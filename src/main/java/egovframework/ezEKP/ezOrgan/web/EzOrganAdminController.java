package egovframework.ezEKP.ezOrgan.web;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

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
public class EzOrganAdminController {
	
	@Autowired	
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	
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
		if(user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1){
			return "cmm/error/adminDenied";
		}
		
		String topid = "";
		
		if(user.getRollInfo().indexOf("c=1") == -1){
			topid = user.getCompanyID();
		}else{
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

		if(cnt > 0){
			result = "PRE";
		}else{
			String mailAddr = cn + "@" + domain;
			ezOrganAdminService.insertDBData_company(cn, displayName, displayName2, mailAddr, parentCn, ldapPath);
			
			result = "OK";
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
		
		if(cnt > 0){
			result = "HASCHILD";
		}else{			
			ezOrganAdminService.deleteDBData(cn, pClass);			
			result = "OK";
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

		if(vo.getParentCn() == null){
			ezOrganAdminService.updateDBData_dept(vo);
		}else{
			String cn = vo.getCn();
			int cnt = ezOrganAdminService.companyCheck(cn);
			
			if(cnt > 0){
				result = "PRE";
			}else{							
				String mailAddr = cn + "@" + domain;
				vo.setMail(mailAddr);
				
				ezOrganAdminService.insertDBData_dept(vo);
				
				result = "OK";
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
		
		if(companyID == null || companyID.equals("")){
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
		String cn = request.getParameter("cn");		
		String[] cnDatas = cn.split(",");
		String result = "";
		
		for(int i=0; i<cnDatas.length; i++){
			ezOrganAdminService.updateProperty(cnDatas[i], "EXTENSIONATTRIBUTE15", i+"", "dept");	
		}
		
		return result;
	}
	
	/**
	 * 조직도관리 사원정보 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/userInfo.do")	
	public String userInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{
		boolean auth = commonUtil.checkAdmin(loginCookie);
		
		if(!auth){
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
	
}
