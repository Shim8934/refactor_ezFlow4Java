package egovframework.ezMobile.ezApprovalG.service;

import java.util.List;
import java.util.Locale;

import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAbsenteeInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAprLineInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAttachInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGDocInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGLeftVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGOpinionInfoVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;

public interface MApprovalGService {

	public List<MApprovalGDocInfoVO> getDoApproveList(MCommonVO userInfo, String type, String searchText, String listSize, String lastDate) throws Exception;

	public int getDoApproveListCount(MCommonVO userInfo, String type, String pSearchText) throws Exception;

	public List<MApprovalGAprLineInfoVO> getAprLineInfo(String pDocID, String type, MCommonVO userInfo) throws Exception;

	public String getMHTBody(String pDocID, String realPath, String domain, MCommonVO userInfo, Locale locale, String type, String scheme) throws Exception;

	public String getOpinionCount(String pDocID, String type, MCommonVO userInfo) throws Exception;

	public List<MApprovalGOpinionInfoVO> getOpinionInfo(String pDocID, String type, MCommonVO userInfo) throws Exception;

	public int mSetOpinionInfo(String pDocID, String pContent, String pOpinionGB, MCommonVO userInfo, String pType) throws Exception;

	public List<MApprovalGAttachInfoVO> getAttachList(String docId, String type, MCommonVO userInfo) throws Exception;

	public MApprovalGAbsenteeInfoVO getAbsenteeInfo(MCommonVO userInfo) throws Exception;

	public int setAbsenteeInfo(MApprovalGAbsenteeInfoVO absenteeInfoVO) throws Exception;

	public int checkPass(MCommonVO userInfo, String shaEncPassword) throws Exception;

	public MApprovalGDocInfoVO getAprDocInfo(String docId, String type, String lang, String companyId, int tenantId, String aprMemberSN) throws Exception;

	public String getDocState(String docId, String companyId, int tenantId) throws Exception;

	public MApprovalGLeftVO getLeftCount(String userId, MCommonVO userInfo) throws Exception;

	public int delAbsenteeInfo(String userId, int tenantId) throws Exception;

}
