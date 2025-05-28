package egovframework.ezMobile.ezOption.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezNewPortal.vo.MenuInfoVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.ezMobile.ezPortal.vo.MPortalTimeLineVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("MOptionDAO")
public class MOptionDAO extends EgovAbstractDAO {

	public MCommonVO commonInfo(Map<String, Object> map) throws Exception {
		return (MCommonVO) select("EzOptionDAO.commonInfo", map);
	}

	public MOptionVO optionInfo(Map<String, Object> map) throws Exception {		
		return (MOptionVO) select("EzOptionDAO.optionInfo", map);
	}
	
	public void insertOption(Map<String, Object> map) throws Exception{
		insert("EzOptionDAO.insertOption", map);		
	}

	public void updateOption(Map<String, Object> map) throws Exception{
		insert("EzOptionDAO.updateOption", map);		
	}

	public void deleteOption(Map<String, Object> map) throws Exception{
		insert("EzOptionDAO.deleteOption", map);
	}

	@SuppressWarnings("unchecked")
	public List<MPortalTimeLineVO> getTimeLineList(Map<String, Object> map) throws Exception {
		return (List<MPortalTimeLineVO>) list("EzOptionDAO.getTimeLineList", map);
	}

	public MCommonVO commonInfoWeb(Map<String, Object> map) throws Exception {
		MCommonVO result = null;
		try {
			result = (MCommonVO) select("EzOptionDAO.commonInfoWeb", map);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		return result;
	}

	@SuppressWarnings("unchecked")
	public List<MenuInfoVO> getMenuForUser(Map<String, Object> map) throws Exception {
		return (List<MenuInfoVO>) list("ezNewPortal.getMenuForUser", map);
	}
	
}
