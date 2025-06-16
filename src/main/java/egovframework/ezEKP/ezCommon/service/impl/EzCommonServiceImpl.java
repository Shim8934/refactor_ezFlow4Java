package egovframework.ezEKP.ezCommon.service.impl;

import egovframework.ezMobile.ezOption.dao.MOptionDAO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;

import egovframework.let.utl.fcc.service.EzFAL;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGKlibService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezCommon.dao.EzCommonDAO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommon.vo.ApprovPWDVO;
import egovframework.ezEKP.ezCommon.vo.CompanyInfoVO;
import egovframework.ezEKP.ezCommon.vo.TblColumnsInfoVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.vo.CountryVO;
import egovframework.ezMobile.ezOption.dao.MOptionDAO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.vo.TenantServerNameVO;
import egovframework.let.user.login.vo.TenantVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.KlibUtil;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.mariadb.jdbc.internal.com.read.dao.ColumnNameMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DeadlockLoserDataAccessException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.SecureRandom;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.StringJoiner;
import java.util.UUID;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import static egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO.FixBoardCode;

@Service("EzCommonService")
public class EzCommonServiceImpl extends EgovFileMngUtil implements EzCommonService {

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private KlibUtil klibUtil;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Resource(name = "EzCommonDAO")
	private EzCommonDAO ezCommonDAO;

    @Resource(name = "MOptionDAO")
    private MOptionDAO mOptionDAO;

	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;

	@Resource(name = "EzSystemAdminService")
	private EzSystemAdminService ezSystemAdminService;

	@Resource(name = "EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
    
    @Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;

    @Resource(name = "EzOrganService")
    private EzOrganService ezOrganService;
    
	private static final Logger logger = LoggerFactory.getLogger(EzCommonServiceImpl.class);

	@Override
	public ApprovPWDVO getApprovPWD(LoginVO userInfo) throws Exception {
		return ezCommonDAO.getApprovPWD(userInfo);
	}

	/* 더 이상 사용되지 않는 코드로 보여 보안 취약점 조치를 위해 제거함
	@Override
	public void responseAttach(String pPhysicalFilePath, String pFileName, boolean pAttachment, HttpServletRequest request, HttpServletResponse response) throws Exception{
        String isUTF8 = "0";

        for(Cookie cookie : request.getCookies()) {
        	if(cookie.getName().equals("UTF8_Option")){
        		isUTF8 = cookie.getValue();
        	}
        }

        String realPath = commonUtil.getRealPath(request);
        String filePath = pPhysicalFilePath;
        String fileName = pFileName;
        String fileExt = "";

        if (fileName.lastIndexOf(".") > -1) {
            fileExt = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
        }
        fileName = getProperFileName(fileName, fileExt, isUTF8);

        FileInputStream is = null;
        String userAgentHeader = request.getHeader("User-Agent");
        String usebrowser = ClientUtil.getClientInfo(request, "browser");//(userAgentHeader == null || userAgentHeader.equals("")) ? "NONE" : userAgentHeader.contains("MSIE") ?
                            //"IE" : userAgentHeader.contains("Trident") ? "IE" : userAgentHeader.contains("Firefox") ? "FIREFOX" : "NONE";

        if(userAgentHeader == null || userAgentHeader.equals("")) {
        	usebrowser = "NONE";
        }

        String type = pAttachment ? "attachment" : "inline";

        if (isUTF8.equals("0") && (usebrowser.equals("Firefox") || usebrowser.equals("Safari"))) {
            response.addHeader("Content-Disposition", type + ";filename=\"" + new String(fileName.getBytes("UTF-8"), "ISO-8859-1") + "\"");
        } else {
            response.addHeader("Content-Disposition", type + ";filename=\"" + URLEncoder.encode((fileName), "UTF-8").replace("+", "%20") + "\"");
        }

        if (fileExt.equals(".pdf")) {
            response.setContentType("application/pdf");
        } else {
            response.setContentType("application/octet-stream");
        }

        try {
	        filePath = realPath + filePath;
	        File file = new File(commonUtil.detectPathTraversal(filePath));
	        is = new FileInputStream(file);

	        IOUtils.copy(is,response.getOutputStream());
        } catch(Exception e) {
			logger.debug("e.message=" + e.getMessage());
        } finally {
        	if (is != null) {
        		is.close();
        	}
        }

	}

	public String getProperFileName(String pOrgFileName, String pOrgFileExt, String pIsUTF8) throws Exception{
		int length = 0;
        int lengthLimit = 10000;
        String newFileName = "";

        if (!pOrgFileExt.equals(""))
        	pOrgFileName = pOrgFileName.substring(0, pOrgFileName.lastIndexOf("."));
        if (pOrgFileExt.equals(".doc") || pOrgFileExt.equals(".xls") || pOrgFileExt.equals(".ppt"))
        	lengthLimit = 110;
        if (pIsUTF8.equals("0"))
        	length = URLEncoder.encode(pOrgFileName + pOrgFileExt,"UTF-8").replace("+", "%20").length();
        else
        	length = URLEncoder.encode(pOrgFileName + pOrgFileExt,"UTF-8").replace("+", "%20").length();

        if (length > lengthLimit){
            newFileName = pOrgFileName;
            while (length > lengthLimit){
                newFileName = newFileName.substring(0, newFileName.length() - 1);
                if (pIsUTF8.equals("0"))
                	length = URLEncoder.encode(newFileName + pOrgFileExt,"UTF-8").replace("+", "%20").length();
                else
                	length = URLEncoder.encode(newFileName + pOrgFileExt, "UTF-8").replace("+", "%20").length();
            }
            pOrgFileName = newFileName;
        }

        return pOrgFileName + pOrgFileExt;
	}
	*/

	/**
	 * html -> mht 변환 실행 Method
	 */
	@Override
	public String startHtml2Mht(String m_strHTML, String realPath, Locale locale) throws Exception{
		StringBuilder mhtBuilder = new StringBuilder();
		StringBuilder htmlBuilder = new StringBuilder(m_strHTML);
        StringBuilder imagesBuilder = new StringBuilder();
        StringBuilder backgroundImagesBuilder = new StringBuilder();

		String m_strBoundary = "";

        if (!m_strHTML.equals("")) {
            //MHT 헤더 생성.
        	m_strBoundary = makeHeader(mhtBuilder);
        	//이미지 경로 추출 및 가상경로 매칭.
            List<String> imgSrcs = extractImageSource(htmlBuilder);
            //이미지 인코딩
            if (imgSrcs != null && !imgSrcs.isEmpty()) {
                htmlBuilder = doImageEncoding(imgSrcs, htmlBuilder, imagesBuilder, m_strBoundary, realPath);
            }
            //백그라운드 경로 추출 및 가상경로 매칭
            List<String> backgroundImgSrcs = extractBackgroundSource(htmlBuilder);
            //백그라운드 인코딩
            if (backgroundImgSrcs != null && !backgroundImgSrcs.isEmpty()) {
                htmlBuilder = doBackgrondEncding(backgroundImgSrcs, htmlBuilder, backgroundImagesBuilder, m_strBoundary, realPath);
            }
            //본문 인코딩
        	doHtmlEncoding(htmlBuilder, mhtBuilder, m_strBoundary);

        	//이미지 삽입
            mhtBuilder.append(imagesBuilder);
            mhtBuilder.append(backgroundImagesBuilder);


            mhtBuilder.append("--" + commonUtil.CRLF);

            return mhtBuilder.toString();
        } else {
        	return egovMessageSource.getMessage("main.t0603", locale);
        }
    }

	/**
	 * html -> mht 변환 헤더설정 표출 Method
	 */
	private String makeHeader(StringBuilder mhtBuilder) throws Exception{
		String m_strBoundary = createBoundary();
        mhtBuilder.append("MIME-Version: 1.0" + commonUtil.CRLF);
        mhtBuilder.append("Content-Type: Multipart/related;" + commonUtil.CRLF);
        mhtBuilder.append("  boundary=\"" + m_strBoundary + "\"" + commonUtil.CRLF);
        mhtBuilder.append("From: Kaoni MHT Component(UTF-8)" + commonUtil.CRLF);
        mhtBuilder.append("Subject: HTML to Mime-HTML" + commonUtil.CRLF);
        mhtBuilder.append("Date: " + getDate() + commonUtil.CRLF);
        mhtBuilder.append(commonUtil.CRLF + commonUtil.CRLF);

        return m_strBoundary;
    }

	/**
	 * boundary 생성 표출 Method
	 */
	private String createBoundary() throws Exception{
        String strBoundary = "Boundary-=_";
        SecureRandom Rnd = new SecureRandom();

        while (strBoundary.length() < 39) {
            int nch = Math.addExact(Rnd.nextInt(9), 1);

            if (nch < 26) {
                strBoundary += (char)(Math.addExact(65, nch));
            } else {
                strBoundary += (char)(Math.subtractExact(Math.addExact(97, nch), 26));
            }
        }
        return strBoundary;
    }

	/**
	 * 날짜반환 표출 Method
	 */
	private String getDate() throws Exception{
        Calendar calendar = Calendar.getInstance();

        String strDate = "";
        String strweek = "";
        String strMonth = "";

        int week = calendar.get(Calendar.DAY_OF_WEEK);

        switch (week) {
            case 1:
                strweek = "Sun";
                break;
            case 2:
                strweek = "Mon";
                break;
            case 3:
                strweek = "Tue";
                break;
            case 4:
                strweek = "Wed";
                break;
            case 5:
                strweek = "Thu";
                break;
            case 6:
                strweek = "Fri";
                break;
            case 7:
                strweek = "Sat";
                break;
        }

        int month = calendar.get(Calendar.MONTH);

        switch (month)
        {
            case 0:
                strMonth = "Jan";
                break;
            case 1:
                strMonth = "Feb";
                break;
            case 2:
                strMonth = "Mar";
                break;
            case 3:
                strMonth = "Apr";
                break;
            case 4:
                strMonth = "May";
                break;
            case 5:
                strMonth = "Jun";
                break;
            case 6:
                strMonth = "Jul";
                break;
            case 7:
                strMonth = "Aug";
                break;
            case 8:
                strMonth = "Sep";
                break;
            case 9:
                strMonth = "Oct";
                break;
            case 10:
                strMonth = "Nov";
                break;
            case 11:
                strMonth = "Dec";
                break;
        }

        strDate = strweek + ", " + calendar.get(Calendar.DATE) + " " + strMonth + " " + calendar.get(Calendar.YEAR) + " " + calendar.get(Calendar.HOUR_OF_DAY) + ":" + calendar.get(Calendar.MINUTE) + ":" + calendar.get(Calendar.SECOND);

        return strDate;
    }

	/**
	 * html -> mht 변환 이미지추출 표출 Method
	 */
	private List<String> extractImageSource(StringBuilder htmlBuilder) throws Exception{
	    logger.debug("extractImageSource started.");

        Document document = Jsoup.parse(htmlBuilder.toString());

        List<String> imgSrcs = new ArrayList<String>();

        getImgfilePath(imgSrcs, document);

        logger.debug("extractImageSource ended.");

        return imgSrcs;
    }

    private void getImgfilePath(List<String> imgSrcs, Document document) throws Exception {
        logger.info("getImgfilePath started");

        Elements elements = null;
        Element element = null;
        int imgTagCnt = document.getElementsByTag("img").size();
        String extractProcessType;

        if (imgTagCnt != 0) {
            extractProcessType = "0";

            elements = document.getElementsByTag("img");
        } else {
            extractProcessType = "1";

            element = document.getElementById("imagediv");
        }

        try {
            switch (extractProcessType) {
                case "0" : {
                    for (Element e : elements) {
                        imgSrcs.add(e.attr("src"));
                    }

                    break;
                }

                case "1" : {
                    /* 2024-06-17 김유진 - 백그라운드 이미지는 extractBackgroundSource 에서 처리되어 주석 처리함  */
//                    String attrList[] = element.attr("style").split(";");
//                    String imgPath;
//
//                    for (String s : attrList) {
//                        if (!s.contains("background-image")) {
//                            continue;
//                        }
//
//                        imgPath = "/" + s.substring(s.indexOf("url(\'") + 5, s.indexOf("\')"));
//                        imgSrcs.add(imgPath);
//                    }
//
//                    break;
                }
            }

            imgSrcs = imgSrcs.stream().distinct().collect(Collectors.toList());
        } catch (IndexOutOfBoundsException iobe) {
            logger.error(iobe.getMessage(), iobe);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }

        logger.info("getImgfilePath ended");
    }

	/**
	 * html -> mht 변환 배경화면추출 표출 Method
	 */
	private List<String> extractBackgroundSource(StringBuilder htmlBuilder) throws Exception {
		logger.debug("extractBackgroundSource started.");

        Document document = Jsoup.parse(htmlBuilder.toString());

        List<String> backgroundImgSrcs = new ArrayList<String>();

        Elements elements = document.select("body[style*='background-image'], table[style*='background-image'], td[style*='background-image']");

        if (!elements.isEmpty()) {
            int tempCount = 0;
            for (Element element : elements) {
                String[] firstSplit = element.attr("style").split(":");
                String[] secondSplit;

                for (int i = 0; i < firstSplit.length; i++) {
                    secondSplit = firstSplit[i].split(";");

                    if (i % 2 != 0) {
                        if (secondSplit.length == 1) break;
                        if (secondSplit[1].trim().equalsIgnoreCase("background-image")) {
                            String backgroundImbUrl = (firstSplit[i + 1].split(";")[0].trim()).replaceAll("^url\\([\"|']", "").replaceAll("[\"|']\\)$", "");
                            backgroundImgSrcs.add(backgroundImbUrl);
                            logger.debug(backgroundImgSrcs.get(tempCount));
                            tempCount++;
                        }
                    } else {
                        if (i + 1 == firstSplit.length) break;
                        if (firstSplit[i].split(";")[secondSplit.length - 1].trim().equalsIgnoreCase("background-image")) {
                            String backgroundImbUrl = (firstSplit[i + 1].split(";")[0].trim()).replaceAll("^url\\([\"|']", "").replaceAll("[\"|']\\)$", "");
                            backgroundImgSrcs.add(backgroundImbUrl);
                            logger.debug(backgroundImgSrcs.get(tempCount));
                            tempCount++;
                        }
                    }
                }
            }
        }

        backgroundImgSrcs = backgroundImgSrcs.stream().filter(backgroundImgSrc -> !backgroundImgSrc.equalsIgnoreCase("none")).distinct().collect(Collectors.toList());

        logger.debug("extractBackgroundSource ended.");

        return backgroundImgSrcs;
    }

	/**
	 * html -> mht 변환 html 인코딩 실행 Method
	 */
	private void doHtmlEncoding(StringBuilder htmlBuilder, StringBuilder mhtBuilder, String m_strBoundary) throws Exception{
        mhtBuilder.append("--" + m_strBoundary + commonUtil.CRLF);
        mhtBuilder.append("Content-Type: Text/HTML" + commonUtil.CRLF);
        mhtBuilder.append("Content-Transfer-Encoding: base64" + commonUtil.CRLF);
        mhtBuilder.append("Content-Location: file://c:" + commonUtil.separator + "test.htm" + commonUtil.CRLF);
        mhtBuilder.append(commonUtil.CRLF);

        byte[] arr = htmlBuilder.toString().getBytes("UTF-8");
        String strMhtBase64 = Base64.getMimeEncoder().encodeToString(arr);

        mhtBuilder.append(strMhtBase64 + commonUtil.CRLF);
        mhtBuilder.append("--" + m_strBoundary);
    }

	/**
	 * html -> mht 변환 이미지인코딩 실행 Method
	 * @param realPath
	 */
	private StringBuilder doImageEncoding(List<String> imgSrcs, StringBuilder htmlBuilder, StringBuilder imagesBuilder, String m_strBoundary, String realPath) throws Exception {
	    logger.debug("doImageEncoding started.");

	    String tempHtml = htmlBuilder.toString();

        for (String imgSrc : imgSrcs) {
            String contentType = "application/octet-stream";
            String extension = ".gif"; //기존확장자가.gif로고정되어있었으므로,디폴트로사용함

            InputStream tempIn = null;
            try {
            	if (imgSrc.contains("222.106.242.180")) {
            		continue;
            	} else {
            		tempIn = Files.newInputStream(Paths.get(realPath + imgSrc));
            		contentType = URLConnection.guessContentTypeFromStream(tempIn);
            	}
            } catch (IOException e) {
                //url 일 시 realPath + path 로 exception 발생 -> 위의 default값 사용하므로 따로 exception 처리 하지 않음.
				logger.debug("e.message=" + e.getMessage());
            } finally {
                if (tempIn != null) {
                    tempIn.close();
                }
            }

            if (contentType == null) {
                contentType = "application/octet-stream";
            } else {
                contentType = contentType.replace("image", "Image");
                extension = "." + contentType.split("/")[1];
            }

            logger.debug("imgSrc = " + imgSrc);
            /*
                imgSrc compile 중 boardID의 {}로 에러가 발생, 임시로 !!Q, !!W로 치환
            */
            imgSrc = imgSrc.replaceAll("\\{", "!!Q").replaceAll("\\}", "!!W");
            tempHtml = tempHtml.replaceAll("\\{", "!!Q").replaceAll("\\}", "!!W");
            tempHtml = Pattern.compile(imgSrc).matcher(tempHtml).replaceAll("file:///C:/IMAGE" + (imgSrcs.indexOf(imgSrc) + 1) + extension);
            tempHtml = Pattern.compile(imgSrc.substring(1)).matcher(tempHtml).replaceAll("file:///C:/IMAGE" + (imgSrcs.indexOf(imgSrc) + 1) + extension);

            imgSrc = imgSrc.replaceAll("!!Q", "\\{").replaceAll("!!W", "\\}");
            tempHtml = tempHtml.replaceAll("!!Q", "\\{").replaceAll("!!W", "\\}");

            imagesBuilder.append(commonUtil.CRLF + "Content-Type: " + contentType + commonUtil.CRLF);
            imagesBuilder.append("Content-Transfer-Encoding: base64" + commonUtil.CRLF);
            imagesBuilder.append("Content-Location: file:///C:/IMAGE" + (imgSrcs.indexOf(imgSrc) + 1) + extension + commonUtil.CRLF);
            imagesBuilder.append(commonUtil.CRLF);

            ByteArrayOutputStream byteOutStream = new ByteArrayOutputStream();
            InputStream in = null;

            logger.debug("index = " + imgSrcs.indexOf(imgSrc));

            if (imgSrc.startsWith("http")) {
                if (imgSrc.equals("https")) {
                    // Create a trust manager that does not validate certificate chains
                    TrustManager[] trustAllCerts = new TrustManager[]{new X509TrustManager() {
                        public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                            return null;
                        }

                        public void checkClientTrusted(X509Certificate[] certs, String authType) {
                        }

                        public void checkServerTrusted(X509Certificate[] certs, String authType) {
                        }
                    }
                    };

                    // Install the all-trusting trust manager
                    SSLContext sc = null;

                    try {
                        sc = SSLContext.getInstance("SSL");
                        // 2023-05-12 이사라 : NullPointerException 시큐어코딩
						if (!Objects.isNull(sc)) {
							sc.init(null, trustAllCerts, new java.security.SecureRandom());
							HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
						}

                    } catch (Exception e) {
                        logger.error(e.getMessage(), e);
                    }

                    //HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory()); // try문 안으로 이동

                    // Create all-trusting host name verifier
                    HostnameVerifier allHostsValid = new HostnameVerifier() {
                        public boolean verify(String hostname, SSLSession session7) {
                            return true;
                        }
                    };

                    // Install the all-trusting host verifier
                    HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);
                }

                try {
                    URL url = new URL(imgSrc);
                    in = url.openStream();
                } catch (Exception e) {
                    logger.error(e.getMessage(), e);
                }
            } else {
                try {
                    String fisPath = new File(realPath + imgSrc).exists() ? realPath + imgSrc : realPath + "/" + imgSrc;
                    in = new FileInputStream(fisPath);

                    logger.debug(realPath + imgSrc + " is exist.");
                } catch (Exception e) {
                    try {
                        in = new FileInputStream(imgSrc);
                        logger.debug(realPath + imgSrc + " is not exist. ::: " + e.getMessage());
                        logger.debug(imgSrc + " is exist.");
                    } catch (Exception e2) {
                        try {
                            in = new FileInputStream(realPath + "/images/default_pic.jpg");
                            logger.debug(imgSrc + " is not exist. ::: " + e2.getMessage());
                            logger.debug("change default image.");
                        } catch (Exception e3) {
                            logger.debug("path = " + realPath + "/images/default_pic.jpg");
                            logger.debug(e3.getMessage());
                        }
                    }
                }
            }

            int len = 0;
            byte[] buf = new byte[1024];

            try {
                while ((len = in.read(buf)) != -1) {
                    byteOutStream.write(buf, 0, len);
                }

                byte[] imageByte = byteOutStream.toByteArray();
                String strImageData = new String(Base64.getMimeEncoder().encodeToString(imageByte));

                imagesBuilder.append(strImageData + commonUtil.CRLF);
                imagesBuilder.append("--" + m_strBoundary);
            } catch (Exception e) {
                logger.debug(e.getMessage());
            } finally {
                if (in != null) {
                    in.close();
                }
                if (byteOutStream != null) {
                	byteOutStream.close();
                }
            }
        }

        htmlBuilder = new StringBuilder(tempHtml);

        logger.debug("doImageEncoding ended.");

