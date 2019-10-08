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
		
		if (todaySurveyList == null) {
			return;
		}
		
		for (int i = 0; i < todaySurveyList.size(); i++) {
			SurveyVO survey = todaySurveyList.get(i);
			long surveyId = todaySurveyList.get(i).getSurveyId();
			String companyId = todaySurveyList.get(i).getCompanyId();
			int tenantId = todaySurveyList.get(i).getTenantId();
			
			List<SurveyParticipantVO> participantList = ezSurveyService.getSurveyParticipantListForMail(surveyId, companyId, tenantId);
			
			sendMail(participantList, survey);
		}
		
		logger.debug("sendMailToSurveyParticipant scheduler ended.");
	}
	
	private void sendMail(SurveyParticipantVO userinfo, SurveyVO survey) throws Exception {
		String userAccount = userinfo.getEmail();
		String password = jspw;
		
		String userId = userAccount.split("@")[0];
		String domainName = userAccount.split("@")[1];
		int tenantId = ezCommonService.getTenantIdByDomainName(domainName);
		String lang = ezCommonService.selectUserGetLang(userId, tenantId);
		Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(lang));
		logger.debug("userAccount : " + userAccount + ", locale=" + locale);
		
		String creatorId = survey.getCreatorId();
		String title = survey.getTitle();
		long surveyId = survey.getSurveyId();
		String creatorName = locale.toString().equals("ko") ? survey.getCreatorName1() : survey.getCreatorName2();
		
		String subject = title;
		StringBuilder sb = new StringBuilder();
		
		sb.append("<span style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:window.open('../ezSurvey/surveyDetail.do?itemId=" + surveyId + "', '', 'width=835, height=900, scrollbars=yes, resizable=yes')\">");
		sb.append("새로운 설문이 추가되었습니다.</span>");
		
		String content = commonUtil.createNotiMailContent(sb.toString(), tenantId, locale);
		
		InternetAddress from;
		from = new InternetAddress(creatorId + "@" + domainName);
		from.setPersonal(creatorName);
		
		InternetAddress toMember = new InternetAddress();
		String toMemberName = locale.toString().equals("ko") ? userinfo.getUserName1() : userinfo.getUserName2();
		toMember.setAddress(userinfo.getEmail());
		toMember.setPersonal(toMemberName);
		
		InternetAddress[] toArr = new InternetAddress[]{toMember};
		
		ezEmailService.sendMail(userAccount, password, locale, from, toArr, null, null, subject, content.toString(), false, EmailImportance.NORMAL);
	}
	
	private void sendMail(List<SurveyParticipantVO> userList, SurveyVO survey) throws Exception {
		for (int i = 0; i < userList.size(); i++) {
			sendMail(userList.get(i), survey);
		}
	}
	
}