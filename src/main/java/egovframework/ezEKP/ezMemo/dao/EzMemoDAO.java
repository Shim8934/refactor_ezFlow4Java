package egovframework.ezEKP.ezMemo.dao;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezMemo.vo.MemoConfigVO;
import egovframework.ezEKP.ezMemo.vo.MemoFolderVO;
import egovframework.ezEKP.ezMemo.vo.MemoVO;
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
	
	@SuppressWarnings("unchecked")
	public List<MemoVO> getMemoList(Map<String, Object> map) throws Exception {
		return (List<MemoVO>) list("EzMemoDAO.getMemoList", map);
	}
	
	public void setMemoConfig(Map<String, Object> map) throws Exception {
		update("EzMemoDAO.setMemoConfig", map);
	}

	public void addMemoFolder(Map<String, Object> map) throws Exception {
		insert("EzMemoDAO.addMemoFolder", map);
	}
	
	public void modifyMemoFolder(Map<String, Object> map) throws Exception {
		update("EzMemoDAO.modifyMemoFolder", map);
	}
	
	public void deleteMemos(Map<String, Object> map) throws Exception {
		update("EzMemoDAO.deleteMemos", map);
	}
	
	public void deleteMemoFolder(Map<String, Object> map) throws Exception {
		update("EzMemoDAO.deleteMemoFolder", map);
	}

	public void insertMemo(Map<String, Object> map) throws Exception {
		insert("EzMemoDAO.insertMemo", map);
	}
	
	public void setFoldStatus(Map<String, Object> map) throws Exception {
		update("EzMemoDAO.setFoldStatus", map);
	}
	
	public int getMaxOrder(Map<String, Object> map) throws Exception {
		return (int) select("EzMemoDAO.getMaxOrder", map);
	}
}
