package egovframework.ezEKP.ezWebFolder.util;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;
import java.util.function.Consumer;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.mail.Folder;
import javax.mail.internet.MimeBodyPart;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import egovframework.let.user.login.vo.LoginVO;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezWebFolder.vo.FileUploadVO;

/**
 * @Description ezWebfolder 모듈에서 사용하는 유틸리티 클래스
 * @author yy9320
 *
 */
@Component("EzWebFolderUtil")
public class EzWebfolderUtil {
	private static final Logger logger = LoggerFactory.getLogger(EzWebfolderUtil.class);
    private JSONParser jp          = new JSONParser();

	@Autowired
	private EzEmailUtil ezEmailUtil;

	@Value("#{cryptos['EzWebfolderUtil.apb']}")
	private String apb;
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

	public boolean isWebfolderAdmin(LoginVO user) {
		return isWebfolderAdmin(user.getRollInfo());
	}

	public boolean isWebfolderAdmin(String rollInfo) {
		return rollInfo.contains("c=1") || rollInfo.contains("k=1") || rollInfo.contains("f=1");
	}

// For WebfolderFile Upload
	// 첫 Controller에서는: GW로 rest를 한번 더 보내기 때문에 굳이 FileUploadVO로 변경할 필요가 없음.
	/**
	 * GW에서는 FileUploadVO으로 사용하기가 좋음.
	 * 	* 다만 Locale정보는 GW에서 받은 것으로 하기 때문에: 첫 Controller에서 받은 Locale정보와 일치할 것인지 의문.
	 */
	public List<FileUploadVO> convertFileUploadVOFromRequest(List<MultipartFile> multiPartFileLists
					, String[] mailAttachArray, String userId, int tenantId, Locale locale) throws Exception {
				  /*, String[] MailAttachLargeArray) throws Exception {*/
		// log4j2에서 %M하면 메소드명 안 적어도 되므로 input,output값만 출력해도 됨	 *스프링 AOP: 매 메소드마다 표준적으로 로그를 찍을 수가 있음.
		logger.debug("convertFileUploadVOFromRequest started. multiPartFileLists={}, mailAttachArray={}, userId={}, tenantId={}, locale={}",
															multiPartFileLists.toString(), Arrays.toString(mailAttachArray), userId, tenantId, locale);
		List<FileUploadVO> list = new ArrayList<>();

		/**
		 * 사용자가 pc에서 업로드 할 파일을 선택하는 것이 기존 웹폴더 로직.
		 *
		 * (1)웹폴더 > 파일업로드 시 : MultipartFile
		 * 사용자는 -input type="file"-를 이용하여 직접 선택한 파일을 담고
		 * front에서: MultipartFile 타입을 보내게 된다.
		 * (back에서도: MultipartFile 타입으로 사용.)
		 * ※ input-file태그에는 임의로 값을 삽입하여 전달할 수가 없음. (직접선택만 가능.)
		 */
		for (MultipartFile multi : multiPartFileLists) {
			list.add(new FileUploadVO(multi.getOriginalFilename(), multi.getSize(), multi.getInputStream()));
		}

		/**
		 * 메일의 첨부파일은 메일(MIME)안에 있음(대용량 제외).
		 * MimeBodyPart 타입으로 첨부파일을 꺼낼 수 있다.
		 *
		 * (2)메일 > 첨부파일 > 웹폴더에 업로드 시 : MimeBodyPart
		 * front에서는: JSONObject객체로 -> 첨부파일을 꺼내기 위해 필요한 정보만을 넘기고,
		 * back에서: 실제 데이터인 MimeBodyPart는 EzEmailUtil.getAttachPart(message, index)를 이용하여 꺼낼 수 밖에 없다고 보여진다.
		 */
		if (mailAttachArray.length != 0) {
			// 메일의 첨부파일을 저장한다는 것은: 1개 또는 한 메일 안에 있는 파일 모두 저장이므로: 첫 파일의 userAccount, folderPath 만 구해도 문제 없을 것으로 예상. (IMAPAccess 생성 때문에.)
			JSONObject firstFileInfo = (JSONObject) jp.parse(mailAttachArray[0]);
			Map<String, Object> extraMap = new HashMap<String, Object>();
			String shareId = firstFileInfo.get("shareId").toString();
			String folderPath = firstFileInfo.get("folderPath").toString();

			String userAccount = ezEmailUtil.getUserAccount(userId, shareId, tenantId, extraMap);

			list.addAll(addListMailAttachArray(mailAttachArray, userAccount, locale, folderPath, extraMap));
		}

		/**
		 * (3)메일 > (이미 저장이 되어 있는)대용량첨부 > 웹폴더에 업로드 시 :	File		//fileSystem_Path: /files/upload_mail/largeFile
		 */
		/*for (  : MailAttachLargeArray) {*/

		logger.debug("convertFileUploadVOFromRequest ended. list={}", list.toString());
		return list;
	}

	private List<FileUploadVO> addListMailAttachArray(String[] mailAttachArray
			, String userAccount, Locale locale, String folderPath, Map<String, Object> extraMap) throws Exception {
		logger.debug("addListMailAttachArray started. mailAttachArray={}, locale={}, folderPath={}",
													  Arrays.toString(mailAttachArray), locale, folderPath);
		List<FileUploadVO> list = new ArrayList<>();

		// IMAPAccess open -> folder open -> 실 수행 -> folder close -> IMAPAccess close
		Consumer<IMAPAccess> callback = ia -> {
			try {
				Folder f = ia.getFolder(folderPath);

				if (f.exists()) {
					f.open(Folder.READ_ONLY);

					// 실 수행.
					for (String fileInfoStr : mailAttachArray) {
						JSONObject fileInfo = (JSONObject) jp.parse(fileInfoStr);

						long uid = Long.parseLong(fileInfo.get("uid").toString());
						int index = Integer.parseInt(fileInfo.get("index").toString());

						MimeBodyPart mime = (MimeBodyPart)ezEmailUtil.getAttachPart(
								ezEmailUtil.getMailMessage(f, uid, folderPath, null, locale, extraMap)	// Message 객체 import 하지 않기 위해 변수로 저장하지 않고 parameter 사용함
								, index);
						InputStream stream = mime.getInputStream();

						list.add(new FileUploadVO((String) fileInfo.get("originalFilename")
													, Long.parseLong(fileInfo.get("size").toString())
													, stream));
					}

					// folder 닫힘.
					f.close(false);
				}
			} catch (Exception e) {
				logger.error("addListMailAttachArray exception", e);
			}
		};

		ezEmailUtil.useIMAPAccessWithCallback(callback, userAccount, locale);

		logger.debug("addListMailAttachArray ended. list={}", list);
		return list;
	}
}