        return htmlBuilder;
    }

	/**
	 * html -> mht 변환 배경화면인코딩 실행 Method
	 */
	private StringBuilder doBackgrondEncding(List<String> backgroundImgSrcs, StringBuilder htmlBuilder, StringBuilder backgroundImagesBuilder, String m_strBoundary, String realPath) throws Exception{
        logger.debug("doBackgrondEncding started.");

        String tempHtml = htmlBuilder.toString();

        for(String backgroundImgSrc : backgroundImgSrcs) {
            String contentType = "application/octet-stream";
            String extension = ".gif"; //기존확장자가.gif로고정되어있었으므로,디폴트로사용함

            InputStream tempIn = null;
            try {
                tempIn = Files.newInputStream(Paths.get(realPath, backgroundImgSrc));
                contentType = URLConnection.guessContentTypeFromStream(tempIn);
            } catch (Exception e) {
                logger.error(e.getMessage(), e);
            } finally {
                if (tempIn != null) {
                    tempIn.close();
                }
            }

            if (contentType == null) {
                contentType = "application/octet-stream";
            } else {
                contentType = contentType.replace("image", "Image");
                extension = "." + contentType.split("/")[1];
            }

            // imgSrc compile 중 boardID의 {}로 에러가 발생, 임시로 !!Q, !!W로 치환
            backgroundImgSrc = backgroundImgSrc.replaceAll("\\{", "!!Q").replaceAll("\\}", "!!W");
            tempHtml = tempHtml.replaceAll("\\{", "!!Q").replaceAll("\\}", "!!W");
            tempHtml = Pattern.compile(backgroundImgSrc).matcher(tempHtml).replaceAll("file:///C:/BACKGROUNDIMAGE" + (backgroundImgSrc.indexOf(backgroundImgSrc) + 1) + extension);

            backgroundImgSrc = backgroundImgSrc.replaceAll("!!Q", "\\{").replaceAll("!!W", "\\}");
            tempHtml = tempHtml.replaceAll("!!Q", "\\{").replaceAll("!!W", "\\}");

            backgroundImagesBuilder.append(commonUtil.CRLF + "Content-Type: " + contentType + commonUtil.CRLF);
            backgroundImagesBuilder.append("Content-Transfer-Encoding: base64" + commonUtil.CRLF);
            backgroundImagesBuilder.append("Content-Location: file:///C:/BACKGROUNDIMAGE" + (backgroundImgSrcs.indexOf(backgroundImgSrc) + 1) + extension + commonUtil.CRLF);
            backgroundImagesBuilder.append(commonUtil.CRLF);

            ByteArrayOutputStream byteOutStream = new ByteArrayOutputStream();
            InputStream in = null;

            logger.debug("index = " + backgroundImgSrcs.indexOf(backgroundImgSrc));

            if (backgroundImgSrc.startsWith("http")) {
                if (backgroundImgSrc.equals("https")) {
                    // Create a trust manager that does not validate certificate chains
                    TrustManager[] trustAllCerts = new TrustManager[]{new X509TrustManager() {
                        public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                            return null;
                        }

                        public void checkClientTrusted(X509Certificate[] certs, String authType) {
                        }

                        public void checkServerTrusted(X509Certificate[] certs, String authType) {
                        }
                    }
                    };

                    // Install the all-trusting trust manager
                    SSLContext sc = null;

                    try {
                        sc = SSLContext.getInstance("SSL");
                        // 2023-05-12 이사라 : NullPointerException 시큐어코딩
						if (!Objects.isNull(sc)) {
							sc.init(null, trustAllCerts, new java.security.SecureRandom());
							HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
						}

                    } catch (Exception e) {
                        logger.error(e.getMessage(), e);
                    }

                    //HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory()); // try문 안으로 이동

                    // Create all-trusting host name verifier
                    HostnameVerifier allHostsValid = new HostnameVerifier() {
                        public boolean verify(String hostname, SSLSession session7) {
                            return true;
                        }
                    };

                    // Install the all-trusting host verifier
                    HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);
                }

                try {
                    URL url = new URL(backgroundImgSrc);
                    in = url.openStream();
                } catch (Exception e) {
                    logger.error(e.getMessage(), e);
                }
            } else {
                try {
                    String fisPath = new File(realPath + backgroundImgSrc).exists() ? realPath + backgroundImgSrc : realPath + "/" + backgroundImgSrc;
                    in = new FileInputStream(fisPath);
                    logger.debug(realPath + backgroundImgSrc + " is exist.");
                } catch (Exception e) {
                    try {
                        in = new FileInputStream(backgroundImgSrc);
                        logger.debug(realPath + backgroundImgSrc + " is not exist. ::: " + e.getMessage());
                        logger.debug(backgroundImgSrc + " is exist.");
                    } catch (Exception e2) {
                        try {
                            in = new FileInputStream(realPath + "/images/default_pic.jpg");
                            logger.debug(backgroundImgSrc + " is not exist. ::: " + e2.getMessage());
                            logger.debug("change default image.");
                        } catch (Exception e3) {
                            logger.debug("path = " + realPath + "/images/default_pic.jpg");
                            logger.debug(e3.getMessage());
                        }
                    }
                }
            }

            int len = 0;
            byte[] buf = new byte[1024];

            try {
                while ((len = in.read(buf)) != -1) {
                    byteOutStream.write(buf, 0, len);
                }

                byte[] imageByte = byteOutStream.toByteArray();
                String strImageData = new String(Base64.getMimeEncoder().encodeToString(imageByte));

                byteOutStream.close();

                backgroundImagesBuilder.append(strImageData + commonUtil.CRLF);
                backgroundImagesBuilder.append("--" + m_strBoundary);
            } catch (Exception e) {
                logger.debug(e.getMessage());
            } finally {
                if (in != null) {
                    in.close();
                }
            }
        }

        htmlBuilder = new StringBuilder(tempHtml);

        logger.debug("doBackgrondEncding ended.");

        return htmlBuilder;
    }

	/**
	 * html -> mht 변환 표출 Method
	 */
	@Override
	public String getMHTtoHTML(String type, String itemID, int tenantID, String realPath, HttpServletRequest request, Locale locale, String scheme) throws Exception{
        String filePath = "";
        String uploadModule = commonUtil.getUploadPath("upload_common.MHTIMAGE", tenantID) + commonUtil.separator;
        String domain = request.getServerName() +":" +request.getServerPort();

        filePath = realPath + uploadModule;
        EzFAL.EzFile file = new EzFAL.EzFile(filePath);

        if (!file.exists()) {
        	file.mkdirs();
        }

        String url = "";
        if (type.equals("HTMLPORTLET") || type.equals("BOARDCONTENT") || type.equals("BOARDCONTENTTEMP") || type.equals("BOARDFORM") || type.equals("COMMUNITYCONTENT") || type.equals("")) {
        	url = request.getParameter("href");
        } else if (type.equals("COMMUNITYNOTI")) {
        	url = commonUtil.getUploadPath("upload_community.MAINBOARD", tenantID) + commonUtil.separator + request.getParameter("href");
        } else if (type.equals("SCHEDULECONTENT")) {
        	url = commonUtil.getUploadPath("upload_schedule.ROOT", tenantID) + itemID;
        } else if (type.equals("TASKCONTENT") || type.equals("TASKCONTENT2")) {
        	url = commonUtil.getUploadPath("upload_task.ROOT", tenantID) + commonUtil.separator + itemID;
        }

        String m_strMHT = "";

        try {
    		m_strMHT = loadMHTFile(realPath + url);
		} catch (Exception e) {
			m_strMHT= "";
		}

        String strHTML = startMHT2HTML(filePath, m_strMHT, filePath, realPath, locale, domain, scheme);

        if (strHTML.trim().length() > 0) {
        	return strHTML;
        } else {
        	return "<HTML><HEAD><TITLE></TITLE><META content=\"text/html; charset=utf-8\" http-equiv=Content-Type></HEAD><STYLE title=\"ezform_style_1\">P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm; *font-size:x-small; } </STYLE><BODY></BODY></HTML>";
        }
	}

	/**
	 * html -> mht 변환 실행 표출 Method
	 * @param domain
	 * @param scheme
	 */
	@Override
	public String startMHT2HTML(String m_strLPath, String m_strMHT, String m_strSPath, String realPath, Locale locale, String domain, String scheme) throws Exception{
		logger.debug("====== startMHT2HTML started ======");
		String m_strHTML = "";
		String strBoundary = "";
		String[] m_Mimechunk = null;
		List<String> m_ListImageLocation = new ArrayList<String>();
		List<String> m_ListImageLocalLocation = new ArrayList<String>();
		String extension = ".gif"; // 기존 확장자가 .gif로 고정되어 있었으므로, 디폴트로 사용함
		boolean isUTF8;
		
		strBoundary = getBoundaryText(m_strMHT);
		logger.debug("strBoundary="+strBoundary);

		if (m_strMHT != null && !m_strMHT.equals("")) {
			if (strBoundary.equals("error")) {
				return egovMessageSource.getMessage("main.t0600", locale);
			} else {
				m_Mimechunk = m_strMHT.split(strBoundary);
//				logger.debug("m_Mimechunk="+m_Mimechunk);
				
				//문서 인코딩 방식 추출 
                if (m_Mimechunk[0].indexOf("(UTF-8)") > -1) 
                    isUTF8 = true; 
                else 
                    isUTF8 = false; 
				
				for (int i = 1; i < m_Mimechunk.length; i++) {
					String[] strMimeChunk = m_Mimechunk[i].split(commonUtil.CRLF + commonUtil.CRLF);
					String[] strMime_info_p = strMimeChunk[0].trim().split(commonUtil.CRLF);
					String[] strMime_info_tupe = strMime_info_p[0].split(": ");

					if (strMime_info_tupe[0].equals("Content-Type")) {
						if (strMime_info_tupe[1].equals("Text/HTML")) {
							m_strHTML = doMHTDecoding(strMimeChunk[1].trim(), m_strHTML, isUTF8);
						}
						/* 2018-08-14 홍승비 - mht->html 변환 시 이미지 디코딩(content-type) 수정 */
						else if (strMime_info_tupe[1].contains("Image/") || strMime_info_tupe[1].contains("application/octet-stream")) {
							String[] strMime_info_location = strMime_info_p[2].split(": ");

							if (strMime_info_location[0].equals("Content-Location")) {
								m_ListImageLocation.add(strMime_info_location[1]);
								extension = "." + strMime_info_location[1].split("\\.")[1];
							}
							m_ListImageLocalLocation.add(doImageDecoding(strMimeChunk[1].trim(), m_strSPath, m_strLPath, extension));
						}
					}
				}

				if (m_ListImageLocation.size() == m_ListImageLocalLocation.size()) {
					for (int i = 0; i < m_ListImageLocation.size(); i++) {
						m_strHTML = m_strHTML.replace(m_ListImageLocation.get(i), m_ListImageLocalLocation.get(i).replace(realPath, ""));
					}
				} else {
					return egovMessageSource.getMessage("main.t0601", locale);
				}

//				배경이미지 url의 표현방법 수정//태그프리,CK는 정상으로 들어옴
				if(m_strHTML.contains("///fileroot")){//NAMO//2018.04.05 재수정
					m_strHTML = m_strHTML.replace("///fileroot", "/fileroot");
				}else if(m_strHTML.contains("//fileroot")){
					m_strHTML = m_strHTML.replace("//fileroot", "/fileroot");
					m_strHTML = m_strHTML.replace("')", ")");
				}else if(m_strHTML.contains("url('fileroot")){//KUKUDOCS
					m_strHTML = m_strHTML.replace("url('fileroot", "url(/fileroot");
					m_strHTML = m_strHTML.replace("')", ")");
				}

                // dhlee: 20240718 - 웹취약점 대응
                m_strHTML = commonUtil.stripScriptTagsAndFunctions(m_strHTML);

                return m_strHTML;
			}
		} else {

			return egovMessageSource.getMessage("main.t0602", locale);
		}
	}

	/**
	 * html -> mht 변환 이미지디코딩 표출 Method
	 */
	private String doImageDecoding(String strImageMht, String m_strSPath, String m_strLPath, String extension) throws Exception{
		byte[] imageBytes = Base64.getMimeDecoder().decode(strImageMht);

		/* 2018-08-16 홍승비 - mht파일 내의 이미지 이름을 .tmp -> 원래 확장자로 변경 */
		String strImageName = UUID.randomUUID() + extension;
        String SfilePath = m_strSPath + strImageName;
        String LfilePath = m_strLPath + strImageName;
        File file = new File(commonUtil.detectPathTraversal(m_strLPath));

        if (!file.exists()) {
        	file.mkdirs();
        }

        OutputStream bos = null;
        try {
        	bos = new FileOutputStream(new File(commonUtil.detectPathTraversal(LfilePath)));
        	bos.write(imageBytes);
		} catch (Exception e) {
			logger.debug("e: {}", e);
		} finally {
			if (bos != null) {
				try {
					bos.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
			}
		}

		return SfilePath;
	}

	/**
	 * html -> mht 변환 mht디코딩 표출 Method
	 */
	private String doMHTDecoding(String strMht, String m_strHTML, boolean isUTF8) {
		byte[] arr = Base64.getMimeDecoder().decode(strMht);

		try {
			//m_strHTML = new String(arr, "utf-8");
			if(isUTF8)
                m_strHTML = new String(arr, "utf-8");
            else
                m_strHTML = new String(arr, "ks_c_5601-1987");
		} catch (UnsupportedEncodingException e) {
			logger.error(e.getMessage(), e);
		}

		return m_strHTML;
	}

	/**
	 * html -> mht 변환boundary 반환 표출 Method
	 */
	private String getBoundaryText(String m_strMHT) {
		String strTemp = m_strMHT;
        int nPos = strTemp.indexOf("boundary=");

        if (nPos > 0) {
            int nEndPos = strTemp.indexOf("\"", nPos + 10);
            return "--" + strTemp.substring(nPos + 10, nEndPos);
        } else {
            return "error";
        }
	}

	/**
	 * mht 로드 표출 Method
	 */
	@Override
	public String loadMHTFile(String strMHTpath) throws Exception{
		String strMhtData = "";
		byte[] fileBytes = commonUtil.readBytesFromFile(Paths.get(commonUtil.detectPathTraversal(strMHTpath.trim())));

		// klib 복호화
		if (strMHTpath.endsWith("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
			fileBytes = klibUtil.decrypt(fileBytes);
		}

	    try (BufferedReader br = new BufferedReader(new InputStreamReader(new ByteArrayInputStream(fileBytes)))) {
	        StringBuilder sb = new StringBuilder();
	        String line = br.readLine();

	        while (line != null) {
	            sb.append(line);
	            sb.append(commonUtil.CRLF);
	            line = br.readLine();
	        }
	        strMhtData = sb.toString();
	    }

        return strMhtData.replace("&lt;", "<").replace("&lt;", "<").replace("&gt;", ">").replace("&quot;", "\"").replace("&apos;", "\'");
    }

	@Override
	public void createTblSession() throws Exception {
		createTblSessionForLocal();
	}

	private void createTblSessionForLocal() throws Exception {
		ezCommonDAO.createTblSession();
	}

	@Override
	public String selectUserGetLang(String userID, int tenantID) throws Exception {
		return ezCommonDAO.selectUserGetLang(userID, tenantID);
	}

	@Override
	public String selectUserGetTimeZone(String userID, int tenantID) throws Exception {
		return ezCommonDAO.selectUserGetTimeZone(userID, tenantID);
	}

    private String getTenantConfigForLocal(String property, int tenantID) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("property", property.toUpperCase());
        map.put("tenantID", tenantID);

        String propertyValue = ezCommonDAO.getTenantConfig(map);

		if (!property.equals("ApprovalFlag")) {
			logger.debug("PROPERTY NAME : {} || PROPERTY VALUE : {} || TENANTID : {} ", property, propertyValue, tenantID);
		}

        if (propertyValue == null) {
            propertyValue = "";
        }

        return propertyValue;
    }

	@Override
	public String getTenantConfig(String property, int tenantID) throws Exception {
		return getTenantConfigForLocal(property, tenantID);
	}

	@Override
	public Map<String, Object> getTenantConfigs(int tenantID) throws Exception {
		logger.debug("getTenantConfigs started");

		Map<String, Object> map = ezCommonDAO.getTenantConfigs(tenantID);

		logger.debug("getTenantConfigs ended");

		return map;
	}

	@Override
	public void insertTblUserLocalInfo(String userID, String timeZone, String lang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_TENANT_ID", tenantID);
		map.put("userID", userID);
		map.put("timeZone", timeZone);
		map.put("lang", lang);

		ezCommonDAO.insertTblUserLocalInfo(map);
	}

	/**
	 * 환경설정 저장 Method
	 */
	public String saveUserLocalInfo (String pUserID, LoginVO userInfo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_TENANT_ID", userInfo.getTenantId());
		map.put("userID", pUserID);

		ezCommonDAO.deleteUserLocalInfo(map);

		Map<String, Object> map1 = new HashMap<String, Object>();

		logger.debug("pUserID="+pUserID);
		logger.debug("timeZone="+userInfo.getOffset());
		logger.debug("lang="+userInfo.getLang());

		map1.put("v_TENANT_ID", userInfo.getTenantId());
		map1.put("userID", pUserID);
		map1.put("timeZone", userInfo.getOffset());
		map1.put("lang", userInfo.getLang());

        ezCommonDAO.insertTblUserLocalInfo(map1);

        map1.put("userId",pUserID);
        map1.put("tenantId",userInfo.getTenantId());
        MOptionVO mOptionVO = mOptionDAO.optionInfo(map1);
        if (mOptionVO!=null){
            map1.put("lang",mOptionVO.getLang());
            map1.put("mainType",mOptionVO.getMainType());
            map1.put("listCnt",mOptionVO.getListCnt());
            map1.put("useSecurity",mOptionVO.getUseSecurity());
            mOptionDAO.deleteOption(map);
        }else{
            map1.put("mainType","D");
            map1.put("listCnt","10");
            map1.put("useSecurity","N");
        }

        mOptionDAO.insertOption(map1);

		return "OK";
	}

	@Override
	public List<TenantVO> getTenantList() throws Exception {
        return ezCommonDAO.getTenantList();
	}

	@Override
	public List<TenantServerNameVO> getTenantServerNameList() throws Exception {
        return ezCommonDAO.getTenantServerNameList();
	}

	@Override
	public int getTenantIdByDomainName(String domainName) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("DOMAIN_NAME", domainName);

		return ezCommonDAO.getTenantIdByDomainName(map);
	}

	/* 2021-11-01 이사라 : 가장최근에 사용했던 비밀번호 유효성 검사 */
	public String getPrevPwd(int tenantID, String userID) throws Exception {
		return getUserConfigInfo(tenantID, userID, "prevPwd");
	}
	
	public int setPrevPwd(int tenantID, String userID, String propertyValue) throws Exception {
		boolean hasUserConfigProperty  = checkHasUserConfigProperty(tenantID, userID, "prevPwd");
		
		if (hasUserConfigProperty) {
     
            String prevPwd = getPrevPwd(tenantID, userID);
            String[] prevPwdList = prevPwd.split(":");

            OrganUserVO user = ezOrganService.getUserInfo(userID,"1",tenantID);
            // 저장 할 값
            String prevPwdValue = "";
            StringJoiner joiner = new StringJoiner(":");
            String rememberPWCountConfig = ezCommonService.getCompanyConfig(tenantID, user.getPhysicalDeliveryOfficeName(), "RememberPWCount");
            int rememberPWCount = rememberPWCountConfig == null || "".equalsIgnoreCase(rememberPWCountConfig) ? 0 : Integer.parseInt(rememberPWCountConfig);
            
            if (prevPwdList.length < rememberPWCount) {
                // 저장된 비밀번호가 rememberPWCount개 미만일 경우
                prevPwdValue = joiner.add(prevPwd)
                        .add(propertyValue)
                        .toString();
            } else {
                // 저장된 비밀번호가 rememberPWCount 이상일 경우 맨 처음 저장된 값 을 뺴고 합친다.
                int startIdx = Math.max(0, prevPwdList.length - rememberPWCount + 1);
                for (int i = startIdx; i < prevPwdList.length; i++) {
                    joiner.add(prevPwdList[i]);
                }
                // 새로운 비밀번호 추가
                prevPwdValue = joiner.add(propertyValue).toString();
            }
            
            return updateUserConfigInfo(tenantID, userID, "prevPwd", prevPwdValue);
		} else {
			insertUserConfigInfo(tenantID, userID, "prevPwd", propertyValue);
			return 0;
		}
	}
	
	@Override
	public String getUserConfigInfo(int tenantID, String userID, String propertyName) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenant_id", tenantID);
		map.put("user_id", userID);
		map.put("property_name", propertyName);

		String propertyValue = ezCommonDAO.getUserConfigInfo(map);

        if (propertyValue == null) {
            propertyValue = "";
        }

        return propertyValue;

	}

	@Override
	public boolean checkHasUserConfigProperty(int tenantID, String userID, String propertyName) throws Exception {
		boolean result = false;

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenant_id", tenantID);
		map.put("user_id", userID);
		map.put("property_name", propertyName);

		int propertyNameCount = ezCommonDAO.checkHasUserConfigProperty(map);

		if (propertyNameCount > 0) {
			result = true;
		}

		return result;
	}

	@Override
	public int updateUserConfigInfo(int tenantID, String userID, String propertyName, String propertyValue) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenant_id", tenantID);
		map.put("user_id", userID);
		map.put("property_name", propertyName);
		map.put("property_value", propertyValue);

		return ezCommonDAO.updateUserConfigInfo(map);
	}

	@Override
	public void insertUserConfigInfo(int tenantID, String userID, String propertyName, String propertyValue) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenant_id", tenantID);
		map.put("user_id", userID);
		map.put("property_name", propertyName);
		map.put("property_value", propertyValue);

		ezCommonDAO.insertUserConfigInfo(map);
	}

    @Override
    public void deleteUserConfigInfo(int tenantID, String userID, String propertyName) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("tenant_id", tenantID);
        map.put("user_id", userID);
        map.put("property_name", propertyName);

        ezCommonDAO.deleteUserConfigInfo(map);
    }
    
	@Override
	public void createTblCompanyConfig() throws Exception {
		ezCommonDAO.createTblCompanyConfig();
	}

	@Override
	public String getCompanyConfig(int tenantID, String companyID, String property) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
        map.put("property", property.toUpperCase());
        map.put("companyID", companyID);
        map.put("tenantID", tenantID);

        String propertyValue = ezCommonDAO.getCompanyConfig(map);

		logger.debug("PROPERTY NAME : {} || PROPERTY VALUE : {} || TENANTID : {} || COMPANYID : {}", property, propertyValue, tenantID, companyID);
		//logger.debug("PROPERTY VALUE : " + propertyValue); // 로그정리

        if (propertyValue == null) {
            propertyValue = "";
        }

        return propertyValue;
    }

	@Override
	public void insertCompanyConfig(int tenantId, String companyId, String propertyName, String propertyValue) throws Exception {
		logger.debug("insertCompanyConfig started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("tenantID", tenantId);
		map.put("companyID", companyId);
		map.put("propertyName", propertyName);
		map.put("propertyValue", propertyValue);

		logger.debug("PROPERTY NAME : {} || PROPERTY VALUE : {} || TENANTID :  {} || COMPANYID : {}", propertyName, propertyValue, tenantId, companyId);
		//logger.debug("PROPERTY VALUE : " + propertyValue); // 로그정리

		ezCommonDAO.insertCompanyConfig(map);

		logger.debug("insertCompanyConfig ended");
	}

	@Override
	public void updateCompanyConfig(int tenantId, String companyId, String propertyName, String propertyValue) throws Exception {
		logger.debug("updateCompanyConfig started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("tenantID", tenantId);
		map.put("companyID", companyId);
		map.put("propertyName", propertyName);
		map.put("propertyValue", propertyValue);

		logger.debug("PROPERTY NAME : {} || PROPERTY VALUE : {} || TENANTID : {} || COMPANYID : {}", propertyName, propertyValue, tenantId, companyId);
		//logger.debug("PROPERTY VALUE : " + propertyValue); // 로그정리

		ezCommonDAO.updateCompanyConfig(map);

		logger.debug("updateCompanyConfig ended");
	}

	@Override
	public void deleteCompanyConfig(int tenantId, String companyId, String propertyName) throws Exception {
		logger.debug("deleteCompanyConfig started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("tenantID", tenantId);
		map.put("companyID", companyId);
		map.put("propertyName", propertyName);

		logger.debug("PROPERTY NAME : " + propertyName + "||" + "TENANTID : " + tenantId + "||" + "COMPANYID : " + companyId);

		ezCommonDAO.deleteCompanyConfig(map);

		logger.debug("deleteCompanyConfig ended");
	}
	
	// 중복로그인 시간 갱신
	@Override
	public void setMultiLoginUser(int tenantID, String companyId, String userID, String loginTime, Device deviceType) throws Exception {
		logger.debug("insertMultiLoginUser started");

		if (deviceType.isMobile()) {
			logger.debug("isMobile");
		}

		boolean isMobileIntegrated = isMobileIntegratedMultiLogin(companyId, tenantID);
		Map<String, Object> map = new HashMap<>();

		map.put("tenantID", tenantID);
		map.put("userID", userID);
		map.put("loginTime", loginTime);
		map.put("isMobileIntegrated", isMobileIntegrated);
		map.put("mobileFlag", deviceType.isMobile() && !isMobileIntegrated ? 1 : 0);

		try {
			ezCommonDAO.deleteMultiLoginUser(map);
			ezCommonDAO.insertMultiLoginUser(map);
		} catch (DeadlockLoserDataAccessException e) {
			//데드락이 발생하면 실패한 작업 다시 실행

			Thread.sleep(1000);

			ezCommonDAO.deleteMultiLoginUser(map);
			ezCommonDAO.insertMultiLoginUser(map);
		}

		logger.debug("insertMultiLoginUser ended");
	}

	// PC 중복로그인 시간 가져오기
	@Override
	public String selectMultiLoginTime(int tenantID, String companyId, String userID, Device deviceType) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("tenantID", tenantID);
		map.put("userID", userID);
		map.put("mobileFlag", deviceType.isMobile() && !isMobileIntegratedMultiLogin(companyId, tenantID));

		return Optional.ofNullable(ezCommonDAO.selectMultiLoginUser(map)).orElse("");
	}

	// PC 중복로그인 본인확인
	@Override
	public boolean matchMultiLoginTime(int tenantID, String companyId, String userID, String loginTime, Device deviceType) throws Exception {
		logger.debug("matchMultiLoginTime started");

		if (deviceType.isMobile()) {
			logger.debug("isMobile");
		}

		// 멀티로그인 시간을 비교해서 새로운 로그인 유저가 없다면 true 새로운 로그인 유저가 있다면 false
		Map<String, Object> map = new HashMap<>();

		map.put("tenantID", tenantID);
		map.put("userID", userID);
		map.put("mobileFlag", deviceType.isMobile() && !isMobileIntegratedMultiLogin(companyId, tenantID) ? 1 : 0);

		String previousLoginTime = Optional.ofNullable(ezCommonDAO.selectMultiLoginUser(map)).orElse("");

		logger.debug("matchMultiLoginTime ended");

		return loginTime.equals(previousLoginTime);
	}

	/**
	 * 중복로그인 체크를 PC와 Mobile에 대해 통합적으로 진행합니다.<br>
	 * 즉, true라면 다른 기기에서의 로그인을 제한합니다. (PC, Mobile 총 1개 허용)<br>
	 * false라면 각각 체크합니다. (PC 1개, Mobile 1개 허용)<br>
	 * useMobileIntergratedMultiLogin 테넌트 콘피그의 옵션을 가져옵니다.
	 */
	private boolean isMobileIntegratedMultiLogin(String companyId, int tenantId) throws Exception {
		return "YES".equalsIgnoreCase(getCompanyConfig(tenantId, companyId, "useMobileIntergratedMultiLogin"));
	}

	@Override
	public void createTblUserMultiLogin() throws Exception {
		ezCommonDAO.createTblUserMultiLogin();
	}

	@Override
	public void createTblIPAccessID() throws Exception {
		ezCommonDAO.createTblIPAccessID();
	}

	@Override
	public void createTblIPAccessIP() throws Exception {
		ezCommonDAO.createTblIPAccessIP();
	}

	@Override
	public void createJMochaDistributionSub() throws Exception {
		ezCommonDAO.createJMochaDistributionSub();
	}

	@Override
	public void createJMochaMailSignatureTemplate() throws Exception {
		ezCommonDAO.createJmochaMailSignatureTemplate();
	}

	public void createJobMasterTable() throws Exception {
		ezCommonDAO.createJobMasterTable();
	}

	@Override
	public String getUseSession(Map<String, Object> map) {
		return ezCommonDAO.getUseSession(map);
	}

	@Override
	public void insertUseSession(Map<String, Object> map) {
		ezCommonDAO.insertUseSession(map);
	}

	@Override
	public void createWebfolderToken() throws Exception {
		ezCommonDAO.createWebfolderToken();

	}

	@Override
	public void createPortalThemePortlet() throws Exception {
		ezCommonDAO.createPortalThemePortlet();
	}
	
	@Override
	public void insertPortalThemePortletInitdata() throws Exception {
		ezCommonDAO.insertPortalThemePortletInitdata();
	}
	
	@Override
	public void updateTaskUrl() throws Exception {
		ezCommonDAO.updateTaskUrl();
	}

	@Override
	public void createJmochaMailCopyright() throws Exception {
		ezCommonDAO.createJmochaMailCopyright();
	}

	@Override
	public void createJamesMailDeletedId() throws Exception {
		ezCommonDAO.createJamesMailDeletedId();
	}
	
	@Override
	public void updateListOptionData() throws Exception {
		ezCommonDAO.updateListOptionData();
	}

	@Override
	public void createBoardLike() throws Exception{
		ezCommonDAO.createBoardLike();
	}
	
	@Override
	public void addWebfolderTotalLimit() throws Exception {
		ezCommonDAO.addWebfolderTotalLimit();
	}

	@Override
	public void addMemoExtensionColumns() throws Exception {
		ezCommonDAO.addMemoExtensionColumns();
	}
	
	@Override
	public void createAttitudeAnnual() throws Exception {
		ezCommonDAO.createTblAttitudeAnnual();
		ezCommonDAO.createTblAttitudeAnnualCanappl();
		ezCommonDAO.createTblAttitudeAnnualConf();
		ezCommonDAO.createTblAttitudeAnnualHistory();
		ezCommonDAO.createTblAttitudeAprConn();
	}

	@Override
	public void createResourcePortlet() throws Exception {
		ezCommonDAO.createTblResourcePortlet();
	}
	
	@Override
	public void createThemeAndPortletAuth() throws Exception {
		ezCommonDAO.createTblThemeAuth();
		ezCommonDAO.createTblPortletAuth();
	}

	@Override
	public void addMenuAndPortletCode() throws Exception {
		ezCommonDAO.addMenuCode();
		ezCommonDAO.addPortletCode();
	}
	
	@Override
	public List<CountryVO> getCountryInfo(Map<String, Object> map) throws Exception {
		return ezCommonDAO.getCountryInfo(map);
	}
	
	@Override
	public void insertSurveyTenantConfig() throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", 0);
		map.put("propertyName", "useSurvey");
		map.put("propertyValue", "YES");
		map.put("description", "YES: 사용 NO: 사용안함 (default: YES)");
		map.put("configName", "전자설문 리뉴얼 모듈 사용여부");
		map.put("configType", "기타모듈");
		map.put("regdate", "2019-06-25 00:00:00");

		ezCommonDAO.insertSurveyTenantConfig(map);
	}

	@Override
	public void insertPortletInfo() throws Exception {
		List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();
		int[] portletIds = {51, 70, 73};
		
		Map<String, Object> rsMap = new HashMap<String, Object>();
		rsMap.put("portletId", portletIds[0]);
		rsMap.put("menuId", 6);
		rsMap.put("portletUrl", "/ezNewPortal/resourcePortlet.do");
		rsMap.put("portletType", "G");
		rsMap.put("defaultOrder", 21);
		rsMap.put("portletUsed", 1);
		rsMap.put("portletOrder", 21);
		rsMap.put("boardId", null);
		ezCommonDAO.insertPortletInfo(rsMap);
		
		Map<String, Object> wfMap = new HashMap<String, Object>();
		wfMap.put("portletId", portletIds[1]);
		wfMap.put("menuId", 10);
		wfMap.put("portletUrl", "/ezNewPortal/webFolderPortlet.do");
		wfMap.put("portletType", "G");
		wfMap.put("defaultOrder", 22);
		wfMap.put("portletUsed", 1);
		wfMap.put("portletOrder", 22);
		wfMap.put("boardId", null);
		ezCommonDAO.insertPortletInfo(wfMap);
		
		String surveyMenuId = checkSurveyMenu();
		int surveyMenu = 0;
		boolean isSurveyMenuNew = false;
		
		if (surveyMenuId == null) {
			logger.debug("surveyMenu doesn't exist. add survey menu data...");
			insertSurveyMenu();
			surveyMenu = Integer.parseInt(checkSurveyMenu());
			isSurveyMenuNew = true;
		} else {
			surveyMenu = Integer.parseInt(surveyMenuId);
		}
		
		Map<String, Object> svMap = new HashMap<String, Object>();
		svMap.put("portletId", portletIds[2]);
		svMap.put("menuId", surveyMenu);
		svMap.put("portletUrl", "/ezNewPortal/surveyPortlet.do");
		svMap.put("portletType", "G");
		svMap.put("defaultOrder", 20);
		svMap.put("portletUsed", 1);
		svMap.put("portletOrder", 20);
		svMap.put("boardId", null);
		ezCommonDAO.insertPortletInfo(svMap);
		
		for (CompanyInfoVO company : companyList) {
			if (company.getCompanyId() != null) {
				rsMap.put("companyId", company.getCompanyId());
				rsMap.put("tenantId", company.getTenantId());
				ezCommonDAO.insertRsPortletInfo(rsMap); // 자원관리 포틀릿 유무 확인 후 insert
				
				wfMap.put("companyId", company.getCompanyId());
				wfMap.put("tenantId", company.getTenantId());
				ezCommonDAO.insertWfPortletInfo(wfMap); // 웹폴더 포틀릿 유무 확인 후 insert
				
				svMap.put("companyId", company.getCompanyId());
				svMap.put("tenantId", company.getTenantId());
				
				if (isSurveyMenuNew) {
					ezCommonDAO.insertSurveyMenuInfo(svMap);
				}
				
				ezCommonDAO.insertSvPortletInfo(svMap); // 전자설문 포틀릿 유무 확인 후 insert
				
			}
		}
	}

	private void insertSurveyMenu() {
		logger.debug("insertSurveyMenu started");
		ezCommonDAO.insertSurveyMenu();
		logger.debug("insertSurveyMenu ended");
	}

	private String checkSurveyMenu() {
		logger.debug("checkSurveyMenu started");
		String surveyMenuId = ezCommonDAO.checkSurveyMenu();
		logger.debug("[surveyMenuId]" + surveyMenuId);
		return surveyMenuId;
	}

	public void createAccessCountry() throws Exception {
		ezCommonDAO.createTblAccessCountry();
	}
	
	@Override
	public void createTblShareDocDir() throws Exception {
		ezCommonDAO.createTblShareDocDir();
	}
	
	@Override
	public void createPersonalPopupUser() throws Exception {
		ezCommonDAO.createPersonalPopupUser();
	}

	@Override
	public boolean getPermissionGroupAccessYN(String groupId, String companyId, int tenantId, String userId,
			String deptId, boolean applySubDeptYN) throws Exception {
		logger.debug("getPermissionGroupAccessYN started. groupId=" + groupId + ",userId=" + userId + ",deptId=" + deptId
				+ ",applySubDeptYN=" + applySubDeptYN);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupId", groupId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("deptId", deptId);
		map.put("applySubDeptYN", applySubDeptYN);
		
		boolean accessYN = ezCommonDAO.getPermissionGroupAccessYN(map);
		
		logger.debug("getPermissionGroupAccessYN ended. accessYN=" + accessYN);
		
		return accessYN;
	}

	@Override
	public List<LoginVO> getPermissionGroupMembers(String groupId, String companyId, int tenantId, boolean applySubDeptYN) throws Exception {
		logger.debug("getPermissionGroupMembers started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupId", groupId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("applySubDeptYN", applySubDeptYN);
		
		logger.debug("getPermissionGroupMembers ended.");
		return ezCommonDAO.getPermissionGroupMembers(map);
	}	
	
	@Override
	public void createTblNoticeBoard() throws Exception {
		ezCommonDAO.createTblNoticeBoard();
	}

	@Override
	public void alterChamjoView() throws Exception {
		ezCommonDAO.alterChamjoView();
	}
	
	@Override
	public void addAddressFurigana() throws Exception {
		ezCommonDAO.addAddressFurigana();
	}
	
	@Override
	public void createOpenGovTable() throws Exception {
		ezCommonDAO.createOpenGovTable();
	}
	
	@Override
	public int checkDeptId(String userID, String deptID, String tenantId, String jobID) {
		//logger.debug("checkDeptId started"); // 로그정리
		int result = 0;
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("tenantID", tenantId);
		map.put("deptID", deptID);
		map.put("userID", userID);
        map.put("jobID", jobID);
		result= ezCommonDAO.checkDeptId(map);
		//logger.debug("checkDeptId ended"); // 로그정리
		return result;
	}

	@Override
	public void createRsFavoriteTable() {
		ezCommonDAO.createRsFavoriteTable();
	}

	@SuppressWarnings("serial")
	@Override
	public void createUserDistributionTable() {
		ezCommonDAO.createUserDistributionTable();
	}
	
	@SuppressWarnings("serial")
	@Override
	public void insertTblTenantConfig() throws Exception {
		logger.debug("=== insert TBL_TENANT_CONFIG Test ===");
		List<Map<String, Object>> test = new ArrayList<Map<String, Object>>(); // List : 순서보장 Collection

		test.add(new HashMap<String, Object>(){{
			put("confName","checkPasswordNumber");
			put("property_value","YES");
			put("config_name","3자리 이상의 연속숫자, 같은숫자, 생일, 전화번호 방지");
			put("regdate","2023-06-09 00:00:00");
			put("description","패스워드 설정 시 3자리 이상의 연속숫자, 같은숫자, 생일, 전화번호 방지 사용여부 (default:YES)");
			put("config_type","로그인");
		}});
		test.add(new HashMap<String, Object>(){{
			put("confName","dbSessionStoragePeriod");
			put("property_value","1");
			put("config_name","DB세션 보관 기간");
			put("regdate","2023-12-14 00:00:00");
			put("description","DB 세션 사용 시 tbl_session 테이블에 세션 보관 기간 day기준(default:1)");
			put("config_type","로그인");
		}});
		test.add(new HashMap<String, Object>(){{
			put("confName","useMailConfirm");
			put("property_value","NO");
			put("config_name","메일 완료/완료취소");
			put("regdate","2020-01-28 00:00:00");
			put("description","메일 완료/완료취소 기능 사용 여부(default: NO)");
			put("config_type","메일");
		}});
		test.add(new HashMap<String, Object>(){{
			put("confName","UseAutoDeleteOfRetireUser");
			put("property_value","NO");
			put("config_name","퇴직자 자동삭제");
			put("regdate","2020-09-14 00:00:00");
			put("description","n일 이후 퇴직자 자동삭제 사용여부(default: NO)");
			put("config_type","조직도");
		}});
		test.add(new HashMap<String, Object>(){{
			put("confName","autoDeleteOfRetireUserLimit");
			put("property_value","0");
			put("config_name","퇴직자 자동삭제 ");
			put("regdate","2020-09-14 00:00:00");
			put("description","n일 이후 퇴직자 자동삭제 : n일 설정(default: 0, 0=사용안함)");
			put("config_type","조직도");
		}});
		test.add(new HashMap<String, Object>(){{
			put("confName","useExternalMailServerAddress");
			put("property_value","0.0.0.0");
			put("config_name","외부메일 서버 주소 ");
			put("regdate","2020-09-29 00:00:00");
			put("description","외부메일 서버 주소 (default:0.0.0.0)");
			put("config_type","메일");
		}});
		test.add(new HashMap<String, Object>(){{
			put("confName","useExternalMailServerAuth");
			put("property_value","NO");
			put("config_name","외부메일 서버 인증 사용여부");
			put("regdate","2020-09-29 00:00:00");
			put("description","외부메일 서버 인증 사용여부(default: NO)");
			put("config_type","메일");
		}});
		test.add(new HashMap<String, Object>(){{
			put("confName","useExternalMailServerUserId");
			put("property_value","authId");
			put("config_name","외부메일 서버 인증 id (ex: test@test.com)");
			put("regdate","2020-09-29 00:00:00");
			put("description","외부메일 서버 인증 id");
			put("config_type","메일");
		}});
		test.add(new HashMap<String, Object>(){{
			put("confName","useExternalMailServerUserPw");
			put("property_value","authPw");
			put("config_name","외부메일 서버 인증 pass");
			put("regdate","2020-09-29 00:00:00");
			put("description","외부메일 서버 인증 pass (ex: password123)");
			put("config_type","메일");
		}});
		test.add(new HashMap<String, Object>(){{
			put("confName","useExternalMailServerPort");
			put("property_value","25");
			put("config_name","외부메일 서버  smtp 포트 ");
			put("regdate","2021-03-29 00:00:00");
			put("description","외부메일 서버 smtp 포트 (deafult:25)");
			put("config_type","메일");
		}});
		test.add(new HashMap<String, Object>(){{
			put("confName","useDeleteMailBlob");
			put("property_value","YES");
			put("config_name","메일 blob 삭제 스케줄러 사용여부");
			put("regdate","2021-02-19 00:00:00");
			put("description","메일 blob 삭제 스케줄러 사용여부 (default:YES)");
			put("config_type","메일");
		}});
		test.add(new HashMap<String, Object>(){{
			put("confName","useOrgListCheckBox");
			put("property_value","NO");
			put("config_name","조직도 리스트 체크박스 표시");
			put("regdate","2021-11-10 00:00:00");
			put("description","조직도 리스트 체크박스 표시 (메일,주소록) (default:NO)");
			put("config_type","메일");
		}});
		test.add(new HashMap<String, Object>(){{
			put("confName","useAdminIPAccess");
			put("property_value","NO");
			put("config_name","관리자 IP 제한");
			put("regdate","2020-04-27 00:00:00");
			put("description","관리자 페이지 IP 제한(default: NO)");
			put("config_type","시스템");
		}});
		test.add(new HashMap<String, Object>(){{
			put("confName","useAddrDupliCheck");
			put("property_value","YES");
			put("config_name","주소록 가져오기 시 기존주소록 중복체크 사용여부");
			put("regdate","2023-05-16 00:00:00");
			put("description","주소록 가져오기 시 기존주소록 중복체크 사용여부(default: YES)");
			put("config_type","주소록");
		}});
        test.add(new HashMap<String, Object>(){{
            put("confName","FidoStoragePeriod"); // property_name
            put("property_value","30");
            put("config_name","FIDO Session 보관기간");
            put("regdate","2023-11-23 00:00:00");
            put("description","2중인증 FIDO Session 보관기간으로 일-day 단위(default: 30)");
            put("config_type","로그인");
        }});
        test.add(new HashMap<String, Object>(){{
            put("confName","FidoTimeLimit"); // property_name
            put("property_value","1");
            put("config_name","FIDO인증 시간");
            put("regdate","2023-11-23 00:00:00");
            put("description","FIDO인증 시간으로 분-minute 단위(default: 1)");
            put("config_type","일반");
        }});
        test.add(new HashMap<String, Object>(){{
            put("confName","useFidoAccessMenu"); // property_name
            put("property_value","NO");
            put("config_name","FIDO인증 관리 화면");
            put("regdate","2023-11-23 00:00:00");
            put("description","FIDO인증 관리 화면 여부(default: NO)");
            put("config_type","일반");
        }});
		test.add(new HashMap<String, Object>(){{
			put("confName","useJapanese");
			put("property_value","YES");
			put("config_name","일본어 사용여부");
			put("regdate","2023-11-17 10:40:00");
			put("description","일본어 사용여부(YES: 사용, NO: 사용안함, default: YES) 언어코드 ja : Japanese, 국가코드 JP : Japan");
			put("config_type","환경설정");
		}});
		test.add(new HashMap<String, Object>(){{ //2023-11-17 조소정 - 중국어 사용 여부 테넌트 컨피그 추가
			put("confName","useChinese");
			put("property_value","NO");
			put("config_name","중국어 사용여부");
			put("regdate","2023-11-17 10:40:00");
			put("description","중국어 사용여부(YES: 사용, NO: 사용안함, default: NO) 언어코드 zh : Chinese (中文 Zhōngwén), 국가코드 CN : Mainland China 중국 대륙(간체자)");
			put("config_type","환경설정");
		}});
		test.add(new HashMap<String, Object>(){{ // 2024-01-17 김은실 - 중국어4, 베트남어5, 인도네시아어6 취합하면서 베트남어, 인도네시아어 추가
			put("confName","useVietnamese");
			put("property_value","NO");
			put("config_name","베트남어 사용여부");
			put("regdate","2024-01-17 00:00:00");
			put("description","베트남어 사용여부(YES: 사용, NO: 사용안함, default: NO) 언어코드 vi : Vietnamese, 국가코드 VN : Viet Nam");
			put("config_type","환경설정");
		}});
		test.add(new HashMap<String, Object>(){{ // 2024-01-17 commit 0877e66
			put("confName","useIndonesian");
			put("property_value","NO");
			put("config_name","인도네시아어 사용여부");
			put("regdate","2024-01-17 00:00:00");
			put("description","인도네시아어 사용여부(YES: 사용, NO: 사용안함, default: NO) 언어코드 id : Indonesian, 국가코드 ID : Indonesia");
			put("config_type","환경설정");
		}});
		test.add(new HashMap<String, Object>(){{
			put("confName","useEachMailDefault"); // property_name
			put("property_value","NO");
			put("config_name","메일 개별발신 디폴트 사용여부");
			put("regdate","2024-01-30 00:00:00");
			put("description","시스템 > 패러메터 > 개별발신 디폴트 사용  메일쓰기 시 개별발신 사용을 디폴트로 설정한다. 사용 : YES , 사용안함 : NO (default : NO)");
			put("config_type","메일");
			put("property","USEEACHMAILDEFAULT"); // property_name (UPPER 조건 처리를 위하여 대문자로 전달)
		}});
		test.add(new HashMap<String, Object>(){{
			put("confName","useApprMail");
			put("property_value","NO");
			put("config_name","승인메일 기능 사용여부");
			put("regdate","2024-02-26 00:00:00");
			put("description","승인메일 기능 사용여부(default: NO)");
			put("config_type","메일");
		}});
		test.add(new HashMap<String, Object>(){{
			put("confName","apprMailKeepLogPeriod");
			put("property_value","3");
			put("config_name","승인메일 자동삭제,로그보존 기간");
			put("regdate","2024-03-14 00:00:00");
			put("description","승인메일 자동삭제,로그보존 기간(default: 3, 단위: 개월)");
			put("config_type","메일");
        }});
        test.add(new HashMap<String, Object>(){{
			put("confName","useFormContOnReuseForWHWP");
			put("property_value","YES");
			put("config_name","웹한글 문서 재사용 시 양식선택창 표출여부");
			put("regdate","2024-06-26 00:00:00");
			put("description","웹한글 문서 재사용 시 양식선택창을 표출한다. YES: 양식선택창 표출, NO: 양식선택창 표출하지 않고 바로 기안창 호출 (default : YES)");
			put("config_type","전자결재G");
		}});
        
        test.add(new HashMap<String, Object>(){{
			put("confName","webHWPVersion");
			put("property_value","2");
			put("config_name","웹한글기안기 버전");
			put("regdate","2025-04-22 00:00:00");
			put("description","웹한글기안기 버전에 따라 다른 동작을 하는 부분을 옵션화한다. 1: 웹한글기안기 v1.0 사용, 2: 웹한글기안기 v2.0 사용 (default : 1)");
			put("config_type","전자결재G");
		}});

        test.add(new HashMap<String, Object>(){{
            put("confName","useStatMenu");
            put("property_value","YES");
            put("config_name","메뉴 통계 사용 여부");
            put("regdate","2025-03-21 00:00:00");
            put("description","메뉴 관련 통계 집계, 및 사용 여부 (default:YES)");
            put("config_type","포탈");
        }});

		List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();
		
		for (Map<String, Object> map : test) {
        	try {
				map.put("property", ((String) map.get("confName")).toUpperCase()); // property_name (UPPER 조건 처리를 위하여 대문자로 전달) 2020-01-28 commit 3b1f3d26 > 2020-06-08 commit 82ca318c4

				for (TenantVO tenantVo : tenantIdList) {
					map.put("tenantID", tenantVo.getTenantId()); // HashMap의 key는 유일한 값 → overwrite

					ezCommonDAO.insertTblTenantConfig(map);
				}
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
        }

		logger.debug("=== insert TBL_TENANT_CONFIG Test Complete ===");
	}

	/**
	 * - AFTER : $AFTER$ 또는 $AFTER_*$ 택하여 사용 가능. : $AFTER$ 값 없어도 에러나지 않는다.
	 * - CONSTRAINT : PRIMARY KEY를 생성하는 데에 꼭 필요치는 않다.
	 * - 필요시 _TIBERO 추가 요망.
	 */
	@SuppressWarnings("serial")
	@Override
	public void alterTableAddColumns() throws Exception {
		logger.debug("=== ALTER TABLE Test ===");
		List<Map<String, Object>> test = new ArrayList<Map<String, Object>>(); // List : 순서보장 Collection

		// JAMES_MAIL_SEARCH
		test.add(new HashMap<String, Object>(){{ // 2019-04-01 commit 263e2a21ff15
			put("TABLE","JAMES_MAIL_SEARCH");
			put("COLUMN", "MESSAGE_ID");
			put("TYPE_MYSQL", "VARCHAR(200)"); put("TYPE_ORACLE", "VARCHAR(200)");
			put("AFTER_MYSQL", "NULL DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2022-06-24 commit df88270
			put("TABLE","JAMES_MAIL_SEARCH");
			put("COLUMN", "SECURE_FLAG");
			put("TYPE_MYSQL", "int(1)"); put("TYPE_ORACLE", "NUMBER");
			put("AFTER", "DEFAULT 0");
		}});

		// JMOCHA_DISTRIBUTION
		test.add(new HashMap<String, Object>(){{ // 2018-09-30 commit edbc67f
			put("TABLE","JMOCHA_DISTRIBUTION");
			put("COLUMN", "MAIL");
			put("TYPE_MYSQL", "VARCHAR(100)"); put("TYPE_ORACLE", "VARCHAR2(100 CHAR)");
			put("AFTER", "DEFAULT NULL");
		}});

		// JMOCHA_MAIL_GENERAL
		test.add(new HashMap<String, Object>(){{ // 2018-12-27 commit 4000af253
			put("TABLE","JMOCHA_MAIL_GENERAL");
			put("COLUMN", "PREVIEW_MAIL_IMAGE");
			put("TYPE_MYSQL", "VARCHAR(10)"); put("TYPE_ORACLE", "VARCHAR(10)");
			put("AFTER", "DEFAULT 'Y'");
		}});

		// JMOCHA_MAIL_RESERVE
		test.add(new HashMap<String, Object>(){{ // 2025-01-14 김은실: 예약메일 공유사서함 추가.
			put("TABLE","JMOCHA_MAIL_RESERVE");
			put("COLUMN", "SENDER");
			put("TYPE_MYSQL", "VARCHAR(80)"); put("TYPE_ORACLE", "NVARCHAR2(80)");
		}});

		// TBL_ADDJOBMASTER
		test.add(new HashMap<String, Object>(){{ // 2018-08-30 commit 2910f2a7
			put("TABLE","TBL_ADDJOBMASTER");
			put("COLUMN", "ORDERBY");
			put("TYPE_MYSQL", "VARCHAR(200)"); put("TYPE_ORACLE", "NVARCHAR2(200)");
			put("AFTER", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2018-11-19 commit 1d1b9d5191
			put("TABLE","TBL_ADDJOBMASTER");
			put("COLUMN", "JOBID");
			put("TYPE_MYSQL", "VARCHAR(200)"); put("TYPE_ORACLE", "VARCHAR2(100)");
			put("AFTER", "DEFAULT NULL");
			put("PRIMARY", "(CN, DEPTID, TENANT_ID, JOBID)");
		}});
		test.add(new HashMap<String, Object>(){{ // 2019-05-20 commit de6232dbb9
			put("TABLE","TBL_ADDJOBMASTER");
			put("COLUMN", "PROXY");
			put("TYPE_MYSQL", "VARCHAR(200)"); put("TYPE_ORACLE", "NVARCHAR2(200)");
			put("AFTER", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2019-10-17 commit c3ceafe04a1
			put("TABLE","TBL_ADDJOBMASTER");
			put("COLUMN", "MANUAL_FLAG");
			put("TYPE_MYSQL", "VARCHAR(4)"); put("TYPE_ORACLE", "NVARCHAR2(2)");
			put("AFTER", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2023-08-16 전인하 - tbl_addJobMaster 테이블에 Roll_INFO 컬럼 추가 commit 568fd2afd54ea2
			put("TABLE","TBL_ADDJOBMASTER");
			put("COLUMN", "ROLL_INFO");
			put("TYPE_MYSQL", "VARCHAR(200)"); put("TYPE_ORACLE", "VARCHAR(200)");
			put("AFTER", "DEFAULT 'c=0;k=0;g=0;a=0;i=0;n=0;l=0;w=0;m=0;'");
		}});
		test.add(new HashMap<String, Object>(){{ // 2023-12-28 김혜지 - 관리자 > 조직도 > 겸직등록 > 직책 컬럼 추가 commit 409af6f
			put("TABLE","TBL_ADDJOBMASTER");
			put("COLUMN", "ROLE");
			put("TYPE_MYSQL", "VARCHAR(200)"); put("TYPE_ORACLE", "VARCHAR(200)");
		}});
		test.add(new HashMap<String, Object>(){{ // 2023-12-28 commit 409af6f
			put("TABLE","TBL_ADDJOBMASTER");
			put("COLUMN", "ROLE2");
			put("TYPE_MYSQL", "VARCHAR(200)"); put("TYPE_ORACLE", "VARCHAR(200)");
		}});
		test.add(new HashMap<String, Object>(){{ // 2023-12-28 commit 409af6f
			put("TABLE","TBL_ADDJOBMASTER");
			put("COLUMN", "ROLEID");
			put("TYPE_MYSQL", "varchar(100)"); put("TYPE_ORACLE", "VARCHAR(100)");
			put("AFTER", "DEFAULT '0'");
			put("CONSTRAINT", "TBL_ADD_JOBMASTER_PK");
			put("PRIMARY", "(CN, DEPTID, TENANT_ID, JOBID, ROLEID)");
		}});

		// TBL_ADMINRECEIPTGROUP_SUB
		test.add(new HashMap<String, Object>(){{ // 2021-06-29 수신처그룹 멤버 테이블에 외부/내부 수신여부 컬럼 추가 commit 01a2e83925
			put("TABLE","TBL_ADMINRECEIPTGROUP_SUB");
			put("COLUMN", "EXTRECEPTYN");
			put("TYPE_MYSQL", "VARCHAR(5)"); put("TYPE_ORACLE", "VARCHAR2(5)");
			put("AFTER", "DEFAULT 'N'");
		}});

		// TBL_APRATTACHINFO
		test.add(new HashMap<String, Object>(){{ // 2020-03-23 홍승비 - 전자결재 일반 첨부파일 순서조정용 칼럼 추가 (진행문서) commit 2ca1dae5eb5
			put("TABLE","TBL_APRATTACHINFO");
			put("COLUMN", "VIEWORDER");
			put("TYPE_MYSQL", "bigint(10)"); put("TYPE_ORACLE", "NUMBER(10,0)");
			put("AFTER_MYSQL", "DEFAULT NULL");
		}});

		// TBL_APRDOCGROUPINFO
		test.add(new HashMap<String, Object>(){{ // 2022-02-09 홍승비 - 일괄기안 테이블에 임시저장/결재올림 구분용 타입 칼럼 추가 commit af9f524a60a
			put("TABLE","TBL_APRDOCGROUPINFO");
			put("COLUMN", "TYPE");
			put("TYPE_MYSQL", "VARCHAR(10)"); put("TYPE_ORACLE", "CHAR(10 CHAR)");
			put("AFTER", "NOT NULL");
		}});

		// TBL_APRRECEIPTPROCESSINFO
		test.add(new HashMap<String, Object>(){{ // 2021-06-29 - 수신결재정보 테이블 오리지날 docid 컬럼 추가 commit e595b3639f
			put("TABLE","TBL_APRRECEIPTPROCESSINFO");
			put("COLUMN", "ROOTDOCID");
			put("TYPE_MYSQL", "VARCHAR(80)"); put("TYPE_ORACLE", "VARCHAR2(80)");
			put("UPDATE", "PARENTSDOCID");
		}});

		// TBL_ATTITUDE
		test.add(new HashMap<String, Object>(){{ // 2020-08-07 김정언 - 근태관리 WORK_STATUS (일근무/반근무) 컬럼 추가 commit b031a7c1dd
			put("TABLE","TBL_ATTITUDE");
			put("COLUMN", "WORK_STATUS");
			put("TYPE_MYSQL", "CHAR(1)"); put("TYPE_ORACLE", "CHAR(1)");
			put("AFTER_MYSQL", "NULL COMMENT 'D : 일근무	H : 반근무'"); put("AFTER_ORACLE", "DEFAULT NULL");
		}});

		// TBL_BOARD_BOARDINFO
		test.add(new HashMap<String, Object>(){{ // 2019-04-08 commit 72e07dbff
			put("TABLE","TBL_BOARD_BOARDINFO");
			put("COLUMN", "LIKEFLAG");
			put("TYPE_MYSQL", "VARCHAR(2)"); put("TYPE_ORACLE", "NCHAR(1)");
			put("AFTER", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2021-06-21 홍승비 - 게시판 메일알림 옵션 추가 commit 104a85bf5
			put("TABLE","TBL_BOARD_BOARDINFO");
			put("COLUMN", "MAILFG_POST");
			put("TYPE_MYSQL", "VARCHAR(2)"); put("TYPE_ORACLE", "CHAR(1 CHAR)");
			put("AFTER", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2021-06-21 commit 104a85bf5
			put("TABLE","TBL_BOARD_BOARDINFO");
			put("COLUMN", "MAILFG_MOD");
			put("TYPE_MYSQL", "VARCHAR(2)"); put("TYPE_ORACLE", "CHAR(1 CHAR)");
			put("AFTER", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2021-06-21 commit 104a85bf5
			put("TABLE","TBL_BOARD_BOARDINFO");
			put("COLUMN", "MAILFG_COMMENT");
			put("TYPE_MYSQL", "VARCHAR(2)"); put("TYPE_ORACLE", "CHAR(1 CHAR)");
			put("AFTER", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2023-07-27 이가은&임정은 - 게시판 > 댓글 좋아요/싫어요 사용여부 옵션 칼럼 추가 commit f112f28760b
			put("TABLE","TBL_BOARD_BOARDINFO");
			put("COLUMN", "REACTFLAG");
			put("TYPE_MYSQL", "VARCHAR(1)"); put("TYPE_ORACLE", "NCHAR(1)");
			put("AFTER", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2023-11-27 조소정 - 게시판그룹이름, 게시판이름 일본어, 중국어 버전 컬럼 추가 commit 0877e66f29445
			put("TABLE","TBL_BOARD_BOARDINFO");
			put("COLUMN", "BOARDNAME3");
			put("TYPE_MYSQL", "VARCHAR(510)"); put("TYPE_ORACLE", "NVARCHAR2(255)");
			put("AFTER_MYSQL", "CHARACTER SET utf8mb4 DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2023-11-27 commit 0877e66f29445
			put("TABLE","TBL_BOARD_BOARDINFO");
			put("COLUMN", "BOARDNAME4");
			put("TYPE_MYSQL", "VARCHAR(510)"); put("TYPE_ORACLE", "NVARCHAR2(255)");
			put("AFTER_MYSQL", "CHARACTER SET utf8mb4 DEFAULT NULL");
		}});

		// TBL_BOARD_BOARDMANAGE
		test.add(new HashMap<String, Object>(){{ // 2019-09-19 홍승비 - 게시판 권한그룹 적용을 위한 TYPE 칼럼 추가 commit e5c8200214
			put("TABLE","TBL_BOARD_BOARDMANAGE");
			put("COLUMN", "TYPE");
			put("TYPE_MYSQL", "VARCHAR(10)"); put("TYPE_ORACLE", "VARCHAR2(10)");
			put("AFTER_MYSQL", "DEFAULT NULL");
		}});

		// TBL_BOARD_MYBOARDS
		test.add(new HashMap<String, Object>(){{ // 2023-11-28 조소정 - 마이게시판 게시판이름 일본어, 중국어 버전 컬럼 추가 commit 0877e66f29445
			put("TABLE","TBL_BOARD_MYBOARDS");
			put("COLUMN", "BOARDNAME3");
			put("TYPE_MYSQL", "varchar(100)"); put("TYPE_ORACLE", "NVARCHAR2(50)");
			put("AFTER_MYSQL", "CHARACTER SET utf8mb4 DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2023-11-28 commit 0877e66f29445
			put("TABLE","TBL_BOARD_MYBOARDS");
			put("COLUMN", "BOARDNAME4");
			put("TYPE_MYSQL", "varchar(100)"); put("TYPE_ORACLE", "NVARCHAR2(50)");
			put("AFTER_MYSQL", "CHARACTER SET utf8mb4 DEFAULT NULL");
		}});

		// TBL_BOARD_MYTREE
		test.add(new HashMap<String, Object>(){{ // 2023-11-27 조소정 - 마이게시판 트리 이름 일본어, 중국어 버전 컬럼 추가 commit 0877e66f29445
			put("TABLE","TBL_BOARD_MYTREE");
			put("COLUMN", "TREENAME3");
			put("TYPE_MYSQL", "VARCHAR(510)"); put("TYPE_ORACLE", "NVARCHAR2(255)");
			put("AFTER_MYSQL", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2023-11-27 commit 0877e66f29445
			put("TABLE","TBL_BOARD_MYTREE");
			put("COLUMN", "TREENAME4");
			put("TYPE_MYSQL", "VARCHAR(510)"); put("TYPE_ORACLE", "NVARCHAR2(255)");
			put("AFTER_MYSQL", "DEFAULT NULL");
		}});

		// TBL_BOARD_TREECACHE
		test.add(new HashMap<String, Object>(){{ // 2023-11-27 조소정 - 게시판 트리 일본어, 중국어 버전 컬럼 추가 commit 0877e66f29445
			put("TABLE","TBL_BOARD_TREECACHE");
			put("COLUMN", "RESULT3");
			put("TYPE_MYSQL", "longtext"); put("TYPE_ORACLE", "NCLOB");
			put("AFTER_MYSQL", "CHARACTER SET utf8mb4 DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2023-11-27 commit 0877e66f29445
			put("TABLE","TBL_BOARD_TREECACHE");
			put("COLUMN", "RESULT4");
			put("TYPE_MYSQL", "longtext"); put("TYPE_ORACLE", "NCLOB");
			put("AFTER_MYSQL", "CHARACTER SET utf8mb4 DEFAULT NULL");
		}});

		// TBL_C_BOARD
		test.add(new HashMap<String, Object>(){{ // 2021-06-28 홍승비 - 커뮤니티 공지사항 부모게시물 정보 칼럼 추가 commit aa89549da6
			put("TABLE","TBL_C_BOARD");
			put("COLUMN", "UPPERNO");
			put("TYPE_MYSQL", "BIGINT(10)"); put("TYPE_ORACLE", "NUMBER(19, 0)");
			put("AFTER_MYSQL", "DEFAULT NULL");
		}});

		// TBL_C_COMCLOSE
		test.add(new HashMap<String, Object>(){{ // 2019-04-09 commit 5e6dfca2ad
			put("TABLE","TBL_C_COMCLOSE");
			put("COLUMN", "COMPANYID");
			put("TYPE_MYSQL", "VARCHAR(100)"); put("TYPE_ORACLE", "NVARCHAR2(20)");
			put("AFTER", "DEFAULT NULL");
		}});

		// TBL_COMM_BOARDINFO
		test.add(new HashMap<String, Object>(){{ // 2021-11-12 홍승비 - 커뮤니티 게시판 메일알림 옵션 추가 (게시/수정/댓글알림) commit 6b94a124ed53
			put("TABLE","TBL_COMM_BOARDINFO");
			put("COLUMN", "MAILFG_POST");
			put("TYPE_MYSQL", "VARCHAR(2)"); put("TYPE_ORACLE", "CHAR(1 CHAR)");
			put("AFTER", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2021-11-12 commit 6b94a124ed53
			put("TABLE","TBL_COMM_BOARDINFO");
			put("COLUMN", "MAILFG_MOD");
			put("TYPE_MYSQL", "VARCHAR(2)"); put("TYPE_ORACLE", "CHAR(1 CHAR)");
			put("AFTER", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2021-11-12 commit 6b94a124ed53
			put("TABLE","TBL_COMM_BOARDINFO");
			put("COLUMN", "MAILFG_COMMENT");
			put("TYPE_MYSQL", "VARCHAR(2)"); put("TYPE_ORACLE", "CHAR(1 CHAR)");
			put("AFTER", "DEFAULT NULL");
		}});

		// TBL_DEPTMASTER
		test.add(new HashMap<String, Object>(){{ // 2018-10-10 commit 2bac88bfb
			put("TABLE","TBL_DEPTMASTER");
			put("COLUMN", "MANUAL_FLAG");
			put("TYPE_MYSQL", "VARCHAR(10)"); put("TYPE_ORACLE", "NVARCHAR2(2)");
			put("AFTER", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2022-06-16 commit 6a38325
			put("TABLE","TBL_DEPTMASTER");
			put("COLUMN", "CREATEDT");
			put("TYPE_MYSQL", "DATETIME"); put("TYPE_ORACLE", "DATE");
			put("AFTER", "DEFAULT NULL");
		}});

		// TBL_DOCDELIVERY
		test.add(new HashMap<String, Object>(){{ // 2021-06-29 - 배부테이블에 대내/대외 여부 컬럼 추가 commit e595b3639f
			put("TABLE","TBL_DOCDELIVERY");
			put("COLUMN", "EXTRECEPTYN");
			put("TYPE_MYSQL", "VARCHAR(5)"); put("TYPE_ORACLE", "VARCHAR2(5)");
			put("AFTER", "DEFAULT 'N'");
			put("UPDATE", "'N'");
		}});

		// TBL_ENDATTACHINFO
		test.add(new HashMap<String, Object>(){{ // 2020-03-25 홍승비 - 전자결재 일반 첨부파일 순서조정용 칼럼 추가 (완료문서) commit 2ca1dae5eb
			put("TABLE","TBL_ENDATTACHINFO");
			put("COLUMN", "VIEWORDER");
			put("TYPE_MYSQL", "bigint(10)"); put("TYPE_ORACLE", "NUMBER(10,0)");
			put("AFTER_MYSQL", "DEFAULT NULL");
		}});

		// TBL_EXPAPRDOCINFO
		test.add(new HashMap<String, Object>(){{ // 2019-05-22 commit bc55ecf875
			put("TABLE","TBL_EXPAPRDOCINFO");
			put("COLUMN", "FORMVERSION");
			put("TYPE_MYSQL", "INT"); put("TYPE_ORACLE", "NUMBER(10,0)");
			put("AFTER_MYSQL", "NULL DEFAULT 0"); put("AFTER_ORACLE", "DEFAULT 0");
		}});

		// TBL_EXPENDAPRDOCINFO
		test.add(new HashMap<String, Object>(){{ // 2019-05-22 commit bc55ecf875
			put("TABLE","TBL_EXPENDAPRDOCINFO");
			put("COLUMN", "FORMVERSION");
			put("TYPE_MYSQL", "INT"); put("TYPE_ORACLE", "NUMBER(10,0)");
			put("AFTER_MYSQL", "NULL DEFAULT 0"); put("AFTER_ORACLE", "DEFAULT 0");
		}});

		// TBL_FORMINFO
		test.add(new HashMap<String, Object>(){{ // 2018-09-28 commit b58029b
			put("TABLE","TBL_FORMINFO");
			put("COLUMN", "REFORMFLAG");
			put("TYPE_MYSQL", "VARCHAR(4)"); put("TYPE_ORACLE", "CHAR(1)");
			put("AFTER", "DEFAULT 'N'");
		}});
		test.add(new HashMap<String, Object>(){{ // 2019-05-22 commit bc55ecf875
			put("TABLE","TBL_FORMINFO");
			put("COLUMN", "FORMVERSION");
			put("TYPE_MYSQL", "INT"); put("TYPE_ORACLE", "NUMBER(10,0)");
			put("AFTER_MYSQL", "NULL DEFAULT 0"); put("AFTER_ORACLE", "DEFAULT 0");
		}});
		test.add(new HashMap<String, Object>(){{ // 2019-07-18 강민수 - 전자결재양식 테이블 원문공개 플래그 추가 commit 9a124afc0a3
			put("TABLE","TBL_FORMINFO");
			put("COLUMN", "OPENGOVFLAG");
			put("TYPE_MYSQL", "VARCHAR(4)"); put("TYPE_ORACLE", "VARCHAR(4)");
			put("AFTER", "DEFAULT 'N'");
		}});
		test.add(new HashMap<String, Object>(){{ // 2020-05-14 홍승비 - 전자결재 양식 옵션 관련 칼럼 추가 commit 79087165e
			put("TABLE","TBL_FORMINFO");
			put("COLUMN", "APROPTION");
			put("TYPE_MYSQL", "varchar(300)"); put("TYPE_ORACLE", "NVARCHAR2(300 CHAR)");
			put("AFTER_MYSQL", "DEFAULT NULL COMMENT '양식 세부설정'");
		}});
		test.add(new HashMap<String, Object>(){{ // 2020-08-13 홍승비 - 양식옵션 > 기결재통과 플래그 추가 commit 9ed74a50
			put("TABLE","TBL_FORMINFO");
			put("COLUMN", "PASSAPRLINEFLAG");
			put("TYPE_MYSQL", "VARCHAR(4)"); put("TYPE_ORACLE", "VARCHAR2(4)");
			put("AFTER_MYSQL", "DEFAULT 'N' COMMENT '기결재통과플래그'"); put("AFTER_ORACLE", "DEFAULT 'N'");
		}});
		test.add(new HashMap<String, Object>(){{ //2020-11-23 김보혜 전자결재G 시행문일때 내부발송/유통(외부)발송 양식 구분 컬럼 추가 commit 11d30125e
			put("TABLE","TBL_FORMINFO");
			put("COLUMN", "SIHANGTYPE");
			put("TYPE_MYSQL", "VARCHAR(10)"); put("TYPE_ORACLE", "VARCHAR2(10)");
			put("AFTER_MYSQL", "DEFAULT '' COMMENT '전자결재G 시행문 타입'"); put("AFTER_ORACLE", "DEFAULT ''");
		}});

		// TBL_HISTORYDOCINFO
		test.add(new HashMap<String, Object>(){{ // 2020-02-24 홍승비 - 전자결재문서 편집전후여부 플래그 컬럼 추가
			put("TABLE","TBL_HISTORYDOCINFO");
			put("COLUMN", "ISBEFOREDOC");
			put("TYPE_MYSQL", "VARCHAR(4)"); put("TYPE_ORACLE", "CHAR(1 CHAR)");
			put("AFTER_MYSQL", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2020-02-27 홍승비 - 전자결재문서 편집전후 문서경로 URL컬럼 추가 commit f4ab6efb6
			put("TABLE","TBL_HISTORYDOCINFO");
			put("COLUMN", "BEFOREDOCURL");
			put("TYPE_MYSQL", "varchar(1020)"); put("TYPE_ORACLE", "VARCHAR2(255 CHAR)");
			put("AFTER_MYSQL", "DEFAULT NULL");
		}});

		// TBL_HOLIDAYLIST
		test.add(new HashMap<String, Object>(){{ // 2019-01-11 commit 7e7fcbb2a
			put("TABLE","TBL_HOLIDAYLIST");
			put("COLUMN", "HOLIDAYFLAG");
			put("TYPE_MYSQL", "VARCHAR(45)"); put("TYPE_ORACLE", "VARCHAR2(45)");
			put("AFTER", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2019-01-11 commit 7e7fcbb2a
			put("TABLE","TBL_HOLIDAYLIST");
			put("COLUMN", "HOLIDAYREPEAT");
			put("TYPE_MYSQL", "VARCHAR(45)"); put("TYPE_ORACLE", "VARCHAR2(45)");
			put("AFTER", "DEFAULT NULL");
		}});

		// TBL_JOURNAL_FORM
		test.add(new HashMap<String, Object>(){{ // 2019-01-30 commit 9214f26bd5e
			put("TABLE","TBL_JOURNAL_FORM");
			put("COLUMN", "form_del_flag");
			put("TYPE_MYSQL", "VARCHAR(10)"); put("TYPE_ORACLE", "VARCHAR2(10)");
			put("AFTER", "DEFAULT NULL");
		}});

		// TBL_LASTAPRLINE
		test.add(new HashMap<String, Object>(){{ // 2020-05-22 commit 247f59788
			put("TABLE","TBL_LASTAPRLINE");
			put("COLUMN", "DOCSTATE");
			put("TYPE_MYSQL", "VARCHAR(12)"); put("TYPE_ORACLE", "NVARCHAR2(12)");
			put("AFTER", "DEFAULT '011' NOT NULL");
			put("CONSTRAINT", "TBL_LASTAPRLINE_PK2");
			put("PRIMARY", "(TENANT_ID, COMPANYID, USERID, FORMID, APRMEMBERSN, DOCSTATE)");
		}});

		// TBL_LASTDEPTLINE
		test.add(new HashMap<String, Object>(){{ // 2020-05-22 commit 247f59788
			put("TABLE","TBL_LASTDEPTLINE");
			put("COLUMN", "DOCSTATE");
			put("TYPE_MYSQL", "VARCHAR(12)"); put("TYPE_ORACLE", "NVARCHAR2(12)");
			put("AFTER", "DEFAULT '011' NOT NULL");
			put("CONSTRAINT", "TBL_LASTDEPTLINE_PK2");
			put("PRIMARY", "(TENANT_ID, COMPANYID, USERID, FORMID, RECEIPTPOINTID, DOCSTATE)");
		}});

		// TBL_PORTAL_MENU_AUTH
		test.add(new HashMap<String, Object>(){{ // 2019-07-29 commit 5ab43088d5
			put("TABLE","TBL_PORTAL_MENU_AUTH");
			put("COLUMN", "sn");
			put("TYPE_MYSQL", "INT"); put("TYPE_ORACLE", "INT");
			put("AFTER", "DEFAULT 0");
		}});

		// TBL_PORTAL_PORTLET_AUTH
		test.add(new HashMap<String, Object>(){{ // 2019-08-06 commit c8cd47401a0
			put("TABLE","TBL_PORTAL_PORTLET_AUTH");
			put("COLUMN", "sn");
			put("TYPE_MYSQL", "INT"); put("TYPE_ORACLE", "INT");
			put("AFTER", "DEFAULT 0");
		}});

		// TBL_PORTAL_PORTLET_USER
		test.add(new HashMap<String, Object>(){{ // 2019-02-21 commit 2789f992f0640
			put("TABLE","TBL_PORTAL_PORTLET_USER");
			put("COLUMN", "PORTLET_USED");
			put("TYPE_MYSQL", "int(11)"); put("TYPE_ORACLE", "NUMBER(11, 0)");
			put("AFTER", "DEFAULT 1");
		}});
		test.add(new HashMap<String, Object>(){{ // 2019-02-21 commit 2789f992f06
			put("TABLE","TBL_PORTAL_PORTLET_USER");
			put("COLUMN", "THEME_ID");
			put("TYPE_MYSQL", "int(11)"); put("TYPE_ORACLE", "NUMBER(11, 0)");
			put("AFTER", "DEFAULT 1");
			put("CONSTRAINT", "TBL_PORTAL_PORTLET_USER_PK");
			put("PRIMARY", "(user_id, tenant_id, company_id, portlet_id, theme_id)");
		}});

		// TBL_PORTAL_THEME
		test.add(new HashMap<String, Object>(){{ // 2019-06-25 유은정 - 테마명 다국어 처리 관련 컬럼 및 이닛데이터 추가 commit 0837ecefdd0
			put("TABLE","TBL_PORTAL_THEME");
			put("COLUMN", "THEME_CONTENT2");
			put("TYPE_MYSQL", "VARCHAR(400)"); put("TYPE_ORACLE", "VARCHAR(400)");
			put("AFTER", "DEFAULT 'theme content'");
			put("UPDATE", "CASE WHEN theme_id = 1 THEN 'A theme with a fixed area on the left or right.'"
								+ " WHEN theme_id = 2 THEN 'A theme with a fixed area on the top.'"
								+ " WHEN theme_id = 3 THEN 'A theme that consists of only portlets without fixed areas.'"
							+ " END");
		}});
		test.add(new HashMap<String, Object>(){{ // 2019-06-25 commit bbf2dd5f93
			put("TABLE","TBL_PORTAL_THEME");
			put("COLUMN", "THEME_NAME2");
			put("TYPE_MYSQL", "VARCHAR(100)"); put("TYPE_ORACLE", "VARCHAR(100)");
			put("AFTER", "DEFAULT 'theme2'");
			put("UPDATE", "CASE WHEN theme_id = 1 THEN 'Theme1'"
								+ " WHEN theme_id = 2 THEN 'Theme2'"
								+ " WHEN theme_id = 3 THEN 'Theme3'"
							+ " END");
		}});
		test.add(new HashMap<String, Object>(){{ // 2019-06-25 commit 0837ecefdd0
			put("TABLE","TBL_PORTAL_THEME");
			put("COLUMN", "THEME_CONTENT3");
			put("TYPE_MYSQL", "VARCHAR(400)"); put("TYPE_ORACLE", "VARCHAR(400)");
			put("AFTER", "DEFAULT 'theme content'");
			put("UPDATE", "CASE WHEN theme_id = 1 THEN '固定領域を画面の右または左に配置できるテーマです。'"
								+ " WHEN theme_id = 2 THEN '固定領域が画面の上部に表示されるテーマです。'"
								+ " WHEN theme_id = 3 THEN '固定領域がなく、すべてのポートレットを自由に配置できるテーマです。'"
							+ " END");
		}});
		test.add(new HashMap<String, Object>(){{ // 2019-06-25 commit bbf2dd5f93
			put("TABLE","TBL_PORTAL_THEME");
			put("COLUMN", "THEME_NAME3");
			put("TYPE_MYSQL", "VARCHAR(100)"); put("TYPE_ORACLE", "VARCHAR(100)");
			put("AFTER", "DEFAULT 'theme3'");
			put("UPDATE", "CASE WHEN theme_id = 1 THEN 'Theme1'"
								+ " WHEN theme_id = 2 THEN 'Theme2'"
								+ " WHEN theme_id = 3 THEN 'Theme3'"
							+ " END");
		}});
		test.add(new HashMap<String, Object>(){{ // 2023-11-16 조소정 - 환경설정 > 테마설정에서 테마설명 중국어 버전 추가
			put("TABLE","TBL_PORTAL_THEME");
			put("COLUMN", "THEME_CONTENT4");
			put("TYPE_MYSQL", "VARCHAR(400)"); put("TYPE_ORACLE", "VARCHAR2(400 BYTE)");
			put("AFTER_MYSQL", "DEFAULT NULL"); put("AFTER_ORACLE", "DEFAULT 'theme content'"); // ?? 왜 DEFAULT가 다르지? (: create_tables_mysql/oracle.sql 참고함.)
			put("UPDATE", "CASE WHEN theme_id = 1 THEN '左侧或右侧有固定区域的主题。'"
								+ " WHEN theme_id = 2 THEN '顶部有固定区域的主题。'"
								+ " WHEN theme_id = 3 THEN '仅由没有固定区域的 portlet 组成的主题。'"
							+ " END");
		}});
		test.add(new HashMap<String, Object>(){{ // 2024-01-17 김은실 - 중국어4, 베트남어5, 인도네시아어6 취합하면서 베트남어, 인도네시아어 추가 commit 0877e66
			put("TABLE","TBL_PORTAL_THEME");
			put("COLUMN", "THEME_CONTENT5");
			put("TYPE_MYSQL", "VARCHAR(400)"); put("TYPE_ORACLE", "VARCHAR2(400 BYTE)");
			put("AFTER_MYSQL", "DEFAULT NULL"); put("AFTER_ORACLE", "DEFAULT 'theme content'");
			put("UPDATE", "CASE WHEN theme_id = 1 THEN 'A theme with a fixed area on the left or right.'"
								+ " WHEN theme_id = 2 THEN 'A theme with a fixed area on the top.'"
								+ " WHEN theme_id = 3 THEN 'A theme that consists of only portlets without fixed areas.'"
							+ " END");
		}});
		test.add(new HashMap<String, Object>(){{ // 2024-01-17 commit 0877e66
			put("TABLE","TBL_PORTAL_THEME");
			put("COLUMN", "THEME_CONTENT6");
			put("TYPE_MYSQL", "VARCHAR(400)"); put("TYPE_ORACLE", "VARCHAR2(400 BYTE)");
			put("AFTER_MYSQL", "DEFAULT NULL"); put("AFTER_ORACLE", "DEFAULT 'theme content'");
			put("UPDATE", "CASE WHEN theme_id = 1 THEN 'A theme with a fixed area on the left or right.' "
								+ " WHEN theme_id = 2 THEN 'A theme with a fixed area on the top.'"
								+ " WHEN theme_id = 3 THEN 'A theme that consists of only portlets without fixed areas.'"
							+ " END");
		}});

		// TBL_PORTAL_THEME_AUTH
		test.add(new HashMap<String, Object>(){{ // 2019-08-06 commit c8cd47401a
			put("TABLE","TBL_PORTAL_THEME_AUTH");
			put("COLUMN", "sn");
			put("TYPE_MYSQL", "INT"); put("TYPE_ORACLE", "INT");
			put("AFTER", "DEFAULT 0");
		}});

		// TBL_PORTAL_THEME_PORTLET
		test.add(new HashMap<String, Object>(){{ // 2018-12-19 commit 263fd8002
			put("TABLE","TBL_PORTAL_THEME_PORTLET");
			put("COLUMN", "IS_FIXED");
			put("TYPE_MYSQL", "INT"); put("TYPE_ORACLE", "NUMBER(5,0)");
			put("AFTER", "DEFAULT 0");
		}});

		// TBL_PORTAL_THEME_USER
		test.add(new HashMap<String, Object>(){{ // 2019-02-21 commit 2c35782f0b5
			put("TABLE","TBL_PORTAL_THEME_USER");
			put("COLUMN", "is_default");
			put("TYPE_MYSQL", "int(11)"); put("TYPE_ORACLE", "NUMBER(11, 0)");
			put("AFTER", "DEFAULT 0");
		}});

		// TBL_PS_APPROVNOTIMAILCONF
		test.add(new HashMap<String, Object>(){{ // 2019-11-15 기결재통과 알림 컬럼 추가 commit 14ee3416b
			put("TABLE","TBL_PS_APPROVNOTIMAILCONF");
			put("COLUMN", "LINEPASS");
			put("TYPE_MYSQL", "VARCHAR(4)"); put("TYPE_ORACLE", "NVARCHAR2(2)");
			put("AFTER", "DEFAULT '0'");
		}});

		// TBL_PS_QUICKLINK
		test.add(new HashMap<String, Object>(){{ // 2019-04-09 commit 5e6dfca2ad
			put("TABLE","TBL_PS_QUICKLINK");
			put("COLUMN", "LINKORDER");
			put("TYPE_MYSQL", "INT(11)"); put("TYPE_ORACLE", "NUMBER(11,0)");
			put("AFTER", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2024-01-17 commit 0877e66
			put("TABLE","TBL_PS_QUICKLINK");
			put("COLUMN", "QUICKLINKNAME5");
			put("TYPE_MYSQL", "varchar(100)"); put("TYPE_ORACLE", "NVARCHAR2(50)");
			put("AFTER_MYSQL", "CHARACTER SET utf8mb4 DEFAULT ' ' NOT NULL"); put("AFTER_ORACLE", "DEFAULT ' ' NOT NULL ENABLE");
		}});
		test.add(new HashMap<String, Object>(){{ // 2024-01-17 commit 0877e66
			put("TABLE","TBL_PS_QUICKLINK");
			put("COLUMN", "QUICKLINKNAME6");
			put("TYPE_MYSQL", "varchar(100)"); put("TYPE_ORACLE", "NVARCHAR2(50)");
			put("AFTER_MYSQL", "CHARACTER SET utf8mb4 DEFAULT ' ' NOT NULL"); put("AFTER_ORACLE", "DEFAULT ' ' NOT NULL ENABLE");
		}});

		// TBL_RS_RESACL
		test.add(new HashMap<String, Object>(){{ // 2023-08-21 이주원 - 자원권한 테이블에 유저명 다국어 지원을 위해 MEMBER_NAM2 컬럼 추가 commit 5cffafe13
			put("TABLE","TBL_RS_RESACL");
			put("COLUMN", "MEMBER_NAM2");
			put("TYPE_MYSQL", "VARCHAR(200)"); put("TYPE_ORACLE", "NVARCHAR2(100)");
		}});

		// TBL_SCHEDULEGROUP
		test.add(new HashMap<String, Object>(){{ // 2023-08-31 조소정 - 일정관리 > 일정그룹 테이블에 컬럼 추가 (양도일자/그룹 색상) commit b14557301de
			put("TABLE","TBL_SCHEDULEGROUP");
			put("COLUMN", "TRANSFERDATE");
			put("TYPE_MYSQL", "DATETIME"); put("TYPE_ORACLE", "DATE");
			put("AFTER", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // commit b14557301de
			put("TABLE","TBL_SCHEDULEGROUP");
			put("COLUMN", "GROUPCOLOR");
			put("TYPE_MYSQL", "VARCHAR(10)"); put("TYPE_ORACLE", "VARCHAR2(10)");
			put("AFTER", "DEFAULT NULL");
		}});

		// TBL_SCHEDULEGROUPMEMBER
		test.add(new HashMap<String, Object>(){{ // 일정관리 > 그룹일정 작성 권한 기능 추가
			put("TABLE","TBL_SCHEDULEGROUPMEMBER");
			put("COLUMN", "WRITEPERMISSION");
			put("TYPE_MYSQL", "VARCHAR(10)"); put("TYPE_ORACLE", "VARCHAR2(10)");
			put("AFTER", "DEFAULT 'Y' NOT NULL");
		}});

		// TBL_SURVEY
		test.add(new HashMap<String, Object>(){{ // 2019-10-07 이석화 - 설문 알림 컬럼 추가 commit abc70b2bb1
			put("TABLE","TBL_SURVEY");
			put("COLUMN", "MAIL_FLAG");
			put("TYPE_MYSQL", "TINYINT(4)"); put("TYPE_ORACLE", "NUMBER(4, 0)");
			put("AFTER", "DEFAULT 0");
		}});
		test.add(new HashMap<String, Object>(){{ // 2019-10-07 이석화 - 설문 알림 컬럼 추가 commit abc70b2bb1
			put("TABLE","TBL_SURVEY");
			put("COLUMN", "POPUP_FLAG");
			put("TYPE_MYSQL", "TINYINT(4)"); put("TYPE_ORACLE", "NUMBER(4, 0)");
			put("AFTER", "DEFAULT 0");
		}});
		test.add(new HashMap<String, Object>(){{ // 2019-10-10 홍대표 - 설문 알림 메일 발송 상태 컬럼 추가 commit cf5107b6f36e9
			put("TABLE","TBL_SURVEY");
			put("COLUMN", "MAIL_SENT_FLAG");
			put("TYPE_MYSQL", "TINYINT(4)"); put("TYPE_ORACLE", "NUMBER(12)");
			put("AFTER", "DEFAULT 0");
		}});

		// TBL_SURVEY_PARTICIPANT
		test.add(new HashMap<String, Object>(){{ // 2021-11-17 홍승비 - 전자설문 대상자 하위부서 허용여부 플래그 추가 (Y/N) commit 8f82077
			put("TABLE","TBL_SURVEY_PARTICIPANT");
			put("COLUMN", "SUBDEPTYN");
			put("TYPE_MYSQL", "VARCHAR(2)"); put("TYPE_ORACLE", "CHAR(1 CHAR)");
			put("AFTER", "DEFAULT 'N'");
		}});

		// TBL_SUSINSCHEDULE
		test.add(new HashMap<String, Object>(){{ // 2022-02-11 홍승비 - 수신스케줄러 알림메일 발송 시 다국어(시간대) 지원을 위해 OFFSET 칼럼 추가 commit 0d16e5fdc
			put("TABLE","TBL_SUSINSCHEDULE");
			put("COLUMN_MYSQL", "`OFFSET`"); put("COLUMN_ORACLE", "OFFSET");
			put("TYPE_MYSQL", "VARCHAR(40)"); put("TYPE_ORACLE", "CHAR(10 CHAR)");
			put("AFTER", "DEFAULT ''");
		}});

		// TBL_TMPATTACHINFO
		test.add(new HashMap<String, Object>(){{ // 2020-03-26 홍승비 - 전자결재 일반 첨부파일 순서조정용 칼럼 추가 (임시문서) commit 2ca1dae5eb
			put("TABLE","TBL_TMPATTACHINFO");
			put("COLUMN", "VIEWORDER");
			put("TYPE_MYSQL", "bigint(10)"); put("TYPE_ORACLE", "NUMBER(10,0)");
			put("AFTER_MYSQL", "DEFAULT NULL");
		}});

		// TBL_TMPEXPAPRDOCINFO
		test.add(new HashMap<String, Object>(){{ // 2019-05-22 commit bc55ecf875
			put("TABLE","TBL_TMPEXPAPRDOCINFO");
			put("COLUMN", "FORMVERSION");
			put("TYPE_MYSQL", "INT"); put("TYPE_ORACLE", "NUMBER(10,0)");
			put("AFTER_MYSQL", "NULL DEFAULT 0"); put("AFTER_ORACLE", "DEFAULT 0");
		}});

		// TBL_USERMASTER
		test.add(new HashMap<String, Object>(){{ // 2018-10-10 commit 2bac88bfb
			put("TABLE","TBL_USERMASTER");
			put("COLUMN", "MANUAL_FLAG");
			put("TYPE_MYSQL", "VARCHAR(4)"); put("TYPE_ORACLE", "NVARCHAR2(2)");
			put("AFTER", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2018-11-15 commit df48c1e5f1b
			put("TABLE","TBL_USERMASTER");
			put("COLUMN", "PASSWORD_UPDATEDT");
			put("TYPE_MYSQL", "DATETIME"); put("TYPE_ORACLE", "DATE");
			put("AFTER", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2019-01-04 commit 6359b57da
			put("TABLE","TBL_USERMASTER");
			put("COLUMN", "MAILBOXQUOTA");
			put("TYPE_MYSQL", "VARCHAR(50)"); put("TYPE_ORACLE", "VARCHAR(50)");
			put("AFTER", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2019-01-04 commit 6359b57da
			put("TABLE","TBL_USERMASTER");
			put("COLUMN", "MAILBOXUSAGE");
			put("TYPE_MYSQL", "VARCHAR(50)"); put("TYPE_ORACLE", "VARCHAR(50)");
			put("AFTER", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2021-09-10 김은실 - 메신저/인사 연동 효율성을 위한: 프로필사진 업데이트시각(PHOTO_UPDATEDT) 컬럼 추가 commit bb9e6cab
			put("TABLE","TBL_USERMASTER");
			put("COLUMN", "PHOTO_UPDATEDT");
			put("TYPE_MYSQL", "DATETIME"); put("TYPE_ORACLE", "DATE");
			put("AFTER", "DEFAULT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2022-06-16 commit 6a38325
			put("TABLE","TBL_USERMASTER");
			put("COLUMN", "CREATEDT");
			put("TYPE_MYSQL", "DATETIME"); put("TYPE_ORACLE", "DATE");
			put("AFTER", "DEFAULT NULL");
		}});

		// TBL_WEBFOLDER_APPLY_HISTORY
		test.add(new HashMap<String, Object>(){{ // 2021-04-01 commit d2e6dc910d
			put("TABLE","TBL_WEBFOLDER_APPLY_HISTORY");
			put("COLUMN", "APPROVAL_STATUS");
			put("TYPE_MYSQL", "VARCHAR(10)"); put("TYPE_ORACLE", "NVARCHAR2(10)");
		}});
		test.add(new HashMap<String, Object>(){{ // 2021-04-01 commit d2e6dc910d
			put("TABLE","TBL_WEBFOLDER_APPLY_HISTORY");
			put("COLUMN", "APPROVAL_STATUS_UPDATEDT");
			put("TYPE_MYSQL", "DATETIME"); put("TYPE_ORACLE", "DATE");
		}});

		// TBL_WEBFOLDER_FILE
		test.add(new HashMap<String, Object>(){{ // 2020-10-19 웹폴더 버전관리 commit d2e6dc910d
			put("TABLE","TBL_WEBFOLDER_FILE");
			put("COLUMN", "VERSION");
			put("TYPE_MYSQL", "INT(7)"); put("TYPE_ORACLE", "NUMBER(7, 0)");
			put("AFTER", "DEFAULT 1 NOT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2020-11-25 웹폴더 답글 파일 컬럼 추가 commit d2e6dc910d
			put("TABLE","TBL_WEBFOLDER_FILE");
			put("COLUMN", "DEPTH");
			put("TYPE_MYSQL", "INT(7)"); put("TYPE_ORACLE", "NUMBER(7, 0)");
			put("AFTER", "DEFAULT 1 NOT NULL");
		}});
		test.add(new HashMap<String, Object>(){{ // 2020-11-25 commit d2e6dc910d
			put("TABLE","TBL_WEBFOLDER_FILE");
			put("COLUMN", "ROOT_ID");
			put("TYPE_MYSQL", "VARCHAR(100)"); put("TYPE_ORACLE", "VARCHAR2(100)");
			put("UPDATE", "FILE_ID");
		}});
		test.add(new HashMap<String, Object>(){{ // 2020-11-25 commit d2e6dc910d
			put("TABLE","TBL_WEBFOLDER_FILE");
			put("COLUMN", "PARENT_ID");
			put("TYPE_MYSQL", "VARCHAR(100)"); put("TYPE_ORACLE", "VARCHAR2(100)");
			put("UPDATE", "FILE_ID");
		}});
		test.add(new HashMap<String, Object>(){{ // 2020-11-25 commit d2e6dc910d
			put("TABLE","TBL_WEBFOLDER_FILE");
			put("COLUMN", "HIERARCHICAL_PATH");
			put("TYPE_MYSQL", "VARCHAR(300)"); put("TYPE_ORACLE", "VARCHAR2(300)");
			put("UPDATE", "FILE_ID");
		}});

		// TBL_WEBFOLDER_FOLDERUSER
		test.add(new HashMap<String, Object>(){{ // 2020-10-19 김은실 - 웹폴더 > 하위부서 허용 여부 추가 commit 658176ee7
			put("TABLE","TBL_WEBFOLDER_FOLDERUSER");
			put("COLUMN", "SUBDEPT_PERMITTED");
			put("TYPE_MYSQL", "INT"); put("TYPE_ORACLE", "NUMBER(11, 0)");
			put("AFTER", "DEFAULT '0'");
		}});
		test.add(new HashMap<String, Object>(){{ // 2020-12-08 김은실 - [카이스트] 웹폴더 > 폴더 담당자 추가 commit 658176ee7
			put("TABLE","TBL_WEBFOLDER_FOLDERUSER");
			put("COLUMN", "FOLDER_MANAGER"); // 폴더담당자 (1레벨만 해당)
			put("TYPE_MYSQL", "INT(11)"); put("TYPE_ORACLE", "NUMBER(11, 0)");
			put("AFTER", "DEFAULT '0'");
		}});
        test.add(new HashMap<String, Object>(){{ // 2024-08-01 전인하 - 게시판 > 키워드 기능
            put("TABLE","TBL_BOARD_BOARDINFO");
            put("COLUMN", "USEKEYWORD"); // 게시판 키워드 기능 사용여부(Y/N)
            put("TYPE_MYSQL", "VARCHAR(11)"); put("TYPE_ORACLE", "NVARCHAR2(2)");
        }});
        test.add(new HashMap<String, Object>(){{ // 2024-08-01 전인하 - 게시판 > 키워드 기능
            put("TABLE","TBL_BOARD_ITEM");
            put("COLUMN", "UPDATERID"); // 게시판 키워드 기능 사용여부(Y/N)
            put("TYPE_MYSQL", "VARCHAR(80)"); put("TYPE_ORACLE", "NVARCHAR2(80)");
        }});
        test.add(new HashMap<String, Object>(){{ //2025-01-24 이가은 전자결재 > 연동테이블 컬럼 추가
            put("TABLE","TBL_CONNDATA");
            put("COLUMN", "USERID");    // 기안자 ID
            put("TYPE_MYSQL", "VARCHAR(400)"); put("TYPE_ORACLE", "VARCHAR2(100)");
        }});
        test.add(new HashMap<String, Object>(){{ //2025-01-24 이가은 전자결재 > 연동테이블 컬럼 추가
            put("TABLE","TBL_CONNDATA");
            put("COLUMN", "DEPTID");    // 기안자 부서ID
            put("TYPE_MYSQL", "VARCHAR(400)"); put("TYPE_ORACLE", "VARCHAR2(100)");
        }});
        test.add(new HashMap<String, Object>(){{ //2025-01-24 이가은 전자결재 > 연동테이블 컬럼 추가
            put("TABLE","TBL_CONNDATA");
            put("COLUMN", "TITLE");     // 문서제목
            put("TYPE_MYSQL", "VARCHAR(1020)"); put("TYPE_ORACLE", "NVARCHAR2(510)");
        }});
        // 2025-02-19 전인하 - 요약전 mht 파일 저장 기능 추가 _ 진행중 문서
		test.add(new HashMap<String, Object>(){{ 
			put("TABLE","TBL_EXPAPRDOCINFO");
			put("COLUMN", "SUMMARYPATH");
			put("TYPE_MYSQL", "VARCHAR(140)"); put("TYPE_ORACLE", "NVARCHAR2(140)");
			put("AFTER_MYSQL", "DEFAULT NULL COMMENT '요약전 mht파일이 저장되는 경로정보'"); 
            put("AFTER_ORACLE", "DEFAULT NULL");
		}});
        // 2025-02-19 전인하 - 요약전 mht 파일 저장 기능 추가 _ 완료 문서
		test.add(new HashMap<String, Object>(){{ 
			put("TABLE","TBL_EXPENDAPRDOCINFO");
			put("COLUMN", "SUMMARYPATH");
			put("TYPE_MYSQL", "VARCHAR(140)"); put("TYPE_ORACLE", "NVARCHAR2(140)");
			put("AFTER_MYSQL", "DEFAULT NULL COMMENT '요약전 mht파일이 저장되는 경로정보'"); 
            put("AFTER_ORACLE", "DEFAULT NULL");
		}});
        // 2025-02-19 전인하 - 요약전 mht 파일 저장 기능 추가 _ 진행중 문서
		test.add(new HashMap<String, Object>(){{ 
			put("TABLE","TBL_TMPEXPAPRDOCINFO");
			put("COLUMN", "SUMMARYPATH");
			put("TYPE_MYSQL", "VARCHAR(140)"); put("TYPE_ORACLE", "NVARCHAR2(140)");
			put("AFTER_MYSQL", "DEFAULT NULL COMMENT '요약전 mht파일이 저장되는 경로정보'"); 
            put("AFTER_ORACLE", "DEFAULT NULL");
		}});
		for (Map<String, Object> map : test) {
			ezCommonDAO.alterTableAddColumns(map);
        }

		logger.debug("=== ALTER TABLE Test Complete ===");
	}

	@Override
	public void addThemeAndPorteltAuthInit() throws Exception {
		List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();
		Map<String, Object> map = new HashMap<String, Object>();
		
		for (CompanyInfoVO company : companyList) {
			if (company.getCompanyId() != null) {
				map.put("companyId", company.getCompanyId());
				map.put("tenantId", company.getTenantId());
				ezCommonDAO.insertThemeAuthInit(map);
				ezCommonDAO.insertPortletAuthInit(map);
			}
		}
	}

	@Override
	public void createJmochaBigAttachDownloadLimit() throws Exception {
		ezCommonDAO.createJmochaBigAttachDownloadLimit();
	}
	
	@Override
	public void insertMailBigSizeAttachLimit() throws Exception {
		logger.debug("insertMailBigSizeAttachLimit started");
		ezCommonDAO.insertMailBigSizeAttachLimit();
		logger.debug("insertMailBigSizeAttachLimit ended");
	}
	
	@SuppressWarnings("serial")
	@Override
	public void setCompanyConfigs()  throws Exception {
		logger.debug("setCompanyConfigs started.");
		List<Map<String, String>> list = new ArrayList<Map<String,String>>();
		list.add(new HashMap<String, String>(){{ put("name","ExpirePassPeriod"); put("value","0"); }});
		list.add(new HashMap<String, String>(){{ put("name","MaxAllowedCountOfLoginFail"); put("value","0"); }});
		// 2024.10.14 한슬기 : 암호정책 디폴트값 설정 (암호패턴 사용, 영문 대/소문자 패턴구분안함, 3개패턴 사용, 8글자 이상)
		list.add(new HashMap<String, String>(){{ put("name","UsePasswordPatternPolicy"); put("value","YES"); }});
		// 2021-11-09 이사라 : 가장 최근 사용한 암호 재사용
		list.add(new HashMap<String, String>(){{ put("name","useChkPrevPwd"); put("value","NO"); }});
		     
		List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();
		
		for (TenantVO tenantVo : tenantIdList) {
			int tenantId = tenantVo.getTenantId();
			logger.debug("tenantId=" + tenantId);

			List<OrganDeptVO> companyList = ezOrganAdminService.getCompanyList("1", tenantId);
			logger.debug("companyList size=" + companyList.size());
			for (OrganDeptVO companyVo : companyList) {
				String companyId = companyVo.getCn();
				logger.debug("companyId=" + companyId);
				for (Map<String, String> config : list) {
					try {
						String propertyName = config.get("name");
						String propertyValue = config.get("value");
						
						insertCompanyConfig(tenantId, companyId, propertyName, propertyValue);
					} catch(Exception e) {
						logger.debug("Config already.");
					}
				}
			}
		}
		
		logger.debug("setCompanyConfigs ended.");
	}
	
	/**
	 * 테이블 생성 공통함수
	 * - tableArr에 추가할 테이블 명 추가 (5개마다 줄바꿈)
	 */
	@Override
	public void createTables() throws Exception {
		// 생성할 테이블 명
		String[] tableArr = new String[] 
				{"jmocha_appr_allowed_domain", "jmocha_appr_user", "jmocha_appr_history", "jmocha_appr_comp_history", "jmocha_address_last_sent"};
		
		for (String t : tableArr) {
			try {
				ezCommonDAO.createTable(t);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		}
	}
	
	@Override
	public void createPwPolicyTable()  throws Exception {
		logger.debug("createPwPolicyTable started.");
		ezCommonDAO.createPwPolicyTable();
		logger.debug("createPwPolicyTable ended.");
	}

	@Override
	public void createPwPolicyPatternTable()  throws Exception {
		logger.debug("createPwPolicyPatternTable started.");
		ezCommonDAO.createPwPolicyPatternTable();
		logger.debug("createPwPolicyPatternTable ended.");
	}
	
	@Override
	public void insertUseExternalMailServerConfig() throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", 0);
		map.put("propertyName", "useExternalMailServer");
		map.put("propertyValue", "NO");
		map.put("description", "메일 모듈 사용 여부. YES: 외부메일 사용 NO: 내부메일 사용(default: NO)");
		map.put("configName", "메일 모듈 사용 여부");
		map.put("configType", "메일");
		map.put("regdate", "2020-04-16 00:00:00");

		ezCommonDAO.insertUseExternalMailServerConfig(map);
	}
	
	@Override
	public void createAdminAccessIpTable() throws Exception {
		ezCommonDAO.createAdminAccessIpTable();
	}

	@Override
	public void insertReBebuOpinionCode() throws Exception {
		List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();
		Map<String, Object> map = new HashMap<String, Object>();
		
		for (CompanyInfoVO company : companyList) {
			if (company.getCompanyId() != null) {
				map.put("companyId", company.getCompanyId());
				map.put("tenantId", company.getTenantId());
				map.put("code1", "A17");
				map.put("code2", "008");
				map.put("name", "재배부요청");
				map.put("isUse", "1");
				map.put("descript", "재배부요청");
				map.put("name2", "재배부요청");
				map.put("name3", "재배부요청");
				map.put("name4", "재배부요청");
				
				ezCommonDAO.insertReBebuOpinionCode(map);
			}
		}
	}
	
	@Override
	public void insertAnnualScheduleTenantConfig() {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", 0);
		map.put("propertyName", "useAnnualScheduleYN");
		map.put("propertyValue", "0");
		map.put("description", "0:근태현황 일정관리 미연동, 1:근태현황 부서일정 연동, 2:근태현황 회사일정 연동");
		map.put("configName", "근태현황 일정관리 연동");
		map.put("configType", "근태관리");
		map.put("regdate", "2020-02-24 00:00:00");

		ezCommonDAO.insertAnnualScheduleTenantConfig(map);
	}

	@Override
	public void insertHalfOffAttitudeType() {
		List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();		
		
		for (CompanyInfoVO company : companyList) {
			if (company.getCompanyId() != null) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("typeId", "A21");
				map.put("companyId", company.getCompanyId());
				map.put("tenantId", company.getTenantId());
				map.put("typeName", "반반차");
				map.put("typeName2", "half off");
				map.put("isUse", "1");
				map.put("imgPath", "refresh");
				map.put("parentId", "A05");
				map.put("formId", 4);
				map.put("isAdd", "0");
				map.put("isDel", "0");
				
				ezCommonDAO.insertHalfOffAttitudeType(map);	
			}
		}
	}

	@Override
	public void insertHolidayCheckTenantConfig() {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", 0);
		map.put("propertyName", "useHolidayCheckYN");
		map.put("propertyValue", "0");
		map.put("description", "0: 휴일 출/퇴근 체크 미사용, 1: 휴일 출/퇴근 체크 사용");
		map.put("configName", "휴일 출/퇴근 체크 사용여부");
		map.put("configType", "근태관리");
		map.put("regdate", "2020-05-21 00:00:00");

		ezCommonDAO.insertHolidayCheckTenantConfig(map);
	}

	@Override
	public void createAprAttachLimit() throws Exception {
		ezCommonDAO.createAprAttachLimit();
	}
	
    @Override
	public void insertAlternateHolidayAttitudeType() {
		List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();		

		for (CompanyInfoVO company : companyList) {
			if (company.getCompanyId() != null) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("typeId", "A24");
				map.put("companyId", company.getCompanyId());
				map.put("tenantId", company.getTenantId());
				map.put("typeName", "대체휴무");
				map.put("typeName2", "alternate holiday");
				map.put("isUse", "1");
				map.put("imgPath", "refresh");
				map.put("parentId", "A05");
				map.put("formId", 9);
				map.put("isAdd", "0");
				map.put("isDel", "0");

				ezCommonDAO.insertAlternateHolidayAttitudeType(map);	
			}
		}
	}

	@Override
	public void insertBeforeOutComeAttitudeType() {
		List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();		

		for (CompanyInfoVO company : companyList) {
			if (company.getCompanyId() != null) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("typeId", "A25");
				map.put("companyId", company.getCompanyId());
				map.put("tenantId", company.getTenantId());
				map.put("typeName", "퇴근");
				map.put("typeName2", "outCom");
				map.put("isUse", "1");
				map.put("imgPath", "inOut");
				map.put("formId", 3);
				map.put("isAdd", "0");
				map.put("isDel", "0");

				ezCommonDAO.insertBeforeOutComeAttitudeType(map);	
			}
		}
	}	
	
	@Override
	public void insertMobileAttitudeColumn() throws Exception {
		logger.debug("insertMobileAttitudeColumn started");
		
		// 모바일 출퇴근 기능 관련 컬럼 추가(tbl_attitude -> attend_type, latitude, longitude)
		ezCommonDAO.insertMobileAttitudeColumn();
		
		List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();
		
		for (TenantVO tenantVo : tenantIdList) {
			// 모바일 근태관리 테넌트 컨피그 추가
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("tenantId", tenantVo.getTenantId());
			map.put("regdate", "2020-07-01 00:00:00");
			map.put("configType", "기타모듈");

			map.put("propertyName", "USE_MATTITUDE");
			map.put("propertyValue", "NO");
			map.put("description", "YES: 사용 NO: 사용안함 (default: NO)");
			map.put("configName", "모바일 근태관리 모듈 사용여부");

			try {
				ezCommonDAO.insertMobileAttitudeConfig(map);
			} catch (Exception e) {
				logger.debug("e.message=" + e.getMessage());
			}
			
			// 근태관리 GPS 테넌트 컨피그 추가
			map.put("propertyName", "attitudeMapApiKey");
			map.put("propertyValue", "");
			map.put("description", "근태관리 지도 api key(미사용시 빈값)");
			map.put("configName", "근태관리 지도 api key");
			
			try {
				ezCommonDAO.insertAttitudeGPSConfig(map);
			} catch (Exception e) {
				logger.debug("e.message=" + e.getMessage());
			}
		}
		
		logger.debug("insertMobileAttitudeColumn ended");
	}

	@Override
	public void createMenuTenantConfig() throws Exception {
		logger.debug("createMenuTenantConfig started");
		
		List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();
		
		for (TenantVO tenantVo : tenantIdList) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("tenantId", tenantVo.getTenantId());
			map.put("regdate", "2020-08-01 00:00:00");
			map.put("propertyValue", "YES");
			map.put("description", "YES: 사용 NO: 사용안함");
			
			map.put("propertyName", "useSchedule");
			map.put("configName", "일정 모듈 사용 여부");
			map.put("configType", "일정관리");
			
			try {
				ezCommonDAO.createMenuTenantConfig(map);
			} catch (Exception e) {
				logger.debug("e.message=" + e.getMessage());
			}
			
			map.put("propertyName", "useBoard");
			map.put("configName", "게시판 모듈 사용 여부");
			map.put("configType", "게시판");
			
			try {
				ezCommonDAO.createMenuTenantConfig(map);
			} catch (Exception e) {
				logger.debug("e.message=" + e.getMessage());
			}
			
			map.put("propertyName", "useResource");
			map.put("configName", "자원관리 모듈 사용 여부");
			map.put("configType", "자원관리");
			
			try {
				ezCommonDAO.createMenuTenantConfig(map);
			} catch (Exception e) {
				logger.debug("e.message=" + e.getMessage());
			}
			
			map.put("propertyName", "useToDo");
			map.put("configName", "업무관리 모듈 사용 여부");
			map.put("configType", "업무관리");
			
			try {
				ezCommonDAO.createMenuTenantConfig(map);
			} catch (Exception e) {
				logger.debug("e.message=" + e.getMessage());
			}
		}
		
		logger.debug("createMenuTenantConfig ended");
	}
	
    @Override
    public void insertAutoSendOfferFlag() throws Exception {
        ezCommonDAO.insertAutoSendOfferFlag();
    }

	@Override
	public void insertTabBoardPortlet() throws Exception {
        String tapBoardCode = "tabBoard";
        if ( ezCommonDAO.checkPortletCodeString(tapBoardCode) > 0) {
			return;
		}
		
		logger.debug("insertTabBoardPortlet started");
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("portletCode", tapBoardCode);

		List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();
		map.put("portletId", ezCommonDAO.getNewPortletId());
		map.put("portletName1", "탭게시판");
		map.put("portletName2", "tab board");
		map.put("portletName3", "タブボード");
		map.put("menuId", 4);
		map.put("portletUrl", "/ezNewPortal/tabBoardPortlet.do");
		map.put("portletType", "G");
		map.put("defaultOrder", 23);
		map.put("portletUsed", 1);	
		map.put("portletOrder", 23);
		map.put("boardId", null);
		ezCommonDAO.insertPortletWithCode(map);
		
		for (CompanyInfoVO company : companyList) {
			if (company.getCompanyId() != null) {
				map.put("companyId", company.getCompanyId());
				map.put("tenantId", company.getTenantId());
				ezCommonDAO.insertTabBoardPortletInfo(map); // 회사별 있는지 확인후 insert
			}
		}
		
		logger.debug("insertTabBoardPortlet ended");
	}

	@Override
	public void createTblTabBoard() throws Exception {
		ezCommonDAO.createTblTabBoard();
	}

	@Override
	public void addScehdulegroup() throws Exception {
		ezCommonDAO.addScehdulegroup();
	}
	
	@Override
	public void insertApprBigAttachInfo() throws Exception {
		List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();
		
		for (TenantVO tenantVo : tenantIdList) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_TENANTID", tenantVo.getTenantId());
			
			ezCommonDAO.insertApprBigAttachConfig(map); // 전자결재 대용량첨부 테넌트 컨피그
		}
		
		ezCommonDAO.addApprBigAttachColumn(); // 전자결재 대용량첨부 관련 컬럼
		ezCommonDAO.createApprBigAttachTable(); // 전자결재 대용량첨부 관련 테이블
	}
	
	@Override
	public void addScheduleMailNotiConfig() throws Exception {
		ezCommonDAO.addScheduleMailNotiConfig();
	}
	
	@Override
	public void insertApprContainterConfig() throws Exception {
		List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();
		
		for (TenantVO tenantVo : tenantIdList) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("tenantID", tenantVo.getTenantId());
			
			ezCommonDAO.insertApprContainterConfig(map);
		}
	}

	@Override
	public void createWebfolderFileUserTable() {
		ezCommonDAO.createWebfolderFileUserTable();
	}
	
	@Override
    public void createTblYearlyDocCount() throws Exception {
	    ezCommonDAO.createTblYearlyDocCount();
    }

    @Override
    public void insertChartPortletInfo() throws Exception {
        if (ezCommonDAO.checkChartPortletInfo() > 0){
            return;
        }

        logger.debug("insertChartPortletInfo started");

        List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();
        Map<String, Object> map = new HashMap<String, Object>();
        int portletId = ezCommonDAO.getNewPortletId();
        map.put("portletId", portletId);
        map.put("portletName1", "전자문서 차트");
        map.put("portletName2", "chart");
        map.put("portletName3", "図表");
        map.put("portletName4", "图表");
        map.put("portletName5", "chart");
        map.put("portletName6", "chart");
        map.put("menuId", 3);
        map.put("portletUrl", "/ezNewPortal/chartPortlet.do");
        map.put("portletType", "G");
        map.put("defaultOrder", 24);
        map.put("portletUsed", 1);
        map.put("portletOrder", 24);
        map.put("boardId", null);
        map.put("portletCode", "chart");
        ezCommonDAO.insertPortletWithCode(map);

        for (CompanyInfoVO company : companyList) {
            if (company.getCompanyId() != null) {
                map.put("companyId", company.getCompanyId());
                map.put("tenantId", company.getTenantId());
                ezCommonDAO.insertPortletInfoData(map); // 회사별 있는지 확인후 insert
            }
        }

        logger.debug("insertChartPortletInfo poertletId=" + portletId + " ended");
    }

	@Override
	public void addTblUserMultiLoginMobileFlagColumn() throws Exception {
		ezCommonDAO.addTblUserMultiLoginMobileFlagColumn();
	}

	@Override
	public void createTblFidoSession() throws Exception {
		ezCommonDAO.createTblFidoSession();
	}

	@Override
	public void createMailTemplateSequence() throws Exception {
		ezCommonDAO.createMailTemplateSequence();
	}
	
	@Override
	public void createJmochaMailboxProgress() throws Exception {
		ezCommonDAO.createMailboxProgressTable();
	}
	
	// webfolder
	@Override
	public List<String> getPermissionGroupIdListOfUser(String userId, String deptId, String companyId, int tenantId) throws Exception {
		logger.debug("getPermissionGroupIdListOfUser started. userId=" + userId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userId", userId);
		map.put("deptId", deptId);		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		logger.debug("getPermissionGroupIdListOfUser ended.");
		
		return ezCommonDAO.getPermissionGroupIdListOfUser(map);				
	}
	
	@Override
    public void createTblWebfolderApplyHistroy() throws Exception {
    	ezCommonDAO.createTblWebfolderApplyHistroy();
    }
	
	/* 2020-10-19 웹폴더 KLIB 암호화 테이블 */
	@Override
	public void checkWebfolderEncryptTable() throws Exception {
		ezCommonDAO.checkWebfolderEncryptTable();
	}
	
	/* 2020-10-19 웹폴더 버전관리 */
	@Override
	public void checkWebfolderVersionTable() throws Exception {
		ezCommonDAO.checkWebfolderVersionTable();
	}
	
	@Override
	public void addWebfolderLogHistory() throws Exception {
		ezCommonDAO.addWebfolderLogHistory();
	}
	
	@Override
	public void createWebfolderNoInherit() {
		ezCommonDAO.createWebfolderNoInherit();
	}
	
	@Override
	public void createSerialnumgenGrant() throws Exception {
		ezCommonDAO.createSerialnumgenGrant();
	}
	
	@Override
	public void insertApprSatViewerConfig() throws Exception {
		List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();
		
		for (TenantVO tenantVo : tenantIdList) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("tenantID", tenantVo.getTenantId());
			
			ezCommonDAO.insertApprSatViewerConfig(map);
		}
	}
	
	@Override
	public JSONObject attachWebFolderFile(JSONArray fileListJson, LoginVO loginVO, String param, HttpServletRequest request) {
		
		JSONObject resultJson = new JSONObject();
		String downloadDIR = "";

		// 2023-05-25 이사라 : 시큐어코딩 문자열 비교 오류 수정
		if (StringUtils.isNotBlank(param)){
			param = "upload_mail.ROOT";
		} else if(param.equals("BOARD")){
			param = "upload_board.ROOT";
		} else if(param.equals("APR")){
			param = "upload_approvalG.ROOT";
		} else if(param.equals("COMMUNITY")){
			param = "upload_community.ROOT";
		} else if(param.equals("TASK")){
			param = "upload_task.ROOT";
		} else if(param.equals("SCHEDULE")){
			param = "upload_schedule.ROOT";
		}
		String realPath = commonUtil.getRealPath(request);
		String paramPath = commonUtil.getUploadPath(param, loginVO.getTenantId());
		
		downloadDIR = paramPath + "/tempWebfolderFileUpload/";
		
		String status = "OK";
		List<String> downloadPath = new ArrayList<String>();
		
		try {
			downloadPath = commonUtil.attachWebFolderFile(fileListJson, downloadDIR, loginVO, realPath);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			status = "ERROR";
		}
		resultJson.put("status", status);
		resultJson.put("downloadPath", downloadPath);
				
		return resultJson;
	}
	
	@Override
	public void createTblCar() throws Exception {
		ezCommonDAO.createTblCar();
	}

	@Override
	public void createTblCarAcl() throws Exception {
		ezCommonDAO.createTblCarAcl();
	}

	@Override
	public void createTblCarAttach() throws Exception {
		ezCommonDAO.createTblCarAttach();
	}

	@Override
	public void createTblCarForm() throws Exception {
		ezCommonDAO.createTblCarForm();
	}
	
	@Override
	public void addViewTaskOldFlag() throws Exception {
		ezCommonDAO.addViewTaskOldFlag();
		ezCommonDAO.addSViewTaskOldFlag();
	}

	@Override
	public HashMap<String, String> getTenantConfigList(int tenantID, String... propertyNames) throws Exception {

		HashMap<String, String> resultMap = new HashMap<>();
		HashMap<String, Object> map = new HashMap<>();
		map.put("property_names", propertyNames);
		map.put("tenantID" , tenantID);

		List<Map<String, String>> tenantConfigList = ezCommonDAO.getTenantConfigList(map);

		for (Map<String, String> configMap : tenantConfigList) {
			resultMap.put(String.valueOf(configMap.get("property_name")),configMap.get("property_value"));
		}

		return resultMap;
	}
	
	@Override
	public void createTblScheduleComplete() throws Exception {
		ezCommonDAO.createTblScheduleComplete();
	}

	@Override
	public void alterTblConnectionInfo() throws Exception {
		ezCommonDAO.alterTblConnectionInfo();
	}

	@Override
	public void createTblAdminAccessInfo() throws Exception {
		ezCommonDAO.createTblAdminAccessInfo();	
	}
	
	@Override
	public void createMailOutOfOfficeTemplate()  throws Exception {
		logger.debug("createMailOutOfOfficeTemplate started.");
		ezCommonDAO.createMailOutOfOfficeTemplate();
		logger.debug("createMailOutOfOfficeTemplate ended.");
	}

	@Override
	public void createUserMailTemplate() throws Exception {
		logger.debug("createUserMailTemplate started.");
		ezCommonDAO.createUserMailTemplate();
		logger.debug("createUserMailTemplate ended.");
	}

	@Override
	public void createTblPermissionChangeInfo() throws Exception {
		ezCommonDAO.createTblPermissionChangeInfo();
	}
	
	@Override
	public void insertReceiptHistoryListoption() throws Exception {
		List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();
		Map<String, Object> map = new HashMap<String, Object>();
		
		for (CompanyInfoVO company : companyList) {
			if (company.getCompanyId() != null) {
				map.put("companyId", company.getCompanyId());
				map.put("tenantId", company.getTenantId());
				ezCommonDAO.insertReceiptHistoryListoption(map);
			}
		}
	}
	
	@Override
	public void alterTblDevMaster() throws Exception {
		ezCommonDAO.alterTblDevMaster();
	}

	// List<List<Object>> 를 이용 엑셀 생성
	// (0,0)부터 차례대로 넣으면 됨. 여백 가능.
	@Override
	public String createExcelByList(String fileName, String dirPath, String sheetName, List<List<Object>> data) throws Exception {
		logger.debug("createExcelByList start. fileName: " + fileName + " / sheetName:" + sheetName);

		String filePath = dirPath + commonUtil.separator + fileName + ".xlsx";
		File folder = new File(dirPath);
		File file = new File(filePath);

		// 폴더가 존재하는경우 clean
		try {
			if (!folder.mkdirs()) FileUtils.cleanDirectory(folder);
		} catch (Exception e) {
			// 폴더 아래 파일들의 삭제가 안될경우에도 그냥 진행
			logger.debug("cleanDirectory Error : " + e.getMessage());
			logger.debug("cleanDirectory dirPath : " + dirPath);
		}

		// 같은 이름의 파일이 있을 경우: "파일(2).xlsx"으로 만든다.
		if (file.exists()) {
			int pos         = fileName.lastIndexOf('.');
			String extend   = fileName.substring(pos + 1);
			String mainName = fileName.substring(0, pos);
			int k           = 1;
			fileName        = mainName + "(" + k + ")." + extend;
			filePath        = dirPath + fileName;
			file           = new File(filePath);

			while (file.exists()) {
				filePath = dirPath + mainName + "(" + ++k + ")." + extend;
			}
		}


		FileOutputStream fileOut = null;
		int rowSize = 0;

		try (Workbook workbook = new XSSFWorkbook()) {
	
			Sheet sheet = workbook.createSheet(sheetName);
			sheet.setDefaultRowHeight((short)500);
	
			//Set style
			CellStyle styleHead = workbook.createCellStyle();
			styleHead.setWrapText(false);
			styleHead.setAlignment(CellStyle.ALIGN_CENTER);
			styleHead.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
			styleHead.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
			styleHead.setFillPattern(CellStyle.SOLID_FOREGROUND);
	
			CellStyle styleData = workbook.createCellStyle();
			styleData.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
	
			int rowNum = 0;
			//int rowSize = data.size();
			rowSize = data.size();
			boolean appearedHead = false;
			int colRangeStart = 0;
			int colRangeEnd = 0;
	
			while(rowNum < rowSize) {
				List<Object> dataList = data.get(rowNum);
				int colSize = dataList.size();
	
				if (colSize > 0) {
					Row row = sheet.createRow(rowNum);
	
					if (!appearedHead) {
						for (int colNum = 0; colNum < colSize; colNum++) {
							Object value = dataList.get(colNum);
							String strValue = String.valueOf(value).trim();
	
							if (value != null && !strValue.isEmpty()) {
								row.createCell(colNum).setCellValue(strValue);
								row.getCell(colNum).setCellStyle(styleHead);
								appearedHead = true;
								if(colRangeStart == 0) colRangeStart = colNum;
								colRangeEnd = colNum;
							}
						}
					} else {
						for (int colNum = 0; colNum < colSize; colNum++) {
							Object value = dataList.get(colNum);
							String strValue = String.valueOf(value).trim();
	
							if (value != null && !strValue.isEmpty()) {
								row.createCell(colNum).setCellValue(strValue);
								row.getCell(colNum).setCellStyle(styleData);
							}
						}
					}
				}

				rowNum++;
			}
	
			for (int i = colRangeStart; i <= colRangeEnd; i++) {
				sheet.setColumnWidth(i, ((int)(15 * 1.14388)) * 256);
			}

			//try {
			fileOut = new FileOutputStream(filePath);
			workbook.write(fileOut);
			fileOut.close();
		}
		catch (Exception e) {
			throw e;
		}
		finally {
			if (fileOut != null) fileOut.close();
			//workbook.close();
		}
		logger.debug("createExcelByList end. list size:" + rowSize);
		return fileName;
	}
	
	@Override
	public void createTblAprpreview() throws Exception {
		ezCommonDAO.createTblAprpreview();
	}
	
	@Override
	public void createTblDisableNotiItem() {
		ezCommonDAO.createTblDisableNotiItem();
	}
	
	@Override
	public void createTblSerialNoRollback() throws Exception {
		ezCommonDAO.createTblSerialNoRollback();
	}
	
	@Override
	public void insertHWPSecurityConfig() throws Exception {
		ezCommonDAO.insertHWPSecurityConfig();
	}

	// 2023-08-21 조소정 - 근태관리 > 작성 양식 테이블에 영어 버전 양식 컬럼 추가
	@Override
	public void addAttitudeFormFormHtml2Column() throws Exception {
		ezCommonDAO.addAttitudeFormFormHtml2Column();
	}

	@Override
	public void createTblUserChangeInfo() throws Exception {
		ezCommonDAO.createTblUserChangeInfo();
	}

    /* 2023-06-26  민지수 - 완료문서 추가의견 타입 추가 */
    public void insertOpinionGB() {
        Map<String, Object> map = new HashMap<String, Object>();

        List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();
        for (CompanyInfoVO company : companyList) {
            if (company.getCompanyId() != null) {
                map.put("code1", "A17");
                map.put("code2", "000");
                map.put("name", "추가의견");
                map.put("isuse", "1");
                map.put("descript", "추가의견");
                map.put("name2", "Add");
                map.put("name3", "追加");
                map.put("name4", "追加意见");
                map.put("tenantId", company.getTenantId());
                map.put("companyId", company.getCompanyId());

                ezCommonDAO.insertOpinionGB(map);
            }
        }
        logger.debug("insertOpinionGB ended");
    }
    
	// 2023-10-05 전인하 - 권한 코드 변경으로 인하여 기존 데이터를 변경하는 메소드
    @Override
    public void updateWebFolderAndApprovalCheckPermissionCode() throws Exception {
        ezCommonDAO.updateWebFolderAndApprovalCheckPermissionCode();
    }

	@Override
	public void createTblBoardReplyReact() throws Exception {
		ezCommonDAO.createTblBoardReplyReact();
	}

    /* 2023-09-25 민지수 - 게시판 > 공지게시물 > 기간설정 컬럼 추가 */
    public void addTblBoardItemNoti() throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("NtStartDate", commonUtil.getTodayUTCTime(""));
        map.put("NtEndDate","9999-12-30 14:59:59"); // 이미 존재하는 게시물 > 영구공지
        ezCommonDAO.addTblBoardItemNoti(map);
    }

    /* 2023-09-25 민지수 - 게시판 > 임시보관함 > 공지게시물 > 기간설정 컬럼 추가 */
    public void addTblBoardItemTempNoti() throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("NtStartDate", commonUtil.getTodayUTCTime(""));
        map.put("NtEndDate","9999-12-30 14:59:59"); // 이미 존재하는 게시물 > 영구공지
        ezCommonDAO.addTblBoardItemTempNoti(map);
    }
    
	@Override
	public void insertPrvwConfig() throws Exception {
		ezCommonDAO.insertPrvwConfig();
	}
	
	/* 2023-12-05 홍승비 - 전자결재 > 전자결재 서명 데이터 재맵핑 시점 컨피그 추가 */
	@Override
	public void insertApprSignRemapApplyTime() throws Exception {
		List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();
		
		for (TenantVO tenantVO : tenantIdList) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("tenantID", tenantVO.getTenantId());
			// 2024-10-17 홍승비 - 컨피그 비교 시에만 대문자로 비교하도록 수정 (삽입 시에는 apprSignRemapApplyTime 사용)
			map.put("property", "APPRSIGNREMAPAPPLYTIME");
			
			ezCommonDAO.insertApprSignRemapApplyTime(map);
		}
	}
    
    @Override
    public void insertPermissionBasisDeptYN_Config() throws Exception {
        ezCommonDAO.insertPermissionBasisDeptYN_Config();
    }
    
    @Override
    public void createTblDbLog() {
        ezCommonDAO.createTblDbLog();
    }

    // 2023-11-22 조소정 - 포탈 > 기본 탑메뉴 중국어 버전 추가
	@Override
	public void insertPortalMenuChinese() throws Exception {
		String tenantIdList = ezCommonDAO.getPortalMenuTenantList();
		String[] tenantIdArr = tenantIdList.split(",");
		int[] tenantIds = new int[tenantIdArr.length];
		
		for (int i = 0; i < tenantIdArr.length; i++) {
			tenantIds[i] = Integer.parseInt(tenantIdArr[i]);
			
			Map<String, Object> map = new HashMap<>();
	        map.put("v_TENANTID", tenantIds[i]);
			
	        // 테넌트 아이디에 따른 회사 아이디 모두 구함
			String companyIdList = ezCommonDAO.getPortalMenuCompanyList(map);
			String[] companyIdArr = companyIdList.split(",");
			String[] companyIds = new String[companyIdArr.length];
			
			for (int j = 0; j < companyIdArr.length; j++) {
				companyIds[j] = companyIdArr[j];
								
				Map<String, Object> map2 = new HashMap<>();
		        map2.put("v_TENANTID", tenantIds[i]);
		        map2.put("v_COMPANYID", companyIds[j]);
		        
				ezCommonDAO.insertPortalMenuChinese(map2);
			}
		}
	}

	// 2023-11-22 조소정 - 포탈 > 기본 포틀릿명 중국어 버전 추가
	@Override
	public void insertPortletNameChinese() throws Exception {
		String tenantIdList = ezCommonDAO.getPortletNameTenantList();
		String[] tenantIdArr = tenantIdList.split(",");
		int[] tenantIds = new int[tenantIdArr.length];
		
		for (int i = 0; i < tenantIdArr.length; i++) {
			tenantIds[i] = Integer.parseInt(tenantIdArr[i]);
			
			Map<String, Object> map = new HashMap<>();
	        map.put("v_TENANTID", tenantIds[i]);
			
	        // 테넌트 아이디에 따른 회사 아이디 모두 구함
			String companyIdList = ezCommonDAO.getPortletNameCompanyList(map);
			String[] companyIdArr = companyIdList.split(",");
			String[] companyIds = new String[companyIdArr.length];
			
			for (int j = 0; j < companyIdArr.length; j++) {
				companyIds[j] = companyIdArr[j];
								
				Map<String, Object> map2 = new HashMap<>();
		        map2.put("v_TENANTID", tenantIds[i]);
		        map2.put("v_COMPANYID", companyIds[j]);
		        
				ezCommonDAO.insertPortletNameChinese(map2);
			}
		}
	}

	// 2023-11-27 조소정 - 게시판그룹 일본어 버전 생성 위해 LangTertiary 테넌트 컨피그 추가	
	@Override
	public void insertTenantConfigLangTertiary() throws Exception {
		List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();
		
		for (TenantVO tenantVo : tenantIdList) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_TENANTID", tenantVo.getTenantId());
			
			ezCommonDAO.insertTenantConfigLangTertiary(map);
		}		
	}

	// 2023-11-27 조소정 - 게시판그룹 중국어 버전 생성 위해 LangQuaternary 테넌트 컨피그 추가
	@Override
	public void insertTenantConfigLangQuaternary() throws Exception {
		List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();
		
		for (TenantVO tenantVo : tenantIdList) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_TENANTID", tenantVo.getTenantId());
			
			ezCommonDAO.insertTenantConfigLangQuaternary(map);
		}		
	}

    @Override
    public void insertLoadTimeForApprAllConfig() {
    	ezCommonDAO.insertLoadTimeForApprAllConfig();
    }

	@Override
	public void createTblDeptChangeInfo() throws Exception {
		ezCommonDAO.createTblDeptChangeInfo();
	}
    @Override
    public void insertSurveyPostingMaxPeriodConfig() throws Exception {
        List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();

        for (TenantVO tenantVo : tenantIdList) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("v_TENANTID", tenantVo.getTenantId());

            ezCommonDAO.insertSurveyPostingMaxPeriodConfig(map);
        }
    }

    @Override
    public void alterFileNameForWebfolderHistory() throws Exception {
        ezCommonDAO.alterFileNameForWebfolderHistory();
    }

	/** 2023-06-27 한태훈 - 전자결재 > 통합PC저장 다운로드 이력 남기는 테이블 생성(차후에 다른 이력을 남기기 위한 테이블로 쓸 수 있음) */
	@Override
	public void createTblTotalHistory() throws Exception {
		logger.debug("createTblTotalHistory started");
		ezCommonDAO.createTblTotalHistory();
		logger.debug("createTblTotalHistory ended");
	}

    public void insertdelAttachByOthersConfing() throws Exception {
        List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();

        for (TenantVO tenantVo : tenantIdList) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("v_TENANTID", tenantVo.getTenantId());
            ezCommonDAO.insertdelAttachByOthersConfing(map);
        }
    }

    @Override
    public void insertUseHideHeaderArea() throws Exception {
    	List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();

    	for (TenantVO tenantVo : tenantIdList) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("v_TENANTID", tenantVo.getTenantId());
            ezCommonDAO.insertUseHideHeaderArea(map);
        }
    }

    // 2024-05-28 이유정 - 자원관리 > 자원반복예약 허용 설정을 위한 RepeatFlag 컬럼 추가
    public void alterRepeatFlagForResourceInfo() throws Exception {
        ezCommonDAO.alterRepeatFlagForResourceInfo();
    }

    /* 2024-05-28 김유진 - 포탈 메뉴,포틀릿,테마,빠른링크 > 하위부서 허용여부 컬럼 추가, 빠른링크 > 유저타입 컬럼 추가 */
    @Override
    public void alterSubPermittedForMenuAuth() throws Exception {
        ezCommonDAO.alterSubPermittedForMenuAuth();
    }

    @Override
    public void alterSubPermittedForPortletAuth() throws Exception {
        ezCommonDAO.alterSubPermittedForPortletAuth();
    }

    @Override
    public void alterSubPermittedForThemeAuth() throws Exception {
        ezCommonDAO.alterSubPermittedForThemeAuth();
    }

    @Override
    public void alterSubPermittedForQuicklinkAcl() throws Exception {
        ezCommonDAO.alterSubPermittedForQuicklinkAcl();
    }

    /* 2024-05-29 김유진 - tenant_config 작업; 전자결재G 비전자문서등록 양식 확장자 정보추가 */
    public void insertApprNonElecRecTypeConfing() throws Exception {
        List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();

        for (TenantVO tenantVo : tenantIdList) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("v_TENANTID", tenantVo.getTenantId());
            ezCommonDAO.insertApprNonElecRecTypeConfing(map);
        }
    }

    @Override
    public void insertRecordHeaderClassTitle() throws Exception {
        List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();
        Map<String, Object> map = new HashMap<String, Object>();

        for (CompanyInfoVO company : companyList) {
            if (company.getCompanyId() != null) {
                map.put("v_COMPANYID", company.getCompanyId());
                map.put("v_TENANTID", company.getTenantId());
                ezCommonDAO.insertRecordHeaderClassTitle(map);
            }
        }
    }

    @Override
    public void insertUseReceiptDeptFileAttach() throws Exception {
    	List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();

    	for (TenantVO tenantVo : tenantIdList) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("v_TENANTID", tenantVo.getTenantId());
            ezCommonDAO.insertUseReceiptDeptFileAttach(map);
        }
    }


    public void insertDocBinderListOption() throws Exception {
        List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();
        Map<String, Object> map = new HashMap<String, Object>();

        for (CompanyInfoVO company : companyList) {
            if (company.getCompanyId() != null) {
                map.put("companyId", company.getCompanyId());
                map.put("tenantId", company.getTenantId());
                ezCommonDAO.insertDocBinderListOption(map);
            }
        }
    }

    @Override
    public void insertEndDateOptionConfig() throws Exception {
        List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();

        for (TenantVO tenantVo : tenantIdList) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("v_TENANTID", tenantVo.getTenantId());

            ezCommonDAO.insertEndDateOptionConfig(map);
        }
    }

    // 2024-06-24 양지혜 - 전자결재 > 지정반송 사용여부 컨피그
    @Override
    public void insertReturnByDesignationUsedConfig() throws Exception {
        List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();
        String property = "ReturnByDesignationUsed";

        for (TenantVO tenantVo : tenantIdList) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("tenantID", tenantVo.getTenantId());
            map.put("property", property.toUpperCase());

            ezCommonDAO.insertReturnByDesignationUsedConfig(map);
        }
    }

    public void alterDocAttachNameCol() throws Exception {
        ezCommonDAO.alterDocAttachNameCol();
    }

	@Override
	public void addColumnsRetireTblCompareWithUserTbl() throws Exception {
		logger.debug("addColumnsRetireTblCompareWithUserTbl started");
		List<TblColumnsInfoVO> columnsList = ezCommonDAO.selectColumnsOnlyExistTblUsermaster();
		if (!columnsList.isEmpty()) {
			for (TblColumnsInfoVO columns : columnsList) {

				Map<String, Object> map = new HashMap<>();

				map.put("TABLE","TBL_USERMASTER_RETIRE");
				map.put("COLUMN", columns.getColumnNm());
				map.put("TYPE_MYSQL", columns.getColumnType());
				map.put("TYPE_ORACLE", columns.getColumnType());
				map.put("AFTER", columns.getIsNullAble() +
						(columns.getColumnDefault() == null ? "" : " DEFAULT " + columns.getColumnDefault()));

				ezCommonDAO.alterTableAddColumns(map);
			}
		}
	}

    public void insertNonUseDocAttachYN() throws Exception {
        List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();

        for (TenantVO tenantVo : tenantIdList) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("v_TENANTID", tenantVo.getTenantId());
            ezCommonDAO.insertNonUseDocAttachYN(map);
        }
    }

    @Override
    public void insertReadingRecordHeader() throws Exception {
        List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();
        Map<String, Object> map = new HashMap<String, Object>();

        for (CompanyInfoVO company : companyList) {
            if (company.getCompanyId() != null) {
                map.put("companyId", company.getCompanyId());
                map.put("tenantId", company.getTenantId());
                ezCommonDAO.insertReadingRecordHeader(map);
            }
        }
    }

    @Override
    public void insertPortalPortletSizeTables() {
        ezCommonDAO.insertPortalPortletSizeTables();
    }

    @Override
    public void insertTblPortalTopUser() {
        ezCommonDAO.insertTblPortalTopUser();
    }

    // 2024-03-28 한태훈 > 통합알림 테이블 생성하는 메소드
	@Override
	public void createTblRealTimeNotification() throws Exception {
		ezCommonDAO.createTblRealTimeNotification();
	}

	// 2024-03-28 한태훈 > 통합알림 보관기간 tenant config 생성하는 메소드
	@Override
	public void addNotiStoragePeriodConfig() throws Exception {
		List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("propertyName", "notiStoragePeriod");
		map.put("propertyValue", "10");
		map.put("description", "통합알림 데이터 보관 기간(default: 10)(일)");
		map.put("configName", "통합알림 데이터 보관 기간");
		map.put("regdate", "2024-04-25 00:00:00");
		map.put("configType", "통합알림");

		for (TenantVO tenantVo : tenantIdList) {
			map.put("tenantId", tenantVo.getTenantId());
			ezCommonDAO.addNotiStoragePeriodConfig(map);
		}
	}

	// 2024-03-28 한태훈 > 통합알림 polling 방식 이용시 알림 데이터 새로고침 주기 설정
	@Override
	public void addNotiPollingIntervalConfig() throws Exception {
		List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("propertyName", "notiPollingInterval");
		map.put("propertyValue", "60000"); // 1분이 기본값. 단위는 밀리초
		map.put("description", "통합알림 데이터 새로고침 주기 설정(단위는 밀리초)");
		map.put("configName", "통합알림 데이터 새로고침 주기");
		map.put("regdate", "2024-04-25 00:00:00");
		map.put("configType", "통합알림");

		for (TenantVO tenantVo : tenantIdList) {
			map.put("tenantId", tenantVo.getTenantId());
			ezCommonDAO.addNotiPollingIntervalConfig(map);
		}

	}

    @Override
    public void insertFixPortlet() {
        int cnt = ezCommonDAO.checkPortletCodeString(FixBoardCode.FIX_LEFT.getCode());
        if (cnt > 0) return;
        int portletID = ezCommonDAO.getNewPortletId();
        List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();
        FixBoardCode[] codes = FixBoardCode.values();
        int order = codes.length * -1;

        Map<String, Object> map = new HashMap<>();
        map.put("portletName1", "고정 포틀릿");
        map.put("portletName2", "fixed portlet");
        map.put("portletName3", "固定ポートレット");
        map.put("portletName4", "固定门户组件");
        map.put("portletName5", "portlet cố định");
        map.put("portletName6", "portlet tetap");
        map.put("menuId", 4);
        map.put("portletUrl", "/ezNewPortal/getCustomBoardInfo.do");
        map.put("connectionUrl", "/ezNewPortal/getCustomBoardInfo.do");
        map.put("portletType", "G");

        for(FixBoardCode code : codes) {
            map.put("portletId", portletID);
            map.put("defaultOrder", order);
            map.put("portletUsed", 1);
            map.put("portletOrder", order);
            map.put("boardId", null);
            map.put("portletCode", code.getCode());
            ezCommonDAO.insertPortletWithCode(map);

            for (CompanyInfoVO company : companyList) {
                if (company.getCompanyId() != null) {
                    map.put("companyId", company.getCompanyId());
                    map.put("tenantId", company.getTenantId());
                    ezCommonDAO.insertPortletInfoData(map); // 회사별 있는지 확인후 insert
                }
            }
            portletID++;
            order++;
        }
    }

	@Override
	public void insertTblPortalTopCompany() throws Exception {
		ezCommonDAO.insertTblPortalTopCompany();
	}

	@Override
	public void insertPortalTopCompanyInitdata() throws Exception {
		ezCommonDAO.insertPortalTopCompanyInitdata();
	}

    @Override
	public void addQuickLinkCompanyID() throws Exception {
		ezCommonDAO.addQuickLinkCompanyID();
	}

	@Override
	public void alterUserThemePagination() throws Exception {
		ezCommonDAO.alterUserThemePagination();
	}

	@Override
	public void alterThemeInformation() throws Exception {
		String themeContent1 = ezCommonDAO.checkThemeInformation().trim();
		if (themeContent1.equals("왼쪽 혹은 오른쪽에 사용자 관련 정보가 있는 디자인의 테마입니다.")) {
			Map<String, Object> map = new HashMap<>();
			map.put("themeId", 1);
			map.put("themeContent1", "소식 및 상단영역이 있는 디자인의 테마입니다.");
			map.put("themeContent2", "A theme with a design that includes news and a top area.");
			map.put("themeContent3", "ニュースやトップエリアのあるデザインのテーマです。");
			map.put("themeContent4", "这是一个包含新闻和顶部区域的设计主题。");
			map.put("themeContent5", "A theme with a design that includes news and a top area.");
			map.put("themeContent6", "A theme with a design that includes news and a top area.");
			ezCommonDAO.alterThemeInformation(map);
			map.put("themeId", 2);
			map.put("themeContent1", "위쪽에 정보 및 바로가기가 있는 디자인의 테마입니다.");
			map.put("themeContent2", "A theme with a design that has information and shortcuts at the top.");
			map.put("themeContent3", "上部に情報やショートカットがあるデザインのテーマです。");
			map.put("themeContent4", "该主题的设计在顶部包含信息和快捷方式。");
			map.put("themeContent5", "A theme with a design that has information and shortcuts at the top.");
			map.put("themeContent6", "A theme with a design that has information and shortcuts at the top.");
			ezCommonDAO.alterThemeInformation(map);
			map.put("themeId", 3);
			map.put("themeContent1", "정보 관련 고정영역이 없어 포틀릿에 집중할 수 있는 테마입니다.");
			map.put("themeContent2", "A theme that allows to focus on portlets without any fixed areas related to information.");
			map.put("themeContent3", "情報関連の固定領域がなくてもポートレットに集中できるテーマです。");
			map.put("themeContent4", "该主题允许您专注于 portlet，而无需任何与信息相关的固定区域。");
			map.put("themeContent5", "A theme that allows to focus on portlets without any fixed areas related to information.");
			map.put("themeContent6", "A theme that allows to focus on portlets without any fixed areas related to information.");
			ezCommonDAO.alterThemeInformation(map);
		}

	}

    @Override
    public void alterCompanyMenuIconUrl() throws Exception {
        ezCommonDAO.alterCompanyMenuIconUrl();
    }

    @Override
    public void alterTblScheduleForShowtop() throws Exception {
        ezCommonDAO.alterTblScheduleForShowtop();
    }

    @Override
    public void addUserDeptHideFlag() throws Exception {
        ezCommonDAO.addUserDeptHideFlag();
    }
    
    @Override
    public void insertGongRamListOption() throws Exception {
        List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();
        Map<String, Object> map = new HashMap<String, Object>();

        for (CompanyInfoVO company : companyList) {
            if (company.getCompanyId() != null) {
                map.put("companyId", company.getCompanyId());
                map.put("tenantId", company.getTenantId());

                ezCommonDAO.insertGongRamListOption(map);
            }
        }
    }
    
    // 2023-09-08 한태훈 - 일정관리 > 미리알림 시간 설정 컬럼 추가
 	@Override
 	public void addReminderTimeAtTblScheduleConfig() throws Exception {
 		ezCommonDAO.addReminderTimeAtTblScheduleConfig();
 	}
 	
 	// 2023-09-08 한태훈 - 일정관리 > 미리알림 스케줄러 테이블 추가
 	@Override
 	public void createTblScheduleReminderScheduler() throws Exception {
 		ezCommonDAO.createTblScheduleReminderScheduler();
 	}
 	
 	// 2023-09-11 한태훈 - 일정관리 > 미리알림 방식(닷넷 통합 알림, 자바 메일) 선택 테넌트 컨피그 추가, 미리알림 시 하루종일 일정의 시작 시각 설정 컨피그 추가
 	@Override
 	public void insertReminderTenantConfig() throws Exception {
 		
 		List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();
 		
 		for (TenantVO tenantVo : tenantIdList) {
 			Map<String, Object> map = new HashMap<String, Object>();
 			map.put("tenantID", tenantVo.getTenantId());
 			ezCommonDAO.insertReminderTenantConfig(map);
 		}
 		
 	}

    // 2024-06-28 이유정 - 캐비넷 > 캐비넷공유 > 공유자 저장여부 컬럼 추가
    public void alterSaveFlagForCbShare() throws Exception {
        ezCommonDAO.alterSaveFlagForCbShare();
    }
    
    @Override
    public void alterBoardExtentionAttrByteSize() throws Exception {
        ezCommonDAO.alterBoardExtentionAttrByteSize();
    }
    
    // 2024-08-21 유길상 닷넷 통합알림 컨피그
    @Override
    public void insertDotNetTotalNotificationConfig() throws Exception{
    	List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();
 		
 		for (TenantVO tenantVo : tenantIdList) {
 			Map<String, Object> map = new HashMap<String, Object>();
 			map.put("tenantID", tenantVo.getTenantId());
 			ezCommonDAO.insertDotNetTotalNotificationConfig(map);
 		}
    }
    
    @Override
    public void createBoardKeywordTable() throws Exception {
        ezCommonDAO.createBoardKeywordTable();
    }
    
    @Override
    public void updateInProcessJpCodeName3() throws Exception{
    	ezCommonDAO.updateInProcessJpCodeName3();
    }

    @Override
    public void createTblDistributeinfo() throws Exception {
        ezCommonDAO.createTblDistributeinfo();
    }
    
    @Override
    public void createExecutiveTable() throws Exception {
        ezCommonDAO.createExecutiveTable();
    }
    
    @Override
    public void createServeyResultviewPermTbl() throws Exception {
        ezCommonDAO.createServeyResultviewPermTbl();
    }

    /* 2024-07-17 기민혁 - 전자결재 > 양식함 순서 컬럼 추가 */
    @Override
    public void addTblFormContainerSN() throws Exception {
        ezCommonDAO.addTblFormContainerSN();
    }

	@Override
    public void insertInitMobileTheme() throws Exception {

        Map<String, Object> map = new HashMap<>();
        List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();
        ezCommonDAO.resetMobileUser(); // 모바일 메인화면 타입 포틀릿으로 통합 "D"

        String[] checkMobileCodes = {"mFixTop", "mFixBottom", "mSchedule", "mResource", "mApprovallist", "mReceivedmail", "mNotice", "mPhotoboard"};
        
        int[] menuId = {4, 4, 2, 6, 3, 1, 4, 4};
        
        String[] portletUrl = {
            "/mobile/ezNewPortal/getCustomBoardInfo.do",
            "/mobile/ezNewPortal/getCustomBoardInfo.do",
            "/mobile/ezNewPortal/schedulePortlet.do",
            "/mobile/ezNewPortal/resourcePortlet.do",
            "/mobile/ezNewPortal/approvalListPortlet.do",
            "/mobile/ezNewPortal/receivedMailPortlet.do",
            "/mobile/ezNewPortal/noticePortlet.do",
            "/mobile/ezNewPortal/photoBoardPortlet.do"
        };

        String[][] portletNames = {
            {"고정 포틀릿","fixed portlet","固定ポートレット","固定门户组件","portlet cố định","portlet tetap"},
            {"고정 포틀릿","fixed portlet","固定ポートレット","固定门户组件","portlet cố định","portlet tetap"},
            {"일정","Schedule","日程","附表","Schedule","Schedule"},
            {"자원관리","Resource","設備管理","教学资源","Resource","Resource"},
            {"결재리스트","Approval List","電子決裁リスト","批准名单","Approval List","Approval List"},
            {"받은 메일","Mail","受信トレイ","收件邮件","Mail","Mail"},
            {"공지사항","Notice","お知らせ","公告","Notice","Notice"},
            {"포토 갤러리","Photo Gallery","フォトギャラリー","相片集","Photo Gallery","Photo Gallery"}
        };
        
        int portletId = ezCommonDAO.getNewPortletId();
        map.put("webType", "mobile");
        if ((int)ezCommonDAO.checkPortletCodeString("mFixTop") < 1) { // 모바일 init data 유무 판단
            ezCommonDAO.insertMobileTheme(); // portal_theme
            ezCommonDAO.insertMobileFrame(); // portal_frame
            for (int i = 0;  i < checkMobileCodes.length; i++) {
                if ((int)ezCommonDAO.checkPortletCodeString(checkMobileCodes[i]) < 1) {
                    map.put("portletId", portletId);
                    map.put("menuId", menuId[i]);
                    map.put("portletUrl", portletUrl[i]);
                    map.put("connectionUrl", portletUrl[i]);
                    map.put("portletType", "MG");
                    map.put("portletUsed", "1");
                    map.put("defaultOrder", i+1);
                    map.put("portletOrder", i+1);
                    map.put("portletCode", checkMobileCodes[i]);
                    ezCommonDAO.insertPortletWithCode(map); //portal_portlet
                    
                    for (int j = 0; j < portletNames[i].length; j++) {
                        map.put("portletName" + (j + 1), portletNames[i][j]);
                    }
                    
                    // portlet_comp, portlet_name, theme_portlet, portal_portlet_auth
                    for (int j = 0; j < companyList.size(); j++) {
                        CompanyInfoVO company = companyList.get(j);
                        if (company.getCompanyId() != null) {
                            map.put("companyId", company.getCompanyId());
                            map.put("tenantId", company.getTenantId());
                            ezCommonDAO.insertPortletInfoData(map);
                            ezCommonDAO.insertMobileFrameComp(map);
                            ezCommonDAO.insertMobileThemeComp(map);
                        }
                    }
                }
                portletId++;
            }
        }
    }

	@Override
	public void alterMenuOpenType() throws Exception {
		ezCommonDAO.alterMenuOpenType();
	}
	
	@Override
	public void createSystemConfig() throws Exception {
		logger.debug("createSystemConfig started");
		ezCommonDAO.createTblSystemConfig();
		ezCommonDAO.createTblSystemConfigType();
		ezCommonDAO.addConnectionIDtoTblPortalPortletComp();
		logger.debug("createSystemConfig ended");
	}

	@Override
	public void createConnectionMenu() throws Exception {
		logger.debug("createConnectionMenu started");
		List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();
		
		String connectMenuId = ezCommonDAO.checkConnectionMenu();
		
		if (connectMenuId == null) {
			logger.debug("connectionMenu doesn't exist. add connection menu data...");
			ezCommonDAO.insertConnectionMenu();
			for (CompanyInfoVO company : companyList) {
				if (company.getCompanyId() != null) {
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("companyId", company.getCompanyId());
					map.put("tenantId", company.getTenantId());
					ezCommonDAO.insertConnectMenuInfo(map);
				}
			}
		}
		logger.debug("createConnectionMenu ended");
	}

	@Override
	public void insertStandardSystemConfigData() throws Exception {
		logger.debug("insertStandardSystemConfigData started");
		List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();
		String nowDate = commonUtil.getTodayUTCTime("");
		for (CompanyInfoVO company : companyList) {
			if (company.getCompanyId() != null) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("companyId", company.getCompanyId());
				map.put("tenantId", company.getTenantId());
				map.put("nowDate", nowDate);
                
                Locale locale = commonUtil.getPrimaryLocale(company.getTenantId());
                map.put("typeName", egovMessageSource.getMessage("ezSystem.config.type", locale));
                map.put("typeDetail", egovMessageSource.getMessage("ezSystem.config.type.detail", locale));
                map.put("configDetail", egovMessageSource.getMessage("ezSystem.config.detail", locale));
				ezCommonDAO.insertStandardSystemConfigData(map);
			}
		}
		
		logger.debug("insertStandardSystemConfigData ended");
	}

	@Override
	public void createEmergencyNotiTable() throws Exception {
		logger.debug("createEmergencyNotiTable started");
		
		ezCommonDAO.createTblNotiEmergencyCompany();
		ezCommonDAO.createTblNotiEmergencyItem();
		ezCommonDAO.createTblNotiEmergencyPermission();
		
		logger.debug("createEmergencyNotiTable ended");
	}
	
	// 2024-08-08 조수빈 - 모바일 우측 panel의 기본 toggle menu 데이터 추가
	public void insertMobileToggleMenus() throws Exception {
		logger.debug("insertMobileToggleMenus started.");
		
		// menu_type이 'MG'인 데이터가 있는지 확인 (연계인 -1 제외)
		if (!ezCommonDAO.hasMobileMenus()) {
			
			int menuId = ezCommonDAO.getNewMenuId();
			ezCommonDAO.insertMobileMenus(menuId);
			
			List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();
			
			for (CompanyInfoVO compVo : companyList) {
				Map<String, Object> param = new HashMap<>();
				param.put("companyId", compVo.getCompanyId());
				param.put("tenantId", compVo.getTenantId());
				param.put("menuId", menuId);
				
				ezCommonDAO.insertCompanyMobileMenus(param);
				ezCommonDAO.insertCompanyMobileMenuNames(param);
				ezCommonDAO.insertMobileMenusAuth(param);
			}
		}
		
		logger.debug("insertMobileToggleMenus ended.");
	}

	@Override
	public void alterUseColor() throws Exception {
		ezCommonDAO.alterUseColor();
	}

	@Override
	public void updateThemeData() throws Exception {
		ezCommonDAO.updateThemeData();
	}

    @Override
    public void createRsScheduleDeptIdColumn() throws Exception {
        ezCommonDAO.createRsScheduleDeptIdColumn();
    } 

    /* 2023-03-30 이가은 - 게시판 > 게시물 댓글 정보 테이블에 답글 작성/수정기능 컬럼 추가 */
	@Override
	public void alterTblBoardOneLineChildReply() throws Exception {
		ezCommonDAO.alterTblBoardOneLineChildReply();
	}
    
    // 2023-11-07 전인하 - 댓글 이모티콘 관련 컬럼 추가    
    @Override
    public void insertBoardReplyCommentEmoticon() throws Exception {
        ezCommonDAO.insertBoardReplyCommentEmoticon();
    }
	
	@Override
	public void createTblBoardDisLike() throws Exception{
		ezCommonDAO.createTblBoardDisLike();
	}
	
	@Override
	public void addBoardDisLikeFlag() throws Exception{
		ezCommonDAO.addBoardDisLikeFlag();
	}
	
    // 2024-08-07 유길상 - 자원관리 즐겨찾기 카테고리 테이블 추가
    @Override
    public void createResourceFavoriteTables() throws Exception {
    	ezCommonDAO.createTblRsFavCat();
    	ezCommonDAO.createTblRsCatBrd();
    }
    
    @Override
    public void addBoardAttachmentFlag() throws Exception {
        ezCommonDAO.addBoardAttachmentFlag();
    }

    @Override
    public void addTblBoardInfoPublicFlag() {
        ezCommonDAO.addTblBoardInfoPublicFlag();
    }

    /* 2024-10-21 한태훈 - 게시판 > 전체게시물 리스트헤더 추가 */
    @Override
    public void insertAllBoardListOption() throws Exception{
        List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();

        for (TenantVO tenantVo : tenantIdList) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("v_TENANTID", tenantVo.getTenantId());
            ezCommonDAO.insertAllBoardListOption(map);
        }
    }
    
    /* 2024-10-17 한태훈 - 게시판 > 전체게시물 게시판정보 추가 */
    @Override
    public void insertAllBoardInfo() throws Exception{
        List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();

        for (TenantVO tenantVo : tenantIdList) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("v_TENANTID", tenantVo.getTenantId());
            ezCommonDAO.insertAllBoardInfo(map);
        }
    }
    
	@Override
	public void addSurveyTotalNotiSentFlag() throws Exception {
		ezCommonDAO.addSurveyTotalNotiSentFlag();
	}

    @Override
    public void createJmochaMailBlocked() throws Exception {
        ezCommonDAO.createJmochaMailBlocked();
    }
    
    @Override
    public void insertModuleEditor() throws Exception {
    	List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();

    	for (TenantVO tenantVo : tenantIdList) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("v_TENANTID", tenantVo.getTenantId());
            ezCommonDAO.insertModuleEditor(map);
        }
    }
	
    @Override
    public void insertServername() throws Exception {
        ezCommonDAO.insertServername();
    }
    
	@Override
	public void insertScrapTenantConfig() throws Exception {
        List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();
        for (TenantVO tenantVo : tenantIdList) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("tenantId", tenantVo.getTenantId());
            map.put("propertyName", "MyBoardScrapFlag");
            map.put("propertyValue", "TYPE1");
            map.put("description", "NONE: 사용안함 / TYPE1: 마이게시판 하위 스크랩함 / TYPE2: 게시판 트리 하위 개인화 스크랩함 (default: TYPE1)");
            map.put("configName", "게시판 스크랩 기능 사용 여부");
            map.put("configType", "게시판");
            map.put("regdate", "2023-06-14 00:00:00");

            ezCommonDAO.insertScrapTenantConfig(map);
        }
	}

    @Override
    public void insertScrapTableHeader() throws Exception {
        List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();
        for (TenantVO tenantVo : tenantIdList) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("tenantId", tenantVo.getTenantId());
            map.put("listType", "S");

            ezCommonDAO.insertScrapTableHeader(map);
        }
    }
	
	@Override
	public void createTblBoardScrap() throws Exception {
		ezCommonDAO.createTblBoardScrap();
	}
	
	@Override
	public void createTblUserScrapCont() throws Exception {
		ezCommonDAO.createTblUserScrapCont();
	}
	
	@Override
	public void createTblUserScrapContList() throws Exception {
		ezCommonDAO.createTblUserScrapContList();
	}

    @Override
    public void createTblBoardCommentAttachments() throws Exception {
        ezCommonDAO.createTblBoardCommentAttachments();
    }

    @Override
    public void createJmochaCompanyQuota() throws Exception {
        ezCommonDAO.createJmochaCompanyQuota();
    }
    
    @Override
    public void alterAddThumbnailForTPI() throws Exception {
    	ezCommonDAO.alterAddThumbnailForTPI();
    }
    
    @Override
    public void alterThumbnailExtForTPI() throws Exception {
    	ezCommonDAO.alterThumbnailExtForTPI();
    }
    
    @Override
    public void alterAttachmentsForCBoard() throws Exception {
    	ezCommonDAO.alterAttachmentsForCBoard();
    }

	@Override
	public void addIsDeleteBlockToSytemConfig() throws Exception {
		ezCommonDAO.addIsDeleteBlockToSytemConfig();
	}

    @Override
    public void addTblCommunityClubguestOnelinereply() throws Exception {
        ezCommonDAO.addTblCommunityClubguestOnelinereply();
    }

    /* 2024-09-11 이유정 - 게시판 > 최근게시물 리스트헤더 추가 */
    @Override
    public void insertBoardItemListOptionAN() throws Exception{
        List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();

        for (TenantVO tenantVo : tenantIdList) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("v_TENANTID", tenantVo.getTenantId());
            ezCommonDAO.insertBoardItemListOptionAN(map);
        }
    }

    /* 2024-09-11 이유정 - 게시판 > 최근게시물 게시판정보 추가 */
    @Override
    public void insertRecentBoardInfo() throws Exception{
        List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();

        for (TenantVO tenantVo : tenantIdList) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("v_TENANTID", tenantVo.getTenantId());
            ezCommonDAO.insertRecentBoardInfo(map);
        }
    }
    
    @Override
    public void addBoardAllNewBoardFlag() throws Exception {
        ezCommonDAO.addBoardAllNewBoardFlag();
    }

    @Override
    public void addBoardAllNewBoardListDate() throws Exception {
        ezCommonDAO.addBoardAllNewBoardListDate();
    }

    @Override
    public void createTblAprAutoSaveConfig() throws Exception {
        List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();
        for (TenantVO tenantVo : tenantIdList) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("tenantId", tenantVo.getTenantId());
            map.put("propertyName", "AprAutoSaveFlag");
            map.put("propertyValue", "YES");
            map.put("description", "YES: 사용 NO: 사용안함 (default: YES)");
            map.put("configName", "전자결재 G 자동 임시저장 사용 여부");
            map.put("configType", "전자결재G");
            map.put("regdate", "2024-07-10 00:00:00");

            ezCommonDAO.insertAprAutoSaveConfig(map);
        }
    }

    // 2024-12-04 기민혁 - 전자결재 > 최근서식 사용여부 테넌트 컨피그 추가
    @Override
    public void insertResendFormYN() throws Exception {
        List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();

        for (TenantVO tenantVo : tenantIdList) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("v_TENANTID", tenantVo.getTenantId());
            ezCommonDAO.insertResendFormYN(map);
        }
    }

    // 2024-12-05 기민혁 - 전자결재 > 본문수정 시 본문버전 변경 기능 사용여부 테넌트 컨피그 추가
    @Override
    public void insertEditVertionYN() throws Exception {
        List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();

        for (TenantVO tenantVo : tenantIdList) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("v_TENANTID", tenantVo.getTenantId());
            ezCommonDAO.insertEditVertionYN(map);
        }
    }

    // 2024-12-10 기민혁 - 전자결재 > 수정버전,수정모드 컬럼 추가
    @Override
    public void alterEditVersionHistory() throws Exception {
        ezCommonDAO.alterEditVersionHistory();
    }

    // 2024-12-10 기민혁 - 수정버전 리스트 해더 생성
    @Override
    public void insertEditVersionListOption() throws Exception {
        List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();
        Map<String, Object> map = new HashMap<String, Object>();

        for (CompanyInfoVO company : companyList) {
            if (company.getCompanyId() != null) {
                map.put("companyId", company.getCompanyId());
                map.put("tenantId", company.getTenantId());
                map.put("listOption", "K064");

                ezCommonDAO.insertEditVersionListOption(map);
            }
        }
    }

    // 2024-11-26 기민혁 - 전자결재 > 개인수신함 사용여부 테넌트 컨피그 추가
    @Override
    public void insertPersonalHideSusinYN() throws Exception {
        List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();

        for (TenantVO tenantVo : tenantIdList) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("v_TENANTID", tenantVo.getTenantId());
            ezCommonDAO.insertPersonalHideSusinYN(map);
        }
    }

    // 2024-11-28 기민혁 - 개인 수신함 리스트 해더 추가
    @Override
    public void insertPersonalSusinListOption() throws Exception {
        List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();
        Map<String, Object> map = new HashMap<String, Object>();

        for (CompanyInfoVO company : companyList) {
            if (company.getCompanyId() != null) {
                map.put("companyId", company.getCompanyId());
                map.put("tenantId", company.getTenantId());
                map.put("listOption", "P004");
                
                ezCommonDAO.insertPersonalSusinListOption(map);
            }
        }
    }

    /* 2024-07-05 양지혜 - 전자결재 > 상위부서문서함 사용여부 컬럼 추가 */
    @Override
    public void alterUseUpperDeptBox() throws Exception {
        ezCommonDAO.alterUseUpperDeptBox();
    }

    /* 2025-03-10 유지아 - 톡알림 테이블 tenantId추가 */
    @Override
    public void alterTalkNotiTenant() throws Exception {
        ezCommonDAO.alterTalkNotiTenant();
    }
    @Override
    public void alterServerNameMain() throws Exception {
        ezCommonDAO.alterServerNameMain();
    }

    @Override
    public void alterBodyHTMLToConnData() throws Exception {
        ezCommonDAO.alterBodyHTMLToConnData();
    }

    // 2024-12-27 이가은 - 공람완료문서 삭제 히스토리 테이블 생성
    @Override
    public void createGongramDeleteHistory() throws Exception {
        ezCommonDAO.createGongramDeleteHistory();
    }

    @Override
    public void addBoardWriterFlagAndWriterNameType() throws Exception {
        ezCommonDAO.alterBoardInfoWriterFlag(); // tbl_board_boardInfo 테이블 writerFlag 컬럼 추가
        ezCommonDAO.alterBoardItemWriterNameType(); // tbl_board_item 테이블 writerNameType 컬럼 추가
        ezCommonDAO.alterBoardItemTempWriterNameType(); // tbl_board_item_temp 테이블 writerNameType 컬럼 추가
    }
    @Override
    public void createTblScheduleGather() throws Exception {
        ezCommonDAO.createTblScheduleGather();
    }

	@Override
	public void addMemberDeptIdScheduleGroupMember() throws Exception {
		ezCommonDAO.addMemberDeptIdScheduleGroupMember();
	}
	
	@Override
	public void addMemberDeptIdScheduleGatherMember() throws Exception {
		ezCommonDAO.addMemberDeptIdScheduleGatherMember();
	}
    
    @Override
    public void createTblBoardStarRating() throws Exception {
        ezCommonDAO.createTblBoardStarRating();
    }
    
	@Override
	public void createMealPlanTable() throws Exception {
		ezCommonDAO.createMealPlanTable();
	}

	@Override
	public void insertMealPlanTenantConfig() throws Exception {
		List<TenantVO> tenantIdList = ezCommonDAO.getTenantList();
		
		for (TenantVO tenantVo : tenantIdList) {
			
			ezCommonDAO.insertMealPlanTenantConfig(tenantVo.getTenantId());
			ezCommonDAO.insertMealPlanBoardInfo(tenantVo.getTenantId());
		}
	}

    @Override
    public void createTblStatMenu() {
        ezCommonDAO.createTblStatMenu();
    }

    public void insertUseSaasYN() {
        ezCommonDAO.insertUseSaasYN();
    }

    @Override
    public void inserExtLargeFilesever() {
        ezCommonDAO.inserExtLargeFilesever();
    }
}
