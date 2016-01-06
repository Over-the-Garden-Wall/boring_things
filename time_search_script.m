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
t_range = -10:20;
v_length = 25;
inference_accuracy = zeros(num_sims, length(t_range));
fit_accuracy = zeros(num_sims, length(t_range));
fit_models = cell(num_sims, length(t_range));


for m_num = 1:length(base_m)

    for t = 1:length(t_range);

        m = base_m{m_num};

        tic
        [inference_accuracy(:,t), fit_accuracy(:,t), fit_models(:,t)] ...
            = test_model_validity(m, data.ret(:,t + (0:v_length-1)), data.ret(:,t+v_length), held_out_ratio, num_sims);
        toc
        
        %trees are big
        if strcmp(base_m{m_num}.model_name, 'RF')
            for k = 1:size(fit_models,1)
                fit_models{k,t}.forest = fit_models{k,t}.forest.importance;
            end
        end
    end

    save(['../data/time_search_' base_m{m_num}.model_name '.mat'], 'inference_accuracy', 'fit_accuracy', 'fit_models');
end
