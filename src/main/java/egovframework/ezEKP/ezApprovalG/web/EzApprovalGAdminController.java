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
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGAdminService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/** 
 * @Description [Controller] 관리자 - 전자결재G
 * @author 오픈솔루션팀 장진혁
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.05.04    장진혁         신규작성
 *	  2016.07.13	이효진		추가작성
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
	
	//장진혁과장 작성 이후 이효진사원 추가
	
	/**
	 * 전자결재G관리 분류,단위업무관리 메뉴 호출 함수 
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGTaskCodeManage.do")
	public String apprGTaskCodeManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getLang());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(vo);
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList);
		
		return "admin/ezApprovalG/apprGTaskCodeManage";
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 분류목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskCategoryTree.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getTaskCategoryTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		String categoryType = request.getParameter("categoryType");
		String parentID = request.getParameter("parentID");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskCategoryTree(categoryType, parentID, companyID);

		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 분류목록에따른 단위업무 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskInSubCategoryForManage.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getTaskInSubCategoryForManage(@RequestBody String data) throws Exception {
		Document doc = commonUtil.convertStringToDocument(data);
		
		String result = ezApprovalGAdminService.getTaskInSubCategoryForManage(doc);

		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 분류추가,분류수정 메뉴 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/taskCategoryInsert.do")
	public String taskCategoryInsert(Locale locale, HttpServletRequest request, Model model) {
		String tCheck = request.getParameter("tCheck");
		String title = "";
		
		if (tCheck.equals("ins")) {
			title = egovMessageSource.getMessage("ezApprovalG.t734",locale);
		} else {
			title = egovMessageSource.getMessage("ezApprovalG.t735",locale);
		}
		model.addAttribute("title", title);
		
		return "admin/ezApprovalG/apprGTaskCategoryInsert";
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 분류추가  중복확인 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskCategoryDuplicate.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getTaskCategoryDuplicate(HttpServletRequest request) throws Exception {
		String categoryType = request.getParameter("cateType");
		String categoryCode = request.getParameter("sCateCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskCategoryDuplicate(categoryType, categoryCode, companyID);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 분류추가 분류선택 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/selectTaskCategory.do")
	public String selectTaskCategory() {
		return "admin/ezApprovalG/apprGSelectTaskCategory";
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 분류추가,분류수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setTaskCategory.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String setTaskCategory(HttpServletRequest request) throws Exception {
		String categoryType = request.getParameter("categoryType");
		String categoryCode = request.getParameter("categoryCode");
		String categoryName = request.getParameter("categoryName");
		String categoryName2 = request.getParameter("categoryName2");
		String categoryDesc = request.getParameter("categoryDesc");
		String pCode = request.getParameter("pCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.setTaskCategory(categoryType, categoryCode, categoryName, categoryName2, categoryDesc, pCode, companyID);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 분류삭제 시 하위노드 여부 체크 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskCategoryNodeExist.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getTaskCategoryNodeExist(HttpServletRequest request) throws Exception {
		String categoryType = request.getParameter("cateType");
		String categoryCode = request.getParameter("sCateCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskCategoryNodeExist(categoryType, categoryCode, companyID);

		return result;
	}

	/**
	 * 전자결재G관리 분류,단위업무관리 분류삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/removeTaskCategory.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String removeTaskCategory(HttpServletRequest request) throws Exception {
		String categoryType = request.getParameter("cateType");
		String categoryCode = request.getParameter("cateCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.removeTaskCategory(categoryType, categoryCode, companyID);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 코드추가,수정 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/taskCodeInsert.do")
	public String taskCodeInsert(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String tCheck = request.getParameter("tCheck");
		String title = "";
		
		if (tCheck.equals("ins")) {
			title = egovMessageSource.getMessage("ezApprovalG.t763",locale);
		} else {
			title = egovMessageSource.getMessage("ezApprovalG.t764",locale);
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("title", title);
		
		return "admin/ezApprovalG/apprGTaskCodeInsert";
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 코드추가 단위업무코드 중복확인 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskCodeDuplicate.do", produces = "text/html; charset=utf-8")
	@ResponseBody
	public String getTaskCodeDuplicate(HttpServletRequest request) throws Exception {
		String taskCode = request.getParameter("sCateCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskCodeDuplicate(taskCode, companyID);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 코드수정 단위업무정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskInfo.do", produces = "text/html; charset=utf-8")
	@ResponseBody
	public String getTaskInfo(HttpServletRequest request) throws Exception {
		String pTaskCode = request.getParameter("taskCode");
		String pDeptCode = request.getParameter("deptCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskInfo(pTaskCode, pDeptCode, companyID);

		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 코드추가,수정 실행함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/setTaskCode.do")
	@ResponseBody
	public String setTaskCode (ApprGTaskVO vo, HttpServletRequest request) throws Exception {
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.setTaskCode(vo, companyID);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 단위업무의 소속 기록물철 여부 체크 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskCodeNodeExist.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getTaskCodeNodeExist(HttpServletRequest request) throws Exception {
		String taskCode = request.getParameter("taskCode");
		String deptID = request.getParameter("deptID");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskCodeNodeExist(taskCode, deptID, companyID);
		
		return result;
	}
	
	/**
	 * 전자결재G관리분류,단위업무관리  코드삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/removeTaskCode.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String removeTaskCode(HttpServletRequest request) throws Exception {
		String taskCode = request.getParameter("taskCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.removeTaskCode(taskCode, companyID);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 사용부서 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/taskDeptInfoManage.do")
	public String taskDeptInfoManage() {
		return "admin/ezApprovalG/apprGTaskDeptInfoManage";
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 사용부서 부서에 포함된 단위업무목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getTaskCodeDeptInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String getTaskCodeDeptInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String taskCode = request.getParameter("taskCode");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.getTaskCodeDeptInfo(taskCode, companyID, userInfo.getLang());
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 사용부서 부서추가 실행함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/addTaskCodeDeptInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String addTaskCodeDeptInfo(HttpServletRequest request) throws Exception {
		String taskCode = request.getParameter("taskCode");
		String deptCode = request.getParameter("deptID");
		String deptName = request.getParameter("deptName");
		String deptName2 = request.getParameter("deptName2");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.addTaskCodeDeptInfo(taskCode, deptCode, deptName, deptName2, companyID);
		
		return result;
	}
	
	/**
	 * 전자결재G관리 분류,단위업무관리 사용부서 부서삭제 실행함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/removeTaskCodeDeptInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String removeTaskCodeDeptInfo(HttpServletRequest request) throws Exception {
		String taskCode = request.getParameter("taskCode");
		String deptCode = request.getParameter("deptID");
		String deptName = request.getParameter("deptName");
		String deptName2 = request.getParameter("deptName2");
		String companyID = request.getParameter("companyID");
		
		String result = ezApprovalGAdminService.removeTaskCodeDeptInfo(taskCode, deptCode, deptName, deptName2, companyID);
		
		return result;
	}
	
	@RequestMapping(value = "/admin/ezApprovalG/viewTaskInfo.do")
	public String viewTaskInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		return "admin/ezApprovalG/apprGViewTaskInfo";
	}
}
