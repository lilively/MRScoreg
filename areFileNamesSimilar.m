
function similar = areFileNamesSimilar(name1, name2)
    [~, n1, ~] = fileparts(name1);
    [~, n2, ~] = fileparts(name2);
    
    % Extract the case number part (everything before the last dash)
    parts1 = split(n1, '-');
    parts2 = split(n2, '-');
    
    if length(parts1) >= 1 && length(parts2) >= 1
        % Compare the case part (e.g., "Case70")
        similar = strcmp(parts1{1}, parts2{1});
    else
        % Fallback: check if names start with same prefix
        similar = startsWith(n1, n2(1:min(5, length(n2)))) || ...
                  startsWith(n2, n1(1:min(5, length(n1))));
    end
end

function fileName = getFileName(fullPath)
    [~, name, ext] = fileparts(fullPath);
    fileName = [name, ext];
end