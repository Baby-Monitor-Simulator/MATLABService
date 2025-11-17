classdef MATFileToDriverDataConverter < handle
    % MATFILETODRIVERDATACONVERTER does the following:
    % 1) Loads the .mat file which contains metadata for the requested
    % vendor driver (only if it finds the .mat file).
    % 2) Converts the data retrieved from the .mat file into a format
    % accepted by the client (DriverMetaDataAdapter) and saves it as a
    % property that can be accessed later by the client.
    % 3) Provides a method for the client to access the data.

    % Copyright 2024 The MathWorks, Inc.

    properties
        % Name of driver
        Driver

        % Contains data for specific functions.
        DriverFuncData

        % Contains the names of all function and function groups in the
        % hierarchy.
        DriverFuncTreeData

        % Contains data for specific properties.
        DriverPropData

        % Contains dynamic repeated capability data used by properties.
        DynamicRepCapMetaData

        % Contains static repeated capability data used by properties.
        StaticRepCapMetaData

        % Form containing ividev examples for some properties
        PropMExampleForm (1, :) ividev.makeMATLABDriver.internal.ividevappForm.PropMExampleForm
    end

    %% Lifetime
    methods
        function obj = MATFileToDriverDataConverter(driver)
            obj.Driver = driver;
            matFileData = getMatFileData(obj);
            obj.DriverFuncData = getFuncData(obj, matFileData);
            obj.DriverFuncTreeData = getFuncTreeData(obj, matFileData);
            obj.DriverPropData = getPropMetaData(obj, matFileData);
            saveRepCapInfo(obj, matFileData);
            savePropMatlabExamples(obj, matFileData);
        end
    end

    %% Data Accessor API
    methods
        function value = accessDataProp(obj, propName, index)
            % This function allows clients to access driver data saved in
            % this class by providing the property name and an optional
            % structure index for the data structure array.
            arguments
                obj
                propName (1, 1) string
                index {mustBeScalarOrEmpty(index), mustBeNumeric(index)} = []
            end

            if isempty(index)
                value = {obj.DriverFuncData.(propName)};
            else
                value = obj.DriverFuncData(index).(propName);
            end
        end
    end

    %% Private Helper functions
    methods (Access = private)
        function matFileData = getMatFileData(obj)
            % Loads the .mat file which contains metadata for the requested
            % vendor driver.
            % After loading the data, this function converts the data into
            % a format accepted by the client (DriverMetaDataAdapter).

            if obj.Driver ~= "NimSc"
                matFileDir = getMatFileDir();
            else
                % Only NimSc test driver mat file uses this test tools location.
                matFileDir = fullfile(matlabroot, "test", "tools", "instrument", "apps", "ividevapp", "appData");
            end

            try
                matFileData = load(fullfile(matFileDir, obj.Driver + "DriverData.mat"));
            catch
                throw(MException(message("ividevapp:ividevapp:MATFileUnSupported")));
            end

            function matFileDir = getMatFileDir()
                % Returns the location of the mat file for the requested
                % driver.
                matFileDir = fullfile(matlabshared.supportpkg.getSupportPackageRoot, "toolbox", "instrument", "supportpackages", "ividev", "drivers", "appData");
                if isfolder(matFileDir)
                    return
                else
                    matFileDir = "";
                end
            end
        end

        function data = getFuncData(obj, matFileData)
            % Retrieves all the function data from the loaded .mat file.
            % This function converts the data into a format accepted by the
            % client (DriverMetaDataAdapter).

            metaData = matFileData.funcData;
            data = getStructData(obj, metaData);
        end

        function data = getFuncTreeData(~, matFileData)
            % Retrieves all the function hierarchy data from the loaded
            % .mat file.

            data = matFileData.functionTreeNodeData;
        end

        function data = getPropMetaData(obj, matFileData)
            % Retrieves all the property data from the loaded .mat file.
            % This function converts the data into a format accepted by the
            % client (DriverMetaDataAdapter).

            metaData = matFileData.propertyMetaData;
            data = getStructData(obj, metaData);
        end

        function saveRepCapInfo(obj, matFileData)
            % Retrieves the dynamic and static repeated capability data
            % from the loaded .mat file.
            % This function converts the retrieved data into a format
            % accepted by the client (DriverMetaDataAdapter).

            metaData = matFileData.staticRepCapMetaData;
            obj.StaticRepCapMetaData = getStructData(obj, metaData);

            metaData = matFileData.dynamicRepCapMetaData;
            obj.DynamicRepCapMetaData = getStructData(obj, metaData);
        end

        function savePropMatlabExamples(obj, matFileData)
            % Retrieves all the property ividev examples from the loaded
            % .mat file.

            obj.PropMExampleForm = matFileData.propMExampleForm;
        end
    end

    %% Helper function
    methods
        function structData = getStructData(~, metaData)
            % Takes metadata and converts into a struct array.

            structData = struct.empty;

            for data = metaData
                props = string(properties(data))';
                for prop = props
                    st.(prop) = data.(prop);
                end
                structData = [structData st]; %#ok<AGROW>
                st = [];
            end
        end
    end
end

