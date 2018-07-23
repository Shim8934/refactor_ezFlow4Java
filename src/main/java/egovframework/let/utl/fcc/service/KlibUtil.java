package egovframework.let.utl.fcc.service;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.function.Function;
import java.util.stream.Stream;

import javax.xml.bind.DatatypeConverter;

//import org.bouncycastle.util.Arrays;
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
	// only aix, 2018.07.23
	private static final String LIBRARY_PATH = "lib/libezKlib.so";

	private static final Logger LOGGER = LoggerFactory.getLogger(KlibUtil.class);

	private static final Cipher CIPHER;

	private static final int DEBUG_BYTE_SIZE = 16;

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
			LOGGER.debug(String.format("Failed to load KLIB - %s", ex));
			Stream.of(ex.getStackTrace()).filter(obj -> obj.getClassName().contains(KlibUtil.class.getName())).map(Object::toString).forEach(LOGGER::debug);
		}

		CIPHER = loadSuccess ? new KlibCipher() : new NonKlibCipher();
		// TEST CODE
		// CIPHER = loadSuccess ? new KlibCipher() : new LocalTestCipher();

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
		} catch (Throwable throwable) {
			LOGGER.debug("Failed to test for KLIB - " + throwable);
		}
	}

	private interface Cipher {
		byte[] encrypt(byte[] originBytes);

		byte[] decrypt(byte[] encryptedBytes);
	}

	private static class KlibCipher implements Cipher {
		@Override
		public native byte[] encrypt(byte[] originBytes);

		@Override
		public native byte[] decrypt(byte[] encryptedBytes);
	}

	private static class NonKlibCipher implements Cipher {
		@Override
		public byte[] encrypt(byte[] originBytes) {
			throw new UnsatisfiedLinkError("KLIB is not loaded.");
		}

		@Override
		public byte[] decrypt(byte[] encryptedBytes) {
			throw new UnsatisfiedLinkError("KLIB is not loaded.");
		}
	}

	// TEST CODE
	/* private static class LocalTestCipher implements Cipher {
		@Override
		public byte[] encrypt(byte[] originBytes) {
			return Arrays.reverse(originBytes);
		}

		@Override
		public byte[] decrypt(byte[] encryptedBytes) {
			return Arrays.reverse(encryptedBytes);
		}
	}

	/**
	 * KLIB를 이용하여 바이트를 암호화
	 * 
	 * @param originBytes
	 *            암호화할 바이트 배열
	 * */
	public byte[] encrypt(byte[] originBytes) throws Exception, UnsatisfiedLinkError {
		LOGGER.debug("encrypt started.");

		byte[] result = tryTransformationPolicy(originBytes, CIPHER::encrypt);

		debugBytes("origin bytes", originBytes);
		debugBytes("encrypted bytes", result);

		LOGGER.debug("encrypt ended.");

		return result;
	}

	/**
	 * KLIB를 이용하여 암호화된 바이트 배열을 복호화
	 * 
	 * @param encryptedBytes
	 *            복호화할 바이트 배열
	 * */
	public byte[] decrypt(byte[] encryptedBytes) throws Exception, UnsatisfiedLinkError {
		LOGGER.debug("decrypt started.");

		byte[] result = tryTransformationPolicy(encryptedBytes, CIPHER::decrypt);

		debugBytes("encrypted bytes", encryptedBytes);
		debugBytes("decrypted bytes", result);

		LOGGER.debug("decrypt ended.");

		return result;
	}

	/**
	 * 암/복호화 정책<br>
	 * <br>
	 * 한 번 시도한 후에 예외가 난다면 재시도한다.<br>
	 * 재시도 시에 예외가 난다면 그 예외를 던진다.<br>
	 * 예외 없이 성공한다면 결과 값의 사이즈를 체크하여 0 이 아니면 결과 값 반환,<br>
	 * 사이즈가 0 이라면 재시도하여 성공시 사이즈 관계 없이 반환, 예외가 난다면 그 예외를 던진다.
	 * */
	private byte[] tryTransformationPolicy(byte[] source, Function<byte[], byte[]> transformationFunction) throws Exception, UnsatisfiedLinkError {
		byte[] dest;

		try {
			dest = transformationFunction.apply(source);
		} catch (Exception ex) {
			LOGGER.debug("An exception occurred in the first attempt. {}", ex);

			try {
				dest = transformationFunction.apply(source);
			} catch (Exception twoEx) {
				LOGGER.debug("An exception occurred in the second attempt. {}: {}", twoEx);

				throw twoEx;
			}
		}

		if (dest.length == 0 && source.length != 0) {
			LOGGER.debug("The result size is zero. try again");

			try {
				dest = transformationFunction.apply(source);
			} catch (Exception ex) {
				LOGGER.debug("An error occurred on retried: {}", ex);

				throw ex;
			}
		}

		LOGGER.debug("Successfully completed");
		return dest;
	}

	private void debugBytes(String byteArrayName, byte[] bytes) {
		boolean isGreaterThanEllipsis = bytes.length > DEBUG_BYTE_SIZE;
		byte[] ellipsisBytes = new byte[DEBUG_BYTE_SIZE];

		System.arraycopy(bytes, 0, ellipsisBytes, 0, DEBUG_BYTE_SIZE);

		LOGGER.debug(isGreaterThanEllipsis ? "{}: {}…, to string: {}…" : "{}: {}, to string: {}", byteArrayName, DatatypeConverter.printHexBinary(ellipsisBytes), new String(ellipsisBytes));
	}
}
