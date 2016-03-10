package egovframework.ezEKP.ezEmail.web;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzEmailController {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@RequestMapping(value="/ezEmail/mailMain.do")
	public String showMailMain() throws Exception{		
		return "ezEmail/mailMain";
	}
	
	@RequestMapping(value="/ezEmail/mailLeft.do")
	public String showMailLeft(@CookieValue("userID") String userID, Model model, LoginVO loginVO) throws Exception{
		String funCode = "";
		String subCode = "";			
        String rootFolderXML = "";
        String rootAddressXML = "";
        String folderID = "";
        String pOutBoxFolderID = "";
        String pSentBoxID = "";
        String pDraftBoxID = "";
        String pDeleteBoxID = "";
        String pInBoxID = "";
        String pJunkBoxID = "";
        String pPersonalBoxID = "";
        String pAddressFolderID = "";
        String pAddressChangeID = "";
        String pAddressUpFolderID = "";
        String use_Editor = "";
        String use_IE11Browser = "";
        String pcFolderPath = "";
        String noneActiveX = "";
        //유저정보 가져오기 아직 미구현이므로 고정값으로 테스트 @수정요망@
        loginVO = commonUtil.userInfo(userID);
        
        String use_ArchiveMailBox = config.getProperty("config.USE_ArchiveMailBox");
        String serverName = config.getProperty("config.serverName");
        model.addAttribute("use_ArchiveMailBox", use_ArchiveMailBox);
        model.addAttribute("serverName", serverName);
		return "ezEmail/mailLeft";
	}
	
	@RequestMapping(value="/ezEmail/mailList.do")
	public String showMailList(@CookieValue("userID") String userID, HttpServletRequest request, Model model, LoginVO loginVO, HttpServletResponse response) throws Exception{
		return "ezEmail/mailList";
	}
}
