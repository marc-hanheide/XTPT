function res=plotActions(master)

firstPlanStart=str2double(master.children(1).param{2});
res=augmentActions(master);

robotPoses=zeros(1,length(res));
for i=1:length(res)
    robotPoses(i)=placeid2num(res(i).robotPose);
    try
        robotCat(i,:)=res(i).placeCat(robotPoses(i)+1,:);
    catch
        robotCat(i,:)=[0 0 0];
    end;
end;
    


offset=min([firstPlanStart res.start]);


set(gcf,'PaperPosition',[2.59447 8.91145 15.7924 15.8443]);
set(gcf,'Position',[0 600 1200 420]),
set(gcf,'PaperPositionMode','auto'); 

cla
hold on;

e=entropyCat(res);
et=([res.start]+([res.stop]-[res.start])/2)-offset


subplot(2,1,1);
cla
bar(et,robotCat)
plot(et,e);
legend(res(end).roomCats.labels)
set(gca,'XTick',[]);
%set(gca,'XTickLabel',round(et));
set(gca,'YTick',[0 1]);
set(gca,'YGrid','on');
set(gca,'XGrid','on');
set(gca,'YLim', [0 1]);
%set(gca,'DataAspectRatio',[250 1 1.66667]);
%set(get(gca,'XLabel'),'String','Time in sec.');



subplot(2,1,2);
cla
set(gca,'XTick',et);
set(gca,'XTickLabel',round(et));
set(gca,'YTick',[]);
set(gca,'YGrid','off');
set(gca,'XGrid','on');
set(gca,'YLim', [-1.6 0]);
%set(gca,'DataAspectRatio',[250 1 1.66667]);
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



subplot(2,1,2);

handles=[];
for i=1:length(res)
    start=res(i).start-offset;
    stop=res(i).stop-offset;
    
    if (strfind(res(i).action,'move')==1)
        startpid=placeid2num(res(i).params{3});
        destpid=placeid2num(res(i).params{2});
        deststatus=res(i).placeStatus(destpid+1);
        robotPose=placeid2num(res(i).robotPose);
        handles(end+1)=rectangle('Position', [start -0.5 stop-start 0.2], 'Curvature',[0.5],'FaceColor',colours(actionsMap('move'),:));
        rcol=res(i).placeCat(startpid+1,:);
        rectangle('Position', [start -1.5 stop-start 0.5], 'Curvature',[0.1],'FaceColor',rcol);
        %actionLabel(start,stop,['move from ',num2str(startpid), ' to ',num2str(destpid),' ', num2str(deststatus), ' (ends at ',num2str(robotPose),')']);
    else
        handles(end+1)=rectangle('Position', [start -0.5 stop-start 0.2], 'Curvature',[0.5],'FaceColor',colours(actionsMap(res(i).action),:));

        %actionLabel(start,stop,res(i).action);
    end;
    %text((start+stop)/2,0,res(i).params, 'Rotation',90,'HorizontalAlignment','center', 'Interpreter','none','FontName','Tahoma','FontSize',6);
end;

rect_legend(colours,legend_text);



function actionLabel(start,stop,t)
text((start+stop)/2,0.5,t, 'Rotation',90,'HorizontalAlignment','center', 'Interpreter','none','FontName','Tahoma');


    