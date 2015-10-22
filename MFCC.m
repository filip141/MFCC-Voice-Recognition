clear all
%% Const variables
SAMPLERATE = 16000;
NSEC = 1.5;
N = 12;
Nfilter = 26;
coeffs = filter200;
featureVector = [];
coeffs = coeffs.Numerator;

%% Record and play voice sample 
% SIGNAL = wavrecord(NSEC*SAMPLERATE,SAMPLERATE,'double');
[SIGNAL,SAMPLERATE]=wavread('samples/Noise_Samples/FB/FB_4.wav');
% [SIGNAL,SAMPLERATE]=wavread('samples/Clear_Samples/jeden.wav');

%% Voice Activity Detector

% Rotate signal
SIGNAL = rotSig(SIGNAL);

% VAD
SIGNAL = voiceActivityDetector( SIGNAL, SAMPLERATE );
wavplay(SIGNAL,SAMPLERATE);
figure
plot(SIGNAL)

% High pass filter no information below 200 Hz
SIGNAL = filter(coeffs, 1, SIGNAL);

%% Pre-emphasis
SIGNAL = filter([1 -0.9735], 1, SIGNAL);

% spectrogram(SIGNAL)

%% Signal divided into 25milisecond frames
[ FramesMatrix ] = Framing( SIGNAL, SAMPLERATE );
[SHor SVec] = size(FramesMatrix);


% Creating Hamming window
window = hamming(SVec);

%% For each Frame
for k = 1:SHor
    
    % Multiply Frame with Hamming window
    frame = FramesMatrix(k,:).*window';
    
   
    % Calculating Power Spectrum Density
    PSD = abs(fft(frame,512)).^2;
    PSD = PSD(256:end);
    
    % Calculate Mel filterbank
    [ MelMatrix ] = MelFilterBanks( 300, 8000, SAMPLERATE, Nfilter );
    
    % MelEnergies vector initialization
    MelEnergies = zeros(26,257);
    % Init vector for scalar calculation
    MelScalarEnergies = zeros(26);
    
    % Multiple each filter with PSD
    for i = 1:26
        MelEnergies(i,:) = MelMatrix(i,:).*PSD;
        % Energy inside filter
        MelScalarEnergies(i) = sum(MelEnergies(i,:));
    end
    
    %Energies Logaritm
    MelLogEnergies = log(MelScalarEnergies);
    for j = 1:N
        CepstralSum = 0;
        for n = 1:Nfilter
            CepstralSum = CepstralSum + MelLogEnergies(n).*cos((pi*j/Nfilter)*(n-0.5));
        end
        MelCoefs(j) = sqrt(2/Nfilter)*CepstralSum;
    end 
    frameEnergy = sum(frame.^2);
    MelExtended = [ MelCoefs' ; frameEnergy ] ;
    featureVector = [ featureVector  MelExtended ];
end

featureVector = findDeltas(featureVector);
% surf(featureVector)

%% Recognizing word by no statistic algoritm DTW
recognizeDTW( featureVector' )


