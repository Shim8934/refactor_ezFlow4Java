package egovframework.ezEKP.ezCommunity.task;

import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletContext;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import egovframework.ezEKP.ezCommunity.service.EzCommunityService;
import egovframework.ezEKP.ezEmail.task.EzEmailScheduler;
import egovframework.let.utl.fcc.service.CommonUtil;
	
@Component
public class EzCommunityScheduler {
	@Autowired
	private Properties config;
	
	@Autowired
	private ServletContext servletContext;

	@Autowired
	private CommonUtil commonUtil;

	@Resource(name = "EzCommunityService")
	private EzCommunityService ezCommunityService;
	
	@Autowired
	private EzEmailScheduler ezEmailScheduler;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCommunityScheduler.class);

	@Scheduled(cron = "${config.cron.communityGarbageClear}")
	public void boardGarbageClear() throws Exception {
		logger.debug("communityGarbageClear started");
		
		//choose scheduler running server
		if (!ezEmailScheduler.preScheduler("communityGarbageClear")) {
			logger.debug("communityGarbageClear scheduler ended.");
			return;
		}

		String realPath = commonUtil.getRealPath(servletContext);
		
		ezCommunityService.deleteExpiredItems(realPath);
		ezCommunityService.deleteReservedBoard(realPath);
		ezCommunityService.deleteReservedBoardItem(realPath);

		logger.debug("communityGarbageClear ended");
	}

}
