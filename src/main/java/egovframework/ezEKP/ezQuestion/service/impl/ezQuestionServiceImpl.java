package egovframework.ezEKP.ezQuestion.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezQuestion.dao.ezQuestionDAO;
import egovframework.ezEKP.ezQuestion.service.ezQuestionService;

@Service("EzQuestionService")
public class ezQuestionServiceImpl implements ezQuestionService{
	
	@Resource(name="EzQuestionDAO")
	private ezQuestionDAO ezQuestionDAO;
}
