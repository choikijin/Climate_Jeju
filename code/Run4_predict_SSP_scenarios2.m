%% Load data
Env_JJ_temp_data = readtable('environment_province.xlsx','Sheet', 'SSP', 'PreserveVariableNames', true);
Env_JJ_hum_data = readtable('environment_province.xlsx','Sheet', 'SSP_hum', 'PreserveVariableNames', true);
d_date_long = datenum(table2array(Env_JJ_temp_data(109:end,1)));
timeline = datetime(d_date_long, 'ConvertFrom', 'datenum');
Env_JJ_temp_data = [d_date_long table2array(Env_JJ_temp_data(109:end,2:end))];
Env_JJ_hum_data = [d_date_long table2array(Env_JJ_hum_data(109:end,2:end))];
save(sprintf('data_%s.mat','jj_env_temp_long'), 'Env_JJ_temp_data', '-ascii')
save(sprintf('data_%s.mat','jj_env_hum_long'), 'Env_JJ_hum_data', '-ascii')

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
global temp_jeju hum_jeju temp_inter hum_inter init_C_inci

D2_ydata = d_larvae(:,15);
D3_ydata = d_nymph(:,15);
D4_ydata = d_adult(:,15);
total_ydata = D2_ydata+D3_ydata+D4_ydata;
end_time=960;
dt=0.01;
%%
init_C = init_A;
init_C_inci = init_A_inci;
results={};
results{1}=d_date_long;
all_result_cell = {};
all_result_stage = cell(4,1);
for temp_num=3:6
    temp_jeju = d_jeju_env_long(:,temp_num);
    hum_jeju = d_jeju_hum_long(:,temp_num);
    x_ori = (1:numel(temp_jeju));
    x_inter = (x_ori(1):dt:x_ori(end));
    temp_inter = interp1(x_ori,temp_jeju, x_inter);    
    hum_inter = interp1(x_ori,hum_jeju, x_inter);    

    [y_temp_esti_simple] = sub_ode_tick_simulation_SSP(esti, x_ori);
    all_result_cell{temp_num} = y_temp_esti_simple;
    results{temp_num} = y_temp_esti_simple{6};
    if temp_num == 3 || temp_num == 4 || temp_num == 5 || temp_num == 6
        all_result_stage{temp_num-2} = y_temp_esti_simple{1};
    end
end
%% yearly data
yearly_results = {};
yearly_results{1}=d_date_long(1:12:end);
for ii=3:6
    ykk=zeros(numel(2030:1:2100),1);
    for jj=1:numel(2030:1:2100)
        ykk(jj)=sum(results{ii}(1+12*(jj-1):12+12*(jj-1)));
    end
    yearly_results{ii}=ykk;
end
%%
cuminc = zeros(4,1);
for temp_num = 3:6
    cucu = cumsum(results{temp_num});
    cuminc(temp_num-2) = round(cucu(end));
end