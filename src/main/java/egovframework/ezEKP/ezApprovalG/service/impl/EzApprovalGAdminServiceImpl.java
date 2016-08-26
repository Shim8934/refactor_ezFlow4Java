package egovframework.ezEKP.ezApprovalG.service.impl;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

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
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

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

	@Override
	public String getContainerInfoManage(String deptID, String type, String companyID, String lang) throws Exception {
		try {
			StringBuilder sb = new StringBuilder();

			if (!companyID.toUpperCase().equals("TOP")) {
				Map<String, Object> map1 = new HashMap<String, Object>();		
				map1.put("v_DEPTID", deptID);
				map1.put("companyID", companyID);
				
				List<ApprGLeftVO> listBody = ezApprovalGAdminDAO.getContainerInfoManage(map1);
				
				String strMultiData = commonUtil.getMultiData(lang);
				
				if (type.equals("LIST")){
					Map<String, Object> map = new HashMap<String, Object>();
					
					map.put("v_LISTTYPE", "106");
					map.put("v_LANGTYPE", lang);
					map.put("companyID", companyID);
					
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
			return sb.toString();
		} catch (Exception e) {
			if (type.equals("LIST")){
				return "<LISTVIEWDATA><HEADERS><HEADERS><ROWS></ROWS></LISTVIEWDATA>";
			}else{
				return "<PARAMETER></PARAMETER>";
			}		
		}
		
	}

	@Override
	public String getContTypeInfo(String type, String companyID, String lang) throws Exception {
		StringBuilder sb = new StringBuilder();
		String strMultiData = commonUtil.getMultiData(lang);
		
		List<ApprGLeftVO> list = ezApprovalGAdminDAO.getContTypeInfo(companyID);
		
		if (type.equals("LIST")) {
			sb.append("<LISTVIEWDATA><HEADERS><HEADER>");
			sb.append("<NAME>" + ezApprovalGService.getCode2Name("L02", "001", companyID, lang) + "</NAME><WIDTH>250</WIDTH></HEADER></HEADERS><ROWS>");
			
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
		return sb.toString();
	}

	@Override
	public String deleteContainerType(String docTypeID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CONTTYPEID", docTypeID);		
		map.put("companyID", companyID);
				
		return ezApprovalGAdminDAO.deleteContainerType(map);
	}

	@Override
	public void insertContainerType(String docTypeName, String docTypeName2, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CONTTYPENAME", docTypeName);
		map.put("v_CONTTYPENAME2", docTypeName2);
		map.put("companyID", companyID);
		
		ezApprovalGAdminDAO.insertContainerType(map);
	}

	@Override
	public String getContainerToDocStateInfo(String companyID, String lang) throws Exception {
		String strMultiData = commonUtil.getMultiData(lang);
		
		StringBuilder sb = new StringBuilder();		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_LISTTYPE", "111");
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		
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
		
		List<ApprGDocStateVO> listBody = ezApprovalGAdminDAO.getContainerToDocStateInfo(map);
		
		for (int i = 0; i < listBody.size(); i++) {
			ApprGDocStateVO vo = listBody.get(i);
			
			Field field = vo.getClass().getDeclaredField("documentStateName" + commonUtil.getLangData(lang));
	    	field.setAccessible(true);

			sb.append("<ROW>");			
			sb.append("<CELL><VALUE>" + commonUtil.cleanValue(String.valueOf(field.get(vo))) + "</VALUE>");
			sb.append("<DATA1>" + vo.getDocumentState() + "</DATA1></CELL>");			
						
			if (strMultiData.equals("")) {
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getContainerTypeName()) + "</VALUE>");
			} else {
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getContainerTypeName2()) + "</VALUE>");
			}			
			sb.append("<DATA1>" + vo.getContainerTypeID().trim() + "</DATA1></CELL>");
			sb.append("</ROW>");
		}
		sb.append("</ROWS></LISTVIEWDATA>");
		
		return sb.toString();
	}

	@Override
	public String updateContainerToDocStateInfo(Document xmlData, String companyID) throws Exception {
		NodeList docData = xmlData.getElementsByTagName("CONTTYPE");
		
		try {
			if (docData != null && docData.getLength() > 0) {
				ezApprovalGAdminDAO.deleteContainerDocState(companyID);
				
				for (int i = 0; i < docData.getLength(); i++) {
					String data1 = docData.item(i).getChildNodes().item(1).getTextContent();
					String data2 = docData.item(i).getChildNodes().item(0).getTextContent();
					
					Map<String, Object> map = new HashMap<String, Object>();
					
					map.put("data1", data1.trim());
					map.put("data2", data2.trim());
					map.put("companyID", companyID);
					
					ezApprovalGAdminDAO.insertContainerDocState(map);
				}				
			}
			return "TRUE";
		} catch(Exception e) {			
			return "FALSE";
		}
	}

	@Override
	public String getContainerUseDeptInfo(String contID, String companyID, String lang) throws Exception {
		StringBuilder sb = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();		
		
		map.put("v_CONTID", contID);		
		map.put("companyID", companyID);
		
		String strMultiData = commonUtil.getMultiData(lang);
		
		try {
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
		} catch(Exception e) {
			sb.append("<PARAMETER><ID0>FALSE</ID0><NAME0></NAME0></PARAMETER>");
		}
		
		return sb.toString();
	}

	@Override
	public String insertContainer(Document xmlData, String companyID)	throws Exception {
		try {
			String pMaxContainerID = ezApprovalGAdminDAO.insertContainerContID(companyID);
			
			int tempMaxContainerID = Integer.parseInt(pMaxContainerID.trim()) + 1;
	        pMaxContainerID = tempMaxContainerID + "";
	        int pMaxContainerIDLength = pMaxContainerID.length();
	        int i;
	
	        for (i = 0; i < (10 - pMaxContainerIDLength); i++) {
	            pMaxContainerID = "0" + pMaxContainerID;
	        }
	
			String pContType = xmlData.getDocumentElement().getChildNodes().item(0).getTextContent().trim();
			String pOwnDeptID = xmlData.getDocumentElement().getChildNodes().item(1).getTextContent().trim();
			
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("contID", pMaxContainerID);		
			map.put("contType", pContType);		
			map.put("deptID", pOwnDeptID);		
			map.put("companyID", companyID);
			//문서함 등록 함수
			ezApprovalGAdminDAO.insertContainer(map);
			
			pMaxContainerIDLength = xmlData.getDocumentElement().getChildNodes().getLength();
	
			if (pMaxContainerIDLength > 2) {
			    for (i = 2; i < pMaxContainerIDLength - 1; i++) {
			    	Map<String, Object> map1 = new HashMap<String, Object>();
					
					map1.put("contID", pMaxContainerID);		
					map1.put("deptID", xmlData.getDocumentElement().getChildNodes().item(i).getTextContent().trim());
					map1.put("companyID", companyID);
					//문서함 공유부서 등록 함수	
			    	ezApprovalGAdminDAO.insertContainerUseDep(map1);		        
			    }
			}
			return "TRUE";
		} catch (Exception e) {
			return "FALSE";
		}
	}

	@Override
	public String updateContainer(Document xmlData, String companyID) throws Exception {
		String pContID = xmlData.getDocumentElement().getChildNodes().item(0).getTextContent().trim();
		String pContType = xmlData.getDocumentElement().getChildNodes().item(1).getTextContent().trim();
		String pOwnDeptID = xmlData.getDocumentElement().getChildNodes().item(2).getTextContent().trim();
				
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("contID", pContID);		
			map.put("contType", pContType);		
			map.put("deptID", pOwnDeptID);		
			map.put("companyID", companyID);
	
			//문서함 수정 함수
			ezApprovalGAdminDAO.updateContainer(map);
			//문서함 공유부서 삭제 함수
			ezApprovalGAdminDAO.deleteContainerUseDep(map);
			
			int cnt = xmlData.getDocumentElement().getChildNodes().getLength();		
		
		    for (int i = 3; i < cnt - 1; i++) {
		    	Map<String, Object> map1 = new HashMap<String, Object>();
				
				map1.put("contID", pContID);		
				map1.put("deptID", xmlData.getDocumentElement().getChildNodes().item(i).getTextContent().trim());
				map1.put("companyID", companyID);
				//문서함 공유부서 등록 함수
		    	ezApprovalGAdminDAO.insertContainerUseDep(map1);
		    }
		    return "TRUE";
		} catch (Exception e) {
			return "FALSE";
		}
	}

	@Override
	public String deleteContainer(String contID, String companyID) throws Exception {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("v_CONTID", contID);
			map.put("companyID", companyID);
	
			//문서함 삭제 함수
			ezApprovalGAdminDAO.deleteContainer(map);
			
			return "TRUE";
		} catch (Exception e) {
			return "FALSE";
		}		
	}

	@Override
	public String getReceiveGroupInfo(String pid, String mode, String companyID, String lang) throws Exception {
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
			
			List<ApprGListHeaderVO> listHeader = ezApprovalGDAO.getListHeader(map);
			
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
			
			List<ApprGAdminReceiveVO> listBody = ezApprovalGAdminDAO.getReceiveGroupInfo(map1);
			
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
					sb.append("<CELL><VALUE>" + ezApprovalGService.getListField(fieldName, fieldValue, companyID, lang) + "</VALUE>");
					
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
	public String insertReceiveGroupItemInfo(String groupID, String deptID,	String deptName, String deptName2, String pCompanyID, String companyID) throws Exception {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("v_MAINID", groupID);
			map.put("v_DEPTID", deptID);
			map.put("v_DEPTNAME", deptName);
			map.put("v_DEPTNAME2", deptName2);
			map.put("v_COMPANYID", pCompanyID);
			map.put("companyID", companyID);
			
			ezApprovalGAdminDAO.insertReceiveGroupItemInfo(map);
			
			return "TRUE";
		} catch (Exception e) {
			return "FALSE";			
		}
	}

	@Override
	public String deleteReceiveGroupItemInfo(String groupID, String companyID) throws Exception {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("v_SUBID", groupID);
			map.put("companyID", companyID);
			
			ezApprovalGAdminDAO.deleteReceiveGroupItemInfo(map);
			
			return "TRUE";
		} catch (Exception e) {
			return "FALSE";			
		}
	}

	@Override
	public String updateReceiveGroupInfo(String groupID, String groupName, String companyID) throws Exception {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("v_MAINID", groupID);
			map.put("v_MAINNAME", groupName);
			map.put("companyID", companyID);
			
			ezApprovalGAdminDAO.updateReceiveGroupInfo(map);
			
			return "TRUE";
		} catch (Exception e) {
			return "FALSE";			
		}
	}

	@Override
	public String insertReceiveGroupInfo(String groupName, String companyID) throws Exception{
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("v_MAINNAME", groupName);
			map.put("companyID", companyID);
			
			ezApprovalGAdminDAO.insertReceiveGroupInfo(map);
			
			return "TRUE";
		} catch (Exception e) {
			return "FALSE";			
		}
	}

	@Override
	public String deleteReceiveGroupInfo(String groupID, String companyID) throws Exception {
		try {
			Map<String, Object> map = new HashMap<String, Object>();

			map.put("v_MAINID", groupID);
			map.put("companyID", companyID);
			
			ezApprovalGAdminDAO.deleteReceiveGroupInfo(map);
			
			return "TRUE";
		} catch (Exception e) {
			return "FALSE";			
		}
	}

	@Override
	public String getTaskCategoryTree(String categoryType, String parentID, String companyID) throws Exception {
		try {
			StringBuilder sb = new StringBuilder();
			String isLeaf = "FALSE";
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_CATETYPE", categoryType);
			map.put("v_PARENTID", parentID);
			map.put("companyID", companyID);
			
			List<ApprGTaskVO> list = ezApprovalGAdminDAO.getTaskCategotyTree(map);
			sb.append("<NODES>");
			
			for (ApprGTaskVO vo : list) {
				switch (vo.getCategoryType()) {
					case "1":
						isLeaf = getTaskCategoryNodeExist(vo.getCategoryType(), vo.getCategoryCode(), companyID);
						break;
					case "2":
						isLeaf = getTaskCategoryNodeExist(vo.getCategoryType(), vo.getMcategoryCode(), companyID);
						break;
					case "3":
						isLeaf = getTaskCategoryNodeExist(vo.getCategoryType(), vo.getSubCategoryCode(), companyID);
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
			
			return sb.toString();
		} catch (Exception e) {
			return "<NODES></NODES>";
		}
	}

	@Override
	public String getTaskInSubCategoryForManage(Document doc) throws Exception {
		StringBuffer sb = new StringBuffer();
		String companyID = doc.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String pSCateCode = doc.getElementsByTagName("SCATECODE").item(0).getTextContent();
		String langType = doc.getElementsByTagName("LANGTYPE").item(0).getTextContent();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SUBCATECODE", pSCateCode);
		map.put("companyID", companyID);
		
		List<ApprGTaskVO> list = ezApprovalGAdminDAO.getTaskInSubCategoryForManage(map);
        sb.append("<DATA>");
        
        for (ApprGTaskVO vo : list) {
        	sb.append(commonUtil.getQueryResult(vo));
        }
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		String result = ezApprovalGService.makeTaskListXml(docXML, companyID, langType);
		
		return result;
	}

	@Override
	public String getTaskCategoryDuplicate(String categoryType, String categoryCode, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CATETYPE", categoryType);
		map.put("v_CATECODE", categoryCode);
		map.put("companyID", companyID);
		
		try {
			Integer result = ezApprovalGAdminDAO.getTaskCategoryDuplicate(map);
			
			if (result > 0) {
				return "TRUE";
			} else {
				return "FALSE";
			}
		} catch (Exception e) {
			return "FALSE";
		}
	}

	@Override
	public String setTaskCategory(String categoryType, String categoryCode, String categoryName, String categoryName2, String categoryDesc, String pCode, String companyID) throws Exception {
		try {
			String duplicate = getTaskCategoryDuplicate(categoryType, categoryCode, companyID);
			
			Map<String, Object> map = new HashMap<String, Object>();
			
			if (duplicate.equals("TRUE")) {
				map.put("v_MODE", "U");
			} else {
				map.put("v_MODE", "I");
			}
			map.put("v_CATETYPE", categoryType);
			map.put("v_CATECODE", categoryCode);
			map.put("v_NAME", categoryName);
			map.put("v_NAME2", categoryName2);
			map.put("v_DESC", categoryDesc);
			map.put("v_CODE", pCode);
			map.put("companyID", companyID);
			
			ezApprovalGAdminDAO.setTaskCategory(map);
		
			return "TRUE";
		} catch (Exception e) {
			return "FALSE";			
		}
	}

	@Override
	public String getTaskCategoryNodeExist(String categoryType, String categoryCode, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CATETYPE", categoryType);
		map.put("v_CATECODE", categoryCode);
		map.put("companyID", companyID);
		
		try {
			Integer result = ezApprovalGAdminDAO.getTaskCategoryNodeExist(map);
			
			if (result > 0) {
				return "TRUE";
			} else {
				return "FALSE";
			}
		} catch (Exception e) {
			return "FALSE";
		}
	}

	@Override
	public String removeTaskCategory(String categoryType, String categoryCode, String companyID) throws Exception {
		try{
			String duplicate = getTaskCategoryNodeExist(categoryType, categoryCode, companyID);
			
			if (duplicate.equals("TRUE")) {
				return "EXIST";
			} else {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("v_CATETYPE", categoryType);
				map.put("v_CATECODE", categoryCode);
				map.put("companyID", companyID);
				
				ezApprovalGAdminDAO.removeTaskCategory(map);
				
				return "TRUE";
			}
		} catch (Exception e){
			return "FALSE";
		}
		
	}

	@Override
	public String getTaskCodeDuplicate(String taskCode, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TASKCODE", taskCode);
		map.put("companyID", companyID);
		
		try {
			Integer result = ezApprovalGAdminDAO.getTaskCodeDuplicate(map);
			
			if (result > 0) {
				return "TRUE";
			} else {
				return "FALSE";
			}
		} catch (Exception e) {
			return "FALSE";
		}
	}

	@Override
	public String getTaskInfo(String pTaskCode, String pDeptCode, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DEPTCODE", pDeptCode);
		map.put("v_TASKCODE", pTaskCode);
		map.put("companyID", companyID);
		
		try {
			List<ApprGTaskVO> list = ezApprovalGAdminDAO.getTaskInfo(map);
	
			if (list.get(0) == null) {
				return "<RESULT>NOITEM</RESULT>";
			}
			
			String result = commonUtil.getQueryResult(list.get(0));
			
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			return "<RESULT>FLASE</RESULT>";
		}
	}

	//TODO 다국어가 영어로 고정되어 있음.
	@Override
	public String setTaskCode(ApprGTaskVO vo, String companyID) throws Exception {
		try {
			if (getTaskCodeDuplicate(vo.getTaskCode(), companyID).equals("TRUE")) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("v_TASKCODE", vo.getTaskCode());
				map.put("companyID", companyID);
				
				ApprGTaskVO item = ezApprovalGAdminDAO.getTaskCode(map);
				
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
                        String subSQL = setTaskHistory(vo.getTaskCode(), vo.getTaskName(), vo.getTaskName2(), NAMEDESC[i], NAMEDESC2[i], docXML.getElementsByTagName(NAMETYPE[i]).item(0).getTextContent().trim(), objParam.getElementsByTagName(NAMETYPE[i]).item(0).getTextContent().trim(), objParam.getElementsByTagName(NAMETYPE[i]).item(0).getTextContent().trim(), companyID);
                        
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
                
                ezApprovalGAdminDAO.updateTaskCode(map1);
			} else {
				String subSQL = setTaskHistory(vo.getTaskCode(), vo.getTaskName(), vo.getTaskName2(), "신규생성", "New creation", "", "", "", companyID);
				
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
                map2.put("v_CREATIONDATE", EgovDateUtil.getCurrentDate("-"));
                map2.put("companyID", companyID);
               
                ezApprovalGAdminDAO.insertTaskCode(map2);
			}
			return "TRUE";
		} catch (Exception e) {
			return "FALSE";
		}
	}
	
	@Override
	public String getTaskCodeNodeExist(String taskCode, String deptID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TASKCODE", taskCode);
		map.put("v_DEPTID", deptID);
		map.put("companyID", companyID);
		
		try {
			Integer result = ezApprovalGAdminDAO.getTaskCodeNodeExist(map);
			
			if (result > 0) {
				return "TRUE";
			} else {
				return "FALSE";
			}
		} catch (Exception e) {
			return "FALSE";
		}
	}

	@Override
	public String removeTaskCode(String taskCode, String companyID) throws Exception {
		try {
			String tempFlag = getTaskCodeNodeExist(taskCode, "", companyID);
			
			if (tempFlag.equals("TRUE")) {
				return "EXIST";
			} else {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("v_TASKCODE", taskCode);
				map.put("companyID", companyID);
				
				ApprGTaskVO vo = ezApprovalGAdminDAO.getTaskName(map);
				
				String temp = setTaskHistory(taskCode, vo.getTaskName(), vo.getTaskName2(), "삭제", "Deleted", "", "", "", companyID);
				
				if (temp.equals("FALSE")) {
					return "FALSE";
				}
				
				Map<String, Object> map1 = new HashMap<String, Object>();
				map1.put("taskCode", taskCode);
				map1.put("now", EgovDateUtil.getCurrentDate("-"));
				map1.put("companyID", companyID);
				
				ezApprovalGAdminDAO.removeTaskCode(map1);
				
				return "TRUE";
			}
		} catch (Exception e) {
			return "FALSE";
		}
	}

	@Override
	public String getTaskCodeDeptInfo(String taskCode, String companyID, String lang) throws Exception {
		StringBuilder sb = new StringBuilder();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", "102");
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		
		List<ApprGListHeaderVO> listHeader = ezApprovalGDAO.getListHeader(map);
		
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
		
		return sb.toString();
	}

	@Override
	public String addTaskCodeDeptInfo(String taskCode, String deptCode, String deptName, String deptName2, String companyID) throws Exception {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_TASKCODE", taskCode);
			map.put("companyID", companyID);
			
			ApprGTaskVO vo = ezApprovalGAdminDAO.getTaskName(map);
			
			String temp = setTaskHistory(taskCode, vo.getTaskName(), vo.getTaskName2(), "사용부서지정", "Designates the Dept", deptCode, deptName, deptName2, companyID);
			
			if (temp.equals("FALSE")) {
				return "FALSE";
			}
			
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("v_TASKCODE", taskCode);
			map1.put("v_DEPTCODE", deptCode);
			map1.put("v_pCount", 0);
			map1.put("companyID", companyID);
			
			Integer tempCount = ezApprovalGAdminDAO.getTaskCodeDeptCnt(map1);

			Map<String, Object> map2 = new HashMap<String, Object>();
			map2.put("taskCode", taskCode);
			map2.put("deptCode", deptCode);
			map2.put("deptName", deptName);
			map2.put("deptName2", deptName2);
			map2.put("companyID", companyID);
			
			if (tempCount > 0){
				ezApprovalGAdminDAO.updateDeptInfo(map2);
			} else {
				ezApprovalGAdminDAO.insertDeptInfo(map2);
			}
			
			return "TRUE";
		} catch(Exception e) {
			return "FALSE";
		}
	}

	@Override
	public String removeTaskCodeDeptInfo(String taskCode, String deptCode, String deptName, String deptName2, String companyID) throws Exception {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_TASKCODE", taskCode);
			map.put("companyID", companyID);
			
			ApprGTaskVO vo = ezApprovalGAdminDAO.getTaskName(map);
			
			String temp = setTaskHistory(taskCode, vo.getTaskName(), vo.getTaskName2(), "사용부서삭제", "Delete the dept", deptCode, deptName, deptName2, companyID);
			
			if (temp.equals("FALSE")) {
				return "FALSE";
			}
			
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("taskCode", taskCode);
			map1.put("deptCode", deptCode);
			map1.put("companyID", companyID);
			
			ezApprovalGAdminDAO.removeDeptInfo(map1);
			
			return "TRUE";
		} catch(Exception e) {
			return "FALSE";
		}
	}
	
	@Override
	public String getTaskHistory(String taskCode, String companyID, String lang) throws Exception {
		StringBuilder sb = new StringBuilder();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", "093");
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		
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
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_TASKCODE", taskCode);
		map1.put("v_LANGTYPE", lang);
		map1.put("companyID", companyID);
		
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
				sb.append("<CELL><VALUE>" + ezApprovalGService.getListField(fieldName, fieldValue, companyID, lang) + "</VALUE></CELL>");
			}
			sb.append("</ROW>");
		}
		sb.append("</ROWS></LISTVIEWDATA>");
		
		return sb.toString();
	}
	
	@Override
	public String getTaskFullList(String deptCode, String pageSize, String pageNo, String langType, String companyID) throws Exception {
		try {
			StringBuilder sb = new StringBuilder();
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_DEPTCODE", deptCode);
			map.put("companyID", companyID);

			List<ApprGTaskVO> list = ezApprovalGAdminDAO.getTaskFullList(map);
			
			sb.append("<DATA>");
			
			for (ApprGTaskVO vo : list) {
				sb.append(commonUtil.getQueryResult(vo));
			}
			sb.append("</DATA>");
			
			String result = ezApprovalGService.makeTaskFullListXml(commonUtil.convertStringToDocument(sb.toString()), companyID, pageSize, pageNo, langType);
			
			return result;
		} catch (Exception e) {
			return "<RESULT>FALSE</RESULT>";
		}
	}

	@Override
	public String getSealList(String listFlag, String companyID, String lang) throws Exception {
		StringBuilder sb = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTFLAG", listFlag);
		map.put("v_PMULTIDATA", lang);
		map.put("companyID", companyID);
		
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
			sb.append("<CELL><VALUE>" + vo.getRegDate() + "</VALUE></CELL>");
			
			if (vo.getDelDate() == null) {
				sb.append("<CELL><VALUE>" + " " + "</VALUE></CELL>");
			} else {
				sb.append("<CELL><VALUE>" + vo.getDelDate() + "</VALUE></CELL>");
			}
			
			sb.append("<CELL><VALUE>" + vo.getRegUserName() + "</VALUE></CELL>");
			sb.append("</ROW>");
		}
		
		sb.append("</ROWS>");

		return sb.toString();
	}

	@Override
	public String sealDelete(String realPath, String dirPath, String fileName) throws Exception{
		try {
			deleteFile(realPath + dirPath + fileName);
			
			return "TRUE";
		} catch(Exception e) {
			return "FALSE";
		}
	}

	@Override
	public String deleteSealInfo(String pSealNum, String companyID) throws Exception {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_SEALNUM", pSealNum);
			map.put("companyID", companyID);
			
			ezApprovalGAdminDAO.deleteSealInfo(map);
			
			return "TRUE";
		} catch (Exception e) {
			return "FALSE";
		}
	}
	
	@Override
	public String insertSealInfo(String pSealNum, String pSealName, String pSealPath, String pSealWidth, String pSealHeight, String pRegUserID, String pRegUserName, String pRegUserName2, String companyID) throws Exception {
		try{
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_SEALNUM", pSealNum);
			map.put("v_SEALNAME", pSealName);
			map.put("v_SEALPATH", pSealPath);
			map.put("v_SEALWIDTH", pSealWidth);
			map.put("v_SEALHEIGHT", pSealHeight);
			map.put("v_REGUSERID", pRegUserID);
			map.put("v_REGUSERNAME", pRegUserName);
			map.put("v_REGUSERNAME2", pRegUserName2);
			map.put("companyID", companyID);
			
			ezApprovalGAdminDAO.insertSealInfo(map);
			
			return "TRUE";
		} catch (Exception e) {
			return "FALSE";
		}
	}

	@Override
	public String getSealDeptlList(String listFlag, String deptID, String companyID, String lang) throws Exception {
		StringBuilder sb = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTFLAG", listFlag);
		map.put("v_DEPTID", deptID);
		map.put("companyID", companyID);
		
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
			sb.append("<CELL><VALUE>" + vo.getRegDate() + "</VALUE></CELL>");
			sb.append("<CELL><VALUE>" + vo.getDelDate() + "</VALUE></CELL>");

			if (lang.equals("1")) {
				sb.append("<CELL><VALUE>" + vo.getRegUserName() + "</VALUE></CELL>");
			} else if (lang.equals("2")) {
				sb.append("<CELL><VALUE>" + vo.getRegUserName2() + "</VALUE></CELL>");
			}
			
			sb.append("</ROW>");
		}
		
		sb.append("</ROWS>");

		return sb.toString();
	}
	
	@Override
	public String insertDeptSealInfo(String pSealNum, String pSealName, String pSealPath, String pSealWidth, String pSealHeight, String pRegUserID, String pRegUserName, String pRegUserName2, String deptID, String companyID) throws Exception {
		try{
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
			
			ezApprovalGAdminDAO.insertDeptSealInfo(map);
			
			return "TRUE";
		} catch (Exception e) {
			return "FALSE";
		}	
	}
	
	@Override
	public String deleteDeptSealInfo(String pSealNum, String deptID, String companyID) throws Exception {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_SEALNUM", pSealNum);
			map.put("v_DEPTID", deptID);
			map.put("companyID", companyID);
			
			ezApprovalGAdminDAO.deleteDeptSealInfo(map);
			
			return "TRUE";
		} catch (Exception e) {
			return "FALSE";
		}
	}

	@Override
	public String getDeptTranSendDocCount(String sYear, String sMonth, String eYear, String eMonth, String pMode, String companyID, String lang) throws Exception {
		StringBuilder sb = new StringBuilder();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", "108");
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		
		List<ApprGListHeaderVO> listHeader = ezApprovalGDAO.getListHeader(map);
		
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
		
		String szFrom = sYear + "-" + sMonth;
		String szTo = eYear + "-" + eMonth;
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_MODE", pMode);
		map1.put("v_FROM", szFrom);
		map1.put("v_TO", szTo);
		map1.put("v_LANGTYPE", lang);
		map1.put("companyID", companyID);
		
		List<ApprGReceiveDocVO> list = ezApprovalGAdminDAO.getDeptTranSendDocCount(map1);
		
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
	public String getUserDocCount(String sYear, String sMonth, String eYear, String eMonth, String userFlag, String companyID, String lang) throws Exception {
		StringBuilder sb = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", "107");
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		
		List<ApprGListHeaderVO> listHeader = ezApprovalGDAO.getListHeader(map);
		
		sb.append("<LISTVIEWDATA><HEADERS>");
		
		for (int i = 0; i < listHeader.size(); i++) {
			ApprGListHeaderVO vo = listHeader.get(i);
			
			sb.append("<HEADER>");
			
			if (vo.getName().equals(egovMessageSource.getMessage("ezApprovalG.t445", new Locale(globals.getProperty("Globals.language"))))) {
				switch (userFlag) {
				case "1":
					vo.setName(egovMessageSource.getMessage("ezApprovalG.t445", new Locale(globals.getProperty("Globals.language"))));
					break;
				case "2":
					vo.setName(egovMessageSource.getMessage("ezApprovalG.t1304", new Locale(globals.getProperty("Globals.language"))));
					break;
				case "3":
					vo.setName(egovMessageSource.getMessage("ezApprovalG.t1305", new Locale(globals.getProperty("Globals.language"))));
					break;
				case "4":
					vo.setName(egovMessageSource.getMessage("ezApprovalG.t1306", new Locale(globals.getProperty("Globals.language"))));
					break;
				default:
					vo.setName(egovMessageSource.getMessage("ezApprovalG.t445", new Locale(globals.getProperty("Globals.language"))));
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
			aprType = "'018'";
			break;
		case "2":
			aprType = "'019'";
			break;
		case "3":
			aprType = "'008', '009', '011', '012'";
			break;
		case "4":
			aprType = "'001', '004', '016'";
			break;
		}
		
		String szFrom = sYear + "-" + sMonth;
		String szTo = eYear + "-" + eMonth;
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_APRTYPE", aprType);
		map1.put("v_FROM", szFrom);
		map1.put("v_TO", szTo);
		map1.put("v_STRLANG", commonUtil.getMultiData(lang));
		map1.put("companyID", companyID);
		
		List<ApprGAprLineVO> list = ezApprovalGAdminDAO.getUserDocCount(map1);
		
		for (ApprGAprLineVO vo : list) {
			sb.append("<ROW>");
			if (lang.equals("1")) {
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
			String orderCell, String orderOption, String companyID, String lang, String approvUser)
			throws Exception {
		String orderOption1 = "";
		String orderOption2 = "";
		StringBuilder sb = new StringBuilder();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", "081");
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		
		List<ApprGListHeaderVO> listHeader = ezApprovalGDAO.getListHeader(map);
		
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
		map1.put("v_STARTDATE1", makeDate(draftFromYear, draftFromMonth, draftFromDay, true));
		map1.put("v_STARTDATE2", makeDate(draftToYear, draftToMonth, draftToDay, false));
		map1.put("v_ENDDATE1", makeDate(apprFromYear, apprFromMonth, apprFromDay, true));
		map1.put("v_ENDDATE2", makeDate(apprToYear, apprToMonth, apprToDay, false));
		map1.put("v_LANGTYPE", commonUtil.getMultiData(lang));
		map1.put("v_APPROVUSER", approvUser);
		map1.put("companyID", companyID);
		
		Integer totalCount = ezApprovalGAdminDAO.searchManageAprDocListCount(map1);
		
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
		map2.put("v_STARTDATE1", makeDate(draftFromYear, draftFromMonth, draftFromDay, true));
		map2.put("v_STARTDATE2", makeDate(draftToYear, draftToMonth, draftToDay, false));
		map2.put("v_ENDDATE1", makeDate(apprFromYear, apprFromMonth, apprFromDay, true));
		map2.put("v_ENDDATE2", makeDate(apprToYear, apprToMonth, apprToDay, false));
		map2.put("v_LANGTYPE", commonUtil.getMultiData(lang));
		map2.put("v_APPROVUSER", approvUser);
		map2.put("companyID", companyID);
		
		List<ApprGAprDocInfoVO> listBody = ezApprovalGAdminDAO.searchManageAprDocList(map2);
		
		for(int i = 0; i < listBody.size(); i ++) {
			ApprGAprDocInfoVO bodyVo = listBody.get(i);
			sb.append("<ROW>");
			
			for (int j = 0; j < listHeader.size(); j++) {
				ApprGListHeaderVO headerVo = listHeader.get(j);				
				String fieldName = headerVo.getColName();
				String fieldValue = "";

				if (fieldName.toUpperCase().equals("WRITERNAME") || fieldName.toUpperCase().equals("WRITERDEPTNAME") || fieldName.toUpperCase().equals("FORMNAME")){
					fieldName = fieldName + commonUtil.getMultiData(lang);
				}
				
				for (Field field : bodyVo.getClass().getDeclaredFields()) {
			        field.setAccessible(true);
										
					if (field.getName().toUpperCase().equals(fieldName.toUpperCase())) {
						fieldValue = String.valueOf(field.get(bodyVo));
					}
			    }

				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(ezApprovalGService.getListField(fieldName.toUpperCase(), fieldValue, companyID, lang)) + "</VALUE>");

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
	public String setFormOrder(String formContID, String formIDList, String companyID) throws Exception {
		try {
			int formListCount = formIDList.split(";").length;
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_pFORMIDLIST", formIDList);
			map.put("v_pFORMLISTCOUNT", formListCount);
			map.put("v_pFORMCONTID", formContID);
			map.put("companyID", companyID);
			
			ezApprovalGAdminDAO.setFormOrder(map);
			
			return "OK";
		} catch (Exception e) {
			return "ERROR" + e.getMessage();
		}
	}

	@Override
	public String insertFormContainer(String contName, String contName2, String contDescript, String contParent, String contDept, String deptList, String companyID) throws Exception {
		contParent = (contParent.equals("") ? "ROOT" : contParent);
		contDept = (contDept.equals("") ? " " : contDept);
		
		String contID = ezApprovalGAdminDAO.insertFormContainerConti(companyID);
		contID = (contID == null ? "null" : contID);
		
		if (contID.substring(0,  4).equals(EgovDateUtil.getToday("-").substring(0, 4))) {
			int tempID = Integer.parseInt(contID) + 1;
			contID = Integer.toString(tempID);
		} else {
			contID = EgovDateUtil.getToday("-").substring(0, 4) + "000001";
		}
		
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("contID", contID);
			map.put("contName", contName);
			map.put("contName2", contName2);
			map.put("contDept", contDept);
			map.put("contParent", contParent);
			map.put("contDescript", contDescript);
			map.put("companyID", companyID);
			
			ezApprovalGAdminDAO.insertFormContainer(map);
			
			if (!contDept.equals("ALL")) {
				Map<String, Object> map2 = new HashMap<String, Object>();
				map2.put("contID", contID);
				map2.put("companyID", companyID);
				
				for(String deptID : deptList.split(";")) {
					map2.put("deptID", deptID);
					
					ezApprovalGAdminDAO.insertFormContainerGroup(map2);
				}
			}
			
			return "<PARAMETER><FContID>" + contID + "</FContID></PARAMETER>";
		} catch(Exception e) {
			return "<PARAMETER><FContID>FALSE</FContID></PARAMETER>";
		}
	}

	@Override
	public String getGroupDept(String contID, String lang, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMCONTID", contID);
		map.put("companyID", companyID);
		
		List<ApprGFormVO> list = ezApprovalGAdminDAO.getGroupDept(map);
		
		StringBuilder sb = new StringBuilder();
		sb.append("<PARAMETER>");
		
		for(ApprGFormVO vo : list) {
			sb.append("<ID" + list.indexOf(vo) + ">");
			sb.append(commonUtil.cleanValue(vo.getFormContUserDepID()));
			sb.append("</ID" + list.indexOf(vo) + ">");
			sb.append("<NAME" + list.indexOf(vo) + ">");
			
			if (!lang.equals("2")) {
				sb.append(ezOrganService.getPropertyValue(vo.getFormContUserDepID(), "displayname"));
			} else {
				sb.append(ezOrganService.getPropertyValue(vo.getFormContUserDepID(), "displayname2"));
			}
			
			sb.append("</NAME" + list.indexOf(vo) + ">");
		}
		
		sb.append("</PARAMETER>");
		
		return sb.toString();
	}

	@Override
	public String updateFormContainer(String contName, String contName2, String contDescript, String contParent, String contDept, String contID, String deptList, String companyID) throws Exception {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("contName", contName);
			map.put("contName2", contName2);
			map.put("contDept", contDept);
			map.put("contParent", contParent);
			map.put("contID", contID);
			map.put("contDescript", contDescript);
			map.put("companyID", companyID);
			
			ezApprovalGAdminDAO.updateFormContainer(map);
			
			if (!contDept.equals("ALL")) {
				Map<String, Object> map2 = new HashMap<String, Object>();
				map2.put("contID", contID);
				map2.put("companyID", companyID);
				
				ezApprovalGAdminDAO.deleteFormContUserGroup(map2);
				
				Map<String, Object> map3 = new HashMap<String, Object>();
				map3.put("contID", contID);
				map3.put("companyID", companyID);

				for(String deptID : deptList.split(";")) {
					map3.put("deptID", deptID);

					ezApprovalGAdminDAO.insertFormContainerGroup(map3);
				}
			}
			
			return "<PARAMETER><RTNVALUE>" + contID + "</RTNVALUE></PARAMETER>";
		} catch(Exception e) {
			return "<PARAMETER><RTNVALUE>FALSE</RTNVALUE></PARAMETER>";
		}
	}

	@Override
	public String deleteFormContainer(String contID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMCONTID", contID);
		map.put("companyID", companyID);
		
		try {
			ezApprovalGAdminDAO.deleteFormContainer(map);
			
			return "TRUE";
		} catch (Exception e) {
			return "FALSE";
		}
	}

	@Override
	public String getFormContent(String formID, String lang, String companyID) throws Exception {
		Map<Object, String> map = new HashMap<Object, String>();
		map.put("v_PFORMID", formID);
		map.put("v_PLANG", lang);
		map.put("companyID", companyID);
		
		ApprGFormVO vo = ezApprovalGAdminDAO.getFormContent(map);
		String result = commonUtil.getQueryResult(vo);
		
		return result;
	}

	@Override
	public String delForm(String formID, String companyID, String realPath) throws Exception {
		String result = deleteForm(formID, companyID);
		
		try {
			if (result.equals("TRUE")) {
				deleteFile(realPath + config.getProperty("upload_approvalG.ROOT") + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + formID + ".mht");
			}
			
			return "TRUE";
		} catch (Exception e) {
			return "FALSE";
		}
	}

	@Override
	public String getFormRecvAdmin(String formID, String lang, String companyID) throws Exception {
		StringBuilder sb = new StringBuilder();		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_LISTTYPE", "105");
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		
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
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_FORMID", formID);
		map1.put("companyID", companyID);
		
		List<ApprGFormVO> listBody = ezApprovalGAdminDAO.getFormRecvAdmin(map1);
		
		for (int i = 0; i < listBody.size(); i++) {
			ApprGFormVO bodyVo = listBody.get(i);
			
			for (int j = 0; j < listHeader.size(); j++) {	
				sb.append("<ROW>");
				sb.append("<CELL><VALUE>" + ezOrganService.getPropertyValue(bodyVo.getDeptID(), "DisplayName" + commonUtil.getMultiData(lang)) + "</VALUE>");

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
	public String formSave(Document doc, String realPath, String companyID) throws Exception {
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
			rtnValue = saveFormInfo(contID, formID, formInfo, formConn, formWorkFlow, formRecevGroup, formMht, companyID, realPath);
		}
		
		if (rtnValue.indexOf("ERROR") > 0) {
			return "<DATA>" + rtnValue + "</DATA>";
		} else {
			return "<DATA>OK</DATA>";
		}
	}

	private String setTaskHistory(String taskCode, String taskName, String taskName2, String changeFactor, String changeFactor2, String beforeValue, String afterValue, String afterValue2, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_APPLYDATE", EgovDateUtil.getCurrentDate("-"));
		map.put("v_TASKCODE", taskCode);
		map.put("v_TASKNAME", taskName);
		map.put("v_TASKNAME2", taskName2);
		map.put("v_CHANGEFACTOR", changeFactor);
		map.put("v_CHANGEFACTOR2", changeFactor2);
		map.put("v_BEFOREVALUE", beforeValue);
		map.put("v_AFTERVALUE", afterValue);
		map.put("v_AFTERVALUE2", afterValue2);
		map.put("companyID", companyID);
		
		try {
			ezApprovalGAdminDAO.setTaskHistory(map);
			return "TRUE";
		} catch(Exception e) {
			return "FALSE";
		}
	}
	
	private String makeDate (String year, String month, String day, boolean startFlag) throws Exception {
		String result = "";
		
		if (!year.equals("") && !month.equals("") && !day.equals("")) {
			result = year + "-" + month + "-" + day;
			
			if (startFlag) {
				result += " 00:00:00";
			} else {
				result += " 23:59:59";
			}
		}
		return result;
	}
	
	private String deleteForm(String formID, String companyID) throws Exception {
		Map<Object, String> map = new HashMap<Object, String>();
		map.put("v_FORMID", formID);
		map.put("companyID", companyID);
		
		try {
			ezApprovalGAdminDAO.deleteForm(map);
			
			return "TRUE";
		} catch (Exception e) {
			return "FALSE";
		}
	}
	
	private String saveFormInfo(String contID, String formID, String formInfo, String formConnInfo, String formWorkFlow, String formRecevGroup, String formMhtInfo, String companyID, String realPath) throws Exception {
		String strBeforMHT = "";
		String path = config.getProperty("upload_approvalG.ROOT");
		Document doc = commonUtil.convertStringToDocument(formInfo);
		String formName = doc.getElementsByTagName("FormName").item(0).getTextContent();
		String formName2 = doc.getElementsByTagName("FormName2").item(0).getTextContent();
		String formDescript = doc.getElementsByTagName("FormDescript").item(0).getTextContent();
		String formKind = doc.getElementsByTagName("FormKind").item(0).getTextContent();
		String formConnFlag = doc.getElementsByTagName("ConnFlag").item(0).getTextContent();

		//TODO 연동정보
		String connXML = "";
		if (!formConnInfo.equals("")) {
			doc = commonUtil.convertStringToDocument(formConnInfo);
			connXML = doc.getElementsByTagName("CONNXML").item(0).getTextContent();
		}

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
				return "ERROR : " + egovMessageSource.getMessage("ezApprovalG.lhj03", new Locale(globals.getProperty("Globals.language"))) + e.getMessage();
			}
		}

		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("iv_PFORMID", formID);
			map.put("v_PFORMCONTAINERID", contID);
			map.put("v_PFORMFORMAT", "MHT");
			map.put("v_PYEAR", EgovDateUtil.getTodayTime().substring(0, 4));
			map.put("v_PFORMNAME", formName);
			map.put("v_PFORMNAME2", formName2);
			map.put("v_PFORMDESCRIPT", formDescript);
			map.put("v_PFORMKIND", formKind);
			map.put("v_PCOMPANYID", companyID);
			map.put("v_PFORMRECVGROUPDATA", recevGroupXML);
			map.put("v_PFORMCONNFLAG", formConnFlag);
			map.put("companyID", companyID);

			String result = ezApprovalGAdminDAO.setFormData(map);

			if (result.equals("") || result.indexOf("ERROR") > 0) {
				if (isUpdate) {
					saveFileName = realPath + path + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + formID + ".mht";
					
					File file = new File(saveFileName);
					FileWriter fw = new FileWriter(file);
					fw.append(formMhtInfo);
					fw.close();
				}
				
				result = "ERROR";
			} else {
				if (formID.equals("") && !isUpdate) {
					formID = result;
					
					if (!formMhtInfo.equals("")) {
						saveFileName = realPath + path + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + formID + ".mht";
						
						File file = new File(saveFileName);
						FileWriter fw = new FileWriter(file);
						fw.append(formMhtInfo);
						fw.close();
					}
				}
			}
			return result;
		} catch (Exception e) {
			return "";
		}
	}
}
