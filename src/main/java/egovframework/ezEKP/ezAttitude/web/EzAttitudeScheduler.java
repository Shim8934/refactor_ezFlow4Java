package egovframework.ezEKP.ezAttitude.web;

import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.ibm.icu.text.SimpleDateFormat;

@Component
public class EzAttitudeScheduler {

	private static final Logger logger = LoggerFactory.getLogger(EzAttitudeScheduler.class);
	
//	@Scheduled(cron = "${config.cron.autoSetAnnualHoliday}")
	@Scheduled(cron = "10/5 * * * * *")
	public void autoSetAnnualHoliday() throws Exception{
		logger.debug("autoSetAnnualHoliday scheduler started.");
		
		// 변수 값은 테스트용 테이블 및 쿼리 생성 후 변경 예정
		char useAnnualAutoGnrt = '0';// 0:사용 1:미사용
		char annualGnrtStd = '0';// 0:입사일기준 1:회계연도기준
		
		if (useAnnualAutoGnrt == '0') {
			if (annualGnrtStd == '0') {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Date currentTime = new Date();
				String today = sdf.format(currentTime);
				
				
			} else {
				
			}
			
		}
		
		logger.debug("autoSetAnnualHoliday scheduler ended.");
		
	}
}
