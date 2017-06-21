package egovframework.ezMobile.ezApprovalG.service;

import java.util.List;

import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAprLineInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGDocInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGOpinionInfoVO;
import egovframework.let.user.login.vo.LoginVO;

public interface MApprovalGService {

	public List<MApprovalGDocInfoVO> getDoApproveList(LoginVO userInfo, String listType, String searchText) throws Exception;

	public int getDoApproveListCount(LoginVO userInfo, String pListType, String pSearchText) throws Exception;

	public List<MApprovalGAprLineInfoVO> getAprLineInfo(String pDocID, String pListType, LoginVO userInfo) throws Exception;

	public String getMHTBody(String pDocID, String pListType, String realPath, String domain, LoginVO userInfo) throws Exception;

	public String getAprCommentCount(String pDocID, String pListType, LoginVO userInfo) throws Exception;

	public List<MApprovalGOpinionInfoVO> getOpinionInfo(String pDocID, String pListType, LoginVO userInfo) throws Exception;

	public void saveOpinionInfo(String pDocID, String pContent, String pOpinionGB, LoginVO userInfo) throws Exception;

}
