package egovframework.ezMobile.ezSchedule.web;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import org.apache.commons.lang3.StringUtils;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.api.services.calendar.model.Event;
import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.type.NotiPlatform;
import egovframework.ezEKP.ezPersonal.type.NotiType;
import egovframework.ezEKP.ezSchedule.service.EzScheduleGoogleService;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.service.impl.EzScheduleCompareUtil;
import egovframework.ezEKP.ezSchedule.vo.AttachListVO;
import egovframework.ezEKP.ezSchedule.vo.AttendantListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheDeptVO;
import egovframework.ezEKP.ezSchedule.vo.ScheSecretaryVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleCumulerVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleMailConfigVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleOwnerInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleReceiveListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleSecretaryVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleDeptVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.ezMobile.ezResource.service.MResourceService;
import egovframework.ezMobile.ezResource.vo.ResScheGetHolidayVO;
import egovframework.ezMobile.ezSchedule.service.MScheduleService;
import egovframework.ezMobile.ezSchedule.vo.MScheduleInfoVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

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
@SuppressWarnings("unchecked")
@RestController
public class MScheduleGWController extends EzFileMngUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(MScheduleGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="EzScheduleService")
	private EzScheduleService ezScheduleService;
		
	@Resource(name="MScheduleService")
	private MScheduleService mScheduleService;
		
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzScheduleGoogleService googleService;
	
	@Autowired
	private EzPersonalService ezPersonalService;
	
	@Resource(name="MResourceService")
	private MResourceService mResourceService;

	@Autowired
	private EzEmailUtil ezEmailUtil;
		
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 리스트 (월간,주간,일정검색)
	 */	
	@RequestMapping(value="/mobile/ezschedule/list/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleList(@PathVariable String userId, HttpServletRequest request){
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/list/users/{userId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String searchTitle = request.getParameter("searchTitle");
			String searchLocation = request.getParameter("searchLocation");
			String searchAll = request.getParameter("searchAll");
			// API에서 쓰이는 파라미터로, 모바일에서는 사용되지 않는 듯
//			String idList = request.getParameter("idList");
//			String pidList = request.getParameter("pidList") != null ? request.getParameter("pidList") : "";

			/* 2023-10-11 기민혁 사용자 일정검색 요소 추가 */
			String chk_usersearch = request.getParameter("chk_usersearch");
			String SuserId = request.getParameter("SuserId");
			String SuserName = request.getParameter("SuserName");
			String SuserDeptId = request.getParameter("SuserDeptId");
			String SuserCompanyId = request.getParameter("SuserCompanyId");
			String SuserDeptName = request.getParameter("SuserDeptName");

			logger.debug("searchTitle: " + searchTitle);
			
			if (startDate != null && !startDate.equals("")) {
				String[] sDate = startDate.split("-");
				String sMon = (sDate[1].length() == 1 ? "0" + sDate[1] : sDate[1]);
				String sDay = (sDate[2].length() == 1 ? "0" + sDate[2] : sDate[2]);
				
				startDate = sDate[0] + "-" + sMon + "-" + sDay + " 00:00:00";
			} else {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Calendar cal = Calendar.getInstance();
				
				startDate = sdf.format(cal.getTime()) + " 00:00:00";
			}
			
			if (endDate != null && !endDate.equals("")) {
				String[] eDate = endDate.split("-");
				String eMon = (eDate[1].length() == 1 ? "0" + eDate[1] : eDate[1]);
				String eDay = (eDate[2].length() == 1 ? "0" + eDate[2] : eDate[2]);
				
				endDate = eDate[0] + "-" + eMon + "-" + eDay  + " 23:59:59";
			} else {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Calendar cal = Calendar.getInstance();
				
				endDate = sdf.format(cal.getTime()) + " 23:59:59";
			}
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			LoginVO loginInfo = new LoginVO();
			loginInfo.setId(info.getUserId());
			loginInfo.setDeptID(info.getDeptId());
			loginInfo.setCompanyID(info.getCompanyId());
			loginInfo.setTenantId(info.getTenantId());
			loginInfo.setPrimary(info.getPrimary());
			loginInfo.setOffset(info.getOffSet());

			List<ScheduleInfoVO> sList ;

			if(chk_usersearch !=null && chk_usersearch.equals("userSearch")) {
				if(SuserId == null || SuserId.isEmpty()){
					info.setUserId("");
					info.setDeptId("");
					info.setCompanyId("");
				}else{
					info.setUserId(SuserId);
					info.setDeptId(SuserDeptId);
					info.setCompanyId(SuserCompanyId);
				}
				
				sList = scheduleUserSearchListData(startDate, endDate, "T", "", commonUtil.getMinuteUTC(info.getOffSet()), loginInfo);
			}else {
				sList = mScheduleService.scheduleList(info, startDate, endDate, searchTitle, searchLocation, searchAll, "");

				String useWorkspaceSchedule = ezCommonService.getTenantConfig("useWorkspaceSchedule", info.getTenantId());
				
				if (useWorkspaceSchedule == null || useWorkspaceSchedule.equals("")) {
					useWorkspaceSchedule = "NO";
				} else if(useWorkspaceSchedule.equalsIgnoreCase("YES")) {
					String workspaceHostUrl = ezCommonService.getTenantConfig("workspaceHostUrlForMobile", info.getTenantId());
					result.put("workspaceHostUrl", workspaceHostUrl);
				}

				String useGoogleCalendar = ezCommonService.getTenantConfig("useGoogleCalendar", info.getTenantId());
				if(useGoogleCalendar.equals("YES")) {
					LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
					userInfo.setDisplayName(info.getUserName());	// 오늘의 일정 > 데이터가 없어서 추가
					List<ScheduleInfoVO> googleList = googleService.getGoogleScheduleList(startDate, endDate, searchTitle, userInfo, userInfo.getId(), "member", userInfo.getDisplayName());
					sList.addAll(googleList);
				}
			}
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", sList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/list/users/{userId}] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 카운트 (월간,주간,일정검색)
	 */
	@RequestMapping(value="/mobile/ezschedule/list-count/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleListCount(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/list-count/users/{userId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String searchTitle = request.getParameter("searchTitle");
			
			if (startDate != null && !startDate.equals("")) {
				String[] sDate = startDate.split("-");
				String sMon = (sDate[1].length() == 1 ? "0" + sDate[1] : sDate[1]);
				String sDay = (sDate[2].length() == 1 ? "0" + sDate[2] : sDate[2]);
				
				startDate = sDate[0] + "-" + sMon + "-" + sDay + " 00:00:00";
			} else {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Calendar cal = Calendar.getInstance();
				
				startDate = sdf.format(cal.getTime()) + " 00:00:00";
			}
			
			if (endDate != null && !endDate.equals("")) {
				String[] eDate = endDate.split("-");
				String eMon = (eDate[1].length() == 1 ? "0" + eDate[1] : eDate[1]);
				String eDay = (eDate[2].length() == 1 ? "0" + eDate[2] : eDate[2]);
				
				endDate = eDate[0] + "-" + eMon + "-" + eDay  + " 23:59:59";
			} else {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Calendar cal = Calendar.getInstance();
				
				endDate = sdf.format(cal.getTime()) + " 23:59:59";
			}
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			List<ScheduleInfoVO> sList = mScheduleService.scheduleList(info, startDate, endDate, searchTitle, "", "", "");

			String useGoogleCalendar = ezCommonService.getTenantConfig("useGoogleCalendar", info.getTenantId());
			if(useGoogleCalendar.equals("YES")) {
				LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
				List<ScheduleInfoVO> googleList = googleService.getGoogleScheduleList(startDate, endDate, "", userInfo, userInfo.getId(), "member", userInfo.getDisplayName());		
				sList.addAll(googleList);
			}
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", sList.size());
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/list-count/users/{userId}] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 상세데이터
	 */
	@RequestMapping(value="/mobile/ezschedule/schedules/{scheduleId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleDetail(@PathVariable String scheduleId, HttpServletRequest request, Locale locale) throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			JSONObject dataObject = new JSONObject();
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, request.getParameter("userId"));
			
			int tenantId = info.getTenantId();
			String offSetMin = commonUtil.getMinuteUTC(info.getOffSet());
			
			LoginVO userInfo = commonUtil.getUserForGw(request.getParameter("userId"), serverName);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
			MScheduleInfoVO vo = new MScheduleInfoVO();
			String flag = request.getParameter("flag");
			if(flag != null && flag.equals("google")) {
				String s_date = request.getParameter("startDate");
				String e_date = request.getParameter("endDate");
				String googleContent = "";
		        
				Event event = googleService.getGoogleScheduleInfo(scheduleId, userInfo, "", "");
			
				if (event != null) {
					vo.setScheduleId(event.getId());
		    		vo.setOwnerId(userInfo.getId());
		    		vo.setCreatorId(userInfo.getId());
		    		vo.setModifierId(userInfo.getId());
		    		vo.setOwnerName(userInfo.getDisplayName1());
					vo.setCreatorName(userInfo.getDisplayName1());
					vo.setModifierName(userInfo.getDisplayName1());
					vo.setOwnerName2(userInfo.getDisplayName2());
					vo.setCreatorName2(userInfo.getDisplayName2());
					vo.setModifierName2(userInfo.getDisplayName2());
		    		vo.setScheduleType("9");
		    		vo.setScheduleFlag("google");
		    		//vo.setCompanyid(userInfo.getCompanyID());
		    		vo.setTitle(event.getSummary() != null ? event.getSummary() : "No Title");
		    		vo.setImportance("2");
		    		vo.setLocation(event.getLocation());
		    		
		    		vo.setCreateDate(sdf.format(event.getCreated().getValue()));
		    		vo.setModifyDate(sdf.format(event.getUpdated().getValue()));

		    		vo.setIsPublic(event.getVisibility() != null && (event.getVisibility().equals("private") || event.getVisibility().equals("confidential")) ? "N" : "Y");
		    		
		    		vo.setStartDate(s_date);
					vo.setEndDate(e_date);
					
		    		boolean isAllday = (event.getStart().getDateTime() == null) ? true : false;
		    		// 반복일정인 경우
		    		if (event.getRecurrence() != null){
		    			vo.setDateType("3");
		    		} else {
		    			if (isAllday) {
		    				vo.setDateType("2");
		    			}
		    			else {
		    				vo.setDateType("1");
		    			}
		    		}
		    		
		    		googleContent = event.getDescription() != null ? event.getDescription() : "";
		    		vo.setContent(googleContent);
				} else {
					result.put("status", "error");
					result.put("code", 1);
					result.put("data", "");
				}
				
				dataObject.put("scheduleInfo", vo);
			} else if (null != scheduleId && scheduleId.startsWith("collaboration:")) {
				// 협업 일정 정보
				String selectedDate = request.getParameter("selectedDate");
				String cScheduleID = scheduleId.substring(14);
				
				if (null == selectedDate) {
					// 선택일이 없는 경우 일정 리스트 범위를 제한할 수 없기 때문에 Exception 발생 시켜 예외 처리
					throw new NullPointerException("startDate or endDate is Null.");
					
				} else if (selectedDate.length() != 10) {
					// 시작일과 종료일의 형식이 잘못된 경우도 예외 처리.
					throw new IllegalArgumentException("Invalid startDate or endDate value.");
				}
				
				logger.debug("selectedDate: {}, collaboration ScheduleID: {}", selectedDate, cScheduleID);
				
				try {
					// 해당 일자에 맞는 협업의 일정 리스트 API 조회하기
					String workspaceHostUrl = ezCommonService.getTenantConfig("workspaceHostUrl", info.getTenantId());
					String domain = workspaceHostUrl + "/ezWorkspace/api/GroupwareApi/post/scheduleread/";
					String params = "userAccountId=" + URLEncoder.encode(request.getParameter("userId"), "UTF-8")
									+ "&startDate=" + URLEncoder.encode(selectedDate + " 00:00:00", "UTF-8")
									+ "&endDate=" + URLEncoder.encode(selectedDate + " 23:59:59", "UTF-8");
					String workspaceScheduleLists = ezEmailUtil.getWebServiceResult(domain, params);
					
					if (workspaceScheduleLists != null && !workspaceScheduleLists.equals("")) {
						
						JSONParser jsonparser = new JSONParser();
						JSONArray jsonArray = new JSONArray();
						
						try {
							jsonArray = (JSONArray)jsonparser.parse(workspaceScheduleLists);
							
						} catch (ParseException e) {
							// parse 중 에러나 혹은 그 외 에러 발생 시 처리
							logger.debug("ParseException: {}", e.getMessage());
							logger.debug("Invalid JSON format. received string: {}", workspaceScheduleLists);
							
							result.put("status", "error");
							result.put("code", 1);
							result.put("data", "parse Error. returned data: " + workspaceScheduleLists);
							
							return result;
							
						} catch (Exception e) {
							logger.debug("Exception: {}", e.getMessage());
							logger.debug("received string: {}", workspaceScheduleLists);
							
							result.put("status", "error");
							result.put("code", 1);
							result.put("data", "");
							
							return result;
						}
						
						// for문 돌려서 cScheduleID와 일치하는 일정 정보 반환하기
						for (Object obj : jsonArray) {
							JSONObject jsonobject = (JSONObject) obj;
							
							logger.debug("collaboration scheduleID: {}", jsonobject.get("ItemId").toString());
							
							// 하나의 날짜에는 하나의 ItemId만 존재함. (반복 일정의 경우 여러 날짜에 하나의 ItemId가 존재 가능) 
							if (null != jsonobject.get("ItemId") && jsonobject.get("ItemId").toString().equals(cScheduleID)) {
								
								vo.setScheduleId("collaboration:" + jsonobject.get("ItemId"));
								vo.setParentId("collaboration:" + jsonobject.get("ItemPostId").toString());
								vo.setOwnerId(jsonobject.get("ItemUserAccountId").toString());
								vo.setOwnerName(jsonobject.get("ItemUserName").toString());
								vo.setCreatorName(jsonobject.get("ItemUserName").toString());
								// 협업의 api에 createdate가 없기 때문에 updatedate = createdate로 취급
								vo.setCreateDate(jsonobject.get("ItemUpdateDate").toString().replace("T", " "));
								// 협업의 타입은 4로 고정됨.
								vo.setScheduleType("4");
								vo.setImportance((Integer.parseInt(jsonobject.get("ItemImportance").toString()) + 1) + "");
								// 협업에 없는 기능으로 연구소에서 default Y로 요청함.
								vo.setIsPublic("Y");
								vo.setDateType(jsonobject.get("ItemDateType").toString());
								vo.setStartDate(jsonobject.get("ItemStartDate").toString().replace("T", " "));
								vo.setEndDate(jsonobject.get("ItemEndDate").toString().replace("T", " "));
								vo.setRepetition(jsonobject.get("ItemRepetition").toString());
								vo.setTitle(jsonobject.get("ItemPostTitle").toString());
								vo.setLocation(jsonobject.get("ItemLocation").toString());
								vo.setContent(jsonobject.get("ItemContents").toString());
								vo.setRepeatCount(Integer.parseInt(jsonobject.get("ItemRepeatCount").toString()));
								// 협업에 없는 기능으로 연구소에서 default N로 요청함.
								vo.setShowTop("N");
								
								dataObject.put("scheduleInfo", vo);
							}
						}
					}
				} catch (Exception e) {
					logger.debug("Exception: {}", e.getMessage());
					
					result.put("status", "error");
					result.put("code", 1);
					result.put("data", "");
					
					return result;
				}
			} else {
				//일정 정보
				vo = mScheduleService.scheduleInfo(scheduleId, offSetMin, tenantId);
				dataObject.put("scheduleInfo", vo);
			
				String itemID = vo.getContentPath();
				logger.debug("itemID: " + itemID);
				String type = "SCHEDULECONTENT";
				String realPath = commonUtil.getRealPath(request);
				String scheme = "http://";
				
				if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
					scheme = "https://";
				}
		
				String mhtToHtml = ezCommonService.getMHTtoHTML(type, itemID, info.getTenantId(), realPath, request, locale, scheme);
				logger.debug("mhtToHtml: " + mhtToHtml);			
				Document doc = Jsoup.parse(mhtToHtml);	        
				Elements elems = doc.select("[src]");
				
				if (elems.size() > 0) {
					for (Element element : elems) {
						element.attr("src", "/mobile/ezCommon/mFileDown.do?filePath=" + element.attr("src") + "&fileName=*.INLINE.*");
					}
				}
				
				String bodyHTML = doc.getElementsByTag("BODY").html();
				vo.setContent(bodyHTML);
				
				
				//자원예약 정보
				int resourceCnt = ezScheduleService.getResourceCount(scheduleId, tenantId);
				
				if (resourceCnt != 0) {
					dataObject.put("resourceCnt", resourceCnt + "");
				} 
				
				//참석자 정보
				if (vo.getHasAttendant().equals("Y")) {
					String parentID = (vo.getParentId().equals("0") ? scheduleId : vo.getParentId());
					List<AttendantListVO> aList = ezScheduleService.getAttendantList(parentID, offSetMin, tenantId, info.getCompanyId());
					
					dataObject.put("attendantList", aList);	        	
				}
	
				//참부파일 정보
				if (vo.getHasAttach().equals("Y")) {        
					String parentID = (vo.getParentId().equals("0") ? scheduleId : vo.getParentId());
					List<AttachListVO> aList = ezScheduleService.getAttachList(parentID, tenantId);
					
					for (AttachListVO avo : aList) {        		
						String fileType = avo.getFileName().substring(avo.getFileName().lastIndexOf(".") + 1).toLowerCase();
						avo.setFileType(fileType);        		
						avo.setFileEncodeName(URLEncoder.encode(avo.getFileName(),"UTF-8"));
						
						String filePath = commonUtil.getUploadPath("upload_schedule.ROOT", info.getTenantId()) + avo.getFilePath();
						avo.setFilePath(URLEncoder.encode(filePath, "UTF-8"));
						String fileSize = commonUtil.byteCalculation(Long.toString(avo.getFileSize()));
						avo.setFileTranSize(fileSize);
					}
					
					dataObject.put("attachList", aList);
					
					// 20180824 조진호 - 모바일 viewerflag 값 추가
					String useMobileViewer = ezCommonService.getTenantConfig("useMobileViewer", info.getTenantId());
					dataObject.put("useMobileViewer", useMobileViewer);
				}

				//비서 권한 부여
				List<ScheduleSecretaryVO> tList = ezScheduleService.getPublicScheduleSec(userInfo.getId(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getCompanyID());

				String chkSecretary = "N";
				for (ScheduleSecretaryVO ssvo : tList) {
					if (ssvo.getSecId().equals(vo.getOwnerId())) {
						chkSecretary = "Y";
					}
				}
				dataObject.put("chkSecretary", chkSecretary);

				// 임원일정 수정/삭제 가능 여부
				String usage = "Y";
				if (!vo.getOwnerId().equals(userInfo.getId())) {
					usage = ezScheduleService.checkExecutiveUsage(vo.getOwnerId(), userInfo.getCompanyID(), userInfo.getTenantId()) != null ? ezScheduleService.checkExecutiveUsage(vo.getOwnerId(), userInfo.getCompanyID(), userInfo.getTenantId()) : "Y";
				}
				dataObject.put("usage", usage);
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
		
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 첨부파일 리스트
	 */
	@RequestMapping(value="/mobile/ezschedule/schedules/{scheduleId}/attach-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleAttachList(@PathVariable String scheduleId, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}/attach-list] started.");
		
		JSONObject result = new JSONObject();
		
		try {			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, request.getParameter("userId"));
			
			List<AttachListVO> aList = ezScheduleService.getAttachList(scheduleId, info.getTenantId());
        	
        	for (AttachListVO avo : aList) {        		
        		String fileType = avo.getFileName().substring(avo.getFileName().lastIndexOf(".") + 1).toLowerCase();
        		avo.setFileType(fileType);        		
        		avo.setFileEncodeName(URLEncoder.encode(avo.getFileName(),"UTF-8"));
        		
        		String filePath = commonUtil.getUploadPath("upload_schedule.ROOT", info.getTenantId());
        		avo.setFilePath(URLEncoder.encode(filePath, "UTF-8"));
        		
        		String fileSize = commonUtil.byteCalculation(Long.toString(avo.getFileSize()));
        		avo.setFileTranSize(fileSize);
        	}
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", aList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			logger.error(e.getMessage(), e);
		} 
		
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}/attach-list] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 종류 리스트 (개인/부서/회사)
	 */
	@RequestMapping(value="/mobile/ezschedule/type-List/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleTypeList(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}/type-List] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			//String lang = info.getLang();	
			String lang = Optional.ofNullable(request.getParameter("langStr")).orElse(info.getLang());
			
			String mode = request.getParameter("mode");
			
			int tenantID = info.getTenantId();
			String companyID = info.getCompanyId();
			
			String primary = commonUtil.getPrimaryData(lang, tenantID);
			Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(lang));
			
			String pCompanyAdmin = "";
			String pDeptAdmin = "";
			
			if (info.getRollInfo().contains("c=1") || info.getRollInfo().contains("k=1")) {
	        	pCompanyAdmin = "Y";
	        	pDeptAdmin = "Y";
	        }
			if (info.getRollInfo().contains("g=1")) {
	        	pDeptAdmin = "Y";
	        }
			if (info.getRollInfo().contains("v=1")) {
				pCompanyAdmin = "Y";
			}

			Map<String, Object> param = new HashMap<>();
			param.put("userID", userId);
			param.put("tenantID", tenantID);
			param.put("companyID", companyID);
			
	        // 현 사용자가 비서인 임원의 일정
	        List<ScheSecretaryVO> sList = ezScheduleService.getPublicExceSchedule(param);
			// 공유 부서 일정
			List<ScheDeptVO> pdList = ezScheduleService.getShareScheduleDept(param);
			// 겸직 부서 일정
			List<ScheDeptVO> cList = ezScheduleService.getAddJobSchedule(param);
			String userType = ezScheduleService.checkExecutiveType(userId, companyID, tenantID); // 임원인지 비서인지 조회
			OrganAuth organAuth = commonUtil.makeOrganAuth(userId, tenantID, info.getDeptId(), info.getJobId());
			
			List<ScheduleOwnerInfoVO> schOwnInfoList = new ArrayList<>();
			
			//개인일정
			ScheduleOwnerInfoVO soi = new ScheduleOwnerInfoVO();
			
    		soi.setScheduleType("1");
    		soi.setOwnerId(userId);
    		soi.setOwnerName(info.getUserName());
    		soi.setOwnerName2(info.getUserName2());
    		
    		schOwnInfoList.add(soi);

			//개인비서
			if (userType.equals("s") || userType.equals("a")) {
				for (ScheSecretaryVO vo : sList) {
					String usage = ezScheduleService.checkExecutiveUsage(vo.getUserID(), companyID, tenantID);
					if (usage == null || usage.equals("Y")) { // 일정관리 > 개인환경설정에 추가된 개인비서일 경우
						ScheduleOwnerInfoVO exceSoiB = new ScheduleOwnerInfoVO();

						exceSoiB.setScheduleType("1");
						exceSoiB.setOwnerId(vo.getUserID());
						exceSoiB.setOwnerName(vo.getUserName());
						exceSoiB.setOwnerName2(vo.getUserName2());

						schOwnInfoList.add(exceSoiB);
					}
				}
			}
			
			if (pDeptAdmin.equals("Y")) {
				//부서일정
				ScheduleOwnerInfoVO deptSoi = new ScheduleOwnerInfoVO();
				
				deptSoi.setScheduleType("2");
				deptSoi.setOwnerId(info.getDeptId());
				deptSoi.setOwnerName(info.getDeptName());
				deptSoi.setOwnerName2(info.getDeptName2());
				
				schOwnInfoList.add(deptSoi);
			}
			
			//겸직일정
			for (ScheDeptVO vo : cList) {
				String deptId = vo.getDeptId();
				if (info.getDeptId().equals(deptId)) {
					continue;
				} else if ("Y".equals(pCompanyAdmin) || organAuth.isAuth(OrganAuth.AdminAuth.DEPT_MANAGER, deptId)){
					ScheduleOwnerInfoVO deptSoi = new ScheduleOwnerInfoVO();
					
					deptSoi.setScheduleType("2");
					deptSoi.setOwnerId(deptId);
					deptSoi.setOwnerName(vo.getDeptName());
					deptSoi.setOwnerName2(vo.getDeptName2());
					
					schOwnInfoList.add(deptSoi);
				}
			}

			//공유일정
			dept_schedule:
			for (ScheDeptVO vo : pdList) {
				for (ScheDeptVO vo2 : cList) {
					if (vo.getDeptId().equals(vo2.getDeptId()) || info.getDeptId().equals(vo.getDeptId())) {
						continue dept_schedule;
					}
				}
				
				ScheduleOwnerInfoVO deptSoi = new ScheduleOwnerInfoVO();
				
				deptSoi.setScheduleType("2");
				deptSoi.setOwnerId(vo.getDeptId());
				deptSoi.setOwnerName(vo.getDeptName());
				deptSoi.setOwnerName2(vo.getDeptName2());
				
				schOwnInfoList.add(deptSoi);
			}
			
			//회사일정
			if (pCompanyAdmin.equals("Y")) {
				ScheduleOwnerInfoVO compSoi = new ScheduleOwnerInfoVO();
				
				compSoi.setScheduleType("3");
				compSoi.setOwnerId(companyID);
				compSoi.setOwnerName(info.getCompanyName());
				compSoi.setOwnerName2(info.getCompanyName2());
				
				schOwnInfoList.add(compSoi);
			}

			// 임원일정
			if (userType.equals("a")) { // 임원 + 비서일 경우
				ScheduleOwnerInfoVO exceSoiA = new ScheduleOwnerInfoVO();
				
				exceSoiA.setScheduleType("10");
				exceSoiA.setOwnerId(userId);
				exceSoiA.setOwnerName(info.getUserName());
				exceSoiA.setOwnerName2(info.getUserName2());
				
				schOwnInfoList.add(exceSoiA);
				
				for (ScheSecretaryVO vo : sList) {
					// 임원일정 사용여부 (Y - 비서가 임원일정 등록가능, N - 비서가 임원일정 등록 불가능)
					String usage = ezScheduleService.checkExecutiveUsage(vo.getUserID(), companyID, tenantID);
					if (("Y").equals(usage)) { // 관리자 > 임원일정관리에 추가된 임원비서일 경우
						ScheduleOwnerInfoVO exceSoiB = new ScheduleOwnerInfoVO();
						
						exceSoiB.setScheduleType("10");
						exceSoiB.setOwnerId(vo.getUserID());
						exceSoiB.setOwnerName(vo.getUserName());
						exceSoiB.setOwnerName2(vo.getUserName2());
						
						schOwnInfoList.add(exceSoiB);
					}
				}

			} else if (userType.equals("u")) { // 임원일 경우
				ScheduleOwnerInfoVO exceSoiA = new ScheduleOwnerInfoVO();
				
				exceSoiA.setScheduleType("10");
				exceSoiA.setOwnerId(userId);
				exceSoiA.setOwnerName(info.getUserName());
				exceSoiA.setOwnerName2(info.getUserName2());
				
				schOwnInfoList.add(exceSoiA);
			} else if (userType.equals("s")) { // 비서일 경우
				for (ScheSecretaryVO vo : sList) {
					// 임원일정 사용여부 (Y - 비서가 임원일정 등록가능, N - 비서가 임원일정 등록 불가능)
					String usage = ezScheduleService.checkExecutiveUsage(vo.getUserID(), companyID, tenantID);
					if (("Y").equals(usage)) { // 관리자 > 임원일정관리에 추가된 임원비서일 경우
						ScheduleOwnerInfoVO exceSoiB = new ScheduleOwnerInfoVO();
						
						exceSoiB.setScheduleType("10");
						exceSoiB.setOwnerId(vo.getUserID());
						exceSoiB.setOwnerName(vo.getUserName());
						exceSoiB.setOwnerName2(vo.getUserName2());
						
						schOwnInfoList.add(exceSoiB);
					}
				}
			}
			
			// 그룹 일정
			List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(userId, tenantID, companyID);
			String offSetMin = commonUtil.getMinuteUTC(info.getOffSet());
			
			for (ScheduleGroupListVO vo : gList) {
            	List<ScheduleGroupListVO> mList = ezScheduleService.getGroupMemberList(vo.getGroupId(), info.getPrimary(), tenantID, offSetMin, companyID);
            	boolean hasWritePermission = false;

                for (ScheduleGroupListVO member : mList) {
                    if (userId.equals(member.getMemberId()) && "Y".equals(member.getWritePermission())) {
                        hasWritePermission = true;
                        break;
                    }
                }

                // 조건: creatorId가 userId와 같거나, hasWritePermission이 true일 때
                if (userId.equals(vo.getCreatorId()) || hasWritePermission) {
                	ScheduleOwnerInfoVO groupSoi = new ScheduleOwnerInfoVO();
                	
                	groupSoi.setScheduleType("7");
                	groupSoi.setOwnerId(vo.getGroupId());
                	// 일정 그룹은 다국어 이름이 없음.
                	groupSoi.setOwnerName(vo.getGroupName());
                	groupSoi.setOwnerName2(vo.getGroupName());
                	
                	schOwnInfoList.add(groupSoi);
        		}
        	}
			
	        
	        ObjectMapper objectMapper = new ObjectMapper();
	        String schOwnInfoListToJson = objectMapper.writeValueAsString(schOwnInfoList);
			
			String chkSchedulePublic = ezCommonService.getTenantConfig("chkSchedulePublic", tenantID);

			// 2023-10-06 임정은 - 모바일 일정관리 > 일정 모아보기 추가
			List<ScheduleGroupListVO> gatherList = ezScheduleService.getMyGatherList(userId, tenantID, companyID);

			result.put("status", "ok");
			result.put("code", 0);			
			
			if ("groupList".equals(mode)) {
				result.put("data", gList);
			} else {
				result.put("data", schOwnInfoListToJson);
			}
			result.put("chkPublic", chkSchedulePublic); // 개인일정 작성시 공개/비공개값 설정가능 여부
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}    	
		
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}/type-List] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 참석자 리스트
	 */
	@RequestMapping(value="/mobile/ezschedule/schedules/{scheduleId}/attendance-List", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleAttendanceList(@PathVariable String scheduleId, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}/attendance-List] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, request.getParameter("userId"));
			
			String offSetMin = commonUtil.getMinuteUTC(info.getOffSet());
			
			List<AttendantListVO> aList = ezScheduleService.getAttendantList(scheduleId, offSetMin, info.getTenantId(), info.getCompanyId());
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", aList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/schedules/{scheduleId}/attendance-List] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 등록
	 */	
	@RequestMapping(value="/mobile/ezschedule/schedules", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject mScheduleInsert(@RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [POST /ezschedule/schedules] started.");
		
		JSONObject result = new JSONObject();
		
		try {
		
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, jsonParam.get("creatorId").toString());
						
			jsonParam.put("creatorName", info.getUserName());
			jsonParam.put("creatorName2", info.getUserName2());
			
			String startDate = jsonParam.get("startDate").toString();
			String endDate = jsonParam.get("endDate").toString();
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	    	Calendar cal = Calendar.getInstance();
	    	cal.setTime(sdf.parse(endDate));
	    	
	    	if (cal.get(Calendar.HOUR) == 0 && cal.get(Calendar.MINUTE) == 0) {        		
	    		cal.add(Calendar.MINUTE, -1);        		
	    		endDate = sdf.format(cal.getTime());
	    	}
	
	    	startDate = sdf.format(sdf.parse(startDate));
	    	endDate = sdf.format(sdf.parse(endDate));
	    	
	    	String utcStartDate = commonUtil.getDateStringInUTC(startDate, info.getOffSet(), true);
	    	String utcEndDate = commonUtil.getDateStringInUTC(endDate, info.getOffSet(), true);	        
	        
	        String realPath = commonUtil.getRealPath(request);
	        Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(info.getLang()));
	        
			String content = jsonParam.get("content").toString();
			content = content.replaceAll("%(?![0-9a-fA-F]{2})", "%25");
			content = content.replaceAll("\\+", "%2B");
			content = URLDecoder.decode(content, "utf-8");
			
			String scheme = "http://";
			if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
				scheme = "https://";
			}
			
			content = content.replace("replace_" + scheme, scheme);
	        
			jsonParam.put("content", content);
	        
	        int resultScheduleID = mScheduleService.insertSchedule(jsonParam, utcStartDate, utcEndDate, info.getTenantId(), realPath, locale, info.getOffSet(), info.getLang()); 
	        
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", resultScheduleID);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}	   			

		logger.debug("MOBILE G/W SCHEDULE [POST /ezschedule/schedules] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 수정
	 */
	@RequestMapping(value="/mobile/ezschedule/schedules/{scheduleId:.+}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject mScheduleUpdate(@PathVariable String scheduleId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [PUT /ezschedule/schedules/{scheduleId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
		
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, jsonParam.get("modifierId").toString());
			MScheduleInfoVO vo = mScheduleService.scheduleInfo(scheduleId, commonUtil.getMinuteUTC(info.getOffSet()), info.getTenantId());
			
			jsonParam.put("modifierName", info.getUserName());
			jsonParam.put("modifierName2", info.getUserName2());
			
			String startDate = jsonParam.get("startDate").toString();
			String endDate = jsonParam.get("endDate").toString();
				
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	    	Calendar cal = Calendar.getInstance();
	    	cal.setTime(sdf.parse(endDate));
	    	
	    	if (cal.get(Calendar.HOUR) == 0 && cal.get(Calendar.MINUTE) == 0) {        		
	    		cal.add(Calendar.MINUTE, -1);        		
	    		endDate = sdf.format(cal.getTime());
	    	}

	    	startDate = sdf.format(sdf.parse(startDate));
	    	endDate = sdf.format(sdf.parse(endDate));

	    	String contentPath = mScheduleService.scheduleContentPath(scheduleId, info.getTenantId());
	    	String utcStartDate = commonUtil.getDateStringInUTC(startDate, info.getOffSet(), true);
	    	String utcEndDate = commonUtil.getDateStringInUTC(endDate, info.getOffSet(), true);
	    	String defaultPath = commonUtil.getRealPath(request)+ commonUtil.getUploadPath("upload_schedule.ROOT", info.getTenantId()) + contentPath;
    	
	        String realPath = commonUtil.getRealPath(request);
	        Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(info.getLang()));
	    	
	        logger.debug("contentPath: " + contentPath);
	        
	        List<AttachListVO> aList = ezScheduleService.getAttachList(scheduleId, info.getTenantId());
	        
	        logger.debug("aList.size: " + aList.size());
	        
	        if(aList.size() > 0) {
	        	jsonParam.put("hasAttach", "Y");
	        } else {
	        	jsonParam.put("hasAttach", "N");
	        }
	        
			String content = jsonParam.get("content").toString();
			content = content.replaceAll("%(?![0-9a-fA-F]{2})", "%25");
			content = content.replaceAll("\\+", "%2B");
			content = URLDecoder.decode(content, "utf-8");
			
			String scheme = "http://";
			if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
				scheme = "https://";
			}
			
			content = content.replace("replace_" + scheme, scheme);
	        
			jsonParam.put("content", content);
			jsonParam.put("repetition", vo.getRepetition());
	        
	        mScheduleService.updateSchedule(jsonParam, utcStartDate, utcEndDate, defaultPath, info.getTenantId(), realPath, locale);
	        
	        String ownerId = (String) jsonParam.get("ownerId");
	        String ownerName = info.getPrimary().equals(info.getLang()) ? (String) jsonParam.get("ownerName") : (String) jsonParam.get("ownerName2");
	        String location = (String) jsonParam.get("location");
	        String title = (String) jsonParam.get("title");
	        String importance = (String) jsonParam.get("importance");
	        String ispublic = (String) jsonParam.get("isPublic");
	        String startdate = (String) jsonParam.get("startDate");
	        String enddate = (String) jsonParam.get("endDate");
	        String datetype = (String) jsonParam.get("dateType");
	        
	        //참석자 정보
	        List<AttendantListVO> attendantList = new ArrayList<AttendantListVO>();
	        if (vo.getHasAttendant().equals("Y")) {
	        	String parentID = (vo.getParentId().equals("0") ? scheduleId : vo.getParentId());
	        	attendantList = ezScheduleService.getAttendantList(parentID, commonUtil.getMinuteUTC(info.getOffSet()), info.getTenantId(), info.getCompanyId());
	        }
	        
            // 2023-09-22 한태훈 : 초대 일정 수정 메일 및 알림 발송
	       	 if (attendantList != null) {
	       		ezScheduleService.sendInviteModNotiForMoblie(request, scheduleId, ownerId, ownerName, attendantList, location, title, importance, ispublic, startdate, enddate, datetype, vo, info);
	       	}
	        
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("MOBILE G/W SCHEDULE [PUT /ezschedule/schedules/{scheduleId}] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 삭제
	 */	
	@RequestMapping(value="/mobile/ezschedule/schedules/{scheduleId:.+}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject mScheduleDelete(@PathVariable String scheduleId, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [DELETE /ezschedule/schedules/{scheduleId}] started.");
		
		JSONObject result = new JSONObject();
						
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, request.getParameter("userId"));
			
			String delType = request.getParameter("delType");       // 단일삭제 : 0 모든일정 삭제 : 1
			String dateType = request.getParameter("dateType");
			String selectDate = request.getParameter("selectDate");
			String startDate = request.getParameter("startDate");
			
			if (delType == null || "".equals(delType)) {
				mScheduleService.deleteSchedule(request, scheduleId, info.getTenantId(), info);
			} else {
				String realStartDate = selectDate + "" + startDate.substring(10, 16);
				String realDate = commonUtil.getDateStringInUTC(realStartDate, info.getOffSet(), true);
				if ("3".equals(dateType))
					ezScheduleService.insertScheduleRepeDel(scheduleId, realDate, info.getTenantId(), info.getCompanyId());
			}
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("MOBILE G/W SCHEDULE [DELETE /ezschedule/schedules/{scheduleId}] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 리스트 (주간)
	 */
	@RequestMapping(value="/mobile/ezschedule/week-list/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleWeekList(@PathVariable String userId, HttpServletRequest request, Locale locale){
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/week-list/users/{userId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			
			String targetDate =  request.getParameter("targetDate");
			String langStr =  request.getParameter("langStr");
			String startDate = "";
			String endDate = "";
			String searchTitle = "";
			
			Calendar calForWeek = Calendar.getInstance();
			int toYear = 0;
			int toMonth = 0;
			int toDay = 0;
			 
			if(targetDate == null || targetDate.equals("")){   //파라메타값이 없을경우 오늘날짜
			 
				toYear = calForWeek.get(Calendar.YEAR);  
				toMonth = calForWeek.get(Calendar.MONTH)+1;
				toDay = calForWeek.get(Calendar.DAY_OF_MONTH);
				int yoil = calForWeek.get(Calendar.DAY_OF_WEEK); //요일나오게하기(숫자로)

			if(yoil != 1){   //해당요일이 일요일이 아닌경우
				
				yoil = yoil-2;
			
			}else{           //해당요일이 일요일인경우
			
				yoil = 7;
			
			}
			
			calForWeek.set(toYear, toMonth-1, toDay-yoil);  //해당주월요일로 세팅
			 
			}else{
			 
			int yy =Integer.parseInt(targetDate.substring(0, 4));
			int mm =Integer.parseInt(targetDate.substring(5, 7))-1;
			int dd =Integer.parseInt(targetDate.substring(8, 10));
			calForWeek.set(yy, mm,dd);
			
			}
			
			String[] arrYMD = new String[7];
			  
			int inYear = calForWeek.get(Calendar.YEAR);  
			int inMonth = calForWeek.get(Calendar.MONTH);
			int inDay = calForWeek.get(Calendar.DAY_OF_MONTH);
			int yoil = calForWeek.get(Calendar.DAY_OF_WEEK); //요일나오게하기(숫자로)
			
			yoil = yoil-1;
			
			inDay = inDay-yoil;
			
			for(int i = 0; i < 7;i++){
			
				calForWeek.set(inYear, inMonth, inDay+i);  //
				String y = Integer.toString(calForWeek.get(Calendar.YEAR));  
				String m = Integer.toString(calForWeek.get(Calendar.MONTH)+1);
				String d = Integer.toString(calForWeek.get(Calendar.DAY_OF_MONTH));
				
				if(m.length() == 1) m = "0" + m; 
				
				if(d.length() == 1) d = "0" + d; 
			   
				arrYMD[i] = y + "-" + m + "-" +d;
				logger.debug("ymd = "+ y + "-" + m + "-" +d);
			   
			}
			
			List<Map<String, Object>> resultList = new ArrayList<>();
					
			for (int i = 0; i < arrYMD.length; i++) {
				
				startDate = arrYMD[i];
				endDate = arrYMD[i];
				
				if (startDate != null && !startDate.equals("")) {
					String[] sDate = startDate.split("-");
					String sMon = (sDate[1].length() == 1 ? "0" + sDate[1] : sDate[1]);
					String sDay = (sDate[2].length() == 1 ? "0" + sDate[2] : sDate[2]);
					
					startDate = sDate[0] + "-" + sMon + "-" + sDay + " 00:00:00";
				} else {
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					Calendar cal = Calendar.getInstance();
					
					startDate = sdf.format(cal.getTime()) + " 00:00:00";
				}
				
				if (endDate != null && !endDate.equals("")) {
					String[] eDate = endDate.split("-");
					String eMon = (eDate[1].length() == 1 ? "0" + eDate[1] : eDate[1]);
					String eDay = (eDate[2].length() == 1 ? "0" + eDate[2] : eDate[2]);
					
					endDate = eDate[0] + "-" + eMon + "-" + eDay  + " 23:59:59";
				} else {
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					Calendar cal = Calendar.getInstance();
					
					endDate = sdf.format(cal.getTime()) + " 23:59:59";
				}
				
				String serverName = request.getHeader("x-user-host");
				MCommonVO info = mOptionService.commonInfo(serverName, userId);
				info.setLang(langStr);
				
				List<ScheduleInfoVO> sList = mScheduleService.scheduleList(info, startDate, endDate, searchTitle, "", "", "");
				
				String useGoogleCalendar = ezCommonService.getTenantConfig("useGoogleCalendar", info.getTenantId());
				if(useGoogleCalendar.equals("YES")) {
					LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
					List<ScheduleInfoVO> googleList = googleService.getGoogleScheduleList(startDate, endDate, "", userInfo, userInfo.getId(), "member", userInfo.getDisplayName());		
					sList.addAll(googleList);
				}
					
				Map<String, Object> dayMap = new HashMap<String, Object>();
				
				if(i == 0) {
					dayMap.put("weekDay", "sun");
					dayMap.put("yoil", egovMessageSource.getMessage("ezSchedule.t9990008", locale));
					dayMap.put("scheduleList", sList);
					dayMap.put("scheduleCount", sList.size());
					dayMap.put("weekDate", arrYMD[0]);
					resultList.add(dayMap);
				} else if(i == 1) {
					dayMap.put("weekDay", "mon");
					dayMap.put("yoil", egovMessageSource.getMessage("ezSchedule.t9990009", locale));
					dayMap.put("scheduleList", sList);
					dayMap.put("scheduleCount", sList.size());
					dayMap.put("weekDate", arrYMD[1]);
					resultList.add(dayMap);
				} else if(i == 2) {
					dayMap.put("weekDay", "tues");
					dayMap.put("yoil", egovMessageSource.getMessage("ezSchedule.t9990010", locale));
					dayMap.put("scheduleList", sList);
					dayMap.put("scheduleCount", sList.size());
					dayMap.put("weekDate", arrYMD[2]);
					resultList.add(dayMap);
				} else if(i == 3) {
					dayMap.put("weekDay", "wed");
					dayMap.put("yoil", egovMessageSource.getMessage("ezSchedule.t9990011", locale));
					dayMap.put("scheduleList", sList);
					dayMap.put("scheduleCount", sList.size());
					dayMap.put("weekDate", arrYMD[3]);
					resultList.add(dayMap);
				} else if(i == 4) {
					dayMap.put("weekDay", "thur");
					dayMap.put("yoil", egovMessageSource.getMessage("ezSchedule.t9990012", locale));
					dayMap.put("scheduleList", sList);
					dayMap.put("scheduleCount", sList.size());
					dayMap.put("weekDate", arrYMD[4]);
					resultList.add(dayMap);
				} else if(i == 5) {
					dayMap.put("weekDay", "fri");
					dayMap.put("yoil", egovMessageSource.getMessage("ezSchedule.t9990013", locale));
					dayMap.put("scheduleList", sList);
					dayMap.put("scheduleCount", sList.size());
					dayMap.put("weekDate", arrYMD[5]);
					resultList.add(dayMap);
				} else if(i == 6) {
					dayMap.put("weekDay", "sat");
					dayMap.put("yoil", egovMessageSource.getMessage("ezSchedule.t9990014", locale));
					dayMap.put("scheduleList", sList);
					dayMap.put("scheduleCount", sList.size());
					dayMap.put("weekDate", arrYMD[6]);
					resultList.add(dayMap);
				}
							
			}
								
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", resultList);		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}
		logger.debug("MOBILE G/W SCHEDULE [GET /ezschedule/week-list/users/{userId}] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [POST] 게시판-일정 연동 등록
	 */	
	@RequestMapping(value="/mobile/ezschedule/board-schedules", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject mBoardScheduleInsert(@RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [POST /mobile/ezschedule/board-schedules] started.");
		
		JSONObject result = new JSONObject();
						
		try {
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, jsonParam.get("creatorId").toString());
						
			jsonParam.put("creatorName", info.getUserName());
			jsonParam.put("creatorName2", info.getUserName2());			
			
			String startDate = jsonParam.get("startDate").toString();
			String endDate = jsonParam.get("endDate").toString();
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	    	Calendar cal = Calendar.getInstance();
	    	cal.setTime(sdf.parse(endDate));
	    	
	    	if (cal.get(Calendar.HOUR) == 0 && cal.get(Calendar.MINUTE) == 0) {        		
	    		cal.add(Calendar.MINUTE, -1);        		
	    		endDate = sdf.format(cal.getTime());
	    	}
	
	    	startDate = sdf.format(sdf.parse(startDate));
	    	endDate = sdf.format(sdf.parse(endDate));
	    	
	    	String utcStartDate = commonUtil.getDateStringInUTC(startDate, info.getOffSet(), true);
	    	String utcEndDate = commonUtil.getDateStringInUTC(endDate, info.getOffSet(), true);	        
	        
	        String realPath = commonUtil.getRealPath(request);
	        Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(info.getLang()));
	        
	        int resultScheduleID = mScheduleService.insertBoardSchedule(jsonParam, utcStartDate, utcEndDate, info.getTenantId(), realPath, locale, info.getOffSet(), info.getLang()); 
	        
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", resultScheduleID);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("MOBILE G/W SCHEDULE [POST /mobile/ezschedule/board-schedules] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정(참석자) 초대 리스트
	 */
	@RequestMapping(value="/mobile/ezschedule/schedules/users/{userId:.+}/attendant/invitationList", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleAttendantInvitationList(@PathVariable String userId, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W SCHEDULE [GET /mobile/ezschedule/schedules/users/{userId:.+}/attendant/invitationList] started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		try {
			logger.debug("userId : " + userId);
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			int tenantId = info.getTenantId();
			String offSetMin = commonUtil.getMinuteUTC(info.getOffSet());
			String companyId = info.getCompanyId();
			
			logger.debug("tenantId : " + tenantId + "  offSetMin : " + offSetMin + "  companyId : " + companyId);
			
			List<ScheduleReceiveListVO> scheduleReceiveList = ezScheduleService.getReceiveList(userId, tenantId, offSetMin, companyId);
			
			for (ScheduleReceiveListVO scheduleReceiveListVO : scheduleReceiveList) {
				logger.debug("scheduleId : " + scheduleReceiveListVO.getScheduleId());
			}
			
			data.put("scheduleReceiveList", scheduleReceiveList);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		logger.debug("MOBILE G/W SCHEDULE [GET /mobile/ezschedule/schedules/users/{userId:.+}/attendant/invitationList] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정(그룹) 초대 리스트
	 */
	@RequestMapping(value="/mobile/ezschedule/schedules/users/{userId:.+}/group/invitationList", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleGroupInvitationList(@PathVariable String userId, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W SCHEDULE [GET /mobile/ezschedule/schedules/users/{userId:.+}/group/invitationList] started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		try {
			logger.debug("userId : " + userId);
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			int tenantId = info.getTenantId();
			String offSetMin = commonUtil.getMinuteUTC(info.getOffSet());
			String companyId = info.getCompanyId();
			
			logger.debug("tenantId : " + tenantId + "  offSetMin : " + offSetMin + "  companyId : " + companyId);
			
			List<ScheduleGroupListVO> scheduleGroupList = ezScheduleService.getInviteScheduleGroupList(userId, tenantId, offSetMin, companyId);
			
			for (ScheduleGroupListVO ScheduleGroupListVO : scheduleGroupList) {
				logger.debug("groupId : " + ScheduleGroupListVO.getGroupId());
			}
			
			data.put("scheduleGroupList", scheduleGroupList);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		logger.debug("MOBILE G/W SCHEDULE [GET /mobile/ezschedule/schedules/users/{userId:.+}/group/invitationList] ended.");
		
		return result;
	}
	
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정(참석자) 초대 참석여부
	 */
	@RequestMapping(value="/mobile/ezschedule/schedules/users/{userId:.+}/attendant/status", method= RequestMethod.PATCH, produces="application/json;charset=utf-8")
	public JSONObject mScheduleIsAcceqptAttendantInvitation(@PathVariable String userId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W SCHEDULE [GET /mobile/ezschedule/schedules/users/{userId:.+}/attendant/status] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			logger.debug("userId : " + userId);
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			int tenantId = info.getTenantId();
			String[] scheduleIdList = jsonParam.get("scheduleIdList").toString().split(",");
			String displayName = jsonParam.get("displayName").toString();
			String displayName2 = jsonParam.get("displayName2").toString();
			String status = jsonParam.get("status").toString();
			String showtop = jsonParam.get("showtop") == null ? "N" : jsonParam.get("showtop").toString();

			for (String scheduleId : scheduleIdList) {
				logger.debug("scheduleId : " + scheduleId);
			}
			logger.debug("tenantId : " + tenantId + "  displayName : " + displayName + "  status : " + status);
			
			for (int i=0; i < scheduleIdList.length; i++) {
				ezScheduleService.updateAttendant(scheduleIdList[i], userId, displayName, displayName2, status, tenantId, showtop, info.getLang(), info.getOffSet());
			}
			
			result.put("status", "ok");
			result.put("code", 0);			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		logger.debug("MOBILE G/W SCHEDULE [GET /mobile/ezschedule/schedules/users/{userId:.+}/attendant/status] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 초대 참석여부
	 */
	@RequestMapping(value="/mobile/ezschedule/schedules/users/{userId:.+}/group/status", method= RequestMethod.PATCH, produces="application/json;charset=utf-8")
	public JSONObject mScheduleIsAcceqptGroupInvitation(@PathVariable String userId, @RequestBody JSONObject jsonParam, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W SCHEDULE [GET /mobile/ezschedule/schedules/users/{userId:.+}/group/status.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			int tenantId = info.getTenantId();
			String[] groupIdList = jsonParam.get("groupIdList").toString().split(",");
			String status = jsonParam.get("status").toString();
			
			for (String groupId : groupIdList) {
				logger.debug("groupId : " + groupId);
			}
			logger.debug("tenantId : " + tenantId + "  status : " + status);
			
			for (int i=0; i < groupIdList.length; i++) {
				ezScheduleService.updateScheduleMember(groupIdList[i], userId, status, tenantId);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		logger.debug("MOBILE G/W SCHEDULE [GET /mobile/ezschedule/schedules/users/{userId:.+}/group/status] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 협업 - 그룹웨어 일정 데이터 연동
	 */
	@RequestMapping(value="/mobile/ezschedule/list/workspace/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mWorkspaceScheduleGetList(@PathVariable String userId, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W SCHEDULE [GET /mobile/ezschedule/list/workspace/{userId:.+}.");
		
		JSONObject result = new JSONObject();
		
		try {
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String searchTitle = request.getParameter("searchTitle");
			
			if (startDate != null && !startDate.equals("")) {
				String[] sDate = startDate.split("-");
				String sMon = (sDate[1].length() == 1 ? "0" + sDate[1] : sDate[1]);
				String sDay = (sDate[2].length() == 1 ? "0" + sDate[2] : sDate[2]);
				
				startDate = sDate[0] + "-" + sMon + "-" + sDay + " 00:00:00";
			} else {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Calendar cal = Calendar.getInstance();
				
				startDate = sdf.format(cal.getTime()) + " 00:00:00";
			}
			
			if (endDate != null && !endDate.equals("")) {
				String[] eDate = endDate.split("-");
				String eMon = (eDate[1].length() == 1 ? "0" + eDate[1] : eDate[1]);
				String eDay = (eDate[2].length() == 1 ? "0" + eDate[2] : eDate[2]);
				
				endDate = eDate[0] + "-" + eMon + "-" + eDay  + " 23:59:59";
			} else {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Calendar cal = Calendar.getInstance();
				
				endDate = sdf.format(cal.getTime()) + " 23:59:59";
			}
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			List<ScheduleInfoVO> sList = mScheduleService.scheduleListForWorkspace(info, startDate, endDate, searchTitle);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", sList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		logger.debug("MOBILE G/W SCHEDULE [GET /mobile/ezschedule/list/workspace/{userId:.+}] ended.");
		
		return result;
	}
	
	@RequestMapping(value="/mobile/ezschedule/config/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getScheduleGetRegi(@PathVariable String userId, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W SCHEDULE [GET /mobile/ezschedule/config/{userId:.+}.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			String prev = ezScheduleService.scheduleGetRegi(info.getCompanyId(), info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", prev);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		logger.debug("MOBILE G/W SCHEDULE [GET /mobile/ezschedule/config/{userId:.+}.");
		
		return result;
	}
	
	/**
	 * 일정메인 > 참석자 초대 팝업
	 */	
	@RequestMapping(value="/mobile/ezSchedule/scheduleReceiveAttendant/{userId:.+}", method = RequestMethod.GET)	
	public JSONObject scheduleReceiveAttendant(@PathVariable String userId, HttpServletRequest request) throws Exception {
		
		logger.debug("MOBILE G/W SCHEDULE [GET /mobile/ezSchedule/scheduleReceiveAttendant/{userId:.+} started.");
		
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String offSetMin = commonUtil.getMinuteUTC(info.getOffSet());
			
			List<ScheduleReceiveListVO> rList = ezScheduleService.getReceiveList(userId, info.getTenantId(), offSetMin, info.getCompanyId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", rList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		logger.debug("MOBILE G/W SCHEDULE [GET /mobile/ezSchedule/scheduleReceiveAttendant/{userId:.+} ended.");
		
		return result;
	}
	
	@RequestMapping(value="/mobile/ezSchedule/scheduleAcceptAttendant/{userId:.+}", method = RequestMethod.POST)	
	public JSONObject scheduleAcceptAttendant(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [POST /mobile/ezSchedule/scheduleAcceptAttendant/{userId:.+} started.");
		
		JSONObject result = new JSONObject();
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(info.getLang()));
			String status = request.getParameter("status");
			String displayName = info.getUserName();
			String displayName2 = info.getUserName2();
			String creatorList = request.getParameter("creatorList");
			String attendantId = request.getParameter("attendantId");
			String scheduleIdStr = request.getParameter("scheduleIdList").substring(0, request.getParameter("scheduleIdList").length() - 1); // 마지막 구분자 제거
			String[] scheduleIdList = null;
			if (scheduleIdStr != null && !scheduleIdStr.equals("")) {
				scheduleIdList = scheduleIdStr.split("\\|"); 
			}
			
			JSONParser parser = new JSONParser();
			JSONArray jsonArray = (JSONArray)parser.parse(creatorList);
			
			for (int i=0; i < scheduleIdList.length; i++) {
				ezScheduleService.updateAttendant(scheduleIdList[i], attendantId, displayName, displayName2, status, info.getTenantId(), "N", info.getLang(), info.getOffSet());
				JSONObject obj = (JSONObject) jsonArray.get(i);
				String scheduleId = scheduleIdList[i];
				String creatorId = (String) obj.get("creatorId");			
				String creatorName = (String) obj.get("creatorName");
				String title = (String) obj.get("title");
				String dateType = (String) obj.get("dateType");
				String startDate = (String) obj.get("startDate");
				String endDate = (String) obj.get("endDate");
				String repetition = (String) obj.get("repetition");
				
				String scheDateContent = ezScheduleService.makeScheDateContent(dateType, repetition, startDate, endDate, locale);
				String scheTimeContent = ezScheduleService.makeScheTimeContent(startDate, endDate, dateType, repetition, locale);
				String scheRepeContent = ezScheduleService.makeRepetitionContent(repetition, locale);
				
				String periodConetent = "";
				periodConetent = " &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezSchedule.t318", locale) + " : " + scheDateContent + "<br>";
				periodConetent += " &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezSchedule.t67", locale) + " : " + scheTimeContent;
				
				if (dateType.equals("3")) {
					periodConetent += "<br>" + " &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezSchedule.t71", locale) + " : " + scheRepeContent;
				}
				
				if (status.equals("1")) {
					ezScheduleService.sendScheduleNotiForMobile(request, info, creatorId, creatorName, title, periodConetent, "acc", scheduleId, startDate, endDate);
				}
				else {
					ezScheduleService.sendScheduleNotiForMobile(request, info, creatorId, creatorName, title, periodConetent, "rej", scheduleId, startDate, endDate);
				}
			}	
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);	
		}
		
		logger.debug("MOBILE G/W SCHEDULE [POST /mobile/ezSchedule/scheduleAcceptAttendant/{userId:.+} ended.");
		
		return result;
	}
	
	@RequestMapping(value="/mobile/ezSchedule/receiveCount/{userId:.+}", method = RequestMethod.GET)	
	public JSONObject getReceiveCount(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [POST /mobile/ezSchedule/receiveCount/{userId:.+} started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			int receiveCount = ezScheduleService.getReceiveCount(userId, info.getTenantId() ,info.getCompanyId());
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", receiveCount > 0 ? "Y" : "N");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);	
		}
		
		logger.debug("MOBILE G/W SCHEDULE [POST /mobile/ezSchedule/receiveCount/{userId:.+} ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 [GET] 일정 종류 리스트 (개인/부서/회사)
	 */
	@RequestMapping(value="/mobile/ezschedule/user/{userId:.+}/all-type-List", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleUserTypeList(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [GET ezschedule/user/{userId}/all-type-List] started.");
		
		JSONObject result = new JSONObject();
		List<Map<String, Object>> typeList = new ArrayList<Map<String,Object>>();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			MOptionVO optionInfo = mOptionService.optionInfo(userId, info.getTenantId());
			
			String lang = info.getLang();
			
			String primary = commonUtil.getPrimaryData(lang, info.getTenantId());
			Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(lang));
			String offSetMin = commonUtil.getMinuteUTC(info.getOffSet());
			StringBuilder sb = new StringBuilder();
			
			String pCompanyAdmin = "";
			String pDeptAdmin = "";
			
			if (info.getRollInfo().contains("c=1") || info.getRollInfo().contains("k=1")) {
	        	pCompanyAdmin = "Y";
	        	pDeptAdmin = "Y";
	        }
			if (info.getRollInfo().contains("g=1")) {
	        	pDeptAdmin = "Y";
	        }
			if (info.getRollInfo().contains("v=1")) {
				pCompanyAdmin = "Y";
			}
			
			LoginVO loginVO = new LoginVO();
			
			loginVO.setId(userId);
			loginVO.setCompanyID(info.getCompanyId());
			loginVO.setTenantId(info.getTenantId());
			loginVO.setOffset(info.getOffSet());
			loginVO.setLocale(locale);
			loginVO.setLang(optionInfo.getLang());
			loginVO.setDeptID(info.getDeptId());
			loginVO.setDeptName(info.getDeptName());
			loginVO.setDisplayName(info.getUserName());
			loginVO.setPrimary(commonUtil.getPrimaryData(loginVO.getLang(), loginVO.getTenantId()));
			loginVO.setEmail(info.getEmail());

			String useGoogleCalendar = ezCommonService.getTenantConfig("useGoogleCalendar", info.getTenantId());
		    String isGoogleSync = useGoogleCalendar.equals("YES") ? isGoogleSync(loginVO) : "N";
		    
		    String useWorkspaceSchedule = ezCommonService.getTenantConfig("useWorkspaceSchedule", loginVO.getTenantId());
		    if (useWorkspaceSchedule == null || useWorkspaceSchedule.equals("")) {
				useWorkspaceSchedule = "NO";
			}
		    
		    // 모든일정, 개인일정, 부서일정, 회사일정, 그룹일정
		    Map<String, Object> allSchedule = new HashMap<String, Object>();
		    allSchedule.put("typeColor", "rgb(125, 125, 125)");
		    allSchedule.put("typeName", "모든일정");
		    allSchedule.put("scheduleType", "");
		    allSchedule.put("ownerId", "");
		    typeList.add(allSchedule);
		    
		    Map<String, Object> personalSchedule = new HashMap<String, Object>();
		    String personalColor = ezScheduleService.getUserScheduleTypeColor(userId, info.getCompanyId(), info.getTenantId(), "1", userId);
		    personalSchedule.put("typeColor", (null == personalColor || "".equals(personalColor)) ? "rgb(1, 138, 249)" : personalColor);
		    personalSchedule.put("typeName", "개인일정");
		    personalSchedule.put("scheduleType", "1");
		    personalSchedule.put("ownerId", userId);
		    personalSchedule.put("ownerName", info.getUserName());
		    typeList.add(personalSchedule);
		    
		    Map<String, Object> googleSchedule = new HashMap<String, Object>();
		    googleSchedule.put("typeColor", "rgb(1, 138, 249)");
		    googleSchedule.put("typeName", "구글일정");
		    googleSchedule.put("scheduleType", "9");
		    googleSchedule.put("ownerId", userId);
		    googleSchedule.put("ownerName", info.getUserName());
		    if ("Y".equals(isGoogleSync)) typeList.add(googleSchedule);
		    
		    Map<String, Object> deptSchedule = new HashMap<String, Object>();
		    String deptColor = ezScheduleService.getUserScheduleTypeColor(userId, info.getCompanyId(), info.getTenantId(), "2", info.getDeptId());
		    deptSchedule.put("typeColor", (null == deptColor || "".equals(deptColor)) ? "rgb(1, 179, 63)" : deptColor);
		    deptSchedule.put("typeName", "부서일정");
		    deptSchedule.put("scheduleType", "2");
		    deptSchedule.put("ownerId", info.getDeptId());
		    deptSchedule.put("ownerName", info.getDeptName());
		    typeList.add(deptSchedule);
		    
		    List<ScheduleDeptVO> pubScheDeptVO = ezScheduleService.getPublicScheduleDept(info.getUserId(), lang, info.getTenantId(), info.getCompanyId());
			List<ScheduleDeptVO> pubScheDeptVO2 = new ArrayList<ScheduleDeptVO>();
			List<ScheduleCumulerVO> pubScheCumulerVO = ezScheduleService.getPublicScheduleCumuler(info.getUserId(), lang, info.getTenantId(), info.getCompanyId());
		    
			dept_schedule:
				for (ScheduleDeptVO vo : pubScheDeptVO) {
					for (ScheduleCumulerVO vo2 : pubScheCumulerVO) {
						if (vo.getDeptId().equals(vo2.getDeptId())){
							continue dept_schedule;
						}
					}						
					pubScheDeptVO2.add(vo);
				}
			
			// 사용자의 본/겸직 부서
			if (pubScheCumulerVO.size() > 0) {
				for (int i = 0; i < pubScheCumulerVO.size(); i++) {
					if (!info.getDeptId().equals(pubScheCumulerVO.get(i).getDeptId())) {
						Map<String, Object> scheCumSchedule = new HashMap<String, Object>();
						String addDeptColor = ezScheduleService.getUserScheduleTypeColor(userId, info.getCompanyId(), info.getTenantId(), "2", pubScheCumulerVO.get(i).getDeptId());
						scheCumSchedule.put("typeColor", (null == addDeptColor || "".equals(addDeptColor)) ? "rgb(1, 179, 63)" : addDeptColor);
						scheCumSchedule.put("typeName", "부서일정 -" + pubScheCumulerVO.get(i).getTitleName());
						scheCumSchedule.put("scheduleType", "2");
						scheCumSchedule.put("ownerId", pubScheCumulerVO.get(i).getDeptId());
						scheCumSchedule.put("ownerName", pubScheCumulerVO.get(i).getTitleName());
						
						typeList.add(scheCumSchedule);
					}
				}
			}
			
			// 일정 공개 부서 (사용자의 본/겸직 부서에 해당하지 않는)
			if (pubScheDeptVO2.size() > 0) {
				for (int i = 0; i < pubScheDeptVO2.size(); i++) {
					Map<String, Object> scheDeptSchedule = new HashMap<String, Object>();
					String pubDeptColor = ezScheduleService.getUserScheduleTypeColor(userId, info.getCompanyId(), info.getTenantId(), "2", pubScheDeptVO2.get(i).getDeptId());
					scheDeptSchedule.put("typeColor", (null == pubDeptColor || "".equals(pubDeptColor)) ? "#b200ff" : pubDeptColor);
					scheDeptSchedule.put("typeName", "부서일정 -" + pubScheDeptVO2.get(i).getDeptName());
					scheDeptSchedule.put("scheduleType", "2");
					scheDeptSchedule.put("ownerId", pubScheDeptVO2.get(i).getDeptId());
					scheDeptSchedule.put("ownerName", pubScheDeptVO2.get(i).getDeptName());
					
					typeList.add(scheDeptSchedule);
				}
			}
			
		    Map<String, Object> companySchedule = new HashMap<String, Object>();
		    String compColor = ezScheduleService.getUserScheduleTypeColor(userId, info.getCompanyId(), info.getTenantId(), "3", info.getCompanyId());
		    companySchedule.put("typeColor", (null == compColor || "".equals(compColor)) ? "rgb(254, 28, 113)" : compColor);
		    companySchedule.put("typeName", "회사일정");
		    companySchedule.put("scheduleType", "3");
		    companySchedule.put("ownerId", info.getCompanyId());
		    companySchedule.put("ownerName", info.getCompanyName());
		    typeList.add(companySchedule);
		    
		    Map<String, Object> workSpaceSchedule = new HashMap<String, Object>();
		    workSpaceSchedule.put("typeColor", "rgb(63, 81, 181)");
		    workSpaceSchedule.put("typeName", "협업일정");
		    workSpaceSchedule.put("scheduleType", "4");
		    workSpaceSchedule.put("ownerId", "collaboration");
		    if (!"NO".equals(useWorkspaceSchedule)) typeList.add(workSpaceSchedule);
		    
			List<ScheduleGroupListVO> groupList = ezScheduleService.getScheduleGroupList(info.getUserId(), info.getTenantId() ,info.getCompanyId());
			
			for (ScheduleGroupListVO vo : groupList) {
				Map<String, Object> groupSchedule = new HashMap<String, Object>();
				groupSchedule.put("typeColor", Optional.ofNullable(vo.getGroupColor()).orElse("#e9de13"));
				groupSchedule.put("typeName", "그룹일정 -" + vo.getGroupName());
				groupSchedule.put("scheduleType", "7");
				groupSchedule.put("ownerId", vo.getGroupId());
				groupSchedule.put("ownerName", vo.getGroupName());
				
				List<ScheduleGroupListVO> mList = ezScheduleService.getGroupMemberList(vo.getGroupId(), info.getPrimary(), info.getTenantId(), offSetMin, info.getCompanyId());

				boolean hasWritePermission = false;
				for (ScheduleGroupListVO member : mList) {
					if (userId.equals(member.getMemberId()) && "Y".equals(member.getWritePermission())) {
						hasWritePermission = true;
						break;
					}
				}
			    
				if (userId.equals(vo.getCreatorId()) || hasWritePermission) {
					groupSchedule.put("permission", "Y");
				} else {
					groupSchedule.put("permission", "N");
				}
			    typeList.add(groupSchedule);
			}
		    
			result.put("status", "ok");
			result.put("code", 0);		
			result.put("data", typeList);
//			result.put("chkPublic", chkSchedulePublic); // 개인일정 작성시 공개/비공개값 설정가능 여부
//			result.put("gatherList", gatherList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}    	
		
		logger.debug("MOBILE G/W SCHEDULE [GET ezschedule/user/{userId}/all-type-List]] ended.");
		
		return result;
	}
	
	private String isGoogleSync(LoginVO userInfo) throws Exception {
	    return googleService.getIsSync(userInfo); 
	}
	
	@RequestMapping(value="/mobile/ezSchedule/scheduleInvitationStatus/{userId:.+}", method = RequestMethod.POST)	
	public JSONObject scheduleInvitationStatus(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [POST /mobile/ezSchedule/scheduleInvitationStatus/{userId:.+} started.");
		
		JSONObject result = new JSONObject();
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(info.getLang()));
			String displayName = info.getUserName();
			String displayName2 = info.getUserName2();
			
			String offSetMin = commonUtil.getMinuteUTC(info.getOffSet());
			
			String status = request.getParameter("status");
			String attendantId = request.getParameter("attendantId");
			String scheduleIdStr = request.getParameter("scheduleIdList").substring(0, request.getParameter("scheduleIdList").length() - 1); // 마지막 구분자 제거
			String[] scheduleIdList = null;
			if (scheduleIdStr != null && !scheduleIdStr.equals("")) {
				scheduleIdList = scheduleIdStr.split(","); 
			}
			
			for (int i=0; i < scheduleIdList.length; i++) {
				ScheduleInfoVO scheduleInfoVO = ezScheduleService.getScheduleInfo(scheduleIdList[i], offSetMin, info.getTenantId(), info.getCompanyId());
				ezScheduleService.updateAttendant(scheduleIdList[i], attendantId, displayName, displayName2, status, info.getTenantId(), "N", info.getLang(), info.getOffSet());

				String scheduleId = scheduleIdList[i];
				String creatorId = scheduleInfoVO.getCreatorId();		
				String creatorName = scheduleInfoVO.getCreatorName();
				String title = scheduleInfoVO.getTitle();
				String dateType = scheduleInfoVO.getDateType();
				String startDate = scheduleInfoVO.getStartDate();
				String endDate = scheduleInfoVO.getEndDate();
				String repetition = scheduleInfoVO.getRepetition();
				
				String scheDateContent = ezScheduleService.makeScheDateContent(dateType, repetition, startDate, endDate, locale);
				String scheTimeContent = ezScheduleService.makeScheTimeContent(startDate, endDate, dateType, repetition, locale);
				String scheRepeContent = ezScheduleService.makeRepetitionContent(repetition, locale);
				
				String periodConetent = "";
				periodConetent = " &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezSchedule.t318", locale) + " : " + scheDateContent + "<br>";
				periodConetent += " &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezSchedule.t67", locale) + " : " + scheTimeContent;
				
				if (dateType.equals("3")) {
					periodConetent += "<br>" + " &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezSchedule.t71", locale) + " : " + scheRepeContent;
				}
				
				if (status.equals("1")) {
					ezScheduleService.sendScheduleNotiForMobile(request, info, creatorId, creatorName, title, periodConetent, "acc", scheduleId, startDate, endDate);
				}
				else {
					ezScheduleService.sendScheduleNotiForMobile(request, info, creatorId, creatorName, title, periodConetent, "rej", scheduleId, startDate, endDate);
				}
			}	
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);	
		}
		
		logger.debug("MOBILE G/W SCHEDULE [POST /mobile/ezSchedule/scheduleInvitationStatus/{userId:.+} ended.");
		
		return result;
	}
	
	/**
	 * 2023-10-10 임정은 - 모바일 G/W 일정관리 > 일정 모아보기 > 그룹 선택 시 정보 가져오기
	 */
	@RequestMapping(value="/mobile/ezschedule/gathered-schedule", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject mScheduleGatherList(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W SCHEDULE [GET /mobile/ezschedule/gathered-schedule] started.");

		JSONObject result = new JSONObject();

		try {
			Map<String, Object> dataObject = new HashMap<String, Object>();

			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String groupId = request.getParameter("groupId");
			String startDate = request.getParameter("startDate") + " 00:00:00";
			String endDate = request.getParameter("endDate") + " 23:59:59";

			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String utcStartTime = commonUtil.getDateStringInUTC(startDate, info.getOffSet(), true);
			String utcEndTime = commonUtil.getDateStringInUTC(endDate, info.getOffSet(), true);
			String offSetMin = commonUtil.getMinuteUTC(info.getOffSet());
			String useAnnualScheduleYN = ezCommonService.getTenantConfig("useAnnualScheduleYN", info.getTenantId());

			List<ScheduleGroupListVO> mList = ezScheduleService.getMyGatherMemberList(groupId, info.getPrimary(), info.getTenantId(), info.getCompanyId());

			StringBuilder sb1 = new StringBuilder("<DATA>");
			StringBuilder sb2 = new StringBuilder();

			for (int i = 0; i < mList.size(); i++) {
				sb1.append(commonUtil.getQueryResult(mList.get(i)));
			}
			sb1.append("</DATA>");

			for (int i = 0; i < mList.size(); i++) {
				String idList = mList.get(i).getMemberId();
				String DeptID = ezScheduleService.getCumDeptId(idList, info.getTenantId(), info.getCompanyId());
				String CompanyID = info.getCompanyId();
				String pidList = "'" + idList + "'";

				String dcidList = "'" + DeptID + "'" + ",'" + CompanyID + "'";
				List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(idList, info.getTenantId() ,info.getCompanyId());
				for (int j = 0; j < gList.size(); j++) {
					if (j == 0) {
						dcidList += ",";
					}
					dcidList += "'" + gList.get(j).getGroupId() + "'";

					if (j != gList.size() - 1) {
						dcidList += ",";
					}
				}

				List<ScheduleInfoVO> sList = ezScheduleService.getScheduleList(pidList, dcidList, "", utcStartTime, utcEndTime, startDate, endDate, offSetMin, "", "", "", info.getTenantId(), info.getCompanyId(), idList, info.getDeptId(), useAnnualScheduleYN);
				sb2.append("<DATA>");
				for (int k = 0; k < sList.size(); k++) {
					ScheduleInfoVO data = sList.get(k);
					sb2.append(commonUtil.getQueryResult(data));
				}

				sb2.append("</DATA>");

				if (i != mList.size() - 1) {
					sb2.append("\\\\");
				}
			}
			List<ScheduleGroupListVO> gatherList = ezScheduleService.getMyGatherList(userId, info.getTenantId(), info.getCompanyId());

			dataObject.put("xmlResult", sb1.toString());
			dataObject.put("xmlArray", sb2.toString());
			dataObject.put("gatherList", gatherList);
			dataObject.put("groupName", mList.get(0).getStatus());

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", dataObject);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}

		logger.debug("MOBILE G/W SCHEDULE [GET /mobile/ezschedule/gathered-schedule] ended.");

		return result;
	}
	
	/**
	 * 모바일 G/W 일정관리 휴일조회
	 */
	@RequestMapping(value="/mobile/ezSchedule/holiday/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getHoliday(@PathVariable String userId, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezSchedule/holiday/{userId:.+}] started.");
		JSONObject result = new JSONObject();
		
		try {
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int targetYear = Integer.parseInt(request.getParameter("targetYear"));
			List<ResScheGetHolidayVO> getHoliday = new ArrayList<>();
			List<ResScheGetHolidayVO> getHoliday2 = new ArrayList<>();
			
			for (int i = -1; i <= 1; i++) {
				int currentYear = targetYear + i;
				getHoliday.addAll(mScheduleService.getTholiday(currentYear, "VIEW", info.getCompanyId(), info.getTenantId()));
				getHoliday2.addAll(mScheduleService.getTholiday(currentYear, "VIEW", "ALL", info.getTenantId()));
			}
			
			logger.debug("userId : " + userId);
			
			Map<String, Object> resultMap = new HashMap<String, Object>();
			resultMap.put("getHoliday", getHoliday);
			resultMap.put("memorialDay", getHoliday2);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", resultMap);
			
		} catch (Exception e) {
			
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		}

		logger.debug("MOBILE G/W RESOURCE [GET /mobile/ezSchedule/holiday/{userId:.+}] ended.");
		return result;
	}
	
	/**
	 * 일정관리 일정 데이터 표출 함수	 
	 */	
	public List<ScheduleInfoVO> scheduleListData(String startDate, String endDate, String idList, String pidList, String groupID, String offSetMin, LoginVO userInfo, String searchTitle, String searchLocation, String searchAll) throws Exception {
		
		logger.debug("============ scheduleListData started ============");		
		String indiList = "";
		String pidListSub = "";
		String indiListSub = "";
		
		if(startDate != null && !startDate.equals("")) {
			String[] sDate = startDate.split("-");
			String sMon = (sDate[1].length() == 1 ? "0" + sDate[1] : sDate[1]);
			String sDay = (sDate[2].length() == 1 ? "0" + sDate[2] : sDate[2]);
			
			startDate = sDate[0] + "-" + sMon + "-" + sDay;
		}
		
		if(endDate != null && !endDate.equals("")) {
			String[] eDate = endDate.split("-");		
			String eMon = (eDate[1].length() == 1 ? "0" + eDate[1] : eDate[1]);
			String eDay = (eDate[2].length() == 1 ? "0" + eDate[2] : eDate[2]);
			
			endDate = eDate[0] + "-" + eMon + "-" + eDay;
		}
		
		String utcStartTime = commonUtil.getDateStringInUTC(startDate, userInfo.getOffset(), true);
		String utcEndTime = commonUtil.getDateStringInUTC(endDate, userInfo.getOffset(), true);
		
		String userID = userInfo.getId();
		String lang = userInfo.getPrimary();
		int tenantID = userInfo.getTenantId();
		String companyID = userInfo.getCompanyID();
		
		//2020-02-24 김정언
		String useAnnualScheduleYN = ezCommonService.getTenantConfig("useAnnualScheduleYN", userInfo.getTenantId());
		
		List<ScheduleSecretaryVO> tList = ezScheduleService.getPublicScheduleSec(userID, lang, tenantID ,companyID);
		List<ScheduleDeptVO> dList = ezScheduleService.getPublicScheduleDept(userID, lang, tenantID ,companyID);
		List<ScheduleCumulerVO> cList = ezScheduleService.getPublicScheduleCumuler(userID, lang, tenantID, companyID);
		List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(userInfo.getId(), userInfo.getTenantId() ,companyID);
		
		if (idList == null) {
			idList = "";
		}
		
		//2018-06-08 구해안 T인 경우를 제외하고 나머지는 id값 그대로 가공해서 넘기기
		
		if (idList.equals("T")) {
			indiList = "'" + userInfo.getId() + "'";
			
			if(tList != null && tList.size()>0){
				for (int i = 0; i < tList.size(); i++) {
					if (i == 0) {
						indiListSub += ",";
					}			
					ScheduleSecretaryVO data = tList.get(i);			
					indiListSub += "\'" + data.getSecId()+ "\',";			
				}				
			}
			
			pidList = "'" + userInfo.getDeptID() + "'," + "'" + userInfo.getCompanyID() + "'";
			
			
			if(dList != null && dList.size()>0){
				for (int i = 0; i < dList.size(); i++) {
						if (i == 0) {
							pidListSub += ",";
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
				}
			
			if(indiListSub.equals("") || indiListSub == null){
				indiListSub = ",\'\'";
			}else{				
				indiListSub = indiListSub.substring(0, indiListSub.length()-1);
			}
			
			indiList += indiListSub;
			
			if(pidListSub.equals("") || pidListSub == null){
				pidListSub = ",\'\'";
			}else{				
				pidListSub = pidListSub.substring(0, pidListSub.length()-1);
			}
			
			pidList += pidListSub;
			
		} else if(idList.equals("chkAllFalse")) {
			indiList = "\'\'";
			pidList = "\'\'";
		} else {
			indiList = idList;
		}
		
		List<ScheduleInfoVO> sList = ezScheduleService.getScheduleList(indiList, pidList, "", utcStartTime, utcEndTime, startDate, endDate, offSetMin, searchTitle, searchLocation, searchAll, userInfo.getTenantId(), companyID, userInfo.getId(), userInfo.getDeptID(), useAnnualScheduleYN);		
		
		// 2025-05-12 조수빈 - 개인, 부서, 회사인 경우 개인 설정 색상 조회 및 설정
		for (ScheduleInfoVO vo : sList) {
			if (vo.getScheduleType().equals("1")
				|| vo.getScheduleType().equals("2")
				|| vo.getScheduleType().equals("3")
				) {
				String tagColor = ezScheduleService.getUserScheduleTypeColor(userID, companyID, tenantID, vo.getScheduleType(), vo.getOwnerId());
				vo.setGroupColor(tagColor);
			}
		}
		
		/* 2021-11-26 홍승비 - 일정 리스트 데이터를 전달받아 일정완료 데이터를 추가 가공하여 리턴 */
		sList = ezScheduleService.applyScheduleCompleteData(sList, userInfo.getOffset(), userInfo.getTenantId(), companyID);

		String useGoogleCalendar = ezCommonService.getTenantConfig("useGoogleCalendar", userInfo.getTenantId());
		if(useGoogleCalendar.equals("YES")) {
			List<ScheduleInfoVO> googleList = googleService.getGoogleScheduleList(startDate, endDate, "", userInfo, userInfo.getId(), "member", userInfo.getDisplayName());		
			sList.addAll(googleList);
		}
		
		Collections.sort(sList, new EzScheduleCompareUtil());
		
		return sList;
	}
	
	/**
	 * 일정관리 일정 데이터 표출 함수
	 */
	public List<ScheduleInfoVO> scheduleUserSearchListData(String startDate, String endDate, String idList, String groupID, String offSetMin, LoginVO userInfo) throws Exception {

		logger.debug("============ scheduleUserSearchListData started ============");
		String indiList = "";
		String pidList = "";
		String pidListSub = "";
		String indiListSub = "";
		String blank ="";

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

		String utcStartTime = commonUtil.getDateStringInUTC(startDate, userInfo.getOffset(), true);
		String utcEndTime = commonUtil.getDateStringInUTC(endDate, userInfo.getOffset(), true);

		String userID = userInfo.getId();
		String lang = userInfo.getPrimary();
		int tenantID = userInfo.getTenantId();
		String companyID = userInfo.getCompanyID();

		//근태현황 일정관리 연동 x
		String useAnnualScheduleYN = "0";
		//일정 비서 사용 x
		//List<ScheduleSecretaryVO> tList = ezScheduleService.getPublicScheduleSec(userID, lang, tenantID ,companyID);
		List<ScheduleSecretaryVO> tList = new ArrayList<ScheduleSecretaryVO>();

		//공유 부서 사용 x
		//List<ScheduleDeptVO> dList = ezScheduleService.getPublicScheduleDept(userID, lang, tenantID ,companyID);
		List<ScheduleDeptVO> dList = new ArrayList<ScheduleDeptVO>();

		//겸직 부서 사용 x
		//List<ScheduleCumulerVO> cList = ezScheduleService.getPublicScheduleCumuler(userID, lang, tenantID, companyID);
		List<ScheduleCumulerVO> cList = new ArrayList<ScheduleCumulerVO>();

		//일정 그룹 사용
		List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(userID, userInfo.getTenantId() ,companyID);
		//List<ScheduleGroupListVO> gList = new ArrayList<ScheduleGroupListVO>();

		if (idList == null) {
			idList = "";
		}

		if (idList.equals("T") || idList.equals("")) {
			indiList = "'" + userInfo.getId() + "'";

			if(tList != null && tList.size()>0){
				for (int i = 0; i < tList.size(); i++) {
					if (i == 0) {
						indiListSub += ",";
					}
					ScheduleSecretaryVO data = tList.get(i);
					indiListSub += "\'" + data.getSecId()+ "\',";
				}
			}

			pidList = "'" + userInfo.getDeptID() + "'," + "'" + userInfo.getCompanyID() + "'";


			if(dList != null && dList.size()>0){
				for (int i = 0; i < dList.size(); i++) {
					if (i == 0) {
						pidListSub += ",";
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

			if(indiListSub.equals("") || indiListSub == null){
				indiListSub = ",\'\'";
			}else{
				indiListSub = indiListSub.substring(0, indiListSub.length()-1);
			}

			indiList += indiListSub;

			if(pidListSub.equals("") || pidListSub == null){
				pidListSub = ",\'\'";
			}else{
				pidListSub = pidListSub.substring(0, pidListSub.length()-1);
			}

			pidList += pidListSub;

		} else if(idList.equals("chkAllFalse")) {
			indiList = "";
			pidList = "\'\'";
		} else if (idList.equals("P")) {
			indiList = "'" + userInfo.getId() + "'";
			pidList = "";
		}else {
			pidList = idList;
		}
		
		List<ScheduleInfoVO> sList = scheduleListData(startDate, endDate, "T", "","", commonUtil.getMinuteUTC(userInfo.getOffset()), userInfo, "", "", "");
		
		/* 2021-11-26 홍승비 - 일정 리스트 데이터를 전달받아 일정완료 데이터를 추가 가공하여 리턴 */
		sList = ezScheduleService.applyScheduleCompleteData(sList, userInfo.getOffset(), userInfo.getTenantId(), companyID);

		Collections.sort(sList, new EzScheduleCompareUtil());

		return sList;
	}
}


