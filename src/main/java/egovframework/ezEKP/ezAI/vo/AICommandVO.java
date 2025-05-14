package egovframework.ezEKP.ezAI.vo;

import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonProperty;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AICommandVO {
    private static final Logger logger = LoggerFactory.getLogger(AICommandVO.class);

    // JSON 구조와 매핑되는 필드
    private String service;
    private String function;
    private List<Map<String, Object>> input_data;
    private Map<String, String> options; // 최상위 옵션 필드

    // 기존 필드 (하위 호환성 유지)
    private String command;
    private String purpose;
    private String length;
    private String tone;
    @JsonProperty("target_language")
    private String targetLanguage;
    private Map<String, Object> inputData;
    
    // getters/setters
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

    public List<Map<String, Object>> getInput_data() {
        return input_data;
    }

    public void setInput_data(List<Map<String, Object>> input_data) {
        this.input_data = input_data;
    }

    public Map<String, String> getOptions() {
        return options;
    }

    public void setOptions(Map<String, String> options) {
        this.options = options;

        // options에서 command 값 동기화 (하위 호환성)
        if (options != null && options.containsKey("command")) {
            this.command = options.get("command");
        }
    }

    // 기존 필드 getters/setters
    public String getCommand() {
        // options에서 우선 확인, 없으면 기존 필드 반환
        if (options != null && options.containsKey("command")) {
            return options.get("command");
        }
        return command;
    }

    public void setCommand(String command) {
        this.command = command;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    public String getLength() {
        return length;
    }

    public void setLength(String length) {
        this.length = length;
    }

    public String getTone() {
        return tone;
    }

    public void setTone(String tone) {
        this.tone = tone;
    }

    public String getTargetLanguage() {
        return targetLanguage;
    }

    public void setTargetLanguage(String targetLanguage) {
        this.targetLanguage = targetLanguage;
    }

    public Map<String, Object> getInputData() {
        return inputData;
    }

    public void setInputData(Map<String, Object> inputData) {
        this.inputData = inputData;
    }

    @Override
    public String toString() {
        return "AICommandRequestVO{" +
                "service='" + service + '\'' +
                ", function='" + function + '\'' +
                ", input_data.size=" + (input_data != null ? input_data.size() : "null") +
                ", options=" + options +
                ", command='" + command + '\'' +
                '}';
    }
}