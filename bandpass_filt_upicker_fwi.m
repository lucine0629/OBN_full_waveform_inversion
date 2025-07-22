%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Name: bandpass_filter.m
%
% Function: bandpass filter the obs data using upicker

% Author: SZU-YING Lai (syll1n21@soton.ac.uk)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;
format long;

set(0,'DefaultFigureColor','w');
set(0,'DefaultAxesFontSize',10);

%% Path of SegyMAT
addpath './matlab_tools/'
addpath './matlab_tools/altmany-export_fig'
addpath './Geophysics_3.0/'
addpath './SegyMAT/'
addpath ./upicker/upicker_linux/
addpath ./upicker/upicker_linux/data_plot/

%% Input parameters
in_folder='./fwi_data/raw/';
out_folder='./fwi_data/p01_2-30hz_filter/';



%% Read su data
for obs = [02 04 10 12 14 16]
% for obs = [02]
name = sprintf('n_sem4a.01.obx%02d.4.su',obs); %hydrophone
% name = sprintf('n_sem4a.01.obx%02d.1.su',obs); % geophone

filename=[in_folder,name];

[Data0,SuTraceHeaders,SuHeader]=ReadSu(filename,'endian','l');
Data0=-1.*Data0;
Data1 = zeros(size(Data0));

for i=1:1:size(Data0,2)
    Data1(:,i)=filter_data(Data0(:,i),SuHeader.dt/1E6,2,30.0,0);  %% t03
end

%% Write to su file
outname = sprintf('2-30_filt_sem4a.01.obx%02d.4.su',obs);
filename=[out_folder,outname];
WriteSuStructure(filename,SuTraceHeaders,Data1,SuHeader);


end
