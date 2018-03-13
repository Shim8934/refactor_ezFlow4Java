package egovframework.ezEKP.ezLadder.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.bouncycastle.asn1.ocsp.Request;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
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
import egovframework.ezEKP.ezLadder.vo.LadderBmUserVO;
import egovframework.ezEKP.ezLadder.vo.LadderBmVO;
import egovframework.ezEKP.ezLadder.vo.LadderLineVO;
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
		String tenantId = request.getParameter("tenantId");
		try {
			List<LadderVO> list = ezLadderService.getLadderList(userId, tenantId);
		
			int page = 1;
			int block = 10;
			int totalLadder = list.size();
			int totalPage = (int) Math.ceil(list.size()/(double) 10);
			int startPoint = (page - 1)*10;
			int endPoint = 0;
			if(page == totalPage) {
				endPoint = totalLadder;
			} else {
				endPoint = page*block;
			}
			if(list.size()>0) {
				list = list.subList(startPoint, endPoint);
			}
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", list);
			result.put("currPage", page);
			result.put("totalPage", totalPage);
			result.put("totalLadder", totalLadder);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("web G/W LADDER [GET /ladder/ladder-list/users/" + userId + "] ended.");
		
		return result;
	}
	
	@RequestMapping(value = "/ladder/ladder-list/{mode}/{currPage}/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")	
	public JSONObject gwViewLadderParticipant(@PathVariable String mode, @PathVariable String currPage, @PathVariable String userId, HttpServletRequest request) {
		logger.debug("web G/W LADDER [GET /ladder/ladder-list/" + mode + "/" + currPage +"/" + userId + "] started.");

		JSONObject result = new JSONObject();
		String tenantId = request.getParameter("tenantId");
		try {
			int page = Integer.parseInt(currPage);
			List<LadderVO> list;
			if(mode.equals("part")){	// 일부 참여자 선택
				list = ezLadderService.getPartLadderList(userId, tenantId);
			} else {					// 전체 참여자 선택
				list = ezLadderService.getLadderList(userId , tenantId);
			}
			
			int block = 10;
			int totalLadder = list.size();
			int totalPage = (int) Math.ceil(list.size()/(double) 10);
			int startPoint = (page - 1)*10;
			int endPoint = 0;
			if(page == totalPage) {
				endPoint = totalLadder;
			} else {
				endPoint = page*block;
			}
			if(list.size()>0) {
				list = list.subList(startPoint, endPoint);
			}
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", list);
			result.put("currPage", page);
			result.put("totalPage", totalPage);
			result.put("totalLadder", totalLadder);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("web G/W LADDER [GET /ladder/ladder-list/participant/" + userId + "] ended.");
		
		return result;
	}
	
	@RequestMapping(value = "/ladder/search/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")	
	public JSONObject gwSearchLadder(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("web G/W LADDER [GET /ladder/search/" + userId + "] started.");

		JSONObject result = new JSONObject();
		String tenantId = request.getParameter("tenantId");
		try {
			List<LadderVO> list;
							// 전체 참여자 선택
			String searchSelect = request.getParameter("searchSelect");
			String searchInput = request.getParameter("searchInput");
			String mode = request.getParameter("mode");
			int page = Integer.parseInt(request.getParameter("currPage"));
			
			logger.debug("searchSelect : " + searchSelect + ", searchInput : " + searchInput + ", mode : " + mode + ", currPage : " + page);
			
			List<String> allData = new ArrayList<String>();
			allData.add(searchSelect);
			allData.add(searchInput);
			allData.add(mode);
			
			list = ezLadderService.searchLadderList(userId, tenantId, allData);
			
			int block = 10;
			int totalLadder = list.size();
			int totalPage = (int) Math.ceil(list.size()/(double) 10);
			int startPoint = (page - 1)*10;
			int endPoint = 0;
			if(page == totalPage) {
				endPoint = totalLadder;
			} else {
				endPoint = page*block;
			}
			if(list.size()>0) {
				list = list.subList(startPoint, endPoint);
			}
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", list);
			result.put("currPage", page);
			result.put("totalPage", totalPage);
			result.put("totalLadder", totalLadder);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("web G/W LADDER [GET /ladder/search/" + userId + "] ended.");
		
		return result;
	}
	/** boh */
	
	/**
	 * 사다리 게임 추가
	 * */
	@RequestMapping(value = "/ladder/ladders/writers/{writerId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject gwInsertLadder(@PathVariable String writerId, HttpServletRequest request) {
		logger.debug("web G/W LADDER [POST /ladder/ladders/writers/" + writerId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String allLadData = request.getParameter("allLadData");
			String writerName = request.getParameter("writerName");
			String writerName2 = request.getParameter("writerName2");
			String deptName = request.getParameter("deptName");
			String deptName2 = request.getParameter("deptName2");
			int tenant_id = Integer.parseInt(request.getParameter("tenant_id"));
			
			JSONParser jp = new JSONParser();
			JSONObject ladObj = (JSONObject) jp.parse(allLadData);
			
			JSONObject lad = (JSONObject) ladObj.get("lad");
			LadderVO ladVO = new LadderVO();
			
			ladVO.setTenant_id(tenant_id); 
			ladVO.setTitle((String) lad.get("title"));
			ladVO.setType(Integer.parseInt((String) lad.get("type")));
			ladVO.setSecretFlag(Integer.parseInt((String) lad.get("secretflag")));
			ladVO.setWriterId(writerId);
			ladVO.setWriterName(writerName);
			ladVO.setWriterName2(writerName2);
			ladVO.setDeptName(deptName);
			ladVO.setDeptName2(deptName2);
			ladVO.setLineCnt(Integer.parseInt((String) lad.get("linecnt")));
			ladVO.setWriteDate((String) lad.get("writedate"));
			
			JSONArray ladLineArr = (JSONArray) ladObj.get("ladline");
			List<LadderLineVO> ladLineList = new ArrayList<LadderLineVO>();
			LadderLineVO ladlineVO = new LadderLineVO();
			JSONObject ladline = new JSONObject();
			
			int len = ladLineArr.size();
			for(int i = 0; i < len; i++) {
				ladline = (JSONObject) ladLineArr.get(i);
				
				ladlineVO.setTenant_id(tenant_id);
				ladlineVO.setUserId((String) ladline.get("userid")); 
				ladlineVO.setUserName((String) ladline.get("username"));
				ladlineVO.setUserName2((String) ladline.get("username2"));
				ladlineVO.setItem((String) ladline.get("item"));
				ladlineVO.setLadderOrder(Integer.parseInt((String) ladline.get("ladderorder")));
				ladlineVO.setWriterId(writerId);
				
				ladLineList.add(ladlineVO);
			}
			
			ezLadderService.insertLadder(ladVO, ladLineList);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", null);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			e.printStackTrace();
		}
		
		logger.debug("web G/W LADDER [POST /ladder/ladders/writers/" + writerId + "] ended.");
		
		return result;
	}
	
	/**
	 * 즐겨찾기 그룹 조회
	 * */
	@RequestMapping(value = "/ladder/BMs/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject gwSelectBMGroup(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("web G/W LADDER [GET /ladder/BMs/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			int tenant_id = Integer.parseInt(request.getParameter("tenant_id"));

			List<LadderBmVO> bmGroups = ezLadderService.selectBMGroup(userId, tenant_id);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", bmGroups);
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
	public JSONObject gwSelectBMUser(@PathVariable String userId, @PathVariable int ladderBMId, HttpServletRequest request) {
		logger.debug("web G/W LADDER [GET /ladder/BMs/" + ladderBMId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			int tenant_id = Integer.parseInt(request.getParameter("tenant_id"));
			
			List<LadderBmUserVO> bmUsers = ezLadderService.selectBMUser(tenant_id, ladderBMId);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", bmUsers);
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
	@RequestMapping(value = "/ladder/BMs/users/{userId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject gwInsertBMGroup(@PathVariable String userId, HttpServletRequest request) {
		logger.debug("web G/W LADDER [POST /ladder/BMs/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			int tenant_id = Integer.parseInt(request.getParameter("tenant_id"));
			String bmName = request.getParameter("bmName");
			String bmUsers = request.getParameter("bmUsers");
			String dateStr = printDate();
			
			LadderBmVO bmGroupVO = makeBmGroupVO(tenant_id, 0, bmName, userId, dateStr);
			List<LadderBmUserVO> bmUsersVO = makeBmUsersVO(tenant_id, 0, userId, bmUsers, "");
			
			ezLadderService.insertBM(bmGroupVO, bmUsersVO);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", null);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			e.printStackTrace();
		}
		
		logger.debug("web G/W LADDER [POST /ladder/BMs/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 즐겨찾기 그룹 수정
	 * */
	@RequestMapping(value = "/ladder/BMs/{ladderBMId}/users/{userId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject gwUpdateBMGroup(@PathVariable String userId, @PathVariable int ladderBMId, HttpServletRequest request) {
		logger.debug("web G/W LADDER [PUT /ladder/BMs/" + ladderBMId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			int tenant_id = Integer.parseInt(request.getParameter("tenant_id"));
			String bmName = request.getParameter("bmName");
			String bmUsers = request.getParameter("bmUsers");
			String dateStr = printDate();
			
			LadderBmVO bmGroupVO = makeBmGroupVO(tenant_id, ladderBMId, bmName, userId, dateStr);
			List<LadderBmUserVO> bmUsersVO = makeBmUsersVO(tenant_id, ladderBMId, userId, bmUsers, "");
			
			ezLadderService.updateBM(bmGroupVO, bmUsersVO);
			
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
	public JSONObject gwDeleteBMGroup(@PathVariable String userId, @PathVariable int ladderBMId, HttpServletRequest request) {
		logger.debug("web G/W LADDER [DELETE /ladder/BMs/" + ladderBMId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			int tenant_id = Integer.parseInt(request.getParameter("tenant_id"));
			String bmName = request.getParameter("bmName");
			String bmUsers = request.getParameter("bmUsers");
			
			LadderBmVO bmGroupVO = makeBmGroupVO(tenant_id, ladderBMId, bmName, userId, "");
			List<LadderBmUserVO> bmUsersVO = makeBmUsersVO(tenant_id, ladderBMId, userId, bmUsers, "");
			
			ezLadderService.deleteBM(bmGroupVO, bmUsersVO);
			
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

	/** ladderBmVO set */
	public LadderBmVO makeBmGroupVO(int tenant_id, int ladderBmId, String bmName, String userId, String dateStr) {
		LadderBmVO bmGroupVO = new LadderBmVO();
		bmGroupVO.setTenant_id(tenant_id);
		bmGroupVO.setLadderBmId(ladderBmId);
		bmGroupVO.setBmName(bmName);
		bmGroupVO.setUserId(userId);
		bmGroupVO.setRegdate(dateStr);
		
		return bmGroupVO;
	}
	
	/** ladderBmUserVO set */
	public List<LadderBmUserVO> makeBmUsersVO(int tenant_id, int ladderBmId, String writerId, String bmUsers, String lang) throws Exception {
		List<LadderBmUserVO> bmUsersVO = new ArrayList<LadderBmUserVO>();
		
		if(!bmUsers.equals("")) {
			JSONParser jp = new JSONParser();
			JSONObject jsonObj = (JSONObject) jp.parse(bmUsers);
			JSONArray bmUserId = (JSONArray) jsonObj.get("userid");
			JSONArray bmUserName = (JSONArray) jsonObj.get("username");
			JSONArray bmUserName2 = (JSONArray) jsonObj.get("username2");
			
			int len = bmUserId.size();
			for(int i = 0; i < len; i++) {
				LadderBmUserVO bmUserVO = new LadderBmUserVO();
				
				bmUserVO.setTenant_id(tenant_id);
				bmUserVO.setLadderBmId(ladderBmId);
				bmUserVO.setWriterId(writerId);
				bmUserVO.setUserId((String) bmUserId.get(i));
				bmUserVO.setUserName((String) bmUserName.get(i));
				bmUserVO.setUserName2((String) bmUserName2.get(i));
				bmUserVO.setLang(lang);
				
				bmUsersVO.add(bmUserVO);
			}
		}
		return bmUsersVO;
	}
	
	/** 날짜 출력 */
	public String printDate() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		Date date = new Date();
		String dateStr = formatter.format(date);
		
		return dateStr;
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
	
	/** hyh	*/
	
	
	/**
	 * 사디리 게임 조회 
	 */
	@RequestMapping(value = "ladder/ladderGame/{ladderId}/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8") 
	public JSONObject gwGetLadderGame(@PathVariable String ladderId , @PathVariable String userId, HttpServletRequest request) {
		logger.debug("web G/W LADDER [Get /ladder/ladders/" + ladderId+ "/users/" + userId + "] started.");
		
		int ladId = Integer.parseInt(ladderId);
		JSONObject result = new JSONObject();
		String tenantId = request.getParameter("tenantId");
		try {
			LadderVO vo = ezLadderService.getLadderGame(tenantId, ladId);
		
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", vo);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("web G/W LADDER [Get /ladder/ladders/" + ladderId + "users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 사디리 삭제 
	 */
	@RequestMapping(value = "ladder/ladders/delete/{userId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8") 
	public JSONObject gwDeleteLadderList(@PathVariable String userId,  HttpServletRequest request) {

		logger.debug("web G/W LADDER [GET /ladder/delete/" + userId + "] started.");

		JSONObject result = new JSONObject();
		String tenantId = request.getParameter("tenantId");
		try {
			List<LadderVO> list;
			
			String ladderId = request.getParameter("ladderId");
			String searchSelect = request.getParameter("searchSelect");
			String searchInput = request.getParameter("searchInput");
			String mode = request.getParameter("mode");
			int page = Integer.parseInt(request.getParameter("currPage"));
			
			logger.debug("ladderId : " + ladderId + ", searchSelect : " + searchSelect + ", searchInput : " + searchInput + ", mode : " + mode);
			
			List<String> allData = new ArrayList<String>();
			allData.add(ladderId);
			allData.add(searchSelect);
			allData.add(searchInput);
			allData.add(mode);
			
			list = ezLadderService.deleteLadderList(userId, tenantId, allData);
			

			int block = 10;
			int totalLadder = list.size();
			int totalPage = (int) Math.ceil(list.size()/(double) 10);
			if(page>totalPage) {	// 마지막 페이지 사다리 삭제시
				page = totalPage;
			}
			int startPoint = (page - 1)*10;
			int endPoint = 0;
			if(page == totalPage) {
				endPoint = totalLadder;
			} else {
				endPoint = page*block;
			}
			if(list.size()>0) {
				list = list.subList(startPoint, endPoint);
			}
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", list);
			result.put("currPage", page);
			result.put("totalPage", totalPage);
			result.put("totalLadder", totalLadder);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("web G/W LADDER [GET /ladder/delete/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 참여자 순서 바꾸기
	 */
	@RequestMapping(value = "ladder/ladders/{ladderId}/users/{userId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8") 
	public JSONObject gwSetUserOrder(@PathVariable String ladderId , @PathVariable String userId) {
		logger.debug("web G/W LADDER [PUT /ladder/ladders/" + ladderId+ "users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", null);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("web G/W LADDER [PUT /ladder/ladders/" + ladderId + "users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 사다리게임 시작
	 */
	@RequestMapping(value = "ladder/ladders/{allData}/{userId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8") 
	public JSONObject gwSetLadderStart(@PathVariable String ladderId , @PathVariable String writerId) {
		logger.debug("web G/W LADDER [PUT /ladder/ladders/" + ladderId+ "users/" + writerId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", null);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		logger.debug("web G/W LADDER [PUT /ladder/ladders/" + ladderId + "users/" + writerId + "] ended.");
		
		return result;
	}
	
}
