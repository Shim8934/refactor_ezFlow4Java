package egovframework.let.utl.sim.service;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.math.BigInteger;
import java.security.KeyFactory;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.RSAPrivateKeySpec;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
/**
 * Base64인코딩/디코딩 방식을 이용한 데이터를 암호화/복호화하는 Business Interface class
 * @author 공통서비스개발팀 박지욱
 * @since 2009.01.19
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.01.19  박지욱          최초 생성
 *   2011.08.31  JJY            경량환경 템플릿 커스터마이징버전 생성
 *
 * </pre>
 */
public class EgovFileScrty {
	// 파일구분자
	static final char FILE_SEPARATOR = File.separatorChar;
	// 버퍼사이즈
	static final int BUFFER_SIZE = 1024;

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovFileScrty.class);
	
	@Value("${CRYPTO.prm}")
	public String prm;	
	@Value("${CRYPTO.pbm}")
	public String pbm;	
	@Value("${CRYPTO.pre}")
	public String pre;	
	@Value("${CRYPTO.apb}")
	public String apb;	
	/**
	 * 파일을 암호화하는 기능
	 *
	 * @param String source 암호화할 파일
	 * @param String target 암호화된 파일
	 * @return boolean result 암호화여부 True/False
	 * @exception Exception
	 */
	public static boolean encryptFile(String source, String target) throws Exception {		
		// 암호화 여부
		boolean result = false;

		String sourceFile = source.replace('\\', FILE_SEPARATOR).replace('/', FILE_SEPARATOR);
		String targetFile = target.replace('\\', FILE_SEPARATOR).replace('/', FILE_SEPARATOR);
		File srcFile = new File(sourceFile);

		BufferedInputStream input = null;
		BufferedOutputStream output = null;

		byte[] buffer = new byte[BUFFER_SIZE];

		try {
			if (srcFile.exists() && srcFile.isFile()) {

				input = new BufferedInputStream(new FileInputStream(srcFile));
				output = new BufferedOutputStream(new FileOutputStream(targetFile));

				int length = 0;
				while ((length = input.read(buffer)) >= 0) {
					byte[] data = new byte[length];
					System.arraycopy(buffer, 0, data, 0, length);
					output.write(encodeBinary(data).getBytes());
					output.write(System.getProperty("line.separator").getBytes());
				}

				result = true;
			}
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORE: {}" + ignore);
				}
			}
			if (output != null) {
				try {
					output.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORE: {}" + ignore);
				}
			}
		}
		return result;
	}

	/**
	 * 파일을 복호화하는 기능
	 *
	 * @param String source 복호화할 파일
	 * @param String target 복호화된 파일
	 * @return boolean result 복호화여부 True/False
	 * @exception Exception
	 */
	public static boolean decryptFile(String source, String target) throws Exception {

		// 복호화 여부
		boolean result = false;

		String sourceFile = source.replace('\\', FILE_SEPARATOR).replace('/', FILE_SEPARATOR);
		String targetFile = target.replace('\\', FILE_SEPARATOR).replace('/', FILE_SEPARATOR);
		File srcFile = new File(sourceFile);

		BufferedReader input = null;
		BufferedOutputStream output = null;

		//byte[] buffer = new byte[BUFFER_SIZE];
		String line = null;

		try {
			if (srcFile.exists() && srcFile.isFile()) {

				input = new BufferedReader(new InputStreamReader(new FileInputStream(srcFile)));
				output = new BufferedOutputStream(new FileOutputStream(targetFile));

				while ((line = input.readLine()) != null) {
					byte[] data = line.getBytes();
					output.write(decodeBinary(new String(data)));
				}

				result = true;
			}
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORE: {}" + ignore);
				}
			}
			if (output != null) {
				try {
					output.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORE: {}" + ignore);
				}
			}
		}
		return result;
	}

	/**
	 * 데이터를 암호화하는 기능
	 *
	 * @param byte[] data 암호화할 데이터
	 * @return String result 암호화된 데이터
	 * @exception Exception
	 */
	public static String encodeBinary(byte[] data) throws Exception {
		if (data == null) {
			return "";
		}

		return new String(Base64.encodeBase64(data));
	}

	/**
	 * 데이터를 암호화하는 기능
	 *
	 * @param String data 암호화할 데이터
	 * @return String result 암호화된 데이터
	 * @exception Exception
	 */
	public static String encode(String data) throws Exception {
		return encodeBinary(data.getBytes());
	}

	/**
	 * 데이터를 복호화하는 기능
	 *
	 * @param String data 복호화할 데이터
	 * @return String result 복호화된 데이터
	 * @exception Exception
	 */
	public static byte[] decodeBinary(String data) throws Exception {
		return Base64.decodeBase64(data.getBytes());
	}

	/**
	 * 데이터를 복호화하는 기능
	 *
	 * @param String data 복호화할 데이터
	 * @return String result 복호화된 데이터
	 * @exception Exception
	 */
	public static String decode(String data) throws Exception {
		return new String(decodeBinary(data));
	}

    /**
     * 비밀번호를 암호화하는 기능(복호화가 되면 안되므로 SHA-256 인코딩 방식 적용).
     * 
     * deprecated : 보안 강화를 위하여 salt로 ID를 지정하는 encryptPassword(password, id) 사용
     *
     * @param String data 암호화할 비밀번호
     * @return String result 암호화된 비밀번호
     * @exception Exception
     */
    @Deprecated
    public static String encryptPassword(String data) throws Exception {

		if (data == null) {
		    return "";
		}
	
		byte[] plainText = null; // 평문
		byte[] hashValue = null; // 해쉬값
		plainText = data.getBytes();
	
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		
		// 변경 시 기존 hash 값에 검증 불가.. => deprecated 시키고 유지
		/*	
	    // Random 방식의 salt 추가
	    SecureRandom ng = new SecureRandom();
	    byte[] randomBytes = new byte[16];
	    ng.nextBytes(randomBytes);
	    
	    md.reset();
	    md.update(randomBytes);
	    
		*/		
		hashValue = md.digest(plainText);
		
		/*
		BASE64Encoder encoder = new BASE64Encoder();
		return encoder.encode(hashValue);
		*/
		return new String(Base64.encodeBase64(hashValue));
    }
    
    /**
     * 비밀번호를 암호화하는 기능(복호화가 되면 안되므로 SHA-256 인코딩 방식 적용)
     * 
     * @param password 암호화될 패스워드
     * @param id salt로 사용될 사용자 ID 지정
     * @return
     * @throws Exception
     */
    public static String encryptPassword(String password, String id) throws Exception {

		if (password == null) {
		    return "";
		}
	
		byte[] hashValue = null; // 해쉬값
	
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		
		md.reset();
		md.update(id.getBytes());
		
		hashValue = md.digest(password.getBytes());
	
		return new String(Base64.encodeBase64(hashValue));
    }
    
    /**
     * 비밀번호를 암호화하는 기능(복호화가 되면 안되므로 SHA-256 인코딩 방식 적용)
     * @param data 암호화할 비밀번호
     * @param salt Salt
     * @return 암호화된 비밀번호
     * @throws Exception
     */
    public static String encryptPassword(String data, byte[] salt) throws Exception {

		if (data == null) {
		    return "";
		}
	
		byte[] hashValue = null; // 해쉬값
	
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		
		md.reset();
		md.update(salt);
		
		hashValue = md.digest(data.getBytes());
	
		return new String(Base64.encodeBase64(hashValue));
    }
    
    /**
     * 비밀번호를 암호화된 패스워드 검증(salt가 사용된 경우만 적용).
     * 
     * @param data 원 패스워드
     * @param encoded 해쉬처리된 패스워드(Base64 인코딩)
     * @return
     * @throws Exception
     */
    public static boolean checkPassword(String data, String encoded, byte[] salt) throws Exception {
    	byte[] hashValue = null; // 해쉬값
    	
    	MessageDigest md = MessageDigest.getInstance("SHA-256");
    	
    	md.reset();
    	md.update(salt);
    	hashValue = md.digest(data.getBytes());
    	
    	return MessageDigest.isEqual(hashValue, Base64.decodeBase64(encoded.getBytes()));
    }
    /**
		* 암호화 된 값은 byte 배열이다.
		* 이를 문자열 폼으로 전송하기 위해 16진 문자열(hex)로 변경한다. 
		* 서버측에서도 값을 받을 때 hex 문자열을 받아서 이를 다시 byte 배열로 바꾼 뒤에 복호화 과정을 수행한다.
		*/
    public static String decryptRsa(PrivateKey privateKey, String securedValue) {
    	String decryptedValue = "";
 	
   	 	try{
   	 		Cipher cipher = Cipher.getInstance("RSA");
	   	   
   	 		byte[] encryptedBytes = hexToByteArray(securedValue);
   	 		cipher.init(Cipher.DECRYPT_MODE, privateKey);
   	 		byte[] decryptedBytes = cipher.doFinal(encryptedBytes);
   	 		decryptedValue = new String(decryptedBytes, "utf-8"); // 문자 인코딩 주의.
   	 		
   	 	}catch(Exception e){
   	 		
   	 	}
   		return decryptedValue;
    } 
    /** 
    * 16진 문자열을 byte 배열로 변환한다. 
    */
    public static byte[] hexToByteArray(String hex) {
    	if (hex == null || hex.length() % 2 != 0) {
    		return new byte[]{};
    	}    
    	byte[] bytes = new byte[hex.length() / 2];
	   
    	for (int i = 0; i < hex.length(); i += 2) {
    		byte value = (byte)Integer.parseInt(hex.substring(i, i + 2), 16);
    		bytes[(int) Math.floor(i / 2)] = value;
    	}
    	return bytes;
    }
    /**
	 * Modulus, Exponent 값을 이용하여 PrivateKey 객체를 생성함
	 * @param modulus RSA private key Modulus
	 * @param privateExponent RSA private key exponent
	 * @return PrivateKey 객체
	 */
    public static PrivateKey getPrivateKey(String modulus, String privateExponent) {
		BigInteger modulus_ = new BigInteger(modulus);
		BigInteger privateExponent_ = new BigInteger(privateExponent);
		PrivateKey privateKey = null;
		
		try {
			privateKey = KeyFactory
					.getInstance("RSA")
					.generatePrivate(new RSAPrivateKeySpec(modulus_, privateExponent_));
		} catch (InvalidKeySpecException e) {
			e.printStackTrace();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		
		return privateKey;
	}
    
    public String encryptAES(String s) throws Exception {
        String encrypted = null;

        try{        	
            SecretKeySpec skeySpec = new SecretKeySpec(apb.getBytes(), "AES");            

            Cipher cipher = Cipher.getInstance("AES");
            cipher.init(Cipher.ENCRYPT_MODE, skeySpec);            

            encrypted = byteArrayToHex(cipher.doFinal(s.getBytes()));

            return encrypted;
        }catch (Exception e){          
            throw e;
        }
    }     

    // key는 16 바이트로 구성 되어야 한다.
    public String decryptAES(String s) throws Exception {
        String decrypted = null;

        try{
            SecretKeySpec skeySpec = new SecretKeySpec(apb.getBytes(), "AES");             

            Cipher cipher = Cipher.getInstance("AES");
            cipher.init(Cipher.DECRYPT_MODE, skeySpec);

            decrypted = new String(cipher.doFinal(hexToByteArray(s)));

            return decrypted;

        }catch(Exception e){
            throw e;
        }
    }
    
    private String byteArrayToHex(byte buf[]) {
        StringBuffer strbuf = new StringBuffer(buf.length * 2);

        for (int i = 0; i < buf.length; i++) {
            if (((int) buf[i] & 0xff) < 0x10) {
                strbuf.append("0");
            }
            strbuf.append(Long.toString((int) buf[i] & 0xff, 16));
        }
        return strbuf.toString();
    }    

	public String getPrm() {
		return prm;
	}
	public void setPrm(String prm) {
		this.prm = prm;
	}
	public String getPbm() {
		return pbm;
	}
	public void setPbm(String pbm) {
		this.pbm = pbm;
	}
	public String getPre() {
		return pre;
	}
	public void setPre(String pre) {
		this.pre = pre;
	}
	public String getApb() {
		return apb;
	}
	public void setApb(String apb) {
		this.apb = apb;
	}
	
}