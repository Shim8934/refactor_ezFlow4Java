package egovframework.ezEKP.ezApprovalG.web;

import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezApprovalG.service.EzApprovalGJsonService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 사용자 - 전자결재
 * @author 솔루션2팀 강민수
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2020.10.29    강민수         신규작성
 *
 * @see
 */

@Controller
public class EzApprovalGJsonController {

	@Resource(name = "EzApprovalGJsonService")
	private EzApprovalGJsonService ezApprovalGJsonService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalGJsonController.class);
	
	/**
	 * 전자결재G 결재라인 표출 Method
	 */
	@RequestMapping(value = "/ezApprGJson/aprLineRequest.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> aprLineRequest(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		logger.debug("aprLineRequest started.");
		
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String docID = request.getParameter("docID");
		String userID = request.getParameter("userID");
		String formID = request.getParameter("formID");
		String reDraftFlag = "DRAFT";
		String isUsed = request.getParameter("isUsed");
		String beforeDocID = request.getParameter("beforeDocID");
		String mode = request.getParameter("mode");
		String docState = request.getParameter("docState");
		
		String orgCompanyID = request.getParameter("orgCompanyID");
		String companyID = userInfo.getCompanyID();
		
		if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
			userInfo.setCompanyID(orgCompanyID);
		}
		
		if (isUsed == null) {
			isUsed = "";
		}
		
		if (beforeDocID == null) {
			beforeDocID = "";
		}
		
		if (request.getParameter("reDraft") != null) {
			reDraftFlag = request.getParameter("reDraft");
		}
		
		Map<String, Object> resultMap = ezApprovalGJsonService.getAprLineInfo(docID.trim(), userID, formID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset(), reDraftFlag, isUsed, beforeDocID, mode, docState);

		logger.debug("aprLineRequest ended.");
		
		return resultMap;
	}
	
	/**
	 * 전자결재G관리 전체문서조회(완료문서) 문서목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezApprovalG/getStatSearchEndDocList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getStatSearchDocLlist(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getStatSearchDocList started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String offset = userInfo.getOffset();
		Locale locale = userInfo.getLocale();
		String lang = userInfo.getLang();
		
		//양식아이디
		String formID = request.getParameter("formID");
		//양식명
		String formName = request.getParameter("formName");
		//문서번호
		String docNumber = request.getParameter("docNumber");
        //문서제목
		String docTitle = request.getParameter("docTitle");
        //기안자
		String drafter = request.getParameter("drafter");
        //결재자
		String approvUser = request.getParameter("approvUser");
        //기안부서
		String draftDeptName = request.getParameter("deptName1");
        
		//기안일자 시작
        String draftFromYear = request.getParameter("draftFromYear");
        String draftFromMonth = request.getParameter("draftFromMonth");
        String draftFromDay = request.getParameter("draftFromDay");
        
        String draftFrom = "";
        
        // 시작일이라면 makeDate의 startFlag값은 true (DB에는 UTC시간으로 저장되므로 getDateStringInUTC의 timeZoneToUTC값은 true)
        if (draftFromYear != null && !draftFromYear.equals("")) {
        	draftFrom = commonUtil.getDateStringInUTC(commonUtil.makeDate(draftFromYear, draftFromMonth, draftFromDay, true), offset, true).trim();
        }
        
        //기안일자 끝
        String draftToYear = request.getParameter("draftToYear");
        String draftToMonth = request.getParameter("draftToMonth");
        String draftToDay = request.getParameter("draftToDay");

        String draftTo = "";
        
        // 종료일이라면 makeDate의 startFlag값은 false (DB에는 UTC시간으로 저장되므로 getDateStringInUTC의 timeZoneToUTC값은 true)
        if (draftToYear != null && !draftToYear.equals("")) {
        	draftTo = commonUtil.getDateStringInUTC(commonUtil.makeDate(draftToYear, draftToMonth, draftToDay, false), offset, true).trim();
        }
        
        //완료일자 시작
        String apprFromYear = request.getParameter("apprFromYear");
        String apprFromMonth = request.getParameter("apprFromMonth");
        String apprFromDay = request.getParameter("apprFromDay");
        
        String aprFrom = "";
        
        if (apprFromYear != null && !apprFromYear.equals("")) {
        	aprFrom = commonUtil.getDateStringInUTC(commonUtil.makeDate(apprFromYear, apprFromMonth, apprFromDay, true), offset, true).trim();
        }
        
        //완료일자 끝
        String apprToYear = request.getParameter("apprToYear");
        String apprToMonth = request.getParameter("apprToMonth");
        String apprToDay = request.getParameter("apprToDay");
        String aprTo = "";
        
        if (apprToYear != null && !apprToYear.equals("")) {
        	aprTo = commonUtil.getDateStringInUTC(commonUtil.makeDate(apprToYear, apprToMonth, apprToDay, false), offset, true).trim();
        }
        	
        //페이지 번호
        String pageNum = request.getParameter("pageNum");
        //총페이지 수
        String pageSize = request.getParameter("pageSize");

        /* 2024-03-20 기준, 해당 URL의 호출 시 orderCell과 orderOption은 반드시 공백으로 전달됨. 차후 정렬 적용되도록 수정할 가능성이 있어 코드는 유지함. */
        //정렬 대상 셀
        String orderCell = request.getParameter("orderCell");
        //정렬 옵션
        String orderOption = request.getParameter("orderOption");
        
        //테넌트 아이디
        int tenantID = userInfo.getTenantId();
        
        //회사 아이디
        String companyID = request.getParameter("companyID");

        //일반/공공구분
        String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
        
        /* 2024-03-20 홍승비 - SQL Injection 제거 > 검색 쿼리를 subQuery 문자열이 아닌 개별 파라미터로 전달 */
        // 2024-03-20 기준, 관리자 > 전체문서조회(완료문서) 문서목록 기능의 subQuery에 들어갈 수 있는 칼럼은 KEYWORD, ITEMCODE 두 개의 칼럼 뿐임
        // 2021-03-16 키워드 검색을 위한 subQuery
        //String subQuery = request.getParameter("subQuery");
        
        String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";
        String itemcode = request.getParameter("itemcode") != null ? request.getParameter("itemcode") : "";
        
        Map<String, Object> resultMap =  ezApprovalGJsonService.getAdminSearchDocList(formID, formName, docNumber, docTitle, drafter, approvUser, draftDeptName, draftFrom, draftTo, aprFrom, aprTo, pageSize, pageNum, orderCell, orderOption, companyID, tenantID, lang, offset, approvalFlag, keyword, itemcode, locale);
        
        logger.debug("getStatSearchDocList ended.");
        
		return resultMap;
	}
	
	/**
	 * 전자결재 JSON 테스트 페이지
	 */
	@RequestMapping(value = "/ezApprGJson/jsonTest.do", method = RequestMethod.GET)
	public String formCheckUI(){
		return "ezApprovalG/jsonTest";
	}
	
}
