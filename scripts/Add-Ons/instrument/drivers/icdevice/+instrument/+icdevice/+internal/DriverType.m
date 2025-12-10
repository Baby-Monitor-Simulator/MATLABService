classdef DriverType
    % DRIVERTYPE is the type of driver MDD that is supported by the new
    % Driver interface.

    %   Copyright 2022 The MathWorks, Inc.

    enumeration
        VXI_PNP
        IVI_C
        SCPIBasedMDD
        GenericMDD
    end
end
