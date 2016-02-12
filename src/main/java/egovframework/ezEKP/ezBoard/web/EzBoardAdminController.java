package egovframework.ezEKP.ezBoard.web;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;

import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;

@Controller
public class EzBoardAdminController {

	@Resource(name="EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name="EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;
	
}
