package egovframework.ezEKP.ezPMS.web;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzPMSController {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EgovFileScrty egovFileScrty;
	
	@Autowired
	private Properties config;
	
	/**
	 * 프로젝트 관리 메인화면 호출함수
	 */
	@RequestMapping(value="/ezPMS/pmsMain.do")
	public String main() {
		return "ezPMS/pmsMain";
	}
	
	/**
	 * 프로젝트관리 왼쪽화면 호출함수
	 * @return
	 */
	@RequestMapping(value="/ezPMS/pmsLeft.do")
	public String left() {
		return "ezPMS/pmsLeft";
	}
	
	/**
	 * 메인페이지화면 호출 함수
	 */
	@RequestMapping(value = "/ezPMS/pmsProjectList.do")
	public String projectList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp,Model model) throws Exception {
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		return "ezPMS/pmsProjectList";
	}
	
	/**
	 * 나의 업무 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPMS/pmsMyTask.do")
	public String myTaskPage(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		return "ezPMS/pmsMyTask";
	}
	
	/**
	 * 프로젝트관리 환경설정 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPMS/pmsSetting.do")
	public String pmsSetting(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		return "ezPMS/pmsSetting";
	}
}
