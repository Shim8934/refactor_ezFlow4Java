package egovframework.ezEKP.ezBoard.task;

import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.let.utl.fcc.service.CommonUtil;

@Component
public class EzBoardScheduler {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name = "EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzBoardScheduler.class);

	@RequestMapping("/ezBoard/goScheduler.do")
	public void boardGarbageClear(HttpServletResponse response) throws Exception {
		logger.debug("boardGarbageClear started");

		String realPath = config.getProperty("data_root");
		
		ezBoardService.deleteExpiredItems(realPath);
		ezBoardService.deleteReservedBoard(realPath);
		ezBoardService.deleteReservedBoardItem(realPath);

		logger.debug("boardGarbageClear ended");
	}


}
