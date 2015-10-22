function [ speech ] = voiceActivityDetector( speechWithSilence, Samplerate )
% This module detect silence in speech 
% and remove it from signal
%   Input : Speech with silence
%           Signal PSD
%   Output : only speech


% Signal divided into 25milisecond frames
[ FramesMatrix ] = Framing( speechWithSilence, Samplerate );
[SHor SVec] = size(FramesMatrix);

%Frame length
trigger = 0;
trmean = 0;
trstd = 0;
alfa = 0;
weight = [];
sampmeas = 0;
signal = [];
Ste = [];
Stp = [];
Zcr = [];

%Creating Hamming window
window = hamming(SVec);


%% For each Frame
for k = 1:SHor

    %Multiply Frame with Hamming window
    frame = FramesMatrix(k,:).*window';

    N = length(frame);

    %Calculating Power Spectrum Density
    PSD = abs(fft(frame)).^2;

    %% Signal features
    ZeroRate = (1/N)*findZeroCrossing(frame);
    Power = (1/N)*sum(PSD);
    Energy = sum(frame.^2);

    if k<10
        weight(k) =  Power*( 1 - ZeroRate)*(1/(40*10.0));
        signal(k) = 0;
    else
        if k == 10
            alfa = 0.005*var(weight)^(-0.92);
            trigger = mean(weight) + alfa*var(weight);
        else
            sampmeas = Power*( 1 - ZeroRate)*(1/(40*10.0));
            if sampmeas >= trigger
                signal(k) = 1;
            else
                signal(k) = 0;
            end
        end
    end
    Stp = [ Stp Power ];
    Zcr = [ Zcr ZeroRate ];
    Ste = [ Ste Energy];

end

Nos = length(signal);

% Human voice dynamics makes it unavalible to
% change signal in few ms 
for k = 10:Nos - 2
    if signal(k) == 1 && ( signal(k - 1) ~= 1 || signal(k - 2) ~= 1) && ( signal(k + 1) ~= 1 || signal(k + 2) ~= 1)
        signal(k) = 0
    end
end
refInd = find(signal > 0);
signal(refInd(1):refInd(end)) = 1;
% figure
% plot(signal)
% alfa
% trigger
% figure
% plot(Ste)
% title('STE');
% figure
% plot(Stp)
% title('STP');
% figure
% plot(Zcr)
% title('ZCR');
% figure
% plot(signal)
% alfa
% trigger
% weight

Nsw = length(speechWithSilence);
scalingFactor = Nsw/Nos;
speech = interp(signal,floor(scalingFactor));
Ns = length(speech);
for i = 1:Ns
    if speech(i) > 0.5 && speech(i) ~= 1
        speech(i) = 1;
    end
    if speech(i) < 0.5 && speech(i) ~= 0
        speech(i) = 0;
    end

end
speech = [ speech zeros(1, Nsw - Ns) ];
speech = speechWithSilence.*speech';
speech = speech( speech ~= 0 );

end

