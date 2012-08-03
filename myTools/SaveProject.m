function SaveProject()

c = clock;
dateStr = sprintf('%04d_%02d_%02d',c(1),c(2),c(3));
defaultFile = ['c:\Users\dz.NTI-AUDIO\Documents\MATLAB\Projects\project_' dateStr '.m'];
[FileName,PathName] = uiputfile('*.m','Enter the MATLAB project file',defaultFile);
if FileName == 0,
    return;
end

desktop = com.mathworks.mde.desk.MLDesktop.getInstance;
openFiles = desktop.getWindowRegistry.getClosers.toArray.cell;
allEditorFilenames = cellfun(@(c)c.getTitle.char,openFiles,'un',0);

fid = fopen(fullfile(PathName,FileName),'w');
for n = 1:length(allEditorFilenames),
    currentFile = allEditorFilenames{n};
    if strcmpi(currentFile(end-1:end),'.m') == 1,
        fprintf(fid, 'open ''%s''\n', currentFile);
    end
end
fclose(fid);

end
