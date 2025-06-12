package egovframework.ezEKP.ezEditor.web;

import java.awt.color.ColorSpace;
import java.awt.image.BufferedImage;
import java.awt.image.Raster;
import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.Base64.Decoder;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.UUID;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;
import javax.servlet.http.HttpServletRequest;

import egovframework.let.utl.fcc.service.EzFAL;
import org.apache.commons.io.IOUtils;
import org.json.simple.JSONArray;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.HandlerMapping;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;

/**
 * @Description [Controller] 에디터
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 *
 *               수정일 수정자 수정내용 ---------- ------ ------------------- 2017.05.23
 *               이효민 신규작성
 *
 * @see
 */
@Controller
public class EzEditorController extends EgovFileMngUtil {

	@Autowired
	private CommonUtil commonUtil;

	@Resource(name = "egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;

	private static final Logger logger = LoggerFactory.getLogger(EzEditorController.class);
	
	@Autowired
	private EzEmailService ezEmailService;
	/**
	 * editor 호출 Method
	 */
	@RequestMapping(value = {"/ezEditor/selectEditor.do", "/ezEditor/selectApprovalEditor.do"}, method = RequestMethod.GET)
	public String selectEditor(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception {

		userInfo = commonUtil.userInfo(loginCookie);

		String type = request.getParameter("type");
		String height = request.getParameter("height");
		String id = request.getParameter("id") == null ? "" : request.getParameter("id");
		String isUsed = request.getParameter("isUsed");
		String requestURL = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);

		// TODO: http/https 설정값
		String serverUrl = "http://" + userInfo.getServerName();
		logger.debug("serverUrl=" + serverUrl);

		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String useHTMLMode = ezCommonService.getTenantConfig("USE_HTMLMODE", userInfo.getTenantId());

		String defaultFontFamily = egovMessageSource.getMessage("main.t246", userInfo.getLocale());
		String defaultFontSize = "10pt";

		// editorFontStyle값이 있을 경우 editorFontStyle값 적용
		if (requestURL.indexOf("selectApprovalEditor.do") == -1) {
			String editorFontStyle = ezCommonService.getTenantConfig("editorFontStyle", userInfo.getTenantId());

			if (!editorFontStyle.equals("")) {
				defaultFontFamily = editorFontStyle.split("\\|")[0];
				defaultFontSize = editorFontStyle.split("\\|")[1];
			}
			
			// 사용자가 메일환경설정에서 설정한 값이 있으면 그 값을 사용하고, 없으면 관리자페이지에서 설정한 값 사용
			// 메일쓰기, 메일예약발송, 메일부재중설정, 메일서명관리(사용자단)에만 적용되도록 수정
			if (type != null && (type.equals("MAILWRITE") || type.equals("MAILOUTOFOFFICE") || type.equals("MAILSIGNATURE"))) {
				MailGeneralVO mailGeneralVO = ezEmailService.getMailGeneral(userInfo.getTenantId(), userInfo.getId()).get(0);
				String userFontFamily = mailGeneralVO.getEditorFontFamily();
				String userFontSize = mailGeneralVO.getEditorFontSize();
				if (userFontFamily != null && !userFontFamily.isEmpty()) {
					defaultFontFamily = userFontFamily;
				}
				if (userFontSize != null && !userFontSize.isEmpty()) {
					defaultFontSize = userFontSize;
				}
			}
		}

		String returnPath = "";

		switch (useEditor) {
		case "DEXT":
			model.addAttribute("id", id);
			returnPath = "ezEditor/dextEditor";
			break;
		case "NAMO":
			model.addAttribute("serverUrl", serverUrl);
			returnPath = "ezEditor/namoEditor";
			break;
		case "TAGFREE":
			returnPath = "ezEditor/tfxEditor";
			break;
		case "KUKUDOCS":
			returnPath = "ezEditor/kukudocsEditor";
			break;
		default:
			returnPath = "ezEditor/ckEditor";
			break;
		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useHTMLMode", useHTMLMode);
		model.addAttribute("type", type);
		model.addAttribute("height", height);
		model.addAttribute("isUsed", isUsed);
		model.addAttribute("defaultFontFamily", defaultFontFamily);
		model.addAttribute("defaultFontSize", defaultFontSize);

		return returnPath;
	}

	/**
	 * editor 호출 Method
	 */
	@RequestMapping(value = {"/admin/ezEditor/selectEditor.do", "/admin/ezEditor/selectApprovalEditor.do"}, method = RequestMethod.GET)
	public String adminSelectEditor(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception {

		userInfo = commonUtil.userInfo(loginCookie);

		String type = request.getParameter("type");
		type = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(type));
		String height = request.getParameter("height");
		height = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(height));
		String formID = request.getParameter("formID");
		formID = (formID == null || formID.equals("")) ? "editor1" : request.getParameter("formID");
		String requestURL = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);

		// TODO: http/https 설정값
		String serverUrl = "http://" + userInfo.getServerName();
		logger.debug("serverUrl=" + serverUrl);

		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String defaultFontFamily = egovMessageSource.getMessage("main.t246", userInfo.getLocale());
		String defaultFontSize = "13px";

		// 사용자 언어가 한국어이고 editorFontStyle값이 있을 경우 editorFontStyle값 적용
		
		if (userInfo.getLang().equals("1") && requestURL.indexOf("selectApprovalEditor.do") == -1) {
			String editorFontStyle = ezCommonService.getTenantConfig("editorFontStyle", userInfo.getTenantId());

			if (!editorFontStyle.equals("")) {
				defaultFontFamily = editorFontStyle.split("\\|")[0];
				defaultFontSize = editorFontStyle.split("\\|")[1];
			}
		}

		String returnPath = "";

		switch (useEditor) {
		case "DEXT":
			model.addAttribute("formID", formID);
			returnPath = "admin/ezEditor/dextEditor";
			break;
		case "NAMO":
			model.addAttribute("serverUrl", serverUrl);
			returnPath = "admin/ezEditor/namoEditor";
			break;
		case "TAGFREE":
			returnPath = "admin/ezEditor/tfxEditor";
			break;
		case "KUKUDOCS":
			returnPath = "admin/ezEditor/kukudocsEditor";
			break;
		default:
			returnPath = "admin/ezEditor/ckEditor";
			break;
		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("type", type);
		model.addAttribute("height", height);
		model.addAttribute("defaultFontFamily", defaultFontFamily);
		model.addAttribute("defaultFontSize", defaultFontSize);

		return returnPath;
	}

	/**
	 * ck에디터 이미지 업로드 화면 호출 Method
	 */
	@RequestMapping(value = "/ezEditor/ckImageUpload.do", method = RequestMethod.GET)
	public String ckImageUpload(HttpServletRequest request, Model model) {
		String type = request.getParameter("type");
		logger.debug("ckImageUpload.do type : " + type);
		model.addAttribute("type", type);
		return "ezEditor/ckImageUpload";
	}

	/**
	 * ck에디터 업로드 실행 Method
	 */
	@RequestMapping(value = "/ezEditor/ckUpload.do", method = RequestMethod.POST)
	public String ckUpload(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception {
		logger.debug("ckUpload started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String useMailLinkHost = ezCommonService.getTenantConfig("useMailLinkHostname", userInfo.getTenantId());
		String mailLinkHost = ezCommonService.getTenantConfig("mailLinkHostname", userInfo.getTenantId());
		logger.debug("useMailLinkHost=" + useMailLinkHost + ", mailLinkHost=" + mailLinkHost);

		String type = request.getParameter("type");
		MultipartFile multiFile = request.getFile("file1");

		String fileType = multiFile.getContentType().replace("\\", "/").split("/")[1];
		String realPath = commonUtil.getRealPath(request);
		String today = EgovDateUtil.getToday("");
		String fileName = UUID.randomUUID() + "." + fileType;
		String filePath = "";

		logger.debug("type:" + type);
		if (type.equals("MAILSIGNATURE") || type.equals("SIGNATURETEMPLATE")) { // 메일 서명 이미지 저장경로
			filePath = commonUtil.getUploadPath("upload_mail.SIGNIMGS", userInfo.getTenantId());
		} else if (type.equals("MAILLETTER")) {
			filePath = commonUtil.getUploadPath("upload_mail.LETTER", userInfo.getTenantId());
		}
		/* 2023-12-18 홍승비 - 자원관리 > 자원예약(포틀릿 포함) / 자원양식 등록 > 파일이 아닌 DB에 본문과 이미지 경로가 저장되므로, 임시 저장경로가 아닌 자원관리 저장경로 사용 */
		else if (type.equals("RESOURCE")) {
			filePath = commonUtil.getUploadPath("upload_resource.CONTENT", userInfo.getTenantId());
		}
		else {
			filePath = commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId());
		}

		if (type.equals("MAILLETTER")) {
			String letterBoxNo = request.getParameter("letterBoxNo");
			String letterId = request.getParameter("letterId");
			logger.debug("letterBoxNo:" + letterBoxNo + "letterId:" + letterId);

			filePath = filePath + commonUtil.separator + letterBoxNo + "/" + letterId + "/images";
		} else {
			filePath = filePath + commonUtil.separator + today;
		}
		logger.debug("filePath : " + filePath);

		/*
		 * if (letterPopUp != null) { // 편지지 등록, 수정때의 업로드 String letterBoxNo =
		 * request.getParameter("letterBoxNo"); String letterId =
		 * request.getParameter("letterId"); logger.debug("letterBoxNo:" +
		 * letterBoxNo + "letterId:" + letterId);
		 * 
		 * // /files/upload_mail/letterBoxUpload/ filePath =
		 * commonUtil.getUploadPath("upload_mail.LETTER",
		 * userInfo.getTenantId());
		 * 
		 * // /files/upload_mail/letterBoxUpload/letterBoxNo/letterId/images
		 * filePath = filePath + commonUtil.separator + letterBoxNo + "/" +
		 * letterId + "/images"; }
		 */

		File file = new File(commonUtil.detectPathTraversal(realPath + filePath));
		if (!file.exists()) {
			file.mkdirs();
		}

		int width = 0;
		int height = 0;

		writeUploadedFile(multiFile, fileName, realPath + filePath);

		File imageFile = new File(commonUtil.detectPathTraversal(realPath + filePath + commonUtil.separator + fileName));

		if (imageFile.exists()) {
			// Checking CMYK
			boolean check = isCMYK(realPath + filePath + commonUtil.separator + fileName);
			BufferedImage bi = null;

			if (check == true) {
				// Find a suitable ImageReader
				Iterator<ImageReader> readers = ImageIO.getImageReadersByFormatName("JPEG");
				ImageReader reader = null;

				while (readers.hasNext()) {
					reader = readers.next();
					if (reader.canReadRaster()) {
						break;
					}
				}

				// 2023-05-15 이사라 : NullPointerException 시큐어코딩
				if (reader != null) {
					// Stream the image file (the original CMYK image)
					ImageInputStream input = ImageIO.createImageInputStream(imageFile);
					reader.setInput(input);
	
					// Read the image raster
					Raster raster = reader.readRaster(0, null);
	
					// Create a new RGB image
					bi = new BufferedImage(raster.getWidth(), raster.getHeight(), BufferedImage.TYPE_4BYTE_ABGR);
	
					// Fill the new image with the old raster
					bi.getRaster().setRect(raster);
				}
			} else {
				bi = ImageIO.read(new File(commonUtil.detectPathTraversal(realPath + filePath + commonUtil.separator + fileName)));
			}

			// 2023-05-15 이사라 : NullPointerException 시큐어코딩
			if (!Objects.isNull(bi)) {
				width = bi.getWidth();
				height = bi.getHeight();
			}
		}
		
		String imgPath = (filePath + commonUtil.separator + fileName + "|!|" + width + "|!|" + height).replace("\\", "/");
		
		if (type.equals("MAILLETTER")) {
			String reProtocol = request.getScheme() + "://";
			String reServer = request.getServerName()
					+ ("http".equals(reProtocol)
						&& request.getServerPort() == 80
						|| "https".equals(reProtocol)
						&& request.getServerPort() == 443 ? "" : ":"
						+ request.getServerPort());
			String hostTmp = reProtocol + reServer;
			
			if (useMailLinkHost.equalsIgnoreCase("YES") && !mailLinkHost.equals("")) {
				hostTmp = reProtocol + mailLinkHost;
			}
			    
			imgPath = hostTmp + imgPath;
		}
		logger.debug("imgPath=" + imgPath);
		
		model.addAttribute("imgPath", imgPath);

		logger.debug("ckUpload ended");
		return "ezEditor/ckUpload";
	}

	private boolean isCMYK(String filename) {
		boolean result = false;
		BufferedImage img = null;

		try {
			img = ImageIO.read(new File(commonUtil.detectPathTraversal(filename)));
		} catch (Exception e) {
			result = true;
		}
		if (img != null) {
			int colorSpaceType = img.getColorModel().getColorSpace().getType();
			result = colorSpaceType == ColorSpace.TYPE_CMYK;
		}

		return result;
	}

	/**
	 * ck에디터 심플업로드 실행 Method
	 */

	@RequestMapping(value = "/ezEditor/ckSimpleUpload.do", produces = "application/json; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String ckSimpleUpload(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception {
		logger.debug("ckSimpleUpload started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String type = request.getParameter("type");
		logger.debug("cksimpleupload type : " + type);

		MultipartFile multiFile = request.getFile("upload");
		String fileType = multiFile.getContentType().replace("\\", "/").split("/")[1];
		String realPath = commonUtil.getRealPath(request);
		String today = EgovDateUtil.getToday("");
		String fileName = UUID.randomUUID() + "." + fileType;
		String filePath = "";

		if (type.equals("MAILSIGNATURE") || type.equals("SIGNATURETEMPLATE")) { // 메일 서명 이미지 저장경로
			filePath = commonUtil.getUploadPath("upload_mail.SIGNIMGS", userInfo.getTenantId());
			filePath = filePath + commonUtil.separator + today;
		} else if (type.equals("MAILLETTER")) { // 편지지 등록, 수정때의 업로드
			String letterBoxNo = request.getParameter("letterBoxNo");
			String letterId = request.getParameter("letterId");
			logger.debug("letterBoxNo:" + letterBoxNo + "letterId:" + letterId);

			// /files/upload_mail/letterBoxUpload/
			filePath = commonUtil.getUploadPath("upload_mail.LETTER", userInfo.getTenantId());

			// /files/upload_mail/letterBoxUpload/letterBoxNo/letterId/images
			filePath = filePath + commonUtil.separator + letterBoxNo + "/" + letterId + "/images";
		}
		/* 2023-12-18 홍승비 - 자원관리 > 자원예약(포틀릿 포함) / 자원양식 등록 > 파일이 아닌 DB에 본문과 이미지 경로가 저장되므로, 임시 저장경로가 아닌 자원관리 저장경로 사용 */
		else if (type.equals("RESOURCE")) {
			filePath = commonUtil.getUploadPath("upload_resource.CONTENT", userInfo.getTenantId());
			filePath = filePath + commonUtil.separator + today;
		}
		else {
			filePath = commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId());
			filePath = filePath + commonUtil.separator + today;
		}

		File file = new File(commonUtil.detectPathTraversal(realPath + filePath));

		if (!file.exists()) {
			file.mkdirs();
		}

		writeUploadedFile(multiFile, fileName, realPath + filePath);
		// return "<script>window.parent.CKEDITOR.tools.callFunction(2, '" +
		// (filePath + commonUtil.separator + fileName).replace("\\", "/") + "',
		// '')</script>";
		logger.debug("ckSimpleUpload ended");
		return "{\"uploaded\": 1,\"fileName\": \"" + fileName + "\", \"url\": \"" + (filePath + commonUtil.separator + fileName).replace("\\", "/") + "\"}";
	}

	
	/**
	 * TagFree에디터 업로드 실행 Method
	 */
	@RequestMapping(value = "/ezEditor/tfxUpload.do", method = RequestMethod.POST)
	public String tfxUpload(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String useMailLinkHost = ezCommonService.getTenantConfig("useMailLinkHostname", userInfo.getTenantId());
		String mailLinkHost = ezCommonService.getTenantConfig("mailLinkHostname", userInfo.getTenantId());
		logger.debug("useMailLinkHost=" + useMailLinkHost + ", mailLinkHost=" + mailLinkHost);

		MultipartFile multiFile = request.getFile("FILE_PATH");
		// String letterPopUp = request.getParameter("letterPopUp"); // 편지지 추가,
		// 수정일때 체크
		String type = request.getParameter("type");

		String fileType = multiFile.getContentType().replace("\\", "/").split("/")[1];
		String realPath = commonUtil.getRealPath(request);
		String today = EgovDateUtil.getToday("");
		String fileName = UUID.randomUUID() + "." + fileType;
		String filePath = "";

		if (type.equals("MAILSIGNATURE") || type.equals("SIGNATURETEMPLATE")) { // 메일 서명 이미지 저장경로
			filePath = commonUtil.getUploadPath("upload_mail.SIGNIMGS", userInfo.getTenantId());
		}
		/* 2023-12-18 홍승비 - 자원관리 > 자원예약(포틀릿 포함) / 자원양식 등록 > 파일이 아닌 DB에 본문과 이미지 경로가 저장되므로, 임시 저장경로가 아닌 자원관리 저장경로 사용 */
		else if (type.equals("RESOURCE")) {
			filePath = commonUtil.getUploadPath("upload_resource.CONTENT", userInfo.getTenantId());
		}
		else {
			filePath = commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId());
		}
		
		filePath = filePath + commonUtil.separator + today;
		
		if (type.equals("MAILLETTER")) { // 편지지 등록, 수정때의 업로드
			String letterBoxNo = request.getParameter("letterBoxNo");
			String letterId = request.getParameter("letterId");
			logger.debug("letterBoxNo:" + letterBoxNo + ", letterId:" + letterId);

			// /files/upload_mail/letterBoxUpload/
			filePath = commonUtil.getUploadPath("upload_mail.LETTER", userInfo.getTenantId());

			// /files/upload_mail/letterBoxUpload/letterBoxNo/letterId/images
			filePath = filePath + commonUtil.separator + letterBoxNo + "/" + letterId + "/images";
		}
		logger.debug("filePath : " + filePath);
		
		File file = new File(commonUtil.detectPathTraversal(realPath + filePath));
		if (!file.exists()) {
			file.mkdirs();
		}

		writeUploadedFile(multiFile, fileName, realPath + filePath);

		String uploadPath = filePath + commonUtil.separator + fileName;
		if (type.equals("MAILLETTER")) {
			String reProtocol = request.getScheme() + "://";
			String reServer = request.getServerName()
					+ ("http".equals(reProtocol)
						&& request.getServerPort() == 80
						|| "https".equals(reProtocol)
						&& request.getServerPort() == 443 ? "" : ":"
						+ request.getServerPort());
			String hostTmp = reProtocol + reServer;
			
			if (useMailLinkHost.equalsIgnoreCase("YES") && !mailLinkHost.equals("")) {
				hostTmp = reProtocol + mailLinkHost;
			}
			    
			uploadPath = hostTmp + uploadPath;
		}
		logger.debug("uploadPath=" + uploadPath);
		
		model.addAttribute("sContentType", request.getParameter("content_type"));
		model.addAttribute("sUploadedPath", uploadPath);

		return "ezEditor/tfxUpload";
	}

	/**
	 * TagFree에디터 심플업로드(drag&drop) 실행 Method
	 */
	@RequestMapping(value = "/ezEditor/tfxSimpleUpload.do", method = RequestMethod.POST)
	public String tfxSimpleUpload(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("tfxSimpleUpload started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String useMailLinkHost = ezCommonService.getTenantConfig("useMailLinkHostname", userInfo.getTenantId());
		String mailLinkHost = ezCommonService.getTenantConfig("mailLinkHostname", userInfo.getTenantId());
		logger.debug("useMailLinkHost=" + useMailLinkHost + ", mailLinkHost=" + mailLinkHost);

		String fileData = request.getParameter("clip_contents");
		String fileType = commonUtil.detectPathTraversal(request.getParameter("file_extension"));
		String rootId = request.getParameter("xfe_root_id");
		String resultCode = "0";

		if (fileData == null) { // 이미지가 너무 큰 경우 fileData가 null로 들어옴(tomcat
								// server.xml의 maxPostSize설정에 따라 이미지 최대 업로드 사이즈
								// 조절 가능함.)
			logger.debug("The file size is too big.");
			resultCode = "1";

		} else {
			logger.debug("fileType=" + fileType + ", rootId=" + rootId);

			if (fileData.startsWith("data:")) { // fileData앞에 data:이 붙어있을 경우
				logger.debug("The fileData start with data:.");

				String[] fileDatas = fileData.split(",");
				if (fileDatas[0].indexOf("image") > -1) {
					fileData = fileDatas[1];
				} else {
					model.addAttribute("resultCode", "2");
					logger.debug("tfxSimpleUpload ended. resultCode=" + resultCode);
					return "ezEditor/tfxSimpleUpload";
				}
			}

			String type = request.getParameter("type");
			String realPath = commonUtil.getRealPath(request);
			String today = EgovDateUtil.getToday("");
			String fileName = UUID.randomUUID() + "." + fileType;
			String filePath = "";

			if (type.equals("MAILSIGNATURE") || type.equals("SIGNATURETEMPLATE")) { // 메일 서명 이미지 저장경로
				filePath = commonUtil.getUploadPath("upload_mail.SIGNIMGS", userInfo.getTenantId());
			}
			/* 2023-12-18 홍승비 - 자원관리 > 자원예약(포틀릿 포함) / 자원양식 등록 > 파일이 아닌 DB에 본문과 이미지 경로가 저장되므로, 임시 저장경로가 아닌 자원관리 저장경로 사용 */
			else if (type.equals("RESOURCE")) {
				filePath = commonUtil.getUploadPath("upload_resource.CONTENT", userInfo.getTenantId());
			}
			else {
				filePath = commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId());
			}

			filePath = filePath + commonUtil.separator + today;

			if (type.equals("MAILLETTER")) { // 편지지 등록, 수정때의 업로드
				String letterBoxNo = request.getParameter("letterBoxNo");
				String letterId = request.getParameter("letterId");
				logger.debug("letterBoxNo:" + letterBoxNo + "letterId:" + letterId);

				// /files/upload_mail/letterBoxUpload/
				filePath = commonUtil.getUploadPath("upload_mail.LETTER", userInfo.getTenantId());

				// /files/upload_mail/letterBoxUpload/letterBoxNo/letterId/images
				filePath = filePath + commonUtil.separator + letterBoxNo + "/" + letterId + "/images";
			}
			logger.debug("filePath : " + filePath);

			File file = new File(commonUtil.detectPathTraversal(realPath + filePath));

			if (!file.exists()) {
				file.mkdirs();
			}

			FileOutputStream fileOuputStream = null;

			try {
				Decoder decoder = Base64.getDecoder();
				byte[] imageByte = decoder.decode(fileData);
				fileOuputStream = new FileOutputStream(commonUtil.detectPathTraversal(realPath + filePath + commonUtil.separator + fileName));
				fileOuputStream.write(imageByte);
				fileOuputStream.flush();

				logger.debug("rootId=" + rootId + ", sUploadedPath=" + filePath + commonUtil.separator + fileName);

				String uploadPath = filePath + commonUtil.separator + fileName;
				if (type.equals("MAILLETTER")) {
					String reProtocol = request.getScheme() + "://";
					String reServer = request.getServerName()
							+ ("http".equals(reProtocol)
								&& request.getServerPort() == 80
								|| "https".equals(reProtocol)
								&& request.getServerPort() == 443 ? "" : ":"
								+ request.getServerPort());
					String hostTmp = reProtocol + reServer;
					
					if (useMailLinkHost.equalsIgnoreCase("YES") && !mailLinkHost.equals("")) {
						hostTmp = reProtocol + mailLinkHost;
					}
					    
					uploadPath = hostTmp + uploadPath;
				}
				
				model.addAttribute("sRootId", rootId);
				model.addAttribute("sUploadedPath", uploadPath);

			} catch (Exception e) {
				logger.error(e.getMessage(), e);

				resultCode = "1";
			} finally {
				try {
					// 2023-05-15 이사라 : NullPointerException 시큐어코딩
					//fileOuputStream.close();
					IOUtils.closeQuietly(fileOuputStream);
				} catch (Exception e) {
					logger.debug("e.message=" + e.getMessage());
				}
			}

		}

		model.addAttribute("resultCode", resultCode);

		logger.debug("tfxSimpleUpload ended. resultCode=" + resultCode);
		return "ezEditor/tfxSimpleUpload";
	}

	/**
	 * 메일 부재중설정 TagFree에디터 심플업로드(drag&drop) 시 아무처리 안하는 Method
	 */
	@RequestMapping(value = "/ezEditor/tfxNoop.do", method = RequestMethod.POST)
	public String tfxNoop(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("tfxNoop started");

		model.addAttribute("resultCode", "3");

		return "ezEditor/tfxSimpleUpload";
	}

	/**
	 * namo에디터 업로드 실행 Method
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezEditor/namoUpload.do", method = RequestMethod.POST)
	@ResponseBody
	public String namoUpload(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception {
		logger.debug("namoUpload started");

		JSONObject resultObj = new JSONObject();
		JSONArray resultArray = new JSONArray();
		String result = "";

		try {
			String type = request.getParameter("type");
			logger.debug("type=" + type);

			// 메일 부재중설정 또는 커뮤니티 포토게시판일 경우 이미지 업로드되지 않도록 한다.
			if (type.equals("MAILOUTOFOFFICE") || type.equals("COMMUNITYPHOTO")) {
				logger.debug("Cannot upload image. type=" + type);
				result = "fail_image";
			} else {
				LoginVO userInfo = commonUtil.userInfo(loginCookie);

				MultipartFile multiFile = request.getFile("imageFile");
				String fileType = multiFile.getContentType().replace("\\", "/").split("/")[1];
				fileType = commonUtil.detectPathTraversal(fileType);
				long fileSize = multiFile.getSize();
				long maxSize = 10485760;
				logger.debug("fileType=" + fileType + ",fileSize=" + fileSize);

				if (!(fileType.equals("gif") || fileType.equals("jpeg") || fileType.equals("jpg") || fileType.equals("png") || fileType.equals("bmp"))) { // 이미지 파일이 아닐 경우
					logger.debug("fileType is not image.");
					result = "invalid_image";
				} else if (fileSize > maxSize) {
					logger.debug("file size over. fileSize=" + fileSize);
					resultArray.add(maxSize);
					result = "invalid_size";
				} else {
					String filePath = "";
					if (type.equals("MAILSIGNATURE") || type.equals("SIGNATURETEMPLATE")) { // 메일 서명 저장경로로 이미지 저장
						filePath = commonUtil.getUploadPath("upload_mail.SIGNIMGS", userInfo.getTenantId());
					} else if (type.equals("MAILLETTER")) {
						// userInfo tenantId -> 회사의 tenantId로 변경하기 (수아)
						filePath = commonUtil.getUploadPath("upload_mail.LETTER", userInfo.getTenantId());
					}
					/* 2023-12-18 홍승비 - 자원관리 > 자원예약(포틀릿 포함) / 자원양식 등록 > 파일이 아닌 DB에 본문과 이미지 경로가 저장되므로, 임시 저장경로가 아닌 자원관리 저장경로 사용 */
					else if (type.equals("RESOURCE")) {
						filePath = commonUtil.getUploadPath("upload_resource.CONTENT", userInfo.getTenantId());
					}
					else {
						filePath = commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId());
					}

