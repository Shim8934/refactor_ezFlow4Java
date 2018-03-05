package egovframework.ezEKP.ezAttitude.web;

import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RestController;

import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzAttitudeGWController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzAttitudeGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
}
