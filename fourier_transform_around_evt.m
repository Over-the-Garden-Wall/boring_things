function fft_data = fourier_transform_around_evt(data)
    data(isnan(data)) = 0;
    fft_data = zeros(size(data));
    
    for n = 1:size(data,1);
        fft_data(n,:) = fft(data(n,:));
    end
end