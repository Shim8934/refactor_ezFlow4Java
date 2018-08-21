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
	
	public List<MemoVO> getMemoList(MemoVO vo, String order, String searchInput, String startDate, String endDate) throws Exception {
		logger.debug("getMemoList started.");

		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("tenant_id", vo.getTenant_id());
		map.put("company_id", vo.getCompany_id());
		map.put("user_id", vo.getUser_id());
		
		List<MemoVO> memoList = ezMemoDAO.getMemoList(map);

		logger.debug("getMemoList ended.");
		return memoList;
	}

	@Override
	public void addMemoFolder(MemoFolderVO memoFolderVO) throws Exception {
		logger.debug("addMemoFolder started.");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", memoFolderVO.getUser_id());
		map.put("tenant_id", memoFolderVO.getTenant_id());
		map.put("company_id", memoFolderVO.getCompany_id());
		map.put("folder_name", memoFolderVO.getFolder_name());
		map.put("reg_date", commonUtil.getTodayUTCTime(""));
		ezMemoDAO.addMemoFolder(map);
		logger.debug("addMemoFolder ended.");
	}
}
