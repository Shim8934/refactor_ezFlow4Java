package egovframework.ezEKP.ezMemo.service;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezMemo.vo.MemoFolderVO;
import egovframework.ezEKP.ezMemo.vo.MemoConfigVO;
import egovframework.ezEKP.ezMemo.vo.MemoVO;

public interface EzMemoService {
	public int getMemoCount(MemoFolderVO memoFolderVO) throws Exception;
	public List<MemoFolderVO> getMemoFolderInfo(MemoFolderVO memoFolderVO) throws Exception;
	public MemoConfigVO getMemoConfig(MemoConfigVO memoConfigVO) throws Exception;
	public void setMemoConfig(MemoConfigVO memoConfigVO) throws Exception;
	public void addMemoFolder(MemoFolderVO memoFolderVO) throws Exception;
	public void modifyMemoFolder(MemoFolderVO memoFolderVO) throws Exception;
	public void deleteMemoFolder(MemoFolderVO memoFolderVO, String folder_ids) throws Exception;
	public List<MemoVO> getMemoList(MemoVO vo, String searchInput, String startDate, String endDate, String folderId, String offset, String orderOption) throws Exception;
	public int memoWrite(MemoVO memo) throws Exception;
	public void insertMemoConfig(MemoConfigVO memoConfigVO) throws Exception;
	public int hasMemoFolder(MemoFolderVO memoFolderVO) throws Exception;
	public void setDefualtMemoFolder(MemoFolderVO memoFolderVO) throws Exception;
	public int getMemoDefaultFolder(MemoFolderVO memoFolderVO) throws Exception;
	public void setMemoDisplay(MemoVO memo, String memo_ids) throws Exception;
	public void setMemoContents(MemoVO memoVO) throws Exception;
	public MemoVO getMemo(MemoVO memoVO) throws Exception;
	public void memoMove(MemoFolderVO memoFolderVO, String memo_ids) throws Exception;
	public void memoDelete(MemoVO memoVO, String memo_ids) throws Exception;
	public void otherModuleCopy(MemoVO memoVO) throws Exception;
	public void setMemoColor(MemoVO memoVO) throws Exception;
	public Map<String, Object> compareOrders(String draggedElId, String compareElId, String userId, MemoConfigVO memoConfigVO);
	public List<MemoVO> getMemoListForReOrder(int draggedMemoOrder,
			int nextMemoOrder, MemoConfigVO memoConfigVO);
	public void setMemoOrders(MemoVO memoVO);
	public void setGadgetConfig(MemoConfigVO memoConfigVO);
}
