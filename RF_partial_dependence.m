function dependence = RF_partial_dependence(m, data, num_points)

    dependence = cell(size(data,2),1);

    for d = 1:size(data,2)
        tic
        
        minval = min(data(:,d));       
        maxval = max(data(:,d));       
        
        x_vals = minval : (maxval-minval)/(num_points-1) : maxval;
        
        dependence{d} = zeros(num_points, 2);
        dependence{d}(:,1) = x_vals;
        
        for v = 1:length(x_vals)
            data_copy = data;
            data_copy(:,d) = x_vals(v);
            
            prediction = run_RF(m, data_copy);

            dependence{d}(v,2) = mean(prediction);
        end
        
        disp(['dimension ' num2str(d) ' analyzed in ' num2str(toc) ' seconds.']);
    end
end

    