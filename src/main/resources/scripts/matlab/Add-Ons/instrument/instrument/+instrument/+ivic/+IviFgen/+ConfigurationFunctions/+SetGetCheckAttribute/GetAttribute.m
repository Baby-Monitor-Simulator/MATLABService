classdef GetAttribute < instrument.ivic.IviGroupBase
    %GETATTRIBUTE This class contains functions that obtain the
    %current value of an attribute.  There are typesafe
    %functions for each attribute data type.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function AttributeValue = GetAttributeViInt32(obj,ChannelName,AttributeID)
            %GETATTRIBUTEVIINT32 This function queries the value of a
            %ViInt32 attribute.  This is a low-level function that you
            %can use to get the values of inherent IVI attributes, class
            %defined attributes, and instrument-specific attributes. If
            %the attribute represents an instrument state, this function
            %performs instrument I/O in the following cases:  - State
            %caching is disabled for the entire session or for the
            %particular attribute.  - State caching is enabled and the
            %currently cached value is invalid.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            AttributeID = obj.checkScalarInt64Arg(AttributeID);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                AttributeValue = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviFgen_GetAttributeViInt32', session, ChannelName, AttributeID, AttributeValue);
                
                AttributeValue = AttributeValue.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function AttributeValue = GetAttributeViReal64(obj,ChannelName,AttributeID)
            %GETATTRIBUTEVIREAL64 This function queries the value of a
            %ViReal64 attribute.  This is a low-level function that you
            %can use to get the values of inherent IVI attributes, class
            %defined attributes, and instrument-specific attributes. If
            %the attribute represents an instrument state, this function
            %performs instrument I/O in the following cases:  - State
            %caching is disabled for the entire session or for the
            %particular attribute.  - State caching is enabled and the
            %currently cached value is invalid.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            AttributeID = obj.checkScalarInt64Arg(AttributeID);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                AttributeValue = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviFgen_GetAttributeViReal64', session, ChannelName, AttributeID, AttributeValue);
                
                AttributeValue = AttributeValue.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function AttributeValue = GetAttributeViString(obj,ChannelName,AttributeID,BufferSize)
            %GETATTRIBUTEVISTRING This function queries the value of a
            %ViString attribute.  This is a low-level function that you
            %can use to get the values of inherent IVI attributes, class
            %defined attributes, and instrument-specific attributes. If
            %the attribute represents an instrument state, this function
            %performs instrument I/O in the following cases:  - State
            %caching is disabled for the entire session or for the
            %particular attribute.  - State caching is enabled and the
            %currently cached value is invalid.   You must provide a
            %ViChar array to serve as a buffer for the value. You pass
            %the number of bytes in the buffer as the Buffer Size
            %parameter. If the current value of the attribute, including
            %the terminating NUL byte, is larger than the size you
            %indicate in the Buffer Size parameter, the function copies
            %Buffer Size-1 bytes into the buffer, places an ASCII NUL
            %byte at the end of the buffer, and returns the buffer size
            %you must pass to get the entire value. For example, if the
            %value is "123456" and the Buffer Size is 4, the function
            %places "123" into the buffer and returns 7.  If you want to
            %call this function just to get the required buffer size,
            %you can pass 0 for the Buffer Size and VI_NULL for the
            %Attribute Value buffer.    If you want the function to fill
            %in the buffer regardless of the number of bytes in the
            %value, pass a negative number for the Buffer Size parameter.
            
            narginchk(4,4)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            AttributeID = obj.checkScalarInt64Arg(AttributeID);
            BufferSize = obj.checkScalarInt32Arg(BufferSize);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                AttributeValue = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviFgen_GetAttributeViString', session, ChannelName, AttributeID, BufferSize, AttributeValue);
                
                AttributeValue = strtrim(char(AttributeValue.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function AttributeValue = GetAttributeViBoolean(obj,ChannelName,AttributeID)
            %GETATTRIBUTEVIBOOLEAN This function queries the value of a
            %ViBoolean attribute.  This is a low-level function that you
            %can use to get the values of inherent IVI attributes, class
            %defined attributes, and instrument-specific attributes. If
            %the attribute represents an instrument state, this function
            %performs instrument I/O in the following cases:  - State
            %caching is disabled for the entire session or for the
            %particular attribute.  - State caching is enabled and the
            %currently cached value is invalid.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            AttributeID = obj.checkScalarInt64Arg(AttributeID);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                AttributeValue = libpointer('uint16Ptr', 0);
                
                status = calllib( libname,'IviFgen_GetAttributeViBoolean', session, ChannelName, AttributeID, AttributeValue);
                
                AttributeValue = AttributeValue.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function AttributeValue = GetAttributeViSession(obj,ChannelName,AttributeID)
            %GETATTRIBUTEVISESSION This function queries the value of a
            %session attribute.  This is a low-level function that you
            %can use to get the values of inherent IVI attributes, class
            %defined attributes, and instrument-specific attributes. If
            %the attribute represents an instrument state, this function
            %performs instrument I/O in the following cases:  - State
            %caching is disabled for the entire session or for the
            %particular attribute.  - State caching is enabled and the
            %currently cached value is invalid.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            AttributeID = obj.checkScalarInt64Arg(AttributeID);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                AttributeValue = libpointer('uint32Ptr', 0);
                
                status = calllib( libname,'IviFgen_GetAttributeViSession', session, ChannelName, AttributeID, session);
                
                AttributeValue = AttributeValue.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
