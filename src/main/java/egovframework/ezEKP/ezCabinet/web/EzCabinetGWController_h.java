package egovframework.ezEKP.ezCabinet.web;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RestController;
import egovframework.let.user.login.service.LoginService;

@RestController
public class EzCabinetGWController_h {
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetGWController_h.class);
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	
}
