classdef Acquisition < instrument.ivic.IviGroupBase
    %ACQUISITION This class contains functions that configure
    %the acquisition subsystem.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureAcquisitionType(obj,AcquisitionType)
            %CONFIGUREACQUISITIONTYPE This function configures how the
            %oscilloscope acquires data and how it fills the waveform
            %record.
            
            narginchk(2,2)
            AcquisitionType = obj.checkScalarInt32Arg(AcquisitionType);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviScope_ConfigureAcquisitionType', session, AcquisitionType);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureAcquisitionRecord(obj,TimePerRecordseconds,MinimumRecordLength,StartTimeseconds)
            %CONFIGUREACQUISITIONRECORD This function configures the
            %most commonly configured attributes of the oscilloscope
            %acquisition subsystem. These attributes are the time per
            %record, minimum record length, and the acquisition start
            %time.
            
            narginchk(4,4)
            TimePerRecordseconds = obj.checkScalarDoubleArg(TimePerRecordseconds);
            MinimumRecordLength = obj.checkScalarInt32Arg(MinimumRecordLength);
            StartTimeseconds = obj.checkScalarDoubleArg(StartTimeseconds);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviScope_ConfigureAcquisitionRecord', session, TimePerRecordseconds, MinimumRecordLength, StartTimeseconds);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureNumAverages(obj,NumberofAverages)
            %CONFIGURENUMAVERAGES When you set the acquisition type to
            %IVISCOPE_VAL_AVERAGE, the oscilloscope acquires multiple
            %waveforms.  After each waveform acquisition, the
            %oscilloscope keeps the average value of all acquisitions
            %for each element in the waveform record.  This function
            %configures the number of waveforms that the oscilloscope
            %acquires and averages.  After the oscilloscope acquires as
            %many waveforms as you specify, it returns to the idle
            %state.    Notes:  (1) Set the acquisition type to
            %IVISCOPE_VAL_AVERAGE before you call this function.  To set
            %the acquisition type, call the
            %IviScope_ConfigureAcquisitionType function.   (2) This
            %function is part of the IviScopeAverageAcquisition [AA]
            %extension group.
            
            narginchk(2,2)
            NumberofAverages = obj.checkScalarInt32Arg(NumberofAverages);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviScope_ConfigureNumAverages', session, NumberofAverages);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureNumEnvelopes(obj,NumberofEnvelopes)
            %CONFIGURENUMENVELOPES When you set the acquisition type to
            %IVISCOPE_VAL_ENVELOPE, the oscilloscope acquires multiple
            %waveforms.  After each waveform acquisition, the
            %oscilloscope keeps the minimum and maximum values it finds
            %for each element in the waveform record.  This function
            %configures the number of waveforms the oscilloscope
            %acquires and analyzes to create the minimum and maximum
            %waveforms.  After the oscilloscope acquires as many
            %waveforms as you specify, it returns to the idle state.
            %Notes:  (1) Set the acquisition type to
            %IVISCOPE_VAL_ENVELOPE before you call this function.  To
            %set the acquisition type, call the
            %IviScope_ConfigureAcquisitionType function.   (2) This
            %function is part of the IviScopeMinMaxWaveform [MmW]
            %extension group.
            
            narginchk(2,2)
            NumberofEnvelopes = obj.checkScalarInt32Arg(NumberofEnvelopes);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviScope_ConfigureNumEnvelopes', session, NumberofEnvelopes);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureInterpolation(obj,Interpolation)
            %CONFIGUREINTERPOLATION This function configures the
            %interpolation method the oscilloscope uses when it cannot
            %sample a voltage for a point in the waveform record.
            %Notes:  (1) This function is part of the
            %IviScopeInterpolation [I] extension group.
            
            narginchk(2,2)
            Interpolation = obj.checkScalarInt32Arg(Interpolation);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviScope_ConfigureInterpolation', session, Interpolation);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureInitiateContinuous(obj,ContinuousAcquisition)
            %CONFIGUREINITIATECONTINUOUS This function configures the
            %oscilloscope to perform continuous acquisition.  Notes:
            %(1) This function is part of the
            %IviScopeContinuousAcquisition [CA] extension group.
            
            narginchk(2,2)
            ContinuousAcquisition = obj.checkScalarBoolArg(ContinuousAcquisition);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviScope_ConfigureInitiateContinuous', session, ContinuousAcquisition);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
