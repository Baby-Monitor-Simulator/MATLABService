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
            %different behavior. If the IVIFGEN_ATTR_SPY attribute is
            %set to False, you use this function to retrieve
            %interchangeability warnings. If the IVIFGEN_ATTR_SPY
            %attribute is set to True, you use the NI Spy utility to
            %view interchangeability warnings.  The class driver
            %performs interchangeability checking when the
            %IVIFGEN_ATTR_INTERCHANGE_CHECK attribute is set to True and
            %you call one of the following functions:
            %IviFgen_InitiateGeneration()  If the next
            %interchangeability warning string, including the
            %terminating NUL byte, contains more bytes than you indicate
            %in this parameter, the function copies Buffer Size - 1
            %bytes into the buffer, places an ASCII NUL byte at the end
            %of the buffer, and returns the buffer size you must pass to
            %get the entire value. For example, if the value is "123456"
            %and the Buffer Size is 4, the function places "123" into
            %the buffer and returns 7.  If you pass a negative number
            %for the buffer size, the function copies the value to the
            %buffer regardless of the number of bytes in the value.  If
            %you pass 0 for the buffer size, you can pass VI_NULL for
            %the Interchange Warning buffer parameter.  The function
            %returns an empty string in the Interchange Warning
            %parameter if no interchangeability warnings remain for the
            %session.  Interchangeability checking examines the
            %attributes in a capability group only if you specify a
            %value for at least one attribute within that group. In
            %general, the class driver generates interchangeability
            %warnings when it encounters one of the following
            %conditions:  (1) An attribute that affects the behavior of
            %the instrument is in a state that you did not specify.  (2)
            %You set a class-defined attribute to an instrument-specific
            %value.  (3) You set the value of an attribute that the
            %class driver defines as read-only.  (4) The class driver
            %encounters an error when it tries to apply a value to an
            %extension attribute that your program never configures.
            
            narginchk(2,2)
            BufferSize = obj.checkScalarInt32Arg(BufferSize);
            try
                [libname, session ] = obj.getLibraryAndSession();
                InterchangeWarning = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviFgen_GetNextInterchangeWarning', session, BufferSize, InterchangeWarning);
                
                InterchangeWarning = strtrim(char(InterchangeWarning.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ClearInterchangeWarnings(obj)
            %CLEARINTERCHANGEWARNINGS The specific driver performs
            %interchangeability checking if the
            %IVIFGEN_ATTR_INTERCHANGE_CHECK attribute is set to True.
            %This function clears the list of current interchange
            %warnings.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviFgen_ClearInterchangeWarnings', session);
                
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
            %guarantee that the IviFgen_GetNextInterchangeWarning
            %function only returns those interchangeability warnings
            %that are generated after calling this function, you must
            %clear the list of interchangeability warnings.  You can
            %clear the interchangeability warnings list by repeatedly
            %calling the IviFgen_GetNextInterchangeWarning function
            %until no more interchangeability warnings are returned.  If
            %you are not interested in the content of those warnings,
            %you can call the IviFgen_ClearInterchangeWarnings function.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviFgen_ResetInterchangeCheck', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
