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
		ezMemoDAO.setMemoConfig(map);
		logger.debug("setMemoConfig ended.");
	}

}
