for (i=1:length(logs))
    figure(i);
    set(gcf,'Name',logs(i).file.name)
    try
        plotActions(logs(i).log);
        print(gcf,'-depsc', [logs(i).file.name, '.eps']);
    catch
        warning('could not plot');
    end;
end;
