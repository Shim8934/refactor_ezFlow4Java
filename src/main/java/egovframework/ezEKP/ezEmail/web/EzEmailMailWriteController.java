package egovframework.ezEKP.ezEmail.web;

import java.io.File;
import java.util.List;
import java.util.Properties;
import java.util.UUID;

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

import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

@Controller
public class EzEmailMailWriteController {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@RequestMapping(value="/ezEmail/mailWrite.do")
	public String mailWrite(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception{
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
        String serialNo = "";
        String itemNo = "";
        String itemID = "";
        String docHref = "";
        String brdGubun = "";
        String docID = "";
        String docImagCnt = "";
        String docTarget = "";
        String sendFrom = "";
        String retransType = "";
        String strSelectHTML = "";
        String useMultiLangMail = "";
        String displayNamePrintable = "";
        String charsetCheck = "1";
        String newMailPath = "";
        String userInfoApprovalG = "";
        String userLang = "1";
        String userPrimary = "1";
        String reSendFlag = "N";
        String mailAttachLimit = "20";
        String bigSizeMailAttachLimit = "20";
        String totBigSizeMailAttachLimit = "20";
        String bigSizeMailAttachDelDay = "20";
        String userTimeset = "";
        String attachFileName = "";
        String orgUrl = "";
        String cmdOwn = "";
        String urlOwn = "";
        String mailSign1 = "";
        String mailSign2 = "";
        String mailSign3 = "";
        String mailSignSel = "";
        String bodyValue = "";
        String returnValue = "";
        String fileUploadType = "";
        String folderPath = "";
        String hostURL = "";
        String mailPath = "";
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
        double offsetHour = 0;
        double offsetMin = 0;
        String useEditor = "";
        String displaySender = "";  // 발신명의 숨김 여부
        String readDefaultOption = "1";  //구축형: 1 (읽음확인) / o365: 0 (읽음확인 해제)
		
        userInfo = commonUtil.userInfo(loginCookie);
        useEditor = config.getProperty("config.EDITOR");
        System.out.println("getRequestURI : "+request.getRequestURI());
        System.out.println("getRequestURL : "+request.getRequestURL().substring(0, request.getRequestURI().length()));
        
        hostURL = request.getRequestURL().substring(0, request.getRequestURI().length()) + "/ezEmail/";
        //mailpath = GetSystemConfigValue("Mail_UploadPath"); - 필요없는것같음
        folderDate = EgovDateUtil.getCurrentDate("");
        stateName = UUID.randomUUID().toString();
        
        /*
         * offset time - 뭐지? 
        string offSetTime_ = userinfo.Offset.Split('|')[1];
        if (offSetTime_.Substring(0, 1).Equals("+"))
        {
            OffsetHour = +double.Parse(offSetTime_.Split(':')[0]);
            offsetMin = +double.Parse(offSetTime_.Split(':')[1]);
        }
        else
        {
            OffsetHour = -double.Parse(offSetTime_.Split(':')[0]);
            offsetMin = -double.Parse(offSetTime_.Split(':')[1]);
        }*/
        
        /*
         * 내부 도메인 ;기호로 여러개 지정 가능 (aaa.com;bbb.com 과 같이) : key="MailInnerDomain" value="opensol2014.com"
        MailInnerDomain = GetSystemConfigValue("MailInnerDomain").ToString().Trim(); - 필요한가?
        */
        
        /* 
         * 개별발신 인원수 : key="INDIVIDUALMAILUSER" value="5"
        individualmailuser = int.Parse(GetSystemConfigValue("INDIVIDUALMAILUSER").ToString().Trim()); - 이건뭐지? 필요한가?
        */
        
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
        
        //--변환중.
        
        
		if (userInfo.getLang().equals("1"))
            pAttachWarning = "일반첨부파일은 총 " + mailAttachLimit + "MB까지 가능하며, 대용량첨부는 " + totBigSizeMailAttachLimit + "MB까지 가능(" + pBigAttachDownloadDay + "일후 자동삭제) ";
        else if (userInfo.getLang().equals("2"))
            pAttachWarning = "Normal attachments and large attachments up to " + mailAttachLimit + "MB up to " + totBigSizeMailAttachLimit + "MB (after " + pBigAttachDownloadDay + " days automatically deleted) ";
        else if (userInfo.getLang().equals("3"))
            pAttachWarning = "一般的な添付ファイルは合計" + mailAttachLimit + "MBまで可能で、大容量の添付ファイルは" + totBigSizeMailAttachLimit + "MBまで可能（" + pBigAttachDownloadDay + "日後に自動削除）";
        else if (userInfo.getLang().equals("4"))
            pAttachWarning = "普通附件和大型附件" + mailAttachLimit + "MB高达" + totBigSizeMailAttachLimit + "MB（" + pBigAttachDownloadDay + " 天之后自动删除）";
		
		model.addAttribute("pAttachWarning", pAttachWarning);
		return "ezEmail/mailWrite";
	}
	
	@RequestMapping(value="/ezEmail/mailCKEditor.do")
	public String mailCKEditor(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{		
		userInfo = commonUtil.userInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "ezEmail/mailCKEditor";
	}
	
	@RequestMapping(value="/ezEmail/dragAndDrop.do")
	public String dragAndDropIframe() throws Exception{
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
        folderDate = EgovDateUtil.getCurrentDate("");
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
