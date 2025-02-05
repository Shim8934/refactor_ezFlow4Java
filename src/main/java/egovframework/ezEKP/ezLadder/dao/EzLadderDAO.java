package egovframework.ezEKP.ezLadder.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezLadder.vo.LadderBmUserVO;
import egovframework.ezEKP.ezLadder.vo.LadderBmVO;
import egovframework.ezEKP.ezLadder.vo.LadderCommentVO;
import egovframework.ezEKP.ezLadder.vo.LadderLineVO;
import egovframework.ezEKP.ezLadder.vo.LadderOrderVO;
import egovframework.ezEKP.ezLadder.vo.LadderVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzLadderDAO")
public class EzLadderDAO extends EgovAbstractDAO {
	
	public int getLadderCount(Map<String, Object> map) throws Exception {
		return (int) select("EzLadderDAO.getLadderCount", map);
	}
	
	public int getPartLadderCount(Map<String, Object> map) throws Exception {
		return (int) select("EzLadderDAO.getPartLadderCount", map);
	}
	
	public int getPartSLadderCount(Map<String, Object> map) throws Exception {
		return (int) select("EzLadderDAO.searchSPartLadderCount", map);
	}

	public int getAllSLadderCount(Map<String, Object> map) throws Exception {
		return (int) select("EzLadderDAO.searchAllSLadderCount", map);
	}
	@SuppressWarnings("unchecked")
	public List<LadderVO> getLadderList(Map<String, Object> map) throws Exception {
		return (List<LadderVO>) list("EzLadderDAO.getLadderList", map);
	}
	
	public void insertLadderSet(LadderVO vo) throws Exception {
		insert("EzLadderDAO.insertLadderSet", vo);
	}
	
	public void insertLadderLine(LadderLineVO vo) throws Exception {
		insert("EzLadderDAO.insertLadderLine", vo);
	}

	@SuppressWarnings("unchecked")
	public List<LadderVO> getPartLadderList(Map<String, Object> map) throws Exception {
		return (List<LadderVO>) list("EzLadderDAO.getPartLadderList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<LadderVO> searchPartLadderList(Map<String, Object> map) throws Exception {
		return (List<LadderVO>) list("EzLadderDAO.searchPartLadderList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<LadderVO> searchPreLadderList(Map<String, Object> map) throws Exception {
		return (List<LadderVO>) list("EzLadderDAO.searchPreLadderList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<LadderVO> searchAllLadderList(Map<String, Object> map) throws Exception {
		return (List<LadderVO>) list("EzLadderDAO.searchAllLadderList", map);
	}
	
	public void deleteLadderList(Map<String, Object> map) throws Exception {
		update("EzLadderDAO.deleteLadderList", map);
	}
	
	public LadderVO ladderContent(Map<String, Object> map) throws Exception {
		return (LadderVO) select("EzLadderDAO.ladderContent", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<LadderLineVO> ladderGameParticipant(Map<String, Object> map) throws Exception {
		return (List<LadderLineVO>) list("EzLadderDAO.ladderGameParticipant", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<LadderLineVO> selectSearchUser(Map<String, Object> dataMap) throws Exception {
		return (List<LadderLineVO>) list("EzLadderDAO.selectSearchUser", dataMap);
	}
	
	public int selectRecentLadderId(LadderVO lad) throws Exception {
		return (int) select("EzLadderDAO.selectRecentLadderId", lad);
	}
	
	/** 이전 사다리 관련 */
	@SuppressWarnings("unchecked")
	public List<LadderVO> selectPreList(Map<String, Object> ladMap) throws Exception {
		return (List<LadderVO>) list("EzLadderDAO.selectPreList", ladMap);
	}
	
	@SuppressWarnings("unchecked")
	public List<LadderOrderVO> selectChangePreList(LadderOrderVO ladOrder) throws Exception {
		return (List<LadderOrderVO>) list("EzLadderDAO.selectChangePreList", ladOrder);
	}
	
	public void deleteChangePreList(LadderOrderVO ladOrder) throws Exception {
		delete("EzLadderDAO.deleteChangePreList", ladOrder);
	}
	
	public void insertChangePreList(LadderOrderVO ladOrder) throws Exception {
		insert("EzLadderDAO.insertChangePreList", ladOrder);
	}
	
	
	/** 댓글 관련 */
	@SuppressWarnings("unchecked")
	public List<LadderCommentVO> selectComments(LadderCommentVO cmt) {
		return (List<LadderCommentVO>) list("EzLadderDAO.selectLadderCommentList", cmt);
	}
	
	public LadderCommentVO selectComment(LadderCommentVO cmt) {
		return (LadderCommentVO) select("EzLadderDAO.selectLadderComment", cmt);
	}
	
	public void insertComment(LadderCommentVO cmt) {
		insert("EzLadderDAO.insertLadderComment", cmt);
	}
	
	public int selectRecentCommentId(LadderCommentVO cmt) {
		return (int) select("EzLadderDAO.selectRecentCommentId", cmt);
	}
	
	public void updateComment(LadderCommentVO cmt) {
		update("EzLadderDAO.updateLadderComment", cmt);
	}
	
	public void deleteComment(LadderCommentVO cmt) {
		delete("EzLadderDAO.deleteLadderComment", cmt);
	}
	
	/** 유저 즐겨찾기 관련 */
	@SuppressWarnings("unchecked")
	public List<LadderBmVO> selectBMGroup(LadderBmVO bmGroup) throws Exception {
		return (List<LadderBmVO>) list("EzLadderDAO.selectLadderBMGroupList", bmGroup);
	}
	
	@SuppressWarnings("unchecked")
	public List<LadderBmUserVO> selectBMUser(LadderBmUserVO bmUser) throws Exception {
		return (List<LadderBmUserVO>) list("EzLadderDAO.selectLadderBMUserList", bmUser);
	}
	
	public void insertBMGroup(LadderBmVO bmGroupVO) throws Exception {
		insert("EzLadderDAO.insertLadderBMGroup", bmGroupVO);
	}
	
	public void insertBMUser(LadderBmUserVO bmUserVO) throws Exception {
		insert("EzLadderDAO.insertLadderBMUser", bmUserVO);
	}
	
	public void updateBMGroup(LadderBmVO bmGroupVO) throws Exception {
		update("EzLadderDAO.updateLadderBMGroup", bmGroupVO);
	}
	
	public void deleteBMGroup(LadderBmVO bmGroupVO) throws Exception {
		delete("EzLadderDAO.deleteLadderBMGroup", bmGroupVO);
	}
	
	public void deleteBMUser(LadderBmUserVO bmUserVO) throws Exception {
		delete("EzLadderDAO.deleteLadderBMUser", bmUserVO);
	}

	public void deleteBMUserAll(LadderBmVO bmGroupVO) throws Exception {
		delete("EzLadderDAO.deleteLadderBMUserAll", bmGroupVO);
	}

	public void updateLadderStart(Map<String, Object> map) throws Exception {
		update("EzLadderDAO.updateLadderStart", map);
	}
	
	public void updateLadderResult(Map<String, Object> map) throws Exception {
		update("EzLadderDAO.updateLadderResult", map);
	}
	
	public void setUserOrder(Map<String, Object> map) throws Exception {
		update ("EzLadderDAO.setUserOrder", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getTblUserMaster(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzLadderDAO.getTblUserMaster", map);
	}
}
