classdef (Hidden) ConfigStoreUtility < handle
    %ConfigStoreUtility class for IVI Configuration Store helper functions.
    %ConfigStoreUtility provides utility functions to search through IVI
    %configuration store and retrieve available IVI driver information
    %based on instrument type and resource.
    
    %    Copyright 2011-2022 The MathWorks, Inc.
    
    methods (Static)
        
        function  iviInstrumentDrivers = getIVIInstrumentDriversFromResource(instrumentType, resource)
            %based on the user input of instrument resource, find out the instrument model,
            %then find out the corresponding IVI driver name. if the model name is not valid,
            % provide a list of valid instrument model name.
            model = getModel(resource);
            if isempty(model)
                iviInstrumentDrivers = [];
                return;
            end
            
            % find out drivers which support that model
            iviInstrumentDrivers = {};
            installedIviInstrumentDrivers = instrument.internal.udm.ConfigStoreUtility.getInstalledIVIInstrumentDrivers(instrumentType);
            for idx = 1: size (installedIviInstrumentDrivers, 2)
                if isempty (installedIviInstrumentDrivers{idx}.SupportedInstrumentModels)
                    continue;
                end
                %parse the string to cell array
                models = textscan (installedIviInstrumentDrivers{idx}.SupportedInstrumentModels,  '%s', 'delimiter', ',');
                if find (ismember (models{1} , model))
                    iviInstrumentDrivers{end+1} = installedIviInstrumentDrivers{idx}; %#ok<*AGROW>
                end
            end
            
            if isempty (iviInstrumentDrivers)
                iviInstrumentDrivers = [];
                return;
            end
            
            
            
            function model = getModel(resource)
                % given resource name, query the instrument and return instrument
                % model.
                instrumentInfo = instrument.internal.udm.InstrumentUtility.queryInstrument(resource);
                
                loc= strfind(instrumentInfo, ',');
                if size (loc, 2 )> 1
                    %parse the return instrument ID string
                    model =  strtrim( instrumentInfo(loc(1)+1 : loc(2) -1));
                end
                
            end
            
        end
        
        function IviInstrumentDriver = getIviInstrumentDriver( instrumentType, driverName)
            %given driver name, check if it is a valid ivi instrument, if so,
            %return the driver
            IviInstrumentDriver = [];

            % IVIC is no longer the final element in the chain of
            % responsibility
            if driverName == "niRFSG"
                return
            end

            installedIviInstrumentDrivers = instrument.internal.udm.ConfigStoreUtility.getInstalledIVIInstrumentDrivers(instrumentType);
            for idx = 1: size (installedIviInstrumentDrivers, 2)
                if strcmpi (installedIviInstrumentDrivers{idx}.Name , driverName)
                    IviInstrumentDriver = installedIviInstrumentDrivers{idx};
                    return;
                end
            end
            
            if isempty (IviInstrumentDriver)
                error (message('instrument:qcinstrument:notValidIVIInstrumentDriver'));
            end
        end
        
        
        function IviInstrumentDrivers = getInstalledIVIInstrumentDrivers(instrumentType)
            % search in the ivi configuration store, find out iviscope drivers
            % and their types( ivic/ ivicom)
            
            %convert the type to ivi instrument type
            IviInstrumentType = sprintf('ivi%s',instrumentType);
            
            iviConfigStore = iviconfigurationstore ;
            softwareModules =  iviConfigStore.SoftwareModules;
            IviInstrumentDrivers = {};
            import instrument.internal.udm.*;
            for idx =1:length (softwareModules)
                
                IviInstrumentModule.Name ='';
                IviInstrumentModule.type = 0 ;
                IviInstrumentModule.SupportedInstrumentModels ='';
                
                %search for IVI instrument driver and driver type
                publishedAPIs = softwareModules(idx).PublishedAPIs;
                ivic = 0;
                ivicom = 0;
               
                for APIIdx = 1: length (publishedAPIs)
                    if strcmpi(publishedAPIs(APIIdx).Name, IviInstrumentType)
                        
                        %don't report the driver that only support 32 bit windows
                        if strcmpi (computer , 'PCWIN64') && isempty (iviConfigStore.SoftwareModules(idx).ModulePath)
                            continue;
                        end
                        IviInstrumentModule.Name= iviConfigStore.SoftwareModules(idx).Name;
                        IviInstrumentModule.SupportedInstrumentModels = iviConfigStore.SoftwareModules(idx).SupportedInstrumentModels;
                        
                        %get driver type ( ivi-c or ivi-com)
                        if strcmpi(publishedAPIs(APIIdx).APIType , 'ivi-c')
                            ivic = IVITypeEnum.IVIC;
                        end
                        if strcmpi (publishedAPIs(APIIdx).APIType, 'ivi-com')
                            ivicom = IVITypeEnum.IVICOM;
                        end
                     
                    end
                end
                
                % found ivi instrument module
                if ~isempty(IviInstrumentModule.Name)
                    
                    % An IVI instrument could ivi-c , ivicom or both
                    IviInstrumentModule.type =  bitor (ivicom , ivic) ;
                    if (IviInstrumentModule.type == 0 )
                        error (message('instrument:qcinstrument:notValidIVIInstrumentType'));
                    end
                    
                    % add it to the list
                    IviInstrumentDrivers{end+1} = IviInstrumentModule;
                end
                
            end
        end
        
        
        
        function addLogicalName( harewareAssetName, resource , sessionName, driverName, logicalName)
            
            try configStore = iviconfigurationstore;
                
                add(configStore, 'HardwareAsset', harewareAssetName, resource);
                
                % Add a driver Session to configStore.
                add(configStore, 'DriverSession', sessionName ,driverName, harewareAssetName);
                
                % Add a logical name to configStore.
                add(configStore, 'LogicalName', logicalName, sessionName);
                
                % Save the changes to the IVI configuration store.
                commit(configStore);
            catch e %#ok<*NASGU>
            end
            
        end
        
        
        function removeLogicalName(harewareAssetName, sessionName, logicalName)
            
            try
                configStore = iviconfigurationstore;
                
                remove(configStore, 'HardwareAsset', harewareAssetName);
                remove(configStore, 'DriverSession', sessionName  );
                remove(configStore, 'LogicalName', logicalName );
                commit(configStore);
            catch e
            end
        end
        
    end
end


