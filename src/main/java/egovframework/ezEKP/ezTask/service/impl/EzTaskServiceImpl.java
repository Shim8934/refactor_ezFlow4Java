package egovframework.ezEKP.ezTask.service.impl;

import java.io.File;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezTask.dao.EzTaskDAO;
import egovframework.ezEKP.ezTask.service.EzTaskService;
import egovframework.ezEKP.ezTask.vo.TaskCommentVO;
import egovframework.ezEKP.ezTask.vo.TaskInfoVO;
import egovframework.ezEKP.ezTask.vo.TaskShareVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzTaskService")
public class EzTaskServiceImpl implements EzTaskService{
	private static final Logger logger = LoggerFactory.getLogger(EzTaskServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzTaskDAO ezTaskDAO;
	
	/* 이효진*/
	@Override
	public TaskInfoVO getTaskInfo(String taskID, String offset, String primary, int tenantID) throws Exception {
		logger.debug("getTaskInfo started.");
		logger.debug("taskID = " + taskID + " || offset = " + offset + " || primary = " + primary + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		
		TaskInfoVO vo = ezTaskDAO.getTaskInfo(map);
		
		logger.debug("getTaskInfo ended.");
		
		return vo;
	}
	
	@Override
	public List<TaskCommentVO> getCommentList(String taskID, String offset, String primary, int tenantID) throws Exception {
		logger.debug("getCommentList started.");
		logger.debug("taskID = " + taskID + " || offset = " + offset + " || primary = " + primary + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		
		List<TaskCommentVO> list = ezTaskDAO.getCommentList(map);
		
		logger.debug("getCommentList ended.");
		logger.debug("listSize = " + list.size());
		
		return list;
	}
	
	@Override
	public List<TaskShareVO> getShareList(String taskID, String offset, String primary, int tenantID) throws Exception {
		//TaskShareVO 내부에 completeDate 있어서 우선 offset 가져오긴하는데 completeDate 사용안할시 VO에서 삭제 및 offset파라미터 제거. 이효진
		logger.debug("getShareList started.");
		logger.debug("taskID = " + taskID + " || offset = " + offset + " || primary = " + primary + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		
		List<TaskShareVO> list = ezTaskDAO.getShareList(map);
		
		logger.debug("getShareList ended.");
		logger.debug("listSize = " + list.size());
		
		return list;
	}
	
	@Override
	public int insertComment(String taskID, String commentorID, String commentorName, String commentorName2, String comment, int tenantID) throws Exception {
		logger.debug("insertComment started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("commentorID", commentorID);
		map.put("commentorName", commentorName);
		map.put("commentorName2", commentorName2);
		map.put("comment", comment);
		map.put("hasComment", "Y");
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		ezTaskDAO.updateHasComment(map);
		int result = ezTaskDAO.insertComment(map);
		
		logger.debug("insertComment ended.");
		
		return result;
	}
	
	@Override
	public void deleteComment(String taskID, String commentID, int tenantID) throws Exception {
		logger.debug("insertComment started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("commentID", commentID);
		map.put("hasComment", "N");
		map.put("tenantID", tenantID);
		
		ezTaskDAO.deleteComment(map);
		ezTaskDAO.updateHasComment(map);
		
		logger.debug("insertComment ended.");
	}
	
	@Override
	public void updateTaskStatus(String taskID, String taskStatus, String completeRate, int tenantID) throws Exception {
		logger.debug("updateTaskStatus started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("taskStatus", taskStatus);
		map.put("completeRate", completeRate);
		map.put("tenantID", tenantID);
		
		ezTaskDAO.updateTaskStatus(map);
		
		logger.debug("updateTaskStatus ended.");
	}
	
	@Override
	public void taskSave(TaskInfoVO taskInfoVO, String realPath, String uploadTaskPath, String content, String fileList, String offset, int tenantID) throws Exception {
		logger.debug("taskSave started.");
		logger.debug("contentPath = " + taskInfoVO.getContentPath());
		
		String taskID = taskInfoVO.getTaskID();
		
		/* mht Save*/
		String mhtFilePath = "";
		if (taskInfoVO.getContentPath().equals("")) {
			/* task Write */
			String contentPath = "Doc" + commonUtil.separator + "{" + UUID.randomUUID().toString() + "}.mht";
			mhtFilePath = realPath + uploadTaskPath + commonUtil.separator + contentPath;
			taskInfoVO.setContentPath(contentPath);
		} else {
			/* task Edit */
			mhtFilePath = realPath + uploadTaskPath + commonUtil.separator + taskInfoVO.getContentPath();
		}
		
		File docFolder = new File(realPath + uploadTaskPath + commonUtil.separator + "Doc");
		if (!docFolder.exists()) {
			docFolder.mkdirs();
		}
		
		PrintWriter pw = null;
		
		try {
			pw = new PrintWriter(new File(mhtFilePath));
			pw.println(content);
			pw.flush();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pw.close();
		}
		
		if (taskID.equals("")) {
			/* task write */
			taskID = insertTask(taskInfoVO, offset, tenantID);
			
		} else {
			/* task edit */
			updateTask(taskInfoVO, offset, tenantID);
			
//			2017-08-28 
//			task에 추가된 파일 전부 삭제
//			deleteAttach(taskID, realPath, uploadTaskPath);
		}
		
		if (taskInfoVO.getHasAttach().equals("Y")) {
			Map<String, Object> attachMap = new HashMap<String, Object>();
			String pDirPath = realPath + uploadTaskPath + commonUtil.separator;
			File uploadFileFolder = new File(pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + taskID);
			
			if (!uploadFileFolder.exists()) {
				uploadFileFolder.mkdirs();
			}
			
			attachMap.put("taskID", taskID);
			attachMap.put("taskType", taskInfoVO.getTaskType());
			attachMap.put("tenantID", tenantID);
			
			for(String fileStr : fileList.split(",")) {
				String[] file = fileStr.split(";");
				String filePath = file[0];
				String fileName = file[1];
				String fileSize = file[2];
				
				attachMap.put("fileName", fileName);
				attachMap.put("fileSize", fileSize);
				attachMap.put("filePath", uploadFileFolder + commonUtil.separator + fileName);
				
				ezTaskDAO.insertTaskAttach(attachMap);
				
				String beforePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath + ";" + fileName;
				String afterPath = pDirPath + "uploadFile" + commonUtil.separator + taskID + filePath + ";" + fileName;
				
				fileMove(beforePath, afterPath);
			}
		}
		
		logger.debug("taskSave ended.");
	}
	
	/** 업무작성 */
	private String insertTask(TaskInfoVO vo, String offset, int tenantID) throws Exception {
		logger.debug("insertTask started.");
		
		String nowDate = commonUtil.getTodayUTCTime("");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("parentID", 0);
		map.put("ownerID", vo.getOwnerID());
		map.put("creatorID", vo.getCreatorID());
		map.put("creatorName", vo.getCreatorName());
		map.put("creatorName2", vo.getCreatorName2());
		map.put("nowDate", nowDate);
		map.put("taskStatus", vo.getTaskStatus());
		map.put("completeRate", 0);
		map.put("completeDate", "");
		map.put("importance", vo.getImportance());
		map.put("hasShare", vo.getHasShare());
		map.put("hasAttach", vo.getHasAttach());
		map.put("startDate", commonUtil.getDateStringInUTC(vo.getStartDate(), offset, true));
		map.put("endDate", commonUtil.getDateStringInUTC(vo.getEndDate(), offset, true));
		map.put("title", vo.getTitle());
		map.put("contentPath", vo.getContentPath());
		map.put("taskType", vo.getTaskType());
		map.put("personID", vo.getPersonID());
		map.put("personName", vo.getPersonName());
		map.put("personName2", vo.getPersonName2());
		map.put("personDeptName", vo.getPersonDeptName());
		map.put("personDeptName2", vo.getPersonDeptName2());
		map.put("tenantID", tenantID);
		
		String taskID = ezTaskDAO.insertTask(map);
		vo.setTaskID(taskID);
		
		if (vo.getHasShare().equals("Y")) {
			for (TaskShareVO shareVO : vo.getShareList()) {
				insertTaskShare(vo, shareVO, nowDate, offset, tenantID);
			}
		}
		
		logger.debug("insertTask ended. taskID = " + taskID);
		
		return taskID;
	}
	
	/** 업무수정 */
	private String updateTask(TaskInfoVO vo, String offset, int tenantID) throws Exception {
		logger.debug("updateTask started.");
		
		String taskID = vo.getTaskID();
		String nowDate = commonUtil.getTodayUTCTime("");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("nowDate", nowDate);
		map.put("taskStatus", vo.getTaskStatus());
		map.put("completeRate", 0);
		map.put("completeDate", "");
		map.put("importance", vo.getImportance());
		map.put("hasShare", vo.getHasShare());
		map.put("hasAttach", vo.getHasAttach());
		map.put("startDate", commonUtil.getDateStringInUTC(vo.getStartDate(), offset, true));
		map.put("endDate", commonUtil.getDateStringInUTC(vo.getEndDate(), offset, true));
		map.put("title", vo.getTitle());
		map.put("taskType", vo.getTaskType());
		map.put("personID", vo.getPersonID());
		map.put("personName", vo.getPersonName());
		map.put("personName2", vo.getPersonName2());
		map.put("personDeptName", vo.getPersonDeptName());
		map.put("personDeptName2", vo.getPersonDeptName2());
		map.put("tenantID", tenantID);
		
		ezTaskDAO.updateTask(map);
		
		deleteTaskShare(taskID, tenantID);
		
		if (vo.getHasShare().equals("Y")) {
			for (TaskShareVO shareVO : vo.getShareList()) {
				insertTaskShare(vo, shareVO, nowDate, offset, tenantID);
			}
		}
		
		logger.debug("updateTask ended. taskID = " + taskID);
		
		return taskID;
	}
	
	/* 공유자 추가 */
	private void insertTaskShare(TaskInfoVO vo, TaskShareVO shareVO, String nowDate, String offset, int tenantID) throws Exception {
		logger.debug("insertTaskShare started.");
		logger.debug("taskID = " + vo.getTaskID() + " || sharerID = " + shareVO.getSharerID() + " || sharerDeptName = " + shareVO.getSharerDeptName());
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", vo.getTaskID());
		map.put("sharerID", shareVO.getSharerID());
		map.put("sharerName", shareVO.getSharerName());
		map.put("sharerName2", shareVO.getSharerName2());
		map.put("sharerDeptName", shareVO.getSharerDeptName());
		map.put("sharerDeptName2", shareVO.getSharerDeptName2());
		
		map.put("parentID", vo.getTaskID());
		map.put("ownerID", vo.getOwnerID());
		map.put("creatorID", vo.getCreatorID());
		map.put("creatorName", vo.getCreatorName());
		map.put("creatorName2", vo.getCreatorName2());
		map.put("nowDate", nowDate);
		map.put("taskStatus", vo.getTaskStatus());
		map.put("completeRate", 0);
		map.put("completeDate", "");
		map.put("importance", vo.getImportance());
		map.put("hasShare", vo.getHasShare());
		map.put("hasAttach", vo.getHasAttach());
		map.put("startDate", commonUtil.getDateStringInUTC(vo.getStartDate(), offset, true));
		map.put("endDate", commonUtil.getDateStringInUTC(vo.getEndDate(), offset, true));
		map.put("title", vo.getTitle());
		map.put("contentPath", vo.getContentPath());
		map.put("taskType", vo.getTaskType());
		map.put("personID", vo.getPersonID());
		map.put("personName", vo.getPersonName());
		map.put("personName2", vo.getPersonName2());
		map.put("personDeptName", vo.getPersonDeptName());
		map.put("personDeptName2", vo.getPersonDeptName2());
		map.put("insertType", "share");
		map.put("tenantID", tenantID);
		
		ezTaskDAO.insertTaskShare(map);
		ezTaskDAO.insertTask(map);
		
		logger.debug("insertTaskShare ended.");
	}
	
	/* 공유자 삭제 */
	private void deleteTaskShare(String taskID, int tenantID) throws Exception {
		logger.debug("deleteTaskShare started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("deleteType", "parent");
		map.put("tenantID", tenantID);
		
		ezTaskDAO.taskDelete(map);
		ezTaskDAO.taskDeleteShare(map);
		
		logger.debug("deleteTaskShare ended.");
	}
	
	/* 첨부파일 삭제 */
	private void deleteTaskAttach(String taskID, String realPath, String uploadTaskPath) throws Exception {
//		2017-08-28
	}
	
	@Override
	public void taskWorkSave(String taskID, String content, String attachList, String contentPath, String realPath, String uploadTaskPath, int tenantID) throws Exception {
		logger.debug("taskWorkSave started.");
		logger.debug("taskID = " + taskID + " || content = " + content + " || attachList = " + attachList + " || contentPath = " + contentPath + " || realPath = " + realPath + " || uploadTaskPath = " + uploadTaskPath);
		
		String filePath = "";
		if (contentPath.equals("")) {
			/* taskWork Write */
			filePath = realPath + uploadTaskPath + commonUtil.separator + "Doc" + commonUtil.separator + UUID.randomUUID().toString() + ".mht";
			contentPath = "Doc" + commonUtil.separator + UUID.randomUUID().toString() + ".mht";
		} else {
			/* taskWork Edit */
			filePath = realPath + uploadTaskPath + commonUtil.separator + contentPath;
		}
		
		File folder = new File(realPath + uploadTaskPath + commonUtil.separator + "Doc");
		if (!folder.exists()) {
			folder.mkdirs();
		}
		
		PrintWriter pw = null;
		
		try {
			pw = new PrintWriter(new File(filePath));
			pw.println(content);
			pw.flush();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pw.close();
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("personAttach", "N");// 파일첨부이후 추가
		map.put("personContentPath", contentPath);
		map.put("tenantID", tenantID);
		
		ezTaskDAO.updateTaskWork(map);
		
		logger.debug("taskWorkSave ended.");
	}

	/* 정수현*/
	@Override
	public String getDelayColor(String userID, int tenantID) throws Exception {
		logger.debug("getDelayColor started.");
		logger.debug("userID = " + userID + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("userID", userID);
		map.put("tenantID", tenantID);

		String result = ezTaskDAO.getDelayColor(map);

		logger.debug("getDelayColor ended. delayColor = " + result);
		
		return result;
	}

	@Override
	public void taskSaveConfig(String memberID, String delayColor, int autoDelete, int tenantID) throws Exception {
		logger.debug("taskSaveConfig started.");
		logger.debug("memberID : " + memberID + " | delayColor : " + delayColor + " | autoDelete : " + autoDelete);

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberID", memberID);
		map.put("delayColor", delayColor);
		map.put("autoDelete", autoDelete);
		map.put("tenantID", tenantID);
		
		ezTaskDAO.taskSaveConfig(map);
		
		logger.debug("taskSaveConfig ended.");
	}

	@Override
	public void taskUpdateConfig(String memberID, String delayColor, int autoDelete, int tenantID) throws Exception {
		logger.debug("taskUpdateConfig started.");
		logger.debug("memberID : " + memberID + " | delayColor : " + delayColor + " | autoDelete : " + autoDelete);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("memberID", memberID);
		map.put("delayColor", delayColor);
		map.put("autoDelete", autoDelete);
		map.put("tenantID", tenantID);

		ezTaskDAO.taskUpdateConfig(map);

		logger.debug("taskUpdateConfig ended.");
	}

	/*@Override
	public String taskSave(Document doc, String realPath, LoginVO userInfo, String newGuid) throws Exception {
		logger.debug("taskSave started.");

		TaskInfoVO taskInfoVO = new TaskInfoVO();

		taskInfoVO.setOwnerID(doc.getElementsByTagName("OWNERID").item(0).getTextContent());
		taskInfoVO.setCreatorID(doc.getElementsByTagName("CREATORID").item(0).getTextContent());
		taskInfoVO.setCreatorName(doc.getElementsByTagName("CREATORNAME1").item(0).getTextContent());
		taskInfoVO.setCreatorName2(doc.getElementsByTagName("CREATORNAME2").item(0).getTextContent());
		taskInfoVO.setHasShare(doc.getElementsByTagName("HASSHARE").item(0).getTextContent());
		taskInfoVO.setHasAttach(doc.getElementsByTagName("HASATTACH").item(0).getTextContent());
		taskInfoVO.setTaskStatus(Integer.parseInt(doc.getElementsByTagName("TASKSTATUS").item(0).getTextContent()));
		taskInfoVO.setImportance(Integer.parseInt(doc.getElementsByTagName("IMPORTANCE").item(0).getTextContent()));
		taskInfoVO.setStartDate(commonUtil.getDateStringInUTC(doc.getElementsByTagName("STARTDATE").item(0).getTextContent(), userInfo.getOffset(), true));
		taskInfoVO.setEndDate(commonUtil.getDateStringInUTC(doc.getElementsByTagName("ENDDATE").item(0).getTextContent(), userInfo.getOffset(), true));
		taskInfoVO.setTitle(commonUtil.cleanValue(doc.getElementsByTagName("TITLE").item(0).getTextContent()));
		taskInfoVO.setContentPath("Doc" + commonUtil.separator + "{" + newGuid + "}" + ".mht");
		taskInfoVO.setTaskType(doc.getElementsByTagName("TASKTYPE").item(0).getTextContent());
		taskInfoVO.setUpdateTime(commonUtil.getTodayUTCTime(""));
		taskInfoVO.setNewAnswer("N");
		taskInfoVO.setNewRefer("N");
		taskInfoVO.setTenantID(userInfo.getTenantId());

		if (taskInfoVO.getTaskType().equals("1")) { // 업무구분 : 개인
			taskInfoVO.setPersonID(doc.getElementsByTagName("PERSONID").item(0).getTextContent());
			taskInfoVO.setPersonName(doc.getElementsByTagName("PERSONNAME1").item(0).getTextContent());
			taskInfoVO.setPersonName2(doc.getElementsByTagName("PERSONNAME2").item(0).getTextContent());
			taskInfoVO.setPersonDeptName(doc.getElementsByTagName("PERSONDEPTNAME1").item(0).getTextContent());
			taskInfoVO.setPersonDeptName2(doc.getElementsByTagName("PERSONDEPTNAME2").item(0).getTextContent());

			taskInfoVO.setTaskPersonID(doc.getElementsByTagName("PERSONID").item(0).getTextContent());
			taskInfoVO.setTaskPersonName(doc.getElementsByTagName("PERSONNAME1").item(0).getTextContent());
			taskInfoVO.setTaskPersonName2(doc.getElementsByTagName("PERSONNAME2").item(0).getTextContent());
		} else { // 업무구분 : 지시, 협조
			taskInfoVO.setPersonID(doc.getElementsByTagName("TASKPERSONID").item(0).getTextContent());
			taskInfoVO.setPersonName(doc.getElementsByTagName("TASKPERSONNAME1").item(0).getTextContent());
			taskInfoVO.setPersonName2(doc.getElementsByTagName("TASKPERSONNAME2").item(0).getTextContent());
			taskInfoVO.setPersonDeptName(doc.getElementsByTagName("TASKPERSONDEPTNAME1").item(0).getTextContent());
			taskInfoVO.setPersonDeptName2(doc.getElementsByTagName("TASKPERSONDEPTNAME2").item(0).getTextContent());
			
			taskInfoVO.setTaskPersonID(doc.getElementsByTagName("TASKPERSONID").item(0).getTextContent());
			taskInfoVO.setTaskPersonName(doc.getElementsByTagName("TASKPERSONNAME1").item(0).getTextContent());
			taskInfoVO.setTaskPersonName2(doc.getElementsByTagName("TASKPERSONNAME2").item(0).getTextContent());			
		}

		int shareLength = Integer.parseInt(doc.getElementsByTagName("SHARELENGTH").item(0).getTextContent());
		String fileList = "";
		
		if (taskInfoVO.getHasAttach().equals("Y")) {
			fileList = doc.getElementsByTagName("FILELIST").item(0).getTextContent();			
		}

		logger.debug("OwnerID : " + taskInfoVO.getOwnerID() + " | CreatorID : " + taskInfoVO.getCreatorID() + " | CreatorName : " + taskInfoVO.getCreatorName() + " | HasShare : " + taskInfoVO.getHasShare() + " | HasAttach : " + taskInfoVO.getHasAttach());
		logger.debug("TaskStatus : " + taskInfoVO.getTaskStatus() + " | Importance : " + taskInfoVO.getImportance() + "StartDate : " + taskInfoVO.getStartDate() + " | EndDate : " + taskInfoVO.getEndDate() + " | Title : " + taskInfoVO.getTitle());
		logger.debug("ContentPath : " + taskInfoVO.getContentPath() + " | TaskType : " + taskInfoVO.getTaskType() + " | FileList : " + fileList);
		logger.debug("PersonID : " + taskInfoVO.getPersonID() + " | PersonName : " + taskInfoVO.getPersonName() + " | TaskPersonID : " + taskInfoVO.getTaskPersonID() + " | TaskPersonName : " + taskInfoVO.getTaskPersonName());

		String taskID = ezTaskDAO.taskSave(taskInfoVO); // taskID 받아옴
		
		logger.debug("taskID : " + taskID);

		taskInfoVO.setTaskID(taskID);
		
		for (int i=0; i<shareLength; i++) {
			String shareID = doc.getElementsByTagName("SHAREID").item(i).getTextContent();
			String shareName1 = doc.getElementsByTagName("SHARENAME1").item(i).getTextContent();
			String shareName2 = doc.getElementsByTagName("SHARENAME2").item(i).getTextContent();
			String shareDeptName1 = doc.getElementsByTagName("SHAREDEPTNAME1").item(i).getTextContent();
			String shareDeptName2 = doc.getElementsByTagName("SHAREDEPTNAME2").item(i).getTextContent();

			taskInfoVO.setOwnerID(shareID);
			taskInfoVO.setPersonID(shareID);
			taskInfoVO.setPersonName(shareName1);
			taskInfoVO.setPersonName2(shareName2);
			taskInfoVO.setPersonDeptName(shareDeptName1);
			taskInfoVO.setPersonDeptName2(shareDeptName2);

			ezTaskDAO.shareTaskSave(taskInfoVO); // Task 테이블에 공유자 Insert
			 이런처리는 조직도스크립트에서 다 되있는것 같은데 빼먹고 안가져와서 여기서 처리하는거 같음
			if (!shareID.equals(userInfo.getId())) {
				ezTaskDAO.shareTaskSave2(taskInfoVO); // TaskShare 테이블에 Insert				
			}
		}
		
		PrintWriter pw = null;

		String mhtPath = realPath + commonUtil.getUploadPath("upload_task.ROOT", userInfo.getTenantId()) + commonUtil.separator + "Doc" + commonUtil.separator + "{" + newGuid + "}" + ".mht";
		File folderDir = new File(realPath + commonUtil.getUploadPath("upload_task.ROOT", userInfo.getTenantId()) + commonUtil.separator + "Doc");

		logger.debug("mhtPath : " + mhtPath + " | folderDirIsExist : " + folderDir.exists());
		
        if (!folderDir.exists()) {
        	folderDir.mkdir();
        }

		try {
			pw = new PrintWriter(new File(mhtPath));
			pw.print(commonUtil.cleanValue(doc.getElementsByTagName("CONTENT").item(0).getTextContent()));
			pw.flush();
			pw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		// 첨부파일 저장
		Map<String, Object> attachMap = new HashMap<String, Object>();

		if (fileList != null && !fileList.equals("")) {
			String pDirPath = realPath + commonUtil.getUploadPath("upload_task.ROOT", userInfo.getTenantId()) + commonUtil.separator;

			File file = new File(pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + taskID + "_uploadFile");

			if (!file.exists()) {
	        	file.mkdir();
	        }

			int fileLength = fileList.split(",").length;
			String[] fileLists = fileList.split(",");

			attachMap.put("taskID", taskID);
			attachMap.put("taskType", taskInfoVO.getTaskType());
			attachMap.put("tenantID", userInfo.getTenantId());

			for (int j=0; j<fileLength; j++) {
				String[] files = fileLists[j].split(";");
				String filePath = files[0];
				String fileName = files[1];
				String fileSize = files[2];

				logger.debug("filePath : " + filePath + " | fileName : " + fileName);

				String uploadFilePath = commonUtil.separator + taskID + "_uploadFile" + commonUtil.separator + filePath + ";" + fileName;
				String beforeFilePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath + ";" + fileName;
				String afterFilePath = pDirPath + "uploadFile" + commonUtil.separator + taskID + "_uploadFile" + commonUtil.separator + filePath + ";" + fileName;

				attachMap.put("fileName", fileName);
				attachMap.put("fileSize", fileSize);
				attachMap.put("filePath", uploadFilePath);
				
				logger.debug("uploadFilePath : " + uploadFilePath);
				
				ezTaskDAO.insertTaskAttach(attachMap);

				fileMove(beforeFilePath, afterFilePath); // Temp 폴더에서 첨부파일 이동
			}
		}
		
		logger.debug("taskSave ended.");

		return "OK";
	}*/
	
	private void fileMove(String beforeFilePath, String afterFilePath) throws Exception {
		logger.debug("fileMove started.");
		logger.debug("beforeFilePath = " + beforeFilePath + " || afterFilePath = " + afterFilePath);

		File file = new File(beforeFilePath);

		try {
			file.renameTo(new File(afterFilePath));
		} catch (Exception e) {
			e.printStackTrace();
		}

		logger.debug("fileMove ended.");
	}

	@Override
	public List<TaskInfoVO> taskGetList(String memberID, String startDate, String endDate, String offset, String app, String type, int tenantID) throws Exception {
		logger.debug("taskGetList started.");
		logger.debug("startDate : " + startDate + " | endDate : " + endDate + " | type : " + type);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberID", memberID);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("type", type);
		map.put("tenantID", tenantID);
		
		List<TaskInfoVO> list = ezTaskDAO.taskGetList(map); 
		
		logger.debug("taskGetList ended.");

		return list;
	}

	@Override
	public String getTaskCount(String memberID, String startDate, String endDate, String offset, String type, int tenantID) throws Exception {
		logger.debug("getTaskCount started.");
		logger.debug("startDate : " + startDate + " | endDate : " + endDate + " | type : " + type);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("memberID", memberID);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("type", type);
		map.put("tenantID", tenantID);

		String rtnCnt = "";
		String cnt = ezTaskDAO.getTaskCount(map); // 진행업무 count
		String cnt2 = ezTaskDAO.getTaskCount2(map); // 지시,협조 count
		
		rtnCnt = cnt + "," + cnt2;

		logger.debug("rtnCnt : " + rtnCnt);
		logger.debug("getTaskCount ended.");

		return rtnCnt;
	}

	@Override
	public void taskDelete(String taskIDList, String pDirPath, String offset, String primary, String memberID, int tenantID) throws Exception {
		logger.debug("taskDelete started.");
		logger.debug("taskIDList : " + taskIDList + " | pDirPath : " + pDirPath + " | offset : " + offset + " | primary : " + primary);

		Map<String, Object> map = new HashMap<String, Object>();

		String[] taskID = taskIDList.split(";");

		for (int i=0; i<taskID.length; i++) {
			map.put("taskID", taskID[i]);
			map.put("offset", commonUtil.getMinuteUTC(offset));
			map.put("primary", primary);
			map.put("tenantID", tenantID);

			TaskInfoVO vo = ezTaskDAO.getTaskInfo(map);

			// 첨부파일이 있으면 첨부파일 삭제
			if (vo.getHasAttach().equals("Y")) {
				deleteDirectory(taskID[i], pDirPath, tenantID);
			}

			String mhtPath = vo.getContentPath();

			logger.debug("Delete mhtPath : " + mhtPath);

			File file = new File(pDirPath + mhtPath);

			if (file.exists()) {
				file.delete();

				logger.debug("mhtFile Delete Success");
			}

			map.put("deleteType", "all");
			
			ezTaskDAO.taskDelete(map);
			ezTaskDAO.taskDeleteShare(map);
			ezTaskDAO.taskDeleteAttach(map);
		}

		logger.debug("taskDelete ended.");
	}

	private void deleteDirectory(String taskID, String pDirpath, int tenantID) throws Exception {
		logger.debug("deleteDirectory ended.");

		File directoryFile = new File(pDirpath + "uploadFile" + commonUtil.separator + taskID + "_uploadFile");
		File[] deleteFileList = directoryFile.listFiles();

		if (directoryFile.exists()) {
			// 디렉토리 하위의 파일을 모두 삭제 한뒤 디렉토리 삭제
			if (deleteFileList.length >0) {
				for (int i=0; i<deleteFileList.length; i++) {
					if (deleteFileList[i].isFile()) {
						deleteFileList[i].delete();
					} else {
						deleteDirectory(taskID, pDirpath, tenantID);
					}
				}
			}

			directoryFile.delete();
		}

		logger.debug("deleteDirectory ended.");
	}
}
