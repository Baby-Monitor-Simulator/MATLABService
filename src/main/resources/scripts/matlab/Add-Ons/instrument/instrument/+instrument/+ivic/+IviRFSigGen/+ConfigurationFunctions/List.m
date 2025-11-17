classdef List < instrument.ivic.IviGroupBase
    %LIST The IviRFSigGenList Extension Group supports signal
    %generators that can set the frequency and power of the RF
    %output signal to values given as a list of values. The user
    %can enable or disable stepping the frequency and power
    %list, specify the name of the list and set it's values. The
    %active list can be selected usingd the list name. Setting
    %single step and dwell time are also included.  This
    %extension group requires the Sweep extension group. List
    %stepping is enabled by setting the sweep mode to
    %IVIRFSIGGEN_VAL_SWEEP_MODE_LIST in the sweep extension
    %group.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function CreateFrequencyList(obj,Name,Length,Frequency)
            %CREATEFREQUENCYLIST This function creates a named list of
            %frequency values.
            
            narginchk(4,4)
            Name = obj.checkScalarStringArg(Name);
            Length = obj.checkScalarInt32Arg(Length);
            Frequency = obj.checkVectorDoubleArg(Frequency);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = [double(Name) 0];
                
                status = calllib( libname,'IviRFSigGen_CreateFrequencyList', session, Name, Length, Frequency);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function CreatePowerList(obj,Name,Length,Power)
            %CREATEPOWERLIST This function creates a named list of
            %power values.
            
            narginchk(4,4)
            Name = obj.checkScalarStringArg(Name);
            Length = obj.checkScalarInt32Arg(Length);
            Power = obj.checkVectorDoubleArg(Power);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = [double(Name) 0];
                
                status = calllib( libname,'IviRFSigGen_CreatePowerList', session, Name, Length, Power);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function CreateFrequencyPowerList(obj,Name,Length,Frequency,Power)
            %CREATEFREQUENCYPOWERLIST This function creates a named
            %list of frequency and power values.
            
            narginchk(5,5)
            Name = obj.checkScalarStringArg(Name);
            Length = obj.checkScalarInt32Arg(Length);
            Frequency = obj.checkVectorDoubleArg(Frequency);
            Power = obj.checkVectorDoubleArg(Power);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = [double(Name) 0];
                
                status = calllib( libname,'IviRFSigGen_CreateFrequencyPowerList', session, Name, Length, Frequency, Power);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SelectList(obj,Name)
            %SELECTLIST This function sets a named list to be the
            %active list.  Create list names using the following
            %functions:  IviRFSigGen_CreateFrequencyList,
            %IviRFSigGen_CreatePowerList, or
            %IviRFSigGen_CreateFrequencyPowerList.
            
            narginchk(2,2)
            Name = obj.checkScalarStringArg(Name);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = [double(Name) 0];
                
                status = calllib( libname,'IviRFSigGen_SelectList', session, Name);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ClearAllLists(obj)
            %CLEARALLLISTS This function deletes all lists from the
            %pool of defined lists.  The following functions create list
            %names: IviRFSigGen_CreateFrequencyList,
            %IviRFSigGen_CreatePowerList, or
            %IviRFSigGen_CreateFrequencyPowerList.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ClearAllLists', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureListDwell(obj,SingleStepEnabled,Dwell)
            %CONFIGURELISTDWELL This function configures how list
            %stepping advances.
            
            narginchk(3,3)
            SingleStepEnabled = obj.checkScalarBoolArg(SingleStepEnabled);
            Dwell = obj.checkScalarDoubleArg(Dwell);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureListDwell', session, SingleStepEnabled, Dwell);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ResetList(obj)
            %RESETLIST This function resets the current list to the
            %first entry value.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ResetList', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
