
base_m = [];
% for k = 1:5
%     base_m{k} = default_model('logistic regression');
%     base_m{k}.interaction_distance = k-1;
%     base_m{k}.model_name = ['logreg_t' num2str(k-1)];
% end
% base_m{end+1} = default_model('nearest neighbors');
base_m{end+1} = default_model('RF');


held_out_ratio = .75;
num_sims = 100;
v_length = 25;

inference_accuracy = zeros(num_sims, length(base_m));
fit_accuracy = zeros(num_sims, length(base_m));
% fit_models = cell(num_sims, length(base_m));

    
data = read_ret_lbl_for_no_evt(v_length);

for m_num = 1:length(base_m)
    tic


    m = base_m{m_num};


    [inference_accuracy(:,m_num), fit_accuracy(:, m_num)] = test_model_validity(m, data.ret, data.labels, held_out_ratio, num_sims);
    toc
end

    
    

