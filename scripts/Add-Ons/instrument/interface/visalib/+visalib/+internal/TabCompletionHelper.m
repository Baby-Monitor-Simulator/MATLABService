classdef (Hidden) TabCompletionHelper
%TABCOMPLETIONHELPER - Utility for returning tab completion options for
%methods in visalib

% Copyright 2020 The MathWorks, Inc.

    % VISA options
    methods(Static)
        function options = resourceIDOptions
            % Used by visadev
            if isempty(visalib.internal.ResourceManager.getInstance().getCachedResourceList)
                visalib.internal.ResourceManager.getResourceList(10);
            end
            
            options = visalib.internal.ResourceManager.getResourceIDs();
        end
        
        function options = queryOptions
            % Used by visalib.Resource.writeread
            options = ["*IDN?", "*TST?", "*OPC?", "*ESE?", "*ESR?", "*SRE?", "*STB?"];
        end        
    end
end