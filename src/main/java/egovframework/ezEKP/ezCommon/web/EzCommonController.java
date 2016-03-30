package egovframework.ezEKP.ezCommon.web;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Properties;
import java.util.Random;
import java.util.UUID;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.imageio.stream.ImageInputStream;
import javax.imageio.stream.ImageOutputStream;
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

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/**
 * 공통적으로 사용되는 메소드 집합 Controller
 */
@Controller
public class EzCommonController extends EgovFileMngUtil{
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@RequestMapping(value = "/ezCommon/manyColor.do")
	public String manyColor(HttpServletRequest request, ModelMap model) throws Exception{		
		return "ezCommon/manyColor";
	}
	
	@RequestMapping(value = "/ezCommon/htmlToMHT.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String htmlToMHT(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
        String strHTML = "";
        if(request.getParameter("strHTML") != null){
        	strHTML = request.getParameter("strHTML");
        }
        strHTML = strHTML.replace("&lt;", "<").replace("&lt;", "<").replace("&gt;", ">").replace("&quot;", "\"").replace("&apos;", "\'");
        
        String scheme = "http://";
    	if(request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")){
    		scheme = "https://";
    	}
        
        //ezEmail 관련 부분이라 스킵 exchange 관련소스 많음
//        while (strHTML.indexOf("src=\"http") > 0)
//        {
//            int pos1 = strHTML.indexOf("src=\"http") + 5;
//            int pos2 = strHTML.substring(pos1).indexOf("\"");
//            String imgurlOrg = strHTML.substring(pos1, pos2);
//            if (imgurlOrg.indexOf("ezEmail") > 0){
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

        // reform 리폼관련 소스는 "부장님 부탁드립니다."
//        if (strHTML.IndexOf("__reform_data_bind_list") > -1){
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

        String mhtData = startHtml2Mht(strHTML);
        
        return mhtData;
	}
	
	public String startHtml2Mht(String m_strHTML) throws Exception{
		StringBuilder m_strMHT = new StringBuilder();
		String m_strBoundary = "";
		String[] m_ImageList = null;
		String[] m_BackImageList = null;
        if (m_strHTML != ""){
            //MHT 헤더 생성.
        	m_strBoundary = makeHeader(m_strMHT);
        	//이미지 경로 추출 및 가상경로 매칭.
        	m_ImageList = extractImageSource(m_strHTML);
            //백그라운드 경로 추출 및 가상경로 매칭
        	m_BackImageList = extractBackgroundSource(m_strHTML, m_ImageList);
            //본문 인코딩
        	doHtmlEncoding(m_strHTML, m_strMHT, m_strBoundary);
            //이미지 인코딩
            if (m_ImageList != null)
                doImageEncoding(m_ImageList, m_strMHT, m_strBoundary);
            //백그라운드 인코딩
            if (m_BackImageList != null)
            	doBackgrondEncding(m_ImageList, m_BackImageList, m_strMHT, m_strBoundary);
            //스크립트 인코딩 - 생략 ex) <script src="http://....test.aspx">
            //CSS 인코딩 - 생략 ex) <link href="http://....test.css">

            m_strMHT.append("--\n");
            
            return m_strMHT.toString();
        }
        else{
        	return "error : Html 데이터가 존재하지 않습니다.";
        }

    }

	private String makeHeader(StringBuilder m_strMHT) throws Exception{
		String m_strBoundary = createBoundary();
        m_strMHT.append("MIME-Version: 1.0\n");
        m_strMHT.append("Content-Type: Multipart/related;\n");
        m_strMHT.append("  boundary=\"" + m_strBoundary + "\"\n");
        m_strMHT.append("From: Kaoni MHT Component(UTF-8)\n");
        m_strMHT.append("Subject:  HTML to Mime-HTML\n");
        m_strMHT.append("Date: " + getDate() + "\n");
        m_strMHT.append("\n\n");
        
        return m_strBoundary;
    }
	
