function data = read_hdf5_into_struct(fn)
    h5inf = hdf5info(fn);
    data = [];
    
    for n = 1:length(h5inf.GroupHierarchy.Datasets)        
        dset_name = h5inf.GroupHierarchy.Datasets(n).Name;
        data.(dset_name(2:end)) = hdf5read(fn, dset_name);
    end        
end