package egovframework.ezEKP.ezEmail.logic;

import java.io.Closeable;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.text.Collator;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Properties;
import java.util.Set;

import javax.mail.Address;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.NoSuchProviderException;
import javax.mail.Part;
import javax.mail.Quota;
import javax.mail.Session;
import javax.mail.Store;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimePart;
import javax.mail.internet.MimeUtility;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.sun.mail.imap.IMAPFolder;
import com.sun.mail.imap.IMAPStore;
import com.sun.mail.util.MailSSLSocketFactory;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;

public class IMAPAccess implements Closeable {

    private static final Logger logger = LoggerFactory.getLogger(IMAPAccess.class);
    
    private EzEmailUtil ezEmailUtil;
    
	private String host;
	private String port;
	private Store store;
	private String userName;
	private String password;
	@SuppressWarnings("unused")
	private EgovMessageSource egovMessageSource;
	private Locale locale;
	// 간혹 SocketTimeoutException이 발생하는 경우가 있어 시간을 짧게 설정하고 retry를 수행하도록 함.
	// James 서버의 netty 버전을 3.10.6.Final로 올린 이후로는 SocketTimeoutException이 발생하지 않는 것으로 보임.
	// 청와대에서 용량이 큰 메일을 다수 삭제할 경우 타임아웃이 발생하여 10초에서 120초로 변경함 
	private int timeout = 120000; 
	private int connectionTimeout = 20000; 
	// 승인메일
	private Store apprStore; // 승인메일 store
	private String apprUserName; // 승인메일 공유사서함
	
	private static final String DEFAULT_FOLDER_NAMES 
		= "INBOX,보낸 편지함,임시 보관함,지운 편지함,개인 편지함,정크 메일" // 한국어
		+ ",Sent Items,Drafts,Trash,Personal folder,Junk Email,Sent" // 영어
		+ ",送信済み,下書き,ゴミ箱,パーソナル,迷惑メール" // 일본어
		+ ",Kotak Keluar,Konsep,Sampah,Folder Personal,Email Junk"; // 인도네시아어
	private static final Set<String> DEFAULT_FOLDER_NAME_SET = new HashSet<>(Arrays.asList(DEFAULT_FOLDER_NAMES.split(",")));
	
	private IMAPAccess(String host, String port, String userName, String password, EgovMessageSource egovMessageSource, 
						Locale locale, EzEmailUtil ezEmailUtil) {
		this.host = host;
		this.port = port;
		this.userName = userName;
		this.password = password;
		this.egovMessageSource = egovMessageSource;
		this.locale = locale;
		this.ezEmailUtil = ezEmailUtil;
	}
	
	private IMAPAccess(String host, String port, String userName, String password, EgovMessageSource egovMessageSource, 
						Locale locale, EzEmailUtil ezEmailUtil, String apprUserName) {
		this.host = host;
		this.port = port;
		this.userName = userName;
		this.password = password;
		this.egovMessageSource = egovMessageSource;
		this.locale = locale;
		this.ezEmailUtil = ezEmailUtil;
		this.apprUserName = apprUserName;
	}
	
	private IMAPAccess(String host, String port, String userName, String password, EgovMessageSource egovMessageSource, 
						Locale locale, int timeout, int connectionTimeout, EzEmailUtil ezEmailUtil) {
		this.host = host;
		this.port = port;
		this.userName = userName;
		this.password = password;
		this.egovMessageSource = egovMessageSource;
		this.locale = locale;
		this.timeout = timeout;
		this.connectionTimeout = connectionTimeout;
		this.ezEmailUtil = ezEmailUtil;
	}
	
