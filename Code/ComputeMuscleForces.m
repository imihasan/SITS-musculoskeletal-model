%% Compute individual muscle forces
% This script takes the results of the rmr solver and finds the indivivdual
% muscle force magnitude and direction
%Author: Ibrahim Mohammed I. Hasan (imihasan@kth.se)
%KTH Royal Institute of Technology

clear
close all
%%

addpath("C:\Users\ibrah\OneDrive - KTH\Paper I\Unilateral\Code")
addpath("C:\Users\ibrah\OneDrive - KTH\Paper I\Unilateral\Code\Visualize Results")
sav_graphics="C:\Doctoral Research - KTH\Affinity Illustrations\Paper II\JCF Locs Postures";
mkdir(sav_graphics)
mkdir(sav_graphics,"Individuals Plots")
nsubj=10;
model="Unilateral";
conditions=["Unlocked"];
postures=["Slouching"; "Upright"];
trials=["Extension", "Front_Raise_Head", "Lateral_Raise_Head"];
tria=["Posterior Raise", "Anterior Raise", "Lateral Raise"];
color=[130 150 111; 0 0 97]/255;
col=[255, 0, 255 ; 232, 106, 88;  200, 200, 200; 120, 230, 255; 98, 152, 210; 255, 190, 0]/255;
subj_weight=[58, 66.8, 70.7, 79, 58.5, 69.7, 75.7, 58.7, 77, 60.5]*9.81;

muscles_of_interest=["Subscapularis_S";"Subscapularis_M"; "Subscapularis_I";
    "Supraspinatus_P"; "Supraspinatus_A"; "Infraspinatus_S"; "Infraspinatus_I";
    "TeresMinor"; "TeresMajor" ; "DeltoideusScapula_P"; "DeltoideusScapula_M"; "DeltoideusClavicle_A";
     "BIClong"; "BICshort"; "TRIlong"; "PectoralisMajorClavicle_S"; "PectoralisMajorThorax_M"; "PectoralisMajorThorax_I"; 
     "LatissimusDorsi_S"; "LatissimusDorsi_M"; "LatissimusDorsi_I"; "Coracobrachialis"; "TrapeziusScapula_S"; 
     "TrapeziusScapula_M"; "TrapeziusScapula_I"; "SerratusAnterior_S"; "SerratusAnterior_M";
     "SerratusAnterior_I"; "Rhomboideus_S"; "Rhomboideus_I"; "LevatorScapulae"];

muscles_of_interest=["LevatorScapulae"];

col=1:length(muscles_of_interest);

for s=1:nsubj 
    if s==10
        SS="S";
    else
        SS="S0";
    end
    import org.opensim.modeling.*;
    model_path="C:\Users\ibrah\OneDrive - KTH\Paper I\"+model+"\Model"+"\"+SS+string(s)+"\SITSModel-Unilateral_scaled.osim";
    osimModel=Model(model_path);
    path="C:\Users\ibrah\OneDrive - KTH\Paper I\"+model+"\Results\Muscle Redundancy\"+SS+string(s);

    for r=1:length(trials)

        for p=1:length(postures)
            for condi=1:length(conditions)
            load(fullfile(path+"\"+conditions(condi),"muscle_activations_"+postures(p)+"_"+trials(r)+".mat"))
            
            tim=timesExp;

            timm=timesExp;
            [~,location]=Normalize(timm,norm_fv_rotated');
            location=location';
            Loc{p}=norm_fv_rotated;
            eval(append('out_param.',char(SS+string(s)),'.',char(trials(r)),'.',char(postures(p)),'.',char(conditions(condi)),'=location;'))
            
                for sc=1:length(muscles_of_interest)
    
                    [Ftime,locatime,F,loca,muscleForce,Costheta]=perturbMuscle(osimModel,muscles_of_interest(sc),All_coordinates,All_coordNames,tim,xsol,muscle_order,Vec_H2GCC,Vec_GC2GEE,subj_weight(s));
                    ft=F;
                    %scatter(-loca(2), -loca(3),50, [1 0 0], 'filled','MarkerFaceAlpha',1,'MarkerFaceColor',[1 0 0],'Marker','o')
                    loc_bubble=loca;
                    sz=norm(ft);
                    sz=sz/norm(mean(force_vecc));
                    % bubblechart(-loc_bubble(2),-loc_bubble(3),sz,col(sc))
                    % hold on
                    musc_loc=[loc_bubble sz];
                    eval(append('muscles_param.',char(SS+string(s)),'.',char(trials(r)),'.',char(postures(p)),'.',char(conditions(condi)),'.',char(muscles_of_interest(sc)),'.','bubble','=musc_loc;'))
                    eval(append('muscles_param.',char(SS+string(s)),'.',char(trials(r)),'.',char(postures(p)),'.',char(conditions(condi)),'.',char(muscles_of_interest(sc)),'.Ftime','=Ftime;'))
                    eval(append('muscles_param.',char(SS+string(s)),'.',char(trials(r)),'.',char(postures(p)),'.',char(conditions(condi)),'.',char(muscles_of_interest(sc)),'.loctime','=locatime;'))
                    eval(append('muscles_param.',char(SS+string(s)),'.',char(trials(r)),'.',char(postures(p)),'.',char(conditions(condi)),'.',char(muscles_of_interest(sc)),'.muscleForce','=muscleForce;'))
                    eval(append('muscles_param.',char(SS+string(s)),'.',char(trials(r)),'.',char(postures(p)),'.',char(conditions(condi)),'.',char(muscles_of_interest(sc)),'.Costheta','=Costheta;'))
                    fprintf(SS+string(s)+"_"+trials(r)+"_"+postures(p)+"_"+conditions(condi)+"_"+muscles_of_interest(sc)+" Done\n")
                    clear sz loca loc_bubble musc_loc ft F Ftime locatime muscleForce Costheta
                end  
            end
            clear norm_fv_rotated coordinates timesExp timm location force_vecc
        end

    end
    fprintf(SS+string(s)+" Done\n")
end

saving_path="C:\Users\ibrah\OneDrive - KTH\Paper I\Unilateral\Results\Individual Muscle Forces";
save(saving_path+"\"+"Levator_Muscles_Forces_CoP_ModelsPostures.mat","out_param","muscles_param")

%% Normalize
function [xx,Vn]=Normalize(T,V)
T=T-T(1);
x = 100*(T - min(T)) / ( max(T) - min(T) );
xx = linspace(0,100,1001); %number of points for resample
Vn=spline(x,V,xx);
end