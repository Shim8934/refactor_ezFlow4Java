package egovframework.ezEKP.ezApprovalG.service.impl;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletContext;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGKlibDAO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGKlibService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAttachInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGHistoryAttachVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGHistoryDocVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.KlibUtil;

/**
 * @see EzApprovalGKlibService
 */
@Service("EzApprovalGKlibService")
public final class EzApprovalGKlibServiceImpl implements EzApprovalGKlibService {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzApprovalGKlibServiceImpl.class);

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private KlibUtil klibUtil;

	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;

	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;

	@Resource(name = "EzApprovalGKlibDAO")
	private EzApprovalGKlibDAO ezApprovalGKlibDAO;

	/** fileroot 폴더 이전 까지의 절대 경로 */
	private String realPath;

	// 생성자에서 ServletContext 인스턴스를 AutoWired 하여 파라미터로 받은 후에, realPath 변수를 초기화 한다.
	@Autowired
	public EzApprovalGKlibServiceImpl(ServletContext servletContext) throws IOException {
		realPath = servletContext.getRealPath("");
		LOGGER.debug("realPath: {}", realPath);
	}

	@Override
	public void encryptCompleteApproveFiles(String docId, String companyId, int tenantId) {
		LOGGER.debug("encryptCompleteApproveFiles started.");
		LOGGER.debug("docId: {}, companyId: {}, tenantId: {}", docId, companyId, tenantId);

		// useApprovalKlibBackup 콘피그가 활성화 되어 있으면 백업
		try {
			if ("yes".equalsIgnoreCase(ezCommonService.getTenantConfig("useApprovalKlibBackup", tenantId))) {
				backupAllFiles(docId, companyId, tenantId);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			LOGGER.debug("Failed to backup files.");
		}

		try {
			Map<String, Object> parameterMap = new HashMap<>();

			parameterMap.put("docId", docId);
			parameterMap.put("companyId", companyId);
			parameterMap.put("tenantId", tenantId);

			// shallow copy
			encryptEndDocFile(new HashMap<>(parameterMap));
			encryptEndAttachFiles(new HashMap<>(parameterMap));
			encryptHistoryDocFiles(new HashMap<>(parameterMap));
			encryptHistoryAttachFiles(new HashMap<>(parameterMap));
		} catch (Exception ex) {
			ex.printStackTrace();
			LOGGER.debug("Failed to encrypt files.");
		}

		LOGGER.debug("encryptCompleteApproveFiles ended.");
	}

	// TODO 파일 I/O 작업이라 그런건지 백업 속도가 느림, 개선 사항
	private void backupAllFiles(String docId, String companyId, int tenantId) {
		LOGGER.debug("backupAllFiles started.");

		try {
			String docDirPath = ezApprovalGService.getDocDir(docId);
			String oldYear = ezApprovalGService.getDocHrefYear(docId, companyId, tenantId);
			LOGGER.debug("realPath: {}", realPath);

			// 전자결재업로드 폴더, ex)
			// ezFlow절대경로/fileroot/0/files/upload_approvalG/company 폴더
			Path uploadApprovalDir = Paths.get(realPath, commonUtil.separator, commonUtil.getUploadPath("upload_approvalG.ROOT", tenantId), companyId);
			// 절대경로 존재 여부 검증
			uploadApprovalDir.toRealPath();
			LOGGER.debug("uploadApprovalDir: {}", uploadApprovalDir);

			// 백업 폴더, ex) fileroot/0/files/upload_approvalG/company/klib_backup
			Path backupDir = uploadApprovalDir.resolve(BACKUP_DIR_NAME);
			LOGGER.debug("backupDir: {}", backupDir);

			/** 결재완료문서 폴더 */
			// 결재완료문서 폴더, ex) doc/2018/792
			Path relativeDocumentFile = Paths.get("doc", oldYear, docDirPath);
			// 결재완료문서 폴더 (절대경로)
			Path realDocumentFile = uploadApprovalDir.resolve(relativeDocumentFile);
			LOGGER.debug("realDocumentFile: {}", realDocumentFile);

			/** 결재문서 히스토리 폴더 */
			// 결재문서 히스토리 폴더, ex) doc/2018/history/792
			Path relativeDocumentHistoryDir = Paths.get("doc", oldYear, "history", docDirPath);
			// 결재문서 히스토리 폴더 (절대경로)
			Path realDocumentHistoryDir = uploadApprovalDir.resolve(relativeDocumentHistoryDir);

			/** 첨부파일 */
			// 첨부파일 폴더, ex) uploadFile/2018/792
			Path relativeAttachmentDir = Paths.get("uploadFile", oldYear, docDirPath);
			// 첨부파일 히스토리 폴더, ex) uploadFile/2018/history/792
			Path relativeAttachmentHistoryDir = Paths.get("uploadFile", oldYear, "history", docDirPath);
			// 첨부파일 폴더 (절대경로)
			Path realAttachmentDir = uploadApprovalDir.resolve(relativeAttachmentDir);
			// 첨부파일 히스토리 폴더 (절대경로)
			Path realAttachmentHistoryDir = uploadApprovalDir.resolve(relativeAttachmentHistoryDir);
			LOGGER.debug("realAttachmentDir: {}", realAttachmentDir);
			LOGGER.debug("realAttachmentHistoryDir: {}", realAttachmentHistoryDir);

			// 결재완료문서 백업
			FileUtils.copyDirectory(realDocumentFile.toFile(), backupDir.resolve(relativeDocumentFile).toFile());
			// 결재문서 히스토리 폴더 백업
			if (Files.exists(realDocumentHistoryDir)) {
				FileUtils.copyDirectory(realDocumentHistoryDir.toFile(), backupDir.resolve(relativeDocumentHistoryDir).toFile());
			}
			// 첨부파일 폴더 백업
			if (Files.exists(realAttachmentDir)) {
				FileUtils.copyDirectory(realAttachmentDir.toFile(), backupDir.resolve(relativeAttachmentDir).toFile());
			}
			// 첨부파일 히스토리 폴더 백업
			if (Files.exists(realAttachmentHistoryDir)) {
				FileUtils.copyDirectory(realAttachmentHistoryDir.toFile(), backupDir.resolve(relativeAttachmentHistoryDir).toFile());
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			LOGGER.debug("backupAllFiles error.");
		}

		LOGGER.debug("backupAllFiles ended.");
	}

	private void encryptEndDocFile(Map<String, Object> parameterMap) {
		LOGGER.debug("encryptEndDocFile started.");

		// 결재완료문서 경로
		String docHref = ezApprovalGKlibDAO.getEndDocHref(parameterMap);
		// 결재완료문서 파일
		Path docFile = Paths.get(realPath, docHref);

		LOGGER.debug("file: {}", docHref);

		// 암호화 성공시 TBL_ENDAPRDOCINFO 테이블의 HREF 컬럼 업데이트
		if (encryptForApprovalFile(docFile)) {
			parameterMap.put("href", docHref + "." + ENCRYPTED_FILE_EXT);
			ezApprovalGKlibDAO.updateEndDocHref(parameterMap);
		}

		LOGGER.debug("encryptEndDocFile ended.");
	}

	private void encryptEndAttachFiles(Map<String, Object> parameterMap) {
		LOGGER.debug("encryptEndAttachFiles started.");

		// 첨부파일 리스트
		List<ApprGAttachInfoVO> attachInfoList = ezApprovalGKlibDAO.getEndAttachInfoList(parameterMap);

		for (ApprGAttachInfoVO attachInfo : attachInfoList) {
			// 첨부파일 경로
			String attachHref = attachInfo.getAttachFileHref();
			Path attachFile = Paths.get(realPath, attachHref);

			LOGGER.debug("file: {}", attachHref);

			// 암호화 성공시 TBL_ENDATTACHINFO 테이블의 HREF 컬럼 업데이트
			if (encryptForApprovalFile(attachFile)) {
				parameterMap.put("attachFileSN", attachInfo.getAttachFileSN());
				parameterMap.put("href", attachHref + "." + ENCRYPTED_FILE_EXT);

				ezApprovalGKlibDAO.updateEndAttachInfoHref(parameterMap);
				/* 진행 중인 문서의 해당 첨부파일이 존재하면 .ezd 확장자를 붙여준다.
				 orgdocid를 현재 결재완료된 문서의 아이디를 쓰는 경우가 존재하기 때문이다.
				예를 들어 수신 문서 같은 경우에는 수신 정보를 원본 문서의 href를 복사해서 붙여넣기 때문에
				.ezd 확장자가 붙어있지 않아서 다운로드할 때 FileNotFound 오류가 난다. */
				ezApprovalGKlibDAO.updateAprAttachInfoHref(parameterMap);
			}
		}

		LOGGER.debug("encryptEndAttachFiles ended.");
	}

	private void encryptHistoryDocFiles(Map<String, Object> parameterMap) {
		LOGGER.debug("encryptHistoryDocFiles started.");

		// 문서 히스토리 리스트
		List<ApprGHistoryDocVO> historyDocList = ezApprovalGKlibDAO.getHistoryDocList(parameterMap);

		for (ApprGHistoryDocVO hisotryDoc : historyDocList) {
			// 문서 경로
			String historyDocUrl = hisotryDoc.getUrl();
			Path historyDocFile = Paths.get(realPath, historyDocUrl);

			LOGGER.debug("file: {}", historyDocUrl);

			// 암호화 성공시 TBL_HISTORYDOCINFO 테이블의 URL 컬럼 업데이트
			if (encryptForApprovalFile(historyDocFile)) {
				parameterMap.put("changeSN", hisotryDoc.getChangeSN());
				parameterMap.put("url", historyDocUrl + "." + ENCRYPTED_FILE_EXT);

				ezApprovalGKlibDAO.updateHistoryDocHref(parameterMap);
			}
		}

		LOGGER.debug("encryptHistoryDocFiles ended.");
	}

	private void encryptHistoryAttachFiles(Map<String, Object> parameterMap) {
		LOGGER.debug("encryptHistoryAttachFiles started.");

		// 첨부파일 히스토리 리스트
		List<ApprGHistoryAttachVO> historyAttachList = ezApprovalGKlibDAO.getHistoryAttachList(parameterMap);

		for (ApprGHistoryAttachVO hisotryAttach : historyAttachList) {
			// 첨부파일 경로
			String historyAttachHref = hisotryAttach.getAttachFileHref();
			Path historyAttachFile = Paths.get(realPath, historyAttachHref);

			LOGGER.debug("file: {}", historyAttachHref);

			// 암호화 성공시 TBL_HISTORYATTACHINFO 테이블의 HREF 컬럼 업데이트
			if (encryptForApprovalFile(historyAttachFile)) {
				parameterMap.put("attachFileSN", hisotryAttach.getAttachFileSN());
				parameterMap.put("modifySN", hisotryAttach.getModifySN());
				parameterMap.put("href", historyAttachHref + "." + ENCRYPTED_FILE_EXT);

				ezApprovalGKlibDAO.updateHistoryAttachHref(parameterMap);
			}
		}

		LOGGER.debug("encryptHistoryAttachFiles ended.");
	}

	/**
	 * 파일을 암호화하여 저장하는 API<br>
	 * <br>
	 * 암호화에 성공하면 .ezd 확장자를 붙여 저장하고 원본 파일은 삭제한다.
	 * 
	 * @param file
	 *            암호화 대상
	 * @return 성공 여부
	 */
	private boolean encryptForApprovalFile(Path file) {
		try {
			// 이미 암호화된 파일이라면 리턴
			if (file == null || file.toString().endsWith("." + ENCRYPTED_FILE_EXT)) {
				return false;
			}

			// 파일의 바이트를 읽음
			byte[] fileBytes = Files.readAllBytes(file);
			// 바이트 암호화
			byte[] encryptedBytes = klibUtil.encrypt(fileBytes);

			// .ezd 확장자로 저장될 경로
			String encryptedFileHref = file.toString() + "." + ENCRYPTED_FILE_EXT;
			Path encryptedFile = Paths.get(encryptedFileHref);

			// 암호화한 바이트를 .ezd 파일로 저장
			Files.write(encryptedFile, encryptedBytes);

			// 원본 파일 삭제
			Files.delete(file);

			return true;
		} catch (Exception ex) {
			ex.printStackTrace();
		} catch (UnsatisfiedLinkError linkErr) {
			LOGGER.error(linkErr.toString());
		}

		return false;
	}
}
