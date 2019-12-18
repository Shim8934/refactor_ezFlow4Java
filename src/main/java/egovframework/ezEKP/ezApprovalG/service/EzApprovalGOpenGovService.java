package egovframework.ezEKP.ezApprovalG.service;

import kr.dogfoot.hwplib.object.HWPFile;

import java.util.List;

public interface EzApprovalGOpenGovService {
    String getOpenGovDocOpenFlag(String docId) throws Exception;

    String getOpenGovDocHref(String docID) throws Exception;

    String getOpenGovAttachHref(String docID, String sn) throws Exception;

    //완료처리
    void insertGovDocSend(String docId, String fileId) throws Exception;

    //Scheduler
    List<String> getOpenGovCsv() throws Exception;

    List<String> getOpenGovResendCsv() throws Exception;

    void setOpenGovSendFlagToY() throws Exception;

    void insertTodayGovSendDocHistory() throws Exception;

    //HWP
    void setHwpSealSignEmpty(HWPFile hwpFile) throws Exception;
}
