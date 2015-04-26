function [ nosilence ] = silence( SIGNAL )
%Silence function cuts silence from wav sample
%   In signal with silence
%   Out signal without silence

Th = 0.1;

tmpsig = SIGNAL/max(SIGNAL);
sth=(abs(tmpsig)>Th);
N = length(tmpsig);
sigstart = 0;


for i = 1:N
    if(sth(i) == 1)
        sigstart = i;
        break
    end
end
SIGNAL = SIGNAL(sigstart:end);
N = N - sigstart;
sigend = N;

for i = N:-1:1
    if(sth(i) == 1)
        sigend = i;
        break
    end
end

SIGNAL = SIGNAL(1:sigend);
nosilence = SIGNAL;

end

