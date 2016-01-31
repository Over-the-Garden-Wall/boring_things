function Y_new = run_RF(m, data)

    if iscell(m.forest)
        Y_new = classRF_predict(data, m.forest{1});
    else
        Y_new = classRF_predict(data, m.forest);    
    end
    
end
    