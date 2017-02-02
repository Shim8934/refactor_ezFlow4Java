package egovframework.ezEKP.ezCommon.service.impl;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Random;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.ezEKP.ezCommon.dao.EzCommonDAO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommon.vo.ApprovPWDVO;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.vo.TenantServerNameVO;
import egovframework.let.user.login.vo.TenantVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzCommonService")
public class EzCommonServiceImpl extends EgovFileMngUtil implements EzCommonService {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzCommonDAO")
	private EzCommonDAO ezCommonDAO;
	
	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
	
    @Autowired
    private EzEmailUtil ezEmailUtil;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCommonServiceImpl.class);
	
	@Override
	public String getContentInfo(String type, String itemID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PTYPE", type);
		map.put("v_PID", itemID);
		return ezCommonDAO.getContentInfo(map);
	}

	@Override
	public BoardAttachVO getAttachInfo(String type, String attID, String mode, int sn, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PTYPE", type);
		map.put("v_PID", attID);
		map.put("v_PMODE", mode);
		map.put("v_PATTACHFILESN", sn);
		map.put("v_PCOMPANYID", companyID);
		return ezCommonDAO.getAttachInfo(map);
	}

	@Override
	public ApprovPWDVO getApprovPWD(LoginVO userInfo) throws Exception {
		return ezCommonDAO.getApprovPWD(userInfo);
	}

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
        boolean bAttachment = false;
        
        if (pAttachment) {
            switch (fileExt) {
                case ".eml":
                case ".mht":
                case ".xls":
                case ".doc":
                case ".pdf":
                case ".hwp":
                case ".ppt":
                case ".docx":
                case ".pptx":
                case ".xlsx":
                case ".rtf":
                case ".jpg":
                case ".gif":
                case ".bmp":
                case ".wmv":
                case ".avi":
                case ".mp4":
                case ".mpeg":
                    bAttachment = true;
                    break;
                default:
                    bAttachment = false;
                    break;
            }
            bAttachment = true;
        }
        
        FileInputStream is = null;
        String usebrowser = (request.getHeader("User-Agent")==null||request.getHeader("User-Agent")=="") ? "NONE" : request.getHeader("User-Agent").indexOf("MSIE") > -1 ?
                            "IE" : request.getHeader("User-Agent").indexOf("Trident") > -1 ? "IE" : "NONE";

        if (bAttachment) {
            if (isUTF8 == "0" && usebrowser == "IE") {
                response.addHeader("Content-Disposition", "attachment;filename=\"" + URLEncoder.encode((fileName).replace("+", "%20"),"UTF-8") + "\"");
            } else if (isUTF8 == "0" && usebrowser != "IE") {
                response.addHeader("Content-Disposition", "attachment;filename=\"" + (fileName) + "\"");
            } else {
                response.addHeader("Content-Disposition", "attachment;filename=\"" + URLEncoder.encode((fileName).replace("+", "%20"), "UTF-8") + "\"");
            }
        } else {
            if (isUTF8 == "0" && usebrowser == "IE") {
                response.addHeader("Content-Disposition", "inline;filename=\"" + URLEncoder.encode((fileName).replace("+", "%20"), "UTF-8") + "\"");
            } else if (isUTF8 == "0" && usebrowser != "IE") {
                response.addHeader("Content-Disposition", "inline;filename=\"" + URLEncoder.encode((fileName).replace("+", "%20"), "UTF-8") + "\"");
            } else {
                response.addHeader("Content-Disposition", "inline;filename=\"" + URLEncoder.encode((fileName).replace("+", "%20"), "UTF-8") + "\"");
            }
        }

        if (fileExt == ".pdf") {
            response.setContentType("application/pdf");
        } else {
            response.setContentType("application/octet-stream");
        }
                
        try {
	        filePath = realPath + filePath;
	        File file = new File(filePath);
	        is = new FileInputStream(file);
	        
	        IOUtils.copy(is,response.getOutputStream());
        } catch(Exception e) {
        	
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

        if (pOrgFileExt != "")
        	pOrgFileName = pOrgFileName.substring(0, pOrgFileName.lastIndexOf("."));
        if (pOrgFileExt == ".doc" || pOrgFileExt == ".xls" || pOrgFileExt == ".ppt")
        	lengthLimit = 110;
        if (pIsUTF8 == "0")
        	length = URLEncoder.encode(pOrgFileName + pOrgFileExt,"UTF-8").replace("+", "%20").length();
        else
        	length = URLEncoder.encode(pOrgFileName + pOrgFileExt,"UTF-8").replace("+", "%20").length();

        if (length > lengthLimit){
            newFileName = pOrgFileName;
            while (length > lengthLimit){
                newFileName = newFileName.substring(0, newFileName.length() - 1);
                if (pIsUTF8 == "0") 
                	length = URLEncoder.encode(newFileName + pOrgFileExt,"UTF-8").replace("+", "%20").length();
                else 
                	length = URLEncoder.encode(newFileName + pOrgFileExt, "UTF-8").replace("+", "%20").length();
            }
            pOrgFileName = newFileName;
        }
        
        return pOrgFileName + pOrgFileExt;
	}
	
	/**
	 * html -> mht 변환 실행 Method
	 */
	@Override
	public String startHtml2Mht(String m_strHTML, String realPath, Locale locale) throws Exception{
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

            m_strMHT.append("--" + commonUtil.CRLF);
            
            return m_strMHT.toString();
        } else {
        	return egovMessageSource.getMessage("main.t0603", locale);
        }
    }

	/**
	 * html -> mht 변환 헤더설정 표출 Method
	 */
	private String makeHeader(StringBuilder m_strMHT) throws Exception{
		String m_strBoundary = createBoundary();
        m_strMHT.append("MIME-Version: 1.0" + commonUtil.CRLF);
        m_strMHT.append("Content-Type: Multipart/related;" + commonUtil.CRLF);
        m_strMHT.append("  boundary=\"" + m_strBoundary + "\"" + commonUtil.CRLF);
        m_strMHT.append("From: Kaoni MHT Component(UTF-8)" + commonUtil.CRLF);
        m_strMHT.append("Subject: HTML to Mime-HTML" + commonUtil.CRLF);
        m_strMHT.append("Date: " + getDate() + commonUtil.CRLF);
        m_strMHT.append(commonUtil.CRLF + commonUtil.CRLF);
        
        return m_strBoundary;
    }
	
	/**
	 * boundary 생성 표출 Method
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
	 * html -> mht 변환 배경화면추출 표출 Method
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
        	if (strTempHtml.indexOf("background", npos) > 0) {
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
        	} else {
        		break;
        	}
        }

        //<td 태그의 Background갯수를 알아낸다.
        npos = 0;
        while (true) {
        	if (strTempHtml.indexOf("background", npos) > 0) {
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
	 * html -> mht 변환 html 인코딩 실행 Method
	 */
	private void doHtmlEncoding(String strHtml, StringBuilder m_strMHT, String m_strBoundary) throws Exception{
        m_strMHT.append("--" + m_strBoundary + commonUtil.CRLF);
        m_strMHT.append("Content-Type: Text/HTML" + commonUtil.CRLF);
        m_strMHT.append("Content-Transfer-Encoding: base64" + commonUtil.CRLF);
        m_strMHT.append("Content-Location: file://c:" + commonUtil.separator + "test.htm" + commonUtil.CRLF);
        m_strMHT.append(commonUtil.CRLF);
        
        byte[] arr = strHtml.getBytes("UTF-8");
        String strMhtBase64 = Base64.getMimeEncoder().encodeToString(arr);
        
        m_strMHT.append(strMhtBase64 + commonUtil.CRLF);
        m_strMHT.append("--" + m_strBoundary);
    }
	
	/**
	 * html -> mht 변환 이미지인코딩 실행 Method
	 * @param realPath 
	 */
	private void doImageEncoding(String[] m_ImageList, StringBuilder m_strMHT, String m_strBoundary, String realPath) throws Exception{
        for (int i = 0; i < m_ImageList.length; i++) {
            m_strMHT.append(commonUtil.CRLF + "Content-Type: Image/gif" + commonUtil.CRLF);
            m_strMHT.append("Content-Transfer-Encoding: base64" + commonUtil.CRLF);
            m_strMHT.append("Content-Location: file:///C:/IMAGE" + (i + 1) + ".gif" + commonUtil.CRLF);
            m_strMHT.append(commonUtil.CRLF);
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
					try {
						logger.debug("not found image(" + m_ImageList[i].replace("&amp;", "&") + ") :::" + e.getMessage());
						File file = new File(m_ImageList[i].replace("&amp;", "&"));
						in = new FileInputStream(file);
						// 이미지 못찾을떄 사진없음 이미지 보여주기
					} catch (FileNotFoundException e2) {
						logger.debug("change default image" + e2.getMessage());
						
						in = new FileInputStream(realPath + "/images/default_pic.jpg");
					}
				}
                int len = 0;
                byte[] buf = new byte[1024];
                
                while ((len = in.read(buf)) != -1) {
                	byteOutStream.write(buf, 0, len);
                }
//                if (m_ImageList[i].length() > 1) {
//                	if (m_ImageList[i].indexOf("files" + commonUtil.separator + "upload_approvalG") == -1) {
//                		try {
//                			deleteFile(realPath + m_ImageList[i].replace("&amp;", "&"));
//                		} catch (Exception e) {
//                			deleteFile(m_ImageList[i].replace("&amp;", "&"));
//                		}
//                	}
//                }
            }
            
            
            byte[] imageByte = byteOutStream.toByteArray();
            String strImageData = new String(Base64.getMimeEncoder().encodeToString(imageByte));
            
            in.close();
            byteOutStream.close();
            
            m_strMHT.append(strImageData + commonUtil.CRLF);
            m_strMHT.append("--" + m_strBoundary);
            
        }
    }
	
	/**
	 * html -> mht 변환 배경화면인코딩 실행 Method
	 */
	private void doBackgrondEncding(String[] m_ImageList, String[] m_BackImageList, StringBuilder m_strMHT, String m_strBoundary) throws Exception{
        for (int i = 0; i < m_BackImageList.length; i++) {
            m_strMHT.append(commonUtil.CRLF + "Content-Type: Image/gif" + commonUtil.CRLF);
            m_strMHT.append("Content-Transfer-Encoding: base64" + commonUtil.CRLF);
            m_strMHT.append("Content-Location: file:///C:/BACKGROUNDIMAGE" + (i + 1) + ".gif" + commonUtil.CRLF);
            m_strMHT.append(commonUtil.CRLF);
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
            String strImageData = Base64.getMimeEncoder().encodeToString(imageByte);
            
            in.close();
            byteOutStream.close();
            
            m_strMHT.append(strImageData + commonUtil.CRLF);
            m_strMHT.append("--" + m_strBoundary);
        }
    }
	
	/**
	 * html -> mht 변환 표출 Method
	 */
	@Override
	public String getMHTtoHTML(String type, String itemID, int tenantID, String realPath, HttpServletRequest request, Locale locale) throws Exception{
        String filePath = "";
        String uploadModule = commonUtil.getUploadPath("upload_common.MHTIMAGE", tenantID) + commonUtil.separator;
        
        if (type.equals("COMMUNITYNOTI")) {
			uploadModule = commonUtil.getUploadPath("upload_community.MAINBOARD", tenantID) + commonUtil.separator;
        }
        
        filePath = realPath + uploadModule;
        File file = new File(filePath);
        
        if (!file.exists()) {
        	file.mkdir();
        }
        
        String url = "";
        if (type.equals("HTMLPORTLET")) {
        	url = request.getParameter("href");
        } else if (type.equals("BOARDCONTENT") || type.equals("BOARDCONTENTTEMP") || type.equals("BOARDFORM")) {
        	url = ezBoardService.getContentInfo(type, itemID, tenantID);
        } else {
        	//나머지도 바꿔야함~
        	url = getContentInfo(type, itemID);
        }
        
        String m_strMHT = "";
        
        try {
        	if (type.equals("COMMUNITYNOTI")) {
        		m_strMHT = loadMHTFile(realPath + uploadModule + url);
        	} else {
        		m_strMHT = loadMHTFile(realPath + url);
        	}
		} catch (Exception e) {
			m_strMHT= "";
		}
        
        String strHTML = startMHT2HTML(filePath, m_strMHT, filePath, realPath, locale);
        
        if (strHTML.trim().length() > 0) {
        	return strHTML;
        } else {
        	return "<HTML><HEAD><TITLE></TITLE><META content=\"text/html; charset=utf-8\" http-equiv=Content-Type></HEAD><STYLE title=\"ezform_style_1\">P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm; *font-size:x-small; } </STYLE><BODY></BODY></HTML>";
        }
	}
	
	/**
	 * html -> mht 변환 실행 표출 Method
	 */
	@Override
	public String startMHT2HTML(String m_strLPath, String m_strMHT, String m_strSPath, String realPath, Locale locale) throws Exception{
		String m_strHTML = "";
		String strBoundary = "";
		String[] m_Mimechunk = null;
		List<String> m_ListImageLocation = new ArrayList<String>();
		List<String> m_ListImageLocalLocation = new ArrayList<String>();
		
		strBoundary = getBoundaryText(m_strMHT);

		if (m_strMHT != null && !m_strMHT.equals("")) {
			if (strBoundary.equals("error")) {
				return egovMessageSource.getMessage("main.t0600", locale);
			} else {
				m_Mimechunk = m_strMHT.split(strBoundary);
				for (int i = 1; i < m_Mimechunk.length; i++) {
					String[] strMimeChunk = m_Mimechunk[i].split(commonUtil.CRLF + commonUtil.CRLF);
					String[] strMime_info_p = strMimeChunk[0].trim().split(commonUtil.CRLF);
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
						//절대경로에서 realPath "" 으로 대체
						m_strHTML = m_strHTML.replace(m_ListImageLocation.get(i), m_ListImageLocalLocation.get(i).replace(realPath, ""));
					}
				} else {
					return egovMessageSource.getMessage("main.t0601", locale);
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
	private String doImageDecoding(String strImageMht, String m_strSPath, String m_strLPath) throws Exception{
		byte[] imageBytes = Base64.getMimeDecoder().decode(strImageMht);
		
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
	 * html -> mht 변환 mht디코딩 표출 Method
	 */
	private String doMHTDecoding(String strMht, String m_strHTML) {
		byte[] arr = Base64.getMimeDecoder().decode(strMht);
		
		try {
			m_strHTML = new String(arr, "utf-8");
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
		BufferedReader br = new BufferedReader(new FileReader(strMHTpath.trim()));
	    try {
	        StringBuilder sb = new StringBuilder();
	        String line = br.readLine();

	        while (line != null) {
	            sb.append(line);
	            sb.append(commonUtil.CRLF);
	            line = br.readLine();
	        }
	        strMhtData = sb.toString();
	    } finally {
	        br.close();
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
	
	private String getTenantConfigForJMocha(String property, int tenantID) throws Exception {
        logger.debug("getTenantConfigForJMocha started. tenantID=" + tenantID + ",property=" + property);
        
        String returnValue = "";
        
        String param1 = "tenantId=" + tenantID;
        String param2 = "property=" + URLEncoder.encode(property, "UTF-8");
        String inputParams = param1 + "&" + param2;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getTenantConfig";
        String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

        logger.debug("response=" + response);
        
        String resultCode = "Error";
        int reasonCode = -100; 
                
        if (response != null) {
            JSONParser jsonParser = new JSONParser();
            JSONObject responseObj = (JSONObject)jsonParser.parse(response);

            resultCode = (String)responseObj.get("resultCode");     
            
            if (resultCode.equals("OK")) {
                reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
                
                if (reasonCode == 0) {
                    JSONObject result = (JSONObject)responseObj.get("result");
                    
                    if (result != null) {
                        returnValue = (String)result.get("propertyValue");
                    }                   
                }
            }
        }                       
        
        logger.debug("PROPERTY NAME : " + property + "||" + "TENANTID : " + tenantID);
        logger.debug("PROPERTY VALUE : " + returnValue);
        
        logger.debug("getTenantConfigForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;	    
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
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getTenantConfigForJMocha(property, tenantID);
        } else {
            return getTenantConfigForLocal(property, tenantID);
        }	    
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
	
}
