package egovframework.ezMobile.ezApprovalG.web;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezMobile.ezApprovalG.service.MApprovalGService;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGDocInfoVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 전자결재 모바일
 * @author 오픈솔루션팀 황윤진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2017.06.01    황윤진    신규작성
 *
 * @see
 */

@Controller
public class MApprovalGController {
	private static final Logger logger = LoggerFactory.getLogger(MApprovalGController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name = "MApprovalGService")
	private MApprovalGService MApprovalGService;
	
	/**
	 * 모바일 전자결재G 결재할문서 호출 Method
	 */
	@RequestMapping(value = "/mobile/ezApprovalG/doApproveList.do")
	public String doApprovList(@CookieValue("loginCookie") String loginCookie, Model model, String listType) throws Exception {
		logger.debug("doApprovList started");
		logger.debug("listType : " + listType);
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		//임시 
		listType = "1";
		
		//결재할 문서 카운트
		int listCount = ezApprovalGService.getWebPartListCount("1", userInfo.getId(), userInfo.getDeptID(), "", "COUNT", "", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
		List<MApprovalGDocInfoVO> approvalGDocInfoVOs = MApprovalGService.getDoApproveList(userInfo, listType);
		
		model.addAttribute("listCount", listCount);
		model.addAttribute("apprGList", approvalGDocInfoVOs);
		
		logger.debug("doApprovList ended");
		
		return "mobile/ezApprovalG/mApprGdoApproveList";
	}
}
