package egovframework.ezEKP.ezCircular.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezCircular.vo.CircularConfigVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzCircularDAO")
public class EzCircularDAO extends EgovAbstractDAO{

	public CircularConfigVO getCircularList_Config(Map<String, Object> map) throws Exception {
		return (CircularConfigVO) select("EzCircularDAO.getCircularList_Config", map);
	}

}
