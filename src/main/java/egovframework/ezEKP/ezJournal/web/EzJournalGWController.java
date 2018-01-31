package egovframework.ezEKP.ezJournal.web;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import egovframework.ezEKP.ezJournal.service.EzJournalService;
import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;
import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;
import egovframework.ezMobile.ezApprovalG.web.MApprovalGGWController;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzJournalGWController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MApprovalGGWController.class);

	@Autowired
	private EzJournalService ezJournalService;
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@RequestMapping(value = "/ezjournal/types", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public Object journalTypeList(HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W JOURNAL [GET /ezJournal/types] started.");
		
		JSONObject result = new JSONObject();
		
		String companyId = request.getParameter("companyId");
		String tenantId = request.getParameter("tenantId");
		
		LOGGER.debug("companyId : " + companyId);
		LOGGER.debug("tenantId : " + tenantId);
		
		try {
			List<JournaltypeVO> typeList = ezJournalService.getJournaltypeList(companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("typeList", typeList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
		}

		LOGGER.debug("G/W JOURNAL [GET /ezJournal/types] ended.");
		
		return result;
	}
	
	@RequestMapping(value = "/ezjournal/types", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public Object journalTypeUpdate(@RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W JOURNAL [PUT /ezJournal/types] started.");
		JSONObject result = new JSONObject();

		String tenantId = (String) jsonParam.get("tenantId");
		String companyId = (String) jsonParam.get("companyId");
		@SuppressWarnings("unchecked")
		ArrayList<Map<String, String>> journaltypeList = (ArrayList<Map<String, String>>) jsonParam.get("journaltypeList");
		
		
		try {
			ezJournalService.updateJournaltype(journaltypeList, companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
		}

		LOGGER.debug("G/W JOURNAL [PUT /ezJournal/types] ended.");
		
		return result;
	}	
	/**
	 * 업무일지 G/W [GET] 양식 리스트 조회 (부서사용가능 양식리스트, 취합가능 양식리스트)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezjournal/types/{typeId}/forms", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object journalFormList(HttpServletRequest request, @PathVariable String typeId,  
			@RequestParam(value="deptId", required=false) String deptId,
			@RequestParam(value="companyId", required=true) String companyId,
			@RequestParam(value="tenantId", required=true) String tenantId) {
		LOGGER.debug("ezJournal G/W journalFormList started.");
		LOGGER.debug("typeId=" + typeId + ",deptId=" + deptId + ",companyId=" + companyId + ",tenantId=" + tenantId);

		JSONObject result = new JSONObject();
		
		try {

			typeId = URLDecoder.decode(typeId, "UTF-8");
			//String serverName = request.getHeader("x-user-host");
			
			JSONObject data = new JSONObject();
			
			if (deptId == "" || deptId == null) {
				List<JournalFormInfoVO> fList = ezJournalService.getFormList(typeId, companyId, tenantId);
				data.put("fList", fList);

			} else {
				List<JournalFormInfoVO> fList = ezJournalService.getDeptUseFormList(typeId, companyId, tenantId, deptId);
				data.put("fList", fList);
			}
			
			// 취합가능양식조회
			List<JournalFormInfoVO> basicList = ezJournalService.getBasicFormList(companyId, tenantId);
			data.put("basicList", basicList);
			
			result.put("data", data);
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
	
	
	@RequestMapping(value = "/ezjournal/test", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public Object journalTest(HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W JOURNAL [GET /ezJournal/types] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
		}

		LOGGER.debug("G/W JOURNAL [GET /ezJournal/types] ended.");
		
		return result;
	}
	
		
	/**
	 * 업무일지 G/W [POST] 양식 저장
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezjournal/types/{typeId}/forms", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject insertForm(@PathVariable String typeId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezJournal G/W insertForm started.");
		LOGGER.debug("typeId=" + typeId);
		
		JSONObject result = new JSONObject();
		
		try {
			String content = jsonParam.get("formContent").toString();
			content = content.replaceAll("%(?![0-9a-fA-F]{2})", "%25");
			content = content.replaceAll("\\+", "%2B");
			content = URLDecoder.decode(content, "utf-8");
			
			String scheme = "http://";
			if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
				scheme = "https://";
			}

			content = content.replace("replace_" + scheme, scheme);
			
			jsonParam.put("content", content);
			
			ezJournalService.insertForm(jsonParam);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			
		}
		
		LOGGER.debug("ezJournal G/W insertForm ended.");
		return result;
	}
	
}
