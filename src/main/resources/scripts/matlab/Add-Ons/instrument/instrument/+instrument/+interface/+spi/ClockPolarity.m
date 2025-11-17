classdef (Enumeration) ClockPolarity < double
    % CLOCKPOLARITY : The Clock Polarity parameter indicates the level of
    % the clock signal when idle.
    
    % Copyright 2013 The MathWorks, Inc.
    
    enumeration
        % IdleLow(0) : Clock idle state is low.
        IdleLow (0)
        % IdleHigh(1) : Clock idle state is high.
        IdleHigh (1)
    end
end

