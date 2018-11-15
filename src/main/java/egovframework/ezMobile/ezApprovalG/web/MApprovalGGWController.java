package egovframework.ezMobile.ezApprovalG.web;

import java.security.PrivateKey;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezMobile.ezApprovalG.service.MApprovalGService;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAbsenteeInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAprLineInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAttachInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGDocInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGLeftVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGOpinionInfoVO;
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
	private static final Logger LOGGER = LoggerFactory.getLogger(MApprovalGGWController.class);
	
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
	@RequestMapping(value = "/mobile/ezapproval/main-list/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")	
	public JSONObject mApprovalMainList(@PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/main-list/users/" + userId + "] started.");

		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String listSize = "10"; //리스트사이즈 임시로 10개 차후 디비에서 가져와야함
			String lastDate = commonUtil.getTodayUTCTime("");
			
			LOGGER.debug("listSize : " + listSize);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			List<MApprovalGDocInfoVO> approvalGDocInfoVOs = mApprovalGService.getDoApproveList(userInfo, "DO", "", listSize, lastDate);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", approvalGDocInfoVOs);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}

		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/main-list/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [GET] 결재문서 리스트 (결재할(DO), 결재한(END), 결재진행(ING), 기안한(DRAFT), 공유결재(SHARE))
	 */
	@RequestMapping(value = "/mobile/ezapproval/{type}/list/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalList(@PathVariable String type, @PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/" + type + "/list/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String searchText = request.getParameter("searchText");
			String listSize = request.getParameter("listSize");
			String lastDate = request.getParameter("lastDate");
			String serverName = request.getHeader("x-user-host");
			
			LOGGER.debug("searchText : " + searchText);
			LOGGER.debug("listSize : " + listSize);
			LOGGER.debug("lastDate : " + lastDate);
			
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
			
			JSONObject totalData = new JSONObject();
			
			totalData.put("docInfos", approvalGDocInfoVOs);
			totalData.put("lastDate", lastDate);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", totalData);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/" + type + "/list/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [GET] 결재문서 카운트 (결재할(DO), 결재한(END), 결재진행(ING), 기안한(DRAFT), 공유결재(SHARE))
	 */
	@RequestMapping(value = "/mobile/ezapproval/{type}/list-count/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalListCount(@PathVariable String type, @PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/" + type + "/list-count/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String searchText = request.getParameter("searchText");
			String serverName = request.getHeader("x-user-host");
			
			LOGGER.debug("serverName : " + serverName);
			LOGGER.debug("searchText : " + searchText);
			
			searchText = searchText.replace("%", "\\%").replace("_", "\\_");
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			int listCount = mApprovalGService.getDoApproveListCount(userInfo, type, searchText);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", listCount);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/" + type + "/list-count/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [GET] 문서보기
	 */
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalDoc(@PathVariable String docId, HttpServletRequest request, Locale locale) {
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "] started.");

		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String type = request.getParameter("type");
			String aprMemberSN = request.getParameter("aprMemberSN");
			String mode = request.getParameter("mode");
			String serverName = request.getHeader("x-user-host");
			
			LOGGER.debug("serverName : " + serverName);
			LOGGER.debug("userId : " + userId);
			LOGGER.debug("type : " + type);
			LOGGER.debug("mode : " + mode);
			
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
			MApprovalGDocInfoVO approvalGDocInfoVO = mApprovalGService.getAprDocInfo(docId, type, optionInfo.getLang(), userInfo.getCompanyId(), userInfo.getTenantId(), aprMemberSN, mode);
			//회수 가능여부
			String callBackYN = ezApprovalGService.getCallBackYN(docId, userId, userInfo.getCompanyId(), userInfo.getTenantId());
			
			// 20180824 조진호 - 모바일 viewerflag 값 추가
        	String useMobileViewer = ezCommonService.getTenantConfig("useMobileViewer", userInfo.getTenantId());
        	
			JSONObject totalData = new JSONObject();
			
			totalData.put("bodyHTML", bodyHTML);
			totalData.put("docInfo", approvalGDocInfoVO);
			totalData.put("callBackYN", callBackYN);
			totalData.put("useMobileViewer", useMobileViewer);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", totalData);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [GET] 결재라인 리스트
	 */
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/line-list", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalLineList(@PathVariable String docId, HttpServletRequest request) {
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/line-list] started.");

		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String type = request.getParameter("type");
			String mode = request.getParameter("mode");
			String serverName = request.getHeader("x-user-host");
			String companyID = request.getParameter("companyID");
			
			LOGGER.debug("serverName : " + serverName);
			LOGGER.debug("userId : " + userId);
			LOGGER.debug("type : " + type);
			LOGGER.debug("mode : " + mode);
			
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
		}

		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/line-list] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [GET] 의견 카운트
	 */
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/opinion-count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalOpinionCount(@PathVariable String docId, HttpServletRequest request) {
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/opinion-count] started.");

		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			String type = request.getParameter("type");
			String mode = request.getParameter("mode");
			
			LOGGER.debug("serverName : " + serverName);
			LOGGER.debug("userId : " + userId);
			LOGGER.debug("type : " + type);
			LOGGER.debug("mode : " + mode);
			
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
		}

		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/opinion-count] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [GET] 첨부파일 리스트
	 */
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/attach-list", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalAttachList(@PathVariable String docId, HttpServletRequest request) {
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/attach-list] started.");

		JSONObject result = new JSONObject();
		
		try {
			String type = request.getParameter("type");
			String mode = request.getParameter("mode");
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			
			LOGGER.debug("serverName : " + serverName);
			LOGGER.debug("userId : " + userId);
			LOGGER.debug("type : " + type);
			LOGGER.debug("mode : " + mode);
			
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
		}

		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/attach-list] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [GET] 의견보기
	 */
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/opinion", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalOpinionInfo(@PathVariable String docId, HttpServletRequest request) {
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/opinion] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			String type = request.getParameter("type");
			String mode = request.getParameter("mode");
			
			LOGGER.debug("serverName : " + serverName);
			LOGGER.debug("userId : " + userId);
			LOGGER.debug("mode : " + mode);
			
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
		}

		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/opinion] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [POST] 의견쓰기
	 */
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/opinion", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalInsertOpinionInfo(@PathVariable String docId, HttpServletRequest request) {
		LOGGER.debug("MOBILE G/W APPROVAL [POST /mobile/ezapproval/docs/" + docId + "/opinion] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String content = request.getParameter("content");
			String opinionGB = request.getParameter("opinionGB");
			String serverName = request.getHeader("x-user-host");
			
			LOGGER.debug("serverName : " + serverName);
			LOGGER.debug("userId : " + userId);
			LOGGER.debug("content : " + content);
			LOGGER.debug("opinionGB : " + opinionGB);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			String companyID = request.getParameter("companyID");
			if (companyID != null && !companyID.equals("") && !companyID.equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(companyID);
			}
			
			int resultCode = mApprovalGService.mSetOpinionInfo(docId, content, opinionGB, userInfo, "INSERT");
			
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
		}

		LOGGER.debug("MOBILE G/W APPROVAL [POST /mobile/ezapproval/docs/" + docId + "/opinion] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [PUT] 의견수정
	 */
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/opinion", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalUpdateOpinionInfo(@PathVariable String docId, HttpServletRequest request) {
		LOGGER.debug("MOBILE G/W APPROVAL [PUT /mobile/ezapproval/docs/" + docId + "/opinion] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String content = request.getParameter("content");
			String opinionGB = request.getParameter("opinionGB");
			String serverName = request.getHeader("x-user-host");
			
			LOGGER.debug("serverName : " + serverName);
			LOGGER.debug("userId : " + userId);
			LOGGER.debug("content : " + content);
			LOGGER.debug("opinionGB : " + opinionGB);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			String companyID = request.getParameter("companyID");
			if (companyID != null && !companyID.equals("") && !companyID.equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(companyID);
			}
			
			mApprovalGService.mSetOpinionInfo(docId, content, opinionGB, userInfo, "UPDATE");
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		LOGGER.debug("MOBILE G/W APPROVAL [PUT /mobile/ezapproval/docs/" + docId + "/opinion] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [DELETE] 의견삭제
	 */
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/opinion", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalDeleteOpinionInfo(@PathVariable String docId, HttpServletRequest request) {
		LOGGER.debug("MOBILE G/W APPROVAL [DELETE /mobile/ezapproval/docs/" + docId + "/opinion] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			
			LOGGER.debug("serverName : " + serverName);
			LOGGER.debug("userId : " + userId);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			String companyID = request.getParameter("companyID");
			if (companyID != null && !companyID.equals("") && !companyID.equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(companyID);
			}
			
			mApprovalGService.mSetOpinionInfo(docId, "", "", userInfo, "DELETE");
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		LOGGER.debug("MOBILE G/W APPROVAL [DELETE /mobile/ezapproval/docs/" + docId + "/opinion] ended.");
		
		return result;
	}

	/**
	 * 모바일 G/W 전자결재 [GET] 부재자설정 보기
	 */
	@RequestMapping(value = "/mobile/ezapproval/absentee/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalAbsenteeInfo(@PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/absentee/users/" + userId + "] started.");

		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			
			LOGGER.debug("serverName : " + serverName);
			LOGGER.debug("userId : " + userId);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			MApprovalGAbsenteeInfoVO absenteeInfoVO = mApprovalGService.getAbsenteeInfo(userInfo);
			
			if (absenteeInfoVO.getAbsenteeId() != null && !absenteeInfoVO.getAbsenteeId().equals("")) {
				result.put("status", "ok");
				result.put("code", "0");
				result.put("data", absenteeInfoVO);
			} else {
				result.put("status", "ok");
				result.put("code", "2");
				result.put("data", "");
			}
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}	

		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/absentee/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [PUT] 부재자설정 등록
	 */
	@RequestMapping(value = "/mobile/ezapproval/absentee/users/{userId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalSetAbsenteeInfo(@PathVariable String userId, HttpServletRequest request, MApprovalGAbsenteeInfoVO absenteeInfoVO) {
		LOGGER.debug("MOBILE G/W APPROVAL [PUT /mobile/ezapproval/absentee/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			
			LOGGER.debug("serverName : " + serverName);
			LOGGER.debug("userId : " + userId);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			absenteeInfoVO.setUserId(userInfo.getUserId());
			absenteeInfoVO.setTenantId(userInfo.getTenantId());
			
			int resultCode = mApprovalGService.setAbsenteeInfo(absenteeInfoVO);
			
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
		}
		
		LOGGER.debug("MOBILE G/W APPROVAL [PUT /mobile/ezapproval/absentee/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [DELETE] 부재자설정 삭제
	 */
	@RequestMapping(value = "/mobile/ezapproval/absentee/users/{userId}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalDelAbsenteeInfo(@PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("MOBILE G/W APPROVAL [DELETE /mobile/ezapproval/absentee/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			
			LOGGER.debug("serverName : " + serverName);
			LOGGER.debug("userId : " + userId);
			
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
		}
		
		LOGGER.debug("MOBILE G/W APPROVAL [DELETE /mobile/ezapproval/absentee/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [GET] 비밀번호 확인
	 */
	@RequestMapping(value = "/mobile/ezapproval/pwd-check/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalCheckPassword(@PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/pwd-check/users/" + userId + "] started.");

		JSONObject result = new JSONObject();
		
		try {
			String rsaEncPassword = request.getParameter("password");
			String serverName = request.getHeader("x-user-host");
			
			LOGGER.debug("serverName : " + serverName);
			LOGGER.debug("userId : " + userId);
			
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
		}

		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/pwd-check/users/" + userId + "] ended.");
		
		return result;
	}

	/**
	 * 모바일 G/W 전자결재 [PUT] 결재(APR), 반송(BAN), 보류(BO), 회수(HWE), 확인(CHECK)
	 */
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/approve/{type}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalDoApprove(@PathVariable String docId, @PathVariable String type, HttpServletRequest request) {
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/approve/" + type + "] started.");

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
			
			LOGGER.debug("serverName : " + serverName);
			LOGGER.debug("userId : " + userId);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			MOptionVO optionInfo = mOptionService.optionInfo(userId, userInfo.getTenantId());
			
			String companyID = request.getParameter("companyID");
			if (companyID != null && !companyID.equals("") && !companyID.equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(companyID);
			}
			
			String rtnVal = "";
			
			//docId로만 정보 가져오기
			MApprovalGDocInfoVO approvalGDocInfoVO = mApprovalGService.getAprDocInfo(docId, "DO", optionInfo.getLang(), userInfo.getCompanyId(), userInfo.getTenantId(), aprMemberSN, mode);
			
			LoginVO loginVO = new LoginVO();
			
			loginVO.setId(userId);
			loginVO.setCompanyID(userInfo.getCompanyId());
			loginVO.setTenantId(userInfo.getTenantId());
			loginVO.setOffset(userInfo.getOffSet());
			loginVO.setLocale(new Locale(locale));
			loginVO.setLang(optionInfo.getLang());
			loginVO.setDeptID(userInfo.getDeptId());
			loginVO.setDeptName(userInfo.getDeptName());
			
			if (type.equals("APR")) {
				String lineMode = ezApprovalGService.getLineModeFlag(docId, userInfo.getUserId(), userInfo.getCompanyId(), userInfo.getTenantId());
				
				rtnVal = ezApprovalGService.mobileSrvConn(userId, "A", approvalGDocInfoVO.getFormID(), "", docId, approvalGDocInfoVO.getAprMemberID(), optionInfo.getLang(), userInfo.getCompanyId(), request, loginVO, lineMode);
				
				if (rtnVal != null && !rtnVal.equals("ERROR")) {
					result.put("status", "ok");
					result.put("code", "0");
					result.put("data", "SUCCESS");
				} else {
					result.put("status", "ok");
					result.put("code", "2");
					result.put("data", "FAIL");
				}
			} else if (type.equals("BAN")) {
				rtnVal = ezApprovalGService.doBansong(docId, "", approvalGDocInfoVO.getAprMemberID(), "004", realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator, userInfo.getDeptId(), userInfo.getCompanyId(), optionInfo.getLang(), loginVO, "");
				
				if (rtnVal != null && !rtnVal.equals("FALSE")) {
					result.put("status", "ok");
					result.put("code", "0");
					result.put("data", "SUCCESS");
				} else {
					result.put("status", "ok");
					result.put("code", "2");
					result.put("data", "FAIL");
				}
			} else if (type.equals("BO")) {
				rtnVal = ezApprovalGService.doBoryu(docId, approvalGDocInfoVO.getAprMemberID(), "005", userInfo.getCompanyId(), optionInfo.getLang(), userInfo.getTenantId());
				
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
				rtnVal = ezApprovalGService.doCallBack(docId, userId, userInfo.getCompanyId(), userInfo.getTenantId());
				
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
				rtnVal = ezApprovalGService.doApprove(docId, approvalGDocInfoVO.getAprMemberID(), "003", approvalGDocInfoVO.getAprMemberName(), approvalGDocInfoVO.getAprMemberName2(), realPath + approvalGDocInfoVO.getHref(), approvalGDocInfoVO.getAprMemberDeptID(), userInfo.getUserId(), userInfo.getCompanyId(), optionInfo.getLang(), loginVO, "", "017", "");
				
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
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", "1");
		}

		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/approve/" + type + "] ended.");
		
		return result;
	}
	
	@RequestMapping(value = "/mobile/ezapproval/left-count/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalLeftCount(@PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/left-count/users/" + userId + "] started.");

		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			
			LOGGER.debug("serverName : " + serverName);
			LOGGER.debug("userId : " + userId);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			MApprovalGLeftVO approvalGLeftVO = mApprovalGService.getLeftCount(userId, userInfo);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", approvalGLeftVO);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}

		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/left-count/users/" + userId + "] ended.");
		
		return result;
	}
	
	//pAprMemberSN  가져오기 메일에서 전자결재
	@RequestMapping(value = "/mobile/ezapproval/AprMemberSN/{docId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getAprMemberSN(@PathVariable String docId, HttpServletRequest request, Locale locale) {
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/AprMemberSN/" + docId + "] started.");

		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String DocID = request.getParameter("DocID");
			String type = request.getParameter("type");
			String serverName = request.getHeader("x-user-host");
			
			LOGGER.debug("serverName : " + serverName);
			LOGGER.debug("userId : " + userId);
			LOGGER.debug("type : " + type);
			LOGGER.debug("DocID : " + DocID);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			MOptionVO optionInfo = mOptionService.optionInfo(userId, userInfo.getTenantId());
			
			String realPath = commonUtil.getRealPath(request);
			String domain = request.getServerName() + ":" + request.getServerPort();
	        String scheme = "http://";
			
	    	if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
	    		scheme = "https://";
	    	}
			//결재문서정보
			MApprovalGDocInfoVO approvalGDocInfoVO = mApprovalGService.getAprMemberSn(docId, type,userInfo.getCompanyId(), userInfo.getTenantId());
			
			JSONObject totalData = new JSONObject();
			
			totalData.put("docInfo", approvalGDocInfoVO);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", totalData);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/AprMemberSN/" + docId + "] ended.");
		
		return result;
	}

	//결재가 처리 됬는지의 유무 확인
	@RequestMapping(value = "/mobile/ezapproval/AprMemberSN/{docId}/checkAprState", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCheckAprState(@PathVariable String docId, HttpServletRequest request, Locale locale) {
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/AprMemberSN/" + docId + "/checkAprState] started.");
		
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
		}
		LOGGER.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/AprMemberSN/" + docId + "/checkAprState] ended.");
		return result;
	}
}
