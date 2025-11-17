classdef Utility < instrument.ivic.IviGroupBase
    %UTILITY This class contains functions and sub-classes that
    %control common instrument operations.  These functions
    %include many of functions that VXIplug&play require, such
    %as reset, self-test, revision query, error query, and error
    %message.  This class also contains functions that access
    %IVI error information, lock the session, and perform
    %instrument I/O.
    
    % Copyright 2010-2020 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = Utility()
            %% Initialize properties
            obj.ErrorInfo = instrument.ivic.IviDmm.Utility.ErrorInfo();
            obj.InterchangeabilityInfo = instrument.ivic.IviDmm.Utility.InterchangeabilityInfo();
            obj.CoercionInfo = instrument.ivic.IviDmm.Utility.CoercionInfo();
            obj.Locking = instrument.ivic.IviDmm.Utility.Locking();
        end
        
        function delete(obj)
            obj.Locking = [];
            obj.CoercionInfo = [];
            obj.InterchangeabilityInfo = [];
            obj.ErrorInfo = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.Locking.setLibraryAndSession(libName, session);
            obj.CoercionInfo.setLibraryAndSession(libName, session);
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
        
        %COERCIONINFO This class contains functions that retrieve
        %coercion records. Read Only.
        CoercionInfo
        
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
                obj.ErrorInfo = instrument.ivic.IviDmm.Utility.ErrorInfo();
            end
            value = obj.ErrorInfo;
        end
        
        %% InterchangeabilityInfo property access methods
        function value = get.InterchangeabilityInfo(obj)
            if isempty(obj.InterchangeabilityInfo)
                obj.InterchangeabilityInfo = instrument.ivic.IviDmm.Utility.InterchangeabilityInfo();
            end
            value = obj.InterchangeabilityInfo;
        end
        
        %% CoercionInfo property access methods
        function value = get.CoercionInfo(obj)
            if isempty(obj.CoercionInfo)
                obj.CoercionInfo = instrument.ivic.IviDmm.Utility.CoercionInfo();
            end
            value = obj.CoercionInfo;
        end
        
        %% Locking property access methods
        function value = get.Locking(obj)
            if isempty(obj.Locking)
                obj.Locking = instrument.ivic.IviDmm.Utility.Locking();
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
                
                status = calllib( libname,'IviDmm_reset', session);
                
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
                
                status = calllib( libname,'IviDmm_ResetWithDefaults', session);
                
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
                
                status = calllib( libname,'IviDmm_self_test', session, SelfTestResult, SelfTestMessage);
                
                SelfTestResult = SelfTestResult.Value;
                SelfTestMessage = strtrim(char(SelfTestMessage.Value));
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
                
                status = calllib( libname,'IviDmm_Disable', session);
                
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
                
                status = calllib( libname,'IviDmm_InvalidateAllAttributes', session);
                
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
                
                status = calllib( libname,'IviDmm_revision_query', session, InstrumentDriverRevision, FirmwareRevision);
                
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
                
                status = calllib( libname,'IviDmm_error_query', session, ErrorCode, ErrorMessage);
                
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
                
                status = calllib( libname,'IviDmm_error_message', session, ErrorCode, ErrorMessage);
                
                ErrorMessage = strtrim(char(ErrorMessage.Value));
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
                
                status = calllib( libname,'IviDmm_GetSpecificDriverCHandle', session, SpecificDriverCHandle);
                
                SpecificDriverCHandle = SpecificDriverCHandle.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
