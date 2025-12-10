function rsName = getResourceNameToConnect()
% GETRESOURCENAMETOCONNECT gets the correct resource name that user 
% selected from the different options present in the dialog.

% Copyright 2023 The MathWorks, Inc.

% Get the resource name to connect to.
hwSelectType = get_param(gcb,"hwConfigOptions");
if strcmpi(hwSelectType, 'Select from resource list')
    if strcmpi(get_param(gcb,"ResourceName"), '<Select a resource name>')
        coder.internal.error('instrument:instrumentblks:noResourceSelected');
    end
    rsName = get_param(gcb,"ResourceName");
elseif strcmpi(hwSelectType, 'Configure new VISA resource')
    switch get_param(gcb,"Interface")
        case 'TCP/IP VXI-11'
            rsName = sprintf("TCPIP%s::%s::inst%s::INSTR", ...
                get_param(gcb,"BoardNumber"), ...
                get_param(gcb,"IPAddress"), ...
                get_param(gcb,"DeviceID"));
        case 'TCP/IP Socket'
            rsName = sprintf("TCPIP%s::%s::%s::SOCKET", ...
                get_param(gcb,"BoardNumber"), ...
                get_param(gcb,"IPAddress"), ...
                get_param(gcb,"Port"));
        case 'TCP/IP HiSLIP 1'
            % If port is empty or 4880, the port is not used as part of the
            % visa identification string.
            if get_param(gcb,"Port") == "" || get_param(gcb,"Port") == "4880"
                rsName = sprintf("TCPIP%s::%s::hislip%s::INSTR", ...
                    get_param(gcb,"BoardNumber"), ...
                    get_param(gcb,"IPAddress"), ...
                    get_param(gcb,"DeviceID"));
            else
                rsName = sprintf("TCPIP%s::%s::hislip%s,%s::INSTR", ...
                    get_param(gcb,"BoardNumber"), ...
                    get_param(gcb,"IPAddress"), ...
                    get_param(gcb,"DeviceID"), ...
                    get_param(gcb,"Port"));
            end
    end
else
    rsName  = get_param(gcb,"ResourceString");
    if isempty(rsName)
        coder.internal.error('instrument:instrumentblks:noResourceSelected');
    end
end

end

