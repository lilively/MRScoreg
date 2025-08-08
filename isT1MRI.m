function isT1 = isT1MRI(info)
    [fileType, ~] = classifyDicomFile(info);
    isT1 = contains(fileType, "MR T1-weighted Image");
end