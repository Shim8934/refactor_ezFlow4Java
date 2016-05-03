package egovframework.ezEKP.ezEmail.web;

import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Folder;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 편지함 관리
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.05.03    이효민    신규작성
 *
 * @see
 */

@Controller
public class EzEmailFolderManageController extends EgovFileMngUtil{

	private static final Logger logger = LoggerFactory.getLogger(EzEmailFolderManageController.class);
	
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
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	/**
	 * 편지함 관리 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailFolderManage.do")
	public String mailFolderManage(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		String pDeleteBoxID = "지운편지함";
		String pDeleteBoxName = "지운편지함";
		
		model.addAttribute("pDeleteBoxID", pDeleteBoxID);
		model.addAttribute("pDeleteBoxName", pDeleteBoxName);
		
		return "ezEmail/mailFolderManage";
	}
	
	/**
	 * 편지함 추가/수정 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/inputNameDlg.do")
	public String inputNameDlg(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		
		return "ezEmail/mailInputNameDlg";
	}
	
	/**
	 * 편지함 이동/복사 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailMoveCopy.do")
	public String mailMoveCopy(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		
		return "ezEmail/mailMoveCopy";
	}
	
	/**
	 * 편지함 추가/수정/삭제/이동/복사/메일삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailMakeFolder.do")
	@ResponseBody
	public String mailMakeFolder(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		Document xmlDoc = commonUtil.convertRequestToDocument(request);
		Element root = xmlDoc.getDocumentElement();
		
		String url = "";
		String name = "";
		String destination = "";
		String cmd = "";
		
		if (root.getElementsByTagName("URL") != null && root.getElementsByTagName("URL").item(0) != null) {
			url = root.getElementsByTagName("URL").item(0).getTextContent();
		}
		if (root.getElementsByTagName("NAME") != null && root.getElementsByTagName("NAME").item(0) != null) {
			name = root.getElementsByTagName("NAME").item(0).getTextContent();
		}
		if (root.getElementsByTagName("DESTINATION") != null && root.getElementsByTagName("DESTINATION").item(0) != null) {
			destination = root.getElementsByTagName("DESTINATION").item(0).getTextContent();
		}
		if (root.getElementsByTagName("CMD") != null && root.getElementsByTagName("CMD").item(0) != null) {
			cmd = root.getElementsByTagName("CMD").item(0).getTextContent();
		}
		
		List<String> userIdnPw = commonUtil.getUserIdAndPassword(loginCookie);
		String userId = userIdnPw.get(0);
		String password  = userIdnPw.get(1);
		
		IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				userId+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
		
        switch (cmd) {
            case "NEW": 
            	ia.createFolder(name, url);
                break;
            case "MOVE": 
//            	folder = Folder.Bind(esb, (FolderId)xmldoc.GetElementsByTagName("URL")[0].InnerText);
//                newFolder = folder.Move((FolderId)xmldoc.GetElementsByTagName("DESTINATION")[0].InnerText);
//                returnFolderID = newFolder.Id.UniqueId;
                break;
            case "DEL": 
//            	folder = Folder.Bind(esb, (FolderId)xmldoc.GetElementsByTagName("URL")[0].InnerText);
//                folder.Delete(DeleteMode.HardDelete);
                break;
            case "COPY": 
//            	folder = Folder.Bind(esb, (FolderId)xmldoc.GetElementsByTagName("URL")[0].InnerText);
//                newFolder = folder.Copy((FolderId)xmldoc.GetElementsByTagName("DESTINATION")[0].InnerText);
//                returnFolderID = newFolder.Id.UniqueId;
                break;
            case "MODIFY":
            	Folder oldFolder = ia.getFolder(url);
            	if (oldFolder.exists()) {
            		String parentPath = oldFolder.getParent().getFullName();
            		Folder newFolder = ia.getFolder(parentPath).getFolder(destination);
            		boolean isRenamed = ((IMAPFolder)oldFolder).renameTo(newFolder);
            		if (isRenamed) {
            			logger.debug(url + " folder is renamed as " + destination + ".");
            		}
            	}
                break;
            case "MAILREALDEL": 
//            	findResults = esb.FindItems((FolderId)xmldoc.GetElementsByTagName("URL")[0].InnerText, new ItemView(int.MaxValue));
//                foreach (Item item in findResults)
//                {
//                    item.Delete(DeleteMode.SoftDelete);
//                }
                break;
            case "MAILDEL": 
//            	findResults = esb.FindItems((FolderId)xmldoc.GetElementsByTagName("URL")[0].InnerText, new ItemView(int.MaxValue));
//                foreach (Item item in findResults)
//                {
//                    item.Delete(DeleteMode.MoveToDeletedItems);
//                }
                break;
            default:
                break;
        }
		
        ia.close();
        
		return "";
	}
}
