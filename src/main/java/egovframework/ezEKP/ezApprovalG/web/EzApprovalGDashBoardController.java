package egovframework.ezEKP.ezApprovalG.web;

import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganProxyVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Pattern;

@Controller
public class EzApprovalGDashBoardController extends EzFileMngUtil {
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalGDashBoardController.class);

	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;

	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	// 2025-07-22 황인경 - 전자결재 대시보드 메인화면 호출
	@RequestMapping(value = "/ezApprovalG/apprGDashBoardMain.do", method=RequestMethod.GET)
	public String apprGDashBoardMain(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp, Locale local) throws Exception {
		logger.debug("apprGDashBoardMain Start");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		String viewLeftCount = ezCommonService.getTenantConfig("APPROVLEFTCOUNT", userInfo.getTenantId());
		String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String draftAllTypeB = ezCommonService.getTenantConfig("draftAllTypeB", userInfo.getTenantId());
		String userLang = userInfo.getLang();
		String susinAdmin = "";
		if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		String buJaeInfo = "";
		String result = ezOrganService.getPropertyList(userInfo.getId(), "extensionAttribute4;extensionAttribute5", userInfo.getPrimary(), userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(result);
		String userRealDeptId = ezOrganService.getUserOrgDeptId(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		List<OrganUserVO> orgUserInfolist = ezOrganService.getOrgUserInfo(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		String userGetTitle = userInfo.getTitle() != null ? userInfo.getTitle() : "";
		String userRealTitle = orgUserInfolist.get(0).getTitle() != null ? orgUserInfolist.get(0).getTitle() : "";
		String userRealTitle2 = orgUserInfolist.get(0).getTitle() != null ? orgUserInfolist.get(0).getTitle2() : "";
		String nowDate = EgovDateUtil.convertDate(org.egovframe.rte.fdl.string.EgovDateUtil.getCurrentDateTimeAsString(), "", "", "");
		
		OrganProxyVO proxyInfo = ezOrganService.getProxyInfo(userInfo.getId(), userInfo.getTenantId(), userInfo.getOffset());
		
		if (userInfo.getDeptID().equals(userRealDeptId) && userGetTitle.equals(userRealTitle) && !userLang.equals("2")) {
			buJaeInfo = doc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent();
		} else if (userInfo.getDeptID().equals(userRealDeptId) && userGetTitle.equals(userRealTitle2) && (userLang.equals("2") || userLang.equals("3") || userLang.equals("6"))) {
			buJaeInfo = doc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent();
		} else {
			buJaeInfo = ezOrganService.getAddJobProxy(userInfo.getId(), userInfo.getDeptID(), userInfo.getTitle(), userInfo.getTenantId());
		}
		
		resp.setHeader("Pragma", "no-cache"); 
		resp.setHeader("Cache-Control", "no-cache");  
		resp.setHeader("Cache-Control", "no-store");  
		resp.setDateHeader("Expires", 0L);
		
		model.addAttribute("userId", userId);
		model.addAttribute("buJaeInfo", buJaeInfo);
		model.addAttribute("userLang", userInfo.getPrimary());
		model.addAttribute("userLang2", userInfo.getLang());
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("now", commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), "235|+09:00", false));
		model.addAttribute("nowDateUTC", commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));
		model.addAttribute("nowDate", nowDate);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		model.addAttribute("proxyInfo", proxyInfo);
		model.addAttribute("susinAdmin", susinAdmin);
		
		String  switchUserCompany = "";
		if (ezCommonService.getTenantConfig("switchUserCompany", userInfo.getTenantId()) != null){
			switchUserCompany = ezCommonService.getTenantConfig("switchUserCompany", userInfo.getTenantId());
			model.addAttribute("switchUserCompany", switchUserCompany);
		}
		
		boolean checkBrowser;
		if (req.getHeader("User-Agent").indexOf("Trident") > 0 || req.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
			checkBrowser = true;
		} else {
			checkBrowser = false;
		}

		model.addAttribute("checkBrowser", checkBrowser);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		model.addAttribute("companyID", companyId);
		model.addAttribute("viewLeftCount", viewLeftCount);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("draftAllTypeB", draftAllTypeB);
		
		
		logger.debug("apprGDashBoardMain End");
		return "/ezApprovalG/apprGDashBoardMain";
	}
	
	// 2025-07-22 황인경 - 부서수신함 목록
	@RequestMapping(value = "/ezApprovalG/getDeptBoxList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getDeptBoxList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("getDeptBoxList started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String deptID = request.getParameter("deptID");
		String receiveDocMode = request.getParameter("mFlag");
		String pageSize = request.getParameter("pageSize");
		String pageNum = request.getParameter("pageNum");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String searchQuery = request.getParameter("searchQuery");
		String searchStatus = request.getParameter("searchStatus");
		String assignChk = request.getParameter("assignChk");
		String userLang = userInfo.getLang();
		Document xmlDomSub = null;
		
		Map<String, Object> searchQueryMap = new HashMap<String, Object>();
		
		if (searchQuery != null && searchQuery.length() > 10) {
			String tempQuery = "";
			xmlDomSub = commonUtil.convertStringToDocument(searchQuery);
			
			tempQuery = xmlDomSub.getElementsByTagName("ROOT").item(0).getChildNodes().item(0).getTextContent();
			
			
            if (tempQuery.indexOf("APRSTARTDATE;") != -1) { // 간단검색 시 사용
            	searchQueryMap.put("col_where_PROCESSDATE_START1", commonUtil.getDateStringInUTC(xmlDomSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent() + " 00:00:01", userInfo.getOffset(), true));
            }
            
            if (tempQuery.indexOf("APRENDDATE;") != -1) {
            	searchQueryMap.put("col_where_PROCESSDATE_END1", commonUtil.getDateStringInUTC(xmlDomSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59", userInfo.getOffset(), true));
            }
            
		}
		
		String result = ezApprovalGService.getDeptBoxList(userID, deptID, receiveDocMode, pageSize, pageNum, orderCell, orderOption, userInfo.getCompanyID(), userLang, searchQueryMap, userInfo.getTenantId(), userInfo.getOffset(), assignChk, userInfo.getPrimary());
		
		logger.debug("getDeptBoxList ended.");
		
		return result;
	}
	
	// 2025-07-22 황인경 - 지연문서, 진행중문서
	@RequestMapping(value = "/ezApprovalG/getDashBoardDocList.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getDashBoardDocList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception {
		logger.debug("getDashBoardDocList started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String listType = request.getParameter("listType");
		String userID = request.getParameter("userID");
		String deptID = request.getParameter("deptID");
		String pageSize = request.getParameter("pageSize");
		String pageNum = request.getParameter("pageNum");
		String companyID = request.getParameter("companyID");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String searchQuery = request.getParameter("searchQuery");
		String searchCompanyID = request.getParameter("searchCompanyID");
		String searchStatus = request.getParameter("searchStatus");

		logger.debug("listType = " + listType + " || userID = " + userID + " || deptID(AddJob) = " + deptID);
		
        if (userID == null) {
            logger.debug("--> userID is null");
            return "";
        }
        if (deptID == null) {
            logger.debug("--> deptID is null");
            return "";
        }
        if (companyID == null) {
            logger.debug("--> companyID is null");
            return "";
        }
		
		if (!commonUtil.isIntNumber(pageSize)) {
		    logger.debug("pageSize is not int value");
		    return "";
		}
		if (!commonUtil.isIntNumber(pageNum)) {
		    logger.debug("pageNum is not int value");
		    return "";
		}
		
 		String userLang = userInfo.getLang();
		String userPrimeLang = userInfo.getPrimary();
		Document domSub = null;
		
		if (pageNum.equals("0")) {
			pageNum = "1";
		}
		
		Map<String, Object> searchMap = new HashMap<>();
		if (searchQuery != null && searchQuery.length() > 10) {
			String tempQuery = "";
			domSub = commonUtil.convertStringToDocument(searchQuery);
			tempQuery = domSub.getElementsByTagName("ROOT").item(0).getChildNodes().item(0).getTextContent();
			
            String dateReg = "^[0-9]{4}-[0-9]{2}-[0-9]{2}$";
            if (tempQuery.indexOf("APRSTARTDATE;") != -1) {
            	String aprStartDate = domSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent();
            	
                String tempMonth = aprStartDate.split("-")[1];
                String tempDay = aprStartDate.split("-")[2];
                
                if (tempMonth.length() < 2 && tempDay.length() < 2) {
                	tempMonth = "0" + tempMonth;
                	tempDay = "0" + tempDay;
                	aprStartDate = aprStartDate.substring(0,5) + tempMonth + "-" + tempDay;
                }
                
                if (!Pattern.matches(dateReg, aprStartDate)) {
                    return "";
                }
                
                searchMap.put("APRSTARTDATE", commonUtil.getDateStringInUTC(domSub.getElementsByTagName("APRSTARTDATE").item(0).getTextContent() + " 00:00:01", userInfo.getOffset(), true));
				searchMap.put("aprStartDateSearch", "4"); 
            }
            
            if (tempQuery.indexOf("APRENDDATE;") != -1) {
                String aprEndDate = domSub.getElementsByTagName("APRENDDATE").item(0).getTextContent();
                
                if (!Pattern.matches(dateReg, aprEndDate)) {
                    return "";
                }
                
                searchMap.put("APRENDDATE", commonUtil.getDateStringInUTC(domSub.getElementsByTagName("APRENDDATE").item(0).getTextContent() + " 23:59:59", userInfo.getOffset(), true));
				searchMap.put("aprEndDateSearch", "4");
            }
		}
		
		if (searchCompanyID != null && !searchCompanyID.equals("")) {
			searchMap.put("companyIdSeach", "2");
			searchMap.put("searchCompanyID", searchCompanyID);
		}
		
		searchMap.put("searchStatus", searchStatus);
		
		String resultXML = ezApprovalGService.aprDashBoardDocList(listType, userID, deptID, pageSize, pageNum, orderCell, orderOption, companyID, userLang, searchQuery, domSub, userInfo.getTenantId(), userInfo.getOffset(), searchMap, userPrimeLang);	
		
		logger.debug("getDashBoardDocList ended.");
		return resultXML;
	}
}