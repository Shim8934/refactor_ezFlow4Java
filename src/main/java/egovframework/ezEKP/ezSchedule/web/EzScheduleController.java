package egovframework.ezEKP.ezSchedule.web;

import java.io.File;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezSchedule.lib.EzScheduleInfo;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.vo.AttachListVO;
import egovframework.ezEKP.ezSchedule.vo.AttendantListVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheCumulerVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheDeptVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheHqVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheSecVO;
import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleConfigVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 스케쥴
 * @author 오픈솔루션팀 지정석
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.05.19	지정석	신규작성
 *    2016.08.10	김경식	scheduleMain 추가
 *    2016.08.30	김경식	scheduleWrite 추가
 *
 * @see
 */

@Controller
public class EzScheduleController extends EgovFileMngUtil {
	private static final Logger logger = LoggerFactory.getLogger(EzScheduleController.class);

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="EzScheduleService")
	private EzScheduleService ezScheduleService;
	
	@Resource(name="EzResourceService")
	private EzResourceService ezResourceService;
	
	@Resource(name="EzScheduleInfo")
	private EzScheduleInfo ezScheduleInfo;
	
	@Resource(name="loginService")
	private LoginService loginService;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Autowired
	private EgovMessageSource msg;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	/**
	 * 일정관리 인덱스화면 호출함수
	 */
	@RequestMapping(value="/ezSchedule/scheduleIndex.do")
	public String  main(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		String	funCode = "";	// 업무관리 or 일정관리(3)
		String	subCode = "";
		
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
	public String  scheduleLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		String	funCode		= "";	// 일정관리 or 업무관리(3)
		String	subCode		= "";	// 아직 모름
		int	defaultView		= 2;	// 일간, 주간, 월간
		int	startDay		= 7;	// 일요일부터 또는 월요일부터
		
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

        LoginVO loginVO = commonUtil.userInfo(loginCookie);
        
		ScheduleConfigVO schConfVO = ezScheduleService.getScheduleConfig(loginVO.getId(), loginVO.getTenantId());
		
		if (schConfVO != null) {
			defaultView = schConfVO.getDefaultView();
			startDay = schConfVO.getStartDay();
		}
        
		model.addAttribute("funCode", funCode);
		model.addAttribute("subCode", subCode);
		model.addAttribute("defautView", defaultView);
		model.addAttribute("startDay", startDay);
		
		return "/ezSchedule/scheduleLeft";
	}
	
	/**
	 * 일정관리 휴일 함수 호출 함수
	 */
	@RequestMapping(value = "/ezSchedule/scheduleGetHoliday.do", produces = "text/html; charset=utf-8")
	@ResponseBody
	public String scheduleGetHoliday(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);		
		String cID = request.getParameter("COMPANYID");
		
		List<ScheGetHolidayVO> getHoliday = ezScheduleService.getTholiday(cID.trim(), userInfo.getCompanyID());
		
		String returnXML = "";
		
		for (int i=0; i<getHoliday.size(); i++ ) {
			returnXML += commonUtil.getQueryResult(getHoliday.get(i));
		}
		
		return "<DATA>" + returnXML + "</DATA>";
	}
	
	/**
	 * 일정관리 휴일 함수 호출 함수
	 */
	@RequestMapping(value = "/ezSchedule/scheduleGetList.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleGetList(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = userInfo.getId();
		String deptID = userInfo.getDeptID();
		String companyID = userInfo.getCompanyID();
		String startDate = request.getParameter("STARTDATE");
		String endDate = request.getParameter("ENDDATE");		
		String infoXML = "";	
		startDate = startDate + " 00:00:00";
		endDate = endDate + " 23:59:59";

		//String idList = request.getParameter("IDLIST");		
		//String groupID = request.getParameter("GROUPID");
		//String app = request.getParameter("APP");
		
		/* 도메인 및 메일과 관련된 공유 프로세스로 짐작됨. 일단 주석처리함 */
		/*String domainName = null;
        domainName = GetSystemConfigValue("DomainName");

        String personalid = null;
        String sharedeptid = null;
        String sharecompanyid = null;

        if (GetSystemConfigValue("LoginIDType") == "mail")
        {
            personalid = userinfo.Email;
            sharedeptid = "D" + userinfo.DeptID + "@" + domainName;
            sharecompanyid = "C" + userinfo.CompanyID + "@" + domainName;
        }
        else
        {
            personalid = userinfo.UserPrincipalName;
            sharedeptid = "D" + userinfo.DeptID + "@" + domainName;
            sharecompanyid = "C" + userinfo.CompanyID + "@" + domainName;
        }*/
		
		/* 구글 메일 연동관련 조건문. 일단 주석처리함 */
		/*if (idList != "GOOGLE") {
			
		} else {
			
		}*/
		
		infoXML = ezScheduleService.getScheduleList(startDate, endDate, userID, deptID, companyID);
		
		return infoXML;
	}

	/**
	 * 일정관리 메인화면 호출함수
	 */
	@RequestMapping(value="/ezSchedule/scheduleMain.do")
	public String  scheduleMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, Locale locale, LoginVO loginVO) throws Exception {
		int	receiveCount = 0;
		int groupCount = 0;
		int	defaultView = 0;
		int	startDay = 0;
		int	startTime = 0;
		int	endTime = 0;
		int	timeZone = 0;
		String	deptAdmin = "";
		String	companyAdmin = "";
		String	idList = "";
		String	idType = "T";        
		String	otherId = "";		
		String	secretaryXml = "";
        String	groupXml = "";
        String	groupXmlTemp = "";
		String	shareXml = "";        
        String	pOffset = "";        
        String	defaultTitle = "";
		
		loginVO = commonUtil.userInfo(loginCookie);
		String useEditor = ezCommonService.getTenantConfig("EDITOR", loginVO.getTenantId());
		String groupId = request.getParameter("groupid");
		
		if (groupId == null) {
			groupId = "";
		}

		List<PubScheHqVO> pubScheHqVO = ezScheduleService.getPublicScheduleHq(loginVO.getId());
		List<PubScheSecVO> pubScheSecVO = ezScheduleService.getPublicScheduleSec(loginVO.getId(), loginVO.getLang());
		List<PubScheDeptVO> pubScheDeptVO = ezScheduleService.getPublicScheduleDept(loginVO.getId(), loginVO.getLang());
		List<PubScheCumulerVO> pubScheCumulerVO = ezScheduleService.getPublicScheduleCumuler(loginVO.getId(), loginVO.getLang());

		//본부아이디        
		List<Map<String, Object>> hqList = new ArrayList<Map<String, Object>>();
        if (pubScheHqVO.size() > 0) {
            /* 20110406 표준에는 없는 기능이므로 일단 주석처리
            string _hqid = hq[0]["HQID"].ToString().Trim();
            LitHq.Text = string.Format("<option value=\"{0}\" >{1}</option>", "HQ", RM.GetString("t995"));
            userinfo.HqId = "D" + _hqid;
            userinfo.HqName = hq[0]["HQNAME"].ToString().Trim();
            userinfo.HqName2 = hq[0]["HQNAME2"].ToString().Trim();
             * */
        	// 원래 소스는 위처럼 주석처리되어 있지만 필요할 것 같아 다음과 같이 추가. 어쩌면 리스트일 수도
            Map<String, Object> hm = new HashMap<String, Object>();
            hm.put("value", pubScheHqVO.get(0).getHqId().trim());
            hm.put("text", pubScheHqVO.get(0).getHqName().trim());
            hqList.add(hm);
        }
 
        List<Map<String, Object>> shareList = new ArrayList<Map<String, Object>>();
        for (int i = 0; i < pubScheSecVO.size(); i++) {
        	Map<String, Object> hm = new HashMap<String, Object>();
            hm.put("value", pubScheSecVO.get(i).getSecId().trim());
            hm.put("type", "user");
            hm.put("text", pubScheSecVO.get(i).getSecName().trim());
            shareList.add(hm);
        }
       
        for (int i = 0; i < pubScheDeptVO.size(); i++) {
            Map<String, Object> hm = new HashMap<String, Object>();
            hm.put("value", pubScheDeptVO.get(i).getDeptId().trim());
            hm.put("type", "dept");
            hm.put("text", "[" + msg.getMessage("ezSchedule.t205", locale) + "]" + pubScheDeptVO.get(i).getDeptName().trim());
            shareList.add(hm);
        }

        for (int i = 0; i < pubScheCumulerVO.size(); i++) {
            Map<String, Object> hm = new HashMap<String, Object>();
            hm.put("value", pubScheCumulerVO.get(i).getDeptId().trim());
            hm.put("type", "dept");
            hm.put("text", "[" + msg.getMessage("ezSchedule.t996", locale) + "]" + pubScheCumulerVO.get(i).getTitleName().trim());
            shareList.add(hm);
        }
        
        if (loginVO.getRollInfo().contains("c=1") || loginVO.getRollInfo().contains("k=1")) {
            companyAdmin = "Y";
            deptAdmin = "Y";
        } else if (loginVO.getRollInfo().contains("g=1")) {
            deptAdmin = "Y";
        }

        receiveCount = GetReceiveCount_DB(loginVO.getId());        
        groupCount = GetInviteScheduleGroupCount(loginVO.getId());	// 일정 그룹 초대건수

        ScheduleConfigVO scheduleConfigVO = ezScheduleInfo.GetConfigInfo(loginVO.getId());	// 환경설정 정보            

        // 일정 환경설정 정보
        if (scheduleConfigVO != null) {
            defaultView	= scheduleConfigVO.getDefaultView();
            startDay	= scheduleConfigVO.getStartDay();
            startTime	= scheduleConfigVO.getStartTime();
            endTime		= scheduleConfigVO.getEndTime();

            switch (defaultView) {
	            case 0:
	                defaultTitle = msg.getMessage("ezSchedule.t140", locale);
	                break;
	            case 1:
	                defaultTitle = msg.getMessage("ezSchedule.t141", locale);
	            	break;
	            case 2:
	                defaultTitle = msg.getMessage("ezSchedule.t142", locale);
	            	break;
	           	default:
	                defaultTitle = msg.getMessage("ezSchedule.t142", locale);
	           		break;
            }
        } else {
            defaultView	= 2;
            startDay	= 7;
            startTime	= 540 / 60;
            endTime		= 1020 / 60;
        }

        List<ScheduleGroupListVO> groupList = ezScheduleService.getScheduleGroupList(loginVO.getId());
		groupXml = commonUtil.getQueryResult(groupList);	// 일정 그룹 목록
        groupXmlTemp = groupXml.replace("\"", "&quot;");
        otherId = request.getParameter("otherid");
        idType = request.getParameter("idtype");
        
        if (idType == null) {
        	idType = "";
        }
        
        if (otherId == null) {
        	otherId = "";
            idList = otherId;
        } else {
            switch (idType)
            {
                case "T":
                    idList = "T";
                    break;
                case "C":
                	idList = "C";
                    break;
                case "D":
                	idList = "D";
                    break;
                case "P":
                	idList = "P";
                    break;
                case "HQ":
                	idList = "HQ";
                    break;
                case "G":
                	idList = "G";
                    break;
                default:
                	idList = idType;
                    break;
            }
        }

        pOffset = loginVO.getOffset().split("\\|")[1];      
        timeZone = (Integer.parseInt(pOffset.split(":")[0]) * 60) + Integer.parseInt(pOffset.split(":")[1]);

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
        model.addAttribute("secretaryXml",	secretaryXml);
        model.addAttribute("groupXmlTemp",	groupXmlTemp);
        model.addAttribute("shareXml",		shareXml);
        model.addAttribute("idList",		idList);
        model.addAttribute("startTime",		startTime);
        model.addAttribute("endTime",		endTime);
        model.addAttribute("defaultView",	defaultView);
        model.addAttribute("startDay",		startDay);
        model.addAttribute("useEditor",		useEditor);
        model.addAttribute("defaultTitle",	defaultTitle);
        model.addAttribute("hqList",		hqList);
        model.addAttribute("shareList",		shareList);
        model.addAttribute("useExchange",	"");
        
		return "/ezSchedule/scheduleMain";
	}
	
	/**
	 * 일정그룹관리 메인화면
	 */
	@RequestMapping(value="/ezSchedule/scheduleManageGroup.do")
	public String scheduleManageGroup(@CookieValue("loginCookie") String loginCookie, Model model, LoginSimpleVO loginSimpleVO) throws Exception {
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
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		List<ScheduleGroupListVO> myList = ezScheduleService.getMyGroupList(loginSimpleVO.getId(), loginSimpleVO.getTenantId());
		
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
            
            int myMemberListCnt = ezScheduleService.getMyGroupMemberListCnt(data.getGroupId(), loginSimpleVO.getLang(), loginSimpleVO.getTenantId());
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
	public String getGroupDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginSimpleVO loginSimpleVO) throws Exception {
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		String gID = request.getParameter("groupID");
		String xmlResult = ezScheduleService.getMyGroupMemberList(gID, loginSimpleVO.getLang(), loginSimpleVO.getTenantId());
		
		return xmlResult;
	}
	
	/**
	 * 일정그룹관리 리스트 삭제
	 */
	@RequestMapping(value="/ezSchedule/scheduleDelGroup.do")	
	public void scheduleDelGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, LoginSimpleVO loginSimpleVO) throws Exception {
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
		loginVO = commonUtil.userInfo(loginCookie);
		String groupID = request.getParameter("groupID");
		String offSetMin = commonUtil.getMinuteUTC(loginVO.getOffset());

		List<ScheduleGroupListVO> mList = ezScheduleService.getGroupMemberList(groupID, loginVO.getTenantId(), offSetMin);
		
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
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		String groupID = request.getParameter("groupID");
		String status = request.getParameter("status");
		
		for (int i=0; i < member.length; i++) {			
			ezScheduleService.updateScheduleMember(groupID, member[i], status, loginSimpleVO.getTenantId());
		}
	}
	
	/**
	 * 일정작성
	 */
	@RequestMapping(value="/ezSchedule/scheduleWrite.do")
	public String scheduleWrite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, Locale locale, LoginVO loginVO) throws Exception {
	    String defaultId = "";
	    String otherId = "";
	    String userId = "";
	    String userName = "";
	    //07.06.27 multidata
	    String userName2 = "";
	    String scheduleId = "";
	    String dateType = "";
	    String startDate = "";
	    String endDate = "";
	    String repetition = "";
	    String repetitionDel = "";
	    String content = "";
	    String contentPath = "";
	    String scheduleType = "";
	    String importance = "";
	    String isPublic = "";
	    String changeKey = "";
	    String pattern = "";
	    String endDateString = "";
	    String startDateString = "";
	    String allDayString = "";
	    String recurringPattern = "";
	    String recurringLabelText = "";
	    String startDateStringOrgin = "";
	    String endDateStringOrgin = "";
	    String pageFrom = "";
	    String uploadSDate = "", uploadEDate = "", startDateTime = "", endDateTime = "";
	    String strIReFlagVal = "";

	    String strLabelOwner = "";
	    String strAttendant = "";
	    String strAttach = "";
	    String hasAttach = "NO";
	    
	    String ownerId = "";
	    String ownerName = "";
	    String ownerName2 = "";
	    	    
	    String attendantName = "";
	    String attendantEmail = "";
	    String useExchangePims = "";
	    String noneActiveX = "";
	    String companyAdmin = "";
	    String deptAdmin = "";
	    String editor = "";
        ScheduleInfoVO scheduleInfo = null;
        List<AttendantListVO> attendantList = null;
        List<AttachListVO> attachList = null;
        List<ScheduleGroupListVO> groupList = null;
        String pDirPath = config.getProperty("upload_schedule.ROOT");

		loginVO = commonUtil.userInfo(loginCookie);

        try
        {
            if (loginVO.getRollInfo().contains("c=1") || loginVO.getRollInfo().contains("k=1"))
            {
                companyAdmin = "Y";
                deptAdmin = "Y";
            }
            else if (loginVO.getRollInfo().contains("g=1"))
            {
                deptAdmin = "Y";
            }

            noneActiveX = config.getProperty("config.NONEACTIVEX");
            editor = config.getProperty("config.EDITOR");
            useExchangePims = config.getProperty("config.UseExchangePims");
            
            //본부일정
            //GetHQInfo();
            defaultId = request.getParameter("defaultid");
    		if (defaultId == null) defaultId = "";
             
    		scheduleId = request.getParameter("id");
    		if (scheduleId == null)
    			scheduleId = "";
    		else {
    			scheduleId.replace(' ', '+');
    			scheduleInfo = ezScheduleService.getScheduleInfo(scheduleId);
    		}
    		otherId = request.getParameter("otherid");
    		if (otherId == null) otherId = "";
             
    		pageFrom = request.getParameter("pageFrom");
    		if (pageFrom == null) pageFrom = "";
             
    		scheduleType = request.getParameter("type");
    		if (scheduleType == null) scheduleType = "";
             
    		pattern = request.getParameter("pattern");
    		if (pattern == null) pattern = "";
             
            userId = loginVO.getId();
            //07.06.27 multidata
            userName  = loginVO.getDisplayName1();
            userName2 = loginVO.getDisplayName2();
            //패스워드, 도메인 네임
            String domainName = ezCommonService.getTenantConfig("DomainName", loginVO.getTenantId());
            
            String personalId = null;
            String shareDeptId = null;
            String shareCompanyId = null;
            String loginId = config.getProperty("config.LoginIDType");

            // 가장(Impersonation)할 로그인 ID : Email 또는 ID
            if (loginId != null && loginId.equals("mail"))
            {
                personalId = loginVO.getEmail();
            }
            else
            {
                personalId = loginVO.getName();	// UserPrincipalName
            } 
            shareDeptId = "D" + loginVO.getDeptID() + "@" + domainName;
            shareCompanyId = "C" + loginVO.getCompanyID() + "@" + domainName;

            /**
            * ///////////////////////////////////////////////////////////////////
            */
            String impersonAddr = null;
    		List<PubScheHqVO> pubScheHqVO = ezScheduleService.getPublicScheduleHq(loginVO.getId());

            if (scheduleType.equals("1"))
            {
                impersonAddr = personalId;
            }
            else if (scheduleType.equals("2"))
            {
                impersonAddr = shareDeptId;
            }
            else if (scheduleType.equals("3"))
            {
                impersonAddr = shareCompanyId;
            }
            else if (scheduleType.equals("4") && pubScheHqVO.size() > 0)
            {
                impersonAddr = pubScheHqVO.get(0).getHqId().trim();
            }
            else if (scheduleType.equals("5"))
            {
                impersonAddr = otherId + "@" + domainName;
            }
            else if (scheduleType.equals("6"))
            {
                impersonAddr = otherId + "@" + domainName;
            }
            else
            {
                impersonAddr = personalId;
            }
            
            if (scheduleId != "")
            {
                if ((scheduleType.equals("1") || scheduleType.equals("6")) && useExchangePims.equals("YES"))
                {
                	// Exchange는 사용하지 않으므로 SKIP
                }
                else if (scheduleInfo != null)
                {
                    contentPath = pDirPath + scheduleInfo.getContentPath();
                    startDateStringOrgin	= scheduleInfo.getStartDate();
                    endDateStringOrgin		= scheduleInfo.getEndDate();
                    hasAttach = scheduleInfo.getHasAttach();
                    
                    String hasAttendant = scheduleInfo.getHasAttendant(); 
                    if (hasAttendant == "Y")
                    {
                        String parentId = scheduleInfo.getParentId();
                        if (parentId.equals("0"))
                        {
                        	parentId = scheduleId;
                        }
                        attendantList = ezScheduleService.getAttendantList(parentId);

                        for (AttendantListVO attendant : attendantList)
                        {
                        	String status;

                        	if (attendant.getStatus().equals("1")) {
                                status = "(" + msg.getMessage("ezSchedule.t251") + ")";
                        	} else if (attendant.getStatus().equals("2")) {
                                status = "(" + msg.getMessage("ezSchedule.t168") + ")";
                        	} else if (attendant.getStatus().equals("3")) {
                                status = "(" + msg.getMessage("ezSchedule.t169") + ")";
                        	} else {
                                status = "(" + msg.getMessage("ezSchedule.t166") + ")";
                        	}

							if (strAttendant != "") {
								strAttendant += ", ";
							}

                            // 07.06.27 multidata
                            // 08.04.14 다국어 primary 멀티데이터 적용
                            // Server.HtmlEncode(Name2) 처리를 어떻게 하나? (by kgs)
                            if (loginVO.getLocale().equals("1"))
                            {
                            	strAttendant += "<span title='" + msg.getMessage("ezSchedule.t162") + "' style='cursor:pointer' onclick=show_personinfo('" + 
                            			"${attendant.attendantId}" + "')>" +
                                		"${attendant.attendantName}" + "')>" + status + "</span>";
                            }
                            else
                            {
                            	strAttendant += "<span title='" + msg.getMessage("ezSchedule.t162") + "' style='cursor:pointer' onclick=show_personinfo('" + 
                            			"${attendant.attendantId}" + "')>" + "')>" +
                                		"${attendant.attendantName2}" + "')>" + status + "</span>";
                            }
                        }
                        
                    }
                    
                    if (hasAttach == "Y")
                    {
                    	attachList = ezScheduleService.getAttachList(scheduleId);
                        //LiteralAttach.Text = "";
                        //infoXML = GetAttachList(loginid, loginpwd, domainName, casname, personalid, sharedeptid, sharecompanyid, _scheduleid, _scheduletype);
                        //xmldom = GetXmlReaderString(infoXML);
                        strAttach = "<ROOT><NODES>";
                        for (AttachListVO attach : attachList)
                        {
                            strAttach += "<DATA><![CDATA[" + commonUtil.cleanPropertyValue(attach.getFilePath() + "/" + attach.getFileName() + "/" + attach.getFileSize() + "/ExistsImage") + "]]></DATA>";
                            strAttach += "<DATA2><![CDATA[" + attach.getAttachId() + "]]></DATA2>";
                            strAttach += "<DATA3><![CDATA[OK]]></DATA3>";
                        }
                        strAttach += "</NODES></ROOT>";

                		// changeKey는 Exchange 일정인 경우에만 있으므로 생략
                    }
                    
                    // 08.04.14 primary 값에 따라 가져오도록 수정함
                    int primary = loginVO.getPrimary().equals("1") ? 1 : 2;
                    
                    if (scheduleType.equals("1") || scheduleType.equals("6"))
                    {
                        strLabelOwner = msg.getMessage("ezSchedule.t372");
                        strLabelOwner += primary == 1 ? scheduleInfo.getOwnerName() : scheduleInfo.getOwnerName2();
                    }
                    else if (scheduleType.equals("2"))
                    {
                        strLabelOwner = msg.getMessage("ezSchedule.t373");
                        strLabelOwner += primary == 1 ? loginVO.getDeptName1() : loginVO.getDeptName2();
                    }
                    else if (scheduleType.equals("3"))
                    {
                        strLabelOwner = msg.getMessage("ezSchedule.t374");
                        strLabelOwner += primary == 1 ? loginVO.getCompanyName1() : loginVO.getCompanyName2();
                    }
                    else if (scheduleType.equals("4"))
                    {
                        impersonAddr = pubScheHqVO.get(0).getHqId().trim();
                        strLabelOwner = msg.getMessage("ezSchedule.t995");
                        strLabelOwner += primary == 1 ? pubScheHqVO.get(0).getHqName() : pubScheHqVO.get(0).getHqName2();
                    }
                    else if (scheduleType.equals("7"))
                    {
                        strLabelOwner = msg.getMessage("ezSchedule.t375");
                        strLabelOwner += primary == 1 ? scheduleInfo.getOwnerName() : scheduleInfo.getOwnerName2();
                    }
                    
                    ownerId			= scheduleInfo.getOwnerId();
                    ownerName		= scheduleInfo.getOwnerName();
                    ownerName2		= scheduleInfo.getOwnerName2();
                    repetition		= scheduleInfo.getRepetition();
                    repetitionDel	= scheduleInfo.getRepetitionDel();
                    isPublic		= scheduleInfo.getIsPublic();
                    importance		= scheduleInfo.getImportance();
                }
            }
            // scheduleId == null
            else {
                groupList = ezScheduleService.getScheduleGroupList(loginVO.getId());
            }
            
			String cDate = "";
			String cTime = "";
			
			dateType = request.getParameter("datetype");
			if (dateType == null) dateType = "";

			startDateTime = request.getParameter("sdate");
			if (startDateTime == null)
			{
				cDate = ezResourceService.getLocalTime(EgovDateUtil.getToday("time"));
				cTime = cDate.split(" ")[1].substring(0, 2);
				
				if (request.getParameter("startDate") != null) {
					cDate = request.getParameter("startDate");
				}
				cDate = cDate.substring(0, 10);

				uploadSDate = getUploadDate(cDate, cTime, true, locale);
			} else {
				uploadSDate = ezResourceService.isoUTFDate(startDateTime, locale);
			}

			endDateTime = request.getParameter("edate");
			if (endDateTime == null)
			{
				cDate = ezResourceService.getLocalTime(EgovDateUtil.getToday("time"));
				cTime = cDate.split(" ")[1].substring(0, 2);
				
				if (request.getParameter("endDate") != null) {
					cDate = request.getParameter("endDate");
				}
				cDate = cDate.substring(0, 10);

				uploadEDate = getUploadDate(cDate, cTime, false, locale);
			} else {
				uploadEDate = ezResourceService.isoUTFDate(endDateTime, locale);
			}

			model.addAttribute("userInfo",		loginVO);
            model.addAttribute("scheduleInfo",	scheduleInfo);
            model.addAttribute("attendantList",	attendantList);
            model.addAttribute("groupList",		groupList);

            model.addAttribute("scheduleId",	scheduleId);
            model.addAttribute("scheduleType",	scheduleType);
            model.addAttribute("hasAttach",		hasAttach);
            model.addAttribute("strAttach",		strAttach);
            model.addAttribute("strAttendant",	strAttendant);
            model.addAttribute("uploadSDate",	uploadSDate);
            model.addAttribute("uploadEDate",	uploadEDate);
            

            model.addAttribute("content",		content);
            model.addAttribute("contentPath",	contentPath);
            model.addAttribute("isPublic",		isPublic);
            model.addAttribute("importance",	importance);
            model.addAttribute("repetition",	repetition);
            model.addAttribute("repetitionDel",	repetitionDel);
            model.addAttribute("changeKey",		changeKey);
            model.addAttribute("pattern",		pattern);

            model.addAttribute("otherId",		otherId);
            model.addAttribute("dateType",		dateType);
            model.addAttribute("startDate",		startDate);
            model.addAttribute("endDate",		endDate);
            model.addAttribute("recurringLabelText",	recurringLabelText);
            model.addAttribute("startDateStringOrgin",	startDateStringOrgin);
            model.addAttribute("endDateStringOrgin",	endDateStringOrgin);
            model.addAttribute("pageFrom",		pageFrom);
            model.addAttribute("attendantName",	attendantName);
            model.addAttribute("attendantEmail",attendantEmail);
            model.addAttribute("useExchangePims",useExchangePims);
            model.addAttribute("noneActiveX",	noneActiveX);
            model.addAttribute("companyAdmin",	companyAdmin);
            model.addAttribute("deptAdmin",		deptAdmin);

		}
        catch (Exception e)
        {
        	e.printStackTrace();
//            WriteTextLog("schedulewriteCK", "PageLoad", Ex.toString());
        }
            
   		return "/ezSchedule/scheduleWrite";
	}
	
	/**
	 * 일정관리 Schedule 저장 호출 Method
	 */
	@RequestMapping(value = "/ezSchedule/scheduleSave.do")
	public String scheduleSave(@CookieValue("loginCookie") String loginCookie, @RequestBody String requestXML, HttpServletRequest request, HttpServletResponse response, Model model, LoginVO loginVO) throws Exception {
        String _domainname = null;
        String pageFrom = "";
        String _pattern;
        List<String> inlineimage = new ArrayList<String>();
        List<String> inlineContent = new ArrayList<String>();

        try {
			loginVO = commonUtil.userInfo(loginCookie);
			
			model.addAttribute("userInfo", loginVO);
	
	        pageFrom = request.getParameter("pageFrom");
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
	        String schenddate	= doc.getElementsByTagName("ENDORGINDATE").item(0).getTextContent();	//?
	        String otherid		= doc.getElementsByTagName("OTHERID").item(0).getTextContent();

	        if (scheduleid != "")
	        {
	            _pattern = doc.getElementsByTagName("PATTERN").item(0).getTextContent();
	        }
	        else
	        {
	        	scheduleid = "" + ezScheduleService.getNewScheduleId();
	        }
	        String pattern = "";
	
	        String startdate	= doc.getElementsByTagName("STARTDATE").item(0).getTextContent();
	        String enddate		= doc.getElementsByTagName("ENDDATE").item(0).getTextContent();
	        String repetition	= doc.getElementsByTagName("REPETITION").item(0).getTextContent();
	        String title		= doc.getElementsByTagName("TITLE").item(0).getTextContent();
	        String location		= doc.getElementsByTagName("LOCATION").item(0).getTextContent();
	        String content		= doc.getElementsByTagName("CONTENT").item(0).getTextContent();
	        String attachxml	= doc.getElementsByTagName("ATTACHLIST").item(0).getTextContent();
	        String attendantxml	= doc.getElementsByTagName("ATTENDANTLIST").item(0).getTextContent();
	        String changekey	= doc.getElementsByTagName("CHANGEKEY").item(0).getTextContent();
	        String contentPath	= doc.getElementsByTagName("CONTENTPATH").item(0).getTextContent();
	        
	        // repetition should be "". not " ". But "" is treated as null.
	        if (repetition == null || repetition.equals("")) repetition = "R";
	        
	        // Test 필요
	        String hasattach	= attachxml.length() > 0 ? "Y" : "N";
	        String hasattendant	= attendantxml.length() > 0 ? "Y" : "N"; 
	        String hascomment	= "N";	//?
	        String isreadonly	= "N";	//?
	        String repetitiondel= "N";	//?
	        String groupname	= "";	//?

	        if (pattern == "0")
	        {
	            repetition = "R";
	        }
	
	        String domainName = null;
	        domainName = config.getProperty("DomainName");
	
	        _domainname = domainName;
	        String personalid = null;
	        String sharedeptid = null;
	        String sharecompanyid = null;
	
	        if (config.getProperty("LoginIDType") == "mail")
	        {
	            personalid = loginVO.getEmail(); 
	        }
	        else
	        {
	            personalid = loginVO.getEmail();	// UPNName
	        }
            sharedeptid = "D" + loginVO.getDeptID() + "@" + domainName;
            sharecompanyid = "C" + loginVO.getCompanyID() + "@" + domainName;
    		List<PubScheHqVO> pubScheHqVO = ezScheduleService.getPublicScheduleHq(loginVO.getId());
	
	        String impersonaddr = null;
	        switch (scheduletype)
	        {
	            case "1":
	                impersonaddr = personalid;
	                break;
	            case "2":
	                impersonaddr = sharedeptid;
	                break;
	            case "3":
	                impersonaddr = sharecompanyid;
	                break;
	            case "4":
	                impersonaddr = pubScheHqVO.get(0).getHqId();
	                break;
	            case "5":
	            case "6":
	                impersonaddr = otherid + "@" + domainName;
	                break;
	            case "8":
	                impersonaddr = otherid;
	                break;
	            default:
	                impersonaddr = personalid;
	                break;
	        }
	        
            String pDirPath = config.getProperty("upload_schedule.ROOT");
	        String contentpath = doc.getElementsByTagName("CONTENTPATH").item(0).getTextContent(); 
	        String pContentPath;
	        if (contentpath == "") {
	        	pContentPath = pDirPath + commonUtil.separator + scheduleid;
	        }
	        else
	        {
	        	pContentPath = contentpath;
	        }

	        // 일정 저장 또는 업데이트
			ScheduleInfoVO schInfoVO = new ScheduleInfoVO();
			schInfoVO.setScheduleId(scheduleid);
			schInfoVO.setParentId("0");
			schInfoVO.setOwnerId(ownerid);
			schInfoVO.setOwnerName(ownername);
			schInfoVO.setOwnerName2(ownername2);
			schInfoVO.setCreatorId(creatorid);
			schInfoVO.setCreatorName(creatorname);
			schInfoVO.setCreatorName2(creatorname2);
			schInfoVO.setCreateDate("");	// Now
			schInfoVO.setModifierId(creatorid);
			schInfoVO.setModifierName(creatorname);
			schInfoVO.setModifierName2(creatorname2);
			schInfoVO.setModifyDate("");	// Now
			schInfoVO.setScheduleType(scheduletype);
			schInfoVO.setImportance(importance);
			schInfoVO.setHasAttendant(hasattendant);
			schInfoVO.setHasAttach(hasattach);
			schInfoVO.setHasComment(hascomment);
			schInfoVO.setIsReadOnly(isreadonly);
			schInfoVO.setIsPublic(ispublic);
			schInfoVO.setDateType(datetype);
			schInfoVO.setStartDate(startdate);
			schInfoVO.setEndDate(enddate);
			schInfoVO.setRepetition(repetition);
			schInfoVO.setRepetitionDel(repetitiondel);
			schInfoVO.setTitle(title);
			schInfoVO.setLocation(location);
			schInfoVO.setContentPath(pContentPath);
			schInfoVO.setGroupName(groupname);

//	        // 첨부 파일 업로드
//	        if (doc.getElementsByTagName("IMAGENAME").getLength() > 0)
//	        {
//	        	NodeList pImageNameNode = doc.getElementsByTagName("IMAGENAME");
//	            if (pImageNameNode != null)
//	            {
//	                for (int i = 0; i < pImageNameNode.getLength(); i++)
//	                {
//	                    if (pImageNameNode.item(i).getTextContent().trim() != "")
//	                    {
//	                        inlineimage.add(pImageNameNode.item(i).getTextContent().trim());
//	                    }
//	                }
//	            }
//	        	NodeList pImageContentNode = doc.getElementsByTagName("IMAGECONTENT");
//	            if (pImageContentNode != null)
//	            {
//	                for (int i = 0; i < pImageContentNode.getLength(); i++)
//	                {
//	                    if (pImageContentNode.item(i).getTextContent().trim() != "")
//	                    {
//	                        inlineContent.add(pImageContentNode.item(i).getTextContent().trim());
//	                    }
//	                }
//	            }
//	        }
//	        

//			if (pMode.equals("modify")) {
//				ezBoardService.brdUpdateItem(boardListVO, "BOARD");
//			} else if (pMode.equals("temp")) {
//				ezBoardService.brdNewItemTemp(boardListVO);
//			} else {
				ezScheduleService.scheduleNewItem(schInfoVO);
//			}
			
//			if (scheduleid == "")
//                result = InsertSchedule_DB(ownerid, ownername, ownername2, creatorid, creatorname, creatorname2, scheduletype, importance, ispublic, datetype, startdate, enddate, repetition, title, location, content, attachxml, attendantxml, contentpath);
//            else
//                result = UpdateSchedule_DB(scheduleid, creatorid, creatorname, creatorname2, importance, ispublic, datetype, startdate, enddate, repetition, title, location, content, attachxml, contentpath);
//
//            if(!result.equals(""))
//                response.write("OK_"+result);
//            else
//                response.write(result);
	        
	    }
	    catch (Exception Ex)
	    {
	        Ex.printStackTrace();;
	    }
		
		return "ezSchedule/scheduleSave";
	}

