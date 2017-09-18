package egovframework.ezEKP.ezTask.service.impl;

import java.io.File;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;

import egovframework.ezEKP.ezTask.dao.EzTaskDAO;
import egovframework.ezEKP.ezTask.service.EzTaskService;
import egovframework.ezEKP.ezTask.vo.TaskAttachVO;
import egovframework.ezEKP.ezTask.vo.TaskCommentVO;
import egovframework.ezEKP.ezTask.vo.TaskConfigVO;
import egovframework.ezEKP.ezTask.vo.TaskInfoVO;
import egovframework.ezEKP.ezTask.vo.TaskShareVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzTaskService")
public class EzTaskServiceImpl extends FileCopyUtils implements EzTaskService {
	private static final Logger logger = LoggerFactory.getLogger(EzTaskServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzTaskDAO ezTaskDAO;
	
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
	public List<TaskShareVO> getShareList(String taskID, String primary, int tenantID) throws Exception {
		logger.debug("getShareList started.");
		logger.debug("taskID = " + taskID + " || primary = " + primary + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
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
		logger.debug("taskID = " + taskID + " || commentorID = " + commentorID + " || commentorName = " + commentorName + " || commentorName2 = " + commentorName2 + " || comment = " + comment);
		
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
		logger.debug("deleteComment started.");
		logger.debug("taskID = " + taskID + " || commentID = " + commentID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("commentID", commentID);
		map.put("hasComment", "N");
		map.put("tenantID", tenantID);
		
		ezTaskDAO.deleteComment(map);
		ezTaskDAO.updateHasComment(map);
		
		logger.debug("deleteComment ended.");
	}
	
	@Override
	public void updateTaskStatus(String taskID, String taskStatus, String completeRate, int tenantID) throws Exception {
		logger.debug("updateTaskStatus started.");
		logger.debug("taskID = " + taskID + " || taskStatus = " + taskStatus + " || completeRate = " + completeRate);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("taskStatus", taskStatus);
		map.put("completeRate", completeRate);
		map.put("tenantID", tenantID);
		
		ezTaskDAO.updateTaskStatus(map);
		
		logger.debug("updateTaskStatus ended.");
	}
	
	@Override
	public void taskSave(TaskInfoVO taskInfoVO, String realPath, String uploadTaskPath, String content, String fileList, String fileNames, String fileSizes, String offset, int tenantID) throws Exception {
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
			taskInfoVO.setTaskStatus(1);
			taskID = insertTask(taskInfoVO, offset, tenantID);
			
		} else {
			/* task edit */
			updateTask(taskInfoVO, offset, tenantID);
			deleteTaskAttach(taskID, 1, realPath, uploadTaskPath, tenantID);
		}
		
		if (fileList.length() > 0) {
			Map<String, Object> attachMap = new HashMap<String, Object>();
			String pDirPath = realPath + uploadTaskPath + commonUtil.separator;
			File uploadFileFolder = new File(pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + taskID);
			
			logger.debug("fileList = " + fileList);
			logger.debug("fileNamse = " + fileNames);
			
			if (!uploadFileFolder.exists()) {
				uploadFileFolder.mkdirs();
			}
			
			attachMap.put("taskID", taskID);
			attachMap.put("taskType", 1);
			attachMap.put("tenantID", tenantID);
			
			int fileListSize = fileList.split("\\\\").length;
			
			for (int i=0; i<fileListSize; i++) {
				String filePath = fileList.split("\\\\")[i];
				String fileName = fileNames.split("\\\\")[i];
				String fileSize = fileSizes.split("\\\\")[i];

				attachMap.put("fileName", fileName);
				attachMap.put("fileSize", fileSize);
				attachMap.put("filePath", commonUtil.separator + taskID + commonUtil.separator + filePath);
				
				logger.debug("fileName = " + fileName + " || filePath = " + filePath + " || fileSize = " + fileSize);
				
				ezTaskDAO.insertTaskAttach(attachMap);
				
				String beforePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath;
				String afterPath = pDirPath + "uploadFile" + commonUtil.separator + taskID + commonUtil.separator + filePath;
			
				fileMove(beforePath, afterPath);
			}
		}
		
		logger.debug("taskSave ended.");
	}
	
	@Override
	public String taskWorkSave(String taskID, String content, String attachList, String fileNames, String fileSizes, String personAttach, String contentPath, String realPath, String uploadTaskPath, int tenantID) throws Exception {
		logger.debug("taskWorkSave started.");
		logger.debug("taskID = " + taskID + " || content = " + content + " || attachList = " + attachList + " || fileName = " + fileNames + " || fileSize = " + fileSizes + " || personAttach = " + personAttach + " || contentPath = " + contentPath + " || realPath = " + realPath + " || uploadTaskPath = " + uploadTaskPath);
		
		String mhtFilePath = "";
		if (contentPath.equals("")) {
			/* taskWork Write */
			contentPath = "Doc" + commonUtil.separator + "{" + UUID.randomUUID().toString() + "}.mht";
			mhtFilePath = realPath + uploadTaskPath + commonUtil.separator + contentPath;
		} else {
			/* taskWork Edit */
			mhtFilePath = realPath + uploadTaskPath + commonUtil.separator + contentPath;
		}
		
		File folder = new File(realPath + uploadTaskPath + commonUtil.separator + "Doc");
		if (!folder.exists()) {
			folder.mkdirs();
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
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("personAttach", personAttach);
		map.put("personContentPath", contentPath);
		map.put("tenantID", tenantID);
		
		ezTaskDAO.updateTaskWork(map);
		deleteTaskAttach(taskID, 2, realPath, uploadTaskPath, tenantID);
		
		if (attachList.length() > 0) {
			Map<String, Object> attachMap = new HashMap<String, Object>();
			String pDirPath = realPath + uploadTaskPath + commonUtil.separator;
			File uploadFileFolder = new File(pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + taskID);
			
			if (!uploadFileFolder.exists()) {
				uploadFileFolder.mkdirs();
			}

			attachMap.put("taskID", taskID);
			attachMap.put("taskType", 2);
			attachMap.put("tenantID", tenantID);
			
			int fileListSize = attachList.split("\\\\").length;

			for (int i=0; i<fileListSize; i++) {
				String filePath = attachList.split("\\\\")[i];
				String fileName = fileNames.split("\\\\")[i];
				String fileSize = fileSizes.split("\\\\")[i];

				attachMap.put("fileName", fileName);
				attachMap.put("fileSize", fileSize);
				attachMap.put("filePath", commonUtil.separator + taskID + commonUtil.separator + filePath);
				
				ezTaskDAO.insertTaskAttach(attachMap);
				
				String beforePath = pDirPath + "tempUploadFile" + commonUtil.separator + filePath;
				String afterPath = pDirPath + "uploadFile" + commonUtil.separator + taskID + commonUtil.separator + filePath;
				
				fileMove(beforePath, afterPath);
			}
		}
		
		logger.debug("taskWorkSave ended. personContentPath = " + contentPath);
		
		return contentPath;
	}
	
	@Override
	public String getAttachListStr(String taskID, String folderPath, String type, int tenantID) throws Exception {
		logger.debug("getAttachListStr started.");
		logger.debug("taskID = " + taskID + " || folderPath = " + folderPath + " || type = " + type);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("type", type);
		map.put("tenantID", tenantID);
		
		List<TaskAttachVO> list = ezTaskDAO.getAttachList(map);
		
		StringBuilder sb = new StringBuilder();
		for (TaskAttachVO vo : list) {
			String fileName = vo.getFileName();
			String filePath = vo.getFilePath();
			String fileSize = commonUtil.byteCalculation(vo.getFileSize());
			String fileImage = null;

			if (fileName.contains(".jpg") || fileName.contains(".jpeg") || fileName.contains(".bmp") || fileName.contains(".gif") || fileName.contains(".png") || fileName.contains(".tif") || fileName.contains(".tiff") || fileName.contains(".jpeg")) {
				fileImage = "/images/image.png";
			} else if (fileName.contains(".doc")) {
				fileImage = "/images/doc.png";
			} else if (fileName.contains(".xls") || fileName.contains(".xlsx")) {
				fileImage = "/images/xls.png";
			} else if (fileName.contains(".ppt") || fileName.contains(".pptx") || fileName.contains(".pps") || fileName.contains(".ppsx")) {
				fileImage = "/images/ppt.png";
			} else if (fileName.contains(".txt")) {
				fileImage = "/images/txt.png";
			} else if (fileName.contains(".zip")) {
				fileImage = "/images/zip.png";
			} else if (fileName.contains(".pdf")) {
				fileImage = "/images/pdf.png";
			} else if (fileName.contains(".ecm")) {
				fileImage = "/images/ecm.png";
			} else if (fileName.contains(".hwp")) {
				fileImage = "/images/hwp.png";
			} else {
				fileImage = "/images/email/mail_006.gif";
			}

			sb.append("<input type='checkbox' name='fileSelect' value='" + fileName + "' filePath='" + folderPath + filePath + "' fileName='" + commonUtil.cleanValue(fileName) + "'>");
			sb.append("<img src='" + fileImage + "' >");
			sb.append("<a href='/ezTask/downloadAttach.do?filePath=" + URLEncoder.encode(folderPath + filePath, "UTF-8") + "&fileName=" + URLEncoder.encode(fileName, "UTF-8") + "' />");
			sb.append(fileName + "&nbsp;(" + fileSize + ")</a><br>");
		}
		
		logger.debug("getAttachListStr ended. listSize = " + list.size());
		
		return sb.toString();
	}
	
	@Override
	public List<TaskAttachVO> getAttachList(String taskID, String realPath, String type, int tenantID) throws Exception {
		logger.debug("getAttachList started");
		logger.debug("taskID = " + taskID + " || type = " + type);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("type", type);
		map.put("tenantID", tenantID);
		
		List<TaskAttachVO> list = ezTaskDAO.getAttachList(map);
		
		logger.debug("getAttachList ended");
		
		return list;
	}

	@Override
	public TaskConfigVO getOriginColor(String userID, int tenantID) throws Exception {
		logger.debug("getOriginColor started.");
		logger.debug("userID = " + userID + " || tenantID = " + tenantID);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("userID", userID);
		map.put("tenantID", tenantID);

		TaskConfigVO result = ezTaskDAO.getOriginColor(map);

		logger.debug("getOriginColor ended.");
		
		return result;
	}

	@Override
	public void taskSaveConfig(String memberID, String delayColor, String completeColor, int tenantID) throws Exception {
		logger.debug("taskSaveConfig started.");
		logger.debug("memberID : " + memberID + " | delayColor : " + delayColor + " | completeColor : " + completeColor);

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberID", memberID);
		map.put("delayColor", delayColor);
		map.put("completeColor", completeColor);
		map.put("tenantID", tenantID);
		
		ezTaskDAO.taskSaveConfig(map);
		
		logger.debug("taskSaveConfig ended.");
	}

	@Override
	public void taskUpdateConfig(String memberID, String delayColor, String completeColor, int tenantID) throws Exception {
		logger.debug("taskUpdateConfig started.");
		logger.debug("memberID : " + memberID + " | delayColor : " + delayColor + " | completeColor : " + completeColor);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("memberID", memberID);
		map.put("delayColor", delayColor);
		map.put("completeColor", completeColor);
		map.put("tenantID", tenantID);

		ezTaskDAO.taskUpdateConfig(map);

		logger.debug("taskUpdateConfig ended.");
	}

	@Override
	public List<TaskInfoVO> getTaskList(String userID, String startDate, String endDate, String offset,String type, String filter, String chkValue, String searchClass, String taskStatusCount, String primary, int tenantID) throws Exception {
		logger.debug("getTaskList started.");
		logger.debug("userID : " + userID + " | startDate : " + startDate + " | endDate : " + endDate + " | type : " + type + " | filter : " + filter + " | chkValue : " + chkValue + " | searchClass : " + searchClass + " | taskStatusCount : " + taskStatusCount);

		if (!startDate.equals("")) {
			startDate += " 00:00:00";
			endDate += " 23:59:59";
			
			startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
			endDate = commonUtil.getDateStringInUTC(endDate, offset, true);
		}

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("userID", userID);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("type", type);
		map.put("filter", filter);
		map.put("chkValue", chkValue);
		map.put("searchClass", searchClass);
		map.put("taskStatusCount", taskStatusCount);
		map.put("primary", primary);
		map.put("tenantID", tenantID);

		List<TaskInfoVO> list = ezTaskDAO.getTaskList(map); 

		logger.debug("getTaskList ended. listsize = " + list.size());

		return list;
	}

	@Override
	public String getTaskCount(String userID, String offset, String type, String filter, String chkValue, String primary, int tenantID) throws Exception {
		logger.debug("getTaskCount started.");
		logger.debug("userID = " + userID + " || type = " + type + " || filter = " + filter + " || chkValue = " + chkValue);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("userID", userID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("type", type);
		map.put("filter", filter);
		map.put("chkValue", chkValue);
		map.put("primary", primary);
		map.put("tenantID", tenantID);

		String rtnCnt = "";
		String cnt = ezTaskDAO.getTaskCount(map); // 진행업무 중 진행중 count
		String cnt2 = ezTaskDAO.getTaskCount2(map); // 지시,협조 중 진행중 count
		String allCnt = ezTaskDAO.getTaskAllCount(map); // 개인 + 지시,협조 count

		rtnCnt = cnt + "," + cnt2 + "," + allCnt;

		logger.debug("rtnCnt : " + rtnCnt);
		logger.debug("getTaskCount ended.");

		return rtnCnt;
	}

	@Override
	public void taskDelete(String taskIDList, String pDirPath, String offset, String primary, String memberID, int tenantID) throws Exception {
		logger.debug("taskDelete started.");
		logger.debug("memberID = " + memberID + " | taskIDList : " + taskIDList + " | pDirPath : " + pDirPath + " | offset : " + offset + " | primary : " + primary);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("primary", primary);
		map.put("tenantID", tenantID);

		for (String taskID : taskIDList.split(";")) {
			map.put("taskID", taskID);

			TaskInfoVO vo = ezTaskDAO.getTaskInfo(map);

			// 첨부파일이 있으면 첨부파일 삭제
			if (vo.getHasAttach().equals("Y")) {
				deleteDirectory(taskID, pDirPath, tenantID);
			}

			String mhtPath = vo.getContentPath();

			logger.debug("Delete mhtPath : " + mhtPath);

			File file = new File(pDirPath + mhtPath);

			if (file.exists()) {
				file.delete();

				logger.debug("mhtFile Delete Success");
			}

			ezTaskDAO.taskDelete(map);
			deleteTaskShare(taskID, tenantID);
			ezTaskDAO.taskDeleteAttach(map);
		}

		logger.debug("taskDelete ended.");
	}
	
	/** 업무작성 */
	private String insertTask(TaskInfoVO vo, String offset, int tenantID) throws Exception {
		logger.debug("insertTask started.");
		
		String nowDate = commonUtil.getTodayUTCTime("");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("parentID", 0);
		map.put("creatorID", vo.getCreatorID());
		map.put("creatorName", vo.getCreatorName());
		map.put("creatorName2", vo.getCreatorName2());
		map.put("creatorDeptName", vo.getCreatorDeptName());
		map.put("creatorDeptName2", vo.getCreatorDeptName2());
		map.put("creatorEmail", vo.getCreatorEmail());
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
		map.put("personEmail", vo.getPersonEmail());
		map.put("memo", vo.getMemo());
		map.put("tenantID", tenantID);
		
		String taskID = ezTaskDAO.insertTask(map);
		
		if (vo.getHasShare().equals("Y")) {
			for (TaskShareVO shareVO : vo.getShareList()) {
				insertTaskShare(taskID, shareVO, nowDate, tenantID);
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
		
		logger.debug("taskID = " + taskID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("nowDate", nowDate);
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
		map.put("personEmail", vo.getPersonEmail());
		map.put("memo", vo.getMemo());
		map.put("tenantID", tenantID);
		
		ezTaskDAO.updateTask(map);
		
		deleteTaskShare(taskID, tenantID);
		
		if (vo.getHasShare().equals("Y")) {
			for (TaskShareVO shareVO : vo.getShareList()) {
				insertTaskShare(taskID, shareVO, nowDate, tenantID);
			}
		}
		
		logger.debug("updateTask ended. taskID = " + taskID);
		
		return taskID;
	}
	
	/* 공유자 추가 */
	private void insertTaskShare(String taskID, TaskShareVO shareVO, String nowDate, int tenantID) throws Exception {
		logger.debug("insertTaskShare started.");
		logger.debug("taskID = " + taskID + " || sharerID = " + shareVO.getSharerID() + " || sharerDeptName = " + shareVO.getSharerDeptName());
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("sharerID", shareVO.getSharerID());
		map.put("sharerName", shareVO.getSharerName());
		map.put("sharerName2", shareVO.getSharerName2());
		map.put("sharerDeptName", shareVO.getSharerDeptName());
		map.put("sharerDeptName2", shareVO.getSharerDeptName2());
		map.put("sharerEmail", shareVO.getSharerEmail());
		map.put("nowDate", nowDate);
		map.put("tenantID", tenantID);
		
		ezTaskDAO.insertTaskShare(map);
		
		logger.debug("insertTaskShare ended.");
	}
	
	/* 공유자 삭제 */
	private void deleteTaskShare(String taskID, int tenantID) throws Exception {
		logger.debug("deleteTaskShare started.");
		logger.debug("taskID = " + taskID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("tenantID", tenantID);
		
		ezTaskDAO.taskDeleteShare(map);
		
		logger.debug("deleteTaskShare ended.");
	}
	
	/* 첨부파일 삭제 */
	private void deleteTaskAttach(String taskID, int type, String realPath, String uploadTaskPath, int tenantID) throws Exception {
		logger.debug("deleteTaskAttach started.");
		logger.debug("taskID = " + taskID + " || attachType = " + type + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("attachType", type);
		map.put("tenantID", tenantID);
		
		ezTaskDAO.deleteTaskAttach(map);
		
		logger.debug("deleteTaskAttach ended.");
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
