function Result = ini2struct(FileName)
%==========================================================================
%  Author: Andriy Nych ( nych.andriy@gmail.com )
% Version:        733341.4155741782200
%==========================================================================
%  Modified by: Danilo Zanatta - NTI AG
% Last Update: 
%==========================================================================
% 
% INI = ini2struct(FileName)
% 
% This function parses INI file FileName and returns it as a structure with
% section names and keys as fields.
% 
% Sections from INI file are returned as fields of INI structure.
% Each fiels (section of INI file) in turn is structure.
% It's fields are variables from the corresponding section of the INI file.
% 
% If INI file contains "oprhan" variables at the beginning, they will be
% added as fields to INI structure.
% 
% Lines starting with ';' and '#' are ignored (comments).
% 
% See example below for more information.
% 
% Usually, INI files allow to put spaces and numbers in section names
% without restrictions as long as section name is between '[' and ']'.
% It makes people crazy to convert them to valid Matlab variables.
% For this purpose Matlab provides GENVARNAME function, which does
%  "Construct a valid MATLAB variable name from a given candidate".
% See 'help genvarname' for more information.
% 
% The INI2STRUCT function uses the GENVARNAME to convert strange INI
% file string into valid Matlab field names.
% 
% [ test.ini ]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% 
%     SectionlessVar1=Oops
%     SectionlessVar2=I did it again ;o)
%     [Application]
%     Title = Cool program
%     LastDir = c:\Far\Far\Away
%     NumberOFSections = 2
%     [1st section]
%     param1 = val1
%     Param 2 = Val 2
%     [Section #2]
%     param1 = val1
%     Param 2 = Val 2
% 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% 
% The function converts this INI file it to the following structure:
% 
% [ MatLab session (R2006b) ]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%  >> INI = ini2struct('test.ini');
%  >> disp(INI)
%         sectionlessvar1: 'Oops'
%         sectionlessvar2: 'I did it again ;o)'
%             application: [1x1 struct]
%             x1stSection: [1x1 struct]
%            section0x232: [1x1 struct]
% 
%  >> disp(INI.application)
%                    title: 'Cool program'
%                  lastdir: 'c:\Far\Far\Away'
%         numberofsections: '2'
% 
%  >> disp(INI.x1stSection)
%         param1: 'val1'
%         param2: 'Val 2'
% 
%  >> disp(INI.section0x232)
%         param1: 'val1'
%         param2: 'Val 2'
% 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% 
% NOTE.
% WhatToDoWithMyVeryCoolSectionAndVariableNamesInIniFileMyVeryCoolProgramWrites?
% GENVARNAME also does the following:
%   "Any string that exceeds NAMELENGTHMAX is truncated". (doc genvarname)
% Period.
% 
% =========================================================================

Result = [];                            % we have to return something
CurrMainField = '';                     % it will be used later
f = fopen(FileName,'r');                % open file
while ~feof(f)                          % and read until it ends
    s = strtrim(fgetl(f));              % Remove any leading/trailing spaces
    if isempty(s)
        continue;
    end;
    if (s(1)==';')                      % ';' start comment lines
        continue;
    end;
    if (s(1)=='#')                      % '#' start comment lines
        continue;
    end;
    if ( s(1)=='[' ) && (s(end)==']' )
        % We found section
        CurrMainField = ['st' genvarname(s(2:end-1))];
        Result.(CurrMainField) = [];    % Create field in Result
    else
        % ??? This is not a section start
        [sPar,sVal] = strtok(s, '=');
        sVal = CleanValue(sVal);
        [sPrefix,Val] = fGetVal(sVal);
        if ~isempty(CurrMainField)
            % But we found section before and have to fill it
            Result.(CurrMainField).(genvarname([sPrefix sPar])) = Val;
        else
            % No sections found before. Orphan value
            Result.(genvarname([sPrefix sPar])) = Val;
        end
    end
end
fclose(f);
return

function [sPrefix,Val] = fGetVal(sVal)
    cPREFIXES = {'s', 'd', 'i', 'f', 'mt'};
    cCONV_FUNC = {'@(x) x', '@str2num', '@str2num', '@(x) x', '@str2num'};
    cPATERNS = {'^[^0-9@\+\-\.]\w*$', '^[\+\-]?[0-9]*[\.]+[0-9]+$', ...
        '^[\+\-]?[0-9]+$', '^@\w*$', '^\[.*\]$'};
    
    cRes = regexp(sVal, cPATERNS);
    bFound = ~cellfun('isempty',cRes);
    if sum(bFound) ~= 1,
        error('Error using fIni2struct, with sVal = |%s|, sum(bFound) = %i', ...
            sVal, sum(bFound))
    else
        % Everything is fine until now...
        assert(cRes{bFound}(1) == 1, ...
            'Strange error in fIni2struct, with sVal = |%s|', ...
            sVal);
        % Why ? Some strange error... Examples ??
        ind = find(bFound);
        sPrefix = cPREFIXES{ind};
        fConv = eval(cCONV_FUNC{ind}); 
        Val = fConv(sVal);
    end
return

function res = CleanValue(s)
res = strtrim(s);
if strcmpi(res(1),'=')
    res(1)=[];
end
res = strtrim(res);
return;
