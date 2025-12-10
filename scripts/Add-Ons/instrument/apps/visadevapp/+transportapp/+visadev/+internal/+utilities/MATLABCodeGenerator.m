classdef MATLABCodeGenerator < matlabshared.transportapp.internal.utilities.MATLABCodeGenerator
    %MATLABCODEGENERATOR generates the MATLAB code associated with user
    %interactions with the app. Overrides Shared Transport App
    %MATLABCodeGenerator class to support 'off' as a valid Read Terminator

    % Copyright 2022 The MathWorks, Inc.
    
    properties(Constant)
        ReadStringTerminators = [matlabshared.transportapp.internal.utilities.MATLABCodeGenerator.StringTerminators, "off"]
    end
    
    methods(Access = {?matlabshared.transportapp.internal.utilities.MATLABCodeGenerator, ?matlabshared.transportapp.internal.utilities.ITestable})
        function readTerminators = getReadStringTerminatorsHook(obj)
            readTerminators = obj.ReadStringTerminators;
        end
    end
end

