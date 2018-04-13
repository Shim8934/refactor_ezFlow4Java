package egovframework.ezEKP.ezWebFolder.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
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
	@Autowired
	private EzWebFolderDAO_y ezWebFolderDAO_y;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EzWebFolderServiceImpl_y.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	public LoginVO getUserInfo ( int tenantId ,String comId, String userId ){
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId",tenantId);
		map.put("comId", comId);
		map.put("userId", userId);
		
		LoginVO userInfo = ezWebFolderDAO_y.getUserInfo(map);
		return userInfo;
	}
	
	// fileList출력
	public List<FileVO> getFileList(String folderId,String folderType,String userId,String deptId, int tenantId,
			String comId, String searchExt, String searchFileName, String searchStartDate, String searchEndDate,
			String searchCreateName, String searchFileType, String searchPageCount, int pStart , int pEnd , String offset
			, String primary) throws Exception {
		
		String parentId = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId",folderId);
		map.put("tenantId",tenantId);
		map.put("comId",comId);
		FolderVO detailFld = ezWebFolderDAO_y.getFolderDetail(map);
		parentId = detailFld.getFolderUpper();
		String folderPath = detailFld.getFolderPath();
		String flag = "0";
		map.put("flag", flag);
		map.put("deptId", deptId);
		map.put("userId", userId);
		map.put("folderPath", folderPath);
		map.put("parentId", parentId);
		map.put("folderType",folderType);
		map.put("searchExt", searchExt);
		map.put("searchFileName", searchFileName);
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		map.put("searchCreateName", searchCreateName);
		map.put("searchFileType", searchFileType);
		map.put("pStart", pStart);
		map.put("pEnd", pEnd);
		map.put("offset", offset);
		map.put("primary", primary);
		List<FileVO> filevo  = new ArrayList<FileVO>();
		if (searchExt != "" || searchStartDate != "" || searchEndDate != "" || searchCreateName != "" || searchFileName!="" ) {
			flag = "1";
		}
		map.put("flag", flag);
		if (flag.equals("1")) {
			filevo = (List<FileVO>) ezWebFolderDAO_y.searchFileList(map);
		}else {
			filevo = (List<FileVO>) ezWebFolderDAO_y.getFileList(map);
		}
		return filevo;
	}
	
	// fileTotalCount
	public Map<String, Integer> getFileToTalCount (String folderId,String folderType,String userId,String deptId, int tenantId,
			String companyId, String searchExt, String searchFileName,
			String searchStartDate, String searchEndDate,
			String searchCreateName, String searchFileType,
			String searchPageCount, int pStart , int pEnd , String offset , String primary) {
		
		String parentId = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId",folderId);
		map.put("tenantId",tenantId);
		map.put("comId",companyId);
		String flag = "0";
		FolderVO detailFld = ezWebFolderDAO_y.getFolderDetail(map);
		parentId = detailFld.getFolderUpper();
		String folderPath = detailFld.getFolderPath();
		map.put("userId", userId);
		map.put("deptId", deptId);
		map.put("parentId", parentId);
		map.put("folderPath", folderPath);
		map.put("folderType",folderType);
		map.put("searchExt", searchExt);
		map.put("searchFileName", searchFileName);
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		map.put("searchCreateName", searchCreateName);
		map.put("searchFileType", searchFileType);
		map.put("searchPageCount", searchPageCount);
		map.put("pStart", pStart);
		map.put("pEnd", pEnd);
		map.put("offset", offset);
		int fileTotalCnt = 0;
		int fldTotalCnt = 0;
		List<FileVO> filevo  = new ArrayList<FileVO>();
		if (searchExt != "" || searchStartDate != "" || searchEndDate != "" || searchCreateName != "" || searchFileName!="") {
			flag = "1";
		}
		try {
			map.put("flag", flag);
			if (flag.equals("1")) {
				fileTotalCnt = ezWebFolderDAO_y.searchFileToTalCount(map);
			}else {
				fileTotalCnt = ezWebFolderDAO_y.getFileTotalCount(map);
			}
			fldTotalCnt = ezWebFolderDAO_y.getFldTotalCount(map);
			
		} catch (Exception e) {
			if (fileTotalCnt < 0) {
				fileTotalCnt = 0;
			}
			if (fldTotalCnt < 0) {
				fldTotalCnt = 0;
			}
		}
		
		Map<String, Integer> cnt = new HashMap<String, Integer>();
		int totalCount = 0;
		totalCount = fileTotalCnt + fldTotalCnt;
		cnt.put("fileTotalCnt", fileTotalCnt);
		cnt.put("fldTotalCnt", fldTotalCnt);
		cnt.put("totalCount", totalCount);
		return cnt;
	}
	
	@Override
	public List<Map<String, Object>> getFolderList(String admin, String userId,String deptId, String comId ,
			String folderId, String folderType, int tenantId , String primary) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userId", userId);
		map.put("deptId", deptId);
		map.put("comId", comId);
		map.put("folderId", folderId);
		map.put("folderType", folderType);
		map.put("tenantId", tenantId);
		map.put("primary", primary);
		
		LOGGER.debug("userId : " + userId + " deptId : " + deptId + " comId" + comId + " folderId : "  + folderId + 
				" folderType : " + folderType + " tenantId :  " + tenantId + " primary : " + primary
				);
		List<Map<String, Object>> folderList = new ArrayList< Map<String,Object>>();

		if ( folderType.equals("C")) {
			folderList = ezWebFolderDAO_y.getFolderList(map);
		}else if ( folderType.equals("D")) {
			folderList = ezWebFolderDAO_y.getDeptFolder(map);
		}else if ( folderType.equals("U")) {
			folderList = ezWebFolderDAO_y.getFolderListUser(map);
		}else if ( folderType.equals("")) {
			folderList = ezWebFolderDAO_y.getFolderListAll(map);
		}
		
		LOGGER.debug("folderList.Size : " + folderList.size());

