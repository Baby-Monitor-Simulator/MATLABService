function [header terminator] = privateslextractheaderandterminator(headStr, termStr)
%PRIVATESLEXTRACTHEADERANDTERMINATOR Extracts header and terminator for serial blocks.
%
%    [HEADER TERMINATOR] = PRIVATESLEXTRACTHEADERANDTERMINATOR(HEADSTR,TERMSTR)
%    Extracts the header and the terminator from the header string, HEADSTR
%    and terminator string, TERMSTR and returns them as array of uint8 in
%    HEADER and TERMINATOR.

%    SS 10-03-07
%    Copyright 2007 The MathWorks, Inc.

% Get header.
if isempty(headStr)
    % Header is empty.
    header = [];
else
    % Add quotes
    headStr = ['''' strrep(headStr, '''', '''''') ''''];
                
    % Get the uint8 value.
    header = uint8(sprintf(eval(headStr)));
end
% Get terminator.
switch termStr
    case {'CR (''\r'')' 'LF (''\n'')' 'CR/LF (''\r\n'')' 'NULL (''\0'')'} % Default combo values.
        index = findstr(termStr, '(');
        terminator = uint8(sprintf(eval(termStr(index+1:end-1))));
    otherwise % Custom value.
        if isempty(termStr) || strcmpi(termStr, '<none>')
            terminator = []; % Terminator empty.
        else
            % Add quotes
            termStr = ['''' strrep(termStr, '''', '''''') ''''];
            % Get the corresponding uint8 value.
            terminator = uint8(sprintf(eval(termStr)));
        end
end