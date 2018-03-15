package egovframework.ezEKP.ezLadder.service;

import java.util.List;

import egovframework.ezEKP.ezLadder.vo.LadderBmUserVO;
import egovframework.ezEKP.ezLadder.vo.LadderBmVO;
import egovframework.ezEKP.ezLadder.vo.LadderCommentVO;
import egovframework.ezEKP.ezLadder.vo.LadderLineVO;
import egovframework.ezEKP.ezLadder.vo.LadderOrderVO;
import egovframework.ezEKP.ezLadder.vo.LadderVO;

public interface EzLadderService {

	public int ladderCount(String userId, String tenantId) throws Exception;
	public int partLadderCount(String userId, String tenantId) throws Exception;
	public int searchLadderCount(String userId, String tenantId, List<String> allData) throws Exception;
	public List<LadderVO> getLadderList(String userId, String tenantId, int startPoint, int endPoint) throws Exception;
	public List<LadderVO> getPartLadderList(String userId, String tenantId, int startPoint, int endPoint) throws Exception;
	public List<LadderVO> searchLadderList(String userId, String tenantId, List<String> allData, int startPoint, int endPoint) throws Exception;
	
	/** boh */
	public void insertLadder(LadderVO lad, LadderLineVO ladLines) throws Exception; // 사다리 게임 만들기
	public int selectRecentLadderId(LadderVO lad) throws Exception; // 최근 등록한 사다리게임 아이디 조회
	
	public List<LadderBmVO> selectBMGroup(LadderBmVO bmGroup) throws Exception; // 즐겨찾기 그룹 조회
	public List<LadderBmUserVO> selectBMUser(LadderBmUserVO bmUser) throws Exception; // 즐겨찾기 그룹 유저 조회
	public void insertBM(LadderBmVO bmGroup, LadderBmUserVO bmUsers) throws Exception; // 즐겨찾기 그룹 추가
	public void updateBM(LadderBmVO bmGroup, LadderBmUserVO bmUsers) throws Exception; // 즐겨찾기 그룹 수정
	public void deleteBM(LadderBmVO bmGroup, LadderBmUserVO bmUsers) throws Exception; // 즐겨찾기 그룹 삭제
	
	public List<LadderCommentVO> selectComment(int ladderId) throws Exception; // 댓글 조회
	public void insertComment(LadderCommentVO ladCmt) throws Exception; // 댓글 추가
	public void updateComment(LadderCommentVO ladCmt) throws Exception; // 댓글 수정
	public void deleteComment(String userId, LadderCommentVO ladCmt) throws Exception; // 댓글 삭제
	
	public List<LadderVO> selectPreLadderList(String userId) throws Exception; // 이전 사다리 목록 조회
	public LadderLineVO selectPreLadder(String userId, int ladderId) throws Exception; // 이전 사다리 조회
	public void changePreLadderList(String userId, String ladderId_1, String ladderId_2) throws Exception; // 이전 사다리 목록 바꾸기
	
	/** hyh	*/

	public LadderVO getLadderGame(String tenantId, int ladderId) throws Exception; // 사다리 게임 조회
	public List<LadderLineVO> getLadderLineParticipant(String tenantId, int ladderId) throws Exception;
	public List<LadderVO> deleteLadderList(String userId, String tenantId, List<String> allData) throws Exception; // 사다리 삭제
	public void setUserOrder(int LadderId, String userName1, String userName2) throws Exception; // 사용자 위치 바꾸기
	public void setLadderStart(int LadderId, String userId, String lineArray) throws Exception;	// 사다리 게임 시작
}
