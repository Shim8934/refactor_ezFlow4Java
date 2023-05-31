package egovframework.ezMobile.ezPortal.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;

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
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleGoogleService;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezMobile.ezApprovalG.service.MApprovalGService;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGDocInfoVO;
import egovframework.ezMobile.ezBoard.service.MBoardService;
import egovframework.ezMobile.ezBoard.vo.MBoardFavoriteVO;
import egovframework.ezMobile.ezBoard.vo.MBoardNewListVO;
import egovframework.ezMobile.ezEmail.service.MEmailService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.ezMobile.ezPortal.vo.MPortalMailTimeLineVO;
import egovframework.ezMobile.ezPortal.vo.MPortalTimeLineVO;
import egovframework.ezMobile.ezResource.service.MResourceService;
import egovframework.ezMobile.ezResource.vo.MResourceScheduleVO;
import egovframework.ezMobile.ezResource.vo.ResGetScheduleVO;
import egovframework.ezMobile.ezSchedule.service.MScheduleService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.collection.ChainMap;
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
	
	private static final Logger logger = LoggerFactory.getLogger(MPortalGWController.class);
	
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
	
	@Resource(name = "EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;

	@Autowired
	private EzWebFolderService_y ezWebFolderService_y;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "jspw")
    private String jspw;
	
	@Autowired
	private EzScheduleGoogleService googleService;
		
	/**
	 * 모바일 G/W 포탈 [GET] 메인 리스트 (일반/폴더/포탈/타임라인)
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezPortal/{type}/main-list/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject portalMainList(@PathVariable String type, @PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("portalMainList Start");
		
		JSONObject result = new JSONObject();
		int code = 0;
		
		try {
			Map<String, Object> dataObject = new HashMap<String, Object>();

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			String primary = commonUtil.getPrimaryData(info.getLang(), info.getTenantId());
			String listCnt = request.getParameter("listCnt");
			String approvalAccess = request.getParameter("approval");
			String mailAccess = request.getParameter("mail");
			String scheduleAccess = request.getParameter("schedule");
			String boardAccess = request.getParameter("board");
			String resourceAccess = request.getParameter("resource");
			String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", info.getTenantId());
			String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", info.getTenantId());	// 2023-05-25 이가은 - 전자결재 > 공람문서 메뉴 표출을 위한 approvalFlag 값 추가
			if (useExternalMailServer == null || useExternalMailServer.equals("")) {
				useExternalMailServer = "NO";
			}
			dataObject.put("useExternalMailServer", useExternalMailServer);
			dataObject.put("approvalFlag", approvalFlag);
			
			if (type != null && !type.equals("T")) {
				/* 결재  */
				//받은결재함 리스트
				String today = commonUtil.getTodayUTCTime("");
				List<MApprovalGDocInfoVO> apprList = new ArrayList<MApprovalGDocInfoVO>();
				//받은결재함 리스트 카운트
				int apprCnt = 0;
				
				if (approvalAccess.equals("true")) {
					apprList = mApprovalGService.getDoApproveList(info, "DO", "", listCnt, today);
					apprCnt = mApprovalGService.getDoApproveListCount(info, "DO", "");
				}
				
				/* 일정  */
				//오늘의일정 리스트			
				JSONObject scheduleInfo = new JSONObject();
				Object scheduleList = null;
				//오늘의일정 리스트 카운트
				Object scheduleCnt = null;
				
				if (scheduleAccess.equals("true")) {
					scheduleInfo = mScheduleService.scheduleMainList(info, listCnt);
					scheduleList = scheduleInfo.get("list");
					scheduleCnt = scheduleInfo.get("cnt");
					
					String useWorkspaceSchedule = ezCommonService.getTenantConfig("useWorkspaceSchedule", info.getTenantId());
					if (useWorkspaceSchedule == null || useWorkspaceSchedule.equals("")) {
						useWorkspaceSchedule = "NO";
					}
			        if("YES".equalsIgnoreCase(useWorkspaceSchedule)) {
			        	String workspaceHostUrl = ezCommonService.getTenantConfig("workspaceHostUrlForMobile", info.getTenantId());
			        	dataObject.put("workspaceHostUrl", workspaceHostUrl);
			        }
				}
				
				/* 메일  */
				//안읽은메일 리스트
				String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
				Locale locale = new Locale(ld);
				
				MOptionVO opt = mOptionService.optionInfo(userId, info.getTenantId());
				if ( opt.getLang().equals("1") ) {
					locale = new Locale("ko");	
				} else if ( opt.getLang().equals("3") ) {
					locale = new Locale("ja");
				}
				
				if (useExternalMailServer.equalsIgnoreCase("NO")) {
					JSONArray mailList = mEmailService.getMainMailList(info, locale, "isUnreadOnly", listCnt);

					//안읽은메일 리스트 카운트
					int mailCnt = 0;

					if ("true".equals(mailAccess)) {
						mailList = mEmailService.getMainMailList(info, locale, "isUnreadOnly", listCnt);
						mailCnt = mEmailService.getMainMailUnreadCount(info, locale);

						// 메일 중요도 색깔 구하기
						// jgw 요청은 비싸니깐 먼저 중요도 높음 메일이 있는지 체크
						if (mailList.stream().anyMatch(mail -> ((JSONObject) mail).get("importance").equals(2))) {
							String importanceColor = Optional.ofNullable(ezEmailService.getMailColor(info.getTenantId()))
									.map(MailColorVO::getImportanceColor).orElse("#ff0000");
							dataObject.put("importanceColor", importanceColor);
						}
					}

					dataObject.put("mailList", mailList);
					dataObject.put("mailCnt", mailCnt + "");
				}

				/* 2018-07-03 홍승비 - 조건에 companyID 추가 필요 */
				//새게시물 리스트
				List<MBoardNewListVO> boardList = new ArrayList<MBoardNewListVO>();
				int boardCnt = 0;
				
				if (boardAccess.equals("true")) {
					boardList = mBoardService.getBoardMainList(userId, listCnt, info.getDeptId(), info.getCompanyId(), info.getTenantId(), info.getOffSet());
					
					/* 2018-07-03 홍승비 - 조건에 companyID 추가 */
					//새게시물 리스트 카운트
					boardCnt = mBoardService.getNewBoardListCount(userId, "", info.getCompanyId(), info.getTenantId(), "");
				}
				
				//오늘의자원 리스트
				Map<String, Object> resourceMap = new HashMap<String, Object>();
				Object resourceList = null;
				//오늘의자원 리스트 카운트
				Object resourceCnt = null;
				
				if (resourceAccess.equals("true")) {
					resourceMap = mResourceService.getScheduleMainList(info, listCnt, primary);
					resourceList = resourceMap.get("scheduleList");
					resourceCnt = resourceMap.get("count");			
				}
				
				dataObject.put("apprList", apprList);
				dataObject.put("apprCnt", apprCnt+"");
				
				dataObject.put("scheduleList", scheduleList);
				dataObject.put("scheduleCnt", scheduleCnt+"");
				
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
				List<MPortalTimeLineVO> mPortalTimeLineVOs = mOptionService.getTimeLineList(info, utcSessionDate, listCnt, approvalAccess, boardAccess);
				
				logger.debug("## 전자결재/게시판 소요시간(초.0f) : " + (System.currentTimeMillis() - startTime)/1000.0f + "초");
				startTime = System.currentTimeMillis();
				
				if ("true".equalsIgnoreCase(mailAccess) && "NO".equalsIgnoreCase(useExternalMailServer)) {
					//메일 조인
					List<Map<String, String>> mailList = ezEmailService.getMailListT(userInfo, jspw, sessionDate, Integer.parseInt(listCnt));
					boolean hasHighImportance = false;
					
					for (Map<String, String> maps : mailList) {
						MPortalMailTimeLineVO mPortalTimeLineVO = new MPortalMailTimeLineVO();
						String importance = maps.get("importance");

						if ("2".equals(importance)) {
							hasHighImportance = true;
						}

						mPortalTimeLineVO.setTitle(maps.get("subject"));
						mPortalTimeLineVO.setStartDate(maps.get("receivedDate"));
						mPortalTimeLineVO.setModule("2");
						mPortalTimeLineVO.setWriterName(maps.get("sender"));
						mPortalTimeLineVO.setMailID(maps.get("uid"));
						mPortalTimeLineVO.setImportance(importance);
						
						mPortalTimeLineVOs.add(mPortalTimeLineVO);
					}
					
					// 메일 중요도 색상
					// jgw 요청은 비싸니깐 먼저 중요도 높음 메일이 있는지 체크
					if (hasHighImportance) {
						String importanceColor = Optional.ofNullable(ezEmailService.getMailColor(info.getTenantId()))
								.map(MailColorVO::getImportanceColor).orElse("#ff0000");
						dataObject.put("importanceColor", importanceColor);
					}

					logger.debug("## 메일 소요시간(초.0f) : " + (System.currentTimeMillis() - startTime)/1000.0f + "초");
				}
				
				startTime = System.currentTimeMillis();
				SimpleDateFormat shotDF = new SimpleDateFormat("yyyy-MM-dd");
				SimpleDateFormat longDF = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				
				if (resourceAccess.equals("true")) {
					//자원관리 조인
					Map<String, Object> resMap = mResourceService.getScheduleList("", info.getCompanyId(), nowDate.substring(0, 10), nowDate.substring(0, 10), info.getDeptId(), info.getTenantId(), info.getOffSet(), listCnt, "", "", "", "", primary);
					List<ResGetScheduleVO> resList = (List<ResGetScheduleVO>) resMap.get("scheduleList");
					
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
					
					logger.debug("## 자원관리 소요시간(초.0f) : " + (System.currentTimeMillis() - startTime)/1000.0f + "초");
				}
				
				startTime = System.currentTimeMillis();
				
				if (scheduleAccess.equals("true")) {
					//일정관리 조인
					String tempSDate = nowDate.substring(0, 10) + " 00:00:00";
					String tempEDate = nowDate.substring(0, 10) + " 23:59:59";
					List<ScheduleInfoVO> schList = mScheduleService.scheduleList(info, tempSDate, tempEDate, "", "", "");
					
					String useGoogleCalendar = ezCommonService.getTenantConfig("useGoogleCalendar", info.getTenantId());
					if(useGoogleCalendar.equals("YES")) {
						userInfo = commonUtil.getUserForGw(userId, serverName);
						userInfo.setDisplayName(info.getUserName());
						userInfo.setDisplayName1(info.getUserName2());
						userInfo.setDisplayName2(info.getUserName2());
						List<ScheduleInfoVO> googleList = googleService.getGoogleScheduleList(tempSDate, tempEDate, "", userInfo, userInfo.getId(), "member", userInfo.getDisplayName());		
						schList.addAll(googleList);
					}
					
					for (ScheduleInfoVO scheduleInfoVO : schList) {
						MPortalTimeLineVO mPortalTimeLineVO = new MPortalTimeLineVO();
						mPortalTimeLineVO.setTitle(scheduleInfoVO.getTitle());
						mPortalTimeLineVO.setStartDate(scheduleInfoVO.getStartDate());
						mPortalTimeLineVO.setEndDate(scheduleInfoVO.getEndDate());
						mPortalTimeLineVO.setModule("3");
						mPortalTimeLineVO.setWriterName((primary.equals("1") ? scheduleInfoVO.getCreatorName() : scheduleInfoVO.getCreatorName2()));
						mPortalTimeLineVO.setSchID(scheduleInfoVO.getScheduleId());
						mPortalTimeLineVO.setRepeatCount(scheduleInfoVO.getRepeatCount());
						mPortalTimeLineVO.setSchFlag(scheduleInfoVO.getScheduleFlag());
						
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
					
					String useWorkspaceSchedule = ezCommonService.getTenantConfig("useWorkspaceSchedule", info.getTenantId());
					if (useWorkspaceSchedule == null || useWorkspaceSchedule.equals("")) {
						useWorkspaceSchedule = "NO";
					}
					if("YES".equalsIgnoreCase(useWorkspaceSchedule)) {
			        	String workspaceHostUrl = ezCommonService.getTenantConfig("workspaceHostUrlForMobile", info.getTenantId());
			        	dataObject.put("workspaceHostUrl", workspaceHostUrl);
			        }
					
					logger.debug("## 일정관리 소요시간(초.0f) : " + (System.currentTimeMillis() - startTime)/1000.0f + "초");
				}
				
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
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");		
		}		
		
		logger.debug("portalMainList End");
		
		return result;
	}
		
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezPortal/{menu}/footer-list/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject portalFooterList(@PathVariable String menu, @PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("portalFooterList Start");
		
		JSONObject result = new JSONObject();
		
		try {
			Map<String, Object> dataObject = new HashMap<String, Object>();

			String serverName = request.getHeader("x-user-host");			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			MOptionVO mobileInfo = mOptionService.optionInfo(userId, tenantId);
			String primary = commonUtil.getPrimaryData(mobileInfo.getLang(), info.getTenantId());
			Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(info.getLang()));
			
			if (menu.equals("etc")) {
				//게시판 풋터리스트
				/* 2018-07-03 홍승비 - 게시판 풋터리스트(즐겨찾기)에 companyID 조건 추가 */
				List<MBoardFavoriteVO> boardFooterList = mBoardService.getFavoriteList(userId, info.getCompanyId(), tenantId, primary);
				
				String langStr = request.getParameter("langStr");
				//자원관리 풋터리스트				
				List<MResourceScheduleVO> resourceFooterList = mResourceService.getResFavoriteList(userId, info.getCompanyId(), tenantId, langStr);
				/* 2019-05-09 홍승비 - useLoginCookieSSO 여부 파라미터 추가 */
				String useLoginCookieSSO = ezCommonService.getTenantConfig("useLoginCookieSSO", tenantId);

				dataObject.put("boardFooterList", boardFooterList);
				dataObject.put("resourceFooterList", resourceFooterList);
				dataObject.put("webfolderFooterList", getWebfolderFooters(userId, info.getDeptId(), info.getCompanyId(), primary, locale, tenantId));
				dataObject.put("useLoginCookieSSO", useLoginCookieSSO);
			} else if (menu.equals("board")) {
				//게시판 풋터리스트
				/* 2018-07-03 홍승비 - 게시판 풋터리스트(즐겨찾기)에 companyID 조건 추가 */
				List<MBoardFavoriteVO> boardFooterList = mBoardService.getFavoriteList(userId, info.getCompanyId(), tenantId, primary);
				dataObject.put("boardFooterList", boardFooterList);
			} else if (menu.equals("workspace")) {
				/* 2019-05-09 홍승비 - useLoginCookieSSO 여부 파라미터 추가 */
				String useLoginCookieSSO = ezCommonService.getTenantConfig("useLoginCookieSSO", tenantId);
				dataObject.put("useLoginCookieSSO", useLoginCookieSSO);
			} else if (menu.equals("resource")) {
				String langStr = request.getParameter("langStr");
				//자원관리 풋터리스트				
				List<MResourceScheduleVO> resourceFooterList = mResourceService.getResFavoriteList(userId, info.getCompanyId(), tenantId, langStr);
				dataObject.put("resourceFooterList", resourceFooterList);
			} else if (menu.equals("webfolder")) {
				// 웹폴더 풋터리스트
				dataObject.put("webfolderFooterList", getWebfolderFooters(userId, info.getDeptId(), info.getCompanyId(), primary, locale, tenantId));
			}
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", dataObject);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");		
		}		
		
		logger.debug("portalFooterList End");
		
		return result;
	}

	private List<Map<String, Object>> getWebfolderFooters(String userId, String deptId, String companyId, String primary, Locale locale, int tenantId) throws Exception {
		List<Map<String, Object>> footers = new ArrayList<>(6);

		getWebfolderFooter("company", userId, deptId, companyId, primary, tenantId, "C", "ezWebFolder.t11", locale).ifPresent(footers::add);
		getWebfolderFooter("department", userId, deptId, companyId, primary, tenantId, "D", "ezWebFolder.t12", locale).ifPresent(footers::add);
		getWebfolderFooter("user", userId, deptId, companyId, primary, tenantId, "U", "ezWebFolder.t13", locale).ifPresent(footers::add);
		footers.add(ChainMap.of("pageType", "shared").add("title", egovMessageSource.getMessage("ezWebFolder.t214", locale)));
		footers.add(ChainMap.of("pageType", "sharing").add("title", egovMessageSource.getMessage("ezWebFolder.t267", locale)));
		footers.add(ChainMap.of("pageType", "favorite").add("title", egovMessageSource.getMessage("ezWebFolder.t281", locale)));

		return footers;
	}

	private Optional<Map<String, Object>> getWebfolderFooter(String pageType, String userId, String deptId, String companyId, String primary, int tenantId, String folderType, String messageKey, Locale locale) throws Exception {
		return ezWebFolderService_y.getFolderTree(userId, deptId, companyId, folderType, primary, tenantId, "").stream()
				.findFirst().map(folder -> ChainMap.of("pageType", pageType).add("id", folder.getId()).add("title", egovMessageSource.getMessage(messageKey, locale)));
	}

	/**
	 * 모바일 G/W 포탈 [GET] 왼쪽 유저정보 
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezPortal/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
			logger.error(e.getMessage(), e);
		}		
		
		logger.debug("portalUserInfo End");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 포탈 [GET] 우측메뉴총계 (일반/폴더/포탈/타임라인)
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezPortal/{type}/right-panel/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject portalRightPanel(@PathVariable String type, @PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("portalMainList Start");
		
		JSONObject result = new JSONObject();
		
		try {
			Map<String, Object> dataObject = new HashMap<String, Object>();

			String serverName = request.getHeader("x-user-host");			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String langStr = request.getParameter("langStr");
			String listCnt = request.getParameter("listCnt");			
			String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", info.getTenantId());
			if (useExternalMailServer == null || useExternalMailServer.equals("")) {
				useExternalMailServer = "NO";
			}					
			
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
			if(useExternalMailServer.equalsIgnoreCase("NO")) {
			int mailCnt = mEmailService.getMainMailUnreadCount(info, locale);
			dataObject.put("mailCnt", mailCnt+"");
			}
			
			/* 2018-07-03 홍승비 - 조건에 companyID 추가 */
			//새게시물 리스트 카운트
			int boardCnt = mBoardService.getNewBoardListCount(userId, "", info.getCompanyId(), info.getTenantId(), "");
			
			//오늘의자원 리스트
			Map<String, Object> resourceMap = mResourceService.getScheduleMainList(info, listCnt, langStr);
			
			//오늘의자원 리스트 카운트
			Object resourceCnt = resourceMap.get("count");			
			
			dataObject.put("apprCnt", apprCnt+"");
			
			dataObject.put("scheduleCnt", scheduleCnt+"");
			
			dataObject.put("boardCnt", boardCnt+"");
			
			dataObject.put("resourceCnt", resourceCnt+"");
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", dataObject);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");	
			logger.error(e.getMessage(), e);
		}		
		
		logger.debug("portalMainList End");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 포탈 [GET] 메뉴 권한 체크 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezPortal/menus/auth/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject checkMenuAuth(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("checkMenuAuth Start");
		
		JSONObject result = new JSONObject();
		
		try {
			Map<String, Object> dataObject = new HashMap<String, Object>();

			String serverName = request.getHeader("x-user-host");			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			String menuCodeStr = "approval,mail,schedule,board,resource,workspace,address,webfolder";
			String[] menuCodeArr = menuCodeStr.split(",");
			ArrayList<String> menuCodeList =  new ArrayList<>(Arrays.asList(menuCodeArr));
			int tenantId = info.getTenantId();
			String companyId = info.getCompanyId();
			String deptId = info.getDeptId();
			String lang = info.getLang();
			
			Map<String, Boolean> menuAccessList = commonUtil.checkMenuAccess(menuCodeList, companyId, tenantId, lang, userId, deptId);
			
			int footerAccessCount = 0;
			int portalAccessCount = 0;
			List<String> accessMenuCode = new ArrayList<String>();
			
			for (Map.Entry<String, Boolean> menuAccess : menuAccessList.entrySet()) {
				String menuCode = menuAccess.getKey();
				boolean access = menuAccess.getValue();
				
				switch(menuCode) {
				case "approval" :
				case "mail" :
				case "schedule" :
				case "board" :
				case "resource" : 
				case "webfolder" :
					footerAccessCount = access? footerAccessCount + 1 : footerAccessCount;
					portalAccessCount = access? portalAccessCount + 1 : portalAccessCount;
					
					if(access) {
						accessMenuCode.add(menuCode);
					}
					
					dataObject.put(menuCode, access);
					dataObject.put(menuCode + "Access", access);
					break;
				case "workspace" : 
					footerAccessCount = access? footerAccessCount + 1 : footerAccessCount;
					
					if(access) {
						accessMenuCode.add(menuCode);
					}
					
					dataObject.put(menuCode, access);
					dataObject.put(menuCode + "Access", access);
					break;
				case "address" : 
					dataObject.put(menuCode, access);
					dataObject.put(menuCode + "Access", access);
					break;
				}
			}
			logger.debug("[access result] footerAccessCount : " + footerAccessCount + ", accessMenuCode : " + accessMenuCode.toString() + ", portalAccessCount : " + portalAccessCount);
			
			// 2023-05-25 이가은 - 전자결재 > 공람문서 메뉴 표출을 위한 approvalFlag 값 추가
			String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", info.getTenantId());	
			
			dataObject.put("portalAccessCount", portalAccessCount);
			dataObject.put("footerAccessCount", footerAccessCount);
			dataObject.put("accessMenuCode", accessMenuCode);
			dataObject.put("approvalFlag", approvalFlag);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", dataObject);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");	
			logger.error(e.getMessage(), e);
		}		
		
		logger.debug("checkMenuAuth End");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 포탈 [GET] 겸직 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezPortal/users/{userId:.+}/addJob", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject addJobList(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("getAddJobList Start");
		
		JSONObject result = new JSONObject();
		
		try {
			Map<String, Object> dataObject = new HashMap<String, Object>();
			
			String serverName = request.getHeader("x-user-host");			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			int tenantId = info.getTenantId();
			String lang = info.getLang();
			
			List<OrganUserVO> addJobList = new ArrayList<OrganUserVO>();
			
			OrganUserVO userVO = ezOrganAdminService.getUserInfo(userId, lang, tenantId);
			userVO.setTitle1(userVO.getTitle1().replace("\'","\\'"));
			userVO.setTitle1(userVO.getTitle1().replace("\"","&quot;"));
			userVO.setTitle2(userVO.getTitle2().replace("\'","\\'"));
			userVO.setTitle2(userVO.getTitle2().replace("\"","&quot;"));
			userVO.setDescription1(userVO.getDescription1().replace("\'","\\'"));
			userVO.setDescription1(userVO.getDescription1().replace("\"","&quot;"));
			userVO.setDescription2(userVO.getDescription2().replace("\'","\\'"));
			userVO.setDescription2(userVO.getDescription2().replace("\"","&quot;"));
			addJobList.add(userVO);
			
			List<OrganUserVO> addJobList2 = ezOrganAdminService.getUserAddJobList(userId, lang, tenantId);
			for (OrganUserVO addJob: addJobList2) {
				addJob.setTitle1(addJob.getTitle1().replace("\'","\\'"));
				addJob.setTitle1(addJob.getTitle1().replace("\"","&quot;"));
				addJob.setTitle2(addJob.getTitle2().replace("\'","\\'"));
				addJob.setTitle2(addJob.getTitle2().replace("\"","&quot;"));
				addJob.setDescription1(addJob.getDescription1().replace("\'","\\'"));
				addJob.setDescription1(addJob.getDescription1().replace("\"","&quot;"));
				addJob.setDescription2(addJob.getDescription2().replace("\'","\\'"));
				addJob.setDescription2(addJob.getDescription2().replace("\"","&quot;"));
			}
			addJobList.addAll(addJobList2);
			
			dataObject.put("addJobList", addJobList);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", dataObject);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");	
			logger.error(e.getMessage(), e);
		}		
		
		logger.debug("getAddJobList End");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 포탈 [GET] 겸직 리스트 플래그
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezPortal/users/{userId:.+}/addJobFlag", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject addJobListFlag(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("getAddJobFlag Start");
		
		JSONObject result = new JSONObject();
		
		try {
			Map<String, Object> dataObject = new HashMap<String, Object>();
			
			String serverName = request.getHeader("x-user-host");			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			int tenantId = info.getTenantId();
			String lang = info.getLang();
			
			List<OrganUserVO> addJobList = new ArrayList<OrganUserVO>();
			
			OrganUserVO userVO = ezOrganAdminService.getUserInfo(userId, lang, tenantId);
			addJobList.add(userVO);
			
			List<OrganUserVO> addJobList2 = ezOrganAdminService.getUserAddJobList(userId, lang, tenantId);
			
			addJobList.addAll(addJobList2);
			
			if ( addJobList.size() >= 2 ) {
				dataObject.put("addJobFlag", "YES");
			}
			else {
				dataObject.put("addJobFlag", "NO");
			}
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", dataObject);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");		
			logger.error(e.getMessage(), e);
		}		
		
		logger.debug("getAddJobFlag End");
		
		return result;
	}
	
}
