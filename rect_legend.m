function rect_legend(h,str)

for n=1:length(str)
ph(n)=plot(nan,nan,'s','markeredgecolor',h(n,:),...
    'markerfacecolor',h(n,:));
end
legend(ph,str)
