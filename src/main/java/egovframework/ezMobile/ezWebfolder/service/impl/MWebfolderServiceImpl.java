package egovframework.ezMobile.ezWebfolder.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.vo.FavoriteVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderTreeVO;
import egovframework.ezEKP.ezWebFolder.vo.SearchVO;
import egovframework.ezEKP.ezWebFolder.vo.ShareVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezWebfolder.service.MWebfolderService;
import egovframework.ezMobile.ezWebfolder.vo.MWebfolderFetchInfo;
import egovframework.ezMobile.ezWebfolder.vo.MWebfolderResult;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.rest.Rest;
import egovframework.let.utl.rest.Rest.Module;
import egovframework.let.utl.rest.Result;

@Component
public class MWebfolderServiceImpl extends EgovAbstractServiceImpl implements MWebfolderService {

	private static Gson GSON = new Gson();

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private EgovMessageSource egovMessageSource;

	@Autowired
	private EzWebFolderService_y serviceY;

	@Autowired
	private EzWebFolderService_m serviceM;

	@Autowired
	private Rest rest;

	private final ServiceResultSupplier<List<ShareVO>> sharedListSupplier = (userId, deptId, companyId, primary, offset, startPoint, pageSize, searchInfo, tenantId) -> {
		return serviceM.getSharedList("N", userId, deptId, companyId, primary, offset, startPoint, pageSize, searchInfo, tenantId, "", "");
	};

	private final ServiceResultSupplier<Map<String, Long>> sharedCountSupplier = (userId, deptId, companyId, primary, offset, startPoint, pageSize, searchInfo, tenantId) -> {
		return serviceM.getSharedCount("N", userId, deptId, companyId, primary, offset, pageSize, searchInfo, tenantId);
	};

	private final ServiceResultSupplier<List<ShareVO>> sharingListSupplier = (userId, deptId, companyId, primary, offset, startPoint, pageSize, searchInfo, tenantId) -> {
		return serviceM.getSharingList("N", userId, primary, offset, startPoint, pageSize, searchInfo, tenantId, "", "");
	};

	private final ServiceResultSupplier<Map<String, Long>> sharingCountSupplier = (userId, deptId, companyId, primary, offset, startPoint, pageSize, searchInfo, tenantId) -> {
		return serviceM.getSharingCount("N", userId, primary, offset, pageSize, searchInfo, tenantId);
	};

	private final ServiceResultSupplier<List<FavoriteVO>> favoriteListSupplier = (userId, deptId, companyId, primary, offset, startPoint, pageSize, searchInfo, tenantId) -> {
		return serviceM.getFavorites(userId, primary, offset, tenantId, searchInfo, startPoint, pageSize, "", "");
	};

	private final ServiceResultSupplier<Map<String, Long>> favoriteCountSupplier = (userId, deptId, companyId, primary, offset, startPoint, pageSize, searchInfo, tenantId) -> {
		return serviceM.getFavoritesCount(userId, primary, offset, tenantId, pageSize, searchInfo);
	};

	private final Function<ShareVO, FileVO> shareVoMapper = share -> {
		FileVO file = new FileVO();
		file.setFileId(share.getFileId());
		file.setFileName(share.getFileName());
		file.setFileSize(share.getFileSize());
		file.setUpdateDate(share.getUpdateDate());
		file.setCreateName1(share.getCreateName());
		file.setFavouriteStatus(share.getFavouriteStatus());
		file.setFileTypeName(share.isFolder() ? "folder" : "file");
		file.setFileIconUrl(share.getFileIconUrl().replace("/images/", "/images/mobile/"));

		return file;
	};

	private final Function<FavoriteVO, FileVO> favoriteVoMapper = favorite -> {
		FileVO file = new FileVO();
		file.setFileId(favorite.getTargetId());
		file.setFileName(favorite.getTargetName());
		file.setFileSize(favorite.getTargetSize());
		file.setUpdateDate(favorite.getCreateDate());
		file.setCreateName1(favorite.getCreatorName());
		file.setFavouriteStatus(favorite.getFavoriteStatus());
		file.setFileTypeName(favorite.isFolder() ? "folder" : "file");
		file.setFileIconUrl(favorite.getTargetIconUrl().replace("/images/", "/images/mobile/"));

		return file;
	};

