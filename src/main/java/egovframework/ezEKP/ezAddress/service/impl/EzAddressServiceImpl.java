package egovframework.ezEKP.ezAddress.service.impl;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezAddress.dao.EzAddressDAO;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezAddress.vo.AddressInfoVO;
import egovframework.ezEKP.ezAddress.vo.AddressVO;
import egovframework.ezEKP.ezAddress.vo.SimpleAddressVO;
import egovframework.ezEKP.ezAddress.vo.SubTreeInfoVO;

@Service("EzAddressService")
public class EzAddressServiceImpl implements EzAddressService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzAddressServiceImpl.class);
	
	@Resource(name = "EzAddressDAO")
	private EzAddressDAO ezAddressDAO;

	@Override
	public List<AddressVO> getAddressInfo(String dong) throws Exception {
		return ezAddressDAO.getAddressInfo(dong);
	}

	@Override
	public List<SimpleAddressVO> getSimpleAddress(String userId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("v_PUSERID", userId);
		
		return ezAddressDAO.getSimpleAddress(map);
	}

	@Override
	public void setSimpleAddress(String pUserId, String pMailList) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", pUserId);
		map.put("v_SN", 0);
		map.put("v_NAME", "");
		map.put("v_EMAIL", "");
		map.put("v_STATUS", 1);
		
		ezAddressDAO.setSimpleAddress(map);
		
		String[] mailList = pMailList.split("\\|");
		
		for (int i=0; i<mailList.length; i++) {
			map = new HashMap<String, Object>();
			map.put("v_USERID", pUserId);
			map.put("v_SN", i);
			map.put("v_NAME", mailList[i].split(";")[0]);
			map.put("v_EMAIL", mailList[i].split(";")[1]);
			map.put("v_STATUS", 0);
			
			ezAddressDAO.setSimpleAddress(map);
			
		}
	}

	@Override
	public List<SubTreeInfoVO> getSubTreeInfo(String pParentID, String pOwnerID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PARENTID", pParentID);
		map.put("v_OWNERID", makeRightField(pOwnerID));
		
		return ezAddressDAO.getSubTreeInfo(map);
	}
	
	@Override
	public String getListType(String userId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userId);
		
		return ezAddressDAO.getListType(map);
	}

	@Override
	public String getListCnt(String userId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userId);
		
		return ezAddressDAO.getListCnt(map);
	}

	@Override
	public String getAddressCount(String pFolderID, String pOwnerID, String pFilter) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", pOwnerID);
		map.put("v_PFOLDERID", pFolderID);
		map.put("v_PFILTER", pFilter);
		
		return ezAddressDAO.getAddressCount(map);
	}
	
	@Override
	public List<AddressInfoVO> getAddressList(String pFolderID, String pOwnerID, String pOrderOption,
			String pFilter, String pFieldList, int pFolderMaxCount, int pListPageSize, int pStart)
					throws Exception {
		
		if (pFieldList.equals("")) {
            pFieldList = "AddressID, CreatorID, ModifierID, HasAttach, HasComment, SNAME, SCOMPANY, SCOMPANYPHONE, SMOBILE, SEMAIL, STYPE";
		}
		
        if (pOrderOption.equals("")){
        	pOrderOption = "SNAME:0";
        }

        if (!pFilter.equals("")){
        	pFilter = " AND " + pFilter;
        }
		
        String orderName = pOrderOption.split(":")[0];
        String order1 = pOrderOption.split(":")[1];
        String order2 = "";
        
        if (order1.equals("0")) {
            order1 = " ASC, AddressID ASC";
            order2 = " DESC, AddressID DESC";
        } else {
            order1 = " DESC, AddressID DESC";
            order2 = " ASC, AddressID ASC";
        }
        
        if (pFolderID == null || pFolderID.equals("")) {
        	pFolderID = "0";
        }
        
        logger.debug("pFilter : " + pFilter);
        
        Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", makeRightField(pOwnerID));
		map.put("v_PFOLDERID", Integer.parseInt(pFolderID));
		map.put("v_PORDERNAME", orderName);
		map.put("v_PORDER1", order1);
		map.put("v_PORDER2", order2);
		map.put("v_PFILTER", pFilter);
		map.put("v_PFIELDLIST", pFieldList);
		map.put("v_PTOTAL", pFolderMaxCount);
		map.put("v_PSTART", pStart);
		map.put("v_PCOUNT", pListPageSize);
		
		return ezAddressDAO.getAddressList(map);
	}
	
	private String makeRightField(String pOrgStr) {
		if (pOrgStr == null) {
			return null;
		}
		
		return pOrgStr.replace("'", "''").replace("\0", "");
	}

	@Override
	public AddressInfoVO getAddressInfo2(String pAddressId) throws Exception {
		if (pAddressId == null || pAddressId.equals("")) {
			pAddressId = "0";
        }
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PADDRESSID", Integer.parseInt(pAddressId));
		
		return ezAddressDAO.getAddressInfo2(map);
	}

	@Override
	public int getSearchCount(String pIdList, String pFilter) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PIDLIST", pIdList);
		map.put("v_PFILTER", pFilter);
		
		return ezAddressDAO.getSearchCount(map);
	}

	@Override
	public void insertAddress(String pOwnerId, String pFolderId, String pCreatorId, String pCreatorName,
			String pCreatorName2, String pPhotoPath, String sName, String sCompany, String sDept, String sTitle,
			String sCompanyPhone, String sFax, String sMobile, String sEmail, String sHomePage, String sCompanyZip,
			String sCompanyAddr, String sHomeZip, String sHomeAddr, String sMemo, String sType, String pAttachXML)
					throws Exception {
		//TODO : 첨부파일(필요시)
		
		String hasAttach = "N";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", pOwnerId);
		map.put("v_PFOLDERID", pFolderId);
		map.put("v_PCREATORID", pCreatorId);
		map.put("v_PCREATORNAME", pCreatorName);
		map.put("v_PCREATORNAME2", pCreatorName2);
		map.put("v_PPHOTOPATH", pPhotoPath);
		map.put("v_PSNAME", sName);
		map.put("v_PSCOMPANY", sCompany);
		map.put("v_PSDEPT", sDept);
		map.put("v_PSTITLE", sTitle);
		map.put("v_PSCOMPANYPHONE", sCompanyPhone);
		map.put("v_PSFAX", sFax);
		map.put("v_PSMOBILE", sMobile);
		map.put("v_PSEMAIL", sEmail);
		map.put("v_PSHOMEPAGE", sHomePage);
		map.put("v_PSCOMPANYZIP", sCompanyZip);
		map.put("v_PSCOMPANYADDR", sCompanyAddr);
		map.put("v_PSHOMEZIP", sHomeZip);
		map.put("v_PSHOMEADDR", sHomeAddr);
		map.put("v_PSMEMO", sMemo);
		map.put("v_PSTYPE", sType);
		map.put("v_PHASATTACH", hasAttach);
		
		ezAddressDAO.insertAddress(map);
		
	}

	@Override
	public void updateAddress(String pAddressId, String pModifierID, String pModifierName, String pModifierName2,
			String pPhotoPath, String sName, String sCompany, String sDept, String sTitle, String sCompanyPhone,
			String sFax, String sMobile, String sEmail, String sHomePage, String sCompanyZip, String sCompanyAddr,
			String sHomeZip, String sHomeAddr, String sMemo, String pAttachXML) throws Exception {
		//TODO : 첨부파일(필요시)
		
		String hasAttach = "N";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PMODIFIERID", pModifierID);
		map.put("v_PMODIFIERNAME", pModifierName);
		map.put("v_PMODIFIERNAME2", pModifierName2);
		map.put("v_PPHOTOPATH", pPhotoPath);
		map.put("v_PSNAME", sName);
		map.put("v_PSCOMPANY", sCompany);
		map.put("v_PSDEPT", sDept);
		map.put("v_PSTITLE", sTitle);
		map.put("v_PSCOMPANYPHONE", sCompanyPhone);
		map.put("v_PSFAX", sFax);
		map.put("v_PSMOBILE", sMobile);
		map.put("v_PSEMAIL", sEmail);
		map.put("v_PSHOMEPAGE", sHomePage);
		map.put("v_PSCOMPANYZIP", sCompanyZip);
		map.put("v_PSCOMPANYADDR", sCompanyAddr);
		map.put("v_PSHOMEZIP", sHomeZip);
		map.put("v_PSHOMEADDR", sHomeAddr);
		map.put("v_PSMEMO", sMemo);
		map.put("v_PHASATTACH", hasAttach);
		map.put("v_PADDRESSID", pAddressId);
		
		ezAddressDAO.updateAddress(map);
		
	}

	@Override
	public void deleteAddress(String pAddressId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PADDRESSID", pAddressId);
		
		ezAddressDAO.deleteAddress(map);
	}

	@Override
	public void setAddressConfig(String pUserID, String pListCnt, String pListType) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", pUserID);
		map.put("v_PLISTCNT", Integer.parseInt(pListCnt));
		map.put("v_PLISTTYPE", pListType);
		
		ezAddressDAO.setAddressConfig(map);
	}

	@Override
	public void moveAddress(String pAddressId, String pFolderId, String pOwnerId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PADDRESSID", Integer.parseInt(pAddressId));
		map.put("v_PFOLDERID", Integer.parseInt(pFolderId));
		map.put("v_POWNERID", pOwnerId);
		
		ezAddressDAO.moveAddress(map);
	}

	@Override
	public void copyAddress(String pAddressId, String pFolderId, String pOwnerId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PADDRESSID", Integer.parseInt(pAddressId));
		map.put("v_PFOLDERID", Integer.parseInt(pFolderId));
		map.put("v_POWNERID", pOwnerId);
		
		ezAddressDAO.copyAddress(map);
	}

	@Override
	public int getMaxSeq(String pParentId, String pOwnerId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PPARENTID", pParentId);
		map.put("v_POWNERID", pOwnerId);
		
		return ezAddressDAO.getMaxSeq(map);
	}

	@Override
	public String insertFolder(String pParentId, String pOwnerId, String pFolderType, String pFolderName,
			String pFolderName2, int pMaxSeq) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PPARENTID", Integer.parseInt(pParentId));
		map.put("v_POWNERID", pOwnerId);
		map.put("v_PFOLDERTYPE", pFolderType);
		map.put("v_PFOLDERNAME", pFolderName);
		map.put("v_PFOLDERNAME2", pFolderName2);
		map.put("v_PMAXSEQ", pMaxSeq);
		
		return ezAddressDAO.insertFolder(map);
	}

	@Override
	public void updateFolder(String pFolderId, String pFolderName, String pFolderName2) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PFOLDERID", Integer.parseInt(pFolderId));
		map.put("v_PFOLDERNAME", pFolderName);
		map.put("v_PFOLDERNAME2", pFolderName2);
		
		ezAddressDAO.updateFolder(map);
	}

	@Override
	public void deleteFolder(String pFolderId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PFOLDERID", Integer.parseInt(pFolderId));
		
		ezAddressDAO.deleteFolder(map);
	}

	@Override
	public void moveFolder(String pFolderId, String pNewParentId, String pNewOwnerId, String pNewFolderType)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PFOLDERID", Integer.parseInt(pFolderId));
		map.put("v_PNEWPARENTID", Integer.parseInt(pNewParentId));
		map.put("v_PNEWOWNERID", pNewOwnerId);
		map.put("v_PNEWFOLDERTYPE", pNewFolderType);
		
		ezAddressDAO.moveFolder(map);
	}

	@Override
	public void copyFolder(String pFolderId, String pNewParentId, String pNewOwnerId, String pNewFolderType)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PFOLDERID", Integer.parseInt(pFolderId));
		map.put("v_PNEWPARENTID", Integer.parseInt(pNewParentId));
		map.put("v_PNEWOWNERID", pNewOwnerId);
		map.put("v_PNEWFOLDERTYPE", pNewFolderType);
		
		ezAddressDAO.copyFolder(map);
	}

	@Override
	public List<AddressInfoVO> getSearchList(String pIdList, String pOrderOption, String pFilter, String pFieldList,
			int pFolderMaxCount, int pListPageSize, int pStart) throws Exception {
		if (pFieldList.equals("")) {
            pFieldList = "AddressID, FolderID, OwnerID, CreatorID, ModifierID, HasAttach, HasComment, SNAME, SCOMPANY, SCOMPANYPHONE, SMOBILE, SEMAIL, STYPE";
		}
		
        if (pOrderOption.equals("")){
        	pOrderOption = "SNAME:0";
        }

        if (!pFilter.equals("")){
        	pFilter = " AND " + pFilter;
        }
		
        String orderName = pOrderOption.split(":")[0];
        String order1 = pOrderOption.split(":")[1];
        String order2 = "";
        
        if (order1.equals("0")) {
            order1 = " ASC, AddressID ASC";
            order2 = " DESC, AddressID DESC";
        } else {
            order1 = " DESC, AddressID DESC";
            order2 = " ASC, AddressID ASC";
        }
        
        logger.debug("pIdList : " + pIdList);
        logger.debug("pFilter : " + pFilter);
        
        Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PIDLIST", pIdList);
		map.put("v_PORDERNAME", orderName);
		map.put("v_PORDER1", order1);
		map.put("v_PORDER2", order2);
		map.put("v_PFILTER", pFilter);
		map.put("v_PFIELDLIST", pFieldList);
		map.put("v_PTOTAL", pFolderMaxCount);
		map.put("v_PSTART", pStart);
		map.put("v_PCOUNT", pListPageSize);
		
		return ezAddressDAO.getSearchList(map);
		
	}

	@Override
	public SubTreeInfoVO getFolderInfo(String pFolderId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PFOLDERID", Integer.parseInt(pFolderId));
		
		return ezAddressDAO.getFolderInfo(map);
	}

}
