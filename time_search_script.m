%time searching script

base_m = cell(3,1);
base_m{1} = default_model('nearest_neighbors');
base_m{2} = default_model('logistic regression');
base_m{3} = default_model('RF');


held_out_ratio = .75;
num_sims = 25;
t_range = -5:25;
results = zeros(num_sims, length(t_range));

for m_num = 1:length(base_m)

    for t = 1:length(t_range);

        tn = t_range(t) + 26;

        m = base_m{m_num};

        tic
    %     results(:,t) = test_model_validity(m, data.resid_ret(:,1:tn-1), data.resid_ret(:,tn), .8, num_sims);
        results(:,t) = test_model_validity(m, data.ret(:,1:tn-1), data.ret(:,tn), held_out_ratio, num_sims);
        toc
    end

    figure; hold all;

    res_mean = mean(results);
    res_std = std(results);

    h = area(t_range, [res_mean' - 2*res_std', 4*res_std']);
    delete(h(1));
    plot(t_range, res_mean, 'k', 'lineWidth', 2);
    plot(t_range, .5*ones(size(t_range)), ':k');

    title(m.model_name);
end
