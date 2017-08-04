package egovframework.ezMobile.ezApprovalG.service;

import java.util.List;
import java.util.Locale;

import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAbsenteeInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAprLineInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAttachInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGDocInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGOpinionInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGTLVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginVO;

public interface MApprovalGService {

	public List<MApprovalGDocInfoVO> getDoApproveList(MCommonVO userInfo, String type, String searchText, String listSize, String lastDate) throws Exception;

	public int getDoApproveListCount(MCommonVO userInfo, String type, String pSearchText) throws Exception;

	public List<MApprovalGAprLineInfoVO> getAprLineInfo(String pDocID, MCommonVO userInfo) throws Exception;

	public String getMHTBody(String pDocID, String realPath, String domain, MCommonVO userInfo, Locale locale) throws Exception;

	public String getOpinionCount(String pDocID, MCommonVO userInfo) throws Exception;

	public List<MApprovalGOpinionInfoVO> getOpinionInfo(String pDocID, MCommonVO userInfo) throws Exception;

	public int mSetOpinionInfo(String pDocID, String pContent, String pOpinionGB, MCommonVO userInfo, String pType) throws Exception;

	public List<MApprovalGTLVO> getTimeLineList(LoginVO userInfo, String sessionDate) throws Exception;

	public List<MApprovalGAttachInfoVO> getAttachList(String docId, String type, MCommonVO userInfo) throws Exception;

	public MApprovalGAbsenteeInfoVO getAbsenteeInfo(MCommonVO userInfo) throws Exception;

	public int setAbsenteeInfo(MApprovalGAbsenteeInfoVO absenteeInfoVO) throws Exception;

	public int checkPass(MCommonVO userInfo, String shaEncPassword) throws Exception;

	public MApprovalGDocInfoVO getAprDocInfo(String docId, String type, String companyId, int tenantId) throws Exception;

}
