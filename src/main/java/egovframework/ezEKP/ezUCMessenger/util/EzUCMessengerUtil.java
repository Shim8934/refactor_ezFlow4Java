package egovframework.ezEKP.ezUCMessenger.util;

import java.util.Base64;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/**
 * @Description ezUCMessenger 모듈에서 사용하는 유틸리티 클래스
 * @author skyblue0o0
 *
 */
@Component
public class EzUCMessengerUtil {
	private static final Logger logger = LoggerFactory.getLogger(EzUCMessengerUtil.class);
	
	private static final String APB = "S0LKK1EAY021BOH1LNY3U8O3E7MI00I0";
    private static final String IV = "S2H1S4GU5S7E7H3D";

    /**
	 * 아이디와 패스워드를 조합하여 만든 암호화된 문자열 리턴.
	 * 
	 * @param id 아이디
	 * @param pw 패스워드
	 * @return 암호화된 문자열 리턴, exception 발생 시 null 리턴
	 */
	public String encryptId(String id, String pw) {
		String result = null;
		
		try {
			result = id + ":" + pw + ":" + System.currentTimeMillis();
			result = encryptAES(result);
		} catch (Exception e) {
			result = null;
			e.printStackTrace();
		}
		
		return result;
	}
    
	public String encryptAES(String s) throws Exception {               	
        SecretKeySpec skeySpec = new SecretKeySpec(APB.getBytes("UTF-8"), "AES");            

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec, new IvParameterSpec(IV.getBytes("UTF-8")));

        byte[] encryptedData = cipher.doFinal(s.getBytes("UTF-8"));
        
        return Base64.getEncoder().encodeToString(encryptedData);
    }
	
	public String decryptAES(String s) throws Exception {               	
        SecretKeySpec skeySpec = new SecretKeySpec(APB.getBytes("UTF-8"), "AES");            

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.DECRYPT_MODE, skeySpec, new IvParameterSpec(IV.getBytes("UTF-8")));

        byte[] byteData = Base64.getDecoder().decode(s);
        byte[] decryptedData = cipher.doFinal(byteData);
                                
        return new String(decryptedData, "UTF-8");
    }
	
}
