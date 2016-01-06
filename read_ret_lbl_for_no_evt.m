function data = read_ret_lbl_for_no_evt(v_length)

    alldata = read_hdf5_into_struct('./data.h5');
    alldata.ret(all(isnan(alldata.ret),2),:) = [];
    
    alldata.ret(isnan(alldata.ret)) = 0;
    
    num_reps = size(alldata.ret,2) - v_length;
    
    data.ret = zeros(size(alldata.ret,1) * num_reps, v_length);
    data.labels = zeros(size(data.ret,1), 1);
    
    for t = 1:num_reps
        data.ret((t-1) * num_reps + (1:size(alldata.ret,1)),:) = ...
            alldata.ret(:, t - 1 + (1:v_length));
        data.labels((t-1) * num_reps + (1:size(alldata.ret,1))) = ...
            sign(alldata.ret(:, t + v_length));
    end
    
    data.ret(data.labels==0,:) = [];
    data.labels(data.labels==0) = [];
    
end