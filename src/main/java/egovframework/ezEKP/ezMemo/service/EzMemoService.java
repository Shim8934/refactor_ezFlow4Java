package egovframework.ezEKP.ezMemo.service;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezMemo.vo.MemoFolderVO;
import egovframework.ezEKP.ezMemo.vo.MemoConfigVO;
import egovframework.ezEKP.ezMemo.vo.MemoVO;

public interface EzMemoService {
	/**
	 * User가 가진 Memo의 수를 가져온다.
	 * @param MemoFolderVO
	 * @return memoCount		메모 갯수
	 * @throws Exception
	 */
	public int getMemoCount(MemoFolderVO memoFolderVO) throws Exception;
	
	/**
	 * User가 가진 Folder의 정보를 가져온다.
	 * @param MemoFolderVO
	 * @return List<MemoFolderVO>
	 * @throws Exception
	 */
	public List<MemoFolderVO> getMemoFolderInfo(MemoFolderVO memoFolderVO) throws Exception;
	
	/**
	 * User가 가진 Memo의 설정을 가져온다.
	 * @param MemoConfigVO
	 * @return User의 MemoConfigVO
	 * @throws Exception
	 */
	public MemoConfigVO getMemoConfig(MemoConfigVO memoConfigVO) throws Exception;
	
	/**
	 * User의 Memo 설정을 변경한다.
	 * @param MemoConfigVO
	 * @throws Exception
	 */
	public void setMemoConfig(MemoConfigVO memoConfigVO) throws Exception;
	
	/**
	 * User의 Folder(메모분류)를 추가한다.
	 * @param MemoFolderVO
	 * @throws Exception
	 */
	public void addMemoFolder(MemoFolderVO memoFolderVO) throws Exception;
	
	/**
	 * User의 Folder(메모분류) 정보를 수정한다.
	 * @param MemoFolderVO
	 * @throws Exception
	 */
	public void modifyMemoFolder(MemoFolderVO memoFolderVO) throws Exception;
	
	/**
	 * User의 Folder(메모분류)를 삭제한다.
	 * @param MemoFolderVO
	 * @param folder_ids	폴더아이디
	 * @throws Exception
	 */
	public void deleteMemoFolder(MemoFolderVO memoFolderVO, String folder_ids) throws Exception;
	
	/**
	 * User가 가진 Memo를 조회한다.
	 * @param MemoVO
	 * @param searchInput 		검색 내용
	 * @param startDate 			검색 시작일
	 * @param endDate 			검색 종료일
	 * @param folderId 				폴더아이디
	 * @param offset
	 * @param orderOption 		정렬기준
	 * @return List<MemoVO>
	 * @throws Exception
	 */
	public List<MemoVO> getMemoList(MemoVO vo, String searchInput, String startDate, String endDate, String folderId, String offset, String orderOption) throws Exception;
	
	/**
	 * Memo를 추가하여 저장한다.
	 * @param MemoVO
	 * @throws Exception
	 */
	public MemoVO memoWrite(MemoVO memo) throws Exception;
	
	/**
	 * User의 Memo 설정을 추가한다.
	 * @param MemoConfigVO
	 * @throws Exception
	 */
	public void insertMemoConfig(MemoConfigVO memoConfigVO) throws Exception;
	
	/**
	 * User가 가진 folder의 수를 계산한다.
	 * @param MemoFolderVO
	 * @return folder 갯수
	 * @throws Exception
	 */
	public int hasMemoFolder(MemoFolderVO memoFolderVO) throws Exception;
	
	/**
	 * User가 최초 접속자인 경우 기본메모함을 생성해준다. 
	 * @param MemoFolderVO
	 * @throws Exception
	 */
	public void setDefualtMemoFolder(MemoFolderVO memoFolderVO) throws Exception;
	
	/**
	 * User가 가진 기본메모함의 folderID 정보를 가져온다.
	 * @param MemoFolderVO
	 * @return User의 folderID
	 * @throws Exception
	 */
	public int getMemoDefaultFolder(MemoFolderVO memoFolderVO) throws Exception;
	
