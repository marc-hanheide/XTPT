function [roomCats,placeRoom,placeCat,robotPose,placeStatus]=parseState(state)
    roomCats=parseRoomCats(state);
    placeRoom=parsePlaceRoom(state);
    robotPose=parseRobotPose(state);
    placeStatus=parsePlaceStatus(state);
    fn=fieldnames(placeRoom);
    for (i=1:length(fn))
        %placeCat.(fn{i})=roomCats.rooms.(placeRoom.(fn{i}));
        placeCat(placeid2num(fn{i})+1,:)=roomCats.rooms.(placeRoom.(fn{i}));
    end;
    
function placeRoom=parsePlaceRoom(state);
    as=selectLogTyp(state,'define.:init.=');
    ir=filterLogTyp(as,'in-room');
    for (i=1:length(ir))
        placeRoom.(ir(i).children(1).param{2})=ir(i).param{2};
    end;
    

function robotPose=parseRobotPose(state);
    as=selectLogTyp(state,'define.:init.=');
    rp=filterLogTyp(as,'is-in');
    robotPose=rp(1).param{2};

function placeStatus=parsePlaceStatus(state);
    as=selectLogTyp(state,'define.:init.=');
    rp=filterLogTyp(as,'placestatus');
    placeStatus=zeros(1,100);
    for i=1:length(rp);
        status=rp(i).param{2};
        place=rp(i).children(1).param{2};
        placeID=placeid2num(place);
        if (strcmp(status,'trueplace'))
            placeStatus(placeID+1)=1;
        else
            placeStatus(placeID+1)=0;
        end;
    end;


    

function [roomCats]=parseRoomCats(state)

    roomMap = containers.Map;
    roomMap('office')=1;
    labels{1}='office';
    roomMap('corridor')=2;
    labels{2}='corridor';
    roomMap('meetingroom')=3;
    labels{3}='meetingroom';
    roomInd=3;


    ps=selectLogTyp(state,'define.:init.probabilistic');
    pc=filterLogTyp(ps,'assign.category');
    for (i=1:length(pc))
        rl=selectLogTyp(pc(i),'assign');
        for (j=1:length(rl))
            room=rl(j).children.param{2};
            prob=str2num(pc(i).param{1+j});
            label=rl(j).param{2};
            if (~roomMap.isKey(label))
                roomInd=roomInd+1;
                labels{roomInd}=label;
                roomMap(label)=roomInd;
            end;
            ind=roomMap(label);

            roomCats.rooms.(room)(ind)=prob;    
        end;
    end;
    roomCats.labels=labels;
    
    