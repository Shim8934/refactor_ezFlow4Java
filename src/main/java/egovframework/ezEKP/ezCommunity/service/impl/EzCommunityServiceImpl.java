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

	@Override
	public int bbsAdminCheck(String userID, String rollInfo) throws Exception {
		int adminCheck = 0;
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_STRUSERID", userID);
		
		String strAdminID = ezCommunityDAO.ezCommunityBaseGet2(map);
		
		if (strAdminID != null || rollInfo.indexOf("c=1") >= 0) {
			adminCheck = 1;
		}
		
		return adminCheck;
	}

	@Override
	public String bbsEditGet1(String bName, String no) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_NO", no);
		
		return ezCommunityDAO.bbsEditGet1(map);
	}

	@Override
	public CommunityCBoardVO bbsViewNewGet1(String bName, String no) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_NO", no);
		
		return ezCommunityDAO.bbsViewNewGet1(map);
	}

	@Override
	public CommunityCBoardVO bbsEditNew(String bName, String no, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_NO", no);
		map.put("v_USERINFO_LANG", lang);
		
		return ezCommunityDAO.bbsEditNew(map);
	}

	@Override
	public CommunityCBoardVO bbsEditOkGet1(String bName, String gant, String code) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_GANT", gant);
		map.put("v_CODE", code);
		
		return ezCommunityDAO.bbsEditOkGet1(map);
	}

	

	@Override
	public void bbsEditOkSet1(String bName, String title, String gant, String code, String attachList, String textContent) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_TITLE", title);
		map.put("v_GANT", gant);
		map.put("v_CODE", code);
		map.put("v_ATTACHLIST", attachList);
		map.put("v_TEXTCONTENT", textContent);
		
		ezCommunityDAO.bbsEditOkSet1(map);
	}
	
	@Override
	public String bbsEditOkGet2(String maxIdFieldName, String bName, String code) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MAXIDFIELDNAME", maxIdFieldName);
		map.put("v_BNAME", bName);	
		map.put("v_CODE", code);
		
		return ezCommunityDAO.bbsEditOkGet2(map);
	}
	
	@Override
	public String bbsEditOkGet3(String maxIdFieldName, String bName, String code, String strMaxNum) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MAXIDFIELDNAME", maxIdFieldName);
		map.put("v_BNAME", bName);	
		map.put("v_CODE", code);
		map.put("v_STRMAXNUM", strMaxNum);
		
		return ezCommunityDAO.bbsEditOkGet3(map);
	}

	@Override
	public void bbsEditOkSet2(String bName, int myRef, int myStep, String code) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_MYREF", myRef);
		map.put("v_MYSTEP", myStep);
		map.put("v_CODE", code);
		
		ezCommunityDAO.bbsEditOkSet2(map);
	}
	
	@Override
	public void bbsEditOkInsert(String bName, int myRef, int newStep, int newLevel, String attachList, int number, String textContent, String nowDate, String fileName, String code, String companyID, String id, String userNm, String userNm2, String title, String maxIdFieldName) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_MYREF", myRef);
		map.put("v_NEWSTEP", newStep);
		map.put("v_NEWLEVEL", newLevel);
		map.put("v_ATTACHLIST", attachList);
		map.put("v_NUMBER", number);
		map.put("v_TEXTCONTENT", textContent);
		map.put("v_DATETIME_NOW", nowDate);
		map.put("v_FILENAME", fileName);
		map.put("v_CODE", code);
		map.put("v_USERINFO_COMPANYID", companyID);
		map.put("v_USERINFO_USERID", id);
		map.put("v_USERNM", userNm);
		map.put("v_USERNM2", userNm2);
		map.put("v_TITLE", title);
		map.put("v_MAXIDFIELDNAME", maxIdFieldName);

		ezCommunityDAO.bbsEditOkInsert(map);
	}

	@Override
	public List<CommunityCBoardVO> bbsViewNewGet2(String bName) throws Exception {
		return ezCommunityDAO.bbsViewNewGet2(bName);
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
	public String getFileFolderName(String bName) throws Exception {
		String strReturn = "";
		switch (bName){
            case "c_clubnotice":
                strReturn = "notice";
                break;
            case "c_clubboard":
                strReturn = "board";
                break;
            case "c_clubboard1":
                strReturn = "board1";
                break;
            case "c_clubboard2":
                strReturn = "board";
                break;
            case "c_clubpds":
                strReturn = "pds";
                break;
            case "c_clubpds1":
                strReturn = "pds1";
                break;
            case "c_notice":
                strReturn = "mainnotice";
                break;
            case "c_board":
            default:
                strReturn = "mainboard";
                break;
        }
		
		return strReturn;
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
