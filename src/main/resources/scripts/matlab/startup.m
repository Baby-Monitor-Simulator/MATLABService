% Add instrument toolbox path
instrumentPath = '/home/matlab/Documents/MATLAB/Add-Ons/instrument';
if exist(instrumentPath, 'dir')
    addpath(genpath(instrumentPath));
else
    error('Instrument directory not found at: %s', instrumentPath);
end

% Add utils directory to path
[scriptDir, ~, ~] = fileparts(mfilename('fullpath'));
utilsPath = fullfile(scriptDir, 'utils');
if exist(utilsPath, 'dir')
    addpath(utilsPath);
else
    error('Utils directory not found at: %s', utilsPath);
end

% Add production directory to path
prodPath = fullfile(scriptDir, 'production');
if exist(prodPath, 'dir')
    addpath(prodPath);
else
    error('Production directory not found at: %s', prodPath);
end

% Additional verification
disp('Checking for TCP/IP functions...');
tcpserverPath = which('tcpserver');
tcpipPath = which('tcpip');

if ~isempty(tcpserverPath) && ~isempty(tcpipPath)
    fprintf('tcpserver and tcpip both exist.\n');
else
    if ~isempty(tcpserverPath)
        fprintf('tcpserver exists.\n');
    end
    if ~isempty(tcpipPath)
        fprintf('tcpip exists.\n');
    end
end

try
    % Create TCP/IP server
    server = tcpserver('0.0.0.0', 12345);
    disp('MATLAB: Server created successfully');
    cleanupObj = onCleanup(@() delete(server));
    
    % Keep MATLAB running and listening for connections
    disp('MATLAB: Server started on port 12345');
    disp('MATLAB: Waiting for client connection...');
    
    % Initialize variables for continuous operation
    current_script = '';
    current_params = [];
    is_running = false;
    should_stop = false;
    is_updating = false;  % Flag to track update state
    update_pending = false;  % Flag to track pending updates
    
    % Wait for initial connection
    while ~server.Connected
        pause(0.1);
    end
    disp('MATLAB: Client connected');
    
    while true
        % Check if client is connected
        if ~server.Connected
            disp('MATLAB: Client disconnected, waiting for new connection...');
            while ~server.Connected
                pause(0.1);
            end
            disp('MATLAB: New client connected');
            continue;
        end
        
        % Check for messages using utility function
        [should_stop, new_params, script_info] = check_messages(server);
        
        % Handle new parameters if received
        if ~isempty(new_params)
            current_params = new_params;
            disp(['MATLAB: Updated parameters to: ' jsonencode(current_params)]);
            should_stop = true;  % Stop current execution to restart with new params
        end
        
        % Handle start command if received
        if ~isempty(script_info)
            current_script = script_info.script;
            current_params = script_info.params;
            is_running = true;
            should_stop = false;
            disp(['MATLAB: Starting continuous execution of ' current_script]);
        end
        
        % If we're running and have a script, execute it
        if is_running && ~isempty(current_script) && ~should_stop
            try
                disp(['MATLAB Startup: Executing ' current_script ' with params: ' jsonencode(current_params)]);

                % Convert params to a cell array in case it isn't already
                if ~iscell(current_params)
                    current_params = num2cell(current_params);
                end

                % Force current_params to be a 1xN row cell array
                current_params = reshape(current_params, 1, []);
                
                % Safely concatenate the function arguments
                all_args = [current_params, {server}, {should_stop}];
                
                % Execute the script
                result = feval(current_script(1:end-2), all_args{:});
                
                % Send result using utility function
                send_message(server, result, 'result');
                
                % Check if we got new parameters from the script
                if (isequal(size(result), [1 5]) || isequal(size(result), [5 1])) && isnumeric(result)
                    disp(['MATLAB: Received new parameters from script: ' jsonencode(result)]);
                    % Convert to row vector if needed
                    if size(result, 1) > size(result, 2)
                        result = result';
                    end
                    current_params = result;
                    disp(['MATLAB: Updated current_params to: ' jsonencode(current_params)]);
                end
                
                if should_stop
                    disp('MATLAB: Script stopped by command');
                    is_running = false;
                    should_stop = false;  % Reset should_stop for next execution
                    % Add a small delay to ensure acknowledgment is sent
                    pause(0.1);
                    continue;  % Continue to next iteration to restart with new parameters
                else
                    disp(['MATLAB: Cycle complete, starting next cycle']);
                    % Add a longer pause between cycles to allow for message processing
                    pause(0.5);
                end
            catch e
                disp(['MATLAB: Error executing script: ' e.message]);
                send_message(server, struct('error', e.message), 'error');
                is_running = false;
            end
        else
            % If not running, add a small pause to prevent CPU spinning
            pause(0.1);
        end
    end 
catch e
    disp(['MATLAB: Server error: ' e.message]);
end