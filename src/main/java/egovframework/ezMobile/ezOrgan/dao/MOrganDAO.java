package egovframework.ezMobile.ezOrgan.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezMobile.ezOrgan.vo.MOrganListVO;
import egovframework.ezMobile.ezOrgan.vo.MPersonListVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("MOrganDAO")
public class MOrganDAO extends EgovAbstractDAO {
	@SuppressWarnings("unchecked")
	public List<MPersonListVO> getPersonList(Map<String, Object> map) throws Exception {
		return (List<MPersonListVO>) list("MOrganDAO.getPersonList", map);
	}
	
	public MPersonListVO getPersonInfo(Map<String, Object> map) throws Exception {
		return (MPersonListVO) select("MOrganDAO.getPersonInfo", map);
	}
	
	public int getPersonListCount(Map<String, Object> map) throws Exception {
		return (int) select("MOrganDAO.getPersonListCount", map);
	}

	@SuppressWarnings("unchecked")
	public List<MOrganListVO> getSameOrganList(Map<String, Object> map) throws Exception {
		return (List<MOrganListVO>) list("MOrganDAO.getSameOrganList", map);
	}

	@SuppressWarnings("unchecked")
	public List<MOrganListVO> getLowOrganList(Map<String, Object> map) throws Exception {
		return (List<MOrganListVO>) list("MOrganDAO.getLowOrganList", map);
	}

	@SuppressWarnings("unchecked")
	public List<MOrganListVO> getDeptMemberList(Map<String, Object> map) throws Exception {
		return (List<MOrganListVO>) list("MOrganDAO.getDeptMemberList", map);
	}
}
