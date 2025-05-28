package egovframework.ezMobile.ezApprovalG.web;

import java.security.PrivateKey;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import egovframework.ezMobile.ezApprovalG.vo.*;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezMobile.ezApprovalG.service.MApprovalGService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 전자결재 모바일 GW
 * @author 오픈솔루션팀 황윤진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2017.07.25    황윤진    신규작성
 *
 * @see
 */

@RestController
public class MApprovalGGWController {
	private static final Logger logger = LoggerFactory.getLogger(MApprovalGGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name = "EzEmailService")
	private EzEmailService ezEmailService;
	
	@Resource(name = "MApprovalGService")
	private MApprovalGService mApprovalGService;
	
	@Resource(name = "MOptionService")
	private MOptionService mOptionService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	/**
	 * 모바일 G/W 전자결재 [GET] 결재문서 메인 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/main-list/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")	
	public JSONObject mApprovalMainList(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/main-list/users/" + userId + "] started.");

		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String listSize = "10"; //리스트사이즈 임시로 10개 차후 디비에서 가져와야함
			String lastDate = commonUtil.getTodayUTCTime("");
			
			logger.debug("listSize : " + listSize);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			List<MApprovalGDocInfoVO> approvalGDocInfoVOs = mApprovalGService.getDoApproveList(userInfo, "DO", "", listSize, lastDate);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", approvalGDocInfoVOs);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/main-list/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [GET] 결재문서 리스트 (결재할(DO), 결재한(END), 결재진행(ING), 기안한(DRAFT), 공유결재(SHARE), 반송된(BAN))
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/{type}/list/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalList(@PathVariable String type, @PathVariable String userId, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/" + type + "/list/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String searchText = request.getParameter("searchText");
			String listSize = request.getParameter("listSize");
			String lastDate = request.getParameter("lastDate");
			String serverName = request.getHeader("x-user-host");
			
			logger.debug("searchText : " + searchText);
			logger.debug("listSize : " + listSize);
			logger.debug("lastDate : " + lastDate);
			
			searchText = searchText.replace("%", "\\%").replace("_", "\\_");
			
			if (listSize == null || listSize.equals("")) {
				listSize = "50";
			}
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			if (lastDate == null || lastDate.equals("")) {
				lastDate = commonUtil.getTodayUTCTime("");
			} else {
				lastDate = commonUtil.getDateStringInUTC(lastDate, userInfo.getOffSet(), true);
			}
			
			List<MApprovalGDocInfoVO> approvalGDocInfoVOs = mApprovalGService.getDoApproveList(userInfo, type, searchText, listSize, lastDate);
			
			if (approvalGDocInfoVOs != null && approvalGDocInfoVOs.size() > 0) {
				lastDate = approvalGDocInfoVOs.get(approvalGDocInfoVOs.size() - 1).getStartDate();
			}
			
			// 2023-05-25 이가은 - 전자결재 > 공람문서 메뉴 표출을 위한 approvalFlag 값 추가
			String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
			
			JSONObject totalData = new JSONObject();
			
			totalData.put("docInfos", approvalGDocInfoVOs);
			totalData.put("lastDate", lastDate);
			totalData.put("approvalFlag", approvalFlag);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", totalData);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/" + type + "/list/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [GET] 결재문서 카운트 (결재할(DO), 결재한(END), 결재진행(ING), 기안한(DRAFT), 공유결재(SHARE), 반송된(BAN))
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/{type}/list-count/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalListCount(@PathVariable String type, @PathVariable String userId, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/" + type + "/list-count/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String searchText = request.getParameter("searchText");
			String serverName = request.getHeader("x-user-host");
			
			logger.debug("serverName : " + serverName);
			logger.debug("searchText : " + searchText);
			
			searchText = searchText.replace("%", "\\%").replace("_", "\\_");
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			int listCount = mApprovalGService.getDoApproveListCount(userInfo, type, searchText);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", listCount);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/" + type + "/list-count/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [GET] 문서보기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalDoc(@PathVariable String docId, HttpServletRequest request, Locale locale) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "] started.");

		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String type = request.getParameter("type");
			String aprMemberSN = request.getParameter("aprMemberSN");
			String mode = request.getParameter("mode");
			String serverName = request.getHeader("x-user-host");
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			logger.debug("type : " + type);
			logger.debug("mode : " + mode);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			MOptionVO optionInfo = mOptionService.optionInfo(userId, userInfo.getTenantId());
			
			String companyID = request.getParameter("companyID");
			
			if (companyID != null && !companyID.equals("") && !companyID.equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(companyID);
			}
			
			String realPath = commonUtil.getRealPath(request);
			String domain = request.getServerName() + ":" + request.getServerPort();
	        String scheme = "http://";
			
	    	if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
	    		scheme = "https://";
	    	}
			//본문
			String bodyHTML = mApprovalGService.getMHTBody(docId, realPath, domain, userInfo, locale, type, scheme, mode);
			//결재문서정보
			MApprovalGDocInfoVO approvalGDocInfoVO = mApprovalGService.getAprDocInfo(docId, type, optionInfo.getLang(), userInfo.getOffSet(), userInfo.getCompanyId(), userInfo.getTenantId(), aprMemberSN, mode);
			//회수 가능여부
			String callBackYN = ezApprovalGService.getCallBackYN(docId, userId, userInfo.getCompanyId(), userInfo.getTenantId());
			
			// 20180824 조진호 - 모바일 viewerflag 값 추가
        	String useMobileViewer = ezCommonService.getTenantConfig("useMobileViewer", userInfo.getTenantId());
        	
        	// 2023-05-25 이가은 - 전자결재 > 공람문서 메뉴 표출을 위한 approvalFlag 값 추가
        	String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
        	
			JSONObject totalData = new JSONObject();
			
			totalData.put("bodyHTML", bodyHTML);
			totalData.put("docInfo", approvalGDocInfoVO);
			totalData.put("callBackYN", callBackYN);
			totalData.put("useMobileViewer", useMobileViewer);
			totalData.put("approvalFlag", approvalFlag);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", totalData);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [GET] 결재라인 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/line-list", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalLineList(@PathVariable String docId, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/line-list] started.");

		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String type = request.getParameter("type");
			String mode = request.getParameter("mode");
			String serverName = request.getHeader("x-user-host");
			String companyID = request.getParameter("companyID");
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			logger.debug("type : " + type);
			logger.debug("mode : " + mode);
			
			if (mode != null && mode.equals("END")) {
				type = "END";
			}
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			if (companyID != null && !companyID.equals("") && !companyID.equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(companyID);
			}
			
			//결재선
			List<MApprovalGAprLineInfoVO> approvalGAprLineInfoVOs = mApprovalGService.getAprLineInfo(docId, type, userInfo);
			String photoPath = commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId());
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", approvalGAprLineInfoVOs);
			result.put("photoPath", photoPath);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/line-list] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [GET] 의견 카운트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/opinion-count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalOpinionCount(@PathVariable String docId, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/opinion-count] started.");

		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			String type = request.getParameter("type");
			String mode = request.getParameter("mode");
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			logger.debug("type : " + type);
			logger.debug("mode : " + mode);
			
			if (mode != null && mode.equals("END")) {
				type = "END";
			}
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			String companyID = request.getParameter("companyID");
			if (companyID != null && !companyID.equals("") && !companyID.equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(companyID);
			}
			
			//의견갯수
			String commentCount = mApprovalGService.getOpinionCount(docId, type, userInfo);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", commentCount);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/opinion-count] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [GET] 첨부파일 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/attach-list", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalAttachList(@PathVariable String docId, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/attach-list] started.");

		JSONObject result = new JSONObject();
		
		try {
			String type = request.getParameter("type");
			String mode = request.getParameter("mode");
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			logger.debug("type : " + type);
			logger.debug("mode : " + mode);
			
			if (mode != null && mode.equals("END")) {
				type = "END";
			}
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			String companyID = request.getParameter("companyID");
			if (companyID != null && !companyID.equals("") && !companyID.equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(companyID);
			}
			
			List<MApprovalGAttachInfoVO> approvalGAttachInfoVOs = mApprovalGService.getAttachList(docId, type, userInfo);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", approvalGAttachInfoVOs);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/attach-list] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [GET] 의견보기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/opinion", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalOpinionInfo(@PathVariable String docId, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/opinion] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			String type = request.getParameter("type");
			String mode = request.getParameter("mode");
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			logger.debug("mode : " + mode);
			
			if (mode != null && mode.equals("END")) {
				type = "END";
			}
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			String companyID = request.getParameter("companyID");
			if (companyID != null && !companyID.equals("") && !companyID.equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(companyID);
			}
			
			List<MApprovalGOpinionInfoVO> approvalGOpinionInfoVOs = mApprovalGService.getOpinionInfo(docId, type, userInfo);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", approvalGOpinionInfoVOs);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/opinion] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [POST] 의견쓰기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/opinion", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalInsertOpinionInfo(@RequestBody JSONObject jsonParam, @PathVariable String docId, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [POST /mobile/ezapproval/docs/" + docId + "/opinion] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = jsonParam.get("userId").toString();
			String content = jsonParam.get("content").toString();
			String opinionGB = jsonParam.get("opinionGB").toString();
			String aprMemberSN = jsonParam.get("aprMemberSN").toString();	// 2023-04-28 이가은 - 의견 추가할 경우 실제 결재선상의 부서명, 직위로 표출하기 위해 추가
			String serverName = request.getHeader("x-user-host");
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			logger.debug("content : " + content);
			logger.debug("opinionGB : " + opinionGB);
			logger.debug("aprMemberSN : " + aprMemberSN);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			String companyID = jsonParam.get("companyID").toString();
			if (companyID != null && !companyID.equals("") && !companyID.equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(companyID);
			}
			
			// 2023-03-13 전인하 - 전자결재 > 모바일 의견 기능 개선 - 의견 동작 시 추가 파라미터 삽입
			int resultCode = mApprovalGService.mSetOpinionInfo(docId, content, opinionGB, userInfo, "INSERT", aprMemberSN, "0");
			
			//resultCode 가 0이면 업데이트를 했는데 업데이트가 안된 경우 잘못된 경우지만 흐름은 정상적으로 흘러가기에 코드로 구분 프론트단에서 업데이트가 안됐다고 알려줘야하는데 안될리가 없을듯 하지만 한치앞을 내다볼수없는 세상이라 만들어놓음
			if (resultCode == 0) {
				result.put("status", "ok");
				result.put("code", "2");
				result.put("data", "");
			} else {
				result.put("status", "ok");
				result.put("code", "0");
				result.put("data", "");
			}
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [POST /mobile/ezapproval/docs/" + docId + "/opinion] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [PUT] 의견수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/opinion", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalUpdateOpinionInfo(@RequestBody JSONObject jsonParam, @PathVariable String docId, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [PUT /mobile/ezapproval/docs/" + docId + "/opinion] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = jsonParam.get("userId").toString();
			String content = jsonParam.get("content").toString();
			String opinionGB = jsonParam.get("opinionGB").toString();
			// 2023-03-13 전인하 - 전자결재 > 모바일 의견 기능 개선 - 의견 동작 시 추가 파라미터(의견순번) 삽입
			String opinionSN = jsonParam.get("opinionSN").toString();
			String serverName = request.getHeader("x-user-host");
			String aprMemberSN = jsonParam.get("aprMemberSN").toString();
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			logger.debug("content : " + content);
			logger.debug("opinionGB : " + opinionGB);
			logger.debug("aprMemberSN : " + aprMemberSN);
			logger.debug("opinionSN : " + opinionSN);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			String companyID = jsonParam.get("companyID").toString();
			if (companyID != null && !companyID.equals("") && !companyID.equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(companyID);
			}
			
			mApprovalGService.mSetOpinionInfo(docId, content, opinionGB, userInfo, "UPDATE", aprMemberSN, opinionSN);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("MOBILE G/W APPROVAL [PUT /mobile/ezapproval/docs/" + docId + "/opinion] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [DELETE] 의견삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/opinion", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalDeleteOpinionInfo(@PathVariable String docId, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [DELETE /mobile/ezapproval/docs/" + docId + "/opinion] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			String aprMemberSN = request.getParameter("aprMemberSN");
			String opinionSN = request.getParameter("opinionSN");
			
			logger.debug("serverName : " + serverName);
			logger.debug("opinionSN : " + opinionSN);
			logger.debug("userId : " + userId);
			logger.debug("aprMemberSN : " + aprMemberSN);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			String companyID = request.getParameter("companyID");
			if (companyID != null && !companyID.equals("") && !companyID.equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(companyID);
			}
			
			mApprovalGService.mSetOpinionInfo(docId, "", "", userInfo, "DELETE", aprMemberSN, opinionSN);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("MOBILE G/W APPROVAL [DELETE /mobile/ezapproval/docs/" + docId + "/opinion] ended.");
		
		return result;
	}

	/**
	 * 모바일 G/W 전자결재 [GET] 부재자설정 보기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/absentee/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalAbsenteeInfo(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/absentee/users/" + userId + "] started.");

		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			// 2021-02-15 박기범 : 겸직부재중정보 호출 서비스로 교체
			List<MApprovalGAbsenteeAddJobInfoVO> resultList = mApprovalGService.getAbsenteeAddJobInfo(userInfo);
			MApprovalGAbsenteeInfoVO absenteeInfoVO = mApprovalGService.getAbsenteeInfo(userInfo);
			
			// 2023-05-25 이가은 - 전자결재 > 공람문서 메뉴 표출을 위한 approvalFlag 값 추가
			String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
			result.put("approvalFlag", approvalFlag);
			
			if (resultList != null && resultList.size() > 0) {
				result.put("status", "ok");
				result.put("code", "0");
				result.put("data", resultList);
				result.put("startDate",absenteeInfoVO.getStartDate());
				result.put("endDate",absenteeInfoVO.getEndDate());
			} else {
				result.put("status", "ok");
				result.put("code", "2");
				result.put("data", "");
				result.put("startDate","");
				result.put("endDate","");
			}
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}	

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/absentee/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [PUT] 부재자설정 등록
	 * 2021-02-18 박기범 - 겸직부재자 등록으로 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/absentee/users/{userId:.+}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalSetAbsenteeInfo(@PathVariable String userId, HttpServletRequest request, @RequestBody JSONObject jsonObject) {
		logger.debug("MOBILE G/W APPROVAL [PUT /mobile/ezapproval/absentee/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			JSONParser jp = new JSONParser();
			JSONObject data = (JSONObject) jp.parse(jsonObject.toJSONString());
			int resultCode = mApprovalGService.updateAbsenteeJobInfo(data, userInfo.getUserId(), userInfo.getTenantId());
			
			// int resultCode = mApprovalGService.setAbsenteeInfo(absenteeInfoVO);
			
			//resultCode 가 0이면 업데이트를 했는데 업데이트가 안된 경우 잘못된 경우지만 흐름은 정상적으로 흘러가기에 코드로 구분 프론트단에서 업데이트가 안됐다고 알려줘야하는데 안될리가 없을듯 하지만 한치앞을 내다볼수없는 세상이라 만들어놓음
			if (resultCode == 0) {
				result.put("status", "ok");
				result.put("code", "2");
				result.put("data", "");
			} else {
				result.put("status", "ok");
				result.put("code", "0");
				result.put("data", "");
			}
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("MOBILE G/W APPROVAL [PUT /mobile/ezapproval/absentee/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [DELETE] 부재자설정 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/absentee/users/{userId:.+}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalDelAbsenteeInfo(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [DELETE /mobile/ezapproval/absentee/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			int resultCode = mApprovalGService.delAbsenteeInfo(userId, userInfo.getTenantId());
			
			//resultCode 가 0이면 업데이트를 했는데 업데이트가 안된 경우 잘못된 경우지만 흐름은 정상적으로 흘러가기에 코드로 구분 프론트단에서 업데이트가 안됐다고 알려줘야하는데 안될리가 없을듯 하지만 한치앞을 내다볼수없는 세상이라 만들어놓음
			if (resultCode == 0) {
				result.put("status", "ok");
				result.put("code", "2");
				result.put("data", "");
			} else {
				result.put("status", "ok");
				result.put("code", "0");
				result.put("data", "");
			}
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("MOBILE G/W APPROVAL [DELETE /mobile/ezapproval/absentee/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [GET] 비밀번호 확인
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/pwd-check/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalCheckPassword(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/pwd-check/users/" + userId + "] started.");

		JSONObject result = new JSONObject();
		
		try {
			String rsaEncPassword = request.getParameter("password");
			String serverName = request.getHeader("x-user-host");
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			String prm = egovFileScrty.getPrm();
	    	String pre = egovFileScrty.getPre();
	    	
			PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
			
			String password = EgovFileScrty.decryptRsa(pk, rsaEncPassword);
			String shaEncPassword = EgovFileScrty.encryptPassword(password, userId);
			
			int resultCode = mApprovalGService.checkPass(userInfo, shaEncPassword);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", resultCode);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/pwd-check/users/" + userId + "] ended.");
		
		return result;
	}

	/**
	 * 모바일 G/W 전자결재 [PUT] 결재(APR), 반송(BAN), 보류(BO), 회수(HWE), 참조(CHECK), 공람(GR)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/approve/{type:.+}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalDoApprove(@PathVariable String docId, @PathVariable String type, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/approve/" + type + "] started.");

		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String locale = request.getParameter("locale");
			String aprMemberSN = request.getParameter("aprMemberSN");
			String mode = request.getParameter("mode");
			String serverName = request.getHeader("x-user-host");
			String realPath = commonUtil.getRealPath(request);
			
			if (mode == null || mode.equals("")) {
				mode = "APR";
			}
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			MOptionVO optionInfo = mOptionService.optionInfo(userId, userInfo.getTenantId());
			
			String companyID = request.getParameter("companyID");
			if (companyID != null && !companyID.equals("") && !companyID.equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(companyID);
			}
			
			String rtnVal = "";
			
			//docId로만 정보 가져오기
			MApprovalGDocInfoVO approvalGDocInfoVO = null;
			if (type.equalsIgnoreCase("GR")) {
				approvalGDocInfoVO = mApprovalGService.getAprDocInfo(docId, "GR", optionInfo.getLang(), userInfo.getOffSet(), userInfo.getCompanyId(), userInfo.getTenantId(), aprMemberSN, mode);
			} else {
				approvalGDocInfoVO = mApprovalGService.getAprDocInfo(docId, "DO", optionInfo.getLang(), userInfo.getOffSet(), userInfo.getCompanyId(), userInfo.getTenantId(), aprMemberSN, mode);
			}
			
			LoginVO loginVO = new LoginVO();
			
			loginVO.setId(userId);
			loginVO.setCompanyID(userInfo.getCompanyId());
			loginVO.setTenantId(userInfo.getTenantId());
			loginVO.setOffset(userInfo.getOffSet());
			loginVO.setLocale(new Locale(locale));
			loginVO.setLang(optionInfo.getLang());
			loginVO.setDeptID(userInfo.getDeptId());
			loginVO.setDeptName(userInfo.getDeptName());
			loginVO.setDisplayName(userInfo.getUserName());
			loginVO.setPrimary(commonUtil.getPrimaryData(loginVO.getLang(), loginVO.getTenantId()));
			loginVO.setEmail(userInfo.getEmail());
			
			if (type.equals("APR")) {
				String lineMode = ezApprovalGService.getLineModeFlag(docId, userInfo.getUserId(), userInfo.getCompanyId(), userInfo.getTenantId());
				
				if(approvalGDocInfoVO.getHref().endsWith("mht")) {
					rtnVal = ezApprovalGService.mobileSrvConn(userId, "A", approvalGDocInfoVO.getFormID(), "", docId, approvalGDocInfoVO.getAprMemberID(), optionInfo.getLang(), userInfo.getCompanyId(), request, loginVO, lineMode, aprMemberSN);
				} else {
					rtnVal = ezApprovalGService.mobileSrvConn_HWP(userId, "A", approvalGDocInfoVO.getFormID(), "", docId, approvalGDocInfoVO.getAprMemberID(), optionInfo.getLang(), userInfo.getCompanyId(), request, loginVO, lineMode, aprMemberSN);
				}
				
				/* 2020-07-02 홍승비 - 모바일에서 최종결재 완료 시 서명에 결재날짜 삽입 동작 추가(결재날짜 필드가 없는 경우에만, 웹과 동일하게) */
				if (rtnVal != null && !rtnVal.contains("ERROR")) {
					String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
					if(approvalFlag.equals("S")) {
						String domain = request.getServerName() + ":" + request.getServerPort();
				        String scheme = "http://";
						
				    	if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
				    		scheme = "https://";
				    	}
						rtnVal = mApprovalGService.insertSeumyungdateMobile(docId, realPath, userInfo.getOffSet(), new Locale(locale), domain, scheme, userInfo.getCompanyId(), userInfo.getTenantId());
					}
				}
				
				if (rtnVal != null && !rtnVal.contains("ERROR")) {
					result.put("status", "ok");
					result.put("code", "0");
					result.put("data", "SUCCESS");
				} else {
					result.put("status", "ok");
					result.put("code", "2");
					result.put("data", "FAIL");
				}
			} else if (type.equals("BAN")) {
			    String lineMode = ezApprovalGService.getLineModeFlag(docId, userInfo.getUserId(), userInfo.getCompanyId(), userInfo.getTenantId());
			    if(approvalGDocInfoVO.getHref().endsWith("mht")) {
			    	rtnVal = ezApprovalGService.mobileSrvConn(userId, "B", approvalGDocInfoVO.getFormID(), "", docId, approvalGDocInfoVO.getAprMemberID(), optionInfo.getLang(), userInfo.getCompanyId(), request, loginVO, lineMode, aprMemberSN);
			    } else {
			    	rtnVal = ezApprovalGService.mobileSrvConn_HWP(userId, "B", approvalGDocInfoVO.getFormID(), "", docId, approvalGDocInfoVO.getAprMemberID(), optionInfo.getLang(), userInfo.getCompanyId(), request, loginVO, lineMode, aprMemberSN);
				}
				
//				String pBansongDeptID = ezApprovalGService.getBansongDeptID(docId, userInfo.getCompanyId(), userInfo.getTenantId(), loginVO);
				
//				rtnVal = ezApprovalGService.doBansong(docId, "", approvalGDocInfoVO.getAprMemberID(), "004", realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator, pBansongDeptID, userInfo.getCompanyId(), optionInfo.getLang(), loginVO, "");
				
				if (rtnVal != null && !rtnVal.contains("ERROR")) {
//				    if (rtnVal != null && !rtnVal.equals("FALSE")) {
					result.put("status", "ok");
					result.put("code", "0");
					result.put("data", "SUCCESS");
				} else {
					result.put("status", "ok");
					result.put("code", "2");
					result.put("data", "FAIL");
				}
			} else if (type.equals("BO")) {
				rtnVal = ezApprovalGService.doBoryu(docId, approvalGDocInfoVO.getAprMemberID(), "005", userInfo.getCompanyId(), optionInfo.getLang(), userInfo.getTenantId(), userInfo.getUserName(), "");
				
				if (rtnVal != null && !rtnVal.equals("FALSE")) {
					result.put("status", "ok");
					result.put("code", "0");
					result.put("data", "SUCCESS");
				} else {
					result.put("status", "ok");
					result.put("code", "2");
					result.put("data", "FAIL");
				}
			} else if (type.equals("HWE")) {
				/* 2021-08-18 홍승비 - 회수메일 발송 시점은 회수동작 이전이 되도록 수정 (현재 결재진행(승인)상태인 참조자와 결재자에게 메일을 보내야 하므로) */
				mApprovalGService.sendApproveNoticeMail(userInfo, optionInfo, approvalGDocInfoVO, docId, type);
				
				rtnVal = ezApprovalGService.doCallBack(docId, userId, userInfo.getCompanyId(), userInfo.getTenantId(), "");
				
				if (rtnVal != null && !rtnVal.equals("<RESULT>FALSE</RESULT>")) {
					result.put("status", "ok");
					result.put("code", "0");
					result.put("data", "SUCCESS");
				} else {
					result.put("status", "ok");
					result.put("code", "2");
					result.put("data", "FAIL");
				}
			} else if (type.equals("CHECK")) {
				rtnVal = ezApprovalGService.doApprove(docId, approvalGDocInfoVO.getAprMemberID(), "003", approvalGDocInfoVO.getAprMemberName(), approvalGDocInfoVO.getAprMemberName2(), realPath + approvalGDocInfoVO.getHref(), approvalGDocInfoVO.getAprMemberDeptID(), userInfo.getUserId(), userInfo.getCompanyId(), optionInfo.getLang(), loginVO, "", "017", "", "", "");
				
				if (rtnVal != null && !rtnVal.equals("FALSE")) {
					result.put("status", "ok");
					result.put("code", "0");
					result.put("data", "SUCCESS");
				} else {
					result.put("status", "ok");
					result.put("code", "2");
					result.put("data", "FAIL");
				}
			} else if (type.equals("GR")) {
				rtnVal = ezApprovalGService.gongRamUpdate(docId, userInfo.getUserId(), userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId());
				
				if (rtnVal != null && !rtnVal.equals("FALSE")) {
					result.put("status", "ok");
					result.put("code", "0");
					result.put("data", "SUCCESS");
				} else {
					result.put("status", "ok");
					result.put("code", "2");
					result.put("data", "FAIL");
				}
			} else {
				//오류
				result.put("status", "error");
				result.put("code", "1");
			}

			// 회수알림메일의 경우, 회수동작 이전에 결재진행(승인)상태인 결재자 및 참조자에게 메일을 발송하므로 예외처리함
            if (!type.equals("HWE") && "SUCCESS".equals(result.get("data"))) {
                mApprovalGService.sendApproveNoticeMail(userInfo, optionInfo, approvalGDocInfoVO, docId, type);
            }
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", "1");
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/approve/" + type + "] ended.");
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/left-count/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalLeftCount(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/left-count/users/" + userId + "] started.");

		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			MApprovalGLeftVO approvalGLeftVO = mApprovalGService.getLeftCount(userId, userInfo);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", approvalGLeftVO);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/left-count/users/" + userId + "] ended.");
		
		return result;
	}
	
	//pAprMemberSN  가져오기 메일에서 전자결재
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/AprMemberSN/{docId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getAprMemberSN(@PathVariable String docId, HttpServletRequest request, Locale locale) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/AprMemberSN/" + docId + "] started.");

		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String DocID = request.getParameter("DocID");
			String type = request.getParameter("type");
			String serverName = request.getHeader("x-user-host");
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			logger.debug("type : " + type);
			logger.debug("DocID : " + DocID);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			@SuppressWarnings("unused")
			MOptionVO optionInfo = mOptionService.optionInfo(userId, userInfo.getTenantId());
			
			@SuppressWarnings("unused")
			String domain = request.getServerName() + ":" + request.getServerPort();
	        @SuppressWarnings("unused")
			String scheme = "http://";
			
	    	if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
	    		scheme = "https://";
	    	}
			//결재문서정보
			MApprovalGDocInfoVO approvalGDocInfoVO = mApprovalGService.getAprMemberSn(docId, type, userInfo);
			
			JSONObject totalData = new JSONObject();
			
			totalData.put("docInfo", approvalGDocInfoVO);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", totalData);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/AprMemberSN/" + docId + "] ended.");
		
		return result;
	}

	//결재가 처리 됬는지의 유무 확인
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/AprMemberSN/{docId}/checkAprState", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCheckAprState(@PathVariable String docId, HttpServletRequest request, Locale locale) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/AprMemberSN/" + docId + "/checkAprState] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String userId = request.getParameter("userId");
			String aprMemberSN = request.getParameter("aprMemberSN");
			String mode = request.getParameter("mode");
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			String companyID = request.getParameter("companyID");
			if (companyID != null && !companyID.equals("") && !companyID.equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(companyID);
			}
			
			if (mode == null || mode.equals("")) {
				mode = "APR";
			}
			
			int rtnValue = mApprovalGService.getCheckAprState(docId, userId, aprMemberSN, mode, userInfo.getCompanyId(), userInfo.getTenantId());
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", rtnValue == 0 ? "FALSE" : "TRUE");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/AprMemberSN/" + docId + "/checkAprState] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [POST] 기안
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/gwDraft", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject gwDraft(@RequestBody JSONObject jsonParam, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [POST /mobile/ezapproval/gwDraft" + " started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = jsonParam.get("userId").toString();
			String serverName = request.getHeader("x-user-host");
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);

			String realPath = commonUtil.getRealPath(request);
			
			result = mApprovalGService.gwDraft(jsonParam, realPath, userInfo);
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			result.put("message", "geDraft controller error");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [POST /mobile/ezapproval/gwDraft" + " ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [GET] 전자결재문서 접근가능여부 리턴 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/checkAccessYNG", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject checkAccessYNG(@PathVariable String docId, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/checkAccessYNG] started.");

		JSONObject result = new JSONObject();
		
		try {
			String userID = request.getParameter("userID");
			String companyID = request.getParameter("companyID");
			String lang = request.getParameter("lang");
			int tenantID = Integer.parseInt(request.getParameter("tenantID"));
			String accessInfo = request.getParameter("accessInfo");
			String serverName = request.getHeader("x-user-host");
			String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", tenantID);
			String pass = "";
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userID);
			
			if (companyID != null && !companyID.equals("") && !companyID.equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(companyID);
			}
			
			if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("m=1") == -1) {
				pass = ezApprovalGService.getAccessYNG(docId, userID, accessInfo, companyID, lang, userInfo.getTenantId(), approvalFlag, userInfo.getDeptId());
			} else {
				pass = "<RESULT>TRUE</RESULT>";
			}
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", pass);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/checkAccessYNG] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [GET] 전달받은 문서ID, 결재순번으로 현재 결재자가 대리결재를 진행하는지 확인 -> 대리결재라면 원결재자의 이름을 리턴하고 아니라면 공백을 리턴
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/checkProxyDoc", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject checkProxyDoc(@PathVariable String docId, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/checkProxyDoc] started.");

		JSONObject result = new JSONObject();
		
		try {
			String userID = request.getParameter("userID");
			String companyID = request.getParameter("companyID");
			String lang = request.getParameter("lang");
			int tenantID = Integer.parseInt(request.getParameter("tenantID"));
			String aprMemberSN = request.getParameter("aprMemberSN");
			String orgAprUserName = "";
			
			HashMap<String, Object> orgAprUserInfo = mApprovalGService.getAprMemberBySn(docId, aprMemberSN, commonUtil.getMultiData(lang, tenantID), companyID, tenantID);
			
			if (!orgAprUserInfo.get("APRMEMBERID").equals(userID)) {
				orgAprUserName = orgAprUserInfo.get("APRMEMBERNAME").toString();
			}
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", orgAprUserName);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/checkProxyDoc] ended.");
		
		return result;
	}
	
	/**
	 * 2022-02-23 홍승비 - 모바일 G/W 전자결재 [GET] 전달받은 문서ID로 해당 문서가 일괄기안된 문서인지 확인하여 리턴 (Y/N)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/checkIsGroupDoc", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject checkIsGroupDoc(@PathVariable String docId, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/checkIsGroupDoc] started.");

		JSONObject result = new JSONObject();
		
		try {
			String userID = request.getParameter("userID");
			String docID = request.getParameter("docID");
			String companyID = request.getParameter("companyID");
			int tenantID = Integer.parseInt(request.getParameter("tenantID"));
			
			String chkResult = ezApprovalGService.checkIsGroupDoc(userID, docID, companyID, tenantID);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", chkResult);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/checkIsGroupDoc] ended.");
		
		return result;
	}
	
	@RequestMapping(value = "/mobile/ezApprovalG/getAprDocInfoForLink.do", method = RequestMethod.GET)
	@SuppressWarnings("unchecked")
	@ResponseBody
	public JSONObject getAprDocInfoForLink(HttpServletRequest request) throws Exception {
		logger.debug("getAprDocInfoForLink (Controller) started");
		JSONObject result = new JSONObject ();
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			String docID = request.getParameter("docId");
			String companyID = request.getParameter("companyId");
			String mode = "ING";
			int tenantID = userInfo.getTenantId();
			ApprGDocListVO apprGDocInfo = ezApprovalGService.getDocInfoForNoti(companyID, docID, tenantID, mode);
			
			if (apprGDocInfo != null) {
				ApprGDocListVO apprGMemberSnVO = ezApprovalGService.getAprMemberSnForNoti(companyID, docID, tenantID, userId);
				if (apprGMemberSnVO != null) {
					apprGDocInfo.setAprMemberSN(apprGMemberSnVO.getAprMemberSN());
					apprGDocInfo.setAprState(apprGMemberSnVO.getAprState());
				}
			}
			
			if (apprGDocInfo == null) {
				mode = "END";
				apprGDocInfo = ezApprovalGService.getDocInfoForNoti(companyID, docID, tenantID, mode);
			}
			
			if (apprGDocInfo == null) {
				mode = "ERROR";
				result.put("status", "error");
				result.put("data", null);
				logger.debug("getAprDocInfoForLink (Controller) ended, result = " + result);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("mode", mode);
			result.put("data", apprGDocInfo);
			result.put("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
			result.put("relayG_type", ezCommonService.getTenantConfig("UserInfo_RelayG_Type", userInfo.getTenantId()));
			result.put("approvalFlag", ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId()));
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", null);
		}
		logger.debug("getAprDocInfoForLink (Controller) ended, result = " + result);
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [POST] 공람문서 회수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/gongram/cancel/{docId:.+}", method = RequestMethod.POST)
	public JSONObject mCancelGongram(@PathVariable String docId, HttpServletRequest request, Locale locale) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [POST /mobile/ezapproval/gongram/cancel/" + docId + "] started.");

		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String aprMemberSN = request.getParameter("aprMemberSN");
			String count = request.getParameter("count");
			String serverName = request.getHeader("x-user-host");
			String companyID = request.getParameter("companyID");
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			String res = mApprovalGService.gongRamCancel(docId, Integer.parseInt(count), Integer.parseInt(aprMemberSN), companyID, userInfo.getTenantId());
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", res);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "] ended.");
		
		return result;
	}
}
