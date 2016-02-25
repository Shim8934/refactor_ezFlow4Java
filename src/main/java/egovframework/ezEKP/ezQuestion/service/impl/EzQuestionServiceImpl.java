package egovframework.ezEKP.ezQuestion.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezQuestion.dao.EzQuestionDAO;
import egovframework.ezEKP.ezQuestion.service.EzQuestionService;

@Service("EzQuestionService")
public class EzQuestionServiceImpl implements EzQuestionService{
	
	@Resource(name="EzQuestionDAO")
	private EzQuestionDAO ezQuestionDAO;
}
