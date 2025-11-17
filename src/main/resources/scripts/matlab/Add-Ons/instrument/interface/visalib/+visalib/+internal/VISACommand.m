classdef VISACommand
% VISACOMMAND - enumeration class that defines all execute commands
% supported in VISA device plugin

% Copyright 2020-2021 The MathWorks, Inc.

    enumeration
        ListResources
        ResetTotalBytesWritten
        GetAttributeByType
        SetAttributeByType
        ReadStatusByte
        AssertTrigger
        ClearDevice
        SetTransferPeriod
        SetTransferSize
        StartTransfer
        StopTransfer
        ReadSync
    end
end