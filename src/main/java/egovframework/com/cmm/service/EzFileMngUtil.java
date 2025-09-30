package egovframework.com.cmm.service;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.let.utl.fcc.service.EzFAL;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
//import java.util.HashMap;

import egovframework.ezEKP.ezApprovalG.service.impl.EzApprovalGKlibServiceImpl;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.let.utl.fcc.service.KlibUtil;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;
import org.egovframe.rte.fdl.property.EgovPropertyService;

/**
 * @Class Name  : EzFileMngUtil.java
 * @Description : 메시지 처리 관련 유틸리티
 * @Modification Information
 *
 *     수정일         수정자                   수정내용
 *     -------          --------        ---------------------------
 *   2009.02.13       이삼섭                  최초 생성
 *   2011.08.31  JJY            경량환경 템플릿 커스터마이징버전 생성
 *
 * @author 공통 서비스 개발팀 이삼섭
 * @since 2009. 02. 13
 * @version 1.0
 * @see
 *
 */
@Component("EzFileMngUtil")
public class EzFileMngUtil extends EgovAbstractServiceImpl{

    public static final int BUFF_SIZE = 2048;

    @Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;

    @Resource(name = "egovFileIdGnrService")
    private EgovIdGnrService idgenService;

    private static final Logger logger = LoggerFactory.getLogger(EzFileMngUtil.class);
    
    @Autowired
	private CommonUtil commonUtil;
    
    @Autowired
    protected KlibUtil klibUtil;
    
    /**
     * 첨부파일에 대한 목록 정보를 취득한다.
     *
     * @param files
     * @return
     * @throws Exception
     */
    public List<FileVO> parseFileInf(Map<String, MultipartFile> files, String KeyStr, int fileKeyParam, String atchFileId, String storePath) throws Exception {
		int fileKey = fileKeyParam;
	
		String storePathString = "";
		String atchFileIdString = "";
	
		if (storePath == null || "".equals(storePath)) {
		    storePathString = propertyService.getString("Globals.fileStorePath");
		} else {
		    storePathString = propertyService.getString(storePath);
		}
	
		if (atchFileId == null || "".equals(atchFileId)) {
		    atchFileIdString = idgenService.getNextStringId();
		} else {
		    atchFileIdString = atchFileId;
		}
	
		File saveFolder = new File(storePathString);
	
		if (!saveFolder.exists() || saveFolder.isFile()) {
		    saveFolder.mkdirs();
		}
	
		Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
		MultipartFile file;
		String filePath = "";
		List<FileVO> result  = new ArrayList<FileVO>();
		FileVO fvo;

		while (itr.hasNext()) {
		    Entry<String, MultipartFile> entry = itr.next();
	
		    file = entry.getValue();
		    String orginFileName = file.getOriginalFilename();
	
		    //--------------------------------------
		    // 원 파일명이 없는 경우 처리
		    // (첨부가 되지 않은 input file type)
		    //--------------------------------------
		    if ("".equals(orginFileName)) {
			continue;
		    }
		    ////------------------------------------
	
		    int index = orginFileName.lastIndexOf(".");
		    //String fileName = orginFileName.substring(0, index);
		    String fileExt = orginFileName.substring(index + 1);
		    String newName = KeyStr + EgovStringUtil.getTimeStamp() + fileKey;
		    long _size = file.getSize();
	
		    if (!"".equals(orginFileName)) {
			filePath = storePathString + File.separator + newName;
			file.transferTo(new File(filePath));
		    }
		    fvo = new FileVO();
		    fvo.setFileExtsn(fileExt);
		    fvo.setFileStreCours(storePathString);
		    fvo.setFileMg(Long.toString(_size));
		    fvo.setOrignlFileNm(orginFileName);
		    fvo.setStreFileNm(newName);
		    fvo.setAtchFileId(atchFileIdString);
		    fvo.setFileSn(String.valueOf(fileKey));
	
		    //writeFile(file, newName, storePathString);
		    result.add(fvo);
	
		    fileKey++;
		}
		return result;
    }
    
