function [Fm, locaa, meanFm,meanloca,muscleForce,Costheta]=perturbMuscle(osimModel, muscle_name, ... 
    All_coordinates, All_coordNames, tim, xsol, muscle_order, Vec_H2GCC, Vec_GC2GEE,subj_weight)

import org.opensim.modeling.*;
% clear all
% s=1;
% model_path="C:\Users\ibrah\OneDrive - KTH\Paper I\"+"Unilateral"+"\Model"+"\S0"+string(s)+"\SITSModel-Unilateral_scaled.osim";
% osimModel=Model(model_path);
% load("C:\Users\ibrah\OneDrive - KTH\Paper I\Unilateral\Results\Muscle Redundancy\S01\Unlocked\muscle_activations_Upright_Lateral_Raise_Head.mat")
% tim=timesExp;
% muscle_name="DeltoideusScapula_P";
% subj_weight=800;
%osimModel.setUseVisualizer(true);

state=osimModel.initSystem();

All_speeds = zeros(size(All_coordinates));
for i=1:size(All_coordNames,1)
    All_speeds(:,i) = gradient(All_coordinates(:,i))./ gradient(tim);
end

for ms=0:osimModel.getMuscles().getSize()-1
    osimModel.getMuscles().get(ms).overrideActuation(state, true);
end



for time_instant=1:length(All_coordinates)
    
    % Loop through model coordinates to set coordinate values and speeds. We set
    % all coordinates to make sure we have the correct kinematic state when 
    % compute muscle multipliers and moment arms.
    state.setTime(tim(time_instant))
    for j = 1:length(All_coordNames)
        coord = osimModel.getCoordinateSet().get(All_coordNames{j});
        coord.setValue(state,All_coordinates(time_instant,j), false); % instead of fals replace so that does the assembly on the last call (j==length)
        coord.setSpeedValue(state, All_speeds(time_instant,j));
    end
    
    osimModel.realizeVelocity(state); %Realize state postion and velocity
    osimModel.equilibrateMuscles(state); %Equilibrate muscles 

    modelControls = osimModel.getControls(state);
 
    %osimModel.realizePosition(state);
    
    

    %Set muscles actuation to zero to find only contribution of the passive
    %forces
    for ms=0:osimModel.getMuscles().getSize()-1
        osimModel.getMuscles().get(ms).setOverrideActuation(state, 0);
        %osimModel.getMuscles().get(ms).set_ignore_activation_dynamics(true);
    end

    osimModel.realizeAcceleration(state);
    glen=osimModel.getJointSet().get("GlenoHumeral");
    F_r0=glen.calcReactionOnParentExpressedInGround(state).get(1).getAsMat(); %Get reaction force induced by the muscle on the parent body expressed in ground.
    

    osimModel.getMuscles().get(muscle_name).overrideActuation(state, true);
    osimModel.realizeAcceleration(state);
    muscle_downcasted=Millard2012EquilibriumMuscle.safeDownCast(osimModel.getMuscles().get(muscle_name));
    fl = muscle_downcasted.getActiveForceLengthMultiplier(state);            
    fv = muscle_downcasted.getForceVelocityMultiplier(state);
    fp = muscle_downcasted.getPassiveForceMultiplier(state);
    cosPenn= muscle_downcasted.getCosPennationAngle(state);
    Fmax=muscle_downcasted.getMaxIsometricForce();

    

    % store the values of active and passive maximum force in the current
    % configuration
    AMuscForce = (fl*fv*Fmax*cosPenn)'; 
    PMuscForce = (Fmax*fp*cosPenn)';

    index=find(muscle_order==muscle_name);
    MuscleForces = AMuscForce*xsol(time_instant,index) + PMuscForce;

    osimModel.updMuscles().get(muscle_name).setOverrideActuation(state, MuscleForces);

    muscleForce(time_instant)=MuscleForces;

    %Find reaction after perturbing the muscle
    osimModel.realizeAcceleration(state);
    Fsim=glen.calcReactionOnParentExpressedInGround(state).get(1).getAsMat();
    
    Fm(time_instant,:)=Fsim-F_r0;

    % Find location

    cosTheta =max(min(dot(Vec_H2GCC(time_instant,:),Fm(time_instant,:))/(norm(Vec_H2GCC(time_instant,:))*norm(Fm(time_instant,:))),1),-1);
    Costheta(time_instant,:)=cosTheta;

    if (cosTheta<=0) ||  (norm(Fm(time_instant,:))<=0.001*subj_weight)
        cosTheta=nan;
        Fm(time_instant,:)=nan;
    else
        cosTheta=cosTheta;
    end
    

    F=Fm(time_instant,:)/norm(Fm(time_instant,:));

    norm_Vec_H2GC=-Vec_H2GCC(time_instant,:)/norm(-Vec_H2GCC(time_instant,:));
    xhat=norm_Vec_H2GC;
    Vxdot=dot(Vec_GC2GEE(time_instant,:),xhat);
    Vy=Vec_GC2GEE(time_instant,:)-Vxdot*xhat;
    yhat=Vy/norm(Vy);
    zhat=cross(xhat,yhat);
    R=[xhat; yhat; zhat];

    loca=R*1000*F'*(norm(Vec_H2GCC(time_instant,:)))/cosTheta;
    locaa(time_instant,:)=loca;

    %test=R*(osimModel.getMarkerSet().get("Test").getLocationInGround(state).getAsMat() - osimModel.getMarkerSet().get("Glenoid_Center").getLocationInGround(state).getAsMat());
    hge=R*Vec_GC2GEE(time_instant,:)';
    % a=Vec_H2GCC(time_instant,:);
    % b=Fm(time_instant,:);
    % atn(time_instant)=atan2d(norm(cross(a,b)),dot(a,b));
    % F_passive(time_instant,:)=F_r0;
    % penn(time_instant)=norm(Fsim);

    
    % osimModel.getVisualizer.show(state);
end

locam=locaa;
isn=isnan(locam);
ind=find(isn(:,1)==1); 
locam(ind,:)=[];

Fma=Fm;
isnF=isnan(Fma);
indF=find(isnF(:,1)==1);
Fma(indF,:)=[];

meanFm=mean(Fma)';
meanloca=mean(locam);

% figure
% plot(Fm)
% % 
% figure
% scatter(-locam(:,2),-locam(:,3),20,"filled")
% hold on
% scatter(0,0,30,"red","filled")
% scatter(-1000*hge(2),-1000*hge(3),30,"blue","filled")

end

