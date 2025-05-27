package egovframework.let.utl.fcc.service;

import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.apache.commons.io.IOUtils;
import org.apache.commons.io.filefilter.PrefixFileFilter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.amazonaws.SdkClientException;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.client.builder.AwsClientBuilder;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.ListObjectsRequest;
import com.amazonaws.services.s3.model.ObjectListing;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import com.amazonaws.services.s3.model.S3ObjectSummary;
import com.amazonaws.services.s3.model.AmazonS3Exception;

/**
 * ezEKP File Access Layer
 */
public class EzFAL {

    private static final Logger LOGGER = LoggerFactory.getLogger(EzFAL.class);

    // 0 : File Storage, 1 : Object Storage
    public static final int FILE_STORAGE_MODE = 0;
    public static final int OBJECT_STORAGE_MODE = 1;

    private static int storageMode = FILE_STORAGE_MODE;

    // 로컬 파일 시스템을 사용해야 하는 폴더 패스들의 목록
    private static List<String> localFolderPathList
        = Arrays.asList("/files/upload_common", "/tempFileUpload", "/files/upload_mail/templist",
                        "/tempUploadFile", "/files/upload_personal/photo/temp", "/files/upload_approvalG/form",
                        "/files/sealImg");
    private static String startFolderPath = "fileroot";

    private static AmazonS3 s3Client;
    private static String bucketName;
    
    public static class EzFile {

        private File file;
        private S3Object s3Obj;
        private String s3ObjKey;
        private boolean s3ObjKeyHasExtension;
        private boolean useFileIO = false;

        public EzFile(File file) {
            // Object Storage를 사용하는 경우에도 File 객체를 함께 보관한다.
            this.file = file;

            if (isObjectStorageMode()) {
                if (localFolderPathList.stream().filter(file.getPath()::contains).count() == 0) {
                    s3ObjKey = file.getPath();
                    // 윈도우에서 설행할 경우 구분자가 \가 되어 /로 변경하도록 함
                    s3ObjKey = s3ObjKey.replace("\\", "/");
                    s3ObjKey = s3ObjKey.substring(s3ObjKey.indexOf(startFolderPath));
                    s3ObjKeyHasExtension = file.getName().lastIndexOf(".") != -1;

                    // eml 파일 삭제를 위한 경로 조정
                    if (s3ObjKey.startsWith("fileroot/mail")) {
                        s3ObjKey = s3ObjKey.substring(s3ObjKey.indexOf("mail"));
                    }
                // 임시 파일을 생성하는 용도인 upload_common 폴더를 대상으로 할 경우엔
                // Object Storage 대신에 파일 I/O를 수행한다.
                } else {
                    useFileIO = true;    
                }            
            } 

            LOGGER.debug("name={},useFileIO={}", file.getPath(), useFileIO);
        }

        public EzFile(String name) {
            // Object Storage를 사용하는 경우에도 File 객체를 함께 생성한다.
            this(new File(name));
        }

        public EzFile(File parent, String child) {
            // Object Storage를 사용하는 경우에도 File 객체를 함께 생성한다.
            this(new File(parent, child));
        }

        public EzFile(String parent, String child) {
            // Object Storage를 사용하는 경우에도 File 객체를 함께 생성한다.
            this(new File(parent, child));
        }

        public String getName() {
            return file.getName();
        }

        public File getFile() {
            // 내부에 보관하고 있는 File 객체를 반환한다.
            return file;
        }

        public boolean exists() {
            if (isObjectStorageMode() && !useFileIO) {
                boolean isExist = s3Client.doesObjectExist(bucketName, s3ObjKey);

                // Object Storage에 존재하는 경우에는 바로 true를 리턴한다.
                if (isExist) {
                    return true;
                }

                // Object Storage에 존재하지 않는 경우 확장자가 있으면 파일로 보고 바로 false를 리턴한다.
                if (s3ObjKeyHasExtension) {
                    return false;
                }

                // 확장자를 가지고 있지 않은 경우는 폴더로 보고 Object Storage에서는
                // 폴더 개념이 존재하지 않으므로 파일 시스템에서의 체크로 넘긴다.
                // 폴더 존재 여부를 체크하는 경우는 해당 폴더를 생성하기 위한 것일 가능성이 크므로
                // 로컬 파일 시스템에 해당 폴더를 생성해 동일 구조를 유지하도록 함(경우에 따라 로컬 폴더를 캐시 공간으로 사용하기 위한 조치).
            }

            return file.exists();
        }