	/**
	 * User가 선택한 Memo의 보기 상태를 변경한다. 보기 상태는 숨김, 나타내기 두가지가 있다.
	 * @param MemoVO
	 * @param memo_ids 		메모 아이디의 리스트
	 * @throws Exception
	 */
	public void setMemoDisplay(MemoVO memo, String memo_ids) throws Exception;
	
	/**
	 * User가 수정한 Memo를 저장한다.
	 * @param MemoVO
	 * @throws Exception
	 */
	public void setMemoContents(MemoVO memoVO) throws Exception;
	
	/**
	 * User가 가진 특정 MemoVO를 가져온다.
	 * @param MemoVO
	 * @return MemoVO
	 * @throws Exception
	 */
	public MemoVO getMemo(MemoVO memoVO) throws Exception;
	
	/**
	 * User가 선택한 Memo를 선택한 folder로 분류를 이동한다.
	 * @param MemoFolderVO
	 * @param memo_ids			메모 아이디의 리스트
	 * @throws Exception
	 */
	public void memoMove(MemoFolderVO memoFolderVO, String memo_ids) throws Exception;
	
	/**
	 * User가 가진 Memo를 삭제한다.
	 * @param MemoVO
	 * @param memo_ids			메모 아이디의 리스트
	 * @throws Exception
	 */
	public void memoDelete(MemoVO memoVO, String memo_ids) throws Exception;
	
	/**
	 * 다른 모듈(메일)에서 메모를 추가한다.
	 * @param MemoVO
	 * @throws Exception
	 */
	public void otherModuleCopy(MemoVO memoVO) throws Exception;
	
	/**
	 * User가 선택한 Memo의 색상과 기본 색상을 변경한다.
	 * @param MemoVO
	 * @throws Exception
	 */
	public void setMemoColor(MemoVO memoVO) throws Exception;
	
	/**
	 * User가 선택한 Memo와 drag&drop 이벤트 후 놓인 자리의 기존 Memo 정보를 비교한다.
	 * @param draggedElId				User가 선택한 메모 아이디
	 * @param compareElId				User가 놓은 위치의 기존 메모 아이디
	 * @param userId
	 * @param MemoConfigVO
	 * @return Map<String, Object> - result : 선택한 Memo의 위치가 이동한 방향(앞이면 1, 뒤이면 0), 
	 * 												draggedMemoOrder : User가 선택한 메모의 order, 
	 * 												compareMemoOrder : User가 놓은 위치의 기존 메모 order
	 * @throws Exception
	 */
	public Map<String, Object> compareOrders(String draggedElId, String compareElId, String userId, MemoConfigVO memoConfigVO) throws Exception;
	
	/**
	 * User가 선택한 Memo와 drag&drop 이벤트 후 놓인 위치 사이의 MemoList를 가져온다
	 * @param draggedMemoOrder		User가 선택한 메모 아이디
	 * @param nextMemoOrder				User가 놓은 위치의 기존 메모 아이디
	 * @param MemoConfigVO
	 * @return List<MemoVO>
	 * @throws Exception
	 */
	public List<MemoVO> getMemoListForReOrder(int draggedMemoOrder, int nextMemoOrder, MemoConfigVO memoConfigVO) throws Exception;
	
	/**
	 * User의 Memo 순서를 변경한다.
	 * @param MemoVO
	 * @throws Exception
	 */
	public void setMemoOrders(MemoVO memoVO) throws Exception;
	
	/**
	 * User가 가진 Memo Gadget의 정보를 변경한다.
	 * @param MemoConfigVO
	 * @throws Exception
	 */
	public void setGadgetConfig(MemoConfigVO memoConfigVO) throws Exception;

	
	/**
	 * 메모 레이어 창모드,전체모드 플래그 저장
	 * @param memoConfigVO
	 * @throws Exception
	 */
	public void setMemoLayerMode(MemoConfigVO memoConfigVO) throws Exception;
}
