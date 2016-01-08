function m = fit_RF(m, data, labels)

%     param_names = fieldnames(m.params);
%     
%     param_in = cell(1,length(param_names)*2);
%     for k = 1:length(param_names)
%         param_in{k*2 - 1} = param_names{k};
%         param_in{k*2} = m.params.(param_names{k});
%     end
    num_samples = size(data,1);

    num_forests = ceil(num_samples/m.max_samples_per_forest);
    samps_per_forest = round(num_samples/num_forests);
    rand_list = randperm(num_samples);

    for n = 1:num_forests
        data_picks = rand_list((n-1)*samps_per_forest + (1:samps_per_forest));
        m.forest{n} = classRF_train(data(data_picks,:),labels(data_picks,:),m.ntree);
    end
end
    