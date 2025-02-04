function [f] = sub_ode_tick_simple_control_monthly_FM(parameter, xdata, month_list, control_list)

global dt init_C init_C_inci
global mu1 mu2 mu3 mu4 mu5 rho temp_inter hum_inter develop_rate1 develop_rate2
global a Conparam_1 Conparam_2 CR_mu2 CR_mu4 K

mn = numel(xdata);
sz=round((mn-1)/dt);

param1 = parameter(1);
param1_1 = parameter(2);
param1_2 = parameter(3);
param1_3 = parameter(4);
param1_4 = parameter(5);
param1_5 = parameter(6);
param2 = parameter(7);
param2_1 = parameter(8);
param2_2 = parameter(9);
param3 = parameter(10);
param3_1 = parameter(11);
param3_2 = parameter(12);
param4 = parameter(13);
param4_1 = parameter(14);
param4_2 = parameter(15);

d1 = develop_rate2(param1, param1_1,param1_2, param1_3, param1_4, param1_5,temp_inter, hum_inter);
d2 = develop_rate1(param2, param2_1,param2_2, temp_inter);
d3 = develop_rate1(param3, param3_1,param3_2, temp_inter);
d4 = develop_rate1(param4, param4_1,param4_2, temp_inter);

d1 = develop_rate_modified(d1);
d2 = develop_rate_modified(d2);
d3 = develop_rate_modified(d3);
d4 = develop_rate_modified(d4);

X1=zeros(1,sz); X2=zeros(1,sz); X3=zeros(1,sz);
X4=zeros(1,sz); X5=zeros(1,sz); Total=zeros(1,sz);
inci_Lar=zeros(1,sz); inci_Lym=zeros(1,sz); inci_Adu=zeros(1,sz);

Final_inci_Lar=zeros(1,mn); Final_inci_Lym=zeros(1,mn); 
Final_inci_Adu=zeros(1,mn); Final_inci_Total=zeros(1,mn);
Final_inci_Lar(1) = init_C_inci(2); Final_inci_Lym(1) = init_C_inci(3);
Final_inci_Adu(1) = init_C_inci(4)+init_C_inci(5); Final_inci_Total(1) = init_C_inci(2)+init_C_inci(3)+init_C_inci(4)+init_C_inci(5); 

d1_sum=zeros(1,mn); d2_sum=zeros(1,mn); d3_sum=zeros(1,mn); Totalsum=zeros(1,mn);
d1_sum(1)=dt*sum(d1(1:100),2); d2_sum(1)=dt*sum(d2(1:100),2); d3_sum(1)=dt*sum(d3(1:100),2); 

X1(1) = init_C(1); X2(1) = init_C(2); X3(1) = init_C(3); 
X4(1) = init_C(4); X5(1) = init_C(5); Total(1) = init_C(2)+init_C(3)+init_C(4)+init_C(5); 

% month that inplemented control measure
m_list = find(month_list==1);

