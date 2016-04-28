package egovframework.ezEKP.ezApprovalG.service;

import java.util.List;

import org.w3c.dom.Document;

import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzApprovalGService {

	public List<ApprGLeftVO> getUseContInfo(LoginVO userInfo, String ownFlag) throws Exception;

	public String getOptionInfo(String code1, String code2, LoginVO userInfo, String mode) throws Exception;

	public String aprDocList(String listType, String userID, String deptID, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String userLang, String searchQuery, Document dueryData) throws Exception;

	public String getProxyUser(String id, String string) throws Exception;

	public String getAprLineInfo(String docID, String flag, String userID, String formID, String companyID) throws Exception;

}
