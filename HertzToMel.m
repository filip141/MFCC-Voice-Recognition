function [ Mel ] = HertzToMel( Hertz )
%Function return value in Mel scale 
%   Output Mel Scale Vector
%   Input Hertz Vector

Mel = 1125*log(1+Hertz/700);

end

