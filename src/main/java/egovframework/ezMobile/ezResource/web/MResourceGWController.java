package egovframework.ezMobile.ezResource.web;

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
import egovframework.ezMobile.ezResource.service.MResourceService;
import egovframework.ezMobile.ezResource.vo.MResourceGetAdmSubClsTreeVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 자원관리
 * @author 오픈솔루션팀 강민수
 * @Modification Information
 * @
 * @  수정일         수정자                   수정내용
 * @ -------    --------    ---------------------------
 * @ 2017.07.24    강민수         최초 생성
 * @see
 */

@RestController
public class MResourceGWController extends EgovFileMngUtil {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MResourceGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
		
	@Resource(name="MResourceService")
	private MResourceService mResourceService;
		
	@Resource(name="loginService")
	private LoginService loginService;

	/*@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;*/
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	/*@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;*/
		
	/**
	 * 모바일 G/W 자원관리 [get] 
	 */
	@RequestMapping(value="/ezresource/{type}/list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public LoginVO resourceList(@PathVariable String type, @RequestParam(value="name", required=false) String name) throws Exception {		
		
		LOGGER.debug("gw-resource list started.");
		LoginVO vo = new LoginVO();
		LOGGER.debug("type: " + type);
		LOGGER.debug("gw-resource list ended.");
		return vo;
	
	}
	
	/**
	 * 모바일 G/W 자원관리 [get] 
	 */
	@RequestMapping(value="/ezresource/{type}/list-count", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public LoginVO resourceSchListCount(@PathVariable String type, @RequestParam(value="name", required=false) String name) throws Exception {		
		
		LOGGER.debug("gw-resource list started.");
		LoginVO vo = new LoginVO();
		LOGGER.debug("type: " + type);
		LOGGER.debug("gw-resource list ended.");
		return vo;
	
	}
	
	/**
	 * 모바일 G/W 자원관리 [get] 
	 */
	@RequestMapping(value="/ezresource/folder-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public LoginVO resourceFolderList( @RequestParam(value="name", required=false) String name) throws Exception {		
		
		LOGGER.debug("gw-resource list started.");
		LoginVO vo = new LoginVO();
		LOGGER.debug("gw-resource list ended.");
		return vo;
	
	}
	
	/**
	 * 모바일 G/W 자원관리 [get] 
	 */
	@RequestMapping(value="/ezresource/favorite-list/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public LoginVO resourceFavoriteList(@PathVariable String userId, @RequestParam(value="name", required=false) String name) throws Exception {		
		
		LOGGER.debug("gw-resource list started.");
		LoginVO vo = new LoginVO();
		LOGGER.debug("gw-resource list ended.");
		return vo;
	
	}
	
	/**
	 * 모바일 G/W 자원관리 [get] 
	 */
	@RequestMapping(value="/ezresource/resources/{resourceId}/schedules/{schuduleId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public LoginVO resourceSchDetail(@PathVariable String resourceId, @PathVariable String schuduleId, @RequestParam(value="name", required=false) String name) throws Exception {		
		
		LOGGER.debug("gw-resource list started.");
		LoginVO vo = new LoginVO();
		LOGGER.debug("gw-resource list ended.");
		return vo;
	
	}
	
	/**
	 * 모바일 G/W 자원관리 [get] 
	 */
	@RequestMapping(value="/ezresource/resources/{resourceId}/schedules/{schuduleId}/check-repetition", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public LoginVO resourceSchCheckRepeat(@PathVariable String resourceId, @PathVariable String schuduleId,@RequestParam(value="name", required=false) String name) throws Exception {		
		
		LOGGER.debug("gw-resource list started.");
		LoginVO vo = new LoginVO();
		LOGGER.debug("gw-resource list ended.");
		return vo;
	
	}
	
	/**
	 * 모바일 G/W 자원관리 [post] 
	 */
	@RequestMapping(value="/ezresource/resources/{resourceId}/schedules", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public void addResourceSch(@PathVariable String resourceId, @RequestBody LoginVO loginVO) throws Exception {		
		LOGGER.debug("gw-testUpdate started.");
		
		System.out.println(loginVO.getIp());
				
		LoginVO vo = new LoginVO();
		
		LOGGER.debug("gw-testUpdate ended.");		
	}
	
	/**
	 * 모바일 G/W 자원관리 [put] 
	 */
	@RequestMapping(value="/ezresource/resources/{resourceId}/schedules/{schuduleId}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public void modResourceSch(@PathVariable String resourceId, @PathVariable String schuduleId, @RequestBody LoginVO loginVO) throws Exception {		
		LOGGER.debug("gw-testUpdate started.");
		
		System.out.println(loginVO.getIp());
				
		LoginVO vo = new LoginVO();
		
		LOGGER.debug("gw-testUpdate ended.");		
	}
	
	/**
	 * 모바일 G/W 자원관리 [delete] 
	 */
	@RequestMapping(value="/ezresource/resources/{resourceId}/schedules/{schuduleId}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public void delResourceSch(@PathVariable String resourceId) throws Exception {		
		LOGGER.debug("gw-testUpdate started.");

		LOGGER.debug("gw-testUpdate ended.");		
	}
	
	/**
	 * 모바일 G/W 자원관리 [post] 
	 */
	@RequestMapping(value="/ezresource/resources/{resourceId}/favorite", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public void addFavorite(@PathVariable String resourceId) throws Exception {		
		LOGGER.debug("gw-testUpdate started.");
		
		LOGGER.debug("gw-testUpdate ended.");		
	}
	

}
