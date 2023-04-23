package egovframework.let.utl.fcc.service;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.function.Function;
import java.util.stream.Stream;

import javax.annotation.PostConstruct;
import javax.servlet.ServletContext;
import javax.xml.bind.DatatypeConverter;

import org.bouncycastle.util.Arrays;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * KLIB 네이티브 라이브러리를 사용하여 암/복호화 하는 유틸
 * 
 * @since 2018.06.07
 * 
 */
@Component
public class KlibUtil {
	// only aix, 2018.07.23
	private static final String LIBRARY_PATH = "/WEB-INF/lib/libezKlib.so";

	private static final Logger logger = LoggerFactory.getLogger(KlibUtil.class);

	private static final int DEBUG_BYTE_SIZE = 16;

	private Cipher cipher = null;


	@Autowired
	private ServletContext servletContext;

	/**
	 * KLIB 암/복호화를 위해서 암호화, 복호화 메소드가 있는 인터페이스
	 */
	private interface Cipher {
		byte[] encrypt(byte[] originBytes);

		byte[] decrypt(byte[] encryptedBytes);
	}

	/**
	 * KLIB 동적 라이브러리를 통해서 암/복호화를 하는 {@link Cipher} 구현체
	 */
	private static class KlibCipher implements Cipher {
		@Override
		public native byte[] encrypt(byte[] originBytes);

		@Override
		public native byte[] decrypt(byte[] encryptedBytes);
	}

	/**
	 * KLIB 동적 라이브러리 로드에 실패했을 때 사용되는 {@link Cipher} 구현체<br>
	 * <br>
	 * 암/복호화를 사용할 일이 없으면 TBL_TENANT_CONFIG 테이블의 useApprovalKlib 옵션을 "no" 로 변경<br>
	 * 로컬에서 KLIB 관련으로 테스트를 하고 싶다면 {@link LocalTestCipher} 구현체를 쓰도록 변경
	 */
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

	/**
	 * KLIB 동적 라이브러리를 사용할 수 없는 환경에서 임시로 테스트를 하기 위한 {@link Cipher} 구현체<br>
	 * 
	 * @deprecated 로컬에서 테스트할 때 쓰는 용도
	 */
	@SuppressWarnings("unused")
	private static class LocalTestCipher implements Cipher {
		private static final byte[] SALT = "LOCAL_TEST_ENCRYPTED".getBytes();

		@Override
		public byte[] encrypt(byte[] originBytes) {
			return Arrays.concatenate(SALT, Arrays.reverse(originBytes));
		}

		@Override
		public byte[] decrypt(byte[] encryptedBytes) {
			int removedSaltLength = encryptedBytes.length - SALT.length;

			if (removedSaltLength < 0) {
				throw new RuntimeException("is not encrypted bytes");
			}

			byte[] saltBytes = new byte[SALT.length];
			System.arraycopy(encryptedBytes, 0, saltBytes, 0, SALT.length);

			if (!Arrays.areEqual(saltBytes, SALT)) {
				throw new RuntimeException("is not encrypted bytes");
			}

			byte[] removedSaltBytes = new byte[removedSaltLength];
			System.arraycopy(encryptedBytes, SALT.length, removedSaltBytes, 0, removedSaltLength);
			return Arrays.reverse(removedSaltBytes);
		}
	}

	@PostConstruct
	public void init() {
		boolean loadSuccess = false;

		try {
			// WEB-INF/lib/libezKlib.so
			Path libraryPath = Paths.get(servletContext.getResource(LIBRARY_PATH).toURI());

			logger.debug("library path: {}", libraryPath);

			// native library load
			System.load(libraryPath.toString());
			loadSuccess = true;
		} catch (Throwable throwable) {
			logger.debug("Failed to load KLIB - {}", throwable.toString());
			Stream.of(throwable.getStackTrace()).filter(obj -> obj.getClassName().contains(KlibUtil.class.getName())).map(Object::toString).forEach(logger::debug);
		}

		cipher = loadSuccess ? new KlibCipher() : new NonKlibCipher();
		// CIPHER = loadSuccess ? new KlibCipher() : new LocalTestCipher();

		try {
			String testString = "Hello klib!";

			logger.debug("=== KLIB Test ===");
			logger.debug("test string: \"{}\"", testString);

			byte[] encryptBytes = cipher.encrypt(testString.getBytes());
			logger.debug("encrypt bytes: {}, to string: {}", DatatypeConverter.printHexBinary(encryptBytes), new String(encryptBytes));

			byte[] decryptBytes = cipher.decrypt(encryptBytes);
			logger.debug("decrypt bytes: {}, to string: {}", DatatypeConverter.printHexBinary(decryptBytes), new String(decryptBytes));
		} catch (Throwable throwable) {
			logger.debug("Failed to test for KLIB - {}", throwable.toString());
		} finally {
			logger.debug("=== KLIB Test ===");
		}
	}

