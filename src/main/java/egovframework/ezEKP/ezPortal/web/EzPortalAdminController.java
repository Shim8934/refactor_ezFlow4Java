package egovframework.ezEKP.ezPortal.web;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 포탈 관리자
 * @author 오픈솔루션팀 지정석
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.09.08    지정석    신규작성
 *
 * @see
 */

@Controller
public class EzPortalAdminController extends EzFileMngUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(EzPortalAdminController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	/**
	 * 관리자 포탈  메인 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPortal/portalMain.do", method = RequestMethod.GET)
	public String portalMain(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalMain started");

		userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		logger.debug("portalMain ended");
		return "/admin/ezPortal/portalMain";
	}
	
	
}
