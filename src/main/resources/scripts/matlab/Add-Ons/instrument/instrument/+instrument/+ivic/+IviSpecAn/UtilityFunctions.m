classdef UtilityFunctions < instrument.ivic.IviGroupBase
    %UTILITYFUNCTIONS This class contains functions and
    %sub-classes that control common instrument operations.
    %These functions include many of functions that VXIplug&play
    %require, such as reset, self-test, revision query, error
    %query, and error message.  This class also contains
    %functions that access IVI error information, lock the
    %session, and perform instrument I/O.
    
    % Copyright 2010-2020 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = UtilityFunctions()
            %% Initialize properties
            obj.ErrorInfo = instrument.ivic.IviSpecAn.UtilityFunctions.ErrorInfo();
            obj.InterchangeabilityInfo = instrument.ivic.IviSpecAn.UtilityFunctions.InterchangeabilityInfo();
            obj.Locking = instrument.ivic.IviSpecAn.UtilityFunctions.Locking();
        end
        
        function delete(obj)
            obj.Locking = [];
            obj.InterchangeabilityInfo = [];
            obj.ErrorInfo = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.Locking.setLibraryAndSession(libName, session);
            obj.InterchangeabilityInfo.setLibraryAndSession(libName, session);
            obj.ErrorInfo.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %ERRORINFO This class contains functions that retrieve and
        %clear the IVI error information. Read Only.
        ErrorInfo
        
        %INTERCHANGEABILITYINFO This class contains functions that
        %retrieve interchangeability warnings. Read Only.
        InterchangeabilityInfo
        
        %LOCKING This class contains functions that lock and unlock
        %IVI instrument driver sessions for multithread safefy. Read
        %Only.
        Locking
    end
    
    %% Property access methods
    methods
        %% ErrorInfo property access methods
        function value = get.ErrorInfo(obj)
            if isempty(obj.ErrorInfo)
                obj.ErrorInfo = instrument.ivic.IviSpecAn.UtilityFunctions.ErrorInfo();
            end
            value = obj.ErrorInfo;
        end
        
        %% InterchangeabilityInfo property access methods
        function value = get.InterchangeabilityInfo(obj)
            if isempty(obj.InterchangeabilityInfo)
                obj.InterchangeabilityInfo = instrument.ivic.IviSpecAn.UtilityFunctions.InterchangeabilityInfo();
            end
            value = obj.InterchangeabilityInfo;
        end
        
        %% Locking property access methods
        function value = get.Locking(obj)
            if isempty(obj.Locking)
                obj.Locking = instrument.ivic.IviSpecAn.UtilityFunctions.Locking();
            end
            value = obj.Locking;
        end
    end
    
    %% Public Methods
    methods
        function reset(obj)
            %RESET This function resets the instrument to a known state
            %and sends initialization commands to the instrument.  The
            %initialization commands set instrument settings such as
            %Headers Off, Short Command form, and Data Transfer Binary
            %to the state necessary for the operation of the instrument
            %driver.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_reset', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ResetWithDefaults(obj)
            %RESETWITHDEFAULTS This function resets the instrument and
            %applies initial user specified settings from the Logical
            %Name which was used to initialize the session.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ResetWithDefaults', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Disable(obj)
            %DISABLE This function places the instrument in a quiescent
            %state where it has minimal or no impact on the system to
            %which it is connected.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_Disable', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function [SelfTestResult,SelfTestMessage] = self_test(obj)
            %SELF_TEST This function runs the instrument's self test
            %routine and returns the test result(s).
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                SelfTestResult = libpointer('int16Ptr', 0);
                SelfTestMessage = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviSpecAn_self_test', session, SelfTestResult, SelfTestMessage);
                
                SelfTestResult = SelfTestResult.Value;
                SelfTestMessage = strtrim(char(SelfTestMessage.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function [InstrumentDriverRevision,FirmwareRevision] = revision_query(obj)
            %REVISION_QUERY This function returns the revision numbers
            %of the instrument driver and instrument firmware.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                InstrumentDriverRevision = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                FirmwareRevision = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviSpecAn_revision_query', session, InstrumentDriverRevision, FirmwareRevision);
                
                InstrumentDriverRevision = strtrim(char(InstrumentDriverRevision.Value));
                FirmwareRevision = strtrim(char(FirmwareRevision.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function [ErrorCode,ErrorMessage] = error_query(obj)
            %ERROR_QUERY This function reads an error code and a
            %message from the instrument's error queue.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                ErrorCode = libpointer('int32Ptr', 0);
                ErrorMessage = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviSpecAn_error_query', session, ErrorCode, ErrorMessage);
                
                ErrorCode = ErrorCode.Value;
                ErrorMessage = strtrim(char(ErrorMessage.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ErrorMessage = error_message(obj,ErrorCode)
            %ERROR_MESSAGE This function converts a status code
            %returned by an instrument driver function into a
            %user-readable string.
            
            narginchk(2,2)
            ErrorCode = obj.checkScalarInt32Arg(ErrorCode);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ErrorMessage = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviSpecAn_error_message', session, ErrorCode, ErrorMessage);
                
                ErrorMessage = strtrim(char(ErrorMessage.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function InvalidateAllAttributes(obj)
            %INVALIDATEALLATTRIBUTES This function invalidates the
            %cached values of all attributes for the session.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_InvalidateAllAttributes', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SpecificDriverCHandle = GetSpecificDriverCHandle(obj)
            %GETSPECIFICDRIVERCHANDLE This function returns the C
            %session instrument handle you use to call the specific
            %driver's functions.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                SpecificDriverCHandle = libpointer('uint32Ptr', 0);
                
                status = calllib( libname,'IviSpecAn_GetSpecificDriverCHandle', session, SpecificDriverCHandle);
                
                SpecificDriverCHandle = SpecificDriverCHandle.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function CoercionRecord = GetNextCoercionRecord(obj,BufferSize)
            %GETNEXTCOERCIONRECORD This function returns the coercion
            %information associated with the IVI session.  This function
            %retrieves and clears the oldest instance in which the
            %instrument driver coerced a value you specified to another
            %value.  If you set the IVISPECAN_ATTR_RECORD_COERCIONS
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
                
                status = calllib( libname,'IviSpecAn_GetNextCoercionRecord', session, BufferSize, CoercionRecord);
                
                CoercionRecord = strtrim(char(CoercionRecord.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
