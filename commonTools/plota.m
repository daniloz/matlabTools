function hp = plota(varargin)
% PLOTA 
%  is the same as standard PLOT function, BUT it plots each new plot
%    using other color ( making 'hold on' automatically and cycling 
%    through the colors in the order specified by the current axes 
%    ColorOrder property )
%
%  EXAMPLE:
%  figure;
%  plota(randn(1,100));
%  plota(randn(1,100));
%  plota(randn(1,100));
%  legend('First call to plota', 'Second call to plota', 'Third call to plota')

% Version 1.0
% Alex Bur-Guy, October 2005
% alex@wavion.co.il
%
% Version 1.2
% Danilo Zanatta, November 2010
%
% Revisions:
%       Version 1.0 -   initial version
%       Version 1.2 -   returning handle to line 
%                   -   possible to pass an axes handle to plot into it

if isAxesHandle(varargin{1}),
    ca = varargin{1};
    plotArgs = varargin(2:end);
  else
    ca = get(get(0,'CurrentFigure'),'CurrentAxes');
    plotArgs = varargin(1:end);
end
  
if isempty( ca )     
     ordi0 = 0;
else
     ordi0 = length(get(ca,'Children'));
     CurrentHold = get(ca, 'NextPlot');
     set(ca, 'NextPlot', 'add' );
end
hp_tmp = plot(ca, plotArgs{:} );
ColOrd = get(ca, 'ColorOrder');
children = get(ca,'Children');
ordi = length(children);
ord = mod((ordi0+1:ordi)-1, size(ColOrd,1));
cc = 0;
for ii = (ordi - ordi0): -1 : 1
     cc = cc + 1;
     set(children(ii), 'Color', ColOrd(((ordi0+cc)<=size(ColOrd,1))*(ordi0+cc) + ((ordi0+cc)>size(ColOrd,1))*(ord(cc)+1), :));
end
if ordi0 == 0,
    set( ca, 'NextPlot', 'replace');
else
    set( ca, 'NextPlot', CurrentHold);
end
if nargout == 1,
    hp = hp_tmp;
end

%
%==============================================================================
% isAxesHandle - determine if an input argument is an axes handle
%
function isAxes = isAxesHandle(hAxes)

isAxes = logical(0);
if (length(hAxes) == 1) & ishandle(hAxes) & strcmp(get(hAxes,'Type'),'axes'),
  isAxes = logical(1);
end