% Control measures are implmented in two months
% Only Mowing
if double([strcmp(control_list,["Mowing" ""])]) == [1 1]
    cr1_idx = 1;
    for fi = 1:sz
        if Total(fi) >= K*dt
                    Total(fi) = K*dt;
        end
        if mod(fix(fi*dt)-m_list(1),12) == 0 || mod(fix(fi*dt)-m_list(2),12) == 0 || mod(fix(fi*dt)-m_list(3),12) == 0 || mod(fix(fi*dt)-m_list(4),12) == 0
            CR1 = Conparam_1(cr1_idx);
            CR2 = 0;
            C_mu2 = mu2*(1+CR2);
            C_mu3 = mu3*(1+CR2*CR_mu2);
            C_mu4 = mu4*(1+CR2*CR_mu4);

            X1(fi+1) = X1(fi) + (d4(fi)*rho*X5(fi) - ((1-CR1)*d1(fi)+mu1)*X1(fi))*dt;
            X2(fi+1) = X2(fi) + ((1-CR1)*d1(fi)*(1-Total(fi)/K)*X1(fi) - ((1-CR1)*d2(fi)+C_mu2)*X2(fi))*dt;
            X3(fi+1) = X3(fi) + ((1-CR1)*d2(fi)*X2(fi) - ((1-CR1)*d3(fi)+C_mu3)*X3(fi))*dt;
            X4(fi+1) = X4(fi) + (a*(1-CR1)*d3(fi)*X3(fi) - C_mu4*X4(fi))*dt;
            X5(fi+1) = X5(fi) + ((1-a)*(1-CR1)*d3(fi)*X3(fi) - (d4(fi)+C_mu4)*X5(fi))*dt;

            Total(fi+1) = X2(fi+1)+X3(fi+1)+X4(fi+1)+X5(fi+1);

            inci_Lar(fi+1) = ((1-CR1)*d1(fi)*(1-Total(fi)/K)*X1(fi))*dt;
            inci_Lym(fi+1) = ((1-CR1)*d2(fi)*X2(fi))*dt;
            inci_Adu(fi+1) = ((1-CR1)*d3(fi)*X3(fi))*dt;

            if cr1_idx == 100
                cr1_idx=1;
            else
                cr1_idx=cr1_idx+1;
            end
        else
            CR2 = 0;
            CR1 = 0;
            C_mu2 = mu2*(1+CR2);
            C_mu3 = mu3*(1+CR2*CR_mu2);
            C_mu4 = mu4*(1+CR2*CR_mu4);
            X1(fi+1) = X1(fi) + (d4(fi)*rho*X5(fi) - ((1-CR1)*d1(fi)+mu1)*X1(fi))*dt;
            X2(fi+1) = X2(fi) + ((1-CR1)*d1(fi)*(1-Total(fi)/K)*X1(fi) - ((1-CR1)*d2(fi)+C_mu2)*X2(fi))*dt;
            X3(fi+1) = X3(fi) + ((1-CR1)*d2(fi)*X2(fi) - ((1-CR1)*d3(fi)+C_mu3)*X3(fi))*dt;
            X4(fi+1) = X4(fi) + (a*(1-CR1)*d3(fi)*X3(fi) - C_mu4*X4(fi))*dt;
            X5(fi+1) = X5(fi) + ((1-a)*(1-CR1)*d3(fi)*X3(fi) - (d4(fi)+C_mu4)*X5(fi))*dt;
            
            Total(fi+1) = X2(fi+1)+X3(fi+1)+X4(fi+1)+X5(fi+1);
            
        end
    end
    Totalsum(1) = dt*sum(Total(1:100),2);
    for fj = 1:mn-1
        if mod(fj-m_list(1),12) == 0 || mod(fj-m_list(2),12) == 0 || mod(fj-m_list(3),12) == 0 || mod(fj-m_list(4),12) == 0
            idx_dev = (fj-1)/dt+2;
            for idd = 1:numel(Conparam_1)
                d1(idx_dev) = (1-Conparam_1(idd))*d1(idx_dev);
                d2(idx_dev) = (1-Conparam_1(idd))*d2(idx_dev);
                d3(idx_dev) = (1-Conparam_1(idd))*d3(idx_dev);
                idx_dev=idx_dev+1;
            end
            d1_sum(fj+1) = dt*sum(d1((fj-1)/dt+2 : (fj)/dt+1),2);
            d2_sum(fj+1) = dt*sum(d2((fj-1)/dt+2 : (fj)/dt+1),2);
            d3_sum(fj+1) = dt*sum(d3((fj-1)/dt+2 : (fj)/dt+1),2);
        else
            d1_sum(fj+1) = dt*sum(d1((fj-1)/dt+2 : (fj)/dt+1),2);
            d2_sum(fj+1) = dt*sum(d2((fj-1)/dt+2 : (fj)/dt+1),2);
            d3_sum(fj+1) = dt*sum(d3((fj-1)/dt+2 : (fj)/dt+1),2);
        end
        Final_inci_Lar(fj+1) = dt*(d1_sum(fj)*(1-Totalsum(fj)/K)*sum(X1((fj-1)/dt+2 : (fj)/dt+1)));
        Final_inci_Lym(fj+1) = dt*(d2_sum(fj)*sum(X2((fj-1)/dt+2 : (fj)/dt+1)));
        Final_inci_Adu(fj+1) = dt*(d3_sum(fj)*sum(X3((fj-1)/dt+2 : (fj)/dt+1)));
        Final_inci_Total(fj+1) = Final_inci_Lar(fj+1)+Final_inci_Lym(fj+1)+Final_inci_Adu(fj+1); 
    end

