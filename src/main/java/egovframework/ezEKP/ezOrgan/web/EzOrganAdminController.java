package egovframework.ezEKP.ezOrgan.web;

import java.awt.image.BufferedImage;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 관리자 - 조직도관리
 * @author 오픈솔루션팀 장진혁
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.14    장진혁    신규작성
 *
 * @see
 */

@Controller
public class EzOrganAdminController extends EgovFileMngUtil{
	
	@Autowired	
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzCommonService ezCommonService;

	// dhlee
	@Autowired
	private EzEmailUserAdminService ezEmailUserAdminService;
	// dhlee - end
	 
	/**
	 * 조직도관리 메인화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/organMain.do")
	public String organMain() throws Exception{        
		return "admin/ezOrgan/organMain";
	}
	
	/**
	 * 조직도관리 왼쪽화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/organLeft.do")
	public String organLeft() throws Exception{        
		return "admin/ezOrgan/organLeft";
	}
	
	/**
	 * 조직도관리 오른쪽화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/organRight.do")
	public String organRight(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		LoginVO user = commonUtil.userInfo(loginCookie);		
		//관리자 권한 체크
		if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		String topid = "";
		
		if (user.getRollInfo().indexOf("c=1") == -1) {
			topid = user.getCompanyID();
		} else {
			topid = "Top";
		}
		
		model.addAttribute("topid", topid);
		model.addAttribute("useOCS", config.getProperty("config.USE_OCS"));
		
		return "admin/ezOrgan/organRight";
	}
	
	/**
	 * 조직도관리 회사추가 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/companyInfo.do")
	public String companyInfo(Model model) throws Exception{
		String lang = config.getProperty("config.primary");		
		String primary = config.getProperty("config.lang_Primary" + lang);
		String secondary = config.getProperty("config.lang_Secondary" + lang);
		
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		
		return "admin/ezOrgan/companyInfo";
	}
	
	/**
	 * 조직도관리 회사추가 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveCompanyInfo.do", produces = "text/html;charset=utf-8")	
	@ResponseBody
	public String saveCompanyInfo(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String parentCn = request.getParameter("parentCn");
		String cn = request.getParameter("cn");
		String displayName = request.getParameter("displayName");
		String displayName2 = request.getParameter("displayName2");
		String domain = config.getProperty("config.DomainName");
		String result = "";
		String ldapPath = "";
		
		int cnt = ezOrganAdminService.companyCheck(cn);

		if (cnt > 0) {
			result = "PRE";
		} else {
			String mailAddr = cn + "@" + domain;
			
			// skyblue0o0
			int rc = ezEmailUserAdminService.addGroup(mailAddr);
			
			if (rc == 0) { // addGroup 성공
				
				String groupAddr = parentCn + "@" + domain;
				rc = ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
				
				if (rc == 0) { // updateGroupAdd 성공
					
					//insertDBData_company 실패했을 경우 JMocha에서 회사 다시 삭제.
					try {
						ezOrganAdminService.insertDBData_company(cn, displayName, displayName2, mailAddr, parentCn, ldapPath);
						result = "OK";	
					} catch (Exception e) {
						ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
						ezEmailUserAdminService.removeGroup(mailAddr);
						throw e;
					}
								
				} else {
					result = "EMAIL_ERROR";
				}
			} else {
				result = "EMAIL_ERROR";
			}
			// skyblue0o0 - end
			
		}
		
		return result;
	}
	
	/**
	 * 조직도관리 회사삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/delDept.do", produces = "text/html;charset=utf-8")	
	@ResponseBody
	public String delDept(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String cn = request.getParameter("cn");
		String pClass = "group";
		String result = "";
		
		int cnt = ezOrganAdminService.companyChildCheck(cn);
		int usercnt = ezOrganAdminService.userCountCheck(cn);
		if (cnt > 0) {
			result = "HASCHILD";
		} else if(usercnt>0){
			result = "HASCHILD";
		}else {
			
			// skyblue0o0
			String domain = config.getProperty("config.DomainName");
			String mailAddr = cn + "@" + domain;
			
			int rc = ezEmailUserAdminService.removeGroup(mailAddr);
			
			if (rc == 0) { // removeGroup 성공
				
				OrganDeptVO dept = ezOrganService.getDeptInfo(cn, config.getProperty("config.primary"));
				String groupAddr = dept.getExtensionAttribute1() + "@" + domain;
				rc = ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
				
				if (rc == 0) { // updateGroupDel 성공
					ezOrganAdminService.deleteDBData(cn, pClass);
					result = "OK";
				} else {
					result = "EMAIL_ERROR";
				}
			} else {
				result = "EMAIL_ERROR";
			}
			// skyblue0o0 - end
			
		}
		
		return result;
	}
	
	/**
	 * 조직도관리 부서정보 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/deptInfo.do")	
	public String deptInfo(Model model) throws Exception{
		String lang = config.getProperty("config.primary");		
		String primary = config.getProperty("config.lang_Primary" + lang);
		String secondary = config.getProperty("config.lang_Secondary" + lang);
		
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		
		return "admin/ezOrgan/deptInfo";
	}

	/**
	 * 조직도관리 부서정보 및 내용 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getEntryInfo.do", produces = "text/xml;charset=utf-8")	
	@ResponseBody
	public String getEntryInfo(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String cn = request.getParameter("cn");
		String proplist = request.getParameter("prop");		
	
		String infoXML = ezOrganAdminService.getPropertyList(cn, proplist, "1");		

		return infoXML;
	}
	
	/**
	 * 조직도관리 부서정보 수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveDeptInfo.do", produces = "text/html;charset=utf-8")	
	@ResponseBody
	public String saveDeptInfo(OrganDeptVO vo, HttpServletRequest request, HttpServletResponse response) throws Exception{	
		String domain = config.getProperty("config.DomainName");
		String result = "";

		if (vo.getParentCn() == null) {
			ezOrganAdminService.updateDBData_dept(vo);
		} else {
			String cn = vo.getCn();
			int cnt = ezOrganAdminService.companyCheck(cn);
			
			if (cnt > 0) {
				result = "PRE";
			} else {

				String mailAddr = cn + "@" + domain;
				
				// skyblue0o0
				int rc = ezEmailUserAdminService.addGroup(mailAddr);
				
				if (rc == 0) { // addGroup 성공
					String groupAddr = vo.getParentCn() + "@" + domain;
					rc = ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
					
					if (rc == 0) { // updateGroupAdd 성공
						vo.setMail(mailAddr);
						
						//insertDBData_dept 실패했을 경우 JMocha에서 부서 다시 삭제.
						try {
							ezOrganAdminService.insertDBData_dept(vo);
							result = "OK";	
						} catch (Exception e) {
							ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
							ezEmailUserAdminService.removeGroup(mailAddr);
							throw e;
						}
									
					}
					else {
						result = "EMAIL_ERROR";
					}
				} else {
					result = "EMAIL_ERROR";
				}
				// skyblue0o0 - end
				
			}
		}
		
		return result;
	}
	
	/**
	 * 조직도관리 부서이동 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/selectDept.do")	
	public String selectDept(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{		
		String companyID = request.getParameter("companyID");
		
		if (companyID == null || companyID.equals("")) {
			companyID = "Top";
		}
		
		model.addAttribute("companyID", companyID);
		
		return "admin/ezOrgan/selectDept";
	}
	
	/**
	 * 조직도관리 부서이동 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/movDept.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String movDept(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{		
		String parentCn = request.getParameter("parentCn");
		String cn = request.getParameter("cn");
		
		String result = ezOrganAdminService.moveEntry(parentCn, cn, "group");

		return result;
	}
	
	/**
	 * 조직도관리 부서검색 시 중복된 부서가 있을 경우 선택 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/checkName2.do")	
	public String checkName2() throws Exception{	
		return "admin/ezOrgan/checkName2";
	}
	
	/**
	 * 조직도관리 부서 표출순서 조정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveOrderList.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String saveOrderList(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String pClass = request.getParameter("pClass");
		String cn = request.getParameter("cn");
		String[] cnDatas = cn.split(",");
		String result = "";
		
		for (int i=0; i<cnDatas.length; i++) {
			ezOrganAdminService.updateProperty(cnDatas[i], "EXTENSIONATTRIBUTE15", i+"", pClass);	
		}
		
		return result;
	}
	
	/**
	 * 조직도관리 사원정보 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/userInfo.do")	
	public String userInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{
		boolean auth = commonUtil.checkAdmin(loginCookie);
		
		if (!auth) {
			return "cmm/error/adminDenied";
		}
		
		String lang = config.getProperty("config.primary");		
		String primary = config.getProperty("config.lang_Primary" + lang);
		String secondary = config.getProperty("config.lang_Secondary" + lang);
		String checkID = config.getProperty("config.USE_CHECKUPSTR");
		
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		model.addAttribute("checkID", checkID);
		model.addAttribute("lang", lang);
		model.addAttribute("birthDay", "");
		
		return "admin/ezOrgan/userInfo";
	}
	
	/**
	 * 조직도관리 서명등록 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/configSignImage.do")	
	public String configSignImage(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{
		String userID = request.getParameter("id");
		String userInfo_approvalG = config.getProperty("config.UserInfo_ApprovalG");
		String signImageSize = config.getProperty("config.SignImageSizeLimit");
		String sign = "APPROVALSIGN";
		
		if (userInfo_approvalG.equals("YES")) {
			sign = "APPROVALGSIGN";
		}
		
		model.addAttribute("userID", userID);
		model.addAttribute("userInfo_approvalG", userInfo_approvalG);
		model.addAttribute("signImageSize", signImageSize);
		model.addAttribute("signPath", sign);
		
		return "admin/ezOrgan/configSignImage";
	}
	
	/**
	 * 조직도관리 전자결재 서명 이미지 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getApprovalSignInfo.do")
	public void getSignImage(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String type = request.getParameter("type");
		String fileName = request.getParameter("fileName");
		
		if (type.equals("APPROVALSIGN")) {
			//2016-04-15 장진혁과장 -- Approval Attach 구현 필요
		} else {			
			String filePath = config.getProperty("upload_approvalG.SIGNIMGS") + commonUtil.separator + fileName.split("_")[0] + commonUtil.separator + fileName;
			
			if (fileName != null && !fileName.equals("")) {
				ezCommonService.responseAttach(filePath, "", true, request, response);
			}
		}	
	}
	
	/**
	 * 조직도관리 암호관리 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/inputPassword.do")
	public String inputPassword(HttpServletRequest request, HttpServletResponse response) throws Exception{
		return "admin/ezOrgan/inputPassword";
	}
	
	/**
	 * 조직도관리 새로운 비밀번호 설정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/changePassword.do")
	public void changePassword(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String pw = request.getParameter("password");
		String cn[] = request.getParameter("cn").split(",");
		
		// dhlee
		String domain = config.getProperty("config.DomainName");
		// dhlee - end
		
		for (int i=0; i < cn.length; i++) {		
			// dhlee
			int rc = ezEmailUserAdminService.updateUserPassword(cn[i] + "@" + domain, pw);
			
			if (rc == 0) { // updateUserPassword 성공			
				ezOrganAdminService.setPassword(cn[i], pw);
			}
			// dhlee - end
		}
	}
	
	/**
	 * 조직도관리 사원퇴직 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/retireUser.do")
	public void retireUser(HttpServletRequest request, HttpServletResponse response) throws Exception{		
		String cn[] = request.getParameter("cn").split(",");
		
		// dhlee
		String domain = config.getProperty("config.DomainName");
		// dhlee - end
		
		for (int i=0; i < cn.length; i++) {			
			// dhlee
			int rc = ezEmailUserAdminService.retireUser(cn[i] + "@" + domain);
			
			if (rc == 0) { // retireUser 성공
				
				OrganUserVO userVO = ezOrganAdminService.getUserInfo(cn[i], config.getProperty("config.primary"));
				String groupAddr = userVO.getDepartment() + "@" + domain;
				rc = ezEmailUserAdminService.updateGroupDel(groupAddr, cn[i] + "@" + domain);
				
				if (rc == 0) { // updateGroupDel 성공
					ezOrganAdminService.retireEntry(cn[i]);
				}
				
			}
			// dhlee - end
		}
	}
	
	/**
	 * 조직도관리 사원이동 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/movUser.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String movUser(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String parentCn = request.getParameter("parentCn");
		String cn[] = request.getParameter("cn").split(",");
		String result = "OK";
		
		for (int i=0; i < cn.length; i++) {			
			result = ezOrganAdminService.moveEntry(parentCn, cn[i], "user");
		
			if (!result.equals("OK")) {
				break;
			}
		}
		return result;
	}
	
	/**
	 * 조직도관리 사원삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/delUser.do")
	public void delUser(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String cn[] = request.getParameter("cn").split(",");
		
		// dhlee
		String domain = config.getProperty("config.DomainName");
		// dhlee - end
				
		for (int i=0; i < cn.length; i++) {
			// dhlee
			int rc = ezEmailUserAdminService.removeUser(cn[i] + "@" + domain);
			
			if (rc == 0) { // removeUser 성공
				
				OrganUserVO userVO = ezOrganAdminService.getUserInfo(cn[i], config.getProperty("config.primary"));
				String groupAddr = userVO.getDepartment() + "@" + domain;
				rc = ezEmailUserAdminService.updateGroupDel(groupAddr, cn[i] + "@" + domain);
				
				if (rc == 0) { // updateGroupDel 성공
					ezOrganAdminService.deleteDBData(cn[i], "user");
				}
				
			}
			// dhlee - end
		}		
	}
	
	/**
	 * 조직도관리 사원정보 추가/수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveUserInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String saveUserInfo(OrganUserVO vo, HttpServletRequest request, HttpServletResponse response) throws Exception{
		String result = "";
		
		if (vo.getParentCn().equals("")) {		
			ezOrganAdminService.updateDBData_user(vo);
			result = "OK";
		} else {
			String domain = config.getProperty("config.DomainName");
			String cn = vo.getCn();
						
			int cnt = ezOrganAdminService.userCheck(cn);
			
			if (cnt > 0) {
				result = "PRE";
			} else {
				String mailAddr = cn + "@" + domain;

				// dhlee
				int rc = ezEmailUserAdminService.addUser(mailAddr, vo.getPassword());
				
				if (rc == 0) { // addUser 성공
					
					String groupAddr = vo.getParentCn() + "@" + domain;
					
					rc = ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
					
					if (rc == 0) { // updateGroup 성공
						vo.setMail(mailAddr);				
						String userPrincipalName = cn + "@" + domain;
						vo.setUpnName(userPrincipalName);
						String pass = EgovFileScrty.encryptPassword(vo.getPassword(), cn);
						vo.setPassword(pass);
						
						//insertDBData_user 실패했을 경우 JMocha에서 계정 다시 삭제.
						try {
							ezOrganAdminService.insertDBData_user(vo);
							result = "OK";
						} catch (Exception e) {
							ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
							ezEmailUserAdminService.removeUser(mailAddr);
							throw e;
						}
					} else {
						ezEmailUserAdminService.removeUser(mailAddr);
						result = "EMAIL_ERROR";
					}
				} else {
					result = "EMAIL_ERROR";
				}
				// dhlee - end								
			}
		}
		return result;
	}
	
	/**
	 * 조직도관리 사원정보 사진등록/변경 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/personPicture.do")
	public String personPicture(HttpServletRequest request, HttpServletResponse response) throws Exception{
		return "admin/ezOrgan/personPicture";
	}
	
	/**
	 * 조직도관리 사원정보 사진이미지 파일 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getPersonalInfo.do")
	public void getPersonalInfo(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String fileName = request.getParameter("fileName");
		String filePath = config.getProperty("upload_personal.PHOTO") + commonUtil.separator + fileName;
		
		if (fileName != null && !fileName.equals("")) {
			ezCommonService.responseAttach(filePath, fileName, false, request, response);
		}
	}
	
	/**
	* 조직도관리 사원정보 사진이미지 임시 업로드 실행 함수
	*/
	@RequestMapping(value = "/admin/ezOrgan/signImageUpload.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String signImangeUpload(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String mode = request.getParameter("mode");
		String userID = request.getParameter("userID");
		String guid = UUID.randomUUID().toString();
		MultipartFile multiFile = request.getFile("file1");
		String realPath = request.getServletContext().getRealPath("");
		String tempPath = realPath + config.getProperty("upload_personal.PHOTOTEMP") + commonUtil.separator;
		String thumbPath = realPath + config.getProperty("upload_personal.PHOTO") + commonUtil.separator;
		String serverPath = "";
						
		if (userID.equals("")) {
			userID = userInfo.getId();
		}
		
		try{
			String fileName = multiFile.getOriginalFilename();
			fileName = fileName.replace("+", "%2b");
			fileName = fileName.replace(";", "%3b");
			String extension = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.lastIndexOf(".") + 1 + 3);
			fileName = userID + "_" + guid + ".";

			if (mode.equals("PICTURE")) {
				serverPath = thumbPath;
			} else if (mode.equals("TEMP")) {
				serverPath = tempPath;
			} else if (mode.equals("GLOGO")) {
				serverPath = realPath + config.getProperty("upload_approvalG.SIGNIMGS") + commonUtil.separator + userID + commonUtil.separator;
			} else {
				serverPath = realPath + config.getProperty("upload_approval.SIGNIMGS") + commonUtil.separator + userID + commonUtil.separator;
			}
						
			File file = new File(serverPath);
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			if (!mode.equals("TEMP")) {
				File file1 = new File(tempPath);
				
				if (!file1.exists()) {
					file1.mkdirs();
				}
			}
			
			writeUploadedFile(multiFile, fileName + extension, tempPath);
			File imageFile = new File(tempPath + fileName + extension);			
			
			BufferedImage bi = ImageIO.read(imageFile);
            BufferedImage bufferedImage = new BufferedImage(119, 128, bi.getType());
            bufferedImage.createGraphics().drawImage(bi, 0, 0, 119, 128, null);
            ImageIO.write(bufferedImage, "png", new File(serverPath + fileName + "png"));
            //임시 저장 파일 삭제
            deleteFile(tempPath + fileName + extension);
            
            return fileName + "png";
			
		}catch(Exception e) {
			return "UPLOAD_ERROR";
		}		
	}
	
	/**
	 * 조직도관리 겸직관리 메뉴 호출 화면
	 */
	@RequestMapping(value = "/admin/ezOrgan/addJobList.do")
	public String addJobList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LoginVO user = commonUtil.userInfo(loginCookie);		
		//관리자 권한 체크
		if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		String strLang = config.getProperty("config.primary");
		String use_editor = config.getProperty("config.EDITOR");
		String use_ie11Browser = config.getProperty("config.IE11EDITOR");
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(strLang);
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (user.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(user.getCompanyID())) {
				resultList.add(j, vo);
			}
		}
		
		model.addAttribute("use_editor", use_editor);
		model.addAttribute("use_ie11Browser", use_ie11Browser);
		model.addAttribute("userCompany", user.getCompanyID());
		model.addAttribute("list", resultList);
		
		return "/admin/ezOrgan/addJobList";
	}
	
	/**
	 * 조직도관리 겸직관리 대상자 리스트 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getAddJobList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getAddJobList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		String companyID = request.getParameter("companyID");
		String strLang = config.getProperty("config.primary");
				
		List<OrganUserVO> list = ezOrganAdminService.getAddJobList(companyID, strLang);
		
		StringBuilder result = new StringBuilder("<LISTVIEWDATA>");
        result.append("<ROWS>");
        
        for (int i = 0; i < list.size(); i++) {
        	OrganUserVO vo = list.get(i);
        	
        	result.append("<ROW>");
            result.append("<CELL>");
            result.append("<VALUE>" + vo.getCn() + "</VALUE>");
            result.append("<DATA1>" + vo.getCn() + "</DATA1>");
            result.append("<DATA2>" + vo.getExtensionAttribute4() + "</DATA2>");
            result.append("<DATA3>" + vo.getDisplayName() + "</DATA3>");
            result.append("<DATA4>" + vo.getMail() + "</DATA4>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + vo.getDisplayName() + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + vo.getTitle() + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + vo.getDescription() + "</VALUE>");
            result.append("</CELL>");                    
            result.append("<CELL>");
            result.append("<VALUE>" + vo.getCompany() + "</VALUE>");
            result.append("</CELL>");
            result.append("</ROW>");
        }                
        result.append("</ROWS>");
        result.append("</LISTVIEWDATA>");
		
		return result.toString();
	}
	
	/**
	 * 조직도관리 겸직관리 대상자 상세정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getUserAddJobList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getUserAddJobList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		String cn = request.getParameter("cn");
		String strLang = config.getProperty("config.primary");
		
		List<OrganUserVO> list = ezOrganAdminService.getUserAddJobList(cn, strLang);
		
		StringBuilder result = new StringBuilder();
		result.append("<DATA>");
		
		for (int i = 0; i < list.size(); i++) {
			OrganUserVO vo = list.get(i);
			
			String rows = commonUtil.getQueryResult(vo);
			result.append(rows.toString());
		}
        result.append("</DATA>");
        
		return result.toString();
	}
	
	/**
	 * 조직도관리 겸직관리 겸직삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveSubTitle.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String saveSubTitle(@RequestBody String data, HttpServletRequest request, Model model) throws Exception{
		Document doc = commonUtil.convertStringToDocument(data);
		
		String userID = doc.getElementsByTagName("CN").item(0).getTextContent();
		String titleInfo = "";
				
		if (!doc.getElementsByTagName("TITLE").item(0).getTextContent().equals("")) {
			for (int i = 0; i < doc.getElementsByTagName("CN").getLength(); i++) {
				if (titleInfo.equals("")) {
					titleInfo = doc.getElementsByTagName("DEPTID").item(i).getTextContent() + ":" + doc.getElementsByTagName("TITLE").item(i).getTextContent();
				} else {
					titleInfo += ";" + doc.getElementsByTagName("DEPTID").item(i).getTextContent() + ":" + doc.getElementsByTagName("TITLE").item(i).getTextContent(); 
				}
			}
		}
		
		ezOrganAdminService.updateProperty(userID, "EXTENSIONATTRIBUTE4", titleInfo, "user");
		
		ezOrganAdminService.addJob(userID, titleInfo);
		
		return "OK";
	}
	
	/**
	 * 조직도관리 겸직관리 겸직등록 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/addJobConfig.do")	
	public String addJobConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LoginVO user = commonUtil.userInfo(loginCookie);
		//관리자 권한 체크
		if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		String topID = "";        
        String userID = (request.getParameter("userID") != null ? request.getParameter("userID") : "");
        String selCompany = (request.getParameter("companyID") != null ? request.getParameter("companyID") : "");
        String lang = config.getProperty("config.primary");		
		String primary = config.getProperty("config.lang_Primary" + lang);
		String secondary = config.getProperty("config.lang_Secondary" + lang);
		
		if (user.getRollInfo().indexOf("c=1") == -1) {
			topID = user.getCompanyID();
		} else {
			topID = "Top";
		}

		model.addAttribute("topID", topID);
		model.addAttribute("use_ocs", "");
		model.addAttribute("userID", userID);
		model.addAttribute("selCompany", selCompany);
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		model.addAttribute("userInfo", user);
		
		return "admin/ezOrgan/addJobConfig";
	}
	
	/**
	 * 조직도관리 겸직관리 겸직등록 대상부서 선택 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/addjobAdd.do")	
	public String addjobAdd(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LoginVO user = commonUtil.userInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		
		if (companyID == null || companyID.equals("")) {
			companyID = "Top";
		}
		
		model.addAttribute("companyID", companyID);
		model.addAttribute("userInfo", user);
		
		return "admin/ezOrgan/addJobAdd";
	}
	
	/**
	 * 조직도관리 권한관리 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/permissionsList.do")	
	public String permissionsList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LoginVO user = commonUtil.userInfo(loginCookie);
		//관리자 권한 체크
		if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		String strLang = config.getProperty("config.primary");
		String use_editor = config.getProperty("config.EDITOR");
		String use_ie11Browser = config.getProperty("config.IE11EDITOR");
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(strLang);
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (user.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(user.getCompanyID())) {
				resultList.add(j, vo);
			}
		}
		
		model.addAttribute("use_editor", use_editor);
		model.addAttribute("use_ie11Browser", use_ie11Browser);
		model.addAttribute("userCompany", user.getCompanyID());
		model.addAttribute("list", resultList);
		
		return "admin/ezOrgan/permissionsList";
	}	
	
	/**
	 * 조직도관리 권한관리 리스트 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getPermissionsList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getPermissionsList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		String companyID = request.getParameter("companyID");
		String type = request.getParameter("type");
		String strLang = config.getProperty("config.primary");
		int pageNum = Integer.parseInt(request.getParameter("pageNum"));
		int pageSize = Integer.parseInt(request.getParameter("pageSize"));		
		int startRow = (pageSize * (pageNum - 1)) + 1;
        int endRow = pageSize * pageNum;
        
        int cnt = ezOrganAdminService.getPermissionListCount(companyID, type, strLang);
        
        List<OrganUserVO> list = ezOrganAdminService.getPermissionList(companyID, type, strLang, startRow, endRow);
        
		StringBuilder result = new StringBuilder("<LISTVIEWDATA>");
		result.append("<ROWS>");
		result.append("<TOTALCNT>");
		result.append(cnt);
		result.append("</TOTALCNT>");
        
        for (int i = 0; i < list.size(); i++) {
        	OrganUserVO vo = list.get(i);
        	
        	result.append("<ROW>");
        	result.append("<CELL>");
        	result.append("<VALUE>" + commonUtil.cleanValue(vo.getCn()) + "</VALUE>");
            result.append("<DATA1>" + commonUtil.cleanValue(vo.getCn()) + "</DATA1>");
            result.append("<DATA2>" + commonUtil.cleanValue(vo.getExtensionAttribute1()) + "</DATA2>");
            result.append("<DATA3>" + commonUtil.cleanValue(vo.getDisplayName()) + "</DATA3>");
            result.append("<DATA4>" + commonUtil.cleanValue(vo.getMail()) + "</DATA4>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getDisplayName()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getTitle()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getDescription()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getMail()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getTelephoneNumber()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getCompany()) + "</VALUE>");
            result.append("</CELL>");
            result.append("</ROW>");
        }
        result.append("</ROWS>");
        result.append("</LISTVIEWDATA>");
        
		return result.toString();
	}
	
	/**
	 * 조직도관리 권한관리 권한등록 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/permissionsCheck.do")	
	public String permissionsCheck(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LoginVO user = commonUtil.userInfo(loginCookie);
		//관리자 권한 체크
		if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		String userID = (request.getParameter("userID") != null ? request.getParameter("userID") : "");
        String selCompany = (request.getParameter("companyID") != null ? request.getParameter("companyID") : "");
		String topID = "";
		
		if (user.getRollInfo().indexOf("c=1") == -1) {
			topID = user.getCompanyID();
		} else {
			topID = "Top";
		}
		
		model.addAttribute("userID", userID);
		model.addAttribute("companyID", selCompany);
		model.addAttribute("topID", topID);
		model.addAttribute("userInfo", user);
		
		return "admin/ezOrgan/permissionsCheck";
	}
	
	/**
	 * 조직도관리 퇴직자관리 메뉴 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/retireUserManage.do")	
	public String retireUserManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LoginVO user = commonUtil.userInfo(loginCookie);
		//관리자 권한 체크
		if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		String strLang = config.getProperty("config.primary");
		int pPageRow = 20;
   		int pPage = 1;
   		
   		if (request.getParameter("page") != null) {
   			pPage = Integer.parseInt(request.getParameter("page"));
   		}
   		
   		int totalCount = ezOrganAdminService.getRetireListCount(pPage, pPageRow);
   		int totalPage = 0;
   		
		if (totalCount > 0) {
			if (totalCount > pPageRow) {
				String cnt = Double.toString((double)totalCount/(double)pPageRow);
				
				if (cnt.indexOf(".") >= 0) {
					totalPage = Integer.parseInt(cnt.split(".")[0]) + 1;
				} else {
					totalPage = Integer.parseInt(cnt);
				}
			} else {
				totalPage = 1;
			}
		} else {
			totalPage = 1;
		}
		
		List<OrganUserVO> list = ezOrganAdminService.getRetireList(pPage, pPageRow);
		
		model.addAttribute("lang", strLang);
   		model.addAttribute("list", list);
   		model.addAttribute("pPage", pPage);
   		model.addAttribute("totalPage", totalPage);
		
		return "admin/ezOrgan/retireUserManage";
	}	
	
	/**
	 * 조직도관리 퇴직자관리 복구 기능 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/restoreRetireUser.do")
	public void restoreRetireUser(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String deptID = request.getParameter("deptID");
		String[] cn = request.getParameter("cn").split(",");
		
		// dhlee
		String domain = config.getProperty("config.DomainName");
		// dhlee - end
		
		for (int i = 0; i < cn.length; i++) {
			// dhlee
			String mailAddr = cn[i] + "@" + domain;
			int rc = ezEmailUserAdminService.restoreUser(mailAddr);
			
			if (rc == 0) { // restoreUser 성공
								
				String groupAddr = deptID + "@" + domain;
				rc = ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
				
				if (rc == 0) { // updateGroupAdd 성공
					ezOrganAdminService.restoreRetireEntry(cn[i], deptID);
				}				
				
			}
			// dhlee - end			
		}		
	}
	
	/**
	 * 조직도관리 퇴직자관리 퇴직사원 상세정보 창 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/retireUserInfo.do")
	public String retireUserInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LoginVO user = commonUtil.userInfo(loginCookie);
		//관리자 권한 체크
		if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		String id = (request.getParameter("id") == null ? "" : request.getParameter("id"));
		String lang = config.getProperty("config.primary");		
		String primary = config.getProperty("config.lang_Primary" + lang);
		String secondary = config.getProperty("config.lang_Secondary" + lang);
				
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);		
		model.addAttribute("userID", id);
		
		return "admin/ezOrgan/retireUserInfo";
	}	
	
	/**
	 * 조직도관리 퇴직자관리 퇴직사원 상세정보 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getRetireEntryInfo.do")
	public String getRetireEntryInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		String cn = request.getParameter("cn");
		String lang = config.getProperty("config.primary");	
		
		OrganUserVO vo = ezOrganAdminService.getRetireEntryInfo(cn, lang);
		
		model.addAttribute("info", vo);
		
		return "json";
	}	
	
}
