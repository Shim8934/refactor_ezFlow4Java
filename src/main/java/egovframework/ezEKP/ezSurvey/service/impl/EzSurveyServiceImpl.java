package egovframework.ezEKP.ezSurvey.service.impl;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;
import java.util.stream.Collectors;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezSurvey.dao.EzSurveyDAO;
import egovframework.ezEKP.ezSurvey.service.EzSurveyService;
import egovframework.ezEKP.ezSurvey.vo.AttachVO;
import egovframework.ezEKP.ezSurvey.vo.OptionVO;
import egovframework.ezEKP.ezSurvey.vo.QuestionVO;
import egovframework.ezEKP.ezSurvey.vo.SimpleDeptVO;
import egovframework.ezEKP.ezSurvey.vo.SimpleUserVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyGeneralVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyItemSearchVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyParticipantVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service
public class EzSurveyServiceImpl extends EgovFileMngUtil implements EzSurveyService {
	private static final Logger logger = LoggerFactory.getLogger(EzSurveyServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name = "EzSurveyDAO")
	private EzSurveyDAO ezSurveyDAO;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Override
	public List<SimpleDeptVO> getAllSubDepts(String companyId, int level, String primary, int tenantId) throws Exception {
		List<SimpleDeptVO> deptList = getAllSimpleSubDepts(companyId, level, primary, tenantId);
		return deptList;
	}
	
	@Override
	public String getDeptPath(String deptId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("tenantId",   tenantId);
		return ezSurveyDAO.getDeptPath(map);
	}
	
	@Override
	public SimpleDeptVO getSimpleCompany(String deptId, int level, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("primary",    primary);
		map.put("level",      level);
		map.put("tenantId",   tenantId);
		
		return ezSurveyDAO.getSimpleCompany(map);
	}
	
	@Override
	public void getAllDepts(SimpleDeptVO sDept, String[] path, String primary, int tenantId, int order, int level) throws Exception {
		if (sDept.getHasSub().equals("1")) {
			List<SimpleDeptVO> listSubSimpleDepts = getAllSimpleSubDepts(sDept.getDeptId(), level, primary, tenantId);
			sDept.setSubDepts(listSubSimpleDepts);
			
			for (SimpleDeptVO subDept: listSubSimpleDepts) {
				if (order < path.length && subDept.getDeptId().equals(path[order])) {
					getAllDepts(subDept, path, primary, tenantId, order + 1, level + 1);
				}
			}
		}
	}
	
	private List<SimpleDeptVO> getAllSimpleSubDepts(String deptId, int level, String primary, int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("primary",    primary);
		map.put("level",      level);
		map.put("tenantId",   tenantId);
		
		return ezSurveyDAO.getAllSimpleSubDepts(map);
	}
	
	@Override
	public int getTotalDeptMembers(String deptId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptId",   deptId);
		map.put("tenantId", tenantId);
		
		return ezSurveyDAO.getTotalDeptMembers(map);
	}
	
	@Override
	public List<SimpleUserVO> getDeptMemberList(String deptId, String primary, int startPoint, int listCount, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("startPoint", startPoint);
		map.put("listCount",  listCount);
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		
		return ezSurveyDAO.getDeptMemberList(map);
	}
	
	@Override
	public int getTotalSearchMembers(String sqlQuery, String srchValue, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("srchOption", sqlQuery);
		map.put("srchValue",  srchValue);
		map.put("tenantId",   tenantId);
		
		return ezSurveyDAO.getTotalSearchMembers(map);
	}
	
	@Override
	public List<SimpleUserVO> getSearchMemberList(String primary, int startPoint, int listCount, String srchOption, String srchValue, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("startPoint", startPoint);
		map.put("listCount",  listCount);
		map.put("srchOption", srchOption);
		map.put("srchValue",  srchValue);
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		
		return ezSurveyDAO.getSearchMemberList(map);
	}
	
	@Override
	public SurveyGeneralVO getUserPreviewConfig(String userId, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("userId",    userId);
		map.put("tenantId",  tenantId);
		
		return ezSurveyDAO.getUserPreviewConfig(map);
	}
	
