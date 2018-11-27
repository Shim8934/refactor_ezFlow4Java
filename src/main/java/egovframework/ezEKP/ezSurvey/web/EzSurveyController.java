package egovframework.ezEKP.ezSurvey.web;

import java.io.File;
import java.util.List;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezSurvey.service.EzSurveyRestService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@SuppressWarnings("unchecked")
@Controller
public class EzSurveyController extends EgovFileMngUtil {
	private static final Logger logger = LoggerFactory.getLogger(EzSurveyController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzSurveyRestService surveyRestService;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@RequestMapping(value = "/ezSurvey/surveyMain.do")
	public String jspGetSurveyMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) {
		logger.debug("jspGetSurveyMain started");
		logger.debug("jspGetSurveyMain ended");
		return "ezSurvey/mainmenu/surveyMain";
	}
	
	@RequestMapping(value="/ezSurvey/surveyLeft.do")
	public String jspGetSurveyLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		logger.debug("jspGetSurveyLeft started");
		
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		logger.debug("jspGetSurveyLeft ended");
		return "ezSurvey/mainmenu/surveyLeft";
	}
	
	@RequestMapping(value="/ezSurvey/surveyConfig.do")
	public String jspGetSurveyConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetSurveyConfig started");
		logger.debug("jspGetSurveyConfig ended");
		return "ezSurvey/config/surveyConfig";
	}
	
	
	@RequestMapping(value="/ezSurvey/surveyGeneral.do")
	public String jspGetSurveyGeneral(@CookieValue("loginCookie") String loginCookie,  HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetSurveyGeneral started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
/*		JSONObject resultObj = cabinetRestService.getUserPreviewConfig(request, user.getId());
		
		if (resultObj.get("status").toString().equals("ok")) {
			JSONObject userConfig = (JSONObject)resultObj.get("config");
			model.addAttribute("config", userConfig);
		}*/
		
		logger.debug("jspGetSurveyGeneral ended");
		return "ezSurvey/config/surveyGeneral";
	}
	
	@RequestMapping(value="/ezSurvey/surveyList.do")
	public String jspGetSurveyList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetSurveyList started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		/*String cabinetId   = request.getParameter("cabinetId");
		
		JSONObject resultObj = cabinetRestService.getCabinetInfo(request, user.getId(), cabinetId);
		
		if (resultObj.get("status").toString().equals("ok")) {
			JSONObject cabinet = (JSONObject) resultObj.get("cabinet");
			model.addAttribute("cabinet", cabinet);
		}
		
		JSONObject configObj = cabinetRestService.getUserPreviewConfig(request, user.getId());
		
		if (configObj.get("status").toString().equals("ok")) {
			JSONObject userConfig = (JSONObject)configObj.get("config");
			model.addAttribute("config", userConfig);
		}
		
		model.addAttribute("cabinetId", cabinetId);*/
		logger.debug("jspGetSurveyList ended");
		return "ezSurvey/listmenu/surveyList";
	}
	
	@RequestMapping(value="/ezSurvey/createSurvey.do")
	public String jspGetCreateSurveyPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetCreateSurveyPage started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		logger.debug("jspGetCreateSurveyPage ended");
		return "ezSurvey/listmenu/surveyCreate";
	}
	
	@RequestMapping(value="/ezSurvey/addQuestionPage.do")
	public String jspAddQuestionPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspAddQuestionPage started");
		
		logger.debug("jspAddQuestionPage ended");
		return "ezSurvey/listmenu/questionCreate";
	}
	
	@RequestMapping(value="/ezSurvey/statisticsPage.do")
	public String jspStatisticsPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspStatisticsPage started");
		
		logger.debug("jspStatisticsPage ended");
		return "ezSurvey/listmenu/statistics";
	}
	
	@RequestMapping(value="/ezSurvey/selectUsers.do")
	public String jspGetSelectUesrPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetSelectUesrPage started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		JSONObject result = surveyRestService.getUserListType(request, user.getId());
		if (result.get("status").toString().equals("ok")) {
			String listType = (String)result.get("listType");
			model.addAttribute("listType", listType);
		}
		
		logger.debug("jspGetSelectUesrPage ended");
		return "ezSurvey/user/selectUser";
	}
	
	@RequestMapping(value="/ezSurvey/getCompanyTree.do")
	@ResponseBody
	public String jsonGetCompanyTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String companyId       = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		JSONObject resultObj   = new JSONObject();
		
		resultObj = surveyRestService.getCompanyTree(request, userInfo.getId(), companyId);
		
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/getSubNodes.do")
	@ResponseBody
	public String jsonGetSubNodes(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		logger.debug("jsonGetSubNodes started");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String deptId          = request.getParameter("nodeId") != null ? request.getParameter("nodeId") : "";
		String level           = request.getParameter("level")  != null ? request.getParameter("level")  : "";
		JSONObject resultObj   = new JSONObject();
		
		if (deptId.equals("") || level.equals("")) {
			logger.debug("Parameter error");
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = surveyRestService.getDeptSubNodes(request, userInfo.getId(), deptId, level);
		logger.debug("jsonGetSubNodes ended");
		
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/getDeptMembers.do", method=RequestMethod.POST)
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
		
		resultObj = surveyRestService.getDeptMembers(request, user.getId(), deptId, currentPage);
		
		logger.debug("jsonGetDeptMembers ended");
		logger.debug(resultObj.toString());
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/getSearchMember.do", method=RequestMethod.POST)
	@ResponseBody
	public String jsonGetSearchMember(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("jsonGetSearchMember started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String srchOption  = request.getParameter("srchOption")  != null  ? request.getParameter("srchOption") : "";
		String srchValue   = request.getParameter("srchValue")   != null  ? request.getParameter("srchValue")  : "";
		String currentPage = request.getParameter("currentPage") != null ? request.getParameter("currentPage") : "";
		
		logger.debug("srchOption: " + srchOption + " || srchValue: " + srchValue + " || currentPage: " + currentPage);
		
		JSONObject resultObj = new JSONObject();
		
		if (srchOption.equals("") || srchValue.equals("") || currentPage.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = surveyRestService.getSearchMember(request, user.getId(), srchOption, srchValue, currentPage);
		
		logger.debug("jsonGetSearchMember ended");
		logger.debug(resultObj.toString());
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/uploadAttachFile.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonUploadFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("Upload file is running!");
		LoginSimpleVO userInfo         = commonUtil.userInfoSimple(loginCookie);
		List<MultipartFile> multiFiles = request.getFiles("fileToUpload");
		JSONObject resultObj           = new JSONObject();
		
		if (multiFiles.size() == 0) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = surveyRestService.uploadAttachFile(request, userInfo.getId(), multiFiles);
		
		logger.debug("Upload file finishes!");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/deleteAttachFile.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonDeleteFile(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("Delete file is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String filePath        = request.getParameter("filePath") != null ? request.getParameter("filePath") : "";
		JSONObject resultObj   = new JSONObject();
		
		if (filePath.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = surveyRestService.deleteAttachFile(request, userInfo.getId(), filePath);
		
		logger.debug("Delete file finishes!");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/downloadAttachFile", produces="application/zip")
	public void responeDownloadFile(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("responeDownloadFile is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String filePath        = request.getParameter("filePath") != null ? request.getParameter("filePath") : "";
		String fileName        = request.getParameter("fileName") != null ? request.getParameter("fileName") : "";
		
		if (filePath.equals("") || fileName.equals("")) {
			logger.debug("Invalid arguments!!!");
			return;
		}
		
		surveyRestService.downloadAttachFile(request, response, userInfo.getId(), filePath, fileName);
		
		logger.debug("responeDownloadFile finishes!");
	}
	
	@RequestMapping(value = "/ezSurvey/uploadFile.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String uploadFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletResponse response) throws Exception {		
		logger.debug("Upload file is running!");		
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
        }    */       
        
        String pDirPath = commonUtil.getUploadPath("upload_vote.ROOT", loginSimpleVO.getTenantId());
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
            } 
            else {
				writeUploadedFile(multiFile.get(i), newFileName, pDirPath + "uploadFile");
				strXML.append("<DATA><![CDATA[" + newFileName + "/" + pFileName[i] + "/" + fileSize[i] + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[]]></DATA2>");
				strXML.append("<DATA3><![CDATA[OK]]></DATA3>");
            }
        }
        strXML.append("</NODES></ROOT>");        
       
        logger.debug("Upload file finishes!");        
        return strXML.toString();
    }
}
