package egovframework.ezEKP.ezEmail.logic;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SMTPAccess {
	
	private static final Logger logger = LoggerFactory.getLogger(IMAPAccess.class);
	
	private String host;
	private String port;
	private String userName;
	private String password;
	private Session session;
	private final int TIMEOUT = 20000;
	
	private SMTPAccess(String host, String port, String userName, String password){
		this.host = host;
		this.port = port;
		this.userName = userName;
		this.password = password;
	}
	
	public static SMTPAccess getInstance(String host, String port, String username, String password){
		return new SMTPAccess(host, port, username, password);
	}
	
	private Session getSession(){
		if(session != null){
			return session;
		}
		Properties props = new Properties();
	    props.put("mail.smtp.auth", "true");
	    props.put("mail.smtp.starttls.enable", "true");
	    props.put("mail.smtp.host", host);
	    props.put("mail.smtp.port", port);
	    
	    props.put("mail.smtp.connectiontimeout", TIMEOUT);
	    props.put("mail.smtp.writetimeout", TIMEOUT);
	    
	    Session session = Session.getInstance(props, new javax.mail.Authenticator() {
	    	protected PasswordAuthentication getPasswordAuthentication() {
	    		return new PasswordAuthentication(userName, password);
	    	}
	    });
	    return session;
	}
	
	public MimeMessage createMimeMessage(){
		MimeMessage message = new MimeMessage(getSession()) {
			
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
		MimeMessage message = new MimeMessage(getSession(), is);
		return message;
	}
	
	public void sendMessage(Message message){
		try {
			Transport.send(message);
		} catch (MessagingException e) {
			e.printStackTrace();
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
