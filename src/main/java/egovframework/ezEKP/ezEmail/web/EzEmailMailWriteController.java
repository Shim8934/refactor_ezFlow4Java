package egovframework.ezEKP.ezEmail.web;

import java.io.File;
import java.net.URLDecoder;
import java.util.List;
import java.util.Properties;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.mail.Address;
import javax.mail.Message.RecipientType;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;

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
public class EzEmailMailWriteController {

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	/**
	 * 메일 쓰기화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailWrite.do")
	public String mailWrite(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception{
		String to = "";
		String cc = "";
		String bcc = "";
		String from = "";
		String body = "";
		String subject = "";
		String importance = "1";
		String postType = "0";
		String url = "";
		String attach = "&nbsp;";
		String cmd = "";
		String unread = "";
		String boardID = "";
		String itemID = "";
		String docHref = "";
		String docID = "";
		String docImagCnt = "";
		String docTarget = "";
		String sendFrom = "";
		String retransType = "";
		String useMultiLangMail = "";
		String displayNamePrintable = "";
		String charsetCheck = "1";
		String userInfoApprovalG = "";
		String userLang = "1";
		String userPrimary = "1";
		String reSendFlag = "N";
		String mailAttachLimit = "20";
		String bigSizeMailAttachLimit = "20";
		String totBigSizeMailAttachLimit = "20";
		String bigSizeMailAttachDelDay = "20";
		String userTimeset = "";
		String cmdOwn = "";
		String urlOwn = "";
		String mailSign1 = "";
		String mailSign2 = "";
		String mailSign3 = "";
		String mailSignSel = "";
		String bodyValue = "";
		String fileUploadType = "";
		String folderPath = "";
		String tempBody = "";
		String newWindowId = "";
		int individualMailUser = 0;
		String pSecurity = "1";
		String folderDate = "";
		String stateName = null;
		String pBigAttachDownloadDay = "";
		String pBigAttachDownloadPeriod = "";
		String pAutoSaveTime = "";
		String pAttachWarning = "";
		String mailSendObject = "";
		String mailInnerDomain = "";
		String inMailColor = "";
		String outMailColor = "";
		String useEditor = "";
		
		String userId = "";
		List<String> userIdnPw = commonUtil.getUserIdAndPassword(loginCookie);
		if(userIdnPw !=null && userIdnPw.get(0) != null){
			userId = userIdnPw.get(0);
		}
		OrganUserVO userInfo = ezOrganAdminService.getUserInfo(userId, "1"); //추후 lang(두번째 파라미터) 수정
		userInfo.setMail(userInfo.getCn()+"@"+config.getProperty("config.DomainName"));
		useEditor = config.getProperty("config.EDITOR");
		System.out.println("getRequestURI : "+request.getRequestURI());
		System.out.println("getRequestURL : "+request.getRequestURL().substring(0, request.getRequestURI().length()));

		//hostURL = request.getRequestURL().substring(0, request.getRequestURI().length()) + "/ezEmail/"; - 지금은 필요없는데 나중에 필요할지도?
		folderDate = EgovDateUtil.getToday();
		stateName = UUID.randomUUID().toString();

		if(config.getProperty("config.MailInnerDomain") != null){
			mailInnerDomain = config.getProperty("config.MailInnerDomain").trim();
		}
		
		if(config.getProperty("config.INDIVIDUALMAILUSER") != null && !config.getProperty("config.INDIVIDUALMAILUSER").trim().equals("")){
			individualMailUser = Integer.parseInt(config.getProperty("config.INDIVIDUALMAILUSER"));
		}

		String tempStr = "";
		if (request.getParameter("cmd") != null)
			tempStr = request.getParameter("cmd").toUpperCase().trim();
		else
			tempStr = "NEW";

		if (!(tempStr.equals("") || tempStr.equals("REPLY") || tempStr.equals("REPLYALL") || tempStr.equals("FORWARD") || tempStr.equals("READ") 
				|| tempStr.equals("EDIT") || tempStr.equals("NEW") || tempStr.equals("BOARD") || tempStr.equals("COMMUNITY") || tempStr.equals("DOCSEND")
				|| tempStr.equals("DOCSENDDOC") || tempStr.equals("ACCESSNO") || tempStr.equals("REPORT") || tempStr.equals("RESEND")))
		{
			return "정상적인 값을 전달 받지 못했습니다.";
		}

		if (request.getParameter("msgto") != null)
			tempStr = request.getParameter("msgto").toUpperCase().trim().replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
		else
			tempStr = "";

		if (tempStr.indexOf("<") >= 0 && tempStr.indexOf(">") >= 0 && tempStr.indexOf("SCRIPT") >= 0)
		{
			return "정상적인 값을 전달 받지 못했습니다.";
		}


//        //DB에서 importance color 가져오기
//        XmlDocument ColorXml = new XmlDocument();
//        ColorXml = GetXmlReaderString(GetImportanceColor());
//
//        if (ColorXml.GetElementsByTagName("DATA").Count > 0)
//        {
//            _inMailColor = ColorXml.GetElementsByTagName("INMAILCOLOR").Item(0).InnerText.Trim();
//            _outMailColor = ColorXml.GetElementsByTagName("OUTMAILCOLOR").Item(0).InnerText.Trim();
//        }
//        else
//        {
		inMailColor = "black";
		outMailColor = "black";
//        }


		userPrimary = config.getProperty("config.primary");
		userLang = "1"; // 추후 수정(DB에서 가져와야함.)
		//userTimeset = userInfo.getOffset();
		userInfoApprovalG = config.getProperty("config.UserInfo_ApprovalG");
		mailAttachLimit = config.getProperty("config.MailAttachLimit");
		bigSizeMailAttachLimit = config.getProperty("config.BigSizeMailAttachLimit");
		totBigSizeMailAttachLimit = config.getProperty("config.totBigSizeMailAttachLimit");
		int day = 20;
		if(config.getProperty("config.BigSizeMailAttachDelDay") != null && !config.getProperty("config.BigSizeMailAttachDelDay").trim().equals("")){
			day = Integer.parseInt(config.getProperty("config.BigSizeMailAttachDelDay"));
		}
		bigSizeMailAttachDelDay = EgovDateUtil.addDay(EgovDateUtil.getToday(), day);
		bigSizeMailAttachDelDay = EgovDateUtil.formatDate(bigSizeMailAttachDelDay, "-");

		displayNamePrintable = userInfo.getDisplayName();

		if(request.getParameter("sendfrom") != null){
			sendFrom = request.getParameter("sendfrom");
		}
		useMultiLangMail = "1";
		if(request.getParameter("cmd") != null){
			cmdOwn = request.getParameter("cmd");
		}
		if(request.getParameter("url") != null){
			urlOwn = URLDecoder.decode(request.getParameter("url").replaceAll(" ", "+"),"UTF-8"); // url decode 해야하나?
		}
		if(request.getParameter("cmd") != null){
			cmd = request.getParameter("cmd");
		}
		
		from = "\""+userInfo.getDisplayName()+"\" <"+userInfo.getMail()+">";

//		OracleCommand comd = new OracleCommand("EZSP_GETMAILGENERAL");
//		comd.CommandType = CommandType.StoredProcedure;
//		comd.Parameters.Add("v_PUSERID", OracleType.VarChar, 20).Value = userinfo.UserID;
//		comd.Parameters.Add("cv_1", OracleType.Cursor).Direction = ParameterDirection.Output;
//		string infoXML = GetQueryResultSP(ref comd, false);
//		comd.Dispose();
//		comd = null;
//
//		XmlDocument xmlDoc = new XmlDocument();
//		xmlDoc = GetXmlReaderString(infoXML);
//		if (xmlDoc.InnerText == "")
		pAutoSaveTime = "0";
//		else
//			pAutoSaveTime = xmlDoc.SelectSingleNode("DATA/KEEPDELETELENGTH").InnerText.Trim();

//		string _PmailSenderNM = xmlDoc.SelectNodes("DATA/MAILSENDERNM").Count > 0 ?
//				string.IsNullOrEmpty(xmlDoc.SelectSingleNode("DATA/MAILSENDERNM").InnerText) ?
//						userinfo.DisplayName2 : xmlDoc.SelectSingleNode("DATA/MAILSENDERNM").InnerText : userinfo.DisplayName2;
//		string[] DivStrstr = new string[] { "|!-@-!|" };
//		string[] SenderList = _PmailSenderNM.Split(DivStrstr, StringSplitOptions.RemoveEmptyEntries);
		mailSendObject += "<option value='NONE'>" + egovMessageSource.getMessage("ezEmail.t99000032") + "</option>";
//		foreach (string pSenderNM in SenderList)
//		{
//			mailSendObject += "<option value='" + pSenderNM + "'>" + pSenderNM + "</option>";
//		}
		
		String _cmd = "";
		if(request.getParameter("cmd") != null){
			_cmd = request.getParameter("cmd");
		}
		String msgto = "";
		if (request.getParameter("msgto") != null){
			msgto = request.getParameter("msgto").toUpperCase().trim().replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
		}
        String _attach = "";
        if(request.getParameter("attach") != null){
        	_attach = request.getParameter("attach");
		}
        String includeContent = "";
        if(request.getParameter("include") != null){
        	includeContent = request.getParameter("include");
		}
        String _url = "";
        if(request.getParameter("iptURL") != null){
        	_url = request.getParameter("iptURL");
		}
        if(request.getParameter("URL") != null){
        	_url = request.getParameter("URL");
        }
        
        if (_url.equals("") && _cmd.equals("NEW"))
        {
        	to = msgto;
            String resultXML = "";
//            resultXML = GetCommentDB(userinfo.UserID, "A");
//            XmlDocument xmlDoc = new XmlDocument();
//            xmlDoc = GetXmlReaderString(ResultXML);
//            if (xmlDoc.SelectSingleNode("DATA").ChildNodes.Count > 0)
//            {
//                mailSign1 = HttpUtility.HtmlDecode(xmlDoc.SelectSingleNode("DATA/ROW/CONTENT1").InnerXml);
//                mailSign2 = HttpUtility.HtmlDecode(xmlDoc.SelectSingleNode("DATA/ROW/CONTENT2").InnerXml);
//                mailSign3 = HttpUtility.HtmlDecode(xmlDoc.SelectSingleNode("DATA/ROW/CONTENT3").InnerXml);
//                mailSignSel = xmlDoc.SelectSingleNode("DATA/ROW/USEFLAG").InnerText;
//
//                mailSign1 = "<DIV style='font-size:12px;'><br /><br /><DIV id='MailSign'> " + mailSign1 + "<br /></DIV></DIV>";
//                mailSign2 = "<DIV style='font-size:12px;'><br /><br /><DIV id='MailSign'> " + mailSign2 + "<br /></DIV></DIV>";
//                mailSign3 = "<DIV style='font-size:12px;'><br /><br /><DIV id='MailSign'> " + mailSign3 + "<br /></DIV></DIV>";
//
//                switch (mailSignSel)
//                {
//                    case "1": resultXML = mailSign1; break;
//                    case "2": resultXML = mailSign2; break;
//                    case "3": resultXML = mailSign3; break;
//                    default: resultXML = ""; mailSignSel = "0"; break;
//                }
//            }
//            else
//            {
                mailSignSel = "0";
                resultXML = "";
//            }
            
            body = EgovStringUtil.getSpclStrCnvr("<DIV style='font-size:12px;'><br><br><DIV id='MailSign'>" + resultXML + "</div><br></DIV>");
        }
//        else if (_url.equals("") && (_cmd.equals("board") || _cmd.equals("Community")))
//        {
//            mailMessageBoard();
//        }
//        else if (_url.equals("") && _cmd.equals("docsend"))
//        {
//            mailMessageDoc();
//        }
//        else if (_url.equals("") && _cmd.equals("AccessNO"))
//        {
//            mailMessageNone();
//        }
//        else if (_url.equals("") && _cmd.equals("report"))
//        {
//            mailMessageReport();
//        }
//        else if (!_url.equals(""))
//        {
//            ExchangeService esb = apiesb.getexchangeservice(userinfo.UserID);
//            ExtendedPropertyDefinition pagehtml = new ExtendedPropertyDefinition(0x1013, MapiPropertyType.Binary);
//            ExtendedPropertyDefinition codepagehtml = new ExtendedPropertyDefinition(0x3FDE, MapiPropertyType.Integer);
//            PropertySet properts = new PropertySet(BasePropertySet.FirstClassProperties, pagehtml, codepagehtml);
//            EmailMessage orgmesg = EmailMessage.Bind(esb, new ItemId(url), properts);
//            if (orgmesg.IsDraft)
//            {
//                //임시보관함에 있는 메일일경우 처리
//                bool isDraft = false;
//                Folder folderid = Folder.Bind(esb, WellKnownFolderName.Drafts);
//                if (orgmesg.ParentFolderId.UniqueId == folderid.Id.UniqueId)
//                {
//                    folderpath = "Draft";
//                    isDraft = true;
//                }
//                else
//                {
//                    Folder draft = Folder.Bind(esb, WellKnownFolderName.Drafts);
//                    if (draft.Id.UniqueId == orgmesg.ParentFolderId.UniqueId)
//                    {
//                        folderpath = "Draft";
//                        isDraft = true;
//                    }
//                    if (!isDraft)
//                    {
//                        FindFoldersResults findfolders = esb.FindFolders(WellKnownFolderName.Drafts, new FolderView(100));
//                        foreach (Folder folder in findfolders)
//                        {
//                            if (folder.Id.UniqueId == orgmesg.ParentFolderId.UniqueId)
//                            {
//                                folderpath = "Draft";
//                                isDraft = true;
//                                break;
//                            }
//                        }
//                    }
//                }
//                if (!isDraft)
//                {
//                    MailMessage_Send(_cmd, _url, _attach, esb, orgmesg);
//                    return;
//                }
//            }
//            if ((_cmd == "EDIT" || _cmd == "RESEND") && msgto != "")
//            {
//                resendMail(_cmd, _url, _attach, msgto, esb, orgmesg); return;
//            }
//            if (_url != "" && _cmd == "EDIT")
//            {
//                MailMessage_Edit(_cmd, _url, _attach, esb, orgmesg); return;
//            }
//            if (_url != "")
//            {
//                MailMessage_Send(_cmd, _url, _attach, esb, orgmesg); return;
//            }
//        }
        
        int pBigAttachDownloadDaynum = 0;
        if(config.getProperty("config.BigSizeMailAttachDelDay") != null && !config.getProperty("config.BigSizeMailAttachDelDay").trim().equals("")){
        	pBigAttachDownloadDay = config.getProperty("config.BigSizeMailAttachDelDay");
        	pBigAttachDownloadDaynum = Integer.parseInt(pBigAttachDownloadDay);
        }
        
        pBigAttachDownloadPeriod = EgovDateUtil.formatDate(EgovDateUtil.getToday(), "/") + " ~ " + EgovDateUtil.formatDate(EgovDateUtil.addDay(EgovDateUtil.getToday(), pBigAttachDownloadDaynum), "/");

		if (userLang.equals("1"))
			pAttachWarning = "일반첨부파일은 총 " + mailAttachLimit + "MB까지 가능하며, 대용량첨부는 " + totBigSizeMailAttachLimit + "MB까지 가능(" + pBigAttachDownloadDay + "일후 자동삭제) ";
		else if (userLang.equals("2"))
			pAttachWarning = "Normal attachments and large attachments up to " + mailAttachLimit + "MB up to " + totBigSizeMailAttachLimit + "MB (after " + pBigAttachDownloadDay + " days automatically deleted) ";
		else if (userLang.equals("3"))
			pAttachWarning = "一般的な添付ファイルは合計" + mailAttachLimit + "MBまで可能で、大容量の添付ファイルは" + totBigSizeMailAttachLimit + "MBまで可能（" + pBigAttachDownloadDay + "日後に自動削除）";
		else if (userLang.equals("4"))
			pAttachWarning = "普通附件和大型附件" + mailAttachLimit + "MB高达" + totBigSizeMailAttachLimit + "MB（" + pBigAttachDownloadDay + " 天之后自动删除）";
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("to", to);
		model.addAttribute("cc", cc);
		model.addAttribute("bcc", bcc);
		model.addAttribute("from", from);
		model.addAttribute("body", body);
		model.addAttribute("subject", subject);
		model.addAttribute("encodedSubject", EgovStringUtil.getSpclStrCnvr(subject));
		model.addAttribute("importance", importance);
		model.addAttribute("postType", postType);
		model.addAttribute("url", url);
		model.addAttribute("attach", attach);
		model.addAttribute("cmd", cmd);
		model.addAttribute("unread", unread);
		model.addAttribute("boardID", boardID);
		model.addAttribute("itemID", itemID);
		model.addAttribute("docHref", docHref);
		model.addAttribute("docID", docID);
		model.addAttribute("docImagCnt", docImagCnt);
		model.addAttribute("docTarget", docTarget);
		model.addAttribute("sendFrom", sendFrom);
		model.addAttribute("retransType", retransType);
		model.addAttribute("useMultiLangMail", useMultiLangMail);
		model.addAttribute("displayNamePrintable", displayNamePrintable);
		model.addAttribute("charsetCheck", charsetCheck);
		model.addAttribute("userInfoApprovalG", userInfoApprovalG);
		model.addAttribute("userLang", userLang);
		model.addAttribute("userPrimary", userPrimary);
		model.addAttribute("reSendFlag", reSendFlag);
		model.addAttribute("mailAttachLimit", mailAttachLimit);
		model.addAttribute("bigSizeMailAttachLimit", bigSizeMailAttachLimit);
		model.addAttribute("totBigSizeMailAttachLimit", totBigSizeMailAttachLimit);
		model.addAttribute("bigSizeMailAttachDelDay", bigSizeMailAttachDelDay);
		model.addAttribute("userTimeset", userTimeset);
		model.addAttribute("cmdOwn", cmdOwn);
		model.addAttribute("urlOwn", urlOwn);
		model.addAttribute("mailSign1", mailSign1);
		model.addAttribute("mailSign2", mailSign2);
		model.addAttribute("mailSign3", mailSign3);
		model.addAttribute("mailSignSel", mailSignSel);
		model.addAttribute("bodyValue", bodyValue);
		model.addAttribute("fileUploadType", fileUploadType);
		model.addAttribute("folderPath", folderPath);
		model.addAttribute("tempBody", tempBody);
		model.addAttribute("newWindowId", newWindowId);
		model.addAttribute("individualMailUser", individualMailUser); //int형
		model.addAttribute("pSecurity", pSecurity);
		model.addAttribute("folderDate", folderDate);
		model.addAttribute("stateName", stateName);
		model.addAttribute("pBigAttachDownloadDay", pBigAttachDownloadDay);
		model.addAttribute("pBigAttachDownloadPeriod", pBigAttachDownloadPeriod);
		model.addAttribute("pAutoSaveTime", pAutoSaveTime);
		model.addAttribute("pAttachWarning", pAttachWarning);
		model.addAttribute("mailSendObject", mailSendObject);
		model.addAttribute("mailInnerDomain", mailInnerDomain);
		model.addAttribute("inMailColor", inMailColor);
		model.addAttribute("outMailColor", outMailColor);
		model.addAttribute("useEditor", useEditor);
		
		return "ezEmail/mailWrite";
	}

	/**
	 * 메일 CK에디터 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailCKEditor.do")
	public String mailCKEditor(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "ezEmail/mailCKEditor";
	}

	/**
	 * 메일 파일첨부 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/dragAndDrop.do")
	public String dragAndDropIframe(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "ezEmail/mailDragAndDrop";
	}

	/**
	 * 메일 CK에디터 첨부파일 업로드 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailInterUploadXCK.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String mailInterUploadXCK(MultipartHttpServletRequest request) throws Exception{
		String strXML = "";
		String strXML2 = "";
		String folderDate = "";
		String tempFolderName = "";
		String xmlList = "";
		String endDay = "";
		String isBigYN = "N";
		List<MultipartFile> multiFile = request.getFiles("fileToUpload"); 
		int cnt = 0;
		if(request.getParameter("cnt") != null && !request.getParameter("cnt").equals("")){
			cnt = Integer.parseInt(request.getParameter("cnt"));
		}
		String realPath = request.getServletContext().getRealPath("");
		String[] pFileName = new String[cnt];
		Long[] fileSize = new Long[cnt];
		String[] fileLocation = new String[cnt];
		String[] resultUpload = new String[cnt];
		String[] newId = new String[cnt];
		String[] sGUID = new String[cnt];
		String[] pUploadSN = new String[cnt];
		String fileName = "";
		String pBigFileUpload = "";
		String[] sFileTitle = new String[cnt];
		String[] sExt = new String[cnt];
		String pDirTempPath = "";
		long bigMaxSize = 0;
		long changeSize = 0;

		if(request.getParameter("STATUS") != null && !request.getParameter("STATUS").equals("")){
			tempFolderName = request.getParameter("STATUS");
		} else{
			return "NODATA";
		}

		isBigYN = request.getParameter("isbigyn");
		String useExtension = config.getProperty("config.USE_FileExtension");

		if (StringUtils.isNotEmpty(multiFile.get(0).getOriginalFilename()) || StringUtils.isNotBlank(multiFile.get(0).getOriginalFilename())){
			boolean isEmpty = false;
			for (int i=0; i<cnt; i++){
				String _pFileName = multiFile.get(i).getOriginalFilename();
				if (_pFileName.indexOf(File.separator) > 0){
					_pFileName = _pFileName.split(File.separator)[_pFileName.split(File.separator).length - 1];
				}
				pFileName[i] = _pFileName;
				sFileTitle[i] = pFileName[i].substring(0, pFileName[i].lastIndexOf("."));
				sExt[i] = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
				if (multiFile.get(i).getSize() == 0)
					isEmpty = true;
			}
			if (isEmpty)
			{
				return "OVERFLOW";
			}
		}

		for(int i=0; i<cnt; i++){
			sGUID[i] = UUID.randomUUID().toString() + "." + sExt[i];
		}

		if(request.getParameter("bigmaxsize") != null){
			bigMaxSize = Long.parseLong(request.getParameter("bigmaxsize"));
		}
		if(request.getParameter("changesize") != null){
			changeSize = Long.parseLong(request.getParameter("changesize"));
		}
		if(request.getParameter("endDay") != null){
			endDay = request.getParameter("endDay");
		}

		strXML = "<ROOT><NODES>";

		String pDirPath = config.getProperty("upload_board.ROOT");
		pDirPath = realPath + pDirPath;
		folderDate = EgovDateUtil.getToday();
		pDirTempPath = pDirPath + File.separator + folderDate;
		File file = new File(pDirTempPath);
		if (!file.exists()){
			file.mkdir();
		}

		for (int i=0; i<cnt; i++){
			fileSize[i] = multiFile.get(i).getSize();
			if(fileSize[i] > changeSize || isBigYN.equals("Y")){
				File file1 = new File(pDirTempPath+sGUID[i]+"__.txt");
				pBigFileUpload = "Y";



				//todo : 수정중...
				//FileOutputStream fos = new FileOutputStream(file1);
				//fos.write(Base64.encodeBase64(pFileName[i].getBytes()));
				//fos.close();
			}
		}

		return "";
	}
	
	/**
	 * 메일 전송 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailInterSend.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailInterSend(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception{
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);
		
		// todo : MailUserVO 만들어지면 수정(jsp단도 수정)
		String userId = "";
		List<String> userIdnPw = commonUtil.getUserIdAndPassword(loginCookie);
		if(userIdnPw !=null && userIdnPw.get(0) != null){
			userId = userIdnPw.get(0);
		}
		//OrganUserVO userInfo = ezOrganAdminService.getUserInfo(userId, "1"); //추후 lang(두번째 파라미터) 수정
		//userInfo.setMail(userInfo.getCn()+"@"+config.getProperty("config.DomainName"));
		
		String pMessageID = "";
		String rtnStatus = "";
		
		// sendmail_2010변환 시작
		// request XML값 받기
		String url = "";
		String connUrl = "";
		String orgUrl = "";
		String author = "";
		String cmd = "";
		String mailCmd = "";
		String eCharSet = "";
		String eContentTransferEncoding = "";
		String eSimpleMIME = "";
		String eSimpleMIMEContentTransferEncoding = "";
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
		String pSecurityMail = "";
		String replySendTime = "";
		String replyReadTime = "";
		String isEachMail = "";
		Document xmlDoc = commonUtil.convertRequestToDocument(request);
		Element root = xmlDoc.getDocumentElement();
		
		Node tempNode = null;
		
		if(root.getElementsByTagName("URL") != null){
			tempNode = root.getElementsByTagName("URL").item(0);
			if(tempNode != null){
				url = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("ORGURL") != null){
			tempNode = root.getElementsByTagName("ORGURL").item(0);
			if(tempNode != null){
				orgUrl = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("CONNURL") != null){
			tempNode = root.getElementsByTagName("CONNURL").item(0);
			if(tempNode != null){
				connUrl = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("CMD") != null){
			tempNode = root.getElementsByTagName("CMD").item(0);
			if(tempNode != null){
				cmd = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("MAILCMD") != null){
			tempNode = root.getElementsByTagName("MAILCMD").item(0);
			if(tempNode != null){
				mailCmd = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("AUTHOR") != null){
			tempNode = root.getElementsByTagName("AUTHOR").item(0);
			if(tempNode != null){
				author = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("SUBJECT") != null){
			tempNode = root.getElementsByTagName("SUBJECT").item(0);
			if(tempNode != null){
				subject = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("TO") != null){
			tempNode = root.getElementsByTagName("TO").item(0);
			if(tempNode != null){
				to = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("CC") != null){
			tempNode = root.getElementsByTagName("CC").item(0);
			if(tempNode != null){
				cc = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("BCC") != null){
			tempNode = root.getElementsByTagName("BCC").item(0);
			if(tempNode != null){
				bcc = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("TEXTBODY") != null){
			tempNode = root.getElementsByTagName("TEXTBODY").item(0);
			if(tempNode != null){
				textBody = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("FROM") != null){
			tempNode = root.getElementsByTagName("FROM").item(0);
			if(tempNode != null){
				from = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("IMPORTANCE") != null){
			tempNode = root.getElementsByTagName("IMPORTANCE").item(0);
			if(tempNode != null){
				importance = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("SIMPLE-MIME") != null){
			tempNode = root.getElementsByTagName("SIMPLE-MIME").item(0);
			if(tempNode != null){
				simpleMime = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("DELAYSENDTIME") != null){
			tempNode = root.getElementsByTagName("DELAYSENDTIME").item(0);
			if(tempNode != null){
				delaySendTime = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("HTMLBODY") != null){
			tempNode = root.getElementsByTagName("HTMLBODY").item(0);
			if(tempNode != null){
				htmlBody = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("SECURITYMAIL") != null){
			tempNode = root.getElementsByTagName("SECURITYMAIL").item(0);
			if(tempNode != null){
				pSecurityMail = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("REPLYSENDTIME") != null){
			tempNode = root.getElementsByTagName("REPLYSENDTIME").item(0);
			if(tempNode != null){
				replySendTime = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("REPLYREADTIME") != null){
			tempNode = root.getElementsByTagName("REPLYREADTIME").item(0);
			if(tempNode != null){
				replyReadTime = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("ISEACHMAIL") != null){
			tempNode = root.getElementsByTagName("ISEACHMAIL").item(0);
			if(tempNode != null){
				isEachMail = tempNode.getTextContent();
			}
		}
		
//		// 다국어 발송 관련 변수들
//      string eCharSet = xmlDoc.GetElementsByTagName("CHARSET").Item(0).InnerText;
//      string eContentTransferEncoding = xmlDoc.GetElementsByTagName("CONTENT-TRANSFER-ENCODING").Item(0).InnerText;
//      string eSimpleMIME = xmlDoc.GetElementsByTagName("SIMPLE-MIME").Item(0).InnerText;
//      string eSimpleMIMEContentTransferEncoding = xmlDoc.GetElementsByTagName("SIMPLE-MIME-CONTENT-TRANSFER-ENCODING").Item(0).InnerText;
//      string eShowDisplayName = xmlDoc.GetElementsByTagName("SHOW-DISPLAYNAME").Item(0).InnerText;
        
//		string newwindowid = url;
//      string messageid; 
//		//messageid로 메시지 있으면 가져오고 없으면 새로운 message객체 생성.
//      EmailMessage message = apiesb.getemailmessage(esb, newwindowid, out messageid);
//		if (cmd.Equals("SAVE") && url != "")
//        {
//            bool isdraftmsg = message.IsDraft;
//            if (!isdraftmsg)
//            {
//                message = apiesb.getemailmessage(esb, "", out messageid);
//            }
//        }
		
		
//		string newwindowid = url;
//      string messageid; 
//      EmailMessage message = apiesb.getemailmessage(esb, newwindowid, out messageid);
//      if (cmd.Equals("SAVE") && url != "")
//      {
//          bool isdraftmsg = message.IsDraft;
//          if (!isdraftmsg)
//          {
//              message = apiesb.getemailmessage(esb, "", out messageid);
//          }
//      }
		
		
		SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
				id+"@"+config.getProperty("config.DomainName"), password);
		MimeMessage message = sa.createMimeMessage();
		
		
		// 메일 From,Recipient,CC,BCC
		InternetAddress internetAddress = new InternetAddress();
		String name = "";
		String address = "";
		
		String pattern = "[\"\"]?([^\"\"]+)[\"\"]? <([^<>]+)>";
		Pattern r = Pattern.compile(pattern);
		
		Matcher m = r.matcher(from);
		if (m.find()) {
			name = m.group(1);
			address = m.group(2);
			internetAddress.setPersonal(name, "UTF-8");
			internetAddress.setAddress(address);
			message.setFrom(internetAddress);
		}
		
		m = r.matcher(to);
		while (m.find()) {
			name = m.group(1);
			address = m.group(2);
			internetAddress.setPersonal(name, "UTF-8");
			internetAddress.setAddress(address);
			message.addRecipient(RecipientType.TO, internetAddress);
		}
		
		// todo : 원래의 To remove (원래의 To - 새로운 To) add (새로운 To - 원래의 To)
//		EmailAddressComparer comparer = new EmailAddressComparer();
//        IEnumerable<EmailAddress> removeemail = message.ToRecipients.Except<EmailAddress>(emailarr, comparer);
//        IEnumerable<EmailAddress> addemail = emailarr.Except<EmailAddress>(message.ToRecipients, comparer);
//
//        while (removeemail.Count<EmailAddress>() > 0)
//        {
//            message.ToRecipients.Remove(removeemail.First<EmailAddress>());
//        }
//        message.ToRecipients.AddRange(addemail);

		m = r.matcher(cc);
		while (m.find()) {
			name = m.group(1);
			address = m.group(2);
			internetAddress.setPersonal(name, "UTF-8");
			internetAddress.setAddress(address);
			message.addRecipient(RecipientType.CC, internetAddress);
		}
		
		// todo : 원래의 CC remove (원래의 CC - 새로운 CC) add (새로운 CC - 원래의 CC)
//		EmailAddressComparer comparer = new EmailAddressComparer();
//        IEnumerable<EmailAddress> removeemail = message.CcRecipients.Except<EmailAddress>(emailarr, comparer);
//        IEnumerable<EmailAddress> addemail = emailarr.Except<EmailAddress>(message.CcRecipients, comparer);
//
//        while (removeemail.Count<EmailAddress>() > 0)
//        {
//            message.CcRecipients.Remove(removeemail.First<EmailAddress>());
//        }
//        message.CcRecipients.AddRange(addemail);

		m = r.matcher(bcc);
		while (m.find()) {
			name = m.group(1);
			address = m.group(2);
			internetAddress.setPersonal(name, "UTF-8");
			internetAddress.setAddress(address);
			message.addRecipient(RecipientType.BCC, internetAddress);
		}
		
		// todo : 원래의 BCC remove (원래의 BCC - 새로운 BCC) add (새로운 BCC - 원래의 BCC)
//		EmailAddressComparer comparer = new EmailAddressComparer();
//        IEnumerable<EmailAddress> removeemail = message.BccRecipients.Except<EmailAddress>(emailarr, comparer);
//        IEnumerable<EmailAddress> addemail = emailarr.Except<EmailAddress>(message.BccRecipients, comparer);
//
//        while (removeemail.Count<EmailAddress>() > 0)
//        {
//            message.BccRecipients.Remove(removeemail.First<EmailAddress>());
//        }
//        message.BccRecipients.AddRange(addemail);
		
		
		// 메일 제목
		message.setSubject(subject, "UTF-8");
		
		// 메일 본문 및 타입
		if (simpleMime.equals("1")) {
            if (!cmd.toUpperCase().equals("SAVE")) {
                if (!delaySendTime.equals(""))
                	message.setContent(textBody, "text/plain; charset=utf-8");
                else
                	message.setContent(textBody.replaceAll("<DIV id=MailSign", "<DIV id=MailSignSent"), "text/plain; charset=utf-8");
            } else {
            	message.setContent(textBody, "text/plain; charset=utf-8");
            }
        } else {
            if (!cmd.toUpperCase().equals("SAVE")) {
                if (!delaySendTime.equals(""))
                	message.setContent(htmlBody, "text/html; charset=utf-8");
                else
                	message.setContent(htmlBody.replaceAll("<DIV id=MailSign", "<DIV id=MailSignSent"), "text/html; charset=utf-8");
            } else {
            	message.setContent(htmlBody, "text/html; charset=utf-8");
            }

        }
		
		// 보안메일
		if (pSecurityMail.equals("3")) {
			message.setHeader("Sensitivity", "company-confidential");
        }
		
		// 메일 중요도
		switch (importance) {
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
        if (replySendTime.equals("1"))
            message.setHeader("Return-Receipt-To", ((InternetAddress)message.getFrom()[0]).getAddress());
        else
            message.removeHeader("Return-Receipt-To");

        // 추적(수신확인)
        if (replyReadTime.equals("1"))
        	message.setHeader("Disposition-Notification-To", ((InternetAddress)message.getFrom()[0]).getAddress());
        else
        	message.removeHeader("Disposition-Notification-To");

        
//        // 첨부및 이미지첨부 처리
//        Dictionary<int, KeyValuePair<string, string>> images = new Dictionary<int, KeyValuePair<string, string>>();
//        XmlNodeList imagenamenodes = xmldom.SelectNodes("DATA/IMAGENAME");
//
//        if (imagenamenodes != null)
//        {
//            for (int i = 0; i < imagenamenodes.Count; i++)
//            {
//                if (imagenamenodes.Item(i).InnerText != "")
//                {
//                    images.Add(i, new KeyValuePair<string, string>(imagenamenodes.Item(i).InnerText, null));
//                    allattlist.Add(imagenamenodes.Item(i).InnerText);
//                }
//            }
//        }
//
//        XmlNodeList imagecontentnodes = xmldom.SelectNodes("DATA/IMAGECONTENT");
//        if (imagecontentnodes != null)
//        {
//            for (int i = 0; i < imagecontentnodes.Count; i++)
//            {
//                if (images.ContainsKey(i))
//                {
//                    string key = images[i].Key;
//                    images[i] = new KeyValuePair<string, string>(key, imagecontentnodes.Item(i).InnerText);
//                }
//            }
//        }
//
//        // 20110907 이미 존재하면 추가 생략
//        foreach (var item in images.Values)
//        {
//            string fatmp = item.Key;
//            // cid가 GUID 라면 //<![CDATA[14DD26F9-E508-40C3-8953-552F741067FA]]>
//            bool isguid = false;
//            if (fatmp.Length == 36 && fatmp[8].Equals('-') && fatmp[13].Equals('-') && fatmp[18].Equals('-') && fatmp[23].Equals('-'))
//            {
//                isguid = true;
//            }
//
//            bool isadd = true; // 추가할려고 하는데
//            foreach (var attachment in message.Attachments)
//            {
//
//                //WriteTextLog("attachment.IsInline", "attachment.IsInline", attachment.IsInline.ToString());
//                //WriteTextLog("attachment.ContentId", "attachment.ContentId", attachment.ContentId.ToString());
//                //WriteTextLog("fatmp", "fatmp", fatmp.ToString());
//                // 예전에 존재한 첨부이미지는 생략
//                if (!isguid && fatmp.IndexOf("@") == -1 && attachment.IsInline && attachment.ContentId.Equals(fatmp.Replace(".tmp", ".png")))
//                {
//                    this.attlist.Add(fatmp);
//                    isadd = false;
//                    break;
//                }
//                if (attachment.IsInline && attachment.ContentId.Equals(fatmp + (isguid || fatmp.IndexOf("@") > -1 ? "" : "@12345678.87654321")))
//                {
//                    isadd = false;
//                    break;
//                }
//            }
//
//            if (isadd)
//            {
//                FileAttachment fa = message.Attachments.AddFileAttachment(fatmp, Convert.FromBase64String(item.Value));
//                fa.IsInline = true;
//                fa.ContentId = fatmp + (isguid || fatmp.IndexOf("@") > -1 ? "" : "@12345678.87654321");
//                //20121017 : 본문이미지 첨부로 빠지는 문제로 주석
//                //fa.ContentType = "image/unknown"; // 파일명에서 확장자가 없을 때 
//            }
//
//        }
        
		String strCheckReadUrl = ""; //외부메일수신확인 관련 URL. GetSystemConfigValue("APPREADCHECK_URL").ToString();
        Boolean isEachMailB = Boolean.parseBoolean(isEachMail.trim());
        if (!delaySendTime.equals("")) {
            //do_delaysend(xmldom, message);
            rtnStatus = "OK";
        } else {                        
            if (!eShowDisplayName.equals("")) {
            	//eShowDisplayName = Base64Encode(eShowDisplayName);
                //message.SetExtendedProperty(new ExtendedPropertyDefinition(DefaultExtendedPropertySet.InternetHeaders, "X-NEW-DISPLAYNAME", MapiPropertyType.String), eShowDisplayName);
            }
            //message.Update(ConflictResolutionMode.AlwaysOverwrite);

//            if (replyReadTime.equals("2") && strCheckReadUrl != "" && !iseachmail) //외부메일수신확인
//            	rtnStatus = OuterMailSend(esb, message, mailcmd, strCheckReadUrl, orgurl, messageid, newwindowid);
//            else
//            	rtnStatus = InnterMailSend(esb, message, mailcmd, iseachmail, orgurl, newwindowid, messageid, strCheckReadUrl, xmldom);
            
            //InnterMailSend 변환 시작
            isEachMailB = true;
            if(isEachMailB){
            	//개별발송에 따른 "X-READCHECK" 값  Update
            	String strRecvGuid = UUID.randomUUID().toString();
            	message.setHeader("x-readcheck", strRecvGuid);
            	message.setHeader("x-eachmail", "true");
            	
            	Address[] allRecipients = message.getAllRecipients();
            	
            	message.removeHeader("TO");
        		message.removeHeader("CC");
        		message.removeHeader("BCC");
            	for(Address a : allRecipients){
            		message.setRecipient(RecipientType.TO, a);
            		
            		Transport.send(message);
            	}
            	
            } else{
            	Transport.send(message);
            }
            
        }
        
        // sendmail_2010변환 끝
		//rtnStatus = sendmail_2010(esb, xmldom, out pMessageID);
        String pResult = null;
        pResult = "<RESULT><![CDATA[" + rtnStatus + "]]></RESULT>";
        pResult += "<MESSAGEID><![CDATA[" + pMessageID + "]]></MESSAGEID>";
        
		return "<DATA>" + pResult + "</DATA>";
	}
	
	/**
	 * 사원 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailNameCheck.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailNameCheck(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception{
		String pOrganSearchList = "";
		String pOrganCellList = "displayname";
		String pOrganPropList = "company;description;title;mail;extensionAttribute3";
		String pOrganListType = "all";
		String pDLSearchList = "";
		String pDLCellList = "displayname";
		String pDLPropList = "mail";
		String pDLListType = "group";
		String pAddressFilter = "";
		
		Document xmlDoc = commonUtil.convertRequestToDocument(request);
		Element root = xmlDoc.getDocumentElement();
		
		Node tempNode = null;
		if(root.getElementsByTagName("ORGSEARCH") != null){
			tempNode = root.getElementsByTagName("ORGSEARCH").item(0);
			if(tempNode != null && !tempNode.getTextContent().equals("")){
				pOrganSearchList = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("DLGSEARCH") != null){
			tempNode = root.getElementsByTagName("DLGSEARCH").item(0);
			if(tempNode != null && !tempNode.getTextContent().equals("")){
				pDLSearchList = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("CELL") != null){
			tempNode = root.getElementsByTagName("CELL").item(0);
			if(tempNode != null && !tempNode.getTextContent().equals("")){
				pOrganCellList = tempNode.getTextContent();
				pDLCellList = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("ORGPROP") != null){
			tempNode = root.getElementsByTagName("ORGPROP").item(0);
			if(tempNode != null && !tempNode.getTextContent().equals("")){
				pOrganPropList = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("DLPROP") != null){
			tempNode = root.getElementsByTagName("DLPROP").item(0);
			if(tempNode != null && !tempNode.getTextContent().equals("")){
				pDLPropList = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("ORGTYPE") != null){
			tempNode = root.getElementsByTagName("ORGTYPE").item(0);
			if(tempNode != null && !tempNode.getTextContent().equals("")){
				pOrganListType = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("DLTYPE") != null){
			tempNode = root.getElementsByTagName("DLTYPE").item(0);
			if(tempNode != null && !tempNode.getTextContent().equals("")){
				pDLListType = tempNode.getTextContent();
			}
		}
		if(root.getElementsByTagName("ADDFILTER") != null){
			tempNode = root.getElementsByTagName("ADDFILTER").item(0);
			if(tempNode != null && !tempNode.getTextContent().equals("")){
				pAddressFilter = tempNode.getTextContent();
			}
		}
        
        String organXML = getOrganSearch(pOrganSearchList, pOrganCellList, pOrganPropList, pOrganListType);
        String dlXML = getOrganDLSearch(pDLSearchList, pDLCellList, pDLPropList, pDLListType);
        String addressXML = getAddressSearch(pAddressFilter);
        return String.format("<RESULT><ORGAN>%s</ORGAN><DL>%s</DL><ADDRESS>%s</ADDRESS></RESULT>", organXML, dlXML, addressXML);
	}
	
	/**
	 * 사원 Organ 정보 호출 함수
	 */
	private String getOrganSearch(String pSearchList, String pCellList, String pPropList, String pListType) {
		String pResult = "";
        try {
            pResult = ezOrganService.getSearchList(pSearchList, pCellList, pPropList, pListType, 100, config.getProperty("config.primary"));
        } catch (Exception Ex) {
            pResult = "EXCEPTION";
        }
        return pResult;
    }
	
