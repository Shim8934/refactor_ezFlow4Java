package egovframework.ezEKP.ezOrgan.web;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import egovframework.let.utl.fcc.service.ClientUtil;
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
	
    private static final Logger logger = LoggerFactory.getLogger(EzOrganAdminController.class);
            
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
	public String companyInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String primary = config.getProperty("config.lang_Primary" + userInfo.getLang());
		String secondary = config.getProperty("config.lang_Secondary" + userInfo.getLang());
		
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		
		return "admin/ezOrgan/companyInfo";
	}
	
	/**
	 * 조직도관리 회사추가 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveCompanyInfo.do", produces = "text/html;charset=utf-8")	
	@ResponseBody
	public String saveCompanyInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("saveCompanyInfo started.");
	    
		String parentCn = request.getParameter("parentCn");
		String cn = request.getParameter("cn");
		String displayName = request.getParameter("displayName");
		String displayName2 = request.getParameter("displayName2");
		
		logger.debug("parentCn=" + parentCn + ",cn=" + cn + ",displayName=" + displayName + ",displayName2=" + displayName2);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);       
		
		String domain = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		
		logger.debug("domain=" + domain);
		
		String result = "";
		String ldapPath = "";
		
        // 사용자, 부서, 퇴직자, 회사 상관없이 기존에 사용되는 아이디를 체크한다.
        int cnt = ezOrganAdminService.userCheck(cn, tenantID);
        
        logger.debug("userCheck cnt=" + cnt);
        
		if (cnt > 0) {
			result = "PRE";
		} else {
			String mailAddr = cn + "@" + domain;
			
			logger.debug("mailAddr=" + mailAddr);
			
			// skyblue0o0
			int rc = ezEmailUserAdminService.addGroup(mailAddr);
			
			logger.debug("addGroup rc=" + rc);
			
			if (rc == 0) { // addGroup 성공
				
				String groupAddr = parentCn + "@" + domain;
				
				logger.debug("groupAddr=" + groupAddr);
				
				rc = ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
				
				logger.debug("updateGroupAdd rc=" + rc);
				
				if (rc == 0) { // updateGroupAdd 성공
					
					//insertDBData_company 실패했을 경우 JMocha에서 회사 다시 삭제.
					try {
						ezOrganAdminService.insertDBData_company(cn, displayName, displayName2, mailAddr, parentCn, ldapPath, tenantID);
						result = "OK";	
					} catch (Exception e) {
						ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
						ezEmailUserAdminService.removeGroup(mailAddr);
						result = "EMAIL_ERROR";
					}
								
				} else {
				    ezEmailUserAdminService.removeGroup(mailAddr);
					result = "EMAIL_ERROR";
				}
			} else {
				result = "EMAIL_ERROR";
			}
			// skyblue0o0 - end
			
		}
		
		logger.debug("saveCompanyInfo ended.");
		
		return result;
	}
	
	/**
	 * 조직도관리 회사 & 부서 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/delDept.do", produces = "text/html;charset=utf-8")	
	@ResponseBody
	public String delDept(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("delDept started.");
	    
	    LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);	    
	    
		String cn = request.getParameter("cn");
		String pClass = "group";
		String result = "";
		
		logger.debug("cn=" + cn);
		
		int cnt = ezOrganAdminService.companyChildCheck(cn, tenantID);
		int usercnt = ezOrganAdminService.userCountCheck(cn, tenantID);
		
		logger.debug("cnt=" + cnt + ",usercnt=" + usercnt);
		
		if (cnt > 0) {
			result = "HASCHILD";
		} else if(usercnt>0){
			result = "HASCHILD";
		}else {
			
			// skyblue0o0
			String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
			String mailAddr = cn + "@" + domain;
			
			logger.debug("mailAddr=" + mailAddr);
			
			int rc = ezEmailUserAdminService.removeGroup(mailAddr);
			
			logger.debug("removeGroup rc=" + rc);
			
			if (rc == 0) { // removeGroup 성공
				
				OrganDeptVO dept = ezOrganService.getDeptInfo(cn, "1", userInfo.getTenantId());
				String groupAddr = dept.getExtensionAttribute1() + "@" + domain;
				
				logger.debug("groupAddr=" + groupAddr);
				
				rc = ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
				
				logger.debug("updateGroupDel rc=" + rc);
				
				if (rc != -100) { // updateGroupDel 성공(부모그룹이나 자식그룹을 찾지 못해도 성공으로 봄.)
				    try {
    					ezOrganAdminService.deleteDBData(cn, pClass, tenantID);
    					result = "OK";
    				// 예외가 발생하면 그룹 주소를 다시 등록한다.
				    } catch (Exception e) {
				        ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
				        ezEmailUserAdminService.addGroup(mailAddr);
				        
				        result = "EMAIL_ERROR";
				    }
				} else {
					result = "EMAIL_ERROR";
				}
			} else {
				result = "EMAIL_ERROR";
			}
			// skyblue0o0 - end
			
		}
		
		logger.debug("delDept ended.");
		
		return result;
	}
	
	/**
	 * 조직도관리 부서정보 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/deptInfo.do")	
	public String deptInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String primary = config.getProperty("config.lang_Primary" + userInfo.getLang());
		String secondary = config.getProperty("config.lang_Secondary" + userInfo.getLang());
		
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		
		return "admin/ezOrgan/deptInfo";
	}

	/**
	 * 조직도관리 부서정보 및 내용 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getEntryInfo.do", produces = "text/xml;charset=utf-8")	
	@ResponseBody
	public String getEntryInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    LoginVO userInfo = commonUtil.userInfo(loginCookie);
	    
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);       
	    
		String cn = request.getParameter("cn");
		String proplist = request.getParameter("prop");				
	
		logger.debug("cn=" + cn);
		
		String infoXML = ezOrganAdminService.getPropertyList(cn, proplist, "1", userInfo.getTenantId());		

		return infoXML;
	}
	
	/**
	 * 조직도관리 부서정보 수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveDeptInfo.do", produces = "text/html;charset=utf-8")	
	@ResponseBody
	public String saveDeptInfo(@CookieValue("loginCookie") String loginCookie, OrganDeptVO vo, HttpServletRequest request, HttpServletResponse response) throws Exception{
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        
        int tenantID = userInfo.getTenantId();                              
	    
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		
		logger.debug("tenantID=" + tenantID + ",domain=" + domain); 
		
		String result = "";

        vo.setTenantId(tenantID);
        
		if (vo.getParentCn() == null) {
			ezOrganAdminService.updateDBData_dept(vo);
		} else {
			String cn = vo.getCn();
			
			// 사용자, 부서, 퇴직자, 회사 상관없이 기존에 사용되는 아이디를 체크한다.
			int cnt = ezOrganAdminService.userCheck(cn, tenantID);
			
			logger.debug("cn=" + cn + ",cnt=" + cnt);
			
			if (cnt > 0) {
				result = "PRE";
			} else {

				String mailAddr = cn + "@" + domain;
				
				logger.debug("mailAddr=" + mailAddr);
				
				// skyblue0o0
				int rc = ezEmailUserAdminService.addGroup(mailAddr);
				
				if (rc == 0) { // addGroup 성공
					String groupAddr = vo.getParentCn() + "@" + domain;
					
					logger.debug("groupAddr=" + groupAddr);
					
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
							result = "EMAIL_ERROR";
						}
									
					}
					else {
						ezEmailUserAdminService.removeGroup(mailAddr);
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
	public String movDept(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{
	    logger.debug("movDept started.");
	    
	    LoginVO userInfo = commonUtil.userInfo(loginCookie);
	    
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);       
	    
		String parentCn = request.getParameter("parentCn");
		String cn = request.getParameter("cn");
		
        logger.debug("parentCn=" + parentCn + ",cn=" + cn);
        
        String result = ezOrganAdminService.moveEntry(parentCn, cn, "group", tenantID);

        logger.debug("moveEntry result=" + result);
        
		logger.debug("movDept ended.");
		
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
	public String saveOrderList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
        logger.debug("saveOrderList started.");
        
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
		String pClass = request.getParameter("pClass");
		String cn = request.getParameter("cn");
		String[] cnDatas = cn.split(",");
		String result = "";
		
		logger.debug("pClass=" + pClass + ",cn=" + cn);
		
		for (int i=0; i<cnDatas.length; i++) {
			ezOrganAdminService.updateProperty(cnDatas[i], "EXTENSIONATTRIBUTE15", i+"", pClass, tenantID);	
		}
		
		logger.debug("saveOrderList ended.");
		
		return result;
	}
	
	/**
	 * 조직도관리 사원정보 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/userInfo.do")	
	public String userInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{
		boolean auth = commonUtil.checkAdmin(loginCookie);
		userInfo = commonUtil.userInfo(loginCookie);
		
		if (!auth) {
			return "cmm/error/adminDenied";
		}
		
		String lang = userInfo.getPrimary();		
		String primary = config.getProperty("config.lang_Primary" + userInfo.getLang());
		String secondary = config.getProperty("config.lang_Secondary" + userInfo.getLang());
		String checkID = config.getProperty("config.USE_CHECKUPSTR");
		String useAddressOpenAPI = config.getProperty("config.USE_AddressOpenAPI");
		
		
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		model.addAttribute("checkID", checkID);
		model.addAttribute("lang", lang);
		model.addAttribute("useAddressOpenAPI", useAddressOpenAPI);
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
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
        
		if (userInfo_approvalG.equals("YES")) {
			sign = "APPROVALGSIGN";
		}
		
		model.addAttribute("userID", userID);
		model.addAttribute("userInfo_approvalG", userInfo_approvalG);
		model.addAttribute("signImageSize", signImageSize);
		model.addAttribute("signPath", sign);
		model.addAttribute("isCrossBrowser", isCrossBrowser);
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
	public void changePassword(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		String pw = request.getParameter("password");
		String cn[] = request.getParameter("cn").split(",");
		
		// dhlee
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domain = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		// dhlee - end
		
		for (int i=0; i < cn.length; i++) {		
			// dhlee
			String mailAddr = cn[i] + "@" + domain;
			// 기존 이메일 계정의 Encrypt된 암호를 가져온다.
			String existingEncryptedPassword = ezEmailUserAdminService.getEncryptedUserPassword(mailAddr);
			
			if (existingEncryptedPassword != null) {
				// 이메일 계정의 암호를 새 암호로 설정한다.
				int rc = ezEmailUserAdminService.updateUserPassword(mailAddr, pw);
				
				if (rc == 0) { // updateUserPassword 성공													
					try {
						// 로컬 시스템에서 해당 User의 암호를 변경한다.
						ezOrganAdminService.setPassword(cn[i], pw);
					} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
						ezEmailUserAdminService.updateUserPasswordWithEncryptedPassword(mailAddr, existingEncryptedPassword);
						
						throw e;
					}										
				} else {
					throw new Exception("setting the user '" + mailAddr + "' password failed.");
				}
			} else {
				throw new Exception("getting the user '" + mailAddr + "' encrypted password failed.");
			}
			// dhlee - end
		}
	}
	
	/**
	 * 조직도관리 사원퇴직 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/retireUser.do")
	public void retireUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("retireUser started.");
	    
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
		String cn[] = request.getParameter("cn").split(",");
		
		// dhlee
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		// dhlee - end
		
		for (int i=0; i < cn.length; i++) {			
			// dhlee
			String mailAddr = cn[i] + "@" + domain;
			
			logger.debug("mailAddr=" + mailAddr);
			
			int rc = ezEmailUserAdminService.retireUser(mailAddr);
			
			logger.debug("retireUser rc=" + rc);
			
			if (rc == 0) { // retireUser 성공				
				// 해당 User가 속한 Group Email 주소에서 해당 User를 제거한다.
				OrganUserVO userVO = ezOrganAdminService.getUserInfo(cn[i], userInfo.getPrimary(), tenantID);
				String groupAddr = userVO.getDepartment() + "@" + domain;
				rc = ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
				
				logger.debug("updateGroupDel rc=" + rc);
				
				if (rc != -100) { // updateGroupDel 성공(부모(그룹)나 자식(유저)을 찾지못해도 성공으로 봄.)
					try {
						// 로컬 시스템에서 해당 User의 계정을 퇴직처리한다.
						ezOrganAdminService.retireEntry(cn[i], tenantID);
					} catch (Exception e) { // Exception이 발생하면 복구 처리를 한다.
						ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
						ezEmailUserAdminService.restoreUser(mailAddr);
						
						throw e;
					}					
				} else { // updateGroupDel 실패
					// Group Email 주소에서 제거하는 것이 실패하면 해당 User를 복원시키고, Exception을 발생시킨다.
					ezEmailUserAdminService.restoreUser(mailAddr);
					
					throw new Exception("removing the user '" + mailAddr + "' from its group email failed.");
				}				
			}
			// dhlee - end
		}
		
		logger.debug("retireUser ended.");
	}
	
	/**
	 * 조직도관리 사원이동 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/movUser.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String movUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("movUser started.");
	    
	    LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
		String parentCn = request.getParameter("parentCn");
		String cn[] = request.getParameter("cn").split(",");
		String result = "OK";
		
		logger.debug("parentCn=" + parentCn);
		
		for (int i=0; i < cn.length; i++) {
		    logger.debug("cn[" + i + "]=" + cn[i]);
		    
			result = ezOrganAdminService.moveEntry(parentCn, cn[i], "user", tenantID);
		
			logger.debug("moveEntry result=" + result);
			
			if (!result.equals("OK")) {
				break;
			}
		}
		
		logger.debug("movUser ended.");
		
		return result;
	}
	
	/**
	 * 조직도관리 사원삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/delUser.do")
	public void delUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("delUser started.");
	    
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
		String cn[] = request.getParameter("cn").split(",");
		
		// dhlee
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		// dhlee - end
				
		for (int i=0; i < cn.length; i++) {
			// dhlee
			String mailAddr = cn[i] + "@" + domain;
			
			logger.debug("mailAddr=" + mailAddr);
			
			// 이메일 계정이 있는 지 확인한다.
			int userExists = ezEmailUserAdminService.checkUserExists(mailAddr);
			int rc = 0;
			
			logger.debug("userExists=" + userExists);
			
			if (userExists == 0) { // 이메일 계정이 존재하지 않음.
				// 로컬 시스템 계정을 삭제한다.
				ezOrganAdminService.deleteDBData(cn[i], "user", tenantID);
			} else if (userExists == 1 || userExists == 2) { // 1은 유효한 이메일 계정. 2는 퇴직자 계정.
				String groupAddr = null;
				
				if (userExists == 1) { // 유효한 이메일 계정이 존재함.	
					// 먼저 퇴직자 처리를 수행한다. 로컬 계정 삭제가 실패할 경우 복구를 위해.
					rc = ezEmailUserAdminService.retireUser(mailAddr);

					logger.debug("retireUser rc=" + rc);
					
					if (rc == 0) {
						// 사용자가 속한 부서의 Group Email 주소를 구한다.
						OrganUserVO userVO = ezOrganAdminService.getUserInfo(cn[i], userInfo.getPrimary(), userInfo.getTenantId());
						groupAddr = userVO.getDepartment() + "@" + domain;				
						
						// 부서의 Group Email 주소로부터 해당 User를 제거한다.
						rc = ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
						
						logger.debug("updateGroupDel rc=" + rc);
						
						if (rc == -100) { // Group Email 주소에서 제거 실패함.(부모(그룹)나 자식(유저)를 찾지 못해도 성공으로 봄.)
							ezEmailUserAdminService.restoreUser(mailAddr);
							
							throw new Exception("removing the user '" + mailAddr + "' from its group email failed.");
						}
					} else {
						throw new Exception("retiring the user '" + mailAddr + "' failed.");
					}
				} 
												
				try {
					// 로컬 시스템 계정을 삭제한다.
					ezOrganAdminService.deleteDBData(cn[i], "user", tenantID);
				} catch (Exception e) {
					if (userExists == 1) { // 유효한 이메일 계정이었으면 복구 처리를 수행한다.
						ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
						ezEmailUserAdminService.restoreUser(mailAddr);							
					}
					
					throw e;
				}
				
				// 아래 과정에서 에러가 발생하면 복구할 수는 없지만, 이미 유효한 계정이 아니므로
				// 저장 공간은 차지하지만 해당 계정이 사용되지는 않는다. 
				
				// 퇴직자 계정을 삭제한다.
				ezEmailUserAdminService.removeUser(mailAddr);
				
				// 해당 사용자의 메일박스들을 모두 제거한다.
				ezEmailUserAdminService.removeUserAllMailboxes(mailAddr);
			}
			// dhlee - end
		}		
		
		logger.debug("delUser ended.");
	}
	
	/**
	 * 조직도관리 사원정보 추가/수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveUserInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String saveUserInfo(@CookieValue("loginCookie") String loginCookie, OrganUserVO vo, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("saveUserInfo started.");
	    
	    LoginVO userInfo = commonUtil.userInfo(loginCookie);
	    int tenantID = userInfo.getTenantId();
	    
	    vo.setTenantId(tenantID);
	    
	    logger.debug("tenantID=" + tenantID);
	    
		String result = "";		
		
		logger.debug("parentCn=" + vo.getParentCn());
		
		// 기존 사용자를 수정하는 경우엔 parentCn의 값이 empty string 이다.
		if (vo.getParentCn().equals("")) {		
			ezOrganAdminService.updateDBData_user(vo);
			result = "OK";
		// 새로운 사용자를 등록한다.
		} else {		    
			String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
			String cn = vo.getCn();
						
			logger.debug("domain=" + domain + ",cn=" + cn);
			
			// 사용자, 부서, 퇴직자, 회사 상관없이 기존에 사용되는 아이디를 체크한다.
			int cnt = ezOrganAdminService.userCheck(cn, tenantID);
			
			logger.debug("cnt=" + cnt);
			
			if (cnt > 0) {
				result = "PRE";
			} else {
				String mailAddr = cn + "@" + domain;

				// dhlee
				// 이메일 시스템에 계정을 생성한다.
				int rc = ezEmailUserAdminService.addUser(mailAddr, vo.getPassword());
				
				logger.debug("addUser rc=" + rc);
				
				if (rc == 0) { // addUser 성공
					// 해당 User가 속한 부서의 Group Email 주소에 User를 등록한다.					
					String groupAddr = vo.getParentCn() + "@" + domain;					
					rc = ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
					
					logger.debug("updateGroupAdd rc=" + rc);
					
					if (rc == 0) { // updateGroup 성공
						vo.setMail(mailAddr);				
						String userPrincipalName = cn + "@" + domain;
						vo.setUpnName(userPrincipalName);
						String pass = EgovFileScrty.encryptPassword(vo.getPassword(), cn);
						vo.setPassword(pass);
						
						//insertDBData_user 실패했을 경우 JMocha에서 계정 다시 삭제.
						try {
							// 로컬 시스템에 해당 User의 계정을 생성한다.
							ezOrganAdminService.insertDBData_user(vo);
							result = "OK";
						} catch (Exception e) { // Exception이 발생하면 취소 처리를 하고 Exception을 발생시킨다.
							ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
							ezEmailUserAdminService.removeUser(mailAddr);
							
							result = "EMAIL_ERROR";
						}
					} else {
						// 부서의 Group Email 주소로의 등록에 실패하면 해당 User를 삭제하고 에러를 반환한다.
						ezEmailUserAdminService.removeUser(mailAddr);
						
						result = "EMAIL_ERROR";
					}
				} else {
					result = "EMAIL_ERROR";
				}
				// dhlee - end								
			}
		}
		
		logger.debug("saveUserInfo ended. result=" + result);
		
		return result;
	}
	
	/**
	 * 조직도관리 사원정보 사진등록/변경 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/personPicture.do")
	public String personPicture(HttpServletRequest request, HttpServletResponse response,Model model) throws Exception{
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		model.addAttribute("isCrossBrowser", isCrossBrowser);
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
	* 조직도관리 사원정보 사진이미지 임시 업로드 실행 함수(Ie9)
	*/
	@RequestMapping(value = "/admin/ezOrgan/signImageUploadIe9.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String signImangeUploadIe9(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String returnVal = "";
		String mode = request.getParameter("mode");
		String userID = request.getParameter("userID");
		String guid = UUID.randomUUID().toString();
		String fileTitle ="" ;
		String sFileData = "";
		String sExt = "";
		String sFolder = "";
		String sPrefix = "";
		String serverPath = "";
		String realPath = request.getServletContext().getRealPath("");
		String tempPath = realPath + config.getProperty("upload_personal.PHOTOTEMP") + commonUtil.separator;
		String thumbPath = realPath + config.getProperty("upload_personal.PHOTO") + commonUtil.separator;
		
				if (request.getParameter("guid") != null) {
					guid = request.getParameter("guid");
				}
				if (request.getParameter("name") != null) {
					fileTitle = request.getParameter("name");
				}
				if (request.getParameter("filedata") != null) {
					sFileData = request.getParameter("filedata");
				}
				if (request.getParameter("ext") != null) {
					sExt = request.getParameter("ext");
				}
				if (request.getParameter("dir") != null) {
					sFolder = request.getParameter("dir");
				}
				if (request.getParameter("prefix") != null) {
					userID = request.getParameter("prefix");
				}
			String fileName = sExt;
			fileName = userID + "_" + guid + "." + fileName;
		 
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
				fileName = fileName.replace("+", "%2b");
		        fileName = fileName.replace(";", "%3b");
		        fileName = fileName.replace("~", "%7e");
		        fileName = fileName.replace("=", "%3d");
		        
				InputStream stream = null;
				OutputStream bos = null;         
				
				try {
					stream = request.getInputStream();
					bos = new FileOutputStream(serverPath+fileName);
//					long fileSize = 0;
					int bytesRead = 0;
					byte[] buffer = new byte[BUFF_SIZE];
					
					while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
						bos.write(buffer, 0, bytesRead);
//						fileSize += bytesRead;
					}
				} catch (Exception e) {
					throw e;                
				} finally {
					if (bos != null) {
						try {
							bos.close();
						} catch (Exception ignore) {
						}
					}
					if (stream != null) {
						try {
							stream.close();
						} catch (Exception ignore) {
						}
					}
					returnVal = "OK_"+ fileName;
				}
		        
		return returnVal;
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
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(strLang, user.getTenantId());
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
	public String saveSubTitle(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, Model model) throws Exception{
        logger.debug("saveSubTitle started.");
        
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
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
		
		ezOrganAdminService.updateProperty(userID, "EXTENSIONATTRIBUTE4", titleInfo, "user", tenantID);
		
		ezOrganAdminService.addJob(userID, titleInfo);
		
		logger.debug("saveSubTitle ended.");
		
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
		String primary = config.getProperty("config.lang_Primary" + user.getLang());
		String secondary = config.getProperty("config.lang_Secondary" + user.getLang());
		
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
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(strLang, user.getTenantId());
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
		
        int tenantID = user.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
		
		String strLang = ezCommonService.getTenantConfig("PrimaryLang", tenantID);
		int pPageRow = 20;
   		int pPage = 1;
   		
   		if (request.getParameter("page") != null) {
   			pPage = Integer.parseInt(request.getParameter("page"));
   		}
   		
   		logger.debug("strLang=" + strLang + ",pPage=" + pPage + ",pPageRow=" + pPageRow);
   		
   		int totalCount = ezOrganAdminService.getRetireListCount(pPage, pPageRow, tenantID);
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
		
		logger.debug("totalCount=" + totalCount + ",totalPage=" + totalPage);
		
		List<OrganUserVO> list = ezOrganAdminService.getRetireList(pPage, pPageRow, tenantID);
		
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
	public void restoreRetireUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    logger.debug("restoreRetireUser started.");
	    
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
		String deptID = request.getParameter("deptID");
		String[] cn = request.getParameter("cn").split(",");
		
		logger.debug("deptID=" + deptID);
		
		// dhlee
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		// dhlee - end
		
		for (int i = 0; i < cn.length; i++) {
			// dhlee
			String mailAddr = cn[i] + "@" + domain;
			
			logger.debug("mailAddr=" + mailAddr);
			
			int rc = ezEmailUserAdminService.restoreUser(mailAddr);
			
			logger.debug("restoreUser rc=" + rc);
			
			if (rc == 0) { // restoreUser 성공				
				// 지정된 부서의 Group Email 주소에 해당 User를 추가한다.
				String groupAddr = deptID + "@" + domain;
				rc = ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
				
				logger.debug("updateGroupAdd rc=" + rc);
				
				if (rc == 0) { // updateGroupAdd 성공
					try {
						// 로컬 시스템에서 해당 User의 복원처리를 수행한다.
						ezOrganAdminService.restoreRetireEntry(cn[i], deptID, tenantID);
					} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
						ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
						ezEmailUserAdminService.retireUser(mailAddr);
						
						throw e;
					}										
				} else {
					// Group Email 주소로의 추가가 실패하면 해당 User를 다시 퇴직처리하고 Exception을 발생시킨다.
					ezEmailUserAdminService.retireUser(mailAddr);
					
					throw new Exception("Adding the user '" + mailAddr + "' to the specified group email '" + groupAddr + "' failed.");
				}
			}
			// dhlee - end			
		}		
		
		logger.debug("restoreRetireUser ended.");
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
		
        int tenantID = user.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
		
		String id = (request.getParameter("id") == null ? "" : request.getParameter("id"));
		String primary = ezCommonService.getTenantConfig("LangPrimary" + user.getLang(), tenantID);
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + user.getLang(), tenantID);
				
		logger.debug("id=" + id + ",primary=" + primary + ",secondary=" + secondary);
		
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
        logger.debug("getRetireEntryInfo started.");
        
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
		String cn = request.getParameter("cn");	
		
		logger.debug("cn=" + cn);
		
		OrganUserVO vo = ezOrganAdminService.getRetireEntryInfo(cn, "1", tenantID);
		
		model.addAttribute("info", vo);
		
		logger.debug("getRetireEntryInfo ended.");
		
		return "json";
	}	
	
}
