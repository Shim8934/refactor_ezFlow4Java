package egovframework.ezEKP.ezEditor.web;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.util.Base64;
import java.util.UUID;
import java.util.Base64.Decoder;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/** 
 * @Description [Controller] 에디터
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 *
 *    수정일               수정자         수정내용
 *    ----------    ------    -------------------
 *    2017.05.23    이효민         신규작성
 *
 * @see
 */
@Controller
public class EzEditorController extends EgovFileMngUtil{
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzEditorController.class);
	
	/**
	 * editor 호출 Method
	 */
	@RequestMapping(value="/ezEditor/selectEditor.do")
	public String mailSelectEditor(
			@CookieValue("loginCookie") String loginCookie,
			HttpServletRequest request,
			LoginVO userInfo, 
			Model model) throws Exception{
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String type = request.getParameter("type");
		String height = request.getParameter("height");
		String id = request.getParameter("id");
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String returnPath = "";
		
		switch (useEditor) {
			/* 2017-05-23 이효민 : DEXT, NAMO 추후 개발
			case "DEXT":
				model.addAttribute("id", id);
				returnPath = "ezEditor/dextEditor";
	            break;
			case "NAMO":
				returnPath = "ezEditor/namoEditor";
                break; */
			case "TAGFREE":
				returnPath = "ezEditor/tfxEditor";
				break;
			default :
				returnPath = "ezEditor/ckEditor";
				break;
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("type", type);
		model.addAttribute("height", height);
		
		return returnPath;
	}
	
	/**
	 * ck에디터 이미지 업로드 화면 호출 Method
	 */
	@RequestMapping(value = "/ezEditor/ckImageUpload.do")
	public String ckImageUpload() {
		return "ezEditor/ckImageUpload";
	}
	
	/**
	 * ck에디터 업로드 실행 Method
	 */
	@RequestMapping(value = "/ezEditor/ckUpload.do")
	public String ckUpload(@CookieValue("loginCookie")String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception {
		logger.debug("ckUpload started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		MultipartFile multiFile = request.getFile("file1");
		String fileType = multiFile.getContentType().replace("\\", "/").split("/")[1];
		String filePath = commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		String today = EgovDateUtil.getToday("");
		String fileName = UUID.randomUUID() + "." + fileType;
		
		filePath = filePath + commonUtil.separator + today;
		File file = new File(realPath + filePath);
		if (!file.exists()) {
			file.mkdirs();
		}
		
		int width = 0;
		int height = 0;
		
		writeUploadedFile(multiFile, fileName, realPath + filePath);
		
		File imageFile = new File(realPath + filePath + commonUtil.separator + fileName);			
		
		if (imageFile.exists()) {			
			BufferedImage bi = ImageIO.read(new File(realPath + filePath + commonUtil.separator + fileName));			    
			width = bi.getWidth();
			height = bi.getHeight();
		}
		
		model.addAttribute("imgPath", (filePath + commonUtil.separator + fileName +  "|!|" + width + "|!|" + height).replace("\\", "/"));

		logger.debug("ckUpload ended");
		return "ezEditor/ckUpload";
	}

	/**
	 * ck에디터 심플업로드 실행 Method
	 */
	
	@RequestMapping(value = "/ezEditor/ckSimpleUpload.do", produces = "application/json; charset=utf-8")
	@ResponseBody
	public String ckSimpleUpload(@CookieValue("loginCookie")String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception{
		logger.debug("ckSimpleUpload started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		MultipartFile multiFile = request.getFile("upload");
		String fileType = multiFile.getContentType().replace("\\", "/").split("/")[1];
		
		String filePath = commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		String today = EgovDateUtil.getToday("");
		String fileName = UUID.randomUUID() + "." + fileType;
		
		filePath = filePath + commonUtil.separator + today;
		File file = new File(realPath + filePath);
		
		if (!file.exists()) {
			file.mkdirs();
		}
		
		writeUploadedFile(multiFile, fileName, realPath + filePath);
		//return "<script>window.parent.CKEDITOR.tools.callFunction(2, '" + (filePath + commonUtil.separator + fileName).replace("\\", "/") + "', '')</script>";
		logger.debug("ckSimpleUpload ended");
		return "{\"uploaded\": 1,\"fileName\": \""+fileName+"\", \"url\": \"" + (filePath + commonUtil.separator + fileName).replace("\\", "/") + "\"}";
	}
	
	/**
	 * 메일 서명관리 ck에디터 이미지 업로드 호출 Method
	 */
	@RequestMapping(value = "/ezEditor/ckImageUploadMail.do")
	public String ckImageUploadMail() {
		return "ezEditor/ckImageUploadMail";
	}

	/**
	 * 메일 서명관리 ck에디터 업로드 실행 Method
	 */
	@RequestMapping(value = "/ezEditor/ckUploadMail.do")
	public String ckUploadMail(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception{
		logger.debug("ckUploadMail started.");
		
		MultipartFile multiFile = request.getFile("file1");
		String fileType = multiFile.getContentType().replace("\\", "/").split("/")[1];

		String realPath = commonUtil.getRealPath(request);
		String today = EgovDateUtil.getToday("");
		String fileName = UUID.randomUUID() + "." + fileType;
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String filePath = commonUtil.getUploadPath("upload_mail.SIGNIMGS", userInfo.getTenantId());
		filePath = filePath + commonUtil.separator + today;
		File file = new File(realPath + filePath);
		if (!file.exists()) {
			file.mkdirs();
		}

		int width = 0;
		int height = 0;

		writeUploadedFile(multiFile, fileName, realPath + filePath);

		File imageFile = new File(realPath + filePath + commonUtil.separator + fileName);			

		if (imageFile.exists()) {			
			BufferedImage bi = ImageIO.read(new File(realPath + filePath + commonUtil.separator + fileName));			    
			width = bi.getWidth();
			height = bi.getHeight();
		}
		
		String imgPath = (filePath + commonUtil.separator + fileName +  "|!|" + width + "|!|" + height).replace("\\", "/");
		
		model.addAttribute("imgPath", imgPath);
		
		logger.debug("imgPath=" + imgPath);
		logger.debug("ckUploadMail ended.");
		
		return "ezEditor/ckUploadMail";
	}
	
	/**
	 * 메일 서명관리 ck에디터 심플업로드 실행 Method
	 */
	@RequestMapping(value = "/ezEditor/ckSimpleUploadMail.do", produces = "application/json; charset=utf-8")
	@ResponseBody
	public String ckSimpleUploadMail(@CookieValue("loginCookie")String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception{
		logger.debug("ckSimpleUploadMail started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		MultipartFile multiFile = request.getFile("upload");
		String fileType = multiFile.getContentType().replace("\\", "/").split("/")[1];
		
		String filePath = commonUtil.getUploadPath("upload_mail.SIGNIMGS", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		String today = EgovDateUtil.getToday("");
		String fileName = UUID.randomUUID() + "." + fileType;
		
		filePath = filePath + commonUtil.separator + today;
		File file = new File(realPath + filePath);
		
		if (!file.exists()) {
			file.mkdirs();
		}
		
		writeUploadedFile(multiFile, fileName, realPath + filePath);
		
		logger.debug("ckSimpleUploadMail ended");
		return "{\"uploaded\": 1,\"fileName\": \""+fileName+"\", \"url\": \"" + (filePath + commonUtil.separator + fileName).replace("\\", "/") + "\"}";
	}
	
	/**
	 * TagFree에디터 업로드 실행 Method
	 */
	@RequestMapping(value = "/ezEditor/tfxUpload.do")
	public String tfxUpload(@CookieValue("loginCookie")String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		MultipartFile multiFile = request.getFile("FILE_PATH");
		
		String fileType = multiFile.getContentType().replace("\\", "/").split("/")[1];
		String filePath = commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		String today = EgovDateUtil.getToday("");
		String fileName = UUID.randomUUID() + "." + fileType;
		
		filePath = filePath + commonUtil.separator + today;
		File file = new File(realPath + filePath);
	    if (!file.exists()) {
	    	file.mkdirs();
	    }
		
		writeUploadedFile(multiFile, fileName, realPath + filePath);
		
		model.addAttribute("sContentType", request.getParameter("content_type"));
		model.addAttribute("sUploadedPath", filePath + commonUtil.separator + fileName);
		
		return "ezEditor/tfxUpload";
	}
	
	/**
	 * TagFree에디터 심플업로드(drag&drop) 실행 Method
	 */
	@RequestMapping(value = "/ezEditor/tfxSimpleUpload.do")
	public String tfxSimpleUpload(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("tfxSimpleUpload started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String fileData = request.getParameter("clip_contents");
		String fileType = request.getParameter("file_extension");
		String rootId = request.getParameter("xfe_root_id");
		String resultCode = "0";
		
		if (fileData == null) { //이미지가 너무 큰 경우 fileData가 null로 들어옴(tomcat server.xml의 maxPostSize설정에 따라 이미지 최대 업로드 사이즈 조절 가능함.)
			logger.debug("The file size is too big.");
			resultCode = "1";
			
		} else if (fileData.startsWith("data:")) { //이미지 파일이 아닌경우 fileData앞에 data:이 붙음.
			logger.debug("The file is not image.");
			resultCode = "2";
			
		} else {
			logger.debug("fileType=" + fileType + ", rootId=" + rootId);
			
			String filePath = commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId());
			String realPath = commonUtil.getRealPath(request);
			String today = EgovDateUtil.getToday("");
			String fileName = UUID.randomUUID() + "." + fileType;

			filePath = filePath + commonUtil.separator + today;
			File file = new File(realPath + filePath);

			if (!file.exists()) {
				file.mkdirs();
			}
			
			FileOutputStream fileOuputStream = null;
			
			try {
				Decoder decoder = Base64.getDecoder();
				byte[] imageByte = decoder.decode(fileData);
				fileOuputStream = new FileOutputStream(realPath + filePath + commonUtil.separator + fileName); 
				fileOuputStream.write(imageByte);
				fileOuputStream.flush();
				
				logger.debug("rootId=" + rootId + ", sUploadedPath=" + filePath + commonUtil.separator + fileName);
				
				model.addAttribute("sRootId", rootId);
				model.addAttribute("sUploadedPath", filePath + commonUtil.separator + fileName);
				
			} catch (Exception e) {
				e.printStackTrace();
				
				resultCode = "1";
			} finally {
				try {
					fileOuputStream.close();
				} catch (Exception e2) {
				}
			}
			
		}
		
		model.addAttribute("resultCode", resultCode);
		
		logger.debug("tfxSimpleUpload ended. resultCode=" + resultCode);
		return "ezEditor/tfxSimpleUpload";
	}
	
	/**
	 * 메일 서명관리 TagFree에디터 업로드 실행 Method
	 */
	@RequestMapping(value = "/ezEditor/tfxUploadMail.do")
	public String tfxUploadMail(@CookieValue("loginCookie")String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception{
		logger.debug("tfxUploadMail started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		MultipartFile multiFile = request.getFile("FILE_PATH");
		String contentType = request.getParameter("content_type");
		
		String fileType = multiFile.getContentType().replace("\\", "/").split("/")[1];
		String filePath = commonUtil.getUploadPath("upload_mail.SIGNIMGS", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		String today = EgovDateUtil.getToday("");
		String fileName = UUID.randomUUID() + "." + fileType;
		
		filePath = filePath + commonUtil.separator + today;
		File file = new File(realPath + filePath);
	    if (!file.exists()) {
	    	file.mkdirs();
	    }
		
		writeUploadedFile(multiFile, fileName, realPath + filePath);
		
		model.addAttribute("sContentType", contentType);
		model.addAttribute("sUploadedPath", filePath + commonUtil.separator + fileName);
		
		logger.debug("tfxUploadMail ended. contentType=" + contentType + ", sUploadedPath=" + filePath + commonUtil.separator + fileName);
		return "ezEditor/tfxUpload";
	}
	
	/**
	 * 메일 서명관리 TagFree에디터 심플업로드(drag&drop) 실행 Method
	 */
	@RequestMapping(value = "/ezEditor/tfxSimpleUploadMail.do")
	public String tfxSimpleUploadMail(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("tfxSimpleUploadMail started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String fileData = request.getParameter("clip_contents");
		String fileType = request.getParameter("file_extension");
		String rootId = request.getParameter("xfe_root_id");
		String resultCode = "0";
		
		if (fileData == null) { //이미지가 너무 큰 경우 fileData가 null로 들어옴(tomcat server.xml의 maxPostSize설정에 따라 이미지 최대 업로드 사이즈 조절 가능함.)
			logger.debug("The file size is too big.");
			resultCode = "1";
			
		} else if (fileData.startsWith("data:")) { //이미지 파일이 아닌경우 fileData앞에 data:이 붙음.
			logger.debug("The file is not image.");
			resultCode = "2";
			
		} else {
			logger.debug("fileType=" + fileType + ", rootId=" + rootId);
			
			String filePath = commonUtil.getUploadPath("upload_mail.SIGNIMGS", userInfo.getTenantId());
			String realPath = commonUtil.getRealPath(request);
			String today = EgovDateUtil.getToday("");
			String fileName = UUID.randomUUID() + "." + fileType;

			filePath = filePath + commonUtil.separator + today;
			File file = new File(realPath + filePath);

			if (!file.exists()) {
				file.mkdirs();
			}
			
			FileOutputStream fileOuputStream = null;
			
			try {
				Decoder decoder = Base64.getDecoder();
				byte[] imageByte = decoder.decode(fileData);
				fileOuputStream = new FileOutputStream(realPath + filePath + commonUtil.separator + fileName); 
				fileOuputStream.write(imageByte);
				fileOuputStream.flush();
				
				logger.debug("rootId=" + rootId + ", sUploadedPath=" + filePath + commonUtil.separator + fileName);
				
				model.addAttribute("sRootId", rootId);
				model.addAttribute("sUploadedPath", filePath + commonUtil.separator + fileName);
				
			} catch (Exception e) {
				e.printStackTrace();
				
				resultCode = "1";
			} finally {
				try {
					fileOuputStream.close();
				} catch (Exception e2) {
				}
			}
			
		}
		
		model.addAttribute("resultCode", resultCode);
		
		logger.debug("tfxSimpleUploadMail ended. resultCode=" + resultCode);
		return "ezEditor/tfxSimpleUpload";
	}
	
	/**
	 * 메일 부재중설정 TagFree에디터 심플업로드(drag&drop) 시 아무처리 안하는 Method
	 */
	@RequestMapping(value = "/ezEditor/tfxNoop.do")
	public String tfxNoop(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("tfxNoop started");
		
		model.addAttribute("resultCode", "3");
		
		return "ezEditor/tfxSimpleUpload";
	}
	
}