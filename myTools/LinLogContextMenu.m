function LinLogContextMenu(ax)
% Create a context menu in axis 'ax' to change the x-axis to lin or log
%
% Usage: LinLogContextMenu(ax)
%
% Input:
%   - ax : handle to axis
%
% Example (use right click on axis to change the x-axis scale):
%   x = logspace(0,2,100);
%   y = linspace(1,100,100);
%   plot(x,y, 'linewidth',2)
%   LinLogContextMenu(gca)

% by Danilo Zanatta, last update 16.11.2010 at 11h10

hcmenu = uicontextmenu; % Create Context Menu
uimenu(hcmenu, 'Label', 'Linear', 'Callback', 'set(gco,''XScale'',''lin'')');   % Create context menu entry for Lin
uimenu(hcmenu, 'Label', 'Log', 'Callback', 'set(gco,''XScale'',''log'')');      % Create context menu entry for Log
set(ax,'UIContextMenu',hcmenu); % Insert the context menu into axes

end
