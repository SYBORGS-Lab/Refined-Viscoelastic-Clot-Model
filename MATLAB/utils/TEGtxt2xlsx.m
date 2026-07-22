% This scripts parse through the TEG_RawData files and extract TEG
% properties from txt files. If path is a file, then this script will call
% the ExtractTegProperty function to process it. If the given path is a
% folder, then the script will parse all txt file in this folder and then
% extract the TEG properties.
function extracted_properties = TEGtxt2xlsx(path, export)

if nargin == 1
    export = 0;
end

if isfile(path)
    txt_files = path;
elseif isfolder(path)
    addpath(path)
    % Check if files exists
    Path_all = dir(path + "*.*");
    if isempty(Path_all)
        error('No files in this folder!')
    end
    % Convert to string array and delete the first two entries
    files = string({Path_all.name});
    files(1:2) = [];
    % Get all files with '.txt' as the extension 
    txt_files = [];
    for i = 1:length(files)
        exp_txt = '\S*.txt';
        matched_files = regexpi(files(i),exp_txt,'match');
        if ~isempty(matched_files)
            txt_files = [txt_files; path+matched_files];
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:length(txt_files)
    filename = txt_files(i);
    extracted_properties = ExtractTegProperty(filename);
    if export == 1
        writetable(extracted_properties,'TEG_Info.xlsx','Sheet',txt_files(i));
    end
end
