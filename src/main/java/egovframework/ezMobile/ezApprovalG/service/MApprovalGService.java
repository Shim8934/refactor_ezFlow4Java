package egovframework.ezMobile.ezApprovalG.service;

import java.util.List;

import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAprLineInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGDocInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGOpinionInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGTLVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginVO;

public interface MApprovalGService {

	public List<MApprovalGDocInfoVO> getDoApproveList(MCommonVO userInfo, String listType, String searchText, String listSize, String lastDate) throws Exception;

	public int getDoApproveListCount(MCommonVO userInfo, String pListType, String pSearchText) throws Exception;

	public List<MApprovalGAprLineInfoVO> getAprLineInfo(String pDocID, String pListType, LoginVO userInfo) throws Exception;

	public String getMHTBody(String pDocID, String pListType, String realPath, String domain, LoginVO userInfo) throws Exception;

	public String getAprCommentCount(String pDocID, String pListType, LoginVO userInfo) throws Exception;

	public List<MApprovalGOpinionInfoVO> getOpinionInfo(String pDocID, String pListType, LoginVO userInfo) throws Exception;

	public void saveOpinionInfo(String pDocID, String pContent, String pOpinionGB, LoginVO userInfo) throws Exception;

	public List<MApprovalGTLVO> getTimeLineList(LoginVO userInfo, String sessionDate) throws Exception;

}
