package egovframework.ezMobile.ezWebfolder.service;

import java.util.List;

import egovframework.ezEKP.ezWebFolder.vo.FolderTreeVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezWebfolder.vo.MWebfolderFetchInfo;
import egovframework.let.utl.rest.Result;

public interface MWebfolderService {

	Result fetchFiles(MWebfolderFetchInfo info, String pageType, String folderId) throws Exception;

	List<FolderTreeVO> fetchTree(MCommonVO user, String pageType, String folderId) throws Exception;
}
