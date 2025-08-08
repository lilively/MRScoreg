function setupSPM12(spm12Path)
    % Add SPM12 to MATLAB path if not already there
    if ~exist('spm', 'file')
        if nargin < 1 || isempty(spm12Path)
            error('SPM12 path not provided and SPM12 not found on path');
        end
        
        if ~isfolder(spm12Path)
            error('SPM12 path does not exist: %s', spm12Path);
        end
        
        fprintf('Adding SPM12 to MATLAB path: %s\n', spm12Path);
        addpath(spm12Path);
        
        % Initialize SPM12
        try
            spm('defaults', 'fmri');
            fprintf('SPM12 initialized successfully\n');
        catch ME
            warning('Failed to initialize SPM12: %s', ME.message);
        end
    else
        fprintf('SPM12 already available on path\n');
    end
end