package egovframework.ezEKP.ezCabinet.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import javax.annotation.Resource;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCabinet.dao.EzCabinetAdminDAO;
import egovframework.ezEKP.ezCabinet.dao.EzCabinetDAO;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService_m;
import egovframework.ezEKP.ezCabinet.vo.CabinetAttachFileVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetColumnVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service
public class EzCabinetServiceImpl_m implements EzCabinetService_m {
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetServiceImpl_m.class);
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzCabinetServiceImpl_h ezCabinetService_h;
	
	@Resource(name = "EzCabinetDAO")
	private EzCabinetDAO ezCabinetDAO;
	
	@Resource(name = "EzCabinetAdminDAO")
	private EzCabinetAdminDAO ezCabinetAdminDAO;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveApprovalItem(String realPath, int cabinetId, String approvalContent, String mode, String doctitle, String summary, String lstAttachLink, String otherAttachLk, Locale locale, LoginVO userInfo)throws Exception {
		JSONObject result      = new JSONObject();
		int tenantId           = userInfo.getTenantId();
		String companyId       = userInfo.getCompanyID();
		JSONParser jp          = new JSONParser();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		//Get itemId
		int itemId = ezCabinetDAO.getMaxItem(map) + 1;
		
		//Save attach files
		if (!lstAttachLink.equals("")) {
			JSONArray attachList = (JSONArray) jp.parse(lstAttachLink);
			result               = ezCabinetService_h.saveListAttachFiles(attachList, itemId, realPath, "", "", locale, userInfo);
			
			if (!result.get("status").equals("ok")) {
				return result;
			}
		}
		
		//Save other files
		if (!otherAttachLk.equals("")) {
			JSONArray otherList = (JSONArray) jp.parse(otherAttachLk);
			int totalOther      = otherList.size();
			int attachId        = ezCabinetDAO.getMaxAttachId(map) + 1;
			for (int i = 0; i < totalOther; i++, attachId++) {
				JSONObject attachInf           = (JSONObject) otherList.get(i);
				String fileName                = attachInf.get("fileName").toString();
				String filePath                = attachInf.get("filePath").toString();
				CabinetAttachFileVO attachFile = new CabinetAttachFileVO(attachId, itemId, filePath, fileName, 0, "", companyId, tenantId);
				saveAttachFile(attachFile);
			}
		}
		
		//Save Item
		int moduleType = 2; //Approval module
		ezCabinetService_h.addRelatedItem(itemId, moduleType, cabinetId, doctitle, summary, approvalContent, mode, userInfo);
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	private synchronized void saveAttachFile(CabinetAttachFileVO attachFile) {
		ezCabinetDAO.saveAttachFile(attachFile);
	}
	
	private synchronized void saveItem(CabinetItemVO itemVO) {
		ezCabinetDAO.saveItem(itemVO);
	}
	
	@Override
	public void saveItem(int cabinetId, JSONArray attacheFiles, JSONArray relatedFiles, String doctitle, String realPath, LoginVO userInfo) throws Exception {
		String companyId           = userInfo.getCompanyID();
		String userId              = userInfo.getId();
		int tenantId               = userInfo.getTenantId();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
		Map<String,Object> map     = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		//Save Approval item
		int itemId           = ezCabinetDAO.getMaxItem(map) + 1;
		CabinetItemVO itemVO = new CabinetItemVO();
		itemVO.setCabinetId(cabinetId);
		itemVO.setItemId(itemId);
		itemVO.setItemType(0);
		itemVO.setTitle(doctitle);
		itemVO.setCreatorId(userId);
		itemVO.setCreatorName1(userInfo.getDisplayName1());
		itemVO.setCreatorName2(userInfo.getDisplayName2());
		itemVO.setDepartmentId(userInfo.getDeptID());
		itemVO.setDepartmentName1(userInfo.getDeptName1());
		itemVO.setDepartmentName2(userInfo.getDeptName2());
		itemVO.setContentPath(null);
		itemVO.setCreatedDate(timeUTC);
		itemVO.setUpdatedDate(timeUTC);
		itemVO.setUseStatus(1);
		itemVO.setUpdateId(userId);
		itemVO.setDeleterId(null);
		itemVO.setCompanyId(companyId);
		itemVO.setTenantId(tenantId);
		
		saveItem(itemVO);
	}
	
	private synchronized void saveAllColumns(List<CabinetColumnVO> listColm) {
		for (CabinetColumnVO column : listColm) {
			ezCabinetDAO.saveRelatedColumn(column);
		}
	}
	
	private CabinetColumnVO createNewRelatedColumn(String columnId, int itemId, String messageName, String columnValue, String companyId, int tenantId) {
		String columnName1 = egovMessageSource.getMessage(messageName, new Locale(config.getProperty("config.cabinetPrimary")));
		String columnName2 = egovMessageSource.getMessage(messageName, new Locale(config.getProperty("config.cabinetPrimary")));
		return new CabinetColumnVO(columnId, itemId, columnName1, columnName2, columnValue, companyId, tenantId);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveJournalItem(String realPath, int cabinetId, String title, String summary, String mode, String journalTitle, String createDate, String journalWriter, String journalType, String journalContent, String formName, String attach, Locale locale, LoginVO userInfo) throws Exception {
		JSONObject result          = new JSONObject();
		int tenantId               = userInfo.getTenantId();
		String companyId           = userInfo.getCompanyID();
		JSONParser jp              = new JSONParser();
		Map<String,Object> map     = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		//Get itemId
		int itemId = ezCabinetDAO.getMaxItem(map) + 1;
		
		logger.debug("real path: " + realPath );
		//Save attach files
		if (!attach.equals("")) {
			JSONArray attachList = (JSONArray) jp.parse(attach);
			result               = ezCabinetService_h.saveListAttachFiles(attachList, itemId, realPath, "upload_journal.ROOT", "uploadFile", locale, userInfo);
			if (!result.get("status").equals("ok")) {
				return result;
			}
		}
		
		//Save Item
		int moduleType = 9; //Journal module
		ezCabinetService_h.addRelatedItem(itemId, moduleType, cabinetId, title, summary, journalContent, mode, userInfo);
		
		//Save journal columns information
		List<CabinetColumnVO> listColm = new ArrayList<>();
		listColm.add(createNewRelatedColumn("jourTitle" , itemId, "ezCabinet.t62", journalTitle , companyId, tenantId));
		listColm.add(createNewRelatedColumn("jourWriter", itemId, "ezJournal.t34", journalWriter, companyId, tenantId));
		listColm.add(createNewRelatedColumn("jourDate"  , itemId, "ezJournal.t35", createDate   , companyId, tenantId));
		listColm.add(createNewRelatedColumn("formname"  , itemId, "ezJournal.t22", formName     , companyId, tenantId));
		listColm.add(createNewRelatedColumn("jourType"  , itemId, "ezJournal.t12", journalType  , companyId, tenantId));
		
		saveAllColumns(listColm);
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
}
