package egovframework.ezEKP.ezAttitude.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzAttitudeDAO")
public class EzAttitudeDAO extends EgovAbstractDAO{

	@SuppressWarnings("unchecked")
	public AttitudeConfigVO getAttitudeConfig(Map<String, Object> map) throws Exception{
		return (AttitudeConfigVO) select("ezAttitude.getAttitudeConfig", map);
	}

}
