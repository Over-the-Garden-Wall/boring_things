function m = fit_logistic_regress(m, data, labels)
    
    is_valid = ~any(isnan(labels) | sign(labels) == 0, 2);
    labels = labels(is_valid);
    labels = sign(labels);
    labels(labels == -1) = 2;
    
    data = data(is_valid, :);
    
    ignored = max(0, size(data,2) - size(data,1) + 1);
    if ignored > 0
        data = data(:,ignored+1:end);
    end
    
    if m.interaction_distance ~= 0
        interaction_data = zeros(size(data)); 

        k = 0;
        for d = 1:size(data,2)
            if d + m.interaction_distance <= size(data,2)
                k = k+1;
                interaction_data(:,k) = ...
                    data(:,d) .* data(:, d + m.interaction_distance);
            end
        end
        data = [data interaction_data(:,1:k)];
    end
    
    [m.B, m.dev, m.stats] = mnrfit(data, labels);
    m.B = [m.B(1); zeros(ignored,1); m.B(2:end)];
end