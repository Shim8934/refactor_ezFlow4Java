package egovframework.ezEKP.ezWebFolder.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzWebFolderAdminController extends EgovFileMngUtil {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "EzWebFolderAdminService")
	private EzWebFolderAdminService ezWebFolderAdminService;	
	
	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderAdminController.class);
	
	@RequestMapping(value = "/admin/ezWebFolder/webFolderConfig.do")
	public String webFolderConfig(@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("webFolderConfig started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		logger.debug("webFolderConfig ended");
		
		return "admin/ezWebFolder/webfolderConfig";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminLeft.do")
	public String webfolderAdminLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {       
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
        //Add more function here
        
        
		return "admin/ezWebFolder/webfolderAdminLeft";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminRight.do")
	public String webfolderAdminRight(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {       
		LoginVO userInfo     = commonUtil.userInfo(loginCookie);
		String personalLimit = "";
		String uploadLimit 	 = "";

		//Get list of companies
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(j++, vo);
			}
		}
		
		String companyId = resultList.get(0).getCn();
		WebfolderConfigVO webfolderConfig = ezWebFolderAdminService.getWebfolderConfig(companyId, userInfo.getTenantId());
		
		if (webfolderConfig != null) {
			personalLimit = webfolderConfig.getTotalLimit();
			uploadLimit   = webfolderConfig.getUploadLimit();
		}		
        
		model.addAttribute("list", resultList);
		model.addAttribute("persLimit", personalLimit);
		model.addAttribute("upLimit", uploadLimit);
		model.addAttribute("userCompany", userInfo.getCompanyID());
		
		return "admin/ezWebFolder/webfolderCompanyConfig";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminPersonal.do")
	public String webfolderAdminPersonal(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {       
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		//Get list of companies
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(j++, vo);
			}
		}		

		model.addAttribute("list", resultList);
		model.addAttribute("userCompany", userInfo.getCompanyID());

		return "admin/ezWebFolder/webfolderPersonalConfig";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminCompanyFolder.do")
	public String webfolderCompanyFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {       
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
        //Add more function here
        
        model.addAttribute("companyID", "S907000");
        
		return "admin/ezWebFolder/webfolderCompanyFolder";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminCompanyFile.do")
	public String webfolderCompanyFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {       
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
        //Add more function here
        
        model.addAttribute("companyID", "S907000");
        
		return "admin/ezWebFolder/webfolderCompanyFile";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminFileHistory.do")
	public String webfolderFileHistory(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {       
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		//Get list of companies
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(j++, vo);
			}
		}		

		model.addAttribute("list", resultList);
		model.addAttribute("primary", userInfo.getPrimary());
		model.addAttribute("userCompany", userInfo.getCompanyID());
        
		return "admin/ezWebFolder/webfolderFileHistory";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/saveConfig.do", method = RequestMethod.POST)
	public void saveConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {       
		logger.debug("saveConfig is running!");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
        
		String personalLimit = request.getParameter("pLimitVal") != null ? request.getParameter("pLimitVal") : "";
		String uploadLimit   = request.getParameter("uLimitVal") != null ? request.getParameter("uLimitVal") : "";
		String companyId     = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		
		logger.debug("personalLimit: " + personalLimit + " || uploadLimit: " + uploadLimit + " || companyId: " + companyId);
		
		if (personalLimit.equals("") || uploadLimit.equals("") || companyId.equals("")) {
			logger.debug("saveConfig illegal arguments!");
			return;
		}
		
		try {
			ezWebFolderAdminService.saveConfig(personalLimit, uploadLimit, companyId, userInfo.getTenantId());
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("saveConfig finishes!");
	}
	
	@RequestMapping(value="/admin/ezWebFolder/getConfig.do", method = RequestMethod.POST)	
	public String getConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {       
		logger.debug("getConfig is running!");		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);    
		String companyId = request.getParameter("companyId");		
		WebfolderConfigVO webfolderConfig = ezWebFolderAdminService.getWebfolderConfig(companyId, userInfo.getTenantId());
		model.addAttribute("webfolderConfig", webfolderConfig);
		
		logger.debug("getConfig finishes!");
		
		return "json";
	}	
	
	@RequestMapping(value="/admin/ezWebFolder/getCapacities.do", method = RequestMethod.POST)	
	public String getCapacities(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {     			
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int currPage  = Integer.parseInt(request.getParameter("currentPage"));
		String searchStr = request.getParameter("searchStr");
		String searchOpt = request.getParameter("searchOpt");
		String companyId = request.getParameter("companyId");
		int totalUsers = 0;
		int totalPages = 0;
		int pageSize = 10;
		
		List<UserCapacityVO> listUserCapacity = ezWebFolderAdminService.getListUserCapacity(companyId, searchStr, searchOpt, userInfo.getTenantId(), userInfo.getPrimary());
		
		for(UserCapacityVO capacity: listUserCapacity) {
			if (capacity.getTotalUsed().equals("0")) {
				capacity.setUsedRate(0);
			}
			else {
				double totalCapKB = Integer.parseInt(capacity.getTotalCapacity()) * 1048576.0;
				capacity.setUsedRate(Integer.parseInt(capacity.getTotalUsed())/totalCapKB);
			}
		}
		
		//Paging
		totalUsers = listUserCapacity.size();
		totalPages = (totalUsers + pageSize - 1)/pageSize;
		List<UserCapacityVO> renderList = new ArrayList<UserCapacityVO>();
		
		logger.debug("totalUsers: " + totalUsers + " || TotalPages: " + totalPages + " || CurrPage: " + currPage);

		if (totalPages == 0 || totalPages == 1) {
			model.addAttribute("capacityList", listUserCapacity);
		}
		else {
			if (currPage < totalPages) {				
				int startPoint = (currPage - 1) * pageSize;
				int endPoint = currPage * pageSize;
				renderList = listUserCapacity.subList(startPoint, endPoint);	
				model.addAttribute("capacityList", renderList);
			}
			else {
				if (currPage > totalPages) {
					currPage = totalPages;
				}
				int startPoint = (currPage - 1) * pageSize;
				int endPoint = totalUsers;				
				
				renderList = listUserCapacity.subList(startPoint, endPoint);
				model.addAttribute("capacityList", renderList);
			}
		}
		
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("totalUsers", totalUsers);		
		return "json";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/updateCapacities.do", method = RequestMethod.POST)
	public void updateCapacities(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestParam(value = "userListParam") List<String> userList, HttpServletResponse response) throws Exception {       
		LoginVO userInfo       = commonUtil.userInfo(loginCookie);        
		String newStorageValue = request.getParameter("newStorage");
		String companyId       = request.getParameter("companyId");
		
		try {
			for (String userId : userList) {
				ezWebFolderAdminService.updateNewAmount(userId, newStorageValue, companyId, userInfo.getTenantId());
			}			
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value="/admin/ezWebFolder/restoreCapacities.do", method = RequestMethod.POST)
	public void restoreCapacities(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestParam(value = "userListParam") List<String> userList, HttpServletResponse response) throws Exception {       
		LoginVO userInfo       = commonUtil.userInfo(loginCookie);		
		String companyId       = request.getParameter("companyId");
		String totalAmount     = "0";
		
		try {
			WebfolderConfigVO webfolderConfig = ezWebFolderAdminService.getWebfolderConfig(companyId, userInfo.getTenantId());
			if (webfolderConfig != null) {
				totalAmount = webfolderConfig.getTotalLimit();
			}
			
			for (String userId : userList) {
				ezWebFolderAdminService.updateNewAmount(userId, totalAmount, companyId, userInfo.getTenantId());
			}			
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value="/admin/ezWebFolder/getFileLogs.do", method = RequestMethod.POST)	
	public String getFileLogs(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {     			
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int currPage  = Integer.parseInt(request.getParameter("currentPage"));
		String companyId = request.getParameter("companyId");
		String offset = userInfo.getOffset();
		
		int totalRows = 0;
		int totalPages = 0;
		int pageSize = 10;
		
		List<FileLogVO> listFileLogs = ezWebFolderAdminService.getListFileLogs(companyId, offset, userInfo.getTenantId());
		
		//Paging
		if (listFileLogs != null) {
			totalRows  = listFileLogs.size();
		}
		
		totalPages = (totalRows + pageSize - 1)/pageSize;
		List<FileLogVO> renderList = new ArrayList<FileLogVO>();
		
		logger.debug("totalUsers: " + totalRows + " || TotalPages: " + totalPages + " || CurrPage: " + currPage);

		if (totalPages == 0 || totalPages == 1) {
			model.addAttribute("fileLogList", listFileLogs);
		}
		else {
			if (currPage < totalPages) {				
				int startPoint = (currPage - 1) * pageSize;
				int endPoint = currPage * pageSize;
				renderList = listFileLogs.subList(startPoint, endPoint);	
				model.addAttribute("fileLogList", renderList);
			}
			else {
				if (currPage > totalPages) {
					currPage = totalPages;
				}
				int startPoint = (currPage - 1) * pageSize;
				int endPoint = totalRows;				
				
				renderList = listFileLogs.subList(startPoint, endPoint);
				model.addAttribute("fileLogList", renderList);
			}
		}
		
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("totalRows", totalRows);
		return "json";
	}
	
	
}
