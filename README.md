
# Single Image Object Reconstruction

<div align="center">
    <img src="https://img.shields.io/badge/Version-1.0-4CAF50?style=for-the-badge" alt="Project version">
    <img src="https://img.shields.io/badge/Matlab-3776AB?logo=matlab&logoColor=white&style=for-the-badge" alt="Matlab"> 
</div>

This project explores camera calibration and 3D reconstruction from a single uncalibrated image of a rectangular piece of furniture. The object has one known dimension, while the other two are unknown, and it also contains a visible circle and an unknown horizontal curve. Using geometry from the image, we:
- Detect and use sets of parallel lines to recover vanishing points and the horizon line.

- Rectify the horizontal plane and estimate the missing dimensions of the object.

- Calibrate the camera from visible vertical lines.

- Recover the 3D shape of the furniture, including its height and depth.

- Extract and rectify the unknown horizontal curve.

- Determine the position of the camera with respect to the scene.

## Screenshots

The outcome is a 3D reconstruction of the furniture, complete with real-world dimensions, a rectified version of the curve, and an estimate of the camera pose relative to the scene.

<div align="center">
![Scene](https://github.com/Chri060/iacv-2025-rossi/blob/main/src/images/xy.jpg)
</div>

## Usage

To run this project, you need MATLAB installed on your system. 
Then:

```bash
# Open MATLAB and navigate to the project folder
cd path/to/my-project

# Add project files to MATLAB path
addpath(genpath(pwd))
```
You can now run the scripts directly from the MATLAB command window with: 
```bash
main
```

## Authors

- [Christian Rossi](https://github.com/Chri060)