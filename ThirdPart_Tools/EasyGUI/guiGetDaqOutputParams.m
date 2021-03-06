% guiGetDaqInputParams
%  S = guiGetDaqOutputParams() shows a dialog box that allows the user to 
%      specify the configuration for analog data acquisition. 
%  
%  THIS IS A HELPER FUNCTION FOR THE GUI.DAQINPUT CLASS. 

%  S = guiGetDaqOutputParams() shows a dialog box that allows the user to 
%      specify the configuration for analog data acquisition. It returns a
%      structure S with the following fields:
%         adaptor
%         boardId 
%         channels 
%         sampleRate 
%      S is [] if (a) the user cancelled the dialog box, (b) closed it, 
%      or (c) the dialog box is not completely filled out. 
%      
%  S = guiGetDaqOutputParams(D) uses the struct D as the default values for
%      the fields of the dialog box. D should have the same fields as S.

%   by Danilo Zanatta, latest update on 07.10.2010 at 12:06
%   http://www.mathworks.com/matlabcentral/fileexchange/authors/53276

function out = guiGetDaqOutputParams(defaultConfig)

if nargin == 0
    defaultConfig = [];
else
    if ~isstruct(defaultConfig)
        error('defaultConfig should be a struct');
    end
end

myGui = gui.autogui('Visible', false, 'Location', 'float');
myGui.Name = 'Configure analog output';
myGui.PanelWidth = 300;

% create widgets (with initial dummy values)
myAdaptor = gui.textmenu('Adaptor', {' '}, myGui);
myAdaptor.LabelLocation = 'left';
myAdaptor.ValueChangedFcn = @adaptorCallback;

myBoardId = gui.textmenu('Board ID', {' '}, myGui);
myBoardId.LabelLocation = 'left';
myBoardId.Enable = false;
myBoardId.ValueChangedFcn = @boardIdCallback;

myBoardName = gui.label('Board Name', myGui);
myBoardName.Font.angle = 'normal';
myBoardName.Font.size = 10;

myChannels = gui.listbox({'Analog channels', '(Ctrl+Click for multiple selections)'}, {' '}, myGui);
myChannels.Value = [];
myChannels.LabelLocation = 'left';
myChannels.Position.height = 60;
myChannels.Enable = false;

mySampleRate = gui.editnumber('Sample rate (Hz)', myGui);
mySampleRate.LabelLocation = 'left';
mySampleRate.Enable = false;
mySampleRate.ValueChangedFcn = @sampleRateCallback;

gui.label('', myGui); 

myButtonGroup = gui.group('righttoleft', myGui);
myButtonGroup.BorderType = 'none';
myButtonGroup.BackgroundColor = myGui.BackgroundColor;
myButtonGroup.Position.width = 300;
myCancelBtn = gui.pushbutton('Cancel', myButtonGroup);
myCancelBtn.Position.width = 100;
mySubmitBtn = gui.pushbutton('Submit', myButtonGroup);
mySubmitBtn.Position.width = 100;

myGui.Visible = true;
myGui.Exclusive = true;

myAnalogOutputObj = [];
myAnalogOutputInfo = [];

initializeFields(defaultConfig);
myGui.monitor(myButtonGroup);
allOk = myGui.waitForInput();
if ~allOk || myGui.LastInput == myCancelBtn
    % window was closed by user or user hit cancel
    out = [];
else
    out.adaptor = myAdaptor.Value;
    out.boardId = myBoardId.Value;
    out.channels = str2double(myChannels.Value);
    out.sampleRate = mySampleRate.Value;

    if all(isspace(out.boardId)) || ...
       isempty(out.channels) || ...
       out.sampleRate < 1
      out = [];
    end
end

if isvalid(myGui)
    delete(myGui);
end

if isa(myAnalogOutputObj, 'analogoutput') && isvalid(myAnalogOutputObj)
    delete(myAnalogOutputObj);
end

