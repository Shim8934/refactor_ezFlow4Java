package egovframework.ezEKP.ezSchedule.web;

import java.io.File;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.service.impl.EzScheduleCompareUtil;
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
		
	@Autowired
	private EgovMessageSource msg;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
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
	public String  scheduleLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginSimpleVO loginSimpleVO) throws Exception {
		
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
        
        loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
        
		ScheduleConfigVO schConfVO = ezScheduleService.getScheduleConfig(loginSimpleVO.getId(), loginSimpleVO.getTenantId());
		
		if (schConfVO != null) {
			defaultView = schConfVO.getDefaultView();
			startDay = schConfVO.getStartDay();
		}
        
		model.addAttribute("funCode", funCode);
		model.addAttribute("subCode", subCode);
		model.addAttribute("defautView", defaultView);
		model.addAttribute("startDay", startDay);
		model.addAttribute("lang", loginSimpleVO.getLang());
		
		return "/ezSchedule/scheduleLeft";
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
		
		List<ScheGetHolidayVO> getHoliday = ezScheduleService.getTholiday(cID.trim(), userInfo.getCompanyID(), userInfo.getTenantId());
				
		for (int i=0; i<getHoliday.size(); i++ ) {
			returnXML.append(commonUtil.getQueryResult(getHoliday.get(i)));
		}
		
		return "<DATA>" + returnXML.toString() + "</DATA>";
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
		
		Collections.sort(sList, new EzScheduleCompareUtil());
		
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
		
		String pidList = "";
		
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
		
		if (idList == null) {
			idList = "";
		}
		
		if (idList.equals("P")) {
			pidList = "'" + userInfo.getId() + "'";
		} else if (idList.equals("D")) {
			pidList = "'" + userInfo.getDeptID() + "'";
		} else if (idList.equals("C")) {
			pidList = "'" + userInfo.getCompanyID() + "'";
		} else if (idList.equals("G")) {
			pidList = "'" + groupID + "'";
		} else if (idList.equals("T") || idList.equals("")) {
			pidList = "'" + userInfo.getId() + "'," + "'" + userInfo.getDeptID() + "'," + "'" + userInfo.getCompanyID() + "'";
			
			List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(userInfo.getId(), userInfo.getTenantId());
			
			for (int i = 0; i < gList.size(); i++) {
				if (i == 0) {
					pidList += ",";
				}			
				ScheduleGroupListVO data = gList.get(i);			
				pidList += "'" + data.getGroupId() + "'";
				
				if (i != gList.size()-1) {
					pidList += ",";
				}	
			}			
		} else {
			pidList = "'" + idList + "'";
		}		
		
		List<ScheduleInfoVO> sList = ezScheduleService.getScheduleList(pidList, "", utcStartTime, utcEndTime, "", offSetMin, userInfo.getTenantId());		
	
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
		
		List<ScheduleSecretaryVO> pubScheSecVO = ezScheduleService.getPublicScheduleSec(userID, lang, tenantID);
		List<ScheduleDeptVO> pubScheDeptVO = ezScheduleService.getPublicScheduleDept(userID, lang, tenantID);
		List<ScheduleCumulerVO> pubScheCumulerVO = ezScheduleService.getPublicScheduleCumuler(userID, lang, tenantID);
		        
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
        
        int receiveCount = ezScheduleService.getReceiveCount(loginVO.getId(), loginVO.getTenantId());
        int groupCount = ezScheduleService.getInviteScheduleGroupCnt(loginVO.getId(), loginVO.getTenantId());
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
        // 일정 그룹 목록
        List<ScheduleGroupListVO> groupList = ezScheduleService.getScheduleGroupList(loginVO.getId(), loginVO.getTenantId());
        
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
        
        if (otherId != null && !otherId.equals("")) {        	
            idList = otherId;
            
            if (idTypeTmp != null && !idTypeTmp.equals("")) {
            	idType = idTypeTmp;	
            }
            
        } else if (idTypeTmp != null && !idTypeTmp.equals("")) {
        	idType = idTypeTmp;
        	
            switch (idType) {
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
        model.addAttribute("groupXmlTemp",	groupXmlTemp);
        model.addAttribute("idList",		idList);
        model.addAttribute("startTime",		startTime);
        model.addAttribute("endTime",		endTime);
        model.addAttribute("defaultView",	defaultView);
        model.addAttribute("startDay",		startDay);
        model.addAttribute("useEditor",		useEditor);
        model.addAttribute("defaultTitle",	defaultTitle);
        model.addAttribute("shareList",		sb.toString());
        
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
	public String getGroupDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO loginVO) throws Exception {
		
		logger.debug("============ getGroupDetail started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		String gID = request.getParameter("groupID");
		String xmlResult = ezScheduleService.getMyGroupMemberList(gID, loginVO.getPrimary(), loginVO.getTenantId());
		
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
	
	/**
	 * 일정그룹관리 멤버 선택 팝업 창
	 */
	@RequestMapping(value = "/ezSchedule/scheduleSelectAttendant.do")
	public String scheduleSelectAttendant(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleSelectAttendant started ============");
		
        String title = request.getParameter("title");
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");
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
		
		String result = ezScheduleService.getDeptMemberList(deptId, subDept, loginVO.getPrimary(), loginVO.getTenantId());
				
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
		
		ezScheduleService.insertScheduleGroup(gUID, loginSimpleVO.getId(), displayName, displayName2, groupName, description, loginSimpleVO.getTenantId());

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
		String pidList = "'" + loginVO.getId() + "'," + "'" + loginVO.getDeptID() + "'," + "'" + loginVO.getCompanyID() + "'";
		
		if (filter != null && !filter.equals("")) {			
			String utcStartTime = "";
			String utcEndTime = "";
			
			if (keyword == null) keyword = "";
			if (startDate == null) startDate = "";
			if (endDate == null) endDate = "";			
			
			if (startDate == null || startDate.equals("") || endDate == null || endDate.equals("")) {
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
			utcStartTime = commonUtil.getDateStringInUTC(startDate + " 00:00:00", loginVO.getOffset(), true);
			utcEndTime = commonUtil.getDateStringInUTC(endDate + " 23:59:59", loginVO.getOffset(), true);
			
			List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(loginVO.getId(), loginVO.getTenantId());
			
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
			sList = ezScheduleService.getScheduleList(pidList, filter.trim(), utcStartTime, utcEndTime, keyword.trim(), offSetMin, loginVO.getTenantId());;			
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
			utcStartTime = commonUtil.getDateStringInUTC(startDate + " 00:00:00", loginVO.getOffset(), true);
			utcEndTime = commonUtil.getDateStringInUTC(endDate + " 23:59:59", loginVO.getOffset(), true);
			
			String[] idArr = idList.split(",");
			String userIDList = "";
			
			for (int i=0; i < idArr.length; i++) {
				userIDList += "'" + idArr[i] +"'";
				
				if (i < idArr.length-1) {
					userIDList += ",";
				}
			}			
			sList = ezScheduleService.getScheduleList(userIDList, "IsPublic", utcStartTime, utcEndTime, "Y", offSetMin, loginVO.getTenantId());
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
		
		String result = ezScheduleService.scheduleGetLunarUse(cID, loginSimpleVO.getTenantId());
		
		return result;
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
		
		String result = ezScheduleService.scheduleGetRegi(cID, loginSimpleVO.getTenantId());
		
		return result;
	}
	
	/**
	 * 환경설정 메인
	 */
	@RequestMapping(value="/ezSchedule/scheduleConfigMain.do")
	public String scheduleConfigMain() throws Exception {
		
		logger.debug("============ scheduleConfigMain started ============");
		
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
		
		scheduleConfigVO = ezScheduleService.getScheduleConfig(userID, tenantID);
		List<ScheduleSecretaryVO> sList = ezScheduleService.getSecretaryList(userID, tenantID);
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
		ezScheduleService.deleteSecretary(userID, tenantID);
		//새로운 환경설정 정보 등록
		ezScheduleService.insertScheduleConfig(userID, defaultView, startDay, startTime, endTime, autoDelete, tenantID);		
		
		for (int i = 0; i < jsonArray.size(); i++) {
			JSONObject obj = (JSONObject) jsonArray.get(i);
			
			String secretaryID = (String) obj.get("secretaryID");
			String secretaryName = (String) obj.get("secretaryName");
			//새로운 비서정보 등록
			ezScheduleService.insertSecretary(userID, displayName, displayName2, secretaryID, secretaryName, tenantID);
		}			
	}
	
	/**
	 * 일정작성
	 */
	@RequestMapping(value="/ezSchedule/scheduleWrite.do")
	public String scheduleWrite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, Locale locale, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleWrite started ============");
		
		String _datetype = "";
		String _startdate = "";
		String _enddate = "";
		String _repetition = "";
		String _repetitiondel = "";
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
        String strIReFlagVal = "";
        String _hasattach = "N";
        String _attendantname = "";
        String _attendantemail = "";
        String pCompanyAdmin = "";
        String pDeptAdmin = "";
        int defaultIndex = 0;
        
        StringBuilder strAttach = new StringBuilder();
        StringBuilder strOwnerID = new StringBuilder();
        ScheduleInfoVO scheduleInfo = new ScheduleInfoVO();
               
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
                          
        if (!_scheduleid.equals("")) {		
        	String pDirPath = commonUtil.getUploadPath("upload_schedule.ROOT", loginVO.getTenantId());
        	
        	scheduleInfo = ezScheduleService.getScheduleInfo(_scheduleid, offSetMin, loginVO.getTenantId());
        	
            _contentpath = pDirPath + scheduleInfo.getContentPath();
            startDateStringOrgin = scheduleInfo.getStartDate();
            endDateStringOrgin = scheduleInfo.getEndDate();
            String hasAttendant = scheduleInfo.getHasAttendant();
                              
            if (hasAttendant.equals("Y")) {            	
            	StringBuilder strAttendant = new StringBuilder();
                String parentId = (scheduleInfo.getParentId().equals("0") ? _scheduleid : scheduleInfo.getParentId());
                
                List<AttendantListVO> attendantList = ezScheduleService.getAttendantList(parentId, offSetMin, loginVO.getTenantId());

                for (int i = 0; i < attendantList.size(); i++) {                    	
                	AttendantListVO attendant = attendantList.get(i);
                	String status = "";

                	if (attendant.getStatus().equals("1")) {
                        status = "(" + msg.getMessage("ezSchedule.t251", locale) + ")";
                	} else if (attendant.getStatus().equals("2")) {
                        status = "(" + msg.getMessage("ezSchedule.t168", locale) + ")";
                	} else if (attendant.getStatus().equals("3")) {
                        status = "(" + msg.getMessage("ezSchedule.t169", locale) + ")";
                	} else {
                        status = "(" + msg.getMessage("ezSchedule.t166", locale) + ")";
                	}
                	
                	if (i != 0) {
                		strAttendant.append(", ");
                	}
                	
                    if (loginVO.getLang().equals("1")) {
                    	strAttendant.append("<span title='" + msg.getMessage("ezSchedule.t162", locale) + "' style='cursor:pointer' onclick=show_personinfo('" + attendant.getAttendantId() + "')>" + attendant.getAttendantDeptName() + status + "</span>");
                    } else {
                    	strAttendant.append("<span title='" + msg.getMessage("ezSchedule.t162", locale) + "' style='cursor:pointer' onclick=show_personinfo('" + attendant.getAttendantId() + "')>" + attendant.getAttendantDeptName2() + status + "</span>");
                    }
                }                    
            }                
            _hasattach = scheduleInfo.getHasAttach();            
            
            if (_hasattach.equals("Y")) {            	
            	_hasattach = "Y";            	
            	
            	List<AttachListVO> attachList = ezScheduleService.getAttachList(_scheduleid, loginVO.getTenantId());
            	
            	strAttach.append("<ROOT><NODES>");
            	
                for (AttachListVO attach : attachList) {
                    strAttach.append("<DATA><![CDATA[" + commonUtil.cleanPropertyValue(attach.getFilePath().split("uploadFile/")[1] + "/" + attach.getFileName() + "/" + attach.getFileSize()) + "]]></DATA>");
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
            _repetitiondel = scheduleInfo.getRepetitionDel();
            _ispublic = scheduleInfo.getIsPublic();
            _importance = scheduleInfo.getImportance();
            
            startDateTime = _startdate;
            endDateTime = _enddate;
            
            String strLabelOwner = "";                
            
        	if (_scheduletype.equals("1") || _scheduletype.equals("6")) {
                 strLabelOwner = msg.getMessage("ezSchedule.t372", locale);
                 strLabelOwner += (primary.equals("1") ? scheduleInfo.getOwnerName() : scheduleInfo.getOwnerName2());
            } else if (_scheduletype.equals("2")) {
                 strLabelOwner = msg.getMessage("ezSchedule.t373", locale);
                 strLabelOwner += (primary.equals("1") ? loginVO.getDeptName() : loginVO.getDeptName2());
            } else if (_scheduletype.equals("3")) {
                 strLabelOwner = msg.getMessage("ezSchedule.t374", locale);
                 strLabelOwner += (primary.equals("1") ? loginVO.getCompanyName() : loginVO.getCompanyName2());
            } else if (_scheduletype.equals("4")) {
                 //HQ관련
            } else if (_scheduletype.equals("7")) {
                 strLabelOwner = msg.getMessage("ezSchedule.t375", locale);
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
				defaultIndex = Integer.parseInt(_defaultid) -1;
				
				if (primary.equals("1")) {
					//개인일정
					strOwnerID.append("<option value='1;;" + userId + "'>" + msg.getMessage("ezSchedule.t372", locale) + " " + loginVO.getDisplayName1() + "</option>");
					//부서일정
					strOwnerID.append("<option value='2;;" + loginVO.getDeptID() + "'>" + msg.getMessage("ezSchedule.t373", locale) + " " + loginVO.getDeptName1() + "</option>");
					//회사일정
					strOwnerID.append("<option value='3;;" + loginVO.getCompanyID() + "'>" + msg.getMessage("ezSchedule.t374", locale) + " " + loginVO.getCompanyName1() + "</option>");
				} else {
					//개인일정
					strOwnerID.append("<option value='1;;" + userId + "'>" + msg.getMessage("ezSchedule.t372", locale) + " " + loginVO.getDisplayName2() + "</option>");
					//부서일정
					strOwnerID.append("<option value='2;;" + loginVO.getDeptID() + "'>" + msg.getMessage("ezSchedule.t373", locale) + " " + "</option>");
					//회사일정
					strOwnerID.append("<option value='3;;" + loginVO.getCompanyID() + "'>" + msg.getMessage("ezSchedule.t374", locale) + " " + "</option>");
				}
            	
            	List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(userId, loginVO.getTenantId());
            	
            	for (ScheduleGroupListVO vo : gList) {
            		//그룹 일정
            		strOwnerID.append("<option value='7;;" + vo.getGroupId() + "'>" + msg.getMessage("ezSchedule.t375", locale) + " " + vo.getGroupName() + "</option>");
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
        model.addAttribute("repetitionDel", _repetitiondel);
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
        model.addAttribute("attendantName", _attendantname);
        model.addAttribute("attendantemail", _attendantemail);
        model.addAttribute("pCompanyAdmin", pCompanyAdmin);
        model.addAttribute("pDeptAdmin", pDeptAdmin);
        model.addAttribute("strXML", strAttach.toString());
        model.addAttribute("UploadSDate", UploadSDate);
        model.addAttribute("UploadEDate", UploadEDate);
        model.addAttribute("lang", loginVO.getLang());        
        model.addAttribute("EDITOR", EDITOR);
        model.addAttribute("strIReFlagVal", strIReFlagVal);
        model.addAttribute("strOwnerID", strOwnerID);
        model.addAttribute("defaultIndex", defaultIndex);
        model.addAttribute("offSetMin", offSetMin);
        model.addAttribute("scheduleInfo", scheduleInfo);

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
        
        String pattern = "";

        if (scheduleid != null && !scheduleid.equals("")) {
        	pattern = doc.getElementsByTagName("PATTERN").item(0).getTextContent();
        }        

        String startdate = doc.getElementsByTagName("STARTDATE").item(0).getTextContent();
        String enddate = doc.getElementsByTagName("ENDDATE").item(0).getTextContent();

    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    	Calendar cal = Calendar.getInstance();
    	cal.setTime(sdf.parse(enddate));
    	
    	if (cal.get(Calendar.HOUR) == 0 && cal.get(Calendar.MINUTE) == 0) {        		
    		cal.add(Calendar.MINUTE, -1);        		
    		enddate = sdf.format(cal.getTime());
    	}

    	startdate = sdf.format(sdf.parse(startdate));
    	enddate = sdf.format(sdf.parse(enddate));
        startdate = commonUtil.getDateStringInUTC(startdate, loginVO.getOffset(), true);
    	enddate = commonUtil.getDateStringInUTC(enddate, loginVO.getOffset(), true);
        
        String repetition	= doc.getElementsByTagName("REPETITION").item(0).getTextContent();
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
	    
	    if (contentPath.trim().equals("") || contentPath == null) {	    
	    	defaultPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_schedule.ROOT", loginVO.getTenantId());
	    } else {
	    	defaultPath = commonUtil.getRealPath(request) + contentPath;
	    }

	    if (scheduleid == null || scheduleid.equals("")) {
        	//insertSchedule
        	result = ezScheduleService.insertSchedule(ownerid, ownername, ownername2, creatorid, creatorname, creatorname2, scheduletype, importance, ispublic, datetype, startdate, enddate, repetition, title, location, content, attach, 
        			attendantId, attendantName, attendantName2, attendantDeptName, attendantDeptName2, defaultPath, loginVO.getTenantId());
        } else {
        	//updateSchedule
        	result = ezScheduleService.updateSchedule(scheduleid, creatorid, creatorname, creatorname2, importance, ispublic, datetype, startdate, enddate, repetition, title, location, content, attach, defaultPath, loginVO.getTenantId());
        }
        
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
		
		String offSetMin = commonUtil.getMinuteUTC(userInfo.getOffset());		
		String startDate = request.getParameter("STARTDATE");
		String endDate = request.getParameter("ENDDATE");
		String idList = request.getParameter("IDLIST");		
		String pidList = "'" + idList + "'";		
		String utcStartTime = commonUtil.getDateStringInUTC(startDate + " 00:00:00", userInfo.getOffset(), true);
		String utcEndTime = commonUtil.getDateStringInUTC(endDate + " 23:59:59", userInfo.getOffset(), true);

		List<ScheduleInfoVO> sList = ezScheduleService.getScheduleList(pidList, "", utcStartTime, utcEndTime, "", offSetMin, userInfo.getTenantId());
		
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
	public String scheduleContentsPrint(Model model, HttpServletRequest request) throws Exception {
		
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
        
        //일정 상세정보
        ScheduleInfoVO vo = ezScheduleService.getScheduleInfo(_scheduleid, offSetMin, tenantId);
         
        //일정기간 계산        
        if (vo.getDateType().equals("3")){        	
        	_repeatcount = request.getParameter("repeatcount");
        	_date = request.getParameter("date");
        	
        	if (vo.getRepetition().split("\\|")[1].equals("1")) {
        		dateString = msg.getMessage("ezSchedule.t343", locale) + " (" + _repeatcount + msg.getMessage("ezSchedule.t329", locale) + " " + _date + " (" + msg.getMessage("ezSchedule.t280", locale);
        	} else {
        		dateString = msg.getMessage("ezSchedule.t343", locale) + " (" + _repeatcount + msg.getMessage("ezSchedule.t329", locale) + " " + _date + " " 
        					+ vo.getStartDate().substring(11, 16) + " ~ " + vo.getEndDate().substring(11, 16);        		
        	}        	
        } else if (vo.getDateType().equals("2")){
        	dateString = vo.getStartDate().substring(0,10) + " (" + msg.getMessage("ezSchedule.t280", locale) + " ~ " + vo.getEndDate().substring(0,10) + " (" + msg.getMessage("ezSchedule.t280", locale);        	
        } else {
        	dateString = vo.getStartDate().substring(0,16) + " ~ " + vo.getEndDate().substring(0,16);
        }
        
        //자원예약 정보
        int resourceCnt = ezScheduleService.getResourceCount(_scheduleid, tenantId);
        
        //참석자 정보
        if (vo.getHasAttendant().equals("Y")) {        
        	String parentID = (vo.getParentId().equals("0") ? _scheduleid : vo.getParentId());
        	List<AttendantListVO> aList = ezScheduleService.getAttendantList(parentID, offSetMin, tenantId);
        	
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
	public String scheduleDeleteConfirm() throws Exception {
		
		logger.debug("============ scheduleDeleteConfirm started ============");
		
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
		ezScheduleService.insertScheduleRepeDel(scheduleId, realDate, loginSimpleVO.getTenantId());
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
		
		List<AttendantListVO> aList = ezScheduleService.getAttendantList(scheduleId, offSetMin, loginVO.getTenantId());		
	
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
			
			ezScheduleService.insertScheduleAttendant(scheduleId, attendantId, attendantName, attendantName2, attendantDeptName, attendantDeptName2, loginSimpleVO.getTenantId());
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
		
		List<ScheduleReceiveListVO> rList = ezScheduleService.getReceiveList(loginVO.getId(), loginVO.getTenantId(), offSetMin);
		
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
				
		List<ScheduleGroupListVO> iList = ezScheduleService.getInviteScheduleGroupList(loginVO.getId(), loginVO.getTenantId(), offSetMin);
		
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
		
		model.addAttribute("userInfo", loginVO);
		
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

        for (int i = 0; i < cnt; i++) {
            pFileName[i] = pFileName[i].replace("+", "%2b");
            pFileName[i] = pFileName[i].replace(";", "%3b");
        }
        
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
