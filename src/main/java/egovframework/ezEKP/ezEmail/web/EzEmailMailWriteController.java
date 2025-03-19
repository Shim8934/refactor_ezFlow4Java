package egovframework.ezEKP.ezEmail.web;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.security.PrivateKey;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.IllegalFormatException;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.Set;
import java.util.TimeZone;
import java.util.UUID;
import java.util.function.Predicate;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.annotation.Resource;
import javax.crypto.Cipher;
import javax.mail.Address;
import javax.mail.BodyPart;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Header;
import javax.mail.Message;
import javax.mail.Message.RecipientType;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Part;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.InternetHeaders;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimePart;
import javax.mail.internet.MimeUtility;
import javax.mail.util.ByteArrayDataSource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import egovframework.let.utl.rest.Result;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.*;

import com.sun.mail.imap.AppendUID;
import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezAddress.vo.AddressVO;
import egovframework.ezEKP.ezAddress.vo.SimpleAddressVO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGKlibService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailDistributionVO;
import egovframework.ezEKP.ezEmail.vo.MailSharedMailboxUserVO;
import egovframework.ezEKP.ezEmail.vo.MailSharedMailboxVO;
import egovframework.ezEKP.ezEmail.vo.MailWriteProcessVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.fcc.service.KlibUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezEmail.service.EzEmailWriteService;

/** 
 * @Description [Controller] 메일 쓰기
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.14    이효민    신규작성
 *
 * @see
 */

