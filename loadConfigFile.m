function config = loadConfigFile(configPath)
    % Set default path if not provided
    if nargin < 1
        configPath = 'config.txt';
    end
    
    config = struct();
    
    % Create config file if it doesn't exist
    if ~isfile(configPath)
        createDefaultConfigFile(configPath);
        config.success = false;
        config.message = 'Config file created. Please edit config.txt with your paths and restart the application.';
        return;
    end
    
    % Read and parse existing config file
    try
        lines = readlines(configPath);
        
        for i = 1:length(lines)
            line = strip(lines{i});
            
            % Skip empty lines and comments
            if isempty(line) || startsWith(line, '#')
                continue;
            end
            
            % Parse key=value pairs
            if contains(line, '=')
                parts = split(line, '=', 2);
                key = strip(parts{1});
                value = strip(parts{2});
                
                % Remove quotes if present
                if (startsWith(value, '"') && endsWith(value, '"')) || ...
                   (startsWith(value, '''') && endsWith(value, ''''))
                    value = value(2:end-1);
                end
                
                % Store in config structure
                config.(key) = value;
            end
        end
        
        % Validate paths
        config.success = true;
        config.message = 'Configuration loaded successfully.';
        
        % Check required paths
        pathFields = {'ITK'};
        for i = 1:length(pathFields)
            field = pathFields{i};
            if isfield(config, field)
                path = config.(field);
                if ~isfolder(path) && ~isfile(path)
                    config.success = false;
                    config.message = sprintf('%s path does not exist: %s', field, path);
                    break;
                end
            end
        end
        
    catch ME
        config.success = false;
        config.message = sprintf('Error reading config file: %s', ME.message);
    end
end

function createDefaultConfigFile(configPath)
    content = [
        '# Configuration File', newline, ...
        '#', newline, ...
        '# Instructions:', newline, ...
        '# 1. Change the paths below to point to your installations', newline, ...
        '# 2. Use forward slashes (/) or double backslashes (\\)', newline, ...
        '# 3. Save this file and restart the application', newline, ...
        '#', newline, ...
        '# Examples:', newline, ...
        '# ITK=C:/ITK-SNAP 3.8/bin/c3d.exe', newline, ...
        '#', newline, ...
        'ITK=C:\ITK-SNAP 3.8\bin\c3d.exe', newline, ...
    ];
    
    try
        fid = fopen(configPath, 'w');
        if fid == -1
            error('Cannot create config file: %s', configPath);
        end
        fprintf(fid, '%s', content);
        fclose(fid);
        fprintf('Created config file: %s\n', configPath);
        fprintf('Please edit this file with correct paths before running again.\n');
    catch ME
        error('Failed to create config file: %s', ME.message);
    end
end