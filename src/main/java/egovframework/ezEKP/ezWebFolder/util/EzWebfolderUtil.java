package egovframework.ezEKP.ezWebFolder.util;

import java.util.Base64;
import java.util.UUID;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/**
 * @Description ezWebfolder 모듈에서 사용하는 유틸리티 클래스
 * @author yy9320
 *
 */
@Component("EzWebFolderUtil")
public class EzWebfolderUtil {
	private static final Logger logger = LoggerFactory.getLogger(EzWebfolderUtil.class);
	
	private static final String apb = "BEE6A8052A1BAD5BB1E40F4C0F8B1FD2";
    private static final String iv = "5F1F6B63AAA65002";

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
	
	/**
	 * UUID 랜덤 생성으로 앞 두 글자로 폴더를 만들어서 해쉬 구조의 파일 경로로 반환
	 * 
	 * @param extension
	 *            파일 확장자 (nullable)
	 * @return 3/1/313cf7f1-dd64-45d7-b9e6-c405e6a2a35f
	 */
	public String generateFilePath(String extension) {
		String result = UUID.randomUUID().toString();

		result = result.charAt(0) + "/" + result.charAt(1) + "/" + result;

		// .none 확장자일 때 확장자 안 붙임
		// 이유: 확장자가 없는 파일이 업로드 될 때 .none 으로 데이터베이스 FILE_EXT 컬럼에 들어감
		if (extension == null || extension.trim().isEmpty() || extension.equals(".none")) {
			return result;
		}

		return result + "." + extension;
	}
}