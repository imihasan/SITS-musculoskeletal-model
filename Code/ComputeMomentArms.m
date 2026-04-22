%% Compute Moment arms
% A script to compute moment arms of muscles in the spine-integrated
% thopracoscapular shoulder model (SITS)
% Author: Ibrahim Mohammed I. Hasan (imihasan@kth.se)

clear all; close all
import org.opensim.modeling.*;

path="C:\Users\ibrah\OneDrive - KTH\Paper I\Unilateral";
subject="S04";
condition="Unlocked"; % A flag whether to lock the spine: Locked, Unlocked
saving_path=fullfile(path,"Results/Muscle Analysis",subject,condition);
mkdir(saving_path);

osimModel=Model(fullfile(path,"Model/"+subject+"/SITSModel-Unilateral_scaled.osim"));
trc_path=fullfile(path,"Experimental Data",subject);

Coord_Names=["shoulder_elv", "plane_elv", "axial_rot", ...
    "scapula_elevation", "scapula_abduction", "scapula_upward_rot", "scapula_winging"]; %Coordinates wrt moment arms will be computed

if condition=="Locked"
    osimModel.updCoordinateSet().get("L5_S1_Flex_Ext").set_locked(1);
    osimModel.updCoordinateSet().get("L5_S1_Lat_Bending").set_locked(1);
     osimModel.updCoordinateSet().get("L5_S1_axial_rotation").set_locked(1);

    osimModel.updCoordinateSet().get("T1_C7_Flex_Ext").set_locked(1);
    osimModel.updCoordinateSet().get("T1_C7_Lat_Bending").set_locked(1);
    osimModel.updCoordinateSet().get("T1_C7_axial_rotation").set_locked(1);

    osimModel.updCoordinateSet().get("C2_C1_Flex_Ext").set_locked(1);
    osimModel.updCoordinateSet().get("C2_C1_Lat_Bending").set_locked(1);
    osimModel.updCoordinateSet().get("C2_C1_axial_rotation").set_locked(1);

end

%Add 2 kg to the hand mass
osimModel.updBodySet().get("hand").setMass(osimModel.updBodySet().get("hand").getMass()+2);
osimModel.finalizeConnections();
osimModel.initSystem();


[files,~] = uigetfile('*.trc', 'Select the .trc files to analyse', trc_path, 'MultiSelect','on');

if ischar(files)
    ff={files};
    s=length(ff);
else
    s=length(files);
end

