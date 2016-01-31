function m = fit_large_RF(m, data, labels)

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

    m.forest_name = char('a'+floor(rand(1,10) * 26));
    m.forest_fn = cell(num_forests,1);
    forest_dir = ['../data/' m.forest_name '/'];
    if ~exist(forest_dir,'dir')
        mkdir(forest_dir);
    end
    
    RF_m = default_model('RF');
    
    for n = 1:num_forests
        if n ~= num_forests
            data_picks = rand_list((n-1)*samps_per_forest + (1:samps_per_forest));
        else
            data_picks = rand_list((n-1)*samps_per_forest + 1 : end);
        end
        tic
        picked_data = data(data_picks,:);
        picked_labels = labels(data_picks,:);        
        
        sub_m = RF_m.fit_fxn(m, picked_data, picked_labels);
%         forest = classRF_train(picked_data,picked_labels,m.ntree);
        

        disp(['forest ' num2str(n) ' of ' num2str(num_forests) ' trained in ' num2str(toc)])
        m.forest_fn{n} = [forest_dir 'forest_' num2str(n) '.mat'];
        save(m.forest_fn{n}, 'sub_m');
    end
end
    