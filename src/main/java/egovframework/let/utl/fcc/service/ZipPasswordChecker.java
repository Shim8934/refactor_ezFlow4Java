package egovframework.let.utl.fcc.service;

import net.lingala.zip4j.ZipFile;
import net.lingala.zip4j.exception.ZipException;
import org.springframework.stereotype.Component;

import java.io.File;

@Component
public class ZipPasswordChecker {

    public static boolean isEncrypted(File file) {
        try {
            ZipFile zipFile = new ZipFile(file);
            return zipFile.isEncrypted();  // 암호 있으면 true, 없으면 false
        } catch (ZipException e) {
            throw new RuntimeException("ZIP 파일이 아님 또는 파일이 손상됨.", e);
        }
    }
}