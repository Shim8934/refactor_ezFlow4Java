package egovframework.ezEKP.ezAI.vo;

import java.util.List;
import java.util.Map;

public class AIPayloadVO {
    private String service;
    private String function;
    private List<Object> input_data;
    private Map<String, String> options;
    private Map<String, String> locale;

    // 기본 생성자
    public AIPayloadVO() {
    }

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public String getFunction() {
        return function;
    }

    public void setFunction(String function) {
        this.function = function;
    }

    public List<Object> getInput_data() {
        return input_data;
    }

    public void setInput_data(List<Object> input_data) {
        this.input_data = input_data;
    }

    public Map<String, String> getOptions() {
        return options;
    }

    public void setOptions(Map<String, String> options) {
        this.options = options;
    }

    public Map<String, String> getLocale() {
        return locale;
    }

    public void setLocale(Map<String, String> locale) {
        this.locale = locale;
    }

    @Override
    public String toString() {
        return "AIPayloadVO{" +
                "service='" + service + '\'' +
                ", function='" + function + '\'' +
                ", input_data.size=" + (input_data != null ? input_data.size() : "null") +
                ", options=" + options +
                ", locale=" + locale +
                '}';
    }
}