package egovframework.ezEKP.ezMemo.web;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.dogfoot.hwplib.object.bodytext.paragraph.memo.Memo;

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
	public JSONObject gwMemoList(@PathVariable String userId, MemoVO vo, MemoConfigVO memoConfigVO, MemoFolderVO memoFolderVO, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/memo-list/users/" +userId + "] started.");

		JSONObject result = new JSONObject();
		String searchInput = request.getParameter("searchInput");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String folderId = request.getParameter("folder_id");
		String searchType = request.getParameter("searchType");
		String companyId = request.getParameter("company_id");
		int tenantId = Integer.parseInt(request.getParameter("tenant_id"));
		String offset = request.getParameter("offset");
		
		vo.setUser_id(userId);
		memoFolderVO.setUser_id(userId);
		memoFolderVO.setCompany_id(companyId);
		memoFolderVO.setTenant_id(tenantId);
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = MOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			List<MemoVO> memoList = ezMemoService.getMemoList(vo, searchInput, startDate, endDate, folderId, searchType, offset);
			MemoConfigVO config = ezMemoService.getMemoConfig(memoConfigVO);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
			result.put("memoList", memoList);
			result.put("colorList", config.getColor_name());
			result.put("defaultColor", config.getDefault_color()-1);
			result.put("folderId", folderId);
		} catch(Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/memo-list/users/" +userId + "] ended.");
		return result;
	}
	
	@RequestMapping(value = "/rest/ezMemo/memo-list/memo/{memoId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject gwMemoModify(@PathVariable String memoId, MemoVO memoVO, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [PUT /rest/ezMemo/memo-list/memo/" + memoId+ "] started.");
		
		JSONObject result = new JSONObject();
		
		LOGGER.debug("G/W MEMO [PUT /rest/ezMemo/memo-list/memo/" + memoId + "] ended.");
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = MOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			ezMemoService.setMemoContents(memoVO);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch(Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
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
			memoFolderVO.setOffset(info.getOffSet());
			
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
		String folder_ids = request.getParameter("folder_ids");
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = MOptionService.commonInfoWeb(serverName, request.getParameter("user_id"));
			memoFolderVO.setTenant_id(info.getTenantId());
			
			ezMemoService.deleteMemoFolder(memoFolderVO, folder_ids);
			
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
	public JSONObject gwMemoWrite(@PathVariable String folderId, @PathVariable String userId, MemoVO memo, MemoConfigVO memoConfigVO, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [POST /rest/ezMemo/memo-list/" + folderId + "/memo/" +userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = MOptionService.commonInfoWeb(serverName, request.getParameter("user_id"));
			memo.setTenant_id(info.getTenantId());
			
			MemoConfigVO configVO = ezMemoService.getMemoConfig(memoConfigVO);
			memo.setColor_id(configVO.getDefault_color());
			
			int memoId = ezMemoService.memoWrite(memo);
			
			result.put("status", "ok");
			result.put("memoId", memoId);
		} catch(Exception e) {
			result.put("status", "error");
		}
		
		LOGGER.debug("G/W MEMO [POST /rest/ezMemo/memo-list/" + folderId + "/memo/" +userId + "] ended.");
		return result;
	}						
	
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
	
	@RequestMapping(value = "/rest/ezMemo/folders/check", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject hasMemoFolder(MemoFolderVO memoFolderVO, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [POST /rest/ezMemo/folders/check started.");
		
		JSONObject result = new JSONObject();

		try {

			int hasMemoFolder = ezMemoService.hasMemoFolder(memoFolderVO);
			if(hasMemoFolder==0) {
				ezMemoService.setDefualtMemoFolder(memoFolderVO);
			}
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
			
		} catch(Exception e) {
			
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("G/W MEMO [POST /rest/ezMemo/folders/check started.");
		return result;
	}
	
	@RequestMapping(value = "/rest/ezMemo/memo-display/memo/{memoId}/users/{userId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject memoDisplay(@PathVariable String memoId, @PathVariable String userId, MemoConfigVO memoConfigVO, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [POST /rest/ezMemo/memo-display/memo/" + memoId + "/memo/" +userId + "] started.");
		
		JSONObject result = new JSONObject();
		
		MemoVO memo = new MemoVO();
		memo.setUser_id(userId);
		memo.setMemo_id(Integer.parseInt(memoId));
		memo.setCompany_id(memoConfigVO.getCompany_id());
		memo.setTenant_id(memoConfigVO.getTenant_id());

		try {
			ezMemoService.setMemoDisplay(memo);
		
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
			
		} catch(Exception e) {
			
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("G/W MEMO [POST /rest/ezMemo/memo-display/memo/" + memoId + "/memo/" +userId + "] ended.");
		return result;
	}
	
	@RequestMapping(value = "/rest/ezMemo/memo-detail/memo/{memoId}/user/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8") 
	public JSONObject getMemoDetail(@PathVariable String memoId, @PathVariable String userId, MemoConfigVO memoConfigVO, HttpServletRequest request) throws Exception { 
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/memo-detail/memo/" + memoId + "/memo/" +userId + "] started."); 
	 
		JSONObject result = new JSONObject(); 
		 
		MemoVO memo = new MemoVO(); 
		memo.setUser_id(userId); 
		memo.setMemo_id(Integer.parseInt(memoId)); 
		memo.setCompany_id(memoConfigVO.getCompany_id()); 
		memo.setTenant_id(memoConfigVO.getTenant_id()); 
		 
		try { 
			//ezMemoService.setMemoDisplay(memo); 
			memo = ezMemoService.getMemo(memo); 
			MemoConfigVO config = ezMemoService.getMemoConfig(memoConfigVO);
			result.put("status", "ok"); 
			result.put("code", 0); 
			result.put("data", memo); 
			result.put("colorList", config.getColor_name());
			 
		} catch(Exception e) { 
		 
			result.put("code", 1); 
			result.put("status", "error"); 
			result.put("data", ""); 
		} 
		 
		LOGGER.debug("G/W MEMO [GET /rest/ezMemo/memo-detail/memo/" + memoId + "/memo/" +userId + "] ended."); 
		 
		return result; 
	}
	
	@RequestMapping(value = "/rest/ezMemo/move/folder/{folder_id}/users/{userId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject gwMemoMove(@PathVariable String folder_id, @PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("G/W MEMO [POST /rest/ezMemo/move/folder/" + folder_id + "/users/" +userId + "] started.");

		JSONObject result = new JSONObject();
		String memo_ids = request.getParameter("memo_ids");
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = MOptionService.commonInfoWeb(serverName, request.getParameter("user_id"));
			MemoFolderVO memoFolderVO = new MemoFolderVO();
			memoFolderVO.setUser_id(info.getUserId());
			memoFolderVO.setCompany_id(info.getCompanyId());
			memoFolderVO.setTenant_id(info.getTenantId());
			memoFolderVO.setFolder_id(Integer.parseInt(folder_id));
			
			ezMemoService.memoMove(memoFolderVO, memo_ids);
		
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
			
		} catch(Exception e) {
			
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		LOGGER.debug("G/W MEMO [POST /rest/ezMemo/move/folder/" + folder_id + "/users/" +userId + "] ended.");

		return result;
	}
}
