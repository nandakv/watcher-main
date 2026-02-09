package com.privo.creditsaison.data_cloud;

import java.util.HashMap;
import java.util.Map;

public class DataCloudResult {
    final boolean result;
    final String message;

    public DataCloudResult(boolean result, String message) {
        this.result = result;
        this.message = message;
    }

    public Map<String, ?> getResult() {
        Map<String, Object> value = new HashMap<>();
        value.put("result", this.result);
        value.put("message", this.message);
        return value;
    }

}
