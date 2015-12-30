function ar_out = sliding_autoregression(v, window_size, AR_depth)

    if any(isnan(v))
        warning('replacing nans with 0s');
        v(isnan(v)) = 0;
    end
    
    t_len = length(v) - window_size + 1; 
    
    ar_out = zeros(t_len, AR_depth);
    
    for t = 1:t_len
        ar_out(t, :) = autoregress(v(t - 1 + (1:window_size)), AR_depth);
    end
end
    