package egovframework.ezEKP.ezEmail.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.security.PrivateKey;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.Set;
import java.util.TimeZone;
import java.util.UUID;
import java.util.function.Consumer;

import javax.annotation.Resource;
import javax.mail.Address;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.internet.AddressException;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;

import egovframework.ezEKP.ezPoll.service.EzPollService;
import org.apache.commons.lang3.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun.mail.imap.AppendUID;
import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.service.EzEmailWriteService;
import egovframework.ezEKP.ezEmail.type.WriteType;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailSharedMailboxVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
import egovframework.ezEKP.ezEmail.vo.MailWriteMessageVO;
import egovframework.ezEKP.ezEmail.vo.MailWriteOptionsVO;
import egovframework.ezEKP.ezEmail.vo.MailWriteProcessVO;
import egovframework.ezEKP.ezPoll.vo.PollEmailSimpleUser;
import egovframework.ezEKP.ezPoll.vo.PollUserAnswerVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/**
 * 반환값 사용식 함수가 아닌, in-place 변경식 함수로 진행되고 있다.
 *
 * 각 모드별(22개) 다형성을 사용하기 위한 방안으로, 마치 writevo의 setter와 같이 사용되고 있다.
 * 상속 활용하여 멤버 함수 안에서 각기 적절한 방식을 거쳐 멤버 변수를 set 해주면 좋겠지만,
 * 그러면 객체 안에서 ezEmailUtil이나 service를 호출해야 하므로 좋지 않다고 판단한다.
 * enum 으로 각 모드를 구분하여 처리하고, vo에 변수를 담도록 다형성을 구현하였다.
 * 더 좋은 방법이 있다면, 수정 또는 주석으로 to-do 추가 바람!
 */
@Service("EzEmailWriteService")
public class EzEmailWriteServiceImpl extends EgovAbstractServiceImpl implements EzEmailWriteService {

    private static final Logger logger = LoggerFactory.getLogger(EzEmailWriteServiceImpl.class);

	@Autowired
    private Properties config;

	@Autowired
    private EzEmailUtil ezEmailUtil;

    @Autowired
    private EzEmailService ezEmailService;

    @Autowired
    private CommonUtil commonUtil;

	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;

    @Resource(name="loginService")
    private LoginService loginService;

    @Resource(name = "EzPollService")
    private EzPollService ezPollService;

    @Resource(name="crypto")
    private EgovFileScrty egovFileScrty;

    @Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;

    /**
     * RESERVE: 예약발송 수정 유효성 검사
     */
    @Override
    public String isValidReserve(HttpServletRequest request, MailWriteProcessVO writevo, LoginVO loginInfo) throws Exception {
        String messageId = StringUtils.defaultIfBlank(request.getParameter("messageid"), ""); // pCDOMessageID

        if (StringUtils.isBlank(messageId)) { //messageId parameter가 비어있는 경우
            return "ezEmail.lhm06";
        }

        messageId = commonUtil.detectPathTraversal(messageId);
        String delaySendDate = ezEmailService.getMailReservedTime(messageId); // pReservedSaveTime

        //utc에서 timezone으로 시간변경
        delaySendDate = commonUtil.getDateStringInUTC(delaySendDate, loginInfo.getOffset(), false);

        SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");

        String utcDate = commonUtil.getTodayUTCTime("");
        Date nowDate = transFormat.parse(commonUtil.getDateStringInUTC(utcDate, loginInfo.getOffset(), false));
        Calendar cal = Calendar.getInstance();
        cal.setTime(nowDate);
        cal.add(Calendar.MINUTE, 30);
        Date timePlus30 = cal.getTime();

        Date reservedSaveTime = transFormat.parse(delaySendDate);

        //예약발송 시간 30분 전에는 수정 불가
        if (reservedSaveTime.before(timePlus30)) {
            return "ezEmail.lhm07";
        }

        //eml파일 읽기
        String realPath = commonUtil.getRealPath(request);
        String pDirPath = commonUtil.getUploadPath("upload_mail.RESERVED_MAIL_PATH", loginInfo.getTenantId());
        pDirPath = realPath + commonUtil.separator + pDirPath;
        File emlFile = new File(pDirPath + commonUtil.separator + messageId + ".eml");

        if (!emlFile.exists()) { //eml파일이 저장소에 없는 경우
            return "ezEmail.lhm06";
        }

        // messageId(cdoMessageID), delaySendDate, emlFile, folderPath, hasOrigin
        writevo.setReservation(messageId, delaySendDate, emlFile);
        return null;
    }

    /**
     * 일반
     */
    @Override
    public void setGeneral(HttpServletRequest request, MailWriteProcessVO writevo, Locale locale) {
        // url
        String urlOwn = Arrays.stream(new String[]{"URL", "url", "iptURL"})
                    .map(request::getParameter).filter(StringUtils::isNotBlank).findFirst().orElse("");
        writevo.setUrlOwn(urlOwn); // folderPath/uid (ex. "INBOX/4")

        if (StringUtils.isNotBlank(urlOwn)) {
            int index = urlOwn.lastIndexOf("/");
            writevo.setHasOrigin(true);

            // separate the passed-in url into a folder path and a message uid
            if (index != -1) {
                writevo.setFolderPath(urlOwn.substring(0, index));
                String url = urlOwn.substring(index + 1);
                writevo.setUid(Long.parseLong(url)); // (long) uid, draftUID(x)
                writevo.setUrl(url); // (String) uid or draftUID
            }
        }

        // cmd
        if(writevo.hasOrigin()) {
            // retrieve the Sent folder name
            String sentFolderName = ezEmailUtil.getSentFolderId(locale);
            writevo.setCmdWithFolderName(sentFolderName);
        }

        // msgto
        String msgto = StringUtils.defaultString(request.getParameter("msgto"));
        msgto = msgto.toLowerCase().trim().replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
        writevo.setMsgto(msgto); // for NEW, RESEND_IN_SENT
    }

    /**
     * shareId 유효성 검사
     */
    @Override
    public boolean isValidShareId(MailWriteProcessVO writevo, String loginId, String shareId, int tenantId) throws Exception {
        boolean result = true;
        String mailId = loginId;

        boolean useSharedMailbox = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useSharedMailbox", tenantId));

        if (useSharedMailbox && StringUtils.isNotBlank(shareId)) {
            result = ezEmailService.checkUserShareId(loginId, shareId, 2, tenantId);
            logger.debug("shareId=" + shareId);

            if (result) {
                MailSharedMailboxVO sharedMailboxInfo = ezEmailService.getSharedMailboxInfo(shareId, tenantId);
                writevo.setSharedMailboxInfoVO(sharedMailboxInfo);

                mailId = shareId;
                writevo.putIntoExtraMap(shareId);
            }
        }

        writevo.setMailId(mailId);
        return result;
    }

