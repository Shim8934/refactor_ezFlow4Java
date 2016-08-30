package egovframework.ezEKP.ezPersonal.web;

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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalAdminService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 관리자 - 초기화면
 * @author 오픈솔루션팀 이효진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.08.30    이효진         신규작성
 * @see
 */

@Controller("EzPersonalAdminController")
public class EzPersonalAdminController {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EgovFileScrty egovFileScrty;
	
	@Autowired
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzPersonalAdminService ezPersonalAdminService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;

	
	/**
	 * 초기화면 메인화면 호출 함수
	 */
	@RequestMapping("/admin/ezPersonal/personalMain.do")
	public String personalMain () throws Exception {
		return "admin/ezPersonal/personalMain";
	}
	
	/**
	 * 초기화면 왼쪽메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/personalLeft.do")
	public String personalLeft (Model model) throws Exception {
		String usePortal = config.getProperty("config.Use_Portal");
		String useKMS = config.getProperty("config.Use_ezKMS");
		
		model.addAttribute("usePortal", usePortal);
		model.addAttribute("useKMS", useKMS);
		
		return "admin/ezPersonal/personalLeft";
	}
	
	/**
	 * 초기화면 공지사항 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/manageNotice.do")
	public String manageNotice (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		boolean auth = commonUtil.checkAdmin(loginCookie);
		
		if (!auth) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getLang());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(vo);
			}
		}
		
		model.addAttribute("list", resultList);
		
		return "admin/ezPersonal/personalManageNotice";
	}
	
	/**
	 * 초기화면 공지사항 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPersonal/manageNoticeList.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String manageNoticeList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		boolean auth = commonUtil.checkAdmin(loginCookie);
		
		String companyID = request.getParameter("id");
		int currentPage = Integer.parseInt(request.getParameter("page"));

		int pageSize = 12;
		
		int totalCount = ezPersonalAdminService.getNoticeCount(companyID);
		String noticeXML = ezPersonalAdminService.getNoticeList(companyID, totalCount, pageSize, (currentPage-1) * pageSize);
		
		int pageCount = (int)((totalCount + pageSize - 1) / pageSize);
		
		if (!auth) {
			return "cmm/error/adminDenied";
		}
		return "";
	}
	
}
