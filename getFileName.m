function fileName = getFileName(fullPath)
    % Extract filename from full path
    [~, name, ext] = fileparts(fullPath);
    fileName = [name, ext];
end