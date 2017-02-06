package egovframework.ezEKP.ezEmail.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 메일
 * @author 오픈솔루션팀 이동호, 이효민
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.14    이효민    신규작성
 *
 * @see
 */

@Controller
public class EzEmailController {
	
    @Autowired
    private CommonUtil commonUtil;
    
	/**
	 * 메일 메인화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailMain.do")
	public String showMailMain(Model model, HttpServletRequest request) throws Exception {
		String funCode = "1";
		if(request.getParameter("funCode") != null) {
			funCode = request.getParameter("funCode");
		}
		
		model.addAttribute("funCode", funCode);
		
		return "ezEmail/mailMain";
	}

    /**
     * 메일 단독 모드에서의 메인화면 호출 함수
     */
    @RequestMapping(value="/ezEmail/mailAloneMain.do")
    public String showMailAloneMain(Model model, HttpServletRequest request) throws Exception {
        return "ezEmail/mailAloneMain";
    }
	
    @RequestMapping(value="/ezEmail/mailAloneTop.do")
    public String showMailAloneTop(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
        LoginVO auth = commonUtil.checkAdmin(loginCookie);
        
        boolean checkAdmin = auth == null ? false : true;
        
        model.addAttribute("checkAdmin", checkAdmin);
        
        if (checkAdmin) {
            model.addAttribute("lang", auth.getLang());
        } else {
            LoginVO userInfo = commonUtil.userInfo(loginCookie);
            model.addAttribute("lang", userInfo.getLang());
        }
        
        return "ezEmail/mailAloneTop";
    }
    
}
