classdef Acquisition < instrument.ieee4882.scope.Acquisition & instrument.ieee4882.scope.tektronix.Tekbase
    %ACQUISITION Class provides an implementation for Tektronix Oscilloscope for
    %the abstract methods defined in its abstract parent class.
    
    % Copyright 2011-2012 The MathWorks, Inc.
    
    %% Public Properties
    properties
        
        
        %AcquisitionTime This attribute specifies the
        %time in seconds that corresponds to the record length.
        AcquisitionTime  ;
        
        
        %AcquisitionStartDelay This attributes specifies the
        %length of time from the trigger event to the first point in
        %the waveform record.  The units are seconds.  If the value
        %is positive, the first point in the waveform record occurs
        %after the trigger event.  If the value is negative, the
        %first point in the waveform record occurs before the
        %trigger event.
        AcquisitionStartDelay ;
        
        %SingleSweepMode Specifies whether the oscilloscope
        %continuously initiates waveform acquisition.
        SingleSweepMode
        
        WaveformLength;
    end
    
    properties (Hidden, Access = 'private' )
        %this is used to distinguish tek scope firmware version, it may be
        %extended to second tek scope class if more firmware differences
        %are discovered
        FirmWareVersion ;
    end
    
    
    %% Property access methods
    methods
        
        function obj = Acquisition(interface, firmWareVersion)
            obj.Interface = interface;
            obj.FirmWareVersion = firmWareVersion;
        end
        
        %% AcquisitionTime property access methods
        function value = get.AcquisitionTime(obj)
            
            fprintf (obj.Interface, 'HORizontal:MAIn:SCAle?' );
            value =  10 * str2double(fscanf (obj.Interface)  );
            
        end
        
        function set.AcquisitionTime(obj,newValue)
            
            validateattributes(newValue,{'numeric'}, {'finite','positive'});
            xScale = newValue /  10 ;
            cmd =  sprintf ('HORizontal:MAIn:SCAle %f', xScale);
            obj.sendCmdToInstrument ( cmd);
            
        end
        
        
        
        %% AcquisitionStartDelay property access methods
        function value = get.AcquisitionStartDelay(obj)
            
            if ( obj.FirmWareVersion == 1 )
                value = 'Not supported';
            else
                ret =  obj.queryInstrument ('HORizontal:DELay:TIMe?' );
                value = str2double (ret );
            end
            
        end
        
        function set.AcquisitionStartDelay(obj,newValue)
            
            if ( obj.FirmWareVersion == 1 ) %#ok<*MCSUP>
                error(message('instrument:ieee4882Driver:notSupported'));
            else
                cmd =  sprintf ('HORizontal:DELay:TIMe %f', newValue);
                obj.sendCmdToInstrument( cmd);
            end
        end
        
        
        %% SingleSweepMode property access methods
        function value = get.SingleSweepMode(obj)
            
            value = obj.queryInstrument('ACQuire:STOPAfter?');
            if strcmpi (value , 'SEQuence')
                value = 'on';
            else
                value = 'off';
            end
        end
        
        function set.SingleSweepMode(obj,newValue)
            if strcmpi (newValue , 'on')
                obj.sendCmdToInstrument('ACQuire:STOPAfter SEQuence' );
            else
                obj.sendCmdToInstrument('ACQuire:STOPAfter RUNSTop' );
            end
            
        end
        
        %% WaveformLength property access methods
        function value = get.WaveformLength(obj)
            value = obj.queryInstrument ('HORizontal:RECOrdlength?');
            value = str2double(value);
        end
        
        
        function set.WaveformLength(obj,newValue)
            if ( obj.FirmWareVersion == 1 )
                error(message ('instrument:ieee4882Driver:notSupported'));
            else
                cmd = sprintf ('HORizontal:RECOrdlength %f' , newValue);
                obj.sendCmdToInstrument ( cmd);
            end
            
        end
        
    end
    
    %     methods (Access = 'protected')
    %         function value = geAcquisitionStartDelayHook (obj)
    %             value = 'Not supported';
    %         end
    %     end
end

