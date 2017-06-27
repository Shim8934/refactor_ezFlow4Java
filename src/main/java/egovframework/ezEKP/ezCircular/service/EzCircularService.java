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

	public List<CircularListVO> getCircularList(String memberID, int startRow, int endRow, int tenantId, String offset) throws Exception;
	
	public List<CircularListVO> getSearchCircularList(String memberID, int startRow, int endRow, int tenantId, String keyword, int circularType, int folderID) throws Exception;

	public List<CircularListVO> getCircularCompleteList(String memberID, int startRow, int endRow, int tenantId, String offset) throws Exception;
	
	public List<CircularListVO> getCircularUserList(int circularID, String searchType, String searchValue, int tenantID) throws Exception;
	
	public List<CircularListVO> getCircularDeptUserList(int circularBMId, int tenantId) throws Exception;
	
	public List<CircularListVO> getCircularTempList(String memberID, int startRow, int endRow, String offset, int tenantId) throws Exception;

	public List<CircularAttachVO> getAttachList(int circularID, int tenantID) throws Exception;
	
	public List<CircularMemberVO> circularDeptModify(int circularBMId, int tenantId) throws Exception;

	public List<CircularMemberVO> getMemberName(int circularBMId, int tenantId) throws Exception;
	
	public List<CircularListVO> getMyCircularList(String memberID, int startRow, int endRow, int tenantID) throws Exception;

	public List<CircularFolderVO> getTopFolder(String id, int tenantId) throws Exception;

	public CircularConfigVO getCircularList_Config(String memberId, int tenantId) throws Exception;
	
	public CircularListVO getCircular(String circularID, int tenantID) throws Exception;
	
	public String setCircularConfig(String userID, int listCount, String preView, int tenantID) throws Exception;
	
	public String getcircularDeptList(CircularDeptVO circularDeptVO, LoginVO userInfo) throws Exception;
	
	public String getFolderInfo(int folderId, String memberId, int tenantId) throws Exception;
	
	public int getCircularListCount(String memberID, int tenantID) throws Exception;
	
	public int getConfirmStatusFirst(int circularID, int tenantID) throws Exception;
	
	public int getConfirmStatusSecond(int circularID, int tenantID) throws Exception;
	
	public int checkUpdateStatus(int circularID, String memberID, int tenantID) throws Exception;
	
	public int getCircularCompleteListCount(String memberID, int tenantID) throws Exception;
	
	public int getCircularTempListCount(String memberID, int tenantId) throws Exception;
	
	public int getMyCircularListCount(String memberID, int tenantId) throws Exception;
	
	public void setCircularList_Config(CircularConfigVO circularConfigVO) throws Exception;
	
	public void setCircularList_Config2(String userID, String listCount, String previewMode, String list, String content, int tenantID) throws Exception;
	
	public void insertCircular(int circularID, String title, int importance, int option, String content, int hasFile, int status, String memberID, String memberName, String memberName2, String regDate, String endDate, int tenantID, int receiverLength, String[] receiverID, int updateStatus, int circularUserId, String[] receiverName, String fileList, String[] receiverName2, String realPath) throws Exception;
	
	public void insertCircularUser(int circularUserID, int circularID, String memberID, String memberName, String memberName2, int status, String confirmDate, int updateStatus, int tenantID) throws Exception;
	
	public void modifyCircular(String title, int importance, int option, int circularID,int tenantID,  int receiverLength,String[] receiverID, int updateStatus, int circularUserId, String memberName, String memberName2, int status, String confirmDate,  String content, String fileList, String[] receiverName, String[] receiverName2) throws Exception;
	
	public void updateStatus(int status, int circularID, int tenantID) throws Exception;
	
	public void updateStatusUser(int status, int circularID, String confirmDate, int tenantID) throws Exception;
	
	public void confirmStatus(int circularID, String memberID, int tenantID) throws Exception;
	
	public void circularDeleteItem(String circularIDList,int tenantID) throws Exception;
	
	public void deleteCircularUser(int circularID,int tenantID) throws Exception;

	public void set_circularDeptSave(CircularDeptVO circularDeptVO, String[] memberListStr) throws Exception;

	public void circularDeptDel(String[] deleteList, int tenantId) throws Exception;

	public void update_circularDept(CircularDeptVO circularDeptVO, String[] memberListStr, int circularBMId) throws Exception;

	public void circularConfirmStatus(String[] circularIDList, String memberID, int tenantID) throws Exception;

	public void circularClose(String[] circularIDList, int tenantId) throws Exception;

	public void circularFolderAdd(String folderName, String memberId, String regDate, int tenantId) throws Exception;

	public void circularDeleteFolder(String deleteFolderId, String memberId, int tenantId) throws Exception;

	public void circularFolderModify(String folderId, String folderName, String memberId, String regDate, int tenantId) throws Exception;

	public int getCircularTDListCount(String memberId, int tenantId) throws Exception;

	public List<CircularListVO> getCircularTDList(String memberId, int startRow, int endRow, int tenantId) throws Exception;

	public void circularDeleteTemp(String circularIDList, String memberId, int tenantId) throws Exception;

	public void moveCircular(String folderId, String circularIdList, String memberId, String updateStatus, int tenantId) throws Exception;

	public int getFolderCircularListCount(int folderId, String memberId, int tenantId) throws Exception;

	public List<CircularListVO> getFolderCircularList(int folderId, String memberId, int startRow, int endRow, int tenantId) throws Exception;

	public void updateFolderId(String folderId, String circularIdList, String memberId, int tenantId) throws Exception;

	public String getItemXML(String pcircularId, String pmemberId, String offset, int tenantId) throws Exception;

	public List<CircularCommentVO> getCircularComment(CircularCommentVO circularCommentVO, String searchType, String searchValue, String offset, int tenantID) throws Exception;

	public void editCircularComment(CircularCommentVO circularCommentVO, LoginVO userInfo) throws Exception;

	public CircularAttachVO getAttachInfo(String circularFileID, int tenantId) throws Exception;

	public String getUpdateStatus(String circularIdList, String memberID, int tenantID) throws Exception;

	public List<CircularListVO> getSearchAllCircularList(String memberID, int startRow, int endRow, int tenantID, String keyword, int filterVal, String startDate, String endDate) throws Exception;

	public int getSearchAllCircularListCount(String memberID, int tenantID, String keyword, int filterVal, String startDate, String endDate) throws Exception;
	
	public void updateReadStatus(int circularID, String circularUserID, int status, int tenantID) throws Exception;

	public int getSearchCircularListCount(String memberID, int tenantID, String keyword, int circularType, int folderID) throws Exception;

	public List<CircularCommentVO> getCircularCommentUserList(String circularID, String circularUserID, int tenantID, String type) throws Exception;

	public void deleteCircularComment(CircularCommentVO circularCommentVO, LoginVO userInfo) throws Exception;

	public List<CircularListVO> getUserList(String memberID, int tenantID) throws Exception;

	public List<CircularListHeaderVO> getListHeader(CircularListHeaderVO headerVO) throws Exception;

}
