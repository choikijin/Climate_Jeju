function [f] = sub_calculate_SFTS_patients(data, biting_rate, prevalence_rate, tempidx)
%%
duration_1 = [7:1:14];
S3 = [10 29 32 43 58 68 70 73]*0.01;
maxS3 = max(S3);
minS3 = min(S3);
S4 = (S3-minS3)/(maxS3-minS3);

xx_fit = [-10:1:30];
F1 = @(x,xdata) x(1)./(1+exp(-x(2)*(xdata-x(3))));
x0 = [1 1 10];
x0_1 = [1 1 1];
x2 = lsqcurvefit(F1,x0,duration_1,S3);

d_jeju_env_long = load('data_jj_env_temp_long.mat','-ascii');
sz = size(data);
sfts_patients = zeros(sz(1),sz(2));
all_sfts_rate = zeros(sz(1),sz(2)*2+3);
for stageidx = 1:3
    tempjeju = d_jeju_env_long(:,tempidx+2);
    for monidx = 1:71
        br=biting_rate(stageidx);
        temp = tempjeju((monidx-1)*12+1:(monidx-1)*12+12);
        temp_effect = F1(x2,temp)+0.2220;
        br_new = temp_effect*br;
        sfts_patients((monidx-1)*12+1:(monidx-1)*12+12,stageidx) = round(data((monidx-1)*12+1:(monidx-1)*12+12,stageidx).*br_new.*prevalence_rate');
        all_sfts_rate((monidx-1)*12+1:(monidx-1)*12+12,stageidx) = round(data((monidx-1)*12+1:(monidx-1)*12+12,stageidx).*br_new.*prevalence_rate');
        all_sfts_rate((monidx-1)*12+1:(monidx-1)*12+12,stageidx+3) = data((monidx-1)*12+1:(monidx-1)*12+12,stageidx);
        all_sfts_rate((monidx-1)*12+1:(monidx-1)*12+12,7) = temp_effect;
        all_sfts_rate((monidx-1)*12+1:(monidx-1)*12+12,8) = br_new;
        all_sfts_rate((monidx-1)*12+1:(monidx-1)*12+12,9) = prevalence_rate';
    end
end
all_inc = cumsum(sum(sfts_patients,2));

f{1} = all_inc(end);
f{2} = sfts_patients;
f{3} = all_sfts_rate;
end