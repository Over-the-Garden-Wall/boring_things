function [ret_data, beta] = remove_market_beta(ret_data)
    market_ret = single(mean_nonan(ret_data));
    sig_market = std_nonan(market_ret');
    sig_data = std_nonan(ret_data')';
    
    beta = zeros(size(ret_data,1),1);
    
    for n = 1:size(ret_data,1)
        is_valid = ~isnan(ret_data(n,:));
        if any(is_valid)
            rho = corr([market_ret(is_valid)', ret_data(n,is_valid)']);
            beta(n) = rho(2,1) * (sig_data(n) / sig_market);
            ret_data(n,:) = ret_data(n,:) - beta(n) * market_ret;
        end
    end
    
end