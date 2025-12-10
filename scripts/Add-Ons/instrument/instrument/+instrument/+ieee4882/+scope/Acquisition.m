classdef Acquisition < handle
    %ACQUISITION Abstract base Class for Interface-based oscilloscope.
    % A concrete sub class need to override its abstract methods.
    
    % Copyright 2011 The MathWorks, Inc.
    
    %% Public Properties
    properties (Abstract)
        
        AcquisitionTime ;
        AcquisitionStartDelay;
        SingleSweepMode;
        WaveformLength;
        
    end
end


