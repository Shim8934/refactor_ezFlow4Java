package egovframework.ezEKP.ezApprovalG.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 관리자 - 전자결재G
 * @author 오픈솔루션팀 장진혁
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.05.04    장진혁         신규작성
 *
 * @see
 */

@Controller
public class EzApprovalGAdminController {
	
	@Autowired	
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzApprovalGAdminService ezApprovalGAdminService;
	
	@Autowired
	private EgovMessageSource egovMessageSource;
	
	/**
	 * 전자결재G관리 메인화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMain.do")
	public String apprGMain() throws Exception{		
		return "/admin/ezApprovalG/apprGMain";
	}
	
	/**
	 * 전자결재G관리 왼쪽화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGLeft.do")
	public String apprGLeft() throws Exception{		
		return "/admin/ezApprovalG/apprGLeft";
	}
	
	/**
	 * 전자결재G관리 문서함관리 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMCont.do")
	public String apprMCont(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		LoginVO user = commonUtil.userInfo(loginCookie);		
		//관리자 권한 체크
		if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
				
		String lang = config.getProperty("config.primary");
		String serverName = config.getProperty("config.ServerName");
				
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(lang);
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (user.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(user.getCompanyID())) {
				resultList.add(j, vo);
			}
		}
		
		model.addAttribute("companyID", user.getCompanyID());
		model.addAttribute("serverName", serverName);
		model.addAttribute("list", resultList);
		
		return "/admin/ezApprovalG/apprGMCont";
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함데이터 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMgetContInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String apprMgetContInfo(HttpServletRequest request) throws Exception{
		String deptID = request.getParameter("deptID");
		String companyID = request.getParameter("comID");
		String lang = config.getProperty("config.primary");

		String result = ezApprovalGAdminService.getContainerInfoManage(deptID, "LIST", companyID, lang);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함명관리 팝업 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMContType.do")
	public String apprMContType(Model model) throws Exception{
		String lang = config.getProperty("config.primary");
		String primary = config.getProperty("config.lang_Primary" + lang);
		String secondary = config.getProperty("config.lang_Secondary" + lang);
		
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		
		return "admin/ezApprovalG/apprGMContType";
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함명관리 팝업 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMLgetDoctype.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String apprGMLgetDoctype(HttpServletRequest request) throws Exception{
		String companyID = request.getParameter("comID");
		String lang = config.getProperty("config.primary");
		
		String result = ezApprovalGAdminService.getContTypeInfo("LIST", companyID, lang);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함타입 등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGInsertContType.do")	
	public void apprGInsertContType(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String docTypeName = request.getParameter("docTypeName");
		String docTypeName2 = request.getParameter("docTypeName2");
		String companyID = request.getParameter("comID");
		
		ezApprovalGAdminService.insertContainerType(docTypeName, docTypeName2, companyID);
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함타입 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGDeleteContType.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String apprGDeleteContType(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String docTypeID = request.getParameter("docTypeID");
		String companyID = request.getParameter("comID");
		
		String result = ezApprovalGAdminService.deleteContainerType(docTypeID, companyID);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서상태등록 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMinsContType.do")
	public String apprGMinsContType(HttpServletRequest request, HttpServletResponse response) throws Exception{		
		return "admin/ezApprovalG/apprGMinsContType";
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서상태등록 등록된 문서함상태 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGGetContDocType.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String apprGGetContDocType(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String companyID = request.getParameter("comID");
		String lang = config.getProperty("config.primary");
		
		String result = ezApprovalGAdminService.getContainerToDocStateInfo(companyID, lang);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서상태등록 문서함상태 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGUpdateContDoctype.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String apprUpdateContDoctype(@RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception{
		Document doc = commonUtil.convertStringToDocument(data);		
		String companyID = doc.getElementsByTagName("COMPANYID").item(0).getTextContent();
		
		String result = ezApprovalGAdminService.updateContainerToDocStateInfo(doc, companyID);

		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함 추가/수정 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMinsContMain.do")
	public String apprMinsContMain(HttpServletRequest request, HttpServletResponse response, Locale locale, Model model) throws Exception{
		String tCheck = request.getParameter("tCheck");
		String serverName = config.getProperty("config.ServerName");
		String title = "";
		
		if (tCheck != null) {
			if (tCheck.equals("DContIns")) {
				title = egovMessageSource.getMessage("ezApprovalG.t1651", locale);
			} else {
				title = egovMessageSource.getMessage("ezApprovalG.t1652", locale);
			}
		}
		
		model.addAttribute("title", title);
		model.addAttribute("serverName", serverName);
		
		return "admin/ezApprovalG/apprGMinsContMain";
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함 추가/수정 팝업 공유부서 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMgetContGroup.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String apprGMgetContGroup(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String contID = request.getParameter("contID");
		String companyID = request.getParameter("comID");
		String lang = config.getProperty("config.primary");
		
		String result = ezApprovalGAdminService.getContainerUseDeptInfo(contID, companyID, lang);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함 추가 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMinsCont.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String apprGMinsCont(@RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception{
		Document doc = commonUtil.convertStringToDocument(data);
		String companyID = doc.getDocumentElement().getChildNodes().item(doc.getDocumentElement().getChildNodes().getLength() - 1).getTextContent();
		
		String result = ezApprovalGAdminService.insertContainer(doc, companyID);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함 수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMupdateCont.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String apprGMupdateCont(@RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception{
		Document doc = commonUtil.convertStringToDocument(data);
		String companyID = doc.getDocumentElement().getChildNodes().item(doc.getDocumentElement().getChildNodes().getLength() - 1).getTextContent();
		
		String result = ezApprovalGAdminService.updateContainer(doc, companyID);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 문서함관리 문서함 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMdelCont.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String apprGMdelCont(HttpServletRequest request, HttpServletResponse response) throws Exception{		
		String contID = request.getParameter("contID");
		String companyID = request.getParameter("comID");
				
		String result = ezApprovalGAdminService.deleteContainer(contID, companyID);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 수신처 그룹지정 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGReceiveGroup.do")	
	public String apprGReceiveGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{		
		LoginVO user = commonUtil.userInfo(loginCookie);
		String lang = config.getProperty("config.primary");
		String serverName = config.getProperty("config.ServerName");
		String topID = "";
		
		//관리자 권한 체크
		if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		if (user.getRollInfo().indexOf("c=1") == -1) {
			topID = user.getCompanyID();
		} else {
			topID = "Top";
		}
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(lang);
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (user.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(user.getCompanyID())) {
				resultList.add(j, vo);
			}
		}
		model.addAttribute("companyID", user.getCompanyID());
		model.addAttribute("serverName", serverName);
		model.addAttribute("topID", topID);
		model.addAttribute("list", resultList);
		
		return "admin/ezApprovalG/apprGReceiveGroup";
	}
	
	/**
	 * 전자결재G관리 수신처 그룹지정 등록된 그룹데이터 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getAdminReceivGroup.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getAdminReceivGroup(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, HttpServletResponse response) throws Exception{
		LoginVO user = commonUtil.userInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);
		
		String lang = config.getProperty("config.primary");
		String pid = doc.getDocumentElement().getChildNodes().item(0).getTextContent();
		String pmode = doc.getDocumentElement().getChildNodes().item(1).getTextContent();
		String pcompanyID = user.getCompanyID();
				
		if (doc.getDocumentElement().getChildNodes().getLength() > 2) {
			pcompanyID = doc.getDocumentElement().getChildNodes().item(2).getTextContent();
		}
		
		String result = ezApprovalGAdminService.getReceiveGroupInfo(pid, pmode, pcompanyID, lang);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 수신처 그룹지정 수신자그룹 부서등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setGroupSubItemInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String setGroupSubItemInfo(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String groupID = request.getParameter("node1");
		String deptID = request.getParameter("node2");
		String deptName = request.getParameter("node3");
		String companyID = request.getParameter("node4");
		String pCompanyID = request.getParameter("node5");
		String deptName2 = request.getParameter("node6");
		
		String result = ezApprovalGAdminService.insertReceiveGroupItemInfo(groupID, deptID, deptName, deptName2, pCompanyID, companyID);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 수신처 그룹지정 수신자그룹 부서삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/deleteGroupSubiteminfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String deleteGroupSubiteminfo(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String groupID = request.getParameter("node1");
		String companyID = request.getParameter("node2");
				
		String result = ezApprovalGAdminService.deleteReceiveGroupItemInfo(groupID, companyID);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 수신처 그룹지정 수신자그룹 수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/updateGroupMainInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String updateGroupMainInfo(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String groupID = request.getParameter("node1");
		String groupName = request.getParameter("node2");
		String companyID = request.getParameter("node3");
		
		String result = ezApprovalGAdminService.updateReceiveGroupInfo(groupID, groupName, companyID);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 수신처 그룹지정 수신자그룹 추가 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setGroupMainInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String setGroupMainInfo(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String groupName = request.getParameter("node1");
		String companyID = request.getParameter("node2");
		
		String result = ezApprovalGAdminService.insertReceiveGroupInfo(groupName, companyID);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 수신처 그룹지정 수신자그룹 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/deleteGroupMainInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String deleteGroupMainInfo(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String groupID = request.getParameter("node1");
		String companyID = request.getParameter("node2");
		
		String result = ezApprovalGAdminService.deleteReceiveGroupInfo(groupID, companyID);
		
		return result;
	}

}