    /**
     * load from origin message
     */
    @Override
    public void loadFromOrigin(MailWriteProcessVO writevo, LoginVO loginInfo, String userAccount, String password, Locale locale) {
        MailWriteMessageVO messagevo = writevo.getMailWriteMessageVO();
        WriteType writetype = writevo.getWriteType();
        File emlFile = writevo.getEmlFile();

        Map<String, Object> extraMap = writevo.getExtraMap();
        String folderPath = writevo.getFolderPath();
        boolean isReply = writetype.isReply();
        boolean isReserve = writetype.isReserve();

        Consumer<IMAPAccess> callback = ia -> {
            try {
                Folder orgFolder = ia.getFolder(folderPath);
                orgFolder.open(Folder.READ_ONLY);

                // retrieve the specified message.
                Message orgMessage = null;
                boolean isValid = false;

                if (isReserve) {
                    isValid = emlFile != null;
                } else {
                    orgMessage = ((IMAPFolder)orgFolder).getMessageByUID(writevo.getUid());
                    isValid = orgMessage != null;
                }

                if (isValid) {
                    Message savedMessage = null; // 임시보관함에 저장

                    // (savedMessage)
                    if (writetype.useSaveDrafts()) { // isResend, isReply, FORWARD, RESERVE
                        savedMessage = getMessageToSave(writetype, orgMessage, userAccount, password, emlFile);

                        if (isReserve) {
                            orgMessage = savedMessage; // orgMessage가 없으므로.
                        } else {
                            setContent(writetype, orgMessage, savedMessage);
                        }

                        savedMessage.setFlag(Flags.Flag.SEEN, true);
                        saveInDraft(ia, savedMessage, writevo);
                    }

                    // (orgMessage)
                    // from
                    Address fromAddress = getForm(orgMessage);
                    if (fromAddress != null && (writetype.isEdit() || writetype.isResend())) {
                        String from = ((InternetAddress) fromAddress).getAddress();
                        writevo.setFrom(from); // eunsil1@svn1.opensol2014.com
                    }

                    // to, cc, bcc
                    if (writetype.useSetAddresses()) { // !FORWARD
                        setAddresses(writetype, orgMessage, savedMessage, messagevo, writevo.getMsgto(), writevo.getReciverName(), loginInfo.getTenantId());
                    }

                    // subject
                    String subject = getSubject(writetype, orgMessage, locale);
                    messagevo.setSubject(subject);
                    messagevo.setEncodedSubject(EgovStringUtil.getSpclStrCnvr(subject));

                    // body, attach
                    long uid = writevo.getUid(); // 예약발송은  savedMessage 이후 uid가 생성됨
                    List<Map<String, String>> attachedFileList = new ArrayList<Map<String, String>>();
                    List<String> bodyInfoList = ezEmailUtil.getBodyInfo(orgMessage, folderPath, uid, -1, attachedFileList, locale, extraMap);
                    String bodyValue = bodyInfoList.get(0);

                    if (writetype.useReplyMessage()) { // REPLY, REPLYALL, FORWARD
                        bodyValue = getBodyChanged(orgMessage, bodyValue, messagevo.getDefaultFontAndSize(), loginInfo.getOffset(), locale);

                        if (!isReply && attachedFileList.size() > 0) { // FORWARD
                            // replyMessage의 첨부 파일 구성이 orgMessage와 다르게 될 수 있기 때문에 다시 첨부파일 정보를 구하도록 한다.
                            attachedFileList.clear();
                            ezEmailUtil.getBodyInfo(savedMessage, folderPath, uid, -1, attachedFileList, locale, extraMap);
                        }
                    }

                    if (writetype.isEdit()) {
                        messagevo.setTempBody(bodyValue); // (tempBody) EDIT_IN_DRAFTS
                    } else {
                        messagevo.setBodyValue(bodyValue); // (bodyValue) RESEND_IN_SENT, REPLY, REPLYALL, FORWARD
                    }

                    if (!isReply) {
                        String attach = getAttached(attachedFileList, uid);
                        messagevo.setAttach(attach);
                    }

                    // mail option
                    if (writetype.useOrgMailOption()) { // isEdit, isResend
                        setMailOption(writetype, orgMessage, messagevo);
                    }

                    if (writetype.useUnread()) { // RESEND_IN_SENT
                        String unread = orgMessage.isSet(Flags.Flag.SEEN) ? "1" : "0";
                        messagevo.setUnread(unread);
                    }

                    String bodyType = ezEmailUtil.isHtmlMessage(orgMessage) ? "0" : "1";
                    messagevo.setBodyType(bodyType);
                }

                orgFolder.close(true);

                /* 이게 필요한가..? (예약발송수정에 있었음.)
                @SuppressWarnings("unchecked")
                Enumeration<Header> headers = message.getAllHeaders();
                while (headers.hasMoreElements()) {
                Header h = (Header) headers.nextElement();
                logger.debug("@@"+h.getName() + ": " + h.getValue());
                }
                */
            } catch (Exception e) {
                if (e.getMessage().indexOf("NO APPEND failed.") > -1) {
                    messagevo.setOverQuota(true);
                }

                logger.error(e.getMessage(), e);
            }
        };

        ezEmailUtil.useIMAPAccessWithCallback(callback, userAccount, password, locale);
    }

    private Message getMessageToSave(WriteType writetype, Message orgMessage, String userAccount, String password, File emlFile) throws Exception {
        Message messageToSave = null;

        // isReply, FORWARD
        if (writetype.useReplyMessage()) {
            // reply call is needed to create 'References' & 'In-Reply-To' headers.
            try {
                messageToSave = orgMessage.reply(writetype.useReplyAnswered()); // REPLYALL
            // From 주소에 : 과 같은 illegal 문자가 있는 경우 mail.mime.address.strict 속성을 false로 하여도
            // 전체회신을 하면 예외가 발생한다. 이 경우 orgMessage.reply(false)로 대신 호출한다.
            } catch (AddressException e) {
                logger.error(e.getMessage(), e);
                logger.debug("orgMessage.reply failed.");

                messageToSave = orgMessage.reply(false);
            }

            // ANSWERED flag needs to be cleared since the above reply method sets it.
            orgMessage.setFlag(Flags.Flag.ANSWERED, false);

        } else {
            SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
                    userAccount, password);

            // RESEND_IN_SENT
            if (writetype.isResend()) {
                messageToSave = sa.createMimeMessage();
            }

            // RESERVE
            if (writetype.isReserve()) {
                FileInputStream fis = null;

                try {
                    fis = new FileInputStream(emlFile);
                    messageToSave = sa.readMimeMessage(fis); // MimeMessage
                } catch (IOException e) {
                    logger.error("IOException has occurred");
                    logger.error(e.getMessage(), e);
                } finally {
                    if (fis != null) {
                        fis.close();
                    }
                }
            }
        }

