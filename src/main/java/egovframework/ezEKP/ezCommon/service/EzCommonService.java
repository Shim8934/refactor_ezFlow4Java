package egovframework.ezEKP.ezCommon.service;

import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.ezEKP.ezCommon.vo.ApprovPWDVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzCommonService {

	public String getContentInfo(String type, String itemID) throws Exception;
	
	public String wpCountLoginTime(String userID) throws Exception;
	
	public String startHtml2Mht(String strHTML, String realPath, Locale locale) throws Exception;
	
	public String getMHTtoHTML(String type, String itemID, String realPath, HttpServletRequest request, Locale locale) throws Exception;
	
	public String loadMHTFile(String path) throws Exception;
	
	public String startMHT2HTML(String filePath, String m_strMHT, String filePath2, HttpServletRequest request, Locale locale) throws Exception;
	
	public String saveUserLocalInfo (String pUserID, LoginVO userInfo) throws Exception;
	
	public String selectUserGetLang(String userID) throws Exception;
	
	public String selectUserGetTimeZone(String userID) throws Exception;
	
	public BoardAttachVO getAttachInfo(String type, String attID, String mode, int sn, String companyID)throws Exception;
	
	public ApprovPWDVO getApprovPWD(String userID) throws Exception;
	
	public void responseAttach(String pPhysicalFilePath, String pFileName, boolean pAttachment, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public void insertTblUserLocalInfo(Map<String, Object> map) throws Exception;

}
