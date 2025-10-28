package egovframework.ezEKP.ezSchedule.web;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Part;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import egovframework.let.utl.fcc.service.EzFAL;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.view.RedirectView;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.api.services.calendar.model.Event;
import com.ibm.icu.util.Calendar;
import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGKlibService;
import egovframework.ezEKP.ezCabinet.service.EzCabinetAdminService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezEKP.ezNotification.service.EzNotificationService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.type.NotiPlatform;
import egovframework.ezEKP.ezPersonal.type.NotiType;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.ezEKP.ezSchedule.service.EzScheduleGoogleService;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.service.impl.EzScheduleCompareUtil;
import egovframework.ezEKP.ezSchedule.service.impl.EzScheduleCompareUtilPublic;
import egovframework.ezEKP.ezSchedule.vo.AttachListVO;
import egovframework.ezEKP.ezSchedule.vo.AttendantListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheDeptVO;
import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.ezEKP.ezSchedule.vo.ScheSecretaryVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleConfigVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleCumulerVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleDeptVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleMailConfigVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleOwnerInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleReceiveListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleSecretaryVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleTokenInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleTypeConfigVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import net.fortuna.ical4j.data.CalendarBuilder;
import net.fortuna.ical4j.data.ParserException;
import net.fortuna.ical4j.filter.Filter;
import net.fortuna.ical4j.filter.PeriodRule;
import net.fortuna.ical4j.model.Component;
import net.fortuna.ical4j.model.ComponentList;
import net.fortuna.ical4j.model.DateTime;
import net.fortuna.ical4j.model.Parameter;
import net.fortuna.ical4j.model.Period;
import net.fortuna.ical4j.model.Property;
import net.fortuna.ical4j.model.Recur;
import net.fortuna.ical4j.model.WeekDay;
import net.fortuna.ical4j.model.component.CalendarComponent;
import net.fortuna.ical4j.model.component.VEvent;
import net.fortuna.ical4j.model.property.Description;
import net.fortuna.ical4j.model.property.DtEnd;
import net.fortuna.ical4j.model.property.DtStart;
import net.fortuna.ical4j.model.property.Location;
import net.fortuna.ical4j.model.property.RRule;
import net.fortuna.ical4j.model.property.Summary;
import net.fortuna.ical4j.util.MapTimeZoneCache;

import static egovframework.ezEKP.ezOrgan.vo.OrganAuth.AdminAuth;

/** 
 * @Description [Controller] 스케쥴
 * @author 오픈솔루션팀 장진혁
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.05.19	지정석	신규작성
 *    2016.08.10	김경식	scheduleMain 추가
 *    2016.08.30	김경식	scheduleWrite 추가
 *    2017.01.09	일정관리 개발 시작 - 장진혁
 *    2017.02.22	일정관리 1차 개발 완료 - 장진혁
 *
 * @see
 */

