package egovframework.ezEKP.ezQuestion.web;

import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezQuestion.service.EzQuestionService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzQuestionController {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
	
	@Resource(name="EzQuestionService")
	private EzQuestionService ezQuestionService;
	
	@Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;
	
	@RequestMapping(value="/ezQuestion/poll/qstList.do")
	public String qstList(){
		return "/ezQuestion/poll/qstList";
	}
	
	@RequestMapping(value="/ezQuestion/poll/qstStep1.do")
	public String qstStep1(){
		return "/ezQuestion/poll/qstStep1";
	}
	
}
