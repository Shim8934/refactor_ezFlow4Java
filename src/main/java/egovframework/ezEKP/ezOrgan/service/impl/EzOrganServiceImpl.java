package egovframework.ezEKP.ezOrgan.service.impl;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzOrganService")
public class EzOrganServiceImpl implements EzOrganService {
	
	@Resource(name = "EzOrganDAO")
	private EzOrganDAO ezOrganDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	
	@Override
	public String getPropertyValue(String userid, String propName) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CN",userid);
		map.put("v_FIELD", propName);
		return ezOrganDAO.getPropertyValue(map);
	}

	@Override
	public String getSIPUriList(String pCNList, String eMailList) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("iv_CNLIST", pCNList);
		map.put("iv_EMAILLIST", eMailList);
		return ezOrganDAO.getSIPUriList(map);
	}

	@Override
	public String getDeptFullPath(String deptID) throws Exception {
		return ezOrganDAO.getDeptFullPath(deptID);
	}

	@Override
	public OrganDeptVO getPropertyList(String userID,  String primary) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("primary", primary);
		return ezOrganDAO.getPropertyList(map);
	}

	@Override
	public String getDeptTreeInfo(String pUserID, String pDeptID, String pTopID, String pPropList, String pLangCode) throws Exception {		
		if (!pUserID.equals("") && pDeptID.equals("")){        
			OrganDeptVO organVo = getPropertyList(pUserID, pLangCode);
			pDeptID = organVo.getDeptID();
        }		
		if (pDeptID.equals("")){
			pDeptID = pTopID;
		}
		
		String prevDeptID = "";
        String deptInfo = "";
        String deptID = pDeptID;
        OrganDeptVO vo = null;        
        
        do{
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_CN", deptID);
			map.put("v_LANGDATA", pLangCode);
			
			List<OrganDeptVO> list = ezOrganDAO.getDeptTreeInfo(map);
			
			String[] memberInfo2 = new String[list.size()];
	        //String[] memberSortInfo2 = new String[list.size()];
	        int memberCount2 = 0;
										
			for(int i=0; i<list.size(); i++){
				OrganDeptVO obj = list.get(i);
				
				if(obj.getType().toLowerCase().equals("dept")){					
					Map<String, Object> map1 = new HashMap<String, Object>();				
					map1.put("v_CN", obj.getCn());
					map1.put("v_LANGDATA", pLangCode);
					
					OrganDeptVO result = ezOrganDAO.getTBLDeptMaster(map1);
	                
	                memberInfo2[memberCount2] = getTreeNodeInfo(result, pDeptID, prevDeptID, deptInfo, pPropList);
	                memberCount2++;
				}		
			}
			StringBuilder deptlist2 = new StringBuilder("<NODES>");
	
	        for (int k = 0; k < memberCount2; k++){
	            deptlist2.append(memberInfo2[k]);
	        }
	        deptlist2.append("</NODES>");	
	        deptInfo = deptlist2.toString();	
	        prevDeptID = deptID;
	        
	        Map<String, Object> map2 = new HashMap<String, Object>();				
			map2.put("v_CN", deptID);
			map2.put("v_LANGDATA", pLangCode);
			
	        vo = ezOrganDAO.getTBLDeptMaster(map2);
	        
	        if (!deptID.toLowerCase().equals(pTopID.toLowerCase())){	        	
                deptID = getPropertyValue(deptID, "extensionAttribute1");
	        }
	        
        }while(!prevDeptID.toLowerCase().equals(pTopID.toLowerCase()) && !deptID.equals(""));
		
        deptInfo = "<TREEVIEWDATA>" + getTreeNodeInfo(vo, pDeptID, prevDeptID, deptInfo, pPropList) + "</TREEVIEWDATA>";
        return deptInfo;
	}	       
	
	private String getTreeNodeInfo(OrganDeptVO vo, String pOrgDeptID, String pPrevDeptID, String pDeptInfo, String pPropList) throws Exception{
		StringBuilder nodeInfo = new StringBuilder();
		
		nodeInfo.append("<NODE>");
		nodeInfo.append("<VALUE>" + vo.getDeptNM() + "</VALUE>");
		nodeInfo.append("<CN>" + vo.getDeptID() + "</CN>");
	
		if (!pPropList.equals("")){					
			pPropList = convertAddandConvert("group", pPropList);
			
			String[] proplist = pPropList.split(";");
			String propvalue = "";
			String propColumn = "";

			for(String propname : proplist){
				if(propname.equals("mail")){
					propColumn = vo.getMail();
				}else if(propname.equals("DisplayName")){
					propColumn = vo.getDisplayName();
				}else if(propname.equals("DISPLAYNAME1")){
					propColumn = vo.getDisplayName1();
				}else if(propname.equals("DISPLAYNAME2")){
					propColumn = vo.getDisplayName2();
				}else{
					propColumn = "";
				}						
				propvalue = (propColumn != null && !propColumn.equals("") ? propColumn : "");												
				nodeInfo.append("<" + propname.toUpperCase() + ">" + propvalue + "</" + propname.toUpperCase() + ">");						
			}
		}
		int cnt = ezOrganDAO.deptSubDeptCnt(vo.getDeptID());
		
		if (cnt > 0){
	        nodeInfo.append("<ISLEAF>FALSE</ISLEAF>");
		}else{
	        nodeInfo.append("<ISLEAF>TRUE</ISLEAF>");
		}
		if(vo.getCn() != null){
			if(vo.getExtensionAttribute2() != null){
				if (vo.getCn().toLowerCase().equals(vo.getExtensionAttribute2().toLowerCase())){
			        nodeInfo.append("<SETNODEICONBYNAME>ICONCOMP</SETNODEICONBYNAME>");
				}
			}
			if(pPrevDeptID != null){
			    if (vo.getCn().toLowerCase().equals(pPrevDeptID.toLowerCase()) && !pDeptInfo.equals("<NODES></NODES>")){
			        nodeInfo.append("<EXPANDED>TRUE</EXPANDED>" + pDeptInfo);
			    }
			}
			if(pOrgDeptID != null){
			    if (vo.getCn().toLowerCase().equals(pOrgDeptID.toLowerCase())){
			        nodeInfo.append("<SELECT/>");
			    }
			}
		}
	    /* 2015-06-30 표준모듈:추가(결재문서수신여부) - KSK */
		if(vo.getExtensionAttribute11() != null){
		    if (vo.getExtensionAttribute11().toUpperCase().equals("N")){
		        nodeInfo.append("<SETTEXTCOLORBYNAME>GRAY</SETTEXTCOLORBYNAME>");
		    }		    
		}
	    nodeInfo.append("</NODE>");

	    return nodeInfo.toString();
	}	
	
	@Override
	public String getDeptMemberList(String pDeptID, String pCellList, String pPropList, String pClass, String pLangCode) throws Exception {	
		if (!pLangCode.equals("2")){
			pLangCode = "1";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> map1 = new HashMap<String, Object>();
		
		map.put("v_CLASS", pClass);
		map.put("v_CN", pDeptID);
		map.put("v_LANGDATA", pLangCode);
		
		List<OrganDeptVO> list = ezOrganDAO.getDeptMemberList(map);
		
		int memberCount2 = 0;		
		String[] memberInfo2 = new String[list.size()];
		
		for (int i = 0; i < list.size(); i++){
			StringBuilder sb = new StringBuilder();
    		sb.append("<DATA><ROW>");
    		
			OrganDeptVO obj = list.get(i);			
            
            if (obj.getType().toLowerCase().equals("user")){
            	map1.put("v_CN", obj.getCn());
        		map1.put("v_DEPTCD", pDeptID);
        		map1.put("v_LANGDATA", pLangCode);
        		
        		OrganUserVO vo = ezOrganDAO.getTBLUserMaster(map1);        		
        		Object userVO = vo;        		
        		
                for (Field field : userVO.getClass().getDeclaredFields()){
                    field.setAccessible(true);
                    
                    sb.append("<" + field.getName().toUpperCase() + ">");
                    sb.append(field.get(userVO));
                    sb.append("</" + field.getName().toUpperCase() + ">");                    
                }                        
            }else{
            	map1.put("v_CN", obj.getCn());
        		map1.put("v_LANGDATA", pDeptID);
        		                
                OrganDeptVO vo = ezOrganDAO.getTBLDeptMaster(map1);
                Object userVO = vo;
                
                for (Field field : userVO.getClass().getDeclaredFields()){
                    field.setAccessible(true);
                    
                    sb.append("<" + field.getName().toUpperCase() + ">");
                    sb.append(field.get(userVO));
                    sb.append("</" + field.getName().toUpperCase() + ">");                    
                }
            }            
            sb.append("</ROW></DATA>");
            
            String cn2 = obj.getCn();
            String displayname2 = obj.getDisplayName();
            
            memberInfo2[memberCount2] = getMemberInfo(sb.toString(), pCellList, pPropList, cn2, displayname2, obj.getCn());
            memberCount2++;
        }
        StringBuilder memberlist2 = new StringBuilder("<LISTVIEWDATA><ROWS>");
        
        for (int i = 0; i < memberCount2; i++){
            memberlist2.append(memberInfo2[i]);
        }
        memberlist2.append("</ROWS></LISTVIEWDATA>");
        
        return memberlist2.toString();
	}
	
	private String getMemberInfo(String pXMLString, String pCellList, String pPropList, String pDeptID, String pDeptName, String pCategory){		
		Document doc = commonUtil.convertStringToDocument(pXMLString);
        StringBuilder nodeInfo = new StringBuilder("<ROW>");
        String[] celllist = pCellList.split(";");
        String cellvalue = "";
        pPropList = convertAddandConvert(pCategory, pPropList);

        for (int i = 0; i < celllist.length; i++){
        	cellvalue = "";
            
            if (!pDeptID.equals("") && pCategory.equals("user") && (doc.getElementsByTagName("DEPTID") != null && !pDeptID.equals(doc.getElementsByTagName("DEPTID").item(0).getTextContent()))){
            	switch (celllist[i].toLowerCase()){
                case "department":
                    cellvalue = pDeptID;
                    break;
                case "description":
                    cellvalue = pDeptName;
                    break;
                case "title":
                    if (doc.getElementsByTagName("ADDJOB") != null && !doc.getElementsByTagName("ADDJOB").item(0).getTextContent().equals("")){
                        cellvalue = doc.getElementsByTagName("ADDJOB").item(0).getTextContent();
                        String[] sublist = cellvalue.split(";");
                        cellvalue = "";

                        for(String subinfo : sublist){
                            String[] subinfolist = subinfo.split(":");
                            if (subinfolist[0] == pDeptID){                                
                                cellvalue = subinfolist[1];
                                break;
                            }
                        }
                    }
                    break;
                }
            }

            if (cellvalue == ""){
                if (celllist[i] != ""){
                    if (doc.getElementsByTagName(celllist[i].toUpperCase()) != null){
                        cellvalue = doc.getElementsByTagName(celllist[i].toUpperCase()).item(0).getTextContent();
                    }else{
                        cellvalue = "";
                    }
                }else{
                    cellvalue = "";
                }
            }

            nodeInfo.append("<CELL><VALUE>" + cellvalue + "</VALUE>");

            if (i == 0){
                String strNode = "";
                
                if (doc.getElementsByTagName("CN") != null){
                    strNode = doc.getElementsByTagName("CN").item(0).getTextContent();
                }
                nodeInfo.append("<DATA1>" + pCategory + "</DATA1><DATA2>" + strNode + "</DATA2>");

                if (pPropList != ""){
                    String[] proplist = pPropList.split(";");
                    String propvalue;
                    
                    for (int j = 0; j < proplist.length; j++){
                        if (doc.getElementsByTagName(proplist[j].toUpperCase()) != null){
                            propvalue = doc.getElementsByTagName(proplist[j].toUpperCase()).item(0).getTextContent();
                        }else{
                            propvalue = "";
                        }
                        nodeInfo.append("<DATA" + (j + 3) + ">" + propvalue + "</DATA" + (j + 3) + ">");
                    }
                }
            }
            nodeInfo.append("</CELL>");
        }
        nodeInfo.append("</ROW>");

        return nodeInfo.toString();        
    }

	private String convertAddandConvert(String pClass, String pProvValue){        
        String[] arryProvValue = pProvValue.split(";");
        String returnValue = "";
        String addPopList = pProvValue;
        
        for (int i = 0; i < arryProvValue.length; i++)
        {
            returnValue = "";
            returnValue = addPropList(pClass, arryProvValue[i]);
            if (!returnValue.equals(""))
            	addPopList = addPopList + ";" + returnValue;
        }
        return addPopList;              
    }
	
	private String addPropList(String pType, String pAttribute){
    	String strRet = "";

        if (!pType.equals("user")){
            // 부서
            switch (pAttribute.toUpperCase()){
                case "DISPLAYNAME": strRet = "DISPLAYNAME1;DISPLAYNAME2".toUpperCase();
                    break;
                case "DESCRIPTION": strRet = "DESCRIPTION1;DESCRIPTION2".toUpperCase();
                    break;
                case "COMPANY": strRet = "COMPANY1;COMPANY2".toUpperCase();
                    break;
                default: strRet = "";
                    break;
            }
        }else{
        	//사용자
            switch (pAttribute.toUpperCase()){
                case "DISPLAYNAME": strRet = "DISPLAYNAME1;DISPLAYNAME2".toUpperCase();
                    break;
                case "DESCRIPTION": strRet = "DESCRIPTION1;DESCRIPTION2".toUpperCase();
                    break;
                case "COMPANY": strRet = "COMPANY1;COMPANY2".toUpperCase();
                    break;
                case "TITLE": strRet = "TITLE1;TITLE2".toUpperCase();
                    break;
                case "EXTENSIONATTRIBUTE10": strRet = "EXTENSIONATTRIBUTE101;EXTENSIONATTRIBUTE102".toUpperCase();
                    break;
                case "UPNNAME":
                    strRet = "UPNNAME";
                    break;
                default: strRet = "";
                    break;
            }
        }
        return strRet;
    }
}
