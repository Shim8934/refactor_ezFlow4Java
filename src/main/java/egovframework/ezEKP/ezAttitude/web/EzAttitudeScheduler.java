package egovframework.ezEKP.ezAttitude.web;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.ibm.icu.text.SimpleDateFormat;

import egovframework.ezEKP.ezAttitude.service.EzAttitudeService;
import egovframework.ezEKP.ezEmail.task.EzEmailScheduler;

@Component
public class EzAttitudeScheduler {

	private static final Logger logger = LoggerFactory.getLogger(EzAttitudeScheduler.class);
	
	@Resource(name = "EzAttitudeService")
	private EzAttitudeService ezAttitudeService;
	
	@Autowired
	private EzEmailScheduler ezEmailScheduler;
	
	@Scheduled(cron = "${config.cron.autoSetAnnualHoliday}")
	public void autoSetAnnualHoliday() throws Exception{
		logger.debug("autoSetAnnualHoliday scheduler started.");
		
		//choose scheduler running server
		if (!ezEmailScheduler.preScheduler("attitudeAnnualGarbageClear")) {
			logger.debug("communityGarbageClear scheduler ended.");
			return;
		}
		
		List<Map<String, Object>> tenantCompanyIdList = ezAttitudeService.getTenantCompanyId();
		
		for (Map<String, Object> tenantCompanyMap : tenantCompanyIdList) {
			
			int tenantId = Integer.parseInt(String.valueOf(tenantCompanyMap.get("tenantId")));
			String companyId = (String)tenantCompanyMap.get("companyId");
			Map<String, Object> annualConf = ezAttitudeService.getAttitudeAnnualConfig(tenantId, companyId);
			
			String useAnnualAutoGnrt = (String)annualConf.get("useAnnualAutoGnrt");// 1:사용 0:미사용
			String annualGnrtStd = (String)annualConf.get("annualGnrtStd");// 0:입사일기준 1:회계연도기준
			String useAnnualTmnt = (String)annualConf.get("useAnnualTmnt");//연차소멸 여부 1:사용 0:미사용
			String initialDate = (String)annualConf.get("initialDate"); // 기산일 
			@SuppressWarnings("unused")
			String roundOffRule = (String)annualConf.get("roundOffRule");//1:0.5 0:1.0
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			String today = sdf.format(new Date());
			Date setDate = sdf.parse(today);
			
			Calendar cal = Calendar.getInstance();
			cal.setTime(setDate);
			cal.add(Calendar.DATE, -1);
	
			String yesterday = sdf.format(cal.getTime());
			
			// 입사년도 기준
			if (useAnnualAutoGnrt.equals("1")) {

				List<Map<String, Object>> list = ezAttitudeService.getJoinDateUserList(yesterday.split("-")[2], companyId, tenantId);
				
				if (annualGnrtStd.equals("0")) {
					for (Map<String, Object> m : list) {
						int workingMonthCnt = Integer.parseInt(String.valueOf(m.get("workingMonthCnt")));
						if (workingMonthCnt < 24) {
							if (workingMonthCnt == 12) {
								ezAttitudeService.updateAnnualHoliday(m); // 입사 후 1년이 되었을 때 연차 발생 (출근율 계산)
							} else if (workingMonthCnt < 12) {
								ezAttitudeService.updateMonthlyHoliday(m); // 입사 후 1년까지 달마다 월차 개념으로 연차가 최대 11개 발생
							} else {
								if (useAnnualTmnt.equals("1")) {
									m.put("today",today);
									ezAttitudeService.extinctionMonthlyHoliday(m); // 13개월이 되었을 때 달마다 연차 1개씩 소멸
								}
							}
						} else {
							ezAttitudeService.updateExceedAnnualHoliday(m); // 3년 차부터는 일반적인 계산법에 의해 연차 발생
						}
					}
			//회계년도 기준
				} else {
					for (Map<String, Object> m : list) {
						int workingMonthCnt = Integer.parseInt(String.valueOf(m.get("workingMonthCnt")));
						if (workingMonthCnt < 12) {
							ezAttitudeService.updateMonthlyHoliday(m); // 입사 후 1년까지 달마다 월차 개념으로 연차가 최대 11개 발생
						} else if (workingMonthCnt > 12) {
							if (workingMonthCnt < 24) {
								if (useAnnualTmnt.equals("1")) {
									m.put("today",today);
									ezAttitudeService.extinctionMonthlyHoliday(m); // 입사 후 12개월이 초과하고 24개월 미만이면 월차를 달마다 1개씩 소멸
								}
							}
						}
					}
					
					// 기산일에 연차를 발생시키는 메소드
					if (initialDate.substring(initialDate.indexOf("-") + 1).equals(yesterday.substring(yesterday.indexOf("-") + 1))) {
						ezAttitudeService.updateFiscalYearAnnualHoliday(annualConf);
					}	
				}
			}
			
			logger.debug("autoSetAnnualHoliday scheduler ended.");
		}
	}
	
	/**
	 * 근태관리 일근무, 반근무 자동 세팅
	 */
	@Scheduled(cron = "${config.cron.autoSetDailyWork}")
	public void autoSetDailyWork() throws Exception {
		logger.debug("autoSetDailyWork scheduler started.");

		if (!ezEmailScheduler.preScheduler("autoSetDailyWork")) {
			logger.debug("autoSetDailyWork scheduler ended.");
			return;
		}

		ezAttitudeService.autoSetDailyWork();
		logger.debug("autoSetDailyWork scheduler ended.");
	}
}