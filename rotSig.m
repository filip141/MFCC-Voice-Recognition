function [ newsig ] = rotSig( SIGNAL )
%If signal have incorrect form rotate signal
%   Input : Signal
%   Output : Rotated signal

[~, hor] = size(SIGNAL);

if hor > 1
    if hor == 2
        newsig = SIGNAL(:,1) + SIGNAL(:,2);
    else
        newsig = SIGNAL';
    end
else
    newsig = SIGNAL;
end

end

