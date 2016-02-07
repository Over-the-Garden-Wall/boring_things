function [evt_accuracy, non_evt_accuracy, models] = test_baseline_model(base_model, num_fits, training_ratio)    

    data = read_and_clean_data(2);
    all_non_evt = isnan(data.evt) & data.bin_label ~= 0;

    evt_vals = unique(data.evt(:))';
    evt_vals(isnan(evt_vals)) = [];
        
    models = cell(num_fits,1);
    non_evt_accuracy = zeros(num_fits,1);
    evt_accuracy = zeros(num_fits,length(evt_vals));
    
    
    non_evt_inputs = data.input(all_non_evt,:);
    non_evt_labels = data.bin_label(all_non_evt);    
    
    for n = 1:num_fits        
        tic;
        r = randperm(size(non_evt_inputs, 1));
        for_training = r(1:floor(length(r) * training_ratio)); 
        for_testing = r(floor(length(r) * training_ratio)+1:end); 
        
        
        training_input = non_evt_inputs(for_training, :);
        training_labels = non_evt_labels(for_training, :);

        models{n} = base_model.fit_fxn(base_model, training_input, training_labels);
      
        prediction = models{n}.infer_fxn(models{n}, non_evt_inputs(for_testing, :));
        non_evt_accuracy(n) = mean(prediction == non_evt_labels(for_testing,:));
        
        
        for evt_t_n = 1:length(evt_vals)
            evt_t = evt_vals(evt_t_n);
            is_evt_t = data.evt == evt_t & data.bin_label ~= 0;
            prediction = models{n}.infer_fxn(models{n}, data.input(is_evt_t, :));
            evt_accuracy(n, evt_t_n) = mean(prediction == data.bin_label(is_evt_t));

        end
        
        disp(['Model #' num2str(n) ' of ' num2str(num_fits) ' finished in ' num2str(toc) ' seconds.']);
    end
    
    

end
