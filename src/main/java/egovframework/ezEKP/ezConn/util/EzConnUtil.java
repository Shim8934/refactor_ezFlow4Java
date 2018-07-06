package egovframework.ezEKP.ezConn.util;

import java.util.Base64;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/**
 * @Description ezConn 모듈에서 사용하는 유틸리티 클래스
 * @author skyblue0o0
 *
 */
@Component("EzConnUtil")
public class EzConnUtil {
	private static final Logger logger = LoggerFactory.getLogger(EzConnUtil.class);
	
	private static final String apb = "SEK6Y8B5LAUBED0BO1040F4C0F8B1FD2";
    private static final String iv = "HFYFOBM3IAN6G092";

	public String encryptAES(String s) throws Exception {
        SecretKeySpec skeySpec = new SecretKeySpec(apb.getBytes("UTF-8"), "AES");
        
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec, new IvParameterSpec(iv.getBytes("UTF-8")));
        
        byte[] encryptedData = cipher.doFinal(s.getBytes("UTF-8"));
        
        return Base64.getEncoder().encodeToString(encryptedData);
    }

	public String decryptAES(String s) throws Exception {
        SecretKeySpec skeySpec = new SecretKeySpec(apb.getBytes("UTF-8"), "AES");
        
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.DECRYPT_MODE, skeySpec, new IvParameterSpec(iv.getBytes("UTF-8")));
        
        byte[] byteData = Base64.getDecoder().decode(s);
        byte[] decryptedData = cipher.doFinal(byteData);
        
        return new String(decryptedData, "UTF-8");
    }
	
	/** 전자결재 일괄결재 시 서버측 연동동작 
	 *  필요한 method 만들어두고 reflection써서 사용
	 *  
	 * */
	
	private String docID;
    private String userID;
    private String companyID;
    private int tenantID;
    
    public void connTest() throws Exception {
    	logger.debug("connTest started.");
    	
    	logger.debug("docID = " + docID + " || userID = " + userID + " || companyID = " + companyID + " || tenantID = " + tenantID);
    	
    	logger.debug("connTest ended.");
    }

	public String getDocID() {
		return docID;
	}

	public void setDocID(String docID) {
		this.docID = docID;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getCompanyID() {
		return companyID;
	}

	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}

	public int getTenantID() {
		return tenantID;
	}

	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
}
