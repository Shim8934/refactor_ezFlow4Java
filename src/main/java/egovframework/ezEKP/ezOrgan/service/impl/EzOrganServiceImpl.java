package egovframework.ezEKP.ezOrgan.service.impl;
import com.microsoft.aad.msal4j.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.dao.EzOrganAdminDAO;
import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganJobVO;
import egovframework.ezEKP.ezOrgan.vo.OrganProxyVO;
import egovframework.ezEKP.ezOrgan.vo.OrganTeamsTreeVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezOrgan.vo.TeamsOrganVO;
import egovframework.ezEKP.ezTeams.dao.EzTeamsDAO;
import egovframework.ezEKP.ezTeams.service.EzTeamsService;
import egovframework.ezEKP.ezTeams.vo.TeamsPresenceVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
//import net.minidev.json.JSONArray;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import org.json.JSONArray;
import org.json.JSONObject;
//import net.minidev.json.JSONObject;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import javax.annotation.Resource;
import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.File;
import java.io.StringReader;
import java.lang.reflect.Field;
import java.net.URLDecoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.Set;
import java.util.concurrent.CompletableFuture;

@Service("EzOrganService")
public class EzOrganServiceImpl implements EzOrganService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzOrganServiceImpl.class);

	/** CRYPTO */
	@Resource(name="crypto")
	private EgovFileScrty egovFileScrty;

	@Resource(name = "EzOrganDAO")
	private EzOrganDAO ezOrganDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
    @Autowired
    private Properties config;

	@Autowired
	private LoginService loginService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;

	@Autowired
	private EzOrganAdminDAO ezOrganAdminDao;
	
	@Autowired
	private Properties globals;

	@Autowired
	private EzOrganDAO ezOrganDao;

	@Resource(name = "EzTeamsDAO")
	private EzTeamsDAO ezTeamsDAO;

	@Resource(name="EzTeamsService")
	private EzTeamsService ezTeamsService;
	
    // 지정된 사원 혹은 부서의 특정 필드의 값을 반환한다.
	@Override
	public String getPropertyValue(String userid, String propName, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TENANT_ID", tenantID);
		map.put("v_CN",userid);
		map.put("v_FIELD", propName.toUpperCase());
		
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

	@Override
	public String getDeptTreeInfo(String pUserID, String pDeptID, String pTopID, String pPropList, String primary, String displayTrashDept, int tenantID) throws Exception {
		return getDeptTreeInfo(pUserID, pDeptID, pTopID, pPropList, primary, displayTrashDept, tenantID, "N");
	}
	// 지정된 부서가 선택된 형태의 조직도 트리를 XML 형식으로 반환한다.
	@Override
	public String getDeptTreeInfo(String pUserID, String pDeptID, String pTopID, String pPropList, String primary, String displayTrashDept, int tenantID, String adminOrgan) throws Exception {
	    logger.debug("getDeptTreeInfo started");
	    logger.debug("pUserID=" + pUserID + ",pDeptID=" + pDeptID + ",pTopID=" + pTopID
	            + ",pPropList=" + pPropList + ",primary=" + primary + ",displayTrashDept=" + displayTrashDept + ",tenantID=" + tenantID);
	    
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
			map.put("displayTrashDept", displayTrashDept);
			map.put("adminOrgan", adminOrgan);
			
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
	                memberInfo[memberCount] = getTreeNodeInfo(result, pDeptID, prevDeptID, deptInfo, pPropList, "", adminOrgan);
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
		
        deptInfo = "<TREEVIEWDATA>" + getTreeNodeInfo(vo, pDeptID, prevDeptID, deptInfo, pPropList, isOrgan, adminOrgan) + "</TREEVIEWDATA>";
        
        logger.debug("deptInfo=" + deptInfo);
        logger.debug("getDeptTreeInfo ended");
        
        return deptInfo;
	}
	
	// 지정된 부서의 자식 부서 목록을 XML 형식으로 반환한다.
	// 폐지부서 표출 안 함, 숨김부터 표시 안 함
	@Override
	public String getDeptSubTreeInfo(String pDeptID, String pPropList, String primary, int tenantID) throws Exception {
		return getDeptSubTreeInfo(pDeptID, pPropList, primary, tenantID, false, "N");
	}
	
	// 지정된 부서의 자식 부서 목록을 XML 형식으로 반환한다.
	@Override
	public String getDeptSubTreeInfo(String pDeptID, String pPropList, String primary, int tenantID, boolean displayTrashDept, String adminOrgan) throws Exception {
	    logger.debug("getDeptSubTreeInfo started");
	    logger.debug("pDeptID=" + pDeptID + ",pPropList=" + pPropList + ",primary=" + primary + ",tenantID=" + tenantID);
	    
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CN", pDeptID);
		map.put("v_LANGDATA", primary);
		map.put("v_TENANT_ID", tenantID);
		map.put("adminOrgan", adminOrgan);

		if (displayTrashDept) {
			map.put("displayTrashDept", true);
		}
		
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

                memberInfo[memberCount] = getTreeNodeInfo(result, "", "", "", pPropList, "", adminOrgan);
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
	
	private String getTreeNodeInfo(OrganDeptVO vo, String pOrgDeptID, String pPrevDeptID, String pDeptInfo, String pPropList, String isOrgan, String adminOrgan) throws Exception {
		logger.debug("getTreeNodeInfo started");
		
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", vo.getTenantId());

		StringBuilder nodeInfo = new StringBuilder();
		
		nodeInfo.append("<NODE>");
		nodeInfo.append("<VALUE>" + commonUtil.cleanValue(vo.getDeptNM()) + "</VALUE>");
		nodeInfo.append("<VALUE1>" + commonUtil.cleanValue(vo.getDisplayName1()) + "</VALUE1>");
		nodeInfo.append("<VALUE2>" + commonUtil.cleanValue(vo.getDisplayName2()) + "</VALUE2>");
		nodeInfo.append("<CN>" + vo.getDepartment() + "</CN>");
		nodeInfo.append("<COMPANYID>" + vo.getExtensionAttribute2() + "</COMPANYID>");
	
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

		if (vo.getCn() != null && vo.getExtensionAttribute2() != null && vo.getCn().toLowerCase().equals(vo.getExtensionAttribute2().toLowerCase())) {
			isOrgan= "true";
		}
		// 부서의 자식 부서의 갯수를 구한다.
		int cnt = ezOrganDAO.deptSubDeptCnt(vo.getDepartment(), vo.getTenantId(), isOrgan, adminOrgan);
		
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
				if (vo.getUseUpperDeptBox() != null) { // 상위부서문서함 사용여부
					nodeInfo.append("<USEUPPERDEPTBOX>" + vo.getUseUpperDeptBox() + "</USEUPPERDEPTBOX>");
				}
			}
		}

		String deptTreeFlag = vo.getDeptTreeFlag() == null ? "N" : vo.getDeptTreeFlag();
		nodeInfo.append("<DEPTTREEFLAG>"+ deptTreeFlag +"</DEPTTREEFLAG>");
		
	    nodeInfo.append("</NODE>");

	    logger.debug("nodeInfo=" + nodeInfo.toString());
		logger.debug("getTreeNodeInfo ended");;
		
	    return nodeInfo.toString();
	}

	public List<OrganDeptVO> getDeptMemberList(String pClass, String deptID, String lang, int tenantID) throws Exception {
		logger.debug("getDeptMemberList started");
		logger.debug("deptID=" + deptID + ",lang=" + lang + ",tenantID=" + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
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
		return getDeptMemberList(pDeptID,pCellList,pPropList,pClass,pLangCode,tenantID,noAddJob,"n");
	}
	
	@Override
	public String getDeptMemberList(String pDeptID, String pCellList, String pPropList, String pClass, String pLangCode, int tenantID, String noAddJob,String adminOrgan) throws Exception {
		logger.debug("getDeptMemberList started");
		logger.debug("pDeptID=" + pDeptID + ",pCellList=" + pCellList + ",pPropList=" + pPropList
				+ ",pClass=" + pClass + ",pLangCode=" + pLangCode + ",tenantID=" + tenantID);

		String permissionBasisDeptYN = ezCommonService.getTenantConfig("permissionBasisDeptYN", tenantID);

	    // 2019-01-09 황윤호
		// 조직도 관리에서 부서장 column을 id -> name으로 바꿔주기 위해 사용
		String deptMaster = "";
		if(pClass != null && pClass.equals("groupDeptMaster")) {
			pClass = "group";
			deptMaster = "group";
		}
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> map1 = new HashMap<String, Object>();
		Map<String, Object> map2 = new HashMap<String, Object>();
		
		map.put("v_CLASS", pClass);
		map.put("v_CN", pDeptID);
		map.put("v_LANGDATA", pLangCode);
		map.put("v_TENANT_ID", tenantID);
		map.put("noAddJob", noAddJob);
		map.put("adminOrgan", adminOrgan);
		
		// 지정된 부서의 멤버 목록을 구한다.
		List<OrganDeptVO> list = ezOrganDAO.getDeptMemberList(map);
		
		int memberCount = 0;		
		List<String> memberInfo = new ArrayList<String>();
		//String[] memberInfo = new String[list.size()];
		
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
        		map1.put("IS_ADDJOB", obj.getIsAddjob());
        		map1.put("JOBID", obj.getJobId());
				map1.put("permissionBasisDeptYN", permissionBasisDeptYN);
        		map1.put("ROLEID", obj.getRoleId());

        		// 사원의 상세 정보를 가져온다.
				Object userVO = ezOrganDAO.getTBLUserMaster(map1);
				sb.append(commonUtil.getQueryResult(userVO));

            // 멤버가 부서인 경우
            } else {
            	map1.put("v_CN", obj.getCn());
        		map1.put("v_LANGDATA", pLangCode);
        		map1.put("v_TENANT_ID", tenantID);
        		map1.put("deptMaster", deptMaster);
        		                
        		// 자식 부서의 상세 정보를 가져온다.
        		Object deptVO = ezOrganDAO.getTBLDeptMaster(map1);
                sb.append(commonUtil.getQueryResult(deptVO));
            }
            
            sb.append("</DATA>");
            
            String cn = obj.getCn();

            //memberInfo[memberCount] = getMemberInfo(sb.toString(), pCellList, pPropList, cn, obj.getType());
            memberInfo.add(getMemberInfo(sb.toString(), pCellList, pPropList, cn, obj.getType()) );
            memberCount++;
        }
		
		map2.put("v_CN", pDeptID);
		map2.put("v_TENANT_ID", tenantID);
		
        StringBuilder memberlist = new StringBuilder("<LISTVIEWDATA><ROWS>");
        memberlist.append(String.join("", memberInfo));
        /*for (int i = 0; i < memberCount; i++) {
            memberlist.append(memberInfo[i]);
        }*/
        
        memberlist.append("</ROWS></LISTVIEWDATA>");
        
        return memberlist.toString();
	}

	@Override
	public String getDeptMemberListPagination(String pDeptID, String pCellList, String pPropList, String pClass, String pLangCode, String pPage, int tenantID) throws Exception {
		return getDeptMemberListPagination(pDeptID, pCellList, pPropList, pClass, pLangCode, pPage, tenantID, "N");
	}
	
	@Override
	public String getDeptMemberListPagination(String pDeptID, String pCellList, String pPropList, String pClass, String pLangCode, String pPage, int tenantID, String adminOrgan) throws Exception {
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
		map.put("adminOrgan", adminOrgan);
	
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
        		map1.put("IS_ADDJOB", obj.getIsAddjob());
        		map1.put("JOBID", obj.getJobId());
        		map1.put("ROLEID", obj.getRoleId());

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
	
	/**
	 * 하위부서 포함하여 카운트 필요시 사용
	 * 2024.07.19 한슬기 : 조직도 숨김처리 기능 사용시 관리자페이지, 사용자페이지 구분하기위해 오버로딩
	 * @param companyList 하위회사 목록
	 * @param containLow YES일때 본인포함 하위, NO일때 본인제외 하위 (하위가 회사인경우를 위해 추가함)
	 * @param tenantID
	 * @param adminOrgan y: 관리자페이지에서 호출, n: 사용자페이지에서 호출
	 * @return
	 * @throws Exception
	 */
	@Override
	public int getMemberListCount2(String deptCN, List<String> companyList, int totalCount, String containLow, int tenantID, String adminOrgan) throws Exception {
		logger.debug("getMemberListCount2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptCN", deptCN);
		map.put("containConfig", containLow);
		map.put("tenantID", tenantID);
		map.put("adminOrgan", adminOrgan);
		
		totalCount = ezOrganDAO.getMemberListCount2(map);
		
		logger.debug("totalCount2 = {}, adminOrgan = {} ", totalCount, adminOrgan);
		
		logger.debug("getMemberListCount2 ended.");
		
		return totalCount;
	}	
	
	public int getDeptMemberListCount(String deptID, boolean containLow, String primary, int tenantID) throws Exception {
		return getDeptMemberListCount(deptID,containLow,primary,tenantID,"n");
	}
	
	public int getDeptMemberListCount(String deptID, boolean containLow, String primary, int tenantID, String adminOrgan) throws Exception {
		logger.debug("getDeptMemberListCount started.");
		logger.debug("deptID = " + deptID + " || containLow = " + containLow + " || primary = " + primary + " || tenantID = " + tenantID);
		
		int totalCount = 0;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CN", deptID);
		map.put("v_TENANT_ID", tenantID);
		map.put("adminOrgan", adminOrgan);		
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
        	boolean isAbsence = false;
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
            // 부재자 YN 날짜계산
            if(celllist[i].toUpperCase().equals("EXTENSIONATTRIBUTE5") && !cellvalue.equals("")) {
            	String cellValSplit[] = cellvalue.split("[:]");
            	
            	if(cellValSplit.length > 5) {
            		String absenceFromDateStr = cellValSplit[3]+":"+cellValSplit[4];
            		String absenceToDateStr = cellValSplit[5]+":"+cellValSplit[6];
                	
            		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                	try {
    					Date curDate = dateFormat.parse(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm"), "235|+09:00", false));
    					Date absenceFromDate  = dateFormat.parse(absenceFromDateStr);
    					Date absenceToDate  = dateFormat.parse(absenceToDateStr);
    					
    					if(absenceFromDate.before(curDate) && absenceToDate.after(curDate)) {
    						isAbsence = true;
    					}
    				} catch (ParseException e) {
    					logger.error("dateFormat.parse(dateFormat.format(new Date())) error :: " + e);
    					logger.error(e.getMessage(), e);
    				} catch (Exception ee) {
    				    logger.error(ee.getMessage(), ee);
    				}
            	}
            	
            	if(isAbsence) {
            		cellvalue = "Y";
            	} else {
            		cellvalue = "";
            	}
            	nodeInfo.append("<CELL><VALUE>" + commonUtil.cleanValue(cellvalue) + "</VALUE>");
            } else {
            	nodeInfo.append("<CELL><VALUE>" + commonUtil.cleanValue(cellvalue) + "</VALUE>");
            }

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
                        
						/* 2024-07-19 양지혜 - 전자결재G > 상위부서문서함 사용 체크 */
						if (!proplist[j].equals("useupperdeptbox")) {
							nodeInfo.append("<DATA" + (j + 3) + ">" + commonUtil.cleanValue(propvalue) + "</DATA" + (j + 3) + ">");	
						} else {
							nodeInfo.append("<USEUPPERDEPTBOX>" + commonUtil.cleanValue(propvalue) + "</USEUPPERDEPTBOX>");
						}
                    }
                }
            }
            if(celllist[i].toUpperCase().equals("EXTENSIONATTRIBUTE5")) {
            	if(isAbsence) {
            		nodeInfo.append("<ABSENCE>" + doc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent() + "</ABSENCE>");
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
	public String getSearchList(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String primary, int tenantID, String adminOrgan) throws Exception {
		logger.debug("getSearchList started");
		
        String[] searchParam = null;
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
            //strSizeForMySQL = " LIMIT " + pLimit;
        }
        
        if (!pSearchList.equals("")){
            pSearchList = pSearchList.replace(";;", "##");
            pSearchList = pSearchList.replace("::", "@@");
            searchList = pSearchList.split("##");
            searchParam = new String[searchList.length];
            
            logger.debug("searchList.length=" + searchList.length);
            
            String escapeString = " ";
            if (globals.getProperty("Globals.DbType").equals("oracle")) {
            	escapeString = " escape '\\' ";
            }
            
            for (i = 0; i < searchList.length; i++) {      	
                searchInfo = searchList[i].split("@@");
                String searchVal =  URLDecoder.decode(searchInfo[1], "utf-8");
                searchParam[i] = searchVal.replace("'", "\\'");
            	String escapedSearchParam = searchParam[i].replace("%", "\\%").replace("_", "\\_");
            	
                if (i == 0) {
                	if (checkSearchField(searchInfo[0])) {
                        if (searchInfo[0].toUpperCase().equals("DISPLAYNAME") && searchParam[0].toString().equals("/")) {
                            strSQL = strSQL + " WHERE ( " + searchInfo[0].toLowerCase() + " = '" + searchParam[i] + "' OR " + searchInfo[0].toLowerCase() + "2 = '" + searchParam[i] + "')";
                            searchParam[0] = searchParam[0].substring(0, searchParam[0].length() - 1);
                        } else {
                            strSQL = strSQL + " WHERE ( " + searchInfo[0].toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString 
                            		+ " OR " + searchInfo[0].toLowerCase() + "2 LIKE '%" + escapedSearchParam + "%'" + escapeString + ")";
                        }
                    } else {
                        if (searchInfo[0].indexOf("EXACT_") == 0) {
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(6).toLowerCase() + " ='" + searchParam[i] + "' ";
                        } else if (searchInfo[0].indexOf("LEFT_") == 0) {
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(5).toLowerCase() + " LIKE '" + escapedSearchParam + "%'" + escapeString;
                        } else if (searchInfo[0].indexOf("RIGHT_") == 0) {
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(5).toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString;
                    	} else {
                            strSQL = strSQL + " WHERE " + searchInfo[0].toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString;
                    	}
                    }
                } else {
                    if (checkSearchField(searchInfo[0])) {
                        strSQL = strSQL + " AND ( " + searchInfo[0].toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString 
                        		+ " OR " + searchInfo[0].toLowerCase() + "2 LIKE '%" + escapedSearchParam + "%'" + escapeString + ")";
                    } else {
                        if (searchInfo[0].indexOf("EXACT_") == 0) {
                            strSQL = strSQL + " AND " + searchInfo[0].substring(6).toLowerCase() + " ='" + searchParam[i] + "' ";
                        } else if (searchInfo[0].indexOf("LEFT_") == 0) {
                            strSQL = strSQL + " AND " + searchInfo[0].substring(5).toLowerCase() + " LIKE '" + escapedSearchParam + " %'" + escapeString;
                        } else if (searchInfo[0].indexOf("RIGHT_") == 0) {
                            strSQL = strSQL + " AND " + searchInfo[0].substring(5).toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString;
                        } else {
                            strSQL = strSQL + " AND " + searchInfo[0].toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString;
                        }
                    }
                }
            }
        }        
        
        if (pClass.equals("user") || pClass.equals("all")){
            //strSQL = strSQL.replace("cn", "a.cn");
            //strSQL = strSQL.replace("title", "a.title");
        	
        	// 2024.06.27 한슬기 : 검색하려는 단어에 cn, userLoginId, title이 포함되어있으면 검색이 되지 않아 앞뒤로 공백추가
    		strSQL = strSQL.replace(" cn ", " a.cn ");
    		strSQL = strSQL.replace(" title ", " a.title ");
    		strSQL = strSQL.replace(" title2 ", " a.title2 ");
    		
            type = "U";
        }else{
        	type = "G";
        }

		String strSQLForAddJob = strSQL;
		if (ezCommonService.getTenantConfig("permissionBasisDeptYN", tenantID).equals("Y")) {
			strSQLForAddJob = strSQLForAddJob.replace(" extensionattribute1 ", " A.roll_info ");
			strSQLForAddJob = strSQLForAddJob.replace(" department ", " deptID ");
		}

		Map<String, Object> map = new HashMap<String, Object>();

        map.put("strSQL", strSQL + strSize);
        map.put("strSQLForMySQL", strSQL);
        map.put("pLimit", pLimit);
        //map.put("strSizeForMySQL", strSizeForMySQL);
        map.put("strGyumjikForOracle", strSQLForAddJob);
        map.put("type", type);
        map.put("class", pClass);
        map.put("v_TENANT_ID", tenantID);
        map.put("adminOrgan", adminOrgan);
		map.put("strSQLForAddJobForMySQL", strSQLForAddJob);
		map.put("adminOrgan", adminOrgan);
        
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
            		map1.put("IS_ADDJOB", organVO.getIsAddjob());
            		map1.put("JOBID", organVO.getJobId());
					map1.put("ROLEID", Optional.ofNullable(organVO.getRoleId()).filter(str -> !str.isEmpty()).orElse("0"));

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
//				String rowXml = getMemberInfo(sb.toString(), pCellList, pPropList, "", organVO.getType());
//				logger.debug("organVO.getCn()={}, getType()={}", organVO.getCn(), organVO.getType());
//				if ("dept".equalsIgnoreCase(organVO.getType())) {
//					Map<String, Object> param = new HashMap<>();
//					param.put("v_CN", organVO.getCn());
//					param.put("v_ADMINFLAG", "N"); // 일단 임의로 N
//					int subDeptCnt = ezOrganDAO.getSubDeptCount(param);
//					logger.debug("subDeptCnt={}", subDeptCnt);
//					organVO.setIsLeaf(subDeptCnt > 0 ? "FALSE" : "TRUE");
//				}
//				if ("group".equalsIgnoreCase(organVO.getType()) || "dept".equalsIgnoreCase(organVO.getType())) {
//					String extra = "<ISLEAF>" + (organVO.getIsLeaf() == null ? "TRUE" : organVO.getIsLeaf().toUpperCase()) + "</ISLEAF>"
//							+ "<HASDEPT>" + (organVO.getHasDept() == null ? "FALSE" : organVO.getHasDept().toUpperCase()) + "</HASDEPT>"
//							+ "<HASDEPTUSER>" + (organVO.getHasDeptUser() == null ? "FALSE" : organVO.getHasDeptUser().toUpperCase()) + "</HASDEPTUSER>";
//
//					rowXml = rowXml.replaceFirst("</CELL>", extra + "</CELL>");
//				}
//				logger.debug("rowXml 1={}", rowXml);
				memberlist2.append(listInfo);
//				memberlist2.append(rowXml);
			}			
		}
		memberlist2.append("</ROWS></LISTVIEWDATA>");

		logger.debug("getSearchList ended");
		
		return memberlist2.toString();
	}
	
	@Override
	public String getSearchListOR(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String primary, int tenantID, String companyId) throws Exception {
		logger.debug("getSearchListOR started");
		
        String[] searchParam = null;
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
            //strSizeForMySQL = " LIMIT " + pLimit;
        }
        
        if (!pSearchList.equals("")){
            pSearchList = pSearchList.replace(";;", "##");
            pSearchList = pSearchList.replace("::", "@@");
            searchList = pSearchList.split("##");
            searchParam = new String[searchList.length];
            String escapeString = " ";
            if (globals.getProperty("Globals.DbType").equals("oracle")) {
            	escapeString = " escape '\\' ";
            } 
            logger.debug("searchList.length=" + searchList.length);
            
            for (i = 0; i < searchList.length; i++) {      	
                searchInfo = searchList[i].split("@@");
                searchParam[i] = searchInfo[1].replace("'", "\\'");
                String escapedSearchParam = searchParam[i].replace("%", "\\%").replace("_", "\\_");
                if (i == 0) {
                    if (checkSearchField(searchInfo[0])) {
                        if (searchInfo[0].toUpperCase().equals("DISPLAYNAME") && searchParam[0].toString().equals("/")) {
                            strSQL = strSQL + " WHERE (" + searchInfo[0].toLowerCase() + " = '" + searchParam[i] 
                            		+ "' OR " + searchInfo[0].toLowerCase() + "2 = '" + searchParam[i] + "'";
                            searchParam[0] = searchParam[0].substring(0, searchParam[0].length() - 1);
                        } else {
                            strSQL = strSQL + " WHERE (" + searchInfo[0].toLowerCase() + " LIKE  '%" + escapedSearchParam + "%'" + escapeString 
                            		+ " OR " + searchInfo[0].toLowerCase() + "2 LIKE '%" + escapedSearchParam + "%'" + escapeString;
                        }
                    } else {
                        if (searchInfo[0].indexOf("EXACT_") == 0) {
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(6).toLowerCase() + "='" + searchParam[i] + "' ";
                        } else if (searchInfo[0].indexOf("LEFT_") == 0) {
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(5).toLowerCase() + " LIKE '" + escapedSearchParam + "%'" + escapeString;
                        } else if (searchInfo[0].indexOf("RIGHT_") == 0) {
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(5).toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString;
                    	} else {
                            strSQL = strSQL + " WHERE " + searchInfo[0].toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString;
                    	}
                    }
                } else {
                    // 20180628 - 기존 AND 조건이 아닌, OR 조건으로 검색
                    if (checkSearchField(searchInfo[0])) {
                        strSQL = strSQL + " OR " + searchInfo[0].toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString + "OR " + searchInfo[0].toLowerCase() + "2 LIKE '%" + escapedSearchParam + "%'" + escapeString ;
                    } else {
                        if (searchInfo[0].indexOf("EXACT_") == 0) {
                            strSQL = strSQL + " OR " + searchInfo[0].substring(6).toLowerCase() + "='" + searchParam[i] + "'";
                        } else if (searchInfo[0].indexOf("LEFT_") == 0) {
                            strSQL = strSQL + " OR " + searchInfo[0].substring(5).toLowerCase() + " LIKE '" + escapedSearchParam + "%'" + escapeString ;
                        } else if (searchInfo[0].indexOf("RIGHT_") == 0) {
                            strSQL = strSQL + " OR " + searchInfo[0].substring(5).toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString ;
                        } else {
                            strSQL = strSQL + " OR " + searchInfo[0].toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString ;
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
        //map.put("strSizeForMySQL", strSizeForMySQL);
        map.put("pLimit", pLimit);
        map.put("strGyumjikForOracle", strSQL.replace("department", "deptID"));
        map.put("type", type);
        map.put("class", pClass);
        map.put("v_TENANT_ID", tenantID);
        map.put("companyId", companyID); // top이면 '' 공백
        map.put("noAddJob", "Y");
        
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
            		map1.put("IS_ADDJOB", organVO.getIsAddjob());
            		map1.put("JOBID", organVO.getJobId());
	        		
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
    public String getSearchListPagination(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String pLangCode, String page, int tenantID, String companyId, String adminOrgan) throws Exception {
    	logger.debug("getSearchListPagination started");
    	
        String strSQL="";
        String strSQLCom="";
        String strSQLAddjobCom="";
        int i = 0;
        String[] searchList;
        String[] searchInfo;
        String ListInfo="";
        String[] searchParm = null;
        String type = "";
        StringBuilder memberlist2 = null;
        
        try {
        	if (!pSearchList.equals("")) {
        		pSearchList = pSearchList.replace(";;", "##");
        		pSearchList = pSearchList.replace("::", "@@");
        		searchList  = pSearchList.split("##");

        		searchParm = new String[searchList.length];

        		String escapeString = " ";
	            if (globals.getProperty("Globals.DbType").equals("oracle")) {
	            	escapeString = " escape '\\' ";
	            } 
	            
        		logger.debug("searchList.length=" + searchList.length);

        		for (i = 0; i < searchList.length; i++) {
        			searchInfo = searchList[i].split("@@");
        			String searchVal =  URLDecoder.decode(searchInfo[1], "utf-8");
        			searchParm[i] = searchVal.replace("'", "\\'");
        			String escapedSearchParam = searchParm[i].replace("%", "\\%").replace("_", "\\_");

        			if (i == 0) {
        				if (checkSearchField(searchInfo[0])) {
        					if (searchInfo[0].toUpperCase().equals("DISPLAYNAME") && searchParm[0].toString().equals(":")) {
        						strSQL = strSQL + " WHERE ( " + searchInfo[0].toLowerCase() + " =UPPER('" + searchParm[i] + "') OR " + searchInfo[0].toLowerCase() + "2 = UPPER('" + searchParm[i] + "'))";
        						searchParm[0] = searchParm[0].substring(0, searchParm[0].length() - 1);
        					} else {
        						strSQL = strSQL + " WHERE ( " + searchInfo[0].toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString + " OR " + searchInfo[0].toLowerCase() + "2 LIKE '%" + escapedSearchParam + "%'" + escapeString + ")";
        					}
        				} else {
        					if (searchInfo[0].indexOf("EXACT_") == 0) {
        						strSQL = strSQL + " WHERE " + searchInfo[0].substring(6).toLowerCase() + " =UPPER('" + searchParm[i] + "') ";
        					} else if (searchInfo[0].indexOf("LEFT_") == 0) {
        						strSQL = strSQL + " WHERE " + searchInfo[0].substring(5).toLowerCase() + " LIKE '" + escapedSearchParam + "%'" + escapeString;
        					} else if (searchInfo[0].indexOf("RIGHT_") == 0) {
        						strSQL = strSQL + " WHERE " + searchInfo[0].substring(5).toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString;
        					} else {
        						strSQL = strSQL + " WHERE " + searchInfo[0].toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString;
        					}
        				}
        			} else {
        				if (checkSearchField(searchInfo[0])) {
        					strSQL = strSQL + " AND ( " + searchInfo[0].toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString + "OR " + searchInfo[0].toLowerCase() + "2 LIKE '%" + escapedSearchParam + "%'" + escapeString +")";
        				} else {
        					if (searchInfo[0].indexOf("EXACT_") == 0) {
        						strSQL = strSQL + " AND " + searchInfo[0].substring(6).toLowerCase() + " =UPPER('" + searchParm[i] + "') ";
        					} else if (searchInfo[0].indexOf("LEFT_") == 0) {
        						strSQL = strSQL + " AND " + searchInfo[0].substring(5).toLowerCase() + " LIKE '" + escapedSearchParam + "%'" + escapeString;
        					} else if (searchInfo[0].indexOf("RIGHT_") == 0) {
        						strSQL = strSQL + " AND " + searchInfo[0].substring(5).toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString;
        					} else {
        						strSQL = strSQL + " AND " + searchInfo[0].toLowerCase() + " LIKE '%" + escapedSearchParam + "%'";
        					}
        				}
        			}
        		}
        	}

        	if (pClass.equals("user") || pClass.equals("all")) {
           		//strSQL = strSQL.replace("cn", "a.cn");
        		//strSQL = strSQL.replace("title", "a.title");
        		
        		// 2024.06.27 한슬기 : 검색하려는 단어에 cn, userLoginId, title이 포함되어있으면 검색이 되지 않아 앞뒤로 공백추가 
        		strSQL = strSQL.replace(" cn ", " a.cn ");
        		strSQL = strSQL.replace(" title ", " a.title ");
        		strSQL = strSQL.replace(" title2 ", " a.title2 ");

        		type = "U";
        	} else {
        		type = "G";
        	}

        	logger.debug("searchList : " + pSearchList.split("@@")[0]);
        	
        	if (!companyId.equals("")) {
        		/*strSQLCom = "AND PHYSICALDELIVERYOFFICENAME = '" + companyId + "'";
        		
        		if (type.equals("G")) {
        			strSQLCom = strSQLCom.replace("PHYSICALDELIVERYOFFICENAME", "EXTENSIONATTRIBUTE2");
        		}

        		strSQLAddjobCom = "AND a.DEPTID IN (SELECT cn FROM TBL_DEPTMASTER WHERE EXTENSIONATTRIBUTE2 = '" + companyId + "')";*/
        		
        		if (pSearchList.split("@@")[0].equals("description")) {
        			//strSQLAddjobCom = strSQLAddjobCom.replace("a.DEPTID", "b.PHYSICALDELIVERYOFFICENAME");
					strSQLAddjobCom = "description";
        		}
        	}

        	if (page == null || page.equals("")) {
        		page = "1";
        	}

        	int startRow = (Integer.parseInt(page) - 1) * 50 + 1;
        	int endRow = Integer.parseInt(page) * 50 + 1;

        	Map<String , Object> map = new HashMap<String , Object>();

        	map.put("strSQL" , strSQL);
        	map.put("type", type);
        	map.put("companyId", companyId);
        	map.put("class", pClass);
        	map.put("startRow", startRow);
        	map.put("endRow", endRow);
        	map.put("v_TENANT_ID", tenantID);
        	map.put("startRowForMySQL", startRow - 1);
        	map.put("count", 50);        
        	//map.put("strSQLCom", strSQLCom);
        	map.put("strSQLAddjobCom", strSQLAddjobCom);
        	map.put("adminOrgan", adminOrgan);
        	map.put("v_LANGDATA", pLangCode);

        	logger.debug("strSQL=" + strSQL);
        	logger.debug("strSQLCom=" + strSQLCom);
        	logger.debug("strSQLAddjobCom=" + strSQLAddjobCom);

        	List<OrganDeptVO> list = ezOrganDAO.organSearchListPage(map);

        	if (pClass.equals("user")) {
        		int totalcount = ezOrganDAO.getSearchListCount(map);
        		memberlist2 = new StringBuilder("<LISTVIEWDATA>");
        		memberlist2.append("<TOTALCOUNT>" + totalcount + "</TOTALCOUNT><ROWS>");
        	} else {
        		memberlist2 = new StringBuilder("<LISTVIEWDATA><ROWS>");
        	}

        	for (int j=0; j < list.size(); j++) {
        		Map<String, Object> map1 = new HashMap<String, Object>();           
        		OrganDeptVO organVO = list.get(j);
        		Object result = null;           

        		if (organVO.getCn() != null && !organVO.getCn().equals("")) {
        			StringBuilder sb = new StringBuilder();
        			sb.append("<DATA>");

        			if (organVO.getType().equals("user")) {
        				map1.put("v_CN", organVO.getCn());
        				map1.put("v_DEPTCD", organVO.getDisplayName());
        				map1.put("v_LANGDATA", pLangCode);
        				map1.put("v_TENANT_ID", tenantID);
                		map1.put("IS_ADDJOB", organVO.getIsAddjob());
                		map1.put("JOBID", organVO.getJobId());
                		map1.put("ROLEID", organVO.getRoleId());

        				result = ezOrganDAO.getTBLUserMaster(map1);                 
        			} else {
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
        	logger.error(e.getMessage(), e);
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
                case "EXTENSIONATTRIBUTE10":
                    bRet = true;
                    break;
            }
        }catch (Exception e){logger.debug("e.message=" + e.getMessage());}
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
        String[] propList = pPropList.toUpperCase().split(";");
		
        for (String propname : propList) {
			if (StringUtils.isBlank(propname)) continue;

			String propValue = null; // null 이면 cleanValue 에서 "" 빈 값 리턴한다.

			if (checkDBColum(propname)) {
                if (xmldom != null && xmldom.getElementsByTagName(propname).getLength() > 0) {
                    propValue = xmldom.getElementsByTagName(propname).item(0).getTextContent();
                }

            } else {
                propValue = getPropertyValue(id, propname, tenantID); // getPropertyValue 에서 propname 는 대문자로 사용된다.
            }

			propInfo.append("<" + propname + ">" + commonUtil.cleanValue(propValue) + "</" + propname + ">");
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
	        stb.append("<EXTENSIONATTRIBUTE10></EXTENSIONATTRIBUTE10>");		           
			stb.append("</ROW>");
			strXML = stb.toString();
		}
		
		return strXML;
	}

	@Override
	public String getUserAddjobInfoWithJobId(String id, String pDeptID, String primary, String jobID, int tenantID) throws Exception {
		String strXML = null;
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_TENANT_ID", tenantID);
		map.put("v_PCN", id);
		map.put("v_PDEPT", pDeptID);
		map.put("v_LANGDATA", primary);
		// 2024.05.16 장혜연 직원 상세정보 조회시 jobId도 고려되도록 추가
		map.put("v_jobID", jobID);

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
			stb.append("<EXTENSIONATTRIBUTE10>");
			stb.append(commonUtil.cleanValue(userVO.getRole()));
			stb.append("</EXTENSIONATTRIBUTE10>");
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
                return  o1[0].compareTo(o2[0]);
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
		map.put("v_PROPNAME", propName.toUpperCase());
		map.put("v_PROPVALUE", propValue);
		
        // 사원의 경우
    	if (pClass.toLowerCase().equals("user")) {
    		ezOrganDAO.updateProperty(map);
    	// 부서의 경우엔
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
			jArr.put(jObj);
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
	public String getSearchList(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String primary, String companyId, int tenantID, String noAddJob, String adminOrgan) throws Exception {
		logger.debug("getSearchList started");
		
        String[] searchParam = null;
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
		String strSQLForAddJob = "";

        if (pLimit != 0) {
            strSize = " AND ROWNUM <= " + pLimit;
            //strSizeForMySQL = " LIMIT " + pLimit;
        }
        
        if (!pSearchList.equals("")) {
            pSearchList = pSearchList.replace(";;", "##");
            pSearchList = pSearchList.replace("::", "@@");
            searchList = pSearchList.split("##");
            searchParam = new String[searchList.length];
            
            logger.debug("searchList.length=" + searchList.length);
            
            String escapeString = " ";
            if (globals.getProperty("Globals.DbType").equals("oracle")) {
            	escapeString = " escape '\\' ";
            }
            
            for (i = 0; i < searchList.length; i++) {      	
                searchInfo = searchList[i].split("@@");
                String searchVal =  URLDecoder.decode(searchInfo[1], "utf-8");
                searchParam[i] = searchVal.replace("'", "\\'");
                String escapedSearchParam = searchParam[i].replace("%", "\\%").replace("_", "\\_");

                if (i == 0) {
                    if (checkSearchField(searchInfo[0])) {
                        if (searchInfo[0].toUpperCase().equals("DISPLAYNAME") && searchParam[0].toString().equals("/")) {
                            strSQL = strSQL + " WHERE ( " + searchInfo[0].toLowerCase() + " = '" + searchParam[i] + "' OR " + searchInfo[0].toLowerCase() + "2 = '" + searchParam[i]+ "')";// + " AND PHYSICALDELIVERYOFFICENAME = '" + companyId + "'";
                            searchParam[0] = searchParam[0].substring(0, searchParam[0].length() - 1);
                        } else {
                            strSQL = strSQL + " WHERE ( " + searchInfo[0].toLowerCase() + " LIKE  '%" + escapedSearchParam + "%'" + escapeString + "OR " + searchInfo[0].toLowerCase() + "2 LIKE '%" + escapedSearchParam + "%'" + escapeString + " )";// + " AND PHYSICALDELIVERYOFFICENAME = '" + companyId + "'";
                        }
                    } else {
                        if (searchInfo[0].indexOf("EXACT_") == 0) {
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(6).toLowerCase() + " ='" + searchParam[i] + "' ";
                        } else if (searchInfo[0].indexOf("LEFT_") == 0) {
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(5).toLowerCase() + " LIKE '" + escapedSearchParam + "%'" + escapeString;
                        } else if (searchInfo[0].indexOf("RIGHT_") == 0) {
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(5).toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString;
                    	} else {
                            strSQL = strSQL + " WHERE " + searchInfo[0].toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString; // 아이디 검색
                    	}
                    }
                } else {
                    if (checkSearchField(searchInfo[0])) {
                        strSQL = strSQL + " AND ( " + searchInfo[0].toLowerCase() + " LIKE  '%" + escapedSearchParam + "%'" + escapeString + "OR " + searchInfo[0].toLowerCase() + "2 LIKE '%" + escapedSearchParam + "%'" + escapeString + ")";
                    } else {
                        if (searchInfo[0].indexOf("EXACT_") == 0) {
                            strSQL = strSQL + " AND " + searchInfo[0].substring(6).toLowerCase() + " ='" + searchParam[i] + "' ";
                        } else if (searchInfo[0].indexOf("LEFT_") == 0) {
                            strSQL = strSQL + " AND " + searchInfo[0].substring(5).toLowerCase() + " LIKE '" + escapedSearchParam + " %'" + escapeString;
                        } else if (searchInfo[0].indexOf("RIGHT_") == 0) {
                            strSQL = strSQL + " AND " + searchInfo[0].substring(5).toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString;
                        } else {
                            strSQL = strSQL + " AND " + searchInfo[0].toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString;
                        }
                    }
                }
            }
        }        
        
        if (pClass.equals("user") || pClass.equals("all")){
            //strSQL = strSQL.replace("cn", "a.cn");
            //strSQL = strSQL.replace("title", "a.title");
        	
        	// 2024.06.27 한슬기 : 검색하려는 단어에 cn, userLoginId, title이 포함되어있으면 검색이 되지 않아 앞뒤로 공백추가
    		strSQL = strSQL.replace(" cn ", " a.cn ");
    		strSQL = strSQL.replace(" title ", " a.title ");
    		strSQL = strSQL.replace(" title2 ", " a.title2 ");
                        
            type = "U";
        }else{
        	type = "G";
        }

    	logger.debug("searchList : " + pSearchList.split("@@")[0]);
        if (!companyId.equals("")) {
        	/*strSQLCom = "AND PHYSICALDELIVERYOFFICENAME = '" + companyId + "'";
        	if (type.equals("G")) {
        		strSQLCom = strSQLCom.replace("PHYSICALDELIVERYOFFICENAME", "EXTENSIONATTRIBUTE2");
        	}
        	
        	strSQLAddjobCom = "AND a.DEPTID IN (SELECT cn FROM TBL_DEPTMASTER WHERE EXTENSIONATTRIBUTE2 = '" + companyId + "')";*/
        	if (pSearchList.split("@@")[0].equals("description")){
        		//strSQLAddjobCom = strSQLAddjobCom.replace("a.DEPTID", "b.PHYSICALDELIVERYOFFICENAME");
				strSQLAddjobCom = "description";
        	}
        }

		strSQLForAddJob = strSQL;
		// 2023-08-23 전인하 - 권한 겸직/사용자 기준 설정 기능 대응, 해당 옵션 사용 시 권한 설정 컬럼을 addJobMaster의 추가컬럼에서 찾게 함
		if (ezCommonService.getTenantConfig("permissionBasisDeptYN", tenantID).equals("Y")) {
			strSQLForAddJob = strSQLForAddJob.replace(" extensionattribute1 ", " A.roll_info ");
			strSQLForAddJob = strSQLForAddJob.replace(" department ", " deptID ");
		}

        Map<String, Object> map = new HashMap<String, Object>();

        map.put("strSQL", strSQL + strSize);
        map.put("strSQLForMySQL", strSQL);
        //map.put("strSizeForMySQL", strSizeForMySQL);
        map.put("pLimit", pLimit);
        map.put("strGyumjikForOracle", strSQLForAddJob);
        map.put("type", type);
        map.put("companyId", companyId);
        map.put("class", pClass);
        map.put("v_TENANT_ID", tenantID);
        //map.put("strSQLCom", strSQLCom);
        map.put("strSQLAddjobCom", strSQLAddjobCom);
        map.put("noAddJob", noAddJob);
        map.put("adminOrgan", adminOrgan);
		map.put("strSQLForAddJobForMySQL", strSQLForAddJob);

        logger.debug("strSQL=" + strSQL);
        //logger.debug("strSQLCom=" + strSQLCom);//getSearchList
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
	        		map1.put("IS_ADDJOB", organVO.getIsAddjob());
	        		map1.put("JOBID", organVO.getJobId());
					map1.put("ROLEID", Optional.ofNullable(organVO.getRoleId()).filter(str -> !str.isEmpty()).orElse("0"));

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
	
	@Override
	public String getUserOrgDeptId(String userID, int tenantID, String companyID) throws Exception {
		logger.debug("getUserOrgDeptId started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		logger.debug("getUserOrgDeptId ended");
		
		return ezOrganDAO.getUserOrgDeptId(map);
	}
	
	@Override
	public String updateAddJobProxy(String userID, String proxyInfo, int tenantID, String dept) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantID", tenantID);
		map.put("userID", userID);
		map.put("proxyInfo", proxyInfo);
		map.put("dept", dept);
		
		ezOrganDAO.updateAddJobProxy(map);
		
        return "OK";	
	}
	
	@Override
	public String updateAddJobProxy(String userID, String proxyInfo, int tenantID, String dept, String jobId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantID", tenantID);
		map.put("userID", userID);
		map.put("proxyInfo", proxyInfo);
		map.put("dept", dept);
		map.put("jobId", jobId);
		
		ezOrganDAO.updateAddJobProxy(map);
		
        return "OK";	
	}
	
	@Override
	public String getAddJobProxy(String id, String dept, int tenantId) throws Exception {
		logger.debug("getAddJobProxy started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", id);
		map.put("tenantID", tenantId);
		map.put("dept", dept);
		logger.debug("getAddJobProxy ended");
		
		return ezOrganDAO.getAddJobProxy(map);
	}

	@Override
	public OrganUserVO getUserInfo(String id, String lang, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CN", id);
		map.put("v_LANGDATA", lang);
		map.put("v_TENANT_ID",  tenantId);
		return ezOrganDAO.getUserInfo(map);
	}
	
	/* 2020-10-22 홍승비 - 전달한 필드(칼럼)에 대응하는 값을 TBL_DEPTMASTER 테이블에서 가져오는 메서드 */
	@Override
	public String getPropertyValueForDept(String fieldName, String deptID, int tenantID) throws Exception {
		logger.debug("getPropertyValueForDept started.");
		
	    Map<String, Object> map = new HashMap<String, Object>();
	    map.put("v_FIELD", fieldName.toUpperCase());
		map.put("v_CN", deptID);
		map.put("v_TENANT_ID", tenantID);
		
		//logger.debug("getPropertyValueForDept v_FIELD : " + fieldName + " || deptID : " + deptID);
        logger.debug("getPropertyValueForDept ended.");
        
        return ezOrganDAO.getPropertyValue_S5(map);
	}

	public String getCompanyJobTreeInfo(String type, String pComID, String pTopID, String pPropList, String primary, int tenantID) throws Exception {
	    logger.debug("getCompanyJobTreeInfo started.");
	    logger.debug("type=" + type + ", pComID=" + pComID + ", pTopID=" + pTopID + ", pPropList=" + pPropList + ", primary=" + primary
	    		+ ", tenantID=" + tenantID);
	    
	    String [] adminOrganChk = pTopID.split("/"); // 관리자 페이지  > 조직도, 겸직, 권한 관리에서 topId + "/organ" 붙임
	    
	    boolean allCompanies = false;
	    if (adminOrganChk.length > 1) {
	    	pTopID = adminOrganChk[0];
	    	allCompanies = true;
		} 
		
		OrganDeptVO vo = null; 
		String prevComID = "";
        String comInfo = ""; 
        String comID = pComID;    
         
        do {
			StringBuilder comlist = new StringBuilder("<NODES>");
        	
        	// 선택한 회사의 직위/직책 목록을 가져온다.
			comlist.append(getJobMasterTreeNodeInfo(type, comID, primary, tenantID));
        	
			// 회사의 자식 회사 목록을 가져온다.
			if (allCompanies) {
    			Map<String, Object> map = new HashMap<String, Object>();
    			map.put("v_CN", comID);
    			map.put("v_LANGDATA", primary);
    			map.put("v_TENANT_ID", tenantID);
    			map.put("isCompanyTree", "Y");
    			
    			List<OrganDeptVO> list = ezOrganDAO.getDeptTreeInfo(map); 

    			for (OrganDeptVO childObj : list) {
    				if (childObj.getType().equalsIgnoreCase("dept")) {
    					// 자식 회사의 상세 정보가져오기
    					Map<String, Object> map1 = new HashMap<String, Object>();	
    					map1.put("v_CN", childObj.getCn());
    					map1.put("v_LANGDATA", primary);
    					map1.put("v_TENANT_ID", tenantID);
    					map1.put("isCompanyTree", "Y");
    					
    					OrganDeptVO result = ezOrganDAO.getTBLDeptMaster(map1);
    					
    					comlist.append(getCompanyJobTreeNodeInfo(result, pComID, prevComID, comInfo, pPropList, type, tenantID));
    				}
    			} 
            }
			
	        comlist.append("</NODES>");	
	        comInfo = comlist.toString();
	        
	        // 지정된 부서 자체의 상세 정보를 가지고 온다
	        Map<String, Object> map2 = new HashMap<String, Object>();				
			map2.put("v_CN", comID);
			map2.put("v_LANGDATA", primary);
			map2.put("v_TENANT_ID", tenantID);
	        vo = ezOrganDAO.getTBLDeptMaster(map2);
	    	
	        prevComID = comID;
	        // 지정된 부서의 부모 부서 ID를 구한다.
	        if (!comID.toLowerCase().equals(pTopID.toLowerCase())) {
	        	if (comID.toLowerCase().equals("top")) {
	        		comID = "";
	        	} else {
	        		comID = getPropertyValue(comID, "extensionAttribute1", tenantID);         
	        	}
	        }
	        logger.debug("prevComID={}, comID={}", prevComID, comID);
	        
        } while (allCompanies && !prevComID.toLowerCase().equals(pTopID.toLowerCase()) && !comID.equals(""));
        
        comInfo = "<TREEVIEWDATA>" + getCompanyJobTreeNodeInfo(vo, pComID, prevComID, comInfo, pPropList, type, tenantID) + "</TREEVIEWDATA>";
        
        logger.debug("comInfo=" + comInfo);
        logger.debug("getCompanyJobTreeInfo ended.");
        
        return comInfo;
	}
	
	@Override
	public String getJobMasterTreeInfo(String type, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("getJobMasterTreeInfo started.");
	    logger.debug("type=" + type + ",companyID=" + companyID + ",lang=" + lang + ",tenantID=" + tenantID);
	    
		StringBuilder jobInfo = new StringBuilder("<NODES>");
		jobInfo.append(getJobMasterTreeNodeInfo(type, companyID, lang, tenantID));
		jobInfo.append("</NODES>");   

        logger.debug("jobInfo=" + jobInfo);
        logger.debug("getJobMasterTreeInfo ended.");
        
		return jobInfo.toString();
	}

	@Override
	public String getJobMasterMemberList(String type, String jobID, String celllist, String proplist, String pageSize, String pageNum, 
			String searchType, String searchValue, String primary, String companyID, int tenantID, String adminOrgan) throws Exception {
		logger.debug("getJobMasterMemberList started.");
		
		StringBuilder userInfo = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TYPE", type);
		map.put("v_JOBID", jobID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		map.put("v_ADMINORGAN", adminOrgan);
		
		if (!pageNum.equals("") && !pageSize.equals("")) {
			int pPageSize = Integer.parseInt(pageSize);
			int pPageNum = Integer.parseInt(pageNum);
			pPageNum = (pPageNum * pPageSize) - pPageSize;
			logger.debug("getJobMasterMemberList pageSize : " + pPageSize + " pageNum : " + pPageNum);
			
			map.put("v_PAGESIZE", pPageSize);
			map.put("v_PAGENUM", pPageNum);
		}
		
		if (!searchType.equals("") && !searchValue.equals("") || "n".equals(adminOrgan)) {
			String v_subQuery = "WHERE ";
			if (searchType.equalsIgnoreCase("displayname")) {
				v_subQuery += primary.equals("1") ? " DISPLAYNAME " : " DISPLAYNAME2 ";
				v_subQuery += " LIKE '%" + searchValue.trim() + "%' ";
				
				if (globals.getProperty("Globals.DbType").equals("oracle")) {
					v_subQuery += " ESCAPE '\\' ";
				}
			}
			
			if ("n".equals(adminOrgan)) {
				String regex = "WHERE\\\\s+\\\\S+.*";
				if (v_subQuery.matches(regex)) {
					// where절 뒤에 searchType문자열이 들어갔는지 확인하고 있으면 AND 추가
					v_subQuery += "AND ";
				}
				v_subQuery += "USERTREEFLAG = 'Y'";
				v_subQuery += " AND DEPTTREEFLAG = 'Y'";
			}
			map.put("v_SUBQUERY", v_subQuery);
		}
		
		List<OrganUserVO> userList = ezOrganAdminDao.getTitleUserList(map);
		int totalCnt = ezOrganAdminDao.getTitleUserListCnt(map);
		String getMemberInfoStr = "";
		
		if (userList != null && userList.size() > 0) {
			for (OrganUserVO obj : userList) {
				String tmpUserType = obj.getUserType();
				tmpUserType = (tmpUserType != null && tmpUserType.equalsIgnoreCase("addJob")) ? "Y" : "";
				String roleId = Optional.ofNullable(obj.getRoleId()).filter(str -> !str.isEmpty()).orElse("0");

				Map<String, Object> userMap = new HashMap<String, Object>();
				userMap.put("v_CN", obj.getCn());
				userMap.put("v_DEPTCD", obj.getDepartment());
				userMap.put("v_LANGDATA", primary);
				userMap.put("v_TENANT_ID", tenantID);
				userMap.put("IS_ADDJOB", tmpUserType);
				userMap.put("JOBID", obj.getJobID());
				userMap.put("ROLEID", roleId);
				Object userVO = ezOrganDAO.getTBLUserMaster(userMap);  
				
				StringBuilder userSb = new StringBuilder();
				userSb.append("<DATA>");        		
                userSb.append(commonUtil.getQueryResult(userVO));
				userSb.append("</DATA>"); 
				
				getMemberInfoStr += getMemberInfo(userSb.toString(), celllist, proplist, obj.getCn(), "USER");
			}
		}
		
		userInfo.append("<LISTVIEWDATA><TOTALCOUNT>"+totalCnt+"</TOTALCOUNT><ROWS>");
		userInfo.append(getMemberInfoStr);
		userInfo.append("</ROWS></LISTVIEWDATA>");

		logger.debug("getJobMasterMemberList ended.");
		return userInfo.toString();	
	};
	
	private String getJobMasterTreeNodeInfo(String type, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("getJobMasterTreeNodeInfo started");

		StringBuilder nodeInfo = new StringBuilder();
		
		String tenantDomain = ezCommonService.getTenantConfig("DomainName", tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TYPE", type);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		
		List<OrganJobVO> list = ezOrganAdminDao.getTitleList(map);
		
		for (OrganJobVO obj : list) {
			String objDisplayName = lang.equals("1") ? obj.getDisplayName() : obj.getDisplayName2();
			String jobMailAttr = "__" + obj.getJobID() + "@" + tenantDomain;
			
			nodeInfo.append("<NODE>");
				nodeInfo.append("<VALUE>" + commonUtil.cleanValue(objDisplayName) + "</VALUE>");
				nodeInfo.append("<CN>" + commonUtil.cleanValue(obj.getJobID()) + "</CN>");
				nodeInfo.append("<COMID>" + commonUtil.cleanValue(obj.getCompanyID()) + "</COMID>");
				nodeInfo.append("<JOBTYPE>" + commonUtil.cleanValue(type) + "</JOBTYPE>");
				nodeInfo.append("<MAIL>" + commonUtil.cleanValue(jobMailAttr) + "</MAIL>"); // __직위아이디@테넌트 도메인
				nodeInfo.append("<ISJOB>true</ISJOB>");
				nodeInfo.append("<ISLEAF>TRUE</ISLEAF>");
			nodeInfo.append("</NODE>");
		}
		
		logger.debug("getJobMasterTreeNodeInfo ended");
		return nodeInfo.toString();
	}
	
	private String getCompanyJobTreeNodeInfo(OrganDeptVO vo, String pOrgComID, String pPrevDeptID, String pDeptInfo, String pPropList, String jobType, int tenantId) throws Exception {
		logger.debug("getCompanyJobTreeNodeInfo started");
		
		StringBuilder nodeInfo = new StringBuilder();
		nodeInfo.append("<NODE>");
		nodeInfo.append("<VALUE>" + commonUtil.cleanValue(vo.getDeptNM()) + "</VALUE>");
		nodeInfo.append("<CN>" + vo.getCn() + "</CN>");
	
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
		
		// 회사의 직위 또는 직책 개수를 구한다
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TYPE", jobType);
		map.put("v_COMPANYID", vo.getCn());
		map.put("v_TENANTID", tenantId);
		int cnt = ezOrganAdminDao.getTitleListCnt(map);
		String isLeafValue = cnt > 0 ? "FALSE" : "TRUE";
		
	    nodeInfo.append("<ISLEAF>" + isLeafValue + "</ISLEAF>");
		
		if (vo.getCn() != null) {
			if (vo.getExtensionAttribute2() != null) {
			    // 현재 처리하는 부서가 회사일 경우 회사 아이콘이 표시되도록 한다.
				if (vo.getCn().equalsIgnoreCase(vo.getExtensionAttribute2())){
			        nodeInfo.append("<SETNODEICONBYNAME>ICONCOMP</SETNODEICONBYNAME>");
				}
			}
			
			if (pPrevDeptID != null) {
			    // 현재 부서의 직전에 처리했던 자식 부서의 XML String 정보를 추가한다. 
			    if (vo.getCn().toLowerCase().equals(pPrevDeptID.toLowerCase()) && !pDeptInfo.equals("<NODES></NODES>")){
			        nodeInfo.append("<EXPANDED>TRUE</EXPANDED>" + pDeptInfo);
			    }
			}
			
			if (pOrgComID != null) {
			    // 사용자가 최초로 지정한 부서가 선택되도록 한다.
			    if (vo.getCn().equalsIgnoreCase(pOrgComID)){
			        nodeInfo.append("<SELECT/>");
			    }
			}
		}
	    nodeInfo.append("</NODE>");

		logger.debug("getCompanyJobTreeNodeInfo ended");;
	    return nodeInfo.toString();
	}
	
	public List<OrganUserVO> getOrgUserInfo(String userID, int tenantID, String companyID) throws Exception {
		logger.debug("getOrgUserInfo started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		logger.debug("getOrgUserInfo ended");
		
		return ezOrganDAO.getOrgUserInfo(map);
	}
	
	@Override
	public String getAddJobProxy(String id, String dept, String title, int tenantId) throws Exception {
		logger.debug("getAddJobProxy2 started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", id);
		map.put("tenantID", tenantId);
		map.put("dept", dept);
		map.put("title", title);
		logger.debug("getAddJobProxy2 ended");
		
		return ezOrganDAO.getAddJobProxy(map);
	}

	// 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 - 겸직/사용자 별 권한 설정 옵션에 따른 권한 조회 메소드
	@Override
	public String getRollInfoBasisDept(String userID, int tenantID, String deptID, String jobID) throws Exception {
		logger.debug("getRollInfoBasisDept started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CN",userID);
		map.put("v_TENANT_ID", tenantID);
		map.put("v_DEPTID", deptID);
		map.put("v_JOBID", jobID);

		logger.debug("getRollInfoBasisDept ended");

		return ezOrganDAO.getRollInfoBasisDept(map);
	}

	// 2023-08-09 전인하 - 특정 유저의 모든 겸직 권한 호출하는 메소드
	@Override
	public List<OrganUserVO> getAllRollInfoForUserBasisDept(String userId, int tenantId, String permissionCode) throws Exception {
		logger.debug("getAllRollInfoForUserBasisDept started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CN", userId);
		map.put("v_TENANT_ID", tenantId);
		map.put("v_PERMISSION_CODE", permissionCode);
		map.put("permissionBasisDeptYN", ezCommonService.getTenantConfig("permissionBasisDeptYN", tenantId));

		List<OrganUserVO> returnVal = ezOrganDAO.getAllRollInfoForUserBasisDept(map);

		logger.debug("getAllRollInfoForUserBasisDept ended");

		return returnVal;
	}

	// 2023-08-28 전인하 - 전자결재 > 좌측 겸직 변경 드롭다운 > 리스트 생성 위한 겸직정보 조회
	@Override
	public List<OrganUserVO> getAddJobListForEzApprDropdown(String lang, String userId, int tenantId) throws Exception {
		logger.debug("getAddJobListForEzApprDropdown started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CN", userId);
		map.put("v_TENANT_ID", tenantId);
		map.put("v_LANGDATA", lang);

		List<OrganUserVO> returnVal = ezOrganDAO.getAddJobListForEzApprDropdown(map);

		logger.debug("getAddJobListForEzApprDropdown ended");

		return returnVal;
	}

	public OrganUserVO getAddJobInfo(String id, String dept, String jobId, int tenantId) throws Exception {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", id);
		map.put("dept", dept);
		map.put("jobID", jobId);
		map.put("tenantID", tenantId);
		return ezOrganDAO.getAddJobInfo(map);
	}

    @Override
	public String changeCookie(String loginCookie, String deptId, String companyId, int tenantId, String jobId) throws Exception {
		logger.debug("changeCookie => deptId = " + deptId + ", companyId = " + companyId + ", tenantId = " + tenantId + ", jobId = " + jobId);

		boolean useDbSession = "YES".equalsIgnoreCase(config.getProperty("config.UseDbSession"));
		String ezSessionId = loginCookie; // useDbSession가 true인 경우에만 사용
		
        String decData = commonUtil.getDecryptedLoginCookie(loginCookie);
		String[] decDataArray = decData.split("///", -1);
		decDataArray[8] = String.valueOf(tenantId);
		decDataArray[9] = deptId;
		decDataArray[10] = companyId;
		decDataArray[11] = jobId;
        String newCookieStr = String.join("///", decDataArray);
		loginCookie = egovFileScrty.encryptAES(newCookieStr);

		if (useDbSession && ezSessionId.length() == 36) {
			loginService.updateSession(ezSessionId, loginCookie);

			loginCookie = ezSessionId;
		}

        return loginCookie;
    }

	@Override
	public Optional<OrganUserVO> getUserInfo(int tenantId, String userId, String companyId, String deptId, String jobId, String lang) throws Exception {
		Map<String, Object> map = new HashMap<>();
		map.put("v_CN", userId);
		map.put("v_TENANT_ID", tenantId);
		map.put("v_LANGDATA", lang);

		List<OrganUserVO> allUserInfo = ezOrganDAO.getAllUserInfo(map);

		// jobId 가 빈경우-> null인 유저정보(본직). 또는 회사, 부서, jobid가 일치한 vo 반환
		return allUserInfo.stream().filter(vo -> (StringUtils.isBlank(jobId) && StringUtils.isBlank(vo.getJobID())) ||
                (companyId.equals(vo.getCompanyId()) && deptId.equals(vo.getDepartment()) && jobId.equals(vo.getJobID()))).findAny();
	}

	@Override
	public List<OrganUserVO> getAllUserinfo(String userId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<>();
		map.put("v_CN", userId);
		map.put("v_TENANT_ID", tenantId);
		map.put("v_LANGDATA", "1");
		List<OrganUserVO> allUserInfo = ezOrganDao.getAllUserInfo(map);

		if (allUserInfo.isEmpty()) {
			throw new Exception("getAllUserinfo - 유저 정보 조회 실패 : " + tenantId + "/" + userId);
		}

		return allUserInfo;
	}

	@Override
	public TeamsOrganVO organMain(LoginVO userInfo, String device, String companyId, String permission, String deptId, String uselstcompany, int tenantId) throws Exception {
		logger.debug("userInfo = " + userInfo + ", device = " + device + ", companyId = " + companyId + ", permission = " + permission + ", deptId = " + deptId + ", uselstcompany = " + uselstcompany);
		
		TeamsOrganVO teamsOrganVO = new TeamsOrganVO();

		String userId = userInfo.getId();
		
		if (userId == null || userId.trim().isEmpty()) {
			return teamsOrganVO;
		}

		String mode = "DB";
		String tenant = "";
		String appId = "";
		String appSecret = "";
		String usePresence = "";
		int presenceInterval = 60;
		String photoPath = "";
		String delegatedAuthToken = "";
		String publicAuthToken = "";
		List<Map<String, String>> companyList = new ArrayList<>();

		try {
			if (device != null && !device.isEmpty()) {
				device = device;
			}

			// 시스템 설정값 로드
			tenant = ezCommonService.getTenantConfig("teamsTenant", tenantId);
			appId = ezCommonService.getTenantConfig("teamsClientId", tenantId);
			appSecret = ezCommonService.getTenantConfig("teamsClientSecret", tenantId);
			usePresence = ezCommonService.getTenantConfig("useTeams", tenantId).toLowerCase(); 
			presenceInterval = Integer.parseInt(ezCommonService.getTenantConfig("presenceInterval", tenantId));
			delegatedAuthToken = ezTeamsService.getToken("delegated");
//			publicAuthToken = ezTeamsService.getPublicAppToken(tenant, appId, appSecret); // TODO
			publicAuthToken = ezTeamsService.getToken("publicapp");
			
			// 회사ID 처리
			if (companyId == null || companyId.isEmpty()) {
				companyId = userInfo.getCompanyID();
			} else {
				if ("TOP".equalsIgnoreCase(companyId)) {
					companyId = userInfo.getCompanyID();
				} else {
					companyId = companyId.trim();
				}

				if (deptId == null || deptId.isEmpty()) {
					if (userInfo.getCompanyID().equalsIgnoreCase(companyId)) {
						deptId = userInfo.getDeptID();
					}
				}
			}

			String companyName = getPropertyValue(companyId, "DISPLAYNAME", tenantId); // TODO
			// 회사 목록 구성
			if ("Y".equalsIgnoreCase(uselstcompany)) {
				Map<String, String> option = new HashMap<>();
				option.put("companyId", companyId);
				option.put("companyName", companyName);
				companyList.add(option);

			} else if ("Y".equalsIgnoreCase(permission)
					&& !userInfo.getRollInfo().contains("c=1")
					&& userInfo.getRollInfo().contains("k=1")) {
				Map<String, String> option = new HashMap<>();
				option.put("companyId", companyId);
				option.put("companyName", companyName);
				companyList.add(option);

			} else {
				companyList = dropDownAllCompanyList(userInfo.getRollInfo(), companyId, userInfo.getLang()); 
			}
			

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		teamsOrganVO.setTenant(tenant);
		teamsOrganVO.setAppId(appId);
		teamsOrganVO.setDelegatedAuthToken(delegatedAuthToken);
		teamsOrganVO.setPublicAuthToken(publicAuthToken);
		teamsOrganVO.setMode(mode);
		teamsOrganVO.setDevice(device);
		teamsOrganVO.setUsePresence(usePresence);
		teamsOrganVO.setPresenceInterval(presenceInterval);
		teamsOrganVO.setPhotoPath(photoPath);
		teamsOrganVO.setCompanyList(companyList);
		return teamsOrganVO;
	}

	// 부서, 사용자 조직도 트리 정보 조회 (Teams용)
	@Override
	public String getTotalTreeNodeInfo(LoginVO userInfo, String userId, String selectedUserId, String deptId, String topId,
									   String propList, String langCode, String type, String adminFlag) throws Exception {

		logger.debug("getTotalTreeNodeInfo started");
		int tenantID = userInfo.getTenantId();
		JSONArray returnJArray = new JSONArray();

		try {
			// selectedUserId만 있고 부서ID가 없으면 해당 사용자의 부서ID를 가져옴
			if (!selectedUserId.isEmpty() && deptId.isEmpty()) {
				Map<String, Object> param = new HashMap<>();
				param.put("CN", selectedUserId);
				OrganDeptVO deptInfo = ezOrganDAO.getDeptInfo(param);
				deptId = deptInfo.getCn();
			}

			if (deptId.isEmpty()) {
				deptId = userInfo.getDeptID();
			}
			if (topId.isEmpty()) {
				topId = userInfo.getCompanyID();
			}
			Set<String> processedDeptIds = new HashSet<>();

			String deptPath = "";
			if (deptId != null && !deptId.equals("")) {
				Map map = new HashMap();
				map.put("tenantID", tenantID);
				map.put("deptId", deptId);

				deptPath = ezOrganDAO.getDeptPath(map); // 예: "teamsdev,projectteam1,subdept1"
			}
			JSONArray nodes = getSubDeptTreeNodes(topId, deptPath, propList, langCode, 1, deptId, "", adminFlag, "Y",processedDeptIds,"all");

			// 최상위 부서에 직접 소속된 사용자 추가
			Map<String, Object> topUserParam = new HashMap<>();
			topUserParam.put("v_CLASS", "user");
			topUserParam.put("v_CN", topId);
			topUserParam.put("v_TENANT_ID", tenantID);
			topUserParam.put("v_LANGDATA", langCode);

			List<OrganTeamsTreeVO> topLevelUsers = ezOrganDAO.getDeptMemberListForTeams(topUserParam); // EZSP_GETDEPTMEMBERLIST_NEW2
			for (OrganTeamsTreeVO user : topLevelUsers) {
				JSONObject userNode = new JSONObject();
				userNode.put("data1", "USER");
				userNode.put("data2", user.getData2());
				userNode.put("nodeLevel", 1);
				userNode.put("department", user.getDepartment());
				userNode.put("title", user.getTitle());
				userNode.put("description", user.getDescription());
				userNode.put("levelName", user.getLevelName());
				userNode.put("value", user.getDisplayName() + ((user.getTitle() != null && !user.getTitle().isEmpty()) ? " (" + user.getTitle() + ")" : ""));
				userNode.put("displayName", user.getDisplayName());
				userNode.put("isLeaf", "TRUE");
				userNode.put("setTextColorByName", "GRAY");
				userNode.put("extensionAttribute10", user.getExtensionAttribute10());
				userNode.put("physicalDeliveryOfficeName", user.getPhysicalDeliveryOfficeName());
				userNode.put("extensionAttribute2", user.getExtensionAttribute2());
				userNode.put("upnName", user.getUpnName());
				userNode.put("teamsId", user.getTeamsId());
				
				// propList 적용
				if (!propList.isEmpty()) {
					String[] props = propList.split(";");
					for (String propName : props) {
						String val = "";
						try {
							Field field = user.getClass().getDeclaredField(propName);
							field.setAccessible(true);
							Object propValue = field.get(user);
							val = propValue != null ? propValue.toString().trim() : "";
						} catch (Exception e) {
							logger.warn(e.getMessage());
						}
						userNode.put(propName, val);
					}
				}

				nodes.put(userNode);  // 사용자 노드 추가
			}
			

			// 최상위 노드 정보 구성
			Map<String, Object> topParam = new HashMap<>();
			topParam.put("userID", topId);
			topParam.put("primary", langCode);
			topParam.put("v_TENANT_ID", tenantID);
			OrganDeptVO top = ezOrganDAO.getDeptInfo(topParam);

			if (top != null) {
				JSONObject topNode = new JSONObject();
				topNode.put("value", top.getDisplayName());
				topNode.put("data1", "DEPT");
				topNode.put("data2", top.getCn());
				topNode.put("nodeLevel", top.getDeptLevel());
				topNode.put("displayName", top.getDisplayName());
				topNode.put("icon", "i_company");
				topNode.put("isLeaf", "FALSE");
				topNode.put("nodes", nodes);

				boolean hasTopDeptUser = false;
				boolean hasTopDept = false;

				for (int i = 0; i < nodes.length(); i++) {
					JSONObject child = nodes.getJSONObject(i);
					String nodeType = child.optString("data1");
					if ("USER".equalsIgnoreCase(nodeType)) hasTopDeptUser = true;
					else if ("DEPT".equalsIgnoreCase(nodeType)) hasTopDept = true;
				}

				topNode.put("hasDeptUser", hasTopDeptUser ? "TRUE" : "FALSE");
				topNode.put("hasDept", hasTopDept ? "TRUE" : "FALSE");
				if (top.getCn().equals(deptId)) {
//					topNode.put("isSelected", true);
					
					JSONObject state = new JSONObject();
					state.put("selected", true);
					state.put("expanded", true);
					topNode.put("state", state);
				}
				returnJArray.put(topNode);
			}
		} catch (Exception e) {
			logger.error("getTotalTreeNodeInfo error", e);
		}
		return returnJArray.toString();
	}

	// 재귀적으로 하위 부서 및 사용자 구성
	private JSONArray getSubDeptTreeNodes(String deptId, String deptPath, String propList, String langCode, int nodeLevel, String userDeptId, String userDeptPath,
										   String adminFlag, String allTreeFlag, Set<String> processedDeptIds, String vClass) {
		
		JSONArray returnJArray = new JSONArray();
		try {
			// 1단계: 파라미터 설정 및 DB 쿼리 호출
			Map<String, Object> param = new HashMap<>();
			param.put("v_CLASS", vClass);
			param.put("v_CN", deptId);
			param.put("v_TENANT_ID", 0);
			param.put("v_LANGDATA", langCode);

			List<OrganTeamsTreeVO> list = ezOrganDAO.getDeptMemberListForTeams(param);
			
			List<OrganTeamsTreeVO> deptList = new ArrayList<>();
			List<OrganTeamsTreeVO> totalUserList = new ArrayList<>();
			
			// 2단계: 부서/사용자 분리 + 자기부서/hierarchy 체크
			for (OrganTeamsTreeVO row : list) {
				if ("DEPT".equalsIgnoreCase(row.getData1())) {
					
					String currentDeptId = row.getData2(); // 현재 부서
					String parentDeptId = row.getDepartment();  // 상위 부서
					
					if (currentDeptId.equals(deptId)) { // 자기 부서
						if (!processedDeptIds.contains(currentDeptId)) {
							processedDeptIds.add(currentDeptId);
							continue;
						}
					} else if (deptId.equals(parentDeptId)) { // 하위 부서
						if (!processedDeptIds.contains(currentDeptId)) {
							processedDeptIds.add(currentDeptId);
							deptList.add(row); // 하위 부서 추가
						}
					}
				} else if ("USER".equalsIgnoreCase(row.getData1())) {
					String userDept  = row.getDepartment();
					totalUserList.add(row);  // 전체 사용자 일괄 저장 (조건없이)
				}
			}

			//  3단계: 부서별 트리 노드 구성 시작
			for (OrganTeamsTreeVO dept : deptList) {
				String cn = dept.getData2();
				String parentCn = dept.getDepartment();
				JSONObject node = new JSONObject();
				
				// 하위 부서 존재 여부 DB 조회로 판단 (EZSP_DEPTSUBDEPTCNT와 동일한 역할)
				Map<String, Object> subParam = new HashMap<>();
				subParam.put("v_CN", dept.getData2());
				subParam.put("v_ADMINFLAG", adminFlag);
				int subDeptCount = ezOrganDAO.getSubDeptCount(subParam);
				String isLeafValue = (subDeptCount > 0) ? "FALSE" : "TRUE";
				node.put("isLeaf", isLeafValue);
				node.put("data1", "DEPT");
				node.put("data2", dept.getData2());
				node.put("nodeLevel", String.valueOf(nodeLevel));
				node.put("value", dept.getDisplayName());
				node.put("displayName", dept.getDisplayName());
				node.put("icon", "i_department");
				node.put("setTextColorByName", "GRAY");
				node.put("extensionAttribute2", dept.getExtensionAttribute2());
				node.put("upnName", dept.getUpnName());
				node.put("teamsId", dept.getTeamsId());
				
				if (dept.getData2().equals(userDeptId)) {
//					node.put("isSelected", true);
					JSONObject state = new JSONObject(); 
					state.put("selected", true);        
					state.put("expanded", true);        
					node.put("state", state);          
				} else if (deptPath != null && deptPath.contains(dept.getData2())) {
					JSONObject state = new JSONObject();
					state.put("expanded", true);
					node.put("state", state);
				}
				// 4단계: 재귀 호출로 하위 부서 구성
				JSONArray childNodes = new JSONArray();
				if ("Y".equalsIgnoreCase(allTreeFlag)) {
					childNodes = getSubDeptTreeNodes(dept.getData2(), deptPath, propList, langCode, nodeLevel + 1, userDeptId, userDeptPath, adminFlag, allTreeFlag, processedDeptIds,"all");
				}

				// 5단계: 사용자 노드 붙이기
				for (OrganTeamsTreeVO user : totalUserList) {
					if (dept.getData2().equals(user.getDepartment())) {
						JSONObject userNode = new JSONObject();
						userNode.put("data1", "USER");
						userNode.put("data2", user.getData2());
						userNode.put("nodeLevel", String.valueOf(nodeLevel + 1));
						userNode.put("department", user.getDepartment());
						userNode.put("title", user.getTitle());
						userNode.put("description", user.getDescription());
						userNode.put("levelName", user.getLevelName());
						userNode.put("value", user.getDisplayName() + ((user.getTitle() != null && !user.getTitle().isEmpty()) ? " (" + user.getTitle() + ")" : ""));
						userNode.put("displayName", user.getDisplayName());
						userNode.put("isLeaf", "TRUE");
						userNode.put("setTextColorByName", "GRAY");
						userNode.put("extensionAttribute10", user.getExtensionAttribute10());
						userNode.put("physicalDeliveryOfficeName", user.getPhysicalDeliveryOfficeName());
						userNode.put("extensionAttribute2", user.getExtensionAttribute2());
						userNode.put("upnName", user.getUpnName());
						userNode.put("teamsId", user.getTeamsId());

						if (!propList.isEmpty()) {
							String[] props = propList.split(";");
							for (String propName : props) {
								String val = "";
								try {
									Field field = user.getClass().getDeclaredField(propName);
									field.setAccessible(true);
									Object propValue = field.get(user);
									val = propValue != null ? propValue.toString().trim() : "";
								} catch (Exception e) {
									logger.warn(e.getMessage());
								}
								userNode.put(propName, val);
							}
						}
						if (user.getData2().equals(userDeptPath)) {
							JSONObject state = new JSONObject();
							state.put("selected", true);
							userNode.put("state", state);
						}

						childNodes.put(userNode);
					}
				}
				node.put("nodes", childNodes);

				// 부서 하위에 사용자/부서 존재 여부 판단
				boolean hasDeptUser = false;
				boolean hasDept = false;
				
				for (int i = 0; i < childNodes.length(); i++) {
					JSONObject child = childNodes.getJSONObject(i);
					String type = child.optString("data1");
					if ("USER".equalsIgnoreCase(type)) hasDeptUser = true;
					else if ("DEPT".equalsIgnoreCase(type)) hasDept = true;
				}
				node.put("hasDeptUser", hasDeptUser ? "TRUE" : "FALSE");
				node.put("hasDept", hasDept ? "TRUE" : "FALSE");

				if (!propList.isEmpty()) {
					String[] props = propList.split(";");
					for (String propName : props) {
						String val = "";
						try {
							Field field = dept.getClass().getDeclaredField(propName);
							field.setAccessible(true);
							Object propValue = field.get(dept);
							val = propValue != null ? propValue.toString().trim() : "";
						} catch (Exception e) {
							logger.warn(e.getMessage());
						}
						node.put(propName, val);
					}
				}

				returnJArray.put(node);
			}

		} catch (Exception e) {
			logger.error("getSubDeptTreeNodes error", e);
			JSONObject err = new JSONObject();
			err.put("error", "treeNode 실패: " + e.getMessage());
			returnJArray.put(err);
		}

		return returnJArray;
	}

	public List<Map<String, String>> dropDownAllCompanyList(String rolInfo, String companyId, String lang) {
		List<Map<String, String>> items = new ArrayList<>();

		try {
			String infoXML = getCompanyList(lang);
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document xmldom = builder.parse(new InputSource(new StringReader(infoXML)));
			NodeList nameList = xmldom.getElementsByTagName("DISPLAYNAME");
			NodeList cnList = xmldom.getElementsByTagName("CN");

			for (int i = 0; i < nameList.getLength(); i++) {
				String displayName = nameList.item(i).getTextContent();
				String cn = cnList.item(i).getTextContent();

				Map<String, String> item = new HashMap<>();
				item.put("companyName", displayName);
				item.put("companyId", cn);

				if (cn.equalsIgnoreCase(companyId)) {
					item.put("selected", "true");
				} else {
					item.put("selected", "false");
				}

				items.add(item);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		return items;
	}
	public String getCompanyList(String userLang) {
		String result = "<DATA></DATA>";

		try {
			List<Map<String, Object>> list = ezOrganDAO.getCompanyList(userLang);

			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");

			for (Map<String, Object> row : list) {
				String cn = String.valueOf(row.get("CN"));
				String displayName = String.valueOf(row.get("DisplayName"));

				sb.append("<Row>");
				sb.append("<CN>").append(cn).append("</CN>");
				sb.append("<DISPLAYNAME>").append(displayName).append("</DISPLAYNAME>");
				sb.append("</Row>");
			}

			sb.append("</DATA>");
			result = sb.toString();

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		return result;
	}

	@Override
	public List<Map<String, Object>> getSearchListForTeamsJson(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String primary, String companyId, int tenantID, String noAddJob, String adminOrgan) throws Exception {
		logger.debug("getSearchListForTeamsJson started");

		String[] searchParam = null;
		String[] searchList;
		String[] searchInfo;
		String strSize = "";
		String strSQL = "";
		String strSQLAddjobCom = "";
		String type = "";
		int i = 0;
		String strSQLForAddJob = "";

		if (pLimit != 0) {
			strSize = " AND ROWNUM <= " + pLimit;
		}

		if (!pSearchList.equals("")) {
			pSearchList = pSearchList.replace(";;", "##");
			pSearchList = pSearchList.replace("::", "@@");
			searchList = pSearchList.split("##");
			searchParam = new String[searchList.length];

			logger.debug("searchList.length=" + searchList.length);

			String escapeString = " ";
			if (globals.getProperty("Globals.DbType").equals("oracle")) {
				escapeString = " escape '\\' ";
			}

			for (i = 0; i < searchList.length; i++) {
				searchInfo = searchList[i].split("@@");
				String searchVal = URLDecoder.decode(searchInfo[1], "utf-8");
				searchParam[i] = searchVal.replace("'", "\\'");
				String escapedSearchParam = searchParam[i].replace("%", "\\%").replace("_", "\\_");

				if (i == 0) {
					if (checkSearchField(searchInfo[0])) {
						if (searchInfo[0].toUpperCase().equals("DISPLAYNAME") && searchParam[0].equals("/")) {
							strSQL += " WHERE ( " + searchInfo[0].toLowerCase() + " = '" + searchParam[i] + "' OR " + searchInfo[0].toLowerCase() + "2 = '" + searchParam[i] + "')";
							searchParam[0] = searchParam[0].substring(0, searchParam[0].length() - 1);
						} else {
							strSQL += " WHERE ( " + searchInfo[0].toLowerCase() + " LIKE  '%" + escapedSearchParam + "%'" + escapeString + "OR " + searchInfo[0].toLowerCase() + "2 LIKE '%" + escapedSearchParam + "%'" + escapeString + " )";
						}
					} else {
						if (searchInfo[0].indexOf("EXACT_") == 0) {
							strSQL += " WHERE " + searchInfo[0].substring(6).toLowerCase() + " ='" + searchParam[i] + "' ";
						} else if (searchInfo[0].indexOf("LEFT_") == 0) {
							strSQL += " WHERE " + searchInfo[0].substring(5).toLowerCase() + " LIKE '" + escapedSearchParam + "%'" + escapeString;
						} else if (searchInfo[0].indexOf("RIGHT_") == 0) {
							strSQL += " WHERE " + searchInfo[0].substring(6).toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString;
						} else {
							strSQL += " WHERE " + searchInfo[0].toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString;
						}
					}
				} else {
					if (checkSearchField(searchInfo[0])) {
						strSQL += " AND ( " + searchInfo[0].toLowerCase() + " LIKE  '%" + escapedSearchParam + "%'" + escapeString + "OR " + searchInfo[0].toLowerCase() + "2 LIKE '%" + escapedSearchParam + "%'" + escapeString + ")";
					} else {
						if (searchInfo[0].indexOf("EXACT_") == 0) {
							strSQL += " AND " + searchInfo[0].substring(6).toLowerCase() + " ='" + searchParam[i] + "' ";
						} else if (searchInfo[0].indexOf("LEFT_") == 0) {
							strSQL += " AND " + searchInfo[0].substring(5).toLowerCase() + " LIKE '" + escapedSearchParam + "%'" + escapeString;
						} else if (searchInfo[0].indexOf("RIGHT_") == 0) {
							strSQL += " AND " + searchInfo[0].substring(6).toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString;
						} else {
							strSQL += " AND " + searchInfo[0].toLowerCase() + " LIKE '%" + escapedSearchParam + "%'" + escapeString;
						}
					}
				}
			}
		}

		if (pClass.equals("user") || pClass.equals("all")) {
			strSQL = strSQL.replace(" cn ", " a.cn ");
			strSQL = strSQL.replace(" title ", " a.title ");
			strSQL = strSQL.replace(" title2 ", " a.title2 ");
			type = "U";
		} else {
			type = "G";
		}

		if (!companyId.equals("") && pSearchList.split("@@")[0].equals("description")) {
			strSQLAddjobCom = "description";
		}

		strSQLForAddJob = strSQL;
		if (ezCommonService.getTenantConfig("permissionBasisDeptYN", tenantID).equals("Y")) {
			strSQLForAddJob = strSQLForAddJob.replace(" extensionattribute1 ", " A.roll_info ");
			strSQLForAddJob = strSQLForAddJob.replace(" department ", " deptID ");
		}

		Map<String, Object> map = new HashMap<>();
		map.put("strSQL", strSQL + strSize);
		map.put("strSQLForMySQL", strSQL);
		map.put("pLimit", pLimit);
		map.put("strGyumjikForOracle", strSQLForAddJob);
		map.put("type", type);
		map.put("companyId", companyId);
		map.put("class", pClass);
		map.put("v_TENANT_ID", tenantID);
		map.put("strSQLAddjobCom", strSQLAddjobCom);
		map.put("noAddJob", noAddJob);
		map.put("adminOrgan", adminOrgan);
		map.put("strSQLForAddJobForMySQL", strSQLForAddJob);
		List<OrganDeptVO> list = ezOrganDAO.organSearch(map);
		List<Map<String, Object>> resultList = new ArrayList<>();
		
		List<String> userList = new ArrayList<>();
		for (OrganDeptVO vo : list) {
			if ("user".equalsIgnoreCase(vo.getType())) {
				userList.add(vo.getCn());
			}
		}
		// M365 Presence 정보 추가
		Map<String, String> presenceMap = new HashMap<>();
		if (!userList.isEmpty()) {
			List<TeamsPresenceVO> presenceList = ezTeamsDAO.getPresenceList(userList);
			for (TeamsPresenceVO presence : presenceList) {
				presenceMap.put(presence.getCn(), presence.getPresence());
			}
		}

		for (int j = 0; j < list.size(); j++) {
			Map<String, Object> map1 = new HashMap<>();
			OrganDeptVO organVO = list.get(j);
			Object result = null;

			if (!organVO.getCn().equals("") && organVO.getCn() != null) {
				if (organVO.getType().equals("user")) {
					map1.put("v_CN", organVO.getCn());
					map1.put("v_DEPTCD", organVO.getDisplayName());
					map1.put("v_LANGDATA", primary);
					map1.put("v_TENANT_ID", tenantID);
					map1.put("IS_ADDJOB", organVO.getIsAddjob());
					map1.put("JOBID", organVO.getJobId());
					map1.put("ROLEID", Optional.ofNullable(organVO.getRoleId()).filter(str -> !str.isEmpty()).orElse("0"));

					result = ezOrganDAO.getTBLUserMaster(map1);
				} else {
					map1.put("v_CN", organVO.getCn());
					map1.put("v_LANGDATA", primary);
					map1.put("v_TENANT_ID", tenantID);

					result = ezOrganDAO.getTBLDeptMaster(map1);
				}

				Map<String, Object> rowMap = commonUtil.getQueryResultAsJson(result);
				
				Map<String, Object> finalRow = new HashMap<>();
				finalRow.put("data1", "group".equalsIgnoreCase(organVO.getType()) ? "DEPT" : organVO.getType()); // ⬅ 변경됨
				finalRow.put("data2", rowMap.getOrDefault("cn", ""));

				finalRow.put("displayName", rowMap.getOrDefault("displayname", ""));
				finalRow.put("title", rowMap.getOrDefault("title", ""));
				finalRow.put("mail", rowMap.getOrDefault("mail", ""));
				finalRow.put("cn", rowMap.getOrDefault("cn", ""));
				finalRow.put("extensionAttribute2", rowMap.getOrDefault("extensionattribute2", ""));
				finalRow.put("telephoneNumber", rowMap.getOrDefault("telephonenumber", ""));
				finalRow.put("mobile", rowMap.getOrDefault("mobile", ""));
				finalRow.put("teamsId", rowMap.getOrDefault("teamsid", ""));
				finalRow.put("upnName", rowMap.getOrDefault("upnname", ""));
				finalRow.put("value", rowMap.getOrDefault("displayname", ""));
				finalRow.put("description", rowMap.getOrDefault("description", ""));
				finalRow.put("presence", "user".equalsIgnoreCase(organVO.getType()) ? presenceMap.getOrDefault(organVO.getCn(), "") : "");

				finalRow.put("isLeaf", "group".equalsIgnoreCase(organVO.getType()) ? "false" : "true");
				finalRow.put("addJob", organVO.getIsAddjob() == null ? "" : organVO.getIsAddjob());
				resultList.add(finalRow);
			}
		}

		logger.debug("getSearchListForTeamsJson ended");
		return resultList;
	}

}
