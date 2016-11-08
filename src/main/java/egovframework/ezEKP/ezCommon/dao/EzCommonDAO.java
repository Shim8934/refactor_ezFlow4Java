package egovframework.ezEKP.ezCommon.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.ezEKP.ezCommon.vo.ApprovPWDVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzCommonDAO")
public class EzCommonDAO extends EgovAbstractDAO{

	public BoardAttachVO getAttachInfo(Map<String, Object> map) throws Exception{
		return (BoardAttachVO) select("EzCommonDAO.getAttachInfo", map);
	}
	
	public ApprovPWDVO getApprovPWD(Map<String, Object> map) throws Exception{
		return (ApprovPWDVO) select("EzCommonDAO.getApprovPWD", map);
	}
	
	public String getContentInfo(Map<String, Object> map) throws Exception{
		return (String) select("EzCommonDAO.getContentInfo", map);
	}
	
	public String selectUserGetLang(String userID) throws Exception{
		return (String) select("EzCommonDAO.selectUserGetLang", userID);
	}
	
	public String selectUserGetTimeZone(String userID) throws Exception{
		return (String) select("EzCommonDAO.selectUserGetTimeZone", userID);
	}
	
	public String getTenantConfig(Map<String, Object> map) throws Exception{
		return (String) select("EzCommonDAO.getTenantConfig", map);
	}
	
	public void insertTblUserLocalInfo(Map<String, Object> map) throws Exception {
		insert("EzCommonDAO.insertTblUserLocalInfo",map);
	}
	
	public void deleteUserLLocalInfo(Map<String, Object> map) throws Exception {
		delete("EzCommonDAO.deleteUserLLocalInfo",map);
	}

	@SuppressWarnings("unchecked")
	public List<HashMap<String, String>> getTenantAllConfig(int tenantID) throws Exception{
		return (List<HashMap<String, String>>) list("EzCommonDAO.getTenantAllConfig", tenantID);
	}
}
