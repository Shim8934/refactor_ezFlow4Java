package egovframework.ezEKP.ezApprovalG.service.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGAdminDAO;
import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGDAO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGAdminService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAdminReceiveVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAprDocInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAprLineVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocStateVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGListHeaderVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGReceiveDocVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGSealInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskCodeHistoryVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskDeptInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzApprovalGAdminService")
public class EzApprovalGAdminServiceImpl extends EgovFileMngUtil implements EzApprovalGAdminService{
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;

	@Autowired
	private Properties globals;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzApprovalGService ezApprovalGService;
	
	@Autowired
	private EzApprovalGDAO ezApprovalGDAO;
	
	@Autowired
	private EzApprovalGAdminDAO ezApprovalGAdminDAO;
	
	@Autowired
	private EgovMessageSource egovMessageSource;
	
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalGAdminServiceImpl.class);

	@Override
	public String getContainerInfoManage(String deptID, String type, String companyID, String primary, int tenantID) throws Exception {
		try {
			logger.debug("getContainerInfoManage started.");
			StringBuilder sb = new StringBuilder();

			logger.debug("companyID=" + companyID + ", deptID=" + deptID);
			
			if (!companyID.toUpperCase().equals("TOP")) {
				Map<String, Object> map1 = new HashMap<String, Object>();		
				map1.put("v_DEPTID", deptID);
				map1.put("companyID", companyID);
				map1.put("tenantID", tenantID);
				
				List<ApprGLeftVO> listBody = ezApprovalGAdminDAO.getContainerInfoManage(map1);
				
				String strMultiData = commonUtil.getMultiData(primary);
				
				if (type.equals("LIST")){
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("v_LISTTYPE", "106");
					map.put("v_LANGTYPE", primary);
					map.put("companyID", companyID);
					map.put("v_TENANTID", tenantID);
					
					List<ApprGListHeaderVO> listHeader = ezApprovalGDAO.getListHeader(map);
					
					sb.append("<LISTVIEWDATA><HEADERS>");
					
					for (int i = 0; i < listHeader.size(); i++) {
						ApprGListHeaderVO vo = listHeader.get(i);
						
						sb.append("<HEADER>");
						sb.append("<NAME>" + commonUtil.cleanValue(vo.getName()) + "</NAME>");
						sb.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
						sb.append("</HEADER>");
					}				
					sb.append("</HEADERS><ROWS>");
					
					for (int i = 0; i < listBody.size(); i++) {
						ApprGLeftVO vo = listBody.get(i);
						
						sb.append("<ROW><CELL>");
											
						if(strMultiData.equals("")){
							sb.append("<VALUE>" + commonUtil.cleanValue(vo.getContainerTypeName()) + "</VALUE>");
							sb.append("<DATA3>" + commonUtil.cleanValue(vo.getContainerTypeName()) + "</DATA3>");
						}else{
							sb.append("<VALUE>" + commonUtil.cleanValue(vo.getContainerTypeName2()) + "</VALUE>");
							sb.append("<DATA3>" + commonUtil.cleanValue(vo.getContainerTypeName2()) + "</DATA3>");
						}
						sb.append("<DATA1>" + vo.getContainerID().trim() + "</DATA1>");
						sb.append("<DATA2>" + vo.getContainerTypeID().trim() + "</DATA2>");
						sb.append("<DATA4>" + vo.getContainerOwnDepID().trim() + "</DATA4>");
						sb.append("</CELL></ROW>");
					}				
					sb.append("</ROWS></LISTVIEWDATA>");
				}else{
					sb.append("<PARAMETER>");
					
					for (int i = 0; i < listBody.size(); i++) {
						ApprGLeftVO vo = listBody.get(i);
						
						sb.append("<CONTID" + i + ">" + vo.getContainerID().trim() + "</CONTID" + i + ">");
											
						if(strMultiData.equals("")){
							sb.append("<NAME" + i + ">" + commonUtil.cleanValue(vo.getContainerTypeName()) + "</NAME" + i + ">");
						}else{
							sb.append("<NAME" + i + ">" + commonUtil.cleanValue(vo.getContainerTypeName2()) + "</NAME" + i + ">");
						}					
					}
					sb.append("</PARAMETER>");
				}
			}else{
				if (type.equals("LIST")){
					sb.append("<LISTVIEWDATA><HEADERS><HEADERS><ROWS></ROWS></LISTVIEWDATA>");
				}else{
					sb.append("<PARAMETER></PARAMETER>");
				}			
			}
			
			logger.debug("getContainerInfoManage ended.");
			
			return sb.toString();
		} catch (Exception e) {
			logger.debug("getContainerInfoManage catch.");
			logger.debug(e.getMessage());
			
			if (type.equals("LIST")){
				logger.debug("getContainerInfoManage catch if.");
				
				return "<LISTVIEWDATA><HEADERS><HEADERS><ROWS></ROWS></LISTVIEWDATA>";
			}else{
				logger.debug("getContainerInfoManage catch else.");
				
				return "<PARAMETER></PARAMETER>";
			}		
		}
		
	}

	@Override
	public String getContTypeInfo(String type, String companyID, String primary ,int tenantID) throws Exception {
		logger.debug("getContTypeInfo started.");
		StringBuilder sb = new StringBuilder();
		String strMultiData = commonUtil.getMultiData(primary);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprGLeftVO> list = ezApprovalGAdminDAO.getContTypeInfo(map);
		
		if (type.equals("LIST")) {
			sb.append("<LISTVIEWDATA><HEADERS><HEADER>");
			sb.append("<NAME>" + ezApprovalGService.getCode2Name("L02", "001", companyID, primary, tenantID) + "</NAME><WIDTH>250</WIDTH></HEADER></HEADERS><ROWS>");
			
			for (int i = 0; i < list.size(); i++) {
				ApprGLeftVO vo = list.get(i);
				
				if(strMultiData.equals("")){
					sb.append("<ROW><CELL><VALUE>" + commonUtil.cleanValue(vo.getContainerTypeName()) + "</VALUE>");
				}else{
					sb.append("<ROW><CELL><VALUE>" + commonUtil.cleanValue(vo.getContainerTypeName2()) + "</VALUE>");
				}
				sb.append("<DATA1>" + vo.getContainerTypeID().trim() + "</DATA1></CELL></ROW>");				
			}
			sb.append("</ROWS></LISTVIEWDATA>");
		} else {
			sb.append("<PARAMETER>");
			
			for (int i = 0; i < list.size(); i++) {
				ApprGLeftVO vo = list.get(i);
				
				sb.append("<ID" + i + ">" + vo.getContainerTypeID().trim() + "</ID" + i + ">");
				
				if (strMultiData.equals("")) {
					sb.append("<NAME" + i + ">" + commonUtil.cleanValue(vo.getContainerTypeName()) + "</NAME" + i + ">");
				} else {
					sb.append("<NAME" + i + ">" + commonUtil.cleanValue(vo.getContainerTypeName2()) + "</NAME" + i + ">");
				}
			}
			sb.append("</PARAMETER>");
		}
		
		logger.debug("getContTypeInfo ended.");
		
		return sb.toString();
	}

	@Override
	public String deleteContainerType(String docTypeID, String companyID, int tenantID) throws Exception {
		logger.debug("deleteContainerType started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CONTTYPEID", docTypeID);		
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		logger.debug("deleteContainerTypeSelect started.");
		int count = ezApprovalGAdminDAO.deleteContainerTypeSelect(map);
		logger.debug("deleteContainerTypeSelect ended.");
		
		String result = "";
		if (count == 0) {
			map.put("v_cnt", count);
			
			logger.debug("deleteContainerTypeDelete1,2 started.");
			ezApprovalGAdminDAO.deleteContainerTypeDelete1(map);
			ezApprovalGAdminDAO.deleteContainerTypeDelete2(map);
			logger.debug("deleteContainerTypeDelete1,2 ended.");
			
			result = "TRUE";
		} else {
			result ="USE";
		}
		
		logger.debug("deleteContainerType ended.");
		
		return result; 
	}

	@Override
	public void insertContainerType(String docTypeName, String docTypeName2, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CONTTYPENAME", docTypeName);
		map.put("v_CONTTYPENAME2", docTypeName2);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		logger.debug("insertContainerType started.");
		ezApprovalGAdminDAO.insertContainerType(map);
		logger.debug("insertContainerType ended.");
	}

	@Override
	public String getContainerToDocStateInfo(String companyID, String primary, int tenantID) throws Exception {
		logger.debug("getContainerToDocStateInfo started.");
		String strMultiData = commonUtil.getMultiData(primary);
		
		StringBuilder sb = new StringBuilder();		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", "111");
		map.put("v_LANGTYPE", primary);
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getListHeader started." );
		List<ApprGListHeaderVO> listHeader = ezApprovalGDAO.getListHeader(map);
		logger.debug("getListHeader ended." );
		
		sb.append("<LISTVIEWDATA><HEADERS>");
		
		for (int i = 0; i < listHeader.size(); i++) {
			ApprGListHeaderVO vo = listHeader.get(i);
			
			sb.append("<HEADER>");
			sb.append("<NAME>" + commonUtil.cleanValue(vo.getName()) + "</NAME>");
			sb.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
			sb.append("</HEADER>");
		}
		sb.append("</HEADERS><ROWS>");
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_LISTTYPE", "111");
		map1.put("v_LANGTYPE", primary);
		map1.put("companyID", companyID);
		map1.put("tenantID", tenantID);
		
		List<ApprGDocStateVO> listBody = ezApprovalGAdminDAO.getContainerToDocStateInfo(map1);
		
		for (int i = 0; i < listBody.size(); i++) {
			ApprGDocStateVO vo = listBody.get(i);
			
			Field field = vo.getClass().getDeclaredField("documentStateName" + commonUtil.getLangData(primary));
	    	field.setAccessible(true);

			sb.append("<ROW>");			
			sb.append("<CELL><VALUE>" + commonUtil.cleanValue(String.valueOf(field.get(vo))) + "</VALUE>");
			sb.append("<DATA1>" + vo.getDocumentState() + "</DATA1></CELL>");			
						
			if (strMultiData.equals("")) {
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getContainerTypeName()) + "</VALUE>");
			} else {
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getContainerTypeName2()) + "</VALUE>");
			}
			
			if (vo.getContainerTypeID() != null) {
				sb.append("<DATA1>" + vo.getContainerTypeID() + "</DATA1></CELL>");
			} else {
				sb.append("<DATA1>" + " " + "</DATA1></CELL>");
			}
			
			sb.append("</ROW>");
		}
		sb.append("</ROWS></LISTVIEWDATA>");
		
		logger.debug("getContainerToDocStateInfo ended.");
		
		return sb.toString();
	}

	@Override
	public String updateContainerToDocStateInfo(Document xmlData, String companyID, int tenantID) throws Exception {
		logger.debug("updateContainerToDocStateInfo started.");
		NodeList docData = xmlData.getElementsByTagName("CONTTYPE");
		String result = "FALSE";
		
		try {
			if (docData != null && docData.getLength() > 0) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("companyID", companyID);
				map.put("tenantID", tenantID);
				
				logger.debug("deleteContainerDocState started.");
				ezApprovalGAdminDAO.deleteContainerDocState(map);
				logger.debug("deleteContainerDocState ended.");
				
				for (int i = 0; i < docData.getLength(); i++) {
					String data1 = docData.item(i).getChildNodes().item(1).getTextContent();
					String data2 = docData.item(i).getChildNodes().item(0).getTextContent();
					
					map.put("data1", data1.trim());
					map.put("data2", data2.trim());
					
					logger.debug("insertContainerDocState started.");
					ezApprovalGAdminDAO.insertContainerDocState(map);
					logger.debug("insertContainerDocState ended.");
				}
				
				result = "TRUE";
			}
		} catch(Exception e) {
			logger.debug("updateContainerToDocStateInfo catch.");
			logger.debug(e.getMessage());
			
			result = "FALSE";
		}
		
		logger.debug("updateContainerToDocStateInfo ended.");
		
		return result;
	}

	@Override
	public String getContainerUseDeptInfo(String contID, String companyID, String primary, int tenantID) throws Exception {
		StringBuilder sb = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CONTID", contID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		String strMultiData = commonUtil.getMultiData(primary);
		
		try {
			logger.debug("getContainerUseDeptInfo started.");
			List<ApprGLeftVO> list = ezApprovalGAdminDAO.getContainerUseDeptInfo(map);
			
			sb.append("<PARAMETER>");
			
			if(list.size() > 0){
				for (int i = 0; i < list.size(); i++) {
					ApprGLeftVO vo = list.get(i);
					
					sb.append("<ID" + i + ">" + vo.getUseDepID().trim() + "</ID" + i + ">");
					
					if (strMultiData.equals("")) {
						sb.append("<NAME" + i + ">" + commonUtil.cleanValue(vo.getContainerTypeName()) + "</NAME" + i + ">");
					} else {
						sb.append("<NAME" + i + ">" + commonUtil.cleanValue(vo.getContainerTypeName2()) + "</NAME" + i + ">");
					}
				}
			}else{
				sb.append("<ID0>FALSE</ID0><NAME0></NAME0>");
			}
			sb.append("</PARAMETER>");
			
			logger.debug("getContainerUseDeptInfo ended.");
		} catch(Exception e) {
			logger.debug("getContainerUseDeptInfo catch.");
			logger.debug(e.getMessage());
			sb.append("<PARAMETER><ID0>FALSE</ID0><NAME0></NAME0></PARAMETER>");
		}
		
		return sb.toString();
	}

	@Override
	public String insertContainer(Document xmlData, String companyID, int tenantID) throws Exception {
		logger.debug("insertContainer started.");
		String result = "FALSE";
		
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("tenantID", tenantID);
			
			logger.debug("insertContainerContID started.");
			String pMaxContainerID = ezApprovalGAdminDAO.insertContainerContID(map);
			logger.debug("insertContainerContID ended.");
			
			int tempMaxContainerID = Integer.parseInt(pMaxContainerID.trim()) + 1;
	        pMaxContainerID = tempMaxContainerID + "";
	        int pMaxContainerIDLength = pMaxContainerID.length();
	        int i;
	
	        for (i = 0; i < (10 - pMaxContainerIDLength); i++) {
	            pMaxContainerID = "0" + pMaxContainerID;
	        }
	
			String pContType = xmlData.getDocumentElement().getChildNodes().item(0).getTextContent().trim();
			String pOwnDeptID = xmlData.getDocumentElement().getChildNodes().item(1).getTextContent().trim();
			
			map.put("contID", pMaxContainerID);
			map.put("contType", pContType);
			map.put("deptID", pOwnDeptID);
			
			logger.debug("insertContainer started.");
			ezApprovalGAdminDAO.insertContainer(map);
			logger.debug("insertContainer ended.");
			
			pMaxContainerIDLength = xmlData.getDocumentElement().getChildNodes().getLength();
	
			if (pMaxContainerIDLength > 2) {
			    for (i = 2; i < pMaxContainerIDLength - 1; i++) {		
					map.put("deptID", xmlData.getDocumentElement().getChildNodes().item(i).getTextContent().trim());
					
					logger.debug("insertContainer ended.");
			    	ezApprovalGAdminDAO.insertContainerUseDep(map);
			    	logger.debug("insertContainer ended.");
			    }
			}
			
			logger.debug("insertContainer ended");
			
			result = "TRUE";
		} catch (Exception e) {
			logger.debug("insertContainer catch");
			result = "FALSE";
		}
		
		return result;
	}

	@Override
	public String updateContainer(Document xmlData, String companyID, int tenantID) throws Exception {
		String pContID = xmlData.getDocumentElement().getChildNodes().item(0).getTextContent().trim();
		String pContType = xmlData.getDocumentElement().getChildNodes().item(1).getTextContent().trim();
		String pOwnDeptID = xmlData.getDocumentElement().getChildNodes().item(2).getTextContent().trim();
		String result = "FALSE";
		
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("contID", pContID);		
			map.put("contType", pContType);		
			map.put("deptID", pOwnDeptID);		
			map.put("companyID", companyID);
			map.put("tenantID", tenantID);
			
			logger.debug("updateContainer started.");
			ezApprovalGAdminDAO.updateContainer(map);
			logger.debug("updateContainer ended.");
			
			logger.debug("deleteContainerUseDep started.");
			ezApprovalGAdminDAO.deleteContainerUseDep(map);
			logger.debug("deleteContainerUseDep ended.");
			
			int cnt = xmlData.getDocumentElement().getChildNodes().getLength();		
		
		    for (int i = 3; i < cnt - 1; i++) {
		    	map.put("deptID", xmlData.getDocumentElement().getChildNodes().item(i).getTextContent().trim());
				
				logger.debug("insertContainerUseDep started.");
		    	ezApprovalGAdminDAO.insertContainerUseDep(map);
		    	logger.debug("insertContainerUseDep ended.");
		    }
		    result = "TRUE";
		} catch (Exception e) {
			result = "FALSE";
		}
		
		return result;
	}

	@Override
	public String deleteContainer(String contID, String companyID, int tenantID) throws Exception {
		logger.debug("deleteContainer started.");
		String result = "FALSE";
		
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_CONTID", contID);
			map.put("companyID", companyID);
			map.put("tenantID", tenantID);
	
			logger.debug("deleteContainer1,2 started.");
			ezApprovalGAdminDAO.deleteContainer1(map);
			ezApprovalGAdminDAO.deleteContainer2(map);
			logger.debug("deleteContainer1,2 ended.");
			
			result = "TRUE";
		} catch (Exception e) {
			logger.debug("deleteContainer1,2 catch.");
			logger.debug(e.getMessage());
			result = "FALSE";
		}
		
		logger.debug("deleteContainer ended. result=" + result);
		
		return result;
	}

	@Override
	public String getReceiveGroupInfo(String pid, String mode, String companyID, String lang, int tenantID) throws Exception {
		StringBuilder sb = new StringBuilder();
		sb.append("<LISTVIEWDATA><HEADERS>");
		
		if (companyID.toUpperCase().equals("TOP")) {
			sb.append("</HEADERS><ROWS></ROWS></LISTVIEWDATA>");
		} else {
			String code = "091";
			
			if (mode.equals("ITEM")) {
				code = "092";
			}
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_LISTTYPE", code);
			map.put("v_LANGTYPE", lang);
			map.put("companyID", companyID);
			map.put("v_TENANTID", tenantID);
			
			logger.debug("getListHeader started.");
			List<ApprGListHeaderVO> listHeader = ezApprovalGDAO.getListHeader(map);
			logger.debug("getListHeader ended.");
			
			for (int i = 0; i < listHeader.size(); i++) {
				ApprGListHeaderVO vo = listHeader.get(i);
				
				sb.append("<HEADER>");
				sb.append("<NAME>" + commonUtil.cleanValue(vo.getName()) + "</NAME>");
				sb.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
				sb.append("<COLNAME>" + commonUtil.cleanValue(vo.getColName()) + "</COLNAME>");
				sb.append("</HEADER>");
			}
			
			if (pid.equals("")){
				pid = "0";
			}
			sb.append("</HEADERS><ROWS>");
			
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("v_MAINID", pid);
			map1.put("v_MODE", mode);
			map1.put("companyID", companyID);
			map1.put("tenantID", tenantID);
			
			logger.debug("getReceiveGroupInfo started.");
			List<ApprGAdminReceiveVO> listBody = ezApprovalGAdminDAO.getReceiveGroupInfo(map1);
			logger.debug("getReceiveGroupInfo ended.");
			
			for (int i = 0; i < listBody.size(); i++) {
				ApprGAdminReceiveVO bodyVo = listBody.get(i);
				
				for (int j = 0; j < listHeader.size(); j++) {	
					ApprGListHeaderVO headerVo = listHeader.get(j);				
					String fieldName = headerVo.getColName();
					String fieldValue = "";
									
					if (!lang.equals("1") && fieldName.toUpperCase().equals("DEPTNAME")){
						fieldName = fieldName + "2";
					}
					
					for (Field field : bodyVo.getClass().getDeclaredFields()) {
				        field.setAccessible(true);
											
						if (field.getName().toUpperCase().equals(fieldName.toUpperCase())) {
							fieldValue = String.valueOf(field.get(bodyVo));
						}					   
				    }
					
					sb.append("<ROW>");
					sb.append("<CELL><VALUE>" + ezApprovalGService.getListField(fieldName, fieldValue, companyID, lang, tenantID) + "</VALUE>");
					
					if (j == 0) {
						if (mode.equals("GROUP") || mode.equals("JOIN")) {
							sb.append("<DATA1>" + bodyVo.getMainID() + "</DATA1>");
						} else {
							sb.append("<DATA1>" + bodyVo.getSubID() + "</DATA1>");
							sb.append("<DATA2>" + bodyVo.getMainID() + "</DATA2>");
							sb.append("<DATA3>" + bodyVo.getDeptID() + "</DATA3>");
							sb.append("<DATA4>" + bodyVo.getCompanyID() + "</DATA4>");
							sb.append("<DATA5>" + commonUtil.cleanValue(bodyVo.getDeptName()) + "</DATA5>");
							sb.append("<DATA6>" + commonUtil.cleanValue(bodyVo.getDeptName2()) + "</DATA6>");
						}
					}					
					sb.append("</CELL></ROW>");
				}
			}
			sb.append("</ROWS></LISTVIEWDATA>");
		}
		return sb.toString();
	}

	@Override
	public String insertReceiveGroupItemInfo(String groupID, String deptID,	String deptName, String deptName2, String pCompanyID, String companyID, int tenantID) throws Exception {
		String result = "FALSE";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MAINID", groupID);
		map.put("v_DEPTID", deptID);
		map.put("v_DEPTNAME", deptName);
		map.put("v_DEPTNAME2", deptName2);
		map.put("v_COMPANYID", pCompanyID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			logger.debug("insertReceiveGroupItemInfo started.");
			ezApprovalGAdminDAO.insertReceiveGroupItemInfo(map);
			
			result = "TRUE";
		} catch (Exception e) {
			logger.debug("insertReceiveGroupItemInfo catch.");
			result = "FALSE";			
		}
		
		logger.debug("insertReceiveGroupItemInfo ended. result=" + result);
		
		return result;
	}

	@Override
	public String deleteReceiveGroupItemInfo(String groupID, String companyID, int tenantID) throws Exception {
		String result = "FALSE";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SUBID", groupID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			logger.debug("deleteReceiveGroupItemInfo started.");
			ezApprovalGAdminDAO.deleteReceiveGroupItemInfo(map);
			
			result = "TRUE";
		} catch (Exception e) {
			logger.debug("deleteReceiveGroupItemInfo catch.");
			
			result = "FALSE";			
		}
		
		logger.debug("deleteReceiveGroupItemInfo ended. result=" + result);
		
		return result;
		
	}

	@Override
	public String updateReceiveGroupInfo(String groupID, String groupName, String companyID, int tenantID) throws Exception {
		String result = "FALSE";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MAINID", groupID);
		map.put("v_MAINNAME", groupName);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			logger.debug("updateReceiveGroupInfo started.");
			ezApprovalGAdminDAO.updateReceiveGroupInfo(map);
			
			result = "TRUE";
		} catch (Exception e) {
			logger.debug("updateReceiveGroupInfo catch.");
			
			result = "FALSE";			
		}
		
		logger.debug("updateReceiveGroupInfo ended. result=" + result);
		
		return result;
	}

	@Override
	public String insertReceiveGroupInfo(String groupName, String companyID, int tenantID) throws Exception{
		String result = "FALSE";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MAINNAME", groupName);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			logger.debug("insertReceiveGroupInfo started.");
			ezApprovalGAdminDAO.insertReceiveGroupInfo(map);
			
			result = "TRUE";
		} catch (Exception e) {
			logger.debug("insertReceiveGroupInfo catch.");
			result = "FALSE";			
		}
		
		logger.debug("insertReceiveGroupInfo ended.");
		
		return result;
	}

	@Override
	public String deleteReceiveGroupInfo(String groupID, String companyID, int tenantID) throws Exception {
		String result = "FALSE";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MAINID", groupID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			logger.debug("deleteReceiveGroupInfo started.");
			ezApprovalGAdminDAO.deleteReceiveGroupInfo(map);
			
			result = "TRUE";
		} catch (Exception e) {
			logger.debug("deleteReceiveGroupInfo catch.");
			result = "FALSE";			
		}
		
		logger.debug("deleteReceiveGroupInfo ended. result=" + result);
		
		return result;
	}

	@Override
	public String getTaskCategoryTree(String categoryType, String parentID, String companyID, int tenantID) throws Exception {
		logger.debug("getTaskCategoryTree started.");
		StringBuilder sb = new StringBuilder();
		String isLeaf = "FALSE";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CATETYPE", categoryType);
		map.put("v_PARENTID", parentID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			logger.debug("categoryType=" + categoryType);
			List<ApprGTaskVO> list = ezApprovalGAdminDAO.getTaskCategotyTree(map);
			
			sb.append("<NODES>");
			
			for (ApprGTaskVO vo : list) {
				switch (vo.getCategoryType()) {
					case "1":
						isLeaf = getTaskCategoryNodeExist(vo.getCategoryType(), vo.getCategoryCode(), companyID, tenantID);
						break;
					case "2":
						isLeaf = getTaskCategoryNodeExist(vo.getCategoryType(), vo.getMcategoryCode(), companyID, tenantID);
						break;
					case "3":
						isLeaf = getTaskCategoryNodeExist(vo.getCategoryType(), vo.getSubCategoryCode(), companyID, tenantID);
						break;
				}
				isLeaf = isLeaf.equals("TRUE") ? "FALSE" : "TRUE";

				sb.append("<NODE><EXPANDED>FALSE</EXPANDED>");
				sb.append("<ISLEAF>" + isLeaf + "</ISLEAF>");
				sb.append("<VALUE>" + commonUtil.cleanValue(vo.getName()) + "</VALUE>");
				sb.append("<VALUE2>" + commonUtil.cleanValue(vo.getName2()) + "</VALUE2>");
				sb.append("<DATA1>" + vo.getCategoryType() + "</DATA1>");
				
				switch (categoryType) {
					case "1":
						sb.append("<DATA2>" + vo.getCategoryCode() + "</DATA2>");
						sb.append("<DATA3>" + vo.getDescription() + "</DATA3>");
						sb.append("<DATA4>" + "ROOT" + "</DATA4>");
						break;
					case "2":
						sb.append("<DATA2>" + vo.getMcategoryCode() + "</DATA2>");
						sb.append("<DATA3>" + vo.getDescription() + "</DATA3>");
						sb.append("<DATA4>" + vo.getCategoryCode() + "</DATA4>");
						break;
					case "3":
						sb.append("<DATA2>" + vo.getSubCategoryCode() + "</DATA2>");
						sb.append("<DATA3>" + vo.getDescription() + "</DATA3>");
						sb.append("<DATA4>" + vo.getMcategoryCode() + "</DATA4>");
						break;
				}
				sb.append("</NODE>");
			}
			sb.append("</NODES>");
			logger.debug("getTaskCategoryTree ended.");
			
			return sb.toString();
		} catch (Exception e) {
			logger.debug("getTaskCategoryTree catch.");
			logger.debug(e.getMessage());
			
			return "<NODES></NODES>";
		}
	}

	@Override
	public String getTaskInSubCategoryForManage(Document doc, int tenantID) throws Exception {
		logger.debug("getTaskInSubCategoryForManage started.");
		StringBuffer sb = new StringBuffer();
		String companyID = doc.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String pSCateCode = doc.getElementsByTagName("SCATECODE").item(0).getTextContent();
		String langType = doc.getElementsByTagName("LANGTYPE").item(0).getTextContent();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SUBCATECODE", pSCateCode);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprGTaskVO> list = ezApprovalGAdminDAO.getTaskInSubCategoryForManage(map);
		
        sb.append("<DATA>");
        
        for (ApprGTaskVO vo : list) {
        	sb.append(commonUtil.getQueryResult(vo));
        }
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		String result = ezApprovalGService.makeTaskListXml(docXML, companyID, langType, tenantID);
		
		logger.debug("getTaskInSubCategoryForManage ended.");
		
		return result;
	}

	@Override
	public String getTaskCategoryDuplicate(String categoryType, String categoryCode, String companyID, int tenantID) throws Exception {
		String result = "FALSE";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CATETYPE", categoryType);
		map.put("v_CATECODE", categoryCode);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		logger.debug("getTaskCategoryDuplicate started.");
		int count = ezApprovalGAdminDAO.getTaskCategoryDuplicate(map);
		
		if (count  > 0) {
			result = "TRUE";
		} else {
			result = "FALSE";
		}
		
		logger.debug("getTaskCategoryDuplicate ended. result=" + result);
		
		return result;
	}

	@Override
	public String setTaskCategory(String categoryType, String categoryCode, String categoryName, String categoryName2, String categoryDesc, String pCode, String companyID, int tenantID) throws Exception {
		String result = "FALSE";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CATETYPE", categoryType);
		map.put("v_CATECODE", categoryCode);
		map.put("v_NAME", categoryName);
		map.put("v_NAME2", categoryName2);
		map.put("v_DESC", categoryDesc);
		map.put("v_CODE", pCode);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			String duplicate = getTaskCategoryDuplicate(categoryType, categoryCode, companyID, tenantID);
			
			if (duplicate.equals("TRUE")) {
				logger.debug("setTaskCategory started. mode=U");
				ezApprovalGAdminDAO.setTaskCategoryUpdate(map);
			} else {
				logger.debug("setTaskCategory started. mode=I");
				ezApprovalGAdminDAO.setTaskCategoryInsert(map);
			}
			
			result = "TRUE";
		} catch (Exception e) {
			logger.debug("setTaskCategory catch.");
			logger.debug(e.getMessage());
			
			result = "FALSE";			
		}
		
		logger.debug("setTaskCategory ended. result=" + result);
		
		return result;
	}

	@Override
	public String getTaskCategoryNodeExist(String categoryType, String categoryCode, String companyID, int tenantID) throws Exception {
		String result = "FALSE";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CATETYPE", categoryType);
		map.put("v_CATECODE", categoryCode);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			logger.debug("getTaskCategoryNodeExist started.");
			logger.debug("categoryType=" + categoryType);
			logger.debug("categoryCode=" + categoryCode);
			int count = ezApprovalGAdminDAO.getTaskCategoryNodeExist(map);
			
			if (count > 0) {
				result = "TRUE";
			}
		} catch (Exception e) {
			logger.debug("getTaskCategoryNodeExist catch.");
			logger.debug(e.getMessage());
			
			result = "FALSE";
		}
		
		logger.debug("getTaskCategoryNodeExist ended. result=" + result);
		
		return result;
	}

	@Override
	public String removeTaskCategory(String categoryType, String categoryCode, String companyID, int tenantID) throws Exception {
		try{
			logger.debug("removeTaskCategory started.");
			
			String duplicate = getTaskCategoryNodeExist(categoryType, categoryCode, companyID, tenantID);
			
			if (duplicate.equals("TRUE")) {
				logger.debug("duplicate TRUE");
				
				return "EXIST";
			} else {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("v_CATETYPE", categoryType);
				map.put("v_CATECODE", categoryCode);
				map.put("companyID", companyID);
				map.put("tenantID", tenantID);
				
				ezApprovalGAdminDAO.removeTaskCategory(map);
				
				logger.debug("removeTaskCategory ended.");
				
				return "TRUE";
			}
		} catch (Exception e){
			logger.debug("removeTaskCategory catch.");
			logger.debug(e.getMessage());
			
			return "FALSE";
		}
		
	}

	@Override
	public String getTaskCodeDuplicate(String taskCode, String companyID, int tenantID) throws Exception {
		String result = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TASKCODE", taskCode);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			logger.debug("getTaskCodeDuplicate started.");
			int count = ezApprovalGAdminDAO.getTaskCodeDuplicate(map);
			
			if (count > 0) {
				result = "TRUE";
			} else {
				result = "FALSE";
			}
		} catch (Exception e) {
			logger.debug("getTaskCodeDuplicate catch.");
			logger.debug(e.getMessage());
			
			result = "FALSE";
		}
		
		logger.debug("getTaskCodeDuplicate ended. result=" + result);
		
		return result;
	}

	@Override
	public String getTaskInfo(String pTaskCode, String pDeptCode, String companyID, int tenantID) throws Exception {
		logger.debug("getTaskInfo started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DEPTCODE", pDeptCode);
		map.put("v_TASKCODE", pTaskCode);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			logger.debug("deptcode=" + pDeptCode);
			List<ApprGTaskVO> list = ezApprovalGAdminDAO.getTaskInfo(map);
	
			if (list.get(0) == null) {
				logger.debug("getTaskInfo ended. null");
				
				return "<RESULT>NOITEM</RESULT>";
			}
			
			String result = commonUtil.getQueryResult(list.get(0));
			
			logger.debug("getTaskInfo ended. result=" + result);
			
			return result;
		} catch (Exception e) {
			logger.debug("getTaskInfo ended. ERROR");
			logger.debug(e.getMessage());
			
			return "<RESULT>FLASE</RESULT>";
		}
	}

	//TODO 다국어가 영어로 고정되어 있음.
	@Override
	public String setTaskCode(ApprGTaskVO vo, String companyID, LoginVO userInfo) throws Exception {
		logger.debug("setTaskCode started.");
		
		int tenantID = userInfo.getTenantId();
		
		try {
			if (getTaskCodeDuplicate(vo.getTaskCode(), companyID, userInfo.getTenantId()).equals("TRUE")) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("v_TASKCODE", vo.getTaskCode());
				map.put("companyID", companyID);
				map.put("tenantID", tenantID);
				
				logger.debug("getTaskCode started.");
				ApprGTaskVO item = ezApprovalGAdminDAO.getTaskCode(map);
				logger.debug("getTaskCode ended.");
				
				Document docXML = commonUtil.convertStringToDocument(commonUtil.getQueryResult(item));
				Document objParam = commonUtil.convertStringToDocument(commonUtil.getQueryResult(vo));
				
				String[] NAMETYPE = {"TASKNAME","TASKNAME2", "KEEPINGPERIOD", "KPREASON", 
									"KEEPINGMETHOD", "KEEPINGPLACE", "DISPLAYRECFLAG", "DISPLAYRECTRASTIME",
									"EXDISPLAYFREQUENCY", "SPECIALCATALOGFLAG", "SC1", "SC2", 
									"SC3", "DISPLAYUSAGE", "DESCRIPTION", "SUBCATEGORYCODE"};
				String[] NAMEDESC = {"단위업무명(한글)","단위업무명(영문)", "보존연한", "보존연한책정사유", 
									"보존방법", "보존장소", "비치기록물", "비치기록물이관시기", 
									"이관후예상열람빈도", "특수목록위치", "제1특수목록", "제2특수목록", 
									"제3특수목록", "주요열람용도", "단위업무설명", "소기능"};
                // 2010.08.23 다국어
                String[] NAMEDESC2 = {"Taskname(Han)","Taskname(Eng)", "KeepingPeriod", "KPREASON", 
									"KeepingMethod", "KeepingPlace", "DisplayREC", "DisplayRECTrastime", 
									"EXDisplayFrequency", "SCPlace", "SC1", "SC2", 
									"SC3", "DisplayUsage", "Description", "SubCategory"};
                
                for (int i=0; i<NAMETYPE.length; i++) {
					if (!docXML.getElementsByTagName(NAMETYPE[i]).item(0).getTextContent().trim().equals(objParam.getElementsByTagName(NAMETYPE[i]).item(0).getTextContent().trim())) {
                        String subSQL = setTaskHistory(vo.getTaskCode(), vo.getTaskName(), vo.getTaskName2(), NAMEDESC[i], NAMEDESC2[i], docXML.getElementsByTagName(NAMETYPE[i]).item(0).getTextContent().trim(), objParam.getElementsByTagName(NAMETYPE[i]).item(0).getTextContent().trim(), objParam.getElementsByTagName(NAMETYPE[i]).item(0).getTextContent().trim(), companyID, tenantID);
                        
                        if (subSQL == "FALSE") {
							return "FALSE";
                        }
					}
				}
                
                Map<String, Object> map1 = new HashMap<String, Object>();
                map1.put("v_TASKCODE", vo.getTaskCode());
                map1.put("v_TASKNAME", vo.getTaskName());
                map1.put("v_TASKNAME2", vo.getTaskName2());
                map1.put("v_KEEPINGPERIOD", vo.getKeepingPeriod());
                map1.put("v_KPREASON", vo.getKpReason());
                map1.put("v_KEEPINGMETHOD", vo.getKeepingMethod());
                map1.put("v_KEEPINGPLACE", vo.getKeepingPlace());
                map1.put("v_DISPLAYRECFLAG", vo.getDisplayRecFlag());
                map1.put("v_DISPLAYRECTRASTIME", vo.getDisplayRecTrasTime());
                map1.put("v_EXDISPLAYFREQUENCY", vo.getExDisplayFrequency());
                map1.put("v_SPECIALCATALOGFLAG", vo.getSpecialCatalogFlag());
                map1.put("v_SC1", vo.getSc1());
                map1.put("v_SC2", vo.getSc2());
                map1.put("v_SC3", vo.getSc3());
                map1.put("v_DISPLAYUSAGE", vo.getDisplayUsage());
                map1.put("v_DESCRIPTION", vo.getDescription());
                map1.put("v_SUBCATEGORYCODE", vo.getSubCategoryCode());
                map1.put("companyID", companyID);
                map1.put("tenantID", tenantID);
                
                ezApprovalGAdminDAO.updateTaskCode(map1);
			} else {
				String subSQL = setTaskHistory(vo.getTaskCode(), vo.getTaskName(), vo.getTaskName2(), egovMessageSource.getMessage("ezApprovalG.lhj07", userInfo.getLocale()), "New creation", "", "", "", companyID, userInfo.getTenantId());
				
                if (subSQL == "FALSE") {
					return "FALSE";
                }
                
                Map<String, Object> map2 = new HashMap<String, Object>();
                map2.put("v_TASKCODE", vo.getTaskCode());
                map2.put("v_TASKNAME", vo.getTaskName());
                map2.put("v_TASKNAME2", vo.getTaskName2());
                map2.put("v_KEEPINGPERIOD", vo.getKeepingPeriod());
                map2.put("v_KPREASON", vo.getKpReason());
                map2.put("v_KEEPINGMETHOD", vo.getKeepingMethod());
                map2.put("v_KEEPINGPLACE", vo.getKeepingPlace());
                map2.put("v_DISPLAYRECFLAG", vo.getDisplayRecFlag());
                map2.put("v_DISPLAYRECTRASTIME", vo.getDisplayRecTrasTime());
                map2.put("v_EXDISPLAYFREQUENCY", vo.getExDisplayFrequency());
                map2.put("v_SPECIALCATALOGFLAG", vo.getSpecialCatalogFlag());
                map2.put("v_SC1", vo.getSc1());
                map2.put("v_SC2", vo.getSc2());
                map2.put("v_SC3", vo.getSc3());
                map2.put("v_DISPLAYUSAGE", vo.getDisplayUsage());
                map2.put("v_DESCRIPTION", vo.getDescription());
                map2.put("v_SUBCATEGORYCODE", vo.getSubCategoryCode());
                map2.put("v_CREATIONDATE", commonUtil.getTodayUTCTime(""));
                map2.put("companyID", companyID);
                map2.put("tenantID", tenantID);
               
                ezApprovalGAdminDAO.insertTaskCode(map2);
			}
			
			logger.debug("setTaskCode ended.");
			
			return "TRUE";
		} catch (Exception e) {
			logger.debug("setTaskCode ERROR.");
			logger.debug(e.getMessage());
			
			return "FALSE";
		}
	}
	
	@Override
	public String getTaskCodeNodeExist(String taskCode, String deptID, String companyID,int tenantID) throws Exception {
		String result = "FALSE";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TASKCODE", taskCode);
		map.put("v_DEPTID", deptID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			logger.debug("getTaskCodeNodeExist started.");
			int count = ezApprovalGAdminDAO.getTaskCodeNodeExist(map);
			
			if (count > 0) {
				result = "TRUE";
			} else {
				result = "FALSE";
			}
		} catch (Exception e) {
			logger.debug("getTaskCodeNodeExist catch.");
			logger.debug(e.getMessage());
			
			result = "FALSE";
		}
		
		logger.debug("getTaskCodeNodeExist ended.");
		
		return result;
	}

	@Override
	public String removeTaskCode(String taskCode, String companyID, LoginVO userInfo) throws Exception {
		logger.debug("removeTaskCode started.");
		String tempFlag = getTaskCodeNodeExist(taskCode, "", companyID, userInfo.getTenantId());
		int tenantID = userInfo.getTenantId();
		
		try {
			if (tempFlag.equals("TRUE")) {
				return "EXIST";
			} else {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("v_TASKCODE", taskCode);
				map.put("companyID", companyID);
				map.put("tenantID", tenantID);
				
				logger.debug("getTaskName started.");
				ApprGTaskVO vo = ezApprovalGAdminDAO.getTaskName(map);
				logger.debug("getTaskName ended.");
				
				String temp = setTaskHistory(taskCode, vo.getTaskName(), vo.getTaskName2(), egovMessageSource.getMessage("ezApprovalG.lhj08", userInfo.getLocale()), "Deleted", "", "", "", companyID, tenantID);
				
				if (temp.equals("FALSE")) {
					return "FALSE";
				}
				
				Map<String, Object> map1 = new HashMap<String, Object>();
				map1.put("taskCode", taskCode);
				map1.put("now", commonUtil.getTodayUTCTime(""));
				map1.put("companyID", companyID);
				map1.put("tenantID", tenantID);
				
				logger.debug("removeTaskCode1,2 started.");
				ezApprovalGAdminDAO.removeTaskCode1(map1);
				ezApprovalGAdminDAO.removeTaskCode2(map1);
				
				logger.debug("removeTaskCode1,2 ended.");
				logger.debug("removeTaskCode ended.");
				return "TRUE";
			}
		} catch (Exception e) {
			logger.debug("removeTaskCode catch.");
			logger.debug(e.getMessage());
			
			return "FALSE";
		}
	}

	@Override
	public String getTaskCodeDeptInfo(String taskCode, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("getTaskCodeDeptInfo started.");
		StringBuilder sb = new StringBuilder();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", "102");
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getListHeader started.");
		List<ApprGListHeaderVO> listHeader = ezApprovalGDAO.getListHeader(map);
		logger.debug("getListHeader ended.");
		
		sb.append("<LISTVIEWDATA><HEADERS>");
		
		for (int i = 0; i < listHeader.size(); i++) {
			ApprGListHeaderVO vo = listHeader.get(i);
			
			sb.append("<HEADER>");
			sb.append("<NAME>" + commonUtil.cleanValue(vo.getName()) + "</NAME>");
			sb.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
			sb.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
			sb.append("</HEADER>");
		}
		sb.append("</HEADERS><ROWS>");
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_TASKCODE", taskCode);
		map1.put("companyID", companyID);
		map1.put("tenantID", tenantID);
		
		List<ApprGTaskDeptInfoVO> listBody = ezApprovalGAdminDAO.getTaskCodeDeptInfo(map1);
		
		for (ApprGTaskDeptInfoVO vo : listBody) {
			sb.append("<ROW><CELL>");
			sb.append("<VALUE>" + vo.getProcessDeptCode() + "</VALUE>");
			sb.append("<DATA1>" + vo.getProcessDeptName() + "</DATA1>");
			sb.append("<DATA2>" + vo.getProcessDeptName2() + "</DATA2>");
			sb.append("</CELL><CELL>");
			sb.append("<VALUE>" + (lang.equals("1") ? vo.getProcessDeptName() : vo.getProcessDeptName2()) + "</VALUE>");
			sb.append("</CELL></ROW>");
		}
		sb.append("</ROWS></LISTVIEWDATA>");
		logger.debug("getTaskCodeDeptInfo ended.");
		
		return sb.toString();
	}

	@Override
	public String addTaskCodeDeptInfo(String taskCode, String deptCode, String deptName, String deptName2, String companyID, LoginVO userInfo) throws Exception {
		logger.debug("addTaskCodeDeptInfo started.");
		int tenantID = userInfo.getTenantId();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TASKCODE", taskCode);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			logger.debug("getTaskName started.");
			ApprGTaskVO vo = ezApprovalGAdminDAO.getTaskName(map);
			logger.debug("getTaskName ended.");
			
			String temp = setTaskHistory(taskCode, vo.getTaskName(), vo.getTaskName2(), egovMessageSource.getMessage("ezApprovalG.lhj09", userInfo.getLocale()), "Designates the Dept", deptCode, deptName, deptName2, companyID, tenantID);
			
			if (temp.equals("FALSE")) {
				return "FALSE";
			}
			
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("v_TASKCODE", taskCode);
			map1.put("v_DEPTCODE", deptCode);
			map1.put("companyID", companyID);
			map1.put("tenantID", tenantID);
			
			logger.debug("getTaskCodeDeptCnt started.");
			int tempCount = ezApprovalGAdminDAO.getTaskCodeDeptCnt(map1);
			logger.debug("getTaskCodeDeptCnt ended.");
			
			Map<String, Object> map2 = new HashMap<String, Object>();
			map2.put("taskCode", taskCode);
			map2.put("deptCode", deptCode);
			map2.put("deptName", deptName);
			map2.put("deptName2", deptName2);
			map2.put("v_pNow1", commonUtil.getTodayUTCTime("yyyyMMddHHmm"));
			map2.put("v_pNow2", commonUtil.getTodayUTCTime("yyyyMMdd"));
			map2.put("companyID", companyID);
			map2.put("tenantID", tenantID);
			
			if (tempCount > 0){
				logger.debug("updateDeptInfo started.");
				ezApprovalGAdminDAO.updateDeptInfo(map2);
				logger.debug("updateDeptInfo ended.");
			} else {
				logger.debug("insertDeptInfo started.");
				ezApprovalGAdminDAO.insertDeptInfo(map2);
				logger.debug("insertDeptInfo ended.");
			}
			
			logger.debug("addTaskCodeDeptInfo ended.");
			
			return "TRUE";
		} catch(Exception e) {
			logger.debug("addTaskCodeDeptInfo catch.");
			logger.debug(e.getMessage());
			
			return "FALSE";
		}
	}

	@Override
	public String removeTaskCodeDeptInfo(String taskCode, String deptCode, String deptName, String deptName2, String companyID, LoginVO userInfo) throws Exception {
		logger.debug("removeTaskCodeDeptInfo started.");
		int tenantID = userInfo.getTenantId();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TASKCODE", taskCode);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			logger.debug("getTaskName started.");
			ApprGTaskVO vo = ezApprovalGAdminDAO.getTaskName(map);
			logger.debug("getTaskName ended.");
			
			String temp = setTaskHistory(taskCode, vo.getTaskName(), vo.getTaskName2(), egovMessageSource.getMessage("ezApprovalG.lhj10", userInfo.getLocale()), "Delete the dept", deptCode, deptName, deptName2, companyID, tenantID);
			
			if (temp.equals("FALSE")) {
				return "FALSE";
			}
			
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("taskCode", taskCode);
			map1.put("deptCode", deptCode);
			map1.put("v_pNow1", commonUtil.getTodayUTCTime("yyyyMMddHHmm"));
			map1.put("v_pNow2", commonUtil.getTodayUTCTime("yyyy-MM-dd"));
			map1.put("companyID", companyID);
			map1.put("tenantID", tenantID);
			
			logger.debug("removeDeptInfo started.");
			ezApprovalGAdminDAO.removeDeptInfo(map1);
			logger.debug("removeDeptInfo ended.");
			logger.debug("removeTaskCodeDeptInfo ended.");
			
			return "TRUE";
		} catch(Exception e) {
			logger.debug("removeTaskCodeDeptInfo catch.");
			logger.debug(e.getMessage());
			
			return "FALSE";
		}
	}
	
	@Override
	public String getTaskHistory(String taskCode, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("getTaskHistory started.");
		StringBuilder sb = new StringBuilder();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", "093");
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getListHeader started.");
		List<ApprGListHeaderVO> listHeader = ezApprovalGDAO.getListHeader(map);
		logger.debug("getListHeader ended.");
		
		sb.append("<LISTVIEWDATA><HEADERS>");
		
		for (int i = 0; i < listHeader.size(); i++) {
			ApprGListHeaderVO vo = listHeader.get(i);
			
			sb.append("<HEADER>");
			sb.append("<NAME>" + commonUtil.cleanValue(vo.getName()) + "</NAME>");
			sb.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
			sb.append("</HEADER>");
		}				
		sb.append("</HEADERS><ROWS>");
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_TASKCODE", taskCode);
		map1.put("v_LANGTYPE", lang);
		map1.put("companyID", companyID);
		map1.put("tenantID", tenantID);
		
		List<ApprGTaskCodeHistoryVO> listBody = ezApprovalGAdminDAO.getTaskHistory(map1);
		
		for (int i = 0; i < listBody.size(); i++) {
			ApprGTaskCodeHistoryVO bodyVo = listBody.get(i);
			
			sb.append("<ROW>");
			
			for (int j = 0; j < listHeader.size(); j++) {	
				ApprGListHeaderVO headerVo = listHeader.get(j);
				String fieldName = headerVo.getColName();
				String fieldValue = "";
				
				for (Field field : bodyVo.getClass().getDeclaredFields()) {
			        field.setAccessible(true);
					
					if (field.getName().toUpperCase().equals(fieldName.toUpperCase()) && field.get(bodyVo) != null) {
						fieldValue = String.valueOf(field.get(bodyVo));
					}
			    }
				sb.append("<CELL><VALUE>" + ezApprovalGService.getListField(fieldName, fieldValue, companyID, lang, tenantID) + "</VALUE></CELL>");
			}
			sb.append("</ROW>");
		}
		sb.append("</ROWS></LISTVIEWDATA>");
		
		logger.debug("getTaskHistory ended.");
		logger.debug("result=" + sb.toString());
		
		return sb.toString();
	}
	
	@Override
	public String getTaskFullList(String deptCode, String pageSize, String pageNo, String langType, String companyID, int tenantID) throws Exception {
		logger.debug("getTaskFullList started.");
		StringBuilder sb = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DEPTCODE", deptCode);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			List<ApprGTaskVO> list = ezApprovalGAdminDAO.getTaskFullList(map);
			
			sb.append("<DATA>");
			
			for (ApprGTaskVO vo : list) {
				sb.append(commonUtil.getQueryResult(vo));
			}
			sb.append("</DATA>");
			
			String result = ezApprovalGService.makeTaskFullListXml(commonUtil.convertStringToDocument(sb.toString()), companyID, pageSize, pageNo, langType, tenantID);
			logger.debug("getTaskFullList ended.");
			
			return result;
		} catch (Exception e) {
			logger.debug("getTaskFullList catch.");
			logger.debug(e.getMessage());
			
			return "<RESULT>FALSE</RESULT>";
		}
	}

	@Override
	public String getSealList(String listFlag, String companyID, String lang, int tenantID, String offset) throws Exception {
		logger.debug("getSealList started.");
		StringBuilder sb = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTFLAG", listFlag);
		map.put("v_PMULTIDATA", lang);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprGSealInfoVO> list = ezApprovalGAdminDAO.getSealList(map);
		
		sb.append("<ROWS>");
		
		for(ApprGSealInfoVO vo : list) {
			sb.append("<ROW>");
			sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getSealName()) + "</VALUE>");
			sb.append("<DATA1>" + vo.getSealNum() + "</DATA1>");
			sb.append("<DATA2>" + vo.getSealPath() + "</DATA2>");
			sb.append("<DATA3>" + commonUtil.cleanValue(vo.getRegUserID()) + "</DATA3></CELL>");
			sb.append("<CELL><VALUE>" + vo.getSealWidth() + "</VALUE></CELL>");
			sb.append("<CELL><VALUE>" + vo.getSealHeight() + "</VALUE></CELL>");
			sb.append("<CELL><VALUE>" + commonUtil.getDateStringInUTC(vo.getRegDate(), offset, false) + "</VALUE></CELL>");
			
			if (vo.getDelDate() == null) {
				sb.append("<CELL><VALUE>" + " " + "</VALUE></CELL>");
			} else {
				sb.append("<CELL><VALUE>" + commonUtil.getDateStringInUTC(vo.getDelDate(), offset, false) + "</VALUE></CELL>");
			}
			
			sb.append("<CELL><VALUE>" + vo.getRegUserName() + "</VALUE></CELL>");
			sb.append("</ROW>");
		}
		
		sb.append("</ROWS>");
		logger.debug("getSealList ended.");
		
		return sb.toString();
	}

	@Override
	public String sealDelete(String realPath, String dirPath, String fileName) throws Exception{
		String result = "FALSE";
		
		try {
			logger.debug("sealDelete started.");
			deleteFile(realPath + dirPath + fileName);
			logger.debug("sealDelete ended.");
			
			result = "TRUE";
		} catch(Exception e) {
			logger.debug("sealDelete catch.");
			logger.debug(e.getMessage());
			
			result = "FALSE";
		}
		
		return result;
	}

	@Override
	public String deleteSealInfo(String pSealNum, String companyID, int tenantID) throws Exception {
		String result = "FALSE";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SEALNUM", pSealNum);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			logger.debug("deleteSealInfo started.");
			ezApprovalGAdminDAO.deleteSealInfo(map);
			logger.debug("deleteSealInfo ended.");
			
			result = "TRUE";
		} catch (Exception e) {
			logger.debug("deleteSealInfo catch.");
			logger.debug(e.getMessage());
			
			result = "FALSE";
		}
		
		return result;
	}
	
	@Override
	public String insertSealInfo(String pSealNum, String pSealName, String pSealPath, String pSealWidth, String pSealHeight, String pRegUserID, String pRegUserName, String pRegUserName2, String companyID, int tenantID) throws Exception {
		logger.debug("insertSealInfo started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SEALNUM", pSealNum);
		map.put("v_SEALNAME", pSealName);
		map.put("v_SEALPATH", pSealPath);
		map.put("v_SEALWIDTH", pSealWidth);
		map.put("v_SEALHEIGHT", pSealHeight);
		map.put("v_REGUSERID", pRegUserID);
		map.put("v_REGUSERNAME", pRegUserName);
		map.put("v_REGUSERNAME2", pRegUserName2);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try{
			logger.debug("insertSealInfoSelect started.");
			int result = ezApprovalGAdminDAO.insertSealInfoSelect(map);
			logger.debug("insertSealInfoSelect ended.");
			logger.debug("result=" + result);
			
			if (result == 0) {
				logger.debug("insertSealInfoInsert started.");
				ezApprovalGAdminDAO.insertSealInfoInsert(map);
				logger.debug("insertSealInfoInsert ended.");
			} else {
				logger.debug("insertSealInfoUpdate started.");
				ezApprovalGAdminDAO.insertSealInfoUpdate(map);
				logger.debug("insertSealInfoUpdate ended.");
			}
			
			logger.debug("insertSealInfo ended.");
			
			return "TRUE";
		} catch (Exception e) {
			logger.debug("insertSealInfo catch.");
			logger.debug(e.getMessage());
			
			return "FALSE";
		}
	}

	@Override
	public String getSealDeptList(String listFlag, String deptID, String companyID, String primary, String offset, int tenantID) throws Exception {
		logger.debug("getSealDeptList started.");
		StringBuilder sb = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTFLAG", listFlag);
		map.put("v_DEPTID", deptID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprGSealInfoVO> list = ezApprovalGAdminDAO.getSealDeptList(map);
		
		sb.append("<ROWS>");
		
		for(ApprGSealInfoVO vo : list) {
			sb.append("<ROW>");
			sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getSealName()) + "</VALUE>");
			sb.append("<DATA1>" + vo.getSealNum() + "</DATA1>");
			sb.append("<DATA2>" + vo.getSealPath() + "</DATA2>");
			sb.append("<DATA3>" + commonUtil.cleanValue(vo.getRegUserID()) + "</DATA3></CELL>");
			sb.append("<CELL><VALUE>" + vo.getSealWidth() + "</VALUE></CELL>");
			sb.append("<CELL><VALUE>" + vo.getSealHeight() + "</VALUE></CELL>");
			sb.append("<CELL><VALUE>" + commonUtil.getDateStringInUTC(vo.getRegDate(), offset, false) + "</VALUE></CELL>");
			
			if (vo.getDelDate() == null) {
				sb.append("<CELL><VALUE>" + " " + "</VALUE></CELL>");
			} else {
				sb.append("<CELL><VALUE>" + commonUtil.getDateStringInUTC(vo.getDelDate(), offset, false) + "</VALUE></CELL>");
			}

			if (primary.equals("1")) {
				sb.append("<CELL><VALUE>" + vo.getRegUserName() + "</VALUE></CELL>");
			} else {
				sb.append("<CELL><VALUE>" + vo.getRegUserName2() + "</VALUE></CELL>");
			}
			
			sb.append("</ROW>");
		}
		
		sb.append("</ROWS>");
		logger.debug("getSealDeptList ended.");
		
		return sb.toString();
	}
	
	@Override
	public String insertDeptSealInfo(String pSealNum, String pSealName, String pSealPath, String pSealWidth, String pSealHeight, String pRegUserID, String pRegUserName, String pRegUserName2, String deptID, String companyID, int tenantID) throws Exception {
		logger.debug("insertDeptSealInfo started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SEALNUM", pSealNum);
		map.put("v_SEALNAME", pSealName);
		map.put("v_SEALPATH", pSealPath);
		map.put("v_SEALWIDTH", pSealWidth);
		map.put("v_SEALHEIGHT", pSealHeight);
		map.put("v_REGUSERID", pRegUserID);
		map.put("v_REGUSERNAME", pRegUserName);
		map.put("v_REGUSERNAME2", pRegUserName2);
		map.put("v_DEPTID", deptID);
		map.put("companyID", companyID);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		try{
			int temp = ezApprovalGAdminDAO.insertDeptSealInfoSelect(map);
			
			if (temp == 0) {
				ezApprovalGAdminDAO.insertDeptSealInfoInsert(map);
			} else {
				ezApprovalGAdminDAO.insertDeptSealInfoUpdate(map);
			}
			
			logger.debug("insertDeptSealInfo ended.");
			
			return "TRUE";
		} catch (Exception e) {
			logger.debug("insertDeptSealInfo catch.");
			logger.debug(e.getMessage());
			
			return "FALSE";
		}	
	}
	
	@Override
	public String deleteDeptSealInfo(String pSealNum, String deptID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SEALNUM", pSealNum);
		map.put("v_DEPTID", deptID);
		map.put("companyID", companyID);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		try {
			logger.debug("deleteDeptSealInfo started.");
			ezApprovalGAdminDAO.deleteSealDeptInfo(map);
			logger.debug("deleteDeptSealInfo ended.");
			
			return "TRUE";
		} catch (Exception e) {
			logger.debug("deleteDeptSealInfo catch.");
			logger.debug(e.getMessage());
			
			return "FALSE";
		}
	}

	@Override
	public String getDeptTranSendDocCount(String sYear, String sMonth, String eYear, String eMonth, String pMode, String companyID, String lang, String offset, int tenantID) throws Exception {
		StringBuilder sb = new StringBuilder();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", "108");
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getListHeader started.");
		List<ApprGListHeaderVO> listHeader = ezApprovalGDAO.getListHeader(map);
		logger.debug("getListHeader ended.");
		
		sb.append("<LISTVIEWDATA><HEADERS>");
		
		for (int i = 0; i < listHeader.size(); i++) {
			ApprGListHeaderVO vo = listHeader.get(i);
			
			if (pMode.equals("RECV") && i != 0){
				sb.append("<HEADER>");
				sb.append("<NAME>" + commonUtil.cleanValue(vo.getName()) + "</NAME>");
				sb.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
				sb.append("</HEADER>");
			} else if (pMode.equals("SEND") && i != 1) {
				sb.append("<HEADER>");
				sb.append("<NAME>" + commonUtil.cleanValue(vo.getName()) + "</NAME>");
				sb.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
				sb.append("</HEADER>");
			} else if (pMode.equals("BOTH")){
				sb.append("<HEADER>");
				sb.append("<NAME>" + commonUtil.cleanValue(vo.getName()) + "</NAME>");
				sb.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
				sb.append("</HEADER>");
			}
		}
		sb.append("</HEADERS><ROWS>");
		
		String szFrom = commonUtil.getDateStringInUTC(sYear + "-" + sMonth + "-01 00:00:00", offset, true);
		String szTo = commonUtil.getDateStringInUTC(eYear + "-" + eMonth + "-01 00:00:00", offset, true);
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_MODE", pMode);
		map1.put("v_FROM", szFrom);
		map1.put("v_TO", szTo);
		map1.put("v_LANGTYPE", lang);
		map1.put("companyID", companyID);
		map1.put("tenantID", tenantID);
		
		logger.debug("mode=" + pMode);
		logger.debug("szFrom=" + szFrom);
		logger.debug("szTo=" + szTo);
		logger.debug("lang=" + lang);
		
		logger.debug("getDeptTranSendDocCount started.");
		List<ApprGReceiveDocVO> list = ezApprovalGAdminDAO.getDeptTranSendDocCount(map1);
		logger.debug("getDeptTranSendDocCount ended.");
		
		for(ApprGReceiveDocVO vo : list) {
			if (vo != null) {
				sb.append("<ROW>");
				
				if (!pMode.equals("RECV")) {
					sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getSentDeptName()) + "</VALUE></CELL>");
				}
				if (!pMode.equals("SEND")) {
					sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getReceivedDeptName()) + "</VALUE></CELL>");
				}
				
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getAprCount()) + "</VALUE></CELL></ROW>");
			}
		}
		
		sb.append("</ROWS></LISTVIEWDATA>");
		
		return sb.toString();
	}

	@Override
	public String getUserDocCount(String sYear, String sMonth, String eYear, String eMonth, String userFlag, String companyID, LoginVO userInfo) throws Exception {
		StringBuilder sb = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", "107");
		map.put("v_LANGTYPE", userInfo.getLang());
		map.put("companyID", companyID);
		map.put("v_TENANTID", userInfo.getTenantId());
		
		logger.debug("getListHeader started.");
		List<ApprGListHeaderVO> listHeader = ezApprovalGDAO.getListHeader(map);
		logger.debug("getListHeader ended.");
		
		sb.append("<LISTVIEWDATA><HEADERS>");
		
		for (int i = 0; i < listHeader.size(); i++) {
			ApprGListHeaderVO vo = listHeader.get(i);
			
			sb.append("<HEADER>");
			
			if (vo.getName().equals(egovMessageSource.getMessage("ezApprovalG.t445", userInfo.getLocale()))) {
				switch (userFlag) {
				case "1":
					vo.setName(egovMessageSource.getMessage("ezApprovalG.t445", userInfo.getLocale()));
					break;
				case "2":
					vo.setName(egovMessageSource.getMessage("ezApprovalG.t1304", userInfo.getLocale()));
					break;
				case "3":
					vo.setName(egovMessageSource.getMessage("ezApprovalG.t1305", userInfo.getLocale()));
					break;
				case "4":
					vo.setName(egovMessageSource.getMessage("ezApprovalG.t1306", userInfo.getLocale()));
					break;
				default:
					vo.setName(egovMessageSource.getMessage("ezApprovalG.t445", userInfo.getLocale()));
					break;
				}
			}
			
			sb.append("<NAME>" + commonUtil.cleanValue(vo.getName()) + "</NAME>");
			sb.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
			sb.append("</HEADER>");
		}
		sb.append("</HEADERS><ROWS>");
		
		String aprType = "";
		switch (userFlag) {
		case "1":
			aprType = "018";
			break;
		case "2":
			aprType = "019";
			break;
		case "3":
			aprType = "008, 009, 011, 012";
			break;
		case "4":
			aprType = "001, 004, 016";
			break;
		}
		
		String szFrom = commonUtil.getDateStringInUTC(sYear + "-" + sMonth + "-01 00:00:00", userInfo.getOffset(), true);
		String szTo = commonUtil.getDateStringInUTC(eYear + "-" + eMonth + "-01 00:00:00", userInfo.getOffset(), true);
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_APRTYPE", aprType);
		map1.put("v_FROM", szFrom);
		map1.put("v_TO", szTo);
		map1.put("v_STRLANG", commonUtil.getMultiData(userInfo.getLang()));
		map1.put("companyID", companyID);
		map1.put("tenantID", userInfo.getTenantId());
		
		logger.debug("aprType=" + aprType);
		logger.debug("getUserDocCount started.");
		List<ApprGAprLineVO> list = ezApprovalGAdminDAO.getUserDocCount(map1);
		logger.debug("getUserDocCount ended.");
		
		for (ApprGAprLineVO vo : list) {
			sb.append("<ROW>");
			if (userInfo.getLang().equals("1")) {
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getAprMemberDeptName()) + "</VALUE>");
				sb.append("<DATA1>" + commonUtil.cleanValue(vo.getAprMemberDeptID()) + "</DATA1>");
				sb.append("<DATA2>" + commonUtil.cleanValue(vo.getAprMemberID()) + "</DATA2></CELL>");
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getAprMemberJobTitle()) + "</VALUE></CELL>");
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getAprMemberName()) + "</VALUE></CELL>");
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getAprCount()) + "</VALUE></CELL>");
			} else {
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getAprMemberDeptName2()) + "</VALUE>");
				sb.append("<DATA1>" + commonUtil.cleanValue(vo.getAprMemberDeptID()) + "</DATA1>");
				sb.append("<DATA2>" + commonUtil.cleanValue(vo.getAprMemberID()) + "</DATA2></CELL>");
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getAprMemberJobTitle2()) + "</VALUE></CELL>");
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getAprMemberName2()) + "</VALUE></CELL>");
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getAprCount()) + "</VALUE></CELL>");
			}
			sb.append("</ROW>");
		}
		
		sb.append("</ROWS></LISTVIEWDATA>");
		
		return sb.toString();
	}
	
	@Override
	public String searchManageAprDocList(String docNumber, String docTitle,
			String drafter, String drafter2, String draftFromYear,
			String draftFromMonth, String draftFromDay, String draftToYear,
			String draftToMonth, String draftToDay, String apprFromYear,
			String apprFromMonth, String apprFromDay, String apprToYear,
			String apprToMonth, String apprToDay, String formID,
			String draftDeptName, String draftDeptName2, String pageNum,
			String pageSize, String docState, String subQuery,
			String orderCell, String orderOption, String companyID, String primary, String approvUser, String offset, int tenantID)
			throws Exception {
		logger.debug("searchManageAprDocList started.");
		String orderOption1 = "";
		String orderOption2 = "";
		StringBuilder sb = new StringBuilder();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", "081");
		map.put("v_LANGTYPE", primary);
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getListHeader started.");
		List<ApprGListHeaderVO> listHeader = ezApprovalGDAO.getListHeader(map);
		logger.debug("getListHeader ended.");
		
		sb.append("<DOCLIST><LISTVIEWDATA><HEADERS>");
		
		for (int i = 0; i < listHeader.size(); i++) {
			ApprGListHeaderVO vo = listHeader.get(i);
			
			sb.append("<HEADER>");
			sb.append("<NAME>" + commonUtil.cleanValue(vo.getName()) + "</NAME>");
			sb.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
			sb.append("<COLNAME>" + commonUtil.cleanValue(vo.getColName()) + "</COLNAME>");
			sb.append("</HEADER>");
			
			if (orderCell.equals("") && orderCell.equals(vo.getName())) {
				if (orderOption.equals("")) {
					orderOption1 = vo.getColName() + " ";
					orderOption2 = vo.getColName() + " desc ";
				} else {
					orderOption1 = vo.getColName() + " desc ";
					orderOption2 = vo.getColName() + " ";
				}
			}
		}				
		sb.append("</HEADERS><ROWS>");
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_SUBQUERY", subQuery);
		map1.put("v_DOCNUMBER", docNumber);
		map1.put("v_DOCTITLE", docTitle);
		map1.put("v_DRAFTER", drafter);
		map1.put("v_DRAFTER2", drafter2);
		map1.put("v_DEPTNAME", draftDeptName);
		map1.put("v_DEPTNAME2", draftDeptName2);
		map1.put("v_FORMID", formID);
		map1.put("v_DOCSTATE", docState);
		map1.put("v_STARTDATE1", commonUtil.getDateStringInUTC(commonUtil.makeDate(draftFromYear, draftFromMonth, draftFromDay, true), offset, true));
		map1.put("v_STARTDATE2", commonUtil.getDateStringInUTC(commonUtil.makeDate(draftToYear, draftToMonth, draftToDay, false), offset, true));
		map1.put("v_ENDDATE1", commonUtil.getDateStringInUTC(commonUtil.makeDate(apprFromYear, apprFromMonth, apprFromDay, true), offset, true));
		map1.put("v_ENDDATE2", commonUtil.getDateStringInUTC(commonUtil.makeDate(apprToYear, apprToMonth, apprToDay, false), offset, true));
		map1.put("v_LANGTYPE", commonUtil.getMultiData(primary));
		map1.put("v_APPROVUSER", approvUser);
		map1.put("companyID", companyID);
		map1.put("tenantID", tenantID);
		
		logger.debug("searchManageAprDocListCount started.");
		int totalCount = ezApprovalGAdminDAO.searchManageAprDocListCount(map1);
		logger.debug("searchManageAprDocListCount ended. totalCount=" + totalCount);
		
		int querySize = Integer.parseInt(pageSize) * Integer.parseInt(pageNum);
		int querySize2 = totalCount - Integer.parseInt(pageSize) * (Integer.parseInt(pageNum) - 1);
		
		if (querySize2 >= Integer.parseInt(pageSize)) {
			querySize2 = Integer.parseInt(pageSize);
		}
		
		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.put("v_SUBQUERY", subQuery);
		map2.put("v_PAGESIZE", querySize);
		map2.put("v_PAGESIZE2", querySize2);
		map2.put("v_ORDEROPTION", orderOption1);
		map2.put("v_ORDEROPTION2", orderOption2);
		map2.put("v_DOCNUMBER", docNumber);
		map2.put("v_DOCTITLE", docTitle);
		map2.put("v_DRAFTER", drafter);
		map2.put("v_DRAFTER2", drafter2);
		map2.put("v_DEPTNAME", draftDeptName);
		map2.put("v_DEPTNAME2", draftDeptName2);
		map2.put("v_FORMID", formID);
		map2.put("v_DOCSTATE", docState);
		map2.put("v_STARTDATE1", commonUtil.getDateStringInUTC(commonUtil.makeDate(draftFromYear, draftFromMonth, draftFromDay, true), offset, true));
		map2.put("v_STARTDATE2", commonUtil.getDateStringInUTC(commonUtil.makeDate(draftToYear, draftToMonth, draftToDay, false), offset, true));
		map2.put("v_ENDDATE1", commonUtil.getDateStringInUTC(commonUtil.makeDate(apprFromYear, apprFromMonth, apprFromDay, true), offset, true));
		map2.put("v_ENDDATE2", commonUtil.getDateStringInUTC(commonUtil.makeDate(apprToYear, apprToMonth, apprToDay, false), offset, true));
		map2.put("v_LANGTYPE", commonUtil.getMultiData(primary));
		map2.put("v_APPROVUSER", approvUser);
		map2.put("companyID", companyID);
		map2.put("tenantID", tenantID);
		
		logger.debug("searchManageAprDocList started.");
		logger.debug("subQuery=" + subQuery);
		logger.debug("querySize=" + querySize);
		logger.debug("querySize2=" + querySize2);
		logger.debug("orderOption1=" + orderOption1);
		logger.debug("orderOption2=" + orderOption2);
		logger.debug("docNumber=" + docNumber);
		logger.debug("docTitle=" + docTitle);
		logger.debug("drafter=" + drafter);
		logger.debug("drafter2=" + drafter2);
		logger.debug("draftDeptName=" + draftDeptName);
		logger.debug("draftDeptName2=" + draftDeptName2);
		logger.debug("formID=" + formID);
		logger.debug("docState=" + docState);
		List<ApprGAprDocInfoVO> listBody = ezApprovalGAdminDAO.searchManageAprDocList(map2);
		logger.debug("searchManageAprDocList ended. listBodysize=" + listBody.size());
		
		for(int i = 0; i < listBody.size(); i ++) {
			ApprGAprDocInfoVO bodyVo = listBody.get(i);
			sb.append("<ROW>");
			
			for (int j = 0; j < listHeader.size(); j++) {
				ApprGListHeaderVO headerVo = listHeader.get(j);				
				String fieldName = headerVo.getColName();
				String fieldValue = "";

				if (fieldName.toUpperCase().equals("WRITERNAME") || fieldName.toUpperCase().equals("WRITERDEPTNAME") || fieldName.toUpperCase().equals("FORMNAME")){
					fieldName = fieldName + commonUtil.getMultiData(primary);
				}
				
				for (Field field : bodyVo.getClass().getDeclaredFields()) {
			        field.setAccessible(true);
										
					if (field.getName().toUpperCase().equals(fieldName.toUpperCase())) {
						if (fieldName.toUpperCase().equals("STARTDATE")) {
							fieldValue = String.valueOf(commonUtil.getDateStringInUTC(String.valueOf(field.get(bodyVo)), offset, false));
						} else {
							fieldValue = String.valueOf(field.get(bodyVo));
						}
						
					}
			    }
				
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(ezApprovalGService.getListField(fieldName.toUpperCase(), fieldValue, companyID, primary, tenantID)) + "</VALUE>");

				if (j == 0) {
					sb.append("<DATA1>" + bodyVo.getDocID() + "</DATA1>");
					sb.append("<DATA2>" + bodyVo.getOrgDocID() + "</DATA2>");
					sb.append("<DATA3>" + bodyVo.getHref() + "</DATA3>");
					sb.append("<DATA4>" + "" + "</DATA4>");
					sb.append("<DATA5>" + "" + "</DATA5>");
					sb.append("<DATA6>" + "" + "</DATA6>");
					sb.append("<DATA7>" + "" + "</DATA7>");
					sb.append("<DATA8>" + "" + "</DATA8>");
					sb.append("<DATA9>" + "0" + "</DATA9>");
					sb.append("<DATA10>" + bodyVo.getFunctionType() + "</DATA10>");
					sb.append("<DATA11>" + bodyVo.getHasOptionYN() + "</DATA11>");
					sb.append("<DATA12>" + bodyVo.getDocState() + "</DATA12>");
					sb.append("<DATA13>" + bodyVo.getWriterDeptID() + "</DATA13>");
					sb.append("<DATA14>" + bodyVo.getUrgentApproval() + "</DATA14>");
				}					
				sb.append("</CELL>");
			}
			sb.append("</ROW>");
		}
		
		sb.append("</ROWS></LISTVIEWDATA><TOTALCNT>" + totalCount + "</TOTALCNT></DOCLIST>");
		
		return sb.toString();
	}

	@Override
	public String setFormOrder(String formContID, String formIDList, String companyID, int tenantID) throws Exception {
		try {
			logger.debug("setFormOrder started.");
			int formListCount = formIDList.split(";").length;
			int index = 0;
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_pFORMCONTID", formContID);
			map.put("companyID", companyID);
			map.put("tenantID", tenantID);
			
			logger.debug("formIDList=" + formIDList);
			logger.debug("formListCount=" + formListCount);
			logger.debug("formContID=" + formContID);
			
			for (String formID : formIDList.split(";")) {
				map.put("v_pFORMID", formID);
				map.put("order", ++index);
				
				logger.debug("index=" + index);
				ezApprovalGAdminDAO.setFormOrder(map);
			}
			
			logger.debug("setFormOrder ended.");
			
			return "OK";
		} catch (Exception e) {
			logger.debug("setFormOrder catch.");
			logger.debug(e.getMessage());
			
			return "ERROR";
		}
	}

	@Override
	public String insertFormContainer(String contName, String contName2, String contDescript, String contParent, String contDept, String deptList, String companyID, int tenantID) throws Exception {
		contParent = (contParent.equals("") ? "ROOT" : contParent);
		contDept = (contDept.equals("") ? " " : contDept);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		logger.debug("insertFormContainerConti started.");
		String contID = ezApprovalGAdminDAO.insertFormContainerConti(map).toString();
		logger.debug("insertFormContainerConti ended. contID=" + contID);
		
		if (contID.substring(0, 4).equals(commonUtil.getTodayUTCTime("YYYY"))) {
			int tempID = Integer.parseInt(contID) + 1;
			contID = Integer.toString(tempID);
		} else {
			contID = commonUtil.getTodayUTCTime("YYYY") + "000001";
		}
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("contID", contID);
		map1.put("contName", contName);
		map1.put("contName2", contName2);
		map1.put("contDept", contDept);
		map1.put("contParent", contParent);
		map1.put("contDescript", contDescript);
		map1.put("companyID", companyID);
		map1.put("tenantID", tenantID);
		
		try {
			logger.debug("insertFormContainer started.");
			ezApprovalGAdminDAO.insertFormContainer(map1);
			logger.debug("insertFormContainer ended.");
			
			if (!contDept.equals("ALL")) {
				Map<String, Object> map2 = new HashMap<String, Object>();
				map2.put("contID", contID);
				map2.put("companyID", companyID);
				map2.put("tenantID", tenantID);
				
				for(String deptID : deptList.split(";")) {
					map2.put("deptID", deptID);
					
					logger.debug("insertFormContainerGroup started.");
					ezApprovalGAdminDAO.insertFormContainerGroup(map2);
					logger.debug("insertFormContainerGroup started.");
				}
			}
			
			return "<PARAMETER><FContID>" + contID + "</FContID></PARAMETER>";
		} catch(Exception e) {
			return "<PARAMETER><FContID>FALSE</FContID></PARAMETER>";
		}
	}

	@Override
	public String getGroupDept(String contID, String lang, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMCONTID", contID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		logger.debug("getGroupDept started.");
		List<ApprGFormVO> list = ezApprovalGAdminDAO.getGroupDept(map);
		logger.debug("listsize=" + list.size());
		
		StringBuilder sb = new StringBuilder();
		sb.append("<PARAMETER>");
		
		for(ApprGFormVO vo : list) {
			sb.append("<ID" + list.indexOf(vo) + ">");
			sb.append(commonUtil.cleanValue(vo.getFormContUserDepID()));
			sb.append("</ID" + list.indexOf(vo) + ">");
			sb.append("<NAME" + list.indexOf(vo) + ">");
			
			if (!lang.equals("2")) {
				sb.append(ezOrganService.getPropertyValue(vo.getFormContUserDepID(), "displayname", tenantID));
			} else {
				sb.append(ezOrganService.getPropertyValue(vo.getFormContUserDepID(), "displayname2", tenantID));
			}
			
			sb.append("</NAME" + list.indexOf(vo) + ">");
		}
		
		sb.append("</PARAMETER>");
		logger.debug("getGroupDept ended.");
		
		return sb.toString();
	}

	@Override
	public String updateFormContainer(String contName, String contName2, String contDescript, String contParent, String contDept, String contID, String deptList, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("contName", contName);
		map.put("contName2", contName2);
		map.put("contDept", contDept);
		map.put("contParent", contParent);
		map.put("contID", contID);
		map.put("contDescript", contDescript);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			logger.debug("updateFormContainer started.");
			ezApprovalGAdminDAO.updateFormContainer(map);
			logger.debug("updateFormContainer ended.");
			
			if (!contDept.equals("ALL")) {
				Map<String, Object> map2 = new HashMap<String, Object>();
				map2.put("contID", contID);
				map2.put("companyID", companyID);
				map2.put("tenantID", tenantID);
				
				logger.debug("deleteFormContUserGroup started.");
				ezApprovalGAdminDAO.deleteFormContUserGroup(map2);
				logger.debug("deleteFormContUserGroup ended.");
				
				Map<String, Object> map3 = new HashMap<String, Object>();
				map3.put("contID", contID);
				map3.put("companyID", companyID);
				map3.put("tenantID", tenantID);

				for(String deptID : deptList.split(";")) {
					map3.put("deptID", deptID);
					map3.put("tenantID", tenantID);
					
					logger.debug("insertFormContainerGroup started.");
					ezApprovalGAdminDAO.insertFormContainerGroup(map3);
					logger.debug("insertFormContainerGroup ended.");
				}
			}
			
			return "<PARAMETER><RTNVALUE>" + contID + "</RTNVALUE></PARAMETER>";
		} catch(Exception e) {
			return "<PARAMETER><RTNVALUE>FALSE</RTNVALUE></PARAMETER>";
		}
	}

	@Override
	public String deleteFormContainer(String contID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMCONTID", contID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			logger.debug("deleteFormContainer started.");
			ezApprovalGAdminDAO.deleteFormContainer1(map);
			ezApprovalGAdminDAO.deleteFormContainer2(map);
			logger.debug("deleteFormContainer ended.");
			
			return "TRUE";
		} catch (Exception e) {
			logger.debug("deleteFormContainer catch.");
			
			return "FALSE";
		}
	}

	@Override
	public String getFormContent(String formID, String lang, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PFORMID", formID);
		map.put("v_PLANG", lang);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		logger.debug("getFormContent started.");
		ApprGFormVO vo = ezApprovalGAdminDAO.getFormContent(map);
		logger.debug("getFormContent ended.");
		
		String result = commonUtil.getQueryResult(vo);
		
		return result;
	}

	@Override
	public String delForm(String formID, String companyID, String realPath, int tenantID) throws Exception {
		logger.debug("delForm started.");
		String result = deleteForm(formID, companyID, tenantID);
		
		try {
			if (result.equals("TRUE")) {
				deleteFile(realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID) + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + formID + ".mht");
				
				result = "TRUE";
			} else {
				result = "FALSE";
			}
		} catch (Exception e) {
			logger.debug("delForm catch.");
			logger.debug(e.getMessage());
			
			result = "FALSE";
		}
		
		logger.debug("delForm ended.");
		
		return result;
	}

	@Override
	public String getFormRecvAdmin(String formID, String lang, String companyID, int tenantID) throws Exception {
		StringBuilder sb = new StringBuilder();		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", "105");
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getListHeader started.");
		List<ApprGListHeaderVO> listHeader = ezApprovalGDAO.getListHeader(map);
		logger.debug("getListHeader ended.");
		
		sb.append("<LISTVIEWDATA><HEADERS>");

		for (int i = 0; i < listHeader.size(); i++) {
			ApprGListHeaderVO vo = listHeader.get(i);
			
			sb.append("<HEADER>");
			sb.append("<NAME>" + commonUtil.cleanValue(vo.getName()) + "</NAME>");
			sb.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
			sb.append("</HEADER>");
		}
		sb.append("</HEADERS><ROWS>");
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_FORMID", formID);
		map1.put("companyID", companyID);
		map1.put("tenantID", tenantID);
		
		logger.debug("getFormRecvAdmin started.");
		List<ApprGFormVO> listBody = ezApprovalGAdminDAO.getFormRecvAdmin(map1);
		logger.debug("getFormRecvAdmin ended.");
		
		for (int i = 0; i < listBody.size(); i++) {
			ApprGFormVO bodyVo = listBody.get(i);
			
			for (int j = 0; j < listHeader.size(); j++) {	
				sb.append("<ROW>");
				sb.append("<CELL><VALUE>" + ezOrganService.getPropertyValue(bodyVo.getDeptID(), "DisplayName" + commonUtil.getMultiData(lang), tenantID) + "</VALUE>");

				if (j == 0) {
					sb.append("<DATA1>" + bodyVo.getDeptID() + "</DATA1></CELL></ROW>");
				} else {
					sb.append("</CELL></ROW>");
				}
			}
		}
		
		sb.append("</ROWS></LISTVIEWDATA>");

		return sb.toString();
	}

	@Override
	public String formSave(Document doc, String realPath, String companyID, LoginVO userInfo) throws Exception {
		String contID = doc.getElementsByTagName("FORMCONTID").item(0).getTextContent();
		String formID = doc.getElementsByTagName("FORMID").item(0).getTextContent();
		String rtnValue = "";
		
		if (doc.getElementsByTagName("FORMINFO").getLength() > 0) {
			String formInfo = doc.getElementsByTagName("FORMINFO").item(0).getTextContent();
			
			String formConn = "";
			if (doc.getElementsByTagName("FORMCONN").getLength() > 0) {
				formConn = doc.getElementsByTagName("FORMCONN").item(0).getTextContent();
			}
			
			String formWorkFlow = "";
			if (doc.getElementsByTagName("FORMWORKFLOW").getLength() > 0) {
				formWorkFlow = doc.getElementsByTagName("FORMWORKFLOW").item(0).getTextContent();
			}
			
			String formRecevGroup = "";
			if (doc.getElementsByTagName("FORMRECEVGROUP").getLength() > 0) {
				formRecevGroup = doc.getElementsByTagName("FORMRECEVGROUP").item(0).getTextContent();
			}
			
			String formMht = "";
			if (doc.getElementsByTagName("FORMMHT").getLength() > 0) {
				if (!doc.getElementsByTagName("FORMMHT").item(0).getTextContent().equals("")) {
					formMht = doc.getElementsByTagName("FORMMHT").item(0).getTextContent();
				}
			}
			rtnValue = saveFormInfo(contID, formID, formInfo, formConn, formWorkFlow, formRecevGroup, formMht, companyID, realPath, userInfo);
		}
		
		if (rtnValue.indexOf("ERROR") > 0) {
			return "<DATA>" + rtnValue + "</DATA>";
		} else {
			return "<DATA>OK</DATA>";
		}
	}

	private String setTaskHistory(String taskCode, String taskName, String taskName2, String changeFactor, String changeFactor2, String beforeValue, String afterValue, String afterValue2, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_APPLYDATE", commonUtil.getTodayUTCTime(""));
		map.put("v_TASKCODE", taskCode);
		map.put("v_TASKNAME", taskName);
		map.put("v_TASKNAME2", taskName2);
		map.put("v_CHANGEFACTOR", changeFactor);
		map.put("v_CHANGEFACTOR2", changeFactor2);
		map.put("v_BEFOREVALUE", beforeValue);
		map.put("v_AFTERVALUE", afterValue);
		map.put("v_AFTERVALUE2", afterValue2);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			logger.debug("setTaskHistory started.");
			ezApprovalGAdminDAO.setTaskHistory(map);
			logger.debug("setTaskHistory ended.");
			
			return "TRUE";
		} catch(Exception e) {
			logger.debug("setTaskHistory ERROR.");
			logger.debug(e.getMessage());
			
			return "FALSE";
		}
	}
	
	private String deleteForm(String formID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", formID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			logger.debug("deleteForm started.");
			ezApprovalGAdminDAO.deleteForm1(map);
			ezApprovalGAdminDAO.deleteForm2(map);
			logger.debug("deleteForm ended.");
			
			return "TRUE";
		} catch (Exception e) {
			logger.debug("deleteForm catch.");
			
			return "FALSE";
		}
	}
	
	private String saveFormInfo(String contID, String formID, String formInfo, String formConnInfo, String formWorkFlow, String formRecevGroup, String formMhtInfo, String companyID, String realPath, LoginVO userInfo) throws Exception {
		logger.debug("saveFormInfo started.");
		String strBeforMHT = "";
		String path = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(formInfo);
		String formName = doc.getElementsByTagName("FormName").item(0).getTextContent();
		String formName2 = doc.getElementsByTagName("FormName2").item(0).getTextContent();
		String formDescript = doc.getElementsByTagName("FormDescript").item(0).getTextContent();
		String formKind = doc.getElementsByTagName("FormKind").item(0).getTextContent();
		String formConnFlag = doc.getElementsByTagName("ConnFlag").item(0).getTextContent();

		//TODO 확인후삭제
		String connXML = "";
		if (!formConnInfo.equals("")) {
			doc = commonUtil.convertStringToDocument(formConnInfo);
			connXML = doc.getElementsByTagName("CONNXML").item(0).getTextContent();
		}

		//TODO 확인후삭제
		String validationsXML = "";
		String statusXML = "";
		if (!formWorkFlow.equals("")) {
			doc = commonUtil.convertStringToDocument(formWorkFlow);
			validationsXML = doc.getElementsByTagName("VALIDATIONS").item(0).getTextContent();
			statusXML = doc.getElementsByTagName("STATUS").item(0).getTextContent();
		}

		String recevGroupXML = "";
		if (!formRecevGroup.equals("")) {
			recevGroupXML = formRecevGroup;
		}
     
		boolean isUpdate = false;
		String saveFileName = "";

		if (!formID.equals("") && !formMhtInfo.equals("")) {
			isUpdate = true;
			saveFileName = realPath + path + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + formID + ".mht";
			
			try {
				File file = new File(saveFileName);
				if (file.exists()) {
					BufferedReader br = new BufferedReader(new FileReader(saveFileName));

					StringBuilder sb = new StringBuilder();
					String line = br.readLine();

					while (line != null) {
						sb.append(line);
						sb.append(System.lineSeparator());
						line = br.readLine();
					}

					br.close();
					strBeforMHT = sb.toString();
				}

				FileWriter fw = new FileWriter(file);
				fw.append(formMhtInfo);
				fw.close();
			} catch (Exception e) {
				logger.debug(e.getMessage());
				return "ERROR : " + egovMessageSource.getMessage("ezApprovalG.lhj03", userInfo.getLocale()) + e.getMessage();
			}
		}

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PFORMCONTAINERID", contID);
		map.put("v_PYEAR", commonUtil.getTodayUTCTime("YYYY"));
		map.put("v_PFORMNAME", formName);
		map.put("v_PFORMNAME2", formName2);
		map.put("v_PFORMDESCRIPT", formDescript);
		map.put("v_PFORMKIND", formKind);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PFORMCONNFLAG", formConnFlag);
		map.put("companyID", companyID);
		map.put("tenantID", userInfo.getTenantId());

		String result = "";
		
		try {
			if (formID.equals("")) {
				logger.debug("setFormDataSelect started.");
				result = ezApprovalGAdminDAO.setFormDataSelect(map);
				logger.debug("setFormDataSelect ended.");
				
				if (result == null) {
					result = commonUtil.getTodayUTCTime("YYYY") + "000001";
				} else {
					if ( result.substring(0,4).equals(commonUtil.getTodayUTCTime("YYYY"))) {
						result = Integer.toString((Integer.parseInt(result) + 1));
					} else {
						result = commonUtil.getTodayUTCTime("YYYY") + "000001";
					}
				}
				
				map.put("v_PURL", path + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + result + ".mht");
				map.put("v_PID", result);
				
				logger.debug("setFormDataInsert1 started.");
				ezApprovalGAdminDAO.setFormDataInsert1(map);
				logger.debug("setFormDataInsert1 ended.");
			} else {
				map.put("v_PFORMID", formID);
				map.put("v_PURL", path + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + formID + ".mht");
				
				logger.debug("setFormDataUpdate started.");
				ezApprovalGAdminDAO.setFormDataUpdate(map);
				logger.debug("setFormDataUpdate ended.");
			}
			
			logger.debug("recevGroupXML=" + recevGroupXML);
			
			if (!recevGroupXML.equals("")) {
				map = new HashMap<String, Object>();
				map.put("v_PFORMID", result);
				map.put("companyID", companyID);
				map.put("tenantID", userInfo.getTenantId());
				
				logger.debug("setFormDataDelete started..");
				ezApprovalGAdminDAO.setFormDataDelete(map);
				logger.debug("setFormDataDelete ended.");
				
				doc = commonUtil.convertStringToDocument(recevGroupXML);
				
				for (int i=0; i < doc.getElementsByTagName("DATA").getLength(); i++) {
					map.put("deptID", doc.getElementsByTagName("DEPTID").item(0).getTextContent());
					map.put("deptSN", doc.getElementsByTagName("DEPTSN").item(0).getTextContent());
					
					logger.debug("setFormDataInsert2 started.");
					ezApprovalGAdminDAO.setFormDataInsert2(map);
					logger.debug("setFormDataInsert2 ended.");
				}
			}
			
			if (result.equals("") || result.indexOf("ERROR") > 0) {
				if (isUpdate) {
					String saveFileDir = realPath + path + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator;
					saveFileName = realPath + path + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + formID + ".mht";
					
					FileWriter fw = null;
					
					try {
						if (!new File(saveFileDir).exists()) {
							new File(saveFileDir).mkdirs();
						}
						
						File file = new File(saveFileName);
						fw = new FileWriter(file);
						fw.append(formMhtInfo);
					} catch (Exception e) {
						logger.debug(e.getMessage());
					} finally {
						fw.close();
					}
				}
				
				result = "ERROR";
			} else {
				if (formID.equals("") && !isUpdate) {
					formID = result;
					
					if (!formMhtInfo.equals("")) {
						String saveFileDir = realPath + path + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator;
						saveFileName = realPath + path + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + formID + ".mht";
						
						FileWriter fw = null;
						
						try {
							if (!new File(saveFileDir).exists()) {
								new File(saveFileDir).mkdirs();
							}
							
							File file = new File(saveFileName);
							fw = new FileWriter(file);
							fw.append(formMhtInfo);
						} catch(Exception e) {
							logger.debug(e.getMessage());
						} finally {
							fw.close();
						}
					}
				}
			}
			
			logger.debug("setFormDataInsert,Update ended.");
			logger.debug("saveFormInfo ended.");
			
			return result;
		} catch (Exception e) {
			logger.debug("saveFormInfo catch.");
			logger.debug(e.getMessage());
			
			return "";
		}
	}

	@Override
	public String setContainerIDForDoc1(String deptID, String containerType, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CONTTYPEID", containerType);
		map.put("v_DEPTID", deptID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		logger.debug("setContainerIDForDoc1 started.");
		String result = ezApprovalGAdminDAO.setContainerIDForDoc1(map);
		logger.debug("setContainerIDForDoc1 ended.");
		
		return result;
	}

	@Override
	public String setContainerIDForDoc2(String docID, String containerID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_CONTID", containerID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			logger.debug("setContainerIDForDoc2 started.");
			ezApprovalGAdminDAO.setContainerIDForDoc2(map);
			logger.debug("setContainerIDForDoc2 ended.");
			
			return "OK";
		} catch (Exception e) {
			logger.debug("setContainerIDForDoc2 catch.");
			logger.debug(e.getMessage());
			
			return "ERROR";
		}
	}

	
}
