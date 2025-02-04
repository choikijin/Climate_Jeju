close all; clc;
%% Load data
d_total=load('data_total.mat','-ascii');
d_adult=load('data_province_adult.mat','-ascii');
d_nymph=load('data_province_nymph.mat','-ascii');
d_larvae=load('data_province_larvae.mat','-ascii');
d_sfts=load('data_sfts.mat','-ascii');
d_jeju_sfts=load('data_sfts_jeju.mat','-ascii');
d_jeju_env= load('data_jj_env.mat','-ascii');
Env_JJ_temp_data = readtable('environment_province.xlsx','Sheet', 'SSP', 'PreserveVariableNames', true);
Env_JJ_hum_data = readtable('environment_province.xlsx','Sheet', 'SSP_hum', 'PreserveVariableNames', true);

Env_JJ_temp_data_SSP = [table2array(Env_JJ_temp_data(:,2:end))];
Env_JJ_hum_data_SSP = [table2array(Env_JJ_hum_data(:,2:end))];

%% 
sub_parameter_simple_0313
global dt init_C a mu1 mu2 mu3 mu4 mu5 rho K temp_inter hum_inter 
global develop_rate1 develop_rate2 temp_jeju hum_jeju fac

dt=0.01;
temp_jeju = d_jeju_env(:,2);
hum_jeju = d_jeju_env(:,5);

x_ori = 1:numel(temp_jeju);
x_inter = x_ori(1):dt:x_ori(end);

temp_inter = interp1(x_ori,temp_jeju, x_inter);
hum_inter = interp1(x_ori,hum_jeju, x_inter);
%%
D2_ydata = d_larvae(:,15);
D3_ydata = d_nymph(:,15);
D4_ydata = d_adult(:,15);
total_ydata = D2_ydata+D3_ydata+D4_ydata;
yearly = zeros(1,5);
for yearidx = 1:5
    yearly(yearidx) = sum(total_ydata((yearidx-1)*12+1:(yearidx-1)*12+11));
end
yearly_mean = mean(yearly);
yearly_mean_2100 = yearly_mean*71;
%% parameter fitting
init_C = [0, 0, 0, 20, 20];
develop_rate1 = @(a0,a1,a2,x) (0.00001)*(a0*x.^2+a1*x+a2);
develop_rate2 = @(a0,a1,a2,a3,a4,a5,x,y) (0.00001)*(a0*x.^2+a1*y.^2+a2*x.*y+a3*x+a4*y+a5);

% Initial condition
num_of_param = 15;
param0 = [0.2700, 0.5080, 0.1340, 0.2700, 0.5080, 0.1340, 0.2700, 0.5080, 0.1340, 0.2700, 0.5080, 0.1340, 0.2700, 0.5080, 0.1340];

[esti, r, residual] = lsqcurvefit(@sub_ode_tick_fit, param0, x_ori, ...
    [cumsum(D2_ydata) cumsum(D3_ydata) cumsum(D4_ydata)],[],[],[],[],[],[],@mycon_0307);
%% temperature-dependent parameter

xxx = [5:1:34];
xxx1 = [5:.1:34];
yyy1 = [50:.1:90];
[X,Y] = meshgrid(xxx1,yyy1);  

d1 =develop_rate2(esti(1),esti(2),esti(3),esti(4),esti(5),esti(6),X,Y);
d2 = develop_rate1(esti(7),esti(8),esti(9),xxx);
d3 = develop_rate1(esti(10),esti(11),esti(12),xxx);
d4 = develop_rate1(esti(13),esti(14),esti(15),xxx);

% max(0, quadratic function)
for k=1:numel(d2)
  if d2(k) <= 0
      d2(k)=0;
  end
   if d3(k) <= 0
    d3(k)=0;
   end
   if d4(k) <= 0
    d4(k)=0;
   end
end

sized1 = size(d1);
for k1 = 1:sized1(1)
    for k2 = 1:sized1(2)
        if d1(k1,k2) <= 0
            d1(k1,k2) = 0;
        end
    end
end
%% 
[y_temp_esti_simple] = sub_ode_tick_simulation(esti, x_ori);
fitted = cumsum(y_temp_esti_simple{6});
real = cumsum(total_ydata);
rmse = sqrt(sum((fitted-real).^2)/numel(real))