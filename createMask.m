%NEW
function maskPath= createMask (dicompath,nii_file,outF)
    nii_file = convertStringsToChars(nii_file);
    [~, fName, ~] = fileparts(dicompath);
    mg = dicominfo(dicompath);

    if isfield(mg, 'PulseSequenceName') && strcmp(mg.PulseSequenceName, 'SPECTROSCOPY')
        paramfile = dicompath;
        mg = dicominfo(paramfile);
    else
        return;
    end
    
    
    pv1074 = double(arrayfun(@(s)s,mg.Private_2001_105f.Item_1.Private_2005_1074)); % MRStackFovAP;(2005,1074)
    pv1076 = double(arrayfun(@(s)s,mg.Private_2001_105f.Item_1.Private_2005_1076)); %MRStackFovRL;(2005,1076)
    pv1075 = double(arrayfun(@(s)s,mg.Private_2001_105f.Item_1.Private_2005_1075)); %MRStackFovFH (2005,1075)
    pv1078 = double(arrayfun(@(s)s,mg.Private_2001_105f.Item_1.Private_2005_1078)); %MRStackOffcentreAP (2005,1078)
    pv107A = double(arrayfun(@(s)s,mg.Private_2001_105f.Item_1.Private_2005_107a)); %MRStackOffcentreRL (2005,107A)
    pv1079 = double(arrayfun(@(s)s,mg.Private_2001_105f.Item_1.Private_2005_1079)); %MRStackOffcentreFH (2005,1079)
    pv1071 = double(arrayfun(@(s)s,mg.Private_2001_105f.Item_1.Private_2005_1071)); %MRStackAngulationAP(2005,1071)
    pv1073 = double(arrayfun(@(s)s,mg.Private_2001_105f.Item_1.Private_2005_1073)); %MRStackAngulationRL(2005,1073)
    pv1072 = double(arrayfun(@(s)s,mg.Private_2001_105f.Item_1.Private_2005_1072)); %MRStackAngulationFH(2005,1072)
    
    
    V=spm_vol(nii_file);
    [MRI,XYZ]=spm_read_vols(V);
     
    
    [~,voxdim] = spm_get_bbox(V,'fv'); 
    voxdim = abs(voxdim)';
    halfpixshift = -voxdim(1:3)/2;
     
    
    %Shift imaging voxel coordinates by half an imaging voxel so that the XYZ matrix
    %tells us the x,y,z coordinates of the MIDDLE of that imaging voxel.
    % halfpixshift = -H.dime.pixdim(1:3).'/2; %Eski kod
    halfpixshift(3) = -halfpixshift(3);
    XYZ=XYZ+repmat(halfpixshift,[1 size(XYZ,2)]);
     
    
     
    
    % get information from SPAR - change later to be read in
    
    %getParametersNii(nii_file, rawdata)
    ap_size = pv1074; %% MRStackFovAP;(2005,1074)
    lr_size = pv1076; %% MRStackFovRL;(2005,1076)
    cc_size = pv1075; %MRStackFovFH (2005,1075)
    
    
    
    ap_off = pv1078; %MRStackOffcentreAP (2005,1078)
    lr_off = pv107A; %MRStackOffcentreRL (2005,107A)
    cc_off = pv1079;  %MRStackOffcentreFH (2005,1079)
    
    
    %[-7.5004 27.4606 -8.2487]mid slab position
    %1 lr
    %2 ap
    %3 cc
     
    rad =0.0175;
     
    
    ap_ang = pv1071; %MRStackAngulationAP(2005,1071)
    lr_ang = pv1073; %MRStackAngulationRL(2005,1073)
    cc_ang= pv1072; %MRStackAngulationFH(2005,1072)
    
    % 
    % ap_ang =6.297132E-002;
    % lr_ang =-9.084825E+000;
    % cc_ang =2.384529E+000;
    
    % 
    % 
    %We need to flip ap and lr axes to match NIFTI convention
    ap_off =-ap_off;
    lr_off =-lr_off;
     
    
     
    
    ap_ang = -ap_ang;
    lr_ang = -lr_ang;
    
    
    
    % define the voxel - use x y z  
    % currently have spar convention that have in AUD voxel - will need to
    % check for everything in future...
    % x - left = positive
    % y - posterior = postive
    % z - superior = positive
    vox_ctr = ...
          [lr_size/2 -ap_size/2 cc_size/2 ;
           -lr_size/2 -ap_size/2 cc_size/2 ;
           -lr_size/2 ap_size/2 cc_size/2 ;
           lr_size/2 ap_size/2 cc_size/2 ;
           -lr_size/2 ap_size/2 -cc_size/2 ;
           lr_size/2 ap_size/2 -cc_size/2 ;
           lr_size/2 -ap_size/2 -cc_size/2 ;
           -lr_size/2 -ap_size/2 -cc_size/2 ];
       
    
    % make rotations on voxel
    rad = pi/180;
    initrot = zeros(3,3);
     
    
    xrot = initrot;
    xrot(1,1) = 1;
    xrot(2,2) = cos(lr_ang *rad);
    xrot(2,3) =-sin(lr_ang*rad);
    xrot(3,2) = sin(lr_ang*rad);
    xrot(3,3) = cos(lr_ang*rad);
     
    
     
    
    yrot = initrot;
    yrot(1,1) = cos(ap_ang*rad);
    yrot(1,3) = sin(ap_ang*rad);
    yrot(2,2) = 1;
    yrot(3,1) = -sin(ap_ang*rad);
    yrot(3,3) = cos(ap_ang*rad);
     
    
     
    
    zrot = initrot;
    zrot(1,1) = cos(cc_ang*rad);
    zrot(1,2) = -sin(cc_ang*rad);
    zrot(2,1) = sin(cc_ang*rad);
    zrot(2,2) = cos(cc_ang*rad);
    zrot(3,3) = 1;
     
    
    % rotate voxel
    vox_rot = xrot*yrot*zrot*vox_ctr.';
     
    
    % calculate corner coordinates relative to xyz origin
    vox_ctr_coor = [lr_off ap_off cc_off]; %I tried to substract midslab position
    vox_ctr_coor = repmat(vox_ctr_coor.', [1,8]);
    vox_corner = vox_rot+vox_ctr_coor;

    ap_coords = vox_corner(2,:);  % Get all AP coordinates
    shared_ap = sum(abs(diff(sort(ap_coords))) < 0.5); 
    
    is_well_aligned = shared_ap >= 3;
    if is_well_aligned
        fprintf('ALIGNED corners\n');
    else  
        fprintf('NOT ALIGNED corners\n');
    end
     
    mask = zeros(1,size(XYZ,2));
    sphere_radius = sqrt((lr_size/2)^2+(ap_size/2)^2+(cc_size/2)^2);
    distance2voxctr=sqrt(sum((XYZ-repmat([lr_off ap_off cc_off].',[1 size(XYZ, 2)])).^2,1));
    sphere_mask = zeros(1, size(XYZ, 2));
    sphere_mask(distance2voxctr<=sphere_radius)=1;
    
    
    mask(sphere_mask==1) = 1;
    XYZ_sphere = XYZ(:,sphere_mask == 1);
     
    
    tri = delaunayn([vox_corner.'; [lr_off ap_off cc_off]]);
    tn = tsearchn([vox_corner.'; [lr_off ap_off cc_off]], tri, XYZ_sphere.');
    isinside = ~isnan(tn);
    mask(sphere_mask==1) = isinside;
    h=mask; 
    
    mask = reshape(mask, V.dim);
    
    f=size(mask);
     
    maskPath = fullfile(outF,strcat(fName, '-mask.nii'));
    maskPath = convertStringsToChars(maskPath);
    
    % V_mask.fname='C:\Users\Lili\Dropbox\Phd\3.FIS-MRS-ML\Images\ITKsnap\220317-1-mask.nii';
    V_mask.fname= maskPath;
    %[MRIFOVMask_file]; %%%
    V_mask.descrip='MRS_Voxel_Mask';
    V_mask.dim=V.dim;
    V_mask.dt=V.dt;
    V_mask.mat=V.mat;
     
    
    V_mask=spm_write_vol(V_mask,mask);
    fprintf('Mask saved to: %s \n', maskPath)
    


end