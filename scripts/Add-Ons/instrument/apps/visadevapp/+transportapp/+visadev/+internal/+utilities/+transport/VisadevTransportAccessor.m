classdef VisadevTransportAccessor < matlabshared.transportapp.internal.utilities.transport.TransportAccessor
    %VISADEVTRANSPORTACCESSOR performs getter and setter operations on the
    %transport object. Overrides Shared Transport App TransportAccessor
    %class to support 'off' as a Read Terminator.

    % Copyright 2022 The MathWorks, Inc.
    
    methods (Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        function validTerminators = getValidTerminators(~)
            validTerminators = transportapp.visadev.internal.utilities.transport.VisadevTerminator.ReadTerminatorDropDownOptions;
        end

        function terminatorObj = getTerminatorClassHook(~, readTerminator, writeTerminator)
            terminatorObj = transportapp.visadev.internal.utilities.transport.VisadevTerminator ...
                    (readTerminator, writeTerminator);
        end
    end
end

