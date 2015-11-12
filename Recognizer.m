clear all
%% Const variables

SAMPLERATE = 16000;

%% Record and play voice sample 
% SIGNAL = wavrecord(NSEC*SAMPLERATE,SAMPLERATE,'double');
[SIGNAL,SAMPLERATE]=wavread('samples/Noise_Samples/KW/KW_1.wav');
% [SIGNAL,SAMPLERATE]=wavread('samples/Clear_Samples/jeden.wav');

wavplay(SIGNAL, SAMPLERATE);

featureVector = mfcc(SIGNAL, SAMPLERATE);

%% Recognizing word by no statistic algoritm DTW
recognizeDTW( featureVector )


