package egovframework.ezEKP.ezApprovalG.service.impl;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGAdminDAO;
import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGDAO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGAdminService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAdminReceiveVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocStateVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGListHeaderVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGSealInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskCodeHistoryVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskDeptInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/**
 * @author DC363
 *
 */
@Service("EzApprovalGAdminService")
public class EzApprovalGAdminServiceImpl extends EgovFileMngUtil implements EzApprovalGAdminService{
	
	@Autowired
	private EzApprovalGService ezApprovalGService;
	
	@Autowired
	private EzApprovalGDAO ezApprovalGDAO;
	
	@Autowired
	private EzApprovalGAdminDAO ezApprovalGAdminDAO;
	
	@Autowired
	private CommonUtil commonUtil;

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
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("v_CATETYPE", categoryType);
			map.put("v_PARENTID", parentID);
			map.put("companyID", companyID);
			
			List<ApprGTaskVO> list = ezApprovalGAdminDAO.getTaskCategotyTree(map);
			sb.append("<NODES>");
			
			for (ApprGTaskVO vo : list) {
				sb.append("<NODE><EXPANDED>FALSE</EXPANDED><ISLEAF>FALSE</ISLEAF>");
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
		map.put("v_pCount", 0);
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
		map.put("v_pCount", 0);
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
		map.put("v_pCount", 0);
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
		map.put("v_pCount", 0);
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
			sb.append("<CELL><VALUE>" + vo.getDelDate() + "</VALUE></CELL>");
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

	public String setTaskHistory(String taskCode, String taskName, String taskName2, String changeFactor, String changeFactor2, String beforeValue, String afterValue, String afterValue2, String companyID) throws Exception {
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
}
