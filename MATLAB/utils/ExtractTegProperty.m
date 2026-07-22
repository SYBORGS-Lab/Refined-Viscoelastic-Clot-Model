% This script reads the raw TEG txt file and output important TEG
% measurements such as R time, K time, MA, alpha angle, Ly30 and Ly60
function teg_properties = ExtractTegProperty(filename)

% filename = "../../Data/Raw/UF/TEG_results_061924.txt";
fid = fopen(filename);

% Get all column names
header = fgetl(fid);
split_str = string(regexp(header, '\t', 'split'));
col_names = split_str(strlength(split_str)~=0);

% Parse the rest of the file
main_body = [];
next_line = fgetl(fid);
while ischar(next_line)
    split_str = string(regexp(next_line, '\t', 'split'));
    if length(split_str) < length(col_names)
        for i = length(split_str):length(col_names)
            split_str = [split_str, {"error"}];
        end
    end
    split_str = split_str(1:length(col_names));      % Get rid of the last empty string
    split_str(strlength(split_str)==0) = "NA";
    main_body = [main_body; split_str];
    next_line = fgetl(fid);
end

% Create table
teg_properties = array2table(main_body, 'VariableNames', col_names);
end