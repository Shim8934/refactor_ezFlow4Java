package egovframework.ezEKP.ezCommunity.web;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

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
import org.springframework.validation.BindingResult;
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
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemReadVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardListVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardPropertyVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubGuestVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubUserVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollAnswerVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollManagerVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollQuestionVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollResponseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityLeftCommunityVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMemberInfoVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityOneLineReplyVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

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
	
	@Autowired
	private EgovFileScrty egovFileScrty;
	
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
	 * 왼쪽 메뉴화면 호출함수
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
        
        
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        
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
        
        String userInfoUserID = userInfo.getId();
        String userID = userInfo.getId();
        
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
        	String boardGroupAdminFG = brdCheckIfBoardGroupAdmin(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID());
        	
        	int pMode = 0;
        	
        	if (boardGroupAdminFG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("t=1") > -1) {
        		pMode = 0;
        	} else {
        		pMode = 1;
        	}
        	//dll
        	String retXML = getBoardTree(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, code, commonUtil.getMultiData(userInfo.getLang()));
        	
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
		model.addAttribute("chCommunityAdmin",userInfo.getRollInfo().indexOf("t=1"));
		model.addAttribute("checkSysop",checkSysop);
		model.addAttribute("lang",userInfo.getLang());
		model.addAttribute("userID", userID);
		model.addAttribute("userInfoUserID",userInfoUserID);
		
		return "/ezCommunity/communityLeftCommunity";
	}

	/**
	 * 커뮤니티목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/getLeftCommunity.do", method = RequestMethod.POST, produces = "TEXT/XML;CHARSET=UTF-8")
	@ResponseBody
	public String getLeftCommunity(@CookieValue("loginCookie")String loginCookie) throws Exception {
		String userID = "";
        StringBuilder sb = new StringBuilder();
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        userID = userInfo.getId();
        
        List<CommunityLeftCommunityVO> leftCommunityList =ezCommunityService.leftCommunityGet3(userID);
        
        sb.append("<DATA>");
        
        for (CommunityLeftCommunityVO leftCommunity : leftCommunityList) {
        	sb.append(commonUtil.getQueryResult(leftCommunity));
        }
        
        sb.append("</DATA>");
        
        return sb.toString();
	}
	
	/**
	 * 알림마당목록 호출함수
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
	 * 커뮤니티 로고 출력함수(ezCommon_Interface)
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
	 * 커뮤니티만들기 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/commMake.do")
	public String commMake(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		String userInfoUserID = "", userInfoDisplayName = "";
		String langPrimary="", langSecondary="";
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		userInfoUserID = userInfo.getId();
		langPrimary = config.getProperty("config.lang_Primary"+userInfo.getLang());
		langSecondary = config.getProperty("config.lang_Secondary"+userInfo.getLang());

		if (userInfo.getLang().equals("2")) {
			userInfoDisplayName = userInfo.getDisplayName2();
		} else {
			userInfoDisplayName = userInfo.getDisplayName1();
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
	public void commMakeOk(@CookieValue("loginCookie")String loginCookie, CommunityClubVO clubVO, ModelMap model, MultipartHttpServletRequest request, HttpServletResponse response) throws Exception {
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
		
		String[] bBoardName = egovMessageSource.getMessage("ezCommunity.t1492", new Locale(globals.getProperty("Globals.language"))).split(";");
		String[] bNotiName = egovMessageSource.getMessage("ezCommunity.t1493", new Locale(globals.getProperty("Globals.language"))).split(";");
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
			response.getWriter().write("alert('" + egovMessageSource.getMessage("ezCommunity.t1029", new Locale(globals.getProperty("Globals.language"))) + "');");
			response.getWriter().write("history.back();");			
			response.getWriter().write("</script>");
			response.getWriter().flush();
			
			return;
		}
		
		boardNo = ezCommunityService.commMakeOkGet2();
		boardNo += 1;
		
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

			File file = new File(logoPath + fileName + "_logo" + "." + extName);
			cClubLogo.transferTo(file);
			
			
			BufferedImage inputImage = ImageIO.read(file);
			BufferedImage outputImage = null;
			Graphics2D saveImage = null;
			
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
			response.getWriter().write("alert('Community" + egovMessageSource.getMessage("ezCommunity.t1027", new Locale(globals.getProperty("Globals.language"))) + "');\n");
			response.getWriter().write("document.location.href = '/ezCommunity/commMake.do?flag=1';\n");
			response.getWriter().write("</script>");
			response.getWriter().flush();
		}
	}
	/**
	 * SubBoards 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/getSubBoards.do", method = RequestMethod.POST, produces = "TEXT/XML;CHARSET=UTF-8")
	@ResponseBody
	public String getSubBoards(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request) throws Exception {
		String pClubID = "", pRootBoardID = "", pSubFlag = "", pExcludeBoardID = " ";
		int pSelectBy = 0, pMode = 0;
		String strXML = "";
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		pClubID = request.getParameter("classID");
		pRootBoardID = request.getParameter("rootBoardID");
		pSubFlag = request.getParameter("subFlag");

		if (request.getParameter("excludeBoardID") != null) {
			pExcludeBoardID = request.getParameter("excludeBoardID");
		}
		if ( request.getParameter("selectFlag") != null) {
			pSelectBy = Integer.parseInt(request.getParameter("selectFlag"));
		}
		
		String boardGroupAdminFG = ezCommunityService.checkIfBoardGroupAdmin(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID());

		if (boardGroupAdminFG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("t=1") > -1) {
			pMode = 0;
		} else {
			pMode = 1;
		}
		
		strXML = ezCommunityService.getBoardTree(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, pClubID, commonUtil.getMultiData(userInfo.getLang()));

		return strXML;
	}
	
	/**
	 * 관리자권한 확인 함수
	 */
	@RequestMapping(value = "/ezCommunity/goAdminOk.do")
	@ResponseBody
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
		aspXML.append("</ASP>");
		
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
	@RequestMapping(value = "/ezCommunity/checkCommHome.do")
	public String checkCommHome(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, ModelMap model) throws Exception {
		String codeName = "", userLevel = "";
        
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userInfoUserID = userInfo.getId();
		
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
        	
        	String boardGroupAdminFG = ezCommunityService.brdCheckIfBoardGroupAdmin(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID());
        	
        	int pMode = 0;
        	
        	if (boardGroupAdminFG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("t=1") > -1) {
        		pMode = 0;
        	} else {
        		pMode = 1;
        	}

        	String retXML = getBoardTree(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, code, commonUtil.getMultiData(userInfo.getLang()));
        	
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
		
		return "/ezCommunity/communityPopupCommHome";
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
	 * 커뮤니티 게시판 목록화면 호출함수
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
				totalCount = Integer.parseInt(ezCommunityService.getNewItemListCount(userInfo.getId()));
				
				if (totalCount < pEndRow) {
					pEndRow = totalCount;
				}
				
                strXML = ezCommunityService.getNewItemListXML(userInfo.getId(), pStartRow, pEndRow, pSortBy);
            } else {
                showAdjacent = "1";
                totalCount = Integer.parseInt(ezCommunityService.getBoardTotalItemCount(pBoardID));
                
                if (totalCount < pEndRow) {
					pEndRow = totalCount;
				}
                
                strXML = ezCommunityService.getBoardListItemXML(userInfo.getId(), pBoardID, pStartRow, pEndRow, pSortBy, userInfo.getLang());
            }
			
			if (totalCount > 0) {
				if (totalCount > boardInfo.getSs_Board_MaxRows()) {
					if(totalCount % boardInfo.getSs_Board_MaxRows() > 0) {
						totalPage = totalCount / boardInfo.getSs_Board_MaxRows() + 1;
					} else {
						totalPage = totalCount / boardInfo.getSs_Board_MaxRows();
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
	 * 커뮤니티 검색화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/searchBoardItem.do")
	public String searchBoardItem(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		int pPage = 1, totalPage = 1, totalCount = 0;
		String title = "", writerName = "", abstracts = "", searchStart = "", searchEnd = "", pSortBy = "";
		String strXML="";
		
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
		if (request.getParameter("pSortBy") != null) {
			pSortBy = request.getParameter("pSortBy");
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
        	totalCount = Integer.parseInt(ezCommunityService.searchItemCount(userInfo.getId(), boardID, title, writerName, abstracts, startDateTime, endDateTime));
            strXML = ezCommunityService.searchItemXML(userInfo.getId(), boardID, title, writerName, abstracts, searchStart, searchEnd, pStartRow, pEndRow, commonUtil.getMultiData(userInfo.getLang()));
            
            if (totalCount > 0) {
				if (totalCount > boardInfo.getSs_SearchBoard_MaxRows()) {
					if(totalCount % boardInfo.getSs_SearchBoard_MaxRows() > 0) {
						totalPage = totalCount / boardInfo.getSs_SearchBoard_MaxRows() + 1;
					} else {
						totalPage = totalCount / boardInfo.getSs_SearchBoard_MaxRows();
					}
				} else {
					totalPage = 1;
				}
			} else {
				totalPage = 1;
			}
        }

        model.addAttribute("userInfo", userInfo);
        model.addAttribute("boardInfo", boardInfo);
        model.addAttribute("orgBoardParameters", orgBoardParameters);
        model.addAttribute("startDateTime", startDateTime);
        model.addAttribute("endDateTime", endDateTime);
        model.addAttribute("pSortBy", pSortBy);
        model.addAttribute("strXML", strXML);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("title", title);
        model.addAttribute("writerName", writerName);
        model.addAttribute("abstract", abstracts);
        
		return "/ezCommunity/communitySearchBoardItem";
	}
	
	/**
	 * 게시물 읽음표시 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/setRead.do", method = RequestMethod.POST)
	@ResponseBody
	public String setRead(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request){
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardID = request.getParameter("boardID");
		String itemIDList = request.getParameter("itemIDList");
		
		try{
			ezCommunityService.setAsRead(userInfo, boardID, itemIDList);
			
			return "OK";
		} catch(Exception e) {
			return "ERROR";
		}
	}
	
	/**
	 * 게시물 답변 여부 체크 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/checkIfHasReply.do", method = RequestMethod.POST)
	@ResponseBody
	public String checkIfHasReply (HttpServletRequest request) throws Exception {
		String itemList = request.getParameter("itemList");
		
		return ezCommunityService.checkIfHasReply(itemList);
	}
	
	/**
	 * 게시물 삭제 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/deleteItem.do", method = RequestMethod.POST)
	public void deleteItem(HttpServletRequest request) throws Exception {
		String itemList = request.getParameter("itemList");
		
		ezCommunityService.deleteItem(itemList);
	}
	
	/**
	 * 게시물 등록/수정/답변 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/newBoardItem.do")
	public String newBoardItem(@CookieValue("loginCookie") String loginCookie, ModelMap model, CommunityBoardItemVO item, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String pItemID = "", pReservedItem = "", pUrl = "", pDocID = "", expireDays = "", strWriterFakeName = "";;
		String hasAttach = "NO";
		String uploadFilePath = config.getProperty("upload_community.ROOT") + commonUtil.separator;
		String userInfoApprovalG = config.getProperty("config.UserInfo_ApprovalG");
		String publicModulus = egovFileScrty.getPbm();
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String pBoardID = request.getParameter("boardID");
		String pMode = request.getParameter("mode");
		
		if (request.getParameter("itemID") != null) {
			pItemID = request.getParameter("itemID");
		}
		if (request.getParameter("reservedItem") != null) {
			pReservedItem = request.getParameter("reservedItem");
		}
		if (request.getParameter("url") != null) {
			pUrl = request.getParameter("url");
		}
		if (request.getParameter("docID") != null) {
			pDocID = request.getParameter("docID");
		}
		
		ezCommunityService.communityConnCHK(userInfo.getId(), "", pBoardID, userInfo.getRollInfo(), 1, response);
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, pBoardID);
		
		if (!pUrl.equals("")) {
			item.setStartDate(EgovDateUtil.getToday("-"));
			item.setStartDate(EgovDateUtil.addDay(EgovDateUtil.getToday("-"), 30, "yyyy-MM-dd"));
			expireDays = "-1";
		} else {
			if (userInfo.getLang().equals("2")) {
				item.setBoardName(boardInfo.getBoardName2());
			} else {
				item.setBoardName(boardInfo.getBoardName());
			}

			expireDays = boardInfo.getExpireDays();
			if (pMode.equals("new")) {
				if (expireDays.equals("-1")) {
                    item.setEndDate(EgovDateUtil.addDay(EgovDateUtil.getToday("-"), 30, "yyyy-MM-dd"));
                } else {
                    item.setEndDate(EgovDateUtil.addDay(EgovDateUtil.getToday("-"), Integer.parseInt(expireDays), "yyyy-MM-dd"));
                }
			} else {
				item = ezCommunityService.getItemXML(pBoardID, pItemID);
				
                if (pMode.equals("reply")) {
                	item.setItemLevel(item.getItemLevel()+1);
                	item.setAbsTract("");
                	item.setTitle(item.getTitle());
                } else if (pMode.equals("modify")) {
                	if (item.getEndDate().substring(0, 4).equals("9999")) {
                        if (expireDays == "-1")	{
                        	item.setEndDate(EgovDateUtil.addDay(EgovDateUtil.getToday("-"), 30, "yyyy-MM-dd"));
                        } else {
                            item.setEndDate(EgovDateUtil.addDay(EgovDateUtil.getToday("-"), Integer.parseInt(expireDays), "yyyy-MM-dd"));
                        }
                    }
                	
                	if (boardInfo.getGubun() != null) {
	                	if (boardInfo.getGubun().equals("2")) {
	                		strWriterFakeName = item.getWriterName();
	                	}
                	}
                }

                if (Integer.parseInt(item.getAttachments()) > 0) {
                	hasAttach = "YES";
                }
			}
		}
		
		model.addAttribute("editor", config.getProperty("config.EDITOR"));
		model.addAttribute("pUploadFilePath", uploadFilePath);
		model.addAttribute("userInfoApprovalG", userInfoApprovalG);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("item", item);
		model.addAttribute("pReservedItem", pReservedItem);
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("pDocID", pDocID);
		model.addAttribute("pMode", pMode);
		model.addAttribute("strNow", EgovDateUtil.getTodayTime());
		model.addAttribute("hasAttach", hasAttach);
		model.addAttribute("strWriterFakeName", strWriterFakeName);
		model.addAttribute("pUrl", pUrl);
		
		return "/ezCommunity/communityNewBoardItem";
	}
	
	/**
	 * 게시판 쓰기/수정/답변 실행함수
	 */
	
	@RequestMapping(value = "/ezCommunity/saveItem.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveItem (@RequestBody String xmlStr, CommunityBoardItemVO item, HttpServletRequest request) throws Exception {
		Document xmlData = commonUtil.convertStringToDocument(xmlStr);
		String pMode = request.getParameter("mode");

		String ret = ezCommunityService.newItem(xmlData, pMode, request.getServletContext().getRealPath(""));
		
		return ret;
	}
	
	/**
	 * 게시판 파일업로드 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/upload.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String upload(MultipartHttpServletRequest request, HttpServletResponse response) throws Exception { 
		int cnt = 0, pMaxSize = 0;
		String strXML = "";
		
		String pBoardID = request.getParameter("boardID");
		String pMode = request.getParameter("mode");
		
		if (request.getParameter("cnt") != null) {
			cnt = Integer.parseInt(request.getParameter("cnt"));
		}
		if (request.getParameter("maxSize") != null) {
			pMaxSize = Integer.parseInt(request.getParameter("maxSize").trim());
		}
		
		String userExtension = config.getProperty("config.USE_FileExtension").toString();
		Iterator<String> itr = request.getFileNames();
		
		String pDirPath = request.getServletContext().getRealPath("") + commonUtil.separator + config.getProperty("upload_community.ROOT") + commonUtil.separator;
		String tempPath = pDirPath  + "TempUploadFile";
		String uploadPath = pDirPath  + pBoardID + commonUtil.separator + "UploadFile";
		String docPath = pDirPath  + pBoardID + commonUtil.separator + "doc";
		
		File tempDir = new File(tempPath);
		
		if (!tempDir.exists()) {
			tempDir.mkdirs();
		}
		
		File boardDir = new File(pDirPath + pBoardID);
		File uploadDir = new File(uploadPath);
		File docDir = new File(docPath);
		
		if (!boardDir.exists()) {
			boardDir.mkdirs();
			uploadDir.mkdirs();
			docDir.mkdirs();
		} else if (!uploadDir.exists()) {
			uploadDir.mkdirs();
		} else if (!docDir.exists()) {
			docDir.mkdirs();
		}
		
		strXML = "<ROOT><NODES>";
		
		while(itr.hasNext()){
			MultipartFile file = request.getFile(itr.next());
			String resultUpload = "false";
			String pUploadSN = "{" + UUID.randomUUID().toString() + "}";
			String pFileName = file.getOriginalFilename();
			String pAttachPath = "";
			
			if (pFileName.indexOf(commonUtil.separator) > 0) {
				pFileName = pFileName.split(commonUtil.separator)[pFileName.split(commonUtil.separator).length - 1];
			}
			
			pFileName =pFileName.replace("+", "%2b").replace(";", "%3b");
			int fileSize = (int) file.getSize();
			
			if (fileSize > pMaxSize) {
				resultUpload = "overflow";
			} else {
				if (pMode.equals("ATT")) {
					if (userExtension.indexOf(pFileName.substring(pFileName.lastIndexOf(".") + 1).toString()) == -1 && !userExtension.equals("*")) {
						resultUpload = "denied";
					} else {
						pAttachPath = pDirPath + "TempUploadFile" + commonUtil.separator + pUploadSN + "_" + pFileName;
						file.transferTo(new File(pAttachPath));
						resultUpload = "true";
					}
					//TODO 2016-05-16 이효진 포토게시판에서 쓸꺼같음
				} else if (pMode.equals("PHOTO")) {
					pAttachPath = pDirPath + "TempUploadFile" + commonUtil.separator + pUploadSN + pFileName.substring(pFileName.lastIndexOf("."));
					file.transferTo(new File(pAttachPath));
					
					//TODO 썸네일 생성소스 만들어논거
					/*BufferedImage inputImage = ImageIO.read(file);
					BufferedImage outputImage = null;
					Graphics2D saveImage = null;
					//로고파일 생성			
					outputImage= new BufferedImage(894, 100, BufferedImage.TYPE_INT_RGB);
					saveImage = outputImage.createGraphics();
					saveImage.drawImage(inputImage, 0, 0, 894, 100, null);
					
					File newLogo = new File(logoPath + fileName + "_logo" + ".png");
					ImageIO.write(outputImage, "png", newLogo);*/
					
					
/*					System.Drawing.Image.GetThumbnailImageAbort myCallBack = new System.Drawing.Image.GetThumbnailImageAbort(ThumbnailCallback);
                    System.Drawing.Image image = System.Drawing.Image.FromFile(pAttachPath);

                    int nImgWidth = image.Width;
                    int nImgHeight = image.Height;
                    int nWidth = 0, nHeight = 0;
                    if (nImgWidth > nImgHeight)
                    {
                        nWidth = 200;
                        nHeight = (image.Height * nWidth) / image.Width;
                    }
                    else
                    {
                        nHeight = 200;
                        nWidth = (image.Width * nHeight) / image.Height;
                    }
                    System.Drawing.Image imageThumbnail = image.GetThumbnailImage(100, 100, myCallBack, (IntPtr)0);
                    imageThumbnail.Save(pDirPath + "\\TempUploadFile\\s_" + pUploadSN[i] + pFileName[i].Substring(pFileName[i].LastIndexOf('.')));
                    imageThumbnail.Dispose();
                    image.Dispose();*/
					
					resultUpload = "true";
					strXML += "<NODE><PUPLOADSN>" + commonUtil.cleanValue(pUploadSN + pFileName.substring(pFileName.lastIndexOf('.'))) + "</PUPLOADSN>";
				}
			}
			
			if (!pMode.equals("PHOTO")) {
				strXML += "<NODE><PUPLOADSN>" + commonUtil.cleanValue(pUploadSN + "_" + pFileName) + "</PUPLOADSN>";
			}
			
			strXML += "<RESULTUPLOADA>" + commonUtil.cleanValue(resultUpload) + "</RESULTUPLOADA>";
            strXML += "<PFILENAME>" + commonUtil.cleanValue(pFileName) + "</PFILENAME>";
            strXML += "<FILESIZE>" + fileSize + "</FILESIZE>";
            strXML += "<FILELOCATION>" + commonUtil.cleanValue(pAttachPath) + "</FILELOCATION>";
            strXML += "</NODE>";	
		}
		
		strXML += "</NODES></ROOT>";
		
		return strXML;
	}
	
	/**
	 * 게시판 읽기 화면호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardItemView.do")
	public String boardItemView(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		/*NoneActiveX = GetSystemConfigValue("NONEACTIVEX");
        Use_Editor = GetSystemConfigValue("EDITOR").ToString();*/
		
		String previousItemID = "", previousTitle = "", nextItemID = "", nextTitle = "";
		String cAdmin = "", gcAdmin = "", pVersionUse = "";
		String pReservedItem = "";
		String pItemID = request.getParameter("itemID");
		String pBoardID = request.getParameter("boardID");
		String code = request.getParameter("code");
		String showAdjacent = request.getParameter("showAdjacent");
		if (showAdjacent == null) {
			showAdjacent = config.getProperty("config.ADJACENT_ITEMS_ENABLE");
		}
		
		String useEditor = config.getProperty("config.EDITOR");
		String oneLineReplyFlag = config.getProperty("config.ONELINE_REPLY_ENABLE");
        String adjacentItemsEnableFlag = config.getProperty("config.ADJACENT_ITEMS_ENABLE");
        String useKMS = config.getProperty("config.Use_ezKMS");
        String publicModulus = egovFileScrty.getPbm();
        
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		ezCommunityService.communityConnCHK(userInfo.getId(), "", pBoardID, userInfo.getRollInfo(), 1, response);
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, pBoardID);
		
		CommunityBoardItemVO item = ezCommunityService.getItemXML(pBoardID, pItemID);
		ezCommunityService.setAsRead(userInfo, pBoardID, pItemID);

		if (request.getParameter("pReservedItem") != null) {
			pReservedItem = request.getParameter("pReservedItem");
		}
		
		if (item.getParentWriteDate().compareTo(item.getWriteDate()) > 0) {
			item.setWriteDate(item.getParentWriteDate());
		}
		
		if (item.getEndDate().substring(0, 4).equals("9999")) {
			item.setEndDate(egovMessageSource.getMessage("ezCommunity.t930", new Locale(globals.getProperty("Globals.language"))));
		}
		
		if (adjacentItemsEnableFlag.equals("1") && showAdjacent.equals("1")) {
			Map<String, String> map = ezCommunityService.getAdjacentItems(pItemID, pBoardID, item.getUpperItemIDTree(), item.getParentWriteDate());
			
            previousItemID = map.get("previousItemID");
            previousTitle = map.get("previousTitle");
            nextItemID = map.get("nextItemID");
            nextTitle = map.get("nextTitle");

            if (previousTitle.equals("")) {
            	previousTitle = egovMessageSource.getMessage("ezCommunity.t191", new Locale(globals.getProperty("Globals.language")));
            }
            
            if (nextTitle.equals("")) {
            	nextTitle = egovMessageSource.getMessage("ezCommunity.t193", new Locale(globals.getProperty("Globals.language")));
            }
            
            if (userInfo.getRollInfo().indexOf("c=1") > 0 || userInfo.getRollInfo().indexOf("k=1") > 0 || userInfo.getRollInfo().indexOf("t=1") > 0) {
            	cAdmin = "admin";
            }
            
            boardInfo.setBoardGroupAdmin_FG(ezCommunityService.checkIfBoardGroupAdmin(pBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID()));
            
            if (boardInfo.getBoardGroupAdmin_FG().equals("OK")) {
            	gcAdmin = "OK";
            }
            
            pVersionUse = ezCommunityService.getVersionInfo(pBoardID); 
		}
		
		if (boardInfo.getGubun() != null) {
			if (boardInfo.getGubun().equals("2")) {
				item.setWriterID("");
				item.setWriterDeptName("");
				item.setWriterCompanyName("");
			}
		}
		
		model.addAttribute("itemID", pItemID);
		model.addAttribute("boardID", pBoardID);
		model.addAttribute("code", code);
		model.addAttribute("pReservedItem", pReservedItem);
		model.addAttribute("showAdjacent", showAdjacent);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("oneLineReplyFlag", oneLineReplyFlag);
		model.addAttribute("adjacentItemsEnableFlag", adjacentItemsEnableFlag);
		model.addAttribute("useKMS", useKMS);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("strUserLang", commonUtil.getMultiData(userInfo.getLang()));
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("item", item);
		model.addAttribute("previousItemID", previousItemID);
		model.addAttribute("previousTitle", previousTitle);
		model.addAttribute("nextItemID", nextItemID);
		model.addAttribute("nextTitle", nextTitle);
		model.addAttribute("cAdmin", cAdmin);
		model.addAttribute("gcAdmin", gcAdmin);
		model.addAttribute("pVersionUse", pVersionUse);
		model.addAttribute("ch_CommunityAdmin", userInfo.getRollInfo().indexOf("t=1"));
		model.addAttribute("publicModulus", publicModulus);
		
		return "/ezCommunity/communityBoardItemView";
	}
	
	//TODO 2016-05-19 이효진  만들어야함
	/**
	 * checkPassword
	 */
	
	/**
	 * 한줄답변 목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/readOneLineReply.do", method = RequestMethod.POST)
	public String readOneLineReply(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		String pBoardID = request.getParameter("boardID");
		String pItemID = request.getParameter("itemID");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<CommunityOneLineReplyVO> oneLineReplyList = ezCommunityService.readOneLineReply(commonUtil.getMultiData(userInfo.getLang()), pBoardID, pItemID);
		
		model.addAttribute("oneLineReplyList", oneLineReplyList);
		
		return "json";
	}
	
	/**
	 * 한줄답변 등록 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/saveOneLineReply.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public void saveOneLineReply(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDoc = commonUtil.convertStringToDocument(request.getParameter("strXML"));

		String userName = "", userName2 = "", userID = userInfo.getId();
		String pItemID = xmlDoc.getElementsByTagName("ITEMID").item(0).getTextContent();
		String pReplyID = xmlDoc.getElementsByTagName("REPLYID").item(0).getTextContent();
		String pBoardID = xmlDoc.getElementsByTagName("BOARDID").item(0).getTextContent();
		String pContent = xmlDoc.getElementsByTagName("CONTENT").item(0).getTextContent();
		String pPassword = xmlDoc.getElementsByTagName("PASSWORD").item(0).getTextContent();
		String[] u_Name = egovMessageSource.getMessage("ezCommunity.t115", new Locale(globals.getProperty("Globals.language"))).split(";");
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, pBoardID);
		
		if (boardInfo.getGubun() != null) {
			if (boardInfo.getGubun().equals("2")) {
				userName = u_Name[0].trim();
				userName2 = u_Name[1].trim();
				userID = "";
			} else {
				userName = userInfo.getDisplayName1();
				userName2 = userInfo.getDisplayName2();
			}
		} else {
			userName = userInfo.getDisplayName1();
			userName2 = userInfo.getDisplayName2();
		}
		
		pContent = pContent.replace("'",  "''");
		
		ezCommunityService.saveOneLineReply(pItemID, pReplyID, pBoardID, userID, userName, userName2, pContent, pPassword);
	}
	
	/**
	 * 한줄답변 삭제시 작성자본인확인 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/checkOneLineOwner.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String checkOneLineOwner(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pReplyID = request.getParameter("replyID");
		
		int count = ezCommunityService.checkOneLineOwner(pReplyID, userInfo.getId());
		
		if (count > 0) {
			return "OK_MINE";
		} else {
			return "FAIL";
		}
	}
	
	/**
	 * 한줄답변 삭제 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/deleteOneLineReply.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String deleteOneLineReply(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pReplyID = request.getParameter("replyID");
		String gubun = request.getParameter("gubun");
		
		return ezCommunityService.deleteOneLineReply(userInfo.getId(), pReplyID, gubun);
	}
	
	//TODO 2016-05-23 이효진  익명게시판 만들고나서 작업해야함
	/**
	 * 익명게시판일때 checkReplyPassword
	 */
	@RequestMapping(value = "/ezCommunity/checkReplyPassword.do")
	public String checkReplyPassword(ModelMap model, HttpServletRequest request) throws Exception {
		String publicModulus = egovFileScrty.getPbm();
		String pItemID = request.getParameter("itemID");
		String pReplyID = request.getParameter("replyID");
		
		String password = ezCommunityService.checkReplyPassword(pItemID, pReplyID);
		
		model.addAttribute("password", password);
		model.addAttribute("publicModulus", publicModulus);
		
		return "/ezCommunity/communitycheckReplyPassword";
	}
	
	/**
	 * 게시판 첨부파일 목록 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/getItemAttachments.do", method = RequestMethod.POST)
	@ResponseBody
	public String getItemAttachments(HttpServletRequest request) throws Exception {
		String itemID = request.getParameter("itemID");
		
		String strXML = ezCommunityService.getItemAttachmentXML(itemID);
		
		if (strXML.substring(0, 5).equals("ERROR")) {
			strXML = "<RESULT>" + strXML + "</RESULT>";
		}
		
		return strXML;
	}
	
	/**
	 * 게시판 예약게시목록 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardReservedItemList.do")
	public String boardReservedItemList(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		String pSortBy = "";
		int pPage = 1, totalPage = 1;
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pOrgBoardParameters = request.getParameter("orgBoardParameters");
		
		if (request.getParameter("page") != null) {
			pPage = Integer.parseInt(request.getParameter("page"));
		}
		
		if (request.getParameter("sortBy") != null) {
			pSortBy = request.getParameter("sortBy");
		}
		
		String boardName = egovMessageSource.getMessage("ezCommunity.t91", new Locale(globals.getProperty("Globals.language")));
		
		CommunityBoardPropertyVO boardInfo = ezCommunityService.getBoardInfo(userInfo, "");
		
		boardInfo.setSs_Board_MaxRows(10);
		
		int pStartRow =  (pPage - 1) * boardInfo.getSs_Board_MaxRows() + 1;
		int pEndRow = pPage * boardInfo.getSs_Board_MaxRows();

		String strXML = ezCommunityService.getReservedItemListXML(userInfo.getId(), pStartRow, pEndRow, pSortBy, userInfo.getLang());
		int totalCount = ezCommunityService.getReservedItemListCount(userInfo.getId());
		
		if (totalCount > 0) {
			if (totalCount > boardInfo.getSs_Board_MaxRows()) {
				if(totalCount % boardInfo.getSs_Board_MaxRows() > 0) {
					totalPage = totalCount / boardInfo.getSs_Board_MaxRows() + 1;
				} else {
					totalPage = totalCount / boardInfo.getSs_Board_MaxRows();
				}
			} else {
				totalPage = 1;
			}
		} else {
			totalPage = 1;
		}
		
		model.addAttribute("pOrgBoardParameters", pOrgBoardParameters);
		model.addAttribute("pPage", pPage);
		model.addAttribute("pSortBy", pSortBy);
		model.addAttribute("boardName", boardName);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("strXML", strXML);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalPage", totalPage);
		
		return "/ezCommunity/communityBoardReservedItemList";
	}
	
	/**
	 * 게시판 첨부파일 다운로드 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/getCommunityAttachInfo.do")
	public void getCommunityAttachInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String pFileName = request.getParameter("fileName");
		String pFilePath = request.getParameter("filePath");
		
		ezCommonService.responseAttach(pFilePath, pFileName, true, request, response);
	}
	
	/**
	 * 게시판 조회자정보 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/itemReadList.do")
	public String itemReadList(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String pBoardID = request.getParameter("boardID");
		String pItemID = request.getParameter("itemID");
		
		List<CommunityBoardItemReadVO> readList = ezCommunityService.getReaderList(pBoardID, pItemID);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("readList", readList);
		
		return "/ezCommunity/communityItemReadList";
	}
	
	/**
	 * 게시글 미리보기 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/boardItemPreview.do")
	public String boardItemPreView(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		String useIE11Browser = "";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String gubun = request.getParameter("gubun");
		String useEditor = config.getProperty("config.EDITOR");
		
		if ((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && config.getProperty("config.IE11EDITOR").equals("CK")) {
                useIE11Browser = "CK";
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("gubun", gubun);
		model.addAttribute("strNow", EgovDateUtil.getTodayTime());
		model.addAttribute("Use_Editor", useEditor);
		model.addAttribute("Use_IE11Browser", useIE11Browser);
		
		return "/ezCommunity/communityBoardItemPreview";
	}
	
	/**
	 * 게시판 복사화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/copyBoardItem.do")
	public String copyBoardItem(ModelMap model, HttpServletRequest request) {
		String pItemIDList = request.getParameter("itemIDList");
		String pBoardID = request.getParameter("boardID");
		String code = request.getParameter("code");
		
		model.addAttribute("itemIdList", pItemIDList);
		model.addAttribute("boardID", pBoardID);
		model.addAttribute("code", code);
		return "/ezCommunity/communityCopyBoardItem";
	}
	
	/**
	 * 게시판 복사 권한 검사
	 */
	@RequestMapping(value = "/ezCommunity/getACL.do", method = RequestMethod.POST)
	public String getACL(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		CommunityBoardPropertyVO boardInfo;
		
		if(request.getParameter("comID") != null) {
			String pComID = request.getParameter("comID");
			String strACLXML = ezCommunityService.getACL(userInfo.getId(), pComID);
			
			model.addAttribute("WRITE", strACLXML);
		} else if (request.getParameter("boardID") != null) {
			String pBoardID = request.getParameter("boardID");
			String userDeptPath = userInfo.getDeptPathCode();
			
			for(String pAccessID : userDeptPath.split(",")) {
				boardInfo = ezCommunityService.brdGetACL(pBoardID, pAccessID);
				
				if (boardInfo != null) {
					model.addAttribute("boardInfo", boardInfo);
					break;
				}
			}
		}
		
		return "json";
	}
	
	/**
	 * 게시판 복사 실행함수
	 */
	//TODO 2016-05-24 이효진 다른게시판 만들고나서 구현가능
	@RequestMapping(value = "/ezCommunity/copyItem.do", method = RequestMethod.POST)
	public String copyItem(ModelMap model, HttpServletRequest request) throws Exception {
		String pOrgItemIDList = request.getParameter("orgItemIDList");
		String pOrgBoardID = request.getParameter("orgBoardID");
		String pDestItemIDList = request.getParameter("destItemIDList");
		String pDestBoardID = request.getParameter("destBoardID");
		String pUploadFilePath = config.getProperty("upload_community.ROOT");
		String ret = "";
		
		int i = 0;
		for(String pOrgItemID : pOrgItemIDList.split(";")) {
			ret = ezCommunityService.copyItem(pOrgItemID, pOrgBoardID, pDestItemIDList.split(";")[i], pDestBoardID, pUploadFilePath);
		}
		
		model.addAttribute("RESULT", ret);
		
		return "json";
	}
	/**
	 * 알림마당 목록화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/board/bbsList.do")
	public String bbsList(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, ModelMap model) throws Exception {
		String bName = "c_Board", sRadio = "", type = "", userLevel = "", code = "", keyword = "";
		String pKeyword = "", titleName = "";
		int curPage = 0, totalPage = 0, nowBlock = 0, myChoice = 0 , keywordCount = 0;
		int prevPage = 0, nextPage = 0 , totalBlock = 0, goPage = 0;
		int comNoPerPage = 17;
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
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

		keywordCount = ezCommunityService.getBBSListGet1(bName, commonUtil.getMultiData(userInfo.getLang()), pKeyword, sRadio);
		totalPage = keywordCount / comNoPerPage;
		
		if (keywordCount % comNoPerPage != 0) {
			totalPage = totalPage + 1;
		}
		
		curPage = Math.min(curPage, totalPage);
		List<CommunityCBoardVO> cBoardList = ezCommunityService.getBBSListGet2(bName, commonUtil.getMultiData(userInfo.getLang()), pKeyword, sRadio);
		
		StringBuilder strHTML = new StringBuilder();
		int iColSpan = 5;
		
		if (bName.equals("c_clubpds") || bName.equals("c_clubpds1")) {
			iColSpan = 6;
		}
		
		strHTML.append("<tr>");
		strHTML.append("<th width=\"60px\" >" + egovMessageSource.getMessage("ezCommunity.t32", new Locale(globals.getProperty("Globals.language"))) + "</th>");
		strHTML.append("<th>" + egovMessageSource.getMessage("ezCommunity.t170", new Locale(globals.getProperty("Globals.language"))) + "</th>");
		strHTML.append("<th width=\"70px\">" + egovMessageSource.getMessage("ezCommunity.t138", new Locale(globals.getProperty("Globals.language"))) + "</th>");
		strHTML.append("<th width=\"90px\">" +  egovMessageSource.getMessage("ezCommunity.t171", new Locale(globals.getProperty("Globals.language"))) + "</th>");
		
		if (iColSpan == 6) {
			strHTML.append("<th width=\"45px\">" + egovMessageSource.getMessage("ezCommunity.t172", new Locale(globals.getProperty("Globals.language"))) + "</th>");
		}
		
		strHTML.append("<th width=\"60px\">" + egovMessageSource.getMessage("ezCommunity.t173", new Locale(globals.getProperty("Globals.language"))) + "</th>");
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
			
			if (commonUtil.getMultiData(userInfo.getLang()).equals("")) {
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
		model.addAttribute("rollInfo", userInfo.getRollInfo());
		model.addAttribute("code", code);
		
		return "/ezCommunity/board/bbsList";
	}
	
	/**
	 * 알림마당 읽기 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/board/bbsViewNew.do")
	public String bbsNewViewNew(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		String keyword = "", sRadio = "", pagec = "1";
		String strTitle = "", strWriteName = "", strWriterID = "";
		int myStep = 0, myLevel = 0, grsRef = 0, readNo = 0, grsNo = 0;	
		String previousItemID = "", nextItemID = "";
		String strWriteDate = "";
		int nowBlock = 0;
	
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
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
		
		int adminCheck = ezCommunityService.bbsAdminCheck(userInfo.getId(), userInfo.getRollInfo());
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
			
			if (commonUtil.getMultiData(userInfo.getLang()).equals("2")) {
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
		model.addAttribute("userInfo", userInfo);
		
		
		return "/ezCommunity/board/bbsViewNew";
	}
	
	/**
	 * 알림마당 쓰기/수정 화면 호출함수 
	 */
	@RequestMapping(value = "/ezCommunity/board/bbsEditNew.do")
	public String bbsEditNew(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception{
		String code = "", sRadio = "", keyword = "", cID = "", no = "", fileName = "", title = "", grsUserName = "", attachFiles = "", writeFakerName = "";
		int pagec = 0, block = 0;
		String step = "", level = "", ref = "";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

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
		
		int adminCheck = ezCommunityService.bbsAdminCheck(userInfo.getId(), userInfo.getRollInfo());*/
		String serverName = request.getServerName();
		CommunityCBoardVO cBoardVO = null;
		
		if (!no.equals("")) { //  수정(mode :  "edit")  또는 답변(mode :  "write")

			fileName = ezCommunityService.bbsEditGet1(bName, no);
			cBoardVO = ezCommunityService.bbsEditNew(bName, no, commonUtil.getMultiData(userInfo.getLang()));
			
			 if (!no.equals("")) { // 수정(mode : "edit") 답변 (mode : "write")
				 if (userInfo.getLang().equals("2")) {
					 grsUserName = userInfo.getDisplayName2();
				 } else {
					 grsUserName = userInfo.getDisplayName1();
				 }
			 } else {
				 if (commonUtil.getMultiData(userInfo.getLang()).equals("2")) {
					 grsUserName = cBoardVO.getUserName2();
				 } else {
					 grsUserName = cBoardVO.getUserName();
				 }
			 }
			 
			 if (commonUtil.getMultiData(userInfo.getLang()).equals("2")) {
				 writeFakerName = cBoardVO.getUserName2();
			 } else {
				 writeFakerName = cBoardVO.getUserName();
			 }
		} else { // 쓰기(mode :  "write")
			if (userInfo.getLang().equals("2")) {
				grsUserName = userInfo.getDisplayName2();
			} else {
				grsUserName = userInfo.getDisplayName1();
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
		model.addAttribute("userInfoUserNM1", userInfo.getDisplayName1());
		model.addAttribute("userInfoUserNM2", userInfo.getDisplayName2());
		model.addAttribute("userInfoUserID", userInfo.getId());
		model.addAttribute("serverName", serverName);
		model.addAttribute("cBoard", cBoardVO);
		model.addAttribute("step", step);
		model.addAttribute("level", level);
		model.addAttribute("gref", ref);
		
		return "/ezCommunity/board/bbsEditNew";
	}
	
	/**
	 * 알림마당 쓰기/수정 실행함수 
	 */
	@RequestMapping(value = "/ezCommunity/bbsEditOk.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String bbsEditOk(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlData, HttpServletRequest request) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
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
        	int adminCheck = ezCommunityService.bbsAdminCheck(userInfo.getId(), userInfo.getRollInfo());

        	if (cBoard != null) {
        		//TODO rollInfo에 t=1권한이 잇어야 자기 글을 삭제 할수 있으나 같은 계정의 글이라도 t=1이 없음
    			//if (cBoard.getId().trim().equals(userInfo.getId()) || adminCheck == 1 || userInfo.getRollInfo().indexOf("t=1") > 0) {
        		if (cBoard.getId().trim().equals(userInfo.getId()) || adminCheck == 1) {
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

        	String nowDate = EgovDateUtil.getTodayTime();
        	
        	ezCommunityService.bbsEditOkInsert(bName.toUpperCase(), myRef, newStep, newLevel, attachList, number, textContent, nowDate, fileName, code, userInfo.getCompanyID(), userInfo.getId(), userNm, userNm2, title, maxIdFieldName);
        	
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
	 * ckeditor 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/ckEditor.do")
	public String ckEditor(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception{
		String pMode = "";
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		if(request.getParameter("DraftFlag") != null){
			pMode = request.getParameter("DraftFlag");
		}

		model.addAttribute("userInfo",userInfo);
		model.addAttribute("pMode", pMode);
		
		return "/ezCommunity/CKEditor";
	}
	
	/**
	 * mht파일 read 실행함수
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
	 * 알림마당 Delete 실행함수
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
	 * 방명록 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/guestOne.do")
	public String guestOne(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = "", keyword = "", sRadio = "";
		int totalPage = 0, curPage = 0, nowBlock = 0, comNoPerPage = 5;
		
		String code = request.getParameter("code");
		
		if (request.getParameter("mode") != null) {
			mode = request.getParameter("mode");
		}
		if (request.getParameter("keyword") != null) {
			keyword = request.getParameter("keyword");
		}
		if (request.getParameter("sRadio") != null) {
			sRadio = request.getParameter("sRadio").toUpperCase();
		}
		if (request.getParameter("gotoPage") != null) {
			curPage = Integer.parseInt(request.getParameter("gotoPage"));
		} else {
			curPage = 1;
		}
		if (request.getParameter("block") != null) {
			nowBlock = Integer.parseInt(request.getParameter("block"));
		}
		
		ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 0, response);
		
		int keywordCount = Integer.parseInt(ezCommunityService.guestOneGet1(sRadio, keyword, code, commonUtil.getMultiData(userInfo.getLang())));
		totalPage = keywordCount / comNoPerPage;

        if ((totalPage * comNoPerPage) != keywordCount && (keywordCount % comNoPerPage) != 0) {
            totalPage = totalPage + 1;
        }
        
        List<CommunityCClubGuestVO> list = ezCommunityService.guestOneGet2(sRadio, keyword, code, commonUtil.getMultiData(userInfo.getLang()));
        
        StringBuilder sb = new StringBuilder();
        int i = 0;
        sb.append("<DATA>");
        
        for (CommunityCClubGuestVO item : list) {
        	i++;
        	
        	if (i > comNoPerPage * curPage) {
        		break;
        	}
        	
        	if (i > comNoPerPage * curPage -5) {
	        	sb.append("<ROW>");
	        	sb.append("<NO>" + item.getNo() + "</NO>");
	        	sb.append("<ID>" + item.getId().trim() + "</ID>");
	        	sb.append("<USERNAME>" + item.getUserName() + "</USERNAME>");
	        	sb.append("<USERNAME2>" + item.getUserName2() + "</USERNAME2>");
	        	sb.append("<COMPANYID>" + item.getCompanyID() + "</COMPANYID>");
	        	sb.append("<TITLE>" + item.getTitle() + "</TITLE>");
	        	sb.append("<CONTENT>" + item.getContent().trim() + "</CONTENT>");
	        	sb.append("<CONTENTURL>" + item.getContentURL() + "</CONTENTURL>");
	        	sb.append("<READNUM>" + item.getReadNum() + "</READNUM>");
	        	sb.append("<WRITEDAY>" + item.getWriteDay() + "</WRITEDAY>");
	        	if (EgovDateUtil.getDaysDiff(EgovDateUtil.getToday("-"), item.getWriteDay().split(" ")[0]) >= 0 ) {
	        		sb.append("<NEW>" + "NEW" + "</NEW>");
	        	}
	        	sb.append("<C_NO>" + item.getC_No() + "</C_NO>");
	        	sb.append("<C_CLUBNO>" + item.getC_clubNo() + "</C_CLUBNO>");
	        	sb.append("</ROW>");
        	}
        }
        
        sb.append("</DATA>");
        
		model.addAttribute("code", code);
		model.addAttribute("mode", mode);
		model.addAttribute("keyword", keyword);
		model.addAttribute("sRadio", sRadio);
		model.addAttribute("curPage", curPage);
		model.addAttribute("nowBlock", nowBlock);
		model.addAttribute("totalPage", totalPage);	
		model.addAttribute("keywordCount", keywordCount);
		model.addAttribute("lang", commonUtil.getMultiData(userInfo.getLang()));
		model.addAttribute("strXML" , sb.toString());
		model.addAttribute("disable" , false);
		
		return "/ezCommunity/communityGuestOne";
	}
	
	/**
	 * 방명록 수정화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/guestEdit.do")
	public String guestEdit(@CookieValue("loginCookie") String loginCookie, CommunityCClubGuestVO item, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		String mode = request.getParameter("mode");
		String no = request.getParameter("no");

		boolean bIsMyContent = false;
		
		item.setId(userInfo.getId());
		item.setUserName(userInfo.getDisplayName1());
		item.setUserName2(userInfo.getDisplayName2());
		
		if (mode.equals("edit")) {
			item = ezCommunityService.guestEditGet(code, commonUtil.getMultiData(userInfo.getLang()), no, userInfo.getId());
			
			if (item != null) {
				bIsMyContent = true;
			}
		}
		
		model.addAttribute("code", code);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("mode", mode);
		model.addAttribute("no", no);
		model.addAttribute("item", item);
		model.addAttribute("bIsMyContent", bIsMyContent);
		
		return "/ezCommunity/communityGuestEdit";
	}
	
	/**
	 * 방명록 쓰기/수정/삭제 실행함수 
	 */
	@RequestMapping(value = "/ezCommunity/guestEditOk.do")
	public String guestEditOk(@CookieValue("loginCookie") String loginCookie, ModelMap model, CommunityCClubGuestVO item, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		boolean bIsMyContent = false;
		String[] cNo = request.getParameterValues("c_no");
		
		String code = request.getParameter("code");
		String mode = request.getParameter("mode");
		//TORO 글쓰기할때 글 내용인가?
		String memo = request.getParameter("memo");
		
		System.out.println(memo);
		
		switch (mode) {
			case "write" :
				ezCommunityService.guestEditOkInsert(code, userInfo, memo);
				
				break;
				
			case "delete" :
				for (String no : cNo){
					item = ezCommunityService.guestEditGet(code, commonUtil.getMultiData(userInfo.getLang()), no, userInfo.getId());
					
					if (item != null) {
						bIsMyContent = true;
						ezCommunityService.guestEditOkDelete(no, code);
					}
				}
				
				break;
				
			case "edit" :
				for (String no : cNo){
					item = ezCommunityService.guestEditGet(code, commonUtil.getMultiData(userInfo.getLang()), no, userInfo.getId());
					
					if (item != null) {
						bIsMyContent = true;
						ezCommunityService.guestEditOkUpdate(no, code, memo, userInfo.getId());
					}
				}
				
				break;
		}
		
		model.addAttribute("mode", mode);
		model.addAttribute("code", code);
		model.addAttribute("bIsMyContent", bIsMyContent);
		
		return "/ezCommunity/communityGuestEditOk";
	}

	/**
	 * 설문조사 목록 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollMain.do")
	public String pollMain(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		int guest = 0;
		boolean disable = false;
		String pollState = "", pollManager = "";
		String code = request.getParameter("code");
		String userLevel = request.getParameter("userLevel");
		
		ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 0, response);
		
		userLevel = ezCommunityService.pollMainGet1(userInfo.getId(), code);
		
		if (userLevel == null) {
			userLevel = "0";
		}
		
		List<CommunityCPollManagerVO> list = ezCommunityService.pollMainGet2(code);
		
		StringBuilder sb = new StringBuilder();
		
		for (CommunityCPollManagerVO item : list) {

			if (EgovDateUtil.getToday("-").compareTo(item.getPollStartDate().substring(0, 10)) < 0) {
				pollState = egovMessageSource.getMessage("ezCommunity.t677", new Locale(globals.getProperty("Globals.language")));
				pollManager = egovMessageSource.getMessage("ezCommunity.t678", new Locale(globals.getProperty("Globals.language")));
			} else {
				if (EgovDateUtil.getToday("-").compareTo(item.getPollStartDate().substring(0, 10)) >= 0 && EgovDateUtil.getToday("-").compareTo(item.getPollEndDate().substring(0,10)) <= 0) {
					pollState = egovMessageSource.getMessage("ezCommunity.t679", new Locale(globals.getProperty("Globals.language")));
					pollManager = egovMessageSource.getMessage("ezCommunity.t678", new Locale(globals.getProperty("Globals.language")));
				} else {
					pollState= egovMessageSource.getMessage("ezCommunity.t680", new Locale(globals.getProperty("Globals.language")));
					pollManager = egovMessageSource.getMessage("ezCommunity.t208", new Locale(globals.getProperty("Globals.language")));
				}
			}
			
			String strQuestionID = ezCommunityService.pollMainGet3(item.getManagerID());
			String strResponseCnt = ezCommunityService.pollMainGet4(strQuestionID);
			
			sb.append("<tr>");
			sb.append("<td align=\"center\">" + item.getPollGroupNo() + "</td>");
			sb.append("<td>" + item.getPollStartDate().substring(0, 10) + " ~ " + item.getPollEndDate().substring(0, 10) + "</td>");
			sb.append("<td style=\"text-overflow:ellipsis;\" title=\"" + item.getPollSubject() + "\">");
			sb.append("<a style = \"cursor:pointer\" onclick=movepage(\"" + code + "\",\"" + item.getManagerID() + "\",\"" + pollState + "\")>" + item.getPollSubject() + "</a></td>");
			sb.append("<td>" + strResponseCnt + egovMessageSource.getMessage("ezCommunity.t478", new Locale(globals.getProperty("Globals.language"))) + "</td>");
			sb.append("<td>" + pollState + "</td>");
			sb.append("<td>");
			
			if (item.getPollRegUser().equals(userInfo.getId())) {
				if (pollManager.equals(egovMessageSource.getMessage("ezCommunity.t678", new Locale(globals.getProperty("Globals.language"))))) {
					sb.append("<a class=\"imgbtn\" onclick=poll_edit(\"" + code + "\",\"" + item.getManagerID() + "\")><span>" + pollManager + "</span></a>");
				} else if (pollManager.equals(egovMessageSource.getMessage("ezCommunity.t208", new Locale(globals.getProperty("Globals.language"))))) {
					sb.append("<a class=\"imgbtn\" onclick=poll_Delete(\"" + code + "\",\"" + item.getManagerID() + "\")><span>" + pollManager + "</span></a>");
				}
			}
			
			sb.append("</td>");
			sb.append("</tr>");
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("guest", guest);
		model.addAttribute("code", code);
		model.addAttribute("userLevel", userLevel);
		model.addAttribute("disable", disable);
		model.addAttribute("strXML", sb.toString());
		model.addAttribute("chCommunityAdmin", userInfo.getRollInfo().indexOf("t=1"));
		
		return "/ezCommunity/communityPollMain";
	}
	
	/**
	 * 설문조사 등록 화면1 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollAdd.do")
	public String pollAdd(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pState = "", pSubject = "", pStartDate = "", pEndDate = "", pSelType = "", pSelRes1 = "", pSelRes2 = "";
		
		String code = request.getParameter("code");
		
		if (request.getParameter("state") != null) {
			pState = request.getParameter("state");
		}
		
		if (pState.equals("PREV")) {
			if (request.getParameter("subject") != null) {
				pSubject = request.getParameter("subject");
			}
			
			if (request.getParameter("startDate") != null){
				pStartDate = request.getParameter("startDate");
			}
			
			if (request.getParameter("endDate") != null) {
				pEndDate = request.getParameter("endDate");
			}
			
			if (request.getParameter("selType") != null) {
				pSelType = request.getParameter("selType");
			}
			
			if (request.getParameter("selRes1") != null) {
				pSelRes1 = request.getParameter("selRes1");
			}
			
			if (request.getParameter("selRes2") != null) {
				pSelRes2 = request.getParameter("selRes2");
			}
		} else {
			pStartDate = EgovDateUtil.getToday("-");
			pEndDate = EgovDateUtil.getToday("-");
		}
		
		ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 1, response);
		
		String expireDays = "-1";
		
		model.addAttribute("code", code);
		model.addAttribute("expireDays", expireDays);
		model.addAttribute("pState", pState);
		model.addAttribute("pSelType", pSelType);
		model.addAttribute("pSelRes1", pSelRes1);
		model.addAttribute("pSelRes2", pSelRes2);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("startDate", pStartDate);
		model.addAttribute("endDate", pEndDate);
		
		return "/ezCommunity/communityPollAdd";
	}
	
	/**
	 * 설문조사 등록 화면2 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollAddOk.do")
	public String pollAddOk (ModelMap model, HttpServletRequest request) {
		String selRes = "", answerViewType = "", selRes1="0";
		int sel = 0, answerCount = 0, selectedNo = 0;
		StringBuilder sb = new StringBuilder();
		
		String code = request.getParameter("code");
		String mode = request.getParameter("mode");
		String startDate = request.getParameter("startPollYear") + "-" + request.getParameter("startPollMonth") + "-" + request.getParameter("startPollDay");
		String endDate = request.getParameter("endPollYear") + "-" + request.getParameter("endPollMonth") + "-" + request.getParameter("endPollDay");
		String subject = request.getParameter("pollSubject");
		String selType = request.getParameter("selType");
		String selRes2 = request.getParameter("selRes2");
		
		if (request.getParameter("selRes1") != null) {
			selRes1 = request.getParameter("selRes1");
		}
		
		
		if (subject != null) {
			if (selRes1.equals("0")) {
				selRes = selRes2;
				answerViewType = "0";
				sel = 1;
			} else {
				selRes = selRes1;
				answerViewType = selRes;
				sel = 0;
			}
		}
		
		if (sel == 0 && !selType.equals("3")) {
			sb.append("<select size=\"5\" style=\"Width:100%; Height:160px\" id=select1 name=select1>");
			
			switch (selRes) {
				case "1" :
					sb.append("<option value = \"1. " + egovMessageSource.getMessage("ezCommunity.t617", new Locale(globals.getProperty("Globals.language"))) + "\">1. " + egovMessageSource.getMessage("ezCommunity.t618", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					sb.append("<option value = \"2. " + egovMessageSource.getMessage("ezCommunity.t619", new Locale(globals.getProperty("Globals.language"))) + "\">2. " + egovMessageSource.getMessage("ezCommunity.t620", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					sb.append("<option value = \"3. " + egovMessageSource.getMessage("ezCommunity.t621", new Locale(globals.getProperty("Globals.language"))) + "\">3. " + egovMessageSource.getMessage("ezCommunity.t622", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					sb.append("<option value = \"4. " + egovMessageSource.getMessage("ezCommunity.t623", new Locale(globals.getProperty("Globals.language"))) + "\">4. " + egovMessageSource.getMessage("ezCommunity.t624", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					sb.append("<option value = \"5. " + egovMessageSource.getMessage("ezCommunity.t625", new Locale(globals.getProperty("Globals.language"))) + "\">5. " + egovMessageSource.getMessage("ezCommunity.t626", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					
					selectedNo = 1;
					answerCount = 5;
					
					break;
					
				case "2" :
					sb.append("<option value = \"1. " + egovMessageSource.getMessage("ezCommunity.t628", new Locale(globals.getProperty("Globals.language"))) + "\">1. " + egovMessageSource.getMessage("ezCommunity.t629", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					sb.append("<option value = \"2. " + egovMessageSource.getMessage("ezCommunity.t630", new Locale(globals.getProperty("Globals.language"))) + "\">2. " + egovMessageSource.getMessage("ezCommunity.t631", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					sb.append("<option value = \"3. " + egovMessageSource.getMessage("ezCommunity.t632", new Locale(globals.getProperty("Globals.language"))) + "\">3. " + egovMessageSource.getMessage("ezCommunity.t633", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					sb.append("<option value = \"4. " + egovMessageSource.getMessage("ezCommunity.t634", new Locale(globals.getProperty("Globals.language"))) + "\">4. " + egovMessageSource.getMessage("ezCommunity.t635", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					sb.append("<option value = \"5. " + egovMessageSource.getMessage("ezCommunity.t636", new Locale(globals.getProperty("Globals.language"))) + "\">5. " + egovMessageSource.getMessage("ezCommunity.t637", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					
					selectedNo = 2;
					answerCount = 5;
					
					break;
					
				case "3" :
					sb.append("<option value = \"1. " + egovMessageSource.getMessage("ezCommunity.t638", new Locale(globals.getProperty("Globals.language"))) + "\">1. " + egovMessageSource.getMessage("ezCommunity.t639", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					sb.append("<option value = \"2. " + egovMessageSource.getMessage("ezCommunity.t640", new Locale(globals.getProperty("Globals.language"))) + "\">2. " + egovMessageSource.getMessage("ezCommunity.t641", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					sb.append("<option value = \"3. " + egovMessageSource.getMessage("ezCommunity.t632", new Locale(globals.getProperty("Globals.language"))) + "\">3. " + egovMessageSource.getMessage("ezCommunity.t633", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					sb.append("<option value = \"4. " + egovMessageSource.getMessage("ezCommunity.t642", new Locale(globals.getProperty("Globals.language"))) + "\">4. " + egovMessageSource.getMessage("ezCommunity.t643", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					sb.append("<option value = \"5. " + egovMessageSource.getMessage("ezCommunity.t644", new Locale(globals.getProperty("Globals.language"))) + "\">5. " + egovMessageSource.getMessage("ezCommunity.t645", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					
					selectedNo = 3;
					answerCount = 5;
					
					break;
					
				case "11" :
					sb.append("<option value = \"1. Yes.\">1. Yes.</option>");
					sb.append("<option value = \"2. No.\">2. No.</option>");
					
					selectedNo = 4;
					answerCount = 2;
					
					break;
					
				case "12" :
					sb.append("<option value = \"1. " + egovMessageSource.getMessage("ezCommunity.t646", new Locale(globals.getProperty("Globals.language"))) + "\">1. " + egovMessageSource.getMessage("ezCommunity.t647", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					sb.append("<option value = \"2. " + egovMessageSource.getMessage("ezCommunity.t648", new Locale(globals.getProperty("Globals.language"))) + "\">2. " + egovMessageSource.getMessage("ezCommunity.t649", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					
					selectedNo = 5;
					answerCount = 2;
					
					break;
					
				case "13" :
					sb.append("<option value = \"1. " + egovMessageSource.getMessage("ezCommunity.t650", new Locale(globals.getProperty("Globals.language"))) + "\">1. " + egovMessageSource.getMessage("ezCommunity.t651", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					sb.append("<option value = \"2. " + egovMessageSource.getMessage("ezCommunity.t652", new Locale(globals.getProperty("Globals.language"))) + "\">2. " + egovMessageSource.getMessage("ezCommunity.t653", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					
					selectedNo = 6;
					answerCount = 2;
					
					break;
					
				case "14" :
					sb.append("<option value = \"1. " + egovMessageSource.getMessage("ezCommunity.t630", new Locale(globals.getProperty("Globals.language"))) + "\">1. " + egovMessageSource.getMessage("ezCommunity.t631", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					sb.append("<option value = \"2. " + egovMessageSource.getMessage("ezCommunity.t634", new Locale(globals.getProperty("Globals.language"))) + "\">2. " + egovMessageSource.getMessage("ezCommunity.t635", new Locale(globals.getProperty("Globals.language"))) + "</option>");
					
					selectedNo = 7;
					answerCount = 2;
					
					break;
			}
			
			if (selType.equals("2")) {
				answerCount++;
				sb.append("<option value = \"3\">3. " + egovMessageSource.getMessage("ezCommunity.t627", new Locale(globals.getProperty("Globals.language"))) + "</option>");
			}
			
			sb.append("</select>");
		} else {
			if (sel == 1 && !selType.equals("3")) {
				selectedNo = 8;
				
				if(!selType.equals("2")){
					for(int i=1; i <= Integer.parseInt(selRes); i++) {
						sb.append(i + ". <input type= \"text\" name = \"selNo_" + i + "\"><br>");
					}
					
					answerCount = Integer.parseInt(selRes);
				} else {
					selectedNo = 9;
					
					for(int i=1; i <= Integer.parseInt(selRes) - 1; i++) {
						sb.append(i + ". <input type= \"text\" name = \"selNo_" + i + "\"><br>");
					}
					
					answerCount = Integer.parseInt(selRes);
					sb.append(selRes + ". " + egovMessageSource.getMessage("ezCommunity.t627", new Locale(globals.getProperty("Globals.language"))));
				}
			} else {
				if (selType.equals("3")) {
					answerCount = 1;
					selectedNo = 10;
					sb.append(egovMessageSource.getMessage("ezCommunity.t654", new Locale(globals.getProperty("Globals.language"))) + "<input type = \"text\" name = \"selJU\">");
				}
			}
		}
		
		model.addAttribute("mode", mode);
		model.addAttribute("code", code);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("selRes", selRes);
		model.addAttribute("answerCount", answerCount);
		model.addAttribute("sel", sel);
		model.addAttribute("selType", selType);
		model.addAttribute("selectedNo", selectedNo);
		model.addAttribute("selJU", 0);
		model.addAttribute("answerViewType", answerViewType);
		model.addAttribute("subject", subject);
		model.addAttribute("idSpanValue", sb.toString());
		
		return "/ezCommunity/communityPollAddOk";
	}
	
	/**
	 * 설문조사 등록 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/pollAddOkGo.do", method=RequestMethod.POST)
	public void pollAddOkGo(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String questionID = "";
		
		String code = request.getParameter("code");
		String mode = request.getParameter("mode");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String subject = request.getParameter("pollSubject");
		String selRes = request.getParameter("selRes");
		String sel = request.getParameter("sel");
		String selType = request.getParameter("selType");
		String selectedNo = request.getParameter("selectedNo");
		String answerViewType = request.getParameter("answerViewType");
		String answerCount = request.getParameter("answerCount");
		
		
		switch (mode) {
			case "write" :
				int maxNo = Integer.parseInt(ezCommunityService.pollAddOkGoGet1(code));
				maxNo++;
				
				ezCommunityService.pollAddOkGoInsert1(code, maxNo, subject, startDate, endDate, userInfo.getId());
				String managerID = ezCommunityService.pollAddOkGoGet2(code, maxNo);
				
				ezCommunityService.pollAddOkGoInsert2(managerID.trim(), subject, answerCount, selType, answerViewType);
				
				questionID = ezCommunityService.pollAddOkGoGet3(managerID);
				
				int[] selNo = new int [100];
				String[] answerContent = new String [100];
				
				switch (selectedNo) {
					case "1":
						answerContent[1] = "1. " + egovMessageSource.getMessage("ezCommunity.t618", new Locale(globals.getProperty("Globals.language")));
						answerContent[2] = "2. " + egovMessageSource.getMessage("ezCommunity.t620", new Locale(globals.getProperty("Globals.language")));
						answerContent[3] = "3. " + egovMessageSource.getMessage("ezCommunity.t622", new Locale(globals.getProperty("Globals.language")));
						answerContent[4] = "4. " + egovMessageSource.getMessage("ezCommunity.t624", new Locale(globals.getProperty("Globals.language")));
						answerContent[5] = "5. " + egovMessageSource.getMessage("ezCommunity.t655", new Locale(globals.getProperty("Globals.language")));
						
						if (selType.equals("2")) {
							answerContent[6] = "6. " + egovMessageSource.getMessage("ezCommunity.t627", new Locale(globals.getProperty("Globals.language")));
						}
						
						break;
						
					case "2" :
						answerContent[1] = "1. " + egovMessageSource.getMessage("ezCommunity.t629", new Locale(globals.getProperty("Globals.language")));
						answerContent[2] = "2. " + egovMessageSource.getMessage("ezCommunity.t631", new Locale(globals.getProperty("Globals.language")));
						answerContent[3] = "3. " + egovMessageSource.getMessage("ezCommunity.t633", new Locale(globals.getProperty("Globals.language")));
						answerContent[4] = "4. " + egovMessageSource.getMessage("ezCommunity.t635", new Locale(globals.getProperty("Globals.language")));
						answerContent[5] = "5. " + egovMessageSource.getMessage("ezCommunity.t637", new Locale(globals.getProperty("Globals.language")));
						
						if (selType.equals("2")) {
							answerContent[6] = "6. " + egovMessageSource.getMessage("ezCommunity.t627", new Locale(globals.getProperty("Globals.language")));
						}
						
						break;
						
					case "3" :
						answerContent[1] = "1. " + egovMessageSource.getMessage("ezCommunity.t639", new Locale(globals.getProperty("Globals.language")));
						answerContent[2] = "2. " + egovMessageSource.getMessage("ezCommunity.t641", new Locale(globals.getProperty("Globals.language")));
						answerContent[3] = "3. " + egovMessageSource.getMessage("ezCommunity.t633", new Locale(globals.getProperty("Globals.language")));
						answerContent[4] = "4. " + egovMessageSource.getMessage("ezCommunity.t643", new Locale(globals.getProperty("Globals.language")));
						answerContent[5] = "5. " + egovMessageSource.getMessage("ezCommunity.t645", new Locale(globals.getProperty("Globals.language")));
						
						if (selType.equals("2")) {
							answerContent[6] = "6. " + egovMessageSource.getMessage("ezCommunity.t627", new Locale(globals.getProperty("Globals.language")));
						}
						
						break;
						
					case "4" :
						answerContent[1] = "1. Yes.";
						answerContent[2] = "2. No.";
						
						if (selType.equals("2")) {
							answerContent[3] = "3. " + egovMessageSource.getMessage("ezCommunity.t627", new Locale(globals.getProperty("Globals.language")));
						}
						
						break;
						
					case "5" :
						answerContent[1] = "1. " + egovMessageSource.getMessage("ezCommunity.t647", new Locale(globals.getProperty("Globals.language")));
						answerContent[2] = "2. " + egovMessageSource.getMessage("ezCommunity.t649", new Locale(globals.getProperty("Globals.language")));
						
						if (selType.equals("2")) {
							answerContent[3] = "3. " + egovMessageSource.getMessage("ezCommunity.t627", new Locale(globals.getProperty("Globals.language")));
						}
						
						break;
						
					case "6" :
						answerContent[1] = "1. " + egovMessageSource.getMessage("ezCommunity.t651", new Locale(globals.getProperty("Globals.language")));
						answerContent[2] = "2. " + egovMessageSource.getMessage("ezCommunity.t653", new Locale(globals.getProperty("Globals.language")));
						
						if (selType.equals("2")) {
							answerContent[3] = "3. " + egovMessageSource.getMessage("ezCommunity.t627", new Locale(globals.getProperty("Globals.language")));
						}
						
						break;
						
					case "7" :
						answerContent[1] = "1. " + egovMessageSource.getMessage("ezCommunity.t631", new Locale(globals.getProperty("Globals.language")));
						answerContent[2] = "2. " + egovMessageSource.getMessage("ezCommunity.t635", new Locale(globals.getProperty("Globals.language")));
						
						if (selType.equals("2")) {
							answerContent[3] = "3. " + egovMessageSource.getMessage("ezCommunity.t627", new Locale(globals.getProperty("Globals.language")));
						}
						
						break;
						
					case "8" :
						for (int i = 1; i <= Integer.parseInt(answerCount); i++) {
							if (request.getParameter("selNo_" + i) != null) {
								answerContent[i] = i + ". " + request.getParameter("selNo_" + i);
							}
						}
						
						break;
						
					case "9" :
						for (int i = 1; i <= Integer.parseInt(answerCount); i++) {
							if (i == Integer.parseInt(answerCount) && selType.equals("2")) {
								answerContent[i] = i + ". " + egovMessageSource.getMessage("ezCommunity.t627", new Locale(globals.getProperty("Globals.language")));
							} else {
								if (request.getParameter("selNo_" + i) != null) {
									answerContent[i] = request.getParameter("selNo_" + i);
								}
							}
						}
						
						break;
						
					case "10" :
						answerContent[1] = egovMessageSource.getMessage("ezCommunity.t603", new Locale(globals.getProperty("Globals.language")));
						
						break;
				}
				
				for (int i = 1; i <= Integer.parseInt(answerCount); i++) {
					ezCommunityService.pollAddOkGoInsert3(questionID.trim(), i, answerContent[i]);
				}
				
				break;
				
			default :
				break;
		}
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		response.getWriter().write("<script language='javascript'>\n");
		response.getWriter().write("document.location.href = '/ezCommunity/pollMain.do?code=" + code + "';\n");
		response.getWriter().write("</script>");
		response.getWriter().flush();
	}
	
	/**
	 * 설문조사 삭제 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/pollDelete.do")
	public void pollDelete(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		String managerID = request.getParameter("managerID");
		
		String strRegUser = ezCommunityService.pollDeleteGet1(managerID);
		
		if (strRegUser != null) {
			String sysopID = ezCommunityService.pollDeleteGet3(code).trim();

			if (strRegUser.equals(userInfo.getId()) && sysopID.equals(userInfo.getId())) {
				List<CommunityCPollQuestionVO> questionList = ezCommunityService.pollDeleteGet2(managerID);

				for (CommunityCPollQuestionVO question : questionList) {
					List<CommunityCPollAnswerVO> answerList= ezCommunityService.pollDeleteGet4(question.getQuestionID());
					
					for(CommunityCPollAnswerVO answer : answerList) {
						ezCommunityService.pollDeleteDel1(question.getQuestionID(), answer.getAnswerID());
					}
					
					ezCommunityService.pollDeleteDel2(question.getQuestionID());
				}
				
				ezCommunityService.pollDeleteDel3(managerID);
			}
		}
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		response.getWriter().write("<script language='javascript'>\n");
		response.getWriter().write("document.location.href = '/ezCommunity/pollMain.do?code=" + code + "';\n");
		response.getWriter().write("</script>");
		response.getWriter().flush();
	}
	
	/**
	 * 설문조사 읽기화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollRes.do")
	public String poll(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		int isSave = 0, responseCount = 0;
		
		String code = request.getParameter("code");
		String pollManagerID = request.getParameter("pollManagerID");
		String pollState = request.getParameter("pollState");
		
		String userLevel = ezCommunityService.pollResGet1(userInfo.getId(), code);
		
		if (userLevel == null) {
			userLevel = "0";
		}
		
		ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 1, response);
		
		CommunityCPollManagerVO managerVO = ezCommunityService.pollResGet2(pollManagerID);
		CommunityCPollQuestionVO questionVO = ezCommunityService.pollResGet3(pollManagerID);
		
		StringBuilder sb = new StringBuilder();
		
		if (questionVO != null) {
			sb.append("<input type=\"hidden\" name=\"questionID_" + questionVO.getQuestionNo() + "\" value=\"" + questionVO.getQuestionID() + "\">");
			sb.append("<input type=\"hidden\" name=\"answerCount_" + questionVO.getQuestionNo() + "\" value=\"" + questionVO.getAnswerCount() + "\">");
			sb.append("<input type=\"hidden\" name=\"answerType_" + questionVO.getQuestionNo() + "\" value=\"" + questionVO.getAnswerType() + "\">");
			
			CommunityCPollResponseVO responseVO = ezCommunityService.pollResGet5(questionVO.getQuestionID(), userInfo.getId(), userInfo.getCompanyID());
			
			
			if (responseVO != null) {
				isSave = 1;
			}

			int allResponseCount = ezCommunityService.pollResGetAllCount(questionVO.getQuestionID());
			
			sb.append("</table><br>");
			sb.append("<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\">");
			
			List<CommunityCPollAnswerVO> answerList = ezCommunityService.pollResGet6(questionVO.getQuestionID());
			
			for(CommunityCPollAnswerVO answerVO : answerList) {
				switch (questionVO.getAnswerType()) {
					case 1 :
						sb.append("<tr><td class=\"t2\" width=\"50\" align=\"center\">");
						sb.append("<input type=\"radio\" name=pollSelect_" + questionVO.getQuestionNo() + " value=" + answerVO.getAnswerNo());
						
						if (isSave == 1) {
							if (answerVO.getAnswerNo().equals(Integer.toString(responseVO.getAnswerNo()))) {
								sb.append(" checked");
							}
						}
						
						sb.append("></td>");
						sb.append("<td class=\"t2\">" + commonUtil.cleanValue(answerVO.getAnswerContent()) + "</td>");
						
						responseCount = ezCommunityService.pollResGetCount(questionVO.getQuestionID(), answerVO.getAnswerID());
						int percent = 0;
						
						if (allResponseCount != 0) {
							percent = responseCount / allResponseCount * 100;
						}
						
						sb.append("<td class=\"t2\" align=\"center\" width=\"60\">[" + responseCount + "/" + allResponseCount + "]</td>");
						sb.append("<td class=\"t2\" align=\"center\" width=\"60\">[" + percent + "%]</td>");
						sb.append("<td class=\"t2\" align=\"left\" width=\"180\">");
						sb.append("<img src=\"/images/question_bar.gif\" width=\"" + percent + "\" height=\"");
						
						if (percent == 0) {
							sb.append("0");
						} else {
							sb.append("10");
						}
						
						sb.append("\" alt=\"" + percent + "%\" border=\"0\"></td>");
						sb.append("</tr>");

						break;
						
					case 2 :
						sb.append("<tr><td class=\"t2\" width=\"50\" align=\"center\">");
						sb.append("<input type=\"radio\" name=pollSelect_" + questionVO.getQuestionNo() + " value=" + answerVO.getAnswerNo() + " id=\"pollSelectID_" + questionVO.getQuestionNo() + "_" + answerVO.getAnswerNo() + "\"");
						
						if (isSave == 1) {
							if (answerVO.getAnswerNo().equals(Integer.toString(responseVO.getAnswerNo()))) {
								sb.append("checked");
							}
						}
						
						sb.append("></td><td class=\"t2\">");
						
						if (answerVO.getAnswerNo().equals(Integer.toString(questionVO.getAnswerCount()))) {
							sb.append(answerVO.getAnswerNo() + ". " + "<input type=\"text\" name=\"answerETC\" style=\"width:270px\">&nbsp;<a href=\"javascript:etcview( '" + egovMessageSource.getMessage("ezCommunity.t627", new Locale(globals.getProperty("Globals.language"))) + "', '" + questionVO.getQuestionID() + "' );\">" + egovMessageSource.getMessage("ezCommunity.t688", new Locale(globals.getProperty("Globals.language"))) + "</a>");
						} else {
							sb.append(commonUtil.cleanValue(answerVO.getAnswerContent()));
						}
						
						sb.append("</td>");
						
						responseCount = ezCommunityService.pollResGetCount(questionVO.getQuestionID(), answerVO.getAnswerID());
						
						if (allResponseCount != 0) {
                            percent = responseCount * 100 / allResponseCount;
                        } else {
                            percent = 0;
                        }
						
						sb.append("<td class=\"t2\" align=\"center\" width=\"60\">[" + responseCount + "/" + allResponseCount + "]</td>");
						sb.append("<td class=\"t2\" align=\"center\" width=\"60\">[" + percent + "%]</td>");
						sb.append("<td class=\"t2\" align=\"left\" width=\"180\">");
						sb.append("<img src=\"/images/question_bar.gif\" width=\"" + percent + "\" height=\"");
						
						if (percent == 0) {
                            sb.append("0");
                        } else {
                        	sb.append("10");
                        }
						
						sb.append("\" alt=\"" + percent + "%\" border=\"0\"></td></tr>");
						
						break;
						
					case 3 :
						sb.append("<tr><td colspan=\"5\" style=\"padding-left:10px\"><b>" + commonUtil.cleanValue(answerVO.getAnswerContent()) + ": </b> <input type=\"text\" name=\"answerETC\" style=\"width:550px\">");
						sb.append("<input type=hidden name=pollSelect_" + questionVO.getQuestionNo() + ">&nbsp;<a href=\"javascript:etcview('" + egovMessageSource.getMessage("ezCommunity.t207", new Locale(globals.getProperty("Globals.language"))) + "', '" + questionVO.getQuestionID() + "' );\" class=\"imgbtn\" ><span>" + egovMessageSource.getMessage("ezCommunity.t689", new Locale(globals.getProperty("Globals.language"))) + "</span></a>");
						sb.append("</td>");
						sb.append("</tr>");
						
						break;
				}
			}
		}
		
		StringBuilder strHTML = new StringBuilder();
		String name = ezCommunityService.pollResGet4(commonUtil.getMultiData(userInfo.getLang()), managerVO.getPollRegUser());
		
		strHTML.append("<table class=\"mainlist\"  style=\"width:100%;\" ><tr>");
		
		if (managerVO.getPollSubject().indexOf("\r\n") >= 0) {
			strHTML.append("<th title = \"" + managerVO.getPollSubject() + "\" style=\"word-break:break-all;width:80%;white-space:normal;\" >" + egovMessageSource.getMessage("ezCommunity.t686", new Locale(globals.getProperty("Globals.language"))) + "<br/>&nbsp;&nbsp;" + managerVO.getPollSubject().replaceAll("\r\n", "<br/>&nbsp;&nbsp;") + "</th>");
			strHTML.append("<th width=\"\" align=\"right\" >" + egovMessageSource.getMessage("ezCommunity.t687", new Locale(globals.getProperty("Globals.language"))) + "<br/>&nbsp;&nbsp;" + name + "</th>");
		} else {
			strHTML.append("<th title = \"" + managerVO.getPollSubject() + "\" style=\"word-break:break-all;width:80%;white-space:normal;\" >" + egovMessageSource.getMessage("ezCommunity.t686", new Locale(globals.getProperty("Globals.language"))) + managerVO.getPollSubject() + "</th>");
			strHTML.append("<th width=\"\" align=\"right\" >" + egovMessageSource.getMessage("ezCommunity.t687", new Locale(globals.getProperty("Globals.language"))) + name + "</th>");
		}
		
		strHTML.append("</tr>");
		strHTML.append(sb.toString());
		strHTML.append("</table>");
		
		model.addAttribute("code", code);
		model.addAttribute("pollState", pollState);
		model.addAttribute("isSave", isSave);
		model.addAttribute("idSpanValue", strHTML.toString());
		
		return "/ezCommunity/communityPollRes";
	}
	
	/**
	 * 설문조사 응답 실행 함수
	 */
	@RequestMapping(value = "/ezCommunity/pollResOk.do", method = RequestMethod.POST)
	public void pollResOk(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int notResponse = 0;
		
		String code = request.getParameter("code");
		String answerType = request.getParameter("answerType_1");
		String answerETC = request.getParameter("answerETC");
		String pollSelect = request.getParameter("pollSelect_1");
		String answerCount = request.getParameter("answerCount_1");
		String isSave = request.getParameter("isSave");
		String questionID = request.getParameter("questionID_1");
		
		if (answerType.equals("3")) {
			if(answerETC.equals("")) {
				notResponse = 2;
			}
		} else {
			if (answerType.equals("2")) {
				if (pollSelect.equals("")) {
					notResponse = 1;
				} else {
					if (pollSelect.equals(answerCount) && answerETC.equals("")) {
						notResponse = 2;
					}
				}
			} else {
				if (pollSelect.equals("")) {
					notResponse = 1;
				}
			}
		}
		
		if (notResponse == 0) {
			if (answerType.equals("3")) {
				pollSelect = "1";
			} else {
				if (answerType.equals("2")) {
					if (!pollSelect.equals(answerETC)) {
						answerETC = ""; 
					}
				}
			}
			
			ezCommunityService.pollResOkSet(questionID, pollSelect, answerETC, userInfo.getId(), userInfo.getCompanyID(), isSave, answerType, answerCount);
		}
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		if (notResponse == 0) {
			response.getWriter().write("<script language='javascript'>\n");
			response.getWriter().write("document.location.href = '/ezCommunity/pollMain.do?code=" + code + "';\n");
			response.getWriter().write("</script>");
			response.getWriter().flush();
		} else {
			if (notResponse == 1) {
				response.getWriter().write("<script language='javascript'>\n");
				response.getWriter().write("alert(\'" + egovMessageSource.getMessage("ezCommunity.t691", new Locale(globals.getProperty("Globals.language"))) + "\');\n");
				response.getWriter().write("window.history.back();");
				response.getWriter().write("</script>");
				response.getWriter().flush();
			} else {
				response.getWriter().write("<script language='javascript'>\n");
				response.getWriter().write("alert(\'" + egovMessageSource.getMessage("ezCommunity.t692", new Locale(globals.getProperty("Globals.language"))) + "\');\n");
				response.getWriter().write("window.history.back();");
				response.getWriter().write("</script>");
				response.getWriter().flush();
			}
		}
	}
	
	/**
	 * 설문조사 날짜변경화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollEdit.do")
	public String pollEdit(ModelMap model,HttpServletRequest request) throws Exception {
		String pClubNo = request.getParameter("pClubNo");
		String managerID = request.getParameter("managerID");
		
		CommunityCPollManagerVO managerVO = ezCommunityService.pollEditGet1(managerID);
		
		String pStartDate = managerVO.getPollStartDate().split(" ")[0];
		String pEndDate = managerVO.getPollEndDate().split(" ")[0];
		
		CommunityCPollQuestionVO questionVO = ezCommunityService.pollEditGet2(managerID);
		
		model.addAttribute("pClubNo", pClubNo);
		model.addAttribute("managerID", managerID);
		model.addAttribute("managerVO", managerVO);
		model.addAttribute("pStartDate", pStartDate);
		model.addAttribute("pEndDate", pEndDate);
		model.addAttribute("questionVO", questionVO);
		
		return "/ezCommunity/communityPollEdit";
	}
	
	/**
	 * 설문조사 날짜변경 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/pollEditOk.do")
	public void pollEditOk(ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String pClubNo = request.getParameter("pClubNo");
		String managerID = request.getParameter("managerID");
		String subject = request.getParameter("pollSubject");
		String startDate = request.getParameter("startPollYear") + "-" + request.getParameter("startPollMonth") + "-" + request.getParameter("startPollDay");
		String endDate = request.getParameter("endPollYear") + "-" + request.getParameter("endPollMonth") + "-" + request.getParameter("endPollDay");
		
		ezCommunityService.pollEditOkUpdate(subject, startDate, endDate, managerID);
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		response.getWriter().write("<script language='javascript'>\n");
		response.getWriter().write("document.location.href = '/ezCommunity/pollMain.do?code=" + pClubNo + "';\n");
		response.getWriter().write("</script>");
		response.getWriter().flush();
	}
	
	/**
	 * 설문조사 답변 응답보기화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollETCView.do")
	public String pollETCView(ModelMap model, HttpServletRequest request) throws Exception {
		String questionID = request.getParameter("questionID");
		String etc = request.getParameter("etc");
		
		String etcTotal = ezCommunityService.pollETCViewGet(questionID);
		
		if (etcTotal == null) {
			etcTotal = "0";
		}
		
		model.addAttribute("questionID", questionID);
		model.addAttribute("etc", etc);
		model.addAttribute("ETCTotal", etcTotal);
		
		return "/ezCommunity/communityPollETCView";
	}
	
	/**
	 * 설문조사 응답 테이블 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/pollETCTable.do")
	public String pollETCTable(ModelMap model, HttpServletRequest request) throws Exception {
		String questionID = request.getParameter("questionID");
		String etc = request.getParameter("etc");
		
		List<CommunityCPollResponseVO> responseList = ezCommunityService.pollETCTableGet(questionID);
		
		model.addAttribute("questionID", questionID);
		model.addAttribute("etc", etc);
		model.addAttribute("responseList", responseList);
		
		return "/ezCommunity/communityPollETCTable";
	}
	
	/**
	 * 회원목록 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/commViewMember.do")
	public String commViewMember(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String keyword = "", sRadio = "", block = "";
		int curPage = 1;
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		if (request.getParameter("keyword") != null) {
			keyword = request.getParameter("keyword");
		}
		
		if (request.getParameter("sRadio") != null) {
			sRadio = request.getParameter("sRadio");
		}
		
		if (request.getParameter("goToPage") != null) {
			curPage = Integer.parseInt(request.getParameter("goToPage"));
		}
		
		if (request.getParameter("block") != null) {
			block = request.getParameter("block");
		}
		
		String code = request.getParameter("code");
		
		ezCommunityService.communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 1, response);
		
		String keywordCount = ezCommunityService.commViewMemberGet2(code, commonUtil.getMultiData(userInfo.getLang()), keyword, sRadio);
		
		int comNoPerPage = 10;
        int totalPage = Integer.parseInt(keywordCount) / comNoPerPage;

        if ((totalPage * comNoPerPage) != Integer.parseInt(keywordCount) && (Integer.parseInt(keywordCount) % comNoPerPage) != 0){
        	totalPage = totalPage + 1;
        }
        
		String strSysopID = ezCommunityService.adminMemberListGet2(code).trim();
		
		StringBuilder sb = new StringBuilder();
		
		List<CommunityCClubUserVO> userList = ezCommunityService.commViewMemberGet1(code, commonUtil.getMultiData(userInfo.getLang()), keyword, sRadio);
		
		int iOutputCount = 1;
		
		for(CommunityCClubUserVO user : userList) {
			if (userList.indexOf(user) + 1 <= (curPage - 1) * comNoPerPage) {
				continue;
			}
			
			if (iOutputCount > comNoPerPage) {
				break;
			}
			
			CommunityMemberInfoVO memberInfo = ezCommunityService.commViewMemberGet3(user.getC_ID().trim(), user.getCompanyID(), commonUtil.getMultiData(userInfo.getLang()));
			
			if (userInfo.getLang().equals("2")) {
				memberInfo.setUserName(memberInfo.getUserName2());
			}
			
			sb.append("<tr>");
			sb.append("<td style=\"width:55; height:23; align:center;\">" + (userList.indexOf(user) + 1) + "</td>");
			sb.append("<td>");
			
			if (user.getC_ID().trim().equals(strSysopID)) {
				sb.append("<img src=\"/images/i_master.gif\" border=\"0\" alt=\"" + egovMessageSource.getMessage("ezCommunity.t513", new Locale(globals.getProperty("Globals.language"))) + "\" align=\"absmiddle\" WIDTH=\"15\" HEIGHT=\"9\">");
			}
			
			sb.append("<a href=\"javascript:openinfo1('" + code + "','" + user.getC_ID().trim() + "','" + user.getCompanyID() + "');\" valign=\"bottom\">" + memberInfo.getUserName() + "</a></td>");
			sb.append("<td style=\"width:85\">" + ezCommunityService.getClubMemberInfo(user.getC_ID().trim(), "DESCRIPTION", commonUtil.getMultiData(userInfo.getLang())) + "</td>");
			sb.append("<td style=\"width:85\">" + user.getC_ID().trim() + "</td>");
			sb.append("<td style=\"width:85\">" + user.getC_inDate().substring(0, 10) + "</td>");
			sb.append("<td style=\"width:150\">");
			
			if (user.getC_lastDate() != null) {
				sb.append(user.getC_lastDate().substring(0, 10));
			}
			
			sb.append("</td>");
			sb.append("<td style=\"width:55; align:center\">" + user.getC_visited() + egovMessageSource.getMessage("ezCommunity.t728", new Locale(globals.getProperty("Globals.language"))) + "</td></tr>");
		}
		
		model.addAttribute("curPage", curPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("code", code);
		model.addAttribute("sRadio", sRadio);
		model.addAttribute("keyword", keyword);
		model.addAttribute("nowBlock", block);
		model.addAttribute("keywordCount", keywordCount);
		model.addAttribute("strSysopID", strSysopID);
		model.addAttribute("strXML", sb.toString());
		
		return "/ezCommunity/communityCommViewMember";
	}
	
	/**
	 * 회원탈퇴 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/commOut.do")
	public String commOut(@CookieValue("loginCookie")String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String code = request.getParameter("code");
		
		CommunityClubVO club = ezCommunityService.aspCommInfoGet1(code);
		CommunityMemberInfoVO member = ezCommunityService.commOutGet(club.getC_SysopID().trim(), club.getCompanyID(), commonUtil.getMultiData(userInfo.getLang()));
		
		String sysopName = member.getUserName();
		
		if (sysopName.equals("")) {
			sysopName = egovMessageSource.getMessage("ezCommunity.t398", new Locale(globals.getProperty("Globals.language")));
		}
		
		if(commonUtil.getMultiData(userInfo.getLang()).equals("2")) {
			club.setC_ClubName(club.getC_ClubName2());
		}
		
		String strCategoryPrint = ezCommunityService.categoryPrint(club.getC_Cate_A().trim(), club.getC_Cate_B().trim(), club.getC_Cate_C().trim());
	
		model.addAttribute("code", code);
		model.addAttribute("club", club);
		model.addAttribute("sysopName", sysopName);
		model.addAttribute("str_category_print", strCategoryPrint);
		
		return "/ezCommunity/communityCommOut";
	}
	
	/**
	 * 회원탈퇴 실행함수
	 */
	@RequestMapping(value = "/ezCommunity/commOutOk.do")
	@ResponseBody
	public String commOutOk(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlData, HttpServletRequest request) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDoc = commonUtil.convertStringToDocument(xmlData);
		
		String code = xmlDoc.getElementsByTagName("CODE").item(0).getTextContent();
		String reason = xmlDoc.getElementsByTagName("REASON").item(0).getTextContent();
		
		String retValue = ezCommunityService.commOutOk(userInfo, code, reason);
		
		return retValue;
	}
	
	/**
	 * 관리메뉴 화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/admin/index.do")
	public String adminIndex(HttpServletRequest request, ModelMap model) {
		String flag = "", num = "";
		String code = request.getParameter("code");
		
		if (request.getParameter("flag") != null) {
			flag = request.getParameter("flag");
		}
		
		if (request.getParameter("num") != null) {
			num = request.getParameter("num");
		}
		
		model.addAttribute("code", code);
		model.addAttribute("flag", flag);
		model.addAttribute("num", num);
		
		return "/ezCommunity/communityAdminIndex";
	}
	
	/**
	 * 관리메뉴 왼쪽화면 호출함수
	 */
	@RequestMapping(value = "/ezCommunity/adminLeft.do")
	public String adminLeft(@CookieValue("loginCookie") String loginCookie, ModelMap model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String num = "", pExcludeBoardID = "", flag = "", clickBoard = "", boardID = "";
		String pRootBoardID = "TOP", pSubFlag = "0";
		int pSelectBy = 0;
		
		String code = request.getParameter("code");
		
		if (request.getParameter("num") != null) {
			num = request.getParameter("num");
		}
		
		if (request.getParameter("flag") != null) {
			flag = request.getParameter("flag");
		}
		
		if (request.getParameter("clickBoard ") != null) {
			clickBoard  = request.getParameter("clickBoard ");
		}
		
		if (request.getParameter("boardID ") != null) {
			boardID  = request.getParameter("boardID ");
		}
		
		CommunityClubVO club = ezCommunityService.adminLeftGet(code);
		int sysopCheck = ezCommunityService.noticeSysopCheck(code, userInfo.getId(), userInfo.getRollInfo(), userInfo.getCompanyID());
		
		String boardGroupAdmin_FG = ezCommunityService.checkIfBoardGroupAdmin(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID());
		int pMode = 0;
		
		//TODO 2016-06-01 이효진 t=1 권한 없음 
//		if (boardGroupAdmin_FG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("t=1") > -1)
		if (boardGroupAdmin_FG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1) {
			pMode = 0;
		} else {
			pMode = 1;
		}

		String retXML = ezCommunityService.getBoardTree(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, code, commonUtil.getMultiData(userInfo.getLang()));
		
		if (retXML.substring(0, 5).toUpperCase().equals("ERROR")){
            retXML = "<RESULT>ERROR</RESULT>";
		}
		
		model.addAttribute("code", code);
		model.addAttribute("num", num);
		model.addAttribute("clickBoard", clickBoard);
		model.addAttribute("boardID", boardID);
		
		model.addAttribute("flag", flag);
		model.addAttribute("club", club);
		model.addAttribute("xmlret", retXML);
		
		return "/ezCommunity/communityAdminLeft";
	}
}

