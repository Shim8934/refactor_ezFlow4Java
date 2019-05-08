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
//	@Scheduled(cron = "10/5 * * * * *")
	public void autoSetAnnualHoliday() throws Exception{
		logger.debug("autoSetAnnualHoliday scheduler started.");

		// 변수 값은 테스트용 테이블 및 쿼리 생성 후 변경 예정
		char useAnnualAutoGnrt = '0';// 0:사용 1:미사용
		char annualGnrtStd = '1';// 0:입사일기준 1:회계연도기준
		char useAnnualTmnt = '0';//연차소멸 여부 0:사용 1:미사용
		String initialDate = "2019-05-02"; // 기산일 
		char roundOffRule = '1';//0:0.5 1:1.0
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String today = sdf.format(new Date());
		Date setDate = sdf.parse(today);
		
		Calendar cal = Calendar.getInstance();
		cal.setTime(setDate);
		cal.add(Calendar.DATE, -1);

		String yesterday = sdf.format(cal.getTime());
		
		if (useAnnualAutoGnrt == '0') {
			
			List<Map<String, Object>> list = ezAttitudeService.getJoinDateUserList(yesterday.split("-")[2]);

			if (annualGnrtStd == '0') {
				
				for (Map<String, Object> m : list) {
					
					int workingMonthCnt = Integer.parseInt((String)m.get("workingMonthCnt"));
					
					if (workingMonthCnt < 24) {
						if (workingMonthCnt == 12) {
							ezAttitudeService.updateAnnualHoliday(m);
						} else if (workingMonthCnt < 12) {
							ezAttitudeService.updateMonthlyHoliday(m);
						} else {
							if (useAnnualTmnt == '0') {
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
							if (useAnnualTmnt == '0') {
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