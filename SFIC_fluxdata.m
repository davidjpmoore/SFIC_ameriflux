% Matt Roby
% 11/21/2019
% Site synthesis

%% README

% % FLUXNET2015 Dataset README
% % 
% % The distribution of the FLUXNET2015 Dataset is done via:
% % http://fluxnet.fluxdata.org/
% % 
% % 
% % For support and information about the dataset, please contact:
% % fluxdata-support@fluxdata.org
% % 
% % 
% % Information about the FLUXNET2015 Dataset:
% % http://fluxnet.fluxdata.org/data/fluxnet2015-dataset/
% % 
% % 
% % Information about the data processing for the FLUXNET2015 Dataset:
% % http://fluxnet.fluxdata.org/data/fluxnet2015-dataset/data-processing
% % 
% % 
% % Information about the data variables for the FLUXNET2015 Dataset:
% % FULLSET (complete set of variables):
% % http://fluxnet.fluxdata.org/data/fluxnet2015-dataset/fullset-data-product
% % SUBSET (selected set of variables):
% % http://fluxnet.fluxdata.org/data/fluxnet2015-dataset/subset-data-product
% % 
% % 
% % Data policy and acknowledgements for the FLUXNET2015 Dataset:
% % http://fluxnet.fluxdata.org/data/data-policy/

%% Script
% Clean up
clear all; close all; fclose('all'); clc

% Add path to functions
addpath('G:\My Drive\Research\functions')

% Set working directory
cd 'F:\extracted'

% Find files with annual data (YY)
file_list = dir('*FULLSET_YY*.csv');

% create empty cell
fluxdata = cell(1,length(file_list));

% load data into cell
for i = 1:length(file_list)
    fluxdata{i} = readtable(file_list(i).name);
end

% Convert latent heat flux to ET
latentheat = 2.452e6; %latent heat of vaporization (J/kg)
t=365*24*60*60; % amount of seconds in one year

for i = 1:length(fluxdata)
GPP_night_mean{i} = mean(fluxdata{1,i}.GPP_NT_CUT_MEAN);
GPP_day_mean{i} = mean(fluxdata{1,i}.GPP_DT_CUT_MEAN);
Reco_night_mean{i} = mean(fluxdata{1,i}.RECO_NT_CUT_MEAN);
Reco_day_mean{i} = mean(fluxdata{1,i}.RECO_NT_CUT_MEAN);
NEE_mean{i} = mean(fluxdata{1,i}.NEE_CUT_MEAN); % Net Ecosystem Exchange, using Constant Ustar Threshold (CUT) across years, average from 40 NEE_CUT_XX versions
ET_mean{i} = mean(fluxdata{1,i}.LE_F_MDS.*(t/latentheat)); % LE_F_MDS is latent heat flux, gapfilled using MDS method; coverted to mm/year ET
start_year{i} = min(fluxdata{1,i}.TIMESTAMP);
end_year{i} = max(fluxdata{1,i}.TIMESTAMP);
site{i} = file_list(i,1).name(5:10);
end

% Write data to table with variable names
master_cell = [site' start_year' end_year' NEE_mean' GPP_day_mean' GPP_night_mean' Reco_day_mean' Reco_night_mean' ET_mean'];
master_table = cell2table(master_cell, 'VariableNames', {'site', 'start_year', 'end_year', 'NEE_gCm2y1', 'GPPdayPartition_gCm2y1','GPPnightPartition_gCm2y1', 'RECOdayPartition_gCm2y1','RECOnightPartition_gCm2y1','ET_mm_year'});

% Write to file
writetable(master_table,'annualfluxes.csv')

%% Old below
% 
% 
% year{i} = fluxdata{1,i}(:,1);
% GPP_NT{i} = fluxdata{1,i}(:,254);
% GPP_DT{i} = fluxdata{1,i}(:,298);
% name{i} = file_list(i,1).name(5:10)
% 
% mean(GPP_NT{1,1})
% 
% % loop through filenames and extract information
% for i = 1:length(cs_parsed_filenames)
%     cs_parsed_year{i} = cs_parsed_filenames{i,1}{1,5};
%     cs_parsed_month{i} = cs_parsed_filenames{i,1}{1,6};
%     cs_parsed_day{i} = cs_parsed_filenames{i,1}{1,7};
%     cs_parsed_hour_long{i} = cs_parsed_filenames{i,1}{1,8};
%     
%     
%     
% 
% % Site names
% site_name = cell(1,length(file_list));
% 
% site_name = file_list.name(5:10)
% 
% 
% %%
% 
% 
% 
% 
% 
% 
% clear i 
% for i=1:length(file_list);
%     filetest=readmatrix(file_list(i).name);
%     name = file_list(i).name
% end
% 
% fname = file_list(i).name(5:10)
% 
% 
% d = dir('*FULLSET_YY*.csv');
% 
% 
% 
% 
% 
% site = readmatrix('C:\Users\mattroby\Downloads\FLX_US-Wkg_FLUXNET2015_FULLSET_2004-2014_1-3\FLX_US-Wkg_FLUXNET2015_FULLSET_YY_2004-2014_1-3.csv');
% 
% year = site(:,1)
% GPP_NT = site(:,254)
% GPP_DT = site(:,298)
% 
% 
% 
% % 30-min data below
% 
% % % Read in data
% % %site_name = readmatrix('C:\Users\mattroby\Downloads\FLX_US-Ha1_FLUXNET2015_FULLSET_1991-2012_1-3\FLX_US-Ha1_FLUXNET2015_FULLSET_HR_1991-2012_1-3.csv');
% % 
% % site_name = readmatrix('C:\Users\mattroby\Downloads\FLX_US-Wkg_FLUXNET2015_FULLSET_2004-2014_1-3\FLX_US-Wkg_FLUXNET2015_FULLSET_HH_2004-2014_1-3.csv');
% % 
% % 
% % 
% % % Time
% % timestamp = num2str(site_name(:,1));
% % years = str2num(timestamp(:,1:4));
% % months = str2num(timestamp(:,5:6));
% % days = str2num(timestamp(:,7:8));
% % hh = str2num(timestamp(:,9:10));
% % mm = str2num(timestamp(:,11:12));
% % time = datetime(years,months,days);
% % 
% % % GEP
% % GEP = site_name(:,199);
% % 
% % % Fuse
% % master = timetable(time, GEP);
% % 
% % % Daily means
% % table_daily = table(year(master.time), month(master.time), day(master.time), master.GEP);
% % table_daily.Properties.VariableNames = {'years';'months';'day';'GEP'};
% % omean = @(x) mean(x,'omitnan');
% % table_daily_output = varfun(omean,table_daily,'GroupingVariables',{'years','months','day'}, 'InputVariables',{'GEP'});
% % 
% % close all; plot(time,GEP); hold on;
% % plot(table_daily_output.Fun_GEP)
% % 
% % test = grpstats(table_daily_output.Fun_GEP, table_daily_output.years,'sum')
% % 
% % close all; plot(test)