package egovframework.ezMobile.ezEmail.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Folder;
import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezMobile.ezEmail.vo.MEmailFolderVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 메일
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2017.06.13    이효민    신규작성
 *
 * @see
 */

@Controller
public class MEmailController extends EgovFileMngUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(MEmailController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	/**
	 * 모바일 메인 > 편지함 리스트 정보 표출 함수
	 */
	@RequestMapping(value = "/mobile/ezEmail/getFolderList.do")
	public String getFolderList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, HttpServletResponse response, Locale locale) throws Exception {
		logger.debug("getFolderList started.");
		
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userIdAndPassword.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		logger.debug("userAccount=" + userAccount);
		
		String folderId = request.getParameter("folderId");
		logger.debug("folderId=" + folderId);
		
		List<MEmailFolderVO> mailFolderList = new ArrayList<MEmailFolderVO>();
		
		IMAPAccess ia = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, locale);
			
			List<Folder> subMailFolder = null;
			
			if (folderId != null && !folderId.equals("")) {
				subMailFolder = ia.getSubFolders(folderId);
			} else {
				subMailFolder = ia.getTopLevelFolders();
			}
			
			MEmailFolderVO folder = null;
			
			for (int i=0; i<subMailFolder.size(); i++) {
				Folder f = subMailFolder.get(i);
				
				folder = new MEmailFolderVO();
				
				folder.setName(f.getName());
				folder.setFullName(f.getFullName());
				folder.setUnReadCount(f.getUnreadMessageCount());
				
				mailFolderList.add(folder);
			}
			
		} catch (MessagingException e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		model.addAttribute("mailFolderList", mailFolderList);
		
		logger.debug("getFolderList ended.");
		return "json";
	}
	
	/**
	 * 모바일 편지함 > 편지함 정보 표출 함수
	 */
	@RequestMapping(value = "/mobile/ezEmail/mailMain.do")
	public String mailMain(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, HttpServletResponse response, Locale locale) throws Exception {
		logger.debug("mailMain started.");
		
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userIdAndPassword.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		logger.debug("userAccount=" + userAccount);
		
		String folderId = request.getParameter("folderId");
		logger.debug("folderId=" + folderId);
		
		MEmailFolderVO folderInfo = new MEmailFolderVO();
		
		IMAPAccess ia = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, locale);
			
			Folder folder = ia.getFolder(folderId);
			
			folderInfo.setName(folder.getName());
			folderInfo.setFullName(folder.getFullName());
			folderInfo.setUnReadCount(folder.getUnreadMessageCount());
			
			if (folder.list().length > 0) {
				folderInfo.setHasSub(true);
			} else {
				folderInfo.setHasSub(false);
			}
			
		} catch (MessagingException e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}

		model.addAttribute("folderInfo", folderInfo);
		
		logger.debug("mailMain ended.");
		
		return "/mobile/ezEmail/mMailMain";
	}
	
}
