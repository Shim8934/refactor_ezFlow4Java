package egovframework.ezEKP.ezEmail.task;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EmailImportance;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.type.NotiPlatform;
import egovframework.ezEKP.ezPersonal.type.NotiType;
import egovframework.ezEKP.ezSurvey.vo.SurveyParticipantVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Component
public class EzEmailAsync {
	private static final Logger logger = LoggerFactory.getLogger(EzEmailAsync.class);

	@Resource(name = "egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzEmailService ezEmailService;

	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;

	@Autowired
	private Properties config;

	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	
	@Autowired
	private EzPersonalService ezPersonalService;
	
	@Resource(name = "jspw")
	private String jspw;

	@Async
	public void cancelMailDelete(String num, int tenantID, Locale locale) {
		logger.debug("cancelMailDelete async methoed started.");
		logger.debug("num=" + num);
		
		try {
			final String messageId = ezEmailService.getMailReceiveMessageId(num);
			
			if (messageId == null) {
				logger.error("cannot get messageId from DB.");
				return;
			}
			
			String password = jspw;
			List<String> addresses = ezEmailService.getMailReceiveAddress(num);
						
			String isReadDeleteStr = ezCommonService.getTenantConfig("IS_READ_DELETE", tenantID);
			boolean isReadDelete = false;

			if (isReadDeleteStr.equals("YES")) {
				isReadDelete = true;
			}
			
			recallMailByMessageId(addresses, password, messageId, num, locale, isReadDelete);
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("cancelMailDelete async methoed ended.");
	}
	
	private void recallMailByMessageId(List<String> recallMailList, String password, String messageId, String num, Locale locale, boolean isReadDelete) {
		IMAPAccess ia = null;
		JSONObject recallMailInfo = null;
		String senderEmail = null;
		JSONArray mailList = null;
		JSONObject mailInfo = null;
		String folderName = null;
		long mailUid = 0;
		
		String senderSentMailBoxName = ezEmailUtil.getSentFolderId(locale);
		String senderDraftMailBoxName = ezEmailUtil.getDraftsFolderId(locale);
		
		for (String address : recallMailList) {
			try {
				int jobCode = 3; // jobCode (1:발견후 삭제, 2:발견하였으나 읽은 메일, 3:발견하지 못함)
				
				recallMailInfo = ezEmailService.recallMailByMessageId(address, messageId);
				
				if (recallMailInfo == null) {
					logger.debug("Get recallMailInfo failed. Move to the next user...");
					continue;
				}
				
				senderEmail = (String) recallMailInfo.get("senderEmail");
				mailList = (JSONArray) recallMailInfo.get("mailList");
				
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"),
						config.getProperty("config.IMAPPort"), address, password, egovMessageSource, locale, ezEmailUtil);
					        	
				for (int i = 0; i < mailList.size(); i++) {
					mailInfo = (JSONObject) mailList.get(i);
					folderName = (String) mailInfo.get("mailboxName");
					mailUid = (long) mailInfo.get("mailUid");
					
					if (senderEmail.equals(address) && (folderName.equals(senderDraftMailBoxName) || folderName.equals(senderSentMailBoxName))) {
						logger.debug("This mailbox is sender mailbox Draft or Sent.");
						continue;
					}
					
					Folder folder = ia.getFolder(folderName);
					
					try {
						if (folder.exists()) {
							folder.open(Folder.READ_WRITE);
							Message message = ((IMAPFolder)folder).getMessageByUID(mailUid);
							
							// 사용자가 메일을 복사하여 같은 메일이 여러개 있고 isReadDelete가 true일 경우(읽어도 회수)
							// 읽은 메일은 회수하지 않고, 읽지 않은 메일은 모두 회수한다.
							// 읽은 메일이 하나라도 있을 경우 읽음으로 처리한다.
							if (message.isSet(Flags.Flag.SEEN)) {               // 사용자가 메일을 읽었을 경우
								if (isReadDelete) {                             // 읽어도 회수할 경우
									message.setFlag(Flags.Flag.DELETED, true);  // 메일 삭제
									jobCode = 1;                                // 회수 처리
								} else {                                        // 읽은 메일 회수하지 않을 경우
									jobCode = 2;                                // 읽음 처리
								}
							} else {                                            // 사용자가 메일을 읽지 않았을 경우
								message.setFlag(Flags.Flag.DELETED, true);      // 메일 삭제
								
								if (jobCode != 2) {                             // 읽음 처리가 안되었을 경우
									jobCode = 1;                                // 회수 처리
								}
							}
							
							folder.close(true);
						}
					} catch (MessagingException e) {
						logger.error(e.getMessage(), e);
						logger.debug("mail Flags update error. so move the next mailbox.");
						continue;
					}
				}
				
				logger.debug("address=" + address + ",jobCode=" + jobCode + ",messageId=" + messageId + ",num=" + num);
				ezEmailService.updateMailReceiveDetailInfo(num, new String[] {address, String.valueOf(jobCode)});
				
				ia.close();
				ia = null;
			
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
		}
	}
	
	@Async
	public void sendMail(List<SurveyParticipantVO> userList, SurveyVO survey, String offset) {
		String creatorId = survey.getCreatorId();
		String title = survey.getTitle();
		long surveyId = survey.getSurveyId();
		
		String endDateUTC     = survey.getEndDate();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		Date timeUTC;
		String endDateString = null ;
		String realTimeZone = "";
		StringBuilder sb = new StringBuilder();
		
		try {
			timeUTC = formatter.parse(endDateUTC);
			endDateString = new SimpleDateFormat("yyyy-MM-dd").format(timeUTC);
			String timeZone = ezCommonService.selectUserGetTimeZone(survey.getCreatorId(), survey.getTenantId());
			System.out.println("timezone" + timeZone);
			String[] timeZoneArr = timeZone.split("\\|");
			realTimeZone = " ( UTC | " + timeZoneArr[1] + " )";
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		/* 2021-11-18 홍승비 - 전자설문 메일발송 대상자 중복제거 Set 추가 */
		Set<String> mailSendSet = new HashSet<String>();
		for (int i = 0; i < userList.size(); i++) {
			try {
				SurveyParticipantVO userinfo = userList.get(i);
				String userAccount = userinfo.getEmail();
				
				String userId = userAccount.split("@")[0];
				
				String domainName = ezCommonService.getTenantConfig("DomainName", userinfo.getTenantId());
				int tenantId = ezCommonService.getTenantIdByDomainName(domainName);
				
				if (ezPersonalService.hasNotiDiableItem(userId, NotiType.fromString("SURVEY_NEW"), NotiPlatform.MAIL, tenantId)) {
					continue;
				}
				
				String lang = ezCommonService.selectUserGetLang(userId, tenantId);
				lang = lang == null ? "1" : lang;
				Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(lang));
				String subject = egovMessageSource.getMessage("ezSurvey.mailAlert.JIH001", locale) + title;
				
				String creatorName = locale.toString().equals("ko") ? survey.getCreatorName1() : survey.getCreatorName2();
				logger.debug("userAccount : " + userAccount + ", locale=" + locale);

				if (i == 0) {
					sb.append("<span>" + egovMessageSource.getMessage("ezSurvey.mailAlert.JIH002", locale) + "</span><br><br>");
					sb.append("<span>" + egovMessageSource.getMessage("ezSurvey.mailAlert.JIH003", locale) + "</span>");
					sb.append("<span id='survey_a' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:window.open('../ezSurvey/surveyDetail.do?itemId=" + surveyId + "', '', 'width=835, height=900, scrollbars=yes, resizable=yes')\">");
					sb.append(commonUtil.cleanValue(title) + "</span><br>");
					sb.append("<span>" + egovMessageSource.getMessage("ezSurvey.mailAlert.JIH004", locale) + " " + creatorName + "</span><br>");
					sb.append("<span>" + egovMessageSource.getMessage("ezSurvey.mailAlert.JIH005", locale) + " " + endDateString + "</span>" + realTimeZone + "<br>");
				}

				String content = commonUtil.createNotiMailContent(sb.toString(), tenantId, locale);
				
				InternetAddress from;
				from = new InternetAddress(creatorId + "@" + domainName);
				from.setPersonal(creatorName);
				
				String user = userId + "@" + domainName;
				InternetAddress toMember = new InternetAddress();
				String toMemberName = locale.toString().equals("ko") ? userinfo.getUserName1() : userinfo.getUserName2();
				toMember.setAddress(user);
				toMember.setPersonal(toMemberName);
				
				// 메일을 발송하지 않은 대상에게만 메일을 발송한 뒤, set에 저장한다.
				if (!mailSendSet.contains(user)) {
					ezEmailService.sendMail(user, jspw, locale, from, new InternetAddress[]{ toMember }, null, null, subject, content.toString(), false, EmailImportance.NORMAL);
					mailSendSet.add(user);
				}
				
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		}
	}
}


