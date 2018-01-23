package egovframework.ezEKP.ezJournal.web;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.minidev.json.JSONUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.JsonUtil;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezJournal.service.EzJournalAdminService;
import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezPortal.web.EzPortalAdminController;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/**
 * @Description [Controller] 업무일지 관리자
 * @author 오픈솔루션팀 박성빈
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2018.01.18    박성빈    신규작성
 *
 * @see
 */

@Controller
public class EzJournalAdminController extends EgovFileMngUtil{

	private static final Logger logger = LoggerFactory.getLogger(EzJournalAdminController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzJournalAdminService ezJournalAdminService;
	
	/**
	 * 관리자 업무일지  메인 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezJournal/journalMain.do")
	public String portalMain(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("journalMain started");

		userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		logger.debug("journalMain ended");
		return "/admin/ezJournal/journalMain";
	}
	
	/**
	 * 관리자 업무일지  좌측 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezJournal/leftTop.do")
	public String leftTop(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("leftTop started");

		userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		logger.debug("leftTop ended");
		return "/admin/ezJournal/leftTop";
	}
	
	/**
	 * 관리자 업무일지 일지함 관리 호출 함수
	 */
	@RequestMapping(value = "/admin/ezJournal/formType.do")
	public String formType(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("formType started");
		
		userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		StringBuilder companySel = new StringBuilder();
		StringBuilder companyList = new StringBuilder();
		String primary = userInfo.getPrimary();
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(primary, userInfo.getTenantId());
		
		for (int k = 0; k < deptVOs.size(); k++) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || deptVOs.get(k).getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + deptVOs.get(k).getCn() + "'>" + deptVOs.get(k).getDisplayName() + "</option>");
				companyList.append(deptVOs.get(k).getCn() + "," +deptVOs.get(k).getDisplayName() + ";");
			}
		}
		model.addAttribute("primary", primary);
		model.addAttribute("companySel", companySel);
		model.addAttribute("companyList", companyList);
		
		logger.debug("formType ended");
		return "/admin/ezJournal/formType";
	}
	
	/**
	 * 공통 > 일지함 사용여부 데이터
	 */
	@RequestMapping(value="admin/ezJournal/journalGetFormUse.do", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getJournaltypeList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("getJournaltypeList started");
		
		HashMap<String, Object> resMap = new HashMap<String, Object>();
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String cID = request.getParameter("COMPANYID");
		
		List<JournaltypeVO> result = ezJournalAdminService.getJournaltypeList(cID, loginSimpleVO.getTenantId());
		
		resMap.put("typeList", result);
		
		logger.debug("getJournaltypeList ended");
		return JsonUtil.HashMapToJson(resMap).toString();
	}
	
	/**
	 * 관리자 업무일지 일지함 사용여부 변경
	 */
	@RequestMapping(value="/admin/ezSchedule/journalSaveFormUse.do")
	@ResponseBody
	public void	journalSaveFormUse(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("journalSaveFormUs started");
		
		userInfo = commonUtil.checkAdmin(loginCookie);
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);		
		
		String cID = request.getParameter("COMPANYID");
		String[] flagList = request.getParameter("FORMUSE").split(";");
		
		List<JournaltypeVO> typelist = new ArrayList<JournaltypeVO>();
		
		
		
		
		//ezJournalAdminService.updateJournaltype(, cID, userInfo.getTenantId());
		
		logger.debug("journalSaveFormUs ended");
		
	}
	
	
}
