classdef ConfigurationInformation < instrument.ivic.IviGroupBase
    %CONFIGURATIONINFORMATION This class contains functions
    %that return information about the current configuration.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ActualRecordLength = ActualRecordLength(obj)
            %ACTUALRECORDLENGTH This function returns the actual number
            %of points the oscilloscope acquires for each channel.
            %After you configure the oscilloscope for an acquisition,
            %call this function to determine the size of the waveforms
            %that the oscilloscope acquires.  The value is greater than
            %or equal to the minimum number of points you specify in the
            %IviScope_ConfigureAcquisitionRecord function.    You must
            %allocate a ViReal64 array of this size or greater to pass
            %as the Waveform Array parameter of the
            %IviScope_ReadWaveform and IviScope_FetchWaveform functions.
            % Notes:  (1) The oscilloscope may use records of different
            %size depending on the acquisition type.  You specify the
            %acquisition type with the IviScope_ConfigureAcquisitionType
            %function.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                ActualRecordLength = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviScope_ActualRecordLength', session, ActualRecordLength);
                
                ActualRecordLength = ActualRecordLength.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function AutoProbeSenseValue = AutoProbeSenseValue(obj,ChannelName)
            %AUTOPROBESENSEVALUE The function returns the probe
            %attenuation value the oscilloscope senses.  The automatic
            %probe sense capability is enabled by setting the Probe
            %Attenuation parameter of the IviScope_ConfigureChannel
            %function to IVISCOPE_VAL_PROBE_SENSE_ON.  Notes:    (1) If
            %you disable the automatic probe sense capability, this
            %parameter returns the manual probe attenuation setting.
            %(2) This function is part of the IviScopeProbeAutoSense
            %[PAS] extension group.
            
            narginchk(2,2)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                AutoProbeSenseValue = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviScope_AutoProbeSenseValue', session, ChannelName, AutoProbeSenseValue);
                
                AutoProbeSenseValue = AutoProbeSenseValue.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SampleMode = SampleMode(obj)
            %SAMPLEMODE This function returns the sample mode the
            %oscilloscope is currently using.  Notes:  (1) This function
            %is part of the IviScopeSampleMode [SM] extension group.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                SampleMode = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviScope_SampleMode', session, SampleMode);
                
                SampleMode = SampleMode.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SampleRate = SampleRate(obj)
            %SAMPLERATE This function returns the effective sample rate
            %of the acquired waveform using the current configuration in
            %samples per second.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                SampleRate = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviScope_SampleRate', session, SampleRate);
                
                SampleRate = SampleRate.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