@Controller
public class EzScheduleController extends EzFileMngUtil {
	private static final Logger logger = LoggerFactory.getLogger(EzScheduleController.class);

	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="EzScheduleService")
	private EzScheduleService ezScheduleService;
		
	@Resource(name="EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name="EzOrganService")	
	private EzOrganService ezOrganService;
	
	@Autowired
	private EgovMessageSource msg;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="EzPortalService")
	private EzPortalService ezPortalService;
	
	@Resource(name="EzCabinetAdminService")
	private EzCabinetAdminService cabinetAdminService;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name = "loginService")
    private LoginService loginService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzEmailService ezEmailService;

	@Autowired
	private EzScheduleGoogleService googleService;

	@Autowired
	private EzNewPortalService ezNewPortalService;
	
	@Autowired
	private EzNotificationService ezNotificationService;

	@Autowired
	private EzPersonalService ezPersonalService;

	/**
	 * 일정관리 인덱스화면 호출함수
	 */
	@RequestMapping(value="/ezSchedule/scheduleIndex.do", method = RequestMethod.GET)
	public String  main(HttpServletRequest request, Model model) throws Exception {

		logger.debug("============ scheduleIndex started ============");
		
		String funCode = "";	// 업무관리 or 일정관리(3)
		String subCode = "";
		String leftFrameWidth = "220";
		int width = 0;
		
        if (request.getParameter("funCode") != null) {
            funCode = request.getParameter("funCode");
        } else {
        	funCode = "2";
        }
        
        if (request.getParameter("subfunction") != null) {
        	subCode = request.getParameter("subfunction");
        } else {
        	subCode = "1";
        }

		if (request.getParameter("__wwidth") != null) {
			String widthParam = request.getParameter("__wwidth");

			try {
				width = Integer.parseInt(widthParam);

				leftFrameWidth = width < 1180 ? "0" : "220";
			} catch (NumberFormatException e) {
				width = 0;
			}
		}
        
		model.addAttribute("funCode", commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(funCode)));
		model.addAttribute("subCode", subCode);		
		model.addAttribute("leftFrameWidth", leftFrameWidth);	
		
		return "/ezSchedule/scheduleIndex";
	}

	/**
	 * 일정관리 왼쪽화면 호출함수
	 */
	@RequestMapping(value="/ezSchedule/scheduleLeft.do", method = RequestMethod.GET)
	public String  scheduleLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleLeft started ============");
		
		String funCode = "";	// 일정관리 or 업무관리(3)
		String subCode = "";	// 아직 모름
		int	defaultView = 2;	// 일간, 주간, 월간
		int	startDay = 7;		// 일요일부터 또는 월요일부터
		
        if (request.getParameter("funCode") != null) {
            funCode = request.getParameter("funCode");
        } else {
        	funCode = "1";
        }
        
        if (request.getParameter("subfunction") != null) {
        	subCode = request.getParameter("subfunction");
        } else {
        	subCode = "1";
        }
        
        loginVO = commonUtil.userInfo(loginCookie);
        String userOffset = loginVO.getOffset().split("\\|")[1];
        
		ScheduleConfigVO schConfVO = ezScheduleService.getScheduleConfig(loginVO.getId(), loginVO.getTenantId());
		
		if (schConfVO != null) {
			defaultView = schConfVO.getDefaultView();
			startDay = schConfVO.getStartDay();
		}		
		
		String userID = loginVO.getId();
		String lang = loginVO.getPrimary();
		int tenantID = loginVO.getTenantId();
		String companyID = loginVO.getCompanyID();
		
		List<ScheduleSecretaryVO> pubScheSecVO = ezScheduleService.getPublicScheduleSec(userID, lang, tenantID ,companyID);
		List<ScheduleDeptVO> pubScheDeptVO = ezScheduleService.getPublicScheduleDept(userID, lang, tenantID ,companyID);
		List<ScheduleDeptVO> pubScheDeptVO2 = new ArrayList<ScheduleDeptVO>();
		List<ScheduleCumulerVO> pubScheCumulerVO = ezScheduleService.getPublicScheduleCumuler(userID, lang, tenantID, companyID);
		
		dept_schedule:
			for (ScheduleDeptVO vo : pubScheDeptVO) {
				for (ScheduleCumulerVO vo2 : pubScheCumulerVO) {
					if (vo.getDeptId().equals(vo2.getDeptId())){
						continue dept_schedule;
					}
				}						
				pubScheDeptVO2.add(vo);
			}
		
		// 2023-09-06 조소정 - Left 메뉴에 로그인한 사용자가 소속된 일정그룹 모두 표출
		List<ScheduleGroupListVO> groupList = ezScheduleService.getScheduleGroupList(loginVO.getId(), loginVO.getTenantId() ,companyID);
		
        for (int i = 0; i < groupList.size(); i++) {
        	ScheduleGroupListVO data = groupList.get(i);

        	if(data.getGroupColor() == null) {
        		data.setGroupColor("#e9de13");
        	}
        }
				
		String useWorkspaceSchedule = ezCommonService.getTenantConfig("useWorkspaceSchedule", loginVO.getTenantId());
	    logger.debug("useWorkspaceSchedule : " + useWorkspaceSchedule);

		if (useWorkspaceSchedule == null || useWorkspaceSchedule.equals("")) {
			useWorkspaceSchedule = "NO";
		}

	    String useGoogleCalendar = ezCommonService.getTenantConfig("useGoogleCalendar", loginVO.getTenantId());
	    String isGoogleSync = useGoogleCalendar.equals("YES") ? isGoogleSync(loginVO) : "N";
		List<ScheduleGroupListVO> gatherList = ezScheduleService.getMyGatherList(loginVO.getId(), loginVO.getTenantId(), loginVO.getCompanyID()); // 2023-10-11 임정은 - 일정 모아보기 그룹 리스트 추가
	    
	    // 2025-04-21 조수빈 - 기본 일정 요소별 사용자 설정값
	    List<ScheduleTypeConfigVO> personalScheConfigList = ezScheduleService.getUserScheduleTypeConfig(userID, companyID, tenantID);
	    ObjectMapper objectMapper = new ObjectMapper();
	    String jsonPersonalScheConfigList = "";
	    
	    try {
			jsonPersonalScheConfigList = objectMapper.writeValueAsString(personalScheConfigList);
		} catch (Exception e) {
			logger.debug(e.getMessage());
		}

		model.addAttribute("isGoogleSync", isGoogleSync);
		model.addAttribute("loginVO", loginVO);
		model.addAttribute("groupList", groupList);
		model.addAttribute("scheSec", pubScheSecVO);
		model.addAttribute("scheDept", pubScheDeptVO2);
		model.addAttribute("scheCum", pubScheCumulerVO);
		model.addAttribute("funCode", funCode);
		model.addAttribute("subCode", subCode);
		model.addAttribute("defautView", defaultView);
		model.addAttribute("startDay", startDay);
		model.addAttribute("lang", loginVO.getLang());
		model.addAttribute("userOffset", userOffset);
		model.addAttribute("useWorkspaceSchedule", useWorkspaceSchedule);
		model.addAttribute("gatherList", gatherList);
		model.addAttribute("jsonPersonalScheConfigList", jsonPersonalScheConfigList);

		return "/ezSchedule/scheduleLeft";
	}
	
	/**
	 * 일정관리 휴일 함수 호출 함수
	 */
	@RequestMapping(value = "/ezSchedule/scheduleGetHoliday.do", method = RequestMethod.GET, produces = "text/html; charset=utf-8")
	@ResponseBody
	public String scheduleGetHoliday(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception {
		
		logger.debug("============ scheduleGetHoliday started ============");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String cID = request.getParameter("COMPANYID");
		StringBuilder returnXML = new StringBuilder();
		String isRest = "normal";
		
		if(cID == null) {
			return "";
		}
		
		List<ScheGetHolidayVO> getHoliday = ezScheduleService.getTholiday(cID.trim(), userInfo.getCompanyID(), userInfo.getTenantId(), isRest);
				
		for (int i=0; i<getHoliday.size(); i++ ) {
			returnXML.append(commonUtil.getQueryResult(getHoliday.get(i)));
		}
		
		return "<DATA>" + returnXML.toString() + "</DATA>";
	}
	
	/**
	 * 일정관리 휴일 함수 호출 함수
	 */
	@RequestMapping(value = "/ezSchedule/scheduleGetHolidayJson.do", produces = "application/json; charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public List<ScheGetHolidayVO> scheduleGetHolidayText(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception {
		
		logger.debug("============ scheduleGetHolidayText started ============");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		List<ScheGetHolidayVO> getHoliday = null;
		String isRest = "normal";
		String holidayType = request.getParameter("holidayType");
		
		if (holidayType.equals("a")) {
			String cID = request.getParameter("COMPANYID");
			getHoliday = ezScheduleService.getTholiday(cID.trim(), userInfo.getCompanyID(), userInfo.getTenantId(), isRest);
		} else {
			getHoliday = ezScheduleService.getTholiday("STATUTORY", userInfo.getCompanyID(), userInfo.getTenantId(), isRest);
		}
		
		logger.debug("============ scheduleGetHolidayText ended ============");
		
		return getHoliday;
	}
	
	/**
	 * 일정관리 년도별 휴일 함수 호출 함수
	 */
	@RequestMapping(value = "/ezSchedule/scheduleGetHolidayJsonYear.do", produces = "application/json; charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public List<ScheGetHolidayVO> scheduleGetHolidayYear(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception {
		
		logger.debug("============ scheduleGetHolidayYear started ============");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		List<ScheGetHolidayVO> getHoliday = null;
		String isRest = "normal";
		String holidayType = request.getParameter("holidayType");
		String holidayYear = request.getParameter("holidayYear");		
		String cID = request.getParameter("COMPANYID");
		
		if (holidayType.equals("a")) {
			if (holidayYear.equals("ALL")) {
				getHoliday = ezScheduleService.getTholiday(cID.trim(), userInfo.getCompanyID(), userInfo.getTenantId(), isRest);
			} else {
				getHoliday = ezScheduleService.getTholidayYear(cID.trim(), userInfo.getCompanyID(), userInfo.getTenantId(), isRest, holidayYear);
			}
		}
		
		logger.debug("============ scheduleGetHolidayYear ended ============");
		
		return getHoliday;
	}
	
	/**
	 * 일정관리 일정 데이터 표출 함수
	 */
	@RequestMapping(value = "/ezSchedule/scheduleGetList.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleGetList(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception {
		
		logger.debug("============ scheduleGetList started ============");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);		
		String offSetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
				
		String startDate = request.getParameter("STARTDATE");
		String endDate = request.getParameter("ENDDATE");
		String idList = request.getParameter("IDLIST");
		
		if(startDate == null || endDate == null || idList == null) {
			return "";
		}

		String chk_usersearch = request.getParameter("chk_usersearch");
		String resultUserID = request.getParameter("resultUserID");
		String resultDeptName = request.getParameter("resultDeptName");
		String resultDeptID = request.getParameter("resultDeptID");
		String resultCompanyID = request.getParameter("resultCompanyID");

		if(chk_usersearch !=null) {
			if (chk_usersearch.equals("UserSearch") && "".equals(resultUserID)) {
				return "";
			} else {
				userInfo.setId(resultUserID);
				userInfo.setDeptName(resultDeptName);
				userInfo.setDeptID(resultDeptID);
				userInfo.setCompanyID(resultCompanyID);
			}
		}

		String groupID = request.getParameter("GROUPID");	
		
		StringBuilder sb = new StringBuilder("<DATA>");

		List<ScheduleInfoVO> sList;

		//일정관리 데이터 호출 함수
		if(chk_usersearch !=null) {
			sList = scheduleUserSearchListData(startDate, endDate, idList, groupID, offSetMin, userInfo);
		}else {
			sList = scheduleListData(startDate, endDate, idList, groupID, offSetMin, userInfo);
		}

		Collections.sort(sList, new EzScheduleCompareUtil());
		
		
		for(int j = 0; j < sList.size(); j++){			
			ScheduleInfoVO data = sList.get(j);
			sb.append(commonUtil.getQueryResult(data));
		}
		sb.append("</DATA>");
	
		
		return sb.toString();
	}
	
	/**
	 * 메인화면 일정 데이터 표출 함수
	 */
	@RequestMapping(value = "/ezSchedule/scheduleNewWebPartList.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleNewWebPartList(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception {
		
		logger.debug("============ scheduleNewWebPartList started ============");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);		
		String offSetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
		
		String selectDate = request.getParameter("selectDate");
		String idList = "T";
				
		StringBuilder sb = new StringBuilder("<DATA>");
		//일정관리 데이터 호출 함수
		List<ScheduleInfoVO> sList = scheduleListData(selectDate, selectDate, idList, "", offSetMin, userInfo);
		
		/*Collections.sort(sList, new EzScheduleCompareUtil());	*/	
		
		for(int j = 0; j < sList.size(); j++){			
			ScheduleInfoVO data = sList.get(j);
			sb.append(commonUtil.getQueryResult(data));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}
		
	/**
	 * 일정관리 일정 데이터 표출 함수	 
	 */	
	public List<ScheduleInfoVO> scheduleListData(String startDate, String endDate, String idList, String groupID, String offSetMin, LoginVO userInfo) throws Exception {
		
		logger.debug("============ scheduleListData started ============");		
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
		
		List<ScheduleInfoVO> sList = ezScheduleService.getScheduleList(indiList, pidList, "", utcStartTime, utcEndTime, startDate, endDate, offSetMin, "", "", "", userInfo.getTenantId(), companyID, userInfo.getId(), userInfo.getDeptID(), useAnnualScheduleYN);		
		
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
	 * 일정관리 메인화면 호출함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezSchedule/scheduleMain.do", method = RequestMethod.GET)
	public String  scheduleMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, Locale locale, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleMain started ============");
		
		int	timeZone = 0;
		String deptAdmin = "";
		String companyAdmin = "";				        
        String pOffset = "";        
        String defaultTitle = "";
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", loginVO.getTenantId());
		String groupId = request.getParameter("groupid");
		
		if (groupId == null) {
			groupId = "";
		}

		String userID = loginVO.getId();
		String lang = loginVO.getPrimary();
		int tenantID = loginVO.getTenantId();
		String companyID = loginVO.getCompanyID();
		
		List<ScheduleSecretaryVO> pubScheSecVO = ezScheduleService.getPublicScheduleSec(userID, lang, tenantID ,companyID);
		List<ScheduleDeptVO> pubScheDeptVO = ezScheduleService.getPublicScheduleDept(userID, lang, tenantID ,companyID);
		List<ScheduleDeptVO> pubScheDeptVO2 = new ArrayList<ScheduleDeptVO>();
		List<ScheduleCumulerVO> pubScheCumulerVO = ezScheduleService.getPublicScheduleCumuler(userID, lang, tenantID, companyID);
		        
		dept_schedule:
			for (ScheduleDeptVO vo : pubScheDeptVO) {
				for (ScheduleCumulerVO vo2 : pubScheCumulerVO) {
					if (vo.getDeptId().equals(vo2.getDeptId())){
						continue dept_schedule;
					}
				}						
				pubScheDeptVO2.add(vo);
			}
		
        StringBuilder sb = new StringBuilder();        
                
        for (int i = 0; i < pubScheSecVO.size(); i++) {
        	ScheduleSecretaryVO vo = pubScheSecVO.get(i);
        	sb.append("<option value='" + vo.getSecId() + "' type='user'>" + vo.getSecName() + "</option>");
        }
       
        for (int i = 0; i < pubScheDeptVO2.size(); i++) {
        	ScheduleDeptVO vo = pubScheDeptVO2.get(i);
        	sb.append("<option value='" + vo.getDeptId() + "' type='dept'>[" + msg.getMessage("ezSchedule.t205", locale) + "]" + vo.getDeptName() + "</option>");
        }

        for (int i = 0; i < pubScheCumulerVO.size(); i++) {
        	ScheduleCumulerVO vo = pubScheCumulerVO.get(i);
        	sb.append("<option value='" + vo.getDeptId() + "' type='dept'>[" + msg.getMessage("ezSchedule.t996", locale) + "]" + vo.getTitleName() + "</option>");            
        }
     
        if (commonUtil.isAdmin(loginVO.getId(), loginVO.getTenantId(), loginVO.getRollInfo(), "c;k")) {
            companyAdmin = "Y";
            deptAdmin = "Y";
        } else if (commonUtil.isAdmin(loginVO.getId(), loginVO.getTenantId(), loginVO.getRollInfo(), "g")) {
            deptAdmin = "Y";
        }
        
        int receiveCount = ezScheduleService.getReceiveCount(loginVO.getId(), loginVO.getTenantId() ,loginVO.getCompanyID());
        int groupCount = ezScheduleService.getInviteScheduleGroupCnt(loginVO.getId(), loginVO.getTenantId() ,loginVO.getCompanyID());
        // 일정관리 환경설정 정보
        ScheduleConfigVO scheduleConfigVO = ezScheduleService.getScheduleConfig(loginVO.getId(), loginVO.getTenantId());
        
        int	defaultView = 0;
		int	startDay = 0;
		int	startTime = 0;
		int	endTime = 0;

        if (scheduleConfigVO != null) {
            defaultView	= scheduleConfigVO.getDefaultView();
            startDay	= scheduleConfigVO.getStartDay();
            startTime	= scheduleConfigVO.getStartTime() / 60;
            endTime		= scheduleConfigVO.getEndTime() / 60;
            /* 2018-02-01 김보미 - 일정관리 타이틀 고정 */
            defaultTitle = msg.getMessage("ezSchedule.t133", locale);
            
//            switch (defaultView) {
//	            case 0:
//	                defaultTitle = msg.getMessage("ezSchedule.t140", locale);
//	                break;
//	            case 1:
//	                defaultTitle = msg.getMessage("ezSchedule.t141", locale);
//	            	break;
//	            case 2:
//	                defaultTitle = msg.getMessage("ezSchedule.t142", locale);
//	            	break;
//	           	default:
//	                defaultTitle = msg.getMessage("ezSchedule.t142", locale);
//	           		break;
//            }
        } else {
        	/* 2018-02-01 김보미 - 일정관리 타이틀 고정 */
//        	defaultTitle = msg.getMessage("ezSchedule.t142", locale);
        	defaultTitle = msg.getMessage("ezSchedule.t133", locale);
        	
            defaultView	= 2;
            startDay	= 7;
            startTime	= 540 / 60;
            endTime		= 1080 / 60;
        }
        // 일정 그룹 목록
        List<ScheduleGroupListVO> groupList = ezScheduleService.getScheduleGroupList(loginVO.getId(), loginVO.getTenantId() ,companyID);
        
        StringBuilder sbGroup = new StringBuilder("<DATA>");
        
        for (int k=0; k < groupList.size(); k++) {
        	ScheduleGroupListVO vo = groupList.get(k);        	
        	sbGroup.append(commonUtil.getQueryResult(vo));
        }
        sbGroup.append("</DATA>");
        
        String groupXml = sbGroup.toString();	
        String groupXmlTemp = groupXml.replace("\"", "&quot;");
        String otherId = request.getParameter("otherid");
        String idList = "";
        String idType = "T";        
        String idTypeTmp = request.getParameter("idtype");
        
        if (idTypeTmp != null) {
        	idTypeTmp = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(idTypeTmp));
        }
        
        //2018-06-07 구해안checkbox 값을 가져와서 char[]에 담기
        String idTypeChk = request.getParameter("idTypeChk");
        @SuppressWarnings("unused")
		char[] chk_array = null;
        if(idTypeChk != null && !idTypeChk.equals("")){
        	
        	chk_array = new char[idTypeChk.length()];
        }
        
        if (otherId != null && !otherId.equals("")) {        	
            idList = otherId;
            
            if (idTypeTmp != null && !idTypeTmp.equals("")) {
            	idType = idTypeTmp;	
            }
            
        } else if (idTypeTmp != null && !idTypeTmp.equals("")) {
        	idType = idTypeTmp;
          //2018-06-07 구해안 id값을 통째로 넘기기 때문에 다른 경우는 삭제하고 처음 시작할때 전체일정 뿌리도록 T만 남김	
            switch (idType) {
                case "T":
                    idList = "T";
                    break;
                default:
                	idList = idType;
                    break;
            }
            //2018-06-07 구해안  check 값 가져오기
        } else if (idTypeChk != null && !idTypeChk.equals("")){        	
        	idList = idTypeChk;
        }
        
        List<String> publicIds = pubScheDeptVO2.stream().map(s -> s.getDeptId()).collect(Collectors.toList());
        JSONArray jsonArray = new JSONArray();
        for (int j = 0; j < publicIds.size(); j++) {
        	JSONObject obj = new JSONObject();
			obj.put("id", publicIds.get(j));
			jsonArray.add(j, obj);
		}
        pOffset = loginVO.getOffset().split("\\|")[1];      
        timeZone = (Integer.parseInt(pOffset.split(":")[0]) * 60) + Integer.parseInt(pOffset.split(":")[1]);

        //2018-10-29 김혜정
        String useScheduleIcs = ezCommonService.getTenantConfig("useScheduleIcs", loginVO.getTenantId());
        //2020-02-24 김정언
      	String useAnnualScheduleYN = ezCommonService.getTenantConfig("useAnnualScheduleYN", loginVO.getTenantId());
      	
      	String workspaceHostUrl = ezCommonService.getTenantConfig("workspaceHostUrl", loginVO.getTenantId());
        
      	/* 2025-03-13 홍승비 - 협업 모듈에 고정된 하드코딩 문자열 제거 (ezWorkspace), 테넌트 컨피그 workspaceAppPath로 협업 웹응용프로그램 경로를 분리하여 사용 ("" 또는 "/ezWork" 등) */
		String workspaceAppPath = ezCommonService.getTenantConfig("workspaceAppPath", loginVO.getTenantId());
		List<ScheduleTypeConfigVO> personalScheConfigList = ezScheduleService.getUserScheduleTypeConfig(userID, companyID, tenantID);
		ObjectMapper objectMapper = new ObjectMapper();
		String jsonPersonalScheConfigList = "";
	    
		try {
			jsonPersonalScheConfigList = objectMapper.writeValueAsString(personalScheConfigList);
		} catch (Exception e) {
			logger.debug(e.getMessage());
		}
		
        model.addAttribute("userInfo",		loginVO);
        model.addAttribute("pOffset",		pOffset);
        model.addAttribute("timeZoneStr",	timeZone);
        model.addAttribute("receiveCount",	receiveCount);
        model.addAttribute("groupCount",	groupCount);
        model.addAttribute("deptAdmin",		deptAdmin);
        model.addAttribute("companyAdmin",	companyAdmin);
        model.addAttribute("idType",		idType);
        model.addAttribute("otherId",		otherId);
        model.addAttribute("groupId",		groupId);
        model.addAttribute("groupXmlTemp",	groupXmlTemp);
        model.addAttribute("idList",		idList);
        model.addAttribute("startTime",		startTime);
        model.addAttribute("endTime",		endTime);
        model.addAttribute("defaultView",	defaultView);
        model.addAttribute("startDay",		startDay);
        model.addAttribute("useEditor",		useEditor);
        model.addAttribute("defaultTitle",	defaultTitle);
        model.addAttribute("shareList",		sb.toString());
        model.addAttribute("useScheduleIcs",useScheduleIcs);
        model.addAttribute("publicIds",jsonArray);
        model.addAttribute("useAnnualScheduleYN", useAnnualScheduleYN);
        model.addAttribute("workspaceHostUrl", workspaceHostUrl);
        model.addAttribute("workspaceAppPath", workspaceAppPath);
        model.addAttribute("jsonPersonalScheConfigList", jsonPersonalScheConfigList);
        
		return "/ezSchedule/scheduleMain";
	}
	
	/**
	 * 일정그룹관리 메인화면
	 */
	@RequestMapping(value="/ezSchedule/scheduleManageGroup.do", method = RequestMethod.GET)
	public String scheduleManageGroup(@CookieValue("loginCookie") String loginCookie, Model model, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleManageGroup started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		String use_ocs = ezCommonService.getTenantConfig("USE_OCS", loginSimpleVO.getTenantId());
	
		model.addAttribute("use_ocs", use_ocs);
		
		return "/ezSchedule/scheduleManageGroup";
	}
	
	/**
	 * 일정그룹관리 그리드 리스트
	 */
	@RequestMapping(value="/ezSchedule/scheduleGroupList.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleGroupList(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleGroupList started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);

		
		List<ScheduleGroupVO> myList = new ArrayList<ScheduleGroupVO>();
		
		// 2023-09-06 조소정 - 일정 그룹 관리 > 로그인한 사용자가 그룹장인 일정그룹 표출
	    myList = ezScheduleService.getMyGroupList(loginSimpleVO.getId(), loginSimpleVO.getTenantId(),loginSimpleVO.getCompanyID());
		
		
		
		StringBuilder result = new StringBuilder("<LISTVIEWDATA>");
		result.append("<HEADERS><HEADER><NAME>CHECK</NAME><WIDTH>10%</WIDTH></HEADER>");
        result.append("<HEADER><NAME>" + msg.getMessage("ezSchedule.t159", loginSimpleVO.getLocale()) + "</NAME><WIDTH>60%</WIDTH></HEADER>");
        result.append("<HEADER><NAME>" + msg.getMessage("ezSchedule.t00002", loginSimpleVO.getLocale()) + "</NAME><WIDTH>40%</WIDTH></HEADER></HEADERS>");
        result.append("<ROWS>");
		
        for (int i = 0; i < myList.size(); i++) {
        	ScheduleGroupVO data = myList.get(i);
        	
        	if (data.getGroupColor() == null) {
        		data.setGroupColor("#e9de13");
        	}
        	
        	result.append("<ROW>");
            result.append("<CELL>");
            result.append("<VALUE>CHECK</VALUE>");
            result.append("<DATA1>" + data.getGroupId() + "</DATA1>");
            result.append("<DATA2><![CDATA[" + data.getDescription() + "]]></DATA2>");
            result.append("<DATA3><![CDATA[" + data.getGroupColor() + "]]></DATA3>");
            result.append("</CELL>");
            result.append("<CELL>");
            
            int myMemberListCnt = ezScheduleService.getMyGroupMemberListCnt(data.getGroupId(), loginSimpleVO.getLang(), loginSimpleVO.getTenantId(),loginSimpleVO.getCompanyID());
            String cDate = commonUtil.getDateStringInUTC(data.getCreateDate(),loginSimpleVO.getOffset(),false).substring(0,10);
            
            // 2023-08-10 황인경 - 관리자 > 일정관리 > 일정그룹관리 > 인원수 다국어 단/복수 처리
            if (myMemberListCnt > 1) {
            	result.append("<VALUE><![CDATA[" + data.getGroupName() + " (" + myMemberListCnt + msg.getMessage("ezSchedule.hik01", loginSimpleVO.getLocale()) + ")" + "]]></VALUE>");
            } else {
            	result.append("<VALUE><![CDATA[" + data.getGroupName() + " (" + myMemberListCnt + msg.getMessage("ezSchedule.t00003", loginSimpleVO.getLocale()) + ")" + "]]></VALUE>");
            }

            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + cDate + "</VALUE>");
            result.append("</CELL>");
            result.append("</ROW>");
        }
        result.append("</ROWS>");
        result.append("</LISTVIEWDATA>");
		
		return result.toString();
	}
	
	/**
	 * 일정그룹관리 리스트 상세화면
	 */
	@RequestMapping(value="/ezSchedule/getGroupDetail.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getGroupDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO loginVO) throws Exception {
		
		logger.debug("============ getGroupDetail started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		String gID = request.getParameter("groupID");
		String xmlResult = ezScheduleService.getMyGroupMemberList(gID, loginVO.getPrimary(), loginVO.getTenantId() ,loginVO.getCompanyID());
		
		return xmlResult;
	}
	
	/**
	 * 일정그룹관리 리스트 삭제
	 */
	@RequestMapping(value="/ezSchedule/scheduleDelGroup.do", method = RequestMethod.POST)	
	@ResponseBody
	public void scheduleDelGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleDelGroup started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String groupID = request.getParameter("groupID");
		String gIDs[] = groupID.split(";");
		
		for (int i = 0; i < gIDs.length; i++) {
			ezScheduleService.deleteScheduleGroup(gIDs[i], loginSimpleVO.getTenantId());
		}		
	}
	
	/**
	 * 일정그룹관리 멤버 팝업
	 * 
	 */
	@RequestMapping(value="/ezSchedule/scheduleGroupMember.do", method = RequestMethod.GET)	
	public String scheduleGroupMember(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleGroupMember started ============");

		loginVO = commonUtil.userInfo(loginCookie);
		
		String groupID = request.getParameter("groupID");
		String groupColor = request.getParameter("groupColor");
		String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());

		List<ScheduleGroupListVO> mList = ezScheduleService.getGroupMemberList(groupID, loginVO.getPrimary(),loginVO.getTenantId(), offSetMin ,loginVO.getCompanyID());

		String primaryData = "";
		if (commonUtil.getPrimaryData(loginVO.getLang(), loginVO.getTenantId()).equals("1")) {
			primaryData = "1";
		} else {
			primaryData = "2";
		}

		model.addAttribute("primaryData", primaryData);
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("loginUserId", loginVO.getId());
		model.addAttribute("loginUserName",loginVO.getDisplayName());
		model.addAttribute("loginUserName2", loginVO.getDisplayName2());
		model.addAttribute("loginUserRoll",loginVO.getRollInfo());
		model.addAttribute("groupID", groupID);
		model.addAttribute("groupColor", groupColor);
		model.addAttribute("memberList", mList);
		model.addAttribute("groupName", mList.get(0).getGroupName().replace("\\", "&#92;"));
		model.addAttribute("description",mList.get(0).getDescription().replace("\\", "&#92;"));
		
		return "/ezSchedule/scheduleGroupMember";
	}
	

	/**
	 * 일정그룹관리 멤버 제외 버튼 클릭 시
	 */
	@RequestMapping(value="/ezSchedule/scheduleDelMember.do", method = RequestMethod.POST)
	@ResponseBody
	public void scheduleDelMember(@RequestParam(value="memberID[]") String[] member, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleDelMember started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String groupID = request.getParameter("groupID");
		
		for (int i=0; i < member.length; i++) {			
			ezScheduleService.deleteScheduleMember(groupID, member[i], loginSimpleVO.getTenantId());
		}
	}
	
	/**
	 * 일정그룹관리 관리권한 양도 버튼 클릭 시 
	 */
	@RequestMapping(value="/ezSchedule/scheduleGiveManagement.do", method = RequestMethod.POST)
	@ResponseBody
	public void scheduleGiveManagement(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginSimpleVO loginSimpleVO, String loginUserId, String loginUserName, String loginUserName2) throws Exception {
		
		logger.debug("============ scheduleGiveManagement started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String groupID = request.getParameter("groupID");
		
		String memberId = request.getParameter("memberID");
		
		String memberName = request.getParameter("memberNAME");
		
		String memberName2 = request.getParameter("memberNAME2");
		
		
		ezScheduleService.updateManageScheduleMember(groupID, memberId, memberName, memberName2, loginSimpleVO.getTenantId(), loginUserId, loginUserName, loginUserName2);
			
		
	}
	
	/**
	 * 일정그룹관리 멤버 재요청 버튼 클릭 시
	 */
	@RequestMapping(value="/ezSchedule/scheduleUpdateMember.do", method = RequestMethod.POST)
	@ResponseBody
	public void scheduleUpdateMember(@RequestParam(value="memberID[]") String[] member, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleUpdateMember started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String groupID = request.getParameter("groupID");
		String status = request.getParameter("status");
		
		for (int i=0; i < member.length; i++) {			
			ezScheduleService.updateScheduleMember(groupID, member[i], status, loginSimpleVO.getTenantId());
		}
	}
	
	@RequestMapping(value="/ezSchedule/scheduleUpdateAttendant.do", method = RequestMethod.POST)
	@ResponseBody
	public void scheduleUpdateAttendant(@RequestParam(value="memberID[]") String[] member, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleUpdateAttendant started ============");		
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String scheduleId = request.getParameter("scheduleId");
		String status = request.getParameter("status");
		
		for (int i=0; i < member.length; i++) {	
			ezScheduleService.updateAttendantStatus(scheduleId, member[i], status, loginSimpleVO.getTenantId());
		}		
	}
	
	/**
	 * 일정그룹관리 멤버 선택 팝업 창
	 */
	@RequestMapping(value = "/ezSchedule/scheduleSelectAttendant.do", method = RequestMethod.GET)
	public String scheduleSelectAttendant(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleSelectAttendant started ============");
		
        String title = request.getParameter("title");
        String startTime = request.getParameter("StartTime");
        String endTime = request.getParameter("EndTime");
        String gubun = request.getParameter("gubun");
        String type = request.getParameter("type");
        String pSearchString = request.getParameter("searchString");
        String userID = request.getParameter("ownerid");
        String groupID = request.getParameter("groupID") != null ? request.getParameter("groupID") : "";
        String groupOwnerID = "";
		String cn = request.getParameter("cn") != null ? request.getParameter("cn") : "";
				    		
		if (title == null) title = "";		
		if (startTime == null) startTime = "";
		if (endTime == null) endTime = "";
		if (gubun == null) gubun = "";
		if (type == null) type = "";
		if (pSearchString == null) pSearchString = "";
		
		loginVO = commonUtil.userInfo(loginCookie);
		String use_ocs = ezCommonService.getTenantConfig("USE_OCS", loginVO.getTenantId());
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", loginVO.getTenantId());
		
		if (userID == null || userID.equals("")) userID = loginVO.getId();
		
		List<ScheduleGroupListVO> mList = new ArrayList<>();
		String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());

		/* 2023-07-19 홍승비 - 일정그룹관리로 접근한 경우, 해당 일정그룹의 관리자(그룹장) USERID 추가 (그룹관리가 아니라면 공백 리턴) */
		if (type.equalsIgnoreCase("group") && !groupID.equals("")) {
			groupOwnerID = ezScheduleService.getScheduleGroupCreatorID(groupID);
			mList = ezScheduleService.getGroupMemberList(groupID, loginVO.getPrimary(),loginVO.getTenantId(), offSetMin ,loginVO.getCompanyID());
		}
		
		model.addAttribute("title", title);
		model.addAttribute("startTime", startTime);
		model.addAttribute("endTime", endTime);
		model.addAttribute("gubun", gubun);
		model.addAttribute("type", type);
		model.addAttribute("pSearchString", pSearchString);
		model.addAttribute("use_ocs", use_ocs);
		model.addAttribute("userID", userID);
		model.addAttribute("deptID", loginVO.getDeptID());
		model.addAttribute("companyID", loginVO.getCompanyID());
		model.addAttribute("primaryLang", primaryLang);
		model.addAttribute("lang", loginVO.getPrimary());
		model.addAttribute("groupOwnerID", groupOwnerID);
		model.addAttribute("mList", mList);
		model.addAttribute("executive", cn);
		
		return "ezSchedule/scheduleSelectAttendant";
	}	
	
	/**
	 * 일정그룹관리 멤버 추가 
	 */
	@RequestMapping(value = "/ezSchedule/scheduleAddMember.do", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public void scheduleAddMember(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleAddMember started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		String groupId = request.getParameter("groupID");
		String memberList = request.getParameter("memberList");
		String displayName = request.getParameter("displayName");
		String displayName2 = request.getParameter("displayName2");

		JSONParser parser = new JSONParser();
		JSONArray jsonArray = (JSONArray)parser.parse(memberList);
		
		String dotNetTotalNotification = ezCommonService.getTenantConfig("dotNetTotalNotification", loginVO.getTenantId());
	    logger.debug("dotNetTotalNotification=" + dotNetTotalNotification);
		
		for(int i = 0; i < jsonArray.size(); i++) {
			JSONObject obj = (JSONObject) jsonArray.get(i);
			
			String memberId = (String) obj.get("memberID");
			String memberName = (String) obj.get("memberName1");
			String memberName2 = (String) obj.get("memberName2");
			String writePermission = (String) obj.get("writePermission");
			String memberDeptId = (String) obj.get("memberDeptId");
			
			ezScheduleService.insertScheduleGroupMember(groupId, memberId, memberName, memberName2, memberDeptId, loginVO.getTenantId(), writePermission);
			
			ScheduleGroupListVO scheduleGroup = ezScheduleService.selectScheduleGroupInfo(groupId, loginVO.getTenantId());
			String groupName = scheduleGroup.getGroupName();
			String description = scheduleGroup.getDescription();
			//KT텔레캅 통합알람 푸쉬 코드
		    if(dotNetTotalNotification.equalsIgnoreCase("yes")) {
		    	try {
		    		String resultCode = "";
		    		String serverFlag = "dotNet";
		    		String serverDomain = request.getServerName();
		    		
					String groupMemberIdParam = "userId=" + URLEncoder.encode(memberId, "UTF-8");
					String mainTypeParam = "type=" + URLEncoder.encode("schedule", "UTF-8");
					String subTypeParam = "subType=" + URLEncoder.encode("attendant", "UTF-8");
					String senderIdParam = "senderId=" + URLEncoder.encode(loginVO.getId(), "UTF-8");
					String senderNameParam = "";
					if (loginVO.getLang().equals("1")) {
				    	 senderNameParam = "senderName=" + URLEncoder.encode(displayName, "UTF-8");
				     } else { 
				    	 senderNameParam = "senderName=" + URLEncoder.encode(displayName2, "UTF-8");
				     }
					String subjectParam = "subject=" + URLEncoder.encode("["+groupName+"] " + description, "UTF-8");
					String etcDataParam = "etcData=";
					String linkURLParam = "linkURL=" + URLEncoder.encode(request.getScheme() + "://" +  serverDomain + "/ezConn/scheduleReceiveMember.do?serverFlag="+serverFlag, "UTF-8");
					String mobileLinkURLParam = "mobileLinkURL=" + URLEncoder.encode("/Schedule/schedule_receive_member.aspx", "UTF-8");
					String viewTypeParam = "viewType=" + URLEncoder.encode("popup", "UTF-8");
					String viewWidthParam = "viewWidth=" + URLEncoder.encode("730", "UTF-8");
					String viewHeightParam = "viewHeight=" + URLEncoder.encode("370", "UTF-8");
					
					String inputParams = groupMemberIdParam + "&" + mainTypeParam + "&" + subTypeParam + "&" + senderIdParam + "&";
						   inputParams += senderNameParam + "&" + subjectParam + "&" + etcDataParam + "&" + linkURLParam + "&";
						   inputParams += mobileLinkURLParam + "&" + viewTypeParam + "&" + viewWidthParam + "&" + viewHeightParam; 

					logger.debug("inputParams=" + inputParams);

					String requestURL = config.getProperty("config.JGwServerURL") + "/ezTalkGate/addNotificationETC";
					String webServiceResultResponse = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

					logger.debug("response=" + webServiceResultResponse);

					if (webServiceResultResponse != null) {
						JSONParser jsonParser = new JSONParser();
						JSONObject responseObj = (JSONObject)jsonParser.parse(webServiceResultResponse);

						resultCode = (String)responseObj.get("resultCode");
						logger.debug("resultCode=" + resultCode);
					}
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
		    }
		}
	}
	
	/**
	 * 일정그룹관리 그룹 추가 팝업
	 */
	@RequestMapping(value="/ezSchedule/scheduleGroupWrite.do", method = RequestMethod.GET)
	public String scheduleGroupWrite(@CookieValue("loginCookie") String loginCookie, Model model, LoginVO loginVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleGroupWrite started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		String use_ocs = ezCommonService.getTenantConfig("USE_OCS", loginVO.getTenantId());
		String groupColor = request.getParameter("groupColor");
		String type = request.getParameter("type");

		model.addAttribute("use_ocs", use_ocs);
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("groupColor", groupColor);
		model.addAttribute("type", type);
		
		return "/ezSchedule/scheduleGroupWrite";
	}
	
	
	/**
	 * 일정그룹관리 그룹 추가 팝업 > 부서선택 클릭 시
	 */
	@RequestMapping(value="/ezSchedule/getDeptUserList.do", method = RequestMethod.GET, produces = "text/xml;charset=UTF-8")
	@ResponseBody
	public String getDeptUserList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO loginVO) throws Exception {
		
		logger.debug("============ getDeptUserList started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		String deptId = request.getParameter("deptID");
		String subDept = request.getParameter("subDept");		
		
		String result = ezScheduleService.getDeptMemberList(deptId, subDept, loginVO.getPrimary(), loginVO.getTenantId() ,loginVO.getCompanyID());
				
		return result;
	}
	
	
	/** 일정그룹 그룹명,설명 수정(저장) 버튼 클릭시 
	 * 
	 */
	@RequestMapping(value="/ezSchedule/scheduleModifyGroup.do", method = RequestMethod.POST)
	@ResponseBody
	public void scheduleModifyGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleModifyGroup started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		String groupId = request.getParameter("groupId");	
		String groupName = request.getParameter("groupName");
		String description = request.getParameter("description");
		String displayName = request.getParameter("displayName");
		String displayName2 = request.getParameter("displayName2");		
		String groupColor = request.getParameter("groupColor");

		

		ezScheduleService.updateScheduleGroup(groupId, loginVO.getId(), displayName, displayName2, groupName, description, loginVO.getTenantId() ,loginVO.getCompanyID(), groupColor);
		
		
	}
	
	/**
	 * 일정그룹관리 그룹 추가 팝업 > 그룹등록 확인 클릭 시
	 */
	@RequestMapping(value="/ezSchedule/scheduleSaveGroup.do", method = RequestMethod.POST)
	@ResponseBody
	public void scheduleSaveGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleSaveGroup started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		String gUID = UUID.randomUUID().toString().toUpperCase();		
		String groupName = request.getParameter("groupName");
		String description = request.getParameter("description");
		String displayName = request.getParameter("displayName");
		String displayName2 = request.getParameter("displayName2");		
		String memberList = request.getParameter("memberList");
		String groupColor = request.getParameter("groupColor");
		
		ezScheduleService.insertScheduleGroup(gUID, loginVO.getId(), displayName, displayName2, groupName, description, loginVO.getTenantId() ,loginVO.getCompanyID(), groupColor);

		JSONParser parser = new JSONParser();
		JSONArray jsonArray = (JSONArray)parser.parse(memberList);
		
		//KT텔레캅 통합알람 푸쉬 코드
	    String dotNetTotalNotification = ezCommonService.getTenantConfig("dotNetTotalNotification", loginVO.getTenantId());
	    logger.debug("dotNetTotalNotification=" + dotNetTotalNotification);
		
		for(int i = 0; i < jsonArray.size(); i++) {
			JSONObject obj = (JSONObject) jsonArray.get(i);
			
			String memberId = (String) obj.get("memberID");
			String memberName = (String) obj.get("memberName1");
			String memberName2 = (String) obj.get("memberName2");
			String writePermission = (String) obj.get("writePermission");
			String memberDeptId = (String) obj.get("memberDeptId");
			
			ezScheduleService.insertScheduleGroupMember(gUID, memberId, memberName, memberName2, memberDeptId, loginVO.getTenantId(), writePermission);
			
			//KT텔레캅 통합알람 푸쉬 코드
		    if(dotNetTotalNotification.equalsIgnoreCase("yes")) {
		    	try {
		    		String resultCode = "";
		    		String serverFlag = "dotNet";
		    		//String serverDomain = config.getProperty("");
		    		String serverDomain = request.getServerName();
		    		
					String groupMemberIdParam = "userId=" + URLEncoder.encode(memberId, "UTF-8");
					String mainTypeParam = "type=" + URLEncoder.encode("schedule", "UTF-8");
					String subTypeParam = "subType=" + URLEncoder.encode("attendant", "UTF-8");
					String senderIdParam = "senderId=" + URLEncoder.encode(loginVO.getId(), "UTF-8");
					String senderNameParam = "";
					if (loginVO.getLang().equals("1")) {
				    	 senderNameParam = "senderName=" + URLEncoder.encode(displayName, "UTF-8");
				     } else { 
				    	 senderNameParam = "senderName=" + URLEncoder.encode(displayName2, "UTF-8");
				     }
					String subjectParam = "subject=" + URLEncoder.encode("["+groupName+"] " + description, "UTF-8");
					String etcDataParam = "etcData=";
					String linkURLParam = "linkURL=" + URLEncoder.encode(request.getScheme() + "://" +  serverDomain + "/ezConn/scheduleReceiveMember.do?serverFlag="+serverFlag, "UTF-8");
					String mobileLinkURLParam = "mobileLinkURL=" + URLEncoder.encode("/Schedule/schedule_receive_member.aspx", "UTF-8");
					String viewTypeParam = "viewType=" + URLEncoder.encode("popup", "UTF-8");
					String viewWidthParam = "viewWidth=" + URLEncoder.encode("730", "UTF-8");
					String viewHeightParam = "viewHeight=" + URLEncoder.encode("370", "UTF-8");
					
					String inputParams = groupMemberIdParam + "&" + mainTypeParam + "&" + subTypeParam + "&" + senderIdParam + "&";
						   inputParams += senderNameParam + "&" + subjectParam + "&" + etcDataParam + "&" + linkURLParam + "&";
						   inputParams += mobileLinkURLParam + "&" + viewTypeParam + "&" + viewWidthParam + "&" + viewHeightParam; 

					logger.debug("inputParams=" + inputParams);

					String requestURL = config.getProperty("config.JGwServerURL") + "/ezTalkGate/addNotificationETC";
					String webServiceResultResponse = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

					logger.debug("response=" + webServiceResultResponse);

					if (webServiceResultResponse != null) {
						JSONParser jsonParser = new JSONParser();
						JSONObject responseObj = (JSONObject)jsonParser.parse(webServiceResultResponse);

						resultCode = (String)responseObj.get("resultCode");
						logger.debug("resultCode=" + resultCode);
					}
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
		    }
		}
	}
	
	/**
	 * 일정그룹관리 작성 권한 저장
	 */
	@RequestMapping(value="/ezSchedule/scheduleSaveWritePermission.do", method = RequestMethod.POST)
	@ResponseBody
	public void scheduleSaveWritePermission(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> data, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleSaveWritePermission started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
	    String groupId = (String) data.get("groupId");
	    @SuppressWarnings("unchecked")
		List<Map<String, String>> memberList = (List<Map<String, String>>) data.get("memberList");
		
		ezScheduleService.updateScheduleWritePermission(groupId, memberList, loginVO.getTenantId());
	}
	
	/**
	 * 일정검색
	 */
	@RequestMapping(value="/ezSchedule/scheduleSearch.do", method = RequestMethod.GET)	
	public String scheduleSearch(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleSearch started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		List<ScheduleInfoVO> sList = null;
		String filter = request.getParameter("filter");
		String startDate = request.getParameter("sdate");
		String endDate = request.getParameter("edate");
		String all = request.getParameter("pAll");
		String title = request.getParameter("pTitle");
		String location = request.getParameter("pLocation");
		
		String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());
		String indiList = "'" + loginVO.getId() + "'";
		//2020-02-24 김정언
		String useAnnualScheduleYN = ezCommonService.getTenantConfig("useAnnualScheduleYN", loginVO.getTenantId());
		
		List<ScheduleSecretaryVO> tList = ezScheduleService.getPublicScheduleSec(loginVO.getId(), loginVO.getPrimary(), loginVO.getTenantId() ,loginVO.getCompanyID());
		
		for(int i = 0; i < tList.size(); i++){
			if(i == 0){
				indiList += ",";
			}			
			ScheduleSecretaryVO data = tList.get(i);			
			indiList += "'" + data.getSecId() + "'";
			
			if(i != tList.size()-1){
				indiList += ",";
			}	
		}
		
		String pidList = "'" + loginVO.getDeptID() + "'," + "'" + loginVO.getCompanyID() + "'";
		//////////////////2018-03-02김은석
		String chkStartDate = "";
		String chkEndDate = "";
		
		if (filter != null && !filter.equals("")) {			
			String utcStartTime = "";
			String utcEndTime = "";

			if (startDate == null) startDate = "";
			if (endDate == null) endDate = "";			
			//////////////////2018-03-02김은석
			chkStartDate = startDate;
			chkEndDate = endDate;
			
			if ((startDate == null || startDate.equals("") || endDate == null || endDate.equals(""))) {
				String utcTime = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date now = sdf.parse(utcTime);
				
				Calendar cal = Calendar.getInstance();
				cal.setTime(now);
				
				cal.add(Calendar.MONTH, -3);
				startDate = commonUtil.getDateStringInUTC(sdf.format(cal.getTime()), loginVO.getOffset(), false).substring(0, 10);
				
				cal.setTime(now);
				cal.add(Calendar.MONTH, 3);
				endDate = commonUtil.getDateStringInUTC(sdf.format(cal.getTime()), loginVO.getOffset(), false).substring(0, 10);
			}
			
			startDate = startDate + " 00:00:00";
			endDate = endDate + " 23:59:59";
			utcStartTime = commonUtil.getDateStringInUTC(startDate, loginVO.getOffset(), true);
			utcEndTime = commonUtil.getDateStringInUTC(endDate, loginVO.getOffset(), true);
			
			List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(loginVO.getId(), loginVO.getTenantId() , loginVO.getCompanyID());
			
			for(int i = 0; i < gList.size(); i++){
				if(i == 0){
					pidList += ",";
				}			
				ScheduleGroupListVO data = gList.get(i);			
				pidList += "'" + data.getGroupId() + "'";
				
				if(i != gList.size()-1){
					pidList += ",";
				}	
			}
			
			List<ScheduleDeptVO> dList = ezScheduleService.getPublicScheduleDept(loginVO.getId(), loginVO.getPrimary(), loginVO.getTenantId(), loginVO.getCompanyID());
			
			for(int i = 0; i < dList.size(); i++){
				if(i == 0){
					pidList += ",";
				}			
				ScheduleDeptVO data = dList.get(i);			
				pidList += "'" + data.getDeptId() + "'";
				
				if(i != dList.size()-1){
					pidList += ",";
				}	
			}
			
			List<ScheduleCumulerVO> cList = ezScheduleService.getPublicScheduleCumuler(loginVO.getId(), loginVO.getPrimary(), loginVO.getTenantId(), loginVO.getCompanyID());
			
			for(int i = 0; i < cList.size(); i++){
				if(i == 0){
					pidList += ",";
				}			
				ScheduleCumulerVO data = cList.get(i);			
				pidList += "'" + data.getDeptId() + "'";
				
				if(i != cList.size()-1){
					pidList += ",";
				}	
			}			
			
			sList = ezScheduleService.getScheduleList(indiList, pidList, filter.trim(), utcStartTime, utcEndTime, startDate, endDate, offSetMin, title, location, all, loginVO.getTenantId(), loginVO.getCompanyID(), loginVO.getId(), loginVO.getDeptID(), useAnnualScheduleYN);
			
			String useGoogleCalendar = ezCommonService.getTenantConfig("useGoogleCalendar", loginVO.getTenantId());
			if(useGoogleCalendar.equals("YES")) {
				String gKeyword = all == null || all.trim().equals("") ? title : all;
				List<ScheduleInfoVO> googleList = googleService.getGoogleScheduleList(startDate, endDate, gKeyword, loginVO, loginVO.getId(), "member", loginVO.getDisplayName());		
				if(filter.trim().equals("location")) {
					final String gKeyword2 = location.trim();
					googleList = googleList.stream().filter(x -> x.getLocation() != null && x.getLocation().contains(gKeyword2)).collect(Collectors.toList());
				}
				sList.addAll(googleList);
			}
			
			Collections.sort(sList, new EzScheduleCompareUtilPublic());
			
			startDate = startDate.substring(0,10);
			endDate = endDate.substring(0,10);
			//////////////////2018-03-02김은석
			if (chkStartDate.equals("") && !chkStartDate.equals(startDate)) {
				startDate = chkStartDate;
				endDate = chkEndDate;
			}
		}
		
		
		model.addAttribute("offSetMin", offSetMin);
		model.addAttribute("filter", filter);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("lang", loginVO.getLang());
		model.addAttribute("primary", loginVO.getPrimary());
		model.addAttribute("scheduleList", sList);
		
		return "/ezSchedule/scheduleSearch";
	}
	
	/**
	 * 공개일정검색
	 */
	@RequestMapping(value="/ezSchedule/schedulePublicSearch.do", method = RequestMethod.GET)	
	public String schedulePulbicSearch(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO loginVO) throws Exception {
		
		logger.debug("============ schedulePulbicSearch started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		List<ScheduleInfoVO> sList = null;
		String idList = request.getParameter("idlist");
		String nameList = request.getParameter("namelist");
		String startDate = request.getParameter("sdate");
		String endDate = request.getParameter("edate");
		String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());
		//2020-02-24 김정언
		String useAnnualScheduleYN = ezCommonService.getTenantConfig("useAnnualScheduleYN", loginVO.getTenantId());
		
		if (idList != null && !idList.equals("")) {			
			String utcStartTime = "";
			String utcEndTime = "";
			
			if (nameList == null) nameList = "";
			if (startDate == null) startDate = "";
			if (endDate == null) endDate = "";			
			
			if (startDate == null || startDate.equals("") || endDate == null || endDate.equals("")) {
				String utcTime = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");					
				startDate = commonUtil.getDateStringInUTC(utcTime, loginVO.getOffset(), false).substring(0, 10);
				endDate = startDate;				
			}			
			startDate = startDate + " 00:00:00";
			endDate = endDate + " 23:59:59";
			
			utcStartTime = commonUtil.getDateStringInUTC(startDate, loginVO.getOffset(), true);
			utcEndTime = commonUtil.getDateStringInUTC(endDate, loginVO.getOffset(), true);
			
			String[] idArr = idList.split(",");
			String userIDList = "";
			
			for (int i=0; i < idArr.length; i++) {
				userIDList += "'" + idArr[i] +"'";
				
				if (i < idArr.length-1) {
					userIDList += ",";
				}
			}			
			sList = ezScheduleService.getScheduleList(userIDList, "\'\'", "IsPublic", utcStartTime, utcEndTime, startDate, endDate, offSetMin, "", "", "", loginVO.getTenantId(), loginVO.getCompanyID(), loginVO.getId(), loginVO.getDeptID(), useAnnualScheduleYN);
			
			Collections.sort(sList, new EzScheduleCompareUtilPublic());
			
			startDate = startDate.substring(0,10);
			endDate = endDate.substring(0,10);
		}		
		model.addAttribute("offSetMin", offSetMin);
		model.addAttribute("idList", idList);
		model.addAttribute("nameList", nameList);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("lang", loginVO.getLang());
		model.addAttribute("primary", loginVO.getPrimary());
		model.addAttribute("scheduleList", sList);
		
		return "/ezSchedule/schedulePublicSearch";
	}
	
	/**
	 * 공개일정검색 > 대상자선택
	 */
	@RequestMapping(value="/ezSchedule/scheduleSelectEntity.do", method = RequestMethod.GET)
	public String scheduleSelectEntity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleSelectEntity started ============");
		
		String title = request.getParameter("title");
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");
        String pSearchString = request.getParameter("searchString");
				    		
		if (title == null) title = "";
		if (startTime == null) startTime = "";
		if (endTime == null) endTime = "";
		if (pSearchString == null) pSearchString = "";
		
		loginVO = commonUtil.userInfo(loginCookie);
		String use_ocs = ezCommonService.getTenantConfig("USE_OCS", loginVO.getTenantId());
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", loginVO.getTenantId());
		
		model.addAttribute("title", title);
		model.addAttribute("startTime", startTime);
		model.addAttribute("endTime", endTime);				
		model.addAttribute("pSearchString", pSearchString);
		model.addAttribute("use_ocs", use_ocs);
		model.addAttribute("userID", loginVO.getId());
		model.addAttribute("deptID", loginVO.getDeptID());
		model.addAttribute("primaryLang", primaryLang);
		
		return "/ezSchedule/scheduleSelectEntity";
	}
	
	/**
	 * 공통 > 공유자 지정 팝업
	 */
	@RequestMapping(value="/ezSchedule/scheduleSelectSecretary.do", method = RequestMethod.GET)
	public String scheduleSelectSecretary(@CookieValue("loginCookie") String loginCookie, Model model, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleSelectSecretary started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("companyID", loginVO.getCompanyID());
		
		return "/ezSchedule/scheduleSelectSecretary";
	}
	
	/**
	 * 공통 > 공유부서 지정 팝업
	 */
	@RequestMapping(value="/ezSchedule/scheduleSelectShareDept.do", method = RequestMethod.GET)
	public String scheduleSelectShareDept(@CookieValue("loginCookie") String loginCookie, Model model, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleSelectShareDept started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("deptID", loginVO.getDeptID());
		
		return "/ezSchedule/scheduleSelectShareDept";
	}
	
	/**
	 * 공통 > 음력날짜 사용여부 데이터
	 */
	@RequestMapping(value="/ezSchedule/scheduleGetLunarUse.do", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String scheduleGetLunarUse(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleGetLunarUse started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String cID = request.getParameter("COMPANYID");
		
		if (cID == null) {
			cID = loginSimpleVO.getCompanyID();
		}
		
		String result = ezScheduleService.scheduleGetLunarUse(cID, loginSimpleVO.getTenantId());
		
		return result;
	}
	
	/**
	 * 공통 > 클릭한 유저정보 겸직된 회사정보로 호출
	 */
	@RequestMapping(value="/ezSchedule/scheduleGetCumDeptID.do", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String scheduleGetCumDeptID(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleGetLunarUse started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String userID = request.getParameter("userID");
		String companyID = "";
		
		if(request.getParameter("companyID") != null && !request.getParameter("companyID").equals("")) {
			companyID = request.getParameter("companyID");
		}
		else {
			companyID = loginSimpleVO.getCompanyID();
		}
		
		String cumDeptID = ezScheduleService.getCumDeptId(userID,loginSimpleVO.getTenantId(), companyID);
		
		return cumDeptID;
	}
	
	/**
	 * 공통 > 이전날짜 등록관리 데이터
	 */
	@RequestMapping(value="/ezSchedule/scheduleGetRegi.do", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String scheduleGetRegi(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleGetRegi started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String cID = request.getParameter("COMPANYID");
		if (cID == null || cID.equals("")){
			cID = loginSimpleVO.getCompanyID();
		}
		
		//2018-11-01 김혜정 일정드래그앤드랍을 위해 추가
		if (cID == null) {
			cID = loginSimpleVO.getCompanyID();
		}
		
		String result = ezScheduleService.scheduleGetRegi(cID, loginSimpleVO.getTenantId());
		
		return result;
	}
	
	/**
	 * 환경설정 메인
	 */
	@RequestMapping(value="/ezSchedule/scheduleConfigMain.do", method = RequestMethod.GET)
	public String scheduleConfigMain(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("============ scheduleConfigMain started ============");
		
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		String useGoogleCalendar = ezCommonService.getTenantConfig("useGoogleCalendar", loginVO.getTenantId());
		
		String flag = request.getParameter("flag") == null ? "" : request.getParameter("flag");
		model.addAttribute("flag", flag);
		model.addAttribute("useGoogleCalendar", useGoogleCalendar);
		
		logger.debug("============ scheduleConfigMain ended ============");
		return "/ezSchedule/scheduleConfigMain";
	}
	
	/**
	 * 환경설정 일정관리
	 */	
	@RequestMapping(value="/ezSchedule/scheduleConfig.do", method = RequestMethod.GET)	
	public String scheduleConfig(@CookieValue("loginCookie") String loginCookie, Model model, LoginVO loginVO, ScheduleConfigVO scheduleConfigVO, OrganUserVO organUserVO) throws Exception {
		
		logger.debug("============ scheduleConfig started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		String userID = loginVO.getId();
		int tenantID = loginVO.getTenantId();
		String companyID = loginVO.getCompanyID();
		
		scheduleConfigVO = ezScheduleService.getScheduleConfig(userID, tenantID);
		List<ScheduleCumulerVO> pubScheCumulerVO = ezScheduleService.getPublicScheduleCumuler(userID, loginVO.getLang(), tenantID, companyID);
		List<ScheduleSecretaryVO> sList = ezScheduleService.getSecretaryList(userID, tenantID, companyID);
		List<OrganUserVO> oList = new ArrayList<OrganUserVO>();
		List<ScheduleSecretaryVO> pubScheSecVO = ezScheduleService.getPublicScheduleSec(userID, loginVO.getLang(), tenantID ,companyID);
		
		for (int i=0; i < sList.size(); i++) {
			ScheduleSecretaryVO vo = sList.get(i);
			
			organUserVO = ezOrganAdminService.getUserInfo(vo.getSecId(), "1", tenantID);
			
			organUserVO.setCn(vo.getSecId());
			organUserVO.setDisplayName(vo.getSecName());
			
			oList.add(i,organUserVO);
		}
		
		List<ScheduleTypeConfigVO> personalScheConfigList = ezScheduleService.getUserScheduleTypeConfig(userID, companyID, tenantID);
		ObjectMapper objectMapper = new ObjectMapper();
		String jsonPersonalScheConfigList = "";
		
		try {
			jsonPersonalScheConfigList = objectMapper.writeValueAsString(personalScheConfigList);
		} catch (Exception e) {
			logger.debug(e.getMessage());
		}
		
		model.addAttribute("selectList", oList);
		model.addAttribute("scheduleConfigVO", scheduleConfigVO);
		model.addAttribute("displayName1", loginVO.getDisplayName1());
		model.addAttribute("displayName2", loginVO.getDisplayName2());
		model.addAttribute("loginVO", loginVO);
		model.addAttribute("lang", loginVO.getPrimary());
		model.addAttribute("scheCum", pubScheCumulerVO);
		model.addAttribute("jsonPersonalScheConfigList", jsonPersonalScheConfigList);
		model.addAttribute("scheSec", pubScheSecVO);
		
		return "/ezSchedule/scheduleConfig";
	}
	
	/**
	 * 환경설정 일정관리 저장
	 */	
	@RequestMapping(value="/ezSchedule/scheduleSaveConfig.do", method = RequestMethod.POST)
	@ResponseBody
	public void scheduleSaveConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleSaveConfig started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		int tenantID = loginSimpleVO.getTenantId();
		String userID = loginSimpleVO.getId();	
		String companyID = loginSimpleVO.getCompanyID();
		String defaultView = request.getParameter("DEFAULTVIEW");
		String startDay = request.getParameter("STARTDAY");
		String startTime = request.getParameter("STARTTIME");
		String endTime = request.getParameter("ENDTIME");
		String autoDelete = request.getParameter("AUTODELETE");
		String displayName = request.getParameter("DISPLAYNAME");
		String displayName2 = request.getParameter("DISPLAYNAME2");
		String listSecretary = request.getParameter("LISTSECRETARY");
		String reminderTime = request.getParameter("REMINDERTIME");
		String defaultViewCheckBox = request.getParameter("DEFAULTVIEWCHECKBOX");
		String tagColorList = request.getParameter("tagColorList");
		
		if (defaultViewCheckBox.equals("false")) {
			defaultViewCheckBox = "N";
		} else {
			defaultViewCheckBox = "Y";
		}
		
		JSONParser parser = new JSONParser();
		JSONArray jsonArray = (JSONArray)parser.parse(listSecretary);

		ObjectMapper mapper = new ObjectMapper();
		List<ScheduleTypeConfigVO> tagColors = mapper.readValue(tagColorList, new TypeReference<List<ScheduleTypeConfigVO>>() {});
		
		// 기본 사용자 정보 세팅
		for (ScheduleTypeConfigVO vo : tagColors) {
			vo.setUserId(loginSimpleVO.getId());
			vo.setCompanyId(loginSimpleVO.getCompanyID());
			vo.setTenantId(loginSimpleVO.getTenantId());
		}
		
		/*//기존 환경설정 정보 삭제
		ezScheduleService.deleteScheduleConfig(userID, tenantID); */
		//새로운 환경설정 정보 등록 / 업데이트
		ezScheduleService.insertScheduleConfig(userID, defaultView, startDay, startTime, endTime, autoDelete, tenantID, reminderTime, defaultViewCheckBox, tagColors);
		//기존 비서정보 삭제
		ezScheduleService.deleteSecretary(userID, tenantID, companyID);
		
		for (int i = 0; i < jsonArray.size(); i++) {
			JSONObject obj = (JSONObject) jsonArray.get(i);
			
			String secretaryID = (String) obj.get("secretaryID");
			String secretaryName = (String) obj.get("secretaryName");
			//새로운 비서정보 등록
			ezScheduleService.insertSecretary(userID, displayName, displayName2, secretaryID, secretaryName, tenantID, companyID);
		}			
	}
	
	/**
	 * 환경설정 알림메일설정
	 */	
	@RequestMapping(value="/ezSchedule/scheduleMailNotiConfig.do")
	public String scheduleMailNotiConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginSimpleVO loginSimpleVO, Model model) throws Exception {
		logger.debug("============ scheduleMailNotiConfig started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		// 사용자 설정 정보 가져오기
		ScheduleMailConfigVO mailConfig = ezScheduleService.getScheduleMailNotiConfig(loginSimpleVO.getId(), loginSimpleVO.getTenantId());	
		
		model.addAttribute("mailConfig", mailConfig);
		
		return "/ezSchedule/scheduleSetNoticeMail";
	}
	
	/**
	 * 환경설정 알림메일설정
	 */	
	@RequestMapping(value="/ezSchedule/scheduleSaveMailNotiConfig.do")
	@ResponseBody
	public void scheduleSaveMailNotiConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginSimpleVO loginSimpleVO) throws Exception {
		logger.debug("============ scheduleSaveMailNotiConfig started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		// 사용자 설정 정보 가져오기
		String userMailNoti = request.getParameter("config");
		
		//새로운 환경설정 정보 등록
		ezScheduleService.setScheduleMailNotiConfig(userMailNoti, loginSimpleVO.getId(), loginSimpleVO.getTenantId());	
	}
		
	
	/**
	 * 일정작성
	 */
	@RequestMapping(value="/ezSchedule/scheduleWrite.do", method = RequestMethod.GET)
	public String scheduleWrite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, Locale locale, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleWrite started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		String _datetype = "";
		String _startdate = "";
		String _enddate = "";
		String _repetition = "";		
		String _content = "";
        String _contentpath = "";
		String _importance = "";
		String _ispublic = "";
        String _changekey = "";
        String recurringLabelText = "";
        String startDateStringOrgin = "";
        String endDateStringOrgin = "";
		String UploadSDate="";
		String UploadEDate="";
		String startDateTime="";
		String endDateTime="";        
        String _hasattach = "N";                
        String pCompanyAdmin = "";
        String pDeptAdmin = "";        
        String userID = loginVO.getId();
		String lang = loginVO.getPrimary();
		int tenantID = loginVO.getTenantId();
		String companyID = loginVO.getCompanyID();
		String showtop = request.getParameter("showtop");

        StringBuilder strAttach = new StringBuilder();        
        ScheduleInfoVO scheduleInfo = new ScheduleInfoVO();
        
		Map<String, Object> param = new HashMap<>();
		param.put("userID", userID);
		param.put("tenantID", tenantID);
		param.put("companyID", companyID);
		
        // 현 사용자가 비서인 임원의 일정
        List<ScheSecretaryVO> sList = ezScheduleService.getPublicExceSchedule(param);
		// 공유 부서 일정
		List<ScheDeptVO> pdList = ezScheduleService.getShareScheduleDept(param);
		// 겸직 부서 일정
		List<ScheDeptVO> cList = ezScheduleService.getAddJobSchedule(param);
		String userType = ezScheduleService.checkExecutiveType(userID, companyID, tenantID); // 임원인지 비서인지 조회
		
		// 2023-08-09 전인하 - 일정관리 > 부서관리자 겸직 권한이 있을 시, 부서관리자 권한이 있는 겸직의 부서 일정 작성/수정 기능
		// 겸직/사용자 기준으로 권한 부여 옵션 사용여부 체크 변수
		String permissionBasisDeptYN = ezCommonService.getTenantConfig("permissionBasisDeptYN", loginVO.getTenantId());
		
		loginVO = commonUtil.userInfo(loginCookie);
		OrganAuth organAuth = commonUtil.makeOrganAuth(loginVO.getId(), loginVO.getTenantId(), loginVO.getDeptID(), loginVO.getJobId());
		
		List<ScheduleOwnerInfoVO> schOwnInfoList = new ArrayList<>();
		
		if (organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER, companyID)) {
			pCompanyAdmin = "Y";
			pDeptAdmin = "Y";
		} else {
			if (organAuth.isAuth(AdminAuth.DEPT_MANAGER, loginVO.getDeptID())) {
				pDeptAdmin = "Y";
			}

			if (organAuth.isAuth(AdminAuth.SCHEDULE_MANAGER, companyID)) {
				pCompanyAdmin = "Y";
			}
		}

        String _defaultid = request.getParameter("defaultid");
        if(!commonUtil.isIntNumber(_defaultid)) {
			logger.debug("This number is invalid.");	
			_defaultid = "0";
		}
		if (_defaultid == null) _defaultid = "";
         
		String _scheduleid = request.getParameter("id");
		if (_scheduleid == null) {
			_scheduleid = "";
		} else {
			_scheduleid.replace(" ", "+");
		}
		
		String _otherid = request.getParameter("otherid");
		if (_otherid == null) _otherid = "";
		
		_otherid = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(_otherid));
         
		String pageFrom = request.getParameter("pageFrom");
		if (pageFrom == null) pageFrom = "";
         
		String _scheduletype = request.getParameter("type");
		if (_scheduletype == null) _scheduletype = "";
         
		String _pattern = request.getParameter("pattern");
		if (_pattern == null) _pattern = "";
		
		/* 2021-11-25 홍승비 - 일정완료 관련 데이터 추가 */
		String repeatCount = request.getParameter("repeatCount") != null ? request.getParameter("repeatCount") : "0";
		String repStartDate = request.getParameter("repStartDate") != null ? request.getParameter("repStartDate") : "";
		
		// 2022-09-29 이사라 - 닷넷그룹웨어 연동 시 일정작성에서 자원설정 제외
		boolean isDotNetIntegration = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("dotNetIntegration", tenantID));

        String userId = loginVO.getId();            
        String userName  = loginVO.getDisplayName1();
        String userName2 = loginVO.getDisplayName2();
        String primary = loginVO.getPrimary();
        String EDITOR = ezCommonService.getTenantConfig("EDITOR", loginVO.getTenantId());
        String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());
        String useAnyoneEdit = ezCommonService.getTenantConfig("UseAnyoneEdit", loginVO.getTenantId());
        String chkSchedulePublic = ezCommonService.getTenantConfig("chkSchedulePublic", loginVO.getTenantId());
        
        if (!_scheduleid.equals("")) {		
        	String pDirPath = commonUtil.getUploadPath("upload_schedule.ROOT", loginVO.getTenantId());
        	
        	scheduleInfo = ezScheduleService.getScheduleInfo(_scheduleid, offSetMin, loginVO.getTenantId() ,loginVO.getCompanyID());
        	
            _contentpath = pDirPath + scheduleInfo.getContentPath();
            startDateStringOrgin = scheduleInfo.getStartDate();
            endDateStringOrgin = scheduleInfo.getEndDate();
            
            //참석자 리스트
            String hasAttendant = scheduleInfo.getHasAttendant();
            if (hasAttendant.equals("Y")) {            	
                String parentId = (scheduleInfo.getParentId().equals("0") ? _scheduleid : scheduleInfo.getParentId());                
                List<AttendantListVO> attendantList = ezScheduleService.getAttendantList(parentId, offSetMin, loginVO.getTenantId(), loginVO.getCompanyID());   
                
                model.addAttribute("attendantList", attendantList);
            }
            
            //첨부파일 리스트
            _hasattach = scheduleInfo.getHasAttach();            
            if (_hasattach.equals("Y")) {            	
            	_hasattach = "Y";            	
            	
            	List<AttachListVO> attachList = ezScheduleService.getAttachList(_scheduleid, loginVO.getTenantId());
            	
            	strAttach.append("<ROOT><NODES>");
            	
                for (AttachListVO attach : attachList) {
//                    strAttach.append("<DATA><![CDATA[" + commonUtil.cleanPropertyValue(attach.getFilePath().split("uploadFile/")[1] + "/" + attach.getFileName() + "/" + attach.getFileSize()) + "]]></DATA>");
                    strAttach.append("<DATA><![CDATA[" + attach.getFilePath().split("uploadFile/")[1] + "/" + attach.getFileName() + "/" + attach.getFileSize() + "]]></DATA>");
                    strAttach.append("<DATA2><![CDATA[]]></DATA2>");
                    strAttach.append("<DATA3><![CDATA[OK]]></DATA3>");
                }
                strAttach.append("</NODES></ROOT>");            		
            } else {
            	_hasattach = "N";
            }
            
            _scheduletype = scheduleInfo.getScheduleType();
            _datetype = scheduleInfo.getDateType();
            _startdate = scheduleInfo.getStartDate();
            _enddate = scheduleInfo.getEndDate();            
            _repetition = scheduleInfo.getRepetition();            
            _ispublic = scheduleInfo.getIsPublic();
            _importance = scheduleInfo.getImportance();
            
            startDateTime = _startdate;
            endDateTime = _enddate;
            
            String strLabelOwner = "";                
            
        	if (_scheduletype.equals("1") || _scheduletype.equals("6")) {
                strLabelOwner = msg.getMessage("ezSchedule.t372", locale) + " ";
                strLabelOwner += (primary.equals("1") ? scheduleInfo.getOwnerName() : scheduleInfo.getOwnerName2());
            } else if (_scheduletype.equals("2")) {
                strLabelOwner = msg.getMessage("ezSchedule.t373", locale) + " ";
                strLabelOwner += (primary.equals("1") ? scheduleInfo.getOwnerName() : scheduleInfo.getOwnerName2());
            } else if (_scheduletype.equals("3")) {
                strLabelOwner = msg.getMessage("ezSchedule.t374", locale) + " ";
                strLabelOwner += (primary.equals("1") ? loginVO.getCompanyName() : loginVO.getCompanyName2());
            } else if (_scheduletype.equals("4")) {
                //HQ관련
            } else if (_scheduletype.equals("7")) {
                strLabelOwner = msg.getMessage("ezSchedule.t375", locale) + " ";
                strLabelOwner += (primary.equals("1") ? scheduleInfo.getOwnerName() : scheduleInfo.getOwnerName2());
            } else if (_scheduletype.equals("8")) {
            	strLabelOwner = msg.getMessage("ezSchedule.t373", locale) + " ";
                strLabelOwner += (primary.equals("1") ? scheduleInfo.getOwnerName() : scheduleInfo.getOwnerName2());
            } else if (_scheduletype.equals("10")) {
				strLabelOwner = msg.getMessage("ezSchedule.lyj14", locale) + " - ";
				strLabelOwner += (primary.equals("1") ? scheduleInfo.getOwnerName() : scheduleInfo.getOwnerName2());
			}
      	
        	model.addAttribute("strLabelOwner", strLabelOwner);        	
        	model.addAttribute("strAttach", strAttach.toString());        	
        } else {
        	if (!_otherid.equals("")) {    
        		ScheduleOwnerInfoVO soi = new ScheduleOwnerInfoVO();
        		
        		soi.setScheduleType(_scheduletype);
        		soi.setOwnerId(_otherid);
        		soi.setOwnerName(request.getParameter("othername"));
        		soi.setOwnerName2(request.getParameter("othername"));
        		
        		schOwnInfoList.add(soi);
        	} else {
        		// 실제로는 defaultid가 0만 넘어오는 쓰이지 않는 파라미터로 보임. 기본으로 개인 일정이 보이도록 함.
//				int defaultIndex = Integer.parseInt(_defaultid);
				
				//개인일정
				ScheduleOwnerInfoVO soi = new ScheduleOwnerInfoVO();
				
        		soi.setScheduleType("1");
        		soi.setOwnerId(userId);
        		soi.setOwnerName(loginVO.getDisplayName1());
        		soi.setOwnerName2(loginVO.getDisplayName2());
        		
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
				
				//부서일정
				if (pDeptAdmin.equals("Y")) {
					ScheduleOwnerInfoVO deptSoi = new ScheduleOwnerInfoVO();
					
					deptSoi.setScheduleType("2");
					deptSoi.setOwnerId(loginVO.getDeptID());
					deptSoi.setOwnerName(loginVO.getDeptName1());
					deptSoi.setOwnerName2(loginVO.getDeptName2());
					
					schOwnInfoList.add(deptSoi);
				}
				
				//겸직일정
				for (ScheDeptVO vo : cList) {
					String deptId = vo.getDeptId();
					if (loginVO.getDeptID().equals(deptId)) {
						continue;
					} else if ("Y".equals(pCompanyAdmin) || organAuth.isAuth(AdminAuth.DEPT_MANAGER, deptId)){
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
						if (vo.getDeptId().equals(vo2.getDeptId()) || loginVO.getDeptID().equals(vo.getDeptId())) {
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
					compSoi.setOwnerId(loginVO.getCompanyID());
					compSoi.setOwnerName(loginVO.getCompanyName1());
					compSoi.setOwnerName2(loginVO.getCompanyName2());
					
					schOwnInfoList.add(compSoi);
				}
				
				// 임원일정
				if (userType.equals("a")) { // 임원 + 비서일 경우
					ScheduleOwnerInfoVO exceSoiA = new ScheduleOwnerInfoVO();
					
					exceSoiA.setScheduleType("10");
					exceSoiA.setOwnerId(userId);
					exceSoiA.setOwnerName(loginVO.getDisplayName1());
					exceSoiA.setOwnerName2(loginVO.getDisplayName2());
					
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
					exceSoiA.setOwnerName(loginVO.getDisplayName1());
					exceSoiA.setOwnerName2(loginVO.getDisplayName2());
					
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

        		//그룹 일정
            	List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(userId, loginVO.getTenantId(), loginVO.getCompanyID());

            	for (ScheduleGroupListVO vo : gList) {
                	List<ScheduleGroupListVO> mList = ezScheduleService.getGroupMemberList(vo.getGroupId(), loginVO.getPrimary(),loginVO.getTenantId(), offSetMin ,loginVO.getCompanyID());
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
        	}
        	
			String cDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), loginVO.getOffset(), false);				
			
			_datetype = request.getParameter("datetype");
    		if (_datetype == null) _datetype = "";
			
			if (request.getParameter("sdate") != null) {
				startDateTime = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(request.getParameter("sdate")));
			} else {				
				if (request.getParameter("startdate") != null) {
					cDate = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(request.getParameter("startdate")));
				}	
				startDateTime = getUploadDate(cDate, true);
			}
			
			if (request.getParameter("edate") != null) {
				endDateTime = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(request.getParameter("edate")));
			} else {
				if (request.getParameter("enddate") != null) {
					cDate = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(request.getParameter("enddate")));
				}
				endDateTime = getUploadDate(cDate, false);
			}
        }
        
        ObjectMapper objectMapper = new ObjectMapper();
        for (ScheduleOwnerInfoVO scheduleOwnerInfoVO : schOwnInfoList) {
            scheduleOwnerInfoVO.setOwnerName(scheduleOwnerInfoVO.getOwnerName().replaceAll("\'", "&#039;").replaceAll("\"", "&#034;"));
            scheduleOwnerInfoVO.setOwnerName2(scheduleOwnerInfoVO.getOwnerName2().replaceAll("\'", "&#039;").replaceAll("\"", "&#034;"));
        }
        String schOwnInfoListToJson = objectMapper.writeValueAsString(schOwnInfoList);

        //2017-11-15 자원관리 사용하지 않을 경우 탭 처리
        //String accessList = ezPortalService.getAccessList(loginVO);
		//boolean checkResourceTab = ezPortalService.checkViewRightBln("6db81dc5-e8ba-49c8-b625-df4fd375a43a", accessList, loginVO.getTenantId());
		int reourceId = 6;
		boolean checkResourceTab = ezNewPortalService.getCheckAuth(reourceId, userID, loginVO.getDeptID(), companyID, tenantID);
		
        UploadSDate = startDateTime;
        UploadEDate = endDateTime;
        
        /* 2021-11-26 홍승비 - 일정 수정 시, 일정완료 체크박스 값 표출하기 위해 플래그 전달 */
        String isAllRep = "";
        String completeFG = "N";
        if (!_scheduleid.equals("")) {
        	isAllRep = ezScheduleService.getScheduleCompleteIsAllRep(_scheduleid, repeatCount, commonUtil.getDateStringInUTC(repStartDate, loginVO.getOffset(), true), _datetype, loginVO.getTenantId(), loginVO.getCompanyID());
        	if (!isAllRep.equals("")) { // 해당 일정에 대한 완료여부 레코드가 존재한다면 completeFG 설정
        		completeFG = "Y";
        	}
        }

		// 2023-08-09 전인하 - 일정관리 > 부서관리자 겸직 권한이 있을 시, 부서관리자 권한이 있는 겸직의 부서 일정 작성/수정 기능
		// 부서관리자겸직권한이 존재하는 겸직부서의 ID를 반환
		String AdminDeptList = "";
		if (permissionBasisDeptYN.equals("Y")) {
			List<OrganUserVO> tempDeptAdminList = ezOrganService.getAllRollInfoForUserBasisDept(loginVO.getId(), loginVO.getTenantId(), "g=1");
			for (OrganUserVO rollData : tempDeptAdminList) {
				AdminDeptList = AdminDeptList + rollData.getDepartment() + ";";
			}
			pDeptAdmin = "N"; // permissionBasisDeptYN 옵션 사용 시 해당 플래그가 "Y"면 부서관리자 권한이 없는 타부서에 대해서도 권한을 부릴 수 있는 오류 일으킴
			model.addAttribute("AdminDeptList", AdminDeptList);
		}

		String nowDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), loginVO.getOffset(), false);
		
        model.addAttribute("userId", userId);
        model.addAttribute("userName", userName);
        model.addAttribute("userName2", userName2);
        model.addAttribute("otherId", _otherid);
        model.addAttribute("scheduleId", _scheduleid);
        model.addAttribute("dateType", _datetype);
        model.addAttribute("startDate", _startdate);
        model.addAttribute("endDate", _enddate);
        model.addAttribute("content", _content);
        model.addAttribute("contentPath", _contentpath);
        model.addAttribute("isPublic", _ispublic);
        model.addAttribute("importance", _importance);
        model.addAttribute("repetition", _repetition);        
        model.addAttribute("scheduleType", _scheduletype);
        model.addAttribute("changeKey", _changekey);
        model.addAttribute("pattern", _pattern);
        model.addAttribute("recurringLabelText", recurringLabelText);
        model.addAttribute("startDateStringOrgin", startDateStringOrgin);
        model.addAttribute("endDateStringOrgin", endDateStringOrgin);
        model.addAttribute("pageFrom", pageFrom); 
        model.addAttribute("companyID", loginVO.getCompanyID());
        model.addAttribute("deptName", loginVO.getDeptName());
        model.addAttribute("deptID", loginVO.getDeptID());
        model.addAttribute("hasAttach", _hasattach);                
        model.addAttribute("pCompanyAdmin", pCompanyAdmin);
        model.addAttribute("pDeptAdmin", pDeptAdmin);
        model.addAttribute("strXML", strAttach.toString());
        model.addAttribute("UploadSDate", UploadSDate);
        model.addAttribute("UploadEDate", UploadEDate);
        model.addAttribute("lang", loginVO.getLang());        
        model.addAttribute("EDITOR", EDITOR);        
        model.addAttribute("schOwnInfoListToJson", schOwnInfoListToJson);        
        model.addAttribute("offSetMin", offSetMin);
        model.addAttribute("scheduleInfo", scheduleInfo);
        model.addAttribute("useAnyoneEdit", useAnyoneEdit);
        model.addAttribute("checkResourceTab", checkResourceTab);
        model.addAttribute("repeatCount", repeatCount);
        model.addAttribute("repStartDate", repStartDate);
        model.addAttribute("isAllRep", isAllRep); // 일정완료 레코드의 전체반복일정 완료여부
        model.addAttribute("completeFG", completeFG); // 일정완료 레코드 존재여부
        model.addAttribute("isDotNetIntegration", isDotNetIntegration); // 닷넷연동 여부
		model.addAttribute("permissionBasisDeptYN", permissionBasisDeptYN); // 겸직/사용자 기준 권한 설정 옵션 여부
		model.addAttribute("chkSchedulePublic", chkSchedulePublic); // 개인일정 작성시 공개/비공개값 설정가능 여부
		model.addAttribute("showtop", showtop); // 겸직/사용자 기준 권한 설정 옵션 여부
		model.addAttribute("nowDate", nowDate); // utc 타임존 적용을 위해 현재시간을 백에서 받아옴
   		return "/ezSchedule/scheduleWrite";
	}	
		
	/**
	 * 일정작성 > 반복일정 선택
	 */	
	@RequestMapping(value="/ezSchedule/scheduleRepetition.do", method = RequestMethod.GET)
	public String scheduleRepetition(@CookieValue("loginCookie") String loginCookie, Model model, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleRepetition started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		model.addAttribute("lang", loginSimpleVO.getLang());
		
		return "/ezSchedule/scheduleRepetition";
	}
	
	/**
	 * 일정작성 > 반복일정 선택
	 */	
	@RequestMapping(value="/ezSchedule/scheduleSelectResource.do", method = RequestMethod.GET)
	public String scheduleSelectResource(@CookieValue("loginCookie") String loginCookie, Model model, LoginVO loginVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleSelectResource started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
				
		String brd_Gubun = request.getParameter("pbrdGubun");
		String selectNo = request.getParameter("flag");
		String startTime = request.getParameter("StartTime");
		String endTime = request.getParameter("EndTime");
		String serverName = request.getServerName();
				
		model.addAttribute("brd_Gubun", brd_Gubun);
		model.addAttribute("selectNo", selectNo);
		model.addAttribute("startTime", startTime);
		model.addAttribute("endTime", endTime);
		model.addAttribute("serverName", serverName);
		model.addAttribute("userInfo", loginVO);		
		
		return "/ezSchedule/scheduleSelectResource";
	}
	
	/**
	 * 일정관리 Schedule 저장 호출 Method
	 */
	@RequestMapping(value = "/ezSchedule/scheduleSave.do", method = RequestMethod.POST)
	@ResponseBody
	public String scheduleSave(@CookieValue("loginCookie") String loginCookie, @RequestBody String requestXML, HttpServletRequest request, HttpServletResponse response, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleSave started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);	
		int result = 0;
		Locale locale = loginVO.getLocale();
						
        String pageFrom = request.getParameter("pageFrom");
		if (pageFrom == null) pageFrom = "";

		Document doc = commonUtil.convertStringToDocument(requestXML);
        String scheduleid	= doc.getElementsByTagName("SCHEDULEID").item(0).getTextContent();
        String ownerid		= doc.getElementsByTagName("OWNERID").item(0).getTextContent();
        String ownername	= doc.getElementsByTagName("OWNERNAME").item(0).getTextContent();
        String ownername2	= doc.getElementsByTagName("OWNERNAME2").item(0).getTextContent();
        String creatorid	= doc.getElementsByTagName("CREATORID").item(0).getTextContent();
        String creatorname	= doc.getElementsByTagName("CREATORNAME").item(0).getTextContent();
        String creatorname2	= doc.getElementsByTagName("CREATORNAME2").item(0).getTextContent();
        String scheduletype	= doc.getElementsByTagName("SCHEDULETYPE").item(0).getTextContent();
        String importance	= doc.getElementsByTagName("IMPORTANCE").item(0).getTextContent();
        String ispublic		= doc.getElementsByTagName("ISPUBLIC").item(0).getTextContent();
        String datetype		= doc.getElementsByTagName("DATETYPE").item(0).getTextContent();
        String showtop		= doc.getElementsByTagName("SHOWTOP").item(0) == null ? "N": doc.getElementsByTagName("SHOWTOP").item(0).getTextContent();
        /* 2021-11-25 홍승비 - 일정 수정 시 일정완료 관련 데이터 추가 */
        String completeFG	= "";
        String repeatCount	= "";
        String repStartDate	= "";
        String isAllRep		= "";

        if (scheduleid.equals("")) {
	        //Set ownername and ownername2
	        /*if (scheduletype.equals("1")) {				// 2019-04-15 김민성 - 비서일정 구분을 위해 주석처리함
	        	ownername = creatorname;
	        	ownername2 = creatorname2;
	        }
	        else */
        	if (scheduletype.equals("2") || scheduletype.equals("3")) {
	        	String organName = ezOrganService.getPropertyValue(ownerid, "displayname", loginVO.getTenantId());
	        	
	        	if (organName.equals(ownername)) {
	        		String organName2 = ezOrganService.getPropertyValue(ownerid, "displayname2", loginVO.getTenantId());
	        		ownername2 = organName2;
	        	}
	        	else {
	        		ownername = organName;
	        	}
	        }
        }
        
        String pattern = "";       
        
        if (scheduleid != null && !scheduleid.equals("")) {
        	pattern = doc.getElementsByTagName("PATTERN").item(0).getTextContent();
        	
        	// 일정완료 관련 데이터
        	completeFG = doc.getElementsByTagName("COMPLETEFG").item(0) != null ? doc.getElementsByTagName("COMPLETEFG").item(0).getTextContent() : "N";
            repeatCount = doc.getElementsByTagName("REPEATCOUNT").item(0) != null ? doc.getElementsByTagName("REPEATCOUNT").item(0).getTextContent() : "0";
            isAllRep = doc.getElementsByTagName("ISALLREP").item(0) != null ? doc.getElementsByTagName("ISALLREP").item(0).getTextContent() : "N";
        }        

        String startdate = doc.getElementsByTagName("STARTDATE").item(0).getTextContent();
        String enddate = doc.getElementsByTagName("ENDDATE").item(0).getTextContent();

    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    	Calendar cal = Calendar.getInstance();
    	cal.setTime(sdf.parse(enddate));
    	
    	if (cal.get(Calendar.HOUR_OF_DAY) == 0 && cal.get(Calendar.MINUTE) == 0) {        		
    		cal.add(Calendar.MINUTE, -1);        		
    		enddate = sdf.format(cal.getTime());
    	}

    	startdate = sdf.format(sdf.parse(startdate));
    	enddate = sdf.format(sdf.parse(enddate));
        startdate = commonUtil.getDateStringInUTC(startdate, loginVO.getOffset(), true);
    	enddate = commonUtil.getDateStringInUTC(enddate, loginVO.getOffset(), true);
        
        String repetition	= doc.getElementsByTagName("REPETITION").item(0).getTextContent();
        logger.debug("repetition : " + repetition);
        String title		= doc.getElementsByTagName("TITLE").item(0).getTextContent();
        String location		= doc.getElementsByTagName("LOCATION").item(0).getTextContent();
        String content		= doc.getElementsByTagName("CONTENT").item(0).getTextContent();
        String contentPath	= doc.getElementsByTagName("CONTENTPATH").item(0).getTextContent();
        NodeList attach				= doc.getElementsByTagName("ATTACH");
        NodeList attendantId 		= doc.getElementsByTagName("ATTENDANTID");
        NodeList attendantName 		= doc.getElementsByTagName("ATTENDANTNAME1");
        NodeList attendantName2 	= doc.getElementsByTagName("ATTENDANTNAME2");
        NodeList attendantDeptName 	= doc.getElementsByTagName("ATTENDANTDEPTNAME");
        NodeList attendantDeptName2 = doc.getElementsByTagName("ATTENDANTDEPTNAME2");
   
	    if (pattern.equals("0")) {
        	repetition = "";
        }        
	    
	    String defaultPath = "";
	    
	    if (contentPath == null || contentPath.trim().equals("")) {	    
	    	defaultPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_schedule.ROOT", loginVO.getTenantId());
	    } else {
	    	defaultPath = commonUtil.getRealPath(request) + contentPath;
	    }
	    defaultPath = commonUtil.detectPathTraversal(defaultPath);
	    
	    if (scheduleid == null || scheduleid.equals("")) {
        	//insertSchedule
        	result = ezScheduleService.insertSchedule(ownerid, ownername, ownername2, creatorid, creatorname, creatorname2, scheduletype, importance, ispublic, datetype, startdate, enddate, repetition, title, location, content, attach, 
        			attendantId, attendantName, attendantName2, attendantDeptName, attendantDeptName2, defaultPath, loginVO.getTenantId(), loginVO.getCompanyID(), showtop, loginVO.getOffset(), loginVO.getLang());
       
        	// 참석자 초대 메일 발송
        	if (attendantId != null) {
        		startdate = commonUtil.getDateStringInUTC(startdate, loginVO.getOffset(), false);
        		enddate = commonUtil.getDateStringInUTC(enddate, loginVO.getOffset(), false);
        		String scheDateContent = ezScheduleService.makeScheDateContent(datetype, repetition, startdate, enddate, loginVO.getLocale());
  				String scheTimeContent = ezScheduleService.makeScheTimeContent(startdate, enddate, datetype, repetition, loginVO.getLocale());
  				String scheRepeContent = ezScheduleService.makeRepetitionContent(repetition, loginVO.getLocale());
  				
  				String periodConetent = "";
  				periodConetent = " &nbsp;&nbsp;- " + msg.getMessage("ezSchedule.t318", loginVO.getLocale()) + " : " + scheDateContent + "<br>";
  				periodConetent += " &nbsp;&nbsp;- " + msg.getMessage("ezSchedule.t67", loginVO.getLocale()) + " : " + scheTimeContent;
  				
  				if (datetype.equals("3")) {
  					periodConetent += "<br>" + " &nbsp;&nbsp;- " + msg.getMessage("ezSchedule.t71", loginVO.getLocale()) + " : " + scheRepeContent;
  				}
  				
     			for (int i=0; i < attendantId.getLength(); i++) {								
     				String v_attendantId = attendantId.item(i).getTextContent();				
     				String v_attendantName = attendantName.item(i).getTextContent();
     				
     				if (!ezPersonalService.hasNotiDiableItem(v_attendantId, NotiType.SCHEDULE_ADD, NotiPlatform.MAIL, loginVO.getTenantId())) {
     					ezScheduleService.scheduleSendMail(result, v_attendantId, v_attendantName, title, periodConetent, "add", loginVO, loginCookie, startdate, enddate);
     				}

     				String linkUrl = "/ezSchedule/scheduleReceiveAttendant.do?from=mail";
     				String linkUrlMobile = "/mobile/ezSchedule/mScheduleReceiveAttendant.do";
     				
     				List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();

     				Map<String, Object> recipientMap = new HashMap<String, Object>();
     				recipientMap.put("userType", "PERSON");
     				recipientMap.put("companyId", loginVO.getCompanyID());
     				recipientMap.put("cn", v_attendantId);
     				notiRecipientList.add(recipientMap);
     				
     				ezNotificationService.sendNoti(request, loginVO.getId(), loginVO.getDisplayName(), notiRecipientList, "schedule", "add", title, "popup", "730", "370", linkUrl, linkUrlMobile, "");
     			}
        	 }
	    } else {
	    	ScheduleInfoVO beforeSche = ezScheduleService.getScheduleInfo(scheduleid, commonUtil.getMinuteUTC(loginVO.getOffset()), loginVO.getTenantId(), loginVO.getCompanyID());
	    	//updateSchedule
        	result = ezScheduleService.updateSchedule(scheduleid, creatorid, creatorname, creatorname2, importance, ispublic, datetype, startdate, enddate, repetition, title, location, content, attach, defaultPath, loginVO.getTenantId(), loginVO.getCompanyID(), showtop);
        	
            if (doc.getElementsByTagName("REPSTARTDATE").item(0) != null) {
            	repStartDate = doc.getElementsByTagName("REPSTARTDATE").item(0).getTextContent();
            	repStartDate = sdf.format(sdf.parse(repStartDate));
            	repStartDate = commonUtil.getDateStringInUTC(repStartDate, loginVO.getOffset(), true);
            } else {
            	repStartDate = startdate;
            }
            
            // 2023-09-22 한태훈 : 초대 일정 수정 메일 발송
	       	 if (attendantId != null) {
	       		ezScheduleService.sendInviteModNoti(request, scheduleid, attendantId, attendantName, location, title, importance, ispublic, startdate, enddate, datetype, repetition, beforeSche, repStartDate, repeatCount, isAllRep, completeFG, loginVO, loginCookie);
	       	}
            
	       	/* 2021-11-25 홍승비 - 일정 수정 시 일정완료 데이터 삽입 또는 삭제 */
            if (completeFG.equals("Y")) { // 일정완료 삽입
            	ezScheduleService.insertScheduleComplete(scheduleid, repeatCount, isAllRep, repStartDate, loginVO.getTenantId(), loginVO.getCompanyID());
            } else { // 일정완료 해제
            	ezScheduleService.deleteScheduleComplete(scheduleid, repeatCount, isAllRep, repStartDate, loginVO.getTenantId(), loginVO.getCompanyID());
            }
        }
	    
	    //KT텔레캅 통합알람 푸쉬 코드
	    String dotNetTotalNotification = ezCommonService.getTenantConfig("dotNetTotalNotification", loginVO.getTenantId());
	    logger.debug("dotNetTotalNotification=" + dotNetTotalNotification);
	    String serverFlag = "dotNet";
		//String serverDomain = config.getProperty("");
		String serverDomain = request.getServerName();
	    
	    if (attendantId != null) {
			for (int i=0; i < attendantId.getLength(); i++) {								
				String v_attendantId = attendantId.item(i).getTextContent();				
				String v_attendantName = attendantName.item(i).getTextContent();
				String v_attendantName2 = attendantName2.item(i).getTextContent();
				
			    if(dotNetTotalNotification.equalsIgnoreCase("yes")) {
			    	try {
			    		String resultCode = "";
			    		
						String attendantIdParam = "userId=" + URLEncoder.encode(v_attendantId, "UTF-8");
						String mainTypeParam = "type=" + URLEncoder.encode("schedule", "UTF-8");
						String subTypeParam = "subType=" + URLEncoder.encode("attendant", "UTF-8");
						String senderIdParam = "senderId=" + URLEncoder.encode(loginVO.getId(), "UTF-8");
						String senderNameParam = "";
						if (loginVO.getLang().equals("1")) {
					    	 senderNameParam = "senderName=" + URLEncoder.encode(v_attendantName, "UTF-8");
					    } else {
					    	 senderNameParam = "senderName=" + URLEncoder.encode(v_attendantName2, "UTF-8");
					    }
						String subjectParam = "subject=" + URLEncoder.encode("["+msg.getMessage("main.t203", locale)+"] " + title, "UTF-8");
						String etcDataParam = "etcData=";
						String linkURLParam = "linkURL=" + URLEncoder.encode(request.getScheme() + "://" +  serverDomain + "/ezConn/scheduleReceiveAttendant.do?serverFlag="+serverFlag, "UTF-8");
						String mobileLinkURLParam = "mobileLinkURL=" + URLEncoder.encode("/Schedule/schedule_receive_attendant.aspx", "UTF-8");
						String viewTypeParam = "viewType=" + URLEncoder.encode("popup", "UTF-8");
						String viewWidthParam = "viewWidth=" + URLEncoder.encode("730", "UTF-8");
						String viewHeightParam = "viewHeight=" + URLEncoder.encode("370", "UTF-8");
						
						String inputParams = attendantIdParam + "&" + mainTypeParam + "&" + subTypeParam + "&" + senderIdParam + "&";
							   inputParams += senderNameParam + "&" + subjectParam + "&" + etcDataParam + "&" + linkURLParam + "&";
							   inputParams += mobileLinkURLParam + "&" + viewTypeParam + "&" + viewWidthParam + "&" + viewHeightParam; 

						logger.debug("inputParams=" + inputParams);

						String requestURL = config.getProperty("config.JGwServerURL") + "/ezTalkGate/addNotificationETC";
						String webServiceResultResponse = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

						logger.debug("response=" + webServiceResultResponse);

						if (webServiceResultResponse != null) {
							JSONParser jsonParser = new JSONParser();
							JSONObject responseObj = (JSONObject)jsonParser.parse(webServiceResultResponse);

							resultCode = (String)responseObj.get("resultCode");
							logger.debug("resultCode=" + resultCode);
						}
					} catch (Exception e) {
						logger.error(e.getMessage(), e);
					}
			    }
			}
		}				    
        
        return Integer.toString(result);
	}
	
	/**
	 * 일정작성 > 참석자 일정조회 팝업
	 */	
	@RequestMapping(value="/ezSchedule/scheduleAddUser.do", method = RequestMethod.GET)
	public String scheduleAddUser(@CookieValue("loginCookie") String loginCookie, Model model, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleAddUser started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		model.addAttribute("userInfo", loginSimpleVO);
		
		return "/ezSchedule/scheduleAddUser";
	}
	
	/**
	 * 일정작성 > 참석자 일정조회 데이터 
	 */	
	@RequestMapping(value="/ezSchedule/scheduleAttendantList.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleAttendantList(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleAttendantList started ============");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String offSetMin = commonUtil.getMinuteUTC(userInfo.getOffset());		
		String startDate = request.getParameter("STARTDATE");
		String endDate = request.getParameter("ENDDATE");
		String idList = request.getParameter("IDLIST");		
		String pidList = "'" + idList + "'";
		
		String DeptID = ezScheduleService.getCumDeptId(idList, userInfo.getTenantId(), userInfo.getCompanyID());
		String CompanyID = userInfo.getCompanyID();
		//2020-02-24 김정언
		String useAnnualScheduleYN = ezCommonService.getTenantConfig("useAnnualScheduleYN", userInfo.getTenantId());
		
		List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(idList, userInfo.getTenantId() ,userInfo.getCompanyID());
		
		String dcidList = "'" + DeptID + "'" + ",'" + CompanyID + "'";
		
		for(int i = 0; i < gList.size(); i++){
			if(i == 0){
				dcidList += ",";
			}			
			ScheduleGroupListVO data = gList.get(i);			
			dcidList += "'" + data.getGroupId() + "'";
			
			if(i != gList.size()-1){
				dcidList += ",";
			}	
		}
		
		startDate = startDate + " 00:00:00";
		endDate = endDate + " 23:59:59";
		
		String utcStartTime = commonUtil.getDateStringInUTC(startDate, userInfo.getOffset(), true);
		String utcEndTime = commonUtil.getDateStringInUTC(endDate, userInfo.getOffset(), true);

		List<ScheduleInfoVO> sList = ezScheduleService.getScheduleList(pidList, dcidList, "", utcStartTime, utcEndTime, startDate, endDate, offSetMin, "", "", "", userInfo.getTenantId(), userInfo.getCompanyID(), idList, userInfo.getDeptID(), useAnnualScheduleYN);
		
		StringBuilder sb = new StringBuilder("<DATA>");
		
		for(int j = 0; j < sList.size(); j++){		
			ScheduleInfoVO data = sList.get(j);
			sb.append(commonUtil.getQueryResult(data));
		}
		sb.append("</DATA>");
		
		return sb.toString(); 
	}
	
	/**
	 * 일정작성 > 자원 현황 조회 
	 */	
	@RequestMapping(value="/ezSchedule/scheduleResourceInfo.do", method = RequestMethod.GET)	
	public String scheduleResourceInfo(@CookieValue("loginCookie") String loginCookie, Model model, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleResourceInfo started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		model.addAttribute("userInfo", loginSimpleVO);
		
		return "/ezSchedule/scheduleResourceInfo";
	}
	
	/**
	 * 일정작성 > 이름확인 조회
	 */
	@RequestMapping(value = "/ezSchedule/checkName.do", method = RequestMethod.GET)
	public String checkName() throws Exception {
		
		logger.debug("============ checkName started ============");
		
		return "ezSchedule/scheduleCheckName";
	}
	
	/**
	 * 일정 메인화면 > 인쇄
	 */
	@RequestMapping(value = "/ezSchedule/schedulePrint.do", method = RequestMethod.GET)
	public String schedulePrint(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, LoginVO loginVO, Locale locale) throws Exception {
		
		logger.debug("============ schedulePrint started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());
		
		String idList = request.getParameter("idlist");
		String groupId = request.getParameter("groupid");		
		String startDate = request.getParameter("date");		
		String view = request.getParameter("view");
		String endDate = "";
		String name = "";
		String deptName = "";
		String description = "";
				
		if (loginVO.getPrimary().equals("1")) {
			deptName = loginVO.getDeptName1();
			name = loginVO.getDisplayName1();
		} else {
			deptName = loginVO.getDeptName2();
			name = loginVO.getDisplayName2();
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		cal.setTime(sdf.parse(startDate));
		
		startDate = sdf.format(cal.getTime());
		
		if (view.equals("2")) {
			endDate = startDate;
			
			description = "[" + msg.getMessage("ezSchedule.t277", locale) + " " + startDate;
		} else if (view.equals("1")) {			
			cal.add(Calendar.DATE, 6);
			endDate = sdf.format(cal.getTime());
			
			description = "[" + msg.getMessage("ezSchedule.t278", locale) + " " + startDate + " ~ " + endDate;			
		} else if (view.equals("0")) {
			if(!startDate.substring(8,10).equals("01")){
				cal.add(Calendar.MONTH, 1);
				cal.set(Calendar.DATE, 1);
				startDate = sdf.format(cal.getTime());
			}
			cal.set(Calendar.DATE, cal.getActualMaximum(Calendar.DATE));
			endDate = sdf.format(cal.getTime());
			
			description = "[" + msg.getMessage("ezSchedule.t279", locale) + " " + startDate + " ~ " + endDate;			
		}
				
		List<ScheduleInfoVO> sList = scheduleListData(startDate, endDate, idList, groupId, offSetMin, loginVO);
		
		String today = commonUtil.getTodayUTCTime("");
		today = commonUtil.getDateStringInUTC(today, loginVO.getOffset(), false);
		
		model.addAttribute("scheduleListData", sList);
		model.addAttribute("description", description);
		model.addAttribute("deptName", deptName);
		model.addAttribute("name", name);
		model.addAttribute("today", today);
		model.addAttribute("primary", loginVO.getPrimary());
		model.addAttribute("lang", loginVO.getLang());
		
		return "ezSchedule/schedulePrint";
	}
	
	/**
	 * 일정작성 > 인쇄
	 */
	@RequestMapping(value = "/ezSchedule/scheduleContentsPrint.do", method = RequestMethod.POST)
	public String scheduleContentsPrint(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleContentsPrint started ============");
		
		String type = request.getParameter("type");
		String printOwner = request.getParameter("printOwner");
		String printCreator = request.getParameter("printCreator");
		String printCreateDate = request.getParameter("printCreateDate");		
		String printAttendant = request.getParameter("printAttendant");
		String printIsPublic = request.getParameter("printIsPublic");
		String printImportance = request.getParameter("printImportance");
		String printRepetition = request.getParameter("printRepetition");
		String printDate = request.getParameter("printDate");
		String printLocation = request.getParameter("printLocation");
		String printTitle = request.getParameter("printTitle");
		String printAttach = request.getParameter("printAttach");
		String printDocument = request.getParameter("printDocument");
		
		model.addAttribute("type", type);
		model.addAttribute("printOwner", printOwner);
		model.addAttribute("printCreator", printCreator);
		model.addAttribute("printCreateDate", printCreateDate);
		model.addAttribute("printAttendant", printAttendant);
		model.addAttribute("printIsPublic", printIsPublic);
		model.addAttribute("printImportance", printImportance);
		model.addAttribute("printRepetition", printRepetition);
		model.addAttribute("printDate", printDate);
		model.addAttribute("printLocation", printLocation);
		model.addAttribute("printTitle", printTitle);
		model.addAttribute("printAttach", printAttach);
		model.addAttribute("printDocument", printDocument);
		
		//2018-08-09 김보미 - 나라별 폰트가 다르므로 구분하기 위해 추가
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		model.addAttribute("locale", loginVO.getLocale());
		
		return "ezSchedule/scheduleContentsPrint";
	}
	
	/**
	 * 일정작성 > 일정상세 팝업
	 */
	@RequestMapping(value = "/ezSchedule/scheduleRead.do", method = RequestMethod.GET)
	public String scheduleRead(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, LoginVO loginVO, Locale locale) throws Exception {
		
		logger.debug("============ scheduleRead started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		        
		String dateString = "";
		String _date = "";
        String _repeatcount = "0";
        String _pattern = request.getParameter("pattern");
        String pageFrom = request.getParameter("pageFrom");
        String otherid = request.getParameter("otherid");
        String _scheduleid = request.getParameter("id");
		String chk_usersearch = request.getParameter("chk_usersearch");
        String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());
        int tenantId = loginVO.getTenantId();
        String companyID = loginVO.getCompanyID();
        String repStartDate = "";
        
        //baonk 추가 2018-08-08
        String use_cabinet = ezCommonService.getTenantConfig("useCabinet", loginVO.getTenantId());
        if (use_cabinet.equals("YES")) {
			use_cabinet = cabinetAdminService.checkModuleActive("schedl", loginVO);
		}
        
        //일정 상세정보
        ScheduleInfoVO vo = ezScheduleService.getScheduleInfo(_scheduleid, offSetMin, tenantId, companyID);
        if (vo == null) {
        	logger.error("Schedule not found.");
			model.addAttribute("title", egovMessageSource.getMessage("ezSchedule.t342", locale));
			model.addAttribute("mainContent", egovMessageSource.getMessage("ezSchedule.gha03", locale));
			model.addAttribute("subContent", egovMessageSource.getMessage("ezSchedule.gha04", locale));
			return "ezCommon/error";
        }
        
        //일정기간 계산        
        if (vo.getDateType().equals("3")){
        	_repeatcount = request.getParameter("repeatcount");
        	_date = request.getParameter("date");
        	//일정관리 참석자 초대메세지에서 반복일정 걸려있는 일정 조회 시, 회차랑 시작일자를 null로 받아와서 null검사 추가 #14484
        	if (_repeatcount == null) {
        		_repeatcount = "1";
        	}
        	if (_date == null) {
        		_date = vo.getStartDate().substring(0,10);
        	}
        	if (vo.getRepetition().split("\\|")[1].equals("1")) {
        		dateString = msg.getMessage("ezSchedule.t343", locale) + " (" + _repeatcount + msg.getMessage("ezSchedule.t329", locale) + " " + _date + " (" + msg.getMessage("ezSchedule.t280", locale);
        	} else {
        		dateString = msg.getMessage("ezSchedule.t343", locale) + " (" + _repeatcount + msg.getMessage("ezSchedule.t329", locale) + " " + _date + " " 
        					+ vo.getStartDate().substring(11, 16) + " ~ " + vo.getEndDate().substring(11, 16);        		
        	}
        	repStartDate = _date + " " + vo.getStartDate().substring(11, 16);
        } else if (vo.getDateType().equals("2")){
        	dateString = vo.getStartDate().substring(0,10) + " (" + msg.getMessage("ezSchedule.t280", locale) + " ~ " + vo.getEndDate().substring(0,10) + " (" + msg.getMessage("ezSchedule.t280", locale);
        	repStartDate = vo.getStartDate().substring(0,16);
        } else {
        	dateString = vo.getStartDate().substring(0,16) + " ~ " + vo.getEndDate().substring(0,16);
        	repStartDate = vo.getStartDate().substring(0,16);
        }
        
        //자원예약 정보
        int resourceCnt = ezScheduleService.getResourceCount(_scheduleid, tenantId);
        
        //참석자 정보
        if (vo.getHasAttendant().equals("Y")) {        
        	String parentID = (vo.getParentId().equals("0") ? _scheduleid : vo.getParentId());
        	List<AttendantListVO> aList = ezScheduleService.getAttendantList(parentID, offSetMin, tenantId, companyID);
        	
        	model.addAttribute("attendantList", aList);
        	
        	String isMailNoti = "";
        	if(request.getParameter("isMailNoti") != null) {
        			isMailNoti = request.getParameter("isMailNoti");
        	}
            if (isMailNoti.equals("Y")) {
            	// 해당 메일 조회자가 참석 여부 체크 안한 참석자인지 확인
            	String userID = loginVO.getId();
            	for(int i=0; i<aList.size(); i++) {
            		String attendantId = aList.get(i).getAttendantId();
            		String status = aList.get(i).getStatus();
	            	if(status.equals("0") && attendantId.equals(userID)) {
	            		model.addAttribute("attendantCheck", "Y");
	            		break;
	            	}
            	}
            }
        }
        
        //참부파일 정보
        if (vo.getHasAttach().equals("Y")) {        
        	String parentID = (vo.getParentId().equals("0") ? _scheduleid : vo.getParentId());
        	List<AttachListVO> aList = ezScheduleService.getAttachList(parentID, tenantId);
        	
        	for (AttachListVO avo : aList) {        		
        		String fileType = avo.getFileName().substring(avo.getFileName().lastIndexOf(".") + 1).toLowerCase();
        		avo.setFileType(fileType);        		
        		avo.setFileEncodeName(URLEncoder.encode(avo.getFileName(),"UTF-8"));
        		avo.setFileEncodeName(URLEncoder.encode(avo.getFileName(),"UTF-8"));
        		avo.setFilePath(URLEncoder.encode(avo.getFilePath(),"UTF-8"));					// 2018-12-11 김민성 - 파일경로 인코딩 처리
        		
        		String fileSize = commonUtil.byteCalculation(Long.toString(avo.getFileSize()));
        		avo.setFileTranSize(fileSize);
        	}
        	
        	model.addAttribute("attachList", aList);
        }
        
        //참석자 관련 권한부여
        String _admin = "Y";
        String _editPosible = "Y";
        String userId = loginVO.getId();
        String rollInfo = loginVO.getRollInfo();
        String ownerId = vo.getOwnerId();
        String scheduleType = vo.getScheduleType();
        
        if (!ownerId.equals(userId) && !ownerId.equals(otherid) && !vo.getCreatorId().equals(userId) && !vo.getModifierId().equals(userId)	 
        	&& (!scheduleType.equals("2") || !ownerId.equals(loginVO.getDeptID()) ||!commonUtil.isAdmin(userId, tenantId, rollInfo, "c;k;g"))
        	&& (!scheduleType.equals("3") && !scheduleType.equals("2") || !commonUtil.isAdmin(userId, tenantId, rollInfo, "c;k;v")) 
        	|| vo.getIsReadOnly().equals("Y")
        ) {
        	_admin = "N";
        	_editPosible = "N";
        }
        //비서 권한 부여
        List<ScheduleSecretaryVO> tList = ezScheduleService.getPublicScheduleSec(loginVO.getId(), loginVO.getLang(), tenantId ,companyID);
        
        for (ScheduleSecretaryVO ssvo : tList) {
        	if (ssvo.getSecId().equals(vo.getOwnerId())) {
        		_admin = "Y";
        		_editPosible = "Y";
        	}
        }
        
        String isReceive = request.getParameter("isReceive");
        if (isReceive == null ) {
        	isReceive = "";
        } else if (isReceive.equals("Y")) {
        	if (vo.getRepetition().length() > 0) {
        		model.addAttribute("isReceive", isReceive);
        		model.addAttribute("repetitionInfo", vo.getRepetition());
        	}
        }

        //사용자일정검색 시 권한 N 고정
		if(chk_usersearch != null && chk_usersearch.equals("UserSearch")){
			_admin = "N";
			_editPosible = "N";
			use_cabinet = "NO";
		}

		String usage = "Y";
		if (!vo.getOwnerId().equals(loginVO.getId())) {
			usage = ezScheduleService.checkExecutiveUsage(vo.getOwnerId(), vo.getCompanyid(), tenantId) != null ? ezScheduleService.checkExecutiveUsage(vo.getOwnerId(), vo.getCompanyid(), tenantId) : "Y";
		}
		
        model.addAttribute("companyID", companyID);
        model.addAttribute("scheduleInfo", vo);        
        model.addAttribute("_date", _date);
        model.addAttribute("_scheduleid", _scheduleid);
        model.addAttribute("_pattern", _pattern);
        model.addAttribute("pageFrom", pageFrom);
        model.addAttribute("otherid", otherid);
        model.addAttribute("primary", loginVO.getPrimary());
        model.addAttribute("lang", loginVO.getLang());
        model.addAttribute("dateString", dateString);
        model.addAttribute("resourceCnt", resourceCnt);
        model.addAttribute("_admin", _admin);
        model.addAttribute("_editPosible", _editPosible);
        model.addAttribute("useCabinet", use_cabinet); // 캐비넷 추가 baonk 2018-08-08
        model.addAttribute("userInfo", loginVO);
        model.addAttribute("repeatCount", _repeatcount); // 반복일정의 경우 반복횟수
        model.addAttribute("repStartDate", repStartDate); // 반복일정의 경우 해당 반복의 시작날짜 + 시간 (YYYY-MM-DD HH:mm)
        model.addAttribute("showtop", vo.getShowTop()); // 반복일정의 경우 해당 반복의 시작날짜 + 시간 (YYYY-MM-DD HH:mm)
		model.addAttribute("usage", usage); // 임원일정 사용여부

		return "ezSchedule/scheduleRead";
	}
	
	/**
	 * 일정보기 > 반복일정 선택 후 삭제시 팝업 
	 */	
	@RequestMapping(value="/ezSchedule/scheduleDeleteConfirm.do", method = RequestMethod.GET)	
	public String scheduleDeleteConfirm(Model model, HttpServletRequest request) throws Exception {
		logger.debug("============ scheduleDeleteConfirm started ============");
		
		String resourceInfo = request.getParameter("resourceInfo");
		model.addAttribute("resourceInfo", resourceInfo);
		
		logger.debug("============ scheduleDeleteConfirm ended ============");
		
		return "ezSchedule/scheduleDeleteConfirm";
	}
	
	/**
	 * 일정보기 > 모든 반복 일정삭제 (일반삭제) 
	 */	
	@RequestMapping(value="/ezSchedule/scheduleDelete.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public void scheduleDelete(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleDelete started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String scheduleId = request.getParameter("scheduleId");
		String resDel = request.getParameter("resDel");
		String dateType = request.getParameter("dateType");
		
		String offSetMin = commonUtil.getMinuteUTC(loginSimpleVO.getOffset());
		
		List<AttendantListVO> attendantList = new ArrayList<>();
		ScheduleInfoVO scheduleInfo = ezScheduleService.getScheduleInfo(scheduleId, offSetMin, loginSimpleVO.getTenantId(), loginSimpleVO.getCompanyID());
		
		String hasAttendant = scheduleInfo.getHasAttendant();
        if (hasAttendant.equals("Y")) {            	
            String parentId = (scheduleInfo.getParentId().equals("0") ? scheduleId : scheduleInfo.getParentId());    
            attendantList = ezScheduleService.getAttendantList(parentId, offSetMin, loginSimpleVO.getTenantId(), loginSimpleVO.getCompanyID());
        }
        
		if (attendantList != null && attendantList.size() > 0) {
			ezScheduleService.sendInviteScheDelNoti(request, attendantList, scheduleInfo, null, "0", commonUtil.userInfo(loginCookie), loginCookie);
		}
		
		//일정데이터 삭제
		ezScheduleService.deleteSchedule(scheduleId, loginSimpleVO.getTenantId());
		
		//반복일정 삭제
		if (dateType.equals("3")) {
			ezScheduleService.deleteScheduleRepe(scheduleId, loginSimpleVO.getTenantId());
		}
		
		//자원예약 삭제
		if (resDel.toUpperCase().equals("TRUE")) {
			ezScheduleService.deleteResource(scheduleId, loginSimpleVO.getTenantId());
		}		
	}
	
	/**
	 * 일정보기 > 해당 일정만 삭제
	 */	
	@RequestMapping(value="/ezSchedule/scheduleOnceDelete.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public void scheduleOnceDelete(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleOnceDelete started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String scheduleId = request.getParameter("scheduleId");
		String selectDate = request.getParameter("selectDate");
		String startDate = request.getParameter("startDate");
		String realStartDate = selectDate + "" + startDate.substring(10, 16);		
		String repeatCount = request.getParameter("repeatCount");	

		String realDate = commonUtil.getDateStringInUTC(realStartDate, loginSimpleVO.getOffset(), true);
		
		String offSetMin = commonUtil.getMinuteUTC(loginSimpleVO.getOffset());
		
		List<AttendantListVO> attendantList = new ArrayList<AttendantListVO> ();
		ScheduleInfoVO scheduleInfo = ezScheduleService.getScheduleInfo(scheduleId, offSetMin, loginSimpleVO.getTenantId(), loginSimpleVO.getCompanyID());
		
		String hasAttendant = scheduleInfo.getHasAttendant();
        if (hasAttendant.equals("Y")) {            	
            String parentId = (scheduleInfo.getParentId().equals("0") ? scheduleId : scheduleInfo.getParentId());    
            attendantList = ezScheduleService.getAttendantList(parentId, offSetMin, loginSimpleVO.getTenantId(), loginSimpleVO.getCompanyID());
        }
		
		if (attendantList != null) {
			ezScheduleService.sendInviteScheDelNoti(request, attendantList, scheduleInfo, realDate, repeatCount, commonUtil.userInfo(loginCookie), loginCookie);
		}

		//일정데이터 삭제
		ezScheduleService.insertScheduleRepeDel(scheduleId, realDate, loginSimpleVO.getTenantId(), loginSimpleVO.getCompanyID());
		
		/* 2021-11-26 홍승비 - 해당 반복일정의 일정완료 레코드 삭제 (전체 반복완료의 경우 해당 일정 하나만 삭제되더라도 유지해야 하므로, isAllRep 조건은 'N'으로 고정) */
		ezScheduleService.deleteScheduleCompleteOneRep(scheduleId, repeatCount, "N", realDate, loginSimpleVO.getTenantId());
	}
	
	/**
	 * 일정작성 > 인쇄
	 */
	@RequestMapping(value = "/ezSchedule/scheduleManageAttendant.do", method = RequestMethod.GET)
	public String scheduleManageAttendant(@CookieValue("loginCookie") String loginCookie, Model model, LoginVO loginVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleManageAttendant started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());		
		String scheduleId = request.getParameter("id");
		String ownerid = request.getParameter("ownerid");
		
		if (scheduleId != null) {
			scheduleId = scheduleId.replaceAll(" ", "+");
		}
		
		List<AttendantListVO> aList = ezScheduleService.getAttendantList(scheduleId, offSetMin, loginVO.getTenantId(), loginVO.getCompanyID());		
	
		model.addAttribute("attendantList", aList);
		model.addAttribute("scheduleId", scheduleId);
		model.addAttribute("ownerId", ownerid);
		model.addAttribute("primary", loginVO.getPrimary());
		
		return "ezSchedule/scheduleManageAttendant";
	}
	
	/**
	 * 일정보기 > 참석자관리 > 참석자추가
	 */
	@RequestMapping(value = "/ezSchedule/scheduleAddAttendant.do", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public void scheduleAddAttendant(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleAddAttendant started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		String scheduleId = request.getParameter("scheduleId");
		String memberList = request.getParameter("memberList");
		
		JSONParser parser = new JSONParser();
		JSONArray jsonArray = (JSONArray)parser.parse(memberList);
		
		for(int i = 0; i < jsonArray.size(); i++) {
			JSONObject obj = (JSONObject) jsonArray.get(i);
			
			String attendantId = (String) obj.get("attendantId");			
			String attendantName = (String) obj.get("attendantName1");
			String attendantName2 = (String) obj.get("attendantName2");
			String attendantDeptName = (String) obj.get("attendantDeptName");
			String attendantDeptName2 = (String) obj.get("attendantDeptName2");
			
			ezScheduleService.insertScheduleAttendant(scheduleId, attendantId, attendantName, attendantName2, attendantDeptName, attendantDeptName2, loginSimpleVO.getTenantId(), loginSimpleVO.getCompanyID());
			ezScheduleService.updateAttendantSchedule("Y", scheduleId, loginSimpleVO.getTenantId());
			
			String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());
			ScheduleInfoVO vo = ezScheduleService.getScheduleInfo(scheduleId, offSetMin, loginVO.getTenantId(), loginVO.getCompanyID());
			
			String startdate = vo.getStartDate();
			String enddate = vo.getEndDate();
			String datetype = vo.getDateType();
			String repetition = vo.getRepetition();
			String scheDateContent = ezScheduleService.makeScheDateContent(datetype, repetition, startdate, enddate, loginVO.getLocale());
			String scheTimeContent = ezScheduleService.makeScheTimeContent(startdate, enddate, datetype, repetition, loginVO.getLocale());
			String scheRepeContent = ezScheduleService.makeRepetitionContent(repetition, loginVO.getLocale());
			
			String periodConetent = "";
			periodConetent = " &nbsp;&nbsp;- " + msg.getMessage("ezSchedule.t318", loginVO.getLocale()) + " : " + scheDateContent + "<br>";
			periodConetent += " &nbsp;&nbsp;- " + msg.getMessage("ezSchedule.t67", loginVO.getLocale()) + " : " + scheTimeContent;
			
			if (datetype.equals("3")) {
				periodConetent += "<br>" + " &nbsp;&nbsp;- " + msg.getMessage("ezSchedule.t71", loginVO.getLocale()) + " : " + scheRepeContent;
			}
			
			if (!ezPersonalService.hasNotiDiableItem(attendantId, NotiType.SCHEDULE_ADD, NotiPlatform.MAIL, loginVO.getTenantId())) {
				ezScheduleService.scheduleSendMail(Integer.parseInt(scheduleId), attendantId, attendantName, vo.getTitle(), periodConetent, "add", loginVO, loginCookie, startdate, enddate);
			}

			/* 2024-04-12 한태훈 일정관리 통합알림 발송 추가 */
			String linkUrl = "/ezSchedule/scheduleReceiveAttendant.do?from=mail";
			String linkUrlMobile = "/mobile/ezSchedule/mScheduleReceiveAttendant.do";
			
			List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();

			Map<String, Object> recipientMap = new HashMap<String, Object>();
			recipientMap.put("userType", "PERSON");
			recipientMap.put("companyId", loginVO.getCompanyID());
			recipientMap.put("cn", attendantId);
			notiRecipientList.add(recipientMap);
			
			ezNotificationService.sendNoti(request, loginVO.getId(), loginVO.getDisplayName(), notiRecipientList, "schedule", "add", vo.getTitle(), "popup", "730", "370", linkUrl, linkUrlMobile, "");
		}
	}
	
	/**
	 * 일정보기 > 참석자관리 > 참석자제외
	 */	
	@RequestMapping(value="/ezSchedule/scheduleDelAttendant.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public void scheduleDelAttendant(@CookieValue("loginCookie") String loginCookie,LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleDelAttendant started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		String scheduleId = request.getParameter("scheduleId");
		String attendantIdList = request.getParameter("attendantIdList");

		JSONParser parser = new JSONParser();
		JSONArray jsonArray = (JSONArray)parser.parse(attendantIdList);
		
		for(int i = 0; i < jsonArray.size(); i++) {
			JSONObject obj = (JSONObject) jsonArray.get(i);
			
			String attendantId = (String) obj.get("attendantId");			
			String attendantName = (String) obj.get("attendantName");
			
			ezScheduleService.scheduleDelAttendant(scheduleId, attendantId, loginSimpleVO.getTenantId());
			
			String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());
			ScheduleInfoVO vo = ezScheduleService.getScheduleInfo(scheduleId, offSetMin, loginVO.getTenantId(), loginVO.getCompanyID());
			
			String startdate = vo.getStartDate();
			String enddate = vo.getEndDate();
			String datetype = vo.getDateType();
			String repetition = vo.getRepetition();
			String scheDateContent = ezScheduleService.makeScheDateContent(datetype, repetition, startdate, enddate, loginVO.getLocale());
			String scheTimeContent = ezScheduleService.makeScheTimeContent(startdate, enddate, datetype, repetition, loginVO.getLocale());
			String scheRepeContent = ezScheduleService.makeRepetitionContent(repetition, loginVO.getLocale());
			String periodContent = "";
			periodContent = " &nbsp;&nbsp;- " + msg.getMessage("ezSchedule.t318", loginVO.getLocale()) + " : " + scheDateContent + "<br>";
			periodContent += " &nbsp;&nbsp;- " + msg.getMessage("ezSchedule.t67", loginVO.getLocale()) + " : " + scheTimeContent;
			
			if (datetype.equals("3")) {
				periodContent += "<br>" + " &nbsp;&nbsp;- " + msg.getMessage("ezSchedule.t71", loginVO.getLocale()) + " : " + scheRepeContent;
			}
			
			if (!ezPersonalService.hasNotiDiableItem(attendantId, NotiType.SCHEDULE_CANCEl, NotiPlatform.MAIL, loginVO.getTenantId())) {
				ezScheduleService.scheduleSendMail(Integer.parseInt(scheduleId), attendantId, attendantName, vo.getTitle(), periodContent, "del", loginVO, loginCookie, startdate, enddate);
			}

			/* 2024-04-12 한태훈 일정관리 통합알림 발송 추가 */
			String linkUrl = "/ezSchedule/scheduleRead.do?id=" + scheduleId;
			String linkUrlMobile = "";
			
			List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();

			Map<String, Object> recipientMap = new HashMap<String, Object>();
			recipientMap.put("userType", "PERSON");
			recipientMap.put("companyId", loginVO.getCompanyID());
			recipientMap.put("cn", attendantId);
			notiRecipientList.add(recipientMap);
			
			ezNotificationService.sendNoti(request, loginVO.getId(), loginVO.getDisplayName(), notiRecipientList, "SCHEDULE", "CANCEL", vo.getTitle(), "popup", "760", "750", linkUrl, linkUrlMobile, "");
		}
	}
	
	/**
	 * 일정메인 > 참석자 초대 팝업
	 */	
	@RequestMapping(value="/ezSchedule/scheduleReceiveAttendant.do", method = RequestMethod.GET)	
	public String scheduleReceiveAttendant(@CookieValue("loginCookie") String loginCookie,LoginVO loginVO, Model model, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleReceiveAttendant started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());
		String serverFlag = request.getParameter("serverFlag");
		String serverName = request.getScheme() + "://" + request.getServerName();
		String from       = request.getParameter("from");
		
		List<ScheduleReceiveListVO> rList = ezScheduleService.getReceiveList(loginVO.getId(), loginVO.getTenantId(), offSetMin, loginVO.getCompanyID());
		
		model.addAttribute("receiveList", rList);
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("serverFlag", serverFlag);
		model.addAttribute("serverName", serverName);
		model.addAttribute("from", from);
		
		return "ezSchedule/scheduleReceiveAttendant";
	}
	
	/**
	 * 일정보기 > 참석자관리 > 참석수락
	 */	
	@RequestMapping(value="/ezSchedule/scheduleAcceptAttendant.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public void scheduleAcceptAttendant(@RequestParam(value="scheduleIdList[]") String[] scheduleIdList, @CookieValue("loginCookie") String loginCookie,LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleAcceptAttendant started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		String status = request.getParameter("status");
		String displayName = request.getParameter("displayName");
		String displayName2 = request.getParameter("displayName2");
		String creatorList = request.getParameter("creatorList");
		String attendantId = loginSimpleVO.getId();
		
		JSONParser parser = new JSONParser();
		JSONArray jsonArray = (JSONArray)parser.parse(creatorList);
		
		for (int i=0; i < scheduleIdList.length; i++) {
			JSONObject obj = (JSONObject) jsonArray.get(i);
			String creatorId = (String) obj.get("creatorId");			
			String creatorName = (String) obj.get("creatorName");
			String title = (String) obj.get("title");
			String dateType = (String) obj.get("dateType");
			String startDate = (String) obj.get("startDate");
			String endDate = (String) obj.get("endDate");
            String showtop = obj.get("showtop") == null ? "N" : obj.get("showtop").toString();

            ezScheduleService.updateAttendant(scheduleIdList[i], attendantId, displayName, displayName2, status, loginSimpleVO.getTenantId(), showtop, loginSimpleVO.getLang(), loginSimpleVO.getOffset());

			String repetition = (String) obj.get("repetition");
			
			String scheDateContent = ezScheduleService.makeScheDateContent(dateType, repetition, startDate, endDate, loginVO.getLocale());
			String scheTimeContent = ezScheduleService.makeScheTimeContent(startDate, endDate, dateType, repetition, loginVO.getLocale());
			String scheRepeContent = ezScheduleService.makeRepetitionContent(repetition, loginVO.getLocale());
			
			String periodContent = "";
			periodContent = " &nbsp;&nbsp;- " + msg.getMessage("ezSchedule.t318", loginVO.getLocale()) + " : " + scheDateContent + "<br>";
			periodContent += " &nbsp;&nbsp;- " + msg.getMessage("ezSchedule.t67", loginVO.getLocale()) + " : " + scheTimeContent;
			
			if (dateType.equals("3")) {
				periodContent += "<br>" + " &nbsp;&nbsp;- " + msg.getMessage("ezSchedule.t71", loginVO.getLocale()) + " : " + scheRepeContent;
			}
			
			if(status.equals("1")) {
				if (!ezPersonalService.hasNotiDiableItem(creatorId, NotiType.SCHEDULE_ACCEPT, NotiPlatform.MAIL, loginVO.getTenantId())) {
 					ezScheduleService.scheduleSendMail(Integer.parseInt(scheduleIdList[i]), creatorId, creatorName, title, periodContent, "acc", loginVO, loginCookie, startDate, endDate);
 				}

				/* 2024-04-12 한태훈 일정관리 통합알림 발송 추가 */
				String linkUrl = "/ezSchedule/scheduleRead.do?id=" + scheduleIdList[i];
				String linkUrlMobile = "/mobile/ezSchedule/mScheduleDetail.do?scheduleId=" + scheduleIdList[i] + "&startDate=" + startDate.substring(0,16) + "&endDate=" + endDate.substring(0,16) + "&date=" + startDate.substring(0,16) + "&type=monthList&purpose=scheduleInfoDetail";
				
				List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();

				Map<String, Object> recipientMap = new HashMap<String, Object>();
				recipientMap.put("userType", "PERSON");
				recipientMap.put("companyId", loginVO.getCompanyID());
				recipientMap.put("cn", creatorId);
				notiRecipientList.add(recipientMap);
				
				ezNotificationService.sendNoti(request, loginVO.getId(), loginVO.getDisplayName(), notiRecipientList, "schedule", "accept", title, "popup", "760", "750", linkUrl, linkUrlMobile, "");
			}
			else {
				if (!ezPersonalService.hasNotiDiableItem(creatorId, NotiType.SCHEDULE_REJECT, NotiPlatform.MAIL, loginVO.getTenantId())) {
 					ezScheduleService.scheduleSendMail(Integer.parseInt(scheduleIdList[i]), creatorId, creatorName, title, periodContent, "rej", loginVO, loginCookie, startDate, endDate);
 				}

				/* 2024-04-12 한태훈 일정관리 통합알림 발송 추가 */
				String linkUrl = "/ezSchedule/scheduleRead.do?id=" + scheduleIdList[i];
				String linkUrlMobile = "/mobile/ezSchedule/mScheduleDetail.do?scheduleId=" + scheduleIdList[i] + "&startDate=" + startDate.substring(0,16) + "&endDate=" + endDate.substring(0,16) + "&date=" + startDate.substring(0,16) + "&type=monthList&purpose=scheduleInfoDetail";

				List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
				Map<String, Object> recipientMap = new HashMap<String, Object>();
				recipientMap.put("userType", "PERSON");
				recipientMap.put("companyId", loginVO.getCompanyID());
				recipientMap.put("cn", creatorId);
				notiRecipientList.add(recipientMap);
				
				ezNotificationService.sendNoti(request, loginVO.getId(), loginVO.getDisplayName(), notiRecipientList, "schedule", "reject", title, "popup", "760", "750", linkUrl, linkUrlMobile, "");
			}
		}	
	}
	
	/**
	 * 일정메인 > 그룹 초대 팝업
	 */	
	@RequestMapping(value="/ezSchedule/scheduleReceiveMember.do", method = RequestMethod.GET)	
	public String scheduleReceiveMember(@CookieValue("loginCookie") String loginCookie, LoginVO loginVO, Model model, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleReceiveMember started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());
		String serverFlag = request.getParameter("serverFlag");
		String serverName = request.getScheme() + "://" + request.getServerName();
				
		List<ScheduleGroupListVO> iList = ezScheduleService.getInviteScheduleGroupList(loginVO.getId(), loginVO.getTenantId(), offSetMin, loginVO.getCompanyID());
		
		model.addAttribute("receiveList", iList);
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("serverFlag", serverFlag);
		model.addAttribute("serverName", serverName);
		
		return "ezSchedule/scheduleReceiveMember";
	}
	
	/**
	 * 일정보기 > 그룹 초대 > 수락 or 거절
	 */	
	@RequestMapping(value="/ezSchedule/scheduleAcceptMember.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public void scheduleAcceptMember(@RequestParam(value="groupIdList[]") String[] groupIdList, @CookieValue("loginCookie") String loginCookie,LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleAcceptMember started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String status = request.getParameter("status");		
		String userId = loginSimpleVO.getId();
		
		for (int i=0; i < groupIdList.length; i++) {
			ezScheduleService.updateScheduleMember(groupIdList[i], userId, status, loginSimpleVO.getTenantId());
		}	
	}
	
	/**
	 * 일정보기 > 반복일정 보기 방식 선택
	 */	
	@RequestMapping(value="/ezSchedule/scheduleReadConfirm.do", method = RequestMethod.GET)
	public String scheduleReadConfirm() throws Exception {
		
		logger.debug("============ scheduleReadConfirm started ============");
		
		return "ezSchedule/scheduleReadConfirm";
	}

	/**
	 * 일정작성 > 첨부파일 리스트 호출 
	 */
	@RequestMapping(value = "/ezSchedule/scheduleDragAndDrop.do", method = RequestMethod.GET)
	public String scheduleDragAndDrop(@CookieValue("loginCookie") String loginCookie, Model model, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleDragAndDrop started ============");

        loginVO = commonUtil.userInfo(loginCookie);
		
        String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", loginVO.getTenantId());
		
		if (attachFileNameMaxLength.equals("")) {
			attachFileNameMaxLength = "100";
		}
        
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		
		return "ezSchedule/scheduleDragAndDrop";
	}	
		
	/**
	 * 일정작성 > 첨부파일 업로드
	 */
	@RequestMapping(value = "/ezSchedule/uploadScheduleAttach.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String uploadScheduleAttach(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO) throws Exception{
		
		logger.debug("============ uploadScheduleAttach started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		List<MultipartFile> multiFile = request.getFiles("fileToUpload"); 
		int cnt = multiFile.size();
		
		String realPath = request.getServletContext().getRealPath("");
		String[] pFileName = new String[cnt];
        Long[] fileSize = new Long[cnt];        
        String[] resultUpload = new String[cnt];
        String[] sGUID = new String[cnt];
        String[] pUploadSN = new String[cnt];
        
        String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", loginSimpleVO.getTenantId());

        for (int i = 0; i < cnt; i++) {
            resultUpload[i] = "false";
            sGUID[i] = UUID.randomUUID().toString();
            pUploadSN[i] = "{" + sGUID[i] + "}";
        }

        if (StringUtils.isNotEmpty(multiFile.get(0).getOriginalFilename()) && StringUtils.isNotBlank(multiFile.get(0).getOriginalFilename())) {        	
            for (int i = 0; i < cnt; i++) {
                String _pFileName = multiFile.get(i).getOriginalFilename();
                if (_pFileName.indexOf(commonUtil.separator) > 0) {
                    _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
                }
                pFileName[i] = _pFileName;
            }
        }

/*        for (int i = 0; i < cnt; i++) {
            pFileName[i] = pFileName[i].replace("+", "%2b");
            pFileName[i] = pFileName[i].replace(";", "%3b");
        }*/
        
        String pDirPath = commonUtil.getUploadPath("upload_schedule.ROOT", loginSimpleVO.getTenantId());

        pDirPath = realPath + pDirPath;
        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
		EzFAL.EzFile file = new EzFAL.EzFile(commonUtil.detectPathTraversal(pDirPath + "uploadFile"));

        if (!file.exists()) {
        	file.mkdirs();        
        }

        StringBuffer strXML = new StringBuffer();
        strXML.append("<ROOT><NODES>");
        
        for (int i = 0; i < cnt; i++) {        	
        	fileSize[i] = multiFile.get(i).getSize();
            String extend = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
            String newFileName = pUploadSN[i] + "." + extend;
            
			// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
            if ((extend.isEmpty() || useExtension.toLowerCase().indexOf(extend.toLowerCase()) == -1) && !useExtension.equals("*")) {           	
				strXML.append("<DATA><![CDATA[" + newFileName + "/" + pFileName[i] + "/" + fileSize[i] + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[]]></DATA2>");
				strXML.append("<DATA3><![CDATA[denied]]></DATA3>");
            } else {
				writeUploadedFile(multiFile.get(i), newFileName, pDirPath + "uploadFile");
				strXML.append("<DATA><![CDATA[" + newFileName + "/" + pFileName[i] + "/" + fileSize[i] + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[]]></DATA2>");
				strXML.append("<DATA3><![CDATA[OK]]></DATA3>");
            }
        }
        strXML.append("</NODES></ROOT>");
        
        return strXML.toString();
    }
	
	/**
	 * 일정보기 > 첨부파일 다운로드
	 */
	@RequestMapping(value = "/ezSchedule/downloadAttach.do", method = RequestMethod.GET)
	@ResponseBody
	public void downloadAttach(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		logger.debug("============ downloadAttach started ============");
		
		userInfo = commonUtil.userInfoSimple(loginCookie);		

		String filePath = request.getParameter("filePath");		
		String fileName = request.getParameter("fileName");
		String realPath = commonUtil.getRealPath(request);
		String uploadFilePath = commonUtil.getUploadPath("upload_schedule.ROOT", userInfo.getTenantId());
		
		if (fileName == null || fileName.equals("")) {
			fileName = filePath; 
		}
		
		String fullFilePath = commonUtil.detectPathTraversal(realPath + uploadFilePath + filePath);

		downFile(request, response, fullFilePath, fileName);	
	}
    
	
	/**
	 * 일정작성 > 자원예약을 위한 반복일정 첫날 구하기
	 */
	@RequestMapping(value = "/ezSchedule/getFirstScheduleDate.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String getFirstScheduleDate(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, @RequestBody String requestXML) throws Exception{
		
		logger.debug("============ getFirstScheduleDate started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(requestXML);
        String startDate = doc.getElementsByTagName("STARTDATE").item(0).getTextContent();
        String endDate = doc.getElementsByTagName("ENDDATE").item(0).getTextContent();
        String repetition = doc.getElementsByTagName("REPETITION").item(0).getTextContent();
        
        String returnValue = "";
		Date firstDate = null;
		String[] info = repetition.split("\\|");
		int maxCount = Integer.parseInt(info[0]);
		int count = 0;
		int count2 = 0;
		boolean isFirst = true;

		if (maxCount == 0) {
			maxCount = -1;
		}

		Calendar date_cal = Calendar.getInstance();

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		
		date_cal.setTime(sdf.parse(startDate));

		switch (info[2]) {
		case "0" :
			while (true) {
				if (maxCount == count) break;

				boolean generated = false;
				int dayOFWeek = date_cal.get(Calendar.DAY_OF_WEEK) - 1;

				if (info[3].equals("0")) {
					if (dayOFWeek != 0 && dayOFWeek != 6) {
						generated = true;
					}
				} else {
					generated = true;
				}

				if (generated) {
					count++;
					
					firstDate = date_cal.getTime();
					break;
				}

				if (info[3].equals("0")) {
					date_cal.add(Calendar.DATE, 1);
				} else {
					date_cal.add(Calendar.DATE, Integer.parseInt(info[3]));
				}
			}
			break;

		case "1" :
			int weekcount = 6 - date_cal.get(Calendar.DAY_OF_WEEK) - 1;

			while (true) {
				if (maxCount == count) break;

				boolean generated = false;

				if (info[4].indexOf((date_cal.get(Calendar.DAY_OF_WEEK) - 1) + "") > -1) {
					generated = true;
				}

				if (generated) {
					count++;

					firstDate = date_cal.getTime();
					break;
				}

				if (weekcount == 0) {
					date_cal.add(Calendar.DATE, (Integer.parseInt(info[3]) - 1) * 7 + 1);
					weekcount = 6;
				} else {
					date_cal.add(Calendar.DATE, 1);
					weekcount--;
				}
			}						
			break;	

		case "2" :
			while (true) {						
				int year = date_cal.get(Calendar.YEAR);
				int month = date_cal.get(Calendar.MONTH) + 1;

				if (maxCount == count) break;

				boolean generated = false;

				Calendar newCal = Calendar.getInstance();
				newCal.set(year, month-1, 1);

				if (info[3].equals("1")) {
					newCal.add(Calendar.DATE, Integer.parseInt(info[5]) - 1);
				} else {
					int diff = Integer.parseInt(info[6]) - (newCal.get(Calendar.DAY_OF_WEEK) - 1);

					if (diff < 0) {
						diff += 7;									
					}								
					newCal.add(Calendar.DATE, diff);

					if (Integer.parseInt(info[5]) < 5) {
						newCal.add(Calendar.DATE, (Integer.parseInt(info[5]) - 1) * 7);
					} else {
						while (true) {
							newCal.add(Calendar.DATE, 7);

							if (newCal.get(Calendar.MONTH) + 1 != month) {
								newCal.add(Calendar.DATE, -7);
								break;
							}
						}
					}
				}

				if (newCal.get(Calendar.MONTH) + 1 == month && (!isFirst || newCal.get(Calendar.DATE) >= date_cal.get(Calendar.DATE))) {
					generated = true;
				}

				isFirst = false;

				if (generated) {
					count++;

					firstDate = newCal.getTime();
					break;
				}

				date_cal.add(Calendar.DATE, 1 - date_cal.get(Calendar.DATE));
				date_cal.add(Calendar.MONTH, Integer.parseInt(info[4]));							
			}
			break;

		case "3" :
			while (true) {
				int year = date_cal.get(Calendar.YEAR);
				int month = Integer.parseInt(info[4]);

				if (maxCount == count) break;

				if (10 == count2) {
					returnValue = "firstScheduleDateNotFound";
					break;
				}

				boolean generated = false;

				Calendar newCal = Calendar.getInstance();
				newCal.set(year, month-1, 1);

				if (info[3].equals("1")) {
					newCal.add(Calendar.DATE, Integer.parseInt(info[5]) - 1);

					if (info[5].equals("2")) {
						//음력으로 newCal 다시 만듬									
						if (!isFirst || newCal.compareTo(date_cal) >= 0) {
							generated = true;
						}
					}
				} else {
					int diff = Integer.parseInt(info[6]) - (newCal.get(Calendar.DAY_OF_WEEK) - 1); 

					if (diff < 0) {
						diff += 7;									
					}								
					newCal.add(Calendar.DATE, diff);

					if (Integer.parseInt(info[5]) < 5) {
						newCal.add(Calendar.DATE, (Integer.parseInt(info[5]) - 1) * 7);
					} else {
						while (true) {
							newCal.add(Calendar.DATE, 7);

							if (newCal.get(Calendar.MONTH) + 1 != month) {
								newCal.add(Calendar.DATE, -7);
								break;
							}
						}
					}
				}

				if (newCal.get(Calendar.MONTH) + 1 == month && (!isFirst || newCal.get(Calendar.DATE) >= date_cal.get(Calendar.DATE))) {
					generated = true;
				}

				isFirst = false;

				if (generated) {
					count++;

					firstDate = newCal.getTime();
					break;
				}

				date_cal.add(Calendar.DATE, 1 - date_cal.get(Calendar.DATE));
				date_cal.add(Calendar.YEAR, 1);

				count2++;
			}						
			break;	
		}				
		
		if (firstDate != null) {
			if (info[1].equals("1")) {
				String rStartDate = sdf.format(firstDate).substring(0, 10);
				returnValue = "allday|" + rStartDate;
			} else {
				String rStartDate = sdf.format(firstDate).substring(0, 10) + startDate.substring(10);
				String rEndDate = sdf.format(firstDate).substring(0, 10) + endDate.substring(10);
				returnValue = rStartDate + "|" + rEndDate;
			}
		}
		
        return returnValue;
    }
	
	/**
	 * 메일 > 일정 조회 > 유저의 읽기권한 체크
	 */
	@RequestMapping(value = "/ezSchedule/getScheduleRead.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String getScheduleRead(@CookieValue("loginCookie") String loginCookie,LoginVO loginVO, Model model, HttpServletRequest request) throws Exception {
		logger.debug("============ check ScheduleRead permission started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		String scheduleId = request.getParameter("scheduleid");
		
		// 1. scheduleID로 일정을 가져와서 본인의 일정인지 확인
		ScheduleInfoVO scheduleInfo = ezScheduleService.getScheduleInfo(scheduleId, loginVO.getOffset(), loginVO.getTenantId(), loginVO.getCompanyID());
		if(scheduleInfo == null) {
			return "D";
		}
		if(scheduleInfo.getCreatorId().equals(loginVO.getId())) {
			return "Y";
		}
		
		// 2. scheduleID와 id로 참석자 리스트를 가져와서 참석 대상자 또는 참석자인지 확인
		List<AttendantListVO> attendantList = ezScheduleService.getAttendantList(scheduleId, loginVO.getOffset(), loginVO.getTenantId(), loginVO.getCompanyID());
		for(int i=0; i<attendantList.size(); i++) {
			AttendantListVO attendant = attendantList.get(i);
			if(attendant.getAttendantId().equals(loginVO.getId()) && !attendant.getStatus().equals("2")) {
				return "Y";
			}
		}
		
		return "N";
	}
	
	/**
	 * 일정작성 > icalendar import
	 */
	@RequestMapping(value = "/ezSchedule/icsImport.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	public String icsImport(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO loginVO, Model model, HttpServletResponse response) throws Exception{
		logger.debug("icsImport start");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		String result = "OK";
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		
		//Setting startDate, endDate
		Calendar startCal = Calendar.getInstance();
		Calendar endCal = Calendar.getInstance();
		
		if (startDate != null && !startDate.equals("")) {
			String[] sDate = startDate.split("-");
			startCal.set(Integer.parseInt(sDate[0]), Integer.parseInt(sDate[1]) - 1, Integer.parseInt(sDate[2])); 
		}
		
		if (endDate != null && !endDate.equals("")) {
			String[] eDate = endDate.split("-");
			endCal.set(Integer.parseInt(eDate[0]), Integer.parseInt(eDate[1]) -1, Integer.parseInt(eDate[2])); 
		}
		
		logger.debug("filter startCal: " + startCal.get(Calendar.YEAR) + "/" + (startCal.get(Calendar.MONTH) + 1) + "/" + startCal.get(Calendar.DAY_OF_MONTH));
		logger.debug("filter endCal:   " + endCal.get(Calendar.YEAR)   + "/" + (endCal.get(Calendar.MONTH) + 1) + "/" + endCal.get(Calendar.DAY_OF_MONTH));
		
		MultipartFile multiFile = request.getFile("file1");
		
		//Setting default
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
		
		String defaultPath   = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_schedule.ROOT", loginVO.getTenantId());
		String realPath      = commonUtil.getRealPath(request);
		String scheme        = "http://";
		
		if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
			scheme = "https://";
		}
		
		InputStream fin = null;
		
		try {
			//Parsing a calendar file
			System.setProperty("net.fortuna.ical4j.timezone.cache.impl", MapTimeZoneCache.class.getName());
			
			fin = new BufferedInputStream(multiFile.getInputStream()); 
			 
			CalendarBuilder builder = new CalendarBuilder();
			
			net.fortuna.ical4j.model.Calendar calendar = builder.build(fin);
			
			//Filtering events
			Period period = new Period(new DateTime(startCal.getTime()), new DateTime(endCal.getTime()));
			Filter<CalendarComponent> filter = new Filter<CalendarComponent>(new PeriodRule<CalendarComponent>(period));
			
			ComponentList<CalendarComponent> cal = calendar.getComponents(Component.VEVENT);
			
			Collection<CalendarComponent> filterCal = filter.filter(cal);
			
			VEvent vEvent = null;
		
			for (Component c : filterCal) {
				if (c instanceof VEvent) {
					
					vEvent = ((VEvent) c);
					
					String title = vEvent.getSummary().getValue();
					title = title.isEmpty()? "no title": substringData(title.trim(), 100);
					
					String location   = substringData(vEvent.getLocation().getValue().trim(), 50);
					String content    = vEvent.getDescription().getValue().trim();
					String ispublic   = "";
					String datetype   = "";
					String repetition = "";
					String sdate      = "";
					String edate      = "";
					String showtop    = "N";

					//content를 mht로 바꾸기 위해서
					content = "<html><head><meta content=\"text/html; charset=utf-8\" http-equiv=\"Content-Type\"><style type=\"text/css\">P { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } DIV { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }TD { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } UL { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } OL { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } LI { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } BODY { MARGIN-RIGHT: 10px; FONT-SIZE:10PT; LINE-HEIGHT:1.3; FONT-FAMILY:Malgun Gothic } TABLE TD { text-indent: 0px } BLOCKQUOTE { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px;}</style></head><body><div>" + contentSplit(content)  + "</div></body></html>";
					content = contentToMHT(content, scheme, realPath, loginVO.getLocale());
					
					DtStart dtStart  = vEvent.getStartDate();
					DtEnd dtEnd      = vEvent.getEndDate();
					
					Date dtStartDate = dtStart.getDate();
					Date dtEndDate   = dtEnd.getDate();
					
					Calendar dtStartCal = Calendar.getInstance();
					Calendar dtEndCal   = Calendar.getInstance();
					Calendar tempEndCal = Calendar.getInstance();
					
					dtStartCal.setTime(dtStartDate);
					dtEndCal.setTime(dtEndDate);
					tempEndCal.setTime(dtEndDate);
					
					if (vEvent.getClassification() != null) {
						String clazz = vEvent.getClassification().getValue();
						
						switch (clazz) {
							case "PRIVATE" : ispublic = "N"; break;
							case "PUBLIC"  : ispublic = "Y"; break;
							default: ispublic = "N"; break;
						}
					}
					else { //기본공개설정상태
						ispublic = "Y";
					}
					
					List<RRule> rrules = vEvent.getProperties(Property.RRULE);
					if (rrules.size() == 0) { //반복일정이 없는 경우
						if (dtStart.getParameter("VALUE") != null) {
							if (dtStart.getParameter("VALUE").getValue().equals("DATE")) { //하루종일
								datetype = "2";
								
								//시작시간 00시  설정
								dtStartCal.set(Calendar.HOUR_OF_DAY, 0);
								
								//구글은 다음날로 나오므로 하루전 23시 59분으로 설정
								dtEndCal.add(Calendar.DATE, -1);
								dtEndCal.set(Calendar.HOUR_OF_DAY, 23);
								dtEndCal.set(Calendar.MINUTE, 59);
								
							}
						}
						else {
							datetype = "1";
						}
					}
					else { //반복설정이 있는 경우
						datetype = "3";
						
						String[] info = new String[7];
						if (rrules.size() > 1) { //한개의 이벤트에 만약 여러개 반복일정이 있다면
							continue;
						}
						else {
							RRule rrule = rrules.get(0);
							Recur recur = rrule.getRecur();
							
							//Setting info[0]
							if (recur.getUntil() == null) { //종료일없음
								if (recur.getCount() == -1) {
									info[0] = "-1";
								}
								else {
									info[0] = String.valueOf(recur.getCount());
								}
							}
							else { //종료일있음
								info[0] = "0";
								
								//시간정보는 가져와야함!
								dtEndDate = recur.getUntil();
								dtEndCal.setTime(dtEndDate);
								dtEndCal.set(Calendar.HOUR_OF_DAY, tempEndCal.get(Calendar.HOUR_OF_DAY));
								dtEndCal.set(Calendar.MINUTE, tempEndCal.get(Calendar.MINUTE));
								dtEndCal.set(Calendar.SECOND, 0);
							}
							
							//Setting info[1]
							if (dtStart.getParameters().toString().indexOf("VALUE=DATE") > -1) { //하루종일
								info[1] = "1";
								
								
								//시작시간 00시
								dtStartCal.set(Calendar.HOUR_OF_DAY, 0);
								
								//구글은 다음날로 나오므로 하루전 23시 59분으로 설정
								dtEndCal.add(Calendar.DATE, -1);
								dtEndCal.set(Calendar.HOUR_OF_DAY, 23);
								dtEndCal.set(Calendar.MINUTE, 59);
								
							}
							else { //시간지정
								info[1] = "0";
							}
							
							//Setting info[2]
							if (recur.getFrequency() != null) {
								switch (recur.getFrequency()) {
									case "DAILY":
										info[2] = "0";
										
										//Setting info[3]
										info[3] = recur.getInterval() == -1 ? "1" : String.valueOf(recur.getInterval());
										break;
									case "WEEKLY": 
										info[2] = "1";
										
										//Setting info[3]
										info[3] = recur.getInterval() == -1 ? "1" : String.valueOf(recur.getInterval());
										
										//Setting info[4]
										if (recur.getDayList() != null) {
											info[4] = "";
											for (WeekDay weekDay : recur.getDayList()) {
												info[4] += changeInfo(weekDay.getDay().toString());
											}
										}
										break;
									case "MONTHLY":
										info[2] = "2";
										
										if (recur.getDayList().size() == 0) {
											//Setting info[3]
											info[3] = "1";
											
											//Setting info[4]
											info[4] = recur.getInterval() == -1 ? "1" : String.valueOf(recur.getInterval());
											
											//Setting info[5]
											info[5] = String.valueOf(recur.getMonthDayList().get(0));
										}
										else {
											//Setting info[3]
											info[3] = "2";
											
											//Setting info[4]
											info[4] = recur.getInterval() == -1 ? "1" : String.valueOf(recur.getInterval());
											
											//Setting info[5] + Setting info[6]
											if (recur.getDayList().size() > 1) { //사이즈1이여야함
												continue;
											}
											else {
												WeekDay weedkDay = recur.getDayList().get(0);
												info[5] = weedkDay.toString().substring(0, 1);
												
												if (info[5].equals("-")) { //매월마지막인지체크
													info[5] = "5";
													info[6] = changeInfo(weedkDay.toString().substring(2));
												}
												else {
													info[6] = changeInfo(weedkDay.toString().substring(1));
												}
											}
										}
										break;
									case "YEARLY":
										info[2] = "3";
										
										//Setting info[4]
										if (recur.getInterval() == -1 || recur.getInterval() == 1) {
											info[4] = String.valueOf(dtStartCal.get(Calendar.MONTH) + 1);
										} 
										else { //반복주기가 1년보다 클 때
											continue;
										}
										
										if (recur.getSetPosList().size() == 0) {
											//Setting info[3]
											info[3] = "1";
											
											//Setting info[5]
											info[5] = String.valueOf(dtStartCal.get(Calendar.DATE));
										}
										else {
											//Setting info[3]
											info[3] = "2";
											
											//Setting info[5]
											if (recur.getSetPosList().size() > 1) { //사이즈1이여야함
												continue;
											}
											else {
												info[5] = recur.getSetPosList().get(0).toString();
											}
											
											//Setting info[6]
											if (recur.getDayList().size() > 1) { //사이즈1이여야함
												continue;
											}
											else {
												WeekDay weekday = recur.getDayList().get(0);
												info[6] = changeInfo(weekday.getDay().toString());
											}	
										}
										
										break;
									default: break;
								}
							}
						}
						
						ArrayList<String> list = new ArrayList<String>(Arrays.asList(info));
						repetition = list.stream().filter(StringUtils::isNotBlank).collect(Collectors.joining("|"));
					}
					
					sdate = sdf.format(dtStartCal.getTime());
					edate = sdf.format(dtEndCal.getTime());
					
					//scheduletype 개인일정, importance 중요도보통 설정
					ezScheduleService.insertSchedule(loginVO.getId(), loginVO.getDisplayName(), loginVO.getDisplayName2(), loginVO.getId(), loginVO.getDisplayName(), loginVO.getDisplayName2(), "1", "2", ispublic, datetype, sdate, edate, repetition, title, location, content, null, 
						null, null, null, null, null, defaultPath, loginVO.getTenantId(), loginVO.getCompanyID(), showtop, loginVO.getOffset(), loginVO.getLang());
					
					/*for(Object sch : c.getProperties()) {
						System.out.println(sch);
					}*/
					
					vEvent = null;
				}
				else{
					logger.error("Check ics file format.");
					model.addAttribute("result", "ERROR");
					return "/ezSchedule/scheduleImportComplete";
				}
			}
		} catch(ParserException e) {
			logger.debug("Parse Error");
			logger.error(e.getMessage(), e);
		} catch(Exception e) {
			logger.debug("Error");
			logger.error(e.getMessage(), e);
		} finally {
			if (fin != null) { try { fin.close(); } catch (IOException e) {logger.debug("e.message=" + e.getMessage());} }
		}
		
		model.addAttribute("result", result);
		
		logger.debug("icsImport end");
		return "/ezSchedule/scheduleImportComplete";
	}
	
	/**
	 * 메일 > ical 메일 > 그룹웨어 일정등록
	 */
	@RequestMapping(value = "/ezSchedule/icsImportFromEmail.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String icsImportFromEmail(HttpServletRequest request,HttpServletResponse response , @CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception {
		logger.debug("icsImportFromEmail started");
		String reMsg = "OK";
		
		String url      = URLDecoder.decode(request.getParameter("pURL"), "utf-8");
		String shareId  = request.getParameter("shareId");
		logger.debug("url={}, shareId={}", url, shareId);
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		LoginVO loginVO       = commonUtil.userInfo(loginCookie);
		String domainName     = ezCommonService.getTenantConfig("DomainName", loginVO.getTenantId());
		String userEmail      = loginVO.getId() + "@" + domainName;
		String password       = userInfo.get(1);
		
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginVO.getTenantId());

		if (useSharedMailbox.equals("YES") && (shareId != null && !shareId.equals(""))) {
			if (!ezEmailService.checkUserShareId(loginVO.getId(), shareId, loginVO.getTenantId())) {
				logger.debug("the user cannot access the shareId.");
				logger.debug("downloadAttach ended.");
				
				return "ERROR_SHAREMAILBOX";
			}
			
			userEmail = shareId + "@" + domainName;
		}
		logger.debug("userId={}, userEmail={}", loginVO.getId(), userEmail);

		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
		
		String defaultPath   = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_schedule.ROOT", loginVO.getTenantId());
		String realPath      = commonUtil.getRealPath(request);
		String scheme        = "http://";
		
		if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
			scheme = "https://";
		}

		
		long uid = 0;
		String folderPath = null;
		
		if (url != null) {
			int index = url.lastIndexOf("/");
			
			// separate the passed-in url into a folder path and a message uid
			if (index != -1) {
				folderPath = url.substring(0, index);
				uid = Long.parseLong(url.substring(index + 1));
			}
		}
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
	
			Folder f = ia.getFolder(folderPath);
			
			if (f == null || !f.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
				reMsg = "ERROR_FOLDER";
			} else {
				f.open(Folder.READ_ONLY);
				Message message = null;
				if(f.isOpen() && f instanceof IMAPFolder){
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				
				Part icalPart = null;
				if (message == null) {
					logger.error("Message not found. uid=" + uid);
				} else {
					icalPart = ezEmailUtil.getIcalMailPart(message);
				}
					
				if (icalPart != null && icalPart.isMimeType("text/calendar")) {
					
					// icsImport.do
					InputStream fin = icalPart.getInputStream();
					try {
			        	
			    		CalendarBuilder cb = new CalendarBuilder();
			    		net.fortuna.ical4j.model.Calendar cal = cb.build(fin);
			    		
			            ComponentList<CalendarComponent> compVEVENT = cal.getComponents(Component.VEVENT);
						
						VEvent vEvent = null;
					
						for (Component c : compVEVENT) {
							if (c instanceof VEvent) {
								
								vEvent = ((VEvent) c);
								
								Summary summary = vEvent.getSummary();
								String title    = (summary == null || summary.getValue().isEmpty()) ? "no title"
										        : substringData(summary.getValue().trim(), 100);
								
								Location lo     = vEvent.getLocation();
								String location = (lo == null) ? "" : substringData(lo.getValue().trim(), 50);
								
								// 본문 =====================
								String content       = "";
								String altDescBody   = ""; 
								
								Property pp          = vEvent.getProperty("X-ALT-DESC");
								if (pp != null) {
									Parameter fmType = pp.getParameter(Parameter.FMTTYPE);
									logger.debug("X-ALT-DESC;fmType={}", fmType.getValue());
									
									content = pp.getValue();
								} else {
									Description description = vEvent.getDescription();
									
									content = (description == null) ? "" : description.getValue();
								}

								String ispublic   = "";
								String datetype   = "";
								String repetition = "";
								String sdate      = "";
								String edate      = "";
								String showtop    = "N";

								//content를 mht로 바꾸기 위해서
								content = "<html><head><meta content=\"text/html; charset=utf-8\" http-equiv=\"Content-Type\"><style type=\"text/css\">P { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } DIV { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }TD { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } UL { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } OL { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } LI { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } BODY { MARGIN-RIGHT: 10px; FONT-SIZE:10PT; LINE-HEIGHT:1.3; FONT-FAMILY:Malgun Gothic } TABLE TD { text-indent: 0px } BLOCKQUOTE { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px;}</style></head><body><div>" + contentSplit(content)  + "</div></body></html>";
								content = contentToMHT(content, scheme, realPath, loginVO.getLocale());
								
								DtStart dtStart  = vEvent.getStartDate();
								DtEnd dtEnd      = vEvent.getEndDate();
								
								Date dtStartDate = dtStart.getDate();
								Date dtEndDate   = dtEnd.getDate();
								
								Calendar dtStartCal = Calendar.getInstance();
								Calendar dtEndCal   = Calendar.getInstance();
								Calendar tempEndCal = Calendar.getInstance();
								
								dtStartCal.setTime(dtStartDate);
								dtEndCal.setTime(dtEndDate);
								tempEndCal.setTime(dtEndDate);
								
								if (vEvent.getClassification() != null) {
									String clazz = vEvent.getClassification().getValue();
									
									switch (clazz) {
										case "PRIVATE" : ispublic = "N"; break;
										case "PUBLIC"  : ispublic = "Y"; break;
										default: ispublic = "N"; break;
									}
								}
								else { //기본공개설정상태
									ispublic = "Y";
								}
								
								List<RRule> rrules = vEvent.getProperties(Property.RRULE);
								if (rrules.size() == 0) { //반복일정이 없는 경우
									if (dtStart.getParameter("VALUE") != null) {
										if (dtStart.getParameter("VALUE").getValue().equals("DATE")) { //하루종일
											datetype = "2";
											
											//시작시간 00시  설정
											dtStartCal.set(Calendar.HOUR_OF_DAY, 0);
											
											//구글은 다음날로 나오므로 하루전 23시 59분으로 설정
											dtEndCal.add(Calendar.DATE, -1);
											dtEndCal.set(Calendar.HOUR_OF_DAY, 23);
											dtEndCal.set(Calendar.MINUTE, 59);
											
										}
									}
									else {
										datetype = "1";
									}
								}
								else { //반복설정이 있는 경우
									datetype = "3";
									
									String[] info = new String[7];
									if (rrules.size() > 1) { //한개의 이벤트에 만약 여러개 반복일정이 있다면
										continue;
									}
									else {
										RRule rrule = rrules.get(0);
										Recur recur = rrule.getRecur();
										
										//Setting info[0]
										if (recur.getUntil() == null) { //종료일없음
											if (recur.getCount() == -1) {
												info[0] = "-1";
											}
											else {
												info[0] = String.valueOf(recur.getCount());
											}
										}
										else { //종료일있음
											info[0] = "0";
											
											//시간정보는 가져와야함!
											dtEndDate = recur.getUntil();
											dtEndCal.setTime(dtEndDate);
											dtEndCal.set(Calendar.HOUR_OF_DAY, tempEndCal.get(Calendar.HOUR_OF_DAY));
											dtEndCal.set(Calendar.MINUTE, tempEndCal.get(Calendar.MINUTE));
											dtEndCal.set(Calendar.SECOND, 0);
										}
										
										//Setting info[1]
										if (dtStart.getParameters().toString().indexOf("VALUE=DATE") > -1) { //하루종일
											info[1] = "1";
											
											
											//시작시간 00시
											dtStartCal.set(Calendar.HOUR_OF_DAY, 0);
											
											//구글은 다음날로 나오므로 하루전 23시 59분으로 설정
											dtEndCal.add(Calendar.DATE, -1);
											dtEndCal.set(Calendar.HOUR_OF_DAY, 23);
											dtEndCal.set(Calendar.MINUTE, 59);
											
										}
										else { //시간지정
											info[1] = "0";
										}
										
										//Setting info[2]
										if (recur.getFrequency() != null) {
											switch (recur.getFrequency()) {
												case "DAILY":
													info[2] = "0";
													
													//Setting info[3]
													info[3] = recur.getInterval() == -1 ? "1" : String.valueOf(recur.getInterval());
													break;
												case "WEEKLY": 
													info[2] = "1";
													
													//Setting info[3]
													info[3] = recur.getInterval() == -1 ? "1" : String.valueOf(recur.getInterval());
													
													//Setting info[4]
													if (recur.getDayList() != null) {
														info[4] = "";
														for (WeekDay weekDay : recur.getDayList()) {
															info[4] += changeInfo(weekDay.getDay().toString());
														}
													}
													break;
												case "MONTHLY":
													info[2] = "2";
													
													if (recur.getDayList().size() == 0) {
														//Setting info[3]
														info[3] = "1";
														
														//Setting info[4]
														info[4] = recur.getInterval() == -1 ? "1" : String.valueOf(recur.getInterval());
														
														//Setting info[5]
														info[5] = String.valueOf(recur.getMonthDayList().get(0));
													}
													else {
														//Setting info[3]
														info[3] = "2";
														
														//Setting info[4]
														info[4] = recur.getInterval() == -1 ? "1" : String.valueOf(recur.getInterval());
														
														//Setting info[5] + Setting info[6]
														if (recur.getDayList().size() > 1) { //사이즈1이여야함
															continue;
														}
														else {
															WeekDay weedkDay = recur.getDayList().get(0);
															info[5] = weedkDay.toString().substring(0, 1);
															
															if (info[5].equals("-")) { //매월마지막인지체크
																info[5] = "5";
																info[6] = changeInfo(weedkDay.toString().substring(2));
															}
															else {
																info[6] = changeInfo(weedkDay.toString().substring(1));
															}
														}
													}
													break;
												case "YEARLY":
													info[2] = "3";
													
													//Setting info[4]
													if (recur.getInterval() == -1 || recur.getInterval() == 1) {
														info[4] = String.valueOf(dtStartCal.get(Calendar.MONTH) + 1);
													} 
													else { //반복주기가 1년보다 클 때
														continue;
													}
													
													if (recur.getSetPosList().size() == 0) {
														//Setting info[3]
														info[3] = "1";
														
														//Setting info[5]
														info[5] = String.valueOf(dtStartCal.get(Calendar.DATE));
													}
													else {
														//Setting info[3]
														info[3] = "2";
														
														//Setting info[5]
														if (recur.getSetPosList().size() > 1) { //사이즈1이여야함
															continue;
														}
														else {
															info[5] = recur.getSetPosList().get(0).toString();
														}
														
														//Setting info[6]
														if (recur.getDayList().size() > 1) { //사이즈1이여야함
															continue;
														}
														else {
															WeekDay weekday = recur.getDayList().get(0);
															info[6] = changeInfo(weekday.getDay().toString());
														}	
													}
													
													break;
												default: break;
											}
										}
									}
									
									ArrayList<String> list = new ArrayList<String>(Arrays.asList(info));
									repetition = list.stream().filter(StringUtils::isNotBlank).collect(Collectors.joining("|"));
								}
								
								sdate = sdf.format(dtStartCal.getTime());
								edate = sdf.format(dtEndCal.getTime());
								
								//scheduletype 개인일정, importance 중요도보통 설정
								ezScheduleService.insertSchedule(loginVO.getId(), loginVO.getDisplayName(), loginVO.getDisplayName2(), loginVO.getId(), loginVO.getDisplayName(), loginVO.getDisplayName2(), "1", "2", ispublic, datetype, sdate, edate, repetition, title, location, content, null, 
									null, null, null, null, null, defaultPath, loginVO.getTenantId(), loginVO.getCompanyID(), showtop, loginVO.getOffset(), loginVO.getLang());
								
								/*for(Object sch : c.getProperties()) {
									System.out.println(sch);
								}*/
								
								vEvent = null;
							} else{
								logger.error("Check ics file format.");
								reMsg = "ERROR_ICS";
							}
						}
					} catch(ParserException e) {
						reMsg = "ERROR";
						logger.debug("Parse Error");
						logger.error(e.getMessage(), e);
					} catch(Exception e) {
						reMsg = "ERROR";
						logger.debug("Error");
						logger.error(e.getMessage(), e);
					} finally {
						if (fin != null) { try { fin.close(); } catch (IOException e) {} }
					}
				} else {
					reMsg = "ERROR_ICAL_PART";
				}
			}
		} catch (MessagingException e) {
			reMsg = "ERROR";
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}

		logger.debug("icsImportFromEmail ended. reMsg={}", reMsg);
		return reMsg;
	}
	
	@RequestMapping(value = "/ezSchedule/scheduleDragSave.do", method = RequestMethod.POST)
	@ResponseBody
	public String scheduleDragSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO loginVO) throws Exception {
		logger.debug("scheduleDragSave started.");
		
		String returnValue = "0";
		
		loginVO = commonUtil.userInfo(loginCookie);
		String offset    = loginVO.getOffset();
		String companyId = loginVO.getCompanyID();
		int tenantId     = loginVO.getTenantId();
		String lang      = loginVO.getLang();
		
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		
		String offSetMin = commonUtil.getMinuteUTC(offset);
		String typeCal   = request.getParameter("typeCal");
		String dragId    = request.getParameter("dragId");
		String dragDay   = request.getParameter("dragDay");
		String dropDay   = request.getParameter("dropDay");
		String completeFG   = request.getParameter("completeFG");
		
		ScheduleInfoVO info  = ezScheduleService.getScheduleInfo(dragId, offSetMin, tenantId, companyId);
		String infoStartTime = info.getStartDate().substring(10, 16);
		String infoEndTime   = info.getEndDate().substring(10, 16);
		
		//Check Permission
		List<ScheduleSecretaryVO> tList = ezScheduleService.getPublicScheduleSec(loginVO.getId(), loginVO.getLang(), tenantId, companyId);
		
		if (getEditPosible(loginVO, info, tList).equals("N")) {
			logger.debug("Not Permission");
			returnValue = "1";
			return returnValue;
		}
		
		//Check PreviousDay 
		String usePreday = ezScheduleService.scheduleGetRegi(companyId, tenantId);
		Calendar cal     = Calendar.getInstance();
		String today     = sdf2.format(cal.getTime());
		String utcToday  = commonUtil.getDateStringInUTC(today, offset, true);

		String startDate;
		String endDate;
		String utcStartTime;
		String utcEndTime;
		
		//반복일정
		if (info.getDateType().equals("3")) {
			String defaultPath  = commonUtil.detectPathTraversal(commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_schedule.ROOT", tenantId));
			String delStartDate;
			
			if (typeCal.equals("0")) { 
				startDate    = dropDay + infoStartTime;
				delStartDate = dragDay.substring(4, 14) + infoStartTime;
				
				if (dragDay.contains("ALL")) {
					endDate = getDropEndDate(sdf1, dropDay, info) + infoEndTime;
				}
				else{
					endDate = dropDay + infoEndTime;
				}
			}
			else {
				if (dropDay.contains("ALL")) {
					startDate = dropDay.substring(0, 10) + infoStartTime;
					endDate   = getDropEndDate(sdf1, dropDay.substring(0, 10), info) + infoEndTime;
				}
				else {
					startDate = getDropStartEnd(sdf2, dropDay, info).get(0);
					endDate   = getDropStartEnd(sdf2, dropDay, info).get(1);
				}
				
				delStartDate = dragDay.substring(0, 10) + infoStartTime;
			}
			
			String utcDelTime   = commonUtil.getDateStringInUTC(delStartDate, offset, true);
			utcStartTime = commonUtil.getDateStringInUTC(startDate, offset, true);
			utcEndTime   = commonUtil.getDateStringInUTC(endDate, offset, true);
			
			if (usePreday.equals("2") && CompareDate(utcEndTime.substring(0, 10), utcToday.substring(0, 10))) { //둘다true이면 저장안함
				returnValue = "2";
				return returnValue;
			}
			else {
				//일정데이터 삭제 
				ezScheduleService.insertScheduleRepeDel(dragId, utcDelTime, tenantId, companyId);
					
				//일정데이터 복사
				ezScheduleService.copySchedule(dragId, utcStartTime, utcEndTime, defaultPath, offSetMin, tenantId, companyId, lang, offset, completeFG);
			}
		}
		else {
			if (typeCal.equals("0")) {
				startDate = dropDay + infoStartTime;
				endDate   = getDropEndDate(sdf1, dropDay.substring(0, 10), info) + infoEndTime;
			}
			else {
				if (dropDay.contains("ALL")) {
					startDate = dropDay.substring(0, 10) + infoStartTime;
					endDate   = getDropEndDate(sdf1, dropDay, info) + infoEndTime;
				}
				else {
					startDate = getDropStartEnd(sdf2, dropDay, info).get(0);
					endDate   = getDropStartEnd(sdf2, dropDay, info).get(1);
				}
			}
			
			utcStartTime = commonUtil.getDateStringInUTC(startDate, offset, true);
			utcEndTime = commonUtil.getDateStringInUTC(endDate, offset, true);
			
			if (usePreday.equals("2") && CompareDate(utcEndTime.substring(0, 10), utcToday.substring(0, 10))) { //둘다true이면 저장안함
				returnValue = "2";
				return returnValue;
			}
			else {
				//일정데이터 수정
				ezScheduleService.updateDragSchedule(dragId, loginVO.getId(), loginVO.getDisplayName1(), loginVO.getDisplayName2(), utcStartTime, utcEndTime, tenantId, companyId, info.getDateType(), info.getRepetition(), info.getTitle());
				ezScheduleService.sendInviteModNotiForDrag(request, dragId, info, startDate, endDate, loginVO, loginCookie);
			}
		}
		
		returnValue = utcEndTime.substring(0, 10);
		
		logger.debug("scheduleDragSave ended.");
		return returnValue;
	}
	
    /* 협업 - 그룹웨어 일정 데이터 연동 */
	@RequestMapping(value = "/ezSchedule/workspaceScheduleGetList.do", method = RequestMethod.POST, produces="application/json;charset=utf-8")
	@ResponseBody
	public List<ScheduleInfoVO> workspaceScheduleGetList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("workspaceScheduleGetList started.");
	
		String userId = request.getParameter("USERID");
		String keyword = request.getParameter("KEYWORD");
		String startDate = request.getParameter("STARTDATE");
		String endDate = request.getParameter("ENDDATE");
		
		String serverName = request.getServerName();
		int tenantId = loginService.getTenantId(serverName);
		
		LoginVO loginVO = new LoginVO();
		loginVO.setId(userId);
		loginVO.setTenantId(tenantId);
		loginVO.setDn("NOPASSWORD");
		loginVO = loginService.selectUser(loginVO);
		loginVO.setOffset(ezCommonService.selectUserGetTimeZone(userId, tenantId));
		
		String idList = "";
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
		
		String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());
		String utcStartTime = commonUtil.getDateStringInUTC(startDate, loginVO.getOffset(), true);
		String utcEndTime = commonUtil.getDateStringInUTC(endDate, loginVO.getOffset(), true);
		
		List<ScheduleSecretaryVO> tList = ezScheduleService.getPublicScheduleSec(loginVO.getId(), loginVO.getPrimary(), loginVO.getTenantId() ,loginVO.getCompanyID());
		List<ScheduleDeptVO> dList = ezScheduleService.getPublicScheduleDept(loginVO.getId(), loginVO.getPrimary(), loginVO.getTenantId() ,loginVO.getCompanyID());
		List<ScheduleCumulerVO> cList = ezScheduleService.getPublicScheduleCumuler(loginVO.getId(), loginVO.getPrimary(), loginVO.getTenantId() ,loginVO.getCompanyID());
		List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(loginVO.getId(), loginVO.getTenantId(), loginVO.getCompanyID());
		
		if (idList.equals("T") || idList.equals("")) {
			indiList = "'" + loginVO.getId() + "'";
			
			if(tList != null && tList.size()>0){
				for (int i = 0; i < tList.size(); i++) {
					if (i == 0) {
						indiListSub += ",";
					}			
					ScheduleSecretaryVO data = tList.get(i);			
					indiListSub += "\'" + data.getSecId()+ "\',";			
				}				
			}
			
			pidList = "'" + loginVO.getDeptID() + "'," + "'" + loginVO.getCompanyID() + "'";
			
			
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
			indiList = "'" + loginVO.getId() + "'";
			pidList = "";
		} else {
			pidList = idList;
		}
			
		List<ScheduleInfoVO> sList = ezScheduleService.getScheduleListForWorkspace(indiList, pidList, "", utcStartTime, utcEndTime, startDate, endDate, "", offSetMin, keyword.trim(), loginVO.getTenantId(), loginVO.getCompanyID(), loginVO.getId(), loginVO.getDeptID());
		
		Collections.sort(sList, new EzScheduleCompareUtilPublic());
		
		logger.debug("workspaceScheduleGetList ended.");
		return sList;
	}
	
	/**
	 * startDate 와 endDate 차이 구하는 함수
	 */
	private Integer getDateDiff(ScheduleInfoVO info) throws Exception {
		logger.debug("getDateDiff start");
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:SS");
		
		Calendar startCal = Calendar.getInstance();
		startCal.setTime(sdf.parse(info.getStartDate().substring(0, 19)));
		
		Calendar endCal = Calendar.getInstance();
		endCal.setTime(sdf.parse(info.getEndDate().substring(0, 19)));
		
		long diff = endCal.getTimeInMillis() - startCal.getTimeInMillis();
		long diffMinu = diff / (60 * 1000);
		
		logger.debug("diffMinu: " + diffMinu);
		logger.debug("getDateDiff ended");
		
		return (int) diffMinu;
	}
	/**
	 * 종일일정 dropDay 에서 endDate 구하는 함수
	 */
	private String getDropEndDate(SimpleDateFormat sdf, String dropDay, ScheduleInfoVO info) {
		logger.debug("getDropEndDate start");
		
		String endDate = "";
		
		try {
			Calendar dropCal = Calendar.getInstance();
			dropCal.setTime(sdf.parse(dropDay));
			dropCal.add(Calendar.MINUTE, getDateDiff(info));
			endDate = sdf.format(dropCal.getTime());
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("getDropEndDate ended");
		return endDate;
	}
	/**
	 * 시간일정 dropDay 에서 startDate 와  endDate 구하는 함수
	 */
	private ArrayList<String> getDropStartEnd (SimpleDateFormat sdf, String dropDay, ScheduleInfoVO info) {
		
		ArrayList<String> date = new ArrayList<String>();
		
		try {
			Calendar dropCal = Calendar.getInstance();
			dropCal.setTime(sdf.parse(dropDay));
		
			date.add(sdf.format(dropCal.getTime())); //startDate
			dropCal.add(Calendar.MINUTE, getDateDiff(info));
			date.add(sdf.format(dropCal.getTime())); //endDate
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}	
		
		return date;
	}
	/**
	 * 드래그앤드롭시 종료일과 오늘날짜 비교하는 함수
	 */
	private boolean CompareDate(String endDate, String today) {
		boolean returnValue = false;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		try {
			Calendar cal1 = Calendar.getInstance();
			cal1.setTime(sdf.parse(endDate));
			Calendar cal2 = Calendar.getInstance();
			cal2.setTime(sdf.parse(today));
			
			if (cal1.compareTo(cal2) == -1) { //종료일이 오늘날짜보다 큰경우 저장안함
				returnValue = true;
			}
			
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		}
		
		return returnValue;
	}
	/**
	 * 일정 수정권한 구하는 함수
	 */
	private String getEditPosible(LoginVO loginVO, ScheduleInfoVO info, List<ScheduleSecretaryVO> tList) throws Exception {
		//참석자관련권한부여
		String _editPosible = "Y";
		String userId = loginVO.getId();
		String rollInfo = loginVO.getRollInfo();
		String ownerId = info.getOwnerId();
		String scheduleType = info.getScheduleType();
		int tenantId = loginVO.getTenantId();
						
		if (!ownerId.equals(userId) && !info.getCreatorId().equals(userId) && !info.getModifierId().equals(userId)	 
			&& (!scheduleType.equals("2") || !ownerId.equals(loginVO.getDeptID()) || !commonUtil.isAdmin(userId, tenantId, rollInfo, "c;k;g"))
			&& (!scheduleType.equals("3") && !scheduleType.equals("2") || !commonUtil.isAdmin(userId, tenantId, rollInfo, "c;k;v")) 
			|| info.getIsReadOnly().equals("Y")
		) {
			_editPosible = "N";
		}
		for (ScheduleSecretaryVO ssvo : tList) {
			if (ssvo.getSecId().equals(info.getOwnerId())) {
				_editPosible = "Y";
			}
		}
		return _editPosible;
	}
	/**
	 * ics 파일에서 가져온 데이터의 문자열을 자르는 함수
	 */
	private String substringData(String data, int length) {
		logger.debug("substringData started.");
		
		if (data.length() > length) {
			data = data.substring(0, length);
		}
		
		logger.debug("substringData ended.");
		return data;
	}
	/**
	 * ics 파일에서 가져온 요일 정보를 info 로 변경하는 함수
	 */
	private String changeInfo(String weekday) {
		logger.debug("changeInfo started.");
		
		String result = "0";
		
		switch (weekday) {
			case "SU" : result = "0"; break;
			case "MO" : result = "1"; break;
			case "TU" : result = "2"; break;
			case "WE" : result = "3"; break;
			case "TH" : result = "4"; break;
			case "FR" : result = "5"; break;
			case "SA" : result = "6"; break;
			default : break;
		}
		
		logger.debug("changeInfo ended.");
		return result;
	}
	/**
	 * ics 파일에서 가져온 content \n 단위로 문자열 분리 후 p태그로 감싸는 함수
	 */
	private String contentSplit(String content) {
		logger.debug("contentSplit started.");
		
		String result = "";
		String[] splitContet = content.split("\\n");
		
		for (int i = 0; i < splitContet.length; i++) {
			result += "<p>" + splitContet[i] + "</p>";
		}
		
		logger.debug("contentSplit ended.");
		return result;
	}
	/**
	 * ics 파일에서 가져온 content 를  mht 로 바꾸는 함수
	 */
	private String contentToMHT(String strHTML, String scheme, String realPath, Locale locale) throws Exception{
		logger.debug("contentToMHT started.");
			
		if (strHTML != null) {
			strHTML = strHTML.replaceAll("%(?![0-9a-fA-F]{2})", "%25");
			strHTML = strHTML.replaceAll("\\+", "%2B");
			strHTML = URLDecoder.decode(strHTML, "utf-8");
		// 2023-05-17 이사라 : NullPointerException 시큐어코딩
		} else {
			strHTML = "";
		}
		
		strHTML = strHTML.replace("replace_" + scheme, scheme);
		
		strHTML = commonUtil.cleanScriptValue(strHTML);
		
		String mhtData = ezCommonService.startHtml2Mht(strHTML, realPath, locale);
		
		logger.debug("contentToMHT ended.");
		return mhtData;
	}
	/**
	 * 업로드 날짜를 30분 단위로 구하는 함수
	 */
    private String getUploadDate(String cDate, boolean isStart) throws Exception{
    	
    	logger.debug("============ getUploadDate started ============");
    	
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:SS");
		Date now = sdf.parse(cDate);
		
		Calendar cal = Calendar.getInstance();		
		cal.setTime(now);		
			
		if (isStart) {
			String date = cDate.substring(0,10);
			String hour = cDate.substring(11,13);
			String time = cDate.substring(14,16);
			
			if (Integer.parseInt(time) < 30) {
				cDate = date + " " + hour + ":00:00";
			} else {
				cDate = date + " " + hour + ":30:00";
			}
		} else {			
			cal.add(Calendar.MINUTE, 30);
			cDate = sdf.format(cal.getTime());

			String date = cDate.substring(0,10);
			String hour = cDate.substring(11,13);
			String time = cDate.substring(14,16);
			
			if (Integer.parseInt(time) < 30) {
				cDate = date + " " + hour + ":00:00";
			} else {
				cDate = date + " " + hour + ":30:00";
			}
		}		
		return cDate;
    }   
    
    @RequestMapping(value = "/ezSchedule/scheduleSyncConfig.do", method = RequestMethod.GET)
    public String scheduleGoogle(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
    	logger.debug("============ scheduleSyncConfig started ============");
		
    	LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
    	String isGoogleSync = googleService.getIsSync(loginVO);
		
    	model.addAttribute("isGoogleSync", isGoogleSync);
		
    	logger.debug("============ scheduleSyncConfig ended ============");
		return "/ezSchedule/scheduleSyncConfig";
    }
    
    @SuppressWarnings("unchecked")
	@RequestMapping(value="/ezSchedule/scheduleGetTokenInfo.do")
	@ResponseBody
	public JSONObject scheduleGetTokenInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginSimpleVO loginSimpleVO) throws Exception {
		logger.debug("============ scheduleGetTokenInfo started ============");
		JSONObject jsonObj = new JSONObject();
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		int tenantID = loginSimpleVO.getTenantId();
		String userID = loginSimpleVO.getId();
		String companyID = loginSimpleVO.getCompanyID();
		
		ScheduleTokenInfoVO tokenData = ezScheduleService.scheduleGetTokenInfo(userID, tenantID, companyID);
		jsonObj.put("data", tokenData);
		
		logger.debug("============ scheduleGetTokenInfo ended ============");
		return jsonObj;
	}
    
	@RequestMapping(value="/ezSchedule/scheduleSaveTokenInfo.do")
	@ResponseBody
	public void scheduleSaveTokenInfo(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		logger.debug("============ scheduleSaveTokenInfo started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		int tenantID = loginSimpleVO.getTenantId();
		String userID = loginSimpleVO.getId();
		String companyID = loginSimpleVO.getCompanyID();
		String todayUtcTime = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
		String googleAccessToken = request.getParameter("GOOGLEACCESSTOKEN").equals("")   ? null : request.getParameter("GOOGLEACCESSTOKEN");
		String googleRefreshToken = request.getParameter("GOOGLEREFRESHTOKEN").equals("") ? null : request.getParameter("GOOGLEREFRESHTOKEN");
		
		ezScheduleService.scheduleSaveTokenInfo(userID, googleAccessToken, googleRefreshToken, todayUtcTime, tenantID, companyID);
		
		logger.debug("============ scheduleSaveTokenInfo ended ============");
	}
	
    /**
	 * 구글 oAuth
	 */
	@RequestMapping(value="/ezSchedule/scheduleGoogleOauth.do")
	public RedirectView scheduleGoogleOauth(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("============ scheduleGoogleOauth started ============");
		logger.debug("============ scheduleGoogleOauth ended   ============");
		return new RedirectView(googleService.authorize());
	}
	
	/**
	 * 구글 oAuth Callback
	 * @throws IOException 
	 */
	@RequestMapping(value = "/ezSchedule/returnFromCallBack.do", method = RequestMethod.GET, params = "code")
	@ResponseBody
	public void oauth2Callback(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, @RequestParam(value = "code") String code, HttpServletResponse response) throws IOException {
		logger.debug("============ oauth2Callback started ============");
		
		userInfo = commonUtil.userInfo(loginCookie);
		JSONObject returnObj = googleService.getReturnMessage(code, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		PrintWriter writer  = response.getWriter();
		if (Integer.parseInt(returnObj.get("code").toString()) == 0) {
			writer.println("<html>");
			writer.println("<head>");
			writer.println("<script>window.onload=function(){ "
								+ "if(!window.opener) window.opener = window.open('','popupParent');"
								+ "window.opener.afterGoogleSuccess('"+ returnObj.get("googleAccessToken").toString() + "' , '" + returnObj.get("googleRefreshToken").toString() + "'); "
								+ "window.open('about:blank','_self').close();}"
						+ "</script>");
			writer.println("</head>");
			writer.println("<body>");
			writer.println("</body>");
			writer.println("</html>");
			
			logger.debug("accessToken: " + returnObj.get("googleAccessToken"));
			logger.debug("refreshToken: " + returnObj.get("googleRefreshToken"));
		}
		else {
			writer.println("<html>");
			writer.println("<head>");
			writer.println("<script>window.onload=function(){ "
								+ "if(!window.opener) window.opener = window.open('','popupParent');"
								+ "window.opener.afterGoogleFailure();"
								+ "window.open('about:blank','_self').close();}"
						+ "</script>");
			writer.println("</head>");
			writer.println("<body>");
			writer.println("</body>");
			writer.println("</html>");
		}
		
		logger.debug("============ oauth2Callback ended ==============");
	}
	
	@RequestMapping(value = "/ezSchedule/googleScheduleRead.do", method = RequestMethod.GET)
	public String googleScheduleRead(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, LoginVO userInfo, Locale locale) throws Exception {
		logger.debug("googleScheduleRead started");
		userInfo = commonUtil.userInfo(loginCookie);
		String s_date = request.getParameter("startdate");
		String e_date = request.getParameter("enddate");
		String googleid = request.getParameter("id");
		String repeatcount = request.getParameter("repeatcount");
		String companyID = userInfo.getCompanyID();
		String dateString = "";
		String _date = s_date.substring(0,10);
		String googleContent = "";
		
		String readFlag = "";
        if (request.getParameter("readFlag") != null) {
        	readFlag = request.getParameter("readFlag");
        }
		
		String memberId = "";
        if (request.getParameter("memberId") != null) {
        	memberId = commonUtil.stripScriptTagsAndFunctions(request.getParameter("memberId"));
        }
        String memberName = "";
        if (request.getParameter("memberName") != null) {
        	memberName = request.getParameter("memberName");
        }
		
		Event event = googleService.getGoogleScheduleInfo(googleid, userInfo, readFlag, memberId);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		ScheduleInfoVO svo = new ScheduleInfoVO();
		if (event != null) {
			svo.setScheduleId(event.getId());
    		svo.setOwnerId(readFlag.equals("member") ? memberId : userInfo.getId());
    		svo.setCreatorId(readFlag.equals("member") ? memberId : userInfo.getId());
    		svo.setModifierId(readFlag.equals("member") ? memberId : userInfo.getId());
    		if (readFlag.equals("member")) {
				svo.setOwnerName(memberName);
				svo.setCreatorName(memberName);
				svo.setModifierName(memberName);
				svo.setOwnerName2(memberName);
				svo.setCreatorName2(memberName);
				svo.setModifierName2(memberName);
			} else {
				svo.setOwnerName(userInfo.getDisplayName());
				svo.setCreatorName(userInfo.getDisplayName());
				svo.setModifierName(userInfo.getDisplayName());
				svo.setOwnerName2(userInfo.getDisplayName2());
				svo.setCreatorName2(userInfo.getDisplayName2());
				svo.setModifierName2(userInfo.getDisplayName2());
			}
    		svo.setScheduleType("9");
    		svo.setScheduleFlag("google");
    		svo.setCompanyid(companyID);
    		svo.setTitle(event.getSummary() != null ? event.getSummary() : "No Title");
    		svo.setImportance("2");
    		svo.setLocation(event.getLocation());
    		
    		svo.setCreateDate(sdf.format(event.getCreated().getValue()));
    		svo.setModifyDate(sdf.format(event.getUpdated().getValue()));

    		svo.setIsPublic(event.getVisibility() != null && (event.getVisibility().equals("private") || event.getVisibility().equals("confidential")) ? "N" : "Y");
    		
    		boolean isAllday = (event.getStart().getDateTime() == null) ? true : false;
    		// 반복일정인 경우
    		if (event.getRecurrence() != null){
    			svo.setDateType("3");
    			com.google.api.client.util.DateTime googleStartDate = isAllday ? event.getStart().getDate() : event.getStart().getDateTime();
    			com.google.api.client.util.DateTime googleEndDate = isAllday ? event.getEnd().getDate() : event.getEnd().getDateTime();
    			long repeatedScheduleOffset = googleEndDate.getValue() - googleStartDate.getValue();
    			// 반복일정 중 일정이 하루 이상인 경우
    			dateString = msg.getMessage("ezSchedule.t343", locale) + " (" + repeatcount + msg.getMessage("ezSchedule.t329", locale) + " ";
    			if (repeatedScheduleOffset != 0 && repeatedScheduleOffset > 86400000) {
    				if (isAllday) {
        				svo.setDateType("2");
        				dateString += _date + " (" + msg.getMessage("ezSchedule.t280", locale) + " ~ " + e_date.substring(0,10) + " (" + msg.getMessage("ezSchedule.t280", locale);
        			}
        			else {
        				svo.setDateType("1");
        				dateString += s_date.substring(0,10) + " " + s_date.substring(11,16) + " ~ " + e_date.substring(0,10) + " " + e_date.substring(11,16);
        			}
    			} else {
    				if (isAllday) {
	    				dateString +=  _date + " (" + msg.getMessage("ezSchedule.t280", locale);
	        		}
	        		else {
	        			dateString += _date + " " + s_date.substring(11, 16) + " ~ " + e_date.substring(11, 16);
	        		}
    			}
    		} else {
    			if (isAllday) {
    				svo.setDateType("2");
    				dateString = _date + " (" + msg.getMessage("ezSchedule.t280", locale) + " ~ " + e_date.substring(0,10) + " (" + msg.getMessage("ezSchedule.t280", locale);
    			}
    			else {
    				svo.setDateType("1");
    				dateString = s_date.substring(0,10) + " " + s_date.substring(11,16) + " ~ " + e_date.substring(0,10) + " " + e_date.substring(11,16);
    			}
    		}
    		
    		googleContent = event.getDescription() != null ? event.getDescription() : "";
    		svo.setContent(googleContent);
		} else {
			logger.error("Schedule not found.");
			model.addAttribute("title", egovMessageSource.getMessage("ezSchedule.t342", locale));
			model.addAttribute("mainContent", egovMessageSource.getMessage("ezSchedule.gha03", locale));
			model.addAttribute("subContent", egovMessageSource.getMessage("ezSchedule.gha04", locale));
			return "ezCommon/error";
		}
		
		String _admin = "N";
	    String _editPosible = "N";
        
    	model.addAttribute("_admin", _admin);
        model.addAttribute("_editPosible", _editPosible);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("scheduleInfo", svo);
		model.addAttribute("_date", _date);
		model.addAttribute("dateString", dateString);
		model.addAttribute("primary", userInfo.getPrimary());
        model.addAttribute("lang", userInfo.getLang());
        model.addAttribute("scheduleBody", googleContent);
        model.addAttribute("companyID", companyID);
		
		logger.debug("googleScheduleRead ended");
		return "ezSchedule/scheduleRead";
	}
	
    private String isGoogleSync(LoginVO userInfo) throws Exception {
	    return googleService.getIsSync(userInfo); 
	}
    
    /* 2023-08-31 조소정 - 일정관리 > 그룹 추가 또는 그룹 관리 시 그룹색상선택표 표출 */
	@RequestMapping(value = "/ezSchedule/scheduleSelectGroupColor.do", method = RequestMethod.GET)
	public String selectGroupColor(HttpServletRequest request, Model model) throws Exception {
		logger.debug("============ selectGroupColor started ============");
		
		String groupColor = request.getParameter("groupColor");
		
		model.addAttribute("groupColor", groupColor);
		
		logger.debug("selectGroupColor ended");
		return "/ezSchedule/scheduleSelectGroupColor";
	}
	
	/**
	 * 2018-10-11 홍승비 - 모두저장(압축파일 내려받기)
	 */
	@RequestMapping(value="/ezSchedule/downloadAttachAll.do", method = RequestMethod.POST, produces="text/plain; charset=UTF-8")
	@ResponseBody
	public void downloadAttachAll(@CookieValue("loginCookie") String loginCookie, Locale locale, 
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadAttachAll started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String filePath = request.getParameter("filePath");
		String fileNames = request.getParameter("fileNames");
		String fileNamesUID = request.getParameter("fileNamesUID");
		String realPath = commonUtil.getRealPath(request);
		String uploadFilePath = commonUtil.getUploadPath("upload_schedule.ROOT", userInfo.getTenantId());
		String tempFileUploadPath = realPath + uploadFilePath + commonUtil.separator + "tempUploadFile";
		String guid = UUID.randomUUID().toString();
		String pDirTempPath = tempFileUploadPath + commonUtil.separator + guid;
		String fullFilePath = realPath + uploadFilePath + filePath;
		// int bufferSize = 4096;

		//logger.debug("fullFilePath : " + fullFilePath);
		//logger.debug("fileNames : " + fileNames);
		
		ZipOutputStream zos = null;
		String downFileName = "";
		
		try {
			EzFAL.EzFile tempFile = new EzFAL.EzFile(pDirTempPath + commonUtil.separator + ".zip");
			
			if (tempFile.exists()) {
				tempFile.delete();
			}
			
			tempFile = new EzFAL.EzFile(tempFileUploadPath);
			
			if (!tempFile.exists()) {
				tempFile.mkdirs();
			}
			
			zos = new ZipOutputStream(new EzFAL.EzFileOutputStream(pDirTempPath + ".zip"), Charset.forName("utf-8"));
			
			String[] fileNamesArr = fileNames.split(":");
			String[] fileNamesUIDArr = fileNamesUID.split(":");
			
			downFileName = fileNamesArr[0] + " " + egovMessageSource.getMessage("ezCircular.t50", userInfo.getLocale()) + " " + (fileNamesArr.length-1) + egovMessageSource.getMessage("ezStatistics.t1067", userInfo.getLocale()) + ".zip";//zip파일명
			
			/* 2019-04-02 홍승비 - 중복된 파일명을 덮어쓰지 않고 (1), (2)... 붙이도록 수정 */
			Map<String, Integer> fileNameMap = new HashMap<String, Integer>();
			
			if (fileNamesArr.length != 0) {// 파일이 있으면
				for (int i = 0; i < fileNamesArr.length; i++) { // 파일 갯수만큼
					BufferedInputStream bis = null;
					
					try {
						EzFAL.EzFile sourceFile = new EzFAL.EzFile(commonUtil.detectPathTraversal(fullFilePath + fileNamesUIDArr[i]));
						byte[] fileBytes = commonUtil.readBytesFromFile(sourceFile.toPath());
						
						if (fileNamesUIDArr[i].endsWith("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
							fileBytes = klibUtil.decrypt(fileBytes);
						}
						
						fileNamesArr[i] = commonUtil.getUniqueFileName(fileNamesArr[i], fileNameMap);
						ZipEntry zentry = new ZipEntry(fileNamesArr[i]);
						zos.putNextEntry(zentry);
						zos.write(fileBytes);
						zos.closeEntry();
					} catch (IOException e) {
						logger.error(e.getMessage(), e);
					} finally {
						if (bis != null) {
							try {
								bis.close();
							} catch (Exception e) {
								logger.error(e.getMessage(), e);
							}
						}
					}
				}
				zos.flush();
				zos.close();
				zos = null;
	
				EzFAL.EzFile file = new EzFAL.EzFile(pDirTempPath + ".zip");
				
				if (file.exists()) {
					downFile(request, response, pDirTempPath + ".zip", downFileName);
					file.delete();
				}
			}
		} catch (Exception e) {
			EzFAL.EzFile file = new EzFAL.EzFile(pDirTempPath + ".zip");
			
			if (file.exists()) {
				file.delete();
			}
		} finally {
			if (zos != null) {
				try {
					zos.close();
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
		}
		logger.debug("downloadAttachAll ended.");
	}

	/* 2024-05-21 김유진 - 일정 > 게시판 게시 > 일정 정보 가져오기 */
	@RequestMapping(value="/ezSchedule/ezScheduleReadBoard.do", method=RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String ezScheduleReadBoard(@CookieValue("loginCookie") String loginCookie, Locale locale, @RequestBody String bodyData, HttpServletRequest request, Model model, LoginVO loginVO) throws Exception{
		logger.debug("ezScheduleReadBoard started.");

		loginVO = commonUtil.userInfo(loginCookie);
		String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());
		int tenantId = loginVO.getTenantId();
		String companyId = loginVO.getCompanyID();
		String lang = loginVO.getLang();

		Document xmldom = commonUtil.convertStringToDocument(bodyData);
		String url = xmldom.getElementsByTagName("URL").item(0).getTextContent();
		String attachLimit = xmldom.getElementsByTagName("ATTACHLIMIT").item(0).getTextContent();
		String scheduleId = xmldom.getElementsByTagName("SCHEDULEID").item(0).getTextContent();
		logger.debug("url=" + url + ",attachLimit=" + attachLimit + ", scheduleId: " + scheduleId);

		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");

		// 일정 상세정보 가져오기
		ScheduleInfoVO vo = ezScheduleService.getScheduleInfo(scheduleId, offSetMin, tenantId, companyId);
		if (vo == null) {
			logger.error("Schedule not found.");
			model.addAttribute("title", egovMessageSource.getMessage("ezSchedule.t342", locale));
			model.addAttribute("mainContent", egovMessageSource.getMessage("ezSchedule.gha03", locale));
			model.addAttribute("subContent", egovMessageSource.getMessage("ezSchedule.gha04", locale));
			return "ezCommon/error";
		}

		sb.append("<SUBJECT><![CDATA[" + vo.getTitle() + "]]></SUBJECT>");
		if (lang != null && "1".equals(lang)){
			sb.append("<FROMNAME>" + vo.getOwnerName() + "</FROMNAME>");
		} else {
			sb.append("<FROMNAME>" + vo.getOwnerName2() + "</FROMNAME>");
		}
		sb.append("<DATE><![CDATA[" + vo.getCreateDate() + "]]></DATE>");

		String realPath = commonUtil.getRealPath(request);
		String path = commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", tenantId);
		String scheme = "http://";
		if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
			scheme = "https://";
		}
		// 일정 본문 데이터 가져오기
		String htmlBody = ezCommonService.getMHTtoHTML("SCHEDULECONTENT", url, tenantId, realPath, request, locale, scheme);
		htmlBody = htmlBody.replaceAll("(?is)<style[^>]*?>.*?</style>", "");
		String escapedHtml = StringEscapeUtils.escapeHtml4(htmlBody);
		sb.append("<HTMLDESCRIPTION>" + escapedHtml + "</HTMLDESCRIPTION>");

		List<AttachListVO> aList = new ArrayList<>();
		// 일정 참부파일 정보 가져오기
		String aListStr = "";
		if (vo.getHasAttach().equals("Y")) {
			String parentID = (vo.getParentId().equals("0") ? scheduleId : vo.getParentId());
			aList = ezScheduleService.getAttachList(parentID, tenantId);
			for (AttachListVO avo : aList) {
				aListStr += "<ROW><ATTACHID>" + avo.getAttachId() + "</ATTACHID><FILESIZE>" + avo.getFileSize() + "</FILESIZE><FILENAME>" + avo.getFileName() + "</FILENAME><FILEPATH>" + avo.getFilePath()+ "</FILEPATH></ROW>";
			}
		}
		sb.append("<ATTACHINFO>" + aListStr + "</ATTACHINFO>");

		sb.append("</DATA>");
		logger.debug("ezScheduleReadBoard ended.");
		return sb.toString();
	}

	/**
	 * 2023-10-11 기민혁 - 일정관리 > 사용자일정검색
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezSchedule/scheduleUserCalendarSearch.do", method = RequestMethod.GET)
	public String  scheduleUserCalendarSearch(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, Locale locale, LoginVO loginVO) throws Exception {

		logger.debug("============ scheduleUserCalendarSearch started ============");

		int	timeZone = 0;
		String deptAdmin = "N";
		String companyAdmin = "N";
		String pOffset = "";
		String idList = "";
		String idType = "T";
		//사용자 일정 검색 타이틀 고정
		String defaultTitle = msg.getMessage("ezSchedule.kmh02", locale);
		loginVO = commonUtil.userInfo(loginCookie);
		String lang = loginVO.getPrimary();
		int tenantID = loginVO.getTenantId();
		String useEditor = ezCommonService.getTenantConfig("EDITOR", loginVO.getTenantId());
		String otherId = request.getParameter("otherid");

		String groupId = request.getParameter("groupid");
		if (groupId == null) {
			groupId = "";
		}

		String SearchUserId = request.getParameter("SearchUserId");
		if (SearchUserId == null) {
			SearchUserId = "";
		}

		String SearchDeptName = request.getParameter("SearchDeptName");
		if (SearchDeptName == null) {
			SearchDeptName = "";
		}

		String SearchDeptId = request.getParameter("SearchDeptId");
		if (SearchDeptId == null) {
			SearchDeptId = "";
		}

		String SearchName = request.getParameter("SearchName");
		if (SearchName == null) {
			SearchName = "";
		}
		String SearchCompanyId = request.getParameter("SearchCompanyId");
		if (SearchCompanyId == null) {
			SearchCompanyId = "";
		}

		// 일정관리 환경설정 정보
		ScheduleConfigVO scheduleConfigVO = ezScheduleService.getScheduleConfig(loginVO.getId(), loginVO.getTenantId());

		int	defaultView = 0;
		int	startDay = 0;
		int	startTime = 0;
		int	endTime = 0;

		if (scheduleConfigVO != null) {
			defaultView	= scheduleConfigVO.getDefaultView();
			startDay	= scheduleConfigVO.getStartDay();
			startTime	= scheduleConfigVO.getStartTime() / 60;
			endTime		= scheduleConfigVO.getEndTime() / 60;
		} else {
			defaultView	= 2;
			startDay	= 7;
			startTime	= 540 / 60;
			endTime		= 1020 / 60;
		}

		List<ScheduleGroupListVO> groupList = ezScheduleService.getScheduleGroupList(SearchUserId, loginVO.getTenantId() ,SearchCompanyId);

		for (int i = 0; i < groupList.size(); i++) {
			ScheduleGroupListVO data = groupList.get(i);

			if(data.getGroupColor() == null) {
				data.setGroupColor("#e9de13");
			}
		}
		
	    // 2025-04-21 조수빈 - 기본 일정 요소별 사용자 설정값
	    List<ScheduleTypeConfigVO> personalScheConfigList = ezScheduleService.getUserScheduleTypeConfig(loginVO.getId(), loginVO.getCompanyID(), tenantID);
	    ObjectMapper objectMapper = new ObjectMapper();
	    String jsonPersonalScheConfigList = "";
	    
	    try {
			jsonPersonalScheConfigList = objectMapper.writeValueAsString(personalScheConfigList);
		} catch (Exception e) {
			logger.debug(e.getMessage());
		}

		model.addAttribute("userInfo",		loginVO);
		model.addAttribute("pOffset",		pOffset);
		model.addAttribute("timeZoneStr",	timeZone);
		model.addAttribute("idType",		idType);
		model.addAttribute("otherId",		otherId);
		model.addAttribute("startTime",		startTime);
		model.addAttribute("endTime",		endTime);
		model.addAttribute("defaultView",	defaultView);
		model.addAttribute("startDay",		startDay);
		model.addAttribute("useEditor",		useEditor);
		model.addAttribute("defaultTitle",	defaultTitle);
		model.addAttribute("SearchName", SearchName);
		model.addAttribute("resultUserID", SearchUserId);
		model.addAttribute("resultCompanyID", SearchCompanyId);
		model.addAttribute("resultDeptName", SearchDeptName);
		model.addAttribute("resultDeptID", SearchDeptId);
		model.addAttribute("groupList", groupList);
		model.addAttribute("jsonPersonalScheConfigList", jsonPersonalScheConfigList);

		return "/ezSchedule/scheduleUserCalendarSearch";
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

		List<ScheduleInfoVO> sList = ezScheduleService.getUserSearchScheduleList(indiList, pidList, "", utcStartTime, utcEndTime, startDate, endDate, "", offSetMin, "",userInfo.getTenantId(), companyID, userInfo.getId(), userInfo.getDeptID(), useAnnualScheduleYN);

		/* 2021-11-26 홍승비 - 일정 리스트 데이터를 전달받아 일정완료 데이터를 추가 가공하여 리턴 */
		sList = ezScheduleService.applyScheduleCompleteData(sList, userInfo.getOffset(), userInfo.getTenantId(), companyID);

		Collections.sort(sList, new EzScheduleCompareUtil());

		return sList;
	}

	@RequestMapping(value = "/ezSchedule/schedulePrintMode.do", method = RequestMethod.GET)
	public String schedulePrintMode(HttpServletRequest request, Model model) throws Exception{
		logger.debug("schedulePrintMode started");


		logger.debug("schedulePrintMode ended");

		return "/ezSchedule/schedulePrintMode";
	}

	/**
	 * 일정관리 메인화면 호출함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezSchedule/schedulePrintCalendar.do", method = RequestMethod.GET)
	public String  schedulePrintCalendar(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, Locale locale, LoginVO loginVO,
										 String typeCal, String startDate, String endDate) throws Exception {

		logger.debug("============ schedulePrintCalendar started ============");

		int	timeZone = 0;
		String deptAdmin = "";
		String companyAdmin = "";
		String pOffset = "";
		String defaultTitle = "";

		loginVO = commonUtil.userInfo(loginCookie);

		String useEditor = ezCommonService.getTenantConfig("EDITOR", loginVO.getTenantId());
		String groupId = request.getParameter("groupid");

		if (groupId == null) {
			groupId = "";
		}

		String userID = loginVO.getId();
		String lang = loginVO.getPrimary();
		int tenantID = loginVO.getTenantId();
		String companyID = loginVO.getCompanyID();

		List<ScheduleSecretaryVO> pubScheSecVO = ezScheduleService.getPublicScheduleSec(userID, lang, tenantID ,companyID);
		List<ScheduleDeptVO> pubScheDeptVO = ezScheduleService.getPublicScheduleDept(userID, lang, tenantID ,companyID);
		List<ScheduleDeptVO> pubScheDeptVO2 = new ArrayList<ScheduleDeptVO>();
		List<ScheduleCumulerVO> pubScheCumulerVO = ezScheduleService.getPublicScheduleCumuler(userID, lang, tenantID, companyID);

		dept_schedule:
		for (ScheduleDeptVO vo : pubScheDeptVO) {
			for (ScheduleCumulerVO vo2 : pubScheCumulerVO) {
				if (vo.getDeptId().equals(vo2.getDeptId())){
					continue dept_schedule;
				}
			}
			pubScheDeptVO2.add(vo);
		}

		StringBuilder sb = new StringBuilder();

		for (int i = 0; i < pubScheSecVO.size(); i++) {
			ScheduleSecretaryVO vo = pubScheSecVO.get(i);
			sb.append("<option value='" + vo.getSecId() + "' type='user'>" + vo.getSecName() + "</option>");
		}

		for (int i = 0; i < pubScheDeptVO2.size(); i++) {
			ScheduleDeptVO vo = pubScheDeptVO2.get(i);
			sb.append("<option value='" + vo.getDeptId() + "' type='dept'>[" + msg.getMessage("ezSchedule.t205", locale) + "]" + vo.getDeptName() + "</option>");
		}

		for (int i = 0; i < pubScheCumulerVO.size(); i++) {
			ScheduleCumulerVO vo = pubScheCumulerVO.get(i);
			sb.append("<option value='" + vo.getDeptId() + "' type='dept'>[" + msg.getMessage("ezSchedule.t996", locale) + "]" + vo.getTitleName() + "</option>");
		}

		if (commonUtil.isAdmin(loginVO.getId(), loginVO.getTenantId(), loginVO.getRollInfo(), "c;k")) {
			companyAdmin = "Y";
			deptAdmin = "Y";
		} else if (commonUtil.isAdmin(loginVO.getId(), loginVO.getTenantId(), loginVO.getRollInfo(), "g")) {
			deptAdmin = "Y";
		} else if (commonUtil.isAdmin(loginVO.getId(), loginVO.getTenantId(), loginVO.getRollInfo(), "g")) {
			companyAdmin = "Y";
		}

		int receiveCount = ezScheduleService.getReceiveCount(loginVO.getId(), loginVO.getTenantId() ,loginVO.getCompanyID());
		int groupCount = ezScheduleService.getInviteScheduleGroupCnt(loginVO.getId(), loginVO.getTenantId() ,loginVO.getCompanyID());
		// 일정관리 환경설정 정보
		ScheduleConfigVO scheduleConfigVO = ezScheduleService.getScheduleConfig(loginVO.getId(), loginVO.getTenantId());

		int	defaultView = 0;
		int	startDay = 0;
		int	startTime = 0;
		int	endTime = 0;

		if (scheduleConfigVO != null) {
			defaultView	= scheduleConfigVO.getDefaultView();
			startDay	= scheduleConfigVO.getStartDay();
			startTime	= scheduleConfigVO.getStartTime() / 60;
			endTime		= scheduleConfigVO.getEndTime() / 60;
			/* 2018-02-01 김보미 - 일정관리 타이틀 고정 */
			defaultTitle = msg.getMessage("ezSchedule.t261", locale);

		} else {
			/* 2018-02-01 김보미 - 일정관리 타이틀 고정 */
//        	defaultTitle = msg.getMessage("ezSchedule.t142", locale);
			defaultTitle = msg.getMessage("ezSchedule.t261", locale);

			defaultView	= 2;
			startDay	= 7;
			startTime	= 540 / 60;
			endTime		= 1080 / 60;
		}
		// 일정 그룹 목록
		List<ScheduleGroupListVO> groupList = ezScheduleService.getScheduleGroupList(loginVO.getId(), loginVO.getTenantId() ,companyID);

		StringBuilder sbGroup = new StringBuilder("<DATA>");

		for (int k=0; k < groupList.size(); k++) {
			ScheduleGroupListVO vo = groupList.get(k);
			sbGroup.append(commonUtil.getQueryResult(vo));
		}
		sbGroup.append("</DATA>");

		String groupXml = sbGroup.toString();
		String groupXmlTemp = groupXml.replace("\"", "&quot;");
		String otherId = request.getParameter("otherid");
		String idList = "";
		String idType = "T";
		String idTypeTmp = request.getParameter("idtype");

		if (idTypeTmp != null) {
			idTypeTmp = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(idTypeTmp));
		}

		//2018-06-07 구해안checkbox 값을 가져와서 char[]에 담기
		String idTypeChk = request.getParameter("idTypeChk");
		@SuppressWarnings("unused")
		char[] chk_array = null;
		if(idTypeChk != null && !idTypeChk.equals("")){

			chk_array = new char[idTypeChk.length()];
		}

		if (otherId != null && !otherId.equals("")) {
			idList = otherId;

			if (idTypeTmp != null && !idTypeTmp.equals("")) {
				idType = idTypeTmp;
			}

		} else if (idTypeTmp != null && !idTypeTmp.equals("")) {
			idType = idTypeTmp;
			//2018-06-07 구해안 id값을 통째로 넘기기 때문에 다른 경우는 삭제하고 처음 시작할때 전체일정 뿌리도록 T만 남김	
			switch (idType) {
				case "T":
					idList = "T";
					break;
				default:
					idList = idType;
					break;
			}
			//2018-06-07 구해안  check 값 가져오기
		} else if (idTypeChk != null && !idTypeChk.equals("")){
			idList = idTypeChk;
		}

		List<String> publicIds = pubScheDeptVO2.stream().map(s -> s.getDeptId()).collect(Collectors.toList());
		JSONArray jsonArray = new JSONArray();
		for (int j = 0; j < publicIds.size(); j++) {
			JSONObject obj = new JSONObject();
			obj.put("id", publicIds.get(j));
			jsonArray.add(j, obj);
		}
		pOffset = loginVO.getOffset().split("\\|")[1];
		timeZone = (Integer.parseInt(pOffset.split(":")[0]) * 60) + Integer.parseInt(pOffset.split(":")[1]);

		//2018-10-29 김혜정
		String useScheduleIcs = ezCommonService.getTenantConfig("useScheduleIcs", loginVO.getTenantId());
		//2020-02-24 김정언
		String useAnnualScheduleYN = ezCommonService.getTenantConfig("useAnnualScheduleYN", loginVO.getTenantId());

		String workspaceHostUrl = ezCommonService.getTenantConfig("workspaceHostUrl", loginVO.getTenantId());
		
		/* 2025-03-13 홍승비 - 협업 모듈에 고정된 하드코딩 문자열 제거 (ezWorkspace), 테넌트 컨피그 workspaceAppPath로 협업 웹응용프로그램 경로를 분리하여 사용 ("" 또는 "/ezWork" 등) */
		String workspaceAppPath = ezCommonService.getTenantConfig("workspaceAppPath", loginVO.getTenantId());
		
	    // 2025-04-21 조수빈 - 기본 일정 요소별 사용자 설정값
	    List<ScheduleTypeConfigVO> personalScheConfigList = ezScheduleService.getUserScheduleTypeConfig(userID, companyID, tenantID);
	    ObjectMapper objectMapper = new ObjectMapper();
	    String jsonPersonalScheConfigList = "";
	    
	    try {
			jsonPersonalScheConfigList = objectMapper.writeValueAsString(personalScheConfigList);
		} catch (Exception e) {
			logger.debug(e.getMessage());
		}

		model.addAttribute("userInfo",		loginVO);
		model.addAttribute("pOffset",		pOffset);
		model.addAttribute("timeZoneStr",	timeZone);
		model.addAttribute("receiveCount",	receiveCount);
		model.addAttribute("groupCount",	groupCount);
		model.addAttribute("deptAdmin",		deptAdmin);
		model.addAttribute("companyAdmin",	companyAdmin);
		model.addAttribute("idType",		idType);
		model.addAttribute("otherId",		otherId);
		model.addAttribute("groupId",		groupId);
		model.addAttribute("groupXmlTemp",	groupXmlTemp);
		model.addAttribute("idList",		idList);
		model.addAttribute("startTime",		startTime);
		model.addAttribute("endTime",		endTime);
		model.addAttribute("defaultView",	defaultView);
		model.addAttribute("startDay",		startDay);
		model.addAttribute("useEditor",		useEditor);
		model.addAttribute("defaultTitle",	defaultTitle);
		model.addAttribute("shareList",		sb.toString());
		model.addAttribute("useScheduleIcs",useScheduleIcs);
		model.addAttribute("publicIds",jsonArray);
		model.addAttribute("useAnnualScheduleYN", useAnnualScheduleYN);
		model.addAttribute("workspaceHostUrl", workspaceHostUrl);
		model.addAttribute("workspaceAppPath", workspaceAppPath);

		model.addAttribute("typeCal",		typeCal);
		//model.addAttribute("sDate",		sDate);
		model.addAttribute("pStartDate",	startDate);
		model.addAttribute("pEndDate",		endDate);
		model.addAttribute("jsonPersonalScheConfigList", jsonPersonalScheConfigList);

		return "/ezSchedule/schedulePrintCalendar";
	}

	/**
	 * 2023-09-27 임정은 - 일정 모아보기 메인화면
	 */
	@RequestMapping(value="/ezSchedule/scheduleGatherMain.do", method = RequestMethod.GET)
	public String scheduleGatherMain(@CookieValue("loginCookie") String loginCookie, Model model, LoginSimpleVO loginSimpleVO) throws Exception {
		logger.debug("============ scheduleGatherMain started ============");

		return "/ezSchedule/scheduleGatherMain";
	}

	/**
	 * 2023-09-27 임정은 - 모아보기 그룹 관리 그리드 리스트
	 */
	@RequestMapping(value="/ezSchedule/scheduleGatherList.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleGatherList(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO) throws Exception {
		logger.debug("============ scheduleGatherList started ============");

		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		List<ScheduleGroupListVO> myList = ezScheduleService.getMyGatherList(loginSimpleVO.getId(), loginSimpleVO.getTenantId(),loginSimpleVO.getCompanyID());

		StringBuilder result = new StringBuilder("<LISTVIEWDATA>");
		result.append("<HEADERS><HEADER><NAME>CHECK</NAME><WIDTH>10%</WIDTH></HEADER>");
		result.append("<HEADER><NAME>" + msg.getMessage("ezSchedule.t159", loginSimpleVO.getLocale()) + "</NAME><WIDTH>60%</WIDTH></HEADER>");
		result.append("<HEADER><NAME>" + msg.getMessage("ezSchedule.t00002", loginSimpleVO.getLocale()) + "</NAME><WIDTH>40%</WIDTH></HEADER></HEADERS>");
		result.append("<ROWS>");

		for (int i = 0; i < myList.size(); i++) {
			ScheduleGroupListVO data = myList.get(i);

			result.append("<ROW>");
			result.append("<CELL>");
			result.append("<VALUE>CHECK</VALUE>");
			result.append("<DATA1>" + data.getGroupId() + "</DATA1>");
			result.append("<DATA2><![CDATA[" + data.getDescription() + "]]></DATA2>");
			result.append("</CELL>");
			result.append("<CELL>");

			int myMemberListCnt = ezScheduleService.getMyGatherMemberCnt(data.getGroupId(), loginSimpleVO.getLang(), loginSimpleVO.getTenantId(), loginSimpleVO.getCompanyID());
			String cDate = commonUtil.getDateStringInUTC(data.getCreateDate(),loginSimpleVO.getOffset(),false).substring(0,10);

			if (myMemberListCnt > 1) {
				result.append("<VALUE><![CDATA[" + data.getGroupName() + " (" + myMemberListCnt + msg.getMessage("ezSchedule.hik01", loginSimpleVO.getLocale()) + ")" + "]]></VALUE>");
			} else {
				result.append("<VALUE><![CDATA[" + data.getGroupName() + " (" + myMemberListCnt + msg.getMessage("ezSchedule.t00003", loginSimpleVO.getLocale()) + ")" + "]]></VALUE>");
			}

			result.append("</CELL>");
			result.append("<CELL>");
			result.append("<VALUE>" + cDate + "</VALUE>");
			result.append("</CELL>");
			result.append("</ROW>");
		}
		result.append("</ROWS>");
		result.append("</LISTVIEWDATA>");

		return result.toString();
	}

	/**
	 * 2023-10-04 임정은 - 모아보기 그룹 관리 > 그룹 추가 팝업
	 */
	@RequestMapping(value="/ezSchedule/scheduleGatherWrite.do", method = RequestMethod.GET)
	public String scheduleGatherWrite(@CookieValue("loginCookie") String loginCookie, Model model, LoginVO loginVO) throws Exception {
		logger.debug("============ scheduleGatherWrite started ============");

		loginVO = commonUtil.userInfo(loginCookie);
		String use_ocs = ezCommonService.getTenantConfig("USE_OCS", loginVO.getTenantId());

		model.addAttribute("use_ocs", use_ocs);
		model.addAttribute("userInfo", loginVO);

		return "/ezSchedule/scheduleGatherWrite";
	}

	/**
	 * 2023-10-04 임정은 - 모아보기 그룹 관리 > 그룹 추가 팝업 > 확인 버튼
	 */
	@RequestMapping(value="/ezSchedule/scheduleGatherSave.do", method = RequestMethod.POST)
	@ResponseBody
	public void scheduleGatherSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO loginVO) throws Exception {
		logger.debug("============ scheduleGatherSave started ============");

		loginVO = commonUtil.userInfo(loginCookie);

		String gUID = UUID.randomUUID().toString().toUpperCase();
		String groupName = request.getParameter("groupName");
		String description = request.getParameter("description");
		String displayName = request.getParameter("displayName");
		String displayName2 = request.getParameter("displayName2");
		String memberList = request.getParameter("memberList");

		ezScheduleService.insertScheduleGather(gUID, loginVO.getId(), displayName, displayName2, groupName, description, loginVO.getTenantId() ,loginVO.getCompanyID());

		JSONParser parser = new JSONParser();
		JSONArray jsonArray = (JSONArray)parser.parse(memberList);

		for (int i = 0; i < jsonArray.size(); i++) {
			JSONObject obj = (JSONObject)jsonArray.get(i);

			String memberId = (String)obj.get("memberID");
			String memberName = (String)obj.get("memberName1");
			String memberName2 = (String)obj.get("memberName2");
			String memberDeptId = (String)obj.get("memberDeptId");

			ezScheduleService.insertScheduleGatherMember(gUID, memberId, memberName, memberName2, memberDeptId, loginVO.getTenantId());
		}
	}

	/**
	 * 2023-10-04 임정은 - 모아보기 그룹 관리 > 그룹 선택 시 상세 정보 리턴하는 메소드
	 */
	@RequestMapping(value="/ezSchedule/getGatherDetail.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getGatherDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO loginVO) throws Exception {
		logger.debug("============ getGatherDetail started ============");

		loginVO = commonUtil.userInfo(loginCookie);
		String gID = request.getParameter("groupID");

		List<ScheduleGroupListVO> gList = ezScheduleService.getMyGatherMemberList(gID, loginVO.getPrimary(), loginVO.getTenantId(), loginVO.getCompanyID());

		StringBuilder sb = new StringBuilder("<DATA>");
		for (int j = 0; j < gList.size(); j++) {
			sb.append(commonUtil.getQueryResult(gList.get(j)));
		}
		sb.append("</DATA>");

		return sb.toString();
	}

	/**
	 * 2023-10-04 임정은 - 모아보기 그룹 관리 > 그룹 선택 후 삭제 버튼
	 */
	@RequestMapping(value="/ezSchedule/scheduleGatherDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public void scheduleGatherDelete(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, LoginSimpleVO loginSimpleVO) throws Exception {
		logger.debug("============ scheduleGatherDelete started ============");

		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);

		String groupID = request.getParameter("groupID");
		String gIDs[] = groupID.split(";");

		for (int i = 0; i < gIDs.length; i++) {
			ezScheduleService.deleteScheduleGather(gIDs[i], loginSimpleVO.getTenantId(), "");
		}
	}

	/**
	 * 2023-10-04 임정은 - 모아보기 그룹 관리 > 그룹 관리 버튼
	 */
	@RequestMapping(value="/ezSchedule/scheduleGatherMember.do", method = RequestMethod.GET)
	public String scheduleGatherMember(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO loginVO) throws Exception {
		logger.debug("============ scheduleGatherMember started ============");

		loginVO = commonUtil.userInfo(loginCookie);

		String groupID = request.getParameter("groupID");
		String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());

		List<ScheduleGroupListVO> mList = ezScheduleService.getGatherMemberList(groupID, loginVO.getPrimary(), loginVO.getTenantId(), offSetMin, loginVO.getCompanyID());

		String primaryData = "";
		if (commonUtil.getPrimaryData(loginVO.getLang(), loginVO.getTenantId()).equals("1")) {
			primaryData = "1";
		} else {
			primaryData = "2";
		}

		model.addAttribute("primaryData", primaryData);
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("loginUserId", loginVO.getId());
		model.addAttribute("loginUserName",loginVO.getDisplayName());
		model.addAttribute("loginUserName2", loginVO.getDisplayName2());
		model.addAttribute("loginUserRoll",loginVO.getRollInfo());
		model.addAttribute("groupID", groupID);
		model.addAttribute("memberList", mList);
		model.addAttribute("groupName", mList.get(0).getGroupName().replace("\\", "&#92;"));
		model.addAttribute("description",mList.get(0).getDescription().replace("\\", "&#92;"));

		return "/ezSchedule/scheduleGatherMember";
	}

	/**
	 * 2023-10-05 임정은 - 모아보기 그룹 관리 > 그룹 관리 버튼 > 그룹명, 설명 수정 후 저장 버튼
	 */
	@RequestMapping(value="/ezSchedule/scheduleGatherModify.do", method = RequestMethod.POST)
	@ResponseBody
	public void scheduleGatherModify(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO loginVO) throws Exception {
		logger.debug("============ scheduleModifyGather started ============");

		loginVO = commonUtil.userInfo(loginCookie);

		String groupId = request.getParameter("groupId");
		String groupName = request.getParameter("groupName");
		String description = request.getParameter("description");

		ezScheduleService.updateScheduleGather(groupId, loginVO.getId(), groupName, description, loginVO.getTenantId());
	}

	/**
	 * 2023-10-05 임정은 - 모아보기 그룹 관리 > 그룹 관리 버튼 > 구성원 추가/편집 버튼 > 구성원 추가
	 */
	@RequestMapping(value = "/ezSchedule/scheduleGatherAddMember.do", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public void scheduleGatherAddMember(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO loginVO) throws Exception {
		logger.debug("============ scheduleGatherAddMember started ============");

		loginVO = commonUtil.userInfo(loginCookie);

		String groupId = request.getParameter("groupID");
		String memberList = request.getParameter("memberList");
		String displayName = request.getParameter("displayName");
		String displayName2 = request.getParameter("displayName2");

		JSONParser parser = new JSONParser();
		JSONArray jsonArray = (JSONArray)parser.parse(memberList);

		for (int i = 0; i < jsonArray.size(); i++) {
			JSONObject obj = (JSONObject) jsonArray.get(i);

			String memberId = (String) obj.get("memberID");
			String memberName = (String) obj.get("memberName1");
			String memberName2 = (String) obj.get("memberName2");
			String memberDeptId = (String) obj.get("memberDeptId");

			ezScheduleService.insertScheduleGatherMember(groupId, memberId, memberName, memberName2, memberDeptId, loginVO.getTenantId());
		}
	}

	/**
	 * 2023-10-05 임정은 - 모아보기 그룹 관리 > 그룹 관리 버튼 > 구성원 추가/편집 버튼 > 구성원 삭제
	 */
	@RequestMapping(value="/ezSchedule/scheduleGatherDelMember.do", method = RequestMethod.POST)
	@ResponseBody
	public void scheduleGatherDelMember(@RequestParam(value="memberID[]") String[] member, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginSimpleVO loginSimpleVO) throws Exception {
		logger.debug("============ scheduleGatherDelMember started ============");

		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		String groupID = request.getParameter("groupID");

		for (int i = 0; i < member.length; i++) {
			ezScheduleService.deleteScheduleGather(groupID, loginSimpleVO.getTenantId(), member[i]);
		}
	}

	/**
	 * 2023-10-06 임정은 - 모아보기 그룹 선택 시 일정 리스트 표출
	 */
	@RequestMapping(value="/ezSchedule/scheduleShowGatherList.do", method = RequestMethod.GET)
	public String scheduleShowGatherList(@CookieValue("loginCookie") String loginCookie, Model model, LoginSimpleVO loginSimpleVO) throws Exception {
		logger.debug("============ scheduleShowGatherList started ============");

		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);

		model.addAttribute("userInfo", loginSimpleVO);

		return "/ezSchedule/scheduleGatherList";
	}
	
	// 권기혁 - 일정 VIEW Status DB Set
	@RequestMapping(value = "/ezSchedule/scheduleSetViewStatus.do", method = RequestMethod.POST, produces="text/xml;charset=utf-8")
	@ResponseBody
	public void scheduleSetViewStatus(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("scheduleSetViewStatus started");
	    
	    loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		// USER 정보
		String userId = loginSimpleVO.getId();
		int tenantId = loginSimpleVO.getTenantId();
		//상태값
		String status = request.getParameter("STATUS");
		ScheduleConfigVO schConfVO = ezScheduleService.getScheduleConfig(userId, tenantId);
		
		if (schConfVO.getDefaultViewCheck().equals("N")) {
			if ("MONTH".equals(status)) {
				status = "2";
			} else if ("WEEK".equals(status)) {
				status = "1";
			} else {
				status = "0";
			}
			
			//상태값 DB 저장
			ezScheduleService.setScheduleViewStatus(userId, tenantId, status);
		}
		
		logger.debug("scheduleSetViewStatus ended");
	}
	
	/* 모든, 개인, 부서 일정 색상선택 popup 표출 */
	@RequestMapping(value = "/ezSchedule/scheduleSelectColor.do", method = RequestMethod.GET)
	public String selectColor(HttpServletRequest request, Model model) throws Exception {
		logger.debug("============ selectGroupColor started ============");
		
		model.addAttribute("type", request.getParameter("type"));
		model.addAttribute("relatedID", request.getParameter("relatedID"));
		model.addAttribute("color", request.getParameter("color"));
		
		logger.debug("selectGroupColor ended");
		return "/ezSchedule/scheduleSelectColor";
	}
	
	// 2025-04-23 조수빈 - 개인의 일정 항목별 체크 여부 저장 메소드
	@RequestMapping(value = "/ezSchedule/saveIsTagChecked.do", method = RequestMethod.POST, produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public String saveIsTagChecked(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String scheduleType, String relatedID, String isChecked) throws Exception {
		logger.debug("saveIsTagChecked started");
		
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String result = ezScheduleService.saveIsTagChecked(loginVO.getId(), scheduleType, relatedID, isChecked, loginVO.getTenantId(), loginVO.getCompanyID());
		
		logger.debug("saveIsTagChecked ended");
		return result;
	}
}
