package egovframework.ezEKP.ezSurvey.service.impl;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezSurvey.dao.EzSurveyDAO;
import egovframework.ezEKP.ezSurvey.service.EzSurveyService;

@Service("EzSurveyService")
public class EzSurveyServiceImpl implements EzSurveyService {

	private static final Logger Logger = LoggerFactory.getLogger(EzSurveyServiceImpl.class);
	
	@Resource(name="EzSurveyDAO")
	private EzSurveyDAO ezSurveyDAO;
	
}
