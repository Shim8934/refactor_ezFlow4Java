package egovframework.ezMobile.ezOrgan.web;

import java.net.URLDecoder;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.ezMobile.ezOrgan.service.MOrganService;
import egovframework.ezMobile.ezOrgan.vo.MOrganListVO;
import egovframework.ezMobile.ezOrgan.vo.MPersonListVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@RestController
public class MOrganGWController {
	private static final Logger logger = LoggerFactory.getLogger(MOrganGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name = "MOrganService")
	private MOrganService mOrganService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	/**
	 * 모바일 G/W 직원조회 [GET] 직원 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezorgan/personlist", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getPersonList(HttpServletRequest request, Model model) {		
		logger.debug("MOBILE G/W ORGAN [GET /ezorgan/personlist] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userID = request.getParameter("userID");
			String pSearchText = request.getParameter("pSearchText");
			String rowNum = request.getParameter("rowNum");
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userID);
			String filePath = commonUtil.getUploadPath("upload_personal.PHOTO", info.getTenantId()) + commonUtil.separator;
			String companyId = info.getCompanyId();
			
			String useShowAllCompanies = ezCommonService.getTenantConfig("useShowAllCompanies", info.getTenantId());
			
	        // useShowAllCompanies가 YES이면 Company ID를 ""로 세트하여 그룹사 전체 조직도를 대상으로 검색하도록 한다.			
			if (useShowAllCompanies.equals("YES")) {
				companyId = "";
			}
			
			pSearchText = pSearchText.replace("%", "\\%").replace("_", "\\_");
			List <MPersonListVO> list = mOrganService.getPersonList(companyId, info.getTenantId(),pSearchText,rowNum);
			int listCount = mOrganService.getPersonListCount(companyId, info.getTenantId(), pSearchText);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", list);
			result.put("filePath", filePath);
			result.put("listCount", listCount);
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			result.put("listCount", "");
		}
		logger.debug("MOBILE G/W BOARD [GET /ezorgan/personlist] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 직원조회 [GET] 직원 상세정보
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezorgan/personDetail", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getPersonInfo(HttpServletRequest request, Model model) {		
		logger.debug("MOBILE G/W ORGAN [GET /ezorgan/personDetail] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userID = request.getParameter("userID");
			String serverName = request.getHeader("x-user-host");
			String primaryLang = request.getParameter("primaryLang");
			primaryLang = (primaryLang == null || primaryLang.equals("")) ? "1" : primaryLang;
			String deptID = request.getParameter("deptID");
			String type= request.getParameter("type");
			MCommonVO info = mOptionService.commonInfo(serverName, userID);
			String filePath = commonUtil.getUploadPath("upload_personal.PHOTO", info.getTenantId()) + commonUtil.separator;
			String imgSrc = "";
			String jobID = request.getParameter("jobID");
			
			MPersonListVO personInfo = mOrganService.getPersonInfo(userID, info.getTenantId(), primaryLang);
			
			if (type.equalsIgnoreCase("addJobUser")) {
				MPersonListVO addJobDept = mOrganService.getUserAddjobInfo(userID, deptID, primaryLang, info.getTenantId(), jobID);
				personInfo.setCompany(addJobDept.getCompany());
				personInfo.setDescription(addJobDept.getDescription());
				personInfo.setTitle(addJobDept.getTitle());
				personInfo.setExtensionAttribute10(addJobDept.getRole());
			} 
			
			if (personInfo.getExtensionAttribute2() != null && !personInfo.getExtensionAttribute2().equals("")) {
				imgSrc = filePath + personInfo.getExtensionAttribute2();
			} else {
				imgSrc = "";
			}
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", personInfo);
			result.put("imgSrc", imgSrc);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		logger.debug("MOBILE G/W BOARD [GET /ezorgan/personDetail] ended.");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezorgan/dept-info/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mGetDeptInfo(HttpServletRequest request, @PathVariable String userId) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezorgan/dept-info/users/" + userId + "] started.");

		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String organType = request.getParameter("organType");
			String userSearch = request.getParameter("userSearch");
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			logger.debug("organType : " + organType);
			logger.debug("userSearch : " + userSearch);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			MOptionVO optionInfo = mOptionService.optionInfo(userId, userInfo.getTenantId());

			List<MOrganListVO> mOrganListVOs = mOrganService.getDeptInfo(organType, userInfo.getCompanyId(), userInfo.getDeptId(), optionInfo.getLang(), userInfo.getTenantId(), userSearch);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", mOrganListVOs);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezorgan/dept-info/users/" + userId + "] ended.");
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezorgan/low-dept-info/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mGetLowDeptInfo(HttpServletRequest request, @PathVariable String userId) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezorgan/low-dept-info/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String deptID = request.getParameter("deptID");
			String userSearch = request.getParameter("userSearch");
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			logger.debug("deptID : " + deptID);
			logger.debug("userSearch : " + userSearch);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			MOptionVO optionInfo = mOptionService.optionInfo(userId, userInfo.getTenantId());
			
			List<MOrganListVO> mOrganListVOs = mOrganService.getLowDeptInfo(deptID, optionInfo.getLang(), userInfo.getTenantId(), userSearch);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", mOrganListVOs);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezorgan/low-dept-info/users/" + userId + "] ended.");
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezorgan/high-dept-info/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mGetHighDeptInfo(HttpServletRequest request, @PathVariable String userId) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezorgan/high-dept-info/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String deptID = request.getParameter("deptID");
			String deptType = request.getParameter("deptType");
			String organType = request.getParameter("organType");
			String userSearch = request.getParameter("userSearch");
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			logger.debug("deptID : " + deptID);
			logger.debug("userSearch : " + userSearch);
			
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			MOptionVO optionInfo = mOptionService.optionInfo(userId, userInfo.getTenantId());
			
			List<MOrganListVO> mOrganListVOs = mOrganService.getHighDeptInfo(deptID, deptType, organType, optionInfo.getLang(), userInfo.getCompanyId(), userInfo.getTenantId(), userSearch);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", mOrganListVOs);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezorgan/high-dept-info/users/" + userId + "] ended.");
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezorgan/depts/{deptID}/userList", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mGetDeptMemberList(HttpServletRequest request, @PathVariable String deptID) {
		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezorgan/depts/" + deptID + "/userList] started.");

		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userID");
			String searchFlag = request.getParameter("searchFlag");
			String selectType = request.getParameter("selectType");
			String companyId = request.getParameter("companyId");
			String userSearch = request.getParameter("userSearch");

			// 2024.09.25 한슬기 : deptId가 한글로 들어올 경우 한글 꺠짐 현상이 있어 url 인코딩하여 전달받음.
			String decodedDeptId = URLDecoder.decode(deptID, "UTF-8");
			
			logger.debug("serverName : " + serverName);
			logger.debug("userId : " + userId);
			logger.debug("selectType : " + selectType);
			logger.debug("searchFlag : " + searchFlag);
			logger.debug("companyId : " + companyId);
			logger.debug("userSearch : " + userSearch);

			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			MOptionVO optionInfo = mOptionService.optionInfo(userId, userInfo.getTenantId());
			
			List<MOrganListVO> mOrganListVOs = mOrganService.getDeptMemberList(decodedDeptId.trim(), searchFlag, selectType, optionInfo.getLang(), userInfo.getTenantId(), companyId, userSearch);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", mOrganListVOs);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", "1");
		}		

		logger.debug("MOBILE G/W APPROVAL [GET /mobile/ezorgan/depts/" + deptID + "/userList] ended.");
		
		return result;
	}
}
