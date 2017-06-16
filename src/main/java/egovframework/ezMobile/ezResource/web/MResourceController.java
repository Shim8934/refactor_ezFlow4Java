package egovframework.ezMobile.ezResource.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezMobile.ezResource.service.MResourceService;
import egovframework.ezMobile.ezResource.vo.MResourceGetAdmSubClsTreeVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 스케쥴
 * @author 오픈솔루션팀 지정석
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2017.06.14    지정석    신규작성
 *
 * @see
 */

@Controller
public class MResourceController extends EgovFileMngUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(MResourceController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name = "EzResourceService")
	private EzResourceService ezResourceService;
	
	@Resource(name="loginService")
	private LoginService loginService;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "MResourceService")
	private MResourceService mResourceService;
	
	@RequestMapping(value="/mobile/ezResource/getSubList.do")
	public String getSubList(HttpServletRequest req, LoginVO userInfo, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse resp) throws Exception {
		logger.debug("getSubList started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String brdId = "";
		
		if (req.getParameter("brdId") != null && !req.getParameter("brdId").equals("")) {
			brdId = req.getParameter("brdId");
		}
		
		List<MResourceGetAdmSubClsTreeVO> resSubList = new ArrayList<MResourceGetAdmSubClsTreeVO>();
		resSubList = mResourceService.getAdmSubClsTree(brdId, userInfo.getCompanyID(), "0", userInfo.getTenantId());
		
		model.addAttribute("subList", resSubList);
		
		logger.debug("getSubList ended.");
		return "json";
	}
	
	
	
}
