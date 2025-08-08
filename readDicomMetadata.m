function metadata = readDicomMetadata(fileList, expectedModality)
    metadata = cell(length(fileList), 1);
    
    for i = 1:length(fileList)
        try
            info = dicominfo(fileList{i});
            
            % Basic validation - but be more flexible about modality
            if isfield(info, 'Modality')
                if strcmp(info.Modality, expectedModality)
                    metadata{i} = info;
                else
                    % Still include it but with warning
                    fprintf('Info: File %s has modality %s (expected %s)\n', ...
                        getFileName(fileList{i}), info.Modality, expectedModality);
                    metadata{i} = info;
                end
            else
                fprintf('Warning: File %s has no Modality field\n', getFileName(fileList{i}));
                metadata{i} = info; % Still include it
            end
            
        catch ME
            fprintf('Warning: Could not read DICOM info from %s: %s\n', ...
                getFileName(fileList{i}), ME.message);
            metadata{i} = [];
        end
    end
end

function fileName = getFileName(fullPath)
    [~, name, ext] = fileparts(fullPath);
    fileName = [name, ext];
end