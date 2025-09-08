function isSame = isSameStudyInstanceUID(mriInfo, mrsInfo)
    isSame = false;
    if isfield(mriInfo, 'StudyInstanceUID') && isfield(mrsInfo, 'StudyInstanceUID')
        % fprintf('DEBUG: MRI StudyInstanceUID: %s\n', mriInfo.StudyInstanceUID);
        % fprintf('DEBUG: MRS StudyInstanceUID: %s\n', mrsInfo.StudyInstanceUID);
        if strcmp(mriInfo.StudyInstanceUID, mrsInfo.StudyInstanceUID)
            fprintf('StudyInstanceUID match!\n');
            isSame = true;
            return;
        end
    end

end