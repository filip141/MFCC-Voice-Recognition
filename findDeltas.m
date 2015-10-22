function [ extFeatureVector ] = findDeltas( featureVector )
%	Find delta coefficient d(t) = c(n-t) - c(n+t)/2
%   Input : feature Vector with MFCC coeffs
%   Output : extended feature vector with delta and double delta coeffs


%% initialize variables
delta = [];
extMell = [];
extFeatureVector = [];
Nf = size(featureVector);
Nf = Nf(2);


%% Find deltas 
for i = 1:Nf
    indNext = i + 1;
    indPrev = i - 1;
    if indPrev < 1
        indPrev = 1;
    end
    if indNext > Nf
        indNext = Nf;
    end
    delta = (featureVector(:,indNext) - featureVector(:,indPrev))./2;
    
    %Extend feature Vector
    extMell = [ featureVector(:,i); delta ];
    extFeatureVector = [ extFeatureVector extMell ];
end

extFeatureVector = findDoubleDeltas( extFeatureVector );

end

