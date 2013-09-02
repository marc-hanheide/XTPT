function [roomCats,placeRoom,placeCat]=parseState(state)
    roomCats=parseRoomCats(state);
    placeRoom=parsePlaceRoom(state);
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
    


    

function [roomCats]=parseRoomCats(state)

    roomMap = containers.Map;
    roomInd=0;


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
    
    