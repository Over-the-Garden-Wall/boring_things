function evt_data = read_and_clean_data_for_nonevt(time_range, input_length)

    fn = 'data.h5';
    
    raw_data = read_hdf5_into_struct(fn);
    
    %pad returns conservatively for convenience
    padvals = [abs(min(time_range)) + input_length, max(time_range)];
    raw_data.ret = pad_data_nans(raw_data.ret, padvals(1), padvals(2));
    
%     %have to remove market effects prior to reorganization
%     [raw_data.resid_ret, raw_data.beta] = remove_market_beta(raw_data.ret);
%     
    [evt_r, evt_c] = find(raw_data.evt==0);
    evt_c = evt_c + abs(padvals(1)); %compensate for padding

    to_use = false(size(raw_data.ret));
    to_use(evt_r,:) = true;
    to_use(:,1:padvals(1)+2) = false;
    to_use(:,end-padvals(2):end) = false;
    
    num_events = length(evt_r);
    for n = 1:num_events
        to_use(evt_r(n), evt_c(n) + time_range) = false;
    end

    
    is_usable_trans = find(to_use');
    trans_ret = raw_data.ret';
    
    
    evt_data = [];
    
    evt_data.ret = trans_ret(is_usable_trans*ones(1,input_length) ...
        + ones(length(is_usable_trans),1)*(-25:-1)); 
    evt_data.label = trans_ret(is_usable_trans);
    evt_data.t = zeros(size(evt_data.label));
    evt_data.clf = raw_data.clf(to_use(:,padvals(1)+1:end-padvals(2)));
    
    
    evt_data.label = sign(evt_data.label);
    evt_data.ret(isnan(evt_data.ret)) = 0;
    
    to_remove = isnan(evt_data.label) | evt_data.label == 0;
    
    evt_data.ret(to_remove,:) = [];
    evt_data.label(to_remove,:) = [];
    evt_data.t(to_remove) = [];
    evt_data.clf(to_remove) = [];
    
    
end
        
    