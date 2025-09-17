function averageImages(slicedir,numberOfSlices,outF,outAV,GridEnabled,GridColor,row, col)

files = dir(fullfile(slicedir,'*.png'));
numberOfImages = length(files);

fprintf('   Processing %d images into %d slices\n', numberOfImages, numberOfSlices);

% Step 1: Extract slice numbers and organize
sliceNumbers = [];
caseIDs = {};
validFiles = {};  % CHANGED: Make this a cell array, not struct array

validCount = 0;
for k = 1:numberOfImages
    filename = files(k).name;  % Get filename from struct
    
    % Remove .png extension first
    [~, nameWithoutExt, ~] = fileparts(filename);
    
    % Find the last occurrence of '-' to split case ID from slice number
    lastDashPos = find(nameWithoutExt == '-', 1, 'last');
    
    if isempty(lastDashPos)
        warning('Skipping file with no dash separator: %s', filename);
        continue;
    end
    
    % Extract case ID and slice number
    caseID = nameWithoutExt(1:lastDashPos-1);
    sliceNumStr = nameWithoutExt(lastDashPos+1:end);
    sliceNum = str2double(sliceNumStr);
    
    % Validate slice number
    if isnan(sliceNum)
        warning('Skipping file with invalid slice number: %s', filename);
        continue;
    end
    
    validCount = validCount + 1;
    caseIDs{validCount} = char(caseID);
    sliceNumbers(validCount) = sliceNum;
    validFiles{validCount} = files(k);  % CHANGED: Store as cell array
end

% Update counts and arrays to only include valid entries
numberOfImages = validCount;

if numberOfImages == 0
    warning('No valid images found in directory: %s', slicedir);
    return;
end

% Step 2: Determine slice boundaries
sortedSliceNumbers = sort(sliceNumbers);
stepSize = (max(sortedSliceNumbers) - min(sortedSliceNumbers)) / numberOfSlices;

sliceBoundaries = min(sortedSliceNumbers) + (0:numberOfSlices) * stepSize;
sliceBoundaries(end) = max(sortedSliceNumbers) + 1; % Ensure last slice includes max

% Create slice labels dynamically
sliceLabels = arrayfun(@(x) sprintf('S%d', x), 1:numberOfSlices, 'UniformOutput', false);

% Step 3: Copy files to organized structure
fprintf('   Separating to slices...\n');
uniqueCases = unique(caseIDs);

for caseIdx = 1:length(uniqueCases)
    % Create case directory
    caseDir = outF;
    if ~exist(caseDir, 'dir')
        mkdir(caseDir);
    end

    % Create slice subdirectories
    for s = 1:numberOfSlices
        sliceDir = fullfile(caseDir, sliceLabels{s});
        if ~exist(sliceDir, 'dir')
            mkdir(sliceDir);
        end
    end
end

% Copy files to appropriate slice directories
for k = 1:numberOfImages
    filename = validFiles{k}.name;  % CHANGED: Access from cell array
    sliceNum = sliceNumbers(k);
    caseName = caseIDs{k};

    % Determine which slice this image belongs to
    sliceIdx = find(sliceNum >= sliceBoundaries(1:end-1) & sliceNum < sliceBoundaries(2:end), 1);
    if isempty(sliceIdx)
        sliceIdx = numberOfSlices; % Put in last slice if beyond boundaries
    end

    % Copy file
    sourcePath = fullfile(slicedir, filename);
    destPath = fullfile(outF, sliceLabels{sliceIdx}, filename);
    copyfile(sourcePath, destPath);
end

%%%%%% NO CHANGES %%%%%%%%%%%
% Step 4: Average images for each case and slice
fprintf('   Averaging images...\n');

