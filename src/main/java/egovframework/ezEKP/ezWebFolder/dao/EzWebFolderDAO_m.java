package egovframework.ezEKP.ezWebFolder.dao;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import egovframework.ezEKP.ezWebFolder.vo.FolderFileVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzWebFolderDAO_m")
public class EzWebFolderDAO_m extends EgovAbstractDAO {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EzWebFolderDAO_m.class);
	
	@SuppressWarnings("unchecked")
	public List<FolderFileVO> getShares(Map<String, Object> map) {
		
		LOGGER.debug("getShares in dao");
		
		return (List<FolderFileVO>)list("EzWebFolderDAO_m.getShares", map);
	}
	
}
