package egovframework.ezEKP.ezCircular.service;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezCircular.vo.CircularConfigVO;
import egovframework.ezEKP.ezCircular.vo.CircularListVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzCircularService {
	
	public List<CircularListVO> getCircularList(String memberID,int tenantId) throws Exception;
	
	public CircularConfigVO getPersonalCount(LoginVO userInfo) throws Exception;

	public CircularConfigVO getCircularList_Config(String memberId, int tenantId) throws Exception;
	
	public CircularListVO getCircular(String circularID, int tenantID) throws Exception;
	
	public String setCircularConfig(String userID, int listCount, String preView, int tenantID) throws Exception;

	public void setCircularList_Config(CircularConfigVO circularConfigVO) throws Exception;
	
	public void setCircularList_Config2(String userID, String listCount, String previewMode, String list, String content, int tenantID) throws Exception;
	
	public void insertCircular(int circularID, String title, int importance, int option, String content, int hasFile, int status, String memberID, String memberName, String memberName2, String regDate, String endDate, int tenantID) throws Exception;
	
	public void insertCircularUser(int circularUserID, int circularID, String memberID, String memberName, String memberName2, int status, String confirmDate, int updateStatus, int tenantID) throws Exception;
	
	public void modifyCircular(int circularID,int tenantID) throws Exception;
	
	public void modifyCircularUser(int circularID,int tenantID) throws Exception;
	
	public void deleteCircular(int circularID,int tenantID) throws Exception;
	
	public void deleteCircularUser(int circularID,int tenantID) throws Exception;
}
