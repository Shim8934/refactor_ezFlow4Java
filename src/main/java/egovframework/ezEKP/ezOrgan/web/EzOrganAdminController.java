package egovframework.ezEKP.ezOrgan.web;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.geom.Ellipse2D;
import java.awt.image.BufferedImage;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;
import java.util.UUID;
import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
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
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
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
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzAddressService ezAddressService;
	
	@Autowired
	private EzEmailUserAdminService ezEmailUserAdminService;

    @Autowired
    private EzEmailUtil ezEmailUtil;	
    
    @Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
    
    @Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;

    @PostConstruct
	public void init() throws Exception {
    	logger.debug("init started.");

    	ezCommonService.createTblCompanyConfig();
    	
    	logger.debug("init ended.");
    }

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
	public String organLeft(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO user = commonUtil.userInfo(loginCookie);
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", user.getTenantId());
		
		// set useLetter
		String useLetter = ezCommonService.getTenantConfig("useLetter", user.getTenantId());
		if (useLetter == null || useLetter.equals("")) {
			useLetter = "NO";
		}
				
		logger.debug("useLetter=" + useLetter);
		
		model.addAttribute("dotNetIntegration", dotNetIntegration);
		model.addAttribute("useLetter", useLetter);
		
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
		
		String use_approvalG = config.getProperty("config.UserInfo_ApprovalG");
		String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", user.getTenantId());
		String useBizmekaTalk = ezCommonService.getTenantConfig("UseBizmekaTalk", user.getTenantId());
		String useDisablePop3Imap = ezCommonService.getTenantConfig("UseDisablePopImap", user.getTenantId());
		
		if (useDisablePop3Imap.equals("")) {
			useDisablePop3Imap = "NO";
		}
		
		model.addAttribute("useDisablePopImap", useDisablePop3Imap);
		model.addAttribute("topid", topid);
		model.addAttribute("useOCS", config.getProperty("config.USE_OCS"));
		model.addAttribute("use_approvalG", use_approvalG);
		model.addAttribute("useBizmekaSpambox", useBizmekaSpambox);
		model.addAttribute("useBizmekaTalk", useBizmekaTalk);
		
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", user.getTenantId());		
		model.addAttribute("dotNetIntegration", dotNetIntegration);
		model.addAttribute("locale", user.getLocale());
		
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
		String mailId = request.getParameter("mailId");
		String extensionAttribute15 = request.getParameter("extensionAttribute15");
		extensionAttribute15 = extensionAttribute15 != null ? extensionAttribute15 : "";		
		String skipInitData = request.getParameter("skipInitData");
		skipInitData = skipInitData != null ? skipInitData : "";
		String operatorId = request.getParameter("operatorId");
		operatorId = operatorId != null ? operatorId : "";
		
		logger.debug("parentCn=" + parentCn + ",cn=" + cn + ",displayName=" + displayName
				+ ",displayName2=" + displayName2 + ",mailId=" + mailId
				+ ",extensionAttribute15=" + extensionAttribute15 + ",skipInitData=" + skipInitData + ",operatorId=" + operatorId);
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
        if (userInfo == null) {
        	return "EMAIL_ERROR";
        }
		
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);       
		
		String domain = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		
		logger.debug("domain=" + domain);
		        
		String result = "";
		
		String operatorMailIdPropertyName = "operatorMailId";
		
		// 회사정보를 수정하는 경우
        if (parentCn == null || parentCn.isEmpty()) {
			String mailAddr = cn + "@" + domain;
			
			// 최상위 회사(Top)의 경우에만 이메일 아이디를 변경할 수 있다.
			if (cn.equalsIgnoreCase("Top")) {
				mailAddr = mailId + "@" + domain;
				
				logger.debug("new mailAddr=" + mailAddr);
			}
        	
        	ezOrganAdminService.updateDBData_company(cn, displayName, displayName2, mailAddr, tenantID);
        	
			String existingOperatorMailId = ezCommonService.getCompanyConfig(tenantID, cn, operatorMailIdPropertyName);
        	
        	if (!operatorId.equals("")) {				
				if (!existingOperatorMailId.equals("")) {
					ezCommonService.updateCompanyConfig(tenantID, cn, operatorMailIdPropertyName, operatorId);
				} else {
					ezCommonService.insertCompanyConfig(tenantID, cn, operatorMailIdPropertyName, operatorId);
				}
        	} else {
        		if (!existingOperatorMailId.equals("")) {
        			ezCommonService.deleteCompanyConfig(tenantID, cn, operatorMailIdPropertyName);
        		}
        	}
        // 새로운 회사를 생성하는 경우	
        } else {			
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
					
					//업무일지 - 일지함 생성
					Map<String, Object> param = new HashMap<String, Object>();
					param.put("tenantId", tenantID);
					param.put("companyId", cn);
					param.put("userId", userInfo.getId());
					JSONObject journalResult = commonUtil.getJsonFromRestApi("/rest/ezjournal/types", param, request, "post", null);
					
					String journalStatus = (String) journalResult.get("status");
					
					if (journalStatus.equals("ok")) {
						ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
					}
					
					logger.debug("updateGroupAdd rc=" + rc);
					
					if (rc == 0 && journalStatus.equals("ok")) { // updateGroupAdd 성공
						
						// insertDBData_company 실패했을 경우 JMocha에서 회사 다시 삭제.
						try {
							ezOrganAdminService.insertDBData_company(cn, displayName, displayName2,
									mailAddr, parentCn, ldapPath, extensionAttribute15, skipInitData, tenantID, userInfo);
							
							if (!operatorId.equals("")) {
								ezCommonService.insertCompanyConfig(tenantID, cn, operatorMailIdPropertyName, operatorId);
							} 
							
							result = "OK";
						} catch (Exception e) {
							e.printStackTrace();
							commonUtil.getJsonFromRestApi("/rest/ezjournal/types", param, request, "delete", null);

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
	    
	    LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
	    
        if (userInfo == null) {
        	return "EMAIL_ERROR";
        }
	    
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
					String bizmekaResult = "ERROR";
					
				    try {
						String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantID);
						
						if (useBizmekaSpambox.equals("YES")) {
							String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantID);
							String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantID);
							String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantID);
							
							bizmekaResult = ezEmailUtil.bizmekaDeleteDept(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, cn);		
							
							logger.debug("bizmekaResult=" + bizmekaResult);
							
							if (!bizmekaResult.equals("OK")) {
								throw new Exception("bizmekaDeleteDept failed");
							}						
						}
				    	
    					ezOrganAdminService.deleteDBData(cn, pClass, tenantID);
    					result = "OK";
    				// 예외가 발생하면 그룹 주소를 다시 등록한다.
				    } catch (Exception e) {
				    	e.printStackTrace();
				    	
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
        String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", tenantID);    
       
        model.addAttribute("approvalFlag", approvalFlag);
        model.addAttribute("primary", primary);
        model.addAttribute("secondary", secondary);
        model.addAttribute("locale", userInfo.getLocale());
        
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
	    
        LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
        
        if (userInfo == null) {
        	return "EMAIL_ERROR";
        }
        
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
		if (vo.getParentCn() == null || vo.getParentCn().isEmpty()) {
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
						String bizmekaResult = "ERROR";
						
						// insertDBData_dept 실패했을 경우 JMocha에서 부서 다시 삭제.
						try {
							String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantID);
							
							if (useBizmekaSpambox.equals("YES")) {
								String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantID);
								String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantID);
								String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantID);
								String parentDeptId = vo.getParentCn();
								
								// 비즈메카에서는 조직도 최상위 회사의 ID가 Top이 아닌 companyId를 사용하므로 상위부서가 Top인 경우 변경한다.
								if (parentDeptId.equals("Top")) {
									parentDeptId = bizmekaCompanyId;
								}
								
								bizmekaResult = ezEmailUtil.bizmekaAddDept(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, 
														cn, vo.getDisplayName(), parentDeptId);		
								
								logger.debug("bizmekaResult=" + bizmekaResult);
								
								if (!bizmekaResult.equals("OK")) {
									throw new Exception("bizmekaAddDept failed");
								}						
							}
							
							vo.setMail(mailAddr);
							
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
	public String selectDept(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
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
		
		model.addAttribute("companyID", topid);
		
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
	    
        LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
        
        if (userInfo == null) {
        	logger.debug("movDept: it's not admin");
        	
        	return "EMAIL_ERROR";
        }
	    
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);       
	    
		String parentCn = request.getParameter("parentCn");
		String cn = request.getParameter("cn");
		
        logger.debug("parentCn=" + parentCn + ",cn=" + cn);
        
        String result = "OK";
		String bizmekaResult = "ERROR";
		String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantID);		
        
		if (useBizmekaSpambox.equals("YES")) {
			String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantID);
			String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantID);
			String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantID);
			String parentDeptId = parentCn;
			
			// 비즈메카에서는 조직도 최상위 회사의 ID가 Top이 아닌 companyId를 사용하므로 상위부서가 Top인 경우 변경한다.
			if (parentDeptId.equals("Top")) {
				parentDeptId = bizmekaCompanyId;
			}
			
			bizmekaResult = ezEmailUtil.bizmekaMoveDept(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, cn, parentDeptId);		
			
			logger.debug("bizmekaResult=" + bizmekaResult);
			
			if (!bizmekaResult.equals("OK")) {
				result = "EMAIL_ERROR";
			}
		}
		
		if (result.equals("OK")) {
	        result = ezOrganAdminService.moveEntry(parentCn, cn, "group", tenantID);
	
	        logger.debug("moveEntry result=" + result);
		}
        
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
        
        LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
        
        if (userInfo == null) {
        	throw new Exception("saveOrderList failed.");
        }        
        
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
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		String lang = userInfo.getLang();		
		String primary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		
		String checkID = config.getProperty("config.USE_CHECKUPSTR");
		String useAddressOpenAPI = config.getProperty("config.USE_AddressOpenAPI");
		String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", userInfo.getTenantId());
		String useZipCodeSearch = ezCommonService.getTenantConfig("useZipCodeSearch", userInfo.getTenantId());
		
		if (useZipCodeSearch == null || useZipCodeSearch.equals("")) {
			useZipCodeSearch = "YES";
		}
		
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		model.addAttribute("checkID", checkID);
		model.addAttribute("lang", lang);
		model.addAttribute("useAddressOpenAPI", useAddressOpenAPI);
		model.addAttribute("birthDay", "");
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("primaryLang", primaryLang);
		model.addAttribute("useBizmekaSpambox", useBizmekaSpambox);
		model.addAttribute("useZipCodeSearch", useZipCodeSearch);
		model.addAttribute("locale", userInfo.getLocale());
				
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
				downImage(filePath, request, response);
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
		
        LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
        
        if (userInfo == null) {
        	throw new Exception("changePassword failed.");
        }

        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);		
		
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		
		logger.debug("domain=" + domain);
		// dhlee - end
		
		for (int i = 0; i < cn.length; i++) {
			ezOrganAdminService.setPasswordWithEmailSystem(cn[i], domain, pw, tenantID);
		}
		
		logger.debug("changePassword ended.");
	}
	
	/**
	 * 조직도관리 사원퇴직 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/retireUser.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String retireUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("retireUser started.");
	    
        LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
        
        if (userInfo == null) {
        	logger.debug("retireUser: it's not admin");
        	
        	return "EMAIL_ERROR";
        }
        
		// 현재 관리자의 암호를 구한다.
		List<String> userCookieInfo = commonUtil.getUserIdAndRealPassword(loginCookie);
		String adminPassword = userCookieInfo.get(1);
        
        int tenantID = userInfo.getTenantId();        
        
        String cnList = request.getParameter("cn");
        
        logger.debug("tenantID=" + tenantID + ",cnList=" + cnList);
        	    
		String cn[] = cnList.split(",");
		String result = "OK";
		
		// dhlee
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		// dhlee - end
		
		for (int i = 0; i < cn.length; i++) {			
			// dhlee
			String mailAddr = cn[i] + "@" + domain;
			
			logger.debug("mailAddr=" + mailAddr);
			
			int rc = ezEmailUserAdminService.retireUser(mailAddr);
			
			logger.debug("retireUser rc=" + rc);
			
			List<String> distributionList = null;
			
			if (rc == 0) { // retireUser 성공				
				// 해당 User가 속한 Group Email 주소에서 해당 User를 제거한다.
				OrganUserVO userVO = ezOrganAdminService.getUserInfo(cn[i], userInfo.getPrimary(), tenantID);
				String groupAddr = userVO.getDepartment() + "@" + domain;
				rc = ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
				
				logger.debug("updateGroupDel rc=" + rc);
				
				if (rc != -100) { // updateGroupDel 성공(부모(그룹)나 자식(유저)을 찾지못해도 성공으로 봄.)
					try {
						// 로컬 시스템에서 해당 User의 계정을 퇴직처리한다.
						ezOrganAdminService.retireEntry(cn[i], domain, adminPassword, tenantID);
					} catch (Exception e) { // Exception이 발생하면 복구 처리를 한다.
						ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
						ezEmailUserAdminService.restoreUser(mailAddr);
						
						result = "EMAIL_ERROR";
						break;
					}					
				} else { // updateGroupDel 실패
					// Group Email 주소에서 제거하는 것이 실패하면 해당 User를 복원시키고, Exception을 발생시킨다.
					ezEmailUserAdminService.restoreUser(mailAddr);
					
					logger.debug("removing the user '" + mailAddr + "' from its group email failed.");
					
					result = "EMAIL_ERROR";
					break;					
				}
				// 사용자가 속한 공용배포그룹의 Group Email 주소 목록을 구한다.
				distributionList = ezEmailUserAdminService.getUserDistributionList(mailAddr);
				
				for (String dist : distributionList) {
					logger.debug("dist=" + dist);
					
					// 공용배포그룹의 Group Email 주소로부터 해당 User를 제거한다.
					rc = ezEmailUserAdminService.updateGroupDel(dist, mailAddr);	
					
					logger.debug("updateGroupDel rc=" + rc);							
				}
			}
			// dhlee - end
		}
		
		logger.debug("retireUser ended. result=" + result);
		
		return result;
	}
	
	/**
	 * 조직도관리 사원이동 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/movUser.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String movUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("movUser started.");
	    
        LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
        
        if (userInfo == null) {
        	logger.debug("movUser: it's not admin");
        	
        	return "EMAIL_ERROR";
        }
	    
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
		String parentCn = request.getParameter("parentCn");
		String cn[] = request.getParameter("cn").split(",");
		String result = "OK";
		
		logger.debug("parentCn=" + parentCn);
		
		String bizmekaResult = "ERROR";
		String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantID);		
		
		for (int i=0; i < cn.length; i++) {
		    logger.debug("cn[" + i + "]=" + cn[i]);		    
			
			if (useBizmekaSpambox.equals("YES")) {
				String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantID);
				String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantID);
				String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantID);
				String parentDeptId = parentCn;
				
				// 비즈메카에서는 조직도 최상위 회사의 ID가 Top이 아닌 companyId를 사용하므로 상위부서가 Top인 경우 변경한다.
				if (parentDeptId.equals("Top")) {
					parentDeptId = bizmekaCompanyId;
				}
				
				bizmekaResult = ezEmailUtil.bizmekaMoveUser(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, cn[i], parentDeptId);		
				
				logger.debug("bizmekaResult=" + bizmekaResult);
				
				if (!bizmekaResult.equals("OK")) {
					result = "EMAIL_ERROR";
					break;
				}
			}
		    
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
	@RequestMapping(value = "/admin/ezOrgan/delUser.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String delUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    logger.debug("delUser started.");
	    
        LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
        
        if (userInfo == null) {
        	logger.debug("delUser: it's not admin");
        	
        	return "EMAIL_ERROR";
        }
        
        int tenantID = userInfo.getTenantId();        
        String cnList = request.getParameter("cn");
        
        logger.debug("tenantID=" + tenantID + ",cnList=" + cnList);
	    
		String cn[] = cnList.split(",");
		String result = "OK";
		
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
				List<String> distributionList = null;
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
						
						if (rc == -100) { // Group Email 주소에서 제거 실패함.(부모(그룹)나 자식(유저)를 찾지 못한 경우는 성공으로 취급함)
							ezEmailUserAdminService.restoreUser(mailAddr);
							
							logger.debug("removing the user '" + mailAddr + "' from its group email failed.");
							
							result = "EMAIL_ERROR";
							break;
						}						
						
						// 사용자가 속한 공용배포그룹의 Group Email 주소 목록을 구한다.
						distributionList = ezEmailUserAdminService.getUserDistributionList(mailAddr);
						
						for (String dist : distributionList) {
							logger.debug("dist=" + dist);
							
							// 공용배포그룹의 Group Email 주소로부터 해당 User를 제거한다.
							rc = ezEmailUserAdminService.updateGroupDel(dist, mailAddr);	
							
							logger.debug("updateGroupDel rc=" + rc);							
						}						
					} else {
						logger.debug("retiring the user '" + mailAddr + "' failed.");
						
						result = "EMAIL_ERROR";
						break;						
					}
				} 
							
				String bizmekaResult = "ERROR";
				
				try {
					String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantID);
					
					// 비즈메카와 연동된 경우에는 비즈메카 API를 이용해 비즈메카 사용자 계정을 삭제한다.
					if (useBizmekaSpambox.equals("YES")) {
						String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantID);
						String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantID);
						String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantID);
						
						bizmekaResult = ezEmailUtil.bizmekaDeleteUser(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, cn[i]);		
						
						logger.debug("bizmekaResult=" + bizmekaResult);
						
						if (!bizmekaResult.equals("OK")) {
							throw new Exception("bizmekaDeleteUser failed");
						}						
					}
										
					// 로컬 시스템 계정을 삭제한다.
					ezOrganAdminService.deleteDBData(cn[i], "user", tenantID);
				} catch (Exception e) {
					if (userExists == 1) { // 유효한 이메일 계정이었으면 복구 처리를 수행한다.
						if (distributionList != null) {
							for (String dist : distributionList) {
								logger.debug("dist=" + dist);
								
								// 공용배포그룹의 Group Email 주소에 해당 User를 추가한다.
								rc = ezEmailUserAdminService.updateGroupAdd(dist, mailAddr);	
								
								logger.debug("updateGroupAdd rc=" + rc);							
							}													
						}
						
						ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
						ezEmailUserAdminService.restoreUser(mailAddr);							
					}
					
					result = "EMAIL_ERROR";
					break;
				}
				
				// 아래 과정에서 에러가 발생하면 복구할 수는 없지만, 이미 유효한 계정이 아니므로
				// 저장 공간은 차지하지만 해당 계정이 사용되지는 않는다. 
				
				// 퇴직자 계정을 삭제한다.
				ezEmailUserAdminService.removeUser(mailAddr);
				
				// 해당 사용자의 메일박스들을 모두 제거한다.
				ezEmailUserAdminService.removeUserAllMailboxes(mailAddr);
				
				// 해당 사용자의 개인주소록 및 주소록 관련 설정을 모두 제거한다.
				ezAddressService.removeUserAddress(mailAddr);
			}
			// dhlee - end
		}		
		
		logger.debug("delUser ended. result=" + result);
		
		return result;
	}
	
	private String checkLicenseKey(int tenantID, String domain) throws Exception {
		String licenseKey = ezCommonService.getTenantConfig("LicenseKey", tenantID);
		
		logger.debug("licenseKey=" + licenseKey);
		
		// 입력된 라이센스키가 발견되지 않는 경우
		if (licenseKey == null || licenseKey.equals("")) {
			logger.debug("No License Key is found.");
			
			return "NO_LICENSE_KEY";
		}
		
		try {
			// 라이센스키를 복호화한다.
			licenseKey = egovFileScrty.decryptAES(licenseKey);
		} catch (Exception e) {
			logger.debug("License Key Decryption failed.");
			
			return "INVALID_LICENSE_KEY";
		}
		
		logger.debug("Decrypted licenseKey=" + licenseKey);
		
		String items[] = licenseKey.split(":");
		
		if (items.length < 2) {
			logger.debug("Number of License Key Items is less than 2");
			
			return "INVALID_LICENSE_KEY";					
		}
		
		String licensedDomainName = items[0];
		
		if (!licensedDomainName.equals(domain)) {
			logger.debug("licensedDomainName=" + licensedDomainName + ",domain=" + domain);
			
			return "INVALID_LICENSE_KEY";										
		}
		
		String licensedUserCountStr = items[1];
		
		int licensedUserCount = 0; 
				
		try {
			licensedUserCount = Integer.parseInt(licensedUserCountStr);
		} catch (NumberFormatException e) {
			logger.debug("Parsing Licensed User Count failed.");
			
			return "INVALID_LICENSE_KEY";										
		}
		
		int userCount = ezOrganAdminService.getUserCount(tenantID);
		
		// masteradmin 사용자를 제외하기 위해 1을 뺀다.
		userCount--;
		
		logger.debug("licensedUserCount=" + licensedUserCount + ",userCount=" + userCount);
				
		if (licensedUserCount <= userCount) {
			logger.debug("Maximum User Count already reached");
			
			return "MAX_USER_REACHED";															
		}
		
		return "OK";
	}
	
	/**
	 * 조직도관리 사원정보 추가/수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveUserInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String saveUserInfo(@CookieValue("loginCookie") String loginCookie, OrganUserVO vo, HttpServletRequest request, HttpServletResponse response, Locale locale) throws Exception{
	    logger.debug("saveUserInfo started.");
	    
	    LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
	    
        //관리자 권한 체크
        if (userInfo == null) {
        	return "EMAIL_ERROR";
        }
	    	    
        // JMocha Mail Server가 계정이 소문자로 저장될 필요가 있어 
        // 사용자 아이디를 무조건 소문자로 변환한다.
        // 소문자로 저장되기만 하면 메일 수신 시에는 발신자가 대소문자를 혼합해서 보내도
        // 수신에 문제는 없다.
        if (vo.getCn() != null) {
        	vo.setCn(vo.getCn().toLowerCase());
        }
        
	    int tenantID = userInfo.getTenantId();

	    vo.setTenantId(tenantID);
	    
	    SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        date.setTimeZone(TimeZone.getTimeZone("GMT"));
        String nowDate = date.format(new Date()); 
        vo.setNowDate(nowDate);
	    
	    logger.debug("tenantID=" + tenantID + ",parentCn=" + vo.getParentCn());
	    
		String result = "";		
		String jobTile2 = "";
		String jobPostion2 = "";
		OrganUserVO useRankMailUser = null;
		String companyId = "";
		
		// 전체관리자가 아닌데 전체관리자 권한을 설정하려는 경우엔 CHECKPERMISSION을 반환한다.
        if (userInfo.getRollInfo().indexOf("c=1") == -1 
                && vo.getExtensionAttribute1() != null
                && vo.getExtensionAttribute1().toLowerCase().indexOf("c=1") > -1) {
            result = "CHECKPERMISSION";		
		// 기존 사용자를 수정하는 경우엔 parentCn의 값이 null 혹은 empty string 이다.
        } else if (vo.getParentCn() == null || vo.getParentCn().equals("")) {
        	try {
        		String useRankMail = ezCommonService.getTenantConfig("useRankMail", tenantID);
        		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
    			String cn = vo.getCn();

        		if (useRankMail != null && useRankMail.equals("YES")) {//직위,직책별 메일 발송 여부
        			String jobTile = vo.getTitle() == null ? "" : vo.getTitle(); 
					String jobPostion = vo.getExtensionAttribute10() == null ? "" : vo.getExtensionAttribute10();
					useRankMailUser = ezOrganAdminService.getUserInfo(cn, userInfo.getPrimary(), tenantID);
					OrganDeptVO deptVO = ezOrganService.getDeptInfo(useRankMailUser.getDepartment(), userInfo.getPrimary(), tenantID);//user의 부서 정보
					companyId = deptVO.getExtensionAttribute2();//회사 ID
					String beforeTitle = useRankMailUser.getTitle();//이전의 직위
					String beforePosition = useRankMailUser.getExtensionAttribute10(); //이전의 직책
					
					if (jobTile != null && !jobTile.equals("")) {
						String userName = ezOrganAdminService.getDistributionUserName(tenantID, jobTile);
						jobTile2 = String.valueOf(UUID.randomUUID()).substring(0,8);

						logger.debug("jobTitle UUID=" + jobTile2);
							
							 if (beforeTitle != null && beforeTitle.equals(jobTile)) {//직위로 공용 배포그룹 존재할때
								 result = ezOrganAdminService.mailUpdateDistributionList(domain, jobTile, userName, companyId, tenantID, cn);
								 
							 } else {// 직위로 공용배포그룹이 없을때  or 직위 를 변경할때
								 String beforeTitleUserName = ezOrganAdminService.getDistributionUserName(tenantID, beforeTitle);
								 if (beforeTitleUserName != null && !beforeTitleUserName.equals("")) {
									 result = ezOrganAdminService.deleteTargetAddressUser(tenantID, beforeTitle, cn, companyId);
								 }

								 result = ezOrganAdminService.mailAddDistributionList(domain, jobTile, jobTile2, companyId, tenantID, cn);
							 }
						}
						
					if (jobPostion != null && !jobTile.equals("")) {
						String userName = ezOrganAdminService.getDistributionUserName(tenantID, jobPostion);
						jobPostion2 = String.valueOf(UUID.randomUUID()).substring(0,8);
						
						logger.debug("jobPostion2 UUID=" + jobPostion2);
						 
						 if (beforePosition != null && beforePosition.equals(jobPostion)) {//직책으로 공용 배포그룹 존재할떄
							 result = ezOrganAdminService.mailUpdateDistributionList(domain, jobPostion, userName, companyId, tenantID, cn);
						 } else {// 직책으로 공용배포그룹이 없을때 or 직책 을 변경할때
							 String beforeTitleUserName = ezOrganAdminService.getDistributionUserName(tenantID, beforeTitle);
							if (beforeTitleUserName != null && !beforeTitleUserName.equals("")) {
								result = ezOrganAdminService.deleteTargetAddressUser(tenantID, beforePosition, cn, companyId);
							}
							 
							 result = ezOrganAdminService.mailAddDistributionList(domain, jobPostion, jobPostion2, companyId, tenantID, cn);
						 }
					}
        		}
        		
        		ezOrganAdminService.updateDBData_user(vo);
        		result = "OK";
        	} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
        		e.printStackTrace();
        		ezOrganAdminService.deleteTargetAddressUser(tenantID, jobTile2, vo.getCn(), companyId);//직위 공용배포 그룹에서 user 삭제
        		ezOrganAdminService.deleteTargetAddressUser(tenantID, jobPostion2, vo.getCn(), companyId);//직책 공용배포 그룹에서 user 삭제
        		String userNameTitle = ezOrganAdminService.getDistributionUserName(tenantID, vo.getTitle());//user의 기존 직위 공용 배포 그룹 이름 가져오기
        		ezOrganAdminService.mailUpdateDistributionList(ezCommonService.getTenantConfig("DomainName", tenantID),
        				vo.getTitle(), userNameTitle, companyId, tenantID, vo.getCn());//기존 user의 직위 공용 배포 그룹에 user 추가 
        		String userNamePosition = ezOrganAdminService.getDistributionUserName(tenantID, vo.getTitle());//user의 기존 직책 공용 배포 그룹 이름 가져오기
        		ezOrganAdminService.mailUpdateDistributionList(ezCommonService.getTenantConfig("DomainName", tenantID),
        				vo.getExtensionAttribute10(), userNamePosition, companyId, tenantID, vo.getCn());//기존 user의 직책 공용 배포 그룹에 user 추가
        		e.printStackTrace();
        		result = "EMAIL_ERROR";
        	}
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
				// 라이센스키를 체크한다.
				String checkResult = checkLicenseKey(tenantID, domain);
				
				if (!checkResult.equals("OK")) {
					return checkResult;
				}
				
				String mailAddr = cn + "@" + domain;

				// 이메일 시스템에 계정을 생성한다.
				int rc = ezEmailUserAdminService.addUser(mailAddr, vo.getPassword());
				
				logger.debug("addUser rc=" + rc);
				
				if (rc == 0) { // addUser 성공
					// 해당 User가 속한 부서의 Group Email 주소에 User를 등록한다.					
					String groupAddr = vo.getParentCn() + "@" + domain;					
					rc = ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
					
					logger.debug("updateGroupAdd rc=" + rc);
					
					if (rc == 0) { // updateGroup 성공												
						String bizmekaResult = "ERROR";
						
						// insertDBData_user 실패했을 경우 JMocha에서 계정 다시 삭제.
						try {
							String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantID);
							
							if (useBizmekaSpambox.equals("YES")) {
								String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantID);
								String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantID);
								String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantID);
								String parentDeptId = vo.getParentCn();
								
								// 비즈메카에서는 조직도 최상위 회사의 ID가 Top이 아닌 companyId를 사용하므로 상위부서가 Top인 경우 변경한다.
								if (parentDeptId.equals("Top")) {
									parentDeptId = bizmekaCompanyId;
								}
								
								bizmekaResult = ezEmailUtil.bizmekaAddUser(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, cn, "", 
													vo.getDisplayName(), parentDeptId);		
								
								logger.debug("bizmekaResult=" + bizmekaResult);
								
								if (!bizmekaResult.equals("OK")) {
									throw new Exception("bizmekaAddUser failed");
								}
							}
							
							String useRankMail = ezCommonService.getTenantConfig("useRankMail", tenantID);
							
							if (useRankMail != null && useRankMail.equals("YES")) {//직위,직책별 메일 발송 여부
								
								String jobTile = vo.getTitle() == null ? "" : vo.getTitle(); 
								String jobPostion = vo.getExtensionAttribute10() == null ? "" : vo.getExtensionAttribute10();
								OrganDeptVO deptVO = ezOrganService.getDeptInfo(vo.getParentCn(), userInfo.getPrimary(), tenantID);//user의 부서 정보
								companyId = deptVO.getExtensionAttribute2();//회사 ID
								
								if (jobTile != null && !jobTile.equals("")) {
									String userName = ezOrganAdminService.getDistributionUserName(tenantID, jobTile);
									jobTile2 = String.valueOf(UUID.randomUUID()).substring(0,8);
									logger.debug("jobTitle UUID=" + jobTile2);
										
									 if (userName != null & !userName.equals("")) {//직위 로 공용 배포그룹 존재할때
										 result = ezOrganAdminService.mailUpdateDistributionList(domain, jobTile, userName, companyId, tenantID, cn);
									 } else {
										 result = ezOrganAdminService.mailAddDistributionList(domain, jobTile, jobTile2, companyId, tenantID, cn);
									 }
									 
								}
									
								if (jobPostion != null && !jobPostion.equals("")) {
									String userName = ezOrganAdminService.getDistributionUserName(tenantID, jobPostion);
									jobPostion2 = String.valueOf(UUID.randomUUID()).substring(0,8);
									logger.debug("jobPostion2 UUID=" + jobPostion2);
									 
									 if (userName != null & !userName.equals("")) {//직책 이름으로 공용 배포그룹 존재때
										 result = ezOrganAdminService.mailUpdateDistributionList(domain, jobPostion, userName, companyId, tenantID, cn);
									 } else {
										 result = ezOrganAdminService.mailAddDistributionList(domain, jobPostion, jobPostion2, companyId, tenantID, cn);
									 }
								}
							}
							
							vo.setMail(mailAddr);				
							String userPrincipalName = cn + "@" + domain;
							vo.setUpnName(userPrincipalName);
							
						    String oriPass = vo.getPassword();
							String pass = EgovFileScrty.encryptPassword(vo.getPassword(), cn);
							vo.setPassword(pass);
							
							// 로컬 시스템에 해당 User의 계정을 생성한다.
							ezOrganAdminService.insertDBData_user(vo, oriPass);
							
							String useStandardFolderId = config.getProperty("config.useStandardFolderId");
							
							if (useStandardFolderId != null && useStandardFolderId.equals("YES")) {							
								createDefaultFolders(loginCookie, mailAddr, locale);
							}
							
							result = "OK";
						} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
							e.printStackTrace();
							ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
							ezEmailUserAdminService.removeUser(mailAddr);
							ezOrganAdminService.mailDelDistributionList(tenantID, vo.getTitle()); //직위 공용 배포 그룹 삭제
							ezOrganAdminService.mailDelDistributionList(tenantID, vo.getExtensionAttribute10()); //직책 공용 배포 그룹 삭제
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
			}
			
			if (result.equals("OK")) {
		        // UseInitMailSign이 YES일 경우 메일 서명 등록
				String useInitMailSign = ezCommonService.getTenantConfig("UseInitMailSign", tenantID);
				if (useInitMailSign.equals("YES")) {
					try {
						setInitMailSign(vo);
					} catch (Exception e) {
						logger.error("setInitMailSign error.");
						e.printStackTrace();
					}
				}
				
				// UseInitInboxRule이 YES일 경우 메일 자동분류 등록
				String useInitInboxRule = ezCommonService.getTenantConfig("UseInitInboxRule", tenantID);
				if (useInitInboxRule.equals("YES")) {
					try {
						setInitInboxRule(loginCookie, vo, locale);
					} catch (Exception e) {
						logger.error("setInitInboxRule error.");
						e.printStackTrace();
					}
				}
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
			downImage(filePath, request, response);
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
		
		//썸네일 생성
        if (mode.equals("PICTURE")) {
        	String thumbnailPath = realPath + commonUtil.getUploadPath("upload_personal.PHOTOTHUMBNAIL", userInfo.getTenantId());
        	File file2 = new File(serverPath + fileName);
			File thumbnailFolder = new File(thumbnailPath);
			if (!thumbnailFolder.exists()) {
				thumbnailFolder.mkdirs();
			}
			
			File thumbnailFile = new File(thumbnailPath + commonUtil.separator + file2.getName());
			createThumbnail(file2, thumbnailFile);
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
			logger.debug("## " + multiFile.getName());
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
			/*2018-04-12이효진  bi.getType으로 지정시 color변경되어 TYPE_4BYTE_ABGR로 지정*/
