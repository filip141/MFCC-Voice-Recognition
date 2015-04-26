%Const variables
SAMPLERATE = 16000;
NSEC = 1.5;
N = 12;
Nfilter = 26;

%Record and play voice sample 
SIGNAL = wavrecord(NSEC*SAMPLERATE,SAMPLERATE,'double');
wavplay(SIGNAL,SAMPLERATE);
% [SIGNAL,SAMPLERATE]=wavread('tak.wav');

SIGNAL = silence( SIGNAL );

%Signal divided into 25milisecond frames
[ FramesMatrix ] = Framing( SIGNAL, SAMPLERATE );
[SHor SVec] = size(FramesMatrix);

%Creating Hamming window
window = hamming(SVec);

%For each Frame
for k = 1:SHor
    MPSD = [];
    %Multiply Frame with Hamming window
    frame = FramesMatrix(k,:).*window';
    %Preemfaza
    frame = filter([1 -0.9735], 1, frame); 
    %Calculating Power Spectrum Density
    PSD = abs(fft(frame,512)).^2;
    PSD = PSD(256:end);
    %Calculate Mel filterbank
    [ MelMatrix ] = MelFilterBanks( 300, 8000, SAMPLERATE, Nfilter );
    
    %MelEnergies vector initialization
    MelEnergies = zeros(26,257);
    %Init vector for scalar calculation
    MelScalarEnergies = zeros(26);
    
    %Multiple each filter with PSD
    for i = 1:26
        MelEnergies(i,:) = MelMatrix(i,:).*PSD;
        %Energy inside filter
        MelScalarEnergies(i) = sum(MelEnergies(i,:));
    end
    
    %Energies Logaritm
    MelLogEnergies = log(MelScalarEnergies);
    for j = 1:N
        CepstralSum = 0;
        for n = 1:Nfilter
            CepstralSum = CepstralSum + MelLogEnergies(n).*cos((pi*j/Nfilter)*(n-0.5));
        end
        MelCoefs(k, j) = sqrt(2/Nfilter)*CepstralSum;
    end   
end

%Load Sample Bank
load('samplebank.mat');

%Dynamic Time Warping Function
[ sumdist(1) ] = DTW( MelCoefs, MelCoefs1 );

[ sumdist(2) ] = DTW( MelCoefs, MelCoefs2 );

[ sumdist(3) ] = DTW( MelCoefs, MelCoefs3 );

[ sumdist(4) ] = DTW( MelCoefs, MelCoefs4 );

[ sumdist(5) ] = DTW( MelCoefs, MelCoefsTak );

[ sumdist(6) ] = DTW( MelCoefs, MelCoefsNie );

if (min(sumdist) == sumdist(1))
    '1'
end
if (min(sumdist) == sumdist(2))
    '2'
end
if (min(sumdist) == sumdist(3))
    '3'
end
if (min(sumdist) == sumdist(4))
    '4'
end
if (min(sumdist) == sumdist(5))
    'Tak'
end
if (min(sumdist) == sumdist(6))
    'Nie'
end


