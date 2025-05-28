package egovframework.ezEKP.ezMemo.dao;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezMemo.vo.MemoConfigVO;
import egovframework.ezEKP.ezMemo.vo.MemoFolderVO;
import egovframework.ezEKP.ezMemo.vo.MemoVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;


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

	public int insertMemo(Map<String, Object> map) throws Exception {
		return (int) insert("EzMemoDAO.insertMemo", map);
	}
	
	public void setFoldStatus(Map<String, Object> map) throws Exception {
		update("EzMemoDAO.setFoldStatus", map);
	}
	
	public int getMaxOrder(Map<String, Object> map) throws Exception {
		return (int) select("EzMemoDAO.getMaxOrder", map);
	}

	public void insertMemoConfig(Map<String, Object> map) {
		insert("EzMemoDAO.insertMemoConfig", map);
	}

	public int hasMemoFolder(Map<String, Object> map) {
		return (int) select("EzMemoDAO.hasMemoFolder", map);
	}
	
	public void setDefaultMemoFolder(Map<String, Object> map) {
		insert("EzMemoDAO.setDefaultMemoFolder", map);
	}
	
	public int getMemoDefaultFolder(Map<String, Object> map) {
		return (int) select("EzMemoDAO.getMemoDefaultFolder", map);
	}

	public MemoVO getMemo(Map<String, Object> map) {
		return (MemoVO) select("EzMemoDAO.getMemo", map);
	}

	public void setMemoDisplay(Map<String, Object> map) {
		update ("EzMemoDAO.setMemoDisplay", map);
	}

	public void setMemoContents(Map<String, Object> map) {
		update("EzMemoDAO.setMemoContents", map);
	}
	
	public int maxFolderOrders(Map<String, Object> map) {
		return (int) select("EzMemoDAO.maxFolderOrders", map);
	}
	
	public void memoMove(Map<String, Object> map) {
		update("EzMemoDAO.memoMove", map);
	}

	public void memoDelete(Map<String, Object> map) {
		update("EzMemoDAO.memoDelete", map);
	}

	public void otherModuleCopy(Map<String, Object> map) {
		insert("EzMemoDAO.otherModuleCopy", map);
	}

	public void setMemoColor(Map<String, Object> map) {
		update("EzMemoDAO.setMemoColor", map);
	}

	public void setDefaultColor(Map<String, Object> map) {
		update("EzMemoDAO.setDefaultColor", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MemoVO> getMemoListForReOrder(Map<String, Object> map) {
		return (List<MemoVO>)list("EzMemoDAO.getMemoListForReOrder", map);
	}

	public void setMemoOrders(Map<String, Object> map) {
		update("EzMemoDAO.setMemoOrders", map);
	}

	public void setGadgetConfig(Map<String, Object> map) {
		update("EzMemoDAO.setGadgetConfig", map);
	}
	
	public void setMemoLayerMode(Map<String, Object> map) {
		update("EzMemoDAO.setMemoLayerMode", map);
	}
	
	public void setMemoLayerArea(Map<String, Object> map) {
		update("EzMemoDAO.setMemoLayerArea", map);
	}

	public void setDetailMemoArea(Map<String, Object> map) {
		update("EzMemoDAO.setDetailMemoArea", map);
	}

	public void setDetailMemoPostion(Map<String, Object> map) {
		update("EzMemoDAO.setDetailMemoPostion", map);
	}

	public void setDetailMemoStatus(Map<String, Object> map) {
		update("EzMemoDAO.setDetailMemoStatus", map);
	}
}