        public boolean isDirectory() {
            if (isObjectStorageMode() && !useFileIO) {
                boolean isExist = s3Client.doesObjectExist(bucketName, s3ObjKey);

                // Object Storage에 존재하는 경우에는 파일이므로 바로 false를 리턴한다.
                if (isExist) {
                    return false;
                }

                // Object Storage에 존재하지 않는 경우 확장자가 있으면 파일로 보고 바로 false를 리턴한다.
                if (s3ObjKeyHasExtension) {
                    return false;
                }

                // 확장자를 가지고 있지 않은 경우는 폴더로 보고 Object Storage에서는
                // 폴더 개념이 존재하지 않으므로 파일 시스템에서의 체크로 넘긴다.
                // 폴더 존재 여부를 체크하는 경우는 해당 폴더를 생성하기 위한 것일 가능성이 크므로
                // 로컬 파일 시스템에 해당 폴더를 생성해 동일 구조를 유지하도록 함(경우에 따라 로컬 폴더를 캐시 공간으로 사용하기 위한 조치).
            }

            return file.isDirectory();
        }

        public boolean isFile() {
            if (isObjectStorageMode() && !useFileIO) {
                return s3Client.doesObjectExist(bucketName, s3ObjKey);
            } else {
                return file.isFile();
            }
        }

        public boolean mkdir() {
            // Object Storage에서는 폴더 개념이 별도로 존재하지 않으므로 아무것도 수행하지 않는다.
            if (isObjectStorageMode()) {
            }

            // 파일 시스템에 폴더 구조를 유지하기 위해 폴더는 로컬에 무조건 생성한다(경우에 따라 로컬 폴더를 캐시 공간으로 사용하기 위한 조치).
            return file.mkdir();
        }

        public boolean mkdirs() {
            // Object Storage에서는 폴더 개념이 별도로 존재하지 않으므로 아무것도 수행하지 않는다.
            if (isObjectStorageMode()) {
            }

            // 파일 시스템에 폴더 구조를 유지하기 위해 폴더는 로컬에 무조건 생성한다(경우에 따라 로컬 폴더를 캐시 공간으로 사용하기 위한 조치).
            return file.mkdirs();
        }

        public long length() {
            if (isObjectStorageMode() && !useFileIO) {
                try {
                    s3Obj = s3Client.getObject(bucketName, s3ObjKey);
                } catch (AmazonS3Exception e) {
                    return 0;
                }

                long contentLen = s3Obj.getObjectMetadata().getContentLength();

                LOGGER.debug("contentLen={}", contentLen);

                try {
                    s3Obj.close();
                } catch (IOException e) {
                    LOGGER.error(e.getMessage(), e);
                } finally {
                    s3Obj = null;
                }

                return contentLen;
            } else {
                return file.length();
            }
        }

        public boolean delete() {
            if (isObjectStorageMode() && !useFileIO) {
                try {
                    s3Client.deleteObject(bucketName, s3ObjKey);
                    return true;
                } catch (SdkClientException e) {
                    return false;
                }
            } else {
                return file.delete();
            }
        }

        public Path toPath() {
            return file.toPath();
        }

