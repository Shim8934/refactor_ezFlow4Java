package egovframework.ezEKP.ezWebFolder.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderAdminDAO;
import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO;
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
	
//	@Resource(name = "ezWebFolderAdminDAO")
//	private EzWebFolderAdminDAO ezWebFolderAdminDAO;
	
//	@Resource(name = "ezWebFolderAdminServiceImpl")
//	private EzWebFolderAdminServiceImpl ezWebFolderAdminServiceImpl;
	
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
			String comId, String searchExt, String searchFileName,
			String searchStartDate, String searchEndDate,
			String searchCreateName, String searchFileType,
			String searchPageCount, String searchListCount, int pStart , int pEnd) throws Exception {
		
		String parentId = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId",folderId);
		map.put("tenantId",tenantId);
		parentId = ezWebFolderDAO_y.getparentId (map);
		
		map.put("deptId", deptId);
		map.put("userId", userId);
		map.put("parentId", parentId);
		map.put("folderType",folderType);
		map.put("comId",comId);
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
		
		List<FileVO> filevo = (List<FileVO>) ezWebFolderDAO_y.getFileList(map);
		return filevo;
	}
	
	// fileTotalCount
	public int getFileToTalCount (String folderId,String folderType,String userId,String deptId, int tenantId,
			String companyId, String searchExt, String searchFileName,
			String searchStartDate, String searchEndDate,
			String searchCreateName, String searchFileType,
			String searchPageCount, String searchListCount, int pStart , int pEnd) throws Exception {
		
		String parentId = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId",folderId);
		map.put("tenantId",tenantId);
		parentId = ezWebFolderDAO_y.getparentId (map);
		
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
		int totalCnt = ezWebFolderDAO_y.getFileTotalCount(map);
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
		
		
		List<Map<String, Object>> folderList = new ArrayList< Map<String,Object>>();
		List<Map<String, Object>> deptFolder = new ArrayList< Map<String,Object>>();
		List<Map<String, Object>> deptSub = new ArrayList< Map<String,Object>>();
		List<Map<String, Object>> addJob = new ArrayList< Map<String,Object>>();
		
		
		
		if ( folderType.equals("C")) {
			if (admin.equals("ad")) {
				folderList = ezWebFolderDAO_y.getFolderListAd(map);
			} else {
				folderList = ezWebFolderDAO_y.getFolderList(map);
			}
		}else if ( folderType.equals("D")) {
			// 겸직인지 아닌지 판단하는 메서드 
/*			addJob = ezWebFolderDAO_y.getAddJobList(map);

			// size == 0이면 겸직 하지 않는다 
			if (addJob.size() == 0) {
				
				deptFolder = getDeptFolder(tenantId, userId, deptId, comId,folderType);
				folderList.addAll(deptFolder);
				
			} else {
				for ( int i = 0; i<addJob.size(); i++ ) {
					deptId = addJob.get(i).get("cn").toString();
					String deptHead = (String) addJob.get(i).get("EXTENSIONATTRIBUTE9");
					if (deptHead == null) {
						deptHead = "";
					}
//					deptHead = addJob.get(i).get("EXTENSIONATTRIBUTE9").toString();
					map.put("deptId", deptId);
					// 이건 부서장
					if ( deptHead.equals(userId)) { 
						// 본인 부서랑 상대 하위부서 추가 하는 메서드 
						deptFolder = ezWebFolderDAO_y.getFolderListDept(map);
						
					} else { // 부서장이 아니다 
						deptFolder = ezWebFolderDAO_y.getDeptFolder(map);
					}
					folderList.addAll(deptFolder);
					// 부서장인지 판단하고 부서장이면 하위폴더id를 가져오고 부서장이 아니면 본인의 폴더 id를 가져온다 
					
					
				}
			}
			*/
			
			folderList = ezWebFolderDAO_y.getDeptFolder(map);
		}else if ( folderType.equals("U")) {
			folderList = ezWebFolderDAO_y.getFolderListUser(map);
		}else if ( folderType.equals("")) {
			folderList = ezWebFolderDAO_y.getFolderListAll(map);
		}
		
		System.out.println(folderList.size());
		
		
		folderList = new ArrayList<Map<String,Object>>(new HashSet<Map<String,Object>>(folderList));
		
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
		uppFolder = ezWebFolderDAO_y.getFolderDetail(map);
		
		return uppFolder;
	}


	@Override					
	public String insertFolder(int tenantId, String comId, String deptId, String userId,String folderType, String newFolderName1,
			String newFolderName2, FolderVO uppFolder) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		LoginVO loginvo =  getUserInfo(tenantId,comId,userId);
		System.out.println("여기는 insertFolder_serviceImpl");

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
		
		// displayName2가 비어 있는 사람은 displayName을 넣는다.
		if ( loginvo.getDisplayName2().equals("")) {
			map.put("createName2", loginvo.getDisplayName1());
		} else {
			map.put("createName2", loginvo.getDisplayName2() );
		}
