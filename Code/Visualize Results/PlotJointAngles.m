%% Plot joint angles
%This script generates ploar plots and timeseries plots of the joint angles 
%with the different testing conditions.
%Author: Ibrahim Mohammed I. Hasan (imihasan@kth.se), Promobilia
%MoveAbility Lab, KTH Royal Institute of Technology, Stokholm, Sweden. 
%Scripted: 2025

%% 
clear all
pathstr=fileparts(matlab.desktop.editor.getActiveFilename);
cd(pathstr+"\..\..");
addpath(pwd)
path_to_repo = pwd;
results_directory=path_to_repo+"\Results\Muscle Analysis";
save_graphics=path_to_repo+"\Graphs";
conditions=["Locked", "Unlocked"];
folders=dir(results_directory);

%% Write .mat files to .txt files
for f=3:length(folders)
    %conditions=dir(fullfile(results_directory,string(folders(f).name)));
    for cond=1:2
        trials=dir(fullfile(results_directory,string(folders(f).name)+"\",conditions(cond),'*.mat'));
        for t=1:length(trials)
            load(fullfile(results_directory,string(folders(f).name)+"\",conditions(cond),trials(t).name));
            [timeN, CoordN]=normalize(timesExp,coordinates');
            Tab = array2table([timeN' CoordN'],'VariableNames',["time"; coordNames]);
            writetable(Tab, fullfile(results_directory,string(folders(f).name)+"\",conditions(cond),trials(t).name(1:end-4) +".txt"));
            clear coordNames coordinates timesExp timeN CoordN
            fprintf("Writing file: " + string(folders(f).name)+ "_" + conditions(cond) + "_" + string(trials(t).name(1:end-4)) +".txt" +"\n")
        end
    end
    
end

%% Restructure the data and plot timeseries with std shades
close all
testing_conditions="Postures";
joint="Glenohumeral";
tasks=["Lateral_Raise_Head", "Front_Raise_Head", "Extension"];
tials_legend=["Lateral Raise", "Anterior Raise", "Posterior Raise"];
coord_Names=["Total Shoulder Elevation", "Humeral Rotation", ... 
    "Plane of Elevation", "Scapula Up Rot", "Scapula Abd", "Scapula Elev" ...
    , "Scapula Winging"];
fig1=figure(1);

fig2=figure(2);

for cood=1:length(coord_Names)
    
    for tr=1:3
        s=1;
        for n=4:length(folders)
            if testing_conditions=="Postures" 
            
                table_cond1=readtable(fullfile(results_directory,string(folders(n).name)+"\","Unlocked\Moment_Arms_Upright_"+tasks(tr)+".txt"));
                table_cond2=readtable(fullfile(results_directory,string(folders(n).name)+"\","Unlocked\Moment_Arms_Slouching_"+tasks(tr)+".txt"));
                color=[0, 0, 97/255; 130/255 150/255 111/255];
                Legend=["Upright", "Slouched"];
            elseif testing_conditions=="Models"
                table_cond1=readtable(fullfile(results_directory,string(folders(n).name)+"\","Locked\Moment_Arms_Slouching_"+tasks(tr)+".txt"));
                table_cond2=readtable(fullfile(results_directory,string(folders(n).name)+"\","Unlocked\Moment_Arms_Slouching_"+tasks(tr)+".txt"));
                color=[111 41 125; 170, 170, 170]/255;
                Legend=["Locked", "Unlocked"];

            end
            shoulder_elevation_cond1{tr}(s,:)=table_cond1.shoulder_elv';
            shoulder_elevation_cond2{tr}(s,:)=table_cond2.shoulder_elv';

            total_elevation_cond1{tr}(s,:)=table_cond1.scapula_upward_rot'+table_cond1.shoulder_elv';
            total_elevation_cond2{tr}(s,:)=table_cond2.scapula_upward_rot'+table_cond2.shoulder_elv';

            axial_rotation_cond1{tr}(s,:)=table_cond1.axial_rot';
            axial_rotation_cond2{tr}(s,:)=table_cond2.axial_rot';

            plane_elevation_cond1{tr}(s,:)=table_cond1.plane_elv';
            plane_elevation_cond2{tr}(s,:)=table_cond2.plane_elv';
            time=table_cond1.time;
            
            scapula_abduction_cond1{tr}(s,:)=table_cond1.scapula_abduction';
            scapula_abduction_cond2{tr}(s,:)=table_cond2.scapula_abduction';

            scapula_elevation_cond1{tr}(s,:)=table_cond1.scapula_elevation';
            scapula_elevation_cond2{tr}(s,:)=table_cond2.scapula_elevation';

            scapula_upward_rot_cond1{tr}(s,:)=table_cond1.scapula_upward_rot';
            scapula_upward_rot_cond2{tr}(s,:)=table_cond2.scapula_upward_rot';

            scapula_winging_cond1{tr}(s,:)=table_cond1.scapula_winging';
            scapula_winging_cond2{tr}(s,:)=table_cond2.scapula_winging';

            lumb_angle_cond1{tr}(s,:)=(-table_cond1.ground_pelvis_coord_2+table_cond1.L5_S1_Flex_Ext+...
                table_cond1.L4_L5_Flex_Ext+table_cond1.L3_L4_Flex_Ext+...
                table_cond1.L2_L3_Flex_Ext+table_cond1.L1_L2_Flex_Ext+...
                table_cond1.L1_T12_Flex_Ext)';

           lumb_angle_cond1{tr}(s,:)=lumb_angle_cond1{tr}(s,:)-lumb_angle_cond1{tr}(s,1);

           lumb_angle_cond2{tr}(s,:)=(-table_cond2.ground_pelvis_coord_2+table_cond2.L5_S1_Flex_Ext+...
                table_cond2.L4_L5_Flex_Ext+table_cond2.L3_L4_Flex_Ext+...
                table_cond2.L2_L3_Flex_Ext+table_cond2.L1_L2_Flex_Ext+...
                table_cond2.L1_T12_Flex_Ext)';

           lumb_angle_cond2{tr}(s,:)=lumb_angle_cond2{tr}(s,:)-lumb_angle_cond2{tr}(s,1);

           pelvis_angle_cond1{tr}(s,:)=(-table_cond1.ground_pelvis_coord_2+table_cond1.ground_pelvis_coord_2(1));
           pelvis_angle_cond2{tr}(s,:)=(-table_cond2.ground_pelvis_coord_2+table_cond2.ground_pelvis_coord_2(1));

            s=s+1;
        end

        if coord_Names(cood)=="Total Shoulder Elevation"
            figure(1)
            subplot(3,3,tr)
            stdevShade(time',rad2deg(mean(total_elevation_cond1{tr})), ... 
            std(rad2deg(total_elevation_cond1{tr})),color(1,:),   0.2)
            hold on
            stdevShade(time',rad2deg(mean(total_elevation_cond2{tr})), ... 
                std(rad2deg(total_elevation_cond2{tr})),color(2,:),0.2)
            title(tials_legend(tr), 'Interpreter','none')
            xlabel("%Task")
            ylabel("Elevation ^{o}")
            ax=gca;
            ax.FontSize=10;
            % ylim([40 160])
            box off
            %axis square
        elseif coord_Names(cood)=="Humeral Rotation"
            figure(1)
            subplot(3,3,3+tr)
            stdevShade(time',rad2deg(mean(axial_rotation_cond1{tr})), ... 
            std(rad2deg(axial_rotation_cond1{tr})),color(1,:),0.2)
            hold on
            stdevShade(time',rad2deg(mean(axial_rotation_cond2{tr})), ... 
                std(rad2deg(axial_rotation_cond2{tr})),color(2,:),0.2)
            %title(tials_legend(tr), 'Interpreter','none')
            xlabel("%Task")
            ylabel("Axial Rotation ^{o}")
            ax=gca;
            ax.FontSize=10;
            % ylim([-70 100])
            box off
            %axis square
        elseif coord_Names(cood)=="Plane of Elevation"
            figure(1)
            subplot(3,3,6+tr)
            stdevShade(time',rad2deg(mean(plane_elevation_cond1{tr})), ... 
            std(rad2deg(plane_elevation_cond1{tr})),color(1,:),0.2)
            hold on
            stdevShade(time',rad2deg(mean(plane_elevation_cond2{tr})), ... 
                std(rad2deg(plane_elevation_cond2{tr})),color(2,:),0.2)
            %title(tials_legend(tr), 'Interpreter','none')
            xlabel("%Task")
            ylabel("Plane Elevation ^{o}")
            ax=gca;
            ax.FontSize=10;
            % ylim([-100 70])
            box off
            %axis square
        elseif coord_Names(cood)=="Scapula Up Rot"
            figure(2)
            subplot(4,3,tr)
            stdevShade(time',rad2deg(mean(scapula_upward_rot_cond1{tr})), ... 
            std(rad2deg(scapula_upward_rot_cond1{tr})),color(1,:),0.2)
            hold on
            stdevShade(time',rad2deg(mean(scapula_upward_rot_cond2{tr})), ... 
                std(rad2deg(scapula_upward_rot_cond2{tr})),color(2,:),0.2)

            xlabel("%Task")
            ylabel("U Rot ^{o}")
            ax=gca;
            ax.FontSize=9;
            ylim([0 60])
            title(tials_legend(tr), 'Interpreter','none')
            box off
            %axis square
        elseif coord_Names(cood)=="Scapula Abd"
            figure(2)
            subplot(4,3,3+tr)
            stdevShade(time',rad2deg(mean(scapula_abduction_cond1{tr})), ... 
            std(rad2deg(scapula_abduction_cond1{tr})),color(1,:),0.2)
            hold on
            stdevShade(time',rad2deg(mean(scapula_abduction_cond2{tr})), ... 
                std(rad2deg(scapula_abduction_cond2{tr})),color(2,:),0.2)

            xlabel("%Task")
            ylabel("Abd ^{o}")
            ax=gca;
            ax.FontSize=9;
            % ylim([-30 5])
            box off
            %axis square
        elseif coord_Names(cood)=="Scapula Elev"
            figure(2)
            subplot(4,3,6+tr)
            stdevShade(time',rad2deg(mean(scapula_elevation_cond1{tr})), ... 
            std(rad2deg(scapula_elevation_cond1{tr})),color(1,:),0.2)
            hold on
            stdevShade(time',rad2deg(mean(scapula_elevation_cond2{tr})), ... 
                std(rad2deg(scapula_elevation_cond2{tr})),color(2,:),0.2)

            xlabel("%Task")
            ylabel("Elev ^{o}")
            ax=gca;
            ax.FontSize=9;
            % ylim([-15 5])
            box off
            %axis square
        elseif coord_Names(cood)=="Scapula Winging"
            figure(2)
            subplot(4,3,9+tr)
            stdevShade(time',rad2deg(mean(scapula_winging_cond1{tr})), ... 
            std(rad2deg(scapula_winging_cond1{tr})),color(1,:),0.2)
            hold on
            stdevShade(time',rad2deg(mean(scapula_winging_cond2{tr})), ... 
                std(rad2deg(scapula_winging_cond2{tr})),color(2,:),0.2)

            xlabel("%Task")
            ylabel("Winging ^{o}")
            ax=gca;
            ax.FontSize=9;
            % ylim([-10 30])
            box off
            %axis square
        end

    end

end

legend("",Legend(1), "", Legend(2))
saveas(fig1,fullfile(save_graphics,testing_conditions,'GHJoint_angles_timeseries.pdf'))
saveas(fig2,fullfile(save_graphics,testing_conditions,'ScapulothoracicJoin_angles_timeseries.pdf'))



%% Plot bar plots of the GH joint angles with statistical significance
close all
index=[1*ones(10,1); 2*ones(10,1)];
iden=["SE"; "PE"; "AR"];
fig=figure;

for tr=1:length(tasks)
    sh_elv=[mean(rad2deg(shoulder_elevation_cond1{tr}'))'; mean(rad2deg(shoulder_elevation_cond2{tr}'))'];
    p_elv=[mean(rad2deg(plane_elevation_cond1{tr}'))'; mean(rad2deg(plane_elevation_cond2{tr}'))'];
    ax_rot=[mean(rad2deg(axial_rotation_cond1{tr}'))'; mean(rad2deg(axial_rotation_cond2{tr}'))'];
    GH_angles=[sh_elv p_elv ax_rot];
    subplot(1,3,tr)
    vp = dabarplot(GH_angles,'groups',index,'colors',color, 'outliers',0, ... 
         'xtlabels', iden,'scatter',1, 'errorbars',0,...
         'jitter',0,'mean',1, ... 
          'fill', 1,'barwidth',1.5);

    axis square
    ax = gca;
    ax.FontSize=10;
    range=ax.YLim(2)-ax.YLim(1);
    hold on
    for tip=1:length(vp.cpos)

        for i=1:10
            plot([vp.sc(tip).XData(i); vp.sc(tip+length(vp.cpos)).XData(i)],[GH_angles(i,tip); GH_angles(i+10,tip)],LineWidth=0.2,Color=[0 0 0])
            %scatter(vp.gpos(1,tip),GH_angles(i,tip),10,[0.6471 0.6471 0.6471],"filled","o",'MarkerEdgeColor',[0 0 0])
            %scatter(vp.gpos(2,tip),GH_angles(i+10,tip),10,[0.6471 0.6471 0.6471],"filled","o",'MarkerEdgeColor',[0 0 0])
        end
    
        [fl(tip),~] = swtest(GH_angles(1:10,tip),0.5); % 1 means normally distrubted
        [fu(tip),~] = swtest(GH_angles(11:20,tip),0.5); % 1 means normally distrubted
    
        %Do Statistical significance test
        if fl(tip) == 0 && fu(tip)== 0
            hn(tip)=ttest(GH_angles(1:10,tip),GH_angles(11:20,tip)); %Paired t test if data comes from a normal distribution
            % 1 = rejecting the null hypothesis that means are the same
            % (significantly different)
            hu(tip)=0;
        else
            %[~,h(p)] = signtest(Locked,Unlocked); %
            [~,hu(tip)]=signrank(GH_angles(1:10,tip),GH_angles(11:20,tip)); %Wilcoxon rank sum test if the data is not normally distributed
            %hu(tip)=ttest(MA_box(1:5,tip),MA_box(6:10,tip));
            hn(tip)=0;
        end
    
        %Plot a star indicating statistial significance
        if hn(tip)==1 || hu(tip)==1
    
            L=max(GH_angles(:,tip));
            if L<0
                L=0.1*range;
            end
            p=mean((vp.gpos(:,tip)));
            if hn(tip)==1
                scatter(p,L+0.2*range,30,LineWidth=0.8,Marker="*",MarkerEdgeColor=[120, 0, 26]/255)
                plot(vp.gpos(:,tip), [L+0.1*range L+0.1*range],LineWidth=1,Color=[120, 0, 26]/255)

            elseif hu(tip) ==1
                scatter(p,L+0.2*range,30,'k*',LineWidth=0.8)
                plot(vp.gpos(:,tip), [L+0.1*range L+0.1*range],LineWidth=1,Color='k')
            end
        end
    end
    
    ylabel("Angle ^{[o]}")
    title(tials_legend(tr))
end
saveas(fig,fullfile(save_graphics,testing_conditions,'GHJoint_angles_Bar.pdf'))

%% Plot bar plots of the Scapulothoracic joint angles with statistical significance

index=[1*ones(10,1); 2*ones(10,1)];
iden=["E"; "A"; "R"; "W"];
fig=figure;

for tr=1:length(tasks)
    sc_elv=[mean(rad2deg(scapula_elevation_cond1{tr}'))'; mean(rad2deg(scapula_elevation_cond2{tr}'))'];
    sc_abd=[mean(rad2deg(scapula_abduction_cond1{tr}'))'; mean(rad2deg(scapula_abduction_cond2{tr}'))'];
    sc_urot=[mean(rad2deg(scapula_upward_rot_cond1{tr}'))'; mean(rad2deg(scapula_upward_rot_cond2{tr}'))'];
    sc_wing=[mean(rad2deg(scapula_winging_cond1{tr}'))'; mean(rad2deg(scapula_winging_cond2{tr}'))'];

    GH_angles=[sc_elv sc_abd sc_urot sc_wing];
    subplot(1,3,tr)
    vp = dabarplot(GH_angles,'groups',index,'colors',color, 'outliers',0, ... 
         'xtlabels', iden,'scatter',1, 'errorbars',0,...
         'jitter',0,'mean',1, ... 
          'fill', 1,'barwidth',1.5);

    axis square
    ax = gca;
    ax.FontSize=10;
    range=ax.YLim(2)-ax.YLim(1);
    hold on
    for tip=1:length(vp.cpos)

        for i=1:10
            plot([vp.sc(tip).XData(i); vp.sc(tip+length(vp.cpos)).XData(i)],[GH_angles(i,tip); GH_angles(i+10,tip)],LineWidth=0.2,Color=[0 0 0])
            %scatter(vp.gpos(1,tip),GH_angles(i,tip),10,[0.6471 0.6471 0.6471],"filled","o",'MarkerEdgeColor',[0 0 0])
            %scatter(vp.gpos(2,tip),GH_angles(i+10,tip),10,[0.6471 0.6471 0.6471],"filled","o",'MarkerEdgeColor',[0 0 0])
        end
    
        [fl(tip),~] = swtest(GH_angles(1:10,tip),0.5); % 0 means normally distrubted
        [fu(tip),~] = swtest(GH_angles(11:20,tip),0.5); % 0 means normally distrubted
    
        %Do Statistical significance test
        if fl(tip) == 0 && fu(tip)== 0
            hn(tip)=ttest(GH_angles(1:10,tip),GH_angles(11:20,tip)); %Paired t test if data comes from a normal distribution
            % 1 = rejecting the null hypothesis that means are the same
            % (significantly different)
            hu(tip)=0;
        else
            [~,hu(tip)]=signrank(GH_angles(1:10,tip),GH_angles(11:20,tip)); %Wilcoxon rank sum test if the data is not normally distributed
            hn(tip)=0;
        end
    
        %Plot a star indicating statistial significance
        if hn(tip)==1 || hu(tip)==1
    
            L=max(GH_angles(:,tip));
            if L<0
                L=0.2*range;
            end
            p=mean((vp.gpos(:,tip)));
            if hn(tip)==1
                scatter(p,L+0.2*range,30,LineWidth=0.8,Marker="*",MarkerEdgeColor=[120, 0, 26]/255)
                plot(vp.gpos(:,tip), [L+0.1*range L+0.1*range],LineWidth=1,Color=[120, 0, 26]/255)
            elseif hu(tip) ==1
                scatter(p,L+0.2*range,30,'k*',LineWidth=0.8)
                plot(vp.gpos(:,tip), [L+0.1*range L+0.1*range],LineWidth=1,Color='k')
            end
    
            
        end
    end
    
    ylabel("Angle ^{[o]}")
    title(tials_legend(tr))
end
saveas(fig,fullfile(save_graphics,testing_conditions,'SCJoint_angles_Bar.pdf'))
%% Plot total shoulder elevation vs. humeral axial rotation
close all
fig=figure;
for tr=1:3

    subplot(1,3,tr)

    
    polarplot(mean(total_elevation_cond2{tr})'-pi/2,rad2deg(mean(axial_rotation_cond2{tr})')+90,Color=color(2,:),LineWidth=2);
    hold on
    polarplot(mean(total_elevation_cond1{tr})'-pi/2,rad2deg(mean(axial_rotation_cond1{tr})')+90,Color=color(1,:),LineWidth=2);


    ax=gca;
    ax.FontSize=12;
    ax.RColor=[166, 89, 0]/255;
    ax.ThetaColor=[165, 165, 165]/255;
    ax.RAxisLocation=115;
    ax.ThetaLim=[-90 60];
    ax.GridAlpha=0.3;

    if tr==1
        ax.RLim=[50 115];
    elseif tr==2
        ax.RLim=[39 95];
    else
        ax.RLim=[100 165];
    end
    
    statis_test(mean(total_elevation_cond1{tr}'),... 
        mean(total_elevation_cond2{tr}'),...
        mean(axial_rotation_cond1{tr}'),...
        mean(axial_rotation_cond2{tr}'),"Total Elevation",...
        "Axial Rotation");

    title(tials_legend(tr),Interpreter="none")
end

saveas(fig,fullfile(save_graphics,testing_conditions,'shoulder_elevation_vs_humeral_axial_rotation.pdf'))

%% Plot total elevation vs. plane of elevation 

% close all
fig=figure;
for tr=1:3

    %here we plot the angles
    
    subplot(1,3,tr)
    polarplot(mean(total_elevation_cond2{tr})'-pi/2,rad2deg(mean(plane_elevation_cond2{tr})')+90,Color=color(2,:),LineWidth=2);
    hold on
    polarplot(mean(total_elevation_cond1{tr})'-pi/2,rad2deg(mean(plane_elevation_cond1{tr})')+90,Color=color(1,:),LineWidth=2);


    ax=gca;
    ax.FontSize=12;
    ax.RColor=[166, 89, 0, 0.3*255]/255;
    ax.ThetaColor=[165, 165, 165 0.3*255]/255;
    ax.RAxisLocation=115;
    ax.ThetaLim=[-90 60];
    ax.GridAlpha=0.3;
    
    % 
    if tr==1
        ax.RLim=[50 85];
    elseif tr==2
        ax.RLim=[110 140];
    else
    end

        statis_test(mean(total_elevation_cond1{tr}'),... 
        mean(total_elevation_cond2{tr}'),...
        mean(plane_elevation_cond1{tr}'),...
        mean(plane_elevation_cond2{tr}'),"Total Elevation",...
        "Plane of Elevation");

    title(tials_legend(tr),Interpreter="none")
end
saveas(fig,fullfile(save_graphics,testing_conditions,'shoulder_elevation_vs_plane_of_elevation.pdf'))

%% Plot scapula upward rotation vs. abduction
close all
fig=figure;
for tr=1:3

    %here we plot the angles
    subplot(1,3,tr)
    polarplot(mean(scapula_upward_rot_cond1{tr})'-pi/2,rad2deg(mean(scapula_abduction_cond1{tr})')+180,Color=color(1,:),LineWidth=2);
    hold on
    polarplot(mean(scapula_upward_rot_cond2{tr})'-pi/2,rad2deg(mean(scapula_abduction_cond2{tr})')+180,Color=color(2,:),LineWidth=2);


    ax=gca;
    ax.FontSize=12;
    ax.RColor=[166, 89, 0, 0.3*255]/255;
    ax.ThetaColor=[165, 165, 165 0.3*255]/255;
    ax.RAxisLocation=115;
    ax.ThetaLim=[-90 60];
    ax.RLim=[158 175];
    

    statis_test(mean(scapula_upward_rot_cond1{tr}'),... 
    mean(scapula_upward_rot_cond2{tr}'),...
    mean(scapula_abduction_cond1{tr}'),...
    mean(scapula_abduction_cond2{tr}'),"Upward Rotation",...
    "Abduction");

    title(tials_legend(tr),Interpreter="none")
end
%saveas(fig,fullfile(save_graphics,testing_conditions,'Scapula_Up_Rot_vs_Scapula_Abduction.pdf'))

%% Plot scapula upward rotation vs. elevation
close all
fig=figure;
for tr=1:3

    %here we plot the angles
    subplot(1,3,tr)
    polarplot(mean(scapula_upward_rot_cond1{tr})'-pi/2,rad2deg(mean(scapula_elevation_cond1{tr})')+180,Color=color(1,:),LineWidth=2);
    hold on
    polarplot(mean(scapula_upward_rot_cond2{tr})'-pi/2,rad2deg(mean(scapula_elevation_cond2{tr})')+180,Color=color(2,:),LineWidth=2);


    ax=gca;
    ax.FontSize=12;
    ax.RColor=[166, 89, 0, 0.3*255]/255;
    ax.ThetaColor=[165, 165, 165 0.3*255]/255;
    ax.RAxisLocation=115;
    ax.ThetaLim=[-90 60];
    ax.RLim=[170 180];
    

    statis_test(mean(scapula_upward_rot_cond1{tr}'),... 
    mean(scapula_upward_rot_cond2{tr}'),...
    mean(scapula_elevation_cond1{tr}'),...
    mean(scapula_elevation_cond2{tr}'),"Upward Rotation",...
    "Elevation");

    title(tials_legend(tr),Interpreter="none")
end

%% Plot scapula upward rotation vs. Winging
close all
fig=figure;
for tr=1:3

    %here we plot the angles
    subplot(1,3,tr)
    polarplot(mean(scapula_upward_rot_cond1{tr})'-pi/2,rad2deg(mean(scapula_winging_cond1{tr})')+180,Color=color(1,:),LineWidth=2);
    hold on
    polarplot(mean(scapula_upward_rot_cond2{tr})'-pi/2,rad2deg(mean(scapula_winging_cond2{tr})')+180,Color=color(2,:),LineWidth=2);


    ax=gca;
    ax.FontSize=12;
    ax.RColor=[166, 89, 0, 0.3*255]/255;
    ax.ThetaColor=[165, 165, 165 0.3*255]/255;
    ax.RAxisLocation=115;
    ax.ThetaLim=[-90 60];
    ax.RLim=[180 195];
    

    statis_test(mean(scapula_upward_rot_cond1{tr}'),... 
    mean(scapula_upward_rot_cond2{tr}'),...
    mean(scapula_winging_cond1{tr}'),...
    mean(scapula_winging_cond2{tr}'),"Upward Rotation",...
    "Winging");

    title(tials_legend(tr),Interpreter="none")
    
end

%% Plot lumbar spine flexion/extension angle 
fig=figure;
for tr=1:3
    subplot(2,3,tr)

    stdevShadeLine(time',-rad2deg(mean(lumb_angle_cond1{tr})), ... 
    std(rad2deg(lumb_angle_cond1{tr})),color(1,:),   0.2, 2, '-')
    hold on
    plot(time',-rad2deg(mean(pelvis_angle_cond1{tr})),'Color',color(1,:),  LineWidth=1, LineStyle='--')

    stdevShadeLine(time',-rad2deg(mean(lumb_angle_cond2{tr})), ... 
    std(rad2deg(lumb_angle_cond2{tr})),color(2,:),   0.2, 2, '-')
    plot(time',-rad2deg(mean(pelvis_angle_cond2{tr})),'Color',color(2,:),  LineWidth=1, LineStyle='--')
    
    title(tials_legend(tr),Interpreter="none")
    ax=gca;
    ax.FontSize=10;
    ylabel("Trunk tilt ^{[o]}")
    xlabel("% Task")
    ylim([-35 27])
    box off
    axis square
    lumb_angle(:,tr)=[mean(lumb_angle_cond1{tr}')'; mean(lumb_angle_cond2{tr}')'];
end
saveas(fig,fullfile(save_graphics,testing_conditions,'Lumbar_Spine_Angle.pdf'))


mean(mean(pelvis_angle_cond2{1}))/mean(mean(lumb_angle_cond2{1}))
mean(mean(pelvis_angle_cond2{2}))/mean(mean(lumb_angle_cond2{2}))
mean(mean(pelvis_angle_cond2{3}))/mean(mean(lumb_angle_cond2{3}))

mean(mean(pelvis_angle_cond1{1}))/mean(mean(lumb_angle_cond1{1}))
mean(mean(pelvis_angle_cond1{2}))/mean(mean(lumb_angle_cond1{2}))
mean(mean(pelvis_angle_cond1{3}))/mean(mean(lumb_angle_cond1{3}))
%% Plot bar plot

 
%% Plot polar plot of the trunk forward/backward flexion
fig=figure;

close all
fig=figure;
for tr=1:3

    %here we plot the angles
    subplot(1,3,tr)
    polarplot(-mean(lumb_angle_cond1{tr})'-pi/2,ones(length(time),1),Color=color(1,:),LineWidth=2);
    hold on
    polarplot(-mean(lumb_angle_cond2{tr})'-pi/2,ones(length(time),1),Color=color(2,:),LineWidth=2);


    ax=gca;
    ax.FontSize=12;
    ax.RColor=[166, 89, 0, 0.3*255]/255;
    ax.ThetaColor=[165, 165, 165 0.3*255]/255;
    ax.RAxisLocation=115;
    %ax.ThetaLim=[-90 60];
    %ax.RLim=[170 180];
    

    % statis_test(mean(scapula_upward_rot_cond1{tr}'),... 
    % mean(scapula_upward_rot_cond2{tr}'),...
    % mean(scapula_elevation_cond1{tr}'),...
    % mean(scapula_elevation_cond2{tr}'),"Upward Rotation",...
    % "Elevation");

    title(tials_legend(tr),Interpreter="none")
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

%% Sahded standard deviation function
function stdevShadeLine(x,y,std_dev,colorVec,alpha,linewidth,linetype)
%x: x data
%y: ydata
%std_dev: standarad Deviation
    curve1 = y + std_dev;
    curve2 = y - std_dev;
    x2 = [x, fliplr(x)];
    inBetween = [curve1, fliplr(curve2)];
    fill(x2, inBetween, colorVec,'FaceAlpha',alpha,'EdgeColor','none');
    hold on;
    plot(x, y, 'Color',colorVec, 'LineWidth', linewidth,'LineStyle',linetype);
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
