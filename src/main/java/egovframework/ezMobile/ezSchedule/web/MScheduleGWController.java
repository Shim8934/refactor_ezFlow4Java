package egovframework.ezMobile.ezSchedule.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.map.HashedMap;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezMobile.ezResource.vo.MResourceGetAdmSubClsTreeVO;
import egovframework.ezMobile.ezSchedule.service.MScheduleService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 스케쥴
 * @author 오픈솔루션팀 지정석
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2017.06.14    지정석    신규작성
 *
 * @see
 */

@RestController
public class MScheduleGWController extends EgovFileMngUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(MScheduleGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
		
	@Resource(name="MScheduleService")
	private MScheduleService mScheduleService;
		
	@Resource(name="loginService")
	private LoginService loginService;

	/*@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;*/
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	/*@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;*/
		
	/**
	 * 모바일 G/W 일정관리 [get] method sample
	 */
	@RequestMapping(value="/ezschedule/{scheduleid}/gw-testList/{id}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public LoginVO testList(@PathVariable String scheduleid, @PathVariable String id, @RequestParam(value="name", required=false) String name) throws Exception {		
		logger.debug("gw-testList started.");
		
System.out.println(scheduleid);
System.out.println(id);
System.out.println(name);

		LoginVO vo = new LoginVO();
		vo.setTenantId(0);
		vo.setId(id);
		vo.setDn("NOPASSWORD");

		LoginVO user = loginService.selectUser(vo);

		logger.debug("gw-testList ended.");
		return user;
	}
	
	/**
	 * 모바일 G/W 일정관리 [put] method sample
	 */
	@RequestMapping(value="/ezschedule/{scheduleid}/gw-testUpdate/{id}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public void testUpdate(@PathVariable String scheduleid, @PathVariable String id, @RequestBody LoginVO loginVO) throws Exception {		
		logger.debug("gw-testUpdate started.");
		
		System.out.println(loginVO.getIp());
				
		LoginVO vo = new LoginVO();
		vo.setTenantId(0);
		vo.setId(id);
		vo.setIp(loginVO.getIp());
		
		loginService.updateUser(vo);
		
		logger.debug("gw-testUpdate ended.");		
	}
}