//		System.out.println("folderType 은 " + uppFolder.getFolderType());
//		// folderType에 따라서 ownerId 다르게 주어짐 c:company , D:depertment , U:user
		if (folderType.equals("C")) {
			System.out.println("여기는 C");
			map.put("ownerId", 	 comId);
		} else if (folderType.equals("D")) {
			System.out.println("여기는 D");
			map.put("ownerId",deptId);
		} else if (folderType.equals("U")) {
			System.out.println("여기는 U");
			map.put("ownerId",userId);
		}
//		map.put("ownerId", fol);
		System.out.println("결론적으로 ownerId는 " + map.get("ownerId"));
		System.out.println("결론적으로 loginVo.getDeptId는 " +loginvo.getDeptID());
		
		
		System.out.println("dao가기 바로 직전");
		String result = ezWebFolderDAO_y.insertFolder(map);
		System.out.println("여기는 insertFolder_serviceImpl_ result후 result");
		System.out.println(result + ""+ "값이 돌아왔습니다.");

		if ( result.equals(null)) {
			result = "fail";
		} else {
			result = "ok";
		}
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
	public List<Map<String, Object>> getAddJobList(int tenantId, String userId,
			String deptId, String comId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId", tenantId);		
		map.put("userId", userId);		
		map.put("deptId", deptId);		
		map.put("comId", comId);		
		List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
		result = ezWebFolderDAO_y.getAddJobList(map);
		return result;
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
			String folderType, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);		
		map.put("userId", userId);		
		map.put("deptId", deptId);		
		map.put("comId", comId);		
		map.put("folderType", folderType);		
		
		//해당 폴더가 있으면 flag=1, 없으면 flag=0을 반환
		int  result = ezWebFolderDAO_y.existFolderChk(map);
