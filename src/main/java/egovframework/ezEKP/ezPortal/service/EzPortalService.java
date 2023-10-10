package egovframework.ezEKP.ezPortal.service;

import java.util.Map;

import org.json.simple.JSONObject;

import egovframework.let.user.login.vo.LoginVO;

public interface EzPortalService {
	
	public String getTotalSearchURL(LoginVO userInfo, Map<String, Object> param) throws Exception;
	
	public Map<String, Object> callSearchServerForResult(String searchURL, String offset) throws Exception;
	
	public JSONObject callSearchServerForResult2(LoginVO userInfo, Map<String, Object> param) throws Exception;
	
	/* 2023-02-14 홍승비 - 통합검색엔진 XTEN 전용 검색어 생성 메서드 분리 */
	public String getTotalSearchURL_XTEN(LoginVO userInfo, Map<String, Object> param) throws Exception;
}
