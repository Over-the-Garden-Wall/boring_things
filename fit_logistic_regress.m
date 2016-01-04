function m = fit_logistic_regress(m, data, labels)
    
    is_valid = ~any(isnan(labels) | sign(labels) == 0, 2);
    labels = labels(is_valid);
    labels = sign(labels);
    labels(labels == -1) = 2;
    
    data = data(is_valid, :);
    
    interaction_data = zeros(size(data,1), ...
        size(data,2) * m.interaction_distance); %will be a couple extra entries
    k = 0;
    for d = 1:size(data,2)
        for dd = 1:m.interaction_distance
            if d + dd <= size(data,2)
                k = k+1;
                interaction_data(:,k) = ...
                    data(:,d) .* data(:, d + dd);
            end
        end
    end
    interaction_data(:,k+1:end) = [];
       
    
    [m.B, m.dev, m.stats] = mnrfit([data interaction_data], labels);
    
end