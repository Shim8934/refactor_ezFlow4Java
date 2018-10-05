package egovframework.ezEKP.ezApprovalG.service.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.reflect.Field;
import java.nio.file.Files;
import java.nio.file.OpenOption;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.io.FileUtils;
import org.apache.tomcat.util.codec.binary.Base64;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.jsoup.Jsoup;
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
import egovframework.ezEKP.ezApprovalG.vo.ApprGAutoRuleVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGContInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocStateVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormConnInfoVO;
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
import egovframework.let.utl.sim.service.EgovFileScrty;

@Service("EzApprovalGAdminService")
public class EzApprovalGAdminServiceImpl extends EgovFileMngUtil implements EzApprovalGAdminService{
	@Autowired
	private CommonUtil commonUtil;
	
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
	
	@Resource(name = "egovMessageSource")
    private EgovMessageSource messageSource;
	
	@Resource(name = "crypto")
	private EgovFileScrty egovFileScrty;
	
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalGAdminServiceImpl.class);

	@Override
	public String getContainerInfoManage(String deptID, String type, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("getContainerInfoManage started.");
		logger.debug("companyID = " + companyID + " || deptID = " + deptID);
		
		StringBuilder sb = new StringBuilder();
		
		Map<String, Object> map1 = new HashMap<String, Object>();		
		map1.put("v_DEPTID", deptID);
		map1.put("companyID", companyID);
		map1.put("tenantID", tenantID);
		
		List<ApprGContInfoVO> listBody = ezApprovalGAdminDAO.getContainerInfoManage(map1);
		
		String strMultiData = commonUtil.getMultiData(lang, tenantID);
		
		if (type.equals("LIST")) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_LISTTYPE", "106");
			map.put("v_LANGTYPE", lang);
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
			
			for (ApprGContInfoVO vo : listBody) {
				sb.append("<ROW><CELL>");
									
				if (strMultiData.equals("")) {
					sb.append("<VALUE>" + commonUtil.cleanValue(vo.getContainerTypeName()) + "</VALUE>");
					sb.append("<DATA3>" + commonUtil.cleanValue(vo.getContainerTypeName()) + "</DATA3>");
				} else {
					sb.append("<VALUE>" + commonUtil.cleanValue(vo.getContainerTypeName2()) + "</VALUE>");
					sb.append("<DATA3>" + commonUtil.cleanValue(vo.getContainerTypeName2()) + "</DATA3>");
				}
				
				sb.append("<DATA1>" + vo.getContainerID().trim() + "</DATA1>");
				sb.append("<DATA2>" + vo.getContainerTypeID().trim() + "</DATA2>");
				sb.append("<DATA4>" + vo.getContainerOwnDepID().trim() + "</DATA4>");
				sb.append("</CELL></ROW>");
			}
			
			sb.append("</ROWS></LISTVIEWDATA>");
		} else {
			sb.append("<PARAMETER>");
			
			for (ApprGContInfoVO vo : listBody) {
				int i = listBody.indexOf(vo);
				
				sb.append("<CONTID" + i + ">" + vo.getContainerID().trim() + "</CONTID" + i + ">");
									
				if (strMultiData.equals("")) {
					sb.append("<NAME" + i + ">" + commonUtil.cleanValue(vo.getContainerTypeName()) + "</NAME" + i + ">");
				} else {
					sb.append("<NAME" + i + ">" + commonUtil.cleanValue(vo.getContainerTypeName2()) + "</NAME" + i + ">");
				}					
			}
			
			sb.append("</PARAMETER>");
		}
		
		logger.debug("getContainerInfoManage ended." +sb.toString());
		
		return sb.toString();
	}

	@Override
	public String getContTypeInfo(String type, String companyID, String primary ,int tenantID, String lang) throws Exception {
		logger.debug("getContTypeInfo started.");
		
		StringBuilder sb = new StringBuilder();
		//String strMultiData = commonUtil.getMultiData(primary, tenantID);
		String strMultiData = commonUtil.getMultiData(lang, tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprGContInfoVO> list = ezApprovalGAdminDAO.getContTypeInfo(map);
		
		if (type.equals("LIST")) {
			sb.append("<LISTVIEWDATA><HEADERS><HEADER>");
			//sb.append("<NAME>" + ezApprovalGService.getCode2Name("L02", "001", companyID, primary, tenantID) + "</NAME><WIDTH>250</WIDTH></HEADER></HEADERS><ROWS>");
			sb.append("<NAME>" + ezApprovalGService.getCode2Name("L02", "001", companyID, lang, tenantID) + "</NAME><WIDTH>250</WIDTH></HEADER></HEADERS><ROWS>");
			
			for (ApprGContInfoVO vo : list) {
				if (strMultiData.equals("")) {
					sb.append("<ROW><CELL><VALUE>" + commonUtil.cleanValue(vo.getContainerTypeName()) + "</VALUE>");
				} else {
					sb.append("<ROW><CELL><VALUE>" + commonUtil.cleanValue(vo.getContainerTypeName2()) + "</VALUE>");
				}
				
				sb.append("<DATA1>" + vo.getContainerTypeID().trim() + "</DATA1></CELL></ROW>");				
			}
			
			sb.append("</ROWS></LISTVIEWDATA>");
		} else {
			sb.append("<PARAMETER>");
			
			for (ApprGContInfoVO vo : list) {
				int i = list.indexOf(vo);
				
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
		logger.debug("insertContainerType started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CONTTYPENAME", docTypeName);
		map.put("v_CONTTYPENAME2", docTypeName2);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		ezApprovalGAdminDAO.insertContainerType(map);
		
		logger.debug("insertContainerType ended.");
	}

	@Override
	public String getContainerToDocStateInfo(String companyID, String primary, int tenantID, String approvalFlag, String lang) throws Exception {
		logger.debug("getContainerToDocStateInfo started.");
		
		//String strMultiData = commonUtil.getMultiData(primary, tenantID);
		String strMultiData = commonUtil.getMultiData(lang, tenantID);
		
		StringBuilder sb = new StringBuilder();		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", "111");
		//map.put("v_LANGTYPE", primary);
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		map.put("v_LANGTYPE", lang);
		
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
		map1.put("companyID", companyID);
		map1.put("tenantID", tenantID);
		map1.put("approvalFlag", approvalFlag);
		
		List<ApprGDocStateVO> listBody = ezApprovalGAdminDAO.getContainerToDocStateInfo(map1);
		
		for (int i = 0; i < listBody.size(); i++) {
			ApprGDocStateVO vo = listBody.get(i);
			
			//Field field = vo.getClass().getDeclaredField("documentStateName" + commonUtil.getLangData(primary));
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
		
		if (docData != null && docData.getLength() > 0) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("tenantID", tenantID);
			
			logger.debug("deleteContainerDocState started.");
			ezApprovalGAdminDAO.deleteContainerDocState(map);
			logger.debug("deleteContainerDocState ended.");
			
			for (int i = 0; i < docData.getLength(); i++) {
				String data1 = docData.item(i).getChildNodes().item(1).getTextContent().trim();
				String data2 = docData.item(i).getChildNodes().item(0).getTextContent().trim();
				
				if (data1.equals("")) {
					data1 = null;
				}
				map.put("data1", data1);
				map.put("data2", data2);
				
				logger.debug("insertContainerDocState started.");
				ezApprovalGAdminDAO.insertContainerDocState(map);
				logger.debug("insertContainerDocState ended.");
			}
			
			result = "TRUE";
		}
		
		logger.debug("updateContainerToDocStateInfo ended.");
		
		return result;
	}

	@Override
	public String getContainerUseDeptInfo(String contID, String companyID, String primary, int tenantID) throws Exception {
		logger.debug("getContainerUseDeptInfo started.");
		
		String strMultiData = commonUtil.getMultiData(primary, tenantID);
		StringBuilder sb = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CONTID", contID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		List<ApprGContInfoVO> list = ezApprovalGAdminDAO.getContainerUseDeptInfo(map);
		
		sb.append("<PARAMETER>");
		
		if (list.size() > 0) {
			for (ApprGContInfoVO vo : list) {
				int i = list.indexOf(vo);
				
				sb.append("<ID" + i + ">" + vo.getUseDeptID().trim() + "</ID" + i + ">");
				
				if (strMultiData.equals("")) {
					sb.append("<NAME" + i + ">" + commonUtil.cleanValue(vo.getContainerTypeName()) + "</NAME" + i + ">");
				} else {
					sb.append("<NAME" + i + ">" + commonUtil.cleanValue(vo.getContainerTypeName2()) + "</NAME" + i + ">");
				}
			}
		} else {
			sb.append("<ID0>FALSE</ID0><NAME0></NAME0>");
		}
		
		sb.append("</PARAMETER>");
		
		logger.debug("getContainerUseDeptInfo ended.");
		
		return sb.toString();
	}

	@Override
	public String insertContainer(Document xmlData, String companyID, int tenantID) throws Exception {
		logger.debug("insertContainer started.");
		
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
		
		String duplicated = ezApprovalGAdminDAO.checkContainer(map);
		
		if (duplicated == null) {
			duplicated = "";
			logger.debug("insertContainer duplicated.");
			
			return "FALSE";
		} else {
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
			
			return "TRUE";
		}
	}

	@Override
	public String updateContainer(Document xmlData, String companyID, int tenantID) throws Exception {
		String pContID = xmlData.getDocumentElement().getChildNodes().item(0).getTextContent().trim();
		String pContType = xmlData.getDocumentElement().getChildNodes().item(1).getTextContent().trim();
		String pOwnDeptID = xmlData.getDocumentElement().getChildNodes().item(2).getTextContent().trim();
		
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
	    
	    return "TRUE";
	}

	@Override
	public String deleteContainer(String contID, String companyID, int tenantID) throws Exception {
		logger.debug("deleteContainer started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CONTID", contID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);

		logger.debug("deleteContainer1,2 started.");
		ezApprovalGAdminDAO.deleteContainer1(map);
		ezApprovalGAdminDAO.deleteContainer2(map);
		logger.debug("deleteContainer1,2 ended.");
		
		logger.debug("deleteContainer ended.");
		
		return "TRUE";
	}

	@Override
	public String getReceiveGroupInfo(String pid, String mode, String companyID, String lang, int tenantID, String offSet, String approvalFlag) throws Exception {
		StringBuilder sb = new StringBuilder();
		sb.append("<LISTVIEWDATA><HEADERS>");
		
		String code = "";
		if (approvalFlag.equals("S")) {
			code = "S091";
			
			if (mode.equals("ITEM")) {
				code = "S092";
			}
		} else {
			code = "091";
			
			if (mode.equals("ITEM")) {
				code = "092";
			}
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
		
		if (pid.equals("")) {
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
				
				//2018-09-06 김보미 - primary에서 lang으로 변경
				//if (!lang.equals("1") && fieldName.toUpperCase().equals("DEPTNAME")) {
				if (!commonUtil.getPrimaryData(lang, tenantID).equals("1") && fieldName.toUpperCase().equals("DEPTNAME")) {
					fieldName = fieldName + "2";
				}
				
				for (Field field : bodyVo.getClass().getDeclaredFields()) {
			        field.setAccessible(true);
										
					if (field.getName().toUpperCase().equals(fieldName.toUpperCase())) {
						fieldValue = String.valueOf(field.get(bodyVo));
					}					   
			    }
				
				sb.append("<ROW>");
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(ezApprovalGService.getListField(fieldName, fieldValue, companyID, lang, tenantID, offSet)) + "</VALUE>");
				
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
		
		return sb.toString();
	}

	@Override
	public String insertReceiveGroupItemInfo(String groupID, String deptID,	String deptName, String deptName2, String pCompanyID, String companyID, int tenantID) throws Exception {
		logger.debug("insertReceiveGroupItemInfo started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MAINID", groupID);
		map.put("v_DEPTID", deptID);
		map.put("v_DEPTNAME", deptName);
		map.put("v_DEPTNAME2", deptName2);
		map.put("v_COMPANYID", pCompanyID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		ezApprovalGAdminDAO.insertReceiveGroupItemInfo(map);
			
		logger.debug("insertReceiveGroupItemInfo ended.");
		
		return "TRUE";
	}
	
	@Override
	public String updateReceiveGroupItemInfo(String groupID, String deptID,	String deptName, String deptName2, String pCompanyID, String companyID, int tenantID) throws Exception {
		logger.debug("updateReceiveGroupItemInfo started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("mainID", groupID);
		map.put("deptID", deptID);
		map.put("deptName", deptName);
		map.put("deptName2", deptName2);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		ezApprovalGAdminDAO.updateReceiveGroupItemInfo(map);
		
		logger.debug("updateReceiveGroupItemInfo ended.");
		
		return "TRUE";
	}

	@Override
	public String deleteReceiveGroupItemInfo(String groupID, String companyID, int tenantID) throws Exception {
		logger.debug("deleteReceiveGroupItemInfo started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SUBID", groupID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		ezApprovalGAdminDAO.deleteReceiveGroupItemInfo(map);
		
		logger.debug("deleteReceiveGroupItemInfo ended.");
		
		return "TRUE";
		
	}

	@Override
	public String updateReceiveGroupInfo(String groupID, String groupName, String companyID, int tenantID) throws Exception {
		logger.debug("updateReceiveGroupInfo started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MAINID", groupID);
		map.put("v_MAINNAME", groupName);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		ezApprovalGAdminDAO.updateReceiveGroupInfo(map);
		
		logger.debug("updateReceiveGroupInfo ended.");
		
		return "TRUE";
	}

	@Override
	public String insertReceiveGroupInfo(String groupName, String companyID, int tenantID) throws Exception{
		logger.debug("insertReceiveGroupInfo started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MAINNAME", groupName);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		ezApprovalGAdminDAO.insertReceiveGroupInfo(map);
		
		logger.debug("insertReceiveGroupInfo ended.");
		
		return "TRUE";
	}

	@Override
	public String deleteReceiveGroupInfo(String groupID, String companyID, int tenantID) throws Exception {
		logger.debug("deleteReceiveGroupInfo started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MAINID", groupID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		ezApprovalGAdminDAO.deleteReceiveGroupInfo(map);
		
		logger.debug("deleteReceiveGroupInfo ended.");
		
		return "TRUE";
	}

	@Override
	public String getTaskCategoryTree(String categoryType, String parentID, String companyID, int tenantID, String approvalFlag) throws Exception {
		logger.debug("getTaskCategoryTree started.");
		logger.debug("categoryType=" + categoryType);
		
		StringBuilder sb = new StringBuilder();
		String isLeaf = "FALSE";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CATETYPE", categoryType);
		map.put("v_PARENTID", parentID);
		map.put("approvalFlag", approvalFlag);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprGTaskVO> list = ezApprovalGAdminDAO.getTaskCategotyTree(map);
		
		sb.append("<NODES>");
		
		for (ApprGTaskVO vo : list) {
			switch (vo.getCategoryType()) {
				case "1":
					isLeaf = getTaskCategoryNodeExist(vo.getCategoryType(), vo.getCategoryCode(), companyID, tenantID, approvalFlag);
					break;
				case "2":
					isLeaf = getTaskCategoryNodeExist(vo.getCategoryType(), vo.getMcategoryCode(), companyID, tenantID, approvalFlag);
					break;
				case "3":
//						isLeaf = getTaskCategoryNodeExist(vo.getCategoryType(), vo.getSubCategoryCode(), companyID, tenantID, approvalFlag);
					isLeaf = "FALSE";
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
					sb.append("<DATA2>" + commonUtil.cleanValue(vo.getCategoryCode()) + "</DATA2>");
					sb.append("<DATA3>" + commonUtil.cleanValue(vo.getDescription()) + "</DATA3>");
					sb.append("<DATA4>" + "ROOT" + "</DATA4>");
					break;
				case "2":
					sb.append("<DATA2>" + commonUtil.cleanValue(vo.getMcategoryCode()) + "</DATA2>");
					sb.append("<DATA3>" + commonUtil.cleanValue(vo.getDescription()) + "</DATA3>");
					sb.append("<DATA4>" + commonUtil.cleanValue(vo.getCategoryCode()) + "</DATA4>");
					break;
				case "3":
					sb.append("<DATA2>" + commonUtil.cleanValue(vo.getSubCategoryCode()) + "</DATA2>");
					sb.append("<DATA3>" + commonUtil.cleanValue(vo.getDescription()) + "</DATA3>");
					sb.append("<DATA4>" + commonUtil.cleanValue(vo.getMcategoryCode()) + "</DATA4>");
					break;
			}
			
			sb.append("</NODE>");
		}
		
		sb.append("</NODES>");
		
		logger.debug("getTaskCategoryTree ended.");
		
		return sb.toString();
	}

	@Override
	public String getTaskInSubCategoryForManage(String sCateCode, String langType, String companyID, int tenantID, String approvalFlag, String userFlag) throws Exception {
		logger.debug("getTaskInSubCategoryForManage started.");
		
		StringBuffer sb = new StringBuffer();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SUBCATECODE", sCateCode);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("approvalFlag", approvalFlag);
		map.put("lang", commonUtil.getMultiData(langType, tenantID));
		
		List<ApprGTaskVO> list = ezApprovalGAdminDAO.getTaskInSubCategoryForManage(map);
		
        sb.append("<DATA>");
        
        for (ApprGTaskVO vo : list) {
        	sb.append(commonUtil.getQueryResult(vo));
        }
        
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		String result = ezApprovalGService.makeTaskListXml(docXML, companyID, langType, tenantID, approvalFlag, userFlag);
		
		logger.debug("getTaskInSubCategoryForManage ended.");
		
		return result;
	}

	@Override
	public String getTaskCategoryDuplicate(String categoryType, String categoryCode, String companyID, int tenantID) throws Exception {
		logger.debug("getTaskCategoryDuplicate started.");
		
		String result = "FALSE";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CATETYPE", categoryType);
		map.put("v_CATECODE", categoryCode);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
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
	public String setTaskCategory(String categoryType, String categoryCode, String categoryName, String categoryName2, String categoryDesc, String pCode, String companyID, int tenantID, String approvalFlag) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CATETYPE", categoryType);
		map.put("v_CATECODE", categoryCode);
		map.put("v_NAME", categoryName);
		map.put("v_NAME2", categoryName2);
		map.put("v_DESC", categoryDesc);
		map.put("v_CODE", pCode);
		map.put("approvalFlag", approvalFlag);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		String duplicate = getTaskCategoryDuplicate(categoryType, categoryCode, companyID, tenantID);
		
		if (approvalFlag.equals("S")) {
			if (duplicate.equals("TRUE")) {
				logger.debug("setTaskCategory started. mode=U");
				
				if (getTaskCategoryNodeExist("3", categoryCode, companyID, tenantID, approvalFlag).equals("TRUE")) {
					for (int i = 3; i >= Integer.parseInt(categoryType); i--) {
						map.put("v_CATETYPE", i);
						
						ezApprovalGAdminDAO.setTaskCategoryUpdate(map);
					}
				}
			} else {
				logger.debug("setTaskCategory started. mode=I");
				ezApprovalGAdminDAO.setTaskCategoryInsert(map);
			}
		} else {
			if (duplicate.equals("TRUE")) {
				logger.debug("setTaskCategory started. mode=U");
				ezApprovalGAdminDAO.setTaskCategoryUpdate(map);
			} else {
				logger.debug("setTaskCategory started. mode=I");
				ezApprovalGAdminDAO.setTaskCategoryInsert(map);
			}
		}
		
		logger.debug("setTaskCategory ended.");
		
		return "TRUE";
	}

	@Override
	public String getTaskCategoryNodeExist(String categoryType, String categoryCode, String companyID, int tenantID, String approvalFlag) throws Exception {
		logger.debug("getTaskCategoryNodeExist started.");
		logger.debug("categoryType=" + categoryType);
		logger.debug("categoryCode=" + categoryCode);
		
		String result = "FALSE";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CATETYPE", categoryType);
		map.put("v_CATECODE", categoryCode);
		map.put("approvalFlag", approvalFlag);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		int count = ezApprovalGAdminDAO.getTaskCategoryNodeExist(map);
		
		if (count > 0) {
			result = "TRUE";
		}
		
		logger.debug("getTaskCategoryNodeExist ended. result=" + result);
		
		return result;
	}

	@Override
	public String removeTaskCategory(String categoryType, String categoryCode, String companyID, int tenantID, String approvalFlag) throws Exception {
		logger.debug("removeTaskCategory started.");
		
		String duplicate = getTaskCategoryNodeExist(categoryType, categoryCode, companyID, tenantID, approvalFlag);
		
		if (duplicate.equals("TRUE")) {
			logger.debug("removeTaskCategory ended. return EXIST");
			
			return "EXIST";
		} else {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_CATETYPE", categoryType);
			map.put("v_CATECODE", categoryCode);
			map.put("companyID", companyID);
			map.put("tenantID", tenantID);
			
			ezApprovalGAdminDAO.removeTaskCategory(map);
			
			logger.debug("removeTaskCategory ended. return TRUE");
			
			return "TRUE";
		}
	}

	@Override
	public String getTaskCodeDuplicate(String taskCode, String companyID, int tenantID) throws Exception {
		logger.debug("getTaskCodeDuplicate started.");
		String result = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TASKCODE", taskCode);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		int count = ezApprovalGAdminDAO.getTaskCodeDuplicate(map);
		
		if (count > 0) {
			result = "TRUE";
		} else {
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
		
		logger.debug("deptcode=" + pDeptCode);
		List<ApprGTaskVO> list = ezApprovalGAdminDAO.getTaskInfo(map);

		if (list.get(0) == null) {
			logger.debug("getTaskInfo ended. null");
			
			return "<RESULT>NOITEM</RESULT>";
		}
		
		String result = commonUtil.getQueryResult(list.get(0));
		
		logger.debug("getTaskInfo ended. result=" + result);
		
		return result;
	}

	//TODO 이효진 2017-02-28 다국어지원하려면 밑에스트링배열 message로 집어넣어야함
	@Override
	public String setTaskCode(ApprGTaskVO vo, String categoryName, String categoryName2, String categoryDesc, String companyID, LoginVO userInfo, String approvalFlag) throws Exception {
		logger.debug("setTaskCodeImpl started.");
		
		int tenantID = userInfo.getTenantId();

		if (getTaskCodeDuplicate(vo.getTaskCode(), companyID, userInfo.getTenantId()).equals("TRUE")) {
			if (approvalFlag.equals("G")) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("v_TASKCODE", vo.getTaskCode());
				map.put("companyID", companyID);
				map.put("tenantID", tenantID);
				
				logger.debug("getTaskCode started.");
				ApprGTaskVO item = ezApprovalGAdminDAO.getTaskCode(map);
				logger.debug("getTaskCode ended.");
				
				Document docXML = commonUtil.convertStringToDocument(commonUtil.getQueryResult(item));
				Document objParam = commonUtil.convertStringToDocument(commonUtil.getQueryResult(vo));
				
				//이효진 2017-03-14 스트링 DB에 초기데이터로 입력하고 db에서 꺼내오게 수정해야함
//					Map<String, Object> map3 = new HashMap<String, Object>();
//					map3.put("v_LISTTYPE", "094");
//					map3.put("v_LANGTYPE", userInfo.getLang());
//					map3.put("tenantID", userInfo.getCompanyID());
//					map3.put("companyID", userInfo.getCompanyID());
//					
//					List<ApprGListHeaderVO> apprGListHeaderVOList = ezApprovalGAdminDAO.getAdminListHeader(map3);
				
				//094 tableName
				String[] NAMETYPE = {"TASKNAME","TASKNAME2", "KEEPINGPERIOD", "KPREASON", 
									"KEEPINGMETHOD", "KEEPINGPLACE", "DISPLAYRECFLAG", "DISPLAYRECTRASTIME",
									"EXDISPLAYFREQUENCY", "SPECIALCATALOGFLAG", "SC1", "SC2", 
									"SC3", "DISPLAYUSAGE", "DESCRIPTION", "SUBCATEGORYCODE"};
				
				//094 Name1
				String[] NAMEDESC = {"단위업무명(한글)","단위업무명(영문)", "보존연한", "보존연한책정사유", 
									"보존방법", "보존장소", "비치기록물", "비치기록물이관시기", 
									"이관후예상열람빈도", "특수목록위치", "제1특수목록", "제2특수목록", 
									"제3특수목록", "주요열람용도", "단위업무설명", "소기능"};
				//094 Name2
                String[] NAMEDESC2 = {"Taskname(Han)","Taskname(Eng)", "KeepingPeriod", "KPREASON", 
									"KeepingMethod", "KeepingPlace", "DisplayREC", "DisplayRECTrastime", 
									"EXDisplayFrequency", "SCPlace", "SC1", "SC2", 
									"SC3", "DisplayUsage", "Description", "SubCategory"};
                
                for (int i=0; i<NAMETYPE.length; i++) {
					if (!docXML.getElementsByTagName(NAMETYPE[i]).item(0).getTextContent().trim().equals(objParam.getElementsByTagName(NAMETYPE[i]).item(0).getTextContent().trim())) {
                        String subSQL = setTaskHistory(vo.getTaskCode(), vo.getTaskName(), vo.getTaskName2(), NAMEDESC[i], NAMEDESC2[i], docXML.getElementsByTagName(NAMETYPE[i]).item(0).getTextContent().trim(), objParam.getElementsByTagName(NAMETYPE[i]).item(0).getTextContent().trim(), objParam.getElementsByTagName(NAMETYPE[i]).item(0).getTextContent().trim(), companyID, tenantID);
                        
                        if (subSQL.equals("FALSE")) {
							return "FALSE";
                        }
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
            map1.put("itemSecurity", vo.getItemSecurity());
            map1.put("isPublic", vo.getIsPublic());
            map1.put("companyID", companyID);
            map1.put("tenantID", tenantID);
            
            ezApprovalGAdminDAO.updateTaskCode(map1);
		} else {
			if (approvalFlag.equals("G")) {
				String subSQL = setTaskHistory(vo.getTaskCode(), vo.getTaskName(), vo.getTaskName2(), egovMessageSource.getMessage("ezApprovalG.lhj07", userInfo.getLocale()), "New creation", "", "", "", companyID, userInfo.getTenantId());
				
				if (subSQL.equals("FALSE")) {
					return "FALSE";
                }
			} else {
				if (vo.getLevel().equals("1")) {
					//중소
					//level, 현재코드, 현재이름, 현재이름2, 현재설명, 상위코드 
					
					setTaskCategory("2", vo.getSubCategoryCode(), categoryName, categoryName2, categoryDesc, vo.getSubCategoryCode(), companyID, tenantID, approvalFlag);
					setTaskCategory("3", vo.getSubCategoryCode(), categoryName, categoryName2, categoryDesc, vo.getSubCategoryCode(), companyID, tenantID, approvalFlag);
				} else if (vo.getLevel().equals("2")) {
					//소
					setTaskCategory("3", vo.getSubCategoryCode(), categoryName, categoryName2, categoryDesc, vo.getSubCategoryCode(), companyID, tenantID, approvalFlag);
				}
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
            map2.put("itemSecurity", vo.getItemSecurity());
            map2.put("isPublic", vo.getIsPublic());
            map2.put("companyID", companyID);
            map2.put("tenantID", tenantID);
           
            ezApprovalGAdminDAO.insertTaskCode(map2);
            
            if (approvalFlag.equals("S")) {
            	StringBuilder sb = new StringBuilder();
            	
            	sb.append("<PARAMETERS>");            	
            	sb.append("<DEPTCODE>" + commonUtil.cleanValue(userInfo.getDeptID()) + "</DEPTCODE>");
            	sb.append("<DEPTNAME>" + commonUtil.cleanValue(userInfo.getDeptName1()) + "</DEPTNAME>");
            	sb.append("<DEPTNAME2>" + commonUtil.cleanValue(userInfo.getDeptName2()) + "</DEPTNAME2>");
            	sb.append("<TASKCODE>" + vo.getTaskCode() + "</TASKCODE>");
            	sb.append("<TASKNAME>" + vo.getTaskName() + "</TASKNAME>");
            	sb.append("<TASKNAME2>" + vo.getTaskName2() + "</TASKNAME2>");
            	sb.append("<TITLE>" + vo.getTaskName() + "</TITLE>");
            	sb.append("<TITLE2>" + vo.getTaskName2() + "</TITLE2>");
            	sb.append("<RECTYPE>1</RECTYPE>");
            	sb.append("<EXPIREYEAR></EXPIREYEAR>");
            	sb.append("<KEEPPERIOD>" + vo.getKeepingPeriod() + "</KEEPPERIOD>");
            	sb.append("<KEEPMETHOD>" + vo.getKeepingMethod() + "</KEEPMETHOD>");
            	sb.append("<KEEPPLACE>" + vo.getKeepingPlace() + "</KEEPPLACE>");
            	sb.append("<DISPLAYFLAG>" + vo.getDisplayUsage() + "</DISPLAYFLAG>");
            	sb.append("<DISPLAYENDDATE></DISPLAYENDDATE>");
            	sb.append("<DISPLAYREASON></DISPLAYREASON>");
            	sb.append("<OWNERID>" + userInfo.getId() + "</OWNERID>");
            	sb.append("<OWNERNAME>" + commonUtil.cleanValue(userInfo.getDisplayName1()) + "</OWNERNAME>");
            	sb.append("<OWNERNAME2>" + commonUtil.cleanValue(userInfo.getDisplayName2()) + "</OWNERNAME2>");
            	sb.append("<VOLNUM>1</VOLNUM>");
            	sb.append("<SPECIALFLAG>0</SPECIALFLAG>");
            	sb.append("<SPECIALCATALOGINFO></SPECIALCATALOGINFO>");
            	sb.append("<COMPANYID>" + commonUtil.cleanValue(companyID) + "</COMPANYID>");
            	sb.append("</PARAMETERS>");
            	
            	Document xmlDom = commonUtil.convertStringToDocument(sb.toString());
            	
            	ezApprovalGService.registerCabinet(xmlDom, userInfo.getLang(), userInfo.getTenantId());
            }
		}
		
		logger.debug("setTaskCode ended.");
		
		return "TRUE";

	}
	
	@Override
	public String getTaskCodeNodeExist(String taskCode, String deptID, String companyID,int tenantID) throws Exception {
		logger.debug("getTaskCodeNodeExist started.");
		
		String result = "FALSE";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TASKCODE", taskCode);
		map.put("v_DEPTID", deptID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		int count = ezApprovalGAdminDAO.getTaskCodeNodeExist(map);
		
		if (count > 0) {
			result = "TRUE";
		} else {
			result = "FALSE";
		}
		
		logger.debug("getTaskCodeNodeExist ended. result = " + result);
		
		return result;
	}

	@Override
	public String removeTaskCode(String taskCode, String companyID, LoginVO userInfo, String approvalFlag) throws Exception {
		logger.debug("removeTaskCode started.");
		
		String tempFlag = null;
		
		if (approvalFlag.equals("S")) {
			tempFlag = "FALSE";
		} else {
			tempFlag = getTaskCodeNodeExist(taskCode, "", companyID, userInfo.getTenantId());
		}
		
		int tenantID = userInfo.getTenantId();

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
			
			if (approvalFlag.equals("G")) {
				String temp = setTaskHistory(taskCode, vo.getTaskName(), vo.getTaskName2(), egovMessageSource.getMessage("ezApprovalG.lhj08", userInfo.getLocale()), "Deleted", "", "", "", companyID, tenantID);
				
				if (temp.equals("FALSE")) {
					return "FALSE";
				}
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
			sb.append("<VALUE>" + commonUtil.cleanValue(vo.getProcessDeptCode()) + "</VALUE>");
			sb.append("<DATA1>" + commonUtil.cleanValue(vo.getProcessDeptName()) + "</DATA1>");
			sb.append("<DATA2>" + commonUtil.cleanValue(vo.getProcessDeptName2()) + "</DATA2>");
			sb.append("</CELL><CELL>");
			sb.append("<VALUE>" + (lang.equals("1") ? commonUtil.cleanValue(vo.getProcessDeptName()) : commonUtil.cleanValue(vo.getProcessDeptName2())) + "</VALUE>");
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
		
		logger.debug("getTaskName started.");
		ApprGTaskVO vo = ezApprovalGAdminDAO.getTaskName(map);
		logger.debug("getTaskName ended.");
		
		String temp = setTaskHistory(taskCode, vo.getTaskName(), vo.getTaskName2(), egovMessageSource.getMessage("ezApprovalG.lhj09", userInfo.getLocale()), "Designates the Dept", "", deptName, deptName2, companyID, tenantID);
		
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
	}

	@Override
	public String removeTaskCodeDeptInfo(String taskCode, String deptCode, String deptName, String deptName2, String companyID, LoginVO userInfo) throws Exception {
		logger.debug("removeTaskCodeDeptInfo started.");
		int tenantID = userInfo.getTenantId();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TASKCODE", taskCode);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		logger.debug("getTaskName started.");
		ApprGTaskVO vo = ezApprovalGAdminDAO.getTaskName(map);
		logger.debug("getTaskName ended.");
		
		String temp = setTaskHistory(taskCode, vo.getTaskName(), vo.getTaskName2(), egovMessageSource.getMessage("ezApprovalG.lhj10", userInfo.getLocale()), "Delete the dept", deptName, "", deptName2, companyID, tenantID);
		
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
	}
	
	@Override
	public String getTaskHistory(String taskCode, String companyID, String lang, int tenantID, String offset) throws Exception {
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
				
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(ezApprovalGService.getListField(fieldName.toUpperCase(), fieldValue, companyID, lang, tenantID, offset)) + "</VALUE></CELL>");
			}
			
			sb.append("</ROW>");
		}
		
		sb.append("</ROWS></LISTVIEWDATA>");
		
		logger.debug("getTaskHistory ended.");
		
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
		
		List<ApprGTaskVO> list = ezApprovalGAdminDAO.getTaskFullList(map);
		
		sb.append("<DATA>");
		
		for (ApprGTaskVO vo : list) {
			sb.append(commonUtil.getQueryResult(vo));
		}
		
		sb.append("</DATA>");
		
		String result = ezApprovalGService.makeTaskFullListXml(commonUtil.convertStringToDocument(sb.toString()), companyID, pageSize, pageNo, langType, tenantID);
		
		logger.debug("getTaskFullList ended.");
		
		return result;
	}

	@Override
	public String getSealList(String realPath, String listFlag, String companyID, String lang, int tenantID, String offset) throws Exception {
		logger.debug("getSealList started.");
		StringBuilder sb = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTFLAG", listFlag);
		map.put("v_PMULTIDATA", lang);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprGSealInfoVO> list = ezApprovalGAdminDAO.getSealList(map);
		
		sb.append("<ROWS>");
		
		for (ApprGSealInfoVO vo : list) {
			sb.append("<ROW>");
			sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getSealName()) + "</VALUE>");
			sb.append("<DATA1>" + vo.getSealNum() + "</DATA1>");
			sb.append("<DATA2>" + vo.getSealPath() + "</DATA2>");
			sb.append("<DATA3>" + commonUtil.cleanValue(vo.getRegUserID()) + "</DATA3>");
			File file = new File(realPath + vo.getSealPath());
			if ( !file.exists() ) {
				sb.append("<DATA4>false</DATA4></CELL>");
			} else {
				sb.append("</CELL>");
			}
			sb.append("<CELL><VALUE>" + vo.getSealWidth() + "</VALUE></CELL>");
			sb.append("<CELL><VALUE>" + vo.getSealHeight() + "</VALUE></CELL>");
			// bug.kaoni.com(#11758) 요청에 의해 날짜까지만 표현하게 편경, substring(0, 19) -> substring(0, 10)
			sb.append("<CELL><VALUE>" + commonUtil.getDateStringInUTC(vo.getRegDate().substring(0, 10), offset, false) + "</VALUE></CELL>");
			
			if (vo.getDelDate() == null) {
				sb.append("<CELL><VALUE>" + " " + "</VALUE></CELL>");
			} else {
				sb.append("<CELL><VALUE>" + commonUtil.getDateStringInUTC(vo.getDelDate().substring(0, 10), offset, false) + "</VALUE></CELL>");
			}
			
			if (!file.exists()) {
				sb.insert(sb.indexOf("</DATA3>") + 8, "<DATA4>false</DATA4>");
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
		logger.debug("sealDelete started.");
		
		deleteFile(realPath + dirPath + fileName);
		
		logger.debug("sealDelete ended.");
		
		return "TRUE";
	}

	@Override
	public String deleteSealInfo(String pSealNum, String companyID, int tenantID) throws Exception {
		logger.debug("deleteSealInfo started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SEALNUM", pSealNum);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		ezApprovalGAdminDAO.deleteSealInfo(map);
		
		logger.debug("deleteSealInfo ended.");
		
		return "TRUE";
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
		
		logger.debug("insertSealInfoSelect started.");
		int result = ezApprovalGAdminDAO.insertSealInfoSelect(map);
		logger.debug("insertSealInfoSelect ended. result = " + result);
		
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
	}

	@Override
	public String getSealDeptList(String realPath, String listFlag, String deptID, String companyID, String primary, String offset, int tenantID) throws Exception {
		logger.debug("getSealDeptList started.");
		StringBuilder sb = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTFLAG", listFlag);
		map.put("v_DEPTID", deptID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprGSealInfoVO> list = ezApprovalGAdminDAO.getSealDeptList(map);
		
		sb.append("<ROWS>");
		
		for (ApprGSealInfoVO vo : list) {
			sb.append("<ROW>");
			sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getSealName()) + "</VALUE>");
			sb.append("<DATA1>" + vo.getSealNum() + "</DATA1>");
			sb.append("<DATA2>" + vo.getSealPath() + "</DATA2>");
			sb.append("<DATA3>" + commonUtil.cleanValue(vo.getRegUserID()) + "</DATA3></CELL>");
			sb.append("<CELL><VALUE>" + vo.getSealWidth() + "</VALUE></CELL>");
			sb.append("<CELL><VALUE>" + vo.getSealHeight() + "</VALUE></CELL>");
			// substring을 통해 날짜까지만 표시
			sb.append("<CELL><VALUE>" + commonUtil.getDateStringInUTC(vo.getRegDate().substring(0, 10), offset, false) + "</VALUE></CELL>");
			
			if (vo.getDelDate() == null) {
				sb.append("<CELL><VALUE>" + " " + "</VALUE></CELL>");
			} else {
				sb.append("<CELL><VALUE>" + commonUtil.getDateStringInUTC(vo.getDelDate().substring(0, 10), offset, false) + "</VALUE></CELL>");
			}

			if (primary.equals("1")) {
				sb.append("<CELL><VALUE>" + vo.getRegUserName() + "</VALUE></CELL>");
			} else {
				sb.append("<CELL><VALUE>" + vo.getRegUserName2() + "</VALUE></CELL>");
			}
			
			File file = new File(realPath + vo.getSealPath());
			
			if (!file.exists()) {
				sb.insert(sb.indexOf("</DATA3>") + 8, "<DATA4>false</DATA4>");
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
		
		int temp = ezApprovalGAdminDAO.insertDeptSealInfoSelect(map);
		
		if (temp == 0) {
			ezApprovalGAdminDAO.insertDeptSealInfoInsert(map);
		} else {
			ezApprovalGAdminDAO.insertDeptSealInfoUpdate(map);
		}
		
		logger.debug("insertDeptSealInfo ended.");
		
		return "TRUE";
	}
	
	@Override
	public String deleteDeptSealInfo(String pSealNum, String deptID, String companyID, int tenantID) throws Exception {
		logger.debug("deleteDeptSealInfo started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SEALNUM", pSealNum);
		map.put("v_DEPTID", deptID);
		map.put("companyID", companyID);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		ezApprovalGAdminDAO.deleteSealDeptInfo(map);
		
		logger.debug("deleteDeptSealInfo ended.");
		
		return "TRUE";
	}

	@Override
	public String getDeptTranSendDocCount(String sYear, String sMonth, String eYear, String eMonth, String pMode, String companyID, String lang, String offset, int tenantID, String approvalFlag) throws Exception {
		logger.debug("getDeptTranSendDocCount started.");
		logger.debug("sYear = " + sYear + " || sMonth = " + sMonth + " || eYear = " + eYear + " || eMonth = " + eMonth + " || pMode = " + pMode + " || companyID = " + companyID + " || lang = " + lang + " || offset = " + offset + " || tenantID = " + tenantID + " || approvalFlag = " + approvalFlag);
		
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
		
		Calendar cal = Calendar.getInstance();
		  
		cal.set(Calendar.YEAR, Integer.parseInt(eYear));
		cal.set(Calendar.MONTH, Integer.parseInt(eMonth)-1);
		
		String eDate = Integer.toString(cal.getActualMaximum(Calendar.DATE));
		
		String szFrom = commonUtil.getDateStringInUTC(sYear + "-" + sMonth + "-01 00:00:00", offset, true);
		String szTo = commonUtil.getDateStringInUTC(eYear + "-" + eMonth + "-" + eDate + " 23:59:59", offset, true);
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_MODE", pMode);
		map1.put("v_FROM", szFrom);
		map1.put("v_TO", szTo);
		map1.put("v_LANGTYPE", commonUtil.getPrimaryData(lang, tenantID));
		map1.put("companyID", companyID);
		map1.put("tenantID", tenantID);
		
		logger.debug("mode=" + pMode);
		logger.debug("szFrom=" + szFrom);
		logger.debug("szTo=" + szTo);
		logger.debug("lang=" + lang);
		
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
		
		logger.debug("getDeptTranSendDocCount ended.");
		
		return sb.toString();
	}

	@Override
	public String getUserDocCount(String sYear, String sMonth, String eYear, String eMonth, String userFlag, String companyID, LoginVO userInfo, String approvalFlag) throws Exception {
		logger.debug("getUserDocCount started.");
		logger.debug("sYear = " + sYear + " || sMonth = " + sMonth + " || eYear = " + eYear + " || eMonth = " + eMonth + " || userFlag = " + userFlag + " || companyID = " + companyID + " || approvalFlag = " + approvalFlag);
		
		String lang = userInfo.getLang();
		String offset = userInfo.getOffset();
		int tenantID = userInfo.getTenantId();
		Locale locale = userInfo.getLocale();
		StringBuilder sb = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		if (approvalFlag.equals("S")) {
			map.put("v_LISTTYPE", "S104");
		} else {
			map.put("v_LISTTYPE", "107");
		}
		
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
			
			if (approvalFlag.equals("G") && vo.getName().equals(egovMessageSource.getMessage("ezApprovalG.t445", locale))) {
				switch (userFlag) {
				case "1":
					vo.setName(egovMessageSource.getMessage("ezApprovalG.t445", locale));
					break;
				case "2":
					vo.setName(egovMessageSource.getMessage("ezApprovalG.t1304", locale));
					break;
				case "3":
					vo.setName(egovMessageSource.getMessage("ezApprovalG.t1305", locale));
					break;
				case "4":
					vo.setName(egovMessageSource.getMessage("ezApprovalG.t1306", locale));
					break;
				default:
					vo.setName(egovMessageSource.getMessage("ezApprovalG.t445", locale));
					break;
				}
			}
			
			sb.append("<NAME>" + commonUtil.cleanValue(vo.getName()) + "</NAME>");
			sb.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
			sb.append("</HEADER>");
		}
		
		sb.append("</HEADERS><ROWS>");
		
		//G에서만 쓰는거
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
		
		Calendar cal = Calendar.getInstance();
		
		cal.set(Calendar.YEAR, Integer.parseInt(eYear));
		cal.set(Calendar.MONTH, Integer.parseInt(eMonth)-1);
		
		String eDate = Integer.toString(cal.getActualMaximum(Calendar.DATE));
		
		String szFrom = commonUtil.getDateStringInUTC(sYear + "-" + sMonth + "-01 00:00:00", offset, true);
		String szTo = commonUtil.getDateStringInUTC(eYear + "-" + eMonth + "-" + eDate + " 23:59:59", offset, true);
		
		logger.debug("szFrom=" + szFrom);
		logger.debug("szTo=" + szTo);
		
		/* 2018-09-07 홍승비 - 결재방법 다국어 데이터(v_LANG) 수정 */
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_APRTYPE", aprType);
		map1.put("v_FROM", szFrom);
		map1.put("v_TO", szTo);
		map1.put("v_STRLANG", commonUtil.getMultiData(lang, tenantID));
		map1.put("v_LANG", commonUtil.getLangData(lang));
		map1.put("userFlag", userFlag);
		map1.put("companyID", companyID);
		map1.put("tenantID", tenantID);
		map1.put("approvalFlag", approvalFlag);
		map1.put("v_CODELANG", lang == "1" ? "" : lang);
		
		logger.debug("aprType=" + aprType);
		List<ApprGAprLineVO> list = ezApprovalGAdminDAO.getUserDocCount(map1);
		
		for (ApprGAprLineVO vo : list) {
			sb.append("<ROW>");
			
			sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getAprMemberDeptName()) + "</VALUE>");
			sb.append("<DATA1>" + commonUtil.cleanValue(vo.getAprMemberDeptID()) + "</DATA1>");
			sb.append("<DATA2>" + commonUtil.cleanValue(vo.getAprMemberID()) + "</DATA2></CELL>");
			sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getAprMemberJobTitle()) + "</VALUE></CELL>");
			sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getAprMemberName()) + "</VALUE></CELL>");
			
			if (approvalFlag.equals("S")) {
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getAprTypeName()) + "</VALUE></CELL>");
			}
			
			sb.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getAprCount()) + "</VALUE></CELL>");
			
			sb.append("</ROW>");
		}
		
		sb.append("</ROWS></LISTVIEWDATA>");
		
		logger.debug("getUserDocCount ended. listsize = " + list.size());
		
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
			String orderCell, String orderOption, String companyID, String lang, String approvUser, String offset, int tenantID)
			throws Exception {
		logger.debug("searchManageAprDocList started.");
		
		String orderOption1 = "";
		String orderOption2 = "";
		String multiData = commonUtil.getMultiData(lang, tenantID);
		StringBuilder sb = new StringBuilder();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", "081");
		map.put("v_LANGTYPE", lang);
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
		map1.put("v_LANGTYPE", multiData);
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
		map2.put("v_LANGTYPE", multiData);
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
					fieldName = fieldName + multiData;
				}
				
				for (Field field : bodyVo.getClass().getDeclaredFields()) {
			        field.setAccessible(true);
										
					if (field.getName().toUpperCase().equals(fieldName.toUpperCase())) {
						fieldValue = String.valueOf(field.get(bodyVo));
					}
			    }
				
				sb.append("<CELL><VALUE>" + commonUtil.cleanValue(ezApprovalGService.getListField(fieldName.toUpperCase(), fieldValue, companyID, lang, tenantID, offset)) + "</VALUE>");

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
		logger.debug("setFormOrder started. formIDList = " + formIDList + " || formContID = " + formContID);
		
		int index = 0;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pFormContID", formContID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		for (String formID : formIDList.split(";")) {
			map.put("v_pFormID", formID);
			map.put("order", ++index);
			
			logger.debug("index=" + index);
			
			ezApprovalGAdminDAO.setFormOrder(map);
		}
		
		logger.debug("setFormOrder ended.");
		
		return "OK";
	}

	@Override
	public String insertFormContainer(String contName, String contName2, String contDescript, String contParent, String contDept, String deptList, String companyID, int tenantID) throws Exception {
		contParent = (contParent.equals("") ? "ROOT" : contParent);
		contDept = (contDept.equals("") ? " " : contDept);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		logger.debug("insertFormContainerConti started.");
		String contID = ezApprovalGAdminDAO.insertFormContainerConti(map);
		logger.debug("insertFormContainerConti ended. contID=" + contID);
		
		if (contID != null && contID.substring(0, 4).equals(commonUtil.getTodayUTCTime("YYYY"))) {
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
				logger.debug("insertFormContainerGroup ended.");
			}
		}
		
		return "<PARAMETER><FContID>" + contID + "</FContID></PARAMETER>";
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
				
			if (deptList != "") {
				for(String deptID : deptList.split(";")) {
					map3.put("deptID", deptID);
					map3.put("tenantID", tenantID);
					
					logger.debug("insertFormContainerGroup started.");
					ezApprovalGAdminDAO.insertFormContainerGroup(map3);
					logger.debug("insertFormContainerGroup ended.");
				}
			}
		}
		
		return "<PARAMETER><RTNVALUE>" + contID + "</RTNVALUE></PARAMETER>";
	}

	@Override
	public String deleteFormContainer(String contID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMCONTID", contID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		logger.debug("deleteFormContainer started.");
		ezApprovalGAdminDAO.deleteFormContainer1(map);
		ezApprovalGAdminDAO.deleteFormContainer2(map);
		logger.debug("deleteFormContainer ended.");
		
		return "TRUE";
	}

	@Override
	public ApprGFormVO getFormContent(String formID, String lang, String companyID, int tenantID, String approvalFlag) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PFORMID", formID);
		map.put("approvalFlag", approvalFlag);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		logger.debug("getFormContent started. formID = " + formID);
		ApprGFormVO vo = ezApprovalGAdminDAO.getFormContent(map);
		logger.debug("getFormContent ended.");
		
		return vo;
	}

	@Override
	public String delForm(String formID, String companyID, String realPath, int tenantID) throws Exception {
		logger.debug("delForm started.");
		String result = deleteForm(formID, companyID, tenantID);
		
		if (result.equals("TRUE")) {
			deleteFile(realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID) + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + formID + ".mht");
			
			result = "TRUE";
		} else {
			result = "FALSE";
		}
		
		logger.debug("delForm ended. result=" + result);
		
		return result;
	}

	@Override
	public String getFormRecvAdmin(String formID, String lang, String companyID, int tenantID, String approvalFlag, String useReceiveInfoName) throws Exception {
		logger.debug("getFormRecvAdmin started.");
		
		String multiData = commonUtil.getMultiData(lang, tenantID);
		StringBuilder sb = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (approvalFlag.equals("S")) {
			map.put("v_LISTTYPE", "S103");
		} else {
			map.put("v_LISTTYPE", "105");
		}
		
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
		sb.append("</HEADERS>");
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_FORMID", formID);
		map1.put("companyID", companyID);
		map1.put("tenantID", tenantID);
		map1.put("approvalFlag", approvalFlag);
		
		
		List<ApprGFormVO> listBody = ezApprovalGAdminDAO.getFormRecvAdmin(map1);
		
		sb.append("<ROWS>");
		
		for (int i = 0; i < listBody.size(); i++) {
			ApprGFormVO bodyVo = listBody.get(i);
			
			sb.append("<ROW>");
			
			for (int j = 0; j < listHeader.size(); j++) {
				sb.append("<CELL>");
				
				if (approvalFlag.equals("S")) {
					if (j == 0) {
						sb.append("<VALUE>" + commonUtil.cleanValue(ezOrganService.getPropertyValue(bodyVo.getDeptID(), "displayName" + multiData, tenantID)) + "</VALUE>");
						sb.append("<DATA1>" + bodyVo.getDeptID() + "</DATA1>");
						sb.append("<DATA2>" + bodyVo.getUserID() + "</DATA2>");
					} else {
						sb.append("<VALUE>" + commonUtil.cleanValue(ezOrganService.getPropertyValue(bodyVo.getUserID(), "displayName" + multiData, tenantID)) + "</VALUE>");
					}
				} else {
					if (useReceiveInfoName.equals("1")) {
						sb.append("<VALUE>" + commonUtil.cleanValue(bodyVo.getDeptName()) + "</VALUE>");
					} else {
						sb.append("<VALUE>" + commonUtil.cleanValue(ezOrganService.getPropertyValue(bodyVo.getDeptID(), "displayName" + multiData, tenantID)) + "</VALUE>");
					}

					if (j == 0) {
						sb.append("<DATA1>" + bodyVo.getDeptID() + "</DATA1>");
					} else {
					}
				}
				sb.append("</CELL>");
				
			}
			
			sb.append("</ROW>");
		}
		
		sb.append("</ROWS>");
		sb.append("</LISTVIEWDATA>");

		logger.debug("getFormRecvAdmin ended.");
		
		return sb.toString();
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
		
		logger.debug("setTaskHistory started.");
		ezApprovalGAdminDAO.setTaskHistory(map);
		logger.debug("setTaskHistory ended.");
		
		return "TRUE";
	}
	
	private String deleteForm(String formID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", formID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		logger.debug("deleteForm started.");
		ezApprovalGAdminDAO.deleteForm1(map);
		ezApprovalGAdminDAO.deleteForm2(map);
		logger.debug("deleteForm ended.");
		
		return "TRUE";
	}
	
	//TODO 2017-01-05 이효진 연동정보 및 workflow 등록 및 수정 부분 미구현(EZSP_SETFORMDATA)
	@Override
	public String saveFormInfo(String contID, String formID, String formInfo, String formConnInfo, String formWorkFlow, String formRecevGroup, String formMhtInfo, String formAutoRule, String formAutoRuleLine, String companyID, String realPath, LoginVO userInfo, String approvalFlag, String reformMht, String reformHtml, String reformFunction) throws Exception {
		logger.debug("saveFormInfo started.");
		String strBeforeMHT = "";
		String path = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(formInfo);
		String keepPeriod = "";
		String keepPeriodCode = "";
		String securityLevel = "";
		String isPublic = "";
		String tbItemCode = "";
		String tbItemName = "";
		String tbItemName2 = "";
		String useFlag = "";
		String formConnFlag = "";
		
		String formName = doc.getElementsByTagName("FormName").item(0).getTextContent();
		String formName2 = doc.getElementsByTagName("FormName2").item(0).getTextContent();
		String formDescript = doc.getElementsByTagName("FormDescript").item(0).getTextContent();
		String formKind = doc.getElementsByTagName("FormKind").item(0).getTextContent();
		
		if (approvalFlag.equals("S")) {
			keepPeriod = doc.getElementsByTagName("KEEPPERIOD").item(0).getTextContent();
			keepPeriodCode = doc.getElementsByTagName("KEEPPERIODCODE").item(0).getTextContent();
			securityLevel = doc.getElementsByTagName("SECURITYLEVEL").item(0).getTextContent();
			isPublic = doc.getElementsByTagName("ISPUBLIC").item(0).getTextContent();
			tbItemCode = doc.getElementsByTagName("TBITEMCODE").item(0).getTextContent();
			tbItemName = doc.getElementsByTagName("TBITEMNAME").item(0).getTextContent();
			tbItemName2 = doc.getElementsByTagName("TBITEMNAME2").item(0).getTextContent();
			useFlag = doc.getElementsByTagName("USEFLAG").item(0).getTextContent();
		} else {
			formConnFlag = doc.getElementsByTagName("ConnFlag").item(0).getTextContent();
		}

		String recevGroupXML = "";
		if (formRecevGroup != null && !formRecevGroup.equals("")) {
			recevGroupXML = formRecevGroup;
		}
		
		String saveFileFolder = "";
		String saveFileName = "";
		// FormBuilder
		boolean useReform = reformMht != null;

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
		// FormBuilder
		map.put("v_PREFORMFLAG", useReform ? "Y" : "N");

		if (formID.equals("")) {
			logger.debug("setFormDataSelect started.");
			formID = ezApprovalGAdminDAO.setFormDataSelect(map);
			logger.debug("setFormDataSelect ended.");
			
			if (formID == null) {
				formID = commonUtil.getTodayUTCTime("YYYY") + "000001";
			} else {
				if (formID.substring(0,4).equals(commonUtil.getTodayUTCTime("YYYY"))) {
					formID = Integer.toString((Integer.parseInt(formID) + 1));
				} else {
					formID = commonUtil.getTodayUTCTime("YYYY") + "000001";
				}
			}
			
			map.put("v_PURL", path + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + formID + ".mht");
			map.put("v_PFORMID", formID);
			logger.debug("setFormDataInsert1 started.");
			ezApprovalGAdminDAO.setFormDataInsert1(map);
			logger.debug("setFormDataInsert1 ended.");
			
			if (approvalFlag.equals("S")) {
				map.put("keepPeriod", keepPeriod);
				map.put("keepPeriodCode", keepPeriodCode);
				map.put("securityLevel", securityLevel);
				map.put("isPublic", isPublic);
				map.put("tbItemCode", tbItemCode);
				map.put("tbItemName", tbItemName);
				map.put("tbItemName2", tbItemName2);
				map.put("useFlag", useFlag);
				
				logger.debug("setAutoDocNum started.");
				ezApprovalGAdminDAO.setAutoDocNum(map);
				logger.debug("setAutoDocNum ended.");
				
				if (!formAutoRule.equals("")) {
					doc = commonUtil.convertStringToDocument(formAutoRule);
					
					map = new HashMap<String, Object>();
					map.put("formID", formID);
					map.put("companyID", companyID);
					map.put("tenantID", userInfo.getTenantId());

					for (int i=0; i < doc.getElementsByTagName("ROW").getLength(); i++) {
						map.put("autoRuleSN", doc.getElementsByTagName("AUTORULESN").item(i).getTextContent());
						map.put("autoRuleGUID", doc.getElementsByTagName("AUTORULEGUID").item(i).getTextContent());
						map.put("checkFieldType", doc.getElementsByTagName("CHECKFIELDTYPE").item(i).getTextContent());
						map.put("checkField", doc.getElementsByTagName("CHECKFIELD").item(i).getTextContent());
						map.put("operatorType", doc.getElementsByTagName("OPERATORTYPE").item(i).getTextContent());
						map.put("operator", doc.getElementsByTagName("OPERATOR").item(i).getTextContent());
						map.put("condType", doc.getElementsByTagName("CONDTYPE").item(i).getTextContent());
						map.put("condValue", doc.getElementsByTagName("CONDVALUE").item(i).getTextContent());
						map.put("condValueDeptID", doc.getElementsByTagName("CONDVALUEDEPTID").item(i).getTextContent());
						map.put("docType", doc.getElementsByTagName("DOCTYPE").item(i).getTextContent());
						
						logger.debug("insertAutoRule started.");
						ezApprovalGAdminDAO.insertAutoRule(map);
						logger.debug("insertAutoRule ended.");
					}
				}
				
				if (!formAutoRuleLine.equals("")) {
					doc = commonUtil.convertStringToDocument(formAutoRuleLine);
					
					map = new HashMap<String, Object>();
					map.put("formID", formID);
					map.put("companyID", companyID);
					map.put("tenantID", userInfo.getTenantId());

					for (int i=0; i < doc.getElementsByTagName("ROW").getLength(); i++) {
						map.put("autoRuleGUID", doc.getElementsByTagName("AUTORULEGUID").item(i).getTextContent());
						map.put("aprMemberSN", doc.getElementsByTagName("APRMEMBERSN").item(i).getTextContent());
						map.put("aprType", doc.getElementsByTagName("APRTYPE").item(i).getTextContent());
						map.put("aprState", doc.getElementsByTagName("APRSTATE").item(i).getTextContent());
						map.put("aprMemberID", doc.getElementsByTagName("APRMEMBERID").item(i).getTextContent());
						map.put("aprMemberIsDeptYN", doc.getElementsByTagName("APRMEMBERISDEPTYN").item(i).getTextContent());
						map.put("aprMemberName", doc.getElementsByTagName("APRMEMBERNAME").item(i).getTextContent());
						map.put("aprMemberName2", doc.getElementsByTagName("APRMEMBERNAME2").item(i).getTextContent());
						map.put("aprMemberJobTitle", doc.getElementsByTagName("APRMEMBERJOBTITLE").item(i).getTextContent());
						map.put("aprMemberJobTitle2", doc.getElementsByTagName("APRMEMBERJOBTITLE2").item(i).getTextContent());
						map.put("aprMemberDeptID", doc.getElementsByTagName("APRMEMBERDEPTID").item(i).getTextContent());
						map.put("aprMemberDeptName", doc.getElementsByTagName("APRMEMBERDEPTNAME").item(i).getTextContent());
						map.put("aprMemberDeptName2", doc.getElementsByTagName("APRMEMBERDEPTNAME2").item(i).getTextContent());
						map.put("aprMemberLdapPath", doc.getElementsByTagName("APRMEMBERLDAPPATH").item(i).getTextContent());
						map.put("reasonDoNotApprov", doc.getElementsByTagName("REASONDONOTAPPROV").item(i).getTextContent());
						map.put("isProposerYN", doc.getElementsByTagName("ISPROPOSERYN").item(i).getTextContent());
						map.put("isBriefUserYN", doc.getElementsByTagName("ISBRIEFUSERYN").item(i).getTextContent());
						
						logger.debug("insertAutoRuleLine started.");
						ezApprovalGAdminDAO.insertAutoRuleLine(map);
						logger.debug("insertAutoRuleLine ended.");
					}
				}
			}
			
			if (!recevGroupXML.equals("")) {
				map = new HashMap<String, Object>();
				map.put("v_PFORMID", formID);
				map.put("companyID", companyID);
				map.put("tenantID", userInfo.getTenantId());
				map.put("approvalFlag", approvalFlag);
				
				logger.debug("setFormDataDelete started.");
				ezApprovalGAdminDAO.setFormDataDelete(map);
				logger.debug("setFormDataDelete ended.");
				
				doc = commonUtil.convertStringToDocument(recevGroupXML);
				
				for (int i=0; i < doc.getElementsByTagName("DATA").getLength(); i++) {
					map.put("deptID", doc.getElementsByTagName("DEPTID").item(i).getTextContent());
					map.put("deptSN", doc.getElementsByTagName("DEPTSN").item(i).getTextContent());
					
					if (approvalFlag.equals("S")) {
						map.put("userID", doc.getElementsByTagName("USERID").item(i).getTextContent());						
					}

					logger.debug("setFormDataInsert2 started.");
					ezApprovalGAdminDAO.setFormDataInsert2(map);
					logger.debug("setFormDataInsert2 ended.");
				}
			}
		} else {
			map.put("v_PFORMID", formID);
			map.put("v_PURL", path + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + formID + ".mht");
			
			logger.debug("setFormDataUpdate started.");
			ezApprovalGAdminDAO.setFormDataUpdate(map);
			logger.debug("setFormDataUpdate ended.");
			
			if (approvalFlag.equals("S")) {
				map.put("keepPeriod", keepPeriod);
				map.put("keepPeriodCode", keepPeriodCode);
				map.put("securityLevel", securityLevel);
				map.put("isPublic", isPublic);
				map.put("tbItemCode", tbItemCode);
				map.put("tbItemName", tbItemName);
				map.put("tbItemName2", tbItemName2);
				map.put("useFlag", useFlag);
				
				logger.debug("setAutoDocNum started.");
				ezApprovalGAdminDAO.setAutoDocNum(map);
				logger.debug("setAutoDocNum ended.");
				
				if (!formAutoRule.equals("")) {
					doc = commonUtil.convertStringToDocument(formAutoRule);
					
					map = new HashMap<String, Object>();
					map.put("formID", formID);
					map.put("companyID", companyID);
					map.put("tenantID", userInfo.getTenantId());

					logger.debug("deleteAutoRule started.");
					ezApprovalGAdminDAO.deleteAutoRule(map);
					logger.debug("deleteAutoRule ended.");
					
					for (int i=0; i < doc.getElementsByTagName("ROW").getLength(); i++) {
						map.put("autoRuleSN", doc.getElementsByTagName("AUTORULESN").item(i).getTextContent());
						map.put("autoRuleGUID", doc.getElementsByTagName("AUTORULEGUID").item(i).getTextContent());
						map.put("checkFieldType", doc.getElementsByTagName("CHECKFIELDTYPE").item(i).getTextContent());
						map.put("checkField", doc.getElementsByTagName("CHECKFIELD").item(i).getTextContent());
						map.put("operatorType", doc.getElementsByTagName("OPERATORTYPE").item(i).getTextContent());
						map.put("operator", doc.getElementsByTagName("OPERATOR").item(i).getTextContent());
						map.put("condType", doc.getElementsByTagName("CONDTYPE").item(i).getTextContent());
						map.put("condValue", doc.getElementsByTagName("CONDVALUE").item(i).getTextContent());
						map.put("condValueDeptID", doc.getElementsByTagName("CONDVALUEDEPTID").item(i).getTextContent());
						map.put("docType", doc.getElementsByTagName("DOCTYPE").item(i).getTextContent());
						
						logger.debug("insertAutoRule started.");
						ezApprovalGAdminDAO.insertAutoRule(map);
						logger.debug("insertAutoRule ended.");
					}
				}
				
				if (!formAutoRuleLine.equals("")) {
					doc = commonUtil.convertStringToDocument(formAutoRuleLine);
					
					map = new HashMap<String, Object>();
					map.put("formID", formID);
					map.put("companyID", companyID);
					map.put("tenantID", userInfo.getTenantId());

					logger.debug("deleteAutoRuleLine started.");
					ezApprovalGAdminDAO.deleteAutoRuleLine(map);
					logger.debug("deleteAutoRuleLine ended.");
					
					for (int i=0; i < doc.getElementsByTagName("ROW").getLength(); i++) {
						map.put("autoRuleGUID", doc.getElementsByTagName("AUTORULEGUID").item(i).getTextContent());
						map.put("aprMemberSN", doc.getElementsByTagName("APRMEMBERSN").item(i).getTextContent());
						map.put("aprType", doc.getElementsByTagName("APRTYPE").item(i).getTextContent());
						map.put("aprState", doc.getElementsByTagName("APRSTATE").item(i).getTextContent());
						map.put("aprMemberID", doc.getElementsByTagName("APRMEMBERID").item(i).getTextContent());
						map.put("aprMemberIsDeptYN", doc.getElementsByTagName("APRMEMBERISDEPTYN").item(i).getTextContent());
						map.put("aprMemberName", doc.getElementsByTagName("APRMEMBERNAME").item(i).getTextContent());
						map.put("aprMemberName2", doc.getElementsByTagName("APRMEMBERNAME2").item(i).getTextContent());
						map.put("aprMemberJobTitle", doc.getElementsByTagName("APRMEMBERJOBTITLE").item(i).getTextContent());
						map.put("aprMemberJobTitle2", doc.getElementsByTagName("APRMEMBERJOBTITLE2").item(i).getTextContent());
						map.put("aprMemberDeptID", doc.getElementsByTagName("APRMEMBERDEPTID").item(i).getTextContent());
						map.put("aprMemberDeptName", doc.getElementsByTagName("APRMEMBERDEPTNAME").item(i).getTextContent());
						map.put("aprMemberDeptName2", doc.getElementsByTagName("APRMEMBERDEPTNAME2").item(i).getTextContent());
						map.put("aprMemberLdapPath", doc.getElementsByTagName("APRMEMBERLDAPPATH").item(i).getTextContent());
						map.put("reasonDoNotApprov", doc.getElementsByTagName("REASONDONOTAPPROV").item(i).getTextContent());
						map.put("isProposerYN", doc.getElementsByTagName("ISPROPOSERYN").item(i).getTextContent());
						map.put("isBriefUserYN", doc.getElementsByTagName("ISBRIEFUSERYN").item(i).getTextContent());
						
						logger.debug("insertAutoRuleLine started.");
						ezApprovalGAdminDAO.insertAutoRuleLine(map);
						logger.debug("insertAutoRuleLine ended.");
					}
				}
			}
			
			if (!recevGroupXML.equals("")) {
				logger.debug("recevGroupXML = " + recevGroupXML);
				map = new HashMap<String, Object>();
				map.put("v_PFORMID", formID);
				map.put("companyID", companyID);
				map.put("tenantID", userInfo.getTenantId());
				map.put("approvalFlag", approvalFlag);
				
				logger.debug("setFormDataDelete started.");
				ezApprovalGAdminDAO.setFormDataDelete(map);
				logger.debug("setFormDataDelete ended.");
				
				doc = commonUtil.convertStringToDocument(recevGroupXML);
				
				for (int i=0; i < doc.getElementsByTagName("DATA").getLength(); i++) {
					map.put("deptID", doc.getElementsByTagName("DEPTID").item(i).getTextContent());
					map.put("deptSN", doc.getElementsByTagName("DEPTSN").item(i).getTextContent());
					map.put("deptName", doc.getElementsByTagName("DEPTNAME").item(i).getTextContent());
					
					if (approvalFlag.equals("S")) {
						map.put("userID", doc.getElementsByTagName("USERID").item(i).getTextContent());						
					}
					
					logger.debug("setFormDataInsert2 started.");
					ezApprovalGAdminDAO.setFormDataInsert2(map);
					logger.debug("setFormDataInsert2 ended.");
				}
			}
		}
		
		if (!formMhtInfo.equals(""))	 {
			saveFileFolder = realPath + path + commonUtil.separator + companyID + commonUtil.separator + "form";
			saveFileName = saveFileFolder + commonUtil.separator + formID + ".mht";
			
			try {
				File fileFolder = new File(saveFileFolder);
				
				if (!fileFolder.exists()) {
					fileFolder.mkdirs();
				}
				
				File file = new File(saveFileName);
				if (file.exists()) {
					strBeforeMHT = FileUtils.readFileToString(file);
				}

				FileWriter fw = new FileWriter(file);
				fw.append(formMhtInfo);
				fw.close();
				
				// FornBuilder
				if (useReform) {
					String reformSaveFolder = saveFileFolder + commonUtil.separator + "reform" + commonUtil.separator + formID;
					String reformFilePrefix = reformSaveFolder + commonUtil.separator + formID + "_FORMBuilder";

					Path reformSaveFolderPath = Paths.get(reformSaveFolder);

					if (!Files.isDirectory(reformSaveFolderPath)) {
						Files.createDirectories(reformSaveFolderPath);
					}
					
					// HTML 쿼리 암호화
					// TODO 파싱 속도 이슈
					org.jsoup.nodes.Document document = Jsoup.parse(reformHtml);
					org.jsoup.nodes.Element dataBindListElement = document.getElementById("__reform_data_bind_list");
					
					if (dataBindListElement != null) {
						String dataBindListValue = dataBindListElement.attr("value");
						
						List<org.jsoup.nodes.Element> elements = document.getElementsByAttributeValueContaining("value", "\"sql\":");
						JSONParser jsonParser = new JSONParser();
						
						for (org.jsoup.nodes.Element element : elements) {
							if (dataBindListValue.contains('"' + element.id() + '"')) {
								Map<String, Object> valueAttrJson = uncheckedCast(jsonParser.parse(element.attr("value")));
								
								String query = valueAttrJson.get("sql").toString();
								query = egovFileScrty.encryptAES(query);
								
								valueAttrJson.put("sql", query);
								
								element.attr("value", JSONObject.toJSONString(valueAttrJson));
								jsonParser.reset();
							}
						}
						
						reformHtml = document.outerHtml();
					}

					Path reformMhtPath = Paths.get(reformFilePrefix + ".mht");
					Path reformHtmlPath = Paths.get(reformFilePrefix + ".html");
					Path reformFunctionPath = Paths.get(reformFilePrefix + ".js");

					OpenOption[] openOptions = { StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING };

					Files.write(reformMhtPath, reformMht.getBytes(), openOptions);
					Files.write(reformHtmlPath, reformHtml.getBytes(), openOptions);

					if (reformFunction == null || reformFunction.trim().isEmpty()) {
						Files.deleteIfExists(reformFunctionPath);
					} else {
						Files.write(reformFunctionPath, reformFunction.getBytes(), openOptions);
					}
				}
			} catch (Exception e) {
				return "ERROR : " + egovMessageSource.getMessage("ezApprovalG.lhj03", userInfo.getLocale()) + e.getMessage();
			}
		}
		
		logger.debug("setFormDataInsert,Update ended.");
		logger.debug("saveFormInfo ended.");
		
		return formID;
	}
	
	@SuppressWarnings("unchecked")
	private <T> T uncheckedCast(Object object) {
		return (T) object;
	}
	
	// 관리자 편집창
	public String editApprovalDoc(String docID, String companyID, String formMHT, String formHTML, String realPath, LoginVO userInfo, String filePath, String htmlData) throws Exception {
		logger.debug("editApprovalDoc started.");
		
		filePath = filePath.replace("/" + docID + ".mht", "").trim();
		logger.debug("filePath : " + filePath);
		String saveFileFolder = realPath + filePath;
		String saveFileName = saveFileFolder + commonUtil.separator + docID + ".mht";
		String strBeforeMHT = "";
		
		logger.debug("saveFileFolder : " + saveFileFolder);
		logger.debug("saveFileName : " + saveFileName);
		
//		FileOutputStream stream = null;
		
		try {
			File fileFolder = new File(saveFileFolder);
			File file = new File(saveFileName);
			
			if (!fileFolder.exists()) {
				fileFolder.mkdirs();
			}
			
			if (file.exists()) {
				strBeforeMHT = FileUtils.readFileToString(file);
			}
			
			FileWriter fw = new FileWriter(file);
			fw.append(formMHT);
			fw.close();
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_DOCID", docID);
			map.put("v_USERID", userInfo.getId());
			map.put("v_TENANTID", userInfo.getTenantId());
			map.put("v_COMPANYID", userInfo.getCompanyID());
			map.put("v_BEFOREHTML", htmlData);
			map.put("v_AFTERHTML", formHTML);
			map.put("v_MODIFYDATE", commonUtil.getTodayUTCTime(""));
			ezApprovalGAdminDAO.insertEditApproDoc(map);
		} catch (Exception e) {
			return "ERROR : " + egovMessageSource.getMessage("ezApprovalG.lhj03", userInfo.getLocale()) + e.getMessage();
		}
		
		logger.debug("editApprovalDoc ended.");
		return "";
	}
	
	@Override
	public String saveFormInfoHWP(String contID, String formID, String formInfo, String formConnInfo, String formWorkFlow, String formRecevGroup, String formMhtInfo, String formAutoRule, String formAutoRuleLine, String companyID, String realPath, LoginVO userInfo, String approvalFlag) throws Exception {
		logger.debug("saveFormInfoHWP started.");
		String strBeforeMHT = "";
		String path = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(formInfo);
		String keepPeriod = "";
		String keepPeriodCode = "";
		String securityLevel = "";
		String isPublic = "";
		String tbItemCode = "";
		String tbItemName = "";
		String tbItemName2 = "";
		String useFlag = "";
		String formConnFlag = "";
		
		String formName = doc.getElementsByTagName("FormName").item(0).getTextContent();
		String formName2 = doc.getElementsByTagName("FormName2").item(0).getTextContent();
		String formDescript = doc.getElementsByTagName("FormDescript").item(0).getTextContent();
		String formKind = doc.getElementsByTagName("FormKind").item(0).getTextContent();
		
		if (approvalFlag.equals("S")) {
			keepPeriod = doc.getElementsByTagName("KEEPPERIOD").item(0).getTextContent();
			keepPeriodCode = doc.getElementsByTagName("KEEPPERIODCODE").item(0).getTextContent();
			securityLevel = doc.getElementsByTagName("SECURITYLEVEL").item(0).getTextContent();
			isPublic = doc.getElementsByTagName("ISPUBLIC").item(0).getTextContent();
			tbItemCode = doc.getElementsByTagName("TBITEMCODE").item(0).getTextContent();
			tbItemName = doc.getElementsByTagName("TBITEMNAME").item(0).getTextContent();
			tbItemName2 = doc.getElementsByTagName("TBITEMNAME2").item(0).getTextContent();
			useFlag = doc.getElementsByTagName("USEFLAG").item(0).getTextContent();
		} else {
			formConnFlag = doc.getElementsByTagName("ConnFlag").item(0).getTextContent();
		}

		String recevGroupXML = "";
		if (formRecevGroup != null && !formRecevGroup.equals("")) {
			recevGroupXML = formRecevGroup;
		}
		
		boolean isUpdate = false;
		String saveFileFolder = "";
		String saveFileName = "";

		if (!formID.equals("") && !formMhtInfo.equals("")) {
			isUpdate = true;
			saveFileFolder = realPath + path + commonUtil.separator + companyID + commonUtil.separator + "form";
			saveFileName = saveFileFolder + commonUtil.separator + formID + ".hwp";
			
			FileOutputStream stream = null;
			
			try {
				File fileFolder = new File(saveFileFolder);
				File file = new File(saveFileName);
				
				if (!fileFolder.exists()) {
					fileFolder.mkdirs();
				}
				
				if (file.exists()) {
					strBeforeMHT = FileUtils.readFileToString(file);
				}
				
				stream = new FileOutputStream(file);
				stream.write(Base64.decodeBase64(formMhtInfo));
				stream.close();
			} catch (Exception e) {
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
			
			map.put("v_PURL", path + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + result + ".hwp");
			map.put("v_PFORMID", result);
			
			
			logger.debug("setFormDataInsert1 started.");
			ezApprovalGAdminDAO.setFormDataInsert1(map);
			logger.debug("setFormDataInsert1 ended.");
			if (approvalFlag.equals("S")) {
				map.put("keepPeriod", keepPeriod);
				map.put("keepPeriodCode", keepPeriodCode);
				map.put("securityLevel", securityLevel);
				map.put("isPublic", isPublic);
				map.put("tbItemCode", tbItemCode);
				map.put("tbItemName", tbItemName);
				map.put("tbItemName2", tbItemName2);
				map.put("useFlag", useFlag);
				
				logger.debug("setAutoDocNum started.");
				ezApprovalGAdminDAO.setAutoDocNum(map);
				logger.debug("setAutoDocNum ended.");
				
				if (!formAutoRule.equals("")) {
					doc = commonUtil.convertStringToDocument(formAutoRule);
					
					map = new HashMap<String, Object>();
					map.put("formID", formID);
					map.put("companyID", companyID);
					map.put("tenantID", userInfo.getTenantId());

					for (int i=0; i < doc.getElementsByTagName("ROW").getLength(); i++) {
						map.put("autoRuleSN", doc.getElementsByTagName("AUTORULESN").item(i).getTextContent());
						map.put("autoRuleGUID", doc.getElementsByTagName("AUTORULEGUID").item(i).getTextContent());
						map.put("checkFieldType", doc.getElementsByTagName("CHECKFIELDTYPE").item(i).getTextContent());
						map.put("checkField", doc.getElementsByTagName("CHECKFIELD").item(i).getTextContent());
						map.put("operatorType", doc.getElementsByTagName("OPERATORTYPE").item(i).getTextContent());
						map.put("operator", doc.getElementsByTagName("OPERATOR").item(i).getTextContent());
						map.put("condType", doc.getElementsByTagName("CONDTYPE").item(i).getTextContent());
						map.put("condValue", doc.getElementsByTagName("CONDVALUE").item(i).getTextContent());
						map.put("condValueDeptID", doc.getElementsByTagName("CONDVALUEDEPTID").item(i).getTextContent());
						map.put("docType", doc.getElementsByTagName("DOCTYPE").item(i).getTextContent());
						
						logger.debug("insertAutoRule started.");
						ezApprovalGAdminDAO.insertAutoRule(map);
						logger.debug("insertAutoRule ended.");
					}
				}
				
				if (!formAutoRuleLine.equals("")) {
					doc = commonUtil.convertStringToDocument(formAutoRuleLine);
					
					map = new HashMap<String, Object>();
					map.put("formID", formID);
					map.put("companyID", companyID);
					map.put("tenantID", userInfo.getTenantId());

					for (int i=0; i < doc.getElementsByTagName("ROW").getLength(); i++) {
						map.put("autoRuleGUID", doc.getElementsByTagName("AUTORULEGUID").item(i).getTextContent());
						map.put("aprMemberSN", doc.getElementsByTagName("APRMEMBERSN").item(i).getTextContent());
						map.put("aprType", doc.getElementsByTagName("APRTYPE").item(i).getTextContent());
						map.put("aprState", doc.getElementsByTagName("APRSTATE").item(i).getTextContent());
						map.put("aprMemberID", doc.getElementsByTagName("APRMEMBERID").item(i).getTextContent());
						map.put("aprMemberIsDeptYN", doc.getElementsByTagName("APRMEMBERISDEPTYN").item(i).getTextContent());
						map.put("aprMemberName", doc.getElementsByTagName("APRMEMBERNAME").item(i).getTextContent());
						map.put("aprMemberName2", doc.getElementsByTagName("APRMEMBERNAME2").item(i).getTextContent());
						map.put("aprMemberJobTitle", doc.getElementsByTagName("APRMEMBERJOBTITLE").item(i).getTextContent());
						map.put("aprMemberJobTitle2", doc.getElementsByTagName("APRMEMBERJOBTITLE2").item(i).getTextContent());
						map.put("aprMemberDeptID", doc.getElementsByTagName("APRMEMBERDEPTID").item(i).getTextContent());
						map.put("aprMemberDeptName", doc.getElementsByTagName("APRMEMBERDEPTNAME").item(i).getTextContent());
						map.put("aprMemberDeptName2", doc.getElementsByTagName("APRMEMBERDEPTNAME2").item(i).getTextContent());
						map.put("aprMemberLdapPath", doc.getElementsByTagName("APRMEMBERLDAPPATH").item(i).getTextContent());
						map.put("reasonDoNotApprov", doc.getElementsByTagName("REASONDONOTAPPROV").item(i).getTextContent());
						map.put("isProposerYN", doc.getElementsByTagName("ISPROPOSERYN").item(i).getTextContent());
						map.put("isBriefUserYN", doc.getElementsByTagName("ISBRIEFUSERYN").item(i).getTextContent());
						
						logger.debug("insertAutoRuleLine started.");
						ezApprovalGAdminDAO.insertAutoRuleLine(map);
						logger.debug("insertAutoRuleLine ended.");
					}
				}
			}
			
			if (!recevGroupXML.equals("")) {
				map = new HashMap<String, Object>();
				map.put("v_PFORMID", formID);
				map.put("companyID", companyID);
				map.put("tenantID", userInfo.getTenantId());
				map.put("approvalFlag", approvalFlag);
				
				logger.debug("setFormDataDelete started.");
				ezApprovalGAdminDAO.setFormDataDelete(map);
				logger.debug("setFormDataDelete ended.");
				
				doc = commonUtil.convertStringToDocument(recevGroupXML);
				
				for (int i=0; i < doc.getElementsByTagName("DATA").getLength(); i++) {
					map.put("deptID", doc.getElementsByTagName("DEPTID").item(i).getTextContent());
					map.put("deptSN", doc.getElementsByTagName("DEPTSN").item(i).getTextContent());
					map.put("deptName", doc.getElementsByTagName("DEPTNAME").item(i).getTextContent());
					
					if (approvalFlag.equals("S")) {
						map.put("userID", doc.getElementsByTagName("USERID").item(i).getTextContent());						
					}
					
					logger.debug("setFormDataInsert2 started.");
					ezApprovalGAdminDAO.setFormDataInsert2(map);
					logger.debug("setFormDataInsert2 ended.");
				}
			}
		} else {
			result = formID;
			map.put("v_PFORMID", formID);
			map.put("v_PURL", path + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + formID + ".hwp");
			
			logger.debug("setFormDataUpdate started.");
			ezApprovalGAdminDAO.setFormDataUpdate(map);
			logger.debug("setFormDataUpdate ended.");
			
			if (approvalFlag.equals("S")) {
				map.put("keepPeriod", keepPeriod);
				map.put("keepPeriodCode", keepPeriodCode);
				map.put("securityLevel", securityLevel);
				map.put("isPublic", isPublic);
				map.put("tbItemCode", tbItemCode);
				map.put("tbItemName", tbItemName);
				map.put("tbItemName2", tbItemName2);
				map.put("useFlag", useFlag);
				
				logger.debug("setAutoDocNum started.");
				ezApprovalGAdminDAO.setAutoDocNum(map);
				logger.debug("setAutoDocNum ended.");
				
				if (!formAutoRule.equals("")) {
					doc = commonUtil.convertStringToDocument(formAutoRule);
					
					map = new HashMap<String, Object>();
					map.put("formID", formID);
					map.put("companyID", companyID);
					map.put("tenantID", userInfo.getTenantId());

					logger.debug("deleteAutoRule started.");
					ezApprovalGAdminDAO.deleteAutoRule(map);
					logger.debug("deleteAutoRule ended.");
					
					for (int i=0; i < doc.getElementsByTagName("ROW").getLength(); i++) {
						map.put("autoRuleSN", doc.getElementsByTagName("AUTORULESN").item(i).getTextContent());
						map.put("autoRuleGUID", doc.getElementsByTagName("AUTORULEGUID").item(i).getTextContent());
						map.put("checkFieldType", doc.getElementsByTagName("CHECKFIELDTYPE").item(i).getTextContent());
						map.put("checkField", doc.getElementsByTagName("CHECKFIELD").item(i).getTextContent());
						map.put("operatorType", doc.getElementsByTagName("OPERATORTYPE").item(i).getTextContent());
						map.put("operator", doc.getElementsByTagName("OPERATOR").item(i).getTextContent());
						map.put("condType", doc.getElementsByTagName("CONDTYPE").item(i).getTextContent());
						map.put("condValue", doc.getElementsByTagName("CONDVALUE").item(i).getTextContent());
						map.put("condValueDeptID", doc.getElementsByTagName("CONDVALUEDEPTID").item(i).getTextContent());
						map.put("docType", doc.getElementsByTagName("DOCTYPE").item(i).getTextContent());
						
						logger.debug("insertAutoRule started.");
						ezApprovalGAdminDAO.insertAutoRule(map);
						logger.debug("insertAutoRule ended.");
					}
				}
				
				if (!formAutoRuleLine.equals("")) {
					doc = commonUtil.convertStringToDocument(formAutoRuleLine);
					
					map = new HashMap<String, Object>();
					map.put("formID", formID);
					map.put("companyID", companyID);
					map.put("tenantID", userInfo.getTenantId());
					logger.debug("deleteAutoRuleLine started.");
					ezApprovalGAdminDAO.deleteAutoRuleLine(map);
					logger.debug("deleteAutoRuleLine ended.");
					
					for (int i=0; i < doc.getElementsByTagName("ROW").getLength(); i++) {
						map.put("autoRuleGUID", doc.getElementsByTagName("AUTORULEGUID").item(i).getTextContent());
						map.put("aprMemberSN", doc.getElementsByTagName("APRMEMBERSN").item(i).getTextContent());
						map.put("aprType", doc.getElementsByTagName("APRTYPE").item(i).getTextContent());
						map.put("aprState", doc.getElementsByTagName("APRSTATE").item(i).getTextContent());
						map.put("aprMemberID", doc.getElementsByTagName("APRMEMBERID").item(i).getTextContent());
						map.put("aprMemberIsDeptYN", doc.getElementsByTagName("APRMEMBERISDEPTYN").item(i).getTextContent());
						map.put("aprMemberName", doc.getElementsByTagName("APRMEMBERNAME").item(i).getTextContent());
						map.put("aprMemberName2", doc.getElementsByTagName("APRMEMBERNAME2").item(i).getTextContent());
						map.put("aprMemberJobTitle", doc.getElementsByTagName("APRMEMBERJOBTITLE").item(i).getTextContent());
						map.put("aprMemberJobTitle2", doc.getElementsByTagName("APRMEMBERJOBTITLE2").item(i).getTextContent());
						map.put("aprMemberDeptID", doc.getElementsByTagName("APRMEMBERDEPTID").item(i).getTextContent());
						map.put("aprMemberDeptName", doc.getElementsByTagName("APRMEMBERDEPTNAME").item(i).getTextContent());
						map.put("aprMemberDeptName2", doc.getElementsByTagName("APRMEMBERDEPTNAME2").item(i).getTextContent());
						map.put("aprMemberLdapPath", doc.getElementsByTagName("APRMEMBERLDAPPATH").item(i).getTextContent());
						map.put("reasonDoNotApprov", doc.getElementsByTagName("REASONDONOTAPPROV").item(i).getTextContent());
						map.put("isProposerYN", doc.getElementsByTagName("ISPROPOSERYN").item(i).getTextContent());
						map.put("isBriefUserYN", doc.getElementsByTagName("ISBRIEFUSERYN").item(i).getTextContent());
						
						logger.debug("insertAutoRuleLine started.");
						ezApprovalGAdminDAO.insertAutoRuleLine(map);
						logger.debug("insertAutoRuleLine ended.");
					}
				}
			}
			
			if (!recevGroupXML.equals("")) {
				logger.debug("recevGroupXML = " + recevGroupXML);
				map = new HashMap<String, Object>();
				map.put("v_PFORMID", formID);
				map.put("companyID", companyID);
				map.put("tenantID", userInfo.getTenantId());
				map.put("approvalFlag", approvalFlag);
				
				logger.debug("setFormDataDelete started.");
				ezApprovalGAdminDAO.setFormDataDelete(map);
				logger.debug("setFormDataDelete ended.");
				
				doc = commonUtil.convertStringToDocument(recevGroupXML);
				
				for (int i=0; i < doc.getElementsByTagName("DATA").getLength(); i++) {
					map.put("deptID", doc.getElementsByTagName("DEPTID").item(i).getTextContent());
					map.put("deptSN", doc.getElementsByTagName("DEPTSN").item(i).getTextContent());
					map.put("deptName", doc.getElementsByTagName("DEPTNAME").item(i).getTextContent());
					
					if (approvalFlag.equals("S")) {
						map.put("userID", doc.getElementsByTagName("USERID").item(i).getTextContent());						
					}
					
					logger.debug("setFormDataInsert2 started.");
					ezApprovalGAdminDAO.setFormDataInsert2(map);
					logger.debug("setFormDataInsert2 ended.");
				}
			}
		}
		
		if (!isUpdate) {
			if (!formMhtInfo.equals("")) {
				saveFileName = realPath + path + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + result + ".hwp";
				
				File file = new File(saveFileName);
				
				if (file.exists()) {
					strBeforeMHT = FileUtils.readFileToString(file);
				} else {
					new File(saveFileName.substring(0, saveFileName.lastIndexOf(commonUtil.separator))).mkdirs();
				}
				
				FileOutputStream stream = null;
				
				try {
					stream = new FileOutputStream(file);
					stream.write(Base64.decodeBase64(formMhtInfo));
				} catch (FileNotFoundException fnfe) {
					logger.debug("fnfe: {}", fnfe);
				} catch (IOException ioe) {
					logger.debug("ioe: {}", ioe);
				} catch (Exception e) {
					logger.debug("e: {}", e);
				} finally {
					if (stream != null) {
						try {
							stream.close();
						} catch (Exception ignore) {
							logger.debug("IGNORED: {}", ignore.getMessage());
						}
					}
				}
			}
		}
		
		logger.debug("setFormDataInsert,Update ended.");
		logger.debug("saveFormInfoHWP ended.");
		
		return result;
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
		
		logger.debug("setContainerIDForDoc2 started.");
		ezApprovalGAdminDAO.setContainerIDForDoc2(map);
		logger.debug("setContainerIDForDoc2 ended.");
		
		return "OK";
	}

	@Override
	public String getFormProperty(Locale locale, String companyID, int tenantID) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("upperCode", "ROOT");
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);

		List<ApprGFormVO> propList = ezApprovalGAdminDAO.getFormProperty(map);
		
		resultXML.append("<GROUP>");
		
		for (ApprGFormVO vo1 : propList) {
			resultXML.append("<PROPERTY ID = \"" + vo1.getId() + "\" NAME = \"" + egovMessageSource.getMessage("ezApprovalG." + vo1.getName(), locale) + "\">");
			
			map.put("upperCode", vo1.getCode());
			
			logger.debug("vo1.getCode() = " + vo1.getCode());
			
			List<ApprGFormVO> propList2 = ezApprovalGAdminDAO.getFormProperty(map);
			
			logger.debug("listSize = " + propList2.size());
			
			for (ApprGFormVO vo2 : propList2) {
				resultXML.append("<ROW>");
				resultXML.append("<ID>" + vo2.getId() + "</ID>");
				resultXML.append("<NAME>" + egovMessageSource.getMessage("ezApprovalG." + vo2.getName(), locale) + "</NAME>");
				resultXML.append("</ROW>");
			}
			
			resultXML.append("</PROPERTY>");
		}
		
		resultXML.append("</GROUP>");
		
		return resultXML.toString();
	}

	@Override
	public String formMove(String companyID, String contID, String selContID, String formID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("contID", contID);
		map.put("selContID", selContID);
		map.put("formID", formID);
		map.put("tenantID", tenantID);
		
		logger.debug("formMove started. contID = " + contID + " || selContID = " + selContID + " || formID = " + formID);
		
		ezApprovalGAdminDAO.formMove(map);
		
		return "OK";
	}
	
	@Override
	public String moveDocList(String strMoveListIDInfo, String sourceContID, String targetContID, String chkAll, String companyID, int tenantID) throws Exception {
		logger.debug("moveDocList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("sourceContID", sourceContID);
		map.put("targetContID", targetContID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		if (chkAll.toLowerCase().equals("true")) {
			ezApprovalGAdminDAO.moveAllDocListF(map);
			ezApprovalGAdminDAO.moveAllDocListS(map);
		} else {
			String subQuery = "";
			String info[] = strMoveListIDInfo.split(";");
			for (int k = 0; k < info.length; k++) {
				subQuery += "'"+info[k]+"'";
				if(k < info.length-1) {
					subQuery += ",";
				}
			}
			
			map.put("subQuery", subQuery);
			
			ezApprovalGAdminDAO.moveDocListF(map);
			ezApprovalGAdminDAO.moveDocListS(map);
		}
		
		logger.debug("moveDocList ended");
		
		return "<PARAMETER><RESULT>TRUE</RESULT></PARAMETER>";
	}
	
	@Override
	public String deleteDocList(String xmlPara, String offset, String companyID, int tenantID) throws Exception {
		logger.debug("deleteDocList started");
		
		Document docXML = commonUtil.convertStringToDocument(xmlPara);
		
		String contID = docXML.getDocumentElement().getChildNodes().item(0).getTextContent();
		String startPeriod = docXML.getDocumentElement().getChildNodes().item(1).getTextContent();
		String storagePeriod = docXML.getDocumentElement().getChildNodes().item(2).getTextContent();
		String deleteAll = docXML.getDocumentElement().getChildNodes().item(3).getTextContent();
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("contID", contID);
		map.put("storagePeriod", storagePeriod);
		map.put("startPeriod", startPeriod);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		if (startPeriod != null && !startPeriod.equals("")) {
			map.put("startDate", commonUtil.getDateStringInUTC(commonUtil.makeDate(startPeriod, "1", "1", true), offset, true));
			map.put("endDate", commonUtil.getDateStringInUTC(commonUtil.makeDate(startPeriod, "12", "31", false), offset, true));
		}
		
		if (deleteAll.equals("true")) {
			ezApprovalGAdminDAO.deleteAllDocList(map);
		} else {
			String subQuery = "";
			
			for (int k = 4; k < docXML.getDocumentElement().getChildNodes().getLength(); k++) {
				if (k == 4) {
					subQuery += " '" + docXML.getDocumentElement().getChildNodes().item(k).getTextContent() + "' ";
				} else {
					subQuery += ", '" + docXML.getDocumentElement().getChildNodes().item(k).getTextContent() + "' ";
				}
			}
			
			map.put("subQuery", subQuery);
			
			ezApprovalGAdminDAO.deleteDocList(map);
		}
		
		logger.debug("deleteDocList ended");
		
		return "<PARAMETER><RESULT>TRUE</RESULT></PARAMETER>";
	}
	
	@Override
	public String deleteDocListjson(String[] DocDelIDArr, String[] DocDelNoArr, String[] DocDelTitleArr, String[] DocDelWriterNameArr, String[] DocDelDeptNameArr,String deleteDay, String DelUserId,String offset, String companyID, int tenantID) throws Exception {
		logger.debug("deleteDocList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("deluserid", DelUserId);
		map.put("deleteday",deleteDay);
		
		for (int i = 0; i < DocDelIDArr.length; i++) {
			
			map.put("docid", DocDelIDArr[i]);
			map.put("docno", DocDelNoArr[i]);
			map.put("doctitle", DocDelTitleArr[i]);
			map.put("writername", DocDelWriterNameArr[i]);
			map.put("deptname", DocDelDeptNameArr[i]);
			
			ezApprovalGAdminDAO.insertDelDoc(map);
			ezApprovalGAdminDAO.deleteDocListjson(map);
		}
		
		logger.debug("deleteDocList ended");
		
		return "<PARAMETER><RESULT>TRUE</RESULT></PARAMETER>";
	}
	
	@Override
	public String getSecurityType(String selected, LoginVO userInfo, String companyID, String approvalFlag) throws Exception {
		logger.debug("getSecurityType started");
		
		StringBuilder result = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (approvalFlag.equals("S")) {
			map.put("code1", "SA51");
		} else {
			map.put("code1", "A51");
		}
		
		map.put("primary", userInfo.getPrimary());
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyID());
		map.put("lang", userInfo.getLang());
		
		List<ApprGLeftVO> list = ezApprovalGAdminDAO.getCodeType(map);
		
		for (int k = 0; k < list.size(); k++) {
			String[] colOption = list.get(k).getName().split(";");
			
			if (colOption[1].equals(selected)) {
				result.append("<OPTION value=" + colOption[2] + " selected>" + colOption[1] + "</OPTION>");
			} else {
				result.append("<OPTION value=" + colOption[2] + ">" + colOption[1] + "</OPTION>");
			}
		}
		
		logger.debug("getSecurityType ended");
		
		return result.toString();
	}
	
	@Override
	public String getKeepType(String selected, LoginVO userInfo, String companyID, String approvalFlag) throws Exception {
		logger.debug("getKeepType started");
		
		StringBuilder result = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (approvalFlag.equals("S")) {
			map.put("code1", "SA52");
		} else {
			map.put("code1", "A52");
		}
		
		map.put("primary", userInfo.getPrimary());
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyID());
		map.put("lang", userInfo.getLang());
		
		List<ApprGLeftVO> list = ezApprovalGAdminDAO.getCodeType(map);
		
		for (int k = 0; k < list.size(); k++) {
			String[] colOption = list.get(k).getName().split(";");
			
			if (colOption[1].equals(selected)) {
				result.append("<OPTION value=" + colOption[2] + " selected>" + colOption[1] + "</OPTION>");
			} else {
				result.append("<OPTION value=" + colOption[2] + ">" + colOption[1] + "</OPTION>");
			}
		}
		
		logger.debug("getKeepType ended");
		
		return result.toString();
	}
	
	@Override
	public String getEtcName(String code1, String selected, String primary, String lang, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code1", code1);
		map.put("primary", primary);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("lang", lang);
		
		logger.debug("getEtcName started. code1=" + code1 + " primary=" + primary + " lang=" + lang + "companyID=" + companyID + "tenantID=" + tenantID);
		
		List<ApprGLeftVO> list = ezApprovalGAdminDAO.getCodeType(map);
		
		String result = "";
		
		for (int k = 0; k < list.size(); k++) {
			String[] colOption = list.get(k).getName().split(";");
			
			if (colOption[2].equals(selected)) {
				result = colOption[1];
			}
		}
		
		logger.debug("getEtcName ended.");
		
		return result;
	}

	@Override
	public String getFormAprRule(String formID, String companyID, int tenantID) throws Exception {
		logger.debug("getFormAprRule started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("formID", formID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprGAutoRuleVO> apprAutoRuleVOs = ezApprovalGAdminDAO.getFormAprRule(map);

		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprAutoRuleVOs.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprAutoRuleVOs.get(i)));
		}
		sb.append("</DATA>");
		
		logger.debug("getFormAprRule ended");
		
		return sb.toString();
	}

	@Override
	public String getFormAprRuleLine(String formID, String companyID, int tenantID) throws Exception {
		logger.debug("getFormAprRuleLine started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("formID", formID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprGAutoRuleVO> apprAutoRuleVOs = ezApprovalGAdminDAO.getFormAprRuleLine(map);

		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprAutoRuleVOs.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprAutoRuleVOs.get(i)));
		}
		sb.append("</DATA>");

		logger.debug("getFormAprRuleLine ended");
		
		return sb.toString();
	}

	@Override
	public String getSpecialContList(String deptID, String companyID, String lang, int tenantID, String approvalFlag) throws Exception {
		logger.debug("getSpecialContList started");
		
		String multiData = commonUtil.getMultiData(lang, tenantID);
		Map<String, Object> map = new HashMap<String, Object>();
		StringBuilder sb= new StringBuilder();
		
		map.put("v_LISTTYPE", "S109");
		map.put("v_LANGTYPE", lang);
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
		sb.append("</HEADERS>");
		
		map = new HashMap<String, Object>();
		
		map.put("deptID", deptID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprGContInfoVO> list = ezApprovalGAdminDAO.getSpecialContList(map);
		
		sb.append("<ROWS>");
		
		for (ApprGContInfoVO vo : list) {
			sb.append("<ROW>");
			sb.append("<CELL>");
			sb.append("<VALUE>");
			
			String contType = vo.getContType();
			
			if (Integer.parseInt(contType) >= 100) {
				map.put("lang", multiData);
				map.put("contType", contType);
				
				String contTypeName = ezApprovalGAdminDAO.getSpecialContInfoContTypeName(map);
				
				sb.append(contTypeName);
			} else {
				sb.append(ezApprovalGService.getCode2Name("SA60", contType, companyID, lang, tenantID));
			}
			sb.append("</VALUE>");
			sb.append("<DATA1>" + vo.getDeptID() + "</DATA1>");
			sb.append("<DATA2>" + contType + "</DATA2>");
			sb.append("<DATA3>" + vo.getSn() + "</DATA3>");
			sb.append("</CELL>");
			sb.append("<CELL>");
			sb.append("<VALUE>" + vo.getContName() + "</VALUE>");
			sb.append("</CELL>");
			sb.append("<CELL>");
			sb.append("<VALUE>" + vo.getSubQuery() + "</VALUE>");
			sb.append("</CELL>");
			sb.append("</ROW>");
		}
		
		sb.append("</ROWS>");
		sb.append("</LISTVIEWDATA>");
		
		logger.debug("getSpecialContList ended");
		
		return sb.toString();
	}

	@Override
	public String getSpecialContCode(String contType, String companyID, String primary, int tenantID) throws Exception {
		logger.debug("getSpecialContCode started.");
		
		StringBuilder sb = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("code1", "SA60");
		map.put("companyID", companyID);
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		
		List<ApprGLeftVO> list = ezApprovalGAdminDAO.getCodeType(map);
		
		for (ApprGLeftVO vo : list) {
			String code = vo.getCode2();
			
			if (code.equals(contType)) {
				sb.append("<OPTION value=" + code + " selected>" + vo.getName() + "</OPTION>");
			} else {
				sb.append("<OPTION value=" + code + ">" + vo.getName() + "</OPTION>");
			}
		}
		
		map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprGContInfoVO> apprContInfoList = ezApprovalGAdminDAO.getContTypeInfo(map);
		
		for (ApprGContInfoVO vo : apprContInfoList) {
			String typeID = vo.getContainerTypeID();
			
			if (typeID.equals(contType)) {
				sb.append("<OPTION value =" + typeID + " selected>" + vo.getContainerTypeName() + "</OPTION>");
			} else {
				sb.append("<OPTION value =" + typeID + ">" + vo.getContainerTypeName() + "</OPTION>");
			}
		}
		
		logger.debug("getSpecialContCode ended");
		
		return sb.toString();
	}
	
	@Override
	public String getSpecialContInfo(String deptID, String contType, String sn, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("getSpecialContInfo started.");
		
		StringBuilder sb = new StringBuilder();;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptID", deptID);
		map.put("contType", contType);
		map.put("sn", sn);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		logger.debug("deptID = " + deptID);
		logger.debug("contType = " + contType);
		logger.debug("sn = " + sn);
		logger.debug("companyID = " + companyID);
		logger.debug("tenantID = " + tenantID);
		
		ApprGContInfoVO vo = ezApprovalGAdminDAO.getSpecialContInfo(map);
		
		sb.append("<CONTINFO>");
		sb.append("<DEPTID>" + vo.getDeptID() + "</DEPTID>");
		sb.append("<CONTTYPE>" + vo.getContType() + "</CONTTYPE>");
		sb.append("<SN>" + vo.getSn() + "</SN>");
		sb.append("<CONTNAME>" + vo.getContName() + "</CONTNAME>");
		
		String subQuery = vo.getSubQuery();
		
		if (subQuery != null && subQuery.indexOf("NOT") > 0) {
			sb.append("<CONTYN>N</CONTYN>");
		} else {
			sb.append("<CONTYN>Y</CONTYN>");
		}
		
		sb.append("<FORMIDS>");
		
		if (subQuery != null && subQuery.length() > 0) {
			map = new HashMap<String, Object>();
			
			map.put("lang", commonUtil.getMultiData(lang, tenantID));
			map.put("subQuery", subQuery);
			map.put("companyID", companyID);
			map.put("tenantID", tenantID);
			
			logger.debug("subQuerty = " + subQuery);
			List<String> list = ezApprovalGAdminDAO.getSpecialContInfoFormName(map);
			
			for (String formIDName : list) {
				sb.append("<FORMID>" + formIDName + "</FORMID>");
			}
		}
		
		sb.append("</FORMIDS>");
		sb.append("</CONTINFO>");
		
		logger.debug("getSpecialContInfo ended.");

		return sb.toString();
	}

	@Override
	public String addSpecialCont(ApprGContInfoVO vo, int tenantID) throws Exception {
		logger.debug("addSpecialCont started");

		String rtnValue = "";
		
		vo.setTenantID(tenantID);
		
		if (vo.getSn() == null || vo.getSn().equals("") || vo.getSn().equals("0")) {
			vo.setSn("new");
		} else {
			ezApprovalGAdminDAO.deleteSpecialContInfo(vo);
		}
		
		String subQuery = "";
		
		if (vo.getFormIDs() != null && !vo.getFormIDs().equals("")) {
			if (vo.getContYN().equals("Y")) {
				subQuery = " formID IN (" + vo.getFormIDs() + ")"; 
			} else {
				subQuery = " formID NOT IN (" + vo.getFormIDs() + ")"; 
			}
		}
		
		vo.setSubQuery(subQuery);
		
		ezApprovalGAdminDAO.insertSpecialContInfo(vo);
		
		rtnValue = "TRUE";
		
		logger.debug("addSpecialCont ended");
		
		return rtnValue;
	}

	@Override
	public String delSpecialCont(ApprGContInfoVO vo, int tenantID) throws Exception {
		logger.debug("delSpecialCont started");
		
		vo.setTenantID(tenantID);
		
		ezApprovalGAdminDAO.deleteSpecialContInfo(vo);
		
		logger.debug("delSpecialCont ended");
		
		return "TRUE";
	}

	@Override
	public String changeSpecialContSN(String deptID, String sContType, String sSn, String tContType, String tSn, String companyID, int tenantID) throws Exception {
		logger.debug("changeSpecialContSN started");
		
		ApprGContInfoVO vo = new ApprGContInfoVO();
			
		vo.setDeptID(deptID);
		vo.setContType(sContType);
		vo.setContType2(tContType);
		vo.setSn(sSn);
		vo.setSn2(tSn);
		vo.setCompanyID(companyID);
		vo.setTenantID(tenantID);
			
		ezApprovalGAdminDAO.changeSpecialContSN1(vo);
		ezApprovalGAdminDAO.changeSpecialContSN2(vo);
		ezApprovalGAdminDAO.changeSpecialContSN3(vo);
		
		logger.debug("changeSpecialContSN ended");
		
		return "TRUE";
	}

	@Override
	public List<ApprGFormConnInfoVO> getFormConnInfo() throws Exception {
		logger.debug("getFormConnInfo started.");
		
		List<ApprGFormConnInfoVO> list = ezApprovalGAdminDAO.getFormConnInfo();
		
		logger.debug("getFormConnInfo ended.");
		
		return list;
	}

	@Override
	public String formConnSave(String formID, String formText, String path, String companyID) throws Exception {
		logger.debug("formConnSave started.");
		logger.debug("formID = " + formID + " || formText = " + formText + " || path = " + path + " || companyID = " + companyID);
		
		String saveFileFolder = path + commonUtil.separator + companyID + commonUtil.separator + "form";
		String saveFileName = saveFileFolder + commonUtil.separator + formID + ".xml"; 
		
		String result = "";
		
		FileWriter fileWriter = null;
		
		try {
			File fileFolder = new File(saveFileFolder);
			File file = new File(saveFileName);
			
			if (!fileFolder.exists()) {
				fileFolder.mkdirs();
			}
			
			fileWriter = new FileWriter(file);
			fileWriter.append(formText);
		} catch (FileNotFoundException fnfe) {
			logger.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			logger.debug("ioe: {}", ioe);
		} catch (Exception e) {
			logger.debug("e: {}", e);
		} finally {
			if (fileWriter != null) {
				try {
					fileWriter.close();
					result = formText;
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
					result = "ERROR";
				}
			}
		}
		
		if (result != null && result.indexOf("<?xml version=\"1.0\" encoding=\"euc-kr\"?>\n") != -1) {
			result = result.replaceAll("\\<\\?xml version=\"1.0\" encoding=\"euc-kr\"\\?\\>", "").replaceAll("\\<CONNROOT\\>", "").replaceAll("\\</CONNROOT\\>", "").replaceAll("\\n", "").replaceAll("\\t", "");
		}
		
		logger.debug("formConnSave ended. result = " + result);
		
		return result;
	}
	
	public String getParentContName(String formID, String companyID, int tenantID, String langType) throws Exception {
		logger.debug("getParentContName started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);
		map.put("v_PARENTID", formID);
		map.put("v_LANG", langType);
		
		String result = ezApprovalGAdminDAO.getParentContName(map);
		
		logger.debug("getParentContName ended.");
		
		return result;
	};
	
	@Override
	public String getIsUse(String code1, String code2, String companyID, String userLang, int tenantID) throws Exception{
		logger.debug("getIsUse started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE1", code1);
		map.put("v_CODE2", code2);
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);
		
		logger.debug("getIsUse param : v_CODE1=" + code1 + " v_CODE2=" + code2 + " v_TENANTID=" + tenantID);

		return ezApprovalGDAO.getIsUse(map);
	}
	
	@Override
	public List<ApprGDocListVO> getContDocList_json(String containerID, String userID, String userSecurityCode, boolean publicFlag, String subQuery, int startRow, int pageSize, String pageNum, 
			String orderCell, String orderOption, int totalcnt, String companyID, String lang, int tenantID, String offset, Locale locale) throws Exception {
//		StringBuilder resultXML = new StringBuilder();
				
		int querySize = pageSize * Integer.parseInt(pageNum);
//		int querySize2 = totalcnt - pageSize * (Integer.parseInt(pageNum) - 1);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CONTID", containerID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_USERSECCODE", userSecurityCode);
		
		if (publicFlag) {
			map.put("v_PUBFLAG", "Y");
		} else {
			map.put("v_PUBFLAG", "N");
		}
		map.put("v_SUBQUERY", subQuery);
		map.put("v_PAGESIZE", querySize);
		map.put("v_PAGESIZE2", pageSize);
		map.put("v_PAGESIZE3", startRow);
		map.put("v_OFFSET",offset);
		map.put("v_PSTRLANG", lang);
		
		map.put("v_H", messageSource.getMessage("ezApprovalG.t1434", locale));
		map.put("v_I", messageSource.getMessage("ezApprovalG.t1422", locale));
		map.put("v_N", messageSource.getMessage("ezApprovalG.t1687", locale));
		map.put("v_Y", messageSource.getMessage("ezApproval.t854", locale));
		
		List<ApprGDocListVO> list = ezApprovalGAdminDAO.getContDocListjson(map);
		
		return list;
	}
	
	@Override
	public int getContDocListCountjson(String containerID, String userID, String userSecurityCode, boolean publicFlag, String subQuery, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CONTID", containerID);
		map.put("companyID", companyID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_USERSECCODE", userSecurityCode);
		
		if (publicFlag) {
			map.put("v_PUBFLAG", "Y");
		} else {
			map.put("v_PUBFLAG", "N"); 
		}
		
		map.put("v_SUBQUERY", subQuery);
		
		int totalCount = ezApprovalGAdminDAO.getContDocListCountjson(map);
		
		return totalCount;
	}
	
	@Override
	public int getDeleteDocListCountjson(String userID, String userSecurityCode, boolean publicFlag, String subQuery, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_USERSECCODE", userSecurityCode);
		
		if (publicFlag) {
			map.put("v_PUBFLAG", "Y");
		} else {
			map.put("v_PUBFLAG", "N"); 
		}
		
		map.put("v_SUBQUERY", subQuery);
		
		int totalCount = ezApprovalGAdminDAO.getDeleteDocListCountjson(map);
		
		return totalCount;
	}
	
	@Override
	public List<ApprGDocListVO> getDeleteDocList_json(String userID, String subQuery, int startRow, int pageSize, String pageNum, int totalcnt, String companyID, int tenantID, String offset, String lang, Locale locale) throws Exception{
		int querySize = pageSize * Integer.parseInt(pageNum);
//		int querySize2 = totalcnt - pageSize * (Integer.parseInt(pageNum) - 1);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_SUBQUERY", subQuery);
		map.put("v_PAGESIZE", querySize);
		map.put("v_PAGESIZE2", pageSize);
		map.put("v_PAGESIZE3", startRow);
		map.put("v_OFFSET",offset);
		map.put("v_PSTRLANG", lang);
		
		map.put("v_H", messageSource.getMessage("ezApprovalG.t1434", locale));
		map.put("v_I", messageSource.getMessage("ezApprovalG.t1422", locale));
		map.put("v_N", messageSource.getMessage("ezApprovalG.t1687", locale));
		map.put("v_Y", messageSource.getMessage("ezApproval.t854", locale));	
		
		List<ApprGDocListVO> list = ezApprovalGAdminDAO.getDeleteDocListjson(map);
		
		return list;
	}


	@Override
	public String getExAttribute(String buJaeId, int tenantID) throws Exception {
		logger.debug("getExAttribute");
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERID", buJaeId);
		map.put("v_TENANTID", tenantID);
		
		String auth = ezApprovalGDAO.getExtAttr1(map);
		
		return auth;
	}
}