//		folderList = new ArrayList<Map<String,Object>>(new HashSet<Map<String,Object>>(folderList));
		JSONObject state  = new JSONObject();
		state.put("selected", "true");
		
		folderList.get(0).put("state",state);
		return folderList;
	}

	@Override
	public FolderVO getFolderDetail(String folderUppId,  String userId,	int tenantId, String comId) throws Exception {
		FolderVO detailFolder  = new FolderVO() ;
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderUppId);
		map.put("tenantId", tenantId);
		map.put("comId", comId);
		map.put("userId", userId);
		detailFolder = ezWebFolderDAO_y.getFolderDetail(map);
		
		return detailFolder;
	}


	@Override					
	public String insertFolder(int tenantId, String comId, String deptId, String userId,String folderType, String newFolderName1,
			String newFolderName2, FolderVO uppFolder , String timeUTC) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		LoginVO loginvo =  getUserInfo(tenantId,comId,userId);
		LOGGER.debug("insertFolder start");

		map.put("tenantId", 	 tenantId);
		if (uppFolder != null){
			map.put("folderUppId",	 uppFolder.getFolderId());
			int folderStep = ezWebFolderDAO_y.getFolderStep(map);
			
			map.put("folderType",	 uppFolder.getFolderType());
			map.put("folderStep",	 folderStep );
			map.put("folderLevel",	 uppFolder.getFolderLevel()+1);
			map.put("folderPath", 	 uppFolder.getFolderPath());
			
		// uppFolder가 없으면 최상위 폴더를 만드는거 
		} else if (uppFolder == null ) {
			map.put("folderUppId", "root");
			map.put("folderType", folderType);
			map.put("folderStep", 0);
			map.put("folderLevel", 0 );
			map.put("folderPath", "|");
		}
		map.put("folderName1", 	 newFolderName1);
		map.put("folderName2", 	 newFolderName2);
		map.put("createName1",	 loginvo.getDisplayName1());
		map.put("userId", 		 userId);
		map.put("comId",		 comId);
		map.put("timeUTC",		 timeUTC);
		
		// displayName2가 비어 있는 사람은 displayName을 넣는다.
		if ( loginvo.getDisplayName2().equals("")) {
			map.put("createName2", loginvo.getDisplayName1());
		} else {
			map.put("createName2", loginvo.getDisplayName2() );
		}
