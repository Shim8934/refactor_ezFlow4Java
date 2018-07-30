package egovframework.ezEKP.ezCabinet.service.impl;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezCabinet.service.EzCabinetService_m;
import egovframework.let.user.login.vo.LoginVO;

@Service
public class EzCabinetServiceImpl_m implements EzCabinetService_m{

	@Override
	public JSONObject saveApprovalItem(String approvalContent, Locale locale, LoginVO userInfo) throws Exception {
		String url                ="/rest/ezcabinet/relate-item/save/apprv";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("approvalContent", approvalContent);
		
		return null;
	}
}
