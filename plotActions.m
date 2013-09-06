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


%set(gcf,'PaperPosition',[2.59447 8.91145 15.7924 15.8443]);
set(gcf,'Position',[0 600 1280 320]),
set(gcf,'PaperPositionMode','auto'); 

cla
hold on;

e=entropyCat(res);
et=([res.start]+([res.stop]-[res.start])/2)-offset;


subplot(2,1,1);
cla
hold on

bar(et,robotCat,'stack')
roomcolors=[0.5 0 0.5; 0.95 0.95 0; 1 0.6 0];
colormap(roomcolors);
plot(et,e,'LineWidth',2);
lt=res(end).roomCats.labels;
lt{end+1}='entropy';
lh=legend('entropy',lt,'EastOutside' );
set(lh,'Location','WestOutside');
set(gca,'XAxisLocation','top');
set(gca,'XTick',et);
set(gca,'XTickLabel',num2str(robotPoses'));
set(gca,'YTick',0:0.2:1);
set(gca,'YGrid','on');
set(gca,'XGrid','on');
set(gca,'YLim', [0 1]);
set(gca,'XLim', [min(et)-30 max(et)+30]);
%set(gca,'DataAspectRatio',[250 1 1.66667]);
set(get(gca,'XLabel'),'String','place robot is in');
set(get(gca,'YLabel'),'String','avg. entropy');
set(get(gca,'XLabel'),'FontSize',14);
set(get(gca,'YLabel'),'FontSize',14);
set(gca,'FontSize',10)

subplot(2,1,2);
cla
hold on
set(gca,'XTick',et);
set(gca,'XTickLabel',round(et));
set(gca,'YTick',[]);
set(gca,'YGrid','off');
set(gca,'XGrid','on');
set(gca,'YLim', [-0.3 0.3]);
set(gca,'XLim', [min(et)-30 max(et)+30]);
%set(gca,'DataAspectRatio',[250 1 1.66667]);
set(get(gca,'XLabel'),'String','time in sec.');
set(get(gca,'YLabel'),'String','actions');
set(get(gca,'XLabel'),'FontSize',14);
set(get(gca,'YLabel'),'FontSize',14);

set(gca,'FontSize',10)

%print -depsc 'out.eps'

actionsMap = containers.Map;

predefAct={'move' 'explore','create-cones','search-in-cones','look-for-people','engage','ask-for-category-polar','ask-for-object-existence'};

legend_text={};
for i=1:length(predefAct)
    actionsMap(predefAct{i})=i;
end;


actInd=length(predefAct);

for i=1:length(res)
    if (~actionsMap.isKey(res(i).action))
        actInd=actInd+1;
        legend_text{actInd}=res(i).action;
        actionsMap(res(i).action)=actInd;
    end;
    legend_text{actionsMap(res(i).action)}=res(i).action;
end;

colours=jet(actionsMap.length);



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
        handles(end+1)=rectangle('Position', [start -0.1 stop-start 0.2], 'Curvature',[0.5],'FaceColor',colours(actionsMap('move'),:));
%        rcol=res(i).placeCat(startpid+1,:);
%        rectangle('Position', [start -1.5 stop-start 0.5], 'Curvature',[0.1],'FaceColor',rcol);
        %actionLabel(start,stop,['move from ',num2str(startpid), ' to ',num2str(destpid),' ', num2str(deststatus), ' (ends at ',num2str(robotPose),')']);
    else
        handles(end+1)=rectangle('Position', [start -0.1 stop-start 0.2], 'Curvature',[0.5],'FaceColor',colours(actionsMap(res(i).action),:));

        %actionLabel(start,stop,res(i).action);
    end;
    %text((start+stop)/2,0,res(i).params, 'Rotation',90,'HorizontalAlignment','center', 'Interpreter','none','FontName','Tahoma','FontSize',6);
end;

rect_legend(colours,legend_text);



function actionLabel(start,stop,t)
text((start+stop)/2,0.5,t, 'Rotation',90,'HorizontalAlignment','center', 'Interpreter','none','FontName','Tahoma');


    