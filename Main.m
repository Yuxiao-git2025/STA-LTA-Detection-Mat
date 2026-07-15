%% Seismic Wave Detection Script
% Refer to: Tonumoy Mukherjee
% XA.,Yu 2026/07
% Processing flow:
% 1. Load three-component acceleration data
% 2. Remove trend and filter signals
% 3. Integrate vertical acceleration to velocity and displacement
% 4. Detect P-wave using STA/LTA
% 5. Detect S-wave using horizontal-component peaks
% 6. Generate figures
clear;
clc;

%% >> Configuration
global config;
config=struct();

config.fs=200; % Sampling frequency (Hz)

% DATA-PATH
config.dataDir='Data';
config.fileE=fullfile(config.dataDir,'Example.HHE.dat');
config.fileN=fullfile(config.dataDir,'Example.HHN.dat');
config.fileV=fullfile(config.dataDir,'Example.HHZ.dat');

% Band-pass processing parameters
config.Freq1=20; % Low-pass cutoff frequency
config.Freq2=0.8; % High-pass cutoff frequency
config.FreqOrder=4;

% STA/LTA parameters for P-wave detection
config.WinSTA=3; % Short-term window length
config.WinLTA=15; % Long-term window length
config.Trigon=1.5; % Trigger-on threshold
config.Trigoff=1.2; % Trigger-off threshold

% S-wave detection parameters
config.WinPS=0.5; % Ignore horizontal peaks before this time after P
config.SPeak=0.72; % Peak threshold relative to horizontal maximum

% Early-warning parameter window
config.WinWarning=3.0; % 3 seconds = 3*fs samples

% Approximate local P- and S-wave velocities
config.Vp=6.0;
config.Vs=config.Vp/sqrt(3);

%% >> Load Three-Component Acceleration Data
accE0=Det_LoadWave(config.fileE);
accN0=Det_LoadWave(config.fileN);
accV0=Det_LoadWave(config.fileV);
time=(0:numel(accV0)-1)'/config.fs;

%% >> Preprocess Data
% AccE: East-West acceleration
% AccN: North-South acceleration
% AccV: Vertical acceleration
[accE,velE,disE]=Det_TransformWave(accE0);
[accN,velN,disN]=Det_TransformWave(accN0);
[accV,velV,disV]=Det_TransformWave(accV0);

%% >> Detect P-Wave Using STA/LTA
ResP=Det_CalSTALTA(accV);
pTime=ResP.onsetTime;
if isnan(pTime)
    warning('# No P-wave trigger was found');
else
    fprintf('# P-wave arrival time: %.3f s\n',pTime);
end

%% >> Detect S-Wave from Horizontal Components
ResS=Det_CalSArrival(accE,accN,pTime);
sTime=ResS.arrivalTime;
if isnan(sTime)
    warning('# No S-wave trigger was found');
else
    fprintf('# S-wave arrival time: %.3f s\n',sTime);
    fprintf('#    Selected component: %s\n',ResS.component);
end

%% >> Estimate Earthquake Distance from P-S Time Difference
Dist=Det_CalDist(pTime,sTime);
if ~isnan(Dist)
    fprintf('# Estimated earthquake distance: %.2f km\n',Dist);
end

%% >> Plot Results
Det_PlotWave(time,accV,velV,disV,pTime,sTime);
Det_PlotSTALTA(time,accV,ResP,sTime);
% Det_PlotSpectrogram(time,accV,pTime,sTime);


