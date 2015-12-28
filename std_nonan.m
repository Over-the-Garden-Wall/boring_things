function std_X = std_nonan(X)
    std_X = zeros(1,size(X,2));
    for n = 1:size(X,2);
        sub_X = X(:,n);
        std_X(n) = std(sub_X(~isnan(sub_X)));
    end
end
    