package egovframework.ezEKP.ezAttitude.web;

import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzAttitudeAdminBOMController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzAttitudeController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name="crypto")
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	/**
	 * 관리자 근태규율관리 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeConfig.do")
	public String attitudeConfig(Model model, HttpServletRequest request) {
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");		
//		String url = gwServerUrl + "/rest/ezattitude/attitude-conf" + request.getParameter("companyId");
		String url = gwServerUrl + "/rest/ezattitude/attitude-conf" + "bomcompany1";
		
		return "admin/ezAttitude/attitudeConfig";
	}
	
}
