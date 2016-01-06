function prediction = run_RFnonlins(m, data)

    for n = 1:size(data,2);
        data(:,n) = m.response_functions{n}(data(:,n), m.fxn_x{n}, m.fxn_y{n});
    end
    
    prediction = m.logit_m.infer_fxn(m.logit_m, data);
    
end
    
    