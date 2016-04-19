package egovframework.ezEKP.ezCommunity.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityLeftCommunityVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzCommunityDAO")
public class EzCommunityDAO extends EgovAbstractDAO{
	@SuppressWarnings("unchecked")
	public List<CommunityLeftCommunityVO> leftCommunityGet3(String userId) throws Exception{
		return (List<CommunityLeftCommunityVO>) list("EzCommunityDAO.leftCommunityGet3", userId);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCBoardVO> getLeftBoardList() {
		return (List<CommunityCBoardVO>) list("EzCommunityDAO.getLeftBoardList");
	}
	
	public String leftCommunityGet1(Map<String, Object> map) throws Exception{
		return (String) select("EzCommunityDAO.leftCommunityGet1", map);
	}

	public String leftCommunityGet2(String code) throws Exception{
		return (String) select("EzCommunityDAO.leftCommunityGet2", code);
	}

	public String leftCommunityGet4(String code) throws Exception{
		return (String) select("EzCommunityDAO.leftCommunityGet4", code);
	}





}
