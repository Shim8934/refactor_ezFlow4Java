package egovframework.ezEKP.ezEmail.web;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import egovframework.ezEKP.ezEmail.service.EzEmailAdminLetterService;
import egovframework.ezEKP.ezEmail.vo.MailLetterBoxVO;
import egovframework.ezEKP.ezEmail.vo.MailLetterVO;
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
	private EzEmailAdminLetterService EzEmailAdminLetterService;
	
	/**
	 * 편지지 메인화면 호출 함수
	 */
	@RequestMapping(value="/admin/ezEmail/letterlMain.do")
	public ModelAndView letterMainView(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		
		//user가 superAdmin인지 그냥 admin인지 구별하는 조건 수정해야됨
		
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
	
	@RequestMapping(value="/admin/ezEmail/letterBoxManager.do")
	public List<MailLetterBoxVO> letterBoxManagerView(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		
		logger.debug("letterBoxManagerView started.");
		
		List<MailLetterBoxVO> list = new ArrayList<MailLetterBoxVO>();
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		return list;
		
	}
	// su==========================================
	
	/**
	 * 편지지 작성 (수아)
	 * @param : displayname, displayname2, letterBoxNo
	 * @return : "OK" or "ERROR"
	 */
	@RequestMapping("/admin/ezEmail/createLetter")
	@ResponseBody
	public String createLetter(@ModelAttribute MailLetterVO letter) throws Exception{
		logger.debug("createLetter started.");
		logger.debug("letter=" + letter);
		
		// 관리자 권한체크     @CookieValue("loginCookie") String loginCookie, 
		/*LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}*/
		
		String displayname = letter.getDisplayname();
		String displayname2 = letter.getDisplayname2();
		String letterBoxNo = Integer.toString(letter.getLetterBoxNo());
		String returnStr = "OK";
		
		try {
			EzEmailAdminLetterService.addLetter(displayname, displayname2, letterBoxNo);
		} catch (Exception e) {
			returnStr = "ERROR";
			//e.printStackTrace();
		}

		logger.debug("createLetter ended.");
		return returnStr;
	}
	
	/**
	 * 편지지 수정 - 편지지 이름 (수아)
	 * @param displayname, displayname2, letterNo
	 * @return : "OK" or "ERROR"
	 */
	@RequestMapping("/admin/ezEmail/updateDisplaynameLetter")
	@ResponseBody
	public String updateDisplayNameLetter(@ModelAttribute MailLetterVO letter) throws Exception{
		logger.debug("updateDisplayNameLetter started.");
		logger.debug("letter=" + letter);
		
		String displayname = letter.getDisplayname();
		String displayname2 = letter.getDisplayname2();
		String letterNo = Integer.toString(letter.getLetterNo());
		String returnStr = "OK";
		
		try {
			EzEmailAdminLetterService.updateDisplayNameLetter(displayname, displayname2, letterNo);
		} catch (Exception e) {
			returnStr = "ERROR";
			//e.printStackTrace();
		}
		
		logger.debug("updateDisplayNameLetter ended.");
		return returnStr;
	}
	
	/**
	 * 편지지 수정 - 편지지 순서 (수아)
	 * @param letterOrder, letterNo (편지지 순서, 편지지 번호)
	 * @return : "OK" or "ERROR"
	 */
	@RequestMapping("/admin/ezEmail/updateOrderLetter")
	@ResponseBody
	public String updateOrderLetter(String letterNo, String letterOrder) throws Exception{
		logger.debug("updateOrderLetter started.");
		logger.debug("letterNo=" + letterNo + ", letterOrder=" + letterOrder);
		
		String returnStr = "OK";
		
		try {
			EzEmailAdminLetterService.updateOrderLetter(letterOrder, letterNo);
		} catch (Exception e) {
			returnStr = "ERROR";
			//e.printStackTrace();
		}

		logger.debug("updateOrderLetter ended.");
		return returnStr;
	}
	
	/**
	 * 편지지 수정 - 편지지함 (수아)
	 * @param letterNo, letterBoxNo (편지지 번호, 편지지함 번호)
	 * @return : "OK" or "ERROR"
	 */
	@RequestMapping("/admin/ezEmail/updateBoxLetter")
	@ResponseBody
	public String updateBoxLetter(String letterNo, String letterBoxNo) throws Exception{
		logger.debug("updateBoxLetter started.");
		logger.debug("letterNo=" + letterNo + ", letterBoxNo=" + letterBoxNo);
		
		String returnStr = "OK";
		
		try {
			EzEmailAdminLetterService.updateBoxLetter(letterNo, letterBoxNo);
		} catch (Exception e) {
			returnStr = "ERROR";
			//e.printStackTrace();
		}

		logger.debug("updateBoxLetter ended.");
		return returnStr;
	}
	
	/**
	 * 편지지 삭제 (수아)
	 * @param letterNo (편지지 번호)
	 * @return : "OK" or "ERROR"
	 */
	@RequestMapping("/admin/ezEmail/deleteLetter")
	@ResponseBody
	public String deleteLetter(String letterNo) throws Exception{
		logger.debug("deleteLetter started.");
		logger.debug("letterNo=" + letterNo);
		
		String returnStr = "OK";
		
		try {
			EzEmailAdminLetterService.deleteLetter(letterNo);
		} catch (Exception e) {
			returnStr = "ERROR";
			//e.printStackTrace();
		}

		logger.debug("deleteLetter ended.");
		return returnStr;
	}
	
	/**
	 * 편지지 목록 조회 (수아)
	 * @param letterBoxNo (편지지함 번호)
	 * @return : JSONArray
	 */
	@RequestMapping("/admin/ezEmail/readLetterList")
	@ResponseBody
	public JSONArray readLetterList(String letterBoxNo) throws Exception{
		logger.debug("readLetterList started.");
		logger.debug("letterBoxNo=" + letterBoxNo);
		
		JSONArray returnJsonArr = new JSONArray();
		
		try {
			returnJsonArr = EzEmailAdminLetterService.selectAllLeter(letterBoxNo);
		} catch (Exception e) {
			//e.printStackTrace();
		}
		
		logger.debug("readLetterList ended.");
		return returnJsonArr;
	}
	
	/**
	 * 편지지 개별 조회 (수아)
	 * @param letterNo (편지지 번호)
	 */
	@RequestMapping("/admin/ezEmail/readLetter")
	@ResponseBody
	public JSONObject readLetter(String letterNo) throws Exception{
		logger.debug("readLetter started.");
		logger.debug("letterNo=" + letterNo);
		
		JSONObject returnJson = new JSONObject();
		
		try {
			returnJson = EzEmailAdminLetterService.selectDetailLetter(letterNo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("readLetter ended.");
		return returnJson;
	}
}