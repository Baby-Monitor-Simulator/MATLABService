classdef InterchangeabilityInfo < instrument.ivic.IviGroupBase
    %INTERCHANGEABILITYINFO This class contains functions that
    %retrieve interchangeability warnings.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function InterchangeWarning = GetNextInterchangeWarning(obj,BufferSize)
            %GETNEXTINTERCHANGEWARNING This function returns the
            %interchangeability warnings associated with the IVI
            %session. It retrieves and clears the oldest instance in
            %which the class driver recorded an interchangeability
            %warning.  Interchangeability warnings indicate that using
            %your application with a different instrument might cause
            %different behavior. You use this function to retrieve
            %interchangeability warnings.  The driver performs
            %interchangeability checking when the
            %IVISPECAN_ATTR_INTERCHANGE_CHECK attribute is set to True.
            %The function returns an empty string in the Interchange
            %Warning parameter if no interchangeability warnings remain
            %for the session.  In general, the instrument driver
            %generates interchangeability warnings when an attribute
            %that affects the behavior of the instrument is in a state
            %that you did not specify.
            
            narginchk(2,2)
            BufferSize = obj.checkScalarInt32Arg(BufferSize);
            try
                [libname, session ] = obj.getLibraryAndSession();
                InterchangeWarning = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviSpecAn_GetNextInterchangeWarning', session, BufferSize, InterchangeWarning);
                
                InterchangeWarning = strtrim(char(InterchangeWarning.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ClearInterchangeWarnings(obj)
            %CLEARINTERCHANGEWARNINGS This function clears the list of
            %current interchange warnings.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ClearInterchangeWarnings', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ResetInterchangeCheck(obj)
            %RESETINTERCHANGECHECK When developing a complex test
            %system that consists of multiple test modules, it is
            %generally a good idea to design the test modules so that
            %they can run in any order.  To do so requires ensuring that
            %each test module completely configures the state of each
            %instrument it uses.  If a particular test module does not
            %completely configure the state of an instrument, the state
            %of the instrument depends on the configuration from a
            %previously executed test module.  If you execute the test
            %modules in a different order, the behavior of the
            %instrument and therefore the entire test module is likely
            %to change.  This change in behavior is generally instrument
            %specific and represents an interchangeability problem.  You
            %can use this function to test for such cases.  After you
            %call this function, the interchangeability checking
            %algorithms in the specific driver ignore all previous
            %configuration operations.  By calling this function at the
            %beginning of a test module, you can determine whether the
            %test module has dependencies on the operation of previously
            %executed test modules.  This function does not clear the
            %interchangeability warnings from the list of previously
            %recorded interchangeability warnings.  If you want to
            %guarantee that the IviSpecAn_GetNextInterchangeWarning
            %function only returns those interchangeability warnings
            %that are generated after calling this function, you must
            %clear the list of interchangeability warnings.  You can
            %clear the interchangeability warnings list by repeatedly
            %calling the IviSpecAn_GetNextInterchangeWarning function
            %until no more interchangeability warnings are returned.  If
            %you are not interested in the content of those warnings,
            %you can call the IviSpecAn_ClearInterchangeWarnings
            %function.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ResetInterchangeCheck', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
