function [] = WormRaster()
% WormRaster.m
% 
% Generates raster plot of different categories of behavioral events across
% individual worms.
%
% Adapts spikeRasterPlot.m and cbrewer code.
%
% Inputs: .xlsx file containing data organized
% into 3 columns (in this order): timeElapsed (in minutes), wormID, behavioralEventID
%
% Outputs: .epsc and .jpeg files of the raster plot
%
% Created 8/12/22 by Astra S. Bryant


%% Code
% Ask user to pick an .xlsx file containing data. Data should be organized
% into 3 columns: timeElapsed (in minutes), wormID, behavioralEventID
[name, pathstr] = uigetfile2({'*.xlsx'},'Select Data File');
if isequal(name,0)
    error('User canceled analysis session');
end
filename = fullfile(pathstr, name); %Generate path to file readable by readtable

n = strsplit(name, '.xlsx'); % Strip file extension text from file name
n = n{1};

fulltable = readtable(filename); %Import the data

timeElapsed = minutes(fulltable{:,1}); % convert times from input data into a duration array, required for spikeRaserPlot
worms = categorical(fulltable{:,2}); % convert wormIDs from input data into a categorical array, required for spikeRaserPlot
behavioralEvents = categorical(fulltable{:,3}); % convert behavioral event types from input data into a categorical array, required for spikeRaserPlot

% Set the color scheme, colors taken from Dark2 colormap in cbrewer
colors = [27,158,119;217,95,2;117,112,179;231,41,138;102,166,30;230,171,2;166,118,29;102,102,102]/256;

% Make the plot
p = spikeRasterPlot(timeElapsed, worms, 'GroupData', behavioralEvents, ...
    'TitleText', 'Behavioral Event Raster Plot', 'SubtitleText', ['Data source: ', name], ...
    'XLabelText', 'Elapsed Time', 'YLabelText', 'Worms', 'ColorOrder', colors);

% Save the plot as both .espc and .jpeg files
saveas(p, fullfile(pathstr, ['/', n, '-rasterplot.eps']),'epsc');
saveas(p, fullfile(pathstr,['/', n, '-rasterplot.jpeg']),'jpeg');
end

% Including uigetfile2 as an "inline" function to reduce the number of
% separate .m files
function [filename, pathname] = uigetfile2(filterspec, title, varargin)
%% uigetfile2
% Wrapper for standard open file dialog box that adds a modal component
% printing the title of the dialog box when run on non-PC computers
% [FILENAME, PATHNAME] = uigetfile2(FILTERSPEC, TITLE)
%
% [FILENAME, PATHNAME] = uigetfile(FILTERSPEC, TITLE, FILE)
%    FILE is a string containing the name to use as the default selection
%
% [FILENAME, PATHNAME] = uigetfile(..., 'MultiSelect', SELECTMODE)
%     specifies if multiple file selection is enabled for the uigetfile
%     dialog. Valid values for SELECTMODE are 'on' and 'off'. If the value of
%     'MultiSelect' is set to 'on', the dialog box supports multiple file
%     selection. 'MultiSelect' is set to 'off' by default.

% Set default values
file = '';
multiselect = 'Multiselect';
selectmode = 'off';

% Parse varargin
if nargin > 2
    if ~strcmp(varargin{1},'Multiselect')
        file = varargin{1};
    end
    if find(contains(varargin, 'Multiselect'))
        selectmode = varargin{find(contains(varargin, 'Multiselect'))+1};
    end
end

if ~ispc
    h = msgbox (title,'','modal');
    uiwait (h);
end

[filename, pathname] = uigetfile(filterspec, title, file, multiselect, selectmode);
end
