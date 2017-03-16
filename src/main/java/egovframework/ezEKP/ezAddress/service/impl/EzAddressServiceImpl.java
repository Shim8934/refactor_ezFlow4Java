package egovframework.ezEKP.ezAddress.service.impl;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezAddress.dao.EzAddressDAO;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezAddress.vo.AddressVO;
import egovframework.ezEKP.ezAddress.vo.AddressOldZipCodeVO;
import egovframework.ezEKP.ezAddress.vo.AddressZipCodeVO;
import egovframework.ezEKP.ezAddress.vo.SimpleAddressVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezAddress.vo.AddressFolderVO;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;

@Service("EzAddressService")
public class EzAddressServiceImpl implements EzAddressService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzAddressServiceImpl.class);
	
	@Autowired
    private Properties config;
	
	@Autowired
    private EzEmailUtil ezEmailUtil;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "EzAddressDAO")
	private EzAddressDAO ezAddressDAO;
	
	@Override
	public String getListType(int tenantId, String userId) throws Exception {
		String listType = null;
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String inputParams = "userId=" + URLEncoder.encode(userId + "@" + domainName, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/getListType", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	listType = (String)object.get("result");
        } else {
        	throw new Exception("Error from JGwServer.");
        }
        
        return listType;
	}
	
	@Override
	public String getListCnt(int tenantId, String userId) throws Exception {
		String listCnt = null;
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String inputParams = "userId=" + URLEncoder.encode(userId + "@" + domainName, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/getListCnt", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	listCnt = (String)object.get("result");
        } else {
        	throw new Exception("Error from JGwServer.");
        }
        
        return listCnt;
	}
	
	@Override
	public void setAddressConfig(int tenantId, String pUserID, String pListCnt, String pListType) throws Exception {
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String userIdIdParam = "userId=" + URLEncoder.encode(pUserID + "@" + domainName, "UTF-8");
		String listCntParam = "listCnt=" + URLEncoder.encode(pListCnt, "UTF-8");
		String listTypeParam = "listType=" + URLEncoder.encode(pListType, "UTF-8");
		
		String inputParams = userIdIdParam + "&" + listCntParam + "&" + listTypeParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/setAddressGeneral", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("Error from JGwServer.");
        }
	}
	
	@Override
	public int getAddressCount(int tenantId, String pFolderId, String pOwnerId, String pFilter) throws Exception {
		int count = 0;
		
		String filterName = null;
		String filterValue = null;
		
		if (pFilter == null || pFilter.trim().equals("")) {
			filterName = "NONE";
			filterValue = "";
		}
		else if (pFilter.indexOf(",") > -1) {
			int splitIndex = pFilter.indexOf(",");
			filterName = pFilter.substring(0, splitIndex);
			filterValue = pFilter.substring(splitIndex + 1);
		} else {
			logger.error("Invalid pFilter parameter. pFilter=" + pFilter);
			filterName = "NONE";
			filterValue = "";
		}
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String ownerIdParam = "ownerId=" + URLEncoder.encode(pOwnerId + "@" + domainName, "UTF-8");
		String folderIdParam = "folderId=" + URLEncoder.encode(pFolderId, "UTF-8");
		String filterNameParam = "filterName=" + URLEncoder.encode(filterName, "UTF-8");
		String filterValueParam = "filterValue=" + URLEncoder.encode(filterValue, "UTF-8");
		
		String inputParams = ownerIdParam + "&" + folderIdParam + "&" + filterNameParam + "&" + filterValueParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/getFolderAddressCount", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
			count = ((Long)object.get("result")).intValue();
        } else {
        	throw new Exception("Error from JGwServer.");
        }
		
        return count;
	}
	
	@Override
	public int getSearchCount(int tenantId, String[] pIdLists, String pFilter) throws Exception {
		int count = 0;
		
		String filterName = null;
		String filterValue = null;
		
		if (pFilter.indexOf(",") > -1) {
			int splitIndex = pFilter.indexOf(",");
			filterName = pFilter.substring(0, splitIndex);
			filterValue = pFilter.substring(splitIndex + 1);
		}
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String filterNameParam = "filterName=" + URLEncoder.encode(filterName, "UTF-8");
		String filterValueParam = "filterValue=" + URLEncoder.encode(filterValue, "UTF-8");
		
		String inputParams = filterNameParam + "&" + filterValueParam;
		
		for (String ownerId : pIdLists) {
			inputParams += "&ownerId=" + URLEncoder.encode(ownerId + "@" + domainName, "UTF-8");
		}
		
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/getOwnerAddressCount", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
			count = ((Long)object.get("result")).intValue();
        } else {
        	throw new Exception("Error from JGwServer.");
        }
		
        return count;
	}
	
	@Override
	public List<AddressVO> getAddressList(int tenantId, String pFolderID, String pOwnerID, String pOrderOption,
			String pFilter, int count, int start) throws Exception {
		List<AddressVO> list = new ArrayList<AddressVO>();
		
		String filterName = null;
		String filterValue = null;
		
		if (pFilter == null || pFilter.trim().equals("")) {
			filterName = "NONE";
			filterValue = "";
		}
		else if (pFilter.indexOf(",") > -1) {
			int splitIndex = pFilter.indexOf(",");
			filterName = pFilter.substring(0, splitIndex);
			filterValue = pFilter.substring(splitIndex + 1);
		}
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String folderIdParam = "folderId=" + URLEncoder.encode(pFolderID, "UTF-8");
		String ownerIdParam = "ownerId=" + URLEncoder.encode(pOwnerID + "@" + domainName, "UTF-8");
		String orderOptionParam = "orderOption=" + URLEncoder.encode(pOrderOption, "UTF-8");
		String startParam = "start=" + start;
		String countParam = "count=" + count;
		String filterNameParam = "filterName=" + URLEncoder.encode(filterName, "UTF-8");
		String filterValueParam = "filterValue=" + URLEncoder.encode(filterValue, "UTF-8");
		
		String inputParams = folderIdParam + "&" + ownerIdParam + "&" + orderOptionParam 
				+ "&" + startParam + "&" + countParam + "&" + filterNameParam + "&" + filterValueParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/getFolderAddressList", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
			JSONArray resultArray = (JSONArray)object.get("result");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		AddressVO vo = new AddressVO();
        		
        		vo.setAddressId((String)obj.get("addressId"));
        		vo.setFolderId((String)obj.get("folderId"));
        		vo.setOwnerId(((String)obj.get("ownerId")).split("@")[0]);
        		vo.setCreatorId(((String)obj.get("creatorId")).split("@")[0]);
        		vo.setModifierId(((String)obj.get("modifierId")).split("@")[0]);
        		vo.setsName((String)obj.get("sName"));
        		vo.setsEmail((String)obj.get("sEmail"));
        		vo.setsCompany((String)obj.get("sCompany"));
        		vo.setsCompanyPhone((String)obj.get("sCompanyPhone"));
        		vo.setsMobile((String)obj.get("sMobile"));
        		vo.setsType((String)obj.get("sType"));
        		
				list.add(vo);
        	}
        }
		
		return list;
	}
	
	@Override
	public List<AddressVO> getAllAddressList(int tenantId, String pFolderID, String pOwnerID, String pOrderOption, String pFilter) 
			throws Exception {
		List<AddressVO> list = new ArrayList<AddressVO>();
		
		String filterName = null;
		String filterValue = null;
		
		if (pFilter == null || pFilter.trim().equals("")) {
			filterName = "NONE";
			filterValue = "";
		}
		else if (pFilter.indexOf(",") > -1) {
			int splitIndex = pFilter.indexOf(",");
			filterName = pFilter.substring(0, splitIndex);
			filterValue = pFilter.substring(splitIndex + 1);
		}
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String folderIdParam = "folderId=" + URLEncoder.encode(pFolderID, "UTF-8");
		String ownerIdParam = "ownerId=" + URLEncoder.encode(pOwnerID + "@" + domainName, "UTF-8");
		String orderOptionParam = "orderOption=" + URLEncoder.encode(pOrderOption, "UTF-8");
		String filterNameParam = "filterName=" + URLEncoder.encode(filterName, "UTF-8");
		String filterValueParam = "filterValue=" + URLEncoder.encode(filterValue, "UTF-8");
		
		String inputParams = folderIdParam + "&" + ownerIdParam + "&" + orderOptionParam 
				+ "&" + filterNameParam + "&" + filterValueParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/getFolderAllAddressList", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
			JSONArray resultArray = (JSONArray)object.get("result");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject resultObject = (JSONObject)resultArray.get(i);
        		
        		AddressVO vo = new AddressVO();
        		
        		vo.setAddressId((String)resultObject.get("addressId"));
        		vo.setFolderId((String)resultObject.get("folderId"));
        		vo.setOwnerId(((String)resultObject.get("ownerId")).split("@")[0]);
        		vo.setCreatorId(((String)resultObject.get("creatorId")).split("@")[0]);
        		vo.setCreateDate((String)resultObject.get("createDate"));
        		vo.setModifierId(((String)resultObject.get("modifierId")).split("@")[0]);
        		vo.setModifyDate((String)resultObject.get("modifyDate"));
        		vo.setsName((String)resultObject.get("sName"));
        		vo.setsEmail((String)resultObject.get("sEmail"));
        		vo.setsCompany((String)resultObject.get("sCompany"));
        		vo.setsDept((String)resultObject.get("sDept"));
        		vo.setsTitle((String)resultObject.get("sTitle"));
        		vo.setsCompanyPhone((String)resultObject.get("sCompanyPhone"));
        		vo.setsFax((String)resultObject.get("sFax"));
        		vo.setsMobile((String)resultObject.get("sMobile"));
        		vo.setsHomePage((String)resultObject.get("sHomepage"));
        		vo.setsCompanyZip((String)resultObject.get("sCompanyZip"));
        		vo.setsCompanyAddr((String)resultObject.get("sCompanyAddr"));
        		vo.setsHomeZip((String)resultObject.get("sHomeZip"));
        		vo.setsHomeAddr((String)resultObject.get("sHomeAddr"));
        		vo.setsMemo((String)resultObject.get("sMemo"));
        		vo.setsType((String)resultObject.get("sType"));
        		
				list.add(vo);
        	}
        }
		
		return list;
	}
	
	@Override
	public List<AddressVO> getSearchList(int tenantId, String[] pIdLists, String pOrderOption, String pFilter,
			int count, int start) throws Exception {
		List<AddressVO> list = new ArrayList<AddressVO>();
		
		String filterName = null;
		String filterValue = null;
		
		if (pFilter.indexOf(",") > -1) {
			int splitIndex = pFilter.indexOf(",");
			filterName = pFilter.substring(0, splitIndex);
			filterValue = pFilter.substring(splitIndex + 1);
		}
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String orderOptionParam = "orderOption=" + URLEncoder.encode(pOrderOption, "UTF-8");
		String startParam = "start=" + start;
		String countParam = "count=" + count;
		String filterNameParam = "filterName=" + URLEncoder.encode(filterName, "UTF-8");
		String filterValueParam = "filterValue=" + URLEncoder.encode(filterValue, "UTF-8");
		
		String inputParams = orderOptionParam + "&" + startParam + "&" + countParam + "&" + filterNameParam + "&" + filterValueParam;
		
		for (String ownerId : pIdLists) {
			inputParams += "&ownerId=" + URLEncoder.encode(ownerId + "@" + domainName, "UTF-8");
		}
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/getOwnerAddressList", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
			JSONArray resultArray = (JSONArray)object.get("result");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		AddressVO vo = new AddressVO();
        		
        		vo.setAddressId((String)obj.get("addressId"));
        		vo.setFolderId((String)obj.get("folderId"));
        		vo.setOwnerId(((String)obj.get("ownerId")).split("@")[0]);
        		vo.setCreatorId(((String)obj.get("creatorId")).split("@")[0]);
        		vo.setModifierId(((String)obj.get("modifierId")).split("@")[0]);
        		vo.setsName((String)obj.get("sName"));
        		vo.setsEmail((String)obj.get("sEmail"));
        		vo.setsCompany((String)obj.get("sCompany"));
        		vo.setsCompanyPhone((String)obj.get("sCompanyPhone"));
        		vo.setsMobile((String)obj.get("sMobile"));
        		vo.setsType((String)obj.get("sType"));
        		
				list.add(vo);
        	}
        }
		
		return list;
	}
	
	@Override
	public boolean checkDuplicateAddress(int tenantId, String ownerId, String sEmail) throws Exception {
		boolean isDuplicate = true;
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String ownerIdParam = "ownerId=" + URLEncoder.encode(ownerId + "@" + domainName, "UTF-8");
		String sEmailParam = "sEmail=" + URLEncoder.encode(sEmail, "UTF-8");
		
		String inputParams = ownerIdParam + "&" + sEmailParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/checkDuplicateAddress", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
			isDuplicate = ((Boolean)object.get("result"));
        } else {
        	throw new Exception("Error from JGwServer.");
        }
		
        return isDuplicate;
	}
	
	@Override
	public AddressVO getAddressInfo(int tenantId, String primary, String pAddressId) throws Exception {
		AddressVO vo = new AddressVO();
		
		String inputParams = "addressId=" + URLEncoder.encode(pAddressId, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/getAddressInfo", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
			JSONObject resultObject = (JSONObject)object.get("result");
        		
    		vo.setAddressId((String)resultObject.get("addressId"));
    		vo.setFolderId((String)resultObject.get("folderId"));
    		vo.setOwnerId(((String)resultObject.get("ownerId")).split("@")[0]);
    		vo.setCreatorId(((String)resultObject.get("creatorId")).split("@")[0]);
    		vo.setCreateDate((String)resultObject.get("createDate"));
    		vo.setModifierId(((String)resultObject.get("modifierId")).split("@")[0]);
    		vo.setModifyDate((String)resultObject.get("modifyDate"));
    		vo.setsName((String)resultObject.get("sName"));
    		vo.setsEmail((String)resultObject.get("sEmail"));
    		vo.setsCompany((String)resultObject.get("sCompany"));
    		vo.setsDept((String)resultObject.get("sDept"));
    		vo.setsTitle((String)resultObject.get("sTitle"));
    		vo.setsCompanyPhone((String)resultObject.get("sCompanyPhone"));
    		vo.setsFax((String)resultObject.get("sFax"));
    		vo.setsMobile((String)resultObject.get("sMobile"));
    		vo.setsHomePage((String)resultObject.get("sHomepage"));
    		vo.setsCompanyZip((String)resultObject.get("sCompanyZip"));
    		vo.setsCompanyAddr((String)resultObject.get("sCompanyAddr"));
    		vo.setsHomeZip((String)resultObject.get("sHomeZip"));
    		vo.setsHomeAddr((String)resultObject.get("sHomeAddr"));
    		vo.setsMemo((String)resultObject.get("sMemo"));
    		vo.setsType((String)resultObject.get("sType"));
    		
    		OrganUserVO creatorVO = ezOrganAdminService.getUserInfo(((String)resultObject.get("creatorId")).split("@")[0], primary, tenantId);
    		vo.setCreatorName(creatorVO.getDisplayName());
    		
    		OrganUserVO modifierVO = ezOrganAdminService.getUserInfo(((String)resultObject.get("modifierId")).split("@")[0], primary, tenantId);
    		vo.setModifierName(modifierVO.getDisplayName());
        } else {
        	throw new Exception("Error from JGwServer.");
        }
		
		return vo;
	}
	
	@Override
	public void insertAddress(int tenantId, String pOwnerId, String pFolderId, String pCreatorId,
			String sName, String sEmail, String sCompany, String sDept, String sTitle,
			String sCompanyPhone, String sFax, String sMobile, String sHomePage, 
			String sCompanyZip, String sCompanyAddr, String sHomeZip, String sHomeAddr,
			String sMemo, String sType) throws Exception {
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String folderIdIdParam = "folderId=" + URLEncoder.encode(pFolderId, "UTF-8");
		String ownerIdParam = "ownerId=" + URLEncoder.encode(pOwnerId + "@" + domainName, "UTF-8");
		String creatorIdParam = "creatorId=" + URLEncoder.encode(pCreatorId + "@" + domainName, "UTF-8");
		String sNameParam = "sName=" + URLEncoder.encode(sName, "UTF-8");
		String sEmailParam = "sEmail=" + URLEncoder.encode(sEmail, "UTF-8");
		String sCompanyParam = "sCompany=" + URLEncoder.encode(sCompany, "UTF-8");
		String sDeptParam = "sDept=" + URLEncoder.encode(sDept, "UTF-8");
		String sTitleParam = "sTitle=" + URLEncoder.encode(sTitle, "UTF-8");
		String sCompanyPhoneParam = "sCompanyPhone=" + URLEncoder.encode(sCompanyPhone, "UTF-8");
		String sFaxParam = "sFax=" + URLEncoder.encode(sFax, "UTF-8");
		String sMobileParam = "sMobile=" + URLEncoder.encode(sMobile, "UTF-8");
		String sHomepageParam = "sHomepage=" + URLEncoder.encode(sHomePage, "UTF-8");
		String sCompanyZipParam = "sCompanyZip=" + URLEncoder.encode(sCompanyZip, "UTF-8");
		String sCompanyAddrParam = "sCompanyAddr=" + URLEncoder.encode(sCompanyAddr, "UTF-8");
		String sHomeZipParam = "sHomeZip=" + URLEncoder.encode(sHomeZip, "UTF-8");
		String sHomeAddrParam = "sHomeAddr=" + URLEncoder.encode(sHomeAddr, "UTF-8");
		String sMemoParam = "sMemo=" + URLEncoder.encode(sMemo, "UTF-8");
		String sTypeParam = "sType=" + URLEncoder.encode(sType, "UTF-8");
		
		String inputParams = folderIdIdParam + "&" + ownerIdParam + "&" + creatorIdParam
				 + "&" + sNameParam + "&" + sEmailParam + "&" + sCompanyParam + "&" + sDeptParam + "&" + sTitleParam
				 + "&" + sCompanyPhoneParam + "&" + sFaxParam + "&" + sMobileParam + "&" + sHomepageParam
				 + "&" + sCompanyZipParam + "&" + sCompanyAddrParam + "&" + sHomeZipParam + "&" + sHomeAddrParam
				 + "&" + sMemoParam + "&" + sTypeParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/addAddress", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("Error from JGwServer.");
        }
	}
	
	@Override
	public void updateAddress(int tenantId, String pAddressId, String pModifierId, 
			String sName, String sEmail, String sCompany, String sDept, String sTitle,
			String sCompanyPhone, String sFax, String sMobile, String sHomePage, 
			String sCompanyZip, String sCompanyAddr, String sHomeZip, String sHomeAddr, String sMemo) throws Exception {
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String addressIdIdParam = "addressId=" + URLEncoder.encode(pAddressId, "UTF-8");
		String modifierIdParam = "modifierId=" + URLEncoder.encode(pModifierId + "@" + domainName, "UTF-8");
		String sNameParam = "sName=" + URLEncoder.encode(sName, "UTF-8");
		String sEmailParam = "sEmail=" + URLEncoder.encode(sEmail, "UTF-8");
		String sCompanyParam = "sCompany=" + URLEncoder.encode(sCompany, "UTF-8");
		String sDeptParam = "sDept=" + URLEncoder.encode(sDept, "UTF-8");
		String sTitleParam = "sTitle=" + URLEncoder.encode(sTitle, "UTF-8");
		String sCompanyPhoneParam = "sCompanyPhone=" + URLEncoder.encode(sCompanyPhone, "UTF-8");
		String sFaxParam = "sFax=" + URLEncoder.encode(sFax, "UTF-8");
		String sMobileParam = "sMobile=" + URLEncoder.encode(sMobile, "UTF-8");
		String sHomepageParam = "sHomepage=" + URLEncoder.encode(sHomePage, "UTF-8");
		String sCompanyZipParam = "sCompanyZip=" + URLEncoder.encode(sCompanyZip, "UTF-8");
		String sCompanyAddrParam = "sCompanyAddr=" + URLEncoder.encode(sCompanyAddr, "UTF-8");
		String sHomeZipParam = "sHomeZip=" + URLEncoder.encode(sHomeZip, "UTF-8");
		String sHomeAddrParam = "sHomeAddr=" + URLEncoder.encode(sHomeAddr, "UTF-8");
		String sMemoParam = "sMemo=" + URLEncoder.encode(sMemo, "UTF-8");
		
		String inputParams = addressIdIdParam + "&" + modifierIdParam
				 + "&" + sNameParam + "&" + sEmailParam + "&" + sCompanyParam + "&" + sDeptParam + "&" + sTitleParam
				 + "&" + sCompanyPhoneParam + "&" + sFaxParam + "&" + sMobileParam + "&" + sHomepageParam
				 + "&" + sCompanyZipParam + "&" + sCompanyAddrParam + "&" + sHomeZipParam + "&" + sHomeAddrParam
				 + "&" + sMemoParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/modAddress", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("Error from JGwServer.");
        }
		
	}
	
	@Override
	public void deleteAddress(String[] pAddressIds) throws Exception {
		String inputParams = "addressId=" + URLEncoder.encode(pAddressIds[0], "UTF-8");
		for (int i=1; i<pAddressIds.length; i++) {
			inputParams += "&addressId=" + URLEncoder.encode(pAddressIds[i], "UTF-8");
		}
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/delAddress", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("Error from JGwServer.");
        }
	}
	
	@Override
	public void moveAddress(int tenantId, String[] pAddressIds, String pFolderId, String pOwnerId) throws Exception {
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String folderIdParam = "folderId=" + URLEncoder.encode(pFolderId, "UTF-8");
		String ownerIdParam = "ownerId=" + URLEncoder.encode(pOwnerId + "@" + domainName, "UTF-8");
		
		String inputParams = folderIdParam + "&" + ownerIdParam;
		
		for (String addressId : pAddressIds) {
			inputParams += "&addressId=" + URLEncoder.encode(addressId, "UTF-8");
		}
		
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/moveAddress", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("Error from JGwServer.");
        }
	}
	
	@Override
	public void copyAddress(int tenantId, String[] pAddressIds, String pFolderId, String pOwnerId, String pCreatorId) throws Exception {
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String folderIdParam = "folderId=" + URLEncoder.encode(pFolderId, "UTF-8");
		String ownerIdParam = "ownerId=" + URLEncoder.encode(pOwnerId + "@" + domainName, "UTF-8");
		String creatorIdParam = "creatorId=" + URLEncoder.encode(pCreatorId + "@" + domainName, "UTF-8");
		
		String inputParams = folderIdParam + "&" + ownerIdParam + "&" + creatorIdParam;
		
		for (String addressId : pAddressIds) {
			inputParams += "&addressId=" + URLEncoder.encode(addressId, "UTF-8");
		}
		
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/copyAddress", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("Error from JGwServer.");
        }
	}
	
	@Override
	public List<AddressFolderVO> getSubTreeInfo(int tenantId, String pParentID, String pOwnerID) throws Exception {
		List<AddressFolderVO> list = new ArrayList<AddressFolderVO>();
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String parentIdParam = "parentId=" + URLEncoder.encode(pParentID, "UTF-8");
		String ownerIdParam = "ownerId=" + URLEncoder.encode(pOwnerID + "@" + domainName, "UTF-8");
		
		String inputParams = parentIdParam + "&" + ownerIdParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/getSubFolder", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
			JSONArray resultArray = (JSONArray)object.get("result");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		AddressFolderVO vo = new AddressFolderVO();
        		
        		vo.setFolderId((String)obj.get("folderId"));
        		vo.setOwnerId(((String)obj.get("ownerId")).split("@")[0]);
        		vo.setFolderName((String)obj.get("folderName"));
        		vo.setFolderType((String)obj.get("folderType"));
        		vo.setChildCount((String)obj.get("childCount"));
        		
				list.add(vo);
        	}
        }
		
		return list;
	}
	
	@Override
	public AddressFolderVO getFolderInfo(String pFolderId) throws Exception {
		AddressFolderVO vo = new AddressFolderVO();
		
		String inputParams = "folderId=" + URLEncoder.encode(pFolderId, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/getFolderInfo", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
			JSONObject resultObject = (JSONObject)object.get("result");
        	
			vo.setFolderId((String)resultObject.get("folderId"));
			vo.setParentId((String)resultObject.get("parentId"));
    		vo.setOwnerId(((String)resultObject.get("ownerId")).split("@")[0]);
    		vo.setFolderName((String)resultObject.get("folderName"));
    		vo.setFolderType((String)resultObject.get("folderType"));
        }
		
		return vo;
	}
	
	@Override
	public void insertFolder(int tenantId, String pParentId, String pOwnerId, String pFolderType, String pFolderName) throws Exception {
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String parentIdParam = "parentId=" + URLEncoder.encode(pParentId, "UTF-8");
		String ownerIdParam = "ownerId=" + URLEncoder.encode(pOwnerId + "@" + domainName, "UTF-8");
		String folderTypeParam = "folderType=" + URLEncoder.encode(pFolderType, "UTF-8");
		String folderNameParam = "folderName=" + URLEncoder.encode(pFolderName, "UTF-8");
		
		String inputParams = parentIdParam + "&" + ownerIdParam + "&" + folderTypeParam + "&" + folderNameParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/addFolder", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("Error from JGwServer.");
        }
	}
	
	@Override
	public void updateFolder(String pFolderId, String pFolderName) throws Exception {
		String folderIdParam = "folderId=" + URLEncoder.encode(pFolderId, "UTF-8");
		String folderNameParam = "folderName=" + URLEncoder.encode(pFolderName, "UTF-8");
		
		String inputParams = folderIdParam + "&" + folderNameParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/modFolder", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("Error from JGwServer.");
        }
	}
	
	@Override
	public void deleteFolder(String pFolderId) throws Exception {
		String inputParams = "folderId=" + URLEncoder.encode(pFolderId, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/delFolder", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("Error from JGwServer.");
        }
	}
	
	@Override
	public void moveFolder(int tenantId, String pFolderId, String pNewParentId, String pNewOwnerId, String pNewFolderType)
			throws Exception {
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String folderIdParam = "folderId=" + URLEncoder.encode(pFolderId, "UTF-8");
		String newParentIdParam = "newParentId=" + URLEncoder.encode(pNewParentId, "UTF-8");
		String newOwnerIdParam = "newOwnerId=" + URLEncoder.encode(pNewOwnerId + "@" + domainName, "UTF-8");
		String newFolderTypeParam = "newFolderType=" + URLEncoder.encode(pNewFolderType, "UTF-8");
		
		String inputParams = folderIdParam + "&" + newParentIdParam + "&" + newOwnerIdParam + "&" + newFolderTypeParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/moveFolder", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("Error from JGwServer.");
        }
	}
	
	@Override
	public void copyFolder(int tenantId, String pFolderId, String pNewParentId, String pNewOwnerId, String pNewFolderType, String pCreatorId) 
			throws Exception {
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String folderIdParam = "folderId=" + URLEncoder.encode(pFolderId, "UTF-8");
		String newParentIdParam = "newParentId=" + URLEncoder.encode(pNewParentId, "UTF-8");
		String newOwnerIdParam = "newOwnerId=" + URLEncoder.encode(pNewOwnerId + "@" + domainName, "UTF-8");
		String newFolderTypeParam = "newFolderType=" + URLEncoder.encode(pNewFolderType, "UTF-8");
		String creatorIdParam = "creatorId=" + URLEncoder.encode(pCreatorId + "@" + domainName, "UTF-8");
		
		String inputParams = folderIdParam + "&" + newParentIdParam + "&" + newOwnerIdParam + "&" + newFolderTypeParam + "&" + creatorIdParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/copyFolder", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("Error from JGwServer.");
        }
	}
	
	@Override
	public List<SimpleAddressVO> getSimpleAddress(int tenantId, String userId) throws Exception {
		List<SimpleAddressVO> list = new ArrayList<SimpleAddressVO>();
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String inputParams = "userId=" + URLEncoder.encode(userId + "@" + domainName, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/getSimpleAddress", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
			JSONArray resultArray = (JSONArray)object.get("result");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		SimpleAddressVO vo = new SimpleAddressVO();
        		
        		vo.setName((String)obj.get("simpleName"));
        		vo.setEmail((String)obj.get("simpleEmail"));
        		
				list.add(vo);
        	}
        }
		
		return list;
	}
	
	@Override
	public void setSimpleAddress(int tenantId, String pUserId, String pMailList) throws Exception {
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String inputParams = "userId=" + URLEncoder.encode(pUserId + "@" + domainName, "UTF-8");
		
		String[] mailList = pMailList.split("\\|");
		
		for (int i=0; i<mailList.length; i++) {
			inputParams += "&simpleName=" + URLEncoder.encode(mailList[i].split(";")[0], "UTF-8");
			inputParams += "&simpleEmail=" + URLEncoder.encode(mailList[i].split(";")[1], "UTF-8");
		}
		
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/setSimpleAddress", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("Error from JGwServer.");
        }
	}
	
	@Override
	public Map<String, Object> getAddressZipCodeList(String pSido, String pKeyword, int pPage) throws Exception {
		int start = (pPage - 1) * 20 + 1;
        int end = pPage * 20;
		
		List<AddressZipCodeVO> list = new ArrayList<AddressZipCodeVO>();
		int totalCount = 0;
		
		String sidoParam = "sido=" + URLEncoder.encode(pSido, "UTF-8");
		String keywordParam = "keyword=" + URLEncoder.encode(pKeyword, "UTF-8");
		String startParam = "start=" + start;
		String endParam = "end=" + end;
		
		String inputParams = sidoParam + "&" + keywordParam + "&" + startParam + "&" + endParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzAddress/getAddressZipCodeList", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
			JSONObject resultObject = (JSONObject)object.get("result");
			totalCount = ((Long)resultObject.get("totalCount")).intValue();
			JSONArray resultArray = (JSONArray)resultObject.get("list");
			
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		AddressZipCodeVO vo = new AddressZipCodeVO();
        		
        		vo.setZipCode((String)obj.get("zipCode"));
        		vo.setDoro((String)obj.get("doro"));
        		vo.setJibun((String)obj.get("jibun"));
        		
				list.add(vo);
        	}
        }
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("totalCount", totalCount);
		resultMap.put("list", list);
		
		return resultMap;
	}

}
