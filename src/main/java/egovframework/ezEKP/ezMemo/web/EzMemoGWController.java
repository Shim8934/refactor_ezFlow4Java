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
import egovframework.ezEKP.ezMemo.service.EzMemoService;
import egovframework.ezEKP.ezMemo.vo.MemoConfigVO;
import egovframework.ezEKP.ezMemo.vo.MemoFolderVO;
import egovframework.ezEKP.ezMemo.vo.MemoVO;
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
	public JSONObject gwMemoList(@PathVariable String userId, MemoVO vo, MemoConfigVO memoConfigVO, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/memo-list/users/" +userId + "] started.");

		JSONObject result = new JSONObject();
		String order = request.getParameter("order");
		String searchInput = request.getParameter("searchInput");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		
		vo.setUser_id(userId);
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = MOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			List<MemoVO> memoList = ezMemoService.getMemoList(vo, order, searchInput, startDate, endDate);
			MemoConfigVO config = ezMemoService.getMemoConfig(memoConfigVO);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
			result.put("memoList", memoList);
			result.put("colorList", config.getColor_name());
			result.put("defaultColor", config.getDefault_color()-1);
			//result.put("folderId", );
		} catch(Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/memo-list/users/" +userId + "] ended.");
		return result;
	}
	
	@RequestMapping(value = "/rest/ezMemo/folders/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject gwMemoFoldersInfo(@PathVariable String userId, MemoFolderVO memoFolderVO, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/folders/users/" +userId + "] started.");
		
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = MOptionService.commonInfoWeb(serverName, request.getParameter("user_id"));
			memoFolderVO.setTenant_id(info.getTenantId());
			
			int memoCount = ezMemoService.getMemoCount(memoFolderVO);
			List<MemoFolderVO> memoFolders  = ezMemoService.getMemoFolderInfo(memoFolderVO);
			MemoConfigVO memoConfigVO = new  MemoConfigVO();
			memoConfigVO.setUser_id(info.getUserId());
			memoConfigVO.setTenant_id(info.getTenantId());
			memoConfigVO.setCompany_id(info.getCompanyId());
			memoConfigVO = ezMemoService.getMemoConfig(memoConfigVO);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", memoFolders);
			result.put("memoCount", memoCount);
			result.put("foldStatus", memoConfigVO.getFold_status());
		} catch(Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/folders/users/" +userId + "] ended.");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezMemo/setLayerArea/users/{userId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject setLayerArea(@PathVariable String userId, MemoConfigVO memoConfig, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [PUT /rest/ezMemo/setLayerArea/users/" +userId + "] started.");
		
		
		JSONObject result = new JSONObject();
		
		try {
			
			ezMemoService.setMemoConfig(memoConfig);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
			
		} catch(Exception e) {
			
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("G/W MEMO [PUT /rest/ezMemo/setLayerArea/users/" +userId + "] ended.");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezMemo/setLayerPosition/users/{userId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject setLayerPosition(@PathVariable String userId, MemoConfigVO memoConfig, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [PUT /rest/ezMemo/setLayerPosition/users/" +userId + "] started.");
		
		
		JSONObject result = new JSONObject();
		
		try {
			LOGGER.debug("===============================================");
			LOGGER.debug("수정 vo: " + memoConfig);
			LOGGER.debug("===============================================");
			ezMemoService.setMemoConfig(memoConfig);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
			
		} catch(Exception e) {
			
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("G/W MEMO [PUT /rest/ezMemo/setLayerPosition/users/" +userId + "] ended.");
		return result;
	}
	
	@RequestMapping(value = "/rest/ezMemo/folders/names/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject gwMemoFolderNames(@PathVariable String userId, MemoFolderVO memoFolderVO, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/folders/names/users/" +userId + "] started.");
		
		
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
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/folders/names/users/" +userId + "] ended.");
		return result;
	}
	
	@RequestMapping(value = "/rest/ezMemo/folders/users/{userId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject gwMemoFoldersAdd(@PathVariable String userId, MemoFolderVO memoFolderVO, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [POST /rest/ezMemo/folders/users/" +userId + "] started.");
		
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
		LOGGER.debug("G/W MEMO [POST /rest/ezMemo/folders/users/" +userId + "] ended.");
		return result;
	}
	
	@RequestMapping(value = "/rest/ezMemo/folders/users/{userId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject gwMemoFolderModify(@PathVariable String userId, MemoFolderVO memoFolderVO, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [PUT /rest/ezMemo/folders/users/" +userId + "] started.");
		
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = MOptionService.commonInfoWeb(serverName, request.getParameter("user_id"));
			memoFolderVO.setTenant_id(info.getTenantId());
			
			ezMemoService.modifyMemoFolder(memoFolderVO);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch(Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		LOGGER.debug("G/W MEMO [PUT /rest/ezMemo/folders/users/" +userId + "] ended.");
		return result;
	}
	
	@RequestMapping(value = "/rest/ezMemo/folders/users/{userId}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject gwMemoFolderDelete(@PathVariable String userId, MemoFolderVO memoFolderVO, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [Delete /rest/ezMemo/folders/users/" +userId + "] started.");
		
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = MOptionService.commonInfoWeb(serverName, request.getParameter("user_id"));
			memoFolderVO.setTenant_id(info.getTenantId());
			
			ezMemoService.deleteMemoFolder(memoFolderVO);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch(Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		LOGGER.debug("G/W MEMO [Delete /rest/ezMemo/folders/users/" +userId + "] ended.");
		
		return result;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezMemo/getMemoConfig/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getMemoConfig(@PathVariable String userId, MemoConfigVO memoConfigVO, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/getMemoConfig/users/" +userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			MemoConfigVO configVO = ezMemoService.getMemoConfig(memoConfigVO);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", configVO);
			
		} catch(Exception e) {
			
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/getMemoConfig/users/" +userId + "] ended.");
		return result;
	}
	
	@RequestMapping(value = "/rest/ezMemo/memo-list/{folderId}/memo/{userId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject gwMemoWrite(@PathVariable String folderId, @PathVariable String userId, MemoVO memo, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [POST /rest/ezMemo/memo-list/" + folderId + "/memo/" +userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = MOptionService.commonInfoWeb(serverName, request.getParameter("user_id"));
			memo.setTenant_id(info.getTenantId());
			
			ezMemoService.memoWrite(memo);
			
			result.put("status", "ok");
		} catch(Exception e) {
			result.put("status", "error");
		}
		
		LOGGER.debug("G/W MEMO [POST /rest/ezMemo/memo-list/" + folderId + "/memo/" +userId + "] ended.");
		return result;
	}
							
	@RequestMapping(value = "/rest/ezMemo/config/users/{userId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject gwSetFoldStatus(@PathVariable String userId, MemoConfigVO memoConfigVO, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [PUT /rest/ezMemo/config/users/" +userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = MOptionService.commonInfoWeb(serverName, request.getParameter("user_id"));
			memoConfigVO.setUser_id(userId);
			
			ezMemoService.setFoldStatus(memoConfigVO);
			
			result.put("status", "ok");
		} catch(Exception e) {
			result.put("status", "error");
		}
		
		LOGGER.debug("G/W MEMO [PUT /rest/ezMemo/config/users/" +userId + "] ended.");
		return result;
	}
	
	/*@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezMemo/getMemoConfig/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getMemoConfig(@PathVariable String userId, MemoConfigVO memoConfigVO, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/getMemoConfig/users/" +userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			memoConfigVO = ezMemoService.getMemoConfig(memoConfigVO);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", memoConfigVO);
			
		} catch(Exception e) {
			
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/getMemoConfig/users/" +userId + "] ended.");
		return result;
	}*/
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezMemo/createMemoConfig/users/{userId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject insertMemoConfig(@PathVariable String userId, MemoConfigVO memoConfigVO, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [POST /rest/ezMemo/createMemoConfig/users/" +userId + "] started.");
		
		JSONObject result = new JSONObject();

		try {

			ezMemoService.insertMemoConfig(memoConfigVO);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
			
		} catch(Exception e) {
			
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("G/W MEMO [POST /rest/ezMemo/createMemoConfig/users/" +userId + "] ended.");
		return result;
	}
}
