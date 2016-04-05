package egovframework.ezEKP.ezEmail.web;

import java.util.Properties;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzEmailMailWriteController {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@RequestMapping(value="/ezEmail/mailWrite.do")
	public String mailWrite(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String pAttachWarning = "";
		String mailAttachLimit = "20";
		String totBigSizeMailAttachLimit = "20";
		String pBigAttachDownloadDay = "";
		
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
	
	@RequestMapping(value="/ezEmail/dragAndDropIframe.do")
	public String dragAndDropIframe() throws Exception{		
		return "ezEmail/dragAndDropIframe";
	}
}
