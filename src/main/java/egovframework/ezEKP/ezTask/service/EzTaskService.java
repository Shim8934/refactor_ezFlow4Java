package egovframework.ezEKP.ezTask.service;

public interface EzTaskService {

	/* 이효진*/
	
	/* 정수현*/
	public void taskSaveConfig(String memberID, String delayColor, int autoDelete, int tenantID) throws Exception;

	public String getDelayColor(String memberID, int tenantID) throws Exception;

	public void taskUpdateConfig(String memberID, String delayColor, int autoDelete, int tenantID) throws Exception;
}
