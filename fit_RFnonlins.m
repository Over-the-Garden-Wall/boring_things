function m = fit_RFnonlins(m, data, labels)

    RF_m = default_model('RF');
    RF_m.ntee = m.ntree;
    
    m.ntree = 500;
        m.forests_per_nlin = 10;
        m.fxn_res = 200;
        m.search_res = 20;
        
    
    [m.response_functions, m.fxn_x, m.fxn_y] = extract_variable_response_RF(RF_m, data, ...
        labels, m.forests_per_nonlin, m.search_res, m.fxn_res);
    
    for n = 1:size(data,2);
        data(:,n) = m.response_functions{n}(data(:,n), m.fxn_x{n}, m.fxn_y{n});
    end
    
    m.logit_m = default_model('logistic regression');
    m.logit_m = m.logit_m.fit_fxn(m.logit_m, data, labels);
    
end
    
    