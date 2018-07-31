package egovframework.ezEKP.ezApprovalG.service;

/**
 * KLIB 암/복호화 관련으로 전자결재에서 쓰이는 서비스 클래스
 * 
 * @NOTE 결재완료된 문서를 암호화 하기 위해서 쓰는데, 파일 처리 로직이나 내부 클래스 구현으로 인해서 소스코드가 복잡해져 KLIB
 *       관련으로 따로 서비스를 만들었습니다.<br>
 *       <i>혹여나 파일을 나눌 필요 없이 기존의 서비스에 넣는다거나, 개선 사항이 있다면 수정해주시길 바랍니다.</i><br>
 */
public interface EzApprovalGKlibService {
	/** 암호화된 파일을 구분하기 위한 확장자명 */
	String ENCRYPTED_FILE_EXT = "ezd";
	/** 원본 파일 백업 폴더 이름 */
	String BACKUP_DIR_NAME = "klib_backup";

	/**
	 * 결재완료문서를 암호화 처리하는 API.<br>
	 * docId에 해당하는 결재완료문서/첨부파일의 모든 원본 파일(히스토리 포함)을 klib으로 암호화하고<br>
	 * ezd 확장자를 붙여 저장한다.<br>
	 * 
	 * <br>
	 * 아래에 나와 있는 테이블들의 파일 경로 컬럼에 ".ezd" 문자열을 붙여 업데이트한다.<br>
	 * <code>TBL_ENDAPRDOCINFO, TBL_ENDATTACHINFO, TBL_HISTORYDOCINFO,
	 * TBL_HISTORYATTACHINFO</code>
	 * 
	 * @param docId
	 *            전자결재 문서 번호
	 * @param companyId
	 *            회사 아이디
	 * @param tenantId
	 *            테넌트 아이디
	 */
	void encryptCompleteApproveFiles(String docId, String companyId, int tenantId);
}
