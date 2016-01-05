function [inference_accuracy, fit_accuracy, m] = test_model_validity(m, samples, labels, proportion4training, num_sims)

    if ~exist('num_sims','var')
        num_sims = 0;
    end

    is_invalid = any(isnan(labels),2);
    labels(is_invalid,:) = [];

    samples(is_invalid,:) = [];
    samples(isnan(samples)) = 0;

    num_total_samples = size(samples,1);
    inference_accuracy = zeros(num_sims,1);
    fit_accuracy = zeros(num_sims,1);
    
    base_m = m;
    
    
    for t = 1:num_sims

        rand_list = randperm(num_total_samples);
       
        for_training = rand_list(1:ceil(num_total_samples * proportion4training));
        training_input = samples(for_training,:);
        training_label = sign(labels(for_training,:));
        training_input(training_label(:,1) == 0,:) = [];
        training_label(training_label(:,1) == 0,:) = [];

        m = base_m;
        m = m.fit_fxn(m, training_input, training_label);

        for_testing = rand_list(1 + ceil(num_total_samples * proportion4training) : end);
        test_input = samples(for_testing,:);
        test_label = sign(labels(for_testing,:));

        test_input(test_label(:,1) == 0,:) = [];
        test_label(test_label(:,1) == 0,:) = [];


        prediction = m.infer_fxn(m, training_input);
        fit_accuracy(t) = sum(prediction==training_label & prediction~= 0) / ...
            sum(prediction~= 0);


        prediction = m.infer_fxn(m, test_input);
        inference_accuracy(t) = sum(prediction==test_label) / ...
            size(test_label,1); 
    
    end
    
end
    
    