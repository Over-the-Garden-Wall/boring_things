function prediction = run_logistic_regress(m, data)
    data(isnan(data)) = 0;
    
    
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
    
    
    prediction = sign(data* m.B(2:end) + m.B(1));

end