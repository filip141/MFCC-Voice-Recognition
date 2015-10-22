function [ str ] = recognizeDTW( MelCoefs )
%Try to recognize word by mel - cepstral coefficient
%   Input : Mel - cepstral coefficient
%   Output : recognized string

%Load Sample Bank
load('samplebankExt.mat');

%Dynamic Time Warping Function
[ sumdist(1) ] = DTW( MelCoefs, MelCoefs1 );

[ sumdist(2) ] = DTW( MelCoefs, MelCoefs2 );

[ sumdist(3) ] = DTW( MelCoefs, MelCoefs3 );

[ sumdist(4) ] = DTW( MelCoefs, MelCoefs4 );

[ sumdist(5) ] = DTW( MelCoefs, MelCoefsTak );

[ sumdist(6) ] = DTW( MelCoefs, MelCoefsNie );

if (min(sumdist) == sumdist(1))
    str = '1';
end
if (min(sumdist) == sumdist(2))
    str = '2';
end
if (min(sumdist) == sumdist(3))
    str = '3';
end
if (min(sumdist) == sumdist(4))
    str = '4';
end
if (min(sumdist) == sumdist(5))
    str = 'Tak';
end
if (min(sumdist) == sumdist(6))
    str = 'Nie';
end


end

