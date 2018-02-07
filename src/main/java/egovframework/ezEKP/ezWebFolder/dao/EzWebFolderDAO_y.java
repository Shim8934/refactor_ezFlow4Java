package egovframework.ezEKP.ezWebFolder.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezWebFolder.vo.FileVO;
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
}
