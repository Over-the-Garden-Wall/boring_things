function spectro = sliding_fft(v, window_size)
    %pretty much a spectrogram...

    if any(isnan(v))
        warning('replacing nans with 0s');
        v(isnan(v)) = 0;
    end
    
    t_len = length(v) - window_size + 1; 
    
    spectro = zeros(t_len, window_size);
    
    for t = 1:t_len
        spectro(t, :) = fft(v(t - 1 + (1:window_size)));
    end
end
    