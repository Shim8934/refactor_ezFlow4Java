package egovframework.ezEKP.ezTask.service.impl;

import java.io.File;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import java.util.UUID;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.io.IOUtils;
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
import egovframework.ezEKP.ezTask.vo.TaskGeneralVO;
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
	public TaskInfoVO getTaskInfo(String taskID, String offset, String primary, int tenantID, String companyID) throws Exception {
		logger.debug("getTaskInfo started.");
		logger.debug("taskID = " + taskID + " || offset = " + offset + " || primary = " + primary + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		
		TaskInfoVO vo = ezTaskDAO.getTaskInfo(map);
		
		/* 2020-09-15 홍승비 - 업무관리 제목의 특수문자를 jsp단에서 처리하므로, 하단 XSS 코드 주석처리 */
		String title = vo.getTitle();
		title = commonUtil.detectPathTraversal(title);
		//title = commonUtil.stripScriptTags(title);
		vo.setTitle(title);
		
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
		int listCount = list.size();
		
		for (int i = 0; i < listCount; i++) {
			String comment = list.get(i).getComment();
			comment = commonUtil.stripScriptTags(comment);
			list.get(i).setComment(comment);
		}
		
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
		
		comment = commonUtil.stripScriptTags(comment);
		
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
	public void updateTaskStatus(String taskID, String taskStatus, String tasktype, String repeatCount, String realDate, String completeRate, int tenantID) throws Exception {
		logger.debug("updateTaskStatus started.");
		logger.debug("taskID = " + taskID + " || taskStatus = " + taskStatus + " || completeRate = " + completeRate);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("taskStatus", taskStatus);
		map.put("completeRate", completeRate);
		map.put("tenantID", tenantID);
		map.put("tasktype", tasktype);
		map.put("repeatCount", repeatCount);
		map.put("realDate", realDate);		
		
		if (tasktype.equals("1") || tasktype.equals("2") || tasktype.equals("3")) {
			ezTaskDAO.updateTaskStatus(map);
		}
		else {
			ezTaskDAO.updateRepetionTaskStatus(map);
		}			
		
		logger.debug("updateTaskStatus ended.");
	}
	
	@Override
	public void taskSave(TaskInfoVO taskInfoVO, String realPath, String uploadTaskPath, String content, String fileList, String fileNames, String fileSizes, String offset, int tenantID, String companyID) throws Exception {
		logger.debug("taskSave started.");
		logger.debug("contentPath = " + taskInfoVO.getContentPath());
		
		String taskID = taskInfoVO.getTaskID();
		
		/* 2020-09-15 홍승비 - 업무관리 제목의 특수문자를 jsp단에서 처리하므로, 하단 XSS 코드 주석처리 */
/*		String taskTitle = taskInfoVO.getTitle();
		taskTitle = commonUtil.stripScriptTags(taskTitle);
		taskInfoVO.setTitle(taskTitle);*/
		
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
		
		String docPath = realPath + uploadTaskPath + commonUtil.separator + "Doc";
		docPath = commonUtil.detectPathTraversal(docPath);
		docPath = commonUtil.stripScriptTags(docPath);
		
		File docFolder = new File(docPath);
		if (!docFolder.exists()) {
			docFolder.mkdirs();
		}
		
		PrintWriter pw = null;
		
		mhtFilePath = commonUtil.detectPathTraversal(mhtFilePath);
		mhtFilePath = commonUtil.stripScriptTags(mhtFilePath);
		
		try {
			pw = new PrintWriter(new File(mhtFilePath));
			pw.println(content);
			pw.flush();
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			// 2023-05-17 이사라 : NullPointerException 시큐어코딩
			//pw.close();
			IOUtils.closeQuietly(pw);
		}
		
		if (taskID.equals("")) {
			/* task write */
			taskInfoVO.setTaskStatus(1);
			taskID = insertTask(taskInfoVO, offset, tenantID, companyID);
			
		} else {
			/* task edit */
			updateTask(taskInfoVO, offset, tenantID);
			deleteTaskAttach(taskID, 1, realPath, uploadTaskPath, tenantID);
		}
		
		if (fileList.length() > 0) {
			Map<String, Object> attachMap = new HashMap<String, Object>();
			String pDirPath = realPath + uploadTaskPath + commonUtil.separator;
			String uploadFilePath = pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + taskID;
			uploadFilePath = commonUtil.detectPathTraversal(uploadFilePath);
			uploadFilePath = commonUtil.stripScriptTags(uploadFilePath);
			
			File uploadFileFolder = new File(uploadFilePath);
			
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
				
				filePath = commonUtil.detectPathTraversal(filePath);
				
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
		
		content = commonUtil.stripScriptTags(content);
		
		String folderPath = realPath + uploadTaskPath + commonUtil.separator + "Doc";
		folderPath = commonUtil.detectPathTraversal(folderPath);
		folderPath = commonUtil.stripScriptTags(folderPath);
		
		File folder = new File(folderPath);
		if (!folder.exists()) {
			folder.mkdirs();
		}
		
		PrintWriter pw = null;
		String mhtFile = commonUtil.detectPathTraversal(mhtFilePath);
		mhtFile = commonUtil.stripScriptTags(mhtFile);
		
		try {
			pw = new PrintWriter(new File(mhtFile));
			pw.println(content);
			pw.flush();
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			// 2023-05-17 이사라 : NullPointerException 시큐어코딩
			//pw.close();
			IOUtils.closeQuietly(pw);
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
			String uploadFilePath = pDirPath + commonUtil.separator + "uploadFile" + commonUtil.separator + taskID;
			uploadFilePath = commonUtil.detectPathTraversal(uploadFilePath);
			uploadFilePath = commonUtil.stripScriptTags(uploadFilePath);
			
			File uploadFileFolder = new File(uploadFilePath);
			
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
				
				filePath = commonUtil.detectPathTraversal(filePath);
				
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
			filePath = commonUtil.detectPathTraversal(filePath);
			
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

			sb.append("<div class='custom_checkbox'><input type='checkbox' name='fileSelect' value='" + fileName + "' filePath='" + folderPath + filePath + "' fileName='" + commonUtil.cleanValue(fileName) + "'></div>");
			sb.append("<img src='" + fileImage + "' >");
			sb.append("<a href='/ezTask/downloadAttach.do?filePath=" + URLEncoder.encode(folderPath + filePath, "UTF-8") + "&fileName=" + URLEncoder.encode(fileName, "UTF-8") + "' />");
			sb.append(commonUtil.cleanValue(fileName) + "&nbsp;(" + fileSize + ")</a><br>");
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
		int listSize = list.size();
		
		for (int i = 0; i < listSize; i++) {
			String filePath = list.get(i).getFilePath();
			filePath = commonUtil.detectPathTraversal(filePath);
			list.get(i).setFilePath(filePath);
		}
		
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
		map.put("initColor", "#FF1B1B");
		map.put("initColor2", "#8DFF1B");
		
		TaskConfigVO result = ezTaskDAO.getOriginColor(map);
		
		if (result == null) {
			ezTaskDAO.insertTaskGeneral(map);
			result = ezTaskDAO.getOriginColor(map);
		}
		
		logger.debug("getOriginColor ended.");
		
		return result;
	}

	@Override
	public void taskSaveConfig(String memberID, String delayColor, String completeColor, String originColor, String originColor2, int tenantID) throws Exception {
		logger.debug("taskSaveConfig started.");
		logger.debug("memberID : " + memberID + " | delayColor : " + delayColor + " | completeColor : " + completeColor + " | originColor : " + originColor + " | originColor2 : " + originColor2);
		
		delayColor = commonUtil.stripScriptTags(delayColor);
		completeColor = commonUtil.stripScriptTags(completeColor);
		originColor = commonUtil.stripScriptTags(originColor);
		originColor2 = commonUtil.stripScriptTags(originColor2);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberID", memberID);
		map.put("delayColor", delayColor);
		map.put("completeColor", completeColor);
		map.put("originColor", originColor);
		map.put("originColor2", originColor2);
		map.put("tenantID", tenantID);
		
		ezTaskDAO.taskSaveConfig(map);
		
		logger.debug("taskSaveConfig ended.");
	}

	@Override
	public void taskUpdateConfig(String memberID, String delayColor, String completeColor, String originColor, String originColor2, int tenantID) throws Exception {
		logger.debug("taskUpdateConfig started.");
		logger.debug("memberID : " + memberID + " | delayColor : " + delayColor + " | completeColor : " + completeColor + " | originColor : " + originColor);

		delayColor = commonUtil.stripScriptTags(delayColor);
		completeColor = commonUtil.stripScriptTags(completeColor);
		originColor = commonUtil.stripScriptTags(originColor);
		originColor2 = commonUtil.stripScriptTags(originColor2);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("memberID", memberID);
		map.put("delayColor", delayColor);
		map.put("completeColor", completeColor);
		map.put("originColor", originColor);
		map.put("originColor2", originColor2);
		map.put("tenantID", tenantID);

		ezTaskDAO.taskUpdateConfig(map);

		logger.debug("taskUpdateConfig ended.");
	}
	
	

	@Override
	public List<TaskInfoVO> getTaskList(String userID, String startDate, String endDate, String offset,String type, String filter, String chkValue, String searchClass, String taskStatusCount, String primary, String pSelectTab, int tenantID, String companyID) throws Exception {
		logger.debug("getTaskList started.");
		logger.debug("userID : " + userID + " | startDate : " + startDate + " | endDate : " + endDate + " | type : " + type + " | filter : " + filter + " | chkValue : " + chkValue + " | searchClass : " + searchClass + " | taskStatusCount : " + taskStatusCount + " | pSelectTab : " + pSelectTab);

		if (!startDate.equals("")) {			
			startDate += " 00:00:00";
			endDate += " 23:59:59";
			
			startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
			endDate = commonUtil.getDateStringInUTC(endDate, offset, true);
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String[] offsetArr = offset.split("\\|");
		
		sdf.setTimeZone(TimeZone.getTimeZone("GMT" + offsetArr[1]));
	    String utcTime = sdf.format(new Date());	

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
		map.put("today", utcTime);
		map.put("v_COMPANYID", companyID);

		List<TaskInfoVO> list = ezTaskDAO.getTaskList(map);
		logger.debug("--------------------------------------------------------------");
		
		/* 2020-09-15 홍승비 - 업무관리 제목의 특수문자를 jsp단에서 처리하므로, 하단 XSS 코드 주석처리 */
/*		for(TaskInfoVO v: list) {
			logger.debug("Task ID: " + v.getTaskID() + " || Task type: " + v.getTaskType());
			String taskTitle = v.getTitle();
			taskTitle = commonUtil.stripScriptTags(taskTitle);
			v.setTitle(taskTitle);
		}*/
		
		logger.debug("--------------------------------------------------------------");
		
		List<TaskInfoVO> resultList = new ArrayList<TaskInfoVO>();
		List<TaskInfoVO> tempResultList = new ArrayList<TaskInfoVO>();
		
		for (int i=0; i < list.size(); i++) {		
			TaskInfoVO vo = list.get(i);
			
			if (pSelectTab.equals("taskprog")) {
				if (vo.getTaskType().equals("1")) {
					resultList.add(vo);
				}
				
				if (vo.getTaskType().equals("2") || vo.getTaskType().equals("3")) {
					if (!userID.equals(vo.getCreatorID())) {
						resultList.add(vo);
					}	
				}
			}
			else if (pSelectTab.equals("taskdictate")) {
				if (vo.getTaskType().equals("2") || vo.getTaskType().equals("3") || vo.getTaskType().equals("5") || vo.getTaskType().equals("6")) {
					if (userID.equals(vo.getCreatorID())) {
						resultList.add(vo);
					}			
				}
			}
			else if (pSelectTab.equals("taskrepetition")) {
				if (vo.getTaskType().equals("4") ) {
					//Check if this task has been deleted
					if (vo.getTotalRep() != 0) {
						resultList.add(vo);
					}
				}
				if (vo.getTaskType().equals("5") || vo.getTaskType().equals("6")) {
					if (!userID.equals(vo.getCreatorID())) {
						//Check if this task has been deleted
						if (vo.getTotalRep() != 0) {
							resultList.add(vo);
						}
					}					
				}
			}
			else {
				//Searching mode
				if (vo.getTaskType().equals("4") || vo.getTaskType().equals("5") || vo.getTaskType().equals("6")) {
					map.put("taskID", vo.getTaskID());
					
					List<String> rList = ezTaskDAO.getTaskRepeDelList(map);
						
					String currentEndDate = vo.getEndDate();
					String[] info = vo.getRepetition().split("\\|");

					if (!info[0].equals("0")) {
						currentEndDate = endDate;
					} // 반복주기 설정범위가 다음회수 반복 후 종료 일때 '0'

					if (currentEndDate.compareTo(endDate) > 0) {
						currentEndDate = endDate;
					}

					int maxCount = Integer.parseInt(info[0]);
					int count = 0;
					boolean isFirst = true;

					if (maxCount == 0) {
						maxCount = -1;
					}

					Calendar sDate_cal = Calendar.getInstance();
					Calendar eDate_cal = Calendar.getInstance();
					Calendar date_cal = Calendar.getInstance();

					//SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					SimpleDateFormat nsdf = new SimpleDateFormat("yyyy-MM-dd");

					logger.debug("startDate : " + startDate + " | endDate : " + endDate + " | currentEndDate : " + currentEndDate);

					sDate_cal.setTime(sdf.parse(startDate));
					eDate_cal.setTime(sdf.parse(currentEndDate));
					date_cal.setTime(sdf.parse(vo.getStartDate()));				

					switch (info[2]) {
						case "0" : // 매일
							while (true) {
								if (date_cal.compareTo(eDate_cal) > 0) break;
								if (maxCount == count) break;
								
								boolean generated = false;
								int dayOFWeek = date_cal.get(Calendar.DAY_OF_WEEK) - 1;
		
								if (info[3].equals("0")) {
									if (dayOFWeek != 0 && dayOFWeek != 6) {
										generated = true;
									}
								} else {
									generated = true;
								}
		
								if (generated) {
									count++;								
									String calcuDate = nsdf.format(date_cal.getTime());

									//2021-09-29 남학선 반복업무 검색시 달성율이 나타나지 않아서 해당 날짜의 완료율을 검색한 후 넣어줌
									String convertDate = calcuDate + " 00:00:00";
									int comRate = selectCompletionOfRepTask(vo.getTaskID(), convertDate, tenantID);
									vo.setCompleteRate(comRate);
		
									//if (calcuDate.compareTo(startDate.substring(0,10)) >= 0 && calcuDate.compareTo(endDate.substring(0,10)) <= 0) {	
									if ((date_cal.compareTo(sDate_cal) >= 0) && (date_cal.compareTo(eDate_cal) <= 0)) {
										//row 추가	
										if (!rList.contains(calcuDate)) {										
											TaskInfoVO rVo = addRepeatRow(vo, date_cal.getTime(), count, info[1]);
											resultList.add(rVo);
										}
									}
								}
								
								if (info[3].equals("0")) {
									date_cal.add(Calendar.DATE, 1);
								} else {
									date_cal.add(Calendar.DATE, Integer.parseInt(info[3]));
								}
							}
						break;
						
						case "1" : //매주
							List<Integer> repeatDayList = new ArrayList<Integer>();
							if(info[4] != null && !info[4].trim().equals("")){
								char[] yoilArr = new char[info[4].length()]; // 스트링을 담을 배열

								for (int j = 0; j < info[4].length(); j++) {
									yoilArr[j] = info[4].charAt(j);					
								}
								int yoilNum;
								for (char yoil : yoilArr) {
									
									yoilNum = yoil - 48;
									repeatDayList.add(yoilNum); 
								}
							}
							count=1;
							maxCount += 1;
							Calendar tempEDate_cal = Calendar.getInstance();
							
							while (true) {
								if (date_cal.compareTo(eDate_cal) > 0) {
									tempEDate_cal.setTime(eDate_cal.getTime());
									tempEDate_cal.add(Calendar.DATE, (Integer.parseInt(info[3])) * 7);
										if(date_cal.compareTo(tempEDate_cal) > 0) {
											break;
										}
								}
								if (maxCount == count) break;
								
									String calcuDate = nsdf.format(date_cal.getTime());

									//2021-09-29 남학선 반복업무 검색시 달성율이 나타나지 않아서 해당 날짜의 완료율을 검색한 후 넣어줌
									String convertDate = calcuDate + " 00:00:00";
									int comRate = selectCompletionOfRepTask(vo.getTaskID(), convertDate, tenantID);
									vo.setCompleteRate(comRate);
									
									//if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 && calcuDate.compareTo(orgEndDate.substring(0,10)) <= 0) {	
									if(info[0].equals("0")){
											for (Integer yoil : repeatDayList) {
												
												date_cal.set(Calendar.DAY_OF_WEEK,yoil+1);
												calcuDate = nsdf.format(date_cal.getTime());
												if (!rList.contains(calcuDate)) {
													logger.debug("vo.getStartDate() : " + vo.getStartDate());
													logger.debug("endDate : " + endDate);
													if (date_cal.getTime().compareTo(sdf.parse(vo.getStartDate())) >= 0 && date_cal.getTime().compareTo(sdf.parse(vo.getEndDate())) <= 0) {
													TaskInfoVO rVo = addRepeatRow(vo, date_cal.getTime(), count, info[1]);									
													tempResultList.add(rVo);
//													resultList.add(rVo);
												}
												
											}
											date_cal.set(Calendar.DAY_OF_WEEK,repeatDayList.get(0)+1);
										}
									}else{
										//row 추가
										for (Integer yoil : repeatDayList) {
											date_cal.set(Calendar.DAY_OF_WEEK,yoil+1);
											calcuDate = nsdf.format(date_cal.getTime());
											if (!rList.contains(calcuDate)) {
												if (date_cal.getTime().compareTo(sdf.parse(vo.getStartDate())) >= 0){
													TaskInfoVO rVo = addRepeatRow(vo, date_cal.getTime(), count, info[1]);									
													tempResultList.add(rVo);
//													resultList.add(rVo);
												}
											}
											date_cal.set(Calendar.DAY_OF_WEEK,repeatDayList.get(0)+1);
										}
									}
								//}								
							
								date_cal.add(Calendar.DATE, (Integer.parseInt(info[3])) * 7);
								count++;
							}
						break;	
						
						case "2" : // 매월
							while (true) {						
								int year = date_cal.get(Calendar.YEAR);
								int month = date_cal.get(Calendar.MONTH) + 1;
		
								if ((year >= eDate_cal.get(Calendar.YEAR) && month > eDate_cal.get(Calendar.MONTH) + 1) || year > eDate_cal.get(Calendar.YEAR)) break;
								if (maxCount == count) break;
								
								boolean generated = false;
								
								Calendar newCal = Calendar.getInstance();
								newCal.set(year, month-1, 1);
		
								if (info[3].equals("1")) {
									newCal.add(Calendar.DATE, Integer.parseInt(info[5]) - 1);
								} else {
									int diff = Integer.parseInt(info[6]) - (newCal.get(Calendar.DAY_OF_WEEK) - 1);
									
									if (diff < 0) {
										diff += 7;									
									}								
									newCal.add(Calendar.DATE, diff);
									
									if (Integer.parseInt(info[5]) < 5) {
										newCal.add(Calendar.DATE, (Integer.parseInt(info[5]) - 1) * 7);
									} else {
										while (true) {
											newCal.add(Calendar.DATE, 7);
											
											if (newCal.get(Calendar.MONTH) + 1 != month) {
												newCal.add(Calendar.DATE, -7);
												break;
											}
										}
									}
								}
		
								if (newCal.get(Calendar.MONTH) + 1 == month && (!isFirst || newCal.get(Calendar.DATE) >= date_cal.get(Calendar.DATE))) {
									generated = true;
								}
								
								isFirst = false;
		
								if (generated) {
									count++;
		
									String calcuDate = nsdf.format(newCal.getTime());

									//2021-09-29 남학선 반복업무 검색시 달성율이 나타나지 않아서 해당 날짜의 완료율을 검색한 후 넣어줌
									String convertDate = calcuDate + " 00:00:00";
									int comRate = selectCompletionOfRepTask(vo.getTaskID(), convertDate, tenantID);
									vo.setCompleteRate(comRate);
									
									//if (calcuDate.compareTo(startDate.substring(0,10)) >= 0 && calcuDate.compareTo(endDate.substring(0,10)) <= 0) {
									if ((newCal.compareTo(sDate_cal) >= 0) && (newCal.compareTo(eDate_cal) <= 0)) {
										//row 추가
										if (!rList.contains(calcuDate)) {
											TaskInfoVO rVo = addRepeatRow(vo, newCal.getTime(), count, info[1]);
											resultList.add(rVo);
										}
									}
								}
								
								date_cal.add(Calendar.DATE, 1 - date_cal.get(Calendar.DATE));
								date_cal.add(Calendar.MONTH, Integer.parseInt(info[4]));							
							}
						break;
						
						case "3" : // 매년
							while (true) {
								int year = date_cal.get(Calendar.YEAR);
								int month = Integer.parseInt(info[4]);
										
								if (year > eDate_cal.get(Calendar.YEAR)) break;
								if (maxCount == count) break;
								
								boolean generated = false;
								
								Calendar newCal = Calendar.getInstance();
								newCal.set(year, month-1, 1);
								
								if (info[3].equals("1")) {
									newCal.add(Calendar.DATE, Integer.parseInt(info[5]) - 1);
									
									if (info[5].equals("2")) {
										//음력으로 newCal 다시 만듬									
										if (!isFirst || newCal.compareTo(date_cal) >= 0) {
											generated = true;
										}
									}
								} else {
									int diff = Integer.parseInt(info[6]) - (newCal.get(Calendar.DAY_OF_WEEK) - 1); 
									
									if (diff < 0) {
										diff += 7;									
									}								
									newCal.add(Calendar.DATE, diff);
									
									if (Integer.parseInt(info[5]) < 5) {
										newCal.add(Calendar.DATE, (Integer.parseInt(info[5]) - 1) * 7);
									} else {
										while (true) {
											newCal.add(Calendar.DATE, 7);
											
											if (newCal.get(Calendar.MONTH) + 1 != month) {
												newCal.add(Calendar.DATE, -7);
												break;
											}
										}
									}
								}
								
								if (newCal.get(Calendar.MONTH) + 1 == month && (!isFirst || newCal.get(Calendar.DATE) >= date_cal.get(Calendar.DATE))) {
									generated = true;
								}
								
								isFirst = false;
								
								if (generated) {
									count++;
									
									String calcuDate = nsdf.format(newCal.getTime());

									//2021-09-29 남학선 반복업무 검색시 달성율이 나타나지 않아서 해당 날짜의 완료율을 검색한 후 넣어줌
									String convertDate = calcuDate + " 00:00:00";
									int comRate = selectCompletionOfRepTask(vo.getTaskID(), convertDate, tenantID);
									vo.setCompleteRate(comRate);
									
									//if (calcuDate.compareTo(startDate.substring(0,10)) >= 0 && calcuDate.compareTo(endDate.substring(0,10)) <= 0) {
									if ((newCal.compareTo(sDate_cal) >= 0) && (newCal.compareTo(eDate_cal) <= 0)) {
										//row 추가
										if (!rList.contains(calcuDate)) {
											TaskInfoVO rVo = addRepeatRow(vo, newCal.getTime(), count, info[1]);
											resultList.add(rVo);
										}
									}
								}
								
								date_cal.add(Calendar.DATE, 1 - date_cal.get(Calendar.DATE));
								date_cal.add(Calendar.YEAR, 1);
							}						
						break;	
					}
				}
				else {
					resultList.add(vo);
				}					
			}
		}

		logger.debug("listsize = " + list.size());
		logger.debug("getTaskList ended.");
		
		logger.debug("=====getScheduleList Ended=====");
		if (tempResultList != null) {
			resultList = realList(resultList, tempResultList, startDate, endDate, offset);
		}

		return resultList;
	}
	
	public List<TaskInfoVO> realList (List<TaskInfoVO> resultList, List<TaskInfoVO> tempResultList, String startDate, String endDate, String offset) throws Exception {
		
		String vosDate = "";
		String voeDate = "";
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		
		for (TaskInfoVO svo : tempResultList) {
			vosDate = commonUtil.getDateStringInUTC(svo.getStartDate(), offset, true);
			voeDate = commonUtil.getDateStringInUTC(svo.getEndDate(), offset, true);
			
			Calendar vosDate_cal = Calendar.getInstance();
			Calendar voeDate_cal = Calendar.getInstance();
			Calendar sDate_cal = Calendar.getInstance();
			Calendar eDate_cal = Calendar.getInstance();
			
			vosDate_cal.setTime(sdf.parse(vosDate));
			voeDate_cal.setTime(sdf.parse(voeDate));
			sDate_cal.setTime(sdf.parse(startDate));
			eDate_cal.setTime(sdf.parse(endDate));
			
			if (vosDate_cal.compareTo(sDate_cal) >= 0 && voeDate_cal.compareTo(eDate_cal) <= 0) {
				resultList.add(svo);
			}
		}
		
		return resultList;
	}

	public TaskInfoVO addRepeatRow(TaskInfoVO vo, Date date, int count, String dateType) throws Exception {
		
		SimpleDateFormat nsdf = new SimpleDateFormat("yyyy-MM-dd");
		TaskInfoVO innerVO = new TaskInfoVO();

		//logger.debug("vo.getStartDate : " + vo.getStartDate() + " | vo.getEndDate() : " + vo.getEndDate());

		String dateTime1 = nsdf.format(date) + vo.getStartDate().substring(10);
		String dateTime2 = nsdf.format(date) + vo.getEndDate().substring(10);
		
		if (dateTime1.compareTo(dateTime2) > 0) {
			Calendar cal = Calendar.getInstance();
			
			cal.setTime(date);
			cal.add(Calendar.DATE, 1); // 1일 후
			
			dateTime2 = nsdf.format(cal.getTime()) + vo.getEndDate().substring(10); 
		}
		
//		int newDateType = Integer.parseInt(dateType) + 1;
		
		BeanUtils.copyProperties(innerVO, vo);

		innerVO.setStartDate(dateTime1);
		innerVO.setEndDate(dateTime2);
//		innerVO.setTaskType(newDateType + "");
		innerVO.setRepeatCount(count);			
		
		return innerVO; 
	}

	@Override
	public String getTaskCount(String userID, String offset, String type, String filter, String chkValue, String primary, String taskStatusCount, String pSelectTab, int tenantID, String companyID) throws Exception {
		logger.debug("getTaskCount started.");
		logger.debug("userID = " + userID + " || type = " + type + " || filter = " + filter + " || chkValue = " + chkValue);
				
		String cnt = ""; // 진행업무 중 진행중 count		
		String cnt2 = ""; // 지시,협조 중 진행중 count
		String cnt3 = ""; // 지시,협조 중 진행중 count	
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");			
		sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
	    String utcTime = sdf.format(new Date());
		
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("userID", userID);		
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("type", type);
		map.put("filter", filter);
		map.put("chkValue", chkValue);
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		map.put("taskStatusCount", taskStatusCount);
		map.put("today", utcTime);
		map.put("v_COMPANYID", companyID);
		
		if (pSelectTab.equals("taskprog")) {			
			cnt = ezTaskDAO.getTaskCount(map);
			map.put("taskStatusCount", "2");
			cnt2 = ezTaskDAO.getTaskCount2(map);
			cnt3 = ezTaskDAO.getTaskCount3(map);
		}
		else if (pSelectTab.equals("taskdictate")) {
			cnt2 = ezTaskDAO.getTaskCount2(map);
			map.put("taskStatusCount", "2");
			cnt = ezTaskDAO.getTaskCount(map);				
			cnt3 = ezTaskDAO.getTaskCount3(map);
		}
		else if (pSelectTab.equals("taskrepetition")) {
			cnt3 = ezTaskDAO.getTaskCount3(map);			
			map.put("taskStatusCount", "2");
			cnt = ezTaskDAO.getTaskCount(map);
			cnt2 = ezTaskDAO.getTaskCount2(map);
			
		}
		else {
			map.put("taskStatusCount", "3");
			cnt = ezTaskDAO.getTaskCount(map);
			cnt2 = ezTaskDAO.getTaskCount2(map);
			cnt3 = ezTaskDAO.getTaskCount3(map);
		}
		

		String rtnCnt = "";
/*		String cnt = ezTaskDAO.getTaskCount(map); // 진행업무 중 진행중 count		
		String cnt2 = ezTaskDAO.getTaskCount2(map); // 지시,협조 중 진행중 count
		String cnt3 = ezTaskDAO.getTaskCount3(map); // 지시,협조 중 진행중 count	*/
		String totalCnt = ezTaskDAO.getTaskAllCount(map); // 개인 + 지시,협조 count	

		rtnCnt = cnt + "," + cnt2 + "," + cnt3 + "," + totalCnt;

		logger.debug("rtnCnt : " + rtnCnt);
		logger.debug("getTaskCount ended.");

		return rtnCnt;
	}

	@Override
	public void taskDelete(String taskIDList, String pDirPath, String offset, String primary, String memberID, int tenantID, String companyID) throws Exception {
		logger.debug("taskDelete started.");
		logger.debug("memberID = " + memberID + " | taskIDList : " + taskIDList + " | pDirPath : " + pDirPath + " | offset : " + offset + " | primary : " + primary);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);

		for (String taskID : taskIDList.split(";")) {
			if (taskID.equals("")) {
				continue;
			}
				
			map.put("taskID", taskID);
			
			TaskInfoVO vo = ezTaskDAO.getTaskInfo(map);
			
			if (vo == null) {
				continue;
			}
			
			/* 2020-09-15 홍승비 - 업무관리 제목의 특수문자를 jsp단에서 처리하므로, 하단 XSS 코드 주석처리 */
/*			String taskTitle = vo.getTitle();
			taskTitle = commonUtil.stripScriptTags(taskTitle);
			vo.setTitle(taskTitle);*/
			
			//baonk added
			if (vo.getTaskType().equals("4")) {
				ezTaskDAO.repTaskDelete(map);
			}
			//end

			// 첨부파일이 있으면 첨부파일 삭제
			if (vo.getHasAttach().equals("Y")) {
				pDirPath = commonUtil.detectPathTraversal(pDirPath);
				deleteDirectory(taskID, pDirPath, tenantID);
			}

			String mhtPath = vo.getContentPath();

			logger.debug("Delete mhtPath : " + mhtPath);
			
			String dirPath = pDirPath + mhtPath;
			dirPath = commonUtil.detectPathTraversal(dirPath);
			dirPath = commonUtil.stripScriptTags(dirPath);
			
			File file = new File(dirPath);

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
	private String insertTask(TaskInfoVO vo, String offset, int tenantID, String companyID) throws Exception {
		logger.debug("insertTask started.");
		
		String nowDate = commonUtil.getTodayUTCTime("");
		
		/* 2020-09-15 홍승비 - 업무관리 제목의 특수문자를 jsp단에서 처리하므로, 하단 XSS 코드 주석처리 */
/*		String taskTitle = vo.getTitle();
		taskTitle = commonUtil.stripScriptTags(taskTitle);
		vo.setTitle(taskTitle);*/
		
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
		map.put("repetition", vo.getRepetition());
		map.put("totalrepetition", vo.getTotalRep());
		map.put("tenantID", tenantID);
		map.put("v_COMPANYID", companyID);
		
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
		
		/* 2020-09-15 홍승비 - 업무관리 제목의 특수문자를 jsp단에서 처리하므로, 하단 XSS 코드 주석처리 */
/*		String taskTitle = vo.getTitle();
		taskTitle = commonUtil.stripScriptTags(taskTitle);
		vo.setTitle(taskTitle);*/
		
		logger.debug("taskID = " + taskID + " || Repetition: " + vo.getRepetition());
		
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
		map.put("repetition", vo.getRepetition());
		map.put("totalrepetition", vo.getTotalRep());
		
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
		
		File file = new File(commonUtil.detectPathTraversal(beforeFilePath));

		try {
			file.renameTo(new File(commonUtil.detectPathTraversal(afterFilePath)));			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("fileMove ended.");
	}

	private void deleteDirectory(String taskID, String pDirpath, int tenantID) throws Exception {
		logger.debug("deleteDirectory ended.");
		
		String dirPath = pDirpath + "uploadFile" + commonUtil.separator + taskID + "_uploadFile";
		
		File directoryFile = new File(commonUtil.detectPathTraversal(dirPath));
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

	@Override
	public void taskSaveGeneral(String userID, int listCount, String selectTaskStatus, int tenantID) throws Exception {
		logger.debug("taskSaveGeneral started.");
		logger.debug("listCount : " + listCount + " | selectTaskStatus : " + selectTaskStatus);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("userID", userID);
		map.put("listCount", listCount);
		map.put("selectTaskStatus", selectTaskStatus);
		map.put("tenantID", tenantID);

		ezTaskDAO.taskSaveGeneral(map);

		logger.debug("taskSaveGeneral ended.");
	}

	@Override
	public TaskGeneralVO getTaskGeneral(String userID, int tenantID) throws Exception {
		logger.debug("getTaskGeneral started.");
		
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("userID", userID);
		map.put("tenantID", tenantID);
		
		TaskGeneralVO taskGeneralVO = ezTaskDAO.getTaskGeneral(map);
		
		logger.debug("getTaskGeneral ended.");
		
		return taskGeneralVO;
	}

	@Override
	public void updateTaskGeneral(String userID, int listCount, String selectTaskStatus, int tenantID) throws Exception {
		logger.debug("updatetaskGeneral started.");
		logger.debug("listCount : " + listCount + " | selectTaskStatus : " + selectTaskStatus);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userID", userID);
		map.put("listCount", listCount);
		map.put("selectTaskStatus", selectTaskStatus);
		map.put("tenantID", tenantID);

		ezTaskDAO.updateTaskGeneral(map);
		
		logger.debug("updatetaskGeneral ended.");
	}

	@Override
	public void insertTaskRepeDel(String taskID, String repeatCount, String taskStatus, String completeRate, String startDate, int tenantID) throws Exception {
		logger.debug("insertTaskRepeDel started.");
		logger.debug("taskID : " + taskID + " | repeatCount : " + repeatCount + " | taskStatus : " + taskStatus + " | completeRate : " + completeRate + " | startDate : " + startDate);
	
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("taskID", taskID);
		map.put("repeatCount", repeatCount);
		map.put("taskStatus", taskStatus);
		map.put("completeRate", completeRate);
		map.put("startDate", startDate);
		map.put("tenantID", tenantID);

		ezTaskDAO.insertTaskRepeDel(map);
		
		logger.debug("insertTaskRepeDel ended.");
	}

	@Override
	public int selectCompletionOfRepTask(String taskID, String date, int tenantID) throws Exception {		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("taskID", taskID);
		map.put("date", date);
		map.put("tenantID", tenantID);
		
		int result = ezTaskDAO.selectCompletionOfRepTask(map);
		return result;
	}

	@Override
	public Map<String, Integer> getDatesOfRepTask(String taskID, String offset,	String primary, String endDate, String startDate, String selectDate, int tenantID, String companyID) throws Exception {
		logger.debug("getDatesOfRepTask started.");
		logger.debug("taskID : " + taskID + " | startDate : " + startDate + " | endDate : " + endDate + " | Select Date: " + selectDate);
		//String currentPos = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		map.put("taskID", taskID);
		map.put("companyID", companyID);
		
		TaskInfoVO vo = ezTaskDAO.getTaskInfo(map);
		
		//List<String> resultList = new ArrayList<String>();
		List<String> rList = ezTaskDAO.getTaskRepeDelList(map);	
		Map<String, Integer> mapDateAndRepeatCount = new LinkedHashMap<String, Integer>();
		
		String currentEndDate = vo.getEndDate();
		String[] info = vo.getRepetition().split("\\|");

		if (!info[0].equals("0")) {
			currentEndDate = endDate;
		} // 반복주기 설정범위가 다음회수 반복 후 종료 일때 '0'

		if (currentEndDate.compareTo(endDate) > 0) {
			currentEndDate = endDate;
		}

		int maxCount = Integer.parseInt(info[0]);
		int count = 0;
		boolean isFirst = true;

		if (maxCount == 0) {
			maxCount = -1;
		}

		Calendar sDate_cal = Calendar.getInstance();
		Calendar eDate_cal = Calendar.getInstance();
		Calendar date_cal = Calendar.getInstance();

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		SimpleDateFormat nsdf = new SimpleDateFormat("yyyy-MM-dd");

		logger.debug("endDate : " + endDate + " | currentEndDate : " + currentEndDate);
		
		Date scheduleStartDate = sdf.parse(vo.getStartDate());

		sDate_cal.setTime(sdf.parse(startDate));
		eDate_cal.setTime(sdf.parse(currentEndDate));
		date_cal.setTime(scheduleStartDate);
		
		Calendar scheduleCalendar = Calendar.getInstance();
		scheduleCalendar.setTime(date_cal.getTime());
		
		Calendar firstDateOfThisCalendar = Calendar.getInstance();
		firstDateOfThisCalendar.setTime(sdf.parse(startDate));
		
		Calendar lastDateOfCalendar = Calendar.getInstance();
		lastDateOfCalendar.setTime(sdf.parse(endDate));
		
		Calendar calculatedScheduleEndDateCalendar = Calendar.getInstance();

		switch (info[2]) {
			case "0" : // 매일
				while (true) {
					if (date_cal.compareTo(eDate_cal) > 0) break;
					if (maxCount == count) break;
					
					boolean generated = false;
					int dayOFWeek = date_cal.get(Calendar.DAY_OF_WEEK) - 1;

					if (info[3].equals("0")) {
						if (dayOFWeek != 0 && dayOFWeek != 6) {
							generated = true;
						}
					} else {
						generated = true;
					}

					if (generated) {
						count++;								
						String calcuDate = nsdf.format(date_cal.getTime());	
						
						if ((date_cal.compareTo(sDate_cal) >= 0) && (date_cal.compareTo(eDate_cal) <= 0)) {
							//row 추가
							if (!rList.contains(calcuDate)) {
								mapDateAndRepeatCount.put(calcuDate, count);
							}
						}
					}
					
					if (info[3].equals("0")) {
						date_cal.add(Calendar.DATE, 1);
					} else {
						date_cal.add(Calendar.DATE, Integer.parseInt(info[3]));
					}
				}
			break;
			
			case "1" : //매주
				
				String isExistEndDate = info[0];
				String weeklyInterval = info[3];
				String dayInfo = info[4];
				
				List<Integer> repeatDayList = new ArrayList<Integer>();
				if(dayInfo != null && !dayInfo.trim().equals("")){
					char[] yoilArr = new char[dayInfo.length()]; // 스트링을 담을 배열

					for (int j = 0; j < dayInfo.length(); j++) {
						yoilArr[j] = dayInfo.charAt(j);					
					}
					int yoilNum;
					for (char yoil : yoilArr) {
						
						yoilNum = yoil - 48;
						repeatDayList.add(yoilNum); 
					}
				}
				
				int MAXSCHEDULECOUNT = 1000;
				int weeklyMaxCount = maxCount * repeatDayList.size();
				
				while (true) {
					if (scheduleCalendar.compareTo(lastDateOfCalendar) > 0) {
						calculatedScheduleEndDateCalendar.setTime(lastDateOfCalendar.getTime());
						calculatedScheduleEndDateCalendar.add(Calendar.DATE, (Integer.parseInt(weeklyInterval)) * 7);
						if(scheduleCalendar.compareTo(calculatedScheduleEndDateCalendar) > 0) {
							break;
						}
					}
					if (Integer.parseInt(isExistEndDate) > 0) {
						if (weeklyMaxCount <= count) break;
					} 
					
					if (count > MAXSCHEDULECOUNT) {
						break;
					}
					
					@SuppressWarnings("unused")
					String calcuDate = nsdf.format(date_cal.getTime());
					String scheduleDate = nsdf.format(scheduleCalendar.getTime());
					
					if(isExistEndDate.equals("0")){
						for (int k = 0; k < repeatDayList.size(); k++) {
							scheduleCalendar.set(Calendar.DAY_OF_WEEK,repeatDayList.get(k)+1);
							scheduleDate = nsdf.format(scheduleCalendar.getTime());
							if (scheduleCalendar.getTime().compareTo(scheduleStartDate) >= 0 && scheduleCalendar.getTime().compareTo(sdf.parse(vo.getEndDate())) <= 0) {
								if (!rList.contains(scheduleDate)) {
									count++;
									int weeklyCount = (int) Math.ceil(count / (double)repeatDayList.size());
									mapDateAndRepeatCount.put(scheduleDate, weeklyCount);
								} else {
									count++;
								}
							}
						}
					} else if (Integer.parseInt(isExistEndDate) > 0) {
						for (int k = 0; k < repeatDayList.size(); k++) {
							scheduleCalendar.set(Calendar.DAY_OF_WEEK,repeatDayList.get(k)+1);
							scheduleDate = nsdf.format(scheduleCalendar.getTime());
							if (scheduleCalendar.getTime().compareTo(scheduleStartDate) >= 0 && scheduleCalendar.getTime().compareTo(sdf.parse(endDate)) <= 0) {
								if (weeklyMaxCount > count) {
									if (!rList.contains(scheduleDate)) {
										count++;
										int weeklyCount = (int) Math.ceil(count / (double)repeatDayList.size());
										mapDateAndRepeatCount.put(scheduleDate, weeklyCount);
									} else {
										count++;
									}
								} else {
									break;
								}
							} 
						}
					} else {
						for (int k = 0; k < repeatDayList.size(); k++) {
							scheduleCalendar.set(Calendar.DAY_OF_WEEK,repeatDayList.get(k)+1);
							scheduleDate = nsdf.format(scheduleCalendar.getTime());
							if (scheduleCalendar.getTime().compareTo(scheduleStartDate) >= 0 && scheduleCalendar.getTime().compareTo(sdf.parse(endDate)) <= 0) {
								if (!rList.contains(scheduleDate)) {
									count++;
									int weeklyCount = (int) Math.ceil(count / (double)repeatDayList.size());
									mapDateAndRepeatCount.put(scheduleDate, weeklyCount);
								} else {
									count++;
								}
							}
						}
					}
					scheduleCalendar.add(Calendar.DATE, (Integer.parseInt(weeklyInterval)) * 7);
				}						
			break;	
			
			case "2" : // 매월
				while (true) {						
					int year = date_cal.get(Calendar.YEAR);
					int month = date_cal.get(Calendar.MONTH) + 1;

					if ((year >= eDate_cal.get(Calendar.YEAR) && month > eDate_cal.get(Calendar.MONTH) + 1) || year > eDate_cal.get(Calendar.YEAR)) break;
					if (maxCount == count) break;
					
					boolean generated = false;
					
					Calendar newCal = Calendar.getInstance();
					newCal.set(year, month-1, 1);

					if (info[3].equals("1")) {
						newCal.add(Calendar.DATE, Integer.parseInt(info[5]) - 1);
					} else {
						int diff = Integer.parseInt(info[6]) - (newCal.get(Calendar.DAY_OF_WEEK) - 1);
						
						if (diff < 0) {
							diff += 7;									
						}								
						newCal.add(Calendar.DATE, diff);
						
						if (Integer.parseInt(info[5]) < 5) {
							newCal.add(Calendar.DATE, (Integer.parseInt(info[5]) - 1) * 7);
						} else {
							while (true) {
								newCal.add(Calendar.DATE, 7);
								
								if (newCal.get(Calendar.MONTH) + 1 != month) {
									newCal.add(Calendar.DATE, -7);
									break;
								}
							}
						}
					}

					if (newCal.get(Calendar.MONTH) + 1 == month && (!isFirst || newCal.get(Calendar.DATE) >= date_cal.get(Calendar.DATE))) {
						generated = true;
					}
					
					isFirst = false;

					if (generated) {
						count++;

						String calcuDate = nsdf.format(newCal.getTime());
						
						//if (calcuDate.compareTo(startDate.substring(0,10)) >= 0 && calcuDate.compareTo(endDate.substring(0,10)) <= 0) {
						if (info[0].equals("0")) {
							if ((newCal.compareTo(sDate_cal) >= 0) && (calcuDate.compareTo(currentEndDate.substring(0,10)) <= 0)) {
								//row 추가
								if (!rList.contains(calcuDate)) {
									mapDateAndRepeatCount.put(calcuDate, count);
								}
							}
						} else {
							if ((newCal.compareTo(sDate_cal) >= 0) && (newCal.compareTo(eDate_cal) <= 0)) {
								//row 추가
								if (!rList.contains(calcuDate)) {
									mapDateAndRepeatCount.put(calcuDate, count);
								}
							}
						}	
					}
					
					date_cal.add(Calendar.DATE, 1 - date_cal.get(Calendar.DATE));
					date_cal.add(Calendar.MONTH, Integer.parseInt(info[4]));							
				}
			break;
			
			case "3" : // 매년
				while (true) {
					int year = date_cal.get(Calendar.YEAR);
					int month = Integer.parseInt(info[4]);
							
					if (year > eDate_cal.get(Calendar.YEAR)) break;
					if (maxCount == count) break;
					
					boolean generated = false;
					
					Calendar newCal = Calendar.getInstance();
					newCal.set(year, month-1, 1);
					
					if (info[3].equals("1")) {
						newCal.add(Calendar.DATE, Integer.parseInt(info[5]) - 1);
						
						if (info[5].equals("2")) {
							//음력으로 newCal 다시 만듬									
							if (!isFirst || newCal.compareTo(date_cal) >= 0) {
								generated = true;
							}
						}
					} else {
						int diff = Integer.parseInt(info[6]) - (newCal.get(Calendar.DAY_OF_WEEK) - 1); 
						
						if (diff < 0) {
							diff += 7;									
						}								
						newCal.add(Calendar.DATE, diff);
						
						if (Integer.parseInt(info[5]) < 5) {
							newCal.add(Calendar.DATE, (Integer.parseInt(info[5]) - 1) * 7);
						} else {
							while (true) {
								newCal.add(Calendar.DATE, 7);
								
								if (newCal.get(Calendar.MONTH) + 1 != month) {
									newCal.add(Calendar.DATE, -7);
									break;
								}
							}
						}
					}
					
					if (newCal.get(Calendar.MONTH) + 1 == month && (!isFirst || newCal.get(Calendar.DATE) >= date_cal.get(Calendar.DATE))) {
						generated = true;
					}
					
					isFirst = false;
					
					if (generated) {
						count++;
						
						String calcuDate = nsdf.format(newCal.getTime());
						
						if (info[0].equals("0")) {
							if ((newCal.compareTo(sDate_cal) >= 0) && (calcuDate.compareTo(currentEndDate.substring(0,10)) <= 0)) {
								//row 추가
								if (!rList.contains(calcuDate)) {
									mapDateAndRepeatCount.put(calcuDate, count);
								}
							}
						} else {
							if ((newCal.compareTo(sDate_cal) >= 0) && (newCal.compareTo(eDate_cal) <= 0)) {
								//row 추가
								if (!rList.contains(calcuDate)) {
									mapDateAndRepeatCount.put(calcuDate, count);
								}
							}
						}
					}
					
					date_cal.add(Calendar.DATE, 1 - date_cal.get(Calendar.DATE));
					date_cal.add(Calendar.YEAR, 1);
				}						
			break;	
		}
		return mapDateAndRepeatCount;
	}

	@Override
	public void setRepTaskInfo(TaskInfoVO vo) throws Exception {		
		String[] info = vo.getRepetition().split("\\|");    				
		if (info[0].equals("-1")) {						
			vo.setTotalRep(-1);	
		}
		else { 
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat nsdf = new SimpleDateFormat("yyyy-MM-dd");
			int count = 0;
			boolean isFirst = true;
			String newEndDate = "";
			
			if (info[0].equals("0")) {				
				String endD = vo.getEndDate();
				String startD = vo.getStartDate();
				
				Calendar sDate_cal = Calendar.getInstance();
				Calendar eDate_cal = Calendar.getInstance();
				Calendar date_cal = Calendar.getInstance();
				
				sDate_cal.setTime(sdf.parse(startD));
				eDate_cal.setTime(sdf.parse(endD));
				date_cal.setTime(sdf.parse(startD));		
				
				
				switch (info[2]) {
					case "0" : // 매일
						while (true) {
							if (date_cal.compareTo(eDate_cal) > 0) break;						
							
							boolean generated = false;
							int dayOFWeek = date_cal.get(Calendar.DAY_OF_WEEK) - 1;
	
							if (info[3].equals("0")) {
								if (dayOFWeek != 0 && dayOFWeek != 6) {
									generated = true;
								}
							} else {
								generated = true;
							}
	
							if (generated) {
								newEndDate = nsdf.format(date_cal.getTime()) + " 23:59:59";
								count++;							
							}
							
							if (info[3].equals("0")) {
								date_cal.add(Calendar.DATE, 1);
							} else {
								date_cal.add(Calendar.DATE, Integer.parseInt(info[3]));
							}
						}
					break;
					
					case "1" : //매주
						/** 2019.02.01 유은정 추가 , 반복일정 요일의 개수가 2개 이상일 때와 1개일 때 구분*/
						
						Calendar scheduleCalendar = Calendar.getInstance();
						scheduleCalendar.setTime(sdf.parse(startD));
						Calendar calculatedScheduleEndDateCalendar = Calendar.getInstance();
						String[] yoil = info[4].split("");
						
						if (yoil.length > 1) {
							
							@SuppressWarnings("unused")
							String scheduleDate = nsdf.format(scheduleCalendar.getTime());
							
							while (true) {
								if (scheduleCalendar.compareTo(eDate_cal) > 0) {
									calculatedScheduleEndDateCalendar.setTime(eDate_cal.getTime());
									calculatedScheduleEndDateCalendar.add(Calendar.DATE, (Integer.parseInt(info[3])) * 7);
									if(scheduleCalendar.compareTo(calculatedScheduleEndDateCalendar) > 0) {
										break;
									}
								}
								
								for (int k = 0; k < yoil.length; k++) {
									scheduleCalendar.set(Calendar.DAY_OF_WEEK,Integer.parseInt(yoil[k])+1);
									scheduleDate = nsdf.format(scheduleCalendar.getTime());
									if (scheduleCalendar.getTime().compareTo(sdf.parse(startD)) >= 0 && scheduleCalendar.getTime().compareTo(sdf.parse(vo.getEndDate())) <= 0) {
										count++;
										newEndDate = nsdf.format(scheduleCalendar.getTime()) + " 23:59:59";
									}
								}
								scheduleCalendar.add(Calendar.DATE, (Integer.parseInt(info[3])) * 7);
							}
						} else {
							int weekcount = 6 - date_cal.get(Calendar.DAY_OF_WEEK) - 1;
						
							while (true) {
								if (date_cal.compareTo(eDate_cal) > 0) break;										
								boolean generated = false;
		
								if (info[4].indexOf((date_cal.get(Calendar.DAY_OF_WEEK) - 1) + "") > -1) {
									generated = true;
								}
								
								if (generated) {
									newEndDate = nsdf.format(date_cal.getTime()) + " 23:59:59";
									count++;
								}
								
								if (weekcount == 0) {
									date_cal.add(Calendar.DATE, (Integer.parseInt(info[3]) - 1) * 7 + 1);
									weekcount = 6;
								} else {
									date_cal.add(Calendar.DATE, 1);
									weekcount--;
								}
							}
						}						
					break;	
					
					case "2" : // 매월
						while (true) {						
							int year = date_cal.get(Calendar.YEAR);
							int month = date_cal.get(Calendar.MONTH) + 1;
	
							if ((year >= eDate_cal.get(Calendar.YEAR) && month > eDate_cal.get(Calendar.MONTH) + 1) || year > eDate_cal.get(Calendar.YEAR)) break;
							
							
							boolean generated = false;
							
							Calendar newCal = Calendar.getInstance();
							newCal.set(year, month-1, 1);
	
							if (info[3].equals("1")) {
								newCal.add(Calendar.DATE, Integer.parseInt(info[5]) - 1);
							} else {
								int diff = Integer.parseInt(info[6]) - (newCal.get(Calendar.DAY_OF_WEEK) - 1);
								
								if (diff < 0) {
									diff += 7;									
								}								
								newCal.add(Calendar.DATE, diff);
								
								if (Integer.parseInt(info[5]) < 5) {
									newCal.add(Calendar.DATE, (Integer.parseInt(info[5]) - 1) * 7);
								} else {
									while (true) {
										newCal.add(Calendar.DATE, 7);
										
										if (newCal.get(Calendar.MONTH) + 1 != month) {
											newCal.add(Calendar.DATE, -7);
											break;
										}
									}
								}
							}
	
							if (newCal.get(Calendar.MONTH) + 1 == month && (!isFirst || newCal.get(Calendar.DATE) >= date_cal.get(Calendar.DATE))) {
								generated = true;
							}
							
							isFirst = false;
	
							if (generated) {
								String calcuDate = nsdf.format(newCal.getTime());
									if (calcuDate.compareTo(sdf.format(sdf.parse(vo.getEndDate())).substring(0,10)) <= 0) {
										newEndDate = nsdf.format(newCal.getTime()) + " 23:59:59";
										count++;
									}
							}
							
							date_cal.add(Calendar.DATE, 1 - date_cal.get(Calendar.DATE));
							date_cal.add(Calendar.MONTH, Integer.parseInt(info[4]));							
						}
					break;
					
					case "3" : // 매년
						while (true) {
							int year = date_cal.get(Calendar.YEAR);
							int month = Integer.parseInt(info[4]);
									
							if (year > eDate_cal.get(Calendar.YEAR)) break;						
							
							boolean generated = false;
							
							Calendar newCal = Calendar.getInstance();
							newCal.set(year, month-1, 1);
							
							if (info[3].equals("1")) {
								newCal.add(Calendar.DATE, Integer.parseInt(info[5]) - 1);
								
								if (info[5].equals("2")) {
									//음력으로 newCal 다시 만듬									
									if (!isFirst || newCal.compareTo(date_cal) >= 0) {
										generated = true;
									}
								}
							} else {
								int diff = Integer.parseInt(info[6]) - (newCal.get(Calendar.DAY_OF_WEEK) - 1); 
								
								if (diff < 0) {
									diff += 7;									
								}								
								newCal.add(Calendar.DATE, diff);
								
								if (Integer.parseInt(info[5]) < 5) {
									newCal.add(Calendar.DATE, (Integer.parseInt(info[5]) - 1) * 7);
								} else {
									while (true) {
										newCal.add(Calendar.DATE, 7);
										
										if (newCal.get(Calendar.MONTH) + 1 != month) {
											newCal.add(Calendar.DATE, -7);
											break;
										}
									}
								}
							}
							
							if (newCal.get(Calendar.MONTH) + 1 == month && (!isFirst || newCal.get(Calendar.DATE) >= date_cal.get(Calendar.DATE))) {
								generated = true;
							}
							
							isFirst = false;
							
							if (generated) {
								String calcuDate = nsdf.format(newCal.getTime());
								if (calcuDate.compareTo(sdf.format(sdf.parse(vo.getEndDate())).substring(0,10)) <= 0) {
									newEndDate = nsdf.format(newCal.getTime()) + " 23:59:59";
									count++;
								}
							}
							
							date_cal.add(Calendar.DATE, 1 - date_cal.get(Calendar.DATE));
							date_cal.add(Calendar.YEAR, 1);
						}						
					break;	
				}	       					
				
				/*----------------------*/									
				vo.setTotalRep(count);	
				vo.setEndDate(newEndDate);
			} else {
				
				String endD = vo.getEndDate();
				String startD = vo.getStartDate();
				
				Calendar sDate_cal = Calendar.getInstance();
				Calendar eDate_cal = Calendar.getInstance();
				
				sDate_cal.setTime(sdf.parse(startD));
				eDate_cal.setTime(sdf.parse(endD));	
				
		        int maxCount = Integer.parseInt(info[0]);
				Calendar date_cal = Calendar.getInstance();
				date_cal.setTime(sdf.parse(vo.getStartDate()));			

				switch (info[2]) {
					case "0" : // 매일
						while (true) {							
							if (maxCount == count) break;
							
							boolean generated = false;
							int dayOFWeek = date_cal.get(Calendar.DAY_OF_WEEK) - 1;

							if (info[3].equals("0")) {
								if (dayOFWeek != 0 && dayOFWeek != 6) {
									generated = true;
								}
							} else {
								generated = true;
							}

							if (generated) {
								newEndDate = nsdf.format(date_cal.getTime()) + " 23:59:59";
								count++;							
							}
							
							if (info[3].equals("0")) {
								date_cal.add(Calendar.DATE, 1);
							} else {
								date_cal.add(Calendar.DATE, Integer.parseInt(info[3]));
							}
						}
					break;
					
					case "1" : //매주
						/** 2019.02.01 유은정 추가 , 반복일정 요일의 개수가 2개 이상일 때와 1개일 때 구분*/
						
						Calendar scheduleCalendar = Calendar.getInstance();
						scheduleCalendar.setTime(sdf.parse(startD));
						String[] yoil = info[4].split("");
						
						int weeklyMaxCount = maxCount * yoil.length;
						int MAXSCHEDULECOUNT = 1000;
						
						if (yoil.length > 1) {
							
							@SuppressWarnings("unused")
							String scheduleDate = nsdf.format(scheduleCalendar.getTime());
							
							while (true) {
								
								if (Integer.parseInt(info[0]) > 0) {
									if (weeklyMaxCount <= count) break;
								} 
								if (count > MAXSCHEDULECOUNT) {
									break;
								}
								
								for (int k = 0; k < yoil.length; k++) {
									scheduleCalendar.set(Calendar.DAY_OF_WEEK,Integer.parseInt(yoil[k])+1);
									scheduleDate = nsdf.format(scheduleCalendar.getTime());
									if (weeklyMaxCount > count) {
										if (scheduleCalendar.getTime().compareTo(sdf.parse(startD)) >= 0) {
											count++;
											newEndDate = nsdf.format(scheduleCalendar.getTime()) + " 23:59:59";
										}
									}
								}
								scheduleCalendar.add(Calendar.DATE, (Integer.parseInt(info[3])) * 7);
							}
							maxCount = maxCount * yoil.length;
						} else {
							int weekcount = 6 - date_cal.get(Calendar.DAY_OF_WEEK) - 1;
							
							while (true) {							
								if (maxCount == count) break;
								
								boolean generated = false;
	
								if (info[4].indexOf((date_cal.get(Calendar.DAY_OF_WEEK) - 1) + "") > -1) {
									generated = true;
								}
								
								if (generated) {
									newEndDate = nsdf.format(date_cal.getTime()) + " 23:59:59";
									count++;
								}
								
								if (weekcount == 0) {
									date_cal.add(Calendar.DATE, (Integer.parseInt(info[3]) - 1) * 7 + 1);
									weekcount = 6;
								} else {
									date_cal.add(Calendar.DATE, 1);
									weekcount--;
								}
							}
							maxCount = maxCount * yoil.length;
						}
					break;	
					
					case "2" : // 매월
						while (true) {						
							int year = date_cal.get(Calendar.YEAR);
							int month = date_cal.get(Calendar.MONTH) + 1;
							
							if (maxCount == count) break;
							
							boolean generated = false;
							
							Calendar newCal = Calendar.getInstance();
							newCal.set(year, month-1, 1);

							if (info[3].equals("1")) {
								newCal.add(Calendar.DATE, Integer.parseInt(info[5]) - 1);
							} else {
								int diff = Integer.parseInt(info[6]) - (newCal.get(Calendar.DAY_OF_WEEK) - 1);
								
								if (diff < 0) {
									diff += 7;									
								}								
								newCal.add(Calendar.DATE, diff);
								
								if (Integer.parseInt(info[5]) < 5) {
									newCal.add(Calendar.DATE, (Integer.parseInt(info[5]) - 1) * 7);
								} else {
									while (true) {
										newCal.add(Calendar.DATE, 7);
										
										if (newCal.get(Calendar.MONTH) + 1 != month) {
											newCal.add(Calendar.DATE, -7);
											break;
										}
									}
								}
							}

							if (newCal.get(Calendar.MONTH) + 1 == month && (!isFirst || newCal.get(Calendar.DATE) >= date_cal.get(Calendar.DATE))) {
								generated = true;
							}
							
							isFirst = false;

							if (generated) {
								newEndDate = nsdf.format(newCal.getTime()) + " 23:59:59";
								count++;
							}
							
							date_cal.add(Calendar.DATE, 1 - date_cal.get(Calendar.DATE));
							date_cal.add(Calendar.MONTH, Integer.parseInt(info[4]));							
						}
					break;
					
					case "3" : // 매년
						while (true) {
							int year = date_cal.get(Calendar.YEAR);
							int month = Integer.parseInt(info[4]);
							
							if (maxCount == count) break;
							
							boolean generated = false;
							
							Calendar newCal = Calendar.getInstance();
							newCal.set(year, month-1, 1);
							
							if (info[3].equals("1")) {
								newCal.add(Calendar.DATE, Integer.parseInt(info[5]) - 1);
								
								if (info[5].equals("2")) {
									//음력으로 newCal 다시 만듬									
									if (!isFirst || newCal.compareTo(date_cal) >= 0) {
										generated = true;
									}
								}
							} else {
								int diff = Integer.parseInt(info[6]) - (newCal.get(Calendar.DAY_OF_WEEK) - 1); 
								
								if (diff < 0) {
									diff += 7;									
								}								
								newCal.add(Calendar.DATE, diff);
								
								if (Integer.parseInt(info[5]) < 5) {
									newCal.add(Calendar.DATE, (Integer.parseInt(info[5]) - 1) * 7);
								} else {
									while (true) {
										newCal.add(Calendar.DATE, 7);
										
										if (newCal.get(Calendar.MONTH) + 1 != month) {
											newCal.add(Calendar.DATE, -7);
											break;
										}
									}
								}
							}
							
							if (newCal.get(Calendar.MONTH) + 1 == month && (!isFirst || newCal.get(Calendar.DATE) >= date_cal.get(Calendar.DATE))) {
								generated = true;
							}
							
							isFirst = false;
							
							if (generated) {
								newEndDate = nsdf.format(newCal.getTime()) + " 23:59:59";
								count++;
							}
							
							date_cal.add(Calendar.DATE, 1 - date_cal.get(Calendar.DATE));
							date_cal.add(Calendar.YEAR, 1);
						}						
					break;	
				}	
				
				vo.setEndDate(newEndDate);
				vo.setTotalRep(maxCount);		        
			}	
		}	
	}

	@Override
	public void updateNumberOfTotalReps(String taskID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("taskID", taskID);		
		map.put("tenantID", tenantID);
		
		ezTaskDAO.updateNumberOfTotalReps(map);		
	}

	@Override
	public List<TaskInfoVO> getRepTaskList(String taskID, String offset, String primary, String date, int tenantID) throws Exception {		
		return null;
	}

	@Override
	public int getStatusOfRepTask(String taskID, String date, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("taskID", taskID);
		map.put("date", date);
		map.put("tenantID", tenantID);
		
		int result = ezTaskDAO.getStatusOfRepTask(map);
		return result;		
	}

	@Override
	public Map<String, Integer> getRepTaskInfo(String date, String taskID, String offset, String primary, int tenantID, TaskInfoVO taskInfoVO, String companyID) throws Exception {		
		SimpleDateFormat nsdf = new SimpleDateFormat("yyyy-MM-dd");	
		int flag = 0;
		int isDeletedRepeatTaskFlag = 0;
		
		Date startDate = nsdf.parse(date); 
        Calendar calendar = Calendar.getInstance();  
        calendar.setTime(startDate); 
        
        calendar.add(Calendar.MONTH, 1);  
        calendar.set(Calendar.DAY_OF_MONTH, 1);  
        calendar.add(Calendar.DATE, -1); 
        String lastDayOfMonth = nsdf.format(calendar.getTime()) + " 23:59:59"; 
        
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        String firstDayOfMonth = nsdf.format(calendar.getTime()) + " 00:00:00";       	              
		
        Map<String, Integer> result = getDatesOfRepTask(taskID, offset, primary, lastDayOfMonth, firstDayOfMonth, date, tenantID, companyID);	
        Map<String, Object> map = new HashMap<String, Object>();
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		map.put("taskID", taskID);
		map.put("companyID", companyID);
		List<String> deletedRepeatTaskList = ezTaskDAO.getTaskRepeDelList(map);
        
		while (flag == 0) {
			if (result.size() > 0) {
				for (String d: result.keySet()) {
			        Calendar calendar2 = Calendar.getInstance();  
			        calendar2.setTime(startDate);
					
					Date tskD = nsdf.parse(d); 
			        Calendar calendar1 = Calendar.getInstance();  
			        calendar1.setTime(tskD);
			       
			        if (calendar1.compareTo(calendar2) >= 0){
		        		flag = 1;
		        		break;
			        }
			        
			        if (deletedRepeatTaskList.size() > 0) {
		        		Calendar deletedDateCalendar = Calendar.getInstance();
		        		for (String deletedRepeatTask : deletedRepeatTaskList) {
							Date deletedRepeatTaskDate = nsdf.parse(deletedRepeatTask);
							deletedDateCalendar.setTime(deletedRepeatTaskDate);
							if (deletedDateCalendar.compareTo(calendar2) >= 0) {
								isDeletedRepeatTaskFlag = 1;
								break;
							}
						}
		        		if (isDeletedRepeatTaskFlag == 1) {
		        			flag = 1;
		        			break;
		        		}
		        	}
				}
			}
			
			if (flag == 1) {
				break;
			}
			
			//Move to next month
			calendar.add(Calendar.MONTH, 1);
			date = nsdf.format(calendar.getTime());
			firstDayOfMonth = date + " 00:00:00"; 				
			calendar.add(Calendar.MONTH, 1); 
	        calendar.set(Calendar.DAY_OF_MONTH, 1);  
	        calendar.add(Calendar.DATE, -1); 
	        lastDayOfMonth = nsdf.format(calendar.getTime()) + " 23:59:59"; 		        
	        result = getDatesOfRepTask(taskID, offset, primary, lastDayOfMonth, firstDayOfMonth, date, tenantID, companyID);			
			//result.remove(result.size() - 1);
			calendar.set(Calendar.DAY_OF_MONTH, 1);
		}			
		return result;
	}
	
	
}