        public EzFile[] listFiles() {
            if (isObjectStorageMode() && !useFileIO) {
                ListObjectsRequest listObjRequest = new ListObjectsRequest().withBucketName(bucketName).withPrefix(s3ObjKey);
                ObjectListing objListing = s3Client.listObjects(listObjRequest);

                LOGGER.debug("listFiles s3ObjKey={}", s3ObjKey);

                return objListing.getObjectSummaries().stream().map(S3ObjectSummary::getKey).map(EzFile::new).toArray(EzFile[]::new);
            } else {
                return Arrays.stream(file.listFiles()).map(EzFile::new).toArray(EzFile[]::new);            
            }
        }

        public EzFile[] listFiles(FileFilter filter) {
            if (isObjectStorageMode() && !useFileIO) {
                String prefix = "";

                if (filter instanceof PrefixFileFilter) {
                    prefix = filter.toString(); // prefixFileFilter(prefix)와 같은 형태로 반환됨.
                    prefix = "/" + prefix.substring(prefix.indexOf("(") + 1, prefix.length() - 1); // ()를 제거하고 / 뒤에 붙임
                }

                ListObjectsRequest listObjRequest = new ListObjectsRequest().withBucketName(bucketName).withPrefix(s3ObjKey + prefix);
                ObjectListing objListing = s3Client.listObjects(listObjRequest);

                LOGGER.debug("listFiles s3ObjKey + prefix={}", s3ObjKey + prefix);
    
                return objListing.getObjectSummaries().stream().map(S3ObjectSummary::getKey).map(EzFile::new).toArray(EzFile[]::new);
            } else {
                return Arrays.stream(file.listFiles(filter)).map(EzFile::new).toArray(EzFile[]::new);            
            }
        }

        public EzFile[] listFiles(FilenameFilter filter) {
            if (isObjectStorageMode() && !useFileIO) {
                EzFile[] fullList = listFiles();
                Set<String> pathSet = new HashSet<>();
                String[] keyPathArr = s3ObjKey.split("/");

                for (EzFile ezFile : fullList) {
                    String pathName = ezFile.getFile().getPath();
                    String[] pathArr = pathName.split("/");

                    if (pathArr.length > keyPathArr.length) {
                        // 바로 하위에 있는 이름을 구성한다.
                        pathSet.add(s3ObjKey + "/" + pathArr[keyPathArr.length]);
                    }
                }

                List<EzFile> directChildList = pathSet.stream().map(EzFile::new).collect(Collectors.toList());

                return directChildList.stream().filter(f -> filter.accept(getFile(), f.getName())).toArray(EzFile[]::new);
            } else {
                return Arrays.stream(file.listFiles(filter)).map(EzFile::new).toArray(EzFile[]::new);            
            }
        }

        public boolean renameTo(EzFile dest) {
            if (isObjectStorageMode() && !(useFileIO && dest.useFileIO)) {
                try (InputStream in = new EzFAL.EzFileInputStream(this);
                    OutputStream out = new EzFAL.EzFileOutputStream(dest)) {
                    IOUtils.copy(in, out);
                    return delete();
			    } catch (IOException e) {
                    return false;
                }
            } else {
                return file.renameTo(dest.getFile());
            }
        }

        public long lastModified() {
            if (isObjectStorageMode() && !useFileIO) {
                s3Obj = s3Client.getObject(bucketName, s3ObjKey);
                long lastTime = s3Obj.getObjectMetadata().getLastModified().getTime();

                try {
                    s3Obj.close();
                } catch (IOException e) {
                    LOGGER.error(e.getMessage(), e);
                } finally {
                    s3Obj = null;
                }

                return lastTime;
            } else {
                return file.lastModified();
            }
        }

        public String toString() {
            return file.toString();
        }

    }

    public static class EzFileInputStream extends InputStream {

        private FileInputStream fis = null;
        private S3ObjectInputStream ois = null;
        private boolean useFileIO = false;

