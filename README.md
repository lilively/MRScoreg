
[![DOI](https://img.shields.io/badge/DOI-1https://doi.org/XXXX-C00000?style=for-the-badge)](https://doi.org/10.5281/zenodo.17987686)  [![License: CC BY-NC-ND 4.0 Plus](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0_Plus-C00000?style=for-the-badge)](https://creativecommons.org/licenses/by-nc-nd/4.0)

<h1><img src="MRScoregIcon5_light.png" alt="MRScoreg logo height="60" style="vertical-align: middle;"> MRSPlotter</h1>

<!-- <h1><img src="resources\icon-512x512.png" alt="MRS Plotter Logo" height="150" style="vertical-align: middle;"> </h1> -->
 
# Overview
MRScoreg is a user-friendly software tool designed to facilitate the integration of magnetic resonance spectroscopy (MRS) data with magnetic resonance imaging (MRI). Spatial parameters are extracted from DICOM headers, and a sequence of processing steps generates anatomical image regions corresponding to each voxel.
Full software documentation can be found [here](MRScoreg%20Instructions.pdf).

## Windows Installation

Download the latest release from the GitHub releases page. Extract the contents of the ZIP file to a desired location on your computer. Navigate to the extracted folder and run `MRSPlotter.exe` to launch the application.

[![Download](https://img.shields.io/badge/Download_Latest_Release-C00000?style=for-the-badge)](https://github.com/lilively/mrscoreg/releases/latest)

[
## Installation from Source
The software can also be run from source using Python. Ensure you have Python 3.8 or higher installed. The simplest way to obtain the program is downloading the source code as a ZIP file from this repository and extracting it, or cloning with git.

Clone the repository from GitHub to your local machine:
```bash
git clone https://github.com/lilively/MRSPlotter
```
Navigate to the project directory and run the main script:
```bash
python main.py
```


## Requirements

### System Requirements
- **Operating System:** Windows 10 or 11 (may work on Windows 7/8)
- **RAM:** 4GB minimum, 8GB+ recommended for larger datasets
- **Disk Space:** 200MB minimum
- **Permissions:** Write access for saving plots

### For Python Installation

**Python 3.8+** with the following packages (see [requirements.txt](requirements.txt)):
- PyQt6 >= 6.4.0
- matplotlib >= 3.5.0
- numpy >= 1.21.0
- pandas >= 1.3.0
- regex >= 2022.1.18

Install dependencies:
```bash
pip install -r requirements.txt
```
](url)

