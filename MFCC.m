function [ featureVector ] = mfcc( SIGNAL, SAMPLERATE )
%   This function contains all modules whith will handle with 
% spectral future extraction problem. Every single weave 
% will go through all extraction steps like
% VAD, preemphasis, filtering, windowing , dfft
% and on the end mel-filterbank which produeces
% feature vector for one frame
%   Input  : wav signal with frequency 16kHz or n*16kHz
%   Output : feature matrix for given word



    %% Const variables
    def_samplerate = 16000;
    NSEC = 1.5;
    N = 12;
    Nfilter = 26;
    coeffs = filter200;
    featureVector = [];
    coeffs = coeffs.Numerator;


    %% Voice Activity Detector

    % Rotate signal
    SIGNAL = rotSig(SIGNAL);

    % Signal decimation
    SIGNAL = decimate(SIGNAL,SAMPLERATE,def_samplerate);
    SAMPLERATE = def_samplerate;

    % VAD
    SIGNAL = voiceActivityDetector( SIGNAL, SAMPLERATE );

    % High pass filter no information below 200 Hz
    SIGNAL = filter(coeffs, 1, SIGNAL);

    %% Pre-emphasis
    SIGNAL = filter([1 -0.9735], 1, SIGNAL);


    %% Signal divided into 25milisecond frames
    [ FramesMatrix ] = Framing( SIGNAL, SAMPLERATE );
    [SHor SVec] = size(FramesMatrix);

    nfft = 2^nextpow2( (0.025*SAMPLERATE) );
    PSDLength = nfft/2+1; 

    % Creating Hamming window
    window = hamming(SVec);


    %% For each Frame
    for k = 1:SHor

        % Multiply Frame with Hamming window
        frame = FramesMatrix(k,:).*window';

        % Calculating Power Spectrum Density
        PSD = abs(fft(frame,nfft)).^2;
        PSD = PSD( 1 : PSDLength );

        % Calculate Mel filterbank
        [ MelMatrix ] = MelFilterBanks( 300, SAMPLERATE/2, SAMPLERATE, Nfilter, PSDLength );

        % MelEnergies vector initialization
        MelEnergies = zeros(26,PSDLength);
        % Init vector for scalar calculation
        MelScalarEnergies = zeros(1,26);

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
            MelCoefs(j) = CepstralSum.*sqrt(2/Nfilter);
        end 
        frameEnergy = sum(frame.^2);
        MelExtended = [ MelCoefs' ; frameEnergy ] ;
        featureVector = [ featureVector  MelExtended ];
    end
    
    featureVector = findDeltas(featureVector);



end

