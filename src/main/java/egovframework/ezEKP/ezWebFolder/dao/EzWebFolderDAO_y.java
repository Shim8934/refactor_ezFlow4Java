package egovframework.ezEKP.ezWebFolder.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzWebFolderDAO_y")
public class EzWebFolderDAO_y extends EgovAbstractDAO {
	// fileList 가져오는 메소드
	public List<FileVO> getFileList(Map<String, Object> map) {
		return  (List<FileVO>) list("EzWebFolderDAO_y.getFileList",map);
		
	}
	
	public int getFileTotalCount (Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_y.getFileToTalCount",map);
	}
	
	// jstree사용하기 위해서는 최상단이 #으로 출력되어야합니다. 
	// id, parentId, text를 가지고 오면 알아서 트리 만들어줍니다.
	public List<Map<String, Object>> getFolderList(Map<String, Object> map) {
		return   (List<Map<String, Object>>) list("EzWebFolderDAO_y.getFolderList",map);
	}
	public List<Map<String, Object>> getFolderListAd(Map<String, Object> map) {
		return   (List<Map<String, Object>>) list("EzWebFolderDAO_y.getFolderList_ad",map);
	}
	public List<Map<String, Object>> getFolderListUser(Map<String, Object> map) {
		return   (List<Map<String, Object>>) list("EzWebFolderDAO_y.getFolderList_U",map);
	}
	public List<Map<String, Object>> getFolderListDept(Map<String, Object> map) {
		return   (List<Map<String, Object>>) list("EzWebFolderDAO_y.getFolderList_D",map);
	}

	public String getparentId(Map<String, Object> map) {
		return (String) select ("EzWebFolderDAO_y.getParentId",map);
	}

	// 폴더 상세 정보 
	public FolderVO getFolderDetail(Map<String, Object> map) {
		return (FolderVO) select("EzWebFolderDAO_y.getFolderDetail",map);
	}

}
