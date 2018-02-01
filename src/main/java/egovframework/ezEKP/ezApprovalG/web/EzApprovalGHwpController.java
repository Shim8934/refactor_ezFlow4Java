package egovframework.ezEKP.ezApprovalG.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class EzApprovalGHwpController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzApprovalGHwpController.class);
	
	@RequestMapping(value = "/ezApprovalG/drafuitHWP.do", produces = "text/xml;charset=utf-8")
	public String drafuitHWP() throws Exception {
		LOGGER.debug("drafuitHWP started");
		LOGGER.debug("drafuitHWP ended");
		
		return "ezApprovalG/apprGdrafuitHWP";
	}
}
