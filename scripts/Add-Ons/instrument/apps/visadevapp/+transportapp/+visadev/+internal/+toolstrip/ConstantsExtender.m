classdef (Abstract) ConstantsExtender < dynamicprops
    %CONSTANTSEXTENDER class for overriding and extending Shared
    %Transport App infrastructure "Constants" classes.
    %
    % Shared Transport App "Constants" classes
    % (matlabshared.transportapp.internal.toolstrip.*.Constants) have only
    % Constant properties, so none of the properties in these classes can
    % be overridden by deriving classes (eg. deriving class wants to add a
    % DataFormat, but cannot override or re-define DataFormat property in
    % base Constants class). This class provides a generic pass-through
    % functionality that allows classes to override or replace properties
    % in the base Constants classes without re-writting properties that
    % they wish to re-use.

    % Copyright 2022 The MathWorks, Inc.
    
    properties(Constant, Access = protected, Abstract)
        % Handle to the base Constants class
        BaseConstants
    end
    
    methods
        function obj = ConstantsExtender()
            % Get list of base class properties
            baseProps = string(properties(obj.BaseConstants))';

            for propName = baseProps
                % If base class property is re-defined in this class, skip
                % this property
                if isprop(obj, propName)
                    continue;
                end

                % If base class property is not re-defined, dynamically add
                % that property to this class and assign the GetMethod.
                p = addprop(obj, propName);
                p.GetMethod = @(~)obj.getFromBase(propName);
            end
        end
    end

    methods(Access = private)
        function value = getFromBase(obj, propName)
            % GetMethod for properties that are not re-defined. Pass
            % through to base class.
            value = obj.BaseConstants.(propName);
        end
    end
end

