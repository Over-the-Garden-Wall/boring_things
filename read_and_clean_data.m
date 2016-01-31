function data = read_and_clean_data(input_length)

    fn = 'data.h5';
    
    raw_data = read_hdf5_into_struct(fn);
    
    %pad returns conservatively for convenience
    fields_to_pad = {'ret', 'mktcap', 'evt', 'clf'};
    for k = 1:length(fields_to_pad)
        raw_data.(fields_to_pad{k}) = pad_data_nans(raw_data.(fields_to_pad{k}), input_length, 0);
    end
    raw_data.ret(isnan(raw_data.ret)) = 0;
    

    data = [];
    category_fields = {'mktcap', 'evt', 'clf'};
    
    num_total_samples = (size(raw_data.ret,2) - input_length) * size(raw_data.ret, 1);
    
    data.input = zeros(num_total_samples,input_length);
    data.reg_label = zeros(num_total_samples,1);
    for k = 1:length(category_fields)
        data.(category_fields{k}) = zeros(num_total_samples,1);
    end
    
    for t = input_length+1 : size(raw_data.ret, 2);
        r = (t-input_length-1) * size(raw_data.ret, 1) + ...
            (1:size(raw_data.ret, 1));
        
        data.input(r, :) = raw_data.ret(:, t + (-input_length : -1));
        data.reg_label(r) = raw_data.ret(:, t);
        
        for k = 1:length(category_fields)
            data.(category_fields{k})(r) = raw_data.(category_fields{k})(:,t);
        end
                
    end
    data.bin_label = sign(data.reg_label);
    
    
end
        
    