package egovframework.ezEKP.ezApprovalG.service.impl;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGAdminDAO;
import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGDAO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGAdminService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAdminReceiveVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAprLineVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAttachInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAutoRuleVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGContInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocStateVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormConnInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGListHeaderVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGOpenGovModifyHistoryVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGReceiveDocVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGSealInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskCodeHistoryVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskDeptInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;
import egovframework.ezEKP.ezApprovalG.vo.KEDAuthorUserInfo;
import egovframework.ezEKP.ezApprovalG.vo.KEDSharedUserInfo;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.tomcat.util.codec.binary.Base64;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.jsoup.Jsoup;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.*;
import java.lang.reflect.Field;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Stream;

@Service("EzApprovalGAdminService")
public class EzApprovalGAdminServiceImpl extends EzFileMngUtil implements EzApprovalGAdminService{
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private ServletContext servletContext;
	
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
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
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
		
		int duplicated = ezApprovalGAdminDAO.checkContainer(map);
		if (duplicated > 0) {
			logger.debug("insertContainer duplicated.");
			return "DUPLICATE";
			
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
		String pModFlag = xmlData.getDocumentElement().getChildNodes().item(3).getTextContent().trim();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("contID", pContID);		
		map.put("contType", pContType);		
		map.put("deptID", pOwnDeptID);		
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			if (pModFlag != null && pModFlag.equals("Y")) {
				int duplicated = ezApprovalGAdminDAO.checkContainer(map);
				if (duplicated > 0) {
					logger.debug("updateContainer duplicated.");
					return "DUPLICATE";
				}
			}
		
			logger.debug("updateContainer started.");
			ezApprovalGAdminDAO.updateContainer(map);
			logger.debug("updateContainer ended.");
			
			logger.debug("deleteContainerUseDep started.");
			ezApprovalGAdminDAO.deleteContainerUseDep(map);
			logger.debug("deleteContainerUseDep ended.");
			
			int cnt = xmlData.getDocumentElement().getChildNodes().getLength();		
			
			for (int i = 4; i < cnt - 1; i++) {
				map.put("deptID", xmlData.getDocumentElement().getChildNodes().item(i).getTextContent().trim());
				
				logger.debug("insertContainerUseDep started.");
				ezApprovalGAdminDAO.insertContainerUseDep(map);
				logger.debug("insertContainerUseDep ended.");
			}
			
			return "TRUE";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return "FALSE";
		}
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
						sb.append("<DATA7>" + bodyVo.getExtReceptYn() + "</DATA7>");
					}
				}
				
				sb.append("</CELL></ROW>");
			}
		}
		
		sb.append("</ROWS></LISTVIEWDATA>");
		
		return sb.toString();
	}

	@Override
	public String insertReceiveGroupItemInfo(String groupID, String deptID,	String deptName, String deptName2, String pCompanyID, String companyID, int tenantID, String extReceptYn) throws Exception {
		logger.debug("insertReceiveGroupItemInfo started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MAINID", groupID);
		map.put("v_DEPTID", deptID);
		map.put("v_DEPTNAME", deptName);
		map.put("v_DEPTNAME2", deptName2);
		map.put("v_COMPANYID", pCompanyID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("v_EXTRECEPTYN", extReceptYn);
		
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
	public String getTaskCategoryTree(String categoryType, String parentID, String companyID, int tenantID, String approvalFlag, LoginVO userInfo) throws Exception {
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
					isLeaf = getTaskCategoryNodeCnt(vo.getCategoryType(), vo.getCategoryCode(), companyID, tenantID, approvalFlag);
					break;
				case "2":
					isLeaf = getTaskCategoryNodeCnt(vo.getCategoryType(), vo.getMcategoryCode(), companyID, tenantID, approvalFlag);
					break;
				case "3":
//						isLeaf = getTaskCategoryNodeExist(vo.getCategoryType(), vo.getSubCategoryCode(), companyID, tenantID, approvalFlag);
					isLeaf = "FALSE";
					break;
			}
			
			isLeaf = isLeaf.equals("TRUE") ? "FALSE" : "TRUE";

			sb.append("<NODE><EXPANDED>FALSE</EXPANDED>");
			sb.append("<ISLEAF>" + isLeaf + "</ISLEAF>");
			//2023-07-31 이주원 -  pollTitle 다국어_en 적용하기 위해 추가
			String lang = commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId());
			if ("1".equals(lang)) {
				sb.append("<VALUE>" + commonUtil.cleanValue(vo.getName()) + "</VALUE>");
			} else {
				sb.append("<VALUE>" + commonUtil.cleanValue(vo.getName2()) + "</VALUE>");
			}

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
				// 코드가 존재하지 않는 체계도 체계수정가능하도록 함.
				// if (getTaskCategoryNodeExist("3", categoryCode, companyID, tenantID, approvalFlag).equals("TRUE")) {
					for (int i = 3; i >= Integer.parseInt(categoryType); i--) {
						map.put("v_CATETYPE", i);
						
						ezApprovalGAdminDAO.setTaskCategoryUpdate(map);
					}
				// }
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
		
		int count = ezApprovalGAdminDAO.getTaskCategoryNodeExist(map); // 분류코드 및 하위노드가 존재하는지 조회
		
		if (count > 0) {
			result = "TRUE";
		}
		
		logger.debug("getTaskCategoryNodeExist ended. result=" + result);
		
		return result;
	}

	@Override
	public String getTaskCategoryNodeCnt(String categoryType, String categoryCode, String companyID, int tenantID, String approvalFlag) throws Exception {
		logger.debug("getTaskCategoryNodeCnt started.");
		logger.debug("categoryType=" + categoryType);
		logger.debug("categoryCode=" + categoryCode);

		String result = "FALSE";

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CATETYPE", categoryType);
		map.put("v_CATECODE", categoryCode);
		map.put("approvalFlag", approvalFlag);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);

		int count = ezApprovalGAdminDAO.getTaskCategoryNodeCnt(map); // 하위 노드가 존재하는지 조회

		if (count > 0) {
			result = "TRUE";
		}

		logger.debug("getTaskCategoryNodeCnt ended. result=" + result);

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
            map1.put("lang", (userInfo.getLang().equals("1")) ? "" : userInfo.getLang());
            if (approvalFlag.equals("S")) {
    			map1.put("code1", "SA52");
    		} else {
    			map1.put("code1", "A52");
    		}
            
            ezApprovalGAdminDAO.updateTaskCode(map1);
            ezApprovalGAdminDAO.updateAutodoc(map1);
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
			ezApprovalGAdminDAO.removeAutoDoc(map1);
			
			if (approvalFlag.equals("S")) {
				ezApprovalGAdminDAO.removeMyTaskCode(map1);
				logger.debug("removeMyTaskCode success.");
			}
			
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
	public String getTaskFullList(String deptCode, String pageSize, String pageNo, String langType, String companyID, int tenantID, String title, String code, String flag, String orderOption1, String orderOption2) throws Exception {
		logger.debug("getTaskFullList started.");
		StringBuilder sb = new StringBuilder();
		
		int startRow = (Integer.parseInt(pageNo) - 1) * Integer.parseInt(pageSize);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DEPTCODE", deptCode);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("pageSize", Integer.parseInt(pageSize));
		map.put("startRow", startRow);
		map.put("startRowForOracle", startRow + 1);
		map.put("endRowForOracle", startRow + Integer.parseInt(pageSize));

		if (!title.isEmpty()) {
			map.put("title", title);
		}
		if (!code.isEmpty()) {
			map.put("code", code);
		}
		if (!orderOption1.isEmpty()) {
			map.put("v_ORDEROPTION1", orderOption1);
			if ("DESC".equals(orderOption2.toUpperCase())) {
				map.put("v_ORDEROPTION2", "DESC");
			}
		}

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
			File file = new File(commonUtil.detectPathTraversal(realPath + vo.getSealPath()));
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
			
			File file = new File(commonUtil.detectPathTraversal(realPath + vo.getSealPath()));
			
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
		
		String[] aprTypeList = aprType.split(", ");
		
		Calendar cal = Calendar.getInstance();
		
		cal.set(Calendar.YEAR, Integer.parseInt(eYear));
		cal.set(Calendar.MONTH, Integer.parseInt(eMonth)-1);
		
		String eDate = Integer.toString(cal.getActualMaximum(Calendar.DATE));
		
		String szFrom = commonUtil.getDateStringInUTC(sYear + "-" + sMonth + "-01 00:00:00", offset, true);
		String szTo = commonUtil.getDateStringInUTC(eYear + "-" + eMonth + "-" + eDate + " 23:59:59", offset, true);
		
		/* 2018-09-07 홍승비 - 결재방법 다국어 데이터(v_LANG) 수정 */
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_APRTYPE", aprTypeList);
		map1.put("v_FROM", szFrom);
		map1.put("v_TO", szTo);
		map1.put("v_STRLANG", commonUtil.getMultiData(lang, tenantID)); // "" (원어) 또는 "2" (다국어)
		map1.put("v_LANG", commonUtil.getLangData(lang)); // "" (원어) 또는 "2 ~ 4" (다국어)
		map1.put("userFlag", userFlag);
		map1.put("companyID", companyID);
		map1.put("tenantID", tenantID);
		map1.put("approvalFlag", approvalFlag);
		//map1.put("v_CODELANG", lang == "1" ? "" : lang); // 2023-05-23 이사라 : 시큐어코딩 문자열 비교 오류 수정 - 쿼리에서 사용하지 않음으로 주석처리
		
		logger.debug("getUserDocCount map = " + map1.toString());
		
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
			String apprToMonth, String apprToDay, String formID, String formName,
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
		
		sb.append("</HEADERS>");
		
		/* 2024-06-04 홍승비 - searchManageAprDocList 쿼리에 전달하기 위한 map을 하나로 통일 */
		Map<String, Object> map1 = new HashMap<String, Object>();
		
		if (!subQuery.equals("")) {
			if (subQuery.indexOf("keyword") != -1) {
				String keyword = subQuery.substring(16, subQuery.length() - 3);
				map1.put("v_KEYWORD", keyword);
			}
		}
		
		map1.put("v_SUBQUERY", subQuery);
		map1.put("v_DOCNUMBER", docNumber);
		map1.put("v_DOCTITLE", docTitle);
		map1.put("v_DRAFTER", drafter);
		map1.put("v_DRAFTER2", drafter2);
		map1.put("v_DEPTNAME", draftDeptName);
		map1.put("v_DEPTNAME2", draftDeptName2);
		map1.put("v_FORMID", formID);
		map1.put("v_FORMNAME", formName); // 2021-01-13 박기범: 양식명 추가
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
		
		map1.put("v_PAGESIZE", querySize);
		map1.put("v_PAGESIZE2", querySize2);
		map1.put("v_ORDEROPTION", orderOption1);
		map1.put("v_ORDEROPTION2", orderOption2);
		
		logger.debug("searchManageAprDocList started, map = " + map1.toString());
		
		List<ApprGDocListVO> listBody = ezApprovalGAdminDAO.searchManageAprDocList(map1);
		
		StringBuffer docList = new StringBuffer();
		docList.append("<DATA>");
		
		for (int i = 0; i < listBody.size(); i++) {
			docList.append(commonUtil.getQueryResult(listBody.get(i)));
		}
		
		docList.append("</DATA>");
		
		Document docXml = commonUtil.convertStringToDocument(docList.toString());
		
		String fieldName = "";
		String fieldValue = "";
		
		sb.append("<ROWS>");
		
		for (int j = 0; j < docXml.getElementsByTagName("ROW").getLength(); j++) {
			
			sb.append("<ROW>");
			
			for (int k = 0; k < listHeader.size(); k++) {
				
				fieldName = listHeader.get(k).getColName().toUpperCase();
				
				if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERDEPTNAME") || fieldName.equals("FORMNAME")) {
					fieldName = fieldName + multiData;
				}
				
				fieldValue = docXml.getElementsByTagName(fieldName).item(j).getTextContent();
				
				sb.append("<CELL>");
				sb.append("<VALUE>" + commonUtil.cleanValue(ezApprovalGService.getListField(fieldName, fieldValue, companyID, lang, tenantID, offset)) + "</VALUE>");
				
				if (k == 0) {
					sb.append("<DATA1>" + docXml.getElementsByTagName("DOCID").item(j).getTextContent() + "</DATA1>");
					sb.append("<DATA2>" + docXml.getElementsByTagName("ORGDOCID").item(j).getTextContent() + "</DATA2>");
					sb.append("<DATA3>" + docXml.getElementsByTagName("HREF").item(j).getTextContent() + "</DATA3>");
					sb.append("<DATA4></DATA4>");
					sb.append("<DATA5></DATA5>");
					sb.append("<DATA6></DATA6>");
					sb.append("<DATA7></DATA7>");
					sb.append("<DATA8></DATA8>");
					sb.append("<DATA9>0</DATA9>");
					sb.append("<DATA10>" + docXml.getElementsByTagName("FUNCTIONTYPE").item(j).getTextContent() + "</DATA10>");
					sb.append("<DATA11>" + docXml.getElementsByTagName("HASOPINIONYN").item(j).getTextContent() + "</DATA11>");
					sb.append("<DATA12>" + docXml.getElementsByTagName("DOCSTATE").item(j).getTextContent() + "</DATA12>");
					sb.append("<DATA13>" + docXml.getElementsByTagName("WRITERDEPTID").item(j).getTextContent() + "</DATA13>");
					sb.append("<DATA14>" + docXml.getElementsByTagName("URGENTAPPROVAL").item(j).getTextContent() + "</DATA14>");
					sb.append("<HASOPINIONYN>" + docXml.getElementsByTagName("HASOPINIONYN").item(j).getTextContent() + "</HASOPINIONYN>");
				}
				
				if (fieldName.equals("HASATTACHYN")) {
					sb.append("<HASATTACHYN>" + docXml.getElementsByTagName("HASATTACHYN").item(j).getTextContent() + "</HASATTACHYN>");
				}
				
				if (fieldName.equals("ISPUBLIC")) {
					sb.append("<ISPUBLIC>" + docXml.getElementsByTagName("ISPUBLIC").item(j).getTextContent() + "</ISPUBLIC>");
				}
				sb.append("</CELL>");
			}
			sb.append("</ROW>");
		}
		sb.append("</ROWS>");
		sb.append("</LISTVIEWDATA><TOTALCNT>" + totalCount + "</TOTALCNT></DOCLIST>");
		
		logger.debug("searchManageAprDocList ended.");
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
			sb.append("<NAME" + list.indexOf(vo) + "><![CDATA[");
			
			if (!lang.equals("2")) {
				sb.append(ezOrganService.getPropertyValue(vo.getFormContUserDepID(), "displayname", tenantID));
			} else {
				sb.append(ezOrganService.getPropertyValue(vo.getFormContUserDepID(), "displayname2", tenantID));
			}
			
			sb.append("]]></NAME" + list.indexOf(vo) + ">");
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
				
			if (StringUtils.isNotBlank(deptList)) { // 2023-05-23 이사라 : 시큐어코딩 문자열 비교 오류 수정
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
	public String delForm(String formID, String companyID, String realPath, int tenantID, String officeFlag) throws Exception {
		logger.debug("delForm started.");		
		String result = deleteForm(formID, companyID, tenantID,officeFlag);
		
		if (result.equals("TRUE")) {
			String filePath = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID) + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + formID;
			File formFile = new File(commonUtil.detectPathTraversal(filePath + ".mht"));
			
			if(formFile.exists()) {
				deleteFile(filePath + ".mht");
			} else {
				deleteFile(filePath + ".hwp");
			}
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
						sb.append("<VALUE>" + commonUtil.cleanValue(bodyVo.getDeptName()) + "</VALUE>");
						sb.append("<DATA1>" + bodyVo.getDeptID() + "</DATA1>");
						sb.append("<DATA2>" + bodyVo.getUserID() + "</DATA2>");
					} else {
						sb.append("<VALUE>" + commonUtil.cleanValue(ezOrganService.getPropertyValue(bodyVo.getUserID(), "displayName" + multiData, tenantID)) + "</VALUE>");
					}
				} else {
					sb.append("<VALUE>" + commonUtil.cleanValue(bodyVo.getDeptName()) + "</VALUE>");
					
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
	
	private String deleteForm(String formID, String companyID, int tenantID, String officeFlag) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", formID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
				
		logger.debug("deleteForm started.");
		if(officeFlag != null && officeFlag.equalsIgnoreCase("Y")) {
			logger.debug("officeForm Delete started");
			ezApprovalGAdminDAO.deleteForm3(map);
			logger.debug("officeForm Delete ended");
		}
		ezApprovalGAdminDAO.deleteForm1(map);
		ezApprovalGAdminDAO.deleteForm2(map);
		logger.debug("deleteForm ended.");
		
		return "TRUE";
	}
	
	//TODO 2017-01-05 이효진 연동정보 및 workflow 등록 및 수정 부분 미구현(EZSP_SETFORMDATA)
	@Override
	public String saveFormInfo(String contID, String formID, String formInfo, String formConnInfo, String formWorkFlow, String formRecevGroup, String formMhtInfo, String formAutoRule, String formAutoRuleLine, String companyID, String realPath, LoginVO userInfo, String approvalFlag, String reformMht, String reformHtml, String reformFunction) throws Exception {
		logger.debug("saveFormInfo started.");
		@SuppressWarnings("unused")
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
		String openGovFlag = "";
		String formAprOption = "";
		String passAprLineFlag = "";
		
		String formName = doc.getElementsByTagName("FormName").item(0).getTextContent();
		String formName2 = doc.getElementsByTagName("FormName2").item(0).getTextContent();
		String formDescript = doc.getElementsByTagName("FormDescript").item(0).getTextContent();
		String formKind = doc.getElementsByTagName("FormKind").item(0).getTextContent();
		String formXslt = doc.getElementsByTagName("FORMXSLT").item(0).getTextContent();
		
		String formSihangType = doc.getElementsByTagName("SIHANGTYPE").item(0).getTextContent();
		
		// 2021-01-21 심기영 오피스 양식 여부
		String officeFlag = doc.getElementsByTagName("officeFlag").item(0).getTextContent();
		
		/* 2020-07-16 홍승비 - 전자결재 일반버전에서도 연동양식을 사용할 수 있도록 수정 */
		if (approvalFlag.equals("S")) {
			keepPeriod = doc.getElementsByTagName("KEEPPERIOD").item(0).getTextContent();
			keepPeriodCode = doc.getElementsByTagName("KEEPPERIODCODE").item(0).getTextContent();
			securityLevel = doc.getElementsByTagName("SECURITYLEVEL").item(0).getTextContent();
			isPublic = doc.getElementsByTagName("ISPUBLIC").item(0).getTextContent();
			tbItemCode = doc.getElementsByTagName("TBITEMCODE").item(0).getTextContent();
			tbItemName = doc.getElementsByTagName("TBITEMNAME").item(0).getTextContent();
			tbItemName2 = doc.getElementsByTagName("TBITEMNAME2").item(0).getTextContent();
			useFlag = doc.getElementsByTagName("USEFLAG").item(0).getTextContent();
			formConnFlag = doc.getElementsByTagName("ConnFlag").item(0).getTextContent();
		} else {
			formConnFlag = doc.getElementsByTagName("ConnFlag").item(0).getTextContent();
			openGovFlag = doc.getElementsByTagName("openGovFlag").item(0).getTextContent();
		}
		String formDraftAllFlag = doc.getElementsByTagName("draftAllFlag").item(0).getTextContent();
		formAprOption = doc.getElementsByTagName("APPROPTION").item(0).getTextContent();
		
		passAprLineFlag = doc.getElementsByTagName("passAprLineFlag").item(0).getTextContent();

		String recevGroupXML = "";
		if (formRecevGroup != null && !formRecevGroup.equals("")) {
			recevGroupXML = formRecevGroup;
		}
		
		// 현재 사용하지 않는 것으로 추정되나 일단 유지함
		@SuppressWarnings("unused")
		boolean isUpdate = false;
		String saveFileFolder = "";
		String saveFileName = "";

		if (!formID.equals("") && !formMhtInfo.equals("")) {
			isUpdate = true;
			saveFileFolder = realPath + path + commonUtil.separator + companyID + commonUtil.separator + "form";
			saveFileName = saveFileFolder + commonUtil.separator + formID + ".mht";
			
			try {
				File fileFolder = new File(commonUtil.detectPathTraversal(saveFileFolder));
				
				if (!fileFolder.exists()) {
					fileFolder.mkdirs();
				}
				
				File file = new File(commonUtil.detectPathTraversal(saveFileName));
				if (file.exists()) {
					strBeforeMHT = FileUtils.readFileToString(file);
				}

				// CWE-404 보안 취약점 대응
				try (FileWriter fw = new FileWriter(file)) {
					fw.append(formMhtInfo);
				}
			} catch (Exception e) {
				return "ERROR : " + egovMessageSource.getMessage("ezApprovalG.lhj03", userInfo.getLocale()) + e.getMessage();
			}
		}
		
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
		map.put("v_POPENGOVFLAG", openGovFlag);
		map.put("v_FORMXSLT", formXslt);
		map.put("v_PPASSAPRLINEFLAG", passAprLineFlag);
		map.put("companyID", companyID);
		map.put("tenantID", userInfo.getTenantId());
		// FormBuilder
		map.put("v_PREFORMFLAG", useReform ? "Y" : "N");
		// 양식 상세옵션
		map.put("v_formAprOption", formAprOption);
		map.put("v_FORMSIHANGTYPE", formSihangType);
		map.put("v_PFORMDRAFTALLFLAG", formDraftAllFlag);

		if (formID.equals("")) {
			formID = generateNextFormId(companyID, userInfo.getTenantId());
			
			map.put("v_PURL", path + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + formID + ".mht");
			map.put("v_PFORMID", formID);
			logger.debug("setFormDataInsert1 started.");
			ezApprovalGAdminDAO.setFormDataInsert1(map);
			logger.debug("setFormDataInsert1 ended.");
			
			if("Y".equals(officeFlag)) {
				ezApprovalGAdminDAO.insertOfficeFormFlag(map);
			}
			
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
			map.put("v_PFORMID", formID);
			map.put("v_PURL", path + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + formID + ".mht");
			
			logger.debug("setFormDataUpdate started.");
			ezApprovalGAdminDAO.setFormDataUpdate(map);
			logger.debug("setFormDataUpdate ended.");
			
			/* 2021-01-21 심기영 오피스결재 양식 용 추가 */
			if("Y".equals(officeFlag)) {
				// 오피스 양식에서 오피스 양식으로 수정할 경우 duplicate key error가 날 수 있기 때문에 지웠다가 다시 insert
				ezApprovalGAdminDAO.deleteOfficeFormFlag(map);
				ezApprovalGAdminDAO.insertOfficeFormFlag(map);
			} else {
				ezApprovalGAdminDAO.deleteOfficeFormFlag(map);
			}
			
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
				} else {
					new File(commonUtil.detectPathTraversal(saveFileName.substring(0, saveFileName.lastIndexOf(commonUtil.separator)))).mkdirs();
				}

				// CWE-404 보안 취약점 대응
				try (FileWriter fw = new FileWriter(file)) {
					fw.append(formMhtInfo);
				}
				
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

					commonUtil.writeBytesToFile(reformMhtPath, reformMht.getBytes());
					commonUtil.writeBytesToFile(reformHtmlPath, reformHtml.getBytes());

					if (reformFunction == null || reformFunction.trim().isEmpty()) {
						Files.deleteIfExists(reformFunctionPath);
					} else {
						commonUtil.writeBytesToFile(reformFunctionPath, reformFunction.getBytes());
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
	
	private String generateNextFormId(String companyId, int tenantId) throws Exception {
		Map<String, Object> parameter = new HashMap<>();
		String currentYear = commonUtil.getTodayUTCTime("YYYY");
		String formId;

		parameter.put("companyID", companyId);
		parameter.put("tenantID", tenantId);

		logger.debug("setFormDataSelect started.");
		formId = ezApprovalGAdminDAO.setFormDataSelect(parameter);
		logger.debug("setFormDataSelect ended.");

		if (formId == null) {
			formId = currentYear + "000001";
		} else {
			if (formId.substring(0,4).equals(currentYear)) {
				formId = Integer.toString((Integer.parseInt(formId) + 1));
			} else {
				formId = currentYear + "000001";
			}
		}

		// 리폼 양식 관련 파일은 지우지 않기 때문에 폼 아이디가 겹칠 수 있음
		String realPath = servletContext.getRealPath("");
		String approvalUploadPath = commonUtil.getUploadPath("upload_approvalG.ROOT", tenantId);
		String reformDirectoryPathStr = String.join(commonUtil.separator, approvalUploadPath, companyId, "form", "reform");
		File reformDirectory = Paths.get(realPath).resolve("." + reformDirectoryPathStr).toFile();

		if (!reformDirectory.exists()) {
			return formId;
		}

		String maxReformId = Stream.of(reformDirectory.listFiles(File::isDirectory))
				.map(File::getName)
				.max(String::compareTo)
				.orElse("");

		if (maxReformId.compareTo(formId) >= 0) {
			formId = Integer.toString((Integer.parseInt(maxReformId) + 1));
		}

		return formId;
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
		@SuppressWarnings("unused")
		String strBeforeMHT = "";
		
		logger.debug("saveFileFolder : " + saveFileFolder);
		logger.debug("saveFileName : " + saveFileName);
		
		try {
			File fileFolder = new File(commonUtil.detectPathTraversal(saveFileFolder));
			File file = new File(commonUtil.detectPathTraversal(saveFileName));
			
			if (!fileFolder.exists()) {
				fileFolder.mkdirs();
			}
			
			if (file.exists()) {
				strBeforeMHT = FileUtils.readFileToString(file);
			}

			// CWE-404 보안 취약점 대응
			try (FileWriter fw = new FileWriter(file)) {
				fw.append(formMHT);
			}
			
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
		@SuppressWarnings("unused")
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
		String formDraftAllFlag = "N";
		String openGovFlag = "";
		String formAprOption = "";
		String passAprLineFlag = "";

		String formName = doc.getElementsByTagName("FormName").item(0).getTextContent();
		String formName2 = doc.getElementsByTagName("FormName2").item(0).getTextContent();
		String formDescript = doc.getElementsByTagName("FormDescript").item(0).getTextContent();
		String formKind = doc.getElementsByTagName("FormKind").item(0).getTextContent();
		String formXslt = doc.getElementsByTagName("FORMXSLT").item(0).getTextContent();
		
		String useWHWP = ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId());
		// 2020-10-19 김민성 - 한글 웹기안기 신규 양식인 경우 파일로 저장하는 형식
		String hwpFileName = "";
		if(formID.equals("") && useWHWP.equalsIgnoreCase("YES")) {
			hwpFileName = doc.getElementsByTagName("HWPFILEPATH").item(0).getTextContent();
		}

		String formSihangType = doc.getElementsByTagName("SIHANGTYPE").item(0).getTextContent();
		
		/* 2020-07-16 홍승비 - 전자결재 일반버전에서도 연동양식을 사용할 수 있도록 수정 */
		if (approvalFlag.equals("S")) {
			keepPeriod = doc.getElementsByTagName("KEEPPERIOD").item(0).getTextContent();
			keepPeriodCode = doc.getElementsByTagName("KEEPPERIODCODE").item(0).getTextContent();
			securityLevel = doc.getElementsByTagName("SECURITYLEVEL").item(0).getTextContent();
			isPublic = doc.getElementsByTagName("ISPUBLIC").item(0).getTextContent();
			tbItemCode = doc.getElementsByTagName("TBITEMCODE").item(0).getTextContent();
			tbItemName = doc.getElementsByTagName("TBITEMNAME").item(0).getTextContent();
			tbItemName2 = doc.getElementsByTagName("TBITEMNAME2").item(0).getTextContent();
			useFlag = doc.getElementsByTagName("USEFLAG").item(0).getTextContent();
			formConnFlag = doc.getElementsByTagName("ConnFlag").item(0).getTextContent();
		} else {
			formConnFlag = doc.getElementsByTagName("ConnFlag").item(0).getTextContent();
			openGovFlag = doc.getElementsByTagName("openGovFlag").item(0).getTextContent();
		}
		
		/* 2022-01-07 홍승비 - 전자결재G 일괄결재 옵션 추가 */
		/* 2024-09-26 이가은 - S버전 일괄결재 옵션 포함 */
		formDraftAllFlag = doc.getElementsByTagName("draftAllFlag").item(0).getTextContent();
		formAprOption = doc.getElementsByTagName("APPROPTION").item(0).getTextContent();

		passAprLineFlag = doc.getElementsByTagName("passAprLineFlag").item(0).getTextContent();
		
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
			
			try {
				File fileFolder = new File(commonUtil.detectPathTraversal(saveFileFolder));
				File file = new File(commonUtil.detectPathTraversal(saveFileName));
				
				if (!fileFolder.exists()) {
					fileFolder.mkdirs();
				}
				
				if (file.exists()) {
					strBeforeMHT = FileUtils.readFileToString(file);
				}
				
				// CWE-404 보안 취약점 대응
				try (FileOutputStream stream = new FileOutputStream(file)) {
					stream.write(Base64.decodeBase64(formMhtInfo));
				}
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
		map.put("v_PFORMDRAFTALLFLAG", formDraftAllFlag);
		map.put("v_POPENGOVFLAG", openGovFlag);
		map.put("v_FORMXSLT", formXslt);
		map.put("v_PPASSAPRLINEFLAG", passAprLineFlag);
		map.put("companyID", companyID);
		map.put("tenantID", userInfo.getTenantId());
		map.put("v_formAprOption", formAprOption);
		map.put("v_FORMSIHANGTYPE", formSihangType);

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
					map.put("formID", result);
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
					map.put("formID", result);
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
				map.put("v_PFORMID", result);
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
			// 1. 기존 한글기안기 사용시
			if (!formMhtInfo.equals("")) {
				saveFileName = realPath + path + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + result + ".hwp";
				
				File file = new File(commonUtil.detectPathTraversal(saveFileName));
				
				if (file.exists()) {
					strBeforeMHT = FileUtils.readFileToString(file);
				} else {
					new File(commonUtil.detectPathTraversal(saveFileName.substring(0, saveFileName.lastIndexOf(commonUtil.separator)))).mkdirs();
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
			} else {
				// 2. 웹 한글기안기 사용시
				if(useWHWP.equalsIgnoreCase("YES")) {
					String beforeFilePath = realPath + path + commonUtil.separator + companyID + commonUtil.separator + "tempUploadFile" + commonUtil.separator + hwpFileName;
					String afterFilePath = realPath + path + commonUtil.separator + companyID + commonUtil.separator + "form" + commonUtil.separator + result + ".hwp";
					
					File beforeFile = new File(beforeFilePath);
					File afterFile = new File(afterFilePath);
					
					FileUtils.moveFile(beforeFile, afterFile);
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
			/* 이유정 - [웹취약점] EzApprovalGAdminDAO.moveDocListF/moveDocListS 관련 IN 조건 문자열 수정 */
			String[] info = strMoveListIDInfo.split(";");
			
			map.put("docIDList", info);
			
			ezApprovalGAdminDAO.moveDocListF(map);
			ezApprovalGAdminDAO.moveDocListS(map);
		}
		
		logger.debug("moveDocList ended");
		
		return "<PARAMETER><RESULT>TRUE</RESULT></PARAMETER>";
	}
	
	/* 2024-06-04 홍승비 - 현재 사용되지 않는 메서드로 확인하여 주석처리 */
	/*@Override
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
			// 이유정 - [웹취약점] EzApprovalGAdminDAO.deleteDocList 관련 IN 조건 문자열 수정
			String[] docIDs = subQuery.replace(" ", "").replace("\'", "").split(",");

			map.put("docIDList", docIDs);
			
			ezApprovalGAdminDAO.deleteDocList(map);
		}
		
		logger.debug("deleteDocList ended");
		
		return "<PARAMETER><RESULT>TRUE</RESULT></PARAMETER>";
	}
	*/
	
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
	
	/* 2024-04-19 홍승비 - 특수문서함 관련 기능 > 호출되지 않는 URL로 확인, 관련 메서드와 쿼리 주석처리 */
	/*@Override
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
		
		StringBuilder sb = new StringBuilder();
		
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
	*/
	
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
			File fileFolder = new File(commonUtil.detectPathTraversal(saveFileFolder));
			File file = new File(commonUtil.detectPathTraversal(saveFileName));
			
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
		
		// nullPointer 접근 오류 대응
		String result = ezApprovalGDAO.getIsUse(map);
		if (result == null) {
			result = "";
		}
		
		return result;
	}
	
	@Override
	public List<ApprGDocListVO> getContDocList_json(String containerID, String userID, String userSecurityCode, boolean publicFlag, int startRow, int pageSize, String pageNum,
			String orderCell, String orderOption, int totalcnt, String companyID, String lang, int tenantID, String offset, Locale locale, Map<String,Object> queryMap) throws Exception {
		
		int querySize = pageSize * Integer.parseInt(pageNum);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CONTID", containerID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_USERSECCODE", userSecurityCode);
		map.put("q_Map", queryMap);
		
		if (publicFlag) {
			map.put("v_PUBFLAG", "Y");
		} else {
			map.put("v_PUBFLAG", "N");
		}
		map.put("v_PAGESIZE", querySize);
		map.put("v_PAGESIZE2", pageSize);
		map.put("v_PAGESIZE3", startRow);
		map.put("v_OFFSET",offset);
		map.put("v_PSTRLANG", lang);
		
		List<ApprGDocListVO> list = ezApprovalGAdminDAO.getContDocListjson(map);
		
		return list;
	}
	
	@Override
	public int getContDocListCountjson(String containerID, String userID, String userSecurityCode, boolean publicFlag, String companyID, int tenantID, Map<String,Object> queryMap) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CONTID", containerID);
		map.put("companyID", companyID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_USERSECCODE", userSecurityCode);
		map.put("q_Map", queryMap);
		
		if (publicFlag) {
			map.put("v_PUBFLAG", "Y");
		} else {
			map.put("v_PUBFLAG", "N"); 
		}
		
		int totalCount = ezApprovalGAdminDAO.getContDocListCountjson(map);
		
		return totalCount;
	}
	
	@Override
	public int getDeleteDocListCountjson(String userID, String userSecurityCode, boolean publicFlag, String companyID, int tenantID, Map<String,Object> queryMap) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_USERSECCODE", userSecurityCode);
		map.put("q_Map", queryMap);
		
		if (publicFlag) {
			map.put("v_PUBFLAG", "Y");
		} else {
			map.put("v_PUBFLAG", "N"); 
		}
		
		int totalCount = ezApprovalGAdminDAO.getDeleteDocListCountjson(map);
		
		return totalCount;
	}
	
	@Override
	public List<ApprGDocListVO> getDeleteDocList_json(String userID, int startRow, int pageSize, String pageNum, int totalcnt, String companyID, int tenantID, String offset, String lang, Locale locale, Map<String,Object> queryMap) throws Exception{
		int querySize = pageSize * Integer.parseInt(pageNum);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_PAGESIZE", querySize);
		map.put("v_PAGESIZE2", pageSize);
		map.put("v_PAGESIZE3", startRow);
		map.put("v_OFFSET",offset);
		map.put("v_PSTRLANG", lang);
		map.put("q_Map", queryMap);
		
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
	
	@Override
	public List<ApprGAttachInfoVO> getAdminTotalDownload(String docIdList, String mode, String companyID, int tenantID) throws Exception {
		logger.debug("getAdminTotalDownload started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		map.put("v_PMODE", mode);
		
		if (!docIdList.trim().equals("")){
			map.put("docIdList", docIdList.split(","));
		}
		
		logger.debug("getAdminTotalDownload ended");
		
		return ezApprovalGAdminDAO.getAdminTotalDownload(map);
	}
	
	@Override
	public List<ApprGAttachInfoVO> getAdminTotalDownloadCnt(String docIdList, String mode, String companyID, int tenantID) throws Exception {
		logger.debug("getAdminTotalDownload started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		map.put("v_PMODE", mode);
		if (!docIdList.trim().equals("")){
			map.put("docIdList", docIdList.split(","));
		}
		
		logger.debug("getAdminTotalDownload ended");
		
		return ezApprovalGAdminDAO.getAdminTotalDownloadCnt(map);
	}

	@Override
	public void resendOpenGov(String resendStartTime, String resendEndTime, int tenantId, String companyID) throws Exception {
		logger.debug("resendOpenGov started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("tenantID", tenantId);
		map.put("startTime", resendStartTime);
		map.put("endTime", resendEndTime);
		
		ezApprovalGAdminDAO.resendOpenGov(map);
		
		logger.debug("resendOpenGov ended");
	}

	@Override
	public String getModifyOpenGovHistory(String docID, String lang, int tenantID, String companyID, String offset) throws Exception {
		logger.debug("getModifyOpenGovHistory started.");
		StringBuilder sb = new StringBuilder();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", "084");
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
		map1.put("docID", docID);
		map1.put("companyID", companyID);
		map1.put("tenantID", tenantID);

		/////////////////////////////////////////////////////////////////////////////////////// 가져오는곳
		List<ApprGOpenGovModifyHistoryVO> listBody = ezApprovalGAdminDAO.getOpenGovModifyHistory(map1);

		for (int i = 0; i < listBody.size(); i++) {
			ApprGOpenGovModifyHistoryVO bodyVo = listBody.get(i);

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

				sb.append("<CELL><VALUE>");
				if (fieldName.equals("ModifyDate")) {
					sb.append(fieldValue.substring(0, fieldValue.length() - 2) + "</VALUE>");
				} else {
					sb.append(commonUtil.cleanValue(ezApprovalGService.getListField(fieldName.toUpperCase(), fieldValue, companyID, lang, tenantID, offset)) + "</VALUE>");
				}
				if (j == 0) {
					sb.append("<DATA1>" + bodyVo.getDocID() + "</DATA1>");
					sb.append("<DATA2>" + bodyVo.getSN() + "</DATA2>");
				}

				sb.append("</CELL>");
			}

			sb.append("</ROW>");
		}

		sb.append("</ROWS></LISTVIEWDATA>");

		logger.debug("getModifyOpenGovHistory ended.");

		return sb.toString();
	}

	@Override
	public String getModifyOpenGovHistoryReason(String docID, String sn, int tenantId, String companyID) throws Exception {
		logger.debug("getModifyOpenGovHistoryReason started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", docID);
		map.put("sn", sn);
		map.put("companyID", companyID);
		map.put("tenantID", tenantId);

		String reason = ezApprovalGAdminDAO.getOpenGovModifyHistoryReason(map);
		logger.debug("getModifyOpenGovHistoryReason ended.");
		return reason;
	}
	
	/* 2020-05-15 홍승비 - 첨부파일 개수제한 관련 메서드 */
	@Override
	public int getAttachLimit(String companyID, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantId);
		
		int result = -1;
		int resultCnt = ezApprovalGAdminDAO.cntAttachLimit(map);
		
		if (resultCnt > 0) {
			result = ezApprovalGAdminDAO.getAttachLimit(map);
		}
		return result;
	}
		

	@Override
	public List<KEDAuthorUserInfo> getDocDirOwnerList(String companyId, int tenantId) throws Exception {
		logger.debug("getDocDirOwnerList start");
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<KEDAuthorUserInfo> ownerList = ezApprovalGAdminDAO.getShareDocDirOwnerList(map);
		
		logger.debug("getDocDirOwnerList end");
		return ownerList;	
	}

	@Override
	public List<KEDSharedUserInfo> getDocDirShareList(String ownerId, int tenantId) throws Exception {
		logger.debug("getDocDirShareList start");
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("ownerId", ownerId);
		map.put("tenantId", tenantId);
		
		List<KEDSharedUserInfo> shareList = ezApprovalGAdminDAO.getShareDocDirShareList(map);
		
		logger.debug("getDocDirShareList end");
		return shareList;
	}
	
	@Override
	public String insertShareDocDir(String ownerId, String ownerType, List<KEDSharedUserInfo> shareList, int tenantId) throws Exception {
		logger.debug("getDocDirShareList start");
		String result = "NO";
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("ownerId", ownerId);
		map.put("ownerType", ownerType);
		map.put("shareList", shareList);
		map.put("tenantId", tenantId);
		
		ezApprovalGAdminDAO.deleteShareDocDir(map);
		
		result = ezApprovalGAdminDAO.insertShareDocDir(map);
		
		logger.debug("getDocDirShareList end");
		return result;
	}
	
	@Override
	public void saveAttachLimit(String attachLimit, String companyID, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_ATTACHLIMIT", attachLimit);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantId);
		
		int result = -1;
		int resultCnt = ezApprovalGAdminDAO.cntAttachLimit(map);
		
		if (resultCnt > 0) {
			result = ezApprovalGAdminDAO.getAttachLimit(map);
		}
		
		if (result == -1) { // 레코드가 없다면 삽입
			ezApprovalGAdminDAO.saveAttachLimit(map);
		} else { // 레코드가 있다면 업데이트
			ezApprovalGAdminDAO.updateAttachLimit(map);
		}
	}
	
	@Override
	public void deleteAttachLimit(String companyID, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantId);
		
		ezApprovalGAdminDAO.deleteAttachLimit(map);
	}
	
	@Override
	public String deleteShareDocDir(String ownerId, int tenantId) throws Exception {
		logger.debug("deleteShareDocDir start");
		String result = "NO";
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("ownerId", ownerId);
		map.put("tenantId", tenantId);
		
		int resultNum = ezApprovalGAdminDAO.deleteShareDocDir(map);
		
		if(resultNum > 0){
			result = "YES";
		}
		
		logger.debug("deleteShareDocDir end");
		return result;
	}
	
	@Override
	public String getSendOutDocList(String userID, String deptID, String mode, String pageSize, String pageNum, String sortHeader, String sortOption, String companyID, String userLang, int tenantID, String offset, Map<String,Object> queryMap) throws Exception {
		logger.debug("getSendOutDocList started");

		StringBuilder resultXML = new StringBuilder();
		String orderOption1 = "";
		String orderOption2 = "";
		String basicOrder = getCode2Name("A18", "001", companyID, userLang, tenantID);
		String basicOrderReverse = "desc";
		
		if (basicOrder.toLowerCase().equals("desc")) {
			basicOrderReverse = "";
		} else {
			basicOrder = "";
		}
		
		String listString = "";
		
		listString = "<DATA>"
				+ "<ROW>"
				+ "<NAME>제목</NAME>"
				+ "<NAME2></NAME2>"
				+ "<NAME3></NAME3>"
				+ "<NAME4></NAME4>"
				+ "<WIDTH>250</WIDTH>"
				+ "<COLNAME>DocTitle</COLNAME>"
				+ "<TABLENAME></TABLENAME>"
				+ "</ROW>"
				+ "<ROW>"
				+ "<NAME>발신의뢰부서</NAME>"
				+ "<NAME2></NAME2>"
				+ "<NAME3></NAME3>"
				+ "<NAME4></NAME4>"
				+ "<WIDTH>65</WIDTH>"
				+ "<COLNAME>WriterDeptName</COLNAME>"
				+ "<TABLENAME></TABLENAME>"
				+ "</ROW>"
				+ "<ROW>"
				+ "<NAME>발신의뢰자</NAME>"
				+ "<NAME2></NAME2>"
				+ "<NAME3></NAME3>"
				+ "<NAME4></NAME4>"
				+ "<WIDTH>55</WIDTH>"
				+ "<COLNAME>WriterName</COLNAME>"
				+ "<TABLENAME></TABLENAME>"
				+ "</ROW><ROW>"
				+ "<NAME>발신의뢰일자</NAME>"
				+ "<NAME2></NAME2>"
				+ "<NAME3></NAME3>"
				+ "<NAME4></NAME4>"
				+ "<WIDTH>100</WIDTH>"
				+ "<COLNAME>EndDate</COLNAME>"
				+ "<TABLENAME></TABLENAME>"
				+ "</ROW>"
				+ "<ROW>"
				+ "<NAME>문서상태</NAME>"
				+ "<NAME2></NAME2>"
				+ "<NAME3></NAME3>"
				+ "<NAME4></NAME4>"
				+ "<WIDTH>60</WIDTH>"
				+ "<COLNAME>ProcessYN</COLNAME>"
				+ "<TABLENAME></TABLENAME>"
				+ "</ROW>"
				+ "<ROW>"
				+ "<NAME>양식명</NAME>"
				+ "<NAME2></NAME2>"
				+ "<NAME3></NAME3>"
				+ "<NAME4></NAME4>"
				+ "<WIDTH>100</WIDTH>"
				+ "<COLNAME>FormName</COLNAME>"
				+ "<TABLENAME></TABLENAME>"
				+ "</ROW>"
				+ "<ROW>"
				+ "<NAME>파일명</NAME>"
				+ "<NAME2></NAME2>"
				+ "<NAME3></NAME3>"
				+ "<NAME4></NAME4>"
				+ "<WIDTH>200</WIDTH>"
				+ "<COLNAME>FileName</COLNAME>"
				+ "<TABLENAME></TABLENAME>"
				+ "</ROW>"
				+ "<ROW>"
				+ "<NAME>파일경로</NAME>"
				+ "<NAME2></NAME2>"
				+ "<NAME3></NAME3>"
				+ "<NAME4></NAME4>"
				+ "<WIDTH>70</WIDTH>"
				+ "<COLNAME>FolderName</COLNAME>"
				+ "<TABLENAME></TABLENAME>"
				+ "<ROW>"
				+ "</ROW>"
				+ "<NAME>처리상태</NAME>"
				+ "<NAME2></NAME2>"
				+ "<NAME3></NAME3>"
				+ "<NAME4></NAME4>"
				+ "<WIDTH>50</WIDTH>"
				+ "<COLNAME>SendState</COLNAME>"
				+ "<TABLENAME></TABLENAME>"
				+ "</ROW>"
				+ "<ROW>"
				+ "<NAME>파일상태</NAME>"
				+ "<NAME2></NAME2>"
				+ "<NAME3></NAME3>"
				+ "<NAME4></NAME4>"
				+ "<WIDTH>50</WIDTH>"
				+ "<COLNAME>FileState</COLNAME>"
				+ "<TABLENAME></TABLENAME>"
				+ "</ROW>"
				+ "</DATA>";
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		int totalCount = getSendOutDocListCount(mode, companyID, tenantID, queryMap);
		int querySize = Integer.parseInt(pageSize) * Integer.parseInt(pageNum);
		int querySize2 = totalCount - Integer.parseInt(pageSize) * (Integer.parseInt(pageNum) - 1);
		
		if (querySize2 >= Integer.parseInt(pageSize)) {
			querySize2 = Integer.parseInt(pageSize);
		}
		
		resultXML.append("<DOCLIST>");
		resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			
			if (!sortHeader.equals("") && sortHeader.equals(listXML.getElementsByTagName("NAME").item(k).getTextContent())) {
				if (sortOption.equals("")) {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
					orderOption2 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
				} else {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
					orderOption2 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
				}
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		String docList = getSendOutDocList(mode, querySize, querySize2, orderOption1, orderOption2, basicOrder, basicOrderReverse, companyID, tenantID, queryMap);
		
		Document docXML = commonUtil.convertStringToDocument(docList);
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		String langData = commonUtil.getMultiData(userLang, tenantID);
		resultXML.append("<ROWS>");
		
		for (int k = dlength - 1; k >= 0; k--) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				if (fieldName.equals("WRITERDEPTNAME") || fieldName.equals("WRITERNAME") || fieldName.equals("FORMNAME")) {
					fieldName = fieldName + langData;
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, companyID, userLang, tenantID, offset)) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + docXML.getElementsByTagName("DOCID").item(k).getTextContent() + "</DATA1>");
					resultXML.append("<DATA2>" + "" + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("HREF").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + docXML.getElementsByTagName("CONTAINERID").item(k).getTextContent() + "</DATA4>");
					resultXML.append("<DATA5>" + docXML.getElementsByTagName("PROCESSYN").item(k).getTextContent() + "</DATA5>");
					resultXML.append("<DATA6>" + "" + "</DATA6>");
					resultXML.append("<DATA7>" + "" + "</DATA7>");
					resultXML.append("<DATA8>" + "" + "</DATA8>");
					resultXML.append("<DATA9>" + "" + "</DATA9>");
					resultXML.append("<DATA10>" + "" + "</DATA10>");
					resultXML.append("<DATA11>" + "" + "</DATA11>");
					resultXML.append("<DATA12>" + "" + "</DATA12>");
					resultXML.append("<DATA13>" + "" + "</DATA13>");
					resultXML.append("<DATA14>" + makeListField(docXML.getElementsByTagName("URGENTAPPROVAL").item(k).getTextContent()) + "</DATA14>");
					resultXML.append("<DATA16>" + makeListField(docXML.getElementsByTagName("FORMID").item(k).getTextContent()) + "</DATA16>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");
		

		logger.debug("getSendOutDocList ended");
		
		return resultXML.toString();
	}
	
	public String getListHeader(String listCode, String companyID, String lang, int tenantID) throws Exception{
		logger.debug("getListHeader started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", listCode);
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getListHeader Param : v_LISTTYPE="+ listCode + " v_LANGTYPE = " +lang +" companyID = " + companyID + " v_TENANTID =" + tenantID);
		List<ApprGListHeaderVO> apprGListHeaderVOList = ezApprovalGDAO.getListHeader(map);
		
        StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGListHeaderVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGListHeaderVOList.get(i)));
		}
		sb.append("</DATA>");
		logger.debug("getListHeader ended.");

		return sb.toString();
	}
	
	public String getCode2Name(String code1, String code2, String companyID, String lang, int tenantID) throws Exception{
		logger.debug("getCode2Name started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE1", code1);
		map.put("v_CODE2", code2);
		map.put("companyID", companyID);
		map.put("v_LANGTYPE", lang);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getOptionInfo Param : v_CODE1=" + code1 + " v_CODE2=" + code2 + " v_LANGTYPE=" + lang +" companyID = " + companyID +  " v_TENANTID= " + tenantID);

		String rtnValue = ezApprovalGDAO.getCode2Name(map);
		
		logger.debug("getCode2Name ended.");
		
		return rtnValue;
	}
	
	private String getSendOutDocList(String mode, int querySize, int querySize2, String orderOption1, String orderOption2, String basicOrder, String basicOrderReverse, String companyID, int tenantID, Map<String,Object> queryMap) throws Exception {
		logger.debug("getSendOutDocList started");

		List<ApprGDocListVO> apprGDocListVOList = new ArrayList<ApprGDocListVO>();
		Map<String, Object> map = new HashMap<String, Object>();
		String orderCol = ""; // 정렬할 컬럼값
		
		map.put("companyID", companyID);
		map.put("v_MODE", mode);
		map.put("v_PAGESIZE", querySize);
		map.put("v_PAGESIZE2", querySize2);
		
		if (orderOption1.length() > 0) {
			String[] tmpStr = orderOption1.substring(0,orderOption1.trim().length()).toLowerCase().split(" ");
			orderCol = tmpStr[0];
			map.put("v_ORDERCOL", orderCol);
			
			if (orderCol.equals("enddate")) {
				map.put("v_ENDCHECK", "true");
			} else {
				map.put("v_ENDCHECK", "false");
			}
			if (tmpStr.length != 1) {
				if (tmpStr[1].equals("desc")) {
					map.put("v_ORDERSORT", "desc");
				}
			} else {
				map.put("v_ORDERSORT", "asc");
			}
		}
		
		map.put("v_TENANTID", tenantID);
		map.put("v_MODELENGTH", mode.trim().length());
		
		//2018-09-28 김보미 - 검색 추가
		map.put("q_Map", queryMap);
		map.put("V_DATABASE", "jmocha");
		map.put("V_TABLE", "tbl_sendoutinfo");
		
		int checkSendOutTable = ezApprovalGAdminDAO.checkSendOutInfoTable(map);
		
		if (checkSendOutTable > 0) {
			apprGDocListVOList = ezApprovalGAdminDAO.getSendOutDocList_file(map);
		} else {
			apprGDocListVOList = ezApprovalGAdminDAO.getSendOutDocList(map);
		}
		
		StringBuffer sb = new StringBuffer();
		sb.append("<DATA>");
		
		for (int i = 0; i < apprGDocListVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGDocListVOList.get(i)));
		}
		
		sb.append("</DATA>");

		logger.debug("getSendOutDocList ended");
		
		return sb.toString();
	}

	private int getSendOutDocListCount(String mode, String companyID, int tenantID, Map<String,Object> queryMap) throws Exception {
		logger.debug("getSendOutDocListCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyID", companyID);
		map.put("v_MODE", mode);
		map.put("v_TENANTID", tenantID);
		map.put("v_MODELENGTH", mode.trim().length());
		map.put("q_Map", queryMap);
		
		int totalCount = 0; 
		
		map.put("V_DATABASE", "jmocha");
		map.put("V_TABLE", "tbl_sendoutinfo");
		
		int checkSendOutTable = ezApprovalGAdminDAO.checkSendOutInfoTable(map);
		
		if (checkSendOutTable > 0) {
			totalCount = ezApprovalGAdminDAO.getSendOutDocListCount_file(map);
		} else {
			totalCount = ezApprovalGAdminDAO.getSendOutDocListCount(map);
		}
		
		logger.debug("getSendOutDocListCount ended");
		
		return totalCount;
	}
	
	public String getListField(String fieldName, String fieldValue, String companyID, String userLang, int tenantID, String offSet) throws Exception {
		logger.debug("getListField started");

		String rtnVal = "";
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", tenantID);
		
		switch (fieldName) {
		case "DOCTYPE" : 
			rtnVal = getCode2Name("A01", fieldValue, companyID, userLang, tenantID);
			
			break;
			
		case "DOCSTATE" :
			rtnVal = getCode2Name("A02", fieldValue, companyID, userLang, tenantID);
			
			break;
			
		case "APRTYPE" :
			
			if (approvalFlag.equals("G")) {
				rtnVal = getCode2Name("A03", fieldValue, companyID, userLang, tenantID);
			} else {
				rtnVal = getCode2Name("SA03", fieldValue, companyID, userLang, tenantID);
			}
			
			break;
			
		case "APRSTATE" :
			if (approvalFlag.equals("G")) {
				rtnVal = getCode2Name("A04", fieldValue, companyID, userLang, tenantID);
			} else {
				rtnVal = getCode2Name("SA04", fieldValue, companyID, userLang, tenantID);
			}
			
			break;
			
		case "FUNCTIONTYPE" :
			if (approvalFlag.equals("G")) {
				rtnVal = getCode2Name("A04", fieldValue, companyID, userLang, tenantID);
			} else {
				rtnVal = getCode2Name("SA04", fieldValue, companyID, userLang, tenantID);
			}
			
			break;
			
		case "PROCESSYN" :
			rtnVal = getStatusName(fieldValue, companyID, userLang, tenantID);
			
			break;
			
		case "OPINIONGB" :
			rtnVal = getCode2Name("A17", fieldValue, companyID, userLang, tenantID);
			
			break;
			
		case "ATTACHFILESIZE" :
			/**
			 * log를 이용한 첨부파일 단위 변환.
			 * cnt값이 0인경우 바이트, 1인경우 KB...
			 * Math.pow를 통해 1024의 cnt승을 구한 뒤 최초 fieldValue를 나누는데 사용.
			 * */
			int cnt = (int) (Math.log10(Double.parseDouble(fieldValue)) / Math.log10(1024));
			String[] unit = {" bytes", " KB", " MB", " GB"};
			
			double filesize = Double.parseDouble(fieldValue) / Math.pow(1024, cnt);
			fieldValue = String.format("%.1f",filesize);
			//rtnVal = fieldValue + " bytes";
			rtnVal = fieldValue + unit[cnt];
			break;
			
		default : 
			if(fieldName.indexOf("DATE") > -1) {
				fieldValue = commonUtil.getDateStringInUTC(convertDate(fieldValue), offSet, false);
			}
			rtnVal = fieldValue;
			break;
		}

		logger.debug("getListField ended");

		return makeListField(rtnVal);
	}
	
	public String makeListField(String orgStr) {
		if (orgStr == null || orgStr.equals("NULL")) {
			return "";
		} else {
			return orgStr;
		}
	}
	
	public String convertDate(String date) {
		   if (date.trim().equals("")) {
			   return date;
		   }
		
		   return date.substring(0, 19);
	}
	
	public String getStatusName(String fieldValue, String companyID, String userLang, int tenantID) throws Exception{
		return getCode2Name("A60", fieldValue.toUpperCase(), companyID, userLang, tenantID);
	}
	
	/* 2024-06-04 홍승비 - 구버전 전자결재 전체문서조회(완료문서) 문서목록 호출 함수 > 호출되지 않는 URL로 확인, 관련 메서드와 쿼리 주석처리 */
	/*@Override
	public String getAdminSearchDocList(
			String formID,
			String formName,
			String docNumber,
			String docTitle, 
			String drafter, 
			String approvUser, 
			String draftDeptName, 
			String draftfrom, 
			String draftto, 
			String apprfrom,
			String apprto, 
			String pageSize, 
			String pageNum, 
			String orderCell, 
			String orderOption, 
			String companyID,  
			int tenantID, 
			String lang, 
			String offSet, 
			String approvalFlag,
			String keyword,
			Locale locale
			) throws Exception {
		
		StringBuffer resultXML = new StringBuffer();

		String OrderOption1 = "";
		String OrderOption2 = "";
		String OrderOptionValue = "";
		boolean docAttachFlag = false; //2019-03-28 천성준 - 문서첨부 리스트 검색인지 체크 Flag. true:기안>문서첨부>검색, false:다른리스트들 검색(추후 문서첨부 리스트 재개발되면 지울예정)
		
		 // 수정(2007.06.18) : multidata 기능추가 
		String strMultiData = commonUtil.getMultiData(lang, tenantID);
		
		String listString = "";
		
		// 표준모듈 (2007.05.07) : 다국어
		if (approvalFlag.equals("G")) {
			listString = getListHeader("082", companyID, lang, tenantID);
		} else {
			listString = getListHeader("S082", companyID, lang, tenantID);
		}
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCNUMBER", docNumber);
		map.put("v_DOCTITLE", docTitle);
		map.put("v_DRAFTER", drafter);
		map.put("v_DEPTNAME", draftDeptName);
		map.put("v_FORMID", formID);
		map.put("v_FORMNAME", formName); // 2021-01-13 박기범 문서명 검색 추가
		map.put("v_STARTDATE1", draftfrom );
		map.put("v_STARTDATE2", draftto);
		map.put("v_ENDDATE1", apprfrom);
		map.put("v_ENDDATE2", apprto);
		map.put("v_APPROVUSER", approvUser);
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		map.put("v_KEYWORD", keyword); // 2021-03-11 박기범 키워드 검색 추가

		map.put("approvalFlag", approvalFlag);		
		
		map.put("v_ORDEROPTION", OrderOption1);
		map.put("v_ORDEROPTIONLENGTH", OrderOption1.length());
		
		if (OrderOption1.length() > 0 ) {
			map.put("v_ORDEROPTIONVALUE", OrderOption1.substring(0,OrderOption1.trim().length()).toLowerCase());
		}
		
		map.put("v_ORDEROPTION2", OrderOption2);
		map.put("v_ORDEROPTIONLENGTH2", OrderOption2.length());
		
		if (OrderOption2.length() > 0 ) {
			map.put("v_ORDEROPTIONVALUE2", OrderOption2.substring(0,OrderOption2.trim().length()).toLowerCase());
		}
		
		int totalCount = ezApprovalGAdminDAO.getSearchDocListCount(map);
		
		resultXML.append("<DOCLIST>");
		resultXML.append("<TOTALCNT>"+ totalCount +"</TOTALCNT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		int hlength = listXML.getElementsByTagName("ROW").getLength();
		
		for (int k = 0; k < hlength; k++) {
			//2019-03-28 천성준 - 기안 > 문서첨부 > 문서리스트에서 보여줄 헤더만 보이게 필요없는건 빼는로직 추가(추후 문서첨부 로직 재개발 예정)
			if (docAttachFlag) {
				String tmpStr = listXML.getElementsByTagName("COLNAME").item(k).getTextContent().toUpperCase();
				if (tmpStr.equals("FORMNAME") || tmpStr.equals("EDMSYN") || tmpStr.equals("DOCSTATENAME") || tmpStr.equals("SENDFLAG") || tmpStr.equals("HASATTACHYN") || tmpStr.equals("ISPUBLIC")) {
					continue;
				}
			}
			
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			
			if (!orderCell.equals("") && orderCell.equals(listXML.getElementsByTagName("NAME").item(k).getTextContent())) {
				if (orderOption.equals("")) {
					OrderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
					OrderOption2 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
				} else {
					OrderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
					OrderOption2 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
				}
				OrderOptionValue = listXML.getElementsByTagName("COLNAME").item(k).getTextContent();
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");

		map.put("v_ORDEROPTION", OrderOption1);
		map.put("v_ORDEROPTIONLENGTH", OrderOption1.length());
		
		if (OrderOption1.length() > 0 ) {
			map.put("v_ORDEROPTIONVALUE", OrderOptionValue.toLowerCase());
		}
		map.put("v_ORDEROPTION2", OrderOption2);
		map.put("v_ORDEROPTIONLENGTH2", OrderOption2.length());
		
		if (OrderOption2.length() > 0 ) {
			map.put("v_ORDEROPTIONVALUE2", OrderOptionValue.toLowerCase());
		}
		
		map.put("v_MULTIDATALANG", strMultiData);
		map.put("v_PAGESIZE2", totalCount - (Integer.parseInt(pageSize)*(Integer.parseInt(pageNum)-1)));
		map.put("v_PAGESIZE", Integer.parseInt(pageSize)*Integer.parseInt(pageNum));
		map.put("v_PAGESIZE3", Integer.parseInt(pageSize) * Integer.parseInt(pageNum) - Integer.parseInt(pageSize));

        map.put("alFlag", "");

		List <ApprGDocListVO> searchDocList = ezApprovalGAdminDAO.getSearchDocList(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int j = 0; j < searchDocList.size(); j++) {
			sb.append(commonUtil.getQueryResult(searchDocList.get(j)));
		}
		sb.append("</DATA>");
		
		boolean firstFlag = true;
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		String FieldName = "";
		String FieldValue = "";
		resultXML.append("<ROWS>");
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		for(int k = dlength-1; k >=0; k-- ) {
			resultXML.append("<ROW>");
			firstFlag = true;
			
			for(int i=0; i<hlength; i++) {
				FieldName = listXML.getElementsByTagName("COLNAME").item(i).getTextContent().toUpperCase();
				//2019-03-28 천성준 - 기안 > 문서첨부 > 문서리스트에서 보여줄 데이터만 보이게 필요없는건 빼는로직 추가(추후 문서첨부 로직 재개발 예정)
				if (docAttachFlag) {
					if (FieldName.equals("FORMNAME") || FieldName.equals("EDMSYN") || FieldName.equals("DOCSTATENAME") || FieldName.equals("SENDFLAG") || FieldName.equals("HASATTACHYN") || FieldName.equals("ISPUBLIC")) {
						continue;
					}
				}
				
        		FieldValue = docXML.getElementsByTagName(FieldName).item(k).getTextContent();
 				resultXML.append("<CELL>");
				resultXML.append("<VALUE><![CDATA[" + getListField(FieldName, FieldValue, companyID, lang, tenantID, offSet) + "]]></VALUE>");
			
				if (firstFlag) { 
					resultXML.append("<DATA1><![CDATA[" + docXML.getElementsByTagName("DOCID").item(k).getTextContent() + "]]></DATA1>");
					resultXML.append("<DATA2><![CDATA[" + docXML.getElementsByTagName("HREF").item(k).getTextContent() + "]]></DATA2>");
					resultXML.append("<DATA3><![CDATA[" + docXML.getElementsByTagName("WRITERID").item(k).getTextContent() + "]]></DATA3>");
					resultXML.append("<DATA4><![CDATA[" + docXML.getElementsByTagName("CONTAINERID").item(k).getTextContent() + "]]></DATA4>");
					resultXML.append("<DATA5><![CDATA[" + docXML.getElementsByTagName("ORGDOCID").item(k).getTextContent() + "]]></DATA5>");
					resultXML.append("<DATA6><![CDATA[" + docXML.getElementsByTagName("FORMID").item(k).getTextContent() + "]]></DATA6>");
					resultXML.append("<DATA7><![CDATA[" + docXML.getElementsByTagName("DOCSTATENAME").item(k).getTextContent() + "]]></DATA7>");
					resultXML.append("<DATA8><![CDATA[" + docXML.getElementsByTagName("ISPUBLIC").item(k).getTextContent() + "]]></DATA8>");
					resultXML.append("<DATA9><![CDATA[" + docXML.getElementsByTagName("DOCTYPE").item(k).getTextContent() + "]]></DATA9>");
					resultXML.append("<DATA10><![CDATA[" + docXML.getElementsByTagName("SECURITYAPPROVAL").item(k).getTextContent() + "]]></DATA10>");
					resultXML.append("<DATA11><![CDATA[" + docXML.getElementsByTagName("EDMSYN").item(k).getTextContent() + "]]></DATA11>");
					resultXML.append("<DATA12><![CDATA[" + docXML.getElementsByTagName("DOCSTATE").item(k).getTextContent() + "]]></DATA12>");
					resultXML.append("<DATA99><![CDATA[" + docXML.getElementsByTagName("FORMNAME").item(k).getTextContent() + "]]></DATA99>"); // 기안 > 문서첨부 >[양식명]을 리스트에서 보여주기위한 DATA99값 추가
					resultXML.append("<ORGCOMPANYID><![CDATA[" + docXML.getElementsByTagName("COMPANYID").item(k).getTextContent() + "]]></ORGCOMPANYID>");
					resultXML.append("<HASOPINIONYN><![CDATA[" + docXML.getElementsByTagName("HASOPINIONYN").item(k).getTextContent() + "]]></HASOPINIONYN>");
					firstFlag = false;
				}
				
				if (listXML.getElementsByTagName("COLNAME").item(i).getTextContent().equals("HASATTACHYN")) {
					resultXML.append("<HASATTACHYN>" + docXML.getElementsByTagName("HASATTACHYN").item(k).getTextContent() + "</HASATTACHYN>");
				}
				
				if (listXML.getElementsByTagName("COLNAME").item(i).getTextContent().equals("ISPUBLIC")) {
					resultXML.append("<ISPUBLIC>" + docXML.getElementsByTagName("ISPUBLIC").item(k).getTextContent() + "</ISPUBLIC>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");
				
 		return resultXML.toString();
	}
	*/
	
	public Object getAuditApprLineListPrc(String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("getAuditApprLineListPrc start");
		LoginVO user = commonUtil.userInfo(loginCookie);
		
		//관리자 권한 체크
		if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		String companyId = user.getCompanyID();
		String auditApprLineId = request.getParameter("auditApprLineId");
		String insUserArray = request.getParameter("insUserArray");
		String delUserArray = request.getParameter("delUserArray");
		
		Map<String, Object> mapResult = new HashMap<String, Object>();
		JSONParser parser = new JSONParser();
		JSONArray jaInsUserArray = new JSONArray();
		//JSONArray jaDelUserArray = new JSONArray();
		
		if(insUserArray != null) {
			jaInsUserArray = (JSONArray)parser.parse(insUserArray);
		}
		/*
		if(delUserArray != null) {
			jaDelUserArray = (JSONArray)parser.parse(delUserArray);
		}
		*/
		Map<String, Object> mapDel = new HashMap<String, Object>();
		mapDel.put("auditApprLineId", auditApprLineId);
		ezApprovalGAdminDAO.getAuditApprLineListDel(mapDel);
		
		for(int i=0; i<jaInsUserArray.size(); i++) {
			Map<String, Object> mapIns = new HashMap<String, Object>();
			
			mapIns = (Map<String, Object>)jaInsUserArray.get(i);
			mapIns.put("auditApprLineId", auditApprLineId);
			// tenantid, companyid 는 로그인한 사용자 기준으로 해도 무방해 보임
			// tenantid 는 화면에서 상이한 값으로 insert 될 수가 없음 => 로그인 사용자 tenantid 사용
			// companyid 는 값이 달라도 부모화면에서 부터  전달 받음
			mapIns.put("companyId", companyId);
			mapIns.put("tenantId", user.getTenantId());
			
			ezApprovalGAdminDAO.getAuditApprLineListIns(mapIns);
		}
		
		mapResult.put("auditApprLineId", auditApprLineId);
		
		JSONObject jo = new JSONObject();
		jo.put("result = ", mapResult);
		logger.debug("getAuditApprLineListPrc end");
		
		return jo;
	}
	
	public String auditApprLineManagePop(String loginCookie, HttpServletRequest request, HttpServletResponse response, ModelAndView model) throws Exception {
		logger.debug("auditApprLineManagePop started.");
	    
		LoginVO user = commonUtil.userInfo(loginCookie);
		
		//관리자 권한 체크
		if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		String userID = (request.getParameter("userID") != null ? request.getParameter("userID") : "");
        String selCompany = (request.getParameter("companyID") != null ? request.getParameter("companyID") : "");
		String topID = "";
		String deptTreeTopId = "";
		//String delType = (request.getParameter("DelType") !=null ? request.getParameter("DelType") : "");
		//String type = (request.getParameter("type") !=null ? request.getParameter("type") : "");
		String title = (request.getParameter("title") !=null ? request.getParameter("title") : "");
		String auditApprLineId = (request.getParameter("auditApprLineId") !=null ? request.getParameter("auditApprLineId") : "");
		String packageType = commonUtil.getPackageType(user.getTenantId());
		
		if (user.getRollInfo().indexOf("c=1") == -1) {
			topID = user.getCompanyID();
			deptTreeTopId = topID;
		} else {
			topID = "Top";
			deptTreeTopId = topID + "/organ";
		}
		
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", user.getTenantId());
		String approvalForDoc = ezCommonService.getTenantConfig("approvalForDoc", user.getTenantId());
		//2018-07-31 김보미 - 근태 추가
		String use_attitude = ezCommonService.getTenantConfig("USE_ATTITUDE", user.getTenantId());
		if (use_attitude == null || use_attitude.equals("")) {
			use_attitude = "YES";
		}
		
		String useWebfolder = ezCommonService.getTenantConfig("useWebfolder", user.getTenantId());
		
		model.addObject("packageType", packageType);
		model.addObject("userID", userID);
		model.addObject("companyID", selCompany);
		model.addObject("topID", topID);
		model.addObject("userInfo", user);
		model.addObject("isAdmin", user.getRollInfo().indexOf("c=1") > -1);
		model.addObject("approvalFlag", approvalFlag);
		model.addObject("approvalForDoc", approvalForDoc);
		model.addObject("use_attitude", use_attitude);
		model.addObject("deptTreeTopId", deptTreeTopId);
		model.addObject("useWebfolder", useWebfolder);
		model.addObject("title", title);
		model.addObject("auditApprLineId", auditApprLineId);
		//model.addAttribute("DelType", delType);
		//model.addAttribute("type", type);
		
		logger.debug("auditApprLineManagePop ended.");
		
		return "admin/ezApprovalG/auditApprLineManagePop";
	}
	
	public String getAuditApprLineList(String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("getAuditApprLineList started.");
	    
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
        String result = "";
        String value = request.getParameter("value");
		String companyID = request.getParameter("companyID");
		String type = request.getParameter("type");
		String strLang = userInfo.getPrimary();
		String searchType = request.getParameter("searchType");
		String searchValue = request.getParameter("searchValue");
		String prop = request.getParameter("propArray");
		String attr = request.getParameter("attrArray");
		String auditApprLineId = request.getParameter("auditApprLineId");
		int pageNum = Integer.parseInt(request.getParameter("pageNum"));
		int pageSize = Integer.parseInt(request.getParameter("pageSize"));		
		int startRow = Math.addExact(Math.multiplyExact(pageSize, Math.subtractExact(pageNum, 1)), 1);
        int endRow = Math.multiplyExact(pageSize, pageNum);
        
		searchValue = searchValue.replace("%", "\\%").replace("_", "\\_");
		
		if(("").equals(auditApprLineId)) {
			auditApprLineId = "AD0001";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		JSONParser parser = new JSONParser();
		JSONArray jaProp = (JSONArray)parser.parse(prop);
		JSONArray jaAttr = (JSONArray)parser.parse(attr);
		JSONArray ja = new JSONArray();
		
		map.put("tenantId", tenantID);
		map.put("companyId", companyID);
		map.put("auditApprLineId", auditApprLineId);
		map.put("value", value);
		map.put("startRow", startRow);
		map.put("endRow", endRow);

		List<HashMap<String, Object>> list = ezApprovalGAdminDAO.getAuditApprLineList(map);
		int count = ezApprovalGAdminDAO.getAuditApprLineListCnt(map);

		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			resultMap = list.get(i);
			ja.add(resultMap);
		}
		
		result = commonUtil.makeListViewData(count, ja, jaAttr, jaProp, value);
		logger.debug("result = " + result);
        logger.debug("getAuditApprLineList ended.");
        
		return result.toString();
	}
	
	public String auditApprLineManage(String loginCookie, HttpServletRequest request, HttpServletResponse response, ModelAndView model) throws Exception {
		logger.debug("auditApprLineManage started.");
	    
		LoginVO user = commonUtil.userInfo(loginCookie);
		//관리자 권한 체크
		if (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(user.getPrimary(), user.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			
			
			if (user.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(user.getCompanyID())) {
				resultList.add(j++, vo);
			}
		}
		
		model.addObject("userCompany", user.getCompanyID());
		model.addObject("list", resultList);
		model.addObject("isAdmin", user.getRollInfo().indexOf("c=1") > -1);	
		
		logger.debug("auditApprLineManage ended.");
		
		return "admin/ezApprovalG/auditApprLineManage";
	}
	
	public Object getAuditStatisticsDocList(String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("getAuditStatisticsDocList start");
		JSONObject jo = new JSONObject();
		LoginVO user = commonUtil.userInfo(loginCookie);
		boolean result = false;
		
		String companyId = user.getCompanyID();
		int tenantId = user.getTenantId();
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String idx = request.getParameter("idx");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("idx", idx);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("offsetMin", commonUtil.getMinuteUTC(user.getOffset()));
		
		List<HashMap<String, Object>> list = ezApprovalGAdminDAO.getAuditStatisticsDocList(map);
		result = true;
		
		jo.put("rows", list);
		jo.put("result", result);
		logger.debug("getAuditStatisticsDocList end");
		
		return jo;
	}

	@Override
	public String xlsxSetGroupWithExcel(String loginCookie, MultipartHttpServletRequest request) {
		logger.debug("xlsxSetGroupWithExcel started");

		String result = "";
		int counts = 0;
		LoginVO user = commonUtil.userInfo(loginCookie);
		String companyId = user.getCompanyID();
		int tenantId = user.getTenantId();
		MultipartFile file = request.getFile("file");
		LinkedList<HashSet<String>> groupDatas = new LinkedList<>();
		LinkedList<String> groupNames = new LinkedList<>();
		boolean isGroup = false;
		InputStream is = null;

		try {
			is = file.getInputStream();
			XSSFWorkbook workbook = new XSSFWorkbook(is);
			XSSFSheet curSheet;
			XSSFRow curRow;
			XSSFCell curCell;
			ApprGAdminReceiveVO vo;
			String value;
			curSheet = workbook.getSheetAt(0);
			int physicalRows = curSheet.getPhysicalNumberOfRows();

			if (curSheet.getRow(0).getCell(7).getNumericCellValue() > 0) {
				return "";
			}

			for(int rowIndex=1; rowIndex < physicalRows; rowIndex++) {
				isGroup = false;
				curRow = curSheet.getRow(rowIndex);
				HashSet<String> data = new HashSet<>();

				if(curRow.getCell(1) != null) {

					for(int cellIndex=1;cellIndex<curRow.getPhysicalNumberOfCells(); cellIndex++) {
						curCell = curRow.getCell(cellIndex);
						// 조건부 서식 등에 의해 null값이 들어 올 수 있음.
						if (curCell == null) {
							break;
						}

						value = "";
						switch (curCell.getCellType()){
							case XSSFCell.CELL_TYPE_FORMULA:
							case XSSFCell.CELL_TYPE_BLANK:
								value = "";
								break;
							case XSSFCell.CELL_TYPE_NUMERIC:
								value = (int) curCell.getNumericCellValue() + "";
								break;
							case XSSFCell.CELL_TYPE_STRING:
								value = curCell.getStringCellValue() + "";
								break;
							case XSSFCell.CELL_TYPE_ERROR:
								value = curCell.getErrorCellValue() + "";
								break;
						}

						if ("".equals(value)) {
							break;
						} else if (cellIndex == 1) {
							groupNames.add(value);
							isGroup = true;
						} else {
							if (ezApprovalGAdminDAO.checkDeptId(value) < 1) {
								return "none deptId :" + value;
							}

							boolean dataInput = data.add(value);
							// data 중복일 경우
							if (!dataInput) {
								return "duplicated :" + value;
							}
						}
					}
				}

				// 빈그룹명이 나오는 경우
				if (!isGroup) {
					break;
				} else if (data.isEmpty()) { // 그룹명은 있으나 빈 데이터인경우 리턴
					return "";
				} else {
					groupDatas.offer(data);
				}
			}

			if (groupNames.size() == 0) {
				return "no data";
			}

			while(!groupNames.isEmpty()) {
				for (HashSet<String> groupData : groupDatas) {
					insertReceiveGroupInfo(groupNames.poll(), companyId, tenantId);
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("companyId", companyId);
					map.put("tenantId", tenantId);

					for (String deptId : groupData) {
						map.put("deptId", deptId);
						ezApprovalGAdminDAO.insertReceiveGroupSubWithExcel(map);
					}
					counts++;
				}
			}
		} catch (Exception e) {
			logger.debug("xlsxSetGroupWithExcel ERROR :" + e.getMessage());
			return "error";
		} finally {
			try {
				if (is != null) {
					is.close();
				}
			} catch (IOException e) {
				logger.debug("xlsxSetGroupWithExcel inputStream close ERROR :" + e.getMessage());
			}
		}

		result = String.valueOf(counts);
		logger.debug("xlsxSetGroupWithExcel ended, return :" + result);
		return result;
	}

	@Override
	public String xlsSetGroupWithExcel(String loginCookie, MultipartHttpServletRequest request) {
		logger.debug("xlsSetGroupWithExcel started");

		String result = "";
		int counts = 0;
		LoginVO user = commonUtil.userInfo(loginCookie);
		String companyId = user.getCompanyID();
		int tenantId = user.getTenantId();
		MultipartFile file = request.getFile("file");
		LinkedList<HashSet<String>> groupDatas = new LinkedList<>();
		LinkedList<String> groupNames = new LinkedList<>();
		boolean isGroup = false;
		InputStream is = null;

		try {
			is = file.getInputStream();
			HSSFWorkbook workbook = new HSSFWorkbook(is);
			HSSFSheet curSheet;
			HSSFRow curRow;
			HSSFCell curCell;
			ApprGAdminReceiveVO vo;
			String value;
			curSheet = workbook.getSheetAt(0);
			int physicalRows = curSheet.getPhysicalNumberOfRows();

			if (curSheet.getRow(0).getCell(7).getNumericCellValue() > 0) {
				return "";
			}

			for(int rowIndex=1; rowIndex < physicalRows; rowIndex++) {
				isGroup = false;
				curRow = curSheet.getRow(rowIndex);
				HashSet<String> data = new HashSet<>();

				if(curRow.getCell(1) != null) {

					for(int cellIndex=1;cellIndex<curRow.getPhysicalNumberOfCells(); cellIndex++) {
						curCell = curRow.getCell(cellIndex);
						// 조건부 서식 등에 의해 null값이 들어 올 수 있음.
						if (curCell == null) {
							break;
						}

						value = "";
						switch (curCell.getCellType()){
							case HSSFCell.CELL_TYPE_FORMULA:
							case HSSFCell.CELL_TYPE_BLANK:
								value = "";
								break;
							case HSSFCell.CELL_TYPE_NUMERIC:
								value = (int) curCell.getNumericCellValue()+"";
								break;
							case HSSFCell.CELL_TYPE_STRING:
								value = curCell.getStringCellValue()+"";
								break;
							case HSSFCell.CELL_TYPE_ERROR:
								value = curCell.getErrorCellValue()+"";
								break;
						}

						if ("".equals(value)) {
							break;
						} else if (cellIndex == 1) {
							groupNames.add(value);
							isGroup = true;
						} else {
							if (ezApprovalGAdminDAO.checkDeptId(value) < 1) {
								return "none deptId :" + value;
							}

							boolean dataInput = data.add(value);
							// data 중복일 경우
							if (!dataInput) {
								return "duplicated :" + value;
							}
						}
					}
				}

				// 빈그룹명이 나오는 경우
				if (!isGroup) {
					break;
				} else if (data.isEmpty()) { // 그룹명은 있으나 빈 데이터인경우 리턴
					return "";
				} else {
					groupDatas.offer(data);
				}
			}


			if (groupNames.size() == 0) {
				return "no data";
			}

			while(!groupNames.isEmpty()) {
				for (HashSet<String> groupData : groupDatas) {
					insertReceiveGroupInfo(groupNames.poll(), companyId, tenantId);
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("companyId", companyId);
					map.put("tenantId", tenantId);

					for (String deptId : groupData) {
						map.put("deptId", deptId);
						ezApprovalGAdminDAO.insertReceiveGroupSubWithExcel(map);
					}
					counts++;
				}
			}
		} catch (Exception e) {
			logger.debug("xlsSetGroupWithExcel ERROR :" + e.getMessage());
			return "error";
		} finally {
			try {
				if (is != null) {
					is.close();
				}
			} catch (IOException e) {
				logger.debug("xlsxSetGroupWithExcel inputStream close ERROR :" + e.getMessage());
			}
		}

		result = String.valueOf(counts);
		logger.debug("xlsSetGroupWithExcel ended, return :" + result);
		return result;
	}
	
	@Override
	public String getChaebunDeptList(String deptID, String companyID, LoginVO userInfo) throws Exception {
		logger.debug("getChaebunDeptList started");
		
		StringBuilder sb = new StringBuilder("<LISTVIEWDATA>");
		sb.append("<HEADERS><HEADER>");
		sb.append("<NAME>" + egovMessageSource.getMessage("ezOrgan.t70", userInfo.getLocale()) + "</NAME>");
		sb.append("</HEADER></HEADERS>");
		sb.append("<ROWS>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DEPTID", deptID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", userInfo.getTenantId());
		
		List<HashMap<String, Object>> chaebunDeptList = ezApprovalGAdminDAO.getChaebunDeptList(map);
		
		for(int i=0; i<chaebunDeptList.size(); i++) {
			HashMap<String, Object> chaebunDept = chaebunDeptList.get(i);
			sb.append("<ROW><CELL>");
			sb.append("<VALUE>" + commonUtil.cleanValue(chaebunDept.get("DEPTNAME").toString()) + "</VALUE>");
			sb.append("<DATA1>" + chaebunDept.get("DEPTID") + "</DATA1>");
			sb.append("<DATA2>" + companyID + "</DATA2>");
			sb.append("<DATA3>" + commonUtil.cleanValue(chaebunDept.get("DEPTNAME").toString()) + "</DATA3>");
			sb.append("</CELL></ROW>");
		}
		sb.append("</ROWS>");
        sb.append("</LISTVIEWDATA>");
		
		logger.debug("getChaebunDeptList ended");
		return sb.toString();
	}
	
	@Override
	public String setChaebunDeptList(Document doc, LoginVO userInfo) throws Exception {
		try {
			logger.debug("setChaebunDeptList started");
			Map<String, Object> map = new HashMap<String, Object>();

			String deptID = doc.getDocumentElement().getChildNodes().item(0).getChildNodes().item(0).getTextContent();
			String deptName = doc.getDocumentElement().getChildNodes().item(0).getChildNodes().item(1).getTextContent();
			String companyID = doc.getDocumentElement().getChildNodes().item(0).getChildNodes().item(2).getTextContent();
					
			map.put("v_TENANTID", userInfo.getTenantId());
			map.put("v_DEPTID", deptID);
			map.put("v_COMPANYID", companyID);
			
			NodeList nodes = doc.getDocumentElement().getChildNodes().item(1).getChildNodes();
			if(nodes.getLength() > 0) {
				String[] deptIds = new String[nodes.getLength()];
				for(int i=0; i<nodes.getLength(); i++) {
					deptIds[i] = nodes.item(i).getChildNodes().item(0).getTextContent();
				}
				map.put("v_DEPTIDS", deptIds);
				List<String> retVal = ezApprovalGAdminDAO.checkChaebunDeptList(map);
				
				if(retVal.size() > 0) {
					return retVal.toString();
				}
			}
			
			ezApprovalGAdminDAO.deleteChaebunDeptList(map);
			
			for(int i=0; i<nodes.getLength(); i++) {
				map.put("v_DEPTID", nodes.item(i).getChildNodes().item(0).getTextContent());
				map.put("v_DEPTNAME", nodes.item(i).getChildNodes().item(1).getTextContent());
				map.put("v_GRANTDEPTID", deptID);
				map.put("v_GRANTDEPTNAME", deptName);
				ezApprovalGAdminDAO.insertChaebunDeptList(map);
			}
		
			logger.debug("setChaebunDeptList ended");
			return "OK";
		} catch (Exception e) {
			logger.debug("setChaebunDeptList ERROR : " + e.getMessage());
			return "error";
		}
	}
	
	/* 2022-12-09 홍승비 - 전자결재G > 현재 년도 기준의 종료예정 기록물철을 리스트로 리턴하는 메서드 */
    public List<Map<String, Object>> getCabinetListByExpireYear(String currYear, String companyID, int tenantID) throws Exception {
    	logger.debug("getCabinetListByExpireYear started");
    	
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_YEAR", currYear);
		map.put("v_COMPANYID", companyID);	
		map.put("v_TENANTID", tenantID);
		
		logger.debug("map for getCabinetListByExpireYear   ::   " + map.toString());
		
		List<Map<String, Object>> resultCabList = ezApprovalGAdminDAO.getCabinetListByExpireYear(map);
		
		logger.debug("getCabinetListByExpireYear ended, resultCabList size = " + resultCabList.size());
		
		return resultCabList;
    }
    
    /* 2022-12-09 홍승비 - 전자결재G > 현재 년도 기준의 종료예정 기록물철을 원하는 생산연도의 기록물철로 삽입하는 메서드 */
	@Override
	public int cloneMultipleCabinets(String regYear, List<Map<String, Object>> cabinetList, String strLang, String companyID, int tenantID) throws Exception {
		logger.debug("registerCabinet started");
		
		int sucessCount = 0; // 일괄생성에 성공한 기록물철 개수
		
		for (Map<String, Object> map : cabinetList) {
			String orgCabinetClassNo = (map.get("v_OrgCabinetClassNo") != null) ? String.valueOf(map.get("v_OrgCabinetClassNo")).trim() : ""; // (원)기록물철 ID
			String deptCode = (map.get("v_ProcessDeptCode") != null) ? String.valueOf(map.get("v_ProcessDeptCode")).trim() : ""; // 생성부서
			String taskCode = (map.get("v_TaskCode") != null) ? String.valueOf(map.get("v_TaskCode")).trim() : ""; // 단위업무
			
			if (!deptCode.isEmpty() && !taskCode.isEmpty()) {
				// 기록물철의 일련번호를 단위업무별로 부여하기 (type1으로 001을 전달하여 생산연도 기준의 기록물철 일련번호를 가져옴)
				// 생산연도는 사용자가 입력한 regYear를 그대로 전달함 (이미 페이지단에서 회계연도 체크 완료됨)
				String regSN = formatSerialNum(getSerialNumRegYear("001", deptCode, taskCode, companyID, strLang, tenantID, regYear));
				
				// 생산연도는 사용자가 입력한 값을 그대로 받아 사용 (= 종료연도 동일)
				String produceY = regYear;
				
				// 기록물철 분류번호 : 처리과기관코드 + 단위업무코드 + 생산년도 + 등록일련번호
				String cabinetClassNO = deptCode + taskCode + produceY + regSN;
				
				try {
					map.put("v_CabinetClassNo", 	cabinetClassNO);
					map.put("v_ProductionYear", 	produceY);
					map.put("v_ExpirationYear", 	produceY);
					map.put("v_RegSerialNo", 		regSN);
					map.put("v_SYSDATE", 			commonUtil.getTodayUTCTime("")); // 등록일은 현재 시간 그대로 사용 (관리자단에서 임의로 생성했음을 알 수 있음)
					map.put("v_TENANTID", 			tenantID);
					
					logger.debug("map for insertRegCabinetCalss  ::  " + map.toString());
					
					// 기록물철 생성 (TBL_CABINETCLASS)
					ezApprovalGDAO.insertRegCabinetCalss(map);
					
					Map<String, Object> map1 = new HashMap<String, Object>();
					map1.put("v_CABINETCLASSNO",  	cabinetClassNO);
					map1.put("v_DeptMID",  			map.get("v_OwnerID"));
					map1.put("v_DeptMName",  		map.get("v_OwnerName"));
					map1.put("v_DeptMName2",		map.get("v_OwnerName2"));
					map1.put("v_TENANTID",  		tenantID);
					map1.put("v_SYSDATE",			commonUtil.getTodayUTCTime(""));
					map1.put("companyID", 			companyID);
					
					logger.debug("map for trigerTbCabinet  ::  " + map1.toString());
					
					// 기록물철 메인정보 생성 (TBL_CABINET)
					ezApprovalGDAO.trigerTbCabinet(map1);
					
					// 기록물철 권한정보 생성 (TBL_CABROLEINFO)
					ezApprovalGDAO.trigerTbCabRoleInfo(map1);
					
					Map<String, Object> map2 = new HashMap<String, Object>();
					map2.put("v_CABINETCLASSNO", 	orgCabinetClassNo);
					map2.put("v_TENANTID", 			tenantID);
					map2.put("v_COMPANYID", 		companyID);
					
					// 성공 기록물철 개수 증가
					sucessCount++;
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
					
					// 자동생성 중 오류난 기록물철은 기록물철 일련번호(TYPE1 = '001') 롤백
					rollbackSN("001", deptCode, taskCode, regSN, companyID, strLang, tenantID, produceY);
				}
			}
		}
		
		logger.debug("registerCabinet ended");
		return sucessCount;
	}
	
	/* 2022-12-09 홍승비 - 전자결재G > 기록물철 자동생성을 위해 오버라이드 없이 구현한 메서드 (기록물철 등록일련번호 가져오기)  */
	public String getSerialNumRegYear(String snType1, String snType2, String snType3, String companyID, String langType, int tenantID, String regYear) throws Exception {
		logger.debug("getSerialNum started.");
		

		String accountYear = regYear;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("iv_Type1", snType1);
		map.put("iv_Type2", snType2);
		map.put("iv_Type3", snType3);
		map.put("v_AccountYear", accountYear);
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		map.put("v_SYSDATE",commonUtil.getTodayUTCTime(""));
		
		String result = ezApprovalGDAO.spGetSerialNo(map);
		map.put("v_CurSN", result);
		
		// 생산연도에 대해 기록물철의 일련번호가 완전히 없으면 신규 레코드 생성
		if (result == null) {
		    String curSn = "1";
		    
            map.put("v_CurSN", curSn);
    
            ezApprovalGDAO.insertSerialNo(map);
            result = curSn;
		}
		
		int rollBackFlag =  ezApprovalGDAO.rollBackFlag(map);
		
		if (rollBackFlag == 1) {
			logger.debug("delete");
			 ezApprovalGDAO.deleteSerialNo(map);
		} else {
			logger.debug("update");
			ezApprovalGDAO.updateSerialNo(map);
			result = Integer.toString((Integer.parseInt(result)));
		}
		
		logger.debug("deptID, SerialNum = " + snType2 + ", " + result);
		logger.debug("getSerialNum ended.");
		
		return String.valueOf(result);
	}
	
	/* 2022-12-09 홍승비 - 전자결재G > 기록물철 자동생성을 위해 오버라이드 없이 구현한 메서드 (일련번호 6자리 포맷) */
	private String formatSerialNum(String strValue) throws Exception {
		return getNDigitNum(strValue, 6);
	}
	
	public String getNDigitNum(String strValue, int numDigits) {
		int valueLen = strValue.length();
		String tempDigit = "";
		
		while (valueLen < numDigits) {
			tempDigit = "0" + "" + tempDigit;
			valueLen++;
		}
		
		return tempDigit + strValue;
	}
	
	/* 2022-12-09 홍승비 - 전자결재G > 기록물철 자동생성을 위해 오버라이드 없이 구현한 메서드 (일련번호 serialNumber 롤백) */
	private String rollbackSN(String snType1, String snType2, String snType3, String toSN, String companyID, String strLang, int tenantID, String regYear) throws Exception {
		logger.debug("rollbackSN started");
		
		String accountYear = regYear;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("iv_Type1", snType1);
		map.put("iv_Type2", snType2);
		map.put("iv_Type3", snType3);
		map.put("v_CurSN", toSN);
		map.put("v_AccountYear", accountYear);
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));
		
		/* 2022-09-21 홍승비 - 정상적인 문서번호 채번 뒤의 중복삽입 오류가 발생한 경우, 기존 문서번호를 롤백하지 않도록 카운트 체크 */
		int noRollbackCnt = ezApprovalGDAO.getNoRollbackRecordCnt(map);
		if (noRollbackCnt <= 0) { // 롤백하지 않아야 하는 레코드가 없을때만 롤백
			ezApprovalGDAO.spRollbackSN(map);
		}
		
		logger.debug("rollbackSN ended, noRollbackCnt = " + noRollbackCnt);

		return "TRUE";
	}

	public int getTaskListCount(String deptCode, String companyID, int tenantID, String title, String code, String flag) throws Exception {
		logger.debug("getTaskListCount started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DEPTCODE", deptCode);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		if (flag.equals("1")) {
			if (!title.isEmpty()) {
				map.put("title", title);
			}
			if (!code.isEmpty()) {
				map.put("code", code);
			}
		}
	
		int result = ezApprovalGAdminDAO.getTaskListCount(map);

		logger.debug("getTaskListCount ended.");
		return result;
	}

	@Override
	public ArrayList<String> getIronListYear(String companyID, int tenantID) throws Exception {
		return ezApprovalGAdminDAO.getIronListYear(companyID, tenantID);
	}

	/* 2024-07-16 기민혁 - 전자결재 > 양식함 이동 */
	@Override
	public String contMove(String companyID, String contID, String selContID, String parentContID, int tenantID) throws Exception {

		boolean Loop = true;
		ArrayList<String> checkList = new ArrayList<String>();
		ArrayList<String> resultCheckList = new ArrayList<String>();
		checkList.add(contID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("contID", contID);
		map.put("selContID", selContID);
		map.put("parentContID", parentContID);
		map.put("tenantID", tenantID);
		map.put("checkList", checkList);

		logger.debug("contMove started. contID = " + contID + " || selContID = " + selContID + " || parentContID = " + parentContID);

		while (Loop) {
			List<String> list = ezApprovalGAdminDAO.checkContList(map);

			if (list.size() > 0) {
				checkList.clear();
				for (String re : list) {
					checkList.add(re);
					resultCheckList.add(re);
				}
				map.put("checkList", checkList);
			}else{
				Loop = false;
			}
		}
		
		if(resultCheckList.contains(selContID)){
			return "CHILD";
		} else {
			ezApprovalGAdminDAO.contMove(map);	
		}
		
		return "OK";
	}

	/* 2024-07-17 기민혁 - 전자결재 > 양식함 순서조정 리스트 호출  */
	@Override
	public List<ApprGFormVO> getSNFContList(String contID, String companyID, int tenantID) throws Exception {
		logger.debug("getSNFContList started");

		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("contID", contID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprGFormVO> contList = ezApprovalGAdminDAO.getSNFContList(map);

		logger.debug("getSNFContList ended");
		return contList;
	}

	/* 2024-07-17 기민혁 - 전자결재 > 양식함 순서조정 실행 함수  */
	@Override
	public String moveContSN(String contID, String groupList, String companyID, int tenantID) throws Exception {
		logger.debug("moveContSN started.");

		int index = 0;

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("contID", contID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);

		for (String targetContID : groupList.split(";")) {
			map.put("targetContID", targetContID);
			map.put("order", ++index);

			logger.debug("index=" + index);

			ezApprovalGAdminDAO.setContSN(map);
		}

		logger.debug("moveContSN ended.");

		return "OK";

	}
}