for caseIdx = 1:length(uniqueCases)
    caseName = uniqueCases{caseIdx};
    for s = 1:numberOfSlices
        sliceDir = fullfile(outF,sliceLabels{s}); 
        sliceFiles = dir(fullfile(sliceDir, '*.png'));
        
        % Filter files for this specific case
        matchIdx = false(length(sliceFiles), 1);
        for f = 1:length(sliceFiles)
            % Ensure both are character vectors for comparison
            fileName = char(sliceFiles(f).name);
            caseNameChar = char(caseName);
            matchIdx(f) = startsWith(fileName, caseNameChar);
        end
        caseFiles = sliceFiles(matchIdx);
        
        if isempty(caseFiles)
            fprintf('No images found for case %s in %s\n', caseName, sliceDir);
            continue;
        end

        fprintf('   Found %d images for %s/%s\n', length(caseFiles), caseName, sliceLabels{s});
        
        maxHeight = 0;
        maxWidth = 0;
        numChannels = 0;
        imageSizes = [];
        
        for img = 1:length(caseFiles)
            imgPath = fullfile(sliceDir, caseFiles(img).name);
            imgInfo = imfinfo(imgPath);
            imageSizes = [imageSizes; imgInfo.Height, imgInfo.Width];
            maxHeight = max(maxHeight, imgInfo.Height);
            maxWidth = max(maxWidth, imgInfo.Width);
            
            % Read first image to determine number of channels
            if img == 1
                tempImg = imread(imgPath);
                numChannels = size(tempImg, 3);
            end
        end
        
        sizeThreshold = 0.8; % Keep images that are at least 80% of max dimensions
        minHeight = maxHeight * sizeThreshold;
        minWidth = maxWidth * sizeThreshold;
        
        filteredFiles = [];
        for img = 1:length(caseFiles)
            imgHeight = imageSizes(img, 1);
            imgWidth = imageSizes(img, 2);
            
            if imgHeight >= minHeight && imgWidth >= minWidth
                filteredFiles = [filteredFiles; caseFiles(img)];
            else
                fprintf('   Excluding small image: %s (%dx%d, threshold: %.0fx%.0f)\n', ...
                    caseFiles(img).name, imgWidth, imgHeight, minWidth, minHeight);
            end
        end
        
        if isempty(filteredFiles)
            fprintf('   No large enough images found for %s/%s\n', caseName, sliceLabels{s});
            continue;
        end
        
        fprintf('   Averaging %d large images in %s/%s (excluded %d small images)\n', ...
            length(filteredFiles), caseName, sliceLabels{s}, length(caseFiles) - length(filteredFiles));

        % Initialize sum array with maximum dimensions
        sumImage = zeros(maxHeight, maxWidth, numChannels, 'double');
        validImageCount = 0;

        % Process only the filtered (large) images
        for img = 1:length(filteredFiles)
            imgPath = fullfile(sliceDir, filteredFiles(img).name);
            fprintf('   Reading image for averaging: %s\n', filteredFiles(img).name);

            try
                currentImg = imread(imgPath);
                %fprintf('   Image size: %s, class: %s\n', mat2str(size(currentImg)), class(currentImg));
                
                currentImg = double(currentImg);
                [h, w, c] = size(currentImg);
                %fprintf('   After double conversion - size: [%d, %d, %d]\n', h, w, c);

                % Handle different image sizes by padding with zeros
                if h ~= maxHeight || w ~= maxWidth
                    fprintf('   Padding image from [%d, %d] to [%d, %d]\n', h, w, maxHeight, maxWidth);
                    paddedImg = zeros(maxHeight, maxWidth, numChannels, 'double');

                    % Center the image in the padded array
                    hStart = floor((maxHeight - h) / 2) + 1;
                    wStart = floor((maxWidth - w) / 2) + 1;

                    % Ensure we don't exceed array bounds
                    hEnd = min(hStart + h - 1, maxHeight);
                    wEnd = min(wStart + w - 1, maxWidth);
                    hActual = hEnd - hStart + 1;
                    wActual = wEnd - wStart + 1;

                    paddedImg(hStart:hEnd, wStart:wEnd, :) = currentImg(1:hActual, 1:wActual, :);
                    currentImg = paddedImg;
                end

                fprintf('   Adding to sum image...\n');
                sumImage = sumImage + currentImg;
                validImageCount = validImageCount + 1;
                fprintf('   Successfully processed image %d/%d\n', img, length(filteredFiles));

            catch ME
                warning('Error processing image %s: %s', filteredFiles(img).name, ME.message);
                fprintf('   Full error details: %s\n', ME.getReport());
            end
        end

        if validImageCount == 0
            warning('No valid large images found for %s in %s', caseName, sliceDir);
            continue;
        end

        % Calculate average
        avgImage = sumImage / validImageCount;

        % Save averaged image
        figure('Visible', 'off'); % Create invisible figure for faster processing
        imshow(avgImage, []);
        if GridEnabled
            Patchsize = size(avgImage);
            xrange = [0 Patchsize(2)];
            yrange = [0 (Patchsize(1))];

            xg = linspace(xrange(1),xrange(2),row+1);
            yg = linspace(yrange(1),yrange(2),col+1);
            hold on
            color = zeros(col+1,row+1);
            hm = pcolor(xg,yg,color);
            hm.FaceColor = 'none';
            hm.EdgeColor = GridColor;
            hm.LineWidth = 2;
            hm.LineStyle ="-";
        end

        % Create output filename
        outputFilename = sprintf('%s-%s.png', caseName, sliceLabels{s});
        outputPath = fullfile(outAV, outputFilename);

        % Export the figure
        exportgraphics(gcf, outputPath, 'Resolution', 600);
        close(gcf);

        fprintf('   Saved: %s (averaged %d/%d images)\n', outputFilename, validImageCount, length(caseFiles));
    end
end
% fprintf('Processing complete!\n');
end