function mean_X = mean_nonan(X)
    mean_X = zeros(1,size(X,2));
    for n = 1:size(X,2);
        sub_X = X(:,n);
        mean_X(n) = mean(sub_X(~isnan(sub_X)));
    end
end
    