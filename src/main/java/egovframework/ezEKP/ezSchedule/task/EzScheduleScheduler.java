package egovframework.ezEKP.ezSchedule.task;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import egovframework.ezEKP.ezEmail.task.EzEmailScheduler;
import egovframework.ezEKP.ezSchedule.service.EzScheduleGoogleService;

@Component
public class EzScheduleScheduler {
	
	@Autowired
	private EzEmailScheduler ezEmailScheduler;
	
	@Autowired
	private EzScheduleGoogleService googleService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzScheduleScheduler.class);

	@Scheduled(cron = "${config.cron.checkGoogleToken}")
	public void checkGoogleToken() throws Exception {
		logger.debug("checkGoogleToken started");
		
		//choose scheduler running server
		if (!ezEmailScheduler.preScheduler("checkGoogleToken")) {
			logger.debug("checkGoogleToken scheduler ended.");
			return;
		}
		
		googleService.checkGoogleToken("part");
		
		logger.debug("checkGoogleToken ended");
	}
}