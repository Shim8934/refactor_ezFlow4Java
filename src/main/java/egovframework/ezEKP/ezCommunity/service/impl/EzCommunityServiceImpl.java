package egovframework.ezEKP.ezCommunity.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommunity.dao.EzCommunityDAO;
import egovframework.ezEKP.ezCommunity.service.EzCommunityService;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardTreeVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCCategoryVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityLeftCommunityVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzCommunityService")
public class EzCommunityServiceImpl implements EzCommunityService{
	@Resource(name="EzCommunityDAO")
	private EzCommunityDAO ezCommunityDAO;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Override
	public String leftCommunityGet1(String code, String userInfoUserID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_USERINFO_USERID", userInfoUserID);
		
		return ezCommunityDAO.leftCommunityGet1(map);
	}

	@Override
	public String leftCommunityGet2(String code) throws Exception {
		return ezCommunityDAO.leftCommunityGet2(code);
	}

	@Override
	public List<CommunityLeftCommunityVO> leftCommunityGet3(String userID) throws Exception {
		return ezCommunityDAO.leftCommunityGet3(userID);
	}

	@Override
	public String leftCommunityGet4(String code) throws Exception {
		return ezCommunityDAO.leftCommunityGet4(code);
	}
	
	@Override
	public String brdCheckIfBoardGroupAdmin(String pRootBoardID, String id, String deptID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", pRootBoardID);
		map.put("v_PUSERID", id);
		map.put("v_PDEPTID", deptID);
		map.put("v_PCOMPANYID", companyID);

		return ezCommunityDAO.brdCheckIfBoardGroupAdmin(map);
	}
	////////////////
	/** 나중에도안쓰면 삭제*/
	@Override
	public List<CommunityCBoardVO> getLeftBoardList() throws Exception {
		return ezCommunityDAO.getLeftBoardList();
	}

	@Override
	public String getCategoryValueA(String strSelCateA, Locale locale) throws Exception {
		StringBuilder sb = new StringBuilder();
		List<CommunityCCategoryVO> categoryList = ezCommunityDAO.getCategoryValueA();
		for(CommunityCCategoryVO category : categoryList){
			sb.append("<Option Value=\"");
			sb.append(category.getC_Code());
			sb.append("\" ");
			
			if(strSelCateA.equals(category.getC_Code())){
				sb.append("selected");
			}
			
			sb.append(">");
			String code = "ezCommunity."+category.getC_Name();
			sb.append(egovMessageSource.getMessage(code, locale));
			sb.append("</Option>");
		}
		return sb.toString();
	}

	@Override
	public String getCategoryValueB(String strSelCateB, Locale locale) throws Exception {
		StringBuilder sb = new StringBuilder();
		List<CommunityCCategoryVO> categoryList = ezCommunityDAO.getCategoryValueB();
		for(CommunityCCategoryVO category : categoryList){
			sb.append("<Option Value=\"");
			sb.append(category.getC_Code());
			sb.append("\" ");
			
			if(strSelCateB.equals(category.getC_Code())){
				sb.append("selected");
			}
			
			sb.append(">");
			String code = "ezCommunity."+category.getC_Name();
			sb.append(egovMessageSource.getMessage(code, locale));
			sb.append("</Option>");
		}
		return sb.toString();
	}

	@Override
	public String getCategoryValueC(String strSelCateC, Locale locale) throws Exception {
		StringBuilder sb = new StringBuilder();
		List<CommunityCCategoryVO> categoryList = ezCommunityDAO.getCategoryValueC();
		for(CommunityCCategoryVO category : categoryList){
			sb.append("<Option Value=\"");
			sb.append(category.getC_Code());
			sb.append("\" ");
			
			if(strSelCateC.equals(category.getC_Code())){
				sb.append("selected");
			}
			
			sb.append(">");
			String code = "ezCommunity."+category.getC_Name();
			sb.append(egovMessageSource.getMessage(code, locale));
			sb.append("</Option>");
		}
		return sb.toString();
	}

	@Override
	public String getBoardTreeGet1(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String strLang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PROOTBOARDID", pRootBoardID);
		map.put("v_PUSERID", pUserID);
		map.put("v_PDEPTID", pDeptID);
		map.put("v_PCOMPANYID", pCompanyID);
		map.put("v_PMODE", pMode);
		map.put("v_PSUBFLAG", pSubFlag);
		map.put("v_PSELECTBY", pSelectBy);
		map.put("v_PEXCLUDEBOARDID", pExcludeBoardID);
		map.put("v_PCLUBNO", pClubNo);
		map.put("v_STRLANG", strLang);
		map.put("v_pCount", 0);
		
		return ezCommunityDAO.getBoardTreeGet1(map);
	}

