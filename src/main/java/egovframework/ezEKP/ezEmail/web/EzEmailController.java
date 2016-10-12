package egovframework.ezEKP.ezEmail.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

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
	
	/**
	 * 메일 메인화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailMain.do")
	public String showMailMain(Model model, HttpServletRequest request) throws Exception{
		String funCode = "1";
		if(request.getParameter("funCode") != null) {
			funCode = request.getParameter("funCode");
		}
		
		model.addAttribute("funCode", funCode);
		
		return "ezEmail/mailMain";
	}

}
