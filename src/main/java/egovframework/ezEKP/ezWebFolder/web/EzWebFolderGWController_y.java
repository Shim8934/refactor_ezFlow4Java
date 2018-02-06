package egovframework.ezEKP.ezWebFolder.web;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.let.utl.fcc.service.CommonUtil;


@RestController
public class EzWebFolderGWController_y {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzWebFolderGWController_y.class);
	
	@Autowired
	private EzWebFolderService_y service ;
	
	@Autowired
	private CommonUtil commonutil;
	
	
	// 전체 폴더 조회
	@RequestMapping ( value="/webfolder/users/{userId}/folder-list" , method=RequestMethod.GET , produces="application/json;charset=utf-8")
	public JSONObject folderList (@PathVariable String userId ,HttpServletRequest request) throws Exception{
		System.out.println(userId);
		JSONObject jsonObj = new JSONObject();
		
		jsonObj.put("id", userId);
		jsonObj.put("status", "ok");
		jsonObj.put("test_GW", "결과 ");
		return jsonObj;
	}
	
	// 폴더 하나를 선택했을때 세부 정보 조회
	@RequestMapping ( value="/webfolder/folders/{folderId}", method = RequestMethod.GET ,produces = "application/json;charset=utf-8" )
	public JSONObject folderListDetail (@PathVariable String folderId , HttpServletRequest request ) {
		JSONObject jsonObj = new JSONObject();
		
		return jsonObj;
		
	}
	
	// 폴더 생성 
	@RequestMapping ( value="/webfolder/folders" , method= RequestMethod.POST , produces = "application/json;charset=utf-8")
	public JSONObject folderInsert (@RequestBody JSONObject insertData, HttpServletRequest request ) {
		JSONObject jsonObj = new JSONObject();
		
		
		return jsonObj;
		
	}
	
	// 폴더 수정 
	@RequestMapping (value = "/webfolder/folders/{folderId}", method = RequestMethod.PUT , produces = "application/json;charset=utf-8")
	public JSONObject folderUpdate (@PathVariable String folderId, HttpServletRequest request) {
		JSONObject jsonObj = new JSONObject();
		
		return jsonObj;
	}
	
	// 폴더 이동 
	@RequestMapping (value="/webfolderfolders/{folderId}/folder-move", method = RequestMethod.PUT, produces = "application/json;charset=utf-8" )
	public JSONObject folderMove (@PathVariable String folderId, HttpServletRequest request ) {
		JSONObject jsonObj = new JSONObject();
		
		
		return jsonObj;
		
	}
	
	// 폴더 복사 
	@RequestMapping ( value = "/webfolder/folders/{folderId}/folder-copy" , method = RequestMethod.PUT , produces ="application/json;charset=utf-8")
	public JSONObject folderCopy (@PathVariable String folderId, HttpServletRequest request ) {
		JSONObject jsonObj = new JSONObject();
		
		
		return jsonObj;
	}
	
	// 폴더 삭제 
	@RequestMapping(value ="/webfolder/folders/{folderId}", method = RequestMethod.DELETE , produces = "application/json;charset=utf-8")
	public JSONObject folderDelete (@PathVariable String folderId , HttpServletRequest request) {
		JSONObject jsonObj = new JSONObject();
		
		return jsonObj;
	}
	
	// 파일리스트 조회 
	@RequestMapping(value="/webfolder/folders/{folderId}/file-list", method=RequestMethod.GET, produces ="application/json;charset=utf-8")
	public JSONObject fileList (@PathVariable String folderId, HttpServletRequest request) {
		JSONObject jsonObj = new JSONObject();
		int tenantId = Integer.parseInt(request.getParameter("tenantId"));
		
		String searchExt = request.getParameter("searchExt") != null ? request.getParameter("searchExt") : "" ;
		
		String searchFileName = request.getParameter("searchFileName") != null ? request.getParameter("searchFileName") : "" ;
		String searchStartDate = request.getParameter("searchStartDate") != null ? request.getParameter("searchStartDate") : "" ;
		String searchEndDate = request.getParameter("searchEndDate") != null ? request.getParameter("searchEndDate") : "" ;
		String searchCreateName = request.getParameter("searchCreateName") != null ? request.getParameter("searchCreateName") : "" ;
		String searchFileType = request.getParameter("searchFileType") != null ? request.getParameter("searchFileType") : "" ;
		String searchPageCount = request.getParameter("searchPageCount") != null ? request.getParameter("searchPageCount") : "" ;
		String searchListCount = request.getParameter("searchListCount") != null ? request.getParameter("searchListCount") : "" ;
		// loginVO 같은 쿠키는 request로 받아와야 한다 
		// test할 용으로 만드는거는 뷰에서 값을 같이 던져줘야 한다. 
		// 던져야 할 데이터 : tenantId, companyId
		
		List<FileVO> fileList = new ArrayList<FileVO>();
		
		try {
			fileList = service.getFileList(folderId,tenantId , request.getParameter("companyId"),
					searchExt, searchFileName, searchStartDate, searchEndDate, searchCreateName, searchFileType,
					searchPageCount, searchListCount);
			
			jsonObj.put("fileList", fileList);
			jsonObj.put("status", "ok");
		} catch (Exception e) {			
			jsonObj.put("status", "error");
			jsonObj.put("code", 1);
		}

		
		return jsonObj;
	}
	
}
