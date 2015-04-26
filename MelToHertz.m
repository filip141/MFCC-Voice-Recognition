function [ Hertz ] = MelToHertz( Mel )
%Function return value in Hertz scale 
%   Output Hertz Scale Vector
%   Input Mel Scale Vector

Hertz = 700*(exp(Mel/1125)-1);

end

