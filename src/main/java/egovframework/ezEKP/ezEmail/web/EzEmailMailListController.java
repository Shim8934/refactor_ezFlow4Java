package egovframework.ezEKP.ezEmail.web;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzEmailMailListController {
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

    @Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;    

    @Resource(name="EzEmailService")
    private EzEmailService ezEmailService;    
    
    private static final Logger logger = LoggerFactory.getLogger(EzEmailMailListController.class);
	
	@RequestMapping("/ezEmail/mailList.do")
	public String showMailList(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("showMailList started");
		
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String userId = userIdAndPassword.get(0);
		String password = userIdAndPassword.get(1);
		String folderName = egovMessageSource.getMessage("ezEmail.t644");
		String folderType = "";
		String userLang ="1";
		
		if (folderName.equals(egovMessageSource.getMessage("ezEmail.t645"))) {
			folderType = "sent";
		}
		else if (folderName.equals(egovMessageSource.getMessage("ezEmail.t646"))) {
			folderType = "draft";
		}
		else if (folderName.equals(egovMessageSource.getMessage("ezEmail.t647"))) {
			folderType = "delete";
		}
		
		MailGeneralVO mailGeneral = null;
		List<MailGeneralVO> mailGeneralList = ezEmailService.getMailGeneral(userId);
		if (mailGeneralList.size() > 0) {
			mailGeneral = mailGeneralList.get(0);
			logger.debug("userId=" + userId + ",mailGeneral=" + mailGeneral);
		}
		
		model.addAttribute("folderName", folderName);
		model.addAttribute("folderType", folderType);
		model.addAttribute("isSentItems", true);
		model.addAttribute("listCount", "30");
		model.addAttribute("userLang", userLang);
		model.addAttribute("userId", userId);
		model.addAttribute("mailGeneral", mailGeneral);
		
		logger.debug("showMailList ended");
		
		return "ezEmail/mailList";
	}
	
	@RequestMapping(value="/ezEmail/mailGetList.do",method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getMailList(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {
		logger.debug("getMailList started");
		
		logger.debug("bodyData=" + bodyData);
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String folderId = doc.getElementsByTagName("FOLDERID").item(0).getTextContent();
		String sortType = doc.getElementsByTagName("SORTTYPE").item(0).getTextContent();
		String start = doc.getElementsByTagName("START").item(0).getTextContent();
		String end = doc.getElementsByTagName("END").item(0).getTextContent();
		String search = doc.getElementsByTagName("SEARCH").item(0).getTextContent();
		String viewSelectIndex = doc.getElementsByTagName("VIEWSELECTINDEX").item(0).getTextContent();
		logger.debug("folderId=" + folderId + ",sortType=" + sortType + ",start=" + start + ",end=" + end
						+ ",search=" + search + ",viewSelectIndex=" + viewSelectIndex);
		
		String returnData = "<maillist><contentrange>0-29</contentrange><response><href><![CDATA[AAMkAGJiNjA1ZTYwLWU3NjItNDA1Yi05NWNhLWU0MjdjYTYwODhiYwBGAAAAAAD0DJQBik2KSIR3MR2XIUsMBwAC5Z0TOjuhQ5Z/reykkEsxAAAAAAEMAAAC5Z0TOjuhQ5Z/reykkEsxAAAZAx8FAAA=]]></href><fromemail><![CDATA[]]></fromemail><importance><![CDATA[1]]></importance><flag><![CDATA[0]]></flag><attach><![CDATA[0]]></attach><sender><![CDATA[ 이동호(iPhone) ]]></sender><subject><![CDATA[Re: Local Delivery 문제 해결]]></subject><receivedt><![CDATA[2016-02-17 18:12]]></receivedt><size><![CDATA[9962]]></size><read><![CDATA[1]]></read><contentclass><![CDATA[IPM.Note]]></contentclass></response><response><href><![CDATA[AAMkAGJiNjA1ZTYwLWU3NjItNDA1Yi05NWNhLWU0MjdjYTYwODhiYwBGAAAAAAD0DJQBik2KSIR3MR2XIUsMBwAC5Z0TOjuhQ5Z/reykkEsxAAAAAAEMAAAC5Z0TOjuhQ5Z/reykkEsxAAAZAx8EAAA=]]></href><fromemail><![CDATA[]]></fromemail><importance><![CDATA[2]]></importance><flag><![CDATA[0]]></flag><attach><![CDATA[0]]></attach><sender><![CDATA[Microsoft Outlook]]></sender><subject><![CDATA[사서함이 거의 꽉 찼습니다.]]></subject><receivedt><![CDATA[2016-02-17 18:07]]></receivedt><size><![CDATA[10299]]></size><read><![CDATA[0]]></read><contentclass><![CDATA[IPM.Note.StorageQuotaWarning.Warning]]></contentclass></response><response><href><![CDATA[AAMkAGJiNjA1ZTYwLWU3NjItNDA1Yi05NWNhLWU0MjdjYTYwODhiYwBGAAAAAAD0DJQBik2KSIR3MR2XIUsMBwAC5Z0TOjuhQ5Z/reykkEsxAAAAAAEMAAAC5Z0TOjuhQ5Z/reykkEsxAAAZAx8DAAA=]]></href><fromemail><![CDATA[]]></fromemail><importance><![CDATA[1]]></importance><flag><![CDATA[0]]></flag><attach><![CDATA[0]]></attach><sender><![CDATA[이동호]]></sender><subject><![CDATA[읽음: Local Delivery 문제 해결]]></subject><receivedt><![CDATA[2016-02-17 17:30]]></receivedt><size><![CDATA[10803]]></size><read><![CDATA[1]]></read><contentclass><![CDATA[REPORT.IPM.Note.IPNRN]]></contentclass></response><response><href><![CDATA[AAMkAGJiNjA1ZTYwLWU3NjItNDA1Yi05NWNhLWU0MjdjYTYwODhiYwBGAAAAAAD0DJQBik2KSIR3MR2XIUsMBwAC5Z0TOjuhQ5Z/reykkEsxAAAAAAEMAAAC5Z0TOjuhQ5Z/reykkEsxAAAZAx8BAAA=]]></href><fromemail><![CDATA[]]></fromemail><importance><![CDATA[1]]></importance><flag><![CDATA[0]]></flag><attach><![CDATA[1]]></attach><sender><![CDATA[이동호]]></sender><subject><![CDATA[FW: 폼빌더 사용자 매뉴얼]]></subject><receivedt><![CDATA[2016-02-16 17:57]]></receivedt><size><![CDATA[2783134]]></size><read><![CDATA[1]]></read><contentclass><![CDATA[REPLY]]></contentclass></response><CONTENTRANGE><![CDATA[rows;0;29;total;4;BoxTCount;4;BoxUCount;1;]]></CONTENTRANGE></maillist>";
		logger.debug("getMailList ended");
		
		return returnData;		
	}
	
}
