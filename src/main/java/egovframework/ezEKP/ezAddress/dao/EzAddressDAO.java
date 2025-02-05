package egovframework.ezEKP.ezAddress.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezAddress.vo.AddressFolderVO;
import egovframework.ezEKP.ezAddress.vo.AddressVO;
import egovframework.ezEKP.ezAddress.vo.SimpleAddressVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzAddressDAO")
public class EzAddressDAO extends EgovAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<SimpleAddressVO> getSimpleAddress(Map<String, Object> map) throws Exception{
		return (List<SimpleAddressVO>) list("EzAddressDAO.getSimpleAddress", map);
	}

	public void setSimpleAddress(Map<String, Object> map) throws Exception{
		update("EzAddressDAO.setSimpleAddress", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<AddressFolderVO> getSubTreeInfo(Map<String, Object> map) throws Exception{
		return (List<AddressFolderVO>) list("EzAddressDAO.getSubTreeInfo", map);
	}
	
	public String getListType(Map<String, Object> map) throws Exception{
		return (String) select("EzAddressDAO.getListType", map);
	}
	
	public String getListCnt(Map<String, Object> map) throws Exception{
		return (String) select("EzAddressDAO.getListCnt", map);
	}
	
	public int getAddressCount(Map<String, Object> map) throws Exception{
		return (Integer) select("EzAddressDAO.getAddressCount", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<AddressVO> getAddressList(Map<String, Object> map) throws Exception{
		return (List<AddressVO>) list("EzAddressDAO.getAddressList", map);
	}
	
	public AddressVO getAddressInfo(Map<String, Object> map) throws Exception{
		return (AddressVO) select("EzAddressDAO.getAddressInfo2", map);
	}
	
	public int getSearchCount(Map<String, Object> map) throws Exception{
		return (Integer) select("EzAddressDAO.getSearchCount", map);
	}
	
	public void insertAddress(Map<String, Object> map) throws Exception{
		insert("EzAddressDAO.insertAddress", map);
	}
	
	public void updateAddress(Map<String, Object> map) throws Exception{
		update("EzAddressDAO.updateAddress", map);
	}
	
	public void deleteAddress(Map<String, Object> map) throws Exception{
		delete("EzAddressDAO.deleteAddress", map);
	}
	
	public void setAddressConfig(Map<String, Object> map) throws Exception{
		delete("EzAddressDAO.setAddressConfig", map);
	}
	
	public void moveAddress(Map<String, Object> map) throws Exception{
		update("EzAddressDAO.moveAddress", map);
	}
	
	public void copyAddress(Map<String, Object> map) throws Exception{
		insert("EzAddressDAO.copyAddress", map);
	}
	
	public int getMaxSeq(Map<String, Object> map) throws Exception{
		return (Integer) select("EzAddressDAO.getMaxSeq", map);
	}
	
	public String insertFolder(Map<String, Object> map) throws Exception{
		return (String) select("EzAddressDAO.insertFolder", map);
	}
	
	public void updateFolder(Map<String, Object> map) throws Exception{
		update("EzAddressDAO.updateFolder", map);
	}
	
	public void deleteFolder(Map<String, Object> map) throws Exception{
		update("EzAddressDAO.deleteFolder", map);
	}
	
	public void moveFolder(Map<String, Object> map) throws Exception{
		update("EzAddressDAO.moveFolder", map);
	}
	
	public void copyFolder(Map<String, Object> map) throws Exception{
		insert("EzAddressDAO.copyFolder", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<AddressVO> getSearchList(Map<String, Object> map) throws Exception{
		return (List<AddressVO>) list("EzAddressDAO.getSearchList", map);
	}
	
	public AddressFolderVO getFolderInfo(Map<String, Object> map) throws Exception{
		return (AddressFolderVO) select("EzAddressDAO.getFolderInfo", map);
	}
	
}