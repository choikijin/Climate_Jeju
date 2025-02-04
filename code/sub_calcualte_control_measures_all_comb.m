global Conparam_1 Conparam_2 CR_mu3 CR_mu4 
global end_time dt init_C mu1 mu2 mu3 mu4 mu5 rho K 
global temp_jeju hum_jeju temp_inter hum_inter init_C_inci

%%
comb = nchoosek(Imp_mon,implented_num);
combinationlist = comb;
scedata=zeros(numel(combinationlist(:,1)),12);
for imp_num=1:numel(combinationlist(:,1))
    implist = combinationlist(imp_num,:);
    for iiii = implist
        scedata(imp_num,iiii) = 1;
    end
end

Implemented_month = cell(1,numel(combinationlist(:,1)));
for mon = 1:numel(combinationlist(:,1))
     Implemented_month{mon} = combinationlist(mon,:);
end
%%
comb_results = cell(4,1);
for temp_num = 3:6

    temp_base_sce = d_jeju_env_long(:,temp_num);
    hum_base_sce = d_jeju_env_long(:,temp_num);
    temp_jeju = d_jeju_env_long(:,temp_num);
    hum_jeju = d_jeju_hum_long(:,temp_num);
    x_ori = (1:numel(temp_jeju));
    x_inter = (x_ori(1):dt:x_ori(end));
    temp_inter = interp1(x_ori,temp_jeju, x_inter);    
    hum_inter = interp1(x_ori,hum_jeju, x_inter);  

    comb_results{temp_num-2} = {};
    sceidx = 1;
    for imp_idx_2 = Implemented_month
        Monlist = zeros(1,12);
        for kkk = imp_idx_2{1}
                Monlist(kkk) = 1;
        end
        comb_results{temp_num-2}{sceidx} = {};
        for Control = 1:3
            if Control == 1
                Clist = Clist_M;
            elseif Control == 2
                Clist = Clist_A;
            elseif Control == 3
                Clist = Clist_All;
            end

            if implented_num == 2
                [y_control_2] = sub_ode_tick_simple_control_monthly_TM(esti, x_ori, Monlist, Clist);
                comb_results{temp_num-2}{sceidx}{Control} = sum(y_control_2{1,5},2);
            elseif implented_num == 3
                [y_control_2] = sub_ode_tick_simple_control_monthly_ThM(esti, x_ori, Monlist, Clist);
                comb_results{temp_num-2}{sceidx}{Control} = sum(y_control_2{1,5},2);
            elseif implented_num == 4
                [y_control_2] = sub_ode_tick_simple_control_monthly_FM(esti, x_ori, Monlist, Clist);
                comb_results{temp_num-2}{sceidx}{Control} = sum(y_control_2{1,5},2);
            end
        end

        sceidx = sceidx+1;
    end
    
    if implented_num == 2
        comb_TM_data = comb_results;
        scedata_TM = scedata;
    elseif implented_num == 3
        comb_ThM_data = comb_results;
        scedata_ThM = scedata;
    elseif implented_num == 4
        comb_FM_data = comb_results;
        scedata_FM = scedata;
    else
        comb_OM_data = comb_results;
    end
end