function data = pad_data_nans(data, l_pad, r_pad)
    data_sz = size(data,1);
    data = [nan(data_sz, l_pad), data, nan(data_sz, r_pad)];
end