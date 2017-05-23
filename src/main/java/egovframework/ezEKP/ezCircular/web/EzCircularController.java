package egovframework.ezEKP.ezCircular.web;

import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Folder;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezCircular.service.EzCircularService;
import egovframework.ezEKP.ezCircular.vo.CircularConfigVO;
import egovframework.ezEKP.ezCircular.vo.CircularListVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

@Controller
public class EzCircularController {

	private static final Logger logger = LoggerFactory.getLogger(EzCircularController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzAddressService ezAddressService;
	
	@Autowired
	private EzCircularService ezCircularService;
	
	@Autowired
	private EzResourceService ezResourceService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	/**
	 * 회람판 메인화면 호출 Method
	 */
	@RequestMapping(value="/ezCircular/circularIndex.do")
	public String main(HttpServletRequest req, Model model) {
		
		logger.debug("Circularmain started");
		
		String func = "";
		String subFunc = "";

		if (req.getParameter("func") != null && !req.getParameter("func").equals("")) {
			func = req.getParameter("func");	
		}
		if (req.getParameter("subFunc") != null && !req.getParameter("subFunc").equals("")) {
			subFunc = req.getParameter("subFunc");	
		}
		
		model.addAttribute("func", func);
		model.addAttribute("subFunc", subFunc);
		
		logger.debug("Circularmain ended");
		
		return "/ezCircular/circularMain";
	}
	
	/**
	 * 회람판 왼쪽화면 호출 Method
	 * @throws Exception 
	 */
	@RequestMapping(value="/ezCircular/circularLeft.do")
	public String circularLeft(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception {
		
		logger.debug("showMailLeft started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		LoginVO user = commonUtil.userInfo(loginCookie);
		
		StringBuilder rootFolderXML = new StringBuilder();
		StringBuilder rootAddressXML = new StringBuilder();
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
			List<Folder> rootMailFolderList = ia.getTopLevelFolders();
			
			for (int i=0,j=0; i<rootMailFolderList.size(); i++) {
				Folder folder = rootMailFolderList.get(i);
				
				String folderName = folder.getName();
				int folderUnreadMessageCount = folder.getUnreadMessageCount();
				
				rootFolderXML.append("<node imgidx='1'");
				
				if (folderUnreadMessageCount > 0) {
					if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.lhm01", locale))) {
						rootFolderXML.append(" caption='"+egovMessageSource.getMessage("ezEmail.t99000025", locale) + "(" + folderUnreadMessageCount + ")'");
					} else {
						rootFolderXML.append(" caption='" + folderName + "(" + folderUnreadMessageCount + ")'");
					}
				} else {
					if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.lhm01", locale))) {
						rootFolderXML.append(" caption='" + egovMessageSource.getMessage("ezEmail.t99000025", locale) + "'");
					} else {
						rootFolderXML.append(" caption='" + folderName+"'");
					}
				}
				
				if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.lhm01", locale))) {
					rootFolderXML.append(" foldername='" + egovMessageSource.getMessage("ezEmail.t99000025", locale) + "'");
				} else {
					rootFolderXML.append(" foldername='" + folderName+"'");
				}

				if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.lhm01", locale))) {
					rootFolderXML.append(" orgBoxName='0'");
					rootFolderXML.append(" fullcaption='_INBOX'"); //수정
				} else if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t645", locale))) {
					rootFolderXML.append(" orgBoxName='1'");
					rootFolderXML.append(" fullcaption='_SENT'"); //수정
				} else if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t646", locale))) {
					rootFolderXML.append(" orgBoxName='2'");
					rootFolderXML.append(" fullcaption='_DRAFT'"); //수정
				} else if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t647", locale))) {
					rootFolderXML.append(" orgBoxName='3'");
					rootFolderXML.append(" fullcaption='_DELETE'"); //수정
				} else if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t648", locale))) {
					rootFolderXML.append(" orgBoxName='4'");
					rootFolderXML.append(" fullcaption='_PERSONAL'"); //수정
				} else if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000029", locale))) {
					rootFolderXML.append(" orgBoxName='5'");
					rootFolderXML.append(" fullcaption='_JUNK'"); //수정
				} else {
					rootFolderXML.append(" orgBoxName='" + ((j++) + 6) + "'");
					rootFolderXML.append(" fullcaption='_NONE'"); //수정
				}

				rootFolderXML.append(" href='" + folder.getFullName() + "'"); //수정
				
				if (folder.list().length > 0) {
					rootFolderXML.append(" hassub='1'");
				}
				if (folderUnreadMessageCount > 0) {
					rootFolderXML.append(" style='font-weight:bold'");
				}
				
				rootFolderXML.append("></node>");
				
			}
		} catch (Exception e) {
			logger.error("Error get unread message count: " + e.getMessage());
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		Map<String, String> map = ezAddressService.getTopFolderSubCount(loginInfo.getTenantId(), loginInfo.getId(), loginInfo.getDeptID(), loginInfo.getCompanyID());
		
		String pHasSub = "";
		String dHasSub = "";
		String cHasSub = "";
		
		if (map != null) {
			if (map.get("P") != null && !map.get("P").equals("0")) {
				pHasSub = "1";
			}
			if (map.get("D") != null && !map.get("D").equals("0")) {
				dHasSub = "1";
			}
			if (map.get("C") != null && !map.get("C").equals("0")) {
				cHasSub = "1";
			}
		}
		
		rootAddressXML.append("<tree>");
		rootAddressXML.append("<nodes>");
        String xmlFormat = "<node imgidx=\"%s\" caption=\"%s\" ownerid=\"%s\" type=\"%s\" folderid=\"%s\" changekey=\"%s\" hassub=\"%s\"></node>";
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezEmail.t99000038", locale), user.getId(), "P", "0", "", pHasSub));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezEmail.t99000039", locale), user.getDeptID(), "D", "0", "", dHasSub));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezEmail.t99000040", locale), user.getCompanyID(), "C", "0", "", cHasSub));
        rootAddressXML.append("</nodes>");
        rootAddressXML.append("</tree>");
        
		String mailServerAddress = config.getProperty("config.MailServerAddress");
		
		String funCode = "1";
		if (request.getParameter("funCode") != null) {
			funCode = request.getParameter("funCode");
		}
		
		model.addAttribute("mailServerAddress", mailServerAddress);
		model.addAttribute("rootFolderXML", rootFolderXML.toString());
		model.addAttribute("rootAddressXML", rootAddressXML.toString());
		model.addAttribute("funCode", funCode);
		
		logger.debug("showMailLeft ended.");
		
		//return "ezEmail/mailLeft";
		
		return "/ezCircular/circularLeft";
	}
	
	@RequestMapping(value = "/ezcircular/newCircular.do")
	public String newCircular(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("newCircular started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		int page = 1;
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId()); 
        String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
        String useRunTime = ezCommonService.getTenantConfig("USERUNTIME", userInfo.getTenantId());
        
		if (request.getParameter("page") != null && !request.getParameter("page").equals("")) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		List<CircularListVO> list = ezCircularService.getCircularList(userInfo.getId(), userInfo.getTenantId());
		
		for (CircularListVO result : list) {
			result.setRegDate(commonUtil.getDateStringInUTC(result.getRegDate(), userInfo.getOffset(), false));
		}
		
		CircularConfigVO config = ezCircularService.getPersonalCount(userInfo);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("page", page);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("useRunTime", useRunTime);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("list", list);
		model.addAttribute("config", config);
		
		logger.debug("newCircular ended");
		return "/ezCircular/newCircular";
	}
	
	/**
	 * 작성분 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circular2.do")
	public String circular2(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		
		logger.debug("Circular2 started");
		
		
		
		logger.debug("Circular2 ended");
		
		return "/ezCircular/circular2";
	}
	
	/**
	 * 휴지통 화면 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circular3.do")
	public String circular3(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		
		logger.debug("Circular3 started");
		
		
		
		logger.debug("Circular3 ended");
		
		return "/ezCircular/circular3";
	}
	
	/**
	 * 임시저장 화면 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circular4.do")
	public String circular4(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		
		logger.debug("Circular4 started");
		
		
		
		logger.debug("Circular4 ended");
		
		return "/ezCircular/circular4";
	}
	
	/**
	 * 확인완료 화면 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circular5.do")
	public String circular5(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		
		logger.debug("Circular5 started");
		
		
		
		logger.debug("Circular5 ended");
		
		return "/ezCircular/circular5";
	}
	
	/**
	 * 환경설정 화면 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/circularConfig.do")
	public String circularConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		
		logger.debug("circularConfig started");
		
		
		
		logger.debug("circularConfig ended");
		
		return "/ezCircular/circularConfig";
	}
	
	@RequestMapping(value = "/ezCircular/circularGeneral.do")
	public String circuralGeneral(@CookieValue("loginCookie") String loginCookie, LoginVO loginVO, Model model) throws Exception {
		
		logger.debug("circuralGeneral started");
		
		loginVO = commonUtil.userInfo(loginCookie);
		String memberId = loginVO.getId();
		
		CircularConfigVO circularListConfig = ezCircularService.getCircularList_Config(memberId, loginVO.getTenantId());
		
		if (circularListConfig == null) {
			circularListConfig = new CircularConfigVO();
			circularListConfig.setIsMailReceive(0);
			circularListConfig.setListCnt(10);
			circularListConfig.setIsPreview(0);
			circularListConfig.setPreviewListValue("50");
			circularListConfig.setPreviewContentValue("50");
		}
		
		model.addAttribute("circularListConfig", circularListConfig);
		
		logger.debug("circuralGeneral started");
		
		return "/ezCircular/circularGeneral";
	}
	
	@RequestMapping(value = "/ezCircular/circular_generallist_save.do", method = RequestMethod.POST)
	@ResponseBody
	public void circular_generallist_save(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularConfigVO circularConfigVO) throws Exception {
		
		logger.debug("circular_generallist_save started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		circularConfigVO.setTenantId(userInfo.getTenantId());
		circularConfigVO.setMemberId(userInfo.getId());

		if (request.getParameter("isPreview").equals("0")) {
			circularConfigVO.setPreviewListValue("50");
			circularConfigVO.setPreviewContentValue("50");
		}

		ezCircularService.setCircularList_Config(circularConfigVO);
		
		logger.debug("circular_generallist_save ended");
	}
	
	/**
	 * 회람판 리스트설정셋팅 실행 Method
	 */
	@RequestMapping(value = "/ezCircular/circularGeneralListSave2.do")
	public String boardGeneralListSave2(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String listCount = request.getParameter("listCount");
		String previewMode = request.getParameter("previewMode");
		String list = request.getParameter("list");
		String content = request.getParameter("content");
		
		ezCircularService.setCircularList_Config2(userID, listCount, previewMode, list, content, userInfo.getTenantId());
		
		return "json";
	}
	
	/**
	 * 회람판 게시물설정 표출 Method
	 */
	@RequestMapping(value = "/ezCircular/setCircularConfig.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String setBoardConfig(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception{
		logger.debug("setBoardConfig started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = request.getParameter("pUserID");
		String listCount = request.getParameter("pListCount");
		String preView = request.getParameter("pPreView");
		
		logger.debug("userID : "+userID + ", listCount : " + listCount + ", preView : " + preView);
		
		int tempCount = 10;
		
		if (listCount != null) {
			tempCount = Integer.parseInt(listCount);
		}
		
		if (preView != null && preView.equals("OFF")) {
			preView = "0";
		} else if (preView != null && preView.equals("H")) {
			preView = "1";
		} else if (preView != null && preView.equals("W")) {
			preView = "2";
		}
		String result = ezCircularService.setCircularConfig(userID, tempCount, preView, userInfo.getTenantId());

		logger.debug("setBoardConfig ended");
		return result;
	}
	
	/**
	 * 회람판 신규회람판 리스트 표출 Method
	 */
    @RequestMapping(value = "/ezCircular/getCircularList.do", produces = "text/xml; charset=utf-8")
    @ResponseBody
    public String getBoardList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
    	logger.debug("getBoardList started");

    	userInfo = commonUtil.userInfo(loginCookie);
    	
    	List<CircularListVO> list = ezCircularService.getCircularList(userInfo.getId(), userInfo.getTenantId());
    	
    	model.addAttribute("list", list);
    	model.addAttribute("userInfo", userInfo);
    	
		logger.debug("getBoardList ended");
        return "";
    }
    
	/**
	 * 회람판 회람작성창 화면 호출 함수
	 */
	@RequestMapping(value = "/ezCircular/circularWrite.do")
	public String scheduleAdd(@CookieValue("loginCookie") String loginCookie,LoginVO userInfo, HttpServletRequest req, Model model, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String editor = config.getProperty("EDITOR");
		String noneActiveX = "YES";
		String resID = "";
		String brdName = "";
		String cmdStr = "";
		String fromStr = "";
		String dayView = "";
		String orgNum = "";
		String orgOwnerID = "";
		String typeVal = "";
		String startDateVal = "";
		String endDateVal = "";
		String deptNm = "";
		String ownerNm = "";
		String title = "";
		String loc = "";
		String importance = "";
		String gresFlag = "0";
		String reFlag = "";
		String startDateTime = "";
		String endDateTime = "";
		String startDateTime2 = "";
		String endDateTime2 = "";
		String timeDisplay = "";
		String content = "";
		String ownerID = "";
		String writerID = "";
		String checkSDT = "";
		String checkEDT = "";
		String allDay = "";
		String saveApproveFlag = "";
		String startDateTimeRepeat = "";
		String endDateTimeRepeat = "";
		String entryList = "";
		
		int pNum = 0;
		int num = 0;
		
		if (req.getParameter("ownerID") != null) {
			resID = req.getParameter("ownerID");
		}
		if (req.getParameter("brdName") != null) {
			brdName = req.getParameter("brdName");
		}

		String adminFg = ezResourceService.getACL(userInfo.getCompanyID(), resID, userInfo.getId(), "", userInfo.getTenantId());
		
		if (req.getParameter("cmd") != null) {
			cmdStr = req.getParameter("cmd");
		}
		if (req.getParameter("from") != null) {
			fromStr = req.getParameter("from");
		}
		if (req.getParameter("dayView") != null) {
			dayView = req.getParameter("dayView");
		}
		if (cmdStr.equals("mod")) {
			if (req.getParameter("num") != null) {
				orgNum = req.getParameter("num").trim();
			}

			if (req.getParameter("ownerID") != null) {
				orgOwnerID = req.getParameter("ownerID").trim();
			}
			if (req.getParameter("type") != null) {
				typeVal = req.getParameter("type").trim();
			}
			if (req.getParameter("startDate") != null) {
				startDateVal = req.getParameter("startDate").trim();
			}
			if (req.getParameter("endDate") != null) {
				endDateVal = req.getParameter("endDate").trim();
			}
			ResGetScheduleVO getSchedule = new ResGetScheduleVO();
			if (typeVal.equals("Master") || typeVal.equals("Readonly")) {
				getSchedule = ezResourceService.getSchedule(Integer.parseInt(orgNum), orgOwnerID, userInfo.getCompanyID(), userInfo.getTenantId());
			}
			
			num = getSchedule.getNum();
			pNum = getSchedule.getpNum();
			ownerID = getSchedule.getOwnerID();
			writerID = getSchedule.getWriterID();
	
			String propList = "displayName;description";
			String infoXML = ezOrganService.getPropertyList(writerID, propList, userInfo.getPrimary(), userInfo.getTenantId());
			
			Document xmlDom2 = commonUtil.convertStringToDocument(infoXML);
			
			if (userInfo.getPrimary().equals("1")) {
				deptNm = xmlDom2.getElementsByTagName("DESCRIPTION1").item(0).getTextContent();
				ownerNm = xmlDom2.getElementsByTagName("DISPLAYNAME1").item(0).getTextContent();
			} else {
				deptNm = xmlDom2.getElementsByTagName("DESCRIPTION" + userInfo.getPrimary()).item(0).getTextContent();
				ownerNm = xmlDom2.getElementsByTagName("DISPLAYNAME" + userInfo.getPrimary()).item(0).getTextContent();
			}
			title = getSchedule.getTitle();
			
			if (title != null) {
				 title = title.replace("'", "&#39;");
                 title = title.replace("\"", "&quot;");
			}
			loc = getSchedule.getLocation();

			if (loc != null) {
				loc = title.replace("'", "&#39;");
                loc = title.replace("\"", "&quot;");
			}
			timeDisplay = getSchedule.getTimeDisplay();
			
			startDateTime = commonUtil.getDateStringInUTC(getSchedule.getStartDate(), userInfo.getOffset(), false);
			endDateTime = commonUtil.getDateStringInUTC(getSchedule.getEndDate(), userInfo.getOffset(), false);
			
			reFlag = getSchedule.getReFlag();
			gresFlag = getSchedule.getGresFlag();
			content = getSchedule.getContent();
			importance = getSchedule.getImportance();
			
			if (importance.equals("")) {
				importance = "2";
			}
			
			entryList = getSchedule.getEntryList();
			allDay = getSchedule.getAllDay();
			saveApproveFlag = getSchedule.getApproveFlag();
			
			ResGetScheduleRepetitionVO repDateTimes = ezResourceService.getRepDateTimes(orgOwnerID, userInfo.getCompanyID(), Integer.parseInt(orgNum), userInfo.getTenantId());
			if (repDateTimes != null) {
				startDateTimeRepeat = commonUtil.getDateStringInUTC(repDateTimes.getStartDateTime(), userInfo.getOffset(), false);
				endDateTimeRepeat = commonUtil.getDateStringInUTC(repDateTimes.getEndDateTime(), userInfo.getOffset(), false);
			}
		} else {
			importance = "2";
			String selSd = "";
			String selEd = "";
			String cDate = "";
			String cTime = "";
			
			if (req.getParameter("selsd") != null) {
				selSd = req.getParameter("selsd");
			}
			if (req.getParameter("seled") != null) {
				selEd = req.getParameter("seled");
			}
			if (selSd.equals("") || selEd.equals("")) {
				cDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"), userInfo.getOffset(), false);
				cTime = cDate.split(" ")[1].substring(0, 2);
				
				if (req.getParameter("startDate") != null) {
					cDate = req.getParameter("startDate");
				}
				cDate = cDate.substring(0, 10);
				startDateTime = cDate + " " + cTime + ":00:00";
				
				if (req.getParameter("endDate") != null) {
					cDate = req.getParameter("endDate");
				}
				cDate = cDate.substring(0, 10);
				endDateTime = cDate + " " + cTime + ":30:00";
			} else {
				if (selSd.length() == 10) {
					cDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"), userInfo.getOffset(), false);
					cTime = cDate.split(" ")[1].substring(0, 2);
					cDate = cDate.substring(0, 10);
					startDateTime = selSd + " " + cTime + ":00:00";
					endDateTime = selEd + " " + cTime + ":30:00";

				} else {
					startDateTime = selSd;
					endDateTime = selEd;
				}
			}
			
			if (req.getParameter("ownerID") != null) {
				ownerID = req.getParameter("ownerID");
			}
		}
		
		startDateTime2 = startDateTime;
		endDateTime2 = endDateTime;
		
		startDateTime = EgovDateUtil.convertDate(startDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
		endDateTime = EgovDateUtil.convertDate(endDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
		
		checkSDT = EgovDateUtil.convertDate(startDateTime, "yyyy-MM-dd aa h:mm:ss", "yyyy-M-d H:mm", "");
		checkEDT = EgovDateUtil.convertDate(endDateTime, "yyyy-MM-dd aa h:mm:ss", "yyyy-M-d H:mm", "");
		
		model.addAttribute("userInfo", userInfo);
		
		model.addAttribute("editor", editor);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("adminFg", adminFg);
		model.addAttribute("brdName", brdName);
		model.addAttribute("resID", resID);
		model.addAttribute("num", num);
		model.addAttribute("cmdStr", cmdStr.toLowerCase());
		model.addAttribute("fromStr", fromStr);
		model.addAttribute("dayView", dayView);
		model.addAttribute("pNum", pNum);
		model.addAttribute("gresFlag", gresFlag);
		model.addAttribute("reFlag", reFlag);
		model.addAttribute("content", content);
		model.addAttribute("ownerID", ownerID);
		model.addAttribute("ownerNm", ownerNm);
		model.addAttribute("importance", importance);
		model.addAttribute("loc", loc);
		model.addAttribute("timeDisplay", timeDisplay);
		model.addAttribute("writerID", writerID);
		model.addAttribute("deptNm", deptNm);
		model.addAttribute("title", title);
		model.addAttribute("allDay", allDay);
		model.addAttribute("entryList", entryList);
		model.addAttribute("startDateTime", startDateTime);
		model.addAttribute("endDateTime", endDateTime);
		model.addAttribute("startDateTime2", startDateTime2);
		model.addAttribute("endDateTime2", endDateTime2);
		model.addAttribute("startDateVal", startDateVal);
		model.addAttribute("endDateVal", endDateVal);
		model.addAttribute("typeVal", typeVal);
		model.addAttribute("saveApproveFlag", saveApproveFlag);
		model.addAttribute("startDateTimeRepeat", startDateTimeRepeat);
		model.addAttribute("endDateTimeRepeat", endDateTimeRepeat);
		model.addAttribute("checkSDT", checkSDT);
		model.addAttribute("checkEDT", checkEDT);
		
		if (reFlag.equals("1")) {
			model.addAttribute("strTmpReFlagVal", "2");
			model.addAttribute("strDspMod1", "style='display:none'");
			model.addAttribute("strDspMod2", "");
		} else {
			model.addAttribute("strTmpReFlagVal", "0");
			model.addAttribute("strDspMod1", "");
			model.addAttribute("strDspMod2", "style='display:none'");
		}
		
		if (reFlag.equals("")) {
			model.addAttribute("strIReFlagVal", "0");
		} else {
			model.addAttribute("strIReFlagVal", reFlag);
		}
		
		return "/ezCircular/circularWrite";
	}
	
	/**
	 * 회람판 draganddrop 호출 Method
	 */
	@RequestMapping(value = "/ezCircular/dragAndDrop.do")
	public String dragAndDrop(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo",userInfo);
		
		return "/ezCircular/circularDragAndDrop";
	}
	
	/**
	 * 회람판 신규 회람판 등록 실행 Method
	 */
	@RequestMapping(value = "/ezCircular/saveCircular.do", method = RequestMethod.POST)
	@ResponseBody
	public void saveCircular(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, CircularListVO circularListVO) throws Exception {
		logger.debug("saveCircular started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		int circularUserId = 0;
		int updateStatus = 0;
		String confirmDate = "";
		String receiverIDs = request.getParameter("receiverID");
		String receiverlist = request.getParameter("receiverlist");
		
		logger.debug("receiverIDs : "+receiverIDs);
		logger.debug("receiverlist : "+receiverlist);
		
		int receiverLength = receiverIDs.split(",").length;
		String[] receiverID = receiverIDs.split(",");
		
		String regDate = commonUtil.getTodayUTCTime("");
		
		ezCircularService.insertCircular(circularListVO.getCircularId(), circularListVO.getTitle(), circularListVO.getImportance(), circularListVO.getOption(), circularListVO.getContent(), circularListVO.getHasFile(), circularListVO.getStatus(), userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(), regDate, circularListVO.getEndDate(),userInfo.getTenantId());
		
		for (int i=0; i<receiverLength; i++) {
			ezCircularService.insertCircularUser(circularUserId, circularListVO.getCircularId(), receiverID[i], userInfo.getDisplayName1(), userInfo.getDisplayName2(), circularListVO.getStatus(), confirmDate, updateStatus, userInfo.getTenantId());
		}

		logger.debug("saveCircular ended");
	}
	
	/**
	 * 회람판 상세정보 화면 호출 함수
	 */
	@RequestMapping(value = "/ezCircular/circularRead.do")
	public String circularRead(@CookieValue("loginCookie") String loginCookie,LoginVO userInfo, HttpServletRequest req, Model model, Locale locale) throws Exception {
		logger.debug("circularRead Start");
		userInfo = commonUtil.userInfo(loginCookie);
		
		String typeVal = "";
		String writerID = "";
		String allDay = "";
		String entryList = "";
		String circularID = "";
		if (req.getParameter("circularID") != null && !req.getParameter("circularID").equals("")) {
			circularID = req.getParameter("circularID");
		}
		 
		//TODO 회람 상세정보 가져옴
		CircularListVO result = ezCircularService.getCircular(circularID, userInfo.getTenantId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("writerID", writerID);
		model.addAttribute("allDay", allDay);
		model.addAttribute("typeVal", typeVal);
		model.addAttribute("entryList", entryList);
		model.addAttribute("result", result);
		
		return "/ezCircular/circularRead";
	}
}
