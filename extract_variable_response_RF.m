function [response_functions, fxn_x, fxn_y] = extract_variable_response_RF(m, data, labels, num_forests, p_per_forest, p_in_fxn)
    
    dependence = cell(num_forests, size(data,2));
    response_functions = cell(size(data,2),1);
    
    for f = 1:num_forests
        new_m = m.fit_fxn(m, data, labels);
        dependence(f, :) = RF_partial_dependence(new_m, data, p_per_forest);    
    end
    
    for x = 1:size(data,2)
        [response_functions{x}, fxn_x{x}, fxn_y{x}] = combine_dependences(dependence(:,x), p_in_fxn);
    end
    
end

function [comb_f, fxn_x, fxn_y] = combine_dependences(xy_cell, p_in_fxn)

    individual_f = cell(length(xy_cell),1);
    min_x = Inf;
    max_x = -Inf;
    
    for n = 1:length(xy_cell)
        min_x = min([min_x; xy_cell{n}(:,1)]);
        max_x = max([max_x; xy_cell{n}(:,1)]);

        xy_cell{n} = [-Inf, xy_cell{n}(1,2); xy_cell{n}; Inf, xy_cell{n}(end,2)];
        
        individual_f{n} = @(x) (interp1(xy_cell{n}(:,1), xy_cell{n}(:,2), x));
    end
    
    fxn_x = min_x:(max_x-min_x)/(p_in_fxn-1):max_x;
    fxn_y = zeros(size(fxn_x));
    
    for n = 1:length(xy_cell);
        fxn_y = individual_f{n}(fxn_x)/length(xy_cell) + fxn_y;
    end
    
    fxn_x = [-Inf, fxn_x, Inf];
    fxn_y = fxn_y([1 1:end end]);
    comb_f = @(x, fxn_x, fxn_y) (interp1(fxn_x, fxn_y, x));
    
end
    
    
    

    
    
    
    