function plotGHVectorField()

    radius = 1000*sind(LmaxAngle);
    p=nsidedpoly(1000, 'Center', [0,0], 'Radius', radius);
    c = linspace(0,timesExp(end),length(Lnorm_fv_rotated));
    f7 = figure;
    hold on
    plot(p, 'FaceColor', 'r')
    
    for time_instant=1:1:length(timesExp)
        scatter(-Lnorm_fv_rotated(time_instant,3), -Lnorm_fv_rotated(time_instant,1), [], c(time_instant), 'filled')
    end
    hcb = colorbar;
    h = gca;
    set(h, "XTickLabel", [])
    set(h, "YTickLabel", [])
    xlabel("Posterior                                                                       Anterior")   % corresponding roughly to OpenSim X axis (horizontal pointing forward)
    ylabel("Inferior                                                                       Superior")      % corresponding to OpenSim Y axis (vertical pointing upwards)
    colorTitleHandle = get(hcb,'Title');
    titleString = 'time [s]';
    set(colorTitleHandle ,'String',titleString);
    
    quiver(-Lnorm_fv_rotated(1:10:end,3),-Lnorm_fv_rotated(1:10:end,1),-Lnorm_fv_rotated(1:10:end,3), ...
        -Lnorm_fv_rotated(1:10:end,1),"filled","AutoScale","on","Alignment","head", ...
       "ColorMode","auto","Marker","none","AutoScaleFactor",1,"LineWidth",1,"LineStyleMode","auto", ...
       "LineStyleMode","auto","MarkerEdgeColor","y","MarkerSize",10,"MaxHeadSize",10,"Color",	[0 0 0])

end

