function isMRS = isMRSpectroscopy(info)
    
    [fileType, ~] = classifyDicomFile(info);
    isMRS = contains(fileType, "Spectroscopy");
end
