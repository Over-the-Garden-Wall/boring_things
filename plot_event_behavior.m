function plot_out = plot_event_behavior(signals, events, time_bins)

    [event_s, event_t] = find(events==0);
    num_events = length(event_s);
    
    plot_out = zeros(num_events, length(time_bins));
    
    min_time = min(time_bins);
    max_time = max(time_bins);
    
    %pad data to avoid boundary problems
    signals = pad_data_nans(signals, ...
        max(0, 1 - min(event_t) - min_time), ...
        max(0, max(event_t) + max_time - size(signals,2)));
        
    
    for n = 1:num_events
        plot_out(n,:) = signals(event_s(n), event_t(n) + (time_bins));
    end
    
    plot(time_bins, plot_out);
    hold all;
    plot(time_bins, mean_nonan(plot_out), 'k', 'lineWidth', 2) 
    
end
            
            