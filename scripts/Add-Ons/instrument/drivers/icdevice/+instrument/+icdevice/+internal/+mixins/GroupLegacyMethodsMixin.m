classdef GroupLegacyMethodsMixin < handle
    %GROUPLEGACYMETHODSMIXIN overrides the isa and class function so that
    %new group objects are a 1-to-1 replacement of legacy icgroup objects.

    %   Copyright 2023-2024 The MathWorks, Inc.

    methods
        function result = isa(obj, arg2)
            arguments
                obj
                arg2
            end

            % convert to char in order to accept string datatype
            arg2 = instrument.internal.stringConversionHelpers.str2char(arg2);

            % Error checking.
            if ~ischar(arg2)
                error(message('instrument:icgroup:isa:badopt'));
            end

            gType = class(obj);
            result = any(arg2 == ["icgroup", "instrument.icdevice.internal.Group", gType]);
        end

        function val = class(obj, varargin)
            % Gives the class type of obj. Override provides special
            % functionality when there is only one input, returning what
            % legacy code would have given users.

            if nargin==1
                val = "ic" + lower(obj(1).Name); %#ok<*MCNPN>
            else
                try
                    % Constructing the object.  Call the builtin CLASS.
                    val = builtin('class', obj, varargin{:});
                catch aException
                    rethrow(aException);
                end
            end

            val = char(val);
        end
    end

    methods(Hidden)
        function close(varargin)
            ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;
            throw(ep.getMException(MException(message("instrument:icdevice:close:unsupportedFcn"))));
        end

        function out = isequal(varargin)
            % isequal is a custom implementation to compare multiple input
            % arguments for equality. This function checks whether all
            % input arguments are of the same size and content. It returns
            % true if all inputs are equal, and false otherwise. The
            % function assumes that the 'eq' method is properly defined for
            % the inputs being compared.

            if nargin < 2
                ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;
                throw(ep.getMException(MException(message("instrument:icgroup:isequal:minrhs"))));
            end
            out = instrument.icdevice.internal.utility.DriverUtility.checkInequality(varargin{:});
        end
    end
end