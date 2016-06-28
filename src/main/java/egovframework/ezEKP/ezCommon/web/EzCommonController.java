package egovframework.ezEKP.ezCommon.web;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.InputStream;
import java.net.URL;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.Random;
import java.util.UUID;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.util.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/** 
 * @Description [Controller] 공통
 * @author 오픈솔루션팀 황윤진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.14    황윤진    신규작성
 *
 * @see
 */
@Controller
public class EzCommonController extends EgovFileMngUtil{
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private Properties globals;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@RequestMapping(value = "/ezCommon/manyColor.do")
	public String manyColor(HttpServletRequest request, ModelMap model) throws Exception{		
		return "ezCommon/manyColor";
	}
	
	/**
	 * 게시판 html -> mht 변환 표출 Method
	 */
	@RequestMapping(value = "/ezCommon/htmlToMHT.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String htmlToMHT(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
        String strHTML = "";
        String realPath = request.getServletContext().getRealPath("");
        
        if (request.getParameter("strHTML") != null) {
        	strHTML = request.getParameter("strHTML");
        	strHTML = URLDecoder.decode(strHTML, "utf-8");
        }
        
        String scheme = "http://";
    	if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
    		scheme = "https://";
    	}
        
        //ezEmail 관련 부분이라 스킵 exchange 관련소스 많음
//        while (strHTML.indexOf("src=\"http") > 0)
//        {
//            int pos1 = strHTML.indexOf("src=\"http") + 5;
//            int pos2 = strHTML.substring(pos1).indexOf("\"");
//            String imgurlOrg = strHTML.substring(pos1, pos2);
//            if (imgurlOrg.indexOf("ezEmail") > 0) {
//                string Imgurl = ImgurlOrg.Replace(@"&amp;", @"&");
//                string ConverImgurl = MailContentDownload(Imgurl);
//                ConverImgurl = "replace_"+scheme + HttpContext.Current.Request.Url.Host + ConverImgurl;
//                strHTML = strHTML.Replace(ImgurlOrg, ConverImgurl);
//            }
//            else
//            {
//                break;
//            }
//        }
        strHTML = strHTML.replace("replace_" + scheme, scheme);

        // reform 리폼관련 
//        if (strHTML.IndexOf("__reform_data_bind_list") > -1) {
//            HTMLDocument iDoc = new HTMLDocument();
//            iDoc.designMode = "on";
//            object[] oPageText = { strHTML };
//            IHTMLDocument2 doc = (IHTMLDocument2)iDoc;
//            doc.write(oPageText);
//
//            IHTMLElement dataBindControlListElement = iDoc.getElementById("__reform_data_bind_list");
//            if (dataBindControlListElement != null)
//            {
//                string dataBindControlListElementValue = (string)dataBindControlListElement.getAttribute("value");
//                JArray dataBindControlList = JArray.Parse(dataBindControlListElementValue);
//                foreach (string item in dataBindControlList)
//                {
//                    IHTMLElement dataBindControl = iDoc.getElementById(item);
//                    if (dataBindControl != null)
//                    {
//                        string dataBindControlValue = (string)dataBindControl.getAttribute("value");
//                        JObject dataBindControlValueObject = JObject.Parse(dataBindControlValue);
//                        string sqlQuery = dataBindControlValueObject["sql"].ToString();
//                        sqlQuery = EncryptionHelper.getInstance().Decrypt(sqlQuery);
//                        dataBindControlValueObject["sql"] = sqlQuery;
//                        dataBindControl.setAttribute("value", dataBindControlValueObject.ToString());
//                    }
//                }
//                strHTML = iDoc.documentElement.outerHTML;
//            }
//
//            System.Runtime.InteropServices.Marshal.ReleaseComObject(doc);
//        }
        // reform - end
        String mhtData = startHtml2Mht(strHTML, realPath);
        