	private Store getStore() {
		if (store != null) {
			return store;
		}
		
		try {
			Properties properties = new Properties();
			properties.put("mail.imap.host", host);
			properties.put("mail.imaps.host", host);
			properties.put("mail.imap.port", port);
			properties.put("mail.imaps.port", port);
			
			if (port.equals("993")) {
    			MailSSLSocketFactory sf = new MailSSLSocketFactory();
    			sf.setTrustAllHosts(true); 
    			properties.put("mail.imaps.ssl.trust", "*");
    			properties.put("mail.imaps.ssl.socketFactory", sf);
			}
			
			//If set to true, failure to create a socket using the specified socket factory class will 
			//cause the socket to be created using the java.net.Socket class. Defaults to true.
			properties.setProperty("mail.imap.socketFactory.fallback", "false");
			properties.setProperty("mail.imaps.socketFactory.fallback", "false");
			properties.setProperty("mail.imap.socketFactory.port", port);
			properties.setProperty("mail.imaps.socketFactory.port", port);
			
			// these properties are required to be set to false, otherwise
			// big mail body part(in-line image, attachment, etc) fetching may be very slow.
			properties.setProperty("mail.imap.partialfetch", "false");
			properties.setProperty("mail.imaps.partialfetch", "false");
			
			properties.put("mail.imap.connectiontimeout", connectionTimeout);
			properties.put("mail.imaps.connectiontimeout", connectionTimeout);
			properties.put("mail.imap.timeout", timeout);
			properties.put("mail.imaps.timeout", timeout);			
			
			Session session = Session.getInstance(properties);

			// IMAPS의 Well-Known Port인 993일 때는 imaps를 사용한다.
			if (port.equals("993")) {
			    store = session.getStore("imaps");
			} else {
			    store = session.getStore("imap");
			}
			
			store.connect(userName, password);
		} catch (NoSuchProviderException e) {
			logger.error("Error get store from session: " + e.getMessage());
			logger.error(e.getMessage(), e);
		} catch (MessagingException e) {
			logger.error("Error connect store: " + e.getMessage());
		} catch (GeneralSecurityException e) {
		    logger.error("GeneralSecurityException: " + e.getMessage());
            logger.error(e.getMessage(), e);
        }
		
		// 2023-05-16 이사라 : NullPointerException 시큐어코딩
		if (Objects.isNull(store)) {
			throw new NullPointerException("getStore store is null, but it isn't ready");
		}

		return store;
	}
	
	// 승인메일 공유사서함 연결
	private Store getApprStore() {
		if (apprStore != null) {
			return apprStore;
		}
		
		try {
			Properties properties = new Properties();
			properties.put("mail.imap.host", host);
			properties.put("mail.imaps.host", host);
			properties.put("mail.imap.port", port);
			properties.put("mail.imaps.port", port);
			
			if (port.equals("993")) {
    			MailSSLSocketFactory sf = new MailSSLSocketFactory();
    			sf.setTrustAllHosts(true); 
    			properties.put("mail.imaps.ssl.trust", "*");
    			properties.put("mail.imaps.ssl.socketFactory", sf);
			}
			
			//If set to true, failure to create a socket using the specified socket factory class will 
			//cause the socket to be created using the java.net.Socket class. Defaults to true.
			properties.setProperty("mail.imap.socketFactory.fallback", "false");
			properties.setProperty("mail.imaps.socketFactory.fallback", "false");
			properties.setProperty("mail.imap.socketFactory.port", port);
			properties.setProperty("mail.imaps.socketFactory.port", port);
			
			// these properties are required to be set to false, otherwise
			// big mail body part(in-line image, attachment, etc) fetching may be very slow.
			properties.setProperty("mail.imap.partialfetch", "false");
			properties.setProperty("mail.imaps.partialfetch", "false");
			
			properties.put("mail.imap.connectiontimeout", connectionTimeout);
			properties.put("mail.imaps.connectiontimeout", connectionTimeout);
			properties.put("mail.imap.timeout", timeout);
			properties.put("mail.imaps.timeout", timeout);			
			
			Session session = Session.getInstance(properties);

			// IMAPS의 Well-Known Port인 993일 때는 imaps를 사용한다.
			if (port.equals("993")) {
				apprStore = session.getStore("imaps");
			} else {
				apprStore = session.getStore("imap");
			}
			
			apprStore.connect(apprUserName, password);
		} catch (NoSuchProviderException e) {
			logger.error("Error get store from session: " + e.getMessage());
			logger.error(e.getMessage(), e);
		} catch (MessagingException e) {
			logger.error("Error connect store: " + e.getMessage());
		} catch (GeneralSecurityException e) {
		    logger.error("GeneralSecurityException: " + e.getMessage());
            logger.error(e.getMessage(), e);
        }
		
		// 2023-05-16 이사라 : NullPointerException 시큐어코딩
		if (Objects.isNull(apprStore)) {
			throw new NullPointerException("getApprStore apprStore is null, but it isn't ready");
		}

		return apprStore;
	}

	@Override
	public void close() {
		try {
			if(store != null){
				store.close();
				store = null;
			}
			if (apprStore != null) {
				apprStore.close();
				apprStore = null;
			}
		} catch (MessagingException e) {
			logger.error("Error close store: " + e.getMessage());
		}
	}
	
