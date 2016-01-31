function Y_new = run_RF(m, data)

    Y_new = zeros(size(data,1),1);
    for n = 1:length(m.forest_fn)
       load(m.forest_fn{n});
       Y_new = Y_new + sub_m.infer_fxn(sub_m, data); 
    end
    Y_new = sign(size(data,1) + .1/length(m.forest_fn));
    
end
    