package egovframework.ezEKP.ezEmail.web;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.*;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
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
 *  수정일                    수정자            수정내용
 *  ----------    ------    -------------------
 *  2018.02.20    김수아             신규작성
 *  2018.02.20    정재은             신규작성
 *
 * @see
 */

@Controller
public class EzEmailAdminLetterController {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailAdminLetterController.class);

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private EzEmailAdminLetterService ezEmailAdminLetterService;

	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;

	/**
	 * 편지지 메인화면 호출 함수
	 * 
	 * @param String loginCookie, Model model
	 * @return String
	 */
	@RequestMapping(value = "/admin/ezEmail/letterMain.do", method = RequestMethod.GET)
	public String letterMainView(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("letterMainView started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();

		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);

			if (userInfo.getRollInfo().contains("c=1") || (userInfo.getRollInfo().contains("k=1") && vo.getCn().equals(userInfo.getCompanyID()))) {
				resultList.add(vo);
			}

		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList);

		logger.debug("letterMainView ended.");

		return "admin/ezEmail/letterMain";

	}

	/**
	 * 편지지함 화면 호출
	 * 
	 * @param String loginCookie, Model model
	 * @return : String
	 */
	@RequestMapping(value = "/admin/ezEmail/letterBoxManager.do", method = RequestMethod.GET)
	public String letterBoxManagerView(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String companyId) throws Exception {
		logger.debug("letterBoxManagerView started.");
		logger.debug("companyId=" + companyId);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userLang = userInfo.getPrimary();
		String primary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		
		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		companyId = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(companyId));
		model.addAttribute("companyId", companyId);
		model.addAttribute("pageType", "letterBox");
		model.addAttribute("userLang", userLang);
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		
		logger.debug("primary=" + primary);
		logger.debug("secondary=" + secondary);
		logger.debug("userLang=" + userLang);
		logger.debug("letterBoxManagerView ended.");

		return "admin/ezEmail/letterBoxManager";

	}

	/**
	 * 편지지함 목록 가져오기
	 * 
	 * @param String loginCookie
	 * @return : JSONArray
	 */
	@RequestMapping(value = "/admin/ezEmail/getLetterBox.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONArray getLetterBox(@CookieValue("loginCookie") String loginCookie, String companyId, Model model) throws Exception {
		logger.debug("getLetterBox started.");

		JSONArray returnJsonArr = new JSONArray();
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		Integer tenant = userInfo.getTenantId();
		String tenantId = Integer.toString(tenant);

		try {
			returnJsonArr = ezEmailAdminLetterService.selectAllLetterBox(companyId, tenantId);
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		logger.debug("getLetterBox ended.");

		return returnJsonArr;

	}

	/**
	 * 편지지함 추가
	 * 
	 * @param String loginCookie, Model model
	 * @return : "OK" or "ERROR"
	 */
	@RequestMapping(value = "/admin/ezEmail/createLetterBox.do", method = RequestMethod.POST)
	@ResponseBody
	public String createLetterBox(@CookieValue("loginCookie") String loginCookie, @ModelAttribute MailLetterBoxVO letterBox) throws Exception {
		logger.debug("createLetterBox started.");
		logger.debug("letterBox=" + letterBox);

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Integer tenant = userInfo.getTenantId();
		String tenantId = Integer.toString(tenant);
		Integer parentNo = letterBox.getParentLetterBoxNo();
		String parentLetterboxNo = Integer.toString(parentNo);
		String displayname = letterBox.getDisplayname();
		String displayname2 = letterBox.getDisplayname2();
		String companyId = letterBox.getCompanyID();
		String returnStr = "OK";

		try {
			ezEmailAdminLetterService.insertLetterBox(parentLetterboxNo, displayname, displayname2, companyId, tenantId);
		} catch (UnsupportedEncodingException e) {
			returnStr = "ERROR";
		} catch (Exception e) {
			returnStr = "ERROR";
		}

		logger.debug("createLetterBox ended.");

		return returnStr;

	}

	/**
	 * 편지지함 조회 (개별)
	 * 
	 * @param String loginCookie, MailLetterBoxVO letterBox
	 * @return : JSONObject
	 */
	@RequestMapping(value = "/admin/ezEmail/readLetterBox.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject readLetterBox(@CookieValue("loginCookie") String loginCookie, @ModelAttribute MailLetterBoxVO letterBox) throws Exception {
		logger.debug("readLetterBox started.");
		logger.debug("letterBox=" + letterBox);

		JSONObject json = null;

		Integer boxNo = letterBox.getLetterBoxNo();
		String letterBoxNo = Integer.toString(boxNo);

		try {
			json = ezEmailAdminLetterService.selectOneLetterBox(letterBoxNo);
		} catch (RuntimeException e) {
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

	/**
	 * 편지지함 수정
	 * 
	 * @param String loginCookie, Model model
	 * @return : String loginCookie, MailLetterBoxVO letterBox
	 */
	@RequestMapping(value = "/admin/ezEmail/updateLetterBox.do", method = RequestMethod.POST)
	@ResponseBody
	public String updateLetterBox(@CookieValue("loginCookie") String loginCookie, @ModelAttribute MailLetterBoxVO letterBox) throws Exception {
		logger.debug("updateLetterBox started.");
		logger.debug("letterBox=" + letterBox);

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Integer tenant = userInfo.getTenantId();
		String tenantId = Integer.toString(tenant);
		Integer boxNo = letterBox.getLetterBoxNo();
		String letterBoxNo = Integer.toString(boxNo);
		Integer parentNo = letterBox.getParentLetterBoxNo();
		String parent_letterbox_no = Integer.toString(parentNo);
		String displayname = letterBox.getDisplayname();
		String displayname2 = letterBox.getDisplayname2();
		String companyId = letterBox.getCompanyID();
		String returnStr = "OK";

		try {
			ezEmailAdminLetterService.updateLetterBox(letterBoxNo, parent_letterbox_no, displayname, displayname2, companyId, tenantId);
		} catch (RuntimeException e) {
			returnStr = "ERROR";
		} catch (Exception e) {
			returnStr = "ERROR";
		}

		logger.debug("updateLetterBox ended.");
		return returnStr;
	}

	/**
	 * 편지지함 삭제
	 * 
	 * @param String loginCookie, Model model
	 * @return : int letterBoxNo
	 */
	@RequestMapping(value = "/admin/ezEmail/deleteLetterBox.do", method = RequestMethod.POST)
	@ResponseBody
	public String deleteLetterBox(@CookieValue("loginCookie") String loginCookie, int letterBoxNo) throws Exception {
		logger.debug("deleteLetterBox started.");
		logger.debug("letterBoxNo=" + letterBoxNo);

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		String letterboxNum = Integer.toString(letterBoxNo);
		String returnStr = "OK";

		try {
			ezEmailAdminLetterService.deleteLetterBox(letterboxNum);
		} catch (UnsupportedEncodingException e) {
			returnStr = "ERROR";
		} catch (Exception e) {
			returnStr = "ERROR";
		}

		logger.debug("deleteLetterBox ended.");
		return returnStr;
	}

	/**
	 * 편지지 순서 수정 (재은)
	 * 
	 * @param String loginCookie, String letterOrder, String letterNo
	 * @return : String
	 */
	@RequestMapping(value = "/admin/ezEmail/updateLetterOrder.do", method = RequestMethod.POST)
	@ResponseBody
	public String updateLetterOrder(@CookieValue("loginCookie") String loginCookie, String letterOrder, String letterNo) throws Exception {
		logger.debug("updateLetterOrder started.");
		logger.debug("letterOrder=" + letterOrder + ", letterNo=" + letterNo);

		String returnStr = "OK";

		try {
			ezEmailAdminLetterService.updateLetterOrder(letterOrder, letterNo);
		} catch (RuntimeException e) {
			returnStr = "ERROR";
		} catch (Exception e) {
			returnStr = "ERROR";
		}

		logger.debug("updateLetterOrder ended.");
		return returnStr;
	}

	/**
	 * 편지지 편지지함 이동 (재은)
	 * 
	 * @param String loginCookie, String letterNo, String parentLetterBoxNo, String letterOrder
	 * @return : String
	 */
	@RequestMapping(value = "/admin/ezEmail/updateLetterMove.do", method = RequestMethod.POST)
	@ResponseBody
	public String updateLetterMove(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, String letterBox, String letterNo, String parentLetterBoxNo, String letterId)
			throws Exception {
		logger.debug("updateLetterMove started.");
		logger.debug("letterBox=" + letterBox + ",letterNo=" + letterNo + ", parentLetterBoxNo=" + parentLetterBoxNo + ", letterId=" + letterId);
		// letterBox = 기존 있던 폴더
		// parentLetterBoxNo = 새로 옮길 폴더

		String returnStr = "OK";

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String fileType = "html";
		String letterFilePath = commonUtil.getUploadPath("upload_mail.LETTER", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		String fileName = "letter." + fileType;

		try {
			letterBox = commonUtil.detectPathTraversal(letterBox);
			letterNo = commonUtil.detectPathTraversal(letterNo);
			parentLetterBoxNo = commonUtil.detectPathTraversal(parentLetterBoxNo);
			letterId = commonUtil.detectPathTraversal(letterId);
			
			String filePath = letterFilePath + commonUtil.separator + letterBox + "/"; // + letterId
			logger.debug(filePath);
			
			ezEmailAdminLetterService.updateLetterMove(letterNo, parentLetterBoxNo);
			
			// 이동 할 편지지 디렉토리명 변경하기  (같은 위치에 옮겨졌을때 대비)
			String exFolder = realPath + filePath + letterId;
			String changeFolder = realPath + filePath + letterId + "-old"; // 변경할 디렉토리명
			File exFile = new File(exFolder); // 변경 전
			File chFile = new File(changeFolder); // 변경 후
			exFile.renameTo(chFile); // 변경
			logger.debug("changeFolder=" + changeFolder + ", exFolder=" + exFolder);

			// 이동하기
			String originPath = changeFolder; // 이동할 디렉토리
			String path = realPath + letterFilePath + commonUtil.separator;
			String folderName = parentLetterBoxNo + "/" + letterId; // 새로 옮길 편지지함(경로) + 폴더명
			String uploadPath = letterFilePath;
			logger.debug("originPath(이동할) " + originPath + ", path " + path + ", folderName(새로)" + folderName + ", uploadPath " + uploadPath);
			
			String result = moveFile(folderName, fileName, originPath, path, uploadPath, letterBox, letterId);
			
			if (result != null) {
				File file = new File(changeFolder);
				
				if (file.exists()) {
					deleteDirectory(file);
				}

				logger.debug("SUCCESS: " + result);

			} else {
				logger.debug("FAIL");
			}
		} catch (RuntimeException e) {
			returnStr = "ERROR";
		} catch (Exception e) {
			returnStr = "ERROR";
		}

		logger.debug("updateLetterMove ended.");
		return returnStr;

	}

	/**
	 * 편지지 관리페이지 화면 전환(수아)
	 */
	@RequestMapping(value = "/admin/ezEmail/letterAdminPage.do", method = RequestMethod.GET)
	public String letterAdminPage(@CookieValue("loginCookie") String loginCookie, String companyId, Model model) throws Exception {
		logger.debug("letterAdminPage started.");

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		logger.debug("lang : " + loginInfo.getLang());

		model.addAttribute("pageType", "letter");
		companyId = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(companyId));
		model.addAttribute("companyId", companyId);
		
		model.addAttribute("userLang", commonUtil.getPrimaryData(loginInfo.getLang(), loginInfo.getTenantId()));
		//model.addAttribute("userLang", loginInfo.getLang());

		logger.debug("letterAdminPage ended.");
		return "admin/ezEmail/letterManager";
	}

	/**
	 * 편지지 추가,수정 팝업 화면 전환(수아)
	 */
	@RequestMapping(value = "/admin/ezEmail/letterEditPopUp.do", method = RequestMethod.GET)
	public String letterAdminAddSetPopUp(
			@CookieValue("loginCookie") String loginCookie,
			Locale locale,
			String letterBoxNo, 
			String popUpType, 
			String letterNo, 
			Model model) throws Exception {
		logger.debug("letterAdminAddSetPopUp started.");
		logger.debug("letterBoxNo=" + letterBoxNo + ", popUpType=" + popUpType + ", letterNo=" + letterNo);

		LoginVO loginInfo = commonUtil.userInfo(loginCookie);

        String primary = ezCommonService.getTenantConfig("LangPrimary" + loginInfo.getLang(), loginInfo.getTenantId());
        String secondary = ezCommonService.getTenantConfig("LangSecondary" + loginInfo.getLang(), loginInfo.getTenantId());
        String defaultFontAndSize = "style='font-size:13px;font-family:" + egovMessageSource.getMessage("main.t246", locale) + "'";
        logger.debug("defaultFontAndSize : " + defaultFontAndSize);
        
		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		
		// 편지지 고유 id
		UUID letterId = null;

		if (popUpType.equals("add")) { // 편지지 작성
			letterId = UUID.randomUUID();
		}
		logger.debug("letterId=" + letterId);

		//사용자 언어가 한국어이고 editorFontStyle값이 있을 경우 editorFontStyle값 적용
		if (loginInfo.getLang().equals("1")) {
			String editorFontStyle = ezCommonService.getTenantConfig("editorFontStyle", loginInfo.getTenantId());
			
			if (!editorFontStyle.equals("")) {
				String fontFamily = editorFontStyle.split("\\|")[0];
				String fontSize = editorFontStyle.split("\\|")[1];
				
				defaultFontAndSize = "style='font-size:" + fontSize + ";font-family:" + fontFamily + "'";
			}
		}
		logger.debug("defaultFontAndSize : " + defaultFontAndSize);
		
		model.addAttribute("letterBoxNo", letterBoxNo);
		model.addAttribute("letterId", letterId);
		model.addAttribute("letterNo", letterNo);
		model.addAttribute("popUpType", popUpType);
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		model.addAttribute("defaultFontAndSize", defaultFontAndSize);

		logger.debug("letterAdminAddSetPopUp ended.");
		return "admin/ezEmail/letterEditPopUp";
	}

	/**
	 * 편지지함 이동(변경) 팝업 (수아)
	 */
	@RequestMapping(value = "/admin/ezEmail/letterBoxMovePopUp.do", method = RequestMethod.GET)
	public String letterAdminBoxMovePopUp(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, String letterBox, @RequestParam("letterNo") String letterNo, @RequestParam("letterId") String letterId,
			Model model) throws Exception {

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = request.getParameter("companyId") != null ? request.getParameter("companyId") : userInfo.getCompanyID();
		String userLang = userInfo.getPrimary();
		
		model.addAttribute("letterBox", letterBox);
		model.addAttribute("letterId", letterId);
		model.addAttribute("letterNo", letterNo);
		model.addAttribute("companyId", companyId);
		model.addAttribute("pageType", "letter_move");
		model.addAttribute("userLang", userLang);

		return "admin/ezEmail/letterBoxMovePopUp";
	}

	/**
	 * 편지지 작성 (수아)
	 * 
	 * @param : displayname, displayname2, letterBoxNo
	 * @return : "OK" or "ERROR" or "파일생성이 안되었습니다."
	 */
	@RequestMapping(value = "/admin/ezEmail/createLetter.do", method = RequestMethod.POST)
	@ResponseBody
	public String createLetter(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @ModelAttribute MailLetterVO letter) throws Exception {
		logger.debug("createLetter started.");
		logger.debug("letter=" + letter);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		String displayname = letter.getDisplayname(); // 편지지명
		String displayname2 = letter.getDisplayname2(); // 편지지명(영문)
		String letterBoxNo = Integer.toString(letter.getLetterBoxNo()); // 편지지함
																		// 번호
		String letterId = letter.getLetterId(); // 편지지 uuid
		String letterContent = letter.getLetterContent(); // 편지지 내용(html)
		String letterNo = Integer.toString(letter.getLetterNo());
		logger.debug("letterBoxNo=" + letterBoxNo + ", letterId=" + letterId + ", displayname:" + displayname + ", displayname2=" + displayname2 + ", letterContent=" + letterContent + ", letterNo="
				+ letterNo);

		// 편지지 내용(html)저장
		String fileType = "html";
		String filePath = commonUtil.getUploadPath("upload_mail.LETTER", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		String fileName = "letter." + fileType;

		String returnStr = "OK";

		try {
			letterBoxNo = commonUtil.detectPathTraversal(letterBoxNo);
			letterId = commonUtil.detectPathTraversal(letterId);
			
			// files/upload_mail/letterBoxUpload/.../...
			filePath = filePath + commonUtil.separator + letterBoxNo + "/" + letterId;
			logger.debug("filePath=" + filePath);
			
			File file = new File(realPath + filePath);

			if (!file.exists()) {
				file.mkdirs();
			}

			// CWE-404 보안 취약점 대응
			try (BufferedWriter fw = new BufferedWriter(new FileWriter(file + commonUtil.separator + fileName))) {
				fw.write(letterContent);
				fw.flush();
			}

			if (file.exists()) {
				ezEmailAdminLetterService.addLetter(displayname, displayname2, letterBoxNo, letterId);
			} else {
				throw new Exception();
			}
			
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnStr = "ERROR";
			logger.error(e.getMessage(), e);
		}

		logger.debug("createLetter ended.");
		return returnStr;
	}

	/**
	 * 편지지 수정 - 편지지 이름 (수아)
	 * 
	 * @param displayname, displayname2, letterNo
	 * @return : "OK" or "ERROR"
	 */
	@RequestMapping(value = "/admin/ezEmail/updateDisplayNameLetter.do", method = RequestMethod.POST)
	@ResponseBody
	public String updateDisplayNameLetter(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @ModelAttribute MailLetterVO letter) throws Exception {
		logger.debug("updateDisplayNameLetter started.");
		logger.debug("letter=" + letter);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		String displayname = letter.getDisplayname();
		String displayname2 = letter.getDisplayname2();
		String letterNo = Integer.toString(letter.getLetterNo());
		String letterBoxNo = Integer.toString(letter.getLetterBoxNo());
		String letterId = letter.getLetterId();
		String letterContent = letter.getLetterContent(); // 편지지 내용(html)
		String returnStr = "OK";

		logger.debug("letterBoxNo=" + letterBoxNo + ", letterId=" + letterId + ", displayname:" + displayname + ", displayname2=" + displayname2 + ", letterContent=" + letterContent);

		// 편지지 내용(html)저장
		String fileType = "html";
		String filePath = commonUtil.getUploadPath("upload_mail.LETTER", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		String fileName = "letter." + fileType;

		try {
			letterBoxNo = commonUtil.detectPathTraversal(letterBoxNo);
			letterId = commonUtil.detectPathTraversal(letterId);
			
			// files/upload_mail/letterBoxUpload/.../...
			filePath = filePath + commonUtil.separator + letterBoxNo + "/" + letterId;
			logger.debug("filePath=" + filePath);
			
			File file = new File(realPath + filePath);
			File fileHtml = new File(realPath + filePath + "/" + fileName);

			if (!file.exists()) {
				file.mkdirs();
			}

			if (fileHtml.exists()) {
				fileHtml.delete();
			}

			// CWE-404 보안 취약점 대응
			try (BufferedWriter fw = new BufferedWriter(new FileWriter(file + commonUtil.separator + fileName))) {
				fw.write(letterContent);
				fw.flush();
			}

			ezEmailAdminLetterService.updateDisplayNameLetter(displayname, displayname2, letterNo);
		} catch (RuntimeException e) {
			returnStr = "ERROR";
		} catch (Exception e) {
			returnStr = "ERROR";
			// logger.error(e.getMessage(), e);
		}

		logger.debug("updateDisplayNameLetter ended.");
		return returnStr;
	}

	/**
	 * 편지지함 삭제 시 fileroot에 있는 편지지함도 삭제 (재은)
	 * 
	 * @param letterBoxNo(편지지함 번호)
	 * @return : "OK" or "ERROR"
	 */
	@RequestMapping(value = "/admin/ezEmail/deleteLetterFile", method = RequestMethod.POST)
	@ResponseBody
	public String deleteLetterFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, String letterBoxNo) throws Exception {
		logger.debug("deleteLetterFile started.");
		logger.debug("letterBoxNo=" + letterBoxNo);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		String returnStr = "OK";

		String realPath = commonUtil.getRealPath(request);
		String filePath = commonUtil.getUploadPath("upload_mail.LETTER", userInfo.getTenantId());

		try {
			letterBoxNo = commonUtil.detectPathTraversal(letterBoxNo);
			filePath = filePath + commonUtil.separator + letterBoxNo;
					
			deleteDirectory(new File(realPath + filePath));

		} catch (RuntimeException e) {
			returnStr = "ERROR";
		} catch (Exception e) {
			returnStr = "ERROR";
		}

		logger.debug("deleteLetterFile ended.");
		return returnStr;
	}

	// 하위 폴더 및 파일까지 삭제하는 함수 (재은)
	public boolean deleteDirectory(File path) {
		if (!path.exists()) {
			return false;
		}

		File[] files = path.listFiles();
		for (File file : files) {
			if (file.isDirectory()) {
				deleteDirectory(file);
			} else {
				file.delete();
			}
		}

		return path.delete();
	}
	// 폴더 이동할때 fileroot를 옮기는 함수 (재은)   folderName, fileName, originPath, path, uploadPath, letterBox, letterId
	public String moveFile(String folderName, String fileName, String originPath, String copyPath, String uploadPath, String letterBox, String letterId) throws Exception{
		String path = copyPath + "/" + folderName;
		String filePath = path + "/" + fileName;
		File dir = new File(path);

		if (!dir.exists()) { // 폴더 없으면 폴더 생성
			dir.mkdirs();
		}

		try {
			File file = new File(originPath + "/" + fileName);

			if (file.renameTo(new File(filePath))) { // 파일 이동

				dir = new File(originPath + "/images"); // 이미지 있으면 이미지도 이동시켜줄것
				if (dir.exists()) {

					File newImages = new File(path + "/images");
					newImages.mkdirs();

					File[] imgs = dir.listFiles();

					for (int i = 0; i < imgs.length; i++) {
						imgs[i].renameTo(new File(newImages.toString() + "/" + imgs[i].getName()));
					}

					updateFile(new File(copyPath + folderName + "/" + fileName), uploadPath + "/" + letterBox + "/" + letterId, uploadPath + "/" + folderName);

				}

				return originPath; // 성공시 성공 파일 경로 return
			} else {
				return null;
			}
		} catch (RuntimeException e) {
			logger.error(e.getMessage(), e);
			return null;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return null;
		}
	}

	// html파일의 img src 경로 바꿔주는 함수 (재은)
	public String updateFile(File htmlFile, String originPath, String copyPath) {
		// file, originPath, path

		String resultReturn = "OK";
		String result = null;
		try {
			// CWE-404 보안 취약점 대응
			try (FileReader reader = new FileReader(htmlFile);
				FileWriter writer = new FileWriter(htmlFile)) {
				result = "";

				int c;

				while (true) {
					c = reader.read();
					if (c == -1) {
						break;
					}
					result += String.valueOf((char) c);
				}

				String replaceResult = "";
				if (result != null && result.length() > 0) {
					if (result.contains("<img src=\"")) {
						replaceResult = result.replaceAll(originPath, copyPath);
					}
				}

				writer.write(replaceResult);
				writer.flush();
			}
		} catch (IOException e) {
			logger.error(e.getMessage(), e);
			resultReturn = "ERROR";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			resultReturn = "ERROR";
		}

		return resultReturn;
	}

	/**
	 * 편지지 삭제 (수아)
	 * 
	 * @param letterNo (편지지 번호)
	 * @return : "OK" or "ERROR"
	 */
	@RequestMapping(value = "/admin/ezEmail/deleteLetter", method = RequestMethod.POST)
	@ResponseBody
	public String deleteLetter(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, String letterNo, String letterBoxNo, String letterId) throws Exception {
		logger.debug("deleteLetter started.");
		logger.debug("letterNo=" + letterNo);
		logger.debug("letterBoxNo=" + letterBoxNo + "letterId=" + letterId);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		String returnStr = "OK";

		// /files/upload_mail/letterBoxUpload/
		String realPath = commonUtil.getRealPath(request);
		String filePath = commonUtil.getUploadPath("upload_mail.LETTER", userInfo.getTenantId());
		
		try {
			letterBoxNo = commonUtil.detectPathTraversal(letterBoxNo);
			letterId = commonUtil.detectPathTraversal(letterId);
			letterNo = commonUtil.detectPathTraversal(letterNo);
			
			filePath = filePath + commonUtil.separator + letterBoxNo + "/" + letterId;
			
			ezEmailAdminLetterService.deleteLetter(letterNo);

			File file = new File(realPath + filePath);
			logger.debug("path=" + realPath + filePath);

			if (file.exists()) {
				File[] fileList = file.listFiles();

				for (File f : fileList) {
					if (!f.delete()) { // 삭제가 안되면 이미지 폴더 밑에 이미지들 삭제
						File[] imgList = f.listFiles();
						for (File imgF : imgList) {
							imgF.delete();
						}
						f.delete();
					}
				}
				file.delete();
			}
		} catch (RuntimeException e) {
			returnStr = "ERROR";
		} catch (Exception e) {
			returnStr = "ERROR";
			// logger.error(e.getMessage(), e);
		}

		logger.debug("deleteLetter ended.");
		return returnStr;
	}

	/**
	 * 편지지 목록 조회 (수아)
	 * 
	 * @param letterBoxNo (편지지함 번호)
	 * @return : JSONArray
	 */
	@RequestMapping(value = "/admin/ezEmail/readLetterList", method = RequestMethod.POST)
	@ResponseBody
	public JSONArray readLetterList(@CookieValue("loginCookie") String loginCookie, @RequestParam("letterBoxNo") String letterBoxNo, HttpServletResponse response, Model model) throws Exception {
		logger.debug("readLetterList started.");
		logger.debug("letterBoxNo=" + letterBoxNo);
		
		JSONArray returnJsonArr = new JSONArray();

		try {
			returnJsonArr = ezEmailAdminLetterService.selectAllLeter(letterBoxNo);
			logger.debug("jsonArr=" + returnJsonArr);
		} catch (RuntimeException e) {
			logger.debug("e.message=" + e.getMessage());
		} catch (Exception e) {
			logger.debug("e.message=" + e.getMessage());
		}
		
		logger.debug("readLetterList ended.");
		return returnJsonArr;
	}

	/**
	 * 편지지 개별 조회 (수아)
	 * 
	 * @param letterNo(편지지 번호)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezEmail/readLetter", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject readLetter(@CookieValue("loginCookie") String loginCookie, String letterNo, String popUpType, HttpServletRequest request) throws Exception {
		logger.debug("readLetter started.");
		logger.debug("letterNo=" + letterNo + ", popUpType=" + popUpType);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		JSONObject returnJson = new JSONObject();

		String fileType = "html";
		String fileName = "letter." + fileType;
		String filePath = commonUtil.getUploadPath("upload_mail.LETTER", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		logger.debug("filePath=" + filePath);

		try {
			letterNo = commonUtil.detectPathTraversal(letterNo);
			returnJson = ezEmailAdminLetterService.selectDetailLetter(letterNo);

			String letter = filePath + commonUtil.separator + returnJson.get("letterBoxNo") + "/" + returnJson.get("letterId") + "/" + fileName;
			
			File file = new File(realPath + letter);

			if (!file.exists()) {
				letter = "ERROR";
			} else {
				if (popUpType != null && popUpType.equals("modify")) {
					String letterHtml = "";
					String letterHtmlTemp = "";
					// CWE-404 보안 취약점 대응
					try (BufferedReader br = new BufferedReader(new FileReader(file))) {
						while ((letterHtmlTemp = br.readLine()) != null) {
							letterHtml += letterHtmlTemp;
						}
					}
					returnJson.put("letterHtml", letterHtml);
					logger.debug("letterHtml=" + letterHtml);
				}
			}
			logger.debug("letter=" + letter);

			returnJson.put("filePath", letter);
		} catch (RuntimeException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("readLetter ended.");
		return returnJson;
	}
}