package egovframework.ezMobile.sample.web;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezMobile.ezApprovalG.dao.MApprovalGDAO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAbsenteeAddJobInfoVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 스케쥴
 * @author 오픈솔루션팀 지정석
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.07.20    지정석    신규작성
 *
 * @see
 */

@Controller
public class MSampleController extends EgovFileMngUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(MSampleController.class);

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;

	@Resource(name = "MApprovalGDAO")
	private MApprovalGDAO mApprovalGDAO;
	
	/**
	 * 모바일 샘플 리스트 함수
	 */
	@RequestMapping(value = "/mobile/sample/sampleList.do")
	public String sampleList(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("sampleList Start");
		
		String type = req.getParameter("type");
		String title = "";
		
		if (type.equals("mailReceive")) {
			title = "받은편지함"; //spring message 적용필요
		} else if (type.equals("mailSend")) {
			title = "보낸편지함"; //spring message 적용필요
		}
		model.addAttribute("title", title);
		model.addAttribute("type", type);
		
		logger.debug("sampleList End");
		
		return "/mobile/sample/sampleList";
	}
	
	/**
	 * 모바일 샘플 상세화면 함수
	 */
	@RequestMapping(value = "/mobile/sample/sampleDetail.do")
	public String sampleDetail(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("sampleDetail Start");
		
		String type = req.getParameter("type");
		String title = "";
		
		title = "받은편지함"; //spring message 적용필요
	
		model.addAttribute("title", title);
		model.addAttribute("type", type);
		
		logger.debug("sampleDetail End");
		
		return "/mobile/sample/sampleDetail";
	}

	@RequestMapping(value = "/ezConn/gbptest.do")
	public void testtest(HttpServletRequest request,  HttpServletResponse response) throws Exception {

		Map<String, Object> map = new HashMap<>();
		map.put("tenantId", 1);
		try {
			List<MApprovalGAbsenteeAddJobInfoVO> vo = mApprovalGDAO.getAbsenteeAddJobInfo(map);
			System.out.println(vo.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
