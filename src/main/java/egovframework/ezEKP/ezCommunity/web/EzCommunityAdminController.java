package egovframework.ezEKP.ezCommunity.web;

import java.util.HashMap;
import java.util.List;
import java.util.Optional;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth.AdminAuth;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommunity.service.EzCommunityAdminService;
import egovframework.ezEKP.ezCommunity.service.EzCommunityService;
import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCComCloseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMemberInfoVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 관리자 커뮤니티
 * @author 오픈솔루션팀 이효진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.06.23    이효진    신규작성
 *
 * @see
 */

@Controller
public class EzCommunityAdminController {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Resource(name="EzCommunityAdminService")
	private EzCommunityAdminService ezCommunityAdminService;
	
	@Resource(name="EzCommunityService")
	private EzCommunityService ezCommunityService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCommunityAdminController.class);
	
	/**
	 * 메인화면 호출함수
	 */
	@RequestMapping(value = "/admin/ezCommunity/communityMain.do", method = RequestMethod.GET)
	public String main() throws Exception {
		return "/admin/ezCommunity/communityMain";
	}
	
	/**
	 * 왼쪽 메뉴화면 호출함수
	 */
	@RequestMapping(value = "/admin/ezCommunity/left.do", method = RequestMethod.GET)
	public String left(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		return "/admin/ezCommunity/communityLeft";
	}
	
	/**
	 * 왼쪽 커뮤니티 신청 관리 카운트 호출함수
	 */
	@RequestMapping(value = "/admin/ezCommunity/getApplicationListCount.do", method = RequestMethod.POST)
	public String getApplicationListCount(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("getApplicationListCount started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String lang         = userInfo.getLang();
		String companyId    = userInfo.getCompanyID();
		int tenantId        = userInfo.getTenantId();
		
		int admitTotalCount = ezCommunityAdminService.aspAdmitComGet2("", "", "", commonUtil.getMultiData(lang, tenantId), companyId, tenantId);
		int closeTotalCount = ezCommunityAdminService.aspCloseComGet2("", "", "", commonUtil.getMultiData(lang, tenantId), companyId, tenantId);
		
		model.addAttribute("count", admitTotalCount + closeTotalCount);
		
		logger.debug("getApplicationListCount started.");
		return "json";
	}
	
	/**
	 * 오른쪽화면 호출함수
	 */
	@RequestMapping(value = "/admin/ezCommunity/right.do", method = RequestMethod.GET)
	public String right(ModelMap model, HttpServletRequest request) throws Exception {
		String cID = "";
		
		if (request.getParameter("cID") != null) {
			cID = request.getParameter("cID");
		}
		
		model.addAttribute("cID", cID);
		
		return "/admin/ezCommunity/communityRight";
	}
	
	/**
	 * 알림마당화면 호출함수
	 */
	@RequestMapping(value = "/admin/ezCommunity/bbsList.do", method = RequestMethod.GET)
	public String bbsList(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useEditor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		String code = "", keyword = "", sRadio = "", titleName = "";
		int nowBlock = 0, curPage = 1 , comNoPerPage = 10;
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		
		String bName = request.getParameter("bName") != null ? request.getParameter("bName") : "";
		
		if (request.getParameter("code") != null) {
			code = request.getParameter("code");
		}
		if (request.getParameter("keyword") != null) {
			keyword = request.getParameter("keyword");
			keyword = keyword.replace("\\", "\\\\");
		}
		if (request.getParameter("sRadio") != null) {
			sRadio = request.getParameter("sRadio");
		}
		if (request.getParameter("goToPage") != null) {
			curPage = Integer.parseInt(request.getParameter("goToPage"));
		}
		if (request.getParameter("titleName") != null) {
			titleName = request.getParameter("titleName");
		}
		if (request.getParameter("block") != null) {
			nowBlock = Integer.parseInt(request.getParameter("block"));
		}
		
		if (!code.equals("")) {
			titleName = ezCommunityService.getBoardTitleName(bName, code, userInfo.getTenantId());
		}

		String companyID = Optional.ofNullable(request.getParameter("companyID")).orElse(userInfo.getCompanyID());

		int keywordCount = ezCommunityService.bbsListGet1(bName, userInfo.getPrimary(), keyword, sRadio, companyID, userInfo.getTenantId());
		int totalPage = keywordCount / comNoPerPage;
		
		if ((totalPage * comNoPerPage) != keywordCount && (keywordCount % comNoPerPage) != 0) {
			totalPage = totalPage + 1;
		}
		
		curPage = Math.min(curPage,  totalPage);
		
		List<CommunityCBoardVO> cBoardList = ezCommunityService.bbsListGet2(bName, userInfo.getPrimary(), keyword, sRadio, userInfo.getTenantId(), companyID);
		
		//String idSpanValue = ezCommunityService.bbsList(userInfo, cBoardList, code, curPage, bName, comNoPerPage);
		//번호 1,2,3 순서로 출력하기 위해
		String idSpanValue = ezCommunityAdminService.adminBbsList(userInfo, cBoardList, code, curPage, bName, comNoPerPage);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("bName", bName);
		model.addAttribute("code", code);
		model.addAttribute("keyword", keyword);
		model.addAttribute("keywordCount", keywordCount);
		model.addAttribute("sRadio", sRadio);
		model.addAttribute("curPage", curPage);
		model.addAttribute("nowBlock", nowBlock);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("titleName", titleName);
		model.addAttribute("idSpanValue", idSpanValue);
		model.addAttribute("companySelectID", companyID);

		return "/admin/ezCommunity/communityBBSList";
	}
	
	/**
	 * 커뮤니티 관리 페이지  호출함수
	 */
	@RequestMapping(value = "/admin/ezCommunity/searchKey.do", method = RequestMethod.GET)
	public String searchKey(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		logger.debug("searchKey started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		model.addAttribute("idSpanValue", ezCommunityService.getCategory("", "", "", userInfo));
		
		logger.debug("searchKey endend.");
		
		return "/admin/ezCommunity/communitySearchKey";
	}
	
	/**
	 * 개설된 커뮤니티  리스트  호출 함수
	 */
	@RequestMapping(value = "/admin/ezCommunity/openCommunityList.do", method = RequestMethod.POST)
	public String openCommunityList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("openCommunityList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String lang      = userInfo.getLang();
		String primary   = userInfo.getPrimary();
		int tenantId     = userInfo.getTenantId();
		
		int pageSize       = 10;
		int pageNum        = request.getParameter("pageNum") != null ? Integer.parseInt(request.getParameter("pageNum")) : 1;
		String searchType  = request.getParameter("searchType") != null ? request.getParameter("searchType")   : "" ;
		String searchType2  = request.getParameter("searchType2") != null ? request.getParameter("searchType2")   : "" ;
		String searchValue = request.getParameter("searchValue") != null ? request.getParameter("searchValue") : "" ;
				String companyId = request.getParameter("companyId") != null ? request.getParameter("companyId") : userInfo.getCompanyID() ;
		String offSetMin   = commonUtil.getMinuteUTC(userInfo.getOffset());
		
/*		logger.debug("pageNum=" + pageNum);
		logger.debug("searchType=" + searchType + ",searchValue=" + searchValue);
		logger.debug("offSetMin=" + offSetMin);*/
		
		/* 2020-01-03 홍승비 - 커뮤니티 검색 시 커뮤니티소개 검색옵션 다시 추가 */
		int totalCount = ezCommunityAdminService.aspSearchKeyGet2(commonUtil.getMultiData(lang, tenantId), searchType, searchType2, searchValue, companyId, tenantId);
		int totalPage  = 1;
		
		if (totalCount > 0) {
			if (totalCount > pageSize) {
				totalPage = totalCount / pageSize;
				
				if (totalCount % pageSize != 0) {
					totalPage++;
				}
			}
		}
		
		//logger.debug("totalCount=" + totalCount + ",totalPage=" + totalPage);
		
		List<CommunityClubVO> clubList = ezCommunityAdminService.aspSearchKeyGet1(primary, pageNum, searchType, searchType2, searchValue, offSetMin, companyId, tenantId);
		if (clubList.size() > 0) {
			for(CommunityClubVO club : clubList) {
				club.setUserName(ezCommunityAdminService.getUserName(club.getC_SysopID().trim(), primary, companyId, tenantId));
				club.setC_MemberCnt(ezCommunityService.commViewMemberGet2(club.getC_ClubNo(), primary, "", "", companyId, tenantId));
				club.setItemCnt(ezCommunityService.categoryListItemCntGet(club.getC_ClubNo(), tenantId));
			}
		}
		
		model.addAttribute("clubList", clubList);
		model.addAttribute("pageNum", pageNum);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("totalCount", totalCount);
		
		logger.debug("openCommunityList endend.");
		return "json";
	}
	
	/**
	 * 폐쇄한 커뮤니티  리스트  호출 함수
	 */
	@RequestMapping(value = "/admin/ezCommunity/closedCommunityList.do", method = RequestMethod.POST)
	public String closedCommunityList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("closedCommunityList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String lang      = userInfo.getLang();
		String primary   = userInfo.getPrimary();
		int tenantId     = userInfo.getTenantId();
		
		int pageSize       = 10;
		int pageNum        = request.getParameter("pageNum") != null ? Integer.parseInt(request.getParameter("pageNum")) : 1;
		String searchValue = request.getParameter("searchValue") != null ? request.getParameter("searchValue") : "";
		String searchType2 = request.getParameter("searchType2") != null ? request.getParameter("searchType2") : "";
		String companyId = request.getParameter("companyId") != null ? request.getParameter("companyId") : userInfo.getCompanyID() ;
		String offSetMin   = commonUtil.getMinuteUTC(userInfo.getOffset());
		
/*		logger.debug("pageNum=" + pageNum);
		logger.debug("searchValue=" + searchValue);
		logger.debug("offSetMin=" + offSetMin);*/
		
		/* 2020-01-06 홍승비 - 폐쇄한 커뮤니티 검색 시 폐쇄사유 추가 */
		int totalCount = ezCommunityAdminService.getClosedCommuListCount(commonUtil.getMultiData(lang, tenantId), userInfo.getLocale(), searchType2, searchValue, companyId, tenantId);
		int totalPage  = 1;
		
		if (totalCount > 0) {
			if (totalCount > pageSize) {
				totalPage = totalCount / pageSize;
				
				if (totalCount % pageSize != 0) {
					totalPage++;
				}
			}
		}
		
		//logger.debug("totalCount=" + totalCount + ",totalPage=" + totalPage);
		
		List<CommunityCComCloseVO> clubList = ezCommunityAdminService.getClosedCommuList(primary, userInfo.getLocale(), pageNum, searchType2, searchValue, offSetMin, companyId, tenantId);
		if (clubList.size() > 0) {
			for(CommunityCComCloseVO club : clubList) {
				club.setUserName(ezCommunityAdminService.getUserName(club.getC_SysopID().trim(), primary, companyId, tenantId));
			}
		}
		
		model.addAttribute("clubList", clubList);
		model.addAttribute("pageNum", pageNum);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("totalCount", totalCount);
		
		logger.debug("closedCommunityList endend.");
		return "json";
	}
	
	/**
	 * 커뮤니티 상세정보 수정화면 호출함수
	 */
	@RequestMapping(value = "/admin/ezCommunity/admCommunityInfoEdit.do", method = RequestMethod.GET)
	public String admCommunityInfoEdit(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		
		CommunityClubVO club = ezCommunityAdminService.admCommunityInfoEdit(commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), code, userInfo.getTenantId());
		club.setUserName(ezCommunityAdminService.getUserName(club.getC_SysopID().trim(), userInfo.getPrimary(), userInfo.getCompanyID(), userInfo.getTenantId()));
		//club.setC_ClubDesc(club.getC_ClubDesc().replaceAll("<br>", "\r\n"));
		club.setC_ClubName(commonUtil.cleanValue(club.getC_ClubName()));
		
		String idSpanValue = ezCommunityService.getCategory(club.getC_Cate_A(), club.getC_Cate_B(), club.getC_Cate_C(), userInfo);
		
		model.addAttribute("code", code);
		model.addAttribute("club", club);
		model.addAttribute("idSpanValue", idSpanValue);
		
		return "/admin/ezCommunity/admCommunityInfoEdit";
	}
	
	/**
	 * 커뮤니티 상세정보 수정 실행함수
	 */
	@RequestMapping(value = "/admin/ezCommunity/admCommunityInfoEditOk.do", method = RequestMethod.POST)
	@ResponseBody
	public String admCommunityInfoEditOk(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("admCommunityInfoEditOk started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		String clubName = request.getParameter("clubName");
		String clubDesc = request.getParameter("clubDesc");
		String cCateA = request.getParameter("cCateA");
		String cCateB = request.getParameter("cCateB");
		String cCateC = request.getParameter("cCateC");
		
		//logger.debug("code=" + code + ",clubName=" + clubName + ",clubDesc=" + clubDesc + ",cCateA=" + cCateA + ",cCateB=" + cCateB + ",cCateC=" + cCateC);
		
		String result = ezCommunityAdminService.admCommunityInfoEditOk(commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), cCateA, cCateB, cCateC, clubName, clubDesc, code, userInfo.getTenantId());
		
		logger.debug("admCommunityInfoEditOk ended.");
		
		return result;
	}
	
	/**
	 * 폐쇄한 커뮤니티 상세정보 수정 호출함수
	 */
	@RequestMapping(value = "/admin/ezCommunity/closeCommunityInfo.do", method = RequestMethod.GET)
	public String closeCommunityInfo(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		logger.debug("closeCommunityInfo started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String offSetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
		String lang        = userInfo.getLang();
		String companyId   = Optional.ofNullable(request.getParameter("companyID")).orElse(userInfo.getCompanyID());
		int tenantId       = userInfo.getTenantId();
		
		String code = request.getParameter("code");
		
		CommunityCComCloseVO club = ezCommunityAdminService.closeCommunityInfo(commonUtil.getMultiData(lang, tenantId), code, offSetMin, companyId, tenantId);
		club.setUserName(ezCommunityAdminService.getUserName(club.getC_SysopID().trim(), userInfo.getPrimary(), companyId, tenantId));
		
		model.addAttribute("club", club);
		
		logger.debug("closeCommunityInfo started.");
		
		return "/admin/ezCommunity/closeCommunityInfo";
	}
	
	/**
	 * 승인/폐쇄신청 커뮤니티 정보화면 호출함수
	 */
	@RequestMapping(value = "/admin/ezCommunity/commInfo.do", method = RequestMethod.GET)
	public String commInfo(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		logger.debug("commInfo started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		String type = request.getParameter("type");
		String title = request.getParameter("title");
		int tenantID = userInfo.getTenantId();
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), tenantID);
		
		CommunityClubVO clubVO = ezCommunityService.aspCommInfoGet1(code, userInfo.getTenantId());
		CommunityMemberInfoVO memberVO = ezCommunityService.aspCommInfoGet2(userInfo.getPrimary(), clubVO.getC_SysopID().trim(), userInfo.getCompanyID(), tenantID);
		
		String strCategory = ezCommunityService.categoryPrint(clubVO.getC_Cate_A().trim(), clubVO.getC_Cate_B().trim(), clubVO.getC_Cate_C().trim(), userInfo);
		
		String delReason = ezCommunityAdminService.aspCommInfoGet3(code, tenantID);
		String newInfo = ezCommunityAdminService.aspCommInfoGet4(code, tenantID);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("sysopCheck", sysopCheck);
		model.addAttribute("code", code);
		model.addAttribute("type", type);
		model.addAttribute("title", title);
		model.addAttribute("clubVO", clubVO);
		model.addAttribute("memberVO", memberVO);
		model.addAttribute("strCategory", strCategory);
		model.addAttribute("delReason", delReason);
		model.addAttribute("newInfo", newInfo);
		
		logger.debug("commInfo ended.");
		
		return "/admin/ezCommunity/communityCommInfo";
	}
	
	/**
	 * 커뮤니티 신청 관리 > 폐쇄신청 실행함수
	 */
	@RequestMapping(value = "/admin/ezCommunity/commCloseAll.do", method = RequestMethod.GET)
	public String commCloseAll(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String type = request.getParameter("type");
		String code = request.getParameter("code");
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		ezCommunityAdminService.commCloseAll(code, userInfo.getLocale(), userInfo.getTenantId());
		
		model.addAttribute("sysopCheck", sysopCheck);
		
		if (type.equals("listBtn")) {
			return "json";
		}
		
		return "/admin/ezCommunity/communityCommCloseAll";
	}
	
	/**
	 * 커뮤니티 관리 > 폐쇄 실행함수
	 */
	@RequestMapping(value = "/admin/ezCommunity/commAdminCloseAll.do", method = RequestMethod.POST)
	public String commAdminCloseAll(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String companyName = userInfo.getCompanyName1();
		int tenantId       = userInfo.getTenantId();
		
		String code = request.getParameter("code");
		
		CommunityCComCloseVO closeVO = ezCommunityService.adminCommCloseOkGet1(code, tenantId);
		CommunityClubVO clubVO       = ezCommunityService.adminCommCloseOkGet2(code, tenantId);
		String companyId   = clubVO.getCompanyID();

		if (closeVO != null) {
			ezCommunityAdminService.adminCommCloseAll(code, egovMessageSource.getMessage("ezCommunity.khj01", userInfo.getLocale()), userInfo.getLocale(), tenantId);
		} else {
			String commName   = clubVO.getC_ClubName();
			String commName2  = clubVO.getC_ClubName2();
			String sysopID    = clubVO.getC_SysopID();
			
			ezCommunityAdminService.aspCommCloseAllDel(code, tenantId);
			ezCommunityService.adminCommCloseOkInsert(code, commName, commName2, sysopID, companyName, companyId, commonUtil.getTodayUTCTime(""), egovMessageSource.getMessage("ezCommunity.khj01", userInfo.getLocale()), "1", tenantId);
		}
		
		return "json";
	}
	
	/**
	 * 승인신청 실행함수
	 */
	@RequestMapping(value = "/admin/ezCommunity/commAdmitOk.do", method = RequestMethod.GET)
	public String commAdmitOk(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String diviTitle = "";
		
		String type = request.getParameter("type");
		String code = request.getParameter("code");
		String pDivi = request.getParameter("pDivi");
		
		List<HashMap<String, Object>> recipientList = null;
		
		if (pDivi.equals("AdmitCancel")) {
			diviTitle = egovMessageSource.getMessage("ezCommunity.t43", userInfo.getLocale());
			
			recipientList = ezCommunityAdminService.aspCommAdmitOkSet1(code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
			ezCommunityAdminService.createCommunityAdmitSendMail(request, loginCookie, userInfo, recipientList, false);
		} else if (pDivi.equals("AdmitOK")) {
			diviTitle = egovMessageSource.getMessage("ezCommunity.t45", userInfo.getLocale());
			recipientList = ezCommunityAdminService.aspCommAdmitOkSet2(code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), "", "", userInfo.getTenantId());
			
			ezCommunityAdminService.createCommunityAdmitSendMail(request, loginCookie, userInfo, recipientList, true);
		} else {
			diviTitle = egovMessageSource.getMessage("ezCommunity.t47", userInfo.getLocale());
		}
		
		model.addAttribute("diviTitle", diviTitle);
		
		if (type.equals("listBtn")) {
			return "json";
		}
		
		return "/admin/ezCommunity/communityCommAdmitOk";
	}
	
	/**
	 * 커뮤니티 신청관리  페이지 호출 함수
	*/
	@RequestMapping(value = "/admin/ezCommunity/applicationList.do", method = RequestMethod.GET)
	public String applicationList(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		logger.debug("applicationList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		model.addAttribute("idSpanValue", ezCommunityService.getCategory("", "", "", userInfo));
		
		logger.debug("applicationList endend.");
		
		return "/admin/ezCommunity/communityApplicationList";
	}
	
	/**
	 * 신청 승인  리스트 호출 함수
	 */
	@RequestMapping(value = "/admin/ezCommunity/admitCom.do", method = RequestMethod.POST)
	public String admitCom(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String lang        = userInfo.getLang();
		String companyId   = Optional.ofNullable(request.getParameter("companyID")).orElse(userInfo.getCompanyID());
		int tenantId       = userInfo.getTenantId();
		
		int pageSize       = 10;
		int pageNum        = request.getParameter("pageNum") != null ? Integer.parseInt(request.getParameter("pageNum")) : 1;
		String searchType  = request.getParameter("searchType") != null ? request.getParameter("searchType") : "" ;
		String searchType2  = request.getParameter("searchType2") != null ? request.getParameter("searchType2") : "" ;
		String searchValue = request.getParameter("searchValue") != null ? request.getParameter("searchValue") : "" ;
		String code        = request.getParameter("code") != null ? request.getParameter("code") : "" ; //언제쓰이는지?
		String offSetMin   = commonUtil.getMinuteUTC(userInfo.getOffset());
		
/*		logger.debug("pageNum=" + pageNum);
		logger.debug("searchType=" + searchType + ", searchType2=" + searchType2 + ", searchValue=" + searchValue);
		logger.debug("offSetMin=" + offSetMin);*/
		
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), companyId, tenantId);
		
		/* 2020-01-06 홍승비 - 커뮤니티소개 검색옵션 추가 */
		/* 2018-06-21 홍승비 - 관리자 > 커뮤니티 신청승인 표출(총 n개 카운트) */
		int totalCount = ezCommunityAdminService.aspAdmitComGet2(searchValue, searchType, searchType2, commonUtil.getMultiData(lang, tenantId), companyId, tenantId);
		int totalPage = 1;
		
		if (totalCount > 0) {
			if (totalCount > pageSize) {
				totalPage = totalCount / pageSize;
				
				if (totalCount % pageSize != 0) {
					totalPage++;
				}
			}
		}
		
		//logger.debug("totalCount=" + totalCount + ", totalPage=" + totalPage);
		
		/* 2018-06-21 홍승비 - 관리자 > 커뮤니티 신청승인 표출(리스트) -> 사간겸직한 회원이 만든 커뮤니티는 겸직한 회사만큼 전부 표출됨(수정필요) */
		List<CommunityClubVO> clubList = ezCommunityAdminService.aspAdmitComGet1(searchValue, searchType, searchType2, commonUtil.getMultiData(lang, tenantId), pageNum, offSetMin, companyId, tenantId);
		
		/* 2019-01-17 김혜정 - 관리자 > 폐쇄승인 커뮤니티 카운트  추가 */ 
		int tabCount = ezCommunityAdminService.aspCloseComGet2("", "", "", commonUtil.getMultiData(lang, tenantId), companyId, tenantId);
		
		model.addAttribute("clubList", clubList);
		model.addAttribute("pageNum", pageNum);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("sysopCheck", sysopCheck);
		model.addAttribute("tabCount", tabCount);
		
		return "json";
	}
	
	/**
	 * 폐쇄 승인 리스트  호출 함수
	 */
	@RequestMapping(value = "/admin/ezCommunity/closeCom.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String closeCom (@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String lang        = userInfo.getLang();
		String companyId   = Optional.ofNullable(request.getParameter("companyID")).orElse(userInfo.getCompanyID());
		int tenantId       = userInfo.getTenantId();
		
		int pageSize       = 10;
		int pageNum        = request.getParameter("pageNum") != null ? Integer.parseInt(request.getParameter("pageNum")) : 1;
		String searchType  = request.getParameter("searchType") != null ? request.getParameter("searchType") : "" ;
		String searchType2  = request.getParameter("searchType2") != null ? request.getParameter("searchType2") : "" ;
		String searchValue = request.getParameter("searchValue") != null ? request.getParameter("searchValue") : "" ;
		String code        = request.getParameter("code") != null ? request.getParameter("code") : "" ; //언제쓰이는지?
		String offSetMin   = commonUtil.getMinuteUTC(userInfo.getOffset());
		
/*		logger.debug("pageNum=" + pageNum);
		logger.debug("searchType=" + searchType + ",searchValue=" + searchValue);
		logger.debug("offSetMin=" + offSetMin);
		*/
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), companyId, tenantId);
		
		/* 2020-01-06 홍승비 - 폐쇄사유 검색옵션 추가 */
		/* 2018-06-21 홍승비 - 관리자 > 폐쇄승인 커뮤니티 표출(총 n개 카운트) */
		int totalCount = ezCommunityAdminService.aspCloseComGet2(searchValue, searchType, searchType2, commonUtil.getMultiData(lang, tenantId), companyId, tenantId);
		int totalPage = 1;
		
		if (totalCount > 0) {
			if (totalCount > pageSize) {
				totalPage = totalCount / pageSize;
				
				if (totalCount % pageSize != 0) {
					totalPage++;
				}
			}
		}
		
		//logger.debug("totalCount=" + totalCount + ", totalPage=" + totalPage);
		
		/* 2018-06-21 홍승비 - 관리자 > 폐쇄승인 커뮤니티 표출(리스트) */
		List<CommunityCComCloseVO> clubList = ezCommunityAdminService.aspCloseComGet1(searchValue, searchType, searchType2, commonUtil.getMultiData(lang, tenantId), pageNum, offSetMin, companyId, tenantId);
		
		/* 2019-01-17 김혜정 - 관리자 > 신청승인 커뮤니티 카운트  추가 */ 
		int tabCount = ezCommunityAdminService.aspAdmitComGet2("", "", "", commonUtil.getMultiData(lang, tenantId), companyId, tenantId);
		
		model.addAttribute("clubList", clubList);
		model.addAttribute("pageNum", pageNum);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("sysopCheck", sysopCheck);
		model.addAttribute("tabCount", tabCount);
		
		return "json";
	}
}
