package egovframework.ezEKP.ezTask.service;

import java.util.List;

import org.w3c.dom.Document;

import egovframework.ezEKP.ezTask.vo.TaskCommentVO;
import egovframework.ezEKP.ezTask.vo.TaskInfoVO;
import egovframework.ezEKP.ezTask.vo.TaskShareVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzTaskService {

	/* 이효진*/
	TaskInfoVO getTaskInfo(String taskID, String offset, String primary, int tenantID) throws Exception;
	
	List<TaskCommentVO> getCommentList(String taskID, String offset, String primary, int tenantID) throws Exception;
	
	List<TaskShareVO> getShareList(String taskID, String offset, String primary, int tenantID) throws Exception;
	
	int insertComment(String taskID, String commentorID, String commentorName, String commentorName2, String comment, int tenantID) throws Exception;
	
	void deleteComment(String taskID, String commentID, int tenantID) throws Exception;
	
	/* 정수현*/
	public void taskSaveConfig(String memberID, String delayColor, int autoDelete, int tenantID) throws Exception;

	public String getDelayColor(String memberID, int tenantID) throws Exception;

	public void taskUpdateConfig(String memberID, String delayColor, int autoDelete, int tenantID) throws Exception;

	public String taskSave(Document doc, String realPath, LoginVO userInfo, String newGuid) throws Exception;

	List<TaskInfoVO> taskGetList(String memberID, String startDate, String endDate, String offset, String app, String type, int tenantID) throws Exception;

	String getTaskCount(String memberID, String startDate, String endDate, String offset, String type, int tenantID) throws Exception;
}
