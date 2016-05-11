package egovframework.ezEKP.ezCommunity.web;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommon.web.EzCommonController;
import egovframework.ezEKP.ezCommunity.service.EzCommunityService;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardInfoVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardListVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardPropertyVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityLeftCommunityVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
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
	
	@Autowired
	private Properties globals;
	
	@Resource(name="EzCommunityService")
	private EzCommunityService ezCommunityService;
	
	@Resource(name="EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name="EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
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
	 * 커뮤니티 로고 출력 함수(ezCommon_Interface)
	 */
	@RequestMapping(value="/ezCommunity/getCommunityThumInfo.do")
	public void getCommunityThumInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String pType = request.getParameter("type");
		String pFileName = request.getParameter("fileName");
		String pFilePath = "", pBoardID = "";
		
		if (request.getParameter("boardID") != null) {
			pBoardID = request.getParameter("boardID");
		}

		if (pType.toUpperCase().equals("COMMUNITYLOGO")) {
			pFilePath = ezCommunityService.getCommunityThumInfo(pBoardID, pFileName, "LOGO");
			
	        if (pFilePath != null && pFilePath != "") {
	            ezCommonService.responseAttach(pFilePath, pFileName, true, request, response);
	        }
		}
		
		if (pType.toUpperCase().equals("COMMUNITYTHUM")) {
			pFilePath = ezCommunityService.getCommunityThumInfo(pBoardID, pFileName, "COMMUNITYTHUM");
	        if (pFilePath != null && pFilePath != "") {
	            ezCommonService.responseAttach(pFilePath, pFileName, true, request, response);
	        }
		}
	}

	/**
	 * 커뮤니티만들기 화면 호출 함수
	 */
	@RequestMapping(value = "/ezCommunity/commMake.do")
	public String commMake(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		String userInfoUserID = "", userInfoDisplayName = "";
		String langPrimary="", langSecondary="";
		//TODO 2016-05-02 이효진 사용하는곳 없음
//		String flag = "";
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		//TODO 2016-05-02 이효진 사용하는곳 없음		
//		if (request.getParameter("flag") != null) {
//			flag = request.getParameter("flag");
//		}
		
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
//		model.addAttribute("flag", flag);		
		model.addAttribute("idSpanValue", ezCommunityService.getCategory("", "", ""));
		
		return "/ezCommunity/communityCommMake";
	}
	
	/**
	 * 커뮤니티만들기 싱청 함수
	 */
	@RequestMapping(value = "/ezCommunity/commMakeOk.do", method = RequestMethod.POST)
	@ResponseBody
	public void commMakeOk(@CookieValue("loginCookie")String loginCookie, Locale locale, CommunityClubVO clubVO, ModelMap model, MultipartHttpServletRequest request, HttpServletResponse response) throws Exception {
		String clubName2 = "";
		MultipartFile cClubLogo = null, cClubBanner = null;
		String cCateA = "", cCateB = "", cCateC = "";
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		//TODO 2016-05-03 이효진 사용하지 않음
//		String makeID = request.getParameter("makeID");
		String clubName = request.getParameter("hiddenClubName");
		String clubType = request.getParameter("clubType");
		String clubConfirmType = request.getParameter("clubConfirmType");
		String intro = request.getParameter("intro");
		String pNewID = request.getParameter("sNewID");
		String pNewSubID = request.getParameter("sNewSubID");
		String logoPath = request.getServletContext().getRealPath("") + config.getProperty("upload_community.LOGO") + commonUtil.separator;
		String logo = "default_logo_type1.jpg";
		String banner = "default_banner.jpg";
		int isIn = 0, boardNo = 0;
		
		if (request.getParameter("hiddenClubName2") != null) {
			clubName2 = request.getParameter("hiddenClubName2");
		}
		if (request.getParameter("cCateA") != null) {
			cCateA = request.getParameter("cCateA");
		}
		if (request.getParameter("cCateB") != null) {
			cCateB = request.getParameter("cCateB");
		}
		if (request.getParameter("cCateC") != null) {
			cCateC = request.getParameter("cCateC");
		}
		if (request.getFile("logo") != null) {
			cClubLogo = request.getFile("logo");
		}
		if (request.getFile("banner") != null) {
			cClubBanner = request.getFile("banner");
		}
		if (request.getParameter("isIn") != null) {
			isIn = Integer.parseInt(request.getParameter("isIn"));
		}
		if (clubName2.equals("")) {
			clubName2 = clubName;
		}
		
		String[] bBoardName = egovMessageSource.getMessage("ezCommunity.t1492", locale).split(";");
		String[] bNotiName = egovMessageSource.getMessage("ezCommunity.t1493", locale).split(";");
		//10MB 제한
		String comatt = "10";
		
		if(cCateA.equals("")) {
			cCateA = "0";
		}
		if(cCateB.equals("")) {
			cCateB = "0";
		}
		if(cCateC.equals("")) {
			cCateC = "0";
		}
		
		clubVO = ezCommunityService.commMakeOkGet1(clubName, cCateA, cCateB, cCateC, commonUtil.getMultiData(userInfo.getLang()));

		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		if (clubVO != null) {
			response.getWriter().write("<script language='javascript'>");
			response.getWriter().write("alert('" + egovMessageSource.getMessage("ezCommunity.t1029", locale) + "');");
			response.getWriter().write("history.back();");			
			response.getWriter().write("</script>");
			response.getWriter().flush();
			
			return;
		}
		
		boardNo = ezCommunityService.commMakeOkGet2();
		boardNo += 1;
		
		//TODO CLUBID COUNT가 0 이면 ID로 0 삽입
		if (ezCommunityService.commMakeOkGet4() == 0) {
			ezCommunityService.commMakeOkInsert1();
		}
		
		int clubNo = 0;
		clubNo = Integer.parseInt(ezCommunityService.commMakeOkGet3().trim());
		clubNo ++ ;
		
		String code = "C_"+clubNo;
		int openEmail = 1;
		int openHp = 1;
		int openComp = 1;
		int openHouse = 1;
		int openJob = 1;
		int openSex = 1;
		int openBirth = 0;
		
		ezCommunityService.commMakeOkInsert2(clubNo, EgovDateUtil.getTodayTime(), clubName, clubName2, cCateA, cCateB, cCateC, clubType, clubConfirmType, intro, isIn, logo, banner, bBoardName[1].trim(), bBoardName[2].trim(), comatt, code, bNotiName[1].trim(), bNotiName[2].trim(), pNewID, boardNo, userInfo.getId(), userInfo.getDisplayName1(), userInfo.getCompanyName1(), userInfo.getDeptName1(), pNewSubID, openEmail, openHp, openComp, openHouse, openJob, openBirth, openSex, userInfo.getCompanyID());
		
		//TODO 2016-05-03 이효진 Email부분 
/*		ezCommunityService.commMakeOkGet5()
		OracleConnection conn2 = new OracleConnection(GetSystemConfigValue("ezCommunityOra"));
                OracleCommand comm2 = new OracleCommand("EZSP_COMM_MAKE_OK_GET5", conn2);
                comm2.CommandType = CommandType.StoredProcedure;
                comm2.Parameters.Add("cv_1", OracleType.Cursor).Direction = ParameterDirection.Output;
                conn2.Open();
                OracleDataReader EMailRS = comm2.ExecuteReader();

                string mailSendServer = "\"" + userinfo.DisplayName + "\" <" + userinfo.Email + ">";
                while (EMailRS.Read())
                {
                    if (EMailRS["UserMail"].ToString() != "")
                    {
                        string CommunityUser = "\"" + EMailRS["UserName"].ToString() + "\" <" + EMailRS["UserMail"].ToString() + ">";

                        string strMailXML = "<DATA>";
                        strMailXML += "<FROM><![CDATA[" + mailSendServer + "]]></FROM>";
                        strMailXML += "<TO><![CDATA[" + CommunityUser + "]]></TO>";
                        strMailXML += "<CC></CC>";
                        strMailXML += "<BCC></BCC>";
                        strMailXML += "<SUBJECT><![CDATA[[Community] " + RM.GetString("t1031") + "></SUBJECT>";
                        if (userinfo.primary == "1")
                        {
                            strMailXML += "<BODY><![CDATA[" + userinfo.DisplayName + RM.GetString("t1032") + clubname + "]" + RM.GetString("t1033") + "></BODY>";
                        }
                        else
                        {
                            strMailXML += "<BODY><![CDATA[" + userinfo.DisplayName + RM.GetString("t1032") + clubname2 + "]" + RM.GetString("t1033") + "></BODY>";
                        }

                        strMailXML += "</DATA>";

                        string WebServerName = Server.MachineName;
                        string url = Request.Url.Scheme + "://" + WebServerName + "/myoffice/ezEmail/remote/mail_send_noti.aspx";

                        string[] HeaderOption = new string[10];
                        HeaderOption[0] = "Authorization\n" + Request.ServerVariables["HTTP_AUTHORIZATION"];
                        HeaderOption[1] = "Content-Type\ntext/xml; charset=utf-8";
                        HeaderOption[2] = "Accept-Language\nutf-8";

                        string rtnStatus = "";
                        Stream ResponseStream = null;
                        long StreamSize = 0;

                        if (ExecuteWebURL("POST", url, strMailXML, HeaderOption, ref rtnStatus, ref ResponseStream, ref StreamSize))
                        {
                            if (ResponseStream != null) { ResponseStream.Close(); }
                            if (ResponseStream != null) { ResponseStream = null; }
                        }
                    }
                }*/
		
		if (ezCommunityService.commMakeOkGet6(userInfo.getCompanyID(), userInfo.getId()) == null) {
			String companyID = userInfo.getCompanyID();
			String userID = userInfo.getId();
			String userName = userInfo.getDisplayName1();
			String userName2 = userInfo.getDisplayName2();
			String companyName = userInfo.getCompanyName1();
			String companyName2 = userInfo.getCompanyName2();
			String companyZip = ""; //회사 우편번호
			String companyAddress = ""; //회사 주소
			String deptName = userInfo.getDeptName1();
			String deptName2 = userInfo.getDeptName2();
			String companyTel = "";
			String companyFax = "";
			String homeTel = "";
			String handPhone = "";
			String eMail = userInfo.getEmail();
			String birthDay = "";
			String gender = "";
			
			if (userName2.equals("")) {
				userName2 = userName;
			}
			if (companyName2.equals("")) {
				companyName2 = companyName;
			}
			if (deptName2.equals("")) {
				deptName2 = deptName;
			}
			
			ezCommunityService.joinOkInsert(companyID, userID, userName, companyName, companyName2, companyZip, companyAddress, deptName, deptName2, companyTel, companyFax, homeTel, handPhone, eMail, birthDay, gender);
		}
		
		String fileName = "", attachFile = "", onlyFileName = "", extName = "";
		int fileSize = 0, iStart = 0;
		
		if (!cClubLogo.isEmpty()) {
			fileName = code;
			attachFile = cClubLogo.getOriginalFilename();
			fileSize = (int) cClubLogo.getSize();
			iStart = attachFile.lastIndexOf("\\");
			onlyFileName = attachFile.substring(iStart);
			iStart = onlyFileName.lastIndexOf(".");
			extName = onlyFileName.substring(iStart);
			//원본파일 생성
			File file = new File(logoPath + fileName + "_logo" + "." + extName);
			cClubLogo.transferTo(file);
			
			
			BufferedImage inputImage = ImageIO.read(file);
			BufferedImage outputImage = null;
			Graphics2D saveImage = null;
			//로고파일 생성			
			outputImage= new BufferedImage(894, 100, BufferedImage.TYPE_INT_RGB);
			saveImage = outputImage.createGraphics();
			saveImage.drawImage(inputImage, 0, 0, 894, 100, null);
			
			File newLogo = new File(logoPath + fileName + "_logo" + ".png");
			ImageIO.write(outputImage, "png", newLogo);
			//썸네일파일 생성
			outputImage = new BufferedImage(198, 140, BufferedImage.TYPE_INT_RGB);
			saveImage = outputImage.createGraphics();
			saveImage.drawImage(inputImage, 0, 0, 198, 140, null);
			
			File newThumbnail = new File(logoPath + fileName + "_thumbnail" + ".png");
			ImageIO.write(outputImage, "png", newThumbnail);
			
			file.delete();
			
			ezCommunityService.commMakeOkSet1(fileName + "_logo" + ".png", fileName + "_thumbnail" + ".png", fileName, fileSize);
		}
		
		//배너파일 생성
		//TODO 2016-05-03 이효진 뷰에서 banner을 사용하지 않아서 파라미터로 받지 않는다.
		if (!cClubBanner.isEmpty()) {
			fileName = code;
			attachFile = cClubBanner.getOriginalFilename();
			fileSize = (int) cClubBanner.getSize();
			iStart = attachFile.lastIndexOf("\\");
			onlyFileName = attachFile.substring(iStart);
			iStart = onlyFileName.lastIndexOf(".");
			extName = onlyFileName.substring(iStart);
			
			File file = new File(logoPath + fileName + "_banner" + "." + extName);
			cClubBanner.transferTo(file);
			
			ezCommunityService.commMakeOkSet2(fileName + "_banner" + "." + extName, fileName, fileSize);
		}
		
		if (clubVO == null) {
			response.getWriter().write("<script language='javascript'>\n");
			response.getWriter().write("alert('Community" + egovMessageSource.getMessage("ezCommunity.t1027", locale) + "');\n");
			response.getWriter().write("document.location.href = '/ezCommunity/commMake.do?flag=1';\n");
			response.getWriter().write("</script>");
			response.getWriter().flush();
		}
	}
	/**
	 * SubBoards 호출 함수
	 */
	//TODO 2016-04-26 이효진 View에서 if문 돌아서 호출 ,호출되는 경우가 없는 것 같다.
	@RequestMapping(value = "/ezCommunity/getSubBoards.do", method = RequestMethod.POST, produces = "TEXT/XML;CHARSET=UTF-8")
	@ResponseBody
	public String getSubBoards(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request) throws Exception {
		String pClubID = "", pRootBoardID = "", pSubFlag = "", pExcludeBoardID = " ";
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
		
		String boardGroupAdminFG = ezCommunityService.checkIfBoardGroupAdmin(pRootBoardID, loginVO.getId(), loginVO.getDeptID(), loginVO.getCompanyID());

		if (boardGroupAdminFG.equals("OK") || loginVO.getRollInfo().toLowerCase().indexOf("c=1") > -1 || loginVO.getRollInfo().toLowerCase().indexOf("k=1") > -1 || loginVO.getRollInfo().toLowerCase().indexOf("t=1") > -1) {
			pMode = 0;
		} else {
			pMode = 1;
		}
		
		strXML = ezCommunityService.getBoardTree(pRootBoardID, loginVO.getId(), loginVO.getDeptID(), loginVO.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, pClubID, commonUtil.getMultiData(loginVO.getLang()));

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
	 * 커뮤니티팝업화면 출력 함수
	 */
	@RequestMapping(value = "/ezCommunity/commHome/popupCommHome.do")
	public String popupCommHome(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		String rootBoardID = "TOP";
		boolean joinFlag = false, checkSysop = false;
		int newMemberConfirmType = 0;
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		String codeName = request.getParameter("codeName");
		String userLevel = request.getParameter("userLevel");
		
		// 20100119 보안처리 관련 추가작업(권한체크)
		ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 0, response);
		
		String strVisit = ezCommunityService.commHomeGet1(userInfo.getId(), code);
		
		if (strVisit == null || strVisit.substring(0, 10).equals(EgovDateUtil.getToday("-"))) {
			ezCommunityService.updateLastDate(EgovDateUtil.getTodayTime(), code, userInfo.getId());
		}
		
		String copType = ezCommunityService.commHomeGet4(code);
		
		if (copType == null) {
			copType = "type1";
		}
		
		//사용하는곳이 없다
		int memberCount = ezCommunityService.commHomeGet2(code);
		
		String boardGroupAdminFG = ezCommunityService.checkIfBoardGroupAdmin(rootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID());
		int mode = 0;
		
		if (boardGroupAdminFG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 ||  userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 ||  userInfo.getRollInfo().toLowerCase().indexOf("t=1") > -1) {
			mode = 0;
		} else {
			mode = 1;
		}
		
		String retXML = ezCommunityService.getBoardTree(rootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), mode, 0, 0, " ", code, commonUtil.getMultiData(userInfo.getLang()));
		
		if (retXML.substring(0, 5).toUpperCase().equals("ERROR")) {
			retXML = "<RESULT>ERROR</RESULT>";
		}
		
		String permit = ezCommunityService.leftCommunityGet1(code, userInfo.getId());

		if (permit != null) {
			userLevel = permit;
			joinFlag = true;
		} else {
			userLevel = "0";
		}
		
		String confirmType = ezCommunityService.leftCommunityGet2(code);
		
		if (confirmType != null) {
			newMemberConfirmType = Integer.parseInt(confirmType);
		}
		
		if (ezCommunityService.leftCommunityGet4(code).trim().equals(userInfo.getId()) && !checkSysop) {
			checkSysop = true;
		}
		
		model.addAttribute("code", code);
		model.addAttribute("copType", copType);
		model.addAttribute("joinFlag", joinFlag);
		model.addAttribute("newMemberConfirmType", newMemberConfirmType);
		model.addAttribute("checkSysop", checkSysop);
		model.addAttribute("retXML", retXML);
		model.addAttribute("userInfo", userInfo);
		
		return "/ezCommunity/popupCommHome";
	}
	
	/**
	 * 커뮤니티 메인 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/commHome/commHomeInfo.do", method = RequestMethod.POST, produces = "text/xml; charset=UTF-8")
	@ResponseBody
	public String commHomeInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlData) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = commonUtil.convertStringToDocument(xmlData).getElementsByTagName("CODE").item(0).getTextContent();
		String strSysopID = "";
		
		CommunityClubVO clubVO = ezCommunityService.aspCommInfoGet1(code);
		
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		String temp = commonUtil.getQueryResult(clubVO);
		sb.append(temp.substring(5, temp.length()-6));
		sb.append("</DATA>");
		
		Document xmlMainDom = commonUtil.convertStringToDocument(sb.toString());
		strSysopID = xmlMainDom.getElementsByTagName("C_SYSOPID").item(0).getTextContent().trim();
		
		String proplist = "displayName;description;company;extensionAttribute2";
		String infoXMLMemberInfo = ezOrganAdminService.getPropertyList(strSysopID, proplist, userInfo.getLang());
		
		Document xmldomMemberInfo = commonUtil.convertStringToDocument(infoXMLMemberInfo);
		
		String name = xmldomMemberInfo.getElementsByTagName("DISPLAYNAME").item(0).getTextContent();
		String companyNM = xmldomMemberInfo.getElementsByTagName("COMPANY").item(0).getTextContent();
		String deptName = xmldomMemberInfo.getElementsByTagName("DESCRIPTION").item(0).getTextContent();
		String userImage = xmldomMemberInfo.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent();
		
		Node targetNode = xmlMainDom.getElementsByTagName("DATA").item(0);
		Node newRow = xmlMainDom.createElement("MEMBER");
		Node newDataName = null;
		Node newDataValue = null;
		
		newDataName = xmlMainDom.createElement("USERNAME");
		newDataValue = xmlMainDom.createTextNode(name);
		newDataName.appendChild(newDataValue);
		newRow.appendChild(newDataName);
		
		newDataName = xmlMainDom.createElement("DEPTNAME");
		newDataValue = xmlMainDom.createTextNode(deptName);
		newDataName.appendChild(newDataValue);
		newRow.appendChild(newDataName);
		
		newDataName = xmlMainDom.createElement("COMPANYNAME");
		newDataValue = xmlMainDom.createTextNode(companyNM);
		newDataName.appendChild(newDataValue);
		newRow.appendChild(newDataName);
		
		newDataName = xmlMainDom.createElement("USERIMAGE");
		newDataValue = xmlMainDom.createTextNode(userImage);
		newDataName.appendChild(newDataValue);
		newRow.appendChild(newDataName);
		
		newDataName = xmlMainDom.createElement("USERID");
		newDataValue = xmlMainDom.createTextNode(strSysopID);
		newDataName.appendChild(newDataValue);
		newRow.appendChild(newDataName);
		
		targetNode.appendChild(newRow);
		
		return commonUtil.convertDocumentToString(xmlMainDom);
	}
	
	/** 
	 * 커뮤니티 메인 오른쪽화면 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/commHome/commHomeBoardInfo.do", method = RequestMethod.POST, produces = "text/xml; charset=UTF-8")
	@ResponseBody
	public String commHomeBoardInfo(@RequestBody String xmlData) throws Exception {
		StringBuilder sb = new StringBuilder();
		String code = commonUtil.convertStringToDocument(xmlData).getElementsByTagName("CODE").item(0).getTextContent();
		//EZSP_COPHOME_BOARD_GET
		List<CommunityBoardInfoVO> boardInfoList = ezCommunityService.copHomeBoardGet(code);
		
		sb.append("<ITEM>");
		sb.append("<BOARDINFO>");
		sb.append("<DATA>");
		
		for(CommunityBoardInfoVO boardInfo: boardInfoList){
			sb.append("<ROW>");
			sb.append("<BOARDID>"+boardInfo.getBoardID()+"</BOARDID>");
			sb.append("<BOARDNAME>"+boardInfo.getBoardName()+"</BOARDNAME>");
			sb.append("<BOARDNAME2>"+boardInfo.getBoardName2()+"</BOARDNAME2>");
			sb.append("<SHOWPOSITION>"+boardInfo.getShowPostition()+"</SHOWPOSITION>");
			sb.append("<SN>"+boardInfo.getSn()+"</SN>");
			sb.append("<GUBUN>"+boardInfo.getGubun()+"</GUBUN>");
			sb.append("</ROW>");
		}
		sb.append("</DATA>");
		
		sb.append("</BOARDINFO>");
		sb.append("<BOARDITEM>");
		sb.append("<DATA>");
		
		for(int i = 0; i < boardInfoList.size(); i++){
			String boardID = boardInfoList.get(i).getBoardID();
			List<CommunityBoardItemVO> boardItemList = ezCommunityService.copHomeBoardItemGet(boardID);
			
			for(CommunityBoardItemVO boardItem: boardItemList){
				sb.append("<ROW>");
				sb.append("<BOARDID>"+boardItem.getBoardID()+"</BOARDID>");
				sb.append("<ITEMID>"+boardItem.getItemID()+"</ITEMID>");
				sb.append("<TITLE>"+boardItem.getTitle()+"</TITLE>");
				sb.append("<WRITEDATE>"+boardItem.getWriteDate()+"</WRITEDATE>");
				sb.append("<GUBUN>"+boardItem.getGubun()+"</GUBUN>");
				sb.append("<EXTENSIONATTRIBUTE5>"+boardItem.getExtensionAttribute5()+"</EXTENSIONATTRIBUTE5>");
				sb.append("</ROW>");
			}
		}
		
		sb.append("</DATA>");
		sb.append("</BOARDITEM>");
		sb.append("</ITEM>");
		
		return sb.toString();
	}
	
	/**
	 * 커뮤니티 게시판 목록화면 호출 함수
	 */
	@RequestMapping(value = "/ezCommunity/boardItemList.do")
	public String boardItemList(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userLevel = "", url = "", pSortBy = "", strXML = "", showAdjacent = "";
		int pPage = 1, totalCount = 0, totalPage = 0;
		String pBoardID = request.getParameter("boardID");
		String code = request.getParameter("code");
		String pBoardName = request.getParameter("boardName");
		
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, pBoardID);
		ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 0, response);
		
		CommunityBoardListVO boardListVO = ezCommunityService.boardItemListGet1(pBoardID, userInfo.getId());
		
		if (boardListVO == null) {
			userLevel = "0";
		} else {
			if (boardListVO.getPermit().equals("0")) {
				userLevel = "9";
			} else {
				userLevel = boardListVO.getPermit();
			}
		}
		
		if (boardInfo.getListView_FG().equals("true")) {
			url = boardInfo.getUrl();
			
			if (request.getParameter("sortBy") != null) {
				pSortBy = request.getParameter("sortBy");
			}
			if (request.getParameter("page") != null) {
				pPage = Integer.parseInt(request.getParameter("page"));
			}
			
			int pStartRow = (pPage - 1) * boardInfo.getSs_Board_MaxRows() + 1;
			int pEndRow = pPage * boardInfo.getSs_Board_MaxRows();
			
			if (pBoardID.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
                strXML = ezCommunityService.getNewItemListXML(userInfo.getId(), pStartRow, pEndRow, pSortBy);
                totalCount = Integer.parseInt(ezCommunityService.getNewItemListCount(userInfo.getId()));
            } else {
                showAdjacent = "1";
                strXML = ezCommunityService.getBoardListItemXML(userInfo.getId(), pBoardID, pStartRow, pEndRow, pSortBy, userInfo.getLang());
                totalCount = Integer.parseInt(ezCommunityService.getBoardTotalItemCount(pBoardID));
            }
			
			if (totalCount > 0) {
				if (totalCount > boardInfo.getSs_Board_MaxRows()) {
					if(totalCount % boardInfo.getSs_Board_MaxRows() > 0) {
						totalPage = totalCount / boardInfo.getSs_Board_MaxRows() + 1;
					} else {
						totalPage = 1;
					}
				} else {
					totalPage = 1;
				}
			} else {
				totalPage = 1;
			}
		}
		
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("code", code);
		model.addAttribute("userLevel", userLevel);
		model.addAttribute("url", url);
		model.addAttribute("pSortBy", pSortBy);
		model.addAttribute("pPage", pPage);
		model.addAttribute("showAdjacent", showAdjacent);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("strXML", strXML);
		model.addAttribute("lang", commonUtil.getMultiData(userInfo.getLang()));
		model.addAttribute("pBoardName", pBoardName);
		
		return "/ezCommunity/communityBoardItemList";
	}
	
	/**
	 * 커뮤니티 검색화면 호출 함수
	 */
	@RequestMapping(value = "/ezCommunity/searchBoardItem.do")
	public String searchBoardItem(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		int pPage = 1, totalPage = 1, totalCount = 0;
		String title = "", writerName = "", abstracts = "", searchStart = "", searchEnd = "";
		String strXML="";
		
		//TODO 이효진 2016-05-11 정렬에 필요한 변수. 추가 작업 필요
		String pSortBy = "";
		
		String boardID = request.getParameter("boardID");
		String orgBoardParameters = request.getParameter("orgBoardParameters");
		String code = request.getParameter("code");
		
		if (request.getParameter("page") != null) {
			pPage = Integer.parseInt(request.getParameter("page"));
		}
		if (request.getParameter("title") != null) {
			title = request.getParameter("title");
		}
		if (request.getParameter("writerName") != null) {
			writerName = request.getParameter("writerName");
		}
		if (request.getParameter("abstract") != null) {
			abstracts = request.getParameter("abstract");
		}
		if (request.getParameter("searchStart") != null) {
			searchStart = request.getParameter("searchStart");
		}
		if (request.getParameter("searchEnd") != null) {
			searchEnd = request.getParameter("searchEnd");
		}

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, boardID);
		// 20100119 보안처리 관련 추가작업(권한체크)
        ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 0, response);
        
        int pStartRow = (pPage - 1) * boardInfo.getSs_SearchBoard_MaxRows() + 1;
        int pEndRow = pPage * boardInfo.getSs_SearchBoard_MaxRows();
        String startDateTime = "";
        String endDateTime = "";
        
        if (!searchStart.equals("")) {
        	startDateTime = searchStart.split(" ")[0];
        	endDateTime = searchEnd.split(" ")[0];
        }

        if (!title.equals("") || !writerName.equals("") || !abstracts.equals("") || !searchStart.equals("")) {
            strXML = ezCommunityService.searchItemXML(userInfo.getId(), boardID, title, writerName, abstracts, searchStart, searchEnd, pStartRow, pEndRow, commonUtil.getMultiData(userInfo.getLang()));
            totalCount = ezCommunityService.searchItemCount(userInfo.getId(), boardID, title, writerName, abstracts, startDateTime, endDateTime);
            
            if (totalCount > 0) {
				if (totalCount > boardInfo.getSs_SearchBoard_MaxRows()) {
					if(totalCount % boardInfo.getSs_SearchBoard_MaxRows() > 0) {
						totalPage = totalCount / boardInfo.getSs_SearchBoard_MaxRows() + 1;
					} else {
						totalPage = 1;
					}
				} else {
					totalPage = 1;
				}
			} else {
				totalPage = 1;
			}
        }

        System.out.println(strXML);
        model.addAttribute("userInfo", userInfo);
        model.addAttribute("boardInfo", boardInfo);
        model.addAttribute("orgBoardParameters", orgBoardParameters);
        model.addAttribute("startDateTime", startDateTime);
        model.addAttribute("endDateTime", endDateTime);
        model.addAttribute("pSortBy", pSortBy);
        
        model.addAttribute("strXML", strXML);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("totalPage", totalPage);
        
		return "/ezCommunity/communitySearchBoardItem";
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
		
		request.setCharacterEncoding("UTF-8");
		
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
			pKeyword = new String(keyword.getBytes("ISO-8859-1"), "UTF-8");
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

		keywordCount = ezCommunityService.getBBSListGet1(bName, commonUtil.getMultiData(loginVO.getLang()), pKeyword, sRadio);
		totalPage = keywordCount / comNoPerPage;
		
		if (keywordCount % comNoPerPage != 0) {
			totalPage = totalPage + 1;
		}
		
		curPage = Math.min(curPage, totalPage);
		List<CommunityCBoardVO> cBoardList = ezCommunityService.getBBSListGet2(bName, commonUtil.getMultiData(loginVO.getLang()), pKeyword, sRadio);
		
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

			if (cBoard.getWriteDay().compareTo(nowDate) >= 0) {
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

}
