function [ Mel ] = MelFilterBanks( Low, High, SampleRate, Nfilter, PSDLength )
%This function compute mel triangular filter bank used to generate Mel
%Cepstral Coefficients 
%   Input : Sample Rate, Low frequency, High frequency of mel filter bank,
%    number of filters and PSD Length
%   Output: Mel FIlter Bank

FilterPoints = PSDLength;
nfft = (FilterPoints - 1)*2 + 1;

%% Set up High and Low frequency
HighFreq = High;
LowFreq = Low;
LowMel = HertzToMel(LowFreq);
HighMel = HertzToMel(HighFreq);

%% Build mel frequency vector
STEP = (HighMel - LowMel)/( Nfilter + 1 );
Melfreqs(1) = LowMel;
for i= 2:(Nfilter + 1)
   Melfreqs(i) = LowMel + (i-1)*STEP ; 
end
Melfreqs(end + 1) = HighMel;

%% Calculate hertz vector
HzFreqs = MelToHertz(Melfreqs);
SampleFreqs = floor(nfft*HzFreqs/SampleRate);
for i = 2:(Nfilter + 1)
    for j = 1:FilterPoints
        if(j < SampleFreqs(i-1))
            MelMatrix(i-1, j) = 0 ;
        else
            if(SampleFreqs(i-1) <= j && j<= SampleFreqs(i))
                MelMatrix(i-1, j) = (j - SampleFreqs(i - 1))/(SampleFreqs(i) - SampleFreqs(i - 1));
            else
                if(SampleFreqs(i) <= j && j <= SampleFreqs(i + 1))
                    MelMatrix(i-1, j) = (-j + SampleFreqs(i+1))/(SampleFreqs(i+1) - SampleFreqs(i));
                else
                    MelMatrix(i-1, j) = 0;
                end
            end
        end
    end
end
 Mel = MelMatrix;    
end

