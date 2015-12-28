function spectral_out = spectral_analysis(clean_data, window_size)

    clean_data(isnan(clean_data)) = 0;
    for n = 1:size(clean_data,1);
        [a b c] = spectrogram(clean_data(n,:), window_size);
    end
    
end