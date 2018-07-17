package egovframework.ezEKP.ezCabinet.service;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;

public interface EzCabinetRestService_h {

	public JSONObject getUserInfo(HttpServletRequest request, String userId) throws Exception;

}
