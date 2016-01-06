function m = default_model(model_name)

    m.model_name = model_name;
    if strcmp(model_name, 'NN')
        m.num_layers = 2;
        m.layer_size = [0 12 12 0];
        
        m.learning_rate = .01;
        m.num_iterations = 10^7;

        m.f = @(x) (tanh(x));
        m.df = @(y) (1 - y.^2);
                
        m.Ef = @(y, t) ((y-t).^2);
        m.dEf = @(y, t) (2.*(y-t)); 
%         m.Ef = @(y, t) (max( abs(t - y) - .5, 0)); %hinge loss at .5
%         m.dEf = @(y, t) ( double(abs(t-y) > .5) );
        
        m.minibatch_size = 20;
        
        m.momentum = .8;
        
%         m.fit_fxn = @fit_NN;
        m.fit_fxn = @fit_NN;
        m.infer_fxn = @run_NN;        
    elseif strcmp(model_name, 'NN logitinit')
        m = default_model('NN');
        m.layer_size(2) = 4;
        m.learning_rate = .001;
        m.minibatch_size = 100;
        m.num_iterations = 1000000;
        m.fit_fxn = @fit_NN_logit_init;
        m.infer_fxn = @run_NN;        
    elseif strcmp(model_name, 'nearest neighbors')
        m.fit_fxn = @fit_nearest_neighbors;
        m.infer_fxn = @run_nearest_neighbors;
    elseif strcmp(model_name, 'RF')
        m.ntree = 2000;
        
        m.fit_fxn = @fit_RF;
        m.infer_fxn = @run_RF;                
    elseif strcmp(model_name, 'logistic regression')        
        m.interaction_distance = 0;
        
        m.fit_fxn = @fit_logistic_regress;
        m.infer_fxn = @run_logistic_regress;        
    else
        error('Model name not recognized');
    end
    
end
    