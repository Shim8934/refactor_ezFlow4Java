package egovframework.ezEKP.ezLadder.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezLadder.service.EzLadderService;
import egovframework.ezEKP.ezLadder.vo.LadderBmUserVO;
import egovframework.ezEKP.ezLadder.vo.LadderBmVO;
import egovframework.ezEKP.ezLadder.vo.LadderCommentVO;
import egovframework.ezEKP.ezLadder.vo.LadderLineVO;
import egovframework.ezEKP.ezLadder.vo.LadderOrderVO;
import egovframework.ezEKP.ezLadder.vo.LadderVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzLadderGWController {
	private static final Logger logger = LoggerFactory.getLogger(EzLadderGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzLadderService")
	private EzLadderService ezLadderService;
	
	@Resource(name="MOptionService")
	private MOptionService MOptionService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	public int[] paging(int currPage, int total, int newBlock) {
		int[] pages = new int[4]; //0 totalPage //1 startPoint //2 endPoint //3 currPage
		int block = newBlock;
		pages[0] = (int) Math.ceil(total/(double) block);	// totalPage
		pages[0] = pages[0] == 0 ? 1 : pages[0];
		
		if (currPage > pages[0]) {
			currPage = pages[0];
		}
		
		pages[1] = Math.multiplyExact(Math.subtractExact(currPage, 1), block); // startPoint
		pages[2] = 0;	//endPoint
		
		if (currPage == pages[0]) {
			pages[2] = total%block;
			if (pages[2] == 0) {
				pages[2] = block;
			}
		} else {
			pages[2] = block;
		}
		
		pages[3] = currPage; // currPage
		return pages;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ladder/ladder-list/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")	
	public JSONObject gwladderList(@PathVariable String userId, LadderVO vo, HttpServletRequest request) {
		logger.debug("web G/W LADDER [GET /rest/ladder/ladder-list/users/" + userId + "] started.");

		JSONObject result = new JSONObject();
		String currPage = request.getParameter("currPage");
		int page = commonUtil.isIntNumber(currPage, 1);
		String mode = request.getParameter("mode");
		String searchSelect = request.getParameter("searchSelect");
		String searchInput = request.getParameter("searchInput");
		String sort = request.getParameter("sort");
		String sortFlag = request.getParameter("sortFlag");
		String companyID = request.getParameter("companyID");
		
		vo.setUserId(userId);
		vo.setCompanyID(companyID);
	
		int totalLadder = 0;
		int[] pages = new int[4]; //0 totalPage //1 startPoint //2 endPoint //3 currPage
		int listNumPerPage = 10;
		
		try {
			List<LadderVO> list;
			if (searchSelect.equals("") || searchSelect.equalsIgnoreCase("none")) {	// 비검색
				if (mode.equals("part")) {		// 일부 참여자 선택
					totalLadder = ezLadderService.partLadderCount(vo);
					pages = paging(page, totalLadder, listNumPerPage);
					list = ezLadderService.getPartLadderList(vo, pages[1], pages[2], sort, sortFlag);
				} else if (mode.equals("pre")) { // 이전 사다리 리스트 출력 
					listNumPerPage = 20;
					totalLadder = ezLadderService.ladderCount(vo, mode);
					pages = paging(page, totalLadder, listNumPerPage);
					list = ezLadderService.getLadderList(vo, pages[1], pages[2], mode, sort, sortFlag);
				} else {						// 전체 참여자 선택
					totalLadder = ezLadderService.ladderCount(vo, mode);
					pages = paging(page, totalLadder, listNumPerPage);
					list = ezLadderService.getLadderList(vo, pages[1], pages[2], mode, sort, sortFlag);
				}
			} else {							// 검색
				if (mode.equals("pre")) {
					listNumPerPage = 20;
				}
				List<String> allData = new ArrayList<String>();
				allData.add(searchSelect);
				allData.add(searchInput);
				allData.add(mode);
				totalLadder = ezLadderService.searchLadderCount(vo, allData);
				pages = paging(page, totalLadder, listNumPerPage);
				list = ezLadderService.searchLadderList(vo, allData, pages[1], pages[2], sort, sortFlag);
			}
			 
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", list);
			result.put("currPage", pages[3]);
			result.put("totalPage", pages[0]);
			result.put("totalLadder", totalLadder);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("web G/W LADDER [GET /rest/ladder/ladder-list/users/" + userId + "] ended.");
		
		return result;
	}
	
	/** 
	 * 참여자 이름 검색으로 바로 추가 
	 * */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ladder/ladders/writers/{writerId:.+}/searchUser", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject gwSelectSearchUser(@PathVariable String writerId, @RequestBody String [] searchUserName, LadderVO ladVO, HttpServletRequest request) {
		
		JSONObject result = new JSONObject();
		
		try {
			List<LadderLineVO> resultUser = ezLadderService.selectSearchUser(searchUserName, ladVO);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", resultUser);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("web G/W LADDER [GET /rest/ladder/ladders/writers/" + writerId + "/searchUser] ended.");
		
		return result;
	}
	
	/**
	 * 사다리 게임 추가
	 * */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ladder/ladders/writers/{writerId:.+}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject gwInsertLadder(@PathVariable String writerId, @RequestBody JSONObject jsonBodys, LadderVO ladVO, LadderLineVO ladLineVO, HttpServletRequest request) {
		logger.debug("web G/W LADDER [POST /rest/ladder/ladders/writers/" + writerId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String todayDate = commonUtil.getTodayUTCTime("");
			
			String logCookie = (String) jsonBodys.get("loginCookie");
			LoginVO userInfo = commonUtil.userInfo(logCookie);
			
			ladVO.setTitle((String) jsonBodys.get("title"));
			ladVO.setType((String) jsonBodys.get("type"));
			ladVO.setSecretFlag((String) jsonBodys.get("secretFlag"));
			ladVO.setLineCnt((String) jsonBodys.get("lineCnt"));
			ladVO.setWriteDate(todayDate);
			ladVO.setWriterName(userInfo.getDisplayName());
			ladVO.setWriterName2(userInfo.getDisplayName2());
			ladVO.setDeptID(userInfo.getDeptID());
			ladVO.setDeptName(userInfo.getDeptName());
			ladVO.setDeptName2(userInfo.getDeptName2());
			ladVO.setCompanyID(userInfo.getCompanyID());
			
			ladLineVO.setUserIds((ArrayList<String>) jsonBodys.get("userIds"));
			ladLineVO.setUserNames((ArrayList<String>) jsonBodys.get("userNames"));
			ladLineVO.setUserName2s((ArrayList<String>) jsonBodys.get("userName2s")); 
			ladLineVO.setDescriptions((ArrayList<String>) jsonBodys.get("descriptions"));
			ladLineVO.setDescriptions2((ArrayList<String>) jsonBodys.get("descriptions2"));
			ladLineVO.setItems((ArrayList<String>) jsonBodys.get("items"));
			
			ezLadderService.insertLadder(ladVO, ladLineVO, logCookie);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", null);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("web G/W LADDER [POST /rest/ladder/ladders/writers/" + writerId + "] ended.");
		
		return result;
	}
	
	/**
	 * 즐겨찾기 그룹 조회
	 * */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ladder/BMs/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject gwSelectBMGroup(@PathVariable String userId, LadderBmVO bmGroupVO, HttpServletRequest request) {
		logger.debug("web G/W LADDER [GET /rest/ladder/BMs/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			List<LadderBmVO> bmGroups = ezLadderService.selectBMGroup(bmGroupVO);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", bmGroups);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("web G/W LADDER [GET /rest/ladder/BMs/users/" + userId + "] ended.");
		
		return result;
	}

	/**
	 * 즐겨찾기 그룹 유저 조회
	 * */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ladder/BMs/{ladderBmId}/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject gwSelectBMUser(@PathVariable String userId, @PathVariable int ladderBmId, LadderBmUserVO bmUserVO, HttpServletRequest request) {
		logger.debug("web G/W LADDER [GET /rest/ladder/BMs/" + ladderBmId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			List<LadderBmUserVO> bmUsers = ezLadderService.selectBMUser(bmUserVO);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", bmUsers);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("web G/W LADDER [GET /rest/ladder/BMs/" + ladderBmId + "/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 즐겨찾기 그룹 추가
	 * */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ladder/BMs/users/{userId:.+}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject gwInsertBMGroup(@PathVariable String userId, LadderBmVO bmGroupVO, LadderBmUserVO bmUsersVO, HttpServletRequest request) {
		logger.debug("web G/W LADDER [POST /rest/ladder/BMs/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			ezLadderService.insertBM(bmGroupVO, bmUsersVO);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", "insert success");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("web G/W LADDER [POST /rest/ladder/BMs/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 즐겨찾기 그룹 수정
	 * */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ladder/BMs/{ladderBmId}/users/{userId:.+}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject gwUpdateBMGroup(@PathVariable String userId, @PathVariable int ladderBmId, LadderBmVO bmGroupVO, LadderBmUserVO bmUsersVO, HttpServletRequest request) {
		logger.debug("web G/W LADDER [PUT /rest/ladder/BMs/" + ladderBmId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			ezLadderService.updateBM(bmGroupVO, bmUsersVO);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", "update success");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("web G/W LADDER [PUT /rest/ladder/BMs/" + ladderBmId + "/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 즐겨찾기 그룹 삭제
	 * */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ladder/BMs/{ladderBmId}/users/{userId:.+}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject gwDeleteBMGroup(@PathVariable String userId, @PathVariable int ladderBmId, LadderBmVO bmGroupVO, LadderBmUserVO bmUsersVO, HttpServletRequest request) {
		logger.debug("web G/W LADDER [DELETE /rest/ladder/BMs/" + ladderBmId + "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			ezLadderService.deleteBM(bmGroupVO, bmUsersVO);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", "delete success");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("web G/W LADDER [DELETE /rest/ladder/BMs/" + ladderBmId + "/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 댓글 조회
	 * */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ladder/ladders/{ladderId}/comment/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject gwSelectComment(@PathVariable String userId, @PathVariable String ladderId, LadderCommentVO cmtVO, HttpServletRequest request) {
		logger.debug("web G/W LADDER [GET /rest/ladder/ladders/" + ladderId + "/comment/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			LadderCommentVO cmt = ezLadderService.selectComment(cmtVO);
			
			cmt.setPic(ezOrganService.getPropertyValue(cmt.getUserId(), "extensionAttribute2", cmt.getTenant_id()));
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", cmt);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("web G/W LADDER [GET /rest/ladder/ladders/" + ladderId + "/comment/users/" + userId + "] ended.");
		
		return result;
	}	
	
	/**
	 * 댓글 추가
	 * */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ladder/ladders/{ladderId}/comment/users/{userId:.+}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject gwInsertComment(@PathVariable String userId, @PathVariable String ladderId, @RequestBody JSONObject jsonBodys, LadderCommentVO cmtVO, HttpServletRequest request) {
		logger.debug("web G/W LADDER [POST /rest/ladder/ladders/" + ladderId + "/comment/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String todayDate = commonUtil.getTodayUTCTime("");
		
			LoginVO userInfo = commonUtil.userInfo((String) jsonBodys.get("loginCookie"));
			cmtVO.setUserName(userInfo.getDisplayName());
			cmtVO.setUserName2(userInfo.getDisplayName2());
			cmtVO.setDeptID(userInfo.getDeptID());
			cmtVO.setId((String) jsonBodys.get("commentId"));
			cmtVO.setComment((String) jsonBodys.get("comment"));
			cmtVO.setWriteDate(todayDate);
			
			ezLadderService.insertComment(cmtVO);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", null);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("web G/W LADDER [POST /rest/ladder/ladders/" + ladderId + "/comment/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 댓글 수정
	 * */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ladder/ladders/{ladderId}/comment/users/{userId:.+}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject gwUpdateComment(@PathVariable String userId, @PathVariable String ladderId, @RequestBody JSONObject jsonBodys, LadderCommentVO cmtVO) {
		logger.debug("web G/W LADDER [PUT /rest/ladder/ladders/" + ladderId + "/comment/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			cmtVO.setId((String) jsonBodys.get("commentId"));
			cmtVO.setComment((String) jsonBodys.get("comment"));
			
			ezLadderService.updateComment(cmtVO);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", null);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("web G/W LADDER [PUT /rest/ladder/ladders/" + ladderId + "/comment/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 댓글 삭제
	 * */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ladder/ladders/{ladderId}/comment/users/{userId:.+}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject gwDeleteComment(@PathVariable String userId, @PathVariable String ladderId, @RequestBody JSONObject jsonBodys, LadderCommentVO cmtVO) {
		logger.debug("web G/W LADDER [DELETE /rest/ladder/ladders/" + ladderId + "/comment/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			cmtVO.setId((String) jsonBodys.get("commentId"));
			
			ezLadderService.deleteComment(cmtVO);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", null);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("web G/W LADDER [DELETE /rest/ladder/ladders/" + ladderId + "/comment/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 이전 사다리 목록 순서 바꾸기
	 * */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ladder/ladder-list/users/{userId:.+}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject gwChangePreLadderList(@PathVariable String userId, LadderOrderVO ladOrderVO, LadderVO vo, HttpServletRequest request) {
		logger.debug("web G/W LADDER [PUT /rest/ladder/ladder-list/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		int page = Integer.parseInt(request.getParameter("currPage"));
		String mode = request.getParameter("mode");
		String searchSelect = request.getParameter("searchSelect");
		String searchInput = request.getParameter("searchInput");
		
		vo.setUserId(userId);
		
		int totalLadder = 0;
		int[] pages = new int[4]; //0 totalPage //1 startPoint //2 endPoint //3 currPage
		int listNumPerPage = 20;
		
		try {
			List<LadderVO> list;
			ezLadderService.changePreLadderList(ladOrderVO);
			if(searchInput.equals("")) {	// 이전 사다리 비검색
				totalLadder = ezLadderService.ladderCount(vo, mode);
				pages = paging(page, totalLadder, listNumPerPage);
				list = ezLadderService.getLadderList(vo, pages[1], pages[2], mode, "date", "desc");
			} else {						// 이전 사다리 검색
				List<String> allData = new ArrayList<String>();
				allData.add(searchSelect);
				allData.add(searchInput);
				allData.add(mode);
			
				totalLadder = ezLadderService.searchLadderCount(vo, allData);
				pages = paging(page, totalLadder, listNumPerPage);
				list = ezLadderService.searchLadderList(vo, allData, pages[1], pages[2], "date", "desc");
			}
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", list);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("web G/W LADDER [PUT /rest/ladder/ladder-list/users/" + userId + "] ended.");
		
		return result;
	}
	
	/** hyh	*/
	
	
	/**
	 * 사디리 게임 조회 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ladder/ladderGame/{ladderId}/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8") 
	public JSONObject gwGetLadderGame(@PathVariable String ladderId , @PathVariable String userId, HttpServletRequest request, LadderVO ladVO, LadderCommentVO cmtVO) {
		logger.debug("web G/W LADDER [Get /rest/ladder/ladders/" + ladderId+ "/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		String mode = request.getParameter("mode");
		String back = request.getParameter("back");

		try {
			LadderVO vo = ezLadderService.getLadderGame(ladVO);
			List<LadderLineVO> list = ezLadderService.getLadderLineParticipant(ladVO, mode, back);
			List<LadderCommentVO> cmtlist = ezLadderService.selectComments(cmtVO);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("ladder", vo);
			result.put("participant", list);
			result.put("cmtlist", cmtlist);
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("web G/W LADDER [Get /rest/ladder/ladders/" + ladderId + "/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 사디리 삭제 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ladder/ladders/delete/{userId:.+}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8") 
	public JSONObject gwDeleteLadderList(@PathVariable String userId,  @RequestBody JSONObject jsonBodys, HttpServletRequest request) {
		logger.debug("web G/W LADDER [GET /rest/ladder/delete/" + userId + "] started.");

		JSONObject result = new JSONObject();
		
		try {
			String logCookie = (String) jsonBodys.get("loginCookie");
			String ladderId = (String) jsonBodys.get("ladderId");
			LoginVO userInfo = commonUtil.userInfo(logCookie);
			
			LadderVO ladVO = new LadderVO();
			ladVO.setUserId(userId);
			ladVO.setTenant_id(userInfo.getTenantId());
			ladVO.setLadderId(Integer.parseInt(ladderId));
			ladVO.setCompanyID(userInfo.getCompanyID());
			
			ezLadderService.deleteLadderList(ladVO);

			result.put("status", "ok");
			result.put("code", "0");

		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("web G/W LADDER [GET /rest/ladder/delete/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 참여자 순서 바꾸기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ladder/ladders/{ladderId}/users/{userId:.+}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8") 
	public JSONObject gwSetUserOrder(@PathVariable String ladderId , @PathVariable String userId, HttpServletRequest request, LadderVO ladVO) {
		logger.debug("web G/W LADDER [PUT /rest/ladder/ladders/" + ladderId+ "/users/" + userId + "] started.");
		String mode = "all";
		String back = "back";
		JSONObject result = new JSONObject();
		String firstUser = request.getParameter("firstUser");
		String secondUser = request.getParameter("secondUser");
		int firstUserOrder = Integer.parseInt(request.getParameter("firstUserOrder"));
		int secondUserOrder = Integer.parseInt(request.getParameter("secondUserOrder"));
		String firstItem = request.getParameter("firstItem");
		String secondItem = request.getParameter("secondItem");
		
		try {
			ezLadderService.setUserOrder(ladVO, firstUser, secondUser, firstUserOrder, secondUserOrder, firstItem, secondItem);
			List<LadderLineVO> lineVO = ezLadderService.getLadderLineParticipant(ladVO, mode, back);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", lineVO);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("web G/W LADDER [PUT /rest/ladder/ladders/" + ladderId + "users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 사다리게임 시작
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ladder/start/{ladderId}/users/{userId:.+}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8") 
	public JSONObject gwSetLadderStart(@PathVariable String ladderId , @PathVariable String userId, @RequestBody JSONObject jsonBodys, HttpServletRequest request) {
		logger.debug("web G/W LADDER [PUT /rest/ladder/start/" + ladderId+ "/users/" + userId + "] started.");
	
		JSONObject result = new JSONObject();
	
		try {
			String logCookie = (String) jsonBodys.get("loginCookie");
			LoginVO userInfo = commonUtil.userInfo(logCookie);
			
			LadderVO ladVO = new LadderVO();
			ladVO.setTenant_id(userInfo.getTenantId());
			ladVO.setLang(userInfo.getLang());
			ladVO.setLadderId(Integer.parseInt(ladderId));
			ladVO.setLineCnt(Integer.parseInt((String)jsonBodys.get("lineCnt")));
			int size = Integer.parseInt((String)jsonBodys.get("size"));
			
			ezLadderService.setLadderStart(ladVO, size);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", "start");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("web G/W LADDER [PUT /rest/ladder/ladders/" + ladderId + "users/" + userId + "] ended.");
		
		return result;
	}
}
