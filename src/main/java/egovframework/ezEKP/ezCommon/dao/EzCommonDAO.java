package egovframework.ezEKP.ezCommon.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzCommonDAO")
public class EzCommonDAO extends EgovAbstractDAO{

	public BoardAttachVO getAttachInfo(Map<String, Object> map) throws Exception{
		return (BoardAttachVO) select("EzCommonDAO.getAttachInfo", map);
	}
	
	public String getContentInfo(Map<String, Object> map) throws Exception{
		return (String) select("EzCommonDAO.getContentInfo", map);
	}


}
