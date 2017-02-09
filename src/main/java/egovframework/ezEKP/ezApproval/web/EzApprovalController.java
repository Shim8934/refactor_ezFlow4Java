package egovframework.ezEKP.ezApproval.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApproval.service.EzApprovalAdminService;
import egovframework.ezEKP.ezApproval.service.EzApprovalService;
import egovframework.ezEKP.ezApproval.vo.ApprContInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocInfoVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 사용자 - 전자결재S
 * @author 오픈솔루션팀 황윤진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2017.01.19    황윤진         신규작성
 *
 * @see
 */

@Controller
public class EzApprovalController {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private Properties apprCode;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzApprovalAdminService ezApprovalAdminService;
	
	@Autowired
	private EzApprovalService ezApprovalService;
	
	@Resource(name = "egovMessageSource")
    private EgovMessageSource egovMessageSource;
	
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalController.class);
	
	/**
	 * 전자결재S 메인화면 호출 Method
	 */
	
	@RequestMapping(value = "/ezApproval/apprMain.do")
	public String approvalMain(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("approvalMain started");
		
		String listType = request.getParameter("listType");
		
		if (listType == null) {
			listType = "1";
		}
		
		model.addAttribute("listType", listType);

		logger.debug("approvalMain ended");
		
		return "ezApproval/apprMain";
	}

	/**
	 * 전자결재S LEFT화면 호출 Method
	 */
	@RequestMapping(value = "/ezApproval/apprLeft.do")
	public String apprLeft(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception{
		logger.debug("apprLeft started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String userInfoEnforce = ezCommonService.getTenantConfig("UserInfo_Enforce", userInfo.getTenantId());
		String viewLeftCount = ezCommonService.getTenantConfig("APPROVLEFTCOUNT", userInfo.getTenantId());
		
		logger.debug("userInfoEnforce :: " + userInfoEnforce + " || viewLeftCount :: " + viewLeftCount);
		
		String listType = "";
		String holdAdmin = "";
		String firstContainerID = "";
		String aprListCont = "";
		String rtnListCont = "";
		StringBuilder containers = new StringBuilder();
		String subTitleString = "";
		boolean isSubTitle = false;
		
		if (request.getParameter("listType") != null) {
			listType = request.getParameter("listType");
		} else {
			listType = "1";
		}
		ApprContInfoVO apprContInfoVO = new ApprContInfoVO();
		apprContInfoVO.setMyDeptID(userInfo.getDeptID());
		apprContInfoVO.setUseDeptID(userInfo.getDeptID());
		apprContInfoVO.setOwnFlag("2");
		apprContInfoVO.setTenantID(userInfo.getTenantId());
		apprContInfoVO.setLang(commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		
		List<ApprContInfoVO> apprContInfoVOs = ezApprovalService.getUseContInfo(apprContInfoVO);
		List<ApprDocInfoVO> apprDocInfoVOs = ezApprovalService.getCodeContainer(userInfo);
		
		if (userInfo.getRollInfo().indexOf("c=1") >= 0 || userInfo.getRollInfo().indexOf("k=1") >= 0 || userInfo.getRollInfo().indexOf("g=1") >= 0) {
			holdAdmin = "YES";
		}
			
		if (apprContInfoVOs.size() > 0) {
			firstContainerID = apprContInfoVOs.get(0).getContainerID();
		} 
		
		for (int k = 0; k < apprContInfoVOs.size(); k++) {
			if (k == 0) {
				containers.append("'" + apprContInfoVOs.get(k).getContainerID() + "'");
			} else {
				containers.append(",'" + apprContInfoVOs.get(k).getContainerID() + "'");
			}
		}
		
		//개인 문서함 관련
		String strXML3 = ezApprovalService.getUserContTree(userInfo, "ROOT");
		//결재 대장, 반송 대장 관련한 ContainerID 모음 던져주기
		String strXML4 = ezApprovalService.getListContainer(userInfo);
		//부서 문서함 관련
		String strXML5 = ezApprovalService.getDeptContTree(userInfo, "ROOT");
		
		Document doc = commonUtil.convertStringToDocument(strXML4);
		
		if (doc.getElementsByTagName("APPRCONT").getLength() > 0) {
			aprListCont = doc.getElementsByTagName("APPRCONT").item(0).getTextContent();
		} else {
			aprListCont = "0000000000";
		}
		
		if (doc.getElementsByTagName("RETNCONT").getLength() > 0) {
			rtnListCont = doc.getElementsByTagName("RETNCONT").item(0).getTextContent();
		} else {
			rtnListCont = "0000000000";
		}
		
		List<ApprContInfoVO> apprContInfoVOs2 = ezApprovalService.getSpecialContTree(userInfo);
		
		int subContCount = 0;
		
		for (int k = 0; k < apprContInfoVOs2.size(); k++) {
			if (!apprContInfoVOs2.get(k).getContType().equals("005")) { //심사할 문서만 제외
				subContCount += 1;
			}
		}
		
		List<Object> referenceTemp = new ArrayList<Object>();
		referenceTemp.add(subTitleString);
		referenceTemp.add(isSubTitle);
		
		getUserSubTitle(userInfo, referenceTemp);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("strXML3", strXML3);
		model.addAttribute("strXML5", strXML5);
		model.addAttribute("subContCount", subContCount);
		model.addAttribute("specialContTreeList", apprContInfoVOs2);
		model.addAttribute("specialContTreeCount", apprContInfoVOs2.size());
		model.addAttribute("codeContainerList", apprDocInfoVOs);
		model.addAttribute("useContInfoList", apprContInfoVOs);
		model.addAttribute("firstContainerID", firstContainerID);
		model.addAttribute("containers", containers.toString());
		model.addAttribute("listType", listType);
		model.addAttribute("holdAdmin", holdAdmin);
		model.addAttribute("userInfoEnforce", userInfoEnforce);
		model.addAttribute("viewLeftCount", viewLeftCount);
		model.addAttribute("isSubTitle", isSubTitle);
		model.addAttribute("subTitleString", subTitleString);
		model.addAttribute("aprListCont", aprListCont);
		model.addAttribute("rtnListCont", rtnListCont);
		
		logger.debug("apprLeft ended");
		
		return "ezApproval/apprLeft";
	}
	
	public void getUserSubTitle(LoginVO userInfo, List<Object> referenceTemp) throws Exception{
		logger.debug("getUserSubTitle started");
		
		String propList = "extensionAttribute4;department;description;title;title2;description2";
		String results = ezOrganService.getPropertyList(userInfo.getId(), propList, userInfo.getPrimary(), userInfo.getTenantId());
		String myDept = "";
		String subTitleString = "";
		boolean isSubTitle = false;
		Document doc = commonUtil.convertStringToDocument(results);
		
		String deptInfo = doc.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0).getTextContent();
        String deptID = doc.getElementsByTagName("DEPARTMENT").item(0).getTextContent();
        String deptName = doc.getElementsByTagName("DESCRIPTION1").item(0).getTextContent();
        String title = doc.getElementsByTagName("TITLE1").item(0).getTextContent();
        String deptName2 = doc.getElementsByTagName("DESCRIPTION2").item(0).getTextContent();
        String title2 = doc.getElementsByTagName("TITLE2").item(0).getTextContent();
        
        myDept = userInfo.getPrimary().equals("1") ? deptName : deptName2;
        
        if (userInfo.getDeptID().equals(deptID)) {
        	if (title.equals("")){
        		subTitleString = "<option value='" + deptID + "|" + myDept + "|" + title + "|" + deptName + "|" + deptName2 + "|" + title + "|" + title2 + "'  selected >" + myDept + "</option>";
        	} else {
        		subTitleString = "<option value='" + deptID + "|" + myDept + "|" + title + "|" + deptName + "|" + deptName2 + "|" + title + "|" + title2 + "'  selected >" + myDept + "[" + title + "]" + "</option>";
        	}
        } else {
        	if (title.equals("")){
        		subTitleString = "<option value='" + deptID + "|" + myDept + "|" + title + "|" + deptName + "|" + deptName2 + "|" + title + "|" + title2 + "' >" + myDept + "</option>";
        	} else {
        		subTitleString = "<option value='" + deptID + "|" + myDept + "|" + title + "|" + deptName + "|" + deptName2 + "|" + title + "|" + title2 + "' >" + myDept + "[" + title + "]" + "</option>";
        	}
        }
        
        String lang = "";
        
        if (!userInfo.getPrimary().equals("1")) {
        	lang = "2";
        }
        
        if (!deptInfo.equals("")) {
        	isSubTitle = true;
        	String[] deptList = deptInfo.split(";");
        	
        	for (int k = 0; k < deptList.length; k++) {
        		String[] subList = deptList[k].split(":");
        		String pTitle_ = userInfo.getPrimary().equals("1") ? commonUtil.cleanValue(subList[1]) : commonUtil.cleanValue(subList[2]);
                String pTitle1_ = commonUtil.cleanValue(subList[1]);
                String pTitle2_ = commonUtil.cleanValue(subList[2]);
                String pDeptNM1_ = commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DISPLAYNAME", userInfo.getTenantId()));
                String pDeptNM2_ = commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DISPLAYNAME2", userInfo.getTenantId()));
                String pDeptNM_ = userInfo.getPrimary().equals("1") ? pDeptNM1_ : pDeptNM2_;
                
                if (userInfo.getDeptID().equals(subList[0])) {
                    if (pTitle_.equals("")) {
                    	subTitleString += "<option  value='" + subList[0] + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "'  selected>" + commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DisplayName" + lang, userInfo.getTenantId())) + "</option>";
                    } else {
                    	subTitleString += "<option  value='" + subList[0] + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "'  selected>" + commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DisplayName" + lang, userInfo.getTenantId())) + "[" + pTitle_ + "]" + "</option>";
                    }
                } else {
                    if (pTitle_.equals("")) {
                    	subTitleString += "<option  value='" + subList[0] + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "' >" + commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DisplayName" + lang, userInfo.getTenantId())) + "</option>";
                    } else {
                    	subTitleString += "<option  value='" + subList[0] + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "' >" + commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DisplayName" + lang, userInfo.getTenantId())) + "[" + pTitle_ + "]" + "</option>";
                    }
                }
        	}
        }
        
        referenceTemp.set(0, subTitleString);
        referenceTemp.set(1, isSubTitle);
        
        logger.debug("getUserSubTitle ended");
	}
	
	/**
	 * 전자결재S Left화면 게시글갯수 Method
	 */
	@RequestMapping(value = "/ezApproval/getListCount.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getListCount(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("getListCount started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String listType = request.getParameter("listType");
		String subQuery = request.getParameter("subQuery");
		String mode = request.getParameter("mode");
		String susinAdmin = "user";
		String result = "";
		
		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "admin";
		}
		
		if (mode != null) {
			result = ezApprovalService.getWebPartList(listType, userInfo, "", "LEFT", susinAdmin, subQuery);
		} else {
			result = ezApprovalService.getWebPartList(listType, userInfo, "", "COUNT", susinAdmin, subQuery);
		}

		logger.debug("getListCount ended");
		
		return result;
	}
	
	@RequestMapping(value = "/ezApproval/aprManage.do")
	public String aprManage(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("aprManage started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		Map<String, Object> map = ezCommonService.getTenantConfigs(userInfo.getTenantId());
		
		String viewLeftCount = (String) map.get("APPROVLEFTCOUNT");
		String useEditor = (String) map.get("EDITOR");
		String useOcs = (String) map.get("USE_OCS");
		String useAdditionalRole = (String) map.get("USE_AdditionalROle");
		String useMobile = (String) map.get("Use_Mobile");
		String openYear = (String) map.get("Site_OpenYear");
		String emailDomain = "";
		String userInfoEnforce = (String) map.get("UserInfo_Enforce");
		String susinAdmin = "";
		String listType = request.getParameter("listType");
		String subQuery = request.getParameter("subQuery");
		String tmpValue = request.getParameter("tmpValue");
		String selMenu = "all";
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isIEBrowser = browser.indexOf("IE") > -1 ? true : false;
		
		if (useOcs.equals("YES")) {
			String userEmail = userInfo.getEmail();
			String[] tempEmailDomain = userEmail.split("@");
			
			emailDomain = tempEmailDomain[1];
		}
		
		if (userInfo.getRollInfo().indexOf("a=1") > -1) {
			susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		
		if (listType == null) {
			listType = "1";
		}
		
		String result = ezOrganService.getPropertyList(userInfo.getId(), "extensionAttribute4;extensionAttribute5", userInfo.getPrimary(), userInfo.getTenantId());
		Document docXML = commonUtil.convertStringToDocument(result);
		
		String deptInfo = docXML.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0).getTextContent();
		String bujaeInfo = docXML.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent();
		String nowDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm"), userInfo.getOffset(), false);
		
		if (bujaeInfo != null && !bujaeInfo.equals("")) {
			if (bujaeInfo.split(":").length >= 5) {
				//TODO: 아이체크 바람
				bujaeInfo = bujaeInfo.split(":")[0] + ":" + bujaeInfo.split(":")[1] + ":" + bujaeInfo.split(":")[2] + ":" + commonUtil.getDateStringInUTC(bujaeInfo.split(":")[3].replace("/", ":"), userInfo.getOffset(), false) + ":" + commonUtil.getDateStringInUTC(bujaeInfo.split(":")[4].replace("/", ":"), userInfo.getOffset(), false);
			}
		}
		
		model.addAttribute("isIEBrowser", isIEBrowser);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("bujaeInfo", bujaeInfo);
		model.addAttribute("listType", listType);
		model.addAttribute("selMenu", selMenu);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("subQuery", subQuery);
		model.addAttribute("deptInfo", deptInfo);
		model.addAttribute("useAdditionalRole", useAdditionalRole);
		model.addAttribute("viewLeftCount", viewLeftCount);
		model.addAttribute("openYear", openYear);
		model.addAttribute("nowDate", nowDate);
		model.addAttribute("useMobile", useMobile);
		model.addAttribute("userInfoEnforce", userInfoEnforce);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("emailDomain", emailDomain);
		model.addAttribute("tmpValue", tmpValue);

		logger.debug("aprManage ended");
		
		return "ezApproval/apprAprManage";
	}
}
