function rect_legend(h,str)

ls={};
i=0;
for n=1:length(str)
    if (~isempty(str{n}))
        i=i+1;
        ph(i)=plot(nan,nan,'s','markeredgecolor',h(n,:),...
            'markerfacecolor',h(n,:));
        ls{i}=str{n};
    end;
end
lh=legend(ph,ls)
set(lh,'Location','WestOutside');
