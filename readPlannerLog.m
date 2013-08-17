function master=readPlannerLog(fname)
    text=fileread(fname);
    openings=strfind(text, '(');
    openings=[openings; repmat(+1,1,length(openings))];
    closings=strfind(text, ')');
    closings=[closings; repmat(-1,1,length(closings))];
    indices=sortrows([openings, closings]');
    levels=cumsum(indices(:,2));
    indices=[indices,levels];
     
    for (i=1:size(indices,1))
        level=indices(i,3);
        if (indices(i,2)==1) %opening
            current{level}.children=[];
            current{level}.startPos=indices(i,1);
            current{level}.param={};
            current{level}.lastParamPos=current{level}.startPos+1;
            if (level>1)
                from=current{level-1}.lastParamPos;
                to=current{level}.startPos-1;
                if (to>from)
                    current{level-1}.param=tokenise(text(from:to),current{level-1}.param);
                end;
                current{level-1}.lastParamPos=to+1;
            end;
        else %closing
            current{level+1}.stopPos=indices(i,1);
            current{level+1}.text=text(current{level+1}.startPos:current{level+1}.stopPos);
            if (isempty(current{level+1}.children))
                current{level+1}.param=tokenise(text(current{level+1}.startPos+1:current{level+1}.stopPos-1),{});
            else
                from=current{level+1}.lastParamPos;
                to=indices(i,1)-1;
                if (to>from)
                    current{level+1}.param=tokenise(text(from:to),current{level+1}.param);
                end;
            end;
            if (level>0)
                current{level}.lastParamPos=current{level+1}.stopPos+1;
                current{level}.children=[current{level}.children current{level+1}];
            end;
        end;
            
    
    end;
    master=current{1};
    
function param=tokenise(t,param)
    R=strtrim(t);
    while (~isempty(R))
        [T,R]=strtok(R);
        param{end+1}=T;
    end;
    
    
    
    
    
    
