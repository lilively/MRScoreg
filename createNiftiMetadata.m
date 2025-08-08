function metadata = createNiftiMetadata(filepath)
    [~, filename, ext] = fileparts(filepath);
    
    % Try to load NIfTI header for basic info
    try
        nii = niftiread(filepath);
        info = niftiinfo(filepath);
        
        metadata.Filename = [filename ext];
        metadata.FileModality = 'MR'; 
        metadata.StudyDate = datestr(now, 'yyyymmdd'); 
        metadata.SeriesDescription = filename; % Use filename as series description
        metadata.ImageType = 'ORIGINAL\PRIMARY\OTHER'; % Default image type
        metadata.Rows = info.ImageSize(1);
        metadata.Columns = info.ImageSize(2);
        
        % For 3D volumes, use the third dimension as slices
        if length(info.ImageSize) >= 3
            metadata.Private_2001_1018 = info.ImageSize(3);
        else
            metadata.Private_2001_1018 = 1;
        end
        
        % Try to infer modality from filename
        filename_lower = lower(filename);
        if contains(filename_lower, {'t1', 'mprage', 'spgr'})
            metadata.ImageType = 'ORIGINAL\PRIMARY\T1';
            metadata.FileModality = 'MR';
        elseif contains(filename_lower, {'mrs', 'spec', 'spectro'})
            metadata.FileModality = 'MR';
            metadata.ImageType = 'ORIGINAL\PRIMARY\SPECTROSCOPY';
        end
        
    catch ME
        warning('Could not read NIfTI file %s: %s', filepath, ME.message);
        % Create minimal metadata
        metadata.Filename = [filename ext];
        metadata.FileModality = 'MR';
        metadata.StudyDate = datestr(now, 'yyyymmdd');
        metadata.SeriesDescription = filename;
        metadata.ImageType = 'ORIGINAL\PRIMARY\OTHER';
        metadata.Rows = 256; % Default values
        metadata.Columns = 256;
        metadata.Private_2001_1018 = 1;
    end
en