% Example usage:
directory_name = 'TRFEP'; % Specify the directory path here
fileList = getAllFiles(directory_name);

% Filter files based on patterns and extension.
filteredFiles = filterFiles(fileList, {'ADNI', 'T2'}, '.nii');

% Deface filtered files.
spm_batch_defacing(filteredFiles);


function [] = spm_batch_defacing(file_list)
    for i=1:length(file_list)
        try
            spm_deface(file_list{i});
            disp('Defaced: ');
            disp(file_list{i});

        catch
            disp('--------');
            disp('Error defacing file:');
            disp(file_list{i});
            disp('--------');
        end
    end


end

function fileList = filterFiles(fileList, patterns, extension)
    % Initialize filtered fileList
    filteredFiles = {};
    
    % Iterate through each file in the fileList
    for i = 1:length(fileList)
        % Get the file name
        [~, fileName, fileExt] = fileparts(fileList{i});
        
        % Check if the file extension is .nii
        if strcmpi(fileExt, extension)
            % Check if the file name contains any of the specified patterns
            containsPattern = false;
            for j = 1:length(patterns)
                if containsSubstring(fileName, patterns{j})
                    containsPattern = true;
                    break;
                end
            end

            % If the file name contains any of the specified patterns, add it to the filtered list
            if containsPattern
                filteredFiles = [filteredFiles; fileList{i}];
            end
        end
    end
    
    % Set the filtered fileList
    fileList = filteredFiles;
end

function result = containsSubstring(str, pattern)
    % Check if the string contains the specified pattern
    result = ~isempty(strfind(lower(str), lower(pattern)));
end


function fileList = getAllFiles(dirName)
    % Initialize fileList to store all file paths
    fileList = {};
    
    % Get a list of all files and directories in the specified folder
    files = dir(dirName);
    
    % Iterate through each file or directory
    for i = 1:length(files)
        % Skip '.' and '..' directories
        if strcmp(files(i).name, '.') || strcmp(files(i).name, '..')
            continue;
        end
        
        % If the current item is a directory, recursively call getAllFiles
        if files(i).isdir
            % Get files from subfolder
            subDir = fullfile(dirName, files(i).name);
            % Recursively call getAllFiles
            subFiles = getAllFiles(subDir);
            % Add subFiles to the main fileList
            fileList = [fileList; subFiles];
        else
            % If the current item is a file, add its full path to the fileList
            filePath = fullfile(dirName, files(i).name);
            filePath = [pwd,'\', filePath];
            fileList = [fileList; filePath];
        end
    end
end
