package egovframework.ezEKP.ezOrgan.service;

/** 사용자 저장시 중복되는 아이디의 존재 여부 */
public enum PreResult {

	/** 중복되지 않음 */
	NONE,
	/** 기존에 사용중인 아이디가 있음 */
	PRE,
	/**
	 * <strong>사번 로그인 사용 시</strong><br>
	 * CN에 대해서 기존에 사용중인 로그인 아이디가 있음<br>
	 * 로그인 아이디란 사용자의 CN 또는 사번입니다.
	 */
	PRE_CN,
	/**
	 * <strong>사번 로그인 사용 시</strong><br>
	 * 사번에 대해서 기존에 사용중인 로그인 아이디가 있음<br>
	 * 로그인 아이디란 사용자의 CN 또는 사번입니다.
	 */
	PRE_EMPLOYEE_NUMBER;

	public boolean succeeded() {
		return this == NONE;
	}

	public boolean failed() {
		return !succeeded();
	}

}
