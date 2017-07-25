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
 * @Description [Controller] 모바일 G/W 일정관리
 * @author 오픈솔루션팀 장진혁
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2017.07.24         장진혁   	     신규작성
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
	
    /////////////////////////////////////////////// sample start ///////////////////////////////////////////////////
		
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
	
    ///////////////////////////////////////////////// sample end /////////////////////////////////////////////////////
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 리스트 (월간,주간,일정검색)
	 */
	@RequestMapping(value="/ezschedule/list/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void mScheduleList() throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/list/users/{userId}] started.");
		
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/list/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 카운트 (월간,주간,일정검색)
	 */
	@RequestMapping(value="/ezschedule/list-count/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void mScheduleListCount() throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/list-count/users/{userId}] started.");
		
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/list-count/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 상세데이터
	 */
	@RequestMapping(value="/ezschedule/schedules/{scheduleId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void mScheduleDetail() throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}] started.");
		
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 첨부파일 리스트
	 */
	@RequestMapping(value="/ezschedule/schedules/{scheduleId}/attach-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void mScheduleAttachList() throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}/attach-list] started.");
		
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}/attach-list] ended.");		
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 종류 리스트 (개인/부서/회사)
	 */
	@RequestMapping(value="/ezschedule/schedules/{scheduleId}/type-List", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void mScheduleTypeList() throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}/type-List] started.");
		
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}/type-List] ended.");		
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 참석자 리스트
	 */
	@RequestMapping(value="/ezschedule/schedules/{scheduleId}/attendance-List", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void mScheduleAttendanceList() throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}/attendance-List] started.");
		
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}/attendance-List] ended.");		
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 등록
	 */
	@RequestMapping(value="/ezschedule/schedules", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public void mScheduleInsert() throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [POST /ezschedule/schedules] started.");
		
		logger.debug("MOBILE G/W SCHEDULE [POST /ezschedule/schedules] ended.");		
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 수정
	 */
	@RequestMapping(value="/ezschedule/schedules/{scheduleId}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public void mScheduleUpdate() throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [PUT /ezschedule/schedules/{scheduleId}] started.");
		
		logger.debug("MOBILE G/W SCHEDULE [PUT /ezschedule/schedules/{scheduleId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 삭제
	 */
	@RequestMapping(value="/ezschedule/schedules/{scheduleId}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public void mScheduleDelete() throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [DELETE /ezschedule/schedules/{scheduleId}] started.");
		
		logger.debug("MOBILE G/W SCHEDULE [DELETE /ezschedule/schedules/{scheduleId}] ended.");		
	}
	
}


