function [res]=filterLogTyp(master,pattern)
 
  res=[];
  for (i=1:length(master))
    search=selectLogTyp(master(i),pattern);
    if (~isempty(search))
        res=[res master(i)];
    end;
  end;
