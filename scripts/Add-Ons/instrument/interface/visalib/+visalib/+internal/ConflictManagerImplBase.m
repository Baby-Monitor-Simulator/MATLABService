classdef (Hidden) ConflictManagerImplBase < handle
    %ConflictManagerImplBase class for handling requests from the
    %ConflictManager. By default the operations are no-ops.
    %
    %    This undocumented class may be removed in a future release.
    
    %    Copyright 2020 The MathWorks, Inc.

    methods
        function obj = ConflictManagerImplBase(conflictManagerPath)
            arguments
                conflictManagerPath (1, 1) string
            end
  
            % By default, the conflict manager should not operate in test mode.          
            testMode = visalib.internal.TestModeManager.getTestMode();
            
            switch testMode
                case visalib.internal.VISAMode.NoVISAInstalled
                    conflictManagerMode = "NoVISAInstalled";
                case visalib.internal.VISAMode.Test
                    conflictManagerMode = "Test";
                case visalib.internal.VISAMode.NoResources
                    conflictManagerMode = "Test";
                case visalib.internal.VISAMode.Normal
                    conflictManagerMode = "Normal";
            end            

            obj.TestMode = testMode;
            obj.ConflictManagerPath = conflictManagerPath;            
            obj.ConflictManagerMode = conflictManagerMode;
        end
    end
    
    methods
        function loadConflictManager(obj)  %#ok<MANU>
            % Loads the VISA ConflictManager on platforms for which it is
            % available.
            
            % does nothing (default)
        end
        
        function unloadConflictManager(obj) %#ok<MANU>
            % Unloads the VISA ConflictManager on platforms for which it is
            % available
            
            % does nothing (default)
        end
        
        function numInstallations = getNumVisaInstallations(obj) %#ok<MANU>
            % Returns the number of visa installations tracked by the VISA
            % Conflict Manager. The loadConflictManager method must be
            % called prior to calling this method.
            
            numInstallations = 0;
        end
        
        function info = getVisaInstallationInfo(obj) %#ok<MANU>
            % Returns information about all visa installations tracked by
            % the VISA Conflict Manager (on platforms for which this
            % service is available). The getNumVisaInstallations method
            % must be called prior to calling this method.
            
            % By convention, the size of empty installation is (1x0)
            % (because that's what is returned from the device plugin)
            info = struct("Index", cell(1, 0),...
                          "ID", [], ...
                          "Preferred", false, ...
                          "GUID", strings(0), ...
                          "Name", strings(0));
        end
        
        function preferredVISA = getPreferredVisa(obj)
            % Returns the ID of the preferred VISA installation as tracked
            % by the VISA Conflict Manager (on platforms for which this
            % service is available).
            
            info = obj.getVisaInstallationInfo();
            if ~isempty(info)
                preferred = [info.Preferred];
                preferredVISA = info(preferred).Name;
            else
                preferredVISA = strings(0);
            end
        end
        
        function visaForResource = findVisaForResource(obj, interfaceType, interfaceNum, resourceType) %#ok<INUSD>
            % Returns the name of the VISA associated with a particular
            % interface type and number, as determined by the VISA Conflict
            % Manager (on platforms for which this service is available).            
            
            visaForResource = obj.getPreferredVisa();
        end
    end
    
    methods (Static, Access = protected)
        function checkPlatform(platform)
            arguments
                platform (1, 1) string
            end
            
            if string(computer('arch')) ~= platform
                throw(MException(message("instrument:interface:visa:codeDoesNotMatchPlatform", platform, computer('arch'))));
            end            
        end
    end
    
    properties (GetAccess = protected, SetAccess = private)
        % Mode set by the test mode manager        
        TestMode
        % Path to the VISA Conflict Manager (typically a relative path or
        % simply the name of the file indicated in the VISA Shared
        % Components specification).
        ConflictManagerPath
        % ConflictManager mode corresponding to the TestMode
        ConflictManagerMode
    end
end

