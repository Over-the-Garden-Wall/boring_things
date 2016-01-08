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
t_range = -20:10;
inference_accuracy = zeros(num_sims, length(base_m));
fit_accuracy = zeros(num_sims, length(base_m));
fit_models = cell(num_sims, length(base_m));


for t = 1:length(t_range);
    input_samples = data.ret(data.t==t_range(t),:);
    labels = data.label(data.t==t_range(t));
    
    
    for m_num = 1:length(base_m)

        m = base_m{m_num};

        tic
        [inference_accuracy(:,m_num), fit_accuracy(:,m_num), fit_models(:,m_num)] ...
            = test_model_validity(m, input_samples, labels, held_out_ratio, num_sims);
        toc
        
    end

    save(['../data/all_models_t' num2str(t) '.mat'], '-v7.3', 'inference_accuracy', 'fit_accuracy', 'fit_models');
end
