classdef AnalogModulation < instrument.ivic.IviGroupBase
    %ANALOGMODULATION The IviRFSigGenModulateAM Extension Group
    %supports signal generators that can apply amplitude
    %modulation to the RF output signal. The user can enable or
    %disable amplitude modulation, specify the source and
    %coupling of the modulating signal and the modulation depth
    %with lin/log attenuation.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureAMEnabled(obj,AMEnabled)
            %CONFIGUREAMENABLED This function configures the signal
            %generator to apply amplitude modulation to the RF output
            %signal.
            
            narginchk(2,2)
            AMEnabled = obj.checkScalarBoolArg(AMEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureAMEnabled', session, AMEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureAMExternalCoupling(obj,AMExternalCoupling)
            %CONFIGUREAMEXTERNALCOUPLING This function configures the
            %coupling of an external source for amplitude modulation.
            
            narginchk(2,2)
            AMExternalCoupling = obj.checkScalarInt32Arg(AMExternalCoupling);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureAMExternalCoupling', session, AMExternalCoupling);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureAM(obj,Source,Scaling,Depth)
            %CONFIGUREAM This function configures the modulation
            %source, scaling, and depth for the signal generator's
            %amplitude modulation.
            
            narginchk(4,4)
            Source = obj.checkScalarStringArg(Source);
            Scaling = obj.checkScalarInt32Arg(Scaling);
            Depth = obj.checkScalarDoubleArg(Depth);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Source = [double(Source) 0];
                
                status = calllib( libname,'IviRFSigGen_ConfigureAM', session, Source, Scaling, Depth);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureFMEnabled(obj,FMEnabled)
            %CONFIGUREFMENABLED This function configures the signal
            %generator to apply frequency modulation to the RF output
            %signal.
            
            narginchk(2,2)
            FMEnabled = obj.checkScalarBoolArg(FMEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureFMEnabled', session, FMEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureFMExternalCoupling(obj,FMExternalCoupling)
            %CONFIGUREFMEXTERNALCOUPLING This function configures the
            %coupling of an external source for frequency modulation.
            
            narginchk(2,2)
            FMExternalCoupling = obj.checkScalarInt32Arg(FMExternalCoupling);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureFMExternalCoupling', session, FMExternalCoupling);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureFM(obj,Source,Deviation)
            %CONFIGUREFM This function configures the modulation
            %deviation and modulation source for the signal generator's
            %frequency modulation.
            
            narginchk(3,3)
            Source = obj.checkScalarStringArg(Source);
            Deviation = obj.checkScalarDoubleArg(Deviation);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Source = [double(Source) 0];
                
                status = calllib( libname,'IviRFSigGen_ConfigureFM', session, Source, Deviation);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigurePMEnabled(obj,PMEnabled)
            %CONFIGUREPMENABLED This function configures the signal
            %generator to apply phase modulation to the RF output signal.
            
            narginchk(2,2)
            PMEnabled = obj.checkScalarBoolArg(PMEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigurePMEnabled', session, PMEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigurePMExternalCoupling(obj,PMExternalCoupling)
            %CONFIGUREPMEXTERNALCOUPLING This function configures the
            %coupling of an external source for phase modulation.
            
            narginchk(2,2)
            PMExternalCoupling = obj.checkScalarInt32Arg(PMExternalCoupling);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigurePMExternalCoupling', session, PMExternalCoupling);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigurePM(obj,Source,Deviation)
            %CONFIGUREPM Configures the attribute that control the
            %signal generator's phase modulation. The attributes are the
            %modulation deviation and the modulating source(s).  This
            %function configures the modulation deviation and modulation
            %source for the signal generator's phase modulation.
            
            narginchk(3,3)
            Source = obj.checkScalarStringArg(Source);
            Deviation = obj.checkScalarDoubleArg(Deviation);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Source = [double(Source) 0];
                
                status = calllib( libname,'IviRFSigGen_ConfigurePM', session, Source, Deviation);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Name = GetAnalogModulationSourceName(obj,Index,NameBufferSize)
            %GETANALOGMODULATIONSOURCENAME This function returns the
            %specific driver defined analog modulation source name that
            %corresponds to the one-based index specified by the Index
            %parameter.  If you pass in a value for the Index parameter
            %that is less than one or greater than the value of the
            %IVIRFSIGGEN_ATTR_ANALOG_MODULATION_SOURCE_COUNT attribute,
            %the function returns an empty string in the Name parameter
            %and returns the Invalid Value error.  Note:  For an
            %instrument with only one analog modulation source, i.e. the
            %IVIRFSIGGEN_ATTR_ANALOG_MODULATION_SOURCE_COUNT attribute
            %is one, the driver may return an empty string.
            
            narginchk(3,3)
            Index = obj.checkScalarInt32Arg(Index);
            NameBufferSize = obj.checkScalarInt32Arg(NameBufferSize);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviRFSigGen_GetAnalogModulationSourceName', session, Index, NameBufferSize, Name);
                
                Name = strtrim(char(Name.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
