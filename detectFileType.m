function fileType = detectFileType(filepath)
    % Detect if file is DICOM or NIfTI based on extension and content
    [~, ~, ext] = fileparts(filepath);
    
    if strcmpi(ext, '.nii') || strcmpi(ext, '.gz')
        fileType = 'nifti';
    else
        try
            % Try to read as DICOM
            dicominfo(filepath);
            fileType = 'dicom';
        catch
            % If DICOM read fails, assume NIfTI
            fileType = 'nifti';
        end
    end
end