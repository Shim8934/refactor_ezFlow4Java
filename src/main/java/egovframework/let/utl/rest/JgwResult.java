package egovframework.let.utl.rest;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

/**
 * HTTP API 리턴 값으로 사용할 수 있는 DTO이다.<br>
 * 
 * <p>
 * 성공 리턴: {@link JgwResult#success()}, {@link JgwResult#success(data)},
 * {@link JgwResult#successWithCode(code)},
 * {@link JgwResult#success(code, data)}<br>
 * 실패 리턴: {@link JgwResult#failure()}, {@link JgwResult#failure(data)},
 * {@link JgwResult#failureWithCode(code)},
 * {@link JgwResult#failure(code, data)}
 * </p>
 * <p>
 * Result 객체에서 성공 여부는<br>
 * {@link JgwResult#succeeded()} 또는 {@link JgwResult#failed()}로 판단할 수 있다.
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
 * public JgwResult example(HttpServletRequest request) throws Exception {
 * 	return rest.jgw()
 * 			.url("/jMochaEzEmail/getMailTag")
 * 			.formParam("tagName", "test")
 * 			.exchangeJgwResult();
 * }
 * </pre>
 */
public class JgwResult {

	private static final Gson GSON = new Gson();

	private static final String SUCCESS = "OK";

	private String resultCode;
	private int reasonCode;
	private Object result;

	public JgwResult() {}

	public JgwResult(String resultCode, int reasonCode, Object result) {
		this.resultCode = resultCode;
		this.reasonCode = reasonCode;
		this.result = result;
	}

	public String getResultCode() {
		return resultCode;
	}

	public void setResultCode(String status) {
		this.resultCode = status;
	}

	public int getReasonCode() {
		return reasonCode;
	}

	public void setReasonCode(int code) {
		this.reasonCode = code;
	}

	public Object getResult() {
		return result;
	}

	public void setResult(Object result) {
		this.result = result;
	}

	public <T> T getResult(Class<T> clazz) {
		return clazz.cast(result);
	}

	@JsonIgnore
	public JsonElement getResultAsJsonElement() {
		return GSON.toJsonTree(result);
	}

	@JsonIgnore
	public JsonObject getResultAsJsonObject() {
		return getResultAsJsonElement().getAsJsonObject();
	}

	/** @return status 코드가 ok 라면 true, 아니면 false */
	public boolean succeeded() {
		return SUCCESS.equalsIgnoreCase(resultCode);
	}

	/** @return status 코드가 ok 라면 false, 아니면 true */
	public boolean failed() {
		return !succeeded();
	}

	@Override
	public String toString() {
		return "JgwResult [resultCode=" + resultCode + ", reasonCode=" + reasonCode + ", result=" + result + "]";
	}

}
