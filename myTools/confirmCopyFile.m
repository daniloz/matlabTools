% CONFIRMCOPYFILE - copy a file and shows a popup dialog asking the user
%                   what to do if the destination file already exists
%
% Usage CONFIRMCOPYFILE(source, destination);
%
% Example
%   CONFIRMCOPYFILE('c:\temp\source.txt', 'c:\temp\destination.txt')

function success = confirmCopyFile(source, dest)

if exist(dest, 'file') == 2,
    choice = questdlg(sprintf('File already exists:\n%s\nDo you want to overwrite it?', dest), ...
        'Confirm overwrite', ...
        'Yes','No', 'No');
    % Handle response
    doCopy = false;
    switch choice
        case 'Yes'
            doCopy = true;
        case {'No', ''}
            doCopy = false;
    end
else
    doCopy = true;
end

if doCopy,
    [success, msg] = copyfile(source, dest);
    if ~success,
        error('Error copying feature files from |%s| to |%s|: %s', source, dest, msg);
    end
else
    success = -1;
end

end
