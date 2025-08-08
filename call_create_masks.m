wd = pwd;
mask_outpt_dir = fullfile(wd,'Masks');
               
if ~exist(mask_outpt_dir, 'dir')
   mkdir(mask_outpt_dir)
end