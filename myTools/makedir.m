% MAKEDIR - make a new directory if it nos exists, otherwise just exit quietly and gracefully
%
% Usage MAKEDIR(full_path_to_dir);
%
% Example
%   MAKEDIR('c:\temp')

function makedir(path)
    if exist(path, 'dir') ~= 7,
        mkdir(path);
    end
end
