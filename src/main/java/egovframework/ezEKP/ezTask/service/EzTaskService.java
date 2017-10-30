package egovframework.ezEKP.ezTask.service;

import java.util.List;

import egovframework.ezEKP.ezTask.vo.TaskAttachVO;
import egovframework.ezEKP.ezTask.vo.TaskCommentVO;
import egovframework.ezEKP.ezTask.vo.TaskConfigVO;
import egovframework.ezEKP.ezTask.vo.TaskGeneralVO;
import egovframework.ezEKP.ezTask.vo.TaskInfoVO;
import egovframework.ezEKP.ezTask.vo.TaskShareVO;

public interface EzTaskService {
	List<TaskCommentVO> getCommentList(String taskID, String offset, String primary, int tenantID) throws Exception;
	
	List<TaskShareVO> getShareList(String taskID, String primary, int tenantID) throws Exception;
	
	List<TaskAttachVO> getAttachList(String taskID, String realPath, String type, int tenantID) throws Exception;
	
	List<TaskInfoVO> getTaskList(String userID, String startDate, String endDate, String offset, String type, String filter, String chkValue, String searchClass, String taskStatusCount, String primary, String pSelectTab, int tenantID) throws Exception;

	TaskGeneralVO getTaskGeneral(String userID, int tenantID) throws Exception;

	TaskInfoVO getTaskInfo(String taskID, String offset, String primary, int tenantID) throws Exception;
	
	TaskConfigVO getOriginColor(String userID, int tenantID) throws Exception;
	
	String getAttachListStr(String taskID, String folderPath, String type, int tenantID) throws Exception;
	
	String taskWorkSave(String taskID, String content, String attachList, String fileName, String fileSize, String personAttach, String contentPath, String realPath, String uploadTaskPath, int tenantID) throws Exception;
	
	String getTaskCount(String userID, String offset, String type, String filter, String chkValue, String primary, int tenantID) throws Exception;
	
	int insertComment(String taskID, String commentorID, String commentorName, String commentorName2, String comment, int tenantID) throws Exception;
	
	void deleteComment(String taskID, String commentID, int tenantID) throws Exception;
	
	void updateTaskStatus(String taskID, String taskStatus, String completeRate, int tenantID) throws Exception;
	
	void taskSave(TaskInfoVO taskInfoVO, String realPath, String uploadTaskPath, String content, String fileList, String offset, String fileSize, String fileName, int tenantID) throws Exception;
	
	void taskSaveConfig(String memberID, String delayColor, String completeColor, String originColor, String originColor2, int tenantID) throws Exception;
	
	void taskUpdateConfig(String memberID, String delayColor, String completeColor, String originColor, String originColor2, int tenantID) throws Exception;
	
	void taskDelete(String taskIDList, String pDirPath, String offset, String primary, String memberID, int tenantID) throws Exception;

	void taskSaveGeneral(String userID, int listCount, String selectTaskStatus, int tenantID) throws Exception;

	void updateTaskGeneral(String userID, int listCount, String selectTaskStatus, int tenantID) throws Exception;

	void insertTaskRepeDel(String taskID, String repeatCount, String taskStatus, String completeRate, String realDate, int tenantID) throws Exception;
}
