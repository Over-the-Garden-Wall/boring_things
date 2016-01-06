function m = fit_NN(m, training_samples, labels)
    
    training_labels = sign(labels);    
    
    m.layer_size(1) = size(training_samples,2);
    m.layer_size(end) = size(training_labels,2);
    
    if ~isfield(m, 'W');
        m.W = cell(m.num_layers,1);
        m.B = cell(m.num_layers,1);
    
        for l = 1:m.num_layers+1
            m.W{l} = .1 * randn(m.layer_size(l), m.layer_size(l+1));
            m.B{l} = .1 * randn(1, m.layer_size(l+1));
        end
    end
    
    m.train_E = zeros(m.minibatch_size, m.layer_size(end), m.num_iterations);
    
    Y = cell(m.num_layers+1,1);
    dEdW = cell(m.num_layers+1,1);
    dEdB = cell(m.num_layers+1,1);
    for l = 1:m.num_layers+1;
        dEdW{l} = zeros(size(m.W{l}));
        dEdB{l} = zeros(m.minibatch_size, size(m.B{l}, 2));
    end
    
    
    for t = 1:m.num_iterations
        
        %picking without replacement to allow for batch training
        sample_list = randperm(size(training_samples,1));
        samples_picked = sample_list(1:m.minibatch_size);
        
        
        
        %forward pass
        Y{1} = training_samples(samples_picked,:);
        for l = 1:m.num_layers+1
            Y{l+1} = m.f(Y{l} * m.W{l} + ones(size(Y{l},1), 1) * m.B{l});
        end
        
        m.train_E(:, :, t) = m.Ef(Y{end}, training_labels(samples_picked, :));
        
        %backward pass
        dEdB{end} = m.df(Y{end}).*m.dEf(Y{end}, training_labels(samples_picked, :));
        for l = m.num_layers+1:-1:1
            dEdW{l} = Y{l}' * dEdB{l} + m.momentum * dEdW{l};
            if l > 1
                dEdB{l-1} = m.df(Y{l}) .* (dEdB{l} * m.W{l}') + m.momentum * dEdB{l-1};
            end
        end
        
        
        
        
        %gradient pass
        for l = 1:m.num_layers+1
            m.W{l} = m.W{l} - dEdW{l} * m.learning_rate / m.minibatch_size;
            m.B{l} = m.B{l} - sum(dEdB{l},1) * m.learning_rate / m.minibatch_size;
        end
        
    end
end
