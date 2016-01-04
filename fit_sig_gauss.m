function m = fit_sig_gauss(m, data, labels)
    %custom function to fit each variable's behavior to the sum of a
    %sigmoid and the derivative of a gaussian. 
    %We find reasonable initial values using a sigmoid fit, and tune the parameters through
    %gradient descent.
    data(isnan(data)) = 0;
    data(isnan(labels),:) = [];
    labels(isnan(labels)) = [];
    
    m.c = zeros(7, size(data,2));
    m.f = @(x,c) (c(1) + c(2) * tanh(c(3) * (x - c(4))) + c(5) * (x - c(7)) .* exp(c(6) * (x - c(7)).^2));
    
    dfdc = cell(7,1);
    dfdc{1} = @(x, c) (1);
    dfdc{2} = @(x, c) (tanh(c(3) * (x - c(4))));
    dfdc{3} = @(x, c) (c(2) * (x - c(4)) .* (1 - tanh(c(3) * (x - c(4))).^2));
    dfdc{4} = @(x, c) (c(2) * -c(3) * (1 - tanh(c(3) * (x - c(4))).^2));
    
    dfdc{5} = @(x, c) ((x-c(7)) .* exp(c(6) * (x-c(7)).^2));
    dfdc{6} = @(x, c) (c(5) * (x - c(7)) .* (x - c(7)).^2 .* exp(c(6) * (x - c(7)).^2));
    dfdc{7} = @(x, c) (c(5) * (-exp(c(6) * (x - c(7)).^2) + ...
        (x - c(7)) .* exp(c(6) * (x - c(7)).^2) .* c(6) * -2 .* (x - c(7))));
    
    
    for d = 1:size(data,2)
        
        x = data(:,d);
        [x, sortord] = sort(x);
        
        y = labels(sortord);

        %our form: c1 + c2*tanh(c3*(x - c4)) + c5 * (x-c7) * exp(c6 * (x-c7).^2);
        %c6 must be negative
        
        sigm_params=sigm_fit(x,y, [], [], 0);
        % fsigm = @(param,xval) param(1)+(param(2)-param(1))./(1+10.^((param(3)-xval)*param(4)))
        % param = [min, max, x50, slope]
        
        m.c(1,d) = mean(sigm_params(1:2));
        m.c(2,d) = (sigm_params(2) - sigm_params(1))/2;
        m.c(3,d) = log(10) / 2 * sigm_params(4);
        m.c(4,d) = sigm_params(3);
%         m.c(4,d) = sigm_params(3);
        
        m.c(5,d) = .05; %something small
        m.c(6,d) = -1/2; 
        m.c(7,d) = m.c(4,d);
        
        eta = .001;
        deltac = zeros(size(m.c,1),1);

        for t = 1:1000 %change to convergence
            model_out = m.f(x, m.c(:,d));
            for p = 1:size(m.c,1)
                dydc = dfdc{p}(x, m.c(:,d));
                dEdf = 2 * (model_out - y);
                deltac(p) = sum(dEdf .* dydc);
            end            
            m.c(:,d) = m.c(:,d) + deltac * eta;            
            if m.c(6,d) > 0
                m.c(6,d) = 0;
            end
        end
    end
    
end
            

        
        
        
        
        
        
        
        
    
    
    