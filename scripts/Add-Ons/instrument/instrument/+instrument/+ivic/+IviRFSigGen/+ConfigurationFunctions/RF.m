classdef RF < instrument.ivic.IviGroupBase
    %RF This class contains functions to configure the base
    %capabilities of the RFSigGen.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureRF(obj,Frequency,PowerLevel)
            %CONFIGURERF This function configures the frequency and the
            %power level of the RF output signal.
            
            narginchk(3,3)
            Frequency = obj.checkScalarDoubleArg(Frequency);
            PowerLevel = obj.checkScalarDoubleArg(PowerLevel);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureRF', session, Frequency, PowerLevel);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureALCEnabled(obj,ALCEnabled)
            %CONFIGUREALCENABLED This function enables the Automatic
            %Level Control.
            
            narginchk(2,2)
            ALCEnabled = obj.checkScalarBoolArg(ALCEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureALCEnabled', session, ALCEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureOutputEnabled(obj,OutputEnabled)
            %CONFIGUREOUTPUTENABLED This function enables the RF output
            %signal.
            
            narginchk(2,2)
            OutputEnabled = obj.checkScalarBoolArg(OutputEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureOutputEnabled', session, OutputEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
