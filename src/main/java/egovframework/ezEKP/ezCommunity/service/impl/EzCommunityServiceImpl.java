package egovframework.ezEKP.ezCommunity.service.impl;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.security.PrivateKey;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
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
import egovframework.ezEKP.ezCommunity.vo.CommunityMemberInfoVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMyCommunityVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityOneLineReplyVO;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzCommunityService")
public class EzCommunityServiceImpl extends EgovAbstractServiceImpl implements EzCommunityService{
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
	
	@Resource(name="EzEmailService")
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Autowired
	private EgovFileScrty egovFileScrty;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties globals;
	
	@Autowired
	private Properties config;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCommunityServiceImpl.class);
	
	@Override
	public String leftCommunityGet2(String code, int tenantID) throws Exception {
		logger.debug("leftCommunityGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.leftCommunityGet2(map);
		
		logger.debug("leftCommunityGet2 ended.");
		
		return result;
	}

	@Override
	public CommunityClubVO leftCommunityGet4(String code, int tenantID) throws Exception {
		logger.debug("leftCommunityGet4 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		CommunityClubVO vo = ezCommunityDAO.leftCommunityGet4(map);
		
		logger.debug("leftCommunityGet4 ended.");
		
		return vo;
	}

	@Override
	public List<CommunityClubVO> getLeftCommunity(LoginVO userInfo) throws Exception {
		logger.debug("getLeftCommunity started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userInfo.getId());
		map.put("tenantID", userInfo.getTenantId());
		
		logger.debug("leftCommunityGet3 started.");
		List<CommunityClubVO> list = ezCommunityDAO.leftCommunityGet3(map);
		logger.debug("leftCommunityGet3 ended.");
		
        logger.debug("getLeftCommunity ended.");
        
        return list;
	}

	@Override
	public List<CommunityCBoardVO> getLeftBoardList(int tenantID) throws Exception {
		logger.debug("getLeftBoardList started.");
		
		List<CommunityCBoardVO> leftBoardList= ezCommunityDAO.getLeftBoardList(tenantID);
		
		logger.debug("getLeftBoardList ended.");
		
		return leftBoardList;
	}
	
	@Override
	public void commMakeUpload(String mode, String fileName, String fileData, String logoPath, int tenantID) throws Exception {
		logger.debug("commMakeUpload started.");
		
		int clubNo = ezCommunityDAO.commMakeOkGet3(tenantID) + 1;
		String code = "C_"+clubNo;
		
		if (mode.equals("logo")) {
			String onlyFileName = fileName.substring(0, fileName.lastIndexOf(".") + 1);
            String ext = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
            String logoTemp = onlyFileName + "_logoTemp" + "." + ext;
            String logoFileName = code + "_logo" + ".png";
            String logoThumbnailFileName = code + "_thumbnail" + ".png";

            
            if (!new File(logoPath).exists()) {
				new File(logoPath).mkdirs();
			}
			
			File file = new File(logoPath + logoTemp);
            byte[] byteList = Base64.decodeBase64(fileData);
            
            FileOutputStream fos = null;
            
            try {
            	fos = new FileOutputStream(file);
                IOUtils.write(byteList, fos);
                
                BufferedImage inputImage = ImageIO.read(file);
    			BufferedImage outputImage = null;
    			Graphics2D saveImage = null;
    			
    			outputImage= new BufferedImage(894, 100, BufferedImage.TYPE_INT_RGB);
    			saveImage = outputImage.createGraphics();
    			saveImage.drawImage(inputImage, 0, 0, 894, 100, null);
    			
    			File newLogo = new File(logoPath + logoFileName);
    			ImageIO.write(outputImage, "png", newLogo);
    			//썸네일파일 생성
    			outputImage = new BufferedImage(198, 140, BufferedImage.TYPE_INT_RGB);
    			saveImage = outputImage.createGraphics();
    			saveImage.drawImage(inputImage, 0, 0, 198, 140, null);
    			
    			File newThumbnail = new File(logoPath + logoThumbnailFileName);
    			ImageIO.write(outputImage, "png", newThumbnail);
            } catch (Exception e) {
            	throw e;
            } finally {
            	fos.close();
            	file.delete();
            }
        }
		
		logger.debug("commMakeUpload ended.");
	}

	@Override
	public void commMakeOk(LoginVO userInfo, CommunityClubVO clubVO, MultipartHttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("commMakeOk started.");
		
		String clubName2 = "";
		MultipartFile cClubLogo = null, cClubBanner = null;
		String cCateA = "", cCateB = "", cCateC = "";

		String clubName = request.getParameter("hiddenClubName");
		String clubType = request.getParameter("clubType");
		String clubConfirmType = request.getParameter("clubConfirmType");
		String intro = request.getParameter("intro");
		String pNewID = request.getParameter("sNewID");
		String pNewSubID = request.getParameter("sNewSubID");
		String logoPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_community.LOGO", userInfo.getTenantId()) + commonUtil.separator;
		String logo = "default_logo_type1.jpg";
		String banner = "default_banner.jpg";
		int isIn = 0, boardNo = 0;
		int tenantID = userInfo.getTenantId();
		
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
		
		String[] bBoardName = egovMessageSource.getMessage("ezCommunity.t1492", userInfo.getLocale()).split(";");
		String[] bNotiName = egovMessageSource.getMessage("ezCommunity.t1493", userInfo.getLocale()).split(";");
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
		
		clubVO = commMakeOkGet1(clubName, cCateA, cCateB, cCateC, commonUtil.getMultiData(userInfo.getLang(), tenantID), tenantID);

		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		if (clubVO != null) {
			response.getWriter().write("<script language='javascript'>");
			response.getWriter().write("alert('" + egovMessageSource.getMessage("ezCommunity.t1029", userInfo.getLocale()) + "');");
			response.getWriter().write("history.back();");			
			response.getWriter().write("</script>");
			response.getWriter().flush();
			
			return;
		}
		
		boardNo = commMakeOkGet2(tenantID);
		boardNo += 1;
		
		if (commMakeOkGet4(tenantID) == 0) {
			ezCommunityDAO.commMakeOkInsert1(tenantID);
		}
		
		int clubNo = 0;
		clubNo = ezCommunityDAO.commMakeOkGet3(tenantID);
		clubNo ++ ;
		
		String code = "C_"+clubNo;
		int openEmail = 1;
		int openHp = 1;
		int openComp = 1;
		int openHouse = 1;
		int openJob = 1;
		int openSex = 1;
		int openBirth = 0;
		
		commMakeOkInsert2(clubNo, clubName, clubName2, cCateA, cCateB, cCateC, clubType, clubConfirmType, intro, isIn, logo, banner, bBoardName[Integer.parseInt(userInfo.getPrimary())].trim(), bBoardName[2].trim(), comatt, code, bNotiName[1].trim(), bNotiName[2].trim(), pNewID, boardNo, userInfo.getId(), userInfo.getDisplayName1(), userInfo.getCompanyName1(), userInfo.getDeptName1(), pNewSubID, openEmail, openHp, openComp, openHouse, openJob, openBirth, openSex, userInfo.getCompanyID(), tenantID);
		
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
		
		if (commMakeOkGet6(userInfo.getCompanyID(), userInfo.getId(), tenantID) == null) {
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
			
			joinOkInsert(companyID, userID, userName, userName2, companyName, companyName2, companyZip, companyAddress, deptName, deptName2, companyTel, companyFax, homeTel, handPhone, eMail, birthDay, gender, tenantID);
		}
		
		String fileName = "", attachFile = "", onlyFileName = "", extName = "";
		int fileSize = 0, iStart = 0;
		
		logger.debug("" + cClubLogo);
		if (cClubLogo != null && !cClubLogo.isEmpty()) {
			fileName = code;
			attachFile = cClubLogo.getOriginalFilename();
			fileSize = (int) cClubLogo.getSize();
			onlyFileName = attachFile;
			iStart = onlyFileName.lastIndexOf(".");
			extName = onlyFileName.substring(iStart);
			
			if (!new File(logoPath).exists()) {
				new File(logoPath).mkdirs();
			}
			
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
			
			commMakeOkSet1(fileName + "_logo" + ".png", fileName + "_thumbnail" + ".png", fileName, fileSize, userInfo.getTenantId());
		} else {
			//IE9
			fileName = code;
			
			if (!new File(logoPath).exists()) {
				new File(logoPath).mkdirs();
			}
			
			File logoFile = new File(logoPath + fileName + "_logo" + ".png");
			File logoThumbnailFile = new File(logoPath + fileName + "_thumbnail" + ".png");
			
			if (logoFile.exists() && logoThumbnailFile.exists()) {
				commMakeOkSet1(fileName + "_logo" + ".png", fileName + "_thumbnail" + ".png", fileName, (int) logoFile.length(), userInfo.getTenantId());
			}
		}
		
		//TODO 2016-05-03 이효진 뷰에서 banner을 사용하지 않아서 파라미터로 받지 않는다.
		if (cClubBanner != null && !cClubBanner.isEmpty()) {
			fileName = code;
			attachFile = cClubBanner.getOriginalFilename();
			fileSize = (int) cClubBanner.getSize();
			onlyFileName = attachFile;
			iStart = onlyFileName.lastIndexOf(".");
			extName = onlyFileName.substring(iStart);
			
			File file = new File(logoPath + fileName + "_banner" + "." + extName);
			cClubBanner.transferTo(file);
			
			commMakeOkSet2(fileName + "_banner" + "." + extName, fileName, fileSize, userInfo.getTenantId());
		}
		
		if (clubVO == null) {
			response.getWriter().write("<script language='javascript'>\n");
			response.getWriter().write("alert('Community" + egovMessageSource.getMessage("ezCommunity.t1027", userInfo.getLocale()) + "');\n");
			response.getWriter().write("document.location.href = '/ezCommunity/commMake.do?flag=1';\n");
			response.getWriter().write("</script>");
			response.getWriter().flush();
		}
		
		logger.debug("commMakeOk ended.");
	}	
	
	@Override
	public String goAdminOkGet2(String pClubID, LoginVO userInfo) throws Exception {
		logger.debug("goAdminOkGet2 started.");
		
		StringBuilder masterXML = new StringBuilder();
		StringBuilder isinXML = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PCLUBID", pClubID);
		map.put("tenantID", userInfo.getTenantId());
		
		List<CommunityClubVO> clubList = ezCommunityDAO.goAdminOkGet2(map);
		
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
		
		String result = masterXML.toString() + isinXML.toString();
		
		logger.debug("goAdminOkGet2 ended.");
		
		return result;
	}

	@Override
	public String commHomeInfo(LoginVO userInfo, String code, HttpServletRequest request) throws Exception {
		String strSysopID = "";
		
		CommunityClubVO clubVO = aspCommInfoGet1(code, userInfo.getTenantId());
		
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		String temp = commonUtil.getQueryResult(clubVO);
		sb.append(temp.substring(5, temp.length()-6));
		sb.append("</DATA>");
		
		Document xmlMainDom = commonUtil.convertStringToDocument(sb.toString());
		strSysopID = xmlMainDom.getElementsByTagName("C_SYSOPID").item(0).getTextContent().trim();
		
		String proplist = "displayName;description;company;extensionAttribute2";
		String infoXMLMemberInfo = ezOrganAdminService.getPropertyList(strSysopID, proplist, userInfo.getPrimary(), userInfo.getTenantId());
		
		Document xmldomMemberInfo = commonUtil.convertStringToDocument(infoXMLMemberInfo);
		
		String name = xmldomMemberInfo.getElementsByTagName("DISPLAYNAME").item(0).getTextContent().trim();
		String companyNM = xmldomMemberInfo.getElementsByTagName("COMPANY").item(0).getTextContent().trim();
		String deptName = xmldomMemberInfo.getElementsByTagName("DESCRIPTION").item(0).getTextContent().trim();
		String userImage = xmldomMemberInfo.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().trim();
		
		if (!commonUtil.checkIE(request)) {
			userImage = userImage.replace(commonUtil.getRealPath(request), "");
		}
		
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
	public List<CommunityBoardInfoVO> commHomeBoardInfo(String code, int tenantID) throws Exception {
		logger.debug("commHomeBoardInfo started.");
		logger.debug("code : " + code + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		List<CommunityBoardInfoVO> boardInfoList = ezCommunityDAO.copHomeBoardGet(map);
		
		logger.debug("boardInfoList size : " + boardInfoList.size());
		logger.debug("commHomeBoardInfo ended.");
		
		return boardInfoList;
	}
	
	@Override
	public List<CommunityBoardItemVO> commHomeBoardItemList(String boardID, int tenantID) throws Exception {
		logger.debug("commHomeBoardItemList started.");
		logger.debug("boardID : " + boardID + ", tenantID : " + tenantID + ", now : " + commonUtil.getTodayUTCTime(""));
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardID);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		List<CommunityBoardItemVO> boardItemList = ezCommunityDAO.copHomeBoardItemGet(map);
		
		logger.debug("boardItemList.size : " + boardItemList.size());
		logger.debug("commHomeBoardItemList ended.");
		
		return boardItemList;
	}

	@Override
	public void boardItemList(LoginVO userInfo, Model model, HttpServletRequest request, HttpServletResponse response, CommunityBoardPropertyVO boardInfo, CommunityBoardListVO boardList) throws Exception {
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
				totalCount = getNewItemListCount(userInfo.getId(), userInfo.getTenantId());
				
				if (totalCount < pEndRow) {
					pEndRow = totalCount;
				}
				
                strXML = getNewItemListXML(userInfo, pStartRow, pEndRow, pSortBy);
            } else {
                showAdjacent = "1";
                totalCount = getBoardTotalItemCount(pBoardID, userInfo.getTenantId());
                
                if (totalCount < pEndRow) {
					pEndRow = totalCount;
				}
                
                strXML = getBoardListItemXML(userInfo, pBoardID, pStartRow, pEndRow, pSortBy);
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
	public void newBoardItem(CommunityBoardItemVO item, CommunityBoardPropertyVO boardInfo, LoginVO userInfo, String pItemID, String pBoardID, String pUrl, String pMode, String expireDays, String hasAttach, Model model) throws Exception {
		String strWriterFakeName = "";
		
		if (!pUrl.equals("")) {
			item.setStartDate(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));
			item.setEndDate(commonUtil.getDateStringInUTC(EgovDateUtil.addDay(commonUtil.getTodayUTCTime(""), 30, "yyyy-MM-dd HH:mm:ss"), userInfo.getOffset(), false));
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
                    item.setEndDate(commonUtil.getDateStringInUTC(EgovDateUtil.addDay(commonUtil.getTodayUTCTime(""), 30, "yyyy-MM-dd HH:mm:ss"), userInfo.getOffset(), false));
                } else {
                    item.setEndDate(commonUtil.getDateStringInUTC(EgovDateUtil.addDay(commonUtil.getTodayUTCTime(""), Integer.parseInt(expireDays), "yyyy-MM-dd HH:mm:ss"), userInfo.getOffset(), false));
                }
			} else {
				item = getItemXML(pBoardID, pItemID, userInfo.getTenantId(), userInfo.getOffset());
				
                if (pMode.equals("reply")) {
                	item.setItemLevel(item.getItemLevel()+1);
                	item.setAbsTract("");
                	item.setTitle(item.getTitle());
                } else if (pMode.equals("modify")) {
                	//이효진 사용하는곳 없음
                	if (item.getEndDate().substring(0, 4).equals("9999")) {
                        if (expireDays.equals("-1")) {
                        	item.setEndDate(commonUtil.getDateStringInUTC(EgovDateUtil.addDay(commonUtil.getTodayUTCTime(""), 30, "yyyy-MM-dd HH:mm:ss"), userInfo.getOffset(), false));
                        } else {
                            item.setEndDate(commonUtil.getDateStringInUTC(EgovDateUtil.addDay(commonUtil.getTodayUTCTime(""), Integer.parseInt(expireDays), "yyyy-MM-dd HH:mm:ss"), userInfo.getOffset(), false));
                        }
                    } else {
                    	item.setEndDate(item.getEndDate().substring(0, 4));
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
		
		model.addAttribute("item", item);
		model.addAttribute("strWriterFakeName", strWriterFakeName);
	}

	@Override
	public String upload(MultipartHttpServletRequest request, HttpServletResponse response, LoginVO userInfo) throws Exception {
		int pMaxSize = 0;
		String strXML = "";
		
		String pBoardID = request.getParameter("boardID");
		String pMode = request.getParameter("mode");
		
		if (request.getParameter("maxSize") != null) {
			pMaxSize = Integer.parseInt(request.getParameter("maxSize").trim());
		}
		
		String userExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		Iterator<String> itr = request.getFileNames();
		
		String pDirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_community.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String tempPath = pDirPath  + "tempUploadFile";
		String uploadPath = pDirPath  + pBoardID + commonUtil.separator + "uploadFile";
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
						pAttachPath = pDirPath + "tempUploadFile" + commonUtil.separator + pUploadSN + "_" + pFileName;
						File thumbnailFile = new File(pAttachPath);
						file.transferTo(thumbnailFile);
						resultUpload = "true";
					}
				} else if (pMode.equals("PHOTO")) {
					pAttachPath = pDirPath + "tempUploadFile" + commonUtil.separator + pUploadSN + pFileName.substring(pFileName.lastIndexOf("."));
					File thumbnailFile = new File(pAttachPath);
					file.transferTo(thumbnailFile);
					
					BufferedImage inputImage = ImageIO.read(thumbnailFile);
					BufferedImage outputImage = null;
					Graphics2D saveImage = null;
					//썸네일 생성		
					outputImage= new BufferedImage(100, 100, BufferedImage.TYPE_INT_RGB);
					saveImage = outputImage.createGraphics();
					saveImage.drawImage(inputImage, 0, 0, 100, 100, null);
					
					File tempTumbbail = new File(pDirPath + "tempUploadFile" + commonUtil.separator + "s_" + pUploadSN + pFileName.substring(pFileName.lastIndexOf(".")));
					ImageIO.write(outputImage, "png", tempTumbbail);
					
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
	public void boardItemView(LoginVO userInfo, CommunityBoardPropertyVO boardInfo, CommunityBoardItemVO item, String pItemID, String pBoardID, String showAdjacent, String adjacentItemsEnableFlag, Model model) throws Exception {
		String previousItemID = "", previousTitle = "", nextItemID = "", nextTitle = "", cAdmin = "", gcAdmin = "", pVersionUse = "";
		if (item.getParentWriteDate().compareTo(item.getWriteDate()) > 0) {
			item.setWriteDate(item.getParentWriteDate());
		}
		
		if (item.getEndDate().substring(0, 4).equals("9999")) {
			item.setEndDate(egovMessageSource.getMessage("ezCommunity.t930", userInfo.getLocale()));
		}
		
		if (adjacentItemsEnableFlag.equals("1") && showAdjacent.equals("1")) {
			Map<String, String> map = getAdjacentItems(pItemID, pBoardID, item.getUpperItemIDTree(), commonUtil.getDateStringInUTC(item.getParentWriteDate(), userInfo.getOffset(), true), userInfo.getTenantId());
			
            previousItemID = map.get("previousItemID");
            previousTitle = map.get("previousTitle");
            nextItemID = map.get("nextItemID");
            nextTitle = map.get("nextTitle");

            if (previousTitle.equals("")) {
            	previousTitle = egovMessageSource.getMessage("ezCommunity.t191", userInfo.getLocale());
            }
            
            if (nextTitle.equals("")) {
            	nextTitle = egovMessageSource.getMessage("ezCommunity.t193", userInfo.getLocale());
            }
            
//            if (userInfo.getRollInfo().indexOf("c=1") > 0 || userInfo.getRollInfo().indexOf("k=1") > 0 || userInfo.getRollInfo().indexOf("t=1") > 0) {
            if (userInfo.getRollInfo().indexOf("c=1") > 0 || userInfo.getRollInfo().indexOf("k=1") > 0) {
            	cAdmin = "admin";
            }
            
            boardInfo.setBoardGroupAdmin_FG(checkIfBoardGroupAdmin(pBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getTenantId()));
            
            if (boardInfo.getBoardGroupAdmin_FG().equals("OK")) {
            	gcAdmin = "OK";
            }
            
            Map<String, Object> map1 = new HashMap<String, Object>();
            map1.put("v_PBOARDID", pBoardID);
            map1.put("tenantID", userInfo.getTenantId());
            
            pVersionUse = ezCommunityDAO.getVersionInfo(map1); 
		}
		
		if (boardInfo.getGubun() != null) {
			if (boardInfo.getGubun().equals("2")) {
				item.setWriterID("");
				item.setWriterDeptName("");
				item.setWriterCompanyName("");
			}
		}
		
		model.addAttribute("item", item);
		model.addAttribute("previousItemID", previousItemID);
		model.addAttribute("previousTitle", previousTitle);
		model.addAttribute("nextItemID", nextItemID);
		model.addAttribute("nextTitle", nextTitle);	
		model.addAttribute("cAdmin", cAdmin);
		model.addAttribute("gcAdmin", gcAdmin);
		model.addAttribute("pVersionUse", pVersionUse);
	}

	@Override
	public String confirmPassword(String itemID, String newPassword) throws Exception {
		logger.debug("confirmPassword started.");
		
		String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
		String oldPassword = "";
		
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		String rpwd = EgovFileScrty.decryptRsa(pk, newPassword);
		
		newPassword = EgovFileScrty.encryptPassword(rpwd, "unknown");
//		oldPassword = EgovFileScrty.encryptPassword(rpwd, "unknown");
		
		if (newPassword != null && newPassword.trim().equals(oldPassword)) {
			logger.debug("confirmPassword ended. if");
			
			return "OK";
		} else {
			logger.debug("confirmPassword ended. else");
			
			return "NO";
		}
	}
	
	@Override
	public String pollMain(LoginVO userInfo, String code) throws Exception {
		logger.debug("pollMain started.");
		
		String pollState = "", pollManager = "";
		String offset = userInfo.getOffset();
		StringBuilder sb = new StringBuilder();
		
		logger.debug("pollMainGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", userInfo.getTenantId());
		
		List<CommunityCPollManagerVO> list = ezCommunityDAO.pollMainGet2(map);
		
		logger.debug("pollMainGet2 ended. size : " + list.size());
		
		String dateStr = commonUtil.getTodayUTCTime("").substring(0, 10);
		logger.debug("userCurrentTime=" + dateStr);
		
		for (CommunityCPollManagerVO item : list) {
			logger.debug("getPollStartDate() : " + commonUtil.getDateStringInUTC(item.getPollStartDate(), offset, false).substring(0, 10));
			logger.debug("getPollEndDate() : " + commonUtil.getDateStringInUTC(item.getPollEndDate(), offset, false).substring(0, 10));
			
			if (dateStr.compareTo(item.getPollStartDate().substring(0, 10)) < 0) {
				pollState = egovMessageSource.getMessage("ezCommunity.t677", userInfo.getLocale());
				pollManager = egovMessageSource.getMessage("ezCommunity.t678", userInfo.getLocale());
			} else {
				if (dateStr.compareTo(item.getPollStartDate().substring(0, 10)) >= 0 && dateStr.compareTo(item.getPollEndDate().substring(0, 10)) <= 0) {
					pollState = egovMessageSource.getMessage("ezCommunity.t679", userInfo.getLocale());
					pollManager = egovMessageSource.getMessage("ezCommunity.t678", userInfo.getLocale());
				} else {
					pollState= egovMessageSource.getMessage("ezCommunity.t680", userInfo.getLocale());
					pollManager = egovMessageSource.getMessage("ezCommunity.t208", userInfo.getLocale());
				}
			}
			
			logger.debug("pollMainGet3 started.");
			
			map = new HashMap<String, Object>();
			map.put("v_MANAGERID", item.getManagerID());
			map.put("tenantID", userInfo.getTenantId());
			
			String strQuestionID = ezCommunityDAO.pollMainGet3(map);
			
			logger.debug("pollMainGet3 ended.");
			logger.debug("pollMainGet4 started.");
			
			map = new HashMap<String, Object>();
			map.put("v_STRQUESTIONID", strQuestionID);
			map.put("tenantID", userInfo.getTenantId());
			
			int strResponseCnt = ezCommunityDAO.pollMainGet4(map);
			
			logger.debug("pollMainGet4 ended.");
			
			sb.append("<tr>");
			sb.append("<td align=\"center\">" + item.getPollGroupNo() + "</td>");
			sb.append("<td>" + commonUtil.getDateStringInUTC(item.getPollStartDate(), offset, false).substring(0, 10) + " ~ " + commonUtil.getDateStringInUTC(item.getPollEndDate(), offset, false).substring(0, 10) + "</td>");
			sb.append("<td style=\"text-overflow:ellipsis;\" title=\"" + item.getPollSubject() + "\">");
			sb.append("<a style = \"cursor:pointer\" onclick=movepage(\"" + code + "\",\"" + item.getManagerID() + "\",\"" + pollState + "\")>" + item.getPollSubject() + "</a></td>");
			sb.append("<td>" + strResponseCnt + egovMessageSource.getMessage("ezCommunity.t478", userInfo.getLocale()) + "</td>");
			sb.append("<td>" + pollState + "</td>");
			sb.append("<td>");
			
			if (item.getPollRegUser().equals(userInfo.getId())) {
				if (pollManager.equals(egovMessageSource.getMessage("ezCommunity.t678", userInfo.getLocale()))) {
					sb.append("<a class=\"imgbtn\" onclick=poll_edit(\"" + code + "\",\"" + item.getManagerID() + "\")><span>" + pollManager + "</span></a>");
				} else if (pollManager.equals(egovMessageSource.getMessage("ezCommunity.t208", userInfo.getLocale()))) {
					sb.append("<a class=\"imgbtn\" onclick=poll_Delete(\"" + code + "\",\"" + item.getManagerID() + "\")><span>" + pollManager + "</span></a>");
				}
			}
			
			sb.append("</td>");
			sb.append("</tr>");
		}
		
		logger.debug("pollMain ended.");
		
		return sb.toString();
	}

	@Override
	public String pollAddOk(int sel, String selType, String selRes, int selectedNo, int answerCount, Model model, LoginVO userInfo) throws Exception {
		StringBuilder sb = new StringBuilder();
		
		if (sel == 0 && !selType.equals("3")) {
			sb.append("<select size=\"5\" style=\"Width:100%; Height:160px\" id=select1 name=select1>");
			
			switch (selRes) {
				case "1" :
					sb.append("<option value = \"1. " + egovMessageSource.getMessage("ezCommunity.t617", userInfo.getLocale()) + "\">1. " + egovMessageSource.getMessage("ezCommunity.t618", userInfo.getLocale()) + "</option>");
					sb.append("<option value = \"2. " + egovMessageSource.getMessage("ezCommunity.t619", userInfo.getLocale()) + "\">2. " + egovMessageSource.getMessage("ezCommunity.t620", userInfo.getLocale()) + "</option>");
					sb.append("<option value = \"3. " + egovMessageSource.getMessage("ezCommunity.t621", userInfo.getLocale()) + "\">3. " + egovMessageSource.getMessage("ezCommunity.t622", userInfo.getLocale()) + "</option>");
					sb.append("<option value = \"4. " + egovMessageSource.getMessage("ezCommunity.t623", userInfo.getLocale()) + "\">4. " + egovMessageSource.getMessage("ezCommunity.t624", userInfo.getLocale()) + "</option>");
					sb.append("<option value = \"5. " + egovMessageSource.getMessage("ezCommunity.t625", userInfo.getLocale()) + "\">5. " + egovMessageSource.getMessage("ezCommunity.t626", userInfo.getLocale()) + "</option>");
					
					selectedNo = 1;
					answerCount = 5;
					
					break;
				case "2" :
					sb.append("<option value = \"1. " + egovMessageSource.getMessage("ezCommunity.t628", userInfo.getLocale()) + "\">1. " + egovMessageSource.getMessage("ezCommunity.t629", userInfo.getLocale()) + "</option>");
					sb.append("<option value = \"2. " + egovMessageSource.getMessage("ezCommunity.t630", userInfo.getLocale()) + "\">2. " + egovMessageSource.getMessage("ezCommunity.t631", userInfo.getLocale()) + "</option>");
					sb.append("<option value = \"3. " + egovMessageSource.getMessage("ezCommunity.t632", userInfo.getLocale()) + "\">3. " + egovMessageSource.getMessage("ezCommunity.t633", userInfo.getLocale()) + "</option>");
					sb.append("<option value = \"4. " + egovMessageSource.getMessage("ezCommunity.t634", userInfo.getLocale()) + "\">4. " + egovMessageSource.getMessage("ezCommunity.t635", userInfo.getLocale()) + "</option>");
					sb.append("<option value = \"5. " + egovMessageSource.getMessage("ezCommunity.t636", userInfo.getLocale()) + "\">5. " + egovMessageSource.getMessage("ezCommunity.t637", userInfo.getLocale()) + "</option>");
					
					selectedNo = 2;
					answerCount = 5;
					
					break;
				case "3" :
					sb.append("<option value = \"1. " + egovMessageSource.getMessage("ezCommunity.t638", userInfo.getLocale()) + "\">1. " + egovMessageSource.getMessage("ezCommunity.t639", userInfo.getLocale()) + "</option>");
					sb.append("<option value = \"2. " + egovMessageSource.getMessage("ezCommunity.t640", userInfo.getLocale()) + "\">2. " + egovMessageSource.getMessage("ezCommunity.t641", userInfo.getLocale()) + "</option>");
					sb.append("<option value = \"3. " + egovMessageSource.getMessage("ezCommunity.t632", userInfo.getLocale()) + "\">3. " + egovMessageSource.getMessage("ezCommunity.t633", userInfo.getLocale()) + "</option>");
					sb.append("<option value = \"4. " + egovMessageSource.getMessage("ezCommunity.t642", userInfo.getLocale()) + "\">4. " + egovMessageSource.getMessage("ezCommunity.t643", userInfo.getLocale()) + "</option>");
					sb.append("<option value = \"5. " + egovMessageSource.getMessage("ezCommunity.t644", userInfo.getLocale()) + "\">5. " + egovMessageSource.getMessage("ezCommunity.t645", userInfo.getLocale()) + "</option>");
					
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
					sb.append("<option value = \"1. " + egovMessageSource.getMessage("ezCommunity.t646", userInfo.getLocale()) + "\">1. " + egovMessageSource.getMessage("ezCommunity.t647", userInfo.getLocale()) + "</option>");
					sb.append("<option value = \"2. " + egovMessageSource.getMessage("ezCommunity.t648", userInfo.getLocale()) + "\">2. " + egovMessageSource.getMessage("ezCommunity.t649", userInfo.getLocale()) + "</option>");
					
					selectedNo = 5;
					answerCount = 2;
					
					break;
				case "13" :
					sb.append("<option value = \"1. " + egovMessageSource.getMessage("ezCommunity.t650", userInfo.getLocale()) + "\">1. " + egovMessageSource.getMessage("ezCommunity.t651", userInfo.getLocale()) + "</option>");
					sb.append("<option value = \"2. " + egovMessageSource.getMessage("ezCommunity.t652", userInfo.getLocale()) + "\">2. " + egovMessageSource.getMessage("ezCommunity.t653", userInfo.getLocale()) + "</option>");
					
					selectedNo = 6;
					answerCount = 2;
					
					break;
				case "14" :
					sb.append("<option value = \"1. " + egovMessageSource.getMessage("ezCommunity.t630", userInfo.getLocale()) + "\">1. " + egovMessageSource.getMessage("ezCommunity.t631", userInfo.getLocale()) + "</option>");
					sb.append("<option value = \"2. " + egovMessageSource.getMessage("ezCommunity.t634", userInfo.getLocale()) + "\">2. " + egovMessageSource.getMessage("ezCommunity.t635", userInfo.getLocale()) + "</option>");
					
					selectedNo = 7;
					answerCount = 2;
					break;
			}
			
			if (selType.equals("2")) {
				answerCount++;
				sb.append("<option value = \"3\">3. " + egovMessageSource.getMessage("ezCommunity.t627", userInfo.getLocale()) + "</option>");
			}
			
			sb.append("</select>");
		} else {
			if (sel == 1 && !selType.equals("3")) {
				selectedNo = 8;
				
				if(!selType.equals("2")){
					for(int i=1; i <= Integer.parseInt(selRes); i++) {
						sb.append("<span style=\"display:inline-block; width:30px;\">"+ i + ". </span><input type= \"text\" size=\"80\" name = \"selNo_" + i + "\"><br>");
					}
					
					answerCount = Integer.parseInt(selRes);
				} else {
					selectedNo = 9;
					
					for(int i=1; i <= Integer.parseInt(selRes) - 1; i++) {
						sb.append("<span style=\"display:inline-block; width:30px;\">"+ i + ". </span><input type= \"text\" size=\"80\" name = \"selNo_" + i + "\"><br>");
					}
					
					answerCount = Integer.parseInt(selRes);
					sb.append(selRes + ". " + egovMessageSource.getMessage("ezCommunity.t627", userInfo.getLocale()));
				}
			} else {
				if (selType.equals("3")) {
					answerCount = 1;
					selectedNo = 10;
					sb.append(egovMessageSource.getMessage("ezCommunity.t654", userInfo.getLocale()) + "<input type = \"text\" size=\"80\" name = \"selJU\">");
				}
			}
		}
		
		model.addAttribute("answerCount", answerCount);
		model.addAttribute("selectedNo", selectedNo);
		
		return sb.toString();
	}

	@Override
	public void pollAddGo(LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("pollAddGo started.");
		
		String questionID = "";
		String code = request.getParameter("code");
		String mode = request.getParameter("mode");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String subject = request.getParameter("pollSubject");
		/*String selRes = request.getParameter("selRes");
		String sel = request.getParameter("sel");*/
		String selType = request.getParameter("selType");
		String selectedNo = request.getParameter("selectedNo");
		String answerViewType = request.getParameter("answerViewType");
		String answerCount = request.getParameter("answerCount");
		String offset = userInfo.getOffset();
		int tenantID = userInfo.getTenantId();
		
		startDate = startDate + " 00:00:00";
		endDate = endDate + " 23:59:59";
		
		logger.debug("startDate : " + startDate);
		logger.debug("endDate : " + endDate);
		
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		endDate = commonUtil.getDateStringInUTC(endDate, offset, true);
		
		logger.debug("UTCstartDate : " + startDate);
		logger.debug("UTCendDate : " + endDate);
		
		switch (mode) {
			case "write" :
				logger.debug("pollAddOkGoGet1 started.");
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("v_CODE", code);
				map.put("tenantID", tenantID);
				
				int maxNo = ezCommunityDAO.pollAddOkGoGet1(map);
				
				logger.debug("pollAddOkGoGet1 ended.");
				
				maxNo++;
				
				pollAddOkGoInsert1(code, maxNo, subject, startDate, endDate, userInfo.getId(), tenantID);
				
				String managerID = pollAddOkGoGet2(code, maxNo, tenantID);
				
				pollAddOkGoInsert2(managerID.trim(), subject, answerCount, selType, answerViewType, tenantID);
				
				Map<String, Object> map1 = new HashMap<String, Object>();
				map1.put("v_MANAGERID", managerID);
				map1.put("tenantID", tenantID);
				
				questionID = ezCommunityDAO.pollAddOkGoGet3(map1);
				
				String[] answerContent = new String [100];
				
				switch (selectedNo) {
					case "1":
						answerContent[1] = "1. " + egovMessageSource.getMessage("ezCommunity.t618", userInfo.getLocale());
						answerContent[2] = "2. " + egovMessageSource.getMessage("ezCommunity.t620", userInfo.getLocale());
						answerContent[3] = "3. " + egovMessageSource.getMessage("ezCommunity.t622", userInfo.getLocale());
						answerContent[4] = "4. " + egovMessageSource.getMessage("ezCommunity.t624", userInfo.getLocale());
						answerContent[5] = "5. " + egovMessageSource.getMessage("ezCommunity.t655", userInfo.getLocale());
						
						if (selType.equals("2")) {
							answerContent[6] = "6. " + egovMessageSource.getMessage("ezCommunity.t627", userInfo.getLocale());
						}
						
						break;
						
					case "2" :
						answerContent[1] = "1. " + egovMessageSource.getMessage("ezCommunity.t629", userInfo.getLocale());
						answerContent[2] = "2. " + egovMessageSource.getMessage("ezCommunity.t631", userInfo.getLocale());
						answerContent[3] = "3. " + egovMessageSource.getMessage("ezCommunity.t633", userInfo.getLocale());
						answerContent[4] = "4. " + egovMessageSource.getMessage("ezCommunity.t635", userInfo.getLocale());
						answerContent[5] = "5. " + egovMessageSource.getMessage("ezCommunity.t637", userInfo.getLocale());
						
						if (selType.equals("2")) {
							answerContent[6] = "6. " + egovMessageSource.getMessage("ezCommunity.t627", userInfo.getLocale());
						}
						
						break;
						
					case "3" :
						answerContent[1] = "1. " + egovMessageSource.getMessage("ezCommunity.t639", userInfo.getLocale());
						answerContent[2] = "2. " + egovMessageSource.getMessage("ezCommunity.t641", userInfo.getLocale());
						answerContent[3] = "3. " + egovMessageSource.getMessage("ezCommunity.t633", userInfo.getLocale());
						answerContent[4] = "4. " + egovMessageSource.getMessage("ezCommunity.t643", userInfo.getLocale());
						answerContent[5] = "5. " + egovMessageSource.getMessage("ezCommunity.t645", userInfo.getLocale());
						
						if (selType.equals("2")) {
							answerContent[6] = "6. " + egovMessageSource.getMessage("ezCommunity.t627", userInfo.getLocale());
						}
						
						break;
						
					case "4" :
						answerContent[1] = "1. Yes.";
						answerContent[2] = "2. No.";
						
						if (selType.equals("2")) {
							answerContent[3] = "3. " + egovMessageSource.getMessage("ezCommunity.t627", userInfo.getLocale());
						}
						
						break;
						
					case "5" :
						answerContent[1] = "1. " + egovMessageSource.getMessage("ezCommunity.t647", userInfo.getLocale());
						answerContent[2] = "2. " + egovMessageSource.getMessage("ezCommunity.t649", userInfo.getLocale());
						
						if (selType.equals("2")) {
							answerContent[3] = "3. " + egovMessageSource.getMessage("ezCommunity.t627", userInfo.getLocale());
						}
						
						break;
						
					case "6" :
						answerContent[1] = "1. " + egovMessageSource.getMessage("ezCommunity.t651", userInfo.getLocale());
						answerContent[2] = "2. " + egovMessageSource.getMessage("ezCommunity.t653", userInfo.getLocale());
						
						if (selType.equals("2")) {
							answerContent[3] = "3. " + egovMessageSource.getMessage("ezCommunity.t627", userInfo.getLocale());
						}
						
						break;
						
					case "7" :
						answerContent[1] = "1. " + egovMessageSource.getMessage("ezCommunity.t631", userInfo.getLocale());
						answerContent[2] = "2. " + egovMessageSource.getMessage("ezCommunity.t635", userInfo.getLocale());
						
						if (selType.equals("2")) {
							answerContent[3] = "3. " + egovMessageSource.getMessage("ezCommunity.t627", userInfo.getLocale());
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
								answerContent[i] = i + ". " + egovMessageSource.getMessage("ezCommunity.t627", userInfo.getLocale());
							} else {
								if (request.getParameter("selNo_" + i) != null) {
									answerContent[i] = request.getParameter("selNo_" + i);
								}
							}
						}
						
						break;
						
					case "10" :
						answerContent[1] = egovMessageSource.getMessage("ezCommunity.t603", userInfo.getLocale());
						
						break;
				}
				
				for (int i = 1; i <= Integer.parseInt(answerCount); i++) {
					pollAddOkGoInsert3(questionID.trim(), i, answerContent[i], tenantID);
				}
				
				break;
				
			default :
				break;
		}
		
		logger.debug("pollAddGo ended.");
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		response.getWriter().write("<script language='javascript'>\n");
		response.getWriter().write("document.location.href = '/ezCommunity/pollMain.do?code=" + code + "';\n");
		response.getWriter().write("</script>");
		response.getWriter().flush();
	}

	@Override
	public void pollDelete(LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String code = request.getParameter("code");
		String managerID = request.getParameter("managerID");
		int tenantID = userInfo.getTenantId();
		
		logger.debug("pollDelete started.");
		logger.debug("pollDeleteGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MANAGERID", managerID);
		map.put("tenantID", tenantID);
		
		String strRegUser = ezCommunityDAO.pollDeleteGet1(map).trim();
		
		logger.debug("pollDeleteGet1 ended. strRegUser=" + strRegUser);
		
		if (strRegUser != null) {
			logger.debug("pollDeleteGet3 started.");
			
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("v_CODE", code);
			map1.put("tenantID", tenantID);
			
			String sysopID = ezCommunityDAO.pollDeleteGet3(map1).trim();
			
			logger.debug("pollDeleteGet3 ended. sysopID=" + sysopID);
			
			if (strRegUser.equals(userInfo.getId()) || sysopID.equals(userInfo.getId())) {
				logger.debug("pollDeleteGet2 started.");
				
				List<CommunityCPollQuestionVO> questionList = ezCommunityDAO.pollDeleteGet2(map);
				
				logger.debug("pollDeleteGet2 ended. size=" + questionList.size());

				for (CommunityCPollQuestionVO question : questionList) {
					logger.debug("pollDeleteGet4 start. " + question.getQuestionID());
					
					Map<String, Object> map2 = new HashMap<String, Object>();
					map2.put("v_QUESTIONID", question.getQuestionID());
					map2.put("tenantID", tenantID);
					
					List<CommunityCPollAnswerVO> answerList= ezCommunityDAO.pollDeleteGet4(map2);
					
					logger.debug("pollDeleteGet4 ended. size=" + answerList.size());
					
					for(CommunityCPollAnswerVO answer : answerList) {
						logger.debug("getQuestionID="+ question.getQuestionID() + " || getAnswerID=" + answer.getAnswerID());
						pollDeleteDel1(question.getQuestionID(), answer.getAnswerID(), tenantID);
					}
					
					pollDeleteDel2(question.getQuestionID(), tenantID);
				}
				
				pollDeleteDel3(managerID, tenantID);
			}
		}
		
		logger.debug("pollDelete ended.");
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		response.getWriter().write("<script language='javascript'>\n");
		response.getWriter().write("document.location.href = '/ezCommunity/pollMain.do?code=" + code + "';\n");
		response.getWriter().write("</script>");
		response.getWriter().flush();
	}
	
	@Override
	public void pollRes(LoginVO userInfo, Model model, String pollManagerID, String pollState, HttpServletResponse response) throws Exception {
		logger.debug("pollRes started.");
		
		int isSave = 0;
		double responseCount = 0;
		int tenantID = userInfo.getTenantId();
		
		logger.debug("pollResGet2, pollResGet3 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_POLLMANAGERID", pollManagerID);
		map.put("tenantID", tenantID);
		
		CommunityCPollManagerVO managerVO = ezCommunityDAO.pollResGet2(map);
		CommunityCPollQuestionVO questionVO = ezCommunityDAO.pollResGet3(map);
		
		logger.debug("pollResGet2, pollResGet3 ended.");
		
		StringBuilder sb = new StringBuilder();
		
		if (questionVO != null) {
			sb.append("<input type=\"hidden\" name=\"questionID_" + questionVO.getQuestionNo() + "\" value=\"" + questionVO.getQuestionID() + "\">");
			sb.append("<input type=\"hidden\" name=\"answerCount_" + questionVO.getQuestionNo() + "\" value=\"" + questionVO.getAnswerCount() + "\">");
			sb.append("<input type=\"hidden\" name=\"answerType_" + questionVO.getQuestionNo() + "\" value=\"" + questionVO.getAnswerType() + "\">");
			
			CommunityCPollResponseVO responseVO = pollResGet5(questionVO.getQuestionID(), userInfo.getId(), userInfo.getCompanyID(), tenantID);
			
			if (responseVO != null) {
				isSave = 1;
			}

			int allResponseCount = pollResGetAllCount(questionVO.getQuestionID(), tenantID);
			
			sb.append("</table><br>");
			sb.append("<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\">");
			
			logger.debug("pollResGet6 started.");
			
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("v_QUESTIONID", questionVO.getQuestionID());
			map1.put("tenantID", tenantID);
			
			List<CommunityCPollAnswerVO> answerList = ezCommunityDAO.pollResGet6(map1);
			
			logger.debug("pollResGet6 ended.");
			
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
						
						responseCount = pollResGetCount(questionVO.getQuestionID(), answerVO.getAnswerID(), tenantID);
						int percent = 0;
						
						if (allResponseCount != 0) {
							percent =  (int) ((double) responseCount / allResponseCount * 100);
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
							sb.append(answerVO.getAnswerNo() + ". " + "<input type=\"text\" name=\"answerETC\" style=\"width:270px\">&nbsp;<a href=\"javascript:etcview( '" + egovMessageSource.getMessage("ezCommunity.t627", userInfo.getLocale()) + "', '" + questionVO.getQuestionID() + "' );\">" + egovMessageSource.getMessage("ezCommunity.t688", userInfo.getLocale()) + "</a>");
						} else {
							sb.append(commonUtil.cleanValue(answerVO.getAnswerContent()));
						}
						
						sb.append("</td>");
						
						responseCount = pollResGetCount(questionVO.getQuestionID(), answerVO.getAnswerID(), tenantID);
						
						if (allResponseCount != 0) {
                            percent = (int) ((double) responseCount / allResponseCount * 100);
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
						sb.append("<input type=hidden name=pollSelect_" + questionVO.getQuestionNo() + ">&nbsp;<a href=\"javascript:etcview('" + egovMessageSource.getMessage("ezCommunity.t207", userInfo.getLocale()) + "', '" + questionVO.getQuestionID() + "' );\" class=\"imgbtn\" ><span>" + egovMessageSource.getMessage("ezCommunity.t689", userInfo.getLocale()) + "</span></a>");
						sb.append("</td>");
						sb.append("</tr>");
						
						break;
				}
			}
		}
		
		StringBuilder strHTML = new StringBuilder();
		String name = pollResGet4(commonUtil.getMultiData(userInfo.getLang(), tenantID), managerVO.getPollRegUser(), tenantID);
		
		strHTML.append("<table class=\"mainlist\"  style=\"width:100%;\" ><tr>");
		
		if (managerVO.getPollSubject().indexOf("\r\n") >= 0) {
			strHTML.append("<th title = \"" + managerVO.getPollSubject() + "\" style=\"word-break:break-all;width:80%;white-space:normal;\" >" + egovMessageSource.getMessage("ezCommunity.t686", userInfo.getLocale()) + "<br/>&nbsp;&nbsp;" + managerVO.getPollSubject().replaceAll("\r\n", "<br/>&nbsp;&nbsp;") + "</th>");
			strHTML.append("<th width=\"\" align=\"right\" >" + egovMessageSource.getMessage("ezCommunity.t687", userInfo.getLocale()) + "<br/>&nbsp;&nbsp;" + name + "</th>");
		} else {
			strHTML.append("<th title = \"" + managerVO.getPollSubject() + "\" style=\"word-break:break-all;width:80%;white-space:normal;\" >" + egovMessageSource.getMessage("ezCommunity.t686", userInfo.getLocale()) + managerVO.getPollSubject() + "</th>");
			strHTML.append("<th width=\"\" align=\"right\" >" + egovMessageSource.getMessage("ezCommunity.t687", userInfo.getLocale()) + name + "</th>");
		}
		
		strHTML.append("</tr>");
		strHTML.append(sb.toString());
		strHTML.append("</table>");
		
		model.addAttribute("isSave", isSave);
		model.addAttribute("idSpanValue", strHTML.toString());
		
		logger.debug("pollRes ended.");
	}
	
	@Override
	public void pollResOk(LoginVO userInfo, String code, String questionID, String pollSelect, String answerETC, String isSave, String answerType, String answerCount, HttpServletResponse response) throws Exception {
		logger.debug("pollResOk started.");
		
		int notResponse = 0;
		
		if (answerType.equals("3")) {
			if(answerETC.equals("")) {
				notResponse = 2;
			}
		} else {
			if (answerType.equals("2")) {
				if (pollSelect == null) {
					notResponse = 1;
				} else {
					if (pollSelect.equals(answerCount) && answerETC.equals("")) {
						notResponse = 2;
					}
				}
			} else {
				if (pollSelect == null) {
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
			
			pollResOkSet(questionID, pollSelect, answerETC, userInfo.getId(), userInfo.getCompanyID(), isSave, answerType, answerCount, userInfo.getTenantId());
		}
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		logger.debug("pollResOk ended.");
		
		if (notResponse == 0) {
			response.getWriter().write("<script language='javascript'>\n");
			response.getWriter().write("document.location.href = '/ezCommunity/pollMain.do?code=" + code + "';\n");
			response.getWriter().write("</script>");
			response.getWriter().flush();
		} else {
			if (notResponse == 1) {
				response.getWriter().write("<script language='javascript'>\n");
				response.getWriter().write("alert(\'" + egovMessageSource.getMessage("ezCommunity.t691", userInfo.getLocale()) + "\');\n");
				response.getWriter().write("window.history.back();");
				response.getWriter().write("</script>");
				response.getWriter().flush();
			} else {
				response.getWriter().write("<script language='javascript'>\n");
				response.getWriter().write("alert(\'" + egovMessageSource.getMessage("ezCommunity.t692", userInfo.getLocale()) + "\');\n");
				response.getWriter().write("window.history.back();");
				response.getWriter().write("</script>");
				response.getWriter().flush();
			}
		}
	}

	@Override
	public void pollEditOk(String pClubNo, String subject, String startDate, String endDate, String managerID, int tenantID, HttpServletResponse response) throws Exception {
		pollEditOkUpdate(subject, startDate, endDate, managerID, tenantID);
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		response.getWriter().write("<script language='javascript'>\n");
		response.getWriter().write("document.location.href = '/ezCommunity/pollMain.do?code=" + pClubNo + "';\n");
		response.getWriter().write("</script>");
		response.getWriter().flush();
	}

	@Override
	public String commViewMember(LoginVO userInfo, String code, String strSysopID, String keyword, String sRadio, int comNoPerPage, int curPage) throws Exception {
		logger.debug("code : " + code + ", strSysopID : " + strSysopID + ", keyword : " + keyword + ", sRadio : " + sRadio);
		
		StringBuilder sb = new StringBuilder();
		
		List<CommunityCClubUserVO> userList = commViewMemberGet1(code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), keyword, sRadio, userInfo.getTenantId());
		
		int iOutputCount = 1;
		
		for(CommunityCClubUserVO user : userList) {
			if (userList.indexOf(user) + 1 <= (curPage - 1) * comNoPerPage) {
				continue;
			}
			
			if (iOutputCount > comNoPerPage) {
				break;
			}
			
			CommunityMemberInfoVO memberInfo = commViewMemberGet3(user.getC_ID().trim(), user.getCompanyID(), commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
			
			if (userInfo.getLang().equals("2")) {
				memberInfo.setUserName(memberInfo.getUserName2());
			}
			
			sb.append("<tr>");
			sb.append("<td style=\"width:55; height:23; align:center;\">" + (userList.indexOf(user) + 1) + "</td>");
			sb.append("<td>");
			
			if (user.getC_ID().trim().equals(strSysopID)) {
				sb.append("<img src=\"/images/i_master.gif\" border=\"0\" alt=\"" + egovMessageSource.getMessage("ezCommunity.t513", userInfo.getLocale()) + "\" align=\"absmiddle\" WIDTH=\"15\" HEIGHT=\"9\">");
			}
			
			sb.append("<a href=\"javascript:openinfo1('" + code + "','" + user.getC_ID().trim() + "','" + user.getCompanyID() + "');\" valign=\"bottom\">" + commonUtil.cleanValue(memberInfo.getUserName()) + "</a></td>");
			sb.append("<td style=\"width:85\">" + commonUtil.cleanValue(getClubMemberInfo(user.getC_ID().trim(), "DESCRIPTION", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId())) + "</td>");
			sb.append("<td style=\"width:85\">" + commonUtil.cleanValue(user.getC_ID().trim()) + "</td>");
			sb.append("<td style=\"width:85\">" + user.getC_inDate().substring(0, 10) + "</td>");
			sb.append("<td style=\"width:150\">");
			
			if (user.getC_lastDate() != null) {
				sb.append(user.getC_lastDate().substring(0, 10));
			}
			
			sb.append("</td>");
			sb.append("<td style=\"width:55; align:center\">" + user.getC_visited() + egovMessageSource.getMessage("ezCommunity.t728", userInfo.getLocale()) + "</td></tr>");
		}
		
		return sb.toString();
	}

	@Override
	public void adminLogoOk(MultipartHttpServletRequest request, int tenantID) throws Exception {
		String attachFile = "", extName = "";
		int iStart = 0;
		
		String code = request.getParameter("code");
		String copType = request.getParameter("type");
		String imageSrc = request.getParameter("imageSrc");
		MultipartFile logoFile = request.getFile("logo");
		
		String logoPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_community.LOGO", tenantID) + commonUtil.separator;
		
		if (!logoFile.isEmpty()) {
			String fileName = code;
			attachFile = logoFile.getOriginalFilename();
			iStart = attachFile.lastIndexOf(".");
			extName = attachFile.substring(iStart);
			String logoFileName = fileName + "_logo_Temp" + "." + extName;
			
			File file = new File(logoPath + logoFileName);
			logoFile.transferTo(file);
			
			BufferedImage inputImage = ImageIO.read(file);
			BufferedImage outputImage = null;
			Graphics2D saveImage = null;
			
			outputImage= new BufferedImage(894, 100, BufferedImage.TYPE_INT_RGB);
			saveImage = outputImage.createGraphics();
			saveImage.drawImage(inputImage, 0, 0, 894, 100, null);
			
			File newLogo = new File(logoPath + fileName + "_logo" + ".png");
			ImageIO.write(outputImage, "png", newLogo);
			String logoFileNameLogo = fileName + "_logo" + ".png";
			
			outputImage = new BufferedImage(198, 140, BufferedImage.TYPE_INT_RGB);
			saveImage = outputImage.createGraphics();
			saveImage.drawImage(inputImage, 0, 0, 198, 140, null);
			
			File newThumbnail = new File(logoPath + fileName + "_thumbnail" + ".png");
			ImageIO.write(outputImage, "png", newThumbnail);
			String logoFileNameThumbnail = fileName + "_thumbnail" + ".png";
			
			file.delete();
			
			adminLogoOkUpdate1(logoFileNameLogo, logoFileNameThumbnail, fileName, tenantID);
		}
		
		if (!copType.equals("")) {
			adminCommType(copType, code, tenantID);
			
			if (logoFile.isEmpty()) { 
				if (imageSrc.indexOf("default_logo_type") > -1) {
					adminLogoOkUpdate1("default_logo_" + copType + ".jpg", "default_logo_" + copType + ".jpg", code, tenantID);
				}
			}
		}
	}
	
	@Override
	public void adminLogoUploadIE9(String code, String copType, String imageSrc, String logoPath, String fileName, String fileData, int tenantID) throws Exception {
		int iStart = 0;
		if (fileData != null) {
			iStart = fileName.lastIndexOf(".");
			String extName = fileName.substring(iStart);
			String logoFileName = code + "_logo_Temp" + "." + extName;
			
			File file = new File(logoPath + logoFileName);
	        byte[] byteList = Base64.decodeBase64(fileData);
	        
	        FileOutputStream fos = null;
	        
	        try {
	        	fos = new FileOutputStream(file);
	            IOUtils.write(byteList, fos);
	            
	            BufferedImage inputImage = ImageIO.read(file);
				BufferedImage outputImage = null;
				Graphics2D saveImage = null;
				
				outputImage= new BufferedImage(894, 100, BufferedImage.TYPE_INT_RGB);
				saveImage = outputImage.createGraphics();
				saveImage.drawImage(inputImage, 0, 0, 894, 100, null);
				
				File newLogo = new File(logoPath + code + "_logo" + ".png");
				ImageIO.write(outputImage, "png", newLogo);
				String logoFileNameLogo = code + "_logo" + ".png";
				
				outputImage = new BufferedImage(198, 140, BufferedImage.TYPE_INT_RGB);
				saveImage = outputImage.createGraphics();
				saveImage.drawImage(inputImage, 0, 0, 198, 140, null);
				
				File newThumbnail = new File(logoPath + code + "_thumbnail" + ".png");
				ImageIO.write(outputImage, "png", newThumbnail);
				String logoFileNameThumbnail = code + "_thumbnail" + ".png";
				
				adminLogoOkUpdate1(logoFileNameLogo, logoFileNameThumbnail, code, tenantID);
	        } catch (Exception e) {
	        	throw e;
	        } finally {
	        	fos.close();
	        	file.delete();
	        }
		}
		
		if (!copType.equals("")) {
			adminCommType(copType, code, tenantID);
			
			if (fileData != null) { 
				if (imageSrc.indexOf("default_logo_type") > -1) {
					adminLogoOkUpdate1("default_logo_" + copType + ".jpg", "default_logo_" + copType + ".jpg", fileName, tenantID);
				}
			}
		}
	}

	@Override
	public String adminHomeBoard1(LoginVO userInfo, String code) throws Exception {
		StringBuilder listData = new StringBuilder();
		
		List<CommunityBoardInfoVO> boardInfoList = getBoardList(code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), "ALL", userInfo.getTenantId());
		
		for (CommunityBoardInfoVO boardInfo : boardInfoList) {
			listData.append("<ROW><CELL><VALUE>");
			listData.append(commonUtil.cleanValue(boardInfo.getBoardName()));
			listData.append("</VALUE>");
			listData.append("<DATA1>" + commonUtil.cleanValue(boardInfo.getBoardID()) + "</DATA1>");
			listData.append("</CELL></ROW>");
		}
		
		return listData.toString();
	}

	@Override
	public String adminHomeBoard2(LoginVO userInfo, String code) throws Exception {
		StringBuilder listData = new StringBuilder();
		
		List<CommunityBoardInfoVO> boardInfoList2 = getBoardList(code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), "LEFT", userInfo.getTenantId());
		
		for (CommunityBoardInfoVO boardInfo : boardInfoList2) {
			listData.append("<ROW><CELL><VALUE>");
			listData.append(commonUtil.cleanValue(boardInfo.getBoardName()));
			listData.append("</VALUE>");
			listData.append("<DATA1>" + commonUtil.cleanValue(boardInfo.getBoardID()) + "</DATA1>");
			listData.append("</CELL></ROW>");
		}
		
		return listData.toString();
	}

	@Override
	public String adminHomeBoard3(LoginVO userInfo, String code) throws Exception {
		StringBuilder listData = new StringBuilder();
		
		List<CommunityBoardInfoVO> boardInfoList3 = getBoardList(code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), "RIGHT", userInfo.getTenantId());
		
		for (CommunityBoardInfoVO boardInfo : boardInfoList3) {
			listData.append("<ROW><CELL><VALUE>");
			listData.append(commonUtil.cleanValue(boardInfo.getBoardName()));
			listData.append("</VALUE>");
			listData.append("<DATA1>" + commonUtil.cleanValue(boardInfo.getBoardID()) + "</DATA1>");
			listData.append("</CELL></ROW>");
		}
		
		return listData.toString();
	}

	@Override
	public String adminOuterList(LoginVO userInfo, String code) throws Exception {
		logger.debug("adminOuterList started.");
		
		List<CommunityCOutApplicationVO> list = adminOuterListGet2(code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		
		int iCount = 1, curPage = 0;
		StringBuilder sb = new StringBuilder();
		
		for (CommunityCOutApplicationVO outApplication : list) {
			sb.append("<tr>");
            sb.append("<td height=\"23\" align=\"center\" >" + iCount + "</td>");
            sb.append("<td>" + commonUtil.cleanValue(outApplication.getUserName().trim()) + "</td>");
            sb.append("<td>" + commonUtil.cleanValue(outApplication.getUserID().trim()) + "</td>");
            sb.append("<td align=\"center\">" + outApplication.getOutDate().substring(0, 10) + "</td>");
            sb.append("<td align=\"center\">");
            sb.append("<a href=\"javascript:okno('ok','" + commonUtil.cleanValue(outApplication.getUserID().trim()) + "','" + code + "','" + curPage + "','" + commonUtil.cleanValue(outApplication.getUserName().trim()) + "');\" class=\"imgbtn\"  ><span style=\"width:40px\">" + egovMessageSource.getMessage("ezCommunity.t46", userInfo.getLocale()) + "</span></a><a href=\"javascript:okno('no','" + commonUtil.cleanValue(outApplication.getUserID().trim()) + "','" + code + "','" + curPage + "','" + commonUtil.cleanValue(outApplication.getUserName().trim()) + "');\" class=\"imgbtn\"><span style=\"width:40px\">" + egovMessageSource.getMessage("ezCommunity.t552", userInfo.getLocale()) + "</span></a>");
            sb.append("</td>");
            sb.append("</tr>");
            sb.append("<tr>");
            sb.append("<td width='60' align='center' >" + egovMessageSource.getMessage("ezCommunity.t564", userInfo.getLocale()) + "</td>");
            sb.append("<td align='left' colspan='4'>");
            sb.append("<textarea id='reason' style='width: 100%;height:60px;box-sizing:border-box;-moz-box-sizing:border-box;' readonly>" + commonUtil.cleanValue(outApplication.getOutReason().trim()) + "</textarea>");
            sb.append("</td>");
            sb.append("</tr>");
			
			iCount++;
		}
		
		logger.debug("adminOuterList ended.");
		
		return sb.toString();
	}

	@Override
	public String adminMemberList(LoginVO userInfo, String code, String flag, String ser, String strSysopID, String mode) throws Exception {
		logger.debug("adminMemberList started.");
		
		List<CommunityCClubUserVO> list = adminMemberListGet3(code, flag.toUpperCase(), commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), ser, userInfo.getTenantId());
		
		int iCount = 1;
		StringBuilder sb = new StringBuilder();
		
		for (CommunityCClubUserVO clubUser : list) {
			sb.append("<tr>");
			sb.append("<td height=\"23\" align=\"center\" class=\"white\">" + iCount + "</td>");
			sb.append("<td class=\"white\">");
			
			if (clubUser.getC_ID().trim().equals(strSysopID.trim())) {
				sb.append("<img src=\"/images/i_master.gif\" alt=\"" + egovMessageSource.getMessage("ezCommunity.t513", userInfo.getLocale()) + "\" WIDTH=\"15\" HEIGHT=\"9\" hspace=\"2\" border=\"0\" align=\"absmiddle\">");
			}
			
			sb.append("<a href=\"adminMemberListOk.do?code=" + code + "&mode=" + mode + "&cID=" + clubUser.getC_ID().trim() + "&cNm=encodeURIComponent(" + clubUser.getUserName() + ")&companyID=" + clubUser.getCompanyID().trim() + "\" valign=\"bottom\">");
			sb.append(clubUser.getUserName()+"</a>");
			sb.append("</td>");
			sb.append("<td class=\"white\">" + clubUser.getC_ID() + "</td>");
			sb.append("</tr>");
			
			iCount++;
		}
		
		logger.debug("adminMemberList ended.");
		
		return sb.toString();
	}

	@Override
	public int mainPage(LoginVO userInfo) throws Exception {
		logger.debug("mainPage started.");
		
		int totalPage = 0;
		
		List<String> clubNoList = myCommunityGet(userInfo.getId(), 0, 0, "CNT", userInfo.getTenantId());
		
		if (clubNoList.size() % 3 == 0) {
			totalPage = clubNoList.size() / 3;
		} else {
			totalPage = clubNoList.size() / 3 + 1;
		}
		
		logger.debug("mainPage ended.");
		
		return totalPage;
	}

	@Override
	public String myCopNewBoardItem(LoginVO userInfo, int startRow, int endRow) throws Exception {
		logger.debug("myCopNewBoardItem started.");
		
		StringBuilder rtnVal = new StringBuilder();
		
		List<String> clubNoList = myCommunityGet(userInfo.getId(), startRow, endRow, "LIST", userInfo.getTenantId());

		logger.debug("clubNoList.size : " + clubNoList.size());
		
		rtnVal.append("<ITEM><DATA>");
		
		for (String clubNo : clubNoList) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_copNo", clubNo.trim());
			map.put("v_pNow", commonUtil.getTodayUTCTime(""));
			map.put("tenantID", userInfo.getTenantId());
			
			logger.debug("v_copNo : " + clubNo.trim());
			
			List<CommunityMyCommunityVO> myCommunityList = ezCommunityDAO.myCommunityItemGet(map);
			
			logger.debug("myCommunityList.size() : " + myCommunityList.size());
			
			for(CommunityMyCommunityVO myCommunity : myCommunityList) {
				rtnVal.append(commonUtil.getQueryResult(myCommunity));
			}
		}
		
		rtnVal.append("</DATA></ITEM>");
		
		logger.debug("myCopNewBoardItem ended.");
		
		return rtnVal.toString();
	}

	@Override
	public String getBestNewCommunity(LoginVO userInfo, String mode) throws Exception {
		logger.debug("getBestNewCommunity started.");
		
		StringBuilder rtnVal = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_LANG", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		map.put("tenantID", userInfo.getTenantId());
		
		rtnVal.append("<DATA>");
		
		if (mode.equals("BEST")) {
			logger.debug("mainPageGet5 started.");
			
			List<CommunityMyCommunityVO> list = ezCommunityDAO.mainPageGet5(map);
			
			logger.debug("mainPageGet5 ended.");
			
			for (CommunityMyCommunityVO vo : list) {
				rtnVal.append(commonUtil.getQueryResult(vo));
			}
			
		} else {
			logger.debug("mainPageGet6 started.");
			
			map.put("v_pNow", commonUtil.getTodayUTCTime(""));
			
			List<CommunityMyCommunityVO> list = ezCommunityDAO.mainPageGet6(map);
			
			logger.debug("mainPageGet6 ended.");
			
			for (CommunityMyCommunityVO vo : list) {
				rtnVal.append(commonUtil.getQueryResult(vo));
			}
		}
		
		rtnVal.append("</DATA>");
		
		logger.debug("getBestNewCommunity ended.");
		
		return rtnVal.toString();
	}

	@Override
	public String leftCommunityGet1(String code, String id, int tenantID) throws Exception {
		logger.debug("leftCommunityGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_USERINFO_USERID", id);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.leftCommunityGet1(map);
		
		logger.debug("leftCommunityGet1 ended. result=" + result);
		
		return result;
	}
	
	@Override
	public void updateLastDate(String strNow, String code, String id, int tenantID) throws Exception {
		logger.debug("updateLastDate started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("STRNOW", strNow);
		map.put("CODE", code);
		map.put("ID", id);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.updateLastDate(map);
		
		logger.debug("updateLastDate ended.");
	}

	@Override
	public String getBoardTitleName(String strBoardName, String strClubNo, int tenantID) throws Exception {
		logger.debug("getBoardTitleName started.");
		logger.debug("strBoardName : " + strBoardName + ", strClubNo : " + strClubNo + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_STRBOARDNAME", strBoardName);
		map.put("v_STRCLUBNO", strClubNo);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.getBoardTitleName(map);
		
		logger.debug("getBoardTitleName started.");
		
		return result;
	}

	@Override
	public int bbsListGet1(String bName, String lang, String pKeyword, String sRadio, int tenantID) throws Exception {
		logger.debug("bbsListGet1 started.");
		logger.debug("bName : " + bName + ", lang : " + lang + ", pKeyword : " + pKeyword + ", sRadio : " + sRadio + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_USERINFO_LANG", lang);
		map.put("v_KEYWORD", pKeyword);
		map.put("v_S_RADIO", sRadio.toUpperCase());
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.bbsListGet1(map);
		
		logger.debug("bbsListGet1 ended.");
		
		return result;
	}

	@Override
	public List<CommunityCBoardVO> bbsListGet2(String bName, String lang, String pKeyword, String sRadio, int tenantID) throws Exception {
		logger.debug("bbsListGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_USERINFO_LANG", lang);
		map.put("v_KEYWORD", pKeyword);
		map.put("v_S_RADIO", sRadio.toUpperCase());
		map.put("tenantID", tenantID);
		
		List<CommunityCBoardVO> list = ezCommunityDAO.bbsListGet2(map);
		
		logger.debug("bName : " + bName + ", lang : " + lang + ", pKeyword : " + pKeyword + ", sRadio : " + sRadio);
		logger.debug("bbsListGet2 ended.");
		
		return list;
	}

	@Override
	public String bbsEditGet1(String bName, String no, int tenantID) throws Exception {
		logger.debug("bbsEditGet1 started.");
		logger.debug("bName : " + bName + ", no : " + no + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_NO", no);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.bbsEditGet1(map);
		
		logger.debug("bbsEditGet1 ended.");
		
		return result;
	}

	@Override
	public CommunityCBoardVO bbsViewNewGet1(String bName, String no, int tenantID, String offset) throws Exception {
		logger.debug("bbsViewNewGet1 started.");
		logger.debug("bName : " + bName + ", no : " + no + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_NO", no);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.bbsViewNewUpdate(map);
		CommunityCBoardVO vo = ezCommunityDAO.bbsViewNewGet1(map);
		
		logger.debug("bbsViewNewGet1 ended.");
		
		return vo;
	}

	@Override
	public CommunityCBoardVO bbsEditNew(String bName, String no, String lang, int tenantID) throws Exception {
		logger.debug("bbsEditNew started.");
		logger.debug("bName : " + bName + ", no : " + no + ", lang : " + lang + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_NO", no);
		map.put("v_USERINFO_LANG", lang);
		map.put("tenantID", tenantID);
		
		CommunityCBoardVO vo = ezCommunityDAO.bbsEditNew(map);
		
		logger.debug("bbsEditNew ended.");
		
		return vo;
	}
	
	@Override
	public List<CommunityCBoardVO> bbsViewNewGet2(String bName, int tenantID) throws Exception {
		logger.debug("bbsViewNewGet2 started.");
		logger.debug("bName : " + bName + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("tenantID", tenantID);
		
		List<CommunityCBoardVO> list = ezCommunityDAO.bbsViewNewGet2(map);
		
		logger.debug("bbsViewNewGet2 ended.");
		
		return list;
	}

	@Override
	public CommunityCBoardVO bbsDelOkGet(String bName, String itemNo, String code, int tenantID) throws Exception {
		logger.debug("bbsDelOkGet started.");
		logger.debug("bName : " + bName + ", itemNo : " + itemNo + ", code : " + code + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_NO", itemNo);
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		CommunityCBoardVO vo = ezCommunityDAO.bbsDelOkGet(map);
		
		logger.debug("bbsDelOkGet ended.");
		
		return vo;
	}

	@Override
	public void joinOkInsert(String companyID, String userID, String userName, String userName2, String companyName, String companyName2, String companyZip, String companyAddress, String deptName, String deptName2, String companyTel, String companyFax, String homeTel, String handPhone, String eMail, String birthDay, String gender, int tenantID) throws Exception {
		logger.debug("joinOkInsert started.");
		
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
		map.put("tenantID", tenantID);
		
		logger.debug("joinOkInsert ended.");
		
		ezCommunityDAO.joinOkInsert(map);
	}
	
	@Override
	public String commHomeGet1(String id, String code, int tenantID) throws Exception {
		logger.debug("commHomeGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_USERID", id);
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.commHomeGet1(map);
		
		logger.debug("commHomeGet1 ended.");
		
		return result;
	}

	@Override
	public String commHomeGet4(String code, int tenantID) throws Exception {
		logger.debug("commHomeGet4 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.commHomeGet4(map);
		
		logger.debug("commHomeGet4 ended.");
		
		return result;
	}
	

	@Override
	public CommunityClubVO aspCommInfoGet1(String code, int tenantID) throws Exception {
		logger.debug("aspCommInfoGet1 started.");
		logger.debug("code : " + code + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		CommunityClubVO vo = ezCommunityDAO.aspCommInfoGet1(map);
		
		logger.debug("aspCommInfoGet1 ended.");
		
		return vo;
	}

	@Override
	public String getCommunityThumInfo(String pBoardID, String pFileName, String pType, int tenantID) throws Exception {
		logger.debug("getCommunityThumInfo started.");
		
		String pSignatureDir = ""; 
		
		if (pType.equals("COMMUNITYTHUM")) {
			pSignatureDir = commonUtil.getUploadPath("upload_community.ROOT", tenantID);
		} else {
			pSignatureDir = commonUtil.getUploadPath("upload_community.LOGO", tenantID);
		}
		
		String pResult = pSignatureDir + commonUtil.separator + pFileName;
		
		logger.debug("getCommunityThumInfo ended.");
		
		return pResult;
	}

	@Override
	public boolean communityConnCHK(String id, String clubID, String boardID, String rollInfo, int mode, HttpServletResponse response, LoginVO userInfo) throws Exception {
		logger.debug("communityConnCHK started.");
		logger.debug("rollInfo = " + rollInfo);
		String rtnValue = "";
		boolean result = false;

		if (rollInfo.indexOf("c=1") < 0) {
			rtnValue = getClubCHK(id, clubID, boardID, userInfo.getTenantId());
		} else {
			rtnValue = "1";
		}
		
		if (mode == 0 && (rtnValue.equals("1") || rtnValue.equals("2"))) {
			result = true;
		}
		
		if (mode == 1 && rtnValue.equals("1")) {
			result = true;
		}
		
//		if (result != true) {
//			response.setCharacterEncoding("UTF-8");
//			response.getWriter().write(egovMessageSource.getMessage("ezCommunity.t423", userInfo.getLocale()));
//			response.getWriter().flush();
//		}
		
		logger.debug("communityConnCHK ended.");
		
		return result;
	}

	private String getClubCHK(String id, String clubID, String boardID, int tenantID) throws Exception{
		logger.debug("getClubCHK started.");
		logger.debug("id : " + id + ", clubID : " + clubID + ", boardID : " + boardID + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", id);
		map.put("v_PCLUBNO", clubID);
		map.put("v_PBOARDID", boardID);
		map.put("tenantID", tenantID);
		
		String result = "";
		
		int temp = ezCommunityDAO.getClubCHKGet1(map);
		
		if (temp != 0) {
			result = "1";
		} else {
			temp = ezCommunityDAO.getClubCHKGet2(map);
			
			if (temp != 0) {
				result = "2";
			} else {
				result = "3";
			}
		}
		
		logger.debug("result : " + result);
		logger.debug("getClubCHK ended.");
		
		return result;
	}

	@Override
	public String getBoardTree(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String strLang, int tenantID) throws Exception {
		logger.debug("getBoardTree started.");
		
		int count = 0;
        String strForbiddenBoardIDList = "";
		StringBuilder result;
		List<CommunityBoardTreeVO> boardTreeList = null;
		List<CommunityBoardTreeVO> brdBoardTreeList = new ArrayList<CommunityBoardTreeVO>();
		
		String retValue = getBoardTreeGet1(pRootBoardID, pUserID, pDeptID, pCompanyID, pMode, pSubFlag, pSelectBy, pExcludeBoardID, pClubNo, strLang, tenantID);
		
        if (retValue != null && retValue.length() > 30) {
    		return retValue;
        }
        
        String pAccessID = pUserID + "," + ezOrganService.getDeptFullPath(pDeptID, tenantID) + ",EVERYONE";
        String strRollInfo = ezOrganService.getPropertyValue(pUserID, "extensionattribute1", tenantID);
        
        for (int i = 0; i < pAccessID.split(",").length; i++) {
        	boardTreeList = getBoardTreeGet2(pAccessID.split(",")[i].trim(), tenantID);
        	brdBoardTreeList = brdBoardTree(pRootBoardID, pAccessID.split(",")[i].trim(), "", "", pMode, pSelectBy, pExcludeBoardID, pClubNo, tenantID);
        	logger.debug("brdBoardTreeList.size : " + brdBoardTreeList.size());
        	
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
            result.append("<ISLEAF>" + checkIfLeafBoard(brdBoardTreeList.get(i).getBoardID(), tenantID) + "</ISLEAF>");

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
        
        getBoardTreeSet(pRootBoardID, pUserID, pDeptID, pCompanyID, pMode, pSubFlag, pSelectBy, pExcludeBoardID, pClubNo, strLang, result.toString().replace("'", "''"), tenantID);

        logger.debug("getBoardTree ended.");
        
        return result.toString();
	}

	@Override
	public CommunityBoardPropertyVO getBoardInfo(LoginVO userInfo, String pBoardID) throws Exception {
		CommunityBoardPropertyVO boardInfo = new CommunityBoardPropertyVO();

		if (pBoardID.equals("")) {
			boardInfo.setBoardName(egovMessageSource.getMessage("ezCommunity.t91", userInfo.getLocale()));
			boardInfo.setBoardName2(egovMessageSource.getMessage("ezCommunity.t91", userInfo.getLocale()));
			return boardInfo;
		}
		
		String userDeptPath = userInfo.getDeptPathCode() + ",EVERYONE";
		
		CommunityBoardPropertyVO boardInfoTemp = null;
		
		for (int i=0; i<userDeptPath.split(",").length; i++) {
			boardInfoTemp = brdGetACL(pBoardID, userDeptPath.split(",")[i].trim(), userInfo.getTenantId());
			
			if (boardInfoTemp != null) {
				break;
			}
		}
		
		String boardGroupAdmin_FG = checkIfBoardGroupAdmin(pBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getTenantId());
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
		} else if (boardInfoTemp.getBoardAdmin_FG() == null || boardInfoTemp.getBoardAdmin_FG().equals("")) {
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("false");
			boardInfo.setListView_FG("false");
			boardInfo.setRead_FG("false");
			boardInfo.setWrite_FG("false");
			boardInfo.setReply_FG("false");
			boardInfo.setDelete_FG("false");
		} else {
			boardInfo.setAccess_FG(Integer.toString(boardInfoTemp.getAccess_()));
			boardInfo.setBoardAdmin_FG(boardInfoTemp.getBoardAdmin_FG().toLowerCase());
			boardInfo.setListView_FG(boardInfoTemp.getListView_FG().toLowerCase());
			boardInfo.setRead_FG(boardInfoTemp.getRead_FG().toLowerCase());
			boardInfo.setWrite_FG(boardInfoTemp.getWrite_FG().toLowerCase());
			boardInfo.setReply_FG(boardInfoTemp.getReply_FG().toLowerCase());
			boardInfo.setDelete_FG(boardInfoTemp.getDelete_FG().toLowerCase());
		}
		
		CommunityBoardPropertyVO strProp = getBoardProperty(pBoardID, userInfo.getTenantId());
		
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
			boardInfo.setSs_Board_MaxRows(12);
			boardInfo.setSs_SearchBoard_MaxRows(12);
		}
		
		boardInfo.setBoardID(pBoardID);
		
		return boardInfo;
	}

	@Override
	public CommunityBoardListVO boardItemListGet1(String pBoardID, String id, int tenantID) throws Exception {
		logger.debug("boardItemListGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", pBoardID);
		map.put("v_USERINFO_USERID", id);
		map.put("tenantID", tenantID);
		
		CommunityBoardListVO vo = ezCommunityDAO.boardItemListGet1(map);
		
		logger.debug("boardItemListGet1 ended.");
		
		return vo;
	}
	
	@Override
	public String checkIfBoardGroupAdmin(String pRootBoardID, String id, String deptID, String companyID, int tenantID) throws Exception {
		if (brdCheckIfBoardGroupAdmin(pRootBoardID, id, deptID, companyID, tenantID) > 0) {
			return "OK";
		} else {
			return "NO";
		}
	}
	
	@Override
	public CommunityBoardPropertyVO brdGetACL(String pBoardID, String pAccessID, int tenantID) throws Exception {
		logger.debug("brdGetACL started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", pBoardID);
		map.put("v_pAccessID", pAccessID);
		map.put("tenantID", tenantID);
		
		CommunityBoardPropertyVO vo = ezCommunityDAO.brdGetACL(map);
		
		logger.debug("brdGetACL ended.");
		
		return vo;
	}
	
	@Override
	public CommunityBoardPropertyVO getBoardProperty(String pBoardID, int tenantID) throws Exception {
		logger.debug("getBoardProperty started.");
		logger.debug("pBoardID : " + pBoardID + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", pBoardID);
		map.put("tenantID", tenantID);
		
		CommunityBoardPropertyVO vo = ezCommunityDAO.getBoardProperty(map);
		
		logger.debug("getBoardProperty started.");
		
		return vo;
	}	
	
	@Override
	public String getCategory(String strSelCateA, String strSelCateB, String strSelCateC, LoginVO userInfo) throws Exception {
		logger.debug("getCategory started.");
		logger.debug("strSelCateA : " + strSelCateA + ", strSelCateB : " + strSelCateB + ", strSelCateC : " + strSelCateC);
		
		StringBuilder strHTML = new StringBuilder();
		
		strHTML.append("<Select name=\"cCateA\">");
		strHTML.append("<Option Value=\"0\">" + egovMessageSource.getMessage("ezCommunity.t80", userInfo.getLocale()) + "</Option>");
		strHTML.append(getCategoryValueA(strSelCateA, userInfo));
		strHTML.append("</Select>");
		strHTML.append("<Select name=\"cCateB\" class=\"text\">");
		strHTML.append("<Option Value=\"0\">" + egovMessageSource.getMessage("ezCommunity.t81", userInfo.getLocale()) + "</Option>");
		strHTML.append(getCategoryValueB(strSelCateB, userInfo));
		strHTML.append("</Select>");
		strHTML.append("<Select name=\"cCateC\" class=\"text\" style='display:none'>");
		strHTML.append("<Option Value=\"0\">" + egovMessageSource.getMessage("ezCommunity.t82", userInfo.getLocale()) + "</Option>");
		strHTML.append(getCategoryValueC(strSelCateC, userInfo));
		strHTML.append("</Select>");
		
		logger.debug("getCategory ended.");
		
		return strHTML.toString();
	}

	@Override
	public String searchItemXML(LoginVO userInfo, String boardID, String title, String writerName, String abstracts, String searchStart, String searchEnd, int pStartRow, int pEndRow) throws Exception {
		logger.debug("searchItemXML started.");
		
		StringBuilder sb = new StringBuilder();
		int count = 0;
		
		String id = userInfo.getId();
		String strLang = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
		String offset = userInfo.getOffset();
		int tenantID = userInfo.getTenantId();
		
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("v_pEndRow", pEndRow);
        map.put("v_strLang", strLang);
        map.put("v_pBoardID", boardID);
        map.put("v_pUserID", id);
        map.put("v_pTitle", title);
        map.put("v_pWriterName", writerName);
        map.put("v_pAbstract", abstracts);
        map.put("v_pStartDate", commonUtil.getDateStringInUTC(searchStart, offset, true));
        map.put("v_pEndDate", commonUtil.getDateStringInUTC(searchEnd, offset, true));
        map.put("v_pNow", commonUtil.getTodayUTCTime(""));
        map.put("tenantID", tenantID);
        
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
					sb.append("<WriteDate>" + commonUtil.getDateStringInUTC(boardList.getWriteDate(), offset, false) + "</WriteDate>");
				} else {
					sb.append("<WriteDate>" + commonUtil.getDateStringInUTC(boardList.getParentWriteDate(), offset, false) + "</WriteDate>");
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
		
		logger.debug("searchItemXML ended.");
		
		return sb.toString();
	}

	@Override
	public int searchItemCount(LoginVO userInfo, String boardID, String title, String writerName, String abstracts, String startDateTime, String endDateTime) throws Exception {
		logger.debug("searchItemCount started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardID);
		map.put("v_pTitle", title);
		map.put("v_pWriterName", writerName);
		map.put("v_pAbstract", abstracts);
		map.put("v_pStartDate", commonUtil.getDateStringInUTC(startDateTime, userInfo.getOffset(), true));
		map.put("v_pEndDate", commonUtil.getDateStringInUTC(endDateTime, userInfo.getOffset(), true));
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", userInfo.getTenantId());
		
		int result = ezCommunityDAO.searchItemCount(map);
		logger.debug("result=" + result);
		logger.debug("searchItemCount ended.");
		
		return result;
	}

	@Override
	public String setAsRead(LoginVO userInfo, String boardID, String itemIDList) throws Exception {
		logger.debug("setAsRead started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardID);
		map.put("v_pUserID", userInfo.getId());
		map.put("v_pUserName", userInfo.getDisplayName1());
		map.put("v_pUserDeptName", userInfo.getDeptName1());
		map.put("v_pUserCompanyName", userInfo.getCompanyName1());
		map.put("v_pUserTitle", userInfo.getTitle1());
		map.put("v_pUserName2", userInfo.getDisplayName2());
		map.put("v_pUserDeptName2", userInfo.getDeptName2());
		map.put("v_pUserCompanyName2", userInfo.getCompanyName2());
		map.put("v_pUserTitle2", userInfo.getTitle2());
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", userInfo.getTenantId());
		
		try {
			for (String item : itemIDList.split(";")) {
				map.put("v_pItemID", item);
				
				if (boardID.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
					map.put("v_pBoardID", ezCommunityDAO.setAsReadSelectBoardID(map));
					logger.debug("v_pBoardID : " + ezCommunityDAO.setAsReadSelectBoardID(map));
				}
				
				logger.debug("item : " + item);
				
				int temp = ezCommunityDAO.setAsReadSelectTemp(map);
				logger.debug("temp : " + temp);
				
				if (temp == 0) {
					ezCommunityDAO.setAsReadInsert(map);
				}
				
				ezCommunityDAO.setAsReadUpdate(map);
			}
			
			logger.debug("setAsRead ended.");
			
			return "OK";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.debug("setAsRead ERROR.");
			logger.error(e.getMessage());
			
			return "ERROR";
		}
	}

	@Override
	public void deleteItem(String itemList, int tenantID) throws Exception {
		logger.debug("deleteItem started.");
		
		String boardID = "";
		
		for (String itemID : itemList.split(";")) {
			itemID = itemID.split(",")[0];
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("itemID", itemID);
			map.put("tenantID", tenantID);
			
			boardID = ezCommunityDAO.deleteItemGet(map);
			
			logger.debug("itemID : " + itemID + ", boardID : " + boardID);
			
			ezCommunityDAO.deleteItem1(map);
			ezCommunityDAO.deleteItem2(map);
			ezCommunityDAO.deleteItem3(map);
			ezCommunityDAO.deleteItem5(map);
			
			map.put("boardID", boardID);
			
			ezCommunityDAO.deleteItem4(map);
		}
		
		logger.debug("deleteItem ended.");
	}

	@Override
	public String checkIfHasReply(String itemList, int tenantID) throws Exception {
		logger.debug("checkIfHasReply started.");
		
		for (String item : itemList.split(";")) {
			String itemID = item.split(",")[0];
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_pItemID", itemID);
			map.put("tenantID", tenantID);
			
			int ret = ezCommunityDAO.checkIfHasReply(map);
			logger.debug("itemID : " + itemID);
			logger.debug("ret : " + ret);

			if (ret != 0) {
				return "FALSE";
			}
		}
		
		logger.debug("checkIfHasReply ended.");
		
		return "TRUE";
	}

	@Override
	public CommunityBoardItemVO getItemXML(String pBoardID, String pItemID, int tenantID, String offset) throws Exception {
		logger.debug("getItemXML started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", pBoardID);
		map.put("v_pItemID", pItemID);
		map.put("tenantID", tenantID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		
		CommunityBoardItemVO vo = ezCommunityDAO.getItemXML(map);
		
		vo.setWriteDate(vo.getWriteDate().substring(0, 19));
		vo.setParentWriteDate(vo.getParentWriteDate().substring(0, 19));
		vo.setStartDate(vo.getStartDate().substring(0, 19));
		vo.setEndDate(vo.getEndDate().substring(0, 19));
		
		logger.debug("getItemXML ended.");
		
		return vo;
	}

	@Override
	public String newItem(Document xmlData, String pMode, String realPath, LoginVO userInfo) throws Exception {
		String pUploadFilePath = "", pContentLocation = "", pHasAttach = "", pContent = "";
		String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
    	String offset = userInfo.getOffset();
		boolean saveMHTResult = false;
		
		String dateStr = commonUtil.getTodayUTCTime("");
		
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
		item.setWriteDate(dateStr);
		item.setImportance(Integer.parseInt(xmlData.getElementsByTagName("IMPORTANCE").item(0).getTextContent()));
		item.setTitle(xmlData.getElementsByTagName("TITLE").item(0).getTextContent().trim());

		if (pMode.equals("copy")) {
			pContentLocation = xmlData.getElementsByTagName("CONTENTLOCATION").item(0).getTextContent();
		} else {
			pContentLocation = commonUtil.getUploadPath("upload_community.ROOT", userInfo.getTenantId()) + commonUtil.separator + item.getBoardID() + commonUtil.separator + "doc" + commonUtil.separator + item.getItemID() + ".mht";
		}
		
		item.setContentLocation(pContentLocation);
		item.setStartDate(commonUtil.getDateStringInUTC(xmlData.getElementsByTagName("STARTDATE").item(0).getTextContent(), offset, true));

		if (item.getStartDate().equals("")) {
			item.setStartDate(item.getWriteDate());
		}
		
		item.setEndDate(commonUtil.getDateStringInUTC(xmlData.getElementsByTagName("ENDDATE").item(0).getTextContent(), offset, true));
		item.setAbsTract(xmlData.getElementsByTagName("ABSTRACT").item(0).getTextContent());
		item.setAttachments(xmlData.getElementsByTagName("ATTACHMENTS").item(0).getTextContent());
		item.setUpperItemIDTree(xmlData.getElementsByTagName("UPPERITEMIDTREE").item(0).getTextContent());
		
		if (pMode.equals("reply")) {
//			item.setUpperItemIDTree(item.getUpperItemIDTree() + GetReverseDateNow() + item.getItemID());
		}
		
		item.setItemLevel(Integer.parseInt(xmlData.getElementsByTagName("ITEMLEVEL").item(0).getTextContent()));
		
		if (!pMode.equals("copy")) {
			pContent = xmlData.getElementsByTagName("CONTENT").item(0).getTextContent();
//			item.setParentWriteDate(xmlData.getElementsByTagName("PARENTWRITEDATE").item(0).getTextContent());
			item.setParentWriteDate(commonUtil.getDateStringInUTC(xmlData.getElementsByTagName("PARENTWRITEDATE").item(0).getTextContent(), offset, true));
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
				return egovMessageSource.getMessage("ezCommunity.lhj04", userInfo.getLocale());
			}
		}
		
		if (item.getAttachments().length() > 0) {
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
		map.put("tenantID", userInfo.getTenantId());

		if (pMode.equals("modify")) {
			logger.debug("modifyItem");
			ezCommunityDAO.brdUpdateItemUpdate(map);
			ezCommunityDAO.brdUpdateItemDelete(map);
		} else {
			logger.debug("newItem");
			int docNo= ezCommunityDAO.brdNewItemSelect(userInfo.getTenantId());
			logger.debug("docNo="+docNo);
			
			map.put("v_pDocNo", docNo + 1);
			
			ezCommunityDAO.brdNewItemInsert(map);
			
		}
		
		map = new HashMap<String, Object>();
		map.put("v_PITEMID", item.getItemID());
		map.put("tenantID", userInfo.getTenantId());
		
		ezCommunityDAO.newItemDel(map);
		
		if (item.getAttachments().length() > 0) {
			if (saveAttachmentsInfo(item, pUploadFilePath, realPath, userInfo.getTenantId()) == false) {
				return egovMessageSource.getMessage("ezCommunity.lhj05", userInfo.getLocale());
			}
			pHasAttach = "1";
		} else {
			pHasAttach = "0";
		}
		
		return "OK";
	}

	@Override
	public String getItemAttachmentXML(String itemID, int tenantID) throws Exception {
		logger.debug("getItemAttachmentXML started.");
		
		StringBuilder sb = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemID", itemID);
		map.put("tenantID", tenantID);
		
		List<CommunityBoardItemAttachmentVO> list = ezCommunityDAO.getItemAttachmentXML(map);

		sb.append("<NODES>");
		
		for (CommunityBoardItemAttachmentVO attach : list) {
			sb.append("<NODE>");
			sb.append("<ItemID>" + attach.getItemID() + "</ItemID>");
			sb.append("<GUID>" + attach.getGuID() + "</GUID>");
			sb.append("<FileName><![CDATA[" + attach.getFileName() + "]]></FileName>");
			sb.append("<FilePath><![CDATA[" + attach.getFilePath() + "]]></FilePath>");
			sb.append("<FileSize>" + getProperSizeDisplay(Integer.parseInt(attach.getFileSize())) + "</FileSize>");
			sb.append("<FileSize2>" + attach.getFileSize() + "</FileSize2>");
			sb.append("</NODE>");
		}
		
		sb.append("</NODES>");
		
		logger.debug("getItemAttachmentXML started.");
		
		return sb.toString();
	}

	@Override
	public String getReservedItemListXML(String id, int pStartRow, int pEndRow, String pSortBy, String lang, int tenantID, String offset) throws Exception {
		logger.debug("getReservedItemListXML started.");
		
		StringBuilder sb = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pEndRow", pEndRow);
		map.put("v_strLang", commonUtil.getMultiData(lang, tenantID));
		map.put("v_pUserID", id);
		map.put("v_pSortBy", pSortBy);
		map.put("tenantID", tenantID);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		
		
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
				sb.append("<StartDate>" + boardList.getStartDate().substring(0, 19) + "</StartDate>");
				sb.append("<EndDate>" + boardList.getEndDate().substring(0, 19) + "</EndDate>");
				sb.append("<Abstract>" + boardList.getAbsTract() + "</Abstract>");
				sb.append("</NODE>");
			}
		}
		
		sb.append("</NODES>");
		
		logger.debug("getReservedItemListXML ended.");
		
		return sb.toString();
	}

	@Override
	public int getReservedItemListCount(String id, int tenantID) throws Exception {
		logger.debug("getReservedItemListCount started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUserID", id);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.getReservedItemListCount(map); 
		
		logger.debug("getReservedItemListCount ended. result : " + result);
		
		return result;
	}

	@Override
	public List<CommunityOneLineReplyVO> readOneLineReply(String lang, String pBoardID, String pItemID, int tenantID, String offset) throws Exception {
		logger.debug("readOneLineReply started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_userInfo_lang", lang);
		map.put("v_pBoardID", pBoardID);
		map.put("v_pItemID", pItemID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		
		List<CommunityOneLineReplyVO> list = ezCommunityDAO.readOneLineReply(map);
		
		logger.debug("readOneLineReply ended.");
		
		return list;
	}

	@Override
	public void saveOneLineReply(Document xmlDoc, LoginVO userInfo) throws Exception {
		logger.debug("saveOneLineReply started.");
		
		String userName = "", userName2 = "";
		String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
		
		String pItemID = xmlDoc.getElementsByTagName("ITEMID").item(0).getTextContent();
		String pReplyID = xmlDoc.getElementsByTagName("REPLYID").item(0).getTextContent();
		String pBoardID = xmlDoc.getElementsByTagName("BOARDID").item(0).getTextContent();
		String pContent = xmlDoc.getElementsByTagName("CONTENT").item(0).getTextContent();
		String pPassword = xmlDoc.getElementsByTagName("PASSWORD").item(0).getTextContent();

		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		String rpwd = EgovFileScrty.decryptRsa(pk, pPassword);
		pPassword = EgovFileScrty.encryptPassword(rpwd, "unknown");
		
		String[] u_Name = egovMessageSource.getMessage("ezCommunity.t115", userInfo.getLocale()).split(";");
		
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
		
		pContent = pContent.replaceAll("'",  "''");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PITEMID", pItemID);
		map.put("v_PREPLYID", pReplyID);
		map.put("v_PBOARDID", pBoardID);
		map.put("v_USERID", userInfo.getId());
		map.put("v_USERNAME", userName);
		map.put("v_USERNAME2", userName2);
		map.put("v_PCONTENT", pContent);
		map.put("v_PPASSWORD", pPassword);
		map.put("tenantID", userInfo.getTenantId());
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		
		ezCommunityDAO.saveOneLineReply(map);
		
		logger.debug("saveOneLineReply ended.");
	}

	@Override
	public String checkReplyPassword(String pItemID, String pReplyID, int tenantID) throws Exception {
		logger.debug("checkReplyPassword started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PITEMID", pItemID);
		map.put("v_REPLYID", pReplyID);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.checkReplyPassword(map);
		
		logger.debug("checkReplyPassword ended.");
		
		return result;
	}

	@Override
	public String checkOneLineOwner(String pReplyID, String id, int tenantID) throws Exception {
		logger.debug("checkOneLineOwner started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_REPLYID", pReplyID);
		map.put("v_USERINFO_USERID", id);
		map.put("tenantID",tenantID);

		int result = ezCommunityDAO.checkOneLineOwner(map);
		
		logger.debug("checkOneLineOwner ended.");
		
		if (result > 0) {
			return "OK_MINE";
		} else {
			return "FAIL";
		}
	}

	@Override
	public void deleteOneLineReply(String id, String pReplyID, String gubun, int tenantID) throws Exception {
		logger.debug("deleteOneLineReply started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_USERID", id);
		map.put("v_REPLYID", pReplyID);
		map.put("v_GUBUN", gubun);
		map.put("tenantID", tenantID);
		
		int totalCount = ezCommunityDAO.deleteOneLineReplySelect(map);
		
		if (totalCount > 0) {
			ezCommunityDAO.deleteOneLineReplyDelete(map);
		}
		
		logger.debug("deleteOneLineReply ended.");
	}
	
	@Override
	public String bbsList(LoginVO userInfo, List<CommunityCBoardVO> cBoardList, String code, int curPage, String bName, int comNoPerPage) throws Exception {
		StringBuilder strHTML = new StringBuilder();
		int iColSpan = 5;
		
		if (bName.equals("tbl_c_clubpds") || bName.equals("tbl_c_clubpds1")) {
			iColSpan = 6;
		}
		
		strHTML.append("<tr>");
		strHTML.append("<th width=\"60px\" >" + egovMessageSource.getMessage("ezCommunity.t32", userInfo.getLocale()) + "</th>");
		strHTML.append("<th>" + egovMessageSource.getMessage("ezCommunity.t170", userInfo.getLocale()) + "</th>");
		strHTML.append("<th width=\"70px\">" + egovMessageSource.getMessage("ezCommunity.t138", userInfo.getLocale()) + "</th>");
		strHTML.append("<th width=\"90px\">" +  egovMessageSource.getMessage("ezCommunity.t171", userInfo.getLocale()) + "</th>");
		
		if (iColSpan == 6) {
			strHTML.append("<th width=\"45px\">" + egovMessageSource.getMessage("ezCommunity.t172", userInfo.getLocale()) + "</th>");
		}
		
		strHTML.append("<th width=\"60px\">" + egovMessageSource.getMessage("ezCommunity.t173", userInfo.getLocale()) + "</th>");
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
			
			if (!bName.equals("tbl_c_clubnotice") && !bName.equals("tbl_c_notice")) {
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
			
			if (!bName.equals("tbl_c_clubnotice") && !bName.equals("tbl_c_notice")) {
				if (cBoard.getRe_Level() > 0) {
					 int wid = 10 * cBoard.getRe_Level();
					 
                     strHTML.append("<img src=\"/images/dum.gif\" width=\"" + wid + "\" height=\"1\" border=\"0\">"); 
                     strHTML.append("<img src=\"/images/i_rep.gif\" alt border=\"0\" VALIGN=\"TOP\">"); 
				}
			}
			
			String nowDate = commonUtil.getTodayUTCTime("");
			nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");

			if (cBoard.getWriteDay().compareTo(nowDate) >= 0) {
				strHTML.append("<img src=\"/images/i_new.gif\" alt border=\"0\">");
			}
			
			strHTML.append(commonUtil.cleanValue(cBoard.getTitle().trim())+"</nobr></td>");
			
			if (commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()).equals("")) {
				strHTML.append("<td class=\"t1\" width=\"70px\" >" + cBoard.getUserName().trim() + "</td>");
			} else {
				strHTML.append("<td class=\"t1\" width=\"70px\" >" + cBoard.getUserName2().trim() + "</td>");
			}
			
			strHTML.append("<td class=\"t1\" width=\"90px\" >" + cBoard.getWriteDay().substring(0, 10) + "</td>");
			 
			/*String localPdsPath = "";*/
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
	public String bbsEditOk(LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("bbsEditOk started.");
		
		int myRef = 0, myStep = 0, myLevel = 0, adminCheck = 0;
		String mode = request.getParameter("mode");
		String code = request.getParameter("code");
		String bName = request.getParameter("bName");
		String no = request.getParameter("no");
		String textContent = request.getParameter("textContent");
		String MHTcontent = request.getParameter("content");
		String title = request.getParameter("title");
		/*String sRadio = request.getParameter("sRadio");
		String keyword = request.getParameter("keyword");
		String id = request.getParameter("id");
		String goToPage = request.getParameter("goToPage");
		String block = request.getParameter("nowBlock");*/
		String attachList = request.getParameter("attachList");
		String userNm = request.getParameter("userNM");
		String userNm2 = request.getParameter("userNM2");
		String realPath = commonUtil.getRealPath(request);

		if (!request.getParameter("ref").equals("")) {
            myRef = Integer.parseInt(request.getParameter("ref"));
		}
        if (!request.getParameter("step").equals("")) {
            myStep = Integer.parseInt(request.getParameter("step"));
        }
        if (!request.getParameter("level").equals("")) {
            myLevel = Integer.parseInt(request.getParameter("level"));
        }
		
        String maxIdFieldName = "c_no";
        
        InputStream is = null;
        OutputStream os = null;
        PrintWriter pw = null;
		
		if (mode.equals("edit")) {
        	CommunityCBoardVO cBoard = bbsEditOkGet1(bName, no, code, userInfo.getTenantId());
        	
        	if (userInfo.getRollInfo().indexOf("c=1") >= 0) {
    			adminCheck = 1;
    		}

        	if (cBoard != null) {
        		if (cBoard.getId().trim().equals(userInfo.getId()) || adminCheck == 1) {
	                bbsEditOkSet1(bName.toUpperCase(), title, no, code, attachList, textContent, userInfo.getTenantId());
	                String strPath = realPath + commonUtil.getUploadPath("upload_community.FILEDATA", userInfo.getTenantId()) + commonUtil.separator + getFileFolderName(bName) + commonUtil.separator + cBoard.getFileName().trim();
	                logger.debug("strPath ==== " + strPath);
	                try{
		    		    pw = new PrintWriter(new File(strPath));
			    		pw.print(MHTcontent);
			    		pw.flush();
			    		pw.close();
	                } catch (FileNotFoundException fnfe) {
	    				logger.debug("fnfe: {}", fnfe);
	    			} catch (Exception e) {
	    				logger.debug("e: {}", e);
	    			} finally {
	    			    if (os != null) {
	    					try {
	    					    os.close();
	    					} catch (Exception ignore) {
	    						logger.debug("IGNORED: {}", ignore.getMessage());
	    					}
	    			    }
	    			    
	    			    if (is != null) {
	    					try {
	    					    is.close();
	    					} catch (Exception ignore) {
	    						logger.debug("IGNORED: {}", ignore.getMessage());
	    					}
	    			    }
	                }
	        	}
        	}
        } else {
        	String fileName = "";
        	int newStep = 0, newLevel = 0;
        	int maxNum = 0, number = 0;
        	
        	int strMaxNum = bbsEditOkGet2(maxIdFieldName, bName, code, userInfo.getTenantId());
        	
        	if (strMaxNum != 0) {
        		fileName = bbsEditOkGet3(maxIdFieldName, bName, code, strMaxNum, userInfo.getTenantId());
        		maxNum = strMaxNum;
        	}
        	
        	number = maxNum + 1;
        	
        	if (no.equals("")) {
        		myRef = number;
        		newStep = 0;
        		newLevel = 0;
        	} else {
        		if (!bName.equals("tbl_c_clubnotice") && !bName.equals("tbl_c_notice")) {
        			bbsEditOkSet2(bName.toUpperCase(), myRef, myStep, code, userInfo.getTenantId());
        		}
        		
        		newStep = myStep + 1;
        		newLevel = myLevel + 1;
        	}
        	
        	String dirPath = "";
        	String strPath = "";
        	
        	if (strMaxNum == 0){
                if (code.equals("")) {
                    fileName = "0000000001.mht";
                } else {
                    fileName = "0000000001" + "(" + code + ").mht";
                }
                
                dirPath = realPath + commonUtil.getUploadPath("upload_community.FILEDATA", userInfo.getTenantId()) + commonUtil.separator + getFileFolderName(bName) + commonUtil.separator;
                strPath = realPath + commonUtil.getUploadPath("upload_community.FILEDATA", userInfo.getTenantId()) + commonUtil.separator + getFileFolderName(bName) + commonUtil.separator +fileName;
            } else {
                int iName = strMaxNum;
                iName = iName + 1;
                String strName = "000000000" + iName;
                strName = strName.substring(strName.length() - 10, strName.length());

                if (!code.equals("")){
                    strName = strName + "(" + code + ")";
                }
                
                fileName = strName + ".mht";
                dirPath = realPath + commonUtil.getUploadPath("upload_community.FILEDATA", userInfo.getTenantId()) + commonUtil.separator + getFileFolderName(bName) + commonUtil.separator;
                strPath = realPath + commonUtil.getUploadPath("upload_community.FILEDATA", userInfo.getTenantId()) + commonUtil.separator + getFileFolderName(bName) + commonUtil.separator + fileName;
            }

        	String nowDate = commonUtil.getTodayUTCTime("");
        	
        	bbsEditOkInsert(bName.toUpperCase(), myRef, newStep, newLevel, attachList, number, textContent, nowDate, fileName, code, userInfo.getCompanyID(), userInfo.getId(), userNm, userNm2, title, maxIdFieldName, userInfo.getTenantId());
        	
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
 				logger.debug("fnfe: {}", fnfe);
 			} catch (Exception e) {
 				logger.debug("e: {}", e);
 			} finally {
 			    if (os != null) {
 					try {
 					    os.close();
 					} catch (Exception ignore) {
 						logger.debug("IGNORED: {}", ignore.getMessage());
 					}
 			    }
 			    
 			    if (is != null) {
 					try {
 					    is.close();
 					} catch (Exception ignore) {
 						logger.debug("IGNORED: {}", ignore.getMessage());
 					}
 			    }
             }
        }
		
		logger.debug("bbsEditOk ended.");
		return "OK";
	}

	@Override
	public String bbsDelOk(LoginVO userInfo, HttpServletRequest request, CommunityCBoardVO board, String itemNo, String goToPage, String bName, int adminCheck, int tenantID) throws Exception {
		String folder = "", strFile = "";
		
//		if (board.getId().trim().equals(userInfo.getId()) || adminCheck == 1 || userInfo.getRollInfo().indexOf("t=1") > -1 || userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
		if (board.getId().trim().equals(userInfo.getId()) || adminCheck == 1 || userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
			String fileName = board.getFileName();
			
			if (fileName != null) {
				folder = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_community.FILEDATA", userInfo.getTenantId()) + commonUtil.separator + getFileFolderName(bName) + commonUtil.separator;
				strFile = folder + fileName;
				File file = new File(strFile);
				
				if (file.exists()) {
					file.delete();
				}
			}
			
			if (bName.equals("tbl_c_clubpds") || bName.equals("tbl_c_clubpds1")) {
				String attachList = "";
				if (board.getCharFileName() != null) {
					attachList = board.getCharFileName();
					String[] strAttachFile = attachList.split(";");
					folder = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_community.FILEDATA", userInfo.getTenantId()) + commonUtil.separator + getFileFolderName(bName) + commonUtil.separator;
					
					for (int i = 0; i <= strAttachFile.length; i++) {
						strFile = folder + strAttachFile[i];
						File file = new File(strFile);
						
						if (file.exists()) {
							file.delete();
						}
					}
				}
			}
			
			bbsDelOkDel(bName, itemNo, "", tenantID);
			
			return "OK";
		}else {
			return "ERROR";
		}		
	}

	@Override
	public String guestOne(LoginVO userInfo, String sRadio, String keyword, String code, int comNoPerPage, int curPage) throws Exception {
		logger.debug("guestOne started.");
		
		List<CommunityCClubGuestVO> list = guestOneGet2(sRadio, keyword, code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
        
        StringBuilder sb = new StringBuilder();
        int i = 0;
        sb.append("<DATA>");
        
        for (CommunityCClubGuestVO item : list) {
        	i++;
        	
        	if (i > comNoPerPage * curPage) {
        		break;
        	}
        	
        	if (i > comNoPerPage * curPage -5) {
        		logger.debug("item.getWriteDay() : " + item.getWriteDay());
        		
	        	sb.append("<ROW>");
	        	sb.append("<NO>" + item.getNo() + "</NO>");
	        	sb.append("<ID>" + commonUtil.cleanValue(item.getId().trim()) + "</ID>");
	        	sb.append("<USERNAME>" + commonUtil.cleanValue(item.getUserName()) + "</USERNAME>");
	        	sb.append("<USERNAME2>" + commonUtil.cleanValue(item.getUserName2()) + "</USERNAME2>");
	        	sb.append("<COMPANYID>" + commonUtil.cleanValue(item.getCompanyID()) + "</COMPANYID>");
	        	sb.append("<TITLE>" + commonUtil.cleanValue(item.getTitle()) + "</TITLE>");
	        	sb.append("<CONTENT>" + commonUtil.cleanValue(item.getContent().trim()) + "</CONTENT>");
	        	sb.append("<CONTENTURL>" + commonUtil.cleanValue(item.getContentURL()) + "</CONTENTURL>");
	        	sb.append("<READNUM>" + item.getReadNum() + "</READNUM>");
	        	sb.append("<WRITEDAY>" + commonUtil.getDateStringInUTC(item.getWriteDay(), userInfo.getOffset(), false).substring(0, item.getWriteDay().lastIndexOf(".")) + "</WRITEDAY>");
	        	
	        	if (EgovDateUtil.getDaysDiff(commonUtil.getTodayUTCTime("").substring(0, 10), item.getWriteDay().substring(0, 10)) >= 0 ) {
	        		sb.append("<NEW>" + "NEW" + "</NEW>");
	        	}
	        	
	        	sb.append("<C_NO>" + item.getC_No() + "</C_NO>");
	        	sb.append("<C_CLUBNO>" + item.getC_clubNo() + "</C_CLUBNO>");
	        	sb.append("</ROW>");
        	}
        }
        
        sb.append("</DATA>");
        
        logger.debug("guestOne ended");
        
		return sb.toString();
	}

	@Override
	public boolean guestEditOk(LoginVO userInfo, CommunityCClubGuestVO item, String code, String mode, String memo, String[] cNo, boolean bIsMyContent) throws Exception {
		switch (mode) {
			case "write" :
				guestEditOkInsert(code, userInfo, memo.replaceAll("\r\n", "<br>").replaceAll("/'", "&quot;").replaceAll("\"", "&dquot;"), userInfo.getTenantId());
				
				break;
			case "delete" :
				for (String no : cNo){
					item = guestEditGet(code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), no, userInfo.getId(), userInfo.getTenantId());
					
					if (item != null) {
						bIsMyContent = true;
						guestEditOkDelete(no, code, userInfo.getTenantId());
					}
				}
				
				break;
			case "edit" :
				for (String no : cNo){
					item = guestEditGet(code, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), no, userInfo.getId(), userInfo.getTenantId());
					
					if (item != null) {
						bIsMyContent = true;
						guestEditOkUpdate(no, code, memo.replaceAll("\r\n", "<br>").replaceAll("/'", "&quot;").replaceAll("\"", "&dquot;"), userInfo.getId(), userInfo.getTenantId());
					}
				}
				
				break;
		}
		
		return bIsMyContent;
	}

	@Override
	public List<CommunityBoardItemReadVO> getReaderList(String pBoardID, String pItemID, int tenantID, String offset) throws Exception {
		logger.debug("getReaderList started.");
		logger.debug("pBoardID : " + pBoardID + ", pItemID : " + pItemID + ", tenantID : " + tenantID);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", pBoardID);
		map.put("v_pItemID", pItemID);
		map.put("tenantID", tenantID);
		map.put("offset", offset);
		
		List<CommunityBoardItemReadVO> list = ezCommunityDAO.getReaderList(map);
		
		logger.debug("getReaderList started.");
		
		return list;
	}

	@Override
	public String getACL(String id, String pComID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_USERID", id);
		map.put("v_PCOMID", pComID);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.getACL(map);
		
		if (result != null) {
			return "true";
		} else {
			return "false";
		}
	}

	@Override
	public String copyItem(String pOrgItemID, String pOrgBoardID, String pDestItemID, String pDestBoardID, String realPath, LoginVO userInfo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pOrgItemID", pOrgItemID);
		map.put("v_pOrgBoardID", pOrgBoardID);
		map.put("tenantID", userInfo.getTenantId());
		
		logger.debug("copyItemGet1 started.");
		
		CommunityBoardItemVO item = ezCommunityDAO.copyItemGet1(map);
		
		logger.debug("copyItemGet1 ended.");
		
		item.setItemID(pDestItemID);
		item.setBoardID(pDestBoardID);
		item.setContentLocation(item.getContentLocation().replace(pOrgBoardID.substring(1, pOrgBoardID.length()-1), pDestBoardID.substring(1, pDestBoardID.length()-1)));
		item.setContentLocation(item.getContentLocation().replace(pOrgItemID.substring(1, pOrgBoardID.length()-1), pDestItemID.substring(1, pDestBoardID.length()-1)));
		item.setStartDate("");
		item.setUpperItemIDTree(pDestItemID);
		item.setItemLevel(1);
		item.setParentWriteDate("");
		
		String pUploadFilePath = realPath + commonUtil.getUploadPath("upload_community.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		copyFiles(pOrgItemID, pOrgBoardID, pDestItemID, pDestBoardID, pUploadFilePath);
		
		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.put("v_pOrgItemID", pOrgItemID);
		map2.put("tenantID", userInfo.getTenantId());
		
		logger.debug("copyItemGet2 started.");
		
		List<CommunityBoardItemAttachmentVO> orgAttachList = ezCommunityDAO.copyItemGet2(map2);
		
		logger.debug("copyItemGet2 ended.");
		
		StringBuilder attachments = new StringBuilder();
		
		for(CommunityBoardItemAttachmentVO itemAttachment : orgAttachList) {
			String orgAttach = itemAttachment.getFilePath();
			String destAttach = itemAttachment.getFilePath().replace(pOrgBoardID.substring(1, pOrgBoardID.length()-1), pDestBoardID.substring(1, pDestBoardID.length()-1));
			
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
        sb.append("<FILEPATH>" + commonUtil.getUploadPath("upload_community.ROOT", userInfo.getTenantId()) + commonUtil.separator + "</FILEPATH>");
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

        String ret = newItem(commonUtil.convertStringToDocument(sb.toString()), "copy", realPath, userInfo);
        
        if(ret.equals("OK")) {
        	map = new HashMap<String, Object>();
        	map.put("v_pItemID", pDestItemID);
        	map.put("tenantID", userInfo.getTenantId());
        	
        	logger.debug("copyUpdate started.");
        	
        	ezCommunityDAO.copyUpdate(map);
        	
        	logger.debug("copyUpdate ended.");
        }
        
		return ret;
	}

	@Override
	public int guestOneGet1(String sRadio, String keyword, String code, String lang, int tenantID) throws Exception {
		logger.debug("guestOneGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_KEYWORD", keyword);
		map.put("v_CODE", code);
		map.put("v_S_RADIO", sRadio);
		map.put("v_USERINFO_LANG", lang);
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.guestOneGet1(map);
		
		logger.debug("guestOntGet1 ended. result=" + result);
		
		return result;
	}

	@Override
	public CommunityCClubGuestVO guestEditGet(String code, String lang, String no, String id, int tenantID) throws Exception {
		logger.debug("guestEditGet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_code", code);
		map.put("v_userInfo_lang", lang);
		map.put("v_no", no);
		map.put("v_userInfo_userID", id);
		map.put("tenantID", tenantID);
		
		CommunityCClubGuestVO vo = ezCommunityDAO.guestEditGet(map);
		
		logger.debug("guestEditGet ended.");
		
		return vo;
	}

	@Override
	public String pollMainGet1(String id, String code, int tenantID) throws Exception {
		logger.debug("pollMainGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_USERID", id);
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		logger.debug("pollMainGet1 ended.");
		
		String result = ezCommunityDAO.pollMainGet1(map);
		
		return result;
	}
	
	@Override
	public int pollResGet1(String id, String code, int tenantID) throws Exception {
		logger.debug("pollResGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_USERID", id);
		map.put("v_CODE",  code);
		map.put("tenantiD",  tenantID);
		
		int result = ezCommunityDAO.pollResGet1(map);
		
		logger.debug("pollResGet1 ended.");
		
		return result;
	}

	@Override
	public CommunityCPollManagerVO pollEditGet1(String managerID, int tenantID) throws Exception {
		logger.debug("pollEditGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MANAGERID", managerID);
		map.put("tenantID", tenantID);
		
		CommunityCPollManagerVO vo = ezCommunityDAO.pollEditGet1(map);
		
		logger.debug("pollEditGet1 ended.");
		
		return vo;
	}

	@Override
	public CommunityCPollQuestionVO pollEditGet2(String managerID, int tenantID) throws Exception {
		logger.debug("pollEditGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MANAGERID", managerID);
		map.put("tenantID", tenantID);
		
		CommunityCPollQuestionVO vo = ezCommunityDAO.pollEditGet2(map);
		
		logger.debug("pollEditGet2 ended.");
		
		return vo;
	}
	
	@Override
	public int pollETCViewGet(String questionID, int tenantID) throws Exception {
		logger.debug("pollETCViewGet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_QUESTIONID", questionID);
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.pollETCViewGet(map);
		
		logger.debug("pollETCViewGet ended.");
		
		return result;
	}

	@Override
	public List<CommunityCPollResponseVO> pollETCTableGet(String questionID, int tenantID) throws Exception {
		logger.debug("pollETCTableGet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_QUESTIONID", questionID);
		map.put("tenantID", tenantID);
		
		List<CommunityCPollResponseVO> list = ezCommunityDAO.pollETCTableGet(map);
		
		logger.debug("pollETCTableGet ended. listSize="+list.size());
		
		return list;
	}

	@Override
	public int commViewMemberGet2(String code, String lang, String keyword, String sRadio, int tenantID) throws Exception {
		logger.debug("commViewMemberGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_USERINFO_LANG", lang);
		map.put("v_KEYWORD", keyword);
		map.put("v_S_RADIO", sRadio.toUpperCase());
		map.put("tenantID", tenantID);
		
		logger.debug("commViewMemberGet2");
		logger.debug("v_CODE="+map.get("v_CODE"));
		logger.debug("v_USERINFO_LANG="+map.get("v_USERINFO_LANG"));
		logger.debug("v_KEYWORD="+map.get("v_KEYWORD"));
		logger.debug("v_S_RADIO="+map.get("v_S_RADIO"));
		
		int result = ezCommunityDAO.commViewMemberGet2(map);
		
		logger.debug("commViewMemberGet2 ended. result="+result);
		
		return result;
	}

	@Override
	public String adminMemberListGet2(String code, int tenantID) throws Exception {
		logger.debug("adminMemberListGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.adminMemberListGet2(map);
		
		logger.debug("adminMemberListGet2 ended.");
		
		return result;
	}
	
	@Override
	public CommunityMemberInfoVO commOutGet(String cSysopID, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("commOutGet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_C_SYSOPID", cSysopID);
		map.put("v_COMPANYID", companyID);
		map.put("v_USERINFO_LANG", lang);
		map.put("tenantID", tenantID);
		
		CommunityMemberInfoVO vo = ezCommunityDAO.commOutGet(map);
		
		logger.debug("commOutGet started.");
		
		return vo;
	}

	@Override
	public String categoryPrint(String c_Cate_A, String c_Cate_B, String c_Cate_C, LoginVO userInfo) throws Exception {
		logger.debug("categoryPrint started.");
		
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
			map.put("tenantID", userInfo.getTenantId());
			
			cateA = ezCommunityDAO.ezCommunityBaseGet3(map);
		}
		
		if (!c_Cate_B.equals("0")) {
			map = new HashMap<String, Object>();
			map.put("v_C_CODE", c_Cate_B);
			map.put("v_C_CAT", "b");
			map.put("tenantID", userInfo.getTenantId());
			
			cateB = ezCommunityDAO.ezCommunityBaseGet3(map);
		}
		
		if (!c_Cate_C.equals("0")) {
			map = new HashMap<String, Object>();
			map.put("v_C_CODE", c_Cate_C);
			map.put("v_C_CAT", "c");
			map.put("tenantID", userInfo.getTenantId());
			
			cateC = ezCommunityDAO.ezCommunityBaseGet3(map);
		}
		
		if (!cateA.equals("0")) {
			sb.append(egovMessageSource.getMessage("ezCommunity."+cateA, userInfo.getLocale()));
			caca = 1;
		}
		
		if (!cateB.equals("0")) {
			if (caca == 1) {
				sb.append(", ");
			}
			
			sb.append(egovMessageSource.getMessage("ezCommunity."+cateB, userInfo.getLocale()));
			caca = 1;
		}
		
		if (!cateC.equals("0")) {
			if (caca == 1) {
				sb.append(",&nbsp");
			}
			
			sb.append(egovMessageSource.getMessage("ezCommunity."+cateC, userInfo.getLocale()));
		}
		
		logger.debug("categoryPrint ended.");
		
		return sb.toString();
	}

	@Override
	public String commOutOk(String loginCookie, String code, String reason) throws Exception {
		logger.debug("commOutOk started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String strReturn = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_USERINFO_USERID", userInfo.getId());
		map.put("tenantID", userInfo.getTenantId());
		
		logger.debug("code="+ code);
		
		if (ezCommunityDAO.commOutOkGet1(map) != 0) {
			strReturn = "<RETURN><VALUE>0</VALUE></RETURN>";
		} else {
			map = new HashMap<String, Object>();
			map.put("v_CODE", code);
			map.put("v_USERINFO_USERID", userInfo.getId());
			map.put("v_DATETIME_NOW", commonUtil.getTodayUTCTime(""));
			map.put("v_REASON", reason);
			map.put("tenantID", userInfo.getTenantId());
			
			ezCommunityDAO.commOutOkInsert(map);
			
			strReturn = "<RETURN><VALUE>1</VALUE></RETURN>";
			commOutOkSendMail(loginCookie, userInfo, code, reason);
		}

		logger.debug("commOutOk ended. strReturn=" + strReturn);
		
		return strReturn;
	}

	@Override
	public CommunityClubVO adminLeftGet(String code, int tenantID) throws Exception {
		logger.debug("adminLeftGet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		CommunityClubVO vo = ezCommunityDAO.adminLeftGet(map);
		
		logger.debug("adminLeftGet ended.");
		
		return vo;
	}

	@Override
	public int noticeSysopCheck(String code, String id, String rollInfo, String companyID, int tenantID) throws Exception {
		int sysopCheck = 0;
		String strSysopID = "", strIsIN = "", strCompanyID = "";
		
		if (!code.equals("")) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_code", code);
			map.put("tenantID", tenantID);
			
			CommunityClubVO club = ezCommunityDAO.ezCommunityBaseGet1(map);
			
			if (club != null) {
				strSysopID = club.getC_SysopID().trim();
                strIsIN = Integer.toString(club.getIsIn());
                strCompanyID = club.getCompanyID().trim();
			}
		}
		
		if (!strSysopID.equals(id)){
			if (rollInfo.indexOf("c=1") < 0 ) {
				if (strIsIN.equals("1") && strCompanyID.equals(companyID)) {
					sysopCheck = 1;
				} 
			} else {
				sysopCheck = 1;
			}
		} else {
			sysopCheck = 1;
		}
		
		logger.debug("sysopCheck = " + sysopCheck);
		return sysopCheck;
	}

	@Override
	public CommunityMemberInfoVO aspCommInfoGet2(String lang, String sysopID, int tenantID) throws Exception {
		logger.debug("aspCommInfoGet2 started.");
		logger.debug("lang : " + lang + ", sysopID : " + sysopID + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_LANG", lang);
		map.put("v_RECORD_C_SYSOPID", sysopID);
		map.put("tenantID", tenantID);
		
		CommunityMemberInfoVO vo = ezCommunityDAO.aspCommInfoGet2(map);
		
		logger.debug("aspCommInfoGet2 ended");
		
		return vo;
	}

	@Override
	public int adminMemPermitGet1(String code, int tenantID) throws Exception {
		logger.debug("adminMemPermitGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.adminMemPermitGet1(map);
		
		logger.debug("adminMemPermitGet1 ended.");
		
		return result;
	}

	@Override
	public String adminBasicGet1(String code, int tenantID) throws Exception {
		logger.debug("adminBasicGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.adminBasicGet1(map);
		
		logger.debug("adminBasicGet1 ended.");
		
		return result;
	}
	
	@Override
	public String adminBasicGet2(String code, int tenantID) throws Exception {
		logger.debug("adminBasicGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.adminBasicGet2(map);
		
		logger.debug("adminBasicGet2 ended.");
		
		return result;
	}

	@Override
	public void adminBasicOkUpdate(CommunityClubVO clubVO, String code, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_C_CLUBNAME", clubVO.getC_ClubName());
		map.put("v_C_CLUBNAME2", clubVO.getC_ClubName2());
		map.put("v_C_CLUBGUBUN", clubVO.getC_ClubGubun());
		map.put("v_C_CLUBTYPE", clubVO.getC_ClubConfirmType());
		map.put("v_ISIN", clubVO.getIsIn());
		map.put("v_C_CLUBDESC", clubVO.getC_ClubDesc());
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.adminBasicOkupdate(map);
	}

	@Override
	public CommunityClubVO  adminLogoGet(String code, String lang, int tenantID) throws Exception {
		logger.debug("adminLogoGet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_USERINFO_LANG", lang);
		map.put("tenantID", tenantID);
		
		CommunityClubVO vo = ezCommunityDAO.adminLogoGet(map);
		
		logger.debug("adminLogoGet ended.");
		
		return vo;
	}

	@Override
	public void adminHomeBoardSet(String clear, String position, int sn, String cn, String boardID, int tenantID) throws Exception {
		logger.debug("adminHomeBoardSet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CLEAR", clear);
		map.put("v_POSITION", position);
		map.put("v_SN", sn);
		map.put("v_CN", cn);
		map.put("v_BOARDID", boardID);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.adminHomeBoardSet(map);
		
		logger.debug("adminHomeBoardSet ended.");
	}

	@Override
	public int boardPropertyGet(String boardID, int tenantID) throws Exception {
		logger.debug("boardPropertyGet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BOARDID", boardID);
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.boardPropertyGet(map);
		
		logger.debug("boardPropertyGet ended. result : " + result);
		
		return result;
	}

	@Override
	public void createBoardGroup(String code, String boardGroupID, String boardGroupName, String boardGroupName2, LoginVO userInfo) throws Exception {
		logger.debug("createBoardGroup started.");
		
		int boardNo = ezCommunityDAO.createBoardGroupSelect(userInfo.getTenantId());
		int tenantID = userInfo.getTenantId();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_BOARDGROUPID", boardGroupID);
		map.put("v_BOARDGROUPNAME", boardGroupName);
		map.put("v_BOARDGROUPNAME2", boardGroupName2);
		map.put("v_USERINFO_USERID", userInfo.getId());
		map.put("v_ACCESSNAME", userInfo.getDisplayName1() + "(" + userInfo.getCompanyName1() + ", " + userInfo.getDeptName1() + ")");
		map.put("v_BOARDNO", boardNo);
		map.put("tenantID", tenantID);
		
		logger.debug("createBoardGroupInsert1 started.");
		ezCommunityDAO.createBoardGroupInsert1(map);
		logger.debug("createBoardGroupInsert1 ended.");		
		logger.debug("createBoardGroupInsert2 started.");
		ezCommunityDAO.createBoardGroupInsert2(map);
		logger.debug("createBoardGroupInsert2 ended.");
		logger.debug("createBoardGroupInsert3 started.");
		ezCommunityDAO.createBoardGroupInsert3(map);
		logger.debug("createBoardGroupInsert3 ended.");
		logger.debug("truncateCommTreeCache started.");
		ezCommunityDAO.truncateCommTreeCache(tenantID);
		logger.debug("truncateCommTreeCache ended.");
		
		logger.debug("createBoardGroup ended.");
	}

	@Override
	public String saveBoardOrder(String xmlData, int tenantID) throws Exception {
		logger.debug("saveBoardOrder started.");
		
		Document xmlDoc = commonUtil.convertStringToDocument(xmlData);
		String pBoardIDList = xmlDoc.getElementsByTagName("BOARDIDLIST").item(0).getTextContent().trim();
		String[] boardIDList = pBoardIDList.split(";");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantID", tenantID);
		
		try {
			for (int i = 0; i < boardIDList.length; i ++) {
				map.put("v_pBoardID", boardIDList[i]);
				map.put("v_count", i+1);
				
				ezCommunityDAO.saveBoardOrder(map);
			}
			
			logger.debug("saveBoardOrder ended.");
			
			return "OK";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.error(e.getMessage());
			
			return "ERROR";
		}
		
	}

	@Override
	public void deleteBoard(int tenantID) throws Exception {
		ezCommunityDAO.deleteBoard(tenantID);
	}

	@Override
	public void createBoardInsert(String code, String boardID, String boardName, String boardName2, String parentBoardID, String boardGroupID, String comatt, LoginVO userInfo) throws Exception {
		logger.debug("createBoardInsert started.");
		
		int boardNo = ezCommunityDAO.createBoardInsertSelect(userInfo.getTenantId());
		
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
		map.put("v_BOARDNO", boardNo);
		map.put("tenantID", userInfo.getTenantId());
		
		logger.debug("code="+code);
		logger.debug("boardID"+boardID);
		logger.debug("boardName="+boardName);
		logger.debug("boardName2="+boardName2);
		logger.debug("parentBoardID="+parentBoardID);
		logger.debug("boardGroupID"+boardGroupID);
		logger.debug("comatt="+comatt);
		logger.debug("v_USERINFO_USERID="+userInfo.getId());
		logger.debug("v_USERINFO_DISPLAYNAME="+userInfo.getDisplayName1());
		logger.debug("v_USERINFO_COMPANYNAME="+userInfo.getCompanyName1());
		logger.debug("v_USERINFO_DEPTNAME="+userInfo.getDeptName1());
		logger.debug("v_BOARDNO="+boardNo);
		
		ezCommunityDAO.createBoardInsertInsert1(map);
		ezCommunityDAO.createBoardInsertInsert2(map);
		ezCommunityDAO.createBoardInsertInsert3(map);
		ezCommunityDAO.createBoardInsertDelete(userInfo.getTenantId());
		
		logger.debug("createBoardInsert ended.");
	}
	
	@Override
	public String moveBoard(String orgBoardID, String newParentBoardID, String newBoardGroupID, int tenantID) throws Exception {
		logger.debug("moveBoard started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pOrgBoardID", orgBoardID);
		map.put("v_pNewParentBoardID", newParentBoardID);
		map.put("v_pNewBoardGroupID", newBoardGroupID);
		map.put("tenantID", tenantID);
		
		try{
			ezCommunityDAO.moveBoardUpdate1(map);
			ezCommunityDAO.moveBoardUpdate2(map);
			deleteBoard(tenantID);
			
			logger.debug("moveBoard ended.");
			
			return "OK";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.debug("moveBoard ERROR.");
			
			return "ERROR" + e.getMessage();
		}
	}
	
	@Override
	public String brdDeleteBoard(String boardID, int tenantID) throws Exception {		
		logger.debug("brdDeleteBoard started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardID);
		map.put("tenantID", tenantID);
		
		try{	
			ezCommunityDAO.brdDeleteBoardDelete1(map);
			ezCommunityDAO.brdDeleteBoardDelete2(map);
			ezCommunityDAO.brdDeleteBoardDelete3(map);
			ezCommunityDAO.brdDeleteBoardInsert(map);
			deleteBoard(tenantID);
			
			logger.debug("brdDeleteBoard ended.");
			
			return "OK";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.debug("brdDeleteBoard ERROR.");
			logger.error(e.getMessage());
			
			return "ERROR" + e.getMessage();
		}
	}

	@Override
	public int adminSearchItemCount(LoginVO userInfo, String boardID, String title, String writerName, String abstracts, String startDateTime, String endDateTime) throws Exception {
		logger.debug("adminSearchItemCount started.");
		
		String offset = userInfo.getOffset();
		int tenantID = userInfo.getTenantId();
		
		if (boardID.equals("")) {
			boardID = "%%";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardID);
		map.put("v_pTitle", title);
		map.put("v_pWriterName", writerName);
		map.put("v_pAbstract", abstracts);
		map.put("v_pStartDate", commonUtil.getDateStringInUTC(startDateTime, offset, true));
		map.put("v_pEndDate", commonUtil.getDateStringInUTC(endDateTime, offset, true));
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.adminSearchItemCount(map);
		
		logger.debug("adminSearchItemCount ended.");
		
		return result;
	}

	@Override
	public String adminSearchItemXML(LoginVO userInfo, String boardID, String title, String writerName, String abstracts, String searchStart, String searchEnd, int pStartRow, int pEndRow) throws Exception {
		logger.debug("adminSearchItemXML ended.");
		
		StringBuilder sb = new StringBuilder();
		String id = userInfo.getId();
		String lang = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
		String offset = userInfo.getOffset();
		int tenantID = userInfo.getTenantId();
		int count = 0;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pEndRow", pEndRow);
		map.put("v_strLang", lang);
		map.put("v_pBoardID", boardID);
		map.put("v_pTitle", title);
		map.put("v_pWriterName", writerName);
		map.put("v_pAbstract", abstracts);
		map.put("v_pStartDate", commonUtil.getDateStringInUTC(searchStart, offset, true));
		map.put("v_pEndDate", commonUtil.getDateStringInUTC(searchEnd, offset, true));
		map.put("v_pUserID", id);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
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
					sb.append("<WriteDate>" + commonUtil.getDateStringInUTC(board.getWriteDate(), offset, false) + "</WriteDate>");
				} else {
					sb.append("<WriteDate>" + commonUtil.getDateStringInUTC(board.getParentWriteDate(), offset, false) + "</WriteDate>");
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
		
		logger.debug("adminSearchItemXML ended.");
		
		return sb.toString();
	}

	@Override
	public int adminOuterListGet1(String code, int tenantID) throws Exception {
		logger.debug("adminOuterListGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.adminOuterListGet1(map);
		
		logger.debug("adminOuterListGet1 ended.");
		
		return result;
	}

	@Override
	public void adminOuterOkNoSet(String flag, String userID, String code, int tenantID) throws Exception {
		logger.debug("adminOuterOkNoSet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		if (flag.equals("OK")) {
			ezCommunityDAO.adminOuterOkNoSetDelete1(map);
			ezCommunityDAO.adminOuterOkNoSetUpdate(map);
		}
		
		ezCommunityDAO.adminOuterOkNoSetDelete2(map);
		
		logger.debug("adminOuterOkNoSet started.");
	}

	@Override
	public int adminMemberListGet1(String code, int tenantID) throws Exception {
		logger.debug("adminMemberListGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.adminMemberListGet1(map);
		
		logger.debug("adminMemberListGet1 ended.");
		return result;
	}

	@Override
	public CommunityMemberInfoVO getMemberInfo(String companyID, String cID, int tenantID) throws Exception {
		logger.debug("getMemberInfo started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyID);
		map.put("v_C_ID", cID);
		map.put("tenantID", tenantID);
		
		CommunityMemberInfoVO vo = ezCommunityDAO.getMemberInfo(map);
		
		logger.debug("getMemberInfo ended.");
		
		return vo;
	}

	@Override
	public CommunityCClubUserVO adminMemberListOkGet(String code, String cID, String companyID, int tenantID) throws Exception {
		logger.debug("adminMemberListOkGet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_C_ID", cID);
		map.put("v_COMPANYID", companyID);
		map.put("tenantID", tenantID);
		
		CommunityCClubUserVO vo = ezCommunityDAO.adminMemberListOkGet(map);
		
		logger.debug("adminMemberListOkGet ended.");
		
		return vo;
	}

	@Override
	public int adminMemberListOkGetE(String code, String cID, int tenantID) throws Exception {
		logger.debug("adminMemberListOkGetE started.");
		
		Map<String , Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_C_ID", cID);
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.adminMemberListOkGetE(map);
		
		logger.debug("adminMemberListOkGetE ended.");
		
		return result;
	}

	@Override
	public void adminMemberListOkGoSe(String mode, String code, String cID, String cNm, int tenantID) throws Exception {
		logger.debug("adminMemberListOkGoSe started.");
		logger.debug("code=" + code + ", id=" + cID + ", Nm=" + cNm);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_C_ID", cID);
		map.put("v_C_NM", cNm);
		map.put("tenantID", tenantID);
		
		if (mode.equals("MASTER")) {
			List<String> list = ezCommunityDAO.adminMemberListGoSESelect(map);
			
			ezCommunityDAO.adminMemberListGoSEUpdate1(map);
			
			for (String rowID : list) {
				map.put("v_rowID", rowID);
				
				ezCommunityDAO.adminMemberListGoSEUpdate2(map);
			}
		} else {
			ezCommunityDAO.adminMemberListGoSEDelete1(map);
			ezCommunityDAO.adminMemberListGoSEUpdate3(map);
			ezCommunityDAO.adminMemberListGoSEDelete2(map);			
		}
		
		logger.debug("adminMemberListOkGoSe ended.");
	}

	@Override
	public String saveBoardProperty(LoginVO userInfo, String xmlData) throws Exception {
		logger.debug("saveBoardProperty started.");
		
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
		map.put("tenantID", userInfo.getTenantId());
		
		try {
			ezCommunityDAO.brdSaveBoardPropertyUpdate1(map);
			ezCommunityDAO.brdSaveBoardPropertyUpdate2(map);
			deleteBoard(userInfo.getTenantId());
			
			logger.debug("saveBoardProperty ended.");
			
			return "OK";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.debug("saveBoardProperty ERROR.");
			
			return "ERROR" + e.getMessage();
		}
	}

	@Override
	public CommunityCComCloseVO adminCommCloseOkGet1(String code, int tenantID) throws Exception {
		logger.debug("adminCommCloseOkGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		CommunityCComCloseVO vo = ezCommunityDAO.adminCommCloseOkGet1(map);
		
		logger.debug("adminCommCloseOkGet1 ended.");
		
		return vo;
	}

	@Override
	public CommunityClubVO adminCommCloseOkGet2(String code, int tenantID) throws Exception {
		logger.debug("adminCommCloseOkGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		CommunityClubVO vo = ezCommunityDAO.adminCommCloseOkGet2(map);
		
		logger.debug("adminCommCloseOkGet2 ended.");
		
		return vo;
	}

	@Override
	public void adminCommCloseOkInsert(String code, String commName, String commName2, String sysopID, String companyName, String todayTime, String reason, String closeState, int tenantID) throws Exception {
		logger.debug("adminCommCloseOkInsert started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_COMMNAME", commName);
		map.put("v_COMMNAME2", commName2);
		map.put("v_SYSOPID", sysopID);
		map.put("v_COMPANYNAME", companyName);
		map.put("v_DATETIME_NOW", todayTime);
		map.put("v_REASON", reason);
		map.put("v_CLOSESTATE", closeState);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.adminCommCloseOkInsert(map);
		
		logger.debug("adminCommCloseOkInsert ended.");
	}

	@Override
	public String join1Get(String no, String lang, int tenantID) throws Exception {
		logger.debug("join1Get started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_NO", no);
		map.put("v_USERINFO_LANG", lang);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.join1Get(map);
		
		logger.debug("join1Get ended.");
		
		return result;
	}

	@Override
	public String joinGet1(String code, String lang, int tenantID) throws Exception {
		logger.debug("joinGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_USERINFO_LANG", lang);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.joinGet1(map);
		
		logger.debug("joinGet1 ended.");
		
		return result;
	}

	@Override
	public CommunityClubVO adminNoticeMailOkGet1(String code, int tenantID) throws Exception {
		logger.debug("adminNoticeMailOkGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		CommunityClubVO vo = ezCommunityDAO.adminNoticeMailOkGet1(map);
		
		logger.debug("adminNoticeMailOkGet1 ended.");
		
		return vo;
	}
	
	public List<CommunityClubVO> adminNoticeMailOkGet2(String code, int tenantID) throws Exception {
		logger.debug("adminNoticeMailOkGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		List<CommunityClubVO> list = ezCommunityDAO.adminNoticeMailOkGet2(map);
		
		logger.debug("adminNoticeMailOkGet2 ended.");
		
		return list;
	}

	@Override
	public String joinGet2(String sysopID, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("joinGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SYSOPID", sysopID);
		map.put("v_COMPANYID", companyID);
		map.put("v_USERINFO_LANG", lang);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.joinGet2(map);
		
		logger.debug("joinGet2 ended.");
		
		return result;
	}

	@Override
	public String joinOkGet1(String code, String id, int tenantID) throws Exception {
		logger.debug("joinOkGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_USERINFO_USERID", id);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.joinOkGet1(map);
		
		logger.debug("joinOkGet1 ended.");
		
		return result;
	}

	@Override
	public void joinOkSet1(String code, String id, String todayTime, String companyID, int tenantID) throws Exception {
		logger.debug("joinOkSet1 started.");
		
		Map<String, Object> map =new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.joinOkSet1Update(map);
		
		map.put("v_USERINFO_USERID", id);
		map.put("v_pNow", todayTime);
		map.put("v_USERINFO_COMPANYID", companyID);
		
		ezCommunityDAO.joinOkSet1Insert(map);
		
		logger.debug("joinOkSet1 ended.");
	}

	@Override
	public String joinOkGet2(String code, String id, int tenantID) throws Exception {
		logger.debug("joinOkGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_USERINFO_USERID", id);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.joinOkGet2(map);
		
		logger.debug("joinOkGet2 ended.");
		
		return result;
	}

	@Override
	public CommunityClubVO joinOkGet3(String code, String lang, int tenantID) throws Exception {
		logger.debug("joinOkGet3 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_USERINFO_LANG", lang);
		map.put("tenantID", tenantID);
		
		CommunityClubVO vo = ezCommunityDAO.joinOkGet3(map);
		
		logger.debug("joinOkGet3 ended.");
		
		return vo;
	}

	@Override
	public void joinOkUpdate1(String id, String code, String cIntro, String openEmail, String openHp, String openComp, String openBirth, String openSex, String openHouse, int tenantID) throws Exception {
		logger.debug("joinOkUpdate1 started.");
		
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
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.joinOkUpdate1(map);
		
		logger.debug("joinOkUpdate1 ended.");
	}

	@Override
	public CommunityMemberInfoVO joinOkGet4(String companyID, String id, int tenantID) throws Exception {
		logger.debug("joinOkGet4 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_COMPANYID", companyID);
		map.put("v_USERINFO_USERID", id);
		map.put("tenantID", tenantID);
		
		CommunityMemberInfoVO vo = ezCommunityDAO.joinOkGet4(map);
		
		logger.debug("joinOkGet4 ended.");
		
		return vo;
	}

	@Override
	public void joinOkUpdate3(String companyID, String id, String birthDay, int tenantID) throws Exception {
		logger.debug("joinOkUpdate3 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_COMPANYID", companyID);
		map.put("v_USERINFO_USERID", id);
		map.put("v_BIRTHDAY", birthDay);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.joinOkUpdate3(map);
		
		logger.debug("joinOkUpdate3 ended.");
	}

	@Override
	public void joinOkUpdate2(String id, String code, String cIntro, String openEmail, String openHp, String openComp, String openHouse, String openJob, String openBirth, String openSex, int tenantID) throws Exception {
		logger.debug("joinOkUpdate2 started.");
		
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
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.joinOkUpdate2(map);
		
		logger.debug("joinOkUpdate2 ended.");
	}

	@Override
	public String getACLGet1(String cID, int tenantID) throws Exception {
		logger.debug("getACLGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CID", cID);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.getACLGet1(map);
		
		logger.debug("getACLGet1 ended.");
		
		return result;
	}

	@Override
	public String getACLGet2(String uID, String cID, int tenantID) throws Exception {
		logger.debug("getACLGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_UID", uID);
		map.put("v_CID", cID);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.getACLGet2(map);
		
		logger.debug("getACLGet2 ended.");
		
		return result;
	}
	
	@Override
	public String adminMemPermit(LoginVO userInfo, String code) throws Exception {
		logger.debug("adminMemPermit started.");
		
		int iCount = 1, curPage = 0;
		StringBuilder sb = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_USERINFO_LANG", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		map.put("tenantID", userInfo.getTenantId());
		
		List<CommunityCClubUserVO> userList = ezCommunityDAO.adminMemPermitGet2(map);

		for (CommunityCClubUserVO user : userList) {
			sb.append("<tr>");
            sb.append("<td height=\"23\" align=\"center\" class=\"white\">" + iCount + "</td>");
            sb.append("<td class=\"white\">");
            
            if (userInfo.getLang().equals("2")) {
            	sb.append("<a href=\"javascript:openinfo( '" + code + "', '" + user.getC_ID().trim() + "', '" + user.getCompanyID().trim() + "' )\">" + user.getUserName2().trim() + "</a>");
            }else {
            	sb.append("<a href=\"javascript:openinfo( '" + code + "', '" + user.getC_ID().trim() + "', '" + user.getCompanyID().trim() + "' )\">" + user.getUserName().trim() + "</a>");
            }
            
            sb.append("</td>");
            sb.append("<td class=\"white\" align=\"center\">" + user.getC_inDate().trim().substring(0, 10) + "</td>");
            sb.append("<td class=\"white\" align=\"center\">");
            
            if (userInfo.getLang().equals("2")) {
            	sb.append("<a href=\"javascript:okno('ok','" + user.getC_ID().trim() + "','" + code + "','" + curPage + "','" + user.getUserName2().trim() + "');\">" + egovMessageSource.getMessage("ezCommunity.t46", userInfo.getLocale()) + "</a>/");
                sb.append("<a href=\"javascript:okno('no','" + user.getC_ID().trim().trim() + "','" + code + "','" + curPage + "','" + user.getUserName2().trim() + "');\">" + egovMessageSource.getMessage("ezCommunity.t552", userInfo.getLocale()) + "</a>");
            } else {
            	sb.append("<a href=\"javascript:okno('ok','" + user.getC_ID().trim() + "','" + code + "','" + curPage + "','" + user.getUserName().trim() + "');\">" + egovMessageSource.getMessage("ezCommunity.t46", userInfo.getLocale()) + "</a>/");
                sb.append("<a href=\"javascript:okno('no','" + user.getC_ID().trim().trim() + "','" + code + "','" + curPage + "','" + user.getUserName().trim() + "');\">" + egovMessageSource.getMessage("ezCommunity.t552", userInfo.getLocale()) + "</a>");
            }
            
            sb.append("</td>");
            sb.append("</tr>");
            
            iCount ++;
		}
		
		logger.debug("adminMemPermit ended.");
		
		return sb.toString();
	}
	
	@Override
	public void okNoSet(String flag, String code, String cID, int tenantID) throws Exception {
		logger.debug("okNoSet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_C_ID", cID);
		map.put("tenantID", tenantID);
		
		if (flag.equals("OK")) {
			logger.debug("okNoSet flag=OK.");
			
			ezCommunityDAO.okNoSetUpdate1(map);
			
		} else if (flag.equals("NO")) {
			logger.debug("okNoSet flag=NO.");
			
			ezCommunityDAO.okNoSetDelete(map);
			ezCommunityDAO.okNoSetUpdate2(map);
		}
		
		logger.debug("okNoSet ended.");
	}

	@Override
	public int todayCopGet1(int tenantID) throws Exception {
		logger.debug("todayCopGet1 started.");
		
		int result = ezCommunityDAO.todayCopGet1(tenantID);
		
		logger.debug("todayCopGet1 ended.");
		
		return result;
	}

	@Override
	public CommunityClubVO todayCopGet2(int num, int tenantID) throws Exception {
		logger.debug("todayCopGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("num", num);
		map.put("mariaNum", num -1);
		map.put("tenantID", tenantID);
		
		String userID = ezCommunityDAO.todayCopGet2SelectUserID(map);
		int totalCount = ezCommunityDAO.todayCopGet2SelectTotalCount(map);
		
		map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		
		int temp = ezCommunityDAO.todayCopGet2SelectTemp(map);
		
		map = new HashMap<String, Object>();
		map.put("temp", temp);
		map.put("num", num);
		map.put("mariaNum", num -1);
		map.put("tenantID", tenantID);
		
		if (num > totalCount) {
			num = totalCount;
			map.put("num", num);
			map.put("mariaNum", num -1);
		}
		
		CommunityClubVO vo = ezCommunityDAO.todayCopGet2List(map);

		logger.debug("todayCopGet2 ended.");
		
		return vo; 
	}

	@Override
	public String todayCopGet3(String c_Cate, String type, int tenantID) throws Exception {
		logger.debug("todayCopGet3 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CATE", c_Cate);
		map.put("v_TYPE", type);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.todayCopGet3(map);
		
		logger.debug("todayCopGet3 ended.");
		
		return result;
	}

	@Override
	public int categoryListItemCntGet(String c_ClubNo, int tenantID) throws Exception {
		logger.debug("categoryListItemCntGet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("c_ClubNo", c_ClubNo.trim());
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.categoryListItemCntGet(map);
		
		logger.debug("categoryListItemCntGet ended.");
		
		return result;
	}

	@Override
	public List<CommunityCCategoryVO> mainPageGet4(String cat, int tenantID) throws Exception {
		logger.debug("mainPageGet4 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cat", cat);
		map.put("tenantID", tenantID);
		
		List<CommunityCCategoryVO> list = ezCommunityDAO.mainPageGet4(map);
		
		logger.debug("mainPageGet4 ended.");
		
		return list;
	}

	@Override
	public CommunityCCategoryVO mainPageCategory(String c_Code, String cat, int tenantID) throws Exception {
		logger.debug("mainPageCategory started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", c_Code);
		map.put("cat", cat);
		map.put("tenantID", tenantID);
		
		CommunityCCategoryVO vo = ezCommunityDAO.mainPageCategory(map);
		
		logger.debug("mainPageCategory ended.");
		
		return vo;
	}

	@Override
	public List<CommunityClubVO> categoryListGet(String type, String mode, int startRow, int endRow, int tenantID) throws Exception {
		logger.debug("categoryListGet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", type);
		map.put("cat", mode);
		map.put("v_pStart", startRow);
		map.put("mariaStart", startRow - 1);
		map.put("v_pEnd", endRow);
		map.put("mariaEnd", endRow - startRow);
		map.put("tenantID", tenantID);
		
		List<CommunityClubVO> list = ezCommunityDAO.categoryListGet(map); 
		
		logger.debug("categoryListGet ended.");
		
		return list;
	}

	@Override
	public List<CommunityClubVO> searchCop(String search, String keyword, int startRow, int endRow, String mode, int tenantID) throws Exception {
		logger.debug("searchCop started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_searchName", search);
		map.put("v_searchValue", keyword);
		map.put("v_pStart", startRow);
		map.put("mariaStart", startRow - 1);
		map.put("v_pEnd", endRow);
		map.put("mariaEnd", endRow - startRow);
		map.put("v_mode", mode);
		map.put("tenantID", tenantID);
		
		List<CommunityClubVO> list = ezCommunityDAO.searchCop(map);
		
		logger.debug("searchCop ended.");
		
		return list;
	}
	
	@Override
	public String getNewItemListXML(LoginVO userInfo, int pStartRow, int pEndRow, String pSortBy) throws Exception {
		logger.debug("getNewItemListXML started.");
		
		String id = userInfo.getId();
		String offset = userInfo.getOffset();
		int tenantID = userInfo.getTenantId();
		
		logger.debug("id : " + id + ", pStartRow : " + pStartRow + ", pEndRow : " + pEndRow + ", pSortBy : " + pSortBy + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUserID", id);
		map.put("v_pSortBy", pSortBy);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		if (pEndRow > 0){
			map.put("v_pEndRow", pEndRow);
		} else {
			map.put("v_pEndRow", 0);
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
				sb.append("<WriteDate>" + commonUtil.getDateStringInUTC(itemList.getWriteDate(), offset, false) + "</WriteDate>");
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
		
		logger.debug("getNewItemListXML ended.");
		
		return sb.toString();
	}
	
	@Override
	public int getNewItemListCount(String id, int tenantID) throws Exception {
		logger.debug("getNewItemListCount started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUserID", id);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("v_pFromNow", EgovDateUtil.addDay(commonUtil.getTodayUTCTime(""), -5, "yyyy-MM-dd HH:mm:ss"));
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.brdNewItemCount(map);
		
		logger.debug("getNewItemListCount ended.");
		
		return result;
	}

	@Override
	public CommunityClubVO boardItemListPhotoGet1(String id, String boardID, int tenantID) throws Exception {
		logger.debug("boardItemListPhotoGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_USERID", id);
		map.put("v_PBOARDID", boardID);
		map.put("tenantID", tenantID);
		
		CommunityClubVO vo = ezCommunityDAO.boardItemListPhotoGet1(map);
		
		logger.debug("boardItemListPhotoGet1 ended.");
		
		return vo;
	}

	@Override
	public int getBoardTotalItemCount(String pBoardID, int tenantID) throws Exception {
		logger.debug("getBoardTotalItemCount started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", pBoardID);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.getBoardTotalItemCount(map);
		
		logger.debug("result : " + result);
		logger.debug("getBoardTotalItemCount ended.");
		
		return result;
	}
	
	@Override
	public String getBoardListItemPhotoXML(LoginVO userInfo, String pBoardID, int pStartRow, int pEndRow, String pSortBy) throws Exception {
		StringBuilder sb = new StringBuilder();
		int count = 0;
		
		String id = userInfo.getId();
		String lang = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
		String offset = userInfo.getOffset();
		int tenantID = userInfo.getTenantId();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", id);
		map.put("v_PBOARDID", pBoardID);
		map.put("v_PSORTBY", pSortBy);
		map.put("v_USERINFO_LANG", lang);
		map.put("v_PENDROW", pEndRow);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		logger.debug("psortBY");
		logger.debug(pSortBy);
		List<CommunityBoardItemVO> itemList = ezCommunityDAO.boardItemListPhotoGet2(map);
		
		sb.append("<NODES>");
		
		for (CommunityBoardItemVO item : itemList) {
			count ++;
			
			if (count >= pStartRow) {
				sb.append("<NODE>");
				
				sb.append("<ItemID>" + item.getItemID().trim() + "</ItemID>");
	            sb.append("<WriterID>" + commonUtil.cleanValue(item.getWriterID()).trim() + "</WriterID>");
	            sb.append("<WriterName>" + commonUtil.cleanValue(item.getWriterName()).trim() + "</WriterName>");
	            sb.append("<WriterDeptName>" + commonUtil.cleanValue(item.getWriterDeptName()).trim() + "</WriterDeptName>");
	            sb.append("<WriterCompanyName>" + commonUtil.cleanValue(item.getWriterCompanyName()).trim() + "</WriterCompanyName>");
	
	            if (EgovDateUtil.getDaysDiff(item.getWriteDate().substring(0, 10), item.getParentWriteDate().substring(0, 10)) > 0) {
	            	sb.append("<WriteDate>" + commonUtil.getDateStringInUTC(item.getWriteDate(), offset, false).substring(0, 10) + "</WriteDate>");
	            } else {
	            	sb.append("<WriteDate>" + commonUtil.getDateStringInUTC(item.getParentWriteDate(), offset, false).substring(0, 10) + "</WriteDate>");
	            }
	            
	            sb.append("<Importance>" + item.getImportance() + "</Importance>");
	            sb.append("<Title>" + commonUtil.cleanValue(item.getTitle()).trim() + "</Title>");
	            if (item.getAttachments() == null)
	                sb.append("<Attachments></Attachments>");
	            else
	                sb.append("<Attachments>" + commonUtil.cleanValue(item.getAttachments()) + "</Attachments>");
	
	            sb.append("<ReadCount>" + item.getReadCount() + "</ReadCount>");
	            sb.append("<ItemLevel>" + item.getItemLevel() + "</ItemLevel>");
	            sb.append("<ReadFlag>" + item.getReadFlag() + "</ReadFlag>");
	            sb.append("<Abstract>" + commonUtil.cleanValue(item.getAbsTract()) + "</Abstract>");
	            // 수정(200700228) : 포토게시판 기능 추가 관련 ExtensionAttribute5(Small 이미지 경로) 값 가져오도록 수정함.
	            sb.append("<EXTENSIONATTRIBUTE5>" + commonUtil.cleanValue(item.getExtensionAttribute5()) + "</EXTENSIONATTRIBUTE5>");
				sb.append("</NODE>");
			}
		}
		
		sb.append("</NODES>");
		
		return sb.toString();
	}
	
	@Override
	public Map<String, String> getAdjacentItemsPhoto(String boardID, CommunityBoardItemVO pItem, int tenantID, String offset) throws Exception {
		logger.debug("getAdjacentItemsPhoto started.");
		
		String previousItemID = "", previousTitle = "", nextItemID = "", nextTitle = "";
		Map<String, Object> map;
		List<CommunityBoardItemVO> list;
		
		if (previousItemID.equals("")) {
			map = new HashMap<String, Object>();
			map.put("v_PBOARDID", boardID);
			map.put("v_PPARENTWRITEDATE", commonUtil.getDateStringInUTC(pItem.getParentWriteDate(), offset, true));
			map.put("v_pNow", commonUtil.getTodayUTCTime(""));
			map.put("tenantID", tenantID);
			
			list = ezCommunityDAO.getAdjacentItemsGet2Pho(map);

			for (CommunityBoardItemVO item : list) {
				if (item.getItemID().equals(pItem.getItemID()) && list.indexOf(item) > 0) {					
					previousItemID = list.get(list.indexOf(item) - 1).getItemID().trim();
					previousTitle = list.get(list.indexOf(item) - 1).getTitle().trim();
				}
			}
		}
		
		if (nextItemID.equals("")) {
			map = new HashMap<String, Object>();
			map.put("v_PBOARDID", boardID);
			map.put("v_PPARENTWRITEDATE", commonUtil.getDateStringInUTC(pItem.getParentWriteDate(), offset, true));
			map.put("v_pNow", commonUtil.getTodayUTCTime(""));
			map.put("tenantID", tenantID);
			
			list = ezCommunityDAO.getAdjacentItemsGet3Pho(map);

			for (CommunityBoardItemVO item : list) {
				if (item.getItemID().equals(pItem.getItemID()) && list.indexOf(item) < list.size() - 1) {
					nextItemID = list.get(list.indexOf(item) + 1).getItemID().trim();
					nextTitle = list.get(list.indexOf(item) + 1).getTitle().trim();
				}
			}
		}
		
		Map<String, String> ret = new HashMap<String, String>();
		ret.put("previousItemID", previousItemID);
		ret.put("previousTitle", previousTitle);
		ret.put("nextItemID", nextItemID);
		ret.put("nextTitle", nextTitle);
		
		logger.debug("getAdjacentItemsPhoto ended.");
		
		return ret;
	}

	@Override
	public String checkPassword(String pItemID, int tenantID) throws Exception {
		logger.debug("checkPassword started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", pItemID);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.checkPassword(map);
		
		logger.debug("checkPassword ended.");
		
		return result;
	}

	public List<CommunityCClubGuestVO> guestOneGet2(String sRadio, String keyword, String code, String lang, int tenantID) throws Exception {
		logger.debug("guestOneGet2 started.");
		logger.debug("sRadio : " + sRadio + ", keyword : " + keyword + ", code : " + code + ", lang : " + lang + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_s_radio", sRadio);
		map.put("v_keyword", keyword);
		map.put("v_code", code);
		map.put("v_userInfo_lang", lang);
		map.put("tenantID", tenantID);
		
		List<CommunityCClubGuestVO> list = ezCommunityDAO.guestOneGet2(map);
		
		logger.debug("guestOneGet2 ended. listsize :" + list.size());
		
		return list;
	}
	
	public void guestEditOkInsert(String code, LoginVO userInfo, String memo, int tenantID) throws Exception {
		logger.debug("guestEditOkInsert started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_USERINFO_USERID", userInfo.getId());
		map.put("v_USERINFO_DISPLAYNAME1", userInfo.getDisplayName1());
		map.put("v_USERINFO_DISPLAYNAME2", userInfo.getDisplayName2());
		map.put("v_USERINFO_COMPANYID", userInfo.getCompanyID());
		map.put("v_MEMO", memo);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.guestEditOkInsert(map);
		
		logger.debug("guestEditOkInsert ended.");
	}
	
	public void pollResOkSet(String questionID, String pollSelect, String answerETC, String id, String companyID, String isSave, String answerType, String answerCount, int tenantID) throws Exception {
		logger.debug("pollResOkSet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_QUESTIONID", questionID);
		map.put("v_POLLSELECT", pollSelect);
		map.put("tenantID", tenantID);
		
		logger.debug("pollResOkSetSelect started.");
		logger.debug("questionID : " + questionID);
		logger.debug("pollSelect : " + pollSelect);
		Integer answerID = ezCommunityDAO.pollResOkSetSelect(map);
		logger.debug("answerID : " + answerID);
		logger.debug("pollResOkSetSelect ended.");
		
		map.put("v_ANSWERID", answerID);
		map.put("v_ANSWERETC", answerETC);
		map.put("v_USERINFO_USERID", id);
		map.put("v_USERINFO_COMPANYID", companyID);
		map.put("v_ANSWERTYPE", answerType);
		map.put("v_ANSWERCOUNT", answerCount);
		
		if (isSave.equals("0")) {
			logger.debug("pollResOkSetInsert started.");
			ezCommunityDAO.pollResOkSetInsert(map);
			logger.debug("pollResOkSetInsert ended.");
		} else {
			logger.debug("pollResOkSetUpdate started.");
			ezCommunityDAO.pollResOkSetUpdate(map);
			logger.debug("pollResOkSetUpdate ended.");
		}
		
		logger.debug("pollResOkSet ended.");
	}
	
	public CommunityMemberInfoVO commViewMemberGet3(String id, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("commViewMemberGet3 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", id);
		map.put("v_COMPANYID", companyID);
		map.put("v_USERINFO_LANG", lang);
		map.put("tenantID", tenantID);
		
		CommunityMemberInfoVO vo = ezCommunityDAO.commViewMemberGet3(map);
		
		logger.debug("commViewMemberGet3 ended.");
		
		return vo;
	}
	
	public List<CommunityClubVO> leftCommunityGet3(String userID, int tenantID) throws Exception {
		logger.debug("leftCommunityGet3 started.");
		logger.debug("userID : " + userID + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("tenantID", tenantID);
		
		List<CommunityClubVO> list = ezCommunityDAO.leftCommunityGet3(map);
		
		logger.debug("leftCommunityGet3 ended.");
		
		return list;
	}
	
	public List<CommunityBoardTreeVO> brdBoardTree(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSelectBy, String pExcludeBoardID, String pClubNo, int tenantID) throws Exception {
		logger.debug("brdBoardTree started.");
		logger.debug("pRootBoardID : " + pRootBoardID);
		logger.debug("pUserID : " + pUserID);
		logger.debug("pDeptID : " + pDeptID);
		logger.debug("pCompanyID : " + pCompanyID);
		logger.debug("pMode : " + pMode);
		logger.debug("pSelectBy : " + pSelectBy);
		logger.debug("pExcludeBoardID : " + pExcludeBoardID);
		logger.debug("pClubNo : " + pClubNo);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pRootBoardID", pRootBoardID);
		map.put("v_pUserID", pUserID);
		map.put("v_pDeptID", pDeptID);
		map.put("v_pCompanyID", pCompanyID);
		map.put("v_pMode", pMode);
		map.put("v_pSelectBy", pSelectBy);
		map.put("v_pExcludeBoardID", pExcludeBoardID);
		map.put("v_pClubNo", pClubNo);
		map.put("tenantID", tenantID);
		
		List<CommunityBoardTreeVO> list = ezCommunityDAO.brdBoardTree(map);
		
		logger.debug("brdBoardTree ended.");
		
		return list;
	}
	
	public List<CommunityBoardTreeVO> getBoardTreeGet2(String userID, int tenantID) throws Exception {
		logger.debug("getBoardTreeGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		
		List<CommunityBoardTreeVO> list = ezCommunityDAO.getBoardTreeGet2(map);
		
		logger.debug("getBoardTreeGet2 ended.");
		
		return list;
	}
	
	public List<CommunityCClubUserVO> commViewMemberGet1(String code, String lang, String keyword, String sRadio, int tenantID) throws Exception {
		logger.debug("commViewMemberGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_code", code);
		map.put("v_userInfo_lang", lang);
		map.put("v_keyword", keyword);
		map.put("v_s_radio", sRadio.toUpperCase());
		map.put("tenantID", tenantID);
		
		List<CommunityCClubUserVO> list = ezCommunityDAO.commViewMemberGet1(map);
		
		logger.debug("commViewMemberGet1 ended.");
		
		return list;
	}	
	
	public List<CommunityBoardInfoVO> getBoardList(String code, String lang, String position, int tenantID) throws Exception {
		logger.debug("getBoardList started.");
		logger.debug("code : " + code + ", lang : " + lang + ", position : " + position + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_LANG", lang);
		map.put("v_POSITION", position);
		map.put("tenantID", tenantID);
		
		List<CommunityBoardInfoVO> list = ezCommunityDAO.getBoardList(map);
		
		logger.debug("getBoardList ended.");
		
		return list;
	}
	
	public List<CommunityCOutApplicationVO> adminOuterListGet2(String code, String lang, int tenantID) throws Exception {
		logger.debug("adminOuterListGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_USERINFO_LANG", lang);
		map.put("tenantID", tenantID);
		
		List<CommunityCOutApplicationVO> list = ezCommunityDAO.adminOuterListGet2(map);
		
		logger.debug("adminOuterListGet2 ended.");
		
		return list;
	}
	
	public List<CommunityCClubUserVO> adminMemberListGet3(String code, String flag, String lang, String ser, int tenantID) throws Exception {
		logger.debug("adminMemberListGet3 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_FLAG", flag);
		map.put("v_USERINFO_LANG", lang);
		map.put("v_SER", ser);
		map.put("tenantID", tenantID);
		
		List<CommunityCClubUserVO> list = ezCommunityDAO.adminMemberListGet3(map);
		
		logger.debug("adminMemberListGet3 ended.");
		
		return list;
	}

	public List<String> myCommunityGet(String id, int pStart, int pEnd, String mode, int tenantID) throws Exception {
		logger.debug("myCommunityGet started.");
		logger.debug("id : " + id + ", pStart : " + pStart + ", pEnd : " + pEnd + ", mode : " + mode + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", id);
		map.put("v_PSTART", pStart);
		map.put("mariaStart", pStart - 1);
		map.put("v_PEND", pEnd);
		map.put("mariaEnd", pEnd - pStart);
		map.put("v_MODE", mode);
		map.put("tenantID", tenantID);
		
		List<String> list = ezCommunityDAO.myCommunityGet(map);
		
		logger.debug("myCommunityGet ended.");
		
		return list;
	}
	
	public CommunityCBoardVO bbsEditOkGet1(String bName, String no, String code, int tenantID) throws Exception {
		logger.debug("bbsEditOkGet1 started");
		logger.debug("bName : " + bName + ", no : " + no + ", code : " + code + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_NO", no);
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		CommunityCBoardVO vo = ezCommunityDAO.bbsEditOkGet1(map);
		
		logger.debug("bbsEditOkGet1 ended");
		
		return vo;
	}
	
	public CommunityClubVO commMakeOkGet1(String clubName, String cCateA, String cCateB, String cCateC, String lang, int tenantID) throws Exception {
		logger.debug("commMakeOkGet1 started.");
		logger.debug("clubName : " + clubName + ", cCateA : " + cCateA + ", cCateB : " + cCateB + ", cCateC : " + cCateC + ", lang : " + lang + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CLUBNAME", clubName);
		map.put("v_C_CATE_A", cCateA);
		map.put("v_C_CATE_B", cCateB);
		map.put("v_C_CATE_C", cCateC);
		map.put("v_USERINFO_LANG", lang);
		map.put("tenantID", tenantID);
		
		CommunityClubVO vo = ezCommunityDAO.commMakeOkGet1(map);
		
		logger.debug("commMakeOkGet1 ended.");
		
		return vo;
	}
	
	public CommunityCPollResponseVO pollResGet5(int questionID, String id, String companyID, int tenantID) throws Exception {
		logger.debug("pollResGet5 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_QUESTIONID", questionID);
		map.put("v_USERINFO_USERID", id);
		map.put("v_USERINFO_COMPANYID", companyID);
		map.put("tenantID", tenantID);
		
		CommunityCPollResponseVO vo = ezCommunityDAO.pollResGet5(map);
		
		logger.debug("pollResGet5 ended.");
		
		return vo;
	}
	
	public Map<String, String> getAdjacentItems(String pItemID, String pBoardID, String upperItemIDTree, String parentWriteDate, int tenantID) throws Exception {
		logger.debug("getAdjacentItems started.");
		logger.debug("pItemID : " + pItemID + ", pBoardID : " + pBoardID + ", upperItemIDTree : " + upperItemIDTree + ", parentWriteDate : " + parentWriteDate + ", tenantID : " + tenantID);
		
		String previousItemID = "", previousTitle = "", nextItemID = "", nextTitle = "", tempItemID = "", tempTitle = "";
		Map<String, Object> map;
		List<CommunityBoardItemVO> list;
		
		map = new HashMap<String, Object>();
		map.put("v_pParentWriteDate", parentWriteDate);
		map.put("v_pUpperItemIDTree", upperItemIDTree);
		map.put("v_pBoardID", pBoardID);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		logger.debug("getAdjacentItemsGet1 started.");
		
		list = ezCommunityDAO.getAdjacentItemsGet1(map);
		
		logger.debug("getAdjacentItemsGet1 ended.");
		
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
			map.put("v_pParentWriteDate", parentWriteDate);
			map.put("v_pBoardID", pBoardID);
			map.put("v_pNow", commonUtil.getTodayUTCTime(""));
			map.put("tenantID", tenantID);
			
			logger.debug("getAdjacentItemsGet2 started.");
			
			list = ezCommunityDAO.getAdjacentItemGet2(map);
			
			logger.debug("getAdjacentItemsGet2 ended.");
			
			for (CommunityBoardItemVO item : list) {
				if (item.getItemID().equals(pItemID) && list.indexOf(item) > 0) {
					previousItemID = list.get(list.indexOf(item) - 1).getItemID().trim();
					previousTitle = list.get(list.indexOf(item) - 1).getTitle().trim();
				}
			}
		}
		
		if (nextItemID.equals("")) {
			map = new HashMap<String, Object>();
			map.put("v_pBoardID", pBoardID);
			map.put("v_pParentWriteDate", parentWriteDate);
			map.put("v_pItemID", pItemID);
			map.put("v_pUpperItemIDTree", upperItemIDTree);
			map.put("v_previousItemID", previousItemID);
			map.put("v_pNow", commonUtil.getTodayUTCTime(""));
			map.put("tenantID", tenantID);
			
			logger.debug("getAdjacentItemsGet3 started.");
			
			CommunityBoardItemVO item = ezCommunityDAO.getAdjacentItemGet3(map);
			
			logger.debug("getAdjacentItemsGet3 ended.");
			
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
		
		logger.debug("getAdjacentItems ended.");
		
		return ret;
	}
	
	public int brdCheckIfBoardGroupAdmin(String pRootBoardID, String id, String deptID, String companyID, int tenantID) throws Exception {
		logger.debug("brdCheckIfBoardGroupAdmin started.");
		logger.debug("pRootBoardID : " + pRootBoardID + ", id : " + id + ", deptID : " + deptID + ", companyID : " + companyID + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", pRootBoardID);
		map.put("v_pUserID", id);
		map.put("v_pDeptID", deptID);
		map.put("v_pCompanyID", companyID);
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.brdCheckIfBoardGroupAdmin(map);
		
		logger.debug("brdCheckIfBoardGroupAdmin ended.");
		
		return result;
	}
	

	public String getCategoryValueA(String strSelCateA, LoginVO userInfo) throws Exception {
		logger.debug("getCategoryValueA started.");
		logger.debug("strSelCateA : " + strSelCateA + ", tenantID : " + userInfo.getTenantId());
		
		StringBuilder sb = new StringBuilder();
		List<CommunityCCategoryVO> categoryList = ezCommunityDAO.getCategoryValueA(userInfo.getTenantId());
		
		for(CommunityCCategoryVO category : categoryList){
			sb.append("<Option Value=\"");
			sb.append(category.getC_Code());
			sb.append("\" ");
			
			if(strSelCateA.equals(category.getC_Code())){
				sb.append("selected");
			}
			
			sb.append(">");
			String code = "ezCommunity."+category.getC_Name();
			sb.append(egovMessageSource.getMessage(code, userInfo.getLocale()));
			sb.append("</Option>");
		}
		
		logger.debug("getCategoryValueA ended.");
		
		return sb.toString();
	}

	public String getCategoryValueB(String strSelCateB, LoginVO userInfo) throws Exception {
		logger.debug("getCategoryValueB started.");
		logger.debug("strSelCateB : " + strSelCateB + ", tenantID : " + userInfo.getTenantId());
		
		StringBuilder sb = new StringBuilder();
		List<CommunityCCategoryVO> categoryList = ezCommunityDAO.getCategoryValueB(userInfo.getTenantId());
		
		for(CommunityCCategoryVO category : categoryList){
			sb.append("<Option Value=\"");
			sb.append(category.getC_Code());
			sb.append("\" ");
			
			if(strSelCateB.equals(category.getC_Code())){
				sb.append("selected");
			}
			
			sb.append(">");
			String code = "ezCommunity."+category.getC_Name();
			sb.append(egovMessageSource.getMessage(code, userInfo.getLocale()));
			sb.append("</Option>");
		}
		
		logger.debug("getCategoryValueB ended.");
		return sb.toString();
	}

	public String getCategoryValueC(String strSelCateC, LoginVO userInfo) throws Exception {
		logger.debug("getCategoryValueB started.");
		logger.debug("strSelCateC : " + strSelCateC + ", tenantID : " + userInfo.getTenantId());
		
		StringBuilder sb = new StringBuilder();
		List<CommunityCCategoryVO> categoryList = ezCommunityDAO.getCategoryValueC(userInfo.getTenantId());
		
		for(CommunityCCategoryVO category : categoryList){
			sb.append("<Option Value=\"");
			sb.append(category.getC_Code());
			sb.append("\" ");
			
			if(strSelCateC.equals(category.getC_Code())){
				sb.append("selected");
			}
			
			sb.append(">");
			String code = "ezCommunity."+category.getC_Name();
			sb.append(egovMessageSource.getMessage(code, userInfo.getLocale()));
			sb.append("</Option>");
		}
		
		logger.debug("getCategoryValueC ended.");
		
		return sb.toString();
	}
	
	public String getBoardTreeGet1(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String strLang, int tenantID) throws Exception {
		logger.debug("getBoardTreeGet1 started.");
		logger.debug("pRootBoardID : " + pRootBoardID + ", pUserID : " + pUserID + ", pDeptID : " + pDeptID + ", pCompanyID : " + pCompanyID + ", pMode : " + pMode + ", pSubFlag : " + pSubFlag);
		logger.debug("pSelectBy : " + pSelectBy + ", pExcludeBoardID : " + pExcludeBoardID + ", pClubNo : " + pClubNo + ", strLang : " + strLang + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pRootBoardID", pRootBoardID);
		map.put("v_pUserID", pUserID);
		map.put("v_pDeptID", pDeptID);
		map.put("v_pCompanyID", pCompanyID);
		map.put("v_pMode", pMode);
		map.put("v_pSubFlag", pSubFlag);
		map.put("v_pSelectBy", pSelectBy);
		map.put("v_pExcludeBoardID", pExcludeBoardID);
		map.put("v_pClubNo", pClubNo);
		map.put("v_strLang", strLang);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.getBoardTreeGet1(map);
		
		logger.debug("result : " + result);
		logger.debug("getBoardTreeGet1 ended.");
		
		return result;
	}
	
	public String getFileFolderName(String bName) throws Exception {
		String strReturn = "";
		
		switch (bName){
            case "tbl_c_clubnotice":
                strReturn = "notice";
                break;
            case "tbl_c_clubboard":
                strReturn = "board";
                break;
            case "tbl_c_clubboard1":
                strReturn = "board1";
                break;
            case "tbl_c_clubboard2":
                strReturn = "board";
                break;
            case "tbl_c_clubpds":
                strReturn = "pds";
                break;
            case "tbl_c_clubpds1":
                strReturn = "pds1";
                break;
            case "tbl_c_notice":
                strReturn = "mainnotice";
                break;
            case "tbl_c_board":
            default:
                strReturn = "mainboard";
                break;
        }
		
		return strReturn;
	}
	
	public int bbsEditOkGet2(String maxIdFieldName, String bName, String code, int tenantID) throws Exception {
		logger.debug("bbsEditOkGet2 started.");
		logger.debug("maxIdFieldName : " + maxIdFieldName + ", bName : " + bName + ", code : " + code + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MAXIDFIELDNAME", maxIdFieldName);
		map.put("v_BNAME", bName);	
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.bbsEditOkGet2(map);
		
		logger.debug("bbsEditOkGet2 ended.");
		
		return result;
	}
	
	public String bbsEditOkGet3(String maxIdFieldName, String bName, String code, int maxNum, int tenantID) throws Exception {
		logger.debug("bbsEditOkGet3 started.");
		logger.debug("maxIdFieldName : " + maxIdFieldName + ", bName : " + bName + ", code : " + code + ", strMaxNum : " + maxNum + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MAXIDFIELDNAME", maxIdFieldName);
		map.put("v_BNAME", bName);	
		map.put("v_CODE", code);
		map.put("v_STRMAXNUM", Integer.toString(maxNum));
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.bbsEditOkGet3(map);
		
		logger.debug("bbsEditOkGet3 ended.");
		
		return result;
	}
	
	public String commMakeOkGet6(String companyID, String id, int tenantID) throws Exception {
		logger.debug("commMakeOkGet6 started.");
		logger.debug("companyID : " + companyID + ", id : " + id + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_COMPANYID",	companyID);
		map.put("v_USERINFO_USERID", id);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.commMakeOkGet6(map);
		
		logger.debug("commMakeOkGet6 ended.");
		
		return result;
	}
	
	public String checkIfLeafBoard(String pBoardID, int tenantID) throws Exception {
		if (checkIfLeafBoardGet(pBoardID, tenantID) > 0) {
			return "FALSE";
		} else {
			return "TRUE";
		}
	}
	
	public String getBoardListItemXML(LoginVO userInfo, String pBoardID, int pStartRow, int pEndRow, String pSortBy) throws Exception {
		logger.debug("getBoardListItemXML started.");
		
		String id = userInfo.getId();
		String offset = userInfo.getOffset();
		String lang = userInfo.getLang();
		int tenantID = userInfo.getTenantId();
		
		int count = 0;
		StringBuilder sb = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_LANG", commonUtil.getMultiData(lang, userInfo.getTenantId()));
		map.put("v_PUSERID", id);
		map.put("v_PBOARDID", pBoardID);
		map.put("v_PSORTBY", pSortBy);
		map.put("v_PENDROW", pEndRow);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
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
				sb.append("<WriteDate>" + commonUtil.getDateStringInUTC(boardList.getWriteDate(), offset, false) + "</WriteDate>");
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
		
		logger.debug("getBoardListItemXML started.");
		
		return sb.toString();
	}
	
	public String getProperSizeDisplay(int pSize) throws Exception {
		if (pSize > 1048576) {
			return Integer.toString((int) (pSize / 1024 / 102.4) / 10) + " MB";
		} else if (pSize > 1024) {
			return Integer.toString((int) (pSize / 102.4) / 10) + " KB";
		} else {
			return Integer.toString(pSize) + " Byte";
		}
	}
	
	public String pollAddOkGoGet2(String code, int maxNo, int tenantID) throws Exception {
		logger.debug("pollAddOkGoGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_MAXNO", maxNo);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.pollAddOkGoGet2(map);
		
		logger.debug("pollAddOkGoGet2 ended.");
		
		return result;
	}
	
	public String pollResGet4(String lang, String pollRegUser, int tenantID) throws Exception {
		logger.debug("pollResGet4 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_LANG", lang);
		map.put("v_POLLREGUSER", pollRegUser);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.pollResGet4(map);
		
		logger.debug("pollResGet4 ended.");
		
		return result;
	}
	
	public String getClubMemberInfo(String pCN, String pSearch, String lang, int tenantID) throws Exception {
		Document xmlDoc = commonUtil.convertStringToDocument(ezOrganService.getPropertyList(pCN, pSearch, "1", tenantID));
		
		if (lang.equals("2")) {
			return xmlDoc.getElementsByTagName("DESCRIPTION2").item(0).getTextContent();
		} else {
			return xmlDoc.getElementsByTagName("DESCRIPTION1").item(0).getTextContent();
		}
	}
	
	public int checkIfLeafBoardGet(String boardID, int tenantID) throws Exception {
		logger.debug("checkIfLeafBoardGet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardID);
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.checkIfLeafBoardGet(map);
		
		logger.debug("checkIfLeafBoardGet ended.");
		
		return result;
	}
	
	public int commMakeOkGet2(int tenantID) throws Exception {
		logger.debug("commMakeOkGet2 started.");
		logger.debug("tenantID : " + tenantID);
		
		int result = ezCommunityDAO.commMakeOkGet2(tenantID);
		
		logger.debug("commMakeOkGet2 ended.");
		
		return result;
	}
	
	public int commMakeOkGet4(int tenantID) throws Exception {
		logger.debug("commMakeOkGet4 started.");
		
		int result = ezCommunityDAO.commMakeOkGet4(tenantID);
		
		logger.debug("commMakeOkGet4 ended.");
		
		return result;
	}
	
	@Override
	public int commHomeGet2(String code, int tenantID) throws Exception {
		logger.debug("commHomeGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.commHomeGet2(map);
		
		logger.debug("commHomeGet2 ended.");
		
		return result;
	}
	
	public int pollResGetAllCount(int questionID, int tenantID) throws Exception {
		logger.debug("pollResGetAllCount started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_QUESTIONID", questionID);
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.pollResGetAllCount(map);
		
		logger.debug("pollResGetAllCount ended. result="+result);
		
		return result;
	}
	
	public int pollResGetCount(int questionID, int answerID, int tenantID) throws Exception {
		logger.debug("pollResGetCount started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_QUESTIONID", questionID);
		map.put("v_ANSWERID", answerID);
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.pollResGetCount(map);
		
		logger.debug("pollResGetCount ended.");
		
		return result;
	}
	
	public boolean saveMHT(String strHTML, String strMHTFileName, String strBoardID, String strFilePath, String realPath) throws Exception {
		String docPath = "";
		String mhtFilePath = "";
		
		try {
			docPath = realPath + strFilePath;
			
			if (!new File(docPath + strBoardID).exists()) {
				File dir1 = new File(docPath + strBoardID + commonUtil.separator + "uploadFile");
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
			logger.debug("saveMHT ERROR");
			logger.error(e.getMessage());
			return false;
		}
	}
	
	public boolean saveAttachmentsInfo(CommunityBoardItemVO item, String pUploadFilePath, String realPath, int tenantID) throws Exception {
		logger.debug("saveItemAttachInfo started. ");
		
		String fileSize = "";
		String filePath = "";
		Map<String, Object> map;
		
		String attachments = item.getAttachments();
		String itemID = item.getItemID();
		String boardID = item.getBoardID();
		String thumbPath = item.getExtensionAttribute5();
		String fileName = "";

		logger.debug("attachments : + " + attachments + ", itemID : " + itemID + ", boardID : " + boardID + ", thumbPath : " + thumbPath + ", fileName : " + fileName);
		
		try {
			if (!attachments.substring(attachments.length() - 1).equals(";")) {
				attachments += ";";
			}
			
			
			String[] attachmentsArr = attachments.split(";");
			for (int i = 0; i < attachmentsArr.length; i++) {
				map = new HashMap<String, Object>();
				map.put("tenantID", tenantID);
				
				File file = new File(realPath + pUploadFilePath + attachmentsArr[i]);
				fileSize = Integer.toString((int) file.length());
				filePath = attachmentsArr[i];
				
				if (attachmentsArr[i].indexOf("tempUploadFile") > -1) {
					File destFile = new File(realPath + pUploadFilePath + boardID + commonUtil.separator + "uploadFile" + commonUtil.separator + attachmentsArr[i].replace("tempUploadFile", ""));
					FileUtils.moveFile(file, destFile);
					filePath = attachmentsArr[i].replace("tempUploadFile", "");
				}
				
				if (!thumbPath.equals("")) {
					File thumbnailFile = new File(realPath + pUploadFilePath  + thumbPath.split(";")[i]);
					map.put("itemID", itemID);
					
					if (thumbPath.indexOf("tempUploadFile") > -1) {
						File destThumbFile = new File(realPath+ pUploadFilePath  + boardID + commonUtil.separator + "uploadFile" + thumbPath.split(";")[i].replace("tempUploadFile", ""));
						FileUtils.moveFile(thumbnailFile, destThumbFile);
						map.put("filePath", boardID + commonUtil.separator + "uploadFile" + commonUtil.separator + thumbPath.split(";")[i].replace("tempUploadFile", ""));
					} else {
						map.put("filePath", thumbPath.split(";")[i]);
					}
					
					ezCommunityDAO.updateAttachInfo(map);
				}
				
				//get fileName from attachments string
				fileName = attachmentsArr[i];
				if (fileName.indexOf("/") > -1) {
					fileName = fileName.substring(fileName.lastIndexOf("/") + 1);
				}
				if (fileName.indexOf("}_") > -1) {
					fileName = fileName.substring(fileName.indexOf("}_") + 2);
				}
				
				map = new HashMap<String, Object>();
				map.put("itemID", itemID);
				map.put("fileSize", fileSize);
				map.put("fileName", fileName);
				map.put("tenantID", tenantID);
				
				if (attachmentsArr[i].indexOf("tempUploadFile") > -1) {
					map.put("filePath", boardID + commonUtil.separator + "uploadFile" + filePath);
					ezCommunityDAO.insertAttachInfo(map);
				} else {
					map.put("filePath", filePath);
					ezCommunityDAO.insertAttachInfo(map);
				}
			}
			
			return true;
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.error(e.getMessage());
			return false;
		}
	}
	
	public void getBoardTreeSet(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String strLang, String result, int tenantID) throws Exception {
		logger.debug("getBoardTreeSet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pRootBoardID", pRootBoardID);
		map.put("v_pUserID", pUserID);
		map.put("v_pDeptID", pDeptID);
		map.put("v_pCompanyID", pCompanyID);
		map.put("v_pMode", pMode);
		map.put("v_pSubFlag", pSubFlag);
		map.put("v_pSelectBy", pSelectBy);
		map.put("v_pExcludeBoardID", pExcludeBoardID);
		map.put("v_pClubNo", pClubNo);
		map.put("v_strLang", strLang);
		map.put("v_result", result);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.deleteBoardTreeChache(map);
		ezCommunityDAO.insertBoardTreeChache(map);
		
		logger.debug("getBoardTreeSet ended.");
	}
	
	public void bbsEditOkSet1(String bName, String title, String no, String code, String attachList, String textContent, int tenantID) throws Exception {
		logger.debug("bbsEditOkSet1 started.");
		logger.debug("bName : "+ bName + ", title : " + title + ", no : " + no + ", code : " + code + ", attachList : " + attachList + ", textContent : " + textContent);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_TITLE", title);
		map.put("v_NO", no);
		map.put("v_CODE", code);
		map.put("v_ATTACHLIST", attachList);
		map.put("v_TEXTCONTENT", textContent);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.bbsEditOkSet1(map);
		
		logger.debug("bbsEditOkSet1 ended.");
	}
	
	public void bbsEditOkSet2(String bName, int myRef, int myStep, String code, int tenantID) throws Exception {
		logger.debug("bbsEditOkSet2 started.");
		logger.debug("bName : " + bName);		
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_bName", bName);
		map.put("v_myREf", myRef);
		map.put("v_myStep", myStep);
		map.put("v_code", code);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.bbsEditOkSet2(map);
		
		logger.debug("bbsEditOkSet2 ended.");
	}
	
	public void bbsEditOkInsert(String bName, int myRef, int newStep, int newLevel, String attachList, int number, String textContent, String nowDate, String fileName, String code, String companyID, String id, String userNm, String userNm2, String title, String maxIdFieldName, int tenantID) throws Exception {
		logger.debug("bbsEditOkInsert started.");
		logger.debug("bName : " + bName + ", myRef : " + myRef + ", newStep : " + newStep + ", newLevel : " + newLevel + ", attachList : " + attachList + ", number : " + number);
		logger.debug(", textContent : " + textContent + ", nowDate : " + nowDate + ", fileName : " + fileName + ", code : " + code + ", companyID : " + companyID + ", id : " + id);
		logger.debug(", userNm : " + userNm + ", userNm2 : " + userNm2 + ", title : " + title + ", maxIdFieldName : " + maxIdFieldName + ", tenantID : " + tenantID);
		
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
		map.put("v_USERINFO_DISPLAYNAME1", userNm);
		map.put("v_USERINFO_DISPLAYNAME2", userNm2);
		map.put("v_TITLE", title);
		map.put("v_MAXIDFIELDNAME", maxIdFieldName);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.bbsEditOkInsert(map);
		
		logger.debug("bbsEditOkInsert ended.");
	}

	public void bbsDelOkDel(String bName, String itemNo, String code, int tenantID) throws Exception {
		logger.debug("bbsDelOkDel started.");
		logger.debug("bName : " + bName + ", itemNo : " + itemNo + ", code : " + code + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName);
		map.put("v_NO", itemNo);
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		logger.debug("bbsDelOkDel started.");
		
		ezCommunityDAO.bbsDelOkDel(map);
	}
	
	public void commMakeOkInsert2(int clubNo, String clubName, String clubName2, String cCateA, String cCateB, String cCateC, String clubType, String clubConfirmType, String intro, int isIn, String logo, String banner, String bBoardName1, String bBoardName2, String comatt, String code, String bNotiName1, String bNotiName2, String pNewID, int boardNo, String id, String displayName1, String companyName1, String deptName1, String pNewSubID, int openEmail, int openHp, int openComp, int openHouse, int openJob, int openBirth, int openSex, String companyID, int tenantID) throws Exception {
		logger.debug("commMakeOkInsert2 started.");
		logger.debug("clubNo : " + clubNo + ", clubName : " + clubName + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TMP_CLUBID", clubNo);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.updateClubID(map);
		
		map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("v_CLUBNAME", clubName);
		map.put("v_CLUBNAME2", clubName2);
		map.put("v_C_CATE_A", cCateA);
		map.put("v_C_CATE_B", cCateB);
		map.put("v_C_CATE_C", cCateC);
		map.put("v_CLUBTYPE", clubType);
		map.put("v_CLUBCONFIRMTYPE", clubConfirmType);
		map.put("v_USERINFO_USERID", id);
		map.put("v_INTRO", intro);
		map.put("v_ISIN", isIn);
		map.put("v_LOGO", logo);
		map.put("v_LOGO_THUMBNAIL", logo);
		map.put("v_BANNER", banner);
		map.put("v_USERINFO_COMPANYID", companyID);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.insertClub(map);
		
		map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_BOARDID", pNewID);
		map.put("v_B_BOARD_NAME1", bBoardName1);
		map.put("v_B_BOARD_NAME2", bBoardName2);
		map.put("v_PARENTBOARDID", "TOP");
		map.put("v_ATTACHSIZELIMIT", comatt);
		map.put("v_BOARDNO", boardNo);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.insertCommBoardInfo(map);
		
		map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_BOARDID", pNewSubID);
		map.put("v_B_BOARD_NAME1", bNotiName1);
		map.put("v_B_BOARD_NAME2", bNotiName2);
		map.put("v_PARENTBOARDID", pNewID);
		map.put("v_ATTACHSIZELIMIT", comatt);
		map.put("v_BOARDNO", boardNo);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.insertCommBoardInfo(map);
		
		map = new HashMap<String, Object>();
		map.put("v_BOARDID", pNewID);
		map.put("v_ACCESSID", id);
		map.put("v_ACCESSNAME", displayName1 + "(" + companyName1 + ", " + deptName1 + ")");
		map.put("v_ACCESSLEVEL", 1);
		map.put("v_ACCESS_", 1);
		map.put("v_PARENTBOARDID", "TOP");
		map.put("v_BOARDADMIN_FG", "TRUE");
		map.put("v_LISTVIEW_FG", "TRUE");
		map.put("v_READ_FG", "TRUE");
		map.put("v_WRITE_FG", "TRUE");
		map.put("v_REPLY_FG", "TRUE");
		map.put("v_DELETE_FG", "TRUE");
		map.put("v_INHERIT_FG", "TRUE");
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.insertCommBoardManage(map);
		
		map = new HashMap<String, Object>();
		map.put("v_BOARDID", pNewSubID);
		map.put("v_ACCESSID", id);
		map.put("v_ACCESSNAME", displayName1 + "(" + companyName1 + ", " + deptName1 + ")");
		map.put("v_ACCESSLEVEL", 1);
		map.put("v_ACCESS_", 1);
		map.put("v_PARENTBOARDID", pNewID);
		map.put("v_BOARDADMIN_FG", "TRUE");
		map.put("v_LISTVIEW_FG", "TRUE");
		map.put("v_READ_FG", "TRUE");
		map.put("v_WRITE_FG", "TRUE");
		map.put("v_REPLY_FG", "TRUE");
		map.put("v_DELETE_FG", "TRUE");
		map.put("v_INHERIT_FG", "TRUE");
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.insertCommBoardManage(map);
		
		map = new HashMap<String, Object>();
		map.put("v_BOARDID", pNewID);
		map.put("v_ACCESSID", "EVERYONE");
		map.put("v_ACCESSNAME", "EVERYONE");
		map.put("v_ACCESSLEVEL", null);
		map.put("v_ACCESS_", 1);
		map.put("v_PARENTBOARDID", "TOP");
		map.put("v_BOARDADMIN_FG", "FALSE");
		map.put("v_LISTVIEW_FG", "TRUE");
		map.put("v_READ_FG", "TRUE");
		map.put("v_WRITE_FG", "FALSE");
		map.put("v_REPLY_FG", "TRUE");
		map.put("v_DELETE_FG", "FALSE");
		map.put("v_INHERIT_FG", "FALSE");
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.insertCommBoardManage(map);
		
		map = new HashMap<String, Object>();
		map.put("v_BOARDID", pNewSubID);
		map.put("v_ACCESSID", "EVERYONE");
		map.put("v_ACCESSNAME", "EVERYONE");
		map.put("v_ACCESSLEVEL", null);
		map.put("v_ACCESS_", 1);
		map.put("v_PARENTBOARDID", pNewID);
		map.put("v_BOARDADMIN_FG", "FALSE");
		map.put("v_LISTVIEW_FG", "TRUE");
		map.put("v_READ_FG", "TRUE");
		map.put("v_WRITE_FG", "FALSE");
		map.put("v_REPLY_FG", "TRUE");
		map.put("v_DELETE_FG", "FALSE");
		map.put("v_INHERIT_FG", "FALSE");
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.insertCommBoardManage(map);
		
		map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_USERINFO_USERID", id);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("v_OPENEMAIL", openEmail);
		map.put("v_OPENHP", openHp);
		map.put("v_OPENCOMP", openComp);
		map.put("v_OPENHOUSE", openHouse);
		map.put("v_OPENJOB", openJob);
		map.put("v_OPENBIRTH", openBirth);
		map.put("v_OPENSEX", openSex);
		map.put("v_PERMIT", 4);
		map.put("v_USERINFO_COMPANYID", companyID);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.insertClubUser(map);
		
		logger.debug("commMakeOkInsert2 ended.");
	}
	
	public void commMakeOkSet1(String logoFileName, String thumbnailFileName, String fileName, int fileSize, int tenantID) throws Exception {
		logger.debug("commMakeOkSet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LOGOFILENAME", logoFileName);
		map.put("v_LOGOFILENAME_THUMBNAIL", thumbnailFileName);
		map.put("v_FILENAME", fileName);
		map.put("v_FILESIZE", fileSize);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.commMakeOkSet1Update(map);
		
		ezCommunityDAO.commMakeOkSet1Insert(map);
		
		logger.debug("commMakeOkSet1 ended.");
	}
	
	public void commMakeOkSet2(String bannerFileName, String fileName, int fileSize, int tenantID) throws Exception {
		logger.debug("commMakeOkSet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BANNERFILENAME", bannerFileName);
		map.put("v_FILENAME", fileName);
		map.put("v_FILESIZE", fileSize);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.commMakeOkSet2Update(map);
		
		int count = ezCommunityDAO.commMakeOkSet2Select(map);
		logger.debug("commMakeOkSet2Select count="+count);
		
		if (count > 0 ) {
			ezCommunityDAO.commMakeOkSet2Update1(map);
		} else {
			ezCommunityDAO.commMakeOkSet2Insert(map);
		}
		
		logger.debug("commMakeOkSet2 ended.");
	}
	
	public void guestEditOkDelete(String no, String code, int tenantID) throws Exception {
		logger.debug("guestEditOkDelete started. no : " + no + ", code : " + code);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("c_no", no);
		map.put("code", code);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.guestEditOkDelete(map);
		
		logger.debug("guestEditOkDelete ended.");
	}
	
	public void guestEditOkUpdate(String no, String code, String memo, String id, int tenantID) throws Exception {
		logger.debug("guestEditOkUpdate started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("c_no", no);
		map.put("code", code);
		map.put("userInfo_userID", id);
		map.put("tenantID", tenantID);
		
		int temp = ezCommunityDAO.guestEditOkUpdateSelect(map);
		
		if (temp > 0) {
			map = new HashMap<String, Object>();
			map.put("c_no", no);
			map.put("code", code);
			map.put("memo", memo);
			map.put("tenantID", tenantID);
			
			ezCommunityDAO.guestEditOkUpdateUpdate(map);
		}
		
		logger.debug("guestEditOkUpdate ended.");
	}
	
	public void pollAddOkGoInsert1(String code, int maxNo, String subject, String startDate, String endDate, String id, int tenantID) throws Exception {
		logger.debug("pollAddOkGoInsert1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_MAXNO", maxNo);
		map.put("v_SUBJECT", subject);
		map.put("v_STARTDATE", startDate);
		map.put("v_ENDDATE", endDate);
		map.put("v_USERINFO_USERID", id);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.pollAddOkGoInsert1(map);
		
		logger.debug("pollAddOkGoInsert1 ended.");
	}
	
	public void pollAddOkGoInsert2(String managerID, String subject, String answerCount, String selType, String answerViewType, int tenantID) throws Exception {
		logger.debug("pollAddOkGoInsert2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MANAGERID", managerID);
		map.put("v_SUBJECT", subject);
		map.put("v_ANSWERCOUNT", answerCount);
		map.put("v_SELTYPE", selType);
		map.put("v_ANSWERVIEWTYPE", answerViewType);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.pollAddOkGoInsert2(map);
		
		logger.debug("pollAddOkGoInsert2 ended.");
	}
	
	public void pollAddOkGoInsert3(String questionID, int answerNo, String answerContent, int tenantID) throws Exception {
		logger.debug("pollAddOkGoInsert3 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_POLLQUESTIONID", questionID);
		map.put("v_ANSWERNO", answerNo);
		map.put("v_ANSWERCONTENT", answerContent);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.pollAddOkGoInsert3(map);
		
		logger.debug("pollAddOkGoInsert3 ended.");
	}
	
	public void pollDeleteDel1(int questionID, int answerID, int tenantID) throws Exception {
		logger.debug("pollDeleteDel1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_QUESTIONID", questionID);
		map.put("v_ANSWERID", answerID);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.pollDeleteDel1(map);
		
		logger.debug("pollDeleteDel1 ended.");
	}
	
	public void pollDeleteDel2(int questionID, int tenantID) throws Exception {
		logger.debug("pollDeleteDel2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_QUESTIONID", questionID);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.pollDeleteDel2(map);
		
		logger.debug("pollDeleteDel2 ended.");
	}
	
	public void pollDeleteDel3(String managerID, int tenantID) throws Exception {
		logger.debug("pollDeleteDel3 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MANAGERID", managerID);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.pollDeleteDel3(map);
		ezCommunityDAO.pollDeleteDel4(map);
		
		logger.debug("pollDeleteDel3 ended.");
	}

	public void pollEditOkUpdate(String subject, String startDate, String endDate, String managerID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SUBJECT", subject);
		map.put("v_POLLSTARTDATE", startDate);
		map.put("v_POLLENDDATE", endDate);
		map.put("v_MANAGERID", managerID);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.pollEditOkUpdateManager(map);
		ezCommunityDAO.pollEditOkUpdateQuestion(map);
	}
	
	public void adminLogoOkUpdate1(String logoFileNameLogo, String logoFileNameThumbnail, String fileName, int tenantID) throws Exception {
		logger.debug("adminLogoOkUpdate1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LOGOFILENAME", logoFileNameLogo);
		map.put("v_LOGOFILENAME_THUMBNAIL", logoFileNameThumbnail);
		map.put("v_FILENAME",  fileName);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.adminLogoOkUpdate1(map);
		
		logger.debug("adminLogoOkUpdate1 ended.");
	}
	
	public void adminCommType(String copType, String fileName, int tenantID) throws Exception {
		logger.debug("adminCommType started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COPTYPE", copType);
		map.put("v_FILENAME", fileName);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.adminCommType(map);
		
		logger.debug("adminCommType ended.");
	}
	
	//TODO 미사용
	/*public void adminLogoOkUpdate2(String bannerFileName, String fileName, int tenantID) throws Exception {
		logger.debug("adminLogoOkUpdate2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BANNERFILENAME", bannerFileName);
		map.put("v_FILENAME", fileName);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.adminLoGoOkUpdate2(map);
		
		logger.debug("adminLogoOkUpdate2 ended.");
	}*/

	public void copyFiles(String pOrgItemID, String pOrgBoardID, String pDestItemID, String pDestBoardID, String pRef) throws Exception {
        String orgFilePath = pRef + pOrgBoardID + commonUtil.separator + "doc" + commonUtil.separator + pOrgItemID + ".mht";
        String destFilePath = pRef + pDestBoardID + commonUtil.separator + "doc" + commonUtil.separator + pDestItemID + ".mht";

        File destdir = new File(pRef + pDestBoardID);
        if (!destdir.exists()) {
        	destdir.mkdir();
        	File destdir1 = new File(pRef + pDestBoardID + commonUtil.separator + "doc");
        	destdir1.mkdir();
        	File destdir2 = new File(pRef + pDestBoardID + commonUtil.separator + "uploadFile");
        	destdir2.mkdir();
        }
        
        File orgFile = new File(orgFilePath);
        File destFile = new File(destFilePath);
        
        FileCopyUtils.copy(orgFile, destFile);
	}
	
	public void copyAttachments(String pOrgFilePath, String pDestFilePath, String pDestBoardID, String pRef) throws Exception {
        String orgFilePath = pRef + pOrgFilePath;
        String destFilePath = pRef + pDestFilePath;

        File destdir = new File(pRef + pDestBoardID);
        if (!destdir.exists()) {
        	destdir.mkdir();
        	File destdir1 = new File(pRef + pDestBoardID + commonUtil.separator + "doc");
        	destdir1.mkdir();
        	File destdir2 = new File(pRef + pDestBoardID + commonUtil.separator + "uploadFile");
        	destdir2.mkdir();
        }
        
        File orgFile = new File(orgFilePath);
        File destFile = new File(destFilePath);
        
        FileCopyUtils.copy(orgFile, destFile);
	}

	@Override
	public String adminLogoUpload(String code, String realPath, String logoPath, MultipartFile logoFile, int tenantId) throws Exception {
		String oriFileName = logoFile.getOriginalFilename();
		String logoFileName = code + "_logo_Temp" + oriFileName.substring(oriFileName.lastIndexOf("."));
		
		File logoDir = new File(realPath + commonUtil.separator + logoPath);
		File logo = new File(realPath + commonUtil.separator + logoPath + commonUtil.separator + logoFileName);
		
		String result = "";
		try {
			if (!logoDir.isDirectory()) {
				boolean _flag = logoDir.mkdirs();
				if (!_flag) {
				    throw new IOException("Directory creation Failed ");
				}
			}
			
			logoFile.transferTo(logo);
			
			result = logoFileName;
		} catch (IOException e) {
			logger.error(e.getMessage());
		}
		
		return result;
	}
	
	@Override
	public void joinOkSendMail(String loginCookie, LoginVO userInfo, CommunityClubVO clubVO) throws Exception {
		logger.debug("joinOkSendMail started.");
		
		int tenantID = userInfo.getTenantId();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", clubVO.getC_ClubNo());
		map.put("tenantID", tenantID);
		
		String clubMasterID = ezCommunityDAO.joinOkSendMailGet1(map);
		
		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.put("clubMasterID", clubMasterID);
		map2.put("v_userInfo_lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		map2.put("tenantID", tenantID);
		
		LoginVO vo = ezCommunityDAO.joinOkSendMailGet2(map2);
		
		if (vo.getEmail() != null) {
			String subject = "";
			String bodyContent = "<DIV id=\"msgBody\" style=\"FONT-SIZE: 10pt; FONT-FAMILY: gulim,arial,verdana\" name=\"urn:schemas:httpmail:textdescription\">";
			if (clubVO.getC_ClubConfirmType().equals("3")) {
				subject = "[" + clubVO.getC_ClubName() + "]Community" + egovMessageSource.getMessage("ezCommunity.t720", userInfo.getLocale()) + userInfo.getDisplayName() + " " + egovMessageSource.getMessage("ezCommunity.t1531", userInfo.getLocale());
				bodyContent += "[" + clubVO.getC_ClubName() + "]Community" + egovMessageSource.getMessage("ezCommunity.t720", userInfo.getLocale()) + userInfo.getDisplayName() + "[" + userInfo.getDeptName() + "] " + egovMessageSource.getMessage("ezCommunity.t1531", userInfo.getLocale());
				bodyContent += "<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t1533", userInfo.getLocale());
			} else {
				subject = "[" + clubVO.getC_ClubName() + "]Community" + egovMessageSource.getMessage("ezCommunity.t720", userInfo.getLocale()) + userInfo.getDisplayName() + " " + egovMessageSource.getMessage("ezCommunity.t1532", userInfo.getLocale());
				bodyContent += "[" + clubVO.getC_ClubName() + "]Community" + egovMessageSource.getMessage("ezCommunity.t720", userInfo.getLocale()) + userInfo.getDisplayName() + "[" + userInfo.getDeptName() + "] " + egovMessageSource.getMessage("ezCommunity.t1532", userInfo.getLocale());
			}
        	
        	bodyContent += "</DIV>";
        
        	InternetAddress from = new InternetAddress();
        	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
        	from.setAddress(userInfo.getEmail());
        	
        	InternetAddress to = new InternetAddress();
        	to.setPersonal(vo.getDisplayName(), "UTF-8");
        	to.setAddress(vo.getEmail());
        	
        	logger.debug("from = " + userInfo.getEmail());
        	logger.debug("to = " + vo.getEmail());
        	ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, bodyContent.toString(), false);
        }
		
		logger.debug("joinOkSendMail ended.");
	}
	
	public void commOutOkSendMail(String loginCookie, LoginVO userInfo, String code, String reason) throws Exception {
		logger.debug("commOutOkSendMail started.");
		
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("v_code", code);
        map.put("v_userInfo_lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
        map.put("tenantID", userInfo.getTenantId());
        
        CommunityClubVO vo = ezCommunityDAO.commOutOkGet2(map);
        
        if (vo.getEmail() != null) {
        	String subject = "[" + vo.getC_ClubName() + "]Community" + egovMessageSource.getMessage("ezCommunity.t720", userInfo.getLocale()) + userInfo.getDisplayName() + " " + egovMessageSource.getMessage("ezCommunity.t722", userInfo.getLocale());
        	String bodyContent = "[" + vo.getC_ClubName() + "]" + egovMessageSource.getMessage("ezCommunity.t720", userInfo.getLocale()) + userInfo.getDisplayName() + " " + egovMessageSource.getMessage("ezCommunity.t587", userInfo.getLocale()) + "< " + reason + " > " + egovMessageSource.getMessage("ezCommunity.t721", userInfo.getLocale());
        
        	InternetAddress from = new InternetAddress();
        	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
        	from.setAddress(userInfo.getEmail());
        	
        	InternetAddress to = new InternetAddress();
        	to.setPersonal(vo.getUserName(), "UTF-8");
        	to.setAddress(vo.getEmail());
        	
        	ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, bodyContent.toString(), false);
        }
        
        logger.debug("commOutOkSendMail ended.");
	}
	
	@Override
	public String getContentInfo(String type, String itemID, int tenantID) throws Exception {
		logger.debug("getContentInfo started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PTYPE", type);
		map.put("v_PID", itemID);
		map.put("tenantID", tenantID);
		
		logger.debug("getContentInfo ended.");
		
		String result = ezCommunityDAO.getContentInfo(map);
		
		if (type.equals("COMMUNITYNOTI")) {
			result = commonUtil.getUploadPath("upload_community.MAINBOARD", tenantID) + commonUtil.separator + result;
		}
		
		return result;
	}

	@Override
	public void okNoSetSendMail(String loginCookie, LoginVO userInfo, String flag, String code, String cID) throws Exception {
		logger.debug("okNoSetSendMail started.");
		
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("v_CODE", code);
        map.put("v_USERINFO_LANG", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
        map.put("tenantID", userInfo.getTenantId());
        
        CommunityClubVO cvo = ezCommunityDAO.getCClubName(map);
        OrganUserVO uvo = ezOrganAdminService.getUserInfo(cID, userInfo.getPrimary(), userInfo.getTenantId());
        logger.debug("C_ClubName=" + cvo.getC_ClubName() + ", email=" + uvo.getMail());
        
        if (uvo.getMail() != null) {
        	String subName = egovMessageSource.getMessage("ezCommunity.t1534", userInfo.getLocale());
            String bodyName = egovMessageSource.getMessage("ezCommunity.t1536", userInfo.getLocale());
            
            if (flag.toUpperCase().equals("NO")) {
            	subName = egovMessageSource.getMessage("ezCommunity.t1535", userInfo.getLocale());
            	bodyName = egovMessageSource.getMessage("ezCommunity.t1537", userInfo.getLocale());
            }
        	
        	String subject = "[" + cvo.getC_ClubName() + "] " + subName;
        	
        	String bodyContent = "<DIV id=\"msgBody\" style=\"FONT-SIZE: 10pt; FONT-FAMILY: gulim,arial,verdana\" name=\"urn:schemas:httpmail:textdescription\">";
        	bodyContent = bodyContent + "[" + cvo.getC_ClubName() + "] " + bodyName;
        	bodyContent = bodyContent + "</DIV>";
        	
        	InternetAddress from = new InternetAddress();
        	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
        	from.setAddress(userInfo.getEmail());
        	
        	InternetAddress to = new InternetAddress();
        	to.setPersonal(uvo.getDisplayName(), "UTF-8");
        	to.setAddress(uvo.getMail());
        	
        	ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, bodyContent.toString(), false);
        }
        
        logger.debug("okNoSetSendMail ended.");
	}
	
	
}
