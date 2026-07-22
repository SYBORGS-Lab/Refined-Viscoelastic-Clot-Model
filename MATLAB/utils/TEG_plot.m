function gh = TEG_plot(t, simTEG, LineColor, LineStyle, LineWidth, DisplayName, HandleVisibility)
arguments
    t (:,1) double
    simTEG (:,1) double
    LineColor string = ""
    LineStyle string = "-"
    LineWidth int8 = 1
    DisplayName string = ""
    HandleVisibility string = "on"
end

if DisplayName == ""
    HandleVisibility = "off";
end
gh = plot(t, 0.5*simTEG, "Color", LineColor, "LineWidth", LineWidth, "LineStyle", LineStyle, "DisplayName", DisplayName, "HandleVisibility", HandleVisibility);
xticks(0:5:105)
% xticks(0:5:max(t)+5)
yticks(-80:20:80)
axis([0 105 -80 80])
% axis([0 max(t)+5 -80 80])
daspect([0.911/4 0.9898 0.1])
end