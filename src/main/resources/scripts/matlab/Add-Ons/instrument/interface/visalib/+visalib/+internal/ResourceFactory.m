classdef ResourceFactory < handle
    %RESOURCEFACTORY Factory for producing specific and unique resource
    %instances

    %   Copyright 2020-2021 The MathWorks, Inc.
    
    methods (Hidden, Static)
        function value = getInstance(createNewAsNeeded)
            % Singleton for the ResourceManager factory.
            
            persistent instance;
            
            narginchk(0, 1)

            % createNewAsNeeded should be set to false if calling 
            % delete(getInstance); otherwise, don't set it
            if nargin == 0
                createNewAsNeeded = true;
            end
        
            if isempty(instance) || ~isvalid(instance) && createNewAsNeeded
                instance = visalib.internal.ResourceFactory();
            end
            value = instance;
        end
        
        function releaseInstance()
            % Delete the single instance.
            try
                delete(visalib.internal.ResourceFactory.getInstance(false));
            catch e %#ok<NASGU>
                % Ignore all errors that occur during deletion
            end
        end
    end
    
    methods
        function dev = createAndRegisterVisaResource(obj, type, resourceInfo, synchronousRead)
            arguments
                obj (1, 1) visalib.internal.ResourceFactory
                type (1, 1) visalib.InterfaceType
                resourceInfo (1, 1) visalib.internal.ResourceInfo
                synchronousRead (1, 1) logical = false
            end
            
            if any(obj.ResourceList == upper(resourceInfo.Name))
                ex = visalib.internal.ErrorProxy.getVisaException(...
                    "multipleIdenticalResources",...
                    upper(resourceInfo.Name));
                mExcept = matlabshared.transportlib.internal.client.GenericClient.throwConnectionError(obj.Interface, ex);
                throwAsCaller(mExcept);
            end            
            
            switch type
                case visalib.InterfaceType.gpib
                    dev = visalib.GPIB(resourceInfo, synchronousRead);
                case visalib.InterfaceType.vxi
                    dev = visalib.VXI(resourceInfo, synchronousRead);
                case visalib.InterfaceType.serial
                    dev = visalib.Serial(resourceInfo, synchronousRead);
                case visalib.InterfaceType.pxi
                    dev = visalib.PXI(resourceInfo, synchronousRead);
                case visalib.InterfaceType.tcpip
                    dev = visalib.TCPIP(resourceInfo, synchronousRead);
                case visalib.InterfaceType.usb
                    dev = visalib.USB(resourceInfo, synchronousRead);
                case visalib.InterfaceType.socket
                    dev = visalib.Socket(resourceInfo, synchronousRead);
                otherwise
                    ex = visalib.internal.ErrorProxy.getVisaException(...
                        "unableToDetermineInterfaceType");
                    mExcept = matlabshared.transportlib.internal.client.GenericClient.throwConnectionError(obj.Interface, ex);
                    throwAsCaller(mExcept);
            end
            
            obj.ResourceList(end+1) = upper(resourceInfo.Name);
        end
        
        function unregisterVisaResource(obj, resourceName)
            matches = (obj.ResourceList == upper(resourceName));            
            if ~isempty(matches)
                obj.ResourceList(matches) = [];
            end
        end
        
        function unregisterAllResources(obj)
            obj.ResourceList = string.empty;
        end        
    end
    
    methods (Access = private)
        function obj = ResourceFactory()
        end
    end
    
    properties (Access = private)
        % List of all resources that have been created (and haven't been
        % removed)
        ResourceList string = string.empty
    end

    properties (Constant, Access = private)
        % Name of the interface that will be provided to throw connect errors
        Interface = "visadev"
    end
end