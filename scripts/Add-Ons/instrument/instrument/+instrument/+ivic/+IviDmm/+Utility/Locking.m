classdef Locking < instrument.ivic.IviGroupBase
    %LOCKING This class contains functions that lock and unlock
    %IVI instrument driver sessions for multithread safefy.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function CallerHasLock = LockSession(obj)
            %LOCKSESSION This function obtains a multithread lock on
            %the instrument session.  Before doing so, it waits until
            %all other execution threads have released their locks on
            %the instrument session.  Other threads might have obtained
            %a lock on this session in the following ways:  - The user's
            %application called IviDmm_LockSession.  - A call to the
            %instrument driver locked the session.  - A call to the IVI
            %engine locked the session.  After your call to
            %IviDmm_LockSession returns successfully, no other threads
            %can access the instrument session until you call
            %IviDmm_UnlockSession.  Use IviDmm_LockSession and
            %IviDmm_UnlockSession around a sequence of calls to
            %instrument driver functions if you require that the
            %instrument retain its settings through the end of the
            %sequence.  You can safely make nested calls to
            %IviDmm_LockSession within the same thread.  To completely
            %unlock the session, you must balance each call to
            %IviDmm_LockSession with a call to IviDmm_UnlockSession.
            %If, however, you use the Caller Has Lock parameter in all
            %calls to IviDmm_LockSession and IviDmm_UnlockSession within
            %a function, the IVI Library locks the session only once
            %within the function regardless of the number of calls you
            %make to IviDmm_LockSession.  This allows you to call
            %IviDmm_UnlockSession just once at the end of the function.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                CallerHasLock = libpointer('uint16Ptr', 0);
                
                status = calllib( libname,'IviDmm_LockSession', session, CallerHasLock);
                
                CallerHasLock = CallerHasLock.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function CallerHasLock = UnlockSession(obj)
            %UNLOCKSESSION This function releases a lock that you
            %acquired on an instrument session using IviDmm_LockSession.
            % Refer to IviDmm_LockSession for additional information on
            %session locks.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                CallerHasLock = libpointer('uint16Ptr', 0);
                
                status = calllib( libname,'IviDmm_UnlockSession', session, CallerHasLock);
                
                CallerHasLock = CallerHasLock.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