	public void makeTopLevelFolders() {
		logger.debug("makeTopLevelFolders started.");
		
		try {
			Folder rootFolder = getStore().getDefaultFolder();
			
			Folder inbox = rootFolder.getFolder(ezEmailUtil.getInboxFolderId());
			Folder sent = rootFolder.getFolder(ezEmailUtil.getSentFolderId(locale));
			Folder draft = rootFolder.getFolder(ezEmailUtil.getDraftsFolderId(locale));
			Folder trash = rootFolder.getFolder(ezEmailUtil.getTrashFolderId(locale));
			Folder personal = rootFolder.getFolder(ezEmailUtil.getPersonalFolderId(locale));
			Folder junk = rootFolder.getFolder(ezEmailUtil.getJunkFolderId(locale));
			
			// if default folders do not exist, create the folders.
			if (!inbox.exists()) {
				createFolder(inbox.getFullName());
			}
			if (!sent.exists()) {
				createFolder(sent.getFullName());
			}
			if (!draft.exists()) {
				createFolder(draft.getFullName());
			}
			if (!trash.exists()) {
				createFolder(trash.getFullName());
			}
			if (!personal.exists()) {
				createFolder(personal.getFullName());
			}
			if (!junk.exists()) {
				createFolder(junk.getFullName());
			}
			
		} catch(MessagingException e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("makeTopLevelFolders ended.");
	}
	
	public List<String> getAllTopLevelFolderNames() {
		List<String> topLevelFolderNames = new ArrayList<>();
				
		try {
			Folder rootFolder = getStore().getDefaultFolder();
			Folder[] folderList = rootFolder.list();
			
			for (Folder folder : folderList) {
				String folderName = folder.getName();
				
				topLevelFolderNames.add(folderName);
			}			
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		}
		
		return topLevelFolderNames;
	}
	
	public List<Folder> getTopLevelFolders(boolean isSubscribe, boolean isUseDefaultFoldersForLangOnly) {
		ArrayList<Folder> topLevelFolders = new ArrayList<Folder>();
		
		try {
			Folder rootFolder = getStore().getDefaultFolder();
			
			if (rootFolder.listSubscribed().length == 0) {
				setReculsiveSubscribe(rootFolder, true);
			}
			
			Folder inbox = rootFolder.getFolder(ezEmailUtil.getInboxFolderId());
			Folder sent = rootFolder.getFolder(ezEmailUtil.getSentFolderId(locale));
			Folder draft = rootFolder.getFolder(ezEmailUtil.getDraftsFolderId(locale));
			Folder trash = rootFolder.getFolder(ezEmailUtil.getTrashFolderId(locale));
			Folder personal = rootFolder.getFolder(ezEmailUtil.getPersonalFolderId(locale));
			Folder junk = rootFolder.getFolder(ezEmailUtil.getJunkFolderId(locale));
			
			// if default folders do not exist, create the folders.
			if (!inbox.exists()) {
				createFolder(inbox.getFullName());
			}
			
			if (!sent.exists()) {
				createFolder(sent.getFullName());
			}
			
			if (!draft.exists()) {
				createFolder(draft.getFullName());
			}
			
			if (!trash.exists()) {
				createFolder(trash.getFullName());
			}
			
			if (!personal.exists()) {
				createFolder(personal.getFullName());
			}
			
			if (!junk.exists()) {
				createFolder(junk.getFullName());
			}
			
			Folder[] folderList = null;
			
			if (isSubscribe) {
				//add subscribe folders and inbox folder into top-level folder list
				topLevelFolders.add(inbox);
				
				if (sent.isSubscribed() || sent.listSubscribed().length > 0) {
					topLevelFolders.add(sent);
				}
				
				if (draft.isSubscribed() || draft.listSubscribed().length > 0) {
					topLevelFolders.add(draft);
				}
				
				if (trash.isSubscribed() || trash.listSubscribed().length > 0) {
					topLevelFolders.add(trash);
				}
				
				if (personal.isSubscribed() || personal.listSubscribed().length > 0) {
					topLevelFolders.add(personal);
				}
				
				if (junk.isSubscribed() || junk.listSubscribed().length > 0) {
					topLevelFolders.add(junk);
				}
				
				folderList = rootFolder.listSubscribed();
				
				Arrays.sort(folderList, new Comparator<Folder>(){
					@Override
					public int compare(Folder f1, Folder f2) {
						return f1.getFullName().compareTo(f2.getFullName());
					}
				});
				
				//add the other folders into top-level folder list
				for (Folder folder : folderList) {
					if (folder.exists()) {
						String folderName = folder.getName();
						
						// 어떤 원인에 의해 편지함명이 empty string인 레코드가 james_subscription 테이블에 
						// 생성되는 경우가 발생해 empty string이 아닌 경우만 처리하도록 수정함.
						if (!folderName.isEmpty()) {
							if (!isUseDefaultFoldersForLangOnly) {
								if (!folderName.equalsIgnoreCase(ezEmailUtil.getInboxFolderId())
										&& !folderName.equalsIgnoreCase(ezEmailUtil.getSentFolderId(locale))
										&& !folderName.equalsIgnoreCase(ezEmailUtil.getDraftsFolderId(locale))
										&& !folderName.equalsIgnoreCase(ezEmailUtil.getTrashFolderId(locale))
										&& !folderName.equalsIgnoreCase(ezEmailUtil.getPersonalFolderId(locale))
										&& !folderName.equalsIgnoreCase(ezEmailUtil.getJunkFolderId(locale))
										) {
									topLevelFolders.add(folder);
								}
							} else {						
								if (!DEFAULT_FOLDER_NAME_SET.contains(folderName)) {
									topLevelFolders.add(folder);
								}
							}
						}
					} else {
						folder.setSubscribed(false);
					}
				}
				
			} else {
				//add default folders into top-level folder list
				topLevelFolders.add(inbox);
				topLevelFolders.add(sent);
				topLevelFolders.add(draft);
				topLevelFolders.add(trash);
				topLevelFolders.add(personal);
				topLevelFolders.add(junk);
				
				folderList = rootFolder.list();
				
				//add the other folders into top-level folder list
				for (Folder folder : folderList) {
					String folderName = folder.getName();
					
					if (!isUseDefaultFoldersForLangOnly) {
						if (!folderName.equalsIgnoreCase(ezEmailUtil.getInboxFolderId())
								&& !folderName.equalsIgnoreCase(ezEmailUtil.getSentFolderId(locale))
								&& !folderName.equalsIgnoreCase(ezEmailUtil.getDraftsFolderId(locale))
								&& !folderName.equalsIgnoreCase(ezEmailUtil.getTrashFolderId(locale))
								&& !folderName.equalsIgnoreCase(ezEmailUtil.getPersonalFolderId(locale))
								&& !folderName.equalsIgnoreCase(ezEmailUtil.getJunkFolderId(locale))
								) {
							topLevelFolders.add(folder);
						}
					} else {					
						if (!DEFAULT_FOLDER_NAME_SET.contains(folderName)) {
							topLevelFolders.add(folder);
						}		
					}
				}
			}			
		} catch (MessagingException e) {
			logger.error("Error get default folder: " + e.getMessage());
		}
		
		return topLevelFolders;
	}
	
	public List<Folder> getSubFolders(String parent, boolean isSubscribe) {
		ArrayList<Folder> subFolders = new ArrayList<Folder>();
		try {
			Folder[] folders = null;
			
			if (isSubscribe) {
				folders = getStore().getFolder(parent).listSubscribed();
				
				Arrays.sort(folders, new Comparator<Folder>(){
					@Override
					public int compare(Folder f1, Folder f2) {
						return f1.getFullName().compareTo(f2.getFullName());
					}
				});
				
				for (Folder f : folders) {
					if (f.exists()) {
						subFolders.add(f);
					} else {
						f.setSubscribed(false);
					}
				}
			} else {
				folders = getStore().getFolder(parent).list();
				
				for (Folder f : folders) {
					subFolders.add(f);
				}
			}
			
		} catch (MessagingException e) {
			logger.error("Error get sub folder: " + e.getMessage());
		}
		return subFolders;
	}

	public int getUnreadCount(String folderName) {
		int unreadCount = 0;
		try {
			unreadCount = getStore().getFolder(folderName).getUnreadMessageCount();
		} catch (MessagingException e) {
			logger.error("Error get unread message count: " + e.getMessage());
		}
		return unreadCount;
	}
	
	public int getTotalCount(String folderName) {
		int totalCount = 0;
		try {
			totalCount = getStore().getFolder(folderName).getMessageCount();
		} catch (MessagingException e) {
			logger.error("Error get total message count: " + e.getMessage());
		}
		return totalCount;
	}

	// 전체메일 - [받은편지함 + 하위, 개인편지함 + 하위] 모든 메일함
	public List<String> getAllFolderNames() {
		List<String> folderNames = new ArrayList<>();

		try {
			Folder[] folders = getStore().getDefaultFolder().list("*");

			for (Folder folder : folders) {
				String folderName = folder.getFullName();

				if (folderName.startsWith("INBOX") || folderName.startsWith("Personal folder")) {
					folderNames.add(folderName);
				}
			}
		} catch (MessagingException e) {
			logger.error("Error get all folder names: " + e.getMessage());
		}

		return folderNames;
	}
	
	public Folder getFolder(String folderName) {
		Folder folder = null;
		
		try {
			folder = getStore().getFolder(folderName);
		} catch (MessagingException e) {
			logger.error("Error get folder: " + e.getMessage());
		}
		
		return folder;
	}
	
	// 승인메일 : apprMail이 true이면 승인메일 공유사서함의 보낸편지함 하위에 사용자 폴더를 리턴, false면 기존 그대로
	public Folder getFolder(String folderName, boolean apprMail) {
		logger.debug("apprMail={}, apprUserName={}", apprMail, apprUserName);
		Folder folder = null;
		
		if (!apprMail || apprUserName == null || "".equals(apprUserName)) {
			folder = getFolder(folderName);
		} else {
			try {
				// 승인메일 공유사서함에 사용자cn별로 폴더 생성
				String userCnFolderName = userName.split("@")[0];
				
				String folderPath = getApprStore().getFolder(ezEmailUtil.getSentFolderId(locale)).getFolder(userCnFolderName).getFullName();
				folder = getApprStore().getFolder(folderPath);
				
				if (!folder.exists()) {
					createApprFolder(folderPath);
					folder = getApprStore().getFolder(folderPath);
				}
			} catch (MessagingException e) {
				logger.error("Error get appr folder: " + e.getMessage());
			}
		}
		
		return folder;
	}
	
	/**
	 * 메일함 생성
	 * @param folderPath
	 * @return 0:성공, 1:실패, 2:중복, 3:에러
	 */
	public int createFolder(String folderPath) {
		int result = 1;
		
		try {
			Folder rootFolder = getStore().getDefaultFolder();
			Folder newFolder = rootFolder.getFolder(folderPath);
			
			if (newFolder.exists()) {
				logger.debug("folder already exist. folderPath=" + folderPath);
				return 2;
			}

			if (!newFolder.create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES)) {
				logger.debug("fail to create folder.");
				return 1;
			}
			
			newFolder.setSubscribed(true);
			logger.debug(folderPath + " is created.");
			result = 0;
			
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
			result = 3;
		}
		
		return result;
	}
	
