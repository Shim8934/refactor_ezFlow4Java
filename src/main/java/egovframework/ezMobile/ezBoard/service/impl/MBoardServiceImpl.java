package egovframework.ezMobile.ezBoard.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezMobile.ezBoard.dao.MBoardDAO;
import egovframework.ezMobile.ezBoard.service.MBoardService;
import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListHeaderVO;
import egovframework.let.user.login.vo.LoginVO;

@Service("MBoardService")
public class MBoardServiceImpl implements MBoardService {
	private static final Logger logger = LoggerFactory.getLogger(MBoardServiceImpl.class);

	@Resource(name = "MBoardDAO")
	private MBoardDAO mBoardDAO;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	
	
	@Override
	public List<MBoardListHeaderVO> getListHeader(MBoardInfoVO mBoardInfoVO, String lang, int tenantID) throws Exception {
		logger.debug("getListHeader started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", mBoardInfoVO.getBoardID());
		map.put("listType", mBoardInfoVO.getBoardType());
		map.put("lang", lang);
		map.put("tenantID", tenantID);
		
		//모바일은 확장컬럼미사용으로 개발
		
		List<MBoardListHeaderVO> list = mBoardDAO.getListHeader(map);
		
		logger.debug("getListHeader ended.");
		
		return list;
	}

	@Override
	public MBoardInfoVO getBoardInfo(String boardID, LoginVO userInfo) throws Exception {
		MBoardInfoVO mBoardInfoVO = new MBoardInfoVO();
		
		mBoardInfoVO.setSs_board_maxRows(20);
		mBoardInfoVO.setSs_searchBoard_maxRows(10);             

		if (boardID == null || boardID.equals("")) {
			mBoardInfoVO.setBoardName(egovMessageSource.getMessage("ezBoard.t229", userInfo.getLocale()));	
			return mBoardInfoVO;
		}
		
		
		
		return mBoardInfoVO;
	}
	
	@Override
	public MBoardInfoVO getBoardProperty(String boardID, String primary, int tenantID) throws Exception {
		logger.debug("getBoardProperty started. boardID = " + boardID + " || primary = " + primary + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		
		MBoardInfoVO vo = mBoardDAO.getBoardProperty(map);
		
		logger.debug("getBoardProperty ended.");
		
		return vo;
	}
}
