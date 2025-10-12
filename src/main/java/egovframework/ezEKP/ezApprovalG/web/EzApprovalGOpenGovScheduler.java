package egovframework.ezEKP.ezApprovalG.web;

import egovframework.ezEKP.ezApprovalG.service.EzApprovalGOpenGovService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezEmail.task.EzEmailScheduler;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.utl.fcc.service.CommonUtil;

import org.apache.commons.collections4.CollectionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.Properties;

@Component
public class EzApprovalGOpenGovScheduler {
    private static final Logger logger = LoggerFactory.getLogger(EzApprovalGOpenGovScheduler.class);

    @Autowired
    private Properties config;

    @Autowired
    private CommonUtil commonUtil;

    @Autowired
    EzApprovalGService ezApprovalGService;

    @Autowired
    EzEmailScheduler ezEmailScheduler;

    @Autowired
    EzApprovalGOpenGovService ezApprovalGOpenGovService;

//    @Scheduled(cron = "0 0/1 * * * *")
    @Scheduled(cron = "0 5 0 * * *")
    public void makeOpenGovCSV() throws Exception {
        logger.debug("makeOpenGovCSV started.");

        if (!config.getProperty("config.useOpenGov").equals("YES") || !ezEmailScheduler.preScheduler("ezapprovalg_makeOpenGovCSV")) {
            logger.debug("makeOpenGovCSV scheduler ended.");
            return;
        }

        List<OrganUserVO> list = ezApprovalGService.getTenantID();
        int tenantID = list.get(0).getTenantId();

        Path csvPath = Paths.get(config.getProperty("openGov_root"),"fileroot", Integer.toString(tenantID), "files", "openGovCsv" , "send");
        Path csvFilePath = csvPath.resolve("WMPUAA$CG174000001937$PIINFOLIST" + config.getProperty("config.companyNum") + commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyyMMddHHmm"),"235|+09:00", true) + ".csv");

        File dirFile = csvPath.toFile();

        if (!dirFile.exists()) {
            dirFile.mkdirs();
        }

        // 2023-05-12 이사라 : NullPointerException 시큐어코딩
        List<String> csvList = Optional.ofNullable(ezApprovalGOpenGovService.getOpenGovCsv()).orElse(Collections.emptyList());
        List<String> resendCSVList = Optional.ofNullable(ezApprovalGOpenGovService.getOpenGovResendCsv()).orElse(Collections.emptyList());

        //if (csvList == null && resendCSVList == null) {
        if (CollectionUtils.isEmpty(csvList) && CollectionUtils.isEmpty(resendCSVList)) {
            logger.debug("makeOpenGovCSV ended csv Size : 0");
            logger.debug("makeOpenGovCSV ended");

            return;
        }
        
        // CWE-404 보안 취약점 대응
        // 2023-05-12 이사라 : 위 에서 csvList, resendCSVList 대응하여 가독성을 위해 아래 코드 원복
        try (BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(csvFilePath.toFile()), "euc-kr"))) {
            //발송
            for (String csv : csvList) {
                bw.write(csv);
                bw.newLine();
            }

            //재발송
            for (String csv : resendCSVList) {
                bw.write(csv);
                bw.newLine();
            }

            String endLine = "END_TOT_COUNT |" + csvList.size();

            bw.write(endLine);
        }

//		어제 csv는 센드플래그 Y로 인서트해줌
//		센드플래그를 Y로 바꿔줌
        ezApprovalGOpenGovService.setOpenGovSendFlagToY();
        ezApprovalGOpenGovService.insertTodayGovSendDocHistory();

        logger.debug("makeOpenGovCSV ended");
    }
}
