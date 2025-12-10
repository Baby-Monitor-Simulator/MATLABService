classdef (Enumeration) ClockPhase < double
    % CLOCKPHASE Indicates when the data should be sampled.
   
    % Copyright 2013 The MathWorks, Inc.
    
    enumeration
        % FirstEdge(0) - The first edge of the clock is used to
        % sample the first data byte. The first edge may be the rising edge
        % (if ClockPhase = IdleLow) or the falling edge(if
        % ClockPhase = IdleHigh)
        FirstEdge(0)
        % SecondEdge(1) - The second edge of the clock is used to sample
        % the first data byte. The second edge may be the falling edge (if
        % ClockPolarity = IdleLow) or the rising edge(if 
        % ClockPolarity = IdleHigh)
        SecondEdge(1)
    end
end