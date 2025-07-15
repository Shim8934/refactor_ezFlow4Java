package egovframework.ezMobile.ezSchedule.service.impl;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.icu.util.Calendar;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezSchedule.dao.EzScheduleDAO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleGoogleService;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.service.impl.EzScheduleCompareUtilPublic;
import egovframework.ezEKP.ezSchedule.vo.AttendantListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleCumulerVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleDeptVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleSecretaryVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezResource.vo.ResScheGetHolidayVO;
import egovframework.ezMobile.ezSchedule.dao.MScheduleDAO;
import egovframework.ezMobile.ezSchedule.service.MScheduleService;
import egovframework.ezMobile.ezSchedule.vo.MScheduleInfoVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.KoreanLunarCalendar;

@Service("MScheduleService")
public class MScheduleServiceImpl extends EgovAbstractServiceImpl implements MScheduleService{
		
	private static final Logger logger = LoggerFactory.getLogger(MScheduleServiceImpl.class);

	@Resource(name="MScheduleDAO")
	private MScheduleDAO mScheduleDAO;
	
	@Resource(name="EzScheduleService")
	private EzScheduleService ezScheduleService;	

	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="EzScheduleDAO")
	private EzScheduleDAO ezScheduleDAO;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Autowired
	private EzScheduleGoogleService googleService;
	
	@Autowired
	private CommonUtil commonUtil;

	@Override
	public int insertSchedule(JSONObject jsonParam, String utcStartDate, String utcEndDate, int tenantId, String realPath, Locale locale, String offSet, String lang) throws Exception {
		//본문내용 MHT 저장
		String mhtPath = commonUtil.separator + "doc";
		/*String uploadFilePath = commonUtil.separator + "uploadFile";*/
		
		String defaultPath = realPath + commonUtil.getUploadPath("upload_schedule.ROOT", tenantId);		
		String contentPath = defaultPath + mhtPath;
		
		File file = new File(contentPath);

		if (!file.exists()) {			
			file.mkdirs();
		}
		
		InputStream stream = null;
		//OutputStream bos = null;		
		int sID = 0;
		
		String schedulePath = commonUtil.separator + "{" + UUID.randomUUID().toString() + "}" + ".mht";
		contentPath += schedulePath;

		try (OutputStream bos = new FileOutputStream(contentPath);) {
			String content = jsonParam.get("content").toString();
			
			if (content == "") content = " ";
			
			//html -> mht변환
			String mhtData = ezCommonService.startHtml2Mht(content, realPath, locale);
			//byte[] ct = Base64.decode(jsonParam.get("content").toString());
			//String mhtData = ezCommonService.startHtml2Mht(new String(ct), realPath, locale);
			
			stream = new ByteArrayInputStream(mhtData.getBytes());
			//bos = new FileOutputStream(contentPath);
	
			int bytesRead = 0;
			byte[] buffer = new byte[2048];
			
			while ((bytesRead = stream.read(buffer, 0, 2048)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
			
			//첨부파일 카운트
			String hasattach = "N";
	
			//비서정보 카운트
			String hasattendant = "N";
			
/*			if(attendantId.getLength() > 0) {				
				hasattendant = "Y";
			}		*/	
			//일정 정보 저장
			schedulePath = mhtPath + schedulePath;
			
			String cycleSet = "";
			String repetitionCycle = "";
			String isAllday = "2".equals(jsonParam.get("dateType").toString()) ? "1" : "0";
			
			cycleSet = jsonParam.containsKey("cycleSet") ? jsonParam.get("cycleSet").toString() : "";
			repetitionCycle = jsonParam.containsKey("repetitionCycle") ? (jsonParam.get("repetitionCycle").toString()).replaceAll(",", "|") : "";
			
			String repetition = "";
			if (cycleSet != "" && repetitionCycle != "") {
				repetition = cycleSet + "|" + isAllday + "|" + repetitionCycle;
			}
			
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("v_OWNERID", jsonParam.get("ownerId").toString());
			map.put("v_OWNERNAME", jsonParam.get("ownerName").toString());
			map.put("v_OWNERNAME2", jsonParam.get("ownerName2").toString());
			map.put("v_CREATORID", jsonParam.get("creatorId").toString());
			map.put("v_CREATORNAME", jsonParam.get("creatorName").toString());
			map.put("v_CREATORNAME2", jsonParam.get("creatorName2").toString());
			map.put("v_SCHEDULETYPE", jsonParam.get("scheduleType").toString());
			map.put("v_IMPORTANCE", jsonParam.get("importance").toString());
			map.put("v_COMPANYID", jsonParam.get("companyID").toString());
			map.put("v_HASATTENDANT", hasattendant);
			map.put("v_HASATTACH", hasattach);
			map.put("v_ISPUBLIC", jsonParam.get("isPublic").toString());
			map.put("v_DATETYPE", jsonParam.get("dateType").toString());
			map.put("v_STARTDATE", utcStartDate);
			map.put("v_ENDDATE", utcEndDate);
			map.put("v_REPETITION", repetition);
			map.put("v_TITLE", jsonParam.get("title").toString());
			map.put("v_LOCATION", jsonParam.get("location").toString());
			map.put("v_CONTENTPATH", schedulePath);
			map.put("v_TENANTID", tenantId);
			map.put("v_SHOWTOP", jsonParam.get("showtop") == null ? "N" : jsonParam.get("showtop").toString());
			
			ezScheduleDAO.insertSchedule(map);
			
			int scheduleId = ezScheduleDAO.getCurScheduleId(null);
			
			/*//첨부파일 저장
			Map<String, Object> attachMap = new HashMap<String, Object>();
						
			for (int i=0; i < attach.getLength(); i++) {
				String[] files = attach.item(i).getTextContent().split("/");				
				String fileName = files[1];
				String filePath = files[0];
				String fileSize = files[2];
				
				filePath = uploadFilePath + commonUtil.separator + filePath;

				attachMap.put("v_SCHEDULEID", scheduleId);
				attachMap.put("v_FILENAME", fileName);
				attachMap.put("v_FILEPATH", filePath);
				attachMap.put("v_FILESIZE", fileSize);
				attachMap.put("v_TENANTID", tenantId);
				
				ezScheduleDAO.insertScheduleAttach(attachMap);
			}					
			
			//참석자 관련 데이터 저장 로직			
			for (int i=0; i < attendantId.getLength(); i++) {								
				String v_attendantId = attendantId.item(i).getTextContent();				
				String v_attendantName = attendantName.item(i).getTextContent();
				String v_attendantName2 = attendantName2.item(i).getTextContent();
				String v_attendantDeptName = attendantDeptName.item(i).getTextContent();
				String v_attendantDeptName2 = attendantDeptName2.item(i).getTextContent();
				
				insertScheduleAttendant(Integer.toString(scheduleId), v_attendantId, v_attendantName, v_attendantName2, v_attendantDeptName, v_attendantDeptName2, tenantId);
			}*/
			// 2023-09-04 한태훈 - 개인 일정의 경우 미리알림 스케줄러에 데이터 추가
			if (jsonParam.get("scheduleType").toString().equals("1")) {
				map.put("v_SCHEDULEID", scheduleId);
				map.put("v_REMINDERSTATUS", "0");
				map.put("v_OFFSET", offSet);
				map.put("v_LANG", lang);
				map.put("v_OFFSETMIN", commonUtil.getMinuteUTC(offSet));
				ezScheduleDAO.insertReminderSchedule(map);
			}
			
			sID = scheduleId;			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (stream != null) stream.close();				
			//if (bos != null) bos.close();
		}
		return sID;
	}

	@Override
	public int insertBoardSchedule(JSONObject jsonParam, String utcStartDate, String utcEndDate, int tenantId, String realPath, Locale locale, String offSet, String lang) throws Exception {
		//본문내용 MHT 저장
		String mhtPath = commonUtil.separator + "doc";
		/*String uploadFilePath = commonUtil.separator + "uploadFile";*/
		
		String defaultPath = realPath + commonUtil.getUploadPath("upload_schedule.ROOT", tenantId);		
		String contentPath = defaultPath + mhtPath;
		
		File file = new File(contentPath);

		if (!file.exists()) {			
			file.mkdirs();
		}
		
		//FileInputStream fis = null;
		//FileOutputStream fos = null;		
		int sID = 0;
		
		String schedulePath = commonUtil.separator + "{" + UUID.randomUUID().toString() + "}" + ".mht";
		contentPath += schedulePath;
			
		String filePath = jsonParam.get("contentPath").toString();
		
		try (FileInputStream fis = new FileInputStream(realPath + filePath); 
				FileOutputStream fos = new FileOutputStream(contentPath)) {
			
			//fis = new FileInputStream(realPath + filePath);
			//fos = new FileOutputStream(contentPath);
	
			int bytesRead = 0;
			byte[] buffer = new byte[2048];
			
			while ((bytesRead = fis.read(buffer, 0, 2048)) != -1) {
				fos.write(buffer, 0, bytesRead);
			}
			
			//첨부파일 카운트
			String hasattach = "N";
	
			//비서정보 카운트
			String hasattendant = "N";
	
			//일정 정보 저장
			schedulePath = mhtPath + schedulePath;
			
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("v_OWNERID", jsonParam.get("ownerId").toString());
			map.put("v_OWNERNAME", jsonParam.get("ownerName").toString());
			map.put("v_OWNERNAME2", jsonParam.get("ownerName2").toString());
			map.put("v_CREATORID", jsonParam.get("creatorId").toString());
			map.put("v_CREATORNAME", jsonParam.get("creatorName").toString());
			map.put("v_CREATORNAME2", jsonParam.get("creatorName2").toString());
			map.put("v_SCHEDULETYPE", jsonParam.get("scheduleType").toString());
			map.put("v_IMPORTANCE", jsonParam.get("importance").toString());
			map.put("v_HASATTENDANT", hasattendant);
			map.put("v_HASATTACH", hasattach);
			map.put("v_ISPUBLIC", jsonParam.get("isPublic").toString());
			map.put("v_DATETYPE", jsonParam.get("dateType").toString());
			map.put("v_STARTDATE", utcStartDate);
			map.put("v_ENDDATE", utcEndDate);
			map.put("v_REPETITION", "");
			map.put("v_TITLE", jsonParam.get("title").toString());
			map.put("v_LOCATION", jsonParam.get("location").toString());
			map.put("v_CONTENTPATH", schedulePath);
			map.put("v_TENANTID", tenantId);
			
			ezScheduleDAO.insertSchedule(map);
			
			int scheduleId = ezScheduleDAO.getCurScheduleId(null);
			
			/*//첨부파일 저장
			Map<String, Object> attachMap = new HashMap<String, Object>();
						
			for (int i=0; i < attach.getLength(); i++) {
				String[] files = attach.item(i).getTextContent().split("/");				
				String fileName = files[1];
				String filePath = files[0];
				String fileSize = files[2];
				
				filePath = uploadFilePath + commonUtil.separator + filePath;

				attachMap.put("v_SCHEDULEID", scheduleId);
				attachMap.put("v_FILENAME", fileName);
				attachMap.put("v_FILEPATH", filePath);
				attachMap.put("v_FILESIZE", fileSize);
				attachMap.put("v_TENANTID", tenantId);
				
				ezScheduleDAO.insertScheduleAttach(attachMap);
			}					
			
			//참석자 관련 데이터 저장 로직			
			for (int i=0; i < attendantId.getLength(); i++) {								
				String v_attendantId = attendantId.item(i).getTextContent();				
				String v_attendantName = attendantName.item(i).getTextContent();
				String v_attendantName2 = attendantName2.item(i).getTextContent();
				String v_attendantDeptName = attendantDeptName.item(i).getTextContent();
				String v_attendantDeptName2 = attendantDeptName2.item(i).getTextContent();
				
				insertScheduleAttendant(Integer.toString(scheduleId), v_attendantId, v_attendantName, v_attendantName2, v_attendantDeptName, v_attendantDeptName2, tenantId);
			}*/
			// 2023-09-04 한태훈 - 개인 일정의 경우 미리알림 스케줄러에 데이터 추가
			if (jsonParam.get("scheduleType").toString().equals("1")) {
				map.put("v_SCHEDULEID", scheduleId);
				map.put("v_REMINDERSTATUS", "0");
				map.put("v_OFFSET", offSet);
				map.put("v_LANG", lang);
				map.put("v_OFFSETMIN", commonUtil.getMinuteUTC(offSet));
				ezScheduleDAO.insertReminderSchedule(map);
			}
			
			sID = scheduleId;			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			//if (fis != null) fis.close();				
			//if (fos != null) fos.close();
		}
		return sID;
	}

	@Override
	public void updateSchedule(JSONObject jsonParam, String utcStartDate, String utcEndDate, String defaultPath, int tenantId, String realPath, Locale locale) throws Exception {
		String cycleSet = "";
		String repetitionCycle = "";
		String isAllday = "2".equals(jsonParam.get("dateType").toString()) ? "1" : "0";

		cycleSet = jsonParam.containsKey("cycleSet") ? jsonParam.get("cycleSet").toString() : "";
		repetitionCycle = jsonParam.containsKey("repetitionCycle") ? (jsonParam.get("repetitionCycle").toString()).replaceAll(",", "|") : "";

		String repetition = "";
		if (cycleSet != "" && repetitionCycle != "") {
			repetition = cycleSet + "|" + isAllday + "|" + repetitionCycle;
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		/*String uploadFilePath = commonUtil.separator + "uploadFile";*/
		
		map.put("v_SCHEDULEID", jsonParam.get("scheduleId").toString());
		map.put("v_MODIFIERID", jsonParam.get("modifierId").toString());
		map.put("v_MODIFIERNAME", jsonParam.get("modifierName").toString());
		map.put("v_MODIFIERNAME2", jsonParam.get("modifierName2").toString());
		map.put("v_IMPORTANCE", jsonParam.get("importance").toString());
		map.put("v_HASATTACH", jsonParam.get("hasAttach").toString());
		map.put("v_ISPUBLIC", jsonParam.get("isPublic").toString());
		map.put("v_DATETYPE", jsonParam.get("dateType").toString());
		map.put("v_SCHEDULETYPE", jsonParam.get("scheduleType").toString());
		map.put("v_TITLE", jsonParam.get("title").toString());
		map.put("v_LOCATION", jsonParam.get("location").toString());
		map.put("v_TENANTID", tenantId);
		map.put("v_SHOWTOP", jsonParam.get("showtop") == null ? "N" : jsonParam.get("showtop").toString());
		
		// 2025-17-15 전인하 - 모바일 > 일정관리 > 모바일 일정수정은 아직 반복일정을 대응하지 않음
		// 따라서 반복일정의 경우 repetition 컬럼 갱신하지 않도록 수정함
		if (!jsonParam.get("dateType").toString().equals("3")) {
			map.put("v_REPETITION", repetition);
			map.put("v_STARTDATE", utcStartDate);
			map.put("v_ENDDATE", utcEndDate);
		}

		ezScheduleDAO.updateSchedule(map);
		
		//mht 내용 변경
		InputStream stream = null;
		//OutputStream bos = null;		
		
		try (OutputStream bos = new FileOutputStream(defaultPath)) {
			String content = jsonParam.get("content").toString();
			
			if (content == "") content = " ";
			
			//html -> mht변환
			String mhtData = ezCommonService.startHtml2Mht(content, realPath, locale);
			
			stream = new ByteArrayInputStream(mhtData.getBytes());
			
			//bos = new FileOutputStream(defaultPath);
			
			int bytesRead = 0;
			byte[] buffer = new byte[2048];
			
			while ((bytesRead = stream.read(buffer, 0, 2048)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (stream != null) stream.close();				
		}

		//첨부파일 경로 삭제
		//ezScheduleDAO.deleteScheduleAttach(map);
		
		/*//첨부파일 정보 등록		
		Map<String, Object> attachMap = new HashMap<String, Object>();
					
		for (int i=0; i < attach.getLength(); i++) {
			String[] files = attach.item(i).getTextContent().split("/");				
			String fileName = files[1];
			String filePath = files[0];
			String fileSize = files[2];
			
			filePath = uploadFilePath + commonUtil.separator + filePath;

			attachMap.put("v_SCHEDULEID", scheduleid);
			attachMap.put("v_FILENAME", fileName);
			attachMap.put("v_FILEPATH", filePath);
			attachMap.put("v_FILESIZE", fileSize);
			attachMap.put("v_TENANTID", tenantId);
			
			ezScheduleDAO.insertScheduleAttach(attachMap);
		}	*/
		
		// 2023-09-15 - 한태훈 : 일정관리 > 미리알림 스케줄러 미완료 상태로 변경.
		map.put("v_REMINDERSTATUS", "0");
		ezScheduleDAO.updateReminderSchedule(map);
	}

	@Override
	public void deleteSchedule(HttpServletRequest request, String scheduleId, int tenantId, MCommonVO info) throws Exception {
		List<AttendantListVO> attendantList = new ArrayList<>();
		ScheduleInfoVO scheduleInfo = ezScheduleService.getScheduleInfo(scheduleId, commonUtil.getMinuteUTC(info.getOffSet()), info.getTenantId(), info.getCompanyId());
		
		String hasAttendant = scheduleInfo.getHasAttendant();
        if (hasAttendant.equals("Y")) {            	
            String parentId = (scheduleInfo.getParentId().equals("0") ? scheduleId : scheduleInfo.getParentId());    
            attendantList = ezScheduleService.getAttendantList(parentId, commonUtil.getMinuteUTC(info.getOffSet()), info.getTenantId(), info.getCompanyId());
        }
        
		if (attendantList != null && attendantList.size() > 0) {
			ezScheduleService.sendInviteScheDelNotiForMobile(request, attendantList, scheduleInfo, info);
		}
		
		ezScheduleService.deleteSchedule(scheduleId, tenantId);
		/*ezScheduleService.deleteResource(scheduleId, tenantId);*/		
	}

	
	@Override
	public void insertScheduleRepeDel(String scheduleId, String startDate, int tenantId) throws Exception {
//		ezScheduleService.insertScheduleRepeDel(scheduleId, startDate, tenantId);
		
	}

	@Override
	public String scheduleContentPath(String scheduleId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SCHEDULEID", scheduleId);		
		map.put("v_TENANTID", tenantId);
		
		return mScheduleDAO.scheduleContentPath(map);
	}

	@Override
	public MScheduleInfoVO scheduleInfo(String scheduleId, String offSetMin, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_OFFSETMIN", offSetMin);
		map.put("v_TENANTID", tenantId);
		
		return mScheduleDAO.scheduleInfo(map);
	}

	@Override
	public List<ScheduleInfoVO> scheduleList(MCommonVO info, String startDate, String endDate, String searchTitle, String searchLocation, String searchAll, String filter) throws Exception {
		String utcStartTime = commonUtil.getDateStringInUTC(startDate, info.getOffSet(), true);
		String utcEndTime = commonUtil.getDateStringInUTC(endDate, info.getOffSet(), true);

		String indiList = "'" + info.getUserId() + "'";
		String pidList = "";
		String pidListSub = "";
		String indiListSub = "";
		String offSetMin = commonUtil.getMinuteUTC(info.getOffSet());
		//2020-02-24 김정언
		String useAnnualScheduleYN = ezCommonService.getTenantConfig("useAnnualScheduleYN", info.getTenantId());
		List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(info.getUserId(), info.getTenantId(), info.getCompanyId());
		List<ScheduleSecretaryVO> tList = ezScheduleService.getPublicScheduleSec(info.getUserId(), info.getLang(), info.getTenantId() ,info.getCompanyId());
		List<ScheduleDeptVO> dList = ezScheduleService.getPublicScheduleDept(info.getUserId(), info.getLang(), info.getTenantId() ,info.getCompanyId());
		List<ScheduleCumulerVO> cList = ezScheduleService.getPublicScheduleCumuler(info.getUserId(), info.getLang(), info.getTenantId() ,info.getCompanyId());

		if(tList != null && tList.size()>0){
			for (int i = 0; i < tList.size(); i++) {
				if (i == 0) {
					indiListSub += ",";
				}
				ScheduleSecretaryVO data = tList.get(i);
				indiListSub += "\'" + data.getSecId()+ "\',";
			}
		}

		pidList = "'" + info.getDeptId() + "'," + "'" + info.getCompanyId() + "'";


		if(dList != null && dList.size()>0){
			for (int i = 0; i < dList.size(); i++) {
				if (i == 0) {
					pidListSub += ",";
				}
				ScheduleDeptVO data = dList.get(i);
				pidListSub += "\'" + data.getDeptId()+ "\',";
			}
		}

		if(cList != null && cList.size()>0 ){
			for (int i = 0; i < cList.size(); i++) {
				if(dList == null || dList.size()<=0){
					if (i == 0) {
						pidListSub += ",";
					}
				}
				ScheduleCumulerVO data = cList.get(i);
				pidListSub += "\'" + data.getDeptId()+ "\',";
			}
		}

		for (int i = 0; i < gList.size(); i++) {
			if((dList == null || dList.size()<=0) && (cList == null || cList.size()<=0)){
				if (i == 0) {
					pidListSub += ",";
				}
			}
			ScheduleGroupListVO data = gList.get(i);
			pidListSub += "\'" + data.getGroupId() + "\',";

				/*if (i != gList.size()-1) {
					pidListSub += ",";
				}*/
		}

		if(indiListSub.equals("") || indiListSub == null){
			indiListSub = ",\'\'";
		}else{
			indiListSub = indiListSub.substring(0, indiListSub.length()-1);
		}

		indiList += indiListSub;

		if(pidListSub.equals("") || pidListSub == null){
			pidListSub = ",\'\'";
		}else{
			pidListSub = pidListSub.substring(0, pidListSub.length()-1);
		}

		pidList += pidListSub;

		List<ScheduleInfoVO> sList = ezScheduleService.getScheduleList(indiList, pidList, filter, utcStartTime, utcEndTime, startDate, endDate, offSetMin, searchTitle, searchLocation, searchAll, info.getTenantId(), info.getCompanyId(), info.getUserId(), info.getDeptId(), useAnnualScheduleYN);

		Collections.sort(sList, new EzScheduleCompareUtilPublic());
		
		return sList;
	}
	
	@Override
	public List<ScheduleInfoVO> scheduleListForWorkspace(MCommonVO info, String startDate, String endDate, String searchTitle) throws Exception {								
		String utcStartTime = commonUtil.getDateStringInUTC(startDate, info.getOffSet(), true);
		String utcEndTime = commonUtil.getDateStringInUTC(endDate, info.getOffSet(), true);
		
		String pidList = "'" + info.getUserId() + "'," + "'" + info.getDeptId() + "'," + "'" + info.getCompanyId() + "'";
		String offSetMin = commonUtil.getMinuteUTC(info.getOffSet());
		List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(info.getUserId(), info.getTenantId(), info.getCompanyId());
		
		for (int i = 0; i < gList.size(); i++) {
			if (i == 0) {
				pidList += ",";
			}
			ScheduleGroupListVO data = gList.get(i);
			pidList += "'" + data.getGroupId() + "'";
			
			if (i != gList.size()-1) {
				pidList += ",";
			}	
		}

		List<ScheduleInfoVO> sList = ezScheduleService.getScheduleListForWorkspace(pidList,"\'\'", "", utcStartTime, utcEndTime, startDate, endDate, "", offSetMin, searchTitle, info.getTenantId(), info.getCompanyId(), info.getUserId(), info.getDeptId());
		
		Collections.sort(sList, new EzScheduleCompareUtilPublic());
		
		return sList;
	}

	@SuppressWarnings("unchecked")
	@Override
	public JSONObject scheduleMainList(MCommonVO info, String listCnt) throws Exception {
		JSONObject jo = new JSONObject();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		
		String startDate = sdf.format(cal.getTime()) + " 00:00:00";
		String endDate = sdf.format(cal.getTime()) + " 23:59:59";
		
		List<ScheduleInfoVO> sList = scheduleList(info, startDate, endDate, "", "", "", "");
		
		String useGoogleCalendar = ezCommonService.getTenantConfig("useGoogleCalendar", info.getTenantId());
		if(useGoogleCalendar.equals("YES")) {
			LoginVO login = new LoginVO();
			login.setId(info.getUserId());
			login.setDn("NOPASSWORD");
			login.setTenantId(info.getTenantId());
			
			LoginVO userInfo = loginService.selectUser(login);
			userInfo.setDisplayName(info.getUserName());
			userInfo.setDisplayName1(info.getUserName2());
			userInfo.setDisplayName2(info.getUserName2());
			
			List<ScheduleInfoVO> googleList = googleService.getGoogleScheduleList(startDate, endDate, "", userInfo, info.getUserId(), "", "");
			sList.addAll(googleList);
			
			Collections.sort(sList, new EzScheduleCompareUtilPublic());
		}
		
		int listSize = sList.size();
		
		jo.put("cnt", listSize);
		
		if (listCnt != null && !listCnt.equals("")) {
			List<ScheduleInfoVO> resultList = new ArrayList<ScheduleInfoVO>();						
			
			int parseCnt = Integer.parseInt(listCnt);
			
			int cnt = 0;
			
			if (parseCnt > listSize) {
				cnt = listSize;
			} else {
				cnt = parseCnt;
			}
			
			for (int i = 0; i < cnt; i++) {
				resultList.add(sList.get(i));
			}
	
			jo.put("list", resultList);
		} else {
			jo.put("list", sList);
		}
		
		return jo;
	}

	@Override
	public List<ScheduleInfoVO> scheduleUserSearchList(MCommonVO info, String startDate, String endDate, String searchTitle) throws Exception {
		String utcStartTime = commonUtil.getDateStringInUTC(startDate, info.getOffSet(), true);
		String utcEndTime = commonUtil.getDateStringInUTC(endDate, info.getOffSet(), true);

		String indiList = "'" + info.getUserId() + "'";
		String pidList = "";
		String pidListSub = "";
		String indiListSub = "";
		String offSetMin = commonUtil.getMinuteUTC(info.getOffSet());

		//근태현황 일정관리 연동 x
		String useAnnualScheduleYN = "0";
		//일정 그룹 사용
		List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(info.getUserId(), info.getTenantId(), info.getCompanyId());
		//List<ScheduleGroupListVO> gList = new ArrayList<ScheduleGroupListVO>();

		//일정 비서 사용 x
		//List<ScheduleSecretaryVO> tList = ezScheduleService.getPublicScheduleSec(info.getUserId(), info.getLang(), info.getTenantId() ,info.getCompanyId());
		List<ScheduleSecretaryVO> tList = new ArrayList<ScheduleSecretaryVO>();

		//공유 부서 사용 x
		//List<ScheduleDeptVO> dList = ezScheduleService.getPublicScheduleDept(info.getUserId(), info.getLang(), info.getTenantId() ,info.getCompanyId());
		List<ScheduleDeptVO> dList = new ArrayList<ScheduleDeptVO>();

		//겸직 부서 사용 x
		//List<ScheduleCumulerVO> cList = ezScheduleService.getPublicScheduleCumuler(info.getUserId(), info.getLang(), info.getTenantId() ,info.getCompanyId());
		List<ScheduleCumulerVO> cList = new ArrayList<ScheduleCumulerVO>();

		if(tList != null && tList.size()>0){
			for (int i = 0; i < tList.size(); i++) {
				if (i == 0) {
					indiListSub += ",";
				}
				ScheduleSecretaryVO data = tList.get(i);
				indiListSub += "\'" + data.getSecId()+ "\',";
			}
		}

		pidList = "'" + info.getDeptId() + "'," + "'" + info.getCompanyId() + "'";


		if(dList != null && dList.size()>0){
			for (int i = 0; i < dList.size(); i++) {
				if (i == 0) {
					pidListSub += ",";
				}
				ScheduleDeptVO data = dList.get(i);
				pidListSub += "\'" + data.getDeptId()+ "\',";
			}
		}

		if(cList != null && cList.size()>0 ){
			for (int i = 0; i < cList.size(); i++) {
				if(dList == null || dList.size()<=0){
					if (i == 0) {
						pidListSub += ",";
					}
				}
				ScheduleCumulerVO data = cList.get(i);
				pidListSub += "\'" + data.getDeptId()+ "\',";
			}
		}

		for (int i = 0; i < gList.size(); i++) {
			if((dList == null || dList.size()<=0) && (cList == null || cList.size()<=0)){
				if (i == 0) {
					pidListSub += ",";
				}
			}
			ScheduleGroupListVO data = gList.get(i);
			pidListSub += "\'" + data.getGroupId() + "\',";

					/*if (i != gList.size()-1) {
						pidListSub += ",";
					}*/
		}

		if(indiListSub.equals("") || indiListSub == null){
			indiListSub = ",\'\'";
		}else{
			indiListSub = indiListSub.substring(0, indiListSub.length()-1);
		}

		indiList += indiListSub;

		if(pidListSub.equals("") || pidListSub == null){
			pidListSub = ",\'\'";
		}else{
			pidListSub = pidListSub.substring(0, pidListSub.length()-1);
		}

		pidList += pidListSub;

		List<ScheduleInfoVO> sList = ezScheduleService.getUserSearchScheduleList(indiList, pidList, "", utcStartTime, utcEndTime, startDate, endDate, "", offSetMin, searchTitle, info.getTenantId(), info.getCompanyId(), info.getUserId(), info.getDeptId(), useAnnualScheduleYN);

		Collections.sort(sList, new EzScheduleCompareUtilPublic());

		return sList;
	}
	
	//휴일가져오기
	@Override
	public List<ResScheGetHolidayVO> getTholiday(int targetYear, String companyId,String userCompany, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyId);
		map.put("v_USERCOMPANY", userCompany);
		map.put("v_TENANTID", tenantId);
		
		List<ResScheGetHolidayVO> list = mScheduleDAO.getTholiday(map);
		
		KoreanLunarCalendar lunarCalendar = KoreanLunarCalendar.newInstance();
				
		for (int i = 0; i < list.size(); i++) {
			String fullDay = list.get(i).getCalendarDay();
			int year = Integer.parseInt(fullDay.split("/")[0]);
			int month = Integer.parseInt(fullDay.split("/")[1]);
			int day = Integer.parseInt(fullDay.split("/")[2]);
			
			if (list.get(i).getIsSolar() == 0) {
				// 반복 휴일일정이면서 음력일경우
				if (list.get(i).getIsRepeat() == 1) {
					year = targetYear;
				}
				
				
				lunarCalendar.setLunarDate(year, month, day, false);
				boolean isLeapMonth = lunarCalendar.isIntercalation();
				if (isLeapMonth) {
					lunarCalendar.setLunarDate(year, month, day, true);
				}
				
				if ((lunarCalendar.getSolarYear() != targetYear) && list.get(i).getIsRepeat() == 1) {
					if (lunarCalendar.getSolarYear() < targetYear) {
						year = targetYear + 1;
					} else if (lunarCalendar.getSolarYear() > targetYear) {
						year = targetYear - 1;
					}
					if (month == 12 && day == 29) {
						day = getLastDayOfLunarMonth(lunarCalendar, year, month);
					}
					
					lunarCalendar.setLunarDate(year, month, day, false);
					isLeapMonth = lunarCalendar.isIntercalation();
					if (isLeapMonth) {
						lunarCalendar.setLunarDate(year, month, day, true);
					}
					
				}
				
				list.get(i).setHolidayDate(String.format("%04d-%02d-%02d", lunarCalendar.getSolarYear(), lunarCalendar.getSolarMonth(), lunarCalendar.getSolarDay()) + " 00:00:00.0");
				list.get(i).setCalendarDay(String.format("%04d-%02d-%02d", lunarCalendar.getSolarYear(), lunarCalendar.getSolarMonth(), lunarCalendar.getSolarDay()));
			} else {
				// 반복 휴일일정이면서 양력일경우
				if (list.get(i).getIsRepeat() == 1) {
					if (list.get(i).getHolidayRepeat() != null) {
						String holidayRepeat = list.get(i).getHolidayRepeat();
						int holidayMonth = Integer.parseInt(holidayRepeat.split("\\|")[1]);
						int holidayWeek = Integer.parseInt(holidayRepeat.split("\\|")[2]);
						int holidayOfWeek = Integer.parseInt(holidayRepeat.split("\\|")[3]) + 1;
						
						Calendar calendar = Calendar.getInstance();
						calendar.set(targetYear, holidayMonth - 1, 1);
						
				        int firstDayOfWeekInMonth = calendar.get(Calendar.DAY_OF_WEEK); 
				        int daysToAdd = holidayOfWeek - firstDayOfWeekInMonth + (7 * (holidayOfWeek >= firstDayOfWeekInMonth ? holidayWeek - 1 : holidayWeek));

				        calendar.add(Calendar.DAY_OF_MONTH, daysToAdd);
				        
				        list.get(i).setHolidayDate(String.format("%04d-%02d-%02d", targetYear, holidayMonth, calendar.get(Calendar.DAY_OF_MONTH)) + " 00:00:00.0");
				        list.get(i).setCalendarDay(String.format("%04d-%02d-%02d", targetYear, holidayMonth, calendar.get(Calendar.DAY_OF_MONTH)));
					} else {
						list.get(i).setHolidayDate(String.format("%04d-%02d-%02d", targetYear, month, day) + " 00:00:00.0");
						list.get(i).setCalendarDay(String.format("%04d-%02d-%02d", targetYear, month, day));
					}
				}
			}
		}
		
		return list;
	}
	
	// 특정 음력 연도와 월의 마지막 날을 찾는 메서드
    public static int getLastDayOfLunarMonth(KoreanLunarCalendar lunarCalendar, int year, int month) {
        int day = 30;
        while (day > 0) {
            lunarCalendar.setLunarDate(year, month, day, false);
            if (lunarCalendar.getLunarDay() == day) {
                break;
            }
            day--;
        }
        return day;
    }

}

