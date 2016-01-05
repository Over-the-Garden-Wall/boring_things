function plot_stacked_areas(x, Y, category_labels)

    maxY = max(abs(Y(:)));
    if any(Y(:) < 0)
        maxY = maxY*2;
    end
    Y = Y / maxY;
    
    plot_Y = zeros(size(Y).*[1 2]);
    plot_Y(:,1:2:end) = Y;
    plot_Y(:,2:2:end) = 1 - plot_Y(:,1:2:end);
    
    h = area(x, plot_Y);
    delete(h(2:2:end));
    
    set(gca, 'YTick', 0:size(Y,1)-1, 'YTickLabel', category_labels);
end
            
            