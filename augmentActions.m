function [ res ] = augmentActions( master )
actions=filterStateAction(master);

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



