package egovframework.ezEKP.ezApprovalG.service.impl;

import java.io.FileFilter;
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

	private static final Logger logger = LoggerFactory.getLogger(EzApprovalGKlibServiceImpl.class);

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
		logger.debug("realPath: {}", realPath);
	}

	@Override
	public void encryptCompleteApproveFiles(String docId, String companyId, int tenantId) {
		logger.debug("encryptCompleteApproveFiles started.");
		logger.debug("docId: {}, companyId: {}, tenantId: {}", docId, companyId, tenantId);

		// 백업 시도
		try {
			// useApprovalKlibBackup 콘피그가 활성화 되어 있으면 백업
			if ("yes".equalsIgnoreCase(ezCommonService.getTenantConfig("useApprovalKlibBackup", tenantId))) {
				backupAllFiles(docId, companyId, tenantId);
			}
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			logger.debug("Failed to backup files.");
		}

		// 암호화 시도
		try {
			// 암호화에 필요한 파라미터 맵 초기화
			Map<String, Object> parameterMap = new HashMap<>();

			parameterMap.put("docId", docId);
			parameterMap.put("companyId", companyId);
			parameterMap.put("tenantId", tenantId);

			// 파라미터 얕은 복사 (shallow copy)
			encryptEndDocFile(new HashMap<>(parameterMap));
			encryptEndAttachFiles(new HashMap<>(parameterMap));
			encryptHistoryDocFiles(new HashMap<>(parameterMap));
			encryptHistoryAttachFiles(new HashMap<>(parameterMap));
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			logger.debug("Failed to encrypt files.");
		}

		logger.debug("encryptCompleteApproveFiles ended.");
	}

	// TODO 파일 I/O 작업이라 그런건지 백업 속도가 느림, 개선 사항
	/**
	 * 암호화 관련 파일을 전부 백업 하는 메소드<br>
	 * <hr>
	 * <i>(아래 나오는 경로는 모두 예시입니다)</i><br>
	 * fileroot/0/files/upload_approvalG/company/klib_backup 폴더 안으로 전부 백업한다.<br>
	 * <br>
	 * <b>백업 대상</b>
	 * <ul>
	 * <li>결재완료문서 폴더, doc/2018/792/...</li>
	 * <li>결재문서 히스토리 폴더, doc/2018/history/792/...</li>
	 * <li>첨부파일 폴더, uploadFile/2018/792/...</li>
	 * <li>첨부파일 히스토리 폴더, uploadFile/2018/history/792/...</li>
	 * </ul>
	 * 
	 * @param docId
	 *            전자결재 문서 번호
	 * @param companyId
	 *            회사 아이디
	 * @param tenantId
	 *            테넌트 아이디
	 */
	private void backupAllFiles(String docId, String companyId, int tenantId) {
		logger.debug("backupAllFiles started.");

		try {
			String docDirPath = ezApprovalGService.getDocDir(docId);
			String oldYear = ezApprovalGService.getDocHrefYear(docId, companyId, tenantId);
			logger.debug("realPath: {}", realPath);

			// 전자결재업로드 폴더, ex)
			// ezFlow절대경로/fileroot/0/files/upload_approvalG/company 폴더
			Path uploadApprovalDir = Paths.get(realPath, commonUtil.separator, commonUtil.getUploadPath("upload_approvalG.ROOT", tenantId), companyId);
			// 절대경로 존재 여부 검증
			uploadApprovalDir.toRealPath();
			logger.debug("uploadApprovalDir: {}", uploadApprovalDir);

			// 백업 폴더, ex) fileroot/0/files/upload_approvalG/company/klib_backup
			Path backupDir = uploadApprovalDir.resolve(BACKUP_DIR_NAME);
			logger.debug("backupDir: {}", backupDir);

			/** 결재완료문서 폴더 */
			// 결재완료문서 폴더, ex) doc/2018/792/
			Path relativeDocumentFile = Paths.get("doc", oldYear, docDirPath);
			// 결재완료문서 폴더 (절대경로)
			Path realDocumentFile = uploadApprovalDir.resolve(relativeDocumentFile);
			logger.debug("realDocumentFile: {}", realDocumentFile);

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
			logger.debug("realAttachmentDir: {}", realAttachmentDir);
			logger.debug("realAttachmentHistoryDir: {}", realAttachmentHistoryDir);

			// .ezd인 파일들은 제외하고 백업
			FileFilter fileFilter = file -> !file.toString().endsWith("." + ENCRYPTED_FILE_EXT);

			// 결재완료문서 백업
			FileUtils.copyDirectory(realDocumentFile.toFile(),
					backupDir.resolve(relativeDocumentFile).toFile(), fileFilter);
			// 결재문서 히스토리 폴더 백업
			if (Files.exists(realDocumentHistoryDir)) {
				FileUtils.copyDirectory(realDocumentHistoryDir.toFile(),
						backupDir.resolve(relativeDocumentHistoryDir).toFile(), fileFilter);
			}
			// 첨부파일 폴더 백업
			if (Files.exists(realAttachmentDir)) {
				FileUtils.copyDirectory(realAttachmentDir.toFile(),
						backupDir.resolve(relativeAttachmentDir).toFile(), fileFilter);
			}
			// 첨부파일 히스토리 폴더 백업
			if (Files.exists(realAttachmentHistoryDir)) {
				FileUtils.copyDirectory(realAttachmentHistoryDir.toFile(),
						backupDir.resolve(relativeAttachmentHistoryDir).toFile(), fileFilter);
			}
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			logger.debug("backupAllFiles error.");
		}

		logger.debug("backupAllFiles ended.");
	}

	/**
	 * <b>결재완료문서를 암호화</b>하여 .ezd 확장자로 저장하고<br>
	 * TBL_ENDATTACHINFO 테이블에서 파일명을 업데이트한다.<br>
	 * <br>
	 * 암호화 실패시 아무 작업도 안 한다.
	 *
	 * @param parameterMap
	 *            문서번호(docId), 회사아이디(companyId), 테넌트아이디(tenantId)
	 */
	private void encryptEndDocFile(Map<String, Object> parameterMap) {
		logger.debug("encryptEndDocFile started.");

		// 결재완료문서 경로
		String docHref = ezApprovalGKlibDAO.getEndDocHref(parameterMap);
		// 결재완료문서 파일
		Path docFile = Paths.get(realPath, docHref);

		logger.debug("file: {}", docHref);

		// 암호화 성공시 TBL_ENDAPRDOCINFO 테이블의 HREF 컬럼 업데이트
		if (encryptForApprovalFile(docFile)) {
			parameterMap.put("href", docHref + "." + ENCRYPTED_FILE_EXT);
			ezApprovalGKlibDAO.updateEndDocHref(parameterMap);
		}

		logger.debug("encryptEndDocFile ended.");
	}

	/**
	 * <b>결재완료문서의 첨부파일을 전부 암호화</b>하여 .ezd 확장자로 저장하고<br>
	 * TBL_ENDATTACHINFO 테이블에서 파일명을 업데이트한다.<br>
	 * <br>
	 * 암호화 실패시 아무 작업도 안 한다.
	 *
	 * @param parameterMap
	 *            문서번호(docId), 회사아이디(companyId), 테넌트아이디(tenantId)
	 */
	private void encryptEndAttachFiles(Map<String, Object> parameterMap) {
		logger.debug("encryptEndAttachFiles started.");

		// 첨부파일 리스트
		List<ApprGAttachInfoVO> attachInfoList = ezApprovalGKlibDAO.getEndAttachInfoList(parameterMap);

		for (ApprGAttachInfoVO attachInfo : attachInfoList) {
			// 첨부파일 경로
			String attachHref = attachInfo.getAttachFileHref();
			Path attachFile = Paths.get(realPath, attachHref);
			
			logger.debug("file: {}", attachHref);

			// 암호화 성공시 TBL_ENDATTACHINFO 테이블의 HREF 컬럼 업데이트
			if (encryptForApprovalFile(attachFile)) {
				// 원래 경로 
				parameterMap.put("orgHref", attachHref);
				// ezd 경로
				parameterMap.put("href", attachHref + "." + ENCRYPTED_FILE_EXT);
				// 첨부파일 순서
				parameterMap.put("attachFileSN", attachInfo.getAttachFileSN());
				
				// 진행 중인 문서, 완료 문서, 임시보관함 등에 있는 동일한 경로의 파일에 모두 .ezd 업데이트
				ezApprovalGKlibDAO.updateEndAttachInfoHref(parameterMap);
				ezApprovalGKlibDAO.updateAprAttachInfoHref(parameterMap);
				ezApprovalGKlibDAO.updateTmpAttachInfoHref(parameterMap);
			}
		}

		logger.debug("encryptEndAttachFiles ended.");
	}

	/**
	 * <b>변경내역의 문서를 전부 암호화</b>하여 .ezd 확장자로 저장하고<br>
	 * TBL_HISTORYDOCINFO 테이블에서 파일명을 업데이트한다.<br>
	 * <br>
	 * 암호화 실패시 아무 작업도 안 한다.
	 *
	 * @param parameterMap
	 *            문서번호(docId), 회사아이디(companyId), 테넌트아이디(tenantId)
	 */
	private void encryptHistoryDocFiles(Map<String, Object> parameterMap) {
		logger.debug("encryptHistoryDocFiles started.");

		// 문서 히스토리 리스트
		List<ApprGHistoryDocVO> historyDocList = ezApprovalGKlibDAO.getHistoryDocList(parameterMap);

		for (ApprGHistoryDocVO hisotryDoc : historyDocList) {
			// 문서 경로
			String historyDocUrl = hisotryDoc.getUrl();
			Path historyDocFile = Paths.get(realPath, historyDocUrl);

			logger.debug("file: {}", historyDocUrl);

			// 암호화 성공시 TBL_HISTORYDOCINFO 테이블의 URL 컬럼 업데이트
			if (encryptForApprovalFile(historyDocFile)) {
				parameterMap.put("changeSN", hisotryDoc.getChangeSN());
				parameterMap.put("url", historyDocUrl + "." + ENCRYPTED_FILE_EXT);

				ezApprovalGKlibDAO.updateHistoryDocHref(parameterMap);
			}
		}

		logger.debug("encryptHistoryDocFiles ended.");
	}

	/**
	 * <b>변경내역의 첨부파일을 전부 암호화</b>하여 .ezd 확장자로 저장하고<br>
	 * TBL_HISTORYATTACHINFO 테이블에서 파일명을 업데이트한다.<br>
	 * <br>
	 * 암호화 실패시 아무 작업도 안 한다.
	 *
	 * @param parameterMap
	 *            문서번호(docId), 회사아이디(companyId), 테넌트아이디(tenantId)
	 */
	private void encryptHistoryAttachFiles(Map<String, Object> parameterMap) {
		logger.debug("encryptHistoryAttachFiles started.");

		// 첨부파일 히스토리 리스트
		List<ApprGHistoryAttachVO> historyAttachList = ezApprovalGKlibDAO.getHistoryAttachList(parameterMap);

		for (ApprGHistoryAttachVO hisotryAttach : historyAttachList) {
			// 첨부파일 경로
			String historyAttachHref = hisotryAttach.getAttachFileHref();
			Path historyAttachFile = Paths.get(realPath, historyAttachHref);

			logger.debug("file: {}", historyAttachHref);

			// 암호화 성공시 TBL_HISTORYATTACHINFO 테이블의 HREF 컬럼 업데이트
			if (encryptForApprovalFile(historyAttachFile)) {
				parameterMap.put("attachFileSN", hisotryAttach.getAttachFileSN());
				parameterMap.put("modifySN", hisotryAttach.getModifySN());
				parameterMap.put("href", historyAttachHref + "." + ENCRYPTED_FILE_EXT);

				ezApprovalGKlibDAO.updateHistoryAttachHref(parameterMap);
			}
		}

		logger.debug("encryptHistoryAttachFiles ended.");
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
			byte[] fileBytes = commonUtil.readBytesFromFile(file);
			// 바이트 암호화
			byte[] encryptedBytes = klibUtil.encrypt(fileBytes);

			// .ezd 확장자로 저장될 경로
			String encryptedFileHref = file.toString() + "." + ENCRYPTED_FILE_EXT;
			Path encryptedFile = Paths.get(encryptedFileHref);

			// 암호화한 바이트를 .ezd 파일로 저장
			commonUtil.writeBytesToFile(encryptedFile, encryptedBytes);

			// 원본 파일 삭제
			Files.delete(file);

			return true;
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
		} catch (UnsatisfiedLinkError linkErr) {
			logger.error(linkErr.toString());
		}

		return false;
	}
}
