package egovframework.ezEKP.ezEmail.web;

import java.net.URLEncoder;
import java.text.ParseException;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailSharedMailboxUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 편지함 관리
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.05.03    이효민    신규작성
 *
 * @see
 */

@Controller
public class EzEmailFolderManageController extends EgovFileMngUtil{

	private static final Logger logger = LoggerFactory.getLogger(EzEmailFolderManageController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	/**
	 * 편지함 관리 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailFolderManage.do", method = RequestMethod.GET)
	public String mailFolderManage(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailFolderManage started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, 4, userInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailFolderManage ended.");
					
					return "ezCommon/error";
				} else {
					MailSharedMailboxUserVO shareInfo = ezEmailService.getSharedMailboxPermissionInfo(shareId, userInfo.getTenantId(), userInfo.getId());
					
					model.addAttribute("shareId", shareId);
					model.addAttribute("shareName", shareInfo.getShareName());
					model.addAttribute("deletePermission", shareInfo.getDeletePermission());
				}
			}
		}
		
		String pDeleteBoxID = ezEmailUtil.getTrashFolderId(locale);
		String pDeleteBoxName = ezEmailUtil.getTrashFolderId(locale);
		
		model.addAttribute("pDeleteBoxID", pDeleteBoxID);
		model.addAttribute("pDeleteBoxName", pDeleteBoxName);
		
		logger.debug("mailFolderManage ended.");
		return "ezEmail/mailFolderManage";
	}
	
	/**
	 * 편지함 추가/수정 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/inputNameDlg.do", method = RequestMethod.GET)
	public String inputNameDlg(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		
		return "ezEmail/mailInputNameDlg";
	}
	
	/**
	 * 편지함 이동/복사 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailMoveCopy.do", method = RequestMethod.GET)
	public String mailMoveCopy(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailMoveCopy started.");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		
		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailMoveCopy ended.");
					
					return "ezCommon/error";
				} else {
					model.addAttribute("shareId", shareId);
				}
			}
		}
		
		if (request.getParameter("fm") != null) {
			model.addAttribute("isFolderManager", "1");
		} else {
			model.addAttribute("isFolderManager", "1"); // 0 > 1로 값 변경하여 전체메일 숨기는 용도로 사용 함 (기존 isFolderManager가 0일때 mailMoveCopy 나타나틑 차이점이 없음) 
		}
		
		logger.debug("mailMoveCopy ended.");
		return "ezEmail/mailMoveCopy";
	}
	
	/**
	 * 편지함 추가/수정/삭제/이동/복사/메일삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailMakeFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public String mailMakeFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model, @RequestBody String bodyData) throws Exception{
		logger.debug("mailMakeFolder started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "ERROR";
		
		Document xmlDoc = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
		Element root = xmlDoc.getDocumentElement();
		
		String url = "";
		String name = "";
		String destination = "";
		String cmd = "";
		
		if (root.getElementsByTagName("URL") != null && root.getElementsByTagName("URL").item(0) != null) {
			url = root.getElementsByTagName("URL").item(0).getTextContent();
		}
		if (root.getElementsByTagName("NAME") != null && root.getElementsByTagName("NAME").item(0) != null) {
			name = root.getElementsByTagName("NAME").item(0).getTextContent();
		}
		if (root.getElementsByTagName("DESTINATION") != null && root.getElementsByTagName("DESTINATION").item(0) != null) {
			destination = root.getElementsByTagName("DESTINATION").item(0).getTextContent();
		}
		if (root.getElementsByTagName("CMD") != null && root.getElementsByTagName("CMD").item(0) != null) {
			cmd = root.getElementsByTagName("CMD").item(0).getTextContent();
		}
		
		List<String> userIdnPw = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userIdnPw.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		
		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				int permissionType = 4;
				
				// 편지함 영구삭제 시 삭제 권한 및 관리 권한(5) 확인
				// 모든 메일 삭제(지운편지함으로 이동), 모든 메일 영구 삭제 시 삭제 권한(1) 확인
				// 그 외에는 관리 권한(4) 확인
				if (cmd.equals("DEL")) {
					permissionType = 5;
				} else if (cmd.equals("MAILREALDEL") || cmd.equals("MAILDEL")) {
					permissionType = 1;
				}
				
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, permissionType, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailMakeFolder ended.");
					
					return "";
				}
				
				userAccount = shareId + "@" + domainName;
			}
		}
		
		logger.debug("userId=" + userInfo.getId() + ",userAccount=" + userAccount);
		
		IMAPAccess ia = null;
        boolean isNewUserQuotaNeeded = false;	
        boolean isThereUserLevelQuota = false;
        Double userQuota = 0.0;
        Double userWarn = 0.0;        
		
		try {
	        switch (cmd) {
	            case "NEW": 
	            	ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
	            			userAccount, password, egovMessageSource, locale, ezEmailUtil);
	            	if (!name.equals("") && !url.equals("") && ia != null) {
	            		String folderPath = ia.getFolder(url).getFolder(name).getFullName();
						folderPath = (folderPath != null) ? folderPath : "";
	            		int result = ia.createFolder(folderPath);
	            		
	            		if (result == 0) {
	            			returnValue = "OK";
	            		} else if (result == 2) {
	            			returnValue = "ALREADY_EXISTS";
	            		}
	            	}
	            	
	                break;
	            case "MODIFY":
	            	ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
	            			userAccount, password, egovMessageSource, locale, ezEmailUtil);
	            	
	            	if (!name.equals("") && !url.equals("") && ia != null) {
	            		String oldFolderPath = url;
	            		String parentPath = ia.getFolder(oldFolderPath).getParent().getFullName();
						parentPath = (parentPath != null) ? parentPath : "";
	            		String newFolderPath = ia.getFolder(parentPath).getFolder(name).getFullName();
	            		
	            		int result = ia.moveFolder(oldFolderPath, newFolderPath);
	            		
	            		if (result == 0) {
	            			returnValue = "OK";
	            		} else if (result == 3) {
	            			returnValue = "ALREADY_EXISTS";
	            		}

						String oldFolderPathParam = "oldFolderPath=" + URLEncoder.encode(oldFolderPath, "UTF-8");
						String newFolderPathParam = "newFolderPath=" + URLEncoder.encode(newFolderPath, "UTF-8");
						String newFolderNameParam = "name=" + URLEncoder.encode(name, "UTF-8");
						String userParam = "userId=" + URLEncoder.encode(userAccount, "UTF-8");

						String inputParams = userParam + "&" + oldFolderPathParam + "&" + newFolderPathParam + "&" + newFolderNameParam;
						logger.debug("case=MODIFY, updateMailDelete started. inputParams=" + inputParams);

						try {
							String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/updateMailDeleteSql", inputParams);
							logger.debug("strJson=" + strJson);

							JSONParser parser = new JSONParser();
							JSONObject object = (JSONObject)parser.parse(strJson);

							if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
								throw new Exception("JGwServer no updateMailDelete");
							}

						} catch (ParseException e) {
							logger.error(e.getMessage(), e);
						} catch (Exception e) {
							logger.debug("[JGW-SERVER] No updateMailDelete.");
						}
	            	}
	            	
	                break;
	            case "MOVE": //폴더 이동(폴더삭제기능 포함 : 지운편지함으로 이동)
	            	ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
	            			userAccount, password, egovMessageSource, locale, ezEmailUtil);
	            	
	            	if (!destination.equals("") && !url.equals("") && ia != null) {
	            		String oldFolderPath = url;
	            		String oldFolderName = ia.getFolder(oldFolderPath).getName();
						oldFolderName = (oldFolderName != null) ? oldFolderName : "";
	            		String newFolderPath = ia.getFolder(destination).getFolder(oldFolderName).getFullName();
	            		
	            		int result = ia.moveFolder(oldFolderPath, newFolderPath);
	            		
	            		if (result == 0) {
	            			returnValue = "OK";
	            		} else if (result == 3) {
	            			returnValue = "ALREADY_EXISTS";
	            		}

						String oldFolderPathParam = "oldFolderPath=" + URLEncoder.encode(oldFolderPath, "UTF-8");
						String newFolderPathParam = "newFolderPath=" + URLEncoder.encode(newFolderPath, "UTF-8");
						String newFolderNameParam = "name=" + URLEncoder.encode(oldFolderName, "UTF-8");
						String userParam = "userId=" + URLEncoder.encode(userAccount, "UTF-8");

						String inputParams = userParam + "&" + oldFolderPathParam + "&" + newFolderPathParam + "&" + newFolderNameParam;
						logger.debug("case=MOVE, updateMailDelete started. inputParams=" + inputParams);

						try {
							String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/updateMailDeleteSql", inputParams);
							logger.debug("strJson=" + strJson);

							JSONParser parser = new JSONParser();
							JSONObject object = (JSONObject)parser.parse(strJson);

							if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
								throw new Exception("JGwServer no updateMailDelete");
							}

						} catch (ParseException e) {
							logger.error(e.getMessage(), e);
						} catch (Exception e) {
							logger.debug("[JGW-SERVER] No updateMailDelete.");
						}
	            	}
	            	
	                break;
	            case "COPY": 
	            	// 특정 편지함을 복사 - 하위폴더는 복사하지 않음(닷넷버전은 하위폴더도 복사) 
	            	// 편지함 삭제 및 복사시 timeout 오류 발생으로 시간 수정
	            	ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
	            			userAccount, password, egovMessageSource, locale, 600000, 20000, ezEmailUtil);
	            	
	            	if (ia != null && url != null && !destination.equals("") && !url.equals("")) {
	            		Folder oldFolder = ia.getFolder(url);
						if (oldFolder != null){
							String folderName = oldFolder.getName();
							String folderPath = ia.getFolder(destination).getFolder(folderName).getFullName();

							int result = ia.createFolder(folderPath);

							if (result == 0) {
								Folder copiedFolder = ia.getFolder(folderPath);

								oldFolder.open(Folder.READ_WRITE);
								oldFolder.copyMessages(oldFolder.getMessages(), copiedFolder);
								oldFolder.close(true);
								logger.debug(url + " folder is copied to " + destination + ".");

								returnValue = "OK";
							} else if (result == 2) {
								returnValue = "ALREADY_EXISTS";
							}
						}
	            	}
	            	
	                break;
	            case "DEL": //지운편지함 하위에 있는 폴더 영구삭제 - 하위폴더도 삭제됨(메일도 삭제됨)
	            	ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
	            			userAccount, password, egovMessageSource, locale, ezEmailUtil);
	            	
	            	if (url != null && !url.equals("") && ia != null) {
						ezEmailService.actionTrashMailAllDelete(ia, url);
	            		int result = ia.deleteFolder(url);
	            		
	            		if (result == 0) {
	            			returnValue = "OK";
	            		}

						String folderPathParam = "folderPath=" + URLEncoder.encode(url, "UTF-8");

						String userParam = "userId=" + URLEncoder.encode(userAccount, "UTF-8");

						String inputParams = userParam + "&" + folderPathParam;
						logger.debug("case=DEL, deleteMailDelete started. inputParams=" + inputParams);

						try {
							String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/deleteMailDelete", inputParams);
							logger.debug("strJson=" + strJson);

							JSONParser parser = new JSONParser();
							JSONObject object = (JSONObject)parser.parse(strJson);

							if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
								throw new Exception("JGwServer no deleteMailDelete");
							}

						} catch (ParseException e) {
							logger.error(e.getMessage(), e);
						} catch (Exception e) {
							logger.debug("[JGW-SERVER] No deleteMailDelete.");
						}
	            	}
	            	
	                break;
	            case "MAILREALDEL": //지운편지함에 있는 모든 메시지 영구삭제
	            	ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
	            			userAccount, password, egovMessageSource, locale, ezEmailUtil);
	            	
	            	if (url != null && !url.equals("") && ia != null) {
						ezEmailService.actionTrashMailAllDelete(ia, url);
						logger.debug(url + " folder is clean.");
						returnValue = "OK";
	            	}
	            	
	                break;
	            case "MAILDEL": 
	            	// 특정폴더의 모든 메시지 삭제(지운편지함으로 이동)
	            	// 편지함 삭제 및 복사시 timeout 오류 발생으로 시간 수정
	            	ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
	            			userAccount, password, egovMessageSource, locale, 600000, 20000, ezEmailUtil);
	            	
	            	if (!url.equals("") && ia != null) {
	            		String trashFolderName = ezEmailUtil.getTrashFolderId(locale);
            			Folder trashFolder = ia.getFolder(trashFolderName);
            			IMAPFolder folder = (IMAPFolder)ia.getFolder(url);
            			
	            		if (folder.exists() && trashFolder.exists()) {
            				folder.open(Folder.READ_WRITE);
            				Message[] messages = folder.getMessages();
            				logger.debug("messageCount:" + messages.length );
            				if (messages.length == 0){
            					returnValue = "MAIL_NOT_EXISTS";
            					break;
            				}
            				
            				String useImapMoveCommand = ezCommonService.getTenantConfig("useImapMoveCommand", userInfo.getTenantId());
            				
            				if (useImapMoveCommand.equals("YES")) {
								for (int i = 0; i < messages.length; i += 100) {
									int end = Math.min(i + 100, messages.length);
									folder.moveMessages(Arrays.copyOfRange(messages, i, end), trashFolder);
								}
            				} else {            				
                				// 지운 편지함으로 보낼 메시지의 크기가 Quota량을 초과하게 되면 Quota를 재조정한다.
                				Double[] adjustQuotaData = ezEmailUtil.adjustUserQuotaForMessageMove(messages, userAccount, domainName, ia);
                				
                				if (adjustQuotaData[0] != null) {
                					isNewUserQuotaNeeded = true;
                					
                					userQuota = adjustQuotaData[0];
                					userWarn = adjustQuotaData[1];
                				}

								if (adjustQuotaData[2] != null) {
									isThereUserLevelQuota = true;
								}

								folder.copyMessages(messages, trashFolder);
								folder.setFlags(messages, new Flags(Flags.Flag.DELETED), true);
							}

							folder.close(true);
							logger.debug(url + " folder's message is moved to " + trashFolderName + ".");
							returnValue = "OK";
						}
	            	}
	            	
	                break;
	            default:
	                break;
	        }
		} catch (MessagingException e) {
			returnValue = "ERROR : " + e.getMessage();
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
			
			// 사용자 Quota를 변경시켰다면 원래 값으로 복원시킨다.			
			if (isNewUserQuotaNeeded) {
				if (isThereUserLevelQuota) {
					ezEmailUtil.setUserQuota(userAccount, String.valueOf(userQuota), String.valueOf(userWarn));
				// 사용자 레벨 Quota 설정값이 없었던 경유에는 해당 설정값을 삭제한다.
				} else {
					ezEmailUtil.deleteUserQuota(userAccount);
				}
			}			
		}
        
		logger.debug("returnValue=" + returnValue);
		logger.debug("mailMakeFolder ended.");
		
		return returnValue;
	}
	
	/**
	 * 편지함 구독 실행 함수
	 */
	@RequestMapping(value="/ezEmail/setSubscribe.do", method = RequestMethod.POST)
	@ResponseBody
	public String setSubscribe(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("setSubscribe started.");
		
		String folderId = request.getParameter("folderId");
		String subscribeStr = request.getParameter("subscribe");
		logger.debug("folderId=" + folderId + ",subscribeStr=" + subscribeStr);
		
		String returnValue = "ERROR";
		
		boolean subscribe = false;
		if ("1".equalsIgnoreCase(subscribeStr)) {
			subscribe = true;
		}
		
		List<String> userIdnPw = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userIdnPw.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		
		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, 4, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("setSubscribe ended.");
					
					return "";
				}
				
				userAccount = shareId + "@" + domainName;
			}
		}
		
		logger.debug("userId=" + userInfo.getId() + ",userAccount=" + userAccount);
		
		IMAPAccess ia = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
        			userAccount, password, egovMessageSource, locale, ezEmailUtil);
			if (ia != null){
				Folder f = ia.getFolder(folderId);
				if (f != null){
					f.setSubscribed(subscribe);
				}
			}
			returnValue = "OK";
		} catch (MessagingException e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("setSubscribe ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	@SuppressWarnings("unused")
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