//            BufferedImage bufferedImage = new BufferedImage(119, 128, bi.getType());
            BufferedImage bufferedImage = new BufferedImage(119, 128, BufferedImage.TYPE_4BYTE_ABGR);
            /*2018-04-12이효진  PNG파일 배경지정*/
//            bufferedImage.createGraphics().drawImage(bi, 0, 0, 119, 128, null);
            bufferedImage.createGraphics().drawImage(bi, 0, 0, 119, 128, Color.WHITE, null);
            
            File file2 = new File(serverPath + fileName + "png");
            ImageIO.write(bufferedImage, "png", file2);
            //임시 저장 파일 삭제
            deleteFile(tempPath + fileName + extension);
            
            //썸네일 생성
            if (mode.equals("PICTURE")) {
            	String thumbnailPath = realPath + commonUtil.getUploadPath("upload_personal.PHOTOTHUMBNAIL", userInfo.getTenantId());
    			File thumbnailFolder = new File(thumbnailPath);
    			if (!thumbnailFolder.exists()) {
    				thumbnailFolder.mkdirs();
    			}
    			
    			File thumbnailFile = new File(thumbnailPath + commonUtil.separator + file2.getName());
    			createThumbnail(file2, thumbnailFile);
            }
            
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
        
        LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
        
        if (userInfo == null) {
        	return "EMAIL_ERROR";
        }
        
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
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", user.getTenantId());
		String approvalForDoc = ezCommonService.getTenantConfig("approvalForDoc", user.getTenantId());
		
		//2018-07-31 김보미 - 근태 추가
		String use_attitude = ezCommonService.getTenantConfig("USE_ATTITUDE", user.getTenantId());
		if (use_attitude == null || use_attitude.equals("")) {
			use_attitude = "YES";
		}
		
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
		model.addAttribute("userCompany", user.getCompanyID());
		model.addAttribute("list", resultList);
		model.addAttribute("isAdmin", user.getRollInfo().indexOf("c=1") > -1);	
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("approvalForDoc", approvalForDoc);
		//2018-07-31 김보미 - 근태 추가
		model.addAttribute("use_attitude", use_attitude);
		
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
		String searchType = request.getParameter("searchType");
		String searchValue = request.getParameter("searchValue");
		int pageNum = Integer.parseInt(request.getParameter("pageNum"));
		int pageSize = Integer.parseInt(request.getParameter("pageSize"));		
		int startRow = (pageSize * (pageNum - 1)) + 1;
        int endRow = pageSize * pageNum;
                
        int cnt = ezOrganAdminService.getPermissionListCount(companyID, type, searchType, searchValue, strLang, tenantID);

        logger.debug("companyID=" + companyID + ",type=" + type + ",strLang=" + strLang + ",pageNum=" + pageNum
                + ",pageSize=" + pageSize + ",startRow=" + startRow + ",endRow=" + endRow
                + ",totalCount=" + cnt);
        
        List<OrganUserVO> list = ezOrganAdminService.getPermissionList(companyID, type, searchType, searchValue, strLang, startRow, endRow, tenantID);
        
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
		
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", user.getTenantId());
		String approvalForDoc = ezCommonService.getTenantConfig("approvalForDoc", user.getTenantId());
		//2018-07-31 김보미 - 근태 추가
		String use_attitude = ezCommonService.getTenantConfig("USE_ATTITUDE", user.getTenantId());
		if (use_attitude == null || use_attitude.equals("")) {
			use_attitude = "YES";
		}
		
		model.addAttribute("userID", userID);
		model.addAttribute("companyID", selCompany);
		model.addAttribute("topID", topID);
		model.addAttribute("userInfo", user);
		model.addAttribute("isAdmin", user.getRollInfo().indexOf("c=1") > -1);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("approvalForDoc", approvalForDoc);
		model.addAttribute("use_attitude", use_attitude);
		
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
   		model.addAttribute("totalCount", totalCount);
   		model.addAttribute("pPageRow", pPageRow);
		
   		String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", user.getTenantId());
   		model.addAttribute("useBizmekaSpambox", useBizmekaSpambox);
   		
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", user.getTenantId());		
		model.addAttribute("dotNetIntegration", dotNetIntegration);
   		
   		logger.debug("retireUserManage ended");
   		
		return "admin/ezOrgan/retireUserManage";
	}	
	
	/**
	 * 조직도관리 퇴직자관리 복구 기능 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/restoreRetireUser.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String restoreRetireUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    logger.debug("restoreRetireUser started.");
	    
        LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
        
        if (userInfo == null) {
        	logger.debug("restoreRetireUser: it's not admin");
        	
        	return "EMAIL_ERROR";
        }
        
        int tenantID = userInfo.getTenantId();        
        
        String cnList = request.getParameter("cn");
        
        logger.debug("tenantID=" + tenantID + ",cnList=" + cnList);
	    
		String deptID = request.getParameter("deptID");
		String[] cn = cnList.split(",");
		String result = "OK";
		
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
						
						result = "EMAIL_ERROR";
						break;
					}										
				} else {
					// Group Email 주소로의 추가가 실패하면 해당 User를 다시 퇴직처리하고 Exception을 발생시킨다.
					ezEmailUserAdminService.retireUser(mailAddr);
					
					logger.debug("Adding the user '" + mailAddr + "' to the specified group email '" + groupAddr + "' failed.");
					
					result = "EMAIL_ERROR";
					break;					
				}
			}
			// dhlee - end			
		}		
		
		logger.debug("restoreRetireUser ended. result=" + result);
		
		return result;
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
		
		OrganUserVO userVO = ezOrganAdminService.getUserInfo(userId, userInfo.getPrimary(), tenantID);
		
		List<String[]> aliasAddressList = ezEmailService.getAliasAddress(userId, tenantID);
		
		StringBuilder sb = new StringBuilder();
		sb.append("<select size='4' name='ListEmail' id='ListEmail' style='height:175px;width:100%;background:none;'>");
		
		for (String[] aliasAddress : aliasAddressList) {
			if (aliasAddress[0].equals(userVO.getMail())) {
				sb.append("<option type='" + aliasAddress[1] + "'>SMTP:" + aliasAddress[0] + "</option>");
			} else {
				sb.append("<option type='" + aliasAddress[1] + "'>smtp:" + aliasAddress[0] + "</option>");
			}
		}
		
		sb.append("</select>");
		String listEmailHtml = sb.toString();
		
		model.addAttribute("userId", userId);
		model.addAttribute("listEmailHtml", listEmailHtml);
		
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
		String bizmekaResult = "ERROR";
		
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
			
			List<String> mailList = new ArrayList<String>();
			NodeList mailNodeList = xmldom.getElementsByTagName("MAIL");
			for (int i=0; i<mailNodeList.getLength(); i++) {
				String mail = mailNodeList.item(i).getTextContent();
				mailList.add(mail.substring(5));
			}
			
			String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantID);
			
			if (useBizmekaSpambox.equals("YES")) {
				String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantID);
				String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantID);
				String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantID);
				
				bizmekaResult = ezEmailUtil.bizmekaEditEmailList(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, 
												userId, primaryMail, mailList);		

				logger.debug("bizmekaResult=" + bizmekaResult);
				
				if (!bizmekaResult.equals("OK")) {
					throw new Exception("bizmekaEditEmailList failed");
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
			int tenantId = userInfo.getTenantId();
			
			Document xmldom = commonUtil.convertStringToDocument(bodyData);
			String mail = xmldom.getElementsByTagName("MAIL").item(0).getTextContent();
			returnValue = ezEmailService.checkIndividualAlias(mail,tenantId);
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
        
//        String strCurrentUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
//        String caller = request.getHeader("referer").replace(strCurrentUrl, "");
//        logger.debug("caller=" + caller);
       
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
//        model.addAttribute("caller", caller);
        
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
    
	/**
	 * 그룹웨어 계정으로 비즈메카톡 계정을 동기화한다.
	 */
	@RequestMapping(value = "/admin/ezOrgan/syncWithBizmekaTalkAccounts.do")
	@ResponseBody
	public String syncWithBizmekaTalkAccounts(@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("syncWithBizmekaTalkAccounts started.");
		
		String returnValue = "ERROR";
		
		try {
			// 관리자 권한 체크
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
				return returnValue;
			}
			
			String ezTalkServerUrl = ezCommonService.getTenantConfig("ezTalkSyncServerUrl", userInfo.getTenantId());
			String queryString = "/ezTalkSyncServer/syncAccounts";
			String inputParams = "tenantId=" + userInfo.getTenantId();
			
			String resultCode = ezEmailUtil.getWebServiceResult(ezTalkServerUrl + queryString, inputParams);
			
			JSONParser parser = new JSONParser();
			JSONObject obj = (JSONObject) parser.parse(resultCode);
			logger.debug("ezTalkSyncServer getWebServerResult=" + obj.toJSONString());
			
			if (!obj.get("resultCode").equals("ERROR") && obj.get("resultCode") != null) {
				returnValue = "OK";
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("syncWithBizmekaTalkAccounts ended.");
		
		return returnValue;
	}
	
	/**
	 * POP3/IMAP 설정 화면을 출력한다.
	 */
	@RequestMapping(value = "/admin/ezOrgan/configPopImap.do")
	public String configPop3Imap(@CookieValue("loginCookie") String loginCookie,
			HttpServletRequest req, Model model) throws Exception {
		logger.debug("configPop3Imap started.");
		
		String returnValue = "ERROR";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		int tenantIdNum = userInfo.getTenantId();
		String userId = req.getParameter("userId");
		String propertyName = "disablePopImap";
		
		String propertyValue = ezCommonService.getUserConfigInfo(tenantIdNum, userId, propertyName);
		
		if (!propertyValue.equals("")) {
			returnValue = "SUCCESS";
			model.addAttribute("propertyValue" , propertyValue);
		} else {
			returnValue = "NODATA";
		}
				
		String defaultForDisablePopImap = ezCommonService.getTenantConfig("defaultForDisablePopImap", userInfo.getTenantId());
		
		model.addAttribute("result", returnValue);
		model.addAttribute("defaultForDisablePopImap", defaultForDisablePopImap);
		
		logger.debug("configPop3Imap ended.");
		
		return "admin/ezOrgan/configPopImap";
	}
	
	/**
	 * POP3/IMAP 설정된 값을 추가 및 수정 한다.
	 */
	@RequestMapping(value = "/admin/ezOrgan/setUseDisablePop3Imap.do")
	@ResponseBody
	public String setUseDisablePop3Imap(@CookieValue("loginCookie") String loginCookie
			, HttpServletRequest req) throws Exception	 {
		
		logger.debug("setUseDisablePop3Imap started.");
		
		String returnValue = "ERROR"; 
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		int tenantIdNum = userInfo.getTenantId();
		String userId = req.getParameter("userId");
		String propertyValue = req.getParameter("propertyValue");
		String propertyName = req.getParameter("propertyName");
		
		String getPropertyValue = ezCommonService.getUserConfigInfo(tenantIdNum, userId, propertyName);
		
		if (!getPropertyValue.equals("")) {
			ezCommonService.updateUserConfigInfo(tenantIdNum, userId, propertyName, propertyValue);
			returnValue = "SUCCESS";
		} else {
			ezCommonService.insertUserConfigInfo(tenantIdNum, userId, propertyName, propertyValue);
			returnValue = "SUCCESS";
		}
		
		logger.debug("setUseDisablePop3Imap ended.");
		
		return returnValue;
	}
	
	/**
	 * 조직도 사원 추가, 수정시 직위,직책으로 공용배포그룹 생성 및 수정
	 */
	@RequestMapping(value="/admin/ezOrgan/mailSaveDistributionList.do")
	@ResponseBody
	public String mailSaveDistributionList(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model,  HttpServletRequest request) throws Exception{
		//관리자 권한체크
		LoginVO auth = commonUtil.aprCheckAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		
		String memberId = request.getParameter("cn");
		String jobTile = request.getParameter("jobTitle") == null ? "" : request.getParameter("jobTitle");
		String jobPostion = request.getParameter("jobPosition") == null ? "" : request.getParameter("jobPosition");
		
		logger.debug("mailSaveDistributionList started.");
		logger.debug("memberId=" + memberId + ", jobTile=" + jobTile +  ", jobPosition=" + jobPostion);
		
		int tenantID = auth.getTenantId();
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		String companyId = userInfo.getCompanyID();
		String result = "ERROR";
		
		try {
			
			String userName = "";
			
			if (!jobTile.equals("")) {
				userName = ezOrganAdminService.getDistributionUserName(tenantID, jobTile);
				String jobTile2 = String.valueOf(UUID.randomUUID()).substring(0,8);
				logger.debug("jobTitle UUID=" + jobTile2);
				
				 if (!userName.equals("")) {//직위 이름으로 공용 배포그룹 존재시
					 result = ezOrganAdminService.mailUpdateDistributionList(domain, jobTile, userName, companyId, tenantID, memberId);
				 } else {
					 result = ezOrganAdminService.mailAddDistributionList(domain, jobTile, jobTile2, companyId, tenantID, memberId);
				 }
				 
			}
			
			if (!jobPostion.equals("")) {
				userName = ezOrganAdminService.getDistributionUserName(tenantID, jobPostion);
				String jobPostion2 = String.valueOf(UUID.randomUUID()).substring(0,8);
				logger.debug("jobPostion2 UUID=" + jobPostion2);
				 
				 if (!userName.equals("")) {//직책 이름으로 공용 배포그룹 존재시
					 result = ezOrganAdminService.mailUpdateDistributionList(domain, jobPostion, userName, companyId, tenantID, memberId);
				 } else {
					 result = ezOrganAdminService.mailAddDistributionList(domain, jobPostion, jobPostion2, companyId, tenantID, memberId);
				 }
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("result=" + result);
		logger.debug("mailSaveDistributionList ended.");
		return result;
	}
	
	/**
	 * 회사 추가,수정시 운영자 전자우편 ID 가져오기
	 */
	@RequestMapping(value="/admin/ezOrgan/getComanyConfig.do")
	@ResponseBody
	public String getComanyConfig(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model,  HttpServletRequest request) throws Exception{
		//관리자 권한체크
		LoginVO auth = commonUtil.aprCheckAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		
		String companyID = request.getParameter("cn");
		
		logger.debug("getComanyConfig started.");
		logger.debug("companyID=" + companyID);
		
		int tenantID = auth.getTenantId();
		String operatorMailId = "";
		
		try {
			operatorMailId = ezCommonService.getCompanyConfig(tenantID, companyID, "operatorMailId");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("operatorMailId=" + operatorMailId);
		logger.debug("getComanyConfig ended.");
		return operatorMailId;
	}
	
	private boolean createThumbnail(File sourceFile, File targetFile) {
		boolean result = false;
		
		try {
			BufferedImage sourceImage = ImageIO.read(sourceFile);
			int w = 100;
		    int h = 100;
		    
		    BufferedImage targetImage = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);

		    Graphics2D g2 = targetImage.createGraphics();
		    g2.setClip(new Ellipse2D.Float(0, 0, w, h));
		    g2.drawImage(sourceImage, 0, 0, w, h, null);
		    g2.dispose();
			
			ImageIO.write(targetImage, "png", targetFile);
			
			result = true;
		} catch (Exception e) {
			logger.debug("fail to create thumbnail : " + sourceFile.getName());
			
			try {
				Files.copy(sourceFile.toPath(), targetFile.toPath());
				logger.debug("copy original File to thumbnail.");
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
		
		return result;
	}
	
	private void setInitMailSign(OrganUserVO vo) throws Exception {
		MailSignatureVO mailSignatureVO = ezEmailService.getInitMailSignature(vo.getTenantId());
		
		if (mailSignatureVO != null) {
			OrganUserVO _vo = ezOrganAdminService.getUserInfo(vo.getCn(), "1", vo.getTenantId());
			
			String content1 = mailSignatureVO.getContent1() == null ? "" : mailSignatureVO.getContent1();
			String content2 = mailSignatureVO.getContent2() == null ? "" : mailSignatureVO.getContent2();
			String content3 = mailSignatureVO.getContent3() == null ? "" : mailSignatureVO.getContent3();
			
			content1 = content1.replace("${company}", _vo.getCompany1()).replace("${engCompany}", _vo.getCompany2()).replace("${name}", _vo.getDisplayName1()).replace("${engName}", _vo.getDisplayName2())
					.replace("${department}", _vo.getDescription1()).replace("${engDepartment}", _vo.getDescription2()).replace("${email}", _vo.getMail())
					.replace("${title}", _vo.getTitle1() == null ? "" : _vo.getTitle1()).replace("${engTitle}", _vo.getTitle2() == null ? "" : _vo.getTitle2())
					.replace("${position}", _vo.getExtensionAttribute101() == null ? "" : _vo.getExtensionAttribute101()).replace("${engPosition}", _vo.getExtensionAttribute102() == null ? "" : _vo.getExtensionAttribute102())
					.replace("${officePhone}", _vo.getTelephoneNumber() == null ? "" : _vo.getTelephoneNumber()).replace("${homePhone}", _vo.getHomePhone() == null ? "" : _vo.getHomePhone())
					.replace("${fax}", _vo.getFacsimileTelephoneNumber() == null ? "" : _vo.getFacsimileTelephoneNumber()).replace("${mobile}", _vo.getMobile() == null ? "" : _vo.getMobile())
					.replace("${zipCode}", _vo.getPostalCode() == null ? "" : _vo.getPostalCode()).replace("${address}", _vo.getStreetAddress() == null ? "" : _vo.getStreetAddress());
		
			content2 = content2.replace("${company}", _vo.getCompany1()).replace("${engCompany}", _vo.getCompany2()).replace("${name}", _vo.getDisplayName1()).replace("${engName}", _vo.getDisplayName2())
					.replace("${department}", _vo.getDescription1()).replace("${engDepartment}", _vo.getDescription2()).replace("${email}", _vo.getMail())
					.replace("${title}", _vo.getTitle1() == null ? "" : _vo.getTitle1()).replace("${engTitle}", _vo.getTitle2() == null ? "" : _vo.getTitle2())
					.replace("${position}", _vo.getExtensionAttribute101() == null ? "" : _vo.getExtensionAttribute101()).replace("${engPosition}", _vo.getExtensionAttribute102() == null ? "" : _vo.getExtensionAttribute102())
					.replace("${officePhone}", _vo.getTelephoneNumber() == null ? "" : _vo.getTelephoneNumber()).replace("${homePhone}", _vo.getHomePhone() == null ? "" : _vo.getHomePhone())
					.replace("${fax}", _vo.getFacsimileTelephoneNumber() == null ? "" : _vo.getFacsimileTelephoneNumber()).replace("${mobile}", _vo.getMobile() == null ? "" : _vo.getMobile())
					.replace("${zipCode}", _vo.getPostalCode() == null ? "" : _vo.getPostalCode()).replace("${address}", _vo.getStreetAddress() == null ? "" : _vo.getStreetAddress());
		
			content3 = content3.replace("${company}", _vo.getCompany1()).replace("${engCompany}", _vo.getCompany2()).replace("${name}", _vo.getDisplayName1()).replace("${engName}", _vo.getDisplayName2())
					.replace("${department}", _vo.getDescription1()).replace("${engDepartment}", _vo.getDescription2()).replace("${email}", _vo.getMail())
					.replace("${title}", _vo.getTitle1() == null ? "" : _vo.getTitle1()).replace("${engTitle}", _vo.getTitle2() == null ? "" : _vo.getTitle2())
					.replace("${position}", _vo.getExtensionAttribute101() == null ? "" : _vo.getExtensionAttribute101()).replace("${engPosition}", _vo.getExtensionAttribute102() == null ? "" : _vo.getExtensionAttribute102())
					.replace("${officePhone}", _vo.getTelephoneNumber() == null ? "" : _vo.getTelephoneNumber()).replace("${homePhone}", _vo.getHomePhone() == null ? "" : _vo.getHomePhone())
					.replace("${fax}", _vo.getFacsimileTelephoneNumber() == null ? "" : _vo.getFacsimileTelephoneNumber()).replace("${mobile}", _vo.getMobile() == null ? "" : _vo.getMobile())
					.replace("${zipCode}", _vo.getPostalCode() == null ? "" : _vo.getPostalCode()).replace("${address}", _vo.getStreetAddress() == null ? "" : _vo.getStreetAddress());
			
			ezEmailService.setMailSignature(vo.getTenantId(), _vo.getCn(), mailSignatureVO.getUseFlag(), content1, content2, content3);
			logger.debug("InitMailSign set.");
		}
	}
	
	private void setInitInboxRule(String loginCookie, OrganUserVO vo, Locale locale) throws Exception {
		//자동분류에 등록된 메일함이 존재하지 않으면 메일함을 생성한다.
		List<String> mailboxList = ezEmailService.getInitInboxRuleMailbox(vo.getTenantId());
		String password = commonUtil.getUserIdAndPassword(loginCookie).get(1);
		
		IMAPAccess ia = null;
		
        try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					vo.getMail(), password, egovMessageSource, locale, ezEmailUtil);
			
			for (int i = 0; i < mailboxList.size(); i++) {
				ia.createFolder(mailboxList.get(i));
			}
		} finally {
			if (ia != null) {
				ia.close();
				ia = null;
			}
		}
		
		ezEmailService.setInitInboxRule(vo.getTenantId(), vo.getCn());
		logger.debug("InitInboxRule set.");
	}
	
	private void createDefaultFolders(String loginCookie, String userEmail, Locale locale) throws Exception {
		String password = commonUtil.getUserIdAndPassword(loginCookie).get(1);		
		IMAPAccess ia = null;
		
        try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
						
			// 기본 폴더들이 없을 때 생성한다.
			ia.getTopLevelFolders(true, false);			
		} finally {
			if (ia != null) {
				ia.close();
				ia = null;
			}
		}		
	}
	
}
