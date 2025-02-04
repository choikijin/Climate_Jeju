close all;
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
global end_time dt init_C mu1 mu2 mu3 mu4 mu5 rho develop_rate temp_inter hum_inter
global d5 a develop_rate1 temp_jeju K hum_jeju num_change_param
global c_d1 c_d2 c_d3 c_d4 c_mu1 c_mu2 c_mu3 c_mu4 c_mu5 c_temp c_hum

sub_parameter_simple_tick

D2_ydata = d_larvae(:,15);
D3_ydata = d_nymph(:,15);
D4_ydata = d_adult(:,15);
total_ydata = D2_ydata+D3_ydata+D4_ydata;
end_time=852;
dt=1;
num_change_param = 11;
c_range = 0.01; % range of parameter change
ss = 10000; % the number of iterations
crdn=(2*rand(num_change_param,ss)-1)*c_range+1;
Total_SA=zeros(num_change_param,ss);
%%
SA = {};
for temp_num = 3:6
    for kkk = 1:num_change_param
        for jjj = 1:ss
            temp_jeju = d_jeju_env_long(:,temp_num);
            hum_jeju = d_jeju_hum_long(:,temp_num);
            x_ori = (1:numel(temp_jeju));
            x_inter = (x_ori(1):dt:x_ori(end));
            temp_inter = interp1(x_ori,temp_jeju, x_inter);    
            hum_inter = interp1(x_ori,hum_jeju, x_inter);
            if kkk == 1
                c_d1 = crdn(kkk,jjj); c_d2 = 1; c_d3=1; c_d4=1;
                c_mu1 = 1; c_mu2= 1; c_mu3 = 1; c_mu4= 1; c_mu5= 1; c_temp=1; c_hum=1;
            elseif kkk == 2
                c_d1 = 1; c_d2 = crdn(kkk,jjj); c_d3=1; c_d4=1;
                c_mu1 = 1; c_mu2 = 1; c_mu3 = 1; c_mu4 = 1; c_mu5= 1; c_temp=1; c_hum=1;
            elseif kkk == 3
                c_d1 = 1; c_d2 = 1; c_d3=crdn(kkk,jjj); c_d4=1;
                c_mu1 = 1; c_mu2 = 1; c_mu3 = 1; c_mu4 = 1; c_mu5= 1; c_temp=1; c_hum=1;
            elseif kkk == 4
                c_d1 = 1; c_d2 = 1; c_d3=1; c_d4=crdn(kkk,jjj);
                c_mu1 = 1; c_mu2 = 1; c_mu3 = 1; c_mu4 = 1; c_mu5= 1; c_temp=1; c_hum=1; 
            elseif kkk == 5
                c_d1 = 1; c_d2 = 1; c_d3=1; c_d4=1;
                c_mu1 = crdn(kkk,jjj); c_mu2 = 1; c_mu3 = 1; c_mu5= 1; c_mu4 = 1; c_temp=1; c_hum=1;
            elseif kkk == 6
                c_d1 = 1; c_d2 = 1; c_d3=1; c_d4=1;
                c_mu1 = 1; c_mu2 = crdn(kkk,jjj); c_mu3 = 1; c_mu5= 1; c_mu4 = 1; c_temp=1; c_hum=1;
            elseif kkk == 7
                c_d1 = 1; c_d2 = 1; c_d3=1; c_d4=1;
                c_mu1 = 1; c_mu2 = 1; c_mu3 = crdn(kkk,jjj); c_mu5= 1; c_mu4 = 1; c_temp=1; c_hum=1;
            elseif kkk == 8
                c_d1 = 1; c_d2 = 1; c_d3=1; c_d4=1;
                c_mu1 = 1; c_mu2 = 1; c_mu3 = 1; c_mu4 = crdn(kkk,jjj); c_mu5= 1; c_temp=1; c_hum=1;
            elseif kkk == 9
                c_d1 = 1; c_d2 = 1; c_d3=1; c_d4=1;
                c_mu1 = 1; c_mu2 = 1; c_mu3 = 1; c_mu4 = 1; c_mu5 = crdn(kkk,jjj); c_temp=1; c_hum=1;
            elseif kkk == 10
                c_d1 = 1; c_d2 = 1; c_d3=1; c_d4=1;
                c_mu1 = 1; c_mu2 = 1; c_mu3 = 1; c_mu4 = 1; c_mu5= 1; c_temp=crdn(kkk,jjj); c_hum=1;
            else
                c_d1 = 1; c_d2 = 1; c_d3=1; c_d4=1;
                c_mu1 = 1; c_mu2 = 1; c_mu3 = 1; c_mu4 = 1; c_mu5= 1; c_temp=1; c_hum=crdn(kkk,jjj);
            end
            sub_parameter_simple_tick
            fval=sub_ode_SA(esti, x_ori);
            Final_Inc=sum(fval,2);
            cum_inc=cumsum(Final_Inc);
            Total_SA(kkk,jjj)=cum_inc(end);
        end
        p_CI_SA=(diff(Total_SA')')./Total_SA(:,1:ss-1);
        
        p_crdn=(diff(crdn')')./crdn(:,1:ss-1);
        CI_total=p_CI_SA./p_crdn;
    end
    SA{temp_num} = CI_total;
end
%%
SA_SSP3 = zeros(num_change_param, 4);
for iii = 1:num_change_param
    for temp_num=3:6
        SA_SSP3(iii,temp_num-2) = mean(SA{temp_num}(iii,:));
    end
end