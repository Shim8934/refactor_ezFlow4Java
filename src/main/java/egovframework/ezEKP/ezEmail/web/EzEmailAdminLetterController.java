package egovframework.ezEKP.ezEmail.web;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.antlr.grammar.v3.ANTLRParser.throwsSpec_return;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.ezEKP.ezEmail.service.EzEmailAdminLetterService;
import egovframework.ezEKP.ezEmail.vo.MailLetterBoxVO;
import egovframework.ezEKP.ezEmail.vo.MailLetterVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;


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
	@RequestMapping(value="/admin/ezEmail/letterMain.do")
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
	 * 편지지함 화면 호출
	 * @param String loginCookie, Model model
	 * @return : String
	 */
	@RequestMapping(value="/admin/ezEmail/letterBoxManager.do")
	public String letterBoxManagerView(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String companyId) throws Exception {
		logger.debug("letterBoxManagerView started.");
		logger.debug("companyId=" + companyId);
		
		// 관리자 권한체크      
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		
		model.addAttribute("companyId", companyId);
		model.addAttribute("pageType", "letterBox");
				
		logger.debug("letterBoxManagerView ended.");
		
		return "admin/ezEmail/letterBoxManager";
		
	}
	
	/**
	 * 편지지함 목록 가져오기
	 * @param String loginCookie
	 * @return : JSONArray
	 */
	@RequestMapping(value="/admin/ezEmail/getLetterBox.do")
	@ResponseBody
	public JSONArray getLetterBox(@CookieValue("loginCookie") String loginCookie, String companyId) throws Exception {
		logger.debug("getLetterBox started.");
		
		JSONArray returnJsonArr = new JSONArray();
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Integer tenant = userInfo.getTenantId();
		String tenantId = Integer.toString(tenant);
		
		try {
			returnJsonArr = EzEmailAdminLetterService.selectAllLetterBox(companyId, tenantId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		logger.debug("getLetterBox ended.");
		
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
			EzEmailAdminLetterService.insertLetterBox(parentLetterboxNo, displayname, displayname2, companyId, tenantId);
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
		String letterBoxNo = Integer.toString(boxNo);
		
		try {
			json = EzEmailAdminLetterService.selectOneLetterBox(letterBoxNo);
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
			EzEmailAdminLetterService.updateLetterBox(letterBoxNo, parent_letterbox_no, displayname, displayname2, companyId, tenantId);
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
		
		String letterboxNum = Integer.toString(letterBoxNo);
		String returnStr = "OK";
		
		try {
			EzEmailAdminLetterService.deleteLetterBox(letterboxNum);
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
	 * 편지지 관리페이지 화면 전환(수아)
	 */
	@RequestMapping("/admin/ezEmail/letterAdminPage.do")
	public String letterAdminPage(@CookieValue("loginCookie") String loginCookie, String companyId, Model model) throws Exception{
		logger.debug("letterAdminPage started.");
		
		// 관리자 권한체크      
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		model.addAttribute("pageType", "letter");
		model.addAttribute("companyId", companyId);
		
		logger.debug("letterAdminPage ended.");
		return "admin/ezEmail/letterManager";
	}
	
	/**
	 * 편지지 추가,수정 팝업  화면 전환(수아)
	 */
	@RequestMapping("/admin/ezEmail/letterEditPopUp.do")
	public String letterAdminAddSetPopUp(@CookieValue("loginCookie") String loginCookie, String letterBoxNo, String popUpType , String letterNo, Model model) throws Exception{
		logger.debug("letterAdminAddSetPopUp started.");
		logger.debug("letterBoxNo=" + letterBoxNo + ", popUpType=" + popUpType + ", letterNo=" + letterNo);

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

		model.addAttribute("letterBoxNo", letterBoxNo);
		model.addAttribute("letterId", letterId);
		model.addAttribute("letterNo", letterNo);
		model.addAttribute("popUpType", popUpType);
		
		logger.debug("letterAdminAddSetPopUp ended.");
		return "admin/ezEmail/letterEditPopUp";
	}
	
	/**
	 * 편지지함 이동(변경) 팝업 (수아)
	 */
	@RequestMapping("/admin/ezEmail/letterBoxMovePopUp.do")
	public String letterAdminBoxMovePopUp(@CookieValue("loginCookie") String loginCookie, @RequestParam("letterNo") String letterNo, Model model) throws Exception{
		
		model.addAttribute("letterNo", letterNo);
		
		return "admin/ezEmail/letterBoxMovePopUp";
	}
	
	/**
	 * 편지지 추가, 수정 이미지 업로드 (수아)
	 */
	@RequestMapping(value = "/admin/ezEmail/letterImageUpload.do", produces = "application/json; charset=utf-8")
	@ResponseBody
	public void letterImageUpload(@CookieValue("loginCookie")String loginCookie, @RequestParam MailLetterVO letter, Model model) throws Exception{
		logger.debug("letterImageUpload started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String letterBoxNo = Integer.toString(letter.getLetterBoxNo());
		String letterId = letter.getLetterId();
		String displayname = letter.getDisplayname();
		String displayname2 = letter.getDisplayname2();
		String letterContent = letter.getLetterContent();
		
		logger.debug("letterBoxNo=" + letterBoxNo + ", letterId=" + letterId + ", displayname:" + displayname
				+ ", displayname2=" + displayname2 + ", letterContent=" + letterContent);
				
		
		
		/*LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		MultipartFile multiFile = request.getFile("upload");
		String fileType = multiFile.getContentType().replace("\\", "/").split("/")[1];
		
		String filePath = commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		String today = EgovDateUtil.getToday("");
		String fileName = UUID.randomUUID() + "." + fileType;
		
		filePath = filePath + commonUtil.separator + today;
		File file = new File(realPath + filePath);
		
		if (!file.exists()) {
			file.mkdirs();
		}
		
		writeUploadedFile(multiFile, fileName, realPath + filePath);
		//return "<script>window.parent.CKEDITOR.tools.callFunction(2, '" + (filePath + commonUtil.separator + fileName).replace("\\", "/") + "', '')</script>";
		logger.debug("ckSimpleUpload ended");
		return "{\"uploaded\": 1,\"fileName\": \""+fileName+"\", \"url\": \"" + (filePath + commonUtil.separator + fileName).replace("\\", "/") + "\"}";*/
	}
	
	/**
	 * 편지지 작성 (수아)
	 * @param : displayname, displayname2, letterBoxNo
	 * @return : "OK" or "ERROR" or "파일생성이 안되었습니다."
	 */
	@RequestMapping("/admin/ezEmail/createLetter.do")
	@ResponseBody
	public String createLetter(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @ModelAttribute MailLetterVO letter) throws Exception{
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
		String letterBoxNo = Integer.toString(letter.getLetterBoxNo()); // 편지지함 번호
		String letterId = letter.getLetterId(); // 편지지 uuid
		String letterContent = letter.getLetterContent(); // 편지지 내용(html)
		String letterNo = Integer.toString(letter.getLetterNo());
		logger.debug("letterBoxNo=" + letterBoxNo + ", letterId=" + letterId + ", displayname:" + displayname
				+ ", displayname2=" + displayname2 + ", letterContent=" + letterContent + ", letterNo=" + letterNo);

		// 편지지 내용(html)저장
		String fileType = "html";
		String filePath = commonUtil.getUploadPath("upload_mail.LETTER", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		String fileName = "letter." + fileType;
		
		// files/upload_mail/letterBoxUpload/.../...
		filePath = filePath + commonUtil.separator + letterBoxNo + "/" + letterId;
		logger.debug("filePath=" + filePath);
		
		String returnStr = "OK";
		
		try {
			File file = new File(realPath + filePath);
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			BufferedWriter fw = new BufferedWriter(new FileWriter(file + commonUtil.separator + fileName)); 
			fw.write(letterContent);
			fw.flush();
			fw.close();
			
			if (file.exists()) {
				EzEmailAdminLetterService.addLetter(displayname, displayname2, letterBoxNo, letterId);
			} else {
				throw new Exception();
			}
			
		} catch (Exception e) {
			returnStr = "ERROR";
			e.printStackTrace();
		}

		logger.debug("createLetter ended.");
		return returnStr;
	}
	
	/**
	 * 편지지 수정 - 편지지 이름 (수아)
	 * @param displayname, displayname2, letterNo
	 * @return : "OK" or "ERROR"
	 */
	@RequestMapping("/admin/ezEmail/updateDisplayNameLetter.do")
	@ResponseBody
	public String updateDisplayNameLetter(@CookieValue("loginCookie") String loginCookie,HttpServletRequest request, @ModelAttribute MailLetterVO letter) throws Exception{
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
		
		logger.debug("letterBoxNo=" + letterBoxNo + ", letterId=" + letterId + ", displayname:" + displayname
				+ ", displayname2=" + displayname2 + ", letterContent=" + letterContent);

		// 편지지 내용(html)저장
		String fileType = "html";
		String filePath = commonUtil.getUploadPath("upload_mail.LETTER", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		String fileName = "letter." + fileType;
		
		// files/upload_mail/letterBoxUpload/.../...
		filePath = filePath + commonUtil.separator + letterBoxNo + "/" + letterId;
		logger.debug("filePath=" + filePath);
		
		try {
			
			File file = new File(realPath + filePath);
			File fileHtml = new File(realPath + filePath + "/" + fileName);
			
			if (fileHtml.exists()) {
				fileHtml.delete();
			}
			
			BufferedWriter fw = new BufferedWriter(new FileWriter(file + commonUtil.separator + fileName)); 
			fw.write(letterContent);
			fw.flush();
			fw.close();
			
			if (file.exists()) {
				EzEmailAdminLetterService.updateDisplayNameLetter(displayname, displayname2, letterNo);
			} else {
				returnStr = "파일생성이 안되었습니다.";
			}
			
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
	@RequestMapping("/admin/ezEmail/updateOrderLetter.do")
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
	@RequestMapping("/admin/ezEmail/updateBoxLetter.do")
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
	public String deleteLetter(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, String letterNo, String letterBoxNo, String letterId) throws Exception{
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
		filePath = filePath + commonUtil.separator + letterBoxNo + "/" + letterId; 	
		
		try {
			EzEmailAdminLetterService.deleteLetter(letterNo);
			
			File file = new File(realPath + filePath);
			logger.debug("path=" + realPath + filePath);
			
			if (file.exists()) {
				File[] fileList = file.listFiles();
				
				for (File f : fileList) {
					if (!f.delete()){ // 삭제가 안되면 이미지 폴더 밑에 이미지들 삭제
						File[] imgList = f.listFiles();
						for (File imgF : imgList) {
							imgF.delete();
						}
						f.delete();
					}
				}
				file.delete();
			}
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
	public JSONArray readLetterList(@RequestParam("letterBoxNo") String letterBoxNo, HttpServletResponse response) throws Exception{
		logger.debug("readLetterList started.");
		logger.debug("letterBoxNo=" + letterBoxNo);
		
		JSONArray returnJsonArr = new JSONArray();
		
		try {
			returnJsonArr = EzEmailAdminLetterService.selectAllLeter(letterBoxNo);
			logger.debug("jsonArr=" + returnJsonArr);
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
	public JSONObject readLetter(@CookieValue("loginCookie") String loginCookie, String letterNo, String popUpType, HttpServletRequest request) throws Exception{
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
			returnJson = EzEmailAdminLetterService.selectDetailLetter(letterNo);

			String letter = filePath + commonUtil.separator + returnJson.get("letterBoxNo") + "/" 
						+ returnJson.get("letterId") + "/" + fileName;
			
			File file = new File(realPath + letter);
			
			if (!file.exists()) {
				letter = "ERROR";
			} else {
				if (popUpType != null && popUpType.equals("modify")) {
					String letterHtml = "";
					String letterHtmlTemp = "";
					BufferedReader br = new BufferedReader(new FileReader(file));
					
					while ((letterHtmlTemp = br.readLine()) != null) {
						letterHtml += letterHtmlTemp;
					}
					
					returnJson.put("letterHtml", letterHtml);
					logger.debug("letterHtml=" + letterHtml);
				}
			}
			logger.debug("letter=" + letter);
			
			returnJson.put("filePath", letter);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("readLetter ended.");
		return returnJson;
	}
}