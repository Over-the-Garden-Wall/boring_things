function prediction = run_NN(m, data)
    
    %forward pass
    prediction = data;
    for l = 1:m.num_layers+1
        prediction = m.f(prediction * m.W{l} + ones(size(prediction,1), 1) * m.B{l});
    end
    if m.binary_prediction
        prediction = sign(prediction);
    end
    
end