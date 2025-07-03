package egovframework.ezMobile.ezSurvey.service.impl;

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
import java.util.TimeZone;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import egovframework.ezEKP.ezSurvey.service.EzSurveyService;
import egovframework.ezEKP.ezSurvey.vo.SurveyVO;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezSurvey.dao.MSurveyDAO;
import egovframework.ezMobile.ezSurvey.service.MSurveyService;
import egovframework.ezMobile.ezSurvey.vo.MAttachVO;
import egovframework.ezMobile.ezSurvey.vo.MOptionVO;
import egovframework.ezMobile.ezSurvey.vo.MQuestionVO;
import egovframework.ezMobile.ezSurvey.vo.MRespondentVO;
import egovframework.ezMobile.ezSurvey.vo.MResponseVO;
import egovframework.ezMobile.ezSurvey.vo.MSimpleDeptVO;
import egovframework.ezMobile.ezSurvey.vo.MSimpleUserVO;
import egovframework.ezMobile.ezSurvey.vo.MSurveyItemSearchVO;
import egovframework.ezMobile.ezSurvey.vo.MSurveyParticipantVO;
import egovframework.ezMobile.ezSurvey.vo.MSurveyVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("MSurveyService")
public class MSurveyServiceImpl extends EgovFileMngUtil implements MSurveyService {
	private static final Logger logger = LoggerFactory.getLogger(MSurveyServiceImpl.class);
	
