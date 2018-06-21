package egovframework.let.utl.fcc.service;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Stream;

import javax.xml.bind.DatatypeConverter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/**
 * KLIB 네이티브 라이브러리를 사용하여 암/복호화 하는 유틸
 * 
 * @author jwseo99
 * @since 2018.06.07
 * 
 */
@Component
public class KlibUtil {
	// only linux & aix
	private static final String LIBRARY_PATH = "lib/libezKlib.so";

	private static final Logger LOGGER = LoggerFactory.getLogger(KlibUtil.class);

	private static final Cipher CIPHER;

	static {
		boolean loadSuccess = false;

		try {
			// KLIB 파일 위치
			// WEB-INF
			Path classPath = Paths.get(KlibUtil.class.getClassLoader().getResource("").toURI());
			Path parentPath = classPath.getParent();
			Path libraryPath = parentPath.resolve(LIBRARY_PATH).toRealPath();

			LOGGER.debug(String.format("class path: %s", classPath.toAbsolutePath().toString()));
			LOGGER.debug(String.format("parent path: %s", parentPath.toAbsolutePath().toString()));
			LOGGER.debug(String.format("library path: %s", libraryPath.toString()));

			// native load
			System.load(libraryPath.toString());
			loadSuccess = true;
		} catch (Throwable ex) {
			LOGGER.debug(String.format("Failed to load KLIB - %s: %s", ex.getClass().getName(), ex.getMessage()));
			Stream.of(ex.getStackTrace()).filter(obj -> obj.getClassName().contains(KlibUtil.class.getName())).map(Object::toString).forEach(LOGGER::debug);
		}

		CIPHER = loadSuccess ? new KlibCipher() : new NonKlibChipher();
		
		// KLIB 테스트
		try {
			String testString = "Hello klib!";

			LOGGER.debug("=== KLIB Test ===");
			LOGGER.debug(String.format("test string: \"%s\"", testString));
			byte[] encryptBytes = CIPHER.encrypt(testString.getBytes());
			LOGGER.debug(String.format("encrypt bytes: %s, to string: %s", DatatypeConverter.printHexBinary(encryptBytes), new String(encryptBytes)));
			byte[] decryptBytes = CIPHER.decrypt(encryptBytes);
			LOGGER.debug(String.format("decrypt bytes: %s, to string: %s", DatatypeConverter.printHexBinary(decryptBytes), new String(decryptBytes)));
			LOGGER.debug("=== KLIB Test ===");
		} catch (Exception ex) {
			LOGGER.debug("Failed to test for KLIB - " + ex.getMessage());
		}
	}

	private interface Cipher {
		byte[] encrypt(byte[] originBytes) throws Exception;

		byte[] decrypt(byte[] encryptedBytes) throws Exception;
	}

	private static class KlibCipher implements Cipher {
		@Override
		public native byte[] encrypt(byte[] originBytes) throws Exception;

		@Override
		public native byte[] decrypt(byte[] encryptedBytes) throws Exception;
	}

	private static class NonKlibChipher implements Cipher {
		@Override
		public byte[] encrypt(byte[] originBytes) {
			LOGGER.debug("NonKlibCipher encrypt running..");
			return reverse(originBytes);
		}

		@Override
		public byte[] decrypt(byte[] encryptedBytes) {
			LOGGER.debug("NonKlibCipher decrypt running..");
			return reverse(encryptedBytes);
		}

		private byte[] reverse(byte[] a) {
			if (a == null) {
				return null;
			}

			int p1 = 0, p2 = a.length;
			byte[] result = new byte[p2];

			while (--p2 >= 0) {
				result[p2] = a[p1++];
			}

			return result;
		}
	}

	/**
	 * KLIB를 이용하여 바이트를 암호화
	 * 
	 * @param originBytes
	 *            암호화할 바이트 배열
	 * */
	// public static native byte[] encrypt(byte[] originBytes) throws Exception,
	// UnsatisfiedLinkError;
	public byte[] encrypt(byte[] originBytes) throws Exception, UnsatisfiedLinkError {
		return CIPHER.encrypt(originBytes);
	}

	/**
	 * KLIB를 이용하여 암호화된 바이트 배열을 복호화
	 * 
	 * @param encryptedBytes
	 *            복호화할 바이트 배열
	 * */
	// public static native byte[] decrypt(byte[] encryptedBytes) throws
	// Exception, UnsatisfiedLinkError;
	public byte[] decrypt(byte[] encryptedBytes) throws Exception, UnsatisfiedLinkError {
		return CIPHER.decrypt(encryptedBytes);
	}
}
