function isT1 = isT1MRI(info)
    
    [fileType, ~] = classifyDicomFile(info);
    printf('File type returned: "%s"\n', fileType); 
    isT1 = contains(fileType, "MR T1-weighted Image");
end

function isMRS = isMRSpectroscopy(info)
    
    [fileType, ~] = classifyDicomFile(info);
    isMRS = contains(fileType, "Spectroscopy");
end

function isSame = isSameStudyDate(mriInfo, mrsInfo)
    isSame = false;
    if isfield(mriInfo, 'StudyDate') && isfield(mrsInfo, 'StudyDate')
        isSame = strcmp(mriInfo.StudyDate, mrsInfo.StudyDate);
        return;
    end

    if isfield(mriInfo, 'AcquisitionDate') && isfield(mrsInfo, 'AcquisitionDate')
        isSame = strcmp(mriInfo.AcquisitionDate, mrsInfo.AcquisitionDate);
        return;
    end

    if isfield(mriInfo, 'SeriesDate') && isfield(mrsInfo, 'SeriesDate')
        isSame = strcmp(mriInfo.SeriesDate, mrsInfo.SeriesDate);
    end
end