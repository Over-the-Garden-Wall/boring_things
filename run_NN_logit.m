function prediction = run_NN_logit(m, data)
    
    %forward pass
    prediction = data;
    for l = 1:m.num_layers+1
        prediction = m.f(prediction * m.W{l} + ones(size(prediction,1), 1) * m.B{l});
    end
    prediction = prediction * 2 - 1;
    if m.binary_prediction
        prediction = sign(prediction);
    end
    
end