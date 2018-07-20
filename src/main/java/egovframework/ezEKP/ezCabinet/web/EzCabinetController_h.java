package egovframework.ezEKP.ezCabinet.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
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
	
	/**
	 * 캐비넷파일 상세페이지
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/ezCabinet/cabinetFileDetail.do")
	public String jspGetCabinetFileDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		logger.debug("jspGetCabinetFileDetail started");
		logger.debug("jspGetCabinetFileDetail ended");
		return "ezCabinet/cabinetFileDetail";
	}
	
	/**
	 * 캐비넷 공유페이지 
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/ezCabinet/shareCabinet.do")
	public String jspGetShareCabinetPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetShareCabinetPage started");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String cabinetId     = request.getParameter("cabId");
		
		JSONObject result    = cabinetRestService_h.getUserListType(request, user.getId());
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
		String srchValue   = request.getParameter("srchValue") != null   ? request.getParameter("srchValue")   : "";
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
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		String cabinetId    = request.getParameter("cabinetId")  != null ? request.getParameter("cabinetId")   : "";
		String userList     = request.getParameter("userList")   != null ? request.getParameter("userList")    : "";
		
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
	
}
