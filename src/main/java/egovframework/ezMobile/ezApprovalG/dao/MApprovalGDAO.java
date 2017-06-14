package egovframework.ezMobile.ezApprovalG.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.ezMobile.ezApprovalG.vo.MApprovalGDocInfoVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("MApprovalGDAO")
public class MApprovalGDAO extends EgovAbstractDAO {

	@SuppressWarnings("unchecked")
	public List<MApprovalGDocInfoVO> getDoApproveList(LoginVO userInfo) throws Exception {
		return (List<MApprovalGDocInfoVO>) list("MApprovalG.getDoApproveList", userInfo);
	}

}
