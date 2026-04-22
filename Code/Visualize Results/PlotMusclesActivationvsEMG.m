%% Plot Torques and Reserve Vs. Actuators

%This script generates plots of rmuscles activation vs measure EMG across
%testing conditions.
%Author: Ibrahim Mohammed I. Hasan (imihasan@kth.se), Promobilia
%MoveAbility Lab, KTH Royal Institute of Technology, Stokholm, Sweden. 
%Scripted: 2025
        
close all; clear all

results_directory="C:\Users\ibrah\OneDrive - KTH\Paper I\Unilateral\Results\Muscle Redundancy";
EMG_directory="C:\Users\ibrah\OneDrive - KTH\Paper I\Unilateral\Experimental Data";
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

        emg_raw_upright=readtable(fullfile(EMG_directory,string(folders(n).name),"EMG\Upright_"+tasks(tr)+".csv"));
        emg_raw_slouched=readtable(fullfile(EMG_directory,string(folders(n).name),"EMG\Slouching_"+tasks(tr)+".csv"));

        time=table_upright.time;


        %Medial Deltoid
        t=(0:length(emg_raw_upright.Var4(2:end))-1)/2000;
        [~,MDel_emg_upright_N]=normalize(t,filtRMS(emg_raw_upright.Var4(2:end)',200));
        MDel_raw_MVC=readtable(fullfile(EMG_directory,string(folders(n).name),"EMG\MVC_Deltoid_M"+".csv"));
        MDel_emg_upright{tr}(s,:)=MDel_emg_upright_N/max(filtRMS(MDel_raw_MVC.Var4(2:end-1),200));

        t=(0:length(emg_raw_slouched.Var4(2:end))-1)/2000;
        [~,MDel_emg_slouched_N]=normalize(t,filtRMS(emg_raw_slouched.Var4(2:end)',200));
        MDel_emg_slouched{tr}(s,:)=MDel_emg_slouched_N/max(filtRMS(MDel_raw_MVC.Var4(2:end-1),200));

        MDel_upright{tr}(s,:)=table_upright.DeltoideusScapula_M;
        MDel_slouchedU{tr}(s,:)=table_slouchedU.DeltoideusScapula_M;
        MDel_slouchedL{tr}(s,:)=table_slouchedL.DeltoideusScapula_M;

        %Anterior Deltoid
        t=(0:length(emg_raw_upright.Var5(2:end))-1)/2000;
        [~,ADel_emg_upright_N]=normalize(t,filtRMS(emg_raw_upright.Var5(2:end)',200));
        ADel_raw_MVC=readtable(fullfile(EMG_directory,string(folders(n).name),"EMG\MVC_Deltoid_A"+".csv"));
        ADel_emg_upright{tr}(s,:)=ADel_emg_upright_N/max(filtRMS(ADel_raw_MVC.Var5(2:end-1),200));

        t=(0:length(emg_raw_slouched.Var5(2:end))-1)/2000;
        [~,ADel_emg_slouched_N]=normalize(t,filtRMS(emg_raw_slouched.Var5(2:end)',200));
        ADel_emg_slouched{tr}(s,:)=ADel_emg_slouched_N/max(filtRMS(ADel_raw_MVC.Var5(2:end-1),200));

        ADel_upright{tr}(s,:)=table_upright.DeltoideusClavicle_A;
        ADel_slouchedU{tr}(s,:)=table_slouchedU.DeltoideusClavicle_A;
        ADel_slouchedL{tr}(s,:)=table_slouchedL.DeltoideusClavicle_A;

        %Posterior Deltoid
        t=(0:length(emg_raw_upright.Var6(2:end))-1)/2000;
        [~,PDel_emg_upright_N]=normalize(t,filtRMS(emg_raw_upright.Var6(2:end)',200));
        PDel_raw_MVC=readtable(fullfile(EMG_directory,string(folders(n).name),"EMG\MVC_Deltoid_P"+".csv"));
        PDel_emg_upright{tr}(s,:)=PDel_emg_upright_N/max(filtRMS(PDel_raw_MVC.Var6(2:end-1),200));

        t=(0:length(emg_raw_slouched.Var6(2:end))-1)/2000;
        [~,PDel_emg_slouched_N]=normalize(t,filtRMS(emg_raw_slouched.Var6(2:end)',200));
        PDel_emg_slouched{tr}(s,:)=PDel_emg_slouched_N/max(filtRMS(PDel_raw_MVC.Var6(2:end-1),200));

        PDel_upright{tr}(s,:)=table_upright.DeltoideusScapula_P;
        PDel_slouchedU{tr}(s,:)=table_slouchedU.DeltoideusScapula_P;
        PDel_slouchedL{tr}(s,:)=table_slouchedL.DeltoideusScapula_P;

        %Trapezuis
        t=(0:length(emg_raw_upright.B_MyonEMG_Voltage(2:end))-1)/2000;
        [~,Trap_emg_upright_N]=normalize(t,filtRMS(emg_raw_upright.B_MyonEMG_Voltage(2:end)',200));
        Trap_raw_MVC=readtable(fullfile(EMG_directory,string(folders(n).name),"EMG\MVC_Trapezuis"+".csv"));
        Trap_emg_upright{tr}(s,:)=Trap_emg_upright_N/max(filtRMS(Trap_raw_MVC.B_MyonEMG_Voltage(2:end-1),200));

        t=(0:length(emg_raw_slouched.B_MyonEMG_Voltage(2:end))-1)/2000;
        [~,Trap_emg_slouched_N]=normalize(t,filtRMS(emg_raw_slouched.B_MyonEMG_Voltage(2:end)',200));
        Trap_emg_slouched{tr}(s,:)=Trap_emg_slouched_N/max(filtRMS(Trap_raw_MVC.B_MyonEMG_Voltage(2:end-1),200));

        Trap_upright{tr}(s,:)=(table_upright.TrapeziusScapula_S);
        Trap_slouchedU{tr}(s,:)=(table_slouchedU.TrapeziusScapula_S);
        Trap_slouchedL{tr}(s,:)=(table_slouchedL.TrapeziusScapula_S);

        %Triceps
        t=(0:length(emg_raw_upright.Var7(2:end))-1)/2000;
        [~,Tri_emg_upright_N]=normalize(t,filtRMS(emg_raw_upright.Var7(2:end)',200));
        Tri_raw_MVC=readtable(fullfile(EMG_directory,string(folders(n).name),"EMG\MVC_Triceps"+".csv"));
        Tri_emg_upright{tr}(s,:)=Tri_emg_upright_N/max(filtRMS(Tri_raw_MVC.Var7(2:end-1),200));

        t=(0:length(emg_raw_slouched.Var7(2:end))-1)/2000;
        [~,Tri_emg_slouched_N]=normalize(t,filtRMS(emg_raw_slouched.Var7(2:end)',200));
        Tri_emg_slouched{tr}(s,:)=Tri_emg_slouched_N/max(filtRMS(Tri_raw_MVC.Var7(2:end-1),200));

        Tri_upright{tr}(s,:)=(table_upright.TRIlong);
        Tri_slouchedU{tr}(s,:)=(table_slouchedU.TRIlong);
        Tri_slouchedL{tr}(s,:)=(table_slouchedL.TRIlong);

        %Biceps
        t=(0:length(emg_raw_upright.Var8(2:end))-1)/2000;
        [~,Bi_emg_upright_N]=normalize(t,filtRMS(emg_raw_upright.Var8(2:end)',200));
        Bi_raw_MVC=readtable(fullfile(EMG_directory,string(folders(n).name),"EMG\MVC_Biceps"+".csv"));
        Bi_emg_upright{tr}(s,:)=Bi_emg_upright_N/max(filtRMS(Bi_raw_MVC.Var8(2:end-1),200));

        t=(0:length(emg_raw_slouched.Var8(2:end))-1)/2000;
        [~,Bi_emg_slouched_N]=normalize(t,filtRMS(emg_raw_slouched.Var8(2:end)',200));
        Bi_emg_slouched{tr}(s,:)=Bi_emg_slouched_N/max(filtRMS(Bi_raw_MVC.Var8(2:end-1),200));

        Bi_upright{tr}(s,:)=(table_upright.BIClong);
        Bi_slouchedU{tr}(s,:)=(table_slouchedU.BIClong);
        Bi_slouchedL{tr}(s,:)=(table_slouchedL.BIClong);

        %Latissimus
        t=(0:length(emg_raw_upright.Var9(2:end))-1)/2000;
        [~,Lat_emg_upright_N]=normalize(t,filtRMS(emg_raw_upright.Var9(2:end)',200));
        Lat_raw_MVC=readtable(fullfile(EMG_directory,string(folders(n).name),"EMG\MVC_Biceps"+".csv"));
        Lat_emg_upright{tr}(s,:)=Lat_emg_upright_N/max(filtRMS(Bi_raw_MVC.Var9(2:end-1),200));

        t=(0:length(emg_raw_slouched.Var9(2:end))-1)/2000;
        [~,Lat_emg_slouched_N]=normalize(t,filtRMS(emg_raw_slouched.Var9(2:end)',200));
        Lat_emg_slouched{tr}(s,:)=Lat_emg_slouched_N/max(filtRMS(Lat_raw_MVC.Var9(2:end-1),200));

        Lat_upright{tr}(s,:)=(table_upright.LatissimusDorsi_S);
        Lat_slouchedU{tr}(s,:)=(table_slouchedU.LatissimusDorsi_S);
        Lat_slouchedL{tr}(s,:)=(table_slouchedL.LatissimusDorsi_S);
       
        s=s+1;
    end
    
    fig=figure;
    %medial deltoid
    subplot(2,3,1)
    stdevShade(time',mean(MDel_emg_upright{tr}),std(MDel_emg_upright{tr}),color(1,:),0.1, 1,'--')
    hold on
    stdevShade(time',mean(MDel_emg_slouched{tr}),std(MDel_emg_slouched{tr}),color(2,:),0.1, 1,'--')
    stdevShade(time',mean(MDel_upright{tr}),std(MDel_upright{tr}),color(1,:),0.1, 2,'-')
    stdevShade(time',mean(MDel_slouchedL{tr}),std(MDel_slouchedL{tr}),color(3,:),0.1, 2,'-')
    stdevShade(time',mean(MDel_slouchedU{tr}),std(MDel_slouchedU{tr}),color(2,:),0.1, 2,'-')
    box off
    ax=gca;
    ax.FontSize=10;
    ylim([0 2]);
    xlabel("% Task")
    ylabel("Activation")
    title("Deltoid M")

    %Anterior deltoid
    subplot(2,3,2)
    stdevShade(time',mean(ADel_emg_upright{tr}),std(ADel_emg_upright{tr}),color(1,:),0.1, 1,'--')
    hold on
    stdevShade(time',mean(ADel_emg_slouched{tr}),std(ADel_emg_slouched{tr}),color(2,:),0.1, 1,'--')
    stdevShade(time',mean(ADel_upright{tr}),std(ADel_upright{tr}),color(1,:),0.1, 2,'-')
    stdevShade(time',mean(ADel_slouchedL{tr}),std(ADel_slouchedL{tr}),color(3,:),0.1, 2,'-')
    stdevShade(time',mean(ADel_slouchedU{tr}),std(ADel_slouchedU{tr}),color(2,:),0.1, 2,'-')
    box off
    ax=gca;
    ax.FontSize=10;
    ylim([0 2]);
    xlabel("% Task")
    title("Deltoid A")


    %Posterior deltoid
    subplot(2,3,3)
    stdevShade(time',mean(PDel_emg_upright{tr}),std(PDel_emg_upright{tr}),color(1,:),0.1, 1,'--')
    hold on
    stdevShade(time',mean(PDel_emg_slouched{tr}),std(PDel_emg_slouched{tr}),color(2,:),0.1, 1,'--')
    stdevShade(time',mean(PDel_upright{tr}),std(PDel_upright{tr}),color(1,:),0.1, 2,'-')
    stdevShade(time',mean(PDel_slouchedL{tr}),std(PDel_slouchedL{tr}),color(3,:),0.1, 2,'-')
    stdevShade(time',mean(PDel_slouchedU{tr}),std(PDel_slouchedU{tr}),color(2,:),0.1, 2,'-')
    box off
    ax=gca;
    ax.FontSize=10;
    ylim([0 2]);
    xlabel("% Task")
    title("Deltoid P")

    %Trapezuis
    subplot(2,4,5)
    stdevShade(time',mean(Trap_emg_upright{tr}),std(Trap_emg_upright{tr}),color(1,:),0.1, 1,'--')
    hold on
    stdevShade(time',mean(Trap_emg_slouched{tr}),std(Trap_emg_slouched{tr}),color(2,:),0.1, 1,'--')
    stdevShade(time',mean(Trap_upright{tr}),std(Trap_upright{tr}),color(1,:),0.1, 2,'-')
    stdevShade(time',mean(Trap_slouchedL{tr}),std(Trap_slouchedL{tr}),color(3,:),0.1, 2,'-')
    stdevShade(time',mean(Trap_slouchedU{tr}),std(Trap_slouchedU{tr}),color(2,:),0.1, 2,'-')
    box off
    ax=gca;
    ax.FontSize=10;
    ylim([0 2]);
    xlabel("% Task")
    ylabel("Activation")
    title("Trapezius")

    %Triceps
    subplot(2,4,6)
    stdevShade(time',mean(Tri_emg_upright{tr}),std(Tri_emg_upright{tr}),color(1,:),0.1, 1,'--')
    hold on
    stdevShade(time',mean(Tri_emg_slouched{tr}),std(Tri_emg_slouched{tr}),color(2,:),0.1, 1,'--')
    stdevShade(time',mean(Tri_upright{tr}),std(Tri_upright{tr}),color(1,:),0.1, 2,'-')
    stdevShade(time',mean(Tri_slouchedL{tr}),std(Tri_slouchedL{tr}),color(3,:),0.1, 2,'-')
    stdevShade(time',mean(Tri_slouchedU{tr}),std(Tri_slouchedU{tr}),color(2,:),0.1, 2,'-')
    box off
    ax=gca;
    ax.FontSize=10;
    ylim([0 2]);
    xlabel("% Task")
    title("Triceps L")

    %Biceps
    subplot(2,4,7)
    stdevShade(time',mean(Bi_emg_upright{tr}),std(Bi_emg_upright{tr}),color(1,:),0.1, 1,'--')
    hold on
    stdevShade(time',mean(Bi_emg_slouched{tr}),std(Bi_emg_slouched{tr}),color(2,:),0.1, 1,'--')
    stdevShade(time',mean(Bi_upright{tr}),std(Bi_upright{tr}),color(1,:),0.1, 2,'-')
    stdevShade(time',mean(Bi_slouchedL{tr}),std(Bi_slouchedL{tr}),color(3,:),0.1, 2,'-')
    stdevShade(time',mean(Bi_slouchedU{tr}),std(Bi_slouchedU{tr}),color(2,:),0.1, 2,'-')
    box off
    ax=gca;
    ax.FontSize=10;
    ylim([0 2]);
    xlabel("% Task")
    title("Biceps L")

    %Lats
    subplot(2,4,8)
    stdevShade(time',mean(Lat_emg_upright{tr}),std(Lat_emg_upright{tr}),color(1,:),0.1, 1,'--')
    hold on
    stdevShade(time',mean(Lat_emg_slouched{tr}),std(Lat_emg_slouched{tr}),color(2,:),0.1, 1,'--')
    stdevShade(time',mean(Lat_upright{tr}),std(Lat_upright{tr}),color(1,:),0.1, 2,'-')
    stdevShade(time',mean(Lat_slouchedL{tr}),std(Lat_slouchedL{tr}),color(3,:),0.1, 2,'-')
    stdevShade(time',mean(Lat_slouchedU{tr}),std(Lat_slouchedU{tr}),color(2,:),0.1, 2,'-')
    box off
    ax=gca;
    ax.FontSize=10;
    ylim([0 2]);
    xlabel("% Task")
    title("Latissimus D")

    saveas(fig,fullfile(save_graphics,append('ActivatiovsEMG_', char(tasks(tr)), '.pdf')));
    
end

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

%% Filter emg and find rms

function y=filtRMS(x,window)
    %Filter
    n = 4; %order of filter
    Wn = [20, 450]/1000; %low and high cut-off frequency
    [b,a] = butter(n,Wn, 'bandpass');
    x = filter(b,a,x);
    [y,~] = envelope(x,window,'rms');
end

