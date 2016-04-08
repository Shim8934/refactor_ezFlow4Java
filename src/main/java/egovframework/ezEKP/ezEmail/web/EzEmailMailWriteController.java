package egovframework.ezEKP.ezEmail.web;

import java.io.File;
import java.net.URLDecoder;
import java.util.List;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;

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
//		XmlDocument xmldom = new XmlDocument();
//		xmldom = GetXmlReaderString(infoXML);
//		if (xmldom.InnerText == "")
		pAutoSaveTime = "0";
//		else
//			pAutoSaveTime = xmldom.SelectSingleNode("DATA/KEEPDELETELENGTH").InnerText.Trim();

//		string _PmailSenderNM = xmldom.SelectNodes("DATA/MAILSENDERNM").Count > 0 ?
//				string.IsNullOrEmpty(xmldom.SelectSingleNode("DATA/MAILSENDERNM").InnerText) ?
//						userinfo.DisplayName2 : xmldom.SelectSingleNode("DATA/MAILSENDERNM").InnerText : userinfo.DisplayName2;
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
//            XmlDocument xmldom = new XmlDocument();
//            xmldom = GetXmlReaderString(ResultXML);
//            if (xmldom.SelectSingleNode("DATA").ChildNodes.Count > 0)
//            {
//                mailSign1 = HttpUtility.HtmlDecode(xmldom.SelectSingleNode("DATA/ROW/CONTENT1").InnerXml);
//                mailSign2 = HttpUtility.HtmlDecode(xmldom.SelectSingleNode("DATA/ROW/CONTENT2").InnerXml);
//                mailSign3 = HttpUtility.HtmlDecode(xmldom.SelectSingleNode("DATA/ROW/CONTENT3").InnerXml);
//                mailSignSel = xmldom.SelectSingleNode("DATA/ROW/USEFLAG").InnerText;
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

	@RequestMapping(value="/ezEmail/mailCKEditor.do")
	public String mailCKEditor(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "ezEmail/mailCKEditor";
	}

	@RequestMapping(value="/ezEmail/dragAndDrop.do")
	public String dragAndDropIframe(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "ezEmail/mailDragAndDrop";
	}

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
		}
		else{
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



				//하다가 말았음. mailWrite.do 다하면 여기서부터 수정ㄱㄱ
				//FileOutputStream fos = new FileOutputStream(file1);
				//fos.write(Base64.encodeBase64(pFileName[i].getBytes()));
				//fos.close();
			}
		}

		return "";
	}

}
