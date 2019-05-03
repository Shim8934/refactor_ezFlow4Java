package egovframework.ezEKP.ezNewPortal.task;

import java.net.UnknownHostException;
import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import egovframework.ezEKP.ezEmail.task.EzEmailScheduler;
import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;

@Component
public class EzNewPortalScheduler {
	private static final Logger logger = LoggerFactory.getLogger(EzNewPortalScheduler.class);
	
	@Autowired
	private Properties config;
	
	@Resource(name = "EzNewPortalService")
	private EzNewPortalService ezNewPortalService;
	
	@Autowired
	private EzEmailScheduler ezEmailScheduler;
	
	@Scheduled(cron = "${config.cron.weatherUpdate}")
	public void receiveWeatherData() {
		if (config.getProperty("config.useInternet") == null ||config.getProperty("config.useInternet").equals("NO")) {
			return;
		}
		
		logger.debug("weatherUpdate started");
		
		try {
			if (!ezEmailScheduler.preScheduler("weatherUpdate")) {
				logger.debug("weatherUpdate scheduler ended.");
				return;
			}
			
			ezNewPortalService.setWeather();
		} catch (Exception e) {
		    if (e instanceof UnknownHostException) {
		    	logger.debug("have to connect the internet to use weather scheduler");
		    }
		    else {
		    	e.printStackTrace();
		    }
		}
		
		logger.debug("weatherUpdate ended");
	}
}
