classdef VISAAttribute < uint32
% ATTRIBUTE - enumeration class that defines attributes used by the
% VisaClient / Device plugin; these values are obtained from attributes
% listed in visa.h (with prefix "VI_ATTR" removed; e.g.
% "VI_ATTR_TMO_VALUE" becomes "TMO_VALUE").

% Copyright 2020-2022 The MathWorks, Inc.

    enumeration                
        %%% Terminator, ASRL End
        TERMCHAR_EN                   (0x3FFF0038)
        TERMCHAR                      (0x3FFF0018)
        
        ASRL_END_IN                   (0x3FFF00B3)
        ASRL_END_OUT                  (0x3FFF00B4)
        
        %%% Timeout
        TMO_VALUE                     (0x3FFF001A)
        
        %%% EOI
        SUPPRESS_END_EN               (0x3FFF0036)
        SEND_END_EN                   (0x3FFF0016)
        
        %%% Interface
        INTF_TYPE                     (0x3FFF0171)
        INTF_NUM                      (0x3FFF0176)
        
        %%% GPIB (BoardIndex, PrimaryAddress, SecondaryAddress)
        % INTF_NUM                      
        GPIB_PRIMARY_ADDR             (0x3FFF0172)
        GPIB_SECONDARY_ADDR           (0x3FFF0173)
        
        %%% VXI (ChassisIndex, LogicalAddress, Slot)
        % INTF_NUM
        VXI_LA                        (0x3FFF00D5)        
        SLOT                          (0x3FFF00E8)
        
        %%% Serial
        ASRL_BAUD                     (0x3FFF0021)
        ASRL_DATA_BITS                (0x3FFF0022)
        ASRL_STOP_BITS                (0x3FFF0024)
        ASRL_PARITY                   (0x3FFF0023)
        ASRL_FLOW_CNTRL               (0x3FFF0025)
        
        ASRL_CTS_STATE                (0x3FFF00AE)
        ASRL_DCD_STATE                (0x3FFF00AF)
        ASRL_DSR_STATE                (0x3FFF00B1)
        ASRL_DTR_STATE                (0x3FFF00B2)
        
        ASRL_RI_STATE                 (0x3FFF00BF)
        ASRL_RTS_STATE                (0x3FFF00C0)

        ASRL_AVAIL_NUM                (0x3FFF00AC)
        
        %%% PXI (Bus, DeviceIndex, FunctionIndex, ChassisIndex)
        PXI_BUS_NUM                   (0x3FFF0205)
        PXI_DEV_NUM                   (0x3FFF0201)
        PXI_FUNC_NUM                  (0x3FFF0202)
        PXI_CHASSIS                   (0x3FFF0206)
        
        %%% USB (VendorID, ProductID, BoardIndex, InterfaceIndex)
        MANF_ID                       (0x3FFF00D9)
        MODEL_CODE                    (0x3FFF00DF)       
        % INTF_NUM
        USB_INTFC_NUM                 (0x3FFF01A1)
        
        %%% TCPIP (BoardIndex, LANName, InstrumentAddress)
        % INTF_NUM
        TCPIP_DEVICE_NAME             (0xBFFF0199)
        TCPIP_ADDR                    (0xBFFF0195)
        
        %%% SOCKET (IPAddress, Port)
        % TCPIP_ADDR
        TCPIP_PORT                    (0x3FFF0197)

        %%% HiSLIP (IsHiSLIP
        TCPIP_IS_HISLIP               (0x3FFF0303)

        %%% Other
        RSRC_LOCK_STATE               (0x3FFF0004)
    end
    
    methods
        function type = getAttributeType(attribute)
            % Determine type of attribute
            type = ""; %#ok<NASGU> 
            switch attribute
                case visalib.internal.VISAAttribute.TERMCHAR                    
                    type = "uint8";
                case {visalib.internal.VISAAttribute.INTF_TYPE, ...
                      visalib.internal.VISAAttribute.INTF_NUM, ...
                      visalib.internal.VISAAttribute.MANF_ID}
                    type = "uint16";
                  %%% PXI / VXI
                case {visalib.internal.VISAAttribute.PXI_BUS_NUM, ...
                      visalib.internal.VISAAttribute.PXI_DEV_NUM, ...
                      visalib.internal.VISAAttribute.PXI_FUNC_NUM, ...
                      visalib.internal.VISAAttribute.PXI_CHASSIS,...
                      visalib.internal.VISAAttribute.SLOT, ...
                      visalib.internal.VISAAttribute.VXI_LA}                     
                    type = "uint16";
                  %%% ASRL
                case {visalib.internal.VISAAttribute.ASRL_DATA_BITS, ...
                      visalib.internal.VISAAttribute.ASRL_STOP_BITS, ...
                      visalib.internal.VISAAttribute.ASRL_PARITY, ...
                      visalib.internal.VISAAttribute.ASRL_FLOW_CNTRL, ...
                      ...
                      visalib.internal.VISAAttribute.ASRL_END_IN, ...
                      visalib.internal.VISAAttribute.ASRL_END_OUT, ...
                      ...
                      visalib.internal.VISAAttribute.ASRL_CTS_STATE, ...
                      visalib.internal.VISAAttribute.ASRL_DCD_STATE, ...
                      visalib.internal.VISAAttribute.ASRL_DSR_STATE, ...
                      visalib.internal.VISAAttribute.ASRL_DTR_STATE, ...
                      ...
                      visalib.internal.VISAAttribute.ASRL_RI_STATE, ...
                      visalib.internal.VISAAttribute.ASRL_RTS_STATE}
                    type = "uint16";
                  %%% GPIB / USB / TCPIP
                case {visalib.internal.VISAAttribute.GPIB_PRIMARY_ADDR, ...
                      visalib.internal.VISAAttribute.GPIB_SECONDARY_ADDR, ...
                      visalib.internal.VISAAttribute.USB_INTFC_NUM, ...
                      visalib.internal.VISAAttribute.MODEL_CODE, ...
                      visalib.internal.VISAAttribute.TCPIP_PORT}
                    type = "uint16";
                case {visalib.internal.VISAAttribute.SUPPRESS_END_EN, ...
                      visalib.internal.VISAAttribute.SEND_END_EN, ...
                      visalib.internal.VISAAttribute.TERMCHAR_EN}
                    type = "uint16";
                case {visalib.internal.VISAAttribute.ASRL_AVAIL_NUM, ...
                      visalib.internal.VISAAttribute.ASRL_BAUD, ...
                      visalib.internal.VISAAttribute.TMO_VALUE, ...
                      visalib.internal.VISAAttribute.RSRC_LOCK_STATE}
                    type = "uint32";
                case {visalib.internal.VISAAttribute.TCPIP_DEVICE_NAME, ...
                      visalib.internal.VISAAttribute.TCPIP_ADDR}
                    type = "string";
                otherwise
                    type = "uint32";
            end
        end
    end
end