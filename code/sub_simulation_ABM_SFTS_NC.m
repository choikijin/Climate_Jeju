function [f1] = sub_simulation_ABM_SFTS_NC(sfts_inc, pdP)
global agegroup base_death_prob base_severe_prob
Total_cost = zeros(1,numel(sfts_inc));
medical_cost = zeros(1,numel(sfts_inc));
wage_loss = zeros(1,numel(sfts_inc));
MP_1 = zeros(numel(sfts_inc), numel(agegroup));
SP_1 = zeros(numel(sfts_inc), numel(agegroup));
DP_1 = zeros(numel(sfts_inc), numel(agegroup));
for agent = 1:numel(sfts_inc) % Depend on SSP Scenario
    sfts_mild = zeros(1,sfts_inc(agent));
    sfts_severe = zeros(1,sfts_inc(agent));
    sfts_death = zeros(1,sfts_inc(agent));
    sfts_age = zeros(1,sfts_inc(agent));
    for i = 1:sfts_inc(agent)
        patient_i = round(random(pdP));
        if patient_i <= 1
            patient_i=1;
        elseif patient_i >= 4
            patient_i=4;
        end
        for age_i = agegroup
            if patient_i == age_i
                sfts_age(i) = patient_i;
                death_prob = rand(1);
                severe_prob = rand(1);
                if severe_prob <= base_severe_prob
                    sfts_severe(i)=1;
                    if death_prob <= base_death_prob(age_i)
                        sfts_death(i)=1;
                    end
                else
                   sfts_mild(i)=1;
                end
            end
        end
    end
    % 70+, 60-69, 40-59, 20-39
    num_mild = [length(find(sfts_mild == 1 & sfts_age == 1)), ...
        length(find(sfts_mild == 1 & sfts_age == 2)), ...
        length(find(sfts_mild == 1 & sfts_age == 3)), ...
        length(find(sfts_mild == 1 & sfts_age == 4))];
    num_severe = [length(find(sfts_severe == 1 & sfts_death ~= 1 & sfts_age == 1)), ...
        length(find(sfts_severe == 1  & sfts_death ~= 1 & sfts_age == 2)),...
        length(find(sfts_severe == 1  & sfts_death ~= 1 & sfts_age == 3)),...
        length(find(sfts_severe == 1  & sfts_death ~= 1 & sfts_age == 4))];
    num_death = [length(find(sfts_severe == 1  & sfts_death == 1 & sfts_age == 1)), ...
        length(find(sfts_severe == 1  & sfts_death == 1 & sfts_age == 2)), ...
        length(find(sfts_severe == 1  & sfts_death == 1 & sfts_age == 3)), ...
        length(find(sfts_severe == 1  & sfts_death == 1 & sfts_age == 4))];
    [f] = sub_calculate_medical_wage_cost(num_mild, num_severe, num_death);
    Total_cost(agent) = f{1};
    medical_cost(agent) = f{2};
    wage_loss(agent) = f{3};
    MP_1(agent, :) = num_mild;
    SP_1(agent, :) = num_severe;
    DP_1(agent, :) = num_death;
end

f1{1} = Total_cost;
f1{2} = medical_cost;
f1{3} = [num_mild; num_severe; num_death];
f1{4} = num_mild;
f1{5} = num_severe;
f1{6} = num_death;
f1{7} = wage_loss;
end