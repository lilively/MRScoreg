function metadata = getUniversalMetadata(filepath)
    % Get metadata regardless of file type
    fileType = detectFileType(filepath);
    
    if strcmp(fileType, 'dicom')
        try
            metadata = dicominfo(filepath);
        catch ME
            warning('Error reading DICOM metadata from %s: %s', filepath, ME.message);
            metadata = createNiftiMetadata(filepath); % Fallback
        end
    else
        metadata = createNiftiMetadata(filepath);
    end
end
