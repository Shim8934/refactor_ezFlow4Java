package egovframework.ezEKP.ezPersonal.web;

import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 사용자 - Personal
 * @author 오픈솔루션팀 황윤진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.07.20    황윤진         신규작성
 *
 * @see
 */

@Controller
public class EzPersonalController {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EgovMessageSource messageSource;
	
	@Resource(name = "EzPersonalService")
	private EzPersonalService ezPersonalService;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	/**
	 * 전자결재 부재자설정 끄기 Method
	 */	
	@RequestMapping(value = "/ezPersonal/saveBujae.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveBujae(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String buJaeInfo = request.getParameter("buJae");
		String buJaeInfo2 = "";
		String proxyInfo = request.getParameter("proxy");
		String proxyInfo2 = "";
		//TODO: ad에서 정보 가져오는데 임시로 하드코딩함 전자결재외에 다른 부분 발견하면 수정요망(전자결재만 존재하면 그냥 박아도됨)
		String pClass = "user";
		
		if (buJaeInfo != null && !buJaeInfo.equals("")) {
			if (buJaeInfo.split(":").length >= 5) {
				buJaeInfo2 = buJaeInfo.split(":")[0] + ":" + buJaeInfo.split(":")[1] + ":" + buJaeInfo.split(":")[2] + ":" + buJaeInfo.split(":")[3] + ":" + buJaeInfo.split(":")[4];
			}
			
			if (buJaeInfo.split(":").length > 5) {
				buJaeInfo2 += ":" + buJaeInfo.split(":")[5];
			}
		}
		
		String result = ezOrganService.updateProperty(userInfo.getId(), "extensionAttribute5", buJaeInfo2, pClass);
		
		if (result.equals("OK")) {
			if (proxyInfo.split(":").length >= 5) {
				proxyInfo2 = proxyInfo.split(":")[0] + ":" + proxyInfo.split(":")[1] + ":" + proxyInfo.split(":")[3] + ":" + proxyInfo.split(":")[4];
			}
			
			if (proxyInfo.split(":")[0].trim().equals("")) {
				result = ezOrganService.delProxyUserInfo(userInfo.getId());
			} else {
				result = ezOrganService.setProxyUserInfo(userInfo.getId(), proxyInfo.split(":")[0], proxyInfo.split(":")[1], proxyInfo.split(":")[2], proxyInfo.split(":")[3], proxyInfo.split(":")[4]);
			}
		}
		
		return result;
	}

}