    /**
     * 첨부파일 삭제를 진행한다.
     *
     * @param filePath
     * @return
     * @throws Exception
     */
    protected void deleteFile(String filePath) throws Exception {
	    try {
			EzFAL.EzFile targetFile = new EzFAL.EzFile(filePath);
	
			if (targetFile != null) {
				targetFile.delete();
			}
		} catch (Exception e) {
			logger.debug("FILE DELETE ERROR: {}", e.getMessage());
		}
    }

    /**
     * 첨부파일을 서버에 저장한다.
     *
     * @param file
     * @param newName
     * @param stordFilePath
     * @throws Exception
     */
    protected void writeUploadedFile(MultipartFile file, String newName, String stordFilePath) throws Exception {
		String stordFilePathReal = (stordFilePath==null?"":stordFilePath);
		
		// 로컬에 경로가 없으면 오류가 발생함
		EzFAL.EzFile stordFile = new EzFAL.EzFile(stordFilePath);
		if (!stordFile.exists()) {
			stordFile.mkdirs();
		}
		
		try (InputStream stream = file.getInputStream();
			 EzFAL.EzFileOutputStream bos = new EzFAL.EzFileOutputStream(stordFilePathReal + commonUtil.separator + newName)) {
			
			EzFAL.EzFile cFile = new EzFAL.EzFile(stordFilePathReal);
	
		    if (!cFile.isDirectory()) {
				boolean _flag = cFile.mkdirs();
				if (!_flag) {
				    throw new IOException("Directory creation Failed ");
				}
		    }

		    int bytesRead = 0;
		    byte[] buffer = new byte[BUFF_SIZE];
	
		    while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
		    	bos.write(buffer, 0, bytesRead);
		    }
		} catch (FileNotFoundException fnfe) {
			logger.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			logger.debug("ioe: {}", ioe);
		} catch (Exception e) {
			logger.debug("e: {}", e);
		}
    }

	/**
	 * 절대 경로로 첨부파일을 서버에 저장한다.
	 *
	 * @param stream
	 * @param filePath
	 * @throws IOException
	 */
	protected void writeUploadedFile(InputStream stream, String filePath) throws IOException {
			logger.debug("writeUploadedFile: {}", filePath);
			File file = new File(filePath);

			file.getParentFile().mkdirs();
			Files.copy(stream, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
	}
	
	/**
	 * 절대 경로로 첨부파일을 klib 암호화하여 서버에 저장한다.
	 *
	 * @param bytes
	 * @param filePath
	 * @throws Exception
	 */
	protected void writeUploadedFileEncryptKlib(byte[] bytes, String filePath) throws Exception {
			logger.debug("writeUploadedFileEncryptKlib: {}", filePath);
			File file = new File(filePath);
			file.getParentFile().mkdirs();
			byte[] encryptedBytes = klibUtil.encrypt(bytes);
			commonUtil.writeBytesToFile(file.toPath(), encryptedBytes);
	}
	
    /**
     * 서버의 파일을 다운로드한다.
     *
     * @param request
     * @param response
     * @throws Exception
     */
    public static void downFile(HttpServletRequest request, HttpServletResponse response) throws Exception {

    	String downFileName = EgovStringUtil.isNullToString(request.getAttribute("downFile")).replaceAll("..","");
    	String orgFileName = EgovStringUtil.isNullToString(request.getAttribute("orgFileName")).replaceAll("..","");

	/*if ((String)request.getAttribute("downFile") == null) {
	    downFileName = "";
	} else {
	    downFileName = EgovStringUtil.isNullToString(request.getAttribute("downFile"));
	}*/

	/*if ((String)request.getAttribute("orgFileName") == null) {
	    orgFileName = "";
	} else {
	    orgFileName = (String)request.getAttribute("orginFile");
	}*/

		File file = new File(downFileName);
	
		if (!file.exists()) {
		    throw new FileNotFoundException(downFileName);
		}
	
		if (!file.isFile()) {
		    throw new FileNotFoundException(downFileName);
		}
	
		byte[] b = new byte[BUFF_SIZE]; //buffer size 2K.
	    String fName = (new String(orgFileName.getBytes(), "UTF-8")).replaceAll("\r\n","");
		response.setContentType("application/x-msdownload");
		response.setHeader("Content-Disposition:", "attachment; filename=" + fName);
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Pragma", "no-cache");
		response.setHeader("Expires", "0");
	
		BufferedInputStream fin = null;
		BufferedOutputStream outs = null;
	
		try {
			fin = new BufferedInputStream(new FileInputStream(file));
		    outs = new BufferedOutputStream(response.getOutputStream());
		    int read = 0;
	
			while ((read = fin.read(b)) != -1) {
			    outs.write(b, 0, read);
			}
		} finally {
		    if (outs != null) {
				try {
				    outs.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		    if (fin != null) {
				try {
				    fin.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		}
    }

    /**
     * 첨부로 등록된 파일을 서버에 업로드한다.
     *
     * @param file
     * @return
     * @throws Exception

    public static HashMap<String, String> uploadFile(MultipartFile file) throws Exception {

	HashMap<String, String> map = new HashMap<String, String>();
	//Write File 이후 Move File????
	String newName = "";
	String stordFilePath = EgovProperties.getProperty("Globals.fileStorePath");
	String orginFileName = file.getOriginalFilename();

	int index = orginFileName.lastIndexOf(".");
	//String fileName = orginFileName.substring(0, _index);
	String fileExt = orginFileName.substring(index + 1);
	long size = file.getSize();

	//newName 은 Naming Convention에 의해서 생성
	newName = EgovStringUtil.getTimeStamp() + "." + fileExt;
	writeFile(file, newName, stordFilePath);
	//storedFilePath는 지정
	map.put(Globals.ORIGIN_FILE_NM, orginFileName);
	map.put(Globals.UPLOAD_FILE_NM, newName);
	map.put(Globals.FILE_EXT, fileExt);
	map.put(Globals.FILE_PATH, stordFilePath);
	map.put(Globals.FILE_SIZE, String.valueOf(size));

	return map;
    }
*/
    /**
     * 파일을 실제 물리적인 경로에 생성한다.
     *
     * @param file
     * @param newName
     * @param stordFilePath
     * @throws Exception
     */
    protected static void writeFile(MultipartFile file, String newName, String stordFilePath) throws Exception {
		InputStream stream = null;
		OutputStream bos = null;
//		newName = EgovStringUtil.isNullToString(newName).replaceAll("..", "");
//		stordFilePath = EgovStringUtil.isNullToString(stordFilePath).replaceAll("..", "");
		
		try {
		    stream = file.getInputStream();
		    File cFile = new File(stordFilePath);
	
		    if (!cFile.isDirectory())
			cFile.mkdirs();
	
		    bos = new FileOutputStream(stordFilePath + File.separator + newName);
	
		    int bytesRead = 0;
		    byte[] buffer = new byte[BUFF_SIZE];
	
		    while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
		    	bos.write(buffer, 0, bytesRead);
		    }
		} catch (FileNotFoundException fnfe) {
			logger.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			logger.debug("ioe: {}", ioe);
		} catch (Exception e) {
			logger.debug("e: {}", e);
		} finally {
		    if (bos != null) {
				try {
				    bos.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		    if (stream != null) {
				try {
				    stream.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		}
    }

    /**
     * 서버 파일에 대하여 다운로드를 처리한다.
     *
     * @param response
     * @param streFileNm
     *            : 파일저장 경로가 포함된 형태
     * @param orignFileNm
     * @throws Exception
     */
    public void downFile(HttpServletRequest request, HttpServletResponse response, String streFileNm, String orignFileNm) throws Exception {
	    //	String downFileName = EgovStringUtil.isNullToString(request.getAttribute("downFile")).replaceAll("..","");
	    //	String orgFileName = EgovStringUtil.isNullToString(request.getAttribute("orgFileName")).replaceAll("..","");
	    String downFileName = EgovStringUtil.isNullToString(streFileNm);

	    // klib 확장자로 끝난다면 downFileForKlib 메소드로 리턴
	    // 사이드이펙트 방지를 위해서 복호화 두번 실패시 원본 파일로 처리
	    if (downFileName.endsWith("." + EzApprovalGKlibServiceImpl.ENCRYPTED_FILE_EXT)) {
	    	downFileForKlib(request, response, streFileNm, orignFileNm);
	    	return;
	    }
	    
		String orgFileName = EgovStringUtil.isNullToString(orignFileNm);
    	
		orgFileName = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), orgFileName);

		EzFAL.EzFile file = new EzFAL.EzFile(commonUtil.detectPathTraversal(downFileName));
		//log.debug(this.getClass().getName()+" downFile downFileName "+downFileName);
		//log.debug(this.getClass().getName()+" downFile orgFileName "+orgFileName);
	
		if (!file.exists()) {
		    throw new FileNotFoundException(downFileName);
		}
	
		if (!file.isFile()) {
		    throw new FileNotFoundException(downFileName);
		}
		
		//byte[] b = new byte[BUFF_SIZE]; //buffer size 2K.
		long fSize = file.length();
		if (fSize > 0) {
		    BufferedInputStream in = null;
	
		    try {
		    	in = new BufferedInputStream(new EzFAL.EzFileInputStream(file));
		    	
	    	    String mimetype = "application/octet-stream"; //"application/x-msdownload"	
	    	    
	    	    String nfcFilename = commonUtil.normalizeFileName(orgFileName);
	    	    
	    	    // dhlee : 파일 크기가 큰 경우 메모리가 작은 시스템에서는 문제가 발생하여 BUFF_SIZE 만큼의 버퍼를 할당하도록 수정함.	    	    
//	    	    response.setBufferSize(fSize);
	    	    response.setBufferSize(BUFF_SIZE);	    	    
				response.setContentType(mimetype);
				response.setHeader("Content-Disposition", "attachment; filename=\"" + nfcFilename + "\"");				
//				response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(orgFileName, "UTF-8").replaceAll("\\+","\\ ") + ";");
				response.setHeader("Content-Length", Long.toString(fSize));
//				response.setHeader("Content-Transfer-Encoding","binary");
				//response.setHeader("Pragma","no-cache");
				//response.setHeader("Expires","0");
				FileCopyUtils.copy(in, response.getOutputStream());
		    } finally {
				if (in != null) {
				    try {
				    	in.close();
				    } catch (Exception ignore) {
				    	logger.debug("IGNORED: {}", ignore.getMessage());
				    }
				}
		    }
		    response.getOutputStream().flush();
		    response.getOutputStream().close();
		}
	
		/*
		String uploadPath = propertiesService.getString("fileDir");
	
		File uFile = new File(uploadPath, requestedFile);
		int fSize = (int) uFile.length();
	
		if (fSize > 0) {
		    BufferedInputStream in = new BufferedInputStream(new FileInputStream(uFile));
	
		    String mimetype = "text/html";
	
		    response.setBufferSize(fSize);
		    response.setContentType(mimetype);
		    response.setHeader("Content-Disposition", "attachment; filename=\""
						+ requestedFile + "\"");
		    response.setContentLength(fSize);
	
		    FileCopyUtils.copy(in, response.getOutputStream());
		    in.close();
		    response.getOutputStream().flush();
		    response.getOutputStream().close();
		} else {
		    response.setContentType("text/html");
		    PrintWriter printwriter = response.getWriter();
		    printwriter.println("<html>");
		    printwriter.println("<br><br><br><h2>Could not get file name:<br>" + requestedFile + "</h2>");
		    printwriter.println("<br><br><br><center><h3><a href='javascript: history.go(-1)'>Back</a></h3></center>");
		    printwriter.println("<br><br><br>&copy; webAccess");
		    printwriter.println("</html>");
		    printwriter.flush();
		    printwriter.close();
		}
		//*/
	
	
		/*
		response.setContentType("application/x-msdownload");
		response.setHeader("Content-Disposition:", "attachment; filename=" + new String(orgFileName.getBytes(),"UTF-8" ));
		response.setHeader("Content-Transfer-Encoding","binary");
		response.setHeader("Pragma","no-cache");
		response.setHeader("Expires","0");
	
		BufferedInputStream fin = new BufferedInputStream(new FileInputStream(file));
		BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
		int read = 0;
	
		while ((read = fin.read(b)) != -1) {
		    outs.write(b,0,read);
		}
		log.debug(this.getClass().getName()+" BufferedOutputStream Write Complete!!! ");
	
		outs.close();
	    	fin.close();
		//*/
    }
    
    /**
     * 서버 파일에 대하여 다운로드를 처리한다. (klib로 암호화 된 경우에 복호화하여 다운로드한다)<br>
     * 혹시 모를 사이드이펙트를 우려해서 기존의 downFile 메소드와 중복되는 코드 제거 안 함
     *
     * @param response
     * @param streFileNm
     *            : 파일저장 경로가 포함된 형태
     * @param orignFileNm
     * @throws Exception
     */
    private void downFileForKlib(HttpServletRequest request, HttpServletResponse response, String streFileNm, String orignFileNm) throws Exception {
    	logger.debug("downFileForKlib started.");
	    String downFileName = EgovStringUtil.isNullToString(streFileNm);
		String orgFileName = EgovStringUtil.isNullToString(orignFileNm);
		
		orgFileName = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), orgFileName);

		EzFAL.EzFile file = new EzFAL.EzFile(downFileName);
	
		if (!file.exists() || !file.isFile()) {
		    throw new FileNotFoundException(downFileName);
		}
		
		long fSize = file.length();
		
		if (fSize > 0) {
		    byte[] encryptedBytes = commonUtil.readBytesFromFile(file.toPath());
		    byte[] decryptedBytes = klibUtil.decrypt(encryptedBytes);
		    
		    try (ByteArrayInputStream in = new ByteArrayInputStream(decryptedBytes)) {
	    	    String mimetype = "application/octet-stream";
	    	    
	    	    String nfcFilename = commonUtil.normalizeFileName(orgFileName);
	    	    
	    	    response.setBufferSize(BUFF_SIZE);	    	    
				response.setContentType(mimetype);
				response.setHeader("Content-Disposition", "attachment; filename=\"" + nfcFilename + "\"");				
				response.setHeader("Content-Length", Long.toString(fSize));
				FileCopyUtils.copy(in, response.getOutputStream());
		    } catch (Exception ex) {
		    	logger.error(ex.getMessage(), ex);
		    }
		    
		    response.getOutputStream().flush();
		    response.getOutputStream().close();
		}
		
		logger.debug("downFileForKlib ended.");
    }
    
    /**
     * 서버에 있는 이미지 요청을 처리한다. (화면에 보여주는 이미지)
     */
    public void downImage(String filePath, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	// 보안을 위해 /fileroot내에 있는 파일들에만 접근가능하도록 제한한다.
    	// 본래 /fileroot로 시작해야 정상이나 혹 //fileroot 등과 같이 사용되는 경우를 대비하여
    	// contains를 사용함.
    	if (!isValidFilePath(filePath)) {
    		logger.debug("filePath=" + filePath + " doesn't contain fileroot.");
    		
    		return;
    	}
    	
    	filePath = commonUtil.detectPathTraversal(filePath);    	
        String realPath = commonUtil.getRealPath(request);
        
        filePath = realPath + filePath;
		EzFAL.EzFile file = new EzFAL.EzFile(filePath);
        
	    // klib 확장자로 끝난다면 downFileForKlib 메소드로 리턴
        // ezCommon/downloadAttach.do 에서 이 메소드를 호출하기 때문에 전자결재에서 결재완료된 한글 문서를 로드할 때도 사용됨
	    if (filePath.endsWith("." + EzApprovalGKlibServiceImpl.ENCRYPTED_FILE_EXT)) {
	    	String fileName = file.getName();
	    	// .ezd 확장자가 제거된 이름으로 다운로드
	    	fileName = fileName.substring(0, fileName.lastIndexOf('.'));
	    	
	    	downFileForKlib(request, response, filePath, fileName);
	    	return;
	    }
        
        BufferedInputStream bis = null;
        OutputStream os = null;
        String contentType = null;
        long fileSize = 0;
        
        try {
			if (file.exists()) {
				fileSize = file.length();
				bis = new BufferedInputStream(new EzFAL.EzFileInputStream(file));
				contentType = URLConnection.guessContentTypeFromStream(bis);

				if (contentType == null) {
					if (filePath.toLowerCase().endsWith(".html")) {
						contentType = "text/html";
					} else {
						contentType = "application/octet-stream";
					}
				}

				response.setContentType(contentType);
				response.setHeader("Content-Length", Long.toString(fileSize));

				logger.debug("contentType=" + contentType + ",fileSize=" + fileSize);

				os = response.getOutputStream();

				IOUtils.copy(bis, os);

				os.flush();
			} else {
				logger.debug("{} not found.", filePath);
			}
        } catch(Exception e) {
        	logger.error(e.getMessage(), e);
        } finally {
        	if (os != null) {
        		try {
        			os.close();
        		} catch(Exception e) {
					logger.debug("e.message=" + e.getMessage());
        		}
        	}
        	
        	if (bis != null) {
        		try {
        			bis.close();
        		} catch(Exception e) {
					logger.debug("e.message=" + e.getMessage());
        		}
        	}
        }
        

	}
    
    public boolean isValidFilePath(String filePath) {
    	
    	if(filePath.contains("/fileroot/") || filePath.contains("/files/") || filePath.contains("/images/") || filePath.contains("/images_en/") || filePath.contains("/images_ja/")) {
    		return true;
    	}
    	
    	return false;
    }
    
    /**
     * 서버 파일/폴더를 재귀적으로 삭제한다.
     *
     * @param path
     * @throws Exception
     */
	public boolean deleteDirectory(File path) throws Exception {
		if (path.isDirectory()) {
			File[] files = path.listFiles();
			
			for (int i=0; i<files.length; i++) {
				if (files[i].isDirectory()) {
					deleteDirectory(files[i]);
				}
				else {
					files[i].delete();
				}
			}
		}
		
		return path.delete();
	}

	public boolean deleteDirectory(EzFAL.EzFile path) throws Exception {
		if (path.isDirectory()) {
			EzFAL.EzFile[] files = path.listFiles();

			for (int i=0; i<files.length; i++) {
				if (files[i].isDirectory()) {
					deleteDirectory(files[i]);
				}
				else {
					files[i].delete();
				}
			}
		}

		return path.delete();
	}

	public void fileMove(String beforeFilePath, String afterFilePath) throws Exception {
		logger.debug("fileMove started.");
		logger.debug("beforeFilePath = " + beforeFilePath + " || afterFilePath = " + afterFilePath);

		EzFAL.EzFile srcFile = new EzFAL.EzFile(commonUtil.detectPathTraversal(beforeFilePath));
		EzFAL.EzFile destFile = new EzFAL.EzFile(commonUtil.detectPathTraversal(afterFilePath));

		try (InputStream in = new EzFAL.EzFileInputStream(srcFile);
			 OutputStream out = new EzFAL.EzFileOutputStream(destFile)) {
			IOUtils.copy(in, out);
		}

		srcFile.delete();

		logger.debug("fileMove ended.");
	}

	/**
	 * 폴더를 압축하여 zip파일을 생성한다.
	 * 
	 * @param path folder path (not file)
	 * @param fileName new zip file name. If null then folder name is default.
	 * @param isDelete whether to delete the original folder
	 * @return zip file's full path
	 * @throws Exception
	 */
	public String zipFolder(String path, String fileName, boolean isDelete) throws Exception {
		logger.debug("zipFolder started. path=" + path + ",fileName=" + fileName + ",isDelete=" + isDelete);
		File dir = new File(path);

		List<File> fileList = new ArrayList<File>();
		getAllFiles(dir, fileList);
		
		// 2023-06-01 이사라 : 시큐어코딩 리소스 close
		//ZipOutputStream zos = null;
		//FileInputStream fis = null;
		
		try (ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(path + ".zip"), Charset.forName("UTF-8"))) {
			if (fileName != null) {
				path = dir.getPath().substring(0, dir.getName().length()) + fileName;
			}
			
			//zos = new ZipOutputStream(new FileOutputStream(path + ".zip"), Charset.forName("UTF-8"));
			
			for (File file : fileList) {
				if (!file.isDirectory()) {
					//fis = new FileInputStream(file);

					try (FileInputStream fis = new FileInputStream(file)) {
						String zipFilePath = file.getPath().substring(dir.getPath().length() + 1, file.getPath().length());

						logger.debug("zipFilePath=" + zipFilePath);

						ZipEntry zipEntry = new ZipEntry(zipFilePath);
						zos.putNextEntry(zipEntry);

						byte[] bytes = new byte[BUFF_SIZE];
						int length;

						while ((length = fis.read(bytes)) >= 0) {
							zos.write(bytes, 0, length);
						}

						zos.closeEntry();
					} catch (IOException e) {
						logger.error(e.getMessage(), e);
					}
				}
			}
						
			//zos.close();
			//zos = null;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			/*} finally {
			if (fis != null) {
				try { fis.close(); } catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
			}
			
			if (zos != null) {
				try { zos.closeEntry(); } catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
				try { zos.close(); } catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
			}*/
			
		}
		
		File zipFile = new File(path + ".zip");
		logger.debug(zipFile.getName() + " is created. size=" + zipFile.length() + "byte");
		
		if (isDelete) {
			if (deleteDirectory(dir)) {
				logger.debug(dir.getName() + " folder is deleted.");
			}
		}
		
		logger.debug("zipFolder ended. returnValue=" + zipFile.getPath());
		return zipFile.getPath();
	}
	
	private void getAllFiles(File dir, List<File> fileList) {
		File[] files = dir.listFiles();
		
		for (File file : files) {
			fileList.add(file);
			if (file.isDirectory()) {
				getAllFiles(file, fileList);
			}
		}
	}
	
	/**
	 * 파일을 읽어 String으로 리턴
	 * @param filePath 파일 경로
	 * @return file text
	 * @throws Exception
	 */
	public String readFile(String filePath) throws Exception {
		EzFAL.EzFile file = new EzFAL.EzFile(filePath);
		
		if (!file.exists()) {
			throw new NoSuchFileException(filePath);
		}
		
		StringBuilder sb = new StringBuilder();
		BufferedReader br = null;
		String strLine = null;
		
		try {
			br = new BufferedReader(new InputStreamReader(new EzFAL.EzFileInputStream(file), "UTF-8"));
			
			while ((strLine = br.readLine()) != null) {
				sb.append(strLine + "\n");
			}
		} finally {
			if (br != null) {
				try {br.close();} catch(Exception e) {logger.debug("e.message=" + e.getMessage());}
			}
		}
		
		return sb.toString();
	}
}
