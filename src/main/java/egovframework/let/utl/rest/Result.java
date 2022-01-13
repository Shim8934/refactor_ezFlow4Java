package egovframework.let.utl.rest;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

/**
 * HTTP API 리턴 값으로 사용할 수 있는 DTO이다.<br>
 * 
 * <p>
 * 성공 리턴: {@link Result#success()}, {@link Result#success(data)},
 * {@link Result#successWithCode(code)}, {@link Result#success(code, data)}<br>
 * 실패 리턴: {@link Result#failure()}, {@link Result#failure(data)},
 * {@link Result#failureWithCode(code)}, {@link Result#failure(code, data)}
 * </p>
 * <p>
 * Result 객체에서 성공 여부는<br>
 * {@link Result#succeeded()} 또는 {@link Result#failed()}로 판단할 수 있다.
 * </p>
 * Rest 빌더를 사용하여 GW 에서 간단히 가져올 수도 있다:
 * {@link Rest.RestBuilder#exchangeResult()}<br>
 * GW 리턴 값이 비어있거나 JSON 형식의 문자열이라면 Result 객체로 받아올 수 있으며<br>
 * 이 때의 기본값은 <code>{"status":null,"code":0,"data":null}</code> 이다.
 * 
 * <pre class="code">
 * &#64;Autowired
 * private Rest rest;
 * 
 * &#64;RequestMapping(value = "/example")
 * &#64;ResponseBody
 * public Result example(HttpServletRequest request) throws Exception {
 * 	return rest.gateway(Module.WEBFOLDER, request)
 * 			.url("/rest/ezwebfolder/test")
 * 			.exchangeResult();
 * }
 * </pre>
 */
public class Result {

	private static final Gson GSON = new Gson();

	private static final String SUCCESS = "ok";
	private static final String ERROR = "error";

	private static final int DEFAULT_SUCCESS_CODE = 0;
	private static final int DEFAULT_FAILURE_CODE = 1;

	private String status;
	private int code;
	private Object data;

	public Result() {}

	public Result(String status, int code, Object data) {
		this.status = status;
		this.code = code;
		this.data = data;
	}

	/**
	 * 성공에 대한 결과를 반환한다.
	 * 
	 * @return <code>{"status":"ok", "code":0, "data":null}</code>
	 */
	public static Result success() {
		return success(null);
	}

	/**
	 * data 값과 함께 성공에 대한 결과를 반환한다.
	 * 
	 * @return <code>{"status":"ok", "code":0, "data":...}</code>
	 */
	public static Result success(Object data) {
		return success(DEFAULT_SUCCESS_CODE, data);
	}

	/**
	 * code 값과 함께 성공에 대한 결과를 반환한다.
	 * 
	 * @return <code>{"status":"ok", "code":..., "data":null}</code>
	 */
	public static Result successWithCode(int code) {
		return success(code, null);
	}

	/**
	 * 구체적인 code 및 data 값과 함께 성공에 대한 결과를 반환한다.
	 * 
	 * @return <code>{"status":"ok", "code":..., "data":...}</code>
	 */
	public static Result success(int code, Object data) {
		return new Result(SUCCESS, code, data);
	}

	/**
	 * 실패에 대한 결과를 반환한다.
	 * 
	 * @return <code>{"status":"error","code":1,"data":null}</code>
	 */
	public static Result failure() {
		return failure(null);
	}

	/**
	 * data 값과 함께 실패에 대한 결과를 반환한다.
	 * 
	 * @return <code>{"status":"error","code":1,"data":...}</code>
	 */
	public static Result failure(Object data) {
		return failure(DEFAULT_FAILURE_CODE, data);
	}

	/**
	 * code 값과 함께 실패에 대한 결과를 반환한다.
	 * 
	 * @return <code>{"status":"error","code":...,"data":null}</code>
	 */
	public static Result failureWithCode(int code) {
		return failure(code, null);
	}

	/**
	 * 구체적인 code 및 data 값과 함께 실패에 대한 결과를 반환한다.
	 * 
	 * @return <code>{"status":"error", "code":..., "data":...}</code>
	 */
	public static Result failure(int code, Object data) {
		return new Result(ERROR, code, data);
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public Object getData() {
		return data;
	}

	public void setData(Object data) {
		this.data = data;
	}

	public <T> T getData(Class<T> clazz) {
		return clazz.cast(data);
	}

	@JsonIgnore
	public JsonElement getDataAsJsonElement() {
		return GSON.toJsonTree(data);
	}

	@JsonIgnore
	public JsonObject getDataAsJsonObject() {
		return getDataAsJsonElement().getAsJsonObject();
	}

	/** @return status 코드가 ok 라면 true, 아니면 false */
	public boolean succeeded() {
		return "ok".equalsIgnoreCase(status);
	}

	/** @return status 코드가 ok 라면 false, 아니면 true */
	public boolean failed() {
		return !succeeded();
	}

	@Override
	public String toString() {
		return "Result [status=" + status + ", code=" + code + ", data=" + data + "]";
	}

}
