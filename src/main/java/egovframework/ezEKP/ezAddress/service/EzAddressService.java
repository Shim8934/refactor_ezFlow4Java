package egovframework.ezEKP.ezAddress.service;

import java.util.List;

import egovframework.ezEKP.ezAddress.vo.AddressInfoVO;
import egovframework.ezEKP.ezAddress.vo.AddressVO;
import egovframework.ezEKP.ezAddress.vo.SimpleAddressVO;
import egovframework.ezEKP.ezAddress.vo.SubTreeInfoVO;

public interface EzAddressService {

	public List<AddressVO> getAddressInfo(String dong) throws Exception;
	public List<SimpleAddressVO> getSimpleAddress(String userId) throws Exception;
	public void setSimpleAddress(String pUserId, String pMailList) throws Exception;
	public List<SubTreeInfoVO> getSubTreeInfo(String pParentID, String pOwnerID) throws Exception;
	public String getListType(String userId) throws Exception;
	public String getListCnt(String userId) throws Exception;
	public String getAddressCount(String pFolderID, String pOwnerID, String pFilter) throws Exception;
	public List<AddressInfoVO> getAddressList(String pFolderID, String pOwnerID, String pOrderOption, String pFilter, String pFieldList, int pFolderMaxCount, int pListPageSize, int pStart) throws Exception;
	public AddressInfoVO getAddressInfo2(String pAddressId) throws Exception;
	public int getSearchCount(String pIdList, String pFilter) throws Exception;
	public void insertAddress(String pOwnerId, int pFolderId, String pCreatorId, String pCreatorName, String pCreatorName2, String pPhotoPath, String sName,
			String sCompany, String sDept, String sTitle, String sCompanyPhone, String sFax, String sMobile, String sEmail, String sHomePage, String sCompanyZip,
			String sCompanyAddr, String sHomeZip, String sHomeAddr, String sMemo, String sType, String pAttachXML) throws Exception;
	public void updateAddress(String pAddressId, String pModifierID, String pModifierName, String pModifierName2, String pPhotoPath, String sName,
			String sCompany, String sDept, String sTitle, String sCompanyPhone, String sFax, String sMobile, String sEmail, String sHomePage, String sCompanyZip,
			String sCompanyAddr, String sHomeZip, String sHomeAddr, String sMemo, String pAttachXML) throws Exception;
	public void deleteAddress(String pAddressId) throws Exception;
	public void setAddressConfig(String pUserID, String pListCnt, String pListType) throws Exception;
	public void moveAddress(String pAddressId, String pFolderId, String pOwnerId) throws Exception;
	public void copyAddress(String pAddressId, String pFolderId, String pOwnerId) throws Exception;
	public int getMaxSeq(String pParentId, String pOwnerId) throws Exception;
	public String insertFolder(String pParentId, String pOwnerId, String pFolderType, String pFolderName, String pFolderName2, int pMaxSeq) throws Exception;
	public void updateFolder(String pFolderId, String pFolderName, String pFolderName2) throws Exception;
	public void deleteFolder(String pFolderId) throws Exception;
	public void moveFolder(String pFolderId, String pNewParentId, String pNewOwnerId, String pNewFolderType) throws Exception;
	public String copyFolder(String pFolderId, String pNewParentId, String pNewOwnerId, String pNewFolderType) throws Exception;
	public List<AddressInfoVO> getSearchList(String pIdList, String pOrderOption, String pFilter, String pFieldList, int pFolderMaxCount, int pListPageSize, int pStart) throws Exception;
	
}
