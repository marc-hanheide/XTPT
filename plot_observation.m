function [avgImage, sqImage, pos, neg]=plot_observation(data)
[ax,ay]=pol2cart(data(:,2),data(:,3));
minx=min(ax);
miny=min(ay);

maxRep=max(data(:,4));
factor=5;
images={};
for (k=0:maxRep)
    selected=find(data(:,4)==k);
    [x,y]=pol2cart(data(selected,2),data(selected,3));
    x=x-minx;
    y=y-miny;
    cx=(floor(x.*factor))+1;
    cy=(floor(y.*factor))+1;
    img=zeros(max(cx)+1,max(cy)+1);
    i=sub2ind(size(img), cx,cy);
    img(i)=data(selected,5)>0.08;
    images{k+1}=img;
end;

avgImage=images{1};
for (k=2:length(images))
    avgImage=avgImage+images{k};
end
avgImage=avgImage./length(images);

sqImage=(images{1}-avgImage).^2;
for (k=2:length(images))
    sqImage=sqImage+((images{k}-avgImage).^2);
end

sqImage=sqImage./length(images);
pos=nnz(data(:,5)>0.08)/size(data,1);
neg=nnz(data(:,5)<=0.08)/size(data,1);

