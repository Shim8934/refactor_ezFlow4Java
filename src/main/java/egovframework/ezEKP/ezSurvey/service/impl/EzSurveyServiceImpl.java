package egovframework.ezEKP.ezSurvey.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezSurvey.dao.EzSurveyDAO;
import egovframework.ezEKP.ezSurvey.service.EzSurveyService;
import egovframework.ezEKP.ezSurvey.vo.SurveyVO;

@Service("EzSurveyService")
public class EzSurveyServiceImpl implements EzSurveyService {

	private static final Logger Logger = LoggerFactory.getLogger(EzSurveyServiceImpl.class);
	
	@Resource(name="EzSurveyDAO")
	private EzSurveyDAO ezSurveyDAO;
	
}
