%time searching script

base_m = [];
% base_m = cell(3,1);
base_m{1} = default_model('nearest neighbors');
base_m{2} = default_model('logistic regression');
base_m{3} = default_model('RF');

held_out_ratio = .75;
num_resamples = 100;
% t_range = 0;
results = zeros(num_resamples, length(base_m));
example_m = cell(length(base_m),1);


for t = 1:num_resamples
    
    data = read_and_clean_data_for_random(-25:10);
        tic
    for m_num = 1:length(base_m)


        m = base_m{m_num};


        [results(t,m_num), dummy, example_m{m_num}] = test_model_validity(m, data.ret(:,1:35), data.ret(:,36), held_out_ratio, 1);
    end
        toc

    
    
end
