function m = fit_nearest_neighbors(m, data, labels)
    %the smart thing to do would be to organize data into a k-d tree for
    %fast querying, but the run-time will be within a few seconds
    %regardless, so I'm going to save time with a naive implementation
    
    
    m.label_points = data;
    m.labels = labels;
    
end
    

    