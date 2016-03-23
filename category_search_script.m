
held_out_ratio = .75;
num_sims = 5;

input_length = 25;

models = [];
% for k = 1:5
%     base_m{k} = default_model('logistic regression');
%     base_m{k}.interaction_distance = k-1;
%     base_m{k}.model_name = ['logreg_t' num2str(k-1)];
% end
% base_m{end+1} = default_model('nearest neighbors');
models{end+1} = default_model('NN logit');
models{end+1} = default_model('logistic regression');


data = read_and_clean_data(input_length, false);
is_invalid = data.bin_label == 0 | data.equity == 1866 | data.equity == 1977;
fns = fieldnames(data);
for k = 1:length(fns)
    data.(fns{k})(is_invalid,:) = [];
end


categories = [];
cap_vals = [0 400 1360 4700 Inf];
clfs = unique(data.clf(:));
for t = 0
%     for k = 1:length(clfs)
%         categories{end+1} = eval(['@(x) (x.mktcap > ' num2str(cap_vals(k)) ' & x.mktcap < ' num2str(cap_vals(k+1)) ' & x.evt == ' num2str(t) ')']);
%         categories{end+1} = eval(['@(x) (x.clf == ' num2str(clfs(k)) ' & x.evt == ' num2str(t) ')']);
%     end
    categories{end+1} = eval(['@(x) (x.evt == ' num2str(t) ')']);
end
% categories{end+1} = eval(['@(x) (~isnan(x.evt))']);

tv = zeros(length(categories),1);
for c = 1:length(categories)
    my_cat = categories{c};
    is_valid = my_cat(data);
    input_samples = data.input(is_valid,:); %data.mktcap(is_valid)];
    labels = data.bin_label(is_valid);
    
    
    for m_num = 1:length(models)
        m = models{m_num};


        tic
        [inference_accuracy, fit_accuracy, fit_models] ...
            = test_model_validity(m, input_samples, labels, held_out_ratio, num_sims);
        toc
        tv(c) = mean(inference_accuracy);
        disp(my_cat);
        disp(mean(inference_accuracy));
        
        save(['../data/models/model_' num2str(round(100000*rand)) '.mat'], '-v7.3', 'inference_accuracy', 'fit_accuracy', 'fit_models', 'my_cat');
%         
%         warning('hack in place');
%         Bs = zeros(27,10);
%         for k = 1:length(fit_models); Bs(:,k) = fit_models{k}.forest.importance; end
%         figure; plot_means_and_std(1:size(Bs,1), mean(Bs, 2)+10, std(Bs,[], 2));
    end
    
end
