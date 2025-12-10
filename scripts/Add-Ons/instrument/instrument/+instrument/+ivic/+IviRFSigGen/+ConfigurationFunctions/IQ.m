classdef IQ < instrument.ivic.IviGroupBase
    %IQ The IviRFSigGenModulateIQ Extension Group supports
    %signal generators that can apply IQ (vector) modulation to
    %the RF output signal. The user can enable or disable IQ
    %modulation and specify the source of the modulating signal.
    %A calibration is executed with an event function.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureIQEnabled(obj,IQEnabled)
            %CONFIGUREIQENABLED This function configures the signal
            %generator to apply IQ (vector) modulation to the RF output
            %signal.
            
            narginchk(2,2)
            IQEnabled = obj.checkScalarBoolArg(IQEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureIQEnabled', session, IQEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureIQ(obj,Source,SwapEnabled)
            %CONFIGUREIQ This function configures the signal generator
            %to apply IQ (vector) modulation to the RF output signal.
            
            narginchk(3,3)
            Source = obj.checkScalarInt32Arg(Source);
            SwapEnabled = obj.checkScalarBoolArg(SwapEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureIQ', session, Source, SwapEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function CalibrateIQ(obj)
            %CALIBRATEIQ This function calibrates the IQ modulator.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_CalibrateIQ', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureIQImpairmentEnabled(obj,IQImpairmentEnabled)
            %CONFIGUREIQIMPAIRMENTENABLED This function enables the IQ
            %(vector) modulation to allow controlled impairment for test
            %or external corrections.
            
            narginchk(2,2)
            IQImpairmentEnabled = obj.checkScalarBoolArg(IQImpairmentEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureIQImpairmentEnabled', session, IQImpairmentEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureIQImpairment(obj,IOffset,QOffset,Ratio,Skew)
            %CONFIGUREIQIMPAIRMENT This function configures the
            %settings that simulate or correct impairment for the signal
            %generator's IQ modulation. These settings are only used if
            %the IVIRFSIGGEN_ATTR_IQ_IMPAIRMENT_ENABLED attribute is set
            %to True.
            
            narginchk(5,5)
            IOffset = obj.checkScalarDoubleArg(IOffset);
            QOffset = obj.checkScalarDoubleArg(QOffset);
            Ratio = obj.checkScalarDoubleArg(Ratio);
            Skew = obj.checkScalarDoubleArg(Skew);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureIQImpairment', session, IOffset, QOffset, Ratio, Skew);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
