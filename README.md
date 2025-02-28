# Dependency Manager for MATLAB

This MATLAB class provides utility functions to manage and check dependencies required for executing MATLAB scripts. It allows users to:
- Check if required MATLAB toolboxes are installed.
- Identify dependencies of MATLAB files.
- Read and write dependency lists to a file.

## Installation
Simply download and add the class to your MATLAB path:
```matlab
addpath('path/to/DependencyManager');
```

## Usage

### 1. Check if a Dependency is Installed
To check if a MATLAB toolbox is installed:
```matlab
isInstalled = DependencyManager.isDependencyInstalled("Simulink");
```
For multiple dependencies:
```matlab
isInstalled = DependencyManager.isDependencyInstalled(["Aerospace Toolbox", "Curve Fitting Toolbox"]);
```

### 2. Find Dependencies of MATLAB Files
To analyze the dependencies required for executing a file or a set of files:
```matlab
dependencies = DependencyManager.findDependencies("myScript.m");
```
For multiple files:
```matlab
dependencies = DependencyManager.findDependencies(["script1.m", "script2.m"]);
```
Using wildcards to scan folders:
```matlab
dependencies = DependencyManager.findDependencies("myFolder/*.m");
```

### 3. Read Dependencies from a File
If you have a file listing dependencies (created with `writeDependencies`), you can read it:
```matlab
dependencies = DependencyManager.readDependencies("dependencies.txt");
```

### 4. Write Dependencies to a File
To save the list of required dependencies for future reference:
```matlab
DependencyManager.writeDependencies(dependencies, "dependencies.txt");
```

## Example Workflow
```matlab
% Find dependencies of a script
requiredToolboxes = DependencyManager.findDependencies("example.m");

% Check if all required toolboxes are installed
isInstalled = DependencyManager.isDependencyInstalled(requiredToolboxes);

% Save dependencies to a file
DependencyManager.writeDependencies(requiredToolboxes, "dependencies.txt");
```

## License
This project is licensed under the BSD 3-Clause License. See the `LICENSE` file for details.

## Acknowledgments
Modified from [MatlabUtils](https://github.com/CarmVarriale/MatlabUtils) by Carmine Varriale.

