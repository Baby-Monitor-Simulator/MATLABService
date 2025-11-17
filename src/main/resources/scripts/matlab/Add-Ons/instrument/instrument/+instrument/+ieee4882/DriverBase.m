classdef (Hidden) DriverBase < instrument.internal.DriverBaseClass
    %DriverBase class for IEEE488.2 based wrappers.
    %   This class provides common functions and capabilities to all
    %   IEEE488.2 based drivers such as driver instantiation and deletion.

    % Copyright 2011-2022 The MathWorks, Inc.

    properties (Hidden = true, Access = protected)
        Interface
        IntrumentType
    end

    properties
        Connected
        DriverName
    end

    methods
        function obj = DriverBase()
            obj.Connected = false ;
        end


        function value = get.Interface(obj)
            value = obj.Interface;
        end

        function delete(obj)
            % Suppresses fclose warning.
            warnState = instrument.internal.udm.WarningUtility.disableWarnings();
            c = onCleanup(@()instrument.internal.udm.WarningUtility.restoreWarnState(warnState));

            if obj.Connected
                fclose(obj.Interface);
            end

            delete (obj.Interface) ;
        end



        function connect(obj)

            % internally set the interface's inputBuffersize
            % and OutputBufferSize. Currently it has to be done before
            % connection is made.
            obj.Interface.InputBufferSize = 1e7;
            obj.Interface.OutputBufferSize = 1e7;

            fopen(obj.Interface);
            obj.Connected = true;
            %optional connection related configuration sub class need to
            %implement
            obj.postConnectionHook();

        end

        function disconnect(obj)
            % Suppresses fclose warning.
            warnState = instrument.internal.udm.WarningUtility.disableWarnings();
            c = onCleanup(@()instrument.internal.udm.WarningUtility.restoreWarnState(warnState));

            fclose(obj.Interface);
            obj.Connected = false;
        end

        function drivers = getDrivers (obj)
            drivers =  instrument.ieee4882.DriverUtility.getDrivers();
        end

        function resources = getResources (obj)
            resources =  instrument.ieee4882.DriverUtility.getResources();
        end

    end

    methods (Access = protected)

        function postConnectionHook(obj)

        end

    end


    methods (Hidden = true)


        function disp(obj)

            % Get the help for the class
            classHelpText = help(class(obj));
            % Remove the first word of the H1 line, which should be the
            % class name, in ALL CAPS
            [firstWord,adjustedClassHelpText] = strtok(classHelpText,' ');
            % Check that the first word is all caps
            if ~strcmp(firstWord,upper(firstWord))
                % if it's not, don't remove first word.
                adjustedClassHelpText = classHelpText;
            end

            % Display the class help text, followed by a line
            % feed
            textToDisp = sprintf('%s \n', adjustedClassHelpText);


            if obj.Connected
                textToDisp = class(obj.Interface);
            else
                textToDisp = sprintf('%s \n%s', textToDisp, ' A connection to an instrument has not been established. Use connect method to connect.');
            end
            %             % Line feed and add the property display
            textToDisp = sprintf('%s\n%s', textToDisp, obj.generatePropertyDisp());

            % Line feed and methods and superclass footer
            textToDisp = sprintf('%s\n%s',textToDisp , obj.generateFooter());

            % Display it all at once
            disp(textToDisp);
        end

        function textToDisp = generatePropertyDisp(obj)

            % define line feed for local use
            linefeed = 10;

            % Property header
            textToDisp = sprintf('%s\n', 'properties:');
            % Get the property names
            propNames = properties(obj);
            % Allocate a cell array for the values
            propValues = cell(size(propNames));
            for i=1:length(propNames)
                try
                    % Attempt to get the value of each property
                    propValues{i} = renderProperty(obj.(propNames{i}));
                catch e
                    % If an error occurs, for instance, the instrument
                    % isn't connected, capture that.
                    propValues{i} = sprintf('Error: %s',e.message);
                end
            end
            % Calculate the length of the longest property name
            maxPropNameLength = max(cellfun(@length,propNames));
            % Print the properties and values, with 3 spaces to the left of
            % the longest property name, and hyperlinks to help for each
            % property.
            for i=1:length(propNames)
                if feature('hotlinks')
                    % Display hyperlinks normally
                    propName = sprintf('<a href="matlab:help(''%s'')">%s</a>',...
                        [class(obj) '/' propNames{i}],...
                        propNames{i});
                else
                    % In publish case, don't show hyperlinks
                    propName = sprintf('%s',propNames{i});
                end
                textToDisp =  sprintf('%s   %s%s: %s\n',...
                    textToDisp,...
                    blanks(maxPropNameLength - length(propNames{i})),...
                    propName,...
                    propValues{i}) ;
            end

            function valueStr = renderProperty(value)
                if isa(value,'instrument.ieee4882.DriverGroupBase')
                    %if it is an interface, get the help for that class
                    classHelpText = help(class(value));
                    % Remove the first word of the H1 line, which should be the
                    % class name, in ALL CAPS
                    [firstWord,valueStr] = strtok(classHelpText,' ');
                    % Check that the first word is all caps
                    if ~strcmp(firstWord,upper(firstWord))
                        % if it's not, don't remove first word.
                        valueStr = classHelpText;
                    end
                    %Limit the help text to the first line
                    valueStr = strtrim(strtok(valueStr,linefeed));
                else
                    if isempty(value)
                        % If it's empty, print nothing
                        valueStr = '';
                    elseif isscalar(value)
                        if islogical(value)
                            % if it's a logical, print true/false
                            if value
                                valueStr = 'true';
                            else
                                valueStr = 'false';
                            end
                        else
                            % If it's a scalar numeric, print value
                            valueStr = num2str(value);
                        end
                    elseif ischar(value)
                        % If it's a string, print it in single quotes
                        valueStr = ['''' value ''''];
                    else
                        % If it's something else, print '<mxn class>',
                        % which should cover any other scenario.
                        valueStr = ['<' sprintf('%dx',size(value))];
                        valueStr(length(valueStr)) = []; % remove extra 'x'
                        valueStr = [valueStr ' ' class(value) '>'];
                    end
                end
            end
        end

        function textToDisp = generateFooter(obj)
            if ~feature('hotlinks')
                % No hyperlinked footer if hotlinks are off
                textToDisp = '';
                return
            end
            % Print the footer, with hyperlinks to methods and superclasses.
            textToDisp = sprintf('lists of <a href="matlab:methods(''%s'')">methods</a>, <a href="matlab:superclasses(''%s'')">superclasses</a>',...
                class(obj),class(obj));
        end

    end

end


