%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Name: plot_spectrum.m
%
% Function: Plot the amplitude spectrum

% Author: Szu-Ying Lai (syll1n21@soton.ac.uk)
%         24-09-2024;
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
% in_folder = './fwi_data/p03_35-8hz_filter/segy/';
in_folder = 'D:/szuying/2024_ULTRA/SEM4/4A/su/line01/REAL_OFFSET/p00_ori/segy/';
% in_folder = './fwi_data/p02_decon/segy/';
out_folder = './fwi_data/';



%% Read su data
for obs = [12];
% name = sprintf('p03_35-8hz_obx%02d_h.sgy',obs);
% name = sprintf('t01_obx%02d_2-6hz_obfilter.segy',obs);
name = sprintf('raw_sem4a.01.obx%02d.1.segy',obs);
% name = sprintf('bp2-30_filt_sem4a.01.obx%02d.4.sgy',obs);
% name = sprintf('2-30_obx%02d_1decon.sgy',obs);
filename=[in_folder,name];

[seismic,ebcdic_header,binary_header] = read_segy_file(filename,...
    {'times',[2050,4700]},{'traces',' source > 300 && source < 590'});
% [Data0,SuTraceHeaders,SuHeader]=ReadSu(filename,'endian','l');


Data0 = seismic.traces;
Data1 = zeros(size(Data0));

% for i=1:1:size(Data0,2)
%     Data1(:,i)=filter_data(Data0(:,i),SuHeader.dt/1E6,3,25.0,0);  %% t03
%     Data1(:,i)=filter_data(Data0(:,i),SuHeader.dt/1E6,3,10.0,0);  %% t04
% end

% seismic_sel = seismic.;

powerspect=s_power_spectrum(seismic,{'window','papoulis'},{'type','amplitude'});
s_wplot(s_stack(powerspect),{'times',0,130},{'orient','portrait'});


end