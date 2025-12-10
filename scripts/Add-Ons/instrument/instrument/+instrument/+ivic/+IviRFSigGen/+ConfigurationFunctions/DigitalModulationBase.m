classdef DigitalModulationBase < instrument.ivic.IviGroupBase
    %DIGITALMODULATIONBASE With
    %IviRFSigGenDigitalModulationBase Extension Group the user
    %can generate signals conforming to wireless communication
    %standards (e.g. mobile cellular standards). The generated
    %signals do not have TDMA framing nor CDMA channel coding.
    %The functionality covers basic modulation properties such
    %as IQ constellation, symbol mapping, etc. within a
    %specified communication standard.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function Name = GetDigitalModulationBaseStandardName(obj,Index,NameBufferSize)
            %GETDIGITALMODULATIONBASESTANDARDNAME This function returns
            %the specific driver defined DigitalModulationBase standard
            %name that corresponds to the one-based index specified by
            %the Index parameter.  If you pass in a value for the Index
            %parameter that is less than one or greater than the value
            %of the
            %IVIRFSIGGEN_ATTR_DIGITAL_MODULATION_BASE_STANDARD_COUNT
            %attribute, the function returns an empty string in the Name
            %parameter and returns the Invalid Value error.  Note:  For
            %an instrument with only one DigitalModulationBase standard,
            %i.e. the
            %IVIRFSIGGEN_ATTR_DIGITAL_MODULATION_BASE_STANDARD_COUNT
            %attribute is one, the driver may return an empty string.
            
            narginchk(3,3)
            Index = obj.checkScalarInt32Arg(Index);
            NameBufferSize = obj.checkScalarInt32Arg(NameBufferSize);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviRFSigGen_GetDigitalModulationBaseStandardName', session, Index, NameBufferSize, Name);
                
                Name = strtrim(char(Name.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SelectDigitalModulationBaseStandard(obj,Name)
            %SELECTDIGITALMODULATIONBASESTANDARD This function
            %specifies the actual standard used by the instrument.  To
            %obtain a list of available standards, call the
            %IviRFSigGen_GetDigitalModulationBaseStandardName function.
            %Many instrument settings are affected by selecting an
            %instrument standard.  These settings include: coding,
            %mapping, symbol rate or bit clock frequency, filter
            %together with the associated filter parameters, and FSK
            %deviation or ASK depth (in the case of FSK or ASK
            %modulation).
            
            narginchk(2,2)
            Name = obj.checkScalarStringArg(Name);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = [double(Name) 0];
                
                status = calllib( libname,'IviRFSigGen_SelectDigitalModulationBaseStandard', session, Name);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureDigitalModulationBaseClockSource(obj,Source,Type)
            %CONFIGUREDIGITALMODULATIONBASECLOCKSOURCE This function
            %configures the DigitalModulationBase clock source.
            
            narginchk(3,3)
            Source = obj.checkScalarInt32Arg(Source);
            Type = obj.checkScalarInt32Arg(Type);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureDigitalModulationBaseClockSource', session, Source, Type);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureDigitalModulationBaseDataSource(obj,Source)
            %CONFIGUREDIGITALMODULATIONBASEDATASOURCE This function
            %configures the source of the data for the digital
            %modulation.
            
            narginchk(2,2)
            Source = obj.checkScalarInt32Arg(Source);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureDigitalModulationBaseDataSource', session, Source);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureDigitalModulationBasePRBSType(obj,Type)
            %CONFIGUREDIGITALMODULATIONBASEPRBSTYPE This function
            %configures the type of the PRBS used as data for the
            %digital modulation. The setting is used only if
            %IVIRFSIGGEN_ATTR_DIGITAL_MODULATION_BASE_DATA_SOURCE is set
            %to PRBS.
            
            narginchk(2,2)
            Type = obj.checkScalarInt32Arg(Type);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureDigitalModulationBasePRBSType', session, Type);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function WriteDigitalModulationBaseBitSequence(obj,Name,BitCount,Sequence,MoreDataPending)
            %WRITEDIGITALMODULATIONBASEBITSEQUENCE This function
            %creates a bit sequence for use as the digital modulation
            %data. The sequence is repeated continuously. The sequence
            %string consists of binary values (8 bit in 1 char/byte).
            
            narginchk(5,5)
            Name = obj.checkScalarStringArg(Name);
            BitCount = obj.checkScalarInt32Arg(BitCount);
            Sequence = obj.checkScalarStringArg(Sequence);
            MoreDataPending = obj.checkScalarBoolArg(MoreDataPending);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = [double(Name) 0];
                Sequence = [double(Sequence) 0];
                
                status = calllib( libname,'IviRFSigGen_WriteDigitalModulationBaseBitSequence', session, Name, BitCount, Sequence, MoreDataPending);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SelectDigitalModulationBaseBitSequence(obj,Name)
            %SELECTDIGITALMODULATIONBASEBITSEQUENCE This function sets
            %a bit sequence to be used as digital modulation data.
            %Create bit sequences using the
            %IviRFSigGen_WriteDigitalModulationBaseBitSequence function.
            %The bit sequence is set only if the
            %IVIRFSIGGEN_ATTR_DIGITAL_MODULATION_BASE_DATA_SOURCE
            %attribute is set to BitSequence.
            
            narginchk(2,2)
            Name = obj.checkScalarStringArg(Name);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = [double(Name) 0];
                
                status = calllib( libname,'IviRFSigGen_SelectDigitalModulationBaseBitSequence', session, Name);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ClearAllDigitalModulationBaseBitSequences(obj)
            %CLEARALLDIGITALMODULATIONBASEBITSEQUENCES This function
            %clears (deletes) all named bit sequences.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ClearAllDigitalModulationBaseBitSequences', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
