package egovframework.ezEKP.ezEmail.logic;

import java.io.InputStream;
import java.security.GeneralSecurityException;
import java.util.Optional;
import java.util.Properties;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.MimeMessage;

import com.sun.mail.util.MailSSLSocketFactory;

public class SMTPAccess {
	
	private static final Logger logger = LoggerFactory.getLogger(SMTPAccess.class);

	private String host;
	private String port;
	private String userName;
	private String password;
	private String primary;
	private boolean usingAuth = true;
	private Session session;
	private final int TIMEOUT = 20000;

	private SMTPAccess(String host, String port, String userName, String password, String primary, boolean usingAuth) {
		this.host = host;
		this.port = port;
		this.userName = userName;
		this.password = password;
		this.primary = primary;
		this.usingAuth = usingAuth;
	}
	
	private SMTPAccess(String host, String port, String userName, String password, boolean usingAuth) {
		this.host = host;
		this.port = port;
		this.userName = userName;
		this.password = password;
		this.usingAuth = usingAuth;
	}
	
	public static SMTPAccess getNotAuthInstance(String host, String port, String username, String password, String primary) {
		return new SMTPAccess(host, port, username, password, primary, false);
	}
	
	public static SMTPAccess getInstance(String host, String port, String username, String password) {
		return new SMTPAccess(host, port, username, password, true);
	}

	public static SMTPAccess getInstance(String host, String port, String username, String password, String primary) {
		return new SMTPAccess(host, port, username, password, primary,true);
	}
	
	private Session getSession(){
		if (session != null) {
			return session;
		}

		Properties props = new Properties();
		try {
		    props.put("mail.smtp.starttls.enable", "false");
		    props.put("mail.smtp.host", host);
		    props.put("mail.smtp.port", port);
			Optional.ofNullable(primary)
					.filter(StringUtils::isNotBlank)
					.ifPresent(mail -> props.put("mail.smtp.from", mail));
		    
		    if (port.equals("465")) {
		    	MailSSLSocketFactory sf = new MailSSLSocketFactory();
		    	sf.setTrustAllHosts(true);
		    	
		    	props.put("mail.smtp.ssl.enable", "true");
		    	props.put("mail.smtp.ssl.trust", "*");
		    	props.put("mail.smtp.ssl.socketFactory", sf);
		    }
		    
		    props.put("mail.smtp.connectiontimeout", TIMEOUT);
		    props.put("mail.smtp.writetimeout", TIMEOUT);
	
			if (usingAuth) {
				props.put("mail.smtp.auth", "true");
	
				return Session.getInstance(props, new javax.mail.Authenticator() {
					protected PasswordAuthentication getPasswordAuthentication() {
						return new PasswordAuthentication(userName, password);
					}
				});
			}
		} catch (RuntimeException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		return Session.getInstance(props);
	}
	
	public MimeMessage createMimeMessage(){
		MimeMessage message = new MimeMessage(getSession()) {
			
		    // 메시지를 전송할 때 보낸 편지함에 저장되는 메시지와 다른 Message-ID가 새로
		    // 생성되어 발송되는 문제가 있어 Message-ID가 이미 있는 경우에는 새로운 Message-ID로
		    // 갱신하지 못하도록 함(메일 회수를 위해 필요한 조치).
			@Override
			protected void updateMessageID() throws MessagingException {
				if (getHeader("Message-ID") == null) {
					super.updateMessageID();
				}
			}
			
		};
		
		return message;
	}
	
	public MimeMessage readMimeMessage(InputStream is) throws Exception{
		MimeMessage message = new MimeMessage(getSession(), is) {
			
		    // 메시지를 전송할 때 보낸 편지함에 저장되는 메시지와 다른 Message-ID가 새로
		    // 생성되어 발송되는 문제가 있어 Message-ID가 이미 있는 경우에는 새로운 Message-ID로
		    // 갱신하지 못하도록 함(메일 회수를 위해 필요한 조치).
			@Override
			protected void updateMessageID() throws MessagingException {
				if (getHeader("Message-ID") == null) {
					super.updateMessageID();
				}
			}
			
		};
		
		return message;
	}
	
	public void sendMessage(Message message){
		try {
			Transport.send(message);
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		}
	}
	
	public void sendMessageWithNewTransport(Message message) throws MessagingException {
		Transport t = getSession().getTransport("smtp");
		
		try {
			t.connect(userName, password);
			t.sendMessage(message, message.getAllRecipients());
		}
		finally {
			t.close();
		}		
	}
	
}
