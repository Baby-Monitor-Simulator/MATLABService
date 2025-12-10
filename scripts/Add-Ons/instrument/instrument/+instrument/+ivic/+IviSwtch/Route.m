classdef Route < instrument.ivic.IviGroupBase
    %ROUTE This class contains functions and classes that
    %initiate instrument operations and report their status.
    %Functions/SubClasses:
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = Route()
            %% Initialize properties
            obj.Paths = instrument.ivic.IviSwtch.Route.Paths();
        end
        
        function delete(obj)
            obj.Paths = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.Paths.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %PATHS This class contains low level functions for getting
        %and setting paths Read Only.
        Paths
    end
    
    %% Property access methods
    methods
        %% Paths property access methods
        function value = get.Paths(obj)
            if isempty(obj.Paths)
                obj.Paths = instrument.ivic.IviSwtch.Route.Paths();
            end
            value = obj.Paths;
        end
    end
    
    %% Public Methods
    methods
        function Connect(obj,Channel1,Channel2)
            %CONNECT This function creates a path between Channel 1 and
            %Channel 2.  The driver calculates the shortest path between
            %the two channels.  If a path is not available, the function
            %returns one of the following errors:
            %IVISWTCH_ERROR_EXPLICIT_CONNECTION_EXISTS, if the two
            %channels                   are already explicitly connected
            %by calling                   either the IviSwtch_Connect or
            %                   IviSwtch_SetPath function.
            %IVISWTCH_ERROR_IS_CONFIGURATION_CHANNEL, if a channel is a
            %                 configuration channel.  Error elaboration
            %                 contains information about which of the
            %two                   channels is a configuration channel.
            %IVISWTCH_ERROR_ATTEMPT_TO_CONNECT_SOURCES, if both channels
            %are                   connected to a different source.
            %Error                   elaboration contains information
            %about sources                   to which channel 1 and 2
            %connect.
            %IVISWTCH_ERROR_CANNOT_CONNECT_TO_ITSELF, if channels 1 and
            %2 are                   one and the same channel.
            %IVISWTCH_ERROR_PATH_NOT_FOUND, if the driver cannot find a
            %path                   between the two channels.  This
            %function applies default values to attributes that have not
            %been set by the user under the following conditions:  (1)
            %If the user has not set the value of any attribute in the
            %IviSwtchScanner extension,  the following default values
            %are used:  IVISWTCH_ATTR_SCAN_LIST            - "" (Empty
            %string) IVISWTCH_ATTR_TRIGGER_INPUT        -
            %IVISWTCH_VAL_EXTERNAL IVISWTCH_ATTR_SCAN_ADVANCED_OUTPUT -
            %IVISWTCH_VAL_EXTERNAL IVISWTCH_ATTR_SCAN_DELAY           -
            %0  Notes:  (1) The paths are bidirectional. For example, if
            %a path exists     from channel CH1 to CH2, then a path from
            %channel     CH2 to CH1 also exists.  (2) This function
            %performs interchangeability checking when the
            %IVISWTCH_ATTR_INTERCHANGE_CHECK attribute is set to True.
            %If the IVISWTCH_ATTR_SPY attribute is set to True, you use
            %the NI Spy utility to view interchangeability warnings.
            %You use the IviSwtch_GetNextInterchangeWarning function to
            %retrieve interchangeability warnings when the
            %IVISWTCH_ATTR_SPY attribute is set to False.  For more
            %information about interchangeability checking, refer to the
            %help text for the IVISWTCH_ATTR_INTERCHANGE_CHECK
            %attribute.
            
            narginchk(3,3)
            Channel1 = obj.checkScalarStringArg(Channel1);
            Channel2 = obj.checkScalarStringArg(Channel2);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Channel1 = [double(Channel1) 0];
                Channel2 = [double(Channel2) 0];
                
                status = calllib( libname,'IviSwtch_Connect', session, Channel1, Channel2);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Disconnect(obj,Channel1,Channel2)
            %DISCONNECT This function destroys the path between two
            %channels that you create with the IviSwtch_Connect or
            %IviSwtch_SetPath function.
            
            narginchk(3,3)
            Channel1 = obj.checkScalarStringArg(Channel1);
            Channel2 = obj.checkScalarStringArg(Channel2);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Channel1 = [double(Channel1) 0];
                Channel2 = [double(Channel2) 0];
                
                status = calllib( libname,'IviSwtch_Disconnect', session, Channel1, Channel2);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function DisconnectAll(obj)
            %DISCONNECTALL This function disconnects all existing
            %paths.  Note: If the switch module is not capable of
            %disconnecting all paths, this function returns the warning
            %IVISWTCH_WARN_PATH_REMAINS.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSwtch_DisconnectAll', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function IsDebounced = IsDebounced(obj)
            %ISDEBOUNCED This function returns a value that indicates
            %whether all the paths that you previously created have
            %settled.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                IsDebounced = libpointer('uint16Ptr', 0);
                
                status = calllib( libname,'IviSwtch_IsDebounced', session, IsDebounced);
                
                IsDebounced = IsDebounced.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function WaitForDebounce(obj,MaximumTimems)
            %WAITFORDEBOUNCE Calling this function causes the driver to
            %return process control back to the user only after all the
            %paths that you previouslt created have settled.
            
            narginchk(2,2)
            MaximumTimems = obj.checkScalarInt32Arg(MaximumTimems);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSwtch_WaitForDebounce', session, MaximumTimems);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function PathCapability = CanConnect(obj,Channel1,Channel2)
            %CANCONNECT This function verifies that the switch module
            %is capable of creating a path between the two channels you
            %specify with the Channel 1 and Channel 2 parameters.  If
            %the switch module is capable of creating a path, this
            %function indicates whether the path is currently available
            %given the existing connections.  If the path is not
            %available due to currently existing connections, but the
            %implicit connection between the two channels already
            %exists, the function returns the warning
            %IVISWTCH_WARN_IMPLICIT_CONNECTION_EXISTS.
            
            narginchk(3,3)
            Channel1 = obj.checkScalarStringArg(Channel1);
            Channel2 = obj.checkScalarStringArg(Channel2);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Channel1 = [double(Channel1) 0];
                Channel2 = [double(Channel2) 0];
                PathCapability = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviSwtch_CanConnect', session, Channel1, Channel2, PathCapability);
                
                PathCapability = PathCapability.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
