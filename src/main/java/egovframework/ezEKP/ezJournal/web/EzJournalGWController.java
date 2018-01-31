package egovframework.ezEKP.ezJournal.web;

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
	
}