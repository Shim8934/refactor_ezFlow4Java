package egovframework.ezEKP.ezStatistics.web;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import egovframework.ezEKP.ezStatistics.service.EzStatisticsAdminService;
import egovframework.ezEKP.ezStatistics.vo.StatApprVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Component
public class EzStatisticsScheduler {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "EzStatisticsAdminService")
	private EzStatisticsAdminService ezStatisticsAdminService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzStatisticsScheduler.class);
	
	@Scheduled(cron = "55 55 23 * * *")
	public void apprStatisticsDailybatch() throws Exception {
		logger.debug("apprStatisticsDailybatch started");

		String today = commonUtil.getTodayUTCTime("yyyy-MM-dd");
		
		StatApprVO statApprVO = new StatApprVO();
		statApprVO.setToday(today);
		statApprVO.setStartDate(today + " 00:00:00");
		statApprVO.setEndDate(today + " 23:59:59");
		
		ezStatisticsAdminService.dailyDocCountLog(statApprVO);
		ezStatisticsAdminService.dailyFormCountLog(statApprVO);
		
		logger.debug("apprStatisticsDailybatch ended");
	}

}