        public EzFileInputStream(EzFile file) throws FileNotFoundException {
            if (isObjectStorageMode()) {
                if (localFolderPathList.stream().filter(file.getFile().getPath()::contains).count() == 0) {
                    String key = file.getFile().getPath();
                    key = key.substring(key.indexOf(startFolderPath));
                    ois = s3Client.getObject(bucketName, key).getObjectContent();
                    // 임시 파일을 생성하는 용도인 upload_common 폴더를 대상으로 할 경우엔
                    // Object Storage 대신에 파일 I/O를 수행한다.
                } else {
                    fis = new FileInputStream(file.getFile());
                    useFileIO = true;
                }
            } else {
                fis = new FileInputStream(file.getFile());
            }

            LOGGER.debug("name={},useFileIO={}", file.getFile().getPath(), useFileIO);
        }

        public EzFileInputStream(String name) throws FileNotFoundException {
            this(new EzFile(name));
        }

        @Override
        public int read(byte b[]) throws IOException {
            return read(b, 0, b.length);
        }

        @Override
        public int read(byte b[], int off, int len) throws IOException {
            if (isObjectStorageMode() && !useFileIO) {
                return ois.read(b, off, len);
            } else {
                return fis.read(b, off, len);
            }
        }
    
        @Override
        public int read() throws IOException {
            if (isObjectStorageMode() && !useFileIO) {
                return ois.read();
            } else {
                return fis.read();
            }
        }
        
        @Override
        public int available() throws IOException {
            if (isObjectStorageMode() && !useFileIO) {
                return ois.available();
            } else {
                return fis.available();
            }
        }
    
        @Override
        public void close() throws IOException {
            if (isObjectStorageMode() && !useFileIO) {
                ois.close();
            } else {
                fis.close();
            }
        }

    }

    public static class EzFileOutputStream extends OutputStream {

        private EzFile file = null;
        private FileOutputStream fos = null;
        private boolean useFileIO = false;

        public EzFileOutputStream(EzFile file) throws FileNotFoundException {
            if (isObjectStorageMode()) {
                if (localFolderPathList.stream().filter(file.getFile().getPath()::contains).count() == 0) {
                    fos = new FileOutputStream(file.getFile());
                    this.file = file;
                    // 임시 파일을 생성하는 용도인 upload_common 폴더를 대상으로 할 경우엔
                    // Object Storage 대신에 파일 I/O를 수행한다.
                } else {
                    fos = new FileOutputStream(file.getFile());
                    useFileIO = true;
                }
            } else {
                fos = new FileOutputStream(file.getFile());
            }

            LOGGER.debug("name={},useFileIO={}", file.getFile().getPath(), useFileIO);
        }

        public EzFileOutputStream(String name) throws FileNotFoundException {
            this(new EzFile(name));
        }

        @Override
        public void write(byte b[]) throws IOException {
            write(b, 0, b.length);
        }

        @Override
        public void write(byte b[], int off, int len) throws IOException {
            fos.write(b, off, len);
        }

        @Override
        public void write(int b) throws IOException {
            fos.write(b);
        }

        @Override
        public void close() throws IOException {
            if (isObjectStorageMode() && !useFileIO) {
                if (fos != null) {
                    fos.close();

                    ObjectMetadata meta = new ObjectMetadata();
                    meta.setContentLength(file.getFile().length());

                    InputStream is = new FileInputStream(file.getFile());
                    String key = file.getFile().getPath();
                    key = key.substring(key.indexOf(startFolderPath));
                    s3Client.putObject(bucketName, key, is, meta);

                    is.close();
                    file.getFile().delete();
                }
            } else {
                fos.close();
            }
        }

    }
    
    public static boolean isObjectStorageMode() {
        LOGGER.debug("isObjectStorageMode={}", storageMode == OBJECT_STORAGE_MODE);

        return storageMode == OBJECT_STORAGE_MODE;
    }

    public static void setStorageMode(int storageMode) {
        EzFAL.storageMode = storageMode;
    }

    public static void initS3Client(String endPoint, String accessKey, String secretKey, String bucketName) {
        s3Client = AmazonS3ClientBuilder.standard().enablePathStyleAccess().disableChunkedEncoding()				
        .withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKey, secretKey)))
        .withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration(endPoint, null))
        .build();		
        EzFAL.bucketName = bucketName;
    }

}
