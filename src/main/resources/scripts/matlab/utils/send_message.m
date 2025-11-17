function success = send_message(server, message, message_type)
    % SEND_MESSAGE Send a message to the server
    %   success = send_message(server, message, message_type) sends a message
    %   to the server and returns whether the operation was successful.
    %
    %   Input:
    %       server - TCP/IP server connection
    %       message - data to send (will be converted to JSON)
    %       message_type - optional string describing the message type
    %
    %   Output:
    %       success - boolean indicating if the message was sent successfully
    
    success = false;
    
    if ~server.Connected
        disp('MATLAB: Cannot send message - server is not connected');
        return;
    end
    
    try
        % Convert message to JSON if it's not already a string
        if ~ischar(message)
            message = jsonencode(message);
        end
        
        % Send the message
        write(server, message, "char");
        
        % Log the message if type is provided
        if nargin > 2
            disp(['MATLAB: Sent ' message_type ' message']);
        end
        
        success = true;
    catch e
        disp(['MATLAB: Error sending message: ' e.message]);
    end
end 