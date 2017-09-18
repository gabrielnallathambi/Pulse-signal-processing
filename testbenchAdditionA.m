clear;
%% Input Signals: x, y
Fs = 10000; % sampling frequency
signalTime = 0:1/Fs:2; % input time
xSignalAmplitude=3*ones(1,length(signalTime));  % input signal 'x'
ySignalAmplitude=2*ones(1,length(signalTime));   % input signal 'y'
%% IF parameters
pThreshold=0.1;
nThreshold=-pThreshold;
refractoryPeriod =0;
decayRate=0;
timeResolution = 1e-8;
%% Convert analog signals to pulses
xOutputPulses = apcTimeApprox(signalTime,xSignalAmplitude,pThreshold,nThreshold,refractoryPeriod,decayRate,timeResolution);
yOutputPulses = apcTimeApprox(signalTime,ySignalAmplitude,pThreshold,nThreshold,refractoryPeriod,decayRate,timeResolution);

%% Pulse addition
if (isempty(xOutputPulses) || isempty(yOutputPulses))
    disp('Check APC parameters')
else
    initialStartTime=signalTime(1);
    addOutputPulses = pulseAdditionA(initialStartTime,xOutputPulses,yOutputPulses);
    %% Plotting
    h=zeros(3,1);
    h(1)=subplot (3,1,1);
    stem(xOutputPulses(:,1),xOutputPulses(:,2))
    title('Input pulse train x')
    h(2)=subplot (3,1,2);
    stem(yOutputPulses(:,1),yOutputPulses(:,2))
    title('Input pulse train y')
    h(3)=subplot (3,1,3);
    stem(addOutputPulses(:,1),addOutputPulses(:,2))
    title('Output pulse train: Addition')
    linkaxes(h,'x')
end
