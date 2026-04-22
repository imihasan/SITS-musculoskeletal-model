%% Plot GH-JCF and Ligamnet Lengthening
%This script generates ligament lengthening plots with the different
%testing conditions.
%Author: Ibrahim Mohammed I. Hasan (imihasan@kth.se), Promobilia
%MoveAbility Lab, KTH Royal Institute of Technology, Stokholm, Sweden. 
%Scripted: 2025

        
clear all
results_directory="C:\Users\ibrah\OneDrive - KTH\Paper I\Unilateral\Results\Muscle Redundancy";
save_graphics="C:\Users\ibrah\OneDrive - KTH\Paper I\Unilateral\Graphs";
conditions=["Locked", "Unlocked"];
folders=dir(results_directory);

%% Write .mat files to .txt files
for f=3:length(folders)
    %conditions=dir(fullfile(results_directory,string(folders(f).name)));
    for cond=1:2
        trials=dir(fullfile(results_directory,string(folders(f).name)+"\",conditions(cond),'*.mat'));
        for t=1:length(trials)
            load(fullfile(results_directory,string(folders(f).name)+"\",conditions(cond),trials(t).name));
            [timeN, Lig_N]=normalize(timesExp,lig_ratio');
            [~, Muscles_N]=normalize(timesExp,xsol');
            [~, Magnitude_N]=normalize(timesExp,force_vecc');
            [~, Direction_N]=normalize(timesExp,norm_fv_rotated');
            
            vv=R*Vec_GC2GEE(end,:)';
            radius = norm(vv)*1000;
            Tab = array2table([timeN' Lig_N' Muscles_N' Magnitude_N' Direction_N' radius*ones(length(Direction_N),1)],'VariableNames',["time"; ligaments; muscle_order'; "Fx";"Fy";"Fz"; "Fdx";"Fdy";"Fdz"; "radius"]);
            writetable(Tab, fullfile(results_directory,string(folders(f).name)+"\",conditions(cond),trials(t).name(1:end-4) +".txt"));
            clear Lig_N Muscles_N Magnitude_N Direction_N radius
            fprintf("Writing file: " + string(folders(f).name)+ "_" + conditions(cond) + "_" + string(trials(t).name(1:end-4)) +".txt" +"\n")
        end
    end
    
end


%% Restructure the data and plot timeseries with std shades
close all
testing_conditions="Postures";
subj_weight=[58, 66.8, 70.7, 79, 58.5, 69.7, 75.7, 58.7, 77, 60.5]*9.81;

tasks=["Lateral_Raise_Head", "Front_Raise_Head", "Extension"];
tials_legend=["Lateral Raise", "Anterior Raise", "Posterior Raise"];
ligament_Names=["s_glenohum_r", "m_glenohum_r", "i_glenohum_r", "coracohum_r"];

fig1=figure(1);
fig2=figure(2);
for tr=1:3
    s=1;
    for n=4:length(folders)
        if testing_conditions=="Postures" 
        
            table_cond1=readtable(fullfile(results_directory,string(folders(n).name)+"\","Unlocked\muscle_activations_Upright_"+tasks(tr)+".txt"));
            table_cond2=readtable(fullfile(results_directory,string(folders(n).name)+"\","Unlocked\muscle_activations_Slouching_"+tasks(tr)+".txt"));
            color=[0, 0, 97/255; 130/255 150/255 111/255];
            Legend=["Upright", "Slouched"];
        elseif testing_conditions=="Models"
            table_cond1=readtable(fullfile(results_directory,string(folders(n).name)+"\","Locked\muscle_activations_Slouching_"+tasks(tr)+".txt"));
            table_cond2=readtable(fullfile(results_directory,string(folders(n).name)+"\","Unlocked\muscle_activations_Slouching_"+tasks(tr)+".txt"));
            color=[111 41 125; 232, 174, 0]/255;
            Legend=["Locked", "Unlocked"];

        end
        i_Lig_cond1{tr}(s,:)=table_cond1.i_glenohum_r';
        i_Lig_cond2{tr}(s,:)=table_cond2.i_glenohum_r';
        time=table_cond1.time;

        s_Lig_cond1{tr}(s,:)=table_cond1.s_glenohum_r';
        s_Lig_cond2{tr}(s,:)=table_cond2.s_glenohum_r';

        F1=[table_cond1.Fx'; table_cond1.Fy'; table_cond1.Fz'];
        F2=[table_cond2.Fx'; table_cond2.Fy'; table_cond2.Fz'];

        F_cond1{tr}(s,:)=sqrt(sum(F1.*F1))/subj_weight(s);
        F_cond2{tr}(s,:)=sqrt(sum(F2.*F2))/subj_weight(s);

        x_cond1{tr}(s,:)=-table_cond1.Fdy';
        y_cond1{tr}(s,:)=-table_cond1.Fdz';

        x_cond2{tr}(s,:)=-table_cond2.Fdy';
        y_cond2{tr}(s,:)=-table_cond2.Fdz';

        DelM_cond1{tr}(s,:)=table_cond1.DeltoideusScapula_M;
        DelM_cond2{tr}(s,:)=table_cond2.DeltoideusScapula_M;

        DelP_cond1{tr}(s,:)=table_cond1.DeltoideusScapula_P;
        DelP_cond2{tr}(s,:)=table_cond2.DeltoideusScapula_P;

        DelA_cond1{tr}(s,:)=table_cond1.DeltoideusClavicle_A;
        DelA_cond2{tr}(s,:)=table_cond2.DeltoideusClavicle_A;

        r(s)=mean(table_cond1.radius);

        s=s+1;
    end

    F_bar(:,tr)=[max(F_cond1{tr}')'; max(F_cond2{tr}')'];

    DelM(:,tr)=[mean(DelM_cond1{tr}')'; mean(DelM_cond2{tr}')'];
    DelA(:,tr)=[mean(DelA_cond1{tr}')'; mean(DelA_cond2{tr}')'];
    DelP(:,tr)=[mean(DelP_cond1{tr}')'; mean(DelP_cond2{tr}')'];

    figure(1)
    if tials_legend(tr)== "Lateral Raise"
        subplot(2,3,tr)
        stdevShade(time',mean(i_Lig_cond1{tr}), ... 
            std(i_Lig_cond1{tr}),color(1,:),   0.2)
        hold on
        
        stdevShade(time',mean(i_Lig_cond2{tr}), ... 
            std(i_Lig_cond2{tr}),color(2,:),   0.2)
        title("Inferior Ligament")
        plot(time,ones(1,length(time)),LineStyle="--",LineWidth=1,Color=[120, 0, 26]/255)
        ylim([0.4 1.5])
        xlabel("%Task")
        ylabel("L/L_{o}")
        axis square


    elseif tials_legend(tr)== "Anterior Raise"
        subplot(2,3,tr)
        stdevShade(time',mean(i_Lig_cond1{tr}), ... 
            std(i_Lig_cond1{tr}),color(1,:),   0.2)
        hold on
        
        stdevShade(time',mean(i_Lig_cond2{tr}), ... 
            std(i_Lig_cond2{tr}),color(2,:),   0.2)
        title("Inferior Ligament")
        plot(time,ones(1,length(time)),LineStyle="--",LineWidth=1,Color=[120, 0, 26]/255)
        ylim([0.4 1.5])
        xlabel("%Task")
        axis square

    else
        subplot(2,3,tr)
        stdevShade(time',mean(s_Lig_cond1{tr}), ... 
            std(s_Lig_cond1{tr}),color(1,:),   0.2)
        hold on
        
        stdevShade(time',mean(s_Lig_cond2{tr}), ... 
            std(s_Lig_cond2{tr}),color(2,:),   0.2)
        title("Superior Ligament")
        plot(time,ones(1,length(time)),LineStyle="--",LineWidth=1,Color=[120, 0, 26]/255)
        ylim([0.4 1.5])
        xlabel("%Task")
        axis square

    end

    ax=gca;
    ax.FontSize=10;
    box off
    

    figure(2)
    subplot(2,3,tr)
    stdevShade(time',mean(F_cond1{tr}), ... 
            std(F_cond1{tr}),color(1,:),   0.2)
    hold on
    stdevShade(time',mean(F_cond2{tr}), ... 
            std(F_cond2{tr}),color(2,:),   0.2)
    
    xlabel("% Task")
    ylabel("GH-JCF / BW")
    ax1=gca;
    ax1.FontSize=10;
    title(tials_legend(tr))
    box off
    axis square
    ylim([0 6])

    subplot(2,3,tr+3)
    pp=nsidedpoly(1000, 'Center', [0,0], 'Radius', mean(r)/10);
    hold on
    plot(pp, "FaceColor",'none','LineWidth',1,'LineStyle','--')
    
    scatter(mean(x_cond1{tr})/10, mean(y_cond1{tr})/10,10, color(1,:), 'filled','MarkerFaceAlpha',0.1)
    scatter(mean(x_cond2{tr})/10, mean(y_cond2{tr})/10,10, color(2,:), 'filled','MarkerFaceAlpha',0.1)
    scatter(mean(mean(x_cond1{tr}))/10, mean(mean(y_cond1{tr}))/10,30, color(1,:), 'filled','MarkerEdgeColor','k')
    scatter(mean(mean(x_cond2{tr}))/10, mean(mean(y_cond2{tr}))/10,30, color(2,:), 'filled','MarkerEdgeColor','k')
    scatter(0, 0,40, [0, 0, 0]/255, 'Marker','x',LineWidth=1.5)
    xlabel("X [cm]")
    ylabel("Y [cm]")
    axis square
    ax = gca;
    ax.FontSize = 10;
    ylim([-2 2])
    xlim([-2 2])
    
end

saveas(fig1,fullfile(save_graphics,testing_conditions,append('Ligament_Lengthening_', testing_conditions, '.pdf')))
saveas(fig2,fullfile(save_graphics,testing_conditions,append('GHJCFMagnitude_', testing_conditions, '.pdf')))
% figure
% plot(F_cond1{1}')


%% Plot bar plots of the contact force magnitude

index=[1*ones(10,1); 2*ones(10,1)];
iden=["L Raise"; "A Raise"; "P Raise"];
fig3=figure;
% subplot(1,3,1)
vp = dabarplot(F_bar,'groups',index,'colors',color, 'outliers',0, ... 
     'xtlabels', iden,'scatter',0, 'errorbars',0,...
     'jitter',0,'mean',1, ... 
      'fill', 1,'barwidth',1.5);


ax = gca;
ax.FontSize=16;
range=ax.YLim(2)-ax.YLim(1);
hold on
for tip=1:length(vp.cpos)

    for i=1:10
        plot(vp.gpos(1:2,tip),[F_bar(i,tip); F_bar(i+10,tip)],LineWidth=1,Color=[0 0 0])
        scatter(vp.gpos(1,tip),F_bar(i,tip),40,[0 0 0],"filled","o",'MarkerEdgeColor',[1 1 1])
        scatter(vp.gpos(2,tip),F_bar(i+10,tip),40,[0 0 0],"filled","o",'MarkerEdgeColor',[1 1 1])
    end

    [fl(tip),~] = swtest(F_bar(1:10,tip),0.5); % 0 means normally distrubted
    [fu(tip),~] = swtest(F_bar(11:20,tip),0.5); % 0 means normally distrubted

    %Do Statistical significance test
    if fl(tip) == 0 && fu(tip)== 0
        hn(tip)=ttest(F_bar(1:10,tip),F_bar(11:20,tip)); %Paired t test if data comes from a normal distribution
        % 1 = rejecting the null hypothesis that means are the same
        % (significantly different)
        hu(tip)=0;
    else
        [~,hu(tip)]=signrank(F_bar(1:10,tip),F_bar(11:20,tip)); %Wilcoxon rank sum test if the data is not normally distributed
        hn(tip)=0;
    end

    L=max(F_bar(:,tip));
    p=mean((vp.gpos(:,tip)));
    %Plot a star indicating statistial significance
    if hn(tip)==1 || hu(tip)==1

        
        if L<0
            L=0.2*range;
        end
        
        if hn(tip)==1
            scatter(p,L+0.2*range,100,LineWidth=1.5,Marker="*",MarkerEdgeColor=[120, 0, 26]/255)
            plot(vp.gpos(:,tip), [L+0.1*range L+0.1*range],LineWidth=2,Color=[120, 0, 26]/255)
        elseif hu(tip) ==1
            scatter(p,L+0.2*range,100,'k*',LineWidth=1.5)
            plot(vp.gpos(:,tip), [L+0.1*range L+0.1*range],LineWidth=2,Color='k')
        end

        
    end
    text(p,L+0.3*range,string(round(mean(-F_bar(1:10,tip)+F_bar(11:20,tip)),2)),"FontSize",14)
end

ylabel("GH-JCF / BW")
ylim([0 8])
axis square
% subplot(1,3,2)
% stdevShade(time',mean(F_cond1{3}), ... 
%         std(F_cond1{3}),color(1,:),   0.2)
% hold on
% stdevShade(time',mean(F_cond2{3}), ... 
%         std(F_cond2{3}),color(2,:),   0.2)
% ylim([0 6])
% xlabel("% Task")
% ylabel("GH-JCF / BW")
% ax1=gca;
% ax1.FontSize=10;
% 
% box off
% axis square
% 
% subplot(1,3,3)
% pp=nsidedpoly(1000, 'Center', [0,0], 'Radius', mean(r));
% hold on
% plot(pp, "FaceColor",'none','LineWidth',1,'LineStyle','-')
% 
% scatter(mean(x_cond1{3}), mean(y_cond1{3}),10, color(1,:), 'filled','MarkerFaceAlpha',0.1)
% scatter(mean(x_cond2{3}), mean(y_cond2{3}),10, color(2,:), 'filled','MarkerFaceAlpha',0.1)
% scatter(mean(mean(x_cond1{3})), mean(mean(y_cond1{3})),30, color(1,:), 'filled','MarkerEdgeColor','k')
% scatter(mean(mean(x_cond2{3})), mean(mean(y_cond2{3})),30, color(2,:), 'filled','MarkerEdgeColor','k')
% scatter(0, 0,30, [120, 0, 26]/255, 'Marker','x',LineWidth=1)
% xlabel("X [mm]")
% ylabel("Y [mm]")
% ax = gca;
% ax.FontSize = 10;
% axis square
saveas(fig3,fullfile(save_graphics,testing_conditions,append('GHJCFBar_', testing_conditions, '.pdf')))

%% Normalize function
function [xx,Vn]=normalize(T,V)
T=T-T(1);
x = 100*(T - min(T)) / ( max(T) - min(T) );
xx = linspace(0,100,101); %number of points for resample
Vn=spline(x,V,xx);
end

%% Sahded standard deviation function
function stdevShade(x,y,std_dev,colorVec,alpha)
%x: x data
%y: ydata
%std_dev: standarad Deviation
    curve1 = y + std_dev;
    curve2 = y - std_dev;
    x2 = [x, fliplr(x)];
    inBetween = [curve1, fliplr(curve2)];
    fill(x2, inBetween, colorVec,'FaceAlpha',alpha,'EdgeColor','none');
    hold on;
    plot(x, y, 'Color',colorVec, 'LineWidth', 2);
end

%% Perform statistical analysis
%Test significance on the first coordinate
function statis_test(x,y,x1,y1,coord1,coord2)
    [H1_elevation, ~, ~] = swtest(x, 0.5);
    [H2_elevation, ~, ~] = swtest(y, 0.5);
    ax=gca;
    r1=ax.RAxis.Limits(1);
    r2=ax.RAxis.Limits(2);
    if H1_elevation==1 || H2_elevation==1
       [~,h_elevation] = signrank(x,y);
       if h_elevation ==1
           text(-pi/2,r1,"** "+coord1)
       end
       
    else 
        h_elevation=ttest(x,y);
       if h_elevation ==1
          text(-pi/2,r1,"** "+coord1,"Color",[120, 0, 26]/255)
       end
       
    end
    
    %Test significance on the second coordinate
    [H1_rot, ~, ~] = swtest(x1, 0.5);
    [H2_rot, ~, ~] = swtest(y1, 0.5);
    
    if H1_rot==1 || H2_rot==1
       [~,h_rot] = signrank(x1,y1);
       if h_rot ==1
           text(-pi/2,r2,"** "+coord2)
       end
       
    else 
        h_rot=ttest(x1,y1);
       if h_rot ==1

          text(-pi/2,r2,"** "+coord2,"Color",[120, 0, 26]/255)
       end
       
    end
end

