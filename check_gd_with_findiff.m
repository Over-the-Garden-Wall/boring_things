function [dB dW] = check_gd_with_findiff(m, input, label)

    dB = m.B;
    dW = m.W;
    
    
    m.binary_prediction = false;
    
    out = m.infer_fxn(m, input);
    tE = m.Ef(out, label);
    E = sum(tE(:));
    
    
    delta = .001;
    
    for l = 1:length(dB);
        for k = 1:numel(dB{l});
            m.B{l}(k) = m.B{l}(k) + delta;

            out = m.infer_fxn(m, input);
            tE = m.Ef(out, label);

            Ep = sum(tE(:));
            
            m.B{l}(k) = m.B{l}(k) - delta;
            dB{l}(k) = (Ep - E) / delta;
        end
    end
    
    for l = 1:length(dW);
        for k = 1:numel(dW{l});
            m.W{l}(k) = m.W{l}(k) + delta;

            out = m.infer_fxn(m, input);
            tE = m.Ef(out, label);

            Ep = sum(tE(:));
            
            m.W{l}(k) = m.W{l}(k) - delta;
            dW{l}(k) = (Ep - E) / delta;
        end
    end
    
    