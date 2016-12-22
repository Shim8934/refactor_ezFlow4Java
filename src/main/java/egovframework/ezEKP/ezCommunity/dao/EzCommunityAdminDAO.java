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
	public List<CommunityCComCloseVO> aspCloseComGet1Select1(Map<String, Object> map) throws Exception {
		return (List<CommunityCComCloseVO>) list("EzCommunityAdminDAO.aspCloseGet1Select1", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCComCloseVO> aspCloseComGet1Select2(Map<String, Object> map) throws Exception {
		return (List<CommunityCComCloseVO>) list("EzCommunityAdminDAO.aspCloseGet1Select2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityClubVO> aspAdmitComGet1Select1(Map<String, Object> map) throws Exception {
		return (List<CommunityClubVO>) list("EzCommunityAdminDAO.aspAdmitComGet1Select1", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityClubVO> aspAdmitComGet1Select2(Map<String, Object> map) throws Exception {
		return (List<CommunityClubVO>) list("EzCommunityAdminDAO.aspAdmitComGet1Select2", map);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityClubVO> aspSearchKeyGet1(Map<String, Object> map) throws Exception {
		return (List<CommunityClubVO>) list("EzCommunityAdminDAO.aspSearchKeyGet1", map);
	}
	
	public CommunityClubVO admCommunityInfoEdit(Map<String, Object> map) throws Exception {
		return (CommunityClubVO) select("EzCommunityAdminDAO.admCommunityInfoEdit", map);
	}
	
	public String aspCommInfoGet3(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityAdminDAO.aspCommInfoGet3", map);
	}
	
	public String aspCommInfoGet4(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityAdminDAO.aspCommInfoGet4", map);
	}
	
	public Integer aspCloseComGet2Select1(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityAdminDAO.aspCloseComGet2Select1", map);
	}
	
	public Integer aspCloseComGet2Select2(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityAdminDAO.aspCloseComGet2Select2", map);
	}
	
	public Integer aspAdmitComGet2Select1(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityAdminDAO.aspAdmitComGet2Select1", map);
	}
	
	public Integer aspAdmitComGet2Select2(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityAdminDAO.aspAdmitComGet2Select2", map);
	}
	
	public String getUserName(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityAdminDAO.getUserName", map);
	}
	
	public Integer aspSearchKeyGet2(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityAdminDAO.aspSearchKeyGet2", map);
	}

	public void aspCommCloseAllDel(Map<String, Object> map) throws Exception {
		delete("EzCommunityAdminDAO.aspCommCloseAllDel", map);
	}
	
	public void aspCommCloseAllUpdate(Map<String, Object> map) throws Exception {
		update("EzCommunityAdminDAO.aspCommCloseAllUpdate", map);
	}

	public void aspCommAdmitOkSet1Update(Map<String, Object> map) throws Exception {
		update("EzCommunityAdminDAO.aspCommAdmitOkSet1Update", map);
	}
	
	public void aspCommAdmitOkSet1Delete(Map<String, Object> map) throws Exception {
		delete("EzCommunityAdminDAO.aspCommAdmitOkSet1Delete", map);
	}

	public void aspCommAdmitokSet2Update(Map<String, Object> map) throws Exception {
		update("EzCommunityAdminDAO.aspCommAdmitOkSet2Update", map);
	}
	public void aspCommAdmitokSet2Insert1(Map<String, Object> map) throws Exception {
		insert("EzCommunityAdminDAO.aspCommAdmitOkSet2Insert1", map);
	}
	public void aspCommAdmitokSet2Insert2(Map<String, Object> map) throws Exception {
		insert("EzCommunityAdminDAO.aspCommAdmitOkSet2Insert2", map);
	}
	public String aspCommAdmitokSet2Select(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityAdminDAO.aspCommAdmitokSet2Select", map);
	}
	
	public void admCommunityInfoEditOk(Map<String, Object> map) throws Exception {
		update("EzCommunityAdminDAO.admCommunityInfoEditOk", map);
	}
}