//		boolean result2 = true;
//		
//		if (result == 1) {
//			result2 = true;
//			LOGGER.debug("folder가 존재합니다. 생성하지 않아도 됩니다.");
//		} else {
//			result2 = false; 
//			LOGGER.debug("folder가 존재하지 않습니다. 생성해야 합니다.");
//		}
		return result;
	}

	// 부서폴더가 존재하는지 판단하는 메서드 
	@Override
	public String existFolderChk_D(String userId, String deptId, String comId, String folderType, int tenantId)  throws Exception{
		
		// 부서폴더 폴더 존재하는지 판단
		// 부서폴더 존재하는지 판단 위해서는 부서폴더에 필요한 자기관련된 부서들을 다 찾을 수 있는 쿼리를 돌려서 다 없으면 다 만들고 다 있은면 안만든다 
		
		// 일단 겸직하는거 가져와서 
		List<Map<String, Object>> addJob = new ArrayList< Map<String,Object>>();
		List<Map<String, Object>> subDept = new ArrayList< Map<String,Object>>();
		List<Map<String, Object>> allDeptheader = new ArrayList< Map<String,Object>>();
		FolderVO vo = null;
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("deptId", deptId);
		map.put("comId", comId);
		map.put("folderType", folderType);
		map.put("tenantId", tenantId);
		addJob = ezWebFolderDAO_y.getAddJobList(map);
		
		Map<String, Object> insertMap = new HashMap<String, Object>();
		String searchAddJob = "";
		
		// addjob 부서 하위의 모든 부서를 가져오는것 
		// 겸직 부서가 있다. 
		if ( addJob.size() != 0) {
			for (int i = 0; i<addJob.size(); i++) {
				String cn = (String) addJob.get(i).get("cn");							// 겸직 부서명
				map.put("deptId", cn);
				allDeptheader = ezWebFolderDAO_y.getDeptSub(map);
				String deptHeader = (String) allDeptheader.get(0).get("EXTENSIONATTRIBUTE9");
				// 겸직부서의 이놈이 부서장인지를 판단하는 것 
				// |이놈| 이놈 아님 | 빈놈
				map.put("deptId", cn);
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
						map.put("deptId", subDeptCn);
						int existFolder = ezWebFolderDAO_y.existFolderChk(map);
						if (existFolder != 0) {// 만들어져 있다.
							// 만들어져 있으면 통과~~~~~
							
						}else {// 만들어야한다.
							// 폴더명 1,2를 만들어야 한다.
							Map<String, Object> deptInfo = ezWebFolderDAO_y.getdeptInfo(map);
							String result = "";
							result = insertFolder(tenantId,  deptInfo.get("EXTENSIONATTRIBUTE1").toString(),deptInfo.get("cn").toString(), userId, folderType, 
									deptInfo.get("displayname").toString(), deptInfo.get("displayname2").toString(), vo);
							if (result.equals("0") || result.equals("")){
								LOGGER.debug("insert 잘못됨");
							}
							
							
						}
					}
					
					// exitstFolder가 null이면 만들어져 있다는 의미 
//					int exitFolder = ezWebFolderDAO_y.existFolderChk(map); 
					// 폴더가 존재하지 않음 
//					searchAddJob += ","+addJob.get(i).get("cn");
//					if( i == addJob.size()-1 ) {
//						searchAddJob +="";
//					}else {
//						searchAddJob += "|";
//					}
				} else {
					// 부서장이 아님  
					// 그 부서만 출력 하면 됨
					int existFolder = ezWebFolderDAO_y.existFolderChk(map);
					if (existFolder != 0) {// 만들어져 있다.
						// 만들어져 있으면 통과~~~~~
						
					}else {// 만들어야한다.
						// 폴더명 1,2를 만들어야 한다.
						Map<String, Object> deptInfo = ezWebFolderDAO_y.getdeptInfo(map);
						String result = "";
						result = insertFolder(tenantId,  deptInfo.get("EXTENSIONATTRIBUTE1").toString(),deptInfo.get("cn").toString(), userId, folderType, 
								deptInfo.get("displayname").toString(), deptInfo.get("displayname2").toString(), vo);
						if (result.equals("0") || result.equals("")){
							LOGGER.debug("insert 잘못됨");
							return "false";
						}
					}
					
				}
				
			}
			
		} else {// 겸직 부서가 없다 . 그럼 내가 부서장인지 아닌지 확인해서 부서장이면 하위도 다 만들고 아니면 내꺼만 만들고 
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
					int existFolder = ezWebFolderDAO_y.existFolderChk(map);
					if (existFolder != 0) {// 만들어져 있다.
						// 만들어져 있으면 통과~~~~~
						
					}else {// 만들어야한다.
						// 폴더명 1,2를 만들어야 한다.
						deptInfo = ezWebFolderDAO_y.getdeptInfo(map);
						String result = "";
						result = insertFolder(tenantId, deptInfo.get("EXTENSIONATTRIBUTE2").toString(), deptInfo.get("cn").toString(),
								userId, folderType, deptInfo.get("displayname").toString(), deptInfo.get("displayname2").toString(), vo);
						if (result.equals("0") || result.equals("")){
							LOGGER.debug("insert 잘못됨");
							return "false";
						}
					}
				}
				
			// 부서장이 아님	
			} else {
				// 부서장 아니고 존재하는지 확인
				int existFolder = ezWebFolderDAO_y.existFolderChk(map);
				if (existFolder != 0) {// 만들어져 있다.
					// 만들어져 있으면 통과~~~~~
					
				}else {// 만들어야한다.
					// 폴더명 1,2를 만들어야 한다.
					deptInfo = ezWebFolderDAO_y.getdeptInfo(map);
					String result = "";
					result = insertFolder(tenantId,  deptInfo.get("EXTENSIONATTRIBUTE2").toString(), deptInfo.get("cn").toString(), 
							userId, folderType, deptInfo.get("displayname").toString(), deptInfo.get("displayname2").toString(), vo);
					if (result.equals("0") || result.equals("")){
						LOGGER.debug("insert 잘못됨");
						return "false";
					}
				}
			}
		}
		
		return "ok";
	}
	
	// 폴더 명 업데이트

	@Override
	public void updateFolder(String folderId, int tenantId, String userId, String comId, String newFolderName1, String newFolderName2) {
		
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
	public void deleteSubFldAFile(String folderId, int tenantId, String comId , String userId) {
		
		Map<String, Object> map = new HashMap<String, Object>();
 		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("comId", comId);
		map.put("userId", userId);
		int result = 0;
		LOGGER.debug("folderId : "+folderId+"comId : "+comId+ "userId"+userId+"deleteSubFldAFile  Method");
		result = checkCreater(folderId, tenantId, comId, userId);
		// result 가 1이 아니면 creater가 자신이 아닌 폴더가 있다는 말 
		if (result == 1) {
			// result 1이면 creater가 모두 자신이라는 의미 
			ezWebFolderDAO_y.deleteFolder(map);
			ezWebFolderDAO_y.deleteFile(map);
			LOGGER.debug("result : " + result);
			System.out.println("성공");
		}else{
			System.out.println("실패");
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
	

	
	
	
	
}
