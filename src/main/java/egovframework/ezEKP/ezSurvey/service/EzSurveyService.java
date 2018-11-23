package egovframework.ezEKP.ezSurvey.service;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezSurvey.vo.SurveyVO;

public interface EzSurveyService {

	public List<SurveyVO> getSurveyList(Map<String, Object> map) throws Exception;

	public int getSurveyCount(Map<String, Object> map);

}
