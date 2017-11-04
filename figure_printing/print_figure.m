%  This file was created on: 
%  Wed Oct 25 18:25:59 CEST 2017
% 
%  Last edited on: 
%  Wed Nov  1 12:41:08 CET 2017
% 
%  Usage: print_figure(fileName,figureName,varargin)
%  Function to plot the data stored in fileName
%
%  INPUT: 
%  fileName: file where data is contained as columns with a header 
%  figureName: path and name of the resulting figure 
%
%  OPTIONAL:
%  'PlotType':  'All' to plot all the columns at the same time
%		'SomeAll' to plot some of the columns at the same time
% 		'XY' to plot one column as X and other as Y
%		'MultiXY' to plot several pairs of X and Y
% 		 except for 'All' the header of the columns to be
%		 ploted shuld be included.
%		 DEFAULT: 'All'
%
%  'DelimeterType':	'\t' for tab sepparated data
%			' ' for space separated data
%			',' for comma separated data
% 
%  'HeaderLines':	lines used for header. DEFAULT: 1
%
%  'Width':	Figure width. DEFAULT: 5
%  'Height':	Figure height. DEFAULT: 5
%  'AxesLineWidth': 	Width of axes lines. DEFAULT: 2
%  'FontSize':	Font Size. DEFAULT: 12
%  'LineWidth': Plot lines width. DEFAULT: 2
%  'MarkerSize':	Marker Size. DEFAULT: 3 %
%
%  'Title':	Figure title. DEFAULT: no title
%  'xlabel': 	X axis label. DEFAULT: no label
%  'ylabel':	Y axis label. DEFAULT: no label
%
%  OUTPUT: 
%  saves a figure in the path given by figureName
% 
%  AUTHORS: Paulo Goncalves, Patrice Abry, Esteban Bautista.
%  Information: estbautista@ieee.org

function print_figure(fileName,figureName,varargin)

% Initialize values
plotType = 'All';
delimeterType = '\t';
headerLines = 1; 
width = 5;
height = 5;
alw = 2;
fsz = 12;
lw = 2;
msz = 3;

% extract useful information for reading the file
for i = 1 : length(varargin)
	variable = varargin{i};
	switch variable
		case 'DelimeterType'
			delimeterType = varargin{i+1};
		case 'HeaderLines'
			headerLines = varargin{i+1};
		otherwise;
	end
end

% read data from file
data = importdata(fileName,delimeterType,headerLines);

% extract information for plotting
for i = 1 : length(varargin)
	variable = varargin{i};
	switch variable
		case 'Width'
			width = varargin{i+1};
		case 'Height'
			height = varargin{i+1};
		case 'AxesLineWidth'
			alw = varargin{i+1};
		case 'FontSize'
			fsz = varargin{i+1};
		case 'LineWidth'
			lw = varargin{i+1};
		case 'MarkerSize'
			msz = varargin{i+1};
		case 'PlotType'
			plotType = varargin{i+1};
		otherwise;
	end
end					

fig = figure('visible','off');

% plot accordingly to the plot specifications provided
switch plotType
	case 'All'
		plot(data.data,'-o','LineWidth',lw,'MarkerSize',msz);
		num_figs = size(data.data,2);
		var_labels = data.textdata(1,:);
		init_fig = length(var_labels) - num_figs + 1;
		legend(var_labels(init_fig:end),'Location','Best');	
	case 'SomeAll'
		var_names = varargin;
		num_figs = size(data.data,2);
		var_labels = data.textdata(1,:);
		init_fig = length(var_labels) - num_figs + 1;
		index_figs = ismember(var_labels,var_names);
		plot(data.data(:,index_figs(init_fig:end)),'-o','LineWidth',lw,'MarkerSize',msz);
		legend(var_labels(index_figs),'Location','Best');
	case 'XY'
		var_names = varargin;
		index_varargin = ismember(var_names,'XY');
		X_label = var_names(find(index_varargin,1,'first') + 1);
		Y_label = var_names(find(index_varargin,1,'first') + 2);
		num_figs = size(data.data,2);
		var_labels = data.textdata(1,:);
		init_fig = length(var_labels) - num_figs + 1;
		X_index = ismember(var_labels,X_label);
		Y_index = ismember(var_labels,Y_label);
		plot(data.data(:,X_index(init_fig:end)),data.data(:,Y_index(init_fig:end)),'-o','LineWidth',lw,'MarkerSize',msz);
		legend(Y_label,'Location','Best');	
	case 'MultiXY'
		var_names = varargin;
		num_figs = size(data.data,2);
		var_labels = data.textdata(1,:);
		init_fig = length(var_labels) - num_figs + 1;
		index_varargin = find(ismember(var_names,var_labels));
		for i = 1 : length(index_varargin)/2
			X_index = ismember(var_labels,var_names(index_varargin(2*i -1)));
			Y_index = ismember(var_labels,var_names(index_varargin(2*i)));
			Y_label(i) = var_names(index_varargin(2*i));
			X_data(:,i) = data.data(:,X_index(init_fig:end));
			Y_data(:,i) = data.data(:,Y_index(init_fig:end));
		end
	 	plot(X_data,Y_data,'-o','LineWidth',lw,'MarkerSize',msz);
		legend(Y_label','Location','Best');
	otherwise;		
end

% extract information for plot labeling
for i = 1 : length(varargin)
	variable = varargin{i};
	switch variable
		case 'Title'
			title(varargin{i+1});
		case 'xlabel'
			xlabel(varargin{i+1});
		case 'ylabel'
			ylabel(varargin{i+1});
	end
end

pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
set(gcf,'InvertHardcopy','on');

set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

print(fig,figureName,'-dpng','-r300');
end

