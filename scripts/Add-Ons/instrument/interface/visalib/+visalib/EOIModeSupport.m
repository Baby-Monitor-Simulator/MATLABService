classdef EOIModeSupport < handle
    %EOIMODESUPPORT Mixin class to allow visalib.Resource classes to add
    %support for EOIMode.
    
    % Copyright 2020-2022 The MathWorks, Inc.
    
    properties
        % Specifies whether the EOI line is asserted ("on") or not ("off")
        % at the end of a write.
        EOIMode (1, 1) matlab.lang.OnOffSwitchState = "on"  
    end
    
    methods
        function obj = EOIModeSupport
        end
    end

    %%% Setting EOIMode
    methods
        function set.EOIMode(obj, value)
            if visalib.internal.TestModeManager.getTestMode == ...
               visalib.internal.VISAMode.Normal

               value = logical(value);

               if value
                   % EOI is enabled
                   if obj.CheckSuppressEndIndicator %#ok<MCSUP> 
                       suppressEndIndicator = obj.setSuppressEndIndicatorTerminator(false);
                   end

                   sendEndIndicator = obj.setAssertEndDuringLastByteTransfer(true);
                   
                   if obj.CheckSuppressEndIndicator %#ok<MCSUP> 
                       eoiMode = ~suppressEndIndicator & sendEndIndicator;
                   else
                       eoiMode = sendEndIndicator;
                   end

                   obj.EOIMode = matlab.lang.OnOffSwitchState(eoiMode);
               else
                   % EOI is disabled: do not set the suppress end indicator
                   % enable 
                   sendEndIndicator = obj.setAssertEndDuringLastByteTransfer(false);                   
                   obj.EOIMode = matlab.lang.OnOffSwitchState(sendEndIndicator);
               end
            else
               obj.EOIMode = matlab.lang.OnOffSwitchState(value);
            end
        end
    end

    properties (Access = protected)
        CheckSuppressEndIndicator (1, 1) logical = true
    end
         
    methods (Abstract, Access = protected)
        valueOut = setAndReturnAttribute(obj, attribute, valueIn)
    end    
    
    methods (Access = private)        
        function out = setSuppressEndIndicatorTerminator(obj, suppressEndIndicator)
            % Suppress END indicator termination (SUPPRESS_END_EN):
            % - true: END indicator does not terminate read operations.
            % - false: END indicator terminates read operations.
            % refer to VPP-4.3 (The VISA Library) for more info
            attrSuppressEndIndicator = visalib.internal.VISAAttribute.SUPPRESS_END_EN;     
            out = setAndReturnAttribute(obj, attrSuppressEndIndicator, suppressEndIndicator);
        end
        
        function out = setAssertEndDuringLastByteTransfer(obj, sendEndIndicator)
            % Assert END during transfer of last byte (SEND_END_EN):
            % - true: assert END indicator.
            % - false: do not assert END indicator.
            % refer to VPP-4.3 (The VISA Library) for more info
            attrSendEndIndicator = visalib.internal.VISAAttribute.SEND_END_EN;
            out = setAndReturnAttribute(obj, attrSendEndIndicator, sendEndIndicator);
        end         
    end
end

