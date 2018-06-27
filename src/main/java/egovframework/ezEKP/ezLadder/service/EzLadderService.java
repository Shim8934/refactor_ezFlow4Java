package egovframework.ezEKP.ezLadder.service;

import java.util.List;

import egovframework.ezEKP.ezLadder.vo.LadderBmUserVO;
import egovframework.ezEKP.ezLadder.vo.LadderBmVO;
import egovframework.ezEKP.ezLadder.vo.LadderCommentVO;
import egovframework.ezEKP.ezLadder.vo.LadderLineVO;
import egovframework.ezEKP.ezLadder.vo.LadderOrderVO;
import egovframework.ezEKP.ezLadder.vo.LadderVO;

public interface EzLadderService {

	public int ladderCount(LadderVO vo, String mode) throws Exception;
	public int partLadderCount(LadderVO vo) throws Exception;
	public int searchLadderCount(LadderVO vo, List<String> allData) throws Exception;
	public List<LadderVO> getLadderList(LadderVO vo, int startPoint, int endPoint, String mode, String sort, String sortFlag) throws Exception;
	public List<LadderVO> getPartLadderList(LadderVO vo, int startPoint, int endPoint, String sort, String sortFlag) throws Exception;
	public List<LadderVO> searchLadderList(LadderVO vo, List<String> allData, int startPoint, int endPoint, String sort, String sortFlag) throws Exception;
	
	/** boh */
	public List<LadderLineVO> selectSearchUser(String [] searchUserName, LadderVO ladVO)  throws Exception;
	
	public int insertLadder(LadderVO lad, LadderLineVO ladLines, String logCookie) throws Exception; // 사다리 게임 만들기
	public int selectRecentLadderId(LadderVO lad) throws Exception; // 최근 등록한 사다리게임 아이디 조회
	
	public List<LadderBmVO> selectBMGroup(LadderBmVO bmGroup) throws Exception; // 즐겨찾기 그룹 조회
	public List<LadderBmUserVO> selectBMUser(LadderBmUserVO bmUser) throws Exception; // 즐겨찾기 그룹 유저 조회
	public void insertBM(LadderBmVO bmGroup, LadderBmUserVO bmUsers) throws Exception; // 즐겨찾기 그룹 추가
	public void updateBM(LadderBmVO bmGroup, LadderBmUserVO bmUsers) throws Exception; // 즐겨찾기 그룹 수정
	public void deleteBM(LadderBmVO bmGroup, LadderBmUserVO bmUsers) throws Exception; // 즐겨찾기 그룹 삭제
	
	public List<LadderCommentVO> selectComments(LadderCommentVO cmtVO) throws Exception; // 댓글 리스트 조회
	public LadderCommentVO selectComment(LadderCommentVO cmtVO) throws Exception; // 댓글 조회
	public void insertComment(LadderCommentVO cmtVO) throws Exception; // 댓글 추가
	public void updateComment(LadderCommentVO cmtVO) throws Exception; // 댓글 수정
	public void deleteComment(LadderCommentVO cmtVO) throws Exception; // 댓글 삭제
	
	public void changePreLadderList(LadderOrderVO ladOrders) throws Exception; // 이전 사다리 목록 바꾸기
	
	/** hyh	*/

	public LadderVO getLadderGame(LadderVO ladVO) throws Exception; // 사다리 게임 조회
	public List<LadderLineVO> getLadderLineParticipant(LadderVO ladVO, String mode, String back) throws Exception;
	public void deleteLadderList(LadderVO ladVO) throws Exception; // 사다리 삭제
	public void setUserOrder(LadderVO ladVO, String firstUser, String secondUser, int firstUserOrder, int secondUserOrder, 
			String firstItem, String secondItem) throws Exception; // 사용자 위치 바꾸기
	public void setLadderStart(LadderVO ladVO, int size) throws Exception;	// 사다리 게임 시작
}