%%
    function initializeFields(s)        
        daqmex;
        adaptorList = daq.engine.getadaptors();
        if isempty(adaptorList)
            adaptorList = {};
        end
        adaptorList{end+1} = 'Scan for others ...';       
        
        if isfield(s,'adaptor') && ischar(s.adaptor) && ~isempty(s.adaptor)
            if isempty(strmatch(s.adaptor, adaptorList, 'exact'))
                adaptorList = {s.adaptor, adaptorList{:}};
            end
            defaultAdaptor = s.adaptor;
        else
            defaultAdaptor = adaptorList{1};
        end
        
        myAdaptor.MenuItems = adaptorList;
        % Set the widget values. On each assignment, the callbacks
        % will try to populate subsequent widgets. In case of error, the 
        % subsequent widgets are set to null values (already-made
        % assignments are not unwound).        
        try
            myAdaptor.Value = defaultAdaptor; 
            if isfield(s, 'boardId')
                myBoardId.Value = s.boardId;
            end
            if isfield(s, 'channels')
                myChannels.Value = cellstr(num2str(s.channels(:)));
            end
            if isfield(s, 'sampleRate')
                mySampleRate.Value = s.sampleRate;
            end
            if isfield(s, 'bufferSize')
                myBufferSize.Value = s.bufferSize;
            end
        catch  %#ok<CTCH>
            % nothing to do in case of error 
        end
        myBufferSize.Enable = true;
    end

%%
    function adaptorCallback(h) %#ok<INUSD>
        if strcmp(myAdaptor.Value, 'Scan for others ...')
            tmpMsg = msgbox('Scanning for data acquisition hardware ...', 'Find adaptors');
            info = daqhwinfo();
            if ishandle(tmpMsg)
                delete(tmpMsg);
            end
           myAdaptor.MenuItems = info.InstalledAdaptors;
           myAdaptor.Value = info.InstalledAdaptors{1};
        end
        
        try
            info = daqhwinfo(myAdaptor.Value);
        catch  %#ok<CTCH>
            info.InstalledBoardIds = [];
        end
        
        if numel(info.InstalledBoardIds) == 0
            myBoardId.MenuItems = {' '};
            myBoardId.Value = ' ';
            myBoardId.Enable = false;
        else
            myBoardId.MenuItems = info.InstalledBoardIds;
            myBoardId.Value = info.InstalledBoardIds{1};
            myBoardId.Enable = true;
        end
    end

%%
    function boardIdCallback(h) %#ok<INUSD>
                
        if ~isempty(myAnalogOutputObj) && isvalid(myAnalogOutputObj)
            delete(myAnalogOutputObj);
            myAnalogOutputObj = [];
            myAnalogOutputInfo = [];
        end

        if all(isspace(myBoardId.Value))
            blankFields(); return;
        end
        
        try
            myAnalogOutputObj = analogoutput(myAdaptor.Value,myBoardId.Value);
        catch  %#ok<CTCH>
            myAnalogOutputObj = [];
        end
        
        if isempty(myAnalogOutputObj) || ~isvalid(myAnalogOutputObj)
            blankFields(); return;
        end
        
        myAnalogOutputInfo = daqhwinfo(myAnalogOutputObj);      
        if isempty(myAnalogOutputInfo.ChannelIDs)
            blankFields(); return;
        end
        
        myChannels.MenuItems = cellstr(int2str(myAnalogOutputInfo.ChannelIDs(:)));
        myChannels.Value = myChannels.MenuItems{1};
        myChannels.Visible = true;
        myChannels.Enable = true;
        
        myBoardName.Value = myAnalogOutputInfo.DeviceName;
            
        mySampleRate.Value = myAnalogOutputInfo.MinSampleRate;
        mySampleRate.Enable = true;
        
        function blankFields()
            myChannels.MenuItems = {' '};
            myChannels.Value = [];
            myChannels.Enable = false;
            
            mySampleRate.Value = 0;
            mySampleRate.Enable = false;
        end        
    end

%%
    function sampleRateCallback(h) %#ok<INUSD>        
        if isempty(myAnalogOutputInfo)
            return;
        end
        
        sr = mySampleRate.Value;
        
        if sr >= myAnalogOutputInfo.MinSampleRate && sr <= myAnalogOutputInfo.MaxSampleRate
            sr = setverify(myAnalogOutputObj, 'SampleRate', sr);
        else
            sr = min(max(sr, myAnalogOutputInfo.MinSampleRate), myAnalogOutputInfo.MaxSampleRate);
        end
        
        mySampleRate.Value = sr;
    end

end