	@Override
	public void saveUserConfig(String prevMode, int listCount, int contentWPrev, int contentHPrev, String userId, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId",    companyId);
		map.put("userId",       userId);
		map.put("tenantId",     tenantId);
		map.put("prevMode",     prevMode);
		map.put("listCount",    listCount);
		map.put("contentWPrev", contentWPrev);
		map.put("contentHPrev", contentHPrev);
		
		ezSurveyDAO.saveUserConfig(map);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject checkPermission(List<Integer> surveyList, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		String userId          = userInfo.getId();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("surveyList", surveyList);
		map.put("userId"    , userId);
		map.put("tenantId"  , userInfo.getTenantId());
		map.put("companyId" , userInfo.getCompanyID());
		
		List<SurveyVO> listSurvey  = ezSurveyDAO.getSurveyListForPermission(map);
		
		if (listSurvey == null || listSurvey.size() == 0) {
			result.put("code", 1);
			result.put("reason", 1);
			return result;
		}
		
		List<SurveyVO> otherSurvey = listSurvey.stream().filter(i -> !i.getCreatorId().equals(userId)).collect(Collectors.toList());
		
		if (otherSurvey.size() == 0) {
			result.put("code", 0);
			return result;
		}
		
		List<Long> listOtherSurveyId  = otherSurvey.stream().map(SurveyVO::getSurveyId).collect(Collectors.toList());
		List<Long> listReceivedSurvey = getUserReceivedSurveyList(userInfo);
		
		if (listReceivedSurvey.containsAll(listOtherSurveyId)) {
			result.put("code", 0);
		}
		else {
			result.put("code", 1);
		}
		
		return result;
	}
	
	@Override
	public String saveUploadFile(List<MultipartFile> multiFileLists, JSONArray nameArray, String realPath, int tenantId) throws Exception {
		String pFileName   = (String)((JSONObject)nameArray.get(0)).get("originalFilename");
		String cabinetPath = getSurveyDirPath(tenantId);
		String pDirPath    = realPath + cabinetPath;
		
		File file = new File(pDirPath);
		
		if (!file.exists()) {
			file.mkdir();
		}
		
		int dotPos     = pFileName.lastIndexOf(".");
		String extend  = dotPos == -1 ? ".none" : pFileName.substring(dotPos + 1);
		String newName = UUID.randomUUID().toString() + "." + extend;
		writeUploadedFile(multiFileLists.get(0), newName, pDirPath);
		
		return cabinetPath + newName;
	}
	
	@Override
	public void deleteAttachFile(String filePath, String realPath, int tenantId) throws Exception {
		String pDirPath = realPath + filePath;
		File file       = new File(pDirPath);
		
		if (file.exists()) {
			try {
				file.delete();
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	@Override
	public void getDownloadedFile(String fileName, String filePath, String realPath, String userAgent, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String _fileName = fileName;
		_fileName        = CommonUtil.getEncodedFileNameForDownload(userAgent, _fileName);
		File file        = new File(realPath + filePath);
		
		if (!file.exists()) {
			throw new FileNotFoundException(fileName);
		}
		
		if (!file.isFile()) {
			throw new FileNotFoundException(fileName);
		}
		
		BufferedInputStream in = null;
		
		try {
			in              = new BufferedInputStream(new FileInputStream(file));
			String mimetype = "application/octet-stream";
			
			response.setBufferSize(BUFF_SIZE);
			response.setContentType(mimetype);
			response.setHeader("Content-Disposition", "attachment; filename=\"" + _fileName + "\"");
			response.setContentLength((int)file.length());
			
			FileCopyUtils.copy(in, response.getOutputStream());
		}
		catch (Exception e) {
			throw e;
		}
		finally {
			if (in != null) {
				try {
					in.close();
				}
				catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
					throw ignore;
				}
			}
		}
		
		response.getOutputStream().flush();
		response.getOutputStream().close();
	}
	
	private String getSurveyDirPath(int tenantId) {
		return commonUtil.getUploadPath("upload_survey.ROOT", tenantId) + commonUtil.separator;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public synchronized JSONObject saveSurveyItem(String realPath, JSONArray questions, String title, String purpose, String startDate, String endDate, int publicFlag, int anonymousFlag, int multipleFlag, int userFlag, int publicDays, JSONArray attchList, JSONArray users, int useStatus, LoginVO userInfo) throws Exception {
		JSONObject result          = new JSONObject();
		int tenantId               = userInfo.getTenantId();
		String companyId           = userInfo.getCompanyID();
		String userId              = userInfo.getId();
		SurveyVO survey            = new SurveyVO();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(new Date()), userInfo.getOffset(), true);
		Map<String,Object> map     = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId" , tenantId);
		long maxSurveyId           = ezSurveyDAO.getMaxSurveyId(map);
		long maxQuestionId         = ezSurveyDAO.getMaxQuestionId(map);
		long maxOptionId           = ezSurveyDAO.getMaxOptionId(map);
		
		survey.setTenantId(tenantId);
		survey.setCompanyId(companyId);
		survey.setCreatorId(userId);
		survey.setUpdateUser(userId);
		survey.setCreatorName1(userInfo.getDisplayName1());
		survey.setCreatorName2(userInfo.getDisplayName2());
		survey.setMultiAnswerFlag(multipleFlag);
		survey.setParitipateFlag(userFlag);
		survey.setResultPublicFlag(publicFlag);
		survey.setAnonymousFlag(anonymousFlag);
		survey.setTittle(title);
		survey.setPurpose(purpose);
		survey.setCreateDate(timeUTC);
		survey.setUpdateDate(timeUTC);
		survey.setUseStatus(useStatus);
		survey.setStartDate(startDate);
		survey.setEndDate(endDate);
		
		if (publicFlag == 1) {
			survey.setOpenDays(publicDays);
		}
		
		//Save questions
		for (int i = 0; i < questions.size(); i++, maxQuestionId++) {
			JSONObject questionObj = (JSONObject)questions.get(i);
			int requiredFlag       = questionObj.get("required").toString().equals("Y") ? 1 : 0;
			int questionType       = ((Long)questionObj.get("type")).intValue();
			JSONObject questionAtt = (JSONObject)questionObj.get("attach");
			JSONArray options      = (JSONArray)questionObj.get("option");
			
			if (options == null || options.size() == 0) {
				result.put("status", "error");
				result.put("code", 1);
				return result;
			}
			
			for (int j = 0; j < options.size(); j++, maxOptionId++) {
				JSONObject optionObj = (JSONObject)options.get(j);
				JSONObject optionAtt = (JSONObject)optionObj.get("attach");
				String optionContent = optionObj.get("content").toString();
				int optionLevel      = optionObj.get("level")     != null ? ((Long)optionObj.get("level")).intValue()     : 0;
				int otherFlag        = optionObj.get("otherFlag") != null ? ((Long)optionObj.get("otherFlag")).intValue() : 0;
				int logicNum         = optionObj.get("logic")     != null ? ((Long)optionObj.get("logic")).intValue()     : -1;
				OptionVO option      = new OptionVO();
				option.setQuestionId(maxQuestionId);
				option.setSurveyId(maxSurveyId);
				option.setQuestionType(questionType);
				option.setContent(optionContent);
				option.setLevels(optionLevel);
				option.setOtherFlag(otherFlag);
				option.setCompanyId(companyId);
				option.setTenantId(tenantId);
				
				if (logicNum != -1) {
					option.setLogicNum(logicNum);
				}
				
				if (questionType == 3 || questionType == 4) {
					int rowLevel = ((Long)optionObj.get("rowLevel")).intValue();
					int colLevel = ((Long)optionObj.get("colLevel")).intValue();
					option.setRowLevel(rowLevel);
					option.setColumnLevel(colLevel);
				}
				
				//Save option attach file
				if (optionAtt != null) {
					saveAttachFile(realPath, optionAtt, maxOptionId, companyId, tenantId, "option");
				}
				
				//Save option
				ezSurveyDAO.saveOptionItem(option);
			}
			
			String questionTitle = questionObj.get("content").toString();
			int questionLogic    = questionObj.get("logic") != null ? ((Long)questionObj.get("logic")).intValue() : 0;
			int questionOrder    = ((Long)questionObj.get("id")).intValue();
			QuestionVO question  = new QuestionVO();
			
			question.setSurveyId(maxSurveyId);
			question.setTenantId(tenantId);
			question.setCompanyId(companyId);
			question.setTittle(questionTitle);
			question.setQuestionType(questionType);
			question.setLevels(questionOrder);
			question.setUseStatus(1);
			question.setLogicFlag(questionLogic);
			question.setRequiredFlag(requiredFlag);
			
			if (questionType == 7) {
				if (questionObj.get("logicPoint") != null && questionLogic == 1) {
					question.setSliderLogicPoint(((Long)questionObj.get("logicPoint")).intValue());
				}
			}
			
			//Save question attach file
			if (questionAtt != null) {
				saveAttachFile(realPath, questionAtt, maxQuestionId, companyId, tenantId, "question");
			}
			
			//Save question
			ezSurveyDAO.saveQuestionItem(question);
		}
		
		//Save survey attach list
		if (attchList != null && attchList.size() > 0) {
			for (int i = 0; i < attchList.size(); i++) {
				JSONObject surveyAtt = (JSONObject)attchList.get(i);
				saveAttachFile(realPath, surveyAtt, maxSurveyId, companyId, tenantId, "survey");
			}
		}
		
		//Save survey users
		if (userFlag == 1) {
			for (int i = 0; i < users.size(); i++) {
				JSONObject userObj             = (JSONObject)users.get(i);
				SurveyParticipantVO surveyUser = new SurveyParticipantVO();
				surveyUser.setSurveyId(maxSurveyId);
				surveyUser.setCompanyId(companyId);
				surveyUser.setTenantId(tenantId);
				surveyUser.setUserId(userObj.get("userId").toString());
				surveyUser.setDeptId(userObj.get("deptId").toString());
				surveyUser.setUserType(userObj.get("userType").toString());
				surveyUser.setUserName1(userObj.get("userName1").toString());
				surveyUser.setUserName2(userObj.get("userName2").toString());
				surveyUser.setDeptName1(userObj.get("deptName1").toString());
				surveyUser.setDeptName2(userObj.get("deptName2").toString());
				surveyUser.setEmail(userObj.get("email").toString());
				
				ezSurveyDAO.saveSurveyUsers(surveyUser);
			}
		}
		
		//Save survey
		ezSurveyDAO.saveSurveyItem(survey);
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}

	private synchronized void saveAttachFile(String realPath, JSONObject attachObj, long targetId, String companyId, int tenantId, String targetType) {
		String fileName      = attachObj.get("fname").toString();
		String filePath      = attachObj.get("fpath").toString();
		File attFile         = new File(realPath + filePath);
		long fileSize        = attFile.length();
		AttachVO attach      = new AttachVO();
		
		attach.setCompanyId(companyId);
		attach.setTenantId(tenantId);
		attach.setTargetId(targetId);
		attach.setTargetType(targetType);
		attach.setFilePath(filePath);
		attach.setFileSize(fileSize);
		attach.setFileName(fileName);
		
		//Save attach
		ezSurveyDAO.saveAttachItem(attach);
	}

	@Override
	public JSONObject getItemsBySearching(String pageMode, int currentPage, int listCntSize, String title, String creatorName, String startDate, String endDate, String sqlQuery, String srchMode, String srchOption, String order, String column, LoginVO userInfo) throws Exception {
		JSONObject result     = new JSONObject();
		String userId         = userInfo.getId();
		int tenantId          = userInfo.getTenantId();
		String companyId      = userInfo.getCompanyID();
		String primary        = userInfo.getPrimary();
		String offset         = userInfo.getOffset();
		String offsetMinute   = commonUtil.getMinuteUTC(offset);
		int startPoint        = 0;
		int totalItems        = 0;
		int totalPages        = 0;
		
		if (!column.equals("") && !order.equals("")) {
			switch(column) {
				case "it": sqlQuery = "item_type "   + order; break;
				case "tt": sqlQuery = "title "       + order; break;
				case "un": sqlQuery = primary.equals("1") ? "creator_name1 " + order : "creator_name2 " + order; break;
				case "cd": sqlQuery = "create_date " + order; break;
				case "is": sqlQuery = "item_size "   + order; break;
				default  : sqlQuery = "item_type "   + order; break;
			}
		}
		
		if (!startDate.equals("")) {
			String startDateTmp = startDate + " 00:00:00";
			String endDateTmp   = endDate + " 23:59:59";
			startDate           = commonUtil.getDateStringInUTC(startDateTmp, offset, true);
			endDate             = commonUtil.getDateStringInUTC(endDateTmp  , offset, true);
		}
		
		title       = title.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
		creatorName = creatorName.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
		
		SurveyItemSearchVO searchVO = new SurveyItemSearchVO(pageMode, listCntSize, tenantId, userId, primary, offsetMinute, title, creatorName, startDate, endDate, sqlQuery, srchMode, srchOption);
		List<SurveyVO> itemList     = new ArrayList<>();
		
		if (pageMode.equals("processing") || pageMode.equals("finish")) {
			List<Long> listReceivedSurvey = getUserReceivedSurveyList(userInfo);
			SimpleDateFormat formatter    = new SimpleDateFormat("yyyy-MM-dd");
			String timeUTC                = commonUtil.getDateStringInUTC(formatter.format(new Date()), offset, true);
			searchVO.setSurveyIds(listReceivedSurvey);
			searchVO.setToday(timeUTC);
		}
		
		totalItems  = ezSurveyDAO.getTotalReceivedSurveyItemsCnt(searchVO);
		totalPages  = (totalItems + listCntSize - 1) / listCntSize;
		currentPage = currentPage > totalPages ? totalPages : currentPage;
		currentPage = currentPage == 0         ? 1          : currentPage;
		startPoint  = (currentPage - 1) * listCntSize;
		searchVO.setStartPoint(startPoint);
		itemList    = ezSurveyDAO.getTotalReceivedSurveyItems(searchVO);
		
		/*CabinetItemSearchVO searchVO = new CabinetItemSearchVO(Integer.parseInt(cabinetId), listCntSize, tenantId, userId, primary, offsetMinute, title, summary, creatorName, startDate, endDate, sqlQuery, srchMode, srchOption);
		List<CabinetItemVO> itemList = new ArrayList<>();
		
		if (srchMode.equals("2") && recursive.equals("1")) {
			CabinetVO cabinet = getCabinetById(cabinetId, userInfo.getTenantId());
			
			if (!cabinet.getCreatorId().equals(userId)) {
				String cabinetPath    = cabinet.getCabinetPath();
				cabinetPath           = cabinetPath.substring(1, cabinetPath.length() - 1);
				List<Integer> nodeIds = Arrays.asList(cabinetPath.split("\\|")).stream().map(Integer::parseInt).collect(Collectors.toList());
				nodeIds.remove(nodeIds.size() - 1);
				Map<String,Object> map = new HashMap<String, Object>();
				map.put("cabinetId", cabinetId);
				map.put("tenantId",  tenantId);
				map.put("sharerId",  cabinet.getCreatorId());
				map.put("sharedId",  userId);
				map.put("listNodes", nodeIds);
				
				//Get user dept list
				map.put("deptId",    userInfo.getDeptID());
				map.put("companyId", userInfo.getCompanyID());
				map.put("userId",    userId);
				List<String> userDeptList = ezCabinetDAO.getUserDepartmentIdList(map);
				map.put("deptList", userDeptList);
				
				List<CabinetShareVO> listShared = ezCabinetDAO.checkSubPermission(map);
				
				if (listShared != null && listShared.size() > 0) {
					searchVO.setCabinetPath(cabinet.getCabinetPath());
					subSearchflag = true;
				}
			}
			else {
				searchVO.setCabinetPath(cabinet.getCabinetPath());
				subSearchflag = true;
			}
		}
		
		if (subSearchflag == true) {
			totalItems  = getTotalItemsRecursive(searchVO);
			totalPages  = (totalItems + listCntSize - 1) / listCntSize;
			currentPage = currentPage > totalPages ? totalPages : currentPage;
			currentPage = currentPage == 0         ? 1          : currentPage;
			startPoint  = (currentPage - 1) * listCntSize;
			searchVO.setStartPoint(startPoint);
			itemList    = getItemsRecursive(searchVO);
		}
		else {
			totalItems  = getTotalItems(searchVO);
			totalPages  = (totalItems + listCntSize - 1) / listCntSize;
			currentPage = currentPage > totalPages ? totalPages : currentPage;
			currentPage = currentPage == 0         ? 1          : currentPage;
			startPoint  = (currentPage - 1) * listCntSize;
			searchVO.setStartPoint(startPoint);
			itemList    = getItems(searchVO);
		}*/
		
		result.put("itemList",    itemList);
		result.put("totalPages",  totalPages);
		result.put("totalRows",   totalItems);
		result.put("currentPage", currentPage);
		result.put("status", "ok");
		result.put("code", 0);
		
		return result;
	}

	private List<Long> getUserReceivedSurveyList(LoginVO userInfo) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId",  userInfo.getTenantId());
		map.put("deptId",    userInfo.getDeptID());
		map.put("companyId", userInfo.getCompanyID());
		map.put("userId",    userInfo.getId());
		List<String> userDeptList = ezSurveyDAO.getUserDepartmentIdList(map);
		map.put("deptList", userDeptList);
		List<Long> result = ezSurveyDAO.getReceivedSurveyList(map);
		
		return result != null ? result : new ArrayList<>();
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}