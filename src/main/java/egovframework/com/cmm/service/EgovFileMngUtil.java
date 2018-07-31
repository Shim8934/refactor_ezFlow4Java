package egovframework.com.cmm.service;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.nio.file.NoSuchFileException;
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

import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
//import java.util.HashMap;


import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * @Class Name  : EgovFileMngUtil.java
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
@Component("EgovFileMngUtil")
public class EgovFileMngUtil extends EgovAbstractServiceImpl{

    public static final int BUFF_SIZE = 2048;

    @Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;

    @Resource(name = "egovFileIdGnrService")
    private EgovIdGnrService idgenService;

    private static final Logger LOGGER = LoggerFactory.getLogger(EgovFileMngUtil.class);
    
    @Autowired
	private CommonUtil commonUtil;
    
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
			File targetFile = new File(filePath);
	
			if (targetFile != null) {
				targetFile.delete();
			}
		} catch (Exception e) {
			LOGGER.debug("FILE DELETE ERROR: {}", e.getMessage());
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
		InputStream stream = null;
		OutputStream bos = null;
		String stordFilePathReal = (stordFilePath==null?"":stordFilePath);
		
		try {
		    stream = file.getInputStream();
		    File cFile = new File(stordFilePathReal);
	
		    if (!cFile.isDirectory()) {
				boolean _flag = cFile.mkdirs();
				if (!_flag) {
				    throw new IOException("Directory creation Failed ");
				}
		    }
	
		    bos = new FileOutputStream(stordFilePathReal + File.separator + newName);
	
		    int bytesRead = 0;
		    byte[] buffer = new byte[BUFF_SIZE];
	
		    while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
		    	bos.write(buffer, 0, bytesRead);
		    }
		} catch (FileNotFoundException fnfe) {
			LOGGER.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			LOGGER.debug("ioe: {}", ioe);
		} catch (Exception e) {
			LOGGER.debug("e: {}", e);
		} finally {
		    if (bos != null) {
				try {
				    bos.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		    if (stream != null) {
				try {
				    stream.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		}
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
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		    if (fin != null) {
				try {
				    fin.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
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
		newName = EgovStringUtil.isNullToString(newName).replaceAll("..", "");
		stordFilePath = EgovStringUtil.isNullToString(stordFilePath).replaceAll("..", "");
		
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
			LOGGER.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			LOGGER.debug("ioe: {}", ioe);
		} catch (Exception e) {
			LOGGER.debug("e: {}", e);
		} finally {
		    if (bos != null) {
				try {
				    bos.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		    if (stream != null) {
				try {
				    stream.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
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
		String orgFileName = EgovStringUtil.isNullToString(orignFileNm);
    	
		orgFileName = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), orgFileName);
		
		File file = new File(downFileName);
		//log.debug(this.getClass().getName()+" downFile downFileName "+downFileName);
		//log.debug(this.getClass().getName()+" downFile orgFileName "+orgFileName);
	
		if (!file.exists()) {
		    throw new FileNotFoundException(downFileName);
		}
	
		if (!file.isFile()) {
		    throw new FileNotFoundException(downFileName);
		}
		
		//byte[] b = new byte[BUFF_SIZE]; //buffer size 2K.
		int fSize = (int)file.length();
		if (fSize > 0) {
		    BufferedInputStream in = null;
	
		    try {
		    	in = new BufferedInputStream(new FileInputStream(file));
		    	
	    	    String mimetype = "application/octet-stream"; //"application/x-msdownload"	
	    	    
	    	    String nfcFilename = commonUtil.normalizeFileName(orgFileName);
	    	    
	    	    // dhlee : 파일 크기가 큰 경우 메모리가 작은 시스템에서는 문제가 발생하여 BUFF_SIZE 만큼의 버퍼를 할당하도록 수정함.	    	    
//	    	    response.setBufferSize(fSize);
	    	    response.setBufferSize(BUFF_SIZE);	    	    
				response.setContentType(mimetype);
				response.setHeader("Content-Disposition", "attachment; filename=\"" + nfcFilename + "\"");				
//				response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(orgFileName, "UTF-8").replaceAll("\\+","\\ ") + ";");
				response.setContentLength(fSize);
//				response.setHeader("Content-Transfer-Encoding","binary");
				//response.setHeader("Pragma","no-cache");
				//response.setHeader("Expires","0");
				FileCopyUtils.copy(in, response.getOutputStream());
		    } finally {
				if (in != null) {
				    try {
				    	in.close();
				    } catch (Exception ignore) {
				    	LOGGER.debug("IGNORED: {}", ignore.getMessage());
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
     * 서버에 있는 이미지 요청을 처리한다. (화면에 보여주는 이미지)
     */
    public void downImage(String filePath, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String realPath = commonUtil.getRealPath(request);
        BufferedInputStream bis = null;
        OutputStream os = null;
        String contentType = null;
        int fileSize = 0;
        
        try {
	        filePath = realPath + filePath;
	        File file = new File(filePath);
	        fileSize = (int) file.length();
	        bis = new BufferedInputStream(new FileInputStream(file));
	        contentType = URLConnection.guessContentTypeFromStream(bis);
	        
	        if (contentType == null) {
	        	contentType = "application/octet-stream";
	        }
	        
	        response.setContentType(contentType);
	        response.setContentLength(fileSize);
	        
	        LOGGER.debug("contentType=" + contentType + ",fileSize=" + fileSize);
	        
	        os = response.getOutputStream();
	        
	        IOUtils.copy(bis, os);
	        
	        os.flush();
        } catch(Exception e) {
        	e.printStackTrace();
        } finally {
        	if (os != null) {
        		try {
        			os.close();
        		} catch(Exception e) {
        		}
        	}
        	
        	if (bis != null) {
        		try {
        			bis.close();
        		} catch(Exception e) {
        		}
        	}
        }
        

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
		LOGGER.debug("zipFolder started. path=" + path + ",fileName=" + fileName + ",isDelete=" + isDelete);
		File dir = new File(path);

		List<File> fileList = new ArrayList<File>();
		getAllFiles(dir, fileList);
		
		ZipOutputStream zos = null;
		FileInputStream fis = null;
		
		try {
			if (fileName != null) {
				path = dir.getPath().substring(0, dir.getName().length()) + fileName;
			}
			
			zos = new ZipOutputStream(new FileOutputStream(path + ".zip"), Charset.forName("UTF-8"));
			
			for (File file : fileList) {
				if (!file.isDirectory()) {
					fis = new FileInputStream(file);
					String zipFilePath = file.getPath().substring(dir.getPath().length() + 1, file.getPath().length());
					
					LOGGER.debug("zipFilePath=" + zipFilePath);
					
					ZipEntry zipEntry = new ZipEntry(zipFilePath);
					zos.putNextEntry(zipEntry);

					byte[] bytes = new byte[BUFF_SIZE];
					int length;
					
					while ((length = fis.read(bytes)) >= 0) {
						zos.write(bytes, 0, length);
					}

					zos.closeEntry();
					fis.close();
				}
			}
			
			fis = null;
			
			zos.close();
			zos = null;
		} catch (Exception e) {
			throw e;
			
		} finally {
			if (fis != null) {
				try { fis.close(); } catch (Exception e) {}
			}
			
			if (zos != null) {
				try { zos.closeEntry(); } catch (Exception e) {}
				try { zos.close(); } catch (Exception e) {}
			}
			
		}
		
		File zipFile = new File(path + ".zip");
		LOGGER.debug(zipFile.getName() + " is created. size=" + zipFile.length() + "byte");
		
		if (isDelete) {
			if (deleteDirectory(dir)) {
				LOGGER.debug(dir.getName() + " folder is deleted.");
			}
		}
		
		LOGGER.debug("zipFolder ended. returnValue=" + zipFile.getPath());
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
		File file = new File(filePath);
		
		if (!file.exists()) {
			throw new NoSuchFileException(filePath);
		}
		
		StringBuilder sb = new StringBuilder();
		BufferedReader br = null;
		String strLine = null;
		
		try {
			br = new BufferedReader(new InputStreamReader(new FileInputStream(file), "UTF-8"));
			
			while ((strLine = br.readLine()) != null) {
				sb.append(strLine + "\n");
			}
			
			br.close();
			br = null;
		} finally {
			if (br != null) {
				try {br.close();} catch(Exception e) {}
			}
		}
		
		return sb.toString();
	}
}
