%% Plot Muscle Activation
%This script generates Muscle Activation plots with the different
%testing conditions.
%Author: Ibrahim Mohammed I. Hasan (imihasan@kth.se), Promobilia
%MoveAbility Lab, KTH Royal Institute of Technology, Stokholm, Sweden. 
%Scripted: 2025

        
close all; clear all
pathstr=fileparts(matlab.desktop.editor.getActiveFilename);
cd(pathstr+"\..\..");
addpath(pwd)
path_to_repo = pwd;
results_directory=path_to_repo+"\Results\Muscle Redundancy";
save_graphics=path_to_repo+"\Graphs";

conditions=["Locked", "Unlocked"];
folders=dir(results_directory);
testing_conditions="Models";

group1=["TrapeziusScapula_S", "TrapeziusScapula_M", "TrapeziusScapula_I"];
group2=["SerratusAnterior_S", "SerratusAnterior_M", "SerratusAnterior_I"];
group3=["DeltoideusClavicle_A", "DeltoideusScapula_M", "DeltoideusScapula_P"];
group4=["LatissimusDorsi_S", "LatissimusDorsi_M", "LatissimusDorsi_I"];
group5=["PectoralisMajorClavicle_S", "PectoralisMajorThorax_M", "PectoralisMajorThorax_I"];
group6=["Subscapularis_S", "Subscapularis_M", "Subscapularis_I"];
group7=[ "Infraspinatus_I", "Infraspinatus_S", "PectoralisMinor"];
group8=["Rhomboideus_S", "Rhomboideus_I", "Coracobrachialis"];
group9=["Supraspinatus_P"    "Supraspinatus_A"    "BIClong"];
group10=[ "TRIlat" "TRImed" "TRIlong" ];
group11=["TeresMinor" "TeresMajor" "Brachiorad"];
group12=["PronatorTeres"    "Supinator"    "PronatorQuad"];
group13=["TrapeziusClavicle_S" "Anconeus" "LevatorScapulae"];
group14=["TRIlong" "BIClong" "BICshort" ];

tasks=["Lateral_Raise_Head", "Front_Raise_Head", "Extension"];
tials_legend=["Lateral Raise", "Anterior Raise", "Posterior Raise"];
muscles=group3;
iden=muscles;

