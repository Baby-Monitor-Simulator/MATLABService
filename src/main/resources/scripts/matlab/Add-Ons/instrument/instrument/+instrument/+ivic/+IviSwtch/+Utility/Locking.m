classdef Locking < instrument.ivic.IviGroupBase
    %LOCKING This class contains functions that lock and unlock
    %IVI instrument driver sessions for multithread safefy.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function CallerHasLock = LockSession(obj)
            %LOCKSESSION This function obtains a multithread lock on
            %the instrument session.  Before it does so, it waits until
            %all other execution threads have released their locks on
            %the instrument session.  Other threads might have obtained
            %a lock on this session in the following ways:  - The user's
            %application called IviSwtch_LockSession.  - A call to the
            %instrument driver locked the session.  - A call to the IVI
            %engine locked the session.  After your call to
            %IviSwtch_LockSession returns successfully, no other threads
            %can access the instrument session until you call
            %IviSwtch_UnlockSession.  Use IviSwtch_LockSession and
            %IviSwtch_UnlockSession around a sequence of calls to
            %instrument driver functions if you require that the
            %instrument retain its settings through the end of the
            %sequence.  You can safely make nested calls to
            %IviSwtch_LockSession within the same thread.  To completely
            %unlock the session, you must balance each call to
            %IviSwtch_LockSession with a call to IviSwtch_UnlockSession.
            % If, however, you use the Caller Has Lock parameter in all
            %calls to IviSwtch_LockSession and IviSwtch_UnlockSession
            %within a function, the IVI Library locks the session only
            %once within the function regardless of the number of calls
            %you make to IviSwtch_LockSession.  This allows you to call
            %IviSwtch_UnlockSession just once at the end of the
            %function.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                CallerHasLock = libpointer('uint16Ptr', 0);
                
                status = calllib( libname,'IviSwtch_LockSession', session, CallerHasLock);
                
                CallerHasLock = CallerHasLock.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function CallerHasLock = UnlockSession(obj)
            %UNLOCKSESSION This function releases a lock that you
            %acquired on an instrument session using
            %IviSwtch_LockSession.  Refer to IviSwtch_LockSession for
            %additional information on session locks.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                CallerHasLock = libpointer('uint16Ptr', 0);
                
                status = calllib( libname,'IviSwtch_UnlockSession', session, CallerHasLock);
                
                CallerHasLock = CallerHasLock.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
