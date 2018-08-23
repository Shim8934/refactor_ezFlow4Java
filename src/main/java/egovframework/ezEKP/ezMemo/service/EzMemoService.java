package egovframework.ezEKP.ezMemo.service;

import java.util.List;

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
	public void deleteMemoFolder(MemoFolderVO memoFolderVO) throws Exception;
	public List<MemoVO> getMemoList(MemoVO vo, String searchInput, String startDate, String endDate, String folderId) throws Exception;
	public void memoWrite(MemoVO memo) throws Exception;
	public void setFoldStatus(MemoConfigVO memoConfigVO) throws Exception;
	public void insertMemoConfig(MemoConfigVO memoConfigVO);
}
