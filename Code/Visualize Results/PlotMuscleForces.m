%% Plot individual muscle forces and direction
%This script is for plotting magnitude and direction of individual muscle
%forces as a bubble chart.
%Author: Ibrahim Mohammed I. Hasan (imihasan@kth.se)
%KTH Royal Institute of Technology


close all; clear
pathstr=fileparts(matlab.desktop.editor.getActiveFilename);
cd(pathstr+"\..\..");
addpath(pwd)
path_to_repo = pwd;
results_directory_red=path_to_repo+"\Results\Muscle Redundancy";
save_graphics=path_to_repo+"\Graphs";
results_directory=path_to_repo+"\Results\Individual Muscle Forces";
testing_conditions="Postures";
subj_weight=[58, 66.8, 70.7, 79, 58.5, 69.7, 75.7, 58.7, 77, 60.5]*9.81;

muscles_rotator=["Subscapularis_S";"Subscapularis_M"; "Subscapularis_I";
    "Supraspinatus_P";"Supraspinatus_A"; "Infraspinatus_S"; "Infraspinatus_I";
    "TeresMinor";"TeresMajor"];
plot_rotator=0;


muscles_superficial=["PectoralisMajorClavicle_S"; "PectoralisMajorThorax_M";
    "PectoralisMajorThorax_I"; "TrapeziusScapula_S"; "TrapeziusScapula_M";
    "TrapeziusScapula_I"; "SerratusAnterior_S"; "SerratusAnterior_M";
    "SerratusAnterior_I"; "LatissimusDorsi_S"; "LatissimusDorsi_M"; 
    "LatissimusDorsi_I"; "DeltoideusClavicle_A"; "DeltoideusScapula_M"; "DeltoideusScapula_P"];

plot_superficial=0;

% 
muscles_LR=["BIClong"; "BICshort"; "TRIlong"; "DeltoideusClavicle_A"; "DeltoideusScapula_M"];
iden_LR=["Bic L"; "Bic S"; "Tric L"; "Del A"; "Del M"];


muscles_AR=["PectoralisMajorThorax_M"; "Coracobrachialis"; "TRIlong"; "BICshort"; "DeltoideusScapula_M"];
iden_AR=["Pec M"; "Coraco"; "Tric L"; "Bic S"; "Del M"];

muscles_PR=["TRIlong" ; "BIClong"; "BICshort"; "DeltoideusClavicle_A"; "DeltoideusScapula_P"];
iden_PR=["Tric L"; "Bic S"; "Bic L"; "Del A"; "Del P"];


% Superficial Muscles
% muscles_LR=["TrapeziusScapula_S"; "TrapeziusScapula_M"; "TrapeziusScapula_I"; "SerratusAnterior_M"; "LevatorScapulae"];
% 
% iden_LR=["Trap S"; "Trap M"; "Trap I"; "Serr M"; "Lev"];
% 
% 
% muscles_AR=["PectoralisMajorClavicle_S"; "SerratusAnterior_M"; "SerratusAnterior_I"; "LevatorScapulae"];
% iden_AR=["Pector S"; "Serr M"; "Serr I"; "Lev"];
% 
% muscles_PR=["TrapeziusScapula_S"; "TrapeziusScapula_M"; "SerratusAnterior_M"; "SerratusAnterior_I"; "LevatorScapulae"];
% iden_PR=["Trap S"; "Trap M";  "Serr M"; "Serr I"; "Lev"];

color=[0, 0, 97/255; 130/255 150/255 111/255];

col=[13, 74, 33; 
    77, 160, 97; 
    199, 235, 186 ; 

    120, 0, 26;
    232, 106, 88;

    165, 165, 165;
    230, 230, 230;

    0, 71, 145;
    98, 152, 210;

    166, 89, 0;
    255, 190, 0;
    255, 240, 176;

 
    111, 41, 125; 
    255, 0, 255;

    0, 0, 255;
    0, 50, 138;
    178, 224, 224]/255;

tasks=["Lateral_Raise_Head", "Front_Raise_Head", "Extension"];
trials=["Lateral Raise", "Anterior Raise", "Posterior Raise"];
Postures=["Upright", "Slouched"];

