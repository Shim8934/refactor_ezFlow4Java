package egovframework.ezEKP.ezCabinet.web;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import egovframework.ezEKP.ezCabinet.service.EzCabinetRestService;
import egovframework.ezEKP.ezCabinet.service.EzCabinetRestService_h;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@SuppressWarnings("unchecked")
@Controller
public class EzCabinetController_h {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCabinetRestService_h cabinetRestService_h;
	
	@Autowired
	private EzCabinetRestService cabinetRestService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetController_h.class);
	
	@RequestMapping(value="/ezCabinet/cabinetFileDetail.do")
	public String jspGetCabinetFileDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetCabinetFileDetail started");
		LoginSimpleVO user    = commonUtil.userInfoSimple(loginCookie);
		String itemId         = request.getParameter("itemId");
		String jspPageName    = "";
		JSONObject permission = cabinetRestService_h.checkPermission(request, user.getId(), itemId, "", 0);
		
		if ((long)permission.get("code") == 1) {
			return "ezCabinet/cabinetAccessDenied";
		}
		
		JSONObject iteminfo = cabinetRestService_h.cabinetItemInfo(request, user.getId(), itemId);
		
		if (iteminfo.get("status").toString().equals("ok")) {
			jspPageName = getModuleHandler(model, iteminfo);
		}
		else {
			return "ezCabinet/cabinetAccessDenied";
		}
		
		model.addAttribute("itemId", itemId);
		
		logger.debug("jspGetCabinetFileDetail ended");
		return jspPageName;
	}
	
	@RequestMapping(value="/ezCabinet/shareCabinet.do")
	public String jspGetShareCabinetPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetShareCabinetPage started");
		LoginSimpleVO user    = commonUtil.userInfoSimple(loginCookie);
		String cabinetId      = request.getParameter("cabId");
		JSONObject permission = cabinetRestService_h.checkPermission(request, user.getId(), "", cabinetId, 1);
		
		if ((long)permission.get("code") == 1) {
			return "ezCabinet/cabinetAccessDenied";
		}
		
		JSONObject result = cabinetRestService_h.getUserListType(request, user.getId());
		if (result.get("status").toString().equals("ok")) {
			String listType = (String)result.get("listType");
			model.addAttribute("listType", listType);
		}
		
		JSONObject resultObj = cabinetRestService.getCabinetInfo(request, user.getId(), cabinetId);
		
		if (resultObj.get("status").toString().equals("ok")) {
			JSONObject cabinet = (JSONObject) resultObj.get("cabinet");
			model.addAttribute("cabinet", cabinet);
		}
		
		model.addAttribute("cabinetId",   cabinetId);
		
		logger.debug("jspGetShareCabinetPage ended");
		return "ezCabinet/cabinetShare";
	}
	
	@RequestMapping(value="/ezCabinet/getSearchShareList.do")
	public String jspGetShareUsers(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetShareUsers started");
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		String cabinetId    = request.getParameter("cabinetId")  != null ? request.getParameter("cabinetId")   : "";
		String searchOpt    = request.getParameter("searchOpt")  != null ? request.getParameter("searchOpt")   : "";
		String searchValue  = request.getParameter("searchValue")!= null ? request.getParameter("searchValue") : "";
		
		logger.debug("CabinetId: " + cabinetId + " || searchOpt: " + searchOpt + " || searchValue" + searchValue);
		
		JSONObject resultObj = cabinetRestService_h.getShareUserList(request, user.getId(), cabinetId, searchOpt, searchValue);
		
		if (resultObj.get("status").toString().equals("ok")) {
			List<SimpleUserVO> listUsers = (List<SimpleUserVO>)resultObj.get("shareList");
			model.addAttribute("listUsers", listUsers);
		}
		
		logger.debug("jspGetShareUsers ended");
		return "ezCabinet/cabinetSearchShare";
	}
	
	@RequestMapping(value="/ezCabinet/getDeptMembers.do", method=RequestMethod.POST)
	@ResponseBody
	public String jsonGetDeptMembers(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("jsonGetDeptMembers started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String deptId      = request.getParameter("deptId")      != null ? request.getParameter("deptId")      : "";
		String currentPage = request.getParameter("currentPage") != null ? request.getParameter("currentPage") : "";
		
		logger.debug("deptId: " + deptId + " || currentPage: " + currentPage);
		
		JSONObject resultObj = new JSONObject();
		
		if (deptId.equals("") || currentPage.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService_h.getDeptMembers(request, user.getId(), deptId, currentPage);
		
		logger.debug("jsonGetDeptMembers ended");
		logger.debug(resultObj.toString());
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/getShareUserList.do", method=RequestMethod.POST)
	@ResponseBody
	public String jsonGetShareUserList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("jsonGetShareUserList started");
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		String cabinetId    = request.getParameter("cabinetId")  != null ? request.getParameter("cabinetId")   : "";
		String searchOpt    = request.getParameter("searchOpt")  != null ? request.getParameter("searchOpt")   : "";
		String searchValue  = request.getParameter("searchValue")!= null ? request.getParameter("searchValue") : "";
		
		logger.debug("CabinetId: " + cabinetId + " || searchOpt: " + searchOpt + " || searchValue" + searchValue);
		
		JSONObject resultObj = new JSONObject();
		
		if (cabinetId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService_h.getShareUserList(request, user.getId(), cabinetId, searchOpt, searchValue);
		
		logger.debug("jsonGetShareUserList ended");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/saveListType.do", method=RequestMethod.POST)
	@ResponseBody
	public String jsonSaveUserListType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("jsonSaveUserListType started");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String listType      = request.getParameter("listType") != null ? request.getParameter("listType") : "";
		JSONObject resultObj = new JSONObject();
		
		if (listType.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService_h.saveUserListType(request, user.getId(), listType);
		
		logger.debug("jsonSaveUserListType ended");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/getSearchMember.do", method=RequestMethod.POST)
	@ResponseBody
	public String jsonGetSearchMember(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("jsonGetSearchMember started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String srchOption  = request.getParameter("srchOption") != null  ? request.getParameter("srchOption")  : "";
		String srchValue   = request.getParameter("srchValue")  != null  ? request.getParameter("srchValue")   : "";
		String currentPage = request.getParameter("currentPage") != null ? request.getParameter("currentPage") : "";
		
		logger.debug("srchOption: " + srchOption + " || srchValue: " + srchValue + " || currentPage: " + currentPage);
		
		JSONObject resultObj = new JSONObject();
		
		if (srchOption.equals("") || srchValue.equals("") || currentPage.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService_h.getSearchMember(request, user.getId(), srchOption, srchValue, currentPage);
		
		logger.debug("jsonGetSearchMember ended");
		logger.debug(resultObj.toString());
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/saveShareUserList.do", method=RequestMethod.POST)
	@ResponseBody
	public String jsonSaveShareUserList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("jsonSaveShareUserList started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String cabinetId   = request.getParameter("cabinetId") != null ? request.getParameter("cabinetId") : "";
		String userList    = request.getParameter("userList")  != null ? request.getParameter("userList")  : "";
		
		logger.debug("CabinetId: " + cabinetId + " || userList" + userList);
		
		JSONObject resultObj = new JSONObject();
		
		if (cabinetId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService_h.saveShareUserList(request, user.getId(), cabinetId, userList);
		
		logger.debug("jsonSaveShareUserList ended");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/getFileDetail.do", method=RequestMethod.GET)
	@ResponseBody
	public String jsonGetFileDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("jsonGetFileDetail started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String itemId      = request.getParameter("itemId") != null ? request.getParameter("itemId") : "";
		
		logger.debug("itemId: " + itemId);
		
		JSONObject resultObj = new JSONObject();
		
		if (itemId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService_h.getFileDetail(request, user.getId(), itemId);
		
		logger.debug("jsonGetFileDetail ended");
		logger.debug(resultObj.toString());
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/modifyItem.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonModifyItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("Modify item is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String itemId          = request.getParameter("itemId")      != null ? request.getParameter("itemId")      : "";
		String title           = request.getParameter("title")       != null ? request.getParameter("title")       : "";
		String summary         = request.getParameter("summary")     != null ? request.getParameter("summary")     : "";
		String fileList        = request.getParameter("listFile")    != null ? request.getParameter("listFile")    : "";
		String relatedList     = request.getParameter("relatedList") != null ? request.getParameter("relatedList") : "";
		JSONObject resultObj   = new JSONObject();
		
		logger.debug("itemId : " + itemId + " || title : " + title + " || summary: " + summary + " || fileList: " + fileList + " || relatedList: " + relatedList);
		
		if (itemId.equals("") || title.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		JSONParser jp        = new JSONParser();
		JSONArray fileArray  = (JSONArray) jp.parse(fileList);
		JSONArray relatedArr = (JSONArray) jp.parse(relatedList);
		
		resultObj = cabinetRestService_h.modifyItem(request, userInfo.getId(), itemId, title, summary, fileArray, relatedArr);
		
		logger.debug("Modify item finishes!");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/saveRelatedBoard.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonSaveRelatedBoard(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("jsonSaveRelatedBoard is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String mode            = request.getParameter("mode")      != null ? request.getParameter("mode")      : "";
		String cabinetId       = request.getParameter("cabinet")   != null ? request.getParameter("cabinet")   : "";
		String title           = request.getParameter("title")     != null ? request.getParameter("title")     : "";
		String writer          = request.getParameter("writer")    != null ? request.getParameter("writer")    : "";
		String dateTime        = request.getParameter("date")      != null ? request.getParameter("date")      : "";
		String attach          = request.getParameter("attach")    != null ? request.getParameter("attach")    : "";
		String content         = request.getParameter("content")   != null ? request.getParameter("content")   : "";
		JSONObject resultObj   = new JSONObject();
		
		logger.debug("mode: " + mode + " || cabinetId: " + cabinetId + " || title: " + title + " || writer: " + writer + " || dateTime: " + dateTime + " || attach: " + attach + " || content : " + content);
		
		if (mode.equals("") || (mode.equals("1") && cabinetId.equals("")) || title.equals("") || writer.equals("") || dateTime.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService_h.saveRelatedBoard(request, userInfo.getId(), mode, cabinetId, title, writer, dateTime, attach, content);
		
		logger.debug("jsonSaveRelatedBoard finishes!");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/saveRelatedOption.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonSaveRelatedOption(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("jsonSaveRelatedOption is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String mode            = request.getParameter("mode")       != null ? request.getParameter("mode")       : "";
		String cabinetId       = request.getParameter("cabinet")    != null ? request.getParameter("cabinet")    : "";
		String title           = request.getParameter("title")      != null ? request.getParameter("title")      : "";
		String writer          = request.getParameter("writer")     != null ? request.getParameter("writer")     : "";
		String date            = request.getParameter("date")       != null ? request.getParameter("date")       : "";
		String importance      = request.getParameter("importance") != null ? request.getParameter("importance") : "";
		String option          = request.getParameter("option")     != null ? request.getParameter("option")     : "";
		String statusNum       = request.getParameter("statusNum")  != null ? request.getParameter("statusNum")  : "";
		String status          = request.getParameter("status")     != null ? request.getParameter("status")     : "";
		String confirm         = request.getParameter("confirm")    != null ? request.getParameter("confirm")    : "";
		String endDate         = request.getParameter("endDate")    != null ? request.getParameter("endDate")    : "";
		String content         = request.getParameter("content")    != null ? request.getParameter("content")    : "";
		String attach          = request.getParameter("attach")     != null ? request.getParameter("attach")     : "";
		JSONObject resultObj   = new JSONObject();
		
		logger.debug("mode: " + mode + " || cabinetId: " + cabinetId + " || title: " + title + " || writer: " + writer + "date: " + date +" || importance: " + importance + " || option: " + option + " || statusNum : " + statusNum + " || status: " + status + " || confirm: " + confirm + " || endDate: " + endDate + " || content : " + content +  " || attach: " + attach);
		
		if (mode.equals("") || (mode.equals("1") && cabinetId.equals("")) || title.equals("") || writer.equals("") || date.equals("") || importance.equals("") || option.equals("") || statusNum.equals("") || status.equals("") || confirm.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService_h.saveRelatedOption(request, userInfo.getId(), mode, cabinetId, title, writer, date, importance, option, statusNum, status, confirm, endDate, content, attach);
		
		logger.debug("jsonSaveRelatedOption finishes!");
		return resultObj.toString();
	}
	
	private String getModuleHandler(Model model, JSONObject iteminfo) {
		String jspPageName   = "";
		JSONObject item      = (JSONObject) iteminfo.get("item");
		JSONArray columnList = (JSONArray) iteminfo.get("columns");
		int itemType         = ((Long)item.get("itemType")).intValue();
		model.addAttribute("item", item);
		
		if (columnList != null) {
			for (int i = 0, totalColumn = columnList.size(); i < totalColumn; i++) {
				JSONObject column = (JSONObject) columnList.get(i);
				String columnId   = column.get("columnId").toString();
				model.addAttribute(columnId, column);
			}
		}
		
		switch(itemType) {
			case 0  : jspPageName = "ezCabinet/cabinetFileDetail"          ; break;
			case 1  : jspPageName = getEmailColumnInfo(model, iteminfo)    ; break;
			case 3  : jspPageName = getBoardColumnInfo(model, iteminfo)    ; break;
			case 4  : jspPageName = getScheduleColumnInfo(model, iteminfo) ; break;
			case 5  : jspPageName = getTodoColumnInfo(model, iteminfo)     ; break;
			case 6  : jspPageName = getOptionColumnInfo(model, iteminfo)   ; break;
			case 8  : jspPageName = getAddressColumnInfo(model, iteminfo)  ; break;
			case 11 : jspPageName = getResourceColumnInfo(model, iteminfo) ; break;
			default : break;
		}
		
		return jspPageName;
	}
	
	private String getTodoColumnInfo(Model model, JSONObject iteminfo) {
		String jspPageName = "ezCabinet/cabinetTodoDetail";
		JSONObject creator = (JSONObject) iteminfo.get("creator");
		model.addAttribute("creatorUser", creator);
		
		return jspPageName;
	}
	
	private String getScheduleColumnInfo(Model model, JSONObject iteminfo) {
		String jspPageName = "ezCabinet/cabinetScheduleDetail";
		JSONObject creator = (JSONObject) iteminfo.get("creator");
		model.addAttribute("creatorUser", creator);
		
		return jspPageName;
	}
	
	private String getResourceColumnInfo(Model model, JSONObject iteminfo) {
		String jspPageName = "ezCabinet/cabinetResourceDetail";
		JSONObject creator = (JSONObject) iteminfo.get("creator");
		
		model.addAttribute("creatorUser", creator);
		return jspPageName;
	}
	
	private String getAddressColumnInfo(Model model, JSONObject iteminfo) {
		String jspPageName  = "";
		String addressType  = iteminfo.get("addresstype").toString();
		JSONObject creator  = (JSONObject) iteminfo.get("creator");
		JSONObject modifier = (JSONObject) iteminfo.get("modifier");
		
		model.addAttribute("creatorUser",  creator);
		model.addAttribute("modifierUser", modifier);
		
		if (addressType.equals("group")) {
			jspPageName = "ezCabinet/cabinetGroupAddress";
		}
		else {
			jspPageName = "ezCabinet/cabinetNormalAddress";
		}
		
		return jspPageName;
	}
	
	private String getEmailColumnInfo(Model model, JSONObject iteminfo) {
		String jspPageName     = "ezCabinet/cabinetEmailDetail";
		JSONObject senderUser  = (JSONObject) iteminfo.get("sender");
		JSONArray receiverList = (JSONArray) iteminfo.get("receivers");
		
		model.addAttribute("receiverList", receiverList);
		model.addAttribute("senderUser", senderUser);
		
		if (iteminfo.get("forwards") != null) {
			JSONArray forwardList = (JSONArray) iteminfo.get("forwards");
			model.addAttribute("forwardList", forwardList);
		}
		
		return jspPageName;
	}
	
	private String getBoardColumnInfo(Model model, JSONObject iteminfo) {
		String jspPageName = "ezCabinet/cabinetBoardDetail";
		return jspPageName;
	}
	
	private String getOptionColumnInfo(Model model, JSONObject iteminfo) {
		String jspPageName = "ezCabinet/cabinetOptionDetail";
		return jspPageName;
	}
}
