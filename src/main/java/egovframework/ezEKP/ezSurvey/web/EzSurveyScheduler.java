package egovframework.ezEKP.ezSurvey.web;

import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.task.EzEmailAsync;
import egovframework.ezEKP.ezEmail.task.EzEmailScheduler;
import egovframework.ezEKP.ezEmail.util.EmailImportance;
import egovframework.ezEKP.ezSurvey.service.EzSurveyService;
import egovframework.ezEKP.ezSurvey.vo.SurveyParticipantVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyVO;
import egovframework.let.utl.fcc.service.CommonUtil;

//@Controller
@Component
public class EzSurveyScheduler {

	private static final Logger logger = LoggerFactory.getLogger(EzSurveyScheduler.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "EzSurveyService")
	private EzSurveyService ezSurveyService;
	
	@Resource(name = "EzEmailService")
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzEmailScheduler ezEmailScheduler;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzEmailAsync ezEmailAsync;
	
	@Resource(name = "jspw")
    private String jspw;
	
	@SuppressWarnings("deprecation")
	@Scheduled(cron = "${config.cron.sendMailToSurveyParticipant}")
//	@RequestMapping(value = "/ezSurvey/tt.do")
	public void sendMailToSurveyParticipant() throws Exception{
		logger.debug("sendMailToSurveyParticipant scheduler started.");
		
		//choose scheduler running server
		if (!ezEmailScheduler.preScheduler("sendMailToSurveyParticipant")) {
			logger.debug("sendMailToSurveyParticipant scheduler ended.");
			return;
		}
		
		int offset = - new Date().getTimezoneOffset();
		
		
		List<SurveyVO> todaySurveyList = ezSurveyService.getTodaySurveyList(offset);
		
		if (todaySurveyList == null || todaySurveyList.size() == 0) {
			return;
		}
		
		for (int i = 0; i < todaySurveyList.size(); i++) {
			SurveyVO survey = todaySurveyList.get(i);
			long surveyId = todaySurveyList.get(i).getSurveyId();
			String companyId = todaySurveyList.get(i).getCompanyId();
			int tenantId = todaySurveyList.get(i).getTenantId();
			
			List<SurveyParticipantVO> participantList = ezSurveyService.getSurveyParticipantListForMail(surveyId, companyId, tenantId);
			
			ezEmailAsync.sendMail(participantList, survey, Integer.toString(offset));
			ezSurveyService.updateMailSentFlag(surveyId, 1, companyId, tenantId);
		}
		
		logger.debug("sendMailToSurveyParticipant scheduler ended.");
	}
}