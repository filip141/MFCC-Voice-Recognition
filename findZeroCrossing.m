function [ zerosCounter ] = findZeroCrossing( signal )
%Function counts number of zero crossing in signal
%   INPUT : Signal
%   OUTPUT : Zeros Frequency

N = length(signal);
zerosCounter = 0;
refsig = 0;


for i = 1:N-1
    
    if signal(i + 1) == 0 && (i + 1) < N 
        refsig = signal(i + 2);
    else
        refsig = signal(i + 1);
    end
        
    if sign(signal(i)) == -sign(refsig)
        zerosCounter = zerosCounter + 1;
    end
    
end


end

