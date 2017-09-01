package egovframework.ezMobile.ezPortal.web;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezMobile.ezApprovalG.service.MApprovalGService;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGDocInfoVO;
import egovframework.ezMobile.ezBoard.service.MBoardService;
import egovframework.ezMobile.ezBoard.vo.MBoardFavoriteVO;
import egovframework.ezMobile.ezBoard.vo.MBoardNewListVO;
import egovframework.ezMobile.ezEmail.service.MEmailService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezResource.service.MResourceService;
import egovframework.ezMobile.ezResource.vo.MResourceScheduleVO;
import egovframework.ezMobile.ezSchedule.service.MScheduleService;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 모바일 - 메인화면
 * @author 오픈솔루션팀 장진혁
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2017.08.03    장진혁    신규작성
 *
 * @see
 */

@RestController
public class MPortalGWController extends EgovFileMngUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(MPortalController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	@Resource(name = "MApprovalGService")
	private MApprovalGService mApprovalGService;
	
	@Resource(name="MScheduleService")
	private MScheduleService mScheduleService;
	
	@Resource(name = "MEmailService")
	private MEmailService mEmailService;
	
	@Resource(name = "MBoardService")
	private MBoardService mBoardService;
	
	@Resource(name="MResourceService")
	private MResourceService mResourceService;
		
	/**
	 * 모바일 G/W 포탈 [GET] 메인 리스트 (일반/폴더/포탈/타임라인)
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezPortal/{type}/main-list/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject portalMainList(@PathVariable String type, @PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("portalMainList Start");
		
		JSONObject result = new JSONObject();
		
		try {
			Map<String, Object> dataObject = new HashMap<String, Object>();

			String serverName = request.getHeader("x-user-host");			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			String listCnt = request.getParameter("listCnt");			
			
			//받은결재함 리스트
			String today = commonUtil.getTodayUTCTime("");
			List<MApprovalGDocInfoVO> apprList = mApprovalGService.getDoApproveList(info, "DO", "", listCnt, today);
		
			//받은결재함 리스트 카운트
			int apprCnt = mApprovalGService.getDoApproveListCount(info, "DO", "");
			
			//오늘의일정 리스트			
			JSONObject scheduleInfo = mScheduleService.scheduleMainList(info, listCnt);
			Object scheduleList = scheduleInfo.get("list");
			
			//오늘의일정 리스트 카운트
			Object scheduleCnt = scheduleInfo.get("cnt");
			
			//안읽은메일 리스트
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			JSONArray mailList = mEmailService.getMainMailList(info, locale, "isUnreadOnly", listCnt);

			//안읽은메일 리스트 카운트
			int mailCnt = mEmailService.getMainMailUnreadCount(info, locale);
			
			//새게시물 리스트
			List<MBoardNewListVO> boardList = mBoardService.getBoardMainList(userId, listCnt, info.getTenantId());
			
			//새게시물 리스트 카운트
			int boardCnt = mBoardService.getNewBoardListCount(userId, "", info.getTenantId());
			
			//오늘의자원 리스트
			Map<String, Object> resourceMap = mResourceService.getScheduleMainList(info, listCnt);
			Object resourceList = resourceMap.get("scheduleList");
			
			//오늘의자원 리스트 카운트
			Object resourceCnt = resourceMap.get("count");			
			
			dataObject.put("apprList", apprList);
			dataObject.put("apprCnt", apprCnt+"");
			
			dataObject.put("scheduleList", scheduleList);
			dataObject.put("scheduleCnt", scheduleCnt+"");
			
			dataObject.put("mailList", mailList);
			dataObject.put("mailCnt", mailCnt+"");
			
			dataObject.put("boardList", boardList);
			dataObject.put("boardCnt", boardCnt+"");
			
			dataObject.put("resourceList", resourceList);
			dataObject.put("resourceCnt", resourceCnt+"");
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", dataObject);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");		
		}		
		
		logger.debug("portalMainList End");
		
		return result;
	}
		
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezPortal/{menu}/footer-list/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject portalFooterList(@PathVariable String menu, @PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("portalFooterList Start");
		
		JSONObject result = new JSONObject();
		
		try {
			Map<String, Object> dataObject = new HashMap<String, Object>();

			String serverName = request.getHeader("x-user-host");			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			
			if (menu.equals("etc")) {
				//게시판 풋터리스트
				List<MBoardFavoriteVO> boardFooterList = mBoardService.getFavoriteList(userId, tenantId);
				
				//자원관리 풋터리스트				
				List<MResourceScheduleVO> resourceFooterList = mResourceService.getResFavoriteList(userId, info.getCompanyId(), tenantId);
				
				dataObject.put("boardFooterList", boardFooterList);
				dataObject.put("resourceFooterList", resourceFooterList);
			}				
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", dataObject);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");		
		}		
		
		logger.debug("portalFooterList End");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 포탈 [GET] 왼쪽 유저정보 
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezPortal/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject portalUserInfo(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("portalUserInfo Start");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", info);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");		
		}		
		
		logger.debug("portalUserInfo End");
		
		return result;
	}
	
}
