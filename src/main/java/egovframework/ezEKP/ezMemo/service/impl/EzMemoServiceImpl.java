package egovframework.ezEKP.ezMemo.service.impl;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezMemo.dao.EzMemoDAO;
import egovframework.ezEKP.ezMemo.service.EzMemoService;
import egovframework.ezEKP.ezMemo.vo.MemoConfigVO;
import egovframework.ezEKP.ezMemo.vo.MemoFolderVO;
import egovframework.ezEKP.ezMemo.vo.MemoVO;
import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzMemoService")
public class EzMemoServiceImpl implements EzMemoService {
private static final Logger logger = LoggerFactory.getLogger(EzMemoServiceImpl.class);
	
	@Resource(name="EzMemoDAO")
	private EzMemoDAO ezMemoDAO;
	
	@Resource(name = "EzOrganDAO")
	private EzOrganDAO ezOrganDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	

	@Override
	public int getMemoCount(MemoFolderVO memoFolderVO) throws Exception {
		logger.debug("getMemoCount started.");
		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoFolderVO.getUser_id());
		map.put("tenant_id", memoFolderVO.getTenant_id());
		map.put("company_id", memoFolderVO.getCompany_id());
		int memoCount = ezMemoDAO.getMemoCount(map);
		
		logger.debug("getMemoCount ended.");
		return memoCount;
	}

	@Override
	public List<MemoFolderVO> getMemoFolderInfo(MemoFolderVO memoFolderVO) throws Exception {
		logger.debug("getMemoFolderInfo started.");
		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoFolderVO.getUser_id());
		map.put("tenant_id", memoFolderVO.getTenant_id());
		map.put("company_id", memoFolderVO.getCompany_id());
		List<MemoFolderVO> memoFolders = ezMemoDAO.getMemoFolderInfo(map);
		
		logger.debug("getMemoFolderInfo ended.");

		return memoFolders;
	}
	@Override
	public MemoConfigVO getMemoConfig(MemoConfigVO memoConfigVO) throws Exception {
		logger.debug("getMemoConfig started.");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoConfigVO.getUser_id());
		map.put("tenant_id", memoConfigVO.getTenant_id());
		map.put("company_id", memoConfigVO.getCompany_id());
		memoConfigVO = ezMemoDAO.getMemoConfig(map);
		logger.debug("getMemoConfig ended.");
		return memoConfigVO;
	}


	@Override
	public void setMemoConfig(MemoConfigVO memoConfigVO) throws Exception {
		logger.debug("setMemoConfig started.");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoConfigVO.getUser_id());
		map.put("tenant_id", memoConfigVO.getTenant_id());
		map.put("company_id", memoConfigVO.getCompany_id());

		map.put("use_date", memoConfigVO.getUse_date());
		map.put("use_gadget", memoConfigVO.getUse_gadget());
		
		if (memoConfigVO.getLayer_width() > 0 && memoConfigVO.getLayer_height() > 0) {

			map.put("layer_width", memoConfigVO.getLayer_width());
			map.put("layer_height", memoConfigVO.getLayer_height());

		} else if (memoConfigVO.getLayer_top() > 0 && memoConfigVO.getLayer_left() > 0) {
			
			map.put("layer_top", memoConfigVO.getLayer_top());
			map.put("layer_left", memoConfigVO.getLayer_left());
		}
		
		
		ezMemoDAO.setMemoConfig(map);
		logger.debug("setMemoConfig ended.");
	}
	
	public List<MemoVO> getMemoList(MemoVO vo, String searchInput, String startDate, String endDate, String folderId, String searchType, String offset) throws Exception {
		logger.debug("getMemoList started.");
		
		if (!startDate.equals("")) {
			startDate += " 00:00:00";
			endDate += " 23:59:59";
		}

		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("tenant_id", vo.getTenant_id());
		map.put("company_id", vo.getCompany_id());
		map.put("user_id", vo.getUser_id());
		map.put("searchInput", searchInput);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("folder_id", folderId);
		map.put("searchType", searchType);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		
		List<MemoVO> memoList = ezMemoDAO.getMemoList(map);

		logger.debug("getMemoList ended.");
		return memoList;
	}
	
	public int memoWrite(MemoVO memo) throws Exception {
		logger.debug("memoWrite started.");
		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("tenant_id", memo.getTenant_id());
		map.put("company_id", memo.getCompany_id());
		map.put("user_id", memo.getUser_id());
		map.put("folder_id", memo.getFolder_id());
		map.put("write_date", memo.getWrite_date());
		map.put("color_id", memo.getColor_id());

		int orders = ezMemoDAO.getMaxOrder(map);
		
		map.put("orders", orders);
		
		int memoId = ezMemoDAO.insertMemo(map);
		
		logger.debug("memoWrite ended.");
		return memoId;
	}

	@Override
	public void addMemoFolder(MemoFolderVO memoFolderVO) throws Exception {
		logger.debug("addMemoFolder started.");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoFolderVO.getUser_id());
		map.put("tenant_id", memoFolderVO.getTenant_id());
		map.put("company_id", memoFolderVO.getCompany_id());
		int orders = ezMemoDAO.maxFolderOrders(map);
		
		map.put("folder_name", memoFolderVO.getFolder_name());
		map.put("reg_date", commonUtil.getTodayUTCTime(""));
		map.put("orders", orders);
		ezMemoDAO.addMemoFolder(map);
		logger.debug("addMemoFolder ended.");
	}

	@Override
	public void modifyMemoFolder(MemoFolderVO memoFolderVO) throws Exception {
		logger.debug("modifyMemoFolder started.");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoFolderVO.getUser_id());
		map.put("tenant_id", memoFolderVO.getTenant_id());
		map.put("company_id", memoFolderVO.getCompany_id());
		map.put("folder_name", memoFolderVO.getFolder_name());
		map.put("folder_id", memoFolderVO.getFolder_id());
		ezMemoDAO.modifyMemoFolder(map);
		logger.debug("modifyMemoFolder ended.");
	}

	@Override
	public void deleteMemoFolder(MemoFolderVO memoFolderVO) throws Exception {
		logger.debug("deleteMemoFolder started.");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoFolderVO.getUser_id());
		map.put("tenant_id", memoFolderVO.getTenant_id());
		map.put("company_id", memoFolderVO.getCompany_id());
		map.put("folder_name", memoFolderVO.getFolder_name());
		map.put("folder_id", memoFolderVO.getFolder_id());
		ezMemoDAO.deleteMemos(map);
		ezMemoDAO.deleteMemoFolder(map);
		logger.debug("deleteMemoFolder ended.");
	}

	@Override
	public void insertMemoConfig(MemoConfigVO memoConfigVO) {
		logger.debug("insertMemoConfig start");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoConfigVO.getUser_id());
		map.put("tenant_id", memoConfigVO.getTenant_id());
		map.put("company_id", memoConfigVO.getCompany_id());
		map.put("font_size", memoConfigVO.getFont_size());
		map.put("use_date", memoConfigVO.getUse_date());
		map.put("use_gadget", memoConfigVO.getUse_gadget());
		map.put("default_color", memoConfigVO.getDefault_color());
		map.put("color_name", memoConfigVO.getColor_name());
		map.put("gadget_right", memoConfigVO.getGadget_right());
		map.put("gadget_bottom", memoConfigVO.getGadget_bottom());
		map.put("layer_height", memoConfigVO.getLayer_height());
		map.put("layer_left", memoConfigVO.getLayer_left());
		map.put("layer_top", memoConfigVO.getLayer_top());
		map.put("layer_width", memoConfigVO.getLayer_width());
		
		ezMemoDAO.insertMemoConfig(map);
		logger.debug("insertMemoConfig end");
	}

	@Override
	public int hasMemoFolder(MemoFolderVO memoFolderVO) throws Exception {
		logger.debug("hasMemoFolder start");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoFolderVO.getUser_id());
		map.put("tenant_id", memoFolderVO.getTenant_id());
		map.put("company_id", memoFolderVO.getCompany_id());
		int hasMemoFolder = ezMemoDAO.hasMemoFolder(map);
		logger.debug("hasMemoFolder end");
		return hasMemoFolder;
	}

	
	@Override
	public void setDefualtMemoFolder(MemoFolderVO memoFolderVO) throws Exception {
		logger.debug("setDefaultMemoFolder start");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoFolderVO.getUser_id());
		map.put("tenant_id", memoFolderVO.getTenant_id());
		map.put("company_id", memoFolderVO.getCompany_id());
		map.put("folder_name", "기본메모함");
		map.put("reg_date", commonUtil.getTodayUTCTime(""));
		map.put("orders", 0);
		map.put("icon_id", 1);
		map.put("delete_flag", 0);
		ezMemoDAO.setDefaultMemoFolder(map);
		logger.debug("setDefaultMemoFolder end");
	}
	
	@Override
	public int getMemoDefaultFolder(MemoFolderVO memoFolderVO) {
		logger.debug("getMemoDefaultFolder start");
		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoFolderVO.getUser_id());
		map.put("tenant_id", memoFolderVO.getTenant_id());
		map.put("company_id", memoFolderVO.getCompany_id());
		
		int folderId = ezMemoDAO.getMemoDefaultFolder(map);
		
		logger.debug("getMemoDefaultFolder end");
		return folderId;
	}
	
}
