package egovframework.ezEKP.ezCommon.service.impl;

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
import java.net.URLEncoder;
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
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import javax.annotation.Resource;
import javax.net.ssl.*;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DeadlockLoserDataAccessException;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGKlibService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezCommon.dao.EzCommonDAO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommon.vo.ApprovPWDVO;
import egovframework.ezEKP.ezCommon.vo.CompanyInfoVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.vo.CountryVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.vo.TenantServerNameVO;
import egovframework.let.user.login.vo.TenantVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.KlibUtil;

import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DeadlockLoserDataAccessException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.net.ssl.*;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.*;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.SecureRandom;
import java.security.cert.X509Certificate;
import java.util.*;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

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

	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;

	@Resource(name = "EzSystemAdminService")
	private EzSystemAdminService ezSystemAdminService;

	@Resource(name = "EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
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

        Elements elements = document.getElementsByTag("img");
        if (!elements.isEmpty()) {
            for (Element element : elements) {
                imgSrcs.add(element.attr("src"));
            }
        }

        imgSrcs = imgSrcs.stream().distinct().collect(Collectors.toList());

        logger.debug("extractImageSource ended.");

        return imgSrcs;
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

        for(String imgSrc : imgSrcs) {
            String contentType = "application/octet-stream";
            String extension = ".gif"; //기존확장자가.gif로고정되어있었으므로,디폴트로사용함

            InputStream tempIn = null;
            try {
            	if(imgSrc.contains("222.106.242.180")){
            		continue;
            	}else{
            		contentType = URLConnection.guessContentTypeFromStream(Files.newInputStream(Paths.get(realPath + imgSrc)));
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
            tempHtml = Pattern.compile(imgSrc).matcher(tempHtml).replaceAll("file:///C:/IMAGE" + (imgSrcs.indexOf(imgSrc) + 1) + extension);

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
                        sc.init(null, trustAllCerts, new java.security.SecureRandom());
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());

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
                    e.printStackTrace();
                }
            } else {
                try {
                    in = new FileInputStream(realPath + imgSrc);
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

                byteOutStream.close();

                imagesBuilder.append(strImageData + commonUtil.CRLF);
                imagesBuilder.append("--" + m_strBoundary);
            } catch (Exception e) {
                logger.debug(e.getMessage());
            } finally {
                if (in != null) {
                    in.close();
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
                e.printStackTrace();
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
                        sc.init(null, trustAllCerts, new java.security.SecureRandom());
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());

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
                    e.printStackTrace();
                }
            } else {
                try {
                    in = new FileInputStream(realPath + backgroundImgSrc);
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
        File file = new File(filePath);

        if (!file.exists()) {
        	file.mkdir();
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
				logger.debug("m_Mimechunk="+m_Mimechunk);
				
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
        	file.mkdir();
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
			e.printStackTrace();
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

		logger.debug("PROPERTY NAME : " + property + "||" + "TENANTID : " + tenantID);
		logger.debug("PROPERTY VALUE : " + propertyValue);

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
		String proValue = getUserConfigInfo(tenantID, userID, "prevPwd");
		
		if (!proValue.isEmpty()) {
			return updateUserConfigInfo(tenantID, userID, "prevPwd", propertyValue);
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
	public void createTblCompanyConfig() throws Exception {
		ezCommonDAO.createTblCompanyConfig();
	}

	@Override
	public void createReformFlagColumn() throws Exception {
		ezCommonDAO.createReformFlagColumn();
	}
	
	@Override
	public String getCompanyConfig(int tenantID, String companyID, String property) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
        map.put("property", property.toUpperCase());
        map.put("companyID", companyID);
        map.put("tenantID", tenantID);

        String propertyValue = ezCommonDAO.getCompanyConfig(map);

		logger.debug("PROPERTY NAME : " + property + "||" + "TENANTID : " + tenantID + "||" + "COMPANYID : " + companyID);
		logger.debug("PROPERTY VALUE : " + propertyValue);

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

		logger.debug("PROPERTY NAME : " + propertyName + "||" + "TENANTID : " + tenantId + "||" + "COMPANYID : " + companyId);
		logger.debug("PROPERTY VALUE : " + propertyValue);

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

		logger.debug("PROPERTY NAME : " + propertyName + "||" + "TENANTID : " + tenantId + "||" + "COMPANYID : " + companyId);
		logger.debug("PROPERTY VALUE : " + propertyValue);

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
	public void addMailToJMochaDistribution() throws Exception {
		ezCommonDAO.addMailToJMochaDistribution();
	}

	@Override
	public void addAddJobMasterOrderBy() throws Exception {
		ezCommonDAO.addAddJobMasterOrderBy();
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
	public void addUserMasterManualFlag() throws Exception {
		ezCommonDAO.addUserMasterManualFlag();
	}

	@Override
	public void addDeptMasterManualFlag() throws Exception {
		ezCommonDAO.addDeptMasterManualFlag();
	}

	@Override
	public void addAddJobMasterManualFlag() throws Exception {
		ezCommonDAO.addAddJobMasterManualFlag();
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
	public void addJobMasterJobID() throws Exception {
		ezCommonDAO.addJobMasterJobID();
	}

	@Override
	public void createWebfolderToken() throws Exception {
		ezCommonDAO.createWebfolderToken();

	}

	@Override
	public void addUserMasterPasswordUpdateDT() throws Exception {
		ezCommonDAO.addUserMasterPasswordUpdateDT();
	}

	@Override
	public void addUserMasterPhotoUpdateDT() throws Exception {
		ezCommonDAO.addUserMasterPhotoUpdateDT();
	}

	@Override
	public void addJmochaMailGenenalPreviewMailImage() throws Exception {
		ezCommonDAO.addJmochaMailGenenalPreviewMailImage();
	}
	
	@Override
	public void addPortalThemePortletIsFixed() throws Exception {
		ezCommonDAO.addPortalThemePortletIsFixed();
	}
	
	@Override
	public void addUserMasterMailBoxQuota() throws Exception {
		ezCommonDAO.addUserMasterMailBoxQuota();
	}

	@Override
	public void addHolidayFlag() throws Exception {
		ezCommonDAO.addHolidayFlag();
	}
	
	@Override
	public void createPortalThemePortlet() throws Exception {
		ezCommonDAO.createPortalThemePortlet();
	}
	
	@Override
	public void addHolidayRepeat() throws Exception {
		ezCommonDAO.addHolidayFlag();
	}
	
	@Override
	public void insertPortalThemePortletInitdata() throws Exception {
		ezCommonDAO.insertPortalThemePortletInitdata();
	}
	
	@Override
	public void addJournalFormDelFlag() throws Exception {
		ezCommonDAO.addJournalFormDelFlag();
	}

	@Override
	public void updateTaskUrl() throws Exception {
		ezCommonDAO.updateTaskUrl();
	}

	@Override
	public void addPortalPortletUserPortletUsed() throws Exception {
		ezCommonDAO.addPortalPortletUserPortletUsed();
		
	}

	@Override
	public void addPortalPortletUserThemeId() throws Exception {
		ezCommonDAO.addPortalPortletUserThemeId();
		
	}

	@Override
	public void addTblPortalThemeUserIsDefault() throws Exception {
        ezCommonDAO.addTblPortalThemeUserIsDefault();
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
	public void addBoardLikeFlag() throws Exception{
		ezCommonDAO.addBoardLikeFlag();
	}
	
	public void addMsgInMailSearch() throws Exception {
		ezCommonDAO.addMsgInMailSearch();
	}

	@Override
	public void addQuickLinkLinkOrder() throws Exception {
		ezCommonDAO.addQuickLinkLinkOrder();
	}

	@Override
	public void addComCloseCompanyId() throws Exception {
		ezCommonDAO.addComCloseCompanyId();
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
	public void addSurveyAlamColums() throws Exception {
		ezCommonDAO.addSurveyAlamColums();
	}

	@Override
	public void addFormVersion() throws Exception {
		ezCommonDAO.addFormVersion();
	}

	@Override
	public void addAddJobMasterProxy() throws Exception {
		ezCommonDAO.addAddJobMasterProxy();
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
	public void addThemeContentLang() throws Exception {
		ezCommonDAO.addThemeContent2();
		ezCommonDAO.addThemeContent3();
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
	public void addSnMenuAuth() throws Exception {
		ezCommonDAO.addSnMenuAuth();
	}
	
	@Override
	public void createTblShareDocDir() throws Exception {
		ezCommonDAO.createTblShareDocDir();
	}
	
	@Override
	public void addBoardManageTypeColumn() throws Exception {
		ezCommonDAO.addBoardManageTypeColumn();
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
	public void addSurveyMailSentFlagColumn() throws Exception {
		ezCommonDAO.addSurveyMailSentFlagColumn();
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
	public void addSnThemeAndPortletAuth() throws Exception {
		ezCommonDAO.addSnThemeAuth();
		ezCommonDAO.addSnPortletAuth();
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
	public void addOpenGovFlag() throws Exception {
        ezCommonDAO.addOpenGovFlag();
    }

	@Override
	public int checkDeptId(String userID, String deptID, String tenantId) {
		logger.debug("checkDeptId started");
		int result = 0;
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("tenantID", tenantId);
		map.put("deptID", deptID);
		map.put("userID", userID);
		result= ezCommonDAO.checkDeptId(map);
		logger.debug("checkDeptId ended");
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
		logger.debug("insertTest started");
		Map<String, Map<String, Object>> test = new HashMap<String,  Map<String, Object>>();
		test.put("mailConfirm", new HashMap<String, Object>(){{
			put("tenantID", 0);
			put("confName","useMailConfirm"); // property_name
			put("property_value","NO");
			put("config_name","메일 완료/완료취소");
			put("regdate","2020-01-28 00:00:00");
			put("description","메일 완료/완료취소 기능 사용 여부(default: NO)");
			put("config_type","메일");
			put("property","USEMAILCONFIRM"); // property_name
		}});
		test.put("UseAutoDeleteOfRetireUser", new HashMap<String, Object>(){{
			put("tenantID", 0);
			put("confName","UseAutoDeleteOfRetireUser"); // property_name
			put("property_value","NO");
			put("config_name","퇴직자 자동삭제");
			put("regdate","2020-09-14 00:00:00");
			put("description","n일 이후 퇴직자 자동삭제 사용여부(default: NO)");
			put("config_type","조직도");
			put("property","USEAUTODELETEOFRETIREUSER"); // property_name
		}});
		test.put("autoDeleteOfRetireUserLimit", new HashMap<String, Object>(){{
			put("tenantID", 0);
			put("confName","autoDeleteOfRetireUserLimit"); // property_name
			put("property_value","0");
			put("config_name","퇴직자 자동삭제 ");
			put("regdate","2020-09-14 00:00:00");
			put("description","n일 이후 퇴직자 자동삭제 : n일 설정(default: 0, 0=사용안함)");
			put("config_type","조직도");
			put("property","AUTODELETEOFRETIREUSERLIMIT"); // property_name
		}});
		test.put("useExternalMailServerAddress", new HashMap<String, Object>(){{
			put("tenantID", 0);
			put("confName","useExternalMailServerAddress"); // property_name
			put("property_value","0.0.0.0");
			put("config_name","외부메일 서버 주소 ");
			put("regdate","2020-09-29 00:00:00");
			put("description","외부메일 서버 주소 (default:0.0.0.0)");
			put("config_type","메일");
			put("property","USEEXTERNALMAILSERVERADDRESS"); // property_name
		}});
		test.put("useExternalMailServerAuth", new HashMap<String, Object>(){{
			put("tenantID", 0);
			put("confName","useExternalMailServerAuth"); // property_name
			put("property_value","NO");
			put("config_name","외부메일 서버 인증 사용여부");
			put("regdate","2020-09-29 00:00:00");
			put("description","외부메일 서버 인증 사용여부(default: NO)");
			put("config_type","메일");
			put("property","USEEXTERNALMAILSERVERAUTH"); // property_name
		}});
		test.put("useExternalMailServerUserId", new HashMap<String, Object>(){{
			put("tenantID", 0);
			put("confName","useExternalMailServerUserId"); // property_name
			put("property_value","authId");
			put("config_name","외부메일 서버 인증 id (ex: test@test.com)");
			put("regdate","2020-09-29 00:00:00");
			put("description","외부메일 서버 인증 id");
			put("config_type","메일");
			put("property","USEEXTERNALMAILSERVERUSERID"); // property_name
		}});
		test.put("useExternalMailServerUserPw", new HashMap<String, Object>(){{
			put("tenantID", 0);
			put("confName","useExternalMailServerUserPw"); // property_name
			put("property_value","authPw");
			put("config_name","외부메일 서버 인증 pass");
			put("regdate","2020-09-29 00:00:00");
			put("description","외부메일 서버 인증 pass (ex: password123)");
			put("config_type","메일");
			put("property","USEEXTERNALMAILSERVERUSERPW"); // property_name
		}});
		test.put("useExternalMailServerPort", new HashMap<String, Object>(){{
			put("tenantID", 0);
			put("confName","useExternalMailServerPort"); // property_name
			put("property_value","25");
			put("config_name","외부메일 서버  smtp 포트 ");
			put("regdate","2021-03-29 00:00:00");
			put("description","외부메일 서버 smtp 포트 (deafult:25)");
			put("config_type","메일");
			put("property","USEEXTERNALMAILSERVERPORT"); // property_name
		}});
		test.put("useDeleteMailBlob", new HashMap<String, Object>(){{
			put("tenantID", 0);
			put("confName","useDeleteMailBlob"); // property_name
			put("property_value","YES");
			put("config_name","메일 blob 삭제 스케줄러 사용여부");
			put("regdate","2021-02-19 00:00:00");
			put("description","메일 blob 삭제 스케줄러 사용여부 (default:YES)");
			put("config_type","메일");
			put("property","USEDELETEMAILBLOB"); // property_name
		}});
		test.put("useOrgListCheckBox", new HashMap<String, Object>(){{
			put("tenantID", 0);
			put("confName","useOrgListCheckBox"); // property_name
			put("property_value","NO");
			put("config_name","조직도 리스트 체크박스 표시");
			put("regdate","2021-11-10 00:00:00");
			put("description","조직도 리스트 체크박스 표시 (메일,주소록) (default:NO)");
			put("config_type","메일");
			put("property","USEORGLISTCHECKBOX"); // property_name
		}});
		test.put("adminIpAccess", new HashMap<String, Object>(){{
			put("tenantID", 0);
			put("confName","useAdminIPAccess"); // property_name
			put("property_value","NO");
			put("config_name","관리자 IP 제한");
			put("regdate","2020-04-27 00:00:00");
			put("description","관리자 페이지 IP 제한(default: NO)");
			put("config_type","시스템");
			put("property","USEADMINIPACCESS"); // property_name (UPPER 조건 처리를 위하여 대문자로 전달)
		}});
		
		Iterator<String> keys = test.keySet().iterator();
        while( keys.hasNext() ){
        	try {
				String key = keys.next();
				ezCommonDAO.insertTblTenantConfig(test.get(key));
			} catch (Exception e) {
				e.printStackTrace();
			}
           
        }
	}

	@SuppressWarnings("serial")
	@Override
	public void alter_AnyTbl_AnyColumns() throws Exception {
		logger.debug("alter_AnyTbl_AnyColumns started");
		List<Map<String, Object>> test = new ArrayList<Map<String, Object>>();
		// JAMES_MAIL_SEARCH
		test.add(new HashMap<String, Object>(){{ put("TBL_NAME","JAMES_MAIL_SEARCH"); put("COLUMN_NAME", "SECURE_FLAG"); put("ALTER", "ADD");
												 put("TYPE_MYSQL", "int(1)"); put("TYPE_ORACLE", "NUMBER"); put("TYPE_TIBERO", "NUMBER"); put("AFTER", "DEFAULT 0"); }});

		// TBL_USERMASTER
		test.add(new HashMap<String, Object>(){{ put("TBL_NAME","TBL_USERMASTER"); put("COLUMN_NAME", "CREATEDT"); put("ALTER", "ADD"); 
												 put("TYPE_MYSQL", "DATETIME"); put("TYPE_ORACLE", "DATE"); put("TYPE_TIBERO", "DATE"); put("AFTER", "DEFAULT NULL"); }});

		// TBL_DEPTMASTER
		test.add(new HashMap<String, Object>(){{ put("TBL_NAME","TBL_DEPTMASTER"); put("COLUMN_NAME", "CREATEDT"); put("ALTER", "ADD"); 
												 put("TYPE_MYSQL", "DATETIME"); put("TYPE_ORACLE", "DATE"); put("TYPE_TIBERO", "DATE"); put("AFTER", "DEFAULT NULL"); }});

		for (Map<String, Object> map : test) {
			ezCommonDAO.alter_AnyTbl_AnyColumns(map);
        }
		logger.debug("alter_AnyTbl_AnyColumns ended");
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
	
	@Override
	public void addIsBeforeDoc() throws Exception {
		ezCommonDAO.addIsBeforeDoc();
	}

	@Override
	public void addBeforeDocUrl() throws Exception {
		ezCommonDAO.addBeforeDocUrl();
	}
	
	@SuppressWarnings("serial")
	@Override
	public void setCompanyConfigs()  throws Exception {
		logger.debug("setCompanyConfigs started.");
		List<Map<String, String>> list = new ArrayList<Map<String,String>>();
		list.add(new HashMap<String, String>(){{ put("name","ExpirePassPeriod"); put("value","0"); }});
		list.add(new HashMap<String, String>(){{ put("name","MaxAllowedCountOfLoginFail"); put("value","0"); }});
		list.add(new HashMap<String, String>(){{ put("name","UsePasswordPatternPolicy"); put("value","NO"); }});
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
	public void addAprAttachViewOrder() throws Exception {
		ezCommonDAO.addAprAttachViewOrder();
	}
	
	@Override
	public void addAprEndAttachViewOrder() throws Exception {
		ezCommonDAO.addAprEndAttachViewOrder();
	}
	
	@Override
	public void addAprTmpAttachViewOrder() throws Exception {
		ezCommonDAO.addAprTmpAttachViewOrder();
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
	public void addFormAprOptionColumn() throws Exception {
		ezCommonDAO.addFormAprOptionColumn();
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
    public void addDocStateIntoLastLines() throws Exception {
	    ezCommonDAO.addDocStateIntoLastLines();
    }

    @Override
    public void addDocStateIntoLastDeptLines() throws Exception {
	    ezCommonDAO.addDocStateIntoLastDeptLines();
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
	public void insertDailyWorkAttitudeColumn() throws Exception {
		// 일근무/반근무 기능 관련 컬럼 추가(tbl_attitude -> WORK_STATUS)
		ezCommonDAO.insertDailyWorkAttitudeColumn();
	}
	
	public void alterTblPsApprovNotiMailConf() throws Exception {
		ezCommonDAO.alterTblPsApprovNotiMailConf();
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
	
	/* 2020-08-13 홍승비 - 양식옵션 > 기결재통과 플래그 추가 */
	@Override
	public void addPassAprLineFlag() throws Exception {
		ezCommonDAO.addPassAprLineFlagColumn();
	}
	
    @Override
    public void addFormSihangTypeColumn() throws Exception {
        ezCommonDAO.addFormSihangTypeColumn();
    }
    
    @Override
    public void insertAutoSendOfferFlag() throws Exception {
        ezCommonDAO.insertAutoSendOfferFlag();
    }

	@Override
	public void insertTabBoardPortlet() throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("portletCode", "tabBoard");
		
		if ( ezCommonDAO.checkPortletCodeString(map) > 0) {
			return;
		}
		
		logger.debug("insertTabBoardPortlet started");
		
		List<CompanyInfoVO> companyList = ezCommonDAO.getAllCompanyIds();
		map.put("portletId", ezCommonDAO.getNewPortletId());
		map.put("portletName1", "탭게시판");
		map.put("portletName2", "tabBoard");
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

	/* 2020-10-19 김은실 - 웹폴더 > 하위부서 허용 여부 추가 */
	@Override
	public void addWebfolderUserSubdeptPermittedColumn() throws Exception {
		ezCommonDAO.addWebfolderUserSubdeptPermittedColumn();
	}
	
	/* 2020-12-08 김은실 - [카이스트] 웹폴더 > 폴더 담당자 추가 */
	@Override
	public void addWebfolderUserFolderManagerColumn() throws Exception {
		ezCommonDAO.addWebfolderUserFolderManagerColumn();
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
	
	/* 2020-11-25 웹폴더 답글 파일 컬럼 추가 */
	@Override
	public void createWebfolderHierarchicalColumns() {
		ezCommonDAO.createWebfolderHierarchicalColumns();
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
    public void alterWebfolderApplyHistoryAddColumn() throws Exception {
    	ezCommonDAO.alterWebfolderApplyHistoryAddColumn();
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
		if (param == ""){
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
			e.printStackTrace();
			status = "ERROR";
		}
		resultJson.put("status", status);
		resultJson.put("downloadPath", downloadPath);
				
		return resultJson;
	}
	
	public void addBoardMailFGColumn() throws Exception {
		ezCommonDAO.addBoardMailFGColumn();
	}
	
	@Override
	public void addCommNoticeUpperNoColumn() throws Exception {
		ezCommonDAO.addCommNoticeUpperNoColumn();
	}

    @Override
    public void alterTblAprReceiptProcessInfoAddColumn() throws Exception {
        ezCommonDAO.alterTblAprReceiptProcessInfoAddColumn();
    }
    
    @Override
    public void alterTblDocDeliveryAddColumn() throws Exception {
        ezCommonDAO.alterTblDocDeliveryAddColumn();
        ezCommonDAO.insertTblCodelistA54002();
    }
    
    @Override
    public void addTblAdminReceiptGroupSubExtReceptYnColumn() throws Exception {
        ezCommonDAO.addTblAdminReceiptGroupSubExtReceptYnColumn();
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
	public void alterTblAddjobMaster() throws Exception {
		ezCommonDAO.alterTblAddjobMaster();
	}
	
	@Override
	public void addCommMailFGColumn() throws Exception {
		ezCommonDAO.addCommMailFGColumn();
	}
	
	@Override
	public void addSurveySubDeptYNColumn() throws Exception {
		ezCommonDAO.addSurveySubDeptYNColumn();
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
	public void addSusinScheduleOffsetColumn() throws Exception {
		ezCommonDAO.addSusinScheduleOffsetColumn();
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
	public void addAprDocGroupInfoTypeColumn() throws Exception {
		ezCommonDAO.addAprDocGroupInfoTypeColumn();
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
		Workbook workbook = new XSSFWorkbook();

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
		int rowSize = data.size();
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

		try {
			fileOut = new FileOutputStream(filePath);
			workbook.write(fileOut);
			fileOut.close();
		}
		catch (Exception e) {
			throw e;
		}
		finally {
			if (fileOut != null) fileOut.close();
			workbook.close();
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
}