	/**
	 * KLIB를 이용하여 바이트를 암호화
	 * 
	 * @param originBytes
	 *            암호화할 바이트 배열
	 */
	public byte[] encrypt(byte[] originBytes) throws Exception, UnsatisfiedLinkError {
		logger.debug("encrypt started.");

		byte[] result = tryTransformationPolicy(originBytes, cipher::encrypt);

		debugBytes("origin bytes", originBytes);
		debugBytes("encrypted bytes", result);

		logger.debug("encrypt ended.");

		return result;
	}

	/**
	 * KLIB를 이용하여 암호화된 바이트 배열을 복호화
	 * 
	 * @NOTE 암호화와는 다르게 복호화가 실패한다면 원본 바이트를 반환한다.
	 * 
	 * @param encryptedBytes
	 *            복호화할 바이트 배열
	 */
	public byte[] decrypt(byte[] encryptedBytes) throws Exception, UnsatisfiedLinkError {
		logger.debug("decrypt started.");
		byte[] result;

		try {
			result = tryTransformationPolicy(encryptedBytes, cipher::decrypt);

			debugBytes("encrypted bytes", encryptedBytes);
			debugBytes("decrypted bytes", result);
		} catch (Exception ex) {
			ex.printStackTrace();
			logger.debug("Failed to decrypt, returns the source bytes.");
			result = encryptedBytes;
		}

		logger.debug("decrypt ended.");

		return result;
	}

	/**
	 * 암/복호화 정책<br>
	 * <br>
	 * 한 번 시도한 후에 예외가 난다면 재시도한다.<br>
	 * 재시도 시에 예외가 난다면 그 예외를 던진다.<br>
	 * 결과적으로 성공한다면 결과 값의 사이즈를 체크하여 0 이 아니면 결과 값 반환,<br>
	 * 사이즈가 0 이라면 재시도하여 성공시 사이즈 관계 없이 반환, 예외가 난다면 그 예외를 던진다.
	 */
	private byte[] tryTransformationPolicy(byte[] source, Function<byte[], byte[]> transformationFunction) throws Exception, UnsatisfiedLinkError {
		byte[] dest;

		// 첫 번째 시도
		try {
			dest = transformationFunction.apply(source);
		} catch (Exception ex) {
			// 실패시 두 번째 시도
			logger.debug("An exception occurred in the first attempt. {}", ex.toString());

			try {
				dest = transformationFunction.apply(source);
			} catch (Exception twoEx) {
				// 두 번째 시도에서 실패시 예외를 던짐
				logger.debug("An exception occurred in the second attempt. {}", twoEx.toString());

				throw twoEx;
			}
		}

		// 만약 결과 값의 사이즈가 0 이라면 재시도
		if (dest.length == 0 && source.length != 0) {
			logger.debug("The result size is zero. try again");

			try {
				dest = transformationFunction.apply(source);
			} catch (Exception ex) {
				// 재시도 실패시 예외를 던짐
				logger.debug("An error occurred on retried: {}", ex.toString());

				throw ex;
			}
		}

		logger.debug("Successfully completed");
		return dest;
	}

	private void debugBytes(String byteArrayName, byte[] bytes) {
		boolean isGreaterThanEllipsis = bytes.length > DEBUG_BYTE_SIZE;
		int debugSize = isGreaterThanEllipsis ? DEBUG_BYTE_SIZE : bytes.length;

		// CWE-190 보안 취약점 관련 조치
		debugSize = debugSize < 0 ? DEBUG_BYTE_SIZE : debugSize;
		
		byte[] ellipsisBytes = new byte[debugSize];

		System.arraycopy(bytes, 0, ellipsisBytes, 0, debugSize);

		logger.debug(isGreaterThanEllipsis ? "{}: {}…, to string: {}…" : "{}: {}, to string: {}", byteArrayName, DatatypeConverter.printHexBinary(ellipsisBytes), new String(ellipsisBytes));
	}
}
