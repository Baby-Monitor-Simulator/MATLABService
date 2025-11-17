classdef QCInstrument <  instrument.internal.DriverBaseClass & ...
        matlab.mixin.CustomDisplay
    % QCInstrument is the base class for Quick-Control instruments.
    % This class contains common functionality for QC instruments
    
    % Copyright 2011-2023 The MathWorks, Inc.
    
    properties(Access = protected, Hidden, Abstract)
        % QUICKCONTROLTYPE defines the type of quick control device.
        QuickControlType (1, 1) string
    end
    
    properties (Hidden, SetAccess = protected)

        % An instance of quick control instrument's internal state.
        InternalState

        % A map of all the possible states of the quick control instrument
        InternalStateMap
    end
    
    methods (Hidden, Access = protected)              
        function displayNonScalarObject(obj)
            % Displays the quick control object and its properties for an array
            % of quick control device objects
            try
                % Display the properties of each element in the array.

                for i = 1 : numel(obj)
                    fprintf(message("instrument:qcinstrument:objectDisp", obj(i).QuickControlType, i).getString);
                    obj(i).displayScalarObject();
                end
            catch ex
                throw(ex);
            end
        end

        function displayScalarObject(obj)
            % Displays the quick control object and its properties.

            if isvalid(obj) && ~isempty(obj.Adaptor)
                obj.displayHelper();
            elseif isvalid(obj) && isempty(obj.Adaptor)
                obj.InternalState.disp();
            else
                disp(getString(message('instrument:qcinstrument:deletedObject')));
            end
        end
        
        function valueStr = renderProperty(obj, value) %#ok
            %renderProperty defines the format for each type of
            %properties.
            if isempty(value)
                % If it's empty, print nothing
                valueStr = '';
            elseif iscell(value)
                valueStr ='';
                for i = 1:size(value, 2)
                    valueStr =  sprintf('%s ''%s'',',valueStr , value{i});
                end
                valueStr(1) = []; % remove empty space
                valueStr(length(valueStr)) = [];
            elseif ischar(value)
                % If it's a string, print it in single quotes
                valueStr = ['''' value ''''];
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
            else
                
            end
        end 
    end
    
    methods
        function varargout = set(obj, varargin)
            if ~all(isvalid(obj))
                error(message('MATLAB:class:InvalidHandle'))
            end
            
            % convert to char in order to accept string datatype
            varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
            
            
            if (nargin > 2)
                set@hgsetget(obj,varargin{:});
                % if the inputs to the set method is correct: set(obj, <propName>, <propValue>, ...),
                % then an LHS will not be assigned. Throw error if an
                % LHS is provided.
                if nargout > 0
                    me = MException(message("instrument:qcinstrument:invalidNumOutputSet"));
                    throw(me);
                end
            else
                qcnargin = nargin;
                qcnargout = nargout;
                % user calls set(obj)
                if qcnargin == 1 && qcnargout == 0
                    qcSet(obj, qcnargin, qcnargout, varargin{:});
                elseif qcnargin == 2
                    % if the user entered property is not a member of the
                    % object properties, then generate error
                    propertyNames = properties(obj);
                    if ~sum(ismember(propertyNames, varargin{1}))                        
                        exception = MException('instrument:qcinstrument:notValidProperty', message('instrument:qcinstrument:notValidProperty', varargin{1}).getString);
                        throwAsCaller(exception)
                    end                    
                    varargout = {qcSet(obj, qcnargin, qcnargout, varargin{:})};
                else % all other cases
                    varargout = {qcSet(obj, qcnargin, qcnargout, varargin{:})};
                end
            end
        end
    end
    
    methods(Access = private)
        function varargout = qcSet(obj, qcnargin, qcnargout, varargin)
            %QCSET is the custom set method for the FGen object. This
            %function provides different number of outputs depending on the
            %number of inputs and outputs.
            
            % Find the class of the object calling the set method. The
            % class is of the format 'instrument.<qc-instrument>. Using
            % strsplit, split the string at the '.' delimiter. Then using
            % lower() function obtain the object.
            qcClassType = strsplit(class(obj), '.');
            qcInstr = lower(qcClassType{2});
            
            % list all the properties defined for the FGen object
            propertyNames = properties(obj);
            
            % sorting the propertyNames alphabetically
            sortedPropertyNames = sort(propertyNames);
            
            if qcnargin == 1 && qcnargout == 0 % user calls set(obj)
                textToDisp = '';
                
                for i = 1:numel(sortedPropertyNames)
                    % fetch the enum values if they exist
                    enumVals = obj.propertyEnumChk(qcInstr, sortedPropertyNames{i});
                    
                    if numel(enumVals) > 0
                        propertyString = '';
                        % create a string of all enum values in required
                        % format
                        for enumCount = 1:numel(enumVals)
                            propertyString = sprintf('%s | %s', propertyString, enumVals{enumCount});
                        end
                        % the propertyString will have ' | <propertyName>...'
                        % format, therefore dropping the first 3 characters
                        propertyString = ['[' propertyString(4:end) ']'];
                        % prepend the property name
                        str2Disp = sprintf('%s: %s', sortedPropertyNames{i}, propertyString);
                    else
                        % if not an enum class
                        propertyString = '';
                        str2Disp = sprintf('%s %s', sortedPropertyNames{i}, propertyString);
                    end
                    % create the final display string. The space between the format specifiers
                    % is to left align the displayed result
                    textToDisp = sprintf('%s\t%s\n', textToDisp, str2Disp);
                end
                disp(textToDisp);
            elseif qcnargin == 1 && nargout ==  1 % user calls s = set(obj);
                for i = 1:numel(sortedPropertyNames)
                    % fetch the enum values if they exist
                    enumVals = obj.propertyEnumChk(qcInstr, sortedPropertyNames{i}); %#ok
                    
                    % update the propertySetStruct structure
                    eval(['propertySetStruct.' sortedPropertyNames{i} '= enumVals;']);
                end
                
                % Assign the result to the output
                varargout = {propertySetStruct};
            elseif qcnargin == 2                
                % fetch the enum values if they exist
                enumVals = obj.propertyEnumChk(qcInstr, varargin{1});
                % check if property has a predefined enum class
                % definition
                valueToDisp = {};
                if numel(enumVals)>0
                    propertyString = '';
                    if qcnargout == 0
                        % create a string of all enum values in required
                        % format
                        for enumCount = 1:numel(enumVals)
                            propertyString = sprintf('%s | %s', propertyString, enumVals{enumCount});
                        end
                        % the propertyString will have ' | <propertyName>...'
                        % format, therefore dropping the first 3 characters
                        valueToDisp = ['[' propertyString(4:end) ']'];
                    elseif qcnargout == 1
                        if size(enumVals, 2) ~= 1
                            enumVals = transpose(enumVals);
                        end
                        valueToDisp = enumVals;
                    end
                    varargout{1} = valueToDisp;
                else
                    str2Disp = sprintf('{}');
                    varargout{1} = str2Disp;
                end
            end
        end
        
        function enumVals = propertyEnumChk(obj, qcInstr, propertyName)   %#ok
            % PROPERTYENUMCHK checks if the property has enumerated inputs and fetches it if it exists.
            
            enumVals = {};
            % enum class definition, if it exists
            enumChkStr = ['instrument.internal.udm.' qcInstr '.' propertyName 'Enum'];
            % check if property has a predefined enum class
            % definition
            if exist(enumChkStr, 'class')
                % fetch the enum set
                [~, enumVals] = enumeration(enumChkStr);
            end
        end
    end
    
    methods (Static, Access = protected)
        
          function driversInfo = instrumentDrivers(instrumentType, formatOutput)              
            
            %instrumentDrivers retrieves a list of available
            %instrument drivers of instrumentType.
            driversArray_temp = instrument.internal.udm.InstrumentUtility.getDrivers(instrumentType);
            driversArray = cell(numel(driversArray_temp, 1));
            indx = 1;
            for i = 1:max(size(driversArray_temp))
                if isempty(strfind(driversArray_temp{i}.Name, 'testDriver'))
                    driversArray{indx} = driversArray_temp{i};
                    indx = indx+1;
                end
            end
            
            if formatOutput == true
                driversInfo = '';
                for idx = 1:numel(driversArray)
                    line = strtrim(driversArray{idx}.SupportedInstrumentModels);
                    newline = 10;
                    maxLineLength = 60;
                    if length(line) < maxLineLength
                        supportedModels = sprintf ('%s\n',line);
                    else                    
                        while length(line) > maxLineLength
                            % Find where we could break the line
                            % before we reach maxLineLength.
                            split_idx = regexp(line(1:maxLineLength),',');
                            split_idx = split_idx(end);
                            
                            % Copy the line to the split point, and add indent
                            newline = sprintf('%s   %s', newline, strtrim(line(1:split_idx-1)));
                            % Insert a line feed.
                            newline = sprintf ('%s\n',(newline));
                            % repeat with remainder of the line.
                            line(1:split_idx) = [];
                        end
                        supportedModels = newline(2:end);                                            
                    end
                    driverInfo = message("instrument:qcinstrument:driversDisp", driversArray{idx}.Name, supportedModels).getString;
                    driversInfo = sprintf('%s%s', driversInfo, driverInfo);
                end
            else
                if size(driversArray,1) == 1
                    driversInfo = driversArray';
                else
                    driversInfo = driversArray;
                end
            end
        end       
        
        function resourceList = instrumentResources(instrumentType, formatOutput)
            %instrumentResources retrieves a list of available instrument
            %resources.
            resourcesArray_temp = instrument.internal.udm.InstrumentUtility.getResources(instrumentType);
            
            resourcesArray = cell(numel(resourcesArray_temp, 1));
            indx = 1;
            for i = 1:max(size(resourcesArray_temp))
                if isempty(strfind(resourcesArray_temp{i}, 'testresource'))
                    resourcesArray{indx} = resourcesArray_temp{i};
                    indx = indx+1;
                end
            end
            
            %format the output
            if formatOutput == true
                resourceList = '';
                for i = 1: numel(resourcesArray)
                    resourceList = sprintf('%s %s\n', resourceList, resourcesArray{i});
                end
            else
                if size(resourcesArray,1) == 1
                    resourceList = resourcesArray';
                else
                    resourceList = resourcesArray;
                end
            end 
        end
    end
    
    methods
        function varargout = methods(obj, varargin)
            methodNames = builtin('methods', obj);
            methodNames = sort(methodNames);
            
            methodNames = instrument.internal.QCInstrument.localRemoveName...
                (methodNames, {'methods','isvalid','set','get','getdisp','setdisp','listener'});
            
            switch nargout
            case 0
                switch nargin
                case 1
                    % Calculate the maximum base method name.
                    maxLength = max(cellfun('length', methodNames));

                    % Print out the method names.
                    instrument.internal.QCInstrument.localPrettyPrint...
                        (methodNames, maxLength, message("instrument:qcinstrument:methodsDisp", class(obj)).getString);
                case 2
                    builtin('methods', obj, '-full');
                end
            case 1
                varargout{1} = methodNames;        
            end            
        end        
    end
    
    methods (Static, Hidden, Access=private)
        
        function methodNames = localRemoveName(methodNames, names)
            for i=1:length(names)
                index = strcmpi(names{i}, methodNames);
                methodNames(index) = [];
            end
        end
        
        function localPrettyPrint(methodNames, maxMethodLength, heading)

            % Calculate spacing information.
            maxColumns = floor(80/maxMethodLength);
            maxSpacing = 2;
            numOfRows = ceil(length(methodNames)/maxColumns);

            % Reshape the methods into a numOfRows-by-maxColumns matrix.
            numToPad = (maxColumns * numOfRows) - length(methodNames);
            for i = 1:numToPad
                methodNames = {methodNames{:} ' '};
            end
            methodNames = reshape(methodNames, numOfRows, maxColumns);

            % Print out the methods.
            fprintf(['\n' heading '\n\n']);

            % Loop through the methods and print them out.
            for i = 1:numOfRows
                out = '';
                for j = 1:maxColumns
                    m = methodNames{i,j};
                    out = [out sprintf([m blanks(maxMethodLength + maxSpacing - length(m))])];
                end    
                fprintf([out '\n']);
            end
            
            fprintf('\n\n');
        end
    end
    
    % To be deprecated helpers
    methods (Static, Hidden, Access = protected)
        function issueDeprecatedMethodWarning(methodName, newName)
            persistent methodsHaveIssuedWarning
            
            if isempty(methodsHaveIssuedWarning)
                methodsHaveIssuedWarning = {};
            end
            
            if ~ismember(methodName, methodsHaveIssuedWarning)
                instrument.internal.QCInstrument.localizedWarning('instrument:instrument:instrument:deprecatedFunction', methodName, newName)
                methodsHaveIssuedWarning = [methodsHaveIssuedWarning, methodName];
            end
        end
        
        function localizedWarning(id, varargin)
            % This is used by MathWorks classes to generate errors using
            % the globalization dictionaries, and provides for localization.  The
            % method signature of warning(id,varargin) allows arbitrary
            % strings to be substituted into the message.
            
            % If you pass in an ID of 'instrument:instrument:instrument:foobar" it will find the
            % foobar key in the <MATLABROOT>/resources/instrument/en/instrument/instrument.xml
            % file.
            
            % The localized text catalog ID system cannot handle doubles as parameters for substitutions,
            % and can throw an error if non-integral values are passed to
            % it.  To ensure this can't happen, we throw an error whenever
            % a parameter is not a string.
             if ~(all(cellfun(@ischar,varargin)))
                 error(message('instrument:instrument:instrument:errorMessageParamNotString'));
             end
            
            % Turn off backtrace for a moment
            sWarningBacktrace = warning('off','backtrace');
            warning(message(id,varargin{:}));
            warning(sWarningBacktrace);
       end 
       
    end
end