load(fullfile(results_directory,"Levator_Muscles_Forces_CoP_ModelsPostures.mat"));

fig2=figure(2);
for tr=1:3
    if plot_rotator==1
        muscles=muscles_rotator;
        iden=["Sub S";"Sub M"; "Sub I";
    "Sup P";"Sup A"; "Infr S"; "Infr I";
    "Ter Mi";"Ter Mj"];

    elseif plot_superficial==1
        muscles=muscles_superficial;
        iden=["Pec S";"Pec M"; "Pec I";
    "Trap S";"Trap M"; "Trap I"; "Ser S";
    "Ser M";"Ser I"; "Lat S"; "Lat M"; "Lat I"];
        % iden=muscles_superficial;


        
    else
        if trials(tr)=="Lateral Raise"
            muscles=muscles_LR;
            iden=iden_LR;
        elseif trials(tr)=="Anterior Raise"
            muscles=muscles_AR;
            iden=iden_AR;
        elseif trials(tr)=="Posterior Raise"
            muscles=muscles_PR;
            iden=iden_PR;
        end
    end


    fig1=figure;
    for m=1:length(muscles)
        for s=1:10
            if s==10
                SS='S'; 
            else
                SS='S0';
            end
            table_cond1=readtable(fullfile(results_directory_red,string(SS)+string(s)+"\","Unlocked\muscle_activations_Upright_"+tasks(tr)+".txt"));
            r(s)=mean(table_cond1.radius);
            F_Slouched=eval(append('muscles_param.', SS,string(s),'.', char(tasks(tr)),'.','Slouching.Unlocked.',char(muscles(m)),'.Ftime'));
            isn=~isnan(F_Slouched);
            Mag_Slouched=norm(mean(F_Slouched(find(isn(:,1)==1),:)))/subj_weight(s);
            Direction_Slouched=eval(append('muscles_param.', SS,string(s),'.', char(tasks(tr)),'.','Slouching.Unlocked.',char(muscles(m)),'.bubble'));
            Direction_Slouched(4)=Mag_Slouched;
            bubble_slouched(s,:)=Direction_Slouched;

            muscles_bar_sl(s,m)=mean(eval(append('muscles_param.', SS,string(s),'.', char(tasks(tr)),'.','Slouching.Unlocked.',char(muscles(m)),'.muscleForce')))/subj_weight(s);

            F_Upright=eval(append('muscles_param.', SS,string(s),'.', char(tasks(tr)),'.','Upright.Unlocked.',char(muscles(m)),'.Ftime'));
            isn=~isnan(F_Upright);
            Mag_Upright=norm(mean(F_Upright(find(isn(:,1)==1),:)))/subj_weight(s);
            Direction_Upright=eval(append('muscles_param.', SS,string(s),'.', char(tasks(tr)),'.','Upright.Unlocked.',char(muscles(m)),'.bubble'));
            Direction_Upright(4)=Mag_Upright;
            bubble_upright(s,:)=Direction_Upright;

             muscles_bar_up(s,m)=mean(eval(append('muscles_param.', SS,string(s),'.', char(tasks(tr)),'.','Upright.Unlocked.',char(muscles(m)),'.muscleForce')))/subj_weight(s);
        end

        if mean(bubble_upright(:,4))<0.2
            flags(m)=m;

        else
            flags(m)=0;
        end

        hold on
        nan_up=isnan(bubble_upright);
        bubble_upright(nan_up(:,1),:)=[];

        nan_sl=isnan(bubble_slouched);
        bubble_slouched(nan_sl(:,1),:)=[];

        bubup(m)=bubblechart(-mean(bubble_upright(:,2))/10,-mean(bubble_upright(:,3))/10,round(mean(bubble_upright(:,4)),2),col(m,:), ... 
                     MarkerEdgeColor=color(1,:),MarkerFaceAlpha=0.7,LineWidth=2);
        
        bubsl(m)=bubblechart(-mean(bubble_slouched(:,2))/10,-mean(bubble_slouched(:,3))/10,round(mean(bubble_slouched(:,4)),2),col(m,:), ... 
                     MarkerEdgeColor=color(2,:),MarkerFaceAlpha=0.7,LineWidth=2);
        
    end
    axis equal
    xlim([-3.5 2.0])
    ylim([-3.0 2.0])
    xlabel("X [cm]")
    ylabel("Y [cm]")
    clear Loc
    ax = gca;
    ax.FontSize = 25;
    bubblelegend('[Force / BW]','NumBubbles',2,'Location','southeast', ... 
        'FontSize',15,'Box','off','Style','vertical')
    
    box off
    p=nsidedpoly(1000, 'Center', [0,0], 'Radius', mean(r)/10);
    pp=plot(p, "FaceColor",'none','LineWidth',1,'LineStyle','--');
    % uistack(pp,'bottom')
    % uistack(bubup(flags(flags~=0)),"top");
    % uistack(bubsl(flags(flags~=0)),"top");
    scatter(0, 0,150, [0, 0, 0]/255, 'Marker','x',LineWidth=2)
    title(trials(tr))

    figure(2)
    subplot(3,1,tr)
    index=[1*ones(10,1); 2*ones(10,1)];
    var=[muscles_bar_up; muscles_bar_sl]*100;
    vp = dabarplot(var,'groups',index,'colors',color, 'outliers',0, ... 
         'xtlabels', iden,'scatter',1, 'errorbars',0,...
         'jitter',1,'mean',1, ... 
          'fill', 1,'barwidth',1);

    ax = gca;
    ax.FontSize=12;
    range=ax.YLim(2)-ax.YLim(1);
    signftest(vp,vp.gpos,vp.cpos,range,var)
    
    ylabel("Force [% BW]")
    ylim([0 170])
    title(trials(tr))
    saveas(fig1,fullfile(save_graphics,testing_conditions,append(tasks(tr),'MuscleForces_', '.pdf')))
    clear iden muscles var muscles_bar_up muscles_bar_sl
    % axis equal

end
saveas(fig2,fullfile(save_graphics,testing_conditions,append('MuscleForces_Bar', '.pdf')))

%% Plot muscle group 2

close all; clear

results_directory="C:\Users\ibrah\OneDrive - KTH\Paper I\Unilateral\Results\Individual Muscle Forces";
results_directory_red="C:\Users\ibrah\OneDrive - KTH\Paper I\Unilateral\Results\Muscle Redundancy";
save_graphics="C:\Users\ibrah\OneDrive - KTH\Paper I\Unilateral\Graphs";
testing_conditions="Postures";
subj_weight=[58, 66.8, 70.7, 79, 58.5, 69.7, 75.7, 58.7, 77, 60.5]*9.81;

muscles=["DeltoideusScapula_P"; "DeltoideusScapula_M"; "DeltoideusClavicle_A"];

color=[0, 0, 97/255; 130/255 150/255 111/255];

col=[13, 74, 33; 
    77, 160, 97; 
    199, 235, 186 ; 

    120, 0, 26;
    232, 106, 88;

    165, 165, 165;
    230, 230, 230;

    0, 71, 145;
    98, 152, 210;

    166, 89, 0;
    255, 190, 0;
    255, 240, 176;

 
    111, 41, 125; 
    255, 0, 255;

    0, 0, 255;
    0, 50, 138;
    178, 224, 224]/255;

tasks=["Lateral_Raise_Head", "Front_Raise_Head", "Extension"];
trials=["Lateral Raise", "Anterior Raise", "Posterior Raise"];
Postures=["Upright", "Slouched"];
load(fullfile(results_directory,"Muscles_Forces_CoP_ModelsPostures.mat"));


for tr=1:3
    fig=figure;
    for m=1:length(muscles)
        for s=1:10
            if s==10
                SS='S'; 
            else
                SS='S0';
            end
            table_cond1=readtable(fullfile(results_directory_red,string(SS)+string(s)+"\","Unlocked\muscle_activations_Upright_"+tasks(tr)+".txt"));
            r(s)=mean(table_cond1.radius);
            F_Slouched=eval(append('muscles_param.', SS,string(s),'.', char(tasks(tr)),'.','Slouching.Unlocked.',char(muscles(m)),'.Ftime'));
            isn=~isnan(F_Slouched);
            Mag_Slouched=norm(mean(F_Slouched(find(isn(:,1)==1),:)))/subj_weight(s);
            Direction_Slouched=eval(append('muscles_param.', SS,string(s),'.', char(tasks(tr)),'.','Slouching.Unlocked.',char(muscles(m)),'.bubble'));
            Direction_Slouched(4)=Mag_Slouched;
            bubble_slouched(s,:)=Direction_Slouched;


            F_Upright=eval(append('muscles_param.', SS,string(s),'.', char(tasks(tr)),'.','Upright.Unlocked.',char(muscles(m)),'.Ftime'));
            isn=~isnan(F_Upright);
            Mag_Upright=norm(mean(F_Upright(find(isn(:,1)==1),:)))/subj_weight(s);
            Direction_Upright=eval(append('muscles_param.', SS,string(s),'.', char(tasks(tr)),'.','Upright.Unlocked.',char(muscles(m)),'.bubble'));
            Direction_Upright(4)=Mag_Upright;
            bubble_upright(s,:)=Direction_Upright;
        end

        if mean(bubble_upright(:,4))<0.2
            flags(m)=m;

        else
            flags(m)=0;
        end
        nan_up=isnan(bubble_upright);
        bubble_upright(nan_up(:,1),:)=[];

        nan_sl=isnan(bubble_slouched);
        bubble_slouched(nan_sl(:,1),:)=[];

        hold on
        bubup(m)=bubblechart(-mean(bubble_upright(:,2))/10,-mean(bubble_upright(:,3))/10,round(mean(bubble_upright(:,4)),2),col(m,:), ... 
                     MarkerEdgeColor=color(1,:),MarkerFaceAlpha=0.7,LineWidth=2);
        
        bubsl(m)=bubblechart(-mean(bubble_slouched(:,2))/10,-mean(bubble_slouched(:,3))/10,round(mean(bubble_slouched(:,4)),2),col(m,:), ... 
                     MarkerEdgeColor=color(2,:),MarkerFaceAlpha=0.7,LineWidth=2);
        

        

        % xlim([-30 20])
        % ylim([-30 20])
        xlabel("X [cm]")
        ylabel("Y [cm]")
        clear Loc
        ax = gca;
        ax.FontSize = 28;
        % axis square
        box off
    end
    p=nsidedpoly(1000, 'Center', [0,0], 'Radius', mean(r)/10);
    pp=plot(p, "FaceColor",'none','LineWidth',1,'LineStyle','--');
    
    % uistack(bubup(flags(flags~=0)),"top");
    % uistack(bubsl(flags(flags~=0)),"top");
    % uistack(pp,'top')
    scatter(0, 0,150, [0, 0, 0]/255, 'Marker','x',LineWidth=3)
    title(trials(tr))
    
    if trials(tr)=="Posterior Raise"
        xlim([-50 450])
        ylim([-50 400])
        axis equal
        legend_loc='southeast';
    elseif trials(tr)=="Lateral Raise"
        xlim([-10 90])
        ylim([-10 60])
        axis equal
        legend_loc='southeast';
    elseif trials(tr)=="Anterior Raise"
        
        xlim([-5 12])
        ylim([-2 12])
        axis equal
        legend_loc='southeast';
    end
    
    bubblelegend('[Force / BW]','NumBubbles',2,'Location',legend_loc, ... 
'FontSize',15,'Box','off','Style','vertical')
    saveas(fig,fullfile(save_graphics,testing_conditions,append(tasks(tr),'MuscleForces2_', testing_conditions, '.pdf')))
end

%% Plot muscle group 3
close all; clear

results_directory="C:\Users\ibrah\OneDrive - KTH\Paper I\Unilateral\Results\Individual Muscle Forces";
results_directory_red="C:\Users\ibrah\OneDrive - KTH\Paper I\Unilateral\Results\Muscle Redundancy";
save_graphics="C:\Users\ibrah\OneDrive - KTH\Paper I\Unilateral\Graphs";
testing_conditions="Postures";
subj_weight=[58, 66.8, 70.7, 79, 58.5, 69.7, 75.7, 58.7, 77, 60.5]*9.81;

muscles=["PectoralisMajorClavicle_S"; "PectoralisMajorThorax_M";
      "PectoralisMajorThorax_I"; "Coracobrachialis"; "BIClong"; "BICshort"; "TRIlong"];

color=[0, 0, 97/255; 130/255 150/255 111/255];

col=[13, 74, 33; 
    77, 160, 97; 
    199, 235, 186 ; 

    120, 0, 26;
    232, 106, 88;

    165, 165, 165;
    230, 230, 230;

    0, 71, 145;
    98, 152, 210;

    166, 89, 0;
    255, 190, 0;
    255, 240, 176;

 
    111, 41, 125; 
    255, 0, 255;

    0, 0, 255;
    0, 50, 138;
    178, 224, 224]/255;

tasks=["Lateral_Raise_Head", "Front_Raise_Head", "Extension"];
trials=["Lateral Raise", "Anterior Raise", "Posterior Raise"];
Postures=["Upright", "Slouched"];
load(fullfile(results_directory,"Muscles_Forces_CoP_ModelsPostures.mat"));


for tr=1:3
    fig=figure;
    for m=1:length(muscles)
        for s=1:10
            if s==10
                SS='S'; 
            else
                SS='S0';
            end
            table_cond1=readtable(fullfile(results_directory_red,string(SS)+string(s)+"\","Unlocked\muscle_activations_Upright_"+tasks(tr)+".txt"));
            r(s)=mean(table_cond1.radius);
            F_Slouched=eval(append('muscles_param.', SS,string(s),'.', char(tasks(tr)),'.','Slouching.Unlocked.',char(muscles(m)),'.Ftime'));
            isn=~isnan(F_Slouched);
            Mag_Slouched=norm(mean(F_Slouched(find(isn(:,1)==1),:)))/subj_weight(s);
            Direction_Slouched=eval(append('muscles_param.', SS,string(s),'.', char(tasks(tr)),'.','Slouching.Unlocked.',char(muscles(m)),'.bubble'));
            Direction_Slouched(4)=Mag_Slouched;
            bubble_slouched(s,:)=Direction_Slouched;


            F_Upright=eval(append('muscles_param.', SS,string(s),'.', char(tasks(tr)),'.','Upright.Unlocked.',char(muscles(m)),'.Ftime'));
            isn=~isnan(F_Upright);
            Mag_Upright=norm(mean(F_Upright(find(isn(:,1)==1),:)))/subj_weight(s);
            Direction_Upright=eval(append('muscles_param.', SS,string(s),'.', char(tasks(tr)),'.','Upright.Unlocked.',char(muscles(m)),'.bubble'));
            Direction_Upright(4)=Mag_Upright;
            bubble_upright(s,:)=Direction_Upright;
        end

        if mean(bubble_upright(:,4))<0.01
            flags(m)=m;

        else
            flags(m)=0;
        end
        nan_up=isnan(bubble_upright);
        bubble_upright(nan_up(:,1),:)=[];

        nan_sl=isnan(bubble_slouched);
        bubble_slouched(nan_sl(:,1),:)=[];

        hold on
        bubup(m)=bubblechart(-mean(bubble_upright(:,2))/10,-mean(bubble_upright(:,3))/10,round(mean(bubble_upright(:,4)),2),col(m,:), ... 
                     MarkerEdgeColor=color(1,:),MarkerFaceAlpha=0.7,LineWidth=2);
        
        bubsl(m)=bubblechart(-mean(bubble_slouched(:,2))/10,-mean(bubble_slouched(:,3))/10,round(mean(bubble_slouched(:,4)),2),col(m,:), ... 
                     MarkerEdgeColor=color(2,:),MarkerFaceAlpha=0.7,LineWidth=2);
        

        

        % xlim([-30 20])
        % ylim([-30 20])
        xlabel("X [cm]")
        ylabel("Y [cm]")
        clear Loc
        ax = gca;
        ax.FontSize = 28;
        % axis square
        box off
    end
    p=nsidedpoly(1000, 'Center', [0,0], 'Radius', mean(r)/10);
    pp=plot(p, "FaceColor",'none','LineWidth',1,'LineStyle','--');
    
    uistack(bubup(flags(flags~=0)),"top");
    uistack(bubsl(flags(flags~=0)),"top");
    uistack(pp,'top')
    scatter(0, 0,150, [0, 0, 0]/255, 'Marker','x',LineWidth=3)
    title(trials(tr))

    if trials(tr)=="Posterior Raise"
        xlim([-10 50])
        ylim([-40 15])
        legend_loc='southwest';
    elseif trials(tr)=="Lateral Raise"
        xlim([-8 12])
        %ylim([-15 5])
        legend_loc='southwest';
    else
        xlim([-35 40])
        ylim([-35 15])
        legend_loc='southwest';
    end
    axis equal
    bubblelegend('[Force / BW]','NumBubbles',2,'Location',legend_loc, ... 
'FontSize',15,'Box','off','Style','vertical')
    saveas(fig,fullfile(save_graphics,testing_conditions,append(tasks(tr),'MuscleForces3_', testing_conditions, '.pdf')))
end

%% Perform statistical analysis
%Test significance on the first coordinate
function signftest(vp,gpos,cpos,range,var)
    for tip=1:length(cpos)

        for i=1:10
            plot([vp.sc(tip).XData(i); vp.sc(tip+length(vp.cpos)).XData(i)],[var(i,tip); var(i+10,tip)],LineWidth=0.2,Color=[0.2 0.2 0.2])
            %plot(vp.gpos(1:2,tip),[GH_angles(i,tip); GH_angles(i+10,tip)],LineWidth=1,Color=[0.5 0.5 0.5])
            %scatter(gpos(1,tip),var(i,tip),30,[0.6471 0.6471 0.6471],"filled","o",'MarkerEdgeColor',[0 0 0])
            %scatter(gpos(2,tip),var(i+10,tip),30,[0.6471 0.6471 0.6471],"filled","o",'MarkerEdgeColor',[0 0 0])
        end
    
        [fl(tip),~] = swtest(var(1:10,tip),0.5); % 1 means normally distrubted
        [fu(tip),~] = swtest(var(11:20,tip),0.5); % 1 means normally distrubted
    
        %Do Statistical significance test
        if fl(tip) == 0 && fu(tip)== 0
            hn(tip)=ttest(var(1:10,tip),var(11:20,tip)); %Paired t test if data comes from a normal distribution
            % 1 = rejecting the null hypothesis that means are the same
            % (significantly different)
            hu(tip)=0;
        else
            %[~,h(p)] = signtest(Locked,Unlocked); %
            [~,hu(tip)]=signrank(var(1:10,tip),var(11:20,tip)); %Wilcoxon rank sum test if the data is not normally distributed
            %hu(tip)=ttest(MA_box(1:5,tip),MA_box(6:10,tip));
            hn(tip)=0;
        end
        L=max(var(:,tip));
        p=mean((gpos(:,tip)));
        %Plot a star indicating statistial significance
        if hn(tip)==1 || hu(tip)==1
            
            if L<0
                L=0.1*range;
            end
            
            if hn(tip)==1
                scatter(p,L+0.2*range,70,LineWidth=1,Marker="*",MarkerEdgeColor=[120, 0, 26]/255)
                plot(gpos(:,tip), [L+0.1*range L+0.1*range],LineWidth=1.5,Color=[120, 0, 26]/255)

            elseif hu(tip) ==1
                scatter(p,L+0.2*range,70,'k*',LineWidth=1)
                plot(gpos(:,tip), [L+0.1*range L+0.1*range],LineWidth=1.5,Color='k')
            end
            
        end
        text(p,L+0.3*range,string(round(mean(-var(1:10,tip)+var(11:20,tip)),1)))
    end
end