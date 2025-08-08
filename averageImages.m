function averageImages(slicedir,numberOfSlices,outF,outAV,GridEnabled,GridColor,row, col)
files = dir(fullfile(slicedir,'*.png'));
numberOfImages = length(files);

fprintf('   Processing %d images into %d slices\n', numberOfImages, numberOfSlices);

% Step 1: Extract slice numbers and organize
sliceNumbers = zeros(numberOfImages, 1);
caseIDs = cell(numberOfImages, 1);

for k = 1:numberOfImages
    filename = files(k).name;
    parts = strsplit(filename, '-');

    if length(parts) < 3
        warning('Skipping file with unexpected format: %s', filename);
        continue;
    end

    caseIDs{k} = strcat(parts{1}, '-', parts{2});
    sliceNumbers(k) = str2double(extractBefore(parts{3}, '.png'));
end

% Remove invalid entries
validIdx = ~isnan(sliceNumbers);
sliceNumbers = sliceNumbers(validIdx);
caseIDs = caseIDs(validIdx);
files = files(validIdx);
numberOfImages = sum(validIdx);

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
    % caseName = uniqueCases{caseIdx};

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
    filename = files(k).name;
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
        imageInfo = cell(length(sliceFiles), 1);
        for f = 1:length(sliceFiles)
            imageInfo{f} = imfinfo(fullfile(sliceDir, sliceFiles(f).name));
        end
        
        % Filter files for this specific case
        matchIdx = false(length(sliceFiles), 1);
        for f = 1:length(sliceFiles)
            matchIdx(f) = startsWith(sliceFiles(f).name, caseName);
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

            try
                currentImg = double(imread(imgPath));
                [h, w, c] = size(currentImg);

                % Handle different image sizes by padding with zeros
                if h ~= maxHeight || w ~= maxWidth
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

                sumImage = sumImage + currentImg;
                validImageCount = validImageCount + 1;

            catch ME
                warning('Error processing image %s: %s', filteredFiles(img).name, ME.message);
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

        % axis square;
        % title(sprintf('Mean Image - %s %s (%d large images)', caseName, sliceLabels{s}, validImageCount), ...
        %     'FontSize', 16, 'Interpreter', 'none');

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