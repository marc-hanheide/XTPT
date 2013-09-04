function [ entropy ] = entropyCat( actions )
for i=1:length(actions)
    [roomCats,placeRoom,placeCats,robotPose,placeStatus]=parseState(actions(i).state_post);
    %placeCats(find(placeCats<=0))=0.0001;
    %placeCats=placeCats./repmat(sum(placeCats,2),1,size(placeCats,2))
    %entropy(i)=mean(-sum(log(placeCats).*placeCats,2));
    %for 
    p=reshape(struct2array(roomCats.rooms),3,[])';
    p(find(p<=0))=0.00000001;
    p=p./repmat(sum(p,2),1,size(p,2));
    entropy(i)=mean(-sum(log(p).*p,2));
end

end

