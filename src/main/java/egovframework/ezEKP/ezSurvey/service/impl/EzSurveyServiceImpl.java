package egovframework.ezEKP.ezSurvey.service.impl;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezSurvey.vo.ResultViewPermissionVO;
import org.apache.commons.io.FileUtils;
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
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.task.EzEmailAsync;
import egovframework.ezEKP.ezNotification.service.EzNotificationService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezSurvey.dao.EzSurveyDAO;
import egovframework.ezEKP.ezSurvey.service.EzSurveyService;
import egovframework.ezEKP.ezSurvey.vo.AttachVO;
import egovframework.ezEKP.ezSurvey.vo.OptionVO;
import egovframework.ezEKP.ezSurvey.vo.QuestionVO;
import egovframework.ezEKP.ezSurvey.vo.RespondentVO;
import egovframework.ezEKP.ezSurvey.vo.ResponseVO;
import egovframework.ezEKP.ezSurvey.vo.SimpleDeptVO;
import egovframework.ezEKP.ezSurvey.vo.SimpleUserVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyGeneralVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyItemSearchVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyParticipantVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzSurveyService")
public class EzSurveyServiceImpl extends EgovFileMngUtil implements EzSurveyService {
	private static final Logger logger = LoggerFactory.getLogger(EzSurveyServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzSurveyDAO")
	private EzSurveyDAO ezSurveyDAO;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name = "EzEmailService")
	private EzEmailService ezEmailService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="EzNotificationService")
	private EzNotificationService ezNotificationService;
	
	@Autowired
	private EzEmailAsync ezEmailAsync;
	
	@Resource(name = "jspw")
    private String jspw;
	
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
	public List<SimpleUserVO> getDeptMemberList(String deptId, List<String> deptList, String primary, int startPoint, int listCount, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		if (deptId != null) {
			map.put("deptId", deptId);
		}
		else {
			map.put("deptList", deptList);
		}
		
		map.put("startPoint", startPoint);
		map.put("listCount",  listCount);
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		
		return ezSurveyDAO.getDeptMemberList(map);
	}
	
	/*
	@Override
	public int getTotalSearchMembers(String sqlQuery, String srchValue, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("srchOption", sqlQuery);
		map.put("srchValue",  srchValue);
		map.put("tenantId",   tenantId);
		
		return ezSurveyDAO.getTotalSearchMembers(map);
	}*/
	/*
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
	}*/

	@Override
	public List<SimpleUserVO> getSearchMemberListByAttr(String primary, String srchOption, List<String> attrList, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("attrList", attrList);
		map.put("srchOption", srchOption);
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);

		return ezSurveyDAO.getSearchMemberListByAttr(map);
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
	public JSONObject checkPermission(List<Long> surveyList, int mode, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		String userId          = userInfo.getId();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("surveyList", surveyList);
		map.put("userId"    , userId);
		map.put("tenantId"  , userInfo.getTenantId());
		map.put("companyId" , userInfo.getCompanyID());
		map.put("primary"   , userInfo.getPrimary());
		map.put("offset"    , commonUtil.getMinuteUTC(userInfo.getOffset()));
		
		boolean isDeletedSurvey = ezSurveyDAO.comfirmSurveyDeletion(map);
		
		if (isDeletedSurvey) {
			result.put("code", -1);
			return result;
		}
		
		List<SurveyVO> listSurvey  = ezSurveyDAO.getSurveyListForPermission(map);
		
		if (listSurvey == null || listSurvey.isEmpty()) {
			result.put("code", 3);
			return result;
		}
		
		List<SurveyVO> otherSurvey = listSurvey.stream().filter(i -> !i.getCreatorId().equals(userId)).collect(Collectors.toList());
		
		// mode - 설문결과 공개 플래그. 0-비공개, 1-공개, 2-지정공개
		if (mode == 1) { //delete, reuse check
			if (otherSurvey.size() > 0) {
				result.put("code", 3);
				return result;
			}
		}
		else {
			if (otherSurvey.size() > 0) {
				List<Long> listOtherSurveyId  = otherSurvey.stream().map(SurveyVO::getSurveyId).collect(Collectors.toList());
				List<Long> listReceivedSurvey = getUserReceivedSurveyList(userInfo, 0);
				List<Long> resultList = new ArrayList<>(listReceivedSurvey);
				if (mode == 2) {
					List<Long> listReceivedSurveyResult = getUserReceivedSurveyResultList(userInfo, 0);
					resultList.removeAll(listReceivedSurveyResult);
					resultList.addAll(listReceivedSurveyResult);
				}
				if (!resultList.containsAll(listOtherSurveyId)) {
					result.put("code", 3);
					return result;
				}
			}
		}
		
		result.put("code", 0);
		return result;
	}
	
	@Override
	public String saveUploadFile(List<MultipartFile> multiFileLists, JSONArray nameArray, String realPath, int tenantId) throws Exception {
		String pFileName   = (String)((JSONObject)nameArray.get(0)).get("originalFilename");
		pFileName = commonUtil.detectPathTraversal(pFileName);
		String surveyPath  = getSurveyDirPath(tenantId);
		String pDirPath    = realPath + surveyPath;
		
		File file = new File(pDirPath);
		
		if (!file.exists() && !file.mkdirs()) {
			logger.debug("Can not create file!");
			throw new IOException();
		}
		
		int dotPos     = pFileName.lastIndexOf(".");
		String extend  = dotPos == -1 ? ".none" : pFileName.substring(dotPos + 1);
		String newName = UUID.randomUUID().toString() + "." + extend;
		writeUploadedFile(multiFileLists.get(0), newName, pDirPath);
		
		return surveyPath + newName;
	}
	
	@Override
	public void deleteAttachFile(String filePath, String realPath, int tenantId) throws Exception {
		String pDirPath = realPath + commonUtil.detectPathTraversal(filePath);
		File file       = new File(pDirPath);
		
		if (file.exists()) {
			try {
				file.delete();
			}
			catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		}
	}
	
	@Override
	public void getDownloadedFile(String fileName, String filePath, String realPath, String userAgent, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String _fileName = fileName;
		_fileName        = CommonUtil.getEncodedFileNameForDownload(userAgent, _fileName);
		File file        = new File(realPath + commonUtil.detectPathTraversal(filePath));
		
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
	public synchronized JSONObject saveSurveyItem(HttpServletRequest request, String realPath, JSONArray questions, String title, String purpose, String startDate, String endDate, int publicFlag, int anonymousFlag, int multipleFlag, int userFlag, int publicDays, JSONArray attchList, JSONArray users, int useStatus, long surveyId, int draftMode, LoginVO userInfo, int mailFlag, int popupFlag) throws Exception {
		JSONObject result                    = new JSONObject();
		int tenantId                         = userInfo.getTenantId();
		String companyId                     = userInfo.getCompanyID();
		String userId                        = userInfo.getId();
		String offset                        = userInfo.getOffset();
		String primary                       = userInfo.getPrimary();
		String userCompanyId                 = "";
		SurveyVO survey                      = new SurveyVO();
		SimpleDateFormat formatter           = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String timeUTC                       = commonUtil.getDateStringInUTC(formatter.format(new Date()), offset, true);
		String startDateUTC                  = commonUtil.getDateStringInUTC(startDate + " 00:00:00", offset, true);
		String endDateUTC                    = commonUtil.getDateStringInUTC(endDate   + " 23:59:59", offset, true);
		Set<SimpleUserVO> setUsers           = new HashSet<>();
		List<String> deptList                = new ArrayList<>();
		List<String> jikchekList                = new ArrayList<>();
		List<String> jikwiList                = new ArrayList<>();
		List<AttachVO> totalAttach           = new ArrayList<>();
		List<QuestionVO> totalQuestions      = new ArrayList<>();
		List<OptionVO> totalOptions          = new ArrayList<>();
		List<SurveyParticipantVO> totalUsers = new ArrayList<>();
		Map<String,Object> map               = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId" , tenantId);
		long crrSurveyId                    = 0;
		long maxQuestionId                  = ezSurveyDAO.getMaxQuestionId(map);
		long maxOptionId                    = ezSurveyDAO.getMaxOptionId(map);
		
		if (surveyId != -1) {
			if (draftMode == 0) {
				crrSurveyId = surveyId;
			}
			else {
				//Check if current survey is draft survey or not
				map.put("primary",   userInfo.getPrimary());
				map.put("offset",    commonUtil.getMinuteUTC(userInfo.getOffset()));
				map.put("userId",    userInfo.getId());
				map.put("surveyId",  surveyId);
				SurveyVO crrsurvey  = ezSurveyDAO.getSurveyInfo(map);
				
				if (crrsurvey.getDraftFlag() == 1) {
					crrSurveyId = surveyId;
				}
				else {
					crrSurveyId = ezSurveyDAO.getMaxSurveyId(map);
				}
			}
		}
		else {
			crrSurveyId = ezSurveyDAO.getMaxSurveyId(map);
		}
		
		survey.setSurveyId(crrSurveyId);
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
		survey.setTitle(commonUtil.stripScriptTags(title));
		survey.setPurpose(commonUtil.stripScriptTags(purpose));
		survey.setCreateDate(timeUTC);
		survey.setUpdateDate(timeUTC);
		survey.setUseStatus(useStatus);
		survey.setStartDate(startDateUTC);
		survey.setEndDate(endDateUTC);
		survey.setDraftFlag(draftMode);
		survey.setMailFlag(mailFlag);
		survey.setPopupFlag(popupFlag);
		
		
		if (publicFlag == 1) {
			survey.setOpenDays(publicDays);
		}
		
		//Add questions
		for (int i = 0; i < questions.size(); i++, maxQuestionId++) {
			JSONObject questionObj = (JSONObject)questions.get(i);
			int requiredFlag       = ((Long)questionObj.get("required")).intValue();
			int questionType       = ((Long)questionObj.get("type")).intValue();
			JSONObject questionAtt = (JSONObject)questionObj.get("attach");
			JSONObject imgTitle = (JSONObject)questionObj.get("imgTitle");
			JSONArray options      = (JSONArray)questionObj.get("option");
			
			if ((options == null || options.size() == 0) && draftMode == 0) {
				result.put("status", "error");
				result.put("code", 1);
				return result;
			}
			
			for (int j = 0; j < options.size(); j++, maxOptionId++) {
				JSONObject optionObj = (JSONObject)options.get(j);
				JSONObject optionAtt = (JSONObject)optionObj.get("attach");
				String optionContent = "";
				if(optionObj.get("content") != null) {
					optionContent = commonUtil.stripScriptTags(optionObj.get("content").toString());
				}
				int optionLevel      = optionObj.get("level")     != null ? ((Long)optionObj.get("level")).intValue()     : 0;
				int otherFlag        = optionObj.get("otherFlag") != null ? ((Long)optionObj.get("otherFlag")).intValue() : 0;
				int logicNum         = optionObj.get("logic")     != null ? ((Long)optionObj.get("logic")).intValue()     : -1;
				OptionVO option      = new OptionVO();
				option.setOptionId(maxOptionId);
				option.setQuestionId(maxQuestionId);
				option.setSurveyId(crrSurveyId);
				option.setQuestionType(questionType);
				option.setContent(optionContent);
				option.setLevel(optionLevel);
				option.setOtherFlag(otherFlag);
				option.setCompanyId(companyId);
				option.setTenantId(tenantId);
				option.setLogic(logicNum);
				
				if (questionType == 3 || questionType == 4) {
					int rowLevel = ((Long)optionObj.get("rowLevel")).intValue();
					int colLevel = ((Long)optionObj.get("colLevel")).intValue();
					option.setRowLevel(rowLevel);
					option.setColLevel(colLevel);
				}
				
				//Add option attach file
				if (optionAtt != null) {
					saveAttachFile(realPath, optionAtt, maxOptionId, companyId, tenantId, "option", crrSurveyId, totalAttach);
				}
				
				//Add option
				totalOptions.add(option);
			}
			
			String questionTitle = commonUtil.stripScriptTags(questionObj.get("content").toString());
			int questionLogic    = questionObj.get("logicFlag") != null ? ((Long)questionObj.get("logicFlag")).intValue() : 0;
			int skipFlag         = questionObj.get("skipFlag")  != null ? ((Long)questionObj.get("skipFlag")).intValue()  : 0;
			long questionSkip    = questionObj.get("skip")      != null ? ((Long)questionObj.get("skip"))                 : -1;
			int questionOrder    = ((Long)questionObj.get("level")).intValue();
			QuestionVO question  = new QuestionVO();
			
			question.setQuestionId(maxQuestionId);
			question.setSurveyId(crrSurveyId);
			question.setTenantId(tenantId);
			question.setCompanyId(companyId);
			question.setContent(questionTitle);
			question.setType(questionType);
			question.setLevel(questionOrder);
			question.setUseStatus(1);
			question.setLogicFlag(questionLogic);
			question.setRequired(requiredFlag);
			question.setSkip(questionSkip);
			question.setSkipFlag(skipFlag);
			
			if (questionType == 7) {
				if (questionObj.get("sliderLogicPoint") != null && questionLogic == 1) {
					question.setSliderLogicPoint(((Long)questionObj.get("sliderLogicPoint")).intValue());
				}
				
				question.setUnit((Long)questionObj.get("unit"));
			}
			
			//Add question attach file
			if (questionAtt != null) {
				saveAttachFile(realPath, questionAtt, maxQuestionId, companyId, tenantId, "question", crrSurveyId, totalAttach);
			}
			
			//Add survey attach list
			if (imgTitle != null && imgTitle.size() > 0) {
				saveAttachFile(realPath, imgTitle, maxQuestionId, companyId, tenantId, "title", crrSurveyId, totalAttach);
				question.setContent("HASIMGTITLE");
			}
			
			//Add question
			totalQuestions.add(question);
		}
		
		if (attchList != null && attchList.size() > 0) {
			for (int i = 0; i < attchList.size(); i++) {
				JSONObject surveyAtt = (JSONObject)attchList.get(i);
				saveAttachFile(realPath, surveyAtt, crrSurveyId, companyId, tenantId, "survey", crrSurveyId, totalAttach);
			}
			
			survey.setAttachFlag(1);
		}
		
		//Add survey users
		if (userFlag == 1) { // 대상자 지정 설문인 경우
			for (int i = 0; i < users.size(); i++) {
				JSONObject userObj             = (JSONObject)users.get(i);
				String userType                = userObj.get("userType").toString();
				String userDeptId              = userObj.get("deptId").toString();
				String subDeptYN			   = userObj.get("subDeptYN") != null ? userObj.get("subDeptYN").toString() : "N";
				SurveyParticipantVO surveyUser = new SurveyParticipantVO();
				surveyUser.setSurveyId(crrSurveyId);
				surveyUser.setCompanyId(companyId);
				surveyUser.setTenantId(tenantId);
				surveyUser.setUserId(userObj.get("userId").toString());
				surveyUser.setDeptId(userDeptId);
				surveyUser.setUserType(userType);
				surveyUser.setUserName1(userObj.get("userName1").toString());
				surveyUser.setUserName2(userObj.get("userName2").toString());
				surveyUser.setDeptName1(userObj.get("deptName1").toString());
				surveyUser.setDeptName2(userObj.get("deptName2").toString());
				surveyUser.setEmail(userObj.get("email").toString());
				surveyUser.setSubDeptYN(subDeptYN);
				totalUsers.add(surveyUser);
				
				// 하위부서 허용여부 추가로 인해 회사도 부서로 취급함 (하위부서 허용여부가 '허용'인 경우에만 회사 소속 모든 사원 포함, '불가'라면 부서 리스트에 추가)
				if (userType.equals("comp") && surveyUser.getSubDeptYN().equals("Y")) {
					userCompanyId = userDeptId;
				}
				else if (userType.equals("dept") || (userType.equals("comp") && surveyUser.getSubDeptYN().equals("N"))) {
					deptList.add(userDeptId);
				}
				else if (userType.equals("jikwi")) {
					jikwiList.add(userDeptId);
				}
				else if (userType.equals("jikchek")) {
					jikchekList.add(userDeptId);
				}
				else {
					SimpleUserVO simpleUser = new SimpleUserVO(surveyUser);
					setUsers.add(simpleUser);
				}
			}
		}
		else { // 전체 대상 설문인 경우
			OrganDeptVO company            = ezOrganService.getDeptInfo(companyId, primary, tenantId);
			SurveyParticipantVO surveyUser = new SurveyParticipantVO();
			surveyUser.setSurveyId(crrSurveyId);
			surveyUser.setCompanyId(companyId);
			surveyUser.setTenantId(tenantId);
			surveyUser.setUserId(companyId);
			surveyUser.setDeptId(companyId);
			surveyUser.setUserType("comp");
			surveyUser.setUserName1(company.getDisplayName1());
			surveyUser.setUserName2(company.getDisplayName2());
			surveyUser.setDeptName1(company.getDisplayName1());
			surveyUser.setDeptName2(company.getDisplayName2());
			surveyUser.setEmail(company.getMail());
			surveyUser.setSubDeptYN("Y"); // 전체 대상이므로 하위부서 허용여부 Y(회사 소속의 모든 개인이 대상자임)
			totalUsers.add(surveyUser);
			userCompanyId = companyId;
		}
		
		//Get total users of the survey
		if (!userCompanyId.equals("")) { // 전체 대상 설문인 경우, 해당 회사의 모든 사원을 대상자로 삽입
			setUsers.addAll(getAllMembersOfCompany(userCompanyId, primary, tenantId));
		}
		else { // 대상자 지정 설문인 경우, 대상자를 찾아 삽입
			if (deptList.size() > 0) {
				setUsers.addAll(getDeptMemberList(null, deptList, primary, 0, 0, tenantId));
			}
			if (jikchekList.size() > 0) {
				setUsers.addAll(getSearchMemberListByAttr(primary, "EXTENSIONATTRIBUTE8", jikchekList, 0));
			}
			if (jikwiList.size() > 0) {
				setUsers.addAll(getSearchMemberListByAttr(primary, "EXTENSIONATTRIBUTE7", jikwiList, 0 ));
			}
		}

		survey.setTotalUser(setUsers.size());
		
		String mode = "";
		//Check modify/save mode
		if (crrSurveyId == surveyId) {
			mode = "MODIFY";
			cleanAndUpdateSurvey(survey);
		}
		else {
			//Save new survey
			mode = "NEW";
			ezSurveyDAO.saveSurveyItem(survey);
		}
		
		//Save questions
		for (QuestionVO question : totalQuestions) {
			ezSurveyDAO.saveQuestionItem(question);
		}
		
		//Save options
		for (OptionVO option : totalOptions) {
			ezSurveyDAO.saveOptionItem(option);
		}
		
		//Save attach
		for (AttachVO attach : totalAttach) {
			ezSurveyDAO.saveAttachItem(attach);
		}
		
		//Save users
		for (SurveyParticipantVO surveyUser : totalUsers) {
			ezSurveyDAO.saveSurveyUsers(surveyUser);
		}
		
		try {
			List<SurveyParticipantVO> sendMailList = new ArrayList<SurveyParticipantVO>();
			List<SurveyParticipantVO> userList = getSurveyParticipantListForMail(crrSurveyId, companyId, tenantId);
			/* 2021-11-18 홍승비 - 대상자가 부서(회사)인 경우, 하위부서 허용여부를 체크하여 메일 발송 대상자 추가 (중복 제거된 개인 단위 VO) */
			List<SurveyParticipantVO> subDeptList = getSurveySubDeptListForMail(crrSurveyId, companyId, tenantId);
			
			sendMailList.addAll(userList);
			sendMailList.addAll(subDeptList);
			List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
			Set<String> sendNotiSet = new HashSet<String> ();
			for (int i = 0; i < sendMailList.size(); i++) {
				SurveyParticipantVO userinfo = sendMailList.get(i);
				String userAccount = userinfo.getEmail();
				String receiveId = userAccount.split("@")[0];
				Map<String, Object> recipientMap = new HashMap<String, Object>();
				recipientMap.put("userType", "PERSON");
				recipientMap.put("companyId", userInfo.getCompanyID());
				recipientMap.put("cn", receiveId);
				
				if (!sendNotiSet.contains(receiveId)) {
					notiRecipientList.add(recipientMap);
					sendNotiSet.add(receiveId);
				}
			}
			
			//Send notice mail
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			Boolean notiMailFlag = mailFlag == 1 && dateFormat.format(new Date()).equals(startDate) && draftMode == 0;
			Boolean totalNotiFlag = dateFormat.format(new Date()).equals(startDate) && draftMode == 0;
			if (notiMailFlag) {
				int mailSentFlag = ezSurveyDAO.getMailSentFlag(survey);
				
				if(mailSentFlag == 0) {
					logger.debug("start send mail");
					
					ezEmailAsync.sendMail(sendMailList, survey, offset);
					updateMailSentFlag(crrSurveyId, 1, companyId, tenantId);
				}
				
			}
			
			if (totalNotiFlag) {
				int totalNotiSentFlag = ezSurveyDAO.getTotalNotiSentFlag(survey);
				
				if(totalNotiSentFlag == 0) {
					logger.debug("start send noti");
					String linkUrl = "/ezSurvey/surveyDetail.do?itemId=" + crrSurveyId;
			    	String linkUrlMobile = "/mobile/ezSurvey/surveyDetail.do?itemId=" + crrSurveyId + "&mode=all";
			    	ezNotificationService.sendNoti(request, userInfo.getId(), userInfo.getDisplayName(), notiRecipientList, "SURVEY", mode, title, "popup", "760", "750", linkUrl, linkUrlMobile, "");
			    	
			    	updateTotalNotiSentFlag(crrSurveyId, 1, companyId, tenantId);
					logger.debug("end send noti");
				}
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		result.put("survey_id", crrSurveyId);
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	private void cleanAndUpdateSurvey(SurveyVO survey) {
		//Remove current questions
		ezSurveyDAO.deleteSurveyQuestions(survey);
		
		//Remove current options
		ezSurveyDAO.deleteSurveyOptions(survey);
		
		//Remove current attach
		ezSurveyDAO.deleteSurveyAttach(survey);
		
		//Remove current users
		ezSurveyDAO.deleteSurveyUsers(survey);
		
		//Update survey
		survey.setUpdateMode(0);
		ezSurveyDAO.updateSurveyItem(survey);
	}
	
	private synchronized void saveAttachFile(String realPath, JSONObject attachObj, long targetId, String companyId, int tenantId, String targetType, long surveyId, List<AttachVO> totalAttach) throws Exception {
		AttachVO attach = new AttachVO();
		String fileName = attachObj.get("fname").toString();
		
		if (attachObj.get("furl") != null) {
			String fileUrl  = attachObj.get("furl").toString();
			attach.setFurl(fileUrl);
		}
		else {
			String filePath = commonUtil.detectPathTraversal(attachObj.get("fpath").toString());
			File attFile    = new File(realPath + filePath);
			long fileSize   = attFile.length();
			attach.setFpath(filePath);
			attach.setFileSize(fileSize);
		}
		
		attach.setSurveyId(surveyId);
		attach.setCompanyId(companyId);
		attach.setTenantId(tenantId);
		attach.setTargetId(targetId);
		attach.setTargetType(targetType);
		attach.setFname(fileName);
		totalAttach.add(attach);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getItemsBySearching(String pageMode, int currentPage, int listCntSize, String title, String creatorName, String startDate, String endDate, String srchMode, String srchOption, String order, String column, LoginVO userInfo, int userMode, String filterStatus) throws Exception {
		JSONObject result   = new JSONObject();
		String userId       = userInfo.getId();
		int tenantId        = userInfo.getTenantId();
		String primary      = userInfo.getPrimary();
		String offset       = userInfo.getOffset();
		String offsetMinute = commonUtil.getMinuteUTC(offset);
		int startPoint      = 0;
		int totalItems      = 0;
		int totalPages      = 0;
		
		/* 2024-07-01 홍승비 - SQL Injection 수정 > 정렬 조건에서 $ 기호 제거, 정렬 칼럼(orderCol)과 순차(orderSort) 변수를 분리 */
		String orderCol = "";
		String orderSort = "";
		if (!column.equals("") && !order.equals("")) {
			orderSort = order;
			
			switch(column) {
				case "at" : orderCol = "attach_flag"; break;
				case "cd" : orderCol = "create_date"; break;
                case "surveyId" : orderCol = "SURVEY_ID"; break;
				case "tt" : orderCol = "title"; break;
				case "ed" : orderCol = "end_date"; break;
				case "ut" : orderCol = "participate_flag"; break;
				case "ct" : orderCol = ("user_name" + primary); break;
				case "pl" : orderCol = "result_public_flag"; break;
				case "an" : orderCol = "anonymous_flag"; break;
                case "participants" : orderCol = "PARTICIPANTS"; break;
                case "participation" : orderCol = "PARTICIPATION"; break;
				default   : orderCol = "title"; break;
			}
		}
		
		if (!startDate.equals("")) {
			startDate = commonUtil.getDateStringInUTC(startDate + " 00:00:00", offset, true);
			endDate   = commonUtil.getDateStringInUTC(endDate   + " 23:59:59", offset, true);
		}
		
		title       = title.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
		creatorName = creatorName.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
		
		SurveyItemSearchVO searchVO = new SurveyItemSearchVO(pageMode, listCntSize, tenantId, userId, primary, offsetMinute, title, creatorName, startDate, endDate, orderCol, orderSort, srchMode, srchOption, userMode);
		
		if (pageMode.equals("processing") || pageMode.equals("finish") || pageMode.equals("all")) {
			List<Long> listReceivedSurvey = getUserReceivedSurveyList(userInfo, 0);
			List<Long> listReceivedResultSurvey = getUserReceivedSurveyResultList(userInfo, 0);
			SimpleDateFormat formatter    = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String timeUTC                = commonUtil.getDateStringInUTC(formatter.format(new Date()), offset, true);
			searchVO.setSurveyIds(listReceivedSurvey);
			searchVO.setSurveyResultIds(listReceivedResultSurvey);
			searchVO.setToday(timeUTC);
		}
        
        searchVO.setFilterStatus(filterStatus);
		
		totalItems  = ezSurveyDAO.getTotalReceivedSurveyItemsCnt(searchVO);
		totalPages  = (totalItems + listCntSize - 1) / listCntSize;
		currentPage = currentPage > totalPages ? totalPages : currentPage;
		currentPage = currentPage == 0         ? 1          : currentPage;
		startPoint  = (currentPage - 1) * listCntSize;
		searchVO.setStartPoint(startPoint);
		List<SurveyVO> itemList = ezSurveyDAO.getTotalReceivedSurveyItems(searchVO);
		
		result.put("itemList",    itemList);
		result.put("totalPages",  totalPages);
		result.put("totalRows",   totalItems);
		result.put("currentPage", currentPage);
		result.put("status", "ok");
		result.put("code", 0);
		
		return result;
	}
	

	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getPopupItems(String mode, LoginVO userInfo) throws Exception {
		JSONObject result   = new JSONObject();
		String userId       = userInfo.getId();
		int tenantId        = userInfo.getTenantId();
		String primary      = userInfo.getPrimary();
		String offset       = userInfo.getOffset();
		String offsetMinute = commonUtil.getMinuteUTC(offset);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("primary", primary);
		map.put("offset", offsetMinute);
		map.put("mode", mode);
		
		if (mode != null && mode.equals("popup")) {
			List<Long> listReceivedSurvey = getUserReceivedSurveyList(userInfo, 0);
			List<Long> listReceivedResultSurvey = getUserReceivedSurveyResultList(userInfo, 0);
			SimpleDateFormat formatter    = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String timeUTC                = commonUtil.getDateStringInUTC(formatter.format(new Date()), offset, true);
			map.put("surveyIds", listReceivedSurvey);
			map.put("surveyResultIds", listReceivedResultSurvey);
			map.put("today", timeUTC);
		}
		
		// 조직도, 직위, 직책, 권한그룹 모든 것에 해당되는 설문 목록
		List<SurveyVO> surveyPopupList = ezSurveyDAO.getTotalPopupSurveyItems(map);
		
		result.put("surveyPopupList", surveyPopupList);
		result.put("userId", userId);
		result.put("status", "ok");
		result.put("code", 0);
		
		return result;
	}
	
	@Override
	public void deleteItems(List<Long> itemIdList, LoginVO userInfo) throws Exception {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
		Map<String,Object> map     = new HashMap<String, Object>();
		map.put("tenantId",   userInfo.getTenantId());
		map.put("companyId",  userInfo.getCompanyID());
		map.put("itemList",   itemIdList);
		map.put("userId",     userInfo.getId());
		map.put("updateTime", timeUTC);
		
		ezSurveyDAO.deleteItems(map);
		
		// 게시물 삭제 시 설문결과 지정공개 대상자 삭제
		for (int i=0; i<itemIdList.size(); i++) {
			Map<String,Object> map2	= new HashMap<String, Object>();
			map2.put("survey_id", itemIdList.get(i));
			map2.put("tenant_id",   userInfo.getTenantId());
			map2.put("company_id",  userInfo.getCompanyID());
			ezSurveyDAO.deleteResultViewPermission(map2);
	 	}
	}
	
	private List<Long> getUserReceivedSurveyList(LoginVO userInfo, long surveyId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId",  userInfo.getTenantId());
		map.put("deptId",    userInfo.getDeptID());
		map.put("companyId", userInfo.getCompanyID());
		map.put("userId",    userInfo.getId());
		
		if (surveyId != 0) {
			map.put("surveyId", surveyId);
		}
		
		List<String> userDeptList = ezSurveyDAO.getUserDepartmentIdList(map);
		map.put("deptList", userDeptList);
		
		/* 2021-11-18 홍승비 - 전자설문 하위부서 허용여부 체크 > 사용자 직속부서, 겸직부서의 모든 상위부서ID를 전달  */
		List<String> userAllDeptPath = ezSurveyDAO.getUserAllDepartmentIdList(map);
		List<String> userAllDeptList = new ArrayList<String>();
		Set<String> userAllDeptSet = new HashSet<String>();
		
		// 상위부서를 전부 포함하는 부서ID+회사ID를 리스트에 담아 쿼리에 전달함 (중복은 set으로 제거)
		if (userAllDeptPath.size() > 0) {
			for (int i = 0; i < userAllDeptPath.size(); i++) {
				userAllDeptSet.addAll(Arrays.asList(userAllDeptPath.get(i).split(",")));
			}
		}
		userAllDeptList.addAll(userAllDeptSet);
		map.put("allDeptList", userAllDeptList);
		
		List<Long> result         = ezSurveyDAO.getReceivedSurveyList(map);
		Set<Long> setSurveyIds    = new HashSet<>(result);
		result.clear();
		result.addAll(setSurveyIds);
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getItemInfo(Long surveyId, String mode, String realPath, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		int tenantId           = userInfo.getTenantId();
		//long startTime         = System.nanoTime(); //Only for test
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId",  tenantId);
		map.put("companyId", userInfo.getCompanyID());
		map.put("primary",   userInfo.getPrimary());
		map.put("offset",    commonUtil.getMinuteUTC(userInfo.getOffset()));
		map.put("userId",    userInfo.getId());
		map.put("surveyId",  surveyId);
		
		SurveyVO survey                     = ezSurveyDAO.getSurveyInfo(map);
		List<SurveyParticipantVO> listUsers = ezSurveyDAO.getSurveyUsers(map);
		
		for (SurveyParticipantVO surveyParticipant : listUsers) {
			// 일반 모드에서는 사용자 정보를 가져올 필요가 없음
			if(mode.equals("normal")) {
				break;
			}
			
			String userType = surveyParticipant.getUserType();
			
			if (userType != null) {
				switch (userType.toLowerCase()) {
				case "user":
					setSurveyUserInfo(surveyParticipant, userInfo.getPrimary());
					break;
				case "dept":
				case "comp":
					setSurveyDeptInfo(surveyParticipant, userInfo.getPrimary());
					break;
				default:
					break;
				}
			}
		}
		JSONArray listResultUsers = getSurveyResultViewTarget(userInfo, surveyId);
		List<AttachVO> surveyAttach         = ezSurveyDAO.getSurveyAttachList(map);
		
		//Clone attach files
		/* 2023-08-04 한태훈 : 첨부파일 다운로드 시 보안문제로 원본 파일 복사 후 복사된 파일을 다운로드 받을 수 있게 하는 코드이지만, 전자설문 페이지  
		 열 때마다 파일이 복사되는 문제가 있음.
		cloneAttachFiles(surveyAttach, realPath, getSurveyDirPath(tenantId));
		*/
		survey.setAttachList(surveyAttach);
		survey.setUserList(listUsers);
		survey.setResultViewTarget(listResultUsers);
		
		result.put("survey", survey);
		
		if (mode.equals("normal")) {
			LoginVO login = new LoginVO();
			login.setId(survey.getCreatorId());
			login.setDn("NOPASSWORD");
			login.setTenantId(tenantId);
			
			LoginVO creator = loginService.selectUser(login);
			creator.setDisplayName(userInfo.getPrimary().equals("1") ? userInfo.getDisplayName1() : userInfo.getDisplayName2());
			
			result.put("creator", creator);
		}
		else if (mode.equals("modify")) {
			//Change modify status only if it's not draft survey
			if (survey.getDraftFlag() == 0) {
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date date                  = new Date();
				String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
				survey.setModifyFlag(1);
				survey.setUpdateDate(timeUTC);
				survey.setUpdateUser(userInfo.getId());
				survey.setUpdateMode(1);
				
				ezSurveyDAO.updateSurveyItem(survey);
			}
		}
		
		//Check requirements
		List<Long> checkReceivedSurvey = getUserReceivedSurveyList(userInfo, surveyId);
		
		if (checkReceivedSurvey == null || checkReceivedSurvey.size() == 0) {
			result.put("participation", "no");
		} else {
			result.put("participation", "yes");
		}
		
		// 20.05.06 강승구 - 설문 열 때 답변했던 것인지 확인
		int responseCnt = ezSurveyDAO.getUserResponseCntForSurvey(map);
		
		if (responseCnt > 0) {
			result.put("resStatus", "true");
		} else {
			result.put("resStatus", "false");
		}

		result.put("status", "ok");
		result.put("code", 0);
		//long endTime   = System.nanoTime();
		//long totalTime = endTime - startTime;
		//logger.debug("TOTAL TIME: " + totalTime);
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getSurveyQuestions(Long surveyId, String logicMode, String realPath, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		int tenantId           = userInfo.getTenantId();
		boolean logicFlag      = false;
		int logicCheck         = 1;
		
		Map<Long, List<Long>> logicMap = new HashMap<>();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId",  tenantId);
		map.put("companyId", userInfo.getCompanyID());
		map.put("primary",   userInfo.getPrimary());
		map.put("offset",    commonUtil.getMinuteUTC(userInfo.getOffset()));
		map.put("userId",    userInfo.getId());
		map.put("surveyId",  surveyId);
		List<QuestionVO> questions = ezSurveyDAO.getAllQuestionsOfSurvey(map);
		
		if (questions != null && questions.size() > 0) {
			List<OptionVO> options     = ezSurveyDAO.getAllOptionsOfSurvey(map);
			List<ResponseVO> responses = new ArrayList<>();
			List<Long> questionIds     = questions.stream().map(QuestionVO::getQuestionId).collect(Collectors.toList());
			List<Long> optionIds       = options.stream().map(OptionVO::getOptionId).collect(Collectors.toList());
			map.put("questionIds", questionIds);
			map.put("optionIds"  , optionIds);
			List<AttachVO> attachs     = ezSurveyDAO.getAllAttachForQsAndOpt(map);
			//Clone list of attach
			/* 2023-08-04 한태훈 : 첨부파일 다운로드 시 보안문제로 원본 파일 복사 후 복사된 파일을 다운로드 받을 수 있게 하는 코드이지만, 전자설문 페이지  
			 열 때마다 파일이 복사되는 문제가 있음.
			cloneAttachFiles(attachs, realPath, getSurveyDirPath(tenantId));
			*/
			
			//long startTime = System.nanoTime();
			
			if (logicMode.equals("answer")) {
				logicCheck = 2; //get options + answers
				responses  = ezSurveyDAO.getAllResponsesForSurvey(map);
			}
			else if (logicMode.equals("logic")) {
				logicCheck = 1; //get logic map
			}
			else {
				logicCheck = 0; // get only options
			}
			
			//Check if survey has or hasn't logic branching
			if (logicCheck == 1) {
				for (QuestionVO question : questions) {
					if (question.getLogicFlag() == 1 || question.getSkipFlag() == 1) {
						logicFlag = true;
						break;
					}
				}
			}
			List<AttachVO> imgTitleList = attachs.stream().filter(a -> a.getTargetType().equals("title")).collect(Collectors.toList());
			attachs.removeAll(imgTitleList); 
			//Separate
			List<AttachVO> qstAttch    = attachs.stream().filter(a -> a.getTargetType().equals("question")).collect(Collectors.toList());
			attachs.removeAll(qstAttch);
			
			Map<String, List<ResponseVO>> mapResponses = new HashMap<>();
			if (logicCheck == 2 && responses != null && responses.size() > 0) {
				ListIterator<ResponseVO> respIter = responses.listIterator();
				while (respIter.hasNext()) {
					ResponseVO response = respIter.next();
					int qstType     = response.getQuestionType();
					String checkKey = (qstType == 1 || qstType == 2 || qstType == 9 || qstType == 10 || qstType == 11) ? "opt" + response.getOptionId() : "qst" + response.getQuestionLevel();
					
					if (mapResponses.containsKey(checkKey)) {
						mapResponses.get(checkKey).add(response);
					}
					else {
						List<ResponseVO> optResponse = new ArrayList<>();
						optResponse.add(response);
						mapResponses.put(checkKey, optResponse);
					}
				}
			}
			
			Map<Long, List<OptionVO>> mapOption = new HashMap<>();
			ListIterator<OptionVO> optionIter   = options.listIterator();
			
			while (optionIter.hasNext()) {
				OptionVO option = optionIter.next();
				ListIterator<AttachVO> attIter = attachs.listIterator();
				while (attIter.hasNext()) {
					AttachVO attach = attIter.next();
					if (attach.getTargetId() == option.getOptionId()) {
						option.setAttach(attach);
						attIter.remove();
					}
				}
				
				if (mapOption.containsKey(option.getQuestionId())) {
					mapOption.get(option.getQuestionId()).add(option);
				}
				else {
					List<OptionVO> qsOption = new ArrayList<>();
					qsOption.add(option);
					mapOption.put(option.getQuestionId(), qsOption);
				}
				
				//Add responses
				if (logicCheck == 2) {
					int qstType = option.getQuestionType();
					if (qstType == 1 || qstType == 2 || qstType == 9 || qstType == 10 || qstType == 11) {
						String optKey = "opt" + option.getOptionId();
						if (mapResponses.containsKey(optKey)) {
							option.setResponses(mapResponses.get(optKey));
						}
					}
				}
			}
			
			for (QuestionVO question : questions) {
				question.setOption(mapOption.get(question.getQuestionId()));
				
				if (logicFlag) {
					//Process question logic
					List<Long> listQst = new ArrayList<>(processQuestionLogic(question, questions.size()));
					logicMap.put(question.getLevel(), listQst);
				}
				
				ListIterator<AttachVO> qsAtIter = qstAttch.listIterator();
				while (qsAtIter.hasNext()) {
					AttachVO qsAttach = qsAtIter.next();
					if (qsAttach.getTargetId() == question.getQuestionId()) {
						question.setAttach(qsAttach);
						qsAtIter.remove();
					}
				}
				
				ListIterator<AttachVO> imgTitleIter = imgTitleList.listIterator();
				while (imgTitleIter.hasNext()) {
					AttachVO imgTitle = imgTitleIter.next();
					if (imgTitle.getTargetId() == question.getQuestionId()) {
						question.setContent("");
						question.setImgTitle(imgTitle);
						imgTitleIter.remove();
					}
				}
				
				//Add responses
				if (logicCheck == 2) {
					int qstType = question.getType();
					if (qstType != 1 && qstType != 2 && qstType != 9 && qstType != 10 && qstType != 11) {
						String qstKey = "qst" + question.getLevel();
						if (mapResponses.containsKey(qstKey)) {
							question.setResponses(mapResponses.get(qstKey));
						}
					}
				}
			}
			
			/* 2022-12-02 홍승비 - 전자설문의 질답 분기처리를 전부 페이지단에서 처리하도록 개선하였으므로, 불필요한 분기처리 동작 제거 (참고를 위해 주석으로 남김) */
			// firstpath(remainPath)는 2022-12-02 기준 어디에서도 쓰이지 않음
			// logicPath와 currentPath는 result로 전달되지 않으며, logicMap은 travelNode() 메서드 내부에서 변형되지 않음
			/*
			if (logicFlag) {
				//Make logic path
				List<List<Long>> logicPath = new ArrayList<>();
				List<Long> currentPath     = new ArrayList<>();
				
				//Get all possible path
				travelNode(1, logicPath, logicMap, currentPath);
				
				//Find enable question list
				List<Long> remainPath = logicPath.get(0).stream().map(elm -> Long.valueOf(elm)).collect(Collectors.toList());
				for (int i = 1; i < logicPath.size(); i++) {
					remainPath.retainAll(logicPath.get(i));
				}
				
				result.put("firstpath", remainPath);
				result.put("logicmap" , logicMap);
			}
			*/
			
			if (logicFlag) {
				result.put("logicmap" , logicMap);
			}
		}
		
		//long endTime   = System.nanoTime();
		//long totalTime = endTime - startTime;
		//logger.debug("TOTAL TIME: " + totalTime);
		
		result.put("questions", questions);
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	private void travelNode(long qstLevel, List<List<Long>> logicPath, Map<Long, List<Long>> logicMap, List<Long> currentPath) {
		if (qstLevel == 0) {
			logicPath.add(currentPath);
		}
		else {
			List<Long> nodeList = logicMap.get(qstLevel);
			currentPath.add(qstLevel);
			
			if (nodeList.size() == 1) {
				long nxtQst = nodeList.get(0);
				if (nxtQst == 0) {
					logicPath.add(currentPath);
				}
				else {
					travelNode(nxtQst, logicPath, logicMap, currentPath);
				}
			}
			else {
				for (long nextQsId : nodeList) {
					List<Long> clonePath = currentPath.stream().map(elm -> Long.valueOf(elm)).collect(Collectors.toList());
					travelNode(nextQsId, logicPath, logicMap, clonePath);
				}
			}
		}
	}
	
	private Set<Long> processQuestionLogic(QuestionVO question, int totalQs) {
		Set<Long> setQuestionIds = new HashSet<>();
		
		if (question.getSkipFlag() == 1) {
			setQuestionIds.add(question.getSkip());
		}
		else if (question.getLogicFlag() == 1) {
			for (OptionVO option : question.getOption()) {
				if (option.getLogic() != -1) {
					setQuestionIds.add(option.getLogic());
				}
				else {
					if (question.getLevel() < totalQs) {
						setQuestionIds.add(question.getLevel() + 1);
					}
					else {
						setQuestionIds.add((long) 0);
					}
				}
			}
		}
		else {
			if (question.getLevel() < totalQs) {
				setQuestionIds.add(question.getLevel() + 1);
			}
			else {
				setQuestionIds.add((long) 0);
			}
		}
		
		return setQuestionIds;
	}
	
	/* 2023-08-04 한태훈 - 첨부파일 다운로드 시 원본 파일의 접근을 막기 위해 원본 파일을 복사하는 작업을 하는 코드인듯 하나,, 
	 첨부파일이 첨부된 전자설문페이지를 열때마다 파일 복사가 일어나 용량이 커지는 문제 생김.
	
	private void cloneAttachFiles(List<AttachVO> attachs, String realPath, String dirPath) throws Exception {
		for (AttachVO attach : attachs) {
			if (attach.getFurl() != null) {
				continue;
			}
			
			String fileName = attach.getFname();
			int dotPos      = fileName.lastIndexOf(".");
			String extend   = dotPos == -1 ? ".none" : fileName.substring(dotPos + 1);
			String newName  = UUID.randomUUID().toString() + "." + commonUtil.detectPathTraversal(extend);
			String newPath  = dirPath + newName;
			File srcFile    = new File(realPath + commonUtil.detectPathTraversal(attach.getFpath()));
			File destFile   = new File(realPath + newPath);
			
			try {
				FileUtils.copyFile(srcFile, destFile);
				attach.setFpath(newPath);
			}
			catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		}
	}
	*/
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject checkProcessing(String itemId, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		int tenantId           = userInfo.getTenantId();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId",  tenantId);
		map.put("companyId", userInfo.getCompanyID());
		map.put("primary",   userInfo.getPrimary());
		map.put("offset",    commonUtil.getMinuteUTC(userInfo.getOffset()));
		map.put("userId",    userInfo.getId());
		map.put("surveyId",  itemId);
		
		SurveyVO survey = ezSurveyDAO.getSurveyInfo(map);
		
		// 2019-11-22 김민성 - 전자설문 수정시 작성자만 수정 가능
		if(!survey.getCreatorId().equals(userInfo.getId())) {
			result.put("status", "error");
			result.put("code", 3);
		}
		else {
			if (survey.getResponseFlag() == 0) {
				result.put("status", "ok");
				result.put("code", 0);
			}
			else {
				result.put("status", "error");
				result.put("code", 4);
			}
		}
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject changeSurveyState(String itemId, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		int tenantId           = userInfo.getTenantId();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId",  tenantId);
		map.put("companyId", userInfo.getCompanyID());
		map.put("primary",   userInfo.getPrimary());
		map.put("offset",    commonUtil.getMinuteUTC(userInfo.getOffset()));
		map.put("userId",    userInfo.getId());
		map.put("surveyId",  itemId);
		
		SurveyVO survey = ezSurveyDAO.getSurveyInfo(map);
		
		if (survey.getModifyFlag() == 1) {
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date                  = new Date();
			String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
			survey.setModifyFlag(0);
			survey.setUpdateDate(timeUTC);
			survey.setUpdateUser(userInfo.getId());
			survey.setUpdateMode(1);
			ezSurveyDAO.updateSurveyItem(survey);
		}
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}

	@SuppressWarnings("unchecked")
	@Override
	public synchronized JSONObject saveResponseItem(JSONArray responses, long surveyId, LoginVO userInfo) throws Exception {
		JSONObject result               = new JSONObject();
		Map<String, Object> map         = new HashMap<String, Object>();
		List<ResponseVO> totalResponses = new ArrayList<>();
		List<RespondentVO> totalUsers   = new ArrayList<>();
		long responseId                 = ezSurveyDAO.getMaxResponseId(map);
		SimpleDateFormat formatter      = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat formatter2     = new SimpleDateFormat("yyyy-MM-dd");
		Date date                       = new Date();
		String timeUTC                  = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
		map.put("tenantId",  userInfo.getTenantId());
		map.put("companyId", userInfo.getCompanyID());
		map.put("primary",   userInfo.getPrimary());
		map.put("offset",    commonUtil.getMinuteUTC(userInfo.getOffset()));
		map.put("userId",    userInfo.getId());
		map.put("surveyId",  surveyId);
		SurveyVO survey = ezSurveyDAO.getSurveyInfo(map);
		
		//Check requirements
		List<Long> checkReceivedSurvey = getUserReceivedSurveyList(userInfo, surveyId);
		
		if (checkReceivedSurvey == null || checkReceivedSurvey.size() == 0) {
			result.put("status", "error");
			result.put("code", 6);
			return result;
		}
		
		//Check date
		String todayStr     = formatter2.format(new Date());
		String endDateStr   = survey.getEndDate().substring(0, 10);
		String startDateStr = survey.getStartDate().substring(0, 10);
		Date dToday         = formatter2.parse(todayStr);
		Date dEndDate       = formatter2.parse(endDateStr);
		Date dStartDate     = formatter2.parse(startDateStr);
		
		if (dStartDate.compareTo(dToday) > 0 || dToday.compareTo(dEndDate) > 0) {
			result.put("status", "error");
			result.put("code", 7);
			return result;
		}
		
		
		if (survey.getMultiAnswerFlag() == 0) {
			int responseCnt = ezSurveyDAO.getUserResponseCntForSurvey(map);
			
			if (responseCnt > 0) {
				// 삭제하는 코드 삽입
				Map<String, Object> resMap = new HashMap<String, Object>();
				resMap.put("surveyId", surveyId);
				resMap.put("userId", userInfo.getId());
				resMap.put("tenantId", userInfo.getTenantId());
				
				ezSurveyDAO.deleteRespondents(resMap);
				ezSurveyDAO.deleteResponseItems(resMap);
//				result.put("status", "error");
//				result.put("code", 5);
//				return result;
			}
		}
		
		for (int i = 0; i < responses.size(); i++) {
			JSONObject responseObj = (JSONObject)responses.get(i);
			
			if (responseObj == null || responseObj.isEmpty()) {
				result.put("status", "error");
				result.put("code", 1);
				return result;
			}
			
			int questionType  = ((Long)responseObj.get("type")).intValue();
			JSONArray answers = ((JSONArray)responseObj.get("answers"));
			int questionLevel = ((Long)responseObj.get("questionLevel")).intValue();
			String companyId  = userInfo.getCompanyID();
			int tenantId      = userInfo.getTenantId();
			String userId     = userInfo.getId();
			
			for (int j = 0; j < answers.size(); j++, responseId++) {
				JSONObject answerObject = (JSONObject) answers.get(j);
				ResponseVO response     = new ResponseVO();
				response.setResponseId(responseId);
				response.setSurveyId(surveyId);
				response.setQuestionType(questionType);
				response.setQuestionLevel(questionLevel);
				response.setCompanyId(companyId);
				response.setTenantId(tenantId);
				response.setResponsorId(userId);
				
				switch (questionType) {
					case 1:
					case 2:
					case 9:
					case 10:
					case 11:
						long optionId = (Long) answerObject.get("optionId");
						
						if (answerObject.get("otherFlag") != null && ((Long) answerObject.get("otherFlag")).intValue() == 1) {
							String otherValue = commonUtil.stripScriptTags((String) answerObject.get("texts"));
							response.setTexts(otherValue);
						}
						response.setOptionId(optionId);
						break;
					case 3:
					case 4:
						int rowId = ((Long) answerObject.get("rowId")).intValue();
						int colId = ((Long) answerObject.get("colId")).intValue();
						response.setRowId(rowId);
						response.setColumnId(colId);
						break;
					case 5:
					case 6:
						long txtOptionId = (Long) answerObject.get("optionId");
						String txt = commonUtil.stripScriptTags((String) answerObject.get("texts"));
						response.setOptionId(txtOptionId);
						response.setTexts(txt);
						break;
					case 7:
						int sliderValue = ((Long) answerObject.get("sliderValue")).intValue();
						response.setSliderValue(sliderValue);
						break;
					case 8:
						int rankingLevel = ((Long) answerObject.get("rankingLevel")).intValue();
						long rankingOptionId = (Long) answerObject.get("optionId");;
						response.setRankingLevel(rankingLevel);
						response.setOptionId(rankingOptionId);
						break;
					default:
						result.put("status", "error");
						result.put("code", 9);
						return result;
				}
				
				totalUsers.add(addRespondent(surveyId, responseId, timeUTC, userInfo));
				totalResponses.add(response);
			}
		}
		
		//Save responses
		for (ResponseVO res : totalResponses) {
			ezSurveyDAO.saveResponseItem(res);
		}
		
		//Save respondents
		for (RespondentVO user : totalUsers) {
			ezSurveyDAO.saveRespondent(user);
		}
		
		if (survey.getResponseFlag() == 0) {
			//Change survey response flag
			survey.setResponseFlag(1);
			survey.setUpdateMode(2);
			ezSurveyDAO.updateSurveyItem(survey);
		}
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	private RespondentVO addRespondent(long surveyId, long responseId, String timeUTC, LoginVO userInfo) {
		RespondentVO respondent = new RespondentVO();
		respondent.setResponseId(responseId);
		respondent.setSurveyId(surveyId);
		respondent.setUserId(userInfo.getId());
		respondent.setUserName1(userInfo.getDisplayName1());
		respondent.setUserName2(userInfo.getDisplayName2());
		respondent.setEmail(userInfo.getEmail());
		respondent.setDeptId(userInfo.getDeptID());
		respondent.setDeptName1(userInfo.getDeptName1());
		respondent.setDeptName2(userInfo.getDeptName2());
		respondent.setResponseDate(timeUTC);
		respondent.setImage(userInfo.getUserFileUrl());
		respondent.setCompanyId(userInfo.getCompanyID());
		respondent.setTenantId(userInfo.getTenantId());
		
		return respondent;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getSurveyStatistic(Long surveyId, String realPath, LoginVO userInfo, String adminYN) throws Exception {
		JSONObject result               = new JSONObject();
		JSONObject data                 = new JSONObject();
		Map<String, Object> map         = new HashMap<String, Object>();
		String primary                  = userInfo.getPrimary();
		int tenantId                    = userInfo.getTenantId();
		int totalRespondents            = 0;
		map.put("primary",   primary);
		map.put("offset",    commonUtil.getMinuteUTC(userInfo.getOffset()));
		map.put("userId",    userInfo.getId());
		map.put("tenantId",  tenantId);
		map.put("companyId", userInfo.getCompanyID());
		map.put("surveyId",  surveyId);
		
		SurveyVO survey  = ezSurveyDAO.getSurveyInfo(map);
		
		if (survey == null) {
			result.put("status", "error");
			result.put("code", 3);
			return result;
		}
		
		if (!survey.getCreatorId().equals(userInfo.getId())) {
			//Check public date
			if (adminYN.equals("N") && survey.getResultPublicFlag() == 0) {
				result.put("status", "error");
				result.put("code", 6);
				return result;
			}
			else {
				//Check requirements
				List<Long> checkReceivedSurvey = getUserReceivedSurveyList(userInfo, surveyId);
				List<Long> checkReceivedResultSurvey = getUserReceivedSurveyResultList(userInfo, surveyId);;
				
				if (survey.getResultPublicFlag() != 2 && (checkReceivedSurvey == null || checkReceivedSurvey.size() == 0)) {
					result.put("status", "error");
					result.put("code", 3);
					return result;
				} else if (survey.getResultPublicFlag() == 2 && (checkReceivedResultSurvey == null || checkReceivedResultSurvey.size() == 0)) {
					result.put("status", "error");
					result.put("code", 3); 
					return result;
				}
				
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
				String todayStr            = formatter.format(new Date());
				String endDateStr          = survey.getEndDate().substring(0, 10);
				int openDays               = survey.getOpenDays();
				Date today                 = formatter.parse(todayStr);
				Date endDate               = formatter.parse(endDateStr);
				Calendar calendar          = Calendar.getInstance();
				calendar.setTime(endDate); 
				calendar.add(Calendar.DATE, openDays);
				Date endPublicDate         = calendar.getTime();
				
				if (adminYN.equals("N") && (today.compareTo(endPublicDate) > 0) && survey.getResultPublicFlag() != 2) {
					result.put("status", "error");
					result.put("code", 7);
					return result;
				}
			}
		}
		
		totalRespondents = ezSurveyDAO.getTotalRespondents(map);
		result           = getSurveyQuestions(surveyId, "answer", realPath, userInfo);
		
		data.put("annoynymous"  , survey.getAnonymousFlag());
		data.put("usersCnt"     , survey.getTotalUser());
		data.put("respondentCnt", totalRespondents);
		data.put("title"        , survey.getTitle());
		
		result.put("data", data);
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	private void setSurveyUserInfo(SurveyParticipantVO participant, String primary) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", participant.getCompanyId());
		map.put("deptID", participant.getDeptId());
		map.put("tenantId", participant.getTenantId());
		map.put("userId", participant.getUserId());
		map.put("primary", primary);
		
		/* 2021-08-30 홍승비 - 전자설문 대상자에 사간겸직자가 포함되는 경우 대응 */
		SimpleUserVO user = ezSurveyDAO.getSurveyUserInfo(map);
		if (user == null) {
			user = ezSurveyDAO.getSurveyUserInfoAddJob(map);
		}
		
		participant.setDeptId(user.getDeptId());
		participant.setDeptName(user.getDeptName());
		participant.setDeptName1(user.getDeptName());
		participant.setDeptName2(user.getDeptName2());
		participant.setEmail(user.getMail());
		participant.setUserName(user.getUserName());
		participant.setUserName1(user.getUserName());
		participant.setUserName2(user.getUserName2());
	}
	
	/* 2021-12-07 홍승비 - 전자설문 대상자가 부서인 경우, 삭제한 부서 정보에 접근하지 않도록 수정 */
	private void setSurveyDeptInfo(SurveyParticipantVO participant, String primary) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", participant.getTenantId());
		map.put("deptId", participant.getUserId());
		map.put("primary", primary);
		
		SimpleDeptVO dept = ezSurveyDAO.getSurveyDeptInfo(map);
		if (dept != null) {
			participant.setDeptId(dept.getDeptId());
			participant.setDeptName(dept.getDeptName());
			participant.setDeptName1(dept.getDeptName());
			participant.setDeptName2(dept.getDeptName2());
			participant.setEmail(dept.getMail());
			participant.setUserName(dept.getDeptName());
			participant.setUserName1(dept.getDeptName());
			participant.setUserName2(dept.getDeptName2());
		}
	}
	
	private List<SimpleUserVO> getAllMembersOfCompany(String companyId, String primary, int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("primary"  , primary);
		map.put("tenantId" , tenantId);
		
		return ezSurveyDAO.getAllMembersOfCompany(map);
	}

	@Override
	public List<SurveyVO> getTodaySurveyList(int offset) {
		logger.debug("getTodaySurveyList started.");
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("offset", offset);
		
		logger.debug("getTodaySurveyList ended.");
		return ezSurveyDAO.getTodaySurveyList(map);
	}

	@Override
	public List<SurveyParticipantVO> getSurveyParticipantListForMail(long surveyId, String companyId, int tenantId) {
		logger.debug("getSurveyParticipantListForMail started.");
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("surveyId", surveyId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		logger.debug("getSurveyParticipantListForMail ended.");
		return ezSurveyDAO.getSurveyParticipantListForMail(map);
	}
	
	/* 2021-11-22 홍승비 - 특정 전자설문ID에 대하여 하위부서 허용여부가 Y인 부서/회사 소속원들을 리턴 */
	@Override
	public List<SurveyParticipantVO> getSurveySubDeptListForMail(long surveyId, String companyId, int tenantId) {
		logger.debug("getSurveySubDeptListForMail started.");
		
		List<SurveyParticipantVO> result = new ArrayList<SurveyParticipantVO>();
		Set<SurveyParticipantVO> tempSet = new HashSet<SurveyParticipantVO>();
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_SURVEYID", surveyId);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyId);
		
		// 특정 전자설문ID에 대하여 하위부서 허용여부가 Y인 부서/회사 대상자 ID 리스트로 리턴
		List<String> allSubDeptIDList = ezSurveyDAO.getSurveySubDeptListForMail(map);
		if (allSubDeptIDList.size() > 0) {
			// 해당 부서/회사ID를 상위부서로 가지는 하위부서 소속원들을 result에 포함 (겸직자 포함)
			for (int i = 0; i < allSubDeptIDList.size(); i++) {
				map.put("v_UPPERDEPTID", allSubDeptIDList.get(i));
				
				List<SurveyParticipantVO> lowerDeptVO = ezSurveyDAO.getSurveyLowerDeptUsersForMail(map);
				if (lowerDeptVO.size() > 0) {
					tempSet.addAll(lowerDeptVO);
				}
			}
		}
		
		result.addAll(tempSet);
		
		logger.debug("getSurveySubDeptListForMail ended.");
		return result;
	}
	
	@Override
	public void updateMailSentFlag(long surveyId, int mailSentFlag, String companyId, int tenantId) throws Exception {
		logger.debug("updateMailSentFlag started.");
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("surveyId", surveyId);
		map.put("mailSentFlag", mailSentFlag);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		ezSurveyDAO.updateMailSentFlag(map);
		logger.debug("updateMailSentFlag ended.");
	}
	
	@Override
	public void updateTotalNotiSentFlag(long surveyId, int mailSentFlag, String companyId, int tenantId) throws Exception {
		logger.debug("updateTotalNotiSentFlag started.");
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("surveyId", surveyId);
		map.put("totalNotiSentFlag", 1);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		ezSurveyDAO.updateTotalNotiSentFlag(map);
		logger.debug("updateTotalNotiSentFlag ended.");
	}

	@SuppressWarnings("unchecked")
	@Override
	public JSONObject checkRespondent(Long surveyId, LoginVO userInfo) {
		JSONObject result      = new JSONObject();
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId",  userInfo.getTenantId());
		map.put("companyId", userInfo.getCompanyID());
		map.put("userId",    userInfo.getId());
		map.put("surveyId",  surveyId);
		
		long responseCnt = ezSurveyDAO.checkRespondent(map);
		
		if (responseCnt > -1) {
			result.put("status", "ok");
			result.put("responseCnt", responseCnt);
			result.put("code", 0);
		} else {
			result.put("status", "no");
			result.put("code", 1);
		}
		return result;
	}

	@Override
	public int getSurveyIngCnt(MCommonVO userInfo) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", userInfo.getTenantId());
		map.put("deptId", userInfo.getDeptId());
		map.put("companyId", userInfo.getCompanyId());
		map.put("userId", userInfo.getUserId());
		
		List<String> userDeptList = ezSurveyDAO.getUserDepartmentIdList(map);
		map.put("deptList", userDeptList);
		
		/* 2021-11-19 홍승비 - 전자설문 하위부서 허용여부 체크 > 사용자 직속부서, 겸직부서의 모든 상위부서ID를 전달  */
		List<String> userAllDeptPath = ezSurveyDAO.getUserAllDepartmentIdList(map);
		List<String> userAllDeptList = new ArrayList<String>();
		Set<String> userAllDeptSet = new HashSet<String>();
		
		if (userAllDeptPath.size() > 0) {
			for (int i = 0; i < userAllDeptPath.size(); i++) {
				userAllDeptSet.addAll(Arrays.asList(userAllDeptPath.get(i).split(",")));
			}
		}
		userAllDeptList.addAll(userAllDeptSet);
		map.put("allDeptList", userAllDeptList);
		
		String offset = userInfo.getOffSet();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String timeUTC = commonUtil.getDateStringInUTC(formatter.format(new Date()), offset, true);
		map.put("today", timeUTC);
		
		int result = ezSurveyDAO.getNoAnsweredIngSurveyList(map);
		
		return result;
	}

	@Override
	public String checkTenantConfig(String propertyName, int tenantID) throws Exception {
		logger.debug("getIsUse started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("propertyName", propertyName);
		map.put("tenantID", tenantID);

		return ezSurveyDAO.checkTenantConfig(map);
	}
	
	@Override
	public void setPreviewFlag(String prevMode, String userId, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("prevMode", prevMode);
		
		ezSurveyDAO.setPreviewFlag(map);
	}
	
	// 2024-07-12 전인하 - 설문 > 설문결과 지정공개 대상자 저장
	@Override
	public void saveSurveyResultViewTarget(LoginVO userInfo, Long survey, JSONArray resultViewTarget) throws Exception {
		logger.debug("saveSurveyResultViewTarget started.");
		Map<String,Object> map = new HashMap<String, Object>();
		List<ResultViewPermissionVO> resultViewList = getSurveyResultViewTarget(userInfo, survey);
		
		map.put("survey_id", survey);
		map.put("company_id", userInfo.getCompanyID());
		map.put("tenant_id", userInfo.getTenantId());
		
		if (resultViewList.size() > 0) {
			ezSurveyDAO.deleteResultViewPermission(map);
		}
		
		for (int i = 0; i < resultViewTarget.size(); i++) {
			JSONObject var = (JSONObject) resultViewTarget.get(i);
			map.put("cn", var.get("userId"));
			map.put("user_type",  var.get("userType"));
			map.put("subdept_permitted", var.get("subDeptYN"));
			map.put("cnName",  var.get("userName"));
			map.put("cnName2", var.get("userName2"));
			
			ezSurveyDAO.saveSurveyResultViewTarget(map);
		}
		logger.debug("saveSurveyResultViewTarget end.");
	}

	// 2024-07-12 전인하 - 설문 > 설문결과 지정공개 대상자 리스트 조회
	@Override
	public JSONArray getSurveyResultViewTarget(LoginVO userInfo, Long survey_id) throws Exception {
		logger.debug("saveSurveyResultViewTarget started.");
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("survey_id", survey_id);
		map.put("company_id", userInfo.getCompanyID());
		map.put("tenant_id", userInfo.getTenantId());

		List<ResultViewPermissionVO> resultViewList = ezSurveyDAO.selectResultViewPermission(map);
		
		JSONArray result = new JSONArray();
		for (int i = 0; i< resultViewList.size(); i++) {
			ResultViewPermissionVO var = resultViewList.get(i);
			JSONObject elem = new JSONObject();
			elem.put("userId", var.getCn());
			if (commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
				elem.put("userName", var.getCnName());
			} else {
				elem.put("userName", var.getCnName2());
			}
			elem.put("userName1", var.getCnName());
			elem.put("userName2", var.getCnName2());
			elem.put("subdeptPermitted", var.getSubdept_permitted());
			elem.put("userType", var.getUser_type());
			elem.put("sn", i);
			
			result.add(elem);
		}
		return result;
	}

	// 2024-07-12 전인하 - 설문 > 사용자가 결과조회 가능한 설문 id 조회
	@Override
	public List<Long> getUserReceivedSurveyResultList(LoginVO userInfo, long surveyId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId",  userInfo.getTenantId());
		map.put("deptId",    userInfo.getDeptID());
		map.put("companyId", userInfo.getCompanyID());
		map.put("userId",    userInfo.getId());

		if (surveyId != 0) {
			map.put("surveyId", surveyId);
		}
		
		List<String> userDeptList = ezSurveyDAO.getUserDepartmentIdList(map);
		map.put("deptList", userDeptList);
		
		/* 2021-11-18 홍승비 - 전자설문 하위부서 허용여부 체크 > 사용자 직속부서, 겸직부서의 모든 상위부서ID를 전달  */
		List<String> userAllDeptPath = ezSurveyDAO.getUserAllDepartmentIdList(map);
		List<String> userAllDeptList = new ArrayList<String>();
		Set<String> userAllDeptSet = new HashSet<String>();

		// 상위부서를 전부 포함하는 부서ID+회사ID를 리스트에 담아 쿼리에 전달함 (중복은 set으로 제거)
		if (userAllDeptPath.size() > 0) {
			for (int i = 0; i < userAllDeptPath.size(); i++) {
				userAllDeptSet.addAll(Arrays.asList(userAllDeptPath.get(i).split(",")));
			}
		}
		userAllDeptList.addAll(userAllDeptSet);
		map.put("allDeptList", userAllDeptList);
		
		List<Long> result         = ezSurveyDAO.getReceivedSurveyResultList(map);
		Set<Long> setSurveyIds    = new HashSet<>(result);
		result.clear();
		result.addAll(setSurveyIds);

		return result;
	}
	
	@Override
	public int checkEditingState(long surveyId, String companyId, int tenantId) throws Exception {
		logger.debug("checkEditingState started");
		int res = 0;
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("surveyId", surveyId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		// MODIFY_FLAG : 0(미사용) 1(사용) , USE_STATUS 0(삭제) 1(사용)
		HashMap<String, Object> resMap = ezSurveyDAO.checkEditingState(map);
		if ("0".equals(resMap.get("USE_STATUS").toString())) {
			res = -1;
		} else if ("1".equals(resMap.get("MODIFY_FLAG").toString())) {
			res = 1;
		}
		
		logger.debug("checkEditingState ended");
		return res;
	}

	@Override
	public void deleteResponseItem(long surveyId, LoginVO userInfo) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("surveyId", surveyId);
		map.put("userId", userInfo.getId());
		map.put("tenantId", userInfo.getTenantId());

		ezSurveyDAO.deleteRespondents(map);
		ezSurveyDAO.deleteResponseItems(map);
	}
}