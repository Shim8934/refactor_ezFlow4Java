package egovframework.ezEKP.ezJournal.web;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.Base64.Decoder;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezJournal.service.EzJournalService;
import egovframework.ezEKP.ezJournal.vo.DeptViewVO;
import egovframework.ezEKP.ezJournal.vo.JournalAttachVO;
import egovframework.ezEKP.ezJournal.vo.JournalAuthorVO;
import egovframework.ezEKP.ezJournal.vo.JournalCompanyVO;
import egovframework.ezEKP.ezJournal.vo.JournalEnvVO;
import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;
import egovframework.ezEKP.ezJournal.vo.JournalVO;
import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;
import egovframework.ezEKP.ezJournal.vo.ReceiverFavoriteVO;
import egovframework.ezMobile.ezBoard.vo.MBoardAttachVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzJournalGWController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzJournalGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCommonService ezCommonService;

	@Resource(name="ezJournalService")
	private EzJournalService ezJournalService;

	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	/**
	 * 업무일지 G/W [GET] 일지함 조회 / 사용하는 일지함 조회
	 */
	@RequestMapping(value = "/rest/ezjournal/types", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public Object journalTypeList(HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W JOURNAL [GET /rest/ezjournal/types] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String used = request.getParameter("used");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			String companyId = request.getParameter("companyId");
			if (companyId == null || companyId.equals("")) {
				companyId = info.getCompanyId();
			}
			
			LOGGER.debug("companyId : " + companyId);

			List<JournaltypeVO> typeList = ezJournalService.getJournaltypeList(companyId, info.getTenantId() + "", used);
	
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", typeList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}

		LOGGER.debug("G/W JOURNAL [GET /rest/ezjournal/types] ended.");
		
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 일지함 사용여부 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezjournal/types", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public Object journalTypeUpdate(@RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W JOURNAL [PUT /rest/ezjournal/types] started.");
		JSONObject result = new JSONObject();
		
		try {
			String companyId = (String) jsonParam.get("companyId");
		
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.get("userId"));
		
			ArrayList<Map<String, String>> journaltypeList = (ArrayList<Map<String, String>>) jsonParam.get("journaltypeList");
			
			ezJournalService.updateJournaltype(journaltypeList, companyId, info.getTenantId() + "");
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}

		LOGGER.debug("G/W JOURNAL [PUT /rest/ezjournal/types] ended.");
		
		return result;
	}	
	
	/**
	 * 업무일지 G/W [GET] 양식 리스트 조회 / 부서사용가능 양식리스트 조회 / 취합가능 양식리스트 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/forms", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object journalFormList(HttpServletRequest request, @PathVariable String typeId) throws Exception {
		LOGGER.debug("ezJournal G/W journalFormList started.");
		LOGGER.debug("typeId=" + typeId);

		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			String deptId = request.getParameter("deptId");
			if (deptId == null || deptId.equals("")) {
				deptId = "";
			}
			
			List<JournalFormInfoVO> formList = ezJournalService.getFormList(typeId, deptId, info.getCompanyId(), info.getCompanyName(), info.getTenantId() + "", info.getOffSet());
			
			result.put("data", formList);
			result.put("status", "ok");
			result.put("code", 0);
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezJournal G/W journalFormList ended.");
		
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 양식 저장
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/forms", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject insertForm(@PathVariable String typeId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W insertForm started.");
		LOGGER.debug("typeId=" + typeId);
		
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
		}
		
		LOGGER.debug("ezJournal G/W insertForm ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [PUT] 양식 수정
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/forms/{formId}", method= RequestMethod.PUT, produces="application/json;charset=UTF-8")
	public JSONObject updateForm(@PathVariable String typeId, @PathVariable String formId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W updateForm started.");
		LOGGER.debug("typeId=" + typeId + ",formId=" + formId);
		
		JSONObject result = new JSONObject();
		
		try {
		//	String companyId = request.getParameter("companyId");

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.get("userId"));
			
			jsonParam.put("tenantId", info.getTenantId());
			ezJournalService.updateJournalForm(jsonParam);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch(Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		LOGGER.debug("ezJournal G/W updateForm ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 양식 삭제
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/forms/{formId}", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteForm(@PathVariable String typeId, @PathVariable String formId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W deleteForm started.");
		LOGGER.debug("typeId=" + typeId + ",formId=" + formId);
		
		JSONObject result = new JSONObject();
		
		try {
			String companyId = request.getParameter("companyId");

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			ezJournalService.deleteJournalForm(formId, companyId, info.getTenantId() + "");
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		LOGGER.debug("ezJournal G/W deleteForm ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 양식 상세 보기
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/forms/{formId}", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject viewForm(@PathVariable String typeId, @PathVariable String formId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W viewForm started.");
		LOGGER.debug("typeId=" + typeId + ",formId=" + formId);
		
		JSONObject result = new JSONObject();
		
		try {
			
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			
			LOGGER.debug("companyId : " + companyId);
			
			// 마지막 사용양식 id 가져오기
			if (request.getParameter("isGetForm") != null ) {
				String selId = ezJournalService.getJournalLastFormId(typeId, formId, userId, companyId, info.getTenantId() + "");
				LOGGER.debug("formId : " + selId);
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", selId);
			// 선택된 양식 가져오기	
			} else {
				JournalFormInfoVO journalFormInfoVO = ezJournalService.getJournalFormInfo(formId, companyId, info.getTenantId() + "");
				
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", journalFormInfoVO);
			}
		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		LOGGER.debug("ezJournal G/W viewForm ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 열람권한 리스트
	 */
	@RequestMapping(value="/rest/ezjournal/authors", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject authorsList(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W authorsList started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String companyId = request.getParameter("companyId");
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			List<JournalAuthorVO> authList = ezJournalService.getAuthorList(companyId, info.getTenantId() + "");
		
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", authList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("ezJournal G/W authorsList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 열람권한 상세정보
	 */
	@RequestMapping(value="/rest/ezjournal/users/{userId}/author-depts", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject authorDepts(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W authorDepts started.");
		LOGGER.debug("userId=" + userId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			List<JournalAuthorVO> deptList = ezJournalService.getAuthDeptList(info.getTenantId() + "", userId);
	
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", deptList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("ezJournal G/W authorDepts ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 열람권한 저장
	 */
	@RequestMapping(value="/rest/ezjournal/authors", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject insertAuthorDepts(@RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W insertAuthorDepts started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			jsonParam.put("tenantId", info.getTenantId());
			ezJournalService.saveAuthDeptList(jsonParam);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
		}
		LOGGER.debug("ezJournal G/W insertAuthorDepts ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 열람권한 삭제
	 */
	@RequestMapping(value="/rest/ezjournal/authors", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteAuthorDepts(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W deleteAuthorDepts started.");
		
		JSONObject result = new JSONObject();
		LOGGER.debug(request.getParameter("userId"));
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			ezJournalService.deleteAuthor(request.getParameter("userId"), info.getTenantId() + "");
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		LOGGER.debug("ezJournal G/W deleteAuthorDepts ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 업무일지 리스트 (일일,주간,월간,분기,반기,연간,다른일지가져오기)
	 */
	@RequestMapping(value="/rest/ezjournal/journals", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject typeJournalList(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W journals started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			Map<String, Object> param = new HashMap<String, Object>();
			
			for (String key : request.getParameterMap().keySet()) {
				param.put(key, request.getParameter(key));
			}
			param.put("tenantId", info.getTenantId());
			
			List<JournalVO> journalList = ezJournalService.getJournalList(param);
			result.put("data", journalList);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
			
		}
		
		LOGGER.debug("ezJournal G/W journals ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 업무일지 리스트 총 게시물수
	 */
	@RequestMapping(value="/rest/ezjournal/journals-count", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject folderJournalList(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W journals-count started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			Map<String, Object> param = new HashMap<String, Object>();
			
			for (String key : request.getParameterMap().keySet()) {
				param.put(key, request.getParameter(key));
			}
			param.put("tenantId", info.getTenantId());
			String totalCount = ezJournalService.getTotalListCount(param);
			
			result.put("data", totalCount);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
			
		}
		
		LOGGER.debug("ezJournal G/W journals-count ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 업무일지 저장
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/journals", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject insertJournal(@PathVariable String typeId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W insertJournal started.");
		LOGGER.debug("typeId=" + typeId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, jsonParam.get("userId").toString());
			String realPath = commonUtil.getRealPath(request);
			
			ezJournalService.insertJournal(jsonParam, info.getDeptId(), info.getTenantId(), realPath);
			
			result.put("data", "");
			result.put("status", "ok");
			result.put("code", 0);
		
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
		}
		
		LOGGER.debug("ezJournal G/W insertJournal ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 일지 취합 후 내용 리턴 (금일, 익일 부분)
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/journals-sum", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject journalsSumContent(@PathVariable String typeId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W journalsSumContent started.");
		LOGGER.debug("typeId=" + typeId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W journalsSumContent ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 업무일지 조회
	 */
	@RequestMapping(value="/rest/ezjournal/journals/{journalId}", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject viewJournal(@PathVariable String journalId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W viewJournal started.");
		LOGGER.debug("journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String viewDate = request.getParameter("viewDate");
			
			JournalVO journal = ezJournalService.getJournal(journalId, userId, viewDate, info.getTenantId()+"");
			
			result.put("data", journal);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
			
		}
		
		LOGGER.debug("ezJournal G/W viewJournal ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [PUT] 업무일지 수정
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/journals/{journalId}", method= RequestMethod.PUT, produces="application/json;charset=UTF-8")
	public JSONObject updateJournal(@PathVariable String typeId, @PathVariable String journalId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W updateJournal started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, jsonParam.get("userId").toString());
			String realPath = commonUtil.getRealPath(request);
			
			String mode = jsonParam.get("mode").toString();
			LOGGER.debug("mode : " + mode);
			
			ezJournalService.updateJournal(journalId, jsonParam, info.getTenantId(), realPath);
			
			result.put("data", "");
			result.put("status", "ok");
			result.put("code", 0);
		
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
		}
		
		LOGGER.debug("ezJournal G/W updateJournal ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 업무일지 삭제
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/journals/{journalId}", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteJournal(@PathVariable String typeId, @PathVariable String journalId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W deleteJournal started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W deleteJournal ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 업무일지 읽음 처리
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/journals/{journalId}/readers/{userId}", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject readJournal(@PathVariable String typeId, @PathVariable String journalId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W readJournal started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId + ",userId=" + userId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W readJournal ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [PUT] 수신 확인 처리
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/journals/{journalId}/receivers/{userId}", method= RequestMethod.PUT, produces="application/json;charset=UTF-8")
	public JSONObject receiveOKJournal(@PathVariable String typeId, @PathVariable String journalId, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W receiveOKJournal started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId + ",userId=" + userId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W receiveOKJournal ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 첨부파일 업로드
	 */
	@RequestMapping(value="/rest/ezjournal/attachfiles", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject uploadFile(@RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W uploadFile started.");
		
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
			
			LOGGER.debug("####cnt:" + cnt + ", maxSize:" + maxSize + "userId:" + userId);
			
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
	        	tempFile.mkdir();
	        }
			
	        for (int i = 0; i < cnt; i++) {
	        	fileSize[i] = (Long) ((JSONObject)fileArray.get(i)).get("fileSize");
        		
	        	// maxsize를 넘어가는 파일은 저장하지 않는다.
	            if (fileSize[i] > maxSize && maxSize != 0) {
	                resultUpload[i] = "overflow";
	            } else {
	            	// 허용하는 확장자가 아닌경우 저장하지 않는다.
                    if (useExtension.toLowerCase().indexOf(pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1).toString().toLowerCase()) == -1 && !useExtension.equals("*")) {
                        resultUpload[i] = "denied";
                    } else {
                        String pAttachPath = pDirPath + "tempUploadFile" + commonUtil.separator;
//                        
                        // 업로드된 파일 데이터를 파일로 저장한다.
                        journalWriteUploadedFile((String)((JSONObject)fileArray.get(i)).get("bytes"), pUploadSN[i] + ";" + pFileName[i], pAttachPath);
                        
                        fileLocation[i] = commonUtil.getUploadPath("upload_journal.ROOT", info.getTenantId()) + commonUtil.separator + "tempUploadFile" + commonUtil.separator + pUploadSN[i] + ";" + pFileName[i];
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
		}
		
		LOGGER.debug("ezJournal G/W uploadFile ended.");
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
    	LOGGER.debug("journalWriteUploadedFile started.");
    	
		InputStream stream = null;
		OutputStream bos = null;
		String stordFilePathReal = (stordFilePath == null ? "" : stordFilePath);
		
		try {
		    File cFile = new File(stordFilePathReal);
	
		    if (!cFile.isDirectory()) {
				boolean _flag = cFile.mkdirs();
				if (!_flag) {
				    throw new IOException("Directory creation Failed ");
				}
		    }
	
		    bos = new FileOutputStream(stordFilePathReal + File.separator + newName);
		    LOGGER.debug("###" + stordFilePathReal + File.separator + newName + "###");
		    Decoder decoder = Base64.getDecoder();

		    bos.write(decoder.decode(bytearray));

		} catch (FileNotFoundException fnfe) {
			LOGGER.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			LOGGER.debug("ioe: {}", ioe);
		} catch (Exception e) {
			LOGGER.debug("e: {}", e);
		} finally {
		    if (bos != null) {
				try {
				    bos.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		    if (stream != null) {
				try {
				    stream.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		}
		LOGGER.debug("journalWriteUploadedFile ended.");
    }
	
	/**
	 * 업무일지 G/W [GET] 첨부파일 리스트
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/journals/{journalId}/attachfiles", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject attachList(@PathVariable String typeId, @PathVariable String journalId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W attachList started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  userId);
			
			List<JournalAttachVO> list = ezJournalService.getAttachList(journalId, info.getTenantId());
			
			//파일사이즈 단위 수정
			String fileSize = "";
			for (int i=0; i<list.size(); i++) {
				fileSize = list.get(i).getFileSize();
				double fs = Double.parseDouble(fileSize);
				
				if (fs / 1024 / 1024 > 1) {
					fileSize = Math.floor(fs / 1024 / 1024 * 10) / 10 + "MB";
				} else if ((fs / 1024) > 1) {
					fileSize = (int)(fs/1024) + "KB"; 
				} else {
					fileSize = Integer.parseInt(fileSize) + "B";
				}
				
				list.get(i).setFileSize(fileSize);
				//filePath 및 fileName 인코딩
				list.get(i).setEncodeFilePath(URLEncoder.encode(list.get(i).getFilePath(), "UTF-8"));
				list.get(i).setEncodeFileName(URLEncoder.encode(list.get(i).getFileName(), "UTF-8"));
			}
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", list);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		LOGGER.debug("ezJournal G/W attachList ended.");
	
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 첨부파일 삭제
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/journals/{journalId}/attachfiles", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteFile(@PathVariable String typeId, @PathVariable String journalId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W deleteFile started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  userId);
		
			String mode = "";
			if (request.getParameter("mode") != null || request.getParameter("mode").equals("")) {
				mode = request.getParameter("mode");
			}
			String pDirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_journal.ROOT", info.getTenantId());
			String filePath = request.getParameter("filePath");
			String fileList = request.getParameter("fileList");
			
			LOGGER.debug("pDirPath : " + pDirPath + " | fileList : " + fileList);
			
			// journalId가 temp이면 임시파일 삭제의 의미 (있으면 journalId에 해당하는 일지의 첨부파일 삭제해야함)
			if (journalId.equals("temp")) {
				if (fileList.length() != 0) {
					String[] data = fileList.split(","); 
					
					for (int i=0; i<data.length; i++) {
						String sGUID = data[i].split(";")[0];
						String fileName = data[i].split(";")[1];
						LOGGER.debug("sGUID:" + sGUID + ",fileName:" + fileName);
						
						File file = new File(pDirPath + commonUtil.separator + filePath + commonUtil.separator + sGUID + ";" + fileName);
						
						file.delete();
					}			
				}
			} else {
				if (fileList.length() != 0) {
					String[] data = fileList.split(","); 
					
					for (int i=0; i<data.length; i++) {
						String sGUID = data[i].split(";")[0];
						String fileName = data[i].split(";")[1];
						LOGGER.debug("sGUID:" + sGUID + ",fileName:" + fileName);
						
						File file = new File(pDirPath + commonUtil.separator + filePath + commonUtil.separator + sGUID + ";" + fileName);
						
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
		}
		
		LOGGER.debug("ezJournal G/W deleteFile ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 첨부파일 다운로드
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/journals/{journalId}/attachfiles/{fileId}", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject downloadFile(@PathVariable String typeId, @PathVariable String journalId, @PathVariable String fileId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W downloadFile started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId + ",fileId=" + fileId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W downloadFile ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 일지 수신자 저장
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/journals/{journalId}/receivers", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject saveReceiver(@PathVariable String typeId, @PathVariable String journalId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W saveReceiver started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W saveReceiver ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 일지 수신자 리스트 
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/journals/{journalId}/receivers", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getReceiverList(@PathVariable String typeId, @PathVariable String journalId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getReceiverList started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W getReceiverList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 일지 수신자 삭제
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/journals/{journalId}/receivers", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteReceiver(@PathVariable String typeId, @PathVariable String journalId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W deleteReceiver started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W deleteReceiver ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 수신자 즐겨찾기 리스트
	 */
	@RequestMapping(value="/rest/ezjournal/users/{userId}/favorites", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getFavoriteList(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getFavoriteList started.");
		LOGGER.debug("userId=" + userId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			List<ReceiverFavoriteVO> favoriteList = ezJournalService.getFavoriteList(userId, info.getTenantId() + "", info.getOffSet());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", favoriteList);
			
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("ezJournal G/W getFavoriteList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 수신자 즐겨찾기 저장
	 */
	@RequestMapping(value="/rest/ezjournal/users/{userId}/favorites", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject saveFavorite(@PathVariable String userId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W saveFavorite started.");
		LOGGER.debug("userId=" + userId);
		
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
		}
		
		LOGGER.debug("ezJournal G/W saveFavorite ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [PUT] 수신자 즐겨찾기 수정
	 */
	@RequestMapping(value="/rest/ezjournal/users/{userId}/favorites/{favoriteId}", method= RequestMethod.PUT, produces="application/json;charset=UTF-8")
	public JSONObject updateFavorite(@PathVariable String userId, @PathVariable String favoriteId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W updateFavorite started.");
		LOGGER.debug("userId=" + userId + ",favoriteId=" + favoriteId);
		
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
			
		}
		
		LOGGER.debug("ezJournal G/W updateFavorite ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 수신자 즐겨찾기 삭제
	 */
	@RequestMapping(value="/rest/ezjournal/users/{userId}/favorites/{favoriteId}", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteFavorite(@PathVariable String userId, @PathVariable String favoriteId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W deleteFavorite started.");
		LOGGER.debug("userId=" + userId + ",favoriteId=" + favoriteId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			ezJournalService.deleteFavorite(favoriteId, userId, info.getTenantId() + "");
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
		}
		
		LOGGER.debug("ezJournal G/W deleteFavorite ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 수신자 즐겨찾기 유저 리스트
	 */
	@RequestMapping(value="/rest/ezjournal/users/{userId}/favorites/{favoriteId}/users", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getFavoriteUserList(@PathVariable String userId, @PathVariable String favoriteId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getFavoriteUserList started.");
		LOGGER.debug("userId=" + userId + ",favoriteId=" + favoriteId);
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			LOGGER.debug("servername: " + serverName);
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			List<JournalAuthorVO> userList = ezJournalService.getFavoriteUserList(favoriteId, info.getTenantId() + "");
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", userList);
			
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("ezJournal G/W getFavoriteUserList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 댓글 리스트 조회
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/journals/{journalId}/replies", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getReplies(@PathVariable String typeId, @PathVariable String journalId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getReplies started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W getReplies ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 댓글 저장
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/journals/{journalId}/replies", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject saveReply(@PathVariable String typeId, @PathVariable String journalId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W saveReply started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W saveReply ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [PUT] 댓글 수정
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/journals/{journalId}/replies/{replyId}", method= RequestMethod.PUT, produces="application/json;charset=UTF-8")
	public JSONObject updateReply(@PathVariable String typeId, @PathVariable String journalId, @PathVariable String replyId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W updateReply started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId + ",replyId=" + replyId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W updateReply ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [DELETE] 댓글 삭제
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/journals/{journalId}/replies/{replyId}", method= RequestMethod.DELETE, produces="application/json;charset=UTF-8")
	public JSONObject deleteReply(@PathVariable String typeId, @PathVariable String journalId, @PathVariable String replyId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W deleteReply started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId + ",replyId=" + replyId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W deleteReply ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 댓글 수 카운트
	 */
	@RequestMapping(value="/rest/ezjournal/types/{typeId}/journals/{journalId}/replies-count", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getReplyCount(@PathVariable String typeId, @PathVariable String journalId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getReplyCount started.");
		LOGGER.debug("typeId=" + typeId + ",journalId=" + journalId);
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W getReplyCount ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [POST] 환경설정 정보 저장
	 */
	@RequestMapping(value="/rest/ezjournal/users/{userId}/options", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject saveOption(@RequestParam Map<String,Object> param,@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W saveOption started.");

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
		}
		
		LOGGER.debug("ezJournal G/W saveOption ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [PUT] 환경설정 정보 수정
	 */
	@RequestMapping(value="/rest/ezjournal/users/{userId}/options", method= RequestMethod.PUT, produces="application/json;charset=UTF-8")
	public JSONObject updateOption(@PathVariable String userId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W updateOption started.");
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("ezJournal G/W updateOption ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 환경설정 정보 조회
	 */
	@RequestMapping(value="/rest/ezjournal/users/{userId}/options", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getOption(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getOption started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			JournalEnvVO journalOpt = ezJournalService.getUserJournalEnv(userId, info.getTenantId() + "");
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", journalOpt);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("ezJournal G/W getOption ended.");
		return result;
	}
	
	// 공통 부분 API
	/**
	 * 업무일지 G/W [GET] 회사리스트 
	 */
	@RequestMapping(value="/rest/ezjournal/companies", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getCompanyList(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getCompanyList started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = request.getParameter("companyId");
			if (companyId == null || companyId.equals("")) {
				companyId = info.getCompanyId();
			}
			
			List<JournalCompanyVO> compList = ezJournalService.getCompanyList(userId, info.getTenantId() + "", companyId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", compList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("ezJournal G/W getCompanyList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 부서리스트 
	 */
	@RequestMapping(value="/rest/ezjournal/depts", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getDeptList(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getDeptList started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			LOGGER.debug("userId : " + userId);
			
			List<DeptViewVO> deptList = ezJournalService.getDeptViewList(userId, info.getCompanyId(), info.getTenantId() + "");
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", deptList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("ezJournal G/W getDeptList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 사원리스트 
	 */
	@RequestMapping(value="/rest/ezjournal/users", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getUserList(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getUserList started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String key = request.getParameter("key");
			String value = request.getParameter("value");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			List<JournalAuthorVO> userList = ezJournalService.getDeptUserList(info.getTenantId() + "", key, value);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", userList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("ezJournal G/W getUserList ended.");
		return result;
	}
	
	/**
	 * 업무일지 G/W [GET] 수신일지개수 
	 */
	@RequestMapping(value="/rest/ezjournal/users/{userId}/recv-count", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getRecvJournalCount(@PathVariable String userId,HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W getRecvJournalCount started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			String recvCount = ezJournalService.getRecvJournalCount(userId, info.getTenantId() + "");
		
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", recvCount);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("ezJournal G/W getRecvJournalCount ended.");
		return result;
	}
}
