package egovframework.ezEKP.ezLadder.web;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezLadder.service.EzLadderService;
import egovframework.ezEKP.ezLadder.vo.LadderVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzLadderGWController {
	private static final Logger logger = LoggerFactory.getLogger(EzLadderGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzLadderService")
	private EzLadderService ezLadderService;
	
	@RequestMapping(value = "/ladder/ladder-list/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")	
	public JSONObject gwladderList(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("web G/W LADDER [GET /ladder/ladder-list/users/" + userId + "] started.");

		JSONObject result = new JSONObject();
		
		try {
			List<LadderVO> list = ezLadderService.getLadderList();
		
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", list);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("web G/W LADDER [GET /ladder/list/" + userId + "] ended.");
		
		return result;
	}
	
	/** boh */
	
	/**
	 * 사다리 게임 추가
	 * */
	@RequestMapping(value = "/ladder/ladders/writers/{writerId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject gwInsertLadder(@PathVariable String writerId) {
		logger.debug("web G/W LADDER [POST /ladder/ladders/writers/" + writerId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", null);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("web G/W LADDER [POST /ladder/ladders/writers/" + writerId + "] ended.");
		
		return result;
	}
	
	/**
	 * 즐겨찾기 그룹 조회
	 * */
	@RequestMapping(value = "/ladder/BMs/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject gwSelectBMGroup(@PathVariable String userId) {
		logger.debug("web G/W LADDER [GET /ladder/BMs/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", null);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("web G/W LADDER [GET /ladder/BMs/users/" + userId + "] ended.");
		
		return result;
	}

	/**
	 * 즐겨찾기 그룹 유저 조회
	 * */
	@RequestMapping(value = "/ladder/BMs/{ladderBMId}/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject gwSelectBMUser(@PathVariable String userId, @PathVariable String ladderBMId) {
		logger.debug("web G/W LADDER [GET /ladder/BMs/" + ladderBMId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", null);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("web G/W LADDER [GET /ladder/BMs/" + ladderBMId + "/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 즐겨찾기 그룹 추가
	 * */
	@RequestMapping(value = "/ladder/BMs/{ladderBMId}/users/{userId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject gwInsertBMGroup(@PathVariable String userId, @PathVariable String ladderBMId) {
		logger.debug("web G/W LADDER [POST /ladder/BMs/" + ladderBMId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", null);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("web G/W LADDER [POST /ladder/BMs/" + ladderBMId + "/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 즐겨찾기 그룹 수정
	 * */
	@RequestMapping(value = "/ladder/BMs/{ladderBMId}/users/{userId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject gwUpdateBMGroup(@PathVariable String userId, @PathVariable String ladderBMId) {
		logger.debug("web G/W LADDER [PUT /ladder/BMs/" + ladderBMId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", null);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("web G/W LADDER [PUT /ladder/BMs/" + ladderBMId + "/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 즐겨찾기 그룹 삭제
	 * */
	@RequestMapping(value = "/ladder/BMs/{ladderBMId}/users/{userId}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject gwDeleteBMGroup(@PathVariable String userId, @PathVariable String ladderBMId) {
		logger.debug("web G/W LADDER [DELETE /ladder/BMs/" + ladderBMId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", null);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("web G/W LADDER [DELETE /ladder/BMs/" + ladderBMId + "/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 댓글 조회
	 * */
	@RequestMapping(value = "/ladder/ladders/{ladderId}/comment/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject gwSelectComment(@PathVariable String userId, @PathVariable String ladderId) {
		logger.debug("web G/W LADDER [GET /ladder/ladders/" + ladderId + "/comment/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", null);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("web G/W LADDER [GET /ladder/ladders/" + ladderId + "/comment/users/" + userId + "] ended.");
		
		return result;
	}	
	
	/**
	 * 댓글 추가
	 * */
	@RequestMapping(value = "/ladder/ladders/{ladderId}/comment/users/{userId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject gwInsertComment(@PathVariable String userId, @PathVariable String ladderId) {
		logger.debug("web G/W LADDER [POST /ladder/ladders/" + ladderId + "/comment/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", null);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("web G/W LADDER [POST /ladder/ladders/" + ladderId + "/comment/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 댓글 수정
	 * */
	@RequestMapping(value = "/ladder/ladders/{ladderId}/comment/users/{userId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject gwUpdateComment(@PathVariable String userId, @PathVariable String ladderId) {
		logger.debug("web G/W LADDER [PUT /ladder/ladders/" + ladderId + "/comment/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", null);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("web G/W LADDER [PUT /ladder/ladders/" + ladderId + "/comment/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 댓글 삭제
	 * */
	@RequestMapping(value = "/ladder/ladders/{ladderId}/comment/users/{userId}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject gwDeleteComment(@PathVariable String userId, @PathVariable String ladderId) {
		logger.debug("web G/W LADDER [DELETE /ladder/ladders/" + ladderId + "/comment/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", null);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("web G/W LADDER [DELETE /ladder/ladders/" + ladderId + "/comment/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 이전 사다리 목록 순서 바꾸기
	 * */
	@RequestMapping(value = "/ladder/ladder-list/users/{userId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject gwChangePreLadderList(@PathVariable String userId, @PathVariable String ladderId) {
		logger.debug("web G/W LADDER [PUT /ladder/ladder-list/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", null);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("web G/W LADDER [PUT /ladder/ladder-list/users/" + userId + "] ended.");
		
		return result;
	}

}
