classdef VISAProperties
% VISAPROPERTIES - class that defines property values used by the
% VisaClient / Device plugin; these values are obtained from attributes
% listed in visa.h (with prefix "VI" removed; e.g.
% "STOP_ONE" becomes "STOP_ONE".

% Copyright 2020-2021 The MathWorks, Inc.
    
    properties (Constant)
        % Serial PARITY
        ASRL_PAR_NONE    = 0
        ASRL_PAR_ODD     = 1
        ASRL_PAR_EVEN    = 2
        ASRL_PAR_MARK    = 3
        ASRL_PAR_SPACE   = 4
        
        % Serial STOP bits
        ASRL_STOP_ONE    = 10
        ASRL_STOP_ONE5   = 15
        ASRL_STOP_TWO    = 20
        
        % Serial FLOW control
        ASRL_FLOW_NONE       = 0
        ASRL_FLOW_XON_XOFF   = 1
        ASRL_FLOW_RTS_CTS    = 2
        ASRL_FLOW_DTR_DSR    = 4

        % Serial END read operations
        ASRL_END_NONE        = 0
        ASRL_END_LAST_BIT    = 1
        ASRL_END_TERMCHAR    = 2
        ASRL_END_BREAK       = 3
        
        % Timeout
        TMO_IMMEDIATE        = 0
        TMO_INFINITE         = 0xFFFFFFFF
        
        % IO Protocol
        PROT_NORMAL          = 1
        PROT_FDC             = 2
        PROT_HS488           = 3
        PROT_4882_STRS       = 4
        PROT_USBTMC_VENDOR   = 5        
    end
    
    methods (Static)
        %%% Lookup MATLAB value from attribute value
        function stopBits = getStopBitsFromAttributeValue(attributeValue)
            switch attributeValue
                case visalib.internal.VISAProperties.ASRL_STOP_ONE
                    stopBits = 1;
                case visalib.internal.VISAProperties.ASRL_STOP_ONE5
                    stopBits = 1.5;
                case visalib.internal.VISAProperties.ASRL_STOP_TWO
                    stopBits = 2;
                otherwise
                    stopBits = 1;
            end
        end
        
        function parity = getParityFromAttributeValue(attributeValue)
            switch attributeValue
                case visalib.internal.VISAProperties.ASRL_PAR_NONE
                    parity = visalib.Parity.none;
                case visalib.internal.VISAProperties.ASRL_PAR_ODD
                    parity = visalib.Parity.odd;
                case visalib.internal.VISAProperties.ASRL_PAR_EVEN
                    parity = visalib.Parity.even;
                otherwise
                    parity = visalib.Parity.none;
            end
        end
        
        function flowControl = getFlowControlFromAttributeValue(attributeValue)
            switch attributeValue
                case visalib.internal.VISAProperties.ASRL_FLOW_NONE
                    flowControl = visalib.FlowControl.none;
                case visalib.internal.VISAProperties.ASRL_FLOW_XON_XOFF
                    flowControl = visalib.FlowControl.software;
                case visalib.internal.VISAProperties.ASRL_FLOW_RTS_CTS
                    flowControl = visalib.FlowControl.hardware;
                case visalib.internal.VISAProperties.ASRL_FLOW_DTR_DSR
                    flowControl = visalib.FlowControl.hardware;
                otherwise 
                    % software + hardware (unsupported); throw an error so
                    % that caller can use this information to set an
                    % appropriate default
                    e = visalib.internal.ErrorProxy.getVisaException("unsupportedFlowControlType");
                    throwAsCaller(e);
            end
        end
        
        %%% Lookup attribute value from MATLAB value
        function attributeValue = getAttributeValueFromStopBits(stopBits)
            switch stopBits
                case 1
                    attributeValue = visalib.internal.VISAProperties.ASRL_STOP_ONE;
                case 1.5
                    attributeValue = visalib.internal.VISAProperties.ASRL_STOP_ONE5;
                case 2
                    attributeValue = visalib.internal.VISAProperties.ASRL_STOP_TWO;                    
                otherwise
                    attributeValue = visalib.internal.VISAProperties.ASRL_STOP_ONE;
            end            
        end
        
        function attributeValue = getAttributeValueFromParity(parity)
            switch parity
                case visalib.Parity.none
                    attributeValue = visalib.internal.VISAProperties.ASRL_PAR_NONE;
                case visalib.Parity.odd
                    attributeValue = visalib.internal.VISAProperties.ASRL_PAR_ODD;
                case visalib.Parity.even
                    attributeValue = visalib.internal.VISAProperties.ASRL_PAR_EVEN;
                otherwise
                    attributeValue = visalib.internal.VISAProperties.ASRL_PAR_NONE;
            end            
        end    
        
        function attributeValue = getAttributeValueFromFlowControl(flowControl)
            switch flowControl
                case visalib.FlowControl.none
                    attributeValue = visalib.internal.VISAProperties.ASRL_FLOW_NONE;
                case visalib.FlowControl.software
                    attributeValue = visalib.internal.VISAProperties.ASRL_FLOW_XON_XOFF;
                case visalib.FlowControl.hardware
                    attributeValue = visalib.internal.VISAProperties.ASRL_FLOW_RTS_CTS;
                otherwise 
                    attributeValue = visalib.internal.VISAProperties.ASRL_FLOW_NONE;
            end
        end         
    end
end

