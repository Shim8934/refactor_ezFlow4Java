package egovframework.ezEKP.ezMemo.web;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCircular.vo.CircularFolderVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezJournal.web.EzJournalGWController;
import egovframework.ezEKP.ezMemo.service.EzMemoService;
import egovframework.ezEKP.ezMemo.vo.MemoConfigVO;
import egovframework.ezEKP.ezMemo.vo.MemoFolderVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzMemoGWController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzMemoGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties globals;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzMemoService")
	private EzMemoService ezMemoService;
	
	@Resource(name="MOptionService")
	private MOptionService MOptionService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@RequestMapping(value = "/rest/ezMemo/memo-list/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject gwMemoList(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/memo-list/users/]" +userId + " started.");
		
		
		JSONObject result = new JSONObject();
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = MOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch(Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/memo-list/users/] ended.");
		return result;
	}
	
	@RequestMapping(value = "/rest/ezMemo/folders/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject gwMemoFoldersInfo(@PathVariable String userId, MemoFolderVO memoFolderVO, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/folders/users/]" +userId + " started.");
		
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = MOptionService.commonInfoWeb(serverName, request.getParameter("user_id"));
			memoFolderVO.setTenant_id(info.getTenantId());
			
			int memoCount = ezMemoService.getMemoCount(memoFolderVO);
			List<MemoFolderVO> memoFolders  = ezMemoService.getMemoFolderInfo(memoFolderVO);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", memoFolders);
			result.put("memoCount", memoCount);
		} catch(Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/folders/users/] ended.");
		return result;
	}
	
	@RequestMapping(value = "/rest/ezMemo/folders/names/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject gwMemoFolderNames(@PathVariable String userId, MemoFolderVO memoFolderVO, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/folders/names/users/]" +userId + " started.");
		
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = MOptionService.commonInfoWeb(serverName, request.getParameter("user_id"));
			memoFolderVO.setTenant_id(info.getTenantId());
			
			List<MemoFolderVO> memoFolders  = ezMemoService.getMemoFolderInfo(memoFolderVO);
			String folderNameList = "";

			for (int i=0; i<memoFolders.size(); i++) {
				folderNameList += memoFolders.get(i).getFolder_name() + ";";
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", folderNameList);
		} catch(Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/folders/names/users/] ended.");
		return result;
	}
	
	@RequestMapping(value = "/rest/ezMemo/folders/users/{userId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject gwMemoFoldersAdd(@PathVariable String userId, MemoFolderVO memoFolderVO, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/folders/users/]" +userId + " started.");
		
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = MOptionService.commonInfoWeb(serverName, request.getParameter("user_id"));
			memoFolderVO.setTenant_id(info.getTenantId());
			
			ezMemoService.addMemoFolder(memoFolderVO);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch(Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/folders/users/] ended.");
		return result;
	}
}
