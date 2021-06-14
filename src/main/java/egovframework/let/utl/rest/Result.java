package egovframework.let.utl.rest;

import com.google.gson.Gson;
import com.google.gson.JsonElement;

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

	public static Result success() {
		return success(null);
	}

	public static Result success(Object data) {
		return success(DEFAULT_SUCCESS_CODE, data);
	}

	public static Result success(int code, Object data) {
		return new Result(SUCCESS, code, data);
	}

	public static Result failure() {
		return failure(null);
	}

	public static Result failure(Object data) {
		return failure(DEFAULT_FAILURE_CODE, data);
	}

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

	public JsonElement toJsonData() {
		return GSON.toJsonTree(data);
	}

	public boolean succeeded() {
		return "ok".equalsIgnoreCase(status);
	}

	public boolean failed() {
		return !succeeded();
	}

}
