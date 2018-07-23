package egovframework.ezEKP.ezPMS.task;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.ibm.icu.text.SimpleDateFormat;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.task.EzEmailScheduler;
import egovframework.ezEKP.ezEmail.util.EmailImportance;
import egovframework.ezEKP.ezPMS.service.EzPMSService;
import egovframework.ezEKP.ezPMS.vo.ProjectInfoVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMainSettingVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Component
public class EzPMSScheduler {

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name = "EzPMSService")
	private EzPMSService ezPMSService;
	
	@Resource(name = "EzEmailService")
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzEmailScheduler ezEmailScheduler;
	
	@Autowired
	private EzCommonService ezCommonService;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "jspw")
    private String jspw;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EzPMSScheduler.class);
	
	//예정 종료일을 넘어선 경우에는 진행 프로젝트의 상태를 지연으로 변경 (진행 프로젝트만 해당 됨)
	@Scheduled(cron = "${config.crone.pmsUpdateLateStatus}")
	public void updateLateStatus() throws Exception {
		LOGGER.debug("updateLateStatus started.");
		
		//choose scheduler running server
		if (!ezEmailScheduler.preScheduler("pmsUpdateLateStatus")) {
			LOGGER.debug("updateLateStatus scheduler ended.");
			return;
		}
		
		String searchStatus = "P";
		
		List<ProjectInfoVO> projectList = ezPMSService.getProgressProject(searchStatus);
		LOGGER.debug("projectList : " + projectList);
		
		Date nowDate = new SimpleDateFormat("yyyy-MM-dd").parse(commonUtil.getTodayUTCTime(""));
		
		for (int i = 0; i < projectList.size(); i++) {
			Date planEndDate = new SimpleDateFormat("yyyy-MM-dd").parse(projectList.get(i).getPlanEndDate());
			
			if (planEndDate.before(nowDate)) {
				LOGGER.debug(projectList.get(i).getProjectName() + " is late");
				ezPMSService.updateProjectStatus(projectList.get(i).getProjectId(), "L", projectList.get(i).getTenantId(), projectList.get(i).getRealStartDate(), projectList.get(i).getPlanEndDate());
			} else {
				LOGGER.debug(projectList.get(i).getProjectName() + " is not late");
			}
		}
		
		LOGGER.debug("updateLateStatus ended.");
	}
	
	//종료 알림 메일 전송
	@Scheduled(cron = "${config.crone.pmsUpdateLateStatus}")
	public void sendEndAlamMail() throws Exception {
		LOGGER.debug("sendEndAlamMail started.");
		
		//choose scheduler running server
		if (!ezEmailScheduler.preScheduler("pmsUpdateLateStatus")) {
			LOGGER.debug("updateLateStatus scheduler ended.");
			return;
		}
		
		String searchStatus = "P";
		
		List<ProjectInfoVO> projectList = ezPMSService.getProgressProject(searchStatus);
		LOGGER.debug("projectList : " + projectList);
		
		Date nowDate = new SimpleDateFormat("yyyy-MM-dd").parse(commonUtil.getTodayUTCTime(""));
		
		for (int i = 0; i < projectList.size(); i++) {
			int endAlamDueday = projectList.get(i).getAlamMailStatus();
			
			if (endAlamDueday != -1) {
				Date planEndDate = new SimpleDateFormat("yyyy-MM-dd").parse(projectList.get(i).getPlanEndDate());
				
				Calendar cal = Calendar.getInstance();
				cal.setTime(planEndDate);
				cal.add(Calendar.DATE, -endAlamDueday);
				
				Date endAlamDay = new SimpleDateFormat("yyyy-MM-dd").parse(new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime()));
				
				if (nowDate.equals(endAlamDay)) {
					LOGGER.debug(projectList.get(i).getProjectName() + " should get AlamMail");
					
					int isGantt = 1;
					List<ProjectMemberVO> memberList = ezPMSService.getProjectMemberList(projectList.get(i).getProjectId(), 4, "", projectList.get(i).getTenantId(), isGantt);
					
					ArrayList<InternetAddress> toArrList = new ArrayList<InternetAddress>();
					
					for (int j = 0; j < memberList.size(); j++) {
						InternetAddress toMember = new InternetAddress();
						ProjectMainSettingVO member = ezPMSService.getProjectMainSetting(memberList.get(j).getUserId(), memberList.get(j).getTenantId(), memberList.get(j).getUserIdType());
						toMember.setAddress(member.getUserMail());
						toMember.setPersonal(member.getUserName());
						
						LOGGER.debug("userMail : " + member.getUserMail() + ", userName : " + member.getUserName());
						toArrList.add(toMember);
					}
					
					InternetAddress[] toArr = new InternetAddress[toArrList.size()];
					
					for (int j = 0; j < toArrList.size(); j++) {
						toArr[j] = toArrList.get(j);
					}
					
					ProjectMainSettingVO headManager = ezPMSService.getProjectMainSetting(projectList.get(i).getHeadManagerId(), projectList.get(i).getTenantId(), "user");
					
					String userAccount = headManager.getUserMail();
					String password = jspw;
					
					String userId = userAccount.split("@")[0];
					String domainName = userAccount.split("@")[1];
					
					int tenantId = ezCommonService.getTenantIdByDomainName(domainName);
					String lang = ezCommonService.selectUserGetLang(userId, tenantId);
					Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(lang));
					LOGGER.debug("userAccount : " + userAccount + ", locale=" + locale);
					
					String subject = "[" + projectList.get(i).getProjectName() + egovMessageSource.getMessage("ezPMS.t326", locale) + projectList.get(i).getAlamMailStatus() + egovMessageSource.getMessage("ezPMS.t327", locale);
					
					String content = "<p>" + "[" + projectList.get(i).getProjectName() + egovMessageSource.getMessage("ezPMS.t326", locale) + projectList.get(i).getAlamMailStatus() + egovMessageSource.getMessage("ezPMS.t327", locale) + "</p>";
					content += "<p></p>";
					content += "<a href='#' target='' onclick='goProjectDetails(\"" + projectList.get(i).getProjectId() + "\")'>[" + projectList.get(i).getProjectName() + egovMessageSource.getMessage("ezPMS.t201", locale) + "</a><br/><br/>";
					content += "===================================================================<br/>";
					content += "<p style='font-size:14px'><strong>[" + projectList.get(i).getProjectName() + "]</strong></p>";
					content += "<p> - " + egovMessageSource.getMessage("ezPMS.t250", locale) + " : " + projectList.get(i).getProgress() + "</p>";
					content += "<p> - " + egovMessageSource.getMessage("ezPMS.t61", locale) + " : " + projectList.get(i).getPlanStartDate() + "</p>";
					content += "<p> - " + egovMessageSource.getMessage("ezPMS.t62", locale) + " : " + projectList.get(i).getPlanEndDate() + "</p>";
					content += "<p> - " + egovMessageSource.getMessage("ezPMS.t66", locale) + " : " + projectList.get(i).getOverview() + "</p>";
					
					InternetAddress from;
					from = new InternetAddress(headManager.getUserMail());
					from.setPersonal(headManager.getUserName());
					
					ezEmailService.sendMail(userAccount, password, locale, from, toArr, null, null, subject, content, false, EmailImportance.NORMAL);
					
				}
			}
		}
		
		LOGGER.debug("sendEndAlamMail ended.");
	}
	
	//예정 종료일을 넘어선 경우에는 업무의 상태를 지연으로 변경 (진행 업무만 해당 됨)
	@Scheduled(cron = "${config.crone.pmsUpdateLateStatus}")
	public void updateLateTaskStatus() throws Exception {
		LOGGER.debug("updateLateTaskStatus started.");
		
		//choose scheduler running server
		if (!ezEmailScheduler.preScheduler("pmsUpdateLateStatus")) {
			LOGGER.debug("updateLateStatus scheduler ended.");
			return;
		}
		
		String UTCTimeStr = commonUtil.getTodayUTCTime("");
		
		ezPMSService.updateTaskStatusScheduler(UTCTimeStr);
		
		LOGGER.debug("updateLateTaskStatus ended.");
	}
}
