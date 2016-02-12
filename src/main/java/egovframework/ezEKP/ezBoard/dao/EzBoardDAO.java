package egovframework.ezEKP.ezBoard.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezBoard.vo.EzBoardVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzBoardDAO")
public class EzBoardDAO extends EgovAbstractDAO{
	Map<String, Object> map;

	@SuppressWarnings("unchecked")
	public List<EzBoardVO> getLeft_BoardSTD(String redirectBoardID) {
		map.put("redirectBoardID", redirectBoardID);
		return (List<EzBoardVO>) list("EzBoardDAO.getLeft_BoardSTD", map);
	}

}