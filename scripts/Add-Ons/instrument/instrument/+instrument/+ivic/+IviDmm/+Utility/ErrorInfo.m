classdef ErrorInfo < instrument.ivic.IviGroupBase
    %ERRORINFO This class contains functions that retrieve and
    %clear the IVI error information.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function [Code,Description] = GetError(obj,BufferSize)
            %GETERROR This function retrieves and then clears the IVI
            %error information for the session or the current execution
            %thread. One exception exists: If the BufferSize parameter
            %is 0, the function does not clear the error information. By
            %passing 0 for the buffer size, the caller can ascertain the
            %buffer size required to get the entire error description
            %string and then call the function again with a sufficiently
            %large buffer.  If the user specifies a valid IVI session
            %for the InstrumentHandle parameter, Get Error retrieves and
            %then clears the error information for the session.  If the
            %user passes VI_NULL for the InstrumentHandle parameter,
            %this function retrieves and then clears the error
            %information for the current execution thread.  If the
            %InstrumentHandle parameter is an invalid session, the
            %function does nothing and returns an error. Normally, the
            %error information describes the first error that occurred
            %since the user last called IviDmm_GetError or
            %IviDmm_ClearError.
            
            narginchk(2,2)
            BufferSize = obj.checkScalarInt32Arg(BufferSize);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Code = libpointer('int32Ptr', 0);
                Description = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviDmm_GetError', session, Code, BufferSize, Description);
                
                Code = Code.Value;
                Description = strtrim(char(Description.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ClearError(obj)
            %CLEARERROR This function clears the error code and error
            %description for the IVI session. If the user specifies a
            %valid IVI session for the instrumenthandle parameter, this
            %function clears the error information for the session. If
            %the user passes VI_NULL for the Vi parameter, this function
            %clears the error information for the current execution
            %thread. If the Vi parameter is an invalid session, the
            %function does nothing and returns an error. The function
            %clears the error code by setting it to VI_SUCCESS.  If the
            %error description string is non-NULL, the function
            %de-allocates the error description string and sets the
            %address to VI_NULL.  Maintaining the error information
            %separately for each thread is useful if the user does not
            %have a session handle to pass to the IviDmm_GetError
            %function, which occurs when a call to IviDmm_init or
            %IviDmm_InitWithOptions fails.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDmm_ClearError', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
