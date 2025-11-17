function [should_stop, new_params, script_info] = check_messages(server)
    % CHECK_MESSAGES Check for incoming messages and process commands
    %   [should_stop, new_params, script_info] = check_messages(server) checks for incoming
    %   messages on the server connection and processes any commands.
    %
    %   Input:
    %       server - TCP/IP server connection
    %
    %   Output:
    %       should_stop - boolean indicating if processing should stop
    %       new_params - struct containing new parameters if an update command
    %                   was received, empty otherwise
    %       script_info - struct containing script and params for start command,
    %                    empty otherwise
    
    should_stop = false;
    new_params = [];
    script_info = [];
    
    % Check if there are any pending commands
    if server.NumBytesAvailable > 0
        try
            % Read and process the command
            data = read(server, server.NumBytesAvailable, "char");
            command = jsondecode(data);
            
            if isfield(command, 'type')
                switch command.type
                    case 'update'
                        disp('MATLAB: Update command received');
                        disp(['MATLAB: Processing update with params: ' jsonencode(command.params)]);
                        new_params = command.params;
                        
                    case 'stop'
                        disp('MATLAB: Stop command received');
                        should_stop = true;
                        % Send acknowledgment with stop reason
                        if server.Connected
                            write(server, jsonencode(struct('status', 'stopped', 'reason', 'command')), "char");
                            disp('MATLAB: Sent stop acknowledgment (command)');
                        end
                        
                    case 'start'
                        disp('MATLAB: Start command received');
                        if isfield(command, 'script')
                            script_info = struct('script', command.script, 'params', command.params);
                            % Send acknowledgment
                            if server.Connected
                                write(server, jsonencode(struct('status', 'started')), "char");
                                disp('MATLAB: Sent start acknowledgment');
                            end
                        else
                            disp('MATLAB: Start command missing script field');
                        end
                        
                    otherwise
                        disp(['MATLAB: Unknown command type: ' command.type]);
                end
            end
        catch e
            disp(['MATLAB: Error processing command: ' e.message]);
        end
    end
    
    % Check for disconnection
    if ~server.Connected
        should_stop = true;
        disp('MATLAB: Server disconnected in check_messages');
    end
end