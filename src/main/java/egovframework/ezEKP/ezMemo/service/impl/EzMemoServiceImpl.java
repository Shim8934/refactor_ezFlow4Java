package egovframework.ezEKP.ezMemo.service.impl;


import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
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
public class EzMemoServiceImpl extends EgovAbstractServiceImpl implements EzMemoService {
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
		map.put("offset", commonUtil.getMinuteUTC(memoFolderVO.getOffset()));
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

		if (memoConfigVO.getUse_date() > 0) {
			map.put("use_date", memoConfigVO.getUse_date());
		}
		
		if (memoConfigVO.getUse_gadget() > 0) {
			map.put("use_gadget", memoConfigVO.getUse_gadget());
		}
		
		if (memoConfigVO.getFont_size() > 0) {
			map.put("font_size", memoConfigVO.getFont_size());
		}
		
		if (memoConfigVO.getLayer_top() >= 0 && memoConfigVO.getLayer_left() >= 0) {		
			map.put("layer_top", memoConfigVO.getLayer_top());
			map.put("layer_left", memoConfigVO.getLayer_left());
		}
		
		ezMemoDAO.setMemoConfig(map);
		logger.debug("setMemoConfig ended.");
	}
	
	public List<MemoVO> getMemoList(MemoVO vo, String searchInput, String startDate, String endDate, String folderId, String offset, String orderOption) throws Exception {
		logger.debug("getMemoList started.");

		if (!startDate.equals("")) {
			startDate += " 00:00:00";
			endDate += " 23:59:59";
		}
		
		if(!searchInput.equals("")) {
			searchInput = searchInput.replace("\\","\\\\");
			searchInput = searchInput.replace("%", "\\%");
			searchInput = searchInput.replace("_", "\\_");
		}

		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("tenant_id", vo.getTenant_id());
		map.put("company_id", vo.getCompany_id());
		map.put("user_id", vo.getUser_id());
		map.put("searchInput", searchInput);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("folder_id", folderId);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("orderOption", orderOption);
		
		List<MemoVO> memoList = ezMemoDAO.getMemoList(map);

		logger.debug("getMemoList ended.");
		return memoList;
	}
	
	public MemoVO memoWrite(MemoVO memo) throws Exception {
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
		map.put("memo_id", memoId);
		
		MemoVO newMemo = ezMemoDAO.getMemo(map);
		
		logger.debug("memoWrite ended.");
		return newMemo;
	}

	@Override
	public void addMemoFolder(MemoFolderVO memoFolderVO) throws Exception {
		logger.debug("addMemoFolder started.");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoFolderVO.getUser_id());
		map.put("tenant_id", memoFolderVO.getTenant_id());
		map.put("company_id", memoFolderVO.getCompany_id());
		int orders = ezMemoDAO.maxFolderOrders(map);
		
		map.put("folder_name", commonUtil.stripScriptTags(memoFolderVO.getFolder_name()));
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
		map.put("folder_name", commonUtil.stripScriptTags(memoFolderVO.getFolder_name()));
		map.put("folder_id", memoFolderVO.getFolder_id());
		ezMemoDAO.modifyMemoFolder(map);
		logger.debug("modifyMemoFolder ended.");
	}

	@Override
	public void deleteMemoFolder(MemoFolderVO memoFolderVO, String folder_ids) throws Exception {
		logger.debug("deleteMemoFolder started.");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoFolderVO.getUser_id());
		map.put("tenant_id", memoFolderVO.getTenant_id());
		map.put("company_id", memoFolderVO.getCompany_id());
		
		for (String folder_id : folder_ids.split(",")) {
			logger.debug("folderId = " + folder_id);
			map.put("folder_id", folder_id);
			ezMemoDAO.deleteMemos(map);
			ezMemoDAO.deleteMemoFolder(map);
		}
		logger.debug("deleteMemoFolder ended.");
	}

	@Override
	public void insertMemoConfig(MemoConfigVO memoConfigVO) throws Exception {
		logger.debug("insertMemoConfig started");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoConfigVO.getUser_id());
		map.put("tenant_id", memoConfigVO.getTenant_id());
		map.put("company_id", memoConfigVO.getCompany_id());
		map.put("font_size", memoConfigVO.getFont_size());
		map.put("use_date", memoConfigVO.getUse_date());
		map.put("use_gadget", memoConfigVO.getUse_gadget());
		map.put("default_color", memoConfigVO.getDefault_color());
		map.put("gadget_right", memoConfigVO.getGadget_right());
		map.put("gadget_bottom", memoConfigVO.getGadget_bottom());
		map.put("layer_height", memoConfigVO.getLayer_height());
		map.put("layer_left", memoConfigVO.getLayer_left());
		map.put("layer_top", memoConfigVO.getLayer_top());
		map.put("layer_width", memoConfigVO.getLayer_width());
		map.put("full_mode", memoConfigVO.getFull_mode());
		
		ezMemoDAO.insertMemoConfig(map);
		logger.debug("insertMemoConfig ended");
	}

	@Override
	public int hasMemoFolder(MemoFolderVO memoFolderVO) throws Exception {
		logger.debug("hasMemoFolder started");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoFolderVO.getUser_id());
		map.put("tenant_id", memoFolderVO.getTenant_id());
		map.put("company_id", memoFolderVO.getCompany_id());
		int hasMemoFolder = ezMemoDAO.hasMemoFolder(map);
		logger.debug("hasMemoFolder ended");
		return hasMemoFolder;
	}

	
	@Override
	public void setDefualtMemoFolder(MemoFolderVO memoFolderVO, Locale locale) throws Exception {
		logger.debug("setDefaultMemoFolder started");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoFolderVO.getUser_id());
		map.put("tenant_id", memoFolderVO.getTenant_id());
		map.put("company_id", memoFolderVO.getCompany_id());
		map.put("folder_name", egovMessageSource.getMessage("ezMemo.t0065", locale));
		map.put("reg_date", commonUtil.getTodayUTCTime(""));
		map.put("orders", 0);
		map.put("delete_flag", 0);
		ezMemoDAO.setDefaultMemoFolder(map);
		logger.debug("setDefaultMemoFolder ended");
	}
	
	@Override
	public int getMemoDefaultFolder(MemoFolderVO memoFolderVO) throws Exception {
		logger.debug("getMemoDefaultFolder started");
		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoFolderVO.getUser_id());
		map.put("tenant_id", memoFolderVO.getTenant_id());
		map.put("company_id", memoFolderVO.getCompany_id());
		
		int folderId = ezMemoDAO.getMemoDefaultFolder(map);
		
		logger.debug("getMemoDefaultFolder ended");
		return folderId;
	}

	@Override
	public void setMemoDisplay(MemoVO memo, String memo_ids) throws Exception {
		logger.debug("setMemoDisplay started");
		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memo.getUser_id());
		map.put("tenant_id", memo.getTenant_id());
		map.put("company_id", memo.getCompany_id());
		map.put("display_flag", memo.getDisplay_flag());
		
		for (String memo_id : memo_ids.split(",")) {
			logger.debug("memo_id = " + memo_id);
			map.put("memo_id", memo_id);
			ezMemoDAO.setMemoDisplay(map);
		}
		
		ezMemoDAO.setMemoDisplay(map);
		
		logger.debug("setMemoDisplay ended");
	}

	@Override
	public void setMemoContents(MemoVO memoVO) throws Exception {
		logger.debug("setMemoContents start");
		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoVO.getUser_id());
		map.put("tenant_id", memoVO.getTenant_id());
		map.put("company_id", memoVO.getCompany_id());
		map.put("contents", memoVO.getContents());
		map.put("write_date", memoVO.getWrite_date());
		map.put("memo_id", memoVO.getMemo_id());
		
		ezMemoDAO.setMemoContents(map);
		
		logger.debug("setMemoContents end");
	}

	@Override
	public MemoVO getMemo(MemoVO memoVO) throws Exception {
		logger.debug("getMemo started");
		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoVO.getUser_id());
		map.put("tenant_id", memoVO.getTenant_id());
		map.put("company_id", memoVO.getCompany_id());
		map.put("memo_id", memoVO.getMemo_id());

		memoVO = ezMemoDAO.getMemo(map);
		
		logger.debug("getMemo ended");
		return memoVO;
	}
	
	@Override
	public void memoMove(MemoFolderVO memoFolderVO, String memo_ids) throws Exception {
		logger.debug("memoMove started.");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoFolderVO.getUser_id());
		map.put("tenant_id", memoFolderVO.getTenant_id());
		map.put("company_id", memoFolderVO.getCompany_id());
		map.put("folder_id", memoFolderVO.getFolder_id());
		
		for (String memo_id : memo_ids.split(",")) {
			logger.debug("memo_id = " + memo_id);
			map.put("memo_id", memo_id);
			ezMemoDAO.memoMove(map);
		}
		logger.debug("memoDelete ended.");
	}
	
	public void memoDelete(MemoVO memoVO, String memo_ids) throws Exception {
		logger.debug("memoDelete started.");
		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoVO.getUser_id());
		map.put("tenant_id", memoVO.getTenant_id());
		map.put("company_id", memoVO.getCompany_id());
		map.put("delete_date", memoVO.getDelete_date());
		
		for (String memo_id : memo_ids.split(",")) {
			map.put("memo_id", memo_id);
			ezMemoDAO.memoDelete(map);
		}
		
		logger.debug("memoDelete ended.");
	}

	@Override
	public void otherModuleCopy(MemoVO memoVO) throws Exception {
		logger.debug("otherModuleCopy started.");

		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoVO.getUser_id());
		map.put("tenant_id", memoVO.getTenant_id());
		map.put("company_id", memoVO.getCompany_id());
		map.put("folder_id", ezMemoDAO.getMemoDefaultFolder(map));
		map.put("contents", memoVO.getContents());
		map.put("write_date", commonUtil.getTodayUTCTime(""));
		map.put("color_id", memoVO.getColor_id());
		map.put("orders", ezMemoDAO.getMaxOrder(map));
		ezMemoDAO.otherModuleCopy(map);
		
		logger.debug("otherModuleCopy ended.");
	}
	
	public void setMemoColor(MemoVO memoVO) throws Exception {
		logger.debug("setMemoColor started.");

		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoVO.getUser_id());
		map.put("tenant_id", memoVO.getTenant_id());
		map.put("company_id", memoVO.getCompany_id());
	
		map.put("memo_id", memoVO.getMemo_id());
		map.put("color_id", memoVO.getColor_id());
		
		ezMemoDAO.setMemoColor(map);
		
		ezMemoDAO.setDefaultColor(map);
		
		logger.debug("setMemoColor endeded.");
	}
	
	public Map<String, Object> compareOrders(String draggedElId, String compareElId, String userId, MemoConfigVO memoConfigVO) throws Exception {
		logger.debug("comparOrders started.");
		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", userId);
		map.put("tenant_id", memoConfigVO.getTenant_id());
		map.put("company_id", memoConfigVO.getCompany_id());
		map.put("memo_id", Integer.parseInt(draggedElId));
		
		MemoVO draggedMemo = ezMemoDAO.getMemo(map);
		int draggedMemoOrder = draggedMemo.getOrders();
		
		map.remove("memo_id");
		map.put("memo_id", compareElId);
		
		MemoVO nextMemo = ezMemoDAO.getMemo(map);
		int compareMemoOrder = nextMemo.getOrders();
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		if (draggedMemoOrder > compareMemoOrder) {
			
			result.put("result", 1);
			
		} else if (draggedMemoOrder < compareMemoOrder) {
			
			result.put("result", 0);
		}
		result.put("draggedMemoOrder", draggedMemoOrder);
		result.put("compareMemoOrder", compareMemoOrder);
		
		logger.debug("comparOrders ended.");
		return result;
	}

	@Override
	public List<MemoVO> getMemoListForReOrder(int draggedMemoOrder, int nextMemoOrder, MemoConfigVO memoConfigVO) throws Exception {
		logger.debug("getMemoListForReOrder ended.");
		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoConfigVO.getUser_id());
		map.put("tenant_id", memoConfigVO.getTenant_id());
		map.put("company_id", memoConfigVO.getCompany_id());
		
		if (draggedMemoOrder > nextMemoOrder) {
			map.put("bigger_order", draggedMemoOrder);
			map.put("smaller_order", nextMemoOrder);
			
		} else if (draggedMemoOrder < nextMemoOrder) {
			map.put("bigger_order", nextMemoOrder);
			map.put("smaller_order", draggedMemoOrder);
		}
		
		List<MemoVO> memoList = ezMemoDAO.getMemoListForReOrder(map);
		
		logger.debug("getMemoListForReOrder ended.");
		return memoList;
	}

	@Override
	public void setMemoOrders(MemoVO memoVO) throws Exception {
		logger.debug("setMemoOrders started");
		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoVO.getUser_id());
		map.put("tenant_id", memoVO.getTenant_id());
		map.put("company_id", memoVO.getCompany_id());

		map.put("orders", memoVO.getOrders());
		map.put("memo_id", memoVO.getMemo_id());

		ezMemoDAO.setMemoOrders(map);
		
		logger.debug("setMemoOrders ended");
	}

	@Override
	public void setGadgetConfig(MemoConfigVO memoConfigVO) throws Exception {
		logger.debug("setGadgetConfig started.");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoConfigVO.getUser_id());
		map.put("tenant_id", memoConfigVO.getTenant_id());
		map.put("company_id", memoConfigVO.getCompany_id());

		// gadget 위치 back-end 예외처리, 초기화
		if(memoConfigVO.getGadget_bottom() < 0 || memoConfigVO.getGadget_right() < 0) {
			map.put("gadget_bottom", 15);
			map.put("gadget_right", 15);
		} else { // 정상
			map.put("gadget_bottom", memoConfigVO.getGadget_bottom());
			map.put("gadget_right", memoConfigVO.getGadget_right());
		}
		ezMemoDAO.setGadgetConfig(map);
		logger.debug("setGadgetConfig ended.");
	}

	@Override
	public void setMemoLayerMode(MemoConfigVO memoConfigVO) {
		logger.debug("setMemoLayerMode started");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoConfigVO.getUser_id());
		map.put("tenant_id", memoConfigVO.getTenant_id());
		map.put("company_id", memoConfigVO.getCompany_id());
		map.put("full_mode", memoConfigVO.getFull_mode());
		
		ezMemoDAO.setMemoLayerMode(map);

		logger.debug("setMemoLayerMode ended");
	}

	@Override
	public void setMemoLayerArea(MemoConfigVO memoConfigVO) throws Exception {
		logger.debug("setLayerArea started.");
	
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoConfigVO.getUser_id());
		map.put("tenant_id", memoConfigVO.getTenant_id());
		map.put("company_id", memoConfigVO.getCompany_id());

		if (memoConfigVO.getLayer_width() >= 330 && memoConfigVO.getLayer_height() >= 370) {
			map.put("layer_width", memoConfigVO.getLayer_width());
			map.put("layer_height", memoConfigVO.getLayer_height());
		}  else {
			return;
		}
		
		ezMemoDAO.setMemoLayerArea(map);

		logger.debug("setLayerArea ended");
	}

	@Override
	public void setDetailMemoArea(MemoConfigVO memoConfig) {
		logger.debug("setDetailMemoArea started.");
		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoConfig.getUser_id());
		map.put("tenant_id", memoConfig.getTenant_id());
		map.put("company_id", memoConfig.getCompany_id());

		if (memoConfig.getB_memo_height() > 0 && memoConfig.getB_memo_width() > 0) {
			map.put("big_memo_height", memoConfig.getB_memo_height());
			map.put("big_memo_width", memoConfig.getB_memo_width());
			
			ezMemoDAO.setDetailMemoArea(map);
		}

		logger.debug("setDetailMemoArea ended");
	}

	@Override
	public void setDetailMemoPosition(MemoConfigVO memoConfig) {
		logger.debug("setDetailMemoPosition started.");
		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoConfig.getUser_id());
		map.put("tenant_id", memoConfig.getTenant_id());
		map.put("company_id", memoConfig.getCompany_id());

		if (memoConfig.getB_memo_top() >= 0 && memoConfig.getB_memo_left() >= 0) {
			map.put("big_memo_top", memoConfig.getB_memo_top());
			map.put("big_memo_left", memoConfig.getB_memo_left());
			
			ezMemoDAO.setDetailMemoPostion(map);
		}

		logger.debug("setDetailMemoPosition ended");
	}

	@Override
	public void setDetailMemoStatus(MemoConfigVO memoConfig) {
		logger.debug("setDetailMemoStatus started.");
		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoConfig.getUser_id());
		map.put("tenant_id", memoConfig.getTenant_id());
		map.put("company_id", memoConfig.getCompany_id());

		if (memoConfig.getMemo_id() > 0) {
			map.put("memo_id", memoConfig.getMemo_id());
		}
		map.put("b_memo_status", memoConfig.getB_memo_status());
		
		ezMemoDAO.setDetailMemoStatus(map);

		logger.debug("setDetailMemoStatus ended");
	}
}
