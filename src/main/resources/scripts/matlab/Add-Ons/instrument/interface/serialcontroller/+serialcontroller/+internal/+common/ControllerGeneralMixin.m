classdef(Abstract) ControllerGeneralMixin < handle
    % CONTROLLERGENERALMIXIN class exposes the device method for the customer facing controller class.
    % device method can create a I2CDevice peripheral object.

    % Copyright 2022 The MathWorks, Inc.

    properties (SetAccess = protected,Hidden)
        % Flag to set production mode or test mode.
        ProductionMode (1,1) logical
    end

    methods
        % Creates a peripheral device of type "I2C" using the
        % controller object as input.
        function dev = device(obj,varargin)
            try
                dev = device(obj.ChannelHandler,obj,varargin{:}); %#ok<MCNPN>
            catch ex
                throwAsCaller(ex);
            end
        end
    end
end

