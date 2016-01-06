function m = fit_NN_logit_init(m, data, labels)

    logit_m = default_model('logistic regression');
    logit_m = logit_m.fit_fxn(logit_m, data, labels);
    
%     logit_pred = logit_m.infer_fxn(logit_m, data);
    
    
    m.num_layers = 1;
    m.layer_size = [0 m.layer_size(2) 0];
    %m.minibatch_size = size(data,1);
    
    %make W small relative to logit weights
    m.W{1} = zeros(size(data,2), m.layer_size(2)); 
    m.W{1}(:,1) = logit_m.B(2:end); %insert logit model
    for k = 2:m.layer_size(2)
        m.W{1}(:,k) = logit_m.B(2:end) .* (rand(size(m.W{1},1), 1) < 1/m.layer_size(2)) / 5;
    end
    
    
    m.B{1} = zeros(1, m.layer_size(2));
    m.B{1}(:) = logit_m.B(1);
    
    m.W{2} = randn(m.layer_size(2), size(labels,2)) / 10;
    m.W{2}(1,1) = 1;
    
    m.B{2} = zeros(1, size(labels,2));
    
%     nn_pred = m.infer_fxn(m, data);
    
    m = fit_NN(m, data, labels);
    
end