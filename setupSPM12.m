function setupSPM12(spm12Path)
    % Add SPM12 to MATLAB path if not already there    
    % Skip path modification entirely in deployed applications
    if isdeployed
        fprintf('Running in deployed mode - skipping path modification\n');
        if nargin >= 1 && ~isempty(spm12Path)
            fprintf('SPM12 path stored: %s\n', spm12Path);
            setenv('SPM12_PATH', spm12Path);
        end
        return;
    end
    
    if ~exist('spm', 'file')
        if nargin < 1 || isempty(spm12Path)
            error('SPM12 path not provided and SPM12 not found on path');
        end
        if ~isfolder(spm12Path)
            error('SPM12 path does not exist: %s', spm12Path);
        end
        fprintf('Adding SPM12 to MATLAB path: %s\n', spm12Path);
        addpath(spm12Path);
    else
        fprintf('SPM12 already available on path\n');
    end
end