	@Override
	public Result fetchFiles(MWebfolderFetchInfo fetchInfo, String pageType, String folderId) throws Exception {
		if (StringUtils.isNotEmpty(folderId)) {
			return fetchInFolder(fetchInfo, folderId);
		}

		switch (pageType) {
		case "company":
			return fetchCompany(fetchInfo);
		case "department":
			return fetchDepartment(fetchInfo);
		case "user":
			return fetchUser(fetchInfo);
		case "shared":
			return fetchShared(fetchInfo);
		case "sharing":
			return fetchSharing(fetchInfo);
		case "favorite":
			return fetchFavorite(fetchInfo);
		default:
			return fetchCompany(fetchInfo);
		}
	}

	@Override
	public List<FolderTreeVO> fetchTree(MCommonVO user, String pageType, String folderId) throws Exception {
		switch (pageType) {
		case "company":
		case "department":
		case "user":
			// C, D, U
			String firstInitialType = String.valueOf(pageType.charAt(0)).toUpperCase();
			return serviceY.getFolderTree(user.getUserId(), user.getDeptId(), user.getCompanyId(), firstInitialType, user.getPrimary(), user.getTenantId(), "", false);
		case "shared":
			return createFakeTree("ezWebFolder.t214", user.getLang());
		case "sharing":
			return createFakeTree("ezWebFolder.t267", user.getLang());
		case "favorite":
			return createFakeTree("ezWebFolder.t216", user.getLang());
		}

		return Collections.emptyList();
	}

	private Result fetchInFolder(MWebfolderFetchInfo info, String folderId) throws Exception {
		Result listResult = rest.gateway(Module.WEBFOLDER, info.getServerName())
				.url("/rest/ezwebfolder/folders/{0}/file-list2", folderId)
				.queryParam("userId", info.getUser().getUserId())
				.queryParam("pStart", info.getOffset())
				.queryParam("currPage", info.getPage())
				.queryParam("listCount", info.getSize())
				.queryParam("searchFileName", info.getSearch())
				.queryParam("searchFileType", info.getFilter())
				.exchangeBody(Result.class);

		if (listResult.failed()) {
			return listResult;
		}

		JsonObject data = listResult.getDataAsJsonObject();
		JsonArray jsonFiles = data.get("fileList").getAsJsonArray();
		List<FileVO> files = new ArrayList<>(jsonFiles.size());

		for (JsonElement obj : jsonFiles) {
			FileVO file = GSON.fromJson(obj, FileVO.class);
			String updateDate = file.getUpdateDate();

			if (updateDate.length() == 21) {
				file.setUpdateDate(updateDate.substring(0, 19));
			}

			file.setFileIconUrl(file.getFileIconUrl().replace("/images/", "/images/mobile/"));

			/*int depth = Optional.ofNullable(fileJson.get("depth")).map(Object::toString).map(Integer::parseInt).orElse(0);
			
			if (depth > 1) {
				StringBuilder fileName = new StringBuilder();
			
				for (int i = 0; i < depth - 1; i++) {
					fileName.append(" ");
				}
			
				fileJson.put("fileName", fileName.append("↪ ").append(fileJson.get("fileName")).toString());
			}*/

			// fileJson.put("fileIconUrl", fileJson.get("fileIconUrl").toString().replace("/images/", "/images/mobile/"));
			// fileJson.put("updateDate", updateDate);
			files.add(file);
		}

		int totalPages = data.get("totalPages").getAsInt();
		int fileCnt = data.get("fileCnt").getAsInt();
		int fldCnt = data.get("fldCnt").getAsInt();

		String folderName = data.get("folderName").getAsString();
		String folderName2 = data.get("folderName2").getAsString();
		String folderUpp = data.get("folderUpp").getAsString();

		MWebfolderResult webfolderResult = new MWebfolderResult();
		webfolderResult.setFiles(files);
		webfolderResult.setFolderName(folderName);
		webfolderResult.setFolderName2(folderName2);
		webfolderResult.setFileCount(fileCnt);
		webfolderResult.setFolderCount(fldCnt);
		webfolderResult.setTotalPages(totalPages);
		webfolderResult.setParentFolderId(folderUpp);

		return Result.success(webfolderResult);
	}

	private Result fetchCompany(MWebfolderFetchInfo info) throws Exception {
		return fetchInFolder(info, getFirstFolderId(info.getUser(), "C"));
	}

