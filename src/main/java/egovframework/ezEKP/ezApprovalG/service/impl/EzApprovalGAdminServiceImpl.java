package egovframework.ezEKP.ezApprovalG.service.impl;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.stringtemplate.v4.compiler.CodeGenerator.conditional_return;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGAdminDAO;
import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGDAO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGAdminService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAdminReceiveVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocStateVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGListHeaderVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzApprovalGAdminService")
public class EzApprovalGAdminServiceImpl implements EzApprovalGAdminService{
	
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
		StringBuilder sb = new StringBuilder();

		if (!companyID.toUpperCase().equals("Top")) {
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
	public String getTaskCategotyTree(String categoryType, String parentID, String companyID) throws Exception {
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
}
