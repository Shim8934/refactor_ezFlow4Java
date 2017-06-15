package egovframework.ezMobile.ezBoard.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardItemVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListHeaderVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("MBoardDAO")
public class MBoardDAO extends EgovAbstractDAO {
	@SuppressWarnings("unchecked")
	public List<MBoardListHeaderVO> getListHeader(Map<String, Object> map) throws Exception {
		return (List<MBoardListHeaderVO>) list("MBoardDAO.getListHeader", map);
	}

	@SuppressWarnings("unchecked")
	public List<MBoardItemVO> getBoarditemList(Map<String, Object> map) throws Exception {
		return (List<MBoardItemVO>) list("MBoardDAO.getBoarditemList", map);
	}

	public MBoardInfoVO getBoardProperty(Map<String, Object> map) throws Exception {
		return (MBoardInfoVO) select("MBoardDAO.getBoardProperty", map);
	}

	public MBoardInfoVO getACL(Map<String, Object> map) throws Exception {
		return (MBoardInfoVO) select("MBoardDAO.getACL", map);
	}

}
