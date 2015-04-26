function [ FramesMatrix ] = Framing( SIGNAL, SampleRate )
%Framing function divide discrete function into 
%many frames 25ms each and 10ms step
%   Input parameter is SIGNAL variable it contain recorded signal and
%   Sample Rate
%   Output parameter is FramesMatrix it is two dimensional matrix whitch
%   contains set of frames.

%Divide into 25ms frames
FrameSamples = round(0.025*SampleRate);
STEP = round(0.010*SampleRate);
N = length(SIGNAL);
NSTEPS = floor(N/STEP);
SIGNAL = [SIGNAL' zeros(1,160)];
for counter = 1:(NSTEPS -1)
    StartFrame = ((counter - 1)*STEP + 1);
    EndFrame = StartFrame + FrameSamples - 1 ;
    FramesMatrix(counter,:) = SIGNAL( StartFrame: EndFrame);
end

end

