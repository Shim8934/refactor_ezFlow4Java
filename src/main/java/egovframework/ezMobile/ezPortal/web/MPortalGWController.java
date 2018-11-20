package egovframework.ezMobile.ezPortal.web;

import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Comparator;
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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezMobile.ezApprovalG.service.MApprovalGService;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGDocInfoVO;
import egovframework.ezMobile.ezBoard.service.MBoardService;
import egovframework.ezMobile.ezBoard.vo.MBoardFavoriteVO;
import egovframework.ezMobile.ezBoard.vo.MBoardNewListVO;
import egovframework.ezMobile.ezEmail.service.MEmailService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.ezMobile.ezPortal.vo.MPortalTimeLineVO;
import egovframework.ezMobile.ezResource.service.MResourceService;
import egovframework.ezMobile.ezResource.vo.MResourceScheduleVO;
import egovframework.ezMobile.ezResource.vo.ResGetScheduleVO;
import egovframework.ezMobile.ezSchedule.service.MScheduleService;
import egovframework.let.user.login.vo.LoginVO;
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
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MPortalGWController.class);
	
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
	
	@Resource(name = "EzEmailService")
	private EzEmailService ezEmailService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "jspw")
    private String jspw;
		
	/**
	 * 모바일 G/W 포탈 [GET] 메인 리스트 (일반/폴더/포탈/타임라인)
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezPortal/{type}/main-list/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject portalMainList(@PathVariable String type, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("portalMainList Start");
		
		JSONObject result = new JSONObject();
		int code = 0;
		
		try {
			Map<String, Object> dataObject = new HashMap<String, Object>();

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			String primary = commonUtil.getPrimaryData(info.getLang(), info.getTenantId());
			String listCnt = request.getParameter("listCnt");
			
			if (type != null && !type.equals("T")) {
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
				
				MOptionVO opt = mOptionService.optionInfo(userId, info.getTenantId());
				if ( opt.getLang().equals("1") ) {
					locale = new Locale("ko");	
				} else if ( opt.getLang().equals("3") ) {
					locale = new Locale("ja");
				}
				
				JSONArray mailList = mEmailService.getMainMailList(info, locale, "isUnreadOnly", listCnt);
				
				//안읽은메일 리스트 카운트
				int mailCnt = mEmailService.getMainMailUnreadCount(info, locale);
				
				/* 2018-07-03 홍승비 - 조건에 companyID 추가 필요 */
				//새게시물 리스트
				List<MBoardNewListVO> boardList = mBoardService.getBoardMainList(userId, listCnt, info.getDeptId(), info.getCompanyId(), info.getTenantId(), info.getOffSet());
				
				/* 2018-07-03 홍승비 - 조건에 companyID 추가 */
				//새게시물 리스트 카운트
				int boardCnt = mBoardService.getNewBoardListCount(userId, "", info.getCompanyId(), info.getTenantId(), "");
				
				//오늘의자원 리스트
				Map<String, Object> resourceMap = mResourceService.getScheduleMainList(info, listCnt, primary);
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
				
			} else {//timeline
				String utcSessionDate = request.getParameter("sessionDate");
				String utcNowDate = commonUtil.getTodayUTCTime("");
				
				//타임라인만 특별히 예외
				listCnt = "30";

				if (utcSessionDate == null || utcSessionDate.equals("")) {
					utcSessionDate = utcNowDate;
				}
				
				String nowDate = commonUtil.getDateStringInUTC(utcNowDate, info.getOffSet(), false);
				String sessionDate = commonUtil.getDateStringInUTC(utcSessionDate, info.getOffSet(), false);
				
				info.setPrimary(primary);
				
				String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
				Locale locale = new Locale(ld);
				LoginVO userInfo = new LoginVO();
				
				userInfo.setId(info.getUserId());
				userInfo.setLocale(locale);
				userInfo.setTenantId(info.getTenantId());
				userInfo.setOffset(info.getOffSet());
				userInfo.setPrimary(primary);
		
				long startTime = System.currentTimeMillis();				
				
				//한번에 가져오긴 힘들고 귀찮다.
				List<MPortalTimeLineVO> mPortalTimeLineVOs = mOptionService.getTimeLineList(info, utcSessionDate, listCnt);
				
				LOGGER.debug("## 전자결재/게시판 소요시간(초.0f) : " + (System.currentTimeMillis() - startTime)/1000.0f + "초");
				startTime = System.currentTimeMillis();
				//메일 조인
				List<Map<String, String>> mailList = ezEmailService.getMailListT(userInfo, jspw, sessionDate, Integer.parseInt(listCnt));
				
				for (Map<String, String> maps : mailList) {
					MPortalTimeLineVO mPortalTimeLineVO = new MPortalTimeLineVO();
					mPortalTimeLineVO.setTitle(maps.get("subject"));
					mPortalTimeLineVO.setStartDate(maps.get("receivedDate"));
					mPortalTimeLineVO.setModule("2");
					mPortalTimeLineVO.setWriterName(maps.get("sender"));
					mPortalTimeLineVO.setMailID(maps.get("uid"));
					
					mPortalTimeLineVOs.add(mPortalTimeLineVO);
				}
				
				LOGGER.debug("## 메일 소요시간(초.0f) : " + (System.currentTimeMillis() - startTime)/1000.0f + "초");
				startTime = System.currentTimeMillis();
				//자원관리 조인
				Map<String, Object> resMap = mResourceService.getScheduleList("", info.getCompanyId(), nowDate.substring(0, 10), nowDate.substring(0, 10), info.getDeptId(), info.getTenantId(), info.getOffSet(), listCnt, "", "", "", "", primary);
				List<ResGetScheduleVO> resList = (List<ResGetScheduleVO>) resMap.get("scheduleList");
				SimpleDateFormat shotDF = new SimpleDateFormat("yyyy-MM-dd");
				SimpleDateFormat longDF = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				
				for (ResGetScheduleVO resGetScheduleVO : resList) {
					MPortalTimeLineVO mPortalTimeLineVO = new MPortalTimeLineVO();
					mPortalTimeLineVO.setTitle(resGetScheduleVO.getTitle());
					mPortalTimeLineVO.setStartDate(resGetScheduleVO.getStartDate());
					mPortalTimeLineVO.setEndDate(resGetScheduleVO.getEndDate());
					mPortalTimeLineVO.setModule("5");
					mPortalTimeLineVO.setWriterName((primary.equals("1") ? resGetScheduleVO.getOwnerNm() : resGetScheduleVO.getOwnerNm2()));
					mPortalTimeLineVO.setResID(resGetScheduleVO.getOwnerId());
					mPortalTimeLineVO.setResNum(resGetScheduleVO.getNum());
					
					if (shotDF.parse(resGetScheduleVO.getStartDate()).compareTo(shotDF.parse(nowDate)) == 0) {
						if (longDF.parse(resGetScheduleVO.getStartDate()).compareTo(longDF.parse(sessionDate)) == 1) {
							if (sessionDate.equals(nowDate)) {
								mPortalTimeLineVOs.add(mPortalTimeLineVO);
							}
						} else {
							mPortalTimeLineVOs.add(mPortalTimeLineVO);
						}
					} else {
						if (longDF.parse(resGetScheduleVO.getStartDate()).compareTo(longDF.parse(sessionDate)) == -1) {
							mPortalTimeLineVOs.add(mPortalTimeLineVO);
						}
					}
				}
				
				LOGGER.debug("## 자원관리 소요시간(초.0f) : " + (System.currentTimeMillis() - startTime)/1000.0f + "초");
				startTime = System.currentTimeMillis();
				//일정관리 조인
				String tempSDate = nowDate.substring(0, 10) + " 00:00:00";
				String tempEDate = nowDate.substring(0, 10) + " 23:59:59";
				
				List<ScheduleInfoVO> schList = mScheduleService.scheduleList(info, tempSDate, tempEDate, "", "", "");
				
				for (ScheduleInfoVO scheduleInfoVO : schList) {
					MPortalTimeLineVO mPortalTimeLineVO = new MPortalTimeLineVO();
					mPortalTimeLineVO.setTitle(scheduleInfoVO.getTitle());
					mPortalTimeLineVO.setStartDate(scheduleInfoVO.getStartDate());
					mPortalTimeLineVO.setEndDate(scheduleInfoVO.getEndDate());
					mPortalTimeLineVO.setModule("3");
					mPortalTimeLineVO.setWriterName((primary.equals("1") ? scheduleInfoVO.getCreatorName() : scheduleInfoVO.getCreatorName2()));
					mPortalTimeLineVO.setSchID(scheduleInfoVO.getScheduleId());
					
					if (shotDF.parse(scheduleInfoVO.getStartDate()).compareTo(shotDF.parse(nowDate)) == 0) {
						if (longDF.parse(scheduleInfoVO.getStartDate()).compareTo(longDF.parse(sessionDate)) == 1) {
							if (sessionDate.equals(nowDate)) {
								mPortalTimeLineVOs.add(mPortalTimeLineVO);
							}
						} else {
							mPortalTimeLineVOs.add(mPortalTimeLineVO);
						}
					} else {
						if (longDF.parse(scheduleInfoVO.getStartDate()).compareTo(longDF.parse(sessionDate)) == -1) {
							mPortalTimeLineVOs.add(mPortalTimeLineVO);
						}
					}
				}
				
				LOGGER.debug("## 일정관리 소요시간(초.0f) : " + (System.currentTimeMillis() - startTime)/1000.0f + "초");
				
				Collections.sort(mPortalTimeLineVOs, new Comparator<MPortalTimeLineVO>() {
					@Override
					public int compare(MPortalTimeLineVO o1, MPortalTimeLineVO o2) {
						return o2.getStartDate().compareTo(o1.getStartDate());
					}
				});
				
				if (mPortalTimeLineVOs.size() > 0) {
					mPortalTimeLineVOs = mPortalTimeLineVOs.subList(0, Integer.parseInt(listCnt) > mPortalTimeLineVOs.size() ? mPortalTimeLineVOs.size() : Integer.parseInt(listCnt));
					utcSessionDate = mPortalTimeLineVOs.get(mPortalTimeLineVOs.size() - 1).getStartDate();
					utcSessionDate = commonUtil.getDateStringInUTC(utcSessionDate, info.getOffSet(), true);
				}
				
				dataObject.put("timeLineCount", mPortalTimeLineVOs.size());
				dataObject.put("timeLineList", mPortalTimeLineVOs);
				dataObject.put("sessionDate", utcSessionDate);
				
				code = 3;
			}
			
			result.put("status", "ok");
			result.put("code", code);			
			result.put("data", dataObject);
		} catch (Exception e) {
			e.printStackTrace();
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");		
		}		
		
		LOGGER.debug("portalMainList End");
		
		return result;
	}
		
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezPortal/{menu}/footer-list/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject portalFooterList(@PathVariable String menu, @PathVariable String userId, HttpServletRequest request, Locale locale) throws Exception {
		LOGGER.debug("portalFooterList Start");
		
		JSONObject result = new JSONObject();
		
		try {
			Map<String, Object> dataObject = new HashMap<String, Object>();

			String serverName = request.getHeader("x-user-host");			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			MOptionVO mobileInfo = mOptionService.optionInfo(userId, tenantId);
			String primary = commonUtil.getPrimaryData(mobileInfo.getLang(), info.getTenantId());
			
			if (menu.equals("etc")) {
				//게시판 풋터리스트
				/* 2018-07-03 홍승비 - 게시판 풋터리스트(즐겨찾기)에 companyID 조건 추가 */
				List<MBoardFavoriteVO> boardFooterList = mBoardService.getFavoriteList(userId, info.getCompanyId(), tenantId, primary);
				
				String langStr = request.getParameter("langStr");
				//자원관리 풋터리스트				
				List<MResourceScheduleVO> resourceFooterList = mResourceService.getResFavoriteList(userId, info.getCompanyId(), tenantId, langStr);
				
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
		
		LOGGER.debug("portalFooterList End");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 포탈 [GET] 왼쪽 유저정보 
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezPortal/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject portalUserInfo(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("portalUserInfo Start");
		
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
		
		LOGGER.debug("portalUserInfo End");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 포탈 [GET] 우측메뉴총계 (일반/폴더/포탈/타임라인)
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezPortal/{type}/right-panel/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject portalRightPanel(@PathVariable String type, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("portalMainList Start");
		
		JSONObject result = new JSONObject();
		
		try {
			Map<String, Object> dataObject = new HashMap<String, Object>();

			String serverName = request.getHeader("x-user-host");			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String langStr = request.getParameter("langStr");
			String listCnt = request.getParameter("listCnt");			
								
			//받은결재함 리스트 카운트
			int apprCnt = mApprovalGService.getDoApproveListCount(info, "DO", "");
			
			//오늘의일정 리스트			
			JSONObject scheduleInfo = mScheduleService.scheduleMainList(info, listCnt);
			
			//오늘의일정 리스트 카운트
			Object scheduleCnt = scheduleInfo.get("cnt");
			
			//안읽은메일 리스트
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);			

			//안읽은메일 리스트 카운트
			int mailCnt = mEmailService.getMainMailUnreadCount(info, locale);
			
			/* 2018-07-03 홍승비 - 조건에 companyID 추가 */
			//새게시물 리스트 카운트
			int boardCnt = mBoardService.getNewBoardListCount(userId, "", info.getCompanyId(), info.getTenantId(), "");
			
			//오늘의자원 리스트
			Map<String, Object> resourceMap = mResourceService.getScheduleMainList(info, listCnt, langStr);
			
			//오늘의자원 리스트 카운트
			Object resourceCnt = resourceMap.get("count");			
			
			dataObject.put("apprCnt", apprCnt+"");
			
			dataObject.put("scheduleCnt", scheduleCnt+"");
			
			dataObject.put("mailCnt", mailCnt+"");
			
			dataObject.put("boardCnt", boardCnt+"");
			
			dataObject.put("resourceCnt", resourceCnt+"");
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", dataObject);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");		
		}		
		
		LOGGER.debug("portalMainList End");
		
		return result;
	}
	
}
