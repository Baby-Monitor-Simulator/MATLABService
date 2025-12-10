classdef (Hidden) InstrumentAdaptor < handle
    %InstrumentAdaptor Abstract base class for instrument adaptor objects.
    %   InstrumentAdaptor is an abstract base class for all concrete instrument
    %   adaptors to override all possible methods.
    
    %    Copyright 2011 The MathWorks, Inc.
    methods (Abstract, Access = protected)
        connect(obj)
        
    end
    
    methods (Abstract )
        disconnect(obj);
    end
end