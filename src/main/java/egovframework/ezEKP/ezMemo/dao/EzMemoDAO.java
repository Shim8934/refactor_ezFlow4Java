package egovframework.ezEKP.ezMemo.dao;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezMemo.vo.MemoConfigVO;
import egovframework.ezEKP.ezMemo.vo.MemoFolderVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;


@Repository("EzMemoDAO")
public class EzMemoDAO extends EgovAbstractDAO {
	public int getMemoCount(Map<String, Object> map) throws Exception {
		return (int) select("EzMemoDAO.getMemoCount", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MemoFolderVO> getMemoFolderInfo(Map<String, Object> map) throws Exception {
		return (List<MemoFolderVO>) list("EzMemoDAO.getMemoFolderInfo", map);
	}
	public MemoConfigVO getMemoConfig(Map<String, Object> map) throws Exception {
		return (MemoConfigVO) select("EzMemoDAO.getMemoConfig", map);
	}
	
	public void setMemoConfig(Map<String, Object> map) throws Exception {
		update("EzMemoDAO.setMemoConfig", map);
	}
	
	public void addMemoFolder(Map<String, Object> map) throws Exception {
		insert("EzMemoDAO.addMemoFolder", map);
	}
}
