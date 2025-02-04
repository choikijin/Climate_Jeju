% clear all; 
clc; close all;
%% 
d_total=load('data_total.mat','-ascii');
d_adult=load('data_province_adult.mat','-ascii');
d_nymph=load('data_province_nymph.mat','-ascii');
d_larvae=load('data_province_larvae.mat','-ascii');
d_jeju_env= load('data_jj_env.mat','-ascii');

%%
% close all;
Korea_rate = [0.53 3.23;0.5 2.27;	0.43 1.35;	0.47 1.93;	0.33 1.18];
Jeju_rate = [3.23	2.27	1.35	1.93	1.18];
t = datetime(2017,01,01):calyears(1):datetime(2021,01,01);
plot_color = ["#0072BD", "#D95319", "#EDB120", "#7E2F8E", "#77AC30"];
%%
% clc; close all;
figure(28)
t1 = tiledlayout(4,2,'TileSpacing','Compact','Padding','Compact');

% Incidence rate in Korea and Jeju Island
nexttile([2,1])
bar(t,Korea_rate)
set(gca, 'XTick', t);
datetick('x','yyyy','keeplimits', 'keepticks')
ylabel('SFTS Incidence per 100,000', 'FontSize', 12)
xlabel('Date', 'FontSize', 12)
legend(["Korea" "Jeju" ],'Location','northeast', 'FontSize', 12)
grid on

% Temperature and Humidity
nexttile
lh(1) = plot(d_date,d_jeju_env(:,2),'-s', 'LineWidth', 1.2,'MarkerSize',7,'Color',	"#A2142F");
hold on
set(gca, 'XTick', d_date(1:3:end), 'XTickLabel',[]);
xlim([d_date(1) d_date(end)])
ylim([3 33])
grid on
nexttile
% plot(d_date,d_jeju_env(:,5), '-o', 'LineWidth', 1.2,'MarkerSize',7,'Color','#4169E1')
lh(2) = plot(d_date,d_jeju_env(:,5), '-o', 'LineWidth', 1.2,'MarkerSize',5,'Color',	"#0072BD");
ylim([50 90])
set(gca, 'XTick', d_date(1:3:end));
xlim([d_date(1) d_date(end)])
datetick('x','yyyy-mm','keeplimits', 'keepticks')
xtickangle(90)
grid on
xlabel('Date', 'FontSize', 12)
legend(lh,["Temperature$(^{\circ}C$)", "Relative Humidity(\%)"],'interpreter', 'latex','Location','northoutside', 'FontSize', 12,'fontweight','bold','NumColumns',2)
hold off

% Tick population
nexttile([2, 2])
bar(d_date,[d_larvae(:,15) d_nymph(:,15) d_adult(:,15) ],'Stacked')
ylabel('The number of ticks', 'FontSize', 12)
legend(["Larvae" "Nymphs" "Adults"],'Location','northeast', 'FontSize', 12)
set(gca, 'XTick', d_date(1:3:end));
datetick('x','yyyy-mm','keeplimits', 'keepticks')
xtickangle(90)
xlabel(t1,'Date' ...
    ,'FontSize',12)
grid on
ax = gca;
x0=50;
y0=80;
width=1000;
height=750;
set(gcf,'position',[x0,y0,width,height])

dim = [0.00005 0.993 0.00254545454545454 0.0194610778443114];
str = {'(a)'};
annotation('textbox', dim,'String',str,'LineStyle','none', 'FontSize', 16);

dim1 = [0.48 0.993 0.00254545454545454 0.0194610778443114];
str = {'(b)'};
annotation('textbox', dim1,'String',str,'LineStyle','none', 'FontSize', 16);

dim1 = [0.00005 0.5 0.00254545454545454 0.0194610778443114];
str = {'(c)'};
annotation('textbox', dim1,'String',str,'LineStyle','none', 'FontSize', 16);
%%
write_Fig_300_dpi(28, "Figure1.tif" )