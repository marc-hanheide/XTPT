function res=plotActions(master)
actions=filterStateAction(master);

firstPlanStart=str2double(master.children(1).param{2});

j=0;
for i=1:length(actions)
    a=actions(i);
    ts=str2num(a.param{2});
    a.status=a.children.param{1};
    if (strcmp(a.status,'IN_PROGRESS'))
        j=j+1;
        start=ts;
    else
        a.action=a.children.children.param{1};
        a.params=a.children.children.param(2:end);
        a.start=start;
        a.stop=ts;
        res(j)=a;
    end;
end;

offset=min([firstPlanStart res.start]);

cla
set(gca,'YTick',[]);
set(gca,'YLim', [-0.6 0.6]);
set(gca,'DataAspectRatio',[200 1 1.66667]);
set(gcf,'PaperPosition',[2.59447 8.91145 15.7924 15.8443]);
set(gcf,'Position',[0 258 1100 420]),
set(gcf,'PaperPositionMode','auto'); 
set(get(gca,'XLabel'),'String','Time in sec.');
%print -depsc 'out.eps'

actionsMap = containers.Map;
actInd=0;
for i=1:length(res)
    if (~actionsMap.isKey(res(i).action))
        actInd=actInd+1;
        actionsMap(res(i).action)=actInd;
    end;
end;

colours=lines(actionsMap.length);

for i=1:length(res)
    start=res(i).start-offset;
    stop=res(i).stop-offset;
    
    rectangle('Position', [start -0.5 stop-start 1], 'Curvature',[0.1],'FaceColor',colours(actionsMap(res(i).action),:));
    if (strfind(res(i).action,'move')==1)
        actionLabel(start,stop,['move to ',num2str(placeid2num(res(i).params{2}))]);
    else
        actionLabel(start,stop,res(i).action);
    end;
    %text((start+stop)/2,0,res(i).params, 'Rotation',90,'HorizontalAlignment','center', 'Interpreter','none','FontName','Tahoma','FontSize',6);
end;


function actionLabel(start,stop,t)
text((start+stop)/2,0,t, 'Rotation',90,'HorizontalAlignment','center', 'Interpreter','none','FontName','Tahoma');