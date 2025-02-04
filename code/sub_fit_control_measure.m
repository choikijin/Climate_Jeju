global Conparam_1 Conparam_2 CR_mu3 CR_mu4  
duration = [3 6 13 20];
duration2 = [1.04 1.5 2 3 4 8];
duration1 = linspace(1,30,100);
S1 = [59.4 46.6 26.8 -9.2]*0.01;
S2 = [100 87 73 0 0 0]*0.01;
S3 = [99.5 97.9 97.2 84.1];
Scenarios = {S1, S2};

F = @(x,xdata) x(1)*exp(-x(2)*xdata);
x0 = [1 1];
Scenario_name = ["Mowing" "Spraying acaricides" "Mowing+Acaricides"];
Scenario_name1 = ["CR_1" "CR_2"];

for temp_num=1:2
    if temp_num == 2
        x1 = lsqcurvefit(F,x0,duration2,Scenarios{temp_num});
        control_rate = F(x1,duration1);
    else
        x2 = lsqcurvefit(F,x0,duration,Scenarios{temp_num});
        control_rate = F(x2,duration1);
    end

    for i=1:numel(control_rate)
        if control_rate(i)<=0
            control_rate(i)=0;
        end
    end
    if temp_num == 1
        for j = 1:numel(duration)
            Conparam_1 = control_rate;
        end
    else
        for j = 1:numel(duration)
            Conparam_2 = control_rate;
        end
        for kkkk = 1:numel(Conparam_2)
            if Conparam_2(kkkk) >= 1
                Conparam_2(kkkk) = 1;
            end
        end
    end
end