	/**
	 * 사원 DL 정보 호출 함수
	 */
	private String getOrganDLSearch(String pSearchList, String pCellList, String pPropList, String pListType) {
        String pResult = "";
        try {
        	//todo : ezOrganService에 getSearchListDL만들어지면 연결
            //pResult = ezOrganService.getSearchListDL(pSearchList, pCellList, pPropList, pListType, 100, "");
        	pResult = "<LISTVIEWDATA><ROWS></ROWS></LISTVIEWDATA>";
        } catch (Exception Ex) {
            pResult = "EXCEPTION";
        }
        return pResult;
    }
	
	/**
	 * 사원 Address 정보 호출 함수
	 */
	private String getAddressSearch(String pFilter) {
        String pResult = "";
        try {
        	//todo : ezAddress 만들어지면 연결
//            XmlDocument xmldom = new XmlDocument();
//            StringBuilder Rvalue = new StringBuilder("");
//            GetSearcAddressInfo(pFilter, "P", ref Rvalue);
//            string _field = "STYPE,AddressID, SNAME,'DB' AS FLODERTYPE , SEMAIL, SCOMPANY, SDEPT, STITLE";
//            //ezAddress.AddressInfo _ezAddress = new ezAddress.AddressInfo();
//            string DBSearchList = _ezAddress.GetSearchList(userinfo.CompanyID + "," + userinfo.DeptID, "", "SNAME LIKE '%" + pFilter + "%'", _field, 0, 100, 0, "");
//            xmldom = GetXmlReaderString(DBSearchList);
//            if (xmldom.SelectNodes("DATA/ROW").Count > 0) {
//                foreach (XmlNode Node in xmldom.SelectNodes("DATA/ROW")) {
//                    Rvalue.Append(Node.OuterXml);
//                }
//            }
//            pResult = Rvalue.ToString();
        	pResult = "";
        } catch (Exception Ex) {
            pResult = "EXCEPTION";
        }
        return pResult;
    }
}
