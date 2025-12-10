function [ieee4882DriverName , firmWareVersion] =  getIEEE4882DriverName(instrumentinfo, instrumenttype)
% GETIEEE4882DRIVERNAME Return ieee 488.2 driver name based on the
% instrument type and info returned from *idn? query.
%
% This is a helper function used by functions in the instrument
% control toolbox. this function should not be called directly
% by users.
%
% Copyright 2011-2017 The MathWorks, Inc.

firmWareVersion = 1;
ieee4882DriverName = '';

% Instrument type has to be the same
if ~strcmpi ( instrumenttype , getInstrumentType(instrumentinfo))
    return;
end

if strcmpi (instrumenttype , 'scope')
    % Parse the instrumentinfo and figure out instrument model
    % and use model number to find out the dir ver name
    if strfind ( instrumentinfo, 'TEKTRONIX')
        series  = instrumentinfo(length ('TEKTRONIX') + 5 : length ('TEKTRONIX') + 5 );
        series  = strtrim (series);
        if isempty (series ) % if it is empty at model series position
            ieee4882DriverName = 'tektronix';
        else
            ieee4882DriverName = 'tektronix';
            firmWareVersion = 2;
        end
    end
elseif strcmpi(instrumenttype,'fgen')
    if strfind ( instrumentinfo, 'Agilent')
        % *IDN? has 'Agilent' in it, meaning it is an Agilent instrument
        splitStrings = regexp(instrumentinfo, '\,', 'split'); % Find the model number, which is the second comma delimited substring in the *IDN? response
        series = splitStrings{2};
        if isequal(series,'33210A') || isequal(series,'33220A') || isequal(series,'33250A')
            ieee4882DriverName = 'Agilent332x0_SCPI';
            firmWareVersion = 1;  % Use elseif block here when adding additional Agilent AFG/AWG class instruments
        end
    end
elseif strcmpi(instrumenttype,'rfsiggen')
    if contains( instrumentinfo, 'Agilent')
        % *IDN? has 'Agilent' in it, meaning it is an Agilent instrument
        splitStrings = regexp(instrumentinfo, '\,', 'split'); % Find the model number, which is the second comma delimited substring in the *IDN? response
        series = splitStrings{2};
        if contains( series, {'E4428C', 'E4438C', 'N5181A', 'N5182A', 'N5183A', 'N5171B', 'N5181B', 'N5172B', 'N5182B', 'N5173B', 'N5183B', 'E8241A', 'E8244A', 'E8251A'})
            ieee4882DriverName = 'AgRfSigGen_SCPI';
            firmWareVersion = 1;  % Use elseif block here when adding additional Agilent N/E class instruments
        end 
    end
    if contains( instrumentinfo, 'Keysight')
        % *IDN? has 'Keysight' in it, meaning it is an Keysight instrument
        splitStrings = regexp(instrumentinfo, '\,', 'split'); % Find the model number, which is the second comma delimited substring in the *IDN? response
        series = splitStrings{2};
        if contains( series, {'E4428C', 'E4438C'})
            ieee4882DriverName = 'AgRfSigGen_SCPI';
            firmWareVersion = 1;  % Use elseif block here when adding additional Keysight N/E class instruments
        end 
    end
    if contains( instrumentinfo, 'Rohde&Schwarz')
        % *IDN? has 'Rohde&Schwarz' in it, meaning it is an Rohde & Schwarz instrument
        splitStrings = regexp(instrumentinfo, '\,', 'split'); % Find the model number, which is the second comma delimited substring in the *IDN? response
        series = splitStrings{2};
        if contains( series, {'SMW200A', 'SMBV100A', 'SMU200A', 'SMJ100A', 'AMU200A', 'SMATE200A'})
            ieee4882DriverName = 'RsRfSigGen_SCPI';
            firmWareVersion = 1;  % Use elseif block here when adding additional Rohde & Schwarz N/E class instruments
        end 
    end
end

function type = getInstrumentType ( instrumentInfo )
% GETINSTRUMENTTYPE Identify the ieee4882 driver type
if contains(instrumentInfo, 'AFG')
    type= 'fgen';
elseif contains( instrumentInfo, {'Agilent Technologies,33220A','Agilent Technologies,33210A', 'Agilent Technologies,33250A'})
    type = 'fgen';
elseif contains( instrumentInfo, {'E4428C', 'E4438C', 'N5181A', 'N5182A', 'N5183A', 'N5171B', 'N5181B', 'N5172B', 'N5182B', 'N5173B', 'N5183B', 'E8241A', 'E8244A', 'E8251A', 'SMW200A', 'SMBV100A', 'SMU200A', 'SMJ100A', 'AMU200A', 'SMATE200A'})
    type = 'rfsiggen';
else
    type= 'scope';
end
