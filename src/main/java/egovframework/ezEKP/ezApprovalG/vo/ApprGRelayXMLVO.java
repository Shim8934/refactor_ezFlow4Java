package egovframework.ezEKP.ezApprovalG.vo;

import org.apache.tomcat.util.codec.binary.Base64;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.TimeZone;

// 안 쓰는 변수가 상당히 있다 필요한건가?
@SuppressWarnings("unused")
public class ApprGRelayXMLVO {

    private String relayFolderPath;
    private String filePath;
    Document xmlDoc = null;
    private String receiveID;
    private String companyID;
    private int tenantID;
    private String aprDocPath;
    private String fileDate;

    private String sendOrgCode;
    private String sendID;
    private String title;
    private String xDocID;
    private String docType;
    private String writerName;
    private String writerDept;
    private String sendName;
    private String xGW;
    private String dTDVersion;
    private String xSLVersion;
    private String recDate;
	private String message;
	private String acceptName;
    private String cont;
    private String contRole;
    private String contName;
    private int contLength;
    private NodeList contentList;

    public ApprGRelayXMLVO(String filePath) {
        this.filePath = filePath;

        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setValidating(false);
            factory.setNamespaceAware(true);

            DocumentBuilder builder = factory.newDocumentBuilder();
            this.xmlDoc = builder.parse(new InputSource(filePath));

            this.sendOrgCode = getXMLproperty("sendOrgCode");
            System.out.println("#송신기관코드=" + this.sendOrgCode);

            this.sendID = getXMLproperty("sendID");
            System.out.println("#송신부서코드=" + this.sendID);

            if (!this.xmlDoc.getElementsByTagName("title").item(0).getTextContent().equals("")) {
                this.title = getXMLproperty("title");

                if (this.title.length() > 125) {
                    this.title = this.title.substring(1, 125);
                }
            }
            System.out.println("#문서제목=" + this.title);
            this.xDocID = getXMLproperty("xDocID");
            System.out.println("#문서고유번호=" + this.xDocID);
            this.docType = getXMLproperty("docType");
            System.out.println("#문서종류=" + this.docType);
            this.writerName = getXMLproperty("writerName");

            if (this.writerName == null || this.writerName.equals("")) {
                this.writerName = "미확인";
            }

            System.out.println("#문서작성자이름=" + this.writerName);
            this.writerDept = getXMLproperty("writerDept");

            if (this.writerDept == null || this.writerDept.equals("")) {
                this.writerDept = "미확인";
            }

            System.out.println("#문서작성자부서=" + this.writerDept);
            this.sendName = getXMLproperty("sendName");
            System.out.println("#송신기관명=" + this.sendName);
            this.xGW = getXMLproperty("XGW");
            System.out.println("#송신그룹웨어명=" + this.xGW);
            this.dTDVersion = getXMLproperty("DTDVersion");
            System.out.println("#DTD버전=" + this.dTDVersion);
            this.xSLVersion = getXMLproperty("XSLVersion");
            System.out.println("#XSL버전=" + this.xSLVersion);

            if (this.xmlDoc.getElementsByTagName("date").item(0).getTextContent().length() > 0) {
                this.recDate = getXMLproperty("recDate");
            } else {
                this.recDate = getDateStringInUTC(getTodayUTCTime(""), "235|+09:00", true);
            }

            if (!ValidateDateTimeString(this.recDate)) {
                this.recDate = getDateStringInUTC(getTodayUTCTime(""), "235|+09:00", true);
            }

            System.out.println("#날짜=" + this.recDate);

            this.message = getXMLproperty("message");

            this.acceptName = getXMLproperty("acceptName");

        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println(e.getStackTrace());
        }

    }

    public String getRelayFolderPath() {
        return relayFolderPath;
    }

    public Document getXmlDoc() {
        return xmlDoc;
    }

    public String getFilePath() {
        return filePath;
    }

    public int getTenantID() {
        return tenantID;
    }

    public String getAprDocPath() {
        return aprDocPath;
    }

    public String getFileDate() {
        return fileDate;
    }

    public String getCompanyID() {
        return companyID;
    }

    public String getSendOrgCode() {
        return sendOrgCode;
    }

    public String getSendID() {
        return sendID;
    }

    public String getReceiveID() {
        return receiveID;
    }

    public String getTitle() {
        return title;
    }

    public String getxDocID() {
        return xDocID;
    }

    public String getDocType() {
        return docType;
    }

    public String getWriterName() {
        return writerName;
    }

    public String getWriterDept() {
        return writerDept;
    }

    public String getSendName() {
        return sendName;
    }

    public String getxGW() {
        return xGW;
    }

    public String getdTDVersion() {
        return dTDVersion;
    }

    public String getxSLVersion() {
        return xSLVersion;
    }

    public String getRecDate() {
        return recDate;
    }

    public String getMessage() {

        String result = null;

        try {
            result = new String(Base64.decodeBase64(xmlDoc.getElementsByTagName("content").item(0).getTextContent()), "euc-kr");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println(e.getStackTrace());
        }

        return result;
    }

    public String getAcceptName() {

        String result = null;

        try {
            result = new String(Base64.decodeBase64(xmlDoc.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("name").getTextContent()), "euc-kr") + "(" + new String(Base64.decodeBase64(xmlDoc.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("dept").getTextContent()), "euc-kr") + ")";
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println(e.getStackTrace());
        }

        return result;
    }

    public String getCont(int count) {
        return xmlDoc.getElementsByTagName("content").item(count).getTextContent();
    }

    public String getContRole(int count) {
        return xmlDoc.getElementsByTagName("content").item(count).getAttributes().getNamedItem("content-role").getTextContent();
    }

    public String getContName(int count) {

        String result = null;

        try {
            result = new String(Base64.decodeBase64(xmlDoc.getElementsByTagName("content").item(count).getAttributes().getNamedItem("filename").getTextContent()), "euc-kr");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println(e.getStackTrace());
        }

        return result;
    }

    public int getContLength() {
        return xmlDoc.getElementsByTagName("content").getLength();
    }

    public NodeList getContentList() {
        return xmlDoc.getElementsByTagName("content");
    }

    public void setRelayFolderPath(String relayFolderPath) {
        this.relayFolderPath = relayFolderPath;
    }

    public void setCont(String cont) {
        this.cont = cont;
    }

    public void setContRole(String contRole) {
        this.contRole = contRole;
    }

    public void setContName(String contName) {
        this.contName = contName;
    }

    public void setTenantID(int tenantID) {
        this.tenantID = tenantID;
    }

    public void setAprDocPath(String aprDocPath) {
        this.aprDocPath = aprDocPath;
    }

    public void setFileDate(String fileDate) {
        this.fileDate = fileDate;
    }

    public void setCompanyID(String companyID) {
        this.companyID = companyID;
    }

    public void setSendOrgCode(String sendOrgCode) {
        this.sendOrgCode = sendOrgCode;
    }

    public void setSendID(String sendID) {
        this.sendID = sendID;
    }

    public void setReceiveID(String receiveID) {
        this.receiveID = receiveID;
        xmlDoc.getElementsByTagName("receive-id").item(0).setTextContent(receiveID);
        System.out.println("#수신부서코드=" + receiveID);
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setxDocID(String xDocID) {
        this.xDocID = xDocID;
    }

    public void setDocType(String docType) {
        this.docType = docType;
    }

    public void setWriterName(String writerName) {
        this.writerName = writerName;
    }

    public void setWriterDept(String writerDept) {
        this.writerDept = writerDept;
    }

    public void setSendName(String sendName) {
        this.sendName = sendName;
    }

    public void setxGW(String xGW) {
        this.xGW = xGW;
    }

    public void setdTDVersion(String dTDVersion) {
        this.dTDVersion = dTDVersion;
    }

    public void setxSLVersion(String xSLVersion) {
        this.xSLVersion = xSLVersion;
    }

    public void setRecDate(String recDate) {
        this.recDate = recDate;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public void setAcceptName(String acceptName) {
        this.acceptName = acceptName;
    }


    /**
     * <pre>
     * timeZoneToUTC가 true면 TimeZone Date 문자열을 UTC타임 Date 문자열로 바꿔서 반환한다.
     * timeZoneToUTC가 false면 UTC타임 Date 문자열을 TimeZone Date 문자열로 바꿔서 반환한다.
     * - dateStr 형식 : yyyy-MM-dd HH:mm:ss, yyyy-MM-dd HH:mm, yyyy-MM-dd
     * 				   yyyy/MM/dd HH:mm:ss, yyyy/MM/dd HH:mm, yyyy/MM/dd, yyMMdd
     * - offset 형식 : ex) 235|+09:00
     * </pre>
     */
    public String getDateStringInUTC(String dateStr, String offset, boolean timeZoneToUTC) {
//		System.out.println("dateStr=" + dateStr + ", offset=" + offset + ", timeZoneToUTC=" + timeZoneToUTC);

        if (dateStr == null) {
            System.out.println("dateStr is null.");
            return null;
        }

        if (dateStr.equals("0")) {
            return dateStr;
        }

        if (offset == null || offset.indexOf("|") == -1) {
            System.out.println("offset is null or offset format is wrong.");
            return dateStr;
        }

        String pattern = "";
        if (dateStr.length() == 8) {
            pattern = "yyyyMMdd";
        } else if (dateStr.length() == 10) {
            if (dateStr.indexOf("/") > -1) {
                pattern = "yyyy/MM/dd";
            } else {
                pattern = "yyyy-MM-dd";
            }
        } else if (dateStr.length() == 14) {
            pattern = "yyyyMMddHHmmss";
        } else if (dateStr.length() == 16) {
            if (dateStr.indexOf("/") > -1) {
                pattern = "yyyy/MM/dd HH:mm";
            } else {
                pattern = "yyyy-MM-dd HH:mm";
            }
        } else if (dateStr.length() == 21) {
            if (dateStr.indexOf("/") > -1) {
                pattern = "yyyy/MM/dd aa h:mm:ss";
            } else {
                pattern = "yyyy-MM-dd aa h:mm:ss";
            }
        } else {
            if (dateStr.indexOf("/") > -1) {
                pattern = "yyyy/MM/dd HH:mm:ss";
            } else {
                pattern = "yyyy-MM-dd HH:mm:ss";
            }
        }
//		System.out.println("pattern=" + pattern);

        String[] offsetArr = offset.split("\\|");

        SimpleDateFormat userFormat = new SimpleDateFormat(pattern);
        userFormat.setTimeZone(TimeZone.getTimeZone("GMT" + offsetArr[1]));

        SimpleDateFormat utcFormat = new SimpleDateFormat(pattern);
        utcFormat.setTimeZone(TimeZone.getTimeZone("GMT"));

        String resultDateStr = "";
        try {
            if (timeZoneToUTC) {
                resultDateStr = utcFormat.format(userFormat.parse(dateStr));
            } else {
                resultDateStr = userFormat.format(utcFormat.parse(dateStr));
            }
        } catch (ParseException e) {
            System.out.println("Check the dateStr format.");
            return dateStr;
        }

//		System.out.println("resultDateStr=" + resultDateStr);
        return resultDateStr;
    }

    /**
     * 현재시간 UTC로 가져오기
     * @param format 공백이면 기본 "yyyy-MM-dd HH:mm:ss" 형식
     * @return 포맷팅된 UTC 현재시간 가져옴
     * @throws Exception
     */
    public String getTodayUTCTime(String format) throws Exception {
        System.out.println("getTodayUTCTime started");

        ZoneId utc = ZoneId.of("UTC");
        ZonedDateTime getTime = ZonedDateTime.of(LocalDateTime.now(utc), utc);

        DateTimeFormatter formatter = null;

        if (format == null || format.equals("")) {
            formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        } else {
            try {
                formatter = DateTimeFormatter.ofPattern(format);
            } catch (Exception e) {
                System.out.println("formatter error :: " + e.getMessage());
                formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            }
        }

        String today = getTime.format(formatter);

        System.out.println("getTodayUTCTime ended");

        return today;
    }

    private boolean ValidateDateTimeString(String strRecDate) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if (strRecDate == null) {
            return false;
        }

        String format = null;
        try {
            format = sdf.format(sdf.parse(strRecDate));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return strRecDate.equals(format);
    }

    public String getXMLproperty(String target) throws UnsupportedEncodingException {
        String result = "";

        switch (target) {

            case "sendOrgCode":
                result = xmlDoc.getElementsByTagName("send-orgcode").item(0).getTextContent();
                break;
            case "sendID":
                result = xmlDoc.getElementsByTagName("send-id").item(0).getTextContent();
                break;
            case "title":
                result = new String(Base64.decodeBase64(xmlDoc.getElementsByTagName("title").item(0).getTextContent().getBytes("UTF-8")), "euc-kr");
                break;
            case "xDocID":
                result = xmlDoc.getElementsByTagName("doc-id").item(0).getTextContent();
                break;
            case "docType":
                result = xmlDoc.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("type").getTextContent();
                break;
            case "writerName":
                result = new String(Base64.decodeBase64(xmlDoc.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("name").getTextContent()), "euc-kr");
                break;
            case "writerDept":
                result = new String(Base64.decodeBase64(xmlDoc.getElementsByTagName("doc-type").item(0).getAttributes().getNamedItem("dept").getTextContent()), "euc-kr");
                break;
            case "sendName":
                result = new String(Base64.decodeBase64(xmlDoc.getElementsByTagName("send-name").item(0).getTextContent()), "euc-kr");
                break;
            case "XGW":
                result = new String(Base64.decodeBase64(xmlDoc.getElementsByTagName("send-gw").item(0).getTextContent()), "euc-kr");
                break;
            case "DTDVersion":
                result = xmlDoc.getElementsByTagName("dtd-version").item(0).getTextContent().toString();
                break;
            case "XSLVersion":
                result = xmlDoc.getElementsByTagName("xsl-version").item(0).getTextContent();
                break;
            case "recDate":
                result = xmlDoc.getElementsByTagName("date").item(0).getTextContent();
                break;

        }

        return result;
    }

}