function Y_new = run_RF(m, data)
    Y_new = zeros(size(data,1),1);
    
    for n = 1:length(m.forest)
        Y_new = classRF_predict(data, m.forest{n})/length(m.forest);
    end
    Y_new = sign(Y_new);
    
end
    