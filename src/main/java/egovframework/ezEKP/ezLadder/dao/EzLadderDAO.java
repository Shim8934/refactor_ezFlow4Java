package egovframework.ezEKP.ezLadder.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

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

}
