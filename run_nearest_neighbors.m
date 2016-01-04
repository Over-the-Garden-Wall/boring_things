function prediction = run_nearest_neighbors(m, data)
    %naive implementation, O(num_training_points*num_inference_points*d)
    
    prediction = zeros(size(data,1), size(m.labels,2));

    
    for n = 1:size(data,1)
        dists = zeros(size(m.label_points,1), 1);
        for d = 1:size(data,2)
            dists = dists + (data(n,d) - m.label_points(:,d)).^2;
        end
        dists = sqrt(dists);
        [dummy, nearest_ind] = min(dists);
        
        prediction(n,:) = sign(m.labels(nearest_ind, :));
    end
    
end
    