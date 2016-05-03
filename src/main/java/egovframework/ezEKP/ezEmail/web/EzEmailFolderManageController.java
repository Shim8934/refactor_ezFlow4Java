package egovframework.ezEKP.ezEmail.web;

import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
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
}