%% Loop 
for f=1:s
    
    if s>1
        experiment_name=files{f}(1:end-4);
    else
        experiment_name=files(1:end-4);
        files={files};
    end
    

    % Run IK
    import org.opensim.modeling.*
    [markersExp, timesExp, ~, unitsExp] = readTRC(fullfile(trc_path,files{f}));
    start_time = timesExp(1)+0;
    end_time = timesExp(end);
    
    %Prepare inverse kinematics tools

    ikSetupFile =fullfile(path,"Results","Muscle Analysis",subject,condition,string(experiment_name)+"_IK_Setup.xml");
    %ikSetupFile =fullfile(path,"Model",subject,"IK_Setup_"+subject+".xml");
    ikTool = InverseKinematicsTool(ikSetupFile);
    taskSet=ikTool.get_IKTaskSet();
    
    ikTool.setMarkerDataFileName(fullfile(trc_path,files{f}));
    ikTool.setOutputMotionFileName(fullfile(saving_path, experiment_name +".mot"));
    ikTool.set_report_marker_locations(1);
    ikTool.setStartTime(start_time);
    ikTool.setEndTime(end_time);
    
    ikTool.setModel(osimModel);

    if condition=="Locked"
       taskSet.get("Head1").setWeight(0);
       taskSet.get("Head2").setWeight(0);
       taskSet.get("Head3").setWeight(0);
       taskSet.get("Head4").setWeight(0);

       taskSet.get("RASI").setWeight(0);
       taskSet.get("RPSI").setWeight(0);
       taskSet.get("LASI").setWeight(0);
       taskSet.get("LPSI").setWeight(0);
    end
    


    ikTool.print(fullfile(saving_path,append(experiment_name,'_IK_setup.xml')));
    
    fprintf(append('\n=====Running Inverse Kinematics for: ', experiment_name, '=====\n'));
    ikTool.run();
    fprintf(append('=====Inverse Kinematics Done=====\n'));

    import org.opensim.modeling.*
    lowpassFreq = 6.0; % Hz
    timeRange = [start_time end_time];
    [coordinates, coordNames, timesExp] = loadFilterCropArray(fullfile(saving_path, experiment_name+".mot"), lowpassFreq, timeRange);

    trans_coord=["GH_Tx", "GH_Ty", "GH_Tz","ground_thorax_tx", "ground_thorax_ty",  "ground_thorax_tz"];
    for coor=1:size(coordNames)
        if ~ismember(coordNames(coor),trans_coord)
            coordinates(:,coor)=deg2rad(coordinates(:,coor));
        end
    end
    % Update state and compute moment arms
    %osimModel.setUseVisualizer(true);
    state = osimModel.initSystem(); %initsystem to update the visualizer status

    fprintf(append('=====Computing Moment Arms=====\n'));
    

    for t=1:length(timesExp)
    
        fprintf('.');
        if(mod(t,80) == 0)
            fprintf('\n %i', t);
        end
        %Update state
        state.setTime(timesExp(t));
        for j = 1:length(coordNames)
            osimModel.updCoordinateSet().get(coordNames(j)).setValue(state,coordinates(t,j),false);
        end
        %It's important to realize position to be able to obtain
        %marker positions
        osimModel.realizeVelocity(state);

        % Store trajectories of markers of interest
        %GT(t,:)=osimModel.updMarkerSet().get("GT").getLocationInGround(state).getAsMat();
        %LT(t,:)=osimModel.updMarkerSet().get("LT").getLocationInGround(state).getAsMat();
        %HHS(t,:)=osimModel.updMarkerSet().get("HHS").getLocationInGround(state).getAsMat();
        %acrm(t,:)=osimModel.updMarkerSet().get("acrm").getLocationInGround(state).getAsMat();

    
        %Compute Moment Arms
        for m=0:osimModel.getMuscles().getSize()-1
            % name=osimModel.updMuscles().get(m).getName();
            for c=1:length(Coord_Names)
                Moment_Arms{m+1,c}(1,t)=osimModel.updMuscles().get(m).computeMomentArm(state,osimModel.updCoordinateSet().get(Coord_Names(c)));
            end
        end

        %Visualize state
        %osimModel.getVisualizer.show(state);

    end

    for m=0:osimModel.getMuscles().getSize()-1
        muscles_names(m+1)=osimModel.updMuscles().get(m).getName();
    end
    cd(saving_path)
    save("Moment_Arms_"+experiment_name,"Moment_Arms","muscles_names", ... 
        "Coord_Names","coordinates","timesExp","coordNames")
    fprintf('\n');
    clear Moment_Arms timesExp coordinates LT GT HHS acrm
end
%
%% Run Inverse Dynamics
import org.opensim.modeling.*;
saving_path_ID=fullfile(path,"Results/Inverse Dynamics",subject,condition);
mkdir(saving_path_ID);
[files,~] = uigetfile('*.mot', 'Select the .trc files to analyse', saving_path, 'MultiSelect','on');

if ischar(files)
    ff={files};
    s=length(ff);
else
    s=length(files);
end

for f=1:s

    if s>1
        experiment_name=files{f}(1:end-4);
    else
        experiment_name=files(1:end-4);
        files={files};
    end
    import org.opensim.modeling.*
    f_trc=char(files{f});
    f_trc=[f_trc(1:end-3) 'trc'];
    [markersExp, timesExp, ~, unitsExp] = readTRC(fullfile(trc_path,string(f_trc)));
    start_time = timesExp(1)+0;
    end_time = timesExp(end);

    fprintf(append('\n=====Running Inverse Dynamics for: ', experiment_name, '=====\n'));
    idSetupFile =fullfile(path,"Model",subject,"ID_Setup_"+subject+".xml");
    IDtool = InverseDynamicsTool(idSetupFile);
    IDtool.setModel(osimModel);
    IDtool.setCoordinatesFileName(fullfile(saving_path, experiment_name+".mot"));
    IDtool.setStartTime(start_time);
    IDtool.setEndTime(end_time);
    IDtool.setOutputGenForceFileName(fullfile(saving_path_ID, experiment_name+".mot"));
    IDtool.setResultsDir(fullfile(saving_path_ID));
    IDtool.setLowpassCutoffFrequency(6);
    IDtool.run();
    fprintf('\n=====Inverse Dynamics Done=====\n');
end