//		// folderType에 따라서 ownerId 다르게 주어짐 c:company , D:depertment , U:user
		if (folderType.equals("C")) {
			map.put("ownerId", comId);
		} else if (folderType.equals("D")) {
			map.put("ownerId",deptId);
		} else if (folderType.equals("U")) {
			map.put("ownerId",userId);
		}
		LOGGER.debug("folderType is " + folderType );

		String result = ezWebFolderDAO_y.insertFolder(map);
		LOGGER.debug("insert folderId is " + result);

		if ( result.equals(null)) {
			result = "fail";
		} else {
			result = "ok";
		}
		LOGGER.debug("insertFolder ended");
		return result;
	}

	// 부서장인지 확인하고 dept가져오는 메서드
	@Override
	public List<Map<String, Object>> getDeptFolder(int tenantId, String userId,
			String deptId, String comId,String folderType) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("folderType", folderType);		
		map.put("tenantId", tenantId);		
		map.put("userId", userId);		
		map.put("deptId", deptId);		
		map.put("comId", comId);		
		List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
		result = ezWebFolderDAO_y.getDeptFolder(map);
		return result;
	}

	// 겸직 리스트 가져오는 메서드 
	@Override
	public List<String> getAddJobList(int tenantId, String userId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);		
		map.put("userId", userId);		
		
		return ezWebFolderDAO_y.getAddJobList(map);
	}
	
	// 부서장인지 확인하고 dept가져오는 메서드
	@Override
	public List<Map<String, Object>> getDeptHeader(int tenantId, String userId,
			String deptId, String comId) throws Exception {
		return null;
	}

	// 첫 로그인 후 폴더가 존재하는지 판단하는 메서드 
	@Override
	public int existFolderChk(String userId, String deptId, String comId,
			String folderType, int tenantId, String primary) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);		
		map.put("userId", userId);		
		map.put("deptId", deptId);		
		map.put("comId", comId);		
		map.put("folderType", folderType);		
		map.put("primary", primary);		
		
		//해당 폴더가 있으면 flag=1, 없으면 flag=0을 반환
		int  result = ezWebFolderDAO_y.existFolderChk(map);
		return result;
	}

	// 부서폴더가 존재하는지 판단하는 메서드 
	@Override
	public String existFolderChk_D(String userId, String deptId, String comId, String folderType,
			int tenantId, String timeUTC, String primary)  throws Exception{
		
		// 부서폴더 폴더 존재하는지 판단
		// 부서폴더 존재하는지 판단 위해서는 부서폴더에 필요한 자기관련된 부서들을 다 찾을 수 있는 쿼리를 돌려서 다 없으면 다 만들고 다 있은면 안만든다 
		
		// 일단 겸직하는거 가져와서 
		LoginVO loginvo =  getUserInfo(tenantId,comId,userId);
		List<String> addJob = new ArrayList<String>();
		List<Map<String, Object>> subDept = new ArrayList< Map<String,Object>>();
		List<Map<String, Object>> allDeptheader = new ArrayList< Map<String,Object>>();
		FolderVO vo = null;
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("deptId", deptId);
		map.put("comId", comId);
		map.put("folderType", folderType);
		map.put("tenantId", tenantId);
		map.put("timeUTC", timeUTC);
		map.put("primary", primary);
		LOGGER.debug("timeUTC : " + timeUTC + "existFolderChk_d  . primary : " + primary);
		
		Map<String, Object> deptInfo = ezWebFolderDAO_y.getdeptInfo(map);
		// 부서장인지 판단  부서장
		String header = "";
		if( (String) deptInfo.get("EXTENSIONATTRIBUTE9") == null ) {
			header = "";
		}else {
			header = (String) deptInfo.get("EXTENSIONATTRIBUTE9");
		}
		if (header.equals(userId)) {
			
			subDept = ezWebFolderDAO_y.getDeptSub(map);
			
			for ( int j = 0; j < subDept.size(); j++ ) {
				String subDeptCn = (String) subDept.get(j).get("cn");
				map.put("deptId", subDeptCn);
				deptInfo = ezWebFolderDAO_y.getdeptInfo(map);
				map.put("folderUppId", "root");
				map.put("folderType", folderType);
				map.put("folderStep", 0);
				map.put("folderLevel", 0 );
				map.put("folderPath", "|");
				map.put("folderName1", deptInfo.get("displayname").toString());
				map.put("folderName2", deptInfo.get("displayname2").toString());
				map.put("createName1",	 loginvo.getDisplayName1());
				map.put("userId", 		 userId);
				map.put("comId",		 comId);
				
				// displayName2가 비어 있는 사람은 displayName을 넣는다.
				if ( loginvo.getDisplayName2().equals("")) {
					map.put("createName2", loginvo.getDisplayName1());
				} else {
					map.put("createName2", loginvo.getDisplayName2() );
				}
				
				String insFldId = "";
				insFldId = ezWebFolderDAO_y.deptInsertTest(map);
				
			}
			
		// 부서장이 아님	
		} else {
				
				map.put("deptId", deptId);
				map.put("folderUppId", "root");
				map.put("folderType", folderType);
				map.put("folderStep", 0);
				map.put("folderLevel", 0 );
				map.put("folderPath", "|");
				map.put("folderName1", deptInfo.get("displayname").toString());
				map.put("folderName2", deptInfo.get("displayname2").toString());
				map.put("createName1",	 loginvo.getDisplayName1());
				map.put("userId", 		 userId);
				map.put("comId",		 comId);
				
				// displayName2가 비어 있는 사람은 displayName을 넣는다.
				if ( loginvo.getDisplayName2().equals("")) {
					map.put("createName2", loginvo.getDisplayName1());
				} else {
					map.put("createName2", loginvo.getDisplayName2() );
				}
				
				String insFldId = "";
				insFldId = ezWebFolderDAO_y.deptInsertTest(map);
				
				
			}
		
		
		addJob = ezWebFolderDAO_y.getAddJobList(map);
		
		Map<String, Object> insertMap = new HashMap<String, Object>();
		String searchAddJob = "";
		
		// addjob 부서 하위의 모든 부서를 가져오는것 
		for (int i = 0; i<addJob.size(); i++) {
			String cn = addJob.get(i);
			map.put("deptId", cn);
			allDeptheader = ezWebFolderDAO_y.getDeptSub(map);
			String deptHeader = (String) allDeptheader.get(0).get("EXTENSIONATTRIBUTE9");
			// 겸직부서의 이놈이 부서장인지를 판단하는 것 
			// |이놈| 이놈 아님 | 빈놈
			
			// 부서장이 아니라는 의미 
			if (deptHeader== null) {
				deptHeader = "";
			} 
			
			// 현재 addJobList의 부서의 부서장이 EXTENSIONATTRIBUTE9에 본인 아이디가 들어있으면 본인은 부서장 
			if ( deptHeader == userId ) {
				// 겸직 하위 부서 부서명 
				subDept = ezWebFolderDAO_y.getDeptSub(map);
				
				for ( int j = 0; j < subDept.size(); j++ ) {
					String subDeptCn = (String) subDept.get(j).get("cn");
					deptInfo = ezWebFolderDAO_y.getdeptInfo(map);
					map.put("deptId", subDeptCn);
					map.put("folderUppId", "root");
					map.put("folderType", folderType);
					map.put("folderStep", 0);
					map.put("folderLevel", 0 );
					map.put("folderPath", "|");
					map.put("folderName1", deptInfo.get("displayname").toString());
					map.put("folderName2", deptInfo.get("displayname2").toString());
					map.put("createName1",	 loginvo.getDisplayName1());
					map.put("userId", 		 userId);
					map.put("comId",		 comId);
					
					// displayName2가 비어 있는 사람은 displayName을 넣는다.
					if ( loginvo.getDisplayName2().equals("")) {
						map.put("createName2", loginvo.getDisplayName1());
					} else {
						map.put("createName2", loginvo.getDisplayName2() );
					}
					
					String insFldId = "";
					insFldId = ezWebFolderDAO_y.deptInsertTest(map);
				}
				
			} else {
				deptInfo = ezWebFolderDAO_y.getdeptInfo(map);
				map.put("folderUppId", "root");
				map.put("folderType", folderType);
				map.put("folderStep", 0);
				map.put("folderLevel", 0 );
				map.put("folderPath", "|");
				map.put("folderName1", deptInfo.get("displayname").toString());
				map.put("folderName2", deptInfo.get("displayname2").toString());
				map.put("createName1",	 loginvo.getDisplayName1());
				map.put("userId", 		 userId);
				map.put("comId",		 comId);
				
				// displayName2가 비어 있는 사람은 displayName을 넣는다.
				if ( loginvo.getDisplayName2().equals("")) {
					map.put("createName2", loginvo.getDisplayName1());
				} else {
					map.put("createName2", loginvo.getDisplayName2() );
				}
				
				String insFldId = "";
				insFldId = ezWebFolderDAO_y.deptInsertTest(map);
				
			}
			
		}
		
		return "ok";
	}
	
	// 폴더 명 업데이트

	@Override
	public void updateFolder(String folderId, int tenantId, String userId, String comId, String newFolderName1, String newFolderName2, String offset) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("comId", comId);
		map.put("newFolderName1", newFolderName1);
		map.put("newFolderName2", newFolderName2);
		ezWebFolderDAO_y.updateFolder(map);
	}
	// 폴더 delete
	
	@Override
	public void deleteSubFldAFile(String folderId, int tenantId, String comId , String userId, String timeUTF) {
		
		Map<String, Object> map = new HashMap<String, Object>();
 		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("comId", comId);
		map.put("userId", userId);
		map.put("timeUTF", timeUTF);
		int result = 0;
		LOGGER.debug("folderId : "+folderId+"comId : "+comId+ "userId"+userId+"deleteSubFldAFile  Method");
		result = checkCreater(folderId, tenantId, comId, userId);
		// result 가 1이 아니면 creater가 자신이 아닌 폴더가 있다는 말 
		if (result == 1) {
			// result 1이면 creater가 모두 자신이라는 의미 
			ezWebFolderDAO_y.deleteFolder(map);
			ezWebFolderDAO_y.deleteFile(map);
			LOGGER.debug("deleteSubFldAFile is success");
		}else{
			LOGGER.debug("deleteSubFldAFile is fail");
		}
	}

	@Override
	public int checkCreater(String folderId, int tenantId,String comId, String userId) {
		
		// 자기 하위에 있는 폴더, 파일들이 모두 본인이 creater인지 확인  
		
		Map<String, Object> map = new HashMap<String, Object>();
		int result = 0;
		int resultFld = 0;
		int resultFile = 0;
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("comId", comId);
		map.put("userId", userId);
		LOGGER.debug("folderId : "+folderId+"comId : "+comId+ "userId"+userId+"deleteSubFldAFile  Method");
		resultFld = ezWebFolderDAO_y.checkSubCreater(map);
		LOGGER.debug("resultFld : "+resultFld);
		resultFile = ezWebFolderDAO_y.checkFileCreater(map);
		LOGGER.debug("resultFile : "+resultFile);
		// 1이 리턴되면 모두 다 내가 만든 파일 
		if (resultFile == 1 && resultFld == 1) {
			result = 1;
		}else if (resultFile == 0 && resultFld == 1) {
			result = 1;
		} else {
			result =0;
		}
		return result;
	}

	@Override
	public int getUsrListCount(int tenantId, String userId) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		
		int listCount = ezWebFolderDAO_y.getUsrListCnt(map);
		
		return listCount;
	}

	@Override
	public void insertEnv(String userId, int tenantId, int listCount) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("listCount", listCount);
		ezWebFolderDAO_y.insertEnv(map);
	}
	
}
