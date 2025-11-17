classdef (Hidden, Sealed) ConflictManager < handle
    %ConflictManager Static class used to manage the lifetime of the
    %channel used to issue commands/queries to the VISA Conflict Manager
    %
    %    This undocumented class may be removed in a future release.
    
    % To fully initialize the conflict manager, the following method calls
    % are required:
    %
    % 1. loadConflictManager
    % 2. getNumVisaInstallations
    % 3. getVisaInstallationInfo
    % ...
    % N. unloadConflictManager
    
    %    Copyright 2020 The MathWorks, Inc.
    
    methods(Hidden, Static)
        function impl = getInstance()
            impl = visalib.internal.ManagerImplFactory.getConflictManagerImpl();
        end
        
        function releaseInstance()
            visalib.internal.ManagerImplFactory.releaseInstance();
        end
    end    
    
    % Don't hide these (tab-completion is helpful)
    methods (Static)
        function loadConflictManager          
            visalib.internal.ConflictManager.getInstance().loadConflictManager();
        end
        
        function unloadConflictManager
            visalib.internal.ConflictManager.getInstance().unloadConflictManager();
        end
        
        function numInstallations = getNumVisaInstallations
            % Returns the number of visa installations tracked by the VISA
            % Conflict Manager. The loadConflictManager method must be
            % called prior to calling this method.
            numInstallations = visalib.internal.ConflictManager.getInstance().getNumVisaInstallations();
        end
        
        function info = getVisaInstallationInfo
            % Returns information about all visa installations tracked by
            % the VISA Conflict Manager. The getNumVisaInstallations method
            % must be called prior to calling this method.
            
            info = visalib.internal.ConflictManager.getInstance().getVisaInstallationInfo();
        end
        
        function preferredVISA = getPreferredVisa
            % Returns the ID of the preferred VISA installation as tracked
            % by the VISA Conflict Manager.
            preferredVISA = visalib.internal.ConflictManager.getInstance().getPreferredVisa();
        end
        
        function visaForResource = findVisaForResource(interfaceType, interfaceNum, resourceType)
            % Returns the name of the VISA associated with a particular
            % interface type and number, as determined by the VISA Conflict
            % Manager.
            
            arguments
                interfaceType (1, 1) uint16
                interfaceNum (1, 1) uint16
                resourceType (1, 1) string
            end
            
            visaForResource = visalib.internal.ConflictManager.getInstance().findVisaForResource(interfaceType, interfaceNum, resourceType);
        end
    end    
end
