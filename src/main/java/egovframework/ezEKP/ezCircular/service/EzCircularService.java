package egovframework.ezEKP.ezCircular.service;

import java.util.HashMap;
import java.util.List;

import egovframework.ezEKP.ezCircular.vo.CircularConfigVO;
import egovframework.ezEKP.ezCircular.vo.CircularListVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.ezEKP.ezCircular.vo.CircularDeptVO;

public interface EzCircularService {
	
	public List<CircularListVO> getCircularList(String memberID, int startRow, int endRow, int tenantId) throws Exception;
	
	public List<HashMap<String, Object>> getCircularMapList(String memberID, int startRow, int endRow, int tenantId) throws Exception;
	
	public CircularConfigVO getPersonalCount(LoginVO userInfo) throws Exception;

	public CircularConfigVO getCircularList_Config(String memberId, int tenantId) throws Exception;
	
	public CircularListVO getCircular(String circularID, int tenantID) throws Exception;
	
	public String setCircularConfig(String userID, int listCount, String preView, int tenantID) throws Exception;
	
	public int getCircularListCount(String memberID, int tenantID) throws Exception;
	
	public int getConfirmStatusFirst(int circularID, int tenantID) throws Exception;
	
	public int getConfirmStatusSecond(int circularID, int tenantID) throws Exception;
	
	public void setCircularList_Config(CircularConfigVO circularConfigVO) throws Exception;
	
	public void setCircularList_Config2(String userID, String listCount, String previewMode, String list, String content, int tenantID) throws Exception;
	
	public void insertCircular(int circularID, String title, int importance, int option, String content, int hasFile, int status, String memberID, String memberName, String memberName2, String regDate, String endDate, int tenantID, int receiverLength, String[] receiverID, int updateStatus, int circularUserId) throws Exception;
	
	public void insertCircularUser(int circularUserID, int circularID, String memberID, String memberName, String memberName2, int status, String confirmDate, int updateStatus, int tenantID) throws Exception;
	
	public void modifyCircular(String title, int importance, int option, int circularID,int tenantID) throws Exception;
	
	public void updateStatus(int status, int circularID, int tenantID) throws Exception;
	
	public void updateStatusUser(int status, int circularID, String confirmDate, int tenantID) throws Exception;
	
	public void confirmStatus(int circularID, String memberID, int tenantID) throws Exception;
	
	public void deleteCircular(int circularID,int tenantID) throws Exception;
	
	public void deleteCircularUser(int circularID,int tenantID) throws Exception;

	public void set_circularDeptSave(CircularDeptVO circularDeptVO, String[] memberListStr) throws Exception;

	public String getcircularDeptList(CircularDeptVO circularDeptVO) throws Exception;

	public void circularDeptDel(CircularDeptVO circularDeptVO) throws Exception;

	public void update_circularDept(CircularDeptVO circularDeptVO) throws Exception;

	public String circularDeptModify(int circularBMId, int tenantId) throws Exception;
	
}
