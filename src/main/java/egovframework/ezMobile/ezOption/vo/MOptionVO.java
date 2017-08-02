package egovframework.ezMobile.ezOption.vo;

public class MOptionVO {
	
	private String userId;			/** 개인환경설정 사용자Id  */
	
	private String timeZone;		/** 개인환경설정  타임존 */
	
	private String lang;			/** 개인환경설정  언어설정  */
	
	private String mainType;		/** 개인환경설정  메인화면 타입설정  */
	
	private String listCnt;			/** 개인환경설정  메인화면 리스트 표출갯수 설정  */
	
	private String useSearch;		/** 개인환경설정  메인화면 직원검색 표출여부 설정*/
	
	private String useSecurity;		/** 개인환경설정  전자결재 보안설정  */
		
	private int tenantId;			/** 계열사 Id */

	public String getUserId() {
		return userId;
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

	public String getUseSearch() {
		return useSearch;
	}

	public void setUseSearch(String useSearch) {
		this.useSearch = useSearch;
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
	
}
