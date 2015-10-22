function [ newsig ] = cutsig( SIGNAL )
%cutsig function cuts signal
%   In signal
%   Out new signal

Th = 0.25;

tmpsig = SIGNAL;
newsig = [];
sth=(abs(tmpsig)>Th);
N = length(tmpsig);

for i = 1:N
    if(sth(i) ~= 1)
        tmpsig(i) = 0;
    else
        break
    end
end

for i = N:-1:1
    if(sth(i) ~= 1)
        tmpsig(i) = 0;
    else
        break
    end
end

newsig = tmpsig(tmpsig > 0);



end

