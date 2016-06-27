package egovframework.ezEKP.ezCommunity.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezCommunity.vo.CommunityCComCloseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzCommunityAdminDAO")
public class EzCommunityAdminDAO extends EgovAbstractDAO {

	@SuppressWarnings("unchecked")
	public List<CommunityCComCloseVO> aspCloseGet1(Map<String, Object> map) throws Exception {
		return (List<CommunityCComCloseVO>) list("EzCommunityAdminDAO.aspCloseComGet1", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityClubVO> aspAdmitComGet1(Map<String, Object> map) throws Exception {
		return (List<CommunityClubVO>) list("EzCommunityAdminDAO.aspAdmitComGet1", map);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityClubVO> aspSearchKeyGet1(Map<String, Object> map) throws Exception {
		return (List<CommunityClubVO>) list("EzCommunityAdminDAO.aspSearchKeyGet1", map);
	}
	
	public CommunityClubVO admCommunityInfoEdit(Map<String, Object> map) throws Exception {
		return (CommunityClubVO) select("EzCommunityAdminDAO.admCommunityInfoEdit", map);
	}
	
	public String aspCloseComGet2(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityAdminDAO.aspCloseComGet2", map);
	}

	public String aspCommInfoGet3(String v_CODE) throws Exception {
		return (String) select("EzCommunityAdminDAO.aspCommInfoGet3", v_CODE);
	}
	
	public String aspCommInfoGet4(String v_CODE) throws Exception {
		return (String) select("EzCommunityAdminDAO.aspCommInfoGet4", v_CODE);
	}

	public String aspAdmitComGet2(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityAdminDAO.aspAdmitComGet2", map);
	}
	
	public String getUserName(String v_ID) throws Exception {
		return (String) select("EzCommunityAdminDAO.getUserName", v_ID);
	}
	
	public Integer aspSearchKeyGet2(Map<String, Object> map) throws Exception {
		select("EzCommunityAdminDAO.aspSearchKeyGet2", map);
		return (Integer) map.get("v_pCount");
	}

	public void aspCommCloseAllDel(String v_CODE) throws Exception {
		delete("EzCommunityAdminDAO.aspCommCloseAllDel", v_CODE);
	}
	
	public void aspCommCloseAllUpdate(Map<String, Object> map) throws Exception {
		update("EzCommunityAdminDAO.aspCommCloseAllUpdate", map);
	}

	public void aspCommAdmitOkSet1(Map<String, Object> map) throws Exception {
		update("EzCommunityAdminDAO.aspCommAdmitOkSet1", map);
	}

	public void aspCommAdmitokSet2(Map<String, Object> map) throws Exception {
		update("EzCommunityAdminDAO.aspCommAdmitOkSet2", map);
	}
	
	public void admCommunityInfoEditOk(Map<String, Object> map) throws Exception {
		update("EzCommunityAdminDAO.admCommunityInfoEditOk", map);
	}
}
