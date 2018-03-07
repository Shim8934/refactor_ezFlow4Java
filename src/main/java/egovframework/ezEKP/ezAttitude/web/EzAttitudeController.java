package egovframework.ezEKP.ezAttitude.web;

import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzAttitudeController {
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
	 * 관리자 근태관리 메인화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeMain.do")
	public String attitudeMain(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo){
		LOGGER.debug("attitudeMain started");
		
		userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		LOGGER.debug("attitudeMain ended");
		return "/admin/ezAttitude/attitudeMain";
	}
	
	/**
	 * 관리자 근태관리 좌측 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeLeft.do")
	public String attitudeLeft(){
		return "/admin/ezAttitude/attitudeLeft";
	}
	
	/**
	 * 관리자 근태관리 우측 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeRight.do")
	public String attitudeRight(){
		return "/admin/ezAttitude/attitudeRight";
	}
	
	/**
	 * 관리자 근태규율관리 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeConfig.do")
	public String attitudeConfig(){
		return "/admin/ezAttitude/attitudeConfig";
	}
	
}
