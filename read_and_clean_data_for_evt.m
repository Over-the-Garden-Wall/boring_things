function evt_data = read_and_clean_data_for_evt(time_range)

    fn = 'data.h5';
    
    raw_data = read_hdf5_into_struct(fn);
    
    %pad returns conservatively for convenience
    raw_data.ret = pad_data_nans(raw_data.ret, abs(min(time_range)), max(time_range));
    
    %have to remove market effects prior to reorganization
    [raw_data.resid_ret, raw_data.beta] = remove_market_beta(raw_data.ret);
    
    [evt_r, evt_c] = find(raw_data.evt==0);
    evt_c = evt_c + abs(min(time_range)); %compensate for padding
    
    num_events = length(evt_r);
    num_t = length(time_range);
    
    evt_data = [];
    evt_data.clf = raw_data.clf(evt_r,1); %clf was in a silly format, now vector
    evt_data.beta = raw_data.beta(evt_r);
    
    
    
    evt_data.ret = zeros(num_events, num_t);
    evt_data.resid_ret = zeros(num_events, num_t);
    for n = 1:num_events
        evt_data.ret(n,:) = raw_data.ret(evt_r(n), evt_c(n) + time_range);
        evt_data.resid_ret(n,:) = raw_data.resid_ret(evt_r(n), evt_c(n) + time_range);
    end
    
end
        
    