	private String createBoundary() throws Exception{
        String strBoundary = "Boundary-=_";
        Random Rnd = new Random();

        while (strBoundary.length() < 39){
            int nch = Rnd.nextInt(9)+1; 

            if (nch < 26){
                strBoundary += (char)(65 + nch);
            }
            else{
                strBoundary += (char)(97 + nch - 26);
            }
        }
        return strBoundary;
    }
	
	private String getDate() throws Exception{
        Calendar calendar = Calendar.getInstance();
        
        String strDate = "";
        String strweek = "";
        String strMonth = "";
        String amPm = "";
        
        int week = calendar.get(Calendar.DAY_OF_WEEK);
        
        switch (week){
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
        if(calendar.get(Calendar.AM_PM) == 1){
        	amPm = "PM";
        }else{
        	amPm = "AM";
        }
	
        strDate = strweek + ", " + calendar.get(Calendar.DATE) + " " + strMonth + " " + calendar.get(Calendar.YEAR) + " " + amPm + " " + calendar.get(Calendar.HOUR)+":"+calendar.get(Calendar.MINUTE)+":"+calendar.get(Calendar.SECOND);

        return strDate;
    }
	
	private String[] extractImageSource(String strHtml) throws Exception{
		int npos = 0, nposStart = 0, nposEnd = 0, nImgCount = 0;
        String strTempHtml = strHtml.toLowerCase();
        String strImgsrc = "";
        String strTempList[] = null;
        String m_ImageList[] = null;
        
        //Img 태그의 갯수를 알아낸다.
        while (true){
            npos = strTempHtml.indexOf("<img", npos);
            if (npos > 0){
                nposStart = strTempHtml.indexOf(" src=", npos + 4);
                if (nposStart > 0){
                    nposEnd = strTempHtml.indexOf("\"", nposStart + 6);
                    if ((nposEnd - nposStart - 6) > 0){
                        npos = nposEnd;
                        nImgCount++;
                    }else{
                        npos = npos + 4;
                    }
                }else{
                    npos = npos + 4;
                }
            }else{
            	break;
            }
        }

        //소스에서 image src를 추출
        if (nImgCount > 0){
            //m_ImageList = new string[nImgCount];
            strTempList = new String[nImgCount];
            
            int i = 0;
            npos = 0;
            while (true){
                npos = strTempHtml.indexOf("<img", npos);
                if (npos > 0){
                    nposStart = strTempHtml.indexOf(" src=", npos + 4);
                    if (nposStart > 0){
                        nposEnd = strTempHtml.indexOf("\"", nposStart + 6);
                        if ((nposEnd - nposStart - 6) > 0){
                            strImgsrc = strHtml.substring(nposStart + 6, nposEnd - nposStart - 6);

                            npos = nposEnd;
                            strTempList[i] = strImgsrc;
                            i++;
                        }else{
                            npos = npos + 4;
                        }
                    }else{
                        npos = npos + 4;
                    }
                }else{
                	break;
                }
            }

            //중복된 이미지 경로를 걸러낸다.
            nImgCount = 0;
            boolean isSameUrl = false;
            String strtempResource = "";
            //if (strTempList != null)
            //{

            for (int j = 0; j < strTempList.length; j++){
                strtempResource = strTempList[j];
                for (int k = 0; k < j; k++){
                    if (j != k && strTempList[k] == strtempResource){
                        isSameUrl = true;
                    }
                }

                if (isSameUrl == false){
                    nImgCount++;
                }
                else{
                	isSameUrl = false;
                }
            }

            if (nImgCount > 0){
                m_ImageList = new String[nImgCount];
                strtempResource = "";
                nImgCount = 0;
                for (int j = 0; j < strTempList.length; j++){
                    strtempResource = strTempList[j];
                    for (int k = 0; k < j; k++){
                        if (j != k && strTempList[k] == strtempResource){
                            isSameUrl = true;
                        }
                    }

                    if (isSameUrl == false){
                        m_ImageList[nImgCount] = strtempResource;
                        nImgCount++;
                    }
                    else{
                    	isSameUrl = false;
                    }
                }

                int index = 1;
                for(String strResource : m_ImageList){
                    strHtml = strHtml.replace(strResource, "file:///C:/IMAGE" + index + ".gif");
                    index++;
                }
            }
        }
        return m_ImageList;
    }
	
	private String[] extractBackgroundSource(String strHtml, String[] m_ImageList) throws Exception{
        String strTempHtml = strHtml.toLowerCase();
        int npos = 0, nposStart = 0, nposEnd = 0;
        int nImgCount = 0;
        String strImgsrc = "";
        String m_BackImageList[] = null;
        List<String> L_BackImage = new ArrayList<String>();

        //<body 태그의 Background갯수를 알아낸다.
        while (true){
            npos = strTempHtml.indexOf("<body", npos);
            if (npos > 0){
                nposStart = strTempHtml.indexOf(" background=", npos + 5);
                if (nposStart > 0){
                    nposEnd = strTempHtml.indexOf("\"", nposStart + 13);
                    if ((nposEnd - nposStart - 13) > 0){
                        strImgsrc = strHtml.substring(nposStart + 13, nposEnd - nposStart - 13);
                        L_BackImage.add(strImgsrc);
                        npos = nposEnd;
                    }else{
                        npos = npos + 5;
                    }
                }else{
                    npos = npos + 5;
                }
            }else{
            	break;
            }
        }

        //<table 태그의 Background갯수를 알아낸다.
        npos = 0;
        while (true){
            npos = strTempHtml.indexOf("<table", npos);
            if (npos > 0){
                nposStart = strTempHtml.indexOf(" background=", npos + 6);
                if (nposStart > 0){
                    nposEnd = strTempHtml.indexOf("\"", nposStart + 13);
                    if ((nposEnd - nposStart - 13) > 0){
                        strImgsrc = strHtml.substring(nposStart + 13, nposEnd - nposStart - 13);
                        L_BackImage.add(strImgsrc);
                        npos = nposEnd;
                    }else{
                        npos = npos + 6;
                    }
                }else{
                    npos = npos + 6;
                }
            }
            else{
            	break;
            }
        }

        //<td 태그의 Background갯수를 알아낸다.
        npos = 0;
        while (true){
            npos = strTempHtml.indexOf("<td", npos);
            if (npos > 0){
                nposStart = strTempHtml.indexOf(" background=", npos + 3);
                if (nposStart > 0){
                    nposEnd = strTempHtml.indexOf("\"", nposStart + 13);
                    if ((nposEnd - nposStart - 13) > 0){
                        strImgsrc = strHtml.substring(nposStart + 13, nposEnd - nposStart - 13);
                        L_BackImage.add(strImgsrc);
                        npos = nposEnd;
                    }else{
                        npos = npos + 3;
                    }
                }else{
                    npos = npos + 3;
                }
            }else{
            	break;
            }
        }

        if (L_BackImage.size() > 1){
            nImgCount = 0;
            boolean isSameUrl = false;
            String strtempResource = "";
            for (int j = 0; j < L_BackImage.size(); j++){
                strtempResource = L_BackImage.get(j);
                for (int k = 0; k < j; k++){
                    if (j != k && L_BackImage.get(k) == strtempResource){
                        isSameUrl = true;
                    }
                }

                if (isSameUrl == false){
                    nImgCount++;
                }else{
                	isSameUrl = false;
                }
            }

            if (nImgCount > 0){
                m_BackImageList = new String[nImgCount];
                strtempResource = "";
                nImgCount = 0;
                for (int j = 0; j < L_BackImage.size(); j++){
                    strtempResource = L_BackImage.get(j);
                    for (int k = 0; k < j; k++){
                        if (j != k && L_BackImage.get(k) == strtempResource){
                            isSameUrl = true;
                        }
                    }

                    if (isSameUrl == false){
                        m_BackImageList[nImgCount] = strtempResource;
                        nImgCount++;
                    }
                    else{
                    	isSameUrl = false;
                    }
                }
            }
        
            L_BackImage = null;
            int index = 1;
            for(String strResource : m_ImageList){
                strHtml = strHtml.replace(strResource, "file:///C:/BACKGROUNDIMAGE" + index + ".gif");
                index++;
            }
        }
        
        return m_BackImageList;
    }
	
	private void doHtmlEncoding(String strHtml, StringBuilder m_strMHT, String m_strBoundary) throws Exception{
        m_strMHT.append("--" + m_strBoundary + "\n");
        m_strMHT.append("Content-Type: Text/HTML\n");
        m_strMHT.append("Content-Transfer-Encoding: base64\n");
        m_strMHT.append("Content-Location: file://c:" + File.separator + "test.html\n");
        m_strMHT.append("\n");
        byte[] arr = strHtml.getBytes("UTF-8");
        String strMhtBase64 = Base64.encodeBase64String(arr);
        m_strMHT.append(strMhtBase64 + "\n");
        m_strMHT.append("--" + m_strBoundary);
        
    }
	
	private void doImageEncoding(String[] m_ImageList, StringBuilder m_strMHT, String m_strBoundary) throws Exception{
        for (int i = 0; i < m_ImageList.length; i++){
            m_strMHT.append("\nContent-Type: Image/gif\n");
            m_strMHT.append("Content-Transfer-Encoding: base64\n");
            m_strMHT.append("Content-Location: file:///C:/IMAGE" + (i + 1) + ".gif\n");
            m_strMHT.append("\n");
            //이미지 본문 영역

            BufferedImage imageSample = null;

            String strExt = m_ImageList[i].substring(m_ImageList[i].lastIndexOf(".") + 1);
            String strTemp = m_ImageList[i].substring(0, 4);
            if (strTemp == "http"){
            	URL url = new URL(m_ImageList[i].replace("&amp;", "&"));
                InputStream inputStream = url.openStream();
                ImageInputStream Imgstream = ImageIO.createImageInputStream(inputStream);
                imageSample = ImageIO.read(Imgstream);
            }else{
            	File file = new File(m_ImageList[i].replace("&amp;", "&"));
            	imageSample = ImageIO.read(file);
            }
            
            ImageOutputStream outputStream = ImageIO.createImageOutputStream(imageSample);
            ImageIO.write(imageSample, strExt, outputStream);
            byte[] imageByte = outputStream.toString().getBytes();
            String strImageData = Base64.encodeBase64String(imageByte);
            outputStream.close();
            imageSample.flush();


            m_strMHT.append(strImageData + "\n");
            m_strMHT.append("--" + m_strBoundary);
        }
    }
	
	private void doBackgrondEncding(String[] m_ImageList, String[] m_BackImageList, StringBuilder m_strMHT, String m_strBoundary) throws Exception{
        for (int i = 0; i < m_BackImageList.length; i++){
            m_strMHT.append("\nContent-Type: Image/gif\n");
            m_strMHT.append("Content-Transfer-Encoding: base64\n");
            m_strMHT.append("Content-Location: file:///C:/BACKGROUNDIMAGE" + (i + 1) + ".gif\n");
            m_strMHT.append("\n");
            //이미지 본문 영역
            
            BufferedImage imageSample = null;

            String strExt = m_ImageList[i].substring(m_ImageList[i].lastIndexOf(".") + 1);
            String strTemp = m_BackImageList[i].substring(0, 4);
            if (strTemp == "http"){
            	URL url = new URL(m_BackImageList[i].replace("&amp;", "&"));
                InputStream inputStream = url.openStream();
                ImageInputStream Imgstream = ImageIO.createImageInputStream(inputStream);
                imageSample = ImageIO.read(Imgstream);
            }else{
            	File file = new File(m_BackImageList[i].replace("&amp;", "&"));
            	imageSample = ImageIO.read(file);
            }
            
            ImageOutputStream outputStream = ImageIO.createImageOutputStream(imageSample);
            ImageIO.write(imageSample, strExt, outputStream);
            byte[] imageByte = outputStream.toString().getBytes();
            String strImageData = Base64.encodeBase64String(imageByte);
            outputStream.close();
            imageSample.flush();

            m_strMHT.append(strImageData + "\n");
            m_strMHT.append("--" + m_strBoundary);
        }
    }
	
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

	public String getMHTtoHTML(String type, String itemID, String realPath) throws Exception{
        String filePath = "";
        String uploadModule = config.getProperty("LocalPath");

        filePath = realPath + uploadModule;
        File file = new File(filePath);
        if (!file.exists()){
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
        
        if(strHTML.trim().length() > 0){
        	return strHTML.replace("&amp;", "&").replace("&lt;", "<").replace("&lt;", "<").replace("&gt;", ">").replace("&quot;", "\"").replace("&apos;", "\'");
        }else{
        	return "<HTML><HEAD><TITLE></TITLE><META content=\"text/html; charset=utf-8\" http-equiv=Content-Type><META name=GENERATOR content=\"MSHTML 8.00.7601.17622\"></HEAD><STYLE title=ezform_style_1>P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm; *font-size:x-small; } </STYLE><BODY></BODY></HTML>";
        }

	}
	
	public String startMHT2HTML(String m_strLPath, String m_strMHT, String m_strSPath) throws Exception{
		String m_strHTML = "";
		String strBoundary = "";
		String[] m_Mimechunk = null;
		List<String> m_ListImageLocation = new ArrayList<String>();
		List<String> m_ListImageLocalLocation = new ArrayList<String>();
		
		strBoundary = getBoundaryText(m_strMHT);
		if(m_strMHT != null && !m_strMHT.equals("")){
			if(strBoundary.equals("error")){
				return "error : boundary 를 찾을 수 없습니다.";
			}else{
				m_Mimechunk = m_strMHT.split(strBoundary);
				
				for(int i = 1; i < m_Mimechunk.length; i++){
					String[] strMimeChunk = m_Mimechunk[i].split("\n\n");
					String[] strMime_info_p = strMimeChunk[0].trim().split("\n");
					String[] strMime_info_tupe = strMime_info_p[0].split(": ");
					
					if(strMime_info_tupe[0].equals("Content-Type")){
						if(strMime_info_tupe[1].equals("Text/HTML")){
							m_strHTML = doMHTDecoding(strMimeChunk[1].trim(), m_strHTML);
						}else if(strMime_info_tupe[0].equals("Image/gif")){
							String[] strMime_info_location = strMime_info_p[2].split(": ");
							if(strMime_info_location[0].equals("Content-Location")){
								m_ListImageLocation.add(strMime_info_location[1]);
							}
							m_ListImageLocalLocation.add(doImageDecoding(strMimeChunk[1].trim(), m_strSPath, m_strLPath));
						}
					}
				}
				if(m_ListImageLocation.size() == m_ListImageLocalLocation.size()){
					for(int i = 0; i < m_ListImageLocation.size(); i++){
						m_strHTML = m_strHTML.replace(m_ListImageLocation.get(i), m_ListImageLocalLocation.get(i)); 
					}
				}else{
					return "error : 파싱오류.";
				}
				return m_strHTML;
			}
		}else{
			return "error : MHT 데이터가 존재하지 않습니다.";
		}
	}

	private String doImageDecoding(String strImageMht, String m_strSPath, String m_strLPath) throws Exception{
		byte[] imageBytes = Base64.decodeBase64(strImageMht);
		
		String strImageName = UUID.randomUUID() + ".tmp";
        String SfilePath = m_strSPath + "\\" + strImageName;
        String LfilePath = m_strLPath + "\\" + strImageName;
        
        File file = new File(m_strLPath);
        if(!file.exists()){
        	file.mkdir();
        }
        BufferedWriter fw = new BufferedWriter(new FileWriter(LfilePath, true));

        fw.write(imageBytes.toString());
    	fw.flush();
    	fw.close();
        
		return SfilePath;
	}

	private String doMHTDecoding(String strMht, String m_strHTML) {
		byte[] arr = Base64.decodeBase64(strMht);
		m_strHTML = new String(arr);
		
		return m_strHTML;
	}

	private String getBoundaryText(String m_strMHT) {
		String strTemp = m_strMHT;
        int nPos = strTemp.indexOf("boundary=");
        if (nPos > 0){
            int nEndPos = strTemp.indexOf("\"", nPos + 10);
            return "--" + strTemp.substring(nPos + 10, nEndPos);
        }else{
            return "error";
        }
	}

	public String loadMHTFile(String strMHTpath) throws Exception{
		String strMhtData = "";
		BufferedReader br = new BufferedReader(new FileReader(strMHTpath));
	    try {
	        StringBuilder sb = new StringBuilder();
	        String line = br.readLine();

	        while (line != null) {
	            sb.append(line);
	            sb.append("\n");
	            line = br.readLine();
	        }
	        strMhtData = sb.toString();
	    } finally {
	        br.close();
	    }
        return strMhtData;
    }
	
	@RequestMapping(value = "/ezCommon/mhtToHTML.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String mhtToHTML(HttpServletRequest request) throws Exception{
		String filePath = "";
        String uploadModule = config.getProperty("LocalPath");
        String realPath = request.getServletContext().getRealPath("");
        String strURL = request.getParameter("strURL");
        
        strURL = strURL.replace("&lt;", "<").replace("&lt;", "<").replace("&gt;", ">").replace("&quot;", "\"").replace("&apos;", "\'");
        filePath = realPath + uploadModule;
        
        File file = new File(filePath);
        if (!file.exists()){
        	file.mkdir();
        }
        String m_strMHT = "";
        
        try {
        	m_strMHT = loadMHTFile(realPath + strURL);
		} catch (Exception e) {
			m_strMHT= "";
		}
        String strHTML = startMHT2HTML(filePath, m_strMHT, filePath);
        strHTML = makeXMLString(strHTML.substring(strHTML.indexOf("<BODY>") + 6,strHTML.indexOf("</BODY>")));
        
		return "<BODYDATA>" + strHTML + "</BODYDATA>";
	}
	
	public String makeXMLString(String orgString){
		if(orgString != null){
			return orgString.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
		}else{
			return orgString;
		}
	}
	
	@RequestMapping(value = "/ezCommon/ckImageUpload.do")
	public String ckImageUpload(){
		return "ezCommon/ckImageUpload";
	}
	
	@RequestMapping(value = "/ezCommon/ckUpload.do")
	public String ckUpload(MultipartHttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		MultipartFile multiFile = request.getFile("file1");
		
		String fileType = multiFile.getContentType().split("/")[1];
		String filePath = config.getProperty("upload_common.ROOT");
		String realPath = request.getServletContext().getRealPath("");
		String today = EgovDateUtil.getToday();
		String fileName = UUID.randomUUID() + "." + fileType;		
		
		filePath = filePath + "/" + today;
		File file = new File(realPath + filePath);
        if (!file.exists()){
        	file.mkdir();
        }
        
        int width = 0;
		int height = 0;
		
		writeUploadedFile(multiFile, fileName, realPath + filePath);
		
		File imageFile = new File(realPath + filePath + "/" + fileName);			
	
		if(imageFile.exists()){			
			BufferedImage bi = ImageIO.read(new File(realPath + filePath + "/" + fileName));			    
			width = bi.getWidth();
			height = bi.getHeight();
		}
		
		model.addAttribute("imgPath", (realPath + filePath).replace("\\", "/") + "/" + fileName +  "|!|" + width + "|!|" + height);
		
		if(request.getParameter("CKEditor") != null){
			response.setContentType("text/plain"); 
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Cache-Control", "no-cache");
            response.getWriter().write(("<script>window.parent.CKEDITOR.tools.callFunction(2, '" + (realPath + filePath).replace("\\", "/") + "/" + fileName + "', '')</script>"));
            
            return "";
		}else{
			return "ezCommon/ckUpload";
		}
	}

}