        return messageToSave;
    }

    private void setContent(WriteType writetype, Message orgMessage, Message messageToSave) throws Exception {
        boolean includeAttachment = false;
        boolean convertInlineImageToAttachment = false;

        if (writetype.useReplyMessage() && writetype.useAppendAttach()) { // FORWARD
            includeAttachment = true;

            // text/html 파트가 없으면 인라인 이미지 파트를 첨부파일 파트로 변환한다.(이미지를 첨부로 대신 표시하기 위해)
            convertInlineImageToAttachment = !ezEmailUtil.hasHtmlPart(orgMessage);
            logger.debug("convertInlineImageToAttachment=" + convertInlineImageToAttachment);
        }

        boolean isRelated = writetype.isReply()? true : orgMessage.isMimeType("multipart/related");

        if (isRelated) {
            MimeMultipart relatedPart = new MimeMultipart("related");

            if (ezEmailUtil.copyInlineParts(orgMessage, relatedPart, includeAttachment, convertInlineImageToAttachment)) {
                messageToSave.setContent(relatedPart);
            }
            else {
                messageToSave.setText("placeholder");
            }
        }
        else if (orgMessage.isMimeType("multipart/*")) {
            MimeMultipart mixedPart = new MimeMultipart();

            ezEmailUtil.copyAllPartsInMultipart(orgMessage, mixedPart, convertInlineImageToAttachment);

            messageToSave.setContent(mixedPart);
        }
        else {
            messageToSave.setText("placeholder");
        }
    }

    private void saveInDraft(IMAPAccess ia, Message messageToSave, MailWriteProcessVO writevo) throws MessagingException {
        Folder draftsFolder = ia.getFolder(writevo.getDraftsFolderName());
        if (draftsFolder.exists()) {
            draftsFolder.open(Folder.READ_WRITE);

            long draftUID = 0;
            AppendUID[] uids = ((IMAPFolder) draftsFolder).appendUIDMessages(new Message[]{messageToSave});

            if (uids != null && uids[0] != null) {
                draftUID = uids[0].uid;
            }

            writevo.setDraftUID(draftUID);
            logger.debug("draftUID=" + draftUID);

            draftsFolder.close(true);
        }
    }

    private void setAddresses(WriteType writetype, Message orgMessage, Message replyMessage, MailWriteMessageVO messagevo, String msgto, String reciverName, int tenantId) throws Exception {
        // RESEND_IN_SENT: TO만 사용할 경우가 있다.
        if (writetype.isResend()) {
            Optional<Address> toAddress = Arrays.stream(orgMessage.getAllRecipients())
                  .filter(address -> ((InternetAddress) address).getAddress().equalsIgnoreCase(msgto))
                  .findFirst();

            if (toAddress.isPresent()) { // isPresent: 요소가 존재
                String to = ezEmailUtil.getStringListOfAddresses(new Address[]{toAddress.get()}, true);
                messagevo.setTo(to);
                return;
            }

            boolean useReSend = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useReSend", tenantId));
            if (!useReSend) return;

            if (StringUtils.isNotBlank(msgto)) { // 2024.05.24 한슬기 : 수신확인/회수 > 부서메일 회수 후 개인에게 재발송
                String to = reciverName + " <" + msgto + ">";
                messagevo.setTo(to);
                return;
            }
        } // else: 재작성시 메세지에서 수신인을 뽑아내어 넣어준다.

        Address[] addresses = null;
        String to = "";

        //(전체)회신, 재작성 시 수신자에 본인이 들어가지 않게 하기 위해 본인 주소는 제거하나 
        // 예약메일은 기능 상 제거하면 안되기 때문에 isReply, isReserve를 확인하여 분기처리

        // TO
        if (writetype.isReply()) {
            addresses = getRecipientsTOFromReply(writetype, orgMessage, replyMessage);
        } else {
            addresses = orgMessage.getRecipients(Message.RecipientType.TO);
        }

        if (writetype.isReserve()) {
            to = getAddresses(writetype, addresses, orgMessage, "To");
        } else {
            to = getAddresses(writetype, addresses, orgMessage, "From", "To");
        }

        messagevo.setTo(to); // 은실사원1 <eunsil1@svn1.opensol2014.com>

        if (writetype != WriteType.REPLY) {
            // CC : replyMessage와 orgMessage가 동일
            addresses = orgMessage.getRecipients(Message.RecipientType.CC);

            if (addresses != null) { // 꼭 필요한가?
                String cc = getAddresses(writetype, addresses, orgMessage, "Cc");
                messagevo.setCc(cc);
            }

            // BCC
            addresses = orgMessage.getRecipients(Message.RecipientType.BCC);
            String bcc = "";

            if (writetype.isReserve()) { // 문제없으면.. 다 사용하던지 통일했으면 좋겠는데
                bcc = getAddresses(writetype, addresses, orgMessage, "Bcc");
            } else {
                bcc = ezEmailUtil.getStringListOfAddresses(addresses, true);
            }

            messagevo.setBcc(bcc);
        }
    }

    /**
     * : 과 같은 illegal 문자가 있는 경우 replyMessage.getRecipients에서 예외가 발생한다.
     * mail.mime.address.strict 속성을 false로 한 경우 orgMessage.getRecipients에서는 예외가 발생하지 않으나
     * replyMessage.getRecipients에서는 여전히 예외가 발생한다.
     * 이 경우 From 주소와 orgMessage.getRecipients를 통해 직접 응답 메시지의 To 주소를 구한다.
     */
    private Address[] getRecipientsTOFromReply(WriteType writetype, Message orgMessage, Message replyMessage) throws MessagingException {
        Address[] addresses = null;

        setHeaderRemoveMailto(replyMessage, "To");
        setHeaderRemoveMailto(replyMessage, "Cc");

        try {
            // retrieve the TO addresses from the reply message.
            addresses = replyMessage.getRecipients(Message.RecipientType.TO);

        } catch (AddressException e) {
            logger.error(e.getMessage(), e);
            logger.debug("replyMessage.getRecipients TO failed.");

            if (writetype == WriteType.REPLYALL) {
                Address fromAddress = getForm(orgMessage);
                Address[] orgToAddresses = orgMessage.getRecipients(Message.RecipientType.TO);

                addresses = getCombinedFromAndToAddresses(fromAddress, orgToAddresses);
            }
        }

        return addresses;
    }

	private Address[] getCombinedFromAndToAddresses(Address fromAddress, Address[] toAddresses) {
		Address[] combinedAddress = null;
		int count = 0;
		int startIndex = 0;

		if (fromAddress != null) {
			count++;
			startIndex++;
		}

		if (toAddresses != null) {
			count += toAddresses.length;
		}

		if (count > 0) {
			combinedAddress = new Address[count];

			if (fromAddress != null) {
				combinedAddress[0] = fromAddress;
			}

			if (toAddresses != null) {
				for (int i = 0; i < toAddresses.length; i++) {
					combinedAddress[startIndex + i] = toAddresses[i];
				}
			}
		}

		return combinedAddress;
	}

    /**
     * 료비에서 다음과 같은 메일이 와서 메일주소 파싱 시 에러 발생함.
     * 그래서 To, Cc 헤더에서 mailto: 제거하도록 함.
     * To: =?ISO-2022-JP?B?GyRCTj5IdxsoQkhEGyRCNzJHTztZRTkbKEI=?= <mailto:gunma@ryobi-holdings.jp>, 
     * =?ISO-2022-JP?B?GyRCTj5IdyVIJWklcyU5JV0hPCVINzJHTztZRTkbKEI=?= <gunma@ryobi-holdings.jp>
     */
    private void setHeaderRemoveMailto(Message message, String headerKey) throws MessagingException {
        String[] headers = message.getHeader(headerKey);

        if (headers != null) {
            message.setHeader(headerKey, headers[0].replace("mailto:", ""));
        }
    }

    private Address getForm(Message orgMessage) throws MessagingException {
        Address[] fromArray = orgMessage.getFrom();
        return (fromArray != null && fromArray[0] != null)? fromArray[0] : null;
    }

    private String getAddresses(WriteType writetype, Address[] addresses, Message orgMessage, String... headerKeys) {
        String[] headerArray = null;
        boolean isPureAscii = true;

        if (writetype.useCheckForAscii()) { // isResend(), isReply(), isReserve()
            String[] headers = Arrays.stream(headerKeys)
                .map(key -> {
                    String header = "";

                    try {
                        String[] rawHeaders = orgMessage.getHeader(key);
                        header = (rawHeaders != null && rawHeaders.length > 0) ? rawHeaders[0] : "";
                    } catch (MessagingException e) {
                        logger.error("getAddresses exception", e);
                    }

                    return header; // =?UTF-8?B?7J2A7Iuk7IKs7JuQMQ==?= <eunsil1@svn1.opensol2014.com>
                })
                .toArray(String[]::new);

            headerArray = writetype.isReply()? getHeaderArrayIfGb2312(headers) : null;
            isPureAscii = Arrays.stream(headers).allMatch(ezEmailUtil::isPureAscii);
        }

        return ezEmailUtil.getStringListOfAddresses(addresses, headerArray, isPureAscii);
    }

    // GB2312 인코딩된 메일 깨지는 문제 방지
    private String[] getHeaderArrayIfGb2312(String[] headers) {
        boolean isGb2312Encoding = false;

        for (int i = 0; i < headers.length; i++) {
            if (headers[i].contains("=?gb2312")) {
                headers[i] = MimeUtility.unfold(headers[i]);
                logger.debug("gb2312 encoding header=" + headers[i]);

                isGb2312Encoding = true;
            }
        }

        if (!isGb2312Encoding) {
            return null;
        }

        return Arrays.stream(headers)  // headers 배열을 스트림으로 변환
                     .flatMap(header -> Arrays.stream(header.split(",")))  // ','로 분리하여 평탄화
                     .map(String::trim)  // 각 요소에 대해 trim 적용
                     .toArray(String[]::new);  // 결과를 String[]로 변환
    }

    // retrieve the subject from the message.
    private String getSubject(WriteType writetype, Message orgMessage, Locale locale) throws Exception {
        String subject = StringUtils.defaultString(ezEmailUtil.getSubject(orgMessage)); // RESEND_IN_SENT: orgMessage.getSubject(); 설마.. 분기해야함?

        if (writetype.useReplyMessage()) {
            // prefix (회신, 전달)
            String prefix = StringUtils.defaultString(writetype.getPrefixCode());
            prefix = egovMessageSource.getMessage(prefix, locale) + ": ";

            if (StringUtils.isNotBlank(subject)) {
                String[] rawHeaders = orgMessage.getHeader("subject");
                String rawHeader = rawHeaders[0];

                // if the subject contains Non-Ascii characters(violating the standard),
                // try to decode it by examining the characters.
                if (!ezEmailUtil.isPureAscii(rawHeader)) {
                    byte[] rawBytes = rawHeader.getBytes("iso-8859-1");

                    subject = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
                }
            }

            if (!subject.startsWith(prefix.trim())) {
                subject = prefix + subject;
            }
        }

        return subject;
    }

    private String getBodyChanged(Message orgMessage, String tmphtmlbody, String defaultFontAndSize, String offset, Locale locale) throws Exception {
        // retrieve the TO addresses from the original message.
        Address[] addresses = orgMessage.getRecipients(Message.RecipientType.TO);
        String[] rawHeaders = orgMessage.getHeader("To");
        String rawHeader = rawHeaders != null ? rawHeaders[0] : "";
        String orgTo = ezEmailUtil.getStringListOfAddresses(addresses, ezEmailUtil.isPureAscii(rawHeader));

        // retrieve the CC addresses from the original message.
        addresses = orgMessage.getRecipients(Message.RecipientType.CC);
        rawHeaders = orgMessage.getHeader("Cc");
        rawHeader = rawHeaders != null ? rawHeaders[0] : "";
        String orgCc = ezEmailUtil.getStringListOfAddresses(addresses, ezEmailUtil.isPureAscii(rawHeader));

        StringBuilder sb = new StringBuilder();
        sb.append("<hr tabindex=\"-1\">");
        sb.append("<p " + defaultFontAndSize + ">");
        sb.append(String.format("<b>%s : </b> %s", egovMessageSource.getMessage("ezEmail.t703", locale), EgovStringUtil.getSpclStrCnvr(ezEmailUtil.getFullFromAddressOfMessage(orgMessage))));
        sb.append("</p>");

        //set received date
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss ( z )");
        if (offset == null || offset.indexOf("|") == -1) {
            logger.error("Check the offset. Offset is null or offset format is wrong.");
        } else {
            String[] offsetArr = offset.split("\\|");
            sdf.setTimeZone(TimeZone.getTimeZone("GMT" + offsetArr[1]));
        }
        sb.append("<p " + defaultFontAndSize + ">");
        sb.append(String.format("<b>%s : </b> %s", egovMessageSource.getMessage("ezEmail.t704", locale), sdf.format(orgMessage.getReceivedDate()).replace("GMT", "")));
        sb.append("</p>");
        //to-do
        sb.append("<p " + defaultFontAndSize + ">");
        sb.append(String.format("<b>%s : </b> %s", egovMessageSource.getMessage("ezEmail.t705", locale), EgovStringUtil.getSpclStrCnvr(orgTo)));
        sb.append("</p>");

        sb.append("<p " + defaultFontAndSize + ">");
        sb.append(String.format("<b>%s : </b> %s", egovMessageSource.getMessage("ezEmail.t706", locale), EgovStringUtil.getSpclStrCnvr(orgCc)));
        sb.append("</p>");

        String orgMessageSubject = ezEmailUtil.getSubject(orgMessage);
        if (orgMessageSubject != null && !orgMessageSubject.equals("")) {
            rawHeaders = orgMessage.getHeader("subject");
            rawHeader = rawHeaders[0];
            
            // if the subject contains Non-Ascii characters(violating the standard),
            // try to decode it by examining the characters.
            if (!ezEmailUtil.isPureAscii(rawHeader)) {
                byte[] rawBytes = rawHeader.getBytes("iso-8859-1");

                orgMessageSubject = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
            }
        }

        sb.append("<p " + defaultFontAndSize + ">");
        sb.append(String.format("<b>%s : </b> %s", egovMessageSource.getMessage("ezEmail.t707", locale), EgovStringUtil.getSpclStrCnvr(orgMessageSubject)));
        sb.append("</p>");
//      sb.append("<br/><br/>");
        sb.append("<p " + defaultFontAndSize + ">&nbsp;</p>");
        sb.append("<p " + defaultFontAndSize + ">&nbsp;</p>");

        String bodyValue = sb.toString() + tmphtmlbody;

        // 원본 메일 내용에 메일 서명 존재 시 변환 처리
        if (bodyValue.contains("id=\"MailSignSent\"") || bodyValue.contains("id=MailSignSent")) {
            bodyValue = bodyValue.replaceAll("MailSignSent", "MailSignSent___send");
            bodyValue = bodyValue.replaceAll("kaoni_sign1", "kaoni_sign1___send");
            bodyValue = bodyValue.replaceAll("kaoni_sign2", "kaoni_sign2___send");
            bodyValue = bodyValue.replaceAll("kaoni_sign3", "kaoni_sign3___send");
        }
        bodyValue = bodyValue.replaceAll("ORGMAIL_CONTENT", "ORGMAIL_CONTENT___send");
        bodyValue = bodyValue.replaceAll("div id=\"MailSign\"", "div ");

        bodyValue = bodyValue.replaceAll("id=msgbody", "");

        bodyValue = bodyValue.replaceAll("class=&quot;FIELD&quot;", "");
        bodyValue = bodyValue.replaceAll("class=FIELD", "");
        bodyValue = "<body free>" + bodyValue + "</body>";

        return bodyValue;
    }

    /**
     * 첨부파일 정보 추출
     * EDIT_IN_DRAFTS, RESEND_IN_SENT, FORWARD
     */
    private String getAttached(List<Map<String, String>> attachedFileList, long uid) {
        String attach = "";

        if (attachedFileList.size() > 0) {
            StringBuilder attachXmlList = new StringBuilder("<ROOT><NODES>");

            for (int i = 0; i < attachedFileList.size(); i++) {
                Map<String, String> fileInfo = attachedFileList.get(i);

                attachXmlList.append("<NODE>");
                //TODO : <PUPLOADSN>" + (i + 1) + "</PUPLOADSN> 으로 수정(인덱스로 파일 지울 때)
                attachXmlList.append("<PUPLOADSN>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PUPLOADSN>"); // or commonUtil.cleanValue
                attachXmlList.append("<RESULTUPLOADA>true</RESULTUPLOADA>");
                attachXmlList.append("<PFILENAME>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PFILENAME>");
                attachXmlList.append("<FILESIZE>" + fileInfo.get("size") + "</FILESIZE>");
                attachXmlList.append("<FILELOCATION>" + uid + "</FILELOCATION>");
                attachXmlList.append("<PBIGFILEUPLOAD>N</PBIGFILEUPLOAD>");
                attachXmlList.append("</NODE>");
            }

            attachXmlList.append("</NODES></ROOT>");
            attach = attachXmlList.toString();
        }

        return attach;
    }

    private void setMailOption(WriteType writetype, Message orgMessage, MailWriteMessageVO messagevo) throws MessagingException {
        logger.debug("set mail option start");

        //set importance
        if (orgMessage.getHeader("X-Priority") != null) {
            String importance = orgMessage.getHeader("X-Priority")[0];
            if (importance.equals("1")) {
                importance = "2";
            } else if (importance.equals("5")) {
                importance = "0";
            } else {
                importance = "1";
            }

            logger.debug("importance=" + importance);
            messagevo.setImportance(importance);
        }

        //set isEachMail
        if (orgMessage.getHeader("X-JMocha-Each-Mail") != null) {
            String isEach = orgMessage.getHeader("X-JMocha-Each-Mail")[0];
            messagevo.setIsEach(isEach);
        }

        // 추적(배달되면 알림): 현재 옵션제외됨.
        if (orgMessage.getHeader("Return-Receipt-To") != null) {
            messagevo.setReplySendTime("1");
        }

        if (orgMessage.getHeader("X-JMocha-Disp-Noti-To") == null) {
            messagevo.setReplyReadTime("0");
        }

        if (!writetype.isEdit()) {
            logger.debug("set mail option end");
            return;
        }

        //set isSecureMail
        if (orgMessage.getHeader("X-JMocha-Secure-Mail") != null) {
            String isSecureMail = orgMessage.getHeader("X-JMocha-Secure-Mail")[0];
            messagevo.setIsSecureMail(isSecureMail);
            
            if (writetype.isReserve()) {
                String securePassword = orgMessage.getHeader("X-JMocha-Secure-Mail-Password")[0];
    			String secureReadCount = orgMessage.getHeader("X-JMocha-Secure-Mail-ReadCount")[0];
    			String secureReadDate = orgMessage.getHeader("X-JMocha-Secure-Mail-ReadDate")[0];
				
    			// 암호화되어있는 securePassword 복호화
    			String prm = egovFileScrty.getPrm();
            	String pre = egovFileScrty.getPre();
            	PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
            	securePassword = EgovFileScrty.decryptRsa(pk, securePassword);
    			
				logger.debug("securePassword=" + securePassword + ",secureReadCount=" + secureReadCount + ",secureReadDate=" + secureReadDate);
                messagevo.setSecurePassword(securePassword);
                messagevo.setSecureMaxReadCount(secureReadCount);
                messagevo.setSecureMaxReadDate(secureReadDate);
    		}
        }

        if (orgMessage.getHeader("Delivery-Date") != null) {
            String delaySendDate = orgMessage.getHeader("Delivery-Date")[0].trim();
            messagevo.setDelaySendDate(delaySendDate);
        }

        logger.debug("EDIT MODE : set mail option end");
    }

