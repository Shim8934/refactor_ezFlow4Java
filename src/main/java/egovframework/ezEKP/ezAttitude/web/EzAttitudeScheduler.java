package egovframework.ezEKP.ezAttitude.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Calendar;

import javax.annotation.Resource;

import org.bouncycastle.asn1.cmp.CAKeyUpdAnnContent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.ibm.icu.text.DecimalFormat;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.ezEKP.ezAttitude.service.EzAttitudeService;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.ezEKP.ezAttitude.vo.HolidayVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.KoreanLunarCalendar;

@Component
public class EzAttitudeScheduler {

	private static final Logger logger = LoggerFactory.getLogger(EzAttitudeScheduler.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "EzAttitudeService")
	private EzAttitudeService ezAttitudeService;
	
	
//	@Scheduled(cron = "${config.cron.autoSetAnnualHoliday}")
//	@Scheduled(cron = "0 * 18 * * *")
	public void autoSetAnnualHoliday() throws Exception{
		logger.debug("autoSetAnnualHoliday scheduler started.");
		
		List<Map<String, Object>> tenantCompanyIdList = ezAttitudeService.getTenantCompanyId();
		
		for ( Map<String, Object> tenantCompanyMap : tenantCompanyIdList) {
			// 변수 값은 테스트용 테이블 및 쿼리 생성 후 변경 예정
			Map<String, Object> annualConf = ezAttitudeService.getAttitudeAnnualConfig((int)tenantCompanyMap.get("tenantId"), (String)tenantCompanyMap.get("companyId"));
			
			String useAnnualAutoGnrt = (String)annualConf.get("useAnnualAutoGnrt");// 1:사용 1:미사용
			String annualGnrtStd = (String)annualConf.get("annualGnrtStd");// 0:입사일기준 1:회계연도기준
			String useAnnualTmnt = (String)annualConf.get("useAnnualTmnt");//연차소멸 여부 1:사용 0:미사용
			String initialDate = (String)annualConf.get("initialDate"); // 기산일 
			String roundOffRule = (String)annualConf.get("roundOffRule");//1:0.5 0:1.0
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			String today = sdf.format(new Date());
			Date setDate = sdf.parse(today);
			
			Calendar cal = Calendar.getInstance();
			cal.setTime(setDate);
			cal.add(Calendar.DATE, -1);
	
			String yesterday = sdf.format(cal.getTime());
			
			if (useAnnualAutoGnrt.equals("1")) {
				
				List<Map<String, Object>> list = ezAttitudeService.getJoinDateUserList(yesterday.split("-")[2]);
	
				if (annualGnrtStd.equals("0")) {
					
					for (Map<String, Object> m : list) {
						
						int workingMonthCnt = Integer.parseInt((String)m.get("workingMonthCnt"));
						
						if (workingMonthCnt < 24) {
							if (workingMonthCnt == 12) {
								ezAttitudeService.updateAnnualHoliday(m);
							} else if (workingMonthCnt < 12) {
								ezAttitudeService.updateMonthlyHoliday(m);
							} else {
								if (useAnnualTmnt.equals("1")) {
									m.put("today",today);
									ezAttitudeService.extinctionMonthlyHoliday(m);
								}
							}
						} else {
							ezAttitudeService.updateExceedAnnualHoliday(m);
						}
					}
				} else {
					for (Map<String, Object> m : list) {
						
						int workingMonthCnt = Integer.parseInt((String)m.get("workingMonthCnt"));
	
						if (workingMonthCnt < 12) {
							ezAttitudeService.updateMonthlyHoliday(m);
						} else if (workingMonthCnt > 12) {
							if (workingMonthCnt < 24) {
								if (useAnnualTmnt.equals("1")) {
									m.put("today",today);
									ezAttitudeService.extinctionMonthlyHoliday(m);
								}
							}
						}
					}
					
					if (initialDate.substring(initialDate.indexOf("-")+1).equals(yesterday.substring(yesterday.indexOf("-")+1))) {
						
						Map<String, Object> m = new HashMap<String, Object>();
						m.put("roundOffRule", roundOffRule);
						m.put("initialDate", initialDate);
						
						ezAttitudeService.updateFiscalYearAnnualHoliday(m);
					}				
				}
			}
			
			logger.debug("autoSetAnnualHoliday scheduler ended.");
		}
	}
}