clear;
%% Input Signals: x, y
Fs = 10000; % sampling frequency
signalTime = 0:1/Fs:2; % input time
xSignalAmplitude=1*ones(1,length(signalTime));   % input signal 'x'
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

%% Reference Time
if decayRate==0
    referenceTime=pThreshold;
else
    referenceTime=(-1/decayRate)*log(1-(pThreshold*decayRate));
end
%% Pulse multiplication
if (isinf(referenceTime) || isempty(xOutputPulses) || isempty(yOutputPulses))
    disp('Check APC parameters')
else
    initialStartTime=signalTime(1);
    multOutputPulses = pulseMultiplicationA(initialStartTime,xOutputPulses,yOutputPulses,referenceTime);
    %% Plotting
    h=zeros(3,1);
    h(1)=subplot (3,1,1);
    stem(xOutputPulses(:,1),xOutputPulses(:,2))
    title('Input pulse train x')
    h(2)=subplot (3,1,2);
    stem(yOutputPulses(:,1),yOutputPulses(:,2))
    title('Input pulse train y')
    h(3)=subplot (3,1,3);
    stem(multOutputPulses(:,1),multOutputPulses(:,2))
    title('Output pulse train: Multiplication')
    linkaxes(h,'x')
end
