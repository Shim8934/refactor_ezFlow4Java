package egovframework.ezEKP.ezOrgan.web;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.TimeZone;
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
import org.w3c.dom.NodeList;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
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
public class EzOrganAdminController extends EgovFileMngUtil {
	
    private static final Logger logger = LoggerFactory.getLogger(EzOrganAdminController.class);
            
	@Autowired	
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private Properties globals;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzEmailUserAdminService ezEmailUserAdminService;

    @Autowired
    private EzEmailUtil ezEmailUtil;	
	 
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
		
		String IsJMochaStandAlone = config.getProperty("config.IsJMochaStandAlone");
		String use_approvalG = config.getProperty("config.UserInfo_ApprovalG");
		
		model.addAttribute("topid", topid);
		model.addAttribute("useOCS", config.getProperty("config.USE_OCS"));
		model.addAttribute("IsJMochaStandAlone", IsJMochaStandAlone);
		model.addAttribute("use_approvalG", use_approvalG);
		
		return "admin/ezOrgan/organRight";
	}
	
	/**
	 * 조직도관리 회사추가 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/companyInfo.do")
	public String companyInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
	    logger.debug("companyInfo started.");
	    
		userInfo = commonUtil.userInfo(loginCookie);
		
		String primary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		
		logger.debug("companyInfo ended.");
		
		return "admin/ezOrgan/companyInfo";
	}
	
	/**
	 * 조직도관리 회사추가 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveCompanyInfo.do", produces = "text/html;charset=utf-8")	
	@ResponseBody
	public String saveCompanyInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
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
					
					// insertDBData_company 실패했을 경우 JMocha에서 회사 다시 삭제.
					try {
						ezOrganAdminService.insertDBData_company(cn, displayName, displayName2, mailAddr, parentCn, ldapPath, tenantID, userInfo);
						result = "OK";	
					} catch (Exception e) {
						e.printStackTrace();
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
	public String delDept(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    logger.debug("delDept started.");
	    
	    LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);	    
	    
		String cn = request.getParameter("cn");
		String pClass = "group";
		String result = "";
		
		logger.debug("cn=" + cn);
		
		// 제거하고자 하는 회사 혹은 부서 바로 아래에 위치한 자식 부서의 수를 구한다.
		int cnt = ezOrganAdminService.companyChildCheck(cn, tenantID);
		
		// 제거하고자 하는 회사 혹은 부서에 속한 사원의 수를 반환한다.
		int usercnt = ezOrganAdminService.userCountCheck(cn, tenantID);
		
		logger.debug("cnt=" + cnt + ",usercnt=" + usercnt);
		
		if (cnt > 0) {
			result = "HASCHILD";
		} else if(usercnt > 0) {
			result = "HASCHILD";
		} else {			
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
				
				// 상위 부서의 이메일 그룹 주소로부터 해당 부서를 삭제한다.
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
	public String deptInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
	    logger.debug("deptInfo started");
	    
        userInfo = commonUtil.userInfo(loginCookie);
        
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);       
        
        String primary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), tenantID);
        String secondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), tenantID);
        String IsJMochaStandAlone = config.getProperty("config.IsJMochaStandAlone");
            
        model.addAttribute("primary", primary);
        model.addAttribute("secondary", secondary);
        model.addAttribute("IsJMochaStandAlone", IsJMochaStandAlone);
        
        logger.debug("deptInfo ended");
        
        return "admin/ezOrgan/deptInfo";
	}

	/**
	 * 조직도관리 부서정보 및 내용 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getEntryInfo.do", produces = "text/xml;charset=utf-8")	
	@ResponseBody
	public String getEntryInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    logger.debug("getEntryInfo started");
	    
	    LoginVO userInfo = commonUtil.userInfo(loginCookie);
	    
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);       
	    
		String cn = request.getParameter("cn");
		String proplist = request.getParameter("prop");				
	
		logger.debug("cn=" + cn);
		
		String infoXML = ezOrganAdminService.getPropertyList(cn, proplist, "1", userInfo.getTenantId());		

		logger.debug("getEntryInfo ended");
		
		return infoXML;
	}
	
	/**
	 * 조직도관리 부서정보 수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveDeptInfo.do", produces = "text/html;charset=utf-8")	
	@ResponseBody
	public String saveDeptInfo(@CookieValue("loginCookie") String loginCookie, OrganDeptVO vo, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    logger.debug("saveDeptInfo started");
	    
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        
        int tenantID = userInfo.getTenantId();                              
	    
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		
		logger.debug("tenantID=" + tenantID + ",domain=" + domain + ",parentCn=" + vo.getParentCn()); 
		
		String result = "";

        vo.setTenantId(tenantID);
        
        SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        date.setTimeZone(TimeZone.getTimeZone("GMT"));
        String nowDate = date.format(new Date()); 
        vo.setNowDate(nowDate);
        
        // 부서정보를 수정하는 경우
		if (vo.getParentCn() == null) {
			ezOrganAdminService.updateDBData_dept(vo);
		// 새로운 부서를 생성하는 경우
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
						
						// insertDBData_dept 실패했을 경우 JMocha에서 부서 다시 삭제.
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
		
		logger.debug("saveDeptInfo ended");
		
		return result;
	}
	
	/**
	 * 조직도관리 부서이동 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/selectDept.do")	
	public String selectDept(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {	    
		String companyID = request.getParameter("companyID");
		
        logger.debug("selectDept started. companyID=" + companyID);

       
		if (companyID == null || companyID.equals("")) {
			companyID = "Top";
		}
		
		model.addAttribute("companyID", companyID);
		
        logger.debug("selectDept ended.");
        
		return "admin/ezOrgan/selectDept";
	}
	
	/**
	 * 조직도관리 부서이동 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/movDept.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String movDept(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
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
	public String saveOrderList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
        logger.debug("saveOrderList started.");
        
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
		String pClass = request.getParameter("pClass");
		String cn = request.getParameter("cn");
		String[] cnDatas = cn.split(",");
		String result = "";
		
		logger.debug("pClass=" + pClass + ",cn=" + cn);
		
		for (int i = 0; i < cnDatas.length; i++) {
			ezOrganAdminService.updateProperty(cnDatas[i], "EXTENSIONATTRIBUTE15", i+"", pClass, tenantID);	
		}
		
		logger.debug("saveOrderList ended.");
		
		return result;
	}
	
	/**
	 * 조직도관리 사원정보 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/userInfo.do")	
	public String userInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
	    logger.debug("userInfo started");
	    
		userInfo = commonUtil.checkAdmin(loginCookie);
		
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		String lang = userInfo.getLang();		
		String primary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		
		String checkID = config.getProperty("config.USE_CHECKUPSTR");
		String useAddressOpenAPI = config.getProperty("config.USE_AddressOpenAPI");
		
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		model.addAttribute("checkID", checkID);
		model.addAttribute("lang", lang);
		model.addAttribute("useAddressOpenAPI", useAddressOpenAPI);
		model.addAttribute("birthDay", "");
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("primaryLang", primaryLang);
		
		logger.debug("userInfo ended");
		
		return "admin/ezOrgan/userInfo";
	}
	
	/**
	 * 조직도관리 서명등록 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/configSignImage.do")	
	public String configSignImage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
	    logger.debug("configSignImage started");
	    
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = request.getParameter("id");
		String userInfo_approvalG = config.getProperty("config.UserInfo_ApprovalG");
		String signImageSize = ezCommonService.getTenantConfig("SignImageSizeLimit", userInfo.getTenantId());
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
		
		logger.debug("configSignImage ended");
		
		return "admin/ezOrgan/configSignImage";
	}
	
	/**
	 * 조직도관리 전자결재 서명 이미지 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getApprovalSignInfo.do")
	public void getSignImage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String type = request.getParameter("type");
		String fileName = request.getParameter("fileName");
		
		if (type.equals("APPROVALSIGN")) {
			//2016-04-15 장진혁과장 -- Approval Attach 구현 필요
		} else {			
			String filePath = commonUtil.getUploadPath("upload_approvalG.SIGNIMGS", userInfo.getTenantId()) + commonUtil.separator + fileName.split("_")[0] + commonUtil.separator + fileName;
			
			if (fileName != null && !fileName.equals("")) {
				ezCommonService.responseAttach(filePath, "", true, request, response);
			}
		}	
	}
	
	/**
	 * 조직도관리 암호관리 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/inputPassword.do")
	public String inputPassword(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "admin/ezOrgan/inputPassword";
	}
	
	/**
	 * 조직도관리 새로운 비밀번호 설정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/changePassword.do")
	public void changePassword(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("changePassword started.");
	    
		String pw = request.getParameter("password");
		String cn[] = request.getParameter("cn").split(",");
		
		logger.debug("cn=" + request.getParameter("cn")); 
		
		// dhlee
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);		
		
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		
		logger.debug("domain=" + domain);
		// dhlee - end
		
		for (int i=0; i < cn.length; i++) {		
			// dhlee
			String mailAddr = cn[i] + "@" + domain;
			
			logger.debug("mailAddr=" + mailAddr);
			
			// 기존 이메일 계정의 Encrypt된 암호를 가져온다.
			String existingEncryptedPassword = ezEmailUserAdminService.getEncryptedUserPassword(mailAddr);
			
			if (existingEncryptedPassword != null) {
				// 이메일 계정의 암호를 새 암호로 설정한다.
				int rc = ezEmailUserAdminService.updateUserPassword(mailAddr, pw);
				
				logger.debug("updateUserPassword rc=" + rc);
				
				if (rc == 0) { // updateUserPassword 성공													
					try {
						// 로컬 시스템에서 해당 User의 암호를 변경한다.
						ezOrganAdminService.setPassword(cn[i], pw, tenantID);
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
		
		logger.debug("changePassword ended.");
	}
	
	/**
	 * 조직도관리 사원퇴직 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/retireUser.do")
	public void retireUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("retireUser started.");
	    
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        String cnList = request.getParameter("cn");
        
        logger.debug("tenantID=" + tenantID + ",cnList=" + cnList);
        	    
		String cn[] = cnList.split(",");
		
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
        String cnList = request.getParameter("cn");
        
        logger.debug("tenantID=" + tenantID + ",cnList=" + cnList);
	    
		String cn[] = cnList.split(",");
		
		// dhlee
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		// dhlee - end
				
		for (int i = 0; i < cn.length; i++) {
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
	    
        //관리자 권한 체크
        if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
            return "cmm/error/adminDenied";
        }
	    
	    int tenantID = userInfo.getTenantId();
	    
	    vo.setTenantId(tenantID);
	    
	    SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        date.setTimeZone(TimeZone.getTimeZone("GMT"));
        String nowDate = date.format(new Date()); 
        vo.setNowDate(nowDate);
	    
	    logger.debug("tenantID=" + tenantID + ",parentCn=" + vo.getParentCn());
	    
		String result = "";		
		
		// 전체관리자가 아닌데 전체관리자 권한을 설정하려는 경우엔 CHECKPERMISSION을 반환한다.
        if (userInfo.getRollInfo().indexOf("c=1") == -1 
                && vo.getExtensionAttribute1() != null
                && vo.getExtensionAttribute1().toLowerCase().indexOf("c=1") > -1) {
            result = "CHECKPERMISSION";		
		// 기존 사용자를 수정하는 경우엔 parentCn의 값이 empty string 이다.
        } else if (vo.getParentCn().equals("")) {				    
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
						
						// insertDBData_user 실패했을 경우 JMocha에서 계정 다시 삭제.
						try {
							// 로컬 시스템에 해당 User의 계정을 생성한다.
							ezOrganAdminService.insertDBData_user(vo);
							result = "OK";
						} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
							ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
							ezEmailUserAdminService.removeUser(mailAddr);
							
							e.printStackTrace();
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
	public String personPicture(HttpServletRequest request, HttpServletResponse response,Model model) throws Exception {
	    logger.debug("personPicture started");
	    
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		
		logger.debug("personPicture ended");
		
		return "admin/ezOrgan/personPicture";
	}
	
	/**
	 * 조직도관리 사원정보 사진이미지 파일 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getPersonalInfo.do")
	public void getPersonalInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    logger.debug("getPersonalInfo started");
	    
	    LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String fileName = request.getParameter("fileName");
		String filePath = commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + commonUtil.separator + fileName;
		
		logger.debug("filePath=" + filePath);
		
		if (fileName != null && !fileName.equals("")) {
			ezCommonService.responseAttach(filePath, fileName, false, request, response);
		}
		
		logger.debug("getPersonalInfo ended");
	}
		
	/**
	* 조직도관리 사원정보 사진이미지 임시 업로드 실행 함수(Ie9)
	*/
	@RequestMapping(value = "/admin/ezOrgan/signImageUploadIe9.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String signImangeUploadIe9(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception {
	    logger.debug("signImangeUploadIe9 started");
	    
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
		String tempPath = realPath + commonUtil.getUploadPath("upload_personal.PHOTOTEMP", userInfo.getTenantId()) + commonUtil.separator;
		String thumbPath = realPath + commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + commonUtil.separator;
		
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
			serverPath = realPath + commonUtil.getUploadPath("upload_approvalG.SIGNIMGS", userInfo.getTenantId()) + commonUtil.separator + userID + commonUtil.separator;
		} else {
			serverPath = realPath + commonUtil.getUploadPath("upload_approvalG.SIGNIMGS", userInfo.getTenantId()) + commonUtil.separator + userID + commonUtil.separator;
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
			int bytesRead = 0;
			byte[] buffer = new byte[BUFF_SIZE];
			
			while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
				bos.write(buffer, 0, bytesRead);
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
		        
		logger.debug("signImangeUploadIe9 ended");
				
		return returnVal;
	}
	
	/**
	* 조직도관리 사원정보 사진이미지 임시 업로드 실행 함수
	*/
	@RequestMapping(value = "/admin/ezOrgan/signImageUpload.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String signImangeUpload(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception {
	    logger.debug("signImangeUpload started");
	    
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String mode = request.getParameter("mode");
		String userID = request.getParameter("userID");
		String guid = UUID.randomUUID().toString();
		MultipartFile multiFile = request.getFile("file1");
		String realPath = request.getServletContext().getRealPath("");				
		String tempPath = realPath + commonUtil.getUploadPath("upload_personal.PHOTOTEMP", userInfo.getTenantId()) + commonUtil.separator;
		String thumbPath = realPath + commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + commonUtil.separator;
		String serverPath = "";
						
		if (userID.equals("")) {
			userID = userInfo.getId();
		}
		
		try {
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
				serverPath = realPath + commonUtil.getUploadPath("upload_approvalG.SIGNIMGS", userInfo.getTenantId()) + commonUtil.separator + userID + commonUtil.separator;
			} else {
				serverPath = realPath + commonUtil.getUploadPath("upload_approvalG.SIGNIMGS", userInfo.getTenantId()) + commonUtil.separator + userID + commonUtil.separator;
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
            
            logger.debug("signImangeUpload ended");
            
            return fileName + "png";
			
		} catch (Exception e) {
		    logger.debug("signImangeUpload failed");
		    
			return "UPLOAD_ERROR";
		}		
	}
	
	/**
	 * 조직도관리 겸직관리 메뉴 호출 화면
	 */
	@RequestMapping(value = "/admin/ezOrgan/addJobList.do")
	public String addJobList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
	    logger.debug("addJobList started.");
	    
		LoginVO user = commonUtil.userInfo(loginCookie);		
		
        int tenantID = user.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
		
		//관리자 권한 체크
		if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		String use_editor = ezCommonService.getTenantConfig("EDITOR", tenantID);
		String use_ie11Browser = ezCommonService.getTenantConfig("IE11EDITOR", tenantID);
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(user.getPrimary(), user.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (user.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(user.getCompanyID())) {
				resultList.add(j++, vo);
			}
		}
		
		model.addAttribute("use_editor", use_editor);
		model.addAttribute("use_ie11Browser", use_ie11Browser);
		model.addAttribute("userCompany", user.getCompanyID());
		model.addAttribute("list", resultList);
		
		logger.debug("addJobList ended.");
		
		return "/admin/ezOrgan/addJobList";
	}
	
	/**
	 * 조직도관리 겸직관리 대상자 리스트 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getAddJobList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getAddJobList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
        logger.debug("getAddJobList started.");
        
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
		String companyID = request.getParameter("companyID");
		String strLang = userInfo.getPrimary();
				
		List<OrganUserVO> list = ezOrganAdminService.getAddJobList(companyID, strLang, tenantID);
		
		StringBuilder result = new StringBuilder("<LISTVIEWDATA>");
        result.append("<ROWS>");
        
        for (int i = 0; i < list.size(); i++) {
        	OrganUserVO vo = list.get(i);
        	
        	result.append("<ROW>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getCn()) + "</VALUE>");
            result.append("<DATA1>" + commonUtil.cleanValue(vo.getCn()) + "</DATA1>");
            result.append("<DATA2>" + commonUtil.cleanValue(vo.getExtensionAttribute4()) + "</DATA2>");
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
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getCompany()) + "</VALUE>");
            result.append("</CELL>");
            result.append("</ROW>");
        }                
        result.append("</ROWS>");
        result.append("</LISTVIEWDATA>");
		
        logger.debug("getAddJobList ended.");
        
		return result.toString();
	}
	
	/**
	 * 조직도관리 겸직관리 대상자 상세정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getUserAddJobList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getUserAddJobList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
        logger.debug("getUserAddJobList started.");
        
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
		String cn = request.getParameter("cn");
		String strLang = userInfo.getPrimary();
		
		List<OrganUserVO> list = ezOrganAdminService.getUserAddJobList(cn, strLang, tenantID);
		
		StringBuilder result = new StringBuilder();
		result.append("<DATA>");
		
		for (int i = 0; i < list.size(); i++) {
			OrganUserVO vo = list.get(i);
			
			String rows = commonUtil.getQueryResult(vo);
			result.append(rows.toString());
		}
        result.append("</DATA>");
        
        logger.debug("getUserAddJobList ended.");
        
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
	    logger.debug("data=" + data);
        
		Document doc = commonUtil.convertStringToDocument(data);
		
		String userID = doc.getElementsByTagName("CN").item(0).getTextContent();
		String titleInfo = "";
		String deleteTitleInfo = "";
				
		for (int i = 0; i < doc.getElementsByTagName("CN").getLength(); i++) {
			String titleValue = doc.getElementsByTagName("TITLE").item(i).getTextContent();
			
		    if (!titleValue.equals("")) {
		    	String[] titleArray = titleValue.split(":");
		    	
		    	// Primary 언어 이름만 있는 경우엔 Secondary 언어 이름을 동일하게 설정한다.
		    	if (titleArray.length == 1) {
		    		titleValue = titleArray[0] + ":" + titleArray[0];
		    	}
		    	
    			if (titleInfo.equals("")) {
    				titleInfo = doc.getElementsByTagName("DEPTID").item(i).getTextContent() + ":" + titleValue;
    			} else {
    				titleInfo += ";" + doc.getElementsByTagName("DEPTID").item(i).getTextContent() + ":" + titleValue; 
    			}
		    } else {
                if (deleteTitleInfo.equals("")) {
                    deleteTitleInfo = doc.getElementsByTagName("DEPTID").item(i).getTextContent() + ":" + titleValue;
                } else {
                    deleteTitleInfo += ";" + doc.getElementsByTagName("DEPTID").item(i).getTextContent() + ":" + titleValue; 
                }		        
		    }
		}
		
		logger.debug("userID=" + userID + ",titleInfo=" + titleInfo + ",deleteTitleInfo=" + deleteTitleInfo);
		
		ezOrganAdminService.updateProperty(userID, "EXTENSIONATTRIBUTE4", titleInfo, "user", tenantID);
		
		if (!deleteTitleInfo.equals("")) {
		    ezOrganAdminService.deleteJob(userID, deleteTitleInfo, tenantID);
		} else {
		    if (!titleInfo.equals("")) {
		        List<OrganUserVO> organUserVOList = ezOrganAdminService.getUserAddJobList(userID, "1", tenantID);
		        StringBuilder sbCurrentJobList = new StringBuilder();
		        
		        // 지정된 사용자의 현재 겸직 목록을 구한다.
		        for (int i = 0; i < organUserVOList.size(); i++) {
		            OrganUserVO organUserVO = organUserVOList.get(i);
		            
		            if (i == 0) {
		                sbCurrentJobList.append(organUserVO.getDepartment() + "::");
		            } else {
		                sbCurrentJobList.append(";" + organUserVO.getDepartment() + "::");
		            }
		        }
		        
		        String currentJobList = sbCurrentJobList.toString();
		        
		        logger.debug("currentJobList=" + currentJobList);
		        
		        if (!currentJobList.equals("")) {
		            // 현재 겸직 목록을 모두 삭제한다.
		            ezOrganAdminService.deleteJob(userID, currentJobList, tenantID);
		        }
		        
		        String sTitle1 = "";
		        String sTitle2 = "";
		        String pDeptID = "";
		        
	            String[] addJobinfo = titleInfo.split(";");
	            StringBuilder sb = new StringBuilder();
	            
	            for (int i = 0; i < addJobinfo.length; i++) {
	                String[] jobInfo = addJobinfo[i].split(":");
	                pDeptID = jobInfo[0];
	                sTitle1 = "";
	                
	                if (jobInfo.length > 1) {
	                    sTitle1 = jobInfo[1];
	                }
	                
	                sTitle2 = "";
	                
	                if (jobInfo.length > 2) {
	                    sTitle2 = jobInfo[2];
	                } else {
	                    sTitle2 = sTitle1;
	                }
	                
	                if (i == 0) {
	                    sb.append(pDeptID + ":" + sTitle1 + ":" + sTitle2);
	                } else {
	                    sb.append(";" + pDeptID + ":" + sTitle1 + ":" + sTitle2);
	                }
	            }		
	            
	            titleInfo = sb.toString();
	            
	            logger.debug("new titleInfo=" + titleInfo);
	            
	            // 새로운 겸직 목록을 설정한다.
	            ezOrganAdminService.addJob(userID, titleInfo, tenantID);	            
		    }		    
		}
		
		logger.debug("saveSubTitle ended.");
		
		return "OK";
	}
	
	/**
	 * 조직도관리 겸직관리 겸직등록 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/addJobConfig.do")	
	public String addJobConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
	    logger.debug("addJobConfig started.");
	    
		LoginVO user = commonUtil.userInfo(loginCookie);
		//관리자 권한 체크
		if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		String topID = "";        
        String userID = (request.getParameter("userID") != null ? request.getParameter("userID") : "");
        String selCompany = (request.getParameter("companyID") != null ? request.getParameter("companyID") : "");
		String primary = ezCommonService.getTenantConfig("LangPrimary" + user.getLang(), user.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + user.getLang(), user.getTenantId());
		
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
		
		logger.debug("addJobConfig ended.");
		
		return "admin/ezOrgan/addJobConfig";
	}
	
	/**
	 * 조직도관리 겸직관리 겸직등록 대상부서 선택 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/addjobAdd.do")	
	public String addjobAdd(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
	    logger.debug("addjobAdd started.");
	    
		LoginVO user = commonUtil.userInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		
		if (companyID == null || companyID.equals("")) {
			companyID = "Top";
		}
		
		logger.debug("companyID=" + companyID);
		        
		model.addAttribute("companyID", companyID);
		model.addAttribute("userInfo", user);
		
		logger.debug("addjobAdd ended.");
		
		return "admin/ezOrgan/addJobAdd";
	}
	
	/**
	 * 조직도관리 권한관리 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/permissionsList.do")	
	public String permissionsList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
	    logger.debug("permissionsList started.");
	    
		LoginVO user = commonUtil.userInfo(loginCookie);
		//관리자 권한 체크
		if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		String use_editor = ezCommonService.getTenantConfig("EDITOR", user.getTenantId());
		String use_ie11Browser = ezCommonService.getTenantConfig("IE11EDITOR", user.getTenantId());
		
        String IsJMochaStandAlone = config.getProperty("config.IsJMochaStandAlone");
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(user.getPrimary(), user.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (user.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(user.getCompanyID())) {
				resultList.add(j++, vo);
			}
		}
		        	
		model.addAttribute("use_editor", use_editor);
		model.addAttribute("use_ie11Browser", use_ie11Browser);
		model.addAttribute("userCompany", user.getCompanyID());
		model.addAttribute("list", resultList);
		model.addAttribute("isAdmin", user.getRollInfo().indexOf("c=1") > -1);
        model.addAttribute("IsJMochaStandAlone", IsJMochaStandAlone);		
		
		logger.debug("permissionsList ended.");
		
		return "admin/ezOrgan/permissionsList";
	}	
	
	/**
	 * 조직도관리 권한관리 리스트 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getPermissionsList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getPermissionsList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
	    logger.debug("getPermissionsList started.");
	    
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
		String companyID = request.getParameter("companyID");
		String type = request.getParameter("type");
		String strLang = userInfo.getPrimary();
		int pageNum = Integer.parseInt(request.getParameter("pageNum"));
		int pageSize = Integer.parseInt(request.getParameter("pageSize"));		
		int startRow = (pageSize * (pageNum - 1)) + 1;
        int endRow = pageSize * pageNum;
                
        int cnt = ezOrganAdminService.getPermissionListCount(companyID, type, strLang, tenantID);

        logger.debug("companyID=" + companyID + ",type=" + type + ",strLang=" + strLang + ",pageNum=" + pageNum
                + ",pageSize=" + pageSize + ",startRow=" + startRow + ",endRow=" + endRow
                + ",totalCount=" + cnt);
        
        List<OrganUserVO> list = ezOrganAdminService.getPermissionList(companyID, type, strLang, startRow, endRow, tenantID);
        
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
        
        logger.debug("getPermissionsList ended.");
        
		return result.toString();
	}
	
	/**
	 * 조직도관리 권한관리 권한등록 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/permissionsCheck.do")	
	public String permissionsCheck(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
	    logger.debug("permissionsCheck started.");
	    
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
		
		String IsJMochaStandAlone = config.getProperty("config.IsJMochaStandAlone");
		
		model.addAttribute("userID", userID);
		model.addAttribute("companyID", selCompany);
		model.addAttribute("topID", topID);
		model.addAttribute("userInfo", user);
		model.addAttribute("isAdmin", user.getRollInfo().indexOf("c=1") > -1);
		model.addAttribute("IsJMochaStandAlone", IsJMochaStandAlone);
		
		logger.debug("permissionsCheck ended.");
		
		return "admin/ezOrgan/permissionsCheck";
	}
	
	/**
	 * 조직도관리 퇴직자관리 메뉴 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/retireUserManage.do")	
	public String retireUserManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
	    logger.debug("retireUserManage started");
	    
		LoginVO user = commonUtil.userInfo(loginCookie);
		
		//관리자 권한 체크
		if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
        int tenantID = user.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
		
		String strLang = user.getPrimary();
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
				totalPage = totalCount / pPageRow;
				
				if (totalCount % pPageRow != 0) {
				    totalPage++;
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
		
   		logger.debug("retireUserManage ended");
   		
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
        
        String cnList = request.getParameter("cn");
        
        logger.debug("tenantID=" + tenantID + ",cnList=" + cnList);
	    
		String deptID = request.getParameter("deptID");
		String[] cn = cnList.split(",");
		
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
	public String retireUserInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
	    logger.debug("retireUserInfo started");
	    
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
		
		logger.debug("retireUserInfo ended");
		
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
	
	/**
	 * 조직도관리 메일주소 창 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/configEmail.do")
	public String configEmail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("configEmail started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		//관리자 권한 체크
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
        int tenantID = userInfo.getTenantId();        
        logger.debug("tenantID=" + tenantID);
		
		String userId = (request.getParameter("id") == null ? "" : request.getParameter("id"));
		
		List<String> mailList = new ArrayList<String>();
		
		OrganUserVO userVO = ezOrganAdminService.getUserInfo(userId, userInfo.getPrimary(), tenantID);
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantID);
		String userAccount = userId + "@" + domainName;
		if (userAccount.equals(userVO.getMail())) {
			mailList.add("SMTP:" + userAccount);
		} else {
			mailList.add("smtp:" + userAccount);
		}
		
		List<String> aliasMailList = ezEmailService.getIndividualAlias(userAccount);
		for (String mail : aliasMailList) {
			if (mail.equals(userVO.getMail())) {
				mailList.add("SMTP:" + mail);
			} else {
				mailList.add("smtp:" + mail);
			}
		}
		
		for (String mail : mailList) {
			logger.debug("mail=" + mail);
		}
		
		//TODO: delete
		//model.addAttribute("noneActiveX", noneActiveX);
		
		model.addAttribute("userId", userId);
		model.addAttribute("mailList", mailList);
		model.addAttribute("originalMail", userAccount);
		
		logger.debug("configEmail ended.");
		
		return "admin/ezOrgan/configEmail";
	}
	
	/**
	 * 조직도관리 메일주소 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveEmail.do")
	@ResponseBody
	public String saveEmail(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData) throws Exception{
		logger.debug("saveEmail started.");
		
		String returnValue = "ERROR";
		
		try {
			//관리자 권한 체크
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
				return returnValue;
			}
			
			logger.debug("bodyData=" + bodyData);
			
			Document xmldom = commonUtil.convertStringToDocument(bodyData);
			String userId = xmldom.getElementsByTagName("CN").item(0).getTextContent();
			String primaryMail = xmldom.getElementsByTagName("PRIMARYMAIL").item(0).getTextContent();
			
			int tenantID = userInfo.getTenantId();
			String domainName = ezCommonService.getTenantConfig("DomainName", tenantID);
			String originalMail = userId + "@" + domainName;
			
			List<String> mailList = new ArrayList<String>();
			NodeList mailNodeList = xmldom.getElementsByTagName("MAIL");
			for (int i=0; i<mailNodeList.getLength(); i++) {
				String mail = mailNodeList.item(i).getTextContent();
				
				if (!mail.substring(5).equals(originalMail)) {
					mailList.add(mail.substring(5));
				}
			}
			
			returnValue = ezEmailService.setIndividualAlias(userId, tenantID, primaryMail, mailList);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("saveEmail ended.");
		
		return returnValue;
	}
	
	/**
	 * 조직도관리 메일주소 도메인체크 및 중복체크 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/checkEmail.do")
	@ResponseBody
	public String checkEmail(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData) throws Exception{
		logger.debug("checkEmail started.");
		
		String returnValue = "ERROR";
		
		try {
			//관리자 권한 체크
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
				return returnValue;
			}
			
			Document xmldom = commonUtil.convertStringToDocument(bodyData);
			String mail = xmldom.getElementsByTagName("MAIL").item(0).getTextContent();
			returnValue = ezEmailService.checkIndividualAlias(mail);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("checkEmail ended.");
		
		return returnValue;
	}
	
    /**
     * 조직도관리 편지함관리 창 호출 함수
     */
    @RequestMapping(value = "/admin/ezOrgan/configUserQuota.do")
    public String configUserQuota(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
        logger.debug("configUserQuota started.");
        
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        
        //관리자 권한 체크
        if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
            return "cmm/error/adminDenied";
        }
        
        int tenantID = userInfo.getTenantId();        
        logger.debug("tenantID=" + tenantID);
        
        String userId = (request.getParameter("id") == null ? "" : request.getParameter("id"));  

        String domainName = ezCommonService.getTenantConfig("DomainName", tenantID);
        String userEmail = userId + "@" + domainName;
                        
        Double[] returnedData = ezEmailUtil.getUserQuota(userEmail);
        
        Double userQuota = returnedData[0];
        
        if (userQuota != null) {
            userQuota = userQuota/1024;
        }

        Double userWarn = returnedData[1];
        
        if (userWarn != null) {
            userWarn = userWarn/1024;
        }
        
        model.addAttribute("userId", userId);
        model.addAttribute("userQuota", userQuota);
        model.addAttribute("userWarn", userWarn);
        
        logger.debug("configUserQuota ended.");
        
        return "admin/ezOrgan/configUserQuota";
    }
    
    /**
     * 조직도관리 사용자 편지함용량 저장 실행 함수
     */
    @RequestMapping(value = "/admin/ezOrgan/saveUserQuota.do")
    @ResponseBody
    public String saveUserQuota(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData) throws Exception {
        logger.debug("saveUserQuota started.");
        
        String returnValue = "ERROR";
        
        try {
            //관리자 권한 체크
            LoginVO userInfo = commonUtil.userInfo(loginCookie);
            if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
                return returnValue;
            }
            
            logger.debug("bodyData=" + bodyData);
            
            Document xmldom = commonUtil.convertStringToDocument(bodyData);
            String userId = xmldom.getElementsByTagName("CN").item(0).getTextContent();
            String useDefault = xmldom.getElementsByTagName("useDefault").item(0).getTextContent();
            String warnStorage = xmldom.getElementsByTagName("warnStorage").item(0).getTextContent();
            String maxStorage = xmldom.getElementsByTagName("maxStorage").item(0).getTextContent();
            
            int tenantID = userInfo.getTenantId();
            String domainName = ezCommonService.getTenantConfig("DomainName", tenantID);
            String userEmail = userId + "@" + domainName;
            
            logger.debug("userEmail=" + userEmail + ",useDefault=" + useDefault 
                    + ",warnStorage=" + warnStorage + ",maxStorage=" + maxStorage);
            
            if (useDefault.equals("1")) {
                ezEmailUtil.deleteUserQuota(userEmail);
            } else {
                ezEmailUtil.setUserQuota(userEmail, maxStorage, warnStorage);
            }            
            
            returnValue = "OK";
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        logger.debug("saveUserQuota ended.");
        
        return returnValue;
    }
    
}
