package egovframework.ezEKP.ezApprovalG.service;

import org.w3c.dom.Document;

public interface EzApprovalGAdminService {

	public String getContainerInfoManage(String deptID, String type, String companyID, String lang) throws Exception;

	public String getContTypeInfo(String type, String companyID, String lang) throws Exception;
	
	public String deleteContainerType(String docTypeID, String companyID) throws Exception;
	
	public String getContainerToDocStateInfo(String companyID, String lang) throws Exception;
	
	public String updateContainerToDocStateInfo(Document xmlData, String companyID) throws Exception;
	
	public String getContainerUseDeptInfo(String contID, String companyID, String lang) throws Exception;
	
	public String insertContainer(Document xmlData, String companyID) throws Exception;
	
	public String updateContainer(Document doc, String companyID) throws Exception;
	
	public String deleteContainer(String contID, String companyID) throws Exception;

	public void insertContainerType(String docTypeName, String docTypeName2, String companyID) throws Exception;
	

}
