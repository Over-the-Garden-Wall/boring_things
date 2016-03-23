function m = fit_NN_logit(m, data, labels)

    is_valid = labels == -1 | labels == 1;
    data = data(is_valid, :);
    labels = labels(is_valid, :);

    logit_m = default_model('logistic regression');
    
    
    m.minibatch_size = size(data,1);

    m = fit_NN(m, data, labels);
    m.binary_prediction = false;
    
%     m.train_E = zeros(m.minibatch_size, m.layer_size(end), m.num_iterations);
    
    total_train_E = zeros(m.layer_size(end), m.num_iterations*m.logit_updates);
     
    for k = 1:m.logit_updates
        m.num_layers = m.num_layers - 1;
        penultimate_layer = m.infer_fxn(m, data);
        m.num_layers = m.num_layers + 1;
        try 
            logit_m = logit_m.fit_fxn(logit_m, penultimate_layer, labels);
        
            m.W{end}(:,1) = logit_m.B(2:end); %insert logit model
            m.B{end}(1) = logit_m.B(1);
        
        catch ME
            disp(ME.message)
            
            m = rmfield(m, 'W');
            m = fit_NN(m, data, labels);
        end
        
        
        m = fit_NN(m, data, labels);

        total_train_E(:, (k-1)*m.num_iterations + (1:m.num_iterations)) = mean(m.train_E, 1);
    end
        
    m.binary_prediction = true;
    m.train_E = total_train_E;
    
end