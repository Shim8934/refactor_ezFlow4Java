package egovframework.ezEKP.ezUCMessenger.util;

import java.util.Base64;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * @Description ezUCMessenger 모듈에서 사용하는 유틸리티 클래스
 * @author skyblue0o0
 *
 */
@Component
public class EzUCMessengerUtil {
	private static final Logger logger = LoggerFactory.getLogger(EzUCMessengerUtil.class);
	
	//AES128로 변경
//	private static final String APB = "S0LKK1EAY021BOH1LNY3U8O3E7MI00I0";
	@Value("#{cryptos['EzUCMessengerUtil.apb']}")
	private String APB;
    private static final String IV = "S2H1S4GU5S7E7H3D";
    
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
