package egovframework.ezEKP.ezNewPortal.task;

import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;

@Component
public class ezNewPortalScheduler {
	private static final Logger logger = LoggerFactory.getLogger(ezNewPortalScheduler.class);
	
	@Autowired
	private Properties config;
	
	@Resource(name = "EzNewPortalService")
	private EzNewPortalService ezNewPortalService;
	
	@Scheduled(cron = "00 1/10 * * * *")
	public void receiveWeatherData() {
		if (config.getProperty("config.Run_Weather").equals("NO")) {
			return;
		}
		
		logger.debug("receiveWeatherData started");
		
		try {
			ezNewPortalService.setWeather();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		logger.debug("receiveWeatherData ended");
	}
}
