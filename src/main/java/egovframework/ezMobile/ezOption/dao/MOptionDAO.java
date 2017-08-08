package egovframework.ezMobile.ezOption.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

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
	
}
