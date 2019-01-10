package egovframework.ezEKP.ezSchedule.web;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.fortuna.ical4j.data.CalendarBuilder;
import net.fortuna.ical4j.data.ParserException;
import net.fortuna.ical4j.filter.Filter;
import net.fortuna.ical4j.filter.PeriodRule;
import net.fortuna.ical4j.model.Component;
import net.fortuna.ical4j.model.ComponentList;
import net.fortuna.ical4j.model.DateTime;
import net.fortuna.ical4j.model.Period;
import net.fortuna.ical4j.model.Property;
import net.fortuna.ical4j.model.Recur;
import net.fortuna.ical4j.model.TimeZoneRegistry;
import net.fortuna.ical4j.model.TimeZoneRegistryFactory;
import net.fortuna.ical4j.model.WeekDay;
import net.fortuna.ical4j.model.component.CalendarComponent;
import net.fortuna.ical4j.model.component.VEvent;
import net.fortuna.ical4j.model.component.VTimeZone;
import net.fortuna.ical4j.model.property.DtEnd;
import net.fortuna.ical4j.model.property.DtStart;
import net.fortuna.ical4j.model.property.RRule;
import net.fortuna.ical4j.util.MapTimeZoneCache;

import org.apache.commons.io.FileUtils;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import com.ibm.icu.util.Calendar;
import com.sun.org.apache.xml.internal.security.utils.Base64;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.service.impl.EzScheduleCompareUtil;
import egovframework.ezEKP.ezSchedule.service.impl.EzScheduleCompareUtilPublic;
import egovframework.ezEKP.ezSchedule.vo.AttachListVO;
import egovframework.ezEKP.ezSchedule.vo.AttendantListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleConfigVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleCumulerVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleDeptVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleReceiveListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleSecretaryVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

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
public class EzScheduleController extends EgovFileMngUtil {
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
	
	/**
	 * 일정관리 인덱스화면 호출함수
	 */
	@RequestMapping(value="/ezSchedule/scheduleIndex.do")
	public String  main(HttpServletRequest request, Model model) throws Exception {

		logger.debug("============ scheduleIndex started ============");
		
		String funCode = "";	// 업무관리 or 일정관리(3)
		String subCode = "";
		
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
        
		model.addAttribute("funCode", funCode);
		model.addAttribute("subCode", subCode);		
		
		return "/ezSchedule/scheduleIndex";
	}

	/**
	 * 일정관리 왼쪽화면 호출함수
	 */
	@RequestMapping(value="/ezSchedule/scheduleLeft.do")
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
		
		List<ScheduleGroupListVO> groupList = ezScheduleService.getScheduleGroupList(loginVO.getId(), loginVO.getTenantId() ,companyID);
				
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
		
