package egovframework.ezEKP.ezMemo.dao;


import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezMemo.vo.MemoConfigVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;


@Repository("EzMemoDAO")
public class EzMemoDAO extends EgovAbstractDAO {
	public int getMemoCount(Map<String, Object> map) throws Exception {
		return (int) select("EzMemoDAO.getMemoCount", map);
	}
	
	public MemoConfigVO getMemoConfig(MemoConfigVO memoConfigVO) throws Exception {
		return (MemoConfigVO) select("EzMemoDAO.getMemoConfig", memoConfigVO);
	}
	
	public void setMemoConfig(MemoConfigVO memoConfigVO) throws Exception {
		update("EzMemoDAO.setMemoConfig", memoConfigVO);
	}
}
