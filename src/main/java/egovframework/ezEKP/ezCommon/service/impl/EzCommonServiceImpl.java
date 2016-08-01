package egovframework.ezEKP.ezCommon.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.ezEKP.ezCommon.dao.EzCommonDAO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;

@Service("EzCommonService")
public class EzCommonServiceImpl implements EzCommonService {
	
	@Resource(name = "EzCommonDAO")
	private EzCommonDAO ezCommonDAO;
	
	@Override
	public String getContentInfo(String type, String itemID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PTYPE", type);
		map.put("v_PID", itemID);
		return ezCommonDAO.getContentInfo(map);
	}

	@Override
	public BoardAttachVO getAttachInfo(String type, String attID, String mode, int sn, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PTYPE", type);
		map.put("v_PID", attID);
		map.put("v_PMODE", mode);
		map.put("v_PATTACHFILESN", sn);
		map.put("v_PCOMPANYID", companyID);
		return ezCommonDAO.getAttachInfo(map);
	}

	@Override
	public void responseAttach(String pPhysicalFilePath, String pFileName, boolean pAttachment, HttpServletRequest request, HttpServletResponse response) throws Exception{
        String isUTF8 = "0";

        for(Cookie cookie : request.getCookies()) {
        	if(cookie.getName().equals("UTF8_Option")){
        		isUTF8 = cookie.getValue();
        	}
        }
        
        String realPath = request.getServletContext().getRealPath("");
        String filePath = pPhysicalFilePath;        
        String fileName = pFileName;
        String fileExt = "";
        
        if (fileName.lastIndexOf(".") > -1) {
            fileExt = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
        }
        fileName = getProperFileName(fileName, fileExt, isUTF8);
        boolean bAttachment = false;
        
        if (pAttachment) {
            switch (fileExt) {
                case ".eml":
                case ".mht":
                case ".xls":
                case ".doc":
                case ".pdf":
                case ".hwp":
                case ".ppt":
                case ".docx":
                case ".pptx":
                case ".xlsx":
                case ".rtf":
                case ".jpg":
                case ".gif":
                case ".bmp":
                case ".wmv":
                case ".avi":
                case ".mp4":
                case ".mpeg":
                    bAttachment = true;
                    break;
                default:
                    bAttachment = false;
                    break;
            }
            bAttachment = true;
        }
        
        FileInputStream is = null;
        String usebrowser = (request.getHeader("User-Agent")==null||request.getHeader("User-Agent")=="") ? "NONE" : request.getHeader("User-Agent").indexOf("MSIE") > -1 ?
                            "IE" : request.getHeader("User-Agent").indexOf("Trident") > -1 ? "IE" : "NONE";

        if (bAttachment) {
            if (isUTF8 == "0" && usebrowser == "IE") {
                response.addHeader("Content-Disposition", "attachment;filename=\"" + URLEncoder.encode((fileName).replace("+", "%20"),"UTF-8") + "\"");
            } else if (isUTF8 == "0" && usebrowser != "IE") {
                response.addHeader("Content-Disposition", "attachment;filename=\"" + (fileName) + "\"");
            } else {
                response.addHeader("Content-Disposition", "attachment;filename=\"" + URLEncoder.encode((fileName).replace("+", "%20"), "UTF-8") + "\"");
            }
        } else {
            if (isUTF8 == "0" && usebrowser == "IE") {
                response.addHeader("Content-Disposition", "inline;filename=\"" + URLEncoder.encode((fileName).replace("+", "%20"), "UTF-8") + "\"");
            } else if (isUTF8 == "0" && usebrowser != "IE") {
                response.addHeader("Content-Disposition", "inline;filename=\"" + URLEncoder.encode((fileName).replace("+", "%20"), "UTF-8") + "\"");
            } else {
                response.addHeader("Content-Disposition", "inline;filename=\"" + URLEncoder.encode((fileName).replace("+", "%20"), "UTF-8") + "\"");
            }
        }

        if (fileExt == ".pdf") {
            response.setContentType("application/pdf");
        } else {
            response.setContentType("application/octet-stream");
        }
                
        try {
	        filePath = realPath + filePath;
	        File file = new File(filePath);
	        is = new FileInputStream(file);
	        
	        IOUtils.copy(is,response.getOutputStream());
        } catch(Exception e) {
        	
        } finally {
        	if (is != null) {
        		is.close();
        	}
        }       
        
	}
	
	@Override
	public String wpCountLoginTime(String userID) throws Exception {
		return ezCommonDAO.wpCountLoginTime(userID);
	}

	public String getProperFileName(String pOrgFileName, String pOrgFileExt, String pIsUTF8) throws Exception{
		int length = 0;
        int lengthLimit = 10000;
        String newFileName = "";

        if (pOrgFileExt != "")
        	pOrgFileName = pOrgFileName.substring(0, pOrgFileName.lastIndexOf("."));
        if (pOrgFileExt == ".doc" || pOrgFileExt == ".xls" || pOrgFileExt == ".ppt")
        	lengthLimit = 110;
        if (pIsUTF8 == "0")
        	length = URLEncoder.encode(pOrgFileName + pOrgFileExt,"UTF-8").replace("+", "%20").length();
        else
        	length = URLEncoder.encode(pOrgFileName + pOrgFileExt,"UTF-8").replace("+", "%20").length();

        if (length > lengthLimit){
            newFileName = pOrgFileName;
            while (length > lengthLimit){
                newFileName = newFileName.substring(0, newFileName.length() - 1);
                if (pIsUTF8 == "0") 
                	length = URLEncoder.encode(newFileName + pOrgFileExt,"UTF-8").replace("+", "%20").length();
                else 
                	length = URLEncoder.encode(newFileName + pOrgFileExt, "UTF-8").replace("+", "%20").length();
            }
            pOrgFileName = newFileName;
        }
        
        return pOrgFileName + pOrgFileExt;
	}
}
