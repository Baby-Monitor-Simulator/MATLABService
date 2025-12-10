classdef Channel < instrument.ivic.IviGroupBase
    %CHANNEL This class contains functions that configure the
    %individual channels of the oscilloscope.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureChannel(obj,ChannelName,VerticalRange,VerticalOffset,VerticalCoupling,ProbeAttenuation,ChannelEnabled)
            %CONFIGURECHANNEL This function configures the most
            %commonly configured attributes of the oscilloscope channel
            %sub-system.  These attributes are the range, offset,
            %coupling, probe attenuation, and whether the channel is
            %enabled.
            
            narginchk(7,7)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            VerticalRange = obj.checkScalarDoubleArg(VerticalRange);
            VerticalOffset = obj.checkScalarDoubleArg(VerticalOffset);
            VerticalCoupling = obj.checkScalarInt32Arg(VerticalCoupling);
            ProbeAttenuation = obj.checkScalarDoubleArg(ProbeAttenuation);
            ChannelEnabled = obj.checkScalarBoolArg(ChannelEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviScope_ConfigureChannel', session, ChannelName, VerticalRange, VerticalOffset, VerticalCoupling, ProbeAttenuation, ChannelEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureChanCharacteristics(obj,ChannelName,InputImpedanceohms,MaxInputFrequencyhertz)
            %CONFIGURECHANCHARACTERISTICS This function configures the
            %attributes that control the electrical characteristics of
            %the channel.  These attributes are the input impedance and
            %the maximum frequency of the input signal.
            
            narginchk(4,4)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            InputImpedanceohms = obj.checkScalarDoubleArg(InputImpedanceohms);
            MaxInputFrequencyhertz = obj.checkScalarDoubleArg(MaxInputFrequencyhertz);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviScope_ConfigureChanCharacteristics', session, ChannelName, InputImpedanceohms, MaxInputFrequencyhertz);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
