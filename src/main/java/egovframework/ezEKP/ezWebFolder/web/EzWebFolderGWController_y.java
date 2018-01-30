package egovframework.ezEKP.ezWebFolder.web;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class EzWebFolderGWController_y {

	Logger logger = LoggerFactory.getLogger(EzWebFolderAdminController.class);
	
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
	@RequestMapping ( value="/ezwebfolder/folders/{folderId}", method = RequestMethod.GET ,produces = "application/json;charset=utf-8" )
	public JSONObject folderListDetail (@PathVariable String folderId , HttpServletRequest request ) {
		JSONObject jsonObj = new JSONObject();
		
		return jsonObj;
		
	}
	
	// 폴더 생성 
	@RequestMapping ( value="/ezwebfolder/folders" , method= RequestMethod.POST , produces = "application/json;charset=utf-8")
	public JSONObject folderInsert (@RequestBody JSONObject insertData, HttpServletRequest request ) {
		JSONObject jsonObj = new JSONObject();
		
		
		return jsonObj;
		
	}
	
	// 폴더 수정 
	@RequestMapping (value = "/ezwebfolder/folders/{folderId}", method = RequestMethod.PUT , produces = "application/json;charset=utf-8")
	public JSONObject folderUpdate (@PathVariable String folderId, HttpServletRequest request) {
		JSONObject jsonObj = new JSONObject();
		
		return jsonObj;
	}
	
	// 폴더 이동 
	@RequestMapping (value="/ezwebfolderfolders/{folderId}/folder-move", method = RequestMethod.PUT, produces = "application/json;charset=utf-8" )
	public JSONObject folderMove (@PathVariable String folderId, HttpServletRequest request ) {
		JSONObject jsonObj = new JSONObject();
		
		
		return jsonObj;
		
	}
	
	// 폴더 복사 
	@RequestMapping ( value = "/ezwebfolder/folders/{folderId}/folder-copy" , method = RequestMethod.PUT , produces ="application/json;charset=utf-8")
	public JSONObject folderCopy (@PathVariable String folderId, HttpServletRequest request ) {
		JSONObject jsonObj = new JSONObject();
		
		
		return jsonObj;
	}
	
	// 폴더 삭제 
	@RequestMapping(value ="/ezwebfolder/folders/{folderId}", method = RequestMethod.DELETE , produces = "application/json;charset=utf-8")
	public JSONObject folderDelete (@PathVariable String folderId , HttpServletRequest request) {
		JSONObject jsonObj = new JSONObject();
		
		return jsonObj;
	}
	
	// 파일리스트 조회 
	@RequestMapping(value="/ezwebfolder/folders/{folderId}/file-list", method=RequestMethod.GET, produces ="application/json;charset=utf-8")
	public JSONObject fileList (@PathVariable String folderId, HttpServletRequest request) {
		JSONObject jsonObj = new JSONObject();
		
		return jsonObj;
	}
	
}
