package egovframework.ezMobile.ezPortal.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.TimeZone;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.UIDFolder;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;

import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezEKP.ezNewPortal.vo.MenuInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.UserPortalSettingVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezResource.vo.ResBrdVO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.service.impl.EzScheduleCompareUtil;
import egovframework.ezEKP.ezSchedule.vo.ScheduleCumulerVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleDeptVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleSecretaryVO;
import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import org.apache.commons.lang3.StringUtils;
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
import egovframework.ezEKP.ezNewPortal.vo.MenuInfoVO;
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

	@Autowired
	private EzOrganService ezOrganService;

	@Resource(name = "EzNewPortalService")
	private EzNewPortalService ezNewPortalService;

	@Autowired
	private Properties config;

	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;

	@Resource(name = "EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;

	@Autowired
	private EzEmailUtil ezEmailUtil;

	@Resource(name = "EzScheduleService")
	private EzScheduleService ezScheduleService;

	@Resource(name="EzResourceService")
	private EzResourceService ezResourceService;
	
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
				locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(opt.getLang()));
				
				if (useExternalMailServer.equalsIgnoreCase("NO")) {
					JSONArray mailList = mEmailService.getMainMailList(info, locale, "isUnreadOnly", listCnt);

					//안읽은메일 리스트 카운트
					int mailCnt = 0;

					if ("true".equals(mailAccess)) {
						mailList = mEmailService.getMainMailList(info, locale, "isUnreadOnly", listCnt);
						mailCnt = mEmailService.getMainMailUnreadCount(info, locale);

						// 메일 중요도 색깔 구하기
						// jgw 요청은 비용이 높으므로 먼저 중요도 높음 메일이 있는지 체크함
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
					// jgw 요청은 비용이 높으므로 먼저 중요도 높음 메일이 있는지 체크함
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
					List<ScheduleInfoVO> schList = mScheduleService.scheduleList(info, tempSDate, tempEDate, "", "", "", "");
					
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
			
			String menuCodeStr = "approval,mail,schedule,board,resource,workspace,address,webfolder,survey";
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

			String useMobileMail2 =  config.getProperty("config.useMobileMail2");
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

					if ("mail".equalsIgnoreCase(menuCode)){
						if ("Y".equalsIgnoreCase(useMobileMail2)){
							footerAccessCount = access? footerAccessCount + 1 : footerAccessCount;
							portalAccessCount = access? portalAccessCount + 1 : portalAccessCount;
							accessMenuCode.add("mail2");
						}
					}

					break;
				case "survey":
				case "workspace":
					footerAccessCount = access ? footerAccessCount + 1 : footerAccessCount;

					if (access) {
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
			dataObject.put("useMobileMail2", useMobileMail2);

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
			String userLang = info.getLang();
			
			String lang = commonUtil.getPrimaryData(userLang, tenantId);
			
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

	@SuppressWarnings("unchecked")
	// 모바일 포탈개인화 G/W [GET] 포틀릿 개인별 조회
	@RequestMapping(value = "/mobile/ezPortal/portletSetting/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getPortalPortlet(HttpServletRequest request, @PathVariable String userId, Locale locale) throws Exception {
		logger.debug("MOBILE G/W getPortalPortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String companyId = info.getCompanyId();
			String deptId = info.getDeptId();
			String jobId = info.getJobId();
			int tenantId = info.getTenantId();
			String portletLang = info.getLang();
			String deptPath = ezOrganService.getDeptPath(deptId, tenantId);
			String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", info.getTenantId());
			
			logger.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId + ", portletLang : " + portletLang + ", deptPath : " + deptPath);
			Optional<OrganUserVO> userInfo = ezOrganService.getUserInfo(tenantId, userId, companyId, deptId, jobId, portletLang);

			if (!userInfo.isPresent()) {
				throw new Exception("There are no query result about user matching the given conditions.");
			}

			OrganUserVO organUserVO = userInfo.get();

			List<PortletInfoVO> portletOrder = ezNewPortalService.getUserPortletList(4, portletLang, userId, tenantId, companyId, deptId, false);

			String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", tenantId);
			String useSchedule = ezCommonService.getTenantConfig("useSchedule", tenantId);
			String useResource = ezCommonService.getTenantConfig("useResource", tenantId);
			String useBoard = ezCommonService.getTenantConfig("useBoard", tenantId);
			String useFixBoard = ezCommonService.getTenantConfig("useFixBoard", tenantId);


			if (useExternalMailServer == null || useExternalMailServer.equals("")) {
				useExternalMailServer = "NO";
			}

			if (useSchedule == null || useSchedule.equals("")) {
				useSchedule = "YES";
			}

			if (useResource == null || useResource.equals("")) {
				useResource = "YES";
			}

			if (useBoard == null || useBoard.equals("")) {
				useBoard = "YES";
			}

			if (StringUtils.isBlank(useFixBoard)) {
				useFixBoard = "YES";
			}

			if (useSchedule.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("schedule")));
			}

			if (useResource.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("resource")));
			}

			if (useBoard.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("board")));
			}

			if (useFixBoard.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("fix")));
			}

			if (useExternalMailServer.equalsIgnoreCase("YES")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("mail")));
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("address")));
			}

			List<PortletInfoVO> fixedPortletList = portletOrder.stream()
					.filter(PortletInfoVO::isFixBoard)
					.collect(Collectors.toList());
			portletOrder.removeAll(fixedPortletList);

			portletOrder.replaceAll(vo -> {
				vo.setClassSize("one_by_one");
				return vo;
			});

			JSONObject data = new JSONObject();
			data.put("fixedPortletList", fixedPortletList);
			data.put("portletOrder", portletOrder);

			String userName = "";
			String userTitle = "";
			String deptName = "";
			String userPhoto = "";

			// 회원정보 불러오기
			userName = organUserVO.getDisplayName();
			userTitle = organUserVO.getTitle();
			deptName = organUserVO.getDescription();

			// 메일, 결재, 일정 권한이 있는지 확인
			String useMail = "NO";
			String useApproval = "NO";
			//String useSchedule = "NO";

			// 2. 메뉴에 권한이 있는지 ================ 수정하기 start

			List<MenuInfoVO> menuList = ezNewPortalService.getUserMenuList(companyId, tenantId, portletLang, userId, deptId);

			boolean isUseScheduleAuth = false;

			for (MenuInfoVO mVO : menuList) {
				if (mVO.getMenuCode() != null && mVO.getMenuCode().equals("approval")) {
					useApproval = "YES";
				}

				if (mVO.getMenuCode() != null && mVO.getMenuCode().equals("mail")) {
					useMail = "YES";
				}

				if (mVO.getMenuCode() != null && mVO.getMenuCode().equals("schedule") && useSchedule.equals("YES")) {
					isUseScheduleAuth = true;
				}
			}

			if(isUseScheduleAuth) {
				useSchedule = "YES";
			} else {
				useSchedule = "NO";
			}

			if (useExternalMailServer.equalsIgnoreCase("YES")) {
				useMail = "NO";
			} else {
				useMail = "YES";
			}

			logger.debug("useMail : " + useMail + ", useApproval : " + useApproval + ", useSchedule : " + useSchedule);
			// =================================== 여기까지 end

			data.put("userName", userName);
			data.put("userTitle", userTitle);
			data.put("deptName", deptName);
			data.put("userPhoto", userPhoto);
			data.put("useMail", useMail);
			data.put("useApproval", useApproval);
			data.put("useSchedule", useSchedule);
			data.put("useBoard", useBoard);
			data.put("useResource", useResource);
			data.put("userEmail", info.getEmail());

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}
		logger.debug("MOBILE G/W getPortalPortlet ended.");
		return result;
	}

	// 모바일 공지사항 게시판 포틀릿 조회
	@RequestMapping(value = "/mobile/ezPortal/portlets/notice", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getNoticePortlet(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W getNoticePortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			String companyId = request.getParameter("companyId");
			String deptId = info.getDeptId();

			String deptPath = ezOrganService.getDeptPath(deptId, tenantId);
			deptPath = "everyone,top,Top," + deptPath + "," + userId;
			String rollInfo = info.getRollInfo();
			int portletId = Integer.parseInt(request.getParameter("portletId"));
			int currentPage = Integer.parseInt(request.getParameter("currentPage"));
			int listCntSize = request.getParameter("listCnt") == null ? 4 * 3 : Integer.parseInt(request.getParameter("listCnt"));
			String portletLang = info.getLang();
			int totalCnt = 0;

			// 회사의 포토게시판의 포틀릿 정보 가져오기
			PortletInfoVO portlet = ezNewPortalService.getCompanyPortletInfo(companyId, tenantId, portletId, portletLang);
			String boardId = portlet.getPortletBoardId();

			// 게시판 권한 체크
			boolean accessCheck = boardAuthCheck(boardId, deptPath, tenantId, companyId, deptId, userId, rollInfo);

			// 여기에 데이터를 put해서 넘기면 됨.
			JSONObject data = new JSONObject();
			data.put("boardId", boardId); // 포틀릿 정보 중 boardId 가져오기

			if (boardId == null) {
				data.put("access", "false");
			} else {
				if (!accessCheck) {
					data.put("access", "false");
				} else {
					BoardMyFavoriteVO brdVo = new BoardMyFavoriteVO();
					brdVo.setBoardId(boardId);
					brdVo.setUserId(userId);
					brdVo.setType("1");
					brdVo.setTenantID(tenantId);
					brdVo.setNowDate(commonUtil.getTodayUTCTime(""));
					totalCnt = ezBoardService.getBrdTotalItemCount(brdVo);
					// 권한이 true이면 boardList불러오기
					List<BoardListVO> noticeList = new ArrayList<BoardListVO>();

					noticeList = ezNewPortalService.getNoticePortletList(companyId, tenantId, info.getOffSet(), info.getLang(), currentPage, listCntSize, portletId);

					if (currentPage > 1 && noticeList.size() < 1) {
						currentPage--;
						ezNewPortalService.getNoticePortletList(companyId, tenantId, info.getOffSet(), info.getLang(), currentPage, listCntSize, portletId);
					}

					int noticeCount = noticeList.size();

					for (int i = 0; i < noticeCount; i++) {
						String writeDate = noticeList.get(i).getWriteDate();
						noticeList.get(i).setWriteDate(commonUtil.getDateStringInUTC(writeDate, info.getOffSet(), false));
					}

					data.put("currentPage", currentPage);
					data.put("access", "true");
					data.put("noticeList", noticeList);
				}

			}

			data.put("totalCnt", totalCnt);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}
		logger.debug("MOBILE G/W getNoticePortlet ended.");
		return result;
	}
	
	// 모바일 포토갤러리 게시판 포틀릿 조회
	@RequestMapping(value = "/mobile/ezPortal/portlets/photoBoard", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getPhotoBoardPortlet(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W getPhotoBoardPortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = request.getParameter("companyId");
			String deptId = info.getDeptId();
			String rollInfo = info.getRollInfo();
			String portletLang = info.getLang();
			int tenantId = info.getTenantId();
			int portletId = Integer.parseInt(request.getParameter("portletId")); // 포토게시판의  포틀릿 아이디
			int currentPage = Integer.parseInt(request.getParameter("currentPage"));
			int photoCount = Integer.parseInt(request.getParameter("listCnt"));
			String deptPath = ezOrganService.getDeptPath(deptId, tenantId);
			deptPath = "everyone,top,Top," + deptPath + "," + userId;
			JSONObject data = new JSONObject();

			// 회사의 포토게시판의 포틀릿 정보 가져오기
			PortletInfoVO portlet = ezNewPortalService.getCompanyPortletInfo(companyId, tenantId, portletId, portletLang);
			String boardId = portlet.getPortletBoardId();
			data.put("boardId", boardId);
			data.put("portletName", portlet.getPortletName());

			if (boardId == null) {
				data.put("access", false);
				data.put("photoBoardList", null);
				data.put("totalCnt", 0);
				data.put("currentPage", 1);
			} else {
				// 게시판 권한 체크
				boolean accessCheck = boardAuthCheck(boardId, deptPath, tenantId, companyId, deptId, userId, rollInfo);
				if (!accessCheck) {
					data.put("access", "false");
					data.put("photoBoardList", null);
					data.put("totalCnt", 0);
					data.put("currentPage", 1);
				} else {
					// 권한이 true이면 boardList불러오기
					int totalCnt = ezNewPortalService.getPhotoBoardPortletTotalCnt(tenantId, boardId, info.getOffSet());
					int totalPages  = (totalCnt + photoCount - 1) / photoCount;
					currentPage = currentPage > totalPages ? totalPages : currentPage;
					currentPage = currentPage == 0         ? 1          : currentPage;
					int startRow  = (currentPage - 1) * photoCount;

					List<BoardItemVO> photoBoardList = ezNewPortalService.getPhotoBoardPortletInfo(tenantId, boardId, startRow, photoCount, info.getOffSet());
					data.put("access", "true");
					data.put("photoBoardList", photoBoardList);
					data.put("totalCnt", totalCnt);
					data.put("currentPage", currentPage);
				}
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("MOBILE G/W getPhotoBoardPortlet ended.");
		return result;
	}

	// 모바일 받은편지함 포틀릿 조회
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezPortal/portlets/receivedMail", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getReceivedMainPortlet(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W getReceivedMainPortlet started.");
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();

		String password = jspw;
		String userId = request.getParameter("userId");

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			Locale locale = info.getLocale();

			// start

			String folderPath = "INBOX";
			IMAPAccess ia = null;

			try {
				// get user credentials

				String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
				String userAccount = userId + "@" + domainName;

				logger.debug("userEmail=" + userAccount);

				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"), userAccount, password, egovMessageSource, locale, 40 * 1000,
						20 * 1000, ezEmailUtil);

				long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();

				double mailboxUsage = storageUsageAndLimit[0]; // in KBs
				double mailboxQuota = storageUsageAndLimit[1]; // in KBs

				// 재은 수정
				String[] mailUse = ezEmailUtil.getMailUsage(mailboxUsage, mailboxQuota);
				String mailPercent = "";
				String mailboxDetail = "";
				String mailboxQuotaStr = "";

				if (mailUse != null) {
					mailPercent = mailUse[0];
					mailboxDetail = mailUse[1];
					mailboxQuotaStr = mailUse[2];
				}

				logger.debug("mailPercent=" + mailPercent + ",mailboxDetail=" + mailboxDetail + ",mailboxQuotaStr=" + mailboxQuotaStr);

				Folder folder = ia.getFolder(folderPath);

				int unreadCount = 0;
				int totalCount = 0;

				// set mailCount
				int mailCount = Integer.parseInt(request.getParameter("mailCount") != null ? request.getParameter("mailCount") : "4");
				int currPage = Integer.parseInt(request.getParameter("currPage") != null ? request.getParameter("currPage") : "0");
				int startRow = (currPage - 1) * mailCount;

				List<Map<Object, String>> mailList = new ArrayList<Map<Object, String>>();
				String useRDBOnlyMailList = ezCommonService.getTenantConfig("useRDBOnlyMailList", info.getTenantId());

				if (useRDBOnlyMailList.equals("YES")) {
					Map<String, Object> extraMap = new HashMap<String, Object>();
					List<Map<String, String>> messageList = ezEmailUtil.searchFolderUsingRDBOnly(userAccount, folderPath, null, null, null, new Date(), false,
							false, false, "receivedDate", false, startRow, mailCount, false, extraMap, info.getTenantId(), false, "");

					unreadCount = (int)extraMap.get("mailboxUnreadMailCount");
					totalCount = (int)extraMap.get("totalCount");

					for (Map<String, String> mailInfo : messageList) {
						// href
						String href = mailInfo.get("MAIL_ID");

						// received date
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
						Date receivedDate = sdf.parse(mailInfo.get("MAIL_DATE"));
						sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
						String receivedDateStr = sdf.format(receivedDate);

						receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, info.getOffSet(), false);

						// sender
						String sender = ezEmailUtil.getNameOrAddress(mailInfo.get("SENDER"));

						// subject
						String subject =  mailInfo.get("SUBJECT");
						subject = (subject != null) ? subject : "";

//						if ("1".equals(mailInfo.get("MAIL_IS_SECURED"))) {
//							subject = "<img src=\"/images/email/secureMail/security_icon.gif\" width=\"15px\" />" + subject;
//						}

						String securedMail = String.valueOf("1".equals(mailInfo.get("MAIL_IS_SECURED")));

						int readFlag = "1".equals(mailInfo.get("MAIL_IS_SEEN")) ? 1 : 0;
						String readClass = "";

						if (readFlag == 0) {
							readClass = "mail_close";
						} else {
							readClass = "mail_open";
						}

						Map<Object, String> mailMap = new HashMap<Object, String>();
						mailMap.put("href", href);
						mailMap.put("receivedDateStr", receivedDateStr);
						mailMap.put("sender", sender);
						mailMap.put("subject", subject);
						mailMap.put("readClass", readClass);
						mailMap.put("securedMail", securedMail);

						mailList.add(mailMap);
					}
				} else {
					// Folder.getUnreadMessageCount() 메소드 동작 방식이 folder가 open 상태일 때는 읽지 않은 메일 갯수를 IMAP search 명령을
					// 통해 비효율적으로 구하는 관계로 folder open 전에 호출함. open 상태가 아닐 때는 IMAP status 명령을 사용하며 status 명령이
					// 더 효율적임.
					unreadCount = ia.getUnreadCount(folderPath);
					totalCount = ia.getTotalCount(folderPath);
					folder.open(Folder.READ_ONLY);

					Message[] messages = ezEmailUtil.searchFolder(ia, userAccount, folder, "", "", null, new Date(), false, false, false, "receivedDate", false, startRow, mailCount, false, null, info.getTenantId(), "");

					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
					sdf.setTimeZone(TimeZone.getTimeZone("GMT"));

					int messagesLength = messages.length;

					for (int i = 0; i < messagesLength; i++) {
						Message message = messages[i];
						UIDFolder uidFolder = (UIDFolder) message.getFolder();

						// href
						String href = "INBOX/" + uidFolder.getUID(message);

						// received date
						Date receivedDate = message.getReceivedDate();
						String receivedDateStr = sdf.format(receivedDate);
						receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, info.getOffSet(), false);

						// sender
						String sender = ezEmailUtil.getFromNameOrAddressOfMessage(message);

						// subject
						String subject = ezEmailUtil.getSubject(message);
						subject = (subject != null) ? subject : "";

//						if (ezEmailUtil.hasSecureMailFlag(message)) {
//							subject = "<img src=\"/images/email/secureMail/security_icon.gif\" width=\"15px\" />" + subject;
//						}

						String securedMail = String.valueOf("1".equals(ezEmailUtil.hasSecureMailFlag(message)));

						int readFlag = message.isSet(Flags.Flag.SEEN) ? 1 : 0;
						String readClass = "";

						if (readFlag == 0) {
							readClass = "mail_close";
						} else {
							readClass = "mail_open";
						}

						Map<Object, String> mailMap = new HashMap<Object, String>();
						mailMap.put("href", href);
						mailMap.put("receivedDateStr", receivedDateStr);
						mailMap.put("sender", sender);
						mailMap.put("subject", subject);
						mailMap.put("readClass", readClass);
						mailMap.put("securedMail", securedMail);

						mailList.add(mailMap);
					}
				}

				data.put("mailList", mailList);
				data.put("unreadCount", unreadCount);
				data.put("mailboxQuotaStr", mailboxQuotaStr);
				data.put("mailboxDetail", mailboxDetail);
				data.put("mailPercent", mailPercent);
				data.put("currPage", currPage);
				data.put("totalCount", totalCount);

			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			} finally {
				if (ia != null) {
					ia.close();
				}
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("MOBILE G/W getReceivedMainPortlet ended.");
		return result;
	}

	// 모바일 일정 포틀릿 조회  
	@RequestMapping(value = "/mobile/ezportal/portlets/schedulePortlet", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getSchedulePortlet(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W getSchedulePortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));

			String offset = info.getOffSet();
			String offSetMin = commonUtil.getMinuteUTC(offset);

			String startDate = (request.getParameter("STARTDATE") == null || request.getParameter("STARTDATE").equals("")) ? request.getParameter("selectDate") : request.getParameter("STARTDATE");
			String endDate = (request.getParameter("ENDDATE") == null || request.getParameter("ENDDATE").equals("")) ? request.getParameter("selectDate") : request.getParameter("ENDDATE");
			String idList = (request.getParameter("IDLIST") == null || request.getParameter("IDLIST").equals("")) ? "T" : request.getParameter("IDLIST");

			String indiList = "";
			String pidList = "";
			String pidListSub = "";
			String indiListSub = "";

			if(startDate != null && !startDate.equals("")) {
				String[] sDate = startDate.split("-");
				String sMon = (sDate[1].length() == 1 ? "0" + sDate[1] : sDate[1]);
				String sDay = (sDate[2].length() == 1 ? "0" + sDate[2] : sDate[2]);

				startDate = sDate[0] + "-" + sMon + "-" + sDay + " 00:00:00";
			}

			if(endDate != null && !endDate.equals("")) {
				String[] eDate = endDate.split("-");
				String eMon = (eDate[1].length() == 1 ? "0" + eDate[1] : eDate[1]);
				String eDay = (eDate[2].length() == 1 ? "0" + eDate[2] : eDate[2]);

				endDate = eDate[0] + "-" + eMon + "-" + eDay  + " 23:59:59";
			}

			String utcStartTime = commonUtil.getDateStringInUTC(startDate, offset, true);
			String utcEndTime = commonUtil.getDateStringInUTC(endDate, offset, true);

			String lang = info.getPrimary();
			int tenantId = info.getTenantId();
			String companyId = request.getParameter("companyId");
			String deptId = info.getDeptId();
			//2020-02-24 김정언
			String useAnnualScheduleYN = ezCommonService.getTenantConfig("useAnnualScheduleYN", tenantId);

			List<ScheduleSecretaryVO> tList = ezScheduleService.getPublicScheduleSec(userId, lang, tenantId ,companyId);
			List<ScheduleDeptVO> dList = ezScheduleService.getPublicScheduleDept(userId, lang, tenantId ,companyId);
			List<ScheduleCumulerVO> cList = ezScheduleService.getPublicScheduleCumuler(userId, lang, tenantId, companyId);
			List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(userId, info.getTenantId() ,companyId);

			if (idList == null) {
				idList = "";
			}

			//2018-06-08 구해안 T인 경우를 제외하고 나머지는 id값 그대로 가공해서 넘기기
			if (idList.equals("T") || idList.equals("")) {
				indiList = "'" + userId + "'";

				if(tList != null && tList.size()>0){
					for (int i = 0; i < tList.size(); i++) {
						if (i == 0) {
							indiListSub += ",";
						}
						ScheduleSecretaryVO data = tList.get(i);
						indiListSub += "\'" + data.getSecId()+ "\',";
					}
				}

				pidList = "'" + deptId + "'," + "'" + companyId + "'";


				if(dList != null && dList.size()>0){
					for (int i = 0; i < dList.size(); i++) {
						if(tList == null || tList.size()<=0){
							if (i == 0) {
								pidListSub += ",";
							}
						}
						ScheduleDeptVO data = dList.get(i);
						pidListSub += "\'" + data.getDeptId()+ "\',";
					}
				}

				if(cList != null && cList.size()>0 ){
					for (int i = 0; i < cList.size(); i++) {
						if(dList == null || dList.size()<=0){
							if (i == 0) {
								pidListSub += ",";
							}
						}
						ScheduleCumulerVO data = cList.get(i);
						pidListSub += "\'" + data.getDeptId()+ "\',";
					}
				}

				for (int i = 0; i < gList.size(); i++) {
					if((dList == null || dList.size()<=0) && (cList == null || cList.size()<=0)){
						if (i == 0) {
							pidListSub += ",";
						}
					}
					ScheduleGroupListVO data = gList.get(i);
					pidListSub += "\'" + data.getGroupId() + "\',";
						
						/*if (i != gList.size()-1) {
							pidListSub += ",";
						}*/
				}

				if(indiListSub == null || indiListSub.equals("")){
					indiListSub = ",\'\'";
				}else{
					indiListSub = indiListSub.substring(0, indiListSub.length()-1);
				}

				indiList += indiListSub;

				if(pidListSub == null || pidListSub.equals("")){
					pidListSub = ",\'\'";
				}else{
					pidListSub = pidListSub.substring(0, pidListSub.length()-1);
				}

				if (pidList != null && pidListSub != null && pidListSub.substring(0,1) != ",") {
					pidList += ",\'\'";
				}

				pidList += pidListSub;

			} else if(idList.equals("chkAllFalse")) {
				indiList = "";
				pidList = "\'\'";
			} else if (idList.equals("P")) {
				indiList = "'" + userId + "'";
				pidList = "";
			}else {
				pidList = idList;
			}

			List<ScheduleInfoVO> sList = ezScheduleService.getScheduleList(indiList, pidList, "", utcStartTime, utcEndTime, startDate, endDate, offSetMin, "", "", "", tenantId, companyId, userId, deptId, useAnnualScheduleYN);

			// 구글연동 일정 가져오기(포탈 일정포틀릿)
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			String useGoogleCalendar = ezCommonService.getTenantConfig("useGoogleCalendar", userInfo.getTenantId());
			if(useGoogleCalendar.equals("YES")) {
				List<ScheduleInfoVO> googleList = googleService.getGoogleScheduleList(startDate, endDate, "", userInfo, userInfo.getId(), "member", userInfo.getDisplayName());
				sList.addAll(googleList);
			}

			Collections.sort(sList, new EzScheduleCompareUtil());
			/* 페이징 처리
			int listCnt = Integer.parseInt(request.getParameter("listCnt"));
			int currentPage = Integer.parseInt(request.getParameter("currentPage"));
			int totalCnt = sList.size();
			int startRow = (currentPage - 1) * listCnt;
			int endRow = Math.min(totalCnt, startRow + listCnt);
			List<ScheduleInfoVO> resultList = null;
			resultList = sList.subList(startRow, endRow);
			*/
			logger.debug("sList : " + sList.toString());
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", sList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("MOBILE G/W getSchedulePortlet ended.");
		return result;
	}

	@RequestMapping(value = "/mobile/ezPortal/portlets/customBoardPortlet", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCustomBoardPortlet(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W getCustomBoardPortlet started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String fileName = request.getParameter("fileName");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);
			String companyId = request.getParameter("companyId");
			String deptId = info.getDeptID();
			String rollInfo = info.getRollInfo();
			int tenantId = info.getTenantId();
			int portletId = Integer.parseInt(request.getParameter("portletId"));
			int itemCount = Integer.parseInt(request.getParameter("photoCount"));
			int currentPage = commonUtil.isIntNumber(request.getParameter("currentPage"),1);
			String portletLang = info.getLang();
			String deptPath = ezOrganService.getDeptPath(deptId, tenantId);
			deptPath = "everyone,top,Top," + deptPath + "," + userId;
			JSONObject data = new JSONObject();

			// 회사의 포틀릿 정보 가져오기
			PortletInfoVO portlet = ezNewPortalService.getCompanyPortletInfo(companyId, tenantId, portletId, portletLang);
			String boardId = portlet.getPortletBoardId();
			if (boardId == null || boardId.isEmpty()) {
				data.put("boardId", "");
			} else {
				data.put("boardId", boardId);
				data.put("portletName", portlet.getPortletName());
	
				// 게시판 권한 체크
				boolean accessCheck = boardAuthCheck(boardId, deptPath, tenantId, companyId, deptId, userId, rollInfo);
				if (!accessCheck) {
					data.put("access", "false");
					data.put("boardList", null);
					data.put("boardListTotalCnt", 0);
					data.put("currentPage", 1);
				} else {
					MBoardInfoVO boardInfo = mBoardService.getBoardProperty(boardId, commonUtil.getPrimaryData(info.getLang(), info.getTenantId()), info.getTenantId(), userId);
					boardInfo = mBoardService.getBoardInfo(boardInfo, info.getRollInfo(), deptPath, mOptionService.commonInfo(serverName, userId));
					String guBun = boardInfo.getGuBun();
					// Q&A 의 일반 유저일 경우 일반 게시판과 다른 리스트
					boolean isQnANormal = "5".equals(guBun);
					if (isQnANormal) {
						// 관리자가 아니면 Q&A 게시판 로직으로 변경
						isQnANormal = !ezBoardService.isBoardAdmin(boardId, userId, deptId, companyId, tenantId, rollInfo);
					}
	
					// 권한이 true이면 boardList불러오기
					int boardListTotalCnt = ezNewPortalService.getBoardPortletTotalCnt(userId, tenantId, boardId, companyId, info.getOffset(), isQnANormal);
	
					int totalPages  = (boardListTotalCnt + itemCount - 1) / itemCount;
					currentPage = currentPage > totalPages ? totalPages : currentPage;
					currentPage = currentPage == 0         ? 1          : currentPage;
					int startRow  = (currentPage - 1) * itemCount;
	
					List<BoardListVO> boardList = ezNewPortalService.getBoardPortletInfo(userId, tenantId, boardId, itemCount, companyId, info.getOffset(), isQnANormal, startRow);
	
					// 리스트 개수로 utc time 적용시키기
					int boardListCount = boardList.size();
					for (int i = 0; i < boardListCount; i++) {
						BoardListVO boardListVO = boardList.get(i);
						String writeDate = boardListVO.getStartDate();
	
						boardListVO.setStartDate(commonUtil.getDateStringInUTC(writeDate, info.getOffset(), false));
						if (StringUtils.isNotBlank(boardListVO.getAttachments()) && "1".equals(boardListVO.getAttachments())) {
							Optional<BoardAttachVO> boardAttach = ezBoardService.getBoardAttachByName(boardListVO.getItemID(), fileName, tenantId);
							boardListVO.setThumbnail(boardAttach.map(BoardAttachVO::getFilePath).orElse(""));
						}
					}
					
					data.put("access", "true");
					data.put("boardList", boardList);
					data.put("boardInfo", boardInfo);
					data.put("boardListTotalCnt", boardListTotalCnt);
					data.put("currentPage", currentPage);
				}
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("MOBILE G/W getCustomBoardPortlet ended.");

		return result;
	}
	
	// 자원관리 포틀릿 > 유저설정 자원 목록 가져오기
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezPortal/portlets/user/resource/list", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getUserResourceList(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W getUserResourceList started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String companyId = request.getParameter("companyId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);
			
			List<ResBrdVO> resources = ezResourceService.getUserResourceList(userId, companyId, info.getDeptID(), info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", resources);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("MOBILE G/W getUserResourceList ended.");

		return result;
	}
	
	// 자원관리 포틀릿 > 자원별 예약 자원 목록 가져오기
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezPortal/portlets/resource/schedule/list", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getResourcePortlet(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W getResourcePortlet started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String date = request.getParameter("date");
			String brdId = request.getParameter("brdId");
			String companyId = request.getParameter("companyId");
			int currentPage = Integer.parseInt(request.getParameter("currentPage"));
			int listCnt = Integer.parseInt(request.getParameter("listCnt"));
			LoginVO info = commonUtil.getUserForGw(userId, serverName);

			if(date == null) {
				JSONObject err = new JSONObject();
				return err;
			}
			
			List<ResBrdVO> resScheList = ezResourceService.getResourceScheduleList(brdId, date, currentPage, listCnt, info.getTenantId(), companyId, info.getOffset(), info.getLang());

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", resScheList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("MOBILE G/W getResourcePortlet ended.");

		return result;
	}
	
	// 게시판 권한 체크
	public boolean boardAuthCheck(String boardId, String deptPath, int tenantId, String companyId, String deptId, String userId, String rollInfo) throws Exception {
		logger.debug("boardAuthCheck started");
		boolean authCheck = false;
		String[] deptPathSplit = deptPath.split(",");
		int deptPathCount = deptPathSplit.length;

		try {
			if (ezBoardService.isBoardAdmin(boardId, userId, deptId, companyId, tenantId, rollInfo)) {
				authCheck = true;
			} else {
				for (int i = 0; i < deptPathCount; i++) {
					String deptPathId = deptPathSplit[i];
					BoardPropertyVO authInfo = ezBoardAdminService.getACL(boardId, deptPathId, tenantId);

					if (authInfo == null) {

					} else {
						String access = authInfo.getAccess_();
						String deptAcl = authInfo.getBoardGroupACL();

						if (i == deptPathCount - 1) {
							deptAcl = "Y";
						}

						if (access.equals("1")) {
							if (deptAcl.equals("Y")) {
								authCheck = true;
							}

							if (authInfo.getAccessID().equals(deptId)) {
								authCheck = true;
							}
						} else if (access.equals("0") && deptAcl.equals("Y")) {
							authCheck = false;
						}
					}
				}
			}
		} catch (Exception e) {
			logger.debug("boardAuthCheck error");
		}

		logger.debug("authCheck : " + authCheck);
		logger.debug("boardAuthCheck ended");
		return authCheck;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezPortal/users/menuList", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject menuList(HttpServletRequest request) throws Exception {
		logger.debug("menuList Start");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			
			Map<String, Object> userInfoMap = new HashMap<>();
			userInfoMap.put("companyId", request.getParameter("companyId"));
			userInfoMap.put("tenantId", request.getParameter("tenantId"));
			userInfoMap.put("langType", request.getParameter("langType"));
			userInfoMap.put("userId", request.getParameter("userId"));
			
			MCommonVO info = mOptionService.commonInfo(serverName, (String) userInfoMap.get("userId"));
			userInfoMap.put("deptId", info.getDeptId());
			
			Map<String, Object> dataObject = new HashMap<String, Object>();
			List<MenuInfoVO> mobileMenuList = mOptionService.getMobileMenuList(userInfoMap);
			dataObject.put("mobileMenuList", mobileMenuList);
	        
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", dataObject);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("menuList End");
		
		return result;
	}
	
	@RequestMapping(value = "/mobile/ezPortal/logos/companies/{companyId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyLogo(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		logger.debug("MOBILE G/W getCompanyLogo Start");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = new LoginVO();
			int tenantId = 0;

			if (userId == null) {
				tenantId = ezNewPortalService.getTnenantIdByServerName(serverName);
			} else {
				userInfo = commonUtil.getUserForGw(userId, serverName);
				tenantId = userInfo.getTenantId();
				result.put("userCompany", userInfo.getCompanyID());
				result.put("lang", userInfo.getLang());
			}

			String portalLogoUrl = "";
			boolean portalLogoUrlDefault = true;

			//로그인 가져오기
			if (companyId != null) {
				portalLogoUrl = ezNewPortalService.getPortalLogoInfo(companyId, tenantId, "P");
			}

			if (portalLogoUrl == null || portalLogoUrl.equals("")) {
				portalLogoUrl = "/files/upload_portal/Top/Logo/logo.png";
				portalLogoUrlDefault = true;
			} else {
				portalLogoUrl = commonUtil.getUploadPath("upload_newPortal.ROOT", tenantId) + commonUtil.separator + "uploadFile" + commonUtil.separator + portalLogoUrl;
				portalLogoUrlDefault = false;
			}

			String returnUrl = null;
			
			if (portalLogoUrlDefault == false) {
				returnUrl = portalLogoUrl;
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", returnUrl);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("MOBILE G/W getCompanyLogo ended.");
		return result;
	}


	@RequestMapping(value = "/mobile/ezPortal/mail2Cnt/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject portalMail2Cnt(@PathVariable String userId, HttpServletRequest request) throws Exception {

		logger.debug("MOBILE G/W portalMail2Cnt started.");
		JSONObject result = new JSONObject();

		try {
			String mailAccess = request.getParameter("mail");

			Map<String, Object> dataObject = new HashMap<String, Object>();

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);

			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);

			MOptionVO opt = mOptionService.optionInfo(userId, info.getTenantId());
			if (opt != null && opt.getLang() != null){
				locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(opt.getLang()));
			} else {
				locale = new Locale(commonUtil.getTwoLetterLangFromLangNum("1"));
			}

			//안읽은메일 리스트 카운트
			int mailCnt = 0;

			if ("true".equals(mailAccess)) {
				mailCnt = mEmailService.getMainMailUnreadCount(info, locale);
				logger.debug("MOBILE G/W portalMail2Cnt mailCnt = " + mailCnt);
			}

			dataObject.put("mailCnt", mailCnt + "");

			result.put("status", "ok");
			result.put("data", dataObject);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			result.put("status", "error");
			result.put("data", "");
		}

		logger.debug("MOBILE G/W portalMail2Cnt ended.");

		return result;

	}
}
