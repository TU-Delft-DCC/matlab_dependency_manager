classdef DependencyManager
    %DEPENDENCYMANAGER Class to manage MATLAB toolbox dependencies
    %
    % Modified from https://github.com/CarmVarriale/MatlabUtils
    % License under the BSD 3-Clause License
    % 
    % Copyright (c) 2025, Carmine Varriale
    % 
    % Redistribution and use in source and binary forms, with or without
    % modification, are permitted provided that the following conditions are met:
    % 
    % 1. Redistributions of source code must retain the above copyright notice, this
    %    list of conditions and the following disclaimer.
    % 
    % 2. Redistributions in binary form must reproduce the above copyright notice,
    %    this list of conditions and the following disclaimer in the documentation
    %    and/or other materials provided with the distribution.
    % 
    % 3. Neither the name of the copyright holder nor the names of its
    %    contributors may be used to endorse or promote products derived from
    %    this software without specific prior written permission.
    % 
    % THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    % AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    % IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    % DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    % FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    % DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    % SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    % CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    % OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    % OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


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
