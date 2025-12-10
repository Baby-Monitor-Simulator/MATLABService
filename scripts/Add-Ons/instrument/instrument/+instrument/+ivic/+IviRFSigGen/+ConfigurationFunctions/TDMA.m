classdef TDMA < instrument.ivic.IviGroupBase
    %TDMA This class includes all of the configuration
    %functions for the Time Division Multiple Access(TDMA)
    %functionality extension group.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function Name = GetTDMAStandardName(obj,Index,NameBufferSize)
            %GETTDMASTANDARDNAME This function returns the specific
            %driver defined TDMA standard name that corresponds to the
            %one-based index specified by the Index parameter.  If you
            %pass in a value for the Index parameter that is less than
            %one or greater than the value of the
            %IVIRFSIGGEN_ATTR_TDMA_STANDARD_COUNT attribute, the
            %function returns an empty string in the Name parameter and
            %returns the Invalid Value error.  Note:  For an instrument
            %with only one CDMA standard, i.e. the
            %IVIRFSIGGEN_ATTR_TDMA_STANDARD_COUNT attribute is one, the
            %driver may return an empty string.
            
            narginchk(3,3)
            Index = obj.checkScalarInt32Arg(Index);
            NameBufferSize = obj.checkScalarInt32Arg(NameBufferSize);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviRFSigGen_GetTDMAStandardName', session, Index, NameBufferSize, Name);
                
                Name = strtrim(char(Name.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SelectTDMAStandard(obj,Name)
            %SELECTTDMASTANDARD This function specifies the standard
            %used by the instrument. To obtain a list of available
            %standards, call the IviRFSigGen_GetTDMAStandardName
            %function.  Many instrument settings are affected by
            %selecting an instrument standard.  These settings include:
            %coding, mapping, symbol rate or bit clock frequency, filter
            %together with the associated filter parameters, and FSK
            %deviation or ASK depth (in case of FSK or ASK modulation).
            
            narginchk(2,2)
            Name = obj.checkScalarStringArg(Name);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = [double(Name) 0];
                
                status = calllib( libname,'IviRFSigGen_SelectTDMAStandard', session, Name);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureTDMAClockSource(obj,Source,Type)
            %CONFIGURETDMACLOCKSOURCE This function configures the TDMA
            %clock source.
            
            narginchk(3,3)
            Source = obj.checkScalarInt32Arg(Source);
            Type = obj.checkScalarInt32Arg(Type);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureTDMAClockSource', session, Source, Type);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureTDMATriggerSource(obj,Source)
            %CONFIGURETDMATRIGGERSOURCE This function configures the
            %TDMA trigger source for starting or synchronizing the
            %generation of the frames/slots.
            
            narginchk(2,2)
            Source = obj.checkScalarInt32Arg(Source);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureTDMATriggerSource', session, Source);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureTDMAExternalTriggerSlope(obj,Slope)
            %CONFIGURETDMAEXTERNALTRIGGERSLOPE This function configures
            %the trigger event to occur on the rising or falling edge of
            %the input signal. This setting is used only if
            %IVIRFSIGGEN_ATTR_TDMA_TRIGGER_SOURCE is set to External
            
            narginchk(2,2)
            Slope = obj.checkScalarInt32Arg(Slope);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureTDMAExternalTriggerSlope', session, Slope);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Name = GetTDMAFrameName(obj,Index,NameBufferSize)
            %GETTDMAFRAMENAME This function returns the specific driver
            %defined TDMA frame name that corresponds to the one-based
            %index specified by the Index parameter.  If you pass in a
            %value for the Index parameter that is less than one or
            %greater than the value of the
            %IVIRFSIGGEN_ATTR_TDMA_FRAME_COUNT attribute, the function
            %returns an empty string in the Name parameter and returns
            %the Invalid Value error.  Note:  For an instrument with
            %only one TDMA frame, i.e. the
            %IVIRFSIGGEN_ATTR_TDMA_FRAME_COUNT attribute is one, the
            %driver may return an empty string.
            
            narginchk(3,3)
            Index = obj.checkScalarInt32Arg(Index);
            NameBufferSize = obj.checkScalarInt32Arg(NameBufferSize);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviRFSigGen_GetTDMAFrameName', session, Index, NameBufferSize, Name);
                
                Name = strtrim(char(Name.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SelectTDMAFrame(obj,Name)
            %SELECTTDMAFRAME This function specifies the frame used for
            %framed digital modulation. To obtain a list of available
            %TDMA frames, call the IviRFSigGen_GetTDMAFrameName function.
            
            narginchk(2,2)
            Name = obj.checkScalarStringArg(Name);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = [double(Name) 0];
                
                status = calllib( libname,'IviRFSigGen_SelectTDMAFrame', session, Name);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
