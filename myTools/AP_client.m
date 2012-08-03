function AP_client
    serverIP = 'localhost';
    Port = 3000;

    data = [];
    while ~strcmpi(data,'STOP'),
        % Waits for a new command
        data = [];
        while isempty(data),
            data = client(serverIP,Port,1);
        end
        if ~strcmpi(data,'STOP'),
            % Type in
            KeyPress(data);
        end
    end
end

function KeyPress(s)
    import java.awt.*;
    import java.awt.event.*;
    rob=Robot;
    keyCodes = double(s);
    for n = 1:length(keyCodes),
        rob.keyPress(keyCodes(n));
    end
end
