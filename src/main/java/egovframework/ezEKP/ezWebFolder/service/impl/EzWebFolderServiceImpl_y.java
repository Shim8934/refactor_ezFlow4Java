package egovframework.ezEKP.ezWebFolder.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO_y;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzWebFolderService_y")
public class EzWebFolderServiceImpl_y implements EzWebFolderService_y {
	@Resource(name = "EzWebFolderDAO_y")
	private EzWebFolderDAO_y ezWebFolderDAO;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EzWebFolderServiceImpl_y.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	public LoginVO getUserInfo ( int tenantId ,String comId, String userId ){
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId",tenantId);
		map.put("comId", comId);
		map.put("userId", userId);
		
		LoginVO userInfo = ezWebFolderDAO.getUserInfo(map);
		return userInfo;
	}
	
	// fileList출력
	public List<FileVO> getFileList(String folderId,String folderType, int tenantId,
			String companyId, String searchExt, String searchFileName,
			String searchStartDate, String searchEndDate,
			String searchCreateName, String searchFileType,
			String searchPageCount, String searchListCount, int pStart , int pEnd) throws Exception {
		
		String parentId = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId",folderId);
		map.put("tenantId",tenantId);
		parentId = ezWebFolderDAO.getparentId (map);
		
		map.put("parentId", parentId);
		map.put("folderType",folderType);
		map.put("comId",companyId);
		map.put("searchExt", searchExt);
		map.put("searchFileName", searchFileName);
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		map.put("searchCreateName", searchCreateName);
		map.put("searchFileType", searchFileType);
		map.put("searchPageCount", searchPageCount);
		map.put("searchListCount", searchListCount);
		map.put("pStart", pStart);
		map.put("pEnd", pEnd);
		
		List<FileVO> filevo = (List<FileVO>) ezWebFolderDAO.getFileList(map);
		return filevo;
	}
	
	// fileTotalCount
	public int getFileToTalCount (String folderId,String folderType, int tenantId,
			String companyId, String searchExt, String searchFileName,
			String searchStartDate, String searchEndDate,
			String searchCreateName, String searchFileType,
			String searchPageCount, String searchListCount, int pStart , int pEnd) throws Exception {
		
		String parentId = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId",folderId);
		map.put("tenantId",tenantId);
		parentId = ezWebFolderDAO.getparentId (map);
		
		map.put("parentId", parentId);
		map.put("folderType",folderType);
		map.put("comId",companyId);
		map.put("searchExt", searchExt);
		map.put("searchFileName", searchFileName);
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		map.put("searchCreateName", searchCreateName);
		map.put("searchFileType", searchFileType);
		map.put("searchPageCount", searchPageCount);
		map.put("searchListCount", searchListCount);
		map.put("pStart", pStart);
		map.put("pEnd", pEnd);
		int totalCnt = ezWebFolderDAO.getFileTotalCount(map);
		System.out.println(totalCnt);
		String test_totalCnt = totalCnt+"";
		LOGGER.debug(test_totalCnt);
		
		return totalCnt;
	}
	
	@Override
	public List<Map<String, Object>> getFolderList(String admin, String userId,String deptId, String comId ,
			String folderId, String folderType, int tenantId) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userId", userId);
		map.put("deptId", deptId);
		map.put("comId", comId);
		map.put("folderId", folderId);
		map.put("folderType", folderType);
		map.put("tenantId", tenantId);
		List<Map<String, Object>> folderList = new ArrayList<Map<String,Object>>();
		
		if ( folderType.equals("C")) {
			if (admin.equals("ad")) {
				folderList = ezWebFolderDAO.getFolderListAd(map);
			} else {
				folderList = ezWebFolderDAO.getFolderList(map);
			}
		}else if ( folderType.equals("D")) {
			// TODO: 부서폴더 다시해야함 
			folderList = ezWebFolderDAO.getFolderListDept(map);
		}else if ( folderType.equals("U")) {
			folderList = ezWebFolderDAO.getFolderListUser(map);
		}else if ( folderType.equals("")) {
			folderList = ezWebFolderDAO.getFolderListAll(map);
		}
		
		System.out.println(folderList.size());
		
		
		
		return folderList;
	}

	@Override
	public FolderVO getFolderDetail(String folderUppId,  String userId,	int tenantId, String comId) throws Exception {
		FolderVO uppFolder  = new FolderVO() ;
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderUppId", folderUppId);
		map.put("tenantId", tenantId);
		map.put("comId", comId);
		map.put("userId", userId);
		uppFolder = ezWebFolderDAO.getFolderDetail(map);
		
		return uppFolder;
	}


	@Override					
	public String insertFolder(int tenantId, String comId, String userId, String newFolderName1, String newFolderName2, FolderVO uppFolder) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		
		
		LoginVO loginvo =  getUserInfo(tenantId,comId,userId);
		System.out.println("여기는 insertFolder_serviceImpl");
		
//		String folderUppId  = uppFolder.getFolderUpper();
//		String folderType   = uppFolder.getFolderType();
//		int folderStep   = uppFolder.getFolderStep();
//		int folderLevel  = uppFolder.getFolderLevel();
//		String createName1  = uppFolder.getCreateName1();
//		String folderPath   = uppFolder.getFolderPath();
//		String ownerId   = uppFolder.getOwnerId();
		
		map.put("tenantId", 	 tenantId);
		map.put("folderUppId",	 uppFolder.getFolderId());
		int folderStep = ezWebFolderDAO.getFolderStep(map);
		
		map.put("userId", 		 userId);
		map.put("comId",		 comId);
		map.put("folderType",	 uppFolder.getFolderType());
		map.put("folderName1", 	 newFolderName1);
		map.put("folderName2", 	 newFolderName2);
		map.put("folderStep",	 folderStep );
		map.put("folderLevel",	 uppFolder.getFolderLevel()+1);
		map.put("folderPath", 	 uppFolder.getFolderPath());
		map.put("createName1",	 loginvo.getId() );
		
		// displayName2가 비어 있는 사람은 displayName을 넣는다.
		if ( loginvo.getDisplayName2().equals("")) {
			map.put("createName2", loginvo.getDisplayName());
		} else {
			map.put("createName2",	 loginvo.getDisplayName2() );
		}
//		System.out.println("folderType 은 " + uppFolder.getFolderType());
//		// folderType에 따라서 ownerId 다르게 주어짐 c:company , D:depertment , U:user
//		if (uppFolder.getFolderType().equals("C")) {
//			System.out.println("여기는 C");
//			map.put("ownerId", 	 loginvo.getCompanyID());
//		} else if (uppFolder.getFolderType().equals("D")) {
//			System.out.println("여기는 D");
//			map.put("ownerId",loginvo.getDeptID());
//		} else if (uppFolder.getFolderType().equals("U")) {
//			System.out.println("여기는 U");
//			map.put("ownerId", 	 loginvo.getId());
//		}
		map.put("ownerId", 	 uppFolder.getOwnerId());
		System.out.println("결론적으로 ownerId는 " + map.get("ownerId"));
		System.out.println("결론적으로 loginVo.getDeptId는 " +loginvo.getDeptID());
		
		
		System.out.println("dao가기 바로 직전");
		String result = ezWebFolderDAO.insertFolder(map);
		System.out.println("여기는 insertFolder_serviceImpl_ result후 result");
		System.out.println(result + ""+ "값이 돌아왔습니다.");
		if ( result.equals(null)) {
			result = "fail";
		} else {
			result = "ok";
		}
		return result;
	}
	
	
	
}
