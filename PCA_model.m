function reward = PCA_model(data, max_components, test_proportion, threshold)

    if ~exist('threshold','var')
        threshold = 0;
    end

    data(isnan(data)) = 0;

    total_samples = size(data,1);
    rand_list = randperm(total_samples);
    
    test_samples = rand_list(1:ceil(total_samples*test_proportion));
    training_samples = rand_list(1+ceil(total_samples*test_proportion):end);
   
    pcs = princomp(data(training_samples, :));
    pcs = pcs(:, 1:max_components);
    
    reward = zeros(size(data(test_samples, :)));
    for t = max_components + 1 : size(data,2)
        
        data_up_to_now = data(test_samples,1:t-1);
        pcs_up_to_now = pcs(1:t-1,:);
        
        pc_fit = pcs_up_to_now \ data_up_to_now';
        
        predicted_ret = pcs(t,:) * pc_fit;
        predicted_ret(abs(predicted_ret)<threshold) = 0;
        
        %policy: buy a unit if positive, sell a unit if negative
        reward(:,t) = sign(predicted_ret').*data(test_samples,t);
    end
    
end