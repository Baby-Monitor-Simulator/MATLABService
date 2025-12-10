classdef CDMA < instrument.ivic.IviGroupBase
    %CDMA This class includes all of the configuration
    %functions for the Code Division Multiple Access(CDMA)
    %functionality extension group.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function Name = GetCDMAStandardName(obj,Index,NameBufferSize)
            %GETCDMASTANDARDNAME This function returns the specific
            %driver defined CDMA standard name that corresponds to the
            %one-based index specified by the Index parameter.  If you
            %pass in a value for the Index parameter that is less than
            %one or greater than the value of the
            %IVIRFSIGGEN_ATTR_CDMA_STANDARD_COUNT attribute, the
            %function returns an empty string in the Name parameter and
            %returns the Invalid Value error.  Note:  For an instrument
            %with only one CDMA standard, i.e. the
            %IVIRFSIGGEN_ATTR_CDMA_STANDARD_COUNT attribute is one, the
            %driver may return an empty string.
            
            narginchk(3,3)
            Index = obj.checkScalarInt32Arg(Index);
            NameBufferSize = obj.checkScalarInt32Arg(NameBufferSize);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviRFSigGen_GetCDMAStandardName', session, Index, NameBufferSize, Name);
                
                Name = strtrim(char(Name.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SelectCDMAStandard(obj,Name)
            %SELECTCDMASTANDARD This function specifies the standard
            %used by the instrument. To obtain a list of available
            %standards, call the IviRFSigGen_GetCDMAStandardName
            %function.  Many instrument settings are affected by
            %selecting an instrument standard.  These settings include:
            %modulation type, bit clock frequency and filter together
            %with the associated filter parameters.
            
            narginchk(2,2)
            Name = obj.checkScalarStringArg(Name);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = [double(Name) 0];
                
                status = calllib( libname,'IviRFSigGen_SelectCDMAStandard', session, Name);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureCDMAClockSource(obj,Source)
            %CONFIGURECDMACLOCKSOURCE This function configures the CDMA
            %clock source.
            
            narginchk(2,2)
            Source = obj.checkScalarInt32Arg(Source);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureCDMAClockSource', session, Source);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureCDMATriggerSource(obj,Source)
            %CONFIGURECDMATRIGGERSOURCE This function configures the
            %CDMA trigger source for starting or synchronizing the
            %generation of the channel codings.
            
            narginchk(2,2)
            Source = obj.checkScalarInt32Arg(Source);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureCDMATriggerSource', session, Source);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureCDMAExternalTriggerSlope(obj,Slope)
            %CONFIGURECDMAEXTERNALTRIGGERSLOPE This function configures
            %the trigger event to occur on the rising or falling edge of
            %the input signal. This setting is used only if
            %IVIRFSIGGEN_ATTR_CDMA_TRIGGER_SOURCE is set to External.
            
            narginchk(2,2)
            Slope = obj.checkScalarInt32Arg(Slope);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureCDMAExternalTriggerSlope', session, Slope);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Name = GetCDMATestModelName(obj,Index,NameBufferSize)
            %GETCDMATESTMODELNAME This function returns the specific
            %driver defined CDMA test model name that corresponds to the
            %one-based index specified by the Index parameter.  If you
            %pass in a value for the Index parameter that is less than
            %one or greater than the value of the
            %IVIRFSIGGEN_ATTR_CDMA_TEST_MODEL_COUNT attribute, the
            %function returns an empty string in the Name parameter and
            %returns the Invalid Value error.  Note:  For an instrument
            %with only one CDMA test model, i.e. the
            %IVIRFSIGGEN_ATTR_CDMA_TEST_MODEL_COUNT attribute is one,
            %the driver may return an empty string.
            
            narginchk(3,3)
            Index = obj.checkScalarInt32Arg(Index);
            NameBufferSize = obj.checkScalarInt32Arg(NameBufferSize);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviRFSigGen_GetCDMATestModelName', session, Index, NameBufferSize, Name);
                
                Name = strtrim(char(Name.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SelectCDMATestModel(obj,Name)
            %SELECTCDMATESTMODEL This function specifies the channel
            %coding used for the digital modulation. To obtain a list of
            %available CDMA test models for channel coding, call the
            %IviRFSigGen_GetCDMATestModelName function.
            
            narginchk(2,2)
            Name = obj.checkScalarStringArg(Name);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = [double(Name) 0];
                
                status = calllib( libname,'IviRFSigGen_SelectCDMATestModel', session, Name);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
