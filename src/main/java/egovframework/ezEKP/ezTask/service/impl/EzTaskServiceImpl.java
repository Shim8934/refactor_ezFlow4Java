package egovframework.ezEKP.ezTask.service.impl;

import java.io.File;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.beanutils.BeanUtils;
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
	public void taskSaveConfig(String memberID, String delayColor, String completeColor, String originColor, String originColor2, int tenantID) throws Exception {
		logger.debug("taskSaveConfig started.");
		logger.debug("memberID : " + memberID + " | delayColor : " + delayColor + " | completeColor : " + completeColor + " | originColor : " + originColor + " | originColor2 : " + originColor2);

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
	public List<TaskInfoVO> getTaskList(String userID, String startDate, String endDate, String offset,String type, String filter, String chkValue, String searchClass, String taskStatusCount, String primary, String pSelectTab, int tenantID) throws Exception {
		logger.debug("getTaskList started.");
		logger.debug("userID : " + userID + " | startDate : " + startDate + " | endDate : " + endDate + " | type : " + type + " | filter : " + filter + " | chkValue : " + chkValue + " | searchClass : " + searchClass + " | taskStatusCount : " + taskStatusCount + " | pSelectTab : " + pSelectTab);

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
		List<TaskInfoVO> resultList = new ArrayList<TaskInfoVO>();
		
		for (int i=0; i < list.size(); i++) {
			TaskInfoVO vo = list.get(i);
			
			if (startDate.equals("")) {
//				startDate = vo.getStartDate();
				startDate = commonUtil.getTodayUTCTime("yyyy-MM-dd") + " 00:00:00";
			}
			
			if (endDate.equals("")) {
//				endDate = vo.getEndDate();
				endDate = commonUtil.getTodayUTCTime("yyyy-MM-dd") + " 23:59:59";
			}

			if (vo.getTaskType().equals("4") && !pSelectTab.equals("taskrepetition")) {
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

				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
				SimpleDateFormat nsdf = new SimpleDateFormat("yyyy-MM-dd");

				logger.debug("startDate : " + startDate + " | endDate : " + endDate + " | currentEndDate : " + currentEndDate);

				sDate_cal.setTime(sdf.parse(startDate));
				eDate_cal.setTime(sdf.parse(currentEndDate));
				date_cal.setTime(sdf.parse(vo.getStartDate()));

				logger.debug("sDate_cal : " + sDate_cal + " | eDate_cal : " + eDate_cal + " | date_cal : " + date_cal);

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
	
								if (calcuDate.compareTo(startDate.substring(0,10)) >= 0 && calcuDate.compareTo(endDate.substring(0,10)) <= 0) {	
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
						int weekcount = 6 - date_cal.get(Calendar.DAY_OF_WEEK) - 1;
						
						while (true) {
							if (date_cal.compareTo(eDate_cal) > 0) break;
							if (maxCount == count) break;
							
							boolean generated = false;
	
							if (info[4].indexOf((date_cal.get(Calendar.DAY_OF_WEEK) - 1) + "") > -1) {
								generated = true;
							}
							
							if (generated) {
								count++;
								
								String calcuDate = nsdf.format(date_cal.getTime());
								
								if (calcuDate.compareTo(startDate.substring(0,10)) >= 0 && calcuDate.compareTo(endDate.substring(0,10)) <= 0) {	
									//row 추가
									if (!rList.contains(calcuDate)) {
										TaskInfoVO rVo = addRepeatRow(vo, date_cal.getTime(), count, info[1]);									
										resultList.add(rVo);
									}
								}
							}
							
							if (weekcount == 0) {
								date_cal.add(Calendar.DATE, (Integer.parseInt(info[3]) - 1) * 7 + 1);
								weekcount = 6;
							} else {
								date_cal.add(Calendar.DATE, 1);
								weekcount--;
							}
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
								
								if (calcuDate.compareTo(startDate.substring(0,10)) >= 0 && calcuDate.compareTo(endDate.substring(0,10)) <= 0) {
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
								
								if (calcuDate.compareTo(startDate.substring(0,10)) >= 0 && calcuDate.compareTo(endDate.substring(0,10)) <= 0) {
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
			} else {
				resultList.add(vo);
			}
		}

		logger.debug("listsize = " + list.size());
		logger.debug("getTaskList ended.");

		return resultList;
	}

	public TaskInfoVO addRepeatRow(TaskInfoVO vo, Date date, int count, String dateType) throws Exception {
		
		SimpleDateFormat nsdf = new SimpleDateFormat("yyyy-MM-dd");
		TaskInfoVO innerVO = new TaskInfoVO();

		logger.debug("vo.getStartDate : " + vo.getStartDate() + " | vo.getEndDate() : " + vo.getEndDate());

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
		String cnt3 = ezTaskDAO.getTaskCount3(map); // 지시,협조 중 진행중 count
		String allCnt = ezTaskDAO.getTaskAllCount(map); // 개인 + 지시,협조 count

		rtnCnt = cnt + "," + cnt2 + "," + cnt3 + "," + allCnt;

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
		map.put("repetition", vo.getRepetition());
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
}
