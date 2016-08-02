package egovframework.ezEKP.ezPersonal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPersonal.vo.PersonalGetSliderListVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzPersonalDAO")
public class EzPersonalDAO extends EgovAbstractDAO{
	
	@SuppressWarnings("unchecked")
	public List<PersonalGetSliderListVO> getSilderList (Map<String, Object> map) {
		return (List<PersonalGetSliderListVO>) list("EzPersonalDAO.getSliderList", map);
	}

	public void setApprovalPwd(Map<String, Object> map) throws Exception{
		insert("EzPersonalDAO.setApprovalPwd", map);
	}
	
}
