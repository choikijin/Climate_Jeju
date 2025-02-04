close all;
clc;
%% Load data
Env_JJ_temp_data = readtable('environment_province.xlsx','Sheet', 'SSP', 'PreserveVariableNames', true);
Env_JJ_hum_data = readtable('environment_province.xlsx','Sheet', 'SSP_hum', 'PreserveVariableNames', true);

d_date_long = datenum(table2array(Env_JJ_temp_data(:,1)));
timeline = datetime(d_date_long, 'ConvertFrom', 'datenum');
Env_JJ_temp_data = [d_date_long table2array(Env_JJ_temp_data(:,2:end))];
Env_JJ_hum_data = [d_date_long table2array(Env_JJ_hum_data(:,2:end))];
save(sprintf('data_%s.mat','jj_env_temp_long'), 'Env_JJ_temp_data', '-ascii')
save(sprintf('data_%s.mat','jj_env_hum_long'), 'Env_JJ_hum_data', '-ascii')

Env_JJ_temp_yearly_data = readtable('SSP_scenario_yearly.xlsx','Sheet', 'Jeju', 'PreserveVariableNames', true);
Env_JJ_hum_yearly_data = readtable('SSP_scenario_yearly.xlsx','Sheet', 'Jeju_hum', 'PreserveVariableNames', true);

d_date_year = datenum(table2array(Env_JJ_temp_yearly_data(:,1)));
Env_JJ_temp_yearly_data = [d_date_year table2array(Env_JJ_temp_yearly_data(:,2:end))];
Env_JJ_hum_yearly_data = [d_date_year table2array(Env_JJ_hum_yearly_data(:,2:end))];

d_total = load('data_total.mat','-ascii');
d_adult = load('data_province_adult.mat','-ascii');
d_nymph = load('data_province_nymph.mat','-ascii');
d_larvae = load('data_province_larvae.mat','-ascii');
d_jeju_env = load('data_jj_env.mat','-ascii');
d_jeju_env_long = load('data_jj_env_temp_long.mat','-ascii');
d_jeju_hum_long = load('data_jj_env_hum_long.mat','-ascii');
%% 
sub_parameter_simple_tick
global end_time dt init_C mu1 mu2 mu3 mu4 mu5 rho K
global temp_jeju hum_jeju temp_inter hum_inter

D2_ydata = d_larvae(:,15);
D3_ydata = d_nymph(:,15);
D4_ydata = d_adult(:,15);
total_ydata = D2_ydata+D3_ydata+D4_ydata;
end_time=12*5;
dt=0.01;
init_C = [0, 0, 0, 20, 20];
%%
results={};
results{1}=d_date_long;
results_R0={};
results_R0{1}=d_date_long;

for temp_num=2:2
    temp_base_sce = d_jeju_env_long(:,temp_num);
    hum_base_sce = d_jeju_hum_long(:,temp_num);
    if temp_num == 2
        temp_base = d_jeju_env_long(13:24,temp_num);
        hum_base = d_jeju_hum_long(13:24,temp_num);
        temp_base_SSP1 = d_jeju_env_long(13:24,3);
        hum_base_SSP1 = d_jeju_hum_long(13:24,3);
        for i=1:2100-2023+1
            temp_base_sce(25+(i-1)*12:25+(i-1)*12+11)=temp_base;
            hum_base_sce(25+(i-1)*12:25+(i-1)*12+11)=hum_base;
        end
        d_jeju_env_long(:,temp_num)=temp_base_sce;
        d_jeju_hum_long(:,temp_num)=hum_base_sce;
    end

    temp_jeju = d_jeju_env_long(:,temp_num);
    hum_jeju = d_jeju_hum_long(:,temp_num);
    x_ori = (1:numel(temp_jeju));
    x_inter = (x_ori(1):dt:x_ori(end));
    temp_inter = interp1(x_ori,temp_jeju, x_inter);    
    hum_inter = interp1(x_ori,hum_jeju, x_inter);

    d1 =develop_rate2(esti(1),esti(2),esti(3),esti(4),esti(5),esti(6),temp_inter,hum_inter);
    d2 = develop_rate1(esti(7),esti(8),esti(9),temp_inter);
    d3 = develop_rate1(esti(10),esti(11),esti(12),temp_inter);
    d4 = develop_rate1(esti(13),esti(14),esti(15),temp_inter);

    d1_oritemp =develop_rate2(esti(1),esti(2),esti(3),esti(4),esti(5),esti(6),temp_jeju,hum_jeju);
    d2_oritemp = develop_rate1(esti(7),esti(8),esti(9),temp_jeju);
    d3_oritemp = develop_rate1(esti(10),esti(11),esti(12),temp_jeju);
    d4_oritemp = develop_rate1(esti(13),esti(14),esti(15),temp_jeju);

    d1_oritemp = modify_development_rate(d1_oritemp);
    d2_oritemp = modify_development_rate(d2_oritemp);
    d3_oritemp = modify_development_rate(d3_oritemp);
    d4_oritemp = modify_development_rate(d4_oritemp);

    [y_temp_esti_simple] = sub_ode_tick_simulation(esti, x_ori);
    results{temp_num} = sum(y_temp_esti_simple{1,1},2);
end
%% Initial condition in 2030
Jan_2030 = 109;
Dec_2029 = 108;

init_lav_inci = y_temp_esti_simple{4}{1}(Jan_2030);
init_adu_inci = y_temp_esti_simple{4}{3}(Jan_2030)/2;
init_egg_inci = y_temp_esti_simple{4}{3}(Dec_2029)/2;
init_nym_inci = y_temp_esti_simple{4}{2}(Jan_2030);

init_egg = dt*sum(y_temp_esti_simple{2}{2}((Jan_2030-1)/dt+2 : (Jan_2030)/dt+1))/dt;
init_lav = dt*sum(y_temp_esti_simple{2}{3}((Jan_2030-1)/dt+2 : (Jan_2030)/dt+1))/dt;
init_nym = dt*sum(y_temp_esti_simple{2}{4}((Jan_2030-1)/dt+2 : (Jan_2030)/dt+1))/dt;
init_adu = dt*sum(y_temp_esti_simple{2}{5}((Jan_2030-1)/dt+2 : (Jan_2030)/dt+1))/dt;
init_adu_1 = dt*sum(y_temp_esti_simple{2}{6}((Jan_2030-1)/dt+2 : (Jan_2030)/dt+1))/dt;

init_A_inci = [init_egg_inci*rho, init_lav_inci,init_nym_inci,init_adu_inci,init_adu_inci];
init_A = [init_egg, init_lav, init_nym, init_adu, init_adu_1];
%%
Run4_predict_SSP_scenarios2