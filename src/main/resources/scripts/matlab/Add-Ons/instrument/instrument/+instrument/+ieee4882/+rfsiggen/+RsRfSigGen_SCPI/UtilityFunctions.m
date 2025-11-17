classdef UtilityFunctions < instrument.ieee4882.rfsiggen.UtilityFunctions & instrument.ieee4882.rfsiggen.RsRfSigGen_SCPI.RohdeSchwarzbase
    % UTILITYFUNCTIONS This class contains functions that
    % control common instrument operations.
    % These functions include functions such as reset, revision query.
    
    % Copyright 2017-2018 The MathWorks, Inc.
    
    %% Constructor
    methods (Hidden=true)
        function obj = UtilityFunctions(interface)
            obj.Interface = interface;
        end
    end
    %% Public Properties - Read Only
    properties  (Dependent, SetAccess = private)
        % MANUFACTURER The name of the manufacturer reported by the
        % physical instrument.
        Manufacturer
        
        % MODEL The model number or name reported by the physical instrument.
        Model
        
        % FIRMWAREREVISION Returns the firmware revision of the instrument,
        % which is the value held in the Instrument Firmware Revision
        % attribute.
        FirmwareRevision
    end
    properties  (Constant)
        % REVISION Revision of the SCPI specific driver, which is the value
        % held in the Specific Driver Revision attribute.
        Revision = '1.0.0.0';
    end
    %% Property access methods
    methods
        %% MANUFACTURER property access methods
        function value = get.Manufacturer(obj)
            strID = obj.queryInstrument ('*IDN?');
            % remove firmware info portion
            positions = strfind (strID , ',');
            if ~isempty(positions)
                manufacturer = strtrim(strID (1: positions(1) -1 ));
            end
            value = manufacturer;
        end
        
        %% MODEL property access methods
        function value = get.Model(obj)
            strID = obj.queryInstrument ('*IDN?');
            % remove firmware info portion
            positions = strfind (strID , ',');
            if ~isempty(positions) && length(positions) >= 2
                model = strtrim(strID(positions(1)+1:positions(2)-1));
            end
            value = model;
        end
        
        %% FIRMWAREREVISION property access methods
        function value = get.FirmwareRevision(obj)
            strID = obj.queryInstrument ('*IDN?');
            % remove firmware info portion
            positions = strfind (strID , ',');
            if ~isempty(positions) && length(positions) >= 3
                firmwareRevision = strtrim(strID(positions(3)+1:end));
            end
            value = firmwareRevision;
        end
    end
    
    %% Public Methods
    methods
        function reset(obj)
            % RESET This function resets the instrument to the factory default state
            obj.sendCmdToInstrument('*RST');
        end
        
        function [manufacturer, model] = getInstrumentInfo(obj)
            value = obj.queryInstrument ('*IDN?');
            % remove firmware info portion
            positions = strfind (value , ',');
            if ~isempty(positions) && length(positions) >= 2
                manufacturer = strtrim(value (1: positions(1) -1 ));
                model = strtrim(value(positions(1)+1:positions(2)-1));
            end
        end
        
        function [driverRev, instrRev] = revisionQuery(obj)
            driverRev = obj.Revision;
            instrRev = obj.FirmwareRevision;
        end
        
    end
end
