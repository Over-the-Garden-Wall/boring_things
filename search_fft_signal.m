function model_out = search_fft_signal(M, window_size, event_time)

    signal_out_length = size(M,2) - window_size + 1;
    time_0 = ceil(signal_out_length / 2);
    event_time = time_0 + event_time;
    
    response_model = zeros(signal_out_length,1);
    response_model(event_time + (window_size-1:-1:0)) = 1:window_size;
    response_model(event_time + (-window_size+1:0)) = 1:window_size;
    
    model_out = zeros(size(M,1), ceil(window_size/2));
    
    for n = 1:size(M,1)
        v = M(n,:);
        spectro = sliding_fft(v, window_size);
        
        model_corr = corr([response_model abs(spectro(:,1:ceil(window_size/2)))]);
        model_out(n,:) = model_corr(1,2:end);
            
    end
    
end
       