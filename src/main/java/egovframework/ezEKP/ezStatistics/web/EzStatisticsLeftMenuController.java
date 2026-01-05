package egovframework.ezEKP.ezStatistics.web;

import java.util.Objects;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 통계
 * @author 오픈솔루션팀 이동호
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.06.27    이동호             신규작성
 *
 * @see
 */

@Controller
public class EzStatisticsLeftMenuController {
	
    @Autowired
    private Properties config;
    
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
    
	/**
	 * 통계 좌측 메뉴 화면 표시 함수
	 */
	@RequestMapping(value="/ezStatistics/statisticsLeftMenu.do", method = RequestMethod.GET)
	public String statisticsLeftMenu(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
	    String use_approvalG = config.getProperty("config.UserInfo_ApprovalG");
	    
	    model.addAttribute("use_approvalG", use_approvalG);
	    
        String packageType = commonUtil.getPackageType(userInfo.getTenantId());
        
        model.addAttribute("packageType", packageType);
        
        //2018-07-26 김보미 - 근태 추가
	    String use_attitude = ezCommonService.getTenantConfig("USE_ATTITUDE", userInfo.getTenantId());
	    
	    model.addAttribute("use_attitude", use_attitude);
	    
		//애티튜드 널일때 처리
		if (use_attitude == null || use_attitude.equals("")) {
			model.addAttribute("use_attitude", "YES");
		}
		
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", userInfo.getTenantId());
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
		}

		//2025-03-21 박기범 - 메뉴통계 추가 
		model.addAttribute("useStatMenu", Objects.toString(ezCommonService.getTenantConfig("useStatMenu", userInfo.getTenantId()), "NO"));
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		model.addAttribute("lang", userInfo.getLang());
	    
		return "ezStatistics/statisticsLeftMenu";
	}

}
