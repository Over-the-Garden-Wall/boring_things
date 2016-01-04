%clf_search_script

base_m = default_model('logistic regression');

t = 38;
clf_types = unique(data.clf);

num_sims = 50;

results = zeros(num_sims, length(clf_types));

for c = 1:length(clf_types)

    m = base_m;

    
    samples = data.ret(data.clf == clf_types(c),1:t-1);
    labels = data.ret(data.clf == clf_types(c),t);
    
    tic
    try
        results(:,c) = test_model_validity(m, samples, labels, .75, num_sims);
    catch ME
        disp(ME.message);
    end
    toc
end