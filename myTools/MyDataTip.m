function output_txt = MyDataTip(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

NB_DIGITS = 6;

pos = get(event_obj,'Position');
output_txt = {['X: ',num2str(pos(1),NB_DIGITS)],...
    ['Y: ',num2str(pos(2),NB_DIGITS)]};

% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['Z: ',num2str(pos(3),NB_DIGITS)];
end