@Controller
public class EzEmailMailWriteController extends EgovFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailMailWriteController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private KlibUtil klibUtil;

	@Autowired
	private Properties config;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzEmailService ezEmailService;

	@Autowired
	private EzEmailWriteService ezEmailWriteService;
	
	@Autowired
	private EzAddressService ezAddressService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;

	@Autowired
	private EzEmailUserAdminService ezEmailUserAdminService;
	
    @Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
	
	/**
	 * 메일 쓰기화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailWrite.do", method = RequestMethod.GET)
	public String mailWrite(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.debug("mailWrite started.");
		MailWriteProcessVO writevo = new MailWriteProcessVO();

	// 1. VALID START
		String cmd = StringUtils.defaultIfBlank(request.getParameter("cmd"), "NEW");
		writevo.setCmd(cmd);

		// get user credentials
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);

		// retrieve the Drafts folder name
		String draftsFolderName = ezEmailUtil.getDraftsFolderId(locale);
		writevo.setDraftsFolderName(draftsFolderName);
		boolean hasScript = false;

		// 예약발송 수정
		if ("RESERVE".equals(cmd)) {
			String errMsgCode = ezEmailWriteService.isValidReserve(request, writevo, loginInfo);

			if (errMsgCode != null) {
				model.addAttribute("pMessage", egovMessageSource.getMessage(errMsgCode, locale));
				logger.debug(egovMessageSource.getMessage(errMsgCode, locale));
				logger.debug("mailEdit ended.");
				return "ezEmail/mailMessage";
			}

		// 일반
		} else {
			ezEmailWriteService.setGeneral(request, writevo, locale);
			hasScript = commonUtil.hasStripScriptTagsAndFunctions(writevo.getMsgto());
		}

		writevo.setWriteType();

		if (!writevo.isValid() || hasScript) {
			return egovMessageSource.getMessage("ezEmail.lhm17", locale);
		}

		String shareId = request.getParameter("shareId");
		boolean isValidShareId = ezEmailWriteService.isValidShareId(writevo, loginInfo.getId(), shareId, loginInfo.getTenantId());
		
		if (!isValidShareId) {
			model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));

			logger.debug("the user cannot access the shareId.");
			logger.debug("mailWrite ended.");

			return "ezCommon/error";
		}
	// VALID END

		// userAccount, password: IMAP·SMTPAccess instance 생성 시 사용
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userAccount = writevo.getMailId() + "@" + domainName;
		String password  = commonUtil.getUserIdAndPassword(loginCookie).get(1);
        logger.debug("userId=" + loginInfo.getId() + ",userAccount=" + userAccount);

		OrganUserVO userInfo = ezOrganAdminService.getUserInfo(writevo.getMailId(), loginInfo.getPrimary(), loginInfo.getTenantId());

		// 2. set options: 사용자의 설정에 따른 메일쓰기 정보를 세팅 함
		ezEmailWriteService.setDefaultMailOptions(request, writevo, loginInfo, userInfo.getDisplayName2(), locale);

		// make mail top level folders: 사용자계정 생성 직후, mail top level folders가 없을 수도 있다. 에러방지.
		ezEmailUtil.useIMAPAccessWithCallback(IMAPAccess::makeTopLevelFolders, userAccount, password, locale);

		// 3. set options: 추가적으로 테넌트나 회사의 옵션으로 강제 변경하는 정보가 있는 경우 반영
		ezEmailWriteService.setOverwriteMailOptions(writevo, userInfo.getMail(), loginInfo.getTenantId(), userInfo.getPhysicalDeliveryOfficeName());

		// 4. load from origin message : 임시저장메일, 회신, 전달, 재사용 등 기존 메일의 정보를 세팅함
		if (writevo.hasOrigin()) {
			writevo.setReciverName(request.getParameter("reciverName")); // for RESEND_IN_SENT
			ezEmailWriteService.loadFromOrigin(writevo, loginInfo, userAccount, password, locale);
		}

	// PROCESS END

		/**
		 * LoginVO loginInfo: tenantId, lang, primary, offset, serverName
		 * → tenantId, userLang, userPrimary, userTimeset, serverName
		 */
		model.addAttribute("loginInfo", loginInfo);
		/**
		 * OrganUserVO userInfo: company, description, displayName, mail, mailNickName, physicalDeliveryOfficeName, title
		 * displayName → displayNamePrintable
		 */
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("shareId", StringUtils.defaultIfBlank(shareId, null));

		model.addAttribute("writetype", writevo.getWriteType());
		model.addAttribute("cmdOwn", writevo.getCmdOwn());
		model.addAttribute("drafts", draftsFolderName); // var folderPath 사용, 일반첨부 시 임시 저장을 위함.
		// poll(투표)는 drafts를 빈값으로 넘김.

		model.addAttribute("message", writevo.getMailWriteMessageVO());
		model.addAttribute("from", writevo.getFrom());
		model.addAttribute("fromAddressList", writevo.getMailWriteOptionsVO().getFromAddressList());
		model.addAttribute("options", writevo.getMailWriteOptionsVO());
		model.addAttribute("general", writevo.getMailGeneralVO());
		model.addAttribute("sign", writevo.getMailSignatureVO());
		model.addAttribute("color", writevo.getMailColorVO());
		model.addAttribute("sharedBox", writevo.getSharedMailboxInfoVO());

		response.setHeader("X-XSS-Protection", "0");
		
		logger.debug("mailWrite ended.");
		return "ezEmail/mailWrite";
	}
	
	/**
	 * 메일 저장 여부를 묻는 확인 다이알로그 표시
	 */
	@RequestMapping(value="/ezEmail/mailConfirmDialog.do", method = RequestMethod.GET)
	public String mailConfirmDialog(
					@CookieValue("loginCookie") String loginCookie,
					@RequestParam("CAPTION") String caption,
					@RequestParam("MESSAGE") String message,
					@RequestParam("BUTTONNAMES") String buttonNames,
					HttpServletRequest request,
					LoginVO userInfo,
					Model model) throws Exception {
		logger.debug("mailConfirmDialog started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		caption = caption != null ? caption : "";
		message = message != null ? message : "";
		buttonNames = buttonNames != null ? buttonNames : "";
		
		String buttonName0 = "";
		String buttonName1 = "";
		String buttonName2 = "";
		String[] buttonNamesArray = buttonNames.split(",");
		
		if (userInfo.getLang().equals("3")) {
			buttonNamesArray = buttonNames.split("、");
		}
		
		for (int i = 0; i < buttonNamesArray.length; i++) {
			switch (i) {
			case 0: buttonName0 = buttonNamesArray[i]; break;
			case 1: buttonName1 = buttonNamesArray[i]; break;
			case 2: buttonName2 = buttonNamesArray[i]; break;
			}
		}
		
		model.addAttribute("caption", caption);
		model.addAttribute("message", message);
		model.addAttribute("buttonName0", buttonName0);
		model.addAttribute("buttonName1", buttonName1);
		model.addAttribute("buttonName2", buttonName2);
		
		logger.debug("mailConfirmDialog ended.");
		return "ezEmail/mailConfirmDialog";
	}

	/**
	 * 첨부파일 추가
	 */
	@RequestMapping(value="/ezEmail/mailLargeFileUpload.do", method = RequestMethod.GET)
	public String mailLargeFileUpload(
			@RequestParam("CAPTION") String caption,
			@RequestParam("MESSAGE") String message,
			@RequestParam("BUTTONNAME") String buttonName,
			HttpServletRequest request,
			Model model) throws Exception {
		logger.debug("mailLargeFileUpload started.");

		caption = caption != null ? caption : "";
		message = message != null ? message : "";
		buttonName = buttonName != null ? buttonName : "";

		model.addAttribute("caption", caption);
		model.addAttribute("message", message);
		model.addAttribute("buttonName", buttonName);

		logger.debug("mailLargeFileUpload ended.");
		return "ezEmail/mailLargeFileUpload";
	}

	/**
	 * 메일 파일첨부 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/dragAndDrop.do", method = RequestMethod.GET)
	public String dragAndDropIframe(
			@CookieValue("loginCookie") String loginCookie, 
			HttpServletRequest request,
			LoginVO userInfo, 
			Model model,
			Locale locale) throws Exception{
		logger.debug("dragAndDropIframe started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
		
		if (attachFileNameMaxLength.equals("")) {
			attachFileNameMaxLength = "100";
		}
		
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, 2, userInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("dragAndDropIframe ended.");
					
					return "ezCommon/error";
				} else {
					model.addAttribute("shareId", shareId);
				}
			}
		}
		String useWebfolder = ezCommonService.getTenantConfig("useWebfolder", userInfo.getTenantId());
		
		model.addAttribute("useWebfolder", useWebfolder);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		
		logger.debug("dragAndDropIframe ended.");
		return "ezEmail/mailDragAndDrop";
	}

	/**
	 * 메일 DragAndDrop 첨부파일 업로드 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailInterUploadXCK.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailInterUpload(
			@CookieValue("loginCookie") String loginCookie, 
			MultipartHttpServletRequest request) throws Exception{
		logger.debug("mailInterUploadXCK started.");
		
		String strXML = "";
		String strXML2 = "";
		String folderDate = "";
		String tempFolderName = "";
		String xmlList = "";
		String isBigYN = "N";
		List<MultipartFile> multiFile = request.getFiles("fileToUpload");
		int cnt = 0;
		
		if (request.getParameter("cnt") != null && !request.getParameter("cnt").equals("")) {
			cnt = Integer.parseInt(request.getParameter("cnt"));
		}
		
		if (cnt == 0) {
			return "";
		}
		
		String realPath = commonUtil.getRealPath(request);
		String[] pFileName = new String[cnt];
		Long[] fileSize = new Long[cnt];
		String[] fileLocation = new String[cnt];
		String[] resultUpload = new String[cnt];
		String[] sGUID = new String[cnt];
		String pBigFileUpload = "";
		String[] sFileTitle = new String[cnt];
		String[] sExt = new String[cnt];
		String pDirTempPath = "";
		long bigMaxSize = 0;
		long changeSize = 0;

		if (request.getParameter("STATUS") != null && !request.getParameter("STATUS").equals("")) {
			tempFolderName = request.getParameter("STATUS");
			tempFolderName = commonUtil.detectPathTraversal(tempFolderName);
		} else {
			return "NODATA";
		}
		
		if (multiFile == null) {
			return "NODATA";
		}
		
		if (request.getParameter("isbigyn") != null) {
			isBigYN = request.getParameter("isbigyn");
		}
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		// 업로드 허용 파일 확장자 설정을 조회
		String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		
		if (useExtension == null) {
			useExtension = "";
		}
		
		if (multiFile.get(0).getOriginalFilename() != null && StringUtils.isNotBlank(multiFile.get(0).getOriginalFilename())){
			boolean isEmpty = false;
			String _pFileName = "";

			// 파일명과 확장자를 구한다.
			for (int i = 0; i < cnt; i++) {
				_pFileName = multiFile.get(i).getOriginalFilename();

				// 폴더 경로를 제외한 파일명만을 구한다.
				if (_pFileName.indexOf(commonUtil.separator) > 0) {
					_pFileName = _pFileName.split(commonUtil.separator)[_pFileName.split(commonUtil.separator).length - 1];
				}

				pFileName[i] = _pFileName;

				// 파일 확장자를 구한다.
				if (pFileName[i].lastIndexOf(".") > -1) {
					sFileTitle[i] = pFileName[i].substring(0, pFileName[i].lastIndexOf("."));
					sExt[i] = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
				} else {
					sFileTitle[i] = pFileName[i];
					sExt[i] = "";
				}
				
				if (multiFile.get(i).getSize() == 0) {
					isEmpty = true;
				}
			}
			
			if (isEmpty) {
				return "OVERFLOW";
			}
		}

		for (int i = 0; i < cnt; i++) {
			sGUID[i] = UUID.randomUUID().toString() + "." + sExt[i];
		}

		if (request.getParameter("bigmaxsize") != null) {
			bigMaxSize = Long.parseLong(request.getParameter("bigmaxsize"));
		}
		
		if (request.getParameter("changesize") != null) {
			changeSize = Long.parseLong(request.getParameter("changesize"));
		}

		strXML = "<ROOT><NODES>";
		String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		pDirPath = realPath + pDirPath;
		
		// check the upload mail root folder and create it if it doesn't exist.
		File uploadMailRootFolder = new File(pDirPath);

		if (!uploadMailRootFolder.exists()) {
			logger.debug("creating uploadMailRootFolder=" + uploadMailRootFolder);

			uploadMailRootFolder.mkdirs();
		}
		
		// 2018-10-08 분리된 대용량파일(largeFile) 폴더 사용 여부
		String largeFilePath = pDirPath;
		String useSeparatedLargeFileFolder = ezCommonService.getTenantConfig("useSeparatedLargeFileFolder", userInfo.getTenantId());

		if (useSeparatedLargeFileFolder.equals("YES")) {
			largeFilePath += commonUtil.separator + "largeFile";
		}
		
		for (int i = 0; i < cnt; i++) {
			fileSize[i] = multiFile.get(i).getSize();

			// 대용량 첨부 파일의 경우
			if (fileSize[i] > changeSize || isBigYN.equals("Y")) {
                String pDate = EgovDateUtil.getToday("");
                folderDate = pDate;
                pDirTempPath = largeFilePath + commonUtil.separator + pDate;
                File file = new File(pDirTempPath);
                
                if (!file.exists()) {
                	file.mkdirs();
                }
                
                pBigFileUpload = "Y";
                
                pFileName[i] = commonUtil.normalizeFileName(pFileName[i]);
                
                String base64OrgFileName = Base64.encodeBase64String(pFileName[i].getBytes("UTF-8"));
                FileOutputStream fos = null;
                
                try {
					// 대용량 첨부 파일명을 저장하는 파일
                	File f = new File(commonUtil.detectPathTraversal(pDirTempPath + commonUtil.separator + sGUID[i] + "__.txt"));
                	fos = new FileOutputStream(f);
                    fos.write(base64OrgFileName.getBytes("ISO-8859-1"));
                } catch(IOException e) {
                	throw e;
				} catch(Exception e) {
                	throw e;
                } finally {
                	if (fos != null) {
                		fos.close();
                	}
                }
			// 일반 첨부 파일의 경우
            } else {
                pDirTempPath = pDirPath + commonUtil.separator + "tempFileUpload";
                pBigFileUpload = "N";
            }
			
			File f = new File(pDirTempPath);

			if (!f.exists()) {
				f.mkdirs();
            }
			
			if (fileSize[i] > bigMaxSize && bigMaxSize != 0) {
                resultUpload[i] = "overflow";
            } else {
				// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
                if ((sExt[i].isEmpty() || useExtension.toLowerCase().indexOf(sExt[i].toLowerCase()) == -1) && !useExtension.equals("*")) {
                    resultUpload[i] = "denied";
                } else {
					// Multipart 형식으로 업로드된 파일을 복사한다.
                    //writeUploadedFile(multiFile.get(i), sGUID[i], pDirTempPath);
					multiFile.get(i).transferTo(new File(pDirTempPath, sGUID[i]));
                    fileLocation[i] = pDirTempPath + commonUtil.separator + sGUID[i];
                    resultUpload[i] = "true";
                }
                
				// 업로드된 파일에 대한 정보를 XML 형식으로 클라이언트에게 반환한다.
                strXML2 += "<NODE><PUPLOADSN><![CDATA[" + sGUID[i] + "]]></PUPLOADSN>";
                strXML2 += "<RESULTUPLOADA><![CDATA[" + resultUpload[i] + "]]></RESULTUPLOADA>";
                strXML2 += "<PFILENAME><![CDATA[" + pFileName[i] + "]]></PFILENAME>";
                strXML2 += "<FILESIZE><![CDATA[" + fileSize[i] + "]]></FILESIZE>";
                if (pBigFileUpload.equals("Y")) {
                	strXML2 += "<FILELOCATION><![CDATA[" + folderDate+"|!|"+sGUID[i] + "]]></FILELOCATION>";
                } else {
                	strXML2 += "<FILELOCATION><![CDATA[" + sGUID[i] + "]]></FILELOCATION>";
                }
                strXML2 += "<PBIGFILEUPLOAD><![CDATA[" + pBigFileUpload + "]]></PBIGFILEUPLOAD>";
                strXML2 += "</NODE>";

				String useExternalLargeFileServer = ezCommonService.getTenantConfig("useExternalLargeFileServer", userInfo.getTenantId());
				// external large file server http upload
				if ("Y".equalsIgnoreCase(useExternalLargeFileServer) && pBigFileUpload.equals("Y") ) {

					File bigAttachFile = new File(pDirTempPath, sGUID[i]);
					HttpHeaders headers = new HttpHeaders();
					headers.setContentType(MediaType.MULTIPART_FORM_DATA);
					//headers.add("Cookie", "loginCookie=\"" + loginCookie + '"');

					MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
					body.add("file", new FileSystemResource(bigAttachFile));
					body.add("saveFileName", sGUID[i]);
					body.add("originalFileName", new String(pFileName[i].getBytes("UTF-8"), "ISO-8859-1"));
					body.add("uploadPath", pDirTempPath);

					HttpEntity<MultiValueMap<String, Object>> entity = new HttpEntity<>(body, headers);

					String externalFileServerUrl = ezCommonService.getTenantConfig("externalFileServerUrl", userInfo.getTenantId());

					RestTemplate restTemplate = new RestTemplate();
					((SimpleClientHttpRequestFactory) restTemplate.getRequestFactory())
							.setBufferRequestBody(false);
					restTemplate.exchange(externalFileServerUrl + "/rest/ezEmail/uploadAttachCommon.do", HttpMethod.POST, entity, String.class);

				}
            }

            pDirTempPath = "";
		}
		
		strXML += strXML2 + "</NODES></ROOT>";

        String xmlPath = pDirPath + commonUtil.separator + "templist";
        File f = new File(xmlPath);

        if (!f.exists()) {
			f.mkdirs();
        }

		// 업로드된 파일에 대한 정보를 누적해서 저장하는 파일
        xmlPath += commonUtil.separator + tempFolderName + ".txt";
        f = new File(xmlPath);
        
        if (f.exists()) {
        	String tempXmlList = "";
        	InputStreamReader isr = null;
        	BufferedReader br = null;
        	OutputStreamWriter osw = null;
        	
        	try {
	        	isr = new InputStreamReader(new FileInputStream(f));
	        	br = new BufferedReader(isr);
	        	int read = 0;
				
	        	while ((read = br.read()) != -1) {
					tempXmlList += (char)read;
				}
				
				Document xmldom = commonUtil.convertStringToDocument(tempXmlList);
				Document xmldom2 = commonUtil.convertStringToDocument(strXML);
				
	            NodeList nodeList = xmldom.getElementsByTagName("NODES");
	            NodeList nodeList2 = xmldom2.getElementsByTagName("NODE");
	            
	            for (int i=0; i<nodeList2.getLength(); i++) {
	            	nodeList.item(0).appendChild(xmldom.importNode(nodeList2.item(i), true));
	            }
            	
	            osw = new OutputStreamWriter(new FileOutputStream(f));
            	osw.write(commonUtil.convertDocumentToString(xmldom));
            	String crlf = System.getProperty("line.separator");
        		osw.append(crlf+crlf);
	            
	            xmlList = strXML;
        	} catch(IOException e) {
        		throw e;
			} catch(Exception e) {
        		throw e;
        	} finally {
        		IOUtils.closeQuietly(osw);

        		if (br != null) {
        			br.close();
        		}
        		if (isr != null) {
        			isr.close();
        		}
        		/*if (osw != null) {
        			osw.close();
        		}*/
        	}
        	
        } else {
        	OutputStreamWriter osw = null;
        	
        	try {
        		osw = new OutputStreamWriter(new FileOutputStream(f));
        		osw.write(strXML);
        		String crlf = System.getProperty("line.separator");
        		osw.append(crlf+crlf);
        		xmlList = strXML;
        	} catch(IOException e) {
        		throw e;
			} catch(Exception e) {
        		throw e;
        	} finally {
        		if (osw != null) {
        			osw.close();
        		}
        	}
        }
        
        logger.debug("mailInterUploadXCK ended.");
        return xmlList;
	}
	
	/**
	 * <pre>
	 * 메일 DragAndDrop 첨부파일 업로드 실행 함수
	 * - 게시판/커뮤니티/전자결재에서 메일로 전송 시.
	 * - 서버에 이미 업로드 되어있는 첨부파일을 복사해옴.
	 * - 일반 첨부파일에만 해당됨.
	 * </pre>
	 */
	@RequestMapping(value="/ezEmail/mailInterUploadCopyXCK.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailInterUploadCopy(
			@CookieValue("loginCookie") String loginCookie, 
			@RequestBody String bodyData,
			HttpServletRequest request) throws Exception {
		logger.debug("mailInterUploadCopy started.");
		logger.debug("bodyData=" + bodyData);
		
		String tempFolderName = request.getParameter("STATUS") == null ? "" : request.getParameter("STATUS");
		String isBigYN = request.getParameter("isbigyn") == null ? "" : request.getParameter("isbigyn"); //isBigYN은 항상 N
		logger.debug("tempFolderName=" + tempFolderName + ",isBigYN=" + isBigYN);
		
		tempFolderName = commonUtil.detectPathTraversal(tempFolderName);
		
		Document doc = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
		String bigMaxSizeStr = doc.getElementsByTagName("BIGMAXSIZE").item(0).getTextContent();
		long bigMaxSize = Long.parseLong(bigMaxSizeStr);
		
		String changeSizeStr = doc.getElementsByTagName("CHANGESIZE").item(0).getTextContent();	
		int changeSize = Integer.parseInt(changeSizeStr);
		
		// String endDate = doc.getElementsByTagName("ENDDAY").item(0).getTextContent();	
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String realPath = commonUtil.getRealPath(request);
		String uploadMailRootPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		String pTempFileUploadPath = uploadMailRootPath + commonUtil.separator + "tempFileUpload";
		String pTempListPath = uploadMailRootPath + commonUtil.separator + "templist";
		
		// 2018-10-08 분리된 대용량파일(largeFile) 폴더 사용 여부
		String largeFilePath = uploadMailRootPath;
		String useSeparatedLargeFileFolder = ezCommonService.getTenantConfig("useSeparatedLargeFileFolder", userInfo.getTenantId());

		if (useSeparatedLargeFileFolder.equals("YES")) {
			largeFilePath += commonUtil.separator + "largeFile";
		}
		
		String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		
		int fileCnt = doc.getElementsByTagName("ROW").getLength();
		String[] fileName = new String[fileCnt];
		String[] filePath = new String[fileCnt];
		long[] fileSize = new long[fileCnt];
		String[] fileExt = new String[fileCnt];
		String[] newFileName = new String[fileCnt];
		boolean[] downloadedFlags = new boolean[fileCnt];
		String comparingExt = "";
		Map<String, Integer> fileNameMap = new HashMap<String, Integer>();
		
		int totalFileSize = 0;
		
		if (tempFolderName.equals("")) {
			logger.debug("tempFolderName is EMPTY. Return NODATA.");
			logger.debug("mailInterUploadCopy ended.");
			
			return "NODATA";
		}
		
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", userInfo.getTenantId());
		String dotNetUrl = ezCommonService.getTenantConfig("dotNetUrl", userInfo.getTenantId());
		
		for (int i = 0; i < fileCnt; i++) {
			String filePathValue = doc.getElementsByTagName("DATA2").item(i).getTextContent();		
			filePathValue = filePathValue != null ? filePathValue : "";
			
			if (!filePathValue.startsWith("/")) {
				filePathValue = "/" + filePathValue;
			}
			filePathValue = commonUtil.detectPathTraversal(filePathValue);
			
			filePath[i] = realPath + filePathValue;
			
			if (dotNetIntegration.equals("YES")) {
				try {
					File f = new File(filePath[i]);
					
					// 닷넷 연동 시 첨부 파일이 존재하지 않으면 암호화된 파일일 수 있으므로 복호화 URL을 호출하여 다운로드를 시도해 본다.
					if (!f.exists()) {						
						String downloadUrl = dotNetUrl + "/myoffice/Common/DownloadAttach_java.aspx?filename=placeholder"
									+ "&filepath=" + URLEncoder.encode(filePathValue, "UTF-8");
						
						logger.debug("downloadUrl=" + downloadUrl);
						
						// 다운로드된 파일을 저장할 로컬 파일명을 임의로 생성한다.
						String localFilePath = pTempFileUploadPath + commonUtil.separator + UUID.randomUUID().toString();
						localFilePath = commonUtil.detectPathTraversal(localFilePath);
						
						File localFile = new File(localFilePath);
						
						// URL로부터 다운로드를 시도한다.
						FileUtils.copyURLToFile(new URL(downloadUrl), localFile);
						
						logger.debug("downloaded File Size is " + localFile.length());
						
						if (localFile.length() != 0) {
							// 다운로드한 파일의 Path로 filePath를 변경한다.
							filePath[i] = localFilePath;
							// 다운로드한 파일을 사용 후 삭제하기 위해 다운로드한 파일임을 표시한다.
							downloadedFlags[i] = true;
						// 파일 크기가 0인 경우는 다운로드가 되지 않은 경우이므로 생성된 파일을 삭제한다.
						} else {
							localFile.delete();
						}
					}
				} catch (IOException e) {
					logger.error(e.getMessage(), e);
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
			
			File f = new File(filePath[i]);
			
			if (f.exists()) {
				fileName[i] = doc.getElementsByTagName("DATA1").item(i).getTextContent();
				fileName[i] = fileName[i].replaceAll("[\\\\/:*?\"<>|]", "_");
				fileName[i] = commonUtil.normalizeFileName(fileName[i]);
				fileName[i] = commonUtil.getUniqueFileName(fileName[i], fileNameMap);
				
				if (fileName[i].lastIndexOf(".") > -1) {
					fileExt[i] = fileName[i].substring(fileName[i].lastIndexOf(".") + 1);
					
					if (filePath[i].endsWith("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
						fileExt[i] += "." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT;
					}
					
					newFileName[i] = UUID.randomUUID().toString() + "." + fileExt[i];
				} else {
					fileExt[i] = "";
					newFileName[i] = UUID.randomUUID().toString();
				}
				
				fileSize[i] = f.length();
				totalFileSize += fileSize[i];
			} else {
				logger.debug("Cannot find the file : " + filePath[i]);
				filePath[i] = "NOFILE";
			}
		}
		
		// 총 파일의 크기가 대용량첨부 제한크기를 넘는지 체크한다.
		if (bigMaxSize != 0 && totalFileSize > bigMaxSize) {
			logger.debug("totalFileSize is over bigMaxSize. Return OVERFLOW.");
			
			if (dotNetIntegration.equals("YES")) {
				for (int i = 0; i < fileCnt; i++) {
					// 복호화 URL을 통해 다운로드한 임시 파일들을 삭제한다.
					if (downloadedFlags[i]) {
						logger.debug("deleting " + filePath[i]);
						
						File localFile = new File(filePath[i]);
						
						localFile.delete();
					}
				}
			}
			
			logger.debug("mailInterUploadCopy ended.");
			
			return "OVERSIZE";
		}
		
		StringBuilder sb = new StringBuilder();
		sb.append("<ROOT><NODES>");
		
		if (totalFileSize > changeSize || isBigYN.equals("Y")) { // 대용량첨부의 경우
			logger.debug("In case of big attachment.");
			
			// 현재 날짜의 폴더가 없으면 생성한다.
			String folderDate = EgovDateUtil.getToday("");
			String bigAttachFolderPath = largeFilePath + commonUtil.separator + folderDate;
            File file = new File(bigAttachFolderPath);
            
            if (!file.exists()) {
            	file.mkdirs();
            }
            
            for (int i = 0; i < fileCnt; i++) {
            	if (filePath[i].equals("NOFILE")) {
					continue;
				}
            	
            	FileInputStream fis = null;
				FileOutputStream fos = null;
				FileOutputStream fos2 = null;
				BufferedInputStream bis = null;
				BufferedOutputStream bos = null;
                
				try {
					// CWE-404 보안 취약점 대응
					// 게시판의 첨부파일을 대용량첨부 폴더쪽으로 복사한다.
					fis = new FileInputStream(filePath[i]);
					bis = new BufferedInputStream(fis);
					
					fos = new FileOutputStream(bigAttachFolderPath + commonUtil.separator + newFileName[i]);
					bos = new BufferedOutputStream(fos);
					
					int data = 0;
					byte[] buffer = new byte[BUFF_SIZE];
					
					while ((data = bis.read(buffer, 0, BUFF_SIZE)) != -1) {
						bos.write(buffer, 0, data);
					}
					
					// 첨부파일의 original 이름을 base64로 인코딩하여 첨부파일__.txt에 저장한다.
                	String base64OrgFileName = Base64.encodeBase64String(fileName[i].getBytes("UTF-8"));
                	
                	File fileForName = new File(bigAttachFolderPath + commonUtil.separator + newFileName[i] + "__.txt");
                	fos2 = new FileOutputStream(fileForName);
                	fos2.write(base64OrgFileName.getBytes("ISO-8859-1"));
                	
                	//첨부파일 정보를 XML data로 만든다.
                    String resultUpload = "";
                    
					// 2022-10-11 이사라 - 확장자에 암호화 모듈에서 붙은 추가 확장자(ezd)가 있는 경우 제거하고 비교
					if (fileExt[i].toLowerCase().endsWith(EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
						comparingExt = fileExt[i].toLowerCase().replace("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT, "");
					} else {
						comparingExt = fileExt[i].toLowerCase();
					}

					logger.debug("comparingExt={}", comparingExt);

					// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
    				if ((fileExt[i].isEmpty() || useExtension.toLowerCase().indexOf(comparingExt) == -1) && !useExtension.equals("*")) {
                        resultUpload = "denied";
                    } else {
                        resultUpload = "true";
                    }
    				
    				sb.append("<NODE>");
    				sb.append("<PUPLOADSN><![CDATA[" + newFileName[i] + "]]></PUPLOADSN>");
    				sb.append("<RESULTUPLOADA><![CDATA[" + resultUpload + "]]></RESULTUPLOADA>");
    				sb.append("<PFILENAME><![CDATA[" + fileName[i] + "]]></PFILENAME>");
    				sb.append("<FILESIZE><![CDATA[" + fileSize[i] + "]]></FILESIZE>");
    				sb.append("<FILELOCATION><![CDATA[" + folderDate + "|!|" + newFileName[i] + "]]></FILELOCATION>");
    				sb.append("<PBIGFILEUPLOAD>Y</PBIGFILEUPLOAD>");
    				sb.append("</NODE>");					
                } catch(IOException e) {
                	logger.error(e.getMessage(), e);
				} catch(Exception e) {
                	logger.error(e.getMessage(), e);
                } finally {
                	if (bos != null) {
                		try { bos.close(); 
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
                	}
                	if (bis != null) {
                		try { bis.close(); 
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
                	}
                	if (fos != null) {
                		try { fos.close(); 
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
                	}
                	if (fos2 != null) {
                		try { fos2.close(); 
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
                	}
                	if (fis != null) {
                		try { fis.close(); 
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
                	}
                }                
            }            
		} else { // 일반첨부의 경우
			logger.debug("In case of common attachment.");
			
			File file = new File(pTempFileUploadPath);
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			for (int i = 0; i < fileCnt; i++) {
				if (filePath[i].equals("NOFILE")) {
					continue;
				}
				
				FileInputStream fis = null;
				FileOutputStream fos = null;
				BufferedInputStream bis = null;
				BufferedOutputStream bos = null;
				
				try {
					// 게시판의 첨부파일을 메일 첨부파일 임시폴더쪽으로 복사한다.
					fis = new FileInputStream(filePath[i]);
					bis = new BufferedInputStream(fis);
					
					fos = new FileOutputStream(pTempFileUploadPath + commonUtil.separator + newFileName[i]);
					bos = new BufferedOutputStream(fos);
					
					int data = 0;
					byte[] buffer = new byte[BUFF_SIZE];
					
					while ((data = bis.read(buffer, 0, BUFF_SIZE)) != -1) {
						bos.write(buffer, 0, data);
					}
					
					// 2022-10-11 이사라 - 확장자에 암호화 모듈에서 붙은 추가 확장자(ezd)가 있는 경우 제거하고 비교
					if (fileExt[i].toLowerCase().endsWith(EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
						comparingExt = fileExt[i].toLowerCase().replace("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT, "");
					} else {
						comparingExt = fileExt[i].toLowerCase();
					}

					logger.debug("comparingExt={}", comparingExt);

					//첨부파일 정보를 XML data로 만든다.
					String resultUpload = "";
					
					if (useExtension.toLowerCase().indexOf(comparingExt) == -1 && !useExtension.equals("*")) {
	                    resultUpload = "denied";
	                } else {
	                    resultUpload = "true";
	                }
					
					sb.append("<NODE>");
					sb.append("<PUPLOADSN><![CDATA[" + newFileName[i] + "]]></PUPLOADSN>");
					sb.append("<RESULTUPLOADA><![CDATA[" + resultUpload + "]]></RESULTUPLOADA>");
					sb.append("<PFILENAME><![CDATA[" + fileName[i] + "]]></PFILENAME>");
					sb.append("<FILESIZE><![CDATA[" + fileSize[i] + "]]></FILESIZE>");
					sb.append("<FILELOCATION><![CDATA[" + newFileName[i] + "]]></FILELOCATION>");
					sb.append("<PBIGFILEUPLOAD>N</PBIGFILEUPLOAD>");
					sb.append("</NODE>");					
				} catch (IOException e) {
					logger.error(e.getMessage(), e);
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				} finally {
					if (bos != null) {
                		try { bos.close(); 
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
                	}
                	if (bis != null) {
                		try { bis.close(); 
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
                	}
					if (fos != null) {
						try { fos.close(); 
						} catch(IOException e){logger.debug("e.message=" + e.getMessage());
						} catch(Exception e){logger.debug("e.message=" + e.getMessage());}
					}
					if (fis != null) {
						try { fis.close(); 
						} catch(IOException e){logger.debug("e.message=" + e.getMessage());
						} catch(Exception e){logger.debug("e.message=" + e.getMessage());}
					}
				}
			}			
		}
		
		sb.append("</NODES></ROOT>");
		
		if (dotNetIntegration.equals("YES")) {
			for (int i = 0; i < fileCnt; i++) {
				// 복호화 URL을 통해 다운로드한 임시 파일들을 삭제한다.
				if (downloadedFlags[i]) {
					logger.debug("deleting " + filePath[i]);
					
					File localFile = new File(filePath[i]);
					
					localFile.delete();
				}
			}
		}
		
		// templist폴더에 메일에 대한 첨부파일 정보를 가지고있는 txt파일 생성한다.
        File f = new File(pTempListPath);
        
        if (!f.exists()) {
			f.mkdirs();
        }
        
        f = new File(pTempListPath + commonUtil.separator + tempFolderName + ".txt");
		// 2024.11.01 한슬기 : 기존파일에 덮어쓰기 -> 기존 파일에 업로드 된 파일에 대한 정보를 추가하여 저장하도록 로직 수정
		if(f.exists()) {
			OutputStreamWriter outWrite = null;
			InputStreamReader inputRead = null;
			BufferedReader bufferRead = null;
			String tempXmlList = "";
		
	    	try {
	    		inputRead = new InputStreamReader(new FileInputStream(f));
	    		bufferRead = new BufferedReader(inputRead);
	    		int read = 0;
	    		
	    		while((read = bufferRead.read()) != -1) {
	    			tempXmlList += (char)read;
	    		}
	    		
	    		Document xmlDom = commonUtil.convertStringToDocument(tempXmlList);
	    		Document xmlDom2 = commonUtil.convertStringToDocument(sb.toString());
	    		
	    		NodeList nodeList = xmlDom.getElementsByTagName("NODES");
	    		NodeList nodeList2 = xmlDom2.getElementsByTagName("NODE");
	    		
	    		for (int i = 0; i < nodeList2.getLength(); i++) {
	    			nodeList.item(0).appendChild(xmlDom.importNode(nodeList2.item(i), true));
	    		}
	    		
	    		outWrite = new OutputStreamWriter(new FileOutputStream(f));
	    		outWrite.write(commonUtil.convertDocumentToString(xmlDom));
	    		String crlf = System.getProperty("line.separator");
	    		outWrite.append(crlf+crlf);
	    		
	    	} catch(Exception e) {
	    		logger.error(e.getMessage(), e);
	    	} finally {
	    		if (outWrite != null) {
	    			try { outWrite.close(); } catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
	    		}
	    		
	    		if (bufferRead != null) {
	    			bufferRead.close();
	    		}
	    		
	    		if (inputRead != null) {
	    			inputRead.close();
	    		}
	    	}
		} else {
			try (OutputStreamWriter outWrite = new OutputStreamWriter(Files.newOutputStream(f.toPath()))) {
				outWrite.write(sb.toString());
				String crlf = System.getProperty("line.separator");
				outWrite.append(crlf).append(crlf);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		}
		
		logger.debug("mailInterUploadCopy ended.");
		
		return sb.toString();
	}
	
	/**
	 * <pre>
	 * 메일 DragAndDrop 첨부파일 업로드 실행 함수
	 * - 업무일지에서 메일로 전송 시.
	 * - 서버에 이미 업로드 되어있는 첨부파일을 복사해옴.
	 * - 일반 첨부파일에만 해당됨.
	 * </pre>
	 */
	@RequestMapping(value="/ezEmail/mailInterUploadCopyXCKFromJournal.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailInterUploadCopyFromJournal(
			@CookieValue("loginCookie") String loginCookie, 
			@RequestBody String bodyData,
			HttpServletRequest request) throws Exception {
		logger.debug("mailInterUploadCopyFromJournal started.");
		logger.debug("bodyData=" + bodyData);
		
		String tempFolderName = request.getParameter("STATUS") == null ? "" : request.getParameter("STATUS");
		tempFolderName = commonUtil.detectPathTraversal(tempFolderName);
		String isBigYN = request.getParameter("isbigyn") == null ? "" : request.getParameter("isbigyn"); //isBigYN은 항상 N
		logger.debug("tempFolderName=" + tempFolderName + ",isBigYN=" + isBigYN);
		
		Document doc = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
		String bigMaxSizeStr = doc.getElementsByTagName("BIGMAXSIZE").item(0).getTextContent();
		long bigMaxSize = Long.parseLong(bigMaxSizeStr);
		
		String changeSizeStr = doc.getElementsByTagName("CHANGESIZE").item(0).getTextContent();	
		int changeSize = Integer.parseInt(changeSizeStr);
		
		// String endDate = doc.getElementsByTagName("ENDDAY").item(0).getTextContent();	
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);		
		String realPath = commonUtil.getRealPath(request);		
		String ezJournalPath = realPath + commonUtil.getUploadPath("upload_journal.ROOT", userInfo.getTenantId())+ commonUtil.separator +"uploadFile";		
		String uploadMailRootPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		String pTempFileUploadPath = uploadMailRootPath + commonUtil.separator + "tempFileUpload";
		String pTempListPath = uploadMailRootPath + commonUtil.separator + "templist";
		
		// 2018-10-08 분리된 대용량파일(largeFile) 폴더 사용 여부
		String largeFilePath = uploadMailRootPath;
		String useSeparatedLargeFileFolder = ezCommonService.getTenantConfig("useSeparatedLargeFileFolder", userInfo.getTenantId());

		if (useSeparatedLargeFileFolder.equals("YES")) {
			largeFilePath += commonUtil.separator + "largeFile";
		}

		String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		
		int fileCnt = doc.getElementsByTagName("ROW").getLength();
		String[] fileName = new String[fileCnt];
		String[] filePath = new String[fileCnt];
		long[] fileSize = new long[fileCnt];
		String[] fileExt = new String[fileCnt];
		String[] newFileName = new String[fileCnt];
		String comparingExt = "";
		
		int totalFileSize = 0;
		
		if (tempFolderName.equals("")) {
			logger.debug("tempFolderName is EMPTY. Return NODATA.");
			logger.debug("mailInterUploadCopy ended.");
			
			return "NODATA";
		}
				
		for (int i = 0; i < fileCnt; i++) {
			String filePathValue = doc.getElementsByTagName("DATA2").item(i).getTextContent();		
			filePathValue = filePathValue != null ? filePathValue : "";
			
			filePathValue = URLDecoder.decode(filePathValue,"UTF-8");
			
//			if (!filePathValue.startsWith("/")) {
//				filePathValue = "/" + filePathValue;
//			}
			
			filePath[i] = ezJournalPath + filePathValue;						
			File f = new File(filePath[i]);
			
			if (f.exists()) {
				fileName[i] = doc.getElementsByTagName("DATA1").item(i).getTextContent();
				fileName[i] = fileName[i].replaceAll("[\\\\/:*?\"<>|]", "_");
				fileName[i] = commonUtil.normalizeFileName(fileName[i]);				
				
				if (fileName[i].lastIndexOf(".") > -1) {
					fileExt[i] = fileName[i].substring(fileName[i].lastIndexOf(".") + 1);
					newFileName[i] = UUID.randomUUID().toString() + "." + fileExt[i];
				} else {
					fileExt[i] = "";
					newFileName[i] = UUID.randomUUID().toString();
				}
				
				fileSize[i] = f.length();
				totalFileSize += fileSize[i];
			} else {
				logger.debug("Cannot find the file : " + filePath[i]);
				filePath[i] = "NOFILE";
			}
		}
		
		// 총 파일의 크기가 대용량첨부 제한크기를 넘는지 체크한다.
		if (bigMaxSize != 0 && totalFileSize > bigMaxSize) {
			logger.debug("totalFileSize is over bigMaxSize. Return OVERFLOW.");
						
			logger.debug("mailInterUploadCopyFromJournal ended.");
			
			return "OVERSIZE";
		}
		
		StringBuilder sb = new StringBuilder();
		sb.append("<ROOT><NODES>");
		
		if (totalFileSize > changeSize || isBigYN.equals("Y")) { // 대용량첨부의 경우
			logger.debug("In case of big attachment.");
			
			// 현재 날짜의 폴더가 없으면 생성한다.
			String folderDate = EgovDateUtil.getToday("");
			String bigAttachFolderPath = largeFilePath + commonUtil.separator + folderDate;
			File file = new File(bigAttachFolderPath);
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			for (int i = 0; i < fileCnt; i++) {
				if (filePath[i].equals("NOFILE")) {
					continue;
				}
				
				FileInputStream fis = null;
				FileOutputStream fos = null;
				FileOutputStream fos2 = null;				
				BufferedInputStream bis = null;
				BufferedOutputStream bos = null;
				
				try {
					// CWE-404 보안 취약점 대응
					// 게시판의 첨부파일을 대용량첨부 폴더쪽으로 복사한다.
					fis = new FileInputStream(filePath[i]);
					bis = new BufferedInputStream(fis);
					
					fos = new FileOutputStream(bigAttachFolderPath + commonUtil.separator + newFileName[i]);
					bos = new BufferedOutputStream(fos);
					
					int data = 0;
					byte[] buffer = new byte[BUFF_SIZE];
					
					while ((data = bis.read(buffer, 0, BUFF_SIZE)) != -1) {
						bos.write(buffer, 0, data);
					}
					
					// 첨부파일의 original 이름을 base64로 인코딩하여 첨부파일__.txt에 저장한다.
					String base64OrgFileName = Base64.encodeBase64String(fileName[i].getBytes("UTF-8"));
					
					File fileForName = new File(bigAttachFolderPath + commonUtil.separator + newFileName[i] + "__.txt");
					fos2 = new FileOutputStream(fileForName);
					fos2.write(base64OrgFileName.getBytes("ISO-8859-1"));
					
					// 2022-10-11 이사라 - 확장자에 암호화 모듈에서 붙은 추가 확장자(ezd)가 있는 경우 제거하고 비교
					if (fileExt[i].toLowerCase().endsWith(EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
						comparingExt = fileExt[i].toLowerCase().replace("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT, "");
					} else {
						comparingExt = fileExt[i].toLowerCase();
					}

					logger.debug("comparingExt={}", comparingExt);

					//첨부파일 정보를 XML data로 만든다.
					String resultUpload = "";
					
					// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
					if ((fileExt[i].isEmpty() || useExtension.toLowerCase().indexOf(comparingExt) == -1) && !useExtension.equals("*")) {
						resultUpload = "denied";
					} else {
						resultUpload = "true";
					}
					
					sb.append("<NODE>");
					sb.append("<PUPLOADSN><![CDATA[" + newFileName[i] + "]]></PUPLOADSN>");
					sb.append("<RESULTUPLOADA><![CDATA[" + resultUpload + "]]></RESULTUPLOADA>");
					sb.append("<PFILENAME><![CDATA[" + fileName[i] + "]]></PFILENAME>");
					sb.append("<FILESIZE><![CDATA[" + fileSize[i] + "]]></FILESIZE>");
					sb.append("<FILELOCATION><![CDATA[" + folderDate + "|!|" + newFileName[i] + "]]></FILELOCATION>");
					sb.append("<PBIGFILEUPLOAD>Y</PBIGFILEUPLOAD>");
					sb.append("</NODE>");					
				} catch(IOException e) {
					logger.error(e.getMessage(), e);
				} catch(Exception e) {
					logger.error(e.getMessage(), e);
				} finally {
					if (bos != null) {
						try { bos.close(); 
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
					}
					if (bis != null) {
						try { bis.close(); 
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
					}
					if (fos != null) {
						try { fos.close();
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
					}
                	if (fos2 != null) {
                		try { fos2.close(); 
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
                	}
					if (fis != null) {
						try { fis.close(); 
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
					}
				}                
			}            
		} else { // 일반첨부의 경우
			logger.debug("In case of common attachment.");
			
			File file = new File(pTempFileUploadPath);
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			for (int i = 0; i < fileCnt; i++) {
				if (filePath[i].equals("NOFILE")) {
					continue;
				}
				
				FileInputStream fis = null;
				FileOutputStream fos = null;
				BufferedInputStream bis = null;
				BufferedOutputStream bos = null;
				
				try {
					// 게시판의 첨부파일을 메일 첨부파일 임시폴더쪽으로 복사한다.
					fis = new FileInputStream(filePath[i]);
					bis = new BufferedInputStream(fis);
					
					fos = new FileOutputStream(pTempFileUploadPath + commonUtil.separator + newFileName[i]);
					bos = new BufferedOutputStream(fos);
					
					int data = 0;
					byte[] buffer = new byte[BUFF_SIZE];
					
					while ((data = bis.read(buffer, 0, BUFF_SIZE)) != -1) {
						bos.write(buffer, 0, data);
					}
					
					// 2022-10-11 이사라 - 확장자에 암호화 모듈에서 붙은 추가 확장자(ezd)가 있는 경우 제거하고 비교
					if (fileExt[i].toLowerCase().endsWith(EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
						comparingExt = fileExt[i].toLowerCase().replace("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT, "");
					} else {
						comparingExt = fileExt[i].toLowerCase();
					}

					logger.debug("comparingExt={}", comparingExt);

					//첨부파일 정보를 XML data로 만든다.
					String resultUpload = "";
					
					if (useExtension.toLowerCase().indexOf(comparingExt) == -1 && !useExtension.equals("*")) {
						resultUpload = "denied";
					} else {
						resultUpload = "true";
					}
					
				//	fileName[i] = fileName[i].substring(fileName[i].lastIndexOf(";")+1);
					sb.append("<NODE>");
					sb.append("<PUPLOADSN><![CDATA[" + newFileName[i] + "]]></PUPLOADSN>");
					sb.append("<RESULTUPLOADA><![CDATA[" + resultUpload + "]]></RESULTUPLOADA>");
					sb.append("<PFILENAME><![CDATA[" + fileName[i] + "]]></PFILENAME>");
					sb.append("<FILESIZE><![CDATA[" + fileSize[i] + "]]></FILESIZE>");
					sb.append("<FILELOCATION><![CDATA[" + newFileName[i] + "]]></FILELOCATION>");
					sb.append("<PBIGFILEUPLOAD>N</PBIGFILEUPLOAD>");
					sb.append("</NODE>");					
				} catch (IOException e) {
					logger.error(e.getMessage(), e);
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				} finally {
					if (bos != null) {
						try { bos.close(); 
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
					}
					if (bis != null) {
						try { bis.close(); 
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
					}
					if (fos != null) {
						try { fos.close(); 
						} catch(IOException e){logger.debug("e.message=" + e.getMessage());
						} catch(Exception e){logger.debug("e.message=" + e.getMessage());}
					}
					if (fis != null) {
						try { fis.close(); 
						} catch(IOException e){logger.debug("e.message=" + e.getMessage());
						} catch(Exception e){logger.debug("e.message=" + e.getMessage());}
					}
				}
			}			
		}
		
		sb.append("</NODES></ROOT>");
				
		// templist폴더에 메일에 대한 첨부파일 정보를 가지고있는 txt파일 생성한다.
		File f = new File(pTempListPath);
		
		if (!f.exists()) {
			f.mkdirs();
		}
		
		f = new File(pTempListPath + commonUtil.separator + tempFolderName + ".txt");
		OutputStreamWriter outWrite = null;
		
		try {
			outWrite = new OutputStreamWriter(new FileOutputStream(f));
			outWrite.write(sb.toString());
			String crlf = System.getProperty("line.separator");
			outWrite.append(crlf+crlf);
		} catch(IOException e) {
			logger.error(e.getMessage(), e);
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (outWrite != null) {
				try { outWrite.close(); 
				} catch (IOException e) {logger.debug("e.message=" + e.getMessage());
				} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
			}
		}
		
		logger.debug("mailInterUploadCopyFromJournal ended.");
		
		return sb.toString();
	}
	
	
	
	@RequestMapping(value="/ezEmail/mailInterUploadCopyXCKFromEzPMSBoard.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailInterUploadCopyFromEzPMSBoard(
			@CookieValue("loginCookie") String loginCookie, 
			@RequestBody String bodyData,
			HttpServletRequest request) throws Exception {
		logger.debug("mailInterUploadCopyFromEzPMSBoard started.");
		logger.debug("bodyData=" + bodyData);
		
		String tempFolderName = request.getParameter("STATUS") == null ? "" : request.getParameter("STATUS");
		String isBigYN = request.getParameter("isbigyn") == null ? "" : request.getParameter("isbigyn"); //isBigYN은 항상 N
		logger.debug("tempFolderName=" + tempFolderName + ",isBigYN=" + isBigYN);
		
		Document doc = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
		String bigMaxSizeStr = doc.getElementsByTagName("BIGMAXSIZE").item(0).getTextContent();
		long bigMaxSize = Long.parseLong(bigMaxSizeStr);
		
		String changeSizeStr = doc.getElementsByTagName("CHANGESIZE").item(0).getTextContent();	
		int changeSize = Integer.parseInt(changeSizeStr);
		
		// String endDate = doc.getElementsByTagName("ENDDAY").item(0).getTextContent();	
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String realPath = commonUtil.getRealPath(request);
		
		String journalPath = realPath + commonUtil.getUploadPath("upload_journal.ROOT", userInfo.getTenantId())+ commonUtil.separator +"uploadFile";
		
		String uploadMailRootPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		String pTempFileUploadPath = uploadMailRootPath + commonUtil.separator + "tempFileUpload";
		String pTempListPath = uploadMailRootPath + commonUtil.separator + "templist";
		
		String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		
		int fileCnt = doc.getElementsByTagName("ROW").getLength();
		String[] fileName = new String[fileCnt];
		String[] filePath = new String[fileCnt];
		long[] fileSize = new long[fileCnt];
		String[] fileExt = new String[fileCnt];
		String[] newFileName = new String[fileCnt];
		boolean[] downloadedFlags = new boolean[fileCnt];
		String comparingExt = "";
		
		int totalFileSize = 0;
		
		if (tempFolderName.equals("")) {
			logger.debug("tempFolderName is EMPTY. Return NODATA.");
			logger.debug("mailInterUploadCopy ended.");
			
			return "NODATA";
		}
		
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", userInfo.getTenantId());
		String dotNetUrl = ezCommonService.getTenantConfig("dotNetUrl", userInfo.getTenantId());
		
		for (int i = 0; i < fileCnt; i++) {
			String filePathValue = doc.getElementsByTagName("DATA2").item(i).getTextContent();		
			filePathValue = filePathValue != null ? filePathValue : "";
			
//			if (!filePathValue.startsWith("/")) {
//				filePathValue = "/" + filePathValue;
//			}
			//19.07.09 첨부파일 경로가 인코딩되어서 파일을 찾지 못해 오류가 나므로 decode처리.
			filePathValue = URLDecoder.decode(filePathValue, "UTF-8");
			
			filePath[i] = commonUtil.detectPathTraversal(journalPath + filePathValue);
			
			if (dotNetIntegration.equals("YES")) {
				try {
					File f = new File(filePath[i]);
					
					// 닷넷 연동 시 첨부 파일이 존재하지 않으면 암호화된 파일일 수 있으므로 복호화 URL을 호출하여 다운로드를 시도해 본다.
					if (!f.exists()) {						
						String downloadUrl = dotNetUrl + "/myoffice/Common/DownloadAttach_java.aspx?filename=placeholder"
								+ "&filepath=" + URLEncoder.encode(filePathValue, "UTF-8");
						
						logger.debug("downloadUrl=" + downloadUrl);
						
						// 다운로드된 파일을 저장할 로컬 파일명을 임의로 생성한다.
						String localFilePath = pTempFileUploadPath + commonUtil.separator + UUID.randomUUID().toString();
						File localFile = new File(localFilePath);
						
						// URL로부터 다운로드를 시도한다.
						FileUtils.copyURLToFile(new URL(downloadUrl), localFile);
						
						logger.debug("downloaded File Size is " + localFile.length());
						
						if (localFile.length() != 0) {
							// 다운로드한 파일의 Path로 filePath를 변경한다.
							filePath[i] = localFilePath;
							// 다운로드한 파일을 사용 후 삭제하기 위해 다운로드한 파일임을 표시한다.
							downloadedFlags[i] = true;
							// 파일 크기가 0인 경우는 다운로드가 되지 않은 경우이므로 생성된 파일을 삭제한다.
						} else {
							localFile.delete();
						}
					}
				} catch (IOException e) {
					logger.error(e.getMessage(), e);
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
			
			File f = new File(filePath[i]);
			
			if (f.exists()) {
				fileName[i] = doc.getElementsByTagName("DATA1").item(i).getTextContent();
				fileName[i] = fileName[i].replaceAll("[\\\\/:*?\"<>|]", "_");
				fileName[i] = commonUtil.normalizeFileName(fileName[i]);
				
				if (fileName[i].lastIndexOf(".") > -1) {
					fileExt[i] = fileName[i].substring(fileName[i].lastIndexOf(".") + 1);
					newFileName[i] = UUID.randomUUID().toString() + "." + fileExt[i];
				} else {
					fileExt[i] = "";
					newFileName[i] = UUID.randomUUID().toString();
				}
//				newFileName[i] = newFileName[i].substring(newFileName[i].lastIndexOf(";")+1);
				
				fileSize[i] = f.length();
				totalFileSize += fileSize[i];
			} else {
				logger.debug("Cannot find the file : " + filePath[i]);
				filePath[i] = "NOFILE";
			}
		}
		
		// 총 파일의 크기가 대용량첨부 제한크기를 넘는지 체크한다.
		if (bigMaxSize != 0 && totalFileSize > bigMaxSize) {
			logger.debug("totalFileSize is over bigMaxSize. Return OVERFLOW.");
			
			if (dotNetIntegration.equals("YES")) {
				for (int i = 0; i < fileCnt; i++) {
					// 복호화 URL을 통해 다운로드한 임시 파일들을 삭제한다.
					if (downloadedFlags[i]) {
						logger.debug("deleting " + filePath[i]);
						
						File localFile = new File(filePath[i]);
						
						localFile.delete();
					}
				}
			}
			
			logger.debug("mailInterUploadCopy ended.");
			
			return "OVERSIZE";
		}
		
		StringBuilder sb = new StringBuilder();
		sb.append("<ROOT><NODES>");
		
		if (totalFileSize > changeSize || isBigYN.equals("Y")) { // 대용량첨부의 경우
			logger.debug("In case of big attachment.");
			
			// 2018-10-08 분리된 대용량파일(largeFile) 폴더 사용 여부
			String largeFilePath = uploadMailRootPath;
			String useSeparatedLargeFileFolder = ezCommonService.getTenantConfig("useSeparatedLargeFileFolder", userInfo.getTenantId());

			if (useSeparatedLargeFileFolder.equals("YES")) {
				largeFilePath += commonUtil.separator + "largeFile";
			}
			
			// 현재 날짜의 폴더가 없으면 생성한다.
			String folderDate = EgovDateUtil.getToday("");
			String bigAttachFolderPath = largeFilePath + commonUtil.separator + folderDate;
			File file = new File(bigAttachFolderPath);
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			for (int i = 0; i < fileCnt; i++) {
				if (filePath[i].equals("NOFILE")) {
					continue;
				}
				
				FileInputStream fis = null;
				FileOutputStream fos = null;
				BufferedInputStream bis = null;
				BufferedOutputStream bos = null;
				
				try {
					// CWE-404 보안 취약점 대응
					try {
						// 게시판의 첨부파일을 대용량첨부 폴더쪽으로 복사한다.
						fis = new FileInputStream(filePath[i]);
						bis = new BufferedInputStream(fis);
						
						fos = new FileOutputStream(bigAttachFolderPath + commonUtil.separator + newFileName[i]);
						bos = new BufferedOutputStream(fos);
						
						int data = 0;
						byte[] buffer = new byte[BUFF_SIZE];
						
						while ((data = bis.read(buffer, 0, BUFF_SIZE)) != -1) {
							bos.write(buffer, 0, data);
						}
					} finally {					
						bos.close(); bos = null;
						bis.close(); bis = null;
						fos.close(); fos = null;
						fis.close(); fis = null;
					}
					
					// 첨부파일의 original 이름을 base64로 인코딩하여 첨부파일__.txt에 저장한다.
					String base64OrgFileName = Base64.encodeBase64String(fileName[i].getBytes("UTF-8"));
					
					file = new File(bigAttachFolderPath + commonUtil.separator + newFileName[i] + "__.txt");
					fos = new FileOutputStream(file);
					fos.write(base64OrgFileName.getBytes("ISO-8859-1"));
					
					// 2022-10-11 이사라 - 확장자에 암호화 모듈에서 붙은 추가 확장자(ezd)가 있는 경우 제거하고 비교
					if (fileExt[i].toLowerCase().endsWith(EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
						comparingExt = fileExt[i].toLowerCase().replace("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT, "");
					} else {
						comparingExt = fileExt[i].toLowerCase();
					}

					logger.debug("comparingExt={}", comparingExt);

					//첨부파일 정보를 XML data로 만든다.
					String resultUpload = "";
					
					// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
					if ((fileExt[i].isEmpty() || useExtension.toLowerCase().indexOf(comparingExt) == -1) && !useExtension.equals("*")) {
						resultUpload = "denied";
					} else {
						resultUpload = "true";
					}
					
					sb.append("<NODE>");
					sb.append("<PUPLOADSN><![CDATA[" + newFileName[i] + "]]></PUPLOADSN>");
					sb.append("<RESULTUPLOADA><![CDATA[" + resultUpload + "]]></RESULTUPLOADA>");
					sb.append("<PFILENAME><![CDATA[" + fileName[i] + "]]></PFILENAME>");
					sb.append("<FILESIZE><![CDATA[" + fileSize[i] + "]]></FILESIZE>");
					sb.append("<FILELOCATION><![CDATA[" + folderDate + "|!|" + newFileName[i] + "]]></FILELOCATION>");
					sb.append("<PBIGFILEUPLOAD>Y</PBIGFILEUPLOAD>");
					sb.append("</NODE>");					
				} catch(IOException e) {
					logger.error(e.getMessage(), e);
				} catch(Exception e) {
					logger.error(e.getMessage(), e);
				} finally {
					if (bos != null) {
						try { bos.close(); 
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
					}
					if (bis != null) {
						try { bis.close(); 
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
					}
					if (fos != null) {
						try { fos.close(); 
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
					}
					if (fis != null) {
						try { fis.close(); 
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
					}
				}                
			}            
		} else { // 일반첨부의 경우
			logger.debug("In case of common attachment.");
			
			File file = new File(pTempFileUploadPath);
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			for (int i = 0; i < fileCnt; i++) {
				if (filePath[i].equals("NOFILE")) {
					continue;
				}
				
				FileInputStream fis = null;
				FileOutputStream fos = null;
				BufferedInputStream bis = null;
				BufferedOutputStream bos = null;
				
				try {
					// 게시판의 첨부파일을 메일 첨부파일 임시폴더쪽으로 복사한다.
					fis = new FileInputStream(filePath[i]);
					bis = new BufferedInputStream(fis);
					
					fos = new FileOutputStream(pTempFileUploadPath + commonUtil.separator + newFileName[i]);
					bos = new BufferedOutputStream(fos);
					
					int data = 0;
					byte[] buffer = new byte[BUFF_SIZE];
					
					while ((data = bis.read(buffer, 0, BUFF_SIZE)) != -1) {
						bos.write(buffer, 0, data);
					}
					
					// 2022-10-11 이사라 - 확장자에 암호화 모듈에서 붙은 추가 확장자(ezd)가 있는 경우 제거하고 비교
					if (fileExt[i].toLowerCase().endsWith(EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
						comparingExt = fileExt[i].toLowerCase().replace("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT, "");
					} else {
						comparingExt = fileExt[i].toLowerCase();
					}

					logger.debug("comparingExt={}", comparingExt);

					//첨부파일 정보를 XML data로 만든다.
					String resultUpload = "";
					
					if (useExtension.toLowerCase().indexOf(fileExt[i].toLowerCase()) == -1 && !useExtension.equals("*")) {
						resultUpload = "denied";
					} else {
						resultUpload = "true";
					}
					
				//	fileName[i] = fileName[i].substring(fileName[i].lastIndexOf(";")+1);
					sb.append("<NODE>");
					sb.append("<PUPLOADSN><![CDATA[" + newFileName[i] + "]]></PUPLOADSN>");
					sb.append("<RESULTUPLOADA><![CDATA[" + resultUpload + "]]></RESULTUPLOADA>");
					sb.append("<PFILENAME><![CDATA[" + fileName[i] + "]]></PFILENAME>");
					sb.append("<FILESIZE><![CDATA[" + fileSize[i] + "]]></FILESIZE>");
					sb.append("<FILELOCATION><![CDATA[" + newFileName[i] + "]]></FILELOCATION>");
					sb.append("<PBIGFILEUPLOAD>N</PBIGFILEUPLOAD>");
					sb.append("</NODE>");					
				} catch (IOException e) {
					logger.error(e.getMessage(), e);
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				} finally {
					if (bos != null) {
						try { bos.close(); 
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
					}
					if (bis != null) {
						try { bis.close(); 
						} catch(IOException e) {logger.debug("e.message=" + e.getMessage());
						} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
					}
					if (fos != null) {
						try { fos.close(); 
						} catch(IOException e){logger.debug("e.message=" + e.getMessage());
						} catch(Exception e){logger.debug("e.message=" + e.getMessage());}
					}
					if (fis != null) {
						try { fis.close(); 
						} catch(IOException e){logger.debug("e.message=" + e.getMessage());
						} catch(Exception e){logger.debug("e.message=" + e.getMessage());}
					}
				}
			}			
		}
		
		sb.append("</NODES></ROOT>");
		
		if (dotNetIntegration.equals("YES")) {
			for (int i = 0; i < fileCnt; i++) {
				// 복호화 URL을 통해 다운로드한 임시 파일들을 삭제한다.
				if (downloadedFlags[i]) {
					logger.debug("deleting " + filePath[i]);
					
					File localFile = new File(filePath[i]);
					
					localFile.delete();
				}
			}
		}
		
		// templist폴더에 메일에 대한 첨부파일 정보를 가지고있는 txt파일 생성한다.
		File f = new File(pTempListPath);
		
		if (!f.exists()) {
			f.mkdirs();
		}
		
		f = new File(commonUtil.detectPathTraversal(pTempListPath + commonUtil.separator + tempFolderName + ".txt"));
		OutputStreamWriter outWrite = null;
		
		try {
			outWrite = new OutputStreamWriter(new FileOutputStream(f));
			outWrite.write(sb.toString());
			String crlf = System.getProperty("line.separator");
			outWrite.append(crlf+crlf);
		} catch(IOException e) {
			logger.error(e.getMessage(), e);
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (outWrite != null) {
				try { outWrite.close(); 
				} catch (IOException e) {logger.debug("e.message=" + e.getMessage());
				} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
			}
		}
		
		logger.debug("mailInterUploadCopyFromEzPMSBoard ended.");
		
		return sb.toString();
	}
	
    /**
	 * 첨부파일을 포함한 메일을 임시 보관함에 저장하는 함수
	 */
	@RequestMapping(value="/ezEmail/mailInterAttachCK.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailInterAttach(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			HttpServletRequest request) throws Exception{
		logger.debug("mailInterAttach started.");
		
		String returnValue = "";
		String cmd = "";
		Document xmldom = commonUtil.convertRequestToDocument(request);
		if (xmldom != null){
			cmd = xmldom.getElementsByTagName("CMD").item(0).getTextContent();
			String uidStr = xmldom.getElementsByTagName("URL").item(0).getTextContent();
			NodeList bigs = xmldom.getElementsByTagName("BIG");
			boolean hasAttachFile = false;

			if (bigs != null) {
				for (int i = 0; i < bigs.getLength(); i++) {
					if (bigs.item(i).getTextContent().equals("N")) {
						// 일반첨부파일이 있는 경우
						hasAttachFile = true;
						break;
					}
				}
			}

			List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
			String password  = userInfo.get(1);

			long uid = 0;

			if (uidStr != null && !uidStr.equals("")) {
				uid = Long.parseLong(uidStr);
			}

			LoginVO loginInfo = commonUtil.userInfo(loginCookie);

			String realPath = commonUtil.getRealPath(request);
			String pDirTempPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", loginInfo.getTenantId()) + commonUtil.separator + "tempFileUpload";
			String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
			String userEmail = loginInfo.getId() + "@" + domainName;
			String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());

			if (useSharedMailbox.equals("YES")) {
				String shareId = request.getParameter("shareId");
				logger.debug("shareId=" + shareId);
				
				if (shareId != null) {
					if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, 2, loginInfo.getTenantId())) {
						logger.debug("the user cannot access the shareId.");
						logger.debug("mailInterAttach ended.");
						
						return "";
					}
					
					userEmail = shareId + "@" + domainName;
				}
			}
			
			logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail + ",uid=" + uid + ",hasAttachFile=" + hasAttachFile);
			
			MimeMessage newMessage = null;
			IMAPAccess ia = null;
			Folder folder = null;
			Multipart multipart = null;
			
			try {			
				if (hasAttachFile) {
					SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
							userEmail, password);
					
					// 첨부파일들을 추가하여 임시 보관함에 저장할 메시지를 생성한다.
					newMessage = sa.createMimeMessage();
					
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userEmail, password, egovMessageSource, locale, ezEmailUtil);
					
					// 임시 보관함 폴더 오픈 
					folder = ia.getFolder(ezEmailUtil.getDraftsFolderId(locale));
					folder.open(Folder.READ_WRITE);
					
					// 첨부파일 Part들을 삽입할 Multipart를 생성한다.
					multipart = new MimeMultipart();
				}
				
				if (cmd.equals("ADD")) {
					NodeList fileNodes = xmldom.getElementsByTagName("FILE");
					
					// 임시 보관함에 이미 기존 메시지가 있는 경우, 해당 메시지의 파트들을 새 메시지에 병합한다.
					if (hasAttachFile && uid != 0) {
						// 임시 보관함에 있는 메시지를 가져온다.
						Message oldMessage = ((IMAPFolder)folder).getMessageByUID(uid);
						
						if (oldMessage != null) {
							// 기존 메시지가 Multipart인 경우 처리
							if (oldMessage.getContent() instanceof Multipart) {
								Multipart mp = (Multipart)oldMessage.getContent();
								int count = mp.getCount();
								BodyPart p = null;
								
								// 임시 보관함에 있는 메시지가 multipart/related일 때는 새롭게 related 파트로 구성한 다음
								// 새 메시지의 서브 파트로 추가한다.
								if (oldMessage.isMimeType("multipart/related")) {
									logger.debug("oldMessage is multipart/related");
									
									Multipart relatedPart = new MimeMultipart("related");
									
									for (int i = 0; i < count; i++) {
										p = mp.getBodyPart(i);
										
										// 코린도에서 수신한 메일 중 multipart/related 안에 첨부 파일이 있는 경우가 있어
										// 해당 첨부 파일을 multipart/mixed 파트로 옮기도록 한다.
										if (p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)) {
											multipart.addBodyPart(p);
										} else {
											relatedPart.addBodyPart(p);
										}
									}
									
									// relatedPart에 속한 파트가 하나도 없는 경우 삽입하면 메시지가
									// 정상적으로 생성되지 않는다.
									if (relatedPart.getCount() > 0) {
										MimeBodyPart wrap = new MimeBodyPart();
										wrap.setContent(relatedPart);
										multipart.addBodyPart(wrap, 0);
									}
								} else if (oldMessage.isMimeType("multipart/alternative")) {
									logger.debug("oldMessage is multipart/alternative");
									
									Multipart alternativePart = new MimeMultipart("alternative");
									
									for (int i = 0; i < count; i++) {
										p = mp.getBodyPart(i); 
										alternativePart.addBodyPart(p);
									}
									
									MimeBodyPart wrap = new MimeBodyPart();
									wrap.setContent(alternativePart);
									multipart.addBodyPart(wrap, 0);							    
								} else {								
									for (int i = 0; i < count; i++) {
										p = mp.getBodyPart(i);
										multipart.addBodyPart(p);
									}
								}
							}
							
							// 기존 메시지의 모든 헤더를 적용한다.
							@SuppressWarnings("unchecked")
							Enumeration<Header> e = oldMessage.getAllHeaders();
							
							while (e.hasMoreElements()) {
								Header header = e.nextElement();
								newMessage.setHeader(header.getName(), header.getValue());
							}
							
							// 기존 메시지를 제거한다.
							oldMessage.setFlag(Flags.Flag.DELETED, true);
						}
					}
					
					// 새로 업로드된 파일들을 새 메시지에 추가한다.
					for (int i = 0; i < fileNodes.getLength(); i++) {
						Node subNode = fileNodes.item(i);
						NodeList childNodes = subNode.getChildNodes();
						String fileName = childNodes.item(0).getTextContent();
						String path = childNodes.item(1).getTextContent();
						path = commonUtil.detectPathTraversal(path);
						String bigBool = childNodes.item(2).getTextContent();
						
						// 일반첨부파일의 경우
						if (hasAttachFile && bigBool.equals("N")) {
							// 첨부파일을 삽입할 Part를 생성한다.
							BodyPart messageBodyPart = new MimeBodyPart();

							File f = new File(pDirTempPath + commonUtil.separator + path);

							// 2018.07.05 - ezd 파일은 복호화하여 넣는다. (KLIB)
							if (f.toString().endsWith("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
								byte[] fileBytes = commonUtil.readBytesFromFile(f.toPath());
								byte[] decryptedBytes = klibUtil.decrypt(fileBytes);

								messageBodyPart.setDataHandler(new DataHandler(new ByteArrayDataSource(decryptedBytes, "application/octet-stream")));
							} else {
								FileDataSource source = new FileDataSource(pDirTempPath + commonUtil.separator + path);
								messageBodyPart.setDataHandler(new DataHandler(source));
							}

							String nfcFilename = commonUtil.normalizeFileName(fileName);

							// MimeUtility.encodeText is needed to encode a file name in UTF-8 explicitly, 
							// otherwise, a wrong encoding may be used on some systems(linux, etc)
							// nonghyup.com 메일 서버의 경우 QP로 인코딩된 경우 connection close(EOF)를 발생시켜
							// 무조건 BASE64로 인코딩하도록 변경함
							String encodedFileName = MimeUtility.encodeText(nfcFilename, "UTF-8", "B");

							// folding a filename is done manually since BodyPart.setFileName method encodes it based on RFC 2231.
							// and some mailers (Daum, etc) may not understand it.			        
							encodedFileName = MimeUtility.fold(0, encodedFileName);
							messageBodyPart.setHeader("Content-Disposition", "attachment;\r\n filename=\"" + encodedFileName + "\"");
							
							String contentType = null;

							// 첨부파일의 Content-Type을 구한다.
							BufferedInputStream stream = null;
							try {
								stream = new BufferedInputStream(new FileInputStream(f));
								contentType = URLConnection.guessContentTypeFromStream(stream);
							} catch (Exception e) {
								
								logger.error(e.getMessage(),e);
								
							} finally {
								if (stream != null) {
									stream.close();
								}
							}

							if (contentType == null) {
								contentType = Files.probeContentType(f.toPath());
							} else {
								if (path.lastIndexOf(".") > 0 && path.substring(path.lastIndexOf(".")).equalsIgnoreCase(".eml")) {
									contentType = "message/rfc822";
								}
							}

							if (contentType == null) {
								// 첨부파일 Content-Type의 디폴트는 application/octet-stream로 설정한다.
								contentType = "application/octet-stream";
							}
							
							messageBodyPart.setHeader("Content-Type", contentType);

							// Multipart에 첨부파일 Part를 삽입한다.
							multipart.addBodyPart(messageBodyPart);

							//TODO: fileName parameter를 attachCount로 바꿔야 할것같음. 또는 (filename, attachCount).
							//메일에서 첨부파일 삭제할 때 attachCount 필요함.
							childNodes.item(4).setTextContent(fileName);
						} else {						
							if (!path.equals("")) {
								String[] newPath = path.split("\\|!\\|");
								childNodes.item(1).setTextContent(newPath[1]);
								childNodes.item(4).setTextContent(newPath[0] + commonUtil.separator + newPath[1]);
							}
						}
					}
					
					if (hasAttachFile) {
						newMessage.setContent(multipart);
						newMessage.setFlag(Flags.Flag.SEEN, true);
						AppendUID[] uids = ((IMAPFolder)folder).appendUIDMessages(new Message[]{newMessage});
						
						uid = uids[0].uid;
						xmldom.getElementsByTagName("URL").item(0).setTextContent(String.valueOf(uid));
					} else {					
						if (uid == 0) {
							xmldom.getElementsByTagName("URL").item(0).setTextContent("");
						} else {
							xmldom.getElementsByTagName("URL").item(0).setTextContent(String.valueOf(uid));
						}
					}
					
					// 처리가 완료된 일반첨부파일 원본 파일들을 삭제한다.				
					for (int i=0; i<fileNodes.getLength(); i++) {
						Node subNode = fileNodes.item(i);
						NodeList childNodes = subNode.getChildNodes();
						
						if (childNodes.item(2).getTextContent().equals("N")) {
							String childNodeContent = commonUtil.detectPathTraversal(childNodes.item(1).getTextContent());
							File file = new File(pDirTempPath + commonUtil.separator + childNodeContent);
							
							if (file.exists()) {
								file.delete();
							}
						}
					}
				}
				
				if (hasAttachFile) {
					folder.close(true);
				}
				
				returnValue = commonUtil.convertDocumentToString(xmldom);			
			} catch (MessagingException e) {
				returnValue = e.getMessage();
				logger.error(e.getMessage(), e);
			} finally {			
				if (ia != null) {
					ia.close();
				}
			}
			
			logger.debug("mailInterAttach ended. uid=" + uid);
		}
		
		return returnValue;
	}

	/**
	 * 메일 전송 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailInterSend.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailInterSend(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, Model model, 
			HttpServletRequest request,
			@RequestBody String bodyData) throws Exception {
		logger.debug("mailInterSend started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String password = commonUtil.getUserIdAndPassword(loginCookie).get(1);
		
		String userId = userInfo.getId();
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String https = "YES".equals(ezCommonService.getTenantConfig("USE_HTTPS", userInfo.getTenantId())) ? "https://" : "http://";
		String serverNameByTenantId = ezCommonService.getTenantConfig("serverName", userInfo.getTenantId());
		String userAccount = userId + "@" + domainName;
		String mailId = userId;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		String mailMaxReceiverCount = ezCommonService.getTenantConfig("mailMaxReceiverCount", userInfo.getTenantId());
		
		if (mailMaxReceiverCount.equals("")) {
			mailMaxReceiverCount = "200";
		}
		
		String shareId = "";
		if (useSharedMailbox.equals("YES")) {
			shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, 2, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailInterSend ended.");
					
					return "";
				}
				
				mailId = shareId;
				userAccount = shareId + "@" + domainName;
			}
		}
		
		logger.debug("userId=" + userInfo.getId() + ",userAccount=" + userAccount);
		
		//변수들은 메일발송 실패 시 다시 사용되므로 메일발송 로직 도중 값이 바뀌면 안된다.
		String url = "";
		String orgUrl = "";
		String cmd = "";
		String mailCmd = "";
		String orgMailCmd = "";
		String eShowDisplayName = "";
		String from = "";
		String to = "";
		String cc = "";
		String bcc = "";
		String textBody = "";
		String importance = "";
		String subject = "";
		String simpleMime = "";
		String delaySendTime = "";
		String htmlBody = "";
		// String pSecurityMail = "";
		String replySendTime = "";
		String replyReadTime = "";
		String isEachMail = "";
		String isReserve = "";
		String reservedId = "";
		String stateName = "";
		boolean isSecureMail = false;
		String securePassword = null;
		String secureReadCount = null;
		String secureReadDate = null;
		String securePasswordHint = "";
		int secureId = 0;
		/* String connUrl = "";
		String author = "";
		String pMessageID = "";
		String eCharSet = "";
		String eContentTransferEncoding = "";
		String eSimpleMIME = "";
		String eSimpleMIMEContentTransferEncoding = ""; */
		String modeFlag = ""; // 20190807 김수아 : 메일 작성 미리보기
		boolean apprmail = false; // 승인메일 정책에 걸려 승인메일 신청인 경우 true, 승인메일 프로세스를 타지 않을 경우 false
		String apprmailType = ""; // 승인메일 정책 종류. ALL_HANDS:전사메일 승인 신청, NORMAL(all_hands외 문자들):일반메일 승인 신청
		String apprmailApprover = ""; // 승인메일 승인자 CN

		String realPath = commonUtil.getRealPath(request);
		List<Map<String, Object>> addressCheck = null; 		// 메일 주소록 자동저장을 위한 name, address 담을 list

		bodyData = bodyData != null ? bodyData : "";
		// 클라이언트로부터 전달된 XML 형태의 요청 데이터를 XML 문서로 변환한다.
		Document xmlDoc = commonUtil.convertStringToDocument(bodyData);
		
		if (xmlDoc == null) {
			return "<DATA>parse error</DATA>";
		}
		
		Element root = xmlDoc.getDocumentElement();
		
		Node tempNode = null;
		
		// 클라이언트로부터 전달된 요청 패러메터들을 추출한다.
		if (root.getElementsByTagName("URL") != null) {
			tempNode = root.getElementsByTagName("URL").item(0);
			if (tempNode != null) {
				url = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("ORGURL") != null) {
			tempNode = root.getElementsByTagName("ORGURL").item(0);
			if (tempNode != null) {
				orgUrl = tempNode.getTextContent();
			}
		}
		/* if (root.getElementsByTagName("CONNURL") != null) {
			tempNode = root.getElementsByTagName("CONNURL").item(0);
			if (tempNode != null) {
				connUrl = tempNode.getTextContent();
			}
		} */
		if (root.getElementsByTagName("CMD") != null) {
			tempNode = root.getElementsByTagName("CMD").item(0);
			if (tempNode != null) {
				cmd = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("MAILCMD") != null) {
			tempNode = root.getElementsByTagName("MAILCMD").item(0);
			if (tempNode != null) {
				mailCmd = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("ORGMAILCMD") != null) {
			tempNode = root.getElementsByTagName("ORGMAILCMD").item(0);
			if (tempNode != null) {
				orgMailCmd = tempNode.getTextContent();
			}
		}
		/* if (root.getElementsByTagName("AUTHOR") != null) {
			tempNode = root.getElementsByTagName("AUTHOR").item(0);
			if (tempNode != null) {
				author = tempNode.getTextContent();
			}
		} */
		if (root.getElementsByTagName("SUBJECT") != null) {
			tempNode = root.getElementsByTagName("SUBJECT").item(0);
			if (tempNode != null) {
				subject = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("TO") != null) {
			tempNode = root.getElementsByTagName("TO").item(0);
			if (tempNode != null) {
				to = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("CC") != null) {
			tempNode = root.getElementsByTagName("CC").item(0);
			if (tempNode != null) {
				cc = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("BCC") != null) {
			tempNode = root.getElementsByTagName("BCC").item(0);
			if (tempNode != null) {
				bcc = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("FROM") != null) {
			tempNode = root.getElementsByTagName("FROM").item(0);
			if (tempNode != null) {
				from = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("IMPORTANCE") != null) {
			tempNode = root.getElementsByTagName("IMPORTANCE").item(0);
			if (tempNode != null) {
				importance = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("SIMPLE-MIME") != null) {
			tempNode = root.getElementsByTagName("SIMPLE-MIME").item(0);
			if (tempNode != null) {
				simpleMime = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("DELAYSENDTIME") != null) {
			tempNode = root.getElementsByTagName("DELAYSENDTIME").item(0);
			if (tempNode != null) {
				delaySendTime = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("HTMLBODY") != null) {
			tempNode = root.getElementsByTagName("HTMLBODY").item(0);
			if (tempNode != null) {
				htmlBody = tempNode.getTextContent();
				
				String hostUrl = request.getScheme()
						+ "://"
						+ request.getServerName()
						+ ("http".equals(request.getScheme())
								&& request.getServerPort() == 80
								|| "https".equals(request.getScheme())
								&& request.getServerPort() == 443 ? "" : ":"
								+ request.getServerPort());
				
				logger.debug("hostUrl=" + hostUrl);
				
				// 쿠쿠닥스 에디터의 경우 인라인 이미지 태그의 src가 http://호스트명:포트 와 같이 시작하여 이를 제거하도록 함
				htmlBody = htmlBody.replaceAll("src=\"" + hostUrl + "/ezEmail/downloadInline\\.do", "src=\"/ezEmail/downloadInline\\.do");
			}
		}
		/* if (root.getElementsByTagName("SECURITYMAIL") != null) {
			tempNode = root.getElementsByTagName("SECURITYMAIL").item(0);
			if (tempNode != null) {
				pSecurityMail = tempNode.getTextContent();
			}
		} */
		if (root.getElementsByTagName("REPLYSENDTIME") != null) {
			tempNode = root.getElementsByTagName("REPLYSENDTIME").item(0);
			if (tempNode != null) {
				replySendTime = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("REPLYREADTIME") != null) {
			tempNode = root.getElementsByTagName("REPLYREADTIME").item(0);
			if (tempNode != null) {
				replyReadTime = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("ISEACHMAIL") != null) {
			tempNode = root.getElementsByTagName("ISEACHMAIL").item(0);
			if (tempNode != null) {
				isEachMail = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("ISRESERVE") != null) {
			tempNode = root.getElementsByTagName("ISRESERVE").item(0);
			if (tempNode != null) {
				isReserve = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("RESERVEDID") != null) {
			tempNode = root.getElementsByTagName("RESERVEDID").item(0);
			if (tempNode != null) {
				reservedId = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("SHOW-DISPLAYNAME") != null) {
			tempNode = root.getElementsByTagName("SHOW-DISPLAYNAME").item(0);
			if (tempNode != null) {
				eShowDisplayName = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("STATENAME") != null) {
			tempNode = root.getElementsByTagName("STATENAME").item(0);
			if (tempNode != null) {
				stateName = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("SECUREMAIL") != null) {
			tempNode = root.getElementsByTagName("SECUREMAIL").item(0);
			if (tempNode != null && tempNode.getTextContent() != null && tempNode.getTextContent().equalsIgnoreCase("TRUE")) {
				isSecureMail = true;

				if (root.getElementsByTagName("SECUREPASSWORD") != null) {
					tempNode = root.getElementsByTagName("SECUREPASSWORD").item(0);
					if (tempNode != null) {
						securePassword = tempNode.getTextContent();

					}
				}
				if (root.getElementsByTagName("SECUREREADCOUNT") != null) {
					tempNode = root.getElementsByTagName("SECUREREADCOUNT").item(0);
					if (tempNode != null) {
						secureReadCount = tempNode.getTextContent();
					}
				}
				if (root.getElementsByTagName("SECUREREADDATE") != null) {
					tempNode = root.getElementsByTagName("SECUREREADDATE").item(0);
					if (tempNode != null) {
						secureReadDate = tempNode.getTextContent();
					}
				}
				if (root.getElementsByTagName("SECUREPASSWORDHINT") != null) {
					tempNode = root.getElementsByTagName("SECUREPASSWORDHINT").item(0);
					if (tempNode != null) {
						securePasswordHint = tempNode.getTextContent();

					}
				}
			}
		}
		if (root.getElementsByTagName("MODEFLAG") != null) {
			tempNode = root.getElementsByTagName("MODEFLAG").item(0);
			if (tempNode != null) {
				modeFlag = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("APPRMAIL") != null) { // 승인메일 프로세스 태움 여부
			tempNode = root.getElementsByTagName("APPRMAIL").item(0);
			if (tempNode != null && tempNode.getTextContent() != null && tempNode.getTextContent().equalsIgnoreCase("TRUE")) {
				apprmail = true;
			}
		}
		if (root.getElementsByTagName("APPRMAIL_TYPE") != null) { // 승인메일 종류. ALL_HANDS:전사메일 승인 신청, NORMAL(all_hands외 문자들):일반메일 승인 신청
			tempNode = root.getElementsByTagName("APPRMAIL_TYPE").item(0);
			if (tempNode != null && tempNode.getTextContent() != null) {
				apprmailType = (!"ALL_HANDS".equalsIgnoreCase(tempNode.getTextContent())) ? "NORMAL" : "ALL_HANDS";
			}
		}
		if (root.getElementsByTagName("APPRMAIL_APPROVER") != null) { // 승인메일 승인자 CN
			tempNode = root.getElementsByTagName("APPRMAIL_APPROVER").item(0);
			if (tempNode != null && tempNode.getTextContent() != null) {
				apprmailApprover = tempNode.getTextContent();
			}
		}

		// 승인메일 공유사서함 계정
		String apprSharedMailBox = "";
		if (apprmail) {
			apprSharedMailBox = ezEmailUtil.getApprSharedMailBox(userInfo.getTenantId(), locale, password);

			if ("APPR_ERROR".equals(apprSharedMailBox)) {
				throw new Exception("APPR_ERROR");
			} else {
				mailId = apprSharedMailBox; // 보안메일일 경우 보안메일 테이블에 저장되기 위해 승인메일 공유사서함 아이디로 변경
				apprSharedMailBox = apprSharedMailBox + "@" + domainName;
			}

			logger.debug("apprmail apprSharedMailBox={}", apprSharedMailBox);
		}
		
		// set textBody
		// tempNode.getTextContent()로 가져오면 whitespace가 모두 없어져서 bodyData에서 잘라서 가져오도록 수정함.
		int sTextBodyIndex = bodyData.indexOf("<TEXTBODY>");
		int eTextBodyIndex = bodyData.indexOf("</TEXTBODY>");
		if (sTextBodyIndex > -1 && eTextBodyIndex > sTextBodyIndex) {
			textBody = bodyData.substring(sTextBodyIndex + 10, eTextBodyIndex);
			textBody = textBody.replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&amp;", "&");
		}
		
//		// 다국어 발송 관련 변수들
//      string eCharSet = xmlDoc.GetElementsByTagName("CHARSET").Item(0).InnerText;
//      string eContentTransferEncoding = xmlDoc.GetElementsByTagName("CONTENT-TRANSFER-ENCODING").Item(0).InnerText;
//      string eSimpleMIME = xmlDoc.GetElementsByTagName("SIMPLE-MIME").Item(0).InnerText;
//      string eSimpleMIMEContentTransferEncoding = xmlDoc.GetElementsByTagName("SIMPLE-MIME-CONTENT-TRANSFER-ENCODING").Item(0).InnerText;
		
		/*SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
				userAccount, password);*/
		SMTPAccess sa = ezEmailUtil.getSMTPServer(userAccount, password, userInfo.getEmail(), userInfo.getTenantId());
		
		String pResult = null;
		IMAPAccess ia = null;
		boolean retryFlag = false;
		int retryCount = 1; //메일 발송 실패 시 재시도 횟수
		long draftUID = 0;
		long sentFolderMessageUID = 0;
		boolean mailSendCompleted = false;
		
		do {
			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userAccount, password, egovMessageSource, locale, ezEmailUtil, apprSharedMailBox);
				
				//메일 발송 재시도일 경우 draftUID의 메일을 지우고 retryFlag와 draftUID를 초기화한다.
				if (retryFlag) {
				    if (draftUID != 0) {
    					Folder draftFolder = null;
    					
    					try {
    						draftFolder = ia.getFolder(ezEmailUtil.getDraftsFolderId(locale));
    						draftFolder.open(Folder.READ_WRITE);
    				        Message draftMessage = ((IMAPFolder)draftFolder).getMessageByUID(draftUID);
    		        		draftMessage.setFlag(Flags.Flag.DELETED, true);
    		        		draftFolder.close(true);
    		        		draftFolder = null;
    		        		
    		        		logger.debug("draftUID message deleted successfully during retry.");
    					} catch (MessagingException e) {
    						logger.error("Failed to delete draftUID message during retry. draftUID=" + draftUID);
						} catch (Exception e) {
    						logger.error("Failed to delete draftUID message during retry. draftUID=" + draftUID);
    					} finally {
    						if (draftFolder != null) {
    							try {
    								draftFolder.close(true);
    							} catch (MessagingException e) {}
								  catch (Exception e) {}
    							
    							draftFolder = null;
    						}
    					}
				    }
				    
				    // 보낸편지함에 저장된 이후 Exception이 발생하여 Retry하는 경우 보낸편지함에 있는 메시지를 삭제한다.
				    if (sentFolderMessageUID != 0) {
                        Folder sentFolder = null;
                        
                        try {
							sentFolder = ia.getFolder(ezEmailUtil.getSentFolderId(locale), apprmail);
                            sentFolder.open(Folder.READ_WRITE);
                            Message sentMessage = ((IMAPFolder)sentFolder).getMessageByUID(sentFolderMessageUID);
                            sentMessage.setFlag(Flags.Flag.DELETED, true);
                            sentFolder.close(true);
                            sentFolder = null;
                            
                            logger.debug("sentFolderMessageUID message deleted successfully during retry.");
                        } catch (MessagingException e) {
                            logger.error("Failed to delete sentFolderMessageUID message during retry. sentFolderMessageUID=" + sentFolderMessageUID);
						} catch (Exception e) {
                            logger.error("Failed to delete sentFolderMessageUID message during retry. sentFolderMessageUID=" + sentFolderMessageUID);
                        } finally {
                            if (sentFolder != null) {
                                try {
                                    sentFolder.close(true);
                                } catch (MessagingException e) {}
								  catch (Exception e) {}
                                
                                sentFolder = null;
                            }
                        }				        
				    }
					
					retryFlag = false;
					draftUID = 0;
					sentFolderMessageUID = 0;
				}

				if (ia == null){
					throw new Exception();
				}

				//편지함 용량 체크
				long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();
				double mailboxUsage = storageUsageAndLimit[0]; // in KBs
				double mailboxQuota = storageUsageAndLimit[1]; // in KBs
				logger.debug("mailboxUsage=" + mailboxUsage + ",mailboxQuota=" + mailboxQuota);

				if (mailboxUsage >= mailboxQuota) {
					throw new Exception("OVERQUOTA");
				}
				
				// MIME Message를 생성한다.
				MimeMessage message = sa.createMimeMessage();
				
				// 메일 From,TO,CC,BCC
				InternetAddress internetAddress = new InternetAddress();
				String name = "";
				String address = "";
				
				// From
				logger.debug("from=" + from);
				String pattern = "\"?([^\"]*)\"? <([^<>]+)>";
				Pattern r = Pattern.compile(pattern);
				Matcher m = r.matcher(from);
				if (m.find()) {
					name = m.group(1);
					address = m.group(2);
					internetAddress.setPersonal(name, "UTF-8");
					internetAddress.setAddress(address);
					message.setFrom(internetAddress);
				}
				
				// 외부메일 주소록 자동저장을 위한 name, address 담을 list 객체 생성 
				addressCheck = new ArrayList<Map<String, Object>>();
				
				// To
				logger.debug("to=" + to);
				m = r.matcher(to);
				while (m.find()) {
					name = m.group(1);
					address = m.group(2);
					internetAddress.setPersonal(name, "UTF-8");
					internetAddress.setAddress(address);
					message.addRecipient(RecipientType.TO, internetAddress);
					
					// 외부메일 주소록 자동저장을 위한 addressCheck list에  name, address add
					Map<String, Object> autoAddress = new HashMap<String, Object>();
					autoAddress.put("name", name);
					autoAddress.put("address", address);
					addressCheck.add(autoAddress);
				}
				
				// Cc
				logger.debug("cc=" + cc);
				m = r.matcher(cc);
				while (m.find()) {
					name = m.group(1);
					address = m.group(2);
					internetAddress.setPersonal(name, "UTF-8");
					internetAddress.setAddress(address);
					message.addRecipient(RecipientType.CC, internetAddress);
					
					Map<String, Object> autoAddress = new HashMap<String, Object>();
					autoAddress.put("name", name);
					autoAddress.put("address", address);
					addressCheck.add(autoAddress);
				}
				
				// Bcc
				logger.debug("bcc=" + bcc);
				m = r.matcher(bcc);
				while (m.find()) {
					name = m.group(1);
					address = m.group(2);
					internetAddress.setPersonal(name, "UTF-8");
					internetAddress.setAddress(address);
					message.addRecipient(RecipientType.BCC, internetAddress);
					
					Map<String, Object> autoAddress = new HashMap<String, Object>();
					autoAddress.put("name", name);
					autoAddress.put("address", address);
					addressCheck.add(autoAddress);
				}				
				
				// 메일 제목
				message.setSubject(subject, "UTF-8");
				
				logger.debug("cmd=" + cmd + ",simpleMime=" + simpleMime);
				
		        Multipart alternativePart = null;
		        
				// 메일 본문 및 타입
				MimeBodyPart content = new MimeBodyPart();
				
				// simpleMime의 값이 1인 경우는 Plain Text 형식이다.
				if (simpleMime.equals("1")) {
					textBody += addCopyrightText(userInfo, textBody, "text/plain"); // copyrightText
					
				 // 메일을 발송하는 경우
		            if (!cmd.toUpperCase().equals("SAVE")) {
		                // 예약 메일의 경우
		                if (!delaySendTime.equals("")) {
		                	message.setContent(textBody, "text/plain; charset=utf-8");
		                	content.setContent(textBody, "text/plain; charset=utf-8");
		                // 지금 발송하는 경우
		                } else {
		                	message.setContent(textBody.replaceAll("div id=\"MailSign\"", "div id=\"MailSignSent\""), "text/plain; charset=utf-8");
		                	content.setContent(textBody.replaceAll("div id=\"MailSign\"", "div id=\"MailSignSent\""), "text/plain; charset=utf-8");
		                }
		             // 임시 보관함에 저장하는 경우    
		            } else {
		            	message.setContent(textBody, "text/plain; charset=utf-8");
		            	content.setContent(textBody, "text/plain; charset=utf-8");
		            }
		        // HTML 형식의 경우
		        } else {
		        	htmlBody += addCopyrightText(userInfo, htmlBody, "text/html"); // copyrightText
					
					// HTML 안에 포함된 인라인 이미지들에 대한 다운로드 링크를 cid 형식으로 변환한다.
		        	// 이후 Related Part 처리 코드에서 변환을 하지만 Related Part 없이 HTML 파트만으로
		        	// 인라인 이미지를 포함하고 있는 메일이 있어 추가함. 이 경우 이 처리를 하지 않으면
		        	// 해당 메일을 전달하거나 회신할 때 인라인 이미지가 포함되지 않게 된다.
		        	htmlBody = convertDownloadInlineImageURLtoCid(htmlBody);							
		        	
		            // 메일을 발송하는 경우
		            if (!cmd.toUpperCase().equals("SAVE")) {
		                // 예약 메일의 경우
		                if (!delaySendTime.equals("")) {
		                	message.setContent(htmlBody, "text/html; charset=utf-8");
		                	content.setContent(htmlBody, "text/html; charset=utf-8");
		                // 지금 발송하는 경우
		                } else {
		                	message.setContent(htmlBody.replaceAll("div id=\"MailSign\"", "div id=\"MailSignSent\""), "text/html; charset=utf-8");
		                	content.setContent(htmlBody.replaceAll("div id=\"MailSign\"", "div id=\"MailSignSent\""), "text/html; charset=utf-8");
		                }
		            // 임시 보관함에 저장하는 경우
		            } else {
		            	//임시보관함에 저장할 경우에는 style 빼도록 수정
		            	htmlBody = htmlBody.replace("<style>P {MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm}</style> ", "");
		            	
		            	message.setContent(htmlBody, "text/html; charset=utf-8");
		            	content.setContent(htmlBody, "text/html; charset=utf-8");
		            }
		
		            // HTML 형식의 경우엔 multipart/alternative로 구성한다.
	                alternativePart = new MimeMultipart("alternative");
		            
	                // text/plain 파트를 구성한다.
		            MimeBodyPart textPlainPart = new MimeBodyPart();
		            textPlainPart.setText(textBody, "utf-8");	
		            
		            // text/plain 파트를 추가한다.
		            alternativePart.addBodyPart(textPlainPart);
		            // text/html 파트를 추가한다. content가 text/html 파트를 갖고 있다.
		            alternativePart.addBodyPart(content);
		            
		            message.setContent(alternativePart);
		        }
				
				// 보안메일
//				if (pSecurityMail.equals("3")) {
//					message.setHeader("Sensitivity", "company-confidential");
//		        }
				
				// 메일 중요도
				switch (importance) { // 2: High, 1: Normal, 0: Low
		            case "0": message.setHeader("X-Priority", "5");
		                break;
		            case "1": message.setHeader("X-Priority", "3");
		                break;
		            case "2": message.setHeader("X-Priority", "1");
		                break;
		            default: message.setHeader("X-Priority", "3");
		                break;
		        }
				
				// 추적(배달되면 알림)
				logger.debug("replySendTime=" + replySendTime);
		        if (replySendTime.equals("1")) {
		        	message.setHeader("Return-Receipt-To", ((InternetAddress)message.getFrom()[0]).getAddress());
		        }
		
		        // 추적(수신확인)
		        logger.debug("replyReadTime=" + replyReadTime);
		        if (replyReadTime.equals("1") || replyReadTime.equals("2")) {
		        	//message.setHeader("X-JMocha-Disp-Noti-To", ((InternetAddress)message.getFrom()[0]).getAddress());
		        	message.setHeader("X-JMocha-Disp-Noti-To", userAccount); // mdn은 사용자의 real address로 입력
		        }
		        
		        // 추적(외부 수신확인)
		        if (replyReadTime.equals("2")) {
		        	message.setHeader("X-JMocha-Ext-Receipt", "1");
					message.setHeader("X-JMocha-Ext-ServerName", https + serverNameByTenantId);
		        }
		        
		        //SentDate 설정
		        message.setSentDate(Calendar.getInstance().getTime());
		        
		        //User-Agent 설정
		        message.setHeader("User-Agent", "JMocha Mail 1.0");	        
		        
		        //inline image 처리
		        MimeMultipart relatedPart = null;
		        Set<String> contentIdSet = new HashSet<String>();
		        
		        // simpleMime의 값이 1인 아닌 경우는 HTML 형식이다.
		        if (!simpleMime.equals("1")) {
		        	// getElementsByTagName always returns non-null object even if
		        	// the tag doesn't exist, so its length must be checked.
		        	NodeList imageNameList = root.getElementsByTagName("IMAGENAME");
		        	NodeList imagePathList = root.getElementsByTagName("IMAGEPATH");
		        	
		        	// 새롭게 HTML 본문에 추가된 이미지가 있으면 이미지를 파트로 추가하고 Related Part로 구성한다.
			        if (imageNameList != null && imageNameList.getLength() > 0
			        		&& imagePathList != null && imagePathList.getLength() > 0) {
			        	String imageName = "";
			            String imagePath = "";
			        	
			            // Related Part를 생성한다.
			            relatedPart = new MimeMultipart("related");
			            
			        	for (int i = 0; true; i++) {
			            	if (imageNameList.item(i) == null || imagePathList.item(i) == null) {
			            		break;
			            	}
			            	
			            	imageName = imageNameList.item(i).getTextContent();
			            	imagePath = imagePathList.item(i).getTextContent();
			            	
			            	if (!imageName.trim().equals("") && !imagePath.trim().equals("")) {
			            	    // 이미지 파일의 Path를 구한다.
			                	imagePath = new URL(imagePath).getPath();
			                	String pDirPath = realPath + imagePath;
			                	
			        	        File f = new File(pDirPath);
			        	        
			        	        if (f.exists()) {	            		
			        	            // 본문 내용에 있는 image tag의 src 속성의 값을 content id 형식으로 변경한다.
				                	String cid = imageName + "@12345678.87654321";
				                	
				                	// content가 HTML 파트를 갖고 있다.
				                	String strContent = content.getContent().toString();
				                	int index = strContent.indexOf("src=\"" + imageName);
				                	
				                	if (index != -1) {
				                		strContent = strContent.replace("src=\"" + imageName, "src=\"cid:" + cid);
				                	}
				                	
				                	content.setContent(strContent, "text/html; charset=utf-8");
			                		        	        
				                	// 이미지 파일을 추가할 Mime Body Part를 생성한다.
				                	MimeBodyPart messageBodyPart = new MimeBodyPart();
				                	
				        	        FileDataSource source = new FileDataSource(f);
				        	        messageBodyPart.setDataHandler(new DataHandler(source));
				        	        messageBodyPart.setFileName(imageName);
				        	        
				        	        String contentType = null;
				        	        BufferedInputStream bis = null;
				        	        
				        	        try {
				        		        bis = new BufferedInputStream(new FileInputStream(f));
				        		        contentType = URLConnection.guessContentTypeFromStream(bis);
				        	        } catch(FileNotFoundException e) {
										logger.error(e.getMessage(), e);
				        	        } catch(Exception e) {
										logger.error(e.getMessage(), e);
				        	        } finally {
				        	        	if (bis != null) {
				        	        		bis.close();
				        	        	}
				        	        }
				        	        
				        	        if (contentType == null) {
			        		        	contentType = Files.probeContentType(f.toPath());
			        		        }
				        	        
				        	        
				        	        messageBodyPart.setHeader("Content-Type", contentType);
				        	        String cidWithBrackets = "<" + cid + ">";
				        	        messageBodyPart.setContentID(cidWithBrackets);
				        	        messageBodyPart.setDisposition(Part.INLINE);
				        	        
				        	        contentIdSet.add(cidWithBrackets);
				        	        logger.debug("cidWithBrackets=" + cidWithBrackets);
				        	        
				        	        // Related Part에 이미지 Part를 추가한다.
				        	        relatedPart.addBodyPart(messageBodyPart);
			        	        }
			                }
			            }
			        	
			        	// Related Part의 첫 부분에 HTML 본문 Part를 삽입한다.
			        	relatedPart.addBodyPart(content, 0);
			        	
			        	// Alternative의 두 번째 파트에 기존 HTML 파트를 제거하고 Related Part를 삽입한다.
			        	alternativePart.removeBodyPart(1);
			        	
			        	// Multipart 객체는 직접적으로 Body Part로서 다른 Multipart 객체 안에 
			        	// 들어갈 수 없기 때문에 Wrapper 역할을 하는 MimeBodyPart 객체의 콘텐트로 세트한 다음
			        	// 해당 Wrapper 객체를 alternativePart에 삽입한다.
	                    MimeBodyPart wrap = new MimeBodyPart();
	                    wrap.setContent(relatedPart);
			        	alternativePart.addBodyPart(wrap, 1);
			        	
			        	// 이 시점에 message는 alternatvie part 안에 plain 파트와 related 파트를 갖게 되고
			        	// related 파트는 html 파트와 인라인 이미지 파트들을 포함한다.
			        	message.setContent(alternativePart);
					}
		        }
		        
	            // 임시 보관함에 메시지가 있는 경우 해당 메시지와 병합 작업을 수행한다.
		        Message oldMessage = null;
		        long uid = 0;
		        
		        Folder draftFolder = ia.getFolder(ezEmailUtil.getDraftsFolderId(locale));
		        draftFolder.open(Folder.READ_WRITE);
		        
		        logger.debug("url=" + url);
		        
		        // url은 임시 보관함에 있는 메시지의 UID를 갖고 있다.
		        if (!url.trim().equals("")) {
		        	uid = Long.parseLong(url);
		        
		        	MimeMultipart mixedPart = new MimeMultipart();
					
					if (uid != 0) {
					    // 임시 보관함에 있는 기존 메시지를 불러온다.
						oldMessage = ((IMAPFolder)draftFolder).getMessageByUID(uid);
						
						if (oldMessage != null) {
							// copy existing headers that are needed.
							String[] headers = oldMessage.getHeader("References");
							
							if (headers != null) {
								message.setHeader("References", headers[0]);
							}
							
							headers = oldMessage.getHeader("In-Reply-To");
							
							if (headers != null) {
								message.setHeader("In-Reply-To", headers[0]);
							}
							
							// 임시 보관함에 있는 기존 메시지가 Multipart 메시지일 경우의 처리
							// 이 경우 각 파트들을 필요에 따라 새 메시지에 병합한다.
							if (oldMessage.getContent() instanceof Multipart) {
							    // 기존 메시지의 Multipart를 불러온다.
								Multipart mp = (Multipart)oldMessage.getContent();
								int count = mp.getCount();
								BodyPart p = null;
								boolean hasAttach = false;
								boolean hasInlineImage = false;
								boolean hasRelated = false;
								
								// Multipart의 각 Part별 처리를 수행한다.
								for (int i = 0; i < count; i++) {
									p = mp.getBodyPart(i);
									
									while (true) {
										// alternativePart가 null이 아닌 경우는 HTML 형식의 메일을 작성하는 경우이다.
										// Related Part는 HTML 형식의 메일에서만 처리할 필요가 있다.
									    // Part가 Related Part일 경우의 처리
	    								if (alternativePart != null && p.isMimeType("multipart/related")) {
	    								    logger.debug("Part is multipart/related");
	    								    
	    									hasAttach = true;
	    									hasRelated = true;
	    									
	    									logger.debug("relatedPart=" + relatedPart);
	    									
	    									// 새로 작성하는 메시지가 이미 Related Part를 갖고 있지 않은 경우에는
	    									// Related Part를 생성한다.
	    									if (relatedPart == null) {
	    										relatedPart = new MimeMultipart("related");
	    										    							
	    							        	// Multipart 객체는 직접적으로 Body Part로서 다른 Multipart 객체 안에 
	    							        	// 들어갈 수 없기 때문에 Wrapper 역할을 하는 MimeBodyPart 객체의 콘텐트로 세트한 다음
	    							        	// 해당 Wrapper 객체를 alternativePart에 삽입한다.	    										
	    					                    MimeBodyPart wrap = new MimeBodyPart();
	    					                    wrap.setContent(relatedPart);
	    					                    // HTML 파트를 갖고 있는 1번 파트를 제거하고 Related Part를 갖고 있는
	    					                    // Wrapper 객체를 대신 추가한다.
	    					                    alternativePart.removeBodyPart(1);
	    					                    alternativePart.addBodyPart(wrap, 1);
	    									}
	    									// HTML 본문에 새로 추가한 인라인 이미지가 있는 경우에는 이미 relatedPart 객체가 
	    									// 생성되어 있다.
	    									else {
	    										// 이 relatedPart 객체는 이미 alternativePart 객체 안에 삽입되어 있다.
	    										// relatedPart 객체가 포함하고 있는 HTML part를 제거한다.
	    										relatedPart.removeBodyPart(0);
	    									}
	    									
	    									// 임시 보관함에 있는 기존 메시지의 Related Part내에 있는 인라인 이미지 파트들을 병합한다.
	    									Multipart existingRelatedPart = (Multipart)p.getContent();
	    									int existingRelatedPartCount = existingRelatedPart.getCount();
	    									BodyPart existingRelatedSubPart = null;
	    									
	    									for (int j = 0; j < existingRelatedPartCount; j++) {
	    									    existingRelatedSubPart = existingRelatedPart.getBodyPart(j);
	    										
	    										if (existingRelatedSubPart instanceof MimePart) {
	    										    String contentId = ((MimePart)existingRelatedSubPart).getContentID();
	    										    logger.debug("Existing ContentId=" + contentId);
	    										    
	    										    // 이미 relatedPart 객체 안에 포함되어 있지 않은 이미지 파트이면 추가한다.
	    											if (contentId != null && !contentIdSet.contains(contentId)) {
	    											    logger.debug("Adding ContentId=" + contentId);
	    											    
	    												relatedPart.addBodyPart(existingRelatedSubPart);	
	    											// related 파트 안에 첨부 파일이 있는 경우가 있어 추가함.
	    											} else if ((existingRelatedSubPart.getDisposition() != null && existingRelatedSubPart.getDisposition().equalsIgnoreCase(Part.ATTACHMENT))
	    	    											|| existingRelatedSubPart.isMimeType("application/*")) {
	    												mixedPart.addBodyPart(existingRelatedSubPart);
	    											}
	    										}				
	    									}
	    									
	    									// content가 HTML 파트를 갖고 있다.
	    									String bodyContent = content.getContent().toString();
	    									// HTML 안에 포함된 임시 보관함 기존 메시지 내의 인라인 이미지들에 대한 다운로드 링크를 
	    									// cid 형식으로 변환한다.
	    									bodyContent = convertDownloadInlineImageURLtoCid(bodyContent);							
	    									content.setContent(bodyContent, "text/html; charset=utf-8");
	    									// relatedPart 객체의 첫 번째 파트에 해당 HTML 파트를 추가한다.
	    									relatedPart.addBodyPart(content, 0);
	    									
	    									// HTML 내에서 참조하고 있지 않은 인라인 이미지 파트들을 제거한다.
	    									removeUnusedInlineImagePart(relatedPart);
	    								}
										// alternativePart가 null이 아닌 경우는 HTML 형식의 메일을 작성하는 경우이다.
										// Alternative Part는 HTML 형식의 메일에서만 처리할 필요가 있다.	    								
	    								// Part가 Alternative Part일 경우의 처리
	    								else if (alternativePart != null && p.isMimeType("multipart/alternative")) {
	    								    logger.debug("Part is multipart/alternative");
	    								    
	    								    hasAttach = true;
	    								    
	                                        Multipart existingAlternativePart = (Multipart)p.getContent();
	                                        int existingAlternativePartCount = existingAlternativePart.getCount();
	                                        BodyPart existingAlternativeSubPart = null;
	                                        boolean isRelatedFound = false;
	                                        
	                                        // Alternative Part 안에 있는 파트들을 처리한다.
	                                        for (int j = 0; j < existingAlternativePartCount; j++) {
	                                            existingAlternativeSubPart = existingAlternativePart.getBodyPart(j);
	                                            
	                                            if (existingAlternativeSubPart instanceof MimePart) {
	                                                // Alternative Part 안에 Related Part가 있는 경우에 대한 처리
	                                                if (existingAlternativeSubPart.isMimeType("multipart/related")) {
	                                                    isRelatedFound = true;
	                                                    break;
	                                                }
	                                            }               
	                                        }						
	                                        
	                                        if (isRelatedFound) {
	                                            // p를 발견된 related 파트로 변경하여 루프의 시작 부분에 있는 related 파트 처리 부분으로 제어를 옮긴다.
	                                            p = existingAlternativeSubPart;
	                                            continue;
	                                        }
	                                    }								
	                                    // there are cases where an in-line image part doesn't have
	                                    // a Content-Disposition header, but has a Content-ID header.
	    								// 첨부파일 파트나 본문 파트에도 Content-ID가 있을 수 있어서 if문에 들어가지 않도록 조건을 추가함
	    								else if (p instanceof MimePart 
	    								        && ((MimePart)p).getContentID() != null
	    								        && !(p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT))
	    								        && !p.isMimeType("text/*")) {
	    								    String contentId = ((MimePart)p).getContentID();
	    								    logger.debug("Existing ContentId=" + contentId);
	    								    
	    								    if (!contentIdSet.contains(contentId)) {
	    								        logger.debug("Adding ContentId=" + contentId);
	    								        
	    								        hasInlineImage = true;
	    								        mixedPart.addBodyPart(p);
	    								    }
	    								}
	    								// Content-Disposition 헤더가 없이 첨부된 파일이 있어
	    								// Content-Type이 application으로 시작하는 경우도 추가함 
	    								// 예) Content-Type: application/octet-stream;
	    								//         name="=?utf-8?B?NDExMDAwODE1OS5QREY=?="
	    							    //    Content-Transfer-Encoding: base64	    								
	    								else if (p.getDisposition() != null || p.isMimeType("application/*")) { 
	    									MimeBodyPart newBodyPart = (MimeBodyPart)p;
	    									
	    									// 료비에서 수신한 메일 중에 text/plain 파트만 있으면서
	    									// ContentID 없이 Content-Dispostion이 inline으로 첨부된
	    									// 이미지가 있어 이 경우 첨부파일로서 처리하기 위해 추가함.(iPhone Mail에서 작성한 메일임.)
	    									boolean isInlinePartWithoutContentID = false;

    										if (newBodyPart.getDisposition() != null 
    												&& newBodyPart.getDisposition().equalsIgnoreCase(Part.INLINE)
    												&& newBodyPart.getContentID() == null) {
    											isInlinePartWithoutContentID = true;
    										}
	    									
	    									// 첨부파일 파트인 경우
	    									if ((p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT))
	    											|| p.isMimeType("application/*")
	    											|| isInlinePartWithoutContentID) {
	    										hasAttach = true;
	    											    										
	    										InternetHeaders newHeaders = new InternetHeaders();
	    										
	    										@SuppressWarnings("unchecked")
												Enumeration<Header> enumerator = p.getAllHeaders();
	    										
	    										// 해당 파트의 헤더들을 읽는다.
	    										while (enumerator.hasMoreElements()) {
	    											Header h = (Header)enumerator.nextElement();
	    											
	    											String hValue = h.getValue();
	    											
	    											// long header line의 경우 작성 시에는 folding이 되어 있으나
	    											// 파트를 복사하는 과정에서 CRLF가 사라지는 현상이 있어
	    											// 이곳에서 다시 CRLF를 삽입하도록 함
	    											hValue = hValue.replace("attachment; filename=", "attachment;\r\n filename=");
	    											hValue = hValue.replace("?= =?", "?=\r\n =?");
	    											
	    											newHeaders.addHeader(h.getName(), hValue);
	    										}
	    										
	    										// 해당 파트의 body 데이터를 읽는다.
	    										byte[] bytes = IOUtils.toByteArray(newBodyPart.getRawInputStream());
	    											    										
	    										// 해당 파트의 헤더와 body 데이터를 동일하게 갖는 파트 객체를 생성한다.
	    										newBodyPart = new MimeBodyPart(newHeaders, bytes);	 
	    									}
	    									
	    									mixedPart.addBodyPart(newBodyPart);	    									
	    								}
	    								// Part가 message 인 경우, 즉 메일이 첨부된 경우
	    								else if (p.isMimeType("message/*")) {
	    								    logger.debug("Part is message");
	    								    
	    									mixedPart.addBodyPart(p);
	    									hasAttach = true;
	    								}							
	    								
	    								break;
									}
								}
								
								// multipart/related 안에 첨부파일이 들어 있는 메일이 코린도에서 수신되어
								// 해당 메일이 인라인 이미지도 포함한 경우의 처리를 위해 추가함.
								// 이 경우엔 전체 메시지를 multipart/related로 구성하고
								// 그 안에 인라인 이미지와 첨부 파일이 들어 있는 형태로 메시지를 구성한다.
								if (oldMessage.isMimeType("multipart/related")) {
									logger.debug("hasAttach=" + hasAttach + ",hasRelated=" + hasRelated
													+ ",hasInlineImage=" + hasInlineImage);
									
									// related 파트가 없는 경우 multipart/mixed로 생성하게 되면 인라인 이미지 표시가
									// 되지 않는 문제가 발생한다. hasAttach 변수를 false로 설정하여 이후 처리 과정에서 multipart/mixed가
									// 아닌 multipart/related로 메시지 생성이 되도록 한다.
									if (hasAttach && !hasRelated && hasInlineImage) {
										hasAttach = false;
									}
								}
								
								// 기존 메시지에 첨부파일이 있거나 Alternative Part 혹은 Related Part가 있는 경우의 처리
								if (hasAttach) {
									if (alternativePart != null) {
										MimeBodyPart wrap = new MimeBodyPart();
										wrap.setContent(alternativePart);
										mixedPart.addBodyPart(wrap, 0);
									} else {
										mixedPart.addBodyPart(content, 0);
									}							
									
									message.setContent(mixedPart);							
								}
								// 기존 메시지가 Related Part일 경우의 처리
								else if (oldMessage.isMimeType("multipart/related")) {
								    logger.debug("oldMessage is multipart/related");
									logger.debug("relatedPart=" + relatedPart);
									
	                                if (alternativePart != null) {								
	    								// 새로 추가되는 이미지 파트들을 추가한다.
	    								// 기존 메시지의 이미지 파트들은 위에서 이미 mixedPart에 추가되어 있다.
	    								// a new related part is already created by the above routine
	    								// for adding new in-line images.						
	    								if (relatedPart != null) {
	    									relatedPart.removeBodyPart(0);
	    									
	    									BodyPart relatedSubPart = null;
	    									for (int i = 0; i < relatedPart.getCount(); i++) {
	    										relatedSubPart = relatedPart.getBodyPart(i);
	    										mixedPart.addBodyPart(relatedSubPart);
	    									}
	    								}
	    								
	    								// 기존 메시지가 Related Part인 경우는 첨부파일이 없는 경우이므로 mixed가 아니다.
	    								// this mixedPart is actually a related part.
	    								mixedPart.setSubType("related");
	    								
	    								String bodyContent = content.getContent().toString();																
	                                    bodyContent = convertDownloadInlineImageURLtoCid(bodyContent);                          
	                                    content.setContent(bodyContent, "text/html; charset=utf-8");                            
	                                    mixedPart.addBodyPart(content, 0);
	                                    
	                                    removeUnusedInlineImagePart(mixedPart);
	                                                                        
	                                    MimeBodyPart wrap = new MimeBodyPart();
	                                    wrap.setContent(mixedPart);
	                                    alternativePart.removeBodyPart(1);
	                                    alternativePart.addBodyPart(wrap, 1);                                                                               
	                                } 
								}
							}					
						}
					}
		        }        
		        
		        //mailboxUsage + messageSize >= mailboxQuota인 경우 OVERQUOTA Exception
		        CountOutputStream cos = null;
		        double messageSize = 0;
		        
		        try {
		        	cos = new CountOutputStream();
		        	message.writeTo(cos);
		        	messageSize = cos.getSize() / 1000.0;
		        } catch(IOException e) {
		        	logger.error(e.getMessage(), e);
				} catch(Exception e) {
		        	logger.error(e.getMessage(), e);
		        } finally {
		        	try { cos.close();}
					catch (IOException e) {}
					catch (Exception e) {}
		        }
		        
		        logger.debug("mailboxUsage=" + mailboxUsage + ", messageSize=" + messageSize + ", mailboxQuota=" + mailboxQuota);
		        
		        if (mailboxUsage + messageSize >= mailboxQuota) {
					throw new Exception("OVERQUOTA");
				}
		        
		        //messageSize가 maxMessageSize 넘을 경우 OVERMESSAGESIZE Exception
		        int maxMessageSize = ezEmailService.getMaxMessageSize(userInfo.getTenantId());
		        
		        if (maxMessageSize > 0 && messageSize > maxMessageSize) {
		        	double maxMessageSizeD = maxMessageSize / 1024.0;
		        	maxMessageSizeD = Math.round(maxMessageSizeD * 10) / 10;
		        	
		        	double messageSizeD = messageSize / 1024.0;
		        	messageSizeD = Math.round(messageSizeD * 10) / 10;
		        	
		        	throw new Exception("OVERMESSAGESIZE:" + maxMessageSizeD + "MB:" + messageSizeD + "MB");
		        }
		        
		        String useSecureMail = ezCommonService.getTenantConfig("USE_SECUREMAIL", userInfo.getTenantId());
		        logger.debug("useSecureMail=" + useSecureMail);
		        
		        if (cmd.equalsIgnoreCase("SAVE")) {
		        	logger.debug("Saving the message");
		        	
		    		Boolean isEachMailB = Boolean.parseBoolean(isEachMail.trim());
		    		
		    		if (isEachMailB) {
	                	message.setHeader("X-JMocha-Each-Mail", "true");
                    }
		    		if (!delaySendTime.equals("")){
		    			message.setHeader("Delivery-Date", delaySendTime);
		    		}
		    		if (useSecureMail.equals("YES") && isSecureMail) {
		    			message.setHeader("X-JMocha-Secure-Mail", "true");
		    		}
		    		
		    		message.setFlag(Flags.Flag.SEEN, true);
		    		AppendUID[] uids = ((IMAPFolder)draftFolder).appendUIDMessages(new Message[]{message});
		    		if (uids != null && uids[0] != null) {
		    			draftUID = uids[0].uid;
		    		} 
		    	
		            // this deletion code block has been moved here because
		            // it needs to be kept in Drafts if an error occurs during the above process.
		    		// modeFlag=='preview'는 메일작성 미리보기로 이전에 저장된 메일을 삭제하면 안된다(미리보기용으로 저장된 메일이 아닌 임시저장용 메일)
					boolean isPreview = "preview".equalsIgnoreCase(modeFlag) || "previewSend".equalsIgnoreCase(modeFlag);

		            if (oldMessage != null && !isPreview) {
		            	oldMessage.setFlag(Flags.Flag.DELETED, true);
		            }
		            
		        } else if (cmd.equalsIgnoreCase("SEND")) {
		        	logger.debug("Sending the message");
		    		
		    		int receiverCount = message.getAllRecipients().length;
		    		
		    		if (Integer.parseInt(mailMaxReceiverCount) < receiverCount) {
		    			logger.debug("Receiver count is over. max=" + mailMaxReceiverCount + ",receiverCount=" + receiverCount);
		    			throw new Exception("RECEIVERCOUNTOVER");
		    		}
		        	
//					String strCheckReadUrl = ""; //외부메일수신확인 관련 URL. GetSystemConfigValue("APPREADCHECK_URL").ToString();
			        Boolean isEachMailB = Boolean.parseBoolean(isEachMail.trim());
			        
			        if (!eShowDisplayName.equals("")) {
		            	message.setHeader("X-JMocha-EXT-SENDERNAME", MimeUtility.encodeText(eShowDisplayName, "UTF-8", null));
		            }
			                            
                    message.setFlag(Flags.Flag.SEEN, true);
		            
                    // 예약 발송의 경우
			        if (!delaySendTime.equals("")) {
			            // 편지함 용량 초과 메세지 확인을 위해 임시저장
	                    AppendUID[] uids = ((IMAPFolder)draftFolder).appendUIDMessages(new Message[]{message});
	                    if (uids != null && uids[0] != null) {
	                        draftUID = uids[0].uid;
	                    } 
			            
	                    // 개별발신
	                    if (isEachMailB) {
		                	message.setHeader("X-JMocha-Each-Mail", "true");
	                    }
	                    
			        	// 예약발송
			        	String delaySendTimeUTC = commonUtil.getDateStringInUTC(delaySendTime, userInfo.getOffset(), true);
			            
			        	// 보안메일 처리
		            	if (useSecureMail.equals("YES") && isSecureMail) {
	    		        	message.setHeader("X-JMocha-Secure-Mail", "true");
	    		        	message.setHeader("X-JMocha-Secure-Mail-Password", securePassword);
	    		        	message.setHeader("X-JMocha-Secure-Mail-ReadCount", secureReadCount);
	    		        	message.setHeader("X-JMocha-Secure-Mail-ReadDate", secureReadDate);
							message.setHeader("X-JMocha-Secure-Mail-PasswordHint", securePasswordHint);
	    		        	
	    		        	// set serverName
	    		    		String serverName = userInfo.getServerName();
	    		    		String useMailLinkHostname = ezCommonService.getTenantConfig("useMailLinkHostname", userInfo.getTenantId());
	    		    		
	    		    		if (useMailLinkHostname.equals("YES")) {
	    		    			String mailLinkHostname = ezCommonService.getTenantConfig("mailLinkHostname", userInfo.getTenantId());
	    		    			
	    		    			if (!mailLinkHostname.equals("")) {
	    		    				serverName = mailLinkHostname;
	    		    			}
	    		    		}
	    		        	
	    		        	message.setHeader("X-JMocha-Secure-Mail-ServerName", serverName);
		            	}
			        	
			        	doDelaySend(userInfo.getTenantId(), message, isReserve, reservedId, subject, delaySendTimeUTC, mailId, userId, realPath);
			        	
			            //임시보관함에서 삭제
			            Message draftMessage = ((IMAPFolder)draftFolder).getMessageByUID(draftUID);
		        		draftMessage.setFlag(Flags.Flag.DELETED, true);
		        		
                        // this deletion code block has been moved here because
                        // it needs to be kept in Drafts if an error occurs during the above process.
                        if (oldMessage != null) {
                            oldMessage.setFlag(Flags.Flag.DELETED, true);
                        }		        		
		        	// 즉시 발송의 경우	
			        } else {
			        	
			        	String[] eachMailHeaders = message.getHeader("X-JMocha-Each-Mail");
						String eachMailHeader = eachMailHeaders != null ? eachMailHeaders[0] : null;		
						
						if (eachMailHeader != null) {
							message.removeHeader("X-JMocha-Each-Mail");
						}
						
						File encryptedFile = null; // 보안메일 관련 파일 변수

		            	String sentMailStoredInSentBox = config.getProperty("config.SentMailStoredInSentbox", "YES");
			        	
			            // mailSendCompleted가 true인 경우는 메일 전송까지 완료된 이후에 Exception이 발생하여 Retry하는 경우이다.
			            // 이 경우에는 이미 보낸편지함에 저장된 메일이 있으므로 보낸편지함에 다시 저장하지 않는다.
			            if (mailSendCompleted == false) {
							Folder sentFolder = ia.getFolder(ezEmailUtil.getSentFolderId(locale), apprmail); // 승인메일인 경우 승인메일 공유사서함의 편지함으로 저장될 수 있게 처리
			            	
			            	// 보안메일 처리
			            	if (useSecureMail.equals("YES") && isSecureMail) {

								// 개별발신 헤더추가
								if (isEachMailB) {
									message.setHeader("X-JMocha-Each-Mail", "true");
								}
								
								// 승인메일일 경우
								if (apprmail) {

									message.setHeader("X-JMocha-Secure-Mail", "true");
									message.setHeader("X-JMocha-Secure-Mail-Password", securePassword);
									message.setHeader("X-JMocha-Secure-Mail-ReadCount", secureReadCount);
									message.setHeader("X-JMocha-Secure-Mail-ReadDate", secureReadDate);
									message.setHeader("X-JMocha-Secure-Mail-PasswordHint", securePasswordHint);

									// set serverName
									String serverName = userInfo.getServerName();
									String useMailLinkHostname = ezCommonService.getTenantConfig("useMailLinkHostname", userInfo.getTenantId());

									if (useMailLinkHostname.equals("YES")) {
										String mailLinkHostname = ezCommonService.getTenantConfig("mailLinkHostname", userInfo.getTenantId());

										if (!mailLinkHostname.equals("")) {
											serverName = mailLinkHostname;
										}
									}

									message.setHeader("X-JMocha-Secure-Mail-ServerName", serverName);

									AppendUID[] uids = ((IMAPFolder)sentFolder).appendUIDMessages(new Message[]{message});
									if (uids != null && uids[0] != null) {
										sentFolderMessageUID = uids[0].uid;
									}
								} else {
									if (!secureReadDate.equals("")) {
										Date date = new Date(Long.parseLong(secureReadDate));
										SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
										secureReadDate = sdf.format(date);
										secureReadDate = commonUtil.getDateStringInUTC(secureReadDate, userInfo.getOffset(), true);
									}

									// client단에서 암호화되어 넘겨진 securePassword 복호화
									String prm = egovFileScrty.getPrm();
									String pre = egovFileScrty.getPre();
									PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
									securePassword = EgovFileScrty.decryptRsa(pk, securePassword);

									// securePassword 암호화
									// securePassword 암호화
									boolean useKlibEncrypt = "YES".equalsIgnoreCase(config.getProperty("config.useKlibEncrypt"));
									logger.debug("useKlibEncrypt : {}",useKlibEncrypt );
									securePassword = ezEmailService.encryptSecureValue(securePassword, useKlibEncrypt);

									// save secure mail info and get secureId
									secureId = ezEmailService.setMailSecure(userInfo.getTenantId(), mailId, securePassword, Integer.parseInt(secureReadCount), secureReadDate);

									if (secureId == 0) {
										throw new Exception("INSERTSECUREMAILFAIL");
									}

									MimeMessage secureMessage = sa.createMimeMessage();

									@SuppressWarnings("unchecked")
									Enumeration<Header> headerEnum = message.getAllHeaders();

									while (headerEnum.hasMoreElements()) {
										Header header = headerEnum.nextElement();
										secureMessage.setHeader(header.getName(), header.getValue());
									}

									MimeMultipart secureMixedPart = new MimeMultipart();

									// make secureBodyPart and add to secureMixedPart
									MimeBodyPart secureBodyPart = new MimeBodyPart();
									MimeMultipart secureBodyRelatedPart = new MimeMultipart("related");
									MimeBodyPart secureBodyHtmlPart = new MimeBodyPart();
									MimeBodyPart secureBodyImagePart = new MimeBodyPart();

									String tempFileName = UUID.randomUUID().toString();

									secureBodyHtmlPart.setContent(ezEmailUtil.getSecureBodyHtml(tempFileName, locale), "text/html; charset=utf-8");

									secureBodyImagePart.setHeader("Content-Disposition", "inline;\r\n\tfilename=\"" + tempFileName + ".gif\"");
									secureBodyImagePart.setHeader("Content-ID", "<" + tempFileName + ".gif@12345678.87654321>");
									secureBodyImagePart.setHeader("Content-Type", "image/gif");
									FileDataSource source = new FileDataSource(new File(realPath + "/images/email/secureMail/security_img.gif"));
									secureBodyImagePart.setDataHandler(new DataHandler(source));

									secureBodyRelatedPart.addBodyPart(secureBodyHtmlPart);
									secureBodyRelatedPart.addBodyPart(secureBodyImagePart);

									secureBodyPart.setContent(secureBodyRelatedPart);
									secureMixedPart.addBodyPart(secureBodyPart);
									// make secureBodyPart and add to secureMixedPart - end

									// make secureAttachPart and add to secureMixedPart
									MimeBodyPart secureAttachPart = new MimeBodyPart();
									secureAttachPart.setHeader("Content-Disposition", "attachment;\r\n\tfilename=\"secureMail.html\"");
									secureAttachPart.setHeader("Content-Type", "text/html");

									String useHttps = ezCommonService.getTenantConfig("USE_HTTPS", userInfo.getTenantId());

									String serverName = userInfo.getServerName();
									String useMailLinkHostname = ezCommonService.getTenantConfig("useMailLinkHostname", userInfo.getTenantId());

									if (useMailLinkHostname.equals("YES")) {
										String mailLinkHostname = ezCommonService.getTenantConfig("mailLinkHostname", userInfo.getTenantId());

										if (!mailLinkHostname.equals("")) {
											serverName = mailLinkHostname;
										}
									}

									logger.debug("useHttps=" + useHttps + ",serverName=" + serverName);

									String secureAttachHtml = ezEmailUtil.getSecureAttachHtml(serverName, locale, useHttps);

									String secureMailKey = userAccount + "/" + secureId + "/" + userAccount;
									secureMailKey = ezEmailService.encryptSecureValue(secureMailKey, useKlibEncrypt);
									secureAttachHtml = secureAttachHtml.replace("${X-JMocha-Secure-Mail-Key}", secureMailKey);
									secureAttachHtml = secureAttachHtml.replace("${passwordHint}", securePasswordHint);

									secureAttachPart.setContent(secureAttachHtml, "text/html; charset=utf-8");
									secureAttachPart.setHeader("Content-Disposition", "attachment;\r\n\tfilename=\"secureMail.html\"");
									secureMixedPart.addBodyPart(secureAttachPart);
									// make secureAttachPart and add to secureMixedPart - end

									// make encryptedOriginalPart and add to secureMixedPart
									MimeBodyPart encryptedOriginalPart = new MimeBodyPart();

									String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId()) + commonUtil.separator + "tempFileUpload";
									File file = new File(pDirPath);
									if (!file.exists()) {
										file.mkdirs();
									}

									File originalFile = new File(pDirPath + commonUtil.separator + UUID.randomUUID().toString());
									FileOutputStream fos = null;

									try {
										fos = new FileOutputStream(originalFile);
										message.writeTo(fos);
									} catch (Exception e) {
										logger.error(e.getMessage(), e);
									} finally {
										if (fos != null) {
											try {
												fos.close();
											} catch (IOException e) {
											}
										}
									}

									encryptedFile = new File(pDirPath + commonUtil.separator + UUID.randomUUID().toString());
									
                                    if (!useKlibEncrypt) {
                                        egovFileScrty.cryptFile(Cipher.ENCRYPT_MODE, originalFile, encryptedFile);
                                    } else {
                                        byte[] bytes = commonUtil.readBytesFromFile(originalFile.toPath());
                                        commonUtil.writeBytesToFile(encryptedFile.toPath(),klibUtil.encrypt(bytes));
                                    }

									// 보안메일 관련 임시파일 삭제
									if (originalFile.delete()) {
										logger.debug("originalFile is deleted. fileName=" + originalFile.getName());
									}

									encryptedOriginalPart.setHeader("Content-Disposition", "attachment;\r\n\tfilename=\"originalMail.eml\"");
									encryptedOriginalPart.setHeader("Content-Type", "message/rfc822");
									source = new FileDataSource(encryptedFile);
									encryptedOriginalPart.setDataHandler(new DataHandler(source));
									secureMixedPart.addBodyPart(encryptedOriginalPart);
									// make encryptedOriginalPart and add to secureMixedPart - end

									secureMessage.setContent(secureMixedPart);

									ezEmailUtil.setSecureMailFlag(secureMessage, true);
									secureMessage.setFlag(Flags.Flag.SEEN, true);

									// mailetcontainer.xml에서 JMochaSecureMail 사용시 X-JMocha-Secure-Mail-ID 사라짐 -> 보안메일 필터링 SECURE_FLAG를 추가하기 위해 헤더 속성 필요.
									secureMessage.setHeader("X-JMocha-Secure-Mail", "true");

									// 편지함 용량 초과 메세지 확인을 위해 임시저장
									// 본래는 임시보관함에 미리 저장해두고 성공했을 시 임시보관함에 있는 메일을 보낸메일함으로 복사하였으나
									// 보낸메일함에 바로 저장하는 것으로 변경함.
									AppendUID[] uids = ((IMAPFolder) sentFolder).appendUIDMessages(new Message[]{secureMessage});
									if (uids != null && uids[0] != null) {
										sentFolderMessageUID = uids[0].uid;
									}

									// 보낸편지함에 저장한 메일의 uid를 저장한다.
									String result = ezEmailService.updateMailSecure(userInfo.getTenantId(), mailId, secureId, sentFolder.getFullName() + "/" + sentFolderMessageUID);

									if (!result.equals("OK")) {
										throw new Exception("UPDATESECUREMAILFAIL");
									}

									// 메일을 발송할 때에는 보낸사람의 secureMailKey를 다시 ${X-JMocha-Secure-Mail-Key}로 되돌려놓는다.
									secureMixedPart.removeBodyPart(secureAttachPart);
									secureAttachPart.setContent(secureAttachHtml, "text/html; charset=utf-8");
									secureMixedPart.addBodyPart(secureAttachPart);

									// 메일을 발송할 때에는 원본메일을 삭제한다.
									secureMixedPart.removeBodyPart(encryptedOriginalPart);

									// 서버에서 보안메일을 처리할 수 있도록 헤더를 추가한다.
									secureMessage.setHeader("X-JMocha-Secure-Mail-ID", String.valueOf(secureId));

									message = secureMessage;
								}
			            	} else {
			            		if (sentMailStoredInSentBox.equalsIgnoreCase("YES")) {
									// 개별발신 헤더추가
									if (isEachMailB) {
										message.setHeader("X-JMocha-Each-Mail", "true");
									}

				            		// 편지함 용량 초과 메세지 확인을 위해 임시저장
		    	                    // 본래는 임시보관함에 미리 저장해두고 성공했을 시 임시보관함에 있는 메일을 보낸메일함으로 복사하였으나
		    			            // 보낸메일함에 바로 저장하는 것으로 변경함.
		    	                    AppendUID[] uids = ((IMAPFolder)sentFolder).appendUIDMessages(new Message[]{message});
		    	                    if (uids != null && uids[0] != null) {
		    	                        sentFolderMessageUID = uids[0].uid;
		    	                    }
			            		}
			            	}
			            }
			            
			            // 개별발신
			            if (isEachMailB && !apprmail) {
			            	logger.debug("sending each recipient mail");
			            	
			                // mailSendCompleted가 true인 경우는 Transport.send가 완료된 이후에 예외가 발생하여 Retry하는 경우이다.
			                // 이 경우에는 메일을 다시 전송하지 않는다.
			                if (mailSendCompleted == false) {				                	
		                		Address[] allRecipients = message.getAllRecipients();
				            	
				            	message.removeHeader("TO");
				        		message.removeHeader("CC");
				        		message.removeHeader("BCC");
				        		
								String useAdvancedEachMail = ezCommonService.getTenantConfig("useAdvancedEachMail", userInfo.getTenantId());
								
								if (useAdvancedEachMail.equals("YES")) {				        		
					        		message.setRecipients(RecipientType.TO, allRecipients);
					        		
					        		message.setHeader("X-JMocha-Each-Mail", "true");
				            		
					        		Transport.send(message);
				            		
	    			            	sentFolderMessageUID = 0;
	    			            	mailSendCompleted = true;				
								} else {
					            	for (Address a : allRecipients) {
					            		logger.debug("address=" + a);
					            		
					            		try {
						            		message.setRecipient(RecipientType.TO, a);

											if (!apprmail) {
												Transport.send(message);
											}
					            		} catch (MessagingException e) {
					            			logger.error(e.getMessage(), e);
										} catch (Exception e) {
					            			logger.error(e.getMessage(), e);
					            		}
					            		
		    			            	sentFolderMessageUID = 0;
		    			            	mailSendCompleted = true;				            		
					            	}									
								}
			                }
			            	
			                // this deletion code block has been moved here because
			                // it needs to be kept in Drafts if an error occurs during the above process.
			                if (oldMessage != null) {
			                	oldMessage.setFlag(Flags.Flag.DELETED, true);
			                }
			            } else {
			                // mailSendCompleted가 true인 경우는 Transport.send가 완료된 이후에 예외가 발생하여 Retry하는 경우이다.
			                // 이 경우에는 메일을 다시 전송하지 않는다.
			                if (mailSendCompleted == false) {
								if (!apprmail) {
									Transport.send(message);
								} else {
									// 승인메일 로그 저장
									try {
										if ("ALL_HANDS".equalsIgnoreCase(apprmailType)) {
											ezEmailService.applyApprCompMail(loginCookie, sentFolderMessageUID, message, shareId);
										} else {
											ezEmailService.applyApprMail(loginCookie, sentFolderMessageUID, message, apprmailApprover, shareId);
										}
									} catch (Exception e) {
										String eMsg = e.getMessage();
										logger.error(eMsg, e);
										// APPR_ERROR_ALLHANDS_NOT_EXIST:회사관리자가 없는 경우, APPR_ERROR_NORMAL_NOT_EXIST:승인자가 없는 경우
										if (!eMsg.contains("APPR_ERROR")) {eMsg = "APPR_ERROR"; }

										throw new Exception(eMsg + "_" + sentFolderMessageUID);
									}
								}

								sentFolderMessageUID = 0;
								mailSendCompleted = true;
			                }
			            				                	            				        		
                            // this deletion code block has been moved here because
                            // it needs to be kept in Drafts if an error occurs during the above process.
                            if (oldMessage != null) {
                                oldMessage.setFlag(Flags.Flag.DELETED, true);
                            }			        		
			            }
			            			            
			            //예악발송 수정창에서 예약발송 옵션 해제하고 저장했을 경우 메일이 바로 발송되므로 DB 데이터 삭제, 파일 시스템의 eml파일 삭제
			            logger.debug("reservedId=" + reservedId);
			            if (reservedId != null && !reservedId.trim().equals("")) {
							ezEmailService.deleteMailReserved(reservedId);
			            	
							String pDirPath = commonUtil.getUploadPath("upload_mail.RESERVED_MAIL_PATH", userInfo.getTenantId());
				    		pDirPath = realPath + pDirPath;
				            File f = new File(pDirPath + commonUtil.separator + reservedId + ".eml");
							if (f.exists()) {
								f.delete();
							}
			            }
			            
			            logger.debug("mailCmd=" + mailCmd + ",orgUrl=" + orgUrl);
			            
			            // set the ANSWERED flag of the original message to indicate it has been replied.
			            if (orgMailCmd.equals("REPLY") || orgMailCmd.equals("REPLYALL") || orgMailCmd.equals("FORWARD")) {
			    			int index = orgUrl.lastIndexOf("/");			
			    			
			    			if (index != -1) {
			    				String orgMsgFolderPath = orgUrl.substring(0, index);
			    				long orgMsgUid = Long.parseLong(orgUrl.substring(index + 1));
		
			    				logger.debug("orgMsgFolderPath=" + orgMsgFolderPath + ",orgMsgUid=" + orgMsgUid);
			    				
			    		        Folder orgMsgFolder = ia.getFolder(orgMsgFolderPath);
			    		        orgMsgFolder.open(Folder.READ_WRITE);
			    				
			    		        Message orgMessage = ((IMAPFolder)orgMsgFolder).getMessageByUID(orgMsgUid);
		    		        	
			    		        if (orgMessage != null) {
			    		        	if (orgMailCmd.equals("REPLY") || orgMailCmd.equals("REPLYALL")) {
				    		        	orgMessage.setFlag(Flags.Flag.ANSWERED, true);
				    		        	ezEmailUtil.setForwardedFlag(orgMessage, false);
				    		        	
				    		        }
				    		        else {
				    		        	ezEmailUtil.setForwardedFlag(orgMessage, true);
				    		        	orgMessage.setFlag(Flags.Flag.ANSWERED, false);
				    		        }
			    		        	ezEmailUtil.setSentDateFlag(orgMessage, true);
			    		        }
			    		        
			    		        orgMsgFolder.close(true);
			    			}
			            }
			            
			            // 보안메일 관련 임시파일 삭제
				        if (encryptedFile != null) {
				        	if (encryptedFile.delete()) {
				        		logger.debug("encryptedFile is deleted. fileName=" + encryptedFile.getName());
				        	}
				        }
			        }
			        
			        // file system의 templist txt파일 삭제
			        String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId()) + commonUtil.separator + "templist";
			        pDirPath += commonUtil.separator + stateName + ".txt";
			        File f = new File(pDirPath);
			        if (f.exists()) {
			        	f.delete();
			        }
			        
		        }
		        
		        // file system의 inline image 파일 삭제 - 경로가 upload_common인 파일만 삭제
		        // 발송의 경우에만 삭제하고 저장의 경우에는 쓰기 창이 계속 표시되어 있는 상태이므로 삭제하지 않고 유지한다.
		        // 남아있는 이미지 파일들은 스케쥴러에 의해 삭제되어야 함.
		        if (cmd.equalsIgnoreCase("SEND")) {
	    	        NodeList imagePathList = root.getElementsByTagName("IMAGEPATH");
	    	        if (imagePathList != null && imagePathList.getLength() > 0) {
	    	            String imagePath = "";
	    	            
	    	        	for (int i=0; true; i++) {
	    	            	if (imagePathList.item(i) == null) {
	    	            		break;
	    	            	}
	    	            	
	    	            	imagePath = imagePathList.item(i).getTextContent();
	    	            	
	    	            	if (!imagePath.trim().equals("") && imagePath.contains(commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId()))) {
	    	                	imagePath = new URL(imagePath).getPath();
	    	                	String pDirPath = realPath + imagePath;
	    	            		File f = new File(pDirPath);
	    	            		if (f.exists()) {
	    	            			f.delete();
	    	            		}
	    	            	}
	    	        	}
	    	        }
		        }
		        
		        draftFolder.close(true);
		        
		        pResult = "<RESULT>OK</RESULT>";
		        pResult += "<MESSAGEID><![CDATA[" + draftUID + "]]></MESSAGEID>";
		        if (cmd.equalsIgnoreCase("SAVE")
						&& (modeFlag.equalsIgnoreCase("preview") || modeFlag.equalsIgnoreCase("previewSend"))) {
		        	pResult += "<MESSAGEID><![CDATA[" + ezEmailUtil.getDraftsFolderId(locale) + "]]></MESSAGEID>";
		        }

				if (!cmd.equalsIgnoreCase("SAVE")) {
					// 2024-11-13 김은실 : 최근 사용 주소 테이블에(jmocha_address_last_sent) insert.
					try {
						ezAddressService.insertLastSentEmailAddresses(addressCheck, userInfo.getTenantId(), StringUtils.defaultIfBlank(shareId, userId));
					} catch (NullPointerException e) {
						logger.debug("insertLastSentEmailAddresses insert fail.");
						logger.error(e.getMessage(), e);
					} catch (Exception e) {
						logger.debug("insertLastSentEmailAddresses insert fail.");
						logger.error(e.getMessage(), e);
					}

					// useAutoSaveMailAddress가 YES일 경우, 외부수신자의 메일주소를 개인주소록에 자동 저장 (코린도)
					String autoSaveAddress = ezCommonService.getTenantConfig("useAutoSaveMailAddress", userInfo.getTenantId());

					if (autoSaveAddress.equals("YES")) {
						try {
							ezEmailUtil.outerMailInsertAddress(addressCheck, userId, userInfo.getTenantId(), 
									userAccount, userInfo.getDisplayName(), userInfo.getDisplayName1());
						} catch (NullPointerException e) {
							logger.debug("AutoEmailAddress insert fail.");
							logger.error(e.getMessage(), e);
						} catch (Exception e) {
							logger.debug("AutoEmailAddress insert fail.");
							logger.error(e.getMessage(), e);
						}
					}
				}
	        
			} catch (RuntimeException e) {
				
				if (e.getMessage().indexOf("OVERQUOTA") > -1 || e.getMessage().indexOf("OVERMESSAGESIZE") > -1) {
					logger.error("mailInterSend : " + e.getMessage());
					pResult = e.getMessage();
				} else if (e.getMessage().indexOf("Invalid Addresses") > -1) {
					pResult = e.getMessage();
					String cause = e.getCause().toString();
					
					String pattern = "Unknown user: ([\\S]+)";
					Pattern r = Pattern.compile(pattern);
					Matcher m = r.matcher(cause);
					pResult = "Invalid Addresses:";
					
					int index = 1000;
					while (m.find()) {
						// 1000번 이상 반복되면 break한다.
						--index;
						if (index < 0) {
							logger.error("Stop finding invalid addresses, because over 1000 times.");
							break;
						}
						
						pResult += m.group(1) + "|";
					}
					
					pResult = pResult.substring(0, pResult.length() - 1);
				} else if (e.getMessage().indexOf("RECEIVERCOUNTOVER") > -1) {
					pResult = egovMessageSource.getMessage("ezEmail.receiverCount01", locale) + mailMaxReceiverCount + egovMessageSource.getMessage("ezEmail.receiverCount02", locale);
				}  else if(e.getMessage().indexOf("APPR_LOG_ERROR") > -1) {
					// 승인메일 로그 저장 시에 오류 발생 시, 공유사서함에 저장된 메일 삭제하기 위해서 추가
					String[] emsg = e.getMessage().split("_");
					mailSendCompleted = false;
					sentFolderMessageUID = Long.parseLong(emsg[emsg.length-1]);
					pResult = "APPR_ERROR";
				} else { // retry
					logger.error(e.getMessage(), e);
					
					retryFlag = true;
					--retryCount;
					
					if (retryCount > -1) {
						logger.debug("Message send fail. Retry...");
						
						try {Thread.sleep(1000);}
						catch (IllegalArgumentException ex) {logger.error(ex.getMessage(), ex);}
						catch (Exception ex) {logger.error(ex.getMessage(), ex);}
					} else {
						//더이상 retry를 하지 않으므로 리턴 메시지를 세팅한다.
						pResult = e.getMessage();
					}
				}
			} catch (Exception e){
				if (e.getMessage().indexOf("OVERQUOTA") > -1 || e.getMessage().indexOf("OVERMESSAGESIZE") > -1) {
					logger.error("mailInterSend : " + e.getMessage());
					pResult = e.getMessage();
				} else if (e.getMessage().indexOf("Invalid Addresses") > -1) {
					pResult = e.getMessage();
					String cause = e.getCause().toString();

					String pattern = "Unknown user: ([\\S]+)";
					Pattern r = Pattern.compile(pattern);
					Matcher m = r.matcher(cause);
					pResult = "Invalid Addresses:";

					int index = 1000;
					while (m.find()) {
						// 1000번 이상 반복되면 break한다.
						--index;
						if (index < 0) {
							logger.error("Stop finding invalid addresses, because over 1000 times.");
							break;
						}

						pResult += m.group(1) + "|";
					}

					pResult = pResult.substring(0, pResult.length() - 1);
				} else if (e.getMessage().indexOf("RECEIVERCOUNTOVER") > -1) {
					pResult = egovMessageSource.getMessage("ezEmail.receiverCount01", locale) + mailMaxReceiverCount + egovMessageSource.getMessage("ezEmail.receiverCount02", locale);
				} else { // retry
					logger.error(e.getMessage(), e);

					retryFlag = true;
					--retryCount;

					if (retryCount > -1) {
						logger.debug("Message send fail. Retry...");

						try {Thread.sleep(1000);}
						catch (IllegalArgumentException ex) {logger.error(ex.getMessage(), ex);}
						catch (Exception ex) {logger.error(ex.getMessage(), ex);}
					} else {
						//더이상 retry를 하지 않으므로 리턴 메시지를 세팅한다.
						pResult = e.getMessage();
					}
				}
			} finally {
				if (ia != null) {
					ia.close();
					ia = null;
				}
			}
			
		} while (retryFlag && retryCount > -1);
		
		// 즉시 발송의 경우
		if (cmd.equalsIgnoreCase("SEND") && delaySendTime.equals("")) {
		    // 보낸편지함에 메일이 저장되었지만 메일 전송이 성공하지 못했다면 해당 메일을 삭제한다.
		    if (mailSendCompleted == false && sentFolderMessageUID != 0) {
                Folder sentFolder = null;
                        
                try {
                    Thread.sleep(1000);

					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userAccount, password, egovMessageSource, locale, ezEmailUtil, apprSharedMailBox);

					sentFolder = ia.getFolder(ezEmailUtil.getSentFolderId(locale), apprmail);
                    sentFolder.open(Folder.READ_WRITE);
                    Message sentMessage = ((IMAPFolder)sentFolder).getMessageByUID(sentFolderMessageUID);
                    sentMessage.setFlag(Flags.Flag.DELETED, true);
                    sentFolder.close(true);
                    sentFolder = null;
                    
                    logger.debug("sentFolderMessageUID message deleted successfully.");
                } catch (MessagingException e) {
                    logger.error("Failed to delete sentFolderMessageUID message. sentFolderMessageUID=" + sentFolderMessageUID);
				} catch (Exception e) {
                    logger.error("Failed to delete sentFolderMessageUID message. sentFolderMessageUID=" + sentFolderMessageUID);
                } finally {
                    if (sentFolder != null) {
                        try {
                            sentFolder.close(true);
                        } catch (MessagingException e) {
							logger.error(e.getMessage(), e);
						} catch (Exception e) {
							logger.error(e.getMessage(), e);
						}
                        
                        sentFolder = null;
                    }
                    
                    if (ia != null) {
                        ia.close();
                        ia = null;
                    }                    
                }                                           
		    }
		}
		
		logger.debug("mailInterSend ended. pResult=" + pResult);
		return "<DATA>" + pResult + "</DATA>";
	}
	
	/**
	 * 임시저장메일 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/delDrafts.do", produces = "text/html", method = RequestMethod.GET)
	@ResponseBody
	public String delDrafts(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			HttpServletRequest request) throws Exception {
		logger.debug("delDrafts started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		String uidStr = request.getParameter("itemid");
		logger.debug("uidStr=" + uidStr);
		
		long uid = 0;
		if (uidStr != null && !uidStr.equals("")) {
			uid = Long.parseLong(uidStr);
		}
		
        LoginVO loginInfo = commonUtil.userInfo(loginCookie);
        
		if (uid != 0) {
    		String domainName = ezCommonService.getTenantConfig("domainName", loginInfo.getTenantId());
    		String userEmail = loginInfo.getId() + "@" + domainName;
    		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());

    		if (useSharedMailbox.equals("YES")) {
    			String shareId = request.getParameter("shareId");
        		logger.debug("shareId=" + shareId);
        		
        		if (shareId != null) {
        			if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, loginInfo.getTenantId())) {
        				logger.debug("the user cannot access the shareId.");
        				logger.debug("delDrafts ended.");
        				
        				return "";
        			}
        			
        			userEmail = shareId + "@" + domainName;
        		}
    		}
    		
    		logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);
    		
    		IMAPAccess ia = null;
    		try {
    			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
    					userEmail, password, egovMessageSource, locale, ezEmailUtil);
    			if (ia != null){
                    Folder folder = ia.getFolder(ezEmailUtil.getDraftsFolderId(locale));
					if (folder != null){
						folder.open(Folder.READ_WRITE);
						Message message = ((IMAPFolder)folder).getMessageByUID(uid);
						logger.debug("message=" + message);

						if (message != null) {
							message.setFlag(Flags.Flag.DELETED, true);
						}
						folder.close(true);
					}
                }
    	        
    		} catch (MessagingException e) {
    			logger.error(e.getMessage(), e);
    		} finally {
    			if (ia != null) {
    				ia.close();
    			}
    		}
		}
		
		//첨부파일 정보파일(templist) 삭제
		String delId = request.getParameter("delid");
		if (delId != null && !delId.equals("")) {
			delId = commonUtil.detectPathTraversal(delId);
	        String realPath = commonUtil.getRealPath(request);
	        String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", loginInfo.getTenantId()) + commonUtil.separator + "templist";
	        pDirPath += commonUtil.separator + delId + ".txt";
	        File f = new File(pDirPath);
	        if (f.exists()) {
	        	f.delete();
	        }
		}
        logger.debug("delDrafts ended.");
        
		return "";
	}
	
	/**
	 * 첨부파일 정보파일(templist) 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/delAttachListFile.do", produces = "text/html", method = RequestMethod.GET)
	@ResponseBody
	public String delAttachListFile(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			HttpServletRequest request) throws Exception {
		logger.debug("delAttachListFile started.");
		
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String delId = request.getParameter("delid");
		delId = commonUtil.detectPathTraversal(delId);
        String realPath = commonUtil.getRealPath(request);
        String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId()) + commonUtil.separator + "templist";
        pDirPath += commonUtil.separator + delId + ".txt";
        
        File f = new File(pDirPath);
        
        if (f.exists()) {
        	f.delete();
        }
        
        logger.debug("delAttachListFile ended.");
        
		return "";
	}
	
	/**
	 * 첨부파일 정보(templist) 반환 함수
	 */
	@RequestMapping(value="/ezEmail/fileListSession.do", produces = "text/xml; charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public String fileListSession(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			HttpServletRequest request) throws Exception {
		logger.debug("fileListSession started.");
		
		String fileData = request.getParameter("filedata") == null ? "" : request.getParameter("filedata");
		fileData = commonUtil.detectPathTraversal(fileData);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		pDirPath = realPath + pDirPath;
		String xmlPath = pDirPath + commonUtil.separator + "templist" + commonUtil.separator + fileData + ".txt";
    	
		String returnValue = "";
		File f = new File(xmlPath);
        if (f.exists()) {
			InputStreamReader isr = null;
	    	BufferedReader br = null;
	    	try {
	        	isr = new InputStreamReader(new FileInputStream(f));
	        	br = new BufferedReader(isr);
	        	int read = 0;
				while ((read = br.read()) != -1) {
					returnValue += (char)read;
				}
	    	} catch(IOException e) {
	    		throw e;
			} catch(Exception e) {
	    		throw e;
	    	} finally {
	    		if (br != null) {
	    			br.close();
	    		}
	    		if (isr != null) {
	    			isr.close();
	    		}
	    	}
        }
		
        logger.debug("fileListSession ended.");
        
		return returnValue;
	}
	
	/**
	 * 일반 첨부파일 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailDelInterAttach.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailDelInterAttach(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			HttpServletRequest request) throws Exception {
		logger.debug("mailDelInterAttach started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		String returnValue = "<DATA><![CDATA[";
		
		Document xmlDoc = commonUtil.convertRequestToDocument(request);
		if (xmlDoc != null){
			Element root = xmlDoc.getDocumentElement();

			long uid = 0;
			if (root.getElementsByTagName("ITEMID") != null) {
				String uidStr = root.getElementsByTagName("ITEMID").item(0).getTextContent();
				if (uidStr != null && !uidStr.trim().equals("")) {
					uid = Long.parseLong(uidStr);
				}
			}

			LoginVO loginInfo = commonUtil.userInfo(loginCookie);
			String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
			String userEmail = loginInfo.getId() + "@" + domainName;
			String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());

			if (useSharedMailbox.equals("YES")) {
				String shareId = request.getParameter("shareId");
				logger.debug("shareId=" + shareId);

				if (shareId != null) {
					if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, loginInfo.getTenantId())) {
						logger.debug("the user cannot access the shareId.");
						logger.debug("mailDelInterAttach ended.");

						return "";
					}

					userEmail = shareId + "@" + domainName;
				}
			}

			logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);

			if (uid != 0) {
				NodeList rows = root.getElementsByTagName("ROW");

				if (rows != null && rows.item(0) != null) {
					SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
							userEmail, password);

					IMAPAccess ia = null;
					try {
						ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
								userEmail, password, egovMessageSource, locale, ezEmailUtil);

						if (ia != null){
							Folder folder = ia.getFolder(ezEmailUtil.getDraftsFolderId(locale));
							if (folder != null){
								folder.open(Folder.READ_WRITE);
								Message oldMessage = ((IMAPFolder)folder).getMessageByUID(uid);

								if (oldMessage != null) {
									MimeMessage newMessage = sa.createMimeMessage();
									Multipart multipart = new MimeMultipart();

									Multipart mp = (Multipart)oldMessage.getContent();
									int count = mp.getCount();
									BodyPart p = null;
									int nonAttachCount = 0;

									// 첨부파일 파트 이전에 존재하는 파트들의 갯수를 구한다.
									// 이 로직이 제대로 동작하려면 첨부파일들이 모두 메시지의 뒷부분에 연속으로 위치하여야 한다.
									for (int i = 0; i < count; i++) {
										p = mp.getBodyPart(i);

										if (p.getDisposition() == null) {
											nonAttachCount++;
										} else {
											break;
										}
									}

									for (int i = 0; i < count; i++) {
										p = mp.getBodyPart(i);

										int length = rows.getLength();
										boolean isRemoved = false;

										// 파일의 index가 nonAttachCount 만큼 뒤로 밀렸으므로 i - nonAttachCount과 비교하여 파일을 삭제한다.
										if (p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)) {
											for (int j = 0; j < length; j++) {
//										String mailFileName = MimeUtility.decodeText(p.getFileName());
//										logger.debug("mailFileName : " + mailFileName + ", index i : " + (i-1));
//										logger.debug("rows.item(j).getFirstChild().getTextContent() : " + rows.item(j).getFirstChild().getTextContent());
//										logger.debug("rows.item(j).getChildNodes().item(1) : " + rows.item(j).getChildNodes().item(1).getTextContent());
												if (rows.item(j).getChildNodes().item(1).getTextContent().equals((i - nonAttachCount) + "")) {
													isRemoved = true;
													break;
												}
											}
										}

										if (!isRemoved) {
											multipart.addBodyPart(p);
										}
									}

									@SuppressWarnings("unchecked")
									Enumeration<Header> e = oldMessage.getAllHeaders();
									while(e.hasMoreElements()){
										Header header = e.nextElement();
										newMessage.setHeader(header.getName(), header.getValue());
									}
									//

									if (multipart.getCount() != 0) {
										newMessage.setContent(multipart);
										newMessage.setFlag(Flags.Flag.SEEN, true);
										AppendUID[] uids = ((IMAPFolder)folder).appendUIDMessages(new Message[]{newMessage});
										returnValue += uids[0].uid;
									}

									oldMessage.setFlag(Flags.Flag.DELETED, true);

								}
								folder.close(true);
							}
						}

					} catch (MessagingException e) {
						logger.error(e.getMessage(), e);
					} finally {
						if (ia != null) {
							ia.close();
						}
					}
				}
			}
		}
		
		returnValue += "]]></DATA>";
		
		logger.debug("mailDelInterAttach ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 대용량 첨부파일 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/fileListDelete.do", produces = "text/plain; charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public String fileListDelete(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			HttpServletRequest request) throws Exception{
		logger.debug("fileListDelete started.");
		
		String fileData = request.getParameter("filedata") != null ? request.getParameter("filedata") : "";
		String realFileNM = request.getParameter("realFileNM") != null ? request.getParameter("realFileNM") : "";
		
		fileData = commonUtil.detectPathTraversal(fileData);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String realPath = commonUtil.getRealPath(request);
		String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		String xmlPath = pDirPath + commonUtil.separator + "templist" + commonUtil.separator + fileData + ".txt";
		
		// 2018-10-08 분리된 대용량파일(largeFile) 폴더 사용 여부
		String largeFilePath = pDirPath;
		String useSeparatedLargeFileFolder = ezCommonService.getTenantConfig("useSeparatedLargeFileFolder", userInfo.getTenantId());

		if (useSeparatedLargeFileFolder.equals("YES")) {
			largeFilePath += commonUtil.separator + "largeFile";
		}
		
		File templistFile = new File(xmlPath);
		if (templistFile.exists()) {
			String strXml = "";
			InputStreamReader isr = null;
			try {
				isr = new InputStreamReader(new FileInputStream(xmlPath));
			    int read = 0;
				while ((read = isr.read()) != -1) {
					strXml += (char)read;
				}
			} finally {
				if (isr != null) {
					isr.close();
				}
			}
			
			Document xmlDom = commonUtil.convertStringToDocument(strXml);
			NodeList nodeList = xmlDom.getElementsByTagName("NODE");
			
			if (nodeList != null) {
				for (int i=0; i<nodeList.getLength(); i++) {
					if (nodeList.item(i).getFirstChild().getTextContent().equals(realFileNM)) {
						String fileLocation = nodeList.item(i).getChildNodes().item(4).getTextContent();
						String[] fileLocationArray = fileLocation.split("\\|!\\|");
						String pRealFilePath = largeFilePath + commonUtil.separator + fileLocationArray[0] + commonUtil.separator + fileLocationArray[1];
						pRealFilePath = commonUtil.detectPathTraversal(pRealFilePath);
						
						File bigAttachFile = new File(pRealFilePath);
						
						if (bigAttachFile.exists()) {
							bigAttachFile.delete();
							File bigAttachNameFile = new File(pRealFilePath+"__.txt");
							bigAttachNameFile.delete();
						}

						nodeList.item(i).getParentNode().removeChild(nodeList.item(i));

						String useExternalLargeFileServer = ezCommonService.getTenantConfig("useExternalLargeFileServer", userInfo.getTenantId());

						if ("Y".equalsIgnoreCase(useExternalLargeFileServer)){
							logger.debug("useExternalLargeFileServer Y.");
							HttpHeaders headers = new HttpHeaders();
							headers.setContentType(MediaType.MULTIPART_FORM_DATA);

							MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
							body.add("filePath", pRealFilePath);

							HttpEntity<MultiValueMap<String, Object>> entity = new HttpEntity<>(body, headers);

							//String uploadServerURL = ezCommonService.getTenantConfig("externalLargeFileServerURL", userInfo.getTenantId());
							String externalFileServerUrl = ezCommonService.getTenantConfig("externalFileServerUrl", userInfo.getTenantId());
							logger.debug("externalFileServerUrl = " + externalFileServerUrl);
							RestTemplate restTemplate = new RestTemplate();
							restTemplate.exchange(externalFileServerUrl + "/rest/ezEmail/deleteAttachCommon.do", HttpMethod.POST, entity, String.class);

						}

					}
				}
			}
			
			String strXml2 = commonUtil.convertDocumentToString(xmlDom);
			logger.debug("strXml : "+strXml);
			logger.debug("strXml2 : "+strXml2);
			
			OutputStreamWriter osw = null;
			try {
				osw = new OutputStreamWriter(new FileOutputStream(xmlPath), "UTF-8");
				osw.write(strXml2);
			} finally {
				if (osw != null) {
					osw.close();
				}
			}
		}
		
		logger.debug("fileListDelete ended.");
		
		return "";
	}
	
	/**
	 * 사원 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailNameCheck.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailNameCheck(
			@CookieValue("loginCookie") String loginCookie, 
			Model model, 
			HttpServletRequest request) throws Exception{
		logger.debug("mailNameCheck started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String pOrganSearchList = "";
		String pOrganCellList = "displayname";
		String pOrganPropList = "company;description;title;mail;extensionAttribute3";
		String pOrganListType = "all";
		String pDLSearchList = "";
		/* String pDLCellList = "displayname";
		String pDLPropList = "mail";
		String pDLListType = "group"; */
		String pAddressFilter = "";
		String pSharedMailboxSearchList = "";
		
		Document xmlDoc = commonUtil.convertRequestToDocument(request);
		if (xmlDoc != null){
			Element root = xmlDoc.getDocumentElement();

			Node tempNode = null;
			if (root.getElementsByTagName("ORGSEARCH") != null) {
				tempNode = root.getElementsByTagName("ORGSEARCH").item(0);
				if (tempNode != null && !tempNode.getTextContent().equals("")) {
					pOrganSearchList = tempNode.getTextContent();
				}
			}
			if (root.getElementsByTagName("DLGSEARCH") != null) {
				tempNode = root.getElementsByTagName("DLGSEARCH").item(0);
				if (tempNode != null && !tempNode.getTextContent().equals("")) {
					pDLSearchList = tempNode.getTextContent();
				}
			}
			if (root.getElementsByTagName("SHAREDMAILBOXSEARCH") != null) {
				tempNode = root.getElementsByTagName("SHAREDMAILBOXSEARCH").item(0);
				if (tempNode != null && !tempNode.getTextContent().equals("")) {
					pSharedMailboxSearchList = tempNode.getTextContent();
				}
			}
		/* if (root.getElementsByTagName("CELL") != null) {
			tempNode = root.getElementsByTagName("CELL").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pOrganCellList = tempNode.getTextContent();
				pDLCellList = tempNode.getTextContent();
			}
		} */
			if (root.getElementsByTagName("ORGPROP") != null) {
				tempNode = root.getElementsByTagName("ORGPROP").item(0);
				if (tempNode != null && !tempNode.getTextContent().equals("")) {
					pOrganPropList = tempNode.getTextContent();
				}
			}
		/* if (root.getElementsByTagName("DLPROP") != null) {
			tempNode = root.getElementsByTagName("DLPROP").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pDLPropList = tempNode.getTextContent();
			}
		} */
			if (root.getElementsByTagName("ORGTYPE") != null) {
				tempNode = root.getElementsByTagName("ORGTYPE").item(0);
				if (tempNode != null && !tempNode.getTextContent().equals("")) {
					pOrganListType = tempNode.getTextContent();
				}
			}
		/* if (root.getElementsByTagName("DLTYPE") != null) {
			tempNode = root.getElementsByTagName("DLTYPE").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pDLListType = tempNode.getTextContent();
			}
		} */
			if (root.getElementsByTagName("ADDFILTER") != null) {
				tempNode = root.getElementsByTagName("ADDFILTER").item(0);
				if (tempNode != null && !tempNode.getTextContent().equals("")) {
					pAddressFilter = tempNode.getTextContent();
				}
			}
		}

        String useShowAllCompanies = ezCommonService.getTenantConfig("useShowAllCompanies", userInfo.getTenantId());
        
        // useShowAllCompanies가 YES이고 company 패러메터가 전달된 경우에는
        // Company ID를 ""로 세트하여 그룹사 전체 조직도를 대상으로 검색하도록 한다.
        String orgCompanyId = userInfo.getCompanyID();
        
        if (useShowAllCompanies.equals("YES")) {
			String companyId  = request.getParameter("company");
			
			if (companyId != null) {
				userInfo.setCompanyID("");
			}
        }        
		
        String organXML = getOrganSearch(pOrganSearchList, pOrganCellList, pOrganPropList, pOrganListType, userInfo);	
        String dlXML = getOrganDLSearch(pDLSearchList, userInfo);
        
        if (useShowAllCompanies.equals("YES")) {
        	// Company ID를 본래값으로 복원한다.
        	userInfo.setCompanyID(orgCompanyId);
        }
        
        String addressXML = getAddressSearch(pAddressFilter, userInfo);
        String sharedMailboxXML = getSharedMailboxSearch(pSharedMailboxSearchList, userInfo);
        
        // 20190619 조진호 - 메일 주소 검색 대상 순서 변경 추가
     	String mailAddressSearchOrder =  ezCommonService.getUserConfigInfo(userInfo.getTenantId(), userInfo.getId(), "mailAddressSearchOrder");
        
        logger.debug("mailNameCheck ended.");
        return String.format("<RESULT><ORGAN>%s</ORGAN><DL>%s</DL><ADDRESS>%s</ADDRESS><SHAREDMAILBOX>%s</SHAREDMAILBOX><MAILADDRESSSEARCHORDER><LISTVIEWDATA><ROWS><ROW><CELL><VALUE>%s</VALUE></CELL></ROW></ROWS></LISTVIEWDATA></MAILADDRESSSEARCHORDER></RESULT>", organXML, dlXML, addressXML, sharedMailboxXML, mailAddressSearchOrder);
	}
	
	/**
	 * 사원 이름으로 메일 찾기 화면 호출 함수 
	 */
	@RequestMapping(value="/ezEmail/mailCheckName.do", method = RequestMethod.GET)
	public String mailCheckName(
			@CookieValue("loginCookie") String loginCookie, 
			Model model, 
			HttpServletRequest request) throws Exception{
		
		return "ezEmail/mailCheckName";
	}
	
	/**
	 * 편지쓰기 창에서 입력받은 메일이 존재하는지 검색. 
	 * 메일쓰기 창에서 받는사람 도메인 확인 메소드
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezEmail/mailCheck.do", method = RequestMethod.GET)
	@ResponseBody
	public List<String> mailCheck(@CookieValue("loginCookie") String loginCookie, Locale locale, 
			Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailCheck started.");
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String email = request.getParameter("name");
		List<String> resultList = new ArrayList<String>();

		String inputParams = "address=" + URLEncoder.encode(email, "UTF-8");
		
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getAliasMail";
		String strJson = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (object.get("resultCode").equals("OK")) {
        	JSONArray array = (JSONArray)object.get("result");
        	
        	if (array != null) { 
        		int len = array.size();
        		for (int i=0; i<len; i++){ 
        			resultList.add((String)array.get(i));
        		} 
        	} 
        }
		
        int usercnt = ezOrganAdminService.userCountCheck(email, loginVO.getTenantId());
        
        if (usercnt >= 0) {
        	object.put("usercnt", usercnt);
        }
        
        
        logger.debug("usercnt="  + usercnt);
		logger.debug("mailCheck ended.");
		
		return resultList;
	}
	
	/**
	 * 메일 옵션화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/letterOption.do", method = RequestMethod.GET)
	public String mailLetterOption(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception{
		logger.debug("mailLetterOption started.");
		
		//TODO: 변수들 setting
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		
		String individualMailUser = ezCommonService.getTenantConfig("INDIVIDUALMAILUSER", tenantId);
		String useSecureMail = ezCommonService.getTenantConfig("USE_SECUREMAIL", tenantId);
		String useOnlyInnerMail = ezCommonService.getTenantConfig("UseOnlyInnerMail", tenantId);
		String offsetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
		String useReceiptExternal = ezCommonService.getTenantConfig("useReceiptExternal", tenantId);
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailLetterOption ended.");
					
					return "ezCommon/error";
					
				} else {
					model.addAttribute("shareId", shareId);
				}
			}
		}
		
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("individualMailUser", individualMailUser);
		model.addAttribute("useSecureMail", useSecureMail);
		model.addAttribute("useOnlyInnerMail", useOnlyInnerMail);
		model.addAttribute("useReceiptExternal", useReceiptExternal);

		logger.debug("mailLetterOption ended.");
		return "ezEmail/mailLetterOption";
	}
	
	/**
	 * 보안메일 설정화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailSecureOption.do", method = RequestMethod.GET)
	public String mailSecureOption(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model) throws Exception{
		logger.debug("mailSecureOption started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String offsetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
		
		// client단에 publicKey 뿌림
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		
		logger.debug("mailSecureOption ended.");
		return "ezEmail/mailSecureOption";
	}

	/**
	 * 메일쓰기 - 조직도(받는사람,참조,숨은참조) 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailNewReceiverChoose.do", method = RequestMethod.GET)
	public String mailNewReceiverChoose(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception{
		logger.debug("mailNewReceiverChoose started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String defaultWin = request.getParameter("defaultwin") == null ? "To" : request.getParameter("defaultwin").trim();
		String type = request.getParameter("type") == null ? "" : request.getParameter("type").trim();
		String ruleKind = request.getParameter("ruleKind") == null ? "" : request.getParameter("ruleKind").trim();
		String useOcs = config.getProperty("config.USE_OCS") == null ? "" : config.getProperty("config.USE_OCS");
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		String mailMaxReceiverCount = ezCommonService.getTenantConfig("mailMaxReceiverCount", userInfo.getTenantId());
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		String useUserDefinedDL = ezCommonService.getTenantConfig("useUserDefinedDL", userInfo.getTenantId()); // 사용자 정의 DL
		String useOrgListCheckBox = ezCommonService.getTenantConfig("useOrgListCheckBox", userInfo.getTenantId()); // 조직도 체크박스 사용여부
		useOrgListCheckBox = (useOrgListCheckBox != null && useOrgListCheckBox.equalsIgnoreCase("YES")) ? "true" : "false";
		
		if (mailMaxReceiverCount.equals("")) {
			mailMaxReceiverCount = "200";
		}
		
		model.addAttribute("defaultWin", defaultWin);
		model.addAttribute("type", type);
		model.addAttribute("ruleKind", ruleKind);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useSharedMailbox", useSharedMailbox);
		model.addAttribute("mailMaxReceiverCount", mailMaxReceiverCount);
		model.addAttribute("primaryLang", primaryLang);
		model.addAttribute("useUserDefinedDL", useUserDefinedDL);
		model.addAttribute("useOrgListCheckBox", useOrgListCheckBox);
		
		String useShowAllCompanies = ezCommonService.getTenantConfig("useShowAllCompanies", userInfo.getTenantId());
		model.addAttribute("useShowAllCompanies", useShowAllCompanies);
		
		logger.debug("mailNewReceiverChoose ended.");
		return "ezEmail/mailNewReceiverChoose";
	}
	
	/**
	 * 메일쓰기 - 공용배포그룹(받는사람,참조,숨은참조) 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetDistribution.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailGetDistribution(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception{
		logger.debug("mailGetDistribution started.");
		
		String returnData = "";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
	        String useShowAllCompanies = ezCommonService.getTenantConfig("useShowAllCompanies", userInfo.getTenantId());
			
	        // useShowAllCompanies가 YES이고 company 패러메터가 전달된 경우에는
	        // Company ID를 ""로 세트하여 그룹사 전체를 대상으로 검색하도록 한다.
	        if (useShowAllCompanies.equals("YES")) {
				String companyId  = request.getParameter("company");
				
				if (companyId != null) {
					userInfo.setCompanyID("");
				}
	        }
			
			List<MailDistributionVO> distributionList = ezEmailService.getDistributionList(userInfo.getCompanyID(), userInfo.getTenantId());
			
			StringBuilder sb = new StringBuilder();
			sb.append("<LISTVIEWDATA><ROWS>");

			for (MailDistributionVO vo : distributionList) {
				sb.append("<ROW><CELL>");
				
				sb.append("<VALUE>");
				sb.append(commonUtil.cleanValue(vo.getName()));
				sb.append("</VALUE>");
				
				sb.append("<DATA1>");
				sb.append(commonUtil.cleanValue(vo.getId()));
				sb.append("</DATA1>");
				
				sb.append("<DATA2>");
				sb.append(commonUtil.cleanValue(vo.getMail()));
				sb.append("</DATA2>");
				
				sb.append("</CELL></ROW>");
			}
			
			sb.append("</ROWS></LISTVIEWDATA>");
			
			returnData = sb.toString();
			
		} catch (RuntimeException e) {
			returnData = "ERROR";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnData = "ERROR";
			logger.error(e.getMessage(), e);
		}

		logger.debug("mailGetDistribution ended.");
		return returnData;
	}
	
	/**
	 * 메일쓰기 - 공용배포그룹 구성원 보기 및 선택 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailSelectDLMember.do", method = RequestMethod.GET)
	public String mailSelectDLMember(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception{
		logger.debug("mailSelectDLMember started.");
		
	    LoginVO userInfo = commonUtil.userInfo(loginCookie);
	    
		String isUser = "";
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		
		String cn = request.getParameter("cn");
		String domain = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String companyName = userInfo.getCompanyName();
		String name = request.getParameter("name");
		String mailAddress = request.getParameter("mailAddress");
		String newMailFlag = request.getParameter("newMailFlag");
		
		/* 사용자 정의 공용배포그룹 컨피그가 활성화 되어있을때 공용배포그룹의 구성원 보기는 공개정책에 의해서 공개 허용 여부가 정해짐
		 * 공개 허용 : policy가 all일 경우, policy가 멤버이면서 구성원일 경우, 관리자 페이지에서 생성된 공용배포그룹일 경우
		 */
		String useUserDefinedDL = ezCommonService.getTenantConfig("useUserDefinedDL", userInfo.getTenantId());
		if (useUserDefinedDL.equalsIgnoreCase("YES")) {
			MailDistributionVO userDlVo = ezEmailService.getUserDistributionInfo(cn, userInfo.getTenantId());
			if (userDlVo != null) { // null이면 관리자에서 생성된 dl
				String dlOwnerId = userDlVo.getOwnerId();
				if (!dlOwnerId.equals(userInfo.getId())) {
					String dlPolicy = userDlVo.getDisclosurePolicy();
					logger.debug("userDistribution policy=" + dlPolicy);
					
					if (dlPolicy.equals("member")) {
						int chk = ezEmailService.checkUserDistributionInCludedMember(domain, cn, userInfo.getId());
						logger.debug("chk=" + chk);
						
						dlPolicy = chk == 0 ? "all" : dlPolicy;
					}
					
					if (!dlPolicy.equals("all")) {
						model.addAttribute("list", null);
						model.addAttribute("dlPolicy", dlPolicy);
						logger.debug("== mailSelectDLMember ended.");
						return "ezEmail/mailSelectDLMember";
					}
				}
			}
		}
		
		try {
			String inputParams = "cn=" + URLEncoder.encode(cn, "UTF-8")
							   + "&domain=" + URLEncoder.encode(domain, "UTF-8");
			
			logger.debug("inputParams=" + inputParams);
			
			String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getDistribution";
			String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
			
			logger.debug("response=" + response);
			
			JSONArray resultArray = null;
			
			if (response != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject)jsonParser.parse(response);

				String resultCode = (String)responseObj.get("resultCode");
				
				if (resultCode.equalsIgnoreCase("OK")) {
					resultArray = (JSONArray)responseObj.get("result");
				}
			}
			
			if (resultArray != null) {
				for (int i=0; i<resultArray.size(); i++) {
					JSONObject address = (JSONObject)resultArray.get(i);
					String pCn = (String)address.get("cn");
					String pCnDomain = pCn.substring(pCn.indexOf("@") + 1, pCn.length());
					isUser = (String)address.get("class");
					String displayName = (String) address.get("displayName");
					
					if (domain.equals(pCnDomain)) {
						pCn = pCn.substring(0, pCn.indexOf("@"));
					} else {
						isUser = "distributionSub";
					}

					logger.debug("pCn=" + pCn + ", isUser=" + isUser + ", displayName=" + displayName);
					
					if(isUser.equals("group")) {
						OrganDeptVO dept = ezOrganService.getDeptInfo(pCn, userInfo.getPrimary(), userInfo.getTenantId());

						Map<String, String> map = new HashMap<String, String>();
						
						if (dept != null) { // 부서
							map.put("displayName", dept.getDisplayName());
							map.put("mail", dept.getMail());
							map.put("company", dept.getExtensionAttribute3());
							map.put("dept", dept.getDisplayName());
							map.put("title", "");
						} else { // 공용배포그룹
							String email = (String)address.get("cn");
							String companyDomainName = ezCommonService.getCompanyConfig(userInfo.getTenantId(), userInfo.getCompanyID(), "DomainName");
							
							// 회사별 이메일 도메인명이 설정되어 있으면 해당 도메인명을 기반으로 한 이메일 주소로 전달한다.								
							if (!companyDomainName.isEmpty()) {
								String emailId = null;
								
								int atSignIndex = email.indexOf("@");
								
								if (atSignIndex != -1) {
									emailId = email.substring(0, atSignIndex);
									email = emailId + "@" + companyDomainName;			        			
								}							
							}
							
							map.put("displayName", displayName); // 배포그룹 이름
							map.put("mail", email);  // 메일
							map.put("company", companyName); // 배포그룹 이름
							map.put("dept", egovMessageSource.getMessage("ezEmail.t57",
									locale));  //배포그룹이름
							map.put("title", ""); // ""
						}
						list.add(map);
					} else if (isUser.equals("user")) {
						OrganUserVO user = ezOrganAdminService.getUserInfo(pCn, userInfo.getPrimary(), userInfo.getTenantId());
						
						if (user != null) {
							Map<String, String> map = new HashMap<String, String>();
							map.put("displayName", user.getDisplayName());
							map.put("mail", user.getMail());
							map.put("company", user.getCompany());
							map.put("dept", user.getDescription());
							map.put("title", user.getTitle());
							
							list.add(map);
						}
						
					} else {
						MailDistributionVO distributionSubVO = ezEmailService
							.getDistributionSub(cn, pCn, userInfo.getCompanyID(), userInfo.getTenantId());
						
						if (distributionSubVO != null) {
							Map<String, String> map = new HashMap<String, String>();
							map.put("displayName", distributionSubVO.getName());
							map.put("mail", distributionSubVO.getMail());
							map.put("company", "");
							map.put("dept", "");
							map.put("title", "");
							
							list.add(map);
						}
					}				
				}
			}			
		} catch (IOException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		model.addAttribute("name", name);
		model.addAttribute("mailAddress", mailAddress);
		model.addAttribute("newMailFlag", newMailFlag);
		model.addAttribute("list", list);
		
		logger.debug("mailSelectDLMember ended.");
		return "ezEmail/mailSelectDLMember";
	}
	
	/**
	 * 공유사서함 리스트 호출 함수 (수신자 설정)
	 */
	@RequestMapping(value="/ezEmail/getSharedMailboxList.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getSharedMailboxList(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception{
		logger.debug("getSharedMailboxList started.");
		
		String returnData = "";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			List<MailSharedMailboxVO> sharedMailboxList = ezEmailService.getSharedMailboxList(userInfo.getCompanyID(), userInfo.getTenantId());
			
			StringBuilder sb = new StringBuilder();
			sb.append("<LISTVIEWDATA><ROWS>");

			for (MailSharedMailboxVO vo : sharedMailboxList) {
				sb.append("<ROW><CELL>");
				
				sb.append("<VALUE>");
				sb.append(commonUtil.cleanValue(vo.getShareName()));
				sb.append("</VALUE>");
				
				sb.append("<DATA1>");
				sb.append(commonUtil.cleanValue(vo.getShareId()));
				sb.append("</DATA1>");
				
				sb.append("<DATA2>");
				sb.append(commonUtil.cleanValue(vo.getShareMail()));
				sb.append("</DATA2>");
				
				sb.append("</CELL></ROW>");
			}
			
			sb.append("</ROWS></LISTVIEWDATA>");
			
			returnData = sb.toString();
			
		} catch (RuntimeException e) {
			returnData = "ERROR";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnData = "ERROR";
			logger.error(e.getMessage(), e);
		}

		logger.debug("getSharedMailboxList ended.");
		return returnData;
	}
	
	/**
	 * 공유사서함 공유자 정보 호출 함수 (수신자 설정)
	 */
	@RequestMapping(value="/ezEmail/getSharedMailboxMember.do", method = RequestMethod.GET)
	public String getSharedMailboxMember(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception{
		logger.debug("getSharedMailboxMember started.");
		
	    LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String shareId = request.getParameter("shareId");
		String lang = userInfo.getPrimary();
		int tenantId = userInfo.getTenantId();
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		MailSharedMailboxVO sharedMailboxInfo = ezEmailService.getSharedMailboxInfo(shareId, tenantId, lang);
		List<MailSharedMailboxUserVO> userList = sharedMailboxInfo.getUserList();
		String userId = null;
		OrganUserVO userVO = null;
		
		for (MailSharedMailboxUserVO user : userList) {
			userId = user.getUserId();
			userVO = ezOrganAdminService.getUserInfo(userId, userInfo.getPrimary(), userInfo.getTenantId());
			
			if (userVO != null) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("displayName", userVO.getDisplayName());
				map.put("mail", userVO.getMail());
				map.put("company", userVO.getCompany());
				map.put("dept", userVO.getDescription());
				map.put("title", userVO.getTitle());
				
				list.add(map);
			}
		}
		
		model.addAttribute("list", list);
		
		logger.debug("getSharedMailboxMember ended.");
		return "ezEmail/mailShowSharedMailboxMember";
	}
	
	/**
	 * 간편주소록 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetAddress.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailGetAddress(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception{
		logger.debug("mailGetAddress started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<SimpleAddressVO> addressList = ezAddressService.getSimpleAddress(userInfo.getTenantId(), userInfo.getId());
		
		StringBuilder sb = new StringBuilder();
		sb.append("<NewDataSet>");
		
		for (SimpleAddressVO vo : addressList) {
			sb.append("<Table>");
			sb.append("<NAME><![CDATA[" + vo.getName() + "]]></NAME>");
			sb.append("<EMAIL><![CDATA[" + vo.getEmail() + "]]></EMAIL>");
			sb.append("</Table>");
		}
		
		sb.append("</NewDataSet>");
		
		logger.debug("mailGetAddress ended.");
		return sb.toString();
	}
	
	/**
	 * 간편주소록 정보 저장 함수
	 */
	@RequestMapping(value="/ezEmail/mailSetAddress.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailSetAddress(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			@RequestBody String bodyData) throws Exception{
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		if (bodyData != null){
			ezAddressService.setSimpleAddress(userInfo.getTenantId(), userInfo.getId(), bodyData);
		}

		return "<DATA>OK</DATA>";
	}
	
	/**
	 * 수신인 추가시 부서나 이메일주소 등을 덧붙는 접두사를 반환
	 * email 파라미터로 OrganUserVO를 구한 후 접두사 만듦
	 */
	@RequestMapping(value="/ezEmail/mailGetUserAdditionalInfo.do", produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String mailGetUserAdditionalInfo(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception {
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		int tenantId = loginVO.getTenantId();

		String email = request.getParameter("email");
		String userId = "";
		if (loginVO.getEmail()!=null){
			userId = loginVO.getEmail().equals(email)
					? loginVO.getId()
					: ezOrganService.getCNByEmail(email, loginVO.getTenantId());
		}
		OrganUserVO userInfo = ezOrganAdminService.getUserInfo(userId, loginVO.getPrimary(), loginVO.getTenantId());

		if (userInfo == null) {
			return "";
		}

		String additionalFormat = ezCommonService.getTenantConfig("mailWriteRecipientAdditionalFormat", tenantId);
		String additionalParameters = ezCommonService.getTenantConfig("mailWriteRecipientAdditionalParameters", tenantId);
		String[] fieldNameArray = additionalParameters.split(";");
		int size = fieldNameArray.length;
		Object[] args = new String[size];

		for (int i = 0; i < size; i++) {
			try {
				Field field = OrganUserVO.class.getDeclaredField(fieldNameArray[i]);
				field.setAccessible(true);
				String value = field.get(userInfo).toString();
				args[i] = value;
			} catch (SecurityException ex) {
				logger.error(ex.getMessage(), ex);
				args[i] = "";
			} catch (Exception ex) {
				logger.error(ex.getMessage(), ex);
				args[i] = "";
			}
		}

		try {
			return String.format(additionalFormat, args);
		} catch (IllegalFormatException ex) {
			logger.error(ex.getMessage(), ex);
			return "";
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			return "";
		}
	}

	/**
	 * 최근 사용 주소 호출 함수
	 */
	private String getLastSentAddrSearch(int tenantId, String cn) {
		String returnValue = "";
		try {
			List<AddressVO> lastSentEmailAddresses = ezAddressService.getLastSentEmailAddresses(tenantId, cn);

			StringBuilder sb = new StringBuilder();
			sb.append("<LISTVIEWDATA><ROWS>");

			for (AddressVO a : lastSentEmailAddresses) {
				sb.append("<ROW>");
				sb.append("<NAME>" + commonUtil.cleanValue(a.getsName()) + "</NAME>");
				sb.append("<EMAIL>" + commonUtil.cleanValue(a.getsEmail()) + "</EMAIL>");
				sb.append("<SENTDATE>" + commonUtil.cleanValue(a.getCreateDate()) + "</SENTDATE>");
				sb.append("</ROW>");
			}

			sb.append("</ROWS></LISTVIEWDATA>");
			returnValue = sb.toString();

		} catch (RuntimeException e) {
			logger.error(e.getMessage(), e);
			returnValue = "EXCEPTION";

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			returnValue = "EXCEPTION";
		}
		return returnValue;
	}

	/**
	 * 사원 Organ 정보 호출 함수
	 */
	private String getOrganSearch(String pSearchList, String pCellList, String pPropList, String pListType, LoginVO userInfo) {
		String pResult = "";
        try {
            pResult = ezOrganService.getSearchListOR(pSearchList, pCellList, pPropList, pListType, 100, userInfo.getPrimary(), userInfo.getTenantId(), userInfo.getCompanyID());
        } catch (NullPointerException e) {
        	logger.error(e.getMessage(), e);
            pResult = "EXCEPTION";
		} catch (Exception e) {
        	logger.error(e.getMessage(), e);
            pResult = "EXCEPTION";
        }
        return pResult;
    }
	
	/**
	 * 공용배포그룹 정보 호출 함수
	 */
	private String getOrganDLSearch(String pSearchList, LoginVO userInfo) {
        String returnData = "";
        
        try {
        	String searchValue = pSearchList.split("::")[1];
        	
			List<MailDistributionVO> distributionList = ezEmailService.getDistributionSearchList(userInfo.getCompanyID(), userInfo.getTenantId(), searchValue);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<LISTVIEWDATA><ROWS>");

			for (MailDistributionVO vo : distributionList) {
				sb.append("<ROW><CELL>");
				
				sb.append("<VALUE>");
				sb.append(commonUtil.cleanValue(vo.getName()));
				sb.append("</VALUE>");
				
				sb.append("<DATA1>group</DATA1>");
				
				sb.append("<DATA2>");
				sb.append(commonUtil.cleanValue(vo.getId()));
				sb.append("</DATA2>");
				
				sb.append("<DATA3>");
				sb.append(commonUtil.cleanValue(vo.getMail()));
				sb.append("</DATA3>");
				
				sb.append("</CELL></ROW>");
			}
			
			sb.append("</ROWS></LISTVIEWDATA>");
			
			returnData = sb.toString();
			
		} catch (RuntimeException e) {
			returnData = "EXCEPTION";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnData = "EXCEPTION";
			logger.error(e.getMessage(), e);
		}
        
        return returnData;
    }
	
	/**
	 * 주소록 정보 호출 함수
	 */
	private String getAddressSearch(String pFilter, LoginVO userInfo) {
        String returnValue = "";
        try {
            String[] ownerIds = new String[]{userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId()};
            pFilter = "S_NAME;S_EMAIL," + pFilter;
            
            List<AddressVO> addressInfoList = ezAddressService.getSearchList(userInfo.getTenantId(), ownerIds, "", pFilter, 100, 0);
            
            StringBuilder sb = new StringBuilder();
            sb.append("<LISTVIEWDATA><ROWS>");
            
            for (AddressVO addressInfo : addressInfoList) {
            	sb.append("<ROW>");
            	sb.append("<STYPE>" + (addressInfo.getsType() == null ? "" : addressInfo.getsType()) + "</STYPE>");
            	sb.append("<ADDRESSID>" + (addressInfo.getAddressId() == null ? "" : addressInfo.getAddressId()) + "</ADDRESSID>");
            	sb.append("<SNAME>" + (addressInfo.getsName() == null ? "" : commonUtil.cleanValue(addressInfo.getsName())) + "</SNAME>");
            	sb.append("<FOLDERTYPE>DB</FOLDERTYPE>");
            	sb.append("<SEMAIL>" + (addressInfo.getsEmail() == null ? "" : commonUtil.cleanValue(addressInfo.getsEmail())) + "</SEMAIL>");
            	sb.append("<SCOMPANY>" + (addressInfo.getsCompany() == null ? "" : commonUtil.cleanValue(addressInfo.getsCompany())) + "</SCOMPANY>");
            	sb.append("<SDEPT>" + (addressInfo.getsDept() == null ? "" : commonUtil.cleanValue(addressInfo.getsDept())) + "</SDEPT>");
            	sb.append("<STITLE>" + (addressInfo.getsTitle() == null ? "" : commonUtil.cleanValue(addressInfo.getsTitle())) + "</STITLE>");
            	sb.append("</ROW>");
            }
            
            sb.append("</ROWS></LISTVIEWDATA>");
            returnValue = sb.toString();
        } catch (RuntimeException e) {
        	logger.error(e.getMessage(), e);
        	returnValue = "EXCEPTION";
		} catch (Exception e) {
        	logger.error(e.getMessage(), e);
        	returnValue = "EXCEPTION";
        }
        return returnValue;
    }
	
	/**
	 * 공유사서함 정보 호출 함수
	 */
	private String getSharedMailboxSearch(String pSearchList, LoginVO userInfo) {
        String returnData = "";
        
        try {
        	String searchValue = pSearchList.split("::")[1];
        	searchValue = searchValue.replace("%", "\\%").replace("_", "\\_");
        	
			List<MailSharedMailboxVO> sharedMailboxList = ezEmailService.getSharedMailboxSearchList(userInfo.getCompanyID(), userInfo.getTenantId(), searchValue);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<LISTVIEWDATA><ROWS>");

			for (MailSharedMailboxVO vo : sharedMailboxList) {
				sb.append("<ROW><CELL>");
				
				sb.append("<VALUE>");
				sb.append(commonUtil.cleanValue(vo.getShareName()));
				sb.append("</VALUE>");
				
				sb.append("<DATA1>group</DATA1>");
				
				sb.append("<DATA2>");
				sb.append(commonUtil.cleanValue(vo.getShareId()));
				sb.append("</DATA2>");
				
				sb.append("<DATA3>");
				sb.append(commonUtil.cleanValue(vo.getShareMail()));
				sb.append("</DATA3>");
				
				sb.append("<DATA4>");
				sb.append(commonUtil.cleanValue(vo.getCompanyName()));
				sb.append("</DATA4>");
				
				sb.append("</CELL></ROW>");
			}
			
			sb.append("</ROWS></LISTVIEWDATA>");
			
			returnData = sb.toString();
			
		} catch (RuntimeException e) {
			returnData = "EXCEPTION";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnData = "EXCEPTION";
			logger.error(e.getMessage(), e);
		}
        
        return returnData;
    }
	
	private String convertDownloadInlineImageURLtoCid(String htmlStr) {
		Pattern pat = Pattern.compile("src=\"/ezEmail/downloadInline\\.do.*?contentId=%3C(.*?)%3E.*?\"", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
		Matcher mat = pat.matcher(htmlStr);
				
		StringBuffer result = new StringBuffer();
		while (mat.find()) {
			String cid = mat.group(1);
			try {
				cid = URLDecoder.decode(cid, "UTF-8");
			} catch (UnsupportedEncodingException e) {
				logger.error(e.getMessage(), e);
			}
			mat.appendReplacement(result, Matcher.quoteReplacement("src=\"cid:" + cid + "\""));
		}
		mat.appendTail(result);
		
		return result.toString();	
	}
	
	private void removeUnusedInlineImagePart(Multipart relatedPart) {
		try {
			String htmlStr = relatedPart.getBodyPart(0).getContent().toString();
			int count = relatedPart.getCount() - 1;
			
			for (int i = count; i >= 1; i--) {
				MimeBodyPart bp = (MimeBodyPart)relatedPart.getBodyPart(i);
				
				if (bp.getDisposition() != null) {
					String contentID = bp.getContentID();
					
					if (contentID != null && contentID.length() > 2) {
						contentID = contentID.substring(1, contentID.length() - 1);
						if (htmlStr.indexOf("src=\"cid:" + contentID) < 0) {
							logger.debug("this inline image isn't used. contentID=" + contentID);
							relatedPart.removeBodyPart(i);
						}
					}
				}
			}
		} catch (IOException e) {
			logger.error(e.getMessage(), e);
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		}
	}
	
	/**
	 * 메일 예약발송 처리 함수
	 */
	private void doDelaySend(int tenantId, Message message, String isReserve, String reservedId, String subject, String sendDate, String mailId, String userId, String realPath) throws Exception {
		logger.debug("isReserve : " + isReserve);
		logger.debug("subject : " + subject);
		logger.debug("sendDate : " + sendDate);
		logger.debug("reservedId : " + reservedId);
		
		String messageId = commonUtil.detectPathTraversal(reservedId);
		
		messageId = ezEmailService.setMailReserved(tenantId, messageId, subject, sendDate, mailId, userId, isReserve);
		
		File f = null;
		
		String pDirPath = commonUtil.getUploadPath("upload_mail.RESERVED_MAIL_PATH", tenantId);
		pDirPath = realPath + pDirPath;
		f = new File(pDirPath);
		if (!f.exists()) {
			f.mkdirs();
		}
		
		f = new File(pDirPath + commonUtil.separator + messageId + ".eml");
    	FileOutputStream fos = null;
    	try {
    		fos = new FileOutputStream(f);
    		message.writeTo(fos);
    	} catch (IOException e) {
    		logger.error("IOException has occurred");
    		logger.error(e.getMessage(), e);
    	} finally {
    		if (fos != null) {
    			fos.close();
    		}
    	}
	}
	
	/**
	 * 받는사람, 참조, 숨은참조 등 자동완성 기능
	 */
	@RequestMapping(value = "/ezEmail/autoCompleteList.do", produces = "application/json; charset=utf-8", method = RequestMethod.POST)
	public String autoCompleteList(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model,
		@RequestBody Map<String, Object> requestBody, HttpServletRequest request) throws Exception {
		logger.debug("autoCompleteList started.");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String searchValue = StringUtils.defaultString((String) requestBody.get("value"));
		String lastSentCn = StringUtils.defaultIfBlank((String) requestBody.get("shareId"), userInfo.getId());
		SimpleDateFormat utcFormatter = null;
		TimeZone timeZone = null;
		long aDayAgo = 0;

		try {
			List<Object> jsonList = new ArrayList<Object>();
			HashMap<String, Document> xmlMap = new HashMap<String, Document>();
			String[] orderedKeys;

			// 최근 사용 주소
			if (searchValue.length() < 2) {
				orderedKeys = new String[]{"lastSent"};
				xmlMap.put("lastSent", commonUtil.convertStringToDocument(getLastSentAddrSearch(userInfo.getTenantId(), lastSentCn)));

				// utcFormatter
				utcFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
				utcFormatter.setTimeZone(TimeZone.getTimeZone("GMT"));
				// timeZone
				String offset = StringUtils.defaultIfBlank(userInfo.getOffset(), "|");
				timeZone = TimeZone.getTimeZone("GMT" + offset.split("\\|", 2)[1]);
				// aDayAgo
				aDayAgo = new Date().getTime() - 24*3600000;

			// 주소 자동 완성
			} else {
				// (1. orderedKeys) 20190619 조진호 - 메일 주소 검색 대상 순서 변경 추가
				orderedKeys = new String[]{"organ", "dl", "address", "shared"}; // [] 배열: 순서 보장됨.
				String mailAddressSearchOrder = ezCommonService.getUserConfigInfo(userInfo.getTenantId(), userInfo.getId(), "mailAddressSearchOrder");

				if (StringUtils.isNotBlank(mailAddressSearchOrder)) {
					orderedKeys = mailAddressSearchOrder.toLowerCase().split(";");
				}

				// (2. xmlMap) : organ, dl, address, shared.
				String pOrganSearchList = "displayname::" + searchValue + ";;mail::" + searchValue;
				String pOrganCellList = "displayname";
				String pOrganPropList = "company;description;title;mail;extensionAttribute3;displayName2";
				String pOrganListType = "all";
				String pDLSearchList = "displayname::" + searchValue;
				String pSharedMailboxSearchList = "displayname::" + searchValue;

				// useShowAllCompanies가 YES이고 company 패러메터가 전달된 경우에는
				// Company ID를 ""로 세트하여 그룹사 전체 조직도를 대상으로 검색하도록 한다.
				String useShowAllCompanies = ezCommonService.getTenantConfig("useShowAllCompanies", userInfo.getTenantId());
				String orgCompanyId = userInfo.getCompanyID();

				if (useShowAllCompanies.equals("YES")) {
					String companyId  = (String) requestBody.get("company");

					if (companyId != null) {
						userInfo.setCompanyID("");
					}
				}

				// 조직도
				xmlMap.put("organ", commonUtil.convertStringToDocument(getOrganSearch(pOrganSearchList, pOrganCellList, pOrganPropList, pOrganListType, userInfo)));
				// 공용그룹
				xmlMap.put("dl", commonUtil.convertStringToDocument(getOrganDLSearch(pDLSearchList, userInfo)));

				if (useShowAllCompanies.equals("YES")) {
					// Company ID를 본래값으로 복원한다.
					userInfo.setCompanyID(orgCompanyId);
				}

				// 주소록
				xmlMap.put("address", commonUtil.convertStringToDocument(getAddressSearch(searchValue, userInfo)));
				// 공유사서함
				xmlMap.put("shared", commonUtil.convertStringToDocument(getSharedMailboxSearch(pSharedMailboxSearchList, userInfo)));
			}

			// Cell 객체에 싸서, 각 list에 따라 적절한 속성값을 추출하도록 함.
			for (String key : orderedKeys) {
				NodeList row = xmlMap.get(key).getElementsByTagName("ROW");

				for (int i = 0; i < row.getLength(); i++) {
					Cell cell = new Cell(key, (Element) row.item(i), locale, utcFormatter, timeZone, aDayAgo);

					if (StringUtils.isNotBlank(cell.mail)) {
						HashMap<String, Object> jsonObject = new HashMap<String, Object>();

						jsonObject.put("name", cell.name);
						jsonObject.put("title", cell.title);
						jsonObject.put("description", cell.description);
						jsonObject.put("mail", cell.mail);
						jsonObject.put("type", cell.type);
						jsonObject.put("href", cell.href);
						jsonObject.put("sentDate", cell.sentDate);

						jsonList.add(jsonObject);
					}
				}
			}
			
			model.addAttribute("susinList", jsonList);
		} catch (DOMException e) {
			logger.debug("e.message=" + e.getMessage());
		} catch (Exception e) {
			logger.debug("e.message=" + e.getMessage());
		}

		logger.debug("autoCompleteList ended.");
		return "json";
	}

	class Cell {
		Element cell;
		String name = "";
		String title = "";
		String description = "";
		String mail = "";
		String type = "";
		String href = "";
		String sentDate = "";

		public Cell(String key, Element row, Locale locale, SimpleDateFormat utcFormatter, TimeZone timeZone, long aDayAgo) throws Exception {
			NodeList list = row.getElementsByTagName("CELL");
			this.cell = (list.getLength() > 0) ? (Element) list.item(0) : row;

			/* [if] 순차 조건 평가. [switch] 점프 테이블 사용.
			 * - 작은 조건문: switch와 if의 성능 차이 미미. 가독성과 관리 편의성에 따라 선택.
			 * - 조건이 많아질수록: 예를 들어, 10개 이상의 조건이 있을 때 switch는 빠른 조건 분기가 가능. 더 효율적.
			 */
			switch (key) {
				case "lastSent":
					setPrimary("NAME", "EMAIL");
					setSentDate(utcFormatter, timeZone, aDayAgo);
					break;

				case "organ":
					setPrimary("VALUE", "DATA6");
					this.title = getByTag("DATA5");
					this.description = getByTag("DATA4");
					break;
				case "dl":
					setPrimary("VALUE", "DATA3");
					setDescriptionByMsg("ezEmail.t593", locale);
					break;
				case "address":
					setPrimary("SNAME", "SEMAIL");
					setDescriptionByMsg("ezEmail.t99000041", locale);
					this.type = getByTag("STYPE");
					this.href = getByTag("ADDRESSID") + "|!|" + getByTag("FOLDERTYPE");
					break;
				case "shared":
					setPrimary("VALUE", "DATA3");
					setDescriptionByMsg("ezEmail.sharedMailbox02", locale);
					break;
			}
		}

		void setPrimary(String name, String mail) {
			this.name = getByTag(name);
			this.mail = getByTag(mail);
		}
		void setDescriptionByMsg(String code, Locale locale) {
			this.description = egovMessageSource.getMessage(code, locale);
		}

		void setSentDate(SimpleDateFormat utcFormatter, TimeZone timeZone, long aDayAgo) throws Exception {
			String sentDateStr = getByTag("SENTDATE");
			Date sentDate = utcFormatter.parse(sentDateStr); //throws ParseException

			boolean within24h = sentDate.getTime() > aDayAgo;
			SimpleDateFormat localFormatter = new SimpleDateFormat(within24h? "HH:mm" : "MM.dd");
			localFormatter.setTimeZone(timeZone);

			this.sentDate = localFormatter.format(sentDate);
		}

		String getByTag(String tagName) {
			NodeList tags = this.cell.getElementsByTagName(tagName);
			return (tags.getLength() > 0) ? tags.item(0).getTextContent() : "";
		}
	}
	
	/**
	 * size만 읽는 OutputStream 클래스
	 */
	public class CountOutputStream extends OutputStream {
	    int size;
		
	    public int getSize() {
	    	return size;
	    }
	    
	    @Override
	    public void write(byte[] b, int off, int len) {
	    	size += len;
	    }

	    @Override
	    public void write(int b) {
	    	size += 1;
	    }

	    @Override
	    public void write(byte[] b) throws IOException {
	    	size += b.length;
	    }
	}
	
	@RequestMapping(value="/ezEmail/downloadAttachInWriter.do", method = RequestMethod.GET)
	@ResponseBody
	public void downloadAttachInWriter(@CookieValue("loginCookie") String loginCookie,
			HttpServletRequest request, HttpServletResponse response, Locale locale) throws Exception {
		logger.debug("downloadAttachInWriter started");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, loginInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("downloadAttachInWriter ended.");
					
					return;
				}
				
				userEmail = shareId + "@" + domainName;
			}
		}
		
		logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);
		
		String folderPath = request.getParameter("folderPath");
		String fileName = request.getParameter("filename");
		String strUid = request.getParameter("uid");
		int fileIndex = Integer.valueOf(request.getParameter("index")); 
		long uid = strUid != null ? Long.parseLong(strUid) : 0;
		logger.debug("folderPath=" + folderPath + ",uid=" + uid + "fileIndex=" + fileIndex + ",fileName=" + fileName);
		
		if (folderPath == null || strUid == null || fileName == null) {
			logger.debug("downloadAttach illegal arguments");
			return;
		}
		
		IMAPAccess ia = null;
		
		try {
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"), 
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			
			Folder folder = ia.getFolder(folderPath);
			
			if (folder == null || !folder.exists()) {
				logger.debug("folder not found. folderPath=" + folderPath);
			} else {
				folder.open(Folder.READ_ONLY);
				
				Message message = null;
				
				if (folder.isOpen() && folder instanceof IMAPFolder) {
					message = ((IMAPFolder)folder).getMessageByUID(uid);
					
					if (message == null) {
						logger.error("message not found. uid=" + uid);
					} else {

						Multipart mp = (Multipart) message.getContent();
						
						int count = mp.getCount();
						BodyPart p = null;
						int nonAttachCount = 0;
						
						// 첨부파일 파트 이전에 존재하는 파트 갯수를 구한다.
						for (int i = 0; i < count; i++) {
							p = mp.getBodyPart(i);
							
							if (p.getDisposition() == null) {
								nonAttachCount++;
							} else {
								break;
							}
						}
						
						// 첨부파일의 index가 nonAttachCount 만큼 뒤로 밀렸으므로 i - nonAttachCount와 비교하여 파일을 다운로드 한다.
						for (int i = 0; i < count; i++) {
							p = mp.getBodyPart(i);
							
							if (p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)) {
								
								if (fileIndex == (i - nonAttachCount)) {
									response.setContentType(p.getContentType());
									fileName = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), fileName);
									String nfcFileName = commonUtil.normalizeFileName(fileName);
									
									response.addHeader("content-disposition", "attachment; filename=\"" + nfcFileName + "\"");
									logger.debug("content-disposition=" + "attachment; filename=\"" + nfcFileName + "\"");
									
									InputStream input = null;
									OutputStream output = null;
									
									try {
										input = p.getInputStream();
										output = response.getOutputStream();
										
										byte[] buffer = new byte[4096];
										int byteRead;
										
										while ((byteRead = input.read(buffer)) != -1) {
											output.write(buffer, 0, byteRead);
										}
									} catch (IOException e) {
										logger.error(e.getMessage(), e);
									} catch (Exception e) {
										logger.error(e.getMessage(), e);
									} finally {
										if (ia != null) {
											ia.close();
										}
										if (input != null) {
											input.close();
										}
										if (output != null) {
											output.flush();
											output.close();
										}
									}
									
									break;
								}
							}
						}
					}
				}
			}
			
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("downloadAttachInWriter ended");
	}
	
	/**
	 * 공용배포그룹 전체 검색
	 * - useUserDefined == YES 일 때 수신자 설정 > 공용그룹 > 검색  박스 출력 
	 *   '전체'로 셀랙트 박스 선택 후 검색 시  관리자페이지에서 생성한 공용배포그룹까지 검색
	 */
	@RequestMapping(value = "/ezEmail/mailGetUserDistributionSearchAll.do", produces="text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailGetUserDistributionSearchAll(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model,
			HttpServletRequest request) throws Exception {
		logger.debug("mailGetUserDistributionSearchAll started.");

		String searchValue = request.getParameter("searchValue");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String returnData = "";

		List<MailDistributionVO> distributionList = ezEmailService.getDistributionSearchList(userInfo.getCompanyID(), userInfo.getTenantId(), searchValue);
		
		StringBuilder sb = new StringBuilder();
		sb.append("<LISTVIEWDATA><ROWS>");
		for (MailDistributionVO vo : distributionList) {
			sb.append("<ROW><CELL>");
			sb.append("<VALUE>" + commonUtil.cleanValue(vo.getName()) + "</VALUE>");
			sb.append("<DATA1>" + commonUtil.cleanValue(vo.getId()) + "</DATA1>");
			sb.append("<DATA2>" + commonUtil.cleanValue(vo.getMail()) + "</DATA2>");
			sb.append("</CELL></ROW>");
		}
		sb.append("</ROWS></LISTVIEWDATA>");
		
		returnData = sb.toString();

		logger.debug("mailGetUserDistributionSearchAll ended.");
		return returnData;
	}
	
	/*
	 * 수신인 안내문구 
	 * 
	 */
	private String addCopyrightText(LoginVO userInfo, String mailBody, String type) throws Exception {
		int tenantId = userInfo.getTenantId();
		String companyId = userInfo.getCompanyID();
		String defaultFontAndSize = "";
		String addCopyrightStr = "";

		//사용자 언어가 한국어이고 editorFontStyle값이 있을 경우 editorFontStyle값 적용
		if (userInfo.getLang().equals("1")) {
			String editorFontStyle = ezCommonService.getTenantConfig("editorFontStyle", userInfo.getTenantId());
			
			String fontFamily = "맑은 고딕"; // jmocha copyright mailet default font css
			String fontSize = "13px";
			
			if (!editorFontStyle.equals("")) {
				fontFamily = editorFontStyle.split("\\|")[0];
				fontSize = editorFontStyle.split("\\|")[1];
			}
			defaultFontAndSize = "font-size:" + fontSize + ";font-family:" + fontFamily + ";";
		}
		
		String copyrightDiv = "<p>&nbsp;</p><div id=\"recipientPhrase\" style=\"box-sizing:border-box; padding:5px 3px; border:1px solid #999; "
				+ defaultFontAndSize + " color: rgb(153, 153, 153);\">%s</div>";
		String useCopyrightMenu = ezCommonService.getTenantConfig("useCopyrightMenu", tenantId);
		useCopyrightMenu = useCopyrightMenu.equals("") ? "NO" : useCopyrightMenu;
		String useCopyright = ezCommonService.getCompanyConfig(tenantId, companyId, "useCopyright");
		useCopyright = useCopyright.equals("") ? "YES" : useCopyright;
		String copyrightText = ezEmailUserAdminService.getCopyrightText(userInfo.getTenantId(), companyId);	
		logger.debug("tenantId=" + tenantId + ",companyId=" + companyId
				+ ",useCopyright=" + useCopyright + ",useCopyrightMenu=" + useCopyrightMenu);

		if (useCopyrightMenu.equals("YES") && !useCopyright.equals("NO") && !copyrightText.trim().equals("")) {
			mailBody = mailBody.replaceAll("\\p{Z}", " "); // 유니코드 범주내에서 구분 기호, 공백을  replacAll
			
			if (copyrightText.contains("id=\"recipientPhrase\"")
					|| mailBody.contains(copyrightText)
					|| mailBody.contains(copyrightText.replace(" ", "&nbsp;"))) {
				logger.debug("copyrightText already exists.");
				return "";
			}
			
			if (type.equals("text/html")) {
				addCopyrightStr = String.format(copyrightDiv, copyrightText);
			} else if(type.equals("text/plain")) {
				String line = "--------------------------------------------------";
				addCopyrightStr = "\r\n" + line;
				addCopyrightStr += "\r\n" + copyrightText; // 태그 제외 된 copyright 문구, copyright 문구 뒤가 1-3개씩 잘리는 현상때문에 줄바꿈 추가
				addCopyrightStr += "\r\n" + line + "\r\n";
			}
		}

		return addCopyrightStr;
	}

	/**
	 * 메일쓰기 - 공용배포그룹(받는사람,참조,숨은참조) 확인
	 */
	@RequestMapping(value="/ezEmail/CheckDistributionExist.do", method = RequestMethod.GET)
	@ResponseBody
	public String CheckDistributionExist(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("CheckDistributionExist started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String groupName = request.getParameter("groupName");
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String companyId = userInfo.getCompanyID();

		String response = null;
		try {
			String inputParams = "groupName=" + URLEncoder.encode(groupName, "UTF-8")
					+ "&domainName=" + URLEncoder.encode(domainName, "UTF-8")
					+ "&companyId=" + URLEncoder.encode(companyId, "UTF-8");

			logger.debug("inputParams=" + inputParams);

			String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getDistributionUserName";
			response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

			logger.debug("response=" + response);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return response;

	}
	
	
	/**
	 * 일반 첨부파일 순서 저장 함수
	 */
	@RequestMapping(value="/ezEmail/saveAttachFileOrder.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String saveAttachFileOrder( @CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request) throws Exception {
		logger.debug("saveAttachFileOrder started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		String returnValue = "";
		
		long uid = 0;
		String strUid = request.getParameter("itemid");
		String[] fileIdxArr = request.getParameterValues("fileIdxArr[]");
		
		uid = strUid != null ? Long.parseLong(strUid) : uid;
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null && !shareId.equals("")) {
				if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, loginInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("saveAttachFileOrder ended.");
					
					return "";
				}
				
				userEmail = shareId + "@" + domainName;
			}
		}
		
		logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);
		
		if (uid != 0) {
			SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
					userEmail, password, loginInfo.getEmail());
			
			IMAPAccess ia = null;
			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, locale, ezEmailUtil);
				
				if (ia != null){
					Folder folder = ia.getFolder(ezEmailUtil.getDraftsFolderId(locale));
					if (folder != null){

						folder.open(Folder.READ_WRITE);
						Message oldMessage = ((IMAPFolder)folder).getMessageByUID(uid);

						if (oldMessage != null) {
							MimeMessage newMessage = sa.createMimeMessage();
							Multipart multipart = new MimeMultipart();

							Multipart mp = (Multipart)oldMessage.getContent();
							int count = mp.getCount();
							BodyPart p = null;
							int nonAttachCount = 0;

							// 첨부파일 파트 이전에 존재하는 파트들의 갯수를 구한다.
							// 이 로직이 제대로 동작하려면 첨부파일들이 모두 메시지의 뒷부분에 연속으로 위치하여야 한다.
							for (int i = 0; i < count; i++) {
								p = mp.getBodyPart(i);

								if (p.getDisposition() != null
										&& p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)
										&& ((MimePart)p).getContentID() == null) {
									break;
								} else {
									nonAttachCount++;
								}
							}

							BodyPart[] oldAttachPartArr = new BodyPart[count - nonAttachCount];
							for (int i = 0; i < count; i++) {
								p = mp.getBodyPart(i);

								if (i < nonAttachCount) {
									multipart.addBodyPart(p);
								} else if (p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)) {
									oldAttachPartArr[i - nonAttachCount] = p;
								} else {
									multipart.addBodyPart(p);
								}
							}

							for (int i = 0; i < fileIdxArr.length; i++) {
								multipart.addBodyPart(oldAttachPartArr[Integer.parseInt(fileIdxArr[i])]);
							}

							@SuppressWarnings("unchecked")
							Enumeration<Header> e = oldMessage.getAllHeaders();
							while(e.hasMoreElements()){
								Header header = e.nextElement();
								newMessage.setHeader(header.getName(), header.getValue());
							}

							if (multipart.getCount() != 0) {
								newMessage.setContent(multipart);
								newMessage.setFlag(Flags.Flag.SEEN, true);
								AppendUID[] uids = ((IMAPFolder)folder).appendUIDMessages(new Message[]{newMessage});
								returnValue += uids[0].uid;
							}

							oldMessage.setFlag(Flags.Flag.DELETED, true);

						} else {
							logger.debug("oldMessage is null. uid = " + uid);
						}
						folder.close(true);
					}
				}
				
			} catch (MessagingException e) {
				logger.error(e.getMessage(), e);
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
		}
		
		logger.debug("saveAttachFileOrder ended. returnValue=" + returnValue);
		
		return returnValue;	
	}
	
	/**
	 * 대용량첨부 횟수 정보 입력 실행 함수
	 */
	@RequestMapping(value="/ezEmail/setBigAttachCountInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public String setBigAttachCountInfo( @CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("setBigAttachCountInfo started.");
		
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String[] fileIdArr = request.getParameterValues("bigAttach[]");
		int bigSizeAttachDownloadLimitCount = Integer.parseInt(request.getParameter("BigSizeAttachDownloadLimitCount"));
		int tenantId = userInfo.getTenantId();
        
        ezEmailService.setBigAttachCountInfo(fileIdArr, bigSizeAttachDownloadLimitCount, tenantId);
        
        logger.debug("setBigAttachCountInfo ended.");
        
		return "";
	}
	
	/**
	 * 메일 템플릿 팝업
	 */
	@RequestMapping(value="/ezEmail/userMailTemplateMain.do", method = RequestMethod.GET)
	public String userMailTemplateMain() throws Exception{
		logger.debug("userMailTemplateMain start-ended");
		return "ezEmail/mailTemplateMain";
	}

	/**
	 * 메일 템플릿 저장 팝업
	 */
	@RequestMapping(value="/ezEmail/saveUserMailTemplateMain.do", method = RequestMethod.GET)
	public String saveUserMailTemplateMain() throws Exception{
		logger.debug("saveUserMailTemplateMain start-ended");
		return "ezEmail/mailTemplateAdd";
	}

	/**
	 * 메일 템플릿 리스트 가져오기
	 */
	@RequestMapping(value="/ezEmail/getUserMailTemplateList.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public String getUserMailTemplateList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception{
		logger.debug("getUserMailTemplateList started.");
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		int tenantId = loginInfo.getTenantId();
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("tenantId=" + tenantId + ", domainName=" + domainName + ", userEmail=" + userEmail);
		
		JSONArray jsonArr = ezEmailService.getUserMailTemplateList(userEmail);
		
		logger.debug("getUserMailTemplateList ended.");
		return jsonArr.toString();
	}

	/**
	 * 메일 템플릿 개별 가져오기
	 */
	@RequestMapping(value="/ezEmail/getUserMailTemplate.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public String getUserMailTemplate(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception{
		logger.debug("getUserMailTemplate started.");
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		int tenantId = loginInfo.getTenantId();
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("tenantId=" + tenantId + ", domainName=" + domainName + ", userEmail=" + userEmail);
		
		String templateId = request.getParameter("templateId");
		templateId = templateId == null ? "" : templateId;
		logger.debug("templateId=" + templateId);
		
		JSONObject jsonObj = ezEmailService.getUserMailTemplate(userEmail, templateId);
		
		logger.debug("getUserMailTemplate ended.");
		return jsonObj != null ? jsonObj.toJSONString() : null;
	}
	
	/**
	 * 메일 템플릿 미리보기
	 */
	@RequestMapping(value="/ezEmail/userMailTemplatePreview.do", method = RequestMethod.GET)
	public String userMailTemplatePreview(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("userMailTemplatePreview started.");
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		int tenantId = loginInfo.getTenantId();
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("tenantId=" + tenantId + ", domainName=" + domainName + ", userEmail=" + userEmail);
		
		String templateId = request.getParameter("templateId");
		templateId = templateId == null ? "" : templateId;
		logger.debug("templateId=" + templateId);
		
		JSONObject jsonObj = ezEmailService.getUserMailTemplate(userEmail, templateId);
		
		model.addAttribute("templateObj", jsonObj);
		
		logger.debug("userMailTemplatePreview ended.");
		return "ezEmail/mailTemplatePreview";
	}
	
	/**
	 * 메일 템플릿 삭제
	 */
	@RequestMapping(value="/ezEmail/deleteUserMailTemplate.do", method = RequestMethod.POST)
	@ResponseBody
	public String deleteUserMailTemplate(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception{
		logger.debug("deleteUserMailTemplate started.");

		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		int tenantId = loginInfo.getTenantId();
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("tenantId=" + tenantId + ", domainName=" + domainName + ", userEmail=" + userEmail);
		
		String templateId = request.getParameter("templateId");
		templateId = templateId == null ? "" : templateId;
		logger.debug("templateId=" + templateId);
		
		String realPath = commonUtil.getRealPath(request);
		
		int resultInt = ezEmailService.deleteUserMailTemplate(userEmail, templateId, "indiviaul", realPath, tenantId);
		String returnStr = resultInt == 0 ? "OK" : "ERROR";
		
		logger.debug("deleteUserMailTemplate ended.");
		return returnStr;
	}
	
	/**
	 * 메일 템플릿 저장
	 */
	@RequestMapping(value="/ezEmail/saveUserMailTemplate.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveUserMailTemplate(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception{
		logger.debug("saveUserMailTemplate started.");
		
		String returnStr = "ERROR";
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		int tenantId = loginInfo.getTenantId();
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("tenantId=" + tenantId + ", domainName=" + domainName + ", userEmail=" + userEmail);

		String displayName = request.getParameter("displayName");
		displayName = displayName == null ? "" : displayName;
		String content = request.getParameter("content");
		content = content == null ? "" : content;
		String editorType = request.getParameter("editorType"); // 0:html, 1:plain
		logger.debug("displayName=" + displayName + ", editorType=" + editorType);
		
		String realPath = commonUtil.getRealPath(request);
		realPath = (realPath != null) ? realPath : "";
		editorType = (editorType != null) ? editorType : "";
		int resultInt = ezEmailService.saveUserMailTemplate(userEmail, displayName, content, realPath, editorType, tenantId);
		returnStr = resultInt == 0 ? "OK" : resultInt == -2 ? "DUPLICATE" : "ERROR";
		
		logger.debug("saveUserMailTemplate ended.");
		return returnStr;
	}

	/** 
	 * 승인메일 :
	 * 승인메일 정책 체크
	 */ 
	@RequestMapping(value="/ezEmail/appr/checkApprPolicy.do", method = RequestMethod.POST)
	@ResponseBody
	public String checkApprPolicy(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("checkApprPolicy started.");
		
		String returnStr = "OK"; // OK, ALL_HANDS:전사메일, EXTERNAL:외부발송메일, EXTERNAL_ATTACH:외부발송메일_첨부파일, INNER:내부발송메일, INNER_ATTACH:내부발송메일_첨부파일
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		int tenantId = userInfo.getTenantId();
		String companyId = userInfo.getCompanyID();
		logger.debug("tenantId={}, companyId={}", tenantId, companyId);

		// Parameter ... 
		Boolean hasAttach = BooleanUtils.toBoolean(request.getParameter("hasAttach"));
		String msgTo = request.getParameter("msgTo");
		String msgCC = request.getParameter("msgCC");
		String msgBCC = request.getParameter("msgBCC");
		String shareId = request.getParameter("shareId");
		logger.debug("hasAttach={}, shareId={}", hasAttach, shareId);
		logger.debug("msgTo={}, msgCC={}, msgBCC={}", msgTo, msgCC, msgBCC);
		
		List<String> msgRecipients = new ArrayList<String>(){{add(msgTo); add(msgCC); add(msgBCC);}};
		String chkUserId = StringUtils.defaultIfEmpty(shareId, userId);
		logger.debug("chkUserId={}", chkUserId);
		
		// getPolicy
		String useApprMailAllHands 	= ezCommonService.getCompanyConfig(tenantId, companyId, "useApprMailAllHands"); // 전사메일 (USAGE|UNUSED)
		String useApprMailOut 		= ezCommonService.getCompanyConfig(tenantId, companyId, "useApprMailOut"); // 외부로 발송되는 메일 (USAGE|USAGE_ATTACH|UNUSED)
		String useApprMailIn 		= ezCommonService.getCompanyConfig(tenantId, companyId, "useApprMailIn"); // 내부로 발송되는 메일 (USAGE|USAGE_ATTACH|UNUSED)
		boolean isExceptionUser		= ezEmailService.checkExceptionUser(tenantId, companyId, chkUserId);
		logger.debug("useApprMailAllHands={}, useApprMailIn={}, useApprMailOut={}, isExceptionUser={}"
				, useApprMailAllHands, useApprMailIn, useApprMailOut, isExceptionUser);
		
		// domain
		Set<String> domainSet = new HashSet<String>(); // 수신자 도메인 리스트 
		List<String> recipients = new ArrayList<String>(); // 수신자 리스트
		
		String pattern = "\"?([^\"]*)\"? <([^<>]+)>";
		Pattern r = Pattern.compile(pattern);
		for (String s : msgRecipients) {
			Matcher m = r.matcher(s);
			while (m.find()) {
				String address = m.group(2);
				String domain = address.substring(address.indexOf('@') + 1);
				
				domainSet.add(domain);
				recipients.add(address);
			}
		}
		logger.debug("domainSet={}", domainSet);
		
		// 조건 체크
		boolean policyChk = true;// boolean allHands = true; boolean innerMail = true; boolean outerMail = true;
		/*
		 * 1. 전사메일 발송 시 승인메일 프로세스 사용 여부 확인 후 수신자에 전사메일이 포함 되어있는지 체크
		 * 2. 허용도메인으로 구성되어있는지 체크
		 * 3. 외부메일 발송 시 승인메일 프로세스 사용여부 && 예외자인지 확인 후 외부메일이 포함되어있는지, 전체/첨부파일메일 포함 체크
		 * 4. 내부메일 발송 시 승인메일 프로세스 사용여부 && 예외자인지 확인 후 내부메일이 포함되어있는지, 전체/첨부파일메일 포함 체크
		 */
		do {
			// 전사메일 ----------------------------------------------------------
			if (!"UNUSED".equalsIgnoreCase(useApprMailAllHands)) {
				for (String addr : recipients) {
					if(ezEmailUtil.isCompanyMail(addr, tenantId)) {
						policyChk = false;
						returnStr = "ALL_HANDS";
						logger.debug("useApprMailAllHands policy. addr={}", addr);
						break;
					}
				}
				if (!policyChk) {break; }
			}

			// 허용도메인---------------------------------------------------------
			List<String> allowedDomainList = ezEmailService.getApprAllowedDomainList(tenantId, companyId);
			Set<String> allowedDomainSet = new HashSet<String>(allowedDomainList); // 허용도메인 리스트

			Set<String> domainSetClone = new HashSet<String>(){{addAll(domainSet);}};
			domainSetClone.removeAll(allowedDomainSet); // 수신자도메인과 허용도메인을 차집합
			if (domainSetClone.size() == 0) {
				policyChk = false;
				logger.debug("allowedDomain policy.");
				break;
			}
			
			// 일반메일 ----------------------------------------------------------
			String mailInnerDomain = ezCommonService.getTenantConfig("MailInnerDomain", tenantId);
			Set<String> innerDomainSet = new HashSet<String>(Arrays.asList(mailInnerDomain.split(";"))); // 시스템에서 사용하는 도메인 리스트 (내부도메인)
			logger.debug("innerDomainSet={}", innerDomainSet);
			
			// 외부메일 발송 조건 체크
			if (!"UNUSED".equalsIgnoreCase(useApprMailOut) && !isExceptionUser) {
				Set<String> externalDomain = new HashSet<String>(){{addAll(domainSet);}};
				externalDomain.removeAll(innerDomainSet); // 수신자도메인과 내부도메인을 차집합하여 외부로 발송되는 도메인 추출
				logger.debug("externalDomain={}", externalDomain);
				
				if (externalDomain.size() > 0) {
					if ("USAGE".equalsIgnoreCase(useApprMailOut)) { // 모든 메일인 경우
						policyChk = false;
						returnStr = "EXTERNAL";
					} else if ("USAGE_ATTACH".equalsIgnoreCase(useApprMailOut) && hasAttach) { // 조건이 첨부파일 포함인 메일인 경 우
						policyChk = false;
						returnStr = "EXTERNAL_ATTACH";
					}
					logger.debug("useApprMailOut policy.");
				}
				if (!policyChk) {break; }
			}
			
			// 내부메일 발송 조건 체크
			if (!"UNUSED".equalsIgnoreCase(useApprMailIn) &&  !isExceptionUser) {
				Set<String> innerDomain = new HashSet<String>(){{addAll(domainSet);}};
				innerDomain.retainAll(innerDomainSet); // 수신자도메인과 내부도메인을 교집합하여 내부 도메인 추출
				logger.debug("innerDomain={}", innerDomain);
				
				if (innerDomain.size() > 0) {
					if ("USAGE".equalsIgnoreCase(useApprMailIn)) { // 모든 메일인 경우
						policyChk = false;
						returnStr = "INNER";
					} else if ("USAGE_ATTACH".equalsIgnoreCase(useApprMailIn) && hasAttach) { // 조건이 첨부파일 포함인 메일인 경우
						policyChk = false;
						returnStr = "INNER_ATTACH";
					}
					logger.debug("useApprMailIn policy.");
				}
				if (!policyChk) {break; }
			}
			
			policyChk = false;
		} while (policyChk); // 1번만 도는 while
		
		logger.debug("checkApprPolicy ended. returnStr={}", returnStr);
		return returnStr;
	}

	/**
	 * 승인메일 :
	 * 발송 승인자 지정 페이지
	 */
	@RequestMapping(value="/ezEmail/appr/approverSettingPopUp.do", method = RequestMethod.GET)
	public String apprApproverSettingPopUp(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("apprApproverSettingPopUp started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		String deptId = userInfo.getDeptID();
		String lang = userInfo.getPrimary();
		int tenantId = userInfo.getTenantId();
		logger.debug("userId={}, companyId={}, lang={}, tenantId={}", userId, companyId, lang, tenantId);

		String shareId = StringUtils.defaultIfBlank(request.getParameter("shareId"), "");
		
		// 부서내 승인자 리스트
		List<OrganUserVO> approverList = ezEmailService.getApproverSearchList(tenantId, companyId, lang, "deptId", deptId);

		String approverAccount = ""; // 승인자 아이디
		String approverName = ""; // 승인자 이름
		int approverCount = approverList.size(); // 부서내 승인자 개수

		if (approverList.size() > 0) {
			// 승인자는 부서내 1명만 존재할 때 승인자로 지정할 수 있음. approverAccount, name 값은 프론트단에서 1명일 때에만 사용함
			approverAccount = approverList.get(0).getCn();
			approverName = approverList.get(0).getDisplayName();
		}

		model.addAttribute("userId", userId);
		model.addAttribute("shareId", shareId);
		model.addAttribute("companyId", companyId);
		model.addAttribute("approverAccount", approverAccount);
		model.addAttribute("approverName", approverName);
		model.addAttribute("approverCount", approverCount);

		logger.debug("apprApproverSettingPopUp ended.");
		return "ezEmail/apprApproverSettingPopUp";
	}

	@PostMapping("/ezEmail/convertAttachNormalToBig.do")
	@ResponseBody
	public Result convertAttachNormalToBig(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> requestBody, HttpServletRequest request) throws Exception {
		try {
			LoginVO user = commonUtil.userInfo(loginCookie);
			int tenantId = user.getTenantId();
			Long mailUid = Optional.ofNullable(requestBody.get("mailUid")).map(Object::toString).filter(StringUtils::isNotBlank).map(Long::parseLong).orElse(null);
			String statusUid = (String) requestBody.get("statusUid");
			String itemUid = (String) requestBody.get("itemUid");
			String shareId = (String) requestBody.get("shareId");
			String fileName = (String) requestBody.get("fileName");
			Integer fileIndex = Optional.ofNullable(requestBody.get("fileIndex")).map(Object::toString).filter(StringUtils::isNotBlank).map(Integer::parseInt).orElse(null);
			String previousOriginAttachXml = (String) requestBody.get("previousOriginAttachXml");

			String domainName = ezCommonService.getTenantConfig("DomainName", user.getTenantId());
			String userEmail = user.getId() + "@" + domainName;
			String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", user.getTenantId());

			if ("YES".equalsIgnoreCase(useSharedMailbox)) {
				logger.debug("shareId={}", shareId);

				if (StringUtils.isNotBlank(shareId)) {
					if (!ezEmailService.checkUserShareId(user.getId(), shareId, user.getTenantId())) {
						logger.debug("the user cannot access the shareId.");
						logger.debug("convertAttachType ended.");

						return Result.failure(2, "the user cannot access the shareId");
					}

					userEmail = shareId + "@" + domainName;
				}
			}

			logger.debug("userId={}, userEmail={}", user.getId(), userEmail);

			String password = commonUtil.getUserIdAndPassword(loginCookie).get(1);
			SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"), userEmail, password);

			try (IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, user.getLocale(), ezEmailUtil);
				 Folder folder = ia.getFolder(ezEmailUtil.getDraftsFolderId(user.getLocale()))
			) {
				if (folder == null) {
					logger.error("IMAP Folder is null");
					return Result.failure(3, "IMAP Folder is null");
				}

				folder.open(Folder.READ_WRITE);
				Message oldMessage = mailUid == null ? null : ((IMAPFolder) folder).getMessageByUID(mailUid);

				String uploadMailDir = commonUtil.getUploadPath("upload_mail.ROOT", tenantId);
				String largeFileDir = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useSeparatedLargeFileFolder", tenantId))
						? "largeFile"
						: "";

				MimeMessage newMessage = sa.createMimeMessage();
				Multipart multipart = new MimeMultipart();

				Multipart mp = (Multipart) oldMessage.getContent();
				int count = mp.getCount();
				BodyPart p = null, targetAttachPart = null;
				int nonAttachCount = 0;

				// 첨부파일 파트 이전에 존재하는 파트들의 갯수를 구한다.
				// 이 로직이 제대로 동작하려면 첨부파일들이 모두 메시지의 뒷부분에 연속으로 위치하여야 한다.
				for (int i = 0; i < count; i++) {
					p = mp.getBodyPart(i);

					if (p.getDisposition() == null) {
						nonAttachCount++;
					} else {
						break;
					}
				}

				for (int i = 0; i < count; i++) {
					p = mp.getBodyPart(i);

					// 파일의 index가 nonAttachCount 만큼 뒤로 밀렸으므로 i - nonAttachCount과 비교하여 파일을 삭제한다.
					if (p.getDisposition() != null
							&& p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)) {
						if (i - nonAttachCount == fileIndex) {
							targetAttachPart = p;
						} else {
							multipart.addBodyPart(p);
						}
					}
				}

				@SuppressWarnings("unchecked")
				Enumeration<Header> e = oldMessage.getAllHeaders();
				while (e.hasMoreElements()) {
					Header header = e.nextElement();
					newMessage.setHeader(header.getName(), header.getValue());
				}

				Long newMessageUid;

				if (multipart.getCount() == 0) {
					newMessageUid = null;
				} else {
					newMessage.setContent(multipart);
					newMessage.setFlag(Flags.Flag.SEEN, true);
					AppendUID[] uids = ((IMAPFolder) folder).appendUIDMessages(new Message[]{newMessage});
					newMessageUid = uids[0].uid;
				}

				oldMessage.setFlag(Flags.Flag.DELETED, true);

				String statusXmlFileName = commonUtil.detectPathTraversal(statusUid);
				Path xmlFile = Paths.get(commonUtil.getRealPath(request), commonUtil.getUploadPath("upload_mail.ROOT", tenantId), "templist", statusXmlFileName + ".txt");
				XPath xPath = XPathFactory.newInstance().newXPath();
				Document xmlDom = null;
				Node itemNode = null;

				if (Files.exists(xmlFile)) {
					StringBuilder strXml = new StringBuilder();
					try (InputStreamReader isr = new InputStreamReader(Files.newInputStream(xmlFile))) {
						int read = 0;
						while ((read = isr.read()) != -1) {
							strXml.append((char) read);
						}
					}

					String oldXmlContent = strXml.toString();
					xmlDom = commonUtil.convertStringToDocument(oldXmlContent);
					NodeList nodeList = (NodeList) xPath.evaluate("//NODE[PUPLOADSN]", xmlDom, XPathConstants.NODESET);

					for (int i = 0; i < nodeList.getLength(); i++) {
						if (nodeList.item(i).getTextContent().equals(itemUid)) {
							itemNode = nodeList.item(i);
							break;
						}
					}
				}

				if (itemNode == null) {
					// XML에 없는 경우 itemUid를 새로 부여
					itemUid = UUID.randomUUID() + fileName.substring(fileName.lastIndexOf('.'));
				}

				String bigDateDir = EgovDateUtil.getToday("");

				Path largeFilePath = Paths.get(commonUtil.getRealPath(request), uploadMailDir, largeFileDir, bigDateDir, itemUid);
				Path largeNameFilePath = largeFilePath.resolveSibling(itemUid + "__.txt");

				Files.createDirectories(largeFilePath.getParent());
				Files.copy(targetAttachPart.getInputStream(), largeFilePath);

				try (FileOutputStream fos = new FileOutputStream(largeNameFilePath.toFile())) {
					String base64EncodedName = Base64.encodeBase64String(commonUtil.normalizeFileName(fileName).getBytes(StandardCharsets.UTF_8));
					fos.write(base64EncodedName.getBytes(StandardCharsets.ISO_8859_1));
				}

				long fileSize = Files.size(largeFilePath);

				if (itemNode == null) {
					Node nodesElem;

					// xml이 없는 경우 새로 생성
					if (xmlDom == null) {
						xmlDom = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
						nodesElem = xmlDom.appendChild(xmlDom.createElement("ROOT"))
								.appendChild(xmlDom.createElement("NODES"));
					} else {
						nodesElem = xmlDom.getElementsByTagName("NODES").item(0);
					}

					// NODE 태그 구성
					Node nodeElem = nodesElem.appendChild(xmlDom.createElement("NODE"));
					nodeElem.appendChild(xmlDom.createElement("PUPLOADSN"))
							.appendChild(xmlDom.createCDATASection(itemUid));
					nodeElem.appendChild(xmlDom.createElement("RESULTUPLOADA"))
							.appendChild(xmlDom.createCDATASection("true"));
					nodeElem.appendChild(xmlDom.createElement("PFILENAME"))
							.appendChild(xmlDom.createCDATASection(fileName));
					nodeElem.appendChild(xmlDom.createElement("FILESIZE"))
							.appendChild(xmlDom.createCDATASection(String.valueOf(fileSize)));
					nodeElem.appendChild(xmlDom.createElement("FILELOCATION"))
							.appendChild(xmlDom.createCDATASection(bigDateDir + "|!|" + itemUid));
					nodeElem.appendChild(xmlDom.createElement("PBIGFILEUPLOAD"))
							.appendChild(xmlDom.createCDATASection("Y"));
				} else {
					((Node) xPath.evaluate("PBIGFILEUPLOAD", itemNode, XPathConstants.NODE)).setTextContent("Y");
					((Node) xPath.evaluate("FILELOCATION", itemNode, XPathConstants.NODE)).setTextContent(bigDateDir + "|!|" + itemUid);
				}

				String newXmlContent = commonUtil.convertDocumentToString(xmlDom);

				try (BufferedWriter writer = Files.newBufferedWriter(xmlFile, Charset.defaultCharset(),
						StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING)) {
					writer.write(newXmlContent);
					String crlf = System.getProperty("line.separator");
					writer.write(crlf);
					writer.write(crlf);
				}

				Map<String, Object> result = new HashMap<>();
				result.put("uid", newMessageUid == null ? "" : newMessageUid);
				result.put("bigDateDir", bigDateDir);
				result.put("itemUid", itemUid);

				return Result.success(result);
			}
		} catch (Exception e) {
			logger.error("error:", e);
			return Result.failure();
		}
	}

	@PostMapping("/ezEmail/convertAttachBigToNormal.do")
	@ResponseBody
	public Result convertAttachBigToNormal(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> requestBody, HttpServletRequest request) throws Exception {
		try {
			LoginVO user = commonUtil.userInfo(loginCookie);
			int tenantId = user.getTenantId();
			Long mailUid = Optional.ofNullable(requestBody.get("mailUid")).map(Object::toString).filter(StringUtils::isNotBlank).map(Long::parseLong).orElse(null);
			String statusUid = (String) requestBody.get("statusUid");
			String itemUid = (String) requestBody.get("itemUid");
			String shareId = (String) requestBody.get("shareId");

			String statusXmlFileName = commonUtil.detectPathTraversal(statusUid);
			Path xmlFile = Paths.get(commonUtil.getRealPath(request), commonUtil.getUploadPath("upload_mail.ROOT", tenantId), "templist", statusXmlFileName + ".txt");
			Document xmlDom;

			if (!Files.exists(xmlFile)) {
				logger.error("does not exist xml={}", xmlFile);
				return Result.failure(1, "does not exist xml=" + xmlFile);
			}

			StringBuilder strXml = new StringBuilder();
			try (InputStreamReader isr = new InputStreamReader(Files.newInputStream(xmlFile))) {
				int read = 0;
				while ((read = isr.read()) != -1) {
					strXml.append((char) read);
				}
			}

			String oldXmlContent = strXml.toString();
			xmlDom = commonUtil.convertStringToDocument(oldXmlContent);

			XPath xPath = XPathFactory.newInstance().newXPath();
			Node itemNode = (Node) xPath.evaluate("//NODE[PUPLOADSN = '" + itemUid + "']", xmlDom, XPathConstants.NODE);

			if (itemNode == null) {
				throw new IllegalArgumentException("No attachment node matches the item uid: " + itemUid);
			}

			Node bigFlagNode = (Node) xPath.evaluate("PBIGFILEUPLOAD", itemNode, XPathConstants.NODE);

			if ("N".equalsIgnoreCase(bigFlagNode.getTextContent())) {
				logger.warn("Does not match big flag. is already a large or normal attachment.");
				return Result.failure(1, "Does not match big flag");
			}

			String domainName = ezCommonService.getTenantConfig("DomainName", user.getTenantId());
			String userEmail = user.getId() + "@" + domainName;
			String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", user.getTenantId());

			if ("YES".equalsIgnoreCase(useSharedMailbox)) {
				logger.debug("shareId={}", shareId);

				if (StringUtils.isNotBlank(shareId)) {
					if (!ezEmailService.checkUserShareId(user.getId(), shareId, user.getTenantId())) {
						logger.debug("the user cannot access the shareId.");
						logger.debug("convertAttachType ended.");

						return Result.failure(2, "the user cannot access the shareId");
					}

					userEmail = shareId + "@" + domainName;
				}
			}

			logger.debug("userId={}, userEmail={}", user.getId(), userEmail);

			String password = commonUtil.getUserIdAndPassword(loginCookie).get(1);
			SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"), userEmail, password);
			Long newMessageUid = null;
			String fileName = null;

			try (IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, user.getLocale(), ezEmailUtil);
				 Folder folder = ia.getFolder(ezEmailUtil.getDraftsFolderId(user.getLocale()))
			) {
				if (folder == null) {
					logger.error("IMAP Folder is null");
					return Result.failure(3, "IMAP Folder is null");
				}

				folder.open(Folder.READ_WRITE);
				Message oldMessage = mailUid == null ? null : ((IMAPFolder) folder).getMessageByUID(mailUid);

				fileName = (String) xPath.evaluate("PFILENAME", itemNode, XPathConstants.STRING);
				Node fileLocationNode = (Node) xPath.evaluate("FILELOCATION", itemNode, XPathConstants.NODE);
				String uploadMailDir = commonUtil.getUploadPath("upload_mail.ROOT", tenantId);
				String largeFileDir = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useSeparatedLargeFileFolder", tenantId))
						? "largeFile"
						: "";

				String[] fileLocations = fileLocationNode.getTextContent().split("\\|!\\|");
				String dateDir = fileLocations[0];
				String fileUidName = fileLocations[1];

				Path largeFilePath = Paths.get(commonUtil.getRealPath(request), uploadMailDir, largeFileDir, dateDir, fileUidName);

				if (!Files.exists(largeFilePath)) {
					logger.error("Not found large file: {}", largeFilePath);
					return Result.failure(5, "Not found large file: " + largeFilePath);
				}

				MimeMessage newMessage = sa.createMimeMessage();
				Multipart multipart = new MimeMultipart();

				if (oldMessage != null) {
					// 기존 메시지가 Multipart인 경우 처리
					if (oldMessage.getContent() instanceof Multipart) {
						Multipart mp = (Multipart) oldMessage.getContent();
						int count = mp.getCount();
						BodyPart p = null;

						// 임시 보관함에 있는 메시지가 multipart/related일 때는 새롭게 related 파트로 구성한 다음
						// 새 메시지의 서브 파트로 추가한다.
						if (oldMessage.isMimeType("multipart/related")) {
							logger.debug("oldMessage is multipart/related");

							Multipart relatedPart = new MimeMultipart("related");

							for (int i = 0; i < count; i++) {
								p = mp.getBodyPart(i);

								// 코린도에서 수신한 메일 중 multipart/related 안에 첨부 파일이 있는 경우가 있어
								// 해당 첨부 파일을 multipart/mixed 파트로 옮기도록 한다.
								if (p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)) {
									multipart.addBodyPart(p);
								} else {
									relatedPart.addBodyPart(p);
								}
							}

							// relatedPart에 속한 파트가 하나도 없는 경우 삽입하면 메시지가
							// 정상적으로 생성되지 않는다.
							if (relatedPart.getCount() > 0) {
								MimeBodyPart wrap = new MimeBodyPart();
								wrap.setContent(relatedPart);
								multipart.addBodyPart(wrap, 0);
							}
						} else if (oldMessage.isMimeType("multipart/alternative")) {
							logger.debug("oldMessage is multipart/alternative");

							Multipart alternativePart = new MimeMultipart("alternative");

							for (int i = 0; i < count; i++) {
								p = mp.getBodyPart(i);
								alternativePart.addBodyPart(p);
							}

							MimeBodyPart wrap = new MimeBodyPart();
							wrap.setContent(alternativePart);
							multipart.addBodyPart(wrap, 0);
						} else {
							for (int i = 0; i < count; i++) {
								p = mp.getBodyPart(i);
								multipart.addBodyPart(p);
							}
						}
					}

					// 기존 메시지의 모든 헤더를 적용한다.
					@SuppressWarnings("unchecked")
					Enumeration<Header> headers = oldMessage.getAllHeaders();

					while (headers.hasMoreElements()) {
						Header header = headers.nextElement();
						newMessage.setHeader(header.getName(), header.getValue());
					}

					// 기존 메시지를 제거한다.
					oldMessage.setFlag(Flags.Flag.DELETED, true);
				}

				BodyPart messageBodyPart = new MimeBodyPart();
				FileDataSource source = new FileDataSource(largeFilePath.toFile());
				messageBodyPart.setDataHandler(new DataHandler(source));

				String nfcFilename = commonUtil.normalizeFileName(fileName);
				String encodedFileName = MimeUtility.fold(0, MimeUtility.encodeText(nfcFilename, "UTF-8", "B"));
				messageBodyPart.setHeader("Content-Disposition", "attachment;\r\n filename=\"" + encodedFileName + "\"");

				String contentType = null;

				// 첨부파일의 Content-Type을 구한다.
				try (BufferedInputStream bis = new BufferedInputStream(Files.newInputStream(largeFilePath))) {
					contentType = URLConnection.guessContentTypeFromStream(bis);
					if (contentType == null) {
						contentType = Files.probeContentType(largeFilePath);
					} else {
						String path = largeFilePath.toString();
						if (path.lastIndexOf(".") > 0 && path.substring(path.lastIndexOf(".")).equalsIgnoreCase(".eml")) {
							contentType = "message/rfc822";
						}
					}

					if (contentType == null) {
						// 첨부파일 Content-Type의 디폴트는 application/octet-stream로 설정한다.
						contentType = "application/octet-stream";
					}
				} catch (Exception ex) {
					logger.error("get Content-Type error:", ex);
					return Result.failure(5, "get Content-Type error");
				}

				messageBodyPart.setHeader("Content-Type", contentType);
				// Multipart에 첨부파일 Part를 삽입한다.
				multipart.addBodyPart(messageBodyPart);
				newMessage.setContent(multipart);
				newMessage.setFlag(Flags.Flag.SEEN, true);
				AppendUID[] uids = ((IMAPFolder) folder).appendUIDMessages(new Message[]{newMessage});
				newMessageUid = uids[0].uid;

				Path largeNameFilePath = largeFilePath.resolveSibling(fileUidName + "__.txt");
				Files.delete(largeNameFilePath);
				Files.delete(largeFilePath);

				bigFlagNode.setTextContent("N");
				fileLocationNode.setTextContent(fileUidName);
			}

			String newXmlContent = commonUtil.convertDocumentToString(xmlDom);

			try (BufferedWriter writer = Files.newBufferedWriter(xmlFile, Charset.defaultCharset(), StandardOpenOption.TRUNCATE_EXISTING)) {
				writer.write(newXmlContent);
				String crlf = System.getProperty("line.separator");
				writer.write(crlf);
				writer.write(crlf);
			}

			Map<String, Object> result = new HashMap<>();
			result.put("uid", newMessageUid);
			result.put("fileName", fileName);

			return Result.success(result);
		} catch (Exception e) {
			logger.error("error:", e);
			return Result.failure();
		}
	}
}