% Only Acaricides
elseif double([strcmp(control_list,["" "Acaricides"])]) == [1 1]
    % cr1_idx = 1;
    cr2_idx = 1;
    for fi = 1:sz
        if Total(fi) >= K*dt
                    Total(fi) = K*dt;
        end
        if mod(fix(fi*dt)-m_list(1),12) == 0 || mod(fix(fi*dt)-m_list(2),12) == 0 || mod(fix(fi*dt)-m_list(3),12) == 0 || mod(fix(fi*dt)-m_list(4),12) == 0
            CR1 = 0;
            CR2 = Conparam_2(cr2_idx);
            C_mu2 = mu2*(1+CR2*CR_mu2);
            if C_mu2 >= 1
                C_mu2 = 1;
            end
            C_mu3 = mu3*(1+CR2);
            C_mu4 = mu4*(1+CR2*CR_mu4);

            X1(fi+1) = X1(fi) + (d4(fi)*rho*X5(fi) - ((1-CR1)*d1(fi)+mu1)*X1(fi))*dt;
            X2(fi+1) = X2(fi) + ((1-CR1)*d1(fi)*(1-Total(fi)/K)*X1(fi) - ((1-CR1)*d2(fi)+C_mu2)*X2(fi))*dt;
            X3(fi+1) = X3(fi) + ((1-CR1)*d2(fi)*X2(fi) - ((1-CR1)*d3(fi)+C_mu3)*X3(fi))*dt;
            X4(fi+1) = X4(fi) + (a*(1-CR1)*d3(fi)*X3(fi) - C_mu4*X4(fi))*dt;
            X5(fi+1) = X5(fi) + ((1-a)*(1-CR1)*d3(fi)*X3(fi) - (d4(fi)+C_mu4)*X5(fi))*dt;

            Total(fi+1) = X2(fi+1)+X3(fi+1)+X4(fi+1)+X5(fi+1);

            if cr2_idx == 100
                cr2_idx=1;
            else
                cr2_idx=cr2_idx+1;
            end
        else
            CR2 = 0;
            CR1 = 0;
            C_mu2 = mu2*(1+CR2);
            C_mu3 = mu3*(1+CR2*CR_mu2);
            C_mu4 = mu4*(1+CR2*CR_mu4);

            X1(fi+1) = X1(fi) + (d4(fi)*rho*X5(fi) - ((1-CR1)*d1(fi)+mu1)*X1(fi))*dt;
            X2(fi+1) = X2(fi) + ((1-CR1)*d1(fi)*(1-Total(fi)/K)*X1(fi) - ((1-CR1)*d2(fi)+C_mu2)*X2(fi))*dt;
            X3(fi+1) = X3(fi) + ((1-CR1)*d2(fi)*X2(fi) - ((1-CR1)*d3(fi)+C_mu3)*X3(fi))*dt;
            X4(fi+1) = X4(fi) + (a*(1-CR1)*d3(fi)*X3(fi) - C_mu4*X4(fi))*dt;
            X5(fi+1) = X5(fi) + ((1-a)*(1-CR1)*d3(fi)*X3(fi) - (d4(fi)+C_mu4)*X5(fi))*dt;

            Total(fi+1) = X2(fi+1)+X3(fi+1)+X4(fi+1)+X5(fi+1);
        end
    end
    Totalsum(1) = dt*sum(Total(1:100),2);
    for fj = 1:mn-1
        if mod(fj-m_list(1),12) == 0 || mod(fj-m_list(2),12) == 0 || mod(fj-m_list(3),12) == 0 || mod(fj-m_list(4),12) == 0
            CR1=0;
            d1_sum(fj+1) = dt*sum((1-CR1)*d1((fj-1)/dt+2 : (fj)/dt+1),2);
            d2_sum(fj+1) = dt*sum((1-CR1)*d2((fj-1)/dt+2 : (fj)/dt+1),2);
            d3_sum(fj+1) = dt*sum((1-CR1)*d3((fj-1)/dt+2 : (fj)/dt+1),2);
        else
            d1_sum(fj+1) = dt*sum(d1((fj-1)/dt+2 : (fj)/dt+1),2);
            d2_sum(fj+1) = dt*sum(d2((fj-1)/dt+2 : (fj)/dt+1),2);
            d3_sum(fj+1) = dt*sum(d3((fj-1)/dt+2 : (fj)/dt+1),2);
        end
        Final_inci_Lar(fj+1) = dt*(d1_sum(fj)*(1-Totalsum(fj)/K)*sum(X1((fj-1)/dt+2 : (fj)/dt+1)));
        Final_inci_Lym(fj+1) = dt*(d2_sum(fj)*sum(X2((fj-1)/dt+2 : (fj)/dt+1)));
        Final_inci_Adu(fj+1) = dt*(d3_sum(fj)*sum(X3((fj-1)/dt+2 : (fj)/dt+1)));
        Final_inci_Total(fj+1) = Final_inci_Lar(fj+1)+Final_inci_Lym(fj+1)+Final_inci_Adu(fj+1); 
    end