//	// 일정 저장
//    public String InsertSchedule_DB(String pOwnerID, String pOwnerName, String pOwnerName2, String pCreatorID, String pCreatorName, String pCreatorName2,
//            String pScheduleType, String pImportance, String pIsPublic, String pDateType,
//            String pStartDate, String pEndDate, String pRepetition, String pTitle, String pLocation, String pContent, String pAttachXML,
//            String pAttendantXML, String pContentPath)
//    {
//        try
//        {
//            // 일정 본문을 파일로 저장한다.
//            String path = "Doc/" + Guid.NewGuid().ToString().ToUpper() + ".mht";
//            StreamWriter writer = new StreamWriter(pContentPath + System.IO.Path.DirectorySeparatorChar.ToString() + path.Replace("/", "\\"), false, System.Text.Encoding.Default);
//            writer.Write(pContent);
//            writer.Close();
//
//            XmlDocument xmldom = new XmlDocument();
//            xmldom = GetXmlReaderString(pAttachXML);
//
//            //String conStr = GetSystemConfigValue("ezPims");
//
//            StringBuilder attachsql = new StringBuilder();
//            for (int i = 0; i < xmldom.GetElementsByTagName("ATTACH").Count; i++)
//            {
//                String filename = xmldom.GetElementsByTagName("ATTACH")[i].InnerText.Split('/')[1];
//                String filepath = xmldom.GetElementsByTagName("ATTACH")[i].InnerText.Split('/')[0];
//                String filesize = xmldom.GetElementsByTagName("ATTACH")[i].InnerText.Split('/')[2];
//
//				attachsql += "INSERT INTO TBLSCHEDULEATTACH(AttachID, ScheduleID, FileName, FilePath, FileSize) VALUES(SEQ_INC_TBLSCHEDULEATTACH.NEXTVAL, seq_inc_TBLSCHEDULE.CURRVAL, '" + 
//				MakeRightField(filename) + "','" + MakeRightField(filepath) + "', " + filesize + ");";
//            }
//
//            xmldom = GetXmlReaderString(pAttendantXML);
//
//            StringBuilder attendantsql = new StringBuilder();
//            for (int i = 0; i < xmldom.GetElementsByTagName("ATTENDANTID").Count; i++)
//            {
//                String attendantid = xmldom.GetElementsByTagName("ATTENDANTID")[i].InnerText;
//                String attendantname = xmldom.GetElementsByTagName("ATTENDANTNAME1")[i].InnerText;
//                String attendantname2 = xmldom.GetElementsByTagName("ATTENDANTNAME2")[i].InnerText;
//                String attendantdeptname = xmldom.GetElementsByTagName("ATTENDANTDEPTNAME")[i].InnerText;
//                String attendantdeptname2 = xmldom.GetElementsByTagName("ATTENDANTDEPTNAME2")[i].InnerText;
//
//				attendantsql.append("INSERT INTO TBLATTENDANT(ScheduleID,AttendantID,AttendantName,AttendantDeptName,Status,ResponseDate) VALUES(seq_inc_TBLSCHEDULE.CURRVAL, '" + 
//				MakeRightField(attendantid) + "','" + MakeRightField(attendantname) + "','" + MakeRightField(attendantdeptname) + "',0,sysdate);)";
//            }                
//            pTitle = LeftByte(pTitle, 250);
//            pLocation = LeftByte(pLocation, 250);
//            pCreatorName = LeftByte(pCreatorName, 50);
//            pCreatorName2 = LeftByte(pCreatorName2, 50);
//
//            string hasattach = "N";
//            if (attachsql.Length > 0) hasattach = "Y";
//
//            string hasattendant = "N";
//            if (attendantsql.Length > 0) hasattendant = "Y";
//
//            StringBuilder sql = new StringBuilder();
//			sql.append(  "INSERT INTO TBLSCHEDULE(ScheduleID,ParentID,OwnerID,OwnerName,CreatorID,CreatorName,CreateDate,ModifierID,ModifierName,");
//			sql.append( "ModifyDate,ScheduleType,Importance,HasAttendant,HasAttach,HasComment,IsReadOnly,IsPublic,DateType,StartDate,");
//			sql.append( "EndDate,Repetition,RepetitionDelete,Title,Location,ContentPath) VALUES(seq_inc_TBLSCHEDULE.NEXTVAL,0,'" + MakeRightField(pOwnerID) );
//            sql.append( "','" + MakeRightField(pOwnerName) + "','" + MakeRightField(pCreatorID) + "','" );
//            sql.append( MakeRightField(pCreatorName) + "',sysdate,'" + MakeRightField(pCreatorID) + "','" + MakeRightField(pCreatorName) + "'," );
//			sql.append( "sysdate," + pScheduleType + "," + pImportance + ",'" + hasattendant + "','" + hasattach + "','N','N','" );
//			sql.append( pIsPublic + "'," + pDateType + ",to_date('" + pStartDate + "','yyyy-mm-dd hh24:mi'),to_date('" + pEndDate + "','yyyy-mm-dd hh24:mi'),'" + pRepetition);
//            sql.append( "','','" + MakeRightField(pTitle) + "','" +	MakeRightField(pLocation) + "','" + path + "');");
//            sql.append(attachsql.ToString() + attendantsql.ToString());
//
//            return GetSingleQueryResult("ezPims", sql.ToString());
//        }
//        catch (Exception Ex)
//        {
//            WriteTextLog("schedule_save", "InsertSchedule_DB", Ex.ToString());
//            return Ex.Message;
//        }
//    }
//
//    // 일정 업데이트
//    public String UpdateSchedule_DB(String pScheduleID, String pModifierID, String pModifierName, String pModifierName2,
//        String pImportance, String pIsPublic, String pDateType,
//        String pStartDate, String pEndDate, String pRepetition, String pTitle, String pLocation, String pContent, String pAttachXML,
//        String pContentPath)
//    {
//        try
//        {
//            // 일정 본문을 파일로 저장한다.
//            StreamWriter writer = new StreamWriter(pContentPath, false, System.Text.Encoding.Default);
//            writer.Write(pContent);
//            writer.Close();
//
//            XmlDocument xmldom = new XmlDocument();
//            xmldom = GetXmlReaderString(pAttachXML);
//
//            StringBuilder attachsql = new StringBuilder();
//
//            for (int i = 0; i < xmldom.GetElementsByTagName("ATTACH").Count; i++)
//            {
//                String filename = xmldom.GetElementsByTagName("ATTACH")[i].InnerText.Split('/')[1];
//                String filepath = xmldom.GetElementsByTagName("ATTACH")[i].InnerText.Split('/')[0];
//                String filesize = xmldom.GetElementsByTagName("ATTACH")[i].InnerText.Split('/')[2];
//				attachsql.append("INSERT INTO TBLSCHEDULEATTACH(AttachID, ScheduleID, FileName, FilePath, FileSize) VALUES(SEQ_INC_TBLSCHEDULEATTACH.NEXTVAL,");
//                attachsql.append( pScheduleID + ", '" +MakeRightField(filename) + "','" + MakeRightField(filepath) + "', " + filesize + ") ;");
//            }
//            pTitle = LeftByte(pTitle, 250);
//            pLocation = LeftByte(pLocation, 250);
//            pModifierName = LeftByte(pModifierName, 50);
//            pModifierName2 = LeftByte(pModifierName2, 50);                
//
//            String hasattach = "N";
//            if (attachsql.Length > 0) hasattach = "Y";
//            StringBuilder sql = new StringBuilder();
//            sql.append("UPDATE TBLSCHEDULE SET ModifierID='" + MakeRightField(pModifierID) + "',ModifierName=N'" + MakeRightField(pModifierName) + "'," + "ModifierName2=N'" + MakeRightField(pModifierName2) + "',");
//            sql.append("ModifyDate=sysdate,Importance=" + pImportance + ",HasAttach='" + hasattach + "',IsPublic='" + pIsPublic + "',DateType=" + pDateType + "," );
//			sql.append("StartDate=to_date('" + pStartDate + "','yyyy-mm-dd hh24:mi:ss'),EndDate=to_date('" + pEndDate + "','yyyy-mm-dd hh24:mi'),Repetition='" + pRepetition + "',Title='" + MakeRightField(pTitle) + "',Location='" + MakeRightField(pLocation) + "' " );
//            sql.append("WHERE ScheduleID=" + pScheduleID + " OR ParentID=" + pScheduleID + " ;");
//            sql.append("DELETE FROM TBLSCHEDULEATTACH WHERE ScheduleID=" + pScheduleID + " ;");
//
//            sql.append(attachsql.ToString());
//
//            return ExecuteSQL("ezPims", sql.ToString());
//        }
//        catch (Exception Ex)
//        {
//            WriteTextLog("schedule_save", "UpdateSchedule_DB", Ex.ToString());
//            return Ex.Message;
//        }
//    }
	
	/**
	 * 일정 첨부파일저장 실행 Method
	 */
	public boolean saveAttachmentsInfo(String strAttachments, String strItemID, String strBoardID, String strFilePath, String strType, String realPath) throws Exception{
        long fileSize = 0;
        String filePath = "";
        String filePath2 = "";
        String fileName = "";
        String[] temp = null;
        
        if (!strAttachments.substring(strAttachments.length() - 1).equals(";")) {
        	strAttachments += ";";
        }
        for (int i = 0; i < strAttachments.split(";").length; i++) {
            if (strType.equals("BOARD")) {
            	
            	if (strAttachments.split(";")[i].indexOf("upload_board") > -1) {
            		filePath = strAttachments.split(";")[i];
            	} else {
            		filePath = strFilePath + commonUtil.separator + strAttachments.split(";")[i];
            	}
                File file = new File(realPath + filePath);
                fileSize = file.length();
                
                if (strAttachments.split(";")[i].indexOf("tempUploadFile") > -1) {
                    filePath2 = strFilePath + commonUtil.separator + strBoardID + commonUtil.separator + "uploadFile" + strAttachments.split(";")[i].replace("tempUploadFile", "");
                    File fileinfo = new File(realPath + filePath2);
                    if (!fileinfo.exists()) {
                    	FileUtils.moveFile(file, fileinfo);
                    }
                } else if (strAttachments.split(";")[i].indexOf("upload_board") > -1) {
                	filePath2 = strAttachments.split(";")[i];
                } else {
                	filePath2 = strFilePath + commonUtil.separator + strAttachments.split(";")[i];
                }
                file = null;
            }
            else{
                File file = new File(realPath + config.getProperty("upload_board.TEMPUPLOADFILE") + commonUtil.separator + strAttachments.split(";")[i].split("/")[2]);
                fileSize = file.length();
                
                filePath2 = strFilePath + commonUtil.separator + strBoardID + commonUtil.separator + "uploadFile" + commonUtil.separator + strAttachments.split(";")[i].split("/")[2];
                	
                File fileinfo = new File(realPath + filePath2);
                if (!fileinfo.exists())
                	FileUtils.moveFile(file, fileinfo);
                file = null;
            }
            temp = strAttachments.split(";")[i].split("}_");
            for (int j = 1; j < temp.length; j++) {
                if (j == 1) {
                	fileName = temp[j];
                }
            }
            
//            ezBoardService.saveAttachInfo(strItemID, filePath2, fileSize, fileName);
            temp = null;
        }
        return true;
	}
	
	
	/**
	 * 일정관리 checkName 호출 Method
	 */
	@RequestMapping(value = "/ezSchedule/checkName.do")
	public String checkName(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		
		return "ezSchedule/checkName";
	}
	
	/**
	 * 일정관리 draganddrop 호출 Method
	 */
	@RequestMapping(value = "/ezSchedule/scheduleDragAndDrop.do")
	public String scheduleDragAndDrop(@CookieValue("loginCookie") String loginCookie, Model model, LoginVO loginVO) throws Exception {

        loginVO = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", loginVO);
		
		return "ezSchedule/scheduleDragAndDrop";
	}
	
	/**
	 * 일정관리 참석자 선택 호출 Method
	 */
	@RequestMapping(value = "/ezSchedule/scheduleSelectAttendant.do")
	public String scheduleSelectAttendant(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO loginVO) throws Exception {
        String _title = "";
        String _starttime = "";
        String _endtime = "";
        String _gubun = "";
        String _type = "";
        String _USE_OCS = "";
        String _pSearchString = "";

        loginVO = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", loginVO);
		
        try
        {
    		_title = request.getParameter("title");
    		if (_title == null) _title = "";
    		
            _starttime = request.getParameter("StartTime");
    		if (_starttime == null) _starttime = "";
    		
    		_endtime = request.getParameter("EndTime");
    		if (_endtime == null) _endtime = "";
    		
    		_gubun = request.getParameter("gubun");
    		if (_gubun == null) _gubun = "";
    		
    		_type = request.getParameter("type");
    		if (_type == null) _type = "";
    		
            _USE_OCS = config.getProperty("USE_OCS");

            _pSearchString = request.getParameter("SearchString");
    		if (_pSearchString == null) _pSearchString = "";
        }
        catch (Exception e)
        {
        	e.printStackTrace();
        }
		
		return "ezSchedule/scheduleSelectAttendant";
	}
	
	/**
	 * 스케쥴 첨부  Method
	 */
	@RequestMapping(value = "/ezSchedule/uploadScheduleAttach.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String uploadScheduleAttach(MultipartHttpServletRequest request) throws Exception{
		List<MultipartFile> multiFile = request.getFiles("fileToUpload"); 
		int cnt = multiFile.size();
		String realPath = request.getServletContext().getRealPath("");
		String[] pFileName = new String[cnt];
        Long[] fileSize = new Long[cnt];
        String[] fileLocation = new String[cnt];
        String[] resultUpload = new String[cnt];
        String[] sGUID = new String[cnt];
        String[] pUploadSN = new String[cnt];

        String useExtension = config.getProperty("config.USE_FileExtension");
        for (int i = 0; i < cnt; i++) {
            resultUpload[i] = "false";
            sGUID[i] = UUID.randomUUID().toString();
            pUploadSN[i] = "{" + sGUID[i] + "}";
        }

        int maxSize = 0;
        String pBoardID = "";
        String pMode = "";
        maxSize = Integer.parseInt(request.getParameter("maxSize"));
        pBoardID = request.getParameter("boardID");
        pMode = request.getParameter("mode");

        if (StringUtils.isNotEmpty(multiFile.get(0).getOriginalFilename()) && StringUtils.isNotBlank(multiFile.get(0).getOriginalFilename())) {
            for (int i = 0; i < cnt; i++) {
                String _pFileName = multiFile.get(i).getOriginalFilename();
                if (_pFileName.indexOf(commonUtil.separator) > 0) {
                    _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
                }
                pFileName[i] = _pFileName;
            }
        }

        for (int i = 0; i < cnt; i++) {
            pFileName[i] = pFileName[i].replace("+", "%2b");
            pFileName[i] = pFileName[i].replace(";", "%3b");
        }

        String pDirPath = config.getProperty("upload_schedule.ROOT");
        pDirPath = realPath + pDirPath;
        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
        File file = new File(pDirPath);
        File file2 = new File(pDirPath + pBoardID + commonUtil.separator + "uploadFile");
        if (!file.exists()) {
        	file.mkdir();
        	file2.mkdir();
        }

        StringBuffer strXML = new StringBuffer();
        strXML.append("<ROOT><NODES>");
        
        for (int i = 0; i < cnt; i++) {
        	fileSize[i] = multiFile.get(i).getSize();

            if (fileSize[i] > maxSize) {
                resultUpload[i] = "overflow";
            } else {
                if (!pMode.equals("ATT")) {
                	continue;
                }
                
                if (useExtension.toLowerCase().indexOf(pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1).toString().toLowerCase()) == -1 && !useExtension.equals("*")) {
                    resultUpload[i] = "denied";

                    strXML.append("<RESULTUPLOADA><![CDATA[" + resultUpload[i] + "]]></RESULTUPLOADA>");
                    strXML.append("<PFILENAME><![CDATA[" + pFileName[i] + "]]></PFILENAME>");
                    strXML.append("<FILESIZE>" + fileSize[i] + "</FILESIZE>");
                    strXML.append("<FILELOCATION><![CDATA[" + "" + "]]></FILELOCATION>");
                } else {
                    String pAttachPath = realPath + config.getProperty("upload_schedule.TEMPUPLOADFILE") + commonUtil.separator;
                    File fTemp = new File(pAttachPath);
                    if (!file.exists()) {
                    	fTemp.mkdir();
                    }
                    writeUploadedFile(multiFile.get(i), pUploadSN[i] + "_" + pFileName[i], pAttachPath);
                    fileLocation[i] = pAttachPath + pUploadSN[i] + "_" + pFileName[i];
                    resultUpload[i] = "OK";

                    strXML.append("<RESULTUPLOADA><![CDATA[" + resultUpload[i] + "]]></RESULTUPLOADA>");
                    strXML.append("<PFILENAME><![CDATA[" + pFileName[i] + "]]></PFILENAME>");
                    strXML.append("<FILESIZE>" + fileSize[i] + "</FILESIZE>");
                    strXML.append("<FILELOCATION><![CDATA[" + fileLocation[i] + "]]></FILELOCATION>");
                }
            }
        }
        strXML.append("</NODES></ROOT>");
        
        return strXML.toString();
    }	

    public int GetReceiveCount_DB(String pUserId)
    {
    	try {
			int count = ezScheduleService.getReceiveCount(pUserId);
	        
	        return count;
    	} catch (Exception e) {
    		e.printStackTrace();
    		return 0;
    	}
    }

    public int GetInviteScheduleGroupCount(String pUserId)
    {
    	try {
			int count = ezScheduleService.getInviteScheduleGroupCnt(pUserId);
	        
	        return count;
    	} catch (Exception e) {
    		e.printStackTrace();
    		return 0;
    	}
    }
    
    private String getUploadDate(String cDate, String cTime, boolean isStart, Locale locale)
    {
		String uploadDate = cDate + " " + cTime + ":00:00";
		
		cDate = cDate.substring(0, 10);
		if (LocalDateTime.now().getMinute() < 30) {
			if (isStart) {
				uploadDate = cDate + " " + cTime + ":00:00";
			} else {
				uploadDate = cDate + " " + cTime + ":00:30";
			}
		} else {
			if (isStart) {
				uploadDate = cDate + " " + cTime + ":00:30";
			} else {
				uploadDate = cDate + " " + cTime + ":00:00";
			}
		}

		System.err.println("uploadDate: " + uploadDate);
		return ezResourceService.isoUTFDate(uploadDate, locale);
    }
}
