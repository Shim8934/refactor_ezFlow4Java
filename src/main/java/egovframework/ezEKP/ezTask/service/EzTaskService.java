package egovframework.ezEKP.ezTask.service;

import egovframework.ezEKP.ezTask.vo.TaskInfoVO;

public interface EzTaskService {

	/* 이효진*/
	TaskInfoVO getTaskInfo(String taskID, String offset, String primary, int tenantID) throws Exception;
	
	/* 정수현*/
	public void taskSaveConfig(String memberID, String delayColor, int autoDelete, int tenantID) throws Exception;

	public String getDelayColor(String memberID, int tenantID) throws Exception;

	public void taskUpdateConfig(String memberID, String delayColor, int autoDelete, int tenantID) throws Exception;
}
