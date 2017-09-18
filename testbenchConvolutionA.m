clear;
%% Input Signals: x, y
Fs = 10000; % sampling frequency
xSignalTime = 0:1/Fs:1; % x input time
ySignalTime = 0:1/Fs:1; % y input time
xSignalAmplitude=1*ones(1,length(xSignalTime));   % input signal 'x'
ySignalAmplitude=1*ones(1,length(ySignalTime));  % input signal 'y'

%% IF parameters
pThreshold=0.05;
nThreshold=-pThreshold;
refractoryPeriod =0;
decayRate=0;
timeResolution = 1e-8;
%% Convert analog signals to pulses
xOutputPulses = apcTimeApprox(xSignalTime,xSignalAmplitude,pThreshold,nThreshold,refractoryPeriod,decayRate,timeResolution);
yOutputPulses = apcTimeApprox(ySignalTime,ySignalAmplitude,pThreshold,nThreshold,refractoryPeriod,decayRate,timeResolution);
%% Reference Time
if decayRate==0
    referenceTime=pThreshold;
else
    referenceTime=(-1/decayRate)*log(1-(pThreshold*decayRate));
end
%% Pulse Convolution
if (isinf(referenceTime) || isempty(xOutputPulses) || isempty(yOutputPulses))
    disp('Check APC parameters')
else
    xInitialStartTime=xSignalTime(1);
    yInitialStartTime=ySignalTime(1);
    convOutputPulses = pulseConvolutionA(xInitialStartTime,yInitialStartTime,xOutputPulses,yOutputPulses,referenceTime);
    %% Plotting
    h=zeros(3,1);
    h(1)=subplot (3,1,1);
    stem(xOutputPulses(:,1),xOutputPulses(:,2))
    xlabel('time');
    ylabel('threshold')
    title('Input pulse train x')
    h(2)=subplot (3,1,2);
    stem(yOutputPulses(:,1),yOutputPulses(:,2))
    xlabel('time');
    ylabel('threshold')
    title('Input pulse train y')
    h(3)=subplot (3,1,3);
    stem(convOutputPulses(:,1),convOutputPulses(:,2))
    xlabel('time');
    ylabel('threshold')
    title('Output pulse train: Convolution')
    linkaxes(h,'x')
    set(h,'XLim',[0 convOutputPulses(end,1)])
end



