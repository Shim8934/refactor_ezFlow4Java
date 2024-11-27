package egovframework.ezEKP.ezSurvey.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.task.EzEmailAsync;
import egovframework.ezEKP.ezEmail.task.EzEmailScheduler;
import egovframework.ezEKP.ezNotification.service.EzNotificationService;
import egovframework.ezEKP.ezSurvey.service.EzSurveyService;
import egovframework.ezEKP.ezSurvey.vo.SurveyParticipantVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyVO;

//@Controller
@Component
public class EzSurveyScheduler {

	private static final Logger logger = LoggerFactory.getLogger(EzSurveyScheduler.class);
	
	@Resource(name = "EzSurveyService")
	private EzSurveyService ezSurveyService;
	
	@Resource(name = "EzEmailService")
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzEmailScheduler ezEmailScheduler;
	
	@Autowired
	private EzEmailAsync ezEmailAsync;
	
	@Autowired
	private EzNotificationService ezNotificationService;
	
	@Resource(name = "jspw")
    private String jspw;
	
	@SuppressWarnings("deprecation")
	@Scheduled(cron = "${config.cron.sendMailToSurveyParticipant}")
//	@RequestMapping(value = "/ezSurvey/tt.do")
	public void sendMailToSurveyParticipant() throws Exception {
		logger.debug("sendMailToSurveyParticipant scheduler started.");
		
		//choose scheduler running server
		if (!ezEmailScheduler.preScheduler("sendMailToSurveyParticipant")) {
			logger.debug("sendMailToSurveyParticipant scheduler ended.");
			return;
		}
		
		int offset = - new Date().getTimezoneOffset();
		
		
		List<SurveyVO> todaySurveyList = ezSurveyService.getTodaySurveyList(offset);
		
		if (todaySurveyList == null || todaySurveyList.size() == 0) {
			logger.debug("sendMailToSurveyParticipant scheduler ended.");
			return;
		}
		
		for (int i = 0; i < todaySurveyList.size(); i++) {
			SurveyVO survey = todaySurveyList.get(i);
			long surveyId = todaySurveyList.get(i).getSurveyId();
			String companyId = todaySurveyList.get(i).getCompanyId();
			int tenantId = todaySurveyList.get(i).getTenantId();
			List<SurveyParticipantVO> participantList = ezSurveyService.getSurveyParticipantListForMail(surveyId, companyId, tenantId);
			
			if (survey.getMailFlag() == 1 && survey.getMailSentFlag() == 0) {
				ezEmailAsync.sendMail(participantList, survey, Integer.toString(offset));
				ezSurveyService.updateMailSentFlag(surveyId, 1, companyId, tenantId);
			}
			
			if (survey.getTotalNotiSentFlag() == 0) {
				List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
				Set<String> recipientSet = new HashSet<String> ();
				for (SurveyParticipantVO surveyParticipant : participantList) {
					Map<String, Object> recipientMap = new HashMap<String, Object>();
					recipientMap.put("userType", "PERSON");
					recipientMap.put("companyId", surveyParticipant.getCompanyId());
					recipientMap.put("cn", surveyParticipant.getUserId());
					if (!recipientSet.contains(surveyParticipant.getUserId())) {
						notiRecipientList.add(recipientMap);
						recipientSet.add(surveyParticipant.getUserId());
					}
				}
				
				if (notiRecipientList != null && notiRecipientList.size() > 0) {
					String linkUrl = "/ezSurvey/surveyDetail.do?itemId=" + surveyId;
			    	String linkUrlMobile = "";
			    	ezNotificationService.sendNoti(survey.getCreatorId(), survey.getCreatorName1(), notiRecipientList, "SURVEY", "NEW", survey.getTitle(), "popup", "760", "750", linkUrl, linkUrlMobile, "");
			    	ezSurveyService.updateTotalNotiSentFlag(surveyId, 1, companyId, tenantId);
				}
			}
		}
		
		logger.debug("sendMailToSurveyParticipant scheduler ended.");
	}
}