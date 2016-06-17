package egovframework.ezEKP.ezCommunity.service.impl;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.PrintWriter;
import java.security.PrivateKey;
import java.util.ArrayList;
import java.util.HashMap;
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

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezCommunity.dao.EzCommunityDAO;
import egovframework.ezEKP.ezCommunity.service.EzCommunityService;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardInfoVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemAttachmentVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemReadVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardListVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardPropertyVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardTreeVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCCategoryVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubGuestVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubUserVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCComCloseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCOutApplicationVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollAnswerVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollManagerVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollQuestionVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollResponseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityLeftCommunityVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMemberInfoVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMyCommunityVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityOneLineReplyVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

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
	private EgovFileScrty egovFileScrty;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties globals;
	
	@Autowired
	private Properties config;
	
	
	@Override
	public void communityLeftCommunity(LoginVO userInfo, HttpServletRequest request, ModelMap model, String code) throws Exception {
		String  userLevel = "";
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
        
        if (request.getParameter("userLevel") != null) {
            userLevel = request.getParameter("userLevel");
        }
        
        if (code.equals("")) {
        	String vPermit = leftCommunityGet1(code, userInfo.getId());
        	
        	if (vPermit==null) {
        		userLevel = "0";
        	} else {
        		userLevel = vPermit;
//        		joinFlag = true;
        	}
        	
        	String clubConfirmType = leftCommunityGet2(code);
        	
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
        	

        	if (userInfo.getId().equals(leftCommunityGet4(code))) {
        		checkSysop = true;
        	}
        }

        //TODO 2016-04-26 이효진 사용하는 곳이 아직 없어서 주석처리
        /*String rtnVal = commonUtil.getQueryResult(ezCommunityService.leftCommunityGet3(userInfo.getID()));
		xmlcop = commonUtil.convertStringToDocument(rtnVal);*/
		
		model.addAttribute("userLevel",userLevel);
		model.addAttribute("newmemberConfirmType",newMemberConfirmtype);
		model.addAttribute("chCommunityAdmin",userInfo.getRollInfo().indexOf("t=1"));
		model.addAttribute("checkSysop",checkSysop);
	}

	
	@Override
	public String getLeftCommunity(LoginVO userInfo) throws Exception {
		String userID = "";
        StringBuilder sb = new StringBuilder();
        
        userID = userInfo.getId();
        
        List<CommunityLeftCommunityVO> leftCommunityList =leftCommunityGet3(userID);
        
        sb.append("<DATA>");
        
        for (CommunityLeftCommunityVO leftCommunity : leftCommunityList) {
        	sb.append(commonUtil.getQueryResult(leftCommunity));
        }
        
        sb.append("</DATA>");
        
        return sb.toString();
	}

	@Override
	public String getLeftBoardList() throws Exception {
		StringBuilder sb = new StringBuilder();
		List<CommunityCBoardVO> leftBoardList= ezCommunityDAO.getLeftBoardList();
		sb.append("<DATA>");
		
		for (CommunityCBoardVO leftBoard : leftBoardList) {
			sb.append(commonUtil.getQueryResult(leftBoard));
		}
		
		sb.append("</DATA>");
		
		return sb.toString();
	}
	
	@Override
	public void commMakeOk(LoginVO userInfo, CommunityClubVO clubVO, MultipartHttpServletRequest request, HttpServletResponse response) throws Exception {
		String clubName2 = "";
		MultipartFile cClubLogo = null, cClubBanner = null;
		String cCateA = "", cCateB = "", cCateC = "";

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
		
		clubVO = commMakeOkGet1(clubName, cCateA, cCateB, cCateC, commonUtil.getMultiData(userInfo.getLang()));

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
		
		boardNo = commMakeOkGet2();
		boardNo += 1;
		
		if (commMakeOkGet4() == 0) {
			commMakeOkInsert1();
		}
		
		int clubNo = 0;
		clubNo = Integer.parseInt(commMakeOkGet3().trim());
		clubNo ++ ;
		
		String code = "C_"+clubNo;
		int openEmail = 1;
		int openHp = 1;
		int openComp = 1;
		int openHouse = 1;
		int openJob = 1;
		int openSex = 1;
		int openBirth = 0;
		
		commMakeOkInsert2(clubNo, EgovDateUtil.getTodayTime(), clubName, clubName2, cCateA, cCateB, cCateC, clubType, clubConfirmType, intro, isIn, logo, banner, bBoardName[1].trim(), bBoardName[2].trim(), comatt, code, bNotiName[1].trim(), bNotiName[2].trim(), pNewID, boardNo, userInfo.getId(), userInfo.getDisplayName1(), userInfo.getCompanyName1(), userInfo.getDeptName1(), pNewSubID, openEmail, openHp, openComp, openHouse, openJob, openBirth, openSex, userInfo.getCompanyID());
		
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
		
		if (commMakeOkGet6(userInfo.getCompanyID(), userInfo.getId()) == null) {
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
			
			joinOkInsert(companyID, userID, userName, userName2, companyName, companyName2, companyZip, companyAddress, deptName, deptName2, companyTel, companyFax, homeTel, handPhone, eMail, birthDay, gender);
		}
		
		String fileName = "", attachFile = "", onlyFileName = "", extName = "";
		int fileSize = 0, iStart = 0;
		
		if (!cClubLogo.isEmpty()) {
			fileName = code;
			attachFile = cClubLogo.getOriginalFilename();
			fileSize = (int) cClubLogo.getSize();
			onlyFileName = attachFile;
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
			
			commMakeOkSet1(fileName + "_logo" + ".png", fileName + "_thumbnail" + ".png", fileName, fileSize);
		}
		
		//배너파일 생성
		//TODO 2016-05-03 이효진 뷰에서 banner을 사용하지 않아서 파라미터로 받지 않는다.
		if (!cClubBanner.isEmpty()) {
			fileName = code;
			attachFile = cClubBanner.getOriginalFilename();
			fileSize = (int) cClubBanner.getSize();
			onlyFileName = attachFile;
			iStart = onlyFileName.lastIndexOf(".");
			extName = onlyFileName.substring(iStart);
			
			File file = new File(logoPath + fileName + "_banner" + "." + extName);
			cClubBanner.transferTo(file);
			
			commMakeOkSet2(fileName + "_banner" + "." + extName, fileName, fileSize);
		}
		
		if (clubVO == null) {
			response.getWriter().write("<script language='javascript'>\n");
			response.getWriter().write("alert('Community" + egovMessageSource.getMessage("ezCommunity.t1027", new Locale(globals.getProperty("Globals.language"))) + "');\n");
			response.getWriter().write("document.location.href = '/ezCommunity/commMake.do?flag=1';\n");
			response.getWriter().write("</script>");
			response.getWriter().flush();
		}
	}

	@Override
	public String getSubBoard(LoginVO userInfo, HttpServletRequest request) throws Exception {
		String pClubID = "", pRootBoardID = "", pSubFlag = "0", pExcludeBoardID = " ";
		int pSelectBy = 0, pMode = 0;
		String strXML = "";
		
		pClubID = request.getParameter("classID");
		pRootBoardID = request.getParameter("rootBoardID");
		
		if (request.getParameter("subFlag") != null) {
			pSubFlag = request.getParameter("subFlag");
		}
		
		if (request.getParameter("excludeBoardID") != null) {
			pExcludeBoardID = request.getParameter("excludeBoardID");
		}
		if ( request.getParameter("selectFlag") != null) {
			pSelectBy = Integer.parseInt(request.getParameter("selectFlag"));
		}
		
		String boardGroupAdminFG = checkIfBoardGroupAdmin(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID());

		if (boardGroupAdminFG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("t=1") > -1) {
			pMode = 0;
		} else {
			pMode = 1;
		}
		
		strXML = getBoardTree(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, pClubID, commonUtil.getMultiData(userInfo.getLang()));

		return strXML;
	}
	
	
	@Override
	public String goAdminOk(String data, HttpServletRequest request, CommunityClubVO communityClubVO) throws Exception {
		String pClubID = "";
		StringBuilder aspXML = new StringBuilder(), masterXML = new StringBuilder(), isinXML = new StringBuilder(), resultXML = new StringBuilder();
		
		Document xmlDom = commonUtil.convertStringToDocument(data);
		pClubID = xmlDom.getChildNodes().item(0).getTextContent();
		
		//TODO 2016-04-26 이효진  사용하지 않는 Table을 참조해서 Null반환
		List<String> userIDList = goAdminOkGet1();
		aspXML.append("<ASP>");
		
		for (String userID : userIDList) {
			aspXML.append("<VALUE>");
			aspXML.append(userID.trim());
			aspXML.append("</VALUE>");
		}
		aspXML.append("</ASP>");
		
		List<CommunityClubVO> clubList = goAdminOkGet2(pClubID);
		
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


	@Override
	public void checkCommHome(LoginVO userInfo, ModelMap model, HttpServletRequest request) throws Exception {
		String codeName = "", userLevel = "";
		String pRootBoardID = "TOP";
		
		String code = request.getParameter("communityCD");
		userLevel = request.getParameter("userLevel");
		
		if (request.getParameter("communityName") != null) {
			codeName = request.getParameter("communityName");
		}
		
		if (!code.equals("")) {
			String vPermit = leftCommunityGet1(code, userInfo.getId());
        	
        	if (vPermit == null) {
        		userLevel = "0";
        	} else {
        		userLevel = vPermit;
//        		joinFlag = true;
        	}
        	
        	//TODO
        	/*String newMemberConfirmtype = leftCommunityGet2(code);
        	
        	String boardGroupAdminFG = brdCheckIfBoardGroupAdmin(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID());
        	
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
        	

        	if (userInfo.getId().equals(leftCommunityGet4(code))) {
        		checkSysop = true;
        	}*/
		}
		
		model.addAttribute("code", code);
		model.addAttribute("codeName", codeName);
		model.addAttribute("userLevel", userLevel);
	}


	@Override
	public void popupCommHome(LoginVO userInfo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String rootBoardID = "TOP";
		boolean joinFlag = false, checkSysop = false;
		int newMemberConfirmType = 0;
		
		String code = request.getParameter("code");
		String codeName = request.getParameter("codeName");
		String userLevel = request.getParameter("userLevel");

		// 20100119 보안처리 관련 추가작업(권한체크)
		communityConnCHK(userInfo.getId(), code, "", userInfo.getRollInfo(), 0, response);
		
		String strVisit = commHomeGet1(userInfo.getId(), code);
		
		if (strVisit == null || strVisit.substring(0, 10).equals(EgovDateUtil.getToday("-"))) {
			updateLastDate(EgovDateUtil.getTodayTime(), code, userInfo.getId());
		}
		
		String copType = commHomeGet4(code);
		
		if (copType == null) {
			copType = "type1";
		}
		
		//사용하는곳이 없다
		int memberCount = commHomeGet2(code);
		
		String boardGroupAdminFG = checkIfBoardGroupAdmin(rootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID());
		int mode = 0;
		
		if (boardGroupAdminFG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 ||  userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 ||  userInfo.getRollInfo().toLowerCase().indexOf("t=1") > -1) {
			mode = 0;
		} else {
			mode = 1;
		}
		
		String retXML = getBoardTree(rootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), mode, 0, 0, " ", code, commonUtil.getMultiData(userInfo.getLang()));
		
		if (retXML.substring(0, 5).toUpperCase().equals("ERROR")) {
			retXML = "<RESULT>ERROR</RESULT>";
		}
		
		String permit = leftCommunityGet1(code, userInfo.getId());

		if (permit != null) {
			userLevel = permit;
			joinFlag = true;
		} else {
			userLevel = "0";
		}
		
		String confirmType = leftCommunityGet2(code);
		
		if (confirmType != null) {
			newMemberConfirmType = Integer.parseInt(confirmType);
		}
		
		CommunityClubVO clubVO = leftCommunityGet4(code);
		
		if (clubVO.getC_SysopID().trim().equals(userInfo.getId()) && !checkSysop) {
			checkSysop = true;
		}
		
		model.addAttribute("copType", copType);
		model.addAttribute("userLevel", userLevel);
		model.addAttribute("joinFlag", joinFlag);
		model.addAttribute("newMemberConfirmType", newMemberConfirmType);
		model.addAttribute("checkSysop", checkSysop);
		model.addAttribute("retXML", retXML);
	}


	@Override
	public String commHomeInfo(LoginVO userInfo, String code) throws Exception {
		String strSysopID = "";
		
		CommunityClubVO clubVO = aspCommInfoGet1(code);
		
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
		
		String name = xmldomMemberInfo.getElementsByTagName("DISPLAYNAME").item(0).getTextContent().trim();
		String companyNM = xmldomMemberInfo.getElementsByTagName("COMPANY").item(0).getTextContent().trim();
		String deptName = xmldomMemberInfo.getElementsByTagName("DESCRIPTION").item(0).getTextContent().trim();
		String userImage = xmldomMemberInfo.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().trim();
		
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

	@Override
	public String commHomeBoardInfo(HttpServletRequest request) throws Exception {
		StringBuilder sb = new StringBuilder();
		String code = request.getParameter("code");
		
		List<CommunityBoardInfoVO> boardInfoList = copHomeBoardGet(code);
		
		sb.append("<ITEM>");
		sb.append("<BOARDINFO>");
		sb.append("<DATA>");
		
		for(CommunityBoardInfoVO boardInfo: boardInfoList){
			sb.append("<ROW>");
			sb.append("<BOARDID>"+boardInfo.getBoardID()+"</BOARDID>");
			sb.append("<BOARDNAME>"+boardInfo.getBoardName()+"</BOARDNAME>");
			sb.append("<BOARDNAME2>"+boardInfo.getBoardName2()+"</BOARDNAME2>");
			sb.append("<SHOWPOSITION>"+boardInfo.getShowPosition()+"</SHOWPOSITION>");
			sb.append("<SN>"+boardInfo.getSn()+"</SN>");
			sb.append("<GUBUN>"+boardInfo.getGubun()+"</GUBUN>");
			sb.append("</ROW>");
		}
		
		sb.append("</DATA>");
		sb.append("</BOARDINFO>");
		sb.append("<BOARDITEM>");
		
		for(int i = 0; i < boardInfoList.size(); i++){
			String boardID = boardInfoList.get(i).getBoardID();
			List<CommunityBoardItemVO> boardItemList = copHomeBoardItemGet(boardID);
			sb.append("<DATA>");
			
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
			
			sb.append("</DATA>");
		}
		
		sb.append("</BOARDITEM>");
		sb.append("</ITEM>");
		
		return sb.toString();
	}

	@Override
	public void boardItemList(LoginVO userInfo, ModelMap model, HttpServletRequest request, HttpServletResponse response, CommunityBoardPropertyVO boardInfo, CommunityBoardListVO boardList) throws Exception {
		String url = "", pSortBy = "", strXML = "", showAdjacent = "";
		int pPage = 1, totalCount = 0, totalPage = 0;
		String pBoardID = request.getParameter("boardID");
		
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
				totalCount = Integer.parseInt(getNewItemListCount(userInfo.getId()));
				
				if (totalCount < pEndRow) {
					pEndRow = totalCount;
				}
				
                strXML = getNewItemListXML(userInfo.getId(), pStartRow, pEndRow, pSortBy);
            } else {
                showAdjacent = "1";
                totalCount = Integer.parseInt(getBoardTotalItemCount(pBoardID));
                
                if (totalCount < pEndRow) {
					pEndRow = totalCount;
				}
                
                strXML = getBoardListItemXML(userInfo.getId(), pBoardID, pStartRow, pEndRow, pSortBy, userInfo.getLang());
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
		
		model.addAttribute("url", url);
		model.addAttribute("pSortBy", pSortBy);
		model.addAttribute("pPage", pPage);
		model.addAttribute("showAdjacent", showAdjacent);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("strXML", strXML);
	}

	
	@Override
	public void newBoardItem(CommunityBoardItemVO item, CommunityBoardPropertyVO boardInfo, LoginVO userInfo, String pItemID, String pBoardID, String pUrl, String pMode, String expireDays, String strWriterFakeName, String hasAttach) throws Exception {
		
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
				item = getItemXML(pBoardID, pItemID);
				
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

                if (item.getAttachments() != null && item.getAttachments().length() > 0) {
                	hasAttach = "YES";
                }
			}
		}
	}


	@Override
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
		
		String pDirPath = request.getServletContext().getRealPath("") + config.getProperty("upload_community.ROOT") + commonUtil.separator;
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


	@Override
	public void boardItemView(LoginVO userInfo, CommunityBoardPropertyVO boardInfo, CommunityBoardItemVO item, String pItemID, String pBoardID, String previousItemID, String previousTitle, String nextItemID, String nextTitle, String cAdmin, String gcAdmin, String pVersionUse, String showAdjacent, String adjacentItemsEnableFlag) throws Exception {
		if (item.getParentWriteDate().compareTo(item.getWriteDate()) > 0) {
			item.setWriteDate(item.getParentWriteDate());
		}
		
		if (item.getEndDate().substring(0, 4).equals("9999")) {
			item.setEndDate(egovMessageSource.getMessage("ezCommunity.t930", new Locale(globals.getProperty("Globals.language"))));
		}
		
		if (adjacentItemsEnableFlag.equals("1") && showAdjacent.equals("1")) {
			Map<String, String> map = getAdjacentItems(pItemID, pBoardID, item.getUpperItemIDTree(), item.getParentWriteDate());
			
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
            
            boardInfo.setBoardGroupAdmin_FG(checkIfBoardGroupAdmin(pBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID()));
            
            if (boardInfo.getBoardGroupAdmin_FG().equals("OK")) {
            	gcAdmin = "OK";
            }
            
            pVersionUse = getVersionInfo(pBoardID); 
		}
		
		if (boardInfo.getGubun() != null) {
			if (boardInfo.getGubun().equals("2")) {
				item.setWriterID("");
				item.setWriterDeptName("");
				item.setWriterCompanyName("");
			}
		}
	}


	@Override
	public String confirmPassword(String itemID, String newPassword) throws Exception {
		String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
		String oldPassword = "";
		
		
		
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		String rpwd = EgovFileScrty.decryptRsa(pk, newPassword);
		
		newPassword = EgovFileScrty.encryptPassword(rpwd, "unknown");
		oldPassword = checkPassword(itemID).trim();
		
		if (newPassword != null && newPassword.trim().equals(oldPassword)) {
			return "OK";
		} else {
			return "NO";
		}
	}


	@Override
	public String leftCommunityGet1(String code, String id) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_USERINFO_USERID", id);
		
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
	public CommunityClubVO leftCommunityGet4(String code) throws Exception {
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
	public void joinOkInsert(String companyID, String userID, String userName, String userName2, String companyName, String companyName2, String companyZip, String companyAddress, String deptName, String deptName2, String companyTel, String companyFax, String homeTel, String handPhone, String eMail, String birthDay, String gender) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_COMPANYID", companyID);
		map.put("v_USERID", userID);
		map.put("v_USERNAME", userName);
		map.put("v_USERNAME2", userName2);
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
		
		String retValue = getBoardTreeGet1(pRootBoardID, pUserID, pDeptID, pCompanyID, pMode, pSubFlag, pSelectBy, pExcludeBoardID, pClubNo, strLang);

        if (retValue != null && retValue.length() > 30) {
    		return retValue;
        }
        
        String pAccessID = pUserID + "," + ezOrganService.getDeptFullPath(pDeptID) + ",EVERYONE";
        String strRollInfo = ezOrganService.getPropertyValue(pUserID, "extensionattribute1");
        
        for (int i = 0; i < pAccessID.split(",").length; i++) {
        	boardTreeList = getBoardTreeGet2(pAccessID.split(",")[i].trim());
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
			CommunityBoardPropertyVO boardInfoTemp = brdGetACL(pBoardID, userDeptPath.split(",")[i].trim());
			
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
		} else if (userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("t=1") > -1) {
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
		} else {
			boardInfo.setAccess_FG(boardInfo.getAccess_FG().trim());
			boardInfo.setBoardAdmin_FG(boardInfo.getBoardAdmin_FG());
			boardInfo.setListView_FG(boardInfo.getListView_FG());
			boardInfo.setRead_FG(boardInfo.getRead_FG());
			boardInfo.setWrite_FG(boardInfo.getWrite_FG());
			boardInfo.setReply_FG(boardInfo.getReply_FG());
			boardInfo.setDelete_FG(boardInfo.getDelete_FG());
		}
		
		CommunityBoardPropertyVO strProp = getBoardProperty(pBoardID);
		
		if (strProp != null) {
			if (strProp.getItemExpires() != null) {
				boardInfo.setExpireDays(Integer.toString(strProp.getItemExpires()));
			}
			
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
	public CommunityBoardPropertyVO brdGetACL(String pBoardID, String pAccessID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", pBoardID);
		map.put("v_pAccessID", pAccessID);
		
		return ezCommunityDAO.brdGetACL(map);
	}
	
	@Override
	public CommunityBoardPropertyVO getBoardProperty(String pBoardID) throws Exception {
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
				sb.append("<Attachments>" + itemList.getAttachments() + "</Attachments>");
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
		Map<String, Object> map = new HashMap<String, Object>();
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
	public String setAsRead(LoginVO userInfo, String boardID, String itemIDList) throws Exception {
		try {
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
			return "OK";
		} catch (Exception e) {
			return "ERROR";
		}
		
	}

	@Override
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
			ezCommunityDAO.deleteItem5(itemID);
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
	public CommunityBoardItemVO getItemXML(String pBoardID, String pItemID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", pBoardID);
		map.put("v_pItemID", pItemID);
		
		return ezCommunityDAO.getItemXML(map);
	}

	@Override
	public String newItem(Document xmlData, String pMode, String realPath) throws Exception {
		String pUploadFilePath = "", pContentLocation = "", pHasAttach = "", pContent = "";
		String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
		boolean saveMHTResult = false;
		CommunityBoardItemVO item = new CommunityBoardItemVO();

		pUploadFilePath = xmlData.getElementsByTagName("FILEPATH").item(0).getTextContent();
		item.setItemID(xmlData.getElementsByTagName("ITEMID").item(0).getTextContent());
		item.setBoardID(xmlData.getElementsByTagName("BOARDID").item(0).getTextContent());
		item.setWriterID(xmlData.getElementsByTagName("WRITERID").item(0).getTextContent().trim());
		item.setWriterName(xmlData.getElementsByTagName("WRITERNAME").item(0).getTextContent().trim());
		item.setWriterName2(xmlData.getElementsByTagName("WRITERNAME2").item(0).getTextContent().trim());
		item.setWriterDeptID(xmlData.getElementsByTagName("DEPTID").item(0).getTextContent());
		item.setWriterDeptName(xmlData.getElementsByTagName("DEPTNAME").item(0).getTextContent());
		item.setWriterDeptName2(xmlData.getElementsByTagName("DEPTNAME2").item(0).getTextContent());
		item.setWriterCompanyID(xmlData.getElementsByTagName("COMPANYID").item(0).getTextContent());
		item.setWriterCompanyName(xmlData.getElementsByTagName("COMPANYNAME").item(0).getTextContent());
		item.setWriterCompanyName2(xmlData.getElementsByTagName("COMPANYNAME2").item(0).getTextContent());
		item.setWriteDate(EgovDateUtil.getTodayTime());
		item.setImportance(Integer.parseInt(xmlData.getElementsByTagName("IMPORTANCE").item(0).getTextContent()));
		item.setTitle(xmlData.getElementsByTagName("TITLE").item(0).getTextContent().trim());
		
		
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
		item.setAttachments(xmlData.getElementsByTagName("ATTACHMENTS").item(0).getTextContent());
		item.setUpperItemIDTree(xmlData.getElementsByTagName("UPPERITEMIDTREE").item(0).getTextContent());
		
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
		
		if (pMode.equals("copy")){
			if (!xmlData.getElementsByTagName("DOCPASSWORD").item(0).getTextContent().equals("")) {
				item.setDocPassword(xmlData.getElementsByTagName("DOCPASSWORD").item(0).getTextContent());
			}
		} else {
			if (!xmlData.getElementsByTagName("DOCPASSWORD").item(0).getTextContent().equals("")) {
				PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
				String rpwd = EgovFileScrty.decryptRsa(pk, xmlData.getElementsByTagName("DOCPASSWORD").item(0).getTextContent());
				item.setDocPassword(EgovFileScrty.encryptPassword(rpwd, "unknown"));
			}
		}
		
		if (!pMode.equals("copy")) {
			saveMHTResult = saveMHT(pContent, item.getItemID(), item.getBoardID(), pUploadFilePath, realPath);
			
			if (saveMHTResult == false) {
				return egovMessageSource.getMessage("ezCommunity.lhj04", new Locale(globals.getProperty("Globals.language")));
			}
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
			ezCommunityDAO.brdUpdateItem(map);
		} else {
			ezCommunityDAO.brdNewItem(map);
		}
		
		ezCommunityDAO.newItemDel(item.getItemID());
		
		if (item.getAttachments().length() > 0) {
			if (saveAttachmentsInfo(item.getAttachments(), item.getItemID(), item.getBoardID(), pUploadFilePath, item.getExtensionAttribute5(), realPath) == false) {
				return egovMessageSource.getMessage("ezCommunity.lhj05", new Locale(globals.getProperty("Globals.language")));
			}
			pHasAttach = "1";
		} else {
			pHasAttach = "0";
		}
		
		return "OK";
	}

	@Override
	public boolean saveAttachmentsInfo(String attachments, String itemID, String boardID, String pUploadFilePath, String thumbPath, String realPath) throws Exception {
		String fileSize = "";
		String filePath = "";
		String[] temps = null;
		String fileName = "";
		Map<String, Object> map;
		
		try {
			if (!attachments.substring(attachments.length() - 1).equals(";")) {
				attachments += ";";
			}
			
			for (int i = 0; i < attachments.split(";").length; i++) {
				map = new HashMap<String, Object>();
				File file = new File(realPath + pUploadFilePath + attachments.split(";")[i]);
				fileSize = Integer.toString((int) file.length());
				
				filePath = attachments.split(";")[i];
				
				if (attachments.split(";")[i].indexOf("TempUploadFile") > -1) {
					File destFile = new File(realPath + pUploadFilePath + boardID + commonUtil.separator + "UploadFile" + commonUtil.separator + attachments.split(";")[i].replace("TempUploadFile", ""));
					FileUtils.moveFile(file, destFile);
					filePath = attachments.split(";")[i].replace("TempUploadFile", "");
				}
				
				temps = attachments.split(";")[i].split("_");
				fileName = temps[temps.length-1];

				if (!thumbPath.equals("")) {
					File thumbnailFile = new File(realPath + pUploadFilePath  + thumbPath.split(";"));
					map.put("itemID", itemID);
					
					if (thumbPath.indexOf("TempUpload") > -1) {
						File destThumbFile = new File(realPath+ pUploadFilePath  + boardID + commonUtil.separator + "UploadFile" + commonUtil.separator + thumbPath.split(";")[i].replace("TempUploadFile", ""));
						FileUtils.moveFile(thumbnailFile, destThumbFile);
						map.put("filePath", boardID + commonUtil.separator + "UploadFile" + commonUtil.separator + thumbPath.split(";")[i].replace("TempUploadFile", ""));
					} else {
						map.put("filePath", thumbPath.split(";")[i]);
					}
					ezCommunityDAO.updateAttachInfo(map);
				}
				
				map = new HashMap<String, Object>();
				map.put("itemID", itemID);
				map.put("fileSize", fileSize);
				map.put("fileName", fileName);
				
				if (attachments.split(";")[i].indexOf("TempUploadFile") > -1) {
					map.put("filePath", boardID + commonUtil.separator + "UploadFile" + filePath);
					ezCommunityDAO.insertAttachInfo(map);
				} else {
					map.put("filePath", filePath);
					ezCommunityDAO.insertAttachInfo(map);
				}
			}
			
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	@Override
	public String getItemAttachmentXML(String itemID) throws Exception {
		StringBuilder sb = new StringBuilder();
		List<CommunityBoardItemAttachmentVO> list = ezCommunityDAO.getItemAttachmentXML(itemID);

		sb.append("<NODES>");
		
		for (CommunityBoardItemAttachmentVO attach : list) {
			sb.append("<NODE>");
			sb.append("<ItemID>" + attach.getItemID() + "</ItemID>");
			sb.append("<GUID>" + attach.getGuID() + "</GUID>");
			sb.append("<FilePath>" + attach.getFilePath() + "</FilePath>");
			sb.append("<FileSize>" + getProperSizeDisplay(Integer.parseInt(attach.getFileSize())) + "</FileSize>");
			sb.append("<FileSize2>" + attach.getFileSize() + "</FileSize2>");
			sb.append("</NODE>");
		}
		
		sb.append("</NODES>");
		
		return sb.toString();
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

	@Override
	public Map<String, String> getAdjacentItems(String pItemID, String pBoardID, String upperItemIDTree, String parentWriteDate) throws Exception {
		String previousItemID = "", previousTitle = "", nextItemID = "", nextTitle = "", tempItemID = "", tempTitle = "";
		Map<String, Object> map;
		List<CommunityBoardItemVO> list;
		
		map = new HashMap<String, Object>();
		
		map.put("v_PPARENTWRITEDATE", parentWriteDate);
		map.put("v_PUPPERITEMIDTREE", upperItemIDTree);
		map.put("v_PBOARDID", pBoardID);
		
		list = ezCommunityDAO.getAdjacentItemsGet1(map);
		
		for (CommunityBoardItemVO item : list) {
			if (item.getItemID().equals(pItemID)) {
				previousItemID = tempItemID;
				previousTitle = tempTitle;
			}
			
			if (item.getItemID().equals(pItemID) && list.indexOf(item) < list.size() - 1) {
				nextItemID = list.get(list.indexOf(item) + 1).getItemID().trim();
				nextTitle = list.get(list.indexOf(item) + 1).getTitle().trim();
			}
			
			tempItemID = item.getItemID().trim();
			tempTitle = item.getTitle().trim();
		}

		if (previousItemID.equals("")) {
			map = new HashMap<String, Object>();
			map.put("v_PPARENTWRITEDATE", parentWriteDate);
			map.put("v_PBOARDID", pBoardID);
			
			list = ezCommunityDAO.getAdjacentItemGet2(map);
			
			for (CommunityBoardItemVO item : list) {
				if (item.getItemID().equals(pItemID) && list.indexOf(item) > 0) {
					previousItemID = list.get(list.indexOf(item) - 1).getItemID().trim();
					previousTitle = list.get(list.indexOf(item) - 1).getTitle().trim();
				}
			}
		}
		
		
		if (nextItemID.equals("")) {
			map = new HashMap<String, Object>();
			
			map.put("v_PBOARDID", pBoardID);
			map.put("v_PPARENTWRITEDATE", parentWriteDate);
			map.put("v_PITEMID", pItemID);
			map.put("v_PUPPERITEMIDTREE", upperItemIDTree);
			map.put("v_PREVIOUSITEMID", previousItemID);
			
			CommunityBoardItemVO item = ezCommunityDAO.getAdjacentItemGet3(map);
	
			if (item != null) {
				nextItemID = item.getItemID();
				nextTitle = item.getTitle();
			}
		}
		
		Map<String, String> ret = new HashMap<String, String>();
		
		ret.put("previousItemID", previousItemID);
		ret.put("previousTitle", previousTitle);
		ret.put("nextItemID", nextItemID);
		ret.put("nextTitle", nextTitle);
		
		return ret;
	}

	@Override
	public String getVersionInfo(String pBoardID) throws Exception {
		return ezCommunityDAO.getVersionInfo(pBoardID);
	}

	@Override
	public String getProperSizeDisplay(int pSize) throws Exception {
		if (pSize > 1048576) {
			return Integer.toString((int) (pSize / 1024 / 102.4) / 10) + " MB";
		} else if (pSize > 1024) {
			return Integer.toString((int) (pSize / 102.4)) + " KB";
		} else {
			return Integer.toString(pSize) + " Byte";
		}
	}

	@Override
	public String getReservedItemListXML(String id, int pStartRow, int pEndRow, String pSortBy, String lang) throws Exception {
		StringBuilder sb = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PENDROW", pEndRow);
		map.put("v_STRLANG", commonUtil.getMultiData(lang));
		map.put("v_PUSERID", id);
		map.put("v_PSORTBY", pSortBy);
		
		List<CommunityBoardListVO> list = ezCommunityDAO.getReservedItemListXML(map);

		sb.append("<NODES>");
		
		int count = 0;
		for (CommunityBoardListVO boardList : list) {
			count ++;
			
			if (count >= pStartRow) {
				sb.append("<NODE>");
				sb.append("<BoardID>" + boardList.getBoardID() + "</BoardID>");
				sb.append("<BoardName>" + boardList.getBoardName() + "</BoardName>");
				sb.append("<ItemID>" + boardList.getItemID() + "</ItemID>");
				sb.append("<Title>" + commonUtil.cleanValue(boardList.getTitle()) + "</Title>");
				
				if (boardList.getAttachments() != null) {
					sb.append("<Attachments>" + boardList.getAttachments() + "</Attachments>");
				} else {
					sb.append("<Attachments></Attachments>");
				}
				
				sb.append("<Importance>" + boardList.getImportance() + "</Importance>");
				sb.append("<StartDate>" + boardList.getStartDate() + "</StartDate>");
				sb.append("<EndDate>" + boardList.getEndDate() + "</EndDate>");
				sb.append("<Abstract>" + boardList.getAbsTract() + "</Abstract>");
				sb.append("</NODE>");
			}
		}
		
		sb.append("</NODES>");

		return sb.toString();
	}

	@Override
	public int getReservedItemListCount(String id) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pUserID", id);
		map.put("v_pNow", EgovDateUtil.convertDate(EgovDateUtil.getTodayTime(), "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss", ""));
		
		String result = ezCommunityDAO.getReservedItemListCount(map); 
		
		if (result == null) {
			result = "0";
		}
		
		return Integer.parseInt(result);
	}

	@Override
	public List<CommunityOneLineReplyVO> readOneLineReply(String lang, String pBoardID, String pItemID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERINFO_LANG", lang);
		map.put("v_PBOARDID", pBoardID);
		map.put("v_PITEMID", pItemID);
		
		return ezCommunityDAO.readOneLineReply(map);
	}

	@Override
	public void saveOneLineReply(Document xmlDoc, LoginVO userInfo) throws Exception {
		String userName = "", userName2 = "";
		String pItemID = xmlDoc.getElementsByTagName("ITEMID").item(0).getTextContent();
		String pReplyID = xmlDoc.getElementsByTagName("REPLYID").item(0).getTextContent();
		String pBoardID = xmlDoc.getElementsByTagName("BOARDID").item(0).getTextContent();
		String pContent = xmlDoc.getElementsByTagName("CONTENT").item(0).getTextContent();
		String pPassword = xmlDoc.getElementsByTagName("PASSWORD").item(0).getTextContent();
		String[] u_Name = egovMessageSource.getMessage("ezCommunity.t115", new Locale(globals.getProperty("Globals.language"))).split(";");
		
		CommunityBoardPropertyVO boardInfo = getBoardInfo(userInfo, pBoardID);
		
		if (boardInfo.getGubun() != null) {
			if (boardInfo.getGubun().equals("2")) {
				userName = u_Name[0].trim();
				userName2 = u_Name[1].trim();
			} else {
				userName = userInfo.getDisplayName1();
				userName2 = userInfo.getDisplayName2();
			}
		} else {
			userName = userInfo.getDisplayName1();
			userName2 = userInfo.getDisplayName2();
		}
		
		pContent = pContent.replace("'",  "''");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PITEMID", pItemID);
		map.put("v_PREPLYID", pReplyID);
		map.put("v_PBOARDID", pBoardID);
		map.put("v_USERID", userInfo.getId());
		map.put("v_USERNAME", userName);
		map.put("v_USERNAME2", userName2);
		map.put("v_PCONTENT", pContent);
		map.put("v_PPASSWORD", pPassword);
		
		ezCommunityDAO.saveOneLineReply(map);
	}

	@Override
	public String checkReplyPassword(String pItemID, String pReplyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PItemID", pItemID);
		map.put("v_REPLYID", pReplyID);
		
		return ezCommunityDAO.checkReplyPassword(map);
	}

	@Override
	public String checkOneLineOwner(String pReplyID, String id) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_REPLYID", pReplyID);
		map.put("v_USERINFO_USERID", id);
		map.put("v_pCount", 0);
		
		
		if (ezCommunityDAO.checkOneLineOwner(map) > 0) {
			return "OK_MINE";
		} else {
			return "FAIL";
		}
	}

	@Override
	public String deleteOneLineReply(String id, String pReplyID, String gubun) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERINFO_USERID", id);
		map.put("v_REPLYID", pReplyID);
		map.put("v_GUBUN", gubun);
		
		return ezCommunityDAO.deleteOneLineReply(map);
	}
	
	

	@Override
	public String bbsList(LoginVO userInfo, List<CommunityCBoardVO> cBoardList, String code, int curPage,
			String bName, int comNoPerPage) throws Exception {
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
				/*String file = cBoard.getCharFileName();
				
				if (bName.equals("c_clubpds")) {
					localPdsPath = config.getProperty("upload_community.PDS");	
				} else {
					localPdsPath = config.getProperty("upload_community.PDS1");
				}*/
			
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
		return strHTML.toString();
	}


	@Override
	public List<CommunityBoardItemReadVO> getReaderList(String pBoardID, String pItemID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", pBoardID);
		map.put("v_pItemID", pItemID);
		
		return ezCommunityDAO.getReaderList(map);
	}

	@Override
	public String getACL(String id, String pComID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERINFO_USERID", id);
		map.put("v_PCOMID", pComID);
		
		if (ezCommunityDAO.getACL(map) != null) {
			return "true";
		} else {
			return "false";
		}
	}

	@Override
	public String copyItem(String pOrgItemID, String pOrgBoardID, String pDestItemID, String pDestBoardID, String realPath) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pOrgItemID", pOrgItemID);
		map.put("v_pOrgBoardID", pOrgBoardID);
		
		CommunityBoardItemVO item = ezCommunityDAO.copyItemGet1(map);
		item.setItemID(pDestItemID);
		item.setBoardID(pDestBoardID);
		item.setContentLocation(item.getContentLocation().replaceAll(pOrgBoardID.substring(1, pOrgBoardID.length()-1), pDestBoardID.substring(1, pDestBoardID.length()-1)));
		item.setContentLocation(item.getContentLocation().replaceAll(pOrgItemID.substring(1, pOrgBoardID.length()-1), pDestItemID.substring(1, pDestBoardID.length()-1)));
		item.setStartDate("");
		item.setUpperItemIDTree(pDestItemID);
		item.setItemLevel(1);
		item.setParentWriteDate("");
		
		String pUploadFilePath = realPath + config.getProperty("upload_community.ROOT") + commonUtil.separator;
		
		copyFiles(pOrgItemID, pOrgBoardID, pDestItemID, pDestBoardID, pUploadFilePath);
		List<CommunityBoardItemAttachmentVO> orgAttachList = ezCommunityDAO.copyItemGet2(pOrgItemID);
		
		StringBuilder attachments = new StringBuilder();
		
		for(CommunityBoardItemAttachmentVO itemAttachment : orgAttachList) {
			String orgAttach = itemAttachment.getFilePath();
			String destAttach = itemAttachment.getFilePath().replaceAll(pOrgBoardID.substring(1, pOrgBoardID.length()-1), pDestBoardID.substring(1, pDestBoardID.length()-1));
			
			copyAttachments(orgAttach, destAttach, pDestBoardID, pUploadFilePath);
			attachments.append(destAttach + ";");
		}

		item.setAttachments(attachments.toString());
		if (item.getWriterID() == null) {
			item.setWriterID("");
		}
		if (item.getWriterName() == null) {
			item.setWriterName("");
		}
		if (item.getWriterName2() == null) {
			item.setWriterName2("");
		}
		if (item.getWriterDeptID() == null) {
			item.setWriterDeptID("");
		}
		if (item.getWriterDeptName() == null) {
			item.setWriterDeptName("");
		}
		if (item.getWriterDeptName2() == null) {
			item.setWriterDeptName2("");
		}
		if (item.getWriterCompanyID() == null) {
			item.setWriterCompanyID("");
		}
		if (item.getWriterCompanyName() == null) {
			item.setWriterCompanyName("");
		}
		if (item.getWriterCompanyName2() == null) {
			item.setWriterCompanyName2("");
		}
		if (item.getAbsTract() == null) {
			item.setAbsTract("");
		}
		if (item.getDocPassword() == null) {
			item.setDocPassword("");
		}
		if (item.getExtensionAttribute3() == null) {
        	item.setExtensionAttribute3("");
        }
        if (item.getExtensionAttribute32() == null) {
        	item.setExtensionAttribute32("");
        }
        if (item.getExtensionAttribute4() == null) {
        	item.setExtensionAttribute4("");
        }
        if (item.getExtensionAttribute5() == null) {
        	item.setExtensionAttribute5("");
        }
		
		StringBuilder sb = new StringBuilder();
		sb.append("<NODES>");
        sb.append("<NODE>");
        sb.append("<FILEPATH>" + config.getProperty("upload_community.ROOT") + commonUtil.separator + "</FILEPATH>");
        sb.append("<ITEMID>" + pDestItemID + "</ITEMID>");
        sb.append("<BOARDID>" + pDestBoardID + "</BOARDID>");
        sb.append("<WRITERID>" + item.getWriterID() + "</WRITERID>");
        sb.append("<WRITERNAME>" + item.getWriterName() + "</WRITERNAME>");
        sb.append("<WRITERNAME2>" + item.getWriterName2() + "</WRITERNAME2>");
        sb.append("<DEPTID>" + item.getWriterDeptID() + "</DEPTID>");
        sb.append("<DEPTNAME>" + item.getWriterDeptName() + "</DEPTNAME>");
        sb.append("<DEPTNAME2>" + item.getWriterDeptName2() + "</DEPTNAME2>");
        sb.append("<COMPANYID>" + item.getWriterCompanyID() + "</COMPANYID>");
        sb.append("<COMPANYNAME>" + item.getWriterCompanyName() + "</COMPANYNAME>");
        sb.append("<COMPANYNAME2>" + item.getWriterCompanyName2() + "</COMPANYNAME2>");
        sb.append("<IMPORTANCE>" + item.getImportance() + "</IMPORTANCE>");
        sb.append("<TITLE>" + item.getTitle() + "</TITLE>");
        sb.append("<CONTENTLOCATION>" + item.getContentLocation() + "</CONTENTLOCATION>"); //복사의 경우만
        sb.append("<STARTDATE>" + item.getStartDate() + "</STARTDATE>");
        sb.append("<ENDDATE>" + item.getEndDate() + "</ENDDATE>");
        sb.append("<ABSTRACT>" + item.getAbsTract() + "</ABSTRACT>");
        sb.append("<ATTACHMENTS>" + item.getAttachments() + "</ATTACHMENTS>");
        sb.append("<UPPERITEMIDTREE>" + item.getUpperItemIDTree() + "</UPPERITEMIDTREE>");
        sb.append("<ITEMLEVEL>" + item.getItemLevel() + "</ITEMLEVEL>");
        sb.append("<EXTENSIONATTRIBUTE1>" + item.getExtensionAttribute1() + "</EXTENSIONATTRIBUTE1>");
        sb.append("<EXTENSIONATTRIBUTE2>" + item.getExtensionAttribute2() + "</EXTENSIONATTRIBUTE2>");
        sb.append("<EXTENSIONATTRIBUTE3>" + item.getExtensionAttribute3() + "</EXTENSIONATTRIBUTE3>");
        sb.append("<EXTENSIONATTRIBUTE32>" +item.getExtensionAttribute32() + "</EXTENSIONATTRIBUTE32>");
        sb.append("<EXTENSIONATTRIBUTE4>" + item.getExtensionAttribute4() + "</EXTENSIONATTRIBUTE4>");
        sb.append("<EXTENSIONATTRIBUTE5>" + item.getExtensionAttribute5() + "</EXTENSIONATTRIBUTE5>");
        sb.append("<DOCPASSWORD>" + item.getDocPassword() + "</DOCPASSWORD>");
        sb.append("</NODE>");
        sb.append("</NODES>");

        String ret = newItem(commonUtil.convertStringToDocument(sb.toString()), "copy", realPath);
        
        if(ret.equals("OK")) {
        	ezCommunityDAO.copyUpdate(pDestItemID);
        }
        
		return ret;
	}

	@Override
	public String guestOneGet1(String sRadio, String keyword, String code, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_S_RADIO", sRadio);
		map.put("v_KEYWORD", keyword);
		map.put("v_CODE", code);
		map.put("v_USERINFO_LANG", lang);
		
		return ezCommunityDAO.guestOneGet1(map);
	}

	@Override
	public List<CommunityCClubGuestVO> guestOneGet2(String sRadio, String keyword, String code, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_S_RADIO", sRadio);
		map.put("v_KEYWORD", keyword);
		map.put("v_CODE", code);
		map.put("v_USERINFO_LANG", lang);
		
		return ezCommunityDAO.guestOneGet2(map);
	}

	@Override
	public CommunityCClubGuestVO guestEditGet(String code, String lang, String no, String id) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_USERINFO_LANG", lang);
		map.put("v_DOG", no);
		map.put("v_USERINFO_USERID", id);
		
		return ezCommunityDAO.guestEditGet(map);
	}

	@Override
	public void guestEditOkInsert(String code, LoginVO userInfo, String memo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_USERINFO_USERID", userInfo.getId());
		map.put("v_USERINFO_DISPLAYNAME1", userInfo.getDisplayName1());
		map.put("v_USERINFO_DISPLAYNAME2", userInfo.getDisplayName2());
		map.put("v_USERINFO_COMPANYID", userInfo.getCompanyID());
		map.put("v_MEMO", memo);
		
		ezCommunityDAO.guestEditOkInsert(map);
	}

	@Override
	public void guestEditOkDelete(String no, String code) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_C_NO", no);
		map.put("v_CODE", code);
		
		ezCommunityDAO.guestEditOkDelete(map);
	}

	@Override
	public void guestEditOkUpdate(String no, String code, String memo, String id) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_C_NO", no);
		map.put("v_CODE", code);
		map.put("v_MEMO", memo);
		map.put("v_USERINFO_USERID", id);
		
		ezCommunityDAO.guestEditOkUpdate(map);
	}

	@Override
	public String pollMainGet1(String id, String code) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERINFO_USERID", id);
		map.put("v_CODE", code);
		
		return ezCommunityDAO.pollMainGet1(map);
	}

	@Override
	public List<CommunityCPollManagerVO> pollMainGet2(String code) throws Exception {
		return ezCommunityDAO.pollMainGet2(code);
	}

	@Override
	public String pollMainGet3(String managerID) throws Exception {
		return ezCommunityDAO.pollMainGet3(managerID);
	}

	@Override
	public String pollMainGet4(String strQuestionID) throws Exception {
		return ezCommunityDAO.pollMainGet4(strQuestionID);
	}

	@Override
	public String pollAddOkGoGet1(String code) throws Exception {
		return ezCommunityDAO.pollAddOkGoGet1(code);
	}

	@Override
	public void pollAddOkGoInsert1(String code, int maxNo, String subject, String startDate, String endDate, String id) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_MAXNO", maxNo);
		map.put("v_SUBJECT", subject);
		map.put("v_STARTDATE", startDate);
		map.put("v_ENDDATE", endDate);
		map.put("v_USERINFO_USERID", id);
		
		ezCommunityDAO.pollAddOkGoInsert1(map);
	}

	@Override
	public String pollAddOkGoGet2(String code, int maxNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_MAXNO", maxNo);
		
		return ezCommunityDAO.pollAddOkGoGet2(map);
	}

	@Override
	public void pollAddOkGoInsert2(String managerID, String subject, String answerCount, String selType, String answerViewType) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_MANAGERID", managerID);
		map.put("v_SUBJECT", subject);
		map.put("v_ANSWERCOUNT", answerCount);
		map.put("v_SELTYPE", selType);
		map.put("v_ANSWERVIEWTYPE", answerViewType);
		
		ezCommunityDAO.pollAddOkGoInsert2(map);
	}

	@Override
	public String pollAddOkGoGet3(String managerID) throws Exception {
		return ezCommunityDAO.pollAddOkGoGet3(managerID);
	}

	@Override
	public void pollAddOkGoInsert3(String questionID, int answerNo, String answerContent) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_POLLQUESTIONID", questionID);
		map.put("v_ANSWERNO", answerNo);
		map.put("v_ANSWERCONTENT", answerContent);
		
		ezCommunityDAO.pollAddOkGoInsert3(map);
	}

	@Override
	public String pollDeleteGet1(String managerID) throws Exception {
		return ezCommunityDAO.pollDeleteGet1(managerID);
	}

	@Override
	public String pollDeleteGet3(String code) throws Exception {
		return ezCommunityDAO.pollDeleteGet3(code);
	}

	@Override
	public List<CommunityCPollQuestionVO> pollDeleteGet2(String managerID) throws Exception {
		return ezCommunityDAO.pollDeleteGet2(managerID);
	}

	@Override
	public List<CommunityCPollAnswerVO> pollDeleteGet4(int questionID) throws Exception {
		return ezCommunityDAO.pollDeleteGet4(questionID);
	}

	@Override
	public void pollDeleteDel1(int questionID, int answerID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_QUESTIONID", questionID);
		map.put("v_ANSWERID", answerID);
		
		ezCommunityDAO.pollDeleteDel1(map);
	}

	@Override
	public void pollDeleteDel2(int questionID) throws Exception {
		ezCommunityDAO.pollDeleteDel2(questionID);
	}

	@Override
	public void pollDeleteDel3(String managerID) throws Exception {
		ezCommunityDAO.pollDeleteDel3(managerID);
	}

	@Override
	public String pollResGet1(String id, String code) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERINFO_USERID", id);
		map.put("v_CODE",  code);
		
		return ezCommunityDAO.pollResGet1(map);
	}

	@Override
	public CommunityCPollManagerVO pollResGet2(String pollManagerID) throws Exception {
		return ezCommunityDAO.pollResGet2(pollManagerID);
	}

	@Override
	public CommunityCPollQuestionVO pollResGet3(String pollManagerID) throws Exception {
		return ezCommunityDAO.pollResGet3(pollManagerID);
	}

	@Override
	public CommunityCPollResponseVO pollResGet5(int questionID, String id, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_QUESTIONID", questionID);
		map.put("v_USERINFO_USERID", id);
		map.put("v_USERINFO_COMPANYID", companyID);
		
		return ezCommunityDAO.pollResGet5(map);
	}

	@Override
	public int pollResGetAllCount(int questionID) throws Exception {
		Integer temp = ezCommunityDAO.pollResGetAllCount(questionID);
		
		if (temp != null) {
			return temp;
		} else {
			return 0;
		}
	}

	@Override
	public List<CommunityCPollAnswerVO> pollResGet6(int questionID) throws Exception {
		return ezCommunityDAO.pollResGet6(questionID);
	}

	@Override
	public int pollResGetCount(int questionID, int answerID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_QUESTIONID", questionID);
		map.put("v_ANSWERID", answerID);
		
		
		Integer temp = ezCommunityDAO.pollResGetCount(map);
		
		if (temp != null) {
			return temp;
		} else {
			return 0;
		}
	}

	@Override
	public String pollResGet4(String lang, String pollRegUser) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERINFO_LANG", lang);
		map.put("v_POLLREGUSER", pollRegUser);
		
		return ezCommunityDAO.pollResGet4(map);
	}

	@Override
	public void pollResOkSet(String questionID, String pollSelect, String answerETC, String id, String companyID, String isSave, String answerType, String answerCount) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_QUESTIONID", questionID);
		map.put("v_POLLSELECT", pollSelect);
		map.put("v_ANSWERETC", answerETC);
		map.put("v_USERINFO_USERID", id);
		map.put("v_USERINFO_COMPANYID", companyID);
		map.put("v_ISSAVE", isSave);
		map.put("v_ANSWERTYPE", answerType);
		map.put("v_ANSWERCOUNT", answerCount);
		
		ezCommunityDAO.pollResOkSet(map);
	}

	@Override
	public CommunityCPollManagerVO pollEditGet1(String managerID) throws Exception {
		return ezCommunityDAO.pollEditGet1(managerID);
	}

	@Override
	public CommunityCPollQuestionVO pollEditGet2(String managerID) throws Exception {
		return ezCommunityDAO.pollEditGet2(managerID);
	}

	@Override
	public void pollEditOkUpdate(String subject, String startDate, String endDate, String managerID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SUBJECT", subject);
		map.put("v_POLLSTARTDATE", startDate);
		map.put("v_POLLENDDATE", endDate);
		map.put("v_MANAGERID", managerID);
		
		ezCommunityDAO.pollEditOkUpdate(map);
	}

	@Override
	public String pollETCViewGet(String questionID) throws Exception {
		return ezCommunityDAO.pollETCViewGet(questionID);
	}

	@Override
	public List<CommunityCPollResponseVO> pollETCTableGet(String questionID) throws Exception {
		return ezCommunityDAO.pollETCTableGet(questionID);
	}

	@Override
	public String commViewMemberGet2(String code, String lang, String keyword, String sRadio) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_USERINFO_LANG", lang);
		map.put("v_KEYWORD", keyword);
		map.put("v_S_RADIO", sRadio);
		
		return ezCommunityDAO.commViewMemberGet2(map);
	}

	@Override
	public String adminMemberListGet2(String code) throws Exception {
		return ezCommunityDAO.adminMemberListGet2(code);
	}

	@Override
	public List<CommunityCClubUserVO> commViewMemberGet1(String code, String lang, String keyword, String sRadio) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_USERINFO_LANG", lang);
		map.put("v_KEYWORD", keyword);
		map.put("v_S_RADIO", sRadio);
		
		return ezCommunityDAO.commViewMemberGet1(map);
		
	}

	@Override
	public CommunityMemberInfoVO commViewMemberGet3(String id, String companyID, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERID", id);
		map.put("v_COMPANYID", companyID);
		map.put("v_USERINFO_LANG", lang);
		
		return ezCommunityDAO.commViewMemberGet3(map);
	}

	@Override
	public String getClubMemberInfo(String pCN, String pSearch, String lang) throws Exception {
		Document xmlDoc = commonUtil.convertStringToDocument(ezOrganService.getPropertyList(pCN, pSearch, "1"));
		
		if (lang.equals("2")) {
			return xmlDoc.getElementsByTagName("DESCRIPTION2").item(0).getTextContent();
		} else {
			return xmlDoc.getElementsByTagName("DESCRIPTION1").item(0).getTextContent();
		}
	}

	@Override
	public CommunityMemberInfoVO commOutGet(String cSysopID, String companyID, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_C_SYSOPID", cSysopID);
		map.put("v_COMPANYID", companyID);
		map.put("v_USERINFO_LANG", lang);
		
		return ezCommunityDAO.commOutGet(map);
	}

	@Override
	public String categoryPrint(String c_Cate_A, String c_Cate_B, String c_Cate_C) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		StringBuilder sb = new StringBuilder();
		String cateA = "0";
		String cateB = "0";
		String cateC = "0";
		int caca = 0;
		
		
		if (!c_Cate_A.equals("0")) {
			map = new HashMap<String, Object>();
			
			map.put("v_C_CODE", c_Cate_A);
			map.put("v_C_CAT", "a");
			cateA = ezCommunityDAO.ezCommunityBaseGet3(map);
		}
		
		if (!c_Cate_B.equals("0")) {
			map = new HashMap<String, Object>();
			
			map.put("v_C_CODE", c_Cate_B);
			map.put("v_C_CAT", "b");
			
			cateB = ezCommunityDAO.ezCommunityBaseGet3(map);
		}
		
		if (!c_Cate_C.equals("0")) {
			map = new HashMap<String, Object>();
			
			map.put("v_C_CODE", c_Cate_C);
			map.put("v_C_CAT", "c");
			
			cateC = ezCommunityDAO.ezCommunityBaseGet3(map);
		}
		
		if (!cateA.equals("0")) {
			sb.append(egovMessageSource.getMessage("ezCommunity."+cateA, new Locale(globals.getProperty("Globals.language"))));
			caca = 1;
		}
		
		if (!cateB.equals("0")) {
			if (caca == 1) {
				sb.append(",&nbsp");
			}
			
			sb.append(egovMessageSource.getMessage("ezCommunity."+cateB, new Locale(globals.getProperty("Globals.language"))));
			caca = 1;
		}
		
		if (!cateC.equals("0")) {
			if (caca == 1) {
				sb.append(",&nbsp");
			}
			
			sb.append(egovMessageSource.getMessage("ezCommunity."+cateC, new Locale(globals.getProperty("Globals.language"))));
		}
		
		return sb.toString();
	}

	@Override
	public String commOutOk(LoginVO userInfo, String code, String reason) throws Exception {
		String strReturn = "";
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_USERINFO_USERID", userInfo.getId());
		
		if (ezCommunityDAO.commOutOkGet1(map) != null) {
			strReturn = "<RETURN><VALUE>0</VALUE></RETURN>";
		} else {
			map = new HashMap<String, Object>();
			
			map.put("v_CODE", code);
			map.put("v_USERINFO_USERID", userInfo.getId());
			map.put("v_DATETIME_NOW", EgovDateUtil.getTodayTime());
			map.put("v_REASON", reason);
			
			ezCommunityDAO.commOutOkInsert(map);
			
			strReturn = "<RETURN><VALUE>1</VALUE></RETURN>";
//			SndMail(code);
		}

		return strReturn;
	}

	@Override
	public CommunityClubVO adminLeftGet(String code) throws Exception {
		return ezCommunityDAO.adminLeftGet(code);
	}

	@Override
	public int noticeSysopCheck(String code, String id, String rollInfo, String companyID) throws Exception {
		int sysopCheck = 0;
		String strSysopID = "", strIsIN = "", strCompanyID = "";
		
		if (!code.equals("")) {
			CommunityClubVO club = ezCommunityDAO.ezCommunityBaseGet1(code);
			
			if (club != null) {
				strSysopID = club.getC_SysopID().trim();
                strIsIN = Integer.toString(club.getIsIn());
                strCompanyID = club.getCompanyID().trim();
			}
		}
		
		if (!strSysopID.equals(id)){
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_STRUSERID", id);
			
			String strAdminID = ezCommunityDAO.ezCommunityBaseGet2(map);
			
			if (strAdminID == null && rollInfo.indexOf("c=1") < 0 ) {
				if (strIsIN.equals("1") && strCompanyID.equals(companyID)) {
					sysopCheck = 1;
				} 
			} else {
				sysopCheck = 1;
			}
		} else {
			sysopCheck = 1;
		}
		
		return sysopCheck;
	}

	@Override
	public CommunityMemberInfoVO aspCommInfoGet2(String lang, String sysopID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERINFO_LANG", lang);
		map.put("v_RECORD_C_SYSOPID", sysopID);
		
		return ezCommunityDAO.aspCommInfoGet2(map);
	}

	@Override
	public String adminMemPermitGet1(String code) throws Exception {
		return ezCommunityDAO.adminMemPermitGet1(code);
	}

	@Override
	public String adminBasicGet1(String code) throws Exception {
		return ezCommunityDAO.adminBasicGet1(code);
	}
	
	@Override
	public String adminBasicGet2(String code) throws Exception {
		return ezCommunityDAO.adminBasicGet2(code);
	}

	@Override
	public void adminBasicOkUpdate(CommunityClubVO clubVO, String code) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_C_CLUBNAME", clubVO.getC_ClubName());
		map.put("v_C_CLUBNAME2", clubVO.getC_ClubName2());
		map.put("v_C_CLUBGUBUN", clubVO.getC_ClubGubun());
		map.put("v_C_CLUBTYPE", clubVO.getC_ClubConfirmType());
		map.put("v_ISIN", clubVO.getIsIn());
		map.put("v_C_CLUBDESC", clubVO.getC_ClubDesc());
		map.put("v_CODE", code);
		
		ezCommunityDAO.adminBasicOkIpdate(map);
	}

	@Override
	public CommunityClubVO  adminLogoGet(String code, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_USERINFO_LANG", lang);
		
		return ezCommunityDAO.adminLogoGet(map);
	}

	@Override
	public void adminLogoOkUpdate1(String logoFileNameLogo, String logoFileNameThumbnail, String fileName) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_LOGOFILENAME", logoFileNameLogo);
		map.put("v_LOGOFILENAME_THUMBNAIL", logoFileNameThumbnail);
		map.put("v_FILENAME",  fileName);
		
		ezCommunityDAO.adminLogoOkUpdate1(map);
	}

	@Override
	public void adminCommType(String copType, String fileName) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_COPTYPE", copType);
		map.put("v_FILENAME", fileName);
		
		ezCommunityDAO.adminCommType(map);
	}

	@Override
	public void adminLogoOkUpdate2(String bannerFileName, String fileName) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BANNERFILENAME", bannerFileName);
		map.put("v_FILENAME", fileName);
		
		ezCommunityDAO.adminLoGoOkUpdate2(map);
	}

	@Override
	public List<CommunityBoardInfoVO> getBoardList(String code, String lang, String position) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_LANG", lang);
		map.put("v_POSITION", position);
		
		return ezCommunityDAO.getBoardList(map);
	}

	@Override
	public void adminHomeBoardSet(String clear, String position, int sn, String cn, String boardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CLEAR", clear);
		map.put("v_POSITION", position);
		map.put("v_SN", sn);
		map.put("v_CN", cn);
		map.put("v_BOARDID", boardID);
		
		ezCommunityDAO.adminHomeBoardSet(map);
	}

	@Override
	public Integer boardPropertyGet(String boardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BOARDID", boardID);
		map.put("v_pCount", 0);
		
		return ezCommunityDAO.boardPropertyGet(map);
	}

	@Override
	public void createBoardGroup(String code, String boardGroupID, String boardGroupName, String boardGroupName2, LoginVO userInfo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_BOARDGROUPID", boardGroupID);
		map.put("v_BOARDGROUPNAME", boardGroupName);
		map.put("v_BOARDGROUPNAME2", boardGroupName2);
		map.put("v_USERINFO_USERID", userInfo.getId());
		map.put("v_ACCESSNAME", userInfo.getDisplayName1() + "(" + userInfo.getCompanyName1() + ", " + userInfo.getDeptName1() + ")");
		
		ezCommunityDAO.createBoardGroup(map);
	}

	@Override
	public String saveBoardOrder(String xmlData) throws Exception {
		Document xmlDoc = commonUtil.convertStringToDocument(xmlData);
		String pBoardIDList = xmlDoc.getElementsByTagName("BOARDIDLIST").item(0).getTextContent().trim();
		int pBoardListCount = pBoardIDList.split(";").length;
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardIDList", pBoardIDList);
		map.put("v_pBoardListCount", pBoardListCount);
		map.put("v_err_cd", 0);
		
		ezCommunityDAO.saveBoardOrder(map);
		
		return "OK";
	}

	@Override
	public void deleteBoard() throws Exception {
		ezCommunityDAO.deleteBoard();
	}

	@Override
	public void createBoardInsert(String code, String boardID,
			String boardName, String boardName2, String parentBoardID,
			String boardGroupID, String comatt, LoginVO userInfo)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_BOARDID", boardID);
		map.put("v_BOARDNAME", boardName);
		map.put("v_BOARDNAME2", boardName2);
		map.put("v_PARENTBOARDID", parentBoardID);
		map.put("v_BOARDGROUPID", boardGroupID);
		map.put("v_COMATT", comatt);
		map.put("v_USERINFO_USERID", userInfo.getId());
		map.put("v_USERINFO_DISPLAYNAME", userInfo.getDisplayName1());
		map.put("v_USERINFO_COMPANYNAME", userInfo.getCompanyName1());
		map.put("v_USERINFO_DEPTNAME", userInfo.getDeptName1());
		
		ezCommunityDAO.createBoardInsert(map);
	}

	@Override
	public String moveBoard(String orgBoardID, String newParentBoardID, String newBoardGroupID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pOrgBoardID", orgBoardID);
		map.put("v_pNewParentBoardID", newParentBoardID);
		map.put("v_pNewBoardGroupID", newBoardGroupID);
		
		try{
			ezCommunityDAO.moveBoard(map);
			
			return "OK";
		} catch (Exception e) {
			return "ERROR" + e.getMessage();
		}
	}

	@Override
	public String brdDeleteBoard(String boardID) throws Exception {
		try{
			ezCommunityDAO.brdDeleteBoard(boardID);
			
			return "OK";
		} catch (Exception e) {
			return "ERROR" + e.getMessage();
		}
	}

	@Override
	public String adminSearchItemCount(String id, String boardID, String title, String writerName, String abstracts, String startDateTime, String endDateTime) throws Exception {
		if (boardID.equals("")) {
			boardID = "%%";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PTITLE", title);
		map.put("v_PWRITERNAME", writerName);
		map.put("v_PABSTRACT", abstracts);
		map.put("v_PSTARTDATE", startDateTime);
		map.put("v_PENDDATE", endDateTime);
		
		return ezCommunityDAO.adminSearchItemCount(map);
	}

	@Override
	public String adminSearchItemXML(String id, String boardID, String title, String writerName, String abstracts, String searchStart, String searchEnd, int pStartRow, int pEndRow, String lang) throws Exception {
		StringBuilder sb = new StringBuilder();
		int count = 0;
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PENDROW", pEndRow);
		map.put("v_STRLANG", lang);
		map.put("v_PBOARDID", boardID);
		map.put("v_PTITLE", title);
		map.put("v_PWRITERNAME", writerName);
		map.put("v_PABSTRACT", abstracts);
		map.put("v_PSTARTDATE", searchStart);
		map.put("v_PENDDATE", searchEnd);
		map.put("v_PUSERID", id);
		
		List<CommunityBoardListVO> list = ezCommunityDAO.adminSearchItemXML(map);
        
        sb.append("<NODES>");
		
		for (CommunityBoardListVO board : list) {
			count++;
			
			if (count >= pStartRow) {
				sb.append("<NODE>");
				sb.append("<BoardID>" + board.getBoardID() + "</BoardID>");
				sb.append("<BoardName>" + commonUtil.cleanValue(board.getBoardName()) + "</BoardName>");
				sb.append("<ItemID>" + board.getItemID() + "</ItemID>");
				sb.append("<WriterID>" + commonUtil.cleanValue(board.getWriterID()) + "</WriterID>");
				sb.append("<WriterName>" + commonUtil.cleanValue(board.getWriterName()) + "</WriterName>");
				sb.append("<WriterDeptName>" + commonUtil.cleanValue(board.getWriterDeptName()) + "</WriterDeptName>");
				sb.append("<WriterCompanyName>" + commonUtil.cleanValue(board.getWriterCompanyName()) + "</WriterCompanyName>");
				
				if (board.getWriteDate().equals(board.getParentWriteDate())) {
					sb.append("<WriteDate>" + board.getWriteDate() + "</WriteDate>");
				} else {
					sb.append("<WriteDate>" + board.getParentWriteDate() + "</WriteDate>");
				}
				
				sb.append("<Importance>" + board.getImportance() + "</Importance>");
				sb.append("<Title>" + commonUtil.cleanValue(board.getTitle()) + "</Title>");
				
				if (board.getAttachments().equals("")) {
					sb.append("<Attachments></Attachments>");
				} else {
					sb.append("<Attachments>" + board.getAttachments() + "</Attachments>");
				}
				
				sb.append("<ReadCount>" + board.getReadCount() + "</ReadCount>");
				sb.append("<ItemLevel>" + board.getItemLevel() + "</ItemLevel>");
				sb.append("<ReadFlag>" + board.getReadFlag() + "</ReadFlag>");
				sb.append("<Abstract>" + board.getAbsTract() + "</Abstract>");
				sb.append("</NODE>");
			}
		}
		
		sb.append("</NODES>");
		
		return sb.toString();
	}

	@Override
	public Integer adminOuterListGet1(String code) throws Exception {
		return ezCommunityDAO.adminOuterListGet1(code);
	}

	@Override
	public List<CommunityCOutApplicationVO> adminOuterListGet2(String code, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_USERINFO_LANG", lang);
		
		return ezCommunityDAO.adminOuterListGet2(map);
	}

	@Override
	public void adminOuterOkNoSet(String flag, String userID, String code) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_FLAG", flag);
		map.put("v_USERID", userID);
		map.put("v_CODE", code);
		
		ezCommunityDAO.adminOuterOkNoSet(map);
	}

	@Override
	public Integer adminMemberListGet1(String code) throws Exception {
		return ezCommunityDAO.adminMemberListGet1(code);
	}

	@Override
	public List<CommunityCClubUserVO> adminMemberListGet3(String code, String flag, String lang, String ser) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_FLAG", flag);
		map.put("v_USERINFO_LANG", lang);
		map.put("v_SER", ser);
		
		return ezCommunityDAO.adminMemberListGet3(map);
	}

	@Override
	public CommunityMemberInfoVO getMemberInfo(String companyID, String cID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_COMPANYID", companyID);
		map.put("v_C_ID", cID);
		
		return ezCommunityDAO.getMemberInfo(map);
	}

	@Override
	public CommunityCClubUserVO adminMemberListOkGet(String code, String cID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_C_ID", cID);
		map.put("v_COMPANYID", companyID);
		
		return ezCommunityDAO.adminMemberListOkGet(map);
	}

	@Override
	public Integer adminMemberListOkGetE(String code, String cID) throws Exception {
		Map<String , Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_C_ID", cID);
		map.put("v_pCount", 0);
		
		return ezCommunityDAO.adminMemberListOkGetE(map);
	}

	@Override
	public void adminMemberListOkGoSe(String mode, String code, String cID, String cNm) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_MODE", mode);
		map.put("v_CODE", code);
		map.put("v_C_ID", cID);
		map.put("v_C_NM", cNm);
		
		ezCommunityDAO.adminMemberListGoSE(map);
	}

	@Override
	public String saveBoardProperty(String id, String xmlData) throws Exception {
		try {
			Document xmlDom = commonUtil.convertStringToDocument(xmlData);
			
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("v_pBoardName", xmlDom.getElementsByTagName("BOARDNAME").item(0).getTextContent());
			map.put("v_pBoardName2", xmlDom.getElementsByTagName("BOARDNAME2").item(0).getTextContent());
			map.put("v_pBoardID", xmlDom.getElementsByTagName("BOARDID").item(0).getTextContent());
			map.put("v_pAttachMax", xmlDom.getElementsByTagName("ATTACHMAX").item(0).getTextContent());
			map.put("v_pDescription", xmlDom.getElementsByTagName("DESCRIPTION").item(0).getTextContent());
			map.put("v_pExpires", xmlDom.getElementsByTagName("EXPIRES").item(0).getTextContent());
			map.put("v_pURL", xmlDom.getElementsByTagName("URL").item(0).getTextContent());
			map.put("v_pGubun", xmlDom.getElementsByTagName("GUBUN").item(0).getTextContent());
			map.put("v_pReplyNotify", xmlDom.getElementsByTagName("REPLYNOTIFY").item(0).getTextContent());
			map.put("v_pDeleteAfter", xmlDom.getElementsByTagName("DELETEAFTER").item(0).getTextContent());
			map.put("v_pBoardColor", xmlDom.getElementsByTagName("BOARDCOLOR").item(0).getTextContent());
			map.put("v_pVersionUse", xmlDom.getElementsByTagName("VERSIONUSE").item(0).getTextContent());
			map.put("v_pCheckUse", xmlDom.getElementsByTagName("CHECKUSE").item(0).getTextContent());
			
			ezCommunityDAO.brdSaveBoardProperty(map);
			
			return "OK";
		} catch (Exception e) {
			return "ERROR" + e.getMessage();
		}
	}

	@Override
	public CommunityCComCloseVO adminCommCloseOkGet1(String code) throws Exception {
		return ezCommunityDAO.adminCommCloseOkGet1(code);
	}

	@Override
	public CommunityClubVO adminCommCloseOkGet2(String code) throws Exception {
		return ezCommunityDAO.adminCommCloseOkGet2(code);
	}

	@Override
	public void adminCommCloseOkInser(String code, String commName, String commName2, String sysopID, String companyName, String todayTime, String reason, String closeState) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_COMMNAME", commName);
		map.put("v_COMMNAME2", commName2);
		map.put("v_SYSOPID", sysopID);
		map.put("v_COMPANYNAME", companyName);
		map.put("v_DATETIME_NOW", todayTime);
		map.put("v_REASON", reason);
		map.put("v_CLOSESTATE", closeState);
		
		ezCommunityDAO.adminCommCloseOkInser(map);
	}

	@Override
	public String checkPassword(String pItemID) throws Exception {
		return ezCommunityDAO.checkPassword(pItemID);
	}
	
	@Override
	public void copyFiles(String pOrgItemID, String pOrgBoardID, String pDestItemID, String pDestBoardID, String pRef) throws Exception {
            String orgFilePath = pRef + pOrgBoardID + commonUtil.separator + "doc" + commonUtil.separator + pOrgItemID + ".mht";
            String destFilePath = pRef + pDestBoardID + commonUtil.separator + "doc" + commonUtil.separator + pDestItemID + ".mht";

            File destdir = new File(pRef + pDestBoardID);
            if (!destdir.exists()) {
            	destdir.mkdir();
            	File destdir1 = new File(pRef + pDestBoardID + commonUtil.separator + "doc");
            	destdir1.mkdir();
            	File destdir2 = new File(pRef + pDestBoardID + commonUtil.separator + "UploadFile");
            	destdir2.mkdir();
            }
            
            File orgFile = new File(orgFilePath);
            File destFile = new File(destFilePath);
            
            FileCopyUtils.copy(orgFile, destFile);
	}
	
	@Override
	public void copyAttachments(String pOrgFilePath, String pDestFilePath, String pDestBoardID, String pRef) throws Exception {
        String orgFilePath = pRef + pOrgFilePath;
        String destFilePath = pRef + pDestFilePath;

        File destdir = new File(pRef + pDestBoardID);
        if (!destdir.exists()) {
        	destdir.mkdir();
        	File destdir1 = new File(pRef + pDestBoardID + commonUtil.separator + "doc");
        	destdir1.mkdir();
        	File destdir2 = new File(pRef + pDestBoardID + commonUtil.separator + "UploadFile");
        	destdir2.mkdir();
        }
        
        File orgFile = new File(orgFilePath);
        File destFile = new File(destFilePath);
        
        FileCopyUtils.copy(orgFile, destFile);
	}

	@Override
	public List<String> myCommunityGet(String id, int pStart, int pEnd, String mode) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERID", id);
		map.put("v_PSTART", pStart);
		map.put("v_PEND", pEnd);
		map.put("v_MODE", mode);
		
		return ezCommunityDAO.myCommunityGet(map);
	}

	@Override
	public List<CommunityMyCommunityVO> myCommunityItemGet(String clubNo) throws Exception {
		return ezCommunityDAO.myCommunityItemGet(clubNo);
	}

	@Override
	public List<CommunityMyCommunityVO> mainPageGet5(String lang) throws Exception {
		return ezCommunityDAO.mainPageGet5(lang);
	}

	@Override
	public List<CommunityMyCommunityVO> mainPageGet6(String lang) throws Exception {
		return ezCommunityDAO.mainPageGet6(lang);
	}

	@Override
	public String join1Get(String no, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_NO", no);
		map.put("v_USERINFO_LANG", lang);
		
		return ezCommunityDAO.join1Get(map);
	}

	@Override
	public String joinGet1(String code, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_USERINFO_LANG", lang);
		
		return ezCommunityDAO.joinGet1(map);
	}

	@Override
	public CommunityClubVO adminNoticeMailOkGet1(String code) throws Exception {
		return ezCommunityDAO.adminNoticeMailOkGet1(code);
	}

	@Override
	public String joinGet2(String sysopID, String companyID, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SYSOPID", sysopID);
		map.put("v_COMPANYID", companyID);
		map.put("v_USERINFO_LANG", lang);
		
		return ezCommunityDAO.joinGet2(map);
	}

	@Override
	public String joinOkGet1(String code, String id) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_USERINFO_USERID", id);
		
		return ezCommunityDAO.joinOkGet1(map);
	}

	@Override
	public void joinOkSet1(String code, String id, String todayTime, String companyID) throws Exception {
		Map<String, Object> map =new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_USERINFO_USERID", id);
		map.put("v_DTNOW", todayTime);
		map.put("v_USERINFO_COMPANYID", companyID);
		
		ezCommunityDAO.joinOkSet1(map);
	}

	@Override
	public String joinOkGet2(String code, String id) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_USERINFO_USERID", id);
		
		return ezCommunityDAO.joinOkGet2(map);
	}

	@Override
	public CommunityClubVO joinOkGet3(String code, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_USERINFO_LANG", lang);
		
		return ezCommunityDAO.joinOkGet3(map);
	}

	@Override
	public void JoinOkUpdate1(String id, String code, String cIntro, String openEmail, String openHp, String openComp, String openBirth, String openSex, String openHouse) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERINFO_USERID", id);
		map.put("v_CODE", code);
		map.put("v_C_INTRO", cIntro);
		map.put("v_OPENEMAIL", openEmail);
		map.put("v_OPENHP", openHp);
		map.put("v_OPENCOMP", openComp);
		map.put("v_OPENBIRTH", openBirth);
		map.put("v_OPENSEX", openSex);
		map.put("v_OPENHOUSE", openHouse);
		
		ezCommunityDAO.joinOkUpdate1(map);
	}

	@Override
	public CommunityMemberInfoVO joinOkGet4(String companyID, String id) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERINFO_COMPANYID", companyID);
		map.put("v_USERINFO_USERID", id);
		
		return ezCommunityDAO.joinOkGet4(map);
	}

	@Override
	public void JoinOkUpdate3(String companyID, String id, String birthDay) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERINFO_COMPANYID", companyID);
		map.put("v_USERINFO_USERID", id);
		map.put("v_BIRTHDAY", birthDay);
		
		ezCommunityDAO.joinOkUpdate3(map);
	}

	@Override
	public void joinOkUpdate2(String id, String code, String cIntro, String openEmail, String openHp, String openComp, String openHouse, String openJob, String openBirth, String openSex) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERINFO_USERID", id);
		map.put("v_CODE", code);
		map.put("v_C_INTRO", cIntro);
		map.put("v_OPENEMAIL", openEmail);
		map.put("v_OPENHP", openHp);
		map.put("v_OPENCOMP", openComp);
		map.put("v_OPENHOUSE", openHouse);
		map.put("v_OPENJOB", openJob);
		map.put("v_OPENBIRTH", openBirth);
		map.put("v_OPENSEX", openSex);
		
		ezCommunityDAO.joinOkUpdate2(map);
	}

	@Override
	public String getACLGet1(String cID) throws Exception {
		return ezCommunityDAO.getACLGet1(cID);
	}

	@Override
	public String getACLGet2(String uID, String cID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_UID", uID);
		map.put("v_CID", cID);
		
		return ezCommunityDAO.getACLGet2(map);
	}

	/*public void SndMail(string code)
	{
        try
        {
            string PositionNM = userinfo.Title;			//  직위
            string DeptNM = userinfo.DeptName;		//  부서명
            string CompanyNM = userinfo.CompanyName;		//  회사명
            string mailSendServer = "\"" + userinfo.DisplayName + "\" <" + userinfo.Email + ">";
            string strSql = "";


#if USE_MSSQL
            SqlConnection conn2 = new SqlConnection(GetSystemConfigValue("ezCommunity"));
            SqlCommand comm2 = new SqlCommand("EZSP_COMM_OUT_OK_GET2", conn2);
            comm2.CommandType = CommandType.StoredProcedure;
            comm2.Parameters.Add("@CODE", SqlDbType.NChar, 20).Value = code;
            comm2.Parameters.Add("@USERINFO_LANG", SqlDbType.NChar, 1).Value = GetMultiData(userinfo.lang);
            conn2.Open();
            SqlDataReader EMailRS = comm2.ExecuteReader();
#elif USE_ORACLE
            OracleConnection conn2 = new OracleConnection(GetSystemConfigValue("ezCommunityOra"));
            OracleCommand comm2 = new OracleCommand("EZSP_COMM_OUT_OK_GET2", conn2);
            comm2.CommandType = CommandType.StoredProcedure;
            comm2.Parameters.Add("v_CODE", OracleType.NChar, 20).Value = code;
            comm2.Parameters.Add("v_USERINFO_LANG", OracleType.NChar, 1).Value = GetMultiData(userinfo.lang);
            comm2.Parameters.Add("cv_1", OracleType.Cursor).Direction = ParameterDirection.Output;
            conn2.Open();
            OracleDataReader EMailRS = comm2.ExecuteReader();
#endif
            while (EMailRS.Read())
            {
                if (EMailRS["EMail"].ToString() != "")
                {
                    string CommunityUser = "\"" + EMailRS["UserName"].ToString() + "\" <" + EMailRS["EMail"].ToString() + ">";
                    string content = "[" + EMailRS["c_clubName" + GetMultiData(userinfo.lang)].ToString() + "] " + RM.GetString("t720") + userinfo.DisplayName + " " + RM.GetString("t587") + "< " + reason + " > " + RM.GetString("t721");
                    string strXML = "<DATA>";
                    strXML += "<FROM><![CDATA[" + mailSendServer + "]]></FROM>";
                    strXML += "<TO><![CDATA[" + CommunityUser + "]]></TO>";
                    strXML += "<CC></CC>";
                    strXML += "<BCC></BCC>";
                    strXML += "<SUBJECT><![CDATA[" + "[" + EMailRS["c_clubName" + GetMultiData(userinfo.lang)].ToString() + "] Community" + RM.GetString("t720") + userinfo.DisplayName + " " + RM.GetString("t722") + "]]></SUBJECT>";
                    strXML += "<BODY><![CDATA[" + content + "]]></BODY>";
                    strXML += "</DATA>";

                    // 2011.06 : 메일 노티 페이지 변경
                    string WebServerName = Server.MachineName;
                    string url = Request.Url.Scheme + "://" + WebServerName + "/myoffice/ezEmail/remote/mail_send_noti.aspx";

                    string[] HeaderOption = new string[10];
                    HeaderOption[0] = "Authorization\n" + Request.ServerVariables["HTTP_AUTHORIZATION"];
                    HeaderOption[1] = "Content-Type\ntext/xml; charset=utf-8";
                    HeaderOption[2] = "Accept-Language\nutf-8";

                    string rtnStatus = "";
                    Stream ResponseStream = null;
                    long StreamSize = 0;

                    if (ExecuteWebURL("POST", url, strXML, HeaderOption, ref rtnStatus, ref ResponseStream, ref StreamSize))
                    {
                        if (ResponseStream != null) { ResponseStream.Close(); }
                        if (ResponseStream != null) { ResponseStream = null; }
                    }
                }
            }
            conn2.Close();
            comm2.Dispose();
            conn2.Dispose();
        }
        catch (Exception ex)
        {
            WriteTextLog("ezcomm_comm_out_ok", "SndMail", ex.ToString());
        }
	}*/
	
	
	
	
	
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