					String realPath = commonUtil.getRealPath(request);
					String today = EgovDateUtil.getToday("");
					String fileName = UUID.randomUUID() + "." + fileType;

					if (type.equals("MAILLETTER")) {
						String letterBoxNo = request.getParameter("letterBoxNo");
						String letterId = request.getParameter("letterId");
						logger.debug("letterBoxNo:" + letterBoxNo + "letterId:" + letterId);

						filePath = filePath + commonUtil.separator + letterBoxNo + "/" + letterId + "/images";
					} else {
						filePath = filePath + commonUtil.separator + today;
					}

					File file = new File(commonUtil.detectPathTraversal(realPath + filePath));
					if (!file.exists()) {
						file.mkdirs();
					}

					int width = 0;
					int height = 0;

					writeUploadedFile(multiFile, fileName, realPath + filePath);

					String urlFilePath = filePath + commonUtil.separator + fileName;
					File imageFile = new File(commonUtil.detectPathTraversal(realPath + urlFilePath));

					if (imageFile.exists()) {
						try {
							BufferedImage bi = ImageIO.read(new File(commonUtil.detectPathTraversal(realPath + urlFilePath)));
							width = bi.getWidth();
							height = bi.getHeight();
						} catch (Exception e) {
							logger.debug(e.getMessage());
						}

						String imageOrgPath = request.getParameter("imageOrgPath");

						if (imageOrgPath != null && !imageOrgPath.equalsIgnoreCase("")) {
							imageOrgPath += "|" + urlFilePath;
						}

						JSONObject jsonObj = new JSONObject();
						jsonObj.put("imageURL", urlFilePath);
						jsonObj.put("imageTitle", request.getParameter("imageTitle") == null ? "" : request.getParameter("imageTitle"));
						jsonObj.put("imageAlt", request.getParameter("imageAlt") == null ? "" : request.getParameter("imageAlt"));
						jsonObj.put("imageWidth", request.getParameter("imageWidth") == null ? "" : request.getParameter("imageWidth"));
						jsonObj.put("imageWidthUnit", request.getParameter("imageWidthUnit") == null ? "" : request.getParameter("imageWidthUnit"));
						jsonObj.put("imageHeight", request.getParameter("imageHeight") == null ? "" : request.getParameter("imageHeight"));
						jsonObj.put("imageHeightUnit", request.getParameter("imageHeightUnit") == null ? "" : request.getParameter("imageHeightUnit"));
						jsonObj.put("imageMarginLeft", request.getParameter("imageMarginLeft") == null ? "" : request.getParameter("imageMarginLeft"));
						jsonObj.put("imageMarginLeftUnit", request.getParameter("imageMarginLeftUnit") == null ? "" : request.getParameter("imageMarginLeftUnit"));
						jsonObj.put("imageMarginRight", request.getParameter("imageMarginRight") == null ? "" : request.getParameter("imageMarginRight"));
						jsonObj.put("imageMarginRightUnit", request.getParameter("imageMarginRightUnit") == null ? "" : request.getParameter("imageMarginRightUnit"));
						jsonObj.put("imageMarginTop", request.getParameter("imageMarginTop") == null ? "" : request.getParameter("imageMarginTop"));
						jsonObj.put("imageMarginTopUnit", request.getParameter("imageMarginTopUnit") == null ? "" : request.getParameter("imageMarginTopUnit"));
						jsonObj.put("imageMarginBottom", request.getParameter("imageMarginBottom") == null ? "" : request.getParameter("imageMarginBottom"));
						jsonObj.put("imageMarginBottomUnit", request.getParameter("imageMarginBottomUnit") == null ? "" : request.getParameter("imageMarginBottomUnit"));
						jsonObj.put("imageAlign", request.getParameter("imageAlign") == null ? "" : request.getParameter("imageAlign"));
						jsonObj.put("imageId", request.getParameter("imageId") == null ? "" : request.getParameter("imageId"));
						jsonObj.put("imageClass", request.getParameter("imageClass") == null ? "" : request.getParameter("imageClass"));
						jsonObj.put("imageBorder", request.getParameter("imageBorder") == null ? "" : request.getParameter("imageBorder"));
						jsonObj.put("imageKind", request.getParameter("imageKind") == null ? "" : request.getParameter("imageKind"));
						jsonObj.put("imageOrgPath", imageOrgPath);
						jsonObj.put("imageOrgWidth", width);
						jsonObj.put("imageOrgHeight", height);
						jsonObj.put("editorFrame", request.getParameter("editorFrame") == null ? "" : request.getParameter("editorFrame"));

						resultArray.add(jsonObj);
						result = "success";

					} else {
						logger.debug("image upload fail.");
					}

				}

			}

		} catch (Exception e) {
			result = "";
			logger.error(e.getMessage(), e);
		}

		resultObj.put("result", result);
		resultObj.put("addmsg", resultArray);

		logger.debug("namoUpload ended. result=" + resultObj.toString());
		return resultObj.toString();
	}

	/**
	 * 쿠쿠닥스 에디터 업로드 실행 Method
	 */
	@RequestMapping(value = "/ezEditor/kukudocsUpload.do", method = RequestMethod.POST, produces="application/json; charset=utf-8")
	@ResponseBody
	public String kukudocsUpload(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Model model, Locale locale) throws Exception {
		logger.debug("kukudocsUpload started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String result = "";
		String msg = "";
		
		String useMailLinkHost = ezCommonService.getTenantConfig("useMailLinkHostname", userInfo.getTenantId());
		String mailLinkHost = ezCommonService.getTenantConfig("mailLinkHostname", userInfo.getTenantId());
		logger.debug("useMailLinkHost=" + useMailLinkHost + ", mailLinkHost=" + mailLinkHost);
		
		try {
			MultipartFile multiFile = request.getFile("image_type");
			String fileData = request.getParameter("image_base64_type");
			String type = request.getParameter("type");

			// 메일 부재중설정 또는 커뮤니티 포토게시판일 경우 이미지 업로드되지 않도록 한다.
			// TODO: ezEmail.lhm29 메시지 변경
			if (type.equals("MAILOUTOFOFFICE") || type.equals("COMMUNITYPHOTO")) {
				msg = egovMessageSource.getMessage("ezEmail.lhm29", locale);
				result = "{ \"isError\" : true, \"msg\" : \"" + msg + "\" }";
				logger.debug("Cannot upload image. kukudocsUpload ended. type=" + type);
				return result;
			}

			// fileData가 넘어왔을 경우의 처리
			if (fileData != null) {
				String[] fileDatas = fileData.split(",");

				if (fileDatas[0].startsWith("data:image/")) {
					String fileType = fileDatas[0].substring(fileDatas[0].indexOf("/") + 1, fileDatas[0].indexOf(";"));
					fileType = commonUtil.detectPathTraversal(fileType);
					fileData = fileDatas[1];
					EzFAL.EzFileOutputStream fileOuputStream = null;

					try {
						String filePath = "";

						if (type.equals("MAILSIGNATURE") || type.equals("SIGNATURETEMPLATE")) { // 메일 서명 저장경로로 이미지 저장
							filePath = commonUtil.getUploadPath("upload_mail.SIGNIMGS", userInfo.getTenantId());
						}
						/* 2023-12-18 홍승비 - 자원관리 > 자원예약(포틀릿 포함) / 자원양식 등록 > 파일이 아닌 DB에 본문과 이미지 경로가 저장되므로, 임시 저장경로가 아닌 자원관리 저장경로 사용 */
						else if (type.equals("RESOURCE")) {
							filePath = commonUtil.getUploadPath("upload_resource.CONTENT", userInfo.getTenantId());
						}
						else {
							filePath = commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId());
						}

						String realPath = commonUtil.getRealPath(request);
						String today = EgovDateUtil.getToday("");
						String fileName = UUID.randomUUID() + "." + fileType;

						filePath = filePath + commonUtil.separator + today;
						EzFAL.EzFile file = new EzFAL.EzFile(commonUtil.detectPathTraversal(realPath + filePath));

						if (!file.exists()) {
							file.mkdirs();
						}

						Decoder decoder = Base64.getDecoder();
						byte[] imageByte = decoder.decode(fileData);
						fileOuputStream = new EzFAL.EzFileOutputStream(commonUtil.detectPathTraversal(realPath + filePath + commonUtil.separator + fileName));
						fileOuputStream.write(imageByte);
						fileOuputStream.flush();

						msg = filePath + commonUtil.separator + fileName;
						result = "{ \"url\" : \"" + msg + "\" }";

					} finally {
						try {
							// 2023-05-15 이사라 : NullPointerException 시큐어코딩
							//fileOuputStream.close();
							IOUtils.closeQuietly(fileOuputStream);
						} catch (Exception e) {
							logger.debug("e.message=" + e.getMessage());
						}
					}
				} else {
					msg = egovMessageSource.getMessage("main.t4000", locale);
					result = "{ \"isError\" : true, \"msg\" : \"" + msg + "\" }";
				}

				// multiFile이 넘어왔을 경우의 처리
			} else if (multiFile != null) {
				// 2023.04.27 한슬기 : fileType이 jsp인 경우 보안상 문제가 될 수 있으므로 error 처리
				// fileType이 대문자로 들어올 경우에도 비교하기 위해 .toLowerCase();추가하여 소문자로 통일
				String fileType = multiFile.getContentType().replace("\\", "/").split("/")[1].toLowerCase();
				
				// Editor에서 허용하는 fileType(Editor.bundle.js의 IMAGE_TYPE_FILES)
				List<String> allowFileTypeList = new ArrayList<>(Arrays.asList("png","jpg","jpeg","gif","bmp"));
				
				// fileType이 fileTypeList에 포함되어있지 않을 경우 에러메시지 return
				if(!allowFileTypeList.contains(fileType)) {
					msg = egovMessageSource.getMessage("fail.common.editor.fileType.warning", locale);
					result = "{ \"isError\" : true, \"msg\" : \"" + msg + "\" }";
					logger.debug("This file type is not allowed. allowFileTypeList : {}, fileType:{}", allowFileTypeList, fileType);
					return result;				
				}
				
				String filePath = commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId());

				if (type.equals("MAILSIGNATURE") || type.equals("SIGNATURETEMPLATE")) { // 메일 서명 저장경로로 이미지 저장
					filePath = commonUtil.getUploadPath("upload_mail.SIGNIMGS", userInfo.getTenantId());
				}
				/* 2023-12-18 홍승비 - 자원관리 > 자원예약(포틀릿 포함) / 자원양식 등록 > 파일이 아닌 DB에 본문과 이미지 경로가 저장되므로, 임시 저장경로가 아닌 자원관리 저장경로 사용 */
				else if (type.equals("RESOURCE")) {
					filePath = commonUtil.getUploadPath("upload_resource.CONTENT", userInfo.getTenantId());
				}

				String realPath = commonUtil.getRealPath(request);
				String today = EgovDateUtil.getToday("");
				String fileName = UUID.randomUUID() + "." + fileType;

				filePath = filePath + commonUtil.separator + today;

				if (type.equals("MAILLETTER")) { // 편지지 등록, 수정때의 업로드
					String letterBoxNo = request.getParameter("letterBoxNo");
					String letterId = request.getParameter("letterId");
					logger.debug("letterBoxNo:" + letterBoxNo + ", letterId:" + letterId);

					filePath = commonUtil.getUploadPath("upload_mail.LETTER", userInfo.getTenantId());
					filePath = filePath + commonUtil.separator + letterBoxNo + "/" + letterId + "/images";
				}
				logger.debug("filePath : " + filePath);

				EzFAL.EzFile file = new EzFAL.EzFile(commonUtil.detectPathTraversal(realPath + filePath));

				if (!file.exists()) {
					file.mkdirs();
				}

				writeUploadedFile(multiFile, fileName, realPath + filePath);
				msg = filePath + commonUtil.separator + fileName;

				if (type.equals("MAILLETTER")) {
					String reProtocol = "YES".equals(ezCommonService.getTenantConfig("USE_HTTPS", userInfo.getTenantId())) ? "https://" : "http://";
					String reServer = request.getServerName()
							+ ("http".equals(request.getScheme())
								&& request.getServerPort() == 80
								|| "https".equals(request.getScheme())
								&& request.getServerPort() == 443 ? "" : ":"
								+ request.getServerPort());
					String hostTmp = reProtocol + reServer;
					
					if (useMailLinkHost.equalsIgnoreCase("YES") && !mailLinkHost.equals("")) {
						hostTmp = reProtocol + mailLinkHost;
					}
					    
					msg = hostTmp + msg;
				}
				logger.debug("msg=" + msg);
				
				result = "{ \"url\" : \"" + msg + "\" }";

				// fileData, multiFile 모두 null일 경우
			} else {
				// 이미지가 너무 큰 경우 fileData가 null로 들어올 수 있다.(tomcat server.xml의
				// maxPostSize설정에 따라 이미지 최대 업로드 사이즈 조절 가능하다.)
				msg = egovMessageSource.getMessage("ezBoard.hyj02", locale);
				result = "{ \"isError\" : true, \"msg\" : \"" + msg + "\" }";
				logger.debug("fileData and multiFile are null.");
			}
		} catch (Exception e) {
			msg = egovMessageSource.getMessage("ezBoard.hyj02", locale);
			result = "{ \"isError\" : true, \"msg\" : \"" + msg + "\" }";

			logger.error(e.getMessage(), e);
		}

		logger.debug("kukudocsUpload ended.");
		return result;
	}

}
