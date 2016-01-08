%time searching script

base_m = [];
for k = 1:5
    base_m{k} = default_model('logistic regression');
    base_m{k}.interaction_distance = k-1;
    base_m{k}.model_name = ['logreg_t' num2str(k-1)];
end
base_m{end+1} = default_model('nearest neighbors');
base_m{end+1} = default_model('RF');



held_out_ratio = .75;
num_sims = 20;
input_length = 25;

inference_accuracy = zeros(num_sims, length(base_m));
fit_accuracy = zeros(num_sims, length(base_m));
fit_models = cell(length(base_m),1);

data = read_and_clean_data_for_nonevt(-20:10, input_length);
input_samples = data.ret;
labels = data.label;
    
for s = 1:num_sims;
    
    
    for m_num = 1:length(base_m)

        m = base_m{m_num};

        tic
        [inference_accuracy(s,m_num), fit_accuracy(:,m_num), fit_models(m_num)] ...
            = test_model_validity(m, input_samples, labels, held_out_ratio, 1);
        toc
        
    end

    save(['../data/baseline_all_models_s' num2str(t) '.mat'], '-v7.3', 'inference_accuracy', 'fit_accuracy', 'fit_models');
end
