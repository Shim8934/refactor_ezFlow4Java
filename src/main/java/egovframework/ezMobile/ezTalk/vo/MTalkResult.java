package egovframework.ezMobile.ezTalk.vo;

public class MTalkResult {

	private final boolean result;
	private final int resultCode;
	private final Object data;

	public MTalkResult(boolean result, int resultCode, Object data) {
		this.result = result;
		this.resultCode = resultCode;
		this.data = data;
	}

	public boolean getResult() {
		return result;
	}

	public int getResultCode() {
		return resultCode;
	}

	public Object getData() {
		return data;
	}

	public static MTalkResult success(Object data) {
		return new MTalkResult(true, 0, data);
	}

	public static MTalkResult failure() {
		return new MTalkResult(false, 0, null);
	}
	
}
