dn='eval/planner-logs/'
d=dir([dn, '/*.log'])
for (i=1:length(d))
    logs(i).file=d(i);
    logs(i).file.name
    logs(i).log=readPlannerLog([dn,d(i).name]);
end;
