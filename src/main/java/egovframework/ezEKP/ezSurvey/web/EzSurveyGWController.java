package egovframework.ezEKP.ezSurvey.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezJournal.vo.JournalPagination;
import egovframework.ezEKP.ezSurvey.service.EzSurveyService;
import egovframework.ezEKP.ezSurvey.vo.Pagination;
import egovframework.ezEKP.ezSurvey.vo.SurveyVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzSurveyGWController {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzSurveyGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties globals;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzSurveyService")
	private EzSurveyService ezSurveyService;
	
	/**
	 * 설문 리스트 호출  method
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/rest/ezSurvey/survey-list/user/{userId}")
	public JSONObject gwSurveyList(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [GET /rest/ezSurvey/survey-list/user/" +userId + "] started.");

		JSONObject result = new JSONObject();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		
		int totalCount = ezSurveyService.getSurveyCount(map);
		
		Pagination pagination = new Pagination();
		
		pagination.setTotalRows(totalCount);
		int beginIndex = pagination.getBeginIndex();
		map.put("beginIndex", beginIndex);

		int rows = pagination.getRows();
		map.put("rows", rows);
		
		List<SurveyVO> surveyList = ezSurveyService.getSurveyList(map);
		LOGGER.debug("리스트: " + surveyList);
		result.put("status", "ok");
		result.put("code", 0);
		result.put("surveyList", surveyList);
		result.put("pagination", pagination);
		
		LOGGER.debug("G/W MEMO [GET /rest/ezSurvey/survey-list/user/" +userId + "] ended.");
		return result;
	}
}
