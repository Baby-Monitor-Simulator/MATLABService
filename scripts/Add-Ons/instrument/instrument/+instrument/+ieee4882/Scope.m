classdef (Hidden) Scope < instrument.ieee4882.DriverBase
    %IEEE488.2 based Scope class
    
    % Copyright 2011-2018 The MathWorks, Inc.
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        
        %UTILITY Attributes that control common instrument operations.
        Utility
        
        %ACQUISITION Attributes that configure the various
        %acquisition modes.
        Acquisition
        
        %CHANNELSUBSYSTEM Channel-based attributes that is used to
        %configure the oscilloscope.
        ChannelSubsystem
        
        %TRIGGERSUBSYSTEM Attributes that control how the
        %oscilloscope triggers an acquisition.
        TriggerSubsystem
        
        %WAVEFORMACQUISITION Attributes that used to retrieve waveforms.
        WaveformAcquisition
        
    end
    
    properties (Access = 'private')
        
        FirmWaveVersion =  1;
    end
    
    
    %% Construction/Clean up
    methods
        function obj = Scope( varargin)
            
            narginchk(1,2) ;
            obj.IntrumentType = 'scope';
            resource = varargin{1};
            switch (nargin)
                % resource info only
                case 1
                    [obj.DriverName , obj.FirmWaveVersion ] =  instrument.ieee4882.DriverUtility.getDriver ( resource ,  obj.IntrumentType );
                    
                case 2
                    instrument.ieee4882.DriverUtility.validateDriverName ( varargin{2},  obj.IntrumentType);
                    obj.DriverName =  varargin{2};
            end
            
            if isempty ( obj.DriverName)
                error (message('instrument:ieee4882Driver:invalidDriver'));
            end
            
            obj.Interface = instrument.ieee4882.DriverUtility.createInterface (resource);

            %% Initialize properties
            obj.WaveformAcquisition =  feval(str2func (['instrument.ieee4882.scope.', obj.DriverName , '.WaveformAcquisition']), obj.Interface);
            obj.Utility = feval(str2func (['instrument.ieee4882.scope.', obj.DriverName , '.Utility']), obj.Interface);
            obj.Acquisition = feval(str2func (['instrument.ieee4882.scope.', obj.DriverName , '.Acquisition']), obj.Interface, obj.FirmWaveVersion);
            obj.ChannelSubsystem = feval(str2func (['instrument.ieee4882.scope.', obj.DriverName , '.ChannelSubsystem']), obj.Interface,  obj.FirmWaveVersion);
            obj.TriggerSubsystem = feval(str2func (['instrument.ieee4882.scope.', obj.DriverName , '.TriggerSubsystem']), obj.Interface);
            
        end
        
        
        
        function resources = getResources (obj) %#ok<MANU>
            resources =  instrument.ieee4882.DriverUtility.getResources();
        end
        
        
        function delete(obj)
            obj.TriggerSubsystem = [];
            obj.ChannelSubsystem = [];
            obj.Acquisition = [];
            obj.Utility = [];
            obj.WaveformAcquisition = [];
            
        end
    end
    
    methods (Access = protected)
        
        function postConnectionHook(obj)
            % turn off header info off, otherwise if returned SCPI command
            % is used to compose next SCPI command, it will result in
            % instrument error.
            fprintf (obj.Interface, 'HEADER OFF');
            fprintf(obj.Interface, 'VERBOSE ON');
            % Clear the Standard Event Status Register (SESR) to remove possible Power
            % on event, which would otherwise be returned by getError.
            query(obj.Interface, '*ESR?');
        end
        
        
    end
    %% Property access methods
    methods
        
        %% WaveformAcquisition property access methods
        function value = get.WaveformAcquisition(obj)
            if isempty(obj.WaveformAcquisition)
                obj.WaveformAcquisition =  feval(str2func (['instrument.ieee4882.scope.', obj.DriverName , '.WaveformAcquisition']), obj.Interface);
            end
            value = obj.WaveformAcquisition;
        end
        
        %% Utility property access methods
        function value = get.Utility(obj)
            if isempty(obj.Utility)
                obj.Utility = feval(str2func (['instrument.ieee4882.scope.', obj.DriverName , '.Utility']), obj.Interface);
            end
            value = obj.Utility;
        end
        
        %% Acquisition property access methods
        function value = get.Acquisition(obj)
            if isempty(obj.Acquisition)
                obj.Acquisition = feval(str2func (['instrument.ieee4882.scope.', obj.DriverName , '.Acquisition']), obj.Interface,   obj.FirmWaveVersion);
            end
            value = obj.Acquisition;
        end
        
        %% ChannelSubsystem property access methods
        function value = get.ChannelSubsystem(obj)
            if isempty(obj.ChannelSubsystem)
                obj.ChannelSubsystem = feval(str2func (['instrument.ieee4882.scope.', obj.DriverName , '.ChannelSubsystem']), obj.Interface,  obj.FirmWaveVersion);
            end
            value = obj.ChannelSubsystem;
        end
        
        %% TriggerSubsystem property access methods
        function value = get.TriggerSubsystem(obj)
            if isempty(obj.TriggerSubsystem)
                obj.TriggerSubsystem = feval(str2func (['instrument.ieee4882.scope.', obj.DriverName , '.TriggerSubsystem']), obj.Interface);
            end
            value = obj.TriggerSubsystem;
        end
        
        
    end
    
    
end
