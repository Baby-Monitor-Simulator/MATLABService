classdef (Hidden)InstrumentUtility < handle
    %InstrumentUtility class provides useful helper functions.
    % InstrumentUtility offers support functions such as available
    % instrument resources and drivers. It also retrieves available
    % adapters information from adapters.config file.

    %    Copyright 2011-2023 The MathWorks, Inc.

    properties (Constant)
        MachineIDType = dictionary(["PCWIN", "PCWIN64", "GLNXA64", "MACI64"], 1:4)
    end

    methods(Static)
        function resources = getResources(instrumentType)
            %GetResources method follows the chain of responsibility pattern, it
            %iterates through each adapter and query the resource information.

            adaptors = instrument.internal.udm.InstrumentUtility.getAdapterList(instrumentType);

            resourcesArray ={};
            for i = 1: size (adaptors , 2)
                % for each resource discovery technique
                for j =  1 : size ( adaptors{i}.ResourceDiscovery, 2)
                    try
                        specificTarget = feval(str2func([adaptors{i}.Name '.getResource']),adaptors{i}.ResourceDiscovery{j} );
                        resourcesArray  =  horzcat (resourcesArray , specificTarget ); %#ok<*AGROW>
                    catch e  %#ok<*NASGU>
                    end
                end
            end

            %eliminate dups
            resources = unique(resourcesArray);

        end

        function visaResources = getVisaResources() %#ok<*STOUT>
            %GetVisaResources returns a list of VISA resources installed in
            %the system.

            visaResources = {};
            try
                vl = visadevlist("Timeout", 60);
            catch
                return
            end

            if ~isempty(vl)
                visaResources = cellstr(vl.ResourceName');
            end
        end

        function drivers = getDrivers(instrumentType)
            %GetDrivers method follows the chain of responsibility pattern, it
            %iterates through each adapter and query the supported driver information.

            adaptors = instrument.internal.udm.InstrumentUtility.getAdapterList(instrumentType);
            drivers = {};
            %follows chain of responsibility pattern
            for i = 1: size (adaptors , 2)
                try
                    specificDrivers = feval(str2func([adaptors{i}.Name '.getDriver']));
                    drivers  =  horzcat (drivers , specificDrivers );
                catch e
                end
            end

        end

        function adaptors =  getAdapterList(instrumentType)
            %GetAdapterList reads adapters.config file and get a list of available
            %adapters for each OS and the instrument type.

            arguments
                instrumentType (1, 1) string
            end

            ictroot = toolboxdir("instrument");
            adaptersFileName = fullfile(ictroot, "instrument", "+instrument","+internal", "+udm" ,"adapters.config" );

            try
                xmlFile = readstruct(adaptersFileName, "FileType", "xml");
            catch
                error(message("instrument:oscilloscope:failedToParseConfigFile"));
            end

            % Parse the config file and retrieve adapter info.
            adaptors = getAdapters(xmlFile, instrumentType);

            %% NESTED Function
            function adapters = getAdapters(xmlFile, instrumentType)
                % Return the adaptors list from the xml file for the given
                % instrument type.

                adapters = {};
                machineType = string(computer);
                idx = instrument.internal.udm.InstrumentUtility.MachineIDType(machineType);

                instrumentData = xmlFile.OS(idx).(machineType);
                if ismissing(instrumentData)
                    return
                end

                try
                    adaptorData = instrumentData.(instrumentType).adapter;
                catch
                    % Return an empty cell-array for an invalid
                    % instrumentType.
                    return
                end

                for a = adaptorData
                    dataStruct.Name = char(a.name);
                    dataStruct.ResourceDiscovery = getResourceDiscoveryData(a);
                    adapters{end+1} = dataStruct;
                end

                %% NESTED Function
                function resourceVal = getResourceDiscoveryData(val)
                    resourceVal = {};
                    resourceIdentification = val.resourceIdentification;
                    for type = resourceIdentification
                        resourceVal{end+1} = char(type.name);
                    end
                end
            end
        end

        function instrumentInfo = queryInstrument( resource)
            %QueryInstrument creates a VISA object and send '*IDN' to the
            %instrument, then it queries resource string from the
            %instrument.

            try
                vl = visadevlist;
            catch e
                switch e.identifier
                    case {"instrument:interface:visa:unableToFindResources",...
                            "instrument:interface:visa:unableToFindResourcesDefaultTimeout"}
                        error(message(e.identifier));
                    otherwise
                        error(message('instrument:oscilloscope:noVisaInstalled'));
                end
            end

            try
                v = visadev(resource);
            catch e
                error(message('instrument:oscilloscope:notValidResource'));
            end

            try
                instrumentInfo = writeread(v, "*IDN?");
                instrumentInfo = sprintf('%s\n', instrumentInfo);
            catch
                % Ignore error
                instrumentInfo = string.empty;
            end
        end
    end
end