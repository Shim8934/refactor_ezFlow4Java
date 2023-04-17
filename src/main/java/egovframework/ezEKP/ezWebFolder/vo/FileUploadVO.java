package egovframework.ezEKP.ezWebFolder.vo;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

import org.apache.commons.io.IOUtils;

/**
 * 파일 저장을 위해 EzWebfolderUtil.convertFileUploadVOFromRequest()에서
 * 각기 다른 타입의 파일: MultipartFile, MimeBodyPart, 	//추후추가:File(대용량)의
 * 웹폴더 저장에 필요한 공통된 데이터(필드변수 4가지)를 담는 '파일저장용' 표준 객체.
 *
 * @author 솔루션1팀 김은실
 */
public class FileUploadVO {
	private String originalFilename;
	private long size;
	private InputStream stream;

	public FileUploadVO(String originalFilename, long size, InputStream stream) {
		this.originalFilename = originalFilename;
		this.size = size;
		this.stream = stream;
	}

	public String getOriginalFilename() {
		return originalFilename;
	}
	public long getSize() {
		return size;
	}
	public InputStream getInputStream() {
		return stream;
	}

//FUNCTION
	// consume(일회성) : InputStream은 한번 읽으면 재사용 할 수 없다.
	public byte[] getBytes() throws IOException {
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		int length;
		byte[] buffer = new byte[2048];
		try {
		    while ((length = stream.read(buffer, 0, buffer.length)) != -1) {
		        bos.write(buffer, 0, length);
		    }
		} finally {
			IOUtils.closeQuietly(stream);
		}

		return bos.toByteArray();
	}
}