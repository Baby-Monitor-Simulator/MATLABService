classdef Memory < instrument.ieee4882.rfsiggen.Memory & instrument.ieee4882.rfsiggen.AgRfSigGen_SCPI.Agilentbase
    % MEMORY This class contains functions
    % that initiate instrument operations and report
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
            obj.sendCmdToInstrument('SOURce:RADio:ARB:STATe OFF');
            obj.sendCmdToInstrument(['SOURce:RADio:ARB:WAVeform "WFM1:', fileName, '"']);
        end
    end
end
