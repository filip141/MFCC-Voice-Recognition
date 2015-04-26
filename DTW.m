function [ sumdist ] = DTW( MelCoefs, MelCoefsx )
%DTW function calculating distance between sample model 
%and recorded model
%   Input Recorded Model, Sample Model
%   Output Calculated distance

COEFSNUMBER = 12;

[samph, ~] = size(MelCoefsx);
[sizh, ~] = size(MelCoefs);


for ns = 1:sizh
    for nw = 1:samph
        sum = 0;
        for k = 1:COEFSNUMBER
            
           sum = sum + (MelCoefs(ns, k) - MelCoefsx(nw, k)).^2;  
        end
        d(ns, nw)  = sqrt(sum);        
    end
end

g = d;

for ns = 2: sizh, g(ns, 1) = g(ns-1, 1) + d(ns, 1); end
for nw = 2: samph, g(1, nw) = g(1, nw-1) + d(1, nw); end

for ns = 2:sizh
    for nw = 2:samph
        dd = d(ns,nw);
        tmp(1) = g(ns-1, nw) + dd;
        tmp(2) = g(ns-1, nw-1) + 2*dd;
        tmp(3) = g(ns, nw-1) + dd;
        g(ns, nw) = min(tmp);
        
    end
end

sumdist = g(sizh, samph)/sqrt(sizh^2 + samph^2);

end

