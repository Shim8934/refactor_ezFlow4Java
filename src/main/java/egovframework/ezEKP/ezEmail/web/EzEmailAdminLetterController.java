package egovframework.ezEKP.ezEmail.web;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import egovframework.ezEKP.ezEmail.vo.MailLetterBoxVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;


/** 
 * @Description [Controller] 편지지함, 편지지 기능
 * @author 오픈솔루션팀 김수아, 정재은
 * @Modification Information
 *
 *    수정일                    수정자            수정내용
 *    ----------    ------    -------------------
 *    2018.02.20    김수아             신규작성
 *    2018.02.20    정재은             신규작성
 *
 * @see
 */

@Controller
public class EzEmailAdminLetterController {
	
	private static final Logger logger = LoggerFactory.getLogger(EzEmailAdminLetterController.class);
		
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	/**
	 * 편지지 메인화면 호출 함수
	 */
	@RequestMapping(value="/admin/ezEmail/letterlMain.do")
	public String letterMainView(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("letterMainView started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || (userInfo.getRollInfo().indexOf("k=1") > -1 && vo.getCn().equals(userInfo.getCompanyID()))) {
				resultList.add(vo);
			}
			
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList);
		
		logger.debug("letterMainView ended.");
		
		return "admin/ezEmail/letterMain";
		
	}
	
	@RequestMapping(value="/admin/ezEmail/letterBoxManager.do")
	public List<MailLetterBoxVO> letterBoxManagerView(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		
		logger.debug("letterBoxManagerView started.");
		
		List<MailLetterBoxVO> list = new ArrayList<MailLetterBoxVO>();
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		return list;
		
	}
	
}