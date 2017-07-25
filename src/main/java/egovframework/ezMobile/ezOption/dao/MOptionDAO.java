package egovframework.ezMobile.ezOption.dao;

import java.util.Map;
import org.springframework.stereotype.Repository;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("MOptionDAO")
public class MOptionDAO extends EgovAbstractDAO {

	public void insertOption(Map<String, Object> map) {
		// TODO Auto-generated method stub
		
	}

	public MCommonVO commonInfo(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return (MCommonVO) select("EzOptionDAO.commonInfo", map);
	}

}
