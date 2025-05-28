package egovframework.ezEKP.ezStatistics.task;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import egovframework.ezEKP.ezEmail.task.EzEmailScheduler;
import egovframework.ezEKP.ezStatistics.service.EzStatisticsAdminService;
import egovframework.ezEKP.ezStatistics.vo.StatApprVO;
import egovframework.let.utl.fcc.service.CommonUtil;

import java.time.LocalDateTime;
import java.util.Properties;

@Component
public class EzStatisticsScheduler {
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "EzStatisticsAdminService")
	private EzStatisticsAdminService ezStatisticsAdminService;
	
	@Autowired
	private EzEmailScheduler ezEmailScheduler;

	@Autowired
	private Properties config;
	
	private static final Logger logger = LoggerFactory.getLogger(EzStatisticsScheduler.class);
	
	@Scheduled(cron = "${config.cron.apprStatisticsDailybatch}")
	public void apprStatisticsDailybatch() throws Exception {
		logger.debug("apprStatisticsDailybatch started");

		//choose scheduler running server
		if (!ezEmailScheduler.preScheduler("apprStatisticsDailybatch")) {
			logger.debug("apprStatisticsDailybatch scheduler ended.");
			return;
		}
		
		String today = commonUtil.getTodayUTCTime("yyyy-MM-dd");
		
		StatApprVO statApprVO = new StatApprVO();
		statApprVO.setToday(today);
		statApprVO.setStartDate(today + " 00:00:00");
		statApprVO.setEndDate(today + " 23:59:59");
		
		ezStatisticsAdminService.dailyDocCountLog(statApprVO);
		ezStatisticsAdminService.dailyFormCountLog(statApprVO);
		ezStatisticsAdminService.yearlyDocCount(statApprVO);
		
		logger.debug("apprStatisticsDailybatch ended");
	}

	@Scheduled(cron = "${config.cron.deleteStatMenu}")
	public void deleteStatMenu() {
		LocalDateTime ago = LocalDateTime.now().minusMonths(3);
		ezStatisticsAdminService.deleteStatMenuBeforeTime(ago);
	}
}
