classdef (Hidden) IviDriverBase < instrument.ivic.IviBase
    %IVICDRIVERBASE class for IVI-C wrappers.
    %   This class provides common functions and capabilities to all
    %   IVI-C drivers such as driver instantiation and deletion.
    
    % Copyright 2010-2017 The MathWorks, Inc.
    
    properties (Hidden = true, Access = protected)
        session;
        libName;
        
    end
    properties
        initialized = false;
    end
    
    methods 
        function obj = IviDriverBase(libName)
            libManager = instrument.ivic.IviLibManager.getInstance();
            libManager.loadLibrary(libName);
            obj.libName = libName;
        end
        
        function delete(obj)
            if obj.initialized
                obj.close();
            end
            
            if (~isempty(obj.libName))
                libManager = instrument.ivic.IviLibManager.getInstance();
                libManager.unloadLibrary(obj.libName);
            end           
        end
    end
    
    methods (Hidden = true)
        
        function disp(obj)
            %   Display driver description such as connection status.
            
            % Get the help for the class
            classHelpText = help(class(obj));
            % Remove the first word of the H1 line, which should be the
            % class name, in ALLCAPS
            [firstWord,adjustedClassHelpText] = strtok(classHelpText,' ');
            % Check that the first word is all caps
            if ~strcmp(firstWord,upper(firstWord))
                % if it's not, don't remove first word.
                adjustedClassHelpText = classHelpText;
            end
            
            % Display the class help text, followed by a line
            % feed
            textToDisp = sprintf('%s \n', adjustedClassHelpText);
            
            
            if obj.initialized
                if any(contains(properties(obj),'InherentIVIProperties'))
                    manufacturer = obj.InherentIVIProperties.InstrumentIdentification.Manufacturer;
                    model = obj.InherentIVIProperties.InstrumentIdentification.Model;
                    simulate =  obj.InherentIVIProperties.UserOptions.Simulate;
                    resourceDes = sprintf ('%s.', obj.InherentIVIProperties.AdvancedSessionInformation.I_O_Resource_Descriptor );
                elseif any(contains(properties(obj),'InherentIVIAttributes'))
                    manufacturer = obj.InherentIVIAttributes.InstrumentIdentification.Manufacturer;
                    model = obj.InherentIVIAttributes.InstrumentIdentification.Model;
                    simulate =  obj.InherentIVIAttributes.UserOptions.Simulate;
                    resourceDes = sprintf ('%s.', obj.InherentIVIAttributes.AdvancedSessionInformation.IO_Resource_Descriptor );
                end
                
                info = sprintf ('%s %s.',manufacturer, model);
                if simulate
                    textToDisp = sprintf('%s %s',textToDisp,  getString(message('instrument:ivic:simulation', info )));
                else
                    textToDisp = sprintf('%s %s',textToDisp,  getString(message('instrument:ivic:connected' , info)));
                end
                    
                textToDisp = sprintf('%s \n %s \n',textToDisp , getString(message('instrument:ivic:resourceDes', resourceDes )));
                
            else
                textToDisp = sprintf('%s %s',textToDisp ,  getString( message('instrument:ivic:NoConnectionEstablished')));
            end
            % Line feed and add the property display
            textToDisp = sprintf('%s\n%s', textToDisp, obj.generatePropertyDisp());
            
            % Line feed and methods and superclass footer
            textToDisp = sprintf('%s\n%s',textToDisp , obj.generateFooter());
            
            % Display it all at once
            disp(textToDisp);
        end        
    end    
end


