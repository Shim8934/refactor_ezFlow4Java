package egovframework.ezEKP.ezMemo.service;

import java.util.List;

import egovframework.ezEKP.ezMemo.vo.MemoFolderVO;
import egovframework.ezEKP.ezMemo.vo.MemoConfigVO;
import egovframework.ezEKP.ezMemo.vo.MemoVO;

public interface EzMemoService {
	public int getMemoCount(MemoFolderVO memoFolderVO) throws Exception;
}
