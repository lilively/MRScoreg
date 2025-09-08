function matches = findDicomMatches(mriFiles, mriMetadata, mrsFiles, mrsMetadata)
    matches = {};
    matchCount = 0;
    
    % Validate inputs
    if isempty(mriFiles) || isempty(mrsFiles)
        warning('Empty file lists provided');
        return;
    end
    if isempty(mriMetadata)
        warning('No MRI metadata available. Please load MRI files first.');
        return;
    end
    if isempty(mrsMetadata)
        warning('No MRS metadata available. Please load MRS files first.');
        return;
    end
    
    fprintf('%s\n', repmat('-', 1, 30));
    disp('Starting matching....');
    fprintf('%s\n', repmat('-', 1, 30));
    
    % Both metadata sets are now available from app properties - no need to read files again!
    fprintf('Using pre-loaded metadata for both MRI and MRS files...\n');
    
    % Find matches based on StudyInstanceUID only
    fprintf('Matching files based on StudyInstanceUID ...\n');
    
    for i = 1:length(mriMetadata)
        if isempty(mriMetadata{i})
            continue;
        end
        
        fprintf('%s\n', repmat('-', 1, 30));
        mriFileName = getFileName(mriFiles{i});
        fprintf('Looking for match for MRI: %s\n', mriFileName);
        
        bestMatch = -1;
        
        for j = 1:length(mrsMetadata)
            if isempty(mrsMetadata{j})
                continue;
            end
            
            % Check StudyInstanceUID only
            if isSameStudyInstanceUID(mriMetadata{i}, mrsMetadata{j})
                fprintf(' StudyInstanceUID match - confirmed!\n');
                bestMatch = j;
                break;
            else
                % fprintf(' StudyInstanceUIDs do not match - skipping\n');
                [~, filename, ext] = fileparts(mrsFiles{j});
                fprintf(' StudyInstanceUIDs do not match - skipping %s\n', filename);
            end
        end
        
        if bestMatch > 0
            matchCount = matchCount + 1;
            matches{matchCount, 1} = mriFileName;
            matches{matchCount, 2} = getFileName(mrsFiles{bestMatch});
            matches{matchCount, 3} = ' ';
        else
            fprintf('%s\n', repmat('-', 1, 30));
            fprintf('No match found for: %s\n', mriFileName);
        end
    end
    
    fprintf('%s\n', repmat('-', 1, 30));
    fprintf('Found %d matching pairs\n', matchCount);
end