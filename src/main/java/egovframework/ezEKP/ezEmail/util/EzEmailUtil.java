package egovframework.ezEKP.ezEmail.util;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.nio.charset.MalformedInputException;
import java.nio.file.StandardCopyOption;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.RSAPublicKeySpec;
import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Properties;
import java.util.Spliterator;
import java.util.TimeZone;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import java.util.function.Consumer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;
import java.util.stream.StreamSupport;
import java.nio.file.Files;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
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
import javax.mail.Message.RecipientType;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Part;
import javax.mail.Transport;
import javax.mail.UIDFolder;
import javax.mail.internet.AddressException;
import javax.mail.internet.ContentDisposition;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.InternetHeaders;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimePart;
import javax.mail.internet.MimeUtility;
import javax.mail.search.AndTerm;
import javax.mail.search.DateTerm;
import javax.mail.search.FlagTerm;
import javax.mail.search.ReceivedDateTerm;
import javax.mail.search.SearchTerm;
import javax.mail.util.ByteArrayDataSource;
import javax.servlet.ServletContext;
import javax.xml.bind.DatatypeConverter;

import com.google.gson.JsonElement;
import egovframework.let.utl.fcc.service.KlibUtil;
import net.fortuna.ical4j.util.CompatibilityHints;
import net.lingala.zip4j.ZipFile;
import net.lingala.zip4j.exception.ZipException;
import net.lingala.zip4j.model.ZipParameters;
import net.lingala.zip4j.model.enums.CompressionLevel;
import net.lingala.zip4j.model.enums.CompressionMethod;
import net.lingala.zip4j.model.enums.EncryptionMethod;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveInputStream;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.bouncycastle.util.encoders.Hex;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Component;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import com.sun.mail.imap.AppendUID;
import com.sun.mail.imap.IMAPFolder;
import com.sun.mail.imap.IMAPMessage;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.vo.IcalVO;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.let.utl.rest.JgwResult;
import egovframework.let.utl.rest.Rest;
import egovframework.let.utl.sim.service.EgovFileScrty;
import net.fortuna.ical4j.data.CalendarBuilder;
import net.fortuna.ical4j.model.ComponentList;
import net.fortuna.ical4j.model.Parameter;
import net.fortuna.ical4j.model.Property;
import net.fortuna.ical4j.model.PropertyList;
import net.fortuna.ical4j.model.Recur;
import net.fortuna.ical4j.model.component.CalendarComponent;
import net.fortuna.ical4j.model.component.VEvent;
import net.fortuna.ical4j.model.property.Attendee;
import net.fortuna.ical4j.model.property.RRule;

