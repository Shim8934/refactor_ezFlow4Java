package egovframework.ezMobile.ezApprovalG.web;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.nio.file.Paths;
import java.security.PrivateKey;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ArrayList;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import com.fasterxml.jackson.databind.ObjectMapper;
import egovframework.ezEKP.ezApprovalG.vo.ApprGGroupDocInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.*;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;

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
import org.jsoup.Jsoup;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.w3c.dom.Document;
import org.apache.commons.io.FileUtils;

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
import egovframework.let.utl.fcc.service.EgovDateUtil;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

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

	@Resource(name = "EzApprovalGAdminService")
	private EzApprovalGAdminService ezApprovalGAdminService;

	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;

	@Resource(name = "EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
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

			List<ApprGGroupDocInfoVO> groupInfo = ezApprovalGService.getGroupDocList(docId, "APR", userInfo.getTenantId(), companyID);
			
			JSONObject totalData = new JSONObject();
			
			totalData.put("bodyHTML", bodyHTML);
			totalData.put("docInfo", approvalGDocInfoVO);
			totalData.put("callBackYN", callBackYN);
			totalData.put("useMobileViewer", useMobileViewer);
			totalData.put("approvalFlag", approvalFlag);
			totalData.put("groupInfo", groupInfo);
			totalData.put("draftAllTypeB", ezCommonService.getTenantConfig("draftAllTypeB", userInfo.getTenantId()));
			
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
				
				/* 일괄결재 보류 DB 백단 처리 */
				List<ApprGGroupDocInfoVO> groupDocList = ezApprovalGService.getGroupDocList(docId, "APR", userInfo.getTenantId(), companyID);
				if(groupDocList.size() > 1){
					for(int i = 1; i < groupDocList.size(); i++){
						rtnVal = ezApprovalGService.doBoryu(groupDocList.get(i).getDocID(), approvalGDocInfoVO.getAprMemberID(), "005", userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getUserName(), "");
					}
				}
				
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

				/* 일괄기안 DB 백단 처리 */
				List<ApprGGroupDocInfoVO> groupDocList = ezApprovalGService.getGroupDocList(docId, "APR", userInfo.getTenantId(), companyID);
				if(groupDocList.size() > 1){
					for(int i = 1; i < groupDocList.size(); i++){
						rtnVal = ezApprovalGService.doCallBack(groupDocList.get(i).getDocID(), userId, userInfo.getCompanyId(), userInfo.getTenantId(), "");
					}
				}
				
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

				/* 일괄기안 DB 백단 처리 */
				List<ApprGGroupDocInfoVO> groupDocList = ezApprovalGService.getGroupDocList(docId, "APR", userInfo.getTenantId(), companyID);
				if(groupDocList.size() > 1){
					for(int i = 1; i < groupDocList.size(); i++){
						rtnVal = ezApprovalGService.doApprove(groupDocList.get(i).getDocID(), approvalGDocInfoVO.getAprMemberID(), "003", approvalGDocInfoVO.getAprMemberName(), approvalGDocInfoVO.getAprMemberName2(), realPath + groupDocList.get(i).getDocHref(), approvalGDocInfoVO.getAprMemberDeptID(), userInfo.getUserId(), userInfo.getCompanyId(), optionInfo.getLang(), loginVO, "", "017", "", "", "");
					}
				}
				
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
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			MOptionVO optionInfo = mOptionService.optionInfo(userId, userInfo.getTenantId());

			String realPath = commonUtil.getRealPath(request);
			
//			result = mApprovalGService.gwDraft(jsonParam, realPath, userInfo);
			

			if (request.getParameter("companyId") != null && !request.getParameter("companyId").isEmpty()) {
				userInfo.setCompanyId(request.getParameter("companyId"));
			}
			String locale = request.getParameter("locale");
			String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
			if ("S".equals(approvalFlag)) { // 모바일 기안하기는 S버전만 지원

				String propName = "displayName;mail;description;company;facsimileTelephoneNumber;telephoneNumber;streetaddress;postalcode";
				String userInfoXML = ezOrganService.getPropertyList(userId, propName, userInfo.getPrimary(), userInfo.getTenantId());
				
				Document xmlDom = commonUtil.convertStringToDocument(jsonParam.get("docinfo").toString());
				String pDocID = xmlDom.getElementsByTagName("DOCID").item(0).getTextContent();
				String pFormID = xmlDom.getElementsByTagName("FORMID").item(0).getTextContent();
				String puserID = xmlDom.getElementsByTagName("PUSERID").item(0).getTextContent();
				String pdeptid = xmlDom.getElementsByTagName("PDEPTID").item(0).getTextContent();
				String pDeptName = xmlDom.getElementsByTagName("PDEPTNAME").item(0).getTextContent();
				String lineMode = "APR";
				
				LoginVO loginVO = new LoginVO();
				loginVO.setId(userId);
				loginVO.setCompanyID(userInfo.getCompanyId());
				loginVO.setTenantId(userInfo.getTenantId());
				loginVO.setOffset(userInfo.getOffSet());
				loginVO.setLocale(new Locale(locale));
				loginVO.setLang(optionInfo.getLang());
				loginVO.setDeptID(pdeptid);
				loginVO.setDeptName(pDeptName);
				loginVO.setDisplayName(userInfo.getUserName());
				loginVO.setPrimary(commonUtil.getPrimaryData(loginVO.getLang(), loginVO.getTenantId()));
				loginVO.setEmail(userInfo.getEmail());

				MApprovalGDocInfoVO approvalGDocInfoVO = null;
				String rtnVal = "";
				// 문서 생성
				rtnVal = mApprovalGService.saveDraftInfo(jsonParam, realPath, loginVO, userInfoXML, request);
				if (rtnVal != null && !rtnVal.isEmpty() && !rtnVal.contains("ERROR")) {
					approvalGDocInfoVO = mApprovalGService.getAprDocInfo(pDocID, "DO", optionInfo.getLang(), userInfo.getOffSet(), userInfo.getCompanyId(), userInfo.getTenantId(), "1", "APR");
					// 기안결재
					rtnVal = ezApprovalGService.mobileSrvConn(userId, "A", pFormID, "", pDocID, puserID, optionInfo.getLang(), userInfo.getCompanyId(), request, loginVO, lineMode, "1");
				}

				//2020-07-02 홍승비 - 모바일에서 최종결재 완료 시 서명에 결재날짜 삽입 동작 추가(결재날짜 필드가 없는 경우에만, 웹과 동일하게) 
				if (rtnVal != null && !rtnVal.isEmpty() && !rtnVal.contains("ERROR")) {
					if(approvalFlag.equals("S")) {
						String domain = request.getServerName() + ":" + request.getServerPort();
						String scheme = "http://";
						if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
							scheme = "https://";
						}
						rtnVal = mApprovalGService.insertSeumyungdateMobile(pDocID, realPath, userInfo.getOffSet(), new Locale(locale), domain, scheme, userInfo.getCompanyId(), userInfo.getTenantId());

						// 메일 발송
						mApprovalGService.sendApproveNoticeMail(userInfo, optionInfo, approvalGDocInfoVO, pDocID, "APR");
					}
				}

				if (rtnVal != null && !rtnVal.isEmpty() && !rtnVal.contains("ERROR")) {
					result.put("status", "ok");
					result.put("code", "0");
					result.put("data", "SUCCESS");
				} else {
					result.put("status", "ok");
					result.put("code", "2");
					result.put("data", "FAIL");
				}
			} else { // G버전에서 접근 시 에러 표출
				result.put("status", "ok");
				result.put("code", "3");
				result.put("data", "FAIL");
			}
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
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

	/**
	 * 모바일 G/W 전자결재 [GET] 기안 양식함 보기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/mGetFormContainer", method = RequestMethod.GET)
	public JSONObject getFormContainer(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mGetFormContainer] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String companyID = request.getParameter("companyId");
			String id = request.getParameter("id");
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			String deptID = (request.getParameter("deptID") != null && !request.getParameter("deptID").isEmpty()) ? request.getParameter("deptID") : userInfo.getDeptId();
			String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

			// 양식함
			String formContainerInfo = ezApprovalGService.getFormContainerInfo(id, deptID, companyID, userInfo.getPrimary(), userInfo.getTenantId(), approvalFlag);

			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", formContainerInfo);
			result.put("approvalFlag", approvalFlag);

		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mGetFormContainer] ended.");

		return result;
	}

	/**
	 * 모바일 G/W 전자결재 [GET] 기안 양식 보기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/mGetForm", method = RequestMethod.GET)
	public JSONObject getForm(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mGetForm] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String companyID = request.getParameter("companyId");
			String id = request.getParameter("id");
			String kind = request.getParameter("kind") != null ? request.getParameter("kind") : "000";

			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			String deptID = request.getParameter("deptID") != null ? request.getParameter("deptID") : userInfo.getDeptId();

			// 양식함
			String formInfo = mApprovalGService.getForm(id, kind, "", "", userId, deptID, companyID, userInfo.getLang(), userInfo.getTenantId());

			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", formInfo);

		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mGetForm] ended.");

		return result;
	}

	/**
	 * 모바일 G/W 전자결재 [GET] 기안창 보기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/mDraftui", method = RequestMethod.GET)
	public JSONObject getDraftui(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mDraftui] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String deptID = request.getParameter("deptID");
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			MOptionVO optionInfo = mOptionService.optionInfo(userId, userInfo.getTenantId());
			String locale = request.getParameter("locale");
			String formID = request.getParameter("formID");
			String formURL = request.getParameter("formURL");
			String formDocType = request.getParameter("formDocType");
			String realPath = commonUtil.getRealPath(request);
			
			if (!deptID.isEmpty()) {
				userInfo.setDeptId(deptID);
			}
			
			if (!locale.isEmpty()) {
				userInfo.setLocale(new Locale(locale));
			}

			// docid 생성
			String docid = ezApprovalGService.createNewDoc(formID, userInfo.getCompanyId(),userInfo.getTenantId());

			// 가변결재선 사용 여부 컨피그
			String useDynamicAprLine = ezCommonService.getTenantConfig("UseDynamicAprLine", userInfo.getTenantId()); //가변 결재선 사용여부 - 1(사용) / 0(사용안함)


			// 상위부서문서함 사용 시 관련 정보 같이 전달
			String upperDeptCode = "";
			String upperDeptName = "";
			Map<String, String> upDeptInfo = ezApprovalGService.getUpperDeptInfo(userInfo.getDeptId(), userInfo.getTenantId());
			if (upDeptInfo.get("USEUPPERDEPTBOX") != null && upDeptInfo.get("USEUPPERDEPTBOX").equals("Y")) {
				upperDeptCode = upDeptInfo.get("upperDeptCode");
				upperDeptName = upDeptInfo.get("upperDeptName");
			}
			
			// 문서번호 사용
			// 부서명
			String pDeptID = userInfo.getDeptId();
			if (upperDeptCode != "") {
				pDeptID = upperDeptCode;
			}
			String chaebunDeptID = ezApprovalGService.getChaebunDept(pDeptID, userInfo.getCompanyId(), userInfo.getTenantId());
			if(chaebunDeptID != null) {
				pDeptID = chaebunDeptID;
			}
			String infoXML = ezOrganService.getPropertyList(pDeptID, "displayName;extensionAttribute6;cn", userInfo.getPrimary(), userInfo.getTenantId());
			org.w3c.dom.Document infoXMLDom = commonUtil.convertStringToDocument(infoXML);
			String deptSymbol = infoXMLDom.getDocumentElement().getChildNodes().item(0).getTextContent();
			String accountingYear = ezApprovalGService.getAccountingYear(commonUtil.getTodayUTCTime(""), userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId());
			
			

			// 양식에서 정보 가져오기
			String doctitle = "";
			String susinFlag = "N";
			int hapyuiCount = 0;
			int signCount = 0;
			String docnumberFormat = "";
			String bedocnumberFormat = "";
			String deptshortednameFormat = "";
			String docTitleUseYN = "Y";
			String docBodyUseYN = "Y";
			List<Map<String, Object>> formFieldList = new ArrayList<>();
			// 문서 제목 가져오기
			if (formURL.endsWith("mht")) {
				String loadMht = ezCommonService.loadMHTFile(realPath + formURL); // 양식 가져오기
				// HTML -> MHT
				String content = ezCommonService.startMHT2HTML(realPath + commonUtil.getUploadPath("config.LocalPath", userInfo.getTenantId()), loadMht, realPath + commonUtil.getUploadPath("config.LocalPath", userInfo.getTenantId()), realPath, userInfo.getLocale(), "", "");
				//HTML 파싱 document 클래스 겹쳐서 임포트 못함
				org.jsoup.nodes.Document doc = Jsoup.parse(content);
				Element titleElement = doc.getElementById("doctitle");
				if (titleElement != null) {
					doctitle = titleElement.text().trim();
					if (!doctitle.isEmpty() && !titleElement.hasAttr("free")) {
						docTitleUseYN = "N";
					}
				}
				
				// 수신 여부
				susinFlag = doc.getElementById("recipient") != null ? "Y" : "N";
				// 양식의 필드 리스트 가져오기
				hapyuiCount = doc.select("[id^=habyuisign]").size();
				signCount = doc.select("[id^=sign]").size();
				
				// 가변 결재선일 때 최대 사인칸 10개로 고정 - 가변결재선 기안은 미구현된 상태
				if ("1".equals(useDynamicAprLine) && doc.getElementById("autoLine") != null) {
					hapyuiCount = 10;
					signCount = 10;
					if ("003".equals(formDocType)) {//가변결재선 양식으로 수신문을 사용하는경우, 양식내에 수신처란이 없어도 수신문으로 인식되도록
						susinFlag = "Y";
					}
				}

				// 문서번호 형식
				Element docnumberEl = doc.getElementById("docnumber");
				Element bedocnumberEl = doc.getElementById("bedocnumber");
				Element deptshortednameEl = doc.getElementById("deptshortedname");
				docnumberFormat = docnumberEl != null ? docnumberEl.text() : "";
				bedocnumberFormat = bedocnumberEl != null ? bedocnumberEl.text() : "";
				deptshortednameFormat = deptshortednameEl != null ? (deptSymbol + ":") : "";

				// body 필드 영역 확인
				Element bodyElement = doc.select("#body.FIELD").first();
				if (bodyElement != null) {
					String bodyElStyle = bodyElement.attr("style");
					if (!bodyElStyle.isEmpty() && bodyElStyle.replaceAll("\\s+", "").contains("display:none")) {
						docBodyUseYN = "N";
					}
				} else {
					docBodyUseYN = "N";
				}
				
				// 2025-09-10 김유진 - id가 m_Name, m_ValText, m_ValDate 로 시작하는 필드값을 받아 입력화면 생성
				Elements mFields = doc.select("[id^=m_Name].FIELD");
				if (!mFields.isEmpty()) {
					Elements  fields;
					String fieldId;
					int fieldNo;
					String fieldNoStr;
					
					for (Element field : mFields) {
						Map<String, Object> fieldMap = new HashMap<>();
						int fieldValCnt = 0;
						String valueType = "single";
						
						fieldId = field.id();
						fieldNoStr = fieldId.length() > 6 ? fieldId.substring(6) : "";

						if (!fieldNoStr.isEmpty() && fieldNoStr.matches("\\d+")) {
							fieldNo = Integer.parseInt(fieldNoStr);
						} else {
							break;
						}
						
						fieldMap.put(fieldId, field.text().trim());

						fields = doc.select("[id~=^m_ValText" + fieldNo + "(_.*)?$].FIELD");
						for (Element field2 : fields) {
							fieldMap.put(field2.id(), field2.text().trim());
							fieldValCnt++;
						}

						fields = doc.select("[id~=^m_ValDate" + fieldNo + "(_.*)?$].FIELD");
						for (Element field2 : fields) {
							fieldMap.put(field2.id(), field2.text().trim());
							fieldValCnt++;
						}
						
						if (fieldValCnt > 1) {
							valueType = "multi";
						}
						fieldMap.put("valueType", valueType);
						formFieldList.add(fieldMap);
					}
				}
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

			// 자동 분류코드 가져오기
			String autoDocNumItem = ezApprovalGService.getAutoDocNumItem(formID, userInfo.getLang(), userInfo.getCompanyId(), userInfo.getTenantId());
			
			String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
			String optSignDateFormat = ezApprovalGService.getOptionInfo("A15", "002", loginVO, "CODE");
			String optisSplit = ezApprovalGService.getOptionInfo("SA33", "001", loginVO, "CODE");
			String optSplitKind = ezApprovalGService.getOptionInfo("A33", "002", loginVO, "CODE");
			String sihangURL = ezApprovalGService.getOptionInfo("A36", "004", loginVO, "CODE");
			String susinAdmin = "";
			if (userInfo.getRollInfo() != null && userInfo.getRollInfo().indexOf("a=1") > -1) {
				susinAdmin = "YES";
			} else {
				susinAdmin = "NO";
			}
			String junGyulFlag = ezCommonService.getTenantConfig("JunGyulFlag", userInfo.getTenantId());
			String draftJunGyulFlag = ezCommonService.getTenantConfig("draftJunGyulFlag", userInfo.getTenantId());
			String addLastKyulJeYN = ezCommonService.getTenantConfig("addLastKyulJeYN", userInfo.getTenantId());
			String chamjoAfterYN = ezCommonService.getTenantConfig("chamjoAfterYN", userInfo.getTenantId());
			
			//결재 세부정보
			String formAprOption = ezApprovalGService.getFormAprOptionInfo(formID, "FORM", loginVO.getCompanyID(), userInfo.getTenantId());
			String useReceiveInfoName = ezCommonService.getTenantConfig("useReceiveInfoName", userInfo.getTenantId());
			String formRecvApr = ezApprovalGService.getFormRecvApr(docid, formID, userInfo.getUserId(), userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId(), useReceiveInfoName);

			// 결재정보 호출
			String securityNode3 = mApprovalGService.getSecurityType("", userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag);
			// 보존기간
			String periodnode = mApprovalGService.getKeepType(userInfo.getLang(),userInfo.getTenantId(), userInfo.getCompanyId());


			// 첨부파일
			String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
			String apprTotalAttachLimit = ezCommonService.getTenantConfig("ApprTotalAttachLimit", userInfo.getTenantId()); // 전자결재 총 첨부용량
			String apprAttachLimit = ezCommonService.getTenantConfig("ApprAttachLimit", userInfo.getTenantId()); // 일반 첨부파일의 총 크기제한 = 일반 첨부파일 -> 대용량으로 변경되는 기준 크기
			String bigSizeApprAttachLimit = ezCommonService.getTenantConfig("BigSizeApprAttachLimit", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 크기제한
			String bigSizeAttachLimitCount = ezCommonService.getTenantConfig("ApprBigSizeAttachLimitCount", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 개수제한
			String bigSizeAttachDownloadLimitCount = ezCommonService.getTenantConfig("ApprBigSizeAttachDownloadLimitCount", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 다운로드 횟수제한
			String bigAttachDownloadDay = ezCommonService.getTenantConfig("BigSizeApprAttachDelDay", userInfo.getTenantId()); // 전자결재 대용량 첨부파일 보존기간
			String bigAttachDownloadPeriod = EgovDateUtil.getToday("/") + " ~ " + EgovDateUtil.addDay(EgovDateUtil.getToday("/"), Integer.parseInt(bigAttachDownloadDay), "yyyy/MM/dd");

			// 2020-12-30 김민성 - 시행문 양식인 경우 첨부파일 6MB로 제한
			boolean isOuterForm = ezApprovalGService.isOuterForm(formID, userInfo.getCompanyId(), userInfo.getTenantId());
			if(isOuterForm) {
				bigSizeApprAttachLimit = "0";
				apprTotalAttachLimit = "20";
				apprAttachLimit = "20";
			}

			// 문서첨부
			String openYear = ezCommonService.getTenantConfig("Site_OpenYear", userInfo.getTenantId());

			// 최근 결재선
			String aprlineInfo = ezApprovalGService.getAprLineInfo(docid.trim(), userId, formID, userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffSet(), "DRAFT", "", "", "", "");

			String aprTypeXML = ezApprovalGService.getAprType(approvalFlag, userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId());

			// 최근 수신처, 고정 수신처
			String receiptInfo = "";
			if ("Y".equals(susinFlag)) {
				String mode = "COD"; // 결재진행문서
				String isUsed = "";
				receiptInfo = ezApprovalGService.getReceiptInfo(docid, mode, "", "", userInfo.getCompanyId(), userInfo.getLang(),userInfo.getTenantId(), userInfo.getOffSet(), approvalFlag, isUsed, userInfo.getLocale());
			}

			
			// 유저정보
			Map<String, String> userInfoMap = new HashMap<>();
			userInfoMap.put("userId", userInfo.getUserId());
			userInfoMap.put("userName1", userInfo.getUserName());
			userInfoMap.put("userName2", userInfo.getUserName2());
			userInfoMap.put("deptId", userInfo.getDeptId());
			userInfoMap.put("deptName1", userInfo.getDeptName());
			userInfoMap.put("deptName2", userInfo.getDeptName2());
			userInfoMap.put("title1", userInfo.getTitle());
			userInfoMap.put("title2", userInfo.getTitle2());
			userInfoMap.put("jobId", userInfo.getJobId()); // 직위
			userInfoMap.put("roleId", userInfo.getRoleId()); // 직책
			userInfoMap.put("email", userInfo.getEmail());
			userInfoMap.put("companyId", userInfo.getCompanyId());
			if (userInfo.getPrimary().equals("1")) {
				userInfoMap.put("title", userInfo.getTitle());
				userInfoMap.put("userName", userInfo.getUserName());
				userInfoMap.put("deptName", userInfo.getDeptName());
			} else {
				userInfoMap.put("title", userInfo.getTitle2());
				userInfoMap.put("userName", userInfo.getUserName2());
				userInfoMap.put("deptName", userInfo.getDeptName2());
			}

			
			JSONObject totalData = new JSONObject();

			totalData.put("userInfoMap", userInfoMap);
			totalData.put("docid", docid);
			totalData.put("doctitle", doctitle);
			totalData.put("susinFlag", susinFlag);
			totalData.put("hapyuiCount", hapyuiCount);
			totalData.put("signCount", signCount);
			totalData.put("upperDeptCode", upperDeptCode);
			totalData.put("upperDeptName", upperDeptName);
			totalData.put("autoDocNumItem", autoDocNumItem);
			totalData.put("draftJunGyulFlag", draftJunGyulFlag);
			totalData.put("aprlineInfo", aprlineInfo);
			totalData.put("aprTypeXML", aprTypeXML);
			totalData.put("receiptInfo", receiptInfo);
			totalData.put("approvalFlag", approvalFlag);
			totalData.put("optSignDateFormat", optSignDateFormat);
			totalData.put("optisSplit", optisSplit);
			totalData.put("optSplitKind", optSplitKind);
			totalData.put("sihangURL", sihangURL);
			totalData.put("susinAdmin", susinAdmin);
			totalData.put("formURL", formURL);
			totalData.put("formDocType", formDocType);
			totalData.put("junGyulFlag", junGyulFlag);
			totalData.put("formAprOption", formAprOption);
			totalData.put("useReceiveInfoName", useReceiveInfoName);
			totalData.put("useDynamicAprLine", useDynamicAprLine);
			totalData.put("securityNode3", securityNode3);
			totalData.put("periodnode", periodnode);
			// 채번
			totalData.put("deptSymbol", deptSymbol);
			totalData.put("accountingYear", accountingYear);
			totalData.put("docnumberFormat", docnumberFormat);
			totalData.put("bedocnumberFormat", bedocnumberFormat);
			totalData.put("deptshortednameFormat", deptshortednameFormat);
			// 첨부 관련 정보
			totalData.put("attachFileNameMaxLength", attachFileNameMaxLength);
			totalData.put("apprTotalAttachLimit", apprTotalAttachLimit);
			totalData.put("apprAttachLimit", apprAttachLimit);
			totalData.put("bigSizeApprAttachLimit", bigSizeApprAttachLimit);
			totalData.put("bigSizeAttachLimitCount", bigSizeAttachLimitCount);
			totalData.put("bigAttachDownloadPeriod", bigAttachDownloadPeriod); // 다운로드 기간
			totalData.put("bigAttachDownloadDay", bigAttachDownloadDay); // 보관되는 일수
			totalData.put("bigSizeAttachDownloadLimitCount", bigSizeAttachDownloadLimitCount); // 다운로드 횟수
			totalData.put("isOuterForm", isOuterForm);
			totalData.put("addLastKyulJeYN", addLastKyulJeYN);
			totalData.put("chamjoAfterYN", chamjoAfterYN);
			// 문서첨부
			totalData.put("openYear", openYear);
			totalData.put("nowDateUTC", commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffSet(), false));

			totalData.put("docTitleUseYN", docTitleUseYN);
			totalData.put("docBodyUseYN", docBodyUseYN);
			ObjectMapper objectMapper = new ObjectMapper();
			String jsonFormFieldList = objectMapper.writeValueAsString(formFieldList);
			totalData.put("jsonFormFieldList", jsonFormFieldList);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", totalData);

		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mDraftui] ended.");

		return result;
	}

	/**
	 * 모바일 G/W 전자결재 [GET] 분류코드
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/mTaskCategoryTreeInfo", method = RequestMethod.GET)
	public JSONObject getTaskCategoryTreeInfo(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mTaskCategoryTreeInfo] started.");

		JSONObject result = new JSONObject();
		JSONObject totalData = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);

			String code = request.getParameter("code");
			String level = request.getParameter("level");
			String orgCompanyID = request.getParameter("orgCompanyID");

			if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(orgCompanyID);
			}
			Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(userInfo.getLang()));

			MOptionVO optionInfo = mOptionService.optionInfo(userId, userInfo.getTenantId());
			LoginVO loginVO = new LoginVO();
			loginVO.setId(userId);
			loginVO.setCompanyID(userInfo.getCompanyId());
			loginVO.setTenantId(userInfo.getTenantId());
			loginVO.setOffset(userInfo.getOffSet());
			loginVO.setLocale(locale);
			loginVO.setLang(optionInfo.getLang());
			loginVO.setDeptID(userInfo.getDeptId());
			loginVO.setDeptName(userInfo.getDeptName());
			loginVO.setDisplayName(userInfo.getUserName());
			loginVO.setPrimary(commonUtil.getPrimaryData(loginVO.getLang(), loginVO.getTenantId()));
			loginVO.setEmail(userInfo.getEmail());

			// 분류폴더
			String taskCodeTree = ezApprovalGService.getCodeTreeInfo(code, level, loginVO);
			totalData.put("taskCodeTree", taskCodeTree);
			
			// 분류코드 즐겨찾기
			String taskCodeFrequencyList = ezApprovalGService.getFrequencyClassList(loginVO);
			totalData.put("taskCodeFrequencyList", taskCodeFrequencyList);
			

			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", totalData);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mTaskCategoryTreeInfo] ended.");
		return result;
	}

	/**
	 * 모바일 G/W 전자결재 [GET] 분류코드 서브
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/mSubTaskCategoryTreeInfo", method = RequestMethod.GET)
	public JSONObject getSubTaskCategoryTreeInfo(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mSubTaskCategoryTreeInfo] started.");
		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);

			String code = request.getParameter("code");
			String level = request.getParameter("level");
			Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(userInfo.getLang()));
			
			MOptionVO optionInfo = mOptionService.optionInfo(userId, userInfo.getTenantId());
			LoginVO loginVO = new LoginVO();
			loginVO.setId(userId);
			loginVO.setCompanyID(userInfo.getCompanyId());
			loginVO.setTenantId(userInfo.getTenantId());
			loginVO.setOffset(userInfo.getOffSet());
			loginVO.setLocale(locale);
			loginVO.setLang(optionInfo.getLang());
			loginVO.setDeptID(userInfo.getDeptId());
			loginVO.setDeptName(userInfo.getDeptName());
			loginVO.setDisplayName(userInfo.getUserName());
			loginVO.setPrimary(commonUtil.getPrimaryData(loginVO.getLang(), loginVO.getTenantId()));
			loginVO.setEmail(userInfo.getEmail());
			
			String taskCodeSubTree = ezApprovalGService.getCodeSubTreeInfo(code, level, loginVO);

			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", taskCodeSubTree);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mSubTaskCategoryTreeInfo] ended.");
		return result;
	}

	/**
	 * 모바일 G/W 전자결재 [GET] 분류코드 목록
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/mTaskCategoryInfo", method = RequestMethod.GET)
	public JSONObject getTaskCategoryInfo(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mTaskCategoryInfo] started.");
		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			String sCategoryCode = request.getParameter("sCateCode");
			String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
			String companyID = request.getParameter("companyID");
			String userFlag = request.getParameter("userFlag");
			String orgCompanyID = request.getParameter("orgCompanyID");

			if (companyID == null || companyID.equals("")) {
				companyID = userInfo.getCompanyId();
			}

			if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(companyID)) {
				companyID = orgCompanyID;
			}

			String data = ezApprovalGAdminService.getTaskInSubCategoryForManage(sCategoryCode, userInfo.getLang(), companyID, userInfo.getTenantId(), approvalFlag, userFlag);

			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mTaskCategoryInfo] ended.");
		return result;
	}

	/**
	 * 모바일 G/W 전자결재 [GET] 분류코드 검색
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/mSearchTaskCategoryInfo", method = RequestMethod.GET)
	public JSONObject getSearchTaskCategoryInfo(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mSearchTaskCategoryInfo] started.");
		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
			String orgCompanyID = request.getParameter("orgCompanyID");

			String deptCode = request.getParameter("deptCode") != null ? request.getParameter("deptCode").trim() : "";
			String title = request.getParameter("title") != null ? request.getParameter("title").trim() : "";
			String langType = request.getParameter("lang") != null ? request.getParameter("lang") : "";

			if (orgCompanyID != null && !orgCompanyID.equals("") && !orgCompanyID.equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(orgCompanyID);
			}

			String data  = ezApprovalGService.findTaskS(deptCode, title, userInfo.getCompanyId(), langType, userInfo.getTenantId(), approvalFlag);


			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mSearchTaskCategoryInfo] ended.");
		return result;
	}

	/** 첨부파일 시작 */
	public static final int BUFF_SIZE = 2048;
	public void mobileWriteUploadedFile(MultipartFile file, String newName, String stordFilePath) throws Exception {
		InputStream stream = null;
		OutputStream bos = null;
		String stordFilePathReal = (stordFilePath==null?"":stordFilePath);

		try {
			stream = file.getInputStream();
			File cFile = new File(stordFilePathReal);

			if (!cFile.isDirectory()) {
				boolean _flag = cFile.mkdirs();
				if (!_flag) {
					throw new IOException("Directory creation Failed ");
				}
			}

			bos = new FileOutputStream(stordFilePathReal + File.separator + newName);

			int bytesRead = 0;
			byte[] buffer = new byte[BUFF_SIZE];

			while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
		} catch (FileNotFoundException fnfe) {
			logger.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			logger.debug("ioe: {}", ioe);
		} catch (Exception e) {
			logger.debug("e: {}", e);
		} finally {
			if (bos != null) {
				try {
					bos.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
			}
			if (stream != null) {
				try {
					stream.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
			}
		}
	}

	/**
	 * 모바일 G/W 전자결재 첨부파일
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/mFileupload", method = RequestMethod.POST)
	public JSONObject fileupload(MultipartHttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mFileupload] started.");
		JSONObject result = new JSONObject();
		try {
			String userId = request.getParameter("userID");
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);

			String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
			String companyID = request.getParameter("companyID");
			String docID = request.getParameter("docID");
			String maxsize = request.getParameter("maxsize");
			String fileAttachSN = Integer.toString(mApprovalGService.getAttachFileMaxSn(docID, userInfo.getTenantId(), companyID) + 1);
			String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
			String oldYear = ezApprovalGService.getDocHrefYear(docID, companyID, userInfo.getTenantId());

			if (useExtension == null) {
				useExtension = "";
			}

			// uploadFile, tempUploadFile 디렉토리 경로
			String upd = dirPath + companyID + commonUtil.separator + "uploadFile" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(docID) + commonUtil.separator;
			String tempUpd = dirPath + companyID + commonUtil.separator + "tempUploadFile" + commonUtil.separator;
			File uFile = new File(commonUtil.detectPathTraversal(upd));
			File tFile = new File(commonUtil.detectPathTraversal(tempUpd));

			if (!tFile.isDirectory()) {
				tFile.mkdirs();
			}

			if (!uFile.isDirectory()) {
				uFile.mkdirs();
			}

			List<MultipartFile> multiFile = request.getFiles("fileToUpload");
			int cnt = !multiFile.isEmpty() ? multiFile.size() : 0;

			if (cnt == 0) {
				logger.debug("NODATA, cnt={}", cnt);

				result.put("status", "error");
				result.put("code", 1);
				result.put("data", "");

				return result;
			}

			String[] resultUploadArray = new String[cnt];
			String[] fileLocationArray = new String[cnt];
			String[] fileNameArray = new String[cnt];
			int[] fileSizeArray = new int[cnt];
			String[] saveFileNameArry = new String[cnt];

			for (int i = 0; i < cnt; i++) {
				String fileName = URLDecoder.decode(multiFile.get(i).getOriginalFilename(), "UTF-8");

				int fileSize = (int) multiFile.get(i).getSize();
				int maxSize = 0;

				if (request.getParameter("maxsize") != null) {
					maxSize = Integer.parseInt(request.getParameter("maxsize"));
				}

				if (fileName.indexOf("\\") > -1) {
					fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
				}

				fileNameArray[i] = fileName;
				fileSizeArray[i] = fileSize;

				// 첨부파일 순번 설정 4자리
				String fileAttachFormatSN = "00000" + fileAttachSN;
				fileAttachFormatSN = fileAttachFormatSN.substring(fileAttachFormatSN.length() - 4, fileAttachFormatSN.length());

				String saveFileName = docID + fileAttachFormatSN + fileName;

				/* 2022-03-17 홍승비 - maxSize가 0인 경우, 전자결재 첨부파일 총용량제한은 무제한으로 취급 */
				if (maxSize != 0 && fileSize > maxSize) {
					resultUploadArray[i] = "overflow";
				} else {
					// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
					String extStr = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();

					// 첨부파일의 확장자가 useExtension에 포함되지 않은경우
					if ((extStr.isEmpty() || useExtension.toLowerCase().indexOf(extStr) == -1) && !useExtension.equals("*")) {
						resultUploadArray[i] = "denied";
					} else {
						// tempUploadFile에 파일 생성
						mobileWriteUploadedFile(multiFile.get(i), saveFileName, tempUpd);

						fileLocationArray[i] = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + companyID + commonUtil.separator + "tempUploadFile" + commonUtil.separator + saveFileName;
						resultUploadArray[i] = "true";
						saveFileNameArry[i] = saveFileName;
						fileAttachSN = Integer.toString(Integer.parseInt(fileAttachSN) + 1);
					}
				}
			}

			StringBuffer strXML = new StringBuffer();

			strXML.append("<ROOT><NODES>");

			for (int i = 0; i < cnt; i++) {
				strXML.append("<NODE><PUPLOADSN><![CDATA[" + saveFileNameArry[i] + "]]></PUPLOADSN>");
				strXML.append("<RESULTUPLOADA><![CDATA[" + resultUploadArray[i] + "]]></RESULTUPLOADA>");
				strXML.append("<PFILENAME><![CDATA[" + fileNameArray[i] + "]]></PFILENAME>");
				strXML.append("<FILESIZE>" + fileSizeArray[i] + "</FILESIZE>");
				strXML.append("<FILELOCATION><![CDATA[" + fileLocationArray[i] + "]]></FILELOCATION>");
				strXML.append("</NODE>");
			}

			strXML.append("</NODES></ROOT>");

			result.put("data", strXML);
			result.put("status", "ok");
			result.put("code", 0);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);

			return result;
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mFileupload] ended.");
		return result;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/mAprAttachSave", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject aprAttachSave(HttpServletRequest request, @RequestBody JSONObject jsonObject) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mAprAttachSave] started.");
		JSONObject result = new JSONObject();
		try {
			String serverName = request.getHeader("x-user-host");
			String userID = request.getParameter("userID");
			String companyID = request.getParameter("companyID");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userID);
			userInfo.setCompanyId(companyID);

			JSONParser jp = new JSONParser();
			JSONObject data = (JSONObject) jp.parse(jsonObject.toJSONString());
			String fileDocID = data.get("docID").toString();

			String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
			String oldYear = ezApprovalGService.getDocHrefYear(fileDocID, userInfo.getCompanyId(), userInfo.getTenantId());
			String upd = dirPath + userInfo.getCompanyId() + commonUtil.separator + "uploadFile" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(fileDocID) + commonUtil.separator;


			String dataArr = data.get("dataArr").toString();
			JSONParser parser = new JSONParser();
			Object obj = parser.parse(dataArr);
			JSONObject jsonObj = (JSONObject) obj;

			for (int i = 0; i < jsonObj.size(); i++) {
				String index = i + "";
				JSONObject json = (JSONObject) parser.parse(jsonObj.get(index).toString());

				String beforePath = commonUtil.getRealPath(request) + commonUtil.detectPathTraversal(json.get("fileLocation").toString());
				String fileName = Paths.get(beforePath).getFileName().toString();
				File beforeFile = new File(beforePath);
				File afterFile = new File(commonUtil.detectPathTraversal(upd + fileName));
				if (FileUtils.contentEquals(beforeFile, afterFile)) {
					continue;
				}
				try {
					if (beforeFile.isFile()) {
						if (beforeFile.exists()) {
							FileUtils.copyFile(beforeFile, afterFile);
						} else {
							throw new FileNotFoundException("not file:" + beforePath);
						}
					} else {
						throw new FileNotFoundException("not file:" + beforePath);
					}
				} catch (Exception e) {
					logger.error("An error occurred while copying files", e);
				}
				json.put("fileLocation", commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyId() + commonUtil.separator + "uploadFile" + commonUtil.separator + oldYear + commonUtil.separator + ezApprovalGService.getDocDir(fileDocID) + commonUtil.separator + fileName);
				jsonObj.put(index, json);
			}
			String rst = "";
			try {
				rst = mApprovalGService.updateAttachFileInfo(fileDocID, jsonObj, userInfo);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				rst = "File_NonAttach";
			}

			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", rst);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mAprAttachSave] ended.");
		return result;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/mUpdateAttachHistory", method = RequestMethod.POST)
	public JSONObject mUpdateAttachHistory(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mUpdateAttachHistory] started.");
		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userID");
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			
			String docID = request.getParameter("docID");
			String attachSN = request.getParameter("attachSN");
			String tempUserID = userId;
			String tempUserName = userInfo.getUserName();
			String tempUserName2 = userInfo.getUserName2();
			String tempUserJobTitle = userInfo.getTitle();
			String tempUserJobTitle2 = userInfo.getTitle2();
			String tempUserDeptID = userInfo.getDeptId();
			String tempUserDeptName = userInfo.getDeptName();
			String tempUserDeptName2 = userInfo.getDeptName2();
			String modifyFlag = request.getParameter("modifyFlag");

			String companyID = request.getParameter("companyID");

			if (companyID != null && !companyID.equals("")) {
				userInfo.setCompanyId(companyID);
			}

			String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
			String rst = ezApprovalGService.updateHistoryForAttach(docID, attachSN, tempUserID, tempUserName, tempUserName2, tempUserJobTitle, tempUserJobTitle2,
					tempUserDeptID, tempUserDeptName, tempUserDeptName2, modifyFlag, dirPath, userInfo.getCompanyId(), userInfo.getTenantId());

			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", rst);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mUpdateAttachHistory] ended.");
		return result;
	}

	/** 첨부파일 끝 */


	/**
	 * 모바일 G/W 전자결재 [GET] 문서첨부 문서타입
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/mDocAttachType", method = RequestMethod.GET)
	public JSONObject getDocAttachType(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mDocAttachType] started.");
		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			String sCategoryCode = request.getParameter("sCateCode");
			String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
			String deptID = userInfo.getDeptId();

			if (request.getParameter("companyID") != null && !request.getParameter("companyID").isEmpty() && !request.getParameter("companyID").equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(request.getParameter("companyID"));
			}

			if (request.getParameter("deptID") != null && !request.getParameter("deptID").isEmpty()) {
				deptID = request.getParameter("deptID");
			}

			String data = ezApprovalGService.getContainerInfoManage(deptID, "XML", userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId());


			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mDocAttachType] ended.");
		return result;
	}

	/**
	 * 모바일 G/W 전자결재 [GET] 문서첨부 문서 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/mDocAttachList", method = RequestMethod.GET)
	public JSONObject getDocAttachList(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mDocAttachList] started.");
		JSONObject result = new JSONObject();

		try {
			String data = "";
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
			String contID = request.getParameter("typeId");
			String pageNum = request.getParameter("pageNum");
			String pageSize = request.getParameter("pageSize");

			// 검색
			String docTitle = request.getParameter("searchText"); // 제목 검색어
			String apprfrom = request.getParameter("apprfrom"); // 완료일자 시작시간
			String apprto = request.getParameter("apprto"); // 완료일자 종료시간
			String searchStatus = "DOCATT";


			if (request.getParameter("companyID") != null && !request.getParameter("companyID").equals("") && !request.getParameter("companyID").equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(request.getParameter("companyID"));
			}
			
			if (!"".equals(docTitle) || !"".equals(apprfrom) || !"".equals(apprto)) {
				data = ezApprovalGService.getSearchDocListS(contID, userId, "", "", docTitle, "", "", "", "", "", apprfrom,
						apprto, "", "", "", "", "", "", "", "", "", pageSize, pageNum, "", "", searchStatus,
						userInfo.getCompanyId(), userInfo.getLang(), "", userInfo.getTenantId(), userInfo.getOffSet(), approvalFlag, userInfo.getLocale());
			} else {
				data = ezApprovalGService.getContDocListS(contID, userId, "", pageSize, pageNum, "", "", userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffSet(), userInfo.getLocale());
			}

			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mDocAttachList] ended.");
		return result;
	}

	/**
	 * 모바일 G/W 전자결재 [POST] 문서첨부 저장
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/mUpdateDocAttach", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject updateDocAttach(HttpServletRequest request, @RequestBody JSONObject jsonObject) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mUpdateDocAttach] started.");
		JSONObject result = new JSONObject();
		try {
			String serverName = request.getHeader("x-user-host");
			String userID = request.getParameter("userID");
			String companyID = request.getParameter("companyID");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userID);
			userInfo.setCompanyId(companyID);

			String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

			String rst = mApprovalGService.updateAttachDocInfo(jsonObject, userInfo, approvalFlag);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", rst);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mUpdateDocAttach] ended.");
		return result;
	}

	/**
	 * 모바일 G/W 전자결재 [GET] 부서확인
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/mCheckDeptAndCabinetId", method = RequestMethod.GET)
	public JSONObject checkDeptAndCabinetId(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mCheckDeptAndCabinetId] started.");
		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			String orgDeptId = request.getParameter("orgDeptId");
			String orgCabinetId = request.getParameter("orgCabinetId");
			String addJobDeptId = request.getParameter("addJobDeptId");
			String userRealDeptId = ezOrganService.getUserOrgDeptId(userInfo.getUserId(), userInfo.getTenantId(), userInfo.getCompanyId());
			String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
			String rtn = "";
			
			if (addJobDeptId != null && !addJobDeptId.isEmpty()) {
				userInfo.setDeptId(addJobDeptId);
			}

			List<OrganUserVO> list = ezOrganAdminService.getUserAddJobList(userInfo.getUserId(), userInfo.getPrimary(), userInfo.getTenantId());

			// 1 : 정상 , 2 : 기록물철 변경, 3 : 겸직변경 필요, 4 : 부서변경 or 겸직삭제
			//기안창의 부서와 현재 유저의 부서정보 비교
			if (userInfo.getDeptId().equals(orgDeptId)) {
				rtn = "1";
				if (!orgCabinetId.equals("") && !orgCabinetId.equals("nonElecRecTempCabinet") && approvalFlag.equals("G")) {
					String cabinetDept = ezApprovalGService.getDeptIdOfCabinet(orgCabinetId, userInfo.getTenantId(), userInfo.getCompanyId()).trim();
					logger.debug("cabinetDept : " + cabinetDept);
					logger.debug("orgDeptId : " + orgDeptId);
					//기안창 부서와 기록물철 부서 정보가 다를경우
					if (!orgDeptId.equals(cabinetDept)) {
						//기록물철 정보를 변경하라는 메세지
						rtn = "2";
					}
				}
			} else {
				//사용자의 원부서와 비교 
				if (orgDeptId.equals(userRealDeptId)) {
					//겸직변경 메세지
					rtn = "3";
				} else {
					// 부서가 변경되거나 겸직부서가 삭제되었습니다 메세지
					rtn = "4";
					for (OrganUserVO userVO : list) {
						if (orgDeptId.equals(userVO.getDepartment())) {
							//겸직부서 변경 메세지
							rtn = "3";
						}
					}
				}
			}

			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", rtn);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mCheckDeptAndCabinetId] ended.");
		return result;
	}

	/**
	 * 모바일 G/W 전자결재 [GET] 부서에 수발신담당자 존재 여부 확인
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/mReceiverChk", method = RequestMethod.GET)
	public JSONObject mReceiverChk(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mReceiverChk] started.");
		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			String deptId = request.getParameter("deptId");

			String rtnVal = ezApprovalGService.receiverChk(deptId, userInfo.getCompanyId(), userInfo.getTenantId());
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", rtnVal);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mReceiverChk] ended.");
		return result;
	}	
	
	/**
	 * 모바일 G/W 전자결재 [GET] 결재암호 사용 여부
	 */
	/*
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/mGetApprovalPWD", method = RequestMethod.GET)
	public JSONObject getApprovalPWD(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mGetApprovalPWD] started.");
		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);

			String rtn = ezApprovalGService.getApprovalPWD(userInfo.getUserId(), userInfo.getTenantId(), userInfo.getCompanyId());

			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", rtn);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/mGetApprovalPWD] ended.");
		return result;
	}
	
	 */

	/**
	 * 모바일 G/W 전자결재 [POST] 결재선 체크 표출
	 */
	@RequestMapping(value = "/mobile/ezapproval/mCheckAprLines", method = RequestMethod.POST)
	public JSONObject mCheckAprLines(@RequestBody Map<String, String> retMap, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [POST /mobile/ezapproval/mCheckAprLines ] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String type = request.getParameter("type");
			String strXML = retMap.get("strXML");
			String serverName = request.getHeader("x-user-host");

			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			MOptionVO optionInfo = mOptionService.optionInfo(userId, userInfo.getTenantId());
			Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(userInfo.getLang()));
			
			LoginVO loginVO = new LoginVO();
			loginVO.setId(userId);
			loginVO.setCompanyID(userInfo.getCompanyId());
			loginVO.setTenantId(userInfo.getTenantId());
			loginVO.setOffset(userInfo.getOffSet());
			loginVO.setLocale(locale);
			loginVO.setLang(optionInfo.getLang());
			loginVO.setDeptID(userInfo.getDeptId());
			loginVO.setDeptName(userInfo.getDeptName());
			loginVO.setDisplayName(userInfo.getUserName());
			loginVO.setPrimary(commonUtil.getPrimaryData(loginVO.getLang(), loginVO.getTenantId()));
			loginVO.setEmail(userInfo.getEmail());

			// 결재선 체크
			Document doc = commonUtil.convertStringToDocument(strXML);
			String chkAprLineResult = "";
			if (type.equals("apr")) {
				chkAprLineResult = ezApprovalGService.chkAprLines(doc, userInfo.getLang(), loginVO);
			} else {
				chkAprLineResult = ezApprovalGService.chkDeptLines(doc, userInfo.getCompanyId(), userInfo.getLang(), loginVO);
			}

			if (!chkAprLineResult.isEmpty() && !"<RESULT></RESULT>".equals(chkAprLineResult)) {
				result.put("status", "ok");
				result.put("code", "2");
				result.put("data", chkAprLineResult);
			} else {
				result.put("status", "ok");
				result.put("code", "0");
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", "1");
		}
		logger.debug("MOBILE G/W APPROVAL [POST /mobile/ezapproval/mCheckAprLines ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [POST] 기안 결재선 저장
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/mAprLineSave", method = RequestMethod.POST)
	public JSONObject mAprLineSave(@RequestBody Map<String, String> retMap, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [POST /mobile/ezapproval/mAprLineSave ] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String strXML = retMap.get("strXML");
			String serverName = request.getHeader("x-user-host");

			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			MOptionVO optionInfo = mOptionService.optionInfo(userId, userInfo.getTenantId());
			Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(userInfo.getLang()));
			
			LoginVO loginVO = new LoginVO();
			loginVO.setId(userId);
			loginVO.setCompanyID(userInfo.getCompanyId());
			loginVO.setTenantId(userInfo.getTenantId());
			loginVO.setOffset(userInfo.getOffSet());
			loginVO.setLocale(locale);
			loginVO.setLang(optionInfo.getLang());
			loginVO.setDeptID(userInfo.getDeptId());
			loginVO.setDeptName(userInfo.getDeptName());
			loginVO.setDisplayName(userInfo.getUserName());
			loginVO.setPrimary(commonUtil.getPrimaryData(loginVO.getLang(), loginVO.getTenantId()));
			loginVO.setEmail(userInfo.getEmail());

			String res = ezApprovalGService.updateLineInfo(strXML, userInfo.getCompanyId(), userInfo.getLang(), loginVO, "");

			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", res);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", "1");
		}
		logger.debug("MOBILE G/W APPROVAL [POST /mobile/ezapproval/mAprLineSave ended.");
		return result;
	}

	/**
	 * 모바일 G/W 전자결재 [POST] 기안 수신처 저장
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/mAprDeptSave", method = RequestMethod.POST)
	public JSONObject mAprDeptSave(@RequestBody Map<String, String> retMap, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [POST /mobile/ezapproval/mAprDeptSave ] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String strXML = retMap.get("strXML");
			String serverName = request.getHeader("x-user-host");

			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());

			String res = ezApprovalGService.updateReceiptInfo(strXML, userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag);

			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", res);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", "1");
		}
		logger.debug("MOBILE G/W APPROVAL [POST /mobile/ezapproval/mAprDeptSave ended.");
		return result;
	}

	/**
	 * 모바일 G/W 전자결재 [POST] 기안 회람 저장
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/mGongRamSave", method = RequestMethod.POST)
	public JSONObject mGongRamSave(@RequestBody Map<String, String> retMap, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W APPROVAL [POST /mobile/ezapproval/mGongRamSave ] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String xmlPara = retMap.get("strXML");
			String type = request.getParameter("type"); // ING 고정으로 들어옴
			String orgCompanyID = request.getParameter("orgCompanyID");
			String serverName = request.getHeader("x-user-host");

			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);

			Document xmlDom = commonUtil.convertStringToDocument(xmlPara);

			String dirPath = commonUtil.getRealPath(request) +  commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator;
			String res = "";

			if (type.equals("ING")) {
				res = ezApprovalGService.gongRamSaveIng(xmlDom, dirPath, userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffSet());
			}
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", res);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", "1");
		}
		logger.debug("MOBILE G/W APPROVAL [POST /mobile/ezapproval/mGongRamSave ended.");
		return result;
	}


	/* 2025/01/22 결재가 백단결재로 실패 이력이 있는지 체크 */ 
	@RequestMapping(value = "/mobile/ezapproval/{docId}/getCheckNotFailDoc", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCheckNotFailDoc(@PathVariable String docId, HttpServletRequest request, Locale locale) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/" + docId + "/getCheckNotFailDoc] started.");

		JSONObject result = new JSONObject();

		try{
			String userId = request.getParameter("userId");
			String aprMemberSN = request.getParameter("aprMemberSN");
			String serverName = request.getHeader("x-user-host");

			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);

			String companyID = request.getParameter("companyID");
			if (companyID != null && !companyID.equals("") && !companyID.equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(companyID);
			}

			boolean rtnValue = ezApprovalGService.getCheckNotFailDoc(docId, companyID, userInfo.getTenantId());

			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", rtnValue ? "TRUE" : "FALSE");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/" + docId + "/getCheckNotFailDoc] ended.");
		return result;
	}
	
	/*
	 * 모바일 G/W 전자결재 [GET] 전달받은 문서ID, 결재순번으로 현재 결재자가 마지막 최종결재를 진행하는지 확인
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezapproval/docs/{docId}/checkLastKyulje", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject checkLastKyulje(@PathVariable String docId, HttpServletRequest request) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/checkLastKyulje] started.");

		JSONObject result = new JSONObject();

		try {
			String userID = request.getParameter("userID");
			String companyID = request.getParameter("companyID");
			String lang = request.getParameter("lang");
			int tenantID = Integer.parseInt(request.getParameter("tenantID"));
			String aprMemberSN = request.getParameter("aprMemberSN");
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userID);
			
			String res = mApprovalGService.checkLastKyulje(docId, aprMemberSN, lang, userInfo.getOffSet(), companyID, tenantID);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", res);
		} catch (Exception e) {
			result.put("status", "error"); 
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezapproval/docs/" + docId + "/checkLastKyulje] ended.");

		return result;
	}
	
}
