function Y_new = run_RF(m, data)

    Y_new = classRF_predict(data, m.forest);