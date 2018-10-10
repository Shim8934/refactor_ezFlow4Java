package egovframework.ezEKP.ezOrgan.service.impl;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganProxyVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;

@Service("EzOrganService")
public class EzOrganServiceImpl implements EzOrganService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzOrganServiceImpl.class);
	
	@Resource(name = "EzOrganDAO")
	private EzOrganDAO ezOrganDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
    @Autowired
    private Properties config;
    
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
    // 지정된 사원 혹은 부서의 특정 필드의 값을 반환한다.
	@Override
	public String getPropertyValue(String userid, String propName, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TENANT_ID", tenantID);
		map.put("v_CN",userid);
		map.put("v_FIELD", propName);
		
        // 지정된 사원이 존재하는 지 여부를 확인한다.
    	String temp = ezOrganDAO.getPropertyValue_S1(map);
    	
    	if (temp != null && temp.equals("1")) {
    	    // 해당 사원이 Proxy User인 지 확인한다.
    		String temp1 = ezOrganDAO.getPropertyValue_S2(map);
    		
    		// Proxy User이고 지정된 속성이 권한 속성(EXTENSIONATTRIBUTE1)인 경우 a=1 권한을 추가하여 반환한다.
    		if (temp1 != null && temp1.equals("1")) {
    			return ezOrganDAO.getPropertyValue_S3(map);
    		// Proxy User가 아닌 경우엔 해당 사원의 지정된 속성값을 그대로 반환한다.
    		} else {
    			return ezOrganDAO.getPropertyValue_S4(map);
    		}
    	// 사원이 존재하지 않는 경우엔 부서 정보에서 지정된 속성값을 반환한다.
    	} else {
    		return ezOrganDAO.getPropertyValue_S5(map);
    	}    		
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
	    logger.debug("getDeptFullPath started");
	    logger.debug("deptID=" + deptID + ",tenantID=" + tenantID);
	    
		String deptFullPath = ezOrganDAO.getDeptFullPath(deptID, tenantID);
		
		logger.debug("deptFullPath=" + deptFullPath);		        
		logger.debug("getDeptFullPath ended");
		
		return deptFullPath;
	}

	@Override
	public OrganDeptVO getDeptInfo(String userID,  String primary, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("primary", primary);
		map.put("v_TENANT_ID", tenantID);
		
		return ezOrganDAO.getDeptInfo(map);
	}

	// 지정된 부서가 선택된 형태의 조직도 트리를 XML 형식으로 반환한다.
	@Override
	public String getDeptTreeInfo(String pUserID, String pDeptID, String pTopID, String pPropList, String primary, int tenantID) throws Exception {
	    logger.debug("getDeptTreeInfo started");
	    logger.debug("pUserID=" + pUserID + ",pDeptID=" + pDeptID + ",pTopID=" + pTopID
	            + ",pPropList=" + pPropList + ",primary=" + primary + ",tenantID=" + tenantID);
	    
	    String [] adminOrganChk = pTopID.split("/"); // 관리자 페이지  > 조직도, 겸직, 권한 관리에서 topId + "/organ" 붙임
	    
	    String isOrgan ="";
	    if (adminOrganChk.length > 1) {
	    	pTopID = adminOrganChk[0];
			isOrgan = adminOrganChk[1];
		} 
	    
	    // pUserID는 값이 있으나 pDeptID가 비어 있을 때는 해당 사용자의 부서 ID를 구한다. 
		if (!pUserID.equals("") && pDeptID.equals("")) {
			OrganDeptVO organVo = getDeptInfo(pUserID, primary, tenantID);
			pDeptID = organVo.getDepartment();
        }		
		
		// pDeptID가 비어 있는 경우엔 Top ID로 처리한다.
		if (pDeptID.equals("")) {
			pDeptID = pTopID;
		}
		
		OrganDeptVO vo = null;
		String prevDeptID = "";
        String deptInfo = "";
        String deptID = pDeptID;               
        
        do {
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("v_CN", deptID);
			map.put("v_LANGDATA", primary);
			map.put("v_TENANT_ID", tenantID);
			map.put("isOrgan", isOrgan);
			
			// 지정된 부서의 자식 부서 목록을 가져온다.
			List<OrganDeptVO> list = ezOrganDAO.getDeptTreeInfo(map);
			
			String[] memberInfo = new String[list.size()];
	        int memberCount = 0;
										
	        // 자식 부서 각각의 정보를 가지고 온다.
			for (int i = 0; i < list.size(); i++) {
				OrganDeptVO obj = list.get(i);
				
				if (obj.getType().toLowerCase().equals("dept")) {					
					Map<String, Object> map1 = new HashMap<String, Object>();	
					
					map1.put("v_CN", obj.getCn());
					map1.put("v_LANGDATA", primary);
					map1.put("v_TENANT_ID", tenantID);
					
					// 자식 부서의 상세 정보를 가져온다.
					OrganDeptVO result = ezOrganDAO.getTBLDeptMaster(map1);
	                
					// 자식 부서의 상세 정보를 XML String 형태로 변환한다.
	                memberInfo[memberCount] = getTreeNodeInfo(result, pDeptID, prevDeptID, deptInfo, pPropList, "");
	                memberCount++;
				}		
			}
			
			// 현재 부서의 자식 부서들의 정보를 XML String으로 생성한다.
			StringBuilder deptlist = new StringBuilder("<NODES>");
			
	        for (int k = 0; k < memberCount; k++) {
	            deptlist.append(memberInfo[k]);
	        }
	        
	        deptlist.append("</NODES>");	
	        deptInfo = deptlist.toString();	
	        prevDeptID = deptID;
	        
	        logger.debug("prevDeptID=" + prevDeptID);
	        
	        Map<String, Object> map2 = new HashMap<String, Object>();				
			map2.put("v_CN", deptID);
			map2.put("v_LANGDATA", primary);
			map2.put("v_TENANT_ID", tenantID);
			
			// 지정된 부서 자체의 상세 정보를 가지고 온다.
	        vo = ezOrganDAO.getTBLDeptMaster(map2);
	        
	        // 지정된 부서의 부모 부서 ID를 구한다.
	        if (!deptID.toLowerCase().equals(pTopID.toLowerCase())) {
	        	if (deptID.toLowerCase().equals("top")) {
	        		deptID = "";
	        	} else {
	        		deptID = getPropertyValue(deptID, "extensionAttribute1", tenantID);         
	        	}
	        }
	        
	        logger.debug("deptID=" + deptID);
	        
	        // 부모 부서가 있는 경우 부모 부서로 이동하여 처리를 반복한다. 
        } while (!prevDeptID.toLowerCase().equals(pTopID.toLowerCase()) && !deptID.equals(""));
		
        deptInfo = "<TREEVIEWDATA>" + getTreeNodeInfo(vo, pDeptID, prevDeptID, deptInfo, pPropList, isOrgan) + "</TREEVIEWDATA>";
        
        logger.debug("deptInfo=" + deptInfo);
        logger.debug("getDeptTreeInfo ended");
        
        return deptInfo;
	}
	
	// 지정된 부서의 자식 부서 목록을 XML 형식으로 반환한다.
	@Override
	public String getDeptSubTreeInfo(String pDeptID, String pPropList, String primary, int tenantID) throws Exception {
	    logger.debug("getDeptSubTreeInfo started");
	    logger.debug("pDeptID=" + pDeptID + ",pPropList=" + pPropList + ",primary=" + primary + ",tenantID=" + tenantID);
	    
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CN", pDeptID);
		map.put("v_LANGDATA", primary);
		map.put("v_TENANT_ID", tenantID);
		
		// 지정된 부서의 자식 부서 목록을 가져온다.
		List<OrganDeptVO> list = ezOrganDAO.getDeptSubTreeInfo(map);
				
		String[] memberInfo = new String[list.size()];
		int memberCount = 0;
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO obj = list.get(i);
			
			if (obj.getType().toLowerCase().equals("dept")) {
				Map<String, Object> map1 = new HashMap<String, Object>();
				map1.put("v_CN", obj.getCn());
				map1.put("v_LANGDATA", primary);
				map1.put("v_TENANT_ID", tenantID);
				
				OrganDeptVO result = ezOrganDAO.getTBLDeptMaster(map1);
                
                memberInfo[memberCount] = getTreeNodeInfo(result, "", "", "", pPropList, "");
                memberCount++;
			}		
		}
		
		StringBuilder deptlist = new StringBuilder("<NODES>");
		
        for (int k = 0; k < memberCount; k++) {
        	deptlist.append(memberInfo[k]);
        }
        
        deptlist.append("</NODES>");   

        logger.debug("deptlist=" + deptlist);
        logger.debug("getDeptSubTreeInfo ended");
        
		return deptlist.toString();
	}
	
	private String getTreeNodeInfo(OrganDeptVO vo, String pOrgDeptID, String pPrevDeptID, String pDeptInfo, String pPropList, String isOrgan) throws Exception {
		logger.debug("getTreeNodeInfo started");
		
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", vo.getTenantId());

		StringBuilder nodeInfo = new StringBuilder();
		
		nodeInfo.append("<NODE>");
		nodeInfo.append("<VALUE>" + commonUtil.cleanValue(vo.getDeptNM()) + "</VALUE>");
		nodeInfo.append("<CN>" + vo.getDepartment() + "</CN>");
	
		if (!pPropList.equals("")) {					
			pPropList = convertAddandConvert("group", pPropList);
			
			String[] proplist = pPropList.split(";");						

			// 속성 목록에 있는 각 속성과 이름이 동일한 필드의 값을 부서의 vo 객체로부터 가져와 XML String 형태로 구성한다.
			for (String propname : proplist) {
				Field field = vo.getClass().getDeclaredField(propname);
            	field.setAccessible(true);					
             	
				nodeInfo.append("<" + propname.toUpperCase() + ">"
				                    + (field.get(vo) != null ? commonUtil.cleanValue(String.valueOf(field.get(vo))) : "") 
				                    + "</" + propname.toUpperCase() + ">");
			}
		}
		
		// 부서의 자식 부서의 갯수를 구한다.
		int cnt = ezOrganDAO.deptSubDeptCnt(vo.getDepartment(), vo.getTenantId(), isOrgan);
		
		if (cnt > 0) {
	        nodeInfo.append("<ISLEAF>FALSE</ISLEAF>");
		} else {
	        nodeInfo.append("<ISLEAF>TRUE</ISLEAF>");
		}
		
		if (vo.getCn() != null) {
			if (vo.getExtensionAttribute2() != null) {
			    // 현재 처리하는 부서가 회사일 경우 회사 아이콘이 표시되도록 한다.
				if (vo.getCn().toLowerCase().equals(vo.getExtensionAttribute2().toLowerCase())){
			        nodeInfo.append("<SETNODEICONBYNAME>ICONCOMP</SETNODEICONBYNAME>");
				}
			}
			
			if (pPrevDeptID != null) {
			    // 현재 부서의 직전에 처리했던 자식 부서의 XML String 정보를 추가한다. 
			    if (vo.getCn().toLowerCase().equals(pPrevDeptID.toLowerCase()) && !pDeptInfo.equals("<NODES></NODES>")){
			        nodeInfo.append("<EXPANDED>TRUE</EXPANDED>" + pDeptInfo);
			    }
			}
			
			if (pOrgDeptID != null) {
			    // 사용자가 최초로 지정한 부서가 선택되도록 한다.
			    if (vo.getCn().toLowerCase().equals(pOrgDeptID.toLowerCase())){
			        nodeInfo.append("<SELECT/>");
			    }
			}
		}
		
		if (approvalFlag.equals("G")) {
		    /* 2015-06-30 표준모듈:추가(결재문서수신여부) - KSK */
			if (vo.getExtensionAttribute11() != null) {
			    if (vo.getExtensionAttribute11().toUpperCase().equals("N")) {
			        nodeInfo.append("<SETTEXTCOLORBYNAME>GRAY</SETTEXTCOLORBYNAME>");
			    }		    
			}
		}
	    nodeInfo.append("</NODE>");

	    logger.debug("nodeInfo=" + nodeInfo.toString());
		logger.debug("getTreeNodeInfo ended");;
		
	    return nodeInfo.toString();
	}

	public List<OrganDeptVO> getDeptMemberList(String pClass, String deptID, String lang, int tenantID) throws Exception {
		logger.debug("getDeptMemberList started");
		logger.debug("deptID=" + deptID + ",lang=" + lang + ",tenantID=" + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> map1 = new HashMap<String, Object>();
		
		map.put("v_CLASS", pClass);
		map.put("v_CN", deptID);
		map.put("v_LANGDATA", lang);
		map.put("v_TENANT_ID", tenantID);
		
		// 지정된 부서의 멤버 목록을 구한다.
		List<OrganDeptVO> memberList = ezOrganDAO.getDeptMemberList(map);
		
		logger.debug("getDeptMemberList ended");
		
		return memberList;
	}
	
	@Override
	public String getDeptMemberList(String pDeptID, String pCellList, String pPropList, String pClass, String pLangCode, int tenantID, String noAddJob) throws Exception {
	    logger.debug("getDeptMemberList started");
	    logger.debug("pDeptID=" + pDeptID + ",pCellList=" + pCellList + ",pPropList=" + pPropList
	            + ",pClass=" + pClass + ",pLangCode=" + pLangCode + ",tenantID=" + tenantID);
	    
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> map1 = new HashMap<String, Object>();
		Map<String, Object> map2 = new HashMap<String, Object>();
		
		map.put("v_CLASS", pClass);
		map.put("v_CN", pDeptID);
		map.put("v_LANGDATA", pLangCode);
		map.put("v_TENANT_ID", tenantID);
		map.put("noAddJob", noAddJob);
		
		// 지정된 부서의 멤버 목록을 구한다.
		List<OrganDeptVO> list = ezOrganDAO.getDeptMemberList(map);
		
		int memberCount = 0;		
		String[] memberInfo = new String[list.size()];
		
		for (int i = 0; i < list.size(); i++) {
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			
			OrganDeptVO obj = list.get(i);			
            
			// 멤버가 사원인 경우
            if (obj.getType().toLowerCase().equals("user")) {
            	map1.put("v_CN", obj.getCn());
        		map1.put("v_DEPTCD", pDeptID);
        		map1.put("v_LANGDATA", pLangCode);
        		map1.put("v_TENANT_ID", tenantID);
        		
        		// 사원의 상세 정보를 가져온다.
        		Object userVO = ezOrganDAO.getTBLUserMaster(map1);        		
                sb.append(commonUtil.getQueryResult(userVO));
            // 멤버가 부서인 경우
            } else {
            	map1.put("v_CN", obj.getCn());
        		map1.put("v_LANGDATA", pLangCode);
        		map1.put("v_TENANT_ID", tenantID);
        		                
        		// 자식 부서의 상세 정보를 가져온다.
        		Object deptVO = ezOrganDAO.getTBLDeptMaster(map1);                
                sb.append(commonUtil.getQueryResult(deptVO));
            }
            
            sb.append("</DATA>");
            
            String cn = obj.getCn();

            memberInfo[memberCount] = getMemberInfo(sb.toString(), pCellList, pPropList, cn, obj.getType());
            memberCount++;
        }
		
		map2.put("v_CN", pDeptID);
		map2.put("v_TENANT_ID", tenantID);
		
        StringBuilder memberlist = new StringBuilder("<LISTVIEWDATA><ROWS>");
        
        for (int i = 0; i < memberCount; i++) {
            memberlist.append(memberInfo[i]);
        }
        
        memberlist.append("</ROWS></LISTVIEWDATA>");
        
        return memberlist.toString();
	}
	
	@Override
	public String getDeptMemberListPagination(String pDeptID, String pCellList, String pPropList, String pClass, String pLangCode, String pPage, int tenantID) throws Exception {
        logger.debug("getDeptMemberListPagination started");
        logger.debug("pDeptID=" + pDeptID + ",pCellList=" + pCellList + ",pPropList=" + pPropList
                + ",pClass=" + pClass + ",pLangCode=" + pLangCode + ",pPage=" + pPage + ",tenantID=" + tenantID);
	    		
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> map1 = new HashMap<String, Object>();
		Map<String, Object> map2 = new HashMap<String, Object>();
		
		map.put("v_CLASS", pClass);
		map.put("v_CN", pDeptID);
		map.put("v_LANGDATA", pLangCode);
		map.put("v_PAGE", pPage);
		map.put("v_TENANT_ID", tenantID);
		map.put("v_STARTROW", (Integer.parseInt(pPage) -1) * 50 + 1);
		map.put("v_ENDROW", Integer.parseInt(pPage) * 50 + 1);
        map.put("v_STARTROWForMySQL", (Integer.parseInt(pPage) -1) * 50);
        map.put("v_COUNT", 50);
		
		// 지정된 부서의 멤버 목록을 페이지를 고려하여 구한다.
		List<OrganDeptVO> list = ezOrganDAO.getDeptMemberListPage(map);
		
		int memberCount = 0;
		String[] memberInfo = new String[list.size()];
		
		for (int i = 0; i < list.size(); i++) {
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			
			OrganDeptVO obj = list.get(i);			
            
			// 멤버가 사원인 경우
            if (obj.getType().toLowerCase().equals("user")) {
            	map1.put("v_CN", obj.getCn());
        		map1.put("v_DEPTCD", pDeptID);
        		map1.put("v_LANGDATA", pLangCode);
        		map1.put("v_TENANT_ID", tenantID);
        		
        		// 사원의 상세 정보를 가져온다.
        		Object userVO = ezOrganDAO.getTBLUserMaster(map1);        		
                sb.append(commonUtil.getQueryResult(userVO));
            // 멤버가 부서인 경우
            } else {
            	map1.put("v_CN", obj.getCn());
        		map1.put("v_LANGDATA", pLangCode);
        		map1.put("v_TENANT_ID", tenantID);
        		                
        		// 자식 부서의 상세 정보를 가져온다.
        		Object userVO = ezOrganDAO.getTBLDeptMaster(map1);                
                sb.append(commonUtil.getQueryResult(userVO));
            }
            
            sb.append("</DATA>");
            
            String cn = obj.getCn();

            memberInfo[memberCount] = getMemberInfo(sb.toString(), pCellList, pPropList, cn, obj.getType());
            memberCount++;
        }
		
		// 지정된 부서의 사원수를 겸직 사원을 포함하여 구한다.
		map2.put("v_CN", pDeptID);
		map2.put("v_TENANT_ID", tenantID);
		String totalcount = ezOrganDAO.getMemberListCount(map2);
		
        StringBuilder memberlist = new StringBuilder("<LISTVIEWDATA>");
        
    	memberlist.append("<TOTALCOUNT>" + totalcount + "</TOTALCOUNT><ROWS>");
        
        for (int i = 0; i < memberCount; i++) {
            memberlist.append(memberInfo[i]);
        }
        
        memberlist.append("</ROWS></LISTVIEWDATA>");
        
        return memberlist.toString();
	}
	
	/**
	 * 하위부서 포함하여 카운트 필요시 사용 
	 * @param companyList 하위회사 목록
	 * @param totalCount2 하위포함 전체카운트
	 * @param containLow YES일때 본인포함 하위, NO일때 본인제외 하위 (하위가 회사인경우를 위해 추가함)
	 * @param tenantID
	 * @return
	 * @throws Exception
	 */
	@Override
	public int getMemberListCount2(String deptCN, List<String> companyList, int totalCount, String containLow, int tenantID) throws Exception {
		logger.debug("getMemberListCount2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptCN", deptCN);
		map.put("containConfig", containLow);
		map.put("tenantID", tenantID);
		
		totalCount = ezOrganDAO.getMemberListCount2(map);
		
		logger.debug("totalCount2 = " + totalCount);
		
//		if (companyList == null) {
//			companyList = ezOrganDAO.getChildCompany(map);
//		}
//		
//		for (String company : companyList) {
//			map.put("deptCN", company);
//			
//			List<String> childCompanyList = ezOrganDAO.getChildCompany(map);
//			
//			totalCount += getMemberListCount2(company, childCompanyList, totalCount, "NO", tenantID);
//		}
		
		logger.debug("getMemberListCount2 ended.");
		
		return totalCount;
	}
	
	public int getDeptMemberListCount(String deptID, boolean containLow, String primary, int tenantID) throws Exception {
		logger.debug("getDeptMemberListCount started.");
		logger.debug("deptID = " + deptID + " || containLow = " + containLow + " || primary = " + primary + " || tenantID = " + tenantID);
		
		int totalCount = 0;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CN", deptID);
		map.put("v_TENANT_ID", tenantID);
		
		if (!containLow) {
			//totalCount
			totalCount = Integer.parseInt(ezOrganDAO.getMemberListCount(map));
		} else {
			//totalCount2
			if (ezCommonService.getTenantConfig("containLow", tenantID).equals("YES")) {
				totalCount = getMemberListCount2(deptID, null, totalCount, ezCommonService.getTenantConfig("containLow", tenantID), tenantID);
			} else {
				totalCount = Integer.parseInt(ezOrganDAO.getMemberListCount(map)); 
			}
		}
		
		logger.debug("getDeptMemberListCount ended.");
		
		return totalCount;
	}
	
	private String getMemberInfo(String pXMLString, String pCellList, String pPropList, String pMemberID, String pCategory) {		
        logger.debug("getMemberInfo started");
        logger.debug("pCellList=" + pCellList + ",pPropList=" + pPropList + ",pMemberID=" + pMemberID 
                + ",pCategory=" + pCategory);

	    Document doc = commonUtil.convertStringToDocument(pXMLString);
        StringBuilder nodeInfo = new StringBuilder("<ROW>");
        String[] celllist = pCellList.split(";");
        String cellvalue = "";
        pPropList = convertAddandConvert(pCategory, pPropList);

        for (int i = 0; i < celllist.length; i++) {
        	cellvalue = "";

            if (!pMemberID.equals("") && pCategory.equals("user") && (doc.getElementsByTagName("DEPARTMENT") != null && !pMemberID.equals(doc.getElementsByTagName("DEPARTMENT").item(0).getTextContent()))) {
            	switch (celllist[i].toLowerCase()) {
                case "department":
                    cellvalue = pMemberID;
                    break;
                case "description":
                    cellvalue = doc.getElementsByTagName("DESCRIPTION").item(0).getTextContent();
                    break;
                case "title":
                    if (doc.getElementsByTagName("TITLE") != null && !doc.getElementsByTagName("TITLE").item(0).getTextContent().equals("")) {
                        cellvalue = doc.getElementsByTagName("TITLE").item(0).getTextContent();
                        String[] sublist = cellvalue.split(";");
                        cellvalue = "";

                        for (String subinfo : sublist) {
                            String[] subinfolist = subinfo.split(":");
                            if (subinfolist[0].equals(pMemberID) && subinfolist.length > 1) {                                
                                cellvalue = subinfolist[1];
                                break;
                            }
                        }
                    }
                    break;
                }
            }
            
            logger.debug("cellList["+i+"]=" + celllist[i]);
            
              if (cellvalue == null || cellvalue.equals("")) { 
                if (celllist[i] != null && !celllist[i].equals("")) {
                    if (doc.getElementsByTagName(celllist[i].toUpperCase()).item(0) != null) {
                    	if (!doc.getElementsByTagName(celllist[i].toUpperCase()).item(0).getTextContent().equals("")) {
                    		cellvalue = doc.getElementsByTagName(celllist[i].toUpperCase()).item(0).getTextContent();
                    	}
                    } else {
                         cellvalue = "";
                    }
                } else {
                    cellvalue = "";
                }
            }

            nodeInfo.append("<CELL><VALUE>" + commonUtil.cleanValue(cellvalue) + "</VALUE>");

            if (i == 0) {
                String strNode = "";
                
                if (doc.getElementsByTagName("CN").item(0) != null) {
                    strNode = doc.getElementsByTagName("CN").item(0).getTextContent();
                }
                
                nodeInfo.append("<DATA1>" + pCategory + "</DATA1><DATA2>" + strNode + "</DATA2>");

                if (!pPropList.equals("")) {
                    String[] proplist = pPropList.split(";");
                    String propvalue;
                    
                    for (int j = 0; j < proplist.length; j++) {
                        if (doc.getElementsByTagName(proplist[j].toUpperCase()) != null && doc.getElementsByTagName(proplist[j].toUpperCase()).item(0) != null) {
                            propvalue = doc.getElementsByTagName(proplist[j].toUpperCase()).item(0).getTextContent();
                        } else {
                            propvalue = "";
                        }
                        
                        nodeInfo.append("<DATA" + (j + 3) + ">" + commonUtil.cleanValue(propvalue) + "</DATA" + (j + 3) + ">");
                    }
                }
            }
            
            nodeInfo.append("</CELL>");
        }
        
        nodeInfo.append("</ROW>");

        logger.debug("nodeInfo=" + nodeInfo);
        logger.debug("getMemberInfo ended");
        
        return nodeInfo.toString();        
    }	

	@Override
	public String getSearchList(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String primary, int tenantID) throws Exception {
		logger.debug("getSearchList started");
		
        String[] searchParemeta = null;
        String[] searchList;
        String[] searchInfo;
        String listInfo = "";
        String strSize = "";
        String strSizeForMySQL = "";
        String strSQL = "";        
        String type = "";        
        int i = 0;
        
        if (pLimit != 0) {
            strSize = " AND ROWNUM <= " + pLimit;
            strSizeForMySQL = " LIMIT " + pLimit;
        }
        
        if (!pSearchList.equals("")){
            pSearchList = pSearchList.replace(";;", "##");
            pSearchList = pSearchList.replace("::", "@@");
            searchList = pSearchList.split("##");
            searchParemeta = new String[searchList.length];
            
            logger.debug("searchList.length=" + searchList.length);
            
            for (i = 0; i < searchList.length; i++){      	
                searchInfo = searchList[i].split("@@");

                if (i == 0){
                    // 수정(2007.06.26) : 검색 시 특정 필드(이름/부서명/직위)의 경우 Primary/Secondary 값을 모두 검색하도록 수정
                    //searchParemeta[i] = searchInfo[1].replace("[", "[[]").replace("%", "[%]").replace("_", "[_]");
                	
                	//수정(2017-01-23)
                	// 검색 시 _가 들어간 문자가 검색이 안되어, [_]로 replace하는부분 제거
                	searchParemeta[i] = searchInfo[1].replaceAll("%", "\\%").replaceAll("'", "\\'").replaceAll("_", "\\_");
                	
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
                    searchParemeta[i] = searchInfo[1].replaceAll("%", "\\\\%").replaceAll("'", "\\\\'").replaceAll("_", "\\_");;
                    
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
                        
            type = "U";
        }else{
        	type = "G";
        }
        
        Map<String, Object> map = new HashMap<String, Object>();
                
        map.put("strSQL", strSQL + strSize);
        map.put("strSQLForMySQL", strSQL);
        map.put("strSizeForMySQL", strSizeForMySQL);
        map.put("strGyumjikForOracle", strSQL.replace("department", "deptID"));
        map.put("type", type);
        map.put("class", pClass);
        map.put("v_TENANT_ID", tenantID);
        
        logger.debug("strSQL=" + strSQL);
        
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
	        		map1.put("v_LANGDATA", primary);
	        		map1.put("v_TENANT_ID", tenantID);
	        		
	        		result = ezOrganDAO.getTBLUserMaster(map1);	        		
	        	}else{
	        		map1.put("v_CN", organVO.getCn());
					map1.put("v_LANGDATA", primary);
					map1.put("v_TENANT_ID", tenantID);
					
					result = ezOrganDAO.getTBLDeptMaster(map1);	        		
				}
				
				sb.append(commonUtil.getQueryResult(result));
				sb.append("</DATA>");
				
				listInfo = getMemberInfo(sb.toString(), pCellList, pPropList, "", organVO.getType());
				memberlist2.append(listInfo);
			}			
		}
		memberlist2.append("</ROWS></LISTVIEWDATA>");

		logger.debug("getSearchList ended");
		
		return memberlist2.toString();
	}
	
	@Override
	public String getSearchListOR(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String primary, int tenantID, String companyId) throws Exception {
		logger.debug("getSearchListOR started");
		
        String[] searchParemeta = null;
        String[] searchList;
        String[] searchInfo;
        String listInfo = "";
        String strSize = "";
        String strSizeForMySQL = "";
        String strSQL = "";        
        String type = "";        
        int i = 0;
        String companyID = companyId.equals("Top") ? "" : companyId;
        
        if (pLimit != 0) {
            strSize = " AND ROWNUM <= " + pLimit;
            strSizeForMySQL = " LIMIT " + pLimit;
        }
        
        if (!pSearchList.equals("")){
            pSearchList = pSearchList.replace(";;", "##");
            pSearchList = pSearchList.replace("::", "@@");
            searchList = pSearchList.split("##");
            searchParemeta = new String[searchList.length];
            
            logger.debug("searchList.length=" + searchList.length);
            
            for (i = 0; i < searchList.length; i++){      	
                searchInfo = searchList[i].split("@@");

                if (i == 0){
                    // 수정(2007.06.26) : 검색 시 특정 필드(이름/부서명/직위)의 경우 Primary/Secondary 값을 모두 검색하도록 수정
                    //searchParemeta[i] = searchInfo[1].replace("[", "[[]").replace("%", "[%]").replace("_", "[_]");
                	
                	//수정(2017-01-23)
                	// 검색 시 _가 들어간 문자가 검색이 안되어, [_]로 replace하는부분 제거
                	searchParemeta[0] = searchInfo[1].replace("%", "\\%").replace("_", "\\_");
                	
                    if (checkSearchField(searchInfo[0])){
                        if (searchInfo[0].toUpperCase().equals("DISPLAYNAME") && searchParemeta[0].toString().equals("/")){
                            strSQL = strSQL + " WHERE (" + searchInfo[0].toLowerCase() + " = '" + searchParemeta[0] + "' OR " + searchInfo[0].toLowerCase() + "2 = '" + searchParemeta[0] + "'";
                            searchParemeta[0] = searchParemeta[0].substring(0, searchParemeta[0].length() - 1);
                        }else{
                            strSQL = strSQL + " WHERE (" + searchInfo[0].toLowerCase() + " LIKE  '%" + searchParemeta[0] + "%' OR " + searchInfo[0].toLowerCase() + "2 LIKE '%" + searchParemeta[0] + "%'";
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
                    searchParemeta[i] = searchInfo[1].replace("%", "\\%").replace("_", "\\_");
                    
                    // 20180628 - 기존 AND 조건이 아닌, OR 조건으로 검색
                    if (checkSearchField(searchInfo[0])){
                        strSQL = strSQL + " OR " + searchInfo[0].toLowerCase() + " LIKE  '%" + searchParemeta[i] + "%' OR " + searchInfo[0].toLowerCase() + "2 LIKE '%" + searchParemeta[i] + "%'";
                    }else{
                        if (searchInfo[0].indexOf("EXACT_") == 0){
                            strSQL = strSQL + " OR " + searchInfo[0].substring(6).toLowerCase() + "='" + searchParemeta[i] + "'";
                        }else if (searchInfo[0].indexOf("LEFT_") == 0){
                            strSQL = strSQL + " OR " + searchInfo[0].substring(5).toLowerCase() + " LIKE '" + searchParemeta[i] + " %'";
                        }else if (searchInfo[0].indexOf("RIGHT_") == 0){
                            strSQL = strSQL + " OR " + searchInfo[0].substring(5).toLowerCase() + " LIKE '%" + searchParemeta[i] + "%'";
                        }else{
                            strSQL = strSQL + " OR " + searchInfo[0].toLowerCase() + " LIKE '%" + searchParemeta[i] + "%'";
                        }
                    }
                }
            }
            strSQL = strSQL + ") ";
        }        
        
        if (pClass.equals("user") || pClass.equals("all")){
            strSQL = strSQL.replace("cn", "a.cn");
            strSQL = strSQL.replace("title", "a.title");
                        
            type = "U";
        }else{
        	type = "G";
        }

        Map<String, Object> map = new HashMap<String, Object>();
                
        map.put("strSQL", strSQL + strSize);
        map.put("strSQLForMySQL", strSQL);
        map.put("strSizeForMySQL", strSizeForMySQL);
        map.put("strGyumjikForOracle", strSQL.replace("department", "deptID"));
        map.put("type", type);
        map.put("class", pClass);
        map.put("v_TENANT_ID", tenantID);
        map.put("companyId", companyID); // top이면 '' 공백
        
        logger.debug("strSQL=" + strSQL);
        
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
	        		map1.put("v_LANGDATA", primary);
	        		map1.put("v_TENANT_ID", tenantID);
	        		
	        		result = ezOrganDAO.getTBLUserMaster(map1);	        		
	        	}else{
	        		map1.put("v_CN", organVO.getCn());
					map1.put("v_LANGDATA", primary);
					map1.put("v_TENANT_ID", tenantID);
					
					result = ezOrganDAO.getTBLDeptMaster(map1);	        		
				}
				
				sb.append(commonUtil.getQueryResult(result));
				sb.append("</DATA>");
				
				listInfo = getMemberInfo(sb.toString(), pCellList, pPropList, "", organVO.getType());
				memberlist2.append(listInfo);
			}			
		}
		memberlist2.append("</ROWS></LISTVIEWDATA>");

		logger.debug("getSearchListOR ended");
		
		return memberlist2.toString();
	}
	
    @Override
    public String getSearchListPagination(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String pLangCode, String page, int tenantID, String companyId) throws Exception {
    	logger.debug("getSearchListPagination started");
    	
        String strSQL="";
        String strSQLCom="";
        String strSQLAddjobCom="";
        int i=0;
        String[] SearchList;
        String[] SearchInfo;
        String ListInfo="";
        String[] SearchParemeta=null;
        String type = "";
        StringBuilder memberlist2 = null;
        try {
	        if (!pSearchList.equals("")){
	               pSearchList = pSearchList.replace(";;", "##");
	               pSearchList = pSearchList.replace("::", "@@");
	               SearchList  = pSearchList.split("##");
	               
	               SearchParemeta = new String[SearchList.length];
	               
	               logger.debug("searchList.length=" + SearchList.length);
	               
	               for(i = 0; i < SearchList.length; i++){
	                   SearchInfo = SearchList[i].split("@@");
	                   
	                   if(i == 0){
	                       // 수정(2007.06.26) : 검색 시 특정 필드(이름/부서명/직위)의 경우 Primary/Secondary 값을 모두 검색하도록 수정
	                       SearchParemeta[i] = SearchInfo[1].replaceAll("%", "\\\\%").replaceAll("'", "\\\\'").toLowerCase();
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
	                       SearchParemeta[i] = SearchInfo[1].replaceAll("%", "\\\\%").replaceAll("'", "\\\\'").toLowerCase();
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
	                          
	             type = "U";
	        }
	        else{
	        	type = "G";
	        }
	        
	        logger.debug("searchList : " + pSearchList.split("@@")[0]);
	        if (!companyId.equals("")) {
	        	strSQLCom = "AND PHYSICALDELIVERYOFFICENAME = '" + companyId + "'";
	        	if (type.equals("G")) {
	        		strSQLCom = strSQLCom.replace("PHYSICALDELIVERYOFFICENAME", "EXTENSIONATTRIBUTE2");
	        	}
	        	
	        	strSQLAddjobCom = "AND a.DEPTID IN (SELECT cn FROM TBL_DEPTMASTER WHERE EXTENSIONATTRIBUTE2 = '" + companyId + "')";
	        	if (pSearchList.split("@@")[0].equals("description")){
	        		strSQLAddjobCom = strSQLAddjobCom.replace("a.DEPTID", "b.PHYSICALDELIVERYOFFICENAME");
	        	}
	        	
	        }
	        
	        if(page.equals(null) || page.equals("")){
	            page = "1";
	        }
	        
	         int startRow = (Integer.parseInt(page) - 1) * 50 + 1;
	         int endRow = Integer.parseInt(page) * 50 + 1;
	         
	         Map<String , Object> map = new HashMap<String , Object>();
	                  
	         map.put("strSQL" , strSQL);
	         map.put("type", type);
	         map.put("class", pClass);
	         map.put("startRow", startRow);
	         map.put("endRow", endRow);
	         map.put("v_TENANT_ID", tenantID);
	         map.put("startRowForMySQL", startRow - 1);
	         map.put("count", 50);        
	         map.put("strSQLCom", strSQLCom);  
	         map.put("strSQLAddjobCom", strSQLAddjobCom);
	         
	         logger.debug("strSQL=" + strSQL);
	         logger.debug("strSQLCom=" + strSQLCom);
	         logger.debug("strSQLAddjobCom=" + strSQLAddjobCom);
	         
	         List<OrganDeptVO> list = ezOrganDAO.organSearchListPage(map);
	         
	         if(pClass.equals("user")){
	        	 int totalcount = ezOrganDAO.getSearchListCount(map);
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
	                
	                ListInfo = getMemberInfo(sb.toString(), pCellList, pPropList, "", organVO.getType());
	                memberlist2.append(ListInfo);
	            }           
	        }
	        memberlist2.append("</ROWS></LISTVIEWDATA>");
        } catch (Exception e) {
        	memberlist2 = new StringBuilder("<LISTVIEWDATA>");
            memberlist2.append("<TOTALCOUNT>" + "0" + "</TOTALCOUNT><ROWS>");
            memberlist2.append("</ROWS></LISTVIEWDATA>");
        }
        logger.debug("getSearchListPagination ended");
        
        return memberlist2.toString();
    }
	
	// 사원이거나 부서의 경우 특정 속성에 대해 Primary 언어용 속성과 Secondary 언어용 속성을 추가하여 반환한다.
	public String convertAddandConvert(String pClass, String pProvValue) {
	    logger.debug("convertAddandConvert started");
	    logger.debug("pClass=" + pClass + ",pProvValue=" + pProvValue);
	    
        String[] arryProvValue = pProvValue.split(";");
        String returnValue = "";
        String addPopList = pProvValue;
        
        for (int i = 0; i < arryProvValue.length; i++) {
            returnValue = "";
            returnValue = addPropList(pClass, arryProvValue[i]);
            
            if (!returnValue.equals("")) {
            	addPopList = addPopList + ";" + returnValue;
            }
        }
        
        logger.debug("addPopList=" + addPopList);
        logger.debug("convertAddandConvert ended");
        
        return addPopList;              
    }
	
	// 사원이거나 부서의 경우 특정 속성에 대해 Primary 언어용 속성과 Secondary 언어용 속성으로 변환한다.
	private String addPropList(String pType, String pAttribute) {
    	String strRet = "";

        if (!pType.equals("user")) {
            // 부서
            switch (pAttribute.toUpperCase()) {
                case "DISPLAYNAME": strRet = "displayName1;displayName2";
                    break;
                case "DESCRIPTION": strRet = "description1;description2";
                    break;
                case "COMPANY": strRet = "company1;company2";
                    break;
                default: strRet = "";
                    break;
            }
        } else {
        	//사용자
            switch (pAttribute.toUpperCase()) {
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
                case "USERTYPE":
                	strRet = "usertype";
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
	    logger.debug("getPropertyList started");
	    logger.debug("id=" + id + ",pPropList=" + pPropList + ",primary=" + primary + ",tenantID=" + tenantID);
	    
		String propValue = "";
		StringBuilder propInfo = new StringBuilder("<DATA>");
		
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
		
		if (xmldom == null || xmldom.getElementsByTagName("ROW").getLength() == 0) {
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
		
        for (String propname : propList) {
        	if (checkDBColum(propname.toUpperCase()) == false) {
                propValue = getPropertyValue(id, propname, tenantID);
                propInfo.append("<" + propname.toUpperCase() + ">" + commonUtil.cleanValue(propValue) + "</" + propname.toUpperCase() + ">");
            } else if (!propname.toUpperCase().equals("")) {            	
                if (xmldom != null && xmldom.getElementsByTagName(propname.toUpperCase()).getLength() > 0) {
                    propInfo.append("<" + propname.toUpperCase() + ">" + commonUtil.cleanValue(xmldom.getElementsByTagName(propname.toUpperCase()).item(0).getTextContent()) + "</" + propname.toUpperCase() + ">");
                } else {
                    propInfo.append("<" + propname.toUpperCase() + "></" + propname.toUpperCase() + ">");
                }
            }
        }
        
        propInfo.append("</DATA>");

        logger.debug("propInfo=" + propInfo);
        logger.debug("getPropertyList ended");
        
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
		
		if (userVO != null) {
			StringBuilder stb = new StringBuilder();		
			
			stb.append("<ROW>");
	        stb.append("<TITLE>");
	        stb.append(commonUtil.cleanValue(userVO.getTitle()));
	        stb.append("</TITLE>");
	        stb.append("<DISPLAYNAME>");
	        stb.append(commonUtil.cleanValue(userVO.getDisplayName()));
	        stb.append("</DISPLAYNAME>");		           
	        stb.append("<COMPANY>");
	        stb.append(commonUtil.cleanValue(userVO.getCompany()));
	        stb.append("</COMPANY>");		           
			stb.append("</ROW>");
			strXML = stb.toString();
		}
		
		return strXML;
	}

	@Override
	public String getOrganTreeInfo(String strFilter, int intScope) throws Exception {
		List<String[]> ou = new ArrayList<String[]>();
		ou = ldapSearch(strFilter, "", intScope);
            
        StringBuilder nodeInfo = new StringBuilder("");

        nodeInfo.append("<TREEVIEWDATA>");

        nodeInfo.append("<TEXTCOLOR>");
        nodeInfo.append("<NAME>GRAY</NAME>");

        nodeInfo.append("<DEFAULTTEXTCOLOR>gray</DEFAULTTEXTCOLOR>");
        nodeInfo.append("<SELECTEDTEXTCOLOR>gray</SELECTEDTEXTCOLOR>");
        nodeInfo.append("</TEXTCOLOR>");

        nodeInfo.append("<NODEICONIMAGE>");
        nodeInfo.append("<NAME>ICONGROUP</NAME>");
        nodeInfo.append("<DEFAULT></DEFAULT>");

        nodeInfo.append("<LEAFDEFAULTICON>images/ic-close.gif</LEAFDEFAULTICON>");
        nodeInfo.append("<LEAFSELECTEDICON>images/ic-open.gif</LEAFSELECTEDICON>");
        nodeInfo.append("<BRANCHDEFAULTICON>images/ic-close.gif</BRANCHDEFAULTICON>");
        nodeInfo.append("<BRANCHSELECTEDICON>images/ic-close.gif</BRANCHSELECTEDICON>");
        nodeInfo.append("</NODEICONIMAGE>");

        nodeInfo.append("<NODEICONIMAGE>");
        nodeInfo.append("<NAME>ICONGROUP</NAME>");

        nodeInfo.append("<BRANCHDEFAULTICON>images/ic-company.gif</BRANCHDEFAULTICON>");
        nodeInfo.append("<BRANCHSELECTEDICON>images/ic-company.gif</BRANCHSELECTEDICON>");
        nodeInfo.append("</NODEICONIMAGE>");

        nodeInfo.append("<NODE>");
        nodeInfo.append("<VALUE>조직도</VALUE>");
        nodeInfo.append("<ISLEAF>FALSE</ISLEAF>");
        nodeInfo.append("<SETNODEICONBYNAME>ICONCOMP</SETNODEICONBYNAME>");
        nodeInfo.append("<EXPANDED>TRUE</EXPANDED>");
        nodeInfo.append("<NODES>");
            
        for (int i = 0; i < ou.size(); i++) {
            String pORGANIZATIONUNITNAME = ou.get(i)[0];

            String pOUCODE =  ou.get(i)[3];
            String pTOPOUCODE =  ou.get(i)[2];
            String pOURECEIVEDOCUMENTYN = ou.get(i)[7];

            nodeInfo.append("<NODE>");
            nodeInfo.append("<VALUE>" + pORGANIZATIONUNITNAME + "</VALUE>");
            
            nodeInfo.append("<DATA1>" + pOUCODE + "</DATA1>");
            nodeInfo.append("<DATA2>" + "ou=" + pORGANIZATIONUNITNAME + "," + "</DATA2>");
            nodeInfo.append("<DATA3>");
            
            if (pOURECEIVEDOCUMENTYN.trim().equals("") || pOURECEIVEDOCUMENTYN.trim().equals("N")) {
            	nodeInfo.append("N");
            } else {
            	nodeInfo.append("Y");
            }
            
            nodeInfo.append("</DATA3>");
            nodeInfo.append("<ISLEAF>FALSE</ISLEAF>");
            
            if (pOUCODE.toUpperCase().equals(pTOPOUCODE.toUpperCase())) {
            	 nodeInfo.append("<SETNODEICONBYNAME>ICONCOMP</SETNODEICONBYNAME>");
            }
            
            if (pOURECEIVEDOCUMENTYN.trim().equals("")|| pOURECEIVEDOCUMENTYN.trim().equals("N"))
            {
            	nodeInfo.append("<SETTEXTCOLORBYNAME>GRAY</SETTEXTCOLORBYNAME>");
            }
            nodeInfo.append("</NODE>");
        }
       
        nodeInfo.append("</NODES>");
        nodeInfo.append("</NODE>");
        nodeInfo.append("</TREEVIEWDATA>");
        
        return nodeInfo.toString();
	}

	@SuppressWarnings("rawtypes")
	private List<String[]> ldapSearch(String strFilter, String strBaseDN, int intScope) throws Exception {
		List<String[]> ou = new ArrayList<String[]>();
		Hashtable<String, String> env = new Hashtable<String, String>(5, 0.75f); 
        NamingEnumeration m_ne = null;
        String[] attrIDs = { "ucOrgFullName", "ou", "topOUCode", "ouCode", "parentOUCode", "ouLevel", "ouSendOutDocumentYN", "ouReceiveDocumentYN", "ucChiefTitle", "ouSMTPAddress", "ouDocumentRecipientSymbol", "repoUCCode", "ouOrder"};
       
        env.put(Context.PROVIDER_URL, config.getProperty("R_LServer")); 
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory"); 
        DirContext dirCtx = new InitialDirContext(env); 
        SearchControls constraints = new SearchControls();
		
		if (intScope == 0) {
            constraints.setSearchScope(SearchControls.SUBTREE_SCOPE); 
		} else {
			if (intScope == 1) {
	            constraints.setSearchScope(SearchControls.ONELEVEL_SCOPE); 
			} else {
	            constraints.setSearchScope(SearchControls.SUBTREE_SCOPE); 
			}
		}
		
        if (attrIDs != null) {
            constraints.setReturningAttributes(attrIDs);
        }
        
        m_ne = dirCtx.search(strBaseDN + config.getProperty("R_LBaseDN"), strFilter, constraints); 
        
        dirCtx.close(); 
        
        while (m_ne.hasMoreElements()) {
        	SearchResult sr = (SearchResult)m_ne.next(); 
            String str[] = new String[13];
            
            for (int i = 0; i < attrIDs.length; i++) { 
            	if (sr.getAttributes().get(attrIDs[i]) == null || sr.getAttributes().get(attrIDs[i]).get().equals("")) {
            		if (attrIDs[i].equals("ouSendOutDocumentYN") || attrIDs[i].equals("ouReceiveDocumentYN")) {
            			str[i] = "N";
            		} else {
            			str[i] = " ";
            		}
            	} else {
            		str[i] = (String)sr.getAttributes().get(attrIDs[i]).get();
            	}
            } 
            ou.add(str); 
        }
  
        Collections.sort(ou, new Comparator<String[]>(){
        	@Override
            public int compare(String[] o1, String[] o2) {
                return  o1[2].compareTo(o2[2]);
            }
        });
        
		return ou;
	}
	
	@Override
	public String getEncPassword(String dUserID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", dUserID);
		map.put("tenantID", tenantID);
		
		return ezOrganDAO.getEncPassword(map);
	}

	@Override
	public String updateProperty(String userID, String propName, String propValue, String pClass, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_CN", userID);
		map.put("v_CLASS", pClass);
		map.put("v_PROPNAME", propName);
		map.put("v_PROPVALUE", propValue);
		
        // 사원의 경우
    	if (pClass.toLowerCase().equals("user")) {
    		ezOrganDAO.updateProperty(map);
    	// 부서의 경우
    	} else {
    		ezOrganDAO.updateProperty_U(map);
    	}
		
        return "OK";		
	}

	@Override
	public String delProxyUserInfo(String userID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_TENANT_ID", tenantID);
		try {
			ezOrganDAO.delProxyUserInfo(map);
			
			return "OK";
		} catch (Exception e) {
			return "";
		}
	}

	@Override
	public String setProxyUserInfo(String userID, String proxyUserID, String proxyUserName, String proxyUserDeptID, String startDate, String endDate, int tenantID, String offset) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_PROXYUSERID", proxyUserID);
		map.put("v_PROXYUSERNAME", proxyUserName);
		map.put("v_PROXYUSERDEPTID", proxyUserDeptID);
		map.put("v_STARTDATE", commonUtil.getDateStringInUTC(startDate, offset, true));
		map.put("v_ENDDATE", commonUtil.getDateStringInUTC(endDate, offset, true));
		map.put("v_TENANT_ID", tenantID);

		String temp = ezOrganDAO.setProxyUserInfo_S(map);
		 
		if (temp != null && temp.equals("1")) {
			ezOrganDAO.setProxyUserInfo(map);
		} else {
			ezOrganDAO.setProxyUserInfo_I(map);
		}
		 
		return "OK";        		
	}

	@Override
	public String getProxyUserInfo(String userID, int tenantID, String offset) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_TENANT_ID", tenantID);
		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		
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
	public String getLastLogin(String userID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		return ezOrganDAO.getLastLogin(map);
	}
	
	@Override
	public String getLoginIP(String userID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		return ezOrganDAO.getLoginIP(map);
	}

	@Override
	public String getDeptReceipterIDs(String deptID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DEPTID", deptID);
		map.put("TENANTID", tenantID);
		List<OrganUserVO> organProxyVOList = ezOrganDAO.getDeptReceipterIDs(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < organProxyVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(organProxyVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	@Override
	public OrganProxyVO getProxyInfo(String userID, int tenantID, String offset) throws Exception {
		logger.debug("getProxyInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		
		OrganProxyVO proxyInfo = ezOrganDAO.getProxyInfo(map);

		logger.debug("getProxyInfo ended");
		
		return proxyInfo;
	}
	
	@Override
	public List<String> getAllSubDeptId(String deptID, int tenantID)
			throws Exception {	
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptId", deptID);
		map.put("tenantID", tenantID);
		return ezOrganDAO.getAllSubDeptId(map);
	}
	
	@Override
	public String getDeptPath(String deptID, int tenantID) throws Exception {		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptId", deptID);
		map.put("tenantID", tenantID);
		return ezOrganDAO.getDeptPath(map);
	}

	@Override
	public String getOrganSubTreeInfo(String strFilter, String strBaseDN, int intScope) throws Exception {
		logger.debug("getOrganSubTreeInfo started");
		
		List<String[]> ou = new ArrayList<String[]>();
		ou = ldapSearch(strFilter, strBaseDN, intScope);
		
		StringBuilder str = new StringBuilder();
		
		str.append("<NODES>");

		for (int i=0; i<ou.size(); i++) {
			str.append("<NODE>");
			str.append("<VALUE>" + ou.get(i)[1] + "</VALUE>");
			str.append("<DATA1>" + ou.get(i)[3] + "</DATA1>");
			str.append("<DATA2> ou=" + ou.get(i)[1] + "," + strBaseDN + "</DATA2>");
			str.append("<DATA3>");
			
			if (ou.get(i)[7].equals(" ") || ou.get(i)[7].equals("N")) {
				str.append("N");
			} else {
				str.append("Y");
			}
			
			str.append("</DATA3>");
			str.append("<ISLEAF>FALSE</ISLEAF>");
			
			if(ou.get(i)[3].toLowerCase().equals(ou.get(i)[2].toLowerCase())) {
				str.append("<SETNODEICONBYNAME>" + ou.get(i)[1] + "</SETNODEICONBYNAME>");
			}
			
			if (ou.get(i)[7].equals(" ") || ou.get(i)[7].equals("N")) {
				str.append("<SETTEXTCOLORBYNAME>GRAY</SETTEXTCOLORBYNAME>");
			}
			str.append("</NODE>");
		}
		str.append("</NODES>");
		logger.debug("getOrganSubTreeInfo ended");
		return str.toString();
	}


	@Override
	public String getOrgInfo(String strFilter, int intScope) throws Exception {
		logger.debug("getOrgInfo started");
		List<String[]> ou = new ArrayList<String[]>();
		ou = ldapSearch(strFilter, "", intScope);
	
		StringBuffer str = new StringBuffer();
		str.append("<ORGAN>");
		
		for(int i=0; i<ou.size(); i++) {
			str.append("<DATA1>" + ou.get(i)[3] + "</DATA1>");
			str.append("<DATA2> ou=" + ou.get(i)[1] + "," + config.getProperty("R_LBaseDN") + "</DATA2>");
			str.append("<DATA3>" + ou.get(i)[1]  + "</DATA3>");
			str.append("<DATA4>" + ou.get(i)[0]  + "</DATA4>");
			str.append("<DATA5>" + ou.get(i)[2]  + "</DATA5>");
			str.append("<DATA6>" + ou.get(i)[4]  + "</DATA6>");
			str.append("<DATA7>" + ou.get(i)[5]  + "</DATA7>");
			str.append("<DATA8>" + ou.get(i)[12]  + "</DATA8>");
			str.append("<DATA9>" + ou.get(i)[8]  + "</DATA9>");
			str.append("<DATA10>" + ou.get(i)[9]  + "</DATA10>");
			str.append("<DATA11>" + ou.get(i)[6]  + "</DATA11>");
			if (ou.get(i)[7].isEmpty() || ou.get(i)[7].equals("N")) {
				str.append("<DATA12>N</DATA12>");
			} else {
				str.append("<DATA12>" + ou.get(i)[7]  + "</DATA12>");
			}
			str.append("<DATA13>" + ou.get(i)[11]  + "</DATA13>");
		}
		str.append("</ORGAN>");
		logger.debug("getOrgInfo ended");	
		return str.toString();
	}

	@Override
	public String searchOuterOrgan(String strFilter, int intScope) throws Exception {
		logger.debug("getOrgInfo started");
		StringBuilder str = new StringBuilder();
		str.append("<LISTVIEWDATA>");
		str.append("<HEADERS>");
		str.append("<HEADER>");
		str.append("<NAME>" + "기관명" + "</NAME>");
		str.append("<WIDTH>" + "150" + "</WIDTH>");
		str.append("<COLNAME>" + "OUName" + "</COLNAME>");
		str.append("</HEADER>");
		
		str.append("<HEADER>");
		str.append("<NAME>" + "기관명(전체)" + "</NAME>");
		str.append("<WIDTH>" + "500" + "</WIDTH>");
		str.append("<COLNAME>" + "OuFullName" + "</COLNAME>");
		str.append("</HEADER>");
		str.append("</HEADERS>");
		
		List<String[]> ou = new ArrayList<String[]>();
		
		ou = ldapSearch(strFilter, "", intScope);
		
		str.append("<ROWS>");
		for (int i=0; i<ou.size(); i++) {
			str.append("<ROW>");
			str.append("<CELL>");

			str.append("<VALUE>" + ou.get(i)[1] + "</VALUE>");
			str.append("<DATA1>" + ou.get(i)[3] + "</DATA1>");
			str.append("<DATA2>" + ou.get(i)[1] + "</DATA2>");
			str.append("<DATA3>" + ou.get(i)[0] + "</DATA3>");
			str.append("<DATA4>" + ou.get(i)[2] + "</DATA4>");
			str.append("<DATA5>" + ou.get(i)[4] + "</DATA5>");
			str.append("<DATA6>" + ou.get(i)[8] + "</DATA6>");
			str.append("<DATA7>");
			
			if(ou.get(i)[7].equals("N") || ou.get(i)[7].equals(" ")) {
				str.append("GRAY");
			} else {
				str.append("YES");
			}
			str.append("</DATA7>");
			str.append("</CELL>");
			str.append("<CELL>");
			str.append("<VALUE>" + ou.get(i)[0] + "</VALUE>");
			str.append("</CELL>");
			str.append("</ROW>");
		}
		str.append("</ROWS>");
		str.append("</LISTVIEWDATA>");
		logger.debug("getOrgInfo started");
		return str.toString();
	}

	@Override
	//문서유통에서 해당 부서의 문서과 정보를 가지고 부서정보 가져오기.
	public List<OrganDeptVO> getExtensionAttr4ID(String strReceiveID) throws Exception {
		logger.debug("getExtensionAttr4ID started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("extension4", strReceiveID);
		
		List<OrganDeptVO> list = ezOrganDAO.getExtension4ID(map);
		logger.debug("getExtensionAttr4ID started");
		return list;
	}
	
	@Override
	public boolean checkRetired(String userID, String companyID, int tenantID) throws Exception {
		logger.debug("checkRetired started.");
		
		boolean chkValue = false;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		int count = ezOrganDAO.checkRetired(map);
		
		logger.debug("count = " + count);
		
		if (count != 0) {
			chkValue = true;
		}
		
		logger.debug("checkRetired ended. chkValue = " + chkValue);
		
		return chkValue;
	}
	
	public String getChildrenDeptID(String parentID, String companyID, int tenantID) throws Exception {
		logger.debug("getChildrenDeptID sratred.");
		
		JSONArray jArr = new JSONArray();
				
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PARENTID", parentID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		logger.debug("parentID : " + parentID + " companyID : " + companyID + " tenantID : " + tenantID);
		
		List<OrganDeptVO> list = ezOrganDAO.getChildrenDeptID(map);
		logger.debug("list : " + list.get(0).getCn().toString());
		
		for (int i = 0; i < list.size(); i++) {
			JSONObject jObj = new JSONObject();
			jObj.put("cn", list.get(i).getCn());
			jArr.add(jObj);
		}		
		
		logger.debug("jArr.toString : " + jArr.toString());
		
		logger.debug("getChildrenDeptID ended.");
		return jArr.toString();
	}

	public String isProxyUser(int tenantId, String userId, String nowDateTime) throws Exception {
		logger.debug("isProxyUser started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TENANT_ID", tenantId);
		map.put("v_CN",userId);
		map.put("nowDate",nowDateTime);
		
		String result = ezOrganDAO.getPropertyValue_S2(map);
		
		if (result == null) {
			result = "0";
		}
		
		logger.debug("result : " + result);
		
		logger.debug("isProxyUser ended");
		
		return result;
	}
	
	@Override
	public String setListType(String listType, String userID, int tenantID, String companyID) throws Exception {
		logger.debug("setListType started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("listType", listType);
		map.put("userID",userID);
		map.put("tenantID",tenantID);
		map.put("companyID", companyID);

		ezOrganDAO.setListType(map);
		
		logger.debug("setListType started");
		return "TRUE";
		
	}

	@Override
	public String getListType(String userID, int tenantID, String companyID) throws Exception {
		logger.debug("getListType started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		
		String listType = ezOrganDAO.getListType(map);
		
		logger.debug("getListType started");
		return listType;
		
	}
	
	@Override
	public String getSearchList(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String primary, String companyId, int tenantID, String noAddJob) throws Exception {
		logger.debug("getSearchList started");
		
        String[] searchParemeta = null;
        String[] searchList;
        String[] searchInfo;
        String listInfo = "";
        String strSize = "";
        String strSizeForMySQL = "";
        String strSQL = "";        
        String strSQLAddjobCom = "";
        String strSQLCom = "";
        String type = ""; 
        int i = 0;
        
        if (pLimit != 0) {
            strSize = " AND ROWNUM <= " + pLimit;
            strSizeForMySQL = " LIMIT " + pLimit;
        }
        
        if (!pSearchList.equals("")) {
            pSearchList = pSearchList.replace(";;", "##");
            pSearchList = pSearchList.replace("::", "@@");
            searchList = pSearchList.split("##");
            searchParemeta = new String[searchList.length];
            
            logger.debug("searchList.length=" + searchList.length);
            
            for (i = 0; i < searchList.length; i++){      	
                searchInfo = searchList[i].split("@@");

                if (i == 0) {
                    // 수정(2007.06.26) : 검색 시 특정 필드(이름/부서명/직위)의 경우 Primary/Secondary 값을 모두 검색하도록 수정
                    //searchParemeta[i] = searchInfo[1].replace("[", "[[]").replace("%", "[%]").replace("_", "[_]");
                	
                	//수정(2017-01-23)
                	// 검색 시 _가 들어간 문자가 검색이 안되어, [_]로 replace하는부분 제거
                	searchParemeta[i] = searchInfo[1].replaceAll("%", "\\\\%").replaceAll("'", "\\\\'");
                	
                    if (checkSearchField(searchInfo[0])){
                        if (searchInfo[0].toUpperCase().equals("DISPLAYNAME") && searchParemeta[0].toString().equals("/")){
                            strSQL = strSQL + " WHERE (" + searchInfo[0].toLowerCase() + " = '" + searchParemeta[i] + "' OR " + searchInfo[0].toLowerCase() + "2 = '" + searchParemeta[i]+ "')";// + " AND PHYSICALDELIVERYOFFICENAME = '" + companyId + "'";
                            searchParemeta[0] = searchParemeta[0].substring(0, searchParemeta[0].length() - 1);
                        }else{
                            strSQL = strSQL + " WHERE (" + searchInfo[0].toLowerCase() + " LIKE  '%" + searchParemeta[i] + "%' OR " + searchInfo[0].toLowerCase() + "2 LIKE '%" + searchParemeta[i] + "%')";// + " AND PHYSICALDELIVERYOFFICENAME = '" + companyId + "'";
                        }
                    }else{
                        if (searchInfo[0].indexOf("EXACT_") == 0){
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(6).toLowerCase() + "='" + searchParemeta[i] + "' ";
                        }else if (searchInfo[0].indexOf("LEFT_") == 0){
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(5).toLowerCase() + " LIKE '" + searchParemeta[i] + "%' ";
                        }else if (searchInfo[0].indexOf("RIGHT_") == 0){
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(5).toLowerCase() + " LIKE '%" + searchParemeta[i] + "%'";
                    	}else{
                            strSQL = strSQL + " WHERE " + searchInfo[0].toLowerCase() + " LIKE '%" + searchParemeta[i] + "%'"; // 아이디 검색
                    	}
                    }
                }else{
                    // 수정(2007.06.26) : 검색 시 특정 필드(이름/부서명/직위)의 경우 Primary/Secondary 값을 모두 검색하도록 수정
                    searchParemeta[i] = searchInfo[1].replaceAll("%", "\\\\%").replaceAll("'", "\\\\'");
                    
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
                        
            type = "U";
        }else{
        	type = "G";
        }

    	logger.debug("searchList : " + pSearchList.split("@@")[0]);
        if (!companyId.equals("")) {
        	strSQLCom = "AND PHYSICALDELIVERYOFFICENAME = '" + companyId + "'";
        	if (type.equals("G")) {
        		strSQLCom = strSQLCom.replace("PHYSICALDELIVERYOFFICENAME", "EXTENSIONATTRIBUTE2");
        	}
        	
        	strSQLAddjobCom = "AND a.DEPTID IN (SELECT cn FROM TBL_DEPTMASTER WHERE EXTENSIONATTRIBUTE2 = '" + companyId + "')";
        	if (pSearchList.split("@@")[0].equals("description")){
        		strSQLAddjobCom = strSQLAddjobCom.replace("a.DEPTID", "b.PHYSICALDELIVERYOFFICENAME");
        	}
        	
        }

        Map<String, Object> map = new HashMap<String, Object>();
                
        map.put("strSQL", strSQL + strSize);
        map.put("strSQLForMySQL", strSQL);
        map.put("strSizeForMySQL", strSizeForMySQL);
        map.put("strGyumjikForOracle", strSQL.replace("department", "deptID"));
        map.put("type", type);
        map.put("class", pClass);
        map.put("v_TENANT_ID", tenantID);
        map.put("strSQLCom", strSQLCom);
        map.put("strSQLAddjobCom", strSQLAddjobCom);
        map.put("noAddJob", noAddJob);
        
        logger.debug("strSQL=" + strSQL);
        logger.debug("strSQLCom=" + strSQLCom);//getSearchList
        logger.debug("strSQLAddjobCom=" + strSQLAddjobCom);
        
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
	        		map1.put("v_LANGDATA", primary);
	        		map1.put("v_TENANT_ID", tenantID);
	        		
	        		result = ezOrganDAO.getTBLUserMaster(map1);	        		
	        	}else{
	        		map1.put("v_CN", organVO.getCn());
					map1.put("v_LANGDATA", primary);
					map1.put("v_TENANT_ID", tenantID);
					
					result = ezOrganDAO.getTBLDeptMaster(map1);	        		
				}
				
				sb.append(commonUtil.getQueryResult(result));
				sb.append("</DATA>");
				
				listInfo = getMemberInfo(sb.toString(), pCellList, pPropList, "", organVO.getType());
				memberlist2.append(listInfo);
			}			
		}
		memberlist2.append("</ROWS></LISTVIEWDATA>");

		logger.debug("getSearchList ended");
		
		return memberlist2.toString();
	}
	
	@Override
	public String getPhysicalDeliveryOfficeName(String userID,  String property, int tenantID) throws Exception {
		
		logger.debug("getPhysicalDeliveryOfficeName started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("v_TENANT_ID", tenantID);
		
		logger.debug("getPhysicalDeliveryOfficeName ended");
		
		return ezOrganDAO.getPhysicalDeliveryOfficeName(map);
	}
}


