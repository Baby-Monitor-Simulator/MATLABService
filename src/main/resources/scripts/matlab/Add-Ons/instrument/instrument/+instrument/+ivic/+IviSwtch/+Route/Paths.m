classdef Paths < instrument.ivic.IviGroupBase
    %PATHS This class contains low level functions for getting
    %and setting paths
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function SetPath(obj,PathList)
            %SETPATH This function connects two channels by
            %establishing the exact path you specify with the pathList
            %parameter.  This function applies default values to
            %attributes that have not been set by the user under the
            %following conditions:  (1) If the user has not set the
            %value of any attribute in the IviSwtchScanner extension,
            %the following default values are used:
            %IVISWTCH_ATTR_SCAN_LIST            - "" (Empty string)
            %IVISWTCH_ATTR_TRIGGER_INPUT        - IVISWTCH_VAL_EXTERNAL
            %IVISWTCH_ATTR_SCAN_ADVANCED_OUTPUT - IVISWTCH_VAL_EXTERNAL
            %IVISWTCH_ATTR_SCAN_DELAY           - 0  Notes:  (1) This
            %function performs interchangeability checking when the
            %IVISWTCH_ATTR_INTERCHANGE_CHECK attribute is set to True.
            %If the IVISWTCH_ATTR_SPY attribute is set to True, you use
            %the NI Spy utility to view interchangeability warnings.
            %You use the IviSwtch_GetNextInterchangeWarning function to
            %retrieve interchangeability warnings when the
            %IVISWTCH_ATTR_SPY attribute is set to False.  For more
            %information about interchangeability checking, refer to the
            %help text for the IVISWTCH_ATTR_INTERCHANGE_CHECK
            %attribute.
            
            narginchk(2,2)
            PathList = obj.checkScalarStringArg(PathList);
            try
                [libname, session ] = obj.getLibraryAndSession();
                PathList = [double(PathList) 0];
                
                status = calllib( libname,'IviSwtch_SetPath', session, PathList);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Path = GetPath(obj,Channel1,Channel2,BufferSize)
            %GETPATH In some cases there is more than one possible path
            %between two channels. The driver or the instrument selects
            %the path when you connect two channels with the
            %IviSwtch_Connect function. Thus, you cannot guarantee that
            %every call to the IviSwtch_Connect function establishes
            %exactly the same path when you pass the same channels. This
            %function returns a string that uniquely identifies the path
            %you create with the IviSwtch_Connect function. You can pass
            %this string to the IviSwtch_SetPath function to establish
            %the exact same path in the future.  Note:  (1) This
            %function returns only those paths that you explicitly
            %create by calling IviSwtch_Connect and IviSwtch_SetPath
            %functions. For example, if you connect channels CH1 and
            %CH3,     and then channels CH2 and CH3, the explicit path
            %between     channels CH1 and Ch2 does not exist and this
            %function     returns an error.
            
            narginchk(4,4)
            Channel1 = obj.checkScalarStringArg(Channel1);
            Channel2 = obj.checkScalarStringArg(Channel2);
            BufferSize = obj.checkScalarInt32Arg(BufferSize);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Channel1 = [double(Channel1) 0];
                Channel2 = [double(Channel2) 0];
                Path = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviSwtch_GetPath', session, Channel1, Channel2, BufferSize, Path);
                
                Path = strtrim(char(Path.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
