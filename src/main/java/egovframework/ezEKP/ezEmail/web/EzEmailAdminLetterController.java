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
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezEmail.service.EzEmailAdminLetterService;
import egovframework.ezEKP.ezEmail.vo.MailLetterBoxVO;
import egovframework.ezEKP.ezEmail.vo.MailLetterVO;
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
	private EzEmailAdminLetterService EzEmailAdminLetterService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	/**
	 * 편지지 메인화면 호출 함수
	 * @param String loginCookie, Model model
	 * @return String
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
	
	/**
	 * 편지지함 화면 호출, 편지지함 목록 가져오기
	 * @param String loginCookie, Model model
	 * @return : JSONArray
	 */
	@RequestMapping(value="/admin/ezEmail/letterBoxManager.do")
	public JSONArray letterBoxManagerView(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("letterBoxManagerView started.");
		
		JSONArray returnJsonArr = new JSONArray();
		
		try {
			returnJsonArr = EzEmailAdminLetterService.selectAllLetterBox();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("letterBoxManagerView ended.");
		
		return returnJsonArr;
		
	}
	
	/**
	 * 편지지함 추가
	 * @param String loginCookie, Model model
	 * @return : "OK" or "ERROR"
	 */
	@RequestMapping(value="/admin/ezEmail/createLetterBox.do")
	@ResponseBody
	public String createLetterBox(@CookieValue("loginCookie") String loginCookie, @ModelAttribute MailLetterBoxVO letterBox) throws Exception {
		logger.debug("createLetterBox started.");
		logger.debug("letter=" + letterBox);
		
		// 관리자 권한체크      
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		
		Integer parentNo = letterBox.getParentLetterBoxNo();
		String parent_letterbox_no = Integer.toString(parentNo);
		String displayname = letterBox.getDisplayname();
		String displayname2 = letterBox.getDisplayname2();
		String company_id = letterBox.getCompanyID();
		String returnStr = "OK";
		
		try {
			EzEmailAdminLetterService.insertLetterBox(parent_letterbox_no, displayname, displayname2, company_id);
		} catch (Exception e) {
			returnStr = "ERROR";
		}

		logger.debug("createLetterBox ended.");
		
		return returnStr;
		
	}
	
	/**
	 * 편지지함 조회 (개별)
	 * @param String loginCookie, MailLetterBoxVO letterBox
	 * @return : JSONObject
	 */
	@RequestMapping(value="/admin/ezEmail/readLetterBox.do")
	@ResponseBody
	public JSONObject readLetterBox(@CookieValue("loginCookie") String loginCookie, @ModelAttribute MailLetterBoxVO letterBox) throws Exception {
		logger.debug("readLetterBox started.");
		logger.debug("letterBox=" + letterBox);
		
		JSONObject json = null;
		
		Integer boxNo = letterBox.getLetterBoxNo();
		String letterbox_no = Integer.toString(boxNo);
		
		try {
			json = EzEmailAdminLetterService.selectOneLetterBox(letterbox_no);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("readLetterBox ended.");
		if (json != null) {
			return json;
		}
		
		return null;
		
	}
	
	/**
	 * 편지지함 수정
	 * @param String loginCookie, Model model
	 * @return : String loginCookie, MailLetterBoxVO letterBox
	 */
	@RequestMapping(value="/admin/ezEmail/updateLetterBox.do")
	@ResponseBody
	public String updateLetterBox(@CookieValue("loginCookie") String loginCookie, @ModelAttribute MailLetterBoxVO letterBox) throws Exception {
		logger.debug("updateLetterBox started.");
		logger.debug("letter=" + letterBox);
		
		// 관리자 권한체크      
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		
		Integer boxNo = letterBox.getLetterBoxNo();
		String letterbox_no = Integer.toString(boxNo);
		Integer parentNo = letterBox.getParentLetterBoxNo();
		String parent_letterbox_no = Integer.toString(parentNo);
		String displayname = letterBox.getDisplayname();
		String displayname2 = letterBox.getDisplayname2();
		String company_id = letterBox.getCompanyID();
		String returnStr = "OK";
		
		try {
			EzEmailAdminLetterService.updateLetterBox(letterbox_no, parent_letterbox_no, displayname, displayname2, company_id);
		} catch (Exception e) {
			returnStr = "ERROR";
		}

		logger.debug("updateLetterBox ended.");
		return returnStr;
	}
	
	/**
	 * 편지지함 삭제
	 * @param String loginCookie, Model model
	 * @return : int letterBoxNo
	 */
	@RequestMapping(value="/admin/ezEmail/deleteLetterBox.do")
	@ResponseBody
	public String deleteLetterBox(@CookieValue("loginCookie") String loginCookie, int letterBoxNo) throws Exception {
		logger.debug("deleteLetterBox started.");
		logger.debug("letterBoxNo=" + letterBoxNo);
		
		// 관리자 권한체크      
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		
		String letterbox_no = Integer.toString(letterBoxNo);
		String returnStr = "OK";
		
		try {
			EzEmailAdminLetterService.deleteLetterBox(letterbox_no);
		} catch (Exception e) {
			returnStr = "ERROR";
		}

		logger.debug("deleteLetterBox ended.");
		return returnStr;
	}
	
	/**
	 * 편지지 순서 조회 (재은)
	 * @param String loginCookie, HttpServletRequest request
	 * @return : int letterBoxNo
	 */
	@RequestMapping(value="/admin/ezEmail/orderLetter.do")
	@ResponseBody
	public JSONArray orderLetter(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("orderLetter started.");
		
		JSONArray json = null;
		
		try {
			json = EzEmailAdminLetterService.selectLetterOrder();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("orderLetter ended.");
		if (json != null) {
			return json;
		}
		
		return null;
	}
	
	/**
	 * 편지지 검색 (재은)
	 * @param String loginCookie, String searchStr
	 * @return : int letterBoxNo
	 */
	@RequestMapping(value="/admin/ezEmail/readLetterSearch.do")
	@ResponseBody
	public JSONArray readLetterSearch(@CookieValue("loginCookie") String loginCookie, String search) throws Exception {
		logger.debug("readLetterSearch started.");
		logger.debug("search="+search);
		
		JSONArray json = null;
		
		try {
			json = EzEmailAdminLetterService.searchLetter(search);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("readLetterSearch ended.");
		if (json != null) {
			return json;
		}
		
		return null;
	}
	
	
	/**
	 * 편지지 작성 (수아)
	 * @param : displayname, displayname2, letterBoxNo
	 * @return : "OK" or "ERROR"
	 */
	@RequestMapping("/admin/ezEmail/createLetter")
	@ResponseBody
	public String createLetter(@CookieValue("loginCookie") String loginCookie, @ModelAttribute MailLetterVO letter) throws Exception{
		logger.debug("createLetter started.");
		logger.debug("letter=" + letter);
		
		// 관리자 권한체크      
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		
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
	public String updateDisplayNameLetter(@CookieValue("loginCookie") String loginCookie, @ModelAttribute MailLetterVO letter) throws Exception{
		logger.debug("updateDisplayNameLetter started.");
		logger.debug("letter=" + letter);
		
		// 관리자 권한체크      
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		
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
	public String updateOrderLetter(@CookieValue("loginCookie") String loginCookie, String letterNo, String letterOrder) throws Exception{
		logger.debug("updateOrderLetter started.");
		logger.debug("letterNo=" + letterNo + ", letterOrder=" + letterOrder);

		// 관리자 권한체크      
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		
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
	public String updateBoxLetter(@CookieValue("loginCookie") String loginCookie, String letterNo, String letterBoxNo) throws Exception{
		logger.debug("updateBoxLetter started.");
		logger.debug("letterNo=" + letterNo + ", letterBoxNo=" + letterBoxNo);
		
		// 관리자 권한체크      
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		
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
	public String deleteLetter(@CookieValue("loginCookie") String loginCookie, String letterNo) throws Exception{
		logger.debug("deleteLetter started.");
		logger.debug("letterNo=" + letterNo);
		
		// 관리자 권한체크      
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		
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