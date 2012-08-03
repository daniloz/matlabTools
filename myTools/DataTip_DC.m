function output_txt = DataTip_DC(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

DC = 1;
N = 1; % plus/minus N samples

pos = get(event_obj,'Position');
xx = get(event_obj.Target,'XData');
yy = get(event_obj.Target,'YData');
name = get(event_obj.Target,'DisplayName');

output_txt = {name, sprintf('X: %d -> Y: %9.7f (%7.4f dB)\n',[xx(pos(1)+(-N:N))' yy(pos(1)+(-N:N))' db(yy(pos(1)+(-N:N))') ]')};

% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['Z: ',num2str(pos(3),4)];
end
