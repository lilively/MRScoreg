function [fileType, details] = classifyDicomFile(info)
    try
        % Get key DICOM tags with defaults
        modality = getFieldSafe(info, 'Modality', 'Unknown');
        sopClassUID = getFieldSafe(info, 'SOPClassUID', '');
        pulseSequenceName = getFieldSafe(info, 'PulseSequenceName', '');
        acquisitionContrast = getFieldSafe(info, 'AcquisitionContrast', '');
        imageType = getFieldSafe(info, 'ImageType', {});
        seriesDescription = getFieldSafe(info, 'SeriesDescription', '');
        
        % Convert ImageType to string if it's a cell array
        if iscell(imageType)
            imageTypeStr = strjoin(cellfun(@(x) string(x), imageType, 'UniformOutput', false), '\');
        else
            imageTypeStr = string(imageType);
        end
        
        % Initialize classification
        fileType = "Unknown";
        details = {};
        
        % Check for Spectroscopy (most specific first)
        if (strcmp(upper(pulseSequenceName), 'SPECTROSCOPY') && ...
            strcmp(upper(acquisitionContrast), 'SPECTROSCOPY'))
            fileType = "MR Spectroscopy";
            details{end+1} = sprintf('Pulse Sequence: %s', pulseSequenceName);
            
        % Check for other spectroscopy indicators
        elseif (contains(upper(pulseSequenceName), 'SPECTROSCOPY') || ...
                contains(upper(seriesDescription), 'SPECTROSCOPY') || ...
                contains(upper(seriesDescription), 'SPEC') || ...
                contains(upper(seriesDescription), 'PRESS') || ...
                contains(upper(seriesDescription), 'STEAM') || ...
                contains(upper(seriesDescription), 'SVS') || ...
                contains(upper(seriesDescription), 'CSI'))
            fileType = "MR Spectroscopy";
            details{end+1} = sprintf('Series: %s', seriesDescription);
            
        % Check for MRI sequences
        elseif strcmp(modality, 'MR')
            % Convert ImageType to uppercase string for easier searching
            if iscell(imageType)
                imageTypeUpper = upper(strjoin(cellfun(@(x) string(x), imageType, 'UniformOutput', false), ' '));
            else
                imageTypeUpper = upper(string(imageType));
            end
            seriesUpper = upper(seriesDescription);

            % Check ImageType for sequence information
            if contains(imageTypeUpper, 'LOCALIZER') || contains(imageTypeUpper, 'SCOUT')
                fileType = "MR Localizer Image";
            elseif contains(imageTypeUpper, 'T1') || contains(seriesUpper, 'T1') || ...
               contains(seriesUpper, 'MPRAGE') || contains(seriesUpper, 'SPGR')
                fileType = "MR T1-weighted Image";
            elseif contains(imageTypeUpper, 'T2')
                fileType = "MR T2-weighted Image";
            elseif contains(imageTypeUpper, 'FLAIR')
                fileType = "MR FLAIR Image";
            elseif contains(imageTypeUpper, 'DWI') || contains(imageTypeUpper, 'DIFFUSION')
                fileType = "MR Diffusion Image";
            elseif contains(imageTypeUpper, 'SWI')
                fileType = "MR SWI Image";
            elseif contains(imageTypeUpper, 'PD')
                fileType = "MR Proton Density Image";
            else
                % Fall back to SeriesDescription if ImageType doesn't have sequence info
                if contains(seriesUpper, 'T2')
                    fileType = "MR T2-weighted Image";
                elseif contains(seriesUpper, 'FLAIR')
                    fileType = "MR FLAIR Image";
                elseif contains(seriesUpper, 'DWI') || contains(seriesUpper, 'DIFFUSION')
                    fileType = "MR Diffusion Image";
                elseif contains(seriesUpper, 'SWI')
                    fileType = "MR SWI Image";
                else
                    fileType = sprintf("MR Image (ImageType: %s)", imageTypeStr);
                end
            end
        else
            % Non-MR modalities
            if ~strcmp(modality, 'Unknown')
                fileType = sprintf("%s Image", modality);
            else
                fileType = "DICOM File";
            end
        end
        
        % Add modality to details if not already obvious
        if ~contains(fileType, modality)
            details{end+1} = sprintf('Modality: %s', modality);
        end
        
    catch ME
        fileType = sprintf("Error reading DICOM: %s", ME.message);
        details = {};
    end
end

function value = getFieldSafe(info, fieldName, defaultValue)
    % Safely get field value with default fallback
    if isfield(info, fieldName)
        value = info.(fieldName);
    else
        value = defaultValue;
    end
end