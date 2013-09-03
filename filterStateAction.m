function actions=filterStateAction(master);

states=selectLogTyp(master,':state');
actions=selectLogTyp(master,':action');


for i=1:length(actions)
    a_time(i,1)=str2num(actions(i).param{2});
    a_time(i,2)=i;
end;


for i=1:length(states)
    s_time(i,1)=str2num(states(i).param{2});
    s_time(i,2)=i;
end;
mintime=min( min(s_time(:,1)),min(a_time(:,1)));

s_time(:,1)=s_time(:,1)-mintime;
a_time(:,1)=a_time(:,1)-mintime;



for i=1:length(actions)
    d=(s_time(:,1)-a_time(i,1));
    dpre=d;
    dpost=d;
    dpre(find(d>0))=inf;
    dpost(find(d<0))=inf;
    [m,ix_pre]=min(abs(dpre));
    [m,ix_post]=min(abs(dpost));
    actions(i).state_pre=states(s_time(ix_pre,2));
    actions(i).state_post=states(s_time(ix_post,2));
end;


