%% Plot Torques and Reserve Vs. Actuators

%This script generates plots of reserve actuators vs joint moments
%testing conditions.
%Author: Ibrahim Mohammed I. Hasan (imihasan@kth.se), Promobilia
%MoveAbility Lab, KTH Royal Institute of Technology, Stokholm, Sweden. 
%Scripted: 2025
        
close all; clear all

results_directory="C:\Users\ibrah\OneDrive - KTH\Paper I\Unilateral\Results\Muscle Redundancy";
results_ID="C:\Users\ibrah\OneDrive - KTH\Paper I\Unilateral\Results\Inverse Dynamics";
save_graphics="C:\Users\ibrah\OneDrive - KTH\Paper I\Unilateral\Graphs";
conditions=["Locked", "Unlocked"];
folders=dir(results_directory);
testing_conditions="Models";

tasks=["Lateral_Raise_Head", "Front_Raise_Head", "Extension"];

tials_legend=["Lateral Raise", "Anterior Raise", "Posterior Raise"];
coordinates=["shoulder_elv", "plane_elv", "axial_rot", "scapula_abduction", ...
    "scapula_elevation", "scapula_upward_rot"];

Legend=["Upright", "Slouched-Unlocked",  "Slouched-Locked"];
color=[0, 0, 97/255; 130/255 150/255 111/255; 111/255 41/255 125/255];

