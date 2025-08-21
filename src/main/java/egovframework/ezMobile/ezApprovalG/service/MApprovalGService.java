package egovframework.ezMobile.ezApprovalG.service;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import egovframework.ezMobile.ezApprovalG.vo.*;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;

import egovframework.let.user.login.vo.LoginVO;
import org.json.simple.JSONObject;

import javax.servlet.http.HttpServletRequest;

public interface MApprovalGService {

	public List<MApprovalGDocInfoVO> getDoApproveList(MCommonVO userInfo, String type, String searchText, String listSize, String lastDate) throws Exception;

	public int getDoApproveListCount(MCommonVO userInfo, String type, String pSearchText) throws Exception;

	public List<MApprovalGAprLineInfoVO> getAprLineInfo(String pDocID, String type, MCommonVO userInfo) throws Exception;

	public String getMHTBody(String pDocID, String realPath, String domain, MCommonVO userInfo, Locale locale, String type, String scheme, String mode) throws Exception;

	public String getOpinionCount(String pDocID, String type, MCommonVO userInfo) throws Exception;

	public List<MApprovalGOpinionInfoVO> getOpinionInfo(String pDocID, String type, MCommonVO userInfo) throws Exception;

	// 2023-03-13 전인하 - 전자결재 > 모바일 의견 기능 개선 - 의견 동작 시 추가 파라미터(의견순번) 삽입
	public int mSetOpinionInfo(String pDocID, String pContent, String pOpinionGB, MCommonVO userInfo, String pType, String pAprMemberSN, String opinionSN) throws Exception;

	public List<MApprovalGAttachInfoVO> getAttachList(String docId, String type, MCommonVO userInfo) throws Exception;

	public MApprovalGAbsenteeInfoVO getAbsenteeInfo(MCommonVO userInfo) throws Exception;

	public int setAbsenteeInfo(MApprovalGAbsenteeInfoVO absenteeInfoVO) throws Exception;

	public int checkPass(MCommonVO userInfo, String shaEncPassword) throws Exception;

	public MApprovalGDocInfoVO getAprDocInfo(String docId, String type, String lang, String offset, String companyId, int tenantId, String aprMemberSN, String mode) throws Exception;

	public MApprovalGDocInfoVO getAprMemberSn(String docId, String type, MCommonVO userInfo) throws Exception;

	public String getDocState(String docId, String companyId, int tenantId) throws Exception;

	public MApprovalGLeftVO getLeftCount(String userId, MCommonVO userInfo) throws Exception;

	public int delAbsenteeInfo(String userId, int tenantId) throws Exception;
	
	public int getCheckAprState(String docId, String userId, String aprMemberSN, String mode, String companyId, int tenantId) throws Exception;
	
	public void sendApproveNoticeMail(MCommonVO userInfo, MOptionVO optionInfo, MApprovalGDocInfoVO approvalGDocInfoVO, String docId, String type) throws Exception;
	
	/* 2020-07-02 홍승비 - 모바일에서 최종결재 완료 시 서명에 결재날짜 삽입 동작 추가(결재날짜 필드가 없는 경우에만, 웹과 동일하게) */
	public String insertSeumyungdateMobile(String docId, String realPath, String offset, Locale locale, String domain, String scheme, String companyId, int tenantId) throws Exception;

	/* 2021-02-15 박기범 - 모바일 겸직 부재자설정*/
	public List<MApprovalGAbsenteeAddJobInfoVO> getAbsenteeAddJobInfo(MCommonVO userInfo) throws Exception;

	public int updateAbsenteeJobInfo(JSONObject data, String userId, int tenantId) throws Exception;

	public JSONObject gwDraft(JSONObject data, String realPath, MCommonVO userInfo) throws Exception;
	
	public List<HashMap> checkChangeDocInfo(HashMap<String, Object> params) throws Exception;

	public HashMap<String, Object> getAprMemberBySn(String docID, String aprMemberSN, String lang, String companyID, int tenantID) throws Exception;
	
	/* 2024-10-31 이가은 - 모바일 보낸공람문서 > 공람회수 기능  */
	public String gongRamCancel(String docID, int count, int aprMemberSN, String companyID, int tenantId) throws Exception;

    /* 2025-08-12 김유진 - 모바일 기안이 가능한 양식 */
    public String getForm(String formContID, String kind, String searchType, String searchName, String userID, String deptId, String companyID, String lang, int tenantID) throws Exception;

    /* 2025-08-12 김유진 - 모바일 기안 > 보안등급, 보존년한 */
    public String getSecurityType(String selected, String companyID, String lang, int tenantID, String approvalFlag) throws Exception;
    public String getKeepType(String lang, int tenantId, String companyID) throws Exception;

    /* 2025-08-12 김유진 - 모바일 기안 > 첨부, 문서첨부  */
    public int getAttachFileMaxSn(String docID, int tenantID, String companyID) throws Exception;
    public String updateAttachFileInfo(String docID, JSONObject jsonObj, MCommonVO userInfo) throws Exception;
    public String deleteAttachFileInfo(String docID, String companyID, String lang, int tenantID) throws Exception;
    public String updateAttachDocInfo(JSONObject jsonObject, MCommonVO userInfo, String approvalFlag) throws Exception;
    public String deleteAttachDocInfo(String docID, String companyID, String lang, int tenantID) throws Exception;

    /* 2025-08-12 김유진 - 모바일 기안 > 문서 작성, 기안정보 저장  */
    public String saveDraftInfo(JSONObject jObject, String realPath, LoginVO userInfo, String userInfoXML, HttpServletRequest request) throws Exception;
}
