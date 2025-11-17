function ivicdriverfpfname =  privateGetIviCDriverName(driver)
%PRIVATEGETIVICDRIVERNAME Check if the driver is an IVI-C driver .
%
%   D = PRIVATEGETIVICDRIVERNAME returns the IVI-C driver function panels file
%   path if it find the file
%
%   If the IVI shared components have not been properly installed, D will
%   be an empty string.
%
%   This is a helper function used by functions in the Instrument
%   Control Toolbox. This function should not be called directly
%   by users.

%   YW 05/01/08
%   Copyright 2008 The MathWorks, Inc. 

ivicdriverfpfname = '';
if (~isempty(driver))
    
    prefix = instrgate('privateGetIviPath');
    
    if (isempty(prefix))
        return
    end;
    
    frontPanelFile = fullfile(prefix, 'Drivers', driver, [driver '.fp']);
    
    if (exist(frontPanelFile, 'file'))
        ivicdriverfpfname = frontPanelFile;
    end
end