for tr=1:3
    s=1;
    for n=3:length(folders)

        table_upright=readtable(fullfile(results_directory,string(folders(n).name)+"\","Unlocked\muscle_activations_Upright_"+tasks(tr)+".txt"));
        table_slouchedU=readtable(fullfile(results_directory,string(folders(n).name)+"\","Unlocked\muscle_activations_Slouching_"+tasks(tr)+".txt"));
        table_slouchedL=readtable(fullfile(results_directory,string(folders(n).name)+"\","Locked\muscle_activations_Slouching_"+tasks(tr)+".txt"));
        
        torque_upright=importdata(fullfile(results_ID,string(folders(n).name),"\Unlocked\Upright_"+tasks(tr)+".mot"));
        torque_upright=array2table(torque_upright.data,'VariableNames',torque_upright.colheaders);

        torque_slouchedU=importdata(fullfile(results_ID,string(folders(n).name),"\Unlocked\Slouching_"+tasks(tr)+".mot"));
        torque_slouchedU=array2table(torque_slouchedU.data,'VariableNames',torque_slouchedU.colheaders);

        torque_slouchedL=importdata(fullfile(results_ID,string(folders(n).name),"\Locked\Slouching_"+tasks(tr)+".mot"));
        torque_slouchedL=array2table(torque_slouchedL.data,'VariableNames',torque_slouchedL.colheaders);

        time=table_upright.time;


        %plane of elevation
        r_poe_upright{tr}(s,:)= table_upright.plane_elv;
        r_poe_slouchedU{tr}(s,:)= table_slouchedU.plane_elv;
        r_poe_slouchedL{tr}(s,:)= table_slouchedL.plane_elv;

        [~,t_poe_upright{tr}(s,:)]= normalize(torque_upright.time,torque_upright.plane_elv_moment);
        [~,t_poe_slouchedU{tr}(s,:)]= normalize(torque_slouchedU.time,torque_slouchedU.plane_elv_moment);
        [~,t_poe_slouchedL{tr}(s,:)]= normalize(torque_slouchedL.time,torque_slouchedL.plane_elv_moment);

        %shoulder elevation
        r_se_upright{tr}(s,:)= table_upright.shoulder_elv;
        r_se_slouchedU{tr}(s,:)= table_slouchedU.shoulder_elv;
        r_se_slouchedL{tr}(s,:)= table_slouchedL.shoulder_elv;

        [~,t_se_upright{tr}(s,:)]= normalize(torque_upright.time,torque_upright.shoulder_elv_moment);
        [~,t_se_slouchedU{tr}(s,:)]= normalize(torque_slouchedU.time,torque_slouchedU.shoulder_elv_moment);
        [~,t_se_slouchedL{tr}(s,:)]= normalize(torque_slouchedL.time,torque_slouchedL.shoulder_elv_moment);

        %shoulder elevation
        r_ar_upright{tr}(s,:)= table_upright.axial_rot;
        r_ar_slouchedU{tr}(s,:)= table_slouchedU.axial_rot;
        r_ar_slouchedL{tr}(s,:)= table_slouchedL.axial_rot;

        [~,t_ar_upright{tr}(s,:)]= normalize(torque_upright.time,torque_upright.axial_rot_moment);
        [~,t_ar_slouchedU{tr}(s,:)]= normalize(torque_slouchedU.time,torque_slouchedU.axial_rot_moment);
        [~,t_ar_slouchedL{tr}(s,:)]= normalize(torque_slouchedL.time,torque_slouchedL.axial_rot_moment);

        %scapular abduction
        r_ScA_upright{tr}(s,:)= table_upright.scapula_abduction;
        r_ScA_slouchedU{tr}(s,:)= table_slouchedU.scapula_abduction;
        r_ScA_slouchedL{tr}(s,:)= table_slouchedL.scapula_abduction;

        [~,t_ScA_upright{tr}(s,:)]= normalize(torque_upright.time,torque_upright.scapula_abduction_moment);
        [~,t_ScA_slouchedU{tr}(s,:)]= normalize(torque_slouchedU.time,torque_slouchedU.scapula_abduction_moment);
        [~,t_ScA_slouchedL{tr}(s,:)]= normalize(torque_slouchedL.time,torque_slouchedL.scapula_abduction_moment);

        %scapular elevation
        r_ScE_upright{tr}(s,:)= table_upright.scapula_elevation;
        r_ScE_slouchedU{tr}(s,:)= table_slouchedU.scapula_elevation;
        r_ScE_slouchedL{tr}(s,:)= table_slouchedL.scapula_elevation;

        [~,t_ScE_upright{tr}(s,:)]= normalize(torque_upright.time,torque_upright.scapula_elevation_moment);
        [~,t_ScE_slouchedU{tr}(s,:)]= normalize(torque_slouchedU.time,torque_slouchedU.scapula_elevation_moment);
        [~,t_ScE_slouchedL{tr}(s,:)]= normalize(torque_slouchedL.time,torque_slouchedL.scapula_elevation_moment);

        %scapular elevation
        r_ScR_upright{tr}(s,:)= table_upright.scapula_upward_rot;
        r_ScR_slouchedU{tr}(s,:)= table_slouchedU.scapula_upward_rot;
        r_ScR_slouchedL{tr}(s,:)= table_slouchedL.scapula_upward_rot;

        [~,t_ScR_upright{tr}(s,:)]= normalize(torque_upright.time,torque_upright.scapula_upward_rot_moment);
        [~,t_ScR_slouchedU{tr}(s,:)]= normalize(torque_slouchedU.time,torque_slouchedU.scapula_upward_rot_moment);
        [~,t_ScR_slouchedL{tr}(s,:)]= normalize(torque_slouchedL.time,torque_slouchedL.scapula_upward_rot_moment);

        %scapular winging
        r_ScW_upright{tr}(s,:)= table_upright.scapula_winging;
        r_ScW_slouchedU{tr}(s,:)= table_slouchedU.scapula_winging;
        r_ScW_slouchedL{tr}(s,:)= table_slouchedL.scapula_winging;

        [~,t_ScW_upright{tr}(s,:)]= normalize(torque_upright.time,torque_upright.scapula_winging_moment);
        [~,t_ScW_slouchedU{tr}(s,:)]= normalize(torque_slouchedU.time,torque_slouchedU.scapula_winging_moment);
        [~,t_ScW_slouchedL{tr}(s,:)]= normalize(torque_slouchedL.time,torque_slouchedL.scapula_winging_moment);

        s=s+1;
    end

    fig=figure;
    subplot(2,3,1)
    stdevShade(time',mean(r_poe_upright{tr}),std(r_poe_upright{tr}),color(1,:),0.1, 1,'--')
    hold on
    stdevShade(time',mean(r_poe_slouchedU{tr}),std(r_poe_slouchedU{tr}),color(2,:),0.1, 1,'--')
    stdevShade(time',mean(r_poe_slouchedL{tr}),std(r_poe_slouchedL{tr}),color(3,:),0.1, 1,'--')

    stdevShade(time',mean(t_poe_upright{tr}),std(t_poe_upright{tr}),color(1,:),0.1, 2,'-')
    stdevShade(time',mean(t_poe_slouchedL{tr}),std(t_poe_slouchedL{tr}),color(3,:),0.1, 2,'-')
    stdevShade(time',mean(t_poe_slouchedU{tr}),std(t_poe_slouchedU{tr}),color(2,:),0.1, 2,'-')
    ylabel("Moment [Nm]")
    title('Plane Elev')
    xlabel("% Task")
    box off
    ax=gca;
    ax.FontSize=10;

    subplot(2,3,2)
    stdevShade(time',mean(r_se_upright{tr}),std(r_se_upright{tr}),color(1,:),0.1, 1,'--')
    hold on
    stdevShade(time',mean(r_se_slouchedU{tr}),std(r_se_slouchedU{tr}),color(2,:),0.1, 1,'--')
    stdevShade(time',mean(r_se_slouchedL{tr}),std(r_se_slouchedL{tr}),color(3,:),0.1, 1,'--')

    stdevShade(time',mean(t_se_upright{tr}),std(t_se_upright{tr}),color(1,:),0.1, 2,'-')
    stdevShade(time',mean(t_se_slouchedL{tr}),std(t_se_slouchedL{tr}),color(3,:),0.1, 2,'-')
    stdevShade(time',mean(t_se_slouchedU{tr}),std(t_se_slouchedU{tr}),color(2,:),0.1, 2,'-')

    title('Shoulder Elev')
    xlabel("% Task")
    box off
    ax=gca;
    ax.FontSize=10;

    subplot(2,3,3)
    stdevShade(time',mean(r_ar_upright{tr}),std(r_ar_upright{tr}),color(1,:),0.1, 1,'--')
    hold on
    stdevShade(time',mean(r_ar_slouchedU{tr}),std(r_ar_slouchedU{tr}),color(2,:),0.1, 1,'--')
    stdevShade(time',mean(r_ar_slouchedL{tr}),std(r_ar_slouchedL{tr}),color(3,:),0.1, 1,'--')

    stdevShade(time',mean(t_ar_upright{tr}),std(t_ar_upright{tr}),color(1,:),0.1, 2,'-')
    stdevShade(time',mean(t_ar_slouchedL{tr}),std(t_ar_slouchedL{tr}),color(3,:),0.1, 2,'-')
    stdevShade(time',mean(t_ar_slouchedU{tr}),std(t_ar_slouchedU{tr}),color(2,:),0.1, 2,'-')

    title('Arxial Rot')
    xlabel("% Task")
    box off
    ax=gca;
    ax.FontSize=10;

    subplot(2,4,5)
    stdevShade(time',mean(r_ScA_upright{tr}),std(r_ScA_upright{tr}),color(1,:),0.1, 1,'--')
    hold on
    stdevShade(time',mean(r_ScA_slouchedU{tr}),std(r_ScA_slouchedU{tr}),color(2,:),0.1, 1,'--')
    stdevShade(time',mean(r_ScA_slouchedL{tr}),std(r_ScA_slouchedL{tr}),color(3,:),0.1, 1,'--')

    stdevShade(time',mean(t_ScA_upright{tr}),std(t_ScA_upright{tr}),color(1,:),0.1, 2,'-')
    stdevShade(time',mean(t_ScA_slouchedL{tr}),std(t_ScA_slouchedL{tr}),color(3,:),0.1, 2,'-')
    stdevShade(time',mean(t_ScA_slouchedU{tr}),std(t_ScA_slouchedU{tr}),color(2,:),0.1, 2,'-')

    title('Scap Abd')
    xlabel("% Task")
    ylabel("Moment [Nm]")
    box off
    ax=gca;
    ax.FontSize=10;

    subplot(2,4,6)
    stdevShade(time',mean(r_ScE_upright{tr}),std(r_ScE_upright{tr}),color(1,:),0.1, 1,'--')
    hold on
    stdevShade(time',mean(r_ScE_slouchedU{tr}),std(r_ScE_slouchedU{tr}),color(2,:),0.1, 1,'--')
    stdevShade(time',mean(r_ScE_slouchedL{tr}),std(r_ScE_slouchedL{tr}),color(3,:),0.1, 1,'--')

    stdevShade(time',mean(t_ScE_upright{tr}),std(t_ScE_upright{tr}),color(1,:),0.1, 2,'-')
    stdevShade(time',mean(t_ScE_slouchedL{tr}),std(t_ScE_slouchedL{tr}),color(3,:),0.1, 2,'-')
    stdevShade(time',mean(t_ScE_slouchedU{tr}),std(t_ScE_slouchedU{tr}),color(2,:),0.1, 2,'-')

    title('Scap Elev')
    xlabel("% Task")
    box off
    ax=gca;
    ax.FontSize=10;

    subplot(2,4,7)
    stdevShade(time',mean(r_ScR_upright{tr}),std(r_ScR_upright{tr}),color(1,:),0.1, 1,'--')
    hold on
    stdevShade(time',mean(r_ScR_slouchedU{tr}),std(r_ScR_slouchedU{tr}),color(2,:),0.1, 1,'--')
    stdevShade(time',mean(r_ScR_slouchedL{tr}),std(r_ScR_slouchedL{tr}),color(3,:),0.1, 1,'--')

    stdevShade(time',mean(t_ScR_upright{tr}),std(t_ScR_upright{tr}),color(1,:),0.1, 2,'-')
    stdevShade(time',mean(t_ScR_slouchedL{tr}),std(t_ScR_slouchedL{tr}),color(3,:),0.1, 2,'-')
    stdevShade(time',mean(t_ScR_slouchedU{tr}),std(t_ScR_slouchedU{tr}),color(2,:),0.1, 2,'-')

    title('Scap URot')
    xlabel("% Task")
    box off
    ax=gca;
    ax.FontSize=10;

    subplot(2,4,8)
    stdevShade(time',mean(r_ScW_upright{tr}),std(r_ScW_upright{tr}),color(1,:),0.1, 1,'--')
    hold on
    stdevShade(time',mean(r_ScW_slouchedU{tr}),std(r_ScW_slouchedU{tr}),color(2,:),0.1, 1,'--')
    stdevShade(time',mean(r_ScW_slouchedL{tr}),std(r_ScW_slouchedL{tr}),color(3,:),0.1, 1,'--')

    stdevShade(time',mean(t_ScW_upright{tr}),std(t_ScW_upright{tr}),color(1,:),0.1, 2,'-')
    stdevShade(time',mean(t_ScW_slouchedL{tr}),std(t_ScW_slouchedL{tr}),color(3,:),0.1, 2,'-')
    stdevShade(time',mean(t_ScW_slouchedU{tr}),std(t_ScW_slouchedU{tr}),color(2,:),0.1, 2,'-')

    title('Scap Wing')
    xlabel("% Task")
    box off
    ax=gca;
    ax.FontSize=10;

    saveas(fig,fullfile(save_graphics,append('ReserveActs_', char(tasks(tr)), '.pdf')));
    
end

%saveas(fig1,fullfile(save_graphics,testing_conditions,append('Ligament_Lengthening_', testing_conditions, '.pdf')))
%saveas(fig2,fullfile(save_graphics,testing_conditions,append('GHJCFMagnitude_', testing_conditions, '.pdf')))



%% Normalize function
function [xx,Vn]=normalize(T,V)
T=T-T(1);
x = 100*(T - min(T)) / ( max(T) - min(T) );
xx = linspace(0,100,101); %number of points for resample
Vn=spline(x,V,xx);
end

%% Sahded standard deviation function
function stdevShade(x,y,std_dev,colorVec,alpha,linewidth,linestyle)
%x: x data
%y: ydata
%std_dev: standarad Deviation
    curve1 = y + std_dev;
    curve2 = y - std_dev;
    x2 = [x, fliplr(x)];
    inBetween = [curve1, fliplr(curve2)];
    fill(x2, inBetween, colorVec,'FaceAlpha',alpha,'EdgeColor','none');
    hold on;
    plot(x, y, 'Color',colorVec, 'LineWidth', linewidth,LineStyle=linestyle);
end
