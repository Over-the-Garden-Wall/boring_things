function data = read_and_clean_data(input_length, use_residual)

    if ~exist('use_residual', 'var') || isempty(use_residual)
        use_residual = false;
    end

    fn = 'data.h5';
    
    raw_data = read_hdf5_into_struct(fn);
    
    
    
    %pad returns conservatively for convenience
    fields_to_pad = {'ret', 'mktcap', 'evt', 'clf'};
    for k = 1:length(fields_to_pad)
        raw_data.(fields_to_pad{k}) = pad_data_nans(raw_data.(fields_to_pad{k}), input_length, 0);
    end
    mkt_signal = mean_nonan(raw_data.ret);
    mkt_signal(isnan(mkt_signal)) = 0;
    raw_data.ret(isnan(raw_data.ret)) = 0;
    
    Betas = raw_data.ret / mkt_signal;
    
    if use_residual
        raw_data.ret = raw_data.ret - (Betas * mkt_signal);
    end

    data = [];
    category_fields = {'mktcap', 'evt', 'clf', 't', 'equity'};
    
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
        data.t(r) = t;
        data.equity(r) = 1:size(raw_data.ret,1); 
        
        for k = 1:3 %length(category_fields)
            data.(category_fields{k})(r) = raw_data.(category_fields{k})(:,t);
        end
                
    end
    data.bin_label = sign(data.reg_label);
    
    
end
        
    