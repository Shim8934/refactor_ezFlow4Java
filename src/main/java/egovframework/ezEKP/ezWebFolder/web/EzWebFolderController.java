package egovframework.ezEKP.ezWebFolder.web;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzWebFolderController extends EgovFileMngUtil {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "egovMessageSource")
    private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderController.class);	
	
	@RequestMapping(value = "/ezWebFolder/webfolderMain.do")
	public String webfolderMain(HttpServletRequest req, Model model) {
/*		String func = "";
		String subFunc = "";

		if (req.getParameter("func") != null && !req.getParameter("func").equals("")) {
			func = req.getParameter("func");	
		}
		if (req.getParameter("subFunc") != null && !req.getParameter("subFunc").equals("")) {
			subFunc = req.getParameter("subFunc");	
		}
		
		model.addAttribute("func", func);
		model.addAttribute("subFunc", subFunc);*/
		
		return "ezWebFolder/webfolderMain";
	}
	
	@RequestMapping(value="/ezWebFolder/webfolderLeft.do")
	public String webfolderLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap modelMap, LoginVO userInfo, HttpServletResponse response) throws Exception{       
        userInfo = commonUtil.userInfo(loginCookie);
        //Add more function here
        
        
		return "ezWebFolder/webfolderLeft";
	}
	
	@RequestMapping(value="/ezWebFolder/test.do")
	public String webfolderTest(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap modelMap, LoginVO userInfo, HttpServletResponse response) throws Exception{       
        userInfo = commonUtil.userInfo(loginCookie);
        //Add more function here
        
        
		return "ezWebFolder/webfolderTest";
	}
	
	@RequestMapping(value = "/ezWebFolder/uploadFile.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String uploadFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, HttpServletResponse response) throws Exception {		
		logger.debug("Upload file is running!");		
		LoginVO user = commonUtil.userInfo(loginCookie);		
		List<MultipartFile> multiFile = request.getFiles("fileToUpload");
		String folderId = request.getParameter("folderId"); //baonk 2018/01/16
		int cnt = multiFile.size();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String realPath = request.getServletContext().getRealPath("");
		String[] pFileName = new String[cnt];
        Long[] fileSize = new Long[cnt];        
        String[] resultUpload = new String[cnt];
        String[] sGUID = new String[cnt];
        //String[] pUploadSN = new String[cnt];        
        String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", user.getTenantId());

        for (int i = 0; i < cnt; i++) {
            resultUpload[i] = "false";
            sGUID[i] = UUID.randomUUID().toString();
            //pUploadSN[i] = "{" + sGUID[i] + "}";
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
        
        String pDirPath = commonUtil.separator + "fileroot" + commonUtil.separator + user.getTenantId() + commonUtil.separator + "webfolder";        		
        pDirPath = realPath + pDirPath;
        
        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
        
        File file = new File(pDirPath);

        if (!file.exists()) {
        	file.mkdir();        
        }

        StringBuffer strXML = new StringBuffer();
        strXML.append("<ROOT><NODES>");
        
        for (int i = 0; i < cnt; i++) {        	
        	fileSize[i] = multiFile.get(i).getSize();
            String extend = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
            //String newFileName = pUploadSN[i] + "." + extend;
            
            if (useExtension.toLowerCase().indexOf(extend.toLowerCase()) == -1 && !useExtension.equals("*")) {           	
				strXML.append("<DATA><![CDATA[" + pFileName[i] + "/" + fileSize[i] + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[]]></DATA2>");
				strXML.append("<DATA3><![CDATA[denied]]></DATA3>");
            } 
            else {
            	try {
            		writeUploadedFile(multiFile.get(i), pFileName[i], pDirPath);
            		//Save to database
            		Date date = new Date();
            		FileVO fileVO = new FileVO();
            		
            		fileVO.setCreatedDate(formatter.format(date));
            		fileVO.setUpdatedDate(fileVO.getCreatedDate());
            		fileVO.setFileExt(extend);
            		fileVO.setFileName(pFileName[i]);
            		fileVO.setFileFavourite("0");
            		fileVO.setFilePath(pDirPath + "." + extend);
            		fileVO.setFileSize(getFileSize(fileSize[i]));
            		fileVO.setFolderId(folderId);
            		fileVO.setTenantId(user.getTenantId());
            		fileVO.setUploaderId(user.getId());
            		
            		if (user.getPrimary().equals("1")) {
            			fileVO.setUploaderName(user.getDisplayName1());
            		}
            		else {
            			fileVO.setUploaderName(user.getDisplayName2());
            		}
            		
            		
            		
            		
            		strXML.append("<DATA><![CDATA[" + pFileName[i] + "/" + fileSize[i] + "]]></DATA>");
    				strXML.append("<DATA2><![CDATA[]]></DATA2>");
    				strXML.append("<DATA3><![CDATA[OK]]></DATA3>");
            	}
            	catch (Exception e) {
            		e.printStackTrace();
    				strXML.append("<DATA><![CDATA[" + pFileName[i] + "/" + fileSize[i] + "]]></DATA>");
    				strXML.append("<DATA2><![CDATA[]]></DATA2>");
    				strXML.append("<DATA3><![CDATA[denied]]></DATA3>");
            	}				
            }
        }
        strXML.append("</NODES></ROOT>");              
        
       
        logger.debug("Upload file finishes!");        
        return strXML.toString();
    }
	
	private String getFileSize(long fileSize) {
		String fileSize_ = "";
		
        if (fileSize / 1024 / 1024 >= 1) {
        	fileSize_ = String.format("%.2f", (double)(fileSize / 1024 / 1024 * 10) / 10);
        	fileSize_ = fileSize_ + "MB";
        }
        else if (fileSize / 1024 >= 1) {
        	fileSize_ = String.format("%.2f", (double)(fileSize / 1024));
        	fileSize_ = fileSize_ + "KB";
        }
        else {
        	fileSize_ = fileSize + "B";
        }
        
        return fileSize_;
	}
	
}