		if(funCode.equals("3")) {
			return "/ezTask/taskLeft";
		} else {
			return "/ezSchedule/scheduleLeft";
		}
	}
	
	/**
	 * 일정관리 휴일 함수 호출 함수
	 */
	@RequestMapping(value = "/ezSchedule/scheduleGetHoliday.do", produces = "text/html; charset=utf-8")
	@ResponseBody
	public String scheduleGetHoliday(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception {
		
		logger.debug("============ scheduleGetHoliday started ============");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String cID = request.getParameter("COMPANYID");
		StringBuilder returnXML = new StringBuilder();
		String isRest = "normal";
		
		List<ScheGetHolidayVO> getHoliday = ezScheduleService.getTholiday(cID.trim(), userInfo.getCompanyID(), userInfo.getTenantId(), isRest);
				
		for (int i=0; i<getHoliday.size(); i++ ) {
			returnXML.append(commonUtil.getQueryResult(getHoliday.get(i)));
		}
		
		return "<DATA>" + returnXML.toString() + "</DATA>";
	}
	
	/**
	 * 일정관리 휴일 함수 호출 함수
	 */
	@RequestMapping(value = "/ezSchedule/scheduleGetHolidayJson.do", produces = "application/json; charset=utf-8")
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
	@RequestMapping(value = "/ezSchedule/scheduleGetHolidayJsonYear.do", produces = "application/json; charset=utf-8")
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
	@RequestMapping(value = "/ezSchedule/scheduleGetList.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleGetList(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception {
		
		logger.debug("============ scheduleGetList started ============");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);		
		String offSetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
				
		String startDate = request.getParameter("STARTDATE");
		String endDate = request.getParameter("ENDDATE");
		String idList = request.getParameter("IDLIST");
		String groupID = request.getParameter("GROUPID");	
		
		StringBuilder sb = new StringBuilder("<DATA>");
		//일정관리 데이터 호출 함수
		List<ScheduleInfoVO> sList = scheduleListData(startDate, endDate, idList, groupID, offSetMin, userInfo);
		
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
	@RequestMapping(value = "/ezSchedule/scheduleNewWebPartList.do", produces = "text/xml; charset=utf-8")
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
		String deptID = userInfo.getDeptID();
		
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
		
		List<ScheduleInfoVO> sList = ezScheduleService.getScheduleList(indiList, pidList, "", utcStartTime, utcEndTime, startDate, endDate, "", offSetMin, "",userInfo.getTenantId(), companyID, userInfo.getId());		
		
		return sList;
	}

	/**
	 * 일정관리 메인화면 호출함수
	 */
	@RequestMapping(value="/ezSchedule/scheduleMain.do")
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
		List<ScheduleCumulerVO> pubScheCumulerVO = ezScheduleService.getPublicScheduleCumuler(userID, lang, tenantID, companyID);
		        
        StringBuilder sb = new StringBuilder();        
                
        for (int i = 0; i < pubScheSecVO.size(); i++) {
        	ScheduleSecretaryVO vo = pubScheSecVO.get(i);
        	sb.append("<option value='" + vo.getSecId() + "' type='user'>" + vo.getSecName() + "</option>");
        }
       
        for (int i = 0; i < pubScheDeptVO.size(); i++) {
        	ScheduleDeptVO vo = pubScheDeptVO.get(i);
        	sb.append("<option value='" + vo.getDeptId() + "' type='dept'>[" + msg.getMessage("ezSchedule.t205", locale) + "]" + vo.getDeptName() + "</option>");
        }

        for (int i = 0; i < pubScheCumulerVO.size(); i++) {
        	ScheduleCumulerVO vo = pubScheCumulerVO.get(i);
        	sb.append("<option value='" + vo.getDeptId() + "' type='dept'>[" + msg.getMessage("ezSchedule.t996", locale) + "]" + vo.getTitleName() + "</option>");            
        }
     
        if (loginVO.getRollInfo().contains("c=1") || loginVO.getRollInfo().contains("k=1")) {
            companyAdmin = "Y";
            deptAdmin = "Y";
        } else if (loginVO.getRollInfo().contains("g=1")) {
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
            endTime		= 1020 / 60;
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
        //2018-06-07 구해안checkbox 값을 가져와서 char[]에 담기
        String idTypeChk = request.getParameter("idTypeChk");
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
        
        

        pOffset = loginVO.getOffset().split("\\|")[1];      
        timeZone = (Integer.parseInt(pOffset.split(":")[0]) * 60) + Integer.parseInt(pOffset.split(":")[1]);

        //2018-10-29 김혜정
        String useScheduleIcs = ezCommonService.getTenantConfig("useScheduleIcs", loginVO.getTenantId());
        
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
        
		return "/ezSchedule/scheduleMain";
	}
	
	/**
	 * 일정그룹관리 메인화면
	 */
	@RequestMapping(value="/ezSchedule/scheduleManageGroup.do")
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
	@RequestMapping(value="/ezSchedule/scheduleGroupList.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleGroupList(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleGroupList started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		List<ScheduleGroupListVO> myList = ezScheduleService.getMyGroupList(loginSimpleVO.getId(), loginSimpleVO.getTenantId(),loginSimpleVO.getCompanyID());
		
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
            
            int myMemberListCnt = ezScheduleService.getMyGroupMemberListCnt(data.getGroupId(), loginSimpleVO.getLang(), loginSimpleVO.getTenantId(),loginSimpleVO.getCompanyID());
            String cDate = commonUtil.getDateStringInUTC(data.getCreateDate(),loginSimpleVO.getOffset(),false).substring(0,10);
            
            result.append("<VALUE><![CDATA[" + data.getGroupName() + " (" + myMemberListCnt + msg.getMessage("ezSchedule.t00003", loginSimpleVO.getLocale()) + ")" + "]]></VALUE>");
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
	@RequestMapping(value="/ezSchedule/getGroupDetail.do", produces = "text/xml; charset=utf-8")
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
	@RequestMapping(value="/ezSchedule/scheduleDelGroup.do")	
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
	 */
	@RequestMapping(value="/ezSchedule/scheduleGroupMember.do")	
	public String scheduleGroupMember(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleGroupMember started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		String groupID = request.getParameter("groupID");
		String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());

		List<ScheduleGroupListVO> mList = ezScheduleService.getGroupMemberList(groupID, loginVO.getPrimary(),loginVO.getTenantId(), offSetMin ,loginVO.getCompanyID());
		
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("groupID", groupID);
		model.addAttribute("memberList", mList);
		
		return "/ezSchedule/scheduleGroupMember";
	}
	
	/**
	 * 일정그룹관리 멤버 제외 버튼 클릭 시
	 */
	@RequestMapping(value="/ezSchedule/scheduleDelMember.do")
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
	 * 일정그룹관리 멤버 재요청 버튼 클릭 시
	 */
	@RequestMapping(value="/ezSchedule/scheduleUpdateMember.do")
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
	
	@RequestMapping(value="/ezSchedule/scheduleUpdateAttendant.do")
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
	@RequestMapping(value = "/ezSchedule/scheduleSelectAttendant.do")
	public String scheduleSelectAttendant(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleSelectAttendant started ============");
		
        String title = request.getParameter("title");
        String startTime = request.getParameter("StartTime");
        String endTime = request.getParameter("EndTime");
        String gubun = request.getParameter("gubun");
        String type = request.getParameter("type");
        String pSearchString = request.getParameter("searchString");
				    		
		if (title == null) title = "";		
		if (startTime == null) startTime = "";
		if (endTime == null) endTime = "";
		if (gubun == null) gubun = "";
		if (type == null) type = "";
		if (pSearchString == null) pSearchString = "";
		
		loginVO = commonUtil.userInfo(loginCookie);
		String use_ocs = ezCommonService.getTenantConfig("USE_OCS", loginVO.getTenantId());
		
		model.addAttribute("title", title);
		model.addAttribute("startTime", startTime);
		model.addAttribute("endTime", endTime);
		model.addAttribute("gubun", gubun);
		model.addAttribute("type", type);
		model.addAttribute("pSearchString", pSearchString);
		model.addAttribute("use_ocs", use_ocs);
		model.addAttribute("userID", loginVO.getId());
		model.addAttribute("deptID", loginVO.getDeptID());
		model.addAttribute("companyID", loginVO.getCompanyID());
		
		
		//2018-06-22 구해안
		
		
		return "ezSchedule/scheduleSelectAttendant";
	}	
	
	/**
	 * 일정그룹관리 멤버 추가 
	 */
	@RequestMapping(value = "/ezSchedule/scheduleAddMember.do", produces = "text/html;charset=UTF-8")
	@ResponseBody
	public void scheduleAddMember(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleAddMember started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String groupId = request.getParameter("groupID");
		String memberList = request.getParameter("memberList");

		JSONParser parser = new JSONParser();
		JSONArray jsonArray = (JSONArray)parser.parse(memberList);
		
		for(int i = 0; i < jsonArray.size(); i++) {
			JSONObject obj = (JSONObject) jsonArray.get(i);
			
			String memberId = (String) obj.get("memberID");
			String memberName = (String) obj.get("memberName1");
			String memberName2 = (String) obj.get("memberName2");
			
			ezScheduleService.insertScheduleGroupMember(groupId, memberId, memberName, memberName2, loginSimpleVO.getTenantId());
		}
	}
	
	/**
	 * 일정그룹관리 그룹 추가 팝업
	 */
	@RequestMapping(value="/ezSchedule/scheduleGroupWrite.do")
	public String scheduleGroupWrite(@CookieValue("loginCookie") String loginCookie, Model model, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleGroupWrite started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		String use_ocs = ezCommonService.getTenantConfig("USE_OCS", loginVO.getTenantId());

		model.addAttribute("use_ocs", use_ocs);
		model.addAttribute("userInfo", loginVO);
		
		return "/ezSchedule/scheduleGroupWrite";
	}
	
	/**
	 * 일정그룹관리 그룹 추가 팝업 > 부서선택 클릭 시
	 */
	@RequestMapping(value="/ezSchedule/getDeptUserList.do", produces = "text/xml;charset=UTF-8")
	@ResponseBody
	public String getDeptUserList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO loginVO) throws Exception {
		
		logger.debug("============ getDeptUserList started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		String deptId = request.getParameter("deptID");
		String subDept = request.getParameter("subDept");		
		
		String result = ezScheduleService.getDeptMemberList(deptId, subDept, loginVO.getPrimary(), loginVO.getTenantId() ,loginVO.getCompanyID());
				
		return result;
	}
	
	/**
	 * 일정그룹관리 그룹 추가 팝업 > 그룹등록 확인 클릭 시
	 */
	@RequestMapping(value="/ezSchedule/scheduleSaveGroup.do")
	@ResponseBody
	public void scheduleSaveGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleSaveGroup started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String gUID = UUID.randomUUID().toString().toUpperCase();		
		String groupName = request.getParameter("groupName");
		String description = request.getParameter("description");
		String displayName = request.getParameter("displayName");
		String displayName2 = request.getParameter("displayName2");		
		String memberList = request.getParameter("memberList");
		
		ezScheduleService.insertScheduleGroup(gUID, loginSimpleVO.getId(), displayName, displayName2, groupName, description, loginSimpleVO.getTenantId() ,loginSimpleVO.getCompanyID());

		JSONParser parser = new JSONParser();
		JSONArray jsonArray = (JSONArray)parser.parse(memberList);
		
		for(int i = 0; i < jsonArray.size(); i++) {
			JSONObject obj = (JSONObject) jsonArray.get(i);
			
			String memberId = (String) obj.get("memberID");
			String memberName = (String) obj.get("memberName1");
			String memberName2 = (String) obj.get("memberName2");
			
			ezScheduleService.insertScheduleGroupMember(gUID, memberId, memberName, memberName2, loginSimpleVO.getTenantId());
		}
	}
	
	/**
	 * 일정검색
	 */
	@RequestMapping(value="/ezSchedule/scheduleSearch.do")	
	public String scheduleSearch(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleSearch started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		List<ScheduleInfoVO> sList = null;
		String filter = request.getParameter("filter");
		String keyword = request.getParameter("keyword");
		String startDate = request.getParameter("sdate");
		String endDate = request.getParameter("edate");
		String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());		
		String indiList = "'" + loginVO.getId() + "'";
		
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
			
			if (keyword == null) keyword = "";
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
			
			sList = ezScheduleService.getScheduleList(indiList, pidList, filter.trim(), utcStartTime, utcEndTime, startDate, endDate, keyword.trim(), offSetMin, "", loginVO.getTenantId(), loginVO.getCompanyID(), loginVO.getId());
			
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
		model.addAttribute("keyword", keyword);
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
	@RequestMapping(value="/ezSchedule/schedulePublicSearch.do")	
	public String schedulePulbicSearch(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO loginVO) throws Exception {
		
		logger.debug("============ schedulePulbicSearch started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		List<ScheduleInfoVO> sList = null;
		String idList = request.getParameter("idlist");
		String nameList = request.getParameter("namelist");
		String startDate = request.getParameter("sdate");
		String endDate = request.getParameter("edate");
		String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());
		
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
			sList = ezScheduleService.getScheduleList(userIDList, "\'\'", "IsPublic", utcStartTime, utcEndTime, startDate, endDate, "Y", offSetMin, "",loginVO.getTenantId(), loginVO.getCompanyID(), loginVO.getId());
			
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
	@RequestMapping(value="/ezSchedule/scheduleSelectEntity.do")
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
		
		model.addAttribute("title", title);
		model.addAttribute("startTime", startTime);
		model.addAttribute("endTime", endTime);				
		model.addAttribute("pSearchString", pSearchString);
		model.addAttribute("use_ocs", use_ocs);
		model.addAttribute("userID", loginVO.getId());
		model.addAttribute("deptID", loginVO.getDeptID());
		
		return "/ezSchedule/scheduleSelectEntity";
	}
	
	/**
	 * 공통 > 공유자 지정 팝업
	 */
	@RequestMapping(value="/ezSchedule/scheduleSelectSecretary.do")
	public String scheduleSelectSecretary(@CookieValue("loginCookie") String loginCookie, Model model, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleSelectSecretary started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("deptID", loginVO.getDeptID());
		
		return "/ezSchedule/scheduleSelectSecretary";
	}
	
	/**
	 * 공통 > 공유부서 지정 팝업
	 */
	@RequestMapping(value="/ezSchedule/scheduleSelectShareDept.do")
	public String scheduleSelectShareDept(@CookieValue("loginCookie") String loginCookie, Model model, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleSelectShareDept started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("deptID", loginVO.getDeptID());
		
		return "/ezSchedule/scheduleSelectShareDept";
	}
	
	/**
	 * 공통 > 음력날짜 사용여부 데이터
	 */
	@RequestMapping(value="/ezSchedule/scheduleGetLunarUse.do", produces = "text/html;charset=UTF-8")
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
	@RequestMapping(value="/ezSchedule/scheduleGetCumDeptID.do", produces = "text/html;charset=UTF-8")
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
	@RequestMapping(value="/ezSchedule/scheduleGetRegi.do", produces = "text/html;charset=UTF-8")
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
	@RequestMapping(value="/ezSchedule/scheduleConfigMain.do")
	public String scheduleConfigMain(Model model, HttpServletRequest request) throws Exception {
		logger.debug("============ scheduleConfigMain started ============");
		
		String flag = request.getParameter("flag") == null ? "" : request.getParameter("flag");
		model.addAttribute("flag", flag);
		
		logger.debug("============ scheduleConfigMain ended ============");
		return "/ezSchedule/scheduleConfigMain";
	}
	
	/**
	 * 환경설정 일정관리
	 */	
	@RequestMapping(value="/ezSchedule/scheduleConfig.do")	
	public String scheduleConfig(@CookieValue("loginCookie") String loginCookie, Model model, LoginVO loginVO, ScheduleConfigVO scheduleConfigVO, OrganUserVO organUserVO) throws Exception {
		
		logger.debug("============ scheduleConfig started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		String userID = loginVO.getId();
		int tenantID = loginVO.getTenantId();
		String companyID = loginVO.getCompanyID();
		
		scheduleConfigVO = ezScheduleService.getScheduleConfig(userID, tenantID);
		List<ScheduleSecretaryVO> sList = ezScheduleService.getSecretaryList(userID, tenantID, companyID);
		List<OrganUserVO> oList = new ArrayList<OrganUserVO>();
		
		for (int i=0; i < sList.size(); i++) {
			ScheduleSecretaryVO vo = sList.get(i);
			
			organUserVO = ezOrganAdminService.getUserInfo(vo.getSecId(), "1", tenantID);
			
			organUserVO.setCn(vo.getSecId());
			organUserVO.setDisplayName(vo.getSecName());
			
			oList.add(i,organUserVO);
		}
		
		model.addAttribute("selectList", oList);
		model.addAttribute("scheduleConfigVO", scheduleConfigVO);
		model.addAttribute("displayName1", loginVO.getDisplayName1());
		model.addAttribute("displayName2", loginVO.getDisplayName2());
		
		return "/ezSchedule/scheduleConfig";
	}
	
	/**
	 * 환경설정 일정관리 저장
	 */	
	@RequestMapping(value="/ezSchedule/scheduleSaveConfig.do")
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

		JSONParser parser = new JSONParser();
		JSONArray jsonArray = (JSONArray)parser.parse(listSecretary);
				
		//기존 환경설정 정보 삭제
		ezScheduleService.deleteScheduleConfig(userID, tenantID);
		//기존 비서정보 삭제
		ezScheduleService.deleteSecretary(userID, tenantID, companyID);
		//새로운 환경설정 정보 등록
		ezScheduleService.insertScheduleConfig(userID, defaultView, startDay, startTime, endTime, autoDelete, tenantID);		
		
		for (int i = 0; i < jsonArray.size(); i++) {
			JSONObject obj = (JSONObject) jsonArray.get(i);
			
			String secretaryID = (String) obj.get("secretaryID");
			String secretaryName = (String) obj.get("secretaryName");
			//새로운 비서정보 등록
			ezScheduleService.insertSecretary(userID, displayName, displayName2, secretaryID, secretaryName, tenantID, companyID);
		}			
	}
	
	/**
	 * 일정작성
	 */
	@RequestMapping(value="/ezSchedule/scheduleWrite.do")
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
                
        StringBuilder strAttach = new StringBuilder();        
        StringBuilder strOwnerID = new StringBuilder();
        ScheduleInfoVO scheduleInfo = new ScheduleInfoVO();
        
		List<ScheduleSecretaryVO> sList = ezScheduleService.getPublicScheduleSec(userID, lang, tenantID ,companyID);
		List<ScheduleDeptVO> pdList = ezScheduleService.getPublicScheduleDept(userID, lang, tenantID ,companyID);
		List<ScheduleCumulerVO> cList = ezScheduleService.getPublicScheduleCumuler(userID, lang, tenantID, companyID);
		
		loginVO = commonUtil.userInfo(loginCookie);

        if (loginVO.getRollInfo().contains("c=1") || loginVO.getRollInfo().contains("k=1")) {
        	pCompanyAdmin = "Y";
        	pDeptAdmin = "Y";
        } else if (loginVO.getRollInfo().contains("g=1")) {
        	pDeptAdmin = "Y";
        }        
        
        String _defaultid = request.getParameter("defaultid");
		if (_defaultid == null) _defaultid = "";
         
		String _scheduleid = request.getParameter("id");
		if (_scheduleid == null) {
			_scheduleid = "";
		} else {
			_scheduleid.replace(" ", "+");
		}
		
		String _otherid = request.getParameter("otherid");
		if (_otherid == null) _otherid = "";
         
		String pageFrom = request.getParameter("pageFrom");
		if (pageFrom == null) pageFrom = "";
         
		String _scheduletype = request.getParameter("type");
		if (_scheduletype == null) _scheduletype = "";
         
		String _pattern = request.getParameter("pattern");
		if (_pattern == null) _pattern = "";
         
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
            }
      	
        	model.addAttribute("strLabelOwner", strLabelOwner);        	
        	model.addAttribute("strAttach", strAttach.toString());        	
        } else {
        	if (!_otherid.equals("")) {    
        		//개인일정
        		String type = _scheduletype;
        		strOwnerID.append("<option value='" + type + ";;" + _otherid + "'>" + request.getParameter("othername") + "</option>");
        	} else {
        		int count = 1;
				int defaultIndex = Integer.parseInt(_defaultid);
				
				if (primary.equals("1")) {
					//개인일정
					strOwnerID.append("<option value='1;;" + userId + "'" + (count == defaultIndex ? " selected" : "")  + ">" + msg.getMessage("ezSchedule.t372", locale) + " " + commonUtil.cleanValue(loginVO.getDisplayName1()) + "</option>");
					count++;
					//비서일정
					for (ScheduleSecretaryVO vo : sList) {
	            		//비서일정
	            		strOwnerID.append("<option value='1;;" + vo.getSecId()+ "'" + (count == defaultIndex ? " selected" : "")  + ">" + msg.getMessage("ezSchedule.t372", locale) + " " + commonUtil.cleanValue(vo.getSecName()) + "</option>");
	            		count++;
	            	}
					//부서일정
					strOwnerID.append("<option value='2;;" + loginVO.getDeptID() + "'" + (count == defaultIndex ? " selected" : "")  + ">" + msg.getMessage("ezSchedule.t373", locale) + " " + commonUtil.cleanValue(loginVO.getDeptName1()) + "</option>");
					count++;
					//공유일정
					dept_schedule:
					for (ScheduleDeptVO vo : pdList) {
						for (ScheduleCumulerVO vo2 : cList) {
							if (vo.getDeptId().equals(vo2.getDeptId()) || loginVO.getDeptID().equals(vo.getDeptId())) {
								continue dept_schedule;
							}
						}						
						strOwnerID.append("<option value='2;;" + vo.getDeptId() + "'" + (count == defaultIndex ? " selected" : "")  + ">" + msg.getMessage("ezSchedule.t373", locale) + " " + commonUtil.cleanValue(vo.getDeptName()) + "</option>");
						count++;
					}
					
					//겸직일정
					for (ScheduleCumulerVO vo : cList) {
						if (loginVO.getDeptID().equals(vo.getDeptId())) {
							continue;
						} else {
							strOwnerID.append("<option value='2;;" + vo.getDeptId() + "'" + (count == defaultIndex ? " selected" : "")  + ">" + msg.getMessage("ezSchedule.t373", locale) + " " + commonUtil.cleanValue(vo.getTitleName()) + "</option>");
							count++;
						}
	            	}
					//회사일정
					strOwnerID.append("<option value='3;;" + loginVO.getCompanyID() + "'" + (count == defaultIndex ? " selected" : "")  + ">" + msg.getMessage("ezSchedule.t374", locale) + " " + commonUtil.cleanValue(loginVO.getCompanyName1()) + "</option>");
					count++;					
					
				} else {
					//개인일정
					strOwnerID.append("<option value='1;;" + userId + "'" + (count == defaultIndex ? " selected" : "")  + ">" + msg.getMessage("ezSchedule.t372", locale) + " " + commonUtil.cleanValue(loginVO.getDisplayName2()) + "</option>");
					count++;
					//비서일정
					for (ScheduleSecretaryVO vo : sList) {
	            		//비서일정
	            		strOwnerID.append("<option value='1;;" + vo.getSecId()+ "'" + (count == defaultIndex ? " selected" : "")  + ">" + msg.getMessage("ezSchedule.t372", locale) + " " + commonUtil.cleanValue(vo.getSecName()) + "</option>");
	            		count++;
	            	}
					//부서일정
					strOwnerID.append("<option value='2;;" + loginVO.getDeptID() + "'" + (count == defaultIndex ? " selected" : "")  + ">" + msg.getMessage("ezSchedule.t373", locale) + " " + commonUtil.cleanValue(loginVO.getDeptName2()) + "</option>");
					count++;
					//공유일정
					dept_schedule:
					for (ScheduleDeptVO vo : pdList) {
						for (ScheduleCumulerVO vo2 : cList) {
							if (vo.getDeptId().equals(vo2.getDeptId()) || loginVO.getDeptID().equals(vo.getDeptId())) {
								continue dept_schedule;
							}
						}						
						strOwnerID.append("<option value='2;;" + vo.getDeptId() + "'" + (count == defaultIndex ? " selected" : "")  + ">" + msg.getMessage("ezSchedule.t373", locale) + " " + commonUtil.cleanValue(vo.getDeptName()) + "</option>");
						count++;
					}
					
					//겸직일정
					for (ScheduleCumulerVO vo : cList) {
						if (loginVO.getDeptID().equals(vo.getDeptId())) {
							continue;
						} else {
							strOwnerID.append("<option value='2;;" + vo.getDeptId() + "'" + (count == defaultIndex ? " selected" : "")  + ">" + msg.getMessage("ezSchedule.t373", locale) + " " + commonUtil.cleanValue(vo.getTitleName()) + "</option>");
							count++;
						}
	            	}
					
					//회사일정
					strOwnerID.append("<option value='3;;" + loginVO.getCompanyID() + "'" + (count == defaultIndex ? " selected" : "")  + ">" + msg.getMessage("ezSchedule.t374", locale) + " " + commonUtil.cleanValue(loginVO.getCompanyName2()) + "</option>");
					count++;
				}
            	
            	List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(userId, loginVO.getTenantId(), loginVO.getCompanyID());
            	
            	for (ScheduleGroupListVO vo : gList) {
            		//그룹 일정
            		strOwnerID.append("<option value='7;;" + vo.getGroupId() + "'" + (count == defaultIndex ? " selected" : "")  + ">" + msg.getMessage("ezSchedule.t375", locale) + " " + commonUtil.cleanValue(vo.getGroupName()) + "</option>");
            		count++;
            	}
        	}
			String cDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), loginVO.getOffset(), false);				
			
			_datetype = request.getParameter("datetype");
    		if (_datetype == null) _datetype = "";
			
			if (request.getParameter("sdate") != null) {
				startDateTime = request.getParameter("sdate");
			} else {				
				if (request.getParameter("startdate") != null) {
					cDate = request.getParameter("startdate");
				}	
				startDateTime = getUploadDate(cDate, true);
			}
			
			if (request.getParameter("edate") != null) {
				endDateTime = request.getParameter("edate");
			} else {
				if (request.getParameter("enddate") != null) {
					cDate = request.getParameter("enddate");
				}
				endDateTime = getUploadDate(cDate, false);
			}
        }
        
        // 2018-10-25 김민성 - 일정 작성시 공개/비공개 기본값 설정 관련 config 추가
        if(chkSchedulePublic.equals("ON")) {
        	// _ispublic =
        }
        
        //2017-11-15 자원관리 사용하지 않을 경우 탭 처리
        String accessList = ezPortalService.getAccessList(loginVO);
		boolean checkResourceTab = ezPortalService.checkViewRightBln("6db81dc5-e8ba-49c8-b625-df4fd375a43a", accessList, loginVO.getTenantId());

        UploadSDate = startDateTime;
        UploadEDate = endDateTime;

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
        model.addAttribute("strOwnerID", strOwnerID);        
        model.addAttribute("offSetMin", offSetMin);
        model.addAttribute("scheduleInfo", scheduleInfo);
        model.addAttribute("useAnyoneEdit", useAnyoneEdit);
        model.addAttribute("checkResourceTab", checkResourceTab);

   		return "/ezSchedule/scheduleWrite";
	}	
		
	/**
	 * 일정작성 > 반복일정 선택
	 */	
	@RequestMapping(value="/ezSchedule/scheduleRepetition.do")
	public String scheduleRepetition(@CookieValue("loginCookie") String loginCookie, Model model, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleRepetition started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		model.addAttribute("lang", loginSimpleVO.getLang());
		
		return "/ezSchedule/scheduleRepetition";
	}
	
	/**
	 * 일정작성 > 반복일정 선택
	 */	
	@RequestMapping(value="/ezSchedule/scheduleSelectResource.do")
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
	@RequestMapping(value = "/ezSchedule/scheduleSave.do")
	@ResponseBody
	public String scheduleSave(@CookieValue("loginCookie") String loginCookie, @RequestBody String requestXML, HttpServletRequest request, HttpServletResponse response, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleSave started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);	
		int result = 0;
						
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

        if (scheduleid.equals("")) {
	        //Set ownername and ownername2
	        if (scheduletype.equals("1")) {
	        	ownername = creatorname;
	        	ownername2 = creatorname2;
	        }
	        else if (scheduletype.equals("2") || scheduletype.equals("3")) {
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
        }        

        String startdate = doc.getElementsByTagName("STARTDATE").item(0).getTextContent();
        String enddate = doc.getElementsByTagName("ENDDATE").item(0).getTextContent();

    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
//    	Calendar cal = Calendar.getInstance();
//    	cal.setTime(sdf.parse(enddate));
//    	
//    	if (cal.get(Calendar.HOUR) == 0 && cal.get(Calendar.MINUTE) == 0) {        		
//    		cal.add(Calendar.MINUTE, -1);        		
//    		enddate = sdf.format(cal.getTime());
//    	}

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
	    if (scheduleid == null || scheduleid.equals("")) {
        	//insertSchedule
        	result = ezScheduleService.insertSchedule(ownerid, ownername, ownername2, creatorid, creatorname, creatorname2, scheduletype, importance, ispublic, datetype, startdate, enddate, repetition, title, location, content, attach, 
        			attendantId, attendantName, attendantName2, attendantDeptName, attendantDeptName2, defaultPath, loginVO.getTenantId(), loginVO.getCompanyID());
        } else {
        	//updateSchedule
        	result = ezScheduleService.updateSchedule(scheduleid, creatorid, creatorname, creatorname2, importance, ispublic, datetype, startdate, enddate, repetition, title, location, content, attach, defaultPath, loginVO.getTenantId(), loginVO.getCompanyID());
        }
	    
	    //2018-08-01 구해안 반복설정 날짜 체크
	    
        
        return Integer.toString(result);
	}
	
	/**
	 * 일정작성 > 참석자 일정조회 팝업
	 */	
	@RequestMapping(value="/ezSchedule/scheduleAddUser.do")
	public String scheduleAddUser(@CookieValue("loginCookie") String loginCookie, Model model, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleAddUser started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		model.addAttribute("userInfo", loginSimpleVO);
		
		return "/ezSchedule/scheduleAddUser";
	}
	
	/**
	 * 일정작성 > 참석자 일정조회 데이터 
	 */	
	@RequestMapping(value="/ezSchedule/scheduleAttendantList.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleAttendantList(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleAttendantList started ============");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String lang = userInfo.getPrimary();
		int tenantID = userInfo.getTenantId();
		String offSetMin = commonUtil.getMinuteUTC(userInfo.getOffset());		
		String startDate = request.getParameter("STARTDATE");
		String endDate = request.getParameter("ENDDATE");
		String idList = request.getParameter("IDLIST");		
		String pidList = "'" + idList + "'";
		
		String DeptID = ezScheduleService.getCumDeptId(idList, userInfo.getTenantId(), userInfo.getCompanyID());
		String CompanyID = userInfo.getCompanyID();
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

		List<ScheduleInfoVO> sList = ezScheduleService.getScheduleList(pidList, dcidList, "", utcStartTime, utcEndTime, startDate, endDate, "", offSetMin, "",userInfo.getTenantId(), userInfo.getCompanyID(), idList);
		
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
	@RequestMapping(value="/ezSchedule/scheduleResourceInfo.do")	
	public String scheduleResourceInfo(@CookieValue("loginCookie") String loginCookie, Model model, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleResourceInfo started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		model.addAttribute("userInfo", loginSimpleVO);
		
		return "/ezSchedule/scheduleResourceInfo";
	}
	
	/**
	 * 일정작성 > 이름확인 조회
	 */
	@RequestMapping(value = "/ezSchedule/checkName.do")
	public String checkName() throws Exception {
		
		logger.debug("============ checkName started ============");
		
		return "ezSchedule/scheduleCheckName";
	}
	
	/**
	 * 일정 메인화면 > 인쇄
	 */
	@RequestMapping(value = "/ezSchedule/schedulePrint.do")
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
			cal.add(Calendar.DATE, 41);
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
		
		return "ezSchedule/schedulePrint";
	}
	
	/**
	 * 일정작성 > 인쇄
	 */
	@RequestMapping(value = "/ezSchedule/scheduleContentsPrint.do")
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
	@RequestMapping(value = "/ezSchedule/scheduleRead.do")
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
        String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());
        int tenantId = loginVO.getTenantId();
        String companyID = loginVO.getCompanyID();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        
        //일정 상세정보
        ScheduleInfoVO vo = ezScheduleService.getScheduleInfo(_scheduleid, offSetMin, tenantId, companyID);
        
        //일정기간 계산        
        if (vo.getDateType().equals("3")){        	
        	_repeatcount = request.getParameter("repeatcount");
        	_date = request.getParameter("date");
        	//일정관리 참석자 초대메세지에서 반복일정 걸려있는 일정 조회 시, 회차랑 시작일자를 null로 받아와서 null검사 추가 #14484
        	if (_repeatcount == null)
        		_repeatcount = "1";
        	if (_date == null)
        		_date = vo.getStartDate().substring(0,10);
        	
        	if (vo.getRepetition().split("\\|")[1].equals("1")) {
        		dateString = msg.getMessage("ezSchedule.t343", locale) + " (" + _repeatcount + msg.getMessage("ezSchedule.t329", locale) + " " + _date + " (" + msg.getMessage("ezSchedule.t280", locale);
        	} else {
        		dateString = msg.getMessage("ezSchedule.t343", locale) + " (" + _repeatcount + msg.getMessage("ezSchedule.t329", locale) + " " + _date + " " 
        					+ vo.getStartDate().substring(11, 16) + " ~ " + vo.getEndDate().substring(11, 16);        		
        	}        	
        } else if (vo.getDateType().equals("2")){
        	//하루종일 일때 endDate 수정
        	String realEndDateFormat = "";
        	if (vo.getEndDate().substring(10).equals(" 00:00:00.0")) {
        		Date realEndDate = sdf.parse(vo.getEndDate().substring(0,10));
        		Calendar cal = Calendar.getInstance();
        		cal.setTime(realEndDate);
        		cal.add(Calendar.DATE, -1);
        		realEndDate = cal.getTime();
        		realEndDateFormat = sdf.format(realEndDate);
        	}
        	
        	dateString = vo.getStartDate().substring(0,10) + " (" + msg.getMessage("ezSchedule.t280", locale) + " ~ " + realEndDateFormat + " (" + msg.getMessage("ezSchedule.t280", locale);        	
        } else {
        	dateString = vo.getStartDate().substring(0,16) + " ~ " + vo.getEndDate().substring(0,16);
        }
        
        //자원예약 정보
        int resourceCnt = ezScheduleService.getResourceCount(_scheduleid, tenantId);
        
        //참석자 정보
        if (vo.getHasAttendant().equals("Y")) {        
        	String parentID = (vo.getParentId().equals("0") ? _scheduleid : vo.getParentId());
        	List<AttendantListVO> aList = ezScheduleService.getAttendantList(parentID, offSetMin, tenantId, companyID);
        	
        	model.addAttribute("attendantList", aList);
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
        	&& (!scheduleType.equals("2") || !ownerId.equals(loginVO.getDeptID()) || (rollInfo.indexOf("c=1") == -1 && rollInfo.indexOf("k=1") == -1 && rollInfo.indexOf("g=1") == -1))
        	&& (!scheduleType.equals("3") && !scheduleType.equals("2") || (rollInfo.indexOf("c=1") == -1 && rollInfo.indexOf("k=1") == -1)) 
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
        
		return "ezSchedule/scheduleRead";
	}
	
	/**
	 * 일정보기 > 반복일정 선택 후 삭제시 팝업 
	 */	
	@RequestMapping(value="/ezSchedule/scheduleDeleteConfirm.do")	
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
	@RequestMapping(value="/ezSchedule/scheduleDelete.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public void scheduleDelete(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleDelete started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String scheduleId = request.getParameter("scheduleId");
		String resDel = request.getParameter("resDel");
		String dateType = request.getParameter("dateType");
		
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
	@RequestMapping(value="/ezSchedule/scheduleOnceDelete.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public void scheduleOnceDelete(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleOnceDelete started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String scheduleId = request.getParameter("scheduleId");
		String selectDate = request.getParameter("selectDate");
		String startDate = request.getParameter("startDate");		
		String realStartDate = selectDate + "" + startDate.substring(10, 16);		

		String realDate = commonUtil.getDateStringInUTC(realStartDate, loginSimpleVO.getOffset(), true);

		//일정데이터 삭제
		ezScheduleService.insertScheduleRepeDel(scheduleId, realDate, loginSimpleVO.getTenantId(), loginSimpleVO.getCompanyID());
	}
	
	/**
	 * 일정작성 > 인쇄
	 */
	@RequestMapping(value = "/ezSchedule/scheduleManageAttendant.do")
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
	@RequestMapping(value = "/ezSchedule/scheduleAddAttendant.do", produces = "text/html;charset=UTF-8")
	@ResponseBody
	public void scheduleAddAttendant(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginSimpleVO loginSimpleVO) throws Exception {
		
		logger.debug("============ scheduleAddAttendant started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
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
		}
	}
	
	/**
	 * 일정보기 > 참석자관리 > 참석자제외
	 */	
	@RequestMapping(value="/ezSchedule/scheduleDelAttendant.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public void scheduleDelAttendant(@RequestParam(value="attendantIdList[]") String[] attendantIdList, @CookieValue("loginCookie") String loginCookie,LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleDelAttendant started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String scheduleId = request.getParameter("scheduleId");

		for (int i=0; i < attendantIdList.length; i++) {
			ezScheduleService.scheduleDelAttendant(scheduleId, attendantIdList[i], loginSimpleVO.getTenantId());
		}	
	}
	
	/**
	 * 일정메인 > 참석자 초대 팝업
	 */	
	@RequestMapping(value="/ezSchedule/scheduleReceiveAttendant.do")	
	public String scheduleReceiveAttendant(@CookieValue("loginCookie") String loginCookie,LoginVO loginVO, Model model, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleReceiveAttendant started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());
		
		List<ScheduleReceiveListVO> rList = ezScheduleService.getReceiveList(loginVO.getId(), loginVO.getTenantId(), offSetMin, loginVO.getCompanyID());
		
		model.addAttribute("receiveList", rList);
		model.addAttribute("userInfo", loginVO);
		
		return "ezSchedule/scheduleReceiveAttendant";
	}
	
	/**
	 * 일정보기 > 참석자관리 > 참석자제외
	 */	
	@RequestMapping(value="/ezSchedule/scheduleAcceptAttendant.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public void scheduleAcceptAttendant(@RequestParam(value="scheduleIdList[]") String[] scheduleIdList, @CookieValue("loginCookie") String loginCookie,LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleAcceptAttendant started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String status = request.getParameter("status");
		String displayName = request.getParameter("displayName");
		String displayName2 = request.getParameter("displayName2");
		String attendantId = loginSimpleVO.getId();
		
		for (int i=0; i < scheduleIdList.length; i++) {
			ezScheduleService.updateAttendant(scheduleIdList[i], attendantId, displayName, displayName2, status, loginSimpleVO.getTenantId());
		}	
	}
	
	/**
	 * 일정메인 > 그룹 초대 팝업
	 */	
	@RequestMapping(value="/ezSchedule/scheduleReceiveMember.do")	
	public String scheduleReceiveMember(@CookieValue("loginCookie") String loginCookie, LoginVO loginVO, Model model, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleReceiveMember started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());
				
		List<ScheduleGroupListVO> iList = ezScheduleService.getInviteScheduleGroupList(loginVO.getId(), loginVO.getTenantId(), offSetMin, loginVO.getCompanyID());
		
		model.addAttribute("receiveList", iList);
		model.addAttribute("userInfo", loginVO);
		
		return "ezSchedule/scheduleReceiveMember";
	}
	
	/**
	 * 일정보기 > 그룹 초대 > 수락 or 거절
	 */	
	@RequestMapping(value="/ezSchedule/scheduleAcceptMember.do", produces = "text/xml; charset=utf-8")
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
	@RequestMapping(value="/ezSchedule/scheduleReadConfirm.do")
	public String scheduleReadConfirm() throws Exception {
		
		logger.debug("============ scheduleReadConfirm started ============");
		
		return "ezSchedule/scheduleReadConfirm";
	}

	/**
	 * 일정작성 > 첨부파일 리스트 호출 
	 */
	@RequestMapping(value = "/ezSchedule/scheduleDragAndDrop.do")
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
	@RequestMapping(value = "/ezSchedule/uploadScheduleAttach.do", produces = "text/plain; charset=utf-8")
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
        File file = new File(pDirPath + "uploadFile");

        if (!file.exists()) {
        	file.mkdir();        
        }

        StringBuffer strXML = new StringBuffer();
        strXML.append("<ROOT><NODES>");
        
        for (int i = 0; i < cnt; i++) {        	
        	fileSize[i] = multiFile.get(i).getSize();
            String extend = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
            String newFileName = pUploadSN[i] + "." + extend;
            
            if (useExtension.toLowerCase().indexOf(extend.toLowerCase()) == -1 && !useExtension.equals("*")) {           	
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
	@RequestMapping(value = "/ezSchedule/downloadAttach.do")
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
		
		String fullFilePath = realPath + uploadFilePath + filePath;

		downFile(request, response, fullFilePath, fileName);	
	}
    
	
	/**
	 * 일정작성 > 자원예약을 위한 반복일정 첫날 구하기
	 */
	@RequestMapping(value = "/ezSchedule/getFirstScheduleDate.do", produces = "text/plain; charset=utf-8")
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
	 * 일정작성 > icalendar import
	 */
	@RequestMapping(value = "/ezSchedule/icsImport.do", produces = "text/plain; charset=utf-8")
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
								
								//끝날짜 00시  설정
								dtEndCal.set(Calendar.HOUR_OF_DAY, 0);
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
								
								if (info[0].equals("0")) {
									dtEndCal.add(Calendar.DATE, 1); //종료일 있을 때에는 다음날로 설정
								}
								
								//시작시간 00시
								dtStartCal.set(Calendar.HOUR_OF_DAY, 0);
								
								//끝날짜 00시
								dtEndCal.set(Calendar.HOUR_OF_DAY, 0);
								
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
						null, null, null, null, null, defaultPath, loginVO.getTenantId(), loginVO.getCompanyID());
					
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
			e.printStackTrace();
		} catch(Exception e) {
			logger.debug("Error");
			e.printStackTrace();
		} finally {
			if (fin != null) { try { fin.close(); } catch (IOException e) {} }
		}
		
		model.addAttribute("result", result);
		
		logger.debug("icsImport end");
		return "/ezSchedule/scheduleImportComplete";
	}
	
	@RequestMapping(value = "/ezSchedule/scheduleDragSave.do")
	@ResponseBody
	public String scheduleDragSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO loginVO) throws Exception {
		logger.debug("scheduleDragSave started.");
		
		String returnValue = "0";
		
		loginVO = commonUtil.userInfo(loginCookie);
		String offset    = loginVO.getOffset();
		String companyId = loginVO.getCompanyID();
		int tenantId     = loginVO.getTenantId();
		
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		
		String offSetMin = commonUtil.getMinuteUTC(offset);
		String typeCal   = request.getParameter("typeCal");
		String dragId    = request.getParameter("dragId");
		String dragDay   = request.getParameter("dragDay");
		String dropDay   = request.getParameter("dropDay");
		
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
			String defaultPath  = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_schedule.ROOT", tenantId);
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
				ezScheduleService.copySchedule(dragId, utcStartTime, utcEndTime, defaultPath, offSetMin, tenantId, companyId);
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
				ezScheduleService.updateDragSchedule(dragId, loginVO.getId(), loginVO.getDisplayName1(), loginVO.getDisplayName2(), utcStartTime, utcEndTime, tenantId, companyId);
			}
		}
		
		returnValue = utcEndTime.substring(0, 10);
		
		logger.debug("scheduleDragSave ended.");
		return returnValue;
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
			e.printStackTrace();
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
			e.printStackTrace();
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
			e.printStackTrace();
		}
		
		return returnValue;
	}
	/**
	 * 일정 수정권한 구하는 함수
	 */
	private String getEditPosible(LoginVO loginVO, ScheduleInfoVO info, List<ScheduleSecretaryVO> tList)  {
		//참석자관련권한부여
		String _editPosible = "Y";
		String userId = loginVO.getId();
		String rollInfo = loginVO.getRollInfo();
		String ownerId = info.getOwnerId();
		String scheduleType = info.getScheduleType();
						
		if (!ownerId.equals(userId) && !info.getCreatorId().equals(userId) && !info.getModifierId().equals(userId)	 
			&& (!scheduleType.equals("2") || !ownerId.equals(loginVO.getDeptID()) || (rollInfo.indexOf("c=1") == -1 && rollInfo.indexOf("k=1") == -1 && rollInfo.indexOf("g=1") == -1))
			&& (!scheduleType.equals("3") && !scheduleType.equals("2") || (rollInfo.indexOf("c=1") == -1 && rollInfo.indexOf("k=1") == -1)) 
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
		}
		
		strHTML = strHTML.replace("replace_" + scheme, scheme);
		
		strHTML = commonUtil.cleanScriptValue(strHTML, "");
		
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
}
