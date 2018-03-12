package egovframework.ezEKP.ezLadder.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezLadder.vo.LadderBmUserVO;
import egovframework.ezEKP.ezLadder.vo.LadderBmVO;
import egovframework.ezEKP.ezLadder.vo.LadderLineVO;
import egovframework.ezEKP.ezLadder.vo.LadderVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzLadderDAO")
public class EzLadderDAO extends EgovAbstractDAO {
	
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
	public List<LadderVO> searchAllLadderList(Map<String, Object> map) throws Exception {
		return (List<LadderVO>) list("EzLadderDAO.searchAllLadderList", map);
	}
	
	@SuppressWarnings("unchecked")
	public void deleteLadderList(Map<String, Object> map) throws Exception {
		update("EzLadderDAO.deleteLadderList", map);
	}
	
	@SuppressWarnings("unchecked")
	public LadderVO ladderContent(Map<String, Object> map) throws Exception {
		return (LadderVO) select("EzLadderDAO.ladderContent", map);
	}
	
	/** boh */
	/** 유저 즐겨찾기 관련 */
	@SuppressWarnings("unchecked")
	public List<LadderBmVO> selectBMGroup(LadderBmVO bmGroup) throws Exception {
		return (List<LadderBmVO>) list("EzLadderDAO.selectLadderBMGroupList", bmGroup);
	}
	
	@SuppressWarnings("unchecked")
	public List<LadderBmUserVO> selectBMUser(LadderBmVO bmGroup) throws Exception {
		return (List<LadderBmUserVO>) list("EzLadderDAO.selectLadderBMUserList", bmGroup);
	}
	
	@SuppressWarnings("unchecked")
	public void insertBMGroup(LadderBmVO bmGroupVO) throws Exception {
		insert("EzLadderDAO.insertLadderBMGroup", bmGroupVO);
	}
	
	@SuppressWarnings("unchecked")
	public void insertBMUser(LadderBmUserVO bmUserVO) throws Exception {
		insert("EzLadderDAO.insertLadderBMUser", bmUserVO);
	}
	
	@SuppressWarnings("unchecked")
	public void updateBMGroup(LadderBmVO bmGroupVO) throws Exception {
		update("EzLadderDAO.updateLadderBMGroup", bmGroupVO);
	}
	
	@SuppressWarnings("unchecked")
	public void deleteBMGroup(LadderBmVO bmGroupVO) throws Exception {
		delete("EzLadderDAO.deleteLadderBMGroup", bmGroupVO);
	}
	
	@SuppressWarnings("unchecked")
	public void deleteBMUser(LadderBmUserVO bmUserVO) throws Exception {
		delete("EzLadderDAO.deleteLadderBMUser", bmUserVO);
	}

	@SuppressWarnings("unchecked")
	public void deleteBMUserAll(LadderBmVO bmGroupVO) throws Exception {
		delete("EzLadderDAO.deleteLadderBMUserAll", bmGroupVO);
	}

}
