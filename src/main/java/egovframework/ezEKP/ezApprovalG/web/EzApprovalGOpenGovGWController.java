package egovframework.ezEKP.ezApprovalG.web;

import egovframework.ezEKP.ezApprovalG.service.EzApprovalGOpenGovService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EzFAL.*;
import kr.dogfoot.hwplib.object.HWPFile;
import kr.dogfoot.hwplib.reader.HWPReader;
import kr.dogfoot.hwplib.writer.HWPWriter;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

@RestController
public class EzApprovalGOpenGovGWController {
    @Autowired
    private CommonUtil commonUtil;

    @Autowired
    private Properties config;

    @Autowired
    EzApprovalGService ezApprovalGService;

    @Autowired
    EzApprovalGOpenGovService ezApprovalGOpenGovService;

    private static final Logger logger = LoggerFactory.getLogger(EzApprovalGOpenGovGWController.class);

    //원문공개 요청
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/openGov/{docId}/file/{fileId:.+}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
    public JSONObject getOpenGovDocInfo(@PathVariable String docId, @PathVariable String fileId, HttpServletRequest request, Locale locale) {
        logger.debug("G/W OPENGOV [POST /openGov/" + docId + "/file/" + fileId + "] started.");

        JSONObject result = new JSONObject();

        try {
          //  InputStream fin = null;
            String resultCode = "000";
            String data = "";
            JSONObject dataJson = new JSONObject();

            String docID = docId.substring(0, 20);
            String companyID = docId.substring(20, 27);

            if (!companyID.equals(config.getProperty("openGov_companyNum"))) {
                resultCode = "ERR_300";
                logger.debug(getMessage(resultCode) + " ::::: " + "COMPANYID error");
                data = getMessage(resultCode);

                result.put("status", "fail");
                result.put("code", resultCode);
                result.put("data", data);

                return result;
            } else {
                // 정상 파일 여부,  Error 발생 시 코드 ERR_801
                String openFlag = ezApprovalGOpenGovService.getOpenGovDocOpenFlag(docID);
                if (openFlag == null || openFlag.equals("")) {
                    resultCode = "ERR_801";
                    logger.debug(getMessage(resultCode) + " ::::: " + "DOCINFO EMPTY");
                    data = getMessage(resultCode);

                    result.put("status", "fail");
                    result.put("code", resultCode);
                    result.put("data", data);

                    return result;
                } else {
                    if (openFlag.equals("3")) {
                        resultCode = "ERR_802";
                        logger.debug(getMessage(resultCode) + " ::::: " + getMessage(resultCode));
                        data = getMessage(resultCode);

                        result.put("status", "fail");
                        result.put("code", resultCode);
                        result.put("data", data);

                        return result;
                    } else {
                        String href = "";
                        if (fileId.length() == 20) {
                            href = ezApprovalGOpenGovService.getOpenGovDocHref(docID);
                            if (href == null) {
                                resultCode = "ERR_801";
                                logger.debug(getMessage(resultCode) + " ::::: " + "DOC empty");
                                data = getMessage(resultCode);

                                result.put("status", "fail");
                                result.put("code", resultCode);
                                result.put("data", data);

                                return result;
                            }
                        } else {
                            String sn = fileId.substring(20);
                            href = ezApprovalGOpenGovService.getOpenGovAttachHref(docID, sn);
                            if (href == null || !Paths.get(commonUtil.getRealPath(request), href).toFile().exists()) {
                                resultCode = "ERR_801";
                                logger.debug(getMessage(resultCode) + " ::::: " + "ATTACH FILE empty");
                                data = getMessage(resultCode);

                                result.put("status", "fail");
                                result.put("code", resultCode);
                                result.put("data", data);

                                return result;
                            }
                        }

                        logger.debug("href = " + href);

                        String fileHref = commonUtil.detectPathTraversal(commonUtil.getRealPath(request) + href);

                        logger.debug("fileType = " + href.substring(href.length() - 3, href.length()));
						
						EzFile orgFile = new EzFile(fileHref); // 원본 HWP파일 접근 시 EzFAL 적용
						String fileHrefForDataJson = fileHref;

                        // 문서가 한글일때
                        if (href.substring(href.length() - 3, href.length()).equals("hwp")) {
                           // HWPFile hwpFile = HWPReader.fromFile(fileHref);
                            HWPFile hwpFile = HWPReader.fromFile(orgFile.getFile());

                            // 관인 지워주는 작업
                            ezApprovalGOpenGovService.setHwpSealSignEmpty(hwpFile);
                            HWPWriter.toFile(hwpFile, fileHref + ".tmp");
                           // fin = new EzFileInputStream(new File(fileHref + ".tmp"));
						   fileHrefForDataJson = fileHref + ".tmp";
                        }/* else {
                            //fin = new EzFileInputStream(new File(fileHref));
                        }*/

                        //byte[] bytes = IOUtils.toByteArray(fin);
						File afterFile = new File(fileHrefForDataJson); // HWP 문서인 경우 관인 제거된 파일 (오브젝트 스토리지에 저장할 파일이 아니므로 EzFAL 적용 제외)
						byte[] bytes = FileUtils.readFileToByteArray(afterFile);
						
                        resultCode = "000";

                        dataJson.put("bytes", bytes);
                        dataJson.put("fileName", docID + "." + href.substring(href.length() - 3, href.length()));
                        dataJson.put("fileType", href.substring(href.length() - 3, href.length()));

                        result.put("status", "ok");
                        result.put("code", resultCode);
                        result.put("data", dataJson);
                    }
                }
            }
        } catch (Exception e) {
            logger.debug(e.getMessage());
            logger.error(e.getMessage(), e);
            result.put("status", "error");
            result.put("code", "1");
        }

        logger.debug("G/W OPENGOV [POST /openGov/" + docId + "/file/" + fileId + "] ended.");

        return result;
    }

