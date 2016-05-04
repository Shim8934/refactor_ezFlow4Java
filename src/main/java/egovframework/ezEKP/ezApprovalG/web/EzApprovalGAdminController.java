package egovframework.ezEKP.ezApprovalG.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

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
	
	/**
	 * 전자결재G 관리 메인화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMain.do")
	public String apprGMain(HttpServletRequest request, Model model) throws Exception{		
		return "/admin/ezApprovalG/apprGMain";
	}
	
	/**
	 * 전자결재G 관리 왼쪽화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGLeft.do")
	public String apprGLeft(HttpServletRequest request, Model model) throws Exception{		
		return "/admin/ezApprovalG/apprGLeft";
	}
	
	/**
	 * 전자결재G 관리 문서함관리 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/apprGMCont.do")
	public String apprMCont(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
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
	 * 전자결재G 관리 문서함관리 문서함데이터 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/mgetContInfo.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String mgetContInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		String deptID = request.getParameter("deptID");
		String companyID = request.getParameter("comID");

		//2016-05-04 여기서부터 계발
		return "/admin/ezApprovalG/apprGMCont";
	}

}
