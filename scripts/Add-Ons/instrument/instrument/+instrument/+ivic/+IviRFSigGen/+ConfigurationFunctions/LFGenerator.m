classdef LFGenerator < instrument.ivic.IviGroupBase
    %LFGENERATOR This class contains functions to configure the
    %low frequency (LF) functionality of RFSigGens.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureLFGenerator(obj,Frequency,Waveform)
            %CONFIGURELFGENERATOR This function configures the LF
            %generators output frequency and  waveform.
            
            narginchk(3,3)
            Frequency = obj.checkScalarDoubleArg(Frequency);
            Waveform = obj.checkScalarInt32Arg(Waveform);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureLFGenerator', session, Frequency, Waveform);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Name = GetLFGeneratorName(obj,Index,NameBufferSize)
            %GETLFGENERATORNAME This function returns the specific
            %driver defined LF generator source name that corresponds to
            %the one-based index specified by the Index parameter.  If
            %you pass in a value for the Index parameter that is less
            %than one or greater than the value of the
            %IVIRFSIGGEN_ATTR_LF_GENERATOR_COUNT attribute, the function
            %returns an empty string in the Name parameter and returns
            %the Invalid Value error.  Note:  For an instrument with
            %only one LF generator source, i.e. the
            %IVIRFSIGGEN_ATTR_LF_GENERATOR_COUNT attribute is one, the
            %driver may return an empty string.
            
            narginchk(3,3)
            Index = obj.checkScalarInt32Arg(Index);
            NameBufferSize = obj.checkScalarInt32Arg(NameBufferSize);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviRFSigGen_GetLFGeneratorName', session, Index, NameBufferSize, Name);
                
                Name = strtrim(char(Name.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SetActiveLFGenerator(obj,ActiveLFGenerator)
            %SETACTIVELFGENERATOR This function selects one of the
            %available LF generator sources, and makes it the active
            %LFGenerator.
            
            narginchk(2,2)
            ActiveLFGenerator = obj.checkScalarStringArg(ActiveLFGenerator);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ActiveLFGenerator = [double(ActiveLFGenerator) 0];
                
                status = calllib( libname,'IviRFSigGen_SetActiveLFGenerator', session, ActiveLFGenerator);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureLFGeneratorOutput(obj,Amplitude,Enabled)
            %CONFIGURELFGENERATOROUTPUT This function sets the output
            %voltage and enables the LF generator within the RF signal
            %generator.
            
            narginchk(3,3)
            Amplitude = obj.checkScalarDoubleArg(Amplitude);
            Enabled = obj.checkScalarBoolArg(Enabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureLFGeneratorOutput', session, Amplitude, Enabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
