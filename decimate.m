function [ new_sig ] = decimate( signal, fs, fns )
%Function will drop every nth sample to 
%downstep samplerate
%   Input : signal ( speech samples vector ),
%           fs - samplerate,fns - new downstep somplerate
%   Output : New signal 16kHz

if fs > fns

    step = round(fs/fns);
    N = length(signal);
    new_sig = [];
    counter = 1;

    for i = 1:N

        if mod(i,step) == 0
            new_sig(counter) = signal(i);
            counter = counter + 1;
        end

    end
    
    new_sig = new_sig';

else
    
    new_sig = signal;

end



end


