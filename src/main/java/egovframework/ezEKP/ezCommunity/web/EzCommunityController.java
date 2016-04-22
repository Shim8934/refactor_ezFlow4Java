package egovframework.ezEKP.ezCommunity.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommunity.service.EzCommunityService;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardTreeVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityLeftCommunityVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/** 
 * @Description [Controller] 커뮤니티
 * @author 오픈솔루션팀 이효진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.19    이효진    신규작성
 *
 * @see
 */

@Controller
public class EzCommunityController {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name="EzCommunityService")
	private EzCommunityService ezCommunityService;
	
	@Resource(name="EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@RequestMapping(value="/ezCommunity/communityMain.do")
	public String  main() {
		
		return "/ezCommunity/communityMain";
	}
	
	/** 왼쪽 메뉴화면 호출 함수*/
	@RequestMapping(value = "/ezCommunity/communityLeftCommunity.do")
	public String communityLeftCommunity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap model) throws Exception {
		String userID = "", companyID = "";
		String communityCD = "", userInfoUserID = "";
		String code = "", codeName = "", userLevel = "";
		int permit = 0, confirmType = 0, newMemberConfirmtype = 0;
		String pRootBoardID = "top";
		String pSubFlag = "0";
		int pSelectBy = 0;
		String pExcludeBoardID = "";
        boolean checkSysop = false, joinFlag = false;
        Document xmlret;
        Document xmlcop;
        
        LoginVO loginVO = commonUtil.userInfo(loginCookie);
        
        if (request.getParameter("communityCD") != null) {
            code = request.getParameter("communityCD");
        } else {
            code = "";
        }
        
        if (request.getParameter("communityName") != null) {
            codeName = request.getParameter("communityName");
        } else {
            codeName = "";
        }
        
        if (request.getParameter("userLevel") != null) {
            userLevel = request.getParameter("userLevel");
        } else {
            userLevel = "";
        }
        
        userInfoUserID = loginVO.getId();
        userID = loginVO.getId();
        companyID = loginVO.getCompanyID();
        
        if (code.equals("")) {
        	String vPermit = ezCommunityService.leftCommunityGet1(code, userInfoUserID);
        	
        	if (vPermit==null) {
        		userLevel = "0";
        	} else {
        		userLevel = vPermit;
        		joinFlag = true;
        	}
        	
        	String clubConfirmType = ezCommunityService.leftCommunityGet2(code);
        	if (clubConfirmType != null) {
        		newMemberConfirmtype = Integer.parseInt(clubConfirmType);
        	}
        	
        	//쓰는데 없는거같음
        	/*//dll
        	String boardGroupAdminFG = brdCheckIfBoardGroupAdmin(pRootBoardID, loginVO.getId(), loginVO.getDeptID(), loginVO.getCompanyID());
        	
        	int pMode = 0;
        	
        	if (boardGroupAdminFG.equals("OK") || loginVO.getRollInfo().toLowerCase().indexOf("c=1") > -1 || loginVO.getRollInfo().toLowerCase().indexOf("k=1") > -1 || loginVO.getRollInfo().toLowerCase().indexOf("t=1") > -1) {
        		pMode = 0;
        	} else {
        		pMode = 1;
        	}
        	//dll
        	String retXML = getBoardTree(pRootBoardID, loginVO.getId(), loginVO.getDeptID(), loginVO.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, code, commonUtil.getMultiData(loginVO.getLang()));
        	
        	if (retXML.substring(0, 5).toUpperCase().equals("ERROR")) {
        		xmlret = commonUtil.convertStringToDocument(retXML);
        	} else {
        		xmlret = commonUtil.convertStringToDocument("<RESULT>ERROR</RESULT>");
        	}*/
        	

        	if (userInfoUserID.equals(ezCommunityService.leftCommunityGet4(code))) {
        		checkSysop = true;
        	}
        	
        }        

        /*String rtnVal = commonUtil.getQueryResult(ezCommunityService.leftCommunityGet3(userID));
		xmlcop = commonUtil.convertStringToDocument(rtnVal);*/
		
		model.addAttribute("code",code);
		model.addAttribute("codeName",codeName);
		model.addAttribute("userLevel",userLevel);
		model.addAttribute("newmemberConfirmType",newMemberConfirmtype);
		model.addAttribute("chCommunityAdmin",loginVO.getRollInfo().indexOf("t=1"));
		model.addAttribute("checkSysop",checkSysop);
		model.addAttribute("lang",loginVO.getLang());
		model.addAttribute("userID", userID);
		model.addAttribute("userInfoUserID",userInfoUserID);
		
		return "/ezCommunity/communityLeftCommunity";
	}

	/** 커뮤니티목록 호출 함수*/
	@RequestMapping(value = "/ezCommunity/getLeftCommunity.do", method = RequestMethod.POST, produces = "TEXT/XML;CHARSET=UTF-8")
	@ResponseBody
	public String getLeftCommunity(@CookieValue("loginCookie")String loginCookie) throws Exception {
		String userID = "";
        StringBuilder sb = new StringBuilder();
        
        LoginVO loginVO = commonUtil.userInfo(loginCookie);
        
        userID = loginVO.getId();
        
        List<CommunityLeftCommunityVO> leftCommunityList =ezCommunityService.leftCommunityGet3(userID);
        
        sb.append("<DATA>");
        
        for (CommunityLeftCommunityVO leftCommunity : leftCommunityList) {
        	sb.append(commonUtil.getQueryResult(leftCommunity));
        }
        
        sb.append("</DATA>");
        
        return sb.toString();
	}
	
	/** 알림마당목록 호출 함수*/
	@RequestMapping(value = "/ezCommunity/getLeftBoardList.do", method = RequestMethod.POST, produces = "TEXT/XML;CHARSET=UTF-8")
	@ResponseBody
	public String getLeftBoardList(@CookieValue("loginCookie")String loginCookie) throws Exception {
		StringBuilder sb = new StringBuilder();
		
		List<CommunityCBoardVO> leftBoardList= ezCommunityService.getLeftBoardList();
		sb.append("<DATA>");
		
		for (CommunityCBoardVO leftBoard : leftBoardList) {
			sb.append(commonUtil.getQueryResult(leftBoard));
		}
		
		sb.append("</DATA>");
		
		return sb.toString();
	}
	
	@RequestMapping(value="/ezCommunity/getCommunityThumInfo.do")
	public void getCommunityThumInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		String pType = "5";
		String pBoardID = "";
		String pItemID = "";
		String pQstNo = "";
        String pAnsNo = "";
        String pAttID = "";
        String pFileName = "";
        String pFilePath = "";
		 
        pType = request.getParameter("type");
		pFileName = request.getParameter("fileName");
		pFilePath = ezCommunityService.getCommunityThumInfo(pBoardID, pFileName, "LOGO");

		if (pType.toUpperCase().equals("COMMUNITYLOGO")) {
	        if (pFilePath != null && pFilePath != "") {
	            ezCommonService.responseAttach(pFilePath, pFileName, true, request, response);
	        }
		}
	}
	
	/** 커뮤니티만들기 화면 호출 함수*/
	@RequestMapping(value = "/ezCommunity/commMake.do")
	public String commMake(@CookieValue("loginCookie")String loginCookie, Locale locale, ModelMap model, HttpServletRequest request) throws Exception {
		String userInfoUserID = "", userInfoDisplayName = "";
		String langPrimary="", langSecondary="";
		String flag = "";
		
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		if (request.getParameter("flag") != null) {
			flag = request.getParameter("flag");
		}
		
		userInfoUserID = loginVO.getId();
		langPrimary = config.getProperty("config.lang_Primary"+loginVO.getLang());
		langSecondary = config.getProperty("config.lang_Secondary"+loginVO.getLang());

		if (loginVO.getLang().equals("2")) {
			userInfoDisplayName = loginVO.getDisplayName2();
		} else {
			userInfoDisplayName = loginVO.getDisplayName1();
		}

		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		model.addAttribute("userInfoUserID", userInfoUserID);
		model.addAttribute("userInfoDisplayName", userInfoDisplayName);
		model.addAttribute("flag", flag);		
		model.addAttribute("idSpanValue", getCategory("", "", "", locale));
		return "/ezCommunity/communityCommMake";
	}
	
	/** SubBoards 호출 함수*/
	@RequestMapping(value = "/ezCommunity/getSubBoards.do", method = RequestMethod.POST, produces = "TEXT/XML;CHARSET=UTF-8")
	@ResponseBody
	public String getSubBoards(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request) throws Exception {
		String pClubID = "", pRootBoardID = "", pSubFlag = "", pExcludeBoardID = "";
		int pSelectBy = 0, pMode = 0;
		String strXML = "";
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		pClubID = request.getParameter("classID");
		pRootBoardID = request.getParameter("rootBoardID");
		pSubFlag = request.getParameter("subFlag");
		
		if (request.getParameter("excludeBoardID") != null) {
			pExcludeBoardID = request.getParameter("excludeBoardID");
		}
		if ( request.getParameter("selectFlag") != null) {
			pSelectBy = Integer.parseInt(request.getParameter("selectFlag"));
		}
		
		String boardGroupAdminFG = checkIfBoardGroupAdmin(pRootBoardID, loginVO.getId(), loginVO.getDeptID(), loginVO.getCompanyID());

		if (boardGroupAdminFG.equals("OK") || loginVO.getRollInfo().toLowerCase().indexOf("c=1") > -1 || loginVO.getRollInfo().toLowerCase().indexOf("k=1") > -1 || loginVO.getRollInfo().toLowerCase().indexOf("t=1") > -1) {
			pMode = 0;
		} else {
			pMode = 1;
		}
		
		strXML = getBoardTree(pRootBoardID, loginVO.getId(), loginVO.getDeptID(), loginVO.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, pClubID, commonUtil.getMultiData(loginVO.getLang()));
		
		return strXML;
	}
	
	@RequestMapping(value = "/ezCommunity/goAdminOk.do")
	public String goAdminOk(@RequestBody String data, HttpServletRequest request, CommunityClubVO communityClubVO) throws Exception {
		String pClubID = "";
		StringBuilder aspXML = new StringBuilder(), masterXML = new StringBuilder(), isinXML = new StringBuilder(), resultXML = new StringBuilder();
		String siteXML = "";
		
		Document xmlDom = commonUtil.convertStringToDocument(data);
		pClubID = xmlDom.getChildNodes().item(0).getTextContent();
		
		//사용안하는 테이블 참조  무조건 NULL반환
		List<String> userIDList = ezCommunityService.goAdminOkGet1();
		aspXML.append("<ASP>");
		
		for (String userID : userIDList) {
			aspXML.append("<VALUE>");
			aspXML.append(userID.trim());
			aspXML.append("</VALUE>");
		}
		aspXML.append("<ASP>");
		
		siteXML = "<SITE>"
                + "<VALUE>"
                + "</VALUE>"
                + "</SITE>";
		
		List<CommunityClubVO> clubList = ezCommunityService.goAdminOkGet2(pClubID);
		
		for (CommunityClubVO communityClub : clubList) {
			masterXML.append("<MASTER>");
			masterXML.append("<VALUE>");
			masterXML.append(communityClub.getC_SysopID().trim());
			masterXML.append("</VALUE>");
			masterXML.append("</MASTER>");
			isinXML.append("<ISIN>");
			isinXML.append("<VALUE>");
			isinXML.append(Integer.toString(communityClub.getIsIn()).trim());
			isinXML.append("</VALUE>");
			isinXML.append("</ISIN>");
		}
		
		resultXML.append("<COMMUNITY>");
		resultXML.append(aspXML.toString());
		resultXML.append(siteXML);
		resultXML.append(masterXML.toString());
		resultXML.append(isinXML.toString());
		resultXML.append("</COMMUNITY>");

		return resultXML.toString();
	}
	
	@RequestMapping(value = "/ezCommunity/checkCommHome.do")
	public String checkCommHome(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, ModelMap model) throws Exception {
		String code = "", codeName = "", userLevel = "";
		String userInfoUserID = "", companyID = "";
		int newMemberConfirmtype = 0;
		String pRootBoardID = "top";
		String pSubFlag = "0";
		int pSelectBy = 0;
		String pExcludeBoardID = "";
        boolean checkSysop = false, joinFlag = false;
        Document xmlret;
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		userInfoUserID = loginVO.getId();
		companyID = loginVO.getCompanyID();
		
		code = request.getParameter("communityCD");
		userLevel = request.getParameter("userLevel");
		
		if (request.getParameter("communityName") != null) {
			codeName = request.getParameter("communityName");
		}
		
		if (!code.equals("")) {
			String vPermit = ezCommunityService.leftCommunityGet1(code, userInfoUserID);
        	
        	if (vPermit==null) {
        		userLevel = "0";
        	} else {
        		userLevel = vPermit;
        		joinFlag = true;
        	}
        	
        	/*사용안함
        	String clubConfirmType = ezCommunityService.leftCommunityGet2(code);
        	
        	if (clubConfirmType != null) {
        		newMemberConfirmtype = Integer.parseInt(clubConfirmType);
        	}
        	
        	String boardGroupAdminFG = ezCommunityService.brdCheckIfBoardGroupAdmin(pRootBoardID, loginVO.getId(), loginVO.getDeptID(), loginVO.getCompanyID());
        	
        	int pMode = 0;
        	
        	if (boardGroupAdminFG.equals("OK") || loginVO.getRollInfo().toLowerCase().indexOf("c=1") > -1 || loginVO.getRollInfo().toLowerCase().indexOf("k=1") > -1 || loginVO.getRollInfo().toLowerCase().indexOf("t=1") > -1) {
        		pMode = 0;
        	} else {
        		pMode = 1;
        	}

        	String retXML = getBoardTree(pRootBoardID, loginVO.getId(), loginVO.getDeptID(), loginVO.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, code, commonUtil.getMultiData(loginVO.getLang()));
        	
        	if (retXML.substring(0, 5).toUpperCase().equals("ERROR")) {
        		xmlret = commonUtil.convertStringToDocument(retXML);
        	} else {
        		xmlret = commonUtil.convertStringToDocument("<RESULT>ERROR</RESULT>");
        	}
        	

        	if (userInfoUserID.equals(ezCommunityService.leftCommunityGet4(code))) {
        		checkSysop = true;
        	}*/
		}
		
		model.addAttribute("code", code);
		model.addAttribute("codeName", codeName);
		model.addAttribute("userLevel", userLevel);
		
		return "/ezCommunity/communityCheckCommHome";
	}
	
	/** 알림마당 목록화면 호출 함수*/
	@RequestMapping(value = "/ezCommunity/board/bbsList.do")
	public String bbsList(@CookieValue("loginCookie")String loginCookie, Locale locale, HttpServletRequest request, ModelMap model) throws Exception {
		String bName = "c_Board", mode = "", sRadio = "", type = "", userLevel = "", code = "", keyword = "";
		String pKeyword = "", titleName = "";
		int curPage = 0, totalPage = 0, nowBlock = 0, myChoice = 0 , keywordCount = 0;
		int prevPage = 0, nextPage = 0 , totalBlock = 0, goPage = 0;
		int comNoPerPage = 17;
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		bName = request.getParameter("bName").toLowerCase();
		
		if (request.getParameter("mode") != null) {
			mode = request.getParameter("mode");
		}
		if (request.getParameter("sRadio") != null) {
			sRadio = request.getParameter("sRadio");
		}
		if (request.getParameter("type") != null) {
			type = request.getParameter("type");
		}
		if (request.getParameter("userLevel") != null) {
			userLevel = request.getParameter("userLevel");
		}
		if (request.getParameter("code") != null) {
			code = request.getParameter("code");
		}
		if (request.getParameter("keyword") != null) {
			keyword = request.getParameter("keyword");
			pKeyword = keyword.replace("[", "[[]").replace("%", "[%]").replace("_", "[_]");
		}
		if (request.getParameter("goToPage") != null) {
			curPage = Integer.parseInt(request.getParameter("goToPage"));
		}
		if (request.getParameter("block") != null) {
			nowBlock = Integer.parseInt(request.getParameter("nowBlock"));
		}
		
		if (!code.equals("")) {
			titleName = ezCommunityService.getBoardTitleName(bName, code);
		}
		
		keywordCount = ezCommunityService.getBBSListGet1(bName, loginVO.getLang(), pKeyword, sRadio);
		totalPage = keywordCount / comNoPerPage;
		
		if (keywordCount % comNoPerPage != 0) {
			totalPage = totalPage + 1;
		}
		
		curPage = Math.min(curPage, totalPage);
		
		List<CommunityCBoardVO> cBoardList = ezCommunityService.getBBSListGet2(bName, loginVO.getLang(), pKeyword, sRadio);
		
		StringBuilder strHTML = new StringBuilder();
		int iColSpan = 5;
		
		if (bName.equals("c_clubpds") || bName.equals("c_clubpds1")) {
			iColSpan = 6;
		}
		
		strHTML.append("<tr>");
		strHTML.append("<th width=\"60px\" >" + egovMessageSource.getMessage("ezCommunity.t32", locale) + "</th>");
		strHTML.append("<th>" + egovMessageSource.getMessage("ezCommunity.t170", locale) + "</th>");
		strHTML.append("<th width=\"70px\">" + egovMessageSource.getMessage("ezCommunity.t138", locale) + "</th>");
		strHTML.append("<th width=\"90px\">" +  egovMessageSource.getMessage("ezCommunity.t171", locale) + "</th>");
		
		if (iColSpan == 6) {
			strHTML.append("<th width=\"45px\">" + egovMessageSource.getMessage("ezCommunity.t172", locale) + "</th>");
		}
		
		strHTML.append("<th width=\"60px\">" + egovMessageSource.getMessage("ezCommunity.t173", locale) + "</th>");
		strHTML.append("</tr>");
		
		int iOutputCount = 1;
		int iList = 0;
		String pURL = "";
		
		for (CommunityCBoardVO cBoard : cBoardList) {
			iList++;
			
			if (iList <= (curPage - 1) * comNoPerPage) {
				continue;
			}
			if ( iOutputCount > comNoPerPage) {
				break;
			}
			
			strHTML.append("<tr>");
			strHTML.append("<td width=\"60px\">");
			
			String strClubRecordNo = "";
			
			if (code.equals("")) {
				strClubRecordNo = Integer.toString(cBoard.getNo()).trim();
			} else {
				strClubRecordNo = Integer.toString(cBoard.getC_No()).trim();
			}
			
			if (!bName.equals("c_clubnodice") && !bName.equals("c_notice")) {
				if (cBoard.getRe_Level() > 0) {
					strHTML.append("<font color=\"#A4A4A4\">" + strClubRecordNo + "</font>");
				} else {
					strHTML.append(strClubRecordNo);
				}
			} else {
				strHTML.append(strClubRecordNo);
			}
			
			strHTML.append("</td>");
			strHTML.append("<td class=\"t2\" onclick=btn_bbsView('" + cBoard.getNo() + "','" + bName + "') style=\"overflow: hidden; cursor: pointer; text-overflow: ellipsis;\" >");
			strHTML.append("<nobr>");
			
			if (!bName.equals("c_clubnotice") && !bName.equals("c_notice")) {
				if (cBoard.getRe_Level() > 0) {
					 int wid = 10 * cBoard.getRe_Level();
					 
                     strHTML.append("<img src=\"/images/dum.gif\" width=\"" + wid + "\" height=\"1\" border=\"0\">"); 
                     strHTML.append("<img src=\"/images/i_rep.gif\" alt border=\"0\" VALIGN=\"TOP\">"); 
				}
			}
			
			String nowDate = egovframework.rte.fdl.string.EgovDateUtil.getCurrentDateTimeAsString();
			nowDate = EgovDateUtil.convertDate(nowDate, "", "", "");
			
			if (cBoard.getWriteDay().compareTo(EgovDateUtil.addDay(nowDate.substring(0, 8), -1) + nowDate.substring(8,13)) >= 0) {
				strHTML.append("<img src=\"/images/i_new.gif\" alt border=\"0\">");
			}
			
			strHTML.append(commonUtil.cleanValue(cBoard.getTitle().trim())+"</nobr></td>");
			
			if (commonUtil.getMultiData(loginVO.getLang()).equals("")) {
				strHTML.append("<td class=\"t1\" width=\"70px\" >" + cBoard.getUserName().trim() + "</td>");
			} else {
				strHTML.append("<td class=\"t1\" width=\"70px\" >" + cBoard.getUserName2().trim() + "</td>");
			}
			
			strHTML.append("<td class=\"t1\" width=\"90px\" >" + nowDate + "</td>");
			
			String localPdsPath = ""; 
			
			if (iColSpan == 6) {
//				String file = cBoard.getCharFileName();
//				String fileSize = cBoard.getFil
				
				if (bName.equals("c_clubpds")) {
					localPdsPath = config.getProperty("upload_community.PDS");	
				} else {
					localPdsPath = config.getProperty("upload_community.PDS1");
				}
			
				strHTML.append("<td class=\"t1\" >");
				
				if (cBoard.getCharFileName().equals("")) {
					strHTML.append("<img src=\"/images/i_save01.gif\" width=\"12\" height=\"12\" border=\"0\">");
				}
				
				strHTML.append("</td>");
			}
			
			strHTML.append("<td class=\"t1\" width=\"60px\" >" + cBoard.getReadNum() + "</td>");
			strHTML.append("</tr>");
			
			iOutputCount++;
		}

		model.addAttribute("idSpan", strHTML.toString());
		model.addAttribute("keyword", keyword);
		model.addAttribute("curPage", curPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("keywordCount", keywordCount);
		model.addAttribute("titleName", titleName);
		model.addAttribute("bName", bName);
		
		return "/ezCommunity/board/bbsList";
	}

	/** 카테고리목록 호출 함수*/
	private String getCategory(String strSelCateA, String strSelCateB, String strSelCateC, Locale locale) throws Exception {
		StringBuilder strHTML = new StringBuilder();
		
		strHTML.append("<Select name=\"c_cate_a\">");
		strHTML.append("<Option Value=\"0\">" + egovMessageSource.getMessage("ezCommunity.t80", locale) + "</Option>");
		strHTML.append(ezCommunityService.getCategoryValueA(strSelCateA, locale));
		strHTML.append("</Select>");
		strHTML.append("<Select name=\"c_cate_b\" class=\"text\">");
		strHTML.append("<Option Value=\"0\">" + egovMessageSource.getMessage("ezCommunity.t81", locale) + "</Option>");
		strHTML.append(ezCommunityService.getCategoryValueB(strSelCateB, locale));
		strHTML.append("</Select>");
		strHTML.append("<Select name=\"c_cate_c\" class=\"text\" style='display:none'>");
		strHTML.append("<Option Value=\"0\">" + egovMessageSource.getMessage("ezCommunity.t82", locale) + "</Option>");
		strHTML.append(ezCommunityService.getCategoryValueC(strSelCateC, locale));
		strHTML.append("</Select>");
		
		return strHTML.toString();
	}

	/** 관리자권한확인 실행 함수*/
	public String checkIfBoardGroupAdmin(String pRootBoardID, String id, String deptID, String companyID) throws Exception {
		if (Integer.parseInt(ezCommunityService.brdCheckIfBoardGroupAdmin(pRootBoardID, id, deptID, companyID)) > 0) {
			return "OK";
		} else {
			return "NO";
		}
	}
	
	/** 게시판 Tree 호출 함수*/
	public String getBoardTree(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String strLang) throws Exception {
		int count = 0;
        String strForbiddenBoardIDList = "";
		StringBuilder result;
		List<CommunityBoardTreeVO> boardTreeList;
		List<CommunityBoardTreeVO> brdBoardTreeList = new ArrayList<CommunityBoardTreeVO>();
		
        String retValue = ezCommunityService.getBoardTreeGet1(pRootBoardID, pUserID, pDeptID, pCompanyID, pMode ,pSubFlag ,pSelectBy ,pExcludeBoardID, pClubNo, strLang);
        
        if (retValue != null && retValue.length() > 30) {
    		return retValue;
        }
        
        String pAccessID = pUserID + "," + ezOrganService.getDeptFullPath(pDeptID) + ",EVERYONE";
        String strRollInfo = ezOrganService.getPropertyValue(pUserID, "extensionattribute1");        
        
        for (int i = 0; i < pAccessID.split(",").length; i++) {
        	
        	boardTreeList = ezCommunityService.getBoardTreeGet2(pAccessID.split(",")[i].trim());
        	brdBoardTreeList = ezCommunityService.brdBoardTree(pRootBoardID, pAccessID.split(",")[i].trim(), "", "", pMode, pSelectBy, pExcludeBoardID, pClubNo);
        	
			if (boardTreeList.size() > 0) {
				for (int r = 0; r < boardTreeList.size(); r++) {
					strForbiddenBoardIDList += boardTreeList.get(r).getBoardID().split(",")[0].trim()+";";
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
        		result.append("<VALUE><![CDATA[" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName()) + "]]></VALUE>");
        	} else {
        		result.append("<VALUE><![CDATA[" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName2()) + "]]></VALUE>");
        	}        	
        	
            result.append("<STYLE><![CDATA[]]></STYLE>");
            result.append("<DATA1>" + brdBoardTreeList.get(i).getBoardID() + "</DATA1>");
            
            if (strLang.equals("")) {
            	result.append("<DATA2><![CDATA[" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName()) + "]]></DATA2>");
            } else {
            	result.append("<DATA2><![CDATA[" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName2()) + "]]></DATA2>");
            }
            
            result.append("<DATA3>" + pRootBoardID + "</DATA3>");
            result.append("<DATA4>" + brdBoardTreeList.get(i).getBoardColor() + "</DATA4>");
            result.append("<DATA5>" + brdBoardTreeList.get(i).getC_ClubNo() + "</DATA4>");
            result.append("<DATA6>" + brdBoardTreeList.get(i).getGubun() + "</DATA5>");
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
        
        ezCommunityService.getBoardTreeSet(pRootBoardID, pUserID, pDeptID, pCompanyID, pMode, pSubFlag, pSelectBy, pExcludeBoardID, pClubNo, strLang, result.toString().replace("'", "''"));

        return result.toString();
	}
	
	/** 게시판 트리하위여부 표출 Method*/
	public String checkIfLeafBoard(String pBoardID) throws Exception {
		if (ezCommunityService.checkIfLeafBoardGet(pBoardID) > 0) {
			return "FALSE";
		} else {
			return "TRUE";
		}
	}
}
