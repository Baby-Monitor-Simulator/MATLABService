classdef ProgrammingState
    %PROGRAMMINGSTATE Enumeration for NI-RFSG Programming State Model
    
    % Copyright 2022 The MathWorks, Inc.
   
   enumeration
       Configuration    (false, false)
       Committed        (true, false)
       Generation       (true, true)
   end

   properties
       IsCommitted logical
       IsInitiated logical
       IsSettled logical
   end
    
   methods
       function state = ProgrammingState(committed, initiated)
           state.IsCommitted = committed;
           state.IsInitiated = initiated;
           state.IsSettled = initiated;
       end
   end
end