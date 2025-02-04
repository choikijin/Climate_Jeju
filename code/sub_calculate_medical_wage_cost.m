function [f] = sub_calculate_medical_wage_cost(num_mild, num_severe_live, num_death)

sub_parameter_cost
mild_medical_cost = zeros(1,4); mild_wage_cost = zeros(1,4);
severe_medical_cost = zeros(1,4); severe_wage_cost = zeros(1,4);
death_medical_cost = zeros(1,4); death_wage_cost = zeros(1,4);

for age_group = 1:4
    mild_medical_cost(age_group) = num_mild(age_group)*mean_Mild_cost;
    mild_wage_cost(age_group) = num_mild(age_group)*(daily_income(age_group)*employment_rate(age_group)*10);
    severe_medical_cost(age_group) = num_severe_live(age_group)*mean_TPE_cost;
    severe_wage_cost(age_group) = num_severe_live(age_group)*(daily_income(age_group)*employment_rate(age_group)*10);
    death_medical_cost(age_group) = num_death(age_group)*(mean_TPE_cost);
    death_wage_cost(age_group) = num_death(age_group)*(daily_income(age_group)*employment_rate(age_group)*10);
end

medical_cost = sum(mild_medical_cost)+sum(severe_medical_cost)+sum(death_medical_cost);
wage_cost = sum(mild_wage_cost)+sum(severe_wage_cost)+sum(death_wage_cost);
Total_cost = medical_cost+wage_cost;

f{1} = Total_cost;
f{2} = medical_cost;
f{3} = wage_cost;

end

