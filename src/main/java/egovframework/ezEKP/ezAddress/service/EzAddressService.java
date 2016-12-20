package egovframework.ezEKP.ezAddress.service;

import java.util.List;

import egovframework.ezEKP.ezAddress.vo.AddressVO;
import egovframework.ezEKP.ezAddress.vo.AddressOldZipCodeVO;
import egovframework.ezEKP.ezAddress.vo.AddressZipCodeVO;
import egovframework.ezEKP.ezAddress.vo.SimpleAddressVO;
import egovframework.ezEKP.ezAddress.vo.AddressFolderVO;

public interface EzAddressService {
	
	public String getListType(int tenantId, String userId) throws Exception;
	public String getListCnt(int tenantId, String userId) throws Exception;
	public void setAddressConfig(int tenantId, String pUserID, String pListCnt, String pListType) throws Exception;
	public int getAddressCount(int tenantId, String pFolderId, String pOwnerId, String pFilter) throws Exception;
	public int getSearchCount(int tenantId, String[] pIdLists, String pFilter) throws Exception;
	public List<AddressVO> getAddressList(int tenantId, String pFolderID, String pOwnerID, String pOrderOption, String pFilter, int pListPageSize, int pStart) throws Exception;
	public List<AddressVO> getAllAddressList(int tenantId, String pFolderID, String pOwnerID, String pOrderOption, String pFilter) throws Exception;
	public List<AddressVO> getSearchList(int tenantId, String[] pIdLists, String pOrderOption, String pFilter, int pListPageSize, int pStart) throws Exception;
	public boolean checkDuplicateAddress(int tenantId, String ownerId, String sEmail) throws Exception;
	public AddressVO getAddressInfo(int tenantId, String primary, String pAddressId) throws Exception;
	public void insertAddress(int tenantId, String pOwnerId, String pFolderId, String pCreatorId, 
			String sName, String sEmail, String sCompany, String sDept, String sTitle, 
			String sCompanyPhone, String sFax, String sMobile, String sHomePage, 
			String sCompanyZip, String sCompanyAddr, String sHomeZip, String sHomeAddr, String sMemo, String sType) throws Exception;
	public void updateAddress(int tenantId, String pAddressId, String pModifierId, 
			String sName, String sEmail, String sCompany, String sDept, String sTitle,
			String sCompanyPhone, String sFax, String sMobile, String sHomePage, 
			String sCompanyZip, String sCompanyAddr, String sHomeZip, String sHomeAddr, String sMemo) throws Exception;
	public void deleteAddress(String[] pAddressIds) throws Exception;
	public void moveAddress(int tenantId, String[] pAddressIds, String pFolderId, String pOwnerId) throws Exception;
	public void copyAddress(int tenantId, String[] pAddressIds, String pFolderId, String pOwnerId, String pCreatorId) throws Exception;
	public List<AddressFolderVO> getSubTreeInfo(int tenantId, String pParentID, String pOwnerID) throws Exception;
	public AddressFolderVO getFolderInfo(String pFolderId) throws Exception;
	public void insertFolder(int tenantId, String pParentId, String pOwnerId, String pFolderType, String pFolderName) throws Exception;
	public void updateFolder(String pFolderId, String pFolderName) throws Exception;
	public void deleteFolder(String pFolderId) throws Exception;
	public void moveFolder(int tenantId, String pFolderId, String pNewParentId, String pNewOwnerId, String pNewFolderType) throws Exception;
	public void copyFolder(int tenantId, String pFolderId, String pNewParentId, String pNewOwnerId, String pNewFolderType, String pCreatorId) throws Exception;
	public List<SimpleAddressVO> getSimpleAddress(int tenantId, String userId) throws Exception;
	public void setSimpleAddress(int tenantId, String pUserId, String pMailList) throws Exception;
	
	public List<AddressOldZipCodeVO> getZipCodeInfo(String dong) throws Exception;
	public List<String> getZipCodeSido() throws Exception;
	public List<AddressZipCodeVO> getAddressZipCodeList(String pSido, String pKeyword, int pPage) throws Exception;
	public int getAddressZipCodeCount(String pSido, String pKeyword) throws Exception;
	
}