import static net.fortuna.ical4j.util.CompatibilityHints.KEY_RELAXED_PARSING;
import static net.fortuna.ical4j.util.CompatibilityHints.KEY_RELAXED_UNFOLDING;
import static net.fortuna.ical4j.util.CompatibilityHints.KEY_RELAXED_VALIDATION;

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

	private static final String[] UNSUPPORTED_PREVIEW_CONTENT_TYPES = { "image/vnd.adobe.photoshop" };

	private static final Logger logger = LoggerFactory.getLogger(EzEmailUtil.class);
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
    @Autowired
    private Properties config;
	
	@Autowired
	private ServletContext servletContext;

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzAddressService ezAddressService;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;

	@Autowired
	private EzEmailUserAdminService ezEmailUserAdminService;

	@Value("#{cryptos['EzEmailUtil.apb']}")
	private String apb;

	@Autowired
	Rest rest;

	@Autowired
	protected KlibUtil klibUtil;

	public String getMailHeaderPath(long mailboxId, long mailUid) {
		String realPath = commonUtil.getRealPath(servletContext);
		String mailboxParentFolderName = String.valueOf(mailboxId % 100);
		String parentFolderName = String.valueOf(mailUid % 100);
		String mailPath = String.format("%s/%s/%s/%d/%s/%d", 
							realPath, "/fileroot/mail", mailboxParentFolderName, mailboxId, parentFolderName, mailUid);
		String headerPath = String.format("%s.%s", mailPath, "head");

		return headerPath;
	}

	public String getMailBodyPath(long mailboxId, long mailUid) {
		String realPath = commonUtil.getRealPath(servletContext);
		String mailboxParentFolderName = String.valueOf(mailboxId % 100);
		String parentFolderName = String.valueOf(mailUid % 100);
		String mailPath = String.format("%s/%s/%s/%d/%s/%d", 
							realPath, "/fileroot/mail", mailboxParentFolderName, mailboxId, parentFolderName, mailUid);
		String bodyPath = String.format("%s.%s", mailPath, "body");

		return bodyPath;
	}
	
	public Map<String, long[]> getFolderIdUid(String[] folderAndMsgIdArray) {
		Map<String, long[]> folderIdUids = new HashMap<>();

		for (String folderAndMsgId : folderAndMsgIdArray) {
			int delimiterIndex = folderAndMsgId.lastIndexOf("/");
			String folderId = folderAndMsgId.substring(0, delimiterIndex);
			long msgId = Long.parseLong(folderAndMsgId.substring(delimiterIndex + 1));

			// folderUids에 folderId가 없으면 새 배열 생성 (초기 크기는 folderAndMsgIdArray의 길이로 설정)
			long[] uidArray = folderIdUids.computeIfAbsent(folderId, k -> new long[folderAndMsgIdArray.length]);

			// 배열에 값 추가
			int index = 0;
			while (index < uidArray.length && uidArray[index] != 0) {
				index++;
			}
			if (index < uidArray.length) {
				uidArray[index] = msgId;
			}
		}

		// 배열의 실제 사용된 크기로 잘라내기
		for (Map.Entry<String, long[]> entry : folderIdUids.entrySet()) {
			long[] uidArray = entry.getValue();
			int actualSize = 0;
			while (actualSize < uidArray.length && uidArray[actualSize] != 0) {
				actualSize++;
			}
			entry.setValue(Arrays.copyOf(uidArray, actualSize));
		}
		
		return folderIdUids;
	}
	
	public String getInboxFolderId() {
		return "INBOX";
	}
		
	public String getSentFolderId(Locale locale) {
		String useStandardFolderId = config.getProperty("config.useStandardFolderId");
		
		if (useStandardFolderId != null && useStandardFolderId.equals("YES")) {
			return "Sent";
		} else {
			return egovMessageSource.getMessage("ezEmail.t645", locale);
		}
	}

	public String getDraftsFolderId(Locale locale) {
		String useStandardFolderId = config.getProperty("config.useStandardFolderId");
		
		if (useStandardFolderId != null && useStandardFolderId.equals("YES")) {		
			return "Drafts";
		} else {
			return egovMessageSource.getMessage("ezEmail.t646", locale);
		}
	}

	public String getTrashFolderId(Locale locale) {
		String useStandardFolderId = config.getProperty("config.useStandardFolderId");
		
		if (useStandardFolderId != null && useStandardFolderId.equals("YES")) {				
			return "Trash";
		} else {
			return egovMessageSource.getMessage("ezEmail.t647", locale);
		}
	}

	public String getPersonalFolderId(Locale locale) {
		String useStandardFolderId = config.getProperty("config.useStandardFolderId");
		
		if (useStandardFolderId != null && useStandardFolderId.equals("YES")) {								
			return "Personal folder";
		} else {
			return egovMessageSource.getMessage("ezEmail.t648", locale);
		}
	}
	
	public String getJunkFolderId(Locale locale) {
		String useStandardFolderId = config.getProperty("config.useStandardFolderId");
		
		if (useStandardFolderId != null && useStandardFolderId.equals("YES")) {						
			return "Junk E-Mail";
		} else {
			return egovMessageSource.getMessage("ezEmail.t99000029", locale);
		}
	}
    
	public String getDisplayNameFromFolderId(String folderId, Locale locale) {
		String displayName = folderId;
		
		String useStandardFolderId = config.getProperty("config.useStandardFolderId");
		
		if (useStandardFolderId != null && useStandardFolderId.equals("YES")) {								
			if (folderId.equals("INBOX") || folderId.startsWith("INBOX.")) {
				displayName = folderId.replaceFirst("INBOX", egovMessageSource.getMessage("ezEmail.t644", locale));
			} else if ("ALLMAIL".equalsIgnoreCase(folderId)) {
				displayName = folderId.replace("ALLMAIL", egovMessageSource.getMessage("email.allmail", locale));
			} else if (folderId.equals("Sent") || folderId.startsWith("Sent.")) {
				displayName = folderId.replaceFirst("Sent", egovMessageSource.getMessage("ezEmail.t645", locale));
			} else if (folderId.equals("Drafts") || folderId.startsWith("Drafts.")) {
				displayName = folderId.replaceFirst("Drafts", egovMessageSource.getMessage("ezEmail.t646", locale));
			} else if (folderId.equals("Trash") || folderId.startsWith("Trash.")) {
				displayName = folderId.replaceFirst("Trash", egovMessageSource.getMessage("ezEmail.t647", locale));
			} else if (folderId.equals("Personal folder") || folderId.startsWith("Personal folder.")) {
				displayName = folderId.replaceFirst("Personal folder", egovMessageSource.getMessage("ezEmail.t648", locale));
			} else if (folderId.equals("Junk E-Mail") || folderId.startsWith("Junk E-Mail.")) {
				displayName = folderId.replaceFirst("Junk E-Mail", egovMessageSource.getMessage("ezEmail.t99000029", locale));
			}
		} else {
			if (folderId.equals("INBOX") || folderId.startsWith("INBOX.")) {
				displayName = folderId.replaceFirst("INBOX", egovMessageSource.getMessage("ezEmail.t644", locale));
			}			
		}
		
		return displayName;
	}	
	
	public String getFolderIdFromDisplayName(String displayName, Locale locale) {
		String folderId = displayName;
		
		String useStandardFolderId = config.getProperty("config.useStandardFolderId");
		
		if (useStandardFolderId != null && useStandardFolderId.equals("YES")) {	
			if (displayName.equals(egovMessageSource.getMessage("ezEmail.t644", locale))) {
				folderId = "INBOX";
			} else if (displayName.equals(egovMessageSource.getMessage("email.allmail", locale))) {
				folderId = "ALLMAIL";
			} else if (displayName.equals(egovMessageSource.getMessage("ezEmail.t645", locale))) {
				folderId = "Sent";
			} else if (displayName.equals(egovMessageSource.getMessage("ezEmail.t646", locale))) {
				folderId = "Drafts";
			} else if (displayName.equals(egovMessageSource.getMessage("ezEmail.t647", locale))) {
				folderId = "Trash";
			} else if (displayName.equals(egovMessageSource.getMessage("ezEmail.t648", locale))) {
				folderId = "Personal folder";
			} else if (displayName.equals(egovMessageSource.getMessage("ezEmail.t99000029", locale))) {
				folderId = "Junk E-Mail";
			}
		} else {
			if (displayName.equals(egovMessageSource.getMessage("ezEmail.t644", locale))) {
				folderId = "INBOX";
			}			
		}
		
		return folderId;
	}
	
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
	
	private String decodeMultiLineQPEncodedName(String rawHeader, String name) {
		try {
			if (rawHeader.startsWith("=?")) {
				String fromName = name;
	            int secondQuestionPos = rawHeader.indexOf("?", 2);
	            int thirdQuestionPos = rawHeader.indexOf("?", secondQuestionPos + 1);
	            String charSetAndEncoding = rawHeader.substring(0, thirdQuestionPos + 1); 
	            String encoding = rawHeader.substring(secondQuestionPos + 1, thirdQuestionPos);                                        
	            
	            // 일부 Mailer에서 RFC 2047에서 정의된 encoded word를 2개 이상의 라인으로 구성할 때
	            // 한글의 한 글자를 표현하는 Byte Array 중간에서 분리하는 경우가 있어(QP 인코딩을 사용하면서) 
	            // 이 경우 JavaMail에서 디코딩할 때 글자가 깨지는 현상이 발생하여 한 줄로 합치는 작업을 직접 수행하도록 함.  
	            // 글자가 깨지는 경우 Unicode의 Replacement Character인 �가 나타남.
	            // From: =?utf-8?Q?=28=EC=A3=BC=29=EC=BC=80=EC=9D=B4=ED=88=AC=EC=BD=94=EB?=
	            //		 =?utf-8?Q?=A6=AC=EC=95=84?= <ecount@ecounterp.com>		                    
	            if (fromName.contains("�")
	                    && encoding.equalsIgnoreCase("Q")) {
	                String[] sequences = rawHeader.split(charSetAndEncoding.replaceAll("\\?", "\\\\?"));
	                
	                if (sequences.length > 2) {
	                    logger.debug("broken multiple sequences. combining them...");
	                    logger.debug("original rawHeader:" + rawHeader);
	                    
	                    StringBuilder combined = new StringBuilder();                        
	                    combined.append(charSetAndEncoding);
	                    
	                    for (int i = 1; i < sequences.length; i++) {
	                        String sequence = sequences[i].trim();
	                        
	                        logger.debug("sequence[" + i + "]:" + sequence);
	                        
	                        sequence = sequence.substring(0, sequence.lastIndexOf("?"));
	                        combined.append(sequence);                            
	                    }
	                    
	                    combined.append("?=");
	                    rawHeader = combined.toString();
	                    
	                    logger.debug("combined rawHeader:" + rawHeader);
	                    
	                    fromName = MimeUtility.decodeText(rawHeader);
	                    
	                    logger.debug("fromName=" + fromName);
	                    
	                    name = fromName;
	                }
	            }		
			}
		} catch (IndexOutOfBoundsException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		return name;
	}
	
	public String changeCharSet(String rawHeader, String oldCharSet, String newCharSet) {
		if (rawHeader.startsWith("=?")) {
			int secondQuestionPos = rawHeader.indexOf("?", 2);
			
			if (secondQuestionPos > -1) {
                String charSet = rawHeader.substring(2, secondQuestionPos).toLowerCase();
                
                if (charSet.equals(oldCharSet)) {
                	rawHeader = rawHeader.replace(charSet, newCharSet);	                        
                }                
			}
		}
		
		return rawHeader;
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
					if (fromHeader != null){
						// 표준을 지키지 않고 Non-Ascii 문자가 사용된 경우엔 직접 디코딩을 처리한다.
						if (!isPureAscii(fromHeader)) {
							byte[] rawBytes = addressStr.getBytes("iso-8859-1");

							addressStr = decodeNonAsciiBytes(rawBytes);
						} else {
							// gb2312로 인코딩되어 있다고 기술되어 있지만 gbk에서
							// 정의되어 있는 글자가 포함되어 디코딩 시 깨지는 문제가 발생하여 gbk로 디코딩 처리하는 코드를 추가함.
							String newFromHeader = changeCharSet(fromHeader, "gb2312", "gbk");

							// gb2312에서 gbk로 변경된 경우
							if (newFromHeader != null && !newFromHeader.equals(fromHeader)) {
								int endPos = newFromHeader.indexOf("?=", 2);

								// 주소 부분을 제외한 이름 파트만 분리한다.
								if (endPos > -1) {
									addressStr = newFromHeader.substring(0, endPos + 2);
								}
							}

							// decoding is needed for the name part
							// ex) =?UTF-8?B?44WC44WC?=
							//     =?utf-8?B?Z2lzYTE=?=
							//     =?ks_c_5601-1987?B?uei03iC1x8H2IL7KwL06IHRlc3Q=?=
							addressStr = MimeUtility.decodeText(addressStr);

							addressStr = decodeMultiLineQPEncodedName(fromHeader, addressStr);
						}
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
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} 
		
		if (addressStr != null) {
			// 료비에서 수신한 메일 중 \(backslash)" 가 문자열 내부에 포함되는 경우가 있어 추가함.
			// 예) =?iso-2022-jp?B?Im1hLXgtOTMyQGRvY29tby5uZS5qcCI=?=<ma-x-932@docomo.ne.jp>
			addressStr = addressStr.replace("\\\"", "");
		}
		
		return addressStr;
	}
	
	public String getNameOrAddress(String internetAddressStr) {
		String name = "";
				
		if (!internetAddressStr.isEmpty()) {
			try {
				InternetAddress ia = new InternetAddress(internetAddressStr);
				name = ia.getPersonal();
				
				if (name == null) {
					name = ia.getAddress();
				}
			} catch (AddressException e) {
//				logger.error(e.getMessage(), e);
				
				// 현대오일뱅크" <HyundaiOilbank@oilbankcard.com> 와 같이 "가 하나만 있는 경우
				// 예외가 발생하는데 이와 같은 경우에 대한 부가적인 처리를 수행한다.
	            Pattern pattern = Pattern.compile("(.*)<(.*)>");
	            Matcher matcher = pattern.matcher(internetAddressStr);
	            
	            if (matcher.find()) {
	            	name = matcher.group(1).trim();
	            	
	            	logger.debug("getNameOrAddress exception happened. new name=" + name);
	            }
			}
		}		
		
		return name;
	}

	public String getAddress(String internetAddressStr) {
		String address = "";
				
		if (!internetAddressStr.isEmpty()) {
			try {
				InternetAddress ia = new InternetAddress(internetAddressStr);
				address = ia.getAddress();
			} catch (AddressException e) {
//				logger.error(e.getMessage(), e);
				
				// 현대오일뱅크" <HyundaiOilbank@oilbankcard.com> 와 같이 "가 하나만 있는 경우
				// 예외가 발생하는데 이와 같은 경우에 대한 부가적인 처리를 수행한다.
	            Pattern pattern = Pattern.compile("(.*)<(.*)>");
	            Matcher matcher = pattern.matcher(internetAddressStr);
	            
	            if (matcher.find()) {
	            	address = matcher.group(2).trim();
	            	
	            	logger.debug("getAddress exception happened. new address=" + address);	            	
	            }				
			}
		}		
		
		return address;
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
			logger.debug("e.message=" + e.getMessage());
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
						if (fromHeader != null){
							name = decodeMultiLineQPEncodedName(fromHeader, name);
						}
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
			logger.debug("e.message=" + e.getMessage());
		} 
		catch (UnsupportedEncodingException e) {		
			logger.debug("e.message=" + e.getMessage());	
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
						logger.debug("e.message=" + e.getMessage());
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
		return getStringListOfAddresses(addresses, null, isPureAscii);
	}
	
	public String getStringListOfAddresses(Address[] addresses, String[] recipientHeaderArray, boolean isPureAscii) {
		String stringList = "";
		
		if (addresses != null) {
			StringBuilder addressBuilder = new StringBuilder();
			for (int i = 0; i < addresses.length; i++) {
				Address address = addresses[i];
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
							if (recipientHeaderArray != null) {
								String recipientHeader = recipientHeaderArray[i];
								
			                    // gb2312로 인코딩되어 있다고 기술되어 있지만 gbk에서 
			                    // 정의되어 있는 글자가 포함되어 디코딩 시 깨지는 문제가 발생하여 gbk로 디코딩 처리하는 코드를 추가함.						
								String newHeader = changeCharSet(recipientHeader, "gb2312", "gbk");
								
								// gb2312에서 gbk로 변경된 경우
								if (!newHeader.equals(recipientHeader)) {
						            int endPos = newHeader.indexOf("?=", 2);
						            
						            // 주소 부분을 제외한 이름 파트만 분리한다.
						            if (endPos > -1) {
						            	name = newHeader.substring(0, endPos + 2);
						            }
								}										
							}
							
							name = MimeUtility.decodeText(name);
						}
					} catch (UnsupportedEncodingException e) {
						logger.debug("e.message=" + e.getMessage());
					}
					
					if (name != null) {
						// 료비에서 수신한 메일 중 \(backslash)" 가 문자열 내부에 포함되는 경우가 있어 추가함.
						// 예) =?iso-2022-jp?B?Im1hLXgtOTMyQGRvY29tby5uZS5qcCI=?=<ma-x-932@docomo.ne.jp>
						name = name.replace("\\\"", "");
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
		String subject = "";
		String originalSubject = "";
		
        try {		
	        subject = message.getSubject();
	        
	        if (subject == null) {
	        	subject = "";
	        }
	        
	        originalSubject = subject;
                
	        if (!subject.equals("")) {
	            String[] rawHeaders = message.getHeader("subject");
				if (rawHeaders != null){
					String rawHeader = rawHeaders[0].trim();
					if (rawHeader != null){
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

							// 일부 Mailer에서 표준을 지키지 않고 큰 따옴표 두개로 감싸서
							// Subject를 구성하여 디코딩이 안 되는 경우가 있어 추가함
							// ex: "=?euc-kr?B?".Z3ctc25zLW5vZGUyICgyMjAuNzMuMTc4LjE4KSBbMV0gZ3ctc25zLW5vZGUyIENQVSBVc2VkICglKQ==."?="
							if (rawHeader.startsWith("\"=?") && rawHeader.endsWith("?=\"")) {
								rawHeader = rawHeader.substring(1, rawHeader.length() - 1);

								subject = String.format("\"%s\"", MimeUtility.decodeText(rawHeader));
							}

							if (rawHeader.startsWith("=?")) {
								int secondQuestionPos = rawHeader.indexOf("?", 2);
								int thirdQuestionPos = rawHeader.indexOf("?", secondQuestionPos + 1);
								String charSetAndEncoding = rawHeader.substring(0, thirdQuestionPos + 1);
								String encoding = rawHeader.substring(secondQuestionPos + 1, thirdQuestionPos);

								String charSet = rawHeader.substring(2, secondQuestionPos).toLowerCase();

								// cp932는 자바에서 아예 인식되지 않는 코드여서 ms932로의 변경을 먼저 수행한다.
								if (charSet.equals("cp932")) {
									rawHeader = rawHeader.replace(charSet, "ms932");
									charSetAndEncoding = rawHeader.substring(0, thirdQuestionPos + 1);

									subject = MimeUtility.decodeText(rawHeader);
								} else if (charSet.equals("iso-8859-8-i")){
									rawHeader = rawHeader.replace(charSet, "iso-8859-8");
									charSetAndEncoding = rawHeader.substring(0, thirdQuestionPos + 1);

									subject = MimeUtility.decodeText(rawHeader);
								}

								// 일부 Mailer에서 RFC 2047에서 정의된 encoded word를 2개 이상의 라인으로 구성할 때
								// 한글의 한 글자를 표현하는 Byte Array 중간에서 분리하는 경우가 있어(Base64 인코딩을 사용하면서)
								// 이 경우 JavaMail에서 디코딩할 때 글자가 깨지는 현상이 발생하여 한 줄로 합치는 작업을 직접 수행하도록 함.
								// 글자가 깨지는 경우 Unicode의 Replacement Character인 �가 나타남.
								if (subject.contains("�")
										&& encoding != null && encoding.equalsIgnoreCase("B")) {
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
								if (charSet.equals("ks_c_5601-1987")) {
									rawHeader = rawHeader.replace(charSet, "ms949");

									subject = MimeUtility.decodeText(rawHeader);
								} else if (charSet.equals("gb2312")) {
									rawHeader = rawHeader.replace(charSet, "gbk");

									subject = MimeUtility.decodeText(rawHeader);
									// 료비에서 구자체 한문을 사용하는 메일의 경우 iso-2022-jp로 인코딩되어 있으나
									// 표시가 제대로 되지 않아 x-windows-iso2022jp로 변경처리함
								} else if (charSet.equals("iso-2022-jp")) {
									rawHeader = rawHeader.replace(charSet, "x-windows-iso2022jp");

									subject = MimeUtility.decodeText(rawHeader);
								}

								// 료비에서 의뢰한 메일 중 제목이
								// Subject: =?UTF-8?Q?=E7=B5=A6=E4=B8=8E=E6=98=8E=E7=B4=B0=E6=9B=B8 (2019=E5=B9=B4
								//  10=E6=9C=88) [=E7=A4=BE=E5=93=A1=E7=95=AA=E5=8F=B7:81706]?=
								// 와 같은 경우 여전히 subject가
								// =?UTF-8?Q?=E7=B5=A6=E4=B8=8E=E6=98=8E=E7=B4=B0=E6=9B=B8 (2019=E5=B9=B4 10=E6=9C=88) [=E7=A4=BE=E5=93=A1=E7=95=AA=E5=8F=B7:81706]?=
								// 로 디코딩되지 않은 형태로 나온다. 이 때 공백 문자를 =20으로 변경하면 제대로 디코딩이 이루어진다.
								if (subject.startsWith("=?")) {
									if (encoding != null && encoding.equalsIgnoreCase("Q")) {
										subject = MimeUtility.decodeText(subject.replace(" ", "=20"));
									}
								}
							}
						}
					}

				}
	            
	            // 제목 중간에 Unicode 0x0(NULL)이 들어가 XML 파싱시 에러가 발생하는 메일이 발견되어 추가함.
	            subject = subject.replaceAll("[\\000]+", "");   
	            
	            // Non US-ASCII 문자로 인코딩된 제목 중에 unfolding이 제대로
	            // 되지 않아 줄바꿈 문자가 포함되는 경우가 있어 추가함
	            // Subject: 메일발송 실패:"대합일반산단 진입도로 공\
	            //	 고문 및 자기소개서 양식"            
	            if (subject.contains("\\\r\n ")) {
	                logger.debug("still folded subject=" + subject);
	                
	                subject = subject.replace("\\\r\n ", "");                
	            }
	
	            // Mac Outlook 보낸 메일의 제목이 decoding 되지 않은 패턴을 찾아 다시 decoding한다.
	            // 대괄호와 같은 문자와 한글이 혼용될 때 아래의 오른쪽 부분과 같이 제대로 디코딩되지 않는 경우가 발생함.
	            // RFC2047에 따른 인코딩이 한 줄에 여러 개가 있는 형태여서 JavaMail에서 문제가 발생하는 것으로 추정됨.
	            // Re: [캠코선박운용]메일 오류 => Re: [=?UTF-8?B?7Lqg7L2U7ISg67CV7Jq07Jqp?=]=?UTF-8?B?66mU7J28?=  오류
	            // Re: 회신: [ 캠코선박운용] 메신저 오류 => Re: 회신: [=?UTF-8?B?IOy6oOy9lOyEoOuwleyatOyaqQ==?=]  메신저 오류
	            Pattern pattern = Pattern.compile("=\\?(.*?)\\?=");
	            Matcher matcher = pattern.matcher(subject);
	
	            while (matcher.find()) {
	                String encData = matcher.group();
	                String decData = MimeUtility.decodeText(encData);
	                logger.debug("encData:" + encData + ",decData:" + decData);
	
	                subject = subject.replace(encData, decData);
	            }
	        }
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);

			// 디코딩 도중 예외가 발생하면 원제목을 반환하여 예외가 발생하더라도 메일 목록이 아예 표시되지 않는 등의 현상이 발생하지 않도록 한다.
			subject = originalSubject;
        } catch (Exception e) {
        	logger.error(e.getMessage(), e);
        	
        	// 디코딩 도중 예외가 발생하면 원제목을 반환하여 예외가 발생하더라도 메일 목록이 아예 표시되지 않는 등의 현상이 발생하지 않도록 한다.
        	subject = originalSubject;
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
		} catch (MalformedInputException e){
			return false;
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
			logger.debug("e.message=" + e.getMessage());
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
	
	public List<String> getBodyInfo(Part part, String folderPath, long uid, 
			int bodyPartIndex, List<Map<String, String>> attachedFileList, boolean forPrint, boolean mobile, Locale locale, 
			String secureKey, String securePassword) throws Exception {
		
		Map<String, Object> extraMap = new HashMap<String, Object>();
		
		extraMap.put("forPrint", forPrint);
		extraMap.put("mobile", mobile);
		extraMap.put("secureKey", secureKey);
		extraMap.put("securePassword", securePassword);
		extraMap.put("includeInlineAsAttachment", false);
		
		return this.getBodyInfo(part, folderPath, uid, bodyPartIndex, attachedFileList, locale, extraMap);
	}

	public List<String> getBodyInfo(Part part, String folderPath, long uid, 
			int bodyPartIndex, List<Map<String, String>> attachedFileList, Locale locale, Map<String, Object> extraMap) throws Exception {
		return this.getBodyInfo(part, folderPath, uid, bodyPartIndex, attachedFileList, locale, extraMap, 0, 0);
	}
	
	/**
	 * 메일 Multipart 정보 반환 함수
	 */
	public List<String> getBodyInfo(Part part, String folderPath, long uid, 
			int bodyPartIndex, List<Map<String, String>> attachedFileList, Locale locale, Map<String, Object> extraMap, int order, int depth) throws Exception {
		List<String> resultList = new ArrayList<String>();
		
		String htmlBody = "";
		String pAttachListHtml = "";
		String filesize = "0";
		String filecnt = "0";
		String isAttach = "";
		String previewImageListHtml = "";
		String isIcalMail = "";
		
		logger.debug("contentType=" + part.getContentType());
		logger.debug("disposition=" + part.getDisposition());
				
		boolean forPrint = false;
		boolean mobile = false;
		String secureKey = null;
		String securePassword = null;
		boolean includeInlineAsAttachment = false;
		String shareId = null;
		String useImageConvertServer = null;	// 20200312 조진호 - 메일 읽기 > 첨부파일 미리 보기 기능 옵션 처리 추가
		boolean useWebfolder = false;			// 20230418 김은실 - 메일 읽기 > 첨부파일 웹폴더에 저장 기능 추가
		boolean forPreviewMail = false;			// 20250213 김대현 - 메일 리스트 > 메일 미리보기 기능 추가
		
		// 료비에서 수신한 메일 중에 text/plain 파트만 있으면서
		// ContentID 없이 Content-Dispostion이 inline으로 첨부된
		// 이미지가 있어 이 경우 첨부파일로서 처리하기 위해 추가함.(iPhone Mail에서 작성한 메일임.)
		boolean isInlinePartWithoutContentID = false;
		
		if (part instanceof MimePart) {
			if (part.getDisposition() != null 
					&& part.isMimeType("image/*")
					&& part.getDisposition().equalsIgnoreCase(Part.INLINE)
					&& ((MimePart)part).getContentID() == null) {
				isInlinePartWithoutContentID = true;
			}
		}
		
		if (extraMap != null) {
			if (extraMap.get("forPrint") != null) forPrint = (boolean)extraMap.get("forPrint");
			if (extraMap.get("mobile") != null) mobile = (boolean)extraMap.get("mobile");
			if (extraMap.get("secureKey") != null) secureKey = (String)extraMap.get("secureKey");
			if (extraMap.get("securePassword") != null) securePassword = (String)extraMap.get("securePassword");
			if (extraMap.get("includeInlineAsAttachment") != null) includeInlineAsAttachment = (boolean)extraMap.get("includeInlineAsAttachment");
			if (extraMap.get("shareId") != null) shareId = (String)extraMap.get("shareId");
			if (extraMap.get("useImageConvertServer") != null) useImageConvertServer = (String)extraMap.get("useImageConvertServer");
			if (extraMap.get("useWebfolder") != null) useWebfolder = (boolean)extraMap.get("useWebfolder");
            if (extraMap.get("forPreviewMail") != null) forPreviewMail = (boolean)extraMap.get("forPreviewMail");
		}
		
		// 첨부 파일이면서 Content-ID가 있는 경우 실제 HTML 본문에서 참조되고 있는 파트인지 확인하기 위해 추가함(Gmail에서 보낸 메일).
		// 실제 참조되지 않는 경우엔 Content-ID가 있어도 첨부 파일로 처리하기 위한 조치임.
		// 예) Content-Type: application/vnd.openxmlformats-officedocument.presentationml.presentation; 
		//        name="=?UTF-8?B?7Iuc7JWIIOyalOyyreyCrO2VrV8yMDIwMTAwNS5wcHR4?="
	    //    Content-Disposition: attachment; 
		//        filename="=?UTF-8?B?7Iuc7JWIIOyalOyyreyCrO2VrV8yMDIwMTAwNS5wcHR4?="
	    //    Content-Transfer-Encoding: base64
	    //    Content-ID: <f_kfxpw01d0>				 
		boolean isAttachmentWithUnreferencedContentID = false;
		
		// 다음과 같이 text/html이면서 Content-ID가 있는 경우가 있어 첨부파일로 취급되지 않도록 text/html을 제외하기 위한 조건을 추가함(text/plain도 함께 추가함).
		// Content-Type: text/html; charset="ks_c_5601-1987"
		// Content-ID: <67617439CE1CE54088B6FC9F88EE8937@mobis.co.kr>
		// Content-Transfer-Encoding: quoted-printable
		// 
		// dhlee : 20240722
		//   text/html 본문이 있으면서 첨부로 text/html 파트가 있고 해당 파트에 Content-ID가 있는 경우가 발견되어
		//   이미 text/html 본문이 발견된 경우에는 text/html 혹은 text/plain 파트라도 Content-ID가 있는 경우
		//   해당 Content-ID가 본문에서 참조되는지 여부를 살펴보도록 수정함
		//   예)
		//      Content-Type: text/html; name="NTS_eTaxInvoice.html"
		//      Content-Description: NTS_eTaxInvoice.html
		//      Content-Disposition: attachment; filename="NTS_eTaxInvoice.html"; size=93696;
		if ((!part.isMimeType("text/html") && !part.isMimeType("text/plain") || extraMap.get("htmlBody") != null) && ((MimePart)part).getContentID() != null) {
			String htmlBodyContent = (String)extraMap.get("htmlBody");
			String contentID = ((MimePart) part).getContentID();
			
			// htmlBody가 없다면 Content-ID 존재 여부 상관없이 무조건 첨부라고 판단
			if (htmlBodyContent == null) {
				isAttachmentWithUnreferencedContentID = true;
			} else {
				if (contentID.startsWith("<")) {
					contentID = contentID.substring(1);
				}

				if (contentID.endsWith(">")) {
					contentID = contentID.substring(0, contentID.length() - 1);
				}

				if (!htmlBodyContent.contains("contentId=%3C" + URLEncoder.encode(contentID, "UTF-8") + "%3E")) {
					isAttachmentWithUnreferencedContentID = true;
				}
			}

			logger.debug("attachment with contentID={}, isAttachmentWithUnreferencedContentID={}", contentID, isAttachmentWithUnreferencedContentID);
		}
		
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
		//
		// pacific에서 보낸 메일 중에 multipart/related안에 text/plain 파트만 있고 인라인 이미지가 첨부된 
		// 경우가 있어 이 경우엔 인라인 이미지를 첨부 파일 형태로 표시하기 위해 includeInlineAsAttachment를 조건에 추가함.
		// ATTACHMENT라도 ContentID가 있는 경우에는 내부에서 참조되는 인라인 이미지일 수 있으므로 제외함.
		if ((part.getDisposition() != null && part.getDisposition().equalsIgnoreCase(Part.ATTACHMENT) && ((MimePart)part).getContentID() == null)
				|| part.getContentType() != null && part.getContentType().contains("x-apple-part-url")
				|| isAttachmentWithUnreferencedContentID
				|| includeInlineAsAttachment
				|| (part.isMimeType("application/*") && ((MimePart)part).getContentID() == null)
				|| isInlinePartWithoutContentID
		        || part.isMimeType("message/rfc822")) {
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
		    
            // part.getFileName 메소드가 반환하는 파일명은 인코딩된 형태인 경우도 있고
            // 디코딩이 수행된 형태인 경우도 있다.
            // 인코딩된 상태로 반환되는 경우 예: =?UTF-8?B?Mu2VmeuFhC56aXA=?=
		    // 디코딩된 상태로 변환되는 경우 예: 료비_20160824 (002)_검토_dhlee.xlsx
		    // 디코딩된 경우 디코딩 이전 인코딩 예: filename*=euc-kr''%B7%E1%BA%F1%5F20160824%20%28002%29%5F%B0%CB%C5%E4%5Fdhlee.xlsx
			String filename = Objects.isNull(part.getFileName()) ? "" : part.getFileName();

			logger.debug("filename=" + filename + ",index=" + bodyPartIndex + ",order=" + order + ",depth=" + depth);

            String NonAsciiFilename = null;
            String originalFilename = null;
		    String[] headers = part.getHeader("Content-Disposition");
		    
		    if (headers != null && headers.length > 0) {
		        String contentDisposition = headers[0];
		        
		        logger.debug("Content-Disposition=" + contentDisposition);
				ContentDisposition cd = new ContentDisposition(contentDisposition);
				String cdFilename = cd.getParameter("filename");

				/**
				 * 첨부파일 이름이 Content-Disposition이 아닌, Content-Type에 붙은 경우가 있음.
				 * Disposition에서 발견되지 않으면 위에서 구한 filename을 가지도록 수정함.
				 *
				 * (보통) Content-Disposition: attachment;	filename="=?UTF-8?B?7ZWc6riALnR4dA==?="
				 * (예외) Content-Type: text/plain; 		name="=?UTF-8?B?7ZWc6riALnR4dA==?="
				 */
				logger.debug("Content-Disposition filename=" + cdFilename);
				cdFilename = StringUtils.defaultIfBlank(cdFilename, filename);
		        
		        // 표준에 의하면 filename은 US-ASCII 로만 어루어져야 하지만 그렇지 않은 비표준 메일들이 있다.
		        // 예) contentDisposition=attachment;   filename="2016³â 2Â÷ ÀÚ»ì¿¹¹æ±³À° ÁöµµÀÚ ¾ç¼º ¾È³».hwp"
		        if (!isPureAscii(cdFilename)) {
    		        NonAsciiFilename = cdFilename;
		        } else {
                    originalFilename = cdFilename;
		        }
		    }
		    
		    logger.debug("NonAsciiFilename=" + NonAsciiFilename);
		    logger.debug("originalFilename=" + originalFilename);
			
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
            } else if (originalFilename != null && originalFilename.startsWith("=?gb2312")) {
                originalFilename = originalFilename.replace("gb2312", "gbk");
                
                logger.debug("originalFilename changed gb2312 to gbk.");
                
                filename = MimeUtility.decodeText(originalFilename);
            // 일본어 파일명에 원형 숫자가 포함되면 문자가 깨져서 cp50220으로 변환하도록 함.
            // 료비에서 구자체 한문을 사용하는 메일의 경우 iso-2022-jp로 인코딩되어 있으나
            // 표시가 제대로 되지 않아 cp50220에서 x-windows-iso2022jp로 변경처리함.
            // x-windows-iso2022jp는 원형 숫자도 제대로 표시함.
            } else if (originalFilename != null && originalFilename.startsWith("=?iso-2022-jp")) {
                originalFilename = originalFilename.replace("iso-2022-jp", "x-windows-iso2022jp");
                
                logger.debug("originalFilename changed iso-2022-jp to x-windows-iso2022jp.");
                
                filename = MimeUtility.decodeText(originalFilename);
            } else if (originalFilename != null && originalFilename.startsWith("=?cp932")) {
                originalFilename = originalFilename.replace("cp932", "ms932");
                
                logger.debug("originalFilename changed cp932 to ms932.");
                
                filename = MimeUtility.decodeText(originalFilename);
            } else if (filename != null) {
				if (isPureAscii(filename)) {
				    // Content-Disposition 헤더에 있는 filename 속성의 값이 Non-Ascii 문자를 포함할 경우에는 직접 디코딩을 처리한다.
                    if (NonAsciiFilename !=  null) {
                        byte[] rawBytes = NonAsciiFilename.getBytes("iso-8859-1");
                        
                        filename = decodeNonAsciiBytes(rawBytes);
                    } else {				    
                        filename = MimeUtility.decodeText(filename);
                        
                        if (originalFilename != null && originalFilename.startsWith("=?")) {
                            int secondQuestionPos = originalFilename.indexOf("?", 2);
                            int thirdQuestionPos = originalFilename.indexOf("?", secondQuestionPos + 1);
                            String charSetAndEncoding = originalFilename.substring(0, thirdQuestionPos + 1);
                            String encoding = originalFilename.substring(secondQuestionPos + 1, thirdQuestionPos);
                            
                            // 일부 Mailer에서 RFC 2047에서 정의된 encoded word를 2개 이상의 라인으로 구성할 때
                            // 한글의 한 글자를 표현하는 Byte Array 중간에서 분리하는 경우가 있어(Base64 인코딩을 사용하면서)
                            // 이 경우 JavaMail에서 디코딩할 때 글자가 깨지는 현상이 발생하여 한 줄로 합치는 작업을 직접 수행하도록 함
                            // 글자가 깨지는 경우 Unicode의 Replacement Character인 �가 나타남.                            
                            if (filename.contains("�")
                                    && encoding.equalsIgnoreCase("B")) {
                                String[] sequences = originalFilename.split(charSetAndEncoding.replaceAll("\\?", "\\\\?"));

                                if (sequences.length > 2) {
                                    logger.debug("broken multiple sequences. combining them...");
                                    logger.debug("originalFilename:" + originalFilename);

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
                                    originalFilename = combined.toString();

                                    logger.debug("combined originalFilename:" + originalFilename);

                                    filename = MimeUtility.decodeText(originalFilename);

                                    logger.debug("filename=" + filename);
                                }
                            }                            
                        }                        
                    }
			    // filename이 US-ASCII 로만 되어 있지 않은 경우는 위에서 part.getFileName 메소드에 의해 디코딩된
                // 경우로 보고 원칙적으로 해당 값을 이용한다.
				} else {
					// filename이 NonAsciiFilename과 동일한 경우는 part.getFileName 메소드에 의해 디코딩이
					// 제대로 이루어지지 않은 경우로 판단하여 직접 디코딩을 처리한다.
					// 예) Content-Type: text/plain; name="첨부파일 테스트1.txt"
					//		  Content-Transfer-Encoding: 7bit
					//		  Content-Disposition: attachment; filename="첨부파일 테스트1.txt" - EUC-KR로 인코딩됨					
					if (NonAsciiFilename !=  null && filename.equals(NonAsciiFilename)) {
                        byte[] rawBytes = NonAsciiFilename.getBytes("iso-8859-1");
                        
                        filename = decodeNonAsciiBytes(rawBytes);						
					}
				}
			} else {
				filename = "";
			}
            
            if (!filename.isEmpty()) {
            	filename = commonUtil.normalizeFileName(filename);

				// Content-Disposition: attachment; filename= 2022-11-07 09:10:52_ma_users.zip와 같이
				// filename 속성의 값이 인용부호로 둘러싸여 있지 않은 경우 공백에 의해 속성값이 종결되어 2022-11-07까지만
				// 값이 취해지는 문제가 있어 확장자가 없는 경우 originalFilename을 사용하도록 수정함.
				if (!filename.contains(".")) {
					filename = originalFilename;
				}
            }
			
            // message/rfc822 타입이면서 filename 속성이 없는 경우에는
            // 첨부된 eml의 제목으로 파일명을 설정한다.
            // 2023-05-16 이사라 : NullPointerException 시큐어코딩
			//if (part.isMimeType("message/rfc822") && filename.isEmpty()) {
            if (part.isMimeType("message/rfc822") && StringUtils.isEmpty(filename)) {
				Message nestedMessage = (Message)part.getContent();
				
				filename = getSubject(nestedMessage);;
				filename = (filename != null) ? filename + ".eml" : "ForwardedMessage.eml";
			}
                        
			if (attachedFileList != null) {
				Map<String, String> attachedFileInfo = new HashMap<String, String>();
				
				attachedFileInfo.put("filename", filename);
				attachedFileInfo.put("size", String.valueOf(size));
				attachedFileInfo.put("folderPath", folderPath);
				attachedFileInfo.put("uid", String.valueOf(uid));
				attachedFileInfo.put("index", String.valueOf(bodyPartIndex));
				attachedFileInfo.put("order", String.valueOf(order));
				attachedFileInfo.put("depth", String.valueOf(depth));
				
				attachedFileList.add(attachedFileInfo);
			} 

			// appendPreviewImage까지- filename의 변경이 없고, 여러번 수행되고 있으므로 변수 생성하여 사용하도록 함.
			String filename_spclStr = this.getSpclStrCnvr2(filename); // 네 경우 모두 사용
			String aitem = "";
			
			String folderPath_URLEnc = URLEncoder.encode(folderPath,"UTF-8").replace("+", "%20");
			if (forPrint) {
				pAttachListHtml += "<span style='cursor:pointer;'><img src='/images/icon_adddownload.gif' width='16' height='16' style='vertical-align:middle'></span>";
				pAttachListHtml += "<span><span title='" + filename_spclStr + " (" + strSize + ")" + "' class='attachFileName' onmouseover=this.style.color='#164aad' onmouseout=this.style.color='black' style='cursor:pointer' >";
				pAttachListHtml += filename_spclStr + " (" + strSize + ")</span></span></br>";
 			} else if (secureKey != null) {
				aitem = "/ezEmail/downloadSecureAttach.do?secureKey=" + URLEncoder.encode(secureKey, "UTF-8") + "&securePassword=" + URLEncoder.encode(securePassword, "UTF-8") + "&filename=" + URLEncoder.encode(filename,"UTF-8") + "&index=" + bodyPartIndex;
				pAttachListHtml += " <li><span onclick=\"DownloadAttach('" + aitem + "');\" _filehref='" + aitem + "' _filesize='" + size + "' _filename='" + EgovStringUtil.getSpclStrCnvr2(filename) + "' id='MailAttachDownloadItems' name='MailAttachDownloadItems' style='cursor:pointer;' ><img src='/images/icon_adddownload.gif' width='16' height='16'></span>";
				/*	(개선) 보안메일도 가능하도록
				if (useWebfolder) {
					pAttachListHtml += webfolderCommonSpan + " >" + webfolderCommonImg + "></span>";
				}
				*/
				pAttachListHtml += " <span onclick=\"DownloadAttach('" + aitem + "');\"><span title='" + filename_spclStr + " (" + strSize + ")" + "' class='attachFileName' onmouseover=this.style.color='#164aad' onmouseout=this.style.color='black' style='cursor:pointer' >" + filename_spclStr + " (" + strSize + ")</span></span></li>";
			} else if (mobile) {
				aitem = URLEncoder.encode(folderPath,"UTF-8") + "','" + uid + "','" + URLEncoder.encode(filename,"UTF-8") + "','" + bodyPartIndex;
				
				if (shareId != null) {
					aitem += "','" + URLEncoder.encode(shareId, "UTF-8");
				}
				
				aitem += "','" + order + "','" + depth;
				
				pAttachListHtml += " <p class=\"ui-bar\" style=\"border-bottom:1px solid #e2e2e2\"><i class='fa fa-download' aria-hidden='true' \"javascript:mailFileDown('" + aitem + "');\" style='cursor:pointer'></i>";
				pAttachListHtml += " <span onclick=\"javascript:mailFileDown('" + aitem + "');\"><span title='" + filename_spclStr + " (" + strSize + ")" + "' class='attachFileName' onmouseover=this.style.color='#164aad' onmouseout=this.style.color='black' style='cursor:pointer' >" + filename_spclStr + " (" + strSize + ")</span></span>";
				pAttachListHtml += " </p>";
			} else if (forPreviewMail) {
				// 메일 미리보기
				String filename_egovSpclStr = EgovStringUtil.getSpclStrCnvr2(filename);

				aitem = "/ezEmail/downloadAttach.do?mode=Attach&folderPath="+folderPath_URLEnc+"&uid="+uid+"&filename="+URLEncoder.encode(filename,"UTF-8")+"&index="+bodyPartIndex + "&order=" + order + "&depth=" + depth;

				if (shareId != null) {
					aitem += "&shareId=" + URLEncoder.encode(shareId, "UTF-8");
				}

				pAttachListHtml += "<li>";

				pAttachListHtml += " <span onclick=\"DownloadAttach('" + aitem + "');\"><span title=\"" + filename_spclStr + " (" + strSize + ")" + "\" class='attachFileName' onmouseover=this.style.color='#164aad' onmouseout=this.style.color='black' style='cursor:pointer' >" + filename_spclStr + " (" + strSize + ")</span></span>";

				// 다운로드 아이콘
				pAttachListHtml += " <span onclick=\"DownloadAttach('" + aitem + "');\" _filehref='" + aitem + "' _filesize='" + size + "' _filename=\"" + filename_egovSpclStr + "\" id='MailAttachDownloadItems' name='MailAttachDownloadItems' ><img src='/images/icon_adddownload.gif' width='16' height='16' style='vertical-align: top; cursor:pointer'></span>";

				pAttachListHtml += "</li>";

			} else {

				aitem = "/ezEmail/downloadAttach.do?mode=Attach&folderPath="+folderPath_URLEnc+"&uid="+uid+"&filename="+URLEncoder.encode(filename,"UTF-8")+"&index="+bodyPartIndex + "&order=" + order + "&depth=" + depth;
				
				if (shareId != null) {
					aitem += "&shareId=" + URLEncoder.encode(shareId, "UTF-8");
				}
				
				pAttachListHtml += " <li><span onclick=\"DownloadAttach('" + aitem + "');\" _filehref='" + aitem + "' _filesize='" + size + "' _filename=\"" + filename_spclStr + "\" id='MailAttachDownloadItems' name='MailAttachDownloadItems' style='cursor:pointer;' class='imgSpan' ><img src='/images/icon_adddownload.gif' width='16' height='16' style='vertical-align: top;'></span>";

				// 2023-04-18 김은실 - 메일 & 웹폴더 연계 기능
				if (useWebfolder) {
					String webfolderCommonSpan = " <span onclick=\"webfolderUpload_open(this);\" title='" + egovMessageSource.getMessage("ezWebFolder.kes065", locale) + "' _filesize='" + (int) size + "' _filetype='" + part.getContentType().toLowerCase() + "' _filename=\"" + filename_spclStr + "\" _folderPath=\"" + folderPath + "\" _uid='" + uid + "' _index='" + bodyPartIndex + "' id='MailAttachDownloadItems_webfolder' name='MailAttachDownloadItems_webfolder' style='cursor:pointer;'";
					String webfolderCommonImg = "<img src='/images/icon_adddownload_webfolder.gif' width='16' height='16'";

					pAttachListHtml += webfolderCommonSpan + " class='imgSpan' >" + webfolderCommonImg + " style='vertical-align: top;'></span>";
				}

				pAttachListHtml += " <span onclick=\"DownloadAttach('" + aitem + "');\"><span title=\"" + filename_spclStr + " (" + strSize + ")" + "\" class='attachFileName' onmouseover=this.style.color='#164aad' onmouseout=this.style.color='black' style='cursor:pointer' >" + filename_spclStr + " (" + strSize + ")</span></span>";
				if (useImageConvertServer != null && !useImageConvertServer.equalsIgnoreCase("0")) {
					pAttachListHtml += " <span class='icon_rbtn2' style='right: 30px;' title='" + egovMessageSource.getMessage("ezEmail.t487", locale) + "' fileid='" + bodyPartIndex + "' onclick=\"AttachFile_Preview('" + folderPath_URLEnc + "','" + uid + "','" + bodyPartIndex + "','" + filename_spclStr.replace("'", "\\'") + "');\"><img src='/images/icon_preview.png' width='16' height='16' style='vertical-align: top'></span>";
				}

				if (!"drafts".equalsIgnoreCase(folderPath)) {
					pAttachListHtml += " <span class='icon_rbtn' fileid='" + bodyPartIndex + "' onclick=\"AttachFile_Delete(this);\"><img src='/images/icon_reddelete.gif' width='16' height='16' style='vertical-align: top'></span></li>";
				}
			}

			appendPreviewImage: if (part.isMimeType("image/*")) {
				// .psd 등 웹 브라우저에서 지원하지 않는 이미지인지 검사
				for (String unsupportedContentType : UNSUPPORTED_PREVIEW_CONTENT_TYPES) {
					if (part.isMimeType(unsupportedContentType)) {
						break appendPreviewImage;
					}
				}
				
				if (useImageConvertServer != null && !useImageConvertServer.equalsIgnoreCase("0")) {
					previewImageListHtml += " <div><p class=imageArea><a onclick=\"AttachFile_Preview('" + folderPath_URLEnc + "','" + uid + "','" + bodyPartIndex + "','" + filename_spclStr.replace("'", "\\'") + "');\">";
				} else {
					previewImageListHtml += " <div><p class=imageArea><a target=_blank href='" + aitem + "&readStatus=Y"+ "'>";
				}
				previewImageListHtml += " <img src='" + aitem + "' _filesize='" + size + "' _filename='" + EgovStringUtil.getSpclStrCnvr2(filename) + "' style='cursor:pointer;'></a></p>";
				previewImageListHtml += " <p onclick=\"DownloadAttach('" + aitem + "');\"><span title='" + filename_spclStr + " (" + strSize + ")" + "' class='attachImageeName' onmouseover=this.style.color='#164aad' onmouseout=this.style.color='black' style='cursor:pointer' >" + filename_spclStr + " (" + strSize + ")</p></div>";
			}

			isAttach = "OK";
			filesize = (Double.parseDouble(filesize) + size) + "";
			filecnt = (Integer.parseInt(filecnt) + 1) + "";
		} else if(part.isMimeType("text/html")){
			// multipart/related가 중첩되어 있는 경우
			// 이전 multipart/related 파트에서 이미 text/html 파트가 발견된 경우가 있어
			// 이를 나타내기 위해 추가함.
			extraMap.put("htmlPartFound", true);
			
			String strContent = null;			
			String contentType = part.getContentType();
			
			String[] headers = part.getHeader("Content-Type");
			String rawContentType = "";
			
			if (headers != null) {
				rawContentType = headers[0];
			}
			
			boolean isCharSet = rawContentType.toLowerCase().contains("charset");
			
			try {
				// cp932는 자바에서 아예 인식되지 않는 코드여서 ms932로의 변경을 먼저 수행한다.				
				if (contentType.toLowerCase().contains("cp932")) {
					InputStream is = getContentInputStream(part);
					
					if (is.available() > 0) {
						byte[] buf = new byte[is.available()];
						is.read(buf);
						
						logger.debug("text/html changed cp932 to ms932.");
						
						strContent = new String(buf, "ms932");
					}											
				} else {				
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
					} else if (contentType.toLowerCase().contains("gb2312")) {
						if (strContent.contains("�")) {
							InputStream is = getContentInputStream(part);
							
							if (is.available() > 0) {
								byte[] buf = new byte[is.available()];
								is.read(buf);
								
								logger.debug("text/html changed gb2312 to gbk.");
								
								strContent = new String(buf, "gbk");
							}											
						}
					} else if (contentType.toLowerCase().contains("iso-2022-jp")) {
						if (strContent.contains("�")) {
							InputStream is = getContentInputStream(part);
							
							if (is.available() > 0) {
								byte[] buf = new byte[is.available()];
								is.read(buf);
								
								logger.debug("text/html changed iso-2022-jp to x-windows-iso2022jp.");
								
								strContent = new String(buf, "x-windows-iso2022jp");
							}											
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
			} catch (IOException e) {
				logger.error(e.getMessage(), e);

				InputStream is = getContentInputStream(part);

				if (is.available() > 0) {
					byte[] buf = new byte[is.available()];
					is.read(buf);

					strContent = decodeNonAsciiBytes(buf);
				}
			// charset 등의 값에 문제가 있을 때 Exception이 발생할 수 있다.
			// 예) Content-Type: text/html; charset="$BIZENIC.ENGINE.CHARSET$"
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				
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
				} else if (shareId != null) {
					strContent = strContent.replace(orgSrc, "src=\"/ezEmail/downloadInline.do?mode=inlineimage&folderPath=" + URLEncoder.encode(folderPath, "UTF-8") + "&uid=" + uid + "&contentId=" + URLEncoder.encode(contentId, "UTF-8") + "&shareId=" + URLEncoder.encode(shareId, "UTF-8") + "\"");						
				} else {
					strContent = strContent.replace(orgSrc, "src=\"/ezEmail/downloadInline.do?mode=inlineimage&folderPath=" + URLEncoder.encode(folderPath, "UTF-8") + "&uid=" + uid + "&contentId=" + URLEncoder.encode(contentId, "UTF-8") + "\"");						
				}
			}
			htmlBody += strContent;
			
			// style 태그가 1536개인 메일(홈플러스 메일)의 경우 IE에서 로딩이 오래 걸리는 문제가 발생하여 추가함.
			htmlBody = stripTooManyStyleTags(htmlBody);
			
			// 본문안에 따로 style태그가 들어가는 경우 sytle class= 를 찾아서 삭제하는 로직추가
			htmlBody = styleClassTagsReplace(htmlBody);
			
			// XSS(Cross Site Scripting)을 방지하기 위한 처리
			htmlBody = commonUtil.stripScriptTagsAndFunctions(htmlBody);
			
			// 메일 본문의 링크를 누르면 별도의 창으로 표시되도록 하는 처리
			htmlBody = addTargetBlank(htmlBody);		
			
			// 이후 다른 파트를 처리할 때 HTML 본문을 참조할 필요가 있는 경우를 위해
			// 추가함. Content-ID가 있는 파트가 실제 HTML 본문에서 참조되고 있는 지를 확인하기 위한 용도임.
			extraMap.put("htmlBody", htmlBody);
		} else if(part.isMimeType("text/plain")) {			
			boolean isRealTextPlain = true;
			
			if (part instanceof BodyPart) {
		        String[] contentTypeHeaders = part.getHeader("Content-Type");
		        
		        if (contentTypeHeaders != null && contentTypeHeaders.length > 0) {
		        	String contentTypeHeader = contentTypeHeaders[0];
		        	
		        	logger.debug("contentTypeHeader=" + contentTypeHeader);
		        	
		        	// 다음과 같이 Multipart 내 Part 중에 Content-Type이 잘못 생성된 메일이 있음.(image/gif가 되어야 함.)
		        	// Content-Type: gif; name="signF_hakungLogo.gif"
		        	// 이 경우 JavaMail에서는 디폴트인 text/plain 타입으로 취급하여 본문에 잘못된 내용이 들어와
		        	// 실제 헤더에 text/plain이 있는 지 여부를 확인하도록 함.
		        	if (!contentTypeHeader.toLowerCase().contains("text/plain")) {
		        		logger.debug("it isn't real text/plain.");
		        		
		        		isRealTextPlain = false;
		        	}
		        }
			}
			
	        if (isRealTextPlain) {
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
					String rawContentType = headers[0];				
					boolean isCharSet = rawContentType.toLowerCase().contains("charset");					
					
					try {
						// cp932는 자바에서 아예 인식되지 않는 코드여서 ms932로의 변경을 먼저 수행한다.	
						if (contentType.toLowerCase().contains("cp932")) {
							InputStream is = getContentInputStream(part);
							
							if (is.available() > 0) {
								byte[] buf = new byte[is.available()];
								is.read(buf);
								
								logger.debug("text/plain changed cp932 to ms932.");
								
								strContent = new String(buf, "ms932");
							}											
						} else {					
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
							} else if (contentType.toLowerCase().contains("gb2312")) {
								if (strContent.contains("�")) {
									InputStream is = getContentInputStream(part);
									
									if (is.available() > 0) {
										byte[] buf = new byte[is.available()];
										is.read(buf);
										
										logger.debug("text/plain changed gb2312 to gbk.");
										
										strContent = new String(buf, "gbk");
									}											
								}
							} else if (contentType.toLowerCase().contains("iso-2022-jp")) {
								if (strContent.contains("�")) {
									InputStream is = getContentInputStream(part);
									
									if (is.available() > 0) {
										byte[] buf = new byte[is.available()];
										is.read(buf);
										
										logger.debug("text/plain changed iso-2022-jp to x-windows-iso2022jp.");
										
										strContent = new String(buf, "x-windows-iso2022jp");
									}											
								}
							} 
						}
						
						// Content-Type 헤더에 charset 속성이 없는 경우엔 US-ASCII로만 구성되어야 한다.
						// Content-Type: text/plain 과 같이 charset이 없지만 본문이 iso-2022-jp(x-windows-iso2022jp)로 작성된 메일이 발견되어 추가함.
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
							} else {
								logger.debug("content is ascii only");
								
								InputStream is = getContentInputStream(part); 
								
								if (is.available() > 0) {
									byte[] buf = new byte[is.available()];
									is.read(buf);
									
									if (isCharEncRight(buf, "x-windows-iso2022jp")) {
										strContent = new String(buf, "x-windows-iso2022jp");
										
										logger.debug("it's x-windows-iso2022jp");																
									}
								}														
							}
						}
					} catch (IOException e) {
						logger.error(e.getMessage(), e);

						InputStream is = getContentInputStream(part);

						if (is.available() > 0) {
							byte[] buf = new byte[is.available()];
							is.read(buf);

							strContent = decodeNonAsciiBytes(buf);
						}
					// charset 등의 값에 문제가 있을 때 Exception이 발생할 수 있다.
					// 예) Content-Type: text/html; charset="$BIZENIC.ENGINE.CHARSET$"
					} catch (Exception e) {
						logger.error(e.getMessage(), e);
						
						InputStream is = getContentInputStream(part); 
												
						if (is.available() > 0) {
							byte[] buf = new byte[is.available()];
							is.read(buf);
							
							strContent = decodeNonAsciiBytes(buf);						
						}
					}				
				}
				
				strContent = commonUtil.cleanValue(strContent);
				
				strContent = convertSpaceToNBSP(strContent);
				String tempText = strContent.replaceAll("\r\n", "<br />").replaceAll("\r", "<br />").replaceAll("\n", "<br />");	
				StringBuilder tempText2 = new StringBuilder();
				String[] tempTexts = tempText.split("<br />");
				
				String defaultFontAndSize = "style='font-size:13px;font-family:" + egovMessageSource.getMessage("main.t246", locale) + "'";
				
				for (int i=0; i<tempTexts.length; i++) {
					if (!tempTexts[i].equals("")) {
						tempText2.append("<p " + defaultFontAndSize + ">" + tempTexts[i] + "</p>");
					} else {
						tempText2.append("<p " + defaultFontAndSize + ">&nbsp;</p>");
					}
				}
				
				htmlBody += tempText2.toString();
				
				htmlBody = changeURLsToAnchorTags(htmlBody);	
				htmlBody = commonUtil.stripScriptTagsAndFunctions(htmlBody);
				htmlBody = addTargetBlank(htmlBody);
	        }
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
					List<String> tempList = null;
					
					if (p.isMimeType("multipart/*")) {							
						tempList = getBodyInfo(p, folderPath, uid, i, attachedFileList, locale, extraMap, i, depth + 1);
					} else {
						tempList = getBodyInfo(p, folderPath, uid, i, attachedFileList, locale, extraMap, order, depth);
					}
					
					htmlBody += tempList.get(0);
					pAttachListHtml += tempList.get(1);
					previewImageListHtml += tempList.get(5);
					filesize = (Double.parseDouble(filesize) + Double.parseDouble(tempList.get(2))) + "";
					filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
					isIcalMail += tempList.get(6);
					
					if (tempList.get(4).equals("OK")) {
						isAttach = "OK";
					}
				}
			}
			
			if (htmlBody.equals("")) {
				for (int i = 0; i < count; i++) {
					p = mp.getBodyPart(i);
					
					if (p.isMimeType("text/plain")) {
						List<String> tempList = getBodyInfo(p, folderPath, uid, i, attachedFileList, locale, extraMap, order, depth);
						htmlBody += tempList.get(0);		
						break;				
					}
				}
			}
		} else if (part.isMimeType("multipart/mixed")) { //재귀
			Multipart mp = (Multipart)part.getContent();
			int count = mp.getCount();
			Part p = null;
			boolean isHtmlPartAlreadyProcessed = false;
			
			for (int i = 0; i < count; i++) {
				p = mp.getBodyPart(i);
				
				if (p.isMimeType("text/html")) {
					isHtmlPartAlreadyProcessed = true;
				}
				
				// 안드로이드 삼성 메일앱이 메일 발송 시 Sent 폴더에 넣은 메일이 
				// alternative part가 아닌 mixed part에 text/html과 text/plain을 함께
				// 넣어 메일이 두 번 반복해 보이는 현상이 있어 추가함.
				// text/plain 타입이 첨부된 경우 첨부파일이 나타나지 않는 현상이 있어 다음 조건 추가함
				//  - !((p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)))
				if (isHtmlPartAlreadyProcessed && p.isMimeType("text/plain")
						&& !((p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)))) {
					logger.debug("contentType=" + p.getContentType());
					logger.debug("disposition=" + p.getDisposition());	
				} else {				
					List<String> tempList = null;
					
					if (p.isMimeType("multipart/*")) {
						tempList = getBodyInfo(p, folderPath, uid, i, attachedFileList, locale, extraMap, i, depth + 1);
					} else {
						tempList = getBodyInfo(p, folderPath, uid, i, attachedFileList, locale, extraMap, order, depth);						
					}
					
					htmlBody += tempList.get(0);
					pAttachListHtml += tempList.get(1);
					previewImageListHtml += tempList.get(5);
					filesize = (Double.parseDouble(filesize) + Double.parseDouble(tempList.get(2))) + "";
					filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
					isIcalMail += tempList.get(6);
					
					if (tempList.get(4).equals("OK")) {
						isAttach = "OK";
					}
				}
			}
		} else if (part.isMimeType("multipart/related")) {
			Multipart mp = (Multipart)part.getContent();
			int count = mp.getCount();
			
			for (int i = 0; i < count; i++) {
				Part p = mp.getBodyPart(i);
				
				// text/html 파트가 나오거나 multipart/alternative 파트가 나올 수도 있다.
				// ContentID가 있는 경우에는 내부에서 참조되는 인라인 이미지일 수 있으므로 제외함.
				if (p.isMimeType("text/html") 
						|| !p.isMimeType("text/plain") 
						&& !(p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.INLINE))
						&& ((MimePart)p).getContentID() == null
						) {
					// 코린도에서 수신된 메일 중 multipart/related 안에 첨부파일이 있는 경우가 있어 패러메터값을 -1 대신 i로 변경함
					List<String> tempList = null;
					
					if (p.isMimeType("multipart/*")) {
						tempList = getBodyInfo(p, folderPath, uid, i, attachedFileList, locale, extraMap, i, depth + 1);
					} else {
						tempList = getBodyInfo(p, folderPath, uid, i, attachedFileList, locale, extraMap, order, depth);
					}
					
					htmlBody += tempList.get(0);
					pAttachListHtml += tempList.get(1);
					previewImageListHtml += tempList.get(5);
					filesize = (Double.parseDouble(filesize) + Double.parseDouble(tempList.get(2))) + "";
					filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
					isIcalMail += tempList.get(6);
					
					if (tempList.get(4).equals("OK")) {
						isAttach = "OK";
					}
				// 료비에서 온 메일 중에 related 파트안에 인라인으로 첨부파일이 있는 메일이 있어 추가함.
				} else if (p.isMimeType("application/*")) { 
					List<String> tempList = getBodyInfo(p, folderPath, uid, i, attachedFileList, locale, extraMap, order, depth);
					htmlBody += tempList.get(0);
					pAttachListHtml += tempList.get(1);
					filesize = (Double.parseDouble(filesize) + Double.parseDouble(tempList.get(2))) + "";
					filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
					isIcalMail += tempList.get(6);
					
					if (tempList.get(4).equals("OK")) {
						isAttach = "OK";
					}					
				} else {
					logger.debug("contentType=" + p.getContentType());
					logger.debug("disposition=" + p.getDisposition());
				}
			}
			
			// multipart/related가 중첩되어 있는 경우
			// 이전 multipart/related 파트에서 이미 text/html 파트가 발견된 경우가 있어
			// 이를 확인함.
			boolean htmlPartFound = (boolean) (extraMap.get("htmlPartFound") == null ? false : extraMap.get("htmlPartFound"));
			
			logger.debug("htmlPartFound=" + htmlPartFound);
			
			// text/html 파트 혹은 multipart/alternative 파트가 발견되지 않았을 경우엔 
			// text/plain 파트를 찾는다.
			// pacific에서 보낸 메일 중에 multipart/related안에 text/plain 파트만 있고 인라인 이미지가 첨부된 
			// 경우가 있어 추가함.
			if (!htmlPartFound) {
				logger.debug("htmlPartFound is false. Trying to find the text/plain part..");
				
				for (int i = 0; i < count; i++) {
					Part p = mp.getBodyPart(i);
					
					if (p.isMimeType("text/plain")) {
						List<String> tempList = getBodyInfo(p, folderPath, uid, i, attachedFileList, locale, extraMap, order, depth);
						htmlBody += tempList.get(0);						
					// 료비에서 온 메일 중에 related 파트안에 인라인으로 첨부파일이 있는 메일이 있음. 이 경우 위에서 MIME Type이 application인 경우
					// 이미 첨부파일로 추가되었기 때문에 중복 추가되지 않도록 하기 위해 !p.isMimeType("application/*") 조건을 추가함.
					// Content-Disposition: inline 지정이 없이 Content-ID만 있는 경우도 있어 || ((MimePart)p).getContentID() != null
					// 조건을 추가함.
					//   예) Content-Type: image/png;
					//	        name="00000000000000028784.png"
					//		Content-Transfer-Encoding: base64
					//		Content-ID: <00000000000000028784.png@12345678.87654321>
					} else if ((p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.INLINE) || ((MimePart)p).getContentID() != null)
							&& !(p.isMimeType("application/*") && ((MimePart)p).getContentID() == null)) {						
						extraMap.put("includeInlineAsAttachment", true);
						List<String> tempList = getBodyInfo(p, folderPath, uid, i, attachedFileList, locale, extraMap, order, depth);
						extraMap.put("includeInlineAsAttachment", false);
						htmlBody += tempList.get(0);
						pAttachListHtml += tempList.get(1);
						previewImageListHtml += tempList.get(5);
						filesize = (Double.parseDouble(filesize) + Double.parseDouble(tempList.get(2))) + "";
						filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
						isIcalMail += tempList.get(6);
						
						if (tempList.get(4).equals("OK")) {
							isAttach = "OK";
						}						
					}
				}				
			}
		} else if (part.isMimeType("multipart/*")) {
			Multipart mp = (Multipart)part.getContent();
			int count = mp.getCount();
			
			for (int i = 0; i < count; i++) {
				Part p = mp.getBodyPart(i);
				
				List<String> tempList = null;
				
				if (p.isMimeType("multipart/*")) {
					tempList = getBodyInfo(p, folderPath, uid, i, attachedFileList, locale, extraMap, i, depth + 1);
				} else {
					tempList = getBodyInfo(p, folderPath, uid, i, attachedFileList, locale, extraMap, order, depth);
				}
				
				htmlBody += tempList.get(0);
				pAttachListHtml += tempList.get(1);
				previewImageListHtml += tempList.get(5);
				filesize = (Double.parseDouble(filesize) + Double.parseDouble(tempList.get(2))) + "";
				filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
				isIcalMail += tempList.get(6);
				
				if (tempList.get(4).equals("OK")) {
					isAttach = "OK";
				}
			}
		} else if (part.isMimeType("text/calendar")) {
			isIcalMail = "Y";
			String icalHtml = getIcalMailPartHTML(part, locale);
 			htmlBody += icalHtml;
		}
		
		resultList.add(htmlBody);
		resultList.add(pAttachListHtml);
		resultList.add(filesize);
		resultList.add(filecnt);
		resultList.add(isAttach);
		resultList.add(previewImageListHtml);
		resultList.add(isIcalMail);
			
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
			} catch (MessagingException e) {
				logger.error(e.getMessage(), e);

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
            // charset 등의 값에 문제가 있을 때 Exception이 발생할 수 있다.
            // 예) Content-Type: text/html; charset="$BIZENIC.ENGINE.CHARSET$"
            } catch (Exception e) {
                logger.error(e.getMessage(), e);
                
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

	/** password default : _jmocha_101 */
	public void useIMAPAccessWithCallback(Consumer<IMAPAccess> callback, String userAccount, Locale locale) {
		useIMAPAccessWithCallback(callback, userAccount, commonUtil.getMailPassword(), locale); // _jmocha_101
	}

    /**
     * IMAPAccess를 생성해주는 Util.
     * : folder.close()전에야 MimeBodyPart를 이용한 수행이 가능.
     * @param callback : (folder를 이용할 작업을 할 ) callback함수를 매개변수로 전해주면 된다.
     * @param userAccount : getUserAccount()로 구해주면 됨. (extraMap를 callback함수에서 써야 할 수 있으므로, 해당 함수에서 통합하지 않았다. //getMailMessage()에서 extraMap필요.)
     * @param password : 특정 password 전달 시에는 해당 password로 수행, 그 외 default 는 위에 오버로딩 되어 있음.
     * ex) EzWebfolderUtil.addListMailAttachArray()를 참고 바람.
     */
	public void useIMAPAccessWithCallback(Consumer<IMAPAccess> callback, String userAccount, String password, Locale locale) {
		logger.debug("useIMAPAccessWithCallback started. userAccount={}, locale={}", userAccount, locale);
		IMAPAccess ia = null;

		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, locale, this);

			callback.accept(ia);
		} catch (RuntimeException e) {
			logger.error("useIMAPAccessWithCallback exception", e);
		} catch (Exception e) {
			logger.error("useIMAPAccessWithCallback exception", e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		logger.debug("useIMAPAccessWithCallback ended.");
	}

	/**
	 * mailbox의 계정은 : 사용자뿐아니라, 공유사서함을 고려하여 다음과 같이 구한다.
	 */
	public String getUserAccount(String userId, String shareId, int tenantId, Map<String, Object> extraMap) throws Exception {
		logger.debug("getUserAccount started. userId={}, shareId={}, tenantId={}, extraMap={}", userId, shareId, tenantId, extraMap.toString());
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", tenantId);
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		String userAccount = userId + "@" + domainName;

		if ("YES".equalsIgnoreCase(useSharedMailbox) && !"".equals(shareId)) {
				if (!ezEmailService.checkUserShareId(userId, shareId, tenantId)) {
					logger.debug("the user cannot access the shareId.");

					logger.debug("getUserAccount ended. userId={}, userAccount={}", userId, userAccount);
					return "";
				}

				userAccount = shareId + "@" + domainName;
				extraMap.put("shareId", shareId);
		}

		logger.debug("getUserAccount ended. userId={}, userAccount={}", userId, userAccount);
		return userAccount;
	}

	/**
	 * Message 생성하기 위한 함수.
	 * @param f : open()된 folder를 사용할 것.
	 * 		// Floder가 Close되면 message를 사용할 수 없다. com.sun.mail.util.FolderClosedIOException: null
	 * @param folderPath : url 		   	// ex. url/index = "INBOX/4"
	 * @param attachedFileList : 필요하면 getMailMessage() 밖에서 선언해주면 된다.
	 */
	public Message getMailMessage(Folder f, long uid, String folderPath, List<Map<String, String>> attachedFileList
			, Locale locale, Map<String, Object> extraMap) throws Exception {
		logger.debug("getMailMessage started. Folder={}, uid={}, folderPath={}, attachedFileList.size()={}, locale={}, extraMap={}"
											, f.toString(), uid, folderPath, (attachedFileList != null)? attachedFileList.size() : "", locale, extraMap.toString());
		Message message = null;
		message = ((IMAPFolder) f).getMessageByUID(uid);

		if (message != null) {
			FetchProfile fp = new FetchProfile();

			fp.add(FetchProfile.Item.ENVELOPE);
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			fp.add(FetchProfile.Item.SIZE);
			fp.add(FetchProfile.Item.FLAGS);
			fp.add("Subject");
			fp.add("From");
			fp.add("To");
			fp.add("Cc");
			fp.add("Bcc");

			Message[] fetchMessages = new Message[] { message };
			f.fetch(fetchMessages, fp);

			// subject
			String subject = getSubject(message);
			if (subject != null && !subject.equals("")) {
				String[] rawHeaders = message.getHeader("subject");
				String rawHeader = rawHeaders[0];

				if (!isPureAscii(rawHeader)) {
					byte[] rawBytes = rawHeader.getBytes("iso-8859-1");

					subject = decodeNonAsciiBytes(rawBytes);
				}
			}

			getBodyInfo(message, folderPath, uid, -1, attachedFileList, locale, extraMap);
		}

		logger.debug("getMailMessage ended. message.toString={}", (message == null) ? "null" : message.toString());
		return message;
	}
    
    public Message[] searchFolder(IMAPAccess ia, String userAccount, Folder folder, String searchField, String searchValue, 
    		Date startDate, Date endDate, boolean searchSubFolder, boolean isUnreadOnly, boolean isImportantOnly, String sortType, boolean isAscending, 
    		int startIndex, int listCount, boolean isFromMobile, Map<String, Object> extraMap, int tenantId, String tagName) throws Exception {

    	return searchFolder(ia, userAccount, folder, new String[]{searchField}, new String[]{searchValue}, startDate, endDate, searchSubFolder, isUnreadOnly, isImportantOnly, sortType, isAscending, startIndex, listCount, isFromMobile, extraMap, tenantId, tagName);
    	
    }
    
    public Message[] searchFolder(IMAPAccess ia, String userAccount, Folder folder, String[] searchField, String[] searchValue, 
    		Date startDate, Date endDate, boolean searchSubFolder, boolean isUnreadOnly, boolean isImportantOnly, String sortType, boolean isAscending, 
    		int startIndex, int listCount, boolean isFromMobile, Map<String, Object> extraMap, int tenantId, String tagName) throws Exception {
    	logger.debug("userAccount=" + userAccount + ",folder=" + folder + ",searchField=" + searchField + ",searchValue=" + searchValue
    			+ ",startDate=" + startDate + ",endDate=" + endDate + ",searchSubFolder=" + searchSubFolder + ",isUnreadOnly=" + isUnreadOnly
    			+ ",isImportantOnly=" + isImportantOnly + ",sortType=" + sortType + ",isAscending=" + isAscending + ",startIndex=" + startIndex
    			+ ",listCount=" + listCount + ",isFromMobile=" + isFromMobile + ",extraMap=" + extraMap + ",tenantId=" + tenantId + ",tagName=" + tagName);
    	
    	String useAdvancedMailSearch = ezCommonService.getTenantConfig("useAdvancedMailSearch", tenantId);
    	logger.debug("useAdvancedMailSearch=" + useAdvancedMailSearch);
    	
    	Message[] messages = null;
    	
    	if (useAdvancedMailSearch.equals("YES")) {
    		String folderPath = "";
    		
    		// folder is null when searching all folder
    		if (folder != null) {
    			folderPath = folder.getFullName();
    		}
    		
    		logger.debug("folderPath=" + folderPath);
    		
    		messages = advancedSearchFolder(ia, userAccount, folder, folderPath, searchField, searchValue, startDate, endDate, 
    				searchSubFolder, isUnreadOnly, isImportantOnly, sortType, isAscending, startIndex, listCount, extraMap, tagName);
    		
    		// pre-fetch
    		if (messages.length > 0) {
    			Folder fetchFolder = messages[0].getFolder();
    			
    			FetchProfile fp = new FetchProfile();
    			fp.add(UIDFolder.FetchProfileItem.UID);
    			fp.add("X-Priority");
    			fp.add(FetchProfile.Item.CONTENT_INFO);
    			fp.add(FetchProfile.Item.ENVELOPE);
    			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
    			fp.add(FetchProfile.Item.SIZE);
    			fp.add(FetchProfile.Item.FLAGS);
    			fp.add("Subject");
    			fp.add("From");
    			fp.add("To");
    			fp.add("Importance");
    			fp.add("X-Jmocha-Country-Code");
    			fp.add("X-Jmocha-IP");    			
    			
    			fetchFolder.fetch(messages, fp);
    		}
    		
    	} else {
    		if (folder == null) { // searching all folder
    			String useDefaultFoldersForLangOnly = ezCommonService.getTenantConfig("UseDefaultFoldersForLangOnly", tenantId);
				boolean isUseDefaultFoldersForLangOnly = useDefaultFoldersForLangOnly.equals("YES") ? true : false;
				
				List<Folder> topLevelFolders = ia.getTopLevelFolders(true, isUseDefaultFoldersForLangOnly);		
    			
    			List<String> topLevelFolderNames = new ArrayList<String>();
    			int maxFolderCount = Math.min(5, topLevelFolders.size());
    			
    			for (int i = 0; i < maxFolderCount; i++) {
    				Folder tmpFolder = topLevelFolders.get(i);
    				
    				topLevelFolderNames.add(tmpFolder.getName());
    			}
    			
    			logger.debug("topLevelFolderNames=" + topLevelFolderNames);	
    			
    			for (String folderName : topLevelFolderNames) {
    				Folder tmpFolder = ia.getFolder(folderName);
    				
    				if (folder == null) {
    					folder = tmpFolder;
    				}
    				
    				tmpFolder.open(Folder.READ_ONLY);
    				
    				Message[] subMessages = searchFolder(tmpFolder, searchField[0], searchValue[0], startDate, endDate, true, null, isUnreadOnly, isImportantOnly, isFromMobile);
    				
    				if (messages == null) {
    					messages = subMessages;
    				}
    				else if (subMessages.length > 0) {
    					int mainLen = messages.length;
    					int subLen = subMessages.length;
    					Message[] combined = new Message[mainLen + subLen];
    					System.arraycopy(messages, 0, combined, 0, mainLen);
    					System.arraycopy(subMessages, 0, combined, mainLen, subLen);	
    					
    					messages = combined;
    				}				
    				
    				FetchProfile fp = new FetchProfile();
    				
    				fp.add(UIDFolder.FetchProfileItem.UID);
    				fp.add("X-Priority");
    				fp.add(FetchProfile.Item.CONTENT_INFO);
    				fp.add(FetchProfile.Item.ENVELOPE);
    				fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
    				fp.add(FetchProfile.Item.SIZE);
    				fp.add(FetchProfile.Item.FLAGS);
    				
    				tmpFolder.fetch(messages, fp);		
    			}
    			
    		} else {
    			if (!searchField[0].equals("") || startDate != null || endDate != null || searchSubFolder || isUnreadOnly || isImportantOnly) {
    				messages = searchFolder(folder, searchField[0], searchValue[0], startDate, endDate, searchSubFolder, null, isUnreadOnly, isImportantOnly, isFromMobile);
    			} else {
    				logger.debug("get all message.");
    				messages = folder.getMessages();
    			}
    		}
    		
    		// sort the messages
    		if (sortType != null) {
    			sortMessages(folder, messages, sortType, isAscending);
    		// 2023-05-16 이사라 : NullPointerException 시큐어코딩
    		} else {
    			sortType = "";
    		}
    		
    		if (extraMap != null) {
    			extraMap.put("totalCount", messages.length);
    		}
    		
    		if (startIndex > messages.length || listCount < 0) {
    			messages = new Message[0];
    		} else {
    			// split messages
    			listCount = Math.min(messages.length - startIndex, listCount);
    			messages = Arrays.copyOfRange(messages, startIndex, startIndex + listCount);
    			
    			// pre-fetch
    			FetchProfile fp = new FetchProfile();
    			
    			if (sortType.equals("importance") || sortType.equals("receivedDate")) {
    				fp.add(UIDFolder.FetchProfileItem.UID);
    				fp.add("X-Priority");
    				fp.add(FetchProfile.Item.CONTENT_INFO);
    				fp.add(FetchProfile.Item.ENVELOPE);
    				fp.add(FetchProfile.Item.SIZE);
    				fp.add(FetchProfile.Item.FLAGS);								
    			}
    			else if (sortType.equals("readFlag") || sortType.equals("flag")) {
    				fp.add(UIDFolder.FetchProfileItem.UID);
    				fp.add("X-Priority");
    				fp.add(FetchProfile.Item.CONTENT_INFO);
    				fp.add(FetchProfile.Item.ENVELOPE);
    				fp.add(FetchProfile.Item.SIZE);								
    			}
    			else if (sortType.equals("attachment")) {
    				fp.add(UIDFolder.FetchProfileItem.UID);
    				fp.add("X-Priority");
    				fp.add(FetchProfile.Item.ENVELOPE);
    				fp.add(FetchProfile.Item.SIZE);
    				fp.add(FetchProfile.Item.FLAGS);								
    			}
    			else if (sortType.equals("sender") || sortType.equals("subject")) {
    				fp.add(UIDFolder.FetchProfileItem.UID);
    				fp.add("X-Priority");
    				fp.add(FetchProfile.Item.CONTENT_INFO);
    				fp.add(FetchProfile.Item.FLAGS);								
    			}
    			else if (sortType.equals("size")) {
    				fp.add(UIDFolder.FetchProfileItem.UID);
    				fp.add("X-Priority");
    				fp.add(FetchProfile.Item.CONTENT_INFO);
    				fp.add(FetchProfile.Item.ENVELOPE);
    				fp.add(FetchProfile.Item.FLAGS);								
    			}
    			
    			fp.add("Subject");
    			fp.add("From");
    			fp.add("To");
    			
    			folder.fetch(messages, fp);
    		}
    	}
    	
    	logger.debug("messagesLength=" + messages.length);
    	return messages;
    }
    
    public List<Map<String, String>> searchFolderUsingRDBOnly(String userAccount, String folderPath, String[] searchField, String[] searchValue, 
    		Date startDate, Date endDate, boolean searchSubFolder, boolean isUnreadOnly, boolean isImportantOnly, String sortType, boolean isAscending, 
    		int startIndex, int listCount, boolean isFromMobile, Map<String, Object> extraMap, int tenantId, boolean includeContent, String tagName) throws Exception {    	
    	logger.debug("searchFolderUsingRDBOnly started. userAccount=" + userAccount + ",folderPath=" + folderPath + ",searchField=" + searchField + ",searchValue=" + searchValue
    			+ ",startDate=" + startDate + ",endDate=" + endDate + ",searchSubFolder=" + searchSubFolder + ",isUnreadOnly=" + isUnreadOnly
    			+ ",isImportantOnly=" + isImportantOnly + ",sortType=" + sortType + ",isAscending=" + isAscending + ",startIndex=" + startIndex
    			+ ",listCount=" + listCount + ",isFromMobile=" + isFromMobile + ",extraMap=" + extraMap + ",tenantId=" + tenantId + ",includeContent=" + includeContent + ",tagName=" + tagName);
    	    	
		Map<String, Object> resultMap = getMailListUsingRDBOnlyFromJGw(userAccount, folderPath, searchField, searchValue, startDate, endDate, 
				isUnreadOnly, isImportantOnly, searchSubFolder, sortType, isAscending, startIndex, listCount, extraMap, includeContent, tagName);
		
		List<Map<String, String>> mailList = (List<Map<String, String>>)resultMap.get("mailList");
		
		if (extraMap != null) {
			extraMap.put("totalCount", (int)resultMap.get("totalCount"));
			extraMap.put("mailboxMailCount", (int)resultMap.get("mailboxMailCount"));
			extraMap.put("mailboxUnreadMailCount", (int)resultMap.get("mailboxUnreadMailCount"));
		}
    	
    	logger.debug("searchFolderUsingRDBOnly ended. mailList.size=" + mailList.size());
    	
    	return mailList;
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
	@SuppressWarnings("serial")
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
						} catch (MessagingException e) {
							logger.debug("e.message=" + e.getMessage());
				        } catch (Exception e) {
							logger.debug("e.message=" + e.getMessage());
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
							logger.debug("e.message=" + e.getMessage());			    		
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
						} catch (PatternSyntaxException e) {
							logger.debug("e.message=" + e.getMessage());
                        } catch (Exception e) {
							logger.debug("e.message=" + e.getMessage());
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
						} catch (MessagingException e) {
							logger.debug("e.message=" + e.getMessage());
				        } catch (Exception e) {
							logger.debug("e.message=" + e.getMessage());
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
				        	// String from = getFullFromAddressOfMessage(message);
				        	
				        	boolean subjectFlag = subject != null && subject.toLowerCase().contains(searchValue.toLowerCase()); 
				        	boolean toFlag = toSearch(message, searchValue);
				        	
				            if (subjectFlag || toFlag) {
				                return true;
				            }
						} catch (MessagingException e) {
							logger.debug("e.message=" + e.getMessage());
				        } catch (Exception e) {
							logger.debug("e.message=" + e.getMessage());
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
			
			// search the sub folders and combine the results.			
			if (searchSubFolder) {
				Folder[] subFolders = folder.list();
				
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
			ArrayList<Message> arrayList = new ArrayList<Message>();
			Message orgMsg[] = messages;
			
			Date from = endDate;
			int end = orgMsg.length;       
			long lFrom = from.getTime(); // endDate
			
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
		
		logger.debug("searchFolder ended.");
		return messages;
	}
	
	@SuppressWarnings("unchecked")
	public Message[] advancedSearchFolder(
			IMAPAccess ia,
			String userAccount,
			Folder folder,
			String folderPath, 
			String[] searchField, 
			final String[] searchValue,
			Date startDate,
			Date endDate,
			boolean searchSubFolder,
			boolean isUnreadOnly,
			boolean isImportantOnly,
			String sortType,
			boolean isAscending,
			int startIndex,
			int listCount,
			Map<String, Object> extraMap,
			String tagName
			) throws Exception {
		logger.debug("advancedSearchFolder started.");
		logger.debug("userAccount=" + userAccount + ",folderPath=" + folderPath + ",searchField=" + searchField + "searchValue=" + searchValue 
				+ ",startDate=" + startDate + ",endDate=" + endDate + ",searchSubFolder=" + searchSubFolder + ",isUnreadOnly=" + isUnreadOnly 
				+ ",isImportantOnly=" + isImportantOnly + ",sortType=" + sortType + ",isAscending=" + isAscending + ",startIndex=" + startIndex
				+ ",listCount=" + listCount + ",extraMap=" + extraMap + ",tagName=" + tagName);
		
		boolean useSecureMailFilter = extraMap != null && (boolean) extraMap.getOrDefault("useSecureMailFilter", false);

		Map<String, Object> resultMap = getMailListFromJGw(userAccount, folderPath, searchField, searchValue, startDate, endDate, 
				isUnreadOnly, isImportantOnly, searchSubFolder, sortType, isAscending, startIndex, listCount, extraMap, useSecureMailFilter, tagName);
		
		List<String> mailList = (List<String>) resultMap.get("mailList");
		
		if (extraMap != null) {
			extraMap.put("totalCount", (int)resultMap.get("totalCount"));
		}
		
		List<Message> messageList = new ArrayList<Message>();
		Map<String, Folder> folderMap = new HashMap<String, Folder>();
		String mailFolderPath = null;
		long mailUid = 0;
		Folder mailFolder = null;
		Message message = null;
		
		// 폴더 오픈 시 IMAP select 커맨드가 호출되는데 폴더 안에 메일이 많은 경우 오버헤드가 큰 관계로
		// 패러메터로 넘어온 이미 오픈된 folder를 folderMap에 미리 넣는다.
		folderMap.put(folderPath, folder);
		
		if (folder != null && !searchSubFolder && mailList.size() > 0) {
			logger.debug("single folder search. folderPath=" + folderPath);
			
			int mailListCount = mailList.size();
			long[] mailUids = new long[mailListCount];
			
			for (int i = 0; i < mailListCount; i++) {
				String mailUrl = mailList.get(i);
				mailUids[i] = Long.parseLong(mailUrl.split("/")[1]);
			}			
			
			Message[] messages = ((IMAPFolder)folder).getMessagesByUID(mailUids);
			
			logger.debug("advancedSearchFolder ended.");
			return messages;
		} else {
			for (String mailUrl : mailList) {
				mailFolderPath = mailUrl.split("/")[0];
				mailUid = Long.parseLong(mailUrl.split("/")[1]);
				
				if (folderMap.containsKey(mailFolderPath)) {
					mailFolder = folderMap.get(mailFolderPath);
					message = ((IMAPFolder)mailFolder).getMessageByUID(mailUid);
					
					if (message != null) {
						messageList.add(message);
					}
				} else {
					mailFolder = ia.getFolder(mailFolderPath);
					mailFolder.open(Folder.READ_ONLY);
					folderMap.put(mailFolderPath, mailFolder);
					message = ((IMAPFolder)mailFolder).getMessageByUID(mailUid);
					
					if (message != null) {
						messageList.add(message);
					}
				}
			}
		}
		
		logger.debug("advancedSearchFolder ended.");
		return messageList.toArray(new Message[0]);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getMailListFromJGw(
			String userAccount,
			String folderPath, 
			String searchField[], 
			String searchValue[], 
			Date startDate, 
			Date endDate, 
			boolean isUnreadOnly, 
			boolean isImportantOnly,
			boolean searchSubFolder,
			String sortType,
			boolean isAscending,
			int startIndex,
			int listCount,
			Map<String, Object> extraMap,
			boolean useSecureMailFilter,
			String tagName
			) throws Exception {
		logger.debug("getMailUidListFromJGw started.");
		logger.debug("userAccount=" + userAccount + ",folderPath=" + folderPath + ",searchField=" + searchField 
				+ ",searchValue=" + searchValue + ",startDate=" + startDate + ",endDate=" + endDate 
				+ ",isUnreadOnly=" + isUnreadOnly + ",isImportantOnly=" + isImportantOnly + ",searchSubFolder=" + searchSubFolder
				+ ",sortType=" + sortType + ",isAscending=" + isAscending + ",startIndex=" + startIndex + ",listCount=" + listCount
				+ ",extraMap=" + extraMap + ",tagName" + tagName);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		String userAccountParam = "userAccount=" + URLEncoder.encode(userAccount, "UTF-8");
		String folderPathParam = "folderPath=" + URLEncoder.encode(folderPath, "UTF-8");
		String startDateParam = "startDate=" + URLEncoder.encode(startDate == null ? "" : sdf.format(startDate), "UTF-8");
		String endDateParam = "endDate=" + URLEncoder.encode(endDate == null ? "" : sdf.format(endDate), "UTF-8");
		String isUnreadOnlyParam = "isUnreadOnly=" + isUnreadOnly;
		String isImportantOnlyParam = "isImportantOnly=" + isImportantOnly;
		
		String searchSubFolderParam = "searchSubFolder=" + searchSubFolder;
		String sortTypeParam = "sortType=" + URLEncoder.encode(sortType == null ? "" : sortType, "UTF-8");
		String isAscendingParam = "isAscending=" + isAscending;
		String startIndexParam = "startIndex=" + startIndex;
		String listCountParam = "listCount=" + listCount;
		
		String andorStatus = "andorStatus=";
		String attachStatus = "attachStatus=";
		
		String mailInnerDomainParam = "&inexternalFilter=&mailInnerDomainStr=";
		String isSecureMail = "&isSecureMail=" + useSecureMailFilter;
		String tagNameParam = "&tagName=" + URLEncoder.encode(tagName, "UTF-8");

		if(extraMap != null){
			logger.debug("extraMAP is not null.extraMap:" + extraMap);
			andorStatus += extraMap.get("andorStatus") == "" ? "and" : extraMap.get("andorStatus");
			attachStatus += extraMap.get("attachStatus") == "" ? "all" :  extraMap.get("attachStatus");

			//2020-07-16 김은실 - (사조그룹)내부·외부필터 상태값 및 내부기준 도메인
			if (extraMap.get("inexternalFilter") != null && extraMap.get("mailInnerDomainStr") != null) {
				mailInnerDomainParam = "&inexternalFilter=" + URLEncoder.encode((String)extraMap.get("inexternalFilter"), "UTF-8");
				mailInnerDomainParam += "&mailInnerDomainStr=" + URLEncoder.encode((String)extraMap.get("mailInnerDomainStr"), "UTF-8");
			}
		}
		
		String searchFieldParam = "";
		String searchValueParam = "";
		if (searchField != null && searchField.length > 0 ) {
			for ( int i= 0 ; i < searchField.length ; i++ ) {
				searchFieldParam += "&searchField=" + URLEncoder.encode(searchField[i], "UTF-8");
			}
		} else {
			searchFieldParam += "&searchField=" + URLEncoder.encode("", "UTF-8");
		}
		
		if (searchValue != null && searchValue.length > 0) {
			for ( int i= 0 ; i < searchValue.length ; i++ ) {
				searchValueParam += "&searchValue=" + URLEncoder.encode(searchValue[i], "UTF-8");
			}
		} else {
			searchValueParam = "&searchValue=" + URLEncoder.encode("", "UTF-8");
		}
		
		String inputParams = userAccountParam + "&" + folderPathParam + searchFieldParam // searchFieldParam , searchValueParam 여러개 보낸다는 가정에 위에서 처리
				+ searchValueParam + "&" + startDateParam + "&" + endDateParam 
				+ "&" + isUnreadOnlyParam + "&" + isImportantOnlyParam + "&" + searchSubFolderParam
				+ "&" + sortTypeParam + "&" + isAscendingParam + "&" + startIndexParam + "&" + listCountParam
				+ "&" + attachStatus + "&" + andorStatus + mailInnerDomainParam + isSecureMail + tagNameParam;
		
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/searchMail";
		String response = getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				List<String> mailList = (List<String>)responseObj.get("mailList");
				int totalCount = (int)(long)responseObj.get("totalCount");
				
				resultMap.put("mailList", mailList);
				resultMap.put("totalCount", totalCount);
				
//				for (int i = 0; i < result.size(); i++) {
//					mailList.add((String)result.get(i));
//				}
			} else {
				throw new Exception("JGwServer ERROR");
			}
		}
		
		logger.debug("getMailUidListFromJGw ended.");
		return resultMap;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getMailListUsingRDBOnlyFromJGw(
			String userAccount,
			String folderPath, 
			String searchField[], 
			String searchValue[], 
			Date startDate, 
			Date endDate, 
			boolean isUnreadOnly, 
			boolean isImportantOnly,
			boolean searchSubFolder,
			String sortType,
			boolean isAscending,
			int startIndex,
			int listCount,
			Map<String, Object> extraMap,
			boolean includeContent,
			String tagName
			) throws Exception {
		logger.debug("getMailListUsingRDBOnlyFromJGw started.");
		logger.debug("userAccount=" + userAccount + ",folderPath=" + folderPath + ",searchField=" + searchField 
				+ ",searchValue=" + searchValue + ",startDate=" + startDate + ",endDate=" + endDate 
				+ ",isUnreadOnly=" + isUnreadOnly + ",isImportantOnly=" + isImportantOnly + ",searchSubFolder=" + searchSubFolder
				+ ",sortType=" + sortType + ",isAscending=" + isAscending + ",startIndex=" + startIndex + ",listCount=" + listCount
				+ ",extraMap=" + extraMap + ",includeContent=" + includeContent
				+ ",tagName=" + tagName);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		String userAccountParam = "userAccount=" + URLEncoder.encode(userAccount, "UTF-8");
		//String folderPathParam = "folderPath=" + URLEncoder.encode(folderPath, "UTF-8");
		String startDateParam = "startDate=" + URLEncoder.encode(startDate == null ? "" : sdf.format(startDate), "UTF-8");
		String endDateParam = "endDate=" + URLEncoder.encode(endDate == null ? "" : sdf.format(endDate), "UTF-8");
		String isUnreadOnlyParam = "isUnreadOnly=" + isUnreadOnly;
		String isImportantOnlyParam = "isImportantOnly=" + isImportantOnly;
		
		String searchSubFolderParam = "searchSubFolder=" + searchSubFolder;
		String sortTypeParam = "sortType=" + URLEncoder.encode(sortType == null ? "" : sortType, "UTF-8");
		String isAscendingParam = "isAscending=" + isAscending;
		String startIndexParam = "startIndex=" + startIndex;
		String listCountParam = "listCount=" + listCount;
		
		String andorStatus = "andorStatus=";
		String attachStatus = "attachStatus=";

		String mailInnerDomainParam = "&inexternalFilter=&mailInnerDomainStr=";
		String isSecureMail = "&isSecureMail=";
		String tagNameParam = "&tagName=" + URLEncoder.encode(tagName, "utf-8");
		String isAttachMail = "&isAttachMail=";

		if(extraMap != null){
			logger.debug("extraMAP is not null.extraMap:" + extraMap);
			andorStatus += extraMap.get("andorStatus") == "" ? "and" : extraMap.get("andorStatus");
			attachStatus += extraMap.get("attachStatus") == "" ? "all" :  extraMap.get("attachStatus");
			isSecureMail += extraMap.get("useSecureMailFilter");
			isAttachMail += extraMap.get("useAttachFileFilter");

			//2020-07-16 김은실 - (사조그룹)내부·외부필터 상태값 및 내부기준 도메인
			if (extraMap.get("inexternalFilter") != null && extraMap.get("mailInnerDomainStr") != null) {
				mailInnerDomainParam = "&inexternalFilter=" + URLEncoder.encode((String)extraMap.get("inexternalFilter"), "UTF-8");
				mailInnerDomainParam += "&mailInnerDomainStr=" + URLEncoder.encode((String)extraMap.get("mailInnerDomainStr"), "UTF-8");
			}
		}
		
		String includeContentParam = "includeContent=" + includeContent;

		String folderPathParam = "";
		// 전체메일에서 받은편지함과 개인편지함으로 국한되어 하드코딩할 수 있으나, 확장성을 위해 ////로 split하여 처리
		// 기존의 단일 folderPath 검색 시에는 folderPath를 그대로 이용하고
		// 여러 편지함을 검색하는 경우에는 folderPaths로 s를 붙여서 넘기며, jgw서버에서 String배열로 받는다.
		if (folderPath.contains("////")) {
			String[] folderPaths = folderPath.split("////");
			for ( int i= 0 ; i < folderPaths.length ; i++ ) {
				folderPathParam += "&folderPaths=" + URLEncoder.encode(folderPaths[i], "UTF-8");
			}
		} else {
			folderPathParam = "folderPath=" + URLEncoder.encode(folderPath, "UTF-8");
		}
		
		String searchFieldParam = "";
		String searchValueParam = "";
		if (searchField != null && searchField.length > 0 ) {
			for ( int i= 0 ; i < searchField.length ; i++ ) {
				searchFieldParam += "&searchField=" + URLEncoder.encode(searchField[i], "UTF-8");
			}
		} else {
			searchFieldParam += "&searchField=" + URLEncoder.encode("", "UTF-8");
		}
		
		if (searchValue != null && searchValue.length > 0) {
			for ( int i= 0 ; i < searchValue.length ; i++ ) {
				searchValueParam += "&searchValue=" + URLEncoder.encode(searchValue[i], "UTF-8");
			}
		} else {
			searchValueParam = "&searchValue=" + URLEncoder.encode("", "UTF-8");
		}
		
		String inputParams = userAccountParam + "&" + folderPathParam + searchFieldParam // searchFieldParam , searchValueParam 여러개 보낸다는 가정에 위에서 처리
				+ searchValueParam + "&" + startDateParam + "&" + endDateParam 
				+ "&" + isUnreadOnlyParam + "&" + isImportantOnlyParam + "&" + searchSubFolderParam
				+ "&" + sortTypeParam + "&" + isAscendingParam + "&" + startIndexParam + "&" + listCountParam
				+ "&" + attachStatus + "&" + andorStatus + "&" + includeContentParam + mailInnerDomainParam + isSecureMail + tagNameParam + isAttachMail;
		
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/searchMailUsingRDBOnly";
		String response = getWebServiceResult(requestURL, inputParams);
//		logger.debug("response=" + response);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				List<Map<String, String>> mailList = (List<Map<String, String>>)responseObj.get("mailList");
				int totalCount = (int)(long)responseObj.get("totalCount");
				int mailboxMailCount = (int)(long)responseObj.get("mailboxMailCount");
				int mailboxUnreadMailCount = (int)(long)responseObj.get("mailboxUnreadMailCount");
				
				resultMap.put("mailList", mailList);
				resultMap.put("totalCount", totalCount);
				resultMap.put("mailboxMailCount", mailboxMailCount);
				resultMap.put("mailboxUnreadMailCount", mailboxUnreadMailCount);
			} else {
				throw new Exception("JGwServer ERROR");
			}
		}
		
		logger.debug("getMailListUsingRDBOnlyFromJGw ended.");
		return resultMap;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, String> getMailInfo(
			String userAccount,
			String folderPath,
			long mailUid
			) throws Exception {
		logger.debug("getMailInfo started.");
		logger.debug("userAccount=" + userAccount + ",folderPath=" + folderPath + ",mailUid=" + mailUid);
				
		String userAccountParam = "userAccount=" + URLEncoder.encode(userAccount, "UTF-8");
		String folderPathParam = "folderPath=" + URLEncoder.encode(folderPath, "UTF-8");
		String mailUidParam = "mailUid=" + mailUid;
						
		String inputParams = userAccountParam + "&" + folderPathParam + "&" + mailUidParam;
		
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMailInfo";
		String response = getWebServiceResult(requestURL, inputParams);
		
		Map<String, String> resultMap = null;
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				resultMap = (Map<String, String>)responseObj.get("mailInfo");
				
			} else {
				throw new Exception("JGwServer ERROR");
			}
		}
		
		logger.debug("getMailInfo ended.");
		
		return resultMap;
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
						p.isMimeType("message/rfc822")
					// 2021-08-12 김은실 - EzEmailUtil.getBodyInfo()_(1909)조건 추가함. : 료비에서 온 메일 중에 related 파트안에 인라인으로 첨부파일이 있는 메일이 있음. (-이하 생략-)
					// line:(1766, 1846, 1871, 1950) 조건이 더 있긴하지만, 사례eml이 없어 섣불리 추가하기 어려움. 추후에 발견되는 대로 테스트 후 추가하는 것이 좋지 않을까하여 둠.
					|| ((p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.INLINE) || ((MimePart)p).getContentID() != null)
					&& !(p.isMimeType("application/*") && ((MimePart)p).getContentID() == null))) {
					mp.removeBodyPart(index[i]);
				}
			}
			if (mp.getCount() == 0) {
				return null;
			}
			newMessage.setContent(mp);
			
			//set header
			@SuppressWarnings("unchecked")
			Enumeration<Header> e = oldMessage.getAllHeaders();
			while(e.hasMoreElements()){
				Header header = e.nextElement();
				newMessage.setHeader(header.getName(), header.getValue());
			}
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		return newMessage;
	}
	
	public boolean hasHtmlPart(Part part) throws Exception {
		if (part != null) {
			if (part.isMimeType("multipart/*")) {
	            Multipart mp = (Multipart)part.getContent();
	            int count = mp.getCount();
	            
	            for (int i = 0; i < count; i++) {
	                if (hasHtmlPart(mp.getBodyPart(i))) {
	                	return true;
	                }
	            }
			} else if (part.isMimeType("text/html")) {
				return true;
			}
		}
		
		return false;
	}
	
	public BodyPart getConvertedBodyPartFromInlineToAttachment(BodyPart p) throws MessagingException, IOException {
		logger.debug("getConvertedBodyPartFromInlineToAttachment started");
		
		MimeBodyPart newBodyPart = (MimeBodyPart)p;
			
		if (p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.INLINE)
				|| ((MimePart)p).getContentID() != null) {		
			InternetHeaders newHeaders = new InternetHeaders();
			
			@SuppressWarnings("unchecked")
			Enumeration<Header> enumerator = p.getAllHeaders();
			
			// 해당 파트의 헤더들을 읽는다.
			while (enumerator.hasMoreElements()) {
				Header h = (Header)enumerator.nextElement();
				
				String hValue = h.getValue();
				
				if (h.getName().equalsIgnoreCase("Content-Disposition")) {
					hValue = hValue.replace("inline;", "attachment;");
				} else if (h.getName().equalsIgnoreCase("Content-ID")) {
					continue;
				}
				
				newHeaders.addHeader(h.getName(), hValue);
			}
			
			// 해당 파트의 body 데이터를 읽는다.
			byte[] bytes = IOUtils.toByteArray(newBodyPart.getRawInputStream());
				    										
			// 해당 파트의 헤더와 body 데이터를 동일하게 갖는 파트 객체를 생성한다.
			newBodyPart = new MimeBodyPart(newHeaders, bytes);	 
		}
		
		logger.debug("getConvertedBodyPartFromInlineToAttachment ended");
		
		return newBodyPart;
	}

	public BodyPart getConvertedBodyPartWithWrongNameParameter(BodyPart p) throws MessagingException, IOException {
		MimeBodyPart newBodyPart = (MimeBodyPart)p;

		String[] contentTypeHeaders = p.getHeader("Content-Type");

		if (contentTypeHeaders != null && contentTypeHeaders.length > 0) {
			String contentType = contentTypeHeaders[0];

			// 다음 예에서와 같이 name 속성 앞에 ; 구분자가 없는 메일을 전달할 경우 JavaMail Parsing 오류가 발생해
			// 전달을 위해 Part 복사 시 ;을 추가하도록 함
			// Content-type: text/html
			//	 name="=?EUC-KR?B?a3RzYXRfYmlsbC5wZGY=?="
			if (contentType.contains("name") && !contentType.contains(";")) {
				logger.debug("name parameter without semicolon. Content-Type={}", contentType);

				InternetHeaders newHeaders = new InternetHeaders();

				@SuppressWarnings("unchecked")
				Enumeration<Header> enumerator = p.getAllHeaders();

				// 해당 파트의 헤더들을 읽는다.
				while (enumerator.hasMoreElements()) {
					Header h = enumerator.nextElement();
					String hValue = h.getValue();

					if (h.getName().equalsIgnoreCase("Content-Type")) {
						hValue = hValue.replaceFirst(" ", ";");

						logger.debug("new Content-Type={}", hValue);
					}

					newHeaders.addHeader(h.getName(), hValue);
				}

				// 해당 파트의 body 데이터를 읽는다.
				byte[] bytes = IOUtils.toByteArray(newBodyPart.getRawInputStream());

				// 해당 파트의 헤더와 body 데이터를 동일하게 갖는 파트 객체를 생성한다.
				newBodyPart = new MimeBodyPart(newHeaders, bytes);
			// Content-Type: "application/octet-stream;	Name="=?utf-8?B?7J287J287LKg6rCV7Iuc7ZmpIDIwMjQwNjI2LnBkZg==?="
			// Content-Type이 위와 같이 이중따옴표로 시작하여 Name=" 까지인 application/octet-stream;	Name=이 Content-Type으로 인식되어 오류가
			// 발생하는 경우가 있어 첫 이중따옴표를 제거하는 로직 추가함
			} else if (contentType.startsWith("\"")) {
				logger.debug("Content-Type starts with double quotes. Content-Type={}", contentType);

				int secondQuote = contentType.indexOf('"', 1);

				if (secondQuote != -1) {
					String value = contentType.substring(1, secondQuote);

					logger.debug("Content-Type starts with double quotes. value={}", value);

					if (value.toLowerCase().endsWith("name=")) {
						InternetHeaders newHeaders = new InternetHeaders();

						@SuppressWarnings("unchecked")
						Enumeration<Header> enumerator = p.getAllHeaders();

						// 해당 파트의 헤더들을 읽는다.
						while (enumerator.hasMoreElements()) {
							Header h = enumerator.nextElement();
							String hValue = h.getValue();

							if (h.getName().equalsIgnoreCase("Content-Type")) {
								// 시작 부분의 이중따옴표를 제거함
								hValue = hValue.substring(1);

								logger.debug("new Content-Type={}", hValue);
							}

							newHeaders.addHeader(h.getName(), hValue);
						}

						// 해당 파트의 body 데이터를 읽는다.
						byte[] bytes = IOUtils.toByteArray(newBodyPart.getRawInputStream());

						// 해당 파트의 헤더와 body 데이터를 동일하게 갖는 파트 객체를 생성한다.
						newBodyPart = new MimeBodyPart(newHeaders, bytes);
					}
				}
			// Content-Type: pdf; name="=?UTF-8?B?7Jew6rWs6rCc67Cc6rO87KCcIOuzgOqyvSDsmpTssq3shJwyLnBkZg==?="
			// Content-Disposition: attachment;
			// filename="=?UTF-8?B?7Jew6rWs6rCc67Cc6rO87KCcIOuzgOqyvSDsmpTssq3shJwyLnBkZg==?="
			// Content-Transfer-Encoding: base64
			// Content-ID: <f_m8cfbdqm0>
			// 위 예와 같이 Content-Type이 mainType이 없이 subType만 있는 경우가 있어 추가함
			} else if (!contentType.contains("/")) {
				logger.debug("Content-Type has no slash. Content-Type={}", contentType);

				InternetHeaders newHeaders = new InternetHeaders();

				@SuppressWarnings("unchecked")
				Enumeration<Header> enumerator = p.getAllHeaders();

				// 해당 파트의 헤더들을 읽는다.
				while (enumerator.hasMoreElements()) {
					Header h = enumerator.nextElement();
					String hValue = h.getValue();

					if (h.getName().equalsIgnoreCase("Content-Type")) {
						// mainType은 application으로 가정함
						hValue = "application/" + hValue;

						logger.debug("new Content-Type={}", hValue);
					}

					newHeaders.addHeader(h.getName(), hValue);
				}

				// 해당 파트의 body 데이터를 읽는다.
				byte[] bytes = IOUtils.toByteArray(newBodyPart.getRawInputStream());

				// 해당 파트의 헤더와 body 데이터를 동일하게 갖는 파트 객체를 생성한다.
				newBodyPart = new MimeBodyPart(newHeaders, bytes);				
			}
		}

		return newBodyPart;
	}

	public boolean copyInlineParts(Part src, Multipart dest, boolean includeAttachment) throws MessagingException, IOException {
		return this.copyInlineParts(src, dest, includeAttachment, false);
	}
	
	public boolean copyInlineParts(Part src, Multipart dest, boolean includeAttachment, 
						boolean convertInlineImageToAttachment) throws MessagingException, IOException {
		if (src.isMimeType("multipart/related")) {
			Multipart mp = (Multipart)src.getContent();
			int count = mp.getCount();
			boolean isAdded = false;
			
			for (int i = 0; i < count; i++) {
				BodyPart p = mp.getBodyPart(i);
				
				// related 파트안에 mixed 파트가 있고 mixed 파트 안에 첨부파일이 있는 경우 전달 시
				// 첨부파일을 추가하기 위해 기존 multipart/related에서 multipart/*로 변경함
				// related 파트안에 mixed 파트가 있고 첨부파일이 있는 메일.eml 참고
				if (p.isMimeType("multipart/*")) {
					if (copyInlineParts(p, dest, includeAttachment, convertInlineImageToAttachment)) {
						return true;
					}					
				} else if (p instanceof MimePart) {
					// text/html 파트가 없으면 인라인 이미지 파트를 첨부파일 파트로 변환한다.(이미지를 첨부로 대신 표시하기 위해)
					if (convertInlineImageToAttachment) {
						if (p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.INLINE)) {
							p = getConvertedBodyPartFromInlineToAttachment(p);
						}
					}
					
					// 코린도에서 수신한 메일 중 multipart/related 안에 첨부 파일이 있는 경우가 있어
					// Content-Disposition: attachment 헤더가 있는 경우도 추가함.
					// includeAttachment는 메일 전달 시에만 적용되도록 하기 위한 용도임(메일 회신 시에는 첨부 파일을 포함하면 안되므로).
					// 료비에서 온 메일 중에 related 파트안에 인라인으로 첨부파일이 있는 메일이 있어 이 경우
					// Forward시 첨부되도록 하기 위해 || p.isMimeType("application/*") 조건을 추가함.
					if (((MimePart)p).getContentID() != null
							// attachment로 첨부 파일이면서 Content-ID가 있는 경우 회신 시 포함되는 문제가 발생해 제외 조건 추가함
							// 혹시라도 인라인 이미지인데 attachment인 경우엔 인라인 이미지로 포함되지 않을 수 있음
							&& !Part.ATTACHMENT.equalsIgnoreCase(p.getDisposition())
							&& !p.isMimeType("text/plain")
							&& !p.isMimeType("application/*")
							|| (includeAttachment 
									&& (Part.ATTACHMENT.equalsIgnoreCase(p.getDisposition()) 
											|| p.isMimeType("application/*")))) {
						dest.addBodyPart(p);	
						isAdded = true;
					}
				}				
			}
			
			return isAdded;
		} else if (src.isMimeType("multipart/*")) {
			Multipart mp = (Multipart)src.getContent();
			int count = mp.getCount();
			boolean isAdded = false;
			
			for (int i = 0; i < count; i++) {
				BodyPart p = mp.getBodyPart(i);
				
				if (copyInlineParts(p, dest, includeAttachment, convertInlineImageToAttachment)) {
					return true;
				}

				// dhlee : 20221125 - multipart/mixed 안에 인라인 이미지 파트가 있는 메일이 있어 추가함.
				if (((MimePart)p).getContentID() != null
						&& !Part.ATTACHMENT.equalsIgnoreCase(p.getDisposition())
						&& !p.isMimeType("text/plain")
						&& !p.isMimeType("application/*")) {
					isAdded = true;
				}
			}

			return isAdded;
		// related 파트안에 mixed 파트가 있고 mixed 파트 안에 첨부파일이 있는 경우 전달 시
		// 첨부파일을 추가하기 위해 다음 코드를 추가함
		// related 파트안에 mixed 파트가 있고 첨부파일이 있는 메일.eml 참고
		} else if (src instanceof BodyPart) {
			if (((MimePart)src).getContentID() != null // dhlee : 20221125 - multipart/mixed 안에 인라인 이미지 파트가 있는 메일이 있어 추가함.
					// attachment로 첨부 파일이면서 Content-ID가 있는 경우 회신 시 포함되는 문제가 발생해 제외 조건 추가함
					// 혹시라도 인라인 이미지인데 attachment인 경우엔 인라인 이미지로 포함되지 않을 수 있음
					&& !Part.ATTACHMENT.equalsIgnoreCase(src.getDisposition())
					// Content-Type: pdf; name="=?UTF-8?B?7Jew6rWs6rCc67Cc6rO87KCcIOuzgOqyvSDsmpTssq3shJwyLnBkZg==?="
					// Content-Disposition: attachment;
					// filename="=?UTF-8?B?7Jew6rWs6rCc67Cc6rO87KCcIOuzgOqyvSDsmpTssq3shJwyLnBkZg==?="
					// Content-Transfer-Encoding: base64
					// Content-ID: <f_m8cfbdqm0>
					// 위 예와 같이 Content-Type이 비정상적인 경우 text/plain으로 인식되어 Content-ID가 있더라도
					// 비정상적인 타입일 경우엔 제외하기 위해 조건을 추가함
					&& !src.isMimeType("text/plain")
					// Content-Type: application/vnd.openxmlformats-officedocument.wordprocessingml.document;  name="2025-03-24-TSB157-SG17-ISED-Response to Circ 003-CAN.docx"
					// Content-Transfer-Encoding: base64
					// Content-Description: 2025-03-24-TSB157-SG17-ISED-Response to Circ 003-CAN.docx
					// Content-Disposition: attachment;    filename="2025-03-24-TSB157-SG17-ISED-Response to Circ 003-CAN.docx";   size=45845; creation-date="Tue, 25 Mar 2025 14:09:59 GMT";  modification-date="Tue, 25 Mar 2025 14:09:59 GMT"
					// Content-ID: <E95C17A570064B4D9A1872F7F507C9D0@sct-15-20-7719-20-msonline-outlook-0b924.templateTenant>
					// 위 예와 같이 Content-ID가 있으면서 첨부 파일인 경우가 있어 application/* 타입인 경우는 제외하는 조건을 추가함
					// 제외 조건을 Content-Disposition: attachment로 하지 않는 이유는 Inline Image이지만 attachment로 잘못 되어 있는 경우도 있는 것으로 보이기 때문
					&& !src.isMimeType("application/*")
					|| (includeAttachment
							&& (Part.ATTACHMENT.equalsIgnoreCase(src.getDisposition())
									|| src.isMimeType("application/*")))) {
				dest.addBodyPart((BodyPart)src);	
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
		return copyAllPartsInMultipart(src, dest, false);
	}
	
	public boolean copyAllPartsInMultipart(Part src, Multipart dest, boolean convertInlineImageToAttachment) throws MessagingException, IOException {
		if (src.isMimeType("multipart/*")) {
			Multipart mp = (Multipart)src.getContent();
			int count = mp.getCount();
			
			for (int i = 0; i < count; i++) {
				BodyPart p = mp.getBodyPart(i);
				
				// 코린도에서 수신된 메일 중 multipart/mixed 파트 안에 multipart/mixed 파트가
				// 또 들어 있는 경우가 있어 추가함.
				if (p.isMimeType("multipart/mixed")) {
					copyAllPartsInMultipart(p, dest, convertInlineImageToAttachment);
				// text/html 파트가 없는 경우엔 multipart/related 파트 안에 있는 인라인 이미지 파트를
				// 첨부파일 파트로 변환하여 복사하기 위해 재귀적 호출을 하고 마지막 else 절에서 해당 변환을 처리한다.
				} else if (convertInlineImageToAttachment && p.isMimeType("multipart/related")) {
					copyAllPartsInMultipart(p, dest, convertInlineImageToAttachment);
				} else {
					if (p instanceof MimePart) {
						// text/html 파트가 없으면 인라인 이미지 파트를 첨부파일 파트로 변환한다.(이미지를 첨부로 대신 표시하기 위해)
						if (convertInlineImageToAttachment) {
							if (p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.INLINE)
									|| ((MimePart)p).getContentID() != null) {
								p = getConvertedBodyPartFromInlineToAttachment(p); 

								if (p.getHeader("Content-Disposition") == null) {
									p.setHeader("Content-Disposition", "attachment");
								}
							}
						}

						p = getConvertedBodyPartWithWrongNameParameter(p);
					}
					
					dest.addBodyPart(p);
				}
			}
			
			return true;
		} 
		
		return false;
	}
	
	/**
	 * 메일 첨부파일 Part 반환 함수
	 */
	public Part getAttachPart(Part part, int index) throws MessagingException, IOException {
		logger.debug("getAttachPart started. index=" + index);
		
		// multipart/related 안에 첨부파일이 들어 있는 메일이 코린도에서 수신되어
		// multipart/related를 추가함
		if (part.isMimeType("multipart/mixed") 
				|| part.isMimeType("multipart/report")
				|| part.isMimeType("multipart/related")) {
			Multipart mp = (Multipart)part.getContent();
			Part p = null;
			String fileName = null;
			
			try {
				p = mp.getBodyPart(index);
				
				fileName = p.getFileName();
				
				logger.debug("fileName=" + fileName);
			// mixed 파트 내 related 파트에 첨부파일이 있는 경우 다운로드 시 ArrayIndexOutOfBoundsException이 발생함.
			// 이 경우 아래 else 문에서 재귀적 호출에 의해 처리되도록 함.
			// docs/eml/mixed 파트내 related 파트에 첨부파일이 있는 메일.eml 참조
			} catch (ArrayIndexOutOfBoundsException e) {
				logger.error(e.getMessage(), e);
			}
			
			if (fileName != null
					|| (p != null && p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT))) {
				logger.debug("getAttachPart ended.");
				
				return p;
			// 코린도에서 수신된 메일 중 multipart/mixed 파트 안에 multipart/alternative와 multipart/mixed 파트가
			// 또 들어 있는 경우가 있어 선택된 파트가 첨부 파일 파트가 아닌 경우엔(filename이 있는 지 혹은 Content-Disposition: attachment 가 있는 지 여부로 구분)
			// 또 다른 multipart를 찾도록 한다.
			} else {
	            int count = mp.getCount();
	            
	            for (int i = 0; i < count; i++) {
	            	if (i != index) {
		                p = getAttachPart(mp.getBodyPart(i), index);
		                
		                if (p != null) {
		                    return p;
		                }
	            	}
	            }				
			}
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
	
	public Part getAttachPart(Part part, int index, int order, int depth) throws MessagingException, IOException {
		return getAttachPart(part, index, order, depth, 0, 0);
	}
	
	/**
	 * 메일 첨부파일 Part 반환 함수
	 */
	public Part getAttachPart(Part part, int index, int order, int depth, int currentOrder, int currentDepth) throws MessagingException, IOException {
		logger.debug("getAttachPart started. index=" + index + ",order=" + order + ",depth=" + depth + ",currentOrder=" + currentOrder + ",currentDepth=" + currentDepth);

		// 만약의 경우 계속해서 재귀적 호출이 되는 것을 방지하기 위해 currentDepth <= 10 조건을 추가함.
		if (part.isMimeType("multipart/*") && currentDepth <= 10) {
			Multipart mp = (Multipart)part.getContent();
			
			if (order == currentOrder && depth == currentDepth) {				
				Part p = mp.getBodyPart(index);
				String fileName = p.getFileName();
								
				logger.debug("fileName=" + fileName);
				logger.debug("getAttachPart ended.");
					
				return p;				
			} else {
	            int count = mp.getCount();
	            
	            for (int i = 0; i < count; i++) {
	                Part p = getAttachPart(mp.getBodyPart(i), index, order, depth, i, currentDepth + 1);
	                
	                if (p != null) {
	                	logger.debug("getAttachPart ended.");
	                	
	                    return p;
	                }
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
		
		if (part.isMimeType("multipart/related")){
			Multipart mp = (Multipart)part.getContent();
			int count = mp.getCount();
			
			for (int i = 0; i < count; i++) {
				Part p = mp.getBodyPart(i);
				
				if (p instanceof MimePart) {
					if (p.isMimeType("multipart/related")) {
						p = getInlinePart(p, contentId);
						
						if (p != null) {
							logger.debug("getInlinePart ended.");
							
							return p;
						}						
					} else if (((MimePart)p).getContentID() != null && ((MimePart)p).getContentID().equals(contentId)) {
						logger.debug("getInlinePart ended.");
						
						return p;
					}
				}
			}
		} else if (part.isMimeType("multipart/*")) {
			Multipart mp = (Multipart)part.getContent();
			int count = mp.getCount();
			Part p = null;
			
			for (int i = 0; i < count; i++) {
				p = getInlinePart(mp.getBodyPart(i), contentId);
				
				if (p != null) {
					logger.debug("getInlinePart ended.");
					
					return p;
				}
			}
		} else {
			if (part instanceof MimePart) {
				if (((MimePart)part).getContentID() != null && ((MimePart)part).getContentID().equals(contentId)) {
					logger.debug("getInlinePart ended.");
					
					return part;
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
				try (OutputStream os = conn.getOutputStream()) {
					// UTF-8로 인코딩한다.
					os.write(inputParams.getBytes("UTF-8"));
					os.flush();
				}
			}
			
			if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
				// Response Body를 UTF-8로서 디코딩한다.			
				try (BufferedReader br = new BufferedReader(
											new InputStreamReader(conn.getInputStream(),"UTF-8")
											)) {

					StringBuilder sb = new StringBuilder();
					String output;

					while ((output = br.readLine()) != null) {
						sb.append(output);
					}

					result = sb.toString();
				}
				
				conn.disconnect();		
				conn = null;
			} else {
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
	
	public boolean isEachMail(Message message) throws MessagingException {
		boolean isEach = false;

		if (message.getHeader("X-JMocha-Each-Mail") != null) {
            String value = message.getHeader("X-JMocha-Each-Mail")[0];
			if ("true".equalsIgnoreCase(value)) {
				isEach = true;
			}
		}

		return isEach;
	}

	public void setSecureMailFlag(Message message, boolean isSet) throws MessagingException {
		Flags secureMailFlag = new Flags("$SecureMail");
		
		message.setFlags(secureMailFlag, isSet);
	}
	
	public void setSentDateFlag(Message message, boolean isSet) throws MessagingException {
		logger.debug("setSentDateFlag");
		
		String[] flags = message.getFlags().getUserFlags();
		
		for (String flag : flags) {
			if (flag.indexOf("$SentDate-") != -1) {
				Flags test = new Flags(flag);
				
				message.setFlags(test, false);
			}
		}
		
		String nowMillisTime = Long.toString(System.currentTimeMillis());
		Flags sentDateFlag = new Flags("$SentDate-" + nowMillisTime);
		
		logger.debug("nowMillisTime : " + nowMillisTime);
		
		message.setFlags(sentDateFlag, isSet);
	}
	
	public boolean hasSentDateFlag(Message message) throws MessagingException {
		logger.debug("hasSentDateFlag");
		
		boolean isSentDate = false;
		String[] flags = message.getFlags().getUserFlags();		
		
		for (String flag : flags) {
			if (flag.indexOf("$SentDate-") != -1) {
				isSentDate = true;
				break;
			}
		}

		logger.debug(Boolean.toString(isSentDate));
		return isSentDate;
	}
	
	public String getSentDateFlag(Message message) throws MessagingException {
		logger.debug("getSentDateFlag");
		
		String[] flags = message.getFlags().getUserFlags();
		String sentDate = "";
		
		for (String flag : flags) {
			if (flag.indexOf("$SentDate-") != -1) {
				sentDate = flag;
				break;
			}
		}

		return sentDate;
	}

	public void setTagFlag(Message message, String userAccount, String tagName, boolean isSet) throws Exception {
		logger.debug("setTagFlag");

		try {
			JgwResult result = rest.jgw().url("/jMochaEzEmail/getTagIdx")
					.formParam("userAccount", userAccount)
					.formParam("tagName", tagName)
					.formParam("isAutoGenerate", isSet)
					.exchangeJgwResult();
			logger.debug("jgw getTagIdx result: {}", result);

			if (result.failed()) {
				throw new RuntimeException("jgw getTagIdx failed.");
			}

			// resultCode가 1일 경우엔 삭제할 때 존재하지 않는 태그를 조회한 경우이므로 아무런 처리를 하지 않음
			if (result.getReasonCode() == 0) {
				int tagIdx = result.getResult(Integer.class);
				Flags setTagFlag = new Flags("$Tag-" + tagIdx);
				message.setFlags(setTagFlag, isSet);
			}
		} catch (MessagingException e) {
			throw e;
		} catch (Exception e) {
			throw e;
		}
	}

	public List<String> getInnerDomain(int tenantId) throws Exception {
		List<String> innerDomainList = new ArrayList<String>();
		
		String mailInnerDomain = ezCommonService.getTenantConfig("MailInnerDomain", tenantId);
		String[] innerDomainArr = mailInnerDomain.split(";");
		
		for (int i = 0; i < innerDomainArr.length; i++) {
			if (innerDomainArr[i] != null && !innerDomainArr[i].trim().equals("")) {
				innerDomainList.add(innerDomainArr[i]);
			}
		}
		
		return innerDomainList;
	}
	
	/**
	 * 개인의 Alias 이메일 주소가 지정될 경우 실제 이메일 주소가 반환된다.
	 * @param emailAddress
	 * @return
	 */
	public String getRealEmailAddress(String emailAddress) throws Exception {
        String result = "";
        
        String addressParam = "address=" + URLEncoder.encode(emailAddress, "UTF-8");
        String inputParams = addressParam;
        
        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getAliasMail";
        
        String response = getWebServiceResult(requestURL, inputParams);
        
        logger.debug("response=" + response);
        
        if (response != null) {
            JSONParser jsonParser = new JSONParser();
            JSONObject responseObj = (JSONObject)jsonParser.parse(response);
            
            String resultCode = (String)responseObj.get("resultCode");
            
            if (resultCode.equalsIgnoreCase("OK")) {
                JSONArray resultArray = (JSONArray)responseObj.get("result");
                
                // 개인의 Alias 이메일 주소일 경우 반환되는 주소는 하나이어야 한다.
                if (resultArray != null && resultArray.size() == 1) {
                    result = (String)resultArray.get(0);
                }
            }
        }
        
        return result;
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
	 * 특정 회사의 메일박스 디폴트 용량을 MB단위로 반환한다.
	 * @param domainName
	 * @param companyId
	 * @return
	 * @throws Exception
	 */
	public Double[] getCompanyQuota(String domainName, String companyId) throws Exception {
		Double returnedData[] = {null, null};

		String param1 = "domainName=" + domainName;
		String param2 = "companyId=" + companyId;
		String inputParams =  param1 + "&" + param2;
		logger.debug("getCompanyQuota inputParams=" + inputParams);
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getCompanyQuota";
		String response = getWebServiceResult(requestURL, inputParams);
		logger.debug("getCompanyQuota response=" + response);

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
				} else if (reasonCode == -1) { // 등록된 company quota가 없는 경우 default quota 반환
					return getDefaultQuota(domainName);
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
	 * 회사별 메일박스 디폴트 용량을 MB단위로 설정한다.
	 * @param domainName
	 * @param companyId
	 * @param maxStorage
	 * @param warnStorage
	 * @throws Exception
	 */
	public void setCompanyQuota(String domainName, String companyId, String maxStorage, String warnStorage) throws Exception {
		String param1 = "domainName=" + domainName;
		String param2 = "companyId=" + companyId;
		String param3 = "maxStorage=" + maxStorage;
		String param4 = "warnStorage=" + warnStorage;
		String inputParams = param1 + "&" + param2 + "&" + param3 + "&" + param4;
		logger.debug("setCompanyQuota inputParams=" + inputParams);
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/setCompanyQuota";

		String response = getWebServiceResult(requestURL, inputParams);

		logger.debug("setCompanyQuota response=" + response);

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = null;

			responseObj = (JSONObject)jsonParser.parse(response);
			String resultCode = (String)responseObj.get("resultCode");
			int reasonCode = ((Long)responseObj.get("reasonCode")).intValue();

			if (!resultCode.equalsIgnoreCase("OK") || reasonCode != 0) {
				throw new Exception("setCompanyQuota failed");
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
	 * 특정 사용자에 대한 메일박스 최대 용량을 MB단위로 반환한다.
	 * @param userEmail
	 * @return
	 */
	public Double[] getUserRealQuota(String userEmail) throws Exception {
		Double returnedData[] = {null, null};

		String param1 = "userEmail=" + userEmail;
		String inputParams = param1;

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getUserRealQuota";

		String response = getWebServiceResult(requestURL, inputParams);

		logger.debug("getUserRealQuota response=" + response);

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
    
    public Double[] adjustUserQuotaForMessageMove(Message[] msgs, String userEmail, String domainName, IMAPAccess ia) {
    	Double[] returnData = {null, null, null};
    	
    	try {
			// 이동할 메시지들의 총 크기를 구한다.
			double messagesTotalSize = 0;
			
			for (Message msg : msgs) {
				messagesTotalSize += msg.getSize();
			}
			
			// in MBs
			messagesTotalSize /= (1024.0*1024.0);
			
			logger.debug("messagesTotalSize=" + messagesTotalSize);
			
			// 사용자의 Quota 설정값을 구한다.
			Double[] userQuotaData = getUserQuota(userEmail);
			Double userQuota = userQuotaData[0];
			Double userWarn = userQuotaData[1];
	        
	        // 사용자 Quota 설정값이 없을 때는 디폴트 설정값을 적용한다.
	        if (userQuota == null) {
	        	Double[] defaultQuotaData = getDefaultQuota(domainName);
	        	
	        	userQuota = defaultQuotaData[0];
	        	userWarn = defaultQuotaData[0];
	        } else {
	        	// 사용자 레벨의 Quota 설정값이 있는 경우 1.0 없으면 null임
	        	returnData[2] = 1.0;
	        }
	        
	        // 사용자의 현재 메일박스 사용량을 구한다.
	        // in MBs
	        double mailboxUsage = ia.getStorageUsageAndLimit()[0]/1024.0;
	        
	        logger.debug("mailboxUsage=" + mailboxUsage);
	        
	        // 지운 편지함으로 복사할 메시지의 크기와 현재 메일박스 사용량을 더한 크기가 Quota를 초과하면 Quota를 증가시킨다.
	        if ((mailboxUsage + messagesTotalSize) > userQuota) {
		        double newUserQuota = (mailboxUsage + messagesTotalSize)*1.1;
		        
		        logger.debug("newUserQuota=" + newUserQuota);
		        
		        setUserQuota(userEmail, String.valueOf(newUserQuota), String.valueOf(userWarn));
		        
		        returnData[0] = userQuota;
		        returnData[1] = userWarn;
	        }
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
    	} catch (Exception e) {
    		logger.error(e.getMessage(), e);
    	}
        
    	return returnData;
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
    		
    		/* 보안 취약점 조치를 위해 제거함
	    	byte[] keyBytes = apb.getBytes("UTF-8");
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
			*/
    		
    		String keyStr = "!@#$%jiran123456!@#$%jiran123456";
    		String ivStr = "!@#$%jiraniv1234";

    		byte[] keyBytes = keyStr.getBytes("UTF-8");
	    	byte[] ivBytes = ivStr.getBytes("UTF-8");
	    	byte[] input = emailAddress.getBytes("UTF-8");
    		
	    	SecretKeySpec key = new SecretKeySpec(keyBytes, "AES");
	    	IvParameterSpec ivSpec = new IvParameterSpec(ivBytes);
	    	Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
	    	
	    	cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec);
	    	byte[] encrypted = cipher.doFinal(input);
	    	
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
    	sb.append("        <section class=\"security_txt\" style=\"margin:0px 0px 0px 300px;padding:54px 0px;font-family:" + egovMessageSource.getMessage("main.t246", locale) + ";position:relative;left:-50px;margin-top:-250px\">\n");
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
    	sb.append("            body{font-family:" + egovMessageSource.getMessage("main.t246", locale) + "}\n");
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
		sb.append("            <p class=\"popup_txt\">" + egovMessageSource.getMessage("ezEmail.lhm57", locale) + "<br /><span>" + egovMessageSource.getMessage("ezEmail.lhm40", locale) + "</span><br /><span>" + egovMessageSource.getMessage("ezEmail.kdh04", locale) + ": ${passwordHint} </span></p>\n");
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
			String url = m.group(1);
			int startPosOfCharacterEntity = url.length();
			int pos1 = url.indexOf("&gt;");
			int pos2 = url.indexOf("&nbsp;");

			if (pos1 != -1) {
				url = url.replace("&gt;", "");
				startPosOfCharacterEntity = pos1;				
			}

			if (pos2 != -1) {
				url = url.replace("&nbsp;", "");

				if (pos2 < startPosOfCharacterEntity) {
					startPosOfCharacterEntity = pos2;
				}
			}

			m.appendReplacement(result, Matcher.quoteReplacement(String.format("<a href=\"%s\">%s</a>%s", url, m.group(1).substring(0, startPosOfCharacterEntity), m.group(1).substring(startPosOfCharacterEntity))));
		}

		m.appendTail(result);
		
		return result.toString();		
	}

	/**
	 * style 태그가 일정 개수 이상이면 style 태그와 그 사이의 콘텐츠를 삭제하는 기능을 수행하는 메소드
	 */
	private String stripTooManyStyleTags(String src) {
		Pattern p = Pattern.compile("<style(>|\\s.*?>).*?</style>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
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
	 * 본문안에 따로 style태그가 들어가는 경우 style태그를 찾아서 삭제하는 로직추가
	 */
	private String styleClassTagsReplace(String str) {

		Pattern p = Pattern.compile("<style[^>]*>[\\s\\S]*?</style>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
		Matcher m = p.matcher(str);
		
		str = m.replaceAll("");
		
		return str;
	}
	
	
	/** 
	 * strip <object>,<applet>,<script> tags
	 */	
	private String stripScriptTags(String src) {
		Pattern p = Pattern.compile("<(object|applet|script).*?>.*?</(object|applet|script).*?>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
		Matcher m = p.matcher(src);
		src = m.replaceAll("");
				
		return src;		
	}
	
	/** 
	 * add target="_blank" to an anchor tag
	 */	
	private String addTargetBlank(String src) {
		Pattern p = Pattern.compile("<a (.*?[^a-zA-Z0-9])>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
		Matcher m = p.matcher(src);
				
		StringBuffer result = new StringBuffer();
		while (m.find()) {
			String att = m.group(1);
			
			if (att.toLowerCase().indexOf("target=") < 0) {
				att = att.replaceAll("'", "\"");
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
			
		} catch (MessagingException e) {logger.debug("e.message=" + e.getMessage());}
			
		return false;
	}
	
	// 2017.11.21 코린도 개발하면서 ZIP관련 메서드 생성 - 압축파일 풀기 
	public void unzip( InputStream is, File destDir, String encoding) throws IOException {
		ZipArchiveEntry entry ;
		String name ;
		File target ;
		int nWritten = 0;
		byte [] buf = new byte[1024 * 8];

		ensureDestDir(destDir);
		
		try (ZipArchiveInputStream zis = new ZipArchiveInputStream(is, encoding, false)) {

			while ((entry = zis.getNextZipEntry()) != null) {
				name = entry.getName();
				target = new File(destDir, name);

				if (entry.isDirectory()) {
					ensureDestDir(target);
				} else {
					target.createNewFile();

					// CWE-404 보안 취약점 대응
					try (BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(target))) {
						while ((nWritten = zis.read(buf)) >= 0) {
							bos.write(buf, 0, nWritten);
						}
					}
				}
			}
		}
	}
	
	// 디렉토리확인
	private void ensureDestDir(File dir) throws IOException {
		if ( ! dir.exists() ) {
			dir.mkdirs(); 
		}
	}
	
	// 암호화된 zip파일에 파일들을 넣는 메서드
	public String encryptZipFile(String filePath, String folderPath, String pwd) throws IOException {
		String zipFileName = filePath + "_secure.zip";

		// CVE 보안 취약점 처리 시 zip4j 라이브러리를 기존 1.3.2에서 2.11.5로 업데이트 했을 때 기존 클래스 파일을 찾지 못해 사용하지 않는
		// 기능이어서 일단 주석 처리함
		/*
		unzip(new FileInputStream(filePath), new File(folderPath), "UTF-8");
		
		File zipFile = new File(filePath);
		
		if (zipFile.delete()) {
			logger.debug(filePath + ".zip file is deleted.");
		}
		
		try {
			File dir = new File(folderPath);
			ArrayList<String> arrList = new ArrayList<>();
			File[] fileList = dir.listFiles();
			
			for (int i = 0; i < fileList.length; i++) {
				File file = fileList[i];
				
				if (file.isFile()) {
					arrList.add(file.getAbsolutePath());
				}
			}
		
			ZipFile zipFiles = new ZipFile(zipFileName);
			
			ZipParameters params = new ZipParameters();
			params.setCompressionMethod(Zip4jConstants.COMP_DEFLATE);
			params.setCompressionLevel(Zip4jConstants.DEFLATE_LEVEL_NORMAL);
			params.setEncryptFiles(true);
			params.setEncryptionMethod(Zip4jConstants.ENC_METHOD_AES);
			params.setAesKeyStrength(Zip4jConstants.AES_STRENGTH_256);
			params.setPassword(pwd);
			
			for (int i = 0; i < arrList.size(); i++) {
				zipFiles.addFile(new File(arrList.get(i)), params);
			}
			
			if (dir.isDirectory()) {
				File[] files = dir.listFiles();
				
				for (File file : files) {
					file.delete();
				}
				
				dir.delete();
				
				File dirFile = new File(folderPath + "_secure");
				dirFile.delete();
			}
		} catch (ZipException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		 */
		
		return zipFileName;
	}
	public static boolean checkZipEncrypted(File file) {
		try {
			ZipFile zipFile = new ZipFile(file);
			return zipFile.isEncrypted();  // 암호 있으면 true, 없으면 false
		} catch (ZipException e) {
			throw new RuntimeException("Not a ZIP file or the file is corrupted.", e);
		}
	}

	public boolean compressAndEncryptFile(File file, String fileName, String zipPath, String password) {
		try {

			if (!file.exists()) {
				System.out.println("File does not exist : " + file.getAbsolutePath());
				return false;
			}

			// 임시 복사 파일 만들기
			File tempFile = new File(file.getParent(), fileName);
			Files.copy(file.toPath(), tempFile.toPath(), StandardCopyOption.REPLACE_EXISTING);

			// 압축
			ZipFile zipFile = new ZipFile(zipPath, password.toCharArray());

			ZipParameters parameters = new ZipParameters();
			parameters.setCompressionMethod(CompressionMethod.DEFLATE); // 기본 압축
			parameters.setCompressionLevel(CompressionLevel.NORMAL);
			parameters.setEncryptFiles(true);
			parameters.setEncryptionMethod(EncryptionMethod.ZIP_STANDARD); // 윈도우 호환 방식

			zipFile.addFile(tempFile, parameters);  // 파라미터로 추가

			// 압축 후 임시 파일 및 원본 파일 삭제
			tempFile.delete();
			file.delete();
			
			return true;
		} catch (ZipException e) {
			logger.error(e.getMessage(), e);
			return false;
		} catch (IOException e) {
			logger.error(e.getMessage(), e);
			return false;
		}
	}

	public String createEncryptZipFile(File file, String fileName, String zipPassword, String pDirTempPath) {
		String zipPath = pDirTempPath + commonUtil.separator + fileName + ".zip";  // 결과 zip 경로 설정

		boolean encrypted = compressAndEncryptFile(file, fileName, zipPath, zipPassword);
		if (encrypted) {
			return zipPath;  // 암호화된 zip 파일 경로 반환
		}

		return null;  // 실패한 경우 null 반환
	}
	
	//메일, 메일함 저장시 파일 이름 : 보낸사람이름_[보낸사람 메일주소]_[보낸 날짜]_메일제목.eml 이 되도록 만들어주는 메서드
	public String saveFilenameForm(LoginVO loginInfo , Locale locale , Message message) throws Exception {
		EzEmailUtil ezEmailUtil = new EzEmailUtil();
		String subject = ezEmailUtil.getSubject(message);
		
		if (subject.trim().equals("")) {
			subject = egovMessageSource.getMessage("ezEmail.kms03", locale);
		}
		
		String senderAddress = ezEmailUtil.getFromEmailAddressOfMessage(message);
		
		if  (senderAddress.trim().equals("")) {
			senderAddress = egovMessageSource.getMessage("ezQuestion.t56", locale);
		}
		
		String senderName = ezEmailUtil.getFromNameOrAddressOfMessage(message);
		
		if (senderName.trim().equals("")) {
			senderName = egovMessageSource.getMessage("ezQuestion.t56", locale);
		}
		
		Date sentDate = message.getSentDate();
		String dateStrExceptTime = "";
		
		if (sentDate == null) {
			dateStrExceptTime = egovMessageSource.getMessage("ezQuestion.t56", locale);
		} else {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
			String sentDateStr = sdf.format(sentDate);
			sentDateStr = commonUtil.getDateStringInUTC(sentDateStr,loginInfo.getOffset(), false);		
			dateStrExceptTime = sentDateStr.substring(0, 10);
		}
		// 2021-11-24 이사라 : 보낸사람 이름에 파일명에 들어갈 수 없는 특수기호가 있을경우 "_"로 변경 - "/"로 인한 파일루트 생성문제 해결
		senderName = senderName.replaceAll("[\\\\/:*?\"<>|]", "_").replaceAll("[\\t\\r\\n\\v\\f\\u00a0]", "");
		subject = subject.replaceAll("[\\\\/:*?\"<>|]", "_").replaceAll("[\\t\\r\\n\\v\\f\\u00a0]", "");
		// 20200317 조진호 - 기존에는 발신자_[발신자주소]_[날짜]_제목 에서 날짜를 맨 앞으로 순서를 변경
		String fileName = dateStrExceptTime + "_" + senderName + "_[" + senderAddress + "]_" + subject ;
		return fileName;
	}
	
	// 메일 용량(사용량 및 퍼센트) 리턴하는 함수
	public String[] getMailUsage(double mailboxUsage, double mailboxQuota) {
		logger.debug("getMailUsage started");
		logger.debug("mailboxUsage=" + mailboxUsage + ",mailboxQuota=" + mailboxQuota);
		
		int mailPercent = 0;
		String mailboxDetail = "";
		String mailboxQuotaStr = "";
		
		if (mailboxUsage < mailboxQuota) {
			mailPercent = (int)Math.round((mailboxUsage/mailboxQuota) * 100);
		} else {
			mailPercent = 100;
		}
					
		// 분자
		if (mailboxUsage >= 1024*1024 ) {
			mailboxDetail = String.format("%.1fG", mailboxUsage/(1024*1024));
		} else if (mailboxUsage >= 1024) {
			mailboxDetail = String.format("%.1fM", mailboxUsage/1024);
		} else {
			mailboxDetail = String.format("%.1fK", mailboxUsage);
		}

		// 분모
		if (mailboxQuota >= 1024*1024) {
			mailboxQuotaStr = String.format("%.1fG", mailboxQuota/(1024*1024));
			
			if (mailboxQuotaStr.contains(".0")) {
				mailboxQuotaStr = mailboxQuotaStr.substring(0, mailboxQuotaStr.indexOf(".")) + "G";
			}
		} else if (mailboxQuota >= 1024) {
			mailboxQuotaStr = String.format("%.1fM", mailboxQuota/1024);
		} else {
			mailboxQuotaStr = (int)mailboxQuota + "K";
		}
		
		String[] returnStr = new String[3];
		returnStr[0] = Integer.toString(mailPercent);
		returnStr[1] = mailboxDetail;
		returnStr[2] = mailboxQuotaStr;
		
		logger.debug("getMailUsage ended");
		return returnStr;
	}
	
	/**
	 * 특수문자를 웹 브라우저에서 정상적으로 보이기 위해 특수문자를 처리('<' -> & lT)하는 기능이다
	 * @param 	srcString 		- '<'
	 * @return 	변환문자열('<' -> "&lt"
	 * @exception MyException
	 * @see
	 */
	public String getSpclStrCnvr2(String srcString) {
		logger.debug("getSpclStrCnvr2 started");

		String rtnStr = null;

		try {
			StringBuffer strTxt = new StringBuffer("");

			char chrBuff;
			int len = srcString.length();

			for (int i = 0; i < len; i++) {
				chrBuff = (char) srcString.charAt(i);

				switch (chrBuff) {
					case '<':
						strTxt.append("&lt;");
						break;
					case '>':
						strTxt.append("&gt;");
						break;
					case '"':
						strTxt.append("&quot;");
						break;
					case '&':
						strTxt.append("&amp;");
						break;
					default:
						strTxt.append(chrBuff);
				}
			}

			rtnStr = strTxt.toString();
		} catch (IndexOutOfBoundsException e) {
			logger.debug(e.getMessage(), e);
		} catch (Exception e) {
			logger.debug(e.getMessage(), e);
		}
		
		logger.debug("rtnStr=" + rtnStr);
		logger.debug("getSpclStrCnvr2 ended.");

		return rtnStr;
	}
	
	/**
	 * 편지 이동/복사, 삭제시 (검색에도 동일) 편지함에 ,콤마가 있는 경우 폴더이름/uid를 구분하여 자르기 위한 메서드  
	 * @param uniqueId
	 * @return String[] folderAndMsgIdArray
	 */
	public String[] makeFolderAndMsgIdArray(String uniqueId) {
		
		boolean isSlash = false;
		int startIdx = 0;
		List<String> folderIdList = new ArrayList<>();
		
		for (int i = 0; i < uniqueId.length(); i++) {
			String ch = String.valueOf(uniqueId.charAt(i));
			
			if (ch.equals("/")) {
				isSlash = true;
			}
			
			if (isSlash == true && (ch.equals(",") || i == uniqueId.length() - 1)) {
				String splitBoxNm = uniqueId.substring(startIdx, i + 1);
				String last = String.valueOf(splitBoxNm.charAt(splitBoxNm.length() - 1));
				
				if (last.equals(",")) {
					splitBoxNm = uniqueId.substring(startIdx, i);
				}
				
				folderIdList.add(splitBoxNm);
				startIdx = i + 1;
				isSlash = false;
			}
		}
		
		String[] folderAndMsgIdArray = new String[folderIdList.size()];
		folderAndMsgIdArray = folderIdList.toArray(folderAndMsgIdArray);
		
		return folderAndMsgIdArray;
	}
	
	/**
	 * 메일 전송시 외부로 보내는 메일 주소 자동검색 되도록 주소록에 저장시키는 메소드
	 * @param param			to, cc, bcc 의 주소록에 들어갈 name, address
	 * @param userId		주소록 user
	 * @param tenantId			
	 * @param userAccount	user 주소
	 * @param displayName	user name	
	 * @param displayName2	user name2
	 * @throws Exception 
	 */
	public void outerMailInsertAddress(List<Map<String, Object>> param, String userId, int tenantId, 
			String userAccount, String displayName, String displayName2) throws Exception {
		logger.debug("outerMailInsertAddress start.");
		String name = "";
		String address = "";
		String innerDomain = ezCommonService.getTenantConfig("MailInnerDomain", tenantId);
		List<String> innerDomainArray = Arrays.asList(innerDomain.split(";"));
		
		for (int i = 0; i < param.size(); i++) {
			
			try {
				name = (String) param.get(i).get("name");
				address = (String) param.get(i).get("address");
				String recipientDomain = address.split("@")[1];	
			
				if (!innerDomainArray.contains(recipientDomain)) {
					// exists가 false이면 존재하지 않음
					boolean exists = ezAddressService.checkDuplicateAddress(tenantId, userId, address);
					if (!exists) {
						logger.debug("autoMailAddress make : " + address);
						ezAddressService.insertAddress(tenantId, userId, "0", userAccount, 
								displayName, displayName2, name, address, "", "", "", 
								"", "", "", "", "", "", "", "", "", "P", "");
					}
				}
			} catch (PatternSyntaxException e) {
				logger.error(e.getMessage(), e);
				logger.debug("outerMail insert Address fail / failAddress:" + address );
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				logger.debug("outerMail insert Address fail / failAddress:" + address );
			}
		}
		logger.debug("outerMailInsertAddress end.");
	}
	
	public String convertSpaceToNBSP(String src) {
		return src.replace(" ", "&nbsp;");
	}
	
	public boolean isHtmlMessage(Message message) throws MessagingException, IOException {
		if (message.getHeader("Content-Type") == null) {
			return false;
		}
		
		String tempBodyType = message.getHeader("Content-Type")[0];
		String contentType = tempBodyType.split(";")[0].trim();

		if (contentType.equals("text/plain")) {
			return false;
		} else if (contentType.equals("multipart/alternative")) {
			return true;
		}
		
		Object content = message.getContent();
		
		if (content instanceof Multipart) {
			return containsHtmlMultipart((Multipart) content);
		}
		
		return true;
	}
	
	public boolean containsHtmlMultipart(Multipart multipart) throws MessagingException, IOException {
		int partCount = multipart.getCount();
		
		Object partContent;

		try {
			for (int i = 0; i < partCount; i++) {
				BodyPart bodyPart = multipart.getBodyPart(i);
				
				if (BodyPart.ATTACHMENT.equalsIgnoreCase(bodyPart.getDisposition())) {
					continue;
				}
				
				partContent = bodyPart.getContent();
				
				if (partContent instanceof Multipart && containsHtmlMultipart((Multipart) partContent)) {
					return true;
				}
	
				if (bodyPart.isMimeType("text/html") || bodyPart.isMimeType("message/*")) {
					return true;
				}
			}
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);

			return true;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			return true;
		}

		return false;
	}

	public SimpleMailer createMail(String loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userId + "@" + domainName;
		String password  = commonUtil.getUserIdAndPassword(loginCookie).get(1);

		return createMail(userAccount, password);
	}

	/** 메일을 간단히 보낼 수 있는 SimpleMailer 객체를 반환 */
	public SimpleMailer createMail(String userEmail, String password) throws Exception {
		return new SimpleMailer(userEmail, password);
	}

	public class SimpleMailer {
		private String userEmail;
		private String password;

		/** 제목 */
		private String subject;
		/** 내용 (HTML) */
		private String content;
		/**
		 * 사용자 로케일<br>
		 * useStandardFolderId 모드가 NO 일 때 메일함 다국어 지원을 위함
		 */
		private Locale locale;
		/** 중요성 */
		private EmailImportance importance;
		/** 보낸 사람 */
		private InternetAddress from;
		/** 받는 사람 */
		private List<InternetAddress> toList;
		/** 참조 */
		private List<InternetAddress> ccList;
		/** 숨은 참조 */
		private List<InternetAddress> bccList;
		/** 실제 SMTP 레벨의 수신자 */
		private List<InternetAddress> recipientList;
		/** 첨부파일 */
		private List<EmailAttachment> attachmentList;

		/** 보낸 편지함 저장 여부, 기본값: false */
		private boolean isSentSave = false;
		/** SMTP 인증 사용, 기본값: true */
		private boolean usingAuth = true;

		private SimpleMailer(String userEmail, String password) {
			this.userEmail = userEmail;
			this.password = password;
		}

		public SimpleMailer subject(String subject) {
			this.subject = subject;
			return this;
		}

		public SimpleMailer content(String content) {
			this.content = content;
			return this;
		}

		public SimpleMailer locale(Locale locale) {
			this.locale = locale;
			return this;
		}

		public SimpleMailer importance(EmailImportance importance) {
			this.importance = importance;
			return this;
		}

		public SimpleMailer from(InternetAddress from) {
			this.from = from;
			return this;
		}

		public SimpleMailer from(String from) throws AddressException {
			this.from = new InternetAddress(from);
			return this;
		}

		public SimpleMailer to(String... array) {
			return to(strArrayToAddress(array));
		}

		public SimpleMailer to(InternetAddress... array) {
			toList = addAll(toList, array);
			return this;
		}

		public SimpleMailer to(List<InternetAddress> list) {
			toList = addAll(toList, list);
			return this;
		}

		public SimpleMailer cc(String... array) {
			return cc(strArrayToAddress(array));
		}

		public SimpleMailer cc(InternetAddress... array) {
			ccList = addAll(ccList, array);
			return this;
		}

		public SimpleMailer cc(List<InternetAddress> list) {
			ccList = addAll(ccList, list);
			return this;
		}

		public SimpleMailer bcc(String... array) throws AddressException {
			return bcc(strArrayToAddress(array));
		}

		public SimpleMailer bcc(InternetAddress... array) {
			bccList = addAll(bccList, array);
			return this;
		}

		public SimpleMailer bcc(List<InternetAddress> list) {
			bccList = addAll(bccList, list);
			return this;
		}

		public SimpleMailer attach(String name, InputStream inputStream) {
			return attach(name, null, inputStream);
		}

		public SimpleMailer attach(String name, String contentType, InputStream inputStream) {
			attachmentList = addAll(attachmentList, new EmailAttachment(name, contentType, inputStream));
			return this;
		}

		public SimpleMailer attach(List<EmailAttachment> list) {
			attachmentList = addAll(attachmentList, list);
			return this;
		}

		public SimpleMailer smtpRecipients(String... array) throws AddressException {
			return smtpRecipients(strArrayToAddress(array));
		}

		public SimpleMailer smtpRecipients(InternetAddress... array) {
			recipientList = addAll(recipientList, array);
			return this;
		}

		public SimpleMailer smtpRecipients(List<InternetAddress> list) {
			recipientList = addAll(recipientList, list);
			return this;
		}

		private InternetAddress[] strArrayToAddress(String... array) {
			return Arrays.stream(array).map(address -> {
				try {
					return new InternetAddress(address);
				} catch (AddressException e) {
					logger.error(e.getMessage(), e);
					return null;
				}
			}).filter(Objects::nonNull).toArray(InternetAddress[]::new);
		}

		@SuppressWarnings("unchecked")
		private <T> List<T> addAll(List<T> origin, T... others) {
			if (others == null) {
				return origin;
			}

			return addAll(origin, Arrays.asList(others));
		}

		private <T> List<T> addAll(List<T> origin, List<T> others) {
			if (others == null) {
				return origin;
			}

			if (origin == null) {
				if (others instanceof ArrayList) {
					return others;
				}

				return new ArrayList<>(others);
			}

			origin.addAll(others);
			return origin;
		}

		public SimpleMailer saveSentMailbox(boolean isSentSave) {
			this.isSentSave = isSentSave;
			return this;
		}

		public SimpleMailer notUseAuth() {
			this.usingAuth = false;
			return this;
		}

		public void send() {
			IMAPAccess ia = null;
			boolean hasAttchment = attachmentList != null && !attachmentList.isEmpty();
			logger.debug("send started");

			try {
				String domainName = userEmail.split("@")[1];
				int tenantId = ezCommonService.getTenantIdByDomainName(domainName);
				tenantId = tenantId < 0 ? 0 : tenantId;
				
				SMTPAccess sa;
				sa = getSMTPServer(userEmail, password, tenantId, usingAuth);
				/*if (usingAuth) {
					sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"),
							config.getProperty("config.SMTPPort"),
							userEmail, password);
				} else {
					sa = SMTPAccess.getNotAuthInstance(config.getProperty("config.MailServerAddress"),
							config.getProperty("config.SMTPPort"),
							userEmail, password);
				}*/

				MimeMessage message = sa.createMimeMessage();

				// set from
				logger.debug("from=" + from.getAddress());
				message.setFrom(from);

				// 수신자 목록에서 퇴직자 제거시 list가 null이 아닐 수도 있으므로 isEmpty 추가
				// set to
				if (toList != null && !toList.isEmpty()) {
					for (InternetAddress to : toList) {
						logger.debug("to=" + to.getAddress());
						message.addRecipient(RecipientType.TO, to);
					}
				}
				// set cc
				if (ccList != null && !ccList.isEmpty()) {
					for (InternetAddress cc : ccList) {
						logger.debug("cc=" + cc.getAddress());
						message.addRecipient(RecipientType.CC, cc);
					}
				}

				// set bcc
				if (bccList != null && !toList.isEmpty()) {
					for (InternetAddress bcc : bccList) {
						logger.debug("bcc=" + bcc.getAddress());
						message.addRecipient(RecipientType.BCC, bcc);
					}
				}

				// set subject
				logger.debug("subject=" + subject);
				message.setSubject(subject, "UTF-8");

				// set content and attachment
				if (hasAttchment) {
					MimeMultipart multipartContent = new MimeMultipart();

					if (content != null) {
						BodyPart htmlContentPart = new MimeBodyPart();
						htmlContentPart.setContent(content, "text/html; charset=utf-8");

						multipartContent.addBodyPart(htmlContentPart);
					}

					for (EmailAttachment attachment : attachmentList) {
						InputStream attachInputStream = attachment.getInputStream();
						BodyPart attachPart = new MimeBodyPart();

						// 첨부파일 이름 자소결합, UTF-8 인코드 및 폴딩
						String nfcFilename = commonUtil.normalizeFileName(attachment.getName());
						String encodedFileName = MimeUtility.encodeText(nfcFilename, "UTF-8", "B");
						encodedFileName = MimeUtility.fold(0, encodedFileName);

						// 첨부파일의 Content-Type을 구한다. (디폴트는
						// application/octet-stream로 설정)
						String contentType = attachment.getContentType();

						// Content-Type을 구할 수 없다면 application/octet-stream 를
						// 기본값으로 함
						if (contentType == null) {
							contentType = Optional
									.ofNullable(URLConnection.guessContentTypeFromStream(attachInputStream))
									.orElse("application/octet-stream");
						}

						attachPart.setDataHandler(new DataHandler(new ByteArrayDataSource(attachInputStream, contentType)));
						attachPart.setHeader("Content-Disposition", "attachment;\r\n filename=\"" + encodedFileName + "\"");
						attachPart.setHeader("Content-Type", contentType);

						multipartContent.addBodyPart(attachPart);
					}

					message.setContent(multipartContent);
				} else {
					message.setContent(content, "text/html; charset=utf-8");
				}

				// set sentDate
				message.setSentDate(Calendar.getInstance().getTime());

				// set User-Agent header
				message.setHeader("User-Agent", "JMocha Mail 1.0");

				// set importance header
				if (importance != null && importance != EmailImportance.NORMAL) {
					message.setHeader("Importance", importance.getMappingValue());
					message.setHeader("X-Priority", importance.getPriority());
				}

				// set X-JMocha-Noti header
				message.setHeader("X-JMocha-Noti", "true");

				if (recipientList == null) {
					Transport.send(message);
				} else {
					Transport.send(message, recipientList.toArray(new InternetAddress[recipientList.size()]));
				}

				logger.debug("Mail send success.");

				if (isSentSave && "YES".equalsIgnoreCase(config.getProperty("config.SentMailStoredInSentbox", "YES"))) {
					// 유저 로케일이 없을시 시스템 로케일로 설정
					if (locale == null) {
						locale = Locale.getDefault();
					}
					// 보낸편지함에 저장
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"),
							config.getProperty("config.IMAPPort"),
							userEmail, password, egovMessageSource, locale,
							EzEmailUtil.this);

					if (ia != null){
						Folder sentFolder = ia.getFolder(getSentFolderId(locale));

						if (sentFolder != null){
							if (!sentFolder.exists()) {
								ia.createFolder(sentFolder.getFullName());
							}

							message.setFlag(Flags.Flag.SEEN, true);
							sentFolder.open(Folder.READ_WRITE);
							sentFolder.appendMessages(new Message[] { message });
							sentFolder.close(true);
							logger.debug("Mail is successfully saved in sent folder.");
						}

					}
				}
			} catch (MessagingException e) {
				logger.error(e.getMessage(), e);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			} finally {
				if (ia != null) {
					ia.close();
				}
			}

			logger.debug("send ended");
		}
	}

	public String spamSniperEnc(String emailAddress, String spamSniperAuthKey, String spamSniperAuthIv, long spamSniperUnixTime) throws Exception {
		logger.debug("spamSniperEnc start");
		String cryptResult = null;
		String authKey = spamSniperAuthKey;
		String authIv = spamSniperAuthIv;
		String algorithm = "AES";
		String mode = "CBC";

		if (!(emailAddress.equals("") || authKey.equals("") || authIv.equals(""))) {
			byte[] secretKey = authKey.getBytes();

			String transform = String.format("%s/%s/%s", algorithm, mode, "PKCS5Padding");
			Cipher cipher = null;
			cipher = Cipher.getInstance(transform);

			byte[] iv = authIv.getBytes();
			int len = 16;

			SecretKeySpec secretKeySpec = new SecretKeySpec(secretKey, 0, len, algorithm);
			cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, new IvParameterSpec(iv, 0, len));
			String encryptTarget = emailAddress;

			if (spamSniperUnixTime > 0) {
				encryptTarget += ".." + (System.currentTimeMillis() / 1000L + spamSniperUnixTime);
			}

			byte[] encrypted = cipher.doFinal(encryptTarget.getBytes());
			cryptResult = new String(Hex.encode(encrypted));
		}

		logger.debug("emailAddress={},spamSniperAuthKey={},spamSniperAuthIv={},spamSniperUnixTime={}",
				emailAddress, spamSniperAuthKey, spamSniperAuthIv, spamSniperUnixTime);
		logger.debug("spamSniperEnc end");
		return cryptResult;
	}
    
    // 메일 완료/완료취소 flag
    public boolean hasMailConfirmFlag(Message message) throws MessagingException {
		boolean isMailConfirmFlag = false;
		String[] flags = message.getFlags().getUserFlags();		
		
		for (String flag : flags) {
			if (flag.equals("$MailConfirm")) {
				isMailConfirmFlag = true;
				break;
			}
		}

		return isMailConfirmFlag;
	}
	
    // 메일 완료/완료취소 flag
	public void setMailConfirmFlag(Message message, boolean isSet) throws MessagingException {
		Flags MailConfirmFlag = new Flags("$MailConfirm");
		message.setFlags(MailConfirmFlag, isSet);
	}

	/**
     * 발신자 메일 주소와 이름이 같을 경우 (혹은 이름이 없어서 메일주소로 이름을 생성할 때)
     * 이름에 ; : , 가 들어가면 수신거부 안되는 현상 때문에 추가
     */
    public List<String> mailAddrNameParse(String mailAddrName, String mailAddr) throws Exception {
    	logger.debug("mailAddrNameParse started.");
    	logger.debug("mailAddrName=" + mailAddrName + ", mailAddr=" + mailAddr);

    	List<String> returnList = new ArrayList<String>();
    	String reMailAddrName = mailAddrName;
    	String reMailAddr = mailAddr;
    	
    	if (mailAddrName.equals(mailAddr)) {
    		int mailAddrLeft = mailAddrName.lastIndexOf("<");
    		int mailAddrRight = mailAddrName.lastIndexOf(">");
    		
    		if (mailAddrLeft < mailAddrRight) {
    			String MailAddrNameTemp = mailAddrName;
    			String MailAddrTemp = mailAddrName;
    			
    			if(mailAddrLeft == -1 || mailAddrRight == -1){
    				// 메일 주소에 @도메인이 포함되어있지 않은 경우에 message.getFrom을 하게 되면 :>:;; 가 추가되는 경우가 생김.
    				// @까지만 붙게 되면 :; 가 붙게 되는 현상이 생기기때문에 하위 코드에서 제거해주어야함.
    				// 이에 다음과 같이 모두 제거하는 코드를 추가 
    				// docs/eml/FROM 헤더에 도메인 없이 아이디만 온 경우_에러.eml 참고 
    				
    				MailAddrTemp = MailAddrTemp.replaceAll("<", "").replaceAll(">", "").replaceAll(";", "").replaceAll(":", "").trim();
    				
    				MailAddrNameTemp = MailAddrNameTemp.trim().replaceAll(",", " ").replaceAll(":", " ").replaceAll(";", " ").replaceAll("<", " ").replaceAll(">", " ");
    				MailAddrNameTemp = "\"" + MailAddrNameTemp + "\"";
    			} else {
    				MailAddrNameTemp = mailAddrName.substring(0, mailAddrLeft);
    				MailAddrTemp = mailAddrName.substring(mailAddrLeft);
    				
    				MailAddrTemp = MailAddrTemp.replaceAll("<", "").replaceAll(">", "").replaceAll(";", "");
    				
    				MailAddrNameTemp = MailAddrNameTemp.trim().replaceAll(",", " ").replaceAll(":", " ").replaceAll(";", " ");
    				MailAddrNameTemp = "\"" + MailAddrNameTemp + "\"";
    			}

    			reMailAddrName = MailAddrNameTemp;
    			reMailAddr = MailAddrTemp;
    		}
    	}
    	logger.debug("reMailAddrName=" + reMailAddrName + ", reMailAddr=" + reMailAddr);
    	
		returnList.add(reMailAddrName);
		returnList.add(reMailAddr);
		
    	logger.debug("mailAddrNameParse ended.");
    	return returnList;
    }
   
    /**
     * smtp server info
     */
 	public SMTPAccess getSMTPServer(String userAccount, String userPw, String primary, int tenantId) {
		return getSMTPServer(userAccount, userPw, primary, tenantId, true);
	}
    /**
     * smtp server info
     */
	public SMTPAccess getSMTPServer(String userAccount, String userPw, int tenantId, boolean usingAuth) {
		return getSMTPServer(userAccount, userPw, "", tenantId, true);
	}

	public SMTPAccess getSMTPServer(String userAccount, String userPw, String primary, int tenantId, boolean usingAuth) {
    	logger.debug("getSMTPServer started.");
    	
    	String smtpMailServer = "";
    	String smtpMailServerPort = "";
    	
    	SMTPAccess reSMTPAccess = null;
    	try {
    		smtpMailServer = config.getProperty("config.MailServerAddress");
    		smtpMailServerPort = config.getProperty("config.SMTPPort");
    		String smtpUserId = userAccount;
    		String smtpUserPw = userPw;
    		
    		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", tenantId); // 외부메일 사용 여부
			if (useExternalMailServer.equalsIgnoreCase("YES")) { // 외부메일 사용 시 
				String externalMailServerAddr = ezCommonService.getTenantConfig("useExternalMailServerAddress", tenantId);
				String externalMailServerAuth = ezCommonService.getTenantConfig("useExternalMailServerAuth", tenantId);
				String externalMailServerPort = ezCommonService.getTenantConfig("useExternalMailServerPort", tenantId);
				logger.debug("externalMailServerAddr=" + externalMailServerAddr + ", externalMailServerAuth=" + externalMailServerAuth + ", externalMailServerPort=" + externalMailServerPort);
				
				if (!externalMailServerAddr.equals("") && !externalMailServerAddr.equals("0.0.0.0")) {
					smtpMailServer = externalMailServerAddr;
					
					if (smtpMailServerPort != null && !smtpMailServerPort.trim().equals("")) { // external mail SMTP port.
						smtpMailServerPort = externalMailServerPort;
					}
					
					if (externalMailServerAuth.equalsIgnoreCase("YES")) { // 인증여부
						String externalMailServerUserId = ezCommonService.getTenantConfig("useExternalMailServerUserId", tenantId);
						String externalMailServerUserPw = ezCommonService.getTenantConfig("useExternalMailServerUserPw", tenantId);

						if (!externalMailServerUserId.equals("") && !externalMailServerUserPw.equals("")) {
							smtpUserId = externalMailServerUserId;
							smtpUserPw = externalMailServerUserPw;
						}
						
						usingAuth = true;
					} else {
						usingAuth = false;
					}
				} // externalMailServerAddr if end
			}

			logger.debug("smtpMailServer={}, smtpMailServerPort={}, usingAuth={}, smtpUserId={}, primary={}", smtpMailServer, smtpMailServerPort, usingAuth, smtpUserId, primary);

			if (usingAuth) {
				reSMTPAccess = SMTPAccess.getInstance(smtpMailServer, smtpMailServerPort, smtpUserId, smtpUserPw, primary);
			} else {
				reSMTPAccess = SMTPAccess.getNotAuthInstance(smtpMailServer, smtpMailServerPort, smtpUserId, smtpUserPw, primary);
			}
		} catch (DataAccessException e) {
			logger.error(e.getMessage(), e);

			reSMTPAccess = SMTPAccess.getInstance(smtpMailServer, smtpMailServerPort, userAccount, userPw, primary);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			reSMTPAccess = SMTPAccess.getInstance(smtpMailServer, smtpMailServerPort, userAccount, userPw, primary);
		}
    	logger.debug("getSMTPServer ended.");
    	return reSMTPAccess;
    }
        
    /**
     * 아이캘린더 - 메일 text/calendar 파트 리턴
     */
    public Part getIcalMailPart(Part part) {
    	Part rePart = null;
    	
    	try {
    		logger.debug("getIcalMailPart:{}", part.getContentType());
    		
    		if(part.isMimeType("multipart/alternative") || part.isMimeType("multipart/MIXED") || part.isMimeType("multipart/related")){
    			Multipart mp = (Multipart)part.getContent();
    			int count = mp.getCount();
    			Part p = null;
    			
    			for (int i = 0; i < count; i++) {
    				p = mp.getBodyPart(i);
    				rePart = getIcalMailPart(p);
    				
    				if (rePart != null) { break; }
    			}
        	} else if(part.isMimeType("text/calendar")) {
        		rePart = part;
        	}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
    	
    	return rePart;
    }
    
    /**
     * 아이캘린더 - 메일 Ical 지원
     */
    public String getIcalMailPartHTML(Part part, Locale locale) {
    	IcalVO vo = getIcalProperty(part);
    	vo.setLocale(locale);
    	
    	String periodTit        = egovMessageSource.getMessage("ezEmail.ical03", locale); // 시간
    	String locationTit      = egovMessageSource.getMessage("ezEmail.ical04", locale); // 장소
    	String attendeeTit      = egovMessageSource.getMessage("ezEmail.ical05", locale); // 참석자
    	String untitledMsg      = egovMessageSource.getMessage("ezEmail.ical02", locale); // 제목없음
    	String fontFamilyMsg    = egovMessageSource.getMessage("main.t246", locale); 
    	
    	String summary     = vo.getSummaryStr().isEmpty() ? untitledMsg : vo.getSummaryStr();
    	String period      = getIcalPeriodStr(vo);
    	String location    = vo.getLocationStr();
    	String descBody    = StringUtils.defaultString(vo.getAltDescStr());
		descBody = addTargetBlank(descBody);
    	descBody = (descBody == null || descBody.equals("")) ? vo.getDescriptionStr() : descBody;
    	       
		PropertyList<Attendee> attendeeList = vo.getAttendee();
    	
    	StringBuilder sb = new StringBuilder();
    	
    	sb.append("<style>");
	    	sb.append(".gw_ical_divWrap { width: 98%; min-height: 120px; background: #fbfbfb; border-style: solid; border-width: 1px 0 1px 0; "
	    			+ "border-color: #e5e5e5; box-sizing: border-box; padding: 20px 10px; font-size: 13px; font-family: " + fontFamilyMsg + "}");
	    	sb.append(".gw_ical_divWrap > p { line-height: 25px; } ");
	    	sb.append(".gw_ical_contents > table tr > td:first-child { min-width: 60px; padding-right: 10px; } ");
	    	sb.append(".gw_ical_summary { font-size: larger; padding-bottom: 10px; } ");
	    	sb.append(".gw_ical_btns { margin-top: 10px } ");
	    	sb.append(".gw_ical_attendee span:not(:last-child):after { content:', ' } ");
	    	sb.append(".gw_ical_btns > button { margin-right: 5px; background: white; border: 1px solid #eee; cursor: pointer; min-width: 70px; box-sizing: border-box; padding: 8px 10px; } ");
	    	sb.append(".gw_ical_desc { margin-top: 10px } ");
    	sb.append("</style>");
    	
    	sb.append("<div class='gw_ical_divWrap'>");
			sb.append("<div class='gw_ical_contents'>");
				// 일정 제목
				sb.append("<div class='gw_ical_summary'>");
					sb.append("<img class='ui-datepicker-trigger' src='/images/ImgIcon/calendar-month.png' alt='' title='' style='margin-right: 10px;'>");
					sb.append(summary);
				sb.append("</div>");
				// 시간, 장소, 참석자
				sb.append("<table>");
					sb.append("<tr class='gw_ical_period'>");
						sb.append("<td>").append(periodTit).append("</td>");
						sb.append("<td>").append(period).append("</td>");
					sb.append("</tr>");

					sb.append("<tr class='gw_ical_location'>");
						sb.append("<td>").append(locationTit).append("</td>");
						sb.append("<td>").append(location).append("</td>");
					sb.append("</tr>");
					
					sb.append("<tr class='gw_ical_attendee'>");
						sb.append("<td>").append(attendeeTit).append("</td>");
						sb.append("<td>");
							for (Attendee attendee : attendeeList) {
								String mailto = attendee.getCalAddress().getSchemeSpecificPart().toString();
								String cn = mailto;
										
								Parameter cnParam = attendee.getParameter(Parameter.CN);
								if (cnParam != null) {
									cn = cnParam.getValue();
								}
								
								String spanTmp = String.format("<span title='%s'>%s</span>", mailto, cn);
								sb.append(spanTmp);
							}
						sb.append("</td>");
					sb.append("</tr>");
				sb.append("</table>");
				// 본문
				sb.append("<div class='gw_ical_desc'>");
					sb.append(descBody.replaceAll("\n", "<br />"));
				sb.append("</div>");
			sb.append("</div>"); // gw_ical_contents div END.
		sb.append("</div>");
    	
    	return sb.toString();
    }

    /**
     * 아이캘린더 - 기간 및 시간 조합
     */
    public String getIcalPeriodStr(IcalVO vo) {
    	String periodStr     = "";
		String recurStr      = "";
		
		Recur recur       = vo.getRecur();
		int recurCount    = 0;
		Locale locale     = vo.getLocale();
		Date sDate        = vo.getDtStartDate();
		Date eDate        = vo.getDtEndDate();
		boolean isAllDay  = vo.isDtAllDay();
		
		if (recur != null) {
			recurCount       = recur.getCount();
			
			String freq      =    recur.getFrequency(); // DAILY WEEKLY MONTHLY YEARLY
			int interval     =    recur.getInterval();
			String dayList        =   (recur.getDayList() != null) ? recur.getDayList().toString() : ""; // MO,TU,WE,TH,FR,SA,SU
			String setPosList     =   (recur.getSetPosList() != null) ? recur.getSetPosList().toString() : ""; // 1, 2, 3, 4, -1
			String monthDayList   =   (recur.getMonthDayList() != null) ? recur.getMonthDayList().toString() : "";
			String monthList      =   (recur.getMonthList() != null) ? recur.getMonthList().toString() : "";
			
			String freqMsg       = ""; // 매일, 매주, 매월, 매년
			String intervalMsg   = ""; // %s일마다, %s주마다, %s달마다, %s년마다
			String monthMsg      = egovMessageSource.getMessage("ezEmail.ical10", locale); // %s월
			String monthDayMsg   = egovMessageSource.getMessage("ezEmail.ical11", locale); // %s일
			
			
			switch (freq) {
				case "DAILY":
					
					freqMsg = egovMessageSource.getMessage("ezEmail.ical06", locale);
					intervalMsg = egovMessageSource.getMessage("ezEmail.ical12", locale);
					
					break;
				case "WEEKLY":
					
					freqMsg = egovMessageSource.getMessage("ezEmail.ical07", locale);
					intervalMsg = egovMessageSource.getMessage("ezEmail.ical13", locale);
					
					break;
				case "MONTHLY":
					
					freqMsg = egovMessageSource.getMessage("ezEmail.ical08", locale);
					intervalMsg = egovMessageSource.getMessage("ezEmail.ical14", locale);
					
					break;
				default : // YEARLY
					
					freqMsg = egovMessageSource.getMessage("ezEmail.ical09", locale);
					intervalMsg = egovMessageSource.getMessage("ezEmail.ical15", locale);
					
					break;
			}
			
			// ex) 매년 or 2년마다
			if (interval > 0) {
				recurStr = String.format(intervalMsg, interval);
			} else {
				recurStr = freqMsg;
			}
			
			// ex) 12월
			if (!monthList.isEmpty()) {
				recurStr += " " + String.format(monthMsg, monthList);
			}

			// ex) 30일
			if (!monthDayList.isEmpty()) {
				recurStr += " " + String.format(monthDayMsg, monthDayList);
			}
			
			// ex) 마지막주 (수)
			if (!dayList.isEmpty()) {
				if (!setPosList.isEmpty()) {
					recurStr += " " + icalWeekToString(setPosList, locale);
				}
				
				recurStr += "(" + icalDayToString(dayList, TextStyle.NARROW, locale) + ")";
			}
			
			periodStr += recurStr;
		} // recur if End
    	
		
		String sDateStr = "";
		String sHourStr = "";
		String eDateStr = "";
		String eHourStr = "";
		String timeZone = new SimpleDateFormat("(z)", locale).format(sDate);
		
		if (recurStr.isEmpty()) {
	    	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd (E)", locale);
	    	sDateStr = dateFormat.format(sDate);
	    	eDateStr = dateFormat.format(eDate);
	    	
	    	// 하루종일이거나 시작날짜와 종료날짜가 같으면 종료날짜 empty String
	    	eDateStr = (isAllDay || sDateStr.equals(eDateStr)) ? "" : eDateStr ;
		}
		
		if (!isAllDay) {
	    	SimpleDateFormat hourFormat = new SimpleDateFormat("a hh:mm", locale);
	    	sHourStr = hourFormat.format(sDate);
	    	eHourStr = hourFormat.format(eDate);
		}
	    
		String sTmp = sDateStr + " " + sHourStr;
		String eTmp = eDateStr + " " + eHourStr;

		String dateTmp = (eTmp.trim().isEmpty()) ? sTmp : sTmp + " ~ " + eTmp;
			   dateTmp += timeZone;
		
	   periodStr += dateTmp;
        
        // ex) (10회)
        if (recurCount > 0) {
        	periodStr += String.format(egovMessageSource.getMessage("ezEmail.ical21", locale), recurCount);
        }
    	
    	return periodStr;
    }

	private String icalDayToString(String day, TextStyle textStyle, Locale locale) {
		if (day.isEmpty()) {return ""; }

		String[] dayArr    =   day.split(",");
		String[] reDayArr  =   new String[dayArr.length];
		DayOfWeek dayTmp;
		
		for (int i = 0; i < dayArr.length; i++) {
			switch(dayArr[i]) {
				case "MO" : dayTmp = DayOfWeek.MONDAY; break;
				case "TU" : dayTmp = DayOfWeek.TUESDAY; break;
				case "WE" : dayTmp = DayOfWeek.WEDNESDAY; break;
				case "TH" : dayTmp = DayOfWeek.THURSDAY; break;
				case "FR" : dayTmp = DayOfWeek.FRIDAY; break;
				case "SA" : dayTmp = DayOfWeek.SATURDAY; break;
				default   : dayTmp = DayOfWeek.SUNDAY; break;
			}
			
			reDayArr[i] = dayTmp.getDisplayName(TextStyle.NARROW, locale);
		}
		
		return String.join(",", reDayArr);
	}
	
	private String icalWeekToString(String week, Locale locale) {
		String returnStr = "";
		
		switch (week) {
			case "1" :  returnStr = "ezEmail.ical16"; break;
			case "2" :  returnStr = "ezEmail.ical17"; break;
			case "3" :  returnStr = "ezEmail.ical18"; break;
			case "4" :  returnStr = "ezEmail.ical19"; break;
			default  :  returnStr = "ezEmail.ical20"; break;
		}
		
		returnStr = egovMessageSource.getMessage(returnStr, locale);
		
		return returnStr;
	}
    
    /**
     * 아이캘린더 - IcalVO 리턴
     */
	public IcalVO getIcalProperty(Part part) {
    	logger.debug("getIcalProperty started.");
    	
    	IcalVO icalVO = new IcalVO();

    	InputStream is = null;
    	
    	try {
    		if (!part.isMimeType("text/calendar")) { throw new Exception("IS_NOT_text/calendar"); }
        	
        	is = getContentInputStream(part);

			CompatibilityHints.setHintEnabled(KEY_RELAXED_UNFOLDING, true);
			CompatibilityHints.setHintEnabled(KEY_RELAXED_PARSING, true);
			CompatibilityHints.setHintEnabled(KEY_RELAXED_VALIDATION, true);
			
    		CalendarBuilder cb = new CalendarBuilder();
    		net.fortuna.ical4j.model.Calendar cal = cb.build(is);
    		
            ComponentList<CalendarComponent> compVEVENT = cal.getComponents(net.fortuna.ical4j.model.Component.VEVENT);
            for (CalendarComponent cp : compVEVENT) {
            	VEvent vEvent = (VEvent) cp;
            	
            	icalVO.setSummary(vEvent.getSummary());
            	icalVO.setDtStart(vEvent.getStartDate());
            	icalVO.setDtEnd(vEvent.getEndDate());
            	icalVO.setLocation(vEvent.getLocation());
            	icalVO.setOrganizer(vEvent.getOrganizer());
            	icalVO.setUid(vEvent.getUid());
            	icalVO.setrRule((RRule) vEvent.getProperty(Property.RRULE));
            	icalVO.setAttendee(vEvent.getProperties(Property.ATTENDEE));
            	icalVO.setAltDesc(vEvent.getProperty("X-ALT-DESC"));
            	icalVO.setDescription(vEvent.getDescription());
            }
		} catch (IOException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (is != null) {
				try {
					is.close();
				} catch (IOException e) {}
			}
		}
    	
    	logger.debug("getIcalProperty ended.");
    	return icalVO;
    }

    // 리얼 주소 구하기
	public String getMailReadAddress(String address) throws Exception {
		String realAddress = address;
		
		String inputParams = "address=" + URLEncoder.encode(address, "UTF-8");
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getRealAddress";
		String response = getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				realAddress = (String) responseObj.get("result");
			} else {
				throw new Exception("JGwServer ERROR");
			}
		}
		logger.debug("realAddress={}", realAddress);
		
		return realAddress;
	}
	
	// 회사 메일인지 확인
	public boolean isCompanyMail(String address, int tenantId) throws Exception {
		boolean isCompanyMail = false;
		
		String realAddress = getMailReadAddress(address);
		String cn = realAddress.split("@")[0];
		
		OrganDeptVO deptVO = ezOrganService.getDeptInfo(cn, "1", tenantId);
		if (deptVO != null) {
			isCompanyMail = (deptVO.getCn().equals(deptVO.getExtensionAttribute2())); // 회사는 extensionAttribute2가 cn과 동일
		}
		
		return isCompanyMail;
	}
	
	/**
	 * 승인메일 : 승인메일 공유사서함에 있는 메일을 다른 사용자의 폴더로 복사
	 * @param applicantFolderId: 복사할 폴더명
	 * @param delFlag: 복사 후 승인메일 공유사서함에 있는 메일 삭제 여부
	 */
	public int apprMailMoveToFolder(Locale locale, int tenantId, Map<String, Object> apprMailMap, String applicantFolderId, boolean delFlag) throws Exception {
		logger.debug("apprMailMoveToFolder started.");
		logger.debug("apprMailMoveToFolder locale={}, tenantId={}, applicantFolderId={}, delFlag={}", locale, tenantId, applicantFolderId, delFlag);

		int resultInt = 0;
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		IMAPAccess ia = null;
		String password = commonUtil.getMailPassword();		
		String apprSharedMailBox = getApprSharedMailBox(tenantId, locale, password);
		String apprSharedMailBoxEmail = apprSharedMailBox + "@" + domainName;
		
		try {
			String applicantEmail = (String) apprMailMap.get("applicantEmail");
			long uid = (long) apprMailMap.get("uid");
			logger.debug("apprMailMoveToFolder applicantEmail={}, uid={}", applicantEmail, uid);

			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					applicantEmail, password, egovMessageSource, locale, this, apprSharedMailBoxEmail);
				
			// 신청자의 승인메일 공유사서함 폴더
			IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(getSentFolderId(locale), true);
			sourceFolder.open(Folder.READ_WRITE);
			
			Message message = sourceFolder.getMessageByUID(uid);

			// 이미 임시보관함으로 이동하여 메일이 없는 경우, 아래 appendUids 오류가 발생하지 않는 경우가 발생하여 대응
			if (message == null) {
				resultInt = 1;
			}

			IMAPFolder movefolder = (IMAPFolder)ia.getFolder(applicantFolderId);	
			movefolder.open(Folder.READ_WRITE);		
			
			// 대상폴더에 메일 추가
			AppendUID[] appendUids = movefolder.appendUIDMessages(new Message[]{message});
				
			// 승인메일 공유사서함에 저장되어있는 메일 삭제
			if (delFlag) {
				sourceFolder.setFlags(new Message[]{message}, new Flags(Flags.Flag.DELETED), true);
			}
			
			sourceFolder.close(true);	
			movefolder.close(true);	
		} catch (Exception e) {
			throw e;
		} finally {
			if (ia != null) {
				ia.close();
			}
		}

		logger.debug("apprMailMoveToFolder ended.");
		return resultInt;
	}
	
	/**
	 * 승인메일 : 승인메일 공유사서함에 있는 메일삭제
	 * @param applicantFolderId: 복사할 폴더명
	 * @param delFlag: 복사 후 승인메일 공유사서함에 있는 메일 삭제 여부
	 */
	public int apprMailDeleteFromSharedMailbox(Locale locale, int tenantId, Map<String, Object> apprMailMap) throws Exception {
		logger.debug("apprMailDeleteFromSharedMailbox started.");
		logger.debug("locale={}, tenantId={}", locale, tenantId);

		int resultInt = 0;
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		IMAPAccess ia = null;
		String password = commonUtil.getMailPassword();		
		String apprSharedMailBox = getApprSharedMailBox(tenantId, locale, password);
		String apprSharedMailBoxEmail = apprSharedMailBox + "@" + domainName;
		
		try {
			String applicantEmail = (String) apprMailMap.get("applicantEmail");
			long uid = (long) apprMailMap.get("uid");
			logger.debug("applicantEmail={}, uid={}", applicantEmail, uid);

			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					applicantEmail, password, egovMessageSource, locale, this, apprSharedMailBoxEmail);
				
			// 신청자의 승인메일 공유사서함 폴더
			IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(getSentFolderId(locale), true);
			sourceFolder.open(Folder.READ_WRITE);

			// 승인메일 공유사서함에 저장되어있는 메일 삭제
			Message message = sourceFolder.getMessageByUID(uid);
			if (message != null) {
				sourceFolder.setFlags(new Message[]{message}, new Flags(Flags.Flag.DELETED), true);
			}
			
			sourceFolder.close(true);	
		} catch (Exception e) {
			throw e;
		} finally {
			if (ia != null) {
				ia.close();
			}
		}

		logger.debug("apprMailDeleteFromSharedMailbox ended.");
		return resultInt;
	}
	
	/**
	 * 승인메일 :메일 발송 및 신청자의 보낸편지함으로 메일 복사
	 * @param apprMailMap: applicantEmail(신청자 이메일), uid(대상 메일 uid)
	 * @param delFlag: 복사 후 승인메일 공유사서함에 있는 메일 삭제 여부
	 */
	public int apprMailMoveAndSend(Locale locale, int tenantId, Map<String, Object> apprMailMap, boolean delFlag) throws Exception {
		logger.debug("apprMailMoveAndSend started.");
		logger.debug("locale={}, tenantId={}, delFlag={}", locale, tenantId, delFlag);

		int resultInt = 0;

		String approverEmail = (String) apprMailMap.get("approverEmail");
		String applicantEmail = (String) apprMailMap.get("applicantEmail");
		String userId = applicantEmail.split("@")[0];
		long uid = (long) apprMailMap.get("uid");
		logger.debug("approverEmail={}, applicantEmail={}, userId={}, uid={}", approverEmail, applicantEmail, userId, uid);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		String useSecureMail = ezCommonService.getTenantConfig("USE_SECUREMAIL", tenantId);
		String sentMailStoredInSentBox = config.getProperty("SentMailStoredInSentbox", "YES");
		logger.debug("domainName={}, userSecureMail={}, sentMailStoredInSentBox={}", domainName, useSecureMail, sentMailStoredInSentBox);
		
		OrganUserVO applicantVO = ezOrganAdminService.getUserInfo(userId, "1", tenantId);
		boolean applicantExist = (applicantVO != null);
		logger.debug("applicantExist={}", applicantExist);
		
		IMAPAccess ia = null;
		SMTPAccess sa = null;
		String password = commonUtil.getMailPassword();		
		String apprSharedMailBox = getApprSharedMailBox(tenantId, locale, password); // 승인메일 공유사서함 아이디
		String apprSharedMailBoxEmail = apprSharedMailBox + "@" + domainName;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					applicantEmail, password, egovMessageSource, locale, this, apprSharedMailBoxEmail);
			if (applicantExist) {
				sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
					applicantEmail, password);
			} else {
				sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
					approverEmail, password);
			}
			
			// 신청자의 승인메일 공유사서함 폴더
			IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(getSentFolderId(locale), true);
			sourceFolder.open(Folder.READ_WRITE);
			
			Message orgMessage = sourceFolder.getMessageByUID(uid);	

			// 메일 발송
			MimeMessage message = null;
			
			/* orgMessage.getInputStream()해서 readMimeMessage할 경우 
			 * Content-Type: multipart/alternative; 누락되는 현상이 있어 아래와 같이 수정함
			 */
			try(ByteArrayOutputStream os = new ByteArrayOutputStream()) {
				orgMessage.writeTo(os); // 원본메일을 outputStream으로
				byte[] osByteArray = os.toByteArray();
				try(ByteArrayInputStream is = new ByteArrayInputStream(osByteArray)) {
					message = sa.readMimeMessage(is);
				}
			}
			
    		@SuppressWarnings("unchecked")
			Enumeration<Header> headerEnum = orgMessage.getAllHeaders();
    		while (headerEnum.hasMoreElements()) {
    			Header header = headerEnum.nextElement();
    			message.setHeader(header.getName(), header.getValue());
    		}
			
			// SentDate 재설정
			Date nDate = Calendar.getInstance().getTime();
			message.setSentDate(nDate);
			logger.debug("Reset sentDate. sentDate=" + message.getSentDate().toString());
			
			String[] eachMailHeaders = message.getHeader("X-JMocha-Each-Mail");
			String eachMailHeader = eachMailHeaders != null ? eachMailHeaders[0] : null;		
			if (eachMailHeader != null) {
				message.removeHeader("X-JMocha-Each-Mail");
			}
				
			String[] secureMailHeaders = message.getHeader("X-JMocha-Secure-Mail");
			String secureMailHeader = secureMailHeaders != null ? secureMailHeaders[0] : null;
				
			// 보안메일 처리
			if (useSecureMail.equals("YES") && secureMailHeader != null && secureMailHeader.equals("true")) {
				String offset = ezCommonService.selectUserGetTimeZone(userId, tenantId);
				String realPath = commonUtil.getRealPath(servletContext);
				File encryptedFile = null; // 보안메일 관련 파일 변수
				
				// get Info from secureMail header
				secureMailHeader = MimeUtility.decodeText(secureMailHeader);
				String securePassword = message.getHeader("X-JMocha-Secure-Mail-Password")[0];
				String secureReadCount = message.getHeader("X-JMocha-Secure-Mail-ReadCount")[0];
				String secureReadDate = message.getHeader("X-JMocha-Secure-Mail-ReadDate")[0];
				String serverName = message.getHeader("X-JMocha-Secure-Mail-ServerName")[0];
				String securePasswordHint = message.getHeader("X-JMocha-Secure-Mail-PasswordHint")[0];
				
				// 암호화되어있는 securePassword 복호화
    			String prm = egovFileScrty.getPrm();
            	String pre = egovFileScrty.getPre();
            	PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
            	securePassword = EgovFileScrty.decryptRsa(pk, securePassword);

				boolean useKlibEncrypt = "YES".equalsIgnoreCase(config.getProperty("config.useKlibEncrypt"));
				
				logger.debug("securePassword={}, secureReadCount={}, secureReadDate={}, serverName={}, useKlibEncrypt={}"
						,securePassword, secureReadCount, secureReadDate, serverName, useKlibEncrypt);
				
				// remove header
				message.removeHeader("X-JMocha-Secure-Mail-Password");
				message.removeHeader("X-JMocha-Secure-Mail-ReadCount");
				message.removeHeader("X-JMocha-Secure-Mail-ReadDate");
				message.removeHeader("X-JMocha-Secure-Mail-ServerName");
				message.removeHeader("X-JMocha-Secure-Mail-PasswordHint");

				
				// timezone 처리 확인
				if (!secureReadDate.equals("")) {
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					secureReadDate = sdf.format(new Date(Long.parseLong(secureReadDate)));
					secureReadDate = commonUtil.getDateStringInUTC(secureReadDate, offset, true);
				}
				
				// securePassword 암호화
				securePassword = ezEmailService.encryptSecureValue(securePassword, useKlibEncrypt);
				
				// save secure mail info and get secureId
        		int secureId = ezEmailService.setMailSecure(tenantId, userId, securePassword, Integer.parseInt(secureReadCount), secureReadDate);
	        	
        		if (secureId == 0) {
	        		throw new Exception("INSERTSECUREMAILFAIL");
	        	}
				
        		MimeMessage secureMessage = sa.createMimeMessage();
        		
        		@SuppressWarnings("unchecked")
    			Enumeration<Header> headerEnum2 = message.getAllHeaders();
        		while (headerEnum2.hasMoreElements()) {
        			Header header = headerEnum2.nextElement();
        			secureMessage.setHeader(header.getName(), header.getValue());
        		}
				
        		MimeMultipart secureMixedPart = new MimeMultipart();
	        	
	        	// make secureBodyPart and add to secureMixedPart
	        	MimeBodyPart secureBodyPart = new MimeBodyPart();
	        	MimeMultipart secureBodyRelatedPart = new MimeMultipart("related");
	        	MimeBodyPart secureBodyHtmlPart = new MimeBodyPart();
	        	MimeBodyPart secureBodyImagePart = new MimeBodyPart();
	        	
	        	String tempFileName = UUID.randomUUID().toString();
	        	
	        	secureBodyHtmlPart.setContent(this.getSecureBodyHtml(tempFileName, locale), "text/html; charset=utf-8");
	        	
	        	secureBodyImagePart.setHeader("Content-Disposition", "inline;\r\n\tfilename=\"" + tempFileName + ".gif\"");
	        	secureBodyImagePart.setHeader("Content-ID", "<" + tempFileName + ".gif@12345678.87654321>");
	        	secureBodyImagePart.setHeader("Content-Type", "image/gif");
	        	FileDataSource source = new FileDataSource(new File(realPath + "/images/email/secureMail/security_img.gif"));
	        	secureBodyImagePart.setDataHandler(new DataHandler(source));
	        	
	        	secureBodyRelatedPart.addBodyPart(secureBodyHtmlPart);
	        	secureBodyRelatedPart.addBodyPart(secureBodyImagePart);
	        	
	        	secureBodyPart.setContent(secureBodyRelatedPart);
	        	secureMixedPart.addBodyPart(secureBodyPart);
	        	// make secureBodyPart and add to secureMixedPart - end
        		
	        	// make secureAttachPart and add to secureMixedPart
	        	MimeBodyPart secureAttachPart = new MimeBodyPart();
	        	secureAttachPart.setHeader("Content-Disposition", "attachment;\r\n\tfilename=\"secureMail.html\"");
	        	secureAttachPart.setHeader("Content-Type", "text/html");
	        	
	        	String useHttps = ezCommonService.getTenantConfig("USE_HTTPS", tenantId);
	        	logger.debug("useHttps=" + useHttps);
	        	
	        	String secureAttachHtml = this.getSecureAttachHtml(serverName, locale, useHttps);
	        	
	        	String secureMailKey = applicantEmail + "/" + secureId + "/" + applicantEmail;
				secureMailKey = ezEmailService.encryptSecureValue(secureMailKey, useKlibEncrypt);

				secureAttachHtml = secureAttachHtml.replace("${X-JMocha-Secure-Mail-Key}", secureMailKey);
				secureAttachHtml = secureAttachHtml.replace("${passwordHint}", securePasswordHint);

				secureAttachPart.setContent(secureAttachHtml, "text/html; charset=utf-8");
	        	secureAttachPart.setHeader("Content-Disposition", "attachment;\r\n\tfilename=\"secureMail.html\"");
	        	secureMixedPart.addBodyPart(secureAttachPart);
	        	// make secureAttachPart and add to secureMixedPart - end
	        	
	        	// make encryptedOriginalPart and add to secureMixedPart
	        	MimeBodyPart encryptedOriginalPart = new MimeBodyPart();
	        	
	        	String tempPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", tenantId) + commonUtil.separator + "tempFileUpload";
	        	
	        	File file = new File(tempPath);
	        	if (!file.exists()) {
	        		file.mkdirs();
	        	}
		        
	        	File originalFile = new File(tempPath + commonUtil.separator + UUID.randomUUID().toString());
	        	FileOutputStream fos = null;
	        	
	        	try {
	        		fos = new FileOutputStream(originalFile);
	        		message.writeTo(fos);
	        	} catch (Exception e) {
	        		logger.error(e.getMessage(), e);
	        	} finally {
					if (fos != null) {
						try { fos.close(); } catch (IOException e) {logger.debug("e.message=" + e.getMessage());}
					}
				}
	        	
	        	encryptedFile = new File(tempPath + commonUtil.separator + UUID.randomUUID().toString());

				if (!useKlibEncrypt) {
					egovFileScrty.cryptFile(Cipher.ENCRYPT_MODE, originalFile, encryptedFile);
				} else {
					byte[] bytes = commonUtil.readBytesFromFile(originalFile.toPath());
					commonUtil.writeBytesToFile(encryptedFile.toPath(),klibUtil.encrypt(bytes));
				}
	        	
	        	if (originalFile.delete()) {
	        		logger.debug("originalFile is deleted. fileName=" + originalFile.getName());
	        	}
	        	
	        	encryptedOriginalPart.setHeader("Content-Disposition", "attachment;\r\n\tfilename=\"originalMail.eml\"");
	        	encryptedOriginalPart.setHeader("Content-Type", "message/rfc822");
	        	source = new FileDataSource(encryptedFile);
	        	encryptedOriginalPart.setDataHandler(new DataHandler(source));
	        	secureMixedPart.addBodyPart(encryptedOriginalPart);
	        	// make encryptedOriginalPart and add to secureMixedPart - end
	        	
	        	secureMessage.setContent(secureMixedPart);
	        	
	        	this.setSecureMailFlag(secureMessage, true);
	        	secureMessage.setFlag(Flags.Flag.SEEN, true);
                
				// 신청자의 보낸편지함 폴더에 저장
	        	if (applicantExist) {
	        		IMAPFolder movefolder = (IMAPFolder)ia.getFolder(getSentFolderId(locale));

					message.setFlag(Flags.Flag.SEEN, true);
					movefolder.open(Folder.READ_WRITE);		
					
					AppendUID[] uids = ((IMAPFolder)movefolder).appendUIDMessages(new Message[]{secureMessage});
	                long sentFolderMessageUID = 0;
	                if (uids != null && uids[0] != null) {
	                    sentFolderMessageUID = uids[0].uid;
	                }
		            movefolder.close(true);
					logger.debug("Succeed in saving a message in sent folder.");
					
					// 보낸편지함에 저장한 메일의 uid를 저장한다.
					String result = ezEmailService.updateMailSecure(tenantId, userId, secureId, movefolder.getFullName() + "/" + sentFolderMessageUID);
		        	
		        	if (!result.equals("OK")) {
		        		throw new Exception("UPDATESECUREMAILFAIL");
		        	}
				}
	            
	        	// 메일을 발송할 때에는 보낸사람의 secureMailKey를 다시 ${X-JMocha-Secure-Mail-Key}로 되돌려놓는다.
	        	secureMixedPart.removeBodyPart(secureAttachPart);
	        	secureAttachPart.setContent(secureAttachHtml, "text/html; charset=utf-8");
	        	secureMixedPart.addBodyPart(secureAttachPart);
	        	
	        	// 메일을 발송할 때에는 원본메일을 삭제한다.
	            secureMixedPart.removeBodyPart(encryptedOriginalPart);
	            
	            // 서버에서 보안메일을 처리할 수 있도록 헤더를 추가한다.
	            secureMessage.setHeader("X-JMocha-Secure-Mail-ID", String.valueOf(secureId));
	            
	            message = secureMessage;
			} else {
	    		// 메일 본문
				//message.setContent((Multipart) orgMessage.getContent());
				if (applicantExist) {
					// 신청자의 보낸편지함 폴더
					IMAPFolder movefolder = (IMAPFolder)ia.getFolder(getSentFolderId(locale));
					
					// 신청자의 보낸편지함으로 이동	
					message.setFlag(Flags.Flag.SEEN, true);
					movefolder.open(Folder.READ_WRITE);		
					movefolder.appendUIDMessages(new Message[]{message});
		            movefolder.close(true);
					logger.debug("Succeed in saving a message in sent folder.");
				}
			}

			List<String> invalidAddressList = new ArrayList<>();
			// 개별발신
			if (eachMailHeader != null) {
				logger.debug("sending each recipient mail");

            	Address[] allRecipients = message.getAllRecipients();
            	
            	message.removeHeader("TO");
        		message.removeHeader("CC");
        		message.removeHeader("BCC");
        		
        		String useAdvancedEachMail = ezCommonService.getTenantConfig("useAdvancedEachMail", tenantId);
        		if (useAdvancedEachMail.equals("YES")) {		
    				try {
    					message.setRecipients(RecipientType.TO, allRecipients);
        				
        				message.setHeader("X-JMocha-Each-Mail", "true");
        				Transport.send(message);
					} catch (Exception e1) {
						logger.error(e1.getMessage(), e1);
        				String errorMessage = e1.getMessage();
        				logger.debug("remove Invalid address. and retry");
        				
        				if (errorMessage.contains("Invalid Addresses")) {
        					String cause = e1.getCause().toString();
        					findInvalidAddresses(cause, invalidAddressList);

        					List<Address> allRecipientList = new ArrayList<Address>();
        					for( int x = 0; x < allRecipients.length; x++){
        						String recipient = allRecipients[x].toString();
        						String temp2 = recipient.substring(recipient.lastIndexOf(" <")+2, recipient.length()-1);
        						
        						if (invalidAddressList.contains(temp2)){
        							continue;
        						} else {
        							allRecipientList.add(allRecipients[x]);
        						}
        					}
        					
        					Address[] newRecipients = allRecipientList.stream().toArray(Address[]::new);							
        					message.setRecipients(RecipientType.TO, newRecipients);
        					logger.debug("validAddressList=" + allRecipientList.toString());
							logger.debug("invalidAddressList=" + invalidAddressList);
							message.setHeader("X-JMocha-Each-Mail", "true");
							Transport.send(message);
        				} else {
        					throw e1;	 // 예외를 발생시킴
        				}
					}
				} else {
	            	for (Address a : allRecipients) {
	            		logger.debug("address={}", a);
	            		
	            		try {
		            		message.setRecipient(RecipientType.TO, a);
	            			Transport.send(message);
	        			} catch (Exception e) {
	        				logger.error(e.getMessage(), e);
	        				String errorMessage = e.getMessage();
	        				
	        				if (errorMessage.contains("Invalid Addresses")) {
	        					String cause = e.getCause().toString();		
	        					
	        					findInvalidAddresses(cause, invalidAddressList);
	        				}
	        			} 						
					}
				}
			} else {
				try {
					Transport.send(message);
				} catch (Exception e) {
    				if (e.getMessage().contains("Invalid Addresses")) {
    					String cause = e.getCause().toString();					
    					findInvalidAddresses(cause, invalidAddressList);
    					logger.debug("invalidAddressList={}", invalidAddressList);
    					
						Address[] recipients = message.getRecipients(RecipientType.TO);
						List<Address> newRecipientList = new ArrayList<>();

						if (recipients != null) {
							for (Address item : recipients) {
								InternetAddress recipient = (InternetAddress)item;
								if (!invalidAddressList.contains(recipient.getAddress())) {
									newRecipientList.add(recipient);
								}
							}
							
							Address[] newRecipients = newRecipientList.stream().toArray(Address[]::new);							
							message.setRecipients(RecipientType.TO, newRecipients);
							
							logger.debug("Retrying... newRecipientList TO={}", newRecipientList);
						}
						
						recipients = message.getRecipients(RecipientType.CC);
						newRecipientList.clear();

						if (recipients != null) {
							for (Address item : recipients) {
								InternetAddress recipient = (InternetAddress)item;
								if (!invalidAddressList.contains(recipient.getAddress())) {
									newRecipientList.add(recipient);
								}
							}

							Address[] newRecipients = newRecipientList.stream().toArray(Address[]::new);							
							message.setRecipients(RecipientType.CC, newRecipients);

							logger.debug("Retrying... newRecipientList CC={}", newRecipientList);
						}

						recipients = message.getRecipients(RecipientType.BCC);
						newRecipientList.clear();

						if (recipients != null) {
							for (Address item : recipients) {
								InternetAddress recipient = (InternetAddress)item;
								if (!invalidAddressList.contains(recipient.getAddress())) {
									newRecipientList.add(recipient);
								}
							}

							Address[] newRecipients = newRecipientList.stream().toArray(Address[]::new);							
							message.setRecipients(RecipientType.BCC, newRecipients);

							logger.debug("Retrying... newRecipientList BCC={}", newRecipientList);
						}
						
						invalidAddressList.clear();
						
		            	Address[] allRecipients = message.getAllRecipients();
		            	if (allRecipients != null) {	
							Transport.send(message);
		            	} else {
							logger.debug("No recipient addresses...");
		            	}
					} else {
						throw new Exception();
					}
				}
			}
			
			// 승인메일 공유사서함에 저장되어있는 메일 삭제
			if (delFlag) {
				sourceFolder.setFlags(new Message[]{orgMessage}, new Flags(Flags.Flag.DELETED), true);
				sourceFolder.close(true);
			}
		} catch (Exception e) {
			throw e;
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		return resultInt;
	}

	private void findInvalidAddresses(String cause, List<String> invalidAddressList) {
		String pattern = "Unknown user: ([\\S]+)";
		Pattern r = Pattern.compile(pattern);
		Matcher m = r.matcher(cause);
		
		int index = 1000;
		while (m.find()) {
			// 1000번 이상 반복되면 break한다.
			--index;
			if (index < 0) {
				logger.error("Stop finding invalid addresses, because over 1000 times.");
				break;
			}
			
			invalidAddressList.add(m.group(1));
		}		
	}
	
	/**
	 * 승인메일 : 사용자가 메일환경에서 설정한 리스트 개수
	 */
	public int getListCount(int tenantId, String userId) throws Exception {
		
		MailGeneralVO mailGeneral = ezEmailService.getMailGeneral(tenantId, userId).get(0);
		int listCount = Integer.parseInt(mailGeneral.getListCount());
		
		return listCount;
	}
	
	/**
	 * 승인메일 : 정책 사용여부가 설정인지 아닌지 확인용
	 */
	public boolean useApprMailPolicy(int tenantId, String companyId) throws Exception {
		String useApprMailAllHands 	= ezCommonService.getCompanyConfig(tenantId, companyId, "useApprMailAllHands").toUpperCase(); // 전사메일 (USAGE|UNUSED)
		String useApprMailOut 		= ezCommonService.getCompanyConfig(tenantId, companyId, "useApprMailOut").toUpperCase(); // 외부로 발송되는 메일 (USAGE|USAGE_ATTACH|UNUSED)
		String useApprMailIn 		= ezCommonService.getCompanyConfig(tenantId, companyId, "useApprMailIn").toUpperCase(); // 내부로 발송되는 메일 (USAGE|USAGE_ATTACH|UNUSED)
		
		return (useApprMailAllHands.contains("USAGE") || useApprMailOut.contains("USAGE") || useApprMailIn.contains("USAGE"));
	}

	/**
	 * 승인메일 : 승인메일 공유사서함 존재여부 확인 및 생성, 공유사서함 아이디 리턴
	 */
	public String getApprSharedMailBox(int tenantId, Locale locale) throws Exception {
		String pw = commonUtil.getMailPassword();
		return getApprSharedMailBox(tenantId, locale, pw);
	}
	public String getApprSharedMailBox(int tenantId, Locale locale, String pw) throws Exception {
		// 나중에 컨피그화 처리
		String apprCompanyId = "Top";
		String apprSharedMailBoxDefaultID = "__approved_mail";
		String oriPass = "123qwe!@#";
		
		int cnt = ezOrganAdminService.userCheck(apprSharedMailBoxDefaultID, tenantId);
		logger.debug("getApprSharedMailBox cnt={}", cnt);
		
		if (cnt < 1) {
			String domain = ezCommonService.getTenantConfig("DomainName", tenantId);

			String deptId = "shared_mailbox_" + apprCompanyId;
			OrganDeptVO deptVO = ezOrganService.getDeptInfo(deptId, "1", tenantId);
			
			if (deptVO == null) { // 공유사서함 부서가 없으면 생성
				String deptName = egovMessageSource.getMessage("ezEmail.sharedMailbox02", locale);
				String mailAddr = deptId + "@" + domain;
				
				int rc = ezEmailUserAdminService.addGroup(mailAddr);
				
				if (rc == 0) { // addGroup 성공
					try {
						OrganDeptVO vo = new OrganDeptVO();
						vo.setTenantId(tenantId);
						vo.setCn(deptId);
						vo.setDisplayName(deptName);
						// 우선은 공유사서함 부서를 회사 하위에 생성한다. 
						vo.setParentCn(apprCompanyId);
						// 인사연동 시 공유사서함 부서를 폐지시키지 않기 위해 manualFlag를 Y로 설정한다.
						vo.setManualFlag("Y");
						vo.setMail(mailAddr);
						
						ezOrganAdminService.insertDBData_dept(vo);
						
						// 조직도에 나타나게 하지 않기 위해 상위부서 정보를 없앤다.
						ezOrganAdminService.updateProperty(deptId, "EXTENSIONATTRIBUTE1", "", "dept", tenantId);
						ezOrganAdminService.updateProperty(deptId, "DEPTLEVEL", "2", "dept", tenantId);
						ezOrganAdminService.updateProperty(deptId, "DEPT_CD_PATH", deptId, "dept", tenantId);
					} catch (Exception e) {
						logger.error(e.getMessage(), e);
						
						ezEmailUserAdminService.removeGroup(mailAddr);	
						logger.debug("apprmail... create sharedMailbox dept failed.");
						return "APPR_ERROR";
					}
				} else {
					logger.debug("apprmail... create sharedMailbox dept failed.");
					return "APPR_ERROR";
				}
			}
				
			String mailAddr = apprSharedMailBoxDefaultID + "@" + domain;
				
			// 이메일 시스템에 계정을 생성한다.
			int rc = ezEmailUserAdminService.addUser(mailAddr, oriPass);
			logger.debug("addUser rc={}", rc);
			
			if (rc == 0) { // addUser 성공
				// 해당 User가 속한 부서의 Group Email 주소에 User를 등록한다.
				String groupAddr = deptId + "@" + domain;
				rc = ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
				logger.debug("updateGroupAdd rc={}", rc);
					
				if (rc == 0) { // updateGroup 성공
					try {
						OrganUserVO vo = new OrganUserVO();
						
						vo.setTenantId(tenantId);
						vo.setCn(apprSharedMailBoxDefaultID);
						vo.setDisplayName("승인메일");
						vo.setParentCn(deptId);
						vo.setMail(mailAddr);
							
						// 인사연동 시 공유사서함 계정을 퇴직처리 시키지 않기 위해 manualFlag를 Y로 설정한다.
						vo.setManualFlag("Y");
						
						String userPrincipalName = apprSharedMailBoxDefaultID + "@" + domain;
						vo.setUpnName(userPrincipalName);
							
						String pass = EgovFileScrty.encryptPassword(oriPass, apprSharedMailBoxDefaultID);
						vo.setPassword(pass);
						
						String useStandardFolderId = config.getProperty("config.useStandardFolderId");
						if (useStandardFolderId != null && useStandardFolderId.equals("YES")) {					
							IMAPAccess ia = null;
							
							try {
								ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
										mailAddr, pw, egovMessageSource, locale, this);
								
								// 기본 폴더들이 없을 때 생성한다.
								ia.getTopLevelFolders(true, false);			
							} finally {
								if (ia != null) {
									ia.close();
									ia = null;
								}
							}
						}
							
						// 로컬 시스템에 해당 User의 계정을 생성한다.
						ezOrganAdminService.insertDBData_user(vo, oriPass);
						
						// 승인메일 공유사서함은 용량 10테라로 설정
						setUserQuota(mailAddr, "10240000", "10240000");
					} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
						logger.error(e.getMessage(), e);
						
						ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
						ezEmailUserAdminService.removeUser(mailAddr);
						logger.debug("appr... create sharedMailbox failed.");
						return "APPR_ERROR";
					}
				} else {
					// 부서의 Group Email 주소로의 등록에 실패하면 해당 User를 삭제하고 에러를 반환한다.
					ezEmailUserAdminService.removeUser(mailAddr);
					logger.debug("appr... create sharedMailbox failed. updateGroupAdd failed.");
					return "APPR_ERROR";
				}
			}
		}

		return apprSharedMailBoxDefaultID;
	}
	
	/**
	 * 승인메일 : 로그 엑셀 내려받기
	 */
	public void apprLogExcelExport(HSSFWorkbook workbook, Locale locale, String sheet1Name, String sheet2Name, List<Map<String, String>> logList, List<Map<String, String>> userCntList) throws Exception {
		/*
		 * style
		 */
		HSSFCellStyle headerStyle = workbook.createCellStyle();
		headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		headerStyle.setVerticalAlignment((short) 1);
		
		HSSFCellStyle bodyStyle = workbook.createCellStyle();
		bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		
		// 첫번째 시트 : 로그리스트
		HSSFSheet sheet = workbook.createSheet(sheet1Name);
		Row row = null;
		Cell cell = null;
		
		/*
		 * header
		 * 구분 | 제목 | 부서 | 작성자명 | 작성자주소 | 작성일시 | 승인자명 | 승인일시
		 */
		row = sheet.createRow(0);
		
		cell = row.createCell(0); // 구분
		cell.setCellValue(egovMessageSource.getMessage("email.appr.excel.head.gubun", locale));
		cell.setCellStyle(headerStyle);
		cell = row.createCell(1); // 제목
		cell.setCellValue(egovMessageSource.getMessage("email.appr.excel.head.subject", locale));
		cell.setCellStyle(headerStyle);
		cell = row.createCell(2); // 부서
		cell.setCellValue(egovMessageSource.getMessage("email.appr.excel.head.deptname", locale));
		cell.setCellStyle(headerStyle);
		cell = row.createCell(3); // 작성자명
		cell.setCellValue(egovMessageSource.getMessage("email.appr.excel.head.username", locale));
		cell.setCellStyle(headerStyle);
		cell = row.createCell(4); // 작성자주소
		cell.setCellValue(egovMessageSource.getMessage("email.appr.excel.head.senderemail", locale));
		cell.setCellStyle(headerStyle);
		cell = row.createCell(5); // 작성일시
		cell.setCellValue(egovMessageSource.getMessage("email.appr.excel.head.writedate", locale));
		cell.setCellStyle(headerStyle);
		cell = row.createCell(6); // 승인자명
		cell.setCellValue(egovMessageSource.getMessage("email.appr.excel.head.approvername", locale));
		cell.setCellStyle(headerStyle);
		cell = row.createCell(7); // 승인일시
		cell.setCellValue(egovMessageSource.getMessage("email.appr.excel.head.approverdate", locale));
		cell.setCellStyle(headerStyle);
		
		/*
		 * body
		 */
		int rowNum = 1;
		for (Map<String, String> m : logList) {
			String gubun			= "";
			String state 			= m.get("state");
			String subject 			= m.get("subject");
			String writerDeptName 	= m.get("userDeptName");
			String writerName 		= m.get("userName");
			String writerEmail 		= m.get("senderEmail");
			String writeDate 		= m.get("writeDate");
			String approvalName 	= m.get("approverName");
			String approvalDate 	= m.get("updateDt");
			
			switch(state) {
				case "approved" : 	gubun = egovMessageSource.getMessage("email.appr.status.approved", locale); break;
				case "rejected" : 	gubun = egovMessageSource.getMessage("email.appr.status.rejected", locale); break;
				case "deleted" : 	gubun = egovMessageSource.getMessage("email.appr.status.deleted", locale); break;
				default : 			gubun = state;
			}
			
			row = sheet.createRow(rowNum);
			
			cell = row.createCell(0); // 구분
			cell.setCellValue(gubun);
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(1); // 제목
			cell.setCellValue(subject);
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(2); // 부서
			cell.setCellValue(writerDeptName);
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(3); //작성자명
			cell.setCellValue(writerName);
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(4); // 작성자주소
			cell.setCellValue(writerEmail);
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(5); // 작성일시
			cell.setCellValue(writeDate);
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(6); // 승인자명
			cell.setCellValue(approvalName);
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(7); // 승인일시
			cell.setCellValue(approvalDate);
			cell.setCellStyle(bodyStyle);
			
			rowNum++;
		}

		// 두번째 시트 사용자 데이터 개수
		HSSFSheet sheet2 = workbook.createSheet(sheet2Name);
		
		/*
		 * header
		 * 작성자명 | 작성자주소 | 합계
		 */
		row = sheet2.createRow(0);
		
		cell = row.createCell(0); // 작성자명
		cell.setCellValue(egovMessageSource.getMessage("email.appr.excel.head.username", locale));
		cell.setCellStyle(headerStyle);
		cell = row.createCell(1); // 작성자주소
		cell.setCellValue(egovMessageSource.getMessage("email.appr.excel.head.senderemail", locale));
		cell.setCellStyle(headerStyle);
		cell = row.createCell(2); // 합계
		cell.setCellValue(egovMessageSource.getMessage("email.appr.excel.head.totalcount", locale));
		cell.setCellStyle(headerStyle);
		
		/*
		 * body
		 */
		int rowNum2 = 1;
		for (Map<String, String> m : userCntList) {
			String writerEmail 		= m.get("senderEmail");
			String writerName 		= m.get("userName");
			String userCnt		 	= m.get("userCnt");
			
			row = sheet2.createRow(rowNum2);
			
			cell = row.createCell(0); // 작성자명
			cell.setCellValue(writerName); 
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(1); // 작성자주소
			cell.setCellValue(writerEmail);
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(2); // 합계
			cell.setCellValue(userCnt);
			cell.setCellStyle(bodyStyle);
			
			rowNum2++;
		}
	}

	/**
	 *  사용자가 메일 태그를 사용하는지 확인
	 * @param tenantId
	 * @param userEmail
	 * @return
	 * @throws Exception
	 */
	public boolean checkUseMailTag(int tenantId,String userEmail) throws Exception {

		// 메일 태그를 사용중인지 확인
		boolean result = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useMailTag", tenantId));
		
		// 메일 태그를 사용한다면 사용자가 기능을 활성화 했는지 확인
		if (result) {
			try {
				logger.debug("jgw getTagConfig started.");

				JgwResult jgwResult = rest.jgw().url("/jMochaEzEmail/getTagConfig").formParam("userAccount", userEmail).exchangeJgwResult();
				logger.debug("jgw getTagConfig ended, success={}", jgwResult.succeeded());

				result &= jgwResult.succeeded() && jgwResult.getResultAsJsonObject().get("enable").getAsBoolean();
			} catch (RuntimeException e) {
				logger.error("jgw fetch error", e);
				result = false;
			} catch (Exception e) {
				logger.error("jgw fetch error", e);
				result = false;
			}
		}
		
		return result;
	}
	
	public String[] getTagList(String userEmail, String folderId, long uid) throws Exception {
		String[] tags = null;
		
		JgwResult tagResult = rest.jgw().url("/jMochaEzEmail/getTagList")
				.formParam("userAccount", userEmail)
				.formParam("folderPath", folderId)
				.formParam("mailUid", uid)
				.exchangeJgwResult();
		logger.debug("jgw getTagList result: {}", tagResult);

		if (tagResult.succeeded()) {
			Spliterator<JsonElement> tagIterator = tagResult.getResultAsJsonElement().getAsJsonArray().spliterator();

			tags = StreamSupport.stream(tagIterator, false)
					.map(jsonElement -> jsonElement.getAsJsonObject().get("name").getAsString())
                    .toArray(String[]::new);
		} else {
			tags = new String[0];
		}
		
		return tags;
	}

	public int createTag(String userAccount, String tagName) {
		try {
			JgwResult result = rest.jgw().url("/jMochaEzEmail/getTagIdx")
					.formParam("userAccount", userAccount)
					.formParam("tagName", tagName)
					.formParam("isAutoGenerate", true)
					.exchangeJgwResult();
			logger.debug("jgw getTagIdx result: {}", result);

			if (result.succeeded()) {
				return result.getResult(Integer.class);
			}

			throw new IllegalStateException("getTagIdx failed");
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
}

