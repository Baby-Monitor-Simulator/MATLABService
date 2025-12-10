classdef Memory < instrument.ieee4882.rfsiggen.Memory & instrument.ieee4882.rfsiggen.RsRfSigGen_SCPI.RohdeSchwarzbase
    % MEMORY This class contains functions that
    % initiate instrument operations and report
    % their status.
    
    % Copyright 2017 The MathWorks, Inc.
    
    
    %% Constructor
    methods (Hidden=true)
        function obj = Memory(interface)
            % Initialize properties
            obj.Interface = interface;
        end
    end
    
    %% Public Methods
    methods
        function MemoryDeleteFile(obj,fileName)
            % MEMORYDELETEFILE This function deletes the named file.
            narginchk(2,2)
            obj.sendCmdToInstrument(':SOURce:BB:ARBitrary:STATe OFF');
            obj.sendCmdToInstrument([':MMEMory:DELete ''/var/user/', fileName, '.wv''']);
        end
    end
end
