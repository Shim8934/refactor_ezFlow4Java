package egovframework.ezEKP.ezCommunity.service.impl;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.FileVisitResult;
import java.nio.file.FileVisitor;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.attribute.BasicFileAttributes;
import java.security.PrivateKey;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;
import java.util.Collections;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.util.Strings;
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
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardDeleteItemVO;
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
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubGuestReplyVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMemberGradeVO;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezNotification.service.EzNotificationService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.type.NotiPlatform;
import egovframework.ezEKP.ezPersonal.type.NotiType;
import egovframework.ezEKP.ezConn.util.EzConnUtil;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

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
	private EzNotificationService ezNotificationService;
	
	@Autowired
	private EgovFileScrty egovFileScrty;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzPersonalService ezPersonalService;
	
	@Autowired
	private EzConnUtil ezConnUtil;

	private static final Logger logger = LoggerFactory.getLogger(EzCommunityServiceImpl.class);
	
	/* 2018-06-21 홍승비 - 자신이 가입한 커뮤니티 리스트 좌측표출 companyID 조건 추가 */
	@Override
	public String leftCommunityGet2(String code, String companyID, int tenantID) throws Exception {
		logger.debug("leftCommunityGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.leftCommunityGet2(map);
		
		logger.debug("leftCommunityGet2 ended.");
		
		return result;
	}

	/* 2018-06-21 홍승비 - 자신이 가입한 커뮤니티 리스트 좌측표출 companyID 조건 추가 */
	@Override
	public CommunityClubVO leftCommunityGet4(String code, String companyID, int tenantID) throws Exception {
		logger.debug("leftCommunityGet4 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		CommunityClubVO vo = ezCommunityDAO.leftCommunityGet4(map);
		
		logger.debug("leftCommunityGet4 ended.");
		
		return vo;
	}

	/* 2018-06-21 홍승비 - 자신이 가입한 커뮤니티 리스트 좌측표출 companyID 조건 추가 */
	@Override
	public List<CommunityClubVO> getLeftCommunity(LoginVO userInfo, String sortByClubno) throws Exception {
		logger.debug("getLeftCommunity started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userInfo.getId());
		map.put("companyID", userInfo.getCompanyID());
		map.put("tenantID", userInfo.getTenantId());
		map.put("v_SORTBYCLUBNO", sortByClubno); // clubno 칼럼으로 정렬하는지 여부
		
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
            String logoTemp = commonUtil.detectPathTraversal(onlyFileName + "_logoTemp" + "." + ext);
            String logoFileName = commonUtil.detectPathTraversal(code + "_logo" + ".png");
            String logoThumbnailFileName = commonUtil.detectPathTraversal(code + "_thumbnail" + ".png");
            logoPath = commonUtil.detectPathTraversal(logoPath);
            
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
    			
    			File newThumbnail = new File(commonUtil.detectPathTraversal(logoPath + logoThumbnailFileName));
    			ImageIO.write(outputImage, "png", newThumbnail);
            } catch (Exception e) {
            	throw e;
            } finally {
				// 2023-05-15 이사라 : NullPointerException 시큐어코딩
				// fos.close();
				IOUtils.closeQuietly(fos);
            	file.delete();
            }
        }
		
		logger.debug("commMakeUpload ended.");
	}

	@Override
	public void commMakeOk(LoginVO userInfo, CommunityClubVO clubVO, MultipartHttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("commMakeOk started.");
		
		String clubName2 = "";
		MultipartFile cClubLogo = null, cClubThumb = null;
		String cCateA = "", cCateB = "", cCateC = "";

		String clubName = request.getParameter("hiddenClubName");
		String clubType = request.getParameter("clubType");
		String clubConfirmType = request.getParameter("clubConfirmType");
		String intro = request.getParameter("intro");
		String pNewID = request.getParameter("sNewID");
		String pNewSubID = request.getParameter("sNewSubID");
		String logoPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_community.LOGO", userInfo.getTenantId()) + commonUtil.separator;
		String logo = "default_logo_type5.png";
		String thumb = "default_logo_empty.png";
		logoPath = commonUtil.detectPathTraversal(logoPath);
		
		//logger.debug("logoPath 		::		 " + logoPath);
			
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
		if (request.getFile("thumb") != null) {
			cClubThumb = request.getFile("thumb");
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
			/* 2018-05-16 홍승비 - 경고메세지 처리를 jsp 내부에서 보이도록 하기 위해 수정 */
			response.getWriter().write("</script>");
			response.getWriter().flush();
			
			return;
		}
		
		// 동일 테넌트 내부에서, companyID의 비교 작업은 필요하지 않다.(boardno 등은 테넌트 공통으로 증가하는 고유 PRI Key이므로)
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
				
		/* 2018-05-02 홍승비 - 로고, 썸네일 저장 로직 통합 */
		String attachFile = "";
		String onlyFileName = "";
		String extName = "";
		int logoFileSize = 0;
		int thumbFileSize = 0;
		int iStart = 0;
		
		//logger.debug("" + cClubLogo);
		if (cClubLogo != null && !cClubLogo.isEmpty()) {
			attachFile = cClubLogo.getOriginalFilename();
			logoFileSize = (int) cClubLogo.getSize();
			onlyFileName = attachFile;
			iStart = onlyFileName.lastIndexOf(".");
			extName = onlyFileName.substring(iStart);
			
			if (!new File(logoPath).exists()) {
				new File(logoPath).mkdirs();
			}
			
			File file = new File(commonUtil.detectPathTraversal(logoPath + code + "_logo." + extName));
			cClubLogo.transferTo(file);
			
			BufferedImage inputImage = ImageIO.read(file);
			BufferedImage outputImage = null;
			Graphics2D saveImage = null;			
			outputImage= new BufferedImage(894, 100, BufferedImage.TYPE_INT_RGB);
			saveImage = outputImage.createGraphics();
			saveImage.drawImage(inputImage, 0, 0, 894, 100, null);
			
			File newLogo = new File(commonUtil.detectPathTraversal(logoPath + code + "_logo.png"));
			ImageIO.write(outputImage, "png", newLogo);			
			file.delete();

			logo = code + "_logo.png";
		}
		
		//TODO 2016-05-03 이효진 뷰에서 banner을 사용하지 않아서 파라미터로 받지 않는다.
		// 2018-04-11 홍승비 thumbnail을 로고와 분리하여 대표 이미지로 사용한다.
		if (cClubThumb != null && !cClubThumb.isEmpty()) {
			attachFile = cClubThumb.getOriginalFilename();
			thumbFileSize = (int) cClubThumb.getSize();
			onlyFileName = attachFile;
			iStart = onlyFileName.lastIndexOf(".");
			extName = onlyFileName.substring(iStart);
			
			if (!new File(logoPath).exists()) {
				new File(logoPath).mkdirs();
			}
			
			File file = new File(commonUtil.detectPathTraversal(logoPath + code + "_thumbnail." + extName));
			cClubThumb.transferTo(file);
			
			BufferedImage inputImage = ImageIO.read(file);
			BufferedImage outputImage = null;
			Graphics2D saveImage = null;			
			outputImage= new BufferedImage(198, 140, BufferedImage.TYPE_INT_RGB);
			saveImage = outputImage.createGraphics();
			saveImage.drawImage(inputImage, 0, 0, 198, 140, null);
			
			File newThumbnail = new File(commonUtil.detectPathTraversal(logoPath + code + "_thumbnail.png"));
			ImageIO.write(outputImage, "png", newThumbnail);			
			file.delete();
			
			thumb = code + "_thumbnail.png";
		}
		
		/* 2019-12-23 홍승비 - 커뮤니티 생성 시, 시스템의 멀티언어(메인, 서브)에 따라 기본생성 게시판명 다국어 처리 */
		String langPrimary = ezCommonService.getTenantConfig("LangPrimary2", userInfo.getTenantId());
		String langSecondary = ezCommonService.getTenantConfig("LangSecondary2", userInfo.getTenantId());
		String boardGroupName1 = "";
		String boardGroupName2 = "";
		String boardNotiName1 = "";
		String boardNotiName2 = "";
		
		if (langPrimary.equalsIgnoreCase("Korean")) {
			boardGroupName1 = bBoardName[1];
			boardNotiName1 = bNotiName[1];
		} else if (langPrimary.equalsIgnoreCase("English")) {
			boardGroupName1 = bBoardName[2];
			boardNotiName1 = bNotiName[2];
		} else if (langPrimary.equalsIgnoreCase("Japanese")) {
			boardGroupName1 = bBoardName[3];
			boardNotiName1 = bNotiName[3];
		} else { // 현재 중국어는 대응되지 않으나 임시로 else문 설정
			boardGroupName1 = bBoardName[4];
			boardNotiName1 = bNotiName[4];
		}
		
		if (langSecondary.equalsIgnoreCase("Korean")) {
			boardGroupName2 = bBoardName[1];
			boardNotiName2 = bNotiName[1];
		} else if (langSecondary.equalsIgnoreCase("English")) {
			boardGroupName2 = bBoardName[2];
			boardNotiName2 = bNotiName[2];
		} else if (langSecondary.equalsIgnoreCase("Japanese")) {
			boardGroupName2 = bBoardName[3];
			boardNotiName2 = bNotiName[3];
		} else { // 현재 중국어는 대응되지 않으나 임시로 else문 설정
			boardGroupName2 = bBoardName[4];
			boardNotiName2 = bNotiName[4];
		}
		
		commMakeOkInsert2(clubNo, clubName, clubName2, cCateA, cCateB, cCateC, clubType, clubConfirmType, intro, isIn, logo, thumb, boardGroupName1.trim(), boardGroupName2.trim(), comatt, code, boardNotiName1.trim(), boardNotiName2.trim(), pNewID, boardNo, userInfo.getId(), userInfo.getDisplayName1(), userInfo.getCompanyName1(), userInfo.getDeptName1(), pNewSubID, openEmail, openHp, openComp, openHouse, openJob, openBirth, openSex, userInfo.getCompanyID(), tenantID);
		/* 커뮤니티 테이블 삽입 후 tbl_logo_size에도 사이즈 넣어주기 */
		commMakeOkSet1(logoFileSize, thumbFileSize, code, tenantID);
		
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
		
		if (clubVO == null) {
			response.getWriter().write("<script language='javascript'>\n");
			response.getWriter().write("alert('" + egovMessageSource.getMessage("ezCommunity.t1529", userInfo.getLocale()) + egovMessageSource.getMessage("ezCommunity.t1027", userInfo.getLocale()) + "');\n");
			response.getWriter().write("window.close();");
			response.getWriter().write("parent.window.close();");
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
		
		// 18-05-08 김민성 - 커뮤니티 회원수 수정
		clubVO.setC_MemberCnt(commViewMemberGet2(clubVO.getC_ClubNo().trim(), userInfo.getPrimary(), "", "", userInfo.getCompanyID(), userInfo.getTenantId(), "", "", userInfo.getOffset()));
		
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
		//logger.debug("code : " + code + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		List<CommunityBoardInfoVO> boardInfoList = ezCommunityDAO.copHomeBoardGet(map);
		
		//logger.debug("boardInfoList size : " + boardInfoList.size());
		logger.debug("commHomeBoardInfo ended.");
		
		return boardInfoList;
	}
	
	/* 2018-05-18 홍승비 - UTC시간에 offset을 적용한 writeDate를 가져오기 위해 offset 추가*/
	@Override
	public List<CommunityBoardItemVO> commHomeBoardItemList(String boardID, int tenantID, String offset) throws Exception {
		logger.debug("commHomeBoardItemList started.");
		//logger.debug("boardID : " + boardID + ", tenantID : " + tenantID + ", now : " + commonUtil.getTodayUTCTime(""));
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardID);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		map.put("offset", offset);
		
		List<CommunityBoardItemVO> boardItemList = ezCommunityDAO.copHomeBoardItemGet(map);
		
		//logger.debug("boardItemList.size : " + boardItemList.size());
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
			
			int pStartRow = Math.addExact(Math.multiplyExact(Math.subtractExact(pPage, 1), boardInfo.getSs_Board_MaxRows()), 1);
			int pEndRow = Math.multiplyExact(pPage, boardInfo.getSs_Board_MaxRows());
			
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
                strXML = strXML.replace("\\", "&#92;"); // 특수문자 변환 '\' -> $#92; 2018-02-19 천성준
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
	public void newBoardItem(CommunityBoardItemVO item, CommunityBoardPropertyVO boardInfo, LoginVO userInfo, String pItemID, String pBoardID, String pUrl, String pMode, String expireDays, Model model) throws Exception {
		String strWriterFakeName = "";
		String startDateTime = "";
		logger.debug("newBoardItem started.");
		logger.debug("pMode = " + pMode);
		logger.debug("item.getItemLevel() = " + item.getItemLevel());
		
		if (!pUrl.equals("")) {
			startDateTime = item.getStartDate();
			item.setStartDate(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false));
			item.setEndDate(commonUtil.getDateStringInUTC(EgovDateUtil.addDay(commonUtil.getTodayUTCTime(""), 30, "yyyy-MM-dd HH:mm:ss"), userInfo.getOffset(), false));
			expireDays = "-1";
		} else {
			if (userInfo.getLang().equals("2")) {
				item.setBoardName(boardInfo.getBoardName2());
			} else {
				item.setBoardName(boardInfo.getBoardName());
			}
			
			startDateTime = item.getStartDate();
			expireDays = boardInfo.getExpireDays();
			if (pMode.equals("new")) {
				if (expireDays.equals("-1")) {
                    item.setEndDate(commonUtil.getDateStringInUTC(EgovDateUtil.addDay(commonUtil.getTodayUTCTime(""), 30, "yyyy-MM-dd HH:mm:ss"), userInfo.getOffset(), false));
                } else {
                    item.setEndDate(commonUtil.getDateStringInUTC(EgovDateUtil.addDay(commonUtil.getTodayUTCTime(""), Integer.parseInt(expireDays), "yyyy-MM-dd HH:mm:ss"), userInfo.getOffset(), false));
                }
			} else {
				item = getItemXML(pBoardID, pItemID, userInfo);
				
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
                    	item.setEndDate(item.getEndDate());
                    }
                	
                	if (boardInfo.getGubun() != null) {
	                	if (boardInfo.getGubun().equals("2")) {
	                		strWriterFakeName = item.getWriterName();
	                	}
                	}
                	
                	
                }
			}
		}
		
		ZoneId utc = ZoneId.ofOffset("UTC", ZoneOffset.of(userInfo.getOffset().split("\\|")[1]));
		ZonedDateTime getTime = ZonedDateTime.of(LocalDateTime.now(utc), utc);
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH");
		
		if (getTime.getMinute() > 30) {
			getTime = getTime.plusHours(1);
			startDateTime = getTime.format(formatter);
			startDateTime = startDateTime + ":00:00"; 
		} else {
			startDateTime = getTime.format(formatter);
			startDateTime = startDateTime + ":30:00"; 
		}
		
		logger.debug("item.getItemLevel() = " + item.getItemLevel());
		
		// 2018-02-19 천성준 : 게시글 수정,답변시 인풋박스에 특수문자 '\'가 사라지는 버그 해결로직 ['\' -> '\\']
		if(pMode.equals("modify") || pMode.equals("reply")){
			if (item.getTitle() != null && item.getTitle().contains("\\")) {
				item.setTitle(item.getTitle().replace("\\", "\\\\"));
			}
			if (item.getAbsTract() != null && item.getAbsTract().contains("\\")) {
				item.setAbsTract(item.getAbsTract().replace("\\", "\\\\"));
			}
		}
		
		model.addAttribute("item", item);
		model.addAttribute("startDateTime", startDateTime);
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
		String tempPath = pDirPath + "tempUploadFile";
		String uploadPath = pDirPath + pBoardID + commonUtil.separator + "uploadFile";
		String docPath = pDirPath + pBoardID + commonUtil.separator + "doc";
		
		pDirPath = commonUtil.detectPathTraversal(pDirPath);
		tempPath = commonUtil.detectPathTraversal(tempPath);
		uploadPath = commonUtil.detectPathTraversal(uploadPath);
		docPath = commonUtil.detectPathTraversal(docPath);
		
		File tempDir = new File(tempPath);
		
		if (!tempDir.exists()) {
			tempDir.mkdirs();
		}
		
		File boardDir = new File(commonUtil.detectPathTraversal(pDirPath + pBoardID));
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

			//pFileName =pFileName.replace("+", "%2b").replace(";", "%3b");
			int fileSize = (int) file.getSize();
			
			if (fileSize > pMaxSize) {
				resultUpload = "overflow";
			} else {
				if (pMode.equals("ATT")) {
					// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
					String extStr = pFileName.substring(pFileName.lastIndexOf(".") + 1).toString().toLowerCase();

					if ((extStr.isEmpty() || userExtension.toLowerCase().indexOf(extStr) == -1) && !userExtension.equals("*")) {
						resultUpload = "denied";
					} else {
						pAttachPath = pDirPath + "tempUploadFile" + commonUtil.separator + pUploadSN + "_" + pFileName;
						pAttachPath = commonUtil.detectPathTraversal(pAttachPath);
						File thumbnailFile = new File(pAttachPath);
						file.transferTo(thumbnailFile);
						resultUpload = "true";
					}
				} else if (pMode.equals("PHOTO")) {
					if (userExtension.toLowerCase().indexOf(pFileName.substring(pFileName.lastIndexOf(".") + 1).toString().toLowerCase()) == -1 && !userExtension.equals("*")) {
						resultUpload = "denied";
					} else {
						pAttachPath = pDirPath + "tempUploadFile" + commonUtil.separator + pUploadSN + pFileName.substring(pFileName.lastIndexOf("."));
						pAttachPath = commonUtil.detectPathTraversal(pAttachPath);
						File thumbnailFile = new File(pAttachPath);
						file.transferTo(thumbnailFile);
						
						String extension = pFileName.substring(pFileName.lastIndexOf(".") + 1, pFileName.length());
						BufferedImage inputImage = ImageIO.read(thumbnailFile);
						BufferedImage outputImage = null;
						BufferedImage outputImageS = null;
						Graphics2D saveImage = null;
						
						// 기존 이미지가 파일 형태로 업로드되었으므로, 다시 이미지 형태로 저장
						if (inputImage.getType() == 0 || extension.equals("png")) { // 일부 png 파일의 경우, type값이 0으로 넘어오거나 검은색으로 저장된다.
							outputImage = new BufferedImage(inputImage.getWidth(), inputImage.getHeight(), BufferedImage.TYPE_4BYTE_ABGR);
						} else {
							outputImage = new BufferedImage(inputImage.getWidth(), inputImage.getHeight(), inputImage.getType());
						}
						saveImage = outputImage.createGraphics();
						saveImage.drawImage(inputImage, 0, 0, inputImage.getWidth(), inputImage.getHeight(), null);
						
						String tempFilaPath = pDirPath + "tempUploadFile" + commonUtil.separator + pUploadSN + pFileName.substring(pFileName.lastIndexOf("."));
						tempFilaPath = commonUtil.detectPathTraversal(tempFilaPath);
						
						File tempFile = new File(tempFilaPath);
						ImageIO.write(outputImage, "png", tempFile);
						
						// 썸네일 생성
						if (inputImage.getType() == 0 || extension.equals("png")) {
							outputImageS = new BufferedImage(100, 100, BufferedImage.TYPE_4BYTE_ABGR);
						} else {
							outputImageS = new BufferedImage(100, 100, inputImage.getType());
						}
						saveImage = outputImageS.createGraphics();
						saveImage.drawImage(inputImage, 0, 0, 100, 100, null);
						
						String tempThumbFilaPath = pDirPath + "tempUploadFile" + commonUtil.separator + "s_" + pUploadSN + pFileName.substring(pFileName.lastIndexOf("."));
						tempThumbFilaPath = commonUtil.detectPathTraversal(tempThumbFilaPath);
						
						File tempTumbbail = new File(tempThumbFilaPath);
						ImageIO.write(outputImageS, "png", tempTumbbail);
						
						inputImage.flush();
						inputImage = null;
						outputImage.flush();
						outputImage = null;
						outputImageS.flush();
						outputImageS = null;
						
						resultUpload = "true";
					}
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
            
            if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;k")) {
            	cAdmin = "admin";
            }
            
            // boardInfo.setBoardGroupAdmin_FG(checkIfBoardGroupAdmin(pBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getTenantId()));
            
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
	public String pollMain(LoginVO userInfo, String code, String pollAdmin) throws Exception {
		logger.debug("pollMain started.");
		
		String pollState = "", pollManager = "";
		String offset = userInfo.getOffset();
		StringBuilder sb = new StringBuilder();
		
		logger.debug("pollMainGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", userInfo.getTenantId());
		
		List<CommunityCPollManagerVO> list = ezCommunityDAO.pollMainGet2(map);
		//logger.debug("pollMainGet2 ended. size : " + list.size());
		
		String dateStr = commonUtil.getTodayUTCTime("");
		//logger.debug("userCurrentTime=" + dateStr);
		
		/* 2018-05-08 홍승비 - 커뮤니티 관리자의 설문조사 테이블 > 관리TD의 모든 버튼 활성 */
		String sysopID = ezCommunityDAO.adminMemberListGet2(map);
		//logger.debug("sysopID=" + sysopID);
		
		/* 2018-05-10 홍승비 - 커뮤니티 설문조사 예정, 진행중, 완료 조건 비교 수정(년-월-일 시:분:초 단위까지 전부 비교) */
		for (CommunityCPollManagerVO item : list) {
			if (dateStr.compareTo(item.getPollStartDate().substring(0, 19)) < 0) {
				pollState = egovMessageSource.getMessage("ezCommunity.t677", userInfo.getLocale());
				pollManager = egovMessageSource.getMessage("ezCommunity.t678", userInfo.getLocale());
			} else {
				if (dateStr.compareTo(item.getPollStartDate().substring(0, 19)) >= 0 && dateStr.compareTo(item.getPollEndDate().substring(0, 19)) <= 0) {
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
			/* 2018-05-07 홍승비 - 커뮤니티 설문조사 체크박스 사용 (삭제를 위한 해당설문ID, 등록자ID, 커뮤니티ID) */
			sb.append("<td><input type=\"checkbox\" id=\"" + item.getManagerID()+ ";\" pollRegID=\"" + item.getPollRegUser() + "\" clubNo=\"" + item.getC_clubNo() + "\"/></td>");			
			sb.append("<td style=\"text-overflow:ellipsis;overflow:hidden;white-space:nowrap;\" title=\"" + commonUtil.cleanValue(item.getPollSubject()).replaceAll("\\\\", "&#92;") + "\">");
			sb.append("<a style = \"cursor:pointer\" onclick=movepage(\"" + code + "\",\"" + item.getManagerID() + "\",\"" + pollState.replaceAll(" ", "&nbsp;") + "\")>" + commonUtil.cleanValue(item.getPollSubject()).replaceAll("\\\\", "&#92;") + "</a></td>");
			sb.append("<td>" + commonUtil.getDateStringInUTC(item.getPollStartDate().substring(0,19), offset, false).substring(0, 10) + " ~ " + commonUtil.getDateStringInUTC(item.getPollEndDate().substring(0,19), offset, false).substring(0, 10) + "</td>");
			sb.append("<td>" + strResponseCnt + egovMessageSource.getMessage("ezCommunity.t478", userInfo.getLocale()) + "</td>");
			sb.append("<td>" + pollState + "</td>");
			sb.append("<td>");
			
			if (item.getPollRegUser().equals(userInfo.getId()) || sysopID.trim().equals(userInfo.getId()) || pollAdmin.equals("true")) {
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
			//2018-07-11 김보미 - 화살표 이미지 제거(background: none 추가)
			//sb.append("<select size=\"5\" style=\"Width:100%; Height:160px\" id=select1 name=select1>");
			sb.append("<select size=\"5\" style=\"Width:100%; Height:160px; background: none\" id=select1 name=select1>");			
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
						sb.append("<span style=\"display:inline-block; width:30px;\">"+ i + ". </span><input class='inputText' style='width:90%;margin:3px;height:20px' type= \"text\" size=\"80\" name = \"selNo_" + i + "\" maxlength=\"200\"><br>");
					}
					
					answerCount = Integer.parseInt(selRes);
				} else {
					selectedNo = 9;
					
					for(int i=1; i <= Integer.parseInt(selRes) - 1; i++) {
						sb.append("<span style=\"display:inline-block; width:30px;\">"+ i + ". </span><input class='inputText' style='width:90%;margin:3px;height:20px' type= \"text\" size=\"80\" name = \"selNo_" + i + "\" maxlength=\"200\"><br>");
					}
					
					answerCount = Integer.parseInt(selRes);
					sb.append(selRes + ". " + egovMessageSource.getMessage("ezCommunity.t627", userInfo.getLocale()));
				}
			} else {
				if (selType.equals("3")) {
					answerCount = 1;
					selectedNo = 10;
					sb.append(egovMessageSource.getMessage("ezCommunity.t603", userInfo.getLocale()));
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
		String subject = request.getParameter("pollSubject");//.replaceAll("\r\n", " ");
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

		//logger.debug("startDate : " + startDate);
		//logger.debug("endDate : " + endDate);
		
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		endDate = commonUtil.getDateStringInUTC(endDate, offset, true);
		
		//logger.debug("UTCstartDate : " + startDate);
		//logger.debug("UTCendDate : " + endDate);
		
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
		response.getWriter().write("document.location.href = '/ezCommunity/pollMain.do?code=" + commonUtil.stripScriptTags(code) + "';\n");
		response.getWriter().write("</script>");	
		response.getWriter().flush();
	}

	@Override
	public void pollDelete(LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String code = request.getParameter("code");
		/* 2018-05-08 홍승비 - 설문 여러개 삭제를 위해 managerID 배열변경*/
		String managerID[] = request.getParameter("managerID").split(";");
		int tenantID = userInfo.getTenantId();
		
		logger.debug("pollDelete started.");
		logger.debug("pollDeleteGet1 started.");
		
		for(int i=0; i<managerID.length; i++) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_MANAGERID", managerID[i]);
			map.put("tenantID", tenantID);			
			
			String strRegUser = ezCommunityDAO.pollDeleteGet1(map).trim();
			logger.debug("pollDeleteGet1 ended. strRegUser=" + strRegUser);
			
			/* 2018-05-10 홍승비 - 삭제권한검사는 jsp(스크립트)에서 먼저 처리하도록 수정 */
			if (strRegUser != null) {				
				Map<String, Object> map1 = new HashMap<String, Object>();
				map1.put("v_CODE", code);
				map1.put("tenantID", tenantID);

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
						//logger.debug("getQuestionID="+ question.getQuestionID() + " || getAnswerID=" + answer.getAnswerID());
						pollDeleteDel1(question.getQuestionID(), answer.getAnswerID(), tenantID);
					}
					
					pollDeleteDel2(question.getQuestionID(), tenantID);
				}
				
				pollDeleteDel3(managerID[i], tenantID);
			}
		}
		
		logger.debug("pollDelete ended.");
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		response.getWriter().write("<script language='javascript'>\n");
		response.getWriter().write("document.location.href = '/ezCommunity/pollMain.do?code=" + commonUtil.stripScriptTags(code) + "';\n");
		response.getWriter().write("</script>");
		response.getWriter().flush();
	}
	
	/* 2018-06-22 홍승비 - 사간겸직 회원의 설문조사 표출 시 companyID 조건 추가 */
	@Override
	public void pollRes(LoginVO userInfo, Model model, String pollManagerID, String pollState, HttpServletResponse response) throws Exception {
		logger.debug("pollRes started.");
		
		int isSave = 0;
		int responseCount = 0;
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
						sb.append("<tr style='height:25px'><td class=\"t2\" width=\"50\" align=\"center\">");
						sb.append("<input type=\"radio\" name=pollSelect_" + questionVO.getQuestionNo() + " value=" + answerVO.getAnswerNo());
						
						if (isSave == 1) {
							if (answerVO.getAnswerNo().equals(Integer.toString(responseVO.getAnswerNo()))) {
								sb.append(" checked");
							}
						}
						
						sb.append("></td>");
						sb.append("<td class=\"t2\">" + commonUtil.cleanValue(answerVO.getAnswerContent()) + "</td>");
						
						/* 2018-05-09 홍승비 - 커뮤니티 설문조사 이미지 대신 색깔 그래프로 표현 */
						responseCount = pollResGetCount(questionVO.getQuestionID(), answerVO.getAnswerID(), tenantID);
						int percent = 0;
						int percentRev = 0;
						
						if (allResponseCount != 0) {
							percent =  (int) ((double) responseCount / allResponseCount * 100);
						}
						
						percentRev = 100 - percent;

						sb.append("<td class=\"t2\" align=\"center\" width=\"60\">[" + responseCount + "/" + allResponseCount + "]</td>");
						sb.append("<td class=\"t2\" align=\"center\" width=\"60\">[" + percent + "%]</td>");
						sb.append("<td class=\"t2\" align=\"left\" width=\"180\">");
						sb.append("<div class=\"graphback\">");
						sb.append("<p class=\"graphbar\"");
						
						if (percent == 0) {
							sb.append("style=\"margin-right:" + percentRev + "%; border-left:0;border-right:0;\"></p></div></td>");
						} else {
							sb.append("style=\"margin-right:" + percentRev + "%;\"></p></div></td>");
						}

						sb.append("</tr>");

						break;
					case 2 :
						sb.append("<tr style='height:25px'><td class=\"t2\" width=\"50\" align=\"center\">");
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
						
						percentRev = 100 - percent;

						sb.append("<td class=\"t2\" align=\"center\" width=\"60\">[" + responseCount + "/" + allResponseCount + "]</td>");
						sb.append("<td class=\"t2\" align=\"center\" width=\"60\">[" + percent + "%]</td>");
						sb.append("<td class=\"t2\" align=\"left\" width=\"180\">");
						sb.append("<div class=\"graphback\">");
						sb.append("<p class=\"graphbar\"");
						
						if (percent == 0) {
                            sb.append("style=\"margin-right:" + percentRev + "%;border-left:0;border-right:0;\"></p></div></td></tr>");
                        } else {
                        	sb.append("style=\"margin-right:" + percentRev + "%;\"></p></div></td></tr>");
                        }
						
						break;
					case 3 :
						sb.append("<tr style='height:25px'><td colspan=\"5\" style=\"padding-left:10px\">" + commonUtil.cleanValue(answerVO.getAnswerContent()) + ": <input type=\"text\" name=\"answerETC\" style=\"width:545px\">");
						sb.append("<input type=hidden name=pollSelect_" + questionVO.getQuestionNo() + ">&nbsp;<a href=\"javascript:etcview('" + egovMessageSource.getMessage("ezCommunity.t207", userInfo.getLocale()) + "', '" + questionVO.getQuestionID() + "' );\" class=\"imgbtn\" ><span>" + egovMessageSource.getMessage("ezCommunity.t689", userInfo.getLocale()) + "</span></a>");
						sb.append("</td>");
						sb.append("</tr>");
						
						break;
				}
			}
		}
		
		StringBuilder strHTML = new StringBuilder();
		
		/* 2018-06-22 홍승비 - 사간겸직 회원의 설문조사 표출 시 companyID 조건 추가 */
		String name = pollResGet4(userInfo.getPrimary(), managerVO.getPollRegUser(), userInfo.getCompanyID(), tenantID);
		
		strHTML.append("<table class=\"mainlist\"  style=\"width:100%;\" ><tr style='height:25px'>");
		
		/* 2020-05-26 홍승비 - 설문 등록자의 이름이 우측 하단으로 내려가는 경우, UI가 깨지지 않도록 이름 전체를 하단에 표출 */
		//2018-07-03 김보미 - 제목th에 너비 추가
		if (managerVO.getPollSubject().indexOf("\r\n") >= 0) {
			strHTML.append("<th align=\"left\" class='pollTitle' title = \"" + commonUtil.cleanValue(managerVO.getPollSubject()) + "\">" + egovMessageSource.getMessage("ezCommunity.t686", userInfo.getLocale()) + commonUtil.cleanValue(managerVO.getPollSubject()) + "</th>");
			strHTML.append("<th align=\"right\" class='pollWriter'><span>" + egovMessageSource.getMessage("ezCommunity.t687", userInfo.getLocale()) + "</span><div class='pollWriterName'>" + name + "</div></th>");
		} else {
			strHTML.append("<th align=\"left\" class='pollTitle' title = \"" + commonUtil.cleanValue(managerVO.getPollSubject()) + "\">" + egovMessageSource.getMessage("ezCommunity.t686", userInfo.getLocale()) + commonUtil.cleanValue(managerVO.getPollSubject()) + "</th>");
			strHTML.append("<th align=\"right\" class='pollWriter'><span>" + egovMessageSource.getMessage("ezCommunity.t687", userInfo.getLocale()) + "</span><div class='pollWriterName'>" + name + "</div></th>");
		}
		
		strHTML.append("</tr>");
		strHTML.append(sb.toString());
		strHTML.append("</table>");
		
		model.addAttribute("isSave", isSave);
		model.addAttribute("idSpanValue", strHTML.toString());
		
		logger.debug("pollRes ended.");
	}
	
	@Override
	public void pollResOk(LoginVO userInfo, String code, String questionID, String pollSelect, String answerETC, String isSave, String answerType, String answerCount, String pollManagerID, String pollState, HttpServletResponse response) throws Exception {
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
		
		/* 2020-05-07 홍승비 - pollState의 인코딩 방식 수정 (JBoss + IE 대응) */
		/* 2018-10-01 홍승비 - 설문조사 응답 후 리스트로 이동하지 않고 해당 설문조사를 유지하도록 수정 */
		if (notResponse == 0) {
			response.getWriter().write("<script language='javascript'>\n");
			//response.getWriter().write("document.location.href = '/ezCommunity/pollMain.do?code=" + code + "';\n");
			response.getWriter().write("document.location.href = '/ezCommunity/pollRes.do?code=" + commonUtil.stripScriptTags(code) + "&pollManagerID=" + commonUtil.stripScriptTags(pollManagerID)
					+ "&pollState=" + URLEncoder.encode(commonUtil.stripScriptTags(pollState), "UTF-8") + "';\n");
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
		response.getWriter().write("document.location.href = '/ezCommunity/pollMain.do?code=" + commonUtil.stripScriptTags(pClubNo) + "';\n");
		response.getWriter().write("</script>");
		response.getWriter().flush();
	}

	@Override
	public String commViewMember(LoginVO userInfo, String code, String strSysopID, String keyword, String sRadio, int comNoPerPage, int curPage, int keywordCount, int totalPage, String block, String selectGrade, String orderCell, String orderOption, String selectMonth, String startdate, String enddate) throws Exception {
		//logger.debug("code : " + code + ", strSysopID : " + strSysopID + ", keyword : " + keyword + ", sRadio : " + sRadio);
		
		StringBuilder sb = new StringBuilder();
		/* 2018-07-18 홍승비 - primary 설정 변경 */
		String primary = userInfo.getPrimary();
		
		// 여기서 회원리스트를 받아온다. CommunityCClubUserVO에 deptID, deptName 필드를 추가했다.
		List<CommunityCClubUserVO> userList = commViewMemberGet1(code, primary, keyword, sRadio, userInfo.getCompanyID(), userInfo.getTenantId(), selectGrade, orderCell, orderOption, selectMonth, userInfo.getOffset());
		
		int iOutputCount = 0;
		
		/* 2021-08-17 홍승비 - 데이터가 없는 경우 tr 추가 */
		if (userList ==  null || userList.size() == 0) {
			sb.append("<tr>");
			sb.append("<td colspan=\"10\" style=\"width:100%; height:30px; text-align:center;\">" + egovMessageSource.getMessage("ezOrgan.hdp25", userInfo.getLocale()) + "</td>");
			sb.append("</tr>");
		}
		else {
			for (CommunityCClubUserVO user : userList) {
				iOutputCount++;

				if (comNoPerPage > 0) {
					if (iOutputCount > comNoPerPage * curPage) {
						break;
					}

					if (iOutputCount <= comNoPerPage * curPage - comNoPerPage) {
						continue;
					}
				}

				CommunityMemberInfoVO memberInfo = commViewMemberGet3(user.getC_ID().trim(), user.getCompanyID(), primary, userInfo.getTenantId());
				String memGradeName = getMemberGradeName(code, user.getGrade(), user.getCompanyID(), userInfo.getTenantId());
				int itemWriteCnt = getBoardItemWriteCount(code, user.getC_ID().trim(), user.getCompanyID(), userInfo.getTenantId(), userInfo.getOffset(), startdate, enddate);
				int replyCnt = getBoardReplyCount(code, user.getC_ID().trim(), user.getCompanyID(), userInfo.getTenantId(), userInfo.getOffset(), startdate, enddate);

				List<CommunityCClubUserVO> operatorList = getClubOperatorList(userInfo.getCompanyID(), userInfo.getTenantId(), code, userInfo.getId());

				String adminAuth = "";
				if (operatorList != null && !operatorList.isEmpty() && operatorList.get(0).getAdmin_Auth() != null) {
					adminAuth = operatorList.get(0).getAdmin_Auth();
				}

				sb.append("<tr>");
				if ((strSysopID.trim().equals(userInfo.getId()) || adminAuth.contains("A")) && comNoPerPage > 0) {
					if (!"4".equals(user.getPermit()) && !user.getGrade().equals("2")) { // 마스터 및 운영자 제외한 나머지 회원들만 체크박스 표출
						sb.append("<td style=\"width:55; height:23; align:center;\"><input type=\"CHECKBOX\" id=\"checkbox" + iOutputCount + "\" class=\"selectMember\" onclick=\"selectMember('" + user.getC_ID() + "', " + iOutputCount + ");\"></input></td>");
					} else {
						sb.append("<td style=\"width:55; height:23; align:center;\"></td>");
					}
				} else {
					sb.append("<td style=\"width:55; height:23; align:center;\">" + (userList.indexOf(user) + 1) + "</td>");
				}
				sb.append("<td>");

				if (user.getC_ID().trim().equals(strSysopID)) {
					sb.append("<img style='margin-right:3px' src=\"/images/i_master.gif\" border=\"0\" alt=\"" + egovMessageSource.getMessage("ezCommunity.t513", userInfo.getLocale()) + "\" align=\"absmiddle\" WIDTH=\"15\" HEIGHT=\"9\"></img>");
				}

				// CommunityMemberInfoVO를 수정해서 부서ID를 가져오도록 하자.
				sb.append("<a href=\"javascript:openinfo1('" + code + "','" + user.getC_ID().trim() + "','" + user.getCompanyID() + "','" + user.getDeptID() + "');\" valign=\"bottom\">" + commonUtil.cleanValue(memberInfo.getUserName()) + "</a></td>");
				// 가입한 당시 겸직한 부서이름(deptName)/또는 겸직하지 않은 상태의 부서이름을 나타낸다. 쿼리 내부에서 다국어 처리한 것(case~primary)임.
				sb.append("<td>" + commonUtil.cleanValue(memGradeName) + "</td>");
				sb.append("<td>" + commonUtil.cleanValue(user.getDeptName()) + "</td>");
				sb.append("<td>" + commonUtil.cleanValue(user.getC_ID().trim()) + "</td>");
				sb.append("<td style=\"align:center\">" + itemWriteCnt + egovMessageSource.getMessage("ezCommunity.t728", userInfo.getLocale()) + "</td>");
				sb.append("<td style=\"align:center\">" + replyCnt + egovMessageSource.getMessage("ezCommunity.t728", userInfo.getLocale()) + "</td>");
				sb.append("<td style=\"align:center\">" + user.getC_visited() + egovMessageSource.getMessage("ezCommunity.t728", userInfo.getLocale()) + "</td>");
				sb.append("<td>" + user.getC_inDate().substring(0, 10) + "</td>");
				sb.append("<td>");

				if (user.getC_lastDate() != null) {
					sb.append(user.getC_lastDate().substring(0, 10));
				}
				sb.append("</td></tr>");
			}
		}

		if (comNoPerPage > 0) {
			sb.append("<ROOT><KEYWORDCOUNT>" + keywordCount + "</KEYWORDCOUNT>");
			sb.append("<TOTALPAGE>" + totalPage + "</TOTALPAGE>");
			sb.append("<CURPAGE>" + curPage + "</CURPAGE>");
			sb.append("<NOWBLOCK>" + block + "</NOWBLOCK></ROOT>");
		}
		
		return sb.toString();
	}

	/* 2018-04-30 홍승비 - 로고,썸네일,타입 통합하여 DB접근하도록 수정 */
	@Override
	public void adminLogoOk(MultipartHttpServletRequest request, int tenantID) throws Exception {
		String attachFile = "", extName = "";
		int iStart = 0;
		
		String code = request.getParameter("code");
		String copType = request.getParameter("type");
		String defaultLogo = request.getParameter("defaultLogo");
		String defaultThumb = request.getParameter("defaultThumb");
		MultipartFile logoFile = request.getFile("logo");
		MultipartFile thumbFile = request.getFile("thumb");
		String logoFileNameLogo = "";
		String logoFileNameThumbnail = "";
		
		String logoPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_community.LOGO", tenantID) + commonUtil.separator;
		logoPath = commonUtil.detectPathTraversal(logoPath);
		
		// 상단 이미지 저장
		if (!logoFile.isEmpty()) {
			attachFile = logoFile.getOriginalFilename();
			iStart = attachFile.lastIndexOf(".");
			extName = attachFile.substring(iStart);
			String logoFileName = code + "_logo_Temp." + extName;
			logoFileName = commonUtil.detectPathTraversal(logoFileName);
			
			File file = new File(logoPath + logoFileName);
			logoFile.transferTo(file);
			
			BufferedImage inputImage = ImageIO.read(file);
			BufferedImage outputImage = null;
			Graphics2D saveImage = null;
			
			outputImage= new BufferedImage(894, 100, BufferedImage.TYPE_INT_RGB);
			saveImage = outputImage.createGraphics();
			saveImage.drawImage(inputImage, 0, 0, 894, 100, null);
			
			String newLogoFilePath = logoPath + code + "_logo.png";
			newLogoFilePath = commonUtil.detectPathTraversal(newLogoFilePath);
			
			File newLogo = new File(newLogoFilePath);
			ImageIO.write(outputImage, "png", newLogo);
			logoFileNameLogo = code + "_logo.png";
			
			file.delete();
		}
		// 썸네일 저장
		if (!thumbFile.isEmpty()) {
			attachFile = thumbFile.getOriginalFilename();
			iStart = attachFile.lastIndexOf(".");
			extName = attachFile.substring(iStart);
			String thumbFileName = code + "_thumb_Temp." + extName;
			String thumbFilePath = logoPath + thumbFileName;
			thumbFilePath = commonUtil.detectPathTraversal(thumbFilePath);
			
			File file = new File(thumbFilePath);
			thumbFile.transferTo(file);
			
			BufferedImage inputImage = ImageIO.read(file);
			BufferedImage outputImage = null;
			Graphics2D saveImage = null;
			
			outputImage = new BufferedImage(198, 140, BufferedImage.TYPE_INT_RGB);
			saveImage = outputImage.createGraphics();
			saveImage.drawImage(inputImage, 0, 0, 198, 140, null);
			
			String newThumbFilePath = logoPath + code + "_thumbnail.png";
			newThumbFilePath = commonUtil.detectPathTraversal(newThumbFilePath);
			
			File newThumbnail = new File(newThumbFilePath);
			ImageIO.write(outputImage, "png", newThumbnail);
			logoFileNameThumbnail = code + "_thumbnail.png";
			
			file.delete();
		}
		
		/* 2018-05-16 홍승비 - 등록한 로고, 썸네일 이미지 삭제 기능 추가 */
		if (defaultLogo != null && !defaultLogo.equals("")) {
			logoFileNameLogo = defaultLogo;
		}
		if (defaultThumb != null && !defaultThumb.equals("")) {
			logoFileNameThumbnail = defaultThumb;
		}
		
		if (!logoFileNameLogo.equals("") || !logoFileNameThumbnail.equals("") || !copType.equals("")) {
			adminLogoOkUpdate1(logoFileNameLogo, logoFileNameThumbnail, copType, code, tenantID);
		}		
	}
	@Override
	public void adminLogoUploadIE9(String code, String copType, String imageSrc, String logoPath, String fileName, String fileData, int tenantID) throws Exception {
		int iStart = 0;
		if (fileData != null) {
			iStart = fileName.lastIndexOf(".");
			String extName = fileName.substring(iStart);
			String logoFileName = code + "_logo_Temp" + "." + extName;
			
			File file = new File(commonUtil.detectPathTraversal(logoPath + logoFileName));
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
				
				File newLogo = new File(commonUtil.detectPathTraversal(logoPath + code + "_logo" + ".png"));
				ImageIO.write(outputImage, "png", newLogo);
				String logoFileNameLogo = code + "_logo" + ".png";
				
				adminLogoOkUpdate2(logoFileNameLogo, code, tenantID);
				
	        } catch (Exception e) {
	        	throw e;
	        } finally {
				// 2023-05-15 이사라 : NullPointerException 시큐어코딩
				// fos.close();
				IOUtils.closeQuietly(fos);
	        	file.delete();
	        }
		}
		
		if (!copType.equals("")) {
			adminCommType(copType, code, tenantID);
			
			if (fileData != null) { 
				if (imageSrc.indexOf("default_logo_type") > -1) {
					adminLogoOkUpdate2("default_logo_" + copType + ".png", fileName, tenantID);
				}
			}
		}
	}
	
	public void adminThumbUploadIE9(String code, String copType, String imageSrc, String thumbPath, String fileName, String fileData, int tenantID) throws Exception {
		int iStart = 0;
		if (fileData != null) {
			iStart = fileName.lastIndexOf(".");
			String extName = fileName.substring(iStart);
			String thumbFileName = code + "_thumb_Temp" + "." + extName;
			
			File file = new File(commonUtil.detectPathTraversal(thumbPath + thumbFileName));
	        byte[] byteList = Base64.decodeBase64(fileData);
	        
	        FileOutputStream fos = null;
	        
	        try {
	        	fos = new FileOutputStream(file);
	            IOUtils.write(byteList, fos);
	            
	            BufferedImage inputImage = ImageIO.read(file);
				BufferedImage outputImage = null;
				Graphics2D saveImage = null;
				
				outputImage = new BufferedImage(198, 140, BufferedImage.TYPE_INT_RGB);
				saveImage = outputImage.createGraphics();
				saveImage.drawImage(inputImage, 0, 0, 198, 140, null);
				
				File newThumbnail = new File(commonUtil.detectPathTraversal(thumbPath + code + "_thumbnail" + ".png"));
				ImageIO.write(outputImage, "png", newThumbnail);
				String logoFileNameThumbnail = code + "_thumbnail" + ".png";

				adminLogoOkUpdate3(logoFileNameThumbnail, code, tenantID);
				
	        } catch (Exception e) {
	        	throw e;
	        } finally {
				// 2023-05-15 이사라 : NullPointerException 시큐어코딩
				// fos.close();
				IOUtils.closeQuietly(fos);
	        	file.delete();
	        }
		}
		
		if (!copType.equals("")) {
			adminCommType(copType, code, tenantID);
		}
	}

	@Override
	public String adminHomeBoard1(LoginVO userInfo, String code) throws Exception {
		StringBuilder listData = new StringBuilder();
		
		List<CommunityBoardInfoVO> boardInfoList = getBoardList(code, userInfo.getPrimary(), "ALL", userInfo.getTenantId());
		
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
		
		List<CommunityBoardInfoVO> boardInfoList2 = getBoardList(code, userInfo.getPrimary(), "LEFT", userInfo.getTenantId());
		
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
		
		List<CommunityBoardInfoVO> boardInfoList3 = getBoardList(code, userInfo.getPrimary(), "RIGHT", userInfo.getTenantId());
		
		for (CommunityBoardInfoVO boardInfo : boardInfoList3) {
			listData.append("<ROW><CELL><VALUE>");
			listData.append(commonUtil.cleanValue(boardInfo.getBoardName()));
			listData.append("</VALUE>");
			listData.append("<DATA1>" + commonUtil.cleanValue(boardInfo.getBoardID()) + "</DATA1>");
			listData.append("</CELL></ROW>");
		}
		
		return listData.toString();
	}

	/* 2018-06-22 홍승비 - 사간겸직 탈퇴희망자 companyID로 중복레코드 제거 */
	@Override
	public String adminOuterList(LoginVO userInfo, String code) throws Exception {
		logger.debug("adminOuterList started.");
		
		// companyID 조건 추가
		List<CommunityCOutApplicationVO> list = adminOuterListGet2(code, userInfo.getPrimary(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		int iCount = 1, curPage = 0;
		StringBuilder sb = new StringBuilder();
		
		for (CommunityCOutApplicationVO outApplication : list) {
			sb.append("<tr>");
            sb.append("<td height=\"23\" align=\"center\" >" + iCount + "</td>");
            sb.append("<td>" + commonUtil.cleanValue(outApplication.getUserName().trim()) + "</td>");
            sb.append("<td>" + commonUtil.cleanValue(outApplication.getUserID().trim()) + "</td>");
            sb.append("<td align=\"center\">" + outApplication.getOutDate().substring(0, 10) + "</td>");
            sb.append("<td align=\"center\">");
            sb.append("<a class=\"imgbtn\"><span onclick=\"javascript:okno('ok','" + commonUtil.cleanValue(outApplication.getUserID().trim()) + "','" + code + "','" + curPage + "','" + commonUtil.cleanValue(outApplication.getUserName().trim()) + "');\" style=\"width:40px\">" + egovMessageSource.getMessage("ezCommunity.t46", userInfo.getLocale()) + "</span></a>");
            sb.append("</td>");
            sb.append("<td align=\"center\">");
            sb.append("<a class=\"imgbtn\"><span onclick=\"javascript:okno('no','" + commonUtil.cleanValue(outApplication.getUserID().trim()) + "','" + code + "','" + curPage + "','" + commonUtil.cleanValue(outApplication.getUserName().trim()) + "');\" style=\"width:40px\">" + egovMessageSource.getMessage("ezCommunity.t552", userInfo.getLocale()) + "</span></a>");
            sb.append("</td>");
            sb.append("</tr>");
            sb.append("<tr>");
            sb.append("<td width='60' align='center' >" + egovMessageSource.getMessage("ezCommunity.t564", userInfo.getLocale()) + "</td>");
            sb.append("<td align='left' colspan='5' style='padding:3px'>");
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
		
		/* 2018-06-22 홍승비 - 커뮤니티 팝업홈 회원탈퇴/마스터이취임 리스트 companyID 조건 추가*/
		List<CommunityCClubUserVO> list = adminMemberListGet3(code, flag, userInfo.getPrimary(), ser, userInfo.getCompanyID(), userInfo.getTenantId());
		
		int iCount = 1;
		StringBuilder sb = new StringBuilder();
		
		for (CommunityCClubUserVO clubUser : list) {
			sb.append("<tr>");
			sb.append("<td height=\"23\" align=\"center\" class=\"white\">" + iCount + "</td>");
			sb.append("<td class=\"white\">");
			
			if (clubUser.getC_ID().trim().equals(strSysopID.trim())) {
				sb.append("<img src=\"/images/i_master.gif\" alt=\"" + egovMessageSource.getMessage("ezCommunity.t513", userInfo.getLocale()) + "\" WIDTH=\"15\" HEIGHT=\"9\" hspace=\"2\" border=\"0\" align=\"absmiddle\">");
			}
			
			sb.append("<a href=\"/ezCommunity/adminMemberListOk.do?code=" + code + "&mode=" + mode + "&cID=" + clubUser.getC_ID().trim() + "&cNm=" + URLEncoder.encode(clubUser.getUserName(), "utf-8") + "&companyID=" + clubUser.getCompanyID().trim() + "\" valign=\"bottom\">");
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
		
		/* 2018-06-21 홍승비 - MY커뮤니티 새글 표출 시 현재 companyID로 자신이 가입한 모든 CLUBNO 가져오도록 수정 */
		List<String> clubNoList = myCommunityGet(userInfo.getId(), 0, 0, "CNT", userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (clubNoList.size() % 2 == 0) {
			totalPage = clubNoList.size() / 2;
		} else {
			totalPage = clubNoList.size() / 2 + 1;
		}
		
		logger.debug("mainPage ended.");
		
		return totalPage;
	}

	@Override
	public String myCopNewBoardItem(LoginVO userInfo, int startRow, int endRow) throws Exception {
		logger.debug("myCopNewBoardItem started.");
		
		StringBuilder rtnVal = new StringBuilder();	
		/* 2018-06-21 홍승비 - MY커뮤니티 새글 표출 시 현재 companyID로 자신이 가입한 모든 CLUBNO 가져오도록 수정 */
		List<String> clubNoList = myCommunityGet(userInfo.getId(), startRow, endRow, "LIST", userInfo.getCompanyID(), userInfo.getTenantId());

		//logger.debug("clubNoList.size : " + clubNoList.size());
		
		rtnVal.append("<ITEM><DATA>");
		
		// 2018-11-14 김민성 - 커뮤니티 개선 작업 새글 정보만 조회하도록 변경
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_copNo", clubNoList);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", userInfo.getTenantId());
		map.put("offset", commonUtil.getMinuteUTC(userInfo.getOffset()));
		
		//logger.debug("v_copNo : " + clubNoList);
		
		if(clubNoList.size() > 0) {
			List<CommunityMyCommunityVO> myCommunityList = ezCommunityDAO.myCommunityItemGet(map);
			
			for(CommunityMyCommunityVO myCommunity : myCommunityList) {
				rtnVal.append(commonUtil.getQueryResult(myCommunity));
			}
		}
		// 이미 companyID로 걸러진 커뮤니티(동일 테넌트 내에서 CLUBNO로 구분 가능)를 가지고 후작업한다.
		/*for (String clubNo : clubNoList) {
			
			logger.debug("myCommunityList.size() : " + myCommunityList.size());
			
			// 18-05-08 김민성 - 커뮤니티 회원수 수정
			for(CommunityMyCommunityVO myCommunity : myCommunityList) {
				int cnt = commViewMemberGet2(clubNo.trim(), userInfo.getPrimary(), "", "", userInfo.getTenantId());
				myCommunity.setC_memberCnt(String.valueOf(cnt));
				rtnVal.append(commonUtil.getQueryResult(myCommunity));
			}
		}*/
		
		rtnVal.append("</DATA></ITEM>");
		
		logger.debug("myCopNewBoardItem ended.");
		
		return rtnVal.toString();
	}

	/* 2018-06-21 홍승비 - 메인홈 우측 우수+신규 커뮤니티 표출 companyID 조건 추가 */
	@Override
	public String getBestNewCommunity(LoginVO userInfo, String mode) throws Exception {
		logger.debug("getBestNewCommunity started.");
		
		StringBuilder rtnVal = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_LANG", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		map.put("companyID", userInfo.getCompanyID());
		map.put("tenantID", userInfo.getTenantId());
		
		rtnVal.append("<DATA>");
		
		// 18-05-08 김민성 - 커뮤니티 회원수 수정
		if (mode.equals("BEST")) {
			logger.debug("mainPageGet5 started.");
			
			/* 2018-06-21 홍승비 - 메인홈 우측 우수커뮤니티 표출 companyID 조건 추가 */
			List<CommunityMyCommunityVO> list = ezCommunityDAO.mainPageGet5(map);
			logger.debug("mainPageGet5 ended.");
			
			// 이미 companyID로 걸러진 커뮤니티를 가져와 후작업한다.
			for (CommunityMyCommunityVO vo : list) {
				int cnt = commViewMemberGet2(vo.getC_ClubNo().trim(), userInfo.getPrimary(), "", "", userInfo.getCompanyID(), userInfo.getTenantId(), "", "", userInfo.getOffset());
				vo.setC_memberCnt(String.valueOf(cnt));
				rtnVal.append(commonUtil.getQueryResult(vo));
			}
			
		} else {
			logger.debug("mainPageGet6 started.");
			
			map.put("v_pNow", commonUtil.getTodayUTCTime(""));
			
			/* 2018-06-21 홍승비 - 메인홈 우측 신규커뮤니티 표출 companyID 조건 추가 */
			List<CommunityMyCommunityVO> list = ezCommunityDAO.mainPageGet6(map);
			
			logger.debug("mainPageGet6 ended.");
			
			// 이미 companyID로 걸러진 커뮤니티를 가져와 후작업한다.
			for (CommunityMyCommunityVO vo : list) {
				int cnt = commViewMemberGet2(vo.getC_ClubNo().trim(), userInfo.getPrimary(), "", "", userInfo.getCompanyID(), userInfo.getTenantId(), "", "", userInfo.getOffset());
				vo.setC_memberCnt(String.valueOf(cnt));
				rtnVal.append(commonUtil.getQueryResult(vo));
			}
		}
		
		rtnVal.append("</DATA>");
		
		logger.debug("getBestNewCommunity ended.");
		
		return rtnVal.toString();
	}

	/* 2018-06-21 홍승비 - 자신이 가입한 커뮤니티 리스트 좌측표출 companyID 조건 추가 */
	@Override
	public String leftCommunityGet1(String code, String id, String companyID, int tenantID) throws Exception {
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
		//logger.debug("strBoardName : " + strBoardName + ", strClubNo : " + strClubNo + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_STRBOARDNAME", strBoardName);
		map.put("v_STRCLUBNO", strClubNo);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.getBoardTitleName(map);
		
		logger.debug("getBoardTitleName started.");
		
		return result;
	}

	@Override
	public int bbsListGet1(String bName, String primary, String pKeyword, String sRadio, String companyID, int tenantID) throws Exception {
		logger.debug("bbsListGet1 started.");
		//logger.debug("bName : " + bName + ", primary : " + primary + ", pKeyword : " + pKeyword + ", sRadio : " + sRadio + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName.toUpperCase()); // TBL_C_BOARD(2024-07-16 기준 커뮤니티 공지사항으로 사용되는 테이블), TBL_C_NOTICE, TBL_C_CLUBNOTICE
		map.put("primary", primary);
		map.put("v_KEYWORD", pKeyword);
		map.put("v_S_RADIO", sRadio.toUpperCase());
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		
		int result = ezCommunityDAO.bbsListGet1(map);
		
		logger.debug("bbsListGet1 ended.");
		
		return result;
	}

	@Override
	public List<CommunityCBoardVO> bbsListGet2(String bName, String primary, String pKeyword, String sRadio, int tenantID, String companyID) throws Exception {
		logger.debug("bbsListGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName.toUpperCase());
		map.put("primary", primary);
		map.put("v_KEYWORD", pKeyword);
		map.put("v_S_RADIO", sRadio.toUpperCase());
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		
		List<CommunityCBoardVO> list = ezCommunityDAO.bbsListGet2(map);
		
		//logger.debug("bName : " + bName + ", primary : " + primary + ", pKeyword : " + pKeyword + ", sRadio : " + sRadio);
		logger.debug("bbsListGet2 ended.");
		
		return list;
	}

	@Override
	public String bbsEditGet1(String bName, String no, int tenantID) throws Exception {
		logger.debug("bbsEditGet1 started.");
		//logger.debug("bName : " + bName + ", no : " + no + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName.toUpperCase());
		map.put("v_NO", no);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.bbsEditGet1(map);
		
		logger.debug("bbsEditGet1 ended.");
		
		return result;
	}

	@Override
	public CommunityCBoardVO bbsViewNewGet1(String bName, String no, int tenantID, String offset) throws Exception {
		logger.debug("bbsViewNewGet1 started.");
		//logger.debug("bName : " + bName + ", no : " + no + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName.toUpperCase());
		map.put("v_NO", no);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.bbsViewNewUpdate(map);
		CommunityCBoardVO vo = ezCommunityDAO.bbsViewNewGet1(map);
		
		logger.debug("bbsViewNewGet1 ended.");
		
		return vo;
	}

	@Override
	public CommunityCBoardVO bbsEditNew(String bName, String no, String primary, int tenantID) throws Exception {
		logger.debug("bbsEditNew started.");
		//logger.debug("bName : " + bName + ", no : " + no + ", primary : " + primary + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName.toUpperCase());
		map.put("v_NO", no);
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		
		CommunityCBoardVO vo = ezCommunityDAO.bbsEditNew(map);
		
		logger.debug("bbsEditNew ended.");
		
		return vo;
	}
	
	@Override
	public List<CommunityCBoardVO> bbsViewNewGet2(String bName, int tenantID) throws Exception {
		logger.debug("bbsViewNewGet2 started.");
		//logger.debug("bName : " + bName + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName.toUpperCase());
		map.put("tenantID", tenantID);
		
		List<CommunityCBoardVO> list = ezCommunityDAO.bbsViewNewGet2(map);
		
		logger.debug("bbsViewNewGet2 ended.");
		
		return list;
	}

	@Override
	public CommunityCBoardVO bbsDelOkGet(String bName, String itemNo, String code, int tenantID) throws Exception {
		logger.debug("bbsDelOkGet started.");
		//logger.debug("bName : " + bName + ", itemNo : " + itemNo + ", code : " + code + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName.toUpperCase());
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
		//logger.debug("code : " + code + ", tenantID : " + tenantID);
		
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
		
		/* 2018-05-02 홍승비 - 커뮤니티 썸네일과 포토게시판 썸네일 경로 다르게 수정 */
		if(pType.equals("LOGO") || pType.equals("COMMUNITYTHUM")) {
			pSignatureDir = commonUtil.getUploadPath("upload_community.LOGO", tenantID);
		}
		else if(pType.equals("COMMUNITYBOARD")) {
			pSignatureDir = commonUtil.getUploadPath("upload_community.ROOT", tenantID);
		}
		
		String pResult = commonUtil.detectPathTraversal(pSignatureDir + commonUtil.separator + pFileName);
		
		logger.debug("getCommunityThumInfo ended.");		
		return pResult;
	}

	@Override
	public boolean communityConnCHK(String id, String clubID, String boardID, String rollInfo, int mode, HttpServletResponse response, LoginVO userInfo, String type) throws Exception {
		logger.debug("communityConnCHK started.");
		//logger.debug("rollInfo = " + rollInfo);
		String rtnValue = "";
		boolean result = false;

		if (!commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c")) {
			rtnValue = getClubCHK(id, clubID, boardID, userInfo.getTenantId(), type);
			if (rtnValue.equals("4")) {
				return result;
			}
		} else {
			rtnValue = "1";
		}
		
		if (mode == 0 && (rtnValue.equals("1") || rtnValue.equals("2"))) {
			result = true;
		}
		
		if (mode == 1 && rtnValue.equals("1")) {
			result = true;
		}
		
		logger.debug("communityConnCHK ended.");
		
		return result;
	}

	private String getClubCHK(String id, String clubID, String boardID, int tenantID, String type) throws Exception{
		logger.debug("getClubCHK started.");
		//logger.debug("id : " + id + ", clubID : " + clubID + ", boardID : " + boardID + ", tenantID : " + tenantID);
		
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
			if (type != null && type.equals("pop") && temp == 0) {
				result = "4"; // 공개글이나 가입되지 않은 사람
				return result;
			}
			temp = ezCommunityDAO.getClubCHKGet2(map);
			
			if (temp != 0) {
				result = "2";
			} else {
				result = "3";
			}
		}
		
		//logger.debug("result : " + result);
		logger.debug("getClubCHK ended.");
		
		return result;
	}

	@Override
	public String getBoardTree(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String primary, int tenantID) throws Exception {
		logger.debug("getBoardTree started.");
		
		int count = 0;
        String strForbiddenBoardIDList = "";
		StringBuilder result;
		List<CommunityBoardTreeVO> boardTreeList = null;
		List<CommunityBoardTreeVO> brdBoardTreeList = new ArrayList<CommunityBoardTreeVO>();
		
		String retValue = getBoardTreeGet1(pRootBoardID, pUserID, pDeptID, pCompanyID, pMode, pSubFlag, pSelectBy, pExcludeBoardID, pClubNo, primary, tenantID);
		
        if (retValue != null && retValue.length() > 30) {
    		return retValue;
        }
        
        String pAccessID = pUserID + "," + ezOrganService.getDeptFullPath(pDeptID, tenantID) + ",everyone";
        String strRollInfo = ezOrganService.getPropertyValue(pUserID, "extensionattribute1", tenantID);
        
        for (int i = 0; i < pAccessID.split(",").length; i++) {
        	boardTreeList = getBoardTreeGet2(pAccessID.split(",")[i].trim(), tenantID);
        	brdBoardTreeList = brdBoardTree(pRootBoardID, pAccessID.split(",")[i].trim(), "", "", pMode, pSelectBy, pExcludeBoardID, pClubNo, tenantID);
        	//logger.debug("brdBoardTreeList.size : " + brdBoardTreeList.size());
        	
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
        	if (!commonUtil.isAdmin(pUserID, tenantID, strRollInfo, "c;n;k")) {
                if (strForbiddenBoardIDList.indexOf(brdBoardTreeList.get(i).getBoardID()) > -1) {
                	continue;
                }
            }
        	
        	result.append("<NODE>");
        	
        	if (primary.equals("1")) {
        		result.append("<VALUE>" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName()) + "</VALUE>");
        	} else {
        		result.append("<VALUE>" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName2()) + "</VALUE>");
        	}        	
        	
            result.append("<STYLE></STYLE>");
            result.append("<DATA1>" + brdBoardTreeList.get(i).getBoardID() + "</DATA1>");
            
            if (primary.equals("1")) {
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
            
            /* 2020-09-08 홍승비 - URL게시판 구분용 파라미터 추가 */
            result.append("<URL>" + brdBoardTreeList.get(i).getUrl() + "</URL>");
            
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
        
        getBoardTreeSet(pRootBoardID, pUserID, pDeptID, pCompanyID, pMode, pSubFlag, pSelectBy, pExcludeBoardID, pClubNo, primary, result.toString().replace("'", "''"), tenantID);

        logger.debug("getBoardTree ended.");
        
        return result.toString();
	}
	
	@Override
	public CommunityBoardPropertyVO getBoardInfo(LoginVO userInfo, String pBoardID, String code) throws Exception {
		CommunityBoardPropertyVO boardInfo = new CommunityBoardPropertyVO();

		if (pBoardID.equals("")) {
			boardInfo.setBoardName(egovMessageSource.getMessage("ezCommunity.t91", userInfo.getLocale()));
			boardInfo.setBoardName2(egovMessageSource.getMessage("ezCommunity.t91", userInfo.getLocale()));
			return boardInfo;
		}

		if (!"".equals(code)) {
			CommunityBoardPropertyVO boardInfoTemp = null;
			boardInfoTemp = brdGetACL(pBoardID, "everyone", userInfo.getTenantId());

			// 사용자 회원등급
			String userGrade = getUserGrade(code, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId()) != null ? getUserGrade(code, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId()) : "10";

			if (userGrade.equals("1")) {
				boardInfo.setBoardGroupAdmin_FG("OK");
			} else {
				boardInfo.setBoardGroupAdmin_FG("NO");
			}
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
			} else if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;k;t")) { // 전체관리자, 회사관리자
				boardInfo.setAccess_FG("1");
				boardInfo.setBoardAdmin_FG("true");
				boardInfo.setListView_FG("true");
				boardInfo.setRead_FG("true");
				boardInfo.setWrite_FG("true");
				boardInfo.setReply_FG("true");
				boardInfo.setDelete_FG("true");
			} else if (boardInfo.getBoardGroupAdmin_FG().equals("OK")) { // 마스터
				boardInfo.setAccess_FG("1");
				boardInfo.setBoardAdmin_FG("true");
				boardInfo.setListView_FG("true");
				boardInfo.setRead_FG("true");
				boardInfo.setWrite_FG("true");
				boardInfo.setReply_FG("true");
				boardInfo.setDelete_FG("true");
			// 2023-05-15 이사라 : NullPointerException 시큐어코딩
			} else if (!Objects.isNull(boardInfoTemp)) {
				if (Integer.parseInt(userGrade) <= Integer.parseInt(boardInfoTemp.getRead_FG())) { // 읽기권한 등급과 사용자 등급 비교
					boardInfo.setRead_FG("true");
				} else {
					boardInfo.setRead_FG("false");
				}
				if (Integer.parseInt(userGrade) <= Integer.parseInt(boardInfoTemp.getWrite_FG())) { // 쓰기권한 등급과 사용자 등급 비교
					boardInfo.setWrite_FG("true");
					boardInfo.setReply_FG("true");
				} else {
					boardInfo.setWrite_FG("false");
					boardInfo.setReply_FG("false");
				}
				if (Integer.parseInt(userGrade) <= Integer.parseInt(boardInfoTemp.getDelete_FG())) { // 삭제권한 등급과 사용자 등급 비교
					// 운영자 권한정보
					List<CommunityCClubUserVO> operatorList = getClubOperatorList(userInfo.getCompanyID(), userInfo.getTenantId(), code, userInfo.getId());

					if (operatorList != null && !operatorList.isEmpty()) {
						if (operatorList.get(0).getAdmin_Auth() != null && operatorList.get(0).getAdmin_Auth().contains("F")) {
							boardInfo.setDelete_FG("true");
						}
					} else {
						boardInfo.setDelete_FG("false");
					}
				} else {
					boardInfo.setDelete_FG("false");
				}
				boardInfo.setAccess_FG("1");
				boardInfo.setBoardAdmin_FG("false");
				boardInfo.setListView_FG("true");
			} else {
				throw new NullPointerException("getBoardInfo boardInfoTemp is null");
			}
		}

		CommunityBoardPropertyVO strProp = getBoardProperty(pBoardID, userInfo.getTenantId());
		
		if (strProp != null) {
			if (strProp.getItemExpires() != null) {
				boardInfo.setExpireDays(Integer.toString(strProp.getItemExpires()));
			}
			
			boardInfo.setC_ClubNo(strProp.getC_ClubNo());
	    	boardInfo.setAttachSizeLimit(strProp.getAttachSizeLimit());
		    boardInfo.setBoardName(strProp.getBoardName());
		    boardInfo.setBoardName2(strProp.getBoardName2());
			boardInfo.setReplyNotify(strProp.getReplyNotify());
			boardInfo.setGubun(strProp.getGubun());
			boardInfo.setUrl(strProp.getUrl());
			boardInfo.setReplyNotify(strProp.getReplyNotify());
			/* 2021-11-15 홍승비 - 메일알림 옵션 추가 */
			boardInfo.setMailFG_Post(strProp.getMailFG_Post());
			boardInfo.setMailFG_Mod(strProp.getMailFG_Mod());
			boardInfo.setMailFG_Comment(strProp.getMailFG_Comment());
			/* 2019-01-10 홍승비 - 부모게시판ID 데이터 추가 */
			boardInfo.setParentBoardID(strProp.getParentBoardID());
			boardInfo.setC_ClubName(strProp.getC_ClubName());
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
		//logger.debug("pBoardID : " + pBoardID + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", pBoardID);
		map.put("tenantID", tenantID);
		
		CommunityBoardPropertyVO vo = ezCommunityDAO.getBoardProperty(map);
		
		logger.debug("getBoardProperty ended.");
		
		return vo;
	}	
	
	@Override
	public String getCategory(String strSelCateA, String strSelCateB, String strSelCateC, LoginVO userInfo) throws Exception {
		logger.debug("getCategory started.");
		//logger.debug("strSelCateA : " + strSelCateA + ", strSelCateB : " + strSelCateB + ", strSelCateC : " + strSelCateC);
		
		StringBuilder strHTML = new StringBuilder();
		
		strHTML.append("<Select name=\"cCateA\">");
		strHTML.append("<Option Value=\"0\">" + egovMessageSource.getMessage("ezCommunity.t80", userInfo.getLocale()) + "</Option>");
		strHTML.append(getCategoryValueA(strSelCateA, userInfo));
		strHTML.append("</Select>");
		strHTML.append("<Select name=\"cCateB\" class=\"text\" style=\"display:none;\">");
		strHTML.append("<Option Value=\"0\">" + egovMessageSource.getMessage("ezCommunity.t81", userInfo.getLocale()) + "</Option>");
		strHTML.append(getCategoryValueB(strSelCateB, userInfo));
		strHTML.append("</Select>");
		strHTML.append("<Select name=\"cCateC\" class=\"text\" style=\"display:none;\">");
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
        
        /* 2018-10-02 홍승비 - 게시자의 writerDeptID를 가져오도록 수정 */
        List<CommunityBoardListVO> list = ezCommunityDAO.searchItemXML(map);
        
        sb.append("<NODES>");
		
		for (CommunityBoardListVO boardList : list) {
			count++;
			
			if (count >= pStartRow) {
				sb.append("<NODE>");
				sb.append("<ItemID>" + boardList.getItemID() + "</ItemID>");
				sb.append("<WriterID>" + commonUtil.cleanValue(boardList.getWriterID()) + "</WriterID>");
				sb.append("<WriterName>" + commonUtil.cleanValue(boardList.getWriterName()) + "</WriterName>");
				sb.append("<WriterDeptID>" + commonUtil.cleanValue(boardList.getWriterDeptID()) + "</WriterDeptID>");
				sb.append("<WriterDeptName>" + commonUtil.cleanValue(boardList.getWriterDeptName()) + "</WriterDeptName>");
				sb.append("<WriterCompanyName>" + commonUtil.cleanValue(boardList.getWriterCompanyName()) + "</WriterCompanyName>");
				sb.append("<WriteDate>" + commonUtil.getDateStringInUTC(boardList.getWriteDate(), offset, false) + "</WriteDate>");
				sb.append("<Importance>" + boardList.getImportance() + "</Importance>");
				sb.append("<Title>" + commonUtil.cleanValue(boardList.getTitle()).replace("\\", "\\\\") + "</Title>");
				
				if (boardList.getAttachments().equals("")) {
					sb.append("<Attachments></Attachments>");
				} else {
					sb.append("<Attachments>" + boardList.getAttachments() + "</Attachments>");
				}
				
				sb.append("<ReadCount>" + boardList.getReadCount() + "</ReadCount>");
				sb.append("<ItemLevel>" + boardList.getItemLevel() + "</ItemLevel>");
				sb.append("<ReadFlag>" + boardList.getReadFlag() + "</ReadFlag>");
				sb.append("<Abstract>" + commonUtil.cleanValue(boardList.getAbsTract()) + "</Abstract>");
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
		
		/* 2024-07-16 홍승비 - 커뮤니티 팝업홈 > 게시판 검색 시 카운트 쿼리에서 누락된 게시자명 다국어 검색조건 추가 */
		map.put("v_strLang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		
		int result = ezCommunityDAO.searchItemCount(map);
		//logger.debug("result=" + result);
		logger.debug("searchItemCount ended.");
		
		return result;
	}

	/* 2018-07-02 홍승비 - 조회자 정보에 companyID 삽입 */
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
		map.put("companyID", userInfo.getCompanyID());
		map.put("tenantID", userInfo.getTenantId());
		
		try {
			for (String item : itemIDList.split(";")) {
				map.put("v_pItemID", item);
				
				if (boardID.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
					map.put("v_pBoardID", ezCommunityDAO.setAsReadSelectBoardID(map));
					//logger.debug("v_pBoardID : " + ezCommunityDAO.setAsReadSelectBoardID(map));
				}
				
				//logger.debug("item : " + item);
				
				int temp = ezCommunityDAO.setAsReadSelectTemp(map);
				//logger.debug("temp : " + temp);
				
				if (temp == 0) {
					ezCommunityDAO.setAsReadInsert(map);
					
					String writerID = ezCommunityDAO.getWriterID(map);
					
					if(writerID == null || !writerID.equals(userInfo.getId())) {
						ezCommunityDAO.setAsReadUpdate(map);
					}
				}
				
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
		//logger.debug("deleteItem started. itemList = " + itemList);
		
		String boardID = "";
		
		for (String itemID : itemList.split(";")) {
			itemID = itemID.split(",")[0];
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("itemID", itemID);
			map.put("tenantID", tenantID);
			
			//logger.debug("deleteItemGet itemID = " + itemID + " || tenantID = " + tenantID);
			boardID = ezCommunityDAO.deleteItemGet(map);
			
			//logger.debug("itemID : " + itemID + ", boardID : " + boardID);
			
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
			
			//logger.debug("itemID = " + itemID + " || tenantID = " + tenantID);
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_pItemID", itemID);
			map.put("tenantID", tenantID);
			
			int ret = ezCommunityDAO.checkIfHasReply(map);
			//logger.debug("itemID : " + itemID);
			//logger.debug("ret : " + ret);

			if (ret != 0) {
				return "TRUE";
			}
		}
		
		logger.debug("checkIfHasReply ended.");
		
		return "FALSE";
	}

	/* 커뮤니티 게시물(일반) > 게시자의 writerDeptID를 가져오도록 수정 */
	@Override
	public CommunityBoardItemVO getItemXML(String pBoardID, String pItemID, LoginVO userInfo) throws Exception {
		logger.debug("getItemXML started.");
		int tenantID = userInfo.getTenantId();
		String offset = userInfo.getOffset();
		String lang = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", pBoardID);
		map.put("v_pItemID", pItemID);
		map.put("v_strLang", lang);
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
		boolean saveResult = false;
		
		String editor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		
		String dateStr = commonUtil.getTodayUTCTime("");
		
		CommunityBoardItemVO item = new CommunityBoardItemVO();

		pUploadFilePath = xmlData.getElementsByTagName("FILEPATH").item(0).getTextContent();
		item.setItemID(xmlData.getElementsByTagName("ITEMID").item(0).getTextContent());
		item.setBoardID(xmlData.getElementsByTagName("BOARDID").item(0).getTextContent());
		item.setWriterID(xmlData.getElementsByTagName("WRITERID").item(0).getTextContent().trim());
		item.setWriterName(URLDecoder.decode(xmlData.getElementsByTagName("WRITERNAME").item(0).getTextContent(), "utf-8").trim());
		item.setWriterName2(URLDecoder.decode(xmlData.getElementsByTagName("WRITERNAME2").item(0).getTextContent(), "utf-8").trim());
		item.setWriterDeptID(xmlData.getElementsByTagName("DEPTID").item(0).getTextContent());
		item.setWriterDeptName(URLDecoder.decode(xmlData.getElementsByTagName("DEPTNAME").item(0).getTextContent().replaceAll("%(?![0-9a-fA-F]{2})", "%25").replaceAll("\\+", "%2B").replaceAll("&amp;", "&").trim(), "utf-8"));
		item.setWriterDeptName2(URLDecoder.decode(xmlData.getElementsByTagName("DEPTNAME2").item(0).getTextContent().replaceAll("%(?![0-9a-fA-F]{2})", "%25").replaceAll("\\+", "%2B").replaceAll("&amp;", "&").trim(), "utf-8"));
		item.setWriterCompanyID(xmlData.getElementsByTagName("COMPANYID").item(0).getTextContent());
		item.setWriterCompanyName(URLDecoder.decode(xmlData.getElementsByTagName("COMPANYNAME").item(0).getTextContent().replaceAll("%(?![0-9a-fA-F]{2})", "%25").replaceAll("\\+", "%2B").replaceAll("&amp;", "&").trim(), "utf-8"));
		item.setWriterCompanyName2(URLDecoder.decode(xmlData.getElementsByTagName("COMPANYNAME2").item(0).getTextContent().replaceAll("%(?![0-9a-fA-F]{2})", "%25").replaceAll("\\+", "%2B").replaceAll("&amp;", "&").trim(), "utf-8"));
		item.setWriteDate(dateStr);
		item.setImportance(Integer.parseInt(xmlData.getElementsByTagName("IMPORTANCE").item(0).getTextContent()));
		item.setTitle(URLDecoder.decode(xmlData.getElementsByTagName("TITLE").item(0).getTextContent().replaceAll("%(?![0-9a-fA-F]{2})", "%25").replaceAll("\\+", "%2B").replaceAll("&amp;", "&"), "utf-8").trim());

		if (pMode.equals("copy")) {
			pContentLocation = xmlData.getElementsByTagName("CONTENTLOCATION").item(0).getTextContent();
		} else {
			if (!editor.equals("HWP")) {
				pContentLocation = commonUtil.getUploadPath("upload_community.ROOT", userInfo.getTenantId()) + commonUtil.separator + item.getBoardID() + commonUtil.separator + "doc" + commonUtil.separator + item.getItemID() + ".mht";
			} else {
				pContentLocation = commonUtil.getUploadPath("upload_community.ROOT", userInfo.getTenantId()) + commonUtil.separator + item.getBoardID() + commonUtil.separator + "doc" + commonUtil.separator + item.getItemID() + ".hwp";
			}
		}
		
		item.setContentLocation(pContentLocation);
		item.setStartDate(commonUtil.getDateStringInUTC(xmlData.getElementsByTagName("STARTDATE").item(0).getTextContent(), offset, true));

		if (item.getStartDate().equals("")) {
			item.setStartDate(item.getWriteDate());
		}
		
		item.setEndDate(commonUtil.getDateStringInUTC(xmlData.getElementsByTagName("ENDDATE").item(0).getTextContent(), offset, true));
		item.setAbsTract(URLDecoder.decode(xmlData.getElementsByTagName("ABSTRACT").item(0).getTextContent().replaceAll("%(?![0-9a-fA-F]{2})", "%25").replaceAll("\\+", "%2B").replaceAll("&amp;", "&"), "utf-8").trim());
		item.setAttachments(URLDecoder.decode(xmlData.getElementsByTagName("ATTACHMENTS").item(0).getTextContent(), "utf-8"));
		item.setUpperItemIDTree(xmlData.getElementsByTagName("UPPERITEMIDTREE").item(0).getTextContent());
		
		if (pMode.equals("reply")) {
			item.setUpperItemIDTree(item.getUpperItemIDTree() + getReverseDateNow());
		}
		
		item.setItemLevel(Integer.parseInt(xmlData.getElementsByTagName("ITEMLEVEL").item(0).getTextContent()));
		
		if (!pMode.equals("copy")) {
			pContent = xmlData.getElementsByTagName("CONTENT").item(0).getTextContent();
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
			if (!editor.equals("HWP")) {
				saveResult = saveMHT(pContent, item.getItemID(), item.getBoardID(), pUploadFilePath, realPath);
				
				if (saveResult == false) {
					return egovMessageSource.getMessage("ezCommunity.lhj04", userInfo.getLocale());
				}
			} else {
				saveResult = saveHWP(pContent, item.getItemID(), item.getBoardID(), pUploadFilePath, realPath);
				if (saveResult == false) {
					return egovMessageSource.getMessage("ezBoard.kwc01", userInfo.getLocale());
				}
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
			//ezCommunityDAO.brdUpdateItemDelete(map);
		} else {
			map.put("v_pDocNo", "");
			ezCommunityDAO.brdNewItemInsert(map);
		}
		
		ezCommunityDAO.newItemDel(map);

		if (item.getAttachments().length() > 0) {
			if (saveAttachmentsInfo(item, pUploadFilePath, realPath, userInfo.getTenantId()) == false) {
				return egovMessageSource.getMessage("ezCommunity.lhj05", userInfo.getLocale());
			}
			pHasAttach = "1";
		} else {
			pHasAttach = "0";
			List<CommunityBoardItemAttachmentVO> orgFileList = ezCommunityDAO.getItemAttachmentXML(map);
			if (orgFileList.size() > 0) {
				String folder = realPath + pUploadFilePath;
				for (CommunityBoardItemAttachmentVO itemAttachment : orgFileList) {
					String strFile = folder + itemAttachment.getFilePath();
					File file = new File(commonUtil.detectPathTraversal(strFile));
					
					if (file.exists()) {
						file.delete();
					}
				}
			}
			ezCommunityDAO.newItemDel(map);
		}
		
		return "OK";
	}

	@Override
	public String getItemAttachmentXML(String itemID, int tenantID, String realPath, String pMode) throws Exception {
		logger.debug("getItemAttachmentXML started.");
		
		StringBuilder sb = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemID", itemID);
		map.put("tenantID", tenantID);
		
		List<CommunityBoardItemAttachmentVO> list = ezCommunityDAO.getItemAttachmentXML(map);
		
		String useEditor = ezCommonService.getTenantConfig("MODULEEDITOR", tenantID);
		
		sb.append("<NODES>");
		
		if (useEditor.equals("HWP") && pMode.equals("mail")) {
			CommunityBoardItemVO item = ezCommunityDAO.getItemXML(map);
			String contentLocation = item.getContentLocation();
			String ext = contentLocation.substring(contentLocation.length() - 3, contentLocation.length());
			if (ext.toUpperCase().equals("HWP")) {
				File file = new File(realPath + commonUtil.detectPathTraversal(item.getContentLocation()));
				int fileSize = (int) file.length();
				sb.append("<NODE>");
				sb.append("<ItemID>" + item.getItemID() + "</ItemID>");
				sb.append("<GUID>0</GUID>");
				sb.append("<FileName>" + commonUtil.cleanValue(item.getTitle()) + "." + ext + "</FileName>");
				sb.append("<FilePath>" + commonUtil.cleanValue(contentLocation) + "</FilePath>");
				sb.append("<FileSize>" + getProperSizeDisplay(fileSize) + "</FileSize>");
				sb.append("<FileSize2>" + fileSize + "</FileSize2>");
				sb.append("<HwpItem>Y</HwpItem>");
				sb.append("</NODE>");
			}
		}
		
		for (CommunityBoardItemAttachmentVO attach : list) {
			sb.append("<NODE>");
			sb.append("<ItemID>" + attach.getItemID() + "</ItemID>");
			sb.append("<GUID>" + attach.getGuID() + "</GUID>");
			sb.append("<FileName>" + commonUtil.cleanValue(attach.getFileName()) + "</FileName>");
			sb.append("<FilePath>" + commonUtil.cleanValue(attach.getFilePath()) + "</FilePath>");
			sb.append("<FileSize>" + getProperSizeDisplay(Integer.parseInt(attach.getFileSize())) + "</FileSize>");
			sb.append("<FileSize2>" + attach.getFileSize() + "</FileSize2>");
			sb.append("</NODE>");
		}
		
		sb.append("</NODES>");
		
		logger.debug("getItemAttachmentXML started.");
		
		return sb.toString();
	}

	@Override
	public String getReservedItemListXML(String id, int pStartRow, int pEndRow, String pSortBy, String primary, int tenantID, String offset) throws Exception {
		logger.debug("getReservedItemListXML started.");
		
		StringBuilder sb = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pEndRow", pEndRow);
		map.put("primary", primary);
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
				sb.append("<BoardName>" + commonUtil.cleanValue(boardList.getBoardName()) + "</BoardName>");
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
				sb.append("<Abstract>" + commonUtil.cleanValue(boardList.getAbsTract()) + "</Abstract>");
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

	/* 2018-07-17 홍승비 - 사원정보 deptID 파라미터 선택을 위해 companyID 조건 추가 */
	@Override
	public List<CommunityOneLineReplyVO> readOneLineReply(String primary, String pBoardID, String pItemID, String companyID, int tenantID, String offset, String gubun) throws Exception {
		logger.debug("readOneLineReply started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("primary", primary);
		map.put("v_pBoardID", pBoardID);
		map.put("v_pItemID", pItemID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		
		/* 2024-01-22 홍승비 - 커뮤니티 게시판 댓글 표출 시 게시판 구분값 분기 추가 */
		map.put("v_GUBUN", gubun);
		
		List<CommunityOneLineReplyVO> list = ezCommunityDAO.readOneLineReply(map);
		
		logger.debug("readOneLineReply ended.");
		
		return list;
	}

	/* 2018-07-02 홍승비 - 댓글 작성 시 작성자의 companyID를 함께 저장함 */
	@Override
	public void saveOneLineReply(Document xmlDoc, LoginVO userInfo) throws Exception {
		logger.debug("saveOneLineReply started.");
		
		String userName = "", userName2 = "";
		String userID = userInfo.getId();
		String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
		
		String pItemID = xmlDoc.getElementsByTagName("ITEMID").item(0).getTextContent();
		String pReplyID = xmlDoc.getElementsByTagName("REPLYID").item(0).getTextContent();
		String pBoardID = xmlDoc.getElementsByTagName("BOARDID").item(0).getTextContent();
		String pContent = URLDecoder.decode(xmlDoc.getElementsByTagName("CONTENT").item(0).getTextContent(), "utf-8");
		String pPassword = xmlDoc.getElementsByTagName("PASSWORD").item(0).getTextContent();

		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		String rpwd = EgovFileScrty.decryptRsa(pk, pPassword);
		pPassword = EgovFileScrty.encryptPassword(rpwd, "unknown");
		
		String[] u_Name = egovMessageSource.getMessage("ezCommunity.t115", userInfo.getLocale()).split(";");
		
		CommunityBoardPropertyVO boardInfo = getBoardInfo(userInfo, pBoardID, "");
		
		if (boardInfo.getGubun() != null) {
			/* 2024-01-18 홍승비 - 커뮤니티 게시판 > 익명게시판의 경우, 댓글 등록 시 사용자ID 저장하지 않도록 수정 (게시판 모듈과 동일) */
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
		
		pContent = pContent.replaceAll("'",  "''");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PITEMID", pItemID);
		map.put("v_PREPLYID", pReplyID);
		map.put("v_PBOARDID", pBoardID);
		map.put("v_USERID", userID);
		map.put("v_USERNAME", userName);
		map.put("v_USERNAME2", userName2);
		map.put("v_PCONTENT", pContent);
		map.put("v_PPASSWORD", pPassword);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyID());
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
		
		// tbl_c_clubpds, tbl_c_clubpds1는 실제로 존재하는 테이블이 아니며, 분기처리를 위해 임의로 사용하는 테이블명임
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
				strHTML.append("<img src=\"/images/i_new.gif\" alt border=\"0\">&nbsp;");
			}
			
			strHTML.append(commonUtil.cleanValue(cBoard.getTitle().trim())+"</nobr></td>");
			
			if (userInfo.getPrimary().equals("1")) {
				strHTML.append("<td class=\"t1\" width=\"70px\" >" + cBoard.getUserName().trim() + "</td>");
			} else {
				strHTML.append("<td class=\"t1\" width=\"70px\" >" + cBoard.getUserName2().trim() + "</td>");
			}
			
			strHTML.append("<td class=\"t1\" width=\"90px\" >" + cBoard.getWriteDay().substring(0, 10) + "</td>");
			 
			if (iColSpan == 6) {
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
		
		String editor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		int myRef = 0, myStep = 0, myLevel = 0, adminCheck = 0;
		String mode = request.getParameter("mode");
		String code = request.getParameter("code");
		String bName = request.getParameter("bName");
		String no = request.getParameter("no");
		String textContent = request.getParameter("textContent");
		String content = request.getParameter("content");
		String title = request.getParameter("title");
		String attachList = request.getParameter("attachList"); // 2024-07-11 기준 전달되지 않는 파라미터로 확인
		String userNm = request.getParameter("userNM");
		String userNm2 = request.getParameter("userNM2");
		String realPath = commonUtil.getRealPath(request);
		String boardID = request.getParameter("boardID");
		int cNo = 0;

		if (!request.getParameter("ref").equals("")) {
            myRef = Integer.parseInt(request.getParameter("ref"));
		}
        if (!request.getParameter("step").equals("")) {
            myStep = Integer.parseInt(request.getParameter("step"));
        }
        if (!request.getParameter("level").equals("")) {
            myLevel = Integer.parseInt(request.getParameter("level"));
        }
		
        //logger.debug("myRef = " + myRef + ", myStep = " + myStep + ", myLevel = " + myLevel);
        String maxIdFieldName = "c_no";
        
        //InputStream is = null;
        //OutputStream os = null;
        //PrintWriter pw = null;
		
		if (mode.equals("edit")) {
        	CommunityCBoardVO cBoard = bbsEditOkGet1(bName, no, code, userInfo.getTenantId());
        	
        	if (userInfo.getRollInfo().indexOf("c=1") >= 0) {
    			adminCheck = 1;
    		}

        	if (cBoard != null) {
        		if (cBoard.getId().trim().equals(userInfo.getId()) || adminCheck == 1) {
	                bbsEditOkSet1(bName.toUpperCase(), title, no, code, attachList, textContent, userInfo.getTenantId());
	                String strPath = realPath + commonUtil.getUploadPath("upload_community.FILEDATA", userInfo.getTenantId()) + commonUtil.separator + getFileFolderName(bName) + commonUtil.separator + cBoard.getFileName().trim();
	                strPath = commonUtil.detectPathTraversal(strPath);
	                //logger.debug("strPath ==== " + strPath);

	                if (!editor.equals("HWP")) {
	                	try (PrintWriter pw = new PrintWriter(new File(strPath))) {
			    		    //pw = new PrintWriter(new File(strPath));
				    		pw.print(commonUtil.stripScriptTags(content));
				    		pw.flush();
				    		pw.close();
		                } catch (FileNotFoundException fnfe) {
		    				logger.debug("fnfe: {}", fnfe);
		    			} catch (Exception e) {
		    				logger.debug("e: {}", e);
		    			} /*finally {
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
		                }*/
	                } else {
	                	InputStream stream = null;
	            		OutputStream bos = null;
	            		
	            		try {
	            			stream = new ByteArrayInputStream(Base64.decodeBase64(content));
	            			bos = new FileOutputStream(strPath);
	            			
	            			int bytesRead = 0;
	            			byte[] buffer = new byte[2048];
	            			
	            			while ((bytesRead = stream.read(buffer, 0, 2048)) != -1) {
	            				bos.write(buffer, 0, bytesRead);
	            			}
	            		}
	            		catch (RuntimeException e) {
	            			throw e;
	            		}
	            		catch (Exception e) {
	            			logger.debug("e: {}", e);
	            		} finally {
	            			if (bos != null) {
	            				try {
	            					bos.close();
	            				} catch (Exception ignore) {
	            						logger.debug("IGNORED: {}", ignore.getMessage());
	            				}
	            			}
	            			
	            			if (stream != null) {
	            				try {
	            					stream.close();
	            				} catch (Exception ignore) {
	            					logger.debug("IGNORED: {}", ignore.getMessage());
	            				}
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
        	cNo = number;
        	
        	if (no.equals("")) {
        		myRef = number;
        		newStep = 0;
        		newLevel = 0;
        	} else {
        		if (!bName.equals("tbl_c_clubnotice") && !bName.equals("tbl_c_notice")) {
        			bbsEditOkSet2(bName.toUpperCase(), myRef, myStep, code, userInfo.getTenantId());
        		}
        		
        		newStep = Math.addExact(myStep, 1);
        		newLevel = Math.addExact(myLevel, 1);
        	}
        	
        	String dirPath = "";
        	String strPath = "";
        	
        	if (strMaxNum == 0){
                if (code.equals("")) {
                	fileName = "0000000001";
                	if (!editor.equals("HWP")) {
                		fileName = fileName + ".mht";
                	} else {
                		fileName = fileName + ".hwp"; 
                	}
                } else {
                    fileName = "0000000001" + "(" + code + ")";
                    if (!editor.equals("HWP")) {
                		fileName = fileName + ".mht";
                	} else {
                		fileName = fileName + ".hwp"; 
                	}
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
                
                if (!editor.equals("HWP")) {
                	fileName = strName + ".mht";
                } else {
                	fileName = strName + ".hwp";
                }
                dirPath = realPath + commonUtil.getUploadPath("upload_community.FILEDATA", userInfo.getTenantId()) + commonUtil.separator + getFileFolderName(bName) + commonUtil.separator;
                strPath = realPath + commonUtil.getUploadPath("upload_community.FILEDATA", userInfo.getTenantId()) + commonUtil.separator + getFileFolderName(bName) + commonUtil.separator + fileName;
            }
    		File dir = new File(commonUtil.detectPathTraversal(dirPath));
    		
    		if (!dir.exists()) {
    			dir.mkdirs();
    		}
        	String nowDate = commonUtil.getTodayUTCTime("");
        	strPath = commonUtil.detectPathTraversal(strPath);
        	
        	/* 2021-06-28 홍승비 - mode가 write이고 no가 존재하는 답변 공지사항 등록 시, 부모 no 데이터를 UPPERNO 칼럼에 저장하도록 수정 */
			String companyID = Optional.ofNullable(request.getParameter("companyID")).orElse(userInfo.getCompanyID());
			bbsEditOkInsert(bName.toUpperCase(), myRef, newStep, newLevel, attachList, number, textContent, nowDate, fileName, code, companyID, userInfo.getId(), userNm, userNm2, title, maxIdFieldName, no, userInfo.getTenantId());
        	
			if (!editor.equals("HWP")) {
				try (PrintWriter pw = new PrintWriter(new File(strPath))) {
	        		//File dir = new File(commonUtil.detectPathTraversal(dirPath));
	        		
	        		if (!dir.exists()) {
	        			dir.mkdirs();
	        		}
	        		
		    		//pw = new PrintWriter(new File(strPath));
		    		pw.print(commonUtil.stripScriptTags(content));
		    		pw.flush();
		    		pw.close();
	            } catch (FileNotFoundException fnfe) {
	 				logger.debug("fnfe: {}", fnfe);
	 			} catch (Exception e) {
	 				logger.debug("e: {}", e);
	 			} /*finally {
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
	        	}*/
			} else {
				InputStream stream = null;
        		OutputStream bos = null;
				
        		try {
					stream = new ByteArrayInputStream(Base64.decodeBase64(content));
					bos = new FileOutputStream(strPath);
					
					int bytesRead = 0;
					byte[] buffer = new byte[2048];
					
					while ((bytesRead = stream.read(buffer, 0, 2048)) != -1) {
						bos.write(buffer, 0, bytesRead);
					}
				}
				catch (RuntimeException e) {
					throw e;
				}
				catch (Exception e) {
					logger.debug("e: {}", e);
				} finally {
					if (bos != null) {
						try {
							bos.close();
						} catch (Exception ignore) {
								logger.debug("IGNORED: {}", ignore.getMessage());
						}
					}
					
					if (stream != null) {
						try {
							stream.close();
						} catch (Exception ignore) {
							logger.debug("IGNORED: {}", ignore.getMessage());
						}
					}
				}
			}
        }
		
		String pHasAttach = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		CommunityBoardItemVO item = new CommunityBoardItemVO();
		map.put("tenantID", userInfo.getTenantId());
		if (mode.equals("edit")) {
			item.setItemID(no);
			map.put("v_pItemID", no);
		} else {
			map.put("v_cNo", cNo);
			int recNo = ezCommunityDAO.getRecentNo(map);
			item.setItemID(String.valueOf(recNo));
			map.put("v_pItemID", String.valueOf(recNo));
		}
		
		String uploadFilePath = commonUtil.getUploadPath("upload_community.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		if (attachList.length() > 0) {
			item.setAttachments(URLDecoder.decode(attachList, "utf-8"));
			item.setExtensionAttribute5("");
			item.setBoardID(boardID);
			
			if (saveAttachmentsInfo(item, uploadFilePath, realPath, userInfo.getTenantId()) == false) {
				return egovMessageSource.getMessage("ezCommunity.lhj05", userInfo.getLocale());
			}
			pHasAttach = "1";
		} else {
			pHasAttach = "0";
			List<CommunityBoardItemAttachmentVO> orgFileList = ezCommunityDAO.getItemAttachmentXML(map);
			if (orgFileList.size() > 0) {
				String folder = realPath + uploadFilePath;
				for (CommunityBoardItemAttachmentVO itemAttachment : orgFileList) {
					String strFile = folder + itemAttachment.getFilePath();
					File file = new File(commonUtil.detectPathTraversal(strFile));
					
					if (file.exists()) {
						file.delete();
					}
				}
			}
			ezCommunityDAO.newItemDel(map);
		}
		
		map.put("pHasAttach", pHasAttach);
		
		ezCommunityDAO.updateAttachments(map);
		
		logger.debug("bbsEditOk ended.");
		return "OK";
	}

	@Override
	public String bbsDelOk(LoginVO userInfo, HttpServletRequest request, CommunityCBoardVO board, String itemNo, String goToPage, String bName, int adminCheck, int tenantID) throws Exception {
		String folder = "", strFile = "";
		
		if (board.getId().trim().equals(userInfo.getId()) || adminCheck == 1 || userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
			String fileName = board.getFileName();
			
			if (fileName != null) {
				folder = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_community.FILEDATA", userInfo.getTenantId()) + commonUtil.separator + getFileFolderName(bName) + commonUtil.separator;
				strFile = folder + fileName;
				File file = new File(commonUtil.detectPathTraversal(strFile));
				
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
						File file = new File(commonUtil.detectPathTraversal(strFile));
						
						if (file.exists()) {
							file.delete();
						}
					}
				}
			} else if (bName.equals("tbl_c_board")) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("tenantID", tenantID);
				map.put("v_pOrgItemID", itemNo);
				List<CommunityBoardItemAttachmentVO> orgAttachList = ezCommunityDAO.copyItemGet2(map);
				
				if (orgAttachList.size() > 0) {
					String uploadFilePath = commonUtil.getUploadPath("upload_community.ROOT", userInfo.getTenantId()) + commonUtil.separator;
					folder = commonUtil.getRealPath(request) + uploadFilePath;
					
					for (CommunityBoardItemAttachmentVO itemAttachment : orgAttachList) {
						strFile = folder + itemAttachment.getFilePath();
						File file = new File(commonUtil.detectPathTraversal(strFile));
						
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
		
		List<CommunityCClubGuestVO> list = guestOneGet2(sRadio, keyword, code, userInfo.getPrimary(), userInfo.getTenantId());
        
        StringBuilder sb = new StringBuilder();
        int i = 0;
        sb.append("<DATA>");
        
        for (CommunityCClubGuestVO item : list) {
        	i++;

        	if (i > comNoPerPage * curPage) {
        		break;
        	}
        	
        	if (i > comNoPerPage * curPage -3) {
	        	sb.append("<ROW>");
	        	sb.append("<NO>" + item.getNo() + "</NO>");
	        	sb.append("<ID>" + commonUtil.cleanValue(item.getId().trim()) + "</ID>");
	        	sb.append("<USERNAME>" + commonUtil.cleanValue(item.getUserName()) + "</USERNAME>");
	        	sb.append("<USERNAME2>" + commonUtil.cleanValue(item.getUserName2()) + "</USERNAME2>");
	        	sb.append("<COMPANYID>" + commonUtil.cleanValue(item.getCompanyID()) + "</COMPANYID>");
	        	sb.append("<TITLE>" + commonUtil.cleanValue(item.getTitle()) + "</TITLE>");
	        	sb.append("<CONTENT><![CDATA[" + commonUtil.cleanValue(item.getContent()).replaceAll("\n", "<br>").replaceAll("\\\\", "&#92;") + "]]>" + "</CONTENT>");
	        	sb.append("<CONTENTURL>" + commonUtil.cleanValue(item.getContentURL()) + "</CONTENTURL>");
	        	sb.append("<READNUM>" + item.getReadNum() + "</READNUM>");
	        	sb.append("<WRITEDAY>" + commonUtil.getDateStringInUTC(item.getWriteDay(), userInfo.getOffset(), false) + "</WRITEDAY>");
	        	
	        	if (EgovDateUtil.getDaysDiff(commonUtil.getTodayUTCTime("").substring(0, 10), item.getWriteDay().substring(0, 10)) >= 0 ) {
	        		sb.append("<NEW>" + "NEW" + "</NEW>");
	        	}
	        	
	        	sb.append("<C_NO>" + item.getC_No() + "</C_NO>");
	        	sb.append("<C_CLUBNO>" + item.getC_clubNo() + "</C_CLUBNO>");

				// 2024-10-30 황인경 - 커뮤니티 > 방명록 > 댓글 표출
				int replyCnt = chkClubguestOnelinereply(item.getNo(), commonUtil.cleanValue(item.getCompanyID()), userInfo.getTenantId(), item.getC_clubNo());
				if (replyCnt > 0) {
					sb.append("<C_REPLY>");
					List<CommunityCClubGuestReplyVO> replyList = getGuestOneLineReply(item.getNo(), userInfo.getTenantId(), userInfo.getCompanyID(), item.getC_clubNo());
					for (int j = 0; j < replyCnt; j++){
						sb.append("<ROW2>");
						sb.append("<ITEMID>" + replyList.get(j).getItemId() + "</ITEMID>");
						sb.append("<RUSERID>" +  ezConnUtil.encryptAES(replyList.get(j).getUserId()) + "</RUSERID>");
						sb.append("<RUSERNAME>" + replyList.get(j).getUserName() + "</RUSERNAME>");
						sb.append("<RUSERNAME2>" + replyList.get(j).getUserName2() + "</RUSERNAME2>");
						sb.append("<WRITEDATE>" + commonUtil.getDateStringInUTC(replyList.get(j).getWriteDate(), userInfo.getOffset(), false) + "</WRITEDATE>");
						sb.append("<RCONTENT><![CDATA[" + commonUtil.cleanValue(replyList.get(j).getContent()).replaceAll("\n", "<br>").replaceAll("\\\\", "&#92;") + "]]>" + "</RCONTENT>");
						sb.append("<REPLYID>" + replyList.get(j).getReplyId() + "</REPLYID>");
						sb.append("</ROW2>");
					}
					sb.append("</C_REPLY>");
				}
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
				//2018-07-16 김보미 - 특수문자 앞단에서 처리 
//				guestEditOkInsert(code, userInfo, memo.replaceAll("\n", "<br>").replaceAll("\'", "&quot;").replaceAll("\"", "&dquot;"), userInfo.getTenantId());
				guestEditOkInsert(code, userInfo, memo, userInfo.getTenantId());
				
				break;
			case "delete" :
				for (String no : cNo){
					item = guestEditGet(code, userInfo.getPrimary(), no, userInfo.getId(), userInfo.getTenantId());
					
					if (item != null) {
						bIsMyContent = true;
						guestEditOkDelete(no, code, userInfo.getTenantId());
					}
				}
				
				break;
			case "edit" :
				for (String no : cNo){
					item = guestEditGet(code, userInfo.getPrimary(), no, userInfo.getId(), userInfo.getTenantId());
					
					if (item != null) {
						bIsMyContent = true;
						//2018-07-16 김보미 - 특수문자 앞단에서 처리 
//						guestEditOkUpdate(no, code, memo.replaceAll("\n", "<br>").replaceAll("\'", "&quot;").replaceAll("\"", "&dquot;"), userInfo.getId(), userInfo.getTenantId());
						guestEditOkUpdate(no, code, memo, userInfo.getId(), userInfo.getTenantId());
					}
				}
				
				break;
		}
		
		return bIsMyContent;
	}

//	@Override
//	public List<CommunityBoardItemReadVO> getReaderList(String pBoardID, String pItemID, int tenantID, String offset) throws Exception {
//		logger.debug("getReaderList started.");
//		logger.debug("pBoardID : " + pBoardID + ", pItemID : " + pItemID + ", tenantID : " + tenantID);
//		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("v_pBoardID", pBoardID);
//		map.put("v_pItemID", pItemID);
//		map.put("tenantID", tenantID);
//		map.put("offset", offset);
//		
//		List<CommunityBoardItemReadVO> list = ezCommunityDAO.getReaderList(map);
//		
//		logger.debug("getReaderList started.");
//		
//		return list;
//	}
	
	/* 커뮤니티 게시물 조회자 정보 가져올 때 deptID도 함께 가져오도록 수정(companyID 조건 추가) */
	@Override
	public StringBuffer getReaderList(String boardID, String itemID, String userID, String lang, String companyID, int tenantID, int pageNum, int perCount, String offset) throws Exception {
		logger.debug("getReaderList started");
		// 2018-02-06 김보미 
    	if(pageNum == 0){
    		pageNum = 1;
    	}
    	
    	int startRowNum = ((pageNum - 1) * perCount);
    	int endRowNum = (pageNum * perCount);

    	Map<String, Object> map = new HashMap<String, Object>();
    	
    	map.put("boardID", boardID);
    	map.put("itemID", itemID);
    	map.put("userID", userID);
    	map.put("lang", lang);
    	map.put("tenantID", tenantID);
    	map.put("companyID", companyID);
    	
    	/* MySQL */
    	map.put("perCount", perCount);
    	map.put("start", startRowNum);
    	
    	/* Oracle */
    	map.put("startRowNum", startRowNum);
    	map.put("endRowNum", endRowNum);
    	
    	
    	List<CommunityBoardItemReadVO> readerList = ezCommunityDAO.getReaderList(map);
    	
    	StringBuffer resultXML = new StringBuffer();
		
		resultXML.append("<DOCLIST>");
		
		int totalCount = getReaderListCount(boardID, itemID, userID, tenantID);
		int totalPage = (int) Math.floor(totalCount / perCount);
		if(totalCount % 10 != 0){
			totalPage = totalPage + 1;
		}
		
		resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
		resultXML.append("<PAGECNT>" + totalPage + "</PAGECNT>");
		resultXML.append("<PERSONALCNT>" + perCount + "</PERSONALCNT>");
    	resultXML.append("<LISTVIEWDATA>");
    	
		resultXML.append("<ROWS>");
		for (CommunityBoardItemReadVO vo : readerList) {
			String userTitle = "";
			String userDeptName = "";

			// 2023-08-04 황인경 - 커뮤니티 > 게시판 > 조회자 정보 > 다국어 처리
			if (lang.equals("2")) {
				vo.setUserName(vo.getUserName2());
				vo.setUserTitle(vo.getUserTitle2());
				vo.setUserDeptName(vo.getUserDeptName2());
				vo.setUserCompanyName(vo.getUserCompanyName2());
			}

			if (vo.getUserTitle() != null) {
				userTitle = vo.getUserTitle();
			}
			if (vo.getUserDeptName() != null) {
				userDeptName =  vo.getUserDeptName();
			}

			resultXML.append("<ROW>");
			resultXML.append("<CELL><USERID><![CDATA[" + vo.getUserID() + "]]></USERID><DEPTID><![CDATA[" + vo.getDeptID() + "]]></DEPTID><VALUE><![CDATA[" + vo.getUserName() + "]]></VALUE></CELL>");
			resultXML.append("<CELL><VALUE><![CDATA[" + userDeptName + "]]></VALUE></CELL>");
			resultXML.append("<CELL><VALUE><![CDATA[" + userTitle + "]]></VALUE></CELL>");
			resultXML.append("<CELL><VALUE><![CDATA[" + commonUtil.getDateStringInUTC(vo.getReadDate(), offset, false) + "]]></VALUE></CELL>");
			resultXML.append("</ROW>");
		}
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");
		
		logger.debug("getReaderList ended");
		return resultXML;
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
		logger.debug("copyItem started");

		String editor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		
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
		
		copyFiles(pOrgItemID, pOrgBoardID, pDestItemID, pDestBoardID, pUploadFilePath, editor);
		
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
			attachments.append(destAttach + "|");
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
        sb.append("<WRITERNAME>" + commonUtil.cleanValue(item.getWriterName()) + "</WRITERNAME>");
        sb.append("<WRITERNAME2>" + commonUtil.cleanValue(item.getWriterName2()) + "</WRITERNAME2>");
        sb.append("<DEPTID>" + item.getWriterDeptID() + "</DEPTID>");
        sb.append("<DEPTNAME>" + commonUtil.cleanValue(item.getWriterDeptName()) + "</DEPTNAME>");
        sb.append("<DEPTNAME2>" + commonUtil.cleanValue(item.getWriterDeptName2()) + "</DEPTNAME2>");
        sb.append("<COMPANYID>" + item.getWriterCompanyID() + "</COMPANYID>");
        sb.append("<COMPANYNAME>" + commonUtil.cleanValue(item.getWriterCompanyName()) + "</COMPANYNAME>");
        sb.append("<COMPANYNAME2>" + commonUtil.cleanValue(item.getWriterCompanyName2()) + "</COMPANYNAME2>");
        sb.append("<IMPORTANCE>" + item.getImportance() + "</IMPORTANCE>");
        sb.append("<TITLE>" + commonUtil.cleanValue(item.getTitle()) + "</TITLE>");
        sb.append("<CONTENTLOCATION>" + item.getContentLocation() + "</CONTENTLOCATION>"); //복사의 경우만
        sb.append("<STARTDATE>" + item.getStartDate() + "</STARTDATE>");
        sb.append("<ENDDATE>" + item.getEndDate() + "</ENDDATE>");
        sb.append("<ABSTRACT>" + commonUtil.cleanValue(item.getAbsTract()) + "</ABSTRACT>");
        sb.append("<ATTACHMENTS>" + URLEncoder.encode(item.getAttachments(), "UTF-8") + "</ATTACHMENTS>");
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

        logger.debug("copyItem ended");

		return ret;
	}

	@Override
	public int guestOneGet1(String sRadio, String keyword, String code, String primary, int tenantID) throws Exception {
		logger.debug("guestOneGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_KEYWORD", keyword);
		map.put("v_CODE", code);
		map.put("v_S_RADIO", sRadio);
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.guestOneGet1(map);
		
		logger.debug("guestOntGet1 ended. result=" + result);
		
		return result;
	}

	@Override
	public CommunityCClubGuestVO guestEditGet(String code, String primary, String no, String id, int tenantID) throws Exception {
		logger.debug("guestEditGet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_code", code);
		map.put("primary", primary);
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
	public int commViewMemberGet2(String code, String primary, String keyword, String sRadio, String companyID, int tenantID, String selectGrade, String selectMonth, String offset) throws Exception {
		logger.debug("commViewMemberGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("primary", primary);
		map.put("v_KEYWORD", keyword);
		map.put("v_S_RADIO", sRadio.toUpperCase());
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		map.put("selectGrade", selectGrade);
		map.put("selectMonth", selectMonth);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));

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
	public CommunityMemberInfoVO commOutGet(String cSysopID, String companyID, String primary, int tenantID) throws Exception {
		logger.debug("commOutGet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_C_SYSOPID", cSysopID);
		map.put("v_COMPANYID", companyID);
		map.put("primary", primary);
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
		
		if (!c_Cate_A.equals("0")) {
			map = new HashMap<String, Object>();
			map.put("v_C_CODE", c_Cate_A);
			map.put("v_C_CAT", "a");
			map.put("tenantID", userInfo.getTenantId());
			
			cateA = ezCommunityDAO.ezCommunityBaseGet3(map);
		}
		
		// 2018-11-12 김민성 - 안쓰는 부분 주석처리
		/*if (!c_Cate_B.equals("0")) {
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
		}*/
		
		if (!cateA.equals("0")) {
			sb.append(egovMessageSource.getMessage("ezCommunity."+cateA, userInfo.getLocale()));
		}
		
		/*if (!cateB.equals("0")) {
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
		}*/
		
		logger.debug("categoryPrint ended.");
		
		return sb.toString();
	}

	@Override
	public String commOutOk(HttpServletRequest request, String loginCookie, String code, String reason) throws Exception {
		logger.debug("commOutOk started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String strReturn = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_USERINFO_USERID", userInfo.getId());
		map.put("tenantID", userInfo.getTenantId());
		
		//logger.debug("code="+ code);
		
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
			commOutOkSendMail(request, loginCookie, userInfo, code, reason);
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

		// 운영자 권한정보
		List<CommunityCClubUserVO> operatorList = getClubOperatorList(companyID, tenantID, code, id);

		if (!strSysopID.equals(id)){
			if (!commonUtil.isAdmin(id, tenantID, rollInfo, "c")) {
				if (strIsIN.equals("1") && strCompanyID.equals(companyID)) {
					sysopCheck = 1;
				} else if (operatorList != null && !operatorList.isEmpty()) {
					if (operatorList.get(0).getAdmin_Auth() != null) {
						sysopCheck = 1;
					}
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
	public CommunityMemberInfoVO aspCommInfoGet2(String primary, String sysopID, String companyID, int tenantID) throws Exception {
		logger.debug("aspCommInfoGet2 started.");
		//logger.debug("primary : " + primary + ", sysopID : " + sysopID + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("primary", primary);
		map.put("v_RECORD_C_SYSOPID", sysopID);
		map.put("companyID", companyID);
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
		map.put("read_Grade", clubVO.getMemlist_readGrade());
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.adminBasicOkupdate(map);
	}

	@Override
	public CommunityClubVO  adminLogoGet(String code, String primary, int tenantID) throws Exception {
		logger.debug("adminLogoGet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		
		CommunityClubVO vo = ezCommunityDAO.adminLogoGet(map);
		
		logger.debug("adminLogoGet ended.");
		
		return vo;
	}
	
	/**
	 * 로고와 썸네일 이미지 경로를 가져온다.
	 */
	@Override
	public CommunityClubVO  adminLogoGet2(String code, int tenantID) throws Exception {
		logger.debug("adminLogoGet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		CommunityClubVO vo = ezCommunityDAO.adminLogoGet2(map);
		
		logger.debug("adminLogoGet2 ended.");
		
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
	public void createBoardInsert(String code, String boardID, String boardName, String boardName2, String parentBoardID, String boardGroupID, String comatt, LoginVO userInfo, String readGrade, String writeGrade) throws Exception {
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
		map.put("readGrade", readGrade);
		map.put("writeGrade", writeGrade);

/*		logger.debug("code="+code);
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
		logger.debug("v_BOARDNO="+boardNo);*/
		
		ezCommunityDAO.createBoardInsertInsert1(map);
		/*ezCommunityDAO.createBoardInsertInsert2(map); accessID를 "everyone"으로만 insert하도록 해당 라인은 주석처리 */
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
		
		/* 2020-06-29 홍승비 - 상위게시판을 자신의 하위게시판 아래로 이동하지 못하도록 수정 */
		boolean canMove = true;
		boolean breakflag = false;
		String newParentBoardIDtemp = newParentBoardID;
		
		while (breakflag == false) {
			CommunityBoardPropertyVO newParentBoardProperty = getBoardProperty(newParentBoardIDtemp, tenantID);
			if (newParentBoardProperty != null) {
				if (newParentBoardProperty.getParentBoardID().equals(orgBoardID)) {
					canMove = false;
					breakflag = true;
				}
				newParentBoardIDtemp = newParentBoardProperty.getParentBoardID();
			} else {
				breakflag = true;
			}
		}
		
		if (canMove == false) {
			logger.debug("moveBoard canceled.");
			return "CANCEL";
		}
		
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
		
		/* 2024-07-16 홍승비 - 커뮤니티 팝업홈 > 관리메뉴 > 게시판 검색 시 카운트 쿼리에서 누락된 게시자명 다국어 검색조건 추가 */
		map.put("v_strLang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		
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
		
		/* 2018-10-02 홍승비 - 게시자의 writerDeptID를 가져오도록 수정 */
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
				sb.append("<WriterDeptID>" + commonUtil.cleanValue(board.getWriterDeptID()) + "</WriterDeptID>");
				sb.append("<WriterDeptName>" + commonUtil.cleanValue(board.getWriterDeptName()) + "</WriterDeptName>");
				sb.append("<WriterCompanyName>" + commonUtil.cleanValue(board.getWriterCompanyName()) + "</WriterCompanyName>");
				sb.append("<WriteDate>" + commonUtil.getDateStringInUTC(board.getWriteDate(), offset, false) + "</WriteDate>");
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
				sb.append("<Abstract>" + commonUtil.cleanValue(board.getAbsTract()) + "</Abstract>");
				sb.append("</NODE>");
			}
		}
		
		sb.append("</NODES>");
		
		logger.debug("adminSearchItemXML ended.");
//		logger.debug("adminSearchItemXML ended. result=" + sb.toString());
		
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
	public void adminOuterOkNoSet(String flag, String userID, String code, int tenantID, String companyID) throws Exception {
		logger.debug("adminOuterOkNoSet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		map.put("withDrawDate", commonUtil.getTodayUTCTime("yyyy-MM-dd"));

		if (flag.equals("OK")) {
			// ezCommunityDAO.adminOuterOkNoSetDelete1(map);
			ezCommunityDAO.commMemberOut(map); // 탈퇴자 count를 위해 delete하지 않고 update 처리
			ezCommunityDAO.adminOuterOkNoSetUpdate(map);
		}
		
		ezCommunityDAO.adminOuterOkNoSetDelete2(map);
		
		logger.debug("adminOuterOkNoSet started.");
	}

	@Override
	public int adminMemberListGet1(String code, String flag, String ser, String primary, int tenantID) throws Exception {
		logger.debug("adminMemberListGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FLAG", flag);
		map.put("v_SER", ser);
		map.put("v_CODE", code);
		map.put("primary", primary);
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
	public void adminMemberListOkGoSe(String mode, String code, String cID, String cNm, LoginVO userInfo) throws Exception {
		logger.debug("adminMemberListOkGoSe started.");
		//logger.debug("code=" + code + ", id=" + cID + ", Nm=" + cNm);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_USERID", cID);
		map.put("v_C_NM", cNm);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyID());
		map.put("withDrawDate", commonUtil.getTodayUTCTime(""));

		if (mode.equals("MASTER")) {
			ezCommunityDAO.adminMemberListGoSEUpdate1(map);
			updateMemberGrade(code, "1", Collections.singletonList(cID), userInfo.getCompanyID(), userInfo.getTenantId());
			updateMemberGrade(code, "3", Collections.singletonList(userInfo.getId()), userInfo.getCompanyID(), userInfo.getTenantId());
		} else {
			// ezCommunityDAO.adminMemberListGoSEDelete1(map);
			ezCommunityDAO.commMemberOut(map); // 탈퇴자 count를 위해 delete하지 않고 update 처리
			ezCommunityDAO.adminMemberListGoSEUpdate3(map);
			ezCommunityDAO.adminMemberListGoSEDelete2(map);			
		}
		
		logger.debug("adminMemberListOkGoSe ended.");
	}

	@Override
	public String saveBoardProperty(LoginVO userInfo, CommunityBoardInfoVO vo) throws Exception {
		logger.debug("saveBoardProperty started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardName", URLDecoder.decode(vo.getBoardName(), "utf-8"));
		map.put("v_pBoardName2", URLDecoder.decode(vo.getBoardName2(), "utf-8"));
		map.put("v_pBoardID", URLDecoder.decode(vo.getBoardID(), "utf-8"));
		map.put("v_pAttachMax", vo.getAttachSizeLimit());
		map.put("v_pDescription", URLDecoder.decode(vo.getBoardDescription(), "utf-8"));
		map.put("v_pExpires", vo.getItemExpires());
		map.put("v_pURL", vo.getUrl());
		map.put("v_pGubun", vo.getGubun());
		map.put("v_pReplyNotify", vo.getReplyNotify());
		map.put("v_pDeleteAfter", vo.getDeleteAfter());
		map.put("v_pBoardColor", URLDecoder.decode(vo.getBoardColor(), "utf-8"));
		map.put("v_pVersionUse", vo.getVersionUse());
		map.put("v_pCheckUse", vo.getCheckUse());
		map.put("v_pMailFG_Post", vo.getMailFG_Post());
		map.put("v_pMailFG_Mod", vo.getMailFG_Mod());
		map.put("v_pMailFG_Comment", vo.getMailFG_Comment());
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
	public void adminCommCloseOkInsert(String code, String commName, String commName2, String sysopID, String companyName, String companyId, String todayTime, String reason, String closeState, int tenantID) throws Exception {
		logger.debug("adminCommCloseOkInsert started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_COMMNAME", commName);
		map.put("v_COMMNAME2", commName2);
		map.put("v_SYSOPID", sysopID);
		map.put("v_COMPANYNAME", companyName);
		map.put("v_COMPANYID", companyId);
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
	public void joinOkSet1(String code, String id, String todayTime, String companyID, int tenantID, String joinGrade) throws Exception {
		logger.debug("joinOkSet1 started.");
		
		Map<String, Object> map =new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.joinOkSet1Update(map);
		
		map.put("v_USERINFO_USERID", id);
		map.put("v_pNow", todayTime);
		map.put("v_USERINFO_COMPANYID", companyID);
		map.put("joinGrade", joinGrade);

		int count = ezCommunityDAO.checkWithDrawUser(map);

		if (count > 0) {
			ezCommunityDAO.updateWithDrawUsertoRegist(map);
		} else {
			ezCommunityDAO.joinOkSet1Insert(map);
		}

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
		map.put("companyID", userInfo.getCompanyID());
		map.put("primary", userInfo.getPrimary());
		map.put("tenantID", userInfo.getTenantId());
		
		// TBL_C_MEMBERINFO에서 승인대기자를 받아올 때, 모든 겸직을 같이 받아와서 레코드 중복이 발생한다. 관리자의 현재 companyID로 조건을 걸어 distinct로 받아오자.
		// deptID도 받아오도록 한다.
		List<CommunityCClubUserVO> userList = ezCommunityDAO.adminMemPermitGet2(map);
		
		for (CommunityCClubUserVO user : userList) {
			sb.append("<tr>");
			sb.append("<td height=\"23\" align=\"center\">" + iCount + "</td>");
			sb.append("<td>");
            
            //logger.debug("lang = " + userInfo.getPrimary() + " || userID = " + user.getC_ID() + " || companyID = " + user.getCompanyID() + " || userName = " + user.getUserName());
            
            // 승인대기자의 정보를 표출할 때 해당 겸직부서(또는 원부서) 값을 같이 넘긴다.
            // userName을 알아서 분기태워 가져오므로(primary로 case 작업), userName2를 사용하지는 않는다.
            sb.append("<a href=\"javascript:openinfo( '" + code + "', '" + user.getC_ID().trim() + "', '" + user.getCompanyID().trim() + "','" + user.getDeptID() + "' )\">" + user.getUserName().trim() + "</a>");
            
            sb.append("</td>");
            sb.append("<td>" + commonUtil.cleanValue(user.getC_ID()) + "</td>");
            sb.append("<td align=\"center\">" + user.getC_inDate().trim().substring(0, 10) + "</td>");
            sb.append("<td align=\"center\">");
        	sb.append("<a class=\"imgbtn\"><span onclick=\"javascript:okno('ok','" + commonUtil.cleanValue(user.getC_ID().trim()) + "','" + code + "','" + curPage + "','" + commonUtil.cleanValue(user.getUserName().trim()) + "');\" style=\"width:40px\">" + egovMessageSource.getMessage("ezCommunity.t46", userInfo.getLocale()) + "</span></a>&nbsp;");
            sb.append("<a class=\"imgbtn\"><span onclick=\"javascript:okno('no','" + commonUtil.cleanValue(user.getC_ID().trim()) + "','" + code + "','" + curPage + "','" + commonUtil.cleanValue(user.getUserName().trim()) + "');\" style=\"width:40px\">" + egovMessageSource.getMessage("ezCommunity.t552", userInfo.getLocale()) + "</span></a>");
            sb.append("</td>");
            sb.append("</tr>");
            
            iCount ++;
		}
		
		logger.debug("adminMemPermit ended.");
		
		return sb.toString();
	}
	
	@Override
	public void okNoSet(String flag, String code, String cID, int tenantID, String joinGrade) throws Exception {
		logger.debug("okNoSet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_C_ID", cID);
		map.put("tenantID", tenantID);
		map.put("joinGrade", joinGrade);

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

	/* 2018-06-21 홍승비 - 오늘의 커뮤니티 표출 companyID 조건 추가 */
	@Override
	public int todayCopGet1(String companyID,  int tenantID) throws Exception {
		logger.debug("todayCopGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		int result = ezCommunityDAO.todayCopGet1(map);
		
		logger.debug("todayCopGet1 ended.");
		
		return result;
	}

	/* 2018-06-21 홍승비 - 오늘의 커뮤니티 표출 companyID 조건 추가 */
	@Override
	public CommunityClubVO todayCopGet2(int num, String companyID, int tenantID) throws Exception {
		logger.debug("todayCopGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("num", num);
		map.put("mariaNum", num -1);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		// 관리자(sysop)ID를 가져온다.
		// 해당 테넌트와 회사에 동시에 속한 레코드가 TBL_C_CLUB, TBL_usermaster 테이블에 존재하는지 조인하여 확인한다.
		String userID = ezCommunityDAO.todayCopGet2SelectUserID(map);
		int totalCount = ezCommunityDAO.todayCopGet2SelectTotalCount(map);
		
		map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		
		// 이미 위쪽 쿼리 2개에서 companyID로 걸러진 userID를 map에 넣어준다.
		int temp = ezCommunityDAO.todayCopGet2SelectTemp(map);
		
		map = new HashMap<String, Object>();
		map.put("temp", temp);
		map.put("num", num);
		map.put("mariaNum", num -1);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		if (num > totalCount) {
			num = totalCount;
			map.put("num", num);
			map.put("mariaNum", num -1);
		}
		
		// 오늘의 커뮤니티로 표출할 커뮤니티를 가져온다.
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
	public CommunityCCategoryVO mainPageCategory(String c_Code, String cat, String companyID, int tenantID) throws Exception {
		logger.debug("mainPageCategory started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", c_Code);
		map.put("cat", cat);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		CommunityCCategoryVO vo = ezCommunityDAO.mainPageCategory(map);
		
		logger.debug("mainPageCategory ended.");
		
		return vo;
	}

	/* 2018-06-21 홍승비 - 커뮤니티 메인홈 하단 카테고리별 커뮤니티 표출 companyID 조건 추가 */
	@Override
	public List<CommunityClubVO> categoryListGet(String type, String mode, int startRow, int endRow, int mariaStart, int mariaEnd, String companyID, int tenantID) throws Exception {
		logger.debug("categoryListGet started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", type);
		map.put("cat", mode);
		map.put("v_pStart", startRow);
		map.put("mariaStart", mariaStart);
		map.put("v_pEnd", endRow);
		map.put("mariaEnd", mariaEnd);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<CommunityClubVO> list = ezCommunityDAO.categoryListGet(map); 
		
		logger.debug("categoryListGet ended.");
		
		return list;
	}

	/* 2018-06-21 홍승비 - 커뮤니티 메인홈 하단 카테고리별 커뮤니티 검색 companyID 조건 추가 */
	@Override
	public List<CommunityClubVO> searchCop(String search, String keyword, int startRow, int endRow, String mode, String companyID, int tenantID) throws Exception {
		logger.debug("searchCop started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_searchName", search.toUpperCase()); // C_CLUBNAME, C_CLUBNAME2, C_CLUBDESC
		map.put("v_searchValue", keyword);
		map.put("v_pStart", startRow);
		map.put("mariaStart", startRow - 1);
		map.put("v_pEnd", endRow);
		map.put("mariaEnd", endRow - startRow + 1);
		map.put("v_mode", mode); // SEA (리스트), CNT (카운트)
		map.put("companyID", companyID);
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
		
		//logger.debug("id : " + id + ", pStartRow : " + pStartRow + ", pEndRow : " + pEndRow + ", pSortBy : " + pSortBy + ", tenantID : " + tenantID);
		
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
				sb.append("<BoardName>" + commonUtil.cleanValue(itemList.getBoardName()) + "</BoardName>");
				sb.append("<ItemID>" + itemList.getItemID() + "</ItemID>");
				sb.append("<WriterID>" + commonUtil.cleanValue(itemList.getWriterID()) + "</WriterID>");
				sb.append("<WriterName>" + commonUtil.cleanValue(itemList.getWriterName()) + "</WriterName>");
				sb.append("<WriterDeptName>" + commonUtil.cleanValue(itemList.getWriterDeptName()) + "</WriterDeptName>");
				sb.append("<WriterCompanyName>" + commonUtil.cleanValue(itemList.getWriterCompanyName()) + "</WriterCompanyName>");
				sb.append("<WriteDate>" + commonUtil.getDateStringInUTC(itemList.getWriteDate(), offset, false) + "</WriteDate>");
				sb.append("<Importance>" + itemList.getImportance() + "</Importance>");
				sb.append("<Title>" + commonUtil.cleanValue(itemList.getTitle()) + "</Title>");
				sb.append("<Attachments>" + commonUtil.cleanValue(itemList.getAttachments()) + "</Attachments>");
				sb.append("<ReadCount>" + itemList.getReadCount() + "</ReadCount>");
				sb.append("<ItemLevel>" + itemList.getItemLevel() + "</ItemLevel>");
				sb.append("<Abstract>" + commonUtil.cleanValue(itemList.getAbsTract()) + "</Abstract>");
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
		
		//logger.debug("result : " + result);
		logger.debug("getBoardTotalItemCount ended.");
		
		return result;
	}
	
	@Override
	public String getBoardListItemPhotoXML(LoginVO userInfo, String pBoardID, int pStartRow, int pEndRow, String pSortBy) throws Exception {
		StringBuilder sb = new StringBuilder();
		int count = 0;
		
		String id = userInfo.getId();
		String lang = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
		String offset = commonUtil.getMinuteUTC(userInfo.getOffset());
		int tenantID = userInfo.getTenantId();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", id);
		map.put("v_PBOARDID", pBoardID);
		map.put("v_PSORTBY", pSortBy);
		map.put("v_USERINFO_LANG", lang);
		map.put("v_PENDROW", pEndRow);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		map.put("offset", offset);
		
		/* 2024-07-11 홍승비 - SQL Injection 수정 > 정렬 조건을 쿼리 내부에서 분기처리 하도록 수정 (현재 포토게시판은 리스트 헤더 정렬 기능이 없고, 정렬 조건으로 공백만 전달됨) */
		if (!pSortBy.equals("")) {
			String orderCell = pSortBy.split(" ")[0].toUpperCase();
			String orderSort = pSortBy.split(" ").length > 1 ? pSortBy.split(" ")[1].toUpperCase() : "";
			
			map.put("v_orderCell", orderCell); // BOARDNAME, TITLE, WRITERCOMPANYNAME, WRITERDEPTNAME, WRITERNAME, WRITEDATE, ATTACHMENTS, READCOUNT
			map.put("v_orderSort", orderSort); // "" or DESC
		}
		
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
	            
	            /* 2018-05-18 홍승비 - 쿼리가 UTC시간에 offset을 적용한 writeDate를 가져오도록 수정*/
	            sb.append("<WriteDate>" + item.getWriteDate() + "</WriteDate>");	            
	            sb.append("<Importance>" + item.getImportance() + "</Importance>");
	            sb.append("<Title>" + commonUtil.cleanValue(item.getTitle()).trim() + "</Title>");
	            if (item.getAttachments() == null) {
	                sb.append("<Attachments></Attachments>");
	            } else {
	                sb.append("<Attachments>" + commonUtil.cleanValue(item.getAttachments()) + "</Attachments>");
	            }
	            sb.append("<ReadCount>" + item.getReadCount() + "</ReadCount>");
	            sb.append("<ItemLevel>" + item.getItemLevel() + "</ItemLevel>");
	            sb.append("<ReadFlag>" + item.getReadFlag() + "</ReadFlag>");
	            sb.append("<Abstract>" + commonUtil.cleanValue(item.getAbsTract()) + "</Abstract>");
	            /* 2018-05-02 홍승비 - 포토게시판 썸네일 파일명 가져오도록 수정 */
	            sb.append("<EXTENSIONATTRIBUTE4>" + commonUtil.cleanValue(item.getExtensionAttribute4()) + "</EXTENSIONATTRIBUTE4>");
	            // 수정(200700228) : 포토게시판 기능 추가 관련 ExtensionAttribute5(Small 이미지 경로) 값 가져오도록 수정함.
	            sb.append("<EXTENSIONATTRIBUTE5>" + commonUtil.cleanValue(item.getExtensionAttribute5()) + "</EXTENSIONATTRIBUTE5>");
	            /* 2018-05-07 홍승비 - 커뮤니티 포토게시판 댓글 표시 */
	            sb.append("<ONELINECNT>" + item.getOneLineCnt() + "</ONELINECNT>");
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

	public List<CommunityCClubGuestVO> guestOneGet2(String sRadio, String keyword, String code, String primary, int tenantID) throws Exception {
		logger.debug("guestOneGet2 started.");
		//logger.debug("sRadio : " + sRadio + ", keyword : " + keyword + ", code : " + code + ", primary : " + primary + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_s_radio", sRadio);
		map.put("v_keyword", keyword);
		map.put("v_code", code);
		map.put("primary", primary);
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
		//logger.debug("questionID : " + questionID);
		//logger.debug("pollSelect : " + pollSelect);
		Integer answerID = ezCommunityDAO.pollResOkSetSelect(map);
		//logger.debug("answerID : " + answerID);
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
	
	public CommunityMemberInfoVO commViewMemberGet3(String id, String companyID, String primary, int tenantID) throws Exception {
		logger.debug("commViewMemberGet3 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", id);
		map.put("v_COMPANYID", companyID);
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		
		CommunityMemberInfoVO vo = ezCommunityDAO.commViewMemberGet3(map);
		
		logger.debug("commViewMemberGet3 ended.");
		
		return vo;
	}
	
	public List<CommunityClubVO> leftCommunityGet3(String userID, int tenantID) throws Exception {
		logger.debug("leftCommunityGet3 started.");
		//logger.debug("userID : " + userID + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("tenantID", tenantID);
		
		List<CommunityClubVO> list = ezCommunityDAO.leftCommunityGet3(map);
		
		logger.debug("leftCommunityGet3 ended.");
		
		return list;
	}
	
	public List<CommunityBoardTreeVO> brdBoardTree(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSelectBy, String pExcludeBoardID, String pClubNo, int tenantID) throws Exception {
		logger.debug("brdBoardTree started.");
/*		logger.debug("pRootBoardID : " + pRootBoardID);
		logger.debug("pUserID : " + pUserID);
		logger.debug("pDeptID : " + pDeptID);
		logger.debug("pCompanyID : " + pCompanyID);
		logger.debug("pMode : " + pMode);
		logger.debug("pSelectBy : " + pSelectBy);
		logger.debug("pExcludeBoardID : " + pExcludeBoardID);
		logger.debug("pClubNo : " + pClubNo);*/
		
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
	
	/* 2018-07-02 홍승비 - 커뮤니티 회원목록 회원정보 표출 시 companyID 조건 추가 */
	public List<CommunityCClubUserVO> commViewMemberGet1(String code, String primary, String keyword, String sRadio, String companyID, int tenantID, String selectGrade, String orderCell, String orderOption, String selectMonth, String offset) throws Exception {
		logger.debug("commViewMemberGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_code", code);
		map.put("primary", primary);
		map.put("v_keyword", keyword);
		map.put("v_s_radio", sRadio.toUpperCase());
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("selectGrade", selectGrade);
		map.put("orderCell", orderCell);
		map.put("orderOption", orderOption);
		map.put("selectMonth", selectMonth);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));

		List<CommunityCClubUserVO> list = ezCommunityDAO.commViewMemberGet1(map);
		
		logger.debug("commViewMemberGet1 ended.");
		
		return list;
	}	
	
	public List<CommunityBoardInfoVO> getBoardList(String code, String primary, String position, int tenantID) throws Exception {
		logger.debug("getBoardList started.");
		//logger.debug("code : " + code + ", primary : " + primary + ", position : " + position + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("primary", primary);
		map.put("v_POSITION", position);
		map.put("tenantID", tenantID);
		
		List<CommunityBoardInfoVO> list = ezCommunityDAO.getBoardList(map);
		
		logger.debug("getBoardList ended.");
		
		return list;
	}
	
	/* 2018-06-22 홍승비 - 사간겸직 탈퇴희망자 companyID로 중복레코드 제거 */
	public List<CommunityCOutApplicationVO> adminOuterListGet2(String code, String primary, String companyID, int tenantID) throws Exception {
		logger.debug("adminOuterListGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("primary", primary);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<CommunityCOutApplicationVO> list = ezCommunityDAO.adminOuterListGet2(map);
		
		logger.debug("adminOuterListGet2 ended.");
		
		return list;
	}
	
	public List<CommunityCClubUserVO> adminMemberListGet3(String code, String flag, String primary, String ser, String companyID, int tenantID) throws Exception {
		logger.debug("adminMemberListGet3 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_FLAG", flag);
		map.put("primary", primary);
		map.put("v_SER", ser);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<CommunityCClubUserVO> list = ezCommunityDAO.adminMemberListGet3(map);
		
		logger.debug("adminMemberListGet3 ended.");
		
		return list;
	}

	/* 2018-06-21 홍승비 - MY커뮤니티 새글 표출 시 현재 companyID로 자신이 가입한 모든 CLUBNO 가져오도록 수정 */
	public List<String> myCommunityGet(String id, int pStart, int pEnd, String mode, String companyID, int tenantID) throws Exception {
		logger.debug("myCommunityGet started.");
		//logger.debug("id : " + id + ", pStart : " + pStart + ", pEnd : " + pEnd + ", mode : " + mode + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", id);
		map.put("v_PSTART", pStart);
		map.put("mariaStart", pStart);
		map.put("v_PEND", pEnd);
		map.put("mariaEnd", pEnd);
		map.put("v_MODE", mode);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<String> list = ezCommunityDAO.myCommunityGet(map);
		
		logger.debug("myCommunityGet ended.");
		
		return list;
	}
	
	public CommunityCBoardVO bbsEditOkGet1(String bName, String no, String code, int tenantID) throws Exception {
		logger.debug("bbsEditOkGet1 started");
		//logger.debug("bName : " + bName + ", no : " + no + ", code : " + code + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName.toUpperCase());
		map.put("v_NO", no);
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		CommunityCBoardVO vo = ezCommunityDAO.bbsEditOkGet1(map);
		
		logger.debug("bbsEditOkGet1 ended");
		
		return vo;
	}
	
	public CommunityClubVO commMakeOkGet1(String clubName, String cCateA, String cCateB, String cCateC, String lang, int tenantID) throws Exception {
		logger.debug("commMakeOkGet1 started.");
		//logger.debug("clubName : " + clubName + ", cCateA : " + cCateA + ", cCateB : " + cCateB + ", cCateC : " + cCateC + ", lang : " + lang + ", tenantID : " + tenantID);
		
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
		//logger.debug("pItemID : " + pItemID + ", pBoardID : " + pBoardID + ", upperItemIDTree : " + upperItemIDTree + ", parentWriteDate : " + parentWriteDate + ", tenantID : " + tenantID);
		
		String previousItemID = "", previousTitle = "", nextItemID = "", nextTitle = "", tempItemID = "", tempTitle = "";
		Map<String, Object> map;
		List<CommunityBoardItemVO> list;
		
		map = new HashMap<String, Object>();
		map.put("v_pParentWriteDate", parentWriteDate);
		map.put("v_pUpperItemIDTree", upperItemIDTree.substring(0, 38));
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
			map.put("v_pUpperItemIDTree", upperItemIDTree.substring(0, 38));
			map.put("v_previousItemID", previousItemID);
			map.put("v_pNow", commonUtil.getTodayUTCTime(""));
			map.put("tenantID", tenantID);
			
			logger.debug("getAdjacentItemsGet3 started. " + previousItemID);
			
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
		//logger.debug("pRootBoardID : " + pRootBoardID + ", id : " + id + ", deptID : " + deptID + ", companyID : " + companyID + ", tenantID : " + tenantID);
		
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
		//logger.debug("strSelCateA : " + strSelCateA + ", tenantID : " + userInfo.getTenantId());
		
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
		//logger.debug("strSelCateB : " + strSelCateB + ", tenantID : " + userInfo.getTenantId());
		
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
		//logger.debug("strSelCateC : " + strSelCateC + ", tenantID : " + userInfo.getTenantId());
		
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
	
	public String getBoardTreeGet1(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String primary, int tenantID) throws Exception {
		logger.debug("getBoardTreeGet1 started.");
		//logger.debug("pRootBoardID : " + pRootBoardID + ", pUserID : " + pUserID + ", pDeptID : " + pDeptID + ", pCompanyID : " + pCompanyID + ", pMode : " + pMode + ", pSubFlag : " + pSubFlag);
		//logger.debug("pSelectBy : " + pSelectBy + ", pExcludeBoardID : " + pExcludeBoardID + ", pClubNo : " + pClubNo + ", primary : " + primary + ", tenantID : " + tenantID);
		
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
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.getBoardTreeGet1(map);
		
		//logger.debug("result : " + result);
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
	
	/* 2024-07-11 홍승비 - SQL Injection 수정 > 의미없는 칼럼 셀렉트 분기처리 제거 (maxIdFieldName값은 항상 C_NO 칼럼을 전달함) */
	public int bbsEditOkGet2(String maxIdFieldName, String bName, String code, int tenantID) throws Exception {
		logger.debug("bbsEditOkGet2 started.");
		//logger.debug("maxIdFieldName : " + maxIdFieldName + ", bName : " + bName + ", code : " + code + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName.toUpperCase());
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		int result = ezCommunityDAO.bbsEditOkGet2(map);
		
		logger.debug("bbsEditOkGet2 ended.");
		
		return result;
	}
	
	public String bbsEditOkGet3(String maxIdFieldName, String bName, String code, int maxNum, int tenantID) throws Exception {
		logger.debug("bbsEditOkGet3 started.");
		//logger.debug("maxIdFieldName : " + maxIdFieldName + ", bName : " + bName + ", code : " + code + ", strMaxNum : " + maxNum + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName.toUpperCase());
		map.put("v_CODE", code);
		map.put("v_STRMAXNUM", Integer.toString(maxNum));
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.bbsEditOkGet3(map);
		
		logger.debug("bbsEditOkGet3 ended.");
		
		return result;
	}
	
	public String commMakeOkGet6(String companyID, String id, int tenantID) throws Exception {
		logger.debug("commMakeOkGet6 started.");
		//logger.debug("companyID : " + companyID + ", id : " + id + ", tenantID : " + tenantID);
		
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
		int tenantID = userInfo.getTenantId();
		
		int count = 0;
		StringBuilder sb = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("primary", userInfo.getPrimary());
		map.put("v_PUSERID", id);
		map.put("v_PBOARDID", pBoardID);
		map.put("v_PSORTBY", pSortBy);
		map.put("v_PENDROW", pEndRow);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		/* 2024-07-11 홍승비 - SQL Injection 수정 > 정렬 조건을 쿼리 내부에서 분기처리 하도록 수정 */
		if (!pSortBy.equals("")) {
			String orderCell = pSortBy.split(" ")[0].toUpperCase();
			String orderSort = pSortBy.split(" ").length > 1 ? pSortBy.split(" ")[1].toUpperCase() : "";
			
			map.put("v_orderCell", orderCell); // BOARDNAME, TITLE, WRITERCOMPANYNAME, WRITERDEPTNAME, WRITERNAME, WRITEDATE, ATTACHMENTS, READCOUNT
			map.put("v_orderSort", orderSort); // "" or DESC
		}
		
		/* 2018-10-02 홍승비 - 게시자의 writerDeptID를 가져오도록 수정 */
		List<CommunityBoardListVO> list = ezCommunityDAO.boardItemListGet2(map);
		
		sb.append("<NODES>");
		
		for (CommunityBoardListVO boardList : list) {
			count++;
			
			if (count >= pStartRow) {
				sb.append("<NODE>");
				sb.append("<ItemID>" + boardList.getItemID() + "</ItemID>");
				sb.append("<WriterID>" + commonUtil.cleanValue(boardList.getWriterID()) + "</WriterID>");
				sb.append("<WriterName>" + commonUtil.cleanValue(boardList.getWriterName()) + "</WriterName>");
				sb.append("<WriterDeptID>" + commonUtil.cleanValue(boardList.getWriterDeptID()) + "</WriterDeptID>");
				sb.append("<WriterDeptName>" + commonUtil.cleanValue(boardList.getWriterDeptName()) + "</WriterDeptName>");
				sb.append("<WriterCompanyName>" + commonUtil.cleanValue(boardList.getWriterCompanyName()) + "</WriterCompanyName>");
				sb.append("<WriteDate>" + commonUtil.getDateStringInUTC(boardList.getWriteDate(), offset, false) + "</WriteDate>");
				sb.append("<Importance>" + boardList.getImportance() + "</Importance>");
				sb.append("<Title>" + commonUtil.cleanValue(boardList.getTitle()) + "</Title>");
				sb.append("<Attachments>" + boardList.getAttachments() + "</Attachments>");
				sb.append("<EXT>" + commonUtil.cleanValue(boardList.getExt()) + "</EXT>");
				sb.append("<FILEPATH>" + commonUtil.cleanValue(boardList.getFilePath()) + "</FILEPATH>");
				sb.append("<ReadCount>" + boardList.getReadCount() + "</ReadCount>");
				sb.append("<ItemLevel>" + boardList.getItemLevel() + "</ItemLevel>");
				sb.append("<ReadFlag>" + boardList.getReadFlag() + "</ReadFlag>");
				sb.append("<Abstract>" + commonUtil.cleanValue(boardList.getAbsTract()) + "</Abstract>");
				/* 2018-05-04 홍승비 - 커뮤니티 게시판 리스트에서 댓글 수 표시하기 */
				sb.append("<OneLineCnt>" + boardList.getOneLineCnt() + "</OneLineCnt>");	
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
	
	public String pollResGet4(String primary, String pollRegUser, String companyID, int tenantID) throws Exception {
		logger.debug("pollResGet4 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("primary", primary);
		map.put("v_POLLREGUSER", pollRegUser);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityDAO.pollResGet4(map);
		
		logger.debug("pollResGet4 ended.");
		
		return result;
	}
	
	public String getClubMemberInfo(String pCN, String pSearch, String primary, int tenantID) throws Exception {
		Document xmlDoc = commonUtil.convertStringToDocument(ezOrganService.getPropertyList(pCN, pSearch, primary, tenantID));
		
		//logger.debug("xmlDoc DESCRIPTION1      ::     " + xmlDoc.getElementsByTagName("DESCRIPTION1").item(0).getTextContent());
		//logger.debug("xmlDoc DESCRIPTION2      ::     " + xmlDoc.getElementsByTagName("DESCRIPTION2").item(0).getTextContent());
		
		if (primary.equals("2")) {
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
		//logger.debug("tenantID : " + tenantID);
		
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
	
	public String getReverseDateNow() throws Exception {
		ZoneId utc = ZoneId.of("UTC");
		ZonedDateTime getTime = ZonedDateTime.of(LocalDateTime.now(utc), utc);
		
		String result = Integer.toString(9999 - getTime.getYear()) +
						Integer.toString(22 - getTime.getMonthValue()) +
						Integer.toString(41 - getTime.getDayOfMonth()) +
						Integer.toString(33 - getTime.getHour()) +
						Integer.toString(69 - getTime.getMinute()) +
						Integer.toString(69 - getTime.getSecond()) +
						Integer.toString(999 - getTime.getNano()/1000000);
		
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
		PrintWriter pw = null;
		
		try {
			docPath = realPath + strFilePath;
			docPath = commonUtil.detectPathTraversal(docPath);
			strBoardID = commonUtil.detectPathTraversal(strBoardID);
			
			if (!new File(docPath + strBoardID).exists()) {
				File dir1 = new File(docPath + strBoardID + commonUtil.separator + "uploadFile");
				File dir2 = new File(docPath + strBoardID + commonUtil.separator + "doc");
				dir1.mkdirs();
				dir2.mkdirs();
			}
			
			mhtFilePath = docPath + strBoardID + commonUtil.separator + "doc" + commonUtil.separator + strMHTFileName + ".mht";
			mhtFilePath = commonUtil.detectPathTraversal(mhtFilePath);
			
			if(new File(mhtFilePath).exists()) {
				new File(mhtFilePath).delete();
			}
			
			pw = new PrintWriter(new File(mhtFilePath));
			pw.print(commonUtil.stripScriptTags(strHTML));
			pw.flush();
			pw.close();
			
			return true;
		} catch(Exception e) {
			logger.debug("saveMHT ERROR");
			logger.error(e.getMessage());
			return false;
		} finally {
			IOUtils.closeQuietly(pw);
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

		//logger.debug("attachments : + " + attachments + ", itemID : " + itemID + ", boardID : " + boardID + ", thumbPath : " + thumbPath + ", fileName : " + fileName);
		
		try {
/*			if (!attachments.substring(attachments.length() - 1).equals(";")) {
				attachments += ";";
			}*/
			
			//baonk added
			if (!attachments.substring(attachments.length() - 1).equals("|")) {
				attachments += "|";
			}
			//end			
			
			//String[] attachmentsArr = attachments.split(";");
			String[] attachmentsArr = attachments.split("\\|"); //baonk added
			
			Map<String, Object> map2 = new HashMap<String, Object>();
			map2.put("v_pItemID", itemID);
			map2.put("tenantID", tenantID);
			List<CommunityBoardItemAttachmentVO> orgFileList = ezCommunityDAO.getItemAttachmentXML(map2);
			if (orgFileList.size() > 0) {
				String folder = realPath + pUploadFilePath;
				for (CommunityBoardItemAttachmentVO itemAttachment : orgFileList) {
					boolean match = false;
					
					for (String attach : attachmentsArr) {
						if (itemAttachment.getFilePath().equals(attach)) {
							match = true;
							break;
						}
					}
					if (!match) {
						String strFile = folder + itemAttachment.getFilePath();
						File file = new File(commonUtil.detectPathTraversal(strFile));
						
						if (file.exists()) {
							file.delete();
						}
					}
				}
			}
			
			ezCommunityDAO.newItemDel(map2);
			
			for (int i = 0; i < attachmentsArr.length; i++) {
				map = new HashMap<String, Object>();
				map.put("tenantID", tenantID);
				
				File file = new File(commonUtil.detectPathTraversal(realPath + pUploadFilePath + attachmentsArr[i]));
				fileSize = Integer.toString((int) file.length());
				filePath = attachmentsArr[i];
				
				if (attachmentsArr[i].indexOf("tempUploadFile") > -1) {
					String destFilePath = commonUtil.detectPathTraversal(realPath + pUploadFilePath + boardID + commonUtil.separator + "uploadFile" + commonUtil.separator + filePath.replace("tempUploadFile", ""));
					File destFile = new File(destFilePath);
					FileUtils.moveFile(file, destFile);
					filePath = filePath.replace("tempUploadFile", "");
				}
				
				if (!thumbPath.equals("")) {
					File thumbnailFile = new File(commonUtil.detectPathTraversal(realPath + pUploadFilePath  + thumbPath.split(";")[i]));
					map.put("itemID", itemID);
					
					if (thumbPath.indexOf("tempUploadFile") > -1) {
						String destThumbFilePath = commonUtil.detectPathTraversal(realPath + pUploadFilePath  + boardID + commonUtil.separator + "uploadFile" + thumbPath.split(";")[i].replace("tempUploadFile", ""));
						File destThumbFile = new File(destThumbFilePath);
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
	
	public void getBoardTreeSet(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String primary, String result, int tenantID) throws Exception {
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
		map.put("primary", primary);
		map.put("v_result", result);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.deleteBoardTreeChache(map);
		ezCommunityDAO.insertBoardTreeChache(map);
		
		logger.debug("getBoardTreeSet ended.");
	}
	
	public void bbsEditOkSet1(String bName, String title, String no, String code, String attachList, String textContent, int tenantID) throws Exception {
		logger.debug("bbsEditOkSet1 started.");
		//logger.debug("bName : "+ bName + ", title : " + title + ", no : " + no + ", code : " + code + ", attachList : " + attachList + ", textContent : " + textContent);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName.toUpperCase());
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
		//logger.debug("bName : " + bName);		
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName.toUpperCase());
		map.put("v_myRef", myRef);
		map.put("v_myStep", myStep);
		map.put("v_code", code);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.bbsEditOkSet2(map);
		
		logger.debug("bbsEditOkSet2 ended.");
	}
	
	/* 2024-07-11 홍승비 - SQL Injection 수정 > 의미없는 칼럼 셀렉트 분기처리 제거 (maxIdFieldName값은 항상 C_NO 칼럼을 전달함) */
	public void bbsEditOkInsert(String bName, int myRef, int newStep, int newLevel, String attachList, int number, String textContent, String nowDate, String fileName, String code, String companyID, String id, String userNm, String userNm2, String title, String maxIdFieldName, String no, int tenantID) throws Exception {
		logger.debug("bbsEditOkInsert started.");
/*		logger.debug("bName : " + bName + ", myRef : " + myRef + ", newStep : " + newStep + ", newLevel : " + newLevel + ", attachList : " + attachList + ", number : " + number);
		logger.debug(", textContent : " + textContent + ", nowDate : " + nowDate + ", fileName : " + fileName + ", code : " + code + ", companyID : " + companyID + ", id : " + id);
		logger.debug(", userNm : " + userNm + ", userNm2 : " + userNm2 + ", title : " + title + ", maxIdFieldName : " + maxIdFieldName + ", tenantID : " + tenantID);
		*/
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName.toUpperCase());
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
		map.put("v_NO", no); // TBL_C_BOARD에 등록될 공지사항 답변인 경우, 전달받은 부모 공지사항의 no값이 존재한다면 UPPERNO 칼럼에 기록
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.bbsEditOkInsert(map);
		
		logger.debug("bbsEditOkInsert ended.");
	}

	public void bbsDelOkDel(String bName, String itemNo, String code, int tenantID) throws Exception {
		logger.debug("bbsDelOkDel started.");
		//logger.debug("bName : " + bName + ", itemNo : " + itemNo + ", code : " + code + ", tenantID : " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BNAME", bName.toUpperCase());
		map.put("v_NO", itemNo);
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		logger.debug("bbsDelOkDel started.");
		
		ezCommunityDAO.bbsDelOkDel(map);
		ezCommunityDAO.bbsDelOkDelAttach(map);
	}
	
	public void commMakeOkInsert2(int clubNo, String clubName, String clubName2, String cCateA, String cCateB, String cCateC, String clubType, String clubConfirmType, String intro, int isIn, String logo, String thumb, String bBoardName1, String bBoardName2, String comatt, String code, String bNotiName1, String bNotiName2, String pNewID, int boardNo, String id, String displayName1, String companyName1, String deptName1, String pNewSubID, int openEmail, int openHp, int openComp, int openHouse, int openJob, int openBirth, int openSex, String companyID, int tenantID) throws Exception {
		logger.debug("commMakeOkInsert2 started.");
		//logger.debug("clubNo : " + clubNo + ", clubName : " + clubName + ", tenantID : " + tenantID);
		
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
		map.put("v_LOGO_THUMBNAIL", thumb);
		map.put("v_BANNER", thumb);
		map.put("v_USERINFO_COMPANYID", companyID);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.insertClub(map);
		
		map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_BOARDID", pNewID);
		map.put("v_B_BOARD_NAME1", bBoardName1);
		map.put("v_B_BOARD_NAME2", bBoardName2);
		map.put("v_PARENTBOARDID", "top");
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

		// accessID를 "everyone"으로만 insert하도록 해당 부분은 주석처리
		/*map = new HashMap<String, Object>();
		map.put("v_BOARDID", pNewID);
		map.put("v_ACCESSID", id);
		map.put("v_ACCESSNAME", displayName1 + "(" + companyName1 + ", " + deptName1 + ")");
		map.put("v_ACCESSLEVEL", 1);
		map.put("v_ACCESS_", 1);
		map.put("v_PARENTBOARDID", "top");
		map.put("v_BOARDADMIN_FG", "true");
		map.put("v_LISTVIEW_FG", "true");
		map.put("v_READ_FG", "true");
		map.put("v_WRITE_FG", "true");
		map.put("v_REPLY_FG", "true");
		map.put("v_DELETE_FG", "true");
		map.put("v_INHERIT_FG", "true");
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.insertCommBoardManage(map);
		
		map = new HashMap<String, Object>();
		map.put("v_BOARDID", pNewSubID);
		map.put("v_ACCESSID", id);
		map.put("v_ACCESSNAME", displayName1 + "(" + companyName1 + ", " + deptName1 + ")");
		map.put("v_ACCESSLEVEL", 1);
		map.put("v_ACCESS_", 1);
		map.put("v_PARENTBOARDID", pNewID);
		map.put("v_BOARDADMIN_FG", "true");
		map.put("v_LISTVIEW_FG", "true");
		map.put("v_READ_FG", "true");
		map.put("v_WRITE_FG", "true");
		map.put("v_REPLY_FG", "true");
		map.put("v_DELETE_FG", "true");
		map.put("v_INHERIT_FG", "true");
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.insertCommBoardManage(map);*/

		// 1~10까지의 등급 존재 가능 (1:마스터, 2:운영자, 3:정회원, 4:준회원, ... , 10: 손님)
		// 초기 등급 - 1:마스터, 2:운영자, 3:정회원, 4:준회원, 10:손님
		// 게시판별 권한을 등급으로 설정 가능
		map = new HashMap<String, Object>();
		map.put("v_BOARDID", pNewID);
		map.put("v_ACCESSID", "everyone");
		map.put("v_ACCESSNAME", "everyone");
		map.put("v_ACCESSLEVEL", null);
		map.put("v_ACCESS_", 1);
		map.put("v_PARENTBOARDID", "top");
		map.put("v_BOARDADMIN_FG", "1"); // 마스터만 가능(디폴트)
		map.put("v_LISTVIEW_FG", "10"); // 리스트권한:손님이상(디폴트)
		map.put("v_READ_FG", "4"); // 읽기권한:정회원이상(사용자 설정 가능)
		map.put("v_WRITE_FG", "3"); // 쓰기권한:준회원이상(사용자 설정 가능)
		map.put("v_REPLY_FG", "3"); // 답글권한:쓰기권한과 동일(디폴트)
		map.put("v_DELETE_FG", "2"); // 삭제권한:운영자이상(디폴트)
		map.put("v_INHERIT_FG", "1"); // 마스터만 가능(디폴트)
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.insertCommBoardManage(map);
		
		map = new HashMap<String, Object>();
		map.put("v_BOARDID", pNewSubID);
		map.put("v_ACCESSID", "everyone");
		map.put("v_ACCESSNAME", "everyone");
		map.put("v_ACCESSLEVEL", null);
		map.put("v_ACCESS_", 1);
		map.put("v_PARENTBOARDID", pNewID);
		map.put("v_BOARDADMIN_FG", "1");
		map.put("v_LISTVIEW_FG", "10");
		map.put("v_READ_FG", "4");
		map.put("v_WRITE_FG", "3");
		map.put("v_REPLY_FG", "3");
		map.put("v_DELETE_FG", "2");
		map.put("v_INHERIT_FG", "1");
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
		
		map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);

		ezCommunityDAO.insertClubGrade(map); // 1~4,10등급 (마스터, 운영자, 정회원, 준회원, 손님) 디폴트로 insert

		logger.debug("commMakeOkInsert2 ended.");
	}
	
	/*
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
	 */
	/* 2018-05-02 홍승비 - 커뮤니티 생성 시 로고, 썸네일 사이즈 저장 통합 */
	public void commMakeOkSet1(int logoSize, int thumbSize, String code, int tenantID) throws Exception {
		logger.debug("commMakeOkSet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LOGOFILESIZE", logoSize);
		map.put("v_THUMBFILESIZE", thumbSize);
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);

		ezCommunityDAO.commMakeOkSet1Insert(map);
		
		logger.debug("commMakeOkSet1 ended.");
	}

	//logo(상단 이미지) 저장
	public void commMakeOkSet3(String logoFileName, String fileName, int fileSize, int tenantID) throws Exception {
		logger.debug("commMakeOkSet3 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LOGOFILENAME", logoFileName);
		map.put("v_FILENAME", fileName);
		map.put("v_FILESIZE", fileSize);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.commMakeOkSet3Update(map);
		ezCommunityDAO.commMakeOkSet1Insert(map);
		
		logger.debug("commMakeOkSet3 ended.");
	}
	//thumbnail(대표 이미지) 저장
	public void commMakeOkSet4(String thumbFileName, String fileName, int fileSize, int tenantID) throws Exception {
		logger.debug("commMakeOkSet4 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_THUMBFILENAME", thumbFileName);
		map.put("v_FILENAME", fileName);
		map.put("v_FILESIZE", fileSize);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.commMakeOkSet4Update(map);	
		
		int count = ezCommunityDAO.commMakeOkSet2Select(map);
		logger.debug("commMakeOkSet4Select count="+count);
		
		if (count > 0 ) {
			ezCommunityDAO.commMakeOkSet2Update1(map);
		} else {
			ezCommunityDAO.commMakeOkSet2Insert(map);
		}
		
		logger.debug("commMakeOkSet4 ended.");
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
	
	/* 2018-04-30 홍승비 - 커뮤니티 로고,썸네일 수정 시 DB접근 통합 */
	public void adminLogoOkUpdate1(String logoFileNameLogo, String logoFileNameThumbnail, String copType, String fileName, int tenantID) throws Exception {
		logger.debug("adminLogoOkUpdate1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LOGOFILENAME", logoFileNameLogo);
		map.put("v_LOGOFILENAME_THUMBNAIL", logoFileNameThumbnail);
		map.put("v_COPTYPE", copType);
		map.put("v_FILENAME",  fileName);
		map.put("tenantID", tenantID);
		
		ezCommunityDAO.adminLogoOkUpdate1(map);
		
		logger.debug("adminLogoOkUpdate1 ended.");
	}
	//상단 이미지 저장
		public void adminLogoOkUpdate2(String logoFileNameLogo, String fileName, int tenantID) throws Exception {
			logger.debug("adminLogoOkUpdate2 started.");
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_LOGOFILENAME", logoFileNameLogo);
			map.put("v_FILENAME",  fileName);
			map.put("tenantID", tenantID);
			
			ezCommunityDAO.adminLogoOkUpdate2(map);
			
			logger.debug("adminLogoOkUpdate2 ended.");
		}
		//썸네일 저장
		public void adminLogoOkUpdate3(String logoFileNameThumbnail, String fileName, int tenantID) throws Exception {
			logger.debug("adminLogoOkUpdate3 started.");
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_LOGOFILENAME_THUMBNAIL", logoFileNameThumbnail);
			map.put("v_FILENAME",  fileName);
			map.put("tenantID", tenantID);
			
			ezCommunityDAO.adminLogoOkUpdate3(map);
			
			logger.debug("adminLogoOkUpdate3 ended.");
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

	public void copyFiles(String pOrgItemID, String pOrgBoardID, String pDestItemID, String pDestBoardID, String pRef, String editor) throws Exception {
        
		String orgFilePath = "";
        String destFilePath = "";
		
		if (!editor.equals("HWP")) {
			orgFilePath = commonUtil.detectPathTraversal(pRef + pOrgBoardID + commonUtil.separator + "doc" + commonUtil.separator + pOrgItemID + ".mht");
			destFilePath = commonUtil.detectPathTraversal(pRef + pDestBoardID + commonUtil.separator + "doc" + commonUtil.separator + pDestItemID + ".mht");
		} else {
			orgFilePath = commonUtil.detectPathTraversal(pRef + pOrgBoardID + commonUtil.separator + "doc" + commonUtil.separator + pOrgItemID + ".hwp");
			destFilePath = commonUtil.detectPathTraversal(pRef + pDestBoardID + commonUtil.separator + "doc" + commonUtil.separator + pDestItemID + ".hwp");
		}

        File destdir = new File(commonUtil.detectPathTraversal(pRef + pDestBoardID));
        if (!destdir.exists()) {
        	destdir.mkdirs();
        	File destdir1 = new File(commonUtil.detectPathTraversal(pRef + pDestBoardID + commonUtil.separator + "doc"));
        	destdir1.mkdirs();
        	File destdir2 = new File(commonUtil.detectPathTraversal(pRef + pDestBoardID + commonUtil.separator + "uploadFile"));
        	destdir2.mkdirs();
        }
        
        File orgFile = new File(orgFilePath);
        File destFile = new File(destFilePath);
        
        FileCopyUtils.copy(orgFile, destFile);
	}
	
	public void copyAttachments(String pOrgFilePath, String pDestFilePath, String pDestBoardID, String pRef) throws Exception {
        File destdir = new File(commonUtil.detectPathTraversal(pRef + pDestBoardID));
        if (!destdir.exists()) {
        	destdir.mkdirs();
        	File destdir1 = new File(commonUtil.detectPathTraversal(pRef + pDestBoardID + commonUtil.separator + "doc"));
        	destdir1.mkdirs();
        	File destdir2 = new File(commonUtil.detectPathTraversal(pRef + pDestBoardID + commonUtil.separator + "uploadFile"));
        	destdir2.mkdirs();
        }
        
        File orgFile = new File(commonUtil.detectPathTraversal(pRef + pOrgFilePath));
        File destFile = new File(commonUtil.detectPathTraversal(pRef + pDestFilePath));
        
        FileCopyUtils.copy(orgFile, destFile);
	}

	@Override
	public String adminLogoUpload(String code, String realPath, String logoPath, MultipartFile logoFile, int tenantId) throws Exception {
		String oriFileName = logoFile.getOriginalFilename();
		String logoFileName = code + "_logo_Temp" + oriFileName.substring(oriFileName.lastIndexOf("."));
		
		File logoDir = new File(commonUtil.detectPathTraversal(realPath + commonUtil.separator + logoPath));
		File logo = new File(commonUtil.detectPathTraversal(realPath + commonUtil.separator + logoPath + commonUtil.separator + logoFileName));
		
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
	
	public String adminThumbUpload(String code, String realPath, String thumbPath, MultipartFile thumbFile, int tenantId) throws Exception {
		String oriFileName = thumbFile.getOriginalFilename();
		String thumbFileName = code + "_thumb_Temp" + oriFileName.substring(oriFileName.lastIndexOf("."));
		
		File thumbDir = new File(commonUtil.detectPathTraversal(realPath + commonUtil.separator + thumbPath));
		File thumb = new File(commonUtil.detectPathTraversal(realPath + commonUtil.separator + thumbPath + commonUtil.separator + thumbFileName));
		
		String result = "";
		try {
			if (!thumbDir.isDirectory()) {
				boolean _flag = thumbDir.mkdirs();
				if (!_flag) {
				    throw new IOException("Directory creation Failed ");
				}
			}
			
			thumbFile.transferTo(thumb);
			
			result = thumbFileName;
		} catch (IOException e) {
			logger.error(e.getMessage());
		}
		
		return result;
	}
	
	@Override
	public void joinOkSendMail(HttpServletRequest request, String loginCookie, LoginVO userInfo, CommunityClubVO clubVO) throws Exception {
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
		String clubName = getClubNameLocalization(userInfo.getLang(), clubVO);
		
		if (vo.getEmail() != null) {
			String subject = "";
			String bodyContent = "";
			String notiSubType = "";
			// 2023-08-18 황인경 - 커뮤니티 > 사용자 가입시 관리자가 받는 메일 제목, 본문 수정
			if (clubVO.getC_ClubConfirmType().equals("3")) {
				subject = "[" + clubName + "]" + userInfo.getDisplayName() + " " + egovMessageSource.getMessage("ezCommunity.t1531", userInfo.getLocale());
				bodyContent += "[" + clubVO.getC_ClubName() + "]" + userInfo.getDisplayName() + "[" + userInfo.getDeptName() + "] " + egovMessageSource.getMessage("ezCommunity.t1531", userInfo.getLocale());
				bodyContent += "<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t1533", userInfo.getLocale());
				notiSubType = "APPLY";
			} else {
				subject = "[" + clubName + "]" + userInfo.getDisplayName() + " " + egovMessageSource.getMessage("ezCommunity.t1532", userInfo.getLocale());
				bodyContent += "[" + clubVO.getC_ClubName() + "]" + userInfo.getDisplayName() + "[" + userInfo.getDeptName() + "] " + egovMessageSource.getMessage("ezCommunity.t1532", userInfo.getLocale());
				notiSubType = "JOIN";
			}
			
//			if (clubVO.getC_ClubConfirmType().equals("3")) {
//				subject = "[" + clubVO.getC_ClubName() + "]Community" + egovMessageSource.getMessage("ezCommunity.t720", userInfo.getLocale()) + userInfo.getDisplayName() + " " + egovMessageSource.getMessage("ezCommunity.t1531", userInfo.getLocale());
//				bodyContent += "[" + clubVO.getC_ClubName() + "]Community" + egovMessageSource.getMessage("ezCommunity.t720", userInfo.getLocale()) + userInfo.getDisplayName() + "[" + userInfo.getDeptName() + "] " + egovMessageSource.getMessage("ezCommunity.t1531", userInfo.getLocale());
//				bodyContent += "<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t1533", userInfo.getLocale());
//			} else {
//				subject = "[" + clubVO.getC_ClubName() + "]Community" + egovMessageSource.getMessage("ezCommunity.t720", userInfo.getLocale()) + userInfo.getDisplayName() + " " + egovMessageSource.getMessage("ezCommunity.t1532", userInfo.getLocale());
//				bodyContent += "[" + clubVO.getC_ClubName() + "]Community" + egovMessageSource.getMessage("ezCommunity.t720", userInfo.getLocale()) + userInfo.getDisplayName() + "[" + userInfo.getDeptName() + "] " + egovMessageSource.getMessage("ezCommunity.t1532", userInfo.getLocale());
//			}
        	
        	String content = commonUtil.createNotiMailContent(bodyContent, userInfo.getTenantId(), userInfo.getLocale());
        
        	InternetAddress from = new InternetAddress();
        	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
        	from.setAddress(userInfo.getEmail());
        	
        	InternetAddress to = new InternetAddress();
        	to.setPersonal(vo.getDisplayName(), "UTF-8");
        	to.setAddress(vo.getEmail());
        	
        	//logger.debug("from = " + userInfo.getEmail());
        	//logger.debug("to = " + vo.getEmail());
        	ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, content, false);
        	
        	String linkUrl = "/ezCommunity/checkCommHome.do?communityCD=" + clubVO.getC_ClubNo();
        	String linkUrlMobile = "";
        	
        	List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
        	Map<String, Object> recipientMap = new HashMap<String, Object>();
        	recipientMap.put("userType", "PERSON");
        	recipientMap.put("companyId", userInfo.getCompanyID());
        	recipientMap.put("cn", clubMasterID);
        	notiRecipientList.add(recipientMap);
        	
			String notiStatus = ezNotificationService.sendNoti(request, userInfo.getId(), userInfo.getDisplayName(), notiRecipientList, "COMMUNITY", notiSubType, clubVO.getC_ClubName(), "popup", "1300", "900", linkUrl, linkUrlMobile, "notChkSetting");
			logger.debug("community " +  notiSubType + " noti status : " + notiStatus);
        }
		
		logger.debug("joinOkSendMail ended.");
	}
	
	/* 2018-07-18 - 탈퇴신청 메일 보낼 시 마스터 셀렉트에 companyID 조건 추가 */
	public void commOutOkSendMail(HttpServletRequest request, String loginCookie, LoginVO userInfo, String code, String reason) throws Exception {
		logger.debug("commOutOkSendMail started.");
		
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("v_code", code);
        map.put("v_userInfo_lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
        map.put("tenantID", userInfo.getTenantId());
        map.put("companyID", userInfo.getCompanyID());
        
        CommunityClubVO vo = ezCommunityDAO.commOutOkGet2(map);
		String clubName = getClubNameLocalization(userInfo.getLang(), vo);
        
        /* 2018-11-27 홍승비 - 커뮤니티 탈퇴 신청 알림 메일 폰트 수정 */
        if (vo.getEmail() != null) {
        	String subject = "[" + clubName + "]Community" + egovMessageSource.getMessage("ezCommunity.t720", userInfo.getLocale()) + userInfo.getDisplayName() + " " + egovMessageSource.getMessage("ezCommunity.t722", userInfo.getLocale());
        	String bodyContent = "[" + vo.getC_ClubName() + "]" + egovMessageSource.getMessage("ezCommunity.t720", userInfo.getLocale()) + userInfo.getDisplayName() + " " + egovMessageSource.getMessage("ezCommunity.t587", userInfo.getLocale()) + "< " + reason + " > " + egovMessageSource.getMessage("ezCommunity.t721", userInfo.getLocale());
        	
        	String content = commonUtil.createNotiMailContent(bodyContent, userInfo.getTenantId(), userInfo.getLocale());
        	
        	InternetAddress from = new InternetAddress();
        	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
        	from.setAddress(userInfo.getEmail());
        	
        	InternetAddress to = new InternetAddress();
        	to.setPersonal(vo.getUserName(), "UTF-8");
        	to.setAddress(vo.getEmail());
        	
        	ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, content, false);
        	
        	String notiSubType = "WITHDRAWAL";
        	String linkUrl = "/ezCommunity/checkCommHome.do?communityCD=" + code;
        	String linkUrlMobile = "";
        	
        	List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
        	Map<String, Object> recipientMap = new HashMap<String, Object>();
        	recipientMap.put("userType", "PERSON");
        	recipientMap.put("companyId", userInfo.getCompanyID());
        	recipientMap.put("cn", vo.getC_SysopID());
        	notiRecipientList.add(recipientMap);
        	
			String notiStatus = ezNotificationService.sendNoti(request, userInfo.getId(), userInfo.getDisplayName(), notiRecipientList, "COMMUNITY", notiSubType, vo.getC_ClubName(), "popup", "1300", "900", linkUrl, linkUrlMobile, "notChkSetting");
			logger.debug("community " +  notiSubType + " noti status : " + notiStatus);
        }
        
        logger.debug("commOutOkSendMail ended.");
	}

	@Override
	public void okNoSetSendMail(HttpServletRequest request, String loginCookie, LoginVO userInfo, String flag, String code, String cID) throws Exception {
		logger.debug("okNoSetSendMail started.");
		
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("v_CODE", code);
        map.put("v_USERINFO_LANG", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
        map.put("tenantID", userInfo.getTenantId());
        
        CommunityClubVO cvo = ezCommunityDAO.getCClubName(map);
		String clubName = getClubNameLocalization(userInfo.getLang(), cvo);
        OrganUserVO uvo = ezOrganAdminService.getUserInfo(cID, userInfo.getPrimary(), userInfo.getTenantId());
        //logger.debug("C_ClubName=" + cvo.getC_ClubName() + ", email=" + uvo.getMail());
        
        if (uvo.getMail() != null) {
        	String notiSubType = "MEMBER_ADMIT";
        	String subName = egovMessageSource.getMessage("ezCommunity.t1534", userInfo.getLocale());
            String bodyName = egovMessageSource.getMessage("ezCommunity.t1536", userInfo.getLocale());
            
            if (flag.toUpperCase().equals("NO")) {
            	subName = egovMessageSource.getMessage("ezCommunity.t1535", userInfo.getLocale());
            	bodyName = egovMessageSource.getMessage("ezCommunity.t1537", userInfo.getLocale());
            	notiSubType = "MEMBER_REJECT";
            }
            
            if (!ezPersonalService.hasNotiDiableItem(cID, NotiType.fromString("COMMUNITY_" + notiSubType), NotiPlatform.MAIL, userInfo.getTenantId())) {
	        	String subject = "[" + clubName + "] " + subName;
	
	        	String bodyContent = "[" + cvo.getC_ClubName() + "] " + bodyName;
	        	
	        	String content = commonUtil.createNotiMailContent(bodyContent, userInfo.getTenantId(), userInfo.getLocale());
	        	
	        	InternetAddress from = new InternetAddress();
	        	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
	        	from.setAddress(userInfo.getEmail());
	        	
	        	InternetAddress to = new InternetAddress();
	        	to.setPersonal(uvo.getDisplayName(), "UTF-8");
	        	to.setAddress(uvo.getMail());
	        	
	        	ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, content, false);
            }
        	
        	String linkUrl = "/ezCommunity/checkCommHome.do?communityCD=" + code;
        	String linkUrlMobile = "";
        	
        	List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();

        	Map<String, Object> recipientMap = new HashMap<String, Object>();
        	recipientMap.put("userType", "PERSON");
        	recipientMap.put("companyId", userInfo.getCompanyID());
        	recipientMap.put("cn", cID);
        	notiRecipientList.add(recipientMap);
        	
			String notiStatus = ezNotificationService.sendNoti(request, userInfo.getId(), userInfo.getDisplayName(), notiRecipientList, "COMMUNITY", notiSubType, cvo.getC_ClubName(), "popup", "1300", "900", linkUrl, linkUrlMobile, "");
			logger.debug("community " +  notiSubType + " noti status : " + notiStatus);
        }
        
        logger.debug("okNoSetSendMail ended.");
	}
	
	@Override
	public String getMyCoummunityBoardList(LoginVO userInfo, String clubNo) throws Exception {
		logger.debug("getMyCoummunityBoardList started.");
		
		StringBuilder rtnVal = new StringBuilder();
		
		rtnVal.append("<ITEM><DATA>");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_copNo", clubNo);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", userInfo.getTenantId());
			
		List<CommunityMyCommunityVO> myCommunityList = ezCommunityDAO.myCommunityItemGet(map);
		
		for(CommunityMyCommunityVO myCommunity : myCommunityList) {
			rtnVal.append(commonUtil.getQueryResult(myCommunity));
		}
		
		rtnVal.append("</DATA></ITEM>");
		
		logger.debug("getMyCoummunityBoardList ended.");
		return rtnVal.toString();
	}
	
	public List<CommunityBoardDeleteItemVO> getExpiredItems() throws Exception {
		logger.debug("getExpiredItems started");

		List<CommunityBoardDeleteItemVO> expiredItemList = ezCommunityDAO.getExpiredItems();

		logger.debug("getExpiredItems ended");
		
		return expiredItemList;
	}

	@Override
	public void deleteExpiredItems(String realPath) throws Exception {
		logger.debug("deleteExpiredItems started");

		List<CommunityBoardDeleteItemVO> expiredItemList = getExpiredItems();
		
		for (CommunityBoardDeleteItemVO k : expiredItemList) {
			deleteItem(k.getItemID(), k.getTenantID());
		}

		logger.debug("deleteExpiredItems ended");
	}

	@Override
	public void deleteReservedBoard(String realPath) throws Exception {
		logger.debug("deleteReservedBoard started");
		
		int deleteCnt = 0;
		List<CommunityBoardDeleteItemVO> boardInfoList = ezCommunityDAO.getDeleteReservedBoard();
		
		for (CommunityBoardDeleteItemVO k : boardInfoList) {
			//logger.debug("deleteBoardPath :  " + realPath + commonUtil.getUploadPath("upload_community.ROOT", k.getTenantID()) + commonUtil.separator + k.getBoardID());
			Path docPath = Paths.get(commonUtil.detectPathTraversal(realPath + commonUtil.getUploadPath("upload_community.ROOT", k.getTenantID()) + commonUtil.separator + k.getBoardID()));
			
			//커뮤니티 게시판 디렉토리 하위 이미지, 게시물 관련 파일 모두 지우기
			try {
				Files.walkFileTree(docPath, new FileVisitor<Path>() {
					@Override
					public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs) throws IOException {
						logger.debug("delete preVisitDirectory :: " + docPath);
						return FileVisitResult.CONTINUE;
					}

					@Override
					public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
						Files.deleteIfExists(file);
						logger.debug("delete File :: " + docPath);
						return FileVisitResult.CONTINUE;
					}

					@Override
					public FileVisitResult visitFileFailed(Path file, IOException exc) throws IOException {
						logger.debug("delete visitFileFailed :: " + docPath);
						return FileVisitResult.CONTINUE;
					}

					@Override
					public FileVisitResult postVisitDirectory(Path dir, IOException exc) throws IOException {
						if (exc == null) {
							Files.deleteIfExists(dir);
							logger.debug("delete Directory :: " + docPath);
							return FileVisitResult.CONTINUE;
						} else {
							throw exc;
						}
					}
				});
				
				deleteCnt++;
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
			
			ezCommunityDAO.deleteReservedBoard(k);
			//logger.debug("delete boardID : " + k.getBoardID() + " is Done");
		}
		
		//logger.debug("deleteReservedBoard:::deleteBoardCount = " + deleteCnt);
		logger.debug("deleteReservedBoard ended");
	}

	@Override
	public void deleteReservedBoardItem(String realPath) throws Exception {
		logger.debug("deleteReservedBoardItem started");

		List<CommunityBoardDeleteItemVO> boardItemList = ezCommunityDAO.getDeleteReservedBoardItem();
		Map<String, Object> map = new HashMap<String, Object>();
		
		for (CommunityBoardDeleteItemVO k : boardItemList) {
			Path docPath = Paths.get(commonUtil.detectPathTraversal(realPath + commonUtil.getUploadPath("upload_community.ROOT", k.getTenantID()) + commonUtil.separator + k.getBoardID()
					+ commonUtil.separator + "doc" + commonUtil.separator + k.getItemID() + ".mht"));
			
			Files.deleteIfExists(docPath);
			
			map.put("itemID", k.getItemID());
			map.put("boardID", k.getBoardID());
			map.put("tenantID", k.getTenantID());
			
			List<String> filePathList = ezCommunityDAO.getCopyItemAttach(map);
			
			for (String h : filePathList) {
				Path filePath = Paths.get(commonUtil.detectPathTraversal(realPath + h));
				
				Files.deleteIfExists(filePath);
			}
			
			ezCommunityDAO.deleteBoardItemAttach(map);
			ezCommunityDAO.deleteReservedBoardItem(k);
			//logger.debug("delete itemID : " + k.getItemID() + " is Done");
		}

		logger.debug("deleteReservedBoardItem ended");
	}
	
	/* 커뮤니티 답변메일 -> 보낼 당시에 a링크로 박힌다. 받고 나서 처리하자. */
	@Override
	public void sendReplyNoticeMail(HttpServletRequest request, String boardID, String itemID, String itemTreeID, String loginCookie) throws Exception {
		logger.debug("sendReplyNoticeMail started.");
		//logger.debug("boardID = " + boardID + " || itemID = " + itemID + " || itemTreeID = " + itemTreeID);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		CommunityBoardPropertyVO boardInfo = getBoardInfo(userInfo, boardID, "");
		
		if (boardInfo.getReplyNotify().equals("1")) {
			CommunityBoardItemVO itemVO = getItemXML(boardID, itemID, userInfo);
			String communityID = sendPostNoticeMailGet1(boardID);
			StringBuilder bodyContent = new StringBuilder();
			Locale locale = userInfo.getLocale();
			String strURL = "";
			String boardName = getClubBoardNameLocalization(userInfo.getLang(), boardInfo);
			
			// 포토게시물과 일반(그룹, 익명) 게시물 링크 분기처리
			if (boardInfo.getGubun().equals("3")) {
				strURL = "<a id='community_a' style='color:blue;text-decoration:underline;cursor:pointer;' onclick=\"" + "item_ViewPhoto_New_Community('" + boardID + "', '" + itemID + "', '" + communityID + "'); return false;" + "\" href=\"_blank\" target=\"_blank\">";
			} else {
				strURL = "<a id='community_a' style='color:blue;text-decoration:underline;cursor:pointer;' onclick=\"" + "item_View_New_Community('" + boardID + "', '" + itemID + "', '" + communityID + "'); return false;" + "\" href=\"_blank\" target=\"_blank\">";
			}
			
			String subject = "[Community " + egovMessageSource.getMessage("ezCommunity.t127", locale) + boardName + "] " + itemVO.getTitle();
			bodyContent.append("<br>" + egovMessageSource.getMessage("ezCommunity.t126", locale) + "<br><br>");
			bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("main.t1006", userInfo.getLocale()) + " : " + commonUtil.cleanValue(boardInfo.getC_ClubName()));
			bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t117", locale) + commonUtil.cleanValue(boardInfo.getBoardName()));
			/* 2018-04-30 이소담 - 커뮤니티 > 답변 알림메일 송부 > 메일 > 게시일자, 게시자, 비정상적으로 표시되어서 수정 */
//			bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t118", locale) + EgovDateUtil.getToday(""));
			bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t118", locale) + itemVO.getWriteDate());
			bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t119", locale) + userInfo.getDisplayName() + "(" + userInfo.getTitle() + ", "  + userInfo.getDeptName() + ", " + userInfo.getCompanyName() + ")");
			bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezCommunity.t120", locale) + strURL + itemVO.getTitle() + "</a>");
    		
			String content = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), locale);
			
        	InternetAddress from = new InternetAddress();
        	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
        	from.setAddress(userInfo.getEmail());
        	
        	// 가장 첫번째 부모글을 작성한 사람에게 메일을 발송 (itemTreeID 잘라서 사용)
        	OrganUserVO uvo = sendReplyNoticeMail(boardID, itemTreeID.substring(0, 38), userInfo.getTenantId());

        	if (!ezPersonalService.hasNotiDiableItem(uvo.getCn(), NotiType.fromString("COMMUNITY_REPLY"), NotiPlatform.MAIL, userInfo.getTenantId())) {
	        	// 가입승인된 사용자에게만 메일을 발송하도록 작성자의 이메일로 체크 (커뮤니티 탈퇴했다면 게시물 접근권한 없으므로 메일 발송 안함)
	        	InternetAddress to = new InternetAddress();
	        	boolean chkUser = checkUserInCommunity(boardInfo.getC_ClubNo(), uvo.getCn(), userInfo.getTenantId());
				if (chkUser == true) {
					to.setPersonal(uvo.getDisplayName(), "UTF-8");
		        	to.setAddress(uvo.getMail());
		        } else {
		        	return;
		        }
				
				//logger.debug("from = " + userInfo.getEmail());
	        	//logger.debug("to = " + uvo.getMail());
	        	ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, content, false);
        	}
        	
        	String boardType = boardInfo.getGubun();
    		String linkUrl = "";
    		String linkUrlMobile = "";
    		
    		String tempItemID = encodeURIComponent(itemID);
    		String tempBoardID = encodeURIComponent(boardID);
    		
    		switch (boardType) {
    		case "3":
    		case "4":
    			linkUrl += "/ezCommunity/boardItemViewPhoto.do?itemID=" + (tempItemID) + "&boardID=" + (tempBoardID);
    			break;
    		case "7":
    			linkUrl += "/ezCommunity/boardItemViewMovie.do?itemID=" + (tempItemID) + "&boardID=" + (tempBoardID);
    			break;
    		default:
    			linkUrl += "/ezCommunity/boardItemView.do?itemID=" + (tempItemID) + "&boardID=" + (tempBoardID) + "&code=" + boardInfo.getC_ClubNo();
    			break;
    		}
    		
        	String notiSubType = "REPLY";
        	
        	List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();

        	Map<String, Object> recipientMap = new HashMap<String, Object>();
        	recipientMap.put("userType", "PERSON");
        	recipientMap.put("companyId", userInfo.getCompanyID());
        	recipientMap.put("cn", uvo.getCn());
        	notiRecipientList.add(recipientMap);
        	
			String notiStatus = ezNotificationService.sendNoti(request, userInfo.getId(), userInfo.getDisplayName(), notiRecipientList , "COMMUNITY", notiSubType, boardName + " - " + itemVO.getTitle(), "popup", "750", "721", linkUrl, linkUrlMobile, "");
			logger.debug("community " +  notiSubType + " noti status : " + notiStatus);
			
		}
		
		logger.debug("sendReplyNoticeMail ended.");
	}
	
	private OrganUserVO sendReplyNoticeMail(String boardID, String itemID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("itemID", itemID);
		map.put("tenantID", tenantID);
		
		OrganUserVO uvo = ezCommunityDAO.sendReplyNoticeMail(map);
		
		return uvo;
	}
	
	private String sendPostNoticeMailGet1(String boardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		
		String result = ezCommunityDAO.sendPostNoticeMailGet1(map);
		
		return result;
	}
	// 2018-01-10 강민수92 한줄댓글 개수
	@Override
	public String getOneLineReplyCount(String pBoardID, String pItemID, int tenantId) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("boardID", pBoardID);
		map.put("itemID", pItemID);
		map.put("tenantID", tenantId);
		return ezCommunityDAO.getOneLineReplyCount(map);
	}
	// 2018-02-06 김보미 - 조회자 수
	@Override
	public int getReaderListCount(String boardID, String itemID, String userID, int tenantID) throws Exception {
		logger.debug("getReaderListCount started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("boardID", boardID);
		map.put("itemID", itemID);
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		
		logger.debug("getReaderListCount ended");
		return ezCommunityDAO.getReaderListCount(map);
	}
	
	public int bbsGetReplyItemCnt(String itemNo, int tenantID) throws Exception {
		logger.debug("getReaderListCount started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_NO", itemNo); // 커뮤니티 공지사항의 PRI KEY는 NO 하나
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getReaderListCount ended");
		return ezCommunityDAO.bbsGetReplyItemCnt(map);
	}
	
	public String getClubConfirmType(String code, int tenantID) throws Exception {
		logger.debug("getClubConfirmType started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getClubConfirmType ended");
		return ezCommunityDAO.getClubConfirmType(map);
	}
	
	/* 2021-11-09 홍승비 - 주어진 커뮤니티 게시판 ID에 대해 자신이 읽지 않은 게시물이 있는지 반환 (Y/N) */
	@Override
	public String getIsNewItemExists(String boardID, String userID, int tenantID) throws Exception {
		logger.debug("getIsNewItemExists started");
		String isNewItemExists = "N";
		int cnt = 0;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BOARDID", boardID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		cnt = ezCommunityDAO.getIsNewItemCnt(map);
		
		if (cnt > 0) { // 읽지 않은 게시물이 존재한다면 Y 반환
			isNewItemExists = "Y";
		}
		
		logger.debug("getIsNewItemExists ended");
		return isNewItemExists;
	}
	
	/* 2021-11-16 홍승비 - 특정 사용자가 해당 커뮤니티에 가입 승인된 상태(permit != 0)인지 체크 후 반환 */
	public boolean checkUserInCommunity(String clubNo, String userID, int tenantID) throws Exception {
		logger.debug("checkUserInCommunity started, clubNo/userID = " + clubNo + "/" + userID);
		boolean result = false;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_C_CLUBNO", clubNo);
		map.put("v_C_ID", userID);
		map.put("v_TENANT_ID", tenantID);
		
		int cnt = ezCommunityDAO.checkUserInCommunity(map);
		if (cnt > 0) {
			result = true;
		}
		
		logger.debug("checkUserInCommunity ended, result = " + result);
		return result;
	}
	
	// 2023-12-07 한태훈 - java에서 encodeURIComponent 메소드 구현
	@Override
	public String encodeURIComponent(String s) throws Exception {
	    String result = null;
    	result = URLEncoder.encode(s, "UTF-8")
                         .replaceAll("\\+", "%20")
                         .replaceAll("\\%21", "!")
                         .replaceAll("\\%27", "'")
                         .replaceAll("\\%28", "(")
                         .replaceAll("\\%29", ")")
                         .replaceAll("\\%7E", "~");
	 
	    return result;
	}

	public List<String> myCommunityAndPublicGet(String id, String companyID, int tenantID) throws Exception {
		logger.debug("myCommunityAndPublicGet started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", id);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);

		List<String> list = ezCommunityDAO.myCommunityPopGet(map);

		logger.debug("myCommunityAndPublicGet ended.");
		return list;
	}

	@Override
	public String popularBoardItem(LoginVO userInfo) throws Exception {
		logger.debug("popularBoardItem started.");
		
		StringBuilder rtnVal = new StringBuilder();
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		int tenantId = userInfo.getTenantId();
		
		List<String> clubNoList = myCommunityAndPublicGet(userId, companyId, tenantId);
		
		rtnVal.append("<ITEM><DATA>");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_copNo", clubNoList);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantId);
		map.put("offset", commonUtil.getMinuteUTC(userInfo.getOffset()));

		if(clubNoList.size() > 0) {
			List<CommunityMyCommunityVO> myCommunityList = ezCommunityDAO.myCommunityPopItemGet(map);

			for(CommunityMyCommunityVO myCommunity : myCommunityList) {
				rtnVal.append(commonUtil.getQueryResult(myCommunity));
			}
		}
		
		rtnVal.append("</DATA></ITEM>");

		logger.debug("popularBoardItem ended.");
		return rtnVal.toString();
	}
    
	@Override
	public boolean saveHWP(String strHTML, String strFileName, String strBoardID, String strFilePath, String realPath) throws Exception {
		
		String docPath = "";
		String filePath = "";
		boolean ret = true;
		InputStream stream = null;
		OutputStream bos = null;
		
		try {
			docPath = realPath + strFilePath;
			docPath = commonUtil.detectPathTraversal(docPath);
			strBoardID = commonUtil.detectPathTraversal(strBoardID);
			
			if (!new File(docPath + strBoardID).exists()) {
				File dir1 = new File(docPath + strBoardID + commonUtil.separator + "uploadFile");
				File dir2 = new File(docPath + strBoardID + commonUtil.separator + "doc");
				dir1.mkdirs();
				dir2.mkdirs();
			}
			
			filePath = docPath + strBoardID + commonUtil.separator + "doc" + commonUtil.separator + strFileName + ".hwp";
			filePath = commonUtil.detectPathTraversal(filePath);
			
			if(new File(filePath).exists()) {
				new File(filePath).delete();
			}
			
			stream = new ByteArrayInputStream(Base64.decodeBase64(strHTML));
			bos = new FileOutputStream(filePath);
			
			int bytesRead = 0;
			byte[] buffer = new byte[2048];
			
			while ((bytesRead = stream.read(buffer, 0, 2048)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
			
		} catch (RuntimeException e) {
			throw e;
		}
		catch (Exception e) {
			ret = false;
		} finally {
			if (bos != null) {
				try {
					bos.close();
				} catch (Exception ignore) {
						logger.debug("IGNORED: {}", ignore.getMessage());
				}
			}
			
			if (stream != null) {
				try {
					stream.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
			}
		}
		
		return ret;
	}
    
    // 2024-10-30 황인경 - 커뮤니티 > 방명록 > 댓글 유무
    public int chkClubguestOnelinereply(int itemID, String companyID, int tenantID, String clubNo) throws Exception{
        logger.debug("chkClubguestOnelinereply started.");

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("itemID", itemID);
        map.put("companyID", companyID);
        map.put("tenantID", tenantID);
        map.put("clubNo", clubNo);

        int cnt = ezCommunityDAO.chkGuestReplyCnt(map);
        logger.debug("chkClubguestOnelinereply ended.");
        return cnt;
    }

    public List<CommunityCClubGuestReplyVO> getGuestOneLineReply(int itemId, int tenantID, String companyID, String clubNo) throws Exception {
        logger.debug("getGuestOneLineReply started.");

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("itemId", itemId);
        map.put("companyID", companyID);
        map.put("tenantID", tenantID);
        map.put("clubNo", clubNo);

        List<CommunityCClubGuestReplyVO> list = ezCommunityDAO.getGuestOneLineReply(map);

        logger.debug("getGuestOneLineReply ended.");
        return list;
    };

    @Override
    public void insertGuestOneLineReply(int itemID, String clubNo, String companyID, int tenantID, String content, LoginVO userInfo) throws Exception {
        logger.debug("insertGuestOneLineReply started.");

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("itemID", itemID);
        map.put("companyID", companyID);
        map.put("tenantID", tenantID);
        map.put("clubNo", clubNo);
        map.put("content", content);
        map.put("v_pNow", commonUtil.getTodayUTCTime(""));
        map.put("userName", userInfo.getDisplayName());
        map.put("userName2", userInfo.getDisplayName2());
        map.put("userId", userInfo.getId());
        map.put("replyId", "{" + UUID.randomUUID().toString() + "}");

        ezCommunityDAO.insertGuestOneLineReply(map);

        logger.debug("insertGuestOneLineReply ended.");
    }

    @Override
    public void deleteGuestOneLineReply(String replyId, int tenantID) throws Exception {
        logger.debug("deleteGuestOneLineReply started.");

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("replyId", replyId);
        map.put("tenantID", tenantID);

        ezCommunityDAO.deleteGuestOneLineReply(map);

        logger.debug("deleteGuestOneLineReply ended.");
    }

    @Override
    public void modifyGuestOneLineReply(String replyId, String content, int tenantID) throws Exception {
        logger.debug("modifyGuestOneLineReply started.");

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("replyId", replyId);
        map.put("tenantID", tenantID);
        map.put("content", content);
        map.put("v_pNow", commonUtil.getTodayUTCTime(""));

        ezCommunityDAO.modifyGuestOneLineReply(map);

        logger.debug("modifyGuestOneLineReply ended.");
    }

	@Override
	public String commBoardTotalSearchList(List<Map<String, String>> searchMaps, LoginVO userInfo, String sortBy, String pageNum, String code) throws Exception {
		logger.debug("commBoardTotalSearchList started.");
		
		String id = userInfo.getId();
		String offset = userInfo.getOffset();
		int tenantID = userInfo.getTenantId();
		int startRow = null != pageNum ? (Integer.parseInt(pageNum) - 1 ) * 10 : 0;
		int endRow = startRow + 10;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("primary", userInfo.getPrimary());
		map.put("v_PUSERID", id);
		map.put("v_pDeptID", userInfo.getDeptID());
		map.put("v_pCompanyID", userInfo.getCompanyID());
		map.put("v_PSORTBY", sortBy == null ? "" : sortBy);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		map.put("searchMaps", searchMaps);
		map.put("startRow", startRow);
		map.put("endRow", endRow);
		map.put("code", code);
		
		/* 2024-07-11 홍승비 - SQL Injection 수정 > 정렬 조건을 쿼리 내부에서 분기처리 하도록 수정 */
		if (null != sortBy && !sortBy.equals("")) {
			String orderCell = sortBy.split(" ")[0].toUpperCase();
			String orderSort = sortBy.split(" ").length > 1 ? sortBy.split(" ")[1].toUpperCase() : "";
			
			map.put("v_orderCell", orderCell); // BOARDNAME, TITLE, WRITERCOMPANYNAME, WRITERDEPTNAME, WRITERNAME, WRITEDATE, ATTACHMENTS, READCOUNT
			map.put("v_orderSort", orderSort); // "" or DESC
		}
		
		List<CommunityBoardListVO> list = ezCommunityDAO.commuTotalSearchList(map);
		
		StringBuilder sb = new StringBuilder();
		sb.append("<NODES>");
		
		for (CommunityBoardListVO boardList : list) {
			sb.append("<NODE>");
			sb.append("<ItemID>" + boardList.getItemID() + "</ItemID>");
			sb.append("<WriterID>" + commonUtil.cleanValue(boardList.getWriterID()) + "</WriterID>");
			sb.append("<WriterName>" + commonUtil.cleanValue(boardList.getWriterName()) + "</WriterName>");
			sb.append("<WriterDeptID>" + commonUtil.cleanValue(boardList.getWriterDeptID()) + "</WriterDeptID>");
			sb.append("<WriterDeptName>" + commonUtil.cleanValue(boardList.getWriterDeptName()) + "</WriterDeptName>");
			sb.append("<WriterCompanyName>" + commonUtil.cleanValue(boardList.getWriterCompanyName()) + "</WriterCompanyName>");
			sb.append("<WriteDate>" + commonUtil.getDateStringInUTC(boardList.getWriteDate(), offset, false) + "</WriteDate>");
			sb.append("<BoardID>" + commonUtil.cleanValue(boardList.getBoardID()) + "</BoardID>");
			sb.append("<BoardName>" + commonUtil.cleanValue(boardList.getBoardName()) + "</BoardName>");
			sb.append("<Importance>" + boardList.getImportance() + "</Importance>");
			sb.append("<Title>" + commonUtil.cleanValue(boardList.getTitle()) + "</Title>");
			sb.append("<ReadCount>" + boardList.getReadCount() + "</ReadCount>");
			sb.append("<OneLineCnt>" + boardList.getOneLineCnt() + "</OneLineCnt>");
			sb.append("<Attachments>" + boardList.getAttachments() + "</Attachments>");
			sb.append("<ItemLevel>" + boardList.getItemLevel() + "</ItemLevel>");
			sb.append("<Abstract>" + commonUtil.cleanValue(boardList.getAbsTract()) + "</Abstract>");
			sb.append("<READ_FG>" + commonUtil.cleanValue(boardList.getRead_fg()) + "</READ_FG>");
			sb.append("<EXT>" + commonUtil.cleanValue(boardList.getExt()) + "</EXT>");
			sb.append("<FILEPATH>" + commonUtil.cleanValue(boardList.getFilePath()) + "</FILEPATH>");
			sb.append("<ReadFlag>" + boardList.getReadFlag() + "</ReadFlag>");
			sb.append("</NODE>");
		}
		
		sb.append("</NODES>");
		
		logger.debug("commBoardTotalSearchList ended.");
		
		return sb.toString();
	}
	
	@Override
	public int commuTotalSearchCount(List<Map<String, String>> searchMaps, LoginVO userInfo, String sortBy, String pageNum, String code) throws Exception {
		logger.debug("commuTotalSearchCount started.");
		
		String id = userInfo.getId();
		int tenantID = userInfo.getTenantId();
		int startRow = null != pageNum ? (Integer.parseInt(pageNum) - 1 ) * 10 : 0;
		int endRow = startRow + 10;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("primary", userInfo.getPrimary());
		map.put("v_PUSERID", id);
		map.put("v_pDeptID", userInfo.getDeptID());
		map.put("v_pCompanyID", userInfo.getCompanyID());
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		map.put("searchMaps", searchMaps);
		map.put("startRow", startRow);
		map.put("endRow", endRow);
		map.put("code", code);
		
		int resCnt = ezCommunityDAO.commuTotalSearchCount(map);
		
		logger.debug("commuTotalSearchCount ended.");
		return resCnt;
	}

	@Override
	public List<CommunityBoardItemAttachmentVO> getItemAttachmentInfo(String itemID, int tenantId) throws Exception {
		logger.debug("getItemAttachmentInfo started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemID", itemID);
		map.put("tenantID", tenantId);
		
		List<CommunityBoardItemAttachmentVO> list = ezCommunityDAO.getItemAttachmentXML(map);
		
		logger.debug("getItemAttachmentInfo ended.");
		return list;
	}

	@Override
	public String getReadFlag(String boardID, LoginVO userInfo) throws Exception {
		logger.debug("getReadFlag started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("tenantID", userInfo.getTenantId());
		map.put("userID", userInfo.getId());
		map.put("deptID", userInfo.getDeptID());
		map.put("companyID", userInfo.getCompanyID());
		
		logger.debug("getReadFlag ended.");
		return ezCommunityDAO.getReadFlag(map);
	}

	@Override
	public String getClubNameLocalization(String userLang, CommunityClubVO clubVO) throws Exception {
		String clubName = clubVO.getC_ClubName();
		if (Strings.isNotBlank(userLang) && !"1".equals(userLang) && Strings.isNotBlank(clubVO.getC_ClubName2())) {
			clubName = clubVO.getC_ClubName2();
		}
		return clubName;
	}

	@Override
	public String getClubBoardNameLocalization(String userLang, CommunityBoardPropertyVO clubBoardVO) throws Exception {
		String boardName = clubBoardVO.getBoardName();
		
		if (Strings.isNotBlank(userLang) && !"1".equals(userLang) && Strings.isNotBlank(clubBoardVO.getBoardName2())) {
			boardName = clubBoardVO.getBoardName2();
		}
		return boardName;
	}

	@Override
	public int checkPollPeriod(String code, String pollManagerID, LoginVO userInfo) throws Exception {
		logger.debug("checkPollPeriod started.");
		String nowDate = commonUtil.getTodayUTCTime("");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", code);
		map.put("pollManagerID", pollManagerID);
		map.put("tenantID", userInfo.getTenantId());
		map.put("nowDate", nowDate);

		logger.debug("checkPollPeriod ended.");
		return ezCommunityDAO.checkPollPeriod(map);
	}

	@Override
	public void updateJoinGrade(String code, String joinGrade, String companyID, int tenantID) throws Exception {
		logger.debug("updateJoinGrade started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", code);
		map.put("joinGrade", joinGrade);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);

		ezCommunityDAO.updateJoinGrade(map);

		logger.debug("updateJoinGrade ended.");
	}

	@Override
	public String saveGradeList(String code, List<String> gradeList, String companyID, int tenantID) throws Exception {
		logger.debug("saveGradeList started.");

		Map<String, Object> map = new HashMap<String, Object>();

		for (int i = 0; i <= gradeList.size(); i++) {
			map.put("code", code);
			if (i != gradeList.size()) {
				map.put("gradeCode", i + 1);
				map.put("gradeName", gradeList.get(i));
			} else {
				map.put("gradeCode", 10);
				map.put("gradeName", "손님");
			}
			map.put("companyID", companyID);
			map.put("tenantID", tenantID);

			ezCommunityDAO.saveGradeList(map);
		}

		logger.debug("saveGradeList ended.");
		return "true";
	}

	@Override
	public void deleteGradeList(String code, String companyID, int tenantID) throws Exception {
		logger.debug("deleteGradeList started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", code);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);

		ezCommunityDAO.deleteGradeList(map);

		logger.debug("deleteGradeList ended");
	}

	@Override
	public List<CommunityMemberGradeVO> getMemberGrade(String code, String companyID, int tenantID) throws Exception {
		logger.debug("getMemberGrade started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", code);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);

		List<CommunityMemberGradeVO> memberGrade = ezCommunityDAO.getMemberGrade(map);

		logger.debug("getMemberGrade ended.");

		return memberGrade;
	}

	@Override
	public String getMemberGradeName(String code, String gradeCode, String companyID, int tenantID) throws Exception {
		logger.debug("getMemberGradeName started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", code);
		map.put("gradeCode", gradeCode);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);

		String gradeName = ezCommunityDAO.getMemberGradeName(map);

		logger.debug("getMemberGradeName ended.");

		return gradeName;
	}

	@Override
	public void updateMemberGrade(String code, String grade, List<String> id, String companyID, int tenantID) throws Exception {
		logger.debug("updateMemberGrade started.");

		Map<String, Object> map = new HashMap<String, Object>();

		for (int i = 0; i < id.size(); i++) {
			map.put("code", code);
			map.put("grade", grade);
			map.put("userId", id.get(i));
			map.put("companyID", companyID);
			map.put("tenantID", tenantID);

			ezCommunityDAO.updateMemberGrade(map);
		}

		logger.debug("updateMemberGrade ended.");
	}

	@Override
	public String getUserGrade(String code, String userId, String companyID, int tenantID) throws Exception {
		logger.debug("getUserGrade started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", code);
		map.put("userId", userId);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);

		String gradeCode = ezCommunityDAO.getUserGrade(map);

		logger.debug("getUserGrade ended.");

		return gradeCode;
	}

	@Override
	public String getMemListReadGrade(String code, String companyID, int tenantID) throws Exception {
		logger.debug("getMemListReadGrade started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", code);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);

		String readGrade = ezCommunityDAO.getMemListReadGrade(map);

		logger.debug("getMemListReadGrade ended.");

		return readGrade;
	}

	@Override
	public int getGradeCount(String code, String grade, String companyID, int tenantID) throws Exception {
		logger.debug("getGradeCount started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", code);
		map.put("grade", grade);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);

		int gradeCount = ezCommunityDAO.getGradeCount(map);

		logger.debug("getGradeCount ended.");

		return gradeCount;
	}

	@Override
	public void updateBoardManageGrade(String boardID, String readGrade, String writeGrade, int tenantID) throws Exception {
		logger.debug("updateBoardManageGrade started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardID);
		map.put("readGrade", readGrade);
		map.put("writeGrade", writeGrade);
		map.put("v_pAccessID", "everyone");
		map.put("tenantID", tenantID);

		ezCommunityDAO.updateBoardManageGrade(map);

		logger.debug("updateBoardManageGrade ended.");
	}

	@Override
	public String getCommunityJoinGrade(String code, String companyID, int tenantID) throws Exception {
		logger.debug("getCommunityJoinGrade started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", code);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);

		String joinGrade = ezCommunityDAO.getCommunityJoinGrade(map);

		logger.debug("getCommunityJoinGrade ended.");

		return joinGrade;
	}

	public List<CommunityCClubUserVO> getClubOperatorList(String companyID, int tenantID, String code, String userId) throws Exception {
		logger.debug("getClubOperatorList started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", code);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("userId", userId);

		List<CommunityCClubUserVO> list = ezCommunityDAO.getClubOperatorList(map);

		logger.debug("getClubOperatorList ended.");

		return list;
	}

	@Override
	public int adminOperatorListCount(LoginVO userInfo, String code) throws Exception {
		logger.debug("adminOperatorListCount started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", code);
		map.put("companyID", userInfo.getCompanyID());
		map.put("tenantID", userInfo.getTenantId());

		int result = ezCommunityDAO.adminOperatorListCount(map);

		logger.debug("adminOperatorListCount ended.");

		return result;
	}

	@Override
	public String adminOperatorList(LoginVO userInfo, String code) throws Exception {
		logger.debug("adminOperatorList started.");
		String primary = userInfo.getPrimary();

		List<CommunityCClubUserVO> list = getClubOperatorList(userInfo.getCompanyID(), userInfo.getTenantId(), code, "");

		int iCount = 1, curPage = 0;
		StringBuilder sb = new StringBuilder();

		if (list == null || list.size() == 0) {
			sb.append("<tr>");
			sb.append("<td colspan=\"6\" style=\"width:100%; height:30px; text-align:center;\">" + egovMessageSource.getMessage("ezOrgan.hdp25", userInfo.getLocale()) + "</td>");
			sb.append("</tr>");
		} else {
			for (CommunityCClubUserVO operatorList : list) {
				CommunityMemberInfoVO memberInfo = commViewMemberGet3(operatorList.getC_ID().trim(), operatorList.getCompanyID(), primary, userInfo.getTenantId());

				sb.append("<tr>");
				sb.append("<td style=\"width:15px; height:23px; align:center;\"><input type=\"CHECKBOX\" id=" + operatorList.getC_ID() + " class=\"selectOperator\">");
				sb.append("<td align=\"center\">" + memberInfo.getUserName().trim() + "</td>");

				List<CommunityCClubUserVO> authInfo = getClubOperatorList(userInfo.getCompanyID(), userInfo.getTenantId(), code, operatorList.getC_ID());

				if (authInfo.get(0).getAdmin_Auth() != null && authInfo.get(0).getAdmin_Auth().contains("D")) {
					sb.append("<td><input type=\"CHECKBOX\" id=\"adminAuthD" + iCount + "\" style=\"vertical-align: middle;\" userId=" + operatorList.getC_ID() + " checked><label for=\"adminAuthD" + iCount + "\" style=\"vertical-align: middle;\">홈화면관리</label></td>");
				} else {
					sb.append("<td><input type=\"CHECKBOX\" id=\"adminAuthD" + iCount + "\" style=\"vertical-align: middle;\" userId=" + operatorList.getC_ID() + "><label for=\"adminAuthD" + iCount + "\" style=\"vertical-align: middle;\">홈화면관리</label></td>");
				}

				if (authInfo.get(0).getAdmin_Auth() != null && authInfo.get(0).getAdmin_Auth().contains("F")) {
					sb.append("<td><input type=\"CHECKBOX\" id=\"adminAuthF" + iCount + "\" style=\"vertical-align: middle;\" userId=" + operatorList.getC_ID() + " checked><label for=\"adminAuthF" + iCount + "\" style=\"vertical-align: middle;\">게시판관리</label></td>");
				} else {
					sb.append("<td><input type=\"CHECKBOX\" id=\"adminAuthF" + iCount + "\" style=\"vertical-align: middle;\" userId=" + operatorList.getC_ID() + "><label for=\"adminAuthF" + iCount + "\" style=\"vertical-align: middle;\">게시판관리</label></td>");
				}

				if (authInfo.get(0).getAdmin_Auth() != null && authInfo.get(0).getAdmin_Auth().contains("B")) {
					sb.append("<td><input type=\"CHECKBOX\" id=\"adminAuthB" + iCount + "\" style=\"vertical-align: middle;\" userId=" + operatorList.getC_ID() + " checked><label for=\"adminAuthB" + iCount + "\" style=\"vertical-align: middle;\">설문조사관리</label></td>");
				} else {
					sb.append("<td><input type=\"CHECKBOX\" id=\"adminAuthB" + iCount + "\" style=\"vertical-align: middle;\" userId=" + operatorList.getC_ID() + "><label for=\"adminAuthB" + iCount + "\" style=\"vertical-align: middle;\">설문조사관리</label></td>");
				}

				if (authInfo.get(0).getAdmin_Auth() != null && authInfo.get(0).getAdmin_Auth().contains("A")) {
					sb.append("<td><input type=\"CHECKBOX\" id=\"adminAuthA" + iCount + "\" style=\"vertical-align: middle;\" userId=" + operatorList.getC_ID() + " checked><label for=\"adminAuthA" + iCount + "\" style=\"vertical-align: middle;\">회원관리</label></td>");
				} else {
					sb.append("<td><input type=\"CHECKBOX\" id=\"adminAuthA" + iCount + "\" style=\"vertical-align: middle;\" userId=" + operatorList.getC_ID() + "><label for=\"adminAuthA" + iCount + "\" style=\"vertical-align: middle;\">회원관리</label></td>");
				}
				sb.append("</tr>");

				iCount++;
			}
		}

		logger.debug("adminOperatorList ended.");

		return sb.toString();
	}

	@Override
	public void deleteClubOperator(String code, List<String> id, String companyID, int tenantID) throws Exception {
		logger.debug("deleteClubOperator started.");

		Map<String, Object> map = new HashMap<String, Object>();

		for (int i = 0; i < id.size(); i++) {
			map.put("code", code);
			map.put("userId", id.get(i));
			map.put("companyID", companyID);
			map.put("tenantID", tenantID);

			ezCommunityDAO.deleteClubOperator(map);
		}

		logger.debug("deleteClubOperator ended.");
	}

	@Override
	public void updateClubOperatorAuth(String code, List<String> auth, String companyID, int tenantID) throws Exception {
		logger.debug("updateClubOperatorAuth started.");

		for (int i = 0; i < auth.size(); i++) {
			String temp = auth.get(i);

			if (temp.contains(";")) {
				String[] operateAuth = temp.split(";");
				String adminAuth = operateAuth[0];
				String userId = operateAuth[1];

				Map<String, Object> map = new HashMap<String, Object>();
				map.put("code", code);
				map.put("adminAuth", adminAuth);
				map.put("userId", userId);
				map.put("companyID", companyID);
				map.put("tenantID", tenantID);

				ezCommunityDAO.updateClubOperatorAuth(map); // 권한 추가
			} else {
				String userId = temp;

				Map<String, Object> map = new HashMap<String, Object>();
				map.put("code", code);
				map.put("adminAuth", "");
				map.put("userId", userId);
				map.put("companyID", companyID);
				map.put("tenantID", tenantID);

				ezCommunityDAO.updateClubOperatorAuth(map); // 권한 삭제
			}
		}

		logger.debug("updateClubOperatorAuth ended.");
	}

	@Override
	public List<CommunityCClubUserVO> getNoOperatorList(String companyID, int tenantID, String code, String keyword, String type) throws Exception {
		logger.debug("getNoOperatorList started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", code);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("keyword", keyword);
		map.put("type", type);

		List<CommunityCClubUserVO> list = ezCommunityDAO.getNoOperatorList(map);

		logger.debug("getNoOperatorList ended.");

		return list;
	}

	@Override
	public int getNoOperatorListCount(String companyID, int tenantID, String code, String keyword, String type) throws Exception {
		logger.debug("getNoOperatorListCount started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", code);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("keyword", keyword);
		map.put("type", type);

		int cnt = ezCommunityDAO.getNoOperatorListCount(map);

		logger.debug("getNoOperatorListCount ended.");

		return cnt;
	}

	@Override
	public String adminOperatorAddList(LoginVO userInfo, String code, String keyword, String type, int comNoPerPage, int curPage) throws Exception {
		logger.debug("adminOperatorList started.");
		String primary = userInfo.getPrimary();

		List<CommunityCClubUserVO> list = getNoOperatorList(userInfo.getCompanyID(), userInfo.getTenantId(), code, keyword, type);

		int iCount = 0;
		StringBuilder sb = new StringBuilder();

		if (list == null || list.size() == 0) {
			sb.append("<tr>");
			sb.append("<td colspan=\"5\" style=\"width:100%; height:30px; text-align:center;\">" + egovMessageSource.getMessage("ezOrgan.hdp25", userInfo.getLocale()) + "</td>");
			sb.append("</tr>");
		} else {
			for (CommunityCClubUserVO userList : list) {
				iCount++;

				if (iCount > comNoPerPage * curPage) {
					break;
				}

				if (iCount > comNoPerPage * curPage - 7) {
					CommunityMemberInfoVO memberInfo = commViewMemberGet3(userList.getC_ID().trim(), userList.getCompanyID(), primary, userInfo.getTenantId());
					String memGradeName = getMemberGradeName(code, userList.getGrade(), userList.getCompanyID(), userInfo.getTenantId());
					sb.append("<tr>");
					sb.append("<td style=\"width:15; height:23; align:center;\"><a href=\"javascript:add('" + userList.getC_ID().trim() + "')\" style=\"width: 17px;padding-left: 8px;padding-right: 16px;text-align:center;\" class=\"imgbtn imgbck\">" + egovMessageSource.getMessage("ezCommunity.lyj44", userInfo.getLocale()) + "</a></td>");
					sb.append("<td align=\"center\">" + memberInfo.getUserName().trim() + "</td>");
					sb.append("<td align=\"center\">" + userList.getC_ID() + "</td>");
					sb.append("<td align=\"center\">" + memberInfo.getDeptName() + "</td>");
					sb.append("<td align=\"center\">" + memGradeName.trim() + "</td>");
					sb.append("</tr>");
				}
			}
		}

		logger.debug("adminOperatorList ended.");

		return sb.toString();
	}

	@Override
	public void updateOperatorGrade(String code, String id, String companyID, int tenantID) throws Exception {
		logger.debug("updateOperatorGrade started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", code);
		map.put("userId", id);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);

		ezCommunityDAO.updateOperatorGrade(map);

		logger.debug("updateOperatorGrade ended.");
	}

	@Override
	public int getBoardItemWriteCount(String code, String id, String companyID, int tenantID, String offset, String startdate, String enddate) throws Exception {
		logger.debug("getBoardItemWriteCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cID", code);
		map.put("userID", id);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("startdate", startdate);
		map.put("enddate", enddate);

		logger.debug("getBoardItemWriteCount ended");
		return ezCommunityDAO.getBoardItemWriteCount(map);
	}

	@Override
	public int getBoardReplyCount(String code, String id, String companyID, int tenantID, String offset, String startdate, String enddate) throws Exception {
		logger.debug("getBoardReplyCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cID", code);
		map.put("userID", id);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("startdate", startdate);
		map.put("enddate", enddate);

		logger.debug("getBoardReplyCount ended");
		return ezCommunityDAO.getBoardReplyCount(map);
	}

	@Override
	public CommunityClubVO getClubUserCountInfo(String code,  String companyID, int tenantID, String offset) throws Exception {
		logger.debug("getClubUserCountInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cID", code);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("sysdate", commonUtil.getTodayUTCTime("yyyy-MM-dd"));

		logger.debug("getClubUserCountInfo ended");
		return ezCommunityDAO.getClubUserCountInfo(map);
	}
}
