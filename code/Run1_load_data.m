%% Load Data
clear all;
clc;
close all;

sheet_title = {'total', 'province_adult', 'province_nymph', 'province_larvae'};
sheet_name = sprintf('%s',sheet_title{1});
data = readtable('tick_data.xlsx','Sheet', sheet_name, 'PreserveVariableNames', true);
d_date = datenum(table2array(data(:,1)));

%% Tick Data
for i = 1:4
    sheet_name = sprintf('%s',sheet_title{i});
    data = readtable('tick_data.xlsx','Sheet', sheet_name, 'PreserveVariableNames', true);
    data = [d_date table2array(data(:,2:end))];
    save(sprintf('data_%s.mat',sheet_name), 'data', '-ascii')
end
%% Environment Data
Tempdata = readtable('temperature.xlsx','Sheet', 'monthly', 'PreserveVariableNames', true);
Tempdata = [d_date table2array(Tempdata(:,2:end))];
save(sprintf('data_%s.mat','temp'), 'Tempdata', '-ascii')

%% Environment Data Jeju
Env_JJ_data = readtable('environment_province.xlsx','Sheet', 'Jeju', 'PreserveVariableNames', true);
Env_JJ_data = [d_date table2array(Env_JJ_data(:,2:end))];
save(sprintf('data_%s.mat','jj_env'), 'Env_JJ_data', '-ascii')

%%
sprintf('Save complete')