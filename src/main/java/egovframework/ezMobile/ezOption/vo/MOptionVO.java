package egovframework.ezMobile.ezOption.vo;

public class MOptionVO {
	
	private String userId;			/** 개인환경설정 사용자Id  */
	
	private String timeZone;		/** 개인환경설정  타임존 */
	
	private String lang;			/** 개인환경설정  언어설정  */
	
	private String mainType;		/** 개인환경설정  메인화면 타입설정  */
	
	private String listCnt;			/** 개인환경설정  메인화면 리스트 표출갯수 설정  */
		
	private String useSecurity;		/** 개인환경설정  전자결재 보안설정  */
	
	private String usePrimaryLangOnly; /** 개인환경설정 타언어 사용여부  */
		
	private int tenantId;			/** 계열사 Id */
	
	private String pin;				/** pin 로그인 사용 유무 */
	
	private String pinState;		/** pin 값 */
	
	private String biometric;		/** 생체인식 사용 유무 */

	public String getUserId() {
		return userId;
	}

	public String getUsePrimaryLangOnly() {
		return usePrimaryLangOnly;
	}

	public void setUsePrimaryLangOnly(String usePrimaryLangOnly) {
		this.usePrimaryLangOnly = usePrimaryLangOnly;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getTimeZone() {
		return timeZone;
	}

	public void setTimeZone(String timeZone) {
		this.timeZone = timeZone;
	}

	public String getLang() {
		return lang;
	}

	public void setLang(String lang) {
		this.lang = lang;
	}

	public String getMainType() {
		return mainType;
	}

	public void setMainType(String mainType) {
		this.mainType = mainType;
	}

	public String getListCnt() {
		return listCnt;
	}

	public void setListCnt(String listCnt) {
		this.listCnt = listCnt;
	}

	public String getUseSecurity() {
		return useSecurity;
	}

	public void setUseSecurity(String useSecurity) {
		this.useSecurity = useSecurity;
	}

	public int getTenantId() {
		return tenantId;
	}

	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}

	public String getPin() {
		return pin;
	}

	public void setPin(String pin) {
		this.pin = pin;
	}

	public String getPinState() {
		return pinState;
	}

	public void setPinState(String pinState) {
		this.pinState = pinState;
	}

	public String getBiometric() {
		return biometric;
	}

	public void setBiometric(String biometric) {
		this.biometric = biometric;
	}	
	
}