        return mhtData;
	}
	
	/**
	 * 게시판 mht -> html 변환 표출 Method
	 */
	@RequestMapping(value = "/ezCommon/mhtToHTMLContent.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String mhtToHTMLContent(HttpServletRequest request) throws Exception{
		String itemID = "";
		String type = "";
		String realPath = request.getServletContext().getRealPath("");
		String strResult = "";
		
		itemID = request.getParameter("itemID");
		type = request.getParameter("type");
		strResult = getMHTtoHTML(type, itemID, realPath);
		
		return strResult;
	}
	
	/**
	 * 게시판 html -> mht 변환 표출 Method
	 */
	@RequestMapping(value = "/ezCommon/mhtToHTML.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String mhtToHTML(HttpServletRequest request) throws Exception{
		String filePath = "";
        String uploadModule = config.getProperty("config.LocalPath");
        String realPath = request.getServletContext().getRealPath("");
        String strURL = request.getParameter("strURL");
        
        filePath = realPath + uploadModule;
        
        File file = new File(filePath);
        if (!file.exists()) {
        	file.mkdir();
        }
        String m_strMHT = "";
        
        try {
        	m_strMHT = loadMHTFile(realPath + strURL);
        	m_strMHT = m_strMHT.replace("&lt;", "<").replace("&lt;", "<").replace("&gt;", ">").replace("&quot;", "\"").replace("&apos;", "\'");
		} catch (Exception e) {
			m_strMHT= "";
		}
        
        String result = "";
        String strHTML = startMHT2HTML(filePath, m_strMHT, filePath);

        if (strHTML.indexOf("error") > -1) {
        	strHTML = commonUtil.cleanValue(strHTML);
        } else {
        	if (strHTML.indexOf("<BODY") > -1) {
        		strHTML = commonUtil.cleanValue(strHTML.substring(strHTML.indexOf("<BODY>") + 6, strHTML.indexOf("</BODY>")));
        		result = "<BODYDATA>" + strHTML + "</BODYDATA>";
        	} else {
        		strHTML = commonUtil.cleanValue(strHTML.substring(strHTML.indexOf("<body"), strHTML.indexOf("</body>") + 7));
        		
        		String attribute = "orgdocnum";
				StringBuffer sb = new StringBuffer();
				
				sb.append("<NODE>");
				sb.append("<NODENAME>" + attribute + "</NODENAME>");
				sb.append("<NODEVALUE>" + strHTML.substring(strHTML.indexOf("\"", strHTML.indexOf(attribute)) + 1, strHTML.indexOf("\"", strHTML.indexOf("\"", strHTML.indexOf(attribute)) + 1)) + "</NODEVALUE>");
				
				attribute = "formid";
				
				sb.append("<NODENAME>" + attribute + "</NODENAME>");
				sb.append("<NODEVALUE>" + strHTML.substring(strHTML.indexOf("\"", strHTML.indexOf(attribute)) + 1, strHTML.indexOf("\"", strHTML.indexOf("\"", strHTML.indexOf(attribute)) + 1)) + "</NODEVALUE>");
				sb.append("</NODE>");
				
        		result = "<?xml version=\"1.0\" encoding=\"utf-8\" ?><ROOT><BODYATTS>" + commonUtil.cleanValue(sb.toString()) + "</BODYATTS>" + "<BODYDATA>" + strHTML + "</BODYDATA></ROOT>";
        	}
        }
        
		return result;
	}
	
	/**
	 * 게시판 ck에디터 이미지 업로드 호출 Method
	 */
	@RequestMapping(value = "/ezCommon/ckImageUpload.do")
	public String ckImageUpload() {
		return "ezCommon/ckImageUpload";
	}
	
	/**
	 * 게시판 ck에디터 업로드 화면 호출 Method
	 */
	@RequestMapping(value = "/ezCommon/ckUpload.do")
	public String ckUpload(MultipartHttpServletRequest request, Model model) throws Exception{
		MultipartFile multiFile = request.getFile("file1");
		String fileType = multiFile.getContentType().replace("\\", "/").split("/")[1];
		String filePath = config.getProperty("upload_common.ROOT");
		String realPath = request.getServletContext().getRealPath("");
		String today = EgovDateUtil.getToday("");
		String fileName = UUID.randomUUID() + "." + fileType;
		
		filePath = filePath + commonUtil.separator + today;
		File file = new File(realPath + filePath);
        if (!file.exists()) {
        	file.mkdirs();
        }
        
        int width = 0;
		int height = 0;
		
		writeUploadedFile(multiFile, fileName, realPath + filePath);
		
		File imageFile = new File(realPath + filePath + commonUtil.separator + fileName);			
	
		if (imageFile.exists()) {			
			BufferedImage bi = ImageIO.read(new File(realPath + filePath + commonUtil.separator + fileName));			    
			width = bi.getWidth();
			height = bi.getHeight();
		}
		
		model.addAttribute("imgPath", (filePath + commonUtil.separator + fileName +  "|!|" + width + "|!|" + height).replace("\\", "/"));
		
		return "ezCommon/ckUpload";
	}

	/**
	 * 게시판 ck에디터 심플업로드화면 호출 Method
	 */
	@RequestMapping(value = "/ezCommon/ckSimpleUpload.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String ckSimpleUpload(MultipartHttpServletRequest request, Model model) throws Exception{
		MultipartFile multiFile = request.getFile("upload");
		String fileType = multiFile.getContentType().replace("\\", "/").split("/")[1];
		String filePath = config.getProperty("upload_common.ROOT");
		String realPath = request.getServletContext().getRealPath("");
		String today = EgovDateUtil.getToday("");
		String fileName = UUID.randomUUID() + "." + fileType;
		
		filePath = filePath + commonUtil.separator + today;
		File file = new File(realPath + filePath);
		
        if (!file.exists()) {
        	file.mkdirs();
        }
        
		writeUploadedFile(multiFile, fileName, realPath + filePath);
		
		return "<script>window.parent.CKEDITOR.tools.callFunction(2, '" + (filePath + commonUtil.separator + fileName).replace("\\", "/") + "', '')</script>";
	}
	
	/**
	 * 게시판 html -> mht 변환 실행 Method
	 */
	public String startHtml2Mht(String m_strHTML, String realPath) throws Exception{
		StringBuilder m_strMHT = new StringBuilder();
		String[] strHtml = {m_strHTML};
		String m_strBoundary = "";
		String[] m_ImageList = null;
		String[] m_BackImageList = null;
		
        if (strHtml[0] != "") {
            //MHT 헤더 생성.
        	m_strBoundary = makeHeader(m_strMHT);
        	//이미지 경로 추출 및 가상경로 매칭.
        	m_ImageList = extractImageSource(strHtml);
            //백그라운드 경로 추출 및 가상경로 매칭
        	m_BackImageList = extractBackgroundSource(strHtml, m_ImageList);
            //본문 인코딩
        	doHtmlEncoding(strHtml[0], m_strMHT, m_strBoundary);
            //이미지 인코딩
            if (m_ImageList != null) {
            	doImageEncoding(m_ImageList, m_strMHT, m_strBoundary, realPath);
            }
            //백그라운드 인코딩
            if (m_BackImageList != null) {
            	doBackgrondEncding(m_ImageList, m_BackImageList, m_strMHT, m_strBoundary);
            }

            m_strMHT.append("--" + System.lineSeparator());
            
            return m_strMHT.toString();
        } else {
        	return egovMessageSource.getMessage("main.t0603", new Locale(globals.getProperty("Globals.language")));
        }
    }

	/**
	 * 게시판 html -> mht 변환 헤더설정 표출 Method
	 */
	private String makeHeader(StringBuilder m_strMHT) throws Exception{
		String m_strBoundary = createBoundary();
        m_strMHT.append("MIME-Version: 1.0" + System.lineSeparator());
        m_strMHT.append("Content-Type: Multipart/related;" + System.lineSeparator());
        m_strMHT.append("  boundary=\"" + m_strBoundary + "\"" + System.lineSeparator());
        m_strMHT.append("From: Kaoni MHT Component(UTF-8)" + System.lineSeparator());
        m_strMHT.append("Subject:  HTML to Mime-HTML" + System.lineSeparator());
        m_strMHT.append("Date: " + getDate() + System.lineSeparator());
        m_strMHT.append(System.lineSeparator() + System.lineSeparator());
        
        return m_strBoundary;
    }
	
	/**
	 * 게시판 boundary 생성 표출 Method
	 */
	private String createBoundary() throws Exception{
        String strBoundary = "Boundary-=_";
        Random Rnd = new Random();

        while (strBoundary.length() < 39) {
            int nch = Rnd.nextInt(9)+1; 

            if (nch < 26) {
                strBoundary += (char)(65 + nch);
            } else {
                strBoundary += (char)(97 + nch - 26);
            }
        }
        return strBoundary;
    }
	
	/**
	 * 게시판 날짜반환 표출 Method
	 */
	private String getDate() throws Exception{
        Calendar calendar = Calendar.getInstance();
        
        String strDate = "";
        String strweek = "";
        String strMonth = "";
        String amPm = "";
        
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
        if (calendar.get(Calendar.AM_PM) == 1) {
        	amPm = "PM";
        } else {
        	amPm = "AM";
        }
	
        strDate = strweek + ", " + calendar.get(Calendar.DATE) + " " + strMonth + " " + calendar.get(Calendar.YEAR) + " " + amPm + " " + calendar.get(Calendar.HOUR)+":"+calendar.get(Calendar.MINUTE)+":"+calendar.get(Calendar.SECOND);

        return strDate;
    }
	
	/**
	 * 게시판 html -> mht 변환 이미지추출 표출 Method
	 */
	private String[] extractImageSource(String[] strHtml) throws Exception{
		int npos = 0, nposStart = 0, nposEnd = 0, nImgCount = 0;
        String strTempHtml = strHtml[0].toLowerCase();
        String strImgsrc = "";
        String strTempList[] = null;
        String m_ImageList[] = null;
        
        //Img 태그의 갯수를 알아낸다.
        while (true) {
            npos = strTempHtml.indexOf("<img", npos);
            if (npos > 0) {
                nposStart = strTempHtml.indexOf(" src=", npos + 4);
                if (nposStart > 0) {
                    nposEnd = strTempHtml.indexOf("\"", nposStart + 6);
                    if ((nposEnd - nposStart - 6) > 0) {
                        npos = nposEnd;
                        nImgCount++;
                    } else {
                        npos = npos + 4;
                    }
                } else {
                    npos = npos + 4;
                }
            } else {
            	break;
            }
        }

        //소스에서 image src를 추출
        if (nImgCount > 0) {
            //m_ImageList = new string[nImgCount];
            strTempList = new String[nImgCount];
            int i = 0;
            npos = 0;
            while (true) {
                npos = strTempHtml.indexOf("<img", npos);
                if (npos > 0) {
                    nposStart = strTempHtml.indexOf(" src=", npos + 4);
                    if (nposStart > 0) {
                        nposEnd = strTempHtml.indexOf("\"", nposStart + 6);
                        if ((nposEnd - nposStart - 6) > 0) {
                            strImgsrc = strHtml[0].substring(nposStart + 6, nposEnd);
                            npos = nposEnd;
                            strTempList[i] = strImgsrc;
                            i++;
                        } else {
                            npos = npos + 4;
                        }
                    } else {
                        npos = npos + 4;
                    }
                } else {
                	break;
                }
            }

            //중복된 이미지 경로를 걸러낸다.
            nImgCount = 0;
            boolean isSameUrl = false;
            String strtempResource = "";
            //if (strTempList != null)
            //{

            for (int j = 0; j < strTempList.length; j++) {
                strtempResource = strTempList[j];
                for (int k = 0; k < j; k++) {
                    if (j != k && strTempList[k].equals(strtempResource)) {
                        isSameUrl = true;
                    }
                }

                if (isSameUrl == false) {
                    nImgCount++;
                }
                else{
                	isSameUrl = false;
                }
            }

            if (nImgCount > 0) {
                m_ImageList = new String[nImgCount];
                strtempResource = "";
                nImgCount = 0;
                for (int j = 0; j < strTempList.length; j++) {
                    strtempResource = strTempList[j];
                    for (int k = 0; k < j; k++) {
                        if (j != k && strTempList[k].equals(strtempResource)) {
                            isSameUrl = true;
                        }
                    }

                    if (isSameUrl == false) {
                        m_ImageList[nImgCount] = strtempResource;
                        nImgCount++;
                    } else {
                    	isSameUrl = false;
                    }
                }

                int index = 1;
                for (String strResource : m_ImageList) {
                	strHtml[0] = strHtml[0].replace(strResource, "file:///C:/IMAGE" + index + ".gif");
                    index++;
                }
            }
        }
        return m_ImageList;
    }
	
	/**
	 * 게시판 html -> mht 변환 배경화면추출 표출 Method
	 */
	private String[] extractBackgroundSource(String[] strHtml, String[] m_ImageList) throws Exception{
        String strTempHtml = strHtml[0].toLowerCase();
        int npos = 0, nposStart = 0, nposEnd = 0;
        int nImgCount = 0;
        String strImgsrc = "";
        String m_BackImageList[] = null;
        List<String> L_BackImage = new ArrayList<String>();

        //<body 태그의 Background갯수를 알아낸다.
        while (true) {
            npos = strTempHtml.indexOf("<body", npos);
            if (npos > 0) {
                nposStart = strTempHtml.indexOf(" background=", npos + 5);
                if (nposStart > 0) {
                    nposEnd = strTempHtml.indexOf("\"", nposStart + 13);
                    if ((nposEnd - nposStart - 13) > 0) {
                        strImgsrc = strHtml[0].substring(nposStart + 13, nposEnd - nposStart - 13);
                        L_BackImage.add(strImgsrc);
                        npos = nposEnd;
                    } else {
                        npos = npos + 5;
                    }
                } else {
                    npos = npos + 5;
                }
            } else {
            	break;
            }
        }

        //<table 태그의 Background갯수를 알아낸다.
        npos = 0;
        while (true) {
            npos = strTempHtml.indexOf("<table", npos);
            if (npos > 0) {
                nposStart = strTempHtml.indexOf(" background=", npos + 6);
                if (nposStart > 0) {
                    nposEnd = strTempHtml.indexOf("\"", nposStart + 13);
                    if ((nposEnd - nposStart - 13) > 0) {
                        strImgsrc = strHtml[0].substring(nposStart + 13, nposEnd - nposStart - 13);
                        L_BackImage.add(strImgsrc);
                        npos = nposEnd;
                    } else {
                        npos = npos + 6;
                    }
                } else {
                    npos = npos + 6;
                }
            } else {
            	break;
            }
        }

        //<td 태그의 Background갯수를 알아낸다.
        npos = 0;
        while (true) {
            npos = strTempHtml.indexOf("<td", npos);
            if (npos > 0) {
                nposStart = strTempHtml.indexOf(" background=", npos + 3);
                if (nposStart > 0) {
                    nposEnd = strTempHtml.indexOf("\"", nposStart + 13);
                    if ((nposEnd - nposStart - 13) > 0) {
                        strImgsrc = strHtml[0].substring(nposStart + 13, nposEnd - nposStart - 13);
                        L_BackImage.add(strImgsrc);
                        npos = nposEnd;
                    } else {
                        npos = npos + 3;
                    }
                } else {
                    npos = npos + 3;
                }
            } else {
            	break;
            }
        }

        if (L_BackImage.size() > 1) {
            nImgCount = 0;
            boolean isSameUrl = false;
            String strtempResource = "";
            for (int j = 0; j < L_BackImage.size(); j++) {
                strtempResource = L_BackImage.get(j);
                for (int k = 0; k < j; k++) {
                    if (j != k && L_BackImage.get(k).equals(strtempResource)) {
                        isSameUrl = true;
                    }
                }

                if (isSameUrl == false) {
                    nImgCount++;
                } else {
                	isSameUrl = false;
                }
            }

            if (nImgCount > 0) {
                m_BackImageList = new String[nImgCount];
                strtempResource = "";
                nImgCount = 0;
                for (int j = 0; j < L_BackImage.size(); j++) {
                    strtempResource = L_BackImage.get(j);
                    for (int k = 0; k < j; k++) {
                        if (j != k && L_BackImage.get(k).equals(strtempResource)) {
                            isSameUrl = true;
                        }
                    }

                    if (isSameUrl == false) {
                        m_BackImageList[nImgCount] = strtempResource;
                        nImgCount++;
                    } else {
                    	isSameUrl = false;
                    }
                }
            }
        
            L_BackImage = null;
            int index = 1;
            for (String strResource : m_ImageList) {
            	strHtml[0] = strHtml[0].replace(strResource, "file:///C:/BACKGROUNDIMAGE" + index + ".gif");
                index++;
            }
        }
        
        return m_BackImageList;
    }
	
	/**
	 * 게시판 html -> mht 변환 html 인코딩 실행 Method
	 */
	private void doHtmlEncoding(String strHtml, StringBuilder m_strMHT, String m_strBoundary) throws Exception{
        m_strMHT.append("--" + m_strBoundary + System.lineSeparator());
        m_strMHT.append("Content-Type: Text/HTML" + System.lineSeparator());
        m_strMHT.append("Content-Transfer-Encoding: base64" + System.lineSeparator());
        m_strMHT.append("Content-Location: file://C:" + commonUtil.separator + "test.html" + System.lineSeparator());
        m_strMHT.append(System.lineSeparator());
        
        byte[] arr = strHtml.getBytes("UTF-8");
        String strMhtBase64 = Base64.encodeBase64String(arr);
        
        m_strMHT.append(strMhtBase64 + System.lineSeparator());
        m_strMHT.append("--" + m_strBoundary);
        
    }
	
	/**
	 * 게시판 html -> mht 변환 이미지인코딩 실행 Method
	 * @param realPath 
	 */
	private void doImageEncoding(String[] m_ImageList, StringBuilder m_strMHT, String m_strBoundary, String realPath) throws Exception{
        for (int i = 0; i < m_ImageList.length; i++) {
            m_strMHT.append(System.lineSeparator() + "Content-Type: Image/gif" + System.lineSeparator());
            m_strMHT.append("Content-Transfer-Encoding: base64" + System.lineSeparator());
            m_strMHT.append("Content-Location: file:///C:/IMAGE" + (i + 1) + ".gif" + System.lineSeparator());
            m_strMHT.append(System.lineSeparator());
            //이미지 본문 영역

            String strTemp = m_ImageList[i].substring(0, 4);
            ByteArrayOutputStream byteOutStream = new ByteArrayOutputStream();
            InputStream in = null;
            
            if (strTemp.equals("http")) {
            	URL url = new URL(m_ImageList[i].replace("&amp;", "&"));
            	in = url.openStream();
                int len = 0;
                byte[] buf = new byte[1024];
                
                while ((len = in.read(buf)) != -1) {
                	byteOutStream.write(buf, 0, len);
                }
            } else {
            	try {
            		File file = new File(realPath + m_ImageList[i].replace("&amp;", "&"));
            		in = new FileInputStream(file);
				} catch (Exception e) {
					File file = new File(m_ImageList[i].replace("&amp;", "&"));
					in = new FileInputStream(file);
				}
                int len = 0;
                byte[] buf = new byte[1024];
                
                while ((len = in.read(buf)) != -1) {
                	byteOutStream.write(buf, 0, len);
                }
                if (m_ImageList[i].length() > 1) {
                	try {
                		deleteFile(realPath + m_ImageList[i].replace("&amp;", "&"));
					} catch (Exception e) {
						deleteFile(m_ImageList[i].replace("&amp;", "&"));
					}
                }
            }
            
            in.close();
            byteOutStream.close();
            
            byte[] imageByte = byteOutStream.toByteArray();
            String strImageData = new String(Base64.encodeBase64String(imageByte));
            
            m_strMHT.append(strImageData + System.lineSeparator());
            m_strMHT.append("--" + m_strBoundary);
        }
    }
	
	/**
	 * 게시판 html -> mht 변환 배경화면인코딩 실행 Method
	 */
	private void doBackgrondEncding(String[] m_ImageList, String[] m_BackImageList, StringBuilder m_strMHT, String m_strBoundary) throws Exception{
        for (int i = 0; i < m_BackImageList.length; i++) {
            m_strMHT.append(System.lineSeparator() + "Content-Type: Image/gif" + System.lineSeparator());
            m_strMHT.append("Content-Transfer-Encoding: base64" + System.lineSeparator());
            m_strMHT.append("Content-Location: file:///C:/BACKGROUNDIMAGE" + (i + 1) + ".gif" + System.lineSeparator());
            m_strMHT.append(System.lineSeparator());
            //이미지 본문 영역
            
            ByteArrayOutputStream byteOutStream = new ByteArrayOutputStream();
            InputStream in = null;
            String strTemp = m_BackImageList[i].substring(0, 4);
            
            if (strTemp.equals("http")) {
            	URL url = new URL(m_BackImageList[i].replace("&amp;", "&"));
            	in = url.openStream();
                int len = 0;
                byte[] buf = new byte[1024];
                
                while ((len = in.read(buf)) != -1) {
                	byteOutStream.write(buf, 0, len);
                }
            } else {
            	File file = new File(m_BackImageList[i].replace("&amp;", "&"));
            	in = new FileInputStream(file);
                int len = 0;
                byte[] buf = new byte[1024];
                
                while ((len = in.read(buf)) != -1) {
                	byteOutStream.write(buf, 0, len);
                }
            }
            
            byte[] imageByte = byteOutStream.toByteArray();
            String strImageData = Base64.encodeBase64String(imageByte);
            
            in.close();
            byteOutStream.close();
            
            m_strMHT.append(strImageData + System.lineSeparator());
            m_strMHT.append("--" + m_strBoundary);
        }
    }
	
	/**
	 * 게시판 html -> mht 변환 표출 Method
	 */
	public String getMHTtoHTML(String type, String itemID, String realPath) throws Exception{
        String filePath = "";
        String uploadModule = config.getProperty("config.LocalPath");
        
        //TODO 2016-04-28 community부분 추가
        if (type.equals("COMMUNITYNOTI")) {
			uploadModule = config.getProperty("upload_community.MAINBOARD") +commonUtil.separator;
			
			filePath = realPath + uploadModule;
	        File file = new File(filePath);
	        
	        if (!file.exists()) {
	        	file.mkdir();
	        }
	        
	        String url = ezCommonService.getContentInfo(type, itemID);
	        String m_strMHT = "";
	        
	        try {
	        	//
	        	m_strMHT = loadMHTFile(filePath + url);
			} catch (Exception e) {
				m_strMHT= "";
			}
	        
	        String strHTML = startMHT2HTML(realPath+config.getProperty("config.LocalPath"), m_strMHT, filePath);
	        
	        if (strHTML.trim().length() > 0) {
	        	return strHTML;
	        } else {
	        	return "<HTML><HEAD><TITLE></TITLE><META content=\"text/html; charset=utf-8\" http-equiv=Content-Type><META name=GENERATOR content=\"MSHTML 8.00.7601.17622\"></HEAD><STYLE title=ezform_style_1>P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm; *font-size:x-small; } </STYLE><BODY></BODY></HTML>";
	        }
		} else {
			filePath = realPath + uploadModule;
	        File file = new File(filePath);
	        
	        if (!file.exists()) {
	        	file.mkdir();
	        }
	        
	        String url = ezCommonService.getContentInfo(type, itemID);
	        String m_strMHT = "";
	        
	        try {
	        	m_strMHT = loadMHTFile(realPath + url);
			} catch (Exception e) {
				m_strMHT= "";
			}
	        
	        String strHTML = startMHT2HTML(filePath, m_strMHT, filePath);
	        
	        if (strHTML.trim().length() > 0) {
	        	return strHTML;
	        } else {
	        	return "<HTML><HEAD><TITLE></TITLE><META content=\"text/html; charset=utf-8\" http-equiv=Content-Type><META name=GENERATOR content=\"MSHTML 8.00.7601.17622\"></HEAD><STYLE title=ezform_style_1>P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm; *font-size:x-small; } </STYLE><BODY></BODY></HTML>";
	        }
		}
	}
	
	/**
	 * 게시판 html -> mht 변환 실행 표출 Method
	 */
	public String startMHT2HTML(String m_strLPath, String m_strMHT, String m_strSPath) throws Exception{
		String m_strHTML = "";
		String strBoundary = "";
		String[] m_Mimechunk = null;
		List<String> m_ListImageLocation = new ArrayList<String>();
		List<String> m_ListImageLocalLocation = new ArrayList<String>();
		
		strBoundary = getBoundaryText(m_strMHT);

		if (m_strMHT != null && !m_strMHT.equals("")) {
			if (strBoundary.equals("error")) {
				return egovMessageSource.getMessage("main.t0600", new Locale(globals.getProperty("Globals.language")));
			} else {
				m_Mimechunk = m_strMHT.split(strBoundary);

				for (int i = 1; i < m_Mimechunk.length; i++) {
					String[] strMimeChunk = m_Mimechunk[i].split(System.lineSeparator() + System.lineSeparator());
					String[] strMime_info_p = strMimeChunk[0].trim().split(System.lineSeparator());
					String[] strMime_info_tupe = strMime_info_p[0].split(": ");
					if (strMime_info_tupe[0].equals("Content-Type")) {
						if (strMime_info_tupe[1].equals("Text/HTML")) {
							m_strHTML = doMHTDecoding(strMimeChunk[1].trim(), m_strHTML);
						} else if (strMime_info_tupe[1].equals("Image/gif")) {
							String[] strMime_info_location = strMime_info_p[2].split(": ");
							
							if (strMime_info_location[0].equals("Content-Location")) {
								m_ListImageLocation.add(strMime_info_location[1]);
							}
							m_ListImageLocalLocation.add(doImageDecoding(strMimeChunk[1].trim(), m_strSPath, m_strLPath));
						}
					}
				}

				if (m_ListImageLocation.size() == m_ListImageLocalLocation.size()) {
					for (int i = 0; i < m_ListImageLocation.size(); i++) {
						m_strHTML = m_strHTML.replace(m_ListImageLocation.get(i), m_ListImageLocalLocation.get(i)); 
					}
				} else {
					return egovMessageSource.getMessage("main.t0601", new Locale(globals.getProperty("Globals.language")));
				}
				return m_strHTML.replace("&nbsp;", "");
			}
		} else {
			return egovMessageSource.getMessage("main.t0602", new Locale(globals.getProperty("Globals.language")));
		}
	}

	/**
	 * 게시판 html -> mht 변환 이미지디코딩 표출 Method
	 */
	private String doImageDecoding(String strImageMht, String m_strSPath, String m_strLPath) throws Exception{
		byte[] imageBytes = Base64.decodeBase64(strImageMht);
		
		String strImageName = UUID.randomUUID() + ".tmp";
        String SfilePath = m_strSPath + strImageName;
        String LfilePath = m_strLPath + strImageName;
        File file = new File(m_strLPath);
        
        if (!file.exists()) {
        	file.mkdir();
        }
        
        FileOutputStream fileOutputStream = new FileOutputStream(new File(LfilePath));
        fileOutputStream.write(imageBytes);
        fileOutputStream.close();
        
		return SfilePath;
	}

	/**
	 * 게시판 html -> mht 변환 mht디코딩 표출 Method
	 */
	private String doMHTDecoding(String strMht, String m_strHTML) {
		byte[] arr = Base64.decodeBase64(strMht);
		m_strHTML = new String(arr);
		
		return m_strHTML;
	}

	/**
	 * 게시판 html -> mht 변환boundary 반환 표출 Method
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
	 * 게시판 mht 로드 표출 Method
	 */
	public String loadMHTFile(String strMHTpath) throws Exception{
		String strMhtData = "";
		BufferedReader br = new BufferedReader(new FileReader(strMHTpath));
	    try {
	        StringBuilder sb = new StringBuilder();
	        String line = br.readLine();

	        while (line != null) {
	            sb.append(line);
	            sb.append(System.lineSeparator());
	            line = br.readLine();
	        }
	        strMhtData = sb.toString();
	    } finally {
	        br.close();
	    }
	    
        return strMhtData;
    }
	
	/**
	 * ID크릭시 사용자 정보화면 호출 Method
	 */
	@RequestMapping(value = "/ezCommon/showPersonInfo.do")
	public String showPersonInfo(@CookieValue("loginCookie")String loginCookie, Locale locale,HttpServletRequest request, ModelMap model) throws Exception{
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String id = "", email = "", pDeptID = "";
		
		String literalEmail = "";
		String literalDisplayName = "";
		String literalPhoto = "";
		String literalDept = "";
		String literalTitle = "";
		String literalCompany = "";
		String literalMobile = "";
		String literalHomePhone = "";
		String literalFax = "";
		String literalPostal = "";
		String literalAddress = "";
		String literalPhone = "";
		String literalInfo = "";
        
        String proplist = "EXTENSIONATTRIBUTE2;COMPANY;DESCRIPTION;DISPLAYNAME;TITLE;MAIL;TELEPHONENUMBER;MOBILE;INFO;HOMEPHONE;FACSIMILETELEPHONENUMBER;POSTALCODE;STREETADDRESS;DEPARTMENT";
        
        if (request.getParameter("id") != null) {
        	id = request.getParameter("id");
        }
        
        if (request.getParameter("email") != null) {
        	id = request.getParameter("email");
        }
        
        if (request.getParameter("dept") != null) {
        	id = request.getParameter("dept");
        }
        
        /*if (id.equals("")) {
        	
        	if (!email.equals("")) {
        		id = ezOrganService.getCNByEmail(email);
        		
        	}
        }*/
        
        if (!id.equals("")) {
        	String infoXML = ezOrganService.getPropertyList(id, proplist, loginVO.getPrimary());
        	
        	Document xmldom = commonUtil.convertStringToDocument(infoXML);
        	if (xmldom.getElementsByTagName(email) == null) {
        		literalEmail = email;
        		literalDisplayName = email;
        		literalPhoto = "<IMG SRC='" + egovMessageSource.getMessage("ezHome.e14", locale) + "' width=119 height=128>";
        	} else {
        		
//        		if (xmldom.getElementsByTagName(email) == null) {
//        			infoXML = ezOrganService.getSearchLikeByEmail(id);
//        			xmldom = commonUtil.convertStringToDocument(infoXML);
//        		}
        		
        		if (!pDeptID.equals("") && !xmldom.getElementsByTagName("DEPARTMENT").item(0).getTextContent().equals(pDeptID)) {
        			String infoXML2 = ezOrganService.getUserAddjobInfo(id, pDeptID, loginVO.getPrimary());
        			
        			if (!infoXML2.equals("") && !infoXML2.equals("<DATA></DATA>")) {
        				Document xmldom2 = commonUtil.convertStringToDocument(infoXML2);
        				
        				literalDept = xmldom2.getElementsByTagName("DISPLAYNAME").item(0).getTextContent();
        				literalTitle= xmldom2.getElementsByTagName("TITLE").item(0).getTextContent();		
        			} else {
        				literalDept = xmldom.getElementsByTagName("DESCRIPTION").item(0).getTextContent();
        				literalTitle= xmldom.getElementsByTagName("TITLE").item(0).getTextContent();
        			}
        			
        		} else {
        			literalDept = xmldom.getElementsByTagName("DESCRIPTION").item(0).getTextContent();
    				literalTitle= xmldom.getElementsByTagName("TITLE").item(0).getTextContent();
        		}
        		
        		if (xmldom.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().equals("") || xmldom.getElementsByTagName("TITLE").item(0).getTextContent().equals("")) {
        			literalPhoto = "<IMG SRC='" + egovMessageSource.getMessage("ezHome.e14", locale) + "' width=119 height=128>";
        		} else {
        			literalPhoto = "<IMG SRC='/admin/ezOrgan/getPersonalInfo.do?fileName=" + xmldom.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent() + "' width=119 height=128>";
        		}
        		
        		literalCompany = xmldom.getElementsByTagName("COMPANY").item(0).getTextContent();
        		literalDisplayName = xmldom.getElementsByTagName("DISPLAYNAME").item(0).getTextContent();
        		literalEmail = xmldom.getElementsByTagName("MAIL").item(0).getTextContent();
        		literalPhone = xmldom.getElementsByTagName("TELEPHONENUMBER").item(0).getTextContent();
        		literalMobile = xmldom.getElementsByTagName("MOBILE").item(0).getTextContent();
        		literalHomePhone = xmldom.getElementsByTagName("HOMEPHONE").item(0).getTextContent();
        		literalFax = xmldom.getElementsByTagName("FACSIMILETELEPHONENUMBER").item(0).getTextContent();
        		literalPostal = xmldom.getElementsByTagName("POSTALCODE").item(0).getTextContent();
        		literalAddress= xmldom.getElementsByTagName("STREETADDRESS").item(0).getTextContent();
        		literalInfo = xmldom.getElementsByTagName("INFO").item(0).getTextContent().replace(System.lineSeparator(), "<BR>");
        	}
        } else {
        	literalEmail = email;
        	literalDisplayName = email;
        	literalPhoto = "<IMG SRC='" + egovMessageSource.getMessage("ezHome.e14", locale) + "' width=119 height=128>";
        }
        
        
        model.addAttribute("LiteralEmail", literalEmail);
        model.addAttribute("LiteralDisplayName", literalDisplayName);
        model.addAttribute("LiteralPhoto", literalPhoto);
        model.addAttribute("LiteralDept", literalDept);
        model.addAttribute("LiteralTitle", literalTitle);
        model.addAttribute("LiteralCompany", literalCompany);
        model.addAttribute("LiteralMobile", literalMobile);
        model.addAttribute("LiteralHomePhone", literalHomePhone);
        model.addAttribute("LiteralFax", literalFax);
        model.addAttribute("LiteralPostal", literalPostal);
        model.addAttribute("LiteralAddress", literalAddress);
        model.addAttribute("LiteralPhone", literalPhone);
        model.addAttribute("LiteralInfo", literalInfo);
       
        return "/ezCommon/showPersonInfo";
	}
	
	@RequestMapping(value = "/ezCommon/downloadAttach.do")
	public void downloadAttach(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String filePath = request.getParameter("filePath");
		String fileName = "";
		
		if (request.getParameter("fileName") != null) {
			fileName = request.getParameter("fileName");
		}
		
		ezCommonService.responseAttach(filePath, fileName, true, request, response);
	}
}