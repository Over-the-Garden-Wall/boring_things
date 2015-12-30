function [phi, c, eta] = autoregress(v, t)

    c = mean(v);
    v = v - c;

    inds = (1:length(v) - t)';
    
    ind_mat = zeros(length(inds), t+1);
    ind_mat(:,1) = inds;
    for k = 2:t+1
        ind_mat(:,k) = ind_mat(:,k-1) + 1;
    end
    
    X = v(ind_mat(:,1:t)); 
    y = v(ind_mat(:,end));
    if size(y,1) == 1
        y = y';
    end
    
    phi = regress(y, X);
    eta = X*phi - c - y;
    
end
    
    