    // 원문공개 처리완료
    @SuppressWarnings("unchecked")
	@RequestMapping(value = "/openGovComplete/{docId}/file/{fileId:.+}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
    public JSONObject openGovComplete(@PathVariable String docId, @PathVariable String fileId, HttpServletRequest request, Locale locale) {
        logger.debug("G/W OPENGOV [POST /openGovComplete/" + docId + "/file/" + fileId + "] started.");

        logger.debug("docId = " + docId + ", fileId = " + fileId);

        JSONObject result = new JSONObject();

        try {
            ezApprovalGOpenGovService.insertGovDocSend(docId, fileId);

            result.put("status", "ok");
            result.put("code", "0");
            result.put("data", "ok");
        } catch (Exception e) {
            result.put("status", "error");
            result.put("code", "1");
        }

        logger.debug("G/W OPENGOV [POST /openGovComplete/" + docId + "/file/" + fileId + "] ended.");
        return result;
    }

    private String getMessage(String key) {
        String result = "";

        Map<String, String> map = new HashMap<String, String>();
        map.put("000", "처리완료");
        map.put("ERR_100", "DB 관련 오류");
        map.put("ERR_200", "IO 관련 오류");
        map.put("ERR_300", "파라미터 오류");
        map.put("ERR_400", "클래스 관련 오류");
        map.put("ERR_500", "Connection 오류");
        map.put("ERR_600", "Web Service 관련 오류");
        map.put("ERR_700", "응용단 기타 오류");
        map.put("ERR_801", "요청 파일 미존재");
        map.put("ERR_802", "비공개 변경 문서");
        map.put("ERR_803", "RMS 이관 문서");
        map.put("ERR_901", "GPKI 적용 오류");
        map.put("ERR_998", "응답 코드 미응답 에러");
        map.put("ERR_999", "알수 없는 에러");

        result = map.get(key);

        if (result == null) {
            result = map.get("ERR_999");
        }

        return result;
    }
}
