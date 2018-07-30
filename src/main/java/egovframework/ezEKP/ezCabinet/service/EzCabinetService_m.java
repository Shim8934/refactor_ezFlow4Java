package egovframework.ezEKP.ezCabinet.service;

import java.util.Locale;
import org.json.simple.JSONObject;
import egovframework.let.user.login.vo.LoginVO;

public interface EzCabinetService_m {
	JSONObject saveApprovalItem(String approvalContent, Locale locale, LoginVO userInfo) throws Exception;
}
