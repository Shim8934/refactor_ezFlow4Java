package egovframework.ezEKP.ezJournal.web;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Base64.Decoder;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.type.NotiType;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezJournal.service.EzJournalService;
import egovframework.ezEKP.ezJournal.vo.DeptViewVO;
import egovframework.ezEKP.ezJournal.vo.JournalAuthCheckVO;
import egovframework.ezEKP.ezJournal.vo.JournalAuthorVO;
import egovframework.ezEKP.ezJournal.vo.JournalCompanyVO;
import egovframework.ezEKP.ezJournal.vo.JournalEnvVO;
import egovframework.ezEKP.ezJournal.vo.JournalFileVO;
import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;
import egovframework.ezEKP.ezJournal.vo.JournalReceiverVO;
import egovframework.ezEKP.ezJournal.vo.JournalReplyVO;
import egovframework.ezEKP.ezJournal.vo.JournalVO;
import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;
import egovframework.ezEKP.ezJournal.vo.ReceiverFavoriteVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzJournalGWController {
	private static final Logger logger = LoggerFactory.getLogger(EzJournalGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCommonService ezCommonService;

	@Resource(name="ezJournalService")
	private EzJournalService ezJournalService;

	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Resource(name="EzEmailService")
	private EzEmailService ezEmailService;
	
	@Resource(name="EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name="EzPersonalService")
	private EzPersonalService ezPersonalService;
	
	/**
	 * 업무일지 G/W [POST] 일지함 생성
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezjournal/types", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public Object makeJournalTypeList(HttpServletRequest request) throws Exception {
		logger.debug("G/W JOURNAL [POST /rest/ezjournal/types] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			String companyId = request.getParameter("companyId");
			
			logger.debug("companyId : " + companyId);
			ArrayList<String> typeList = new ArrayList<String>();
			for (int i = 5; i < 11; i++) {
				String num = "";
				if (i < 10) {
					num= "0" + i;
				}else{
					num = i + "";
				}
				typeList.add("ezJournal.t" + num);
			}
			
			ezJournalService.insertJournaltype(companyId, info.getTenantId(), typeList);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("G/W JOURNAL [POST /rest/ezjournal/types] ended.");
		
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 일지함 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezjournal/types", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public Object removeJournalTypeList(HttpServletRequest request) throws Exception {
		logger.debug("G/W JOURNAL [DELETE /rest/ezjournal/types] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			String companyId = request.getParameter("companyId");
			logger.debug("companyId : " + companyId);
			
			ezJournalService.deleteJournaltype(companyId, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("G/W JOURNAL [DELETE /rest/ezjournal/types] ended.");
		
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 일지함 조회 / 사용하는 일지함 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezjournal/types", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public Object journalTypeList(HttpServletRequest request) throws Exception {
		logger.debug("G/W JOURNAL [GET /rest/ezjournal/types] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String used = request.getParameter("used");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			String companyId = request.getParameter("companyId");
			if (companyId == null || companyId.equals("")) {
				companyId = info.getCompanyId();
			}
			
			logger.debug("companyId : " + companyId);

			List<JournaltypeVO> typeList = ezJournalService.getJournaltypeList(companyId, info.getTenantId(), used);
	
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", typeList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}

		logger.debug("G/W JOURNAL [GET /rest/ezjournal/types] ended.");
		
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 일지함 사용여부 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezjournal/types", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public Object journalTypeUpdate(@RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		logger.debug("G/W JOURNAL [PUT /rest/ezjournal/types] started.");
		JSONObject result = new JSONObject();
		
		try {
			String companyId = (String) jsonParam.get("companyId");
		
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.get("userId"));
		
			ArrayList<Map<String, String>> journaltypeList = (ArrayList<Map<String, String>>) jsonParam.get("journaltypeList");
			ezJournalService.updateJournaltype(journaltypeList, companyId, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}

		logger.debug("G/W JOURNAL [PUT /rest/ezjournal/types] ended.");
		
		return result;
	}	
	
	/**
	 * 업무일지 G/W [GET] 양식 리스트 조회 / 부서사용가능 양식리스트 조회 / 취합가능 양식리스트 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/forms", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object journalFormList(HttpServletRequest request, @PathVariable String typeId) throws Exception {
		logger.debug("ezJournal G/W journalFormList started.");
		logger.debug("typeId=" + typeId);

		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			String deptId = request.getParameter("deptId");
			if (deptId == null || deptId.equals("")) {
				deptId = "";
			}
			
			String companyId = "";
			List<JournalFormInfoVO> formList = new ArrayList<JournalFormInfoVO>();
			if (request.getParameter("companyId") != null && !request.getParameter("companyId").equals("")) {
				// 관리자단의 양식리스트
				companyId = request.getParameter("companyId");
				formList = ezJournalService.getFormListAdmin(typeId, deptId, companyId, info.getTenantId(), info.getOffSet(), lang);
			} else {
				// 사용자단의 양식리스트 (부서사용양식, 기본양식)
				formList = ezJournalService.getFormList(typeId, deptId, "", info.getTenantId());
			}
			
			result.put("data", formList);
			result.put("status", "ok");
			result.put("code", 0);
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		logger.debug("ezJournal G/W journalFormList ended.");
		
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 양식 저장
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/forms", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject insertForm(@PathVariable String typeId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W insertForm started.");
		logger.debug("typeId=" + typeId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.get("userId"));
			
			jsonParam.put("tenantId", info.getTenantId());
			ezJournalService.insertForm(jsonParam);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W insertForm ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [PUT] 양식 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/forms/{formId:.+}", method= RequestMethod.PUT, produces="application/json;charset=UTF-8")
	public JSONObject updateForm(@PathVariable String typeId, @PathVariable String formId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W updateForm started.");
		logger.debug("typeId=" + typeId + ",formId=" + formId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.get("userId"));
			
			jsonParam.put("tenantId", info.getTenantId());
			ezJournalService.updateJournalForm(jsonParam);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W updateForm ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 양식 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/forms/{formId:.+}", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteForm(@PathVariable String typeId, @PathVariable String formId, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W deleteForm started.");
		logger.debug("typeId=" + typeId + ",formId=" + formId);
		
		JSONObject result = new JSONObject();
		
		try {
			String companyId = request.getParameter("companyId");

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			ezJournalService.deleteJournalForm(formId, companyId, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W deleteForm ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 양식 상세 보기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/forms/{formId:.+}", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject viewForm(@PathVariable String typeId, @PathVariable String formId, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W viewForm started.");
		logger.debug("typeId=" + typeId + ",formId=" + formId);
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = request.getParameter("companyId");
			if (companyId == null || companyId.equals("")) {
				companyId = info.getCompanyId();
			}
			
			logger.debug("companyId : " + companyId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			// 마지막 사용양식 id 가져오기
			if (request.getParameter("isGetForm") != null ) {
				String selId = ezJournalService.getJournalLastFormId(typeId, formId, userId, companyId, info.getTenantId());
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", selId);
			// 선택된 양식 가져오기	
			} else {
				JournalFormInfoVO journalFormInfoVO = ezJournalService.getJournalFormInfo(formId, companyId, info.getTenantId(), lang);
				
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", journalFormInfoVO);
			}
		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W viewForm ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 열람권한 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/authors", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject authorsList(HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W authorsList started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String companyId = request.getParameter("companyId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			
			List<JournalAuthorVO> authList = ezJournalService.getAuthorList(companyId, info.getTenantId(), lang);
		
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", authList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W authorsList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 열람권한 상세정보
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/users/{userId:.+}/author-depts", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject authorDepts(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W authorDepts started.");
		logger.debug("userId=" + userId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = request.getParameter("lang") != null ? commonUtil.getMultiData(request.getParameter("lang"), info.getTenantId()) : commonUtil.getMultiData(info.getLang(), info.getTenantId());
			String userCompany = request.getParameter("userCompany") != null ? request.getParameter("userCompany") : "";
			
			List<JournalAuthorVO> deptList = ezJournalService.getAuthDeptList(info.getTenantId(), userId, lang, userCompany);
	
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", deptList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W authorDepts ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 열람권한 저장 or 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/authors", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject insertAuthorDepts(@RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W insertAuthorDepts started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.get("userId"));
			
			jsonParam.put("tenantId", info.getTenantId());
			ezJournalService.saveAuthDeptList(jsonParam);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		logger.debug("ezJournal G/W insertAuthorDepts ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 열람권한 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/authors", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteAuthorDepts(HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W deleteAuthorDepts started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			ezJournalService.deleteAuthor(request.getParameter("userId"), info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W deleteAuthorDepts ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 업무일지 리스트 (일일,주간,월간,분기,반기,연간,다른일지가져오기)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/journals", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject typeJournalList(HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W journals started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			Map<String, Object> param = new HashMap<String, Object>();
			
			/* 2024-07-17 홍승비 - SQL Injection 수정 > 페이징을 위한 startCount, listCnt 값은 정수로 전달하도록 수정 */
			for (String key : request.getParameterMap().keySet()) {
				if (key.equalsIgnoreCase("startCount") || key.equalsIgnoreCase("listCnt")) {
					param.put(key, Integer.parseInt(request.getParameter(key)));
				} else {
					param.put(key, request.getParameter(key));
				}
			}
			
			param.put("tenantId", info.getTenantId());
			param.put("lang", lang);
			param.put("offset", commonUtil.getMinuteUTC(info.getOffSet()));
			
			List<JournalVO> journalList = ezJournalService.getJournalList(param);
			result.put("data", journalList);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W journals ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 업무일지 리스트 총 게시물수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/journals-count", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject folderJournalList(HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W journals-count started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			Map<String, Object> param = new HashMap<String, Object>();
			
			for (String key : request.getParameterMap().keySet()) {
				param.put(key, request.getParameter(key));
			}
			param.put("tenantId", info.getTenantId());
			param.put("offset", commonUtil.getMinuteUTC(info.getOffSet()));
			param.put("lang", commonUtil.getMultiData(info.getLang(), info.getTenantId()));
			
			String totalCount = ezJournalService.getTotalListCount(param);
			
			result.put("data", totalCount);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W journals-count ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 업무일지 저장
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/journals", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject insertJournal(@PathVariable String typeId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W insertJournal started.");
		logger.debug("typeId=" + typeId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, jsonParam.get("userId").toString());
			String deptId = String.valueOf(jsonParam.get("deptId"));
			String realPath = commonUtil.getRealPath(request);
			
			String journalId = ezJournalService.insertJournal(jsonParam, deptId, info.getTenantId(), realPath);
			
			result.put("data", journalId);
			result.put("status", "ok");
			result.put("code", 0);
		
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W insertJournal ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 일지 취합 후 내용 리턴 (금일, 익일 부분)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/journals-sum", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject journalsSumContent(@RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W journalsSumContent started.");
		Gson gson = new Gson();
		JSONObject result = new JSONObject();
		
		try {
			String userId = (String) jsonParam.get("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			String formId = (String) jsonParam.get("formId");
			String journalIdArray = (String) jsonParam.get("journalIdList").toString();
			
			List<String> journalIdList = gson.fromJson(journalIdArray, new TypeToken<List<String>>(){}.getType());
			
			logger.debug("companyId : " + companyId);
			
			JournalFormInfoVO journalFormInfoVO = ezJournalService.getJournalDivideThisNext(journalIdList, formId, companyId,userId, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", journalFormInfoVO);
		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W journalsSumContent ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 업무일지 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/journals/{journalId:.+}", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject viewJournal(@PathVariable String journalId, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W viewJournal started.");
		logger.debug("journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String pPreviewShow_HOW = request.getParameter("pPreviewShow_HOW");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			/*
			String viewDate = "";
			if (request.getParameter("viewDate") != null) {
				viewDate = request.getParameter("viewDate");
			}
			*/
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			JournalVO journal = ezJournalService.getJournal(journalId, userId, info.getTenantId(), lang, info.getOffSet(), pPreviewShow_HOW);
			
			if (journal == null) {
				result.put("data", "");
				result.put("status", "empty");
				result.put("code", -1);
			}
			
			if (journal.getFileList().size() > 0) {
				List<JournalFileVO> fileList = journal.getFileList();
				
				long fileTotalSizeLong = 0;
				for (JournalFileVO vo : fileList) {
					String fileType = vo.getFileName().substring(vo.getFileName().lastIndexOf(".") + 1).toLowerCase();
					vo.setFileType(fileType);
					vo.setFileEncodeName(URLEncoder.encode(vo.getFileName(), "UTF-8"));
					vo.setFilePath(URLEncoder.encode(vo.getFilePath(), "UTF-8"));
						
					String fileSize = commonUtil.getSizeWithUnit(vo.getFileSize());
					vo.setFileTransSize(fileSize);
					
					fileTotalSizeLong += vo.getFileSize();
					
					logger.debug("##fileType: " + vo.getFileType() + ", EncodeFileName: " + vo.getFileEncodeName() + ", transSize: " + vo.getFileTransSize());
				}
				
				journal.setFileList(fileList);
				String totalFileSize = commonUtil.getSizeWithUnit(fileTotalSizeLong);
				journal.setFileTotalSize(totalFileSize);
			}
			
			result.put("data", journal);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W viewJournal ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [PUT] 업무일지 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/journals/{journalId:.+}", method= RequestMethod.PUT, produces="application/json;charset=UTF-8")
	public JSONObject updateJournal(@PathVariable String typeId, @PathVariable String journalId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W updateJournal started.");
		logger.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, jsonParam.get("userId").toString());
			String realPath = commonUtil.getRealPath(request);
			
			String mode = jsonParam.get("mode").toString();
			logger.debug("mode : " + mode);
			
			ezJournalService.updateJournal(commonUtil.detectPathTraversal(journalId), jsonParam, info.getTenantId(), realPath);
			
			result.put("data", journalId);
			result.put("status", "ok");
			result.put("code", 0);
		
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W updateJournal ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 업무일지 삭제 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/journals", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteJournalList(@RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W deleteJournalList started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, jsonParam.get("userId").toString());
			String realPath = commonUtil.getRealPath(request);
			String journalId = commonUtil.detectPathTraversal(jsonParam.get("journalId").toString());
			List<String> journalIdList = new ArrayList<String>();
			
			if (journalId.contains("[")) {
				Gson gson = new Gson();
				journalIdList = gson.fromJson(journalId, new TypeToken<List<String>>(){}.getType());
			} else {
				journalIdList.add(journalId);
			}
			logger.debug("journalIdList : " + journalIdList);
			
			String pDirPath = "";
			pDirPath = commonUtil.getUploadPath("upload_journal.ROOT", info.getTenantId());
			pDirPath = realPath + pDirPath;
					
			if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
				pDirPath = pDirPath + commonUtil.separator;
			}
			
			String listType = jsonParam.get("listType").toString();
			logger.debug("listType : " + listType);
			
			if (listType.equals("recv")) {
				ezJournalService.updateJournalStatus(journalIdList, info.getUserId(), info.getTenantId());
			} else {
				ezJournalService.deleteJournalList(journalIdList, pDirPath, info.getTenantId());
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W deleteJournalList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [PUT] 수신 확인 처리
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/viewers/{userId:.+}", method= RequestMethod.PUT, produces="application/json;charset=UTF-8")
	public JSONObject receiveOKJournal(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W receiveOKJournal started.");
		logger.debug("userId=" + userId);
		
		Gson gson = new Gson();
		JSONObject result = new JSONObject();
	
		try {
			String serverName = request.getHeader("x-user-host");
			String journalIdArray = request.getParameter("journalIdList").toString();
//			String viewDate = request.getParameter("viewDate");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
		
			List<String> journalIdList = gson.fromJson(journalIdArray, new TypeToken<List<String>>(){}.getType());
		
			logger.debug("journalIdList : " + journalIdList);
	
			ezJournalService.saveJournalViewInfo(journalIdList, info.getUserId(), info.getTenantId());
		
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W receiveOKJournal ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 첨부파일 업로드
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/attachfiles", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject uploadFile(@RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W uploadFile started.");
		
		JSONObject result = new JSONObject();
		
		JSONParser jp = new JSONParser();
		jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
	
		try {
			JSONArray fileArray = new JSONArray();
			String userId = "";
			int cnt = 0;
			int maxSize = 0;
			
			if (jsonParam.get("fileArray") != null) {
				fileArray = (JSONArray) jsonParam.get("fileArray");
			}
			
			if (jsonParam.get("cnt") != null) {
				cnt =  ((Long) jsonParam.get("cnt")).intValue();
			}
			
			if (jsonParam.get("maxSize") != null) {
				maxSize =  ((Long) jsonParam.get("maxSize")).intValue();
			}
			
			if (jsonParam.get("userId") != null) {
				userId = (String) jsonParam.get("userId");
			}
			
			logger.debug("####cnt:" + cnt + ", maxSize:" + maxSize + ", userId:" + userId);
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			String realPath = commonUtil.getRealPath(request);
			String[] pFileName = new String[cnt];
			Long[] fileSize = new Long[cnt];
			String[] fileLocation = new String[cnt];
			String[] resultUpload = new String[cnt];
			String[] sGUID = new String[cnt];
			String[] pUploadSN = new String[cnt];

			String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", info.getTenantId());
			
			for (int i = 0; i < cnt; i++) {
	            resultUpload[i] = "false";
	            sGUID[i] = UUID.randomUUID().toString();
	            pUploadSN[i] = "{" + sGUID[i] + "}";
	        }
		
			if (useExtension == null) {
				useExtension = "";
			}
			
			if (((JSONObject)fileArray.get(0)).get("originalFilename") != null && StringUtils.isNotBlank((String) ((JSONObject)fileArray.get(0)).get("originalFilename"))) {
				String _pFileName = "";
				
				for (int i = 0; i < cnt; i++) {
	                _pFileName = (String) ((JSONObject)fileArray.get(i)).get("originalFilename");
	                
	                // 폴더패스를 제외한 파일명을 구한다.
	                if (_pFileName.indexOf(commonUtil.separator) > 0) {
	                    _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
	                }
	                
	                pFileName[i] = _pFileName;
	            }
	        }
			
			String pDirPath = commonUtil.getUploadPath("upload_journal.ROOT", info.getTenantId());
	        pDirPath = realPath + pDirPath;
	        
	        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
	        	pDirPath = pDirPath + commonUtil.separator;
	        }
	        
	        File file = new File(pDirPath + "uploadFile");
	        File tempFile = new File(pDirPath + "tempUploadFile");

	        if (!file.exists()) {
	        	file.mkdirs();
	        }
	        
	        if (!tempFile.exists()) {
	        	tempFile.mkdirs();
	        }
			
	        for (int i = 0; i < cnt; i++) {
	        	fileSize[i] = (Long) ((JSONObject)fileArray.get(i)).get("fileSize");
	        	String extend = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
	        	String newFileName = pUploadSN[i] + "." + extend;
        		
	        	// maxsize를 넘어가는 파일은 저장하지 않는다.
	            if (fileSize[i] > maxSize && maxSize != 0) {
	                resultUpload[i] = "overflow";
	            } else {
	            	// 허용하는 확장자가 아닌경우 저장하지 않는다.
					// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
                    if ((extend.isEmpty() || useExtension.toLowerCase().indexOf(extend.toLowerCase()) == -1) && !useExtension.equals("*")) {
                        resultUpload[i] = "denied";
                    } else {
                        String pAttachPath = pDirPath + "tempUploadFile" + commonUtil.separator;
//                        
                        // 업로드된 파일 데이터를 파일로 저장한다.
                        journalWriteUploadedFile((String)((JSONObject)fileArray.get(i)).get("bytes"), newFileName, pAttachPath);
                        
                        fileLocation[i] = commonUtil.getUploadPath("upload_journal.ROOT", info.getTenantId()) + commonUtil.separator + "tempUploadFile" + commonUtil.separator + pUploadSN[i];
                        resultUpload[i] = "true";
                    }
	            }
	        }
			/*
	        StringBuffer strXML = new StringBuffer();

	        strXML.append("<ROOT><NODES>");
	        
	        for (int i = 0; i < cnt; i++) {
	            strXML.append("<NODE><PUPLOADSN><![CDATA[" + pUploadSN[i] + "_" + pFileName[i] + "]]></PUPLOADSN>");
	            strXML.append("<RESULTUPLOADA><![CDATA[" + resultUpload[i] + "]]></RESULTUPLOADA>");
	            strXML.append("<PFILENAME><![CDATA[" + pFileName[i] + "]]></PFILENAME>");
	            strXML.append("<FILESIZE>" + fileSize[i] + "</FILESIZE>");
	            strXML.append("<FILELOCATION><![CDATA[" + fileLocation[i] + "]]></FILELOCATION>");
	            strXML.append("</NODE>");
	        }
	        
	        strXML.append("</NODES></ROOT>");
	        
	        result.put("data", strXML);
	        */
	        
	        ArrayList<JSONObject> filelist = new ArrayList<JSONObject>();
	        
	        for (int i = 0; i < cnt; i++) {
	        	JSONObject fileInfo = new JSONObject();
	        	fileInfo.put("pUploadSN", pUploadSN[i]);
	        	fileInfo.put("pFileName", pFileName[i]);
	        	fileInfo.put("fileSize", fileSize[i]);
	        	fileInfo.put("fileLocation", fileLocation[i]);
	        	fileInfo.put("resultUpload", resultUpload[i]);
	        	filelist.add(i, fileInfo);
	        }
	        result.put("data", filelist);
			result.put("status", "ok");
			result.put("code", 0);
			
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 0);
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W uploadFile ended.");
		return result;
	}
	
	/**
     * 첨부파일을 서버에 저장한다.
     *
     * @param file
     * @param newName
     * @param stordFilePath
     * @throws Exception
     */
    public void journalWriteUploadedFile(String bytearray, String newName, String stordFilePath) throws Exception {
    	logger.debug("journalWriteUploadedFile started.");
    	
		InputStream stream = null;
		OutputStream bos = null;
		String stordFilePathReal = (stordFilePath == null ? "" : commonUtil.detectPathTraversal(stordFilePath));
		
		try {
		    File cFile = new File(stordFilePathReal);
	
		    if (!cFile.isDirectory()) {
				boolean _flag = cFile.mkdirs();
				if (!_flag) {
				    throw new IOException("Directory creation Failed ");
				}
		    }
	
		    bos = new FileOutputStream(stordFilePathReal + File.separator + commonUtil.detectPathTraversal(newName));
		    logger.debug("###" + stordFilePathReal + File.separator + newName + "###");
		    Decoder decoder = Base64.getDecoder();

		    bos.write(decoder.decode(bytearray));

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
		logger.debug("journalWriteUploadedFile ended.");
    }
	
	
	/**
	 * 업무일지 G/W [DELETE] 첨부파일 삭제 (임시파일)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/journals/{journalId}/attachfiles", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteFile(@PathVariable String journalId, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W deleteFile started.");
		logger.debug("journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName,  userId);
		
		//	String mode = "";
		//	if (request.getParameter("mode") != null || request.getParameter("mode").equals("")) {
		//		mode = request.getParameter("mode");
		//	}
			String pDirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_journal.ROOT", info.getTenantId());
			String filePath = commonUtil.detectPathTraversal(request.getParameter("filePath"));
			String fileList = request.getParameter("fileList");
			
			logger.debug("pDirPath : " + pDirPath + " | fileList : " + fileList);
			
			// journalId가 temp이면 임시파일 삭제의 의미
			if (journalId.equals("temp")) {
				if (fileList.length() != 0) {
					String[] data = fileList.split("/"); 
					
					for (int i=0; i<data.length; i++) {
						String sGUID = commonUtil.detectPathTraversal(data[i].split(":")[0]);
						String fileName = commonUtil.detectPathTraversal(data[i].split(":")[1]);
						String extension = commonUtil.detectPathTraversal(fileName.substring(fileName.lastIndexOf(".") + 1));
						logger.debug("sGUID:" + sGUID + ",fileName:" + fileName);
						
						File file = new File(pDirPath + commonUtil.separator + filePath + commonUtil.separator + sGUID + "." + extension);
						if(file.exists()){
							file.delete();
						}
					}
				}
			}
			else {
				if (fileList.length() != 0) {
					String[] data = fileList.split("/"); 
					
					for (int i=0; i<data.length; i++) {
						String sGUID = commonUtil.detectPathTraversal(data[i].split(":")[0]);
						String fileName = commonUtil.detectPathTraversal(data[i].split(":")[1]);
						String extension = commonUtil.detectPathTraversal(fileName.substring(fileName.lastIndexOf(".") + 1));
						logger.debug("sGUID:" + sGUID + ",fileName:" + fileName);
						
						File file = new File(pDirPath + commonUtil.separator + filePath + commonUtil.separator + sGUID + "." + extension);
						
						file.delete();
					}
				}
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W deleteFile ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 모든첨부파일 다운로드
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/journals/{journalId}/allattachfiles", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject downloadFile(@PathVariable String journalId, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("ezJournal G/W downloadFile started.");
		logger.debug("journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		int bufferSize = 4096;
		            
		//ZipOutputStream zos = null;
		
		//try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String realPath = commonUtil.getRealPath(request);
			String uploadFilePath = commonUtil.getUploadPath("upload_journal.ROOT", info.getTenantId());
			String tempFileUploadPath = realPath + uploadFilePath + commonUtil.separator + "tempUploadFile";
			String guid = UUID.randomUUID().toString();
			String pDirTempPath = tempFileUploadPath + commonUtil.separator + guid;
			String[] filePathS = request.getParameter("filePathS").split("\\|");
			String[] fileNameS = request.getParameter("fileNameS").split("\\|");
			List<String> filePathList = Arrays.asList(filePathS);
			List<String> fileNameList = Arrays.asList(fileNameS);
			
			//zos = new ZipOutputStream(new FileOutputStream(pDirTempPath + ".zip"), Charset.forName("utf-8"));
		try (ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(pDirTempPath + ".zip"), Charset.forName("utf-8"))){
			//BufferedInputStream bis = null;
			
			for (int i = 0; i < filePathList.size(); i++) {
				//try {
					String filePath = URLDecoder.decode(filePathList.get(i), "UTF-8");
					String fileName = fileNameList.get(i);
					
					String fullFilePath = realPath + uploadFilePath + commonUtil.separator + "uploadFile" + commonUtil.detectPathTraversal(filePath);
					
					logger.debug("fullFilePath : " + fullFilePath);
					
					File file = new File(fullFilePath);
					
					if (!file.exists()) {
						throw new FileNotFoundException(fullFilePath);
					}
					
					if (!file.isFile()) {
						throw new FileNotFoundException(fullFilePath);
					}
					
					try (BufferedInputStream bis = new BufferedInputStream(new FileInputStream(file))) {
			        ZipEntry zentry = new ZipEntry(fileName);
			        zentry.setTime(file.lastModified());
			        zos.putNextEntry(zentry);
					
			        byte[] buffer = new byte[bufferSize];
			        int cnt = 0;
			        	
			        while ((cnt = bis.read(buffer, 0, bufferSize)) != -1) {
			            zos.write(buffer, 0, cnt);
			        }
			        zos.closeEntry();
				} catch (IOException e) {
					logger.error(e.getMessage(), e);
				/*} finally {
					if (bis != null) {
						try {
							bis.close();
						} catch (Exception e) {
							logger.error(e.getMessage(), e);
						}
					}*/
				}
			}
			/*zos.flush();
			zos.close();
			zos = null;*/
			
			File file = new File(pDirTempPath + ".zip");
			
			int fileSize = (int)file.length();
			
			if (fileSize > 0) {
				byte[] bytes = commonUtil.readBytesFromFile(Paths.get(pDirTempPath + ".zip"));
				
				JSONObject data = new JSONObject();
				
				data.put("bytes", bytes);
				data.put("fileSize", fileSize);
				
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", data);
			}
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W downloadFile ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 첨부파일 다운로드
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/journals/{journalId}/attachfiles", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject downloadAllFile(@PathVariable String journalId, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W downloadFile started.");
		logger.debug("journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String realPath = commonUtil.getRealPath(request);
			String uploadFilePath = commonUtil.getUploadPath("upload_journal.ROOT", info.getTenantId());
			String filePath = request.getParameter("filePath");
			String fullFilePath = realPath + uploadFilePath + commonUtil.separator + "uploadFile" + commonUtil.detectPathTraversal(filePath);
			logger.debug("fullFilePath : " + fullFilePath);
			
			File file = new File(fullFilePath);
			
			if (!file.exists()) {
				throw new FileNotFoundException(fullFilePath);
			}
			
			if (!file.isFile()) {
				throw new FileNotFoundException(fullFilePath);
			}
			
			int fileSize = (int)file.length();
			
			if (fileSize > 0) {
				byte[] bytes = commonUtil.readBytesFromFile(Paths.get(fullFilePath));
				
				JSONObject data = new JSONObject();
				
				data.put("bytes", bytes);
				data.put("fileSize", fileSize);
				
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", data);
			}
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W downloadFile ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 일지 수신자 리스트 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/journals/{journalId}/receivers", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getReceiverList(@PathVariable String journalId, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W getReceiverList started.");
		logger.debug("journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String startCount = request.getParameter("startCount");
			String listCnt = request.getParameter("listCnt");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName,  userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			List<JournalReceiverVO> receiverList = ezJournalService.getReceiverList(journalId, startCount, listCnt, info.getTenantId(), lang, info.getOffSet());
		
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", receiverList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W getReceiverList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 일지 수신자 명수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/journals/{journalId}/receivers-count", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getReceiverCount(@PathVariable String journalId, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W getReceiverCount started.");
		logger.debug("journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
		//	String startCount = request.getParameter("startCount");
		//	String listCnt = request.getParameter("listCnt");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName,  userId);
			
			String receiverCount = ezJournalService.getReceiverCount(journalId, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", receiverCount);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W getReceiverCount ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 수신자 즐겨찾기 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/users/{userId:.+}/favorites", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getFavoriteList(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W getFavoriteList started.");
		logger.debug("userId=" + userId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			List<ReceiverFavoriteVO> favoriteList = ezJournalService.getFavoriteList(userId, info.getTenantId(), info.getOffSet());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", favoriteList);
			
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W getFavoriteList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 수신자 즐겨찾기 저장
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/users/{userId:.+}/favorites", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject saveFavorite(@PathVariable String userId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W saveFavorite started.");
		logger.debug("userId=" + userId);
		
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			jsonParam.put("tenantId", info.getTenantId());
			ezJournalService.saveFavorite(jsonParam);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W saveFavorite ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [PUT] 수신자 즐겨찾기 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/users/{userId:.+}/favorites/{favoriteId:.+}", method= RequestMethod.PUT, produces="application/json;charset=UTF-8")
	public JSONObject updateFavorite(@PathVariable String userId, @PathVariable String favoriteId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W updateFavorite started.");
		logger.debug("userId=" + userId + ",favoriteId=" + favoriteId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			jsonParam.put("tenantId", info.getTenantId());
			ezJournalService.modifyFavorite(jsonParam);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W updateFavorite ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 수신자 즐겨찾기 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/users/{userId:.+}/favorites/{favoriteId:.+}", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteFavorite(@PathVariable String userId, @PathVariable String favoriteId, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W deleteFavorite started.");
		logger.debug("userId=" + userId + ",favoriteId=" + favoriteId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			ezJournalService.deleteFavorite(favoriteId, userId, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W deleteFavorite ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 수신자 즐겨찾기 유저 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/users/{userId:.+}/favorites/{favoriteId}/users", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getFavoriteUserList(@PathVariable String userId, @PathVariable String favoriteId, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W getFavoriteUserList started.");
		logger.debug("userId=" + userId + ",favoriteId=" + favoriteId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			List<JournalReceiverVO> userList = ezJournalService.getFavoriteUserList(favoriteId, info.getTenantId(),lang);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", userList);
			
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W getFavoriteUserList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 댓글 리스트 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/journals/{journalId}/replies", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getReplies(@PathVariable String journalId, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W getReplies started.");
		logger.debug("journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			List<JournalReplyVO> replyList = ezJournalService.getJournalReplyList(journalId, userId, tenantId, lang, info.getOffSet());
			
			result.put("data", replyList);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W getReplies ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 댓글 저장
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/journals/{journalId}/replies", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject saveReply(@PathVariable String journalId,  HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W saveReply started.");
		logger.debug("journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String replyContent = request.getParameter("replyContent");
		//	String replyDate = request.getParameter("replyDate");
		//	String journalTitle = request.getParameter("journalTitle");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			String journalWriter = ezJournalService.saveJorunalReply(journalId, userId, replyContent, tenantId);
			
			result.put("data", journalWriter);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W saveReply ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 댓글 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/journals/{journalId}/replies/{replyId:.+}", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteReply(@PathVariable String journalId, @PathVariable String replyId, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W deleteReply started.");
		logger.debug("journalId=" + journalId + ",replyId=" + replyId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			ezJournalService.removeJorunalReply(journalId, replyId, userId, tenantId);
			
			result.put("data", "");
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W deleteReply ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 환경설정 정보 저장
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/users/{userId:.+}/options", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject saveOption(@RequestParam Map<String,Object> param, @PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W saveOption started.");

		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			param.put("userId", userId);
			param.put("tenantId", info.getTenantId());
			ezJournalService.saveJournalEnv(param);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W saveOption ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 환경설정 정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/users/{userId:.+}/options", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getOption(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W getOption started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			/* 2024-07-17 홍승비 - SQL Injection 수정 > 알림 메일 발송을 위한 사용자명 다국어 처리 정상 동작하도록 lang 파라미터 추가 */
			JournalEnvVO journalOpt = ezJournalService.getUserJournalEnv(userId, commonUtil.getMultiData(info.getLang(), info.getTenantId()), info.getTenantId());
			List<DeptViewVO> deptList = ezJournalService.getCheifBoss(userId, commonUtil.getMultiData(info.getLang(), info.getTenantId()), info.getTenantId());
			
			data.put("journalOpt", journalOpt);
			data.put("deptList", deptList);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W getOption ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 수신일지개수 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/users/{userId:.+}/recv-count", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getRecvJournalCount(@PathVariable String userId,HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W getRecvJournalCount started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			String recvCount = ezJournalService.getRecvJournalCount(userId, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", recvCount);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W getRecvJournalCount ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 일지 조회자 리스트 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/journals/{journalId}/viewer", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getViewerList(@PathVariable String journalId,HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W getRecvJournalCount started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String startCount = request.getParameter("startCount");
			String listCnt = request.getParameter("listCnt");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			List<JournalReceiverVO> viewerList= ezJournalService.getJournalViewerList(journalId, startCount, listCnt, info.getTenantId(), lang, info.getOffSet());
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", viewerList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W getRecvJournalCount ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 일지 조회자 수  
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/journals/{journalId}/viewer-count", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getViewerCount(@PathVariable String journalId,HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W getRecvJournalCount started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			String viewerCount= ezJournalService.getJournalViewerCount(journalId, info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", viewerCount);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W getRecvJournalCount ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 권한 체크
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/journals/{journalId}/auth", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject checkJournalAuth(@PathVariable String journalId,HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W checkJournalAuth started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			JournalAuthCheckVO journalAuth = ezJournalService.checkJournalAuth(userId, journalId, info.getTenantId());
		
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", journalAuth);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W checkJournalAuth ended.");
		return result;
	}
	
	// 공통 부분 API
	/**
	 * 업무일지 G/W [GET] 회사리스트 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/companies", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getCompanyList(HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W getCompanyList started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = request.getParameter("companyId");
			if (companyId == null || companyId.equals("")) {
				companyId = info.getCompanyId();
			}
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			List<JournalCompanyVO> compList = ezJournalService.getCompanyList(userId, info.getTenantId(), companyId,lang);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", compList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W getCompanyList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 부서리스트 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/depts", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getDeptList(HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W getDeptList started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			List<OrganUserVO> allUserinfo = ezOrganService.getAllUserinfo(userId, info.getTenantId());

			logger.debug("userId : " + userId);
			String companyId = request.getParameter("companyId");
			
			if (companyId == null || companyId.equals("")) {
				companyId = info.getCompanyId();
			}
			String lang = request.getParameter("lang") != null ? commonUtil.getMultiData(request.getParameter("lang"), info.getTenantId()) : commonUtil.getMultiData(info.getLang(), info.getTenantId());;
			List<DeptViewVO> deptList = ezJournalService.getDeptViewList(userId, companyId, info.getTenantId(),lang);

			if (deptList.stream().noneMatch(vo -> "yes".equals(vo.getMyDept()))) {
				Set<String> set = allUserinfo.stream()
						.map(OrganUserVO::getDepartment)
						.collect(Collectors.toSet());
                deptList.stream()
						.filter(vo -> set.contains(vo.getId()))
						.findFirst()
						.ifPresent(vo -> vo.setMyDept("yes"));
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", deptList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W getDeptList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 사원리스트 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/users", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getUserList(HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W getUserList started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String key = request.getParameter("key");
			String value = request.getParameter("value");
			String companyId = request.getParameter("companyId");
			String curPage = request.getParameter("curPage");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			if (companyId == null || companyId.equals("")) {
				companyId = info.getCompanyId();
			}
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			
			List<JournalAuthorVO> userList = ezJournalService.getDeptUserList(info.getTenantId(), key, value, companyId, lang, curPage);
			int userCount = ezJournalService.getDeptUserListCount(info.getTenantId(), key, value, companyId, lang);
			
			// 하위부서 포함
			String containLow= ezCommonService.getTenantConfig("containLow", info.getTenantId());
			int totalCount2 = 0;
			
			if (containLow.equals("YES") && key.equals("DEPARTMENT")) {
				totalCount2 = ezOrganService.getMemberListCount2(value, null, totalCount2, containLow, info.getTenantId());
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", userList);
			result.put("totalCount", userCount);
			result.put("totalCount2", totalCount2);
			result.put("containLow", containLow);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W getUserList ended.");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/users/{userId:.+}/noti/options", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getNotiOption(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("ezJournal G/W getNotiOption started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String notiName = request.getParameter("notiName");
			NotiType notiType = NotiType.fromString(notiName);
			List<Integer> disablePlatformList = ezPersonalService.getAllPlatformFromNotiDisableItem(userId, notiType, info.getTenantId());
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			JournalEnvVO journalMailInfo = ezJournalService.getUserJournalMailInfo(userId, info.getTenantId(), lang);
			
			data.put("journalMailInfo", journalMailInfo);
			data.put("disablePlatformList", disablePlatformList);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezJournal G/W getNotiOption ended.");
		return result;
	}
	
}
