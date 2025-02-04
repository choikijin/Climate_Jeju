function [f] = sub_ode_tick_fit(parameter, xdata)

global dt init_C mu1 mu2 mu3 mu4 mu5 rho K a
global temp_inter develop_rate1 develop_rate2 hum_inter

mn=numel(xdata);
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

for k=1:numel(d2)
  if d2(k) <= 0
      d2(k)=0;
  end
  if d1(k) <= 0
        d1(k)=0;
   end
   if d3(k) <= 0
     d3(k)=0;
   end
   if d4(k) <= 0
        d4(k)=0;
   end
end

X1=zeros(1,sz); X2=zeros(1,sz); X3=zeros(1,sz);
X4=zeros(1,sz); X5=zeros(1,sz); Total=zeros(1,sz);
inci_Lar=zeros(1,sz); inci_Lym=zeros(1,sz); inci_Adu=zeros(1,sz);

Final_inci_Lar=zeros(1,mn); Final_inci_Lym=zeros(1,mn); 
Final_inci_Adu=zeros(1,mn); Final_inci_Total=zeros(1,mn);
Final_inci_Lar(1) = init_C(2); Final_inci_Lym(1) = init_C(3);
Final_inci_Adu(1) = init_C(4)+init_C(5); Final_inci_Total(1) = init_C(2)+init_C(3)+init_C(4)+init_C(5); 

d1_sum=zeros(1,mn); d2_sum=zeros(1,mn); d3_sum=zeros(1,mn); Totalsum=zeros(1,mn);
d1_sum(1)=dt*sum(d1(1:100),2); d2_sum(1)=dt*sum(d2(1:100),2); d3_sum(1)=dt*sum(d3(1:100),2); 

X1(1) = init_C(1); X2(1) = init_C(2); X3(1) = init_C(3); 
X4(1) = init_C(4); X5(1) = init_C(5); Total(1) = init_C(2)+init_C(3)+init_C(4)+init_C(5); 

for fi = 1:sz
    X1(fi+1) = X1(fi) + (d4(fi)*rho*X5(fi) - (d1(fi)+mu1)*X1(fi))*dt;
    X2(fi+1) = X2(fi) + (d1(fi)*(1-Total(fi)/K)*X1(fi) - (d2(fi)+mu2)*X2(fi))*dt;
    X3(fi+1) = X3(fi) + (d2(fi)*X2(fi) - (d3(fi)+mu3)*X3(fi))*dt;
    X4(fi+1) = X4(fi) + (a*d3(fi)*X3(fi) - mu4*X4(fi))*dt;
    X5(fi+1) = X5(fi) + ((1-a)*d3(fi)*X3(fi) - (d4(fi)+mu5)*X5(fi))*dt;

    Total(fi+1) = X2(fi+1)+X3(fi+1)+X4(fi+1)+X5(fi+1);

    inci_Lar(fi+1) = (d1(fi)*(1-Total(fi)/K)*X1(fi))*dt;
    inci_Lym(fi+1) = (d2(fi)*X2(fi))*dt;
    inci_Adu(fi+1) = (d3(fi)*X3(fi))*dt;
    
end
Totalsum(1) = dt*sum(Total(1:100),2);
for fj = 1:mn-1

    d1_sum(fj+1) = sum(d1((fj-1)/dt+2 : (fj)/dt+1));
    d2_sum(fj+1) = sum(d2((fj-1)/dt+2 : (fj)/dt+1));
    d3_sum(fj+1) = sum(d3((fj-1)/dt+2 : (fj)/dt+1));
    Totalsum(fj+1) = sum(Total((fj-1)/dt+2 : (fj)/dt+1));

    Final_inci_Lar(fj+1) = dt*(d1_sum(fj)*(1-Totalsum(fj)/K)*sum(X1((fj-1)/dt+2 : (fj)/dt+1)));
    Final_inci_Lym(fj+1) = dt*(d2_sum(fj)*sum(X2((fj-1)/dt+2 : (fj)/dt+1)));
    Final_inci_Adu(fj+1) = dt*(d3_sum(fj)*sum(X3((fj-1)/dt+2 : (fj)/dt+1)));
    Final_inci_Total(fj+1) = Final_inci_Lar(fj+1)+Final_inci_Lym(fj+1)+Final_inci_Adu(fj+1);
end
f = [cumsum(Final_inci_Lar)' cumsum(Final_inci_Lym)' cumsum(Final_inci_Adu)'];
end