%time searching script

base_m = [];
% for k = 1:5
%     base_m{k} = default_model('logistic regression');
%     base_m{k}.interaction_distance = k-1;
%     base_m{k}.model_name = ['logreg_t' num2str(k-1)];
% end
% base_m{end+1} = default_model('nearest neighbors');
base_m{end+1} = default_model('RF');



held_out_ratio = .75;
num_sims = 10;
t_range = -20:10;
input_length = 25;

data = read_and_clean_data_for_evt(-20:10, input_length);

inference_accuracy = zeros(num_sims, length(base_m));
fit_accuracy = zeros(num_sims, length(base_m));
fit_models = cell(num_sims, length(base_m));


for t = 1:length(t_range);
    input_samples = [data.mktcap(data.t==t_range(t),:), data.ret(data.t==t_range(t),:)];
    labels = data.label(data.t==t_range(t));
    
    
    for m_num = 1:length(base_m)

        m = base_m{m_num};

        tic
        [inference_accuracy(:,m_num), fit_accuracy(:,m_num), fit_models(:,m_num)] ...
            = test_model_validity(m, input_samples, labels, held_out_ratio, num_sims);
        toc
        
    end

    
end
save(['../data/RF_models_t' num2str(t) '_' num2str(10000*rand) '.mat'], '-v7.3', 'inference_accuracy', 'fit_accuracy', 'fit_models');