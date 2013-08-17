function res=selectLogTyp(master,pattern)
cs=master.children;
res=cell(0);
for (i=1:length(cs))
    c=cs(i);
    if strcmp(c.param{1},pattern)
        res{end+1}=c;
    end;
end;