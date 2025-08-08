function niftiFile = convertDicomToNifti(dicomFile, outputPath, c3dPath)

    % Default C3D path - update this to match your installation
    if nargin < 3 || isempty(c3dPath)
        % Common installation paths - the function will try each one
        possiblePaths = {
            'C:\ITK-SNAP 3.8\bin\c3d.exe'  
        };
        
        c3dPath = '';
        for i = 1:length(possiblePaths)
            if exist(possiblePaths{i}, 'file')
                c3dPath = possiblePaths{i};
                break;
            end
        end
        
        if isempty(c3dPath)
            error(['C3D executable not found. Please:\n' ...
                   '1. Install C3D from http://www.itksnap.org/pmwiki/pmwiki.php?n=Downloads.C3D\n' ...
                   '2. Specify the full path to c3d.exe as the third argument\n' ...
                   '3. Or move c3d.exe to one of these locations:\n   %s'], ...
                   strjoin(possiblePaths, '\n   '));
        end
    end
    
    % Validate that C3D executable exists
    if ~exist(c3dPath, 'file')
        error('C3D executable not found at: %s', c3dPath);
    end
    
    % Validate inputs
    if ~exist(dicomFile, 'file')
        error('DICOM file not found: %s', dicomFile);
    end
    
    if ~exist(outputPath, 'dir')
        mkdir(outputPath);
    end
    
    % Get file name without extension
    [~, name, ~] = fileparts(dicomFile);
    
    % Create output NIfTI file path
    niftiFile = fullfile(outputPath, [name '.nii']);
    
    % Build C3D command with full path to executable
    cmd = sprintf('"%s" "%s" -verbose -o "%s"', c3dPath, dicomFile, niftiFile);
    
    % Execute C3D command
    fprintf('Converting DICOM to NIfTI using C3D...\n');
    fprintf('C3D executable: %s\n', c3dPath);
    fprintf('Command: %s\n', cmd);
    
    [status, cmdout] = system(cmd);
    
    % Check if conversion was successful
    if status ~= 0
        error('C3D conversion failed:\n%s\nCommand was: %s', cmdout, cmd);
    end
    
    % Display C3D output
    fprintf('C3D Output:\n%s', cmdout);
    
    % Verify output file was created
    if ~exist(niftiFile, 'file')
        error('NIfTI file was not created: %s', niftiFile);
    end
    
    % Display results using MATLAB's niftiinfo if available
    if exist('niftiinfo', 'file')
        try
            nii_info = niftiinfo(niftiFile);
            fprintf('File created!\n');
            fprintf('   Output file: %s\n', niftiFile);
            fprintf('   Image size: %dx%dx%d\n', nii_info.ImageSize);
            fprintf('   Data type: %s\n', nii_info.Datatype);
            fprintf('   Pixel dimensions: %.2fx%.2fx%.2f mm\n', nii_info.PixelDimensions);
        catch ME
            warning('Could not read NIfTI info: %s', ME.message);
        end
    end
    
    fprintf('Conversion completed successfully!\n');
end

