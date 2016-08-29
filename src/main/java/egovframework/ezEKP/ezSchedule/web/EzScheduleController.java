package egovframework.ezEKP.ezSchedule.web;

import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezSchedule.lib.EzScheduleInfo;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.vo.PubScheCumulerVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheDeptVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheHqVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheSecVO;
import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleConfigVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGmailInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.UserLocalInfoVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
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
 *
 * @see
 */

@Controller
public class EzScheduleController extends EgovFileMngUtil {
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="EzScheduleService")
	private EzScheduleService ezScheduleService;
	
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
    		System.out.println("funCode: " + funCode);
        } else {
        	System.out.println("funCode: NULL");
        }
        
        if (request.getParameter("subfunction") != null) {
        	subCode = request.getParameter("subfunction");
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
		int	defaultView;			// 일간, 주간, 월간
		int	startDay;				// 일요일부터 또는 월요일부터
		
        if (request.getParameter("funCode") != null) {
            funCode = request.getParameter("funCode");
        }
        
        if (request.getParameter("subfunction") != null) {
        	subCode = request.getParameter("subfunction");
        }

        LoginVO loginVO = commonUtil.userInfo(loginCookie);
		ScheduleConfigVO schConfVO = ezScheduleService.getScheduleConfig(loginVO.getId());
		defaultView = schConfVO.getDefaultView();
		startDay = schConfVO.getStartDay();
        
		model.addAttribute("funCode", funCode);
		model.addAttribute("subCode", subCode);
		model.addAttribute("defautView", defaultView);	// 임시
		model.addAttribute("startDay", startDay);	// 임시

		
		return "/ezSchedule/scheduleLeft";
	}

	/**
	 * 일정관리 메인화면 호출함수
	 */
	@RequestMapping(value="/ezSchedule/scheduleMain.do")
	public String  scheduleMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, Locale locale, LoginVO loginVO) throws Exception {
		int		receiveCount = 0;
		int 	groupCount = 0;
		String	deptAdmin = "";
		String	companyAdmin = "";
		String	idList = "";
		String	idType = "T";
        String	groupId = "";

		String	otherId = "";
		int		defaultView;
		int		startDay;
		int		startTime;
		int		endTime;
		String	secretaryXml = "";
        String	groupXml = "";
        String	groupXmlTemp = "";
		String	shareXml = "";
        String	scheduleType = "";
        String	pOffset = "";
		int		timeZone = 0;
        String	useGoogleCalendar = config.getProperty("UseGoogleCalrendar");
        String	gList = "";
        String	useEditor = config.getProperty("config.EDITOR");
        String	useIE11Browser = "";
        String	pFlag = "";
        String	pGoogleID = "";
        String	defaultTitle = "";
		
		groupId = request.getParameter("groupid");
		if (groupId == null) {
			groupId = "";
		}

		loginVO = commonUtil.userInfo(loginCookie);

		List<PubScheHqVO> pubScheHqVO = ezScheduleService.getPublicScheduleHq(loginVO.getId());
		List<PubScheSecVO> pubScheSecVO = ezScheduleService.getPublicScheduleSec(loginVO.getId(), loginVO.getLang());
		List<PubScheDeptVO> pubScheDeptVO = ezScheduleService.getPublicScheduleDept(loginVO.getId(), loginVO.getLang());
		List<PubScheCumulerVO> pubScheCumulerVO = ezScheduleService.getPublicScheduleCumuler(loginVO.getId(), loginVO.getLang());

		//본부아이디
        if (pubScheHqVO.size() > 0)
        {
            /* 20110406 표준에는 없는 기능이므로 일단 주석처리
            string _hqid = hq[0]["HQID"].ToString().Trim();
            LitHq.Text = string.Format("<option value=\"{0}\" >{1}</option>", "HQ", RM.GetString("t995"));
            userinfo.HqId = "D" + _hqid;
            userinfo.HqName = hq[0]["HQNAME"].ToString().Trim();
            userinfo.HqName2 = hq[0]["HQNAME2"].ToString().Trim();
             * */
        }
      
		StringBuilder sb = new StringBuilder();		
        for (int i = 0; i < pubScheSecVO.size(); i++)
        {
            sb.append("<option value=\"");
        	sb.append(pubScheSecVO.get(i).getSecId().trim());
        	sb.append("\" type=\"user\" >");
        	sb.append(pubScheSecVO.get(i).getSecName().trim());
        	sb.append("</option>");
        }
       
        for (int i = 0; i < pubScheDeptVO.size(); i++)
        {
            sb.append("<option value=\"");
        	sb.append(pubScheDeptVO.get(i).getDeptId().trim());
        	sb.append("\" type=\"dept\" >[");
        	sb.append("<spring:message code='ezSchedule.t205'/>");
        	sb.append("]");
        	sb.append(pubScheDeptVO.get(i).getDeptName().trim());
        	sb.append("</option>");
        }

        for (int i = 0; i < pubScheCumulerVO.size(); i++)
        {
            sb.append("<option value=\"");
        	sb.append(pubScheCumulerVO.get(i).getDeptId().trim());
        	sb.append("\" type=\"dept\" >[");
        	sb.append("<spring:message code='ezSchedule.t996'/>");
        	sb.append("]");
        	sb.append(pubScheCumulerVO.get(i).getTitleName().trim());
        	sb.append("</option>");
        }
        String litShare = sb.toString();
        
        if (loginVO.getRollInfo().contains("c=1") || loginVO.getRollInfo().contains("k=1"))
        {
            companyAdmin = "Y";
            deptAdmin = "Y";
        }
        else if (loginVO.getRollInfo().contains("g=1"))
        {
            deptAdmin = "Y";
        }

        String useExchange = config.getProperty("Use_Exchange_Pims");
        if (useExchange == null) useExchange = "";
        
        if (useExchange.equals("YES")) {	// 20160824 by kgs: Exchange를 쓸 일은 없으니 Skip. 나중에 CalDAV로 수정
            String domainName = config.getProperty("DomainName");

            String personalId = null;

            if (config.getProperty("LoginIDType").equals("mail"))
            {
                personalId = loginVO.getEmail();
            }
            else
            {
                personalId = loginVO.getName();	// UserPrincipalName
            }
            // receiveCount = GetReceiveCount(esb);
        }
        else
        {
            receiveCount = GetReceiveCount_DB(loginVO.getId());
        }
        groupCount = GetInviteScheduleGroupCount(loginVO.getId());	// 일정 그룹 초대건수

        ScheduleConfigVO scheduleConfigVO = ezScheduleInfo.GetConfigInfo(loginVO.getId());	// 환경설정 정보            

        // 일정 환경설정 정보
        if (scheduleConfigVO != null)
        {
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
        }
        else
        {
            defaultView	= 2;
            startDay	= 7;
            startTime	= 540 / 60;
            endTime		= 1020 / 60;
        }

        List<ScheduleGroupListVO> groupList = ezScheduleInfo.GetScheduleGroupList(loginVO.getId());
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

        UserLocalInfoVO userLocalInfo = ezScheduleInfo.GetUserLocalInfo(loginVO.getId());
        if (userLocalInfo != null) {
        	String[] timeZoneStr = userLocalInfo.getTimeZone().split(":");
        	timeZone = Integer.parseInt(timeZoneStr[0]) * 60 + Integer.parseInt(timeZoneStr[1]);
        }

        // 2011-06 GoogleCalendar              
        String pGooglePWD = "";
        List<ScheduleGmailInfoVO> gmailInfo = ezScheduleInfo.GetScheduleGmailInfo(loginVO.getId());
		Document docGmail = commonUtil.convertStringToDocument(commonUtil.getQueryResult(gmailInfo));

		try {
	        if (docGmail != null)
	        {
	        	pFlag = docGmail.getElementsByTagName("FLAG").item(0).getTextContent().trim();
	        	pGoogleID = docGmail.getElementsByTagName("GMAILID").item(0).getTextContent().trim();
	        }
		} catch (Exception e) {e.printStackTrace();}
        
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
        System.err.println("Title: " + defaultTitle);
		
		return "/ezSchedule/scheduleMain";
	}

	/**
	 * 일정관리 휴일 함수 호출 함수
	 */
	@RequestMapping(value = "/ezSchedule/scheduleGetHoliday.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleGetHoliday(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlStr) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		List<ScheGetHolidayVO> getHoliday = ezScheduleService.getTholiday(xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent().toUpperCase().trim(), userInfo.getCompanyID());
		String returnXML = "";
		for (int i=0; i<getHoliday.size(); i++ ) {
			returnXML = commonUtil.getQueryResult(getHoliday.get(i));
		}
		return returnXML;
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
}
