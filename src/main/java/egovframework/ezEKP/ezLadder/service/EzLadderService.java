package egovframework.ezEKP.ezLadder.service;

import java.util.List;

import egovframework.ezEKP.ezLadder.vo.LadderBmUserVO;
import egovframework.ezEKP.ezLadder.vo.LadderBmVO;
import egovframework.ezEKP.ezLadder.vo.LadderCommentVO;
import egovframework.ezEKP.ezLadder.vo.LadderLineVO;
import egovframework.ezEKP.ezLadder.vo.LadderOrderVO;
import egovframework.ezEKP.ezLadder.vo.LadderVO;

public interface EzLadderService {

	public List<LadderVO> getLadderList(String userId) throws Exception;
	public List<LadderVO> getPartLadderList(String userId) throws Exception;
	public List<LadderVO> searchLadderList(String userId, List<String> allData) throws Exception;
	
	/** boh */
	public void insertLadder(LadderVO lad, LadderLineVO ladLine) throws Exception; // 사다리 게임 만들기
	
	public List<LadderBmVO> selectBMGroup(String userId) throws Exception; // 즐겨찾기 그룹 조회
	public List<LadderBmUserVO> selectBMUser(String userId, int ladderBMId) throws Exception; // 즐겨찾기 그룹 유저 조회
	public void insertBMGroup(LadderBmVO bmGroup, LadderBmUserVO bmUser) throws Exception; // 즐겨찾기 그룹 추가
	public void updateBMGroup(LadderBmVO bmGroup, LadderBmUserVO bmUser) throws Exception; // 즐겨찾기 그룹 수정
	public void deleteBMGroup(String userId, int ladderBMId) throws Exception; // 즐겨찾기 그룹 삭제
	
	public List<LadderCommentVO> selectComment(int ladderId) throws Exception; // 댓글 조회
	public void insertComment(LadderCommentVO ladCmt) throws Exception; // 댓글 추가
	public void updateComment(LadderCommentVO ladCmt) throws Exception; // 댓글 수정
	public void deleteComment(String userId, LadderCommentVO ladCmt) throws Exception; // 댓글 삭제
	
	public List<LadderVO> selectPreLadderList(String userId) throws Exception; // 이전 사다리 목록 조회
	public LadderLineVO selectPreLadder(String userId, int ladderId) throws Exception; // 이전 사다리 조회
	public void changePreLadderList(String userId, String ladderId_1, String ladderId_2) throws Exception; // 이전 사다리 목록 바꾸기
	
	/** hyh	*/

	public LadderVO getLadderGame(String userId, int ladderId) throws Exception; // 사다리 게임 조회
	public void deleteLadder(String userId, int ladderId) throws Exception; // 사다리 삭제
	public void setUserOrder(int LadderId, String userName1, String userName2) throws Exception; // 사용자 위치 바꾸기
	public void setLadderStart(int LadderId, String userId, String lineArray) throws Exception;	// 사다리 게임 시작
}
