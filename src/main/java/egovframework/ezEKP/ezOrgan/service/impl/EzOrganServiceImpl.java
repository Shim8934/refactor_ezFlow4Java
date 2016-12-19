package egovframework.ezEKP.ezOrgan.service.impl;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganProxyVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPortal.web.EzPortalAdminController;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzOrganService")
public class EzOrganServiceImpl implements EzOrganService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzOrganServiceImpl.class);
	
	@Resource(name = "EzOrganDAO")
	private EzOrganDAO ezOrganDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
    @Autowired
    private Properties config;
	
	@Override
	public String getPropertyValue(String userid, String propName, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TENANT_ID", tenantID);
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
	public String getDeptFullPath(String deptID, int tenantID) throws Exception {
		return ezOrganDAO.getDeptFullPath(deptID, tenantID);
	}

	@Override
	public OrganDeptVO getDeptInfo(String userID,  String primary, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("primary", primary);
		map.put("v_TENANT_ID", tenantID);
		
		return ezOrganDAO.getDeptInfo(map);
	}

	@Override
	public String getDeptTreeInfo(String pUserID, String pDeptID, String pTopID, String pPropList, String primary, int tenantID) throws Exception {		
		if (!pUserID.equals("") && pDeptID.equals("")){
			OrganDeptVO organVo = getDeptInfo(pUserID, primary, tenantID);
			pDeptID = organVo.getDepartment();
        }		
		if (pDeptID.equals("")){
			pDeptID = pTopID;
		}
		
		OrganDeptVO vo = null;
		String prevDeptID = "";
        String deptInfo = "";
        String deptID = pDeptID;               
        
        do{
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_CN", deptID);
			map.put("v_LANGDATA", primary);
			map.put("v_TENANT_ID", tenantID);
			
			List<OrganDeptVO> list = ezOrganDAO.getDeptTreeInfo(map);
			
			String[] memberInfo2 = new String[list.size()];
	        //String[] memberSortInfo2 = new String[list.size()];
	        int memberCount2 = 0;
										
			for(int i=0; i<list.size(); i++){
				OrganDeptVO obj = list.get(i);
				
				if(obj.getType().toLowerCase().equals("dept")){					
					Map<String, Object> map1 = new HashMap<String, Object>();				
					map1.put("v_CN", obj.getCn());
					map1.put("v_LANGDATA", primary);
					map1.put("v_TENANT_ID", tenantID);
					
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
	        
	        logger.debug("prevDeptID=" + prevDeptID);
	        
	        Map<String, Object> map2 = new HashMap<String, Object>();				
			map2.put("v_CN", deptID);
			map2.put("v_LANGDATA", primary);
			map2.put("v_TENANT_ID", tenantID);
			
	        vo = ezOrganDAO.getTBLDeptMaster(map2);
	        
	        if (!deptID.toLowerCase().equals(pTopID.toLowerCase())){	        	
                deptID = getPropertyValue(deptID, "extensionAttribute1", tenantID);                
	        }
	        
	        logger.debug("deptID=" + deptID);
	        
        }while(!prevDeptID.toLowerCase().equals(pTopID.toLowerCase()) && !deptID.equals(""));
		
        deptInfo = "<TREEVIEWDATA>" + getTreeNodeInfo(vo, pDeptID, prevDeptID, deptInfo, pPropList) + "</TREEVIEWDATA>";
        
        return deptInfo;
	}
	
	@Override
	public String getDeptSubTreeInfo(String pDeptID, String pPropList, String primary, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CN", pDeptID);
		map.put("v_LANGDATA", primary);
		map.put("v_TENANT_ID", tenantID);
		
		List<OrganDeptVO> list = ezOrganDAO.getDeptSubTreeInfo(map);
				
		String[] memberInfo2 = new String[list.size()];
		int memberCount2 = 0;
		
		for(int i=0; i<list.size(); i++){
			OrganDeptVO obj = list.get(i);
			
			if(obj.getType().toLowerCase().equals("dept")){
				Map<String, Object> map1 = new HashMap<String, Object>();
				map1.put("v_CN", obj.getCn());
				map1.put("v_LANGDATA", primary);
				map1.put("v_TENANT_ID", tenantID);
				
				OrganDeptVO result = ezOrganDAO.getTBLDeptMaster(map1);
                
                memberInfo2[memberCount2] = getTreeNodeInfo(result, "", "", "", pPropList);
                memberCount2++;
			}		
		}
		StringBuilder deptlist = new StringBuilder("<NODES>");
		
        for (int k = 0; k < memberCount2; k++){
        	deptlist.append(memberInfo2[k]);
        }
        deptlist.append("</NODES>");   

		return deptlist.toString();
	}
	
	private String getTreeNodeInfo(OrganDeptVO vo, String pOrgDeptID, String pPrevDeptID, String pDeptInfo, String pPropList) throws Exception{
		StringBuilder nodeInfo = new StringBuilder();
		
		nodeInfo.append("<NODE>");
		nodeInfo.append("<VALUE>" + commonUtil.cleanValue(vo.getDeptNM()) + "</VALUE>");
		nodeInfo.append("<CN>" + vo.getDepartment() + "</CN>");
	
		if (!pPropList.equals("")){					
			pPropList = convertAddandConvert("group", pPropList);
			
			String[] proplist = pPropList.split(";");						

			for(String propname : proplist){
				Field field = vo.getClass().getDeclaredField(propname);
            	field.setAccessible(true);					
             	
				nodeInfo.append("<" + propname.toUpperCase() + ">"
				                    + (field.get(vo) != null ? commonUtil.cleanValue(String.valueOf(field.get(vo))) : "") 
				                    + "</" + propname.toUpperCase() + ">");
			}
		}
		int cnt = ezOrganDAO.deptSubDeptCnt(vo.getDepartment(), vo.getTenantId());
		
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
	public String getDeptMemberList(String pDeptID, String pCellList, String pPropList, String pClass, String pLangCode, int tenantID) throws Exception {	
		if (!pLangCode.equals("2")){
			pLangCode = "1";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> map1 = new HashMap<String, Object>();
		
		map.put("v_CLASS", pClass);
		map.put("v_CN", pDeptID);
		map.put("v_LANGDATA", pLangCode);
		map.put("v_TENANT_ID", tenantID);
		
		List<OrganDeptVO> list = ezOrganDAO.getDeptMemberList(map);
		
		int memberCount2 = 0;		
		String[] memberInfo2 = new String[list.size()];
		
		for (int i = 0; i < list.size(); i++){
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			
			OrganDeptVO obj = list.get(i);			
            
            if (obj.getType().toLowerCase().equals("user")){
            	map1.put("v_CN", obj.getCn());
        		map1.put("v_DEPTCD", pDeptID);
        		map1.put("v_LANGDATA", pLangCode);
        		map1.put("v_TENANT_ID", tenantID);
        		
        		Object userVO = ezOrganDAO.getTBLUserMaster(map1);        		
                sb.append(commonUtil.getQueryResult(userVO));
            }else{
            	map1.put("v_CN", obj.getCn());
        		map1.put("v_LANGDATA", pLangCode);
        		map1.put("v_TENANT_ID", tenantID);
        		                
        		Object userVO = ezOrganDAO.getTBLDeptMaster(map1);                
                sb.append(commonUtil.getQueryResult(userVO));
            }
            sb.append("</DATA>");
            
            String cn2 = obj.getCn();
            String displayname2 = obj.getDisplayName();

            //memberInfo2[memberCount2] = getMemberInfo(sb.toString(), pCellList, pPropList, cn2, displayname2, obj.getCn());
            memberInfo2[memberCount2] = getMemberInfo(sb.toString(), pCellList, pPropList, cn2, displayname2, obj.getType());
            memberCount2++;
        }
        StringBuilder memberlist2 = new StringBuilder("<LISTVIEWDATA><ROWS>");
        
        for (int i = 0; i < memberCount2; i++) {
            memberlist2.append(memberInfo2[i]);
        }
        memberlist2.append("</ROWS></LISTVIEWDATA>");
        
        return memberlist2.toString();
	}
	
	@Override
	public String getDeptMemberListPagination(String pDeptID, String pCellList, String pPropList, String pClass, String pLangCode, String pPage, int tenantID) throws Exception {	
		if (!pLangCode.equals("2")){
			pLangCode = "1";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> map1 = new HashMap<String, Object>();
		Map<String, Object> map2 = new HashMap<String, Object>();
		
		map.put("v_CLASS", pClass);
		map.put("v_CN", pDeptID);
		map.put("v_LANGDATA", pLangCode);
		map.put("v_PAGE", pPage);
		map.put("v_TENANT_ID", tenantID);
		
		List<OrganDeptVO> list = ezOrganDAO.getDeptMemberListPage(map);
		
		int memberCount2 = 0;		
		String[] memberInfo2 = new String[list.size()];
		
		for (int i = 0; i < list.size(); i++){
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			
			OrganDeptVO obj = list.get(i);			
            
            if (obj.getType().toLowerCase().equals("user")){
            	map1.put("v_CN", obj.getCn());
        		map1.put("v_DEPTCD", pDeptID);
        		map1.put("v_LANGDATA", pLangCode);
        		map1.put("v_TENANT_ID", tenantID);
        		
        		Object userVO = ezOrganDAO.getTBLUserMaster(map1);        		
                sb.append(commonUtil.getQueryResult(userVO));
            }else{
            	map1.put("v_CN", obj.getCn());
        		map1.put("v_LANGDATA", pLangCode);
        		map1.put("v_TENANT_ID", tenantID);
        		                
        		Object userVO = ezOrganDAO.getTBLDeptMaster(map1);                
                sb.append(commonUtil.getQueryResult(userVO));
            }
            sb.append("</DATA>");
            
            String cn2 = obj.getCn();
            String displayname2 = obj.getDisplayName();

            //memberInfo2[memberCount2] = getMemberInfo(sb.toString(), pCellList, pPropList, cn2, displayname2, obj.getCn());
            memberInfo2[memberCount2] = getMemberInfo(sb.toString(), pCellList, pPropList, cn2, displayname2, obj.getType());
            memberCount2++;
        }
		
		map2.put("v_CN", pDeptID);
		map2.put("v_TENANT_ID", tenantID);
		String totalcount = ezOrganDAO.getMemberListCount(map2);
        StringBuilder memberlist2 = new StringBuilder("<LISTVIEWDATA>");
        memberlist2.append("<TOTALCOUNT>" + totalcount + "</TOTALCOUNT><ROWS>");
        for (int i = 0; i < memberCount2; i++){
            memberlist2.append(memberInfo2[i]);
        }
        memberlist2.append("</ROWS></LISTVIEWDATA>");
        
        return memberlist2.toString();
	}
	
	private String getMemberInfo(String pXMLString, String pCellList, String pPropList, String pDeptID, String pDeptName, String pCategory){		
		Document doc = commonUtil.convertStringToDocument(pXMLString);
		logger.debug("getMemberInfo Start");
		logger.debug("pXMLString="+pXMLString);
        StringBuilder nodeInfo = new StringBuilder("<ROW>");
        String[] celllist = pCellList.split(";");
        String cellvalue = "";
        pPropList = convertAddandConvert(pCategory, pPropList);

        for (int i = 0; i < celllist.length; i++){
        	cellvalue = "";
            //if (!pDeptID.equals("") && pCategory.equals("user") && (doc.getElementsByTagName("DEPTID") != null && !pDeptID.equals(doc.getElementsByTagName("DEPTID").item(0).getTextContent()))){
            if (!pDeptID.equals("") && pCategory.equals("user") && (doc.getElementsByTagName("DEPARTMENT") != null && !pDeptID.equals(doc.getElementsByTagName("DEPARTMENT").item(0).getTextContent()))){
            	switch (celllist[i].toLowerCase()){
                case "department":
                    cellvalue = pDeptID;
                    break;
                case "description":
                    cellvalue = doc.getElementsByTagName("DESCRIPTION").item(0).getTextContent();
                    break;
                case "title":
                	//if (doc.getElementsByTagName("ADDJOB") != null && !doc.getElementsByTagName("ADDJOB").item(0).getTextContent().equals("")){
                    if (doc.getElementsByTagName("TITLE") != null && !doc.getElementsByTagName("TITLE").item(0).getTextContent().equals("")){
                        cellvalue = doc.getElementsByTagName("TITLE").item(0).getTextContent();
                        String[] sublist = cellvalue.split(";");
                        cellvalue = "";

                        for(String subinfo : sublist){
                            String[] subinfolist = subinfo.split(":");
                            if (subinfolist[0].equals(pDeptID)){                                
                                cellvalue = subinfolist[1];
                                break;
                            }
                        }
                    }
                    break;
                }
            }
            
            logger.debug("cellList["+i+"]="+celllist[i]);
            if (cellvalue == "" || cellvalue == null){
                if (celllist[i] != null && !celllist[i].equals("")){
                    if (doc.getElementsByTagName(celllist[i].toUpperCase()) != null){
                        cellvalue = doc.getElementsByTagName(celllist[i].toUpperCase()).item(0).getTextContent();
                    }else{
                        cellvalue = "";
                    }
                }else{
                    cellvalue = "";
                }
            }

            nodeInfo.append("<CELL><VALUE>" + commonUtil.cleanValue(cellvalue) + "</VALUE>");

            if (i == 0){
                String strNode = "";
                
                if (doc.getElementsByTagName("CN") != null){
                    strNode = doc.getElementsByTagName("CN").item(0).getTextContent();
                }
                nodeInfo.append("<DATA1>" + pCategory + "</DATA1><DATA2>" + strNode + "</DATA2>");

                if (!pPropList.equals("")){
                    String[] proplist = pPropList.split(";");
                    String propvalue;
                    
                    for (int j = 0; j < proplist.length; j++){
                        if (doc.getElementsByTagName(proplist[j].toUpperCase()) != null && doc.getElementsByTagName(proplist[j].toUpperCase()).item(0) != null){
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

	@Override
	public String getSearchList(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String pLangCode, int tenantID) throws Exception {
		pLangCode = commonUtil.convertLangCode(pLangCode);	
		
        String[] searchParemeta = null;
        String[] searchList;
        String[] searchInfo;
        String listInfo = "";
        String strSize = "";
        String strSQL = "";        
        String type = "";        
        int i = 0;
        
        if (pLimit != 0) {
            if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
                // MySQL에 의존적인 부분이라 후에 수정 필요함.
                strSize = " LIMIT " + pLimit;
            } else {
                strSize = " AND ROWNUM <= " + pLimit;
            }
        }
        
        if (pSearchList != ""){
            pSearchList = pSearchList.replace(";;", "##");
            pSearchList = pSearchList.replace("::", "@@");
            searchList = pSearchList.split("##");
            searchParemeta = new String[searchList.length];
            
            for (i = 0; i < searchList.length; i++){      	
                searchInfo = searchList[i].split("@@");

                if (i == 0){
                    // 수정(2007.06.26) : 검색 시 특정 필드(이름/부서명/직위)의 경우 Primary/Secondary 값을 모두 검색하도록 수정
                    searchParemeta[i] = searchInfo[1].replace("[", "[[]").replace("%", "[%]").replace("_", "[_]");
                    
                    if (checkSearchField(searchInfo[0])){
                        if (searchInfo[0].toUpperCase().equals("DISPLAYNAME") && searchParemeta[0].toString().equals("/")){
                            strSQL = strSQL + " WHERE (" + searchInfo[0].toLowerCase() + " = '" + searchParemeta[i] + "' OR " + searchInfo[0].toLowerCase() + "2 = '" + searchParemeta[i] + "')";
                            searchParemeta[0] = searchParemeta[0].substring(0, searchParemeta[0].length() - 1);
                        }else{
                            strSQL = strSQL + " WHERE (" + searchInfo[0].toLowerCase() + " LIKE  '%" + searchParemeta[i] + "%' OR " + searchInfo[0].toLowerCase() + "2 LIKE '%" + searchParemeta[i] + "%')";
                        }
                    }else{
                        if (searchInfo[0].indexOf("EXACT_") == 0){
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(6).toLowerCase() + "='" + searchParemeta[i] + "' ";
                        }else if (searchInfo[0].indexOf("LEFT_") == 0){
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(5).toLowerCase() + " LIKE '" + searchParemeta[i] + "%' ";
                        }else if (searchInfo[0].indexOf("RIGHT_") == 0){
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(5).toLowerCase() + " LIKE '%" + searchParemeta[i] + "%'";
                    	}else{
                            strSQL = strSQL + " WHERE " + searchInfo[0].toLowerCase() + " LIKE '%" + searchParemeta[i] + "%'";
                    	}
                    }
                }else{
                    // 수정(2007.06.26) : 검색 시 특정 필드(이름/부서명/직위)의 경우 Primary/Secondary 값을 모두 검색하도록 수정
                    searchParemeta[i] = searchInfo[1].replace("[", "[[]").replace("%", "[%]").replace("_", "[_]");
                    
                    if (checkSearchField(searchInfo[0])){
                        strSQL = strSQL + " AND (" + searchInfo[0].toLowerCase() + " LIKE  '%" + searchParemeta[i] + "%' OR " + searchInfo[0].toLowerCase() + "2 LIKE '%" + searchParemeta[i] + "%')";
                    }else{
                        if (searchInfo[0].indexOf("EXACT_") == 0){
                            strSQL = strSQL + " AND " + searchInfo[0].substring(6).toLowerCase() + "='" + searchParemeta[i] + "' ";
                        }else if (searchInfo[0].indexOf("LEFT_") == 0){
                            strSQL = strSQL + " AND " + searchInfo[0].substring(5).toLowerCase() + " LIKE '" + searchParemeta[i] + " %' ";
                        }else if (searchInfo[0].indexOf("RIGHT_") == 0){
                            strSQL = strSQL + " AND " + searchInfo[0].substring(5).toLowerCase() + " LIKE '%" + searchParemeta[i] + "%'";
                        }else{
                            strSQL = strSQL + " AND " + searchInfo[0].toLowerCase() + " LIKE '%" + searchParemeta[i] + "%'";
                        }
                    }
                }
            }
        }        
        
        if (pClass.equals("user") || pClass.equals("all")){
            strSQL = strSQL.replace("cn", "a.cn");
            strSQL = strSQL.replace("title", "a.title");
            
            if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
                strSQL = strSQL.replace("displayname", "a.displayname");
            }
            
            type = "U";
        }else{
        	type = "G";
        }

        Map<String, Object> map = new HashMap<String, Object>();
        
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            strSQL += " AND a.tenant_id=" + tenantID;
        }
        
        map.put("strSQL", strSQL + strSize);
        map.put("type", type);
        map.put("class", pClass);
        map.put("v_TENANT_ID", tenantID);
        
        List<OrganDeptVO> list = ezOrganDAO.organSearch(map);
        
        StringBuilder memberlist2 = new StringBuilder("<LISTVIEWDATA><ROWS>");
        
		for(int j=0; j < list.size(); j++){
			Map<String, Object> map1 = new HashMap<String, Object>();			
			OrganDeptVO organVO = list.get(j);
			Object result = null;			
			
			if(!organVO.getCn().equals("") && organVO.getCn() != null){
				StringBuilder sb = new StringBuilder();
				sb.append("<DATA>");
				
				if(organVO.getType().equals("user")){
					map1.put("v_CN", organVO.getCn());
	        		map1.put("v_DEPTCD", organVO.getDisplayName());
	        		map1.put("v_LANGDATA", pLangCode);
	        		map1.put("v_TENANT_ID", tenantID);
	        		
	        		result = ezOrganDAO.getTBLUserMaster(map1);	        		
	        	}else{
	        		map1.put("v_CN", organVO.getCn());
					map1.put("v_LANGDATA", pLangCode);
					map1.put("v_TENANT_ID", tenantID);
					
					result = ezOrganDAO.getTBLDeptMaster(map1);	        		
				}
				
				sb.append(commonUtil.getQueryResult(result));
				sb.append("</DATA>");
				
				listInfo = getMemberInfo(sb.toString(), pCellList, pPropList, "", "", organVO.getType());
				memberlist2.append(listInfo);
			}			
		}
		memberlist2.append("</ROWS></LISTVIEWDATA>");
        
		return memberlist2.toString();
	}
	
	public String convertAddandConvert(String pClass, String pProvValue){        
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
                case "DISPLAYNAME": strRet = "displayName1;displayName2";
                    break;
                case "DESCRIPTION": strRet = "description1;description2";
                    break;
                case "COMPANY": strRet = "company1;company2";
                    break;
                default: strRet = "";
                    break;
            }
        }else{
        	//사용자
            switch (pAttribute.toUpperCase()){
                case "DISPLAYNAME": strRet = "displayName1;displayName2";
                    break;
                case "DESCRIPTION": strRet = "description1;description2";
                    break;
                case "COMPANY": strRet = "company1;company2";
                    break;
                case "TITLE": strRet = "title1;title2";
                    break;
                case "EXTENSIONATTRIBUTE10": strRet = "extensionAttribute101;extensionAttribute102";
                    break;
                case "UPNNAME":
                    strRet = "upnName";
                    break;
                default: strRet = "";
                    break;
            }
        }
        return strRet;
    }
	
	public boolean checkSearchField(String pFieldName){
		boolean bRet = false;
		
        try{
            switch (pFieldName.toUpperCase()){
                case "DISPLAYNAME":
                    bRet = true;
                    break;
                case "DESCRIPTION":
                    bRet = true;
                    break;
                case "TITLE":
                    bRet = true;
                    break;
            }
        }catch (Exception Ex){ }
        return bRet;
    }
	
	public boolean checkDBColum(String pProvValue) throws Exception{
		boolean bRet = false;    

        switch (pProvValue.toUpperCase()){
            case "CN":
                bRet = true;
                break;
            case "DISPLAYNAME":
                bRet = true;
                break;
            case "DISPLAYNAME1":
                bRet = true;
                break;
            case "DISPLAYNAME2":
                bRet = true;
                break;
            case "USEFLAG":
                bRet = true;
                break;
            case "MAIL":
                bRet = true;
                break;
            case "MAILNICKNAME":
                bRet = true;
                break;
            case "UPNNAME":
                bRet = true;
                break;
            case "DEPARTMENT":
                bRet = true;
                break;
            case "DESCRIPTION":
                bRet = true;
                break;
            case "DESCRIPTION1":
                bRet = true;
                break;
            case "DESCRIPTION2":
                bRet = true;
                break;
            case "PHYSICALDELIVERYOFFICENAME":
                bRet = true;
                break;
            case "COMPANY":
                bRet = true;
                break;
            case "COMPANY1":
                bRet = true;
                break;
            case "COMPANY2":
                bRet = true;
                break;
            case "DEPTLEVEL":
                bRet = true;
                break;
            case "DEPT_CD_PATH":
                bRet = true;
                break;
            case "DEPT_NM_PATH":
                bRet = true;
                break;
            case "TITLE":
                bRet = true;
                break;
            case "TITLE1":
                bRet = true;
                break;
            case "TITLE2":
                bRet = true;
                break;
            case "TELEPHONENUMBER":
                bRet = true;
                break;
            case "HOMEPHONE":
                bRet = true;
                break;
            case "FACSIMILETELEPHONENUMBER":
                bRet = true;
                break;
            case "MOBILE":
                bRet = true;
                break;
            case "POSTALCODE":
                bRet = true;
                break;
            case "STREETADDRESS":
                bRet = true;
                break;
            case "INFO":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE1":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE2":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE3":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE4":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE5":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE6":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE7":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE8":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE9":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE10":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE101":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE102":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE11":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE12":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE13":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE14":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE15":
                bRet = true;
                break;
            case "ADSPATH":
                bRet = true;
                break;
            case "ADFLAG":
                bRet = true;
                break;
            case "UPDATEDT":
                bRet = true;
                break;
            case "SIPURI":
                bRet = true;
                break;
            case "BIRTH":
                bRet = true;
                break;
            case "BIRTHTYPE":
                bRet = true;
                break;
        }     
        return bRet;
    }

	@Override
	public String getPropertyList(String id, String pPropList, String primary, int tenantID) throws Exception {
		String propValue = "";
		StringBuilder propInfo = new StringBuilder("<DATA>");
		primary = commonUtil.convertLangCode(primary);
		
		String dataType = "user";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CN", id);
		map.put("v_LANGDATA", primary);
		map.put("v_TENANT_ID",  tenantID);
		
		String strXML = commonUtil.getQueryResult(ezOrganDAO.getUserInfo(map));
		Document xmldom = null;
		
		if (strXML != null && !strXML.equals("")) {
			xmldom = commonUtil.convertStringToDocument(strXML);
		}
		
		if(xmldom == null || xmldom.getElementsByTagName("ROW").getLength() == 0){
			map = new HashMap<String, Object>();
			map.put("userID", id);
			map.put("primary", primary);
			map.put("v_TENANT_ID",  tenantID);
			
			strXML = commonUtil.getQueryResult(ezOrganDAO.getDeptInfo(map));
			xmldom = commonUtil.convertStringToDocument(strXML); 
			dataType = "group";
		}
		
		pPropList = convertAddandConvert(dataType, pPropList);
        String[] propList = pPropList.split(";");
		
        for(String propname : propList){
        	if (checkDBColum(propname.toUpperCase()) == false){
                propValue = getPropertyValue(id, propname, tenantID);
                propInfo.append("<" + propname.toUpperCase() + ">" + commonUtil.cleanValue(propValue) + "</" + propname.toUpperCase() + ">");
            }else if (propname.toUpperCase() != ""){
            	
                if (xmldom != null && xmldom.getElementsByTagName(propname.toUpperCase()).getLength() > 0){
                    propInfo.append("<" + propname.toUpperCase() + ">" + commonUtil.cleanValue(xmldom.getElementsByTagName(propname.toUpperCase()).item(0).getTextContent()) + "</" + propname.toUpperCase() + ">");
                }else{
                    propInfo.append("<" + propname.toUpperCase() + "></" + propname.toUpperCase() + ">");
                }
            }
        }
        
        propInfo.append("</DATA>");

        return propInfo.toString();
	}

	@Override
	public String getUserAddjobInfo(String id, String pDeptID, String primary, int tenantID) throws Exception {
		String strXML = null;
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_PCN", id);
		map.put("v_PDEPT", pDeptID);
		map.put("v_LANGDATA", primary);
		
		OrganUserVO userVO = (ezOrganDAO.getUserAddjobInfo(map));
		
		if(userVO!=null){
			StringBuilder stb = new StringBuilder();		
			
			stb.append("<ROW>");
	        stb.append("<TITLE>");
	        stb.append(userVO.getTitle());
	        stb.append("</TITLE>");
	        stb.append("<DISPLAYNAME>");
	        stb.append(userVO.getDisplayName());
	        stb.append("</DISPLAYNAME>");		           
			stb.append("</ROW>");
			strXML = stb.toString();
		}
		
		return strXML;
	}

	@Override
	public String getOrganTreeInfo(String strFilter, int intScope) throws Exception {
		//TODO LDAP 으로 되어있어서 보류 외부수신처
		return null;
	}

	@Override
	public String getEncPassword(String dUserID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", dUserID);
		
		return ezOrganDAO.getEncPassword(map);
	}

	@Override
	public String getSearchListPagination(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String pLangCode, String page, int tenantID) throws Exception {
		pLangCode = commonUtil.convertLangCode(pLangCode);
		
		String strSQL="";
		int i=0;
		String[] SearchList;
		String[] SearchInfo;
		String ListInfo="";
		String strSize="";
		String[] SearchParemeta=null;
		String type = "";
		
        if (pLimit != 0) {
            if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
                // Pagination에서는 페이지에 따른 행 범위가 따로 지정되기 때문에 최대 제한을 별도로 두지 않는다.
            } else {
                strSize = " AND ROWNUM <= " + pLimit;
            }
        }
		
		if (pSearchList != ""){
			   pSearchList = pSearchList.replace(";;", "##");
	           pSearchList = pSearchList.replace("::", "@@");
	           SearchList  = pSearchList.split("##");
	           
	           SearchParemeta = new String[SearchList.length];
	           
	           for(i = 0; i < SearchList.length; i++){
	        	   SearchInfo = SearchList[i].split("@@");
	        	   
	        	   if(i == 0){
	        		   // 수정(2007.06.26) : 검색 시 특정 필드(이름/부서명/직위)의 경우 Primary/Secondary 값을 모두 검색하도록 수정
                       SearchParemeta[i] = SearchInfo[1].replace("[", "[[]").replace("%", "[%]").replace("_", "[_]").toLowerCase();
                       if (checkSearchField(SearchInfo[0])){
                           if (SearchInfo[0].toUpperCase().equals("DISPLAYNAME") && SearchParemeta[0].toString().equals(":")){
                               strSQL = strSQL + " WHERE (" + SearchInfo[0].toLowerCase() + " = UPPER('" + SearchParemeta[i] + "') OR " + SearchInfo[0].toLowerCase() + "2 = UPPER('" + SearchParemeta[i] + "'))";
                               SearchParemeta[0] = SearchParemeta[0].substring(0, SearchParemeta[0].length() - 1);
                           }
                           else{
                        	   strSQL = strSQL + " WHERE (" + SearchInfo[0].toLowerCase() + " LIKE  '%" + SearchParemeta[i] + "%' OR " + SearchInfo[0].toLowerCase() + "2 LIKE '%" + SearchParemeta[i] + "%')";
                       }
	        	   }
	        	   else{
	        		   if (SearchInfo[0].indexOf("EXACT_") == 0)
                           strSQL = strSQL + " WHERE " + SearchInfo[0].substring(6).toLowerCase() + "=UPPER('" + SearchParemeta[i] + "') ";
                       else if (SearchInfo[0].indexOf("LEFT_") == 0)
                           strSQL = strSQL + " WHERE " + SearchInfo[0].substring(5).toLowerCase() + " LIKE '" + SearchParemeta[i] + "%' ";
                       else if (SearchInfo[0].indexOf("RIGHT_") == 0)
                           strSQL = strSQL + " WHERE " + SearchInfo[0].substring(5).toLowerCase() + " LIKE '%" + SearchParemeta[i] + "%'";
                       else
                           strSQL = strSQL + " WHERE " + SearchInfo[0].toLowerCase() + " LIKE '%" + SearchParemeta[i] + "%'";
	        	   }
	           }
	        	   else{
	        		   // 수정(2007.06.26) : 검색 시 특정 필드(이름/부서명/직위)의 경우 Primary/Secondary 값을 모두 검색하도록 수정
                       SearchParemeta[i] = SearchInfo[1].replace("[", "[[]").replace("%", "[%]").replace("_", "[_]").toLowerCase();
                       if (checkSearchField(SearchInfo[0]))
                       {
                           strSQL = strSQL + " AND (" + SearchInfo[0].toLowerCase() + " LIKE  '%" + SearchParemeta[i] + "%' OR " + SearchInfo[0].toLowerCase() + "2 LIKE '%" + SearchParemeta[i] + "%')";
                       }
                       else
                       {
                           if (SearchInfo[0].indexOf("EXACT_") == 0)
                               strSQL = strSQL + " AND " + SearchInfo[0].substring(6).toLowerCase() + "=UPPER('" + SearchParemeta[i] + "') ";
                           else if (SearchInfo[0].indexOf("LEFT_") == 0)
                               strSQL = strSQL + " AND " + SearchInfo[0].substring(5).toLowerCase() + " LIKE '" + SearchParemeta[i] + "%' ";
                           else if (SearchInfo[0].indexOf("RIGHT_") == 0)
                               strSQL = strSQL + " AND " + SearchInfo[0].substring(5).toLowerCase() + " LIKE '%" + SearchParemeta[i] + "%'";
                           else
                               strSQL = strSQL + " AND " + SearchInfo[0].toLowerCase() + " LIKE '%" + SearchParemeta[i] + "%'";
                       }
	        	   }
	           }
	        }
		
		if (pClass.equals("user") || pClass.equals("all")){
			 strSQL = strSQL.replace("cn", "a.cn");
             strSQL = strSQL.replace("title", "a.title");
             
             if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
                 strSQL = strSQL.replace("displayname", "a.displayname");
             }
             
             type = "U";
    	}
		else{
			type = "G";
    	}

		if(page.equals(null) || page.equals("")){
			page = "1";
		}
		
		 int startRow = (Integer.parseInt(page) - 1) * 50 + 1;
         int endRow = Integer.parseInt(page) * 50 + 1;
         
         Map<String , Object> map = new HashMap<String , Object>();
         
         if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
             strSQL += " AND a.tenant_id=" + tenantID;
         }
         
         map.put("strSQL" , strSQL + strSize);
         map.put("type", type);
         map.put("class", pClass);
         map.put("startRow", startRow);
         map.put("endRow", endRow);
         map.put("v_TENANT_ID", tenantID);
         
         List<OrganDeptVO> list = ezOrganDAO.organSearchListPage(map);
         
         //여기까지 구현
         StringBuilder memberlist2 = null;
         int totalcount = ezOrganDAO.getSearchListCount(map);
         if(pClass.equals("user")){
               memberlist2 = new StringBuilder("<LISTVIEWDATA>");
               memberlist2.append("<TOTALCOUNT>" + totalcount + "</TOTALCOUNT><ROWS>");
         }else{
        	 memberlist2 = new StringBuilder("<LISTVIEWDATA><ROWS>");
         }
       

 		for(int j=0; j < list.size(); j++){
 			Map<String, Object> map1 = new HashMap<String, Object>();			
 			OrganDeptVO organVO = list.get(j);
 			Object result = null;			
 			
 			if(!organVO.getCn().equals("") && organVO.getCn() != null){
 				StringBuilder sb = new StringBuilder();
 				sb.append("<DATA>");
 				
 				if(organVO.getType().equals("user")){
 					map1.put("v_CN", organVO.getCn());
 	        		map1.put("v_DEPTCD", organVO.getDisplayName());
 	        		map1.put("v_LANGDATA", pLangCode);
 	        		map1.put("v_TENANT_ID", tenantID);
 	        		
 	        		result = ezOrganDAO.getTBLUserMaster(map1);	        		
 	        	}else{
 	        		map1.put("v_CN", organVO.getCn());
 					map1.put("v_LANGDATA", pLangCode);
 					map1.put("v_TENANT_ID", tenantID);
 					
 					result = ezOrganDAO.getTBLDeptMaster(map1);	        		
 				}
 				
 				sb.append(commonUtil.getQueryResult(result));
 				sb.append("</DATA>");
 				
 				ListInfo = getMemberInfo(sb.toString(), pCellList, pPropList, "", "", organVO.getType());
 				memberlist2.append(ListInfo);
 			}			
 		}
 		memberlist2.append("</ROWS></LISTVIEWDATA>");
         
 		return memberlist2.toString();
	}

	@Override
	public String updateProperty(String userID, String propName, String propValue, String pClass) throws Exception {
		String strFlag = "N";
		
		if (!pClass.equals("user")) {
			if (propName.toLowerCase().indexOf("displayname") != -1) {
				strFlag = "Y";
			}
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CN", userID);
		map.put("v_CLASS", pClass);
		map.put("v_PROPNAME", propName);
		map.put("v_PROPVALUE", propValue);
		map.put("v_FLAG", strFlag);
		
		try {
			ezOrganDAO.updateProperty(map);
			return "OK";
		} catch (Exception e) {
			return e.getMessage();
		}
	}

	@Override
	public String delProxyUserInfo(String userID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		
		try {
			ezOrganDAO.delProxyUserInfo(map);
			
			return "OK";
		} catch (Exception e) {
			return "";
		}
	}

	@Override
	public String setProxyUserInfo(String userID, String proxyUserID, String proxyUserName, String proxyUserDeptID, String startDate, String endDate) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_PROXYUSERID", proxyUserID);
		map.put("v_PROXYUSERNAME", proxyUserName);
		map.put("v_PROXYUSERDEPTID", proxyUserDeptID);
		map.put("v_STARTDATE", startDate);
		map.put("v_ENDDATE", endDate);
		
		try {
			ezOrganDAO.setProxyUserInfo(map);
			
			return "OK";
		} catch (Exception e) {
			return "";
		}
	}

	@Override
	public String getProxyUserInfo(String userID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		
		List<OrganProxyVO> organProxyVOList = ezOrganDAO.getProxyUserInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < organProxyVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(organProxyVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	//TODO eMail 값으로 ID 를 찾는 함수
	@Override
	public String getCNByEmail(String email, int tenantID) throws Exception {
			String result = ezOrganDAO.getCNByEmail(email, tenantID);
			
			return result;
	}

	@Override
	public String getLastLogin(String userID) throws Exception {
		return ezOrganDAO.getLastLogin(userID);
	}

}


