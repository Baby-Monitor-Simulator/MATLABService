classdef HardwareInfo < dynamicprops & matlab.mixin.CustomDisplay
% HardwareInfo Displays information on available hardware.

% Copyright 2014-2022 The MathWorks, Inc.
    
    properties (Access = private)
        % PropertyList - Stores the properties in the order of creation.
        PropertyList
    end

    properties (Constant, Hidden)
        % Old property names that we want to hide.
        PropertiesToReplace (1, :) string = ["MasterConfigurationStore"]

        % Corresponding new property names for "PropertiesToReplace" that
        % we want to use instead.
        PropertiesReplacedBy (1, :) string = ["ConfigurationStoreLocation"]

        PropertiesReplacement = dictionary(instrument.HardwareInfo.PropertiesToReplace, instrument.HardwareInfo.PropertiesReplacedBy)
    end
    
    methods
        % FIELDNAMES returns the properties of the object in in the order
        % of creation for maintaining backward compatibility with
        % INSTRHWINFO display.
        function names = fieldnames(obj)
            names = obj.PropertyList;
        end
    end
    
    methods (Static)
        % STRUCT2OBJ converts a structure to HardwareInfo object. The
        % structure fields are converted to properties.
        function obj = Struct2Obj(structData)
            obj = instrument.HardwareInfo();

            allProps = fieldnames(structData);
            if isempty(allProps)
                obj.PropertyList = allProps;
                return
            end

            allProps = string(allProps)';
            for prop = allProps
                addDynamicProperty(obj, prop, structData);
            end

            % Update "PropertyList" with the new property name. FYI,
            % "PropertyList" is used later for object display - check the
            % getPropertyGroups() method.
            allProps = replace(allProps, obj.PropertiesToReplace, obj.PropertiesReplacedBy);
            obj.PropertyList = cellstr(allProps)';

            %% NESTED STATIC FUNCTION
            function addDynamicProperty(originalObject, originalProp, structData)
                % Add the <originalProp> as a dynamic property on the
                % HardwareInfo class instance.
                %
                % If <originalProp> has a new replacement name, add both
                % the <originalProp> and the new name as dynamicprops, and
                % set the <originalProp> property as hidden.
                %
                % e.g. old name -> MasterConfigurationStore
                %      new name -> PrimaryConfigurationStore
                %
                % There are going to be 2 properties,
                % MasterConfigurationStore and PrimaryConfigurationStore,
                % added as dynamic props. MasterConfigurationStore will be
                % hidden and won't show up as a public member of the class.
                % PrimaryConfigurationStore will show up as a public member
                % of the class, and it's value will be the same as the
                % MasterConfigurationStore

                p = originalObject.addprop(originalProp);
                originalObject.(originalProp) = structData.(originalProp);

                if isKey(originalObject.PropertiesReplacement, originalProp)
                    newProp = originalObject.PropertiesReplacement(originalProp);

                    % Add the new property
                    originalObject.addprop(newProp);
                    originalObject.(newProp) = structData.(originalProp);

                    % Hide the original property
                    p.Hidden = true;
                end
            end
        end
    end
    
    methods (Access = protected)
        % GETFOOTER returns the footer information. 
        function footer = getFooter(~)
            if matlab.internal.display.isHot
                footer = sprintf('Access to your hardware may be provided by a support package. Go to the <a href="matlab:instrument.internal.supportPackageInstaller">Support Package Installer</a> to learn more.\n\n');
            else
                footer = '';
            end
        end
        
        % GETPROPERTYGROUPS returns the properties of the object in in the
        % order of creation for maintaining backward compatibility with
        % INSTRHWINFO display.
        function propgrp = getPropertyGroups(obj)
            if (~isempty(obj.PropertyList))
                propgrp = matlab.mixin.util.PropertyGroup(obj.PropertyList);
            else
                propgrp = [];
            end
        end
    end
end