% All Control measure
elseif double([strcmp(control_list,["Mowing" "Acaricides"])]) == [1 1]
    cr1_idx = 1;
    cr2_idx = 1;
    for fi = 1:sz
        if Total(fi) >= K*dt
                    Total(fi) = K*dt;
        end
        if mod(fix(fi*dt)-m_list(1),12) == 0 || mod(fix(fi*dt)-m_list(2),12) == 0 || mod(fix(fi*dt)-m_list(3),12) == 0 || mod(fix(fi*dt)-m_list(4),12) == 0
            CR1 = Conparam_1(cr1_idx);
            CR2 = Conparam_2(cr2_idx);
            C_mu2 = mu2*(1+CR2*CR_mu2);
            if C_mu2 >= 1
                C_mu2 = 1;
            end
            C_mu3 = mu3*(1+CR2);
            C_mu4 = mu4*(1+CR2*CR_mu4);

            X1(fi+1) = X1(fi) + (d4(fi)*rho*X5(fi) - ((1-CR1)*d1(fi)+mu1)*X1(fi))*dt;
            X2(fi+1) = X2(fi) + ((1-CR1)*d1(fi)*(1-Total(fi)/K)*X1(fi) - ((1-CR1)*d2(fi)+C_mu2)*X2(fi))*dt;
            X3(fi+1) = X3(fi) + ((1-CR1)*d2(fi)*X2(fi) - ((1-CR1)*d3(fi)+C_mu3)*X3(fi))*dt;
            X4(fi+1) = X4(fi) + (a*(1-CR1)*d3(fi)*X3(fi) - C_mu4*X4(fi))*dt;
            X5(fi+1) = X5(fi) + ((1-a)*(1-CR1)*d3(fi)*X3(fi) - (d4(fi)+C_mu4)*X5(fi))*dt;

            Total(fi+1) = X2(fi+1)+X3(fi+1)+X4(fi+1)+X5(fi+1);

            if cr1_idx == 100
                cr1_idx=1;
                cr2_idx=1;
            else
                cr1_idx=cr1_idx+1;
                cr2_idx=cr2_idx+1;
            end

        else
            CR2 = 0;
            CR1 = 0;
            C_mu2 = mu2*(1+CR2);
            C_mu3 = mu3*(1+CR2*CR_mu2);
            C_mu4 = mu4*(1+CR2*CR_mu4);

            X1(fi+1) = X1(fi) + (d4(fi)*rho*X5(fi) - ((1-CR1)*d1(fi)+mu1)*X1(fi))*dt;
            X2(fi+1) = X2(fi) + ((1-CR1)*d1(fi)*(1-Total(fi)/K)*X1(fi) - ((1-CR1)*d2(fi)+C_mu2)*X2(fi))*dt;
            X3(fi+1) = X3(fi) + ((1-CR1)*d2(fi)*X2(fi) - ((1-CR1)*d3(fi)+C_mu3)*X3(fi))*dt;
            X4(fi+1) = X4(fi) + (a*(1-CR1)*d3(fi)*X3(fi) - C_mu4*X4(fi))*dt;
            X5(fi+1) = X5(fi) + ((1-a)*(1-CR1)*d3(fi)*X3(fi) - (d4(fi)+C_mu4)*X5(fi))*dt;

            Total(fi+1) = X2(fi+1)+X3(fi+1)+X4(fi+1)+X5(fi+1);

        end
    end

    Totalsum(1) = dt*sum(Total(1:100),2);
    
    for fj = 1:mn-1
        if mod(fj-m_list(1),12) == 0 || mod(fj-m_list(2),12) == 0 || mod(fj-m_list(3),12) == 0 || mod(fj-m_list(4),12) == 0
            idx_dev = (fj-1)/dt+2;
            for idd = 1:numel(Conparam_1)
                d1(idx_dev) = (1-Conparam_1(idd))*d1(idx_dev);
                d2(idx_dev) = (1-Conparam_1(idd))*d2(idx_dev);
                d3(idx_dev) = (1-Conparam_1(idd))*d3(idx_dev);
                idx_dev=idx_dev+1;
            end
            d1_sum(fj+1) = dt*sum(d1((fj-1)/dt+2 : (fj)/dt+1),2);
            d2_sum(fj+1) = dt*sum(d2((fj-1)/dt+2 : (fj)/dt+1),2);
            d3_sum(fj+1) = dt*sum(d3((fj-1)/dt+2 : (fj)/dt+1),2);
        else
            d1_sum(fj+1) = dt*sum(d1((fj-1)/dt+2 : (fj)/dt+1),2);
            d2_sum(fj+1) = dt*sum(d2((fj-1)/dt+2 : (fj)/dt+1),2);
            d3_sum(fj+1) = dt*sum(d3((fj-1)/dt+2 : (fj)/dt+1),2);
        end
        Final_inci_Lar(fj+1) = dt*(d1_sum(fj)*(1-Totalsum(fj)/K)*sum(X1((fj-1)/dt+2 : (fj)/dt+1)));
        Final_inci_Lym(fj+1) = dt*(d2_sum(fj)*sum(X2((fj-1)/dt+2 : (fj)/dt+1)));
        Final_inci_Adu(fj+1) = dt*(d3_sum(fj)*sum(X3((fj-1)/dt+2 : (fj)/dt+1)));
        Final_inci_Total(fj+1) = Final_inci_Lar(fj+1)+Final_inci_Lym(fj+1)+Final_inci_Adu(fj+1); 
    end
end

f{1} = [X1(end), X2(end), X3(end), X4(end), X5(end)];
f{2} = {Total', X1', X2', X3', X4', X5'};
f{3} = Final_inci_Total';
f{4} = {Final_inci_Lar', Final_inci_Lym', Final_inci_Adu'};
f{5} = [round(Final_inci_Lar)' round(Final_inci_Lym)' round(Final_inci_Adu)'];
f{6} = [d1' d2' d3' d4'];
end