package egovframework.ezEKP.ezBoard.task;

import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletContext;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezEmail.task.EzEmailScheduler;
import egovframework.let.utl.fcc.service.CommonUtil;
	
@Component
public class EzBoardScheduler {
	@Autowired
	private Properties config;
	
	@Autowired
	private ServletContext servletContext;

	@Autowired
	private CommonUtil commonUtil;

	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name = "EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;
	
	@Autowired
	private EzEmailScheduler ezEmailScheduler;
	
	private static final Logger logger = LoggerFactory.getLogger(EzBoardScheduler.class);

	@Scheduled(cron = "${config.cron.boardGarbageClear}")
	public void boardGarbageClear() throws Exception {
		logger.debug("boardGarbageClear started");
		
		//choose scheduler running server
		if (!ezEmailScheduler.preScheduler("ezboard_boardGarbageClear")) {
			logger.debug("boardGarbageClear scheduler ended.");
			return;
		}

		String realPath = commonUtil.getRealPath(servletContext);
		
		/* 2023-10-10 홍승비 - 게시물 삭제 스케줄러 > 예외 발생 시 try~catch 로그 추가 */
		try {
			ezBoardService.deleteExpiredItems(realPath);
			ezBoardService.deleteReservedBoard(realPath);
			ezBoardService.deleteReservedBoardItem(realPath);
			ezBoardService.deleteItemsScrap();
			ezBoardService.deleteItemsScrapCont();
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("boardGarbageClear ended");
	}

	/** 공지등록 기간 만료 시 메신저로 알림 발송 */
	@Scheduled(cron = "${config.cron.boardNotiEndAlram}")
	public void boardNotiEndAlram() throws Exception {
		logger.debug("boardNotiEndAlram started");

		//choose scheduler running server
		if (!ezEmailScheduler.preScheduler("ezboard_boardNotiEndAlram")) {
			logger.debug("boardNotiEndAlram scheduler ended.");
			return;
		}

		try {
			ezBoardAdminService.boardNotiEndAlram();
		} catch (NumberFormatException ne) {
			logger.error(ne.getMessage(), ne);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("boardNotiEndAlram ended");
	}

}
