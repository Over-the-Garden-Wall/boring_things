function [inference_accuracy, fit_accuracy, m] = test_model_validity(base_m, samples, labels, proportion4training, num_sims)

    if ~exist('num_sims','var')
        num_sims = 1;
    end

    is_invalid = any(isnan(labels),2);
    labels(is_invalid,:) = [];

    if length(unique(labels)) <= 1
        warning('not enough unique labels');
        inference_accuracy = 0;
        fit_accuracy = 0;
        m = base_m;
        return
    end
    
    samples(is_invalid,:) = [];
    samples(isnan(samples)) = 0;

    num_total_samples = size(samples,1);
    inference_accuracy = zeros(num_sims,1);
    fit_accuracy = zeros(num_sims,1);
    
	m = cell(num_sims,1);
    
    
    for t = 1:num_sims
        uni_training_label = 0;
        while length(uni_training_label) <= 1
            rand_list = randperm(num_total_samples);

            for_training = rand_list(1:ceil(num_total_samples * proportion4training));
            training_label = labels(for_training,:);
            
            uni_training_label = unique(training_label);
        end
        training_input = samples(for_training,:);
        
        m{t} = base_m;
        m{t} = m{t}.fit_fxn(m{t}, training_input, training_label);

        for_testing = rand_list(1 + ceil(num_total_samples * proportion4training) : end);
        test_input = samples(for_testing,:);
        test_label = sign(labels(for_testing,:));

        test_input(test_label(:,1) == 0,:) = [];
        test_label(test_label(:,1) == 0,:) = [];


        prediction = m{t}.infer_fxn(m{t}, training_input);
        fit_accuracy(t) = sum(prediction==training_label & prediction~= 0) / ...
            sum(prediction~= 0);


        prediction = m{t}.infer_fxn(m{t}, test_input);
        inference_accuracy(t) = sum(prediction==test_label) / ...
            size(test_label,1); 
    
    end
    
end
    
    