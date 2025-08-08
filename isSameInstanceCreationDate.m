function isSame = isSameInstanceCreationDate(mriInfo, mrsInfo)
    isSame = false;
    % if isfield(mriInfo, 'StudyDate') && isfield(mrsInfo, 'StudyDate')
    %     isSame = strcmp(mriInfo.StudyDate, mrsInfo.StudyDate);
    %     return;
    % end
    % Check AcquisitionDate
    % if isfield(mriInfo, 'AcquisitionDate') && isfield(mrsInfo, 'AcquisitionDate')
    %     isSame = strcmp(mriInfo.AcquisitionDate, mrsInfo.AcquisitionDate);
    %     return;
    % end
    % 
    % Fallback to InstanceCreationDate
    if isfield(mriInfo, 'InstanceCreationDate') && isfield(mrsInfo, 'InstanceCreationDate')
        isSame = strcmp(mriInfo.InstanceCreationDate, mrsInfo.InstanceCreationDate);
        return;
    end

    % if isfield(mriInfo, 'SeriesDate') && isfield(mrsInfo, 'SeriesDate')
    %     isSame = strcmp(mriInfo.SeriesDate, mrsInfo.SeriesDate);
    % end
end