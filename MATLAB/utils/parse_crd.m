% This script parses the TEG CRD file
% Input: filename - path points to a CRD file;
% Output: S - a struct variable contains parsed data for all samples
function out = parse_crd(filename)
fid = fopen(filename);

tline = fgetl(fid);
attrib_split = string(regexp(tline, '\t', 'split'));
tline = fgetl(fid);

% Parse CRD file
sample_idx = 1;
out = struct();
seq = [];
time_sec = [];
value = [];
while ischar(tline)
    line_check = regexpi(tline, '^\w+', 'match');
    if ~isempty(line_check)
        % if sample_idx == 2
        %     out.Sample1.Seq = seq;
        %     out.Sample1.Time_sec = time_sec;
        %     out.Sample1.Time_min = time_sec/60;
        %     out.Sample1.value = value;
        % end
        sample_attrib_split = string(regexp(tline, '\t', 'split'));
        sample_attrib_split(sample_attrib_split=="") = "NA";
        if sample_idx == 1
            seq = [];
            time_sec = [];
            value = [];
            for ii = 1:length(sample_attrib_split)
                field_name = attrib_split(ii);
                out.Sample1.(field_name) = sample_attrib_split(ii);
            end
        else
            pre_sample_idx = sample_idx - 1;
            pre_sample_name = "Sample"+string(pre_sample_idx);
            out.(pre_sample_name).Seq = seq;
            out.(pre_sample_name).Time_sec = time_sec;
            out.(pre_sample_name).Time_min = time_sec/60;
            out.(pre_sample_name).value = value;

            sample_name = "Sample"+string(sample_idx);
            for ii = 1:length(sample_attrib_split)
                field_name = attrib_split(ii);
                out.(sample_name).(field_name) = sample_attrib_split(ii);
            end
            out.(sample_name).Seq = [];
            out.(sample_name).Time_sec = [];
            out.(sample_name).Time_min = [];
            out.(sample_name).value = [];
            seq = [];
            time_sec = [];
            value = [];
        end
        sample_idx = sample_idx + 1;
    else
        data_split = string(regexp(tline,'[\d.]+','match'));
        data_mat = str2double(data_split);
        seq = [seq; data_mat(1)];
        time_sec = [time_sec; data_mat(2)];
        value = [value; data_mat(3)];
    end
    tline = fgetl(fid);
end

out.(sample_name).Seq = seq;
out.(sample_name).Time_sec = time_sec;
out.(sample_name).Time_min = time_sec/60;
out.(sample_name).value = value;

fclose(fid);