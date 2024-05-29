package egovframework.ezEKP.ezApprovalG.util;

import com.google.gson.*;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.*;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.*;

import static egovframework.ezEKP.ezApprovalG.util.Method.*;

/**
 * 한글 rest api 호출을 위한 클래스
 */
public class RestWHWP {
    private final String id;
    private static final String STRING = "String";
    private static final String BOOLEAN = "boolean";
    private static final int STATUS_INIT = 0;
    private static final int STATUS_OPEN = 1;
    private static final int STATUS_CLOSE = 2;
    private final String restURL;
    private String outPath;
    private int status;

    private final JsonObject data = new JsonObject();
    private final JsonArray fnArr = new JsonArray();
    private int fnOrder;

    public RestWHWP(String restURL) {
        this.id = UUID.randomUUID().toString();
        this.restURL = restURL;
        this.fnOrder = 1;
        this.status = STATUS_INIT;

        data.addProperty(Param.tid.toString(), id);
        data.addProperty(Param.type.toString(), "ap");
    }

    public RestWHWP open(String inFilePath) {
        if (status != STATUS_INIT) throw new IllegalStateException("open() must be called first");
        JsonArray parameterValueArr = new JsonArray();
        JsonObject val = new JsonObject();
        val.addProperty(Value.fileName.toString(), inFilePath);
        parameterValueArr.add(val);
        addFunc(open, new String[]{STRING}, parameterValueArr);
        this.status = STATUS_OPEN;
        return this;
    }

    public RestWHWP putText(String field, String text) {
        return putText(Collections.singletonList(field), Collections.singletonList(text));
    }

    public RestWHWP putText(List<String> field, List<String> text) {
        if (status != STATUS_OPEN) throw new IllegalStateException("putText() must be called on open state");

        // filed 와 text 가 여러개 일 경우, 구분자 \u0002 로 구분 됨.
        String fields = String.join("\u0002", field);
        String texts = String.join("\u0002", text);

        JsonArray parameterValueArr = new JsonArray();
        JsonObject val = new JsonObject();
        val.addProperty(Value.fieldList.toString(), fields);
        val.addProperty(Value.valueList.toString(), texts);
        val.add(Value.pDelimiter.toString(), null);
        parameterValueArr.add(val);
        addFunc(putFieldText, new String[]{STRING,STRING,STRING}, parameterValueArr);
        return this;
    }

    public RestWHWP putImg(String field, String path, String width, String height) {
        if (status != STATUS_OPEN) throw new IllegalStateException("putImg() must be called on open state");

        JsonArray parameterValueArr = new JsonArray();
        JsonObject data = new JsonObject();
        data.addProperty(ImageData.field.toString(), field);
        data.addProperty(ImageData.value.toString(), path);
        data.addProperty(ImageData.width.toString(), width);
        data.addProperty(ImageData.height.toString(), height);
        JsonObject val = new JsonObject();
        val.add(Value.data.toString(), data);
        parameterValueArr.add(val);
        addFunc(insertImageEx, new String[]{STRING}, parameterValueArr);
        return this;
    }

    public RestWHWP savePdf(String outFilePath) {
        if (outFilePath == null || outFilePath.trim().isEmpty()) {
            throw new IllegalArgumentException("outFilePath is empty");
        } else if (!StringUtils.substringAfterLast(outFilePath, ".").equalsIgnoreCase("pdf")) {
            throw new IllegalArgumentException("savePdf() outFilePath must be end with .pdf");
        }
        return save(savePdfDocument, outFilePath);
    }

    public RestWHWP saveHwp(String outFilePath) {
        if (outFilePath == null || outFilePath.trim().isEmpty()) {
            throw new IllegalArgumentException("outFilePath is empty");
        } else if (!StringUtils.substringAfterLast(outFilePath, ".").equalsIgnoreCase("hwp")) {
            throw new IllegalArgumentException("savePdf() outFilePath must be end with .hwp");
        }
        return save(saveHwpDocument, outFilePath);
    }

    private RestWHWP save(Method method, String outFilePath) {
        if (status != STATUS_OPEN) throw new IllegalStateException("save() must be called on open state");
        this.outPath = outFilePath; // tPath 를 위해 저장. 하나만 필요 하므로 마지막 outFilePath 만 저장
        JsonArray parameterValueArr = new JsonArray();
        JsonObject val = new JsonObject();
        val.addProperty(Value.filepath.toString(), outFilePath);
        val.addProperty(Value.lock.toString(), false);
        parameterValueArr.add(val);
        addFunc(method, new String[]{STRING, BOOLEAN}, parameterValueArr);
        return this;
    }

    public void flush() {
        if (status != STATUS_OPEN) throw new IllegalStateException("flush() must be called after open()");
        if (outPath == null) throw new IllegalStateException("save() must be called before flush()");

        // add tpath
        String tpath = StringUtils.substringBeforeLast(outPath, "/");
        data.addProperty(Param.tpath.toString(), tpath);

        // add close fnArr
        JsonArray emptyArr = new JsonArray();
        addFunc(close, new String[]{}, emptyArr);
        status = STATUS_CLOSE;

        // add data to body
        data.add(Param.func.toString(), fnArr);

        // send request java
        String json = new Gson().toJson(data);


        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON_UTF8);

        org.springframework.http.HttpEntity<?> entity = new HttpEntity<>(json, headers);
        UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(restURL)
                // 파라미터 들이 필요 하지 않지만 localhost_access_log 에 log 남기기 위해 추가
                .queryParam("uid", this.id)
                .queryParam("lastOutFile", StringUtils.substringAfterLast(outPath, "/"));

        RestTemplate rest = null;
        HttpComponentsClientHttpRequestFactory httpRequestFactory = new HttpComponentsClientHttpRequestFactory();
        httpRequestFactory.setConnectTimeout(4000);
        httpRequestFactory.setReadTimeout(8000);
        rest = new RestTemplate(httpRequestFactory);

        ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);

        if (result.getStatusCode() != HttpStatus.OK) {
            throw new RuntimeException("RestWHWP flush() error : " + result.getStatusCode() + " " + result.getBody());
        }

        // getbody 에서 json 파싱
        JsonObject response = null;
        try {
            response = new JsonParser().parse(result.getBody()).getAsJsonObject();

            // {"success":"true"} or {"success":"false"}
            if (!response.has("success") || !response.get("success").getAsString().equalsIgnoreCase("true")) {
                throw new RuntimeException("response : " + response);
            }
        } catch (JsonSyntaxException e) {
            throw new RuntimeException("response parsing error : " + result.getBody());
        }

    }

    private void addFunc(Method addMethod, String[] paramTypes, JsonArray parameterValueArr) {
        JsonObject json = new JsonObject();
        json.addProperty(Func.method.toString(), addMethod.toString());
        JsonArray paramArr = new JsonArray();
        for (String param : paramTypes) {
            paramArr.add(param);
        }
        json.add(Func.parameterTypes.toString(), paramArr);
        json.add(Func.parameterValues.toString(), parameterValueArr);
        json.addProperty(Func.order.toString(), fnOrder++);
        fnArr.add(json);
    }

    public String getRestURL() {
        return restURL;
    }

    public String getId() {
        return id;
    }

    public JsonObject getData() {
        return data;
    }

    public JsonArray getFnArr() {
        return fnArr;
    }

    public int getFnOrder() {
        return fnOrder;
    }

    public int getStatus() {
        return status;
    }
}
enum Func {
    method, parameterTypes, parameterValues, order
}

enum Method {
    open, close, savePdfDocument, saveHwpDocument, putFieldText, insertImageEx
}

enum Param {
    tid, tpath, func, type
}

enum Value {
    fileName, fieldList, valueList, pDelimiter, data, filepath, lock
}

enum ImageData {
    field, value, width, height
}