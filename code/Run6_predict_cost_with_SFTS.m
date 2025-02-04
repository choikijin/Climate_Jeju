%% 
sub_distribution_fitting
global agegroup base_death_prob base_severe_prob d_jeju_env_long d_jeju_hum_long
base_death_prob = [24/97, 12/53, 4/38, 0];
base_severe_prob = 0.32;
Total_num_fed = 704;
num_fed = [174, 450, 77+3];
biting_rate = [round(0.6*10^(-3)*30,2), round(0.6*10^(-3)*30,2)*3.1, round(0.6*10^(-3)*30,2)*3.1];
prevalence_rate = [9.6 18.9 17.9 6.7 19.1 7.8 15.1 14.7 15.2 13.6 7.1 5.3]*0.01;
SSP_data = data_SSP;
ABM_iter = 1000;
%%
sfts_all_NC=cell(4,1);
sfts = zeros(1,length(SSP_data));
for i = 1:length(SSP_data)
    data = SSP_data{i};
    sum_ = sub_calculate_SFTS_patients(data, biting_rate, prevalence_rate, i);
    sfts(i)= sum_{1};
    sfts_all_NC{i} = sum_{2};
end

COST_NC = zeros(ABM_iter,numel(sfts));
COST_med_NC = zeros(ABM_iter,numel(sfts));
COST_wage_NC = zeros(ABM_iter,numel(sfts));

num_mild_patients = zeros(ABM_iter,numel(agegroup));
num_severe_patients = zeros(ABM_iter,numel(agegroup));
num_death_patients = zeros(ABM_iter,numel(agegroup));

for iii =1:4 
    for iter = 1:ABM_iter
        [f1] = sub_simulation_ABM_SFTS_NC(sfts(iii), pdP);
        COST_NC(iter,iii) = f1{1};
        COST_med_NC(iter,iii) = f1{2};
        COST_wage_NC(iter,iii) = f1{7};
        num_mild_patients(iter,:) = f1{4};
        num_severe_patients(iter,:) = f1{5};
        num_death_patients(iter,:) = f1{6};
    end
    
    if iii == 1
        num_mild_patients_1 = num_mild_patients;
        num_severe_patients_1 = num_severe_patients;
        num_death_patients_1 = num_death_patients;
    elseif iii == 2
        num_mild_patients_2 = num_mild_patients;
        num_severe_patients_2 = num_severe_patients;
        num_death_patients_2 = num_death_patients;
    elseif iii == 3
        num_mild_patients_3 = num_mild_patients;
        num_severe_patients_3 = num_severe_patients;
        num_death_patients_3 = num_death_patients;
    else
        num_mild_patients_5 = num_mild_patients;
        num_severe_patients_5 = num_severe_patients;
        num_death_patients_5 = num_death_patients;
    end
end
mean_COST = mean(COST_NC);
mean_med_COST = mean(COST_med_NC);
mean_wage_COST = mean(COST_wage_NC);

NC_SFTS_final_SSP1 = {num_mild_patients_1, num_severe_patients_1, num_death_patients_1};
NC_SFTS_final_SSP2 = {num_mild_patients_2, num_severe_patients_2, num_death_patients_2};
NC_SFTS_final_SSP3 = {num_mild_patients_3, num_severe_patients_3, num_death_patients_3};
NC_SFTS_final_SSP5 = {num_mild_patients_5, num_severe_patients_5, num_death_patients_5};
NC_cost_final = {mean_COST, mean_med_COST, mean_wage_COST};
%% 
SSP1_data = {SSP1_OM, SSP1_TM, SSP1_ThM, SSP1_FM};
SSP2_data = {SSP2_OM, SSP2_TM, SSP2_ThM, SSP2_FM};
SSP3_data = {SSP3_OM, SSP3_TM, SSP3_ThM, SSP3_FM};
SSP5_data = {SSP5_OM, SSP5_TM, SSP5_ThM, SSP5_FM};
%%
SSP1_results = sub_calculate_COST_SFTS_ABM(SSP1_data, ABM_iter, pdP, biting_rate, prevalence_rate,1);
SSP2_results = sub_calculate_COST_SFTS_ABM(SSP2_data, ABM_iter, pdP, biting_rate, prevalence_rate,2);
SSP3_results = sub_calculate_COST_SFTS_ABM(SSP3_data, ABM_iter, pdP, biting_rate, prevalence_rate,3);
SSP5_results = sub_calculate_COST_SFTS_ABM(SSP5_data, ABM_iter, pdP, biting_rate, prevalence_rate,4);
%% Final cost
SSP1_cost_final = sub_calculate_total_cost(SSP1_results{1});
SSP2_cost_final = sub_calculate_total_cost(SSP2_results{1});
SSP3_cost_final = sub_calculate_total_cost(SSP3_results{1});
SSP5_cost_final = sub_calculate_total_cost(SSP5_results{1});
%%
NC_SFTSdatacell = {NC_SFTS_final_SSP1, NC_SFTS_final_SSP2, NC_SFTS_final_SSP3, NC_SFTS_final_SSP5};
SFTSdatacell = {SSP1_results, SSP2_results, SSP3_results, SSP5_results};
%%
Alldatalist={SSP1_data, SSP2_data, SSP3_data, SSP5_data};
for dataidx = 1:4
    SSPNEW = zeros(4,3);
    for monidx = 1:4
        for CR = 1:3
            Alldatalist{dataidx}{monidx}{CR};
            sumeach = cumsum(Alldatalist{dataidx}{monidx}{CR});
            cumsumeach = sum(sumeach(end,:));
            SSPNEW(monidx, CR) = cumsumeach(end);
        end
    end
    if dataidx == 1
        SSP1_data_NEW = SSPNEW;
    elseif dataidx == 2
        SSP2_data_NEW = SSPNEW;
    elseif dataidx == 3
        SSP3_data_NEW = SSPNEW;
    else
        SSP5_data_NEW = SSPNEW;
    end
end