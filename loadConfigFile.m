function config = loadConfigFile(configPath)
    config = struct();
    
    if ~isfile(configPath)
        config.success = false;
        config.message = 'Configuration file not found.';
        return;
    end
    
    try
        % Read the config file
        fileContent = fileread(configPath);
        lines = strsplit(fileContent, '\n');
        
        for i = 1:length(lines)
            line = strtrim(lines{i});
            if ~isempty(line) && ~startsWith(line, '#')
                if contains(line, '=')
                    % Split on first '=' only
                    equalPos = find(line == '=', 1, 'first');
                    key = strtrim(line(1:equalPos-1));
                    value = strtrim(line(equalPos+1:end));
                    
                    % Remove quotes if present
                    if (startsWith(value, '"') && endsWith(value, '"')) || ...
                       (startsWith(value, '''') && endsWith(value, ''''))
                        value = value(2:end-1);
                    end
                    
                    % Store in config structure
                    config.(key) = value;
                end
            end
        end
        
        % Validate required paths
        config.success = true;
        config.message = 'Configuration loaded successfully.';
        
        % Check paths exist
        pathFields = {'ITK', 'SPM12'};
        for i = 1:length(pathFields)
            field = pathFields{i};
            if isfield(config, field)
                path = config.(field);
                % Check if it's a folder or file
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