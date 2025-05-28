package egovframework.ezEKP.ezEmail.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

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
	@RequestMapping(value="/ezEmail/mailMain.do", method = RequestMethod.GET)
	public String showMailMain(Model model, HttpServletRequest request) throws Exception {
		String funCode = "1";
		String subCode = "1";
        String leftFrameWidth = "220";
        int width = 0;
		
		if (request.getParameter("funCode") != null) {
			funCode = request.getParameter("funCode");
		}

		if (request.getParameter("subCode") != null) {
			subCode = request.getParameter("subCode");
		}

		if (request.getParameter("__wwidth") != null) {
			String widthParam = request.getParameter("__wwidth");

            try {
                width = Integer.parseInt(widthParam);

                leftFrameWidth = width < 1180 ? "0" : "220";
            } catch (NumberFormatException e) {
                width = 0;
            }
		}

        // 승인메일 수정필요
        //boolean useApprMail = ezEmailUtil.useApprMailPolicy(tenantId, companyId); // 2024-03-06 이사라 - 승인메일 사용 여부
        //boolean isApprMailApprover = useApprMail ? ezEmailService.checkApprMailApprover(tenantId, companyId, userInfo.getId()) : false; // 2024-03-06 이사라 - 승인자 여부 확인

        model.addAttribute("funCode", funCode);
		model.addAttribute("subCode", subCode);
        model.addAttribute("leftFrameWidth", leftFrameWidth);
        model.addAttribute("useApprMail", true); // 2024-03-06 이사라 - 승인메일 사용 여부
        model.addAttribute("isApprMailApprover", true); // 2024-03-06 이사라 - 승인자 여부 확인

        return "ezEmail/mailMain";
	}

    /**
     * 메일 단독 모드에서의 메인화면 호출 함수
     */
    @RequestMapping(value="/ezEmail/mailAloneMain.do", method = RequestMethod.GET)
    public String showMailAloneMain(Model model, HttpServletRequest request) throws Exception {
        return "ezEmail/mailAloneMain";
    }
	
    @RequestMapping(value="/ezEmail/mailAloneTop.do", method = RequestMethod.GET)
    public String showMailAloneTop(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
        LoginVO auth = commonUtil.checkAdmin(loginCookie);
        
        boolean checkAdmin = auth == null ? false : true;
        
        model.addAttribute("checkAdmin", checkAdmin);
        
        String packageType = "";
        
        if (checkAdmin) {
        	packageType = commonUtil.getPackageType(auth.getTenantId());
        	
            model.addAttribute("lang", auth.getLang());
        } else {
            LoginVO userInfo = commonUtil.userInfo(loginCookie);
        	packageType = commonUtil.getPackageType(userInfo.getTenantId());            
            
            model.addAttribute("lang", userInfo.getLang());
        }
        
        model.addAttribute("packageType", packageType);
        
        return "ezEmail/mailAloneTop";
    }
    
}
