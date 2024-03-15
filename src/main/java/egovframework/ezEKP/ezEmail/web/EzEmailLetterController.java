package egovframework.ezEKP.ezEmail.web;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezEmail.service.EzEmailAdminLetterService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/**
 * @Description [Controller] 편지지함, 편지지 기능
 * @author 오픈솔루션팀 김수아, 정재은
 * @Modification Information
 *  수정일                    수정자            수정내용
 *  ----------    ------    -------------------
 *  2018.02.20    김수아             신규작성
 *  2018.02.20    정재은             신규작성
 *
 * @see
 */

@Controller
public class EzEmailLetterController {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailAdminLetterController.class);

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private EzEmailAdminLetterService ezEmailAdminLetterService;

	/**
	 * 편지지 버튼 클릭시 호출
	 * 
	 * @param String loginCookie, Model model
	 * @return String
	 */
	@RequestMapping(value = "/ezEmail/mailLetter.do", method = RequestMethod.GET)
	public String mailLetterView(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("mailLetterView started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = userInfo.getCompanyID();
		String userLang = userInfo.getPrimary();

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pageType", "letter_user");
		model.addAttribute("companyId", companyId);
		model.addAttribute("userLang", userLang);

		logger.debug("mailLetterView ended.");

		return "ezEmail/mailLetter";

	}

	/**
	 * 편지지 검색
	 * 
	 * @param String loginCookie, Model model
	 * @return String
	 */
	@RequestMapping(value = "/ezEmail/searchLetter.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONArray searchLetter(@CookieValue("loginCookie") String loginCookie, String search, HttpServletRequest request) throws Exception {
		search = URLDecoder.decode(search, "UTF-8");

		logger.debug("searchLetter started.");
		logger.debug("search=" + search);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userLang = userInfo.getPrimary();
		String companyId = request.getParameter("companyId") != null ? request.getParameter("companyId") : userInfo.getCompanyID();
		String tenantId = Integer.toString(userInfo.getTenantId());
		logger.debug("userLang=" + userLang + ", companyId=" + companyId + ", tenantId=" + tenantId);

		JSONArray returnJsonArr = new JSONArray();

		try {
			returnJsonArr = ezEmailAdminLetterService.searchLetter(search, companyId, tenantId, userLang);
		} catch (UnsupportedEncodingException e) {
			// logger.error(e.getMessage(), e);
			logger.debug("no data");
		} catch (Exception e) {
			// logger.error(e.getMessage(), e);
			logger.debug("no data");
		}

		logger.debug("searchLetter ended.");

		return returnJsonArr;

	}

	/**
	 * 편지지함명 검색
	 * 
	 * @param String loginCookie, letterNo, Model model
	 * @return String
	 */
	@RequestMapping(value = "/ezEmail/mailLetterPreview.do", method = RequestMethod.GET)
	public String mailLetterPreview(@CookieValue("loginCookie") String loginCookie, String letterNo, Model model) throws Exception {

		logger.debug("mailLetterPreview started.");
		logger.debug("letterNo=" + letterNo);

		model.addAttribute("letterNo", letterNo);

		logger.debug("mailLetterPreview ended.");

		return "ezEmail/mailLetterPreview";

	}

	/**
	 * 편지지함명 검색
	 * 
	 * @param String loginCookie, Model model
	 * @return String
	 */
	@RequestMapping(value = "/ezEmail/selectLetterBoxName.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject selectLetterBoxName(@CookieValue("loginCookie") String loginCookie, String letterBoxNo) throws Exception {

		logger.debug("selectLetterBoxName started.");
		logger.debug("letterBoxNo=" + letterBoxNo);

		JSONObject json = null;
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userLang = userInfo.getPrimary();
		
		logger.debug("userLang=" + userLang);

		try {
			json = ezEmailAdminLetterService.selectLetterBoxName(letterBoxNo, userLang);
		} catch (UnsupportedEncodingException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("readLetterBox ended.");

		if (json != null) {
			return json;
		}else{
			return new JSONObject();
		}

	}

}
