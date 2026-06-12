
[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.20662959-C00000?style=for-the-badge)](https://doi.org/10.5281/zenodo.20662959)
<h1><img src="MRScoregIcon5.png" alt="MRScoreg logo" width="50" style="vertical-align: middle;"> MRScoreg</h1>

# Overview

MRScoreg is a user-friendly software tool designed to facilitate the integration of magnetic resonance spectroscopy (MRS) data with magnetic resonance imaging (MRI). Spatial parameters are extracted from DICOM headers, and a sequence of processing steps generates anatomical image regions corresponding to each voxel.
Full software documentation can be found [here](MRScoreg_instructions.pdf).

## Windows Installation

After downloading the latest version from the GitHub releases page, extract the contents and start the application by double-clicking on the `MRScoreg.exe.` The MATLAB Runtime 2025a will be automatically retrieved during the installation process if it is not detected in the system. This component is available free of charge and does not require a MATLAB license. Other setup instructions can be found in the included [MRScoreg Instructions.pdf](MRScoreg%20Instructions.pdf). 

The neccesary MATLAB Runtime version can also be downloaded and installed manually from the [MathWorks website](https://www.mathworks.com/products/compiler/matlab-runtime.html).

SPM12 is required for some processing steps. The neccesary files are included in the download, but if you wish to update or replace them, you can obtain the latest version from the [SPM website](https://www.fil.ion.ucl.ac.uk/spm/software/spm12/).

ITK SNAP Convert3D is used for creating NiFti images from DICOM files. The required files are included in the download, but if you wish to update or replace them, you can obtain the latest version from the [ITK SNAP website](https://www.itksnap.org/pmwiki/pmwiki.php?n=Downloads.C3D).


[![Download](https://img.shields.io/badge/Download_Latest_Release-C00000?style=for-the-badge)](https://github.com/lilively/mrscoreg/releases/latest)



## Installation from Source
The software can also be run from MATLAB 2025a or later, with the required toolboxes (Image Processing, Statistics and Machine Learning). 

Clone the repository from GitHub to your local machine:
```bash
git clone https://github.com/lilively/mrscoreg.git
```

Open the MRScoreg.mlapp file using MATLAB App Designer in MATLAB. 

Make sure that ITK SNAP Convert3D ius installed and added to the MATLAB path. You can download  ITK SNAP Convert3D from [here](https://www.itksnap.org/pmwiki/pmwiki.php?n=Downloads.C3D).
