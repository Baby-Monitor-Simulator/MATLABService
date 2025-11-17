classdef CoercionInfo < instrument.ivic.IviGroupBase
    %COERCIONINFO This class contains functions that retrieve
    %coercion records.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function CoercionRecord = GetNextCoercionRecord(obj,BufferSize)
            %GETNEXTCOERCIONRECORD This function returns the coercion
            %information associated with the IVI session.  This function
            %retrieves and clears the oldest instance in which the
            %instrument driver coerced a value you specified to another
            %value.  If you set the IVIDCPWR_ATTR_RECORD_COERCIONS
            %attribute to True, the instrument driver keeps a list of
            %all coercions it makes on ViInt32 or ViReal64 values you
            %pass to instrument driver functions.  You use this function
            %to retrieve information from that list.  If the next
            %coercion record string, including the terminating NUL byte,
            %contains more bytes than you indicate in this parameter,
            %the function copies Buffer Size - 1 bytes into the buffer,
            %places an ASCII NUL byte at the end of the buffer, and
            %returns the buffer size you must pass to get the entire
            %value.  For example, if the value is "123456" and the
            %Buffer Size is 4, the function places "123" into the buffer
            %and returns 7.  If you pass a negative number, the function
            %copies the value to the buffer regardless of the number of
            %bytes in the value.  If you pass 0, you can pass VI_NULL
            %for the Coercion Record buffer parameter.  The function
            %returns an empty string in the Coercion Record parameter if
            %no coercion records remain for the session.
            
            narginchk(2,2)
            BufferSize = obj.checkScalarInt32Arg(BufferSize);
            try
                [libname, session ] = obj.getLibraryAndSession();
                CoercionRecord = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviDCPwr_GetNextCoercionRecord', session, BufferSize, CoercionRecord);
                
                CoercionRecord = strtrim(char(CoercionRecord.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
