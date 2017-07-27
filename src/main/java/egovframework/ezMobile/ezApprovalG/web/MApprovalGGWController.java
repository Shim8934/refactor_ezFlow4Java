package egovframework.ezMobile.ezApprovalG.web;

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
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezMobile.ezApprovalG.service.MApprovalGService;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGDocInfoVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 전자결재 모바일 GW
 * @author 오픈솔루션팀 황윤진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2017.07.25    황윤진    신규작성
 *
 * @see
 */

@RestController
public class MApprovalGGWController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MApprovalGGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name = "EzEmailService")
	private EzEmailService ezEmailService;
	
	@Resource(name = "MApprovalGService")
	private MApprovalGService MApprovalGService;
	
	@Resource(name = "MOptionService")
	private MOptionService MOptionService;

	/**
	 * 모바일 G/W 전자결재 [GET] 결재문서 리스트 (결재할(DO), 결재한(END), 결재진행(ING), 기안한(DRAFT))
	 */
	@RequestMapping(value = "/ezapproval/{type}/list/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalList(@PathVariable String type, @PathVariable String userId, HttpServletRequest request, Model model) {
		LOGGER.debug("MOBILE G/W APPROVAL [GET /ezapproval/" + type + "/list/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String searchText = request.getParameter("searchText");
			String listSize = request.getParameter("listSize");
			String lastDate = request.getParameter("lastDate");
			String serverName = request.getHeader("x-user-host");
			
			LOGGER.debug("SearchText : " + searchText);
			LOGGER.debug("ListSize : " + listSize);
			LOGGER.debug("LastDate : " + lastDate);
			
			MCommonVO userInfo = MOptionService.commonInfo(serverName, userId);
			
			List<MApprovalGDocInfoVO> approvalGDocInfoVOs = MApprovalGService.getDoApproveList(userInfo, type, searchText, listSize, lastDate);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", approvalGDocInfoVOs);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			result.put("data", "");
		}
		
		LOGGER.debug("MOBILE G/W APPROVAL [GET /ezapproval/" + type + "/list/users/" + userId + "] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 전자결재 [GET] 결재문서 카운트 (결재할(DO), 결재한(END), 결재진행(ING), 기안한(DRAFT))
	 */
	@RequestMapping(value = "/ezapproval/{type}/list-count/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject mApprovalListCount(@PathVariable String type, @PathVariable String userId, HttpServletRequest request, Model model) {
		LOGGER.debug("MOBILE G/W APPROVAL [GET /ezapproval/" + type + "/list-count/users/" + userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String searchText = request.getParameter("searchText");
			String serverName = request.getHeader("x-user-host");
			
			LOGGER.debug("ServerName : " + serverName);
			LOGGER.debug("SearchText : " + searchText);
			
			MCommonVO userInfo = MOptionService.commonInfo(serverName, userId);
			
			int listCount = MApprovalGService.getDoApproveListCount(userInfo, type, searchText);
			
			result.put("status", "ok");
			result.put("code", "0");
			result.put("data", listCount);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			result.put("data", "");
		}
		
		LOGGER.debug("MOBILE G/W APPROVAL [GET /ezapproval/" + type + "/list-count/users/" + userId + "] ended.");
		
		return result;
	}
}
