% INSTRSUPPORT Instrument Control Toolbox troubleshooting utility.
%
%    INSTRSUPPORT, returns diagnostic information for all installed hardware
%    adaptors and saves output to text file 'instrsupport.txt' in the current
%    directory.
%
%    Examples:
%       instrsupport

%#ok<*NOPRT>

%   Copyright 2006-2022 The MathWorks, Inc.

function instrsupport

    originalWarningState = warning;
    cleanup = onCleanup(@()warning(originalWarningState));
    warning('off',"instrument:instrhwinfo:FunctionToBeRemoved");
    warning('off',"instrument:serial:ClassToBeRemoved");
    warning('off',"instrument:visa:ClassToBeRemoved");

    filename = 'instrsupport.txt';

    % Deletes text file, 'FILENAME', if one already exists.
    if ~isempty(dir(filename))
        try
            delete(filename);
        catch aException
            error(message('instrument:instrsupport:filedelete'));
        end
    end

    diary(filename)
    cUp = onCleanup(@()diary('off'));
    section('current date and time')
    datestr(datetime("now"))

    section('matlab and instrument control toolbox versions');

    m=ver('matlab'); %#ok<NASGU>
    c=ver('instrument');

    [x, y]=size(c);
    if ~(x > 0 && y > 0)
        % instrument control toolbox not found
        warn('You need to install the Instrument Control Toolbox before attempting to use its functionality.\n');
        return;
    end
    matlabVersion = version %#ok<NASGU>
    toolboxVersion = c %#ok<NASGU>

    section('serial library version');
    import gnu.io.RXTXVersion
    RXTXVersion.getVersion

    section('installed adaptors');
    info = instrhwinfo
    ifaces = info.SupportedInterfaces
    for i=1:length(ifaces)
        subsection( ifaces{i} );
        try
            adaptors = instrhwinfo( ifaces{i} )
            if isprop( adaptors, 'InstalledAdaptors')
                if(iscell(adaptors.InstalledAdaptors))
                    for j=1:length(adaptors.InstalledAdaptors)
                        devinfo=instrhwinfo( ifaces{i}, adaptors.InstalledAdaptors{j} )
                        if isprop(devinfo,'ObjectConstructorName')
                            for n=1:length(devinfo.ObjectConstructorName)
                                fprintf('\nConnecting using the constructor: %s\n',devinfo.ObjectConstructorName{n});
                                obj=eval(devinfo.ObjectConstructorName{n})
                                delete(obj)
                                clear obj
                            end
                        end
                    end
                end
            elseif isprop(adaptors,'ObjectConstructorName')
                for n=1:length(adaptors.ObjectConstructorName)
                    fprintf('\nConnecting using the constructor: %s\n',adaptors.ObjectConstructorName{n});
                    obj=eval(adaptors.ObjectConstructorName{n})
                    delete(obj)
                    clear obj
                end
            elseif isprop( adaptors, 'InstalledVendors')
                if(iscell(adaptors.InstalledVendors))
                    for j=1:length(adaptors.InstalledVendors)
                        devinfo=instrhwinfo( ifaces{i}, adaptors.InstalledVendors{j} )
                        if isprop(devinfo,'ObjectConstructors')
                            for n=1:length(devinfo.ObjectConstructors)
                                fprintf('\nConnecting using the constructor: %s\n',devinfo.ObjectConstructors{n});
                                obj=eval(devinfo.ObjectConstructors{n})
                                delete(obj)
                                clear obj
                            end
                        end
                    end
                end
            end
        catch e %#ok<NASGU>
        end
    end

    % Display the driver information available with instrhwinfo.

    section( 'installed drivers' );
    drivers = info.SupportedDrivers
    for i=1:length(drivers)
        subsection( drivers{i} );
        driverType = instrhwinfo( drivers{i} )'
        if isprop( driverType, 'InstalledDrivers')
            subsection('InstalledDrivers');
            driverType.InstalledDrivers'
        elseif isprop(driverType, 'LogicalNames')
            subsection('LogicalNames');
            driverType.LogicalNames'
            subsection('Modules');
            driverType.Modules' 
        end
    end

    section ('visadevlist')
    vl = visadevlist("Timeout", 60)
    for r = vl.ResourceName'
        try
            vd = visadev(r) %#ok<NASGU> 
            clear vd
        catch e
            disp(e.message)
            clear vd
        end
    end

    clear vl

    section ('serialportlist')
    spl = serialportlist
    for sp = spl
        try
            s = serialport(sp, 9600) %#ok<NASGU> 
            clear s
        catch e
            disp(e.message)
            clear s
        end
    end

    clear spl

    section( 'installed support packages' );
    spkgs = matlabshared.supportpkg.getInstalled('BaseProduct', 'Instrument Control Toolbox');
    for i=1:length(spkgs)
        spkgs(i)
    end
    
    section('version')
    ver

    section('environment variables');
    !set

    section('current working directory')
    pwd

    section('matlab path')
    path

    section('matlabroot')
    matlabroot
    diary OFF;

    edit(filename)

    function section( str )
        fprintf('\n ------------- %s -------------\n\n', upper(str) );
    end

    function subsection( str )
        fprintf('\n -------- %s --------\n\n', upper(str) );
    end

    function warn( str )
        input( ['!!!:  '  str '\nPress ENTER to continue...'], 's' );
    end
end
