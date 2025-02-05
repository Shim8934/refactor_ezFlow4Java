package egovframework.ezEKP.ezAddress.service;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezAddress.vo.AddressFolderVO;
import egovframework.ezEKP.ezAddress.vo.AddressVO;
import egovframework.ezEKP.ezAddress.vo.SimpleAddressVO;

public interface EzAddressService {
	
	public boolean checkAddressAccessPermission(String addressId, String loginCookie) throws Exception;
	public Map<String, String> getTopFolderSubCount(int tenantId, String userId, String deptId, String companyId) throws Exception;
	public String getListType(int tenantId, String userId) throws Exception;
	public String getListCnt(int tenantId, String userId) throws Exception;
	public void setAddressConfig(int tenantId, String pUserID, String pListCnt, String pListType) throws Exception;
	public int getAddressCount(int tenantId, String pFolderId, String pOwnerId, String pFilter) throws Exception;
	public int getAddressCount(int tenantId, String pFolderId, String pOwnerId, String pFilter, String addressType) throws Exception;
	public int getSearchCount(int tenantId, String[] pIdLists, String pFilter) throws Exception;
	public int getSearchCount(int tenantId, String[] pIdLists, String pFilter, String addressType) throws Exception;
	public int getAddressSearchCount(int tenantId, String pFolderId, String[] pOwnerId, String pFilter) throws Exception;
	public int getFilterAddressSearchCount(int tenantId, String pFolderId, String[] pOwnerId, String pFilter, String pAddressTpe) throws Exception;
	public List<AddressVO> getAddressSearchList(int tenantId, String pFolderID, String[] pOwnerIDs, String pOrderOption, String pFilter, int pListPageSize, int pStart) throws Exception;
	public List<AddressVO> getFilterAddressSearchList(int tenantId, String pFolderID, String[] pOwnerIDs, String pOrderOption, String pFilter, int pListPageSize, int pStart, String pAddressTpe) throws Exception;
	public List<AddressVO> getAddressList(int tenantId, String pFolderID, String pOwnerID, String pOrderOption, String pFilter, int pListPageSize, int pStart) throws Exception;
	public List<AddressVO> getAddressList(int tenantId, String pFolderID, String pOwnerID, String pOrderOption, String pFilter, int pListPageSize, int pStart, String addressType) throws Exception;
	public List<AddressVO> getAllAddressList(int tenantId, String pFolderID, String pOwnerID, String pOrderOption, String pFilter) throws Exception;
	public List<AddressVO> getSearchList(int tenantId, String[] pIdLists, String pOrderOption, String pFilter, int pListPageSize, int pStart) throws Exception;
	public List<AddressVO> getSearchList(int tenantId, String[] pIdLists, String pOrderOption, String pFilter, int pListPageSize, int pStart, String addressType) throws Exception;
	public boolean checkDuplicateAddress(int tenantId, String ownerId, String sEmail) throws Exception;
	public AddressVO getAddressInfo(int tenantId, String primary, String pAddressId) throws Exception;
	public void insertAddress(int tenantId, String pOwnerId, String pFolderId, String pCreatorId, String pCreatorName, String pCreatorName2,
			String sName, String sEmail, String sCompany, String sDept, String sTitle, 
			String sCompanyPhone, String sFax, String sMobile, String sHomePage, 
			String sCompanyZip, String sCompanyAddr, String sHomeZip, String sHomeAddr, String sMemo, String sType, String sFurigana) throws Exception;
	public void updateAddress(int tenantId, String pAddressId, String pModifierId, String pModifierName, String pModifierName2,
			String sName, String sEmail, String sCompany, String sDept, String sTitle,
			String sCompanyPhone, String sFax, String sMobile, String sHomePage, 
			String sCompanyZip, String sCompanyAddr, String sHomeZip, String sHomeAddr, String sMemo, String sFurigana) throws Exception;
	public void deleteAddress(String[] pAddressIds) throws Exception;
	public void moveAddress(int tenantId, String[] pAddressIds, String pFolderId, String pOwnerId) throws Exception;
	public void copyAddress(int tenantId, String[] pAddressIds, String pFolderId, String pOwnerId, String pCreatorId, String pCreatorName, String pCreatorName2) throws Exception;
	public List<AddressFolderVO> getSubTreeInfo(int tenantId, String pParentID, String pOwnerID) throws Exception;
	public List<AddressFolderVO> getHighTreeInfo(int tenantId, String folderID, String pOwnerID) throws Exception;
	public List<AddressFolderVO> getLowTreeInfo(int tenantId, String folderID, String pOwnerID) throws Exception;
	public AddressFolderVO getFolderInfo(String pFolderId) throws Exception;
	public void insertFolder(int tenantId, String pParentId, String pOwnerId, String pFolderType, String pFolderName) throws Exception;
	public void updateFolder(String pFolderId, String pFolderName) throws Exception;
	public void deleteFolder(String pFolderId) throws Exception;
	public void moveFolder(int tenantId, String pFolderId, String pNewParentId, String pNewOwnerId, String pNewFolderType) throws Exception;
	public void copyFolder(int tenantId, String pFolderId, String pNewParentId, String pNewOwnerId, String pNewFolderType, String pCreatorId, String pCreatorName, String pCreatorName2) throws Exception;
	public List<SimpleAddressVO> getSimpleAddress(int tenantId, String userId) throws Exception;
	public void setSimpleAddress(int tenantId, String pUserId, String pMailList) throws Exception;
	public int removeUserAddress(String userEmailAddress) throws Exception;
	public List<AddressVO> getLastSentEmailAddresses(int tenantId, String cn) throws Exception;
	public void insertLastSentEmailAddresses(List<Map<String, Object>> lastSentEmailAddresses, int tenantId, String cn) throws Exception;
	public void deleteLastSentEmailAddress(int tenantId, String cn, String email) throws Exception;
	
	public Map<String, Object> getAddressZipCodeList(String pSido, String pKeyword, int pPage) throws Exception;
}