	private Result fetchDepartment(MWebfolderFetchInfo info) throws Exception {
		return fetchInFolder(info, getFirstFolderId(info.getUser(), "D"));
	}

	private Result fetchUser(MWebfolderFetchInfo info) throws Exception {
		return fetchInFolder(info, getFirstFolderId(info.getUser(), "U"));
	}

	private Result fetchShared(MWebfolderFetchInfo info) throws Exception {
		return getSharesOrFavorites(info, "ezWebFolder.t214", sharedListSupplier, sharedCountSupplier, shareVoMapper);
	}

	private Result fetchSharing(MWebfolderFetchInfo info) throws Exception {
		return getSharesOrFavorites(info, "ezWebFolder.t267", sharingListSupplier, sharingCountSupplier, shareVoMapper);
	}

	private Result fetchFavorite(MWebfolderFetchInfo info) throws Exception {
		return getSharesOrFavorites(info, "ezWebFolder.t216", favoriteListSupplier, favoriteCountSupplier, favoriteVoMapper);
	}

	/**
	 * @param folderType
	 *            C, D, U
	 * @throws Exception
	 */
	private String getFirstFolderId(MCommonVO user, String folderType) throws Exception {
		return serviceY.getFolderTree(user.getUserId(), user.getDeptId(), user.getCompanyId(), folderType, user.getPrimary(), user.getTenantId(), "")
				.stream().findFirst().map(FolderTreeVO::getId).orElse("");
	}

	/** 공유받은목록, 공유한목록, 즐겨찾기 가져오는 로직이 똑같아서 공통으로 사용하기 위한 메소드 */
	private <T> Result getSharesOrFavorites(MWebfolderFetchInfo info, String folderNameMessageKey,
			ServiceResultSupplier<List<T>> listSupplier, ServiceResultSupplier<Map<String, Long>> countSupplier, Function<T, FileVO> voMapper) throws Exception {
		MCommonVO user = info.getUser();
		String userId = user.getUserId();
		String deptId = user.getDeptId();
		String companyId = user.getCompanyId();
		String primary = user.getPrimary();
		String offset = user.getOffSet();
		int tenantId = user.getTenantId();

		int page = info.getPage();
		int size = info.getSize();

		SearchVO searchInfo = new SearchVO();
		searchInfo.setSearchFileName(info.getSearch());
		searchInfo.setSearchFileType(info.getFilter());

		int startPoint = (page - 1) * size;

		List<FileVO> files = listSupplier.get(userId, deptId, companyId, primary, offset, startPoint, size, searchInfo, tenantId).stream()
				.map(voMapper::apply).collect(Collectors.toList());
		Map<String, Long> countInfo = countSupplier.get(userId, deptId, companyId, primary, offset, startPoint, size, searchInfo, tenantId);

		MWebfolderResult webfolderResult = new MWebfolderResult();
		webfolderResult.setRootFolder();
		webfolderResult.setFiles(files);
		webfolderResult.setFileCount(countInfo.get("fileCount").intValue());
		webfolderResult.setTotalPages(countInfo.get("totalPage").intValue());
		webfolderResult.setFolderCount(countInfo.get("folderCount").intValue());
		Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(user.getLang()));
		webfolderResult.setFolderName(egovMessageSource.getMessage(folderNameMessageKey,
				new Locale(commonUtil.getTwoLetterLangFromLangNum(user.getLang()))));

		return Result.success(webfolderResult);
	}

	private List<FolderTreeVO> createFakeTree(String nameKey, String lang) {
		FolderTreeVO folderTree = new FolderTreeVO();
		folderTree.setFolderLevel("1");
		folderTree.setFolderName1(egovMessageSource.getMessage(nameKey, new Locale(commonUtil.getTwoLetterLangFromLangNum(lang))));
		// 2024-12-09 김대현 folderName2에 값이 없어서 모바일 웹폴더 목록리스트에 null이 출력되는 현상 수정 foldername2는 영어로 나오게 수정함
		folderTree.setFolderName2(egovMessageSource.getMessage(nameKey, new Locale(commonUtil.getTwoLetterLangFromLangNum("2"))));

		return Collections.singletonList(folderTree);
	}

	private interface ServiceResultSupplier<T> {
		T get(String userId, String deptId, String compId, String primary, String offset,
				int startPoint, int pageSize, SearchVO searchInfo, int tenantId) throws Exception;
	}

}
