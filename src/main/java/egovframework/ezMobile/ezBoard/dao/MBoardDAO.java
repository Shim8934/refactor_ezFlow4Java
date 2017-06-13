package egovframework.ezMobile.ezBoard.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListHeaderVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("MBoardDAO")
public class MBoardDAO extends EgovAbstractDAO {

	@SuppressWarnings("unchecked")
	public List<MBoardListHeaderVO> getListHeader(Map<String, Object> map) {
		return (List<MBoardListHeaderVO>) list("MBoardDAO.getListHeader", map);
	}
	
	public MBoardInfoVO getBoardProperty(Map<String, Object> map) {
		return (MBoardInfoVO) select("MBoardDAO.getBoardProperty", map);
	}

	

}
