package egovframework.ezEKP.ezTalkGate.util;

import java.util.Base64;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/**
 * @Description ezTalkGate 모듈에서 사용하는 유틸리티 클래스
 * @author dhlee
 *
 */
@Component
public class EzTalkGateUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzTalkGateUtil.class);
	
	private static final String apb = "BEE6A8052A1BAD5BB1E40F4C0F8B1FD2";
    private static final String iv = "5F1F6B63AAA65002";

	public String encryptEzTalkAES(String s) throws Exception {               	
        SecretKeySpec skeySpec = new SecretKeySpec(apb.getBytes("UTF-8"), "AES");            

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec, new IvParameterSpec(iv.getBytes("UTF-8")));

        byte[] encryptedData = cipher.doFinal(s.getBytes("UTF-8"));
        
        return Base64.getEncoder().encodeToString(encryptedData);
    }     

	public String decryptEzTalkAES(String s) throws Exception {               	
        SecretKeySpec skeySpec = new SecretKeySpec(apb.getBytes("UTF-8"), "AES");            

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.DECRYPT_MODE, skeySpec, new IvParameterSpec(iv.getBytes("UTF-8")));

        byte[] byteData = Base64.getDecoder().decode(s);
        
        byte[] decryptedData = cipher.doFinal(byteData);
                                
        return new String(decryptedData, "UTF-8");
    }     
	
}
