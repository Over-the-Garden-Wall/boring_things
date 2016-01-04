function prediction = run_logistic_regress(m, data)
    data(isnan(data)) = 0;
    
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
    
    prediction = sign([data interaction_data]* m.B(2:end) + m.B(1));

end