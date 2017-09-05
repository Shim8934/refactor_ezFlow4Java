package egovframework.ezMobile.ezOrgan.web;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOrgan.service.MOrganService;
import egovframework.ezMobile.ezOrgan.vo.MPersonListVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@RestController
public class MOrganGWController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MOrganGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name = "MOrganService")
	private MOrganService mOrganService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	/**
	 * 모바일 G/W 직원조회 [GET] 직원 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezorgan/personlist", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getPersonList(HttpServletRequest request, Model model) {		
		LOGGER.debug("MOBILE G/W ORGAN [GET /ezorgan/personlist] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userID = request.getParameter("userID");
			String pSearchText = request.getParameter("pSearchText");
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userID);
			
			//String primary = commonUtil.getPrimaryData(info.getLang(), info.getTenantId());
			
			List <MPersonListVO> list = mOrganService.getPersonList(info.getCompanyId(), info.getTenantId(),pSearchText);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", list);
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		LOGGER.debug("MOBILE G/W BOARD [GET /ezorgan/personlist] ended.");
		return result;
	}
}
