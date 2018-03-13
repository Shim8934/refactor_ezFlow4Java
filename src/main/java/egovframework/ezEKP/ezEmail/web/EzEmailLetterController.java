package egovframework.ezEKP.ezEmail.web;

import java.net.URLDecoder;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezEmail.service.EzEmailAdminLetterService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 편지지함, 편지지 기능
 * @author 오픈솔루션팀 김수아, 정재은
 * @Modification Information
 *
 *    수정일                    수정자            수정내용
 *    ----------    ------    -------------------
 *    2018.03.08    김수아             신규작성
 *    2018.03.08    정재은             신규작성
 *
 * @see
 */

@Controller
public class EzEmailLetterController {
	
	private static final Logger logger = LoggerFactory.getLogger(EzEmailAdminLetterController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private EzEmailAdminLetterService EzEmailAdminLetterService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	
	/**
	 * 편지지 버튼 클릭시 호출
	 * @param String loginCookie, Model model
	 * @return String
	 */
	@RequestMapping(value="/ezEmail/mailLetter.do")
	public String mailLetterView(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("mailLetterView started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = userInfo.getCompanyID();
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pageType", "letter_user");
		model.addAttribute("companyId", companyId);
		
		logger.debug("mailLetterView ended.");
		
		return "ezEmail/mailLetter";
		
	}
	
	/**
	 * 편지지 검색
	 * @param String loginCookie, Model model
	 * @return String
	 */
	@RequestMapping(value="/ezEmail/searchLetter.do")
	@ResponseBody
	public JSONArray searchLetter(@CookieValue("loginCookie") String loginCookie, String search) throws Exception {
		search = URLDecoder.decode(search,"UTF-8");
		
		logger.debug("searchLetter started.");
		logger.debug("search=" + search);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = userInfo.getCompanyID();
		String tenantId = Integer.toString(userInfo.getTenantId());
		
		if (search == null || search.equals("")) {
			search = "";
		}
		
		JSONArray returnJsonArr = new JSONArray();
		
		
		try {
			returnJsonArr = EzEmailAdminLetterService.searchLetter(search, companyId, tenantId);
		} catch (Exception e) {
			//e.printStackTrace();
			logger.debug("no data");
		}
		
		logger.debug("searchLetter ended.");
		
		return returnJsonArr;
		
	}
	
	/**
	 * 편지지함명 검색
	 * @param String loginCookie, Model model
	 * @return String
	 */
	@RequestMapping(value="/ezEmail/selectLetterBoxName.do")
	@ResponseBody
	public JSONObject selectLetterBoxName(@CookieValue("loginCookie") String loginCookie, String letterBoxNo) throws Exception {
		
		logger.debug("selectLetterBoxName started.");
		logger.debug("letterBoxNo=" + letterBoxNo);
		
		JSONObject json = null;
		
		try {
			json = EzEmailAdminLetterService.selectLetterBoxName(letterBoxNo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("readLetterBox ended.");
		if (json != null) {
			return json;
		}
		
		return null;
		
	}

}
