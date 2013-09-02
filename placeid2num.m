function [ placeid ] = placeid2num( id )
    if (length(id)==10)
        val=double(id(7));
        placeid=val-double('0');
    elseif (length(id)==11)
        val=double(id(8));
        placeid=val-double('a')+10;
    else
        error('invalid place format');
    end;
        
        