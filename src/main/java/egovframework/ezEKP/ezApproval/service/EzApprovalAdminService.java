package egovframework.ezEKP.ezApproval.service;

import java.util.List;
import java.util.Locale;

import org.w3c.dom.Document;

import egovframework.ezEKP.ezApproval.vo.ApprContInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocInfoVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzApprovalAdminService {

	public List<ApprContInfoVO> getUseContInfo(ApprContInfoVO apprContInfoVO) throws Exception;

	public List<ApprDocInfoVO> getCodeContainer(LoginVO userInfo) throws Exception;

	public String getUserContTree(LoginVO userInfo, String parentContID) throws Exception;

	public String getListContainer(LoginVO userInfo) throws Exception;

	public String getDeptContTree(LoginVO userInfo, String parentContID) throws Exception;

	public List<ApprContInfoVO> getSpecialContTree(LoginVO userInfo) throws Exception;

	public String getDocType(String selected, LoginVO userInfo) throws Exception;

	public String getContainerInfoManage(String deptID, String mode, String companyID, LoginVO userInfo) throws Exception;

	public String getContTypeInfo(String mode, String companyID, LoginVO userInfo) throws Exception;

	public String insertContainerType(String docTypeName, String docTypeName2, String companyID, int tenantID) throws Exception;

	public String deleteContainerType(String codeID, String companyID, int tenantID) throws Exception;

	public String getContainerToDocStateInfo(String companyID, Locale locale, String lang, int tenantID) throws Exception;

	public String updateContainerToDocStateInfo(Document doc, String companyID, String lang, int tenantID) throws Exception;

	public String getContainerUseDeptInfo(String contID, String companyID, String lang, int tenantID) throws Exception;

	public String insertContainer(String contType, String contOwnDeptID, String selUseDept, String companyID, String lang, int tenantID) throws Exception;

	public String updateContainer(String contType, String contID, String contOwnDeptID, String selUseDept, String companyID, String lang, int tenantID) throws Exception;

	public String deleteContainer(String contID, String companyID, String lang, int tenantID) throws Exception;

}
