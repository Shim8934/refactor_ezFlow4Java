package egovframework.ezEKP.ezCommunity.service.impl;

import java.io.File;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezCommon.service.impl.EzCommonServiceImpl;
import egovframework.ezEKP.ezCommunity.dao.EzCommunityDAO;
import egovframework.ezEKP.ezCommunity.service.EzCommunityService;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardInfoVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardListVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardPropertyVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardTreeVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCCategoryVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityLeftCommunityVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

@Service("EzCommunityService")
public class EzCommunityServiceImpl implements EzCommunityService{
	@Resource(name="EzCommunityDAO")
	private EzCommunityDAO ezCommunityDAO;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name="EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name="EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;
	
	@Resource(name="EzBoardService")
	private EzBoardService ezBoardService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties globals;
	
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
	public String getCategoryValueA(String strSelCateA) throws Exception {
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
			sb.append(egovMessageSource.getMessage(code, new Locale(globals.getProperty("Globals.language"))));
			sb.append("</Option>");
		}
		return sb.toString();
	}

	@Override
	public String getCategoryValueB(String strSelCateB) throws Exception {
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
			sb.append(egovMessageSource.getMessage(code, new Locale(globals.getProperty("Globals.language"))));
			sb.append("</Option>");
		}
		return sb.toString();
	}

	@Override
	public String getCategoryValueC(String strSelCateC) throws Exception {
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
			sb.append(egovMessageSource.getMessage(code, new Locale(globals.getProperty("Globals.language"))));
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
	public CommunityCBoardVO bbsDelOkGet(String bName, String itemNo, String code) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_DOG", itemNo);
		map.put("v_CODE", code);
		
		return ezCommunityDAO.bbsDelOkGet(map);
	}

	@Override
	public void bbsDelOkDel(String bName, String itemNo, String code) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_DOG", itemNo);
		map.put("v_CODE", code);
		
		ezCommunityDAO.bbsDelOkDel(map);
	}

	@Override
	public CommunityClubVO commMakeOkGet1(String clubName, String cCateA, String cCateB, String cCateC, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CLUBNAME", clubName);
		map.put("v_C_CATE_A", cCateA);
		map.put("v_C_CATE_B", cCateB);
		map.put("v_C_CATE_C", cCateC);
		map.put("v_USERINFO_LANG", lang);
		
		return ezCommunityDAO.commMakeOkGet1(map);
	}

	@Override
	public int commMakeOkGet2() throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCount", 0);
		
		return ezCommunityDAO.commMakeOkGet2(map);
	}
	
	@Override
	public int commMakeOkGet4() throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCount", 0);
		
		return ezCommunityDAO.commMakeOkGet4(map);
	}

	@Override
	public void commMakeOkInsert1() throws Exception {
		ezCommunityDAO.commMakeOkInsert1();
	}

	@Override
	public String commMakeOkGet3() throws Exception {
		return ezCommunityDAO.commMakeOkGet3();
	}

	@Override
	public void commMakeOkInsert2(int clubNo, String todayTime, String clubName, String clubName2, String cCateA, String cCateB, String cCateC, String clubType, String clubConfirmType, String intro, int isIn, String logo, String banner, String bBoardName1, String bBoardName2, String comatt, String code, String bNotiName1, String bNotiName2, String pNewID, int boardNo, String id, String displayName1, String companyName1, String deptName1, String pNewSubID, int openEmail, int openHp, int openComp, int openHouse, int openJob, int openBirth, int openSex, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TMP_CLUBID", clubNo);
		map.put("v_DATETIME_NOW1", todayTime);
		map.put("v_CLUBNAME", clubName);
		map.put("v_CLUBNAME2", clubName2);
		map.put("v_C_CATE_A", cCateA);
		map.put("v_C_CATE_B", cCateB);
		map.put("v_C_CATE_C", cCateC);
		map.put("v_CLUBTYPE", clubType);
		map.put("v_CLUBCONFIRMTYPE", clubConfirmType);
		map.put("v_INTRO", intro);
		map.put("v_ISIN", isIn);
		map.put("v_LOGO", logo);
		map.put("v_LOGO_THUMBNAIL", logo);
		map.put("v_BANNER", banner);
		map.put("v_B_BOARD_NAME1", bBoardName1);
		map.put("v_B_BOARD_NAME2", bBoardName2);
		map.put("v_COMATT", comatt);
		map.put("v_CODE", code);
		map.put("v_B_NOTI_NAME1", bNotiName1);
		map.put("v_B_NOTI_NAME2", bNotiName2);
		map.put("v_PNEWID", pNewID);
		map.put("v_BOARDNO", boardNo);
		map.put("v_USERINFO_USERID", id);
		map.put("v_USERINFO_DISPLAYNAME", displayName1);
		map.put("v_USERINFO_COMPANYNAME", companyName1);
		map.put("v_USERINFO_DEPTNAME", deptName1);
		map.put("v_PNEW_SUBID", pNewSubID);
		map.put("v_DATETIME_NOW2", todayTime);
		map.put("v_OPENEMAIL", openEmail);
		map.put("v_OPENHP", openHp);
		map.put("v_OPENCOMP", openComp);
		map.put("v_OPENHOUSE", openHouse);
		map.put("v_OPENJOB", openJob);
		map.put("v_OPENBIRTH", openBirth);
		map.put("v_OPENSEX", openSex);
		map.put("v_USERINFO_COMPANYID", companyID);
		
		ezCommunityDAO.commMakeOkInsert2(map);
	}

	@Override
	public String commMakeOkGet6(String companyID, String id) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_COMPANYID",	companyID);
		map.put("v_USERINFO_USERID", id);
		return ezCommunityDAO.commMakeOkGet6(map);
	}

	@Override
	public void joinOkInsert(String companyID, String userID, String userName, String companyName, String companyName2, String companyZip, String companyAddress, String deptName, String deptName2, String companyTel, String companyFax, String homeTel, String handPhone, String eMail, String birthDay, String gender) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyID);
		map.put("v_USERID", userID);
		map.put("v_USERNAME", userName);
		map.put("v_USERNAME2", userName);
		map.put("v_COMPANYNAME", companyName);
		map.put("v_COMPANYNAME2", companyName2);
		map.put("v_COMPANYZIP", companyZip);
		map.put("v_COMPANYADDRESS", companyAddress);
		map.put("v_DEPTNAME", deptName);
		map.put("v_DEPTNAME2", deptName2);
		map.put("v_COMPANYTEL", companyTel);
		map.put("v_COMPANYFAX", companyFax);
		map.put("v_HOMETEL", homeTel);
		map.put("v_HANDPHONE", handPhone);
		map.put("v_EMAIL", eMail);
		map.put("v_BIRTHDAY", birthDay);
		map.put("v_GENDER", gender);
		
		ezCommunityDAO.joinOkInsert(map);
	}

	@Override
	public void commMakeOkSet1(String logoFileName, String thumbnailFileName, String fileName, int fileSize) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LOGOFILENAME", logoFileName);
		map.put("v_LOGOFILENAME_THUMBNAIL", thumbnailFileName);
		map.put("v_FILENAME", fileName);
		map.put("v_FILESIZE", fileSize);
		
		ezCommunityDAO.commMakeOkSet1(map);
	}

	@Override
	public void commMakeOkSet2(String bannerFileName, String fileName, int fileSize) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BANNERFILENAME", bannerFileName);
		map.put("v_FILENAME", fileName);
		map.put("v_FILESIZE", fileSize);
		
		ezCommunityDAO.commMakeOkSet2(map);
	}
	
	@Override
	public String commHomeGet1(String id, String code) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_USERID", id);
		map.put("v_CODE", code);
		
		return ezCommunityDAO.commHomeGet1(map);
	}

	@Override
	public void updateLastDate(String strNow, String code, String id) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("STRNOW", strNow);
		map.put("CODE", code);
		map.put("ID", id);
		
		ezCommunityDAO.updateLastDate(map);
	}

	@Override
	public String commHomeGet4(String v_CODE) throws Exception {
		return ezCommunityDAO.commHomeGet4(v_CODE);
	}

	@Override
	public int commHomeGet2(String code) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_pCount", 0);
		
		return ezCommunityDAO.commHomeGet2(map);
	}

	@Override
	public CommunityClubVO aspCommInfoGet1(String code) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		
		return ezCommunityDAO.aspCommInfoGet1(map);
	}

	@Override
	public String getCommunityThumInfo(String pBoardID, String pFileName, String pType) throws Exception {
		String pSignatureDir = ""; 
		
		if (pType.equals("COMMUNITYTHUM")) {
			pSignatureDir = config.getProperty("upload_community.ROOT") + commonUtil.separator + pBoardID + commonUtil.separator + "uploadFile";
		} else {
			pSignatureDir = config.getProperty("upload_community.LOGO");
		}
		
		String pResult = pSignatureDir + commonUtil.separator + pFileName;
		
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

	@Override
	public void communityConnCHK(String id, String clubID, String boardID, String rollInfo, int mode, HttpServletResponse response) throws Exception {
		String rtnValue = "";
		boolean result = false;
		
		if (rollInfo.indexOf("c=1") < 0) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_PUSERID", id);
			map.put("iv_PCLUBNO", clubID);
			map.put("v_PBOARDID", boardID);
			
			rtnValue = ezCommunityDAO.getClubCHK(map);
		} else {
			rtnValue = "1";
		}
		
		if (mode == 0 && (rtnValue.equals("1") || rtnValue.equals("2"))) {
			result = true;
		}
		if (mode == 1 && rtnValue.equals("1")) {
			result = true;
		}
		if (result != true) {
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(egovMessageSource.getMessage("ezCommunity.t423", new Locale(globals.getProperty("Globals.language"))));
			response.getWriter().flush();
		}
	}

	@Override
	public String getBoardTree(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String strLang) throws Exception {
		int count = 0;
        String strForbiddenBoardIDList = "";
		StringBuilder result;
		List<CommunityBoardTreeVO> boardTreeList = null;
		List<CommunityBoardTreeVO> brdBoardTreeList = new ArrayList<CommunityBoardTreeVO>();
		
		//TODO 왜 계속 null 인지 모르겟음
/*        String retValue = getBoardTreeGet1(pRootBoardID, pUserID, pDeptID, pCompanyID, pMode, pSubFlag, pSelectBy, pExcludeBoardID, pClubNo, strLang);
System.out.println("retValue = "+retValue);

        if (retValue != null && retValue.length() > 30) {
System.out.println("@");
    		return retValue;
        }*/
        
        String pAccessID = pUserID + "," + ezOrganService.getDeptFullPath(pDeptID) + ",EVERYONE";
        String strRollInfo = ezOrganService.getPropertyValue(pUserID, "extensionattribute1");        
        
        for (int i = 0; i < pAccessID.split(",").length; i++) {
        	boardTreeList = getBoardTreeGet2(pAccessID.split(",")[i].trim());
        	//TODO 여기서 트리가 나와야하는데 size가 0이네
        	brdBoardTreeList = brdBoardTree(pRootBoardID, pAccessID.split(",")[i].trim(), "", "", pMode, pSelectBy, pExcludeBoardID, pClubNo);
        	
			if (boardTreeList.size() > 0) {
				for (int r = 0; r < boardTreeList.size(); r++) {
					strForbiddenBoardIDList += boardTreeList.get(r).getBoardID().split(";")[0].trim()+";";
				}
			}
        }
        
        result = new StringBuilder();
        
        if (pSubFlag == 1) {
        	result.append("<NODES>");
        } else {
        	result.append("<TREEVIEWDATA>");
        }
        
        for (int i = 0; i < brdBoardTreeList.size(); i++) {
        	if (strRollInfo.toLowerCase().indexOf("c=1") == -1 && strRollInfo.toLowerCase().indexOf("k=1") == -1 && strRollInfo.toLowerCase().indexOf("n=1") == -1) {
                if (strForbiddenBoardIDList.indexOf(brdBoardTreeList.get(i).getBoardID()) > -1) {
                	continue;
                }
            }
        	
        	result.append("<NODE>");
        	
        	if (strLang.equals("")) {
        		result.append("<VALUE>" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName()) + "</VALUE>");
        	} else {
        		result.append("<VALUE>" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName2()) + "</VALUE>");
        	}        	
        	
            result.append("<STYLE></STYLE>");
            result.append("<DATA1>" + brdBoardTreeList.get(i).getBoardID() + "</DATA1>");
            
            if (strLang.equals("")) {
            	result.append("<DATA2>" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName()) + "</DATA2>");
            } else {
            	result.append("<DATA2>" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName2()) + "</DATA2>");
            }
            
            result.append("<DATA3>" + pRootBoardID + "</DATA3>");
            
            if (brdBoardTreeList.get(i).getBoardColor() != null) {
            	result.append("<DATA4>" + brdBoardTreeList.get(i).getBoardColor() + "</DATA4>");
            } else {
            	result.append("<DATA4></DATA4>");
            }
            
            result.append("<DATA5>" + brdBoardTreeList.get(i).getC_ClubNo() + "</DATA5>");
            result.append("<DATA6>" + brdBoardTreeList.get(i).getGubun() + "</DATA6>");
            result.append("<EXPANDED>FALSE</EXPANDED>");
            result.append("<ISLEAF>" + checkIfLeafBoard(brdBoardTreeList.get(i).getBoardID()) + "</ISLEAF>");

            if (count == 0 && pSubFlag != 1) {
            	result.append("<SELECT>TRUE</SELECT>");
            }
            
            result.append("</NODE>");
            count++;
        }
        
        if (pSubFlag == 1) {
        	result.append("</NODES>");
        } else {
        	result.append("</TREEVIEWDATA>");
        }
        
        getBoardTreeSet(pRootBoardID, pUserID, pDeptID, pCompanyID, pMode, pSubFlag, pSelectBy, pExcludeBoardID, pClubNo, strLang, result.toString().replace("'", "''"));

        return result.toString();
	}
	
	@Override
	public String checkIfLeafBoard(String pBoardID) throws Exception {
		if (checkIfLeafBoardGet(pBoardID) > 0) {
			return "FALSE";
		} else {
			return "TRUE";
		}
	}

	@Override
	public List<CommunityBoardInfoVO> copHomeBoardGet(String code) throws Exception {
		return ezCommunityDAO.copHomeBoardGet(code);
	}

	@Override
	public List<CommunityBoardItemVO> copHomeBoardItemGet(String boardID) throws Exception {
		return ezCommunityDAO.copHomeBoardItemGet(boardID);
	}

	@Override
	public CommunityBoardPropertyVO getBoardInfo(LoginVO userInfo, String pBoardID) throws Exception {
		CommunityBoardPropertyVO boardInfo = new CommunityBoardPropertyVO();

		if (pBoardID.equals("")) {
			boardInfo.setBoardName(egovMessageSource.getMessage("ezCommunity.t91", new Locale(globals.getProperty("Globals.language"))));
			boardInfo.setBoardName2(egovMessageSource.getMessage("ezCommunity.t91", new Locale(globals.getProperty("Globals.language"))));
			return boardInfo;
		}
		
		String userDeptPath = userInfo.getDeptPathCode() + ",everyone";
		
		for (int i=0; i<userDeptPath.split(",").length; i++) {
			CommunityBoardPropertyVO boardInfoTemp = getACL(pBoardID, userDeptPath.split(",")[i].trim());
			
			if (boardInfoTemp == null) {
				break;
			} else {
				boardInfo = boardInfoTemp;
			}
		}
		
		String boardGroupAdmin_FG = checkIfBoardGroupAdmin(pBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID());
		boardInfo.setBoardGroupAdmin_FG(boardGroupAdmin_FG);
		boardInfo.setSs_Board_MaxRows(10);
		boardInfo.setSs_SearchBoard_MaxRows(10);
		
		if (pBoardID.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
	    	boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("false");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		} else if (userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("n=1") > -1) {
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("true");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		} else if (boardInfo.getBoardGroupAdmin_FG().equals("OK")) {	
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("true");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		} else if (boardInfo.getBoardAdmin_FG().equals("") || boardInfo.getBoardAdmin_FG() == null) {
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("false");
			boardInfo.setListView_FG("false");
			boardInfo.setRead_FG("false");
			boardInfo.setWrite_FG("false");
			boardInfo.setReply_FG("false");
			boardInfo.setDelete_FG("false");
		}
		
		CommunityBoardPropertyVO strProp = getBoardProperty(pBoardID);
		
		if (strProp != null) {
	    	boardInfo.setExpireDays(Integer.toString(strProp.getItemExpires()));
	    	boardInfo.setAttachSizeLimit(strProp.getAttachSizeLimit());
		    boardInfo.setBoardName(strProp.getBoardName());
		    boardInfo.setBoardName2(strProp.getBoardName2());
			boardInfo.setReplyNotify(strProp.getReplyNotify());
			boardInfo.setGubun(strProp.getGubun());
			boardInfo.setUrl(strProp.getUrl());
		}
		
		if (boardInfo.getGubun() != null && boardInfo.getGubun().equals("3")) {
			boardInfo.setSs_Board_MaxRows(10);
		}
		
		boardInfo.setBoardID(pBoardID);
		
		return boardInfo;
	}

	@Override
	public CommunityBoardListVO boardItemListGet1(String pBoardID, String id) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", pBoardID);
		map.put("v_USERINFO_USERID", id);
		return ezCommunityDAO.boardItemListGet1(map);
	}
	
	@Override
	public String checkIfBoardGroupAdmin(String pRootBoardID, String id, String deptID, String companyID) throws Exception {
		if (Integer.parseInt(brdCheckIfBoardGroupAdmin(pRootBoardID, id, deptID, companyID)) > 0) {
			return "OK";
		} else {
			return "NO";
		}
	}
	
	@Override
	public CommunityBoardPropertyVO getACL(String pBoardID, String pAccessID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", pBoardID);
		map.put("v_pAccessID", pAccessID);
		
		return ezCommunityDAO.getACL(map);
	}
	
	@Override
	public CommunityBoardPropertyVO getBoardProperty(String pBoardID) {
		return ezCommunityDAO.getBoardProperty(pBoardID);
	}

	@Override
	public String getNewItemListXML(String id, int pStartRow, int pEndRow, String pSortBy) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", id);
		map.put("v_PSORTBY", pSortBy);
		
		if (pEndRow > 0){
			map.put("v_PENDROW", pEndRow);
		} else {
			map.put("v_PENDROW", 0);
		}
		
		int count = 0;
		StringBuilder sb = new StringBuilder();
		
		List<CommunityBoardItemVO> list = ezCommunityDAO.getNewItemListXML(map);
		
		sb.append("<NODES>");
		
		for (CommunityBoardItemVO itemList : list) {
			count ++;
			
			if (count >= pStartRow) {
				sb.append("<NODE>");
				sb.append("<BoardID>" + itemList.getBoardID() + "</BoardID>");
				sb.append("<BoardName>" + itemList.getBoardName() + "</BoardName>");
				sb.append("<ItemID>" + itemList.getItemID() + "</ItemID>");
				sb.append("<WriterID>" + itemList.getWriterID() + "</WriterID>");
				sb.append("<WriterName>" + itemList.getWriterName() + "</WriterName>");
				sb.append("<WriterDeptName>" + itemList.getWriterDeptName() + "</WriterDeptName>");
				sb.append("<WriterCompanyName>" + itemList.getWriterCompanyName() + "</WriterCompanyName>");
				sb.append("<WriteDate>" + itemList.getWriteDate() + "</WriteDate>");
				sb.append("<Importance>" + itemList.getImportance() + "</Importance>");
				sb.append("<Title>" + itemList.getTitle() + "</Title>");
				sb.append("<Attachments>" + itemList.getAttachMents() + "</Attachments>");
				sb.append("<ReadCount>" + itemList.getReadCount() + "</ReadCount>");
				sb.append("<ItemLevel>" + itemList.getItemLevel() + "</ItemLevel>");
				sb.append("<Abstract>" + itemList.getAbsTract() + "</Abstract>");
				sb.append("</NODE>");
			}
		}
		
		sb.append("</NODES>");
		
		return sb.toString();
	}

	@Override
	public String getNewItemListCount(String id) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUserID", id);
		map.put("v_pNow", EgovDateUtil.getTodayTime());
		map.put("v_pFromNow", EgovDateUtil.addDay(EgovDateUtil.getTodayTime(), -5, "yyyy-MM-dd HH:mm:ss"));
		
		return ezCommunityDAO.brdNewItemCount(map);
	}

	@Override
	public String getBoardListItemXML(String id, String pBoardID, int pStartRow, int pEndRow, String pSortBy, String lang) throws Exception {
		int count = 0;
		StringBuilder sb = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_LANG", commonUtil.getMultiData(lang));
		map.put("v_PUSERID", id);
		map.put("v_PBOARDID", pBoardID);
		map.put("v_PSORTBY", pSortBy);
		map.put("v_PENDROW", pEndRow);
		
		///////////////////////////////
		List<CommunityBoardListVO> list = ezCommunityDAO.boardItemListGet2(map);
		
		sb.append("<NODES>");
		
		for (CommunityBoardListVO boardList : list) {
			count++;
			
			if (count >= pStartRow) {
				sb.append("<NODE>");
				sb.append("<ItemID>" + boardList.getItemID() + "</ItemID>");
				sb.append("<WriterID>" + commonUtil.cleanValue(boardList.getWriterID()) + "</WriterID>");
				sb.append("<WriterName>" + commonUtil.cleanValue(boardList.getWriterName()) + "</WriterName>");
				sb.append("<WriterDeptName>" + commonUtil.cleanValue(boardList.getWriterDeptName()) + "</WriterDeptName>");
				sb.append("<WriterCompanyName>" + commonUtil.cleanValue(boardList.getWriterCompanyName()) + "</WriterCompanyName>");
				sb.append("<WriteDate>" + boardList.getWriteDate() + "</WriteDate>");
				sb.append("<Importance>" + boardList.getImportance() + "</Importance>");
				sb.append("<Title>" + commonUtil.cleanValue(boardList.getTitle()) + "</Title>");
				sb.append("<Attachments>" + boardList.getAttachments() + "</Attachments>");
				sb.append("<ReadCount>" + boardList.getReadCount() + "</ReadCount>");
				sb.append("<ItemLevel>" + boardList.getItemLevel() + "</ItemLevel>");
				sb.append("<ReadFlag>" + boardList.getReadFlag() + "</ReadFlag>");
				sb.append("<Abstract>" + boardList.getAbsTract() + "</Abstract>");
				sb.append("</NODE>");
			}
		}
		
		sb.append("</NODES>");
		
		return sb.toString();
	}

	@Override
	public String getBoardTotalItemCount(String pBoardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", pBoardID);
		map.put("v_pNow", EgovDateUtil.getTodayTime());
		
		return ezCommunityDAO.getBoardTotalItemCount(map);
	}
	
	@Override
	public String getCategory(String strSelCateA, String strSelCateB, String strSelCateC) throws Exception {
		StringBuilder strHTML = new StringBuilder();
		
		strHTML.append("<Select name=\"cCateA\">");
		strHTML.append("<Option Value=\"0\">" + egovMessageSource.getMessage("ezCommunity.t80", new Locale(globals.getProperty("Globals.language"))) + "</Option>");
		strHTML.append(getCategoryValueA(strSelCateA));
		strHTML.append("</Select>");
		strHTML.append("<Select name=\"cCateB\" class=\"text\">");
		strHTML.append("<Option Value=\"0\">" + egovMessageSource.getMessage("ezCommunity.t81", new Locale(globals.getProperty("Globals.language"))) + "</Option>");
		strHTML.append(getCategoryValueB(strSelCateB));
		strHTML.append("</Select>");
		strHTML.append("<Select name=\"cCateC\" class=\"text\" style='display:none'>");
		strHTML.append("<Option Value=\"0\">" + egovMessageSource.getMessage("ezCommunity.t82", new Locale(globals.getProperty("Globals.language"))) + "</Option>");
		strHTML.append(getCategoryValueC(strSelCateC));
		strHTML.append("</Select>");
		
		return strHTML.toString();
	}

	@Override
	public String searchItemXML(String id, String boardID, String title, String writerName, String abstracts, String searchStart, String searchEnd, int pStartRow, int pEndRow, String strLang) throws Exception {
		StringBuilder sb = new StringBuilder();
		int count = 0;
		
		if (!searchStart.trim().equals("")) {
            if (searchStart.indexOf(" ") != -1) {
            	searchStart = searchStart.split(" ")[0];
            }
        }

        if (!searchEnd.trim().equals("")) {
            if (searchEnd.indexOf(" ") != -1) {
            	searchEnd = searchEnd.split(" ")[0];
            }
        }
        
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("v_PENDROW", pEndRow);
        map.put("v_STRLANG", strLang);
        map.put("v_PBOARDID", boardID);
        map.put("v_PUSERID", id);
        map.put("v_PTITLE", title);
        map.put("v_PWRITERNAME", writerName);
        map.put("v_PABSTRACT", abstracts);
        map.put("v_PSTARTDATE", searchStart);
        map.put("v_PENDDATE", searchEnd);
        
        List<CommunityBoardListVO> list = ezCommunityDAO.searchItemXML(map);
        
        sb.append("<NODES>");
		
		for (CommunityBoardListVO boardList : list) {
			count++;
			
			if (count >= pStartRow) {
				sb.append("<NODE>");
				sb.append("<ItemID>" + boardList.getItemID() + "</ItemID>");
				sb.append("<WriterID>" + commonUtil.cleanValue(boardList.getWriterID()) + "</WriterID>");
				sb.append("<WriterName>" + commonUtil.cleanValue(boardList.getWriterName()) + "</WriterName>");
				sb.append("<WriterDeptName>" + commonUtil.cleanValue(boardList.getWriterDeptName()) + "</WriterDeptName>");
				sb.append("<WriterCompanyName>" + commonUtil.cleanValue(boardList.getWriterCompanyName()) + "</WriterCompanyName>");
				
				if (boardList.getWriteDate().equals(boardList.getParentWriteDate())) {
					sb.append("<WriteDate>" + boardList.getWriteDate() + "</WriteDate>");
				} else {
					sb.append("<WriteDate>" + boardList.getParentWriteDate() + "</WriteDate>");
				}
				
				sb.append("<Importance>" + boardList.getImportance() + "</Importance>");
				sb.append("<Title>" + commonUtil.cleanValue(boardList.getTitle()) + "</Title>");
				
				if (boardList.getAttachments().equals("")) {
					sb.append("<Attachments></Attachments>");
				} else {
					sb.append("<Attachments>" + boardList.getAttachments() + "</Attachments>");
				}
				
				sb.append("<ReadCount>" + boardList.getReadCount() + "</ReadCount>");
				sb.append("<ItemLevel>" + boardList.getItemLevel() + "</ItemLevel>");
				sb.append("<ReadFlag>" + boardList.getReadFlag() + "</ReadFlag>");
				sb.append("<Abstract>" + boardList.getAbsTract() + "</Abstract>");
				sb.append("</NODE>");
			}
		}
		
		sb.append("</NODES>");
		
		return sb.toString();
	}

	@Override
	public String searchItemCount(String id, String boardID, String title, String writerName, String abstracts, String startDateTime, String endDateTime) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", boardID);
		map.put("v_PTITLE", title);
		map.put("v_PWRITERNAME", writerName);
		map.put("v_PABSTRACT", abstracts);
		map.put("v_PSTARTDATE", startDateTime);
		map.put("v_PENDDATE", endDateTime);
		
		
		return ezCommunityDAO.searchItemCount(map);
	}

	@Override
	public void setAsRead(LoginVO userInfo, String boardID, String itemIDList) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("iv_pBoardID", boardID);
		map.put("v_pUserID", userInfo.getId());
		map.put("v_pUserName", userInfo.getDisplayName1());
		map.put("v_pUserDeptName", userInfo.getDeptName1());
		map.put("v_pUserCompanyName", userInfo.getCompanyName1());
		map.put("v_pUserTitle", userInfo.getTitle1());
		map.put("v_pUserName2", userInfo.getDisplayName2());
		map.put("v_pUserDeptName2", userInfo.getDeptName2());
		map.put("v_pUserCompanyName2", userInfo.getCompanyName2());
		map.put("v_pUserTitle2", userInfo.getTitle2());
		
		for (String item : itemIDList.split(";")) {
			map.put("v_pItemID", item);
			ezCommunityDAO.setAsRead(map);
		}
	}

	@Override
	@Transactional
	public void deleteItem(String itemList) throws Exception {
		String boardID = "";
		
		for (String itemID : itemList.split(";")) {
			itemID = itemID.split(",")[0];
			boardID = ezCommunityDAO.deleteItemGet(itemID);
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("boardID", boardID);
			map.put("itemID", itemID);

			ezCommunityDAO.deleteItem1(itemID);
			ezCommunityDAO.deleteItem2(itemID);
			ezCommunityDAO.deleteItem3(itemID);
			ezCommunityDAO.deleteItem4(map);
		}
	}

	@Override
	public String checkIfHasReply(String itemList) throws Exception {
		for (String item : itemList.split(";")) {
			String itemID = item.split(",")[0];
			String ret = ezCommunityDAO.checkIfHasReply(itemID);

			if (!ret.equals("0")) {
				return "FALSE";
			}
		}
		return "TRUE";
	}

	@Override
	public CommunityBoardItemVO getItemXML(String pBoardID, String pItemID, String multiData) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String newItem(Document xmlData, String pMode, String realPath) throws Exception {
		String pUploadFilePath = "", pContentLocation = "", pHasAttach = "", pContent = "";
		boolean saveMHTResult = false;
		CommunityBoardItemVO item = new CommunityBoardItemVO();

		pUploadFilePath = xmlData.getElementsByTagName("FILEPATH").item(0).getTextContent();
		item.setItemID(xmlData.getElementsByTagName("ITEMID").item(0).getTextContent());
		item.setBoardID(xmlData.getElementsByTagName("BOARDID").item(0).getTextContent());
		item.setWriterID(xmlData.getElementsByTagName("WRITERID").item(0).getTextContent());
		item.setWriterName(xmlData.getElementsByTagName("WRITERNAME").item(0).getTextContent());
		item.setWriterName2(xmlData.getElementsByTagName("WRITERNAME2").item(0).getTextContent());
		item.setWriterDeptID(xmlData.getElementsByTagName("DEPTID").item(0).getTextContent());
		item.setWriterDeptName(xmlData.getElementsByTagName("DEPTNAME").item(0).getTextContent());
		item.setWriterDeptName2(xmlData.getElementsByTagName("DEPTNAME2").item(0).getTextContent());
		item.setWriterCompanyID(xmlData.getElementsByTagName("COMPANYID").item(0).getTextContent());
		item.setWriterCompanyName(xmlData.getElementsByTagName("COMPANYNAME").item(0).getTextContent());
		item.setWriterCompanyName2(xmlData.getElementsByTagName("COMPANYNAME2").item(0).getTextContent());
		item.setWriteDate(EgovDateUtil.getTodayTime());
		item.setImportance(Integer.parseInt(xmlData.getElementsByTagName("IMPORTANCE").item(0).getTextContent()));
		item.setTitle(xmlData.getElementsByTagName("TITLE").item(0).getTextContent());
		
		
		if (pMode.equals("copy")) {
			pContentLocation = xmlData.getElementsByTagName("CONTENTLOCATION").item(0).getTextContent();
		} else {
			pContentLocation = config.getProperty("upload_community.ROOT") + commonUtil.separator + item.getBoardID() + commonUtil.separator + "doc" + commonUtil.separator + item.getItemID() + ".mht";
		}
		
		item.setContentLocation(pContentLocation);
		item.setStartDate(xmlData.getElementsByTagName("STARTDATE").item(0).getTextContent());

		if (item.getStartDate().equals("")) {
			item.setStartDate(item.getWriteDate());
		}
		
		item.setEndDate(xmlData.getElementsByTagName("ENDDATE").item(0).getTextContent());
		item.setAbsTract(xmlData.getElementsByTagName("ABSTRACT").item(0).getTextContent());
		item.setAttachMents(xmlData.getElementsByTagName("ATTACHMENTS").item(0).getTextContent());
		item.setUpperItemIDTree(xmlData.getElementsByTagName("UPPERITEMIDTREE").item(0).getTextContent());
		
		//답변의 경우 최근에 답변 달은 것이 최상위로 와야함(by design)
		if (pMode.equals("reply")) {
//			item.setUpperItemIDTree(item.getUpperItemIDTree() + GetReverseDateNow() + item.getItemID());
		}
		
		item.setItemLevel(Integer.parseInt(xmlData.getElementsByTagName("ITEMLEVEL").item(0).getTextContent()));
		
		if (!pMode.equals("copy")) {
			pContent = xmlData.getElementsByTagName("CONTENT").item(0).getTextContent();
			item.setParentWriteDate(xmlData.getElementsByTagName("PARENTWRITEDATE").item(0).getTextContent());
		} else {
			item.setParentWriteDate(item.getWriteDate());
		}

		if (item.getParentWriteDate().equals("")) {
			item.setParentWriteDate(item.getStartDate());
		}
	
		//확장 필드, Ext1, Ext2는 integer 값을 가짐
		if (xmlData.getElementsByTagName("EXTENSIONATTRIBUTE1").item(0).getTextContent().trim().equals("")) {
			item.setExtensionAttribute1(0);
		} else {
			item.setExtensionAttribute1(Integer.parseInt(xmlData.getElementsByTagName("EXTENSIONATTRIBUTE1").item(0).getTextContent().trim()));
		}

		if (xmlData.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().trim().equals("")) {
			item.setExtensionAttribute2(0);
		} else {
			item.setExtensionAttribute2(Integer.parseInt(xmlData.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().trim()));
		}

		item.setExtensionAttribute3(xmlData.getElementsByTagName("EXTENSIONATTRIBUTE3").item(0).getTextContent());
		item.setExtensionAttribute32(xmlData.getElementsByTagName("EXTENSIONATTRIBUTE32").item(0).getTextContent());
		item.setExtensionAttribute4(xmlData.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0).getTextContent());
		item.setExtensionAttribute5(xmlData.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent());

		item.setDocPassword(xmlData.getElementsByTagName("DOCPASSWORD").item(0).getTextContent());

		if (!pMode.equals("copy")) {
			saveMHTResult = saveMHT(pContent, item.getItemID(), item.getBoardID(), pUploadFilePath, realPath);
			
			if (saveMHTResult == false) {
				return "ERROR:MHT 파일을 저장하는데 실패하였습니다.";
			}
		}
    
		if (item.getAttachMents().length() > 0) {
			pHasAttach = "1";
		} else {
			pHasAttach = "0";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemID", item.getItemID());
		map.put("v_pBoardID", item.getBoardID());
		map.put("v_pWriterID", item.getWriterID());
		map.put("v_pWriterName", item.getWriterName());
		map.put("v_pWriterName2", item.getWriterName2());
		map.put("v_pWriterDeptID", item.getWriterDeptID());
		map.put("v_pWriterDeptName", item.getWriterDeptName());
		map.put("v_pWriterDeptName2", item.getWriterDeptName2());
		map.put("v_pWriterCompanyID", item.getWriterCompanyID());
		map.put("v_pWriterCompanyName", item.getWriterCompanyName());
		map.put("v_pWriterCompanyName2", item.getWriterCompanyName2());
		map.put("v_pWriteDate", item.getWriteDate());
		map.put("v_pParentWriteDate", item.getParentWriteDate());
		map.put("v_pImportance", item.getImportance());
		map.put("v_pTitle", item.getTitle());
		map.put("v_pContentLocation", item.getContentLocation());
		map.put("v_pStartDate", item.getStartDate());
		map.put("v_pEndDate", item.getEndDate());
		map.put("v_pAbstract", item.getAbsTract());
		map.put("v_pAttachments", pHasAttach);
		map.put("v_pUpperItemIDTree", item.getUpperItemIDTree());
		map.put("v_pItemLevel", item.getItemLevel());
		map.put("v_pExtensionAttribute1", item.getExtensionAttribute1());
		map.put("v_pExtensionAttribute2", item.getExtensionAttribute2());
		map.put("v_pExtensionAttribute3", item.getExtensionAttribute3());
		map.put("v_pExtensionAttribute32", item.getExtensionAttribute32());
		map.put("v_pExtensionAttribute4", item.getExtensionAttribute4());
		map.put("v_pExtensionAttribute5", item.getExtensionAttribute5());
		map.put("v_pDocPassWord", item.getDocPassword());

		if (pMode.equals("modify")) {
//			ezCommunityDAO.brdUpdateItem(map);
			return "OK";
		} else {
			ezCommunityDAO.brdNewItem(map);
			return "OK";
		}
		
	}

	@Override
	public boolean saveMHT(String strHTML, String strMHTFileName, String strBoardID, String strFilePath, String realPath) throws Exception {
		String docPath = "";
		String mhtFilePath = "";
		
		try {
			docPath = realPath + commonUtil.separator + strFilePath + commonUtil.separator;
			
			
			if (!new File(docPath + strBoardID).exists()) {
				File dir1 = new File(docPath + strBoardID + commonUtil.separator + "UploadFile");
				File dir2 = new File(docPath + strBoardID + commonUtil.separator + "doc");
				dir1.mkdirs();
				dir2.mkdirs();
			}
			
			mhtFilePath = docPath + strBoardID + commonUtil.separator + "doc" + commonUtil.separator + strMHTFileName + ".mht";

			if(new File(mhtFilePath).exists()) {
				new File(mhtFilePath).delete();
			}
			
			PrintWriter pw = new PrintWriter(new File(mhtFilePath));
			pw.print(strHTML);
			pw.flush();
			pw.close();
			return true;
		} catch(Exception e) {
			return false;
		}
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
