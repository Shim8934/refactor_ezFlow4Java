package egovframework.ezMobile.ezOrgan.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezMobile.ezOrgan.vo.MPersonListVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("MOrganDAO")
public class MOrganDAO extends EgovAbstractDAO {
	@SuppressWarnings("unchecked")
	public List<MPersonListVO> getPersonList(Map<String, Object> map) throws Exception {
		return (List<MPersonListVO>) list("MOrganDAO.getPersonList", map);
	}
}
