classdef TestDependencyManager < matlab.unittest.TestCase
    % Test suite for DependencyManager class
    
    properties
        tempFile % Temporary file for testing writeDependencies and readDependencies
    end
    
    methods (TestMethodSetup)
        function createTempFile(testCase)
            % Create a temporary file for testing read/write functions
            testCase.tempFile = 'deps.txt';
        end
    end

    methods (TestMethodTeardown)
        function deleteTempFile(testCase)
            % Clean up temporary file
            if exist(testCase.tempFile, 'file')
                delete(testCase.tempFile);
            end
        end
    end
    
    methods (Test)
        function testIsDependencyInstalledSingle(testCase)
            % Test checking a single installed MATLAB product
            testCase.verifyTrue(DependencyManager.isDependencyInstalled("MATLAB"));
        end

        function testIsDependencyInstalledMultiple(testCase)
            % Test checking multiple installed MATLAB products
            testCase.verifyEqual(...
                DependencyManager.isDependencyInstalled(["MATLAB", "Simulink"]), ...
                [true; true] ...
            ); % Simulink might not be installed
        end
        
        function testIsDependencyInstalledNonExistent(testCase)
            % Test a non-existent toolbox
            testCase.verifyFalse(DependencyManager.isDependencyInstalled("Fake Toolbox"));
        end
        
        function testFindDependenciesValidFile(testCase)
            % Test dependency detection for a valid file
            mFile = which("ver"); % MATLAB's built-in function, should exist
            names = DependencyManager.findDependencies(mFile);
            testCase.verifyNotEmpty(names); % It should return dependencies
        end
        
        function testFindDependenciesEmptyFileList(testCase)
            % Test handling of empty input
            testCase.verifyEmpty(DependencyManager.findDependencies(string.empty));
        end

        function testFindDependenciesInvalidFile(testCase)
            % Test with a non-existing file
            testCase.verifyEmpty(DependencyManager.findDependencies("nonexistent.m"));
        end

        function testWriteDependenciesValid(testCase)
            % Test writing dependencies to a file
            exitFlag = DependencyManager.writeDependencies(["MATLAB", "Simulink"], testCase.tempFile);
            testCase.verifyTrue(exitFlag);
            testCase.verifyTrue(exist(testCase.tempFile, "file") > 0);
        end
        
        function testWriteDependenciesInvalidFile(testCase)
            % Test handling of invalid file path
            testCase.verifyError(@() DependencyManager.writeDependencies("MATLAB", ""), ...
                                 "DependencyManager:FileError");
        end

        function testReadDependenciesValid(testCase)
            % Write dependencies and then read them
            DependencyManager.writeDependencies(["MATLAB", "Simulink"], testCase.tempFile);
            names = DependencyManager.readDependencies(testCase.tempFile);
            testCase.verifyEqual(names, ["MATLAB"; "Simulink"]);
        end

        function testReadDependenciesNonExistent(testCase)
            % Test reading from a non-existent file
            testCase.verifyError(@() DependencyManager.readDependencies("fake_file.txt"), ...
                                 "DependencyManager:FileError");
        end
    end
end
