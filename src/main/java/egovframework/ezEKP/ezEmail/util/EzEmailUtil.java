package egovframework.ezEKP.ezEmail.util;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.security.KeyFactory;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.RSAPublicKeySpec;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.mail.Address;
import javax.mail.BodyPart;
import javax.mail.FetchProfile;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Header;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Part;
import javax.mail.internet.ContentDisposition;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimePart;
import javax.mail.internet.MimeUtility;
import javax.mail.search.AndTerm;
import javax.mail.search.ComparisonTerm;
import javax.mail.search.DateTerm;
import javax.mail.search.FlagTerm;
import javax.mail.search.ReceivedDateTerm;
import javax.mail.search.SearchTerm;
import javax.xml.bind.DatatypeConverter;

import org.apache.commons.codec.binary.Base64;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import com.sun.mail.imap.IMAPFolder;
import com.sun.mail.imap.IMAPMessage;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;

/** 
 * @Description [Utility] 메일 관련 유틸리티
 * @author 오픈솔루션팀 이동호
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.22    이동호    신규작성
 *
 * @see
 */

@Component
public class EzEmailUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailUtil.class);
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
    @Autowired
    private Properties config;
	
	@Autowired
	private CommonUtil commonUtil;
    
	/**
	 * returns a string containing size with a size unit(MB or KB or B) 
	 */
	public String getSizeWithUnit(double size) {		
		String strSize;

		if (size > 1024 * 1024) {
			/*size = size / 1024.0 / 1024.0;*/
			strSize = Math.floor(size / 1024 / 1024 * 10) / 10 + "MB";
			/*strSize = String.format("%.1fMB", size);*/
		} else if (size > 1024) {
			/*size = size / 1024.0;*/
			strSize = (int)(size/1024) + "KB";
			/*strSize = String.format("%dKB", (int)size);*/
		} else {
			/*strSize = size + "B";*/
			strSize = (int)size + "B";
		}

		return strSize;
	}
	
	/**
	 * 메일의 From 헤더로부터 보낸 사람의 이름을 반환한다. 이름을 반환할 수 없는 경우엔 이메일 주소를 대신 반환한다. 
	 * 예외가 발생하였거나 유효한 From 헤더값이 존재하지 않는 경우엔 empty string을 반환한다.
	 */
	public String getFromNameOrAddressOfMessage(Message message) {
		String addressStr = "";
		
		try {
			Address[] addresses = message.getFrom();
			
			if (addresses != null && addresses.length > 0) {
				addressStr = ((InternetAddress)addresses[0]).getPersonal(); // name part

				if (addressStr == null) {
					addressStr = ((InternetAddress)addresses[0]).getAddress(); // email address part
					
					// From: =?euc-kr?B?vLrH9rz3?= 와 같은 경우엔 위 라인의 결과가
					// =?euc-kr?B?vLrH9rz3?=:; 로 반환되어 이 경우 헤더 디코딩을 직접 처리하도록 함
					if (addressStr != null && !addressStr.contains("@") && addressStr.startsWith("=?")) {
						String fromHeader = message.getHeader("From")[0];
						
						logger.debug("fromHeader=" + fromHeader);
						
						addressStr = MimeUtility.decodeText(fromHeader);
					}
				} else {
					String fromHeader = message.getHeader("From")[0];
					
					// 표준을 지키지 않고 Non-Ascii 문자가 사용된 경우엔 직접 디코딩을 처리한다.
					if (!isPureAscii(fromHeader)) {
						byte[] rawBytes = addressStr.getBytes("iso-8859-1");
						
						addressStr = decodeNonAsciiBytes(rawBytes);
					} else {
						// decoding is needed for the name part
						// ex) =?UTF-8?B?44WC44WC?=
						//     =?utf-8?B?Z2lzYTE=?=
						//     =?ks_c_5601-1987?B?uei03iC1x8H2IL7KwL06IHRlc3Q=?=
						addressStr = MimeUtility.decodeText(addressStr);
					}
				}
			// From 헤더가 존재하더라도 이름만 있고 유효한 이메일 주소가 없는 경우에도 이 부분이 실행될 수 있다.				
			} else {
				String[] fromHeaders = message.getHeader("From");
				
				if (fromHeaders != null) {
					String fromHeader = fromHeaders[0];
					
					if (!isPureAscii(fromHeader)) {
						byte[] rawBytes = fromHeader.getBytes("iso-8859-1");
						
						addressStr = decodeNonAsciiBytes(rawBytes);
					} else {
						addressStr = MimeUtility.decodeText(fromHeader);
					}					
				}
			}			
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		return addressStr;
	}
	
	public String getFromEmailAddressOfMessage(Message message) {
		String addressStr = "";
		
		try {
			Address[] addresses = message.getFrom();
			
			if (addresses != null && addresses.length > 0) {
				addressStr = ((InternetAddress)addresses[0]).getAddress(); // email address part
			}			
		} 
		catch (MessagingException e) {			
		}
		
		return addressStr;
	}
	
	public String getFullFromAddressOfMessage(Message message) {
		String fullFromAddressStr = "";
		
		try {
			Address[] addresses = message.getFrom();			
			StringBuilder addressBuilder = new StringBuilder();
			
			if (addresses != null && addresses.length > 0) {
				Address address = addresses[0];
				String addressStr = ((InternetAddress)address).getAddress(); // email address part				
				String name = ((InternetAddress)address).getPersonal(); // name part
				
				if (name != null) {
					String fromHeader = message.getHeader("From")[0];
					
					// if the name contains Non-Ascii characters(violating the standard), 
					// try to decode it by examining the characters.					
					if (!isPureAscii(fromHeader)) {
						byte[] rawBytes = name.getBytes("iso-8859-1");
						
						name = decodeNonAsciiBytes(rawBytes);
					}
					else {					
						name = MimeUtility.decodeText(name);
					}
					
					addressBuilder.append(name + " <" + addressStr + ">");					
				}
				else {
					addressBuilder.append(addressStr + " <" + addressStr + ">");
				}				
				
				fullFromAddressStr = addressBuilder.toString();
			}			
			// in case there is only a name with no email address
			else {
				String[] fromHeaders = message.getHeader("From");
				if (fromHeaders != null) {
					fullFromAddressStr = MimeUtility.decodeText(fromHeaders[0]);
				}
			}			
		} catch (MessagingException e) {
		} 
		catch (UnsupportedEncodingException e) {			
		}		
		
		return fullFromAddressStr;
	}
	
	public String getStringListOfNameOrAddressOfAddresses(Address[] addresses) {
		String stringList = "";
		
		if (addresses != null) {
			StringBuilder addressBuilder = new StringBuilder();
			
			for (Address address : addresses) {
				String addressStr = ((InternetAddress)address).getPersonal(); // name part
				if (addressStr == null) {
					addressStr = ((InternetAddress)address).getAddress(); // email address part
				}
				else {
					// decoding is needed for the name part
					try {
						addressStr = MimeUtility.decodeText(addressStr);
					} catch (UnsupportedEncodingException e) {
					}
				}						
				addressBuilder.append(addressStr);
				addressBuilder.append("; ");
			}
			
			stringList = addressBuilder.toString();
			stringList = stringList.substring(0, stringList.length() - 2);	
		}
		
		return stringList;
	}
	
	/**
	 * returns a comma separated string list containing the passed-in addresses. 
	 */
	public String getStringListOfAddresses(Address[] addresses, boolean isPureAscii) {
		String stringList = "";
		
		if (addresses != null) {
			StringBuilder addressBuilder = new StringBuilder();
			for (Address address : addresses) {
				String addressStr = ((InternetAddress)address).getAddress(); // email address part				
				String name = ((InternetAddress)address).getPersonal(); // name part
				
				if (name != null) {
					try {
						// if the name contains Non-Ascii characters(violating the standard), 
						// try to decode it by examining the characters.
						if (!isPureAscii) {
							byte[] rawBytes = name.getBytes("iso-8859-1");
							
							name = decodeNonAsciiBytes(rawBytes);
						}
						else {						
							name = MimeUtility.decodeText(name);
						}
					} catch (UnsupportedEncodingException e) {
					}
					
					addressBuilder.append(name + " <" + addressStr + ">");					
				}
				else {
					addressBuilder.append(addressStr + " <" + addressStr + ">");
				}
				
				addressBuilder.append(",");
			}
			stringList = addressBuilder.toString();
			stringList = stringList.substring(0, stringList.length() - 1);
		}
		
		return stringList;
	}
	
	public String getSubject(Message message) throws Exception {
        String subject = message.getSubject();
        
        if (subject == null) {
        	subject = "";
        }
        
        if (!subject.equals("")) {
            String[] rawHeaders = message.getHeader("subject");
            String rawHeader = rawHeaders[0].trim();
                        
			// 제목이 줄바꿈없이 인코딩 경우가 있어 추가함.
            // Subject: =?ISO-2022-JP?B?GyRCIVobKEIyMDE3LzEyLzA0GyRCJE5MZEJqIVsbKEJPSlQ=?=
            //		 =?ISO-2022-JP?B?GyRCJEszOkV2JDkkayRiJE4kSCRPISkbKEI=?==?iso-2022-jp?B?GyRCIWMbKEJJVBskQiUtJWMlUSVBJWMhPCU4GyhCIA==?=
            //		 =?iso-2022-jp?B?GyRCJVkhPCU3JUMlLyFkGyhC?=                        
			int pos = rawHeader.indexOf("?==?");
			
			if (pos >= 0) {
				StringBuilder sb = new StringBuilder();
				
				sb.append(rawHeader.substring(0, pos + 2));
				sb.append("\r\n ");
				sb.append(rawHeader.substring(pos + 2));
										
				rawHeader = sb.toString();
				
				logger.debug("line broken new subject=" + rawHeader);	
				
				subject = MimeUtility.decodeText(rawHeader);
			}
			
            // Subject: =?utf-8?q?=5b=46=65=64=45...=35=35 ?= 의 경우와 같이 
            // ?= 앞에 공백 문자가 있어 제목이 디코딩 되지 않는 경우가 발견되어 추가함
            if (rawHeader.startsWith("=?") && rawHeader.endsWith(" ?=")) {
            	logger.debug("There is a space before ?=");
            	
            	int lastNonSpaceIndex = rawHeader.length() - 4;
            	
            	while (rawHeader.charAt(lastNonSpaceIndex) == ' ') {
            		lastNonSpaceIndex--;
            	}
            	
            	rawHeader = rawHeader.substring(0, lastNonSpaceIndex + 1) + "?=";
            	subject = MimeUtility.decodeText(rawHeader);
            }
            
            // 표준을 지키지 않고 Non-Ascii 문자가 사용된 경우엔 직접 디코딩을 처리한다.
            if (!isPureAscii(rawHeader)) {
                byte[] rawBytes = rawHeader.getBytes("iso-8859-1");
                
                subject = decodeNonAsciiBytes(rawBytes);
            } else {
                if (rawHeader.startsWith("=?")) {
                    int secondQuestionPos = rawHeader.indexOf("?", 2);
                    int thirdQuestionPos = rawHeader.indexOf("?", secondQuestionPos + 1);
                    String charSetAndEncoding = rawHeader.substring(0, thirdQuestionPos + 1); 
                    String encoding = rawHeader.substring(secondQuestionPos + 1, thirdQuestionPos);                                        
                    
                    // 일부 Mailer에서 RFC 2047에서 정의된 encoded word를 2개 이상의 라인으로 구성할 때
                    // 한글의 한 글자를 표현하는 Byte Array 중간에서 분리하는 경우가 있어(Base64 인코딩을 사용하면서) 
                    // 이 경우 JavaMail에서 디코딩할 때 글자가 깨지는 현상이 발생하여 한 줄로 합치는 작업을 직접 수행하도록 함.  
                    // 글자가 깨지는 경우 Unicode의 Replacement Character인 �가 나타남.
                    if (subject.contains("�")
                            && encoding.equalsIgnoreCase("B")) {
                        String[] sequences = rawHeader.split(charSetAndEncoding.replaceAll("\\?", "\\\\?"));
                        
                        if (sequences.length > 2) {
                            logger.debug("broken multiple sequences. combining them...");
                            logger.debug("original rawHeader:" + rawHeader);
                            
                            StringBuilder combined = new StringBuilder();                        
                            combined.append(charSetAndEncoding);
                            
                            ByteArrayOutputStream combinedBytes = new ByteArrayOutputStream();
                            
                            for (int i = 1; i < sequences.length; i++) {
                                String sequence = sequences[i].trim();
                                
                                logger.debug("sequence[" + i + "]:" + sequence);
                                
                                sequence = sequence.substring(0, sequence.lastIndexOf("?"));
                                combinedBytes.write(Base64.decodeBase64(sequence));                            
                            }
                            
                            combined.append(Base64.encodeBase64String(combinedBytes.toByteArray()));
                            combined.append("?=");
                            rawHeader = combined.toString();
                            
                            logger.debug("combined rawHeader:" + rawHeader);
                            
                            subject = MimeUtility.decodeText(rawHeader);
                            
                            logger.debug("subject=" + subject);
                        }
                    }
                
                    // Exchange에서 온 메일 중에 ks_c_5601-1987로 인코딩되어 있다고 기술되어 있지만 확장 완성형인 ms949에만
                    // 정의되어 있는 글자(샾 같은)가 포함되어 디코딩 시 깨지는 문제가 발생하여 ms949로 디코딩 처리하는 코드를 추가함.
                    String charSet = rawHeader.substring(2, secondQuestionPos).toLowerCase();
                    
                    if (charSet.equals("ks_c_5601-1987")) {
                        rawHeader = rawHeader.replace(charSet, "ms949");
                        
//                        logger.debug("subject changed ks_c_5601-1987 to ms949.");
                        
                        subject = MimeUtility.decodeText(rawHeader);
                    }                        
                }
            }
            
            // 제목 중간에 Unicode 0x0(NULL)이 들어가 XML 파싱시 에러가 발생하는 메일이 발견되어 추가함.
            subject = subject.replaceAll("[\\000]+", "");            
        }
        
        return subject;
	}
	
	public boolean isPureAscii(String str) {
		boolean result = true;
		
		if (str != null) {
			int length = str.length();		
			
	        for (int i = 0; i < length; i++) {
	            char character = str.charAt(i);
	            
	            if (character >= 128) {
	            	result = false;
	            	break;
	            }
	        }		
		}
        
        return result;
	}
	
	public boolean isCharEncRight(byte[] bytes, String charEnc) {
		Charset charset = Charset.forName(charEnc);
		CharsetDecoder decoder = charset.newDecoder();
		decoder.reset();
		
		try {
			decoder.decode(ByteBuffer.wrap(bytes));
		} catch (Exception e){			
			return false;
		}

		return true;
	}
	
	public String decodeNonAsciiBytes(byte[] rawBytes) {
		String result = null;		
		
		try {
			if (isCharEncRight(rawBytes, "utf-8")) {							
				result = new String(rawBytes, "utf-8");
				
				logger.debug("it's UTF-8");
			}
			else if (isCharEncRight(rawBytes, "euc-kr")) {
				result = new String(rawBytes, "euc-kr");
				
				logger.debug("it's EUC-KR");							
			}
			else {
				result = new String(rawBytes, "iso-8859-1");
				
				logger.debug("unknown encoding");														
			}		
		} catch (UnsupportedEncodingException e) {			
		}
		
		return result;
	}
	
	private InputStream getContentInputStream(Part part) throws Exception {
		InputStream is = null; 
		
		try {
			is = part.getInputStream();
		// Content-Transfer-Encoding 값에 문제가 있을 때, IOException이 발생할 수 있다.
		// 예) Content-Type: Text/Html; Charset="utf-8"
		//	  Content-Transfer-Encoding: 
		} catch (IOException ioe) {
			// gerRawInputStream()은 Content-Transfer-Encoding에 의한 Decoding을 수행하지 않은 Raw Data를 반환한다.
			if (part instanceof MimeBodyPart) {
				is = ((MimeBodyPart)part).getRawInputStream();
			} else if (part instanceof MimeMessage) {
				is = ((MimeMessage)part).getRawInputStream();
			}
			else {
				throw ioe;
			}
		}		
		
		return is;
	}
	
	/**
	 * 메일 Multipart 정보 반환 함수
	 */
	public List<String> getBodyInfo(Part part, String folderPath, long uid, 
			int bodyPartIndex, List<Map<String, String>> attachedFileList, boolean forPrint, boolean mobile, Locale locale, 
			String secureKey, String securePassword) throws Exception {
		List<String> resultList = new ArrayList<String>();
		
		String htmlBody = "";
		String pAttachListHtml = "";
		String filesize = "0";
		String filecnt = "0";
		String isAttach = "";
		
		logger.debug("contentType=" + part.getContentType());
		logger.debug("disposition=" + part.getDisposition());
		
		// 아래 if문 조건에 disposition이 attachment인지 체크했는데
		// iphone에서 inline-image를 보냈을 때 inline-image가 mulitpart/related에 들어있지 않고 mulitpart/mixed에 들어있어서
		// 이럴 경우 inline-image가 아닌 attachment로 취급하기로 하여
		// disposition이 attachment인지 체크하는 조건을 뺐다.
		//
		// Content-Type: image/png;
		//   name=IMG_5729.PNG;
		//   x-apple-part-url=EB4D7F71-6AF8-40C0-9F14-67B22A5B404E
		//   Content-Disposition: inline;
		//   filename=IMG_5729.PNG
		//   Content-Transfer-Encoding: base64
		//
		// 본문인(첨부파일이 아닌) text/plain 혹은 text/html에서 Content-Disposition 헤더가 있는 경우가 있어 
		// disposition이 attachment인지 체크하는 조건을 다시 추가함
		// Content-Type: text/plain; charset="UTF-8"
		//		 Content-Disposition: inline
		
		// 다음과 같이 message/rfc822이면서 Content-Disposition에 filename이 없는 경우가 있어
		// 이 경우엔 message/rfc822 type을 처리하는 if문 조건절에서 처리하도록 하기 위해 조건을 추가함.
		// Content-Type: message/rfc822
		// Content-Transfer-Encoding: 7bit
		// Content-Disposition: attachment
		//
		// Content-Disposition 헤더가 없이 첨부된 파일이 있어
		// Content-Type이 application으로 시작하는 경우도 추가함 
		// 예) Content-Type: application/octet-stream;
		//         name="=?utf-8?B?NDExMDAwODE1OS5QREY=?="
	    //    Content-Transfer-Encoding: base64	    										
		if ((part.getDisposition() != null
				&& (part.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)
						|| (part.getContentType() != null && part.getContentType().contains("x-apple-part-url")))
		        && !(part.isMimeType("message/rfc822") && part.getFileName() == null))
				|| part.isMimeType("application/*")) {
            double size = part.getSize();
            String[] encodingHeaders = part.getHeader("Content-Transfer-Encoding");
            
            if (encodingHeaders != null && encodingHeaders.length > 0) {
                String encodingName = encodingHeaders[0];
                
                logger.debug("Content-Transfer-Encoding=" + encodingName);
                
                if (encodingName.equalsIgnoreCase("base64")) {
                    // decrease the size because base64 increases the size to 4/3 times.
                    size = size / 138 * 101;
                }
            }
            
            String strSize = getSizeWithUnit(size);
		    
            String NonAsciiFilename = null;
            String originalFilename = null;
		    String[] headers = part.getHeader("Content-Disposition");
		    
		    if (headers != null && headers.length > 0) {
		        String contentDisposition = headers[0];
		        
		        logger.debug("contentDisposition=" + contentDisposition);
		        
		        // 표준에 의하면 filename은 US-ASCII 로만 어루어져야 하지만 그렇지 않은 비표준 메일들이 있다.
		        // 예) contentDisposition=attachment;   filename="2016³â 2Â÷ ÀÚ»ì¿¹¹æ±³À° ÁöµµÀÚ ¾ç¼º ¾È³».hwp"
		        if (!isPureAscii(contentDisposition)) {
    		        ContentDisposition cd = new ContentDisposition(contentDisposition);
    		        NonAsciiFilename = cd.getParameter("filename");
		        } else {
                    ContentDisposition cd = new ContentDisposition(contentDisposition);
                    originalFilename = cd.getParameter("filename");		            
		        }
		    }
		    
		    logger.debug("NonAsciiFilename=" + NonAsciiFilename);
		    logger.debug("originalFilename=" + originalFilename);
		    
            // part.getFileName 메소드가 반환하는 파일명은 인코딩된 형태인 경우도 있고
            // 디코딩이 수행된 형태인 경우도 있다.
            // 인코딩된 상태로 반환되는 경우 예: =?UTF-8?B?Mu2VmeuFhC56aXA=?=
		    // 디코딩된 상태로 변환되는 경우 예: 료비_20160824 (002)_검토_dhlee.xlsx
		    // 디코딩된 경우 디코딩 이전 인코딩 예: filename*=euc-kr''%B7%E1%BA%F1%5F20160824%20%28002%29%5F%B0%CB%C5%E4%5Fdhlee.xlsx
			String filename = part.getFileName();
			
			logger.debug("filename=" + filename);
			
			if (filename != null) {
				// long filename이 줄바꿈없이 인코딩 경우가 있어 추가함.
				// 예) Content-Type: application/octet-stream; name=
				//        "=?utf-8?B?MTcwNjIwMC00MTkwMDAxOTE1LVQ1MFBCTOyaqSBHQ1UoU042NCntmZXsoJVQTyDrsI8gR0NVM+uM?==?utf-8?B?gChTTiAzLTM3LTc0KSDsiJjrpqzsnoTsi5wgUE8ucGRm?="
				int pos = filename.indexOf("?==?");
				
				if (pos >= 0) {
					StringBuilder sb = new StringBuilder();
					
					sb.append(filename.substring(0, pos));
					
					int nextPos = filename.indexOf("?", pos + 4);
					
					if (nextPos >= 0) {
						nextPos = filename.indexOf("?", nextPos + 1);
						
						if (nextPos >= 0) {
							sb.append(filename.substring(nextPos + 1));
							
							filename = sb.toString();
							
							logger.debug("line broken new filename=" + filename);						
						}
					}				
				}
			}
									
            // Exchange에서 온 메일 중에 ks_c_5601-1987로 인코딩되어 있다고 기술되어 있지만 확장 완성형인 ms949에만
            // 정의되어 있는 글자(샾 같은)가 포함되어 디코딩 시 깨지는 문제가 발생하여 ms949로 디코딩 처리하는 코드를 추가함.
            if (originalFilename != null && originalFilename.startsWith("=?ks_c_5601-1987")) {
                originalFilename = originalFilename.replace("ks_c_5601-1987", "ms949");
                
                logger.debug("originalFilename changed ks_c_5601-1987 to ms949.");
                
                filename = MimeUtility.decodeText(originalFilename);
            } else if (filename != null) {
			    // filename이 US-ASCII 로만 되어 있지 않은 경우는 위에서 part.getFileName 메소드에 의해 디코딩된 경우이므로
			    // 디코딩 처리를 하지 않는다.
				if (isPureAscii(filename)) {
				    // Content-Disposition 헤더에 있는 filename 속성의 값이 Non-Ascii 문자를 포함할 경우에는 직접 디코딩을 처리한다.
                    if (NonAsciiFilename !=  null) {
                        byte[] rawBytes = NonAsciiFilename.getBytes("iso-8859-1");
                        
                        filename = decodeNonAsciiBytes(rawBytes);
                    } else {				    
                        filename = MimeUtility.decodeText(filename);
                    }
				} 
			} else {
				filename = "";
			}
			
			if (attachedFileList != null) {
				Map<String, String> attachedFileInfo = new HashMap<String, String>();
				
				attachedFileInfo.put("filename", filename);
				attachedFileInfo.put("size", String.valueOf(size));
				attachedFileInfo.put("folderPath", folderPath);
				attachedFileInfo.put("uid", String.valueOf(uid));
				attachedFileInfo.put("index", String.valueOf(bodyPartIndex));
				
				attachedFileList.add(attachedFileInfo);
			}
			
			if (forPrint) {
				pAttachListHtml += "<span style='cursor:pointer;'><img src='/images/icon_adddownload.gif' width='16' height='16'></span>";
				pAttachListHtml += "<span><span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666' style='cursor:pointer' >";
				pAttachListHtml += filename + " (" + strSize + ")</span></span></br>";
			} else if (secureKey != null) {
				String aitem = "/ezEmail/downloadSecureAttach.do?secureKey=" + URLEncoder.encode(secureKey, "UTF-8") + "&securePassword=" + URLEncoder.encode(securePassword, "UTF-8") + "&filename=" + URLEncoder.encode(filename, "UTF-8") + "&index=" + bodyPartIndex;
				pAttachListHtml += " <li><span onclick=\"DownloadAttach('" + aitem + "');\" _filehref='" + aitem + "' _filesize='" + size + "' _filename='" + EgovStringUtil.getSpclStrCnvr2(filename) + "' id='MailAttachDownloadItems' name='MailAttachDownloadItems' style='cursor:pointer;' ><img src='/images/icon_adddownload.gif' width='16' height='16'></span>";
				pAttachListHtml += " <span onclick=\"DownloadAttach('" + aitem + "');\"><span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666' style='cursor:pointer' >" + filename + " (" + strSize + ")</span></span></li>";
			} else if (mobile) {
				String aitem = URLEncoder.encode(folderPath,"UTF-8") + "','" + uid + "','" + URLEncoder.encode(filename,"UTF-8") + "','" + bodyPartIndex;
				pAttachListHtml += " <p class=\"ui-bar\" style=\"border-bottom:1px solid #e2e2e2\"><i class='fa fa-download' aria-hidden='true' \"javascript:mailFileDown('" + aitem + "');\" style='cursor:pointer'></i>";
				pAttachListHtml += " <span onclick=\"javascript:mailFileDown('" + aitem + "');\"><span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666' style='cursor:pointer' >" + filename + " (" + strSize + ")</span></span>";
				pAttachListHtml += " </p>";
			} else {
				String aitem = "/ezEmail/downloadAttach.do?mode=Attach&folderPath="+URLEncoder.encode(folderPath,"UTF-8")+"&uid="+uid+"&filename="+URLEncoder.encode(filename,"UTF-8")+"&index="+bodyPartIndex;
				pAttachListHtml += " <li><span onclick=\"DownloadAttach('" + aitem + "');\" _filehref='" + aitem + "' _filesize='" + size + "' _filename='" + EgovStringUtil.getSpclStrCnvr2(filename) + "' id='MailAttachDownloadItems' name='MailAttachDownloadItems' style='cursor:pointer;' ><img src='/images/icon_adddownload.gif' width='16' height='16'></span>";
				pAttachListHtml += " <span onclick=\"DownloadAttach('" + aitem + "');\"><span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666' style='cursor:pointer' >" + filename + " (" + strSize + ")</span></span>";
				pAttachListHtml += " <span class='icon_rbtn' fileid='" + bodyPartIndex + "' onclick=\"AttachFile_Delete(this);\"><img src='/images/icon_reddelete.gif' width='16' height='16'></span></li>";
			}
			
			isAttach = "OK";
			filesize = (Double.parseDouble(filesize) + size) + "";
			filecnt = (Integer.parseInt(filecnt) + 1) + "";
		} else if(part.isMimeType("text/html")){
			String strContent = null;			
			String contentType = part.getContentType();
			
			String[] headers = part.getHeader("Content-Type");
			String rawContentType = "";
			
			if (headers != null) {
				rawContentType = headers[0];
			}
			
			boolean isCharSet = rawContentType.toLowerCase().contains("charset");
			
			try {
				strContent = part.getContent().toString();
								
				if (contentType.toLowerCase().contains("ks_c_5601-1987")) {
		            // Exchange에서 온 메일 중에 ks_c_5601-1987로 인코딩되어 있다고 기술되어 있지만 확장 완성형인 ms949에만
		            // 정의되어 있는 글자(샾 같은)가 포함되어 디코딩 시 깨지는 문제가 발생하여 ms949로 디코딩 처리하는 코드를 추가함.								
					if (strContent.contains("�")) {
						InputStream is = getContentInputStream(part);
						
						if (is.available() > 0) {
							byte[] buf = new byte[is.available()];
							is.read(buf);
							
							logger.debug("text/html changed ks_c_5601-1987 to ms949.");
							
							strContent = new String(buf, "ms949");
						}											
					}
				}
				
				// Content-Type 헤더에 charset 속성이 없는 경우엔 US-ASCII로만 구성되어야 한다.
				// Content-Type: text/html 과 같이 charset이 없지만 본문이 euc-kr로 작성된 메일이 발견되어 추가함.
				if (!isCharSet) {
					logger.debug("rawContentType=" + rawContentType);
					logger.debug("no charset attribute");
					
					// US-ASCII로만 되어 있지 않은 경우 직접 디코딩을 수행한다.
					if (!isPureAscii(strContent)) {
						logger.debug("content isn't ascii only");
						
						InputStream is = getContentInputStream(part); 
						
						if (is.available() > 0) {
							byte[] buf = new byte[is.available()];
							is.read(buf);
							
							strContent = decodeNonAsciiBytes(buf);						
						}							
					}
				}
				
			// charset 등의 값에 문제가 있을 때 Exception이 발생할 수 있다.
			// 예) Content-Type: text/html; charset="$BIZENIC.ENGINE.CHARSET$"
			} catch (Exception e) {
				e.printStackTrace();
				
				InputStream is = getContentInputStream(part); 
										
				if (is.available() > 0) {
					byte[] buf = new byte[is.available()];
					is.read(buf);
					
					strContent = decodeNonAsciiBytes(buf);						
				}
			}
			
			// process in-line images
			int index1 = -1;
			int index2 = -1;
			while ((index1 = strContent.indexOf("src=\"cid:")) > -1 || (index2 = strContent.indexOf("src='cid:")) > -1) {
				char quoteChar;
				int index;
				if (index1 > -1) {
					quoteChar = '"';
					index = index1;
				}
				else {
					quoteChar = '\'';
					index = index2;
				}
				
				int lastindex = index+9;
				while (true) {
					if (lastindex>=strContent.length()) {
						lastindex = -1;
						break;
					}						
					char c = strContent.charAt(lastindex);
					if (c == quoteChar) {
						break;
					}
					++lastindex;
				}
				if (lastindex == -1) {
					break;
				}
				
				String cid = strContent.substring(index+9, lastindex);
				String contentId = "<"+cid+">";
				String orgSrc = "src=" + quoteChar + "cid:" + cid + quoteChar;
				
				if (secureKey != null) {
					strContent = strContent.replace(orgSrc, "src=\"/ezEmail/downloadSecureInline.do?secureKey=" + URLEncoder.encode(secureKey, "UTF-8") + "&securePassword=" + URLEncoder.encode(securePassword, "UTF-8") + "&contentId=" + URLEncoder.encode(contentId, "UTF-8") + "\"");						
				} else {
					strContent = strContent.replace(orgSrc, "src=\"/ezEmail/downloadInline.do?mode=inlineimage&folderPath=" + URLEncoder.encode(folderPath, "UTF-8") + "&uid=" + uid + "&contentId=" + URLEncoder.encode(contentId, "UTF-8") + "\"");						
				}
			}
			htmlBody += strContent;
			
			// style 태그가 1536개인 메일(홈플러스 메일)의 경우 IE에서 로딩이 오래 걸리는 문제가 발생하여 추가함.
			htmlBody = stripTooManyStyleTags(htmlBody);
			
			// XSS(Cross Site Scripting)을 방지하기 위한 처리
			htmlBody = stripScriptTags(htmlBody);
			
			// 메일 본문의 링크를 누르면 별도의 창으로 표시되도록 하는 처리
			htmlBody = addTargetBlank(htmlBody);				
		} else if(part.isMimeType("text/plain")) {
			String strContent = "";
			String[] headers = part.getHeader("Content-Type");
			
			// Content-Type 헤더 자체가 없는 경우, part.isMimeType("text/plain")이 true가 될 수 있으나 part.getContent()는
			// 예외가 발생한다. 이 경우 part.getInputStream()으로부터 직접 디코딩을 수행한다.
			if (headers == null) {
				logger.debug("no Content-Type header");
				
				InputStream is = getContentInputStream(part); 
								
				if (is.available() > 0) {
					byte[] buf = new byte[is.available()];
					is.read(buf);
					
					strContent = decodeNonAsciiBytes(buf);						
				}					
			}
			else {
				String contentType = part.getContentType();
				
				try {
					strContent = part.getContent().toString();
					
					if (contentType.toLowerCase().contains("ks_c_5601-1987")) {
			            // Exchange에서 온 메일 중에 ks_c_5601-1987로 인코딩되어 있다고 기술되어 있지만 확장 완성형인 ms949에만
			            // 정의되어 있는 글자(샾 같은)가 포함되어 디코딩 시 깨지는 문제가 발생하여 ms949로 디코딩 처리하는 코드를 추가함.								
						if (strContent.contains("�")) {
							InputStream is = getContentInputStream(part);
							
							if (is.available() > 0) {
								byte[] buf = new byte[is.available()];
								is.read(buf);
								
								logger.debug("text/plain changed ks_c_5601-1987 to ms949.");
								
								strContent = new String(buf, "ms949");
							}											
						}
					}
					
				// charset 등의 값에 문제가 있을 때 Exception이 발생할 수 있다.
				// 예) Content-Type: text/html; charset="$BIZENIC.ENGINE.CHARSET$"
				} catch (Exception e) {
					e.printStackTrace();
					
					InputStream is = getContentInputStream(part); 
											
					if (is.available() > 0) {
						byte[] buf = new byte[is.available()];
						is.read(buf);
						
						strContent = decodeNonAsciiBytes(buf);						
					}
				}				
			}
			
			String tempText = strContent.replaceAll("\r\n", "<br />").replaceAll("\r", "<br />").replaceAll("\n", "<br />");	
			StringBuilder tempText2 = new StringBuilder();
			String[] tempTexts = tempText.split("<br />");
			
			String defaultFontAndSize = "style='font-size:13px;font-family:" + egovMessageSource.getMessage("main.t246", locale) + "'";
			
			for (int i=0; i<tempTexts.length; i++) {
				if (!tempTexts[i].equals("")) {
					tempText2.append("<p " + defaultFontAndSize + ">" + tempTexts[i] + "</p>");
				}
			}
			
			htmlBody += tempText2.toString();
			
			htmlBody = changeURLsToAnchorTags(htmlBody);	
			htmlBody = stripScriptTags(htmlBody);
			htmlBody = addTargetBlank(htmlBody);
		} else if(part.isMimeType("multipart/alternative")){
			Multipart mp = (Multipart)part.getContent();
			int count = mp.getCount();
			Part p = null;
			
			for (int i = 0; i < count; i++) {
				p = mp.getBodyPart(i);
				
				if (p.isMimeType("text/plain")) {
					logger.debug("contentType=" + p.getContentType());
					logger.debug("disposition=" + p.getDisposition());
				// text/html 파트가 나오거나 multipart/related or mixed 파트가 나올 수도 있다.	
				} else {
					List<String> tempList = getBodyInfo(p, folderPath, uid, -1, attachedFileList, forPrint, mobile, locale, secureKey, securePassword);
					htmlBody += tempList.get(0);
					pAttachListHtml += tempList.get(1);
					filesize = (Double.parseDouble(filesize) + Double.parseDouble(tempList.get(2))) + "";
					filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
					
					if (tempList.get(4).equals("OK")) {
						isAttach = "OK";
					}
				}
			}
			
			if (htmlBody.equals("")) {
				for (int i = 0; i < count; i++) {
					p = mp.getBodyPart(i);
					
					if (p.isMimeType("text/plain")) {
						htmlBody += p.getContent().toString();
					}
				}
			}
		} else if (part.isMimeType("multipart/mixed")) { //재귀
			Multipart mp = (Multipart)part.getContent();
			int count = mp.getCount();
			Part p = null;
			
			for (int i = 0; i < count; i++) {
				p = mp.getBodyPart(i);
				List<String> tempList = getBodyInfo(p, folderPath, uid, i, attachedFileList, forPrint, mobile, locale, secureKey, securePassword);
				htmlBody += tempList.get(0);
				pAttachListHtml += tempList.get(1);
				filesize = (Double.parseDouble(filesize) + Double.parseDouble(tempList.get(2))) + "";
				filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
				
				if (tempList.get(4).equals("OK")) {
					isAttach = "OK";
				}
			}
		} else if (part.isMimeType("multipart/related")) {
			Multipart mp = (Multipart)part.getContent();
			int count = mp.getCount();
			
			for (int i = 0; i < count; i++) {
				Part p = mp.getBodyPart(i);
				
				// text/html 파트가 나오거나 multipart/alternative 파트가 나올 수도 있다.
				if (!p.isMimeType("text/plain") && !(p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.INLINE))) {
					List<String> tempList = getBodyInfo(p, folderPath, uid, -1, attachedFileList, forPrint, mobile, locale, secureKey, securePassword);
					htmlBody += tempList.get(0);
					pAttachListHtml += tempList.get(1);
					filesize = (Double.parseDouble(filesize) + Double.parseDouble(tempList.get(2))) + "";
					filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
					
					if (tempList.get(4).equals("OK")) {
						isAttach = "OK";
					}
				} else {
					logger.debug("contentType=" + p.getContentType());
					logger.debug("disposition=" + p.getDisposition());
				}
			}
		} else if (part.isMimeType("multipart/*")) {
			Multipart mp = (Multipart)part.getContent();
			int count = mp.getCount();
			
			for (int i = 0; i < count; i++) {
				Part p = mp.getBodyPart(i);
				List<String> tempList = getBodyInfo(p, folderPath, uid, i, attachedFileList, forPrint, mobile, locale, secureKey, securePassword);
				htmlBody += tempList.get(0);
				pAttachListHtml += tempList.get(1);
				filesize = (Double.parseDouble(filesize) + Double.parseDouble(tempList.get(2))) + "";
				filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
				
				if (tempList.get(4).equals("OK")) {
					isAttach = "OK";
				}
			}
		} else if (part.isMimeType("message/rfc822")) {
			Message nestedMessage = (Message)part.getContent();
			
			double size = part.getSize();
			String strSize = getSizeWithUnit(size);
			
			String filename = getSubject(nestedMessage);;
			filename = (filename != null) ? filename + ".eml" : "ForwardedMessage.eml";
						
			if (forPrint) {
				pAttachListHtml += "<span style='cursor:pointer;'><img src='/images/icon_adddownload.gif' width='16' height='16'></span>";
				pAttachListHtml += "<span><span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666' style='cursor:pointer' >";
				pAttachListHtml += filename + " (" + strSize + ")</span></span></br>";
			} else if (secureKey != null) {
				String aitem = "/ezEmail/downloadSecureAttach.do?secureKey=" + URLEncoder.encode(secureKey, "UTF-8") + "&securePassword=" + URLEncoder.encode(securePassword, "UTF-8") + "&filename=" + URLEncoder.encode(filename, "UTF-8") + "&index=" + bodyPartIndex;
				pAttachListHtml += " <li><span onclick=\"DownloadAttach('" + aitem + "');\" _filehref='" + aitem + "' _filesize='" + size + "' _filename='" + EgovStringUtil.getSpclStrCnvr2(filename) + "' id='MailAttachDownloadItems' name='MailAttachDownloadItems' style='cursor:pointer;' ><img src='/images/icon_adddownload.gif' width='16' height='16'></span>";
				pAttachListHtml += " <span onclick=\"DownloadAttach('" + aitem + "');\"><span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666' style='cursor:pointer' >" + filename + " (" + strSize + ")</span></span></li>";
			} else if (mobile) {
				String aitem = URLEncoder.encode(folderPath,"UTF-8") + "','" + uid + "','" + URLEncoder.encode(filename,"UTF-8") + "','" + bodyPartIndex;
				pAttachListHtml += " <p class=\"ui-bar\" style=\"border-bottom:1px solid #e2e2e2\"><i class='fa fa-download' aria-hidden='true' onclick=\"javascript:mailFileDown('" + aitem + "');\" style='cursor:pointer'></i>";
				pAttachListHtml += " <span onclick=\"javascript:mailFileDown('" + aitem + "');\"><span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666' style='cursor:pointer' >" + filename + " (" + strSize + ")</span></span>";
				pAttachListHtml += " </p>";
			} else {
				String aitem = "/ezEmail/downloadAttach.do?mode=Attach&folderPath="+URLEncoder.encode(folderPath,"UTF-8")+"&uid="+uid+"&filename="+URLEncoder.encode(filename,"UTF-8")+"&index="+bodyPartIndex;
				pAttachListHtml += " <li><span onclick=\"DownloadAttach('" + aitem + "');\" _filehref='" + aitem + "' _filesize='" + size + "' _filename='" + EgovStringUtil.getSpclStrCnvr2(filename) + "' id='MailAttachDownloadItems' name='MailAttachDownloadItems' style='cursor:pointer;' ><img src='/images/icon_adddownload.gif' width='16' height='16'></span>";
				pAttachListHtml += " <span onclick=\"DownloadAttach('" + aitem + "');\"><span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666' style='cursor:pointer' >" + filename + " (" + strSize + ")</span></span>";
				pAttachListHtml += " <span class='icon_rbtn' fileid='" + bodyPartIndex + "' onclick=\"AttachFile_Delete(this);\"><img src='/images/icon_reddelete.gif' width='16' height='16'></span></li>";
			}
			
			isAttach = "OK";
			filesize = (Double.parseDouble(filesize) + size) + "";
			filecnt = (Integer.parseInt(filecnt) + 1) + "";				
		}

		resultList.add(htmlBody);
		resultList.add(pAttachListHtml);
		resultList.add(filesize);
		resultList.add(filecnt);
		resultList.add(isAttach);
			
		return resultList;
	}
	
    /**
     * 메일에서 Text 부분을 찾아 반환하는 함수
     */
    public List<String> getTextPart(Part part) throws Exception {
        List<String> resultList = new ArrayList<String>();
        
        String textBody = "";
        String contentType = "";
                
        if (part.isMimeType("text/html")) {
            String strContent = null;
            
            try {
                strContent = part.getContent().toString();
            // charset 등의 값에 문제가 있을 때 Exception이 발생할 수 있다.
            // 예) Content-Type: text/html; charset="$BIZENIC.ENGINE.CHARSET$"
            } catch (Exception e) {
                e.printStackTrace();
                
                InputStream is = null; 
                    
                try {
                    is = part.getInputStream();
                // Content-Transfer-Encoding 값에 문제가 있을 때, IOException이 발생할 수 있다.
                // 예) Content-Type: Text/Html; Charset="utf-8"
                //    Content-Transfer-Encoding: 
                } catch (IOException ioe) {
                    // gerRawInputStream()은 Content-Transfer-Encoding에 의한 Decoding을 수행하지 않은 Raw Data를 반환한다.
                    if (part instanceof MimeBodyPart) {
                        is = ((MimeBodyPart)part).getRawInputStream();
                    } else if (part instanceof MimeMessage) {
                        is = ((MimeMessage)part).getRawInputStream();
                    }
                    else {
                        throw ioe;
                    }
                }
                
                if (is.available() > 0) {
                    byte[] buf = new byte[is.available()];
                    is.read(buf);
                    
                    strContent = decodeNonAsciiBytes(buf);                      
                }
            }
            
            textBody = strContent;   
            contentType = "text/html";
        } else if (part.isMimeType("text/plain")) {
            String strContent = "";
            String[] headers = part.getHeader("Content-Type");
            
            // Content-Type 헤더 자체가 없는 경우, part.isMimeType("text/plain")이 true가 될 수 있으나 part.getContent()는
            // 예외가 발생한다. 이 경우 part.getInputStream()으로부터 직접 디코딩을 수행한다.
            if (headers == null) {
                logger.debug("no Content-Type header");
                
                InputStream is = null; 
                
                try {
                    is = part.getInputStream();
                // Content-Transfer-Encoding 값에 문제가 있을 때, IOException이 발생할 수 있다.
                // 예) Content-Transfer-Encoding: 
                } catch (IOException ioe) {
                    // gerRawInputStream()은 Content-Transfer-Encoding에 의한 Decoding을 수행하지 않은 Raw Data를 반환한다.
                    if (part instanceof MimeBodyPart) {
                        is = ((MimeBodyPart)part).getRawInputStream();
                    } else if (part instanceof MimeMessage) {
                        is = ((MimeMessage)part).getRawInputStream();
                    }
                    else {
                        throw ioe;
                    }
                }
                
                if (is.available() > 0) {
                    byte[] buf = new byte[is.available()];
                    is.read(buf);
                    
                    strContent = decodeNonAsciiBytes(buf);                      
                }                   
            }
            else {
                strContent = part.getContent().toString();
            }
            
            textBody = strContent;
            contentType = "text/plain";
        } else if (part.isMimeType("multipart/alternative")) {
            Multipart mp = (Multipart)part.getContent();
            int count = mp.getCount();
            Part p = null;
            
            for (int i = 0; i < count; i++) {
                p = mp.getBodyPart(i);
                
                // text/html 파트가 나오거나 multipart/related or mixed 파트가 나올 수도 있다.
                if (!p.isMimeType("text/plain")) {
                    List<String> tempList = getTextPart(p);
                    textBody = tempList.get(0);
                    contentType = tempList.get(1);
                    break;
                }
            }
            
            if (textBody.equals("")) {
                for (int i = 0; i < count; i++) {
                    p = mp.getBodyPart(i);
                    if (p.isMimeType("text/plain")) {
                        textBody = p.getContent().toString();
                        contentType = "text/plain";
                        break;
                    }
                }
            }
        } else if (part.isMimeType("multipart/related")) {
            Multipart mp = (Multipart)part.getContent();
            int count = mp.getCount();
            for (int i = 0; i < count; i++) {
                Part p = mp.getBodyPart(i);
                
                // text/html 파트가 나오거나 multipart/alternative 파트가 나올 수도 있다.
                if (!p.isMimeType("text/plain") && !(p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.INLINE))) {
                    List<String> tempList = getTextPart(p);
                    textBody = tempList.get(0);
                    contentType = tempList.get(1);

                    if (!contentType.equals("")) {
                        break;            
                    }                    
                }
            }
        } else if (part.isMimeType("multipart/*")) {
            Multipart mp = (Multipart)part.getContent();
            int count = mp.getCount();
            for (int i = 0; i < count; i++) {
                Part p = mp.getBodyPart(i);
                List<String> tempList = getTextPart(p);
                textBody = tempList.get(0);
                contentType = tempList.get(1);
                
                if (!contentType.equals("")) {
                    break;            
                }
            }
        } 
        
        resultList.add(textBody);
        resultList.add(contentType);
            
        return resultList;
    }

	public Message[] searchFolder (
			Folder folder, 
			String searchField, 
			final String searchValue,
			Date startDate,
			Date endDate,
			boolean searchSubFolder,
			SearchTerm existingSearchTerm,
			boolean isUnreadOnly,
			boolean isImportantOnly) throws Exception {		
		return this.searchFolder(folder, searchField, searchValue, startDate, endDate, searchSubFolder, existingSearchTerm, isUnreadOnly, isImportantOnly, false);
	}
	
	/**
	 * searches an open folder for messages matching the specified criterion. 
	 */
	public Message[] searchFolder (
			Folder folder, 
			String searchField, 
			final String searchValue,
			Date startDate,
			Date endDate,
			boolean searchSubFolder,
			SearchTerm existingSearchTerm,
			boolean isUnreadOnly,
			boolean isImportantOnly,
			boolean isFromMobile
			) throws Exception {
		logger.debug("searchFolder started.");
		
		Message[] messages = folder.getMessages();
		
		logger.debug("searchField=" + searchField + ",startDate=" + startDate + ",endDate=" + endDate + ",isImportantOnly=" + isImportantOnly);
		logger.debug("isUnreadOnly=" + isUnreadOnly + ",isFromMobile=" + isFromMobile);
		
		SearchTerm sTerm = existingSearchTerm; 
		
		if (sTerm == null) {
			if (searchField.equalsIgnoreCase("SUBJECT")) {
				sTerm = new SearchTerm() {
				    public boolean match(Message message) {
				        try {
				        	String subject = getSubject(message);				        	
				        	
				            if (subject != null && subject.toLowerCase().contains(searchValue.toLowerCase())) {
				                return true;
				            }
				        } 
				        catch (Exception e) {
				        }
				        
				        return false;
				    }
				};					
			}
			else if (searchField.equalsIgnoreCase("FROM")) {
				sTerm = new SearchTerm() {
				    public boolean match(Message message) {
			        	String from = getFullFromAddressOfMessage(message);
			            if (from != null && from.toLowerCase().contains(searchValue.toLowerCase())) {
			                return true;
			            }
				        
				        return false;
				    }
				};					
			}
			else if (searchField.equalsIgnoreCase("RECEIVE")) {
				sTerm = new SearchTerm() {
				    public boolean match(Message message) {
				    	if (",<>@".contains(searchValue)) {
				    		return false;
				    	}
				    	
				    	try {
					    	StringBuilder sb = new StringBuilder();
					    	
					    	// retrieve the TO addresses from the message.
							Address[] addresses = message.getRecipients(Message.RecipientType.TO);
							String[] rawHeaders = message.getHeader("To");
							String rawHeader = rawHeaders != null ? rawHeaders[0] : "";							
							String to = getStringListOfAddresses(addresses, isPureAscii(rawHeader));
							
							if (!to.equals("")) {
								sb.append(to);
							}
							
							// retrieve the CC addresses from the message.
							addresses = message.getRecipients(Message.RecipientType.CC);
							rawHeaders = message.getHeader("Cc");
							rawHeader = rawHeaders != null ? rawHeaders[0] : "";														
							String cc = getStringListOfAddresses(addresses, isPureAscii(rawHeader));
							
							if (!cc.equals("")) {
								if (!to.equals("")) {
									sb.append(",");
								}
								
								sb.append(cc);
							}
							
							// retrieve the BCC addresses from the message.
							addresses = message.getRecipients(Message.RecipientType.BCC);
							String bcc = getStringListOfAddresses(addresses, true);
	
							if (!bcc.equals("")) {
								if (!to.equals("") || !cc.equals("")) {
									sb.append(",");
								}
								
								sb.append(bcc);
							}							
					    	
				            if (sb.toString().toLowerCase().contains(searchValue.toLowerCase())) {
				                return true;
				            }
				    	}
				    	catch (MessagingException e) {					    		
				    	}
				        
				        return false;
				    }
				};					
			}
			else if (searchField.equalsIgnoreCase("CONTENT")) {
//				sTerm = new BodyTerm(searchValue);
			    
                sTerm = new SearchTerm() {
                    public boolean match(Message message) {
                        try {
                            ((IMAPMessage)message).setPeek(true);
                            List<String> bodyInfoList = getTextPart(message);
                            String textBody = bodyInfoList.get(0);
                            String contentType = bodyInfoList.get(1);
                            
                            // html의 경우엔 html tag를 제거한다.
                            if (textBody != null && contentType.equals("text/html")) {
                                Pattern p = Pattern.compile("\\s*<(head|title|style)(.*?)<\\/(head|title|style)>\\s*", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
                                Matcher m = p.matcher(textBody);
                                textBody = m.replaceAll("");
                                
                                p = Pattern.compile("\\s*<.*?>\\s*", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
                                m = p.matcher(textBody);
                                textBody = m.replaceAll("").trim();

                                p = Pattern.compile("&nbsp;");
                                m = p.matcher(textBody);
                                textBody = m.replaceAll(" ");

                                p = Pattern.compile("&lt;");
                                m = p.matcher(textBody);
                                textBody = m.replaceAll("<");
                                
                                p = Pattern.compile("&gt;");
                                m = p.matcher(textBody);
                                textBody = m.replaceAll(">");

                                p = Pattern.compile("&amp;");
                                m = p.matcher(textBody);
                                textBody = m.replaceAll("&");                                
                            }
                            
//                            logger.debug("contentType=" + contentType + ",textBody=" + textBody);
//                            logger.debug("searchValue=" + searchValue);
                            
                            if (textBody != null) {                                
                                Pattern p = Pattern.compile(searchValue, Pattern.CASE_INSENSITIVE);
                                Matcher m = p.matcher(textBody);
                                
                                if (m.find()) {
                                    return true;
                                }                      
                            }
                        } 
                        catch (Exception e) {
                        }
                        
                        return false;
                    }
                };                  			    
			}
			
			if (searchField.equalsIgnoreCase("SUBJECT&FROM")) {
				logger.debug("if SUBJECT&FROM start");
				sTerm = new SearchTerm() {
				    public boolean match(Message message) {
				        try {
				        	String subject = getSubject(message);				        	
				        	String from = getFullFromAddressOfMessage(message);
				        	
				        	boolean subjectFlag = subject != null && subject.toLowerCase().contains(searchValue.toLowerCase()); 
				        	boolean fromFlag = from != null & from.toLowerCase().contains(searchValue.toLowerCase());
				        	
				            if (subjectFlag || fromFlag) {
				                return true;
				            }
				        } 
				        catch (Exception e) {
				        }
				        
				        return false;
				    }
				};					
			}
			
			if (searchField.equalsIgnoreCase("SUBJECT&TO")) {
				logger.debug("if SUBJECT&TO start");
				sTerm = new SearchTerm() {
				    public boolean match(Message message) {
				        try {
				        	String subject = getSubject(message);				        	
				        	String from = getFullFromAddressOfMessage(message);
				        	
				        	boolean subjectFlag = subject != null && subject.toLowerCase().contains(searchValue.toLowerCase()); 
				        	boolean toFlag = toSearch(message, searchValue);
				        	
				            if (subjectFlag || toFlag) {
				                return true;
				            }
				        } 
				        catch (Exception e) {
				        }
				        
				        return false;
				    }
				};					
			}
		}
		
		if (sTerm != null) {
			// pre-fetch fields needed for searching
			if (!searchField.equalsIgnoreCase("CONTENT")) {
				FetchProfile fp = new FetchProfile();
				fp.add(FetchProfile.Item.ENVELOPE);
				fp.add(IMAPFolder.FetchProfileItem.HEADERS);
				folder.fetch(messages, fp);
			}
			
			if (startDate != null) {
				sTerm = new AndTerm(sTerm, new ReceivedDateTerm(DateTerm.GT, startDate));
			}

			if (endDate != null) {
				sTerm = new AndTerm(sTerm, new ReceivedDateTerm(DateTerm.LT, endDate));
			}
			
			if (isUnreadOnly) {
				sTerm = new AndTerm(sTerm, new FlagTerm(new Flags(Flags.Flag.SEEN), false));
			}
			
			if (isImportantOnly) {
				sTerm = new AndTerm(sTerm, new FlagTerm(new Flags(Flags.Flag.FLAGGED), true));
			}
			
			messages = folder.search(sTerm);
			
			Folder[] subFolders = folder.list();
			
			// search the sub folders and combine the results.			
			if (searchSubFolder) {
				for (Folder subFolder : subFolders) {
					subFolder.open(Folder.READ_ONLY);
					Message[] subMessages = searchFolder(subFolder, searchField, searchValue, startDate, endDate, searchSubFolder, sTerm, isUnreadOnly, isImportantOnly);
					
					if (subMessages.length > 0) {
					   int mainLen = messages.length;
					   int subLen = subMessages.length;
					   Message[] combined = new Message[mainLen + subLen];
					   System.arraycopy(messages, 0, combined, 0, mainLen);
					   System.arraycopy(subMessages, 0, combined, mainLen, subLen);	
					   
					   messages = combined;
					}
				}
			}
		}		
		else if (isUnreadOnly) {
			sTerm = new FlagTerm(new Flags(Flags.Flag.SEEN), false);
			
			messages = folder.search(sTerm);
			logger.debug("UnRead Message Count : " + messages.length);
		}
		else if (isImportantOnly) {
			sTerm = new FlagTerm(new Flags(Flags.Flag.FLAGGED), true);
			
			messages = folder.search(sTerm);
			logger.debug("Important Message Count : " + messages.length);
		} 
		else {
//			messages = null;
		}
		
		if (isFromMobile && endDate != null && startDate == null) {
			if (sTerm == null) { // filter search 없을 때
				ArrayList<Message> arrayList = new ArrayList<>();

				Date from = endDate;       
				Folder f = folder;

				int end = f.getMessageCount();       
				long lFrom = from.getTime(); //endDate

				Date rDate; //message Date       
				long lrDate; //message Date long for comparing endDate

				Message orgMsg[] = f.getMessages();
				
				if (orgMsg.length > 0) {
					this.sortMessages(folder, orgMsg, "receivedDate", true);
					
					int j = 0;
					
					do {                
						Message testMsg = orgMsg[end-1];         
						rDate = testMsg.getReceivedDate();         
						lrDate = rDate.getTime();
						end--;
						
						if (lrDate < lFrom) {
							arrayList.add(testMsg);
							j++;
						}
					} while (j < 30 && end > 0);// 더 빨리 온 메세지를 뽑는다.
				}
				
				Message msg[] = arrayList.toArray(new Message[arrayList.size()]);

				return msg;
			// filter 있을 때				
			} else {				
				ArrayList<Message> arrayList = new ArrayList<>();
				
				Date from = endDate;       
				Folder f = folder;
				
				Message orgMsg[] = f.search(sTerm);
				
				int end = orgMsg.length;       
				long lFrom = from.getTime(); //endDate
				
				Date rDate; // message Date       
				long lrDate; // message Date long for comparing endDate       
				int j = 0;
								
				if (orgMsg.length > 0) {
					this.sortMessages(folder, orgMsg, "receivedDate", true);
					
					do {                
						Message testMsg = orgMsg[end-1];         
						rDate = testMsg.getReceivedDate();         
						lrDate = rDate.getTime();
						end--;
						
						if (lrDate < lFrom) {
							if (isUnreadOnly || isImportantOnly) {
								if (isUnreadOnly && !testMsg.isSet(Flags.Flag.SEEN)) {
									arrayList.add(testMsg);
									j++;
								} else if (isImportantOnly && testMsg.isSet(Flags.Flag.FLAGGED)) {
									arrayList.add(testMsg);
									j++;
								}
							} else {
								arrayList.add(testMsg);
								j++;
							}
						}
					} while (j < 30 && end > 0);// 더 빨리 온 메세지를 뽑는다.
				}
				
				Message msg[] = arrayList.toArray(new Message[arrayList.size()]);
				
				messages = msg;
			}
		}
		
		logger.debug("searchFolder ended.");
		return messages;
	}
	
	public MimeMessage deleteAttach(SMTPAccess sa, Message oldMessage, int[] index) {
		MimeMessage newMessage = null;
		
		try {
			newMessage = sa.createMimeMessage();
			
			//set body
			Multipart mp = (Multipart)oldMessage.getContent();
			BodyPart p = null;
			int length = index.length;
			for (int i = 0; i < length; i++) {
				if (index[i] < 0) {
					continue;
				}
				p = mp.getBodyPart(index[i]);
				if ((p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)) || 
						p.isMimeType("message/rfc822")) {
					mp.removeBodyPart(index[i]);
				}
			}
			if (mp.getCount() == 0) {
				return null;
			}
			newMessage.setContent(mp);
			
			//set header
			Enumeration<Header> e = oldMessage.getAllHeaders();
			while(e.hasMoreElements()){
				Header header = e.nextElement();
				newMessage.setHeader(header.getName(), header.getValue());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return newMessage;
	}
	
	public boolean copyInlineParts(Part src, Multipart dest) throws MessagingException, IOException {
		if (src.isMimeType("multipart/related")) {
			Multipart mp = (Multipart)src.getContent();
			int count = mp.getCount();
			boolean isAdded = false;
			for (int i = 0; i < count; i++) {
				BodyPart p = mp.getBodyPart(i);
				
				if (p instanceof MimePart) {
					if (((MimePart)p).getContentID() != null) {
						dest.addBodyPart(p);	
						isAdded = true;
					}
				}				
			}
			
			return isAdded;
		} 
		else if (src.isMimeType("multipart/*")) {
			Multipart mp = (Multipart)src.getContent();
			int count = mp.getCount();
			for (int i = 0; i < count; i++) {
				BodyPart p = mp.getBodyPart(i);
				
				if (copyInlineParts(p, dest)) {
					return true;
				}
			}
		}
		
		return false;
	}
	
	/**
	 * 메일 리스트 정렬 실행 함수
	 */
	public void sortMessages(Folder folder, Message[] messages, String sortTypeSpecifier, boolean isAscending) throws Exception {
		logger.debug("sortMessages started.");
		logger.debug("sortTypeSpecifier=" + sortTypeSpecifier + ",isAscending=" + isAscending);
		
		Comparator<Message> comparator = null;
		
		// subject
		if (sortTypeSpecifier.equals("subject")) {
			comparator = new IMAPAccess.MessageSubjectComparator();
			
			if (!isAscending) {
				comparator = Collections.reverseOrder(comparator);
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.ENVELOPE);
			folder.fetch(messages, fp);			
		}
		// sender
		else if (sortTypeSpecifier.equals("sender")) {
			comparator = new IMAPAccess.MessageAddressComparator(true);
			
			if (!isAscending) {
				comparator = Collections.reverseOrder(comparator);
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.ENVELOPE);
			folder.fetch(messages, fp);
		}		
		// recipient
		else if (sortTypeSpecifier.equals("recipient")) {
			comparator = new IMAPAccess.MessageAddressComparator(false);
			
			if (!isAscending) {
				comparator = Collections.reverseOrder(comparator);
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.ENVELOPE);
			folder.fetch(messages, fp);
		}				
		// attachment
		else if (sortTypeSpecifier.equals("attachment")) {
			comparator = new IMAPAccess.MessageAttachmentComparator();
			
			if (!isAscending) {
				comparator = Collections.reverseOrder(comparator);
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.CONTENT_INFO);
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			folder.fetch(messages, fp);
		}				
		// read/unread
		else if (sortTypeSpecifier.equals("readFlag")) {
			comparator = new IMAPAccess.MessageUnreadComparator();
			
			if (!isAscending) {
				comparator = Collections.reverseOrder(comparator);
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.FLAGS);
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			folder.fetch(messages, fp);
		}		
		// bookmark
		else if (sortTypeSpecifier.equals("flag")) {
			comparator = new IMAPAccess.MessageFlaggedComparator();
			
			if (!isAscending) {
				comparator = Collections.reverseOrder(comparator);
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.FLAGS);
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			folder.fetch(messages, fp);
		}								
		// importance
		else if (sortTypeSpecifier.equals("importance")) {
			comparator = new IMAPAccess.MessagePriorityComparator();
			
			if (!isAscending) {
				comparator = Collections.reverseOrder(comparator);
			}
								
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(IMAPFolder.FetchProfileItem.HEADERS);
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			folder.fetch(messages, fp);
		}								
		// size
		else if (sortTypeSpecifier.equals("size")) {
			comparator = new IMAPAccess.MessageSizeComparator();
			
			if (!isAscending) {
				comparator = Collections.reverseOrder(comparator);
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.SIZE);
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			folder.fetch(messages, fp);
		}			
		// received date
		else if (sortTypeSpecifier.equals("receivedDate")) {
			comparator = new IMAPAccess.MessageReceivedDateComparator();
			
			if (!isAscending) {
				comparator = Collections.reverseOrder(comparator);
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			folder.fetch(messages, fp);
		}			
		
		if (comparator != null) {			
			Arrays.sort(messages, comparator);
		}
		
		logger.debug("sortMessages ended.");
	}
	
	public boolean copyAllPartsInMultipart(Part src, Multipart dest) throws MessagingException, IOException {
		if (src.isMimeType("multipart/*")) {
			Multipart mp = (Multipart)src.getContent();
			int count = mp.getCount();
			for (int i = 0; i < count; i++) {
				BodyPart p = mp.getBodyPart(i);
				
				dest.addBodyPart(p);										
			}
			
			return true;
		} 
		
		return false;
	}
	
	/**
	 * 메일 첨부파일 Part 반환 함수
	 */
	public Part getAttachPart(Part part, int index) throws MessagingException, IOException {
		logger.debug("getAttachPart started.");
		
		if (part.isMimeType("multipart/mixed") || part.isMimeType("multipart/report")){
			Part p = ((Multipart)part.getContent()).getBodyPart(index);
			
			logger.debug("getAttachPart ended.");
			return p;
		// multipart/alternative 안에 multipart/mixed가 있는 경우의 처리
		} else if (part.isMimeType("multipart/*")) {
            Multipart mp = (Multipart)part.getContent();
            int count = mp.getCount();
            
            for (int i = 0; i < count; i++) {
                Part p = getAttachPart(mp.getBodyPart(i), index);
                
                if (p != null) {
                    return p;
                }
            }
		}
		
		logger.debug("getAttachPart ended.");
		return null;
	}
	
	/**
	 * 메일 인라인 이미지 Part 반환 함수
	 */
	public Part getInlinePart(Part part, String contentId) throws MessagingException, IOException{
		logger.debug("getInlinePart started.");
		
		if(part.isMimeType("multipart/related")){
			Multipart mp = (Multipart)part.getContent();
			int count = mp.getCount();
			for (int i = 0; i < count; i++) {
				Part p = mp.getBodyPart(i);
				if(p instanceof MimePart){
					if(((MimePart)p).getContentID()!=null && ((MimePart)p).getContentID().equals(contentId)){
						logger.debug("getInlinePart ended.");
						return p;
					}
				}
			}
		} else if(part.isMimeType("multipart/*")){
			Multipart mp = (Multipart)part.getContent();
			int count = mp.getCount();
			Part p = null;
			for (int i = 0; i < count; i++) {
				p = getInlinePart(mp.getBodyPart(i), contentId);
				if(p != null){
					logger.debug("getInlinePart ended.");
					return p;
				}
			}
		}
		
		logger.debug("getInlinePart ended.");
		return null;
	}
	
	/**
	 * returns an array of long of size 2.
	 * first element is hour of time offset and
	 * second element is minute of time offset
	 */
	public long[] getTimeOffsetInHourAndMinute() {
		TimeZone tz = TimeZone.getDefault();
		long hours = TimeUnit.MILLISECONDS.toHours(tz.getRawOffset());
		long minutes = TimeUnit.MILLISECONDS.toMinutes(tz.getRawOffset())
						- TimeUnit.HOURS.toMinutes(hours);	
		
		long[] timeOffset = new long[2];
		timeOffset[0] = hours;
		timeOffset[1] = minutes;
		
		return timeOffset;
	}

	/**
     * JMocha Gateway Server로 HTTP POST로 요청을 보내고 그 결과를 반환한다. 
	 */
	public String getWebServiceResult(String urlString, String inputParams) throws Exception {
		logger.debug("urlString=" + urlString);
		
		String result = null;
		
		URL url = new URL(urlString);
		HttpURLConnection conn = null;
				
		try {
			conn = (HttpURLConnection) url.openConnection();
			
			// POST 방식으로 요청한다.
			conn.setDoOutput(true);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");	
			
			// 입력 패러메터값이 있는 경우엔 HTTP Body로 출력한다.
			if (inputParams != null) {
				OutputStream os = conn.getOutputStream();
				// UTF-8로 인코딩한다.
				os.write(inputParams.getBytes("UTF-8"));
				os.flush();
			}
			
			if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
				// Response Body를 UTF-8로서 디코딩한다.			
				BufferedReader br = new BufferedReader(
											new InputStreamReader(conn.getInputStream(),"UTF-8")
											);
	
				StringBuilder sb = new StringBuilder();
				String output;
	
				while ((output = br.readLine()) != null) {
					sb.append(output);
				}
				
				result = sb.toString();
				
				conn.disconnect();		
				conn = null;
			}
			else {
				Exception e = new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());			
				
				throw e;
			} 
		} finally {
			if (conn != null) {
				conn.disconnect();
				conn = null;
			}
		}
		
		return result;
	}    
	
	public boolean hasForwardedFlag(Message message) throws MessagingException {
		boolean isForwarded = false;
		String[] flags = message.getFlags().getUserFlags();	
		
		for (String flag : flags) {
			if (flag.equals("$Forwarded")) {
				isForwarded = true;
				break;
			}
		}

		return isForwarded;
	}
	
	public void setForwardedFlag(Message message, boolean isSet) throws MessagingException {
		Flags forwardedFlag = new Flags("$Forwarded");
		
		message.setFlags(forwardedFlag, isSet);
	}

	public boolean hasMDNSentFlag(Message message) throws MessagingException {
		boolean isMDNSent = false;
		String[] flags = message.getFlags().getUserFlags();		
		
		for (String flag : flags) {
			if (flag.equals("$MDNSent")) {
				isMDNSent = true;
				break;
			}
		}

		return isMDNSent;
	}
	
	public void setMDNSentFlag(Message message, boolean isSet) throws MessagingException {
		Flags mdnSentFlag = new Flags("$MDNSent");
		
		message.setFlags(mdnSentFlag, isSet);
	}
	
	public boolean hasSecureMailFlag(Message message) throws MessagingException {
		boolean isSecureMail = false;
		String[] flags = message.getFlags().getUserFlags();		
		
		for (String flag : flags) {
			if (flag.equals("$SecureMail")) {
				isSecureMail = true;
				break;
			}
		}

		return isSecureMail;
	}
	
	public void setSecureMailFlag(Message message, boolean isSet) throws MessagingException {
		Flags secureMailFlag = new Flags("$SecureMail");
		
		message.setFlags(secureMailFlag, isSet);
	}
	
	public List<String> getInnerDomain(int tenantId) throws Exception {
		List<String> innerDomainList = new ArrayList<String>();
		
		String mailInnerDomain = ezCommonService.getTenantConfig("MailInnerDomain", tenantId);
		String[] innerDomainArr = mailInnerDomain.split(";");
		
		for (int i=0; i<innerDomainArr.length; i++) {
			innerDomainList.add(innerDomainArr[i]);
		}
		
		return innerDomainList;
	}
	
	/**
	 * 특정 메일 도메인에 대한 메일박스 디폴트 용량을 MB단위로 반환한다.
	 * @param domainName
	 * @return
	 */
	public Double[] getDefaultQuota(String domainName) throws Exception {
	    Double returnedData[] = {null, null};
	    
        String param1 = "domainName=" + domainName;
        String inputParams = param1;            
        
        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getDefaultQuota";
        
        String response = getWebServiceResult(requestURL, inputParams);
        
        logger.debug("getDefaultQuota response=" + response);
   
        if (response != null) {
            JSONParser jsonParser = new JSONParser();
            JSONObject responseObj = null;
            
            responseObj = (JSONObject)jsonParser.parse(response);                    
            String resultCode = (String)responseObj.get("resultCode");
            int reasonCode = ((Long)responseObj.get("reasonCode")).intValue();                        
            
            if (resultCode.equalsIgnoreCase("OK")) {
                if (reasonCode == 0) {
                    JSONObject result = (JSONObject)responseObj.get("result");
                    
                    if (result != null) {
                        String maxStorage = (String)result.get("maxStorage");
                        double maxDouble = Double.parseDouble(maxStorage);                        
                        returnedData[0] = maxDouble;

                        String warnStorage = (String)result.get("warnStorage");
                        double warnDouble = Double.parseDouble(warnStorage);                        
                        returnedData[1] = warnDouble;
                        
                        logger.debug("maxStorage=" + maxStorage + ",warnStorage=" + warnStorage);                                                                
                    }
                }
            }                    
        }                 
        
        return returnedData;
    }    
    
	/**
	 * 특정 메일 도메인에 대한 메일박스 디폴트 용량을 MB단위로 설정한다.
	 * @param domainName
	 * @param maxStorage
	 * @throws Exception
	 */
	public void setDefaultQuota(String domainName, String maxStorage, String warnStorage) throws Exception {
        String param1 = "domainName=" + domainName;
        String param2 = "maxStorage=" + maxStorage;
        String param3 = "warnStorage=" + warnStorage;
        String inputParams = param1 + "&" + param2 + "&" + param3;            
        
        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/setDefaultQuota";
        
        String response = getWebServiceResult(requestURL, inputParams);
        
        logger.debug("setDefaultQuota response=" + response);
   
        if (response != null) {
            JSONParser jsonParser = new JSONParser();
            JSONObject responseObj = null;
            
            responseObj = (JSONObject)jsonParser.parse(response);                    
            String resultCode = (String)responseObj.get("resultCode");
            int reasonCode = ((Long)responseObj.get("reasonCode")).intValue();                        
            
            if (!resultCode.equalsIgnoreCase("OK") || reasonCode != 0) {
                throw new Exception("setDefaultMaxStorage failed");
            }                    
        }                 
    }    
    
	/**
	 * 특정 사용자에 대한 메일박스 최대 용량을 MB단위로 반환한다.
	 * @param userEmail
	 * @return
	 */
    public Double[] getUserQuota(String userEmail) throws Exception {
        Double returnedData[] = {null, null};
        
        String param1 = "userEmail=" + userEmail;
        String inputParams = param1;            
        
        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getUserQuota";
        
        String response = getWebServiceResult(requestURL, inputParams);
        
        logger.debug("getUserQuota response=" + response);
   
        if (response != null) {
            JSONParser jsonParser = new JSONParser();
            JSONObject responseObj = null;
            
            responseObj = (JSONObject)jsonParser.parse(response);                    
            String resultCode = (String)responseObj.get("resultCode");
            int reasonCode = ((Long)responseObj.get("reasonCode")).intValue();                        
            
            if (resultCode.equalsIgnoreCase("OK")) {
                if (reasonCode == 0) {
                    JSONObject result = (JSONObject)responseObj.get("result");
                    
                    if (result != null) {
                        String maxStorage = (String)result.get("maxStorage");
                        double maxDouble = Double.parseDouble(maxStorage);                        
                        returnedData[0] = maxDouble;

                        String warnStorage = (String)result.get("warnStorage");
                        double warnDouble = Double.parseDouble(warnStorage);                        
                        returnedData[1] = warnDouble;
                        
                        logger.debug("maxStorage=" + maxStorage + ",warnStorage=" + warnStorage);                                                                                         
                    }
                }
            }                    
        }                 
        
        return returnedData;
    }    
    
    /**
     * 특정 사용자에 대한 메일박스 최대 용량을 MB단위로 설정한다.
     * @param domainName
     * @param maxStorage
     * @throws Exception
     */
    public void setUserQuota(String userEmail, String maxStorage, String warnStorage) throws Exception {
        String param1 = "userEmail=" + userEmail;
        String param2 = "maxStorage=" + maxStorage;
        String param3 = "warnStorage=" + warnStorage;
        String inputParams = param1 + "&" + param2 + "&" + param3;            
        
        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/setUserQuota";
        
        String response = getWebServiceResult(requestURL, inputParams);
        
        logger.debug("setUserQuota response=" + response);
   
        if (response != null) {
            JSONParser jsonParser = new JSONParser();
            JSONObject responseObj = null;
            
            responseObj = (JSONObject)jsonParser.parse(response);                    
            String resultCode = (String)responseObj.get("resultCode");
            int reasonCode = ((Long)responseObj.get("reasonCode")).intValue();                        
            
            if (!resultCode.equalsIgnoreCase("OK") || reasonCode != 0) {
                throw new Exception("setUserQuota failed");
            }                    
        }                 
    }    
    
    /**
     * 특정 사용자에 대한 메일박스 최대 용량 설정을 제거한다.
     * @param userEmail
     * @throws Exception
     */
    public void deleteUserQuota(String userEmail) throws Exception {
        String param1 = "userEmail=" + userEmail;
        String inputParams = param1;            
        
        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/deleteUserQuota";
        
        String response = getWebServiceResult(requestURL, inputParams);
        
        logger.debug("deleteUserQuota response=" + response);
   
        if (response != null) {
            JSONParser jsonParser = new JSONParser();
            JSONObject responseObj = null;
            
            responseObj = (JSONObject)jsonParser.parse(response);                    
            String resultCode = (String)responseObj.get("resultCode");
            int reasonCode = ((Long)responseObj.get("reasonCode")).intValue();                        
            
            if (!resultCode.equalsIgnoreCase("OK") || reasonCode != 0) {
                throw new Exception("deleteUserQuota failed");
            }                    
        }                 
    }    
    
    /**
     * 비즈메카 스팸편지함과 연동하기 위한 Credential을 반환하는 메소드
     * @param emailAddress 스팸편지함 사용자의 이메일 주소
     * @return
     * @throws Exception
     */
    public String getCredentialForBizmekaSpambox(String emailAddress) throws Exception {
    	String credential = null;
    	
    	if (emailAddress != null && !emailAddress.equals("")) {
	    	byte[] keyBytes = "bizmGW02".getBytes("UTF-8");
	    	byte[] ivBytes = "mekaGW02".getBytes("UTF-8");
	    	byte[] input = emailAddress.getBytes("UTF-8");
	    	
	    	SecretKeySpec key = new SecretKeySpec(keyBytes, "DES");
	    	IvParameterSpec ivSpec = new IvParameterSpec(ivBytes);
	    	Cipher cipher = Cipher.getInstance("DES/CBC/PKCS5Padding");
	    	
	    	cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec);
	    	byte[] encrypted= new byte[cipher.getOutputSize(input.length)];
	    	int enc_len = cipher.update(input, 0, input.length, encrypted, 0);
	    	enc_len += cipher.doFinal(encrypted, enc_len);  
	    	
	    	credential = toHexString(encrypted);
    	}
    	
    	return credential;
    }
    
    /**
     * Bizmeka API를 호출할 때 인증을 위해 관리자의 id와 pw를 이 메소드를 사용해 암호화한 후 보낸다.
     * 현재 구현은 Tenant Config에 이미 암호화된 형태로 입력해 놓았기 때문에(BizmekaAdminId와 BizmekaAdminPw)
     * App내에서 이 메소드를 직접 호출하지는 않는다.
     * @param value
     * @return
     * @throws Exception
     */
    public String getEncryptedCredentialForBizmekaAPI(String value) throws Exception {
    	String encryptedValue = "";
    	
    	// RSA 키의 Modulus를 대입
    	String modulusInBase64 = "iWJy6wVrRTu4FcieK+FOyVaoxhMC0Ng6APQD5wefVEWFbcx8S9iOtj+JOith3XYeZi9E3+0rqhwgcGKDYryYRMrmWDAcLqwWHO/Cp9EX3uQw3GDLSwo4TwkwcXhtAwKXL5mttkX76p9eSUWwbKLRq+Eq+0oeh6ZUkcYLiwIY5Q8=";
    	// RSA 키의 Exponent를 대입
    	String exponentInBase64 = "AQAB";
    	
    	java.util.Base64.Decoder decoder = java.util.Base64.getDecoder();
    	String modulusInHex = toHexString(decoder.decode(modulusInBase64));
    	String exponentInHex = toHexString(decoder.decode(exponentInBase64));

    	BigInteger modulus = new BigInteger(modulusInHex, 16);
    	BigInteger pubExp = new BigInteger(exponentInHex, 16);

    	KeyFactory keyFactory = KeyFactory.getInstance("RSA");
    	RSAPublicKeySpec pubKeySpec = new RSAPublicKeySpec(modulus, pubExp);
    	RSAPublicKey key = (RSAPublicKey) keyFactory.generatePublic(pubKeySpec);
    	Cipher cipher = Cipher.getInstance("RSA");
    	cipher.init(Cipher.ENCRYPT_MODE, key);
    	
    	byte[] cipherData = cipher.doFinal(value.getBytes());
    	
    	encryptedValue = toHexString(cipherData);
    	
    	return encryptedValue;
    }
    
    public String bizmekaAddSubtitle(String bizmekaAdminId, String bizmekaAdminPw, String companyId, String userId, 
    					String deptId, String title1, String title2) throws Exception {
    	String result = "ERROR";
    	
    	String urlString = config.getProperty("config.BizmekaAPIGateURL") + "?UID=" + bizmekaAdminId 
    			+ "&UPW=" + bizmekaAdminPw + "&PPARAM=SUBTITLEADD" + "&CID=" + companyId
    			+ "&PFLAG=ORGAN_USER";
    	
    	StringBuilder sb = new StringBuilder();
    	
    	sb.append("<DATA>");
    	sb.append("<ROWS>");
    	sb.append("<USERID>" + commonUtil.cleanValue(userId) + "</USERID>");
    	sb.append("<DEPTID>" + commonUtil.cleanValue(deptId) + "</DEPTID>");    	
    	sb.append("<TITLE1>" + commonUtil.cleanValue(title1) + "</TITLE1>");
    	sb.append("<TITLE2>" + commonUtil.cleanValue(title2) + "</TITLE2>");
    	sb.append("</ROWS>");
    	sb.append("</DATA>");
    	
    	String inputParams = sb.toString();
    	
    	logger.debug("inputParams=" + inputParams);
    	
    	result = getWebServiceResult(urlString, inputParams);
    	
		logger.debug("result=" + result);
    	
		Document doc = commonUtil.convertStringToDocument(result);		
		NodeList rtnValueList = doc.getElementsByTagName("RTNVAL");
		
		if (rtnValueList != null && rtnValueList.getLength() > 0) {
			result = rtnValueList.item(0).getTextContent();
		}
    	
    	return result;
    }
    
    public String bizmekaDeleteSubtitle(String bizmekaAdminId, String bizmekaAdminPw, String companyId, String userId, 
						String deptId) throws Exception {
		String result = "ERROR";
		
		String urlString = config.getProperty("config.BizmekaAPIGateURL") + "?UID=" + bizmekaAdminId 
			+ "&UPW=" + bizmekaAdminPw + "&PPARAM=SUBTITLEDEL" + "&CID=" + companyId
			+ "&PFLAG=ORGAN_USER";
		
		StringBuilder sb = new StringBuilder();
		
		sb.append("<DATA>");
		sb.append("<ROWS>");
		sb.append("<USERID>" + commonUtil.cleanValue(userId) + "</USERID>");
		sb.append("<DEPTID>" + commonUtil.cleanValue(deptId) + "</DEPTID>");    	
		sb.append("</ROWS>");
		sb.append("</DATA>");
		
		String inputParams = sb.toString();
		
		logger.debug("inputParams=" + inputParams);
		
		result = getWebServiceResult(urlString, inputParams);
		
		logger.debug("result=" + result);
		
		Document doc = commonUtil.convertStringToDocument(result);		
		NodeList rtnValueList = doc.getElementsByTagName("RTNVAL");
		
		if (rtnValueList != null && rtnValueList.getLength() > 0) {
			result = rtnValueList.item(0).getTextContent();
		}
		
		return result;
    }
    
    public String bizmekaAddUser(String bizmekaAdminId, String bizmekaAdminPw, String companyId, String userId, 
    		String userPw, String userName, String deptId) throws Exception {
    	String result = "ERROR";
    	
    	String urlString = config.getProperty("config.BizmekaAPIGateURL") + "?UID=" + bizmekaAdminId 
    			+ "&UPW=" + bizmekaAdminPw + "&PPARAM=ADD" + "&CID=" + companyId
    			+ "&PFLAG=ORGAN_USER";
    	
    	StringBuilder sb = new StringBuilder();
    	
    	sb.append("<DATA>");
    	sb.append("<ROWS>");
    	sb.append("<USERID>" + commonUtil.cleanValue(userId) + "</USERID>");
    	sb.append("<USERPW>" + commonUtil.cleanValue(userPw) + "</USERPW>");
    	sb.append("<USERNAME>" + commonUtil.cleanValue(userName) + "</USERNAME>");
    	sb.append("<DEPTID>" + commonUtil.cleanValue(deptId) + "</DEPTID>");
    	sb.append("</ROWS>");
    	sb.append("</DATA>");
    	
    	String inputParams = sb.toString();
    	
    	logger.debug("inputParams=" + inputParams);
    	
    	result = getWebServiceResult(urlString, inputParams);
    	
		logger.debug("result=" + result);
    	
		Document doc = commonUtil.convertStringToDocument(result);		
		NodeList rtnValueList = doc.getElementsByTagName("RTNVAL");
		
		if (rtnValueList != null && rtnValueList.getLength() > 0) {
			result = rtnValueList.item(0).getTextContent();
		}
    	
    	return result;
    }
    
    public String bizmekaMoveUser(String bizmekaAdminId, String bizmekaAdminPw, String companyId, String userId, 
    								String deptId) throws Exception {
    	String result = "ERROR";
    	
    	String urlString = config.getProperty("config.BizmekaAPIGateURL") + "?UID=" + bizmekaAdminId 
    			+ "&UPW=" + bizmekaAdminPw + "&PPARAM=MOVE" + "&CID=" + companyId
    			+ "&PFLAG=ORGAN_USER";
    	
    	StringBuilder sb = new StringBuilder();
    	
    	sb.append("<DATA>");
    	sb.append("<ROWS>");
    	sb.append("<PARENTDEPTID>" + commonUtil.cleanValue(deptId) + "</PARENTDEPTID>");    	
    	sb.append("<USERID>" + commonUtil.cleanValue(userId) + "</USERID>");
    	sb.append("</ROWS>");
    	sb.append("</DATA>");
    	
    	String inputParams = sb.toString();
    	
    	logger.debug("inputParams=" + inputParams);
    	
    	result = getWebServiceResult(urlString, inputParams);
    	
		logger.debug("result=" + result);
    	
		Document doc = commonUtil.convertStringToDocument(result);		
		NodeList rtnValueList = doc.getElementsByTagName("RTNVAL");
		
		if (rtnValueList != null && rtnValueList.getLength() > 0) {
			result = rtnValueList.item(0).getTextContent();
		}
    	
    	return result;
    }
    
    public String bizmekaDeleteUser(String bizmekaAdminId, String bizmekaAdminPw, String companyId, String userId) throws Exception {
    	String result = "ERROR";
    	
    	String urlString = config.getProperty("config.BizmekaAPIGateURL") + "?UID=" + bizmekaAdminId 
    			+ "&UPW=" + bizmekaAdminPw + "&PPARAM=DEL" + "&CID=" + companyId
    			+ "&PFLAG=ORGAN_USER";
    	
    	StringBuilder sb = new StringBuilder();
    	
    	sb.append("<DATA>");
    	sb.append("<ROWS>");
    	sb.append("<USERID>" + commonUtil.cleanValue(userId) + "</USERID>");
    	sb.append("</ROWS>");
    	sb.append("</DATA>");
    	
    	String inputParams = sb.toString();
    	
    	logger.debug("inputParams=" + inputParams);
    	
    	result = getWebServiceResult(urlString, inputParams);
    	
		logger.debug("result=" + result);
    	
		Document doc = commonUtil.convertStringToDocument(result);		
		NodeList rtnValueList = doc.getElementsByTagName("RTNVAL");
		
		if (rtnValueList != null && rtnValueList.getLength() > 0) {
			result = rtnValueList.item(0).getTextContent();
		}
    	
    	return result;
    }
    
    public String bizmekaAddDept(String bizmekaAdminId, String bizmekaAdminPw, String companyId, String deptId, 
    		String deptName, String parentDeptId) throws Exception {
    	String result = "ERROR";
    	
    	String urlString = config.getProperty("config.BizmekaAPIGateURL") + "?UID=" + bizmekaAdminId 
    			+ "&UPW=" + bizmekaAdminPw + "&PPARAM=ADD" + "&CID=" + companyId
    			+ "&PFLAG=ORGAN_DEPT";
    	
    	StringBuilder sb = new StringBuilder();
    	
    	sb.append("<DATA>");
    	sb.append("<ROWS>");
    	sb.append("<DEPTID>" + commonUtil.cleanValue(deptId) + "</DEPTID>");
    	sb.append("<PARENTDEPTID>" + commonUtil.cleanValue(parentDeptId) + "</PARENTDEPTID>");    	
    	sb.append("<DEPTNAME>" + commonUtil.cleanValue(deptName) + "</DEPTNAME>");
    	sb.append("</ROWS>");
    	sb.append("</DATA>");
    	
    	String inputParams = sb.toString();
    	
    	logger.debug("inputParams=" + inputParams);
    	
    	result = getWebServiceResult(urlString, inputParams);
    	
		logger.debug("result=" + result);
    	
		Document doc = commonUtil.convertStringToDocument(result);		
		NodeList rtnValueList = doc.getElementsByTagName("RTNVAL");
		
		if (rtnValueList != null && rtnValueList.getLength() > 0) {
			result = rtnValueList.item(0).getTextContent();
		}
    	
    	return result;
    }
    
    public String bizmekaMoveDept(String bizmekaAdminId, String bizmekaAdminPw, String companyId, String deptId, 
    								String parentDeptId) throws Exception {
    	String result = "ERROR";
    	
    	String urlString = config.getProperty("config.BizmekaAPIGateURL") + "?UID=" + bizmekaAdminId 
    			+ "&UPW=" + bizmekaAdminPw + "&PPARAM=MOVE" + "&CID=" + companyId
    			+ "&PFLAG=ORGAN_DEPT";
    	
    	StringBuilder sb = new StringBuilder();
    	
    	sb.append("<DATA>");
    	sb.append("<ROWS>");
    	sb.append("<DEPTID>" + commonUtil.cleanValue(deptId) + "</DEPTID>");
    	sb.append("<PARENTDEPTID>" + commonUtil.cleanValue(parentDeptId) + "</PARENTDEPTID>");    	
    	sb.append("</ROWS>");
    	sb.append("</DATA>");
    	
    	String inputParams = sb.toString();
    	
    	logger.debug("inputParams=" + inputParams);
    	
    	result = getWebServiceResult(urlString, inputParams);
    	
		logger.debug("result=" + result);
    	
		Document doc = commonUtil.convertStringToDocument(result);		
		NodeList rtnValueList = doc.getElementsByTagName("RTNVAL");
		
		if (rtnValueList != null && rtnValueList.getLength() > 0) {
			result = rtnValueList.item(0).getTextContent();
		}
    	
    	return result;
    }
    
    public String bizmekaDeleteDept(String bizmekaAdminId, String bizmekaAdminPw, String companyId, String deptId) throws Exception {
    	String result = "ERROR";
    	
    	String urlString = config.getProperty("config.BizmekaAPIGateURL") + "?UID=" + bizmekaAdminId 
    			+ "&UPW=" + bizmekaAdminPw + "&PPARAM=DEL" + "&CID=" + companyId
    			+ "&PFLAG=ORGAN_DEPT";
    	
    	StringBuilder sb = new StringBuilder();
    	
    	sb.append("<DATA>");
    	sb.append("<ROWS>");
    	sb.append("<DEPTID>" + commonUtil.cleanValue(deptId) + "</DEPTID>");
    	sb.append("</ROWS>");
    	sb.append("</DATA>");
    	
    	String inputParams = sb.toString();
    	
    	logger.debug("inputParams=" + inputParams);
    	
    	result = getWebServiceResult(urlString, inputParams);
    	
		logger.debug("result=" + result);
    	
		Document doc = commonUtil.convertStringToDocument(result);		
		NodeList rtnValueList = doc.getElementsByTagName("RTNVAL");
		
		if (rtnValueList != null && rtnValueList.getLength() > 0) {
			result = rtnValueList.item(0).getTextContent();
		}
    	
    	return result;
    }
    
    public String bizmekaAddDistributionList(String bizmekaAdminId, String bizmekaAdminPw, String companyId, String distId, 
    		String distName, List<String> memberList) throws Exception {
    	String result = "ERROR";
    	
    	String urlString = config.getProperty("config.BizmekaAPIGateURL") + "?UID=" + bizmekaAdminId 
    			+ "&UPW=" + bizmekaAdminPw + "&PPARAM=ADD" + "&CID=" + companyId
    			+ "&PFLAG=ORGAN_DIST";
    	
    	StringBuilder sbMembers = new StringBuilder();    
    	int memberCount = memberList.size();
    	
    	for (int i = 0; i < memberCount; i++) {
    		sbMembers.append(memberList.get(i));
    		
    		if (i != memberCount - 1) {
    			sbMembers.append("|");
    		}
    	}

    	StringBuilder sb = new StringBuilder();
    	
    	sb.append("<DATA>");
    	sb.append("<ROWS>");
    	sb.append("<DISTID>" + commonUtil.cleanValue(distId) + "</DISTID>");
    	sb.append("<DISTNAME>" + commonUtil.cleanValue(distName) + "</DISTNAME>");    	
    	sb.append("<MEMBERS>" + commonUtil.cleanValue(sbMembers.toString()) + "</MEMBERS>");
    	sb.append("</ROWS>");
    	sb.append("</DATA>");
    	
    	String inputParams = sb.toString();
    	
    	logger.debug("inputParams=" + inputParams);
    	
    	result = getWebServiceResult(urlString, inputParams);
    	
		logger.debug("result=" + result);
    	
		Document doc = commonUtil.convertStringToDocument(result);		
		NodeList rtnValueList = doc.getElementsByTagName("RTNVAL");
		
		if (rtnValueList != null && rtnValueList.getLength() > 0) {
			result = rtnValueList.item(0).getTextContent();
		}
    	
    	return result;
    }
    
    public String bizmekaEditDistributionList(String bizmekaAdminId, String bizmekaAdminPw, String companyId, String distId, 
    		String distName, List<String> memberList) throws Exception {
    	String result = "ERROR";
    	
    	String urlString = config.getProperty("config.BizmekaAPIGateURL") + "?UID=" + bizmekaAdminId 
    			+ "&UPW=" + bizmekaAdminPw + "&PPARAM=EDIT" + "&CID=" + companyId
    			+ "&PFLAG=ORGAN_DIST";
    	
    	StringBuilder sbMembers = new StringBuilder();    
    	int memberCount = memberList.size();
    	
    	for (int i = 0; i < memberCount; i++) {
    		sbMembers.append(memberList.get(i));
    		
    		if (i != memberCount - 1) {
    			sbMembers.append("|");
    		}
    	}

    	StringBuilder sb = new StringBuilder();
    	
    	sb.append("<DATA>");
    	sb.append("<ROWS>");
    	sb.append("<DISTID>" + commonUtil.cleanValue(distId) + "</DISTID>");
    	sb.append("<DISTNAME>" + commonUtil.cleanValue(distName) + "</DISTNAME>");    	
    	sb.append("<MEMBERS>" + commonUtil.cleanValue(sbMembers.toString()) + "</MEMBERS>");
    	sb.append("</ROWS>");
    	sb.append("</DATA>");
    	
    	String inputParams = sb.toString();
    	
    	logger.debug("inputParams=" + inputParams);
    	
    	result = getWebServiceResult(urlString, inputParams);
    	
		logger.debug("result=" + result);
    	
		Document doc = commonUtil.convertStringToDocument(result);		
		NodeList rtnValueList = doc.getElementsByTagName("RTNVAL");
		
		if (rtnValueList != null && rtnValueList.getLength() > 0) {
			result = rtnValueList.item(0).getTextContent();
		}
    	
    	return result;
    }
    
    public String bizmekaDeleteDistributionList(String bizmekaAdminId, String bizmekaAdminPw, String companyId, String distId) throws Exception {
    	String result = "ERROR";
    	
    	String urlString = config.getProperty("config.BizmekaAPIGateURL") + "?UID=" + bizmekaAdminId 
    			+ "&UPW=" + bizmekaAdminPw + "&PPARAM=DEL" + "&CID=" + companyId
    			+ "&PFLAG=ORGAN_DIST";
    	
    	StringBuilder sb = new StringBuilder();
    	
    	sb.append("<DATA>");
    	sb.append("<ROWS>");
    	sb.append("<DISTID>" + commonUtil.cleanValue(distId) + "</DISTID>");
    	sb.append("</ROWS>");
    	sb.append("</DATA>");
    	
    	String inputParams = sb.toString();
    	
    	logger.debug("inputParams=" + inputParams);
    	
    	result = getWebServiceResult(urlString, inputParams);
    	
		logger.debug("result=" + result);
    	
		Document doc = commonUtil.convertStringToDocument(result);		
		NodeList rtnValueList = doc.getElementsByTagName("RTNVAL");
		
		if (rtnValueList != null && rtnValueList.getLength() > 0) {
			result = rtnValueList.item(0).getTextContent();
		}
    	
    	return result;
    }
    
    public String bizmekaEditEmailList(String bizmekaAdminId, String bizmekaAdminPw, String companyId, String emailId, 
    		String mainEmail, List<String> subEmailList) throws Exception {
    	String result = "ERROR";
    	
    	String urlString = config.getProperty("config.BizmekaAPIGateURL") + "?UID=" + bizmekaAdminId 
    			+ "&UPW=" + bizmekaAdminPw + "&PPARAM=EDIT" + "&CID=" + companyId
    			+ "&PFLAG=ORGAN_EMAIL";
    	
    	StringBuilder sbMembers = new StringBuilder();    
    	int memberCount = subEmailList.size();
    	
    	for (int i = 0; i < memberCount; i++) {
    		sbMembers.append(subEmailList.get(i));
    		
    		if (i != memberCount - 1) {
    			sbMembers.append(";");
    		}
    	}
    	
    	if (memberCount == 0) {
    		sbMembers.append(mainEmail);
    	}

    	StringBuilder sb = new StringBuilder();
    	
    	sb.append("<DATA>");
    	sb.append("<ROWS>");
    	sb.append("<EMAILID>" + commonUtil.cleanValue(emailId) + "</EMAILID>");
    	sb.append("<EDITMAINEMAIL>" + commonUtil.cleanValue(mainEmail) + "</EDITMAINEMAIL>");    	
    	sb.append("<EDITSUBEMAIL>" + commonUtil.cleanValue(sbMembers.toString()) + "</EDITSUBEMAIL>");
    	sb.append("</ROWS>");
    	sb.append("</DATA>");
    	
    	String inputParams = sb.toString();
    	
    	logger.debug("inputParams=" + inputParams);
    	
    	result = getWebServiceResult(urlString, inputParams);
    	
		logger.debug("result=" + result);
    	
		Document doc = commonUtil.convertStringToDocument(result);		
		NodeList rtnValueList = doc.getElementsByTagName("RTNVAL");
		
		if (rtnValueList != null && rtnValueList.getLength() > 0) {
			result = rtnValueList.item(0).getTextContent();
		}
    	
    	return result;
    }
    
    public String getSecureBodyHtml(String fileName, Locale locale) {
    	StringBuilder sb = new StringBuilder();
    	sb.append("<div class=\"security_message\" style=\"background:#d0e1ff;min-width:770px;\">\n");
    	sb.append("    <div class=\"security_img\" style=\"max-width:780px;margin:0 auto;padding-left:40px;padding-bottom:20px\">\n");
    	sb.append("        <img src=\"cid:" + fileName + ".gif@12345678.87654321\">\n");
    	sb.append("        <section class=\"security_txt\" style=\"margin:0px 0px 0px 300px;padding:54px 0px;font-family:" + egovMessageSource.getMessage("main.t0620", locale).replace(";", ",") + ";position:relative;left:-50px;margin-top:-250px\">\n");
    	sb.append("            <h4 style=\"margin:0px;padding:3px 0px 0px 0px;font-size:22px;letter-spacing:-1px;color:#333;border-bottom:2px solid #727985;line-height:44px\">" + egovMessageSource.getMessage("ezEmail.lhm57", locale) + "</h4>\n");
    	sb.append("            <p style=\"margin:0px;padding:5px 0px 0px 0px;font-size:15px;color:#333;line-height:22px\">" + egovMessageSource.getMessage("ezEmail.lhm58", locale) + "</p>\n");
    	sb.append("        </section>\n");
    	sb.append("    </div>\n");
    	sb.append("</div>\n");
    	
    	return sb.toString();
    }
    
    public String getSecureAttachHtml(String serverName, Locale locale, String useHttps) {
    	String protocol = "http";
    	if (useHttps.equals("YES")) {
    		protocol = "https";
    	}
    	
    	StringBuilder sb = new StringBuilder();
    	sb.append("<!DOCTYPE html>\n");
    	sb.append("<html style=\"height:100%;\">\n");
    	sb.append("    <head>\n");
    	sb.append("        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>\n");
    	sb.append("        <title>SECURE MAIL</title>\n");
    	sb.append("        <style>\n");
    	sb.append("            body{font-family:" + egovMessageSource.getMessage("main.t0620", locale).replace(";", ",") + "}\n");
    	sb.append("            .security_layerpopup{width:100%; height:100%; background:#f1f1f1;}\n");
    	sb.append("            .security_layerpopup .popup_img{margin:0px; padding:84px 0px 0px 0px; text-align:center;}\n");
    	sb.append("            .security_layerpopup .popup_txt{margin:0px; padding:0px; text-align:center; font-size:24px; color:#333; font-weight:600;}\n");
    	sb.append("            .security_layerpopup .popup_txt span{font-size:18px; font-weight:300; letter-spacing:-1px;}\n");
    	sb.append("            .security_layerpopup form{width:465px; margin: 35px auto;}\n");
    	sb.append("            .security_layerpopup form fieldset {margin:0; padding:0; border:0; clear:both;}\n");
    	sb.append("            .security_layerpopup legend {visibility:hidden; position:absolute; top:0; left:0; width:1px; height:1px; font-size:0; line-height:0}\n");
    	sb.append("            .security_layerpopup .password{float:left; width:380px; height:45px; margin:0px; padding::0px; background:url(" + protocol + "://" + serverName + "/images/email/secureMail/input_pw_bg.gif) no-repeat;}\n");
    	sb.append("            .security_layerpopup #TextPassword {width:300px; height:43px; margin:1px 0px 0px 46px; padding:0px 0px 0px 10px; line-height:21px; color:#777; font-size:18px; border:0px solid #fff; border-radius:5px; -webkit-border-radius:5px; -moz-border-radius:5px;}\n");
    	sb.append("            .security_layerpopup .input_text.focus, .input_text.focusnot{background:#fff !important;}\n");
    	sb.append("            .security_layerpopup .btn{float:left; width:75px; height:45px; margin:0px 0px 0px 10px; padding:0px;}\n");
    	sb.append("            .security_layerpopup .btn_check{width:75px; height:45px; margin:0px; padding:0px;border-radius:5px;border:none;color:white;font-size:17px;text-decoration:none;background-color:rgb(48, 77, 127);}\n");
    	sb.append("        </style>\n");
    	sb.append("        <script>\n");
    	sb.append("            function submitForm() {\n");
    	sb.append("                if (document.secureForm.securePassword.value.length == 0) {\n");
    	sb.append("                   alert(\"" + egovMessageSource.getMessage("ezEmail.lhm42", locale) + "\");\n");
    	sb.append("                   return;\n");
    	sb.append("                }\n");
    	sb.append("                var f = document.secureForm;\n");
    	sb.append("                f.submit();\n");
    	sb.append("            }\n");
    	sb.append("        </script>\n");
    	sb.append("    </head>\n");
    	sb.append("    <body style=\"margin:0;height:100%;\">\n");
    	sb.append("        <div class=\"security_layerpopup\">\n");
    	sb.append("            <p class=\"popup_img\"><img src=\"" + protocol + "://" + serverName + "/images/email/secureMail/layer_img.gif\"></p>\n");
    	sb.append("            <p class=\"popup_txt\">" + egovMessageSource.getMessage("ezEmail.lhm57", locale) + "<br /><span>" + egovMessageSource.getMessage("ezEmail.lhm40", locale) + "</span></p>\n");
    	sb.append("            <form name=\"secureForm\" method=\"post\" action=\"" + protocol + "://" + serverName + "/ezEmail/readSecureMail.do\">\n");
    	sb.append("                <fieldset>\n");
    	sb.append("                    <p class=\"password\"><input name=\"securePassword\" type=\"password\" id=\"TextPassword\" class=\"input_text\" placeholder=\"" + egovMessageSource.getMessage("ezEmail.lhm42", locale) + "\" /></p>\n");
    	sb.append("                    <p class=\"btn\"><input type=\"button\" name=\"Button\" id=\"Button\" value=\"" + egovMessageSource.getMessage("ezEmail.t38", locale) + "\" tabindex=\"3\" class=\"btn_check\" onclick=\"submitForm()\" /></p>\n");
    	sb.append("                </fieldset>\n");
    	sb.append("                <input type=\"hidden\" name=\"secureKey\" value=\"${X-JMocha-Secure-Mail-Key}\" />\n");
    	sb.append("            </form>\n");
    	sb.append("        </div>\n");
    	sb.append("    </body>\n");
    	sb.append("</html>\n");
    	
    	return sb.toString();
    }
    
    private String toHexString(byte[] array) {
        return DatatypeConverter.printHexBinary(array);
    }    
    
	/**
	 * change an http or https URL to an anchor tag in a text/plain message 
	 * so that the user can click on it
	 */	
	private String changeURLsToAnchorTags(String src) {
		Pattern p = Pattern.compile("(https?://[^ <$]+)");
		Matcher m = p.matcher(src);
		
		StringBuffer result = new StringBuffer();
		while (m.find()) {
			m.appendReplacement(result, Matcher.quoteReplacement(String.format("<a href=\"%s\">%s</a>", m.group(1), m.group(1))));
		}
		m.appendTail(result);
		
		return result.toString();		
	}

	/**
	 * style 태그가 일정 개수 이상이면 style 태그와 그 사이의 콘텐츠를 삭제하는 기능을 수행하는 메소드
	 */
	private String stripTooManyStyleTags(String src) {
		Pattern p = Pattern.compile("<style.*?>.*?</style>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
		Matcher m = p.matcher(src);
		
		int count = 0;
		while (m.find()) {
		    count++;		
		}
		
		logger.debug("style count=" + count);
		
		if (count >= 20) {
			src = m.replaceAll("");
		}
				
		return src;		
	}
	
	/** 
	 * strip <object>,<applet>,<script> tags
	 */	
	private String stripScriptTags(String src) {
		Pattern p = Pattern.compile("<(object|applet|script).*?>|</(object|applet|script).*?>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
		Matcher m = p.matcher(src);
		src = m.replaceAll("");
				
		return src;		
	}
	
	/** 
	 * add target="_blank" to an anchor tag
	 */	
	private String addTargetBlank(String src) {
		Pattern p = Pattern.compile("<a (.*?)>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
		Matcher m = p.matcher(src);
				
		StringBuffer result = new StringBuffer();
		while (m.find()) {
			String att = m.group(1);
			
			if (att.toLowerCase().indexOf("target=") < 0) {
				m.appendReplacement(result, Matcher.quoteReplacement("<a " + att + " target=\"_blank\">"));
			}
		}
		m.appendTail(result);
		
		return result.toString();		
	}	
	
	public boolean toSearch (Message message, String searchValue) {
		if (",<>@".contains(searchValue)) {
			return false;
		}
			
		try {
			StringBuilder sb = new StringBuilder();
			
			// retrieve the TO addresses from the message.
			Address[] addresses = message.getRecipients(Message.RecipientType.TO);
			String[] rawHeaders = message.getHeader("To");
			String rawHeader = rawHeaders != null ? rawHeaders[0] : "";							
			String to = getStringListOfAddresses(addresses, isPureAscii(rawHeader));
			
			if (!to.equals("")) {
				sb.append(to);
			}
			
			// retrieve the CC addresses from the message.
			addresses = message.getRecipients(Message.RecipientType.CC);
			rawHeaders = message.getHeader("Cc");
			rawHeader = rawHeaders != null ? rawHeaders[0] : "";														
			String cc = getStringListOfAddresses(addresses, isPureAscii(rawHeader));
			
			if (!cc.equals("")) {
				if (!to.equals("")) {
					sb.append(",");
				}
				
				sb.append(cc);
			}
			
			// retrieve the BCC addresses from the message.
			addresses = message.getRecipients(Message.RecipientType.BCC);
			String bcc = getStringListOfAddresses(addresses, true);

			if (!bcc.equals("")) {
				if (!to.equals("") || !cc.equals("")) {
					sb.append(",");
				}
				
				sb.append(bcc);
			}							
			
			if (sb.toString().toLowerCase().contains(searchValue.toLowerCase())) {
				return true;
			}
		}

		catch (MessagingException e) {					    		
		}
			
		return false;
		}
}


