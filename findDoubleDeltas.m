function [ extDelFeatureVector ] = findDoubleDeltas( extFeatureVector )
%	Find double delta coefficient dd(t) = d(n-t) - d(n+t)/2
%   Input : Extended feature vector with delta coefficients
%   Output : Dobule delta coefficient vector



%% initialize variables
ddelta = [];
extDelMell = [];
extDelFeatureVector = [];
Nf = size(extFeatureVector);
Nf = Nf(2);


%% Find double deltas 
for i = 1:Nf
    indNext = i + 1;
    indPrev = i - 1;
    if indPrev < 1
        indPrev = 1;
    end
    if indNext > Nf
        indNext = Nf;
    end
    ddelta = (extFeatureVector(14:end,indNext) - extFeatureVector(14:end,indPrev))./2;
    
    %Extend feature Vector
    extDelMell = [ extFeatureVector(:,i) ; ddelta ];
    extDelFeatureVector = [ extDelFeatureVector extDelMell ];
end


end

