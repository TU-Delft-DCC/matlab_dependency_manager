classdef DependencyManager
    %DEPENDENCYMANAGER Class to manage MATLAB toolbox dependencies

    methods (Static)
        function exitFlag = isDependencyInstalled(names)
            % Check if MATLAB toolboxes are installed
            arguments (Input)
                names (:,1) string
            end
            arguments (Output)
                exitFlag (:,1) logical
            end
            
            v = ver;
            exitFlag = matches(names, string({v.Name})'); % Transpose for correct shape
        end

        function names = findDependencies(fileList)
            % Returns the MATLAB products necessary to execute the indicated files
            arguments (Input)
                fileList (:,1) string
            end
            arguments (Output)
                names (:,1) string
            end
            
            files = arrayfun(@(x) string({dir(x).name}), fileList, "UniformOutput", false);
            
            % Flatten and remove empty values
            files = string([files{:}]);
            files = files(strlength(files) > 0);

            % Handle empty cases to avoid errors
            if isempty(files)
                names = string.empty;
                return;
            end
            
            namesCell = dependencies.toolboxDependencyAnalysis(files);
            names = string(namesCell)';
        end

        function names = readDependencies(file)
            % Reads the names of required MATLAB products from a text file
            arguments (Input)
                file (1,1) string
            end
            arguments (Output)
                names (:,1) string
            end
            
            fid = fopen(file, "r");
            if fid == -1
                error("DependencyManager:FileError", "Cannot open file: %s", file);
            end

            productList = textscan(fid, "%s", "HeaderLines", 4, "Delimiter", "\n");
            fclose(fid);
            names = string([productList{:}]);
        end

        function exitFlag = writeDependencies(names, file)
            % Writes the MATLAB products necessary to execute the indicated files
            arguments (Input)
                names (:,1) string
                file (1,1) string % Ensure a valid string is provided
            end
            arguments (Output)
                exitFlag (1,1) logical
            end
            
            fid = fopen(fullfile(pwd, file), "w");
            if fid == -1
                error("DependencyManager:FileError", "Cannot open file: %s", file);
            end
            
            try
                fprintf(fid, "MATLAB Version:\n \t%s\n\n", version);
                fprintf(fid, "Dependencies:\n");
                fprintf(fid, "\t%s\n", names);
                exitFlag = fclose(fid) == 0; % True if successfully closed
            catch
                fclose(fid);
                error("DependencyManager:WriteError", "Error writing to file: %s", file);
            end
            
            if exitFlag
                fprintf("Dependencies successfully written to file %s\n", file);
            end
        end
    end
end
