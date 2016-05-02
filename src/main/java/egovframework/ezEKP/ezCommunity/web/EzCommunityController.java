package egovframework.ezEKP.ezCommunity.web;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommon.web.EzCommonController;
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
public class EzCommunityController extends EgovFileMngUtil{
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
	
	@Autowired
	private EzCommonController ezCommonController;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovFileMngUtil.class);
	
	@RequestMapping(value="/ezCommunity/communityMain.do")
	public String  main() {
		
		return "/ezCommunity/communityMain";
	}
	
	/**
	 * 왼쪽 메뉴화면 호출 함수
	 */
	@RequestMapping(value = "/ezCommunity/communityLeftCommunity.do")
	public String communityLeftCommunity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap model) throws Exception {
		String code = "", codeName = "", userLevel = "";
		int newMemberConfirmtype = 0;
		//TODO 사용하지않음 
/*		String pRootBoardID = "top";
		String pSubFlag = "0";
		int pSelectBy = 0;
		String pExcludeBoardID = "";
		Document xmlret;
        Document xmlcop;*/
        boolean checkSysop = false;
        //TODO 사용하는곳이 없음
//        boolean	joinFlag = false;
        
        
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
        
        String userInfoUserID = loginVO.getId();
        String userID = loginVO.getId();
        
        if (code.equals("")) {
        	String vPermit = ezCommunityService.leftCommunityGet1(code, userInfoUserID);
        	
        	if (vPermit==null) {
        		userLevel = "0";
        	} else {
        		userLevel = vPermit;
//        		joinFlag = true;
        	}
        	
        	String clubConfirmType = ezCommunityService.leftCommunityGet2(code);
        	
        	if (clubConfirmType != null) {
        		newMemberConfirmtype = Integer.parseInt(clubConfirmType);
        	}
        	
        	//TODO 2016-04-26 이효진 사용하는 곳이 아직 없어서 주석처리
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

        //TODO 2016-04-26 이효진 사용하는 곳이 아직 없어서 주석처리
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

	/**
	 * 커뮤니티목록 호출 함수
	 */
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
	
	/**
	 * 알림마당목록 호출 함수
	 */
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
	
	/**
	 * 커뮤니티 로고 출력 함수
	 */
	@RequestMapping(value="/ezCommunity/getCommunityThumInfo.do")
	public void getCommunityThumInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		String pType = "5";
		String pBoardID = "";
		//TODO 왼쪽화면 호출시에는 사용안함
		/*String pItemID = "";
		String pQstNo = "";
        String pAnsNo = "";
        String pAttID = "";*/
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

	/**
	 * 커뮤니티만들기 화면 호출 함수
	 */
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
	
	/**
	 * SubBoards 호출 함수
	 */
	//TODO 2016-04-26 이효진 View에서 if문 돌아서 호출 ,호출되는 경우가 없는 것 같다.
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
	
	/**
	 * 관리자권한 확인 함수
	 */
	@RequestMapping(value = "/ezCommunity/goAdminOk.do")
	public String goAdminOk(@RequestBody String data, HttpServletRequest request, CommunityClubVO communityClubVO) throws Exception {
		String pClubID = "";
		StringBuilder aspXML = new StringBuilder(), masterXML = new StringBuilder(), isinXML = new StringBuilder(), resultXML = new StringBuilder();
		
		Document xmlDom = commonUtil.convertStringToDocument(data);
		pClubID = xmlDom.getChildNodes().item(0).getTextContent();
		
		//TODO 2016-04-26 이효진  사용하지 않는 Table을 참조해서 Null반환
		List<String> userIDList = ezCommunityService.goAdminOkGet1();
		aspXML.append("<ASP>");
		
		for (String userID : userIDList) {
			aspXML.append("<VALUE>");
			aspXML.append(userID.trim());
			aspXML.append("</VALUE>");
		}
		aspXML.append("<ASP>");
		
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
		resultXML.append("<SITE><VALUE></VALUE></SITE>");
		resultXML.append(masterXML.toString());
		resultXML.append(isinXML.toString());
		resultXML.append("</COMMUNITY>");

		return resultXML.toString();
	}
	
	/**
	 * 
	 */
	//TODO 2016-04-26 이효진 주석처리된부분 검토 후 삭제필요
	@RequestMapping(value = "/ezCommunity/checkCommHome.do")
	public String checkCommHome(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, ModelMap model) throws Exception {
		String codeName = "", userLevel = "";
		//TODO 사용하는곳 없음
		/*int newMemberConfirmtype = 0;
		String pRootBoardID = "top";
		String pSubFlag = "0";
		int pSelectBy = 0;
		String pExcludeBoardID = "";
        boolean checkSysop = false;
        Document xmlret;*/
//        boolean joinFlag = false;
        
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		String userInfoUserID = loginVO.getId();
		
		String code = request.getParameter("communityCD");
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
//        		joinFlag = true;
        	}
        	
        	//TODO 2016-04-26 이효진 사용하는 곳이 아직 없어서 주석처리
        	/*String clubConfirmType = ezCommunityService.leftCommunityGet2(code);
        	
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
	
	/**
	 * 알림마당 목록화면 호출 함수
	 */
	@RequestMapping(value = "/ezCommunity/board/bbsList.do")
	public String bbsList(@CookieValue("loginCookie")String loginCookie, Locale locale, HttpServletRequest request, ModelMap model) throws Exception {
		String bName = "c_Board", sRadio = "", type = "", userLevel = "", code = "", keyword = "";
		String pKeyword = "", titleName = "";
		int curPage = 0, totalPage = 0, nowBlock = 0, myChoice = 0 , keywordCount = 0;
		int prevPage = 0, nextPage = 0 , totalBlock = 0, goPage = 0;
		int comNoPerPage = 17;
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		bName = request.getParameter("bName").toLowerCase();
		
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
			pKeyword = URLDecoder.decode(keyword, "UTF-8");
		}
		if (request.getParameter("goToPage") != null) {
			curPage = Integer.parseInt(request.getParameter("goToPage"));
		}
		if (request.getParameter("block") != null && !request.getParameter("block").equals("")) {
			nowBlock = Integer.parseInt(request.getParameter("block"));
		}
		
		if (!code.equals("")) {
			titleName = ezCommunityService.getBoardTitleName(bName, code);
		}
		
		System.out.println(keyword);
		System.out.println(pKeyword);

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
//		String pURL = "";
		
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
			
			String nowDate = EgovDateUtil.getTodayTime();
			nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");

			if (cBoard.getWriteDay().compareTo(nowDate.substring(0, 8) + nowDate.substring(8,13)) >= 0) {
				strHTML.append("<img src=\"/images/i_new.gif\" alt border=\"0\">");
			}
			
			strHTML.append(commonUtil.cleanValue(cBoard.getTitle().trim())+"</nobr></td>");
			
			if (commonUtil.getMultiData(loginVO.getLang()).equals("")) {
				strHTML.append("<td class=\"t1\" width=\"70px\" >" + cBoard.getUserName().trim() + "</td>");
			} else {
				strHTML.append("<td class=\"t1\" width=\"70px\" >" + cBoard.getUserName2().trim() + "</td>");
			}
			
			strHTML.append("<td class=\"t1\" width=\"90px\" >" + cBoard.getWriteDay().substring(0, 10) + "</td>");
			String localPdsPath = ""; 
			
			if (iColSpan == 6) {
				//TODO 2016-04-26 이효진 사용하는 곳이 아직 없어서 주석처리
//				String file = cBoard.getCharFileName();
				
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

		model.addAttribute("idSpanVal", strHTML.toString());
		model.addAttribute("keyword", keyword);
		model.addAttribute("curPage", curPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("keywordCount", keywordCount);
		model.addAttribute("titleName", titleName);
		model.addAttribute("bName", bName);
		model.addAttribute("block", nowBlock);
		model.addAttribute("rollInfo", loginVO.getRollInfo());
		model.addAttribute("code", code);
		
		return "/ezCommunity/board/bbsList";
	}
	
	/**
	 * 알림마당 읽기 화면 호출 함수
	 */
	@RequestMapping(value = "/ezCommunity/board/bbsViewNew.do")
	public String bbsNewViewNew(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		String keyword = "", sRadio = "", pagec = "1";
		String strTitle = "", strWriteName = "", strWriterID = "";
		int myStep = 0, myLevel = 0, grsRef = 0, readNo = 0, grsNo = 0;	
		String previousItemID = "", nextItemID = "";
		String strWriteDate = "";
		int nowBlock = 0;
	
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		String bName = request.getParameter("bName").toLowerCase();
		String mode = request.getParameter("mode");
		String no = request.getParameter("no");
		
		if (request.getParameter("keyword") != null) {
			keyword = request.getParameter("keyword");
		}
		if (request.getParameter("sRadio") != null) {
			sRadio = request.getParameter("sRadio");
		}
		if (request.getParameter("block") != null && !request.getParameter("block").equals("")) {
			nowBlock = Integer.parseInt(request.getParameter("block"));
		}
		if (request.getParameter("pagec") != null) {
			pagec = request.getParameter("pagec");
		}
		
		int adminCheck = ezCommunityService.bbsAdminCheck(loginVO.getId(), loginVO.getRollInfo());
		String fileName = ezCommunityService.bbsEditGet1(bName, no);
		CommunityCBoardVO cBoardGet1 = ezCommunityService.bbsViewNewGet1(bName, no);
		
		if (cBoardGet1 != null) {
			strTitle = cBoardGet1.getTitle().trim().replaceAll("&quot;", "'").replaceAll("&dquot;", "\"");
			
			if (!bName.equals("c_clubnotice") && !bName.equals("c_notice")) {
				myStep = cBoardGet1.getStep();
				myLevel = cBoardGet1.getRe_Level();
				grsRef = cBoardGet1.getRef(); 
			}
			
			readNo = cBoardGet1.getReadNum();
			strWriteDate = cBoardGet1.getWriteDay().trim();
			
			if (commonUtil.getMultiData(loginVO.getLang()).equals("2")) {
				strWriteName = cBoardGet1.getUserName2();
			} else {
				strWriteName = cBoardGet1.getUserName();
			}
			
			strWriterID = cBoardGet1.getId().toLowerCase().trim();
			grsNo = cBoardGet1.getNo();
			
		} else {
			response.encodeRedirectURL("/error.do");
		}
		
		String previousTitle = egovMessageSource.getMessage("ezCommunity.t191");
		String nextTitle = egovMessageSource.getMessage("ezCommunity.t193");
		
		List<CommunityCBoardVO> cBoardList = ezCommunityService.bbsViewNewGet2(bName);
		
		for (int i = 0; i < cBoardList.size(); i++) {
			if (cBoardList.get(i).getNo() == grsNo) {
				if (i >= 1) {
					previousItemID = Integer.toString(cBoardList.get(i-1).getNo());
					previousTitle = cBoardList.get(i-1).getTitle();
				}
			}
		}
		
		for (int i = 0; i < cBoardList.size(); i++) {
			if (cBoardList.get(i).getNo() == grsNo) {
				if (i < cBoardList.size()-1) {
					nextItemID = Integer.toString(cBoardList.get(i+1).getNo());
					nextTitle = cBoardList.get(i+1).getTitle();
				}
			}
		}

		//TODO 2016-04-27 이효진 EZSP_BBS_VIEW_NEW_GET3사용하는 곳 없어서 미구현 
        
		model.addAttribute("bName", bName);
		model.addAttribute("mode", mode);
		model.addAttribute("no", no);
		model.addAttribute("nowBlock", nowBlock);
		model.addAttribute("strTitle", strTitle);
		model.addAttribute("myStep", myStep);
		model.addAttribute("myLevel", myLevel);
		model.addAttribute("grsRef", grsRef);
		model.addAttribute("readNo", readNo);
		model.addAttribute("grsNo", grsNo);
		model.addAttribute("pagec", pagec);		
		model.addAttribute("strWriteDate", strWriteDate);
		model.addAttribute("strWriteName", strWriteName);
		model.addAttribute("strWriterID", strWriterID);
		model.addAttribute("previousTitle", previousTitle);
		model.addAttribute("nextTitle", nextTitle);
		model.addAttribute("nextItemID", nextItemID);
		model.addAttribute("previousItemID", previousItemID);
		model.addAttribute("userInfo", loginVO);
		
		
		return "/ezCommunity/board/bbsViewNew";
	}
	
	/**
	 * 알림마당 쓰기/수정 화면 호출 함수 
	 */
	@RequestMapping(value = "/ezCommunity/board/bbsEditNew.do")
	public String bbsEditNew(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception{
		String code = "", sRadio = "", keyword = "", cID = "", no = "", fileName = "", title = "", grsUserName = "", attachFiles = "", writeFakerName = "";
		int pagec = 0, block = 0;
		String step = "", level = "", ref = "";
		
		LoginVO loginVO = commonUtil.userInfo(loginCookie);

		String mode = request.getParameter("mode");
		String bName = request.getParameter("bName");
		
		if (request.getParameter("code") != null) {
			code = request.getParameter("code");
		}
		
		if (mode.equals("edit")) {
			sRadio = request.getParameter("sRadio");
			keyword = request.getParameter("keyword");
			no = request.getParameter("no");
			pagec = Integer.parseInt(request.getParameter("pagec"));
			block = Integer.parseInt(request.getParameter("block"));
		} else {
			step = request.getParameter("step");
			level = request.getParameter("level");
			ref = request.getParameter("ref");
			
			if (request.getParameter("no") != null) {
				no = request.getParameter("no");
			}
			if (request.getParameter("pagec") != null) {
				pagec = Integer.parseInt(request.getParameter("pagec"));
			}
		}
		
		//TODO 2016-04-27 이효진 사용하는곳 없음
		/*if (!code.equals("")){
			String titleName = ezCommunityService.getBoardTitleName(bName, code);
		}
		
		int adminCheck = ezCommunityService.bbsAdminCheck(loginVO.getId(), loginVO.getRollInfo());*/
		String serverName = request.getServerName();
		CommunityCBoardVO cBoardVO = null;
		
		if (!no.equals("")) { //  수정(mode :  "edit")  또는 답변(mode :  "write")
			//TODO 2016-0427 이효진 VO에 담아서 던지는게 더 효율적일것같음
			fileName = ezCommunityService.bbsEditGet1(bName, no);
			cBoardVO = ezCommunityService.bbsEditNew(bName, no, commonUtil.getMultiData(loginVO.getLang()));
			
			 if (!no.equals("")) { // 수정(mode : "edit") 답변 (mode : "write")
				 if (loginVO.getLang().equals("2")) {
					 grsUserName = loginVO.getDisplayName2();
				 } else {
					 grsUserName = loginVO.getDisplayName1();
				 }
			 } else {
				 if (commonUtil.getMultiData(loginVO.getLang()).equals("2")) {
					 grsUserName = cBoardVO.getUserName2();
				 } else {
					 grsUserName = cBoardVO.getUserName();
				 }
			 }
			 
			 if (commonUtil.getMultiData(loginVO.getLang()).equals("2")) {
				 writeFakerName = cBoardVO.getUserName2();
			 } else {
				 writeFakerName = cBoardVO.getUserName();
			 }
		} else { // 쓰기(mode :  "write")
			if (loginVO.getLang().equals("2")) {
				grsUserName = loginVO.getDisplayName2();
			} else {
				grsUserName = loginVO.getDisplayName1();
			}
		}
		
		model.addAttribute("mode", mode);
		model.addAttribute("no", no);
		model.addAttribute("pagec", pagec);
		model.addAttribute("sRadio", sRadio);
		model.addAttribute("keyword", keyword);
		model.addAttribute("block", block);
		model.addAttribute("code", code);
		model.addAttribute("bName", bName);
		model.addAttribute("grsUserName", grsUserName);
		model.addAttribute("writerFakerName", writeFakerName);
		model.addAttribute("fileName", fileName);
		model.addAttribute("userInfoUserNM1", loginVO.getDisplayName1());
		model.addAttribute("userInfoUserNM2", loginVO.getDisplayName2());
		model.addAttribute("userInfoUserID", loginVO.getId());
		model.addAttribute("serverName", serverName);
		model.addAttribute("cBoard", cBoardVO);
		model.addAttribute("step", step);
		model.addAttribute("level", level);
		model.addAttribute("gref", ref);
		
		return "/ezCommunity/board/bbsEditNew";
	}
	
	/**
	 * 알림마당 쓰기/수정 실행 함수 
	 */
	@RequestMapping(value = "/ezCommunity/bbsEditOk.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String bbsEditOk(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlData, HttpServletRequest request) throws Exception{
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(xmlData);		

		int myRef = 0, myStep = 0, myLevel = 0;
		String mode = doc.getElementsByTagName("Mode").item(0).getTextContent();
		String code = doc.getElementsByTagName("Code").item(0).getTextContent();
		String bName = doc.getElementsByTagName("Bname").item(0).getTextContent();
		String no = doc.getElementsByTagName("NO").item(0).getTextContent();
		String textContent = doc.getElementsByTagName("Textcontent").item(0).getTextContent();
		String MHTcontent = doc.getElementsByTagName("Content").item(0).getTextContent();
		String title = doc.getElementsByTagName("Title").item(0).getTextContent();
		String gant = doc.getElementsByTagName("Gant").item(0).getTextContent();
		String sRadio = doc.getElementsByTagName("Sradio").item(0).getTextContent();
		String keyword = doc.getElementsByTagName("Keyword").item(0).getTextContent();
		String id = doc.getElementsByTagName("ID").item(0).getTextContent();
		String goToPage = doc.getElementsByTagName("GoTopage").item(0).getTextContent();
		String block = doc.getElementsByTagName("Nowblock").item(0).getTextContent();
		String attachList = doc.getElementsByTagName("Attachlist").item(0).getTextContent();
		String userNm = doc.getElementsByTagName("UserNM").item(0).getTextContent();
		String userNm2 = doc.getElementsByTagName("UserNM2").item(0).getTextContent();
		String realPath = request.getServletContext().getRealPath("");

		if (doc.getElementsByTagName("Ref").item(0).getTextContent() != "") {
            myRef = Integer.parseInt(doc.getElementsByTagName("Ref").item(0).getTextContent());
		}
        if (doc.getElementsByTagName("Step").item(0).getTextContent() != "") {
            myStep = Integer.parseInt(doc.getElementsByTagName("Step").item(0).getTextContent());
        }
        if (doc.getElementsByTagName("Level").item(0).getTextContent() != "") {
            myLevel = Integer.parseInt(doc.getElementsByTagName("Level").item(0).getTextContent());
        }
		
        String maxIdFieldName = "c_no";
        
        InputStream is = null;
        OutputStream os = null;
        PrintWriter pw = null;

        if (mode.equals("edit")) {
        	CommunityCBoardVO cBoard = ezCommunityService.bbsEditOkGet1(bName, gant, code);
        	int adminCheck = ezCommunityService.bbsAdminCheck(loginVO.getId(), loginVO.getRollInfo());

        	if (cBoard != null) {
        		//TODO rollInfo에 t=1권한이 잇어야 자기 글을 삭제 할수 있으나 같은 계정의 글이라도 t=1이 없음
    			//if (cBoard.getId().trim().equals(loginVO.getId()) || adminCheck == 1 || loginVO.getRollInfo().indexOf("t=1") > 0) {
        		if (cBoard.getId().trim().equals(loginVO.getId()) || adminCheck == 1) {
	                ezCommunityService.bbsEditOkSet1(bName.toUpperCase(), title, gant, code, attachList, textContent);
	                String strPath = realPath + config.getProperty("upload_community.FILEDATA") + commonUtil.separator + ezCommunityService.getFileFolderName(bName) + commonUtil.separator + cBoard.getFileName().trim();
	                
	                try{
		    		    pw = new PrintWriter(new File(strPath));
			    		pw.print(MHTcontent);
			    		pw.flush();
			    		pw.close();
			    		
	                } catch (FileNotFoundException fnfe) {
	    				LOGGER.debug("fnfe: {}", fnfe);
	    			} catch (Exception e) {
	    				LOGGER.debug("e: {}", e);
	    			} finally {
	    			    if (os != null) {
	    					try {
	    					    os.close();
	    					} catch (Exception ignore) {
	    						LOGGER.debug("IGNORED: {}", ignore.getMessage());
	    					}
	    			    }
	    			    
	    			    if (is != null) {
	    					try {
	    					    is.close();
	    					} catch (Exception ignore) {
	    						LOGGER.debug("IGNORED: {}", ignore.getMessage());
	    					}
	    			    }
	                }
	        	}
        	}
        } else {
        	String fileName = "";
        	int newStep = 0, newLevel = 0;
        	int maxNum = 0, number = 0;
        	
        	String strMaxNum = ezCommunityService.bbsEditOkGet2(maxIdFieldName, bName, code);
        	
        	if (!strMaxNum.equals("")) {
        		fileName = ezCommunityService.bbsEditOkGet3(maxIdFieldName, bName, code, strMaxNum);
        		maxNum = Integer.parseInt(strMaxNum);
        	}
        	
        	number = maxNum + 1;
        	
        	if (no.equals("")) {
        		myRef = number;
        		newStep = 0;
        		newLevel = 0;
        	} else {
        		if (!bName.equals("c_clubnotice") && !bName.equals("c_notice")) {
        			ezCommunityService.bbsEditOkSet2(bName.toUpperCase(), myRef, myStep, code);
        		}
        		
        		newStep = myStep + 1;
        		newLevel = myLevel + 1;
        	}
        	
        	String dirPath = "";
        	String strPath = "";
        	
        	if (strMaxNum.equals("")){
                if (code == "") {
                    fileName = "0000000001.mht";
                } else {
                    fileName = "0000000001" + "(" + code + ").mht";
                }
                
                strPath = config.getProperty("upload_community.FILEDATA") + commonUtil.separator + ezCommunityService.getFileFolderName(bName) + commonUtil.separator +fileName;
            } else {
                int iName = Integer.parseInt(strMaxNum);
                iName = iName + 1;
                String strName = "000000000" + iName;
                strName = strName.substring(strName.length() - 10, strName.length());

                if (code != ""){
                    strName = strName + "(" + code + ")";
                }
                
                fileName = strName + ".mht";
                dirPath = realPath + config.getProperty("upload_community.FILEDATA") + commonUtil.separator + ezCommunityService.getFileFolderName(bName) + commonUtil.separator ;
                strPath = realPath + config.getProperty("upload_community.FILEDATA") + commonUtil.separator + ezCommunityService.getFileFolderName(bName) + commonUtil.separator + fileName;
            }

        	String nowDate = egovframework.rte.fdl.string.EgovDateUtil.getCurrentDateTimeAsString();
        	nowDate = EgovDateUtil.convertDate(nowDate, "", "", "");
        	
        	ezCommunityService.bbsEditOkInsert(bName.toUpperCase(), myRef, newStep, newLevel, attachList, number, textContent, nowDate, fileName, code, loginVO.getCompanyID(), loginVO.getId(), userNm, userNm2, title, maxIdFieldName);
        	
        	try{
        		File dir = new File(dirPath);
        		
        		if (!dir.exists()) {
        			dir.mkdirs();
        		}
        		
	    		pw = new PrintWriter(new File(strPath));
	    		pw.print(MHTcontent);
	    		pw.flush();
	    		pw.close();
            } catch (FileNotFoundException fnfe) {
 				LOGGER.debug("fnfe: {}", fnfe);
 			} catch (Exception e) {
 				LOGGER.debug("e: {}", e);
 			} finally {
 			    if (os != null) {
 					try {
 					    os.close();
 					} catch (Exception ignore) {
 						LOGGER.debug("IGNORED: {}", ignore.getMessage());
 					}
 			    }
 			    
 			    if (is != null) {
 					try {
 					    is.close();
 					} catch (Exception ignore) {
 						LOGGER.debug("IGNORED: {}", ignore.getMessage());
 					}
 			    }
             }
        }
		return "OK";
	}
	
	/**
	 * ckeditor 호출 함수
	 */
	@RequestMapping(value = "/ezCommunity/ckEditor.do")
	public String ckEditor(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception{
		String pMode = "";
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		if(request.getParameter("DraftFlag") != null){
			pMode = request.getParameter("DraftFlag");
		}

		model.addAttribute("userInfo",loginVO);
		model.addAttribute("pMode", pMode);
		
		return "/ezCommunity/board/CKEditor";
	}
	
	/**
	 * mht파일 read 실행 함수
	 */
	@RequestMapping(value = "/ezCommunity/getCommunityContentInfo.do", method = RequestMethod.POST, produces="text/plain; charset=UTF-8")
	@ResponseBody
	public String getCommunityContentInfo(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String type = request.getParameter("type");
		String itemID = request.getParameter("itemID");
		String realPath = request.getServletContext().getRealPath("");
		String uploadModule = config.getProperty("config.LocalPath");
		String strUrl = ezCommonService.getContentInfo(type, itemID);
		String filePath = "";
		String m_strMHT = "";

		if (type.equals("COMMUNITYNOTI")) {
			filePath = config.getProperty("upload_community.MAINBOARD") +commonUtil.separator; 
		} else {
			filePath = "";
		}

		try{
			m_strMHT = ezCommonController.loadMHTFile(realPath + filePath + strUrl);
		}catch(Exception e){
			m_strMHT = "";
		}
		
        String strHTML = ezCommonController.startMHT2HTML(realPath + uploadModule + commonUtil.separator, m_strMHT, realPath + uploadModule + commonUtil.separator);

        
        if (strHTML.trim().length() > 0) {
        	return strHTML;
        } else {
        	return "<HTML><HEAD><TITLE></TITLE><META content=\"text/html; charset=utf-8\" http-equiv=Content-Type><META name=GENERATOR content=\"MSHTML 8.00.7601.17622\"></HEAD><STYLE title=ezform_style_1>P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm; *font-size:x-small; } </STYLE><BODY></BODY></HTML>";
        }
	}
	
	/**
	 * 알림마당 Delete 실행 함수
	 */
	@RequestMapping(value = "/ezCommunity/bbsDelOk.do", method = RequestMethod.POST, produces = "text/xml; charset=UTF-8")
	@ResponseBody
	public String bbsDelOk(@CookieValue("loginCookie")String loginCookie,@RequestBody String data, CommunityCBoardVO board, HttpServletRequest request) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);
		
		String itemNo = doc.getElementsByTagName("ItemNo").item(0).getTextContent();
		String goToPage = doc.getElementsByTagName("GoToPage").item(0).getTextContent();
		String bName = doc.getElementsByTagName("Bname").item(0).getTextContent();
		String code = "";
		String fileName = "", folder = "", strFile = "";
		
		int adminCheck = ezCommunityService.bbsAdminCheck(userInfo.getId(), userInfo.getRollInfo());
		//EZSP_BBS_DEL_OK_GET
		board = ezCommunityService.bbsDelOkGet(bName, itemNo, code);
		
		if (board.getId().trim().equals(userInfo.getId()) || adminCheck == 1 || userInfo.getRollInfo().indexOf("t=1") > -1 || userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
			fileName = board.getFileName();
			
			if (fileName != null) {
				folder = request.getServletContext().getRealPath("") + config.getProperty("upload_community.FILEDATA") + commonUtil.separator + ezCommunityService.getFileFolderName(bName) + commonUtil.separator;
				strFile = folder + fileName;
				File file = new File(strFile);
				
				if (file.exists()) {
					file.delete();
				}
			}
			
			if (bName.equals("c_clubpds") || bName.equals("c_clubpds1")) {
				String attachList = "";
				if (board.getCharFileName() != null) {
					attachList = board.getCharFileName();
					String[] strAttachFile = attachList.split(";");
					folder = request.getServletContext().getRealPath("") + config.getProperty("upload_community.FILEDATA") + commonUtil.separator + ezCommunityService.getFileFolderName(bName) + commonUtil.separator;
					
					for (int i = 0; i <= strAttachFile.length; i++) {
						strFile = folder + strAttachFile[i];
						File file = new File(strFile);
						
						if (file.exists()) {
							file.delete();
						}
					}
				}
			}
			
			ezCommunityService.bbsDelOkDel(bName, itemNo, code);
			
			return "OK";
		}
		return "ERROR";
	}
	
	/**
	 * 카테고리목록 호출 함수
	 */
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

	
	/**
	 * 관리자권한확인 실행 함수
	 */
	public String checkIfBoardGroupAdmin(String pRootBoardID, String id, String deptID, String companyID) throws Exception {
		if (Integer.parseInt(ezCommunityService.brdCheckIfBoardGroupAdmin(pRootBoardID, id, deptID, companyID)) > 0) {
			return "OK";
		} else {
			return "NO";
		}
	}
	
	/**
	 * 게시판 Tree 호출 함수
	 */
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
	
	/**
	 * 게시판 트리하위여부 표출 Method
	 */
	public String checkIfLeafBoard(String pBoardID) throws Exception {
		if (ezCommunityService.checkIfLeafBoardGet(pBoardID) > 0) {
			return "FALSE";
		} else {
			return "TRUE";
		}
	}
}
