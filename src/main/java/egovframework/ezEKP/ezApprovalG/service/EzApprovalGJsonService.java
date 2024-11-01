package egovframework.ezEKP.ezApprovalG.service;

import java.util.Locale;
import java.util.Map;

public interface EzApprovalGJsonService {

	public Map<String, Object> getAprLineInfo(String docID, String userID, String formID, String companyID, String lang, int tenantID, String offset, String reDraftFlag, String isUsed, String beforeDocID, String mode, String docState) throws Exception;
	
	/* 2024-03-20 홍승비 - SQL Injection 제거 > 검색 쿼리를 subQuery 문자열이 아닌 개별 파라미터로 전달 */
	public Map<String, Object> getAdminSearchDocList(
			String formID,
			String formName,
			String docNumber,
			String docTitle, 
			String drafter, 
			String approvUser, 
			String draftDeptName, 
			String draftfrom, 
			String draftto, 
			String apprfrom,
			String apprto, 
			String pageSize, 
			String pageNum, 
			String orderCell, 
			String orderOption, 
			String companyID,  
			int tenantID, 
			String lang, 
			String offSet, 
			String approvalFlag,
			String keyword,
			String itemcode,
			Locale locale
			) throws Exception;
	
}
