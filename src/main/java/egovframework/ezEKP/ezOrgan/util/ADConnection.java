package egovframework.ezEKP.ezOrgan.util;

import java.util.Hashtable;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ADConnection {
	
	private static final Logger logger = LoggerFactory.getLogger(ADConnection.class);
	
    @Autowired
    private Properties config;
    	
	public ADConnection() throws Exception {
		
	}	
	
	public DirContext setConnection() throws Exception {
		logger.debug("setConnection started.");
		
		/**
		 * AD 접속을 위한 서버 정보 입력
		 * */		
//    	String address = "10.0.100.185";
//    	String security = "administrator@syl2017.dev";
//    	String passwd = "P@ssw0rd";
		
    	String address = config.getProperty("config.PROVIDER_URL");
    	String security = config.getProperty("config.SECURITY_PRINCIPAL");
    	String passwd = config.getProperty("config.SECURITY_CREDENTIALS");
    	
    	logger.debug("=======AD Connection=======");
    	logger.debug(address);
    	logger.debug(security);
    	logger.debug(passwd);
    	logger.debug("===========================");

    	Hashtable<String, String> env = new Hashtable<String, String>();
    	
    	env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
    	env.put(Context.PROVIDER_URL, "ldaps://" + address + ":636");
    	env.put(Context.SECURITY_AUTHENTICATION, "simple");
    	env.put(Context.SECURITY_PRINCIPAL, security);
    	env.put(Context.SECURITY_CREDENTIALS, passwd);
    	env.put(Context.SECURITY_PROTOCOL, "ssl");
    	// SSL 인증을 패스하기 위한 부분
    	env.put("java.naming.ldap.factory.socket", "egovframework.ezEKP.ezOrgan.util.MySSLSocketFactory"); // SSL 인증을 거치지 않고 사용

    	DirContext ctx = new InitialDirContext(env);
    	logger.debug("AD server connections is sucess.");
    	
    	logger.debug("setConnection started.");
    	return ctx;
	}
}