	/** 
	 * 메일함 생성
	 * @param folderPath
	 * @return 0:성공, 1:실패, 2:중복, 3:에러
	 */
	public int createApprFolder(String folderPath) {
		int result = 1;
		
		try {
			Folder rootFolder = getApprStore().getDefaultFolder();
			Folder newFolder = rootFolder.getFolder(folderPath);
			
			if (newFolder.exists()) {
				logger.debug("folder already exist. folderPath=" + folderPath);
				return 2;
			}

			if (!newFolder.create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES)) {
				logger.debug("fail to create folder.");
				return 1;
			}
			
			newFolder.setSubscribed(true);
			logger.debug(folderPath + " is created.");
			result = 0;
			
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
			result = 3;
		}
		
		return result;
	}
	
	/**
	 * 메일함 삭제
	 * @param folderPath
	 * @return 0:성공, 1:실패, 2:존재하지 않음, 3:에러
	 */
	public int deleteFolder(String folderPath) {
		int result = 1;
		
		try {
			Folder rootFolder = getStore().getDefaultFolder();
			Folder folder = rootFolder.getFolder(folderPath);
			
			if (!folder.exists()) {
				logger.debug("folder not exist. folderPath=" + folderPath);
				return 2;
			}
			
			unSubscribeAndGetSubscribeFolderSet(folder, new HashSet<String>());
			
			if (!folder.delete(true)) {
				logger.debug("fail to delete folder.");
				return 1;
			}
			
			logger.debug(folderPath + " is deleted.");
			result = 0;
			
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
			result = 3;
		}
		
		return result;
	}
	
	/**
	 * 메일함 이동
	 * @param oldFolderPath
	 * @param newFolderPath
	 * @return 0:성공, 1:실패, 2:oldFolder 존재하지 않음, 3:newFolder 중복, 4:에러
	 */
	public int moveFolder(String oldFolderPath, String newFolderPath) {
		int result = 1;
		
		try{
			Folder rootFolder = getStore().getDefaultFolder();
			Folder oldFolder = rootFolder.getFolder(oldFolderPath);
			Folder newFolder = rootFolder.getFolder(newFolderPath);
			
			if (!oldFolder.exists()) {
				logger.debug("oldFolder not exist. oldFolderPath=" + oldFolderPath);
				return 2;
			}
			
			if (newFolder.exists()) {
				logger.debug("newFolder already exist. newFolderPath=" + newFolderPath);
				return 3;
			}
			
			Set<String> folderSet = new HashSet<String>();
			folderSet = unSubscribeAndGetSubscribeFolderSet(oldFolder, folderSet);
			
			Set<String> newFolderSet = new HashSet<String>();
			for (String folderPath : folderSet) {
				newFolderSet.add(folderPath.replace(oldFolderPath, newFolderPath));
			}
			
			if (!((IMAPFolder)oldFolder).renameTo(newFolder)) {
				logger.debug("fail to move folder.");
				return 1;
			}
			
			for (String folderPath : newFolderSet) {
				rootFolder.getFolder(folderPath).setSubscribed(true);
			}
			
			logger.debug("folder is moved.");
			logger.debug("oldFolderPath=" + oldFolderPath + ",newFolderPath=" + newFolderPath);
			
			result = 0;
			
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
			result = 4;
		}
		
		return result;
	}
	
	public Quota[] getQuota(String folder) {
		IMAPStore imapStore = (IMAPStore)getStore();
		Quota[] quotas = null;
		
		try {
			quotas = imapStore.getQuota(folder);
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		}
		
		return quotas;
	}
	
	public long[] getStorageUsageAndLimit() {
		long[] returnValues = null;
		
		Quota[] quotas = getQuota("INBOX");		
		
		if (quotas != null) {
			for (Quota quota : quotas) {
				Quota.Resource[] resources = quota.resources;
	
				for (Quota.Resource resource : resources) {
					if (resource.name.equals("STORAGE")) {
						returnValues = new long[] {resource.usage, resource.limit};
					}
				}
			}
		}
		
		return returnValues;
	}
	
	public static boolean hasAttachment(Part part) {
		boolean isAttached = false;
		
		try {
//			logger.debug("Content-Type=" + part.getContentType());

			// 료비에서 수신한 메일 중에 text/plain 파트만 있으면서
			// ContentID 없이 Content-Dispostion이 inline으로 첨부된
			// 이미지가 있어 이 경우 첨부파일로서 처리하기 위해 추가함.(iPhone Mail에서 작성한 메일임.)
			boolean isInlinePartWithoutContentID = false;

			if (!part.isMimeType("multipart/*") && part instanceof MimePart) {
				if (part.getDisposition() != null 
						&& part.getDisposition().equalsIgnoreCase(Part.INLINE)
						&& ((MimePart)part).getContentID() == null) {
					isInlinePartWithoutContentID = true;
				}
			}
			
			// this is a multipart			
			if (part.isMimeType("multipart/*")) {				
		         Multipart mp = (Multipart)part.getContent();
		         int count = mp.getCount();
		         for (int i = 0; i < count; i++) {
		        	 isAttached = hasAttachment(mp.getBodyPart(i));
		        	 if (isAttached) {
		        		 break;
		        	 }
		         }
			}
			/*
			// this is a nested message			
			else if (part.isMimeType("message/rfc822")) {
				hasAttachment((Part)part.getContent());
			}
			*/
			// Content-Disposition 헤더가 없이 첨부된 파일이 있어
			// Content-Type이 application으로 시작하는 경우도 추가함 
			// 예) Content-Type: application/octet-stream;
			//         name="=?utf-8?B?NDExMDAwODE1OS5QREY=?="
		    //    Content-Transfer-Encoding: base64	    											
			else if ((part.getDisposition() != null && part.getDisposition().equalsIgnoreCase(Part.ATTACHMENT))
						|| (part.isMimeType("application/*") && ((MimePart)part).getContentID() == null)
						|| isInlinePartWithoutContentID) {
				isAttached = true;
			}			
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} 		
		
		return isAttached;
	}
	
	public static IMAPAccess getInstance(String host, String port, String username, String password, EgovMessageSource egovMessageSource, 
								Locale locale, EzEmailUtil ezEmailUtil) {
		return new IMAPAccess(host, port, username, password, egovMessageSource, locale, ezEmailUtil);
	}
	
	public static IMAPAccess getInstance(String host, String port, String username, String password, EgovMessageSource egovMessageSource, 
								Locale locale, EzEmailUtil ezEmailUtil, String apprUsername) {
		return new IMAPAccess(host, port, username, password, egovMessageSource, locale, ezEmailUtil, apprUsername);
	}
	
	public static IMAPAccess getInstance(String host, String port, String username, String password, EgovMessageSource egovMessageSource, 
								Locale locale, int timeout, int connectionTimeout, EzEmailUtil ezEmailUtil) {
		return new IMAPAccess(host, port, username, password, egovMessageSource, locale, timeout, connectionTimeout, ezEmailUtil);
	}
	
	public static class MessageSubjectComparator implements Comparator<Message> {
		
		Collator collator = Collator.getInstance();
		
		@Override
		public int compare(Message m1, Message m2) {
			String first = null;
			String second = null;
			try {
				first = m1.getSubject();
				second = m2.getSubject();
			} catch (MessagingException e) {
				logger.debug("e.message=" + e.getMessage());
			}
			
			first = first != null ? first.trim() : "";
			second = second != null ? second.trim() : "";
			
			int rc = collator.compare(first, second);
			if (rc == 0) {
				try {
					Date d1 = m1.getReceivedDate();
					Date d2 = m2.getReceivedDate();
					if (d1 != null && d2 != null) {
						rc = d1.compareTo(d2);
					}
				} catch (MessagingException e) {
					logger.debug("e.message=" + e.getMessage());
				}
			}
			
			return rc;
		}
		
	}	
	
	public static class MessageAddressComparator implements Comparator<Message> {
		
		private Collator collator = Collator.getInstance();
		private Map<String, String> addressMap = new HashMap<String, String>();
		private boolean isSender;
		
		public MessageAddressComparator(boolean isSender) {
			this.isSender = isSender;
		}
		
		private String getAddress(Message msg) {
			String addressStr = null;
			Address[] addresses = null;
			try {
				if (isSender) {
					addresses = msg.getFrom();
				}
				else {
					addresses = msg.getRecipients(Message.RecipientType.TO);
				}
			} catch (MessagingException e) {
				logger.debug("e.message=" + e.getMessage());
			}
			if (addresses != null) {
				if (isSender) {
					addressStr = addressMap.get(addresses[0].toString());			
					if (addressStr == null) {					
						addressStr = ((InternetAddress)addresses[0]).getPersonal();
						if (addressStr == null) {
							addressStr = ((InternetAddress)addresses[0]).getAddress();
						}
						else {
							try {
								addressStr = MimeUtility.decodeText(addressStr);
							} catch (UnsupportedEncodingException e) {
								logger.error(e.getMessage(), e);
							}
						}					
						
						addressMap.put(addresses[0].toString(), addressStr);
					}		
				}
				else {
					String keyString = InternetAddress.toString(addresses);
					addressStr = addressMap.get(keyString);			
					if (addressStr == null) {		
						StringBuilder addressBuilder = new StringBuilder();
						for (Address address : addresses) {
							addressStr = ((InternetAddress)address).getPersonal();
							if (addressStr == null) {
								addressStr = ((InternetAddress)address).getAddress();
							}
							else {
								try {
									addressStr = MimeUtility.decodeText(addressStr);
								} catch (UnsupportedEncodingException e) {
									logger.error(e.getMessage(), e);
								}
							}			
							addressBuilder.append(addressStr);
							addressBuilder.append("; ");							
						}
						addressStr = addressBuilder.toString();
						addressStr = addressStr.substring(0, addressStr.length() - 2);						
						
						addressMap.put(keyString, addressStr);
					}		
				}
			}
			else {
				addressStr = "";
			}
			
			return addressStr;
		}
		
		@Override
		public int compare(Message m1, Message m2) {			
			String first = getAddress(m1);
			String second = getAddress(m2);
			
			first = first != null ? first.trim() : "";
			second = second != null ? second.trim() : "";
			
			int rc = collator.compare(first, second);
			if (rc == 0) {
				try {
					Date d1 = m1.getReceivedDate();
					Date d2 = m2.getReceivedDate();
					if (d1 != null && d2 != null) {
						rc = d1.compareTo(d2);
					}
				} catch (MessagingException e) {
					logger.debug("e.message=" + e.getMessage());
				}
			}
			
			return rc;
		}
		
	}	
	
	public static class MessageAttachmentComparator implements Comparator<Message> {
				
		@Override
		public int compare(Message m1, Message m2) {
			int attached1 = hasAttachment(m1) ? 1 : 0;
			int attached2 = hasAttachment(m2) ? 1 : 0;
						
			int rc = attached1 - attached2;
			if (rc == 0) {
				try {
					Date d1 = m1.getReceivedDate();
					Date d2 = m2.getReceivedDate();
					if (d1 != null && d2 != null) {
						rc = d1.compareTo(d2);
					}
				} catch (MessagingException e) {
					logger.debug("e.message=" + e.getMessage());
				}
			}
			
			return rc;
		}
		
	}	
	
	public static class MessageUnreadComparator implements Comparator<Message> {
				
		@Override
		public int compare(Message m1, Message m2) {
			int unread1 = 0;
			int unread2 = 0;
			try {
				unread1 = !m1.isSet(Flags.Flag.SEEN) ? 1 : 0;
				unread2 = !m2.isSet(Flags.Flag.SEEN) ? 1 : 0;
			} catch (MessagingException e) {
				logger.debug("e.message=" + e.getMessage());
			}
						
			int rc = unread1 - unread2;
			if (rc == 0) {
				try {
					Date d1 = m1.getReceivedDate();
					Date d2 = m2.getReceivedDate();
					if (d1 != null && d2 != null) {
						rc = d1.compareTo(d2);
					}
				} catch (MessagingException e) {
					logger.debug("e.message=" + e.getMessage());
				}
			}
			
			return rc;
		}
		
	}	
	
	public static class MessageFlaggedComparator implements Comparator<Message> {
		
		@Override
		public int compare(Message m1, Message m2) {
			int flagged1 = 0;
			int flagged2 = 0;
			try {
				flagged1 = m1.isSet(Flags.Flag.FLAGGED) ? 1 : 0;
				flagged2 = m2.isSet(Flags.Flag.FLAGGED) ? 1 : 0;
			} catch (MessagingException e) {
				logger.debug("e.message=" + e.getMessage());
			}
						
			int rc = flagged1 - flagged2;
			if (rc == 0) {
				try {
					Date d1 = m1.getReceivedDate();
					Date d2 = m2.getReceivedDate();
					if (d1 != null && d2 != null) {
						rc = d1.compareTo(d2);
					}
				} catch (MessagingException e) {
					logger.debug("e.message=" + e.getMessage());
				}
			}
			
			return rc;
		}
		
	}	
	
	public static class MessagePriorityComparator implements Comparator<Message> {
		
		private int getPriority(Message msg) {
			String[] headers = null;
			try {
				headers = msg.getHeader("X-Priority");
			} catch (MessagingException e) {
				logger.debug("e.message=" + e.getMessage());
			}
			String header = headers != null ? headers[0] : "normal";
			int importance = 1;
			// startsWith is used since
			// there are cases like X-Priority: 1 (Highest) generated by Thunderbird.			
			if (header.startsWith("1")) {
				importance = 2;
			}
			else if (header.startsWith("5")) {
				importance = 0;
			}			
			
			return importance;
		}
		
		@Override
		public int compare(Message m1, Message m2) {
			int priority1 = getPriority(m1);	
			int priority2 = getPriority(m2);
			
			int rc = priority1 - priority2;
			if (rc == 0) {
				try {
					Date d1 = m1.getReceivedDate();
					Date d2 = m2.getReceivedDate();
					if (d1 != null && d2 != null) {
						rc = d1.compareTo(d2);
					}
				} catch (MessagingException e) {
					logger.debug("e.message=" + e.getMessage());
				}
			}
			
			return rc;
		}
		
	}	
	
	public static class MessageSizeComparator implements Comparator<Message> {
		
		@Override
		public int compare(Message m1, Message m2) {
			int size1 = 0;
			int size2 = 0;
			try {
				size1 = m1.getSize();
				size2 = m2.getSize();
			} catch (MessagingException e) {
				logger.debug("e.message=" + e.getMessage());
			}
						
			int rc = size1 - size2;
			if (rc == 0) {
				try {
					Date d1 = m1.getReceivedDate();
					Date d2 = m2.getReceivedDate();
					if (d1 != null && d2 != null) {
						rc = d1.compareTo(d2);
					}
				} catch (MessagingException e) {
					logger.debug("e.message=" + e.getMessage());
				}
			}
			
			return rc;
		}
		
	}	
	
	public static class MessageReceivedDateComparator implements Comparator<Message> {
		
		@Override
		public int compare(Message m1, Message m2) {
			int rc = 0;
			try {
				Date d1 = m1.getReceivedDate();
				Date d2 = m2.getReceivedDate();
				if (d1 != null && d2 != null) {
					rc = d1.compareTo(d2);
				}
			} catch (MessagingException e) {
				logger.debug("e.message=" + e.getMessage());
			}
			
			return rc;
		}
		
	}		
	
	private void setReculsiveSubscribe(Folder folder, boolean isSubscribe) throws MessagingException {
		Folder[] folderArr = folder.list();
		
		for (Folder f : folderArr) {
			f.setSubscribed(isSubscribe);
			setReculsiveSubscribe(f, isSubscribe);
		}
	}
	
	private Set<String> unSubscribeAndGetSubscribeFolderSet(Folder folder, Set<String> folderSet) throws MessagingException {
		if (folder.exists()) {
			if (folder.isSubscribed()) {
				folder.setSubscribed(false);
				folderSet.add(folder.getFullName());
			}
			
			Folder[] folderArr = folder.listSubscribed();
			
			for (Folder f : folderArr) {
				unSubscribeAndGetSubscribeFolderSet(f, folderSet);
			}
		} else {
			folder.setSubscribed(false);
		}
		
		return folderSet;
	}
}