	@Override
	public List<CommunityBoardTreeVO> brdBoardTree(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSelectBy, String pExcludeBoardID, String pClubNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PROOTBOARDID", pRootBoardID);
		map.put("v_PUSERID", pUserID);
		map.put("v_PDEPTID", pDeptID);
		map.put("v_PCOMPANYID", pCompanyID);
		map.put("v_PMODE", pMode);
		map.put("v_PSELECTBY", pSelectBy);
		map.put("v_PEXCLUDEBOARDID", pExcludeBoardID);
		map.put("v_PCLUBNO", pClubNo);
		
		return ezCommunityDAO.brdBoardTree(map);
	}

	@Override
	public List<CommunityBoardTreeVO> getBoardTreeGet2(String pUserID) throws Exception {
		return ezCommunityDAO.getBoardTreeGet2(pUserID);
	}

	@Override
	public void getBoardTreeSet(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String strLang, String result) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PROOTBOARDID", pRootBoardID);
		map.put("v_PUSERID", pUserID);
		map.put("v_PDEPTID", pDeptID);
		map.put("v_PCOMPANYID", pCompanyID);
		map.put("v_PMODE", pMode);
		map.put("v_PSUBFLAG", pSubFlag);
		map.put("v_PSELECTBY", pSelectBy);
		map.put("v_PEXCLUDEBOARDID", pExcludeBoardID);
		map.put("v_PCLUBNO", pClubNo);
		map.put("v_STRLANG", strLang);
		map.put("v_RESULT", result);
		
		ezCommunityDAO.getBoardTreeSet(map);
	}

	@Override
	public int checkIfLeafBoardGet(String boardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardID);
		map.put("v_pCount", 0);
		return ezCommunityDAO.checkIfLeafBoardGet(map);
	}

	@Override
	public List<String> goAdminOkGet1() throws Exception {
		return ezCommunityDAO.goAdminOkGet1();
	}

	@Override
	public List<CommunityClubVO> goAdminOkGet2(String pClubID) throws Exception {
		return ezCommunityDAO.goAdminOkGet2(pClubID);
	}

	@Override
	public String getCommunityThumInfo(String pBoardID, String pFileName, String pType) throws Exception {
		String pResult = "", pSignatureDir = ""; 
		
		if (pType.equals("COMMUNITYTHUM")) {
			pSignatureDir = config.getProperty("upload_community.ROOT") + commonUtil.separator + pBoardID + commonUtil.separator + "uploadFile";
		} else {
			pSignatureDir = config.getProperty("upload_community.LOGO");
		}
		
		pResult = pSignatureDir + commonUtil.separator + pFileName;
		
		return pResult;
	}

	@Override
	public String getBoardTitleName(String strBoardName, String strClubNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_STRBOARDNAME", strBoardName);
		map.put("v_STRCLUBNO", strClubNo);
		
		return ezCommunityDAO.getBoardTitleName(map);
	}

	@Override
	public int getBBSListGet1(String bName, String lang, String pKeyword, String sRadio) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_USERINFO_LANG", lang);
		map.put("v_KEYWORD", pKeyword);
		map.put("v_S_RADIO", sRadio.toUpperCase());
		
		return ezCommunityDAO.getBBSListGet1(map);
	}

	@Override
	public List<CommunityCBoardVO> getBBSListGet2(String bName, String lang, String pKeyword, String sRadio) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_USERINFO_LANG", lang);
		map.put("v_KEYWORD", pKeyword);
		map.put("v_S_RADIO", sRadio.toUpperCase());
		
		return ezCommunityDAO.getBBSListGet2(map);
	}
	
	
/*	@Override
	public String extractString(String pSource, String pStarts, String pEnds) throws Exception {
		int pos1 = pSource.indexOf(pStarts);
		int pos2 = pSource.indexOf(pEnds, pos1 + pStarts.length());
		
		if(pos1 == -1){
			return "";
		}
		if(pos2 == -1){
			return "";
		}
		
		return pSource.substring(pos1, pos2 - pos1 + pEnds.length());
	}

	@Override
	public String sortXML(String pXML, String pSortBy) throws Exception{
		String temp = "1";
		String[] sortInfo = new String[1000];
		int iCount = 0;
		
		while(iCount < 1000){
			temp = extractString(pXML, "<ROW>", "</ROW>");
			
			if(!temp.equals("")){
				String sortNum = extractString(temp, "<" + pSortBy + ">", "</" + pSortBy + ">").replace("<" + pSortBy + ">", "").replace("</" + pSortBy + ">", "").trim();
				
				while(sortNum.length() < 4){
					sortNum = "0" + sortNum;
				}
				
				sortInfo[iCount] = sortNum + temp;
				pXML = pXML.replace(temp, "");
			}
			
			iCount++;
		}
		
		Arrays.sort(sortInfo);
		
		StringBuilder sb = new StringBuilder("<DATA>");
		
		for(String info : sortInfo){
			sb.append(info.substring(4));
		}
		
		sb.append("</DATA>");
		
		return sb.toString();
	}*/
	
	
}
