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
        state_pre=a.state_pre;
    else
        a.action=getActionName(a.children.children.param{1});
        a.params=a.children.children.param(2:end);
        a.start=start;
        a.stop=ts;
        a.state_pre=state_pre;
        [d1,d2,d3,d4,a.placeStatus]=parseState(a.state_pre);
        [a.roomCats,a.placeRoom,a.placeCat,a.robotPose]=parseState(a.state_post);
        res(j)=a;
        if (strcmp(a.action,'move'))
            destpid=placeid2num(res(j).params{2});
            deststatus=res(j).placeStatus(destpid+1);
            if (deststatus==0)
                res(j).action='explore';
            end;
        end;

    end;
end;

offset=min([firstPlanStart res.start]);

cla
set(gca,'YTick',[]);
set(gca,'YLim', [-1.6 1.6]);
set(gca,'DataAspectRatio',[250 1 1.66667]);
set(gcf,'PaperPosition',[2.59447 8.91145 15.7924 15.8443]);
set(gcf,'Position',[0 258 1200 420]),
set(gcf,'PaperPositionMode','auto'); 
set(get(gca,'XLabel'),'String','Time in sec.');
%print -depsc 'out.eps'

actionsMap = containers.Map;
actInd=0;

legend_text={};
for i=1:length(res)
    if (~actionsMap.isKey(res(i).action))
        actInd=actInd+1;
        legend_text{actInd}=res(i).action;
        actionsMap(res(i).action)=actInd;
    end;
end;

colours=lines(actionsMap.length);



handles=[];
for i=1:length(res)
    start=res(i).start-offset;
    stop=res(i).stop-offset;
    
    if (strfind(res(i).action,'move')==1)
        startpid=placeid2num(res(i).params{3});
        destpid=placeid2num(res(i).params{2});
        deststatus=res(i).placeStatus(destpid+1);
        robotPose=placeid2num(res(i).robotPose);
        handles(end+1)=rectangle('Position', [start -0.5 stop-start 2], 'Curvature',[0.1],'FaceColor',colours(actionsMap('move'),:));
        rcol=res(i).placeCat(startpid+1,:);
        rectangle('Position', [start -1.5 stop-start 0.5], 'Curvature',[0.1],'FaceColor',rcol);
        actionLabel(start,stop,['move from ',num2str(startpid), ' to ',num2str(destpid),' ', num2str(deststatus), ' (ends at ',num2str(robotPose),')']);
    else
        handles(end+1)=rectangle('Position', [start -0.5 stop-start 2], 'Curvature',[0.1],'FaceColor',colours(actionsMap(res(i).action),:));

        actionLabel(start,stop,res(i).action);
    end;
    %text((start+stop)/2,0,res(i).params, 'Rotation',90,'HorizontalAlignment','center', 'Interpreter','none','FontName','Tahoma','FontSize',6);
end;
hold on;
rect_legend(colours,legend_text);



function actionLabel(start,stop,t)
text((start+stop)/2,0.5,t, 'Rotation',90,'HorizontalAlignment','center', 'Interpreter','none','FontName','Tahoma');

function name=getActionName(orig)
name=orig;
switch(orig)
    case 'move_direct'
        name='move';
    case 'create_cones_in_room'
        name='create-cones';
    case 'process_conegroup'
        name='search-in-cones';
end;


    