package egovframework.ezMobile.ezWebfolder.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import egovframework.ezEKP.ezWebFolder.vo.FolderTreeVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezWebfolder.service.MWebfolderService;
import egovframework.ezMobile.ezWebfolder.vo.MWebfolderFetchInfo;
import egovframework.let.utl.rest.Result;

@RestController
public class MWebfolderGWController {

	private static final Logger logger = LoggerFactory.getLogger(MWebfolderGWController.class);

	@Autowired
	private MOptionService mOptionService;

	@Autowired
	private MWebfolderService mWebfolderService;

	/**
	 * 파일 목록 조회<br>
	 * 
	 * @param pageType
	 *            종류: company, department, user, shared, sharing, favorite<br>
	 *            다른 값이 들어올 경우 company를 기본값으로 한다.
	 * @param folderId
	 *            접근하려는 폴더 아이디를 넣는다. null이 들어올 경우에 기본 목록을 보여준다.
	 */
	@RequestMapping(value = "/mobile/ezwebfolder/users/{userId:.+}/files/{pageType:company|department|user|shared|sharing|favorite}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public Result getFileList(HttpServletRequest request,
			@PathVariable String userId, @PathVariable String pageType, @RequestParam(defaultValue = "") String folderId,
			@RequestParam int page, @RequestParam int size, @RequestParam int offset,
			@RequestParam(defaultValue = "") String search, @RequestParam(defaultValue = "") String filter, 
		    @RequestParam(required = false) String lang) {
		logger.debug("MOBILE G/W WEBFOLDER [GET /mobile/ezwebfolder/users/{userId}/files/{pageType}] started.");
		logger.debug("userId: {}, pageType: {}, folderId: {}", userId, pageType, folderId);

		Result result;

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO common = mOptionService.commonInfoWeb(serverName, userId);

			if (lang != null) common.setLang(lang);

			MWebfolderFetchInfo fetchInfo = new MWebfolderFetchInfo();
			fetchInfo.setServerName(serverName);
			fetchInfo.setUser(common);
			fetchInfo.setPage(page);
			fetchInfo.setSize(size);
			fetchInfo.setOffset(offset);
			fetchInfo.setSearch(search);
			fetchInfo.setFilter(filter);

			result = mWebfolderService.fetchFiles(fetchInfo, pageType, folderId);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = Result.failure();
		}

		logger.debug("MOBILE G/W WEBFOLDER [GET /mobile/ezwebfolder/users/{userId}/files/{pageType}] ended.");
		return result;
	}

	/**
	 * 폴더 트리 조회
	 */
	@RequestMapping(value = "/mobile/ezwebfolder/users/{userId:.+}/tree/{pageType:company|department|user|shared|sharing|favorite}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public Result getFolderTree(@PathVariable String userId, @PathVariable String pageType, @RequestParam(defaultValue = "") String folderId, HttpServletRequest request) {
		logger.debug("MOBILE G/W WEBFOLDER [GET /mobile/ezwebfolder/users/{userId}/tree/{pageType}] started.");
		logger.debug("userId: {}, pageType: {}, folderId: {}", userId, pageType, folderId);

		Result result;

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO user = mOptionService.commonInfoWeb(serverName, userId);
			List<FolderTreeVO> treeList = mWebfolderService.fetchTree(user, pageType, folderId);

			result = Result.success(treeList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = Result.failure();
		}

		logger.debug("MOBILE G/W WEBFOLDER [GET /mobile/ezwebfolder/users/{userId}/tree/{pageType}] ended.");
		return result;
	}

}
