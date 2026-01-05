package egovframework.ezEKP.ezCircular.service;

import java.util.List;

import egovframework.ezEKP.ezCircular.vo.CircularAttachVO;
import egovframework.ezEKP.ezCircular.vo.CircularCommentVO;
import egovframework.ezEKP.ezCircular.vo.CircularConfigVO;
import egovframework.ezEKP.ezCircular.vo.CircularDeptVO;
import egovframework.ezEKP.ezCircular.vo.CircularFolderVO;
import egovframework.ezEKP.ezCircular.vo.CircularListHeaderVO;
import egovframework.ezEKP.ezCircular.vo.CircularListVO;
import egovframework.ezEKP.ezCircular.vo.CircularMemberVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzCircularService {

	public List<CircularListVO> getCircularList(String memberID, String searchValue, String searchType, String sdate, String edate, int startRow, int endRow, int tenantId, String offset, String orderCell, String orderOption, String companyID, String lang) throws Exception;

	public List<CircularListVO> getCircularCompleteList(String memberID, String searchValue, String searchType, String sdate, String edate, int startRow, int endRow, int tenantId, String offset, String orderCell, String orderOption, String companyID, String lang) throws Exception;
	
	public List<CircularListVO> getCircularUserList(int circularID, String searchType, String searchValue, int tenantID, String offset) throws Exception;
	
	public List<CircularListVO> getCircularDeptUserList(int circularBMId, int tenantId) throws Exception;
	
	public List<CircularListVO> getCircularTempList(String memberID, String searchValue, String searchType, String sdate, String edate, int startRow, int endRow, String offset, int tenantId, String orderCell, String orderOption, String companyID, String lang) throws Exception;

	public List<CircularListVO> getMyCircularList(String memberID, String searchValue, String searchType, String sdate, String edate, int startRow, int endRow, String offset, int tenantID, String orderCell, String orderOption, String companyID, String lang) throws Exception;
	
	public List<CircularListVO> getCircularTDList(String memberID, String searchValue, String searchType, int startRow, int endRow, int tenantID, String offset, String orderCell, String orderOption, String companyID, String lang) throws Exception;
	
	public List<CircularListVO> getFolderCircularList(String folderId, String memberId, int startRow, int endRow, String offset, String searchValue, String searchType, String sdate, String edate, int tenantId, String orderCell, String orderOption, String companyID, String lang) throws Exception;
	
	public List<CircularListVO> getUserList(String memberID, int tenantID) throws Exception;
	
	public List<CircularAttachVO> getAttachList(int circularID, int tenantID) throws Exception;
	
	public List<CircularMemberVO> getMemberName(String circularBMId, int tenantID, String companyID, String primary) throws Exception;
	
	public List<CircularFolderVO> getTopFolder(String id, int tenantId, String companyID) throws Exception;

	public List<CircularCommentVO> getCircularComment(CircularCommentVO circularCommentVO, String searchType, String searchValue, String circularUserID, String commentType, String offset, int tenantID) throws Exception;
	
	public List<CircularCommentVO> getCircularCommentUserList(String circularID, String circularUserID, int tenantID, String type) throws Exception;
	
	public List<CircularListHeaderVO> getListHeader(String listType, String lang, int tenantID) throws Exception;
	
	public List<CircularDeptVO> getcircularDeptList(String memberID, String offset, int tenantID, String companyID) throws Exception;
	
	public StringBuffer getConfirmMemberList(String circularID, int pageNum, int perCount, String offset, LoginVO userInfo) throws Exception;
	
	public CircularConfigVO getCircularList_Config(String memberId, int tenantId) throws Exception;
	
	public CircularListVO getCircular(String circularID, String memberID, String offset, int tenantID, String type, String lang) throws Exception;

	public CircularAttachVO getAttachInfo(String circularFileID, int tenantId) throws Exception;

	public String setCircularConfig(String userID, int listCount, String preView, int tenantID) throws Exception;

	public String getFolderInfo(int folderId, String memberId, int tenantId) throws Exception;

	public String getItemXML(String pcircularId, String pmemberId, String offset, int tenantId, String lang) throws Exception;

	public int getCircularListCount(String memberID, String searchValue, String searchType, String sdate, String edate, String offset, int tenantID, String companyID, String lang) throws Exception;

	public int checkUpdateStatus(int circularID, String memberID, int tenantID) throws Exception;

	public int getCircularCompleteListCount(String memberID, String searchValue, String searchType, String sdate, String edate, String offset, int tenantID, String companyID, String lang) throws Exception;

	public int getCircularTempListCount(String memberID, String searchValue, String searchType, String sdate, String edate, String offset, int tenantId, String companyID, String lang) throws Exception;

	public int getMyCircularListCount(String memberID, String searchValue, String searchType, String sdate, String edate, String offset, int tenantId, String companyID, String lang) throws Exception;

	public int getCircularTDListCount(String memberID, String searchValue, String searchType, int tenantID, String companyID, String lang) throws Exception;

	public int getFolderCircularListCount(String folderId, String memberId, String searchValue, String searchType, String sdate, String edate, String offset, int tenantId, String companyID, String lang) throws Exception;
	
	public int getCommentCount(String circularID, String memberID, String type, int tenantID) throws Exception;
	
	public int getListCount(String listType, String userID, int tenantID, String companyID) throws Exception;

	public int checkFolder(String deleteFolder, String memberID, int tenantID) throws Exception;

	public void setCircularList_Config(CircularConfigVO circularConfigVO) throws Exception;
	
	public void setCircularList_Config2(String userID, String listCount, String previewMode, String list, String content, int tenantID) throws Exception;
	
	public void insertCircular(int circularID, String title, int importance, int option, String content, int hasFile, int status, String regDate, String endDate, int receiverLength, String[] receiverID, int updateStatus, int circularUserId, String[] receiverName, String fileList, String[] receiverName2, String pDirPath, String mode, LoginVO userInfo, String loginCookie) throws Exception;
	
//	public void insertCircularUser(int circularUserID, int circularID, String memberID, String memberName, String memberName2, int status, String confirmDate, int updateStatus, int tenantID) throws Exception;
	
	public void modifyCircular(String title, int importance, int option, int circularID,int tenantID,  int receiverLength,String[] receiverID, int updateStatus, int circularUserId, String memberName, String memberName2, int status, String confirmDate,  String content, String fileList, String pDirPath, String[] receiverName, String[] receiverName2, String offset, String companyID) throws Exception;

	public void deleteCircularList(String circularIDList, String memberIDList, String memberID, String pDirpath, int tenantID) throws Exception;
	
	public void deleteCircular(String circularID, String memberID, String userID, int tenantID) throws Exception;
	
	public void deleteCircularUser(int circularID,int tenantID) throws Exception;

	public void setCircularDeptSave(String title, String userID, String[] memberListStr, int tenantID, String companyID) throws Exception;

	public void circularDeptDel(String circularBMIdList, int tenantID) throws Exception;

	public void updateCircularDept(String title, String userID, String[] memberListStr, String circularBMId, int tenantID, String companyID) throws Exception;

	public void circularConfirmStatus(String circularIDList, String memberID, int tenantID) throws Exception;

	public void circularClose(String circularIDList, int tenantId, String endDate) throws Exception;

	public void circularFolderAdd(String folderName, String memberId, String regDate, int tenantId, String companyID) throws Exception;

	public void circularDeleteFolder(String deleteFolderId, String memberId, int tenantId) throws Exception;

	public void circularFolderModify(String folderId, String folderName, String memberId, String regDate, int tenantId) throws Exception;

	public void circularDeleteTemp(String circularIDList, String memberId, int tenantId) throws Exception;

	public void moveCircular(String folderId, String circularIdList, String memberId, String updateStatus, String originLoc, int tenantId, String companyID) throws Exception;

	public void updateFolderId(String folderId, String circularIdList, String memberId, int tenantId) throws Exception;

	public void editCircularComment(CircularCommentVO circularCommentVO, LoginVO userInfo, String loginCookie) throws Exception;
	
	public void deleteCircularComment(CircularCommentVO circularCommentVO, LoginVO userInfo) throws Exception;
	
	public void circularReturn(String circularIdList, String folderID, String memberID, int tenantID) throws Exception;
	
	public void commentShareUser(String circularID, String circularCommentID, String memberIDList, LoginVO userInfo, String loginCookie) throws Exception;
	
	public void confirmStatus(String circularID, String memberID, int tenantID, String type) throws Exception;

	public void updateCircular(String title, int importance, int option, String circularID, int tenantID, String memberID, int receiverLength, int status, String loginCookie, LoginVO userInfo, String regDate, String content, String fileList, String offset, String[] receiverID, String[] receiverName, String[] receiverName2, int circularUserID, int updateStatus, String mode, String pDirPath) throws Exception;

	public void restoreCircular(String circularIDList, String memberID, int tenantID) throws Exception;

	public void copyFileList(String pDirPath, String fileName, String circularID) throws Exception;
	
	public CircularMemberVO getCircularUserDeptId(int tenantID, String companyID, String circularUserID) throws Exception;

}