// OPTIONS
    @Override
    public void setDefaultMailOptions(HttpServletRequest request, MailWriteProcessVO writevo, LoginVO loginInfo, String userName, Locale locale) throws Exception {
        // loginInfo
        int tenantId = loginInfo.getTenantId();
		String serverName = loginInfo.getServerName();

		boolean useMailLinkHostname = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useMailLinkHostname", tenantId));
		if (useMailLinkHostname) {
			serverName = StringUtils.defaultIfBlank(ezCommonService.getTenantConfig("mailLinkHostname", tenantId), serverName);
		}

        loginInfo.setServerName(serverName);

        // 메일 기본환경설정
        setMailGeneralVO(writevo, loginInfo.getId(), userName, tenantId, locale);

        // 메일 서명
        MailSignatureVO sign = ezEmailService.getMailSignature(tenantId, writevo.getMailId());
        WriteType writetype = writevo.getWriteType();

        if (sign != null) {
            if (writetype.useOriginalMessage()) {
                sign.setUseFlag("0");
            }

            writevo.setMailSignatureVO(sign);
        }

		//메일 색상 관련 설정
		MailColorVO color = ezEmailService.getMailColor(tenantId);

        if (color != null) {
            writevo.setMailColorVO(color);
            // logger.debug("inMailColor=" + inMailColor + ",outMailColor=" + outMailColor);
        }

        setMailWriteOptionsVO(request, writevo, loginInfo, locale);

        // origin message에 따라 변경 될 수 있는 값.
        setMailWriteMessageVO(writevo, loginInfo.getLang(), tenantId, locale);

        // to: msgto
        if (writetype.useMsgToAsTo()) { // NEW
            writevo.setTo(writevo.getMsgto());
        }

        // to: 운영자에게 메일 보내기
        if (writetype.useOperatorMailAddress()) { // NEW
            String operatorMailAddress = StringUtils.defaultString(request.getParameter("operatorMailAddress"));

            if (StringUtils.isNotBlank(operatorMailAddress)) {
                String to =  egovMessageSource.getMessage("ezEmail.0hun03", locale) + " <" + operatorMailAddress + ">";
                writevo.setTo(to);
            }
        }
    }

    private void setMailGeneralVO(MailWriteProcessVO writevo, String loginId, String userName2, int tenantId, Locale locale) throws Exception {
        MailGeneralVO general = ezEmailService.getMailGeneral(tenantId, loginId).get(0);

        if (general == null) {
            general = writevo.getMailGeneralVO();
        }

        // keepDeleteLength → pAutoSaveTime: 자동 임시저장
		String pAutoSaveTime = StringUtils.defaultIfBlank(general.getKeepDeleteLength(), "0");
        general.setKeepDeleteLength(pAutoSaveTime);

        // mailSenderNm → mailSendObject: 보내는사람이름
		String pMailSenderNM = general.getMailSenderNm();
		String mailSendObject = "<option value='NONE'>" + egovMessageSource.getMessage("ezEmail.t99000032", locale) + "</option>";

		if (pMailSenderNM != null && !pMailSenderNM.trim().equals("")) {
			String[] senderList = pMailSenderNM.split("\\|!\\-@\\-!\\|");

			 for (String pSenderNM : senderList) {
                 if (pSenderNM.startsWith("___")){
                     mailSendObject += "<option value='" + pSenderNM.substring(3) + "' selected>" + pSenderNM.substring(3) + "</option>";
                 } else {
                     mailSendObject += "<option value='" + pSenderNM + "'>" + pSenderNM + "</option>";
                 }
			 }
		}
        general.setMailSenderNm(mailSendObject);

        // previewMail: 발송 전 미리보기
		String previewMail = StringUtils.defaultIfBlank(general.getPreviewMail(), "N");
        general.setPreviewMail(previewMail);

		// 2024.08.07 한슬기 : 메일쓰기화면 기본 커서 위치 설정. (recipient : 밭는사람, content : 내용, subject : 제목 / default : recipient)
		String defaultCursorPosition = StringUtils.defaultIfBlank(general.getDefaultCursorPosition(), "recipient");
        general.setDefaultCursorPosition(defaultCursorPosition);

        // mailSendResult: 메일 발송 결과 표시
		String mailSendResult = StringUtils.defaultIfBlank(general.getMailSendResult(), "failure");
        general.setMailSendResult(mailSendResult);

        // 2025.02.11 한슬기 : 항상 나를 참조에 포함 설정. selfCcOption = none : 사용안함(default) / cc : 나를 항상 참조에 포함 / bcc : 나를 항상 숨은참조에 포함
        String selfCcOption =StringUtils.defaultIfBlank(general.getSelfCcOption(), "none");
        general.setSelfCcOption(selfCcOption);

        writevo.setMailGeneralVO(general);
    }

    private void setMailWriteOptionsVO(HttpServletRequest request, MailWriteProcessVO writevo, LoginVO loginInfo, Locale locale) throws Exception {
        MailWriteOptionsVO options = writevo.getMailWriteOptionsVO();
        WriteType writetype = writevo.getWriteType();
        int tenantId = loginInfo.getTenantId();

		//내게쓰기
		String isMailToMe = "NO";
		if (request.getParameter("isMailToMe") != null) {
			isMailToMe = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(request.getParameter("isMailToMe")));
		}

		options.setIsMailToMe(isMailToMe); // 내게쓰기 버튼 클릭시  checkobx checked

        boolean isCrossBrowser = !"IE9".equalsIgnoreCase(ClientUtil.getClientInfo(request, "browser"));
        options.setIsCrossBrowser(isCrossBrowser);

        // 보안메일
        String useSecureMail = ezCommonService.getTenantConfig("USE_SECUREMAIL", tenantId);
        options.setUseSecureMail(useSecureMail); // 보안메일 사용여부

        // 첨부
        String stateName = UUID.randomUUID().toString();
        options.setStateName(stateName);

        String uploadCommonPath = commonUtil.getUploadPath("upload_common.ROOT", tenantId);
        options.setUploadCommonPath(uploadCommonPath);

        String uploadCommunityPath = commonUtil.getUploadPath("upload_community.ROOT", tenantId);
        options.setUploadCommunityPath(uploadCommunityPath);

        // 파일첨부 제한 관련 변수 설정
		String mailAttachLimit = ezCommonService.getTenantConfig("MailAttachLimit", tenantId);
		String bigSizeMailAttachLimit = ezCommonService.getTenantConfig("BigSizeMailAttachLimit", tenantId);
		String bigSizeAttachLimitCount = ezCommonService.getTenantConfig("MailBigSizeAttachLimitCount", tenantId);
		String bigSizeAttachDownloadLimitCount = ezCommonService.getTenantConfig("MailBigSizeAttachDownloadLimitCount", tenantId);
		String totBigSizeMailAttachLimit = ezCommonService.getTenantConfig("totBigSizeMailAttachLimit", tenantId);
		String bigAttachDownloadDay = ezCommonService.getTenantConfig("BigSizeMailAttachDelDay", tenantId);

		String bigSizeMailAttachDelDate = EgovDateUtil.addDay(EgovDateUtil.getToday("-"), Integer.parseInt(bigAttachDownloadDay), "yyyy-MM-dd");
        String bigAttachDownloadPeriod = EgovDateUtil.getToday("/") + " ~ " + EgovDateUtil.addDay(EgovDateUtil.getToday("/"), Integer.parseInt(bigAttachDownloadDay), "yyyy/MM/dd");
        int bigAttachLimitCount = bigSizeAttachLimitCount == null || bigSizeAttachLimitCount.equals("") ? 0 : Integer.parseInt(bigSizeAttachLimitCount);
        int bigAttachDownloadLimitCount = bigSizeAttachDownloadLimitCount == null || bigSizeAttachDownloadLimitCount.equals("") ? 0 : Integer.parseInt(bigSizeAttachDownloadLimitCount);
        String attachWarning = egovMessageSource.getMessage("ezEmail.lhm18", locale) + mailAttachLimit + egovMessageSource.getMessage("ezEmail.lhm19", locale) 
        	+ totBigSizeMailAttachLimit + egovMessageSource.getMessage("ezEmail.lhm20", locale); // 일반첨부파일은 총 10MB까지 가능하며, 대용량첨부는 800MB까지 가능(

        if(bigAttachLimitCount > 0) {
        	attachWarning += egovMessageSource.getMessageExtend("ezEmail.hdp03", new Object[] {bigAttachLimitCount}, locale) + ", "; // 일반첨부파일은 총 10MB까지 가능하며, 대용량첨부는 800MB까지 가능(최대 1개 첨부,
        }

        if(bigAttachDownloadLimitCount > 0) {
        	attachWarning += egovMessageSource.getMessageExtend("ezEmail.hdp04", new Object[] {bigAttachDownloadLimitCount}, locale) + ", "; // 일반첨부파일은 총 10MB까지 가능하며, 대용량첨부는 800MB까지 가능(최대 1개 첨부, 1회까지 다운로드 가능,
        }

        attachWarning += egovMessageSource.getMessage("ezEmail.lhm69", locale) + bigAttachDownloadDay + egovMessageSource.getMessage("ezEmail.lhm21", locale); // 일반첨부파일은 총 10MB까지 가능하며, 대용량첨부는 800MB까지 가능(최대 1개 첨부, 1회까지 다운로드 가능, 14일간 보관)

        if(totBigSizeMailAttachLimit.equals("0")){
        	attachWarning = egovMessageSource.getMessage("ezEmail.kms01", locale) + mailAttachLimit +egovMessageSource.getMessage("ezEmail.kms02", locale);
        }

		options.setMailAttachLimit(mailAttachLimit);
		options.setBigSizeMailAttachLimit(bigSizeMailAttachLimit);
		options.setTotBigSizeMailAttachLimit(totBigSizeMailAttachLimit);
		options.setBigSizeMailAttachDelDate(bigSizeMailAttachDelDate);
		options.setBigAttachDownloadDay(bigAttachDownloadDay);
		options.setBigAttachDownloadPeriod(bigAttachDownloadPeriod);
		options.setAttachWarning(attachWarning);
		options.setBigSizeAttachLimitCount(bigSizeAttachLimitCount);
		options.setBigSizeAttachDownloadLimitCount(bigSizeAttachDownloadLimitCount);

        // tenant config
        String useApprMail = StringUtils.defaultIfBlank(ezCommonService.getTenantConfig("useApprMail", tenantId), "NO");
        options.setUseApprMail(useApprMail); // 승인메일 기능 사용여부

		String mailInnerDomain = ezCommonService.getTenantConfig("MailInnerDomain", tenantId);
        options.setMailInnerDomain(mailInnerDomain); // 내부 메일도메인

        String useOnlyInnerMail = ezCommonService.getTenantConfig("UseOnlyInnerMail", tenantId);
        options.setUseOnlyInnerMail(useOnlyInnerMail); // 메일 내부망만 사용

		String mailMaxReceiverCount = StringUtils.defaultIfBlank(ezCommonService.getTenantConfig("mailMaxReceiverCount", tenantId), "200");
        options.setMailMaxReceiverCount(mailMaxReceiverCount); // 메일 최대 수신자 수

		String useMailAddrAutoComplete = ezCommonService.getTenantConfig("useMailAddrAutoComplete", tenantId); // 20180531 조진호 추가
        options.setUseMailAddrAutoComplete(useMailAddrAutoComplete); // 쓰기창에서 수신인 자동완성 기능 사용 유무

		boolean useAdditionalInfo = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useMailWriteRecipientAdditional", tenantId));
        options.setUseAdditionalInfo(useAdditionalInfo); // 메일쓰기 수신인 추가 정보 사용여부

		String individualMailUser = ezCommonService.getTenantConfig("INDIVIDUALMAILUSER", tenantId); //int형
        options.setIndividualMailUser(individualMailUser); // 메일 개별발신 최대 인원

		String useEditor = ezCommonService.getTenantConfig("EDITOR", tenantId);
        options.setUseEditor(useEditor); // 에디터 타입

		String useLetter = StringUtils.defaultIfBlank(ezCommonService.getTenantConfig("useLetter", tenantId), "NO");
        options.setUseLetter(useLetter); // 메일 편지지 기능 사용여부

		String useMailWriteSenderClick = StringUtils.defaultIfBlank(ezCommonService.getTenantConfig("useMailWriteSenderClick", tenantId), "NO");
        options.setUseMailWriteSenderClick(useMailWriteSenderClick); // 보낸사람에게 바로 메일보내기 사용

        // HWP 양식작성기
		String useHWP = ezCommonService.getTenantConfig("useHWP", tenantId);
        options.setUseHWP(useHWP);

        String webHWPUrl = ezCommonService.getTenantConfig("webHWPUrl", tenantId); // Whwp api Url
        options.setWebHWPUrl(webHWPUrl);

		String hwpSecurityNum = "";
        String useHwpDownSecurity = ezCommonService.getTenantConfig("useHwpDownSecurity", tenantId);
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", tenantId);

		/* 2023-05-15 김우철 - 한글문서 배포(수정 및 복사 제한)를 위한 배포용 암호 설정 테넌트 컨피그로 추가 */
		if (useHwpDownSecurity.equals("Y") && approvalFlag.equals("G")) {
			hwpSecurityNum = ezCommonService.getTenantConfig("HwpSecurityNum", tenantId);
		}

        options.setUseHwpDownSecurity(useHwpDownSecurity); // hwp 배포용 문서 저장을 위한 테넌트 컨피그
        options.setHwpSecurityNum(hwpSecurityNum); // hwp 배포용 문서 해제를 위한 암호
        options.setApprovalFlag(approvalFlag);

		String moduleEditor = ezCommonService.getTenantConfig("MODULEEDITOR", tenantId);
        options.setModuleEditor(moduleEditor);

    // [module options]
		// 닷넷 여부
		if (writetype.isDotNet()) { // BOARDDOTNET, COMMUNITYDOTNET, DOCSENDDOTNET
			String dotNetUrl = ezCommonService.getTenantConfig("dotNetUrl", tenantId);
            options.setDotNetUrl(dotNetUrl);
		}

		switch (writetype) {
			// in case of board/Community
			case BOARD:
			case BOARDDOTNET:
			case COMMUNITY:
			case COMMUNITYDOTNET:
				String boardID = StringUtils.defaultString(request.getParameter("boardID"));
                options.setBoardID(boardID);
				String itemID = StringUtils.defaultString(request.getParameter("itemID"));
                options.setItemID(itemID);
				String retransType = StringUtils.defaultString(request.getParameter("retransType"));
                options.setRetransType(retransType);
				break;

			// in case of approvalG
			case DOCSEND:
			case DOCSENDDOTNET:
				String docHref = StringUtils.defaultString(request.getParameter("docHref")).trim();
                options.setDocHref(docHref);
				String docID = StringUtils.defaultString(request.getParameter("docID")).trim();
                options.setDocID(docID);
				String docImagCnt = StringUtils.defaultString(request.getParameter("imagCnt")).trim();
                options.setDocImagCnt(docImagCnt);
				String docTarget = StringUtils.defaultString(request.getParameter("target")).trim();
                options.setDocTarget(docTarget);
				String docType = StringUtils.defaultString(request.getParameter("docType")).trim();
                options.setDocType(docType);
				String orgCompanyID = StringUtils.defaultString(request.getParameter("orgCompanyID")).trim();
                options.setOrgCompanyID(orgCompanyID);
				break;

			// 업무일지
			case JOURNAL:
				String journalId = request.getParameter("journalId");
                options.setJournalId(journalId);
				break;

			// ezPMS
			case EZPMS:
                String projectId = request.getParameter("projectId");
                options.setEzPMSProjectId(projectId);
				String pmsRoleId = request.getParameter("roleId");
                options.setPmsRoleId(pmsRoleId);
				String pmsType = request.getParameter("type");
                options.setPmsType(pmsType);
                options.setModuleType("ezPMS");
				String pmsToUserId = request.getParameter("toUserId");
                options.setPmsToUserId(pmsToUserId);
				String pmsUserIdType = request.getParameter("userIdType");
                options.setPmsUserIdType(pmsUserIdType);
				String pmsTaskId = request.getParameter("taskId");
                options.setPmsTaskId(pmsTaskId);
				break;

            // ezPMS 게시판
            case EZPMSBOARD:
                String ezPMSProjectId = request.getParameter("ezPMSProjectId");
                options.setEzPMSProjectId(ezPMSProjectId);
                String ezPMSBoardId = request.getParameter("ezPMSBoardId");
                options.setEzPMSBoardId(ezPMSBoardId);
                break;

			// 근태관리
			case ATTITUDE:
				String attitudeId = request.getParameter("attitudeId");
                options.setAttitudeId(attitudeId);
				break;

			// 근태관리 미입력자 메일발송
			case ATTITUDEABSENTED:
                options.setModuleType("attitudeAbsented");
				String companyId = request.getParameter("companyId");
                options.setCompanyId(companyId);
				String searchUserName = request.getParameter("userName");
                options.setSearchUserName(searchUserName);
				String searchDeptName = request.getParameter("deptName");
                options.setSearchDeptName(searchDeptName);
				String searchTitle = request.getParameter("title");
                options.setSearchTitle(searchTitle);
				String searchDeptId = request.getParameter("deptId");
                options.setSearchDeptId(searchDeptId);
				String searchStartDate = request.getParameter("startDate");
                options.setSearchStartDate(searchStartDate);
				String searchEndDate = request.getParameter("endDate");
                options.setSearchEndDate(searchEndDate);
//				String pageNum = request.getParameter("pageNum");
//				String listSize = request.getParameter("listSize");
//				String orderCell = request.getParameter("orderCell");
//				String orderOption = request.getParameter("orderOption");
				break;

            // 투표
            case POLL:
                String to = getToForPoll(request, options, loginInfo); // set options
                writevo.setTo(to); // setTo를 하긴 하지만, POLL은 origin message를 사욯하지 않기 때문에, 바뀔 우려가 현재까진 없다.
                break;
        }
    }

    private void setMailWriteMessageVO(MailWriteProcessVO writevo, String userLang, int tenantId, Locale locale) throws Exception {
        MailWriteMessageVO message = writevo.getMailWriteMessageVO();
        MailGeneralVO general = writevo.getMailGeneralVO();
        WriteType writetype = writevo.getWriteType();

        String bodyType = !writetype.ignoreTextOption() && "PLAIN".equalsIgnoreCase(general.getTextOption())? "1" : "0";
        message.setBodyType(bodyType); // useLoadFromOrigin()> bodyType 변경될 수 있음.

        // 2024.08.07 한슬기 :  개별발신 기본 사용 여부(Y : 개별발신, N : 사용안함 default:N)
        boolean useEachMailDefault = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useEachMailDefault", tenantId)); // 관리자 > 시스템 > 패러메터 개별발신 사용여부 "예"
        boolean defaultSeparateSend = "Y".equalsIgnoreCase(StringUtils.defaultIfBlank(general.getDefaultSeparateSend(), "N")); // 사용자 설정
        message.setIsEach((useEachMailDefault || defaultSeparateSend)? "true" : "FALSE"); // EDIT에서 변경될 수 있음.

        String defaultFontAndSize = getDefaultFontAndSize(general, userLang, tenantId, locale);
        message.setDefaultFontAndSize(defaultFontAndSize); // useReplyMessage()> setBodyChanged()에 쓰임.

        boolean isDefaultReceiptExternal = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("isDefaultReceiptExternal", tenantId));
        boolean useReceiptExternal = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useReceiptExternal", tenantId));
        message.setReplyReadTime(useReceiptExternal && isDefaultReceiptExternal? "2" : "1"); // EDIT에서 변경될 수 있음.

        // writevo.setMailWriteMessageVO(message);
    }

    private String getDefaultFontAndSize(MailGeneralVO general, String userLang, int tenantId, Locale locale) throws Exception {

        String fontFamily = egovMessageSource.getMessage("main.t246", locale);
        String fontSize = "10pt";
        
        // 사용자가 환경설정에서 설정한 에디터 폰트 및 크기가 있으면 그 값을 사용하고, 없으면 관리자페이지에서 설정한 값 사용
        String editorFontStyle = ezCommonService.getTenantConfig("editorFontStyle", tenantId);
        if (StringUtils.isNotBlank(editorFontStyle)) {
            fontFamily = editorFontStyle.split("\\|")[0];
            fontSize = editorFontStyle.split("\\|")[1];
        }
        
        fontFamily = StringUtils.defaultIfBlank(general.getEditorFontFamily(), fontFamily);
        fontSize = StringUtils.defaultIfBlank(general.getEditorFontSize(), fontSize);
        
        String defaultFontAndSize = "style='font-size:" + fontSize + ";font-family:" + fontFamily + "'";
        
        logger.debug("defaultFontAndSize=" + defaultFontAndSize);
        return defaultFontAndSize;
    }

    // POLL (투표)
    private String getToForPoll(HttpServletRequest request, MailWriteOptionsVO options, LoginVO loginInfo) throws Exception{
        String userPrimary = loginInfo.getPrimary();
        int tenantId = loginInfo.getTenantId();

        ObjectMapper om = new ObjectMapper();
        String type = StringUtils.defaultString(request.getParameter("type"));
        String folderDate = EgovDateUtil.getToday("");
        String pollSendType = "";
        String to = "";

        // in case of only one user
        if (type.equals("one")) {
            String userID = StringUtils.defaultString(request.getParameter("userId"));
            LoginVO receivedUser = loginService.selectReceiver(userID, tenantId);
            PollEmailSimpleUser simpleUserVO = new PollEmailSimpleUser();
            simpleUserVO.setEmail(receivedUser.getEmail());

            if (userPrimary.equals("1")) {
                simpleUserVO.setUserName(receivedUser.getDisplayName1());
            }
            else {
                simpleUserVO.setUserName(receivedUser.getDisplayName2());
            }

            to = om.writeValueAsString(simpleUserVO);
            pollSendType = "one";
        }
        else if (type.equals("group")) {
            String state = request.getParameter("state") == null ? "" : request.getParameter("state");
            int qstId = Integer.parseInt(request.getParameter("qstId"));
            List<PollEmailSimpleUser> listSimpleUser = new ArrayList<PollEmailSimpleUser>();

            switch (state) {
                case "voted":
                    int optId =	Integer.parseInt(request.getParameter("optId"));
                    listSimpleUser = getListSimpleUsers(qstId, optId, tenantId, userPrimary);
                    break;
                case "seen":
                    listSimpleUser = getListSimpleUsers(loginInfo, qstId, tenantId, userPrimary, 1);
                    break;
                case "unseen":
                    listSimpleUser = getListSimpleUsers(loginInfo, qstId, tenantId, userPrimary, 0);
                    break;
                case "notjoin":
                    listSimpleUser = getListSimpleUsers(loginInfo, qstId, tenantId, userPrimary);
                    break;
            }

            to = om.writeValueAsString(listSimpleUser);
            pollSendType = "list";
        }

        options.setModuleType("poll");
        options.setFolderDate(folderDate);
        options.setPollSendType(pollSendType);

        return to;
    }

    private List<PollEmailSimpleUser> getListSimpleUsers(int qstId, int optId, int tenantId, String userPrimary) throws Exception {
        List<PollEmailSimpleUser> listSimpleUser = new ArrayList<PollEmailSimpleUser>();
        List<PollUserAnswerVO> listOfVotedUsersForAnswer = ezPollService.getListVotedUsersForAnswer(optId, qstId, tenantId);

        for (PollUserAnswerVO userAnswer: listOfVotedUsersForAnswer) {
            LoginVO receivedUser = loginService.selectReceiver(userAnswer.getUserId(), tenantId);
            PollEmailSimpleUser simpleUserVO = new PollEmailSimpleUser();
            simpleUserVO.setEmail(receivedUser.getEmail());

            if (userPrimary.equals("1")) {
                simpleUserVO.setUserName(receivedUser.getDisplayName1());
            }
            else {
                simpleUserVO.setUserName(receivedUser.getDisplayName2());
            }

            listSimpleUser.add(simpleUserVO);
        }

        return listSimpleUser;
    }

    private List<PollEmailSimpleUser> getListSimpleUsers(LoginVO loginVO, int qstId, int tenantId, String userPrimary, int mode) throws Exception {
        List<PollEmailSimpleUser> listSimpleUser = new ArrayList<PollEmailSimpleUser>();
        List<LoginVO> listofSeenUsers = new ArrayList<LoginVO>();
        //Get all of seen users
        List<String> listOfSeenUsers = ezPollService.getNumberOfSeenUsers(qstId, tenantId);

        for (String _userID : listOfSeenUsers) {
            LoginVO user = loginService.selectReceiver(_userID, tenantId);
            listofSeenUsers.add(user);
        }

        if (mode == 0) {
            //Get all related users for this question
            Set<LoginVO> setOfUserIds = new HashSet<LoginVO>();
            ezPollService.getAllUserForQuestion(loginVO, qstId, setOfUserIds);
            List<LoginVO> listofUnseenUsers = new ArrayList<LoginVO>(setOfUserIds);

            listofUnseenUsers.removeAll(listofSeenUsers);

            for (LoginVO receivedUser: listofUnseenUsers) {
                PollEmailSimpleUser simpleUserVO = new PollEmailSimpleUser();
                simpleUserVO.setEmail(receivedUser.getEmail());

                if (userPrimary.equals("1")) {
                    simpleUserVO.setUserName(receivedUser.getDisplayName1());
                }
                else {
                    simpleUserVO.setUserName(receivedUser.getDisplayName2());
                }

                listSimpleUser.add(simpleUserVO);
            }
        }
        else {
            for (LoginVO receivedUser: listofSeenUsers) {
                PollEmailSimpleUser simpleUserVO = new PollEmailSimpleUser();
                simpleUserVO.setEmail(receivedUser.getEmail());

                if (userPrimary.equals("1")) {
                    simpleUserVO.setUserName(receivedUser.getDisplayName1());
                }
                else {
                    simpleUserVO.setUserName(receivedUser.getDisplayName2());
                }

                listSimpleUser.add(simpleUserVO);
            }
        }

        return listSimpleUser;
    }

    private List<PollEmailSimpleUser> getListSimpleUsers(LoginVO loginVO, int qstId, int tenantId, String userPrimary) throws Exception {
        List<PollEmailSimpleUser> listSimpleUser = new ArrayList<PollEmailSimpleUser>();
        //Get all users for this question
        Set<LoginVO> setOfUserIds = new HashSet<LoginVO>();
        ezPollService.getAllUserForQuestion(loginVO, qstId, setOfUserIds);
        List<LoginVO> listOfUnvotedUsers = new ArrayList<LoginVO>(setOfUserIds);

        //Get list of users and their answers
        List<PollUserAnswerVO> listOfPollUserAndAnswer = ezPollService.getPollUserAndAnswer(qstId, tenantId);

        //Get list of voted users
        List<String> listOfAnsweredUsers = new ArrayList<String>();

        for (PollUserAnswerVO pollUserAndAnswer : listOfPollUserAndAnswer) {
            if (!listOfAnsweredUsers.contains(pollUserAndAnswer.getUserId())) {
                listOfAnsweredUsers.add(pollUserAndAnswer.getUserId());
            }
        }

        Iterator<LoginVO> iterator = listOfUnvotedUsers.iterator();

        while (iterator.hasNext()) {
            LoginVO user = iterator.next();

            if (listOfAnsweredUsers.contains(user.getId())) {
                iterator.remove();
            }
        }

        for (LoginVO receivedUser: listOfUnvotedUsers) {
            PollEmailSimpleUser simpleUserVO = new PollEmailSimpleUser();
            simpleUserVO.setEmail(receivedUser.getEmail());

            if (userPrimary.equals("1")) {
                simpleUserVO.setUserName(receivedUser.getDisplayName1());
            }
            else {
                simpleUserVO.setUserName(receivedUser.getDisplayName2());
            }

            listSimpleUser.add(simpleUserVO);
        }

        return listSimpleUser;
    }

    /**
     * overwrite
     * 추후 필요한 값이 많아지면, String userMail, int tenantId 대신 LoginVO loginVO, OrganUserVO userInfo 해도 됨.
     */
    @Override
    public void setOverwriteMailOptions(MailWriteProcessVO writevo, String userMail, int tenantId, String companyId) throws Exception {
        // from Address list - alias메일주소, 공용배포그룹주소
        String useFromAddress = StringUtils.defaultIfBlank(ezCommonService.getTenantConfig("Use_FromAddress", tenantId), "NO");
        String useDistributionSender = StringUtils.defaultIfBlank(ezCommonService.getCompanyConfig(tenantId, companyId, "useDistributionSender"), "NO");

        if ("YES".equalsIgnoreCase(useFromAddress) || "YES".equalsIgnoreCase(useDistributionSender)) {
            setFromAddress(writevo, userMail, tenantId, companyId, useFromAddress, useDistributionSender);
        }
    }

    private void setFromAddress(MailWriteProcessVO writevo, String userMail, int tenantId, String companyId, String useFromAddress, String useDistributionSender) throws Exception {
        //String fromAddressHtml = "";
        List<String[]> fromAddressList = new ArrayList<>();
        MailWriteOptionsVO options = writevo.getMailWriteOptionsVO();
        
        fromAddressList = ezEmailService.getAliasAddress(writevo.getMailId(), tenantId, useFromAddress, useDistributionSender);
        
        // 공용배포그룹주소 사용만 YES인 경우에는 primary mail 주소를 jgw에서 가져오지 않기 때문에 추가 함
        if ("NO".equalsIgnoreCase(useFromAddress) && "YES".equalsIgnoreCase(useDistributionSender)) {
            fromAddressList.add(0, new String[]{userMail,"",""});
        }

        if (fromAddressList.size() < 2) {
            useFromAddress = "NO";
            useDistributionSender = "NO";
        } 
            /* html을 backend에서 만들어 보내지 않고 frontend에서 처리하는 방식으로 변경하여 주석 처리 함
            else {
                StringBuilder sb = new StringBuilder();
                sb.append("<select id='ex_select' onchange='fromAddressChange(this.value)'>");

                boolean isValidFrom = false;
                String from = writevo.getFrom();

                for (String[] address : fromAddressList) {
                    if (from.equals(address[0])) {
                        isValidFrom = true;
                        break;
                    }
                }

                if (!isValidFrom) {
                    from = userMail; // mailId == userInfo.getMail()?
                }

                for (String[] address : fromAddressList) {
                    if (from.equals(address[0])) {
                        sb.append("<option value='" + address[0] + "' selected>" + address[0] + "</option>");
                    } else {
                        sb.append("<option value='" + address[0] + "'>" + address[0] + "</option>");
                    }
                }

                sb.append("</select>");
                sb.append("<label for='ex_select'>" + from + "</label>"); // from: 여기서 사용하고 끝.

                fromAddressHtml = sb.toString();
            }*/

        options.setUseFromAddress(useFromAddress);
        options.setUseDistributionSender(useDistributionSender);
        options.setFromAddressList(fromAddressList);
        writevo.setFrom(userMail);
        
    }
}
