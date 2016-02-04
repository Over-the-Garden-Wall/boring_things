function plot_means_and_std(x, Y, Yerr)
    
    hold all;
    col = colormap('Lines');
    
    for n = 1:size(Y,2)
        
        h = area(x, [Y(:,n) - Yerr(:,n), 2 * Yerr(:,n)]);
        delete(h(1));
        set(h(2), 'EdgeColor', (col(n,:) + [1 1 1])/2);
        set(h(2), 'FaceColor', (col(n,:) + [1 1 1])/2);
        
    end
    
    for n = 1:size(Y,2)
        
        plot(x, Y(:,n), 'Color', col(n,:), 'lineWidth', 2)
        
    end
    
end
    