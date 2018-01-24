package egovframework.ezEKP.ezWebFolder.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
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

	@SuppressWarnings("unchecked")
	public List<UserCapacityVO> getListUserCapacity(Map<String, Object> map) {		
		return (List<UserCapacityVO>) list("EzWebFolderAdminDAO.getListUserCapacity", map);
	}

	public void updateNewAmount(Map<String, Object> map) {		
		insert("EzWebFolderAdminDAO.updateNewAmount", map);
	}

}
