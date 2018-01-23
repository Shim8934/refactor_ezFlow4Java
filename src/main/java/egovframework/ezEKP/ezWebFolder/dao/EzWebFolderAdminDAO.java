package egovframework.ezEKP.ezWebFolder.dao;

import java.util.Map;
import org.springframework.stereotype.Repository;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzWebFolderAdminDAO")
public class EzWebFolderAdminDAO extends EgovAbstractDAO {

	public void saveConfig(Map<String, Object> map) {		
		insert("EzWebFolderAdminDAO.saveConfig", map);
	}

	public WebfolderConfigVO getWebfolderConfig(Map<String, Object> map) {		
		return (WebfolderConfigVO)select("EzWebFolderAdminDAO.getWebfolderConfig", map);
	}

}
