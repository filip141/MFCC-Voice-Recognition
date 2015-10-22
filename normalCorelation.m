function [ correlcoef ] = normalCorelation( speech, n, N )
%Finds normalised autocorrelation coeff at lag n
%   Input : speech frame, Signal length
%   Output : correlation coef

correl = [];
energy = [];
energyAtLag = [];

for i = 1:N-1
    
    correl(i) = speech(i)*speech(i+n);
    energyAtLag(i) = speech(i+n).^2;
    energy = speech(i).^2;

end

correlcoef = sum(correl)/sqrt(sum(energy)*sum(energyAtLag));
