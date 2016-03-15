package egovframework.ezEKP.ezEmail.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzEmailDAO")
public class EzEmailDAO extends EgovAbstractDAO {

	@SuppressWarnings("unchecked")
	public List<MailGeneralVO> getMailGeneral(Map<String, Object> map) throws Exception {
		return (List<MailGeneralVO>)list("EzEmailDAO.getMailGeneral", map);
	}	
	
}