	final public int mobileListSize = 20;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "MOptionService")
	private MOptionService mOptionService;
	
	@Resource(name = "MSurveyDAO")
	private MSurveyDAO mSurveyDAO;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name = "EzSurveyService")
	private EzSurveyService ezSurveyService;
	
	/**
	 * 2023-08-03 한태훈 - 모바일 전자설문 > 검색 조건에 맞는 설문 목록 가져오기
	 */
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getItemsBySearching(String pageMode, int start, int end, String title, MCommonVO userInfo, int userMode) throws Exception {
		logger.debug("getItemsBySearching started");
		
		JSONObject result = new JSONObject();
		String userId = userInfo.getUserId();
		int tenantId = userInfo.getTenantId();
		String primary = userInfo.getPrimary();
		String offset = userInfo.getOffSet();
		String offsetMinute = commonUtil.getMinuteUTC(offset);
		int totalItems = 0;
		
		LoginVO userInfoNew = new LoginVO();
		userInfoNew.setId(userInfo.getUserId());
		userInfoNew.setCompanyID(userInfo.getCompanyId());
		userInfoNew.setDeptID(userInfo.getDeptId());
		userInfoNew.setTenantId(userInfo.getTenantId());
		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String endDate = commonUtil.getDateStringInUTC(formatter.format(new Date()), offset, true);		
		title = title.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
		
		MSurveyItemSearchVO searchVO = new MSurveyItemSearchVO(pageMode, start, end, tenantId, userId, primary, offsetMinute, title, endDate, userMode);
		
		if (pageMode.equals("processing") || pageMode.equals("finish") || pageMode.equals("all")) {
			List<Long> listReceivedSurvey = getUserReceivedSurveyList(userInfo, 0);
			List<Long> listReceivedResultSurvey = ezSurveyService.getUserReceivedSurveyResultList(userInfoNew, 0);
			formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String timeUTC = commonUtil.getDateStringInUTC(formatter.format(new Date()), offset, true);
			searchVO.setSurveyIds(listReceivedSurvey);
			searchVO.setSurveyResultIds(listReceivedResultSurvey);
			searchVO.setToday(timeUTC);
		}
		
		totalItems = mSurveyDAO.getTotalReceivedSurveyItemsCnt(searchVO);
		List<MSurveyVO> itemList = mSurveyDAO.getTotalReceivedSurveyItems(searchVO);
		
		result.put("itemList", itemList);
		result.put("totalRows", totalItems);
		result.put("status", "ok");
		result.put("code", 0);
		
		logger.debug("getItemsBySearching ended");
		
		return result;
	}
	
	/**
	 * 2023-08-03 한태훈 - 모바일 전자설문 > 대상자로 속한 설문 목록 가져오기 (전체, 지정 포함)
	 */
	private List<Long> getUserReceivedSurveyList(MCommonVO userInfo, long surveyId) throws Exception{
		logger.debug("getUserReceivedSurveyList started");
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", userInfo.getTenantId());
		map.put("deptId", userInfo.getDeptId());
		map.put("companyId", userInfo.getCompanyId());
		map.put("userId", userInfo.getUserId());
		
		if (surveyId != 0) {
			map.put("surveyId", surveyId);
		}
		
		List<String> userDeptList = mSurveyDAO.getUserDepartmentIdList(map);
		map.put("deptList", userDeptList);
		
		/* 2021-11-18 홍승비 - 전자설문 하위부서 허용여부 체크 > 사용자 직속부서, 겸직부서의 모든 상위부서ID를 전달  */
		List<String> userAllDeptPath = mSurveyDAO.getUserAllDepartmentIdList(map);
		List<String> userAllDeptList = new ArrayList<String>();
		Set<String> userAllDeptSet = new HashSet<String>();
		
		// 상위부서를 전부 포함하는 부서ID + 회사ID를 리스트에 담아 쿼리에 전달함 (중복은 set으로 제거)
		if (userAllDeptPath.size() > 0) {
			for (int i = 0; i < userAllDeptPath.size(); i++) {
				userAllDeptSet.addAll(Arrays.asList(userAllDeptPath.get(i).split(",")));
			}
		}
		
		userAllDeptList.addAll(userAllDeptSet);
		map.put("allDeptList", userAllDeptList);
		
		List<Long> result = mSurveyDAO.getReceivedSurveyList(map);
		Set<Long> setSurveyIds = new HashSet<>(result);
		result.clear();
		result.addAll(setSurveyIds);
		
		logger.debug("getUserReceivedSurveyList ended");
		
		return result;
	}
	
	/**
	 * 2023-07-05 한태훈 - 모바일 전자설문 > 설문 접근 권한 체크
	 */
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject checkPermission(List<Long> surveyList, int mode, MCommonVO userInfo) throws Exception {
		logger.debug("checkPermission started");
		
		JSONObject result = new JSONObject();
		String userId = userInfo.getUserId();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("surveyList", surveyList);
		map.put("userId" , userId);
		map.put("tenantId" , userInfo.getTenantId());
		map.put("companyId" , userInfo.getCompanyId());
		map.put("primary" , userInfo.getPrimary());
		map.put("offset" , commonUtil.getMinuteUTC(userInfo.getOffSet()));
		
		List<MSurveyVO> listSurvey  = mSurveyDAO.getSurveyListForPermission(map);
		
		logger.debug("listSurvey : " + listSurvey.size());
		
		if (listSurvey == null || listSurvey.isEmpty()) {
			result.put("code", 3);
			return result;
		}
		
		List<MSurveyVO> otherSurvey = listSurvey.stream().filter(i -> !i.getCreatorId().equals(userId)).collect(Collectors.toList());
		
		// mode - 설문결과 공개 플래그. 0-비공개, 1-공개, 2-지정공개
		if (mode == 1) { //delete, reuse check
			if (otherSurvey.size() > 0) {
				result.put("code", 3);
				return result;
			}
		} else {
			if (otherSurvey.size() > 0) {
				List<Long> listOtherSurveyId  = otherSurvey.stream().map(MSurveyVO::getSurveyId).collect(Collectors.toList());
				List<Long> listReceivedSurvey = getUserReceivedSurveyList(userInfo, 0);
				List<Long> resultList = new ArrayList<>(listReceivedSurvey);
				
				LoginVO userInfoNew = new LoginVO();
				userInfoNew.setId(userInfo.getUserId());
				userInfoNew.setCompanyID(userInfo.getCompanyId());
				userInfoNew.setDeptID(userInfo.getDeptId());
				userInfoNew.setTenantId(userInfo.getTenantId());
				
				if (mode == 2) {
					List<Long> listReceivedSurveyResult = ezSurveyService.getUserReceivedSurveyResultList(userInfoNew, 0);
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
		
		logger.debug("checkPermission ended");
		return result;
	}
	
	/**
	 *  2023-07-05 한태훈 - 모바일 전자설문 > 설문 정보 가져오기
	 */
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getItemInfo(Long surveyId, String mode, String realPath, MCommonVO userInfo) throws Exception {
		logger.debug("getItemInfo started");
		
		JSONObject result = new JSONObject();
		int tenantId = userInfo.getTenantId();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", userInfo.getCompanyId());
		map.put("primary", userInfo.getPrimary());
		map.put("offset", commonUtil.getMinuteUTC(userInfo.getOffSet()));
		map.put("userId", userInfo.getUserId());
		map.put("surveyId", surveyId);
		
		MSurveyVO survey = mSurveyDAO.getSurveyInfo(map);
		List<MSurveyParticipantVO> listUsers = mSurveyDAO.getSurveyUsers(map);
		
		for (MSurveyParticipantVO surveyParticipant : listUsers) {
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
		List<MAttachVO> surveyAttach = mSurveyDAO.getSurveyAttachList(map);
		
		//Clone attach files
		/* 2023-08-04 한태훈 - 첨부파일 다운로드 시 보안문제로 원본 파일 복사 후 복사된 파일을 다운로드 받을 수 있게 하는 코드이지만, 전자설문 페이지  
		 열 때마다 파일이 복사되는 문제가 있음.
		cloneAttachFiles(surveyAttach, realPath, getSurveyDirPath(tenantId));
		*/
		survey.setAttachList(surveyAttach);
		survey.setUserList(listUsers);
		String strHtml = survey.getPurpose();
        strHtml = strHtml.replace("/fileroot", "/mobile/ezCommon/mFileDown.do?fileName=*.INLINE.*&filePath=/fileroot");
		survey.setPurpose(strHtml);
		
		result.put("survey", survey);
		
		if (mode.equals("normal")) {
			LoginVO login = new LoginVO();
			login.setId(survey.getCreatorId());
			login.setDn("NOPASSWORD");
			login.setTenantId(tenantId);
			
			LoginVO creator = loginService.selectUser(login);
			creator.setDisplayName(userInfo.getPrimary().equals("1") ? userInfo.getUserName() : userInfo.getUserName2());
			
			result.put("creator", creator);
			
		} else if (mode.equals("modify")) {
			//Change modify status only if it's not draft survey
			if (survey.getDraftFlag() == 0) {
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date date = new Date();
				String timeUTC = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffSet(), true);
				survey.setModifyFlag(1);
				survey.setUpdateDate(timeUTC);
				survey.setUpdateUser(userInfo.getUserId());
				survey.setUpdateMode(1);
				
				mSurveyDAO.updateSurveyItem(survey);
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
		int responseCnt = mSurveyDAO.getUserResponseCntForSurvey(map);
		
		if (responseCnt > 0) {
			result.put("resStatus", "true");
		} else {
			result.put("resStatus", "false");
		}

		String finishYN = checkfinishSurvey(survey.getEndDate(), userInfo.getOffSet()); // 설문 종료여부 체크
		result.put("finishYN", finishYN);

		result.put("status", "ok");
		result.put("code", 0);
		//long endTime   = System.nanoTime();
		//long totalTime = endTime - startTime;
		//logger.debug("TOTAL TIME: " + totalTime);
		
		logger.debug("getItemInfo ended");
		
		return result;
	}
	
	/**
	 *  2023-07-05 한태훈 - 모바일 전자설문 > 유저정보 세팅
	 */
	private void setSurveyUserInfo(MSurveyParticipantVO participant, String primary) throws Exception {
		logger.debug("setSurveyUserInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", participant.getCompanyId());
		map.put("deptID", participant.getDeptId());
		map.put("tenantId", participant.getTenantId());
		map.put("userId", participant.getUserId());
		map.put("primary", primary);
		
		/* 2021-08-30 홍승비 - 전자설문 대상자에 사간겸직자가 포함되는 경우 대응 */
		MSimpleUserVO user = mSurveyDAO.getSurveyUserInfo(map);
		if (user == null) {
			user = mSurveyDAO.getSurveyUserInfoAddJob(map);
		}
		
		participant.setDeptId(user.getDeptId());
		participant.setDeptName(user.getDeptName());
		participant.setDeptName1(user.getDeptName());
		participant.setDeptName2(user.getDeptName2());
		participant.setEmail(user.getMail());
		participant.setUserName(user.getUserName());
		participant.setUserName1(user.getUserName());
		participant.setUserName2(user.getUserName2());
		
		logger.debug("setSurveyUserInfo ended");
	}
	
	/**
	 * 2023-07-05 한태훈 - 모바일 전자설문 > 설문 부서정보 세팅
	 */
	private void setSurveyDeptInfo(MSurveyParticipantVO participant, String primary) throws Exception  {
		logger.debug("setSurveyDeptInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", participant.getTenantId());
		map.put("deptId", participant.getUserId());
		map.put("primary", primary);
		
		MSimpleDeptVO dept = mSurveyDAO.getSurveyDeptInfo(map);
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
		
		logger.debug("setSurveyDeptInfo ended");
	}
	

	/* 2023-08-04 한태훈 - cloneAttachFiles 이 첨부파일 다운로드 시 원본 파일의 접근을 막기 위해 원본 파일을 복사하는 작업을 하는 코드인듯 하나,, 
	 첨부파일이 첨부된 전자설문페이지를 열때마다 파일 복사가 일어나 용량이 커지는 문제 생김.
	 
	private String getSurveyDirPath(int tenantId) {
		logger.debug("getSurveyDirPath started");
		
		logger.debug("getSurveyDirPath ended");
		return commonUtil.getUploadPath("upload_survey.ROOT", tenantId) + commonUtil.separator;
	}
	
	
	private void cloneAttachFiles(List<MAttachVO> attachs, String realPath, String dirPath) throws Exception {
		logger.debug("cloneAttachFiles started");
		
		for (MAttachVO attach : attachs) {
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
		
		logger.debug("cloneAttachFiles ended");
	}
	*/
	
	/**
	 * 2023-08-04 한태훈 - 모바일 전자설문 > 설문 질문들 가져오기
	 */
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getSurveyQuestions(Long surveyId, String logicMode, String realPath, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		int tenantId           = userInfo.getTenantId();
		boolean logicFlag      = false;
		int logicCheck         = 1;
		
		Map<Long, List<Long>> logicMap = new HashMap<>();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId",tenantId);
		map.put("companyId", userInfo.getCompanyID());
		map.put("primary", userInfo.getPrimary());
		map.put("offset", commonUtil.getMinuteUTC(userInfo.getOffset()));
		map.put("userId", userInfo.getId());
		map.put("surveyId", surveyId);
		List<MQuestionVO> questions = mSurveyDAO.getAllQuestionsOfSurvey(map);
		
		if (questions != null && questions.size() > 0) {
			List<MOptionVO> options = mSurveyDAO.getAllOptionsOfSurvey(map);
			List<MResponseVO> responses = new ArrayList<>();
			List<Long> questionIds = questions.stream().map(MQuestionVO::getQuestionId).collect(Collectors.toList());
			List<Long> optionIds = options.stream().map(MOptionVO::getOptionId).collect(Collectors.toList());
			map.put("questionIds", questionIds);
			map.put("optionIds" , optionIds);
			List<MAttachVO> attachs = mSurveyDAO.getAllAttachForQsAndOpt(map);
			
			//Clone list of attach
			/* 2023-08-04 한태훈 : 첨부파일 다운로드 시 보안문제로 원본 파일 복사 후 복사된 파일을 다운로드 받을 수 있게 하는 코드이지만, 전자설문 페이지  
			 열 때마다 파일이 복사되는 문제가 있음.
			cloneAttachFiles(attachs, realPath, getSurveyDirPath(tenantId));
			*/
			//long startTime = System.nanoTime();
			
			if (logicMode.equals("answer")) {
				logicCheck = 2; //get options + answers
				map.put("userImageFilePath", commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + commonUtil.separator);
				responses  = mSurveyDAO.getAllResponsesForSurvey(map);
				
			} else if (logicMode.equals("logic")) {
				logicCheck = 1; //get logic map
				
			} else {
				logicCheck = 0; // get only options
			}
			
			//Check if survey has or hasn't logic branching
			if (logicCheck == 1) {
				for (MQuestionVO question : questions) {
					if (question.getLogicFlag() == 1 || question.getSkipFlag() == 1) {
						logicFlag = true;
						break;
					}
				}
			}
			List<MAttachVO> imgTitleList = attachs.stream().filter(a -> a.getTargetType().equals("title")).collect(Collectors.toList());
			attachs.removeAll(imgTitleList); 
			
			//Separate
			List<MAttachVO> qstAttch = attachs.stream().filter(a -> a.getTargetType().equals("question")).collect(Collectors.toList());
			attachs.removeAll(qstAttch);
			
			Map<String, List<MResponseVO>> mapResponses = new HashMap<>();
			if (logicCheck == 2 && responses != null && responses.size() > 0) {
				ListIterator<MResponseVO> respIter = responses.listIterator();
				while (respIter.hasNext()) {
					MResponseVO response = respIter.next();
					int qstType     = response.getQuestionType();
					String checkKey = (qstType == 1 || qstType == 2 || qstType == 9 || qstType == 10 || qstType == 11) ? "opt" + response.getOptionId() : "qst" + response.getQuestionLevel();
					
					if (mapResponses.containsKey(checkKey)) {
						mapResponses.get(checkKey).add(response);
					}
					else {
						List<MResponseVO> optResponse = new ArrayList<>();
						optResponse.add(response);
						mapResponses.put(checkKey, optResponse);
					}
				}
			}
			
			Map<Long, List<MOptionVO>> mapOption = new HashMap<>();
			ListIterator<MOptionVO> optionIter = options.listIterator();
			
			while (optionIter.hasNext()) {
				MOptionVO option = optionIter.next();
				ListIterator<MAttachVO> attIter = attachs.listIterator();
				while (attIter.hasNext()) {
					MAttachVO attach = attIter.next();
					if (attach.getTargetId() == option.getOptionId()) {
						option.setAttach(attach);
						attIter.remove();
					}
				}
				
				if (mapOption.containsKey(option.getQuestionId())) {
					mapOption.get(option.getQuestionId()).add(option);
					
				} else {
					List<MOptionVO> qsOption = new ArrayList<>();
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
			
			for (MQuestionVO question : questions) {
				question.setOption(mapOption.get(question.getQuestionId()));
				
				if (logicFlag) {
					//Process question logic
					List<Long> listQst = new ArrayList<>(processQuestionLogic(question, questions.size()));
					logicMap.put(question.getLevel(), listQst);
				}
				
				ListIterator<MAttachVO> qsAtIter = qstAttch.listIterator();
				while (qsAtIter.hasNext()) {
					MAttachVO qsAttach = qsAtIter.next();
					if (qsAttach.getTargetId() == question.getQuestionId()) {
						question.setAttach(qsAttach);
						qsAtIter.remove();
					}
				}
				
				ListIterator<MAttachVO> imgTitleIter = imgTitleList.listIterator();
				while (imgTitleIter.hasNext()) {
					MAttachVO imgTitle = imgTitleIter.next();
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
	
	/**
	 * 2023-08-07 한태훈 - 모바일 전자설문 > 분기 로직 처리
	 */
	private Set<Long> processQuestionLogic(MQuestionVO question, int totalQs) {
		Set<Long> setQuestionIds = new HashSet<>();
		
		if (question.getSkipFlag() == 1) {
			setQuestionIds.add(question.getSkip());
			
		} else if (question.getLogicFlag() == 1) {
			for (MOptionVO option : question.getOption()) {
				if (option.getLogic() != -1) {
					setQuestionIds.add(option.getLogic());
					
				} else {
					if (question.getLevel() < totalQs) {
						setQuestionIds.add(question.getLevel() + 1);
						
					} else {
						setQuestionIds.add((long) 0);
					}
				}
			}
		} else {
			if (question.getLevel() < totalQs) {
				setQuestionIds.add(question.getLevel() + 1);
				
			} else {
				setQuestionIds.add((long) 0);
			}
		}
		
		return setQuestionIds;
	}
	
	/**
	 * 2023-08-07 한태훈 - 모바일 전자설문 > 응답 내용 저장
	 */
	@SuppressWarnings("unchecked")
	@Override
	public synchronized JSONObject saveResponseItem(JSONArray responses, long surveyId, LoginVO userInfo) throws Exception {
		logger.debug("saveResponseItem started");
		
		JSONObject result = new JSONObject();
		Map<String, Object> map = new HashMap<String, Object>();
		List<MResponseVO> totalResponses = new ArrayList<>();
		List<MRespondentVO> totalUsers = new ArrayList<>();
		long responseId = mSurveyDAO.getMaxResponseId(map);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String timeUTC = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
		map.put("tenantId", userInfo.getTenantId());
		map.put("companyId", userInfo.getCompanyID());
		map.put("primary", userInfo.getPrimary());
		map.put("offset", commonUtil.getMinuteUTC(userInfo.getOffset()));
		map.put("userId", userInfo.getId());
		map.put("surveyId", surveyId);
		MSurveyVO survey = mSurveyDAO.getSurveyInfo(map);
		
		//Check requirements
		List<Long> checkReceivedSurvey = getUserReceivedSurveyList(userInfo, surveyId);
		
		if (checkReceivedSurvey == null || checkReceivedSurvey.size() == 0) {
			result.put("status", "error");
			result.put("code", 6);
			return result;
		}
		
		//Check date
		String todayStr = formatter.format(new Date());
		Date dToday = formatter.parse(todayStr);
		Date dEndDate = formatter.parse(survey.getEndDate());
		Date dStartDate = formatter.parse(survey.getStartDate());
		
		if (dStartDate.compareTo(dToday) > 0) {
			result.put("status", "error");
			result.put("code", 7);
			return result;
		} else if (dToday.compareTo(dEndDate) > 0) {
			result.put("status", "error");
			result.put("code", 8);
			return result;
		}
		
		
		if (survey.getMultiAnswerFlag() == 0) {
			int responseCnt = mSurveyDAO.getUserResponseCntForSurvey(map);
			
			if (responseCnt > 0) {
				// 삭제하는 코드 삽입
				Map<String, Object> resMap = new HashMap<String, Object>();
				resMap.put("surveyId", surveyId);
				resMap.put("userId", userInfo.getId());
				
				mSurveyDAO.deleteRespondents(resMap);
				mSurveyDAO.deleteResponseItems(resMap);
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
			
			int questionType = ((Long)responseObj.get("type")).intValue();
			JSONArray answers = ((JSONArray)responseObj.get("answers"));
			int questionLevel = ((Long)responseObj.get("questionLevel")).intValue();
			String companyId = userInfo.getCompanyID();
			int tenantId = userInfo.getTenantId();
			String userId = userInfo.getId();
			
			for (int j = 0; j < answers.size(); j++, responseId++) {
				JSONObject answerObject = (JSONObject) answers.get(j);
				MResponseVO response = new MResponseVO();
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
		for (MResponseVO res : totalResponses) {
			mSurveyDAO.saveResponseItem(res);
		}
		
		//Save respondents
		for (MRespondentVO user : totalUsers) {
			mSurveyDAO.saveRespondent(user);
		}
		
		if (survey.getResponseFlag() == 0) {
			//Change survey response flag
			survey.setResponseFlag(1);
			survey.setUpdateMode(2);
			mSurveyDAO.updateSurveyItem(survey);
		}
		
		result.put("status", "ok");
		result.put("code", 0);
		
		logger.debug("saveResponseItem ended");
		
		return result;
	}
	
	/**
	 * 2023-08-04 한태훈 - 모바일 전자설문 > 대상자로 포함된 설문 리스트 가져오기
	 */
	private List<Long> getUserReceivedSurveyList(LoginVO userInfo, long surveyId) throws Exception {
		logger.debug("getUserReceivedSurveyList started");
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", userInfo.getTenantId());
		map.put("deptId", userInfo.getDeptID());
		map.put("companyId", userInfo.getCompanyID());
		map.put("userId", userInfo.getId());
		
		if (surveyId != 0) {
			map.put("surveyId", surveyId);
		}
		
		List<String> userDeptList = mSurveyDAO.getUserDepartmentIdList(map);
		map.put("deptList", userDeptList);
		
		/* 2021-11-18 홍승비 - 전자설문 하위부서 허용여부 체크 > 사용자 직속부서, 겸직부서의 모든 상위부서ID를 전달  */
		List<String> userAllDeptPath = mSurveyDAO.getUserAllDepartmentIdList(map);
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
		
		List<Long> result = mSurveyDAO.getReceivedSurveyList(map);
		Set<Long> setSurveyIds = new HashSet<>(result);
		result.clear();
		result.addAll(setSurveyIds);
		
		logger.debug("getUserReceivedSurveyList ended");
		
		return result;
	}
	
	/**
	 * 2023-08-04 한태훈 - 모바일 전자설문 > 질문 응답자 정보 세팅하기
	 */
	private MRespondentVO addRespondent(long surveyId, long responseId, String timeUTC, LoginVO userInfo) {
		logger.debug("addRespondent started");
		
		MRespondentVO respondent = new MRespondentVO();
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
		
		logger.debug("addRespondent ended");
		return respondent;
	}
	
	/**
	 * 2023-08-04 한태훈 - 모바일 전자설문 > 전자설문 결과분석 페이지 표출
	 */
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getSurveyStatistic(Long surveyId, String realPath, LoginVO userInfo, String adminYN) throws Exception {
		logger.debug("getSurveyStatistic started");
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		Map<String, Object> map = new HashMap<String, Object>();
		String primary = userInfo.getPrimary();
		int tenantId = userInfo.getTenantId();
		int totalRespondents = 0;
		map.put("primary", primary);
		map.put("offset", commonUtil.getMinuteUTC(userInfo.getOffset()));
		map.put("userId", userInfo.getId());
		map.put("tenantId", tenantId);
		map.put("companyId", userInfo.getCompanyID());
		map.put("surveyId", surveyId);
		
		MSurveyVO survey  = mSurveyDAO.getSurveyInfo(map);
		
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
			} else {
				//Check requirements
				List<Long> checkReceivedSurvey = getUserReceivedSurveyList(userInfo, surveyId);
				List<Long> checkReceivedResultSurvey = ezSurveyService.getUserReceivedSurveyResultList(userInfo, surveyId);
				
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
					
					logger.debug("getSurveyStatistic ended");
					return result;
				}
			}
		}
		
		totalRespondents = mSurveyDAO.getTotalRespondents(map);
		result = getSurveyQuestions(surveyId, "answer", realPath, userInfo);
		
		data.put("annoynymous"  , survey.getAnonymousFlag());
		data.put("usersCnt"     , survey.getTotalUser());
		data.put("respondentCnt", totalRespondents);
		data.put("title"        , survey.getTitle());
		
		logger.debug("annoynymous : " + survey.getAnonymousFlag());
		logger.debug("usersCnt : " + survey.getTotalUser());
		logger.debug("respondentCnt : " + totalRespondents);
		logger.debug("title : " + survey.getTitle());
		
		result.put("data", data);
		result.put("status", "ok");
		result.put("code", 0);
		
		logger.debug("getSurveyStatistic ended");
		return result;
	}

	private String checkfinishSurvey(String EndStr, String offsetRaw) throws Exception {
		logger.debug("checkfinishSurvey started");
		String finishYN = "N";

		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		String[] parts = offsetRaw.split("\\|");
		String offset = parts[1];
		date.setTimeZone(TimeZone.getTimeZone("GMT" + offset));
		String nowStr = date.format(new Date());

		Date nowDate = date.parse(nowStr);
		Date endDate = date.parse(EndStr);

		finishYN = nowDate.after(endDate) ? "Y" : "N";

		logger.debug("checkfinishSurvey ended");
		return finishYN;
	}
}
