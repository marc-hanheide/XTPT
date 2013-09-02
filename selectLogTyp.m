function [res]=selectLogTyp(master,pattern)
pp=strfind(pattern,'.');
res=[];
%pattern
if (isempty(pp))
    ind=dosearch(master,pattern);
    res=master.children(ind);
else
    fp=pattern(1:pp(1)-1);
    rp=pattern(pp(1)+1:end);
    indnew=dosearch(master,fp);
    fpres=master.children(indnew);
    for (i=1:length(fpres))        
        [r]=selectLogTyp(fpres(i),rp);
        if (length(r)>0)
            res=[res r];
        end;
    end;
end;


function [res]=dosearch(master,pattern)
  cs=master.children;
  res=[];
  for (i=1:length(cs))
      c=cs(i);
      if strcmp(c.param{1},pattern)
          res(end+1)=i;
      end;
  end;
