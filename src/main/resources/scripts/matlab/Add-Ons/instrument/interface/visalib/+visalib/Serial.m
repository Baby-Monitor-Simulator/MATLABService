classdef Serial < visalib.Resource
    %Serial Class representing a VISA Serial resource
    
    % Copyright 2020-2022 The MathWorks, Inc.
    
    properties
        % Speed of the serial communication (in bits per second)
        BaudRate (1, 1) double {mustBePositive, mustBeInteger} = 9600
        
        % Number of bits used to represent one character of data
        DataBits (1, 1) double {mustBeMember(DataBits, [5, 6, 7, 8])} = 8
        
        % Pattern of bits that indicates the end of a character or of the
        % whole transmission
        StopBits (1, 1) double {mustBeMember(StopBits, [1, 1.5, 2])} = 1
        
        % Parity to check whether or not data has been lost
        Parity  (1, 1) visalib.Parity = "none"
        
        % Mode for managing the rate of data transmission
        FlowControl (1, 1) visalib.FlowControl = "none"
    end

    properties (SetAccess = private)
        % VISA port used for connection 
        Port (1, 1) string = "ASRL1"
    end
    
    methods (Hidden)
        function obj = Serial(resourceInfo, synchronousRead)
            visalib.Resource.checkResourceType(resourceInfo.Type, visalib.InterfaceType.serial);
            obj@visalib.Resource(resourceInfo, synchronousRead);
        end
    end
    
    %% Getters and Setters
    methods
        %%% Getters
        
        %%% Setters
        function set.BaudRate(obj, value)
            attribute = visalib.internal.VISAAttribute.ASRL_BAUD;
            unsupportedBaudRate = false;
            
            try
                obj.setAttributeByType(attribute, value); 
            catch e
                switch e.identifier
                    case "instrument:interface:visa:resourceDoesNotSupportThisSetting"
                        unsupportedBaudRate = true;
                    otherwise
                        throwAsCaller(e)
                end                        
            end
            
            obj.BaudRate = obj.getAttributeByType(attribute);
            
            if unsupportedBaudRate && value ~= obj.BaudRate
                visalib.internal.ErrorProxy.sendWarning(...
                    "instrument:interface:visa:unableToSetPropertyValue",...
                    "BaudRate",...
                    obj.BaudRate,...
                    value);                    
            end            
        end
        
        function set.DataBits(obj, value)
            attribute = visalib.internal.VISAAttribute.ASRL_DATA_BITS;
            obj.setAttributeByType(attribute, value); 
            
            obj.DataBits = obj.getAttributeByType(attribute);
        end
        
        function set.StopBits(obj, value)
            attribute = visalib.internal.VISAAttribute.ASRL_STOP_BITS;
            attrValue = visalib.internal.VISAProperties.getAttributeValueFromStopBits(value);
            obj.setAttributeByType(attribute, attrValue); 
            
            stopBits = obj.getAttributeByType(attribute);
            obj.StopBits = visalib.internal.VISAProperties.getStopBitsFromAttributeValue(stopBits);              
        end  
        
        function set.Parity(obj, value)
            attribute = visalib.internal.VISAAttribute.ASRL_PARITY;
            attrValue = visalib.internal.VISAProperties.getAttributeValueFromParity(value);
            obj.setAttributeByType(attribute, attrValue);
         
            parity = obj.getAttributeByType(attribute);
            obj.Parity = visalib.internal.VISAProperties.getParityFromAttributeValue(parity);            
        end         
        
        function set.FlowControl(obj, value)
            attribute = visalib.internal.VISAAttribute.ASRL_FLOW_CNTRL;
            attrValue = visalib.internal.VISAProperties.getAttributeValueFromFlowControl(value);
            obj.setAttributeByType(attribute, attrValue); 
         
            flowControl = obj.getAttributeByType(attribute);
            obj.FlowControl = visalib.internal.VISAProperties.getFlowControlFromAttributeValue(flowControl);
        end        
    end
    
    %% VISA methods
    methods
        function setDTR(obj, value)
            %SETDTR Set/reset the serial DTR (Data Terminal Ready) pin.
            %
            % SETDTR(OBJ,FLAG) Sets or resets the serial DTR pin, based
            % on the value of FLAG.
            %
            % Input Arguments:
            %   FLAG is logical true or false. FLAG set to true sets the 
            %   DTR pin and false resets it.
            %
            % Example:
            %      % Set the DTR pin.
            %      setDTR(v, true);
            %
            %      % Reset the RTS pin.
            %      setDTR(v, false);            
            
            arguments
                obj visalib.Serial
                value (1, 1) logical
            end
            
            attrDTR = visalib.internal.VISAAttribute.ASRL_DTR_STATE;
            obj.setAttributeByType(attrDTR, value);            
        end
        
        function setRTS(obj, value)
            %SETRTS Set/reset the serial RTS (Ready to Send) pin.
            %
            % SETRTS(OBJ,FLAG) sets or resets the serial RTS pin, based
            % on the value of FLAG.
            %
            % Input Arguments:
            %   FLAG is logical true or false. FLAG set to true sets the 
            %   RTS pin, false resets it.
            %
            % Example:
            %      % Set the RTS pin.
            %      setRTS(v,true);
            %
            %      % Reset the RTS pin.
            %      setRTS(v,false);
            
            arguments
                obj visalib.Serial
                value (1, 1) logical
            end            
            
            attrRTS = visalib.internal.VISAAttribute.ASRL_RTS_STATE;
            obj.setAttributeByType(attrRTS, value);                        
        end
        
        function status = getpinstatus(obj)
            %GETPINSTATUS Get the serial pin status.
            %
            % STATUS = GETPINSTATUS(OBJ) gets the serial pin status and
            % returns it as a struct to STATUS.
            %
            % Output Arguments:
            %   STATUS is a 1x1 struct with the fields ClearToSend,
            %   DataSetReady, CarrierDetect, and RingIndicator.
            %
            % Example:
            %      % Get the pin status.
            %      status = getpinstatus(s);
            
            % Define VISA attributes
            attrClearToSend = visalib.internal.VISAAttribute.ASRL_CTS_STATE;
            attrDataSendReady = visalib.internal.VISAAttribute.ASRL_DSR_STATE;
            attrCarrierDetect = visalib.internal.VISAAttribute.ASRL_DCD_STATE;
            attrRingIndicator = visalib.internal.VISAAttribute.ASRL_RI_STATE;
            
            % Fetch VISA attribute values
            clearToSend = obj.getAttributeByType(attrClearToSend);
            dataSendReady = obj.getAttributeByType(attrDataSendReady);
            carrierDetect = obj.getAttributeByType(attrCarrierDetect);
            ringIndicator = obj.getAttributeByType(attrRingIndicator);
            
            status.ClearToSend = matlab.lang.OnOffSwitchState(clearToSend);
            status.DataSendReady = matlab.lang.OnOffSwitchState(dataSendReady);
            status.CarrierDetect = matlab.lang.OnOffSwitchState(carrierDetect);
            status.RingIndicator = matlab.lang.OnOffSwitchState(ringIndicator);
        end
    end    
    
    %% Overridden methods
    methods (Access = protected)
        function initResourceHook(obj)
            % Initialize properties prior to asking the client to connect.
            attrBaudRate = visalib.internal.VISAAttribute.ASRL_BAUD;
            attrDataBits = visalib.internal.VISAAttribute.ASRL_DATA_BITS;
            attrStopBits = visalib.internal.VISAAttribute.ASRL_STOP_BITS;
            attrParity = visalib.internal.VISAAttribute.ASRL_PARITY;
            attrFlowControl = visalib.internal.VISAAttribute.ASRL_FLOW_CNTRL;
            
            obj.BaudRate = obj.getAttributeByType(attrBaudRate);
            obj.DataBits = obj.getAttributeByType(attrDataBits);
            
            stopBits = obj.getAttributeByType(attrStopBits);
            obj.StopBits = visalib.internal.VISAProperties.getStopBitsFromAttributeValue(stopBits);
            
            parity = obj.getAttributeByType(attrParity);
            obj.Parity = visalib.internal.VISAProperties.getParityFromAttributeValue(parity);
            
            flowControl = obj.getAttributeByType(attrFlowControl);
            % If flow control isn't supported (hardware + software), then
            % set the flow control to "none" and issue a warning
            try
                obj.FlowControl = visalib.internal.VISAProperties.getFlowControlFromAttributeValue(flowControl);
            catch e
               switch e.identifier 
                   case 'instrument:interface:visa:unsupportedFlowControlType'
                       value = visalib.internal.VISAProperties.ASRL_FLOW_NONE;
                       obj.setAttributeByType(attrFlowControl, value);
                       flowControl = obj.getAttributeByType(attrFlowControl);
                       obj.FlowControl = visalib.internal.VISAProperties.getFlowControlFromAttributeValue(flowControl);
                       
                       % Re-issue the error as a warning
                       visalib.internal.ErrorProxy.sendWarning(e.identifier);
                   otherwise
                       throwAsCaller(e);
               end
            end
            
            port = split(obj.ResourceName, "::");
            obj.Port = port(1);            
        end                  

        function postConnectHook(obj)
            obj.setTermCharEnabled(true);
        end        
        
        function preDisconnectHook(obj)
            value = visalib.internal.VISAProperties.ASRL_FLOW_NONE;
            attrFlowControl = visalib.internal.VISAAttribute.ASRL_FLOW_CNTRL;
            obj.setAttributeByType(attrFlowControl, value);
        end

        function adjustGroupListHook(obj) 
            obj.AdditionalIDProperties = strings(0);
            obj.InterfaceSpecificProperties = ["Port", "BaudRate"];            
            obj.SupplementalIDProperties = ["Type", "PreferredVisa"];
            obj.SharedProperties = ...
                ["ByteOrder", "DataBits", "StopBits", "Parity", ...
                 "FlowControl", "Timeout", "Terminator"];
        end

        function disableVisaTerminatorHook(obj)
            % Allow specific instrument classes to perform additional
            % actions required to disable terminators
            obj.setASRLEndIn(false);
        end

        function enableVisaTerminatorHook(obj)
            % Allow specific instrument classes to perform additional
            % actions required to enable terminators
            obj.setASRLEndIn(true);
        end            
    end


    methods (Access = private)
        function setASRLEndIn(obj, enabled)
            % The VI_ATTR_ASRL_END_IN attribute indicates the method used to
            % terminate a read operation. When enabled is:
            % - true: look for terminating character
            % - false: ignore terminating character (read all available)

            arguments
                obj
                enabled (1, 1) logical
            end

            attrASRLEndIn = visalib.internal.VISAAttribute.ASRL_END_IN;

            if enabled
                % VI_ASRL_END_TERMCHAR: read terminates on receipt of the
                % terminating character, as specified using
                % VI_ATTR_TERMCHAR).
                value = visalib.internal.VISAProperties.ASRL_END_TERMCHAR;
            else
                % VI_ASRL_END_NONE: read won't terminate until either all
                % of the requested data is received or an error occurs.
                value = visalib.internal.VISAProperties.ASRL_END_NONE;
            end

            obj.setAttributeByType(attrASRLEndIn, value);
        end
    end
end


