function Sline = getline()

disp('Select the line to get the information from...')

T = 1;
while (T ~= 0)
    T = waitforbuttonpress;
end


% get the handles to the selected object
hselect = gco;

objType = get(hselect,'Type');
if (strcmp(objType,'line') ~= 1)
    error('Object is not a line, it is of type %s.',objType);
end

% Get the line data
Sline.handle = hselect;
Sline.X = get(hselect,'xData');
Sline.Y = get(hselect,'yData');
Sline.Color      = get(hselect,'Color');
Sline.LineStyle  = get(hselect,'LineStyle');
Sline.LineWidth  = get(hselect,'LineWidth');
Sline.Marker     = get(hselect,'Marker');
Sline.MarkerSize = get(hselect,'MarkerSize');
Sline.DisplayName = get(hselect,'DisplayName');
