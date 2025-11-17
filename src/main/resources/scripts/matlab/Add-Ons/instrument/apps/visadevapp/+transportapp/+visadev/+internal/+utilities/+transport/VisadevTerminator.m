classdef VisadevTerminator < matlabshared.transportapp.internal.utilities.transport.TerminatorClass
    %VISADEVTERMINATOR provides the getters and setters for the Read and
    %Write Terminators. Overrides Shared Transport App TerminatorClass to
    %add support for 'off' as a Read Terminator value.

    % Copyright 2022 The MathWorks, Inc.
    
    properties(Constant, Hidden)
        ReadTerminatorDropDownOptions = [ ...
            matlabshared.transportapp.internal.utilities.transport.TerminatorClass.TerminatorDropDownValues ...
            "off"]
    end
    
    methods(Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        function values = getReadTerminatorDropDownValuesHook(obj)
            % Override base class method to use specialized read terminator
            % options.
            values = obj.ReadTerminatorDropDownOptions;
        end
    end
end

