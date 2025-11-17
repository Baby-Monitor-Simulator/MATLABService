classdef Multitrace < instrument.ivic.IviGroupBase
    %MULTITRACE The IviSpecAnMultitrace extension group defines
    %extensions for analyzers capable of performing simple
    %mathematical functions on one or more traces.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function AddTraces(obj,DestinationTrace,Trace1,Trace2)
            %ADDTRACES This function adds trace 1 and trace 2, point by
            %point, and stores the results in the destination trace.
            %Any data in the destination trace is deleted.
            
            narginchk(4,4)
            DestinationTrace = obj.checkScalarStringArg(DestinationTrace);
            Trace1 = obj.checkScalarStringArg(Trace1);
            Trace2 = obj.checkScalarStringArg(Trace2);
            try
                [libname, session ] = obj.getLibraryAndSession();
                DestinationTrace = [double(DestinationTrace) 0];
                Trace1 = [double(Trace1) 0];
                Trace2 = [double(Trace2) 0];
                
                status = calllib( libname,'IviSpecAn_AddTraces', session, DestinationTrace, Trace1, Trace2);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ExchangeTraces(obj,Trace1,Trace2)
            %EXCHANGETRACES This function exchanges the data arrays of
            %two traces.
            
            narginchk(3,3)
            Trace1 = obj.checkScalarStringArg(Trace1);
            Trace2 = obj.checkScalarStringArg(Trace2);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Trace1 = [double(Trace1) 0];
                Trace2 = [double(Trace2) 0];
                
                status = calllib( libname,'IviSpecAn_ExchangeTraces', session, Trace1, Trace2);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function CopyTrace(obj,DestinationTrace,SourceTrace)
            %COPYTRACE This function copies one trace array to another
            %trace array.  Any data in the destination trace is over
            %written.
            
            narginchk(3,3)
            DestinationTrace = obj.checkScalarStringArg(DestinationTrace);
            SourceTrace = obj.checkScalarStringArg(SourceTrace);
            try
                [libname, session ] = obj.getLibraryAndSession();
                DestinationTrace = [double(DestinationTrace) 0];
                SourceTrace = [double(SourceTrace) 0];
                
                status = calllib( libname,'IviSpecAn_CopyTrace', session, DestinationTrace, SourceTrace);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SubtractTraces(obj,DestinationTrace,Trace1,Trace2)
            %SUBTRACTTRACES This function subtracts the array elements
            %of Trace 2 from Trace 1 and stores the result in the
            %Destination Trace.  Destination Trace = Trace 1 - Trace 2
            
            narginchk(4,4)
            DestinationTrace = obj.checkScalarStringArg(DestinationTrace);
            Trace1 = obj.checkScalarStringArg(Trace1);
            Trace2 = obj.checkScalarStringArg(Trace2);
            try
                [libname, session ] = obj.getLibraryAndSession();
                DestinationTrace = [double(DestinationTrace) 0];
                Trace1 = [double(Trace1) 0];
                Trace2 = [double(Trace2) 0];
                
                status = calllib( libname,'IviSpecAn_SubtractTraces', session, DestinationTrace, Trace1, Trace2);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
