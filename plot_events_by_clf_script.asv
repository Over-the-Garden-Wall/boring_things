%plot events by group classifier
uni_clf = unique(data.clf(:,1));
time_bins = -5:5;


for c = uni_clf'
    figure;
    is_me = data.clf(:,1) == c;
    
    plot_event_behavior(data.resid_ret(is_me,:), data.evt(is_me,:), time_bins);        
    title(num2str(c));        
    
    plot_event_behavior(data.resid_ret(is_me,:), data.evt(is_me,:), time_bins);        
    title(num2str(c));        
    
end

