package egovframework.ezEKP.ezEmail.web;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import egovframework.ezEKP.ezEmail.vo.MailLetterBoxVO;
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
	
	/**
	 * 편지지 메인화면 호출 함수
	 */
	@RequestMapping(value="/admin/ezEmail/letterlMain.do")
	public ModelAndView letterMainView(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		
		logger.debug("letterMainView started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		ModelAndView mav = new ModelAndView();
		
		String companyID = userInfo.getCompanyID();
		String companyName = userInfo.getCompanyName();
		
		mav.addObject("companyID", companyID);
		mav.addObject("companyName", companyName);
		mav.setViewName("/admin/ezEmail/letterMain");
		
		return mav;
	}
	
	public List<MailLetterBoxVO> letterBoxManagerView(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		List<MailLetterBoxVO> list = new ArrayList<MailLetterBoxVO>();
		
		return list;
		
	}
	
}