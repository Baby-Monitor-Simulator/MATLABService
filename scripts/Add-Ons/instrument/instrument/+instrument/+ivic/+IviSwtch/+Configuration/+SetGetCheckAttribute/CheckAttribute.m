classdef CheckAttribute < instrument.ivic.IviGroupBase
    %CHECKATTRIBUTE This class contains functions that obtain
    %the current value of an attribute.  There are typesafe
    %functions for each attribute data type.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function CheckAttributeViInt32(obj,ChannelName,AttributeID,AttributeValue)
            %CHECKATTRIBUTEVIINT32 This function checks the validity of
            %a value you specify for a ViInt32 attribute.
            
            narginchk(4,4)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            AttributeID = obj.checkScalarInt64Arg(AttributeID);
            AttributeValue = obj.checkScalarInt32Arg(AttributeValue);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviSwtch_CheckAttributeViInt32', session, ChannelName, AttributeID, AttributeValue);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function CheckAttributeViReal64(obj,ChannelName,AttributeID,AttributeValue)
            %CHECKATTRIBUTEVIREAL64 This function checks the validity
            %of a value you specify for a ViReal64 attribute.
            
            narginchk(4,4)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            AttributeID = obj.checkScalarInt64Arg(AttributeID);
            AttributeValue = obj.checkScalarDoubleArg(AttributeValue);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviSwtch_CheckAttributeViReal64', session, ChannelName, AttributeID, AttributeValue);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function CheckAttributeViString(obj,ChannelName,AttributeID,AttributeValue)
            %CHECKATTRIBUTEVISTRING This function checks the validity
            %of a value you specify for a ViString attribute.
            
            narginchk(4,4)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            AttributeID = obj.checkScalarInt64Arg(AttributeID);
            AttributeValue = obj.checkScalarStringArg(AttributeValue);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                AttributeValue = [double(AttributeValue) 0];
                
                status = calllib( libname,'IviSwtch_CheckAttributeViString', session, ChannelName, AttributeID, AttributeValue);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function CheckAttributeViBoolean(obj,ChannelName,AttributeID,AttributeValue)
            %CHECKATTRIBUTEVIBOOLEAN This function checks the validity
            %of a value you specify for a ViBoolean attribute.
            
            narginchk(4,4)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            AttributeID = obj.checkScalarInt64Arg(AttributeID);
            AttributeValue = obj.checkScalarBoolArg(AttributeValue);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviSwtch_CheckAttributeViBoolean', session, ChannelName, AttributeID, AttributeValue);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function CheckAttributeViSession(obj,ChannelName,AttributeID)
            %CHECKATTRIBUTEVISESSION This function checks the validity
            %of a value you specify for a session attribute.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            AttributeID = obj.checkScalarInt64Arg(AttributeID);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviSwtch_CheckAttributeViSession', session, ChannelName, AttributeID, session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
