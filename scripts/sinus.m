function result = sinus(a, f, ts, tsp, te, server, should_stop)
    % Get the directory where this script is located
    [scriptDir, ~, ~] = fileparts(mfilename('fullpath'));
    
    % Add the script directory and utils directory to the MATLAB path if not already there
    utilsDir = fullfile(scriptDir, 'utils');
    if ~contains(path, scriptDir)
        addpath(scriptDir);
    end
    if ~contains(path, utilsDir)
        addpath(utilsDir);
    end

    
    % SINUS Generate sine wave data
    %   This function generates a sine wave with specified parameters
    %
    %   Input:
    %       a - amplitude
    %       f - frequency (Hz)
    %       ts - start time (s)
    %       tsp - time step (s)
    %       te - end time (s)
    %       server - TCP/IP server connection
    %       should_stop - boolean to indicate if calculation should stop
    %
    %   Output:
    %       result - generated sine wave data

    % Log received parameters
    disp(['MATLAB: sinus received parameters: a=' num2str(a) ', f=' num2str(f) ', ts=' num2str(ts) ', tsp=' num2str(tsp) ', te=' num2str(te)]);
    
    % Calculate number of points
    num_points = floor((te - ts) / tsp) + 1;
    disp(['MATLAB: Calculating ' num2str(num_points) ' points']);
    
    % Generate time points
    T = linspace(ts, te, num_points);
    
    % Calculate in chunks of 100 points
    chunk_size = 100;
    result = [];
    
    % Continuous loop until server disconnects or should_stop is true
    while true
        % Check for messages and process commands
        [should_stop, new_params] = check_messages(server);
        
        % If we received new parameters, send acknowledgment and return them
        if ~isempty(new_params)
            send_message(server, struct('status', 'updated'), 'update acknowledgment');
            result = new_params;
            return;
        end
        
        % Check if we should stop
        if should_stop || ~server.Connected
            disp('MATLAB: Received stop signal or server disconnected, stopping calculation');
            break;
        end
        
        % Reset result for this cycle
        result = [];
        
        for i = 1:chunk_size:num_points
            % Check if we should stop
            if should_stop || ~server.Connected
                disp('MATLAB: Received stop signal or server disconnected, stopping calculation');
                break;
            end
            
            % Calculate end index for this chunk
            end_idx = min(i + chunk_size - 1, num_points);
            
            % Calculate sine wave for this chunk
            chunk_T = T(i:end_idx);
            chunk_y = a * sin(2 * pi * f * chunk_T);
            
            % Add to result
            result = [result, chunk_y];
            
            % Send this chunk to the server
            send_message(server, chunk_y, 'data chunk');
            
            % Add a small pause between chunks to allow for message processing
            pause(0.05);
        end
        
        if should_stop || ~server.Connected
            break;
        end
        
        disp(['MATLAB: First few values: ' num2str(result(1:min(5, length(result))))]);
        disp('MATLAB: Cycle complete, starting next cycle');
        
        % Add a longer delay between cycles
        pause(0.2);
    end
    
    disp('MATLAB: Continuous calculation stopped');
end