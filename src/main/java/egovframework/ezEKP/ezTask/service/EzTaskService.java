package egovframework.ezEKP.ezTask.service;

import egovframework.ezEKP.ezTask.vo.TaskInfoVO;

public interface EzTaskService {
	/* 이효진*/
	TaskInfoVO getTaskInfo(String taskID, String offset, String primary, int tenantID) throws Exception;
	
	/* 정수현*/
}
