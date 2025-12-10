classdef (Hidden) Fgen < instrument.ieee4882.DriverBase
    %IEEE488.2 based fgen class
    
    % Copyright 2012-2018 The MathWorks, Inc.
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        
        %UTILITY Attributes that control common instrument operations.
        Utility
        
        %CHANNELSUBSYSTEM Attributes that control aspects related to the channels.
        ChannelSubsystem
        
        %TRIGGERSUBSYSTEM Attributes that control aspects related to the triggering.
        TriggerSubsystem
        
        %WAVEFORMSUBSYSTEM Attributes that control aspects related to the waveform.
        WaveformSubsystem
        
    end
    
    
    %% Construction/Clean up
    methods
        function obj = Fgen(varargin)
            narginchk(1,2) ;
            obj.IntrumentType = 'fgen';
            resource = varargin{1};
            switch (nargin)
                % resource info only
                case 1
                    obj.DriverName = instrument.ieee4882.DriverUtility.getDriver(resource, obj.IntrumentType);
                case 2
                    instrument.ieee4882.DriverUtility.validateDriverName(varargin{2}, obj.IntrumentType);
                    obj.DriverName =  varargin{2};
            end
            
            if isempty ( obj.DriverName)
                error (message('instrument:ieee4882Driver:invalidDriver'));
            end
            obj.Interface = instrument.ieee4882.DriverUtility.createInterface (resource);
            
            % Initialize properties
            try
                
                obj.Utility = feval(str2func (['instrument.ieee4882.fgen.', obj.DriverName , '.Utility']), obj.Interface);
                obj.ChannelSubsystem = feval(str2func (['instrument.ieee4882.fgen.', obj.DriverName , '.ChannelSubsystem']), obj.Interface);
                obj.TriggerSubsystem = feval(str2func (['instrument.ieee4882.fgen.', obj.DriverName , '.TriggerSubsystem']), obj.Interface);
                obj.WaveformSubsystem = feval(str2func (['instrument.ieee4882.fgen.', obj.DriverName , '.WaveformSubsystem']), obj.Interface);
            catch myException
                getReport(myException)
            end
        end
        
        
        function resources = getResources (obj) %#ok<MANU>
            resources =  instrument.ieee4882.DriverUtility.getResources();
        end
        
        function delete(obj)
            obj.Utility = [];
            obj.ChannelSubsystem = [];
            obj.TriggerSubsystem = [];
            obj.WaveformSubsystem = [];
        end
        
    end
    
    methods (Access = protected)
        
        function postConnectionHook(obj)
            % Clear instrument error and status queues to prevent existing
            % status messages from feeding through
            fprintf (obj.Interface, '*CLS');
        end
    end
    
    
    %% Property access methods
    methods
        
        %% ChannelSubsystem property access methods
        function value = get.ChannelSubsystem(obj)
            if isempty(obj.ChannelSubsystem)
                obj.ChannelSubsystem = feval(str2func (['instrument.ieee4882.fgen.', obj.DriverName , '.ChannelSubsystem']), obj.Interface);
            end
            value = obj.ChannelSubsystem;
        end
        
        %% TriggerSubsystem property access methods
        function value = get.TriggerSubsystem(obj)
            if isempty(obj.TriggerSubsystem)
                obj.TriggerSubsystem = feval(str2func (['instrument.ieee4882.fgen.', obj.DriverName , '.TriggerSubsystem']), obj.Interface);
            end
            value = obj.TriggerSubsystem;
        end
        
        %% Utility property access methods
        function value = get.Utility(obj)
            if isempty(obj.Utility)
                obj.Utility = feval(str2func (['instrument.ieee4882.fgen.', obj.DriverName , '.Utility']), obj.Interface);
            end
            value = obj.Utility;
        end
        
        %% WaveformSubsystem property access methods
        function value = get.WaveformSubsystem(obj)
            if isempty(obj.WaveformSubsystem)
                obj.WaveformSubsystem =  feval(str2func (['instrument.ieee4882.fgen.', obj.DriverName , '.WaveformSubsystem']), obj.Interface);
            end
            value = obj.WaveformSubsystem;
        end
        
    end
    
    
end