fig1=figure(1);
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
            color=[111 41 125; 170 170 170]/255;
            Legend=["Locked", "Unlocked"];

        end
        time=table_cond1.time;


        

        DelA_cond1{tr}(s,:)=eval(['table_cond1.' char(muscles(1))]);
        DelA_cond2{tr}(s,:)=eval(['table_cond2.' char(muscles(1))]);

        DelM_cond1{tr}(s,:)=eval(['table_cond1.' char(muscles(2))]);
        DelM_cond2{tr}(s,:)=eval(['table_cond2.' char(muscles(2))]);

        DelP_cond1{tr}(s,:)=eval(['table_cond1.' char(muscles(3))]);
        DelP_cond2{tr}(s,:)=eval(['table_cond2.' char(muscles(3))]);




        s=s+1;
    end


    DelM(:,tr)=[mean(DelM_cond1{tr}')'; mean(DelM_cond2{tr}')'];
    DelA(:,tr)=[mean(DelA_cond1{tr}')'; mean(DelA_cond2{tr}')'];
    DelP(:,tr)=[mean(DelP_cond1{tr}')'; mean(DelP_cond2{tr}')'];

    index=[1*ones(10,1); 2*ones(10,1)];
    

    var=[DelA(:,tr) DelM(:,tr) DelP(:,tr)];  
    subplot(3,1,tr)
    vp = dabarplot(var,'groups',index,'colors',color, 'outliers',0, ... 
         'xtlabels', iden,'scatter',0, 'errorbars',0,...
         'jitter',0,'mean',1, ... 
          'fill', 1,'barwidth',1.5);
    ylim([0 1])
    axis equal
    ax = gca;
    ax.FontSize=10;
    range=ax.YLim(2)-ax.YLim(1);
    hold on

    signftest(vp.gpos,vp.cpos,range,var)
    
    ylabel("Activation")
    title(tials_legend(tr))

end

%saveas(fig1,fullfile(save_graphics,testing_conditions,append('Ligament_Lengthening_', testing_conditions, '.pdf')))
%saveas(fig2,fullfile(save_graphics,testing_conditions,append('GHJCFMagnitude_', testing_conditions, '.pdf')))


%% Significant Muscles Models

%Muscles_LR=["SerratusAnterior_M", "TrapeziusScapula_M"];

% Muscles_LR=["SerratusAnterior_M", "SerratusAnterior_I", "TrapeziusScapula_M",...
%     "DeltoideusScapula_P", "Rhomboideus_S", "Rhomboideus_I", "Coracobrachialis", ...
%     "Subscapularis_S", "TRIlat", "TRImed", "LevatorScapulae"];

Muscles_LR=["SerratusAnterior_M", "SerratusAnterior_I", "TrapeziusScapula_M",...
    "LevatorScapulae", "Subscapularis_S"];


%Muscles_AR=["BIClong", "LevatorScapulae", "Infraspinatus_S"];

Muscles_AR=["BIClong", "LevatorScapulae", "DeltoideusScapula_P"];

Muscles_PR=["Rhomboideus_I", "Rhomboideus_S", "SerratusAnterior_I"];

%Muscles_PR=["Rhomboideus_I", "SerratusAnterior_I"];


index=[1*ones(10,1); 2*ones(10,1)];
close all
fig=figure;
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
            color=[111 41 125; 196, 196, 196]/255;
            Legend=["Locked", "Unlocked"];

        end
        time=table_cond1.time;

        if tials_legend(tr)=="Lateral Raise"
           for m=1:length(Muscles_LR)
               eval([char(Muscles_LR(m)) '_cond1{tr}(s,:)=table_cond1.' char(Muscles_LR(m)) ';']);
               eval([char(Muscles_LR(m)) '_cond2{tr}(s,:)=table_cond2.' char(Muscles_LR(m)) ';']);
           end

        elseif tials_legend(tr)=="Anterior Raise"
           for m=1:length(Muscles_AR)
               eval([char(Muscles_AR(m)) '_cond1{tr}(s,:)=table_cond1.' char(Muscles_AR(m)) ';']);
               eval([char(Muscles_AR(m)) '_cond2{tr}(s,:)=table_cond2.' char(Muscles_AR(m)) ';']);
           end

        elseif tials_legend(tr)=="Posterior Raise"
           for m=1:length(Muscles_PR)
               eval([char(Muscles_PR(m)) '_cond1{tr}(s,:)=table_cond1.' char(Muscles_PR(m)) ';']);
               eval([char(Muscles_PR(m)) '_cond2{tr}(s,:)=table_cond2.' char(Muscles_PR(m)) ';']);
           end  
        end

        s=s+1;
    end

    if tials_legend(tr)=="Lateral Raise"
       for m=1:length(Muscles_LR)       
           cond1=eval([char(Muscles_LR(m)) '_cond1{tr}']);
           cond2=eval([char(Muscles_LR(m)) '_cond2{tr}']);
           var1(:,m)=[mean(cond1')';mean(cond2')'];
           
       end
       subplot(3,1,tr)
       iden=["Serr M", "Serr I", "Trap M", "Levator S", "Subscap S"];

       vp1 = dabarplot(var1,'groups',index,'colors',color, 'outliers',0, ... 
     'xtlabels', iden,'scatter',1, 'errorbars',1,...
     'jitter',1,'mean',1, ... 
      'fill', 1,'barwidth',1.5);
        ylim([0 1])
        
        ax = gca;
        ax.FontSize=12;
        range=ax.YLim(2)-ax.YLim(1);
        hold on
        %axis square
        for tip=1:length(vp1.cpos)
            for i=1:10
                
                plot([vp1.sc(tip).XData(i); vp1.sc(tip+length(vp1.cpos)).XData(i)],[var1(i,tip); var1(i+10,tip)],LineWidth=0.2,Color=[0 0 0])
                %scatter(vp.gpos(1,tip),GH_angles(i,tip),10,[0.6471 0.6471 0.6471],"filled","o",'MarkerEdgeColor',[0 0 0])
                %scatter(vp.gpos(2,tip),GH_angles(i+10,tip),10,[0.6471 0.6471 0.6471],"filled","o",'MarkerEdgeColor',[0 0 0])
            end
        end

        signftest(vp1.gpos,vp1.cpos,range,var1)
    
        
        title(tials_legend(tr))

    elseif tials_legend(tr)=="Anterior Raise"
        
       for m=1:length(Muscles_AR)       
           cond1=eval([char(Muscles_AR(m)) '_cond1{tr}']);
           cond2=eval([char(Muscles_AR(m)) '_cond2{tr}']);
           var2(:,m)=[mean(cond1')';mean(cond2')'];
       end

       iden=["Biceps L", "Levator S", "Deltoid P"];

       subplot(3,1,tr)
          vp2 = dabarplot(var2,'groups',index,'colors',color, 'outliers',0, ... 
     'xtlabels', iden,'scatter',1, 'errorbars',1,...
     'jitter',1,'mean',1, ... 
      'fill', 1,'barwidth',1.5);
        ylim([0 1])
        ylabel("Activation")
        ax = gca;
        ax.FontSize=12;
        range=ax.YLim(2)-ax.YLim(1);
        hold on
        %axis square

        for tip=1:length(vp2.cpos)
            for i=1:10
                plot([vp2.sc(tip).XData(i); vp2.sc(tip+length(vp2.cpos)).XData(i)],[var2(i,tip); var2(i+10,tip)],LineWidth=0.2,Color=[0 0 0])
                %scatter(vp.gpos(1,tip),GH_angles(i,tip),10,[0.6471 0.6471 0.6471],"filled","o",'MarkerEdgeColor',[0 0 0])
                %scatter(vp.gpos(2,tip),GH_angles(i+10,tip),10,[0.6471 0.6471 0.6471],"filled","o",'MarkerEdgeColor',[0 0 0])
            end
        end

        signftest(vp2.gpos,vp2.cpos,range,var2)

        
        title(tials_legend(tr))

    elseif tials_legend(tr)=="Posterior Raise"

       for m=1:length(Muscles_PR)       
           cond1=eval([char(Muscles_PR(m)) '_cond1{tr}']);
           cond2=eval([char(Muscles_PR(m)) '_cond2{tr}']);
           var3(:,m)=[mean(cond1')';mean(cond2')'];
       end

       iden=["Rhomboid Maj", "Rhomboid Min", "Serr I"];

       subplot(3,1,tr)
          vp3 = dabarplot(var3,'groups',index,'colors',color, 'outliers',0, ... 
     'xtlabels', iden,'scatter',1, 'errorbars',1,...
     'jitter',1,'mean',1, ... 
      'fill', 1,'barwidth',1.5);
        ylim([0 1])

        ax = gca;
        ax.FontSize=12;
        range=ax.YLim(2)-ax.YLim(1);
        hold on
        %axis square

        for tip=1:length(vp3.cpos)
            for i=1:10
                plot([vp3.sc(tip).XData(i); vp3.sc(tip+length(vp3.cpos)).XData(i)],[var3(i,tip); var3(i+10,tip)],LineWidth=0.2,Color=[0 0 0])
                %scatter(vp.gpos(1,tip),GH_angles(i,tip),10,[0.6471 0.6471 0.6471],"filled","o",'MarkerEdgeColor',[0 0 0])
                %scatter(vp.gpos(2,tip),GH_angles(i+10,tip),10,[0.6471 0.6471 0.6471],"filled","o",'MarkerEdgeColor',[0 0 0])
            end
        end


        signftest(vp3.gpos,vp3.cpos,range,var3)

      
        title(tials_legend(tr))
    end
    %saveas(fig,fullfile(save_graphics,testing_conditions,append(tials_legend(tr),'MuscleActivation_Bar', '.pdf')))
end
%print(fig, fullfile(save_graphics,testing_conditions,append('MuscleActivation_Bar', '.pdf')), '-dpdf', '-r600')
saveas(fig,fullfile(save_graphics,testing_conditions,append('MuscleActivation_Bar', '.pdf')))
%exportgraphics(ax,fullfile(save_graphics,testing_conditions,append('MuscleActivation_Bar', '.pdf')),'Resolution',600)

%% Plot timeseries of all muscles for each task
load(fullfile(results_directory,string(folders(4).name)+"\","Unlocked\muscle_activations_Upright_"+tasks(1)+".mat"));
close all
tr=1; %latral raise=1, anterior raise=2, posterior raise=3
MUSCLES=muscle_order;
for mus=1:41
    s=1;
    for n=3:length(folders)
        if testing_conditions=="Postures" 
         
            table_cond1=readtable(fullfile(results_directory,string(folders(n).name)+"\","Unlocked\muscle_activations_Upright_"+tasks(tr)+".txt"));
            table_cond2=readtable(fullfile(results_directory,string(folders(n).name)+"\","Unlocked\muscle_activations_Slouching_"+tasks(tr)+".txt"));
            color=[0, 0, 97/255; 130/255 150/255 111/255];
            Legend=["Upright", "Slouched"];
        elseif testing_conditions=="Models"
            table_cond1=readtable(fullfile(results_directory,string(folders(n).name)+"\","Locked\muscle_activations_Slouching_"+tasks(tr)+".txt"));
            table_cond2=readtable(fullfile(results_directory,string(folders(n).name)+"\","Unlocked\muscle_activations_Slouching_"+tasks(tr)+".txt"));
            color=[111/255 41/255 125/255; 130/255 150/255 111/255];
            Legend=["Locked", "Unlocked"];
    
        end
        muscle_cond1(s,:)=eval(['table_cond1.' char(MUSCLES(mus))]);
        muscle_cond2(s,:)=eval(['table_cond2.' char(MUSCLES(mus))]);
        time=table_cond1.time;
        s=s+1;
    end
    % figure;
    subplot(6,5,mus)
    stdevShade(time',mean(muscle_cond1),std(muscle_cond1),color(1,:),0.2)
    hold on
    stdevShade(time',mean(muscle_cond2),std(muscle_cond2),color(2,:),0.2)
    title(MUSCLES(mus))
    ylim([0 1])
    %ax=gca;

end


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
function signftest(gpos,cpos,range,var)
    for tip=1:length(cpos)

        for i=1:10
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
    
        %Plot a star indicating statistial significance
        if hn(tip)==1 || hu(tip)==1
    
            L=max(var(:,tip));
            if L<0
                L=0.1*range;
            end
            p=mean((gpos(:,tip)));
            if hn(tip)==1
                scatter(p,L+0.2*range,30,LineWidth=0.8,Marker="*",MarkerEdgeColor=[120, 0, 26]/255)
                plot(gpos(:,tip), [L+0.1*range L+0.1*range],LineWidth=1,Color=[120, 0, 26]/255)

            elseif hu(tip) ==1
                scatter(p,L+0.2*range,30,'k*',LineWidth=0.8)
                plot(gpos(:,tip), [L+0.1*range L+0.1*range],LineWidth=1,Color='k')
            end
        end
    end
end
