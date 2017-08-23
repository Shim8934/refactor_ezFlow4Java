package egovframework.ezEKP.ezTask.service.impl;

import java.io.File;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezTask.dao.EzTaskDAO;
import egovframework.ezEKP.ezTask.service.EzTaskService;
import egovframework.ezEKP.ezTask.vo.TaskCommentVO;
import egovframework.ezEKP.ezTask.vo.TaskInfoVO;
import egovframework.ezEKP.ezTask.vo.TaskShareVO;
import egovframework.let.user.login.vo.LoginVO;
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
		logger.debug(vo.toString());
		
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

	/* 정수현*/
	@Override
	public String getDelayColor(String memberID, int tenantID) throws Exception {
		logger.debug("getDelayColor started.");
		
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("memberID", memberID);
		map.put("tenantID", tenantID);

		String _delayColor = ezTaskDAO.getDelayColor(map);

		logger.debug("_delayColor : " + _delayColor);
		logger.debug("getDelayColor ended.");
		
		return _delayColor;
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

	@Override
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
		taskInfoVO.setContentPath(userInfo.getTenantId() + commonUtil.separator + "{" + newGuid + "}" + ".mht");
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

			taskInfoVO.setTaskPersonID(doc.getElementsByTagName("CREATORID").item(0).getTextContent());
			taskInfoVO.setTaskPersonName(doc.getElementsByTagName("CREATORNAME1").item(0).getTextContent());
			taskInfoVO.setTaskPersonName2(doc.getElementsByTagName("CREATORNAME2").item(0).getTextContent());
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
		String fileList = doc.getElementsByTagName("FILELIST").item(0).getTextContent();

		logger.debug("OwnerID : " + taskInfoVO.getOwnerID() + " | CreatorName : " + taskInfoVO.getCreatorName() + " | HasShare : " + taskInfoVO.getHasShare() + " | TaskStatus : " + taskInfoVO.getTaskStatus() + " | Importance : " + taskInfoVO.getImportance() + " | ContentPath : " + taskInfoVO.getContentPath());
		logger.debug("HasAttach : " + taskInfoVO.getHasAttach() + " | StartDate : " + taskInfoVO.getStartDate() + " | EndDate : " + taskInfoVO.getEndDate() + " | Title : " + taskInfoVO.getTitle() + " | TaskType : " + taskInfoVO.getTaskType() + " | PersonID : " + taskInfoVO.getPersonID());
		logger.debug("TaskPersonID : " + taskInfoVO.getTaskPersonID() + " | TaskPersonName : " + taskInfoVO.getTaskPersonName() + " | FileList : " + fileList);

		String taskID = ezTaskDAO.taskSave(taskInfoVO);
		
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

			ezTaskDAO.shareTaskSave(taskInfoVO); // Task 테이블에 Insert
			if (!shareID.equals(userInfo.getId())) {
				ezTaskDAO.shareTaskSave2(taskInfoVO); // TaskShare 테이블에 Insert				
			}
		}
		
		PrintWriter pw = null;

		String mhtPath = realPath + commonUtil.getUploadPath("upload_task.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getTenantId() + commonUtil.separator + "{" + newGuid + "}" + ".mht";
		File folderDir = new File(commonUtil.getUploadPath("upload_task.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getTenantId());

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
	}
	
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
		map.put("offset", offset);
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
		map.put("offset", offset);
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
}
