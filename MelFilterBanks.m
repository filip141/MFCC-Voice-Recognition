function [ Mel ] = MelFilterBanks( Low, High, SampleRate, Nfilter )
%This function compute mel triangular filter bank used to generate Mel
%Cepstral Coefficients 
%   Input : Sample Rate, Low frequency, High frequency of mel filter bank
%   and number of filters
%   Output: Mel FIlter Bank

Nfilters = Nfilter + 1;
FilterPoints = 257;
HighFreq = High;
LowFreq = Low;
LowMel = HertzToMel(LowFreq);
HighMel = HertzToMel(HighFreq);
STEP = (HighMel - LowMel)/26;
Melfreqs(1) = LowMel;
for i= 1:(Nfilters + 1)
   Melfreqs(i+1) = LowFreq + i*STEP ; 
end
Melfreqs(end) = HighMel;
HzFreqs = MelToHertz(Melfreqs);
SampleFreqs = floor(512*HzFreqs/SampleRate) ;
for i = 2:(Nfilters +1)
    for j = 1:FilterPoints
        if(j < SampleFreqs(i-1))
            MelMatrix(i, j) = 0 ;
        else
            if(SampleFreqs(i-1) <= j && j<= SampleFreqs(i))
                MelMatrix(i, j) = (j - SampleFreqs(i - 1))/(SampleFreqs(i) - SampleFreqs(i - 1));
            else
                if(SampleFreqs(i) <= j && j <= SampleFreqs(i + 1))
                    MelMatrix(i, j) = (-j + SampleFreqs(i+1))/(SampleFreqs(i+1) - SampleFreqs(i));
                else
                    MelMatrix(i, j) = 0;
                end
            end
        end
    end
end
 Mel = MelMatrix(3:end,:);    
end

