function fullPath = findPathByFilename(filename, pathList)
    % Remove extension from filename if present
    [~, baseFilename, ~] = fileparts(filename);
    
    for i = 1:length(pathList)
        [~, name, ~] = fileparts(pathList{i});
        
        % Compare base names (without extensions)
        if strcmp(name, baseFilename)
            fullPath = pathList{i};
            return;
        end
    end
    
    error('File not found: %s', filename);
end