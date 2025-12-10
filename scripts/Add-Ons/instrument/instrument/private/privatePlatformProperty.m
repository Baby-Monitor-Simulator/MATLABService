function value = privatePlatformProperty(prop)
%PRIVATEPLATFORMPROPERTY return platform information.
%
%   PRIVATEPLATFORMPROPERTY(PROP) returns platform specific values for a given
%   property, PROP.
%
%   This function should not be called directly by the user.
%  
 
%   PE 08-16-04
%   Copyright 2004-2012 The MathWorks, Inc.

value = '';

switch(prop)
    case 'dirname'
        value = computer('arch');
    case 'libext'
        switch computer
            case {'PCWIN', 'PCWIN64'}
                value = '.dll';
            case {'GLNX86', 'GLNXA64', 'SOL2', 'SOL64'}
                value = '.so';
            case {'MAC', 'MACI', 'MACI64'}
                value = '.dylib';
        end
end
