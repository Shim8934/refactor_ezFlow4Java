package egovframework.ezEKP.ezLadder.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezLadder.vo.LadderVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzLadderDAO")
public class EzLadderDAO extends EgovAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<LadderVO> getLadderList() throws Exception {
		return (List<LadderVO>) list("EzLadderDAO.getLadderList");
	}

}
