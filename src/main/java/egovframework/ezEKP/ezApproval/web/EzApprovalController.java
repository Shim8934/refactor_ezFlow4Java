package egovframework.ezEKP.ezApproval.web;

import java.util.ArrayList;
import java.util.List;
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
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApproval.service.EzApprovalAdminService;
import egovframework.ezEKP.ezApproval.vo.ApprContInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocInfoVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzApprovalController {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzApprovalAdminService ezApprovalAdminService;
	
	@Resource(name = "egovMessageSource")
    private EgovMessageSource egovMessageSource;
	
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalController.class);

	@RequestMapping(value = "/ezApproval/apprLeft.do")
	public String apprLeft(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception{
		logger.debug("apprLeft started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String userInfoEnforce = ezCommonService.getTenantConfig("UserInfo_Enforce", userInfo.getTenantId());
		String viewLeftCount = ezCommonService.getTenantConfig("APPROVLEFTCOUNT", userInfo.getTenantId());
		String listType = "";
		String holdAdmin = "";
		String firstContainerID = "";
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
		apprContInfoVO.setLang(userInfo.getLang());
		
		List<ApprContInfoVO> apprContInfoVOs = ezApprovalAdminService.getUseContInfo(apprContInfoVO);
		List<ApprDocInfoVO> apprDocInfoVOs = ezApprovalAdminService.getCodeContainer(userInfo);
		
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
		String strXML3 = ezApprovalAdminService.getUserContTree(userInfo, "ROOT");
		//결재 대장, 반송 대장 관련한 ContainerID 모음 던져주기
		String strXML4 = ezApprovalAdminService.getListContainer(userInfo);
		//부서 문서함 관련
		String strXML5 = ezApprovalAdminService.getDeptContTree(userInfo, "ROOT");
		
		List<ApprContInfoVO> apprContInfoVOs2 = ezApprovalAdminService.getSpecialContTree(userInfo);
		
		List<Object> referenceTemp = new ArrayList<Object>();
		referenceTemp.add(subTitleString);
		referenceTemp.add(isSubTitle);
		
		getUserSubTitle(userInfo, referenceTemp);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("strXML3", strXML3);
		model.addAttribute("strXML5", strXML5);
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
		
		logger.debug("apprLeft ended");
		
		return "admin/ezApproval/apprLeft";
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
                String pDeptNM1_ = commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DISPLAYNAME"));
                String pDeptNM2_ = commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DISPLAYNAME2"));
                String pDeptNM_ = userInfo.getPrimary().equals("1") ? pDeptNM1_ : pDeptNM2_;
                
                if (userInfo.getDeptID().equals(subList[0])) {
                    if (pTitle_.equals("")) {
                    	subTitleString += "<option  value='" + subList[0] + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "'  selected>" + commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DisplayName" + lang)) + "</option>";
                    } else {
                    	subTitleString += "<option  value='" + subList[0] + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "'  selected>" + commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DisplayName" + lang)) + "[" + pTitle_ + "]" + "</option>";
                    }
                } else {
                    if (pTitle_.equals("")) {
                    	subTitleString += "<option  value='" + subList[0] + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "' >" + commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DisplayName" + lang)) + "</option>";
                    } else {
                    	subTitleString += "<option  value='" + subList[0] + "|" + pDeptNM_ + "|" + pTitle_ + "|" + pDeptNM1_ + "|" + pDeptNM2_ + "|" + pTitle1_ + "|" + pTitle2_ + "' >" + commonUtil.cleanValue(ezOrganService.getPropertyValue(subList[0], "DisplayName" + lang)) + "[" + pTitle_ + "]" + "</option>";
                    }
                }
        	}
        }
        
        referenceTemp.set(0, subTitleString);
        referenceTemp.set(1, isSubTitle);
        
        logger.debug("getUserSubTitle ended");
	}
}
