function result = cosinus(a, f, ts, tsp, te)
    T = ts:tsp:te;
    y = a * cos(2 * pi * f * T);
    
    % Convert to array for JSON serialization
    result = double(y);
end