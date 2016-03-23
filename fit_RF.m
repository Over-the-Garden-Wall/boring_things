function m = fit_RF(m, data, labels)

%     param_names = fieldnames(m.params);
%     
%     param_in = cell(1,length(param_names)*2);
%     for k = 1:length(param_names)
%         param_in{k*2 - 1} = param_names{k};
%         param_in{k*2} = m.params.(param_names{k});
%     end
    p = [];
    p.nodesize = ceil(size(data,1) / m.max_nodes * 2);
    m.forest = classRF_train(data,labels,m.ntree, 